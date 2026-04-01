# GitHub Actions Administration - GitHub Administration

## Overview

GitHub Actions management covers 20% of the exam. This domain focuses on self-hosted runners, runner groups, allowed actions policies, secrets management, and OIDC for cloud deployments.

**[📖 GitHub Actions Admin](https://docs.github.com/en/enterprise-cloud@latest/admin/policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-github-actions-in-your-enterprise)** - Actions administration

## Self-Hosted Runners

**[📖 Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners)** - Custom runners

### Why Self-Hosted Runners

- **Custom hardware**: GPUs, ARM, specialized processors
- **Network access**: Access private resources behind firewalls
- **Persistent environment**: Pre-installed tools, cached dependencies
- **Cost control**: No per-minute charges (you provide infrastructure)
- **Compliance**: Data stays in your network
- **Longer runs**: No 6-hour job timeout (configurable)

### Runner Types

| Level | Scope | Managed By |
|-------|-------|-----------|
| Repository runner | Single repository | Repo admin |
| Organization runner | All/selected repos in org | Org admin |
| Enterprise runner | All/selected orgs | Enterprise admin |

### Runner Installation

1. Download runner application from GitHub settings
2. Configure with registration token: `./config.sh --url <url> --token <token>`
3. Run as a service: `sudo ./svc.sh install && sudo ./svc.sh start`
4. Runner appears in settings with labels

### Runner Labels

**[📖 Runner Labels](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/using-labels-with-self-hosted-runners)** - Label management

- Default labels: `self-hosted`, OS label (`linux`, `windows`, `macOS`), architecture (`X64`, `ARM64`)
- Custom labels: Add labels for capabilities (`gpu`, `docker`, `high-memory`)
- Workflow targeting: `runs-on: [self-hosted, linux, gpu]`
- Labels enable routing jobs to appropriate runners

### Runner Security Considerations

**[📖 Runner Security](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security)** - Security hardening

- **Never use self-hosted runners with public repositories** - Anyone can fork and run workflows
- Runners execute arbitrary code from workflows
- Use ephemeral runners for better isolation (recreated per job)
- Restrict runner access via runner groups
- Keep runner software updated
- Use minimal permissions for runner service account
- Network: Restrict outbound access to required endpoints only

## Runner Groups

**[📖 Runner Groups](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/managing-access-to-self-hosted-runners-using-groups)** - Access control

### Purpose

- Control which repositories or organizations can use which runners
- Isolate runners for security-sensitive workloads
- Manage runner allocation for cost or compliance

### Configuration

**Organization runner groups:**
- Default group: Available to all repositories
- Custom groups: Restrict to selected repositories
- Can contain multiple runners with different labels
- Admin controls which repos access which groups

**Enterprise runner groups:**
- Restrict to selected organizations
- Organization admins can further restrict to repos within their org
- Shared runners across the enterprise with controlled access

### Common Pattern

```
Enterprise Runner Groups:
├── default (all orgs)
│   └── General-purpose runners
├── production (selected orgs)
│   └── High-security runners with production network access
└── gpu-runners (data-science org only)
    └── GPU-enabled runners
```

## Actions Policies

### Allowed Actions

**[📖 Actions Policies](https://docs.github.com/en/enterprise-cloud@latest/admin/policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-github-actions-in-your-enterprise)** - Action restrictions

| Policy | Description |
|--------|-------------|
| Allow all actions | Any action from GitHub Marketplace or custom |
| Allow local actions only | Only actions defined in the same repository |
| Allow select actions | Specific actions by owner or owner/repo |

**Select actions configuration:**
- Allow actions by GitHub (`actions/*`, `github/*`)
- Allow actions by verified creators
- Allow specific patterns: `owner/*`, `owner/repo@ref`
- Block all other actions

### GITHUB_TOKEN Permissions

**[📖 GITHUB_TOKEN](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication)** - Token permissions

- Automatic token for each workflow run
- Default permissions: Can be set to **read-only** (recommended) or **read-write**
- Set default at organization or enterprise level
- Workflows can request additional permissions via `permissions` key
- Best practice: Set default to read-only, explicitly request write permissions per job

### Fork Pull Request Policies

- Control whether workflows run on PRs from forks
- **Require approval**: First-time contributors need approval before workflows run
- **Restrict fork PRs**: Limit which fork PRs can trigger workflows
- **Share secrets**: Control whether fork PR workflows can access secrets (default: no)

## Secrets Management

**[📖 Encrypted Secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)** - Secret storage

### Secret Levels

| Level | Scope | Access |
|-------|-------|--------|
| Repository secret | Single repository | All workflows in repo |
| Organization secret | Multiple repositories | Selected repos or all repos |
| Environment secret | Specific environment | Workflows deploying to that environment |

### Secret Management

- Encrypted with libsodium sealed box
- Not visible in logs (automatically masked)
- Not passed to workflows from fork PRs (by default)
- Cannot be read after creation - only updated or deleted
- Maximum 1,000 secrets per organization, 100 per repository, 100 per environment
- Maximum secret size: 48 KB

### Environment Protection Rules

**[📖 Environments](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment)** - Deployment environments

- **Required reviewers**: Specific people must approve before deployment
- **Wait timer**: Delay deployment by specified minutes
- **Deployment branches**: Restrict which branches can deploy
- **Environment secrets**: Secrets scoped to the environment
- **Environment variables**: Non-sensitive configuration per environment

### Configuration Variables

**[📖 Variables](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables)** - Non-sensitive configuration

- Store non-sensitive configuration values
- Available at repository, organization, and environment levels
- Referenced as `${{ vars.VARIABLE_NAME }}`
- Not encrypted (use secrets for sensitive values)
- Visible in workflow logs

## OIDC for Cloud Deployments

**[📖 OIDC](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect)** - Secure cloud access

### Why OIDC

- **No long-lived credentials**: No cloud access keys stored as secrets
- **Short-lived tokens**: Temporary credentials per workflow run
- **Fine-grained trust**: Cloud provider trusts specific repos, branches, environments
- **Auditable**: Cloud provider logs show which workflow requested access

### How OIDC Works

1. Workflow requests OIDC token from GitHub's token endpoint
2. Token contains claims: repository, branch, environment, actor, etc.
3. Cloud provider validates token against GitHub OIDC provider
4. Cloud provider issues temporary credentials based on trust policy
5. Workflow uses temporary credentials for cloud operations

### Cloud Provider Setup

**AWS:**
- Create OIDC identity provider in IAM
- Create IAM role with trust policy for GitHub OIDC
- Condition keys: `repo`, `ref`, `environment`
- Use `aws-actions/configure-aws-credentials` action

**Azure:**
- Create federated credential in Azure AD app registration
- Trust specific repo, branch, or environment
- Use `azure/login` action

**GCP:**
- Create Workload Identity Pool and Provider
- Map GitHub claims to GCP service account
- Use `google-github-actions/auth` action

**[📖 OIDC with AWS](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)** - AWS OIDC setup
**[📖 OIDC with Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)** - Azure OIDC setup

## GitHub-Hosted Larger Runners

**[📖 Larger Runners](https://docs.github.com/en/actions/using-github-hosted-runners/using-larger-runners)** - Enhanced runners

- 2-core to 64-core options (Linux, Windows)
- GPU runners available
- Static IP address option (for firewall rules)
- Runner groups for access control
- macOS larger runners available
- Metered billing per minute

## Common Exam Patterns

1. **"Restrict which actions can be used"** - Allowed actions policy (select actions)
2. **"Secure cloud access without stored credentials"** - OIDC
3. **"Self-hosted runner with public repo"** - Security risk, do not do this
4. **"Control which repos use which runners"** - Runner groups
5. **"Default token too permissive"** - Set GITHUB_TOKEN default to read-only
6. **"Require approval before production deploy"** - Environment protection rules
7. **"Share secrets across multiple repos"** - Organization-level secrets
8. **"Static IP for firewall"** - GitHub-hosted larger runners with static IP
