# Collaboration and Automation

The last domain (around 15%) tests your ability to wire Terraform into VCS workflows, CI/CD pipelines, and organization-scale self-service patterns.

## VCS Integration

HCP Terraform integrates natively with:

- GitHub (Cloud and Enterprise Server)
- GitLab (Cloud and Self-Managed)
- Bitbucket (Cloud and Data Center)
- Azure DevOps (Cloud and Server)

### OAuth vs App

- **GitHub App** (preferred): granular per-repo permissions, no personal token
- **OAuth**: user-tied, broader permissions, works with older deployments

In HCP: Settings > Providers > add VCS provider. The resulting `oauth_token_id` is what workspaces reference.

### Working Directory and Trigger Patterns

A monorepo often holds multiple Terraform modules. Configure per workspace:

- **Working directory:** relative path where `terraform init` runs (e.g., `environments/prod`)
- **VCS branch:** which branch triggers runs (default: repo default branch)
- **Auto-apply:** whether to skip the human approval step
- **Trigger patterns:** glob patterns; only changes to matching files queue a run

```
environments/prod/**
modules/vpc/**
```

Without trigger patterns, any push to the configured branch queues a run for every workspace attached to that repo. With trigger patterns, runs queue only when matching files change.

### Speculative Plans on Pull Requests

When a PR is opened against the tracked branch, HCP Terraform auto-runs a speculative plan. The plan output posts as a PR comment or status check. Plan succeeds or fails; no apply is ever offered. Merges to the trunk branch then trigger a real run (plan + approve + apply).

## GitHub Actions Integration

For non-HCP setups or bespoke pipelines:

```yaml
name: Terraform
on:
  pull_request:
  push:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    permissions:
      id-token: write   # for OIDC to AWS
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.8
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - run: terraform fmt -check -recursive
      - run: terraform init
      - run: terraform validate

      - name: Plan
        if: github.event_name == 'pull_request'
        run: terraform plan -out=tfplan -input=false

      - name: Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve -input=false
```

The `setup-terraform` action installs the CLI and, with a token, configures `terraform login` for HCP Terraform. When using the `cloud{}` block, plan/apply actually execute remotely; the Actions runner just orchestrates.

## GitLab CI Integration

```yaml
stages: [validate, plan, apply]

variables:
  TF_ROOT: ${CI_PROJECT_DIR}/environments/prod

default:
  image: hashicorp/terraform:1.9.8
  before_script:
    - cd ${TF_ROOT}
    - terraform init

validate:
  stage: validate
  script:
    - terraform fmt -check -recursive
    - terraform validate

plan:
  stage: plan
  script:
    - terraform plan -out=$CI_PROJECT_DIR/tfplan
  artifacts:
    paths: [tfplan]

apply:
  stage: apply
  script:
    - terraform apply -auto-approve tfplan
  dependencies: [plan]
  when: manual
  only: [main]
```

GitLab's `terraform` managed state backend uses the `http` backend protocol.

## API-Driven Workflow

For fully bespoke pipelines (e.g., Jenkins, Buildkite), use the HCP Terraform API directly.

Flow:

1. Create a configuration version: `POST /workspaces/:id/configuration-versions`
2. Upload a tarball of your config: `PUT` to returned upload URL
3. Queue a run: `POST /runs` referencing the workspace and configuration version
4. Poll `GET /runs/:id` until status is `planned_and_finished` or `cost_estimated`
5. If auto-apply is off, `POST /runs/:id/actions/apply` after approval

Useful Python and Go clients exist. HashiCorp's `go-tfe` library is the canonical Go client.

## Self-Service Workspace Provisioning

Pattern: a "meta-workspace" manages other workspaces via the `tfe` provider.

```hcl
resource "tfe_project" "team_a" {
  name         = "team-a"
  organization = "my-org"
}

resource "tfe_workspace" "team_a_dev" {
  name         = "team-a-dev"
  organization = "my-org"
  project_id   = tfe_project.team_a.id
  vcs_repo {
    identifier     = "my-org/team-a-infra"
    branch         = "main"
    oauth_token_id = var.oauth_token
  }
  execution_mode = "remote"
  auto_apply     = false
}

resource "tfe_team_project_access" "team_a_write" {
  access     = "write"
  team_id    = tfe_team.team_a.id
  project_id = tfe_project.team_a.id
}

resource "tfe_variable_set" "team_a_aws" {
  name = "team-a-aws-oidc"
}

resource "tfe_project_variable_set" "team_a" {
  project_id      = tfe_project.team_a.id
  variable_set_id = tfe_variable_set.team_a_aws.id
}
```

New team? Add one project block and submit a PR. Merge triggers workspace provisioning.

## Drift Detection Strategies

- **HCP Terraform health assessments:** scheduled `plan -refresh-only`. Surfaces drift in UI and notifications. Best for ongoing passive monitoring.
- **Scheduled applies:** cron-like run triggers that auto-remediate. Use cautiously; if drift reflects a legitimate emergency change, auto-apply undoes it.
- **Third-party tools:** `driftctl`, `terraformer` for bulk detection. Useful during onboarding.
- **AWS Config / Azure Policy:** detect cloud-side changes outside Terraform and notify.

A robust pattern combines health assessments (for daily awareness) with Config rules (for real-time alerts on critical resources).

## Module Versioning in Consumers

Consumer repos should pin:

```hcl
module "vpc" {
  source  = "app.terraform.io/my-org/vpc/aws"
  version = "~> 2.1"
}
```

On new major releases, maintainers communicate via:

- CHANGELOG.md in the module repo
- Announcement in team channel or org-wide readme
- Optionally, a dependabot-like bot PRs version bumps to consumers

Speculative plans on PRs catch most breakage before merge.

## Run Tasks for Scanner Integration

Run tasks hit a webhook at a run phase with a signed HMAC. The handler evaluates and POSTs back a verdict.

Common integrations:

- **Checkov, tfsec, Trivy:** IaC security scanning
- **Infracost:** cost diff reporting
- **Bridgecrew, Wiz, Snyk:** commercial security platforms
- **Custom webhooks:** for org-specific policies

Attach at post-plan phase to evaluate the plan JSON before apply.

## Observability

- HCP Terraform audit logs (Plus tier) stream via HTTP to SIEMs
- Workspace notifications into Slack or webhook for run lifecycle
- Prometheus exporter for HCP Terraform metrics (community)

Track:

- Apply success rate per workspace
- Mean plan duration
- Number of policy failures
- Frequency of manual overrides

## Branching Strategies for Terraform

**Trunk-based with environments as workspaces:** single branch (`main`), multiple workspaces pointing to different directories or var files. Best for most orgs.

**Branch-per-environment:** `main` is prod, `staging` branch is staging, etc. Fragile and promotes drift between branches. Avoid unless required by policy.

**GitOps (ArgoCD-style):** PR merge to an env-specific branch triggers apply. Works but adds complexity.

## Anti-Patterns

- Committing `.terraform/` directory (should be gitignored)
- Committing `terraform.tfstate` to git
- Sharing backend credentials across teams (use per-team roles)
- Configuring providers inside reusable modules (keep providers in root)
- One workspace per resource (over-decomposition)
- One workspace for everything (no blast-radius isolation)

## Exam-Ready Checklist

- [ ] Can configure VCS-driven workspace with working dir and trigger patterns
- [ ] Can build a GitHub Actions pipeline using `setup-terraform`
- [ ] Can provision workspaces via `tfe` provider
- [ ] Understand speculative plans on PRs
- [ ] Can integrate a run task end-to-end
- [ ] Know drift detection options and tradeoffs
