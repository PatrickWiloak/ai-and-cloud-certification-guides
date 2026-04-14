# Boundary Associate - Fact Sheet

## Exam Logistics

| Attribute | Value |
|-----------|-------|
| Exam name | HashiCorp Certified: Boundary Associate |
| Delivery | Online proctored (PSI), multiple-choice and multi-select |
| Duration | 60 minutes |
| Number of questions | 57 |
| Passing score | ~70% (HashiCorp reports pass or fail) |
| Cost | $70.50 USD |
| Language | English |
| Validity | 2 years |
| Recommended experience | 3 to 6 months with Boundary, SSH/identity fundamentals |

## Domains and Weights (estimated)

### Domain 1: Boundary Architecture and Core Concepts (~20%)

- Controllers, workers, clients
- Scopes (global, org, project)
- Resources: auth methods, accounts, users, groups, roles, hosts, host sets, host catalogs, targets, credentials, credential stores, sessions
- Boundary Enterprise vs Community Edition vs HCP Boundary
- Control plane vs data plane separation
- Database (Postgres) and KMS requirements

### Domain 2: Targets, Sessions, and Host Management (~20%)

- Host catalogs (static, dynamic: AWS, Azure)
- Host sets (membership grouping)
- Hosts
- Targets (TCP and SSH types)
- Session lifecycle: pending, active, canceling, terminated
- Session connection limits (max connections per session)
- Session duration and expiration
- Worker filters (route sessions to specific workers)

### Domain 3: Credential Brokering and Vault (~15%)

- Credential stores: static and Vault
- Credential libraries (Vault-backed)
- Credential brokering vs injection
- SSH credentials (username/password, username/keypair)
- Key-value credentials
- Vault integration setup (token, policy, namespace)
- Dynamic credentials lifecycle

### Domain 4: Authentication and RBAC (~20%)

- Auth methods: password, OIDC, LDAP
- Primary vs non-primary auth method per scope
- Accounts, users, groups
- Managed groups (OIDC claims-based)
- Roles and grant strings
- Grant scope (this, children, descendants)
- Grant format: `ids=<ids>;type=<type>;actions=<actions>`
- Default role: `authenticated`, `anonymous`

### Domain 5: Deployment Modes and Workers (~15%)

- Self-managed vs HCP Boundary
- Controllers in HA mode
- Workers: upstream and downstream (multi-hop)
- Ingress vs egress workers
- Worker registration: controller-led or worker-led (PKI)
- Worker tags for filtering
- KMS configuration (AWS KMS, Azure Key Vault, GCP KMS, Vault Transit, shamir)

### Domain 6: Session Recording, Audit, Ops (~10%)

- Session recording (Enterprise / HCP Plus)
- Storage buckets for recordings (S3 primarily)
- BSR (Boundary Session Recording) format
- Replaying sessions in Boundary Desktop
- Events and audit logs
- Metrics (Prometheus)
- Health endpoint

## Key CLI Commands

```
boundary dev                             # start all components for local test
boundary server -config=controller.hcl   # run a controller
boundary server -config=worker.hcl       # run a worker
boundary authenticate password -auth-method-id=... -login-name=...
boundary authenticate oidc -auth-method-id=...
boundary targets list -scope-id=p_...
boundary targets authorize-session -id=ttcp_...
boundary connect -target-id=ttcp_...           # start a session via local proxy
boundary connect ssh -target-id=ttcp_...       # ssh with credential brokering
boundary connect http -target-id=...
boundary sessions list
boundary sessions cancel -id=s_...
boundary roles add-grants -id=r_... -grant='ids=*;type=session;actions=list,read,cancel:self'
boundary database init -config=controller.hcl
boundary database migrate -config=controller.hcl
boundary config autocomplete install
```

## Resource ID Prefixes

| Prefix | Resource |
|--------|----------|
| `global` | Global scope |
| `o_` | Org scope |
| `p_` | Project scope |
| `u_` | User |
| `g_` | Group |
| `mg_` | Managed group |
| `r_` | Role |
| `amp_` | Password auth method |
| `amoidc_` | OIDC auth method |
| `amldap_` | LDAP auth method |
| `acctpw_`, `acctoidc_`, `acctldap_` | Accounts by type |
| `hcst_`, `hcplg_` | Host catalog (static or plugin) |
| `hsst_`, `hsplg_` | Host set |
| `hst_`, `hplg_` | Host |
| `ttcp_` | TCP target |
| `tssh_` | SSH target |
| `csst_`, `csvlt_` | Credential store (static or Vault) |
| `credup_`, `credspk_`, `credjson_` | Static credentials |
| `clvlt_`, `clvsclt_` | Credential library (Vault generic, Vault SSH cert) |
| `s_` | Session |
| `w_` | Worker |
| `sb_` | Storage bucket |

Knowing these prefixes helps when reading exam questions that show IDs.

## Minimal Scope Hierarchy

```
global
├── o_core (org)
│   ├── p_networking (project)
│   │   ├── targets, hosts, credentials
│   │   └── roles scoped to this project
│   └── p_data-platform (project)
└── o_security (org)
    └── p_audit (project)
```

Scopes form a three-level hierarchy. Resources live in scopes. Roles grant permissions, scoped to `this`, `children`, or `descendants`.

## Grant String Syntax

```
ids=<id1>,<id2>;type=<resource-type>;actions=<action1>,<action2>;output_fields=<fields>
```

Examples:

- `ids=*;type=target;actions=read,list,authorize-session`
- `ids=ttcp_1234;type=target;actions=authorize-session`
- `type=*;actions=*` (wildcard, use sparingly)
- `ids=*;type=session;actions=list,read,cancel:self`

The `:self` qualifier restricts to sessions the user created.

## Auth Methods Summary

| Method | Type | Notes |
|--------|------|-------|
| Password | amp_ | Built-in, for initial setup or break-glass |
| OIDC | amoidc_ | Connects to Okta, Auth0, Azure AD, Google |
| LDAP | amldap_ | Corporate AD or LDAP |

A scope has one primary auth method per type. The primary is used when users don't specify.

## Credential Flows

### Credential Brokering

Boundary retrieves credentials and passes them to the client, which uses them to auth to the target. Client sees the credential.

### Credential Injection

Boundary injects the credential directly into the session transparent to the client (SSH only). Client never sees the credential. More secure.

Enable via target configuration: `credential_injection` vs `credential_brokering`.

## Session Lifecycle

1. **Pending:** client requested, worker assignment in progress
2. **Active:** proxy established, traffic flowing
3. **Canceling:** cancel requested, connections closing
4. **Terminated:** fully closed

Sessions expire based on:

- Max duration (default 8 hours)
- Max connections reached
- Explicit cancel
- Worker disconnect
- Credential expiration

## Worker Roles and Multi-Hop

- **Ingress workers:** accept connections from clients. Run in DMZ or public subnet.
- **Egress workers:** connect to targets. Run in private subnet near targets.
- **Multi-hop:** chain ingress and egress with upstream / downstream workers. Useful for reaching isolated networks.

Workers have tags (`region = ["us-east-1"]`); targets have worker filters that select by tag.

## Deployment Modes

- **HCP Boundary:** HashiCorp-managed controllers in HCP; you run workers
- **Self-managed (Community or Enterprise):** you run controllers, workers, Postgres

HCP Boundary is the fastest to get started. Self-managed gives you full control and is required for air-gapped deployments.

## Database and KMS

- **Database:** PostgreSQL (13+)
- **KMS purposes:**
  - `root`: root key wrapping
  - `worker-auth`: worker authentication
  - `recovery`: break-glass admin
- **KMS providers:** AWS KMS, Azure Key Vault, GCP KMS, Vault Transit, AEAD (dev only)

## Boundary Desktop App

Client GUI that wraps the CLI. Users log in, browse targets, connect with one click. The Desktop app handles `boundary connect` under the hood.

## Session Recording (Enterprise / HCP Plus)

Capture SSH session I/O to S3. Stored in BSR format. Replay via Desktop or CLI. Requires:

- Enterprise/Plus license
- Storage bucket resource pointed at S3
- Worker with recording capability
- Target configured with `enable_session_recording = true`

## HCL Configuration Structure (Controller)

```hcl
disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:9200"
  purpose = "api"
  tls_disable = false
  tls_cert_file = "/path/cert.pem"
  tls_key_file  = "/path/key.pem"
}

listener "tcp" {
  address = "0.0.0.0:9201"
  purpose = "cluster"
}

controller {
  name = "controller-1"
  description = "Primary controller"
  database {
    url = "postgresql://boundary@db:5432/boundary?sslmode=require"
  }
}

kms "awskms" {
  purpose = "root"
  region = "us-east-1"
  kms_key_id = "alias/boundary-root"
}

kms "awskms" {
  purpose = "worker-auth"
  region = "us-east-1"
  kms_key_id = "alias/boundary-worker-auth"
}

kms "awskms" {
  purpose = "recovery"
  region = "us-east-1"
  kms_key_id = "alias/boundary-recovery"
}
```

## HCL Configuration Structure (Worker)

```hcl
listener "tcp" {
  purpose = "proxy"
  address = "0.0.0.0:9202"
}

worker {
  name = "worker-1"
  public_addr = "worker1.example.com"
  initial_upstreams = ["controller1.example.com:9201"]
  tags {
    region = ["us-east-1"]
    type   = ["egress"]
  }
}

kms "awskms" {
  purpose = "worker-auth"
  region = "us-east-1"
  kms_key_id = "alias/boundary-worker-auth"
}
```

## Exam Cheatsheet: First-Principles Rules

- Every resource lives in exactly one scope.
- Grants are additive: a user gets the union of their roles' grants.
- Roles are in a specific scope; grant_scope controls where the grants apply.
- `:self` qualifier is a powerful way to give users limited session management.
- Primary auth methods let users authenticate without specifying an ID.
- Dynamic host catalogs sync from cloud APIs; static are managed by hand.
- Workers cannot be shared across controllers directly; they upstream to one control cluster.
- HCP Boundary controllers are managed; you still run workers in your network.
