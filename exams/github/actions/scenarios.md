# GitHub Actions High-Yield Scenarios and Practice Problems

## Scenario 1: CI/CD Workflow Design

**Scenario**: Design a workflow that runs tests on every PR to main, requires tests to pass before merging, builds a Docker image on merge to main, and deploys to staging automatically but requires manual approval for production.

**Solution Pattern**:
- Trigger: `pull_request` for tests, `push` to main for build/deploy
- Use environments with protection rules for production
- Use job dependencies (`needs`) for sequential execution
- Use concurrency to prevent duplicate deployments

```yaml
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - run: npm test
  build:
    if: github.event_name == 'push'
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - run: docker build -t myapp:${{ github.sha }} .
  deploy-staging:
    needs: build
    environment: staging
    runs-on: ubuntu-latest
    steps:
    - run: echo "Deploy to staging"
  deploy-production:
    needs: deploy-staging
    environment: production  # Has required reviewers
    runs-on: ubuntu-latest
    steps:
    - run: echo "Deploy to production"
```

**Key Takeaway**: Use `if` conditions to control which jobs run for which events. Use environments with protection rules for deployment approvals.

---

## Scenario 2: Matrix Strategy

**Scenario**: Test a Node.js library across Node 16, 18, and 20 on Ubuntu and macOS. Node 16 on macOS is known to fail - exclude it. Also add a specific test for Node 20 with experimental features enabled.

**Solution Pattern**:
```yaml
strategy:
  fail-fast: false
  matrix:
    node: [16, 18, 20]
    os: [ubuntu-latest, macos-latest]
    exclude:
    - node: 16
      os: macos-latest
    include:
    - node: 20
      os: ubuntu-latest
      experimental: true
```

**Common Distractors**:
- Using `fail-fast: true` (default) would cancel all jobs if one fails
- Forgetting `exclude` syntax (must match full combination)
- Not knowing that `include` can add extra variables to specific combinations

**Key Takeaway**: Matrix creates all combinations. Use `exclude` to remove specific combinations and `include` to add extras with additional variables.

---

## Scenario 3: Custom Action Development

**Scenario**: Create a composite action that checks if a PR has the required labels before allowing merge. It should accept a list of required labels as input and fail if any are missing.

**Solution Pattern**:
```yaml
# action.yml
name: 'Check Required Labels'
description: 'Verify PR has required labels'
inputs:
  required-labels:
    description: 'Comma-separated list of required labels'
    required: true
  github-token:
    description: 'GitHub token'
    required: true
runs:
  using: 'composite'
  steps:
  - name: Check labels
    shell: bash
    env:
      REQUIRED: ${{ inputs.required-labels }}
      GH_TOKEN: ${{ inputs.github-token }}
    run: |
      # Get PR labels and check against required
      labels=$(gh pr view ${{ github.event.number }} --json labels -q '.labels[].name')
      # Check each required label
```

**Common Distractors**:
- Using JavaScript action when composite is simpler for this use case
- Forgetting `shell: bash` on composite action run steps (required)
- Not passing the GitHub token as an input

**Key Takeaway**: Composite actions combine steps and are the simplest to create. JavaScript actions provide more power. Docker actions support any language but are Linux-only.

---

## Scenario 4: Reusable Workflows

**Scenario**: An organization has 50 repositories that all need the same security scanning workflow. How should this be implemented to maintain consistency and reduce duplication?

**Solution Pattern**:
- Create a reusable workflow in a central repository
- Use `workflow_call` trigger with inputs for customization
- Call the reusable workflow from each repository

```yaml
# Central repo: .github/workflows/security-scan.yml
on:
  workflow_call:
    inputs:
      language:
        type: string
        required: true
    secrets:
      token:
        required: true
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run security scan
      run: echo "Scanning ${{ inputs.language }}"
      env:
        TOKEN: ${{ secrets.token }}
```

```yaml
# Each repo's workflow
on: [push]
jobs:
  security:
    uses: org/central-repo/.github/workflows/security-scan.yml@main
    with:
      language: javascript
    secrets:
      token: ${{ secrets.SCAN_TOKEN }}
```

**Common Distractors**:
- Confusing reusable workflows with composite actions (different mechanisms)
- Not knowing that `secrets: inherit` passes all secrets from the caller
- Forgetting that reusable workflows have a maximum nesting depth of 4

**Key Takeaway**: Reusable workflows enable DRY CI/CD across an organization. Use `workflow_call` trigger, define inputs and secrets, and call from other workflows.

---

## Scenario 5: Enterprise Runner Management

**Scenario**: A company needs self-hosted runners that can access internal services behind a firewall. Different teams should only use runners assigned to them. How should this be configured?

**Solution Pattern**:
- Install self-hosted runners on machines with network access to internal services
- Create runner groups for each team (e.g., "frontend-runners", "backend-runners")
- Assign repositories to the appropriate runner group
- Label runners for specific capabilities (e.g., `gpu`, `high-memory`)

```yaml
# Workflow targeting a specific runner group and label
jobs:
  build:
    runs-on: [self-hosted, backend, linux]
```

**Common Distractors**:
- Running self-hosted runners on public repositories (security risk - anyone can submit a PR and execute code)
- Not using runner groups for access control
- Not considering auto-scaling (Actions Runner Controller for Kubernetes)

**Key Takeaway**: Self-hosted runners provide access to internal resources. Use runner groups for access control and labels for capability selection. Never use self-hosted runners with public repositories.

---

## Scenario 6: OIDC Cloud Deployment

**Scenario**: Deploy to AWS from GitHub Actions without storing long-lived AWS credentials as secrets. How should authentication be configured?

**Solution Pattern**:
- Configure OIDC trust between GitHub and AWS
- Use the `aws-actions/configure-aws-credentials` action with OIDC
- Restrict trust to specific repository, branch, and environment

```yaml
permissions:
  id-token: write
  contents: read
jobs:
  deploy:
    environment: production
    runs-on: ubuntu-latest
    steps:
    - uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: arn:aws:iam::123456789:role/github-actions
        aws-region: us-east-1
    - run: aws s3 ls
```

**Common Distractors**:
- Forgetting `permissions: id-token: write` (required for OIDC token)
- Storing AWS access keys as secrets (works but less secure than OIDC)
- Not restricting the IAM trust policy to specific repos/branches

**Key Takeaway**: OIDC eliminates the need for long-lived cloud credentials. Configure trust at the cloud provider level, restrict to specific repos/branches, and always set `id-token: write` permission.

---

## Scenario 7: Secrets and Security

**Scenario**: A workflow needs to access a database password, an API key shared across the organization, and a deployment token only available in the production environment. How should secrets be organized?

**Solution Pattern**:
- **Database password**: Repository secret (specific to this repo)
- **API key**: Organization secret (shared across repos)
- **Deployment token**: Environment secret on the "production" environment (with required reviewers)

**Access in workflow:**
```yaml
jobs:
  deploy:
    environment: production
    runs-on: ubuntu-latest
    steps:
    - name: Access secrets
      env:
        DB_PASS: ${{ secrets.DATABASE_PASSWORD }}       # Repo secret
        API_KEY: ${{ secrets.ORG_API_KEY }}              # Org secret
        DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}        # Env secret
      run: echo "Deploying..."
```

**Common Distractors**:
- Printing secrets in logs (they are masked, but avoid deliberately logging them)
- Using repository secrets for shared values (org secrets reduce duplication)
- Not using environment protection rules for sensitive deployment secrets

**Key Takeaway**: Use the appropriate scope for each secret - repository for repo-specific, organization for shared, environment for deployment-specific. Environment secrets benefit from protection rules.

## Key Decision Factors

### Domain Priority for Study
1. **Author and Maintain Workflows (40%)** - YAML syntax, triggers, expressions, matrix, reusable workflows
2. **Author and Maintain Actions (25%)** - JS, Docker, composite actions, action.yml
3. **Consume Workflows (20%)** - Marketplace, pinning, starter workflows
4. **Manage for Enterprise (15%)** - Self-hosted runners, policies, OIDC

### Common Anti-Patterns
- Memorizing syntax without building real workflows
- Ignoring security features (OIDC, action pinning, permissions)
- Not understanding the difference between reusable workflows and composite actions
- Skipping enterprise features (15% of the exam)
