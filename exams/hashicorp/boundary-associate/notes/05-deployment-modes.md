# Deployment Modes, Clusters, and Workers

Boundary's deployment architecture splits control from data. Controllers manage configuration and authorization; workers proxy session traffic. Understanding how to deploy each and how they communicate is a significant exam domain.

## Deployment Options

### HCP Boundary

HashiCorp-managed control plane. You run workers only.

Benefits:
- No Postgres, KMS, or controller HA to manage
- Automatic upgrades
- Built-in UI and observability
- Fast onboarding

Tradeoffs:
- SaaS; data plane is yours but control plane is HashiCorp's
- Requires internet connectivity from workers to HCP
- Not viable for air-gapped deployments

### Self-Managed Community Edition

Free. You run everything. Limitations:
- No session recording
- No SAML
- No multi-hop worker chaining (restricted)

### Self-Managed Enterprise

Licensed. Full feature set. Required for:
- Session recording
- SAML auth
- Multi-hop workers at scale
- Advanced observability

## Controllers

### Single Controller

For labs or non-production.

```hcl
# controller.hcl
disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:9200"
  purpose = "api"
  tls_cert_file = "/etc/boundary/api.crt"
  tls_key_file  = "/etc/boundary/api.key"
}

listener "tcp" {
  address = "0.0.0.0:9201"
  purpose = "cluster"
  tls_cert_file = "/etc/boundary/cluster.crt"
  tls_key_file  = "/etc/boundary/cluster.key"
}

listener "tcp" {
  address = "127.0.0.1:9203"
  purpose = "ops"
  tls_disable = true
}

controller {
  name = "controller-01"
  database {
    url = "postgresql://boundary:pass@db.example.com/boundary?sslmode=require"
  }
}

kms "awskms" {
  purpose = "root"
  region  = "us-east-1"
  kms_key_id = "alias/boundary-root"
}

kms "awskms" {
  purpose = "worker-auth"
  region  = "us-east-1"
  kms_key_id = "alias/boundary-worker-auth"
}

kms "awskms" {
  purpose = "recovery"
  region  = "us-east-1"
  kms_key_id = "alias/boundary-recovery"
}
```

Initialize: `boundary database init -config=controller.hcl`.

### HA Controllers

Run 3+ controllers behind a load balancer. All use the same Postgres and same KMS keys. Load balancer distributes API traffic; cluster listener uses all controllers equally.

```
Client ->  LB (ALB/NLB) -> Controller 1|2|3
                              │
                              ▼
                          Postgres (Multi-AZ)
```

Workers keep connections to all controllers and reconnect on failure.

### Database Requirements

- PostgreSQL 13 or newer
- TLS strongly recommended
- Regular backups
- Parameters: default values work for small installs; tune `max_connections` for busy clusters

### Database Migrations

Upgrades require `boundary database migrate` to run schema updates:

```
boundary database migrate -config=controller.hcl
```

Run once per upgrade, typically from CI. Controllers refuse to start if schema is ahead or behind.

## Workers

### Worker Configuration

```hcl
# worker.hcl
listener "tcp" {
  purpose = "proxy"
  address = "0.0.0.0:9202"
}

worker {
  name = "worker-01"
  description = "us-east-1 egress worker"
  public_addr = "worker1.example.com:9202"
  initial_upstreams = [
    "controller1.example.com:9201",
    "controller2.example.com:9201",
  ]
  tags {
    region = ["us-east-1"]
    type   = ["egress"]
  }
  auth_storage_path = "/var/lib/boundary/worker"
}
```

`public_addr` is how clients reach this worker (or for multi-hop, how downstream workers reach it).

### Worker Authentication

**KMS-based auth (deprecated):** worker and controller share a KMS key. The worker demonstrates KMS access to authenticate. Requires the `worker-auth` purpose KMS on both.

**PKI-based auth (modern, preferred):** worker generates a keypair, registers with a controller via a one-time activation token or CLI-driven registration. The controller issues a certificate.

```
# Generate activation token (on controller side)
boundary workers create controller-led -scope-id=global -name=worker-01

# Or worker-led: start worker, get registration request, approve on controller
boundary workers create worker-led -worker-generated-auth-token=<token>
```

### Worker-Led vs Controller-Led Registration

- **Worker-led:** worker generates a token on first startup; admin approves on controller side
- **Controller-led:** controller pre-generates a token; worker starts with it

Worker-led is typical for PKI. Controller-led is common for automation pipelines.

## Multi-Hop Worker Chains

In segmented networks, workers can form chains:

```
Client -> Ingress Worker (DMZ, public) -> Egress Worker (private) -> Target
```

Downstream workers upstream to another worker instead of a controller directly. Used for:

- On-prem with no internet access
- Segmented cloud networks (target subnets without internet egress)
- Meeting strict firewall policies

Configuration:

```hcl
worker {
  initial_upstreams = ["ingress-worker.example.com:9202"]
  # ...
}
```

The upstream must be another worker (not a controller) and must be registered to enable downstream workers.

**Enterprise feature:** multi-hop at scale requires Enterprise or HCP Plus.

## Worker Tags

Tags let you annotate workers with arbitrary labels:

```hcl
worker {
  tags {
    region = ["us-east-1", "us-east"]
    team   = ["platform"]
    env    = ["production"]
    recording = ["true"]
  }
}
```

Tag values are always lists of strings.

## Worker Filters on Targets

Targets specify which workers can serve sessions using a filter expression:

```
"us-east-1" in "/tags/region"
"true" in "/tags/recording" and "production" in "/tags/env"
```

Boundary evaluates the filter against each eligible worker and picks one that matches.

Filter syntax:

- `"<value>" in "/tags/<key>"`: check list membership
- `/name == "worker-01"`: match worker name
- Boolean combinators: `and`, `or`, `not`

## Session Routing Logic

For each session authorization:

1. Boundary collects workers upstream-connected to the cluster
2. Applies the target's worker filter
3. Among matches, applies load balancing / connection affinity
4. Returns chosen worker's address to the client

Clients connect directly to the selected worker's proxy port.

## KMS Providers

### AWS KMS (`awskms`)

```hcl
kms "awskms" {
  purpose = "root"
  region  = "us-east-1"
  kms_key_id = "alias/boundary-root"
  endpoint = "https://kms.us-east-1.amazonaws.com"
}
```

Auth: IAM role (instance profile) or env-var access keys.

### Azure Key Vault (`azurekeyvault`)

```hcl
kms "azurekeyvault" {
  purpose     = "root"
  tenant_id   = "..."
  client_id   = "..."
  client_secret = "..."
  vault_name  = "boundary-vault"
  key_name    = "boundary-root"
}
```

### GCP KMS (`gcpckms`)

```hcl
kms "gcpckms" {
  purpose = "root"
  project = "my-project"
  region  = "global"
  key_ring = "boundary"
  crypto_key = "root"
}
```

### Vault Transit (`transit`)

Use Vault's Transit engine as Boundary's KMS.

```hcl
kms "transit" {
  purpose  = "root"
  address  = "https://vault.example.com:8200"
  token    = "s.abc"
  key_name = "boundary-root"
  mount_path = "transit/"
}
```

### AEAD (dev only)

```hcl
kms "aead" {
  purpose = "root"
  aead_type = "aes-gcm"
  key = "BASE64..."
  key_id = "global_root"
}
```

Not secure for production; key is in config file.

## Recovery Access

Break-glass admin access bypasses the database entirely. Requires `recovery` KMS key.

```
# Client side
export BOUNDARY_RECOVERY_CONFIG=/path/to/recovery.hcl
# recovery.hcl contains the kms "awskms" block with purpose=recovery

unset BOUNDARY_TOKEN
boundary roles list -scope-id=global
```

Use to:

- Reset broken auth methods
- Recover from role misconfigurations that locked you out
- Emergency admin access during IdP outages

Audit every use. Rotate the KMS key permissions as tightly as possible.

## Run-Time Topology Example

Small production:

```
2x controllers behind ALB
1x RDS Postgres (Multi-AZ)
AWS KMS keys (root, worker-auth, recovery)
4x workers in each of 3 regions (us-east-1, us-west-2, eu-west-1)
```

Each worker runs on a small VM (2 vCPU, 4GB RAM). Scales horizontally based on concurrent sessions.

## Kubernetes Deployment

Boundary provides Helm charts for controllers and workers:

```
helm install boundary-controller hashicorp/boundary-controller -f values.yaml
helm install boundary-worker hashicorp/boundary-worker -f worker-values.yaml
```

Useful for cloud-native deployments.

## Observability and Ops Endpoints

The `ops` listener exposes:

- `/health`: readiness check
- `/metrics`: Prometheus scrape

```hcl
listener "tcp" {
  purpose = "ops"
  address = "0.0.0.0:9203"
  tls_disable = true
}
```

Scrape with Prometheus; alert on session count, failed auths, worker disconnects.

## Upgrade Procedure

1. Back up Postgres
2. Upgrade workers in rolling fashion (workers are stateless)
3. Run `boundary database migrate`
4. Upgrade one controller, verify, then rest

Workers are backward-compatible with controllers one minor version ahead; upgrade workers last or equally.

## Exam-Ready Checklist

- [ ] Can author a minimal controller HCL
- [ ] Can author a minimal worker HCL
- [ ] Know KMS purposes: root, worker-auth, recovery
- [ ] Understand PKI vs KMS worker authentication
- [ ] Can describe multi-hop worker chains
- [ ] Can write worker filters using tag syntax
- [ ] Know HCP Boundary vs self-managed CE vs Enterprise differences
- [ ] Understand the recovery auth mechanism
