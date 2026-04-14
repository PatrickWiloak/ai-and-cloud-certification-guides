# Targets, Hosts, and Sessions

Targets define what users connect to. Hosts are the actual addressable endpoints. Sessions are the proxy-established connection lifecycle. Understanding this trio is essential.

## Host Catalogs

A host catalog is a container for hosts. Two types:

### Static Host Catalog (`hcst_`)

Hosts are manually declared and managed:

```
boundary host-catalogs create static -scope-id=p_... -name=datacenter
boundary hosts create static -host-catalog-id=hcst_... -address=10.0.1.10 -name=db-01
boundary host-sets create static -host-catalog-id=hcst_... -name=databases
boundary host-sets add-hosts -id=hsst_... -host=hst_...
```

Use when:
- Hosts are stable and change rarely
- You manage via Terraform or config
- Small number of endpoints

### Plugin (Dynamic) Host Catalog (`hcplg_`)

Hosts sync from a cloud provider API:

```
boundary host-catalogs create plugin \
  -scope-id=p_... \
  -plugin-name=aws \
  -name=prod-ec2 \
  -attr region=us-east-1 \
  -secret access_key_id=... \
  -secret secret_access_key=...

boundary host-sets create plugin \
  -host-catalog-id=hcplg_... \
  -name=web-tier \
  -attr filters="tag:Role=web"
```

Plugins:

- `aws`: filter EC2 instances by tag or filter expression
- `azure`: filter Azure VMs
- `gcp`: filter GCE instances

Hosts are refreshed on a schedule; as instances come and go, the host set updates automatically.

## Host Sets

A host set groups hosts within a catalog. Targets reference host sets, not hosts directly.

Why host sets?

- One target can round-robin across multiple hosts
- Dynamic plugins produce host sets with filter expressions
- Membership can be large and changeable

## Targets

Two target types:

### TCP Target (`ttcp_`)

Generic TCP proxy. Works for any protocol.

```
boundary targets create tcp \
  -scope-id=p_... \
  -default-port=5432 \
  -name=postgres-prod \
  -session-max-seconds=28800 \
  -session-connection-limit=-1 \
  -host-source-ids=hsst_...
```

Attributes:

- `default-port`: the port at the target to connect to
- `session-max-seconds`: max session duration (default 8h)
- `session-connection-limit`: max concurrent connections per session (-1 = unlimited)
- `host-source-ids`: host sets to draw endpoints from
- `worker-filter`: expression to select workers

### SSH Target (`tssh_`)

SSH-aware. Supports credential injection, session recording, and SSH-specific features.

```
boundary targets create ssh \
  -scope-id=p_... \
  -default-port=22 \
  -name=webservers \
  -host-source-ids=hsst_... \
  -enable-session-recording=true \
  -storage-bucket-id=sb_...
```

SSH-specific attributes:

- `enable-session-recording`: (Enterprise/HCP Plus) record all I/O
- `storage-bucket-id`: where to store recordings
- `injected-application-credential-source-ids`: credentials injected into SSH session

## Credentials on Targets

Two attachment types:

- **Brokered credentials:** passed to the client to use. Client sees them.
  - `-brokered-credential-source-ids=clvlt_...`
- **Injected credentials:** used by the worker during session establishment (SSH only). Client never sees them.
  - `-injected-application-credential-source-ids=clvlt_...`

Target types that support injection:

- SSH targets only

TCP targets support brokering only.

## Worker Filters

Route sessions to specific workers using a selector on worker tags:

```
-worker-filter='"us-east-1" in "/tags/region"'
```

Selector language is Boundary-specific: `"value" in "/path"` checks that the value is in the tagged list.

Use for:
- Data residency (only EU workers for EU targets)
- Latency optimization (closest region wins)
- Compliance (dedicated workers for PCI-scope targets)

## Session Authorization Flow

1. Client runs `boundary connect -target-id=ttcp_...`
2. Controller validates the client's token and evaluates role grants
3. If authorized, controller picks a host from the target's host sets
4. Controller picks an eligible worker based on target's worker filter
5. Controller issues a session token and session ID
6. Client connects to the worker's proxy port with the token
7. Worker validates token, dials the target host, proxies traffic
8. On any credential libraries, worker fetches credentials (and optionally injects)
9. When client disconnects or session expires, worker closes connections; controller marks session terminated

## Connection Commands

### Generic

```
boundary connect -target-id=ttcp_...
# prints local port, e.g. 127.0.0.1:54321
# user then connects with their own tool
```

This starts a local proxy. Use when Boundary doesn't have a protocol-specific helper.

### SSH

```
boundary connect ssh -target-id=tssh_...
```

Boundary handles the SSH connection, including:

- Setting up known_hosts to avoid prompts
- Injecting credentials (if configured)
- Forwarding stdin/stdout through the proxy

### HTTP

```
boundary connect http -target-id=ttcp_... -path=/
```

Opens a browser or returns a URL for HTTP-based targets.

### Postgres / MySQL / MSSQL

Specialized subcommands that launch the respective client:

```
boundary connect postgres -target-id=ttcp_... -dbname=mydb
boundary connect mysql -target-id=...
```

## Session Lifecycle States

- **pending:** authorized, waiting for worker connection
- **active:** worker established, data flowing
- **canceling:** cancel requested, graceful drain
- **terminated:** session ended

Transitions:

- `pending -> active`: worker accepts and connects to target
- `active -> canceling`: explicit cancel, timeout, or idle
- `canceling -> terminated`: all connections closed

## Managing Sessions

```
boundary sessions list                             # all sessions you can see
boundary sessions list -recursive -scope-id=global # org-wide
boundary sessions read -id=s_...                   # detail on one session
boundary sessions cancel -id=s_...                 # cancel a session
```

Admins with `list` and `cancel` grants on sessions can manage others'. Users typically get `list,read,cancel:self`.

## Connection Limits

`session-connection-limit` on a target caps concurrent connections within a single session. Useful for:

- Preventing scp from monopolizing an SSH session
- Rate limiting connection attempts through a single session

Default is often -1 (unlimited). Set a sensible cap for high-throughput targets.

## Session Duration

`session-max-seconds` caps total session length. Default 8 hours (28800). For long-running operations, adjust; for tight control, shorten.

## Address Sources for Targets

Targets can also have `address` attribute directly (no host sets), for simple one-off targets:

```
boundary targets create ssh \
  -scope-id=p_... \
  -name=one-off \
  -default-port=22 \
  -address=10.0.0.50
```

Useful for quick setup but loses the dynamic-host-set flexibility.

## Alias Resolution

Boundary supports target aliases: a DNS-style name that resolves to a target. Users can `boundary connect -target=prod.db.example.com` without knowing the `ttcp_` ID. Aliases live in global or per-scope namespaces.

## Tagging Targets

Targets do not have native tags in core metadata, but filter labels and worker filters can be used to create logical groupings. Organize via naming convention and scope hierarchy primarily.

## Listing Targets

```
boundary targets list -scope-id=p_...                # in a project
boundary targets list -scope-id=global -recursive    # everywhere
```

Users only see targets they can read (list grant includes).

## Best Practices

- Use host sets (not hard-coded `address`) for resilience and dynamic membership
- Group related targets into a project; use role grants at project level
- Keep `session-max-seconds` short for sensitive targets (DB, admin hosts)
- Use SSH targets with injection when users don't need direct credential access
- Use worker filters for segmented networks

## Exam-Ready Checklist

- [ ] Can explain host catalog vs host set vs host
- [ ] Know static vs plugin catalog tradeoffs
- [ ] Can author a TCP target and an SSH target
- [ ] Understand credential brokering vs injection and which targets support each
- [ ] Know session lifecycle states
- [ ] Can use worker filters
- [ ] Know the main `boundary connect` subcommands
