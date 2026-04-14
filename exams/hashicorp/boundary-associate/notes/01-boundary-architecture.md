# Boundary Architecture

Boundary is HashiCorp's identity-aware secure remote access platform. It replaces bastion hosts, VPN-based lateral access, and shared SSH keys with a proxy-based model where every session is authenticated, authorized, and proxied through purpose-built workers.

## Core Components

### Controllers

The Boundary control plane. Responsible for:

- User authentication (via auth methods)
- Authorization decisions (role grants)
- Storing configuration (scopes, targets, credentials, roles)
- Issuing session tokens to clients
- Coordinating workers

Controllers expose two listeners:

- **API (default port 9200):** HTTPS API for CLI, Desktop, Terraform provider
- **Cluster (default port 9201):** gRPC for worker-controller communication

For HA, run multiple controllers behind a load balancer, all connected to the same PostgreSQL database.

### Workers

The Boundary data plane. Responsible for:

- Accepting client proxy connections (ingress)
- Establishing outbound connections to targets (egress)
- Brokering or injecting credentials during sessions
- Streaming session data (and optionally recording it)

Workers expose:

- **Proxy (default port 9202):** TCP listener for client connections

Workers do not store state; they authenticate to controllers and pull session authorization data as needed.

### Clients

- **CLI:** `boundary` command
- **Desktop app:** macOS, Windows, Linux GUI
- **Terraform provider:** configuration as code
- **API:** REST (internally JSON-over-HTTP)

## HCP Boundary vs Self-Managed

**HCP Boundary:**
- HashiCorp-hosted controllers
- You deploy workers into your networks
- Managed Postgres
- Built-in observability
- Fastest to get started

**Self-Managed:**
- You run controllers, workers, database
- Full control, works air-gapped
- Community Edition is free; Enterprise adds session recording, SAML, multi-tenant

## Scopes

Boundary organizes everything into a three-level hierarchy:

```
global
├── org (created in global)
│   └── project (created in org)
```

- **global scope:** top-level; holds orgs and global-level auth methods, roles, users
- **org scope:** business unit or team; holds project scopes, auth methods, roles
- **project scope:** contains application resources: targets, hosts, credentials, sessions

Resources live in exactly one scope. The scope determines the blast radius of grants.

## Identity Resources

- **User (`u_`):** an identity in Boundary. A human or service.
- **Group (`g_`):** a static collection of users.
- **Managed Group (`mg_`):** dynamic membership based on auth claims (OIDC, LDAP).
- **Account (`acctXX_`):** a specific auth method's identity for a user. A user can have multiple accounts (one per auth method).

Users can belong to groups; groups (and managed groups) can be granted roles.

## Auth Resources

- **Auth Method (`amXX_`):** configures how users authenticate. Password, OIDC, LDAP.
- **Primary Auth Method:** a flag per auth method per scope; up to one per type. Used when users login without specifying the method ID.

## Authorization Resources

- **Role (`r_`):** a set of grants, attached to users/groups/managed groups.
- **Grant:** a single permission string.
- **Grant Scope:** where the grants apply. Three values:
  - `this` (default): grants apply in the role's own scope
  - `children`: grants apply in direct child scopes (org role granting into projects)
  - `descendants`: grants apply in all descendant scopes (global role granting everywhere)

## Target Resources

- **Target (`ttcp_` or `tssh_`):** a resource users connect to. Defines port, worker filter, credential associations, session limits.
- **Host Catalog (`hcst_`, `hcplg_`):** container for hosts. Static or plugin-backed.
- **Host Set (`hsst_`, `hsplg_`):** a grouping of hosts within a catalog, referenced by targets.
- **Host (`hst_`, `hplg_`):** an actual endpoint (IP or DNS, port).

A target references one or more host sets. When a session is authorized, Boundary picks a host from the host set to connect to.

## Credential Resources

- **Credential Store (`csst_`, `csvlt_`):** static store or Vault-backed.
- **Credential Library (`clvlt_`, `clvsclt_`):** for Vault stores, defines what credentials to fetch (Vault path, SSH signing role).
- **Credential (`credXX_`):** static credentials (username/password, SSH key, JSON blob).

Credentials are attached to targets as either brokered or injected.

## Session Lifecycle

```
  authorize-session
         │
         ▼
   ┌──pending──┐
   │           │  worker assigned
   ▼           ▼
 cancel   ┌─active──┐
           │        │  session cancel, timeout, or idle
           ▼        ▼
       canceling   canceling
           │        │
           ▼        ▼
       terminated
```

States:

- **pending:** authorization granted, worker assignment in progress
- **active:** worker established, traffic flowing
- **canceling:** client or admin canceled; connections draining
- **terminated:** session ended

Sessions carry a bearer token. Workers verify the token with controllers before allowing traffic.

## Database and KMS

**Database:** PostgreSQL 13+. Stores all state except transient session data (which goes through workers).

**KMS (Key Management Service):** Wraps Boundary's root key and other sensitive data. Supported providers:

- AWS KMS (`awskms`)
- Azure Key Vault (`azurekeyvault`)
- GCP KMS (`gcpckms`)
- Vault Transit (`transit`)
- AEAD (dev only, insecure)

**KMS purposes** (you configure one key per purpose):

- **root:** wraps the derived keys used across Boundary internals
- **worker-auth:** authenticates workers to controllers (for KMS-based worker auth)
- **recovery:** enables break-glass admin access when normal auth is unavailable

## Worker Authentication

Two methods:

1. **KMS-based:** worker and controller share access to a KMS key (`worker-auth` purpose). The worker authenticates by demonstrating KMS access.
2. **PKI-based (worker-led):** worker generates a key, registers with the controller via a one-time activation token, receives a certificate. Subsequent reconnects use the certificate.

PKI is the more modern approach and is required for multi-hop worker chains.

## Multi-Hop Workers

In environments where workers must reach isolated networks, you can chain workers:

```
Client -> Ingress Worker (DMZ) -> Egress Worker (private subnet) -> Target
```

The ingress worker authenticates to controllers. Egress workers authenticate to ingress workers via PKI, forming a chain. Useful for on-prem or segmented cloud networks.

## Worker Tags and Filters

Workers can carry arbitrary tags:

```hcl
worker {
  tags {
    region = ["us-east-1"]
    type   = ["egress"]
    team   = ["platform"]
  }
}
```

Targets have worker filters (selector expressions):

```
"region" in "/tags/region"
```

Boundary only assigns workers matching the filter to that target's sessions. Used to enforce data residency, latency, or operational boundaries.

## Events and Audit

Boundary emits structured events:

- **audit:** authentication, authorization decisions
- **observation:** session lifecycle
- **error:** failures
- **system:** startup, shutdown

Sinks:

- **stderr:** default
- **file:** rotating logs
- **syslog:** for central collection
- **AWS CloudWatch, Datadog:** via filebeat or custom sinks

Configure in the `events` block of the controller or worker HCL.

## Observability

Boundary exposes a Prometheus `/metrics` endpoint on a dedicated listener:

```hcl
listener "tcp" {
  purpose = "ops"
  address = "0.0.0.0:9203"
  tls_disable = true
}
```

Key metrics: session count, database query durations, worker health.

Health endpoint: `GET /health` on the ops listener.

## Typical Deployment Topology

```
                ┌──────────────┐
                │  OIDC IdP    │
                └──────┬───────┘
                       │
                       ▼
┌────────────┐    ┌────────────┐    ┌─────────┐
│  User CLI  │───▶│ Controller │───▶│Postgres │
└─────┬──────┘    │  (HA set)  │    └─────────┘
      │           └──────┬─────┘
      │                  │ worker auth
      │                  ▼
      │            ┌──────────┐
      └───────────▶│  Worker  │──────▶ Target (SSH, DB, HTTP)
       session     └──────────┘         │
                         │              │
                         ▼              │
                    ┌─────────┐         │
                    │  Vault  │◀────────┘ credential brokering
                    └─────────┘
```

## Security Model Summary

- Identity is first-class; every session is tied to an authenticated user or service.
- Fine-grained authorization via scoped roles and specific grants.
- Credentials can be brokered (given to client) or injected (never seen by client).
- All session traffic flows through workers, enabling recording, inspection, and policy enforcement.
- KMS-based root-of-trust with multiple key purposes.
- Break-glass via recovery KMS.

## Exam-Ready Checklist

- [ ] Can describe controllers, workers, clients and their roles
- [ ] Know the three-scope hierarchy and what lives where
- [ ] Know all major resource ID prefixes
- [ ] Understand KMS purposes
- [ ] Can describe session lifecycle states
- [ ] Understand HCP Boundary vs self-managed tradeoffs
- [ ] Know worker authentication options (KMS, PKI) and multi-hop
