# Enterprise Management

**[📖 Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)** - Runner documentation
**[📖 Security Hardening](https://docs.github.com/en/actions/security-guides)** - Security guides
**[📖 OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)** - OIDC security

## Self-Hosted Runners

### When to Use
- Access to internal/private network resources
- Custom hardware requirements (GPU, high memory)
- Compliance requirements (data residency, air-gapped)
- Cost optimization for high-volume usage
- Specific OS or software requirements

### Setup
1. Navigate to Settings > Actions > Runners in repo/org/enterprise
2. Choose OS and architecture
3. Download and configure the runner application
4. Register the runner with a token
5. Start the runner as a service

### Runner Labels
```yaml
# Target a self-hosted runner with specific labels
runs-on: [self-hosted, linux, x64, gpu]
```
- Default labels: `self-hosted`, OS label, architecture label
- Custom labels for capabilities (gpu, high-memory, etc.)
- Labels enable routing workflows to appropriate runners

### Runner Groups
- Organize runners into groups at org or enterprise level
- Control which repositories can use which runners
- Default group: accessible to all repos
- Custom groups: restrict access to specific repos

### Security Considerations
- **Never use self-hosted runners with public repos** - Any fork can submit a PR and execute arbitrary code on your runner
- Runners should be treated as potentially compromised
- Use ephemeral runners when possible (fresh for each job)
- Limit access to sensitive resources on the runner
- Keep runner software updated

### Auto-Scaling
- **Actions Runner Controller (ARC)**: Kubernetes-based auto-scaling
- Scale runners up/down based on workflow queue
- Supports ephemeral runners (new pod per job)
- Works with any Kubernetes cluster

## Enterprise Policies

### Actions Permissions
- **All actions**: Allow any action from any source
- **Local actions only**: Only allow actions defined in the repository
- **Selected actions**: Allow specific actions and reusable workflows

### Configurable Settings
| Setting | Level | Purpose |
|---------|-------|---------|
| Allowed actions | Org/Enterprise | Restrict which actions can be used |
| Default permissions | Org/Repo | GITHUB_TOKEN default (read/write or read) |
| Fork PR policies | Org/Repo | Require approval for fork PR workflows |
| Artifact retention | Org/Repo | How long artifacts are kept |
| Cache storage | Org | Cache size limits |

### Default GITHUB_TOKEN Permissions
- **Permissive**: Read and write for all scopes
- **Restricted**: Read-only for contents and packages
- Best practice: Use restricted default and grant permissions per workflow

## Secrets Management

### Scopes
| Scope | Visibility | Use Case |
|-------|-----------|----------|
| Repository | Single repo | Repo-specific credentials |
| Environment | Single environment | Deployment credentials |
| Organization | Selected repos in org | Shared credentials |

### Environment Secrets
- Associated with a deployment environment
- Can require reviewer approval before use
- Support deployment protection rules (required reviewers, wait timer)
- Higher priority than repository secrets with the same name

### Best Practices
- Use OIDC instead of stored cloud credentials when possible
- Rotate secrets regularly
- Use environment secrets with protection rules for production
- Never log or echo secrets (they are masked, but avoid it)
- Organization secrets reduce duplication across repos

## OIDC (OpenID Connect)

### How It Works
1. Workflow requests an OIDC token from GitHub's identity provider
2. Token is exchanged with the cloud provider for short-lived credentials
3. Workflow uses temporary credentials to access cloud resources
4. Credentials expire automatically after the job

### Benefits
- No stored long-lived secrets
- Credentials are short-lived and scoped to the workflow run
- Cloud trust policies can restrict by repository, branch, environment
- Reduces secret management overhead

### Configuration
```yaml
permissions:
  id-token: write     # Required for OIDC
  contents: read

jobs:
  deploy:
    environment: production
    runs-on: ubuntu-latest
    steps:
    # AWS
    - uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: arn:aws:iam::123456789:role/github-deploy
        aws-region: us-east-1

    # Azure
    - uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    # GCP
    - uses: google-github-actions/auth@v2
      with:
        workload_identity_provider: 'projects/123/locations/global/workloadIdentityPools/pool/providers/github'
        service_account: 'deploy@project.iam.gserviceaccount.com'
```

### OIDC Token Claims
| Claim | Description |
|-------|-------------|
| `sub` | Subject (repo, branch, environment) |
| `repository` | Full repository name (owner/repo) |
| `repository_owner` | Organization or user |
| `ref` | Git ref that triggered the workflow |
| `environment` | Deployment environment name |
| `actor` | User who triggered the workflow |
| `workflow` | Workflow name |

**Trust Policy Example (AWS):**
- Restrict to specific repository: `repo:org/repo:*`
- Restrict to specific branch: `repo:org/repo:ref:refs/heads/main`
- Restrict to specific environment: `repo:org/repo:environment:production`

## Audit Logging

### What Is Logged
- Workflow runs and their status
- Secret access and modifications
- Runner registration and deregistration
- Policy changes
- Actions settings modifications

### Accessing Audit Logs
- Organization: Settings > Audit log
- Enterprise: Settings > Audit log
- API: REST API for programmatic access
- Streaming: Forward logs to external systems (Splunk, Datadog, S3)

## Billing and Usage

### GitHub-Hosted Runners
- Free minutes included per plan (2000 for Teams, 50000 for Enterprise)
- Overage billed per minute
- Multipliers: Linux 1x, Windows 2x, macOS 10x

### Storage
- Artifacts and caches count toward storage limits
- Configure retention periods to manage costs
- Organization-level cache size limits available

### Cost Optimization
- Use self-hosted runners for high-volume workflows
- Cache dependencies to reduce build times
- Use `paths` filter to skip unnecessary runs
- Set appropriate artifact retention periods
- Use concurrency to cancel redundant runs
