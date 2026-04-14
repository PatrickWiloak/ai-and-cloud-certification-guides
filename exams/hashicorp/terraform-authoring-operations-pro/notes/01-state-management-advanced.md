# Advanced State Management

State is the single source of truth that maps Terraform resources to real-world infrastructure. On the Professional exam, you will be asked to perform state surgery, migrate between backends, and recover from failure modes. Associate-level knowledge (what state is, why it exists) is assumed.

## The State File Contract

Terraform state is a JSON document. Each resource has:

- `address`: `aws_instance.web["prod"]`
- `type` and `name`
- `provider`: fully-qualified name (e.g., `registry.terraform.io/hashicorp/aws`)
- `instances`: one per for_each/count key
- `attributes`: the current values of every attribute
- `dependencies`: upstream resource addresses
- `schema_version`: for provider-side migrations

Never hand-edit a state file in production. Use `terraform state` subcommands or `pull`/`push` with a code review.

## Remote Backends Comparison

| Backend | State locking | Encryption | Use when |
|---------|---------------|------------|----------|
| `s3` | via DynamoDB table (or native with `use_lockfile = true` in newer AWS provider) | SSE-S3, SSE-KMS | AWS shops, maximum flexibility |
| `gcs` | native | CMEK | GCP shops |
| `azurerm` | via blob lease | SSE | Azure shops |
| `remote` / `cloud` | native (HCP Terraform) | managed | You want HCP Terraform features |
| `consul` | native | at rest via Consul | On-prem HashiCorp stacks |
| `http` | optional | depends on server | Custom backends (GitLab) |
| `local` | file-based | none | Development only |

`remote` is legacy syntax. Modern HCP Terraform configs use the `cloud {}` block:

```hcl
terraform {
  cloud {
    organization = "my-org"
    workspaces { name = "prod-network" }
  }
}
```

## State Locking Mechanics

- S3 backend historically requires a DynamoDB table with partition key `LockID`. Newer S3 backend supports native locking via `use_lockfile = true`.
- A lock is acquired at plan and apply time.
- If a run crashes without releasing, the lock persists. Use `terraform force-unlock LOCK_ID` to clear, but only after confirming no operation is running.
- `TF_LOG=DEBUG` will show lock acquisition timing.

## State Surgery Commands

```
terraform state list                    # show all addresses
terraform state show aws_instance.web   # show attributes for one
terraform state mv SRC DEST             # rename or move within state
terraform state rm ADDRESS              # forget resource (does NOT destroy)
terraform state pull > state.json       # download current state
terraform state push state.json         # upload edited state (dangerous)
terraform state replace-provider OLD NEW # swap provider source (e.g., after fork)
```

Rule: `state rm` does not destroy. It deorphans. The resource still exists in the cloud. Always pair with either `import` (to re-adopt) or manual cleanup.

## Refactoring with moved Blocks

`moved` blocks are the preferred way to rename or restructure resources in HCL without state surgery.

```hcl
moved {
  from = aws_instance.web
  to   = aws_instance.web_server
}
```

Terraform reads these during plan and adjusts state automatically during apply. Advantages over `state mv`:

- Reviewable in PR
- Idempotent and replayable
- Works in HCP Terraform without CLI access
- Documents intent

Once apply succeeds, the `moved` block can stay (safe, has no effect on subsequent runs) or be removed in a cleanup PR.

## Removing Resources with removed Blocks (Terraform 1.7+)

```hcl
removed {
  from = aws_instance.deprecated

  lifecycle {
    destroy = false
  }
}
```

With `destroy = false`, the resource is forgotten from state but not destroyed in the cloud. Equivalent to `state rm` but declarative. With `destroy = true`, it is destroyed. Use this when decommissioning a module cleanly.

## Import Blocks vs terraform import CLI

CLI (legacy, still works):

```
terraform import aws_vpc.prod vpc-0abc123
```

Block (Terraform 1.5+, preferred):

```hcl
import {
  to = aws_vpc.prod
  id = "vpc-0abc123"
}
```

Block advantages:

- Declarative and reviewable
- Supports `terraform plan -generate-config-out=generated.tf` to scaffold HCL
- Works in HCP Terraform workflows without CLI

When importing many resources (bulk onboarding), the block form scales far better.

## Migrating Between Backends

```
# Before: local backend
terraform init  # local state exists

# Edit backend block to S3
# Then:
terraform init -migrate-state

# Terraform prompts: "Copy existing state to S3?"  Yes.
```

Gotchas:

- State version must match. If migrating to HCP Terraform, run on a CLI version at or above the workspace's Terraform version.
- Lock the old backend manually if possible during migration.
- Back up the state file before migration: `terraform state pull > backup.tfstate`.
- Use `-reconfigure` to skip migration and start fresh (destroys the state link).

## Drift Reconciliation with refresh-only

`terraform plan -refresh-only` compares state to the cloud without planning any changes. It reports drift without generating diff actions. Ideal for:

- Audit: detect someone changed a tag via console
- Safe reconciliation before a real plan
- HCP Terraform health assessments use this internally

`terraform apply -refresh-only` commits refreshed attributes to state without changing infrastructure. Use with caution: if the drift reflects unauthorized changes, you are legitimizing them in state.

## Splitting State

When a monolithic workspace grows unwieldy, split:

1. `terraform state pull > combined.tfstate`
2. `cp combined.tfstate new.tfstate`
3. `terraform state mv -state=combined.tfstate -state-out=new.tfstate aws_vpc.a aws_vpc.a`
4. Repeat for each resource that belongs in the new workspace
5. `terraform state push new.tfstate` into the new backend
6. `terraform state rm aws_vpc.a` from the old backend
7. Plan both workspaces. Both should report zero changes.

## Secrets in State

State contains every attribute, including sensitive ones (RDS passwords, private keys, Vault tokens). Treat state files as secrets:

- Encrypt at rest (SSE-KMS on S3, CMEK on GCS)
- Restrict IAM/ACLs tightly
- Never commit state to git
- Avoid `terraform output` of sensitive attributes without `sensitive = true` markers

Terraform 1.10+ introduces **ephemeral resources** and **write-only attributes**, which do not persist in state. Use these for any secret that does not need to be readable after creation.

## The terraform_remote_state Data Source

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tfstate-prod"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Usage
resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
}
```

Alternative: publish a module from `network` and consume it. Remote state is tightly coupled (any state-layout change breaks consumers); published outputs via module are a cleaner interface.

## When Not to Touch State

- During an active apply
- When you do not have a recent backup
- When you do not understand the blast radius
- As a substitute for a proper HCL refactor (prefer `moved` / `import` blocks)

## Exam-Ready Checklist

- [ ] Can migrate state from local to S3 and back
- [ ] Can `state mv`, `state rm`, and `import` fluently
- [ ] Can author `moved`, `removed`, and `import` blocks
- [ ] Can recover from stuck locks safely
- [ ] Can split a monolithic workspace
- [ ] Can identify sensitive attributes in state and mitigate
