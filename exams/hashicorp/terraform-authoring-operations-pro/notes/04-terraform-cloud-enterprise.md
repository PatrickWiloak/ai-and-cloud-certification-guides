# HCP Terraform and Terraform Enterprise

HCP Terraform (formerly Terraform Cloud) and Terraform Enterprise (self-hosted) provide the managed execution, state, RBAC, and governance layer. The Professional exam dedicates about 15% to operating these platforms.

## HCP Terraform vs Terraform Enterprise

| Feature | HCP Terraform | Terraform Enterprise |
|---------|---------------|----------------------|
| Hosting | SaaS | Self-hosted (Replicated or FDO) |
| Support | Free, Standard, Plus tiers | Contract required |
| SSO | Standard+ | All versions |
| Audit logs | Plus | All versions |
| Agents | Plus | All versions |
| Network isolation | Plus (private clusters) | Native self-host |
| Cost estimation | Standard+ | All versions |
| Sentinel | Plus | All versions |

Both share the same API and UX. Migration between the two is supported.

## Workspaces

A workspace holds:

- Terraform configuration (via VCS, CLI upload, or API)
- State file(s)
- Variables (Terraform variables and environment variables)
- Run history
- Policy attachments
- Notifications

### Execution Modes

- **Remote:** Terraform runs inside HCP Terraform. Plans and applies use HCP's compute. State stored in HCP.
- **Local:** State stored in HCP, execution happens on your laptop or CI runner. Used when you need local tooling or network access.
- **Agent:** Runs execute on self-hosted HCP Terraform Agents inside your private network. Required when Terraform must reach resources HCP cannot (on-prem, private VPCs without public endpoints).

Agents are lightweight Docker containers. Each agent pool can host multiple agents. Workspaces select an agent pool.

### Workflow Types

- **CLI-driven:** Developer runs `terraform plan/apply` locally, state stored remotely. Variables live in HCP.
- **VCS-driven:** HCP watches a VCS repo. PRs trigger speculative plans; merges to trunk trigger full runs.
- **API-driven:** External pipeline uploads a configuration tarball via API, triggers runs. Used for custom CI.

## Variables

Two kinds:

- **Terraform variables:** become `var.X` in HCL.
- **Environment variables:** exposed to the Terraform process (e.g., `AWS_ACCESS_KEY_ID`).

Properties:

- `sensitive`: redacted in logs; once set, value is write-only
- `hcl`: for complex types (maps, lists); value is parsed as HCL
- `description`: UI hint

### Variable Sets

Variable sets apply to multiple workspaces or projects. Use cases:

- Shared AWS credentials across a project's workspaces
- Organization-wide policy configuration
- Per-environment variable bundles

Precedence (highest wins):

1. `-var` and `-var-file` CLI flags (CLI-driven workflow only)
2. Workspace variables
3. Variable set variables
4. `terraform.tfvars` / `*.auto.tfvars` files in config

## Projects

A project groups workspaces for team ownership and permissions. Example: `project:platform` contains `networking`, `security`, `identity` workspaces. Team access is set at project level; workspaces inherit.

Projects also receive variable sets and policy sets.

## Teams and Permissions

Organization-level roles:

- **Owner:** full control including billing
- **Manage Policies, Manage VCS Settings, Manage Workspaces, Manage Projects:** scoped admin roles

Project-level team access:

- **Read:** view workspaces and runs
- **Plan:** queue plans
- **Write:** queue plans and applies
- **Admin:** full workspace management within the project
- **Custom:** mix and match permissions

## Dynamic Provider Credentials (OIDC)

Static credentials are a security liability. HCP Terraform can issue short-lived credentials per run using OIDC workload identity federation.

### AWS Example

1. Create an AWS IAM OIDC provider for `app.terraform.io` (audience: `aws.workload.identity`).
2. Create an IAM role with trust policy on that OIDC provider. Condition on `sub` to restrict to a specific organization/project/workspace.
3. Set workspace variables:
   - `TFC_AWS_PROVIDER_AUTH=true` (env var)
   - `TFC_AWS_RUN_ROLE_ARN=arn:aws:iam::123:role/tfc-role` (env var)
4. Remove any `AWS_ACCESS_KEY_ID` variables.

The AWS provider auto-detects the OIDC token and assumes the role. No static secrets ever land on disk.

### Azure and GCP

Equivalent patterns exist with `TFC_AZURE_PROVIDER_AUTH` / `TFC_GCP_PROVIDER_AUTH` and corresponding workload identity configs. Vault integration uses `TFC_VAULT_PROVIDER_AUTH`.

## Run Triggers

A run trigger links workspace B to workspace A: when A applies successfully, B queues a plan.

Use cases:

- Networking workspace applies, then application workspaces re-plan
- Shared module workspace applies, then consumers pick up changes

Configure under workspace settings > Run Triggers. Multiple sources allowed.

## Run Tasks

Run tasks are webhooks invoked at specific phases of a run. The task endpoint returns a verdict (pass/advisory-fail/mandatory-fail) that can block progression.

Use cases:

- Security scanners (Checkov, Snyk, Bridgecrew, Wiz)
- Cost controllers (Infracost)
- Custom governance checks

Attachable at organization or workspace level. Phases:

- `pre-plan` (Plus tier)
- `post-plan`
- `pre-apply`
- `post-apply`

## Notifications

Per-workspace notifications via:

- Email
- Slack
- Microsoft Teams
- Generic webhook (with HMAC signing)

Events: run created, plan finished, apply finished, needs attention, verification required.

## Health Assessments

Enable per-workspace to run scheduled drift detection. HCP performs a `plan -refresh-only` on a schedule and reports:

- Drift: real infrastructure differs from state
- Continuous validation: `check` block results

View under workspace > Health. No auto-remediation; surface to dashboard and notifications.

## Cost Estimation

Available on Standard and higher. HCP calculates proposed monthly cost from the plan using AWS/Azure/GCP public pricing. Shown in the run UI. Can be gated with Sentinel or OPA cost policies.

## No-Code Modules

Mark a module in the private registry as "no-code ready". End users can provision it via UI without writing HCL, by filling in inputs. Great for self-service of paved-road infrastructure.

## The tfe Provider

Manages HCP Terraform itself from Terraform code ("Terraform for Terraform"):

```hcl
terraform {
  required_providers {
    tfe = { source = "hashicorp/tfe" }
  }
}

provider "tfe" {
  token = var.tfe_token
}

resource "tfe_workspace" "app" {
  name           = "app-prod"
  organization   = "my-org"
  project_id     = tfe_project.platform.id
  auto_apply     = false
  execution_mode = "remote"
}

resource "tfe_variable" "region" {
  key          = "region"
  value        = "us-east-1"
  category     = "terraform"
  workspace_id = tfe_workspace.app.id
}
```

Use for self-service workspace provisioning, policy-as-code attachments, and team access management.

## Agents

Self-hosted runners for private-network access.

```
docker run -d \
  -e TFC_AGENT_TOKEN=<token> \
  -e TFC_AGENT_NAME=prod-agent-01 \
  hashicorp/tfc-agent:latest
```

Agents pull jobs from HCP; no inbound ports needed. Pair with variable sets scoping AWS roles to specific agent pools.

## API Essentials

- Base URL: `https://app.terraform.io/api/v2`
- Auth: Bearer user/team/organization token
- Key endpoints:
  - `POST /organizations/:org/workspaces`
  - `GET /workspaces/:id/runs`
  - `POST /runs` (queue a plan or apply)
  - `POST /workspaces/:id/vars`
  - `POST /runs/:id/actions/apply`

Useful for custom CI or migrations.

## Exam-Ready Checklist

- [ ] Can configure all three workspace execution modes
- [ ] Can set up OIDC dynamic credentials for AWS
- [ ] Can attach a variable set at org, project, and workspace scope
- [ ] Can configure a run trigger chain
- [ ] Can register and attach a run task
- [ ] Understand difference between health assessments and Sentinel continuous validation
- [ ] Can provision workspaces via the `tfe` provider
