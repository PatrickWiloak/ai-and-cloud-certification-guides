# GitHub Actions Certification Fact Sheet

## Exam Overview

**Exam Name:** GitHub Actions
**Duration:** 120 minutes
**Format:** Multiple choice (65 questions)
**Passing Score:** 70%
**Cost:** $99 USD
**Valid For:** 3 years
**Delivery:** Online proctored
**Prerequisites:** None (GitHub Foundations recommended)

**[📖 GitHub Certifications](https://resources.github.com/learn/certifications/)** - Registration and exam details
**[📖 GitHub Actions Documentation](https://docs.github.com/en/actions)** - Complete Actions documentation
**[📖 Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - YAML syntax reference

## Exam Domains

### Domain 1: Author and Maintain Workflows (40%)

#### 1.1 Workflow Structure
```yaml
name: CI Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
permissions:
  contents: read
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run tests
      run: npm test
```

**[📖 Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - Complete YAML reference

#### 1.2 Event Triggers

| Trigger | Description |
|---------|-------------|
| `push` | Push to a branch or tag |
| `pull_request` | PR opened, synchronized, reopened |
| `schedule` | Cron-based schedule |
| `workflow_dispatch` | Manual trigger with optional inputs |
| `repository_dispatch` | External webhook trigger |
| `workflow_call` | Called by another workflow (reusable) |
| `release` | Release created, published, etc. |
| `issues` | Issue created, edited, labeled, etc. |

**Filters:**
- `branches`, `branches-ignore` - filter by branch name
- `paths`, `paths-ignore` - filter by file path changes
- `tags`, `tags-ignore` - filter by tag name

**[📖 Events](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)** - All trigger events

#### 1.3 Expressions and Contexts

**Contexts:**
| Context | Contents |
|---------|----------|
| `github` | Workflow run info (event, sha, ref, actor, repository) |
| `env` | Environment variables |
| `secrets` | Repository and organization secrets |
| `inputs` | Workflow dispatch or reusable workflow inputs |
| `vars` | Configuration variables |
| `job` | Current job info |
| `steps` | Step outputs and outcomes |
| `runner` | Runner info (os, arch, temp) |
| `matrix` | Current matrix values |
| `needs` | Outputs from dependent jobs |

**Status Functions:**
- `success()` - True if all previous steps succeeded
- `failure()` - True if any previous step failed
- `always()` - Always true (run regardless of status)
- `cancelled()` - True if workflow was cancelled

**[📖 Expressions](https://docs.github.com/en/actions/reference/expressions)** - Expression syntax
**[📖 Contexts](https://docs.github.com/en/actions/reference/contexts)** - Available contexts

#### 1.4 Matrix Strategy
```yaml
strategy:
  matrix:
    node-version: [16, 18, 20]
    os: [ubuntu-latest, windows-latest]
  fail-fast: false
  max-parallel: 4
```
- Creates a job for each combination
- `fail-fast`: Cancel remaining jobs if one fails (default: true)
- `include`/`exclude`: Add or remove specific combinations

#### 1.5 Artifacts and Caching
- **Artifacts**: Upload/download build outputs between jobs
- `actions/upload-artifact` and `actions/download-artifact`
- **Cache**: Speed up dependency installation
- `actions/cache` with key and restore-keys
- Cache key should include lock file hash

**[📖 Caching](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)** - Caching dependencies

#### 1.6 Secrets and Variables
- **Secrets**: Encrypted, masked in logs, available via `${{ secrets.NAME }}`
- **Variables**: Non-sensitive configuration, available via `${{ vars.NAME }}`
- Scope: repository, environment, organization
- Secrets cannot be read back after creation
- Environment secrets require approval for protected environments

**[📖 Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)** - Managing secrets

#### 1.7 Reusable Workflows
```yaml
# Caller workflow
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/reusable.yml@main
    with:
      environment: production
    secrets: inherit
```
- Triggered by `workflow_call` event
- Support inputs, secrets, and outputs
- `secrets: inherit` passes all caller secrets
- Maximum nesting depth: 4 levels

**[📖 Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)** - Reusable workflow guide

#### 1.8 Concurrency
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```
- Prevents duplicate runs for the same branch/PR
- `cancel-in-progress`: Cancel the running workflow when a new one starts

#### 1.9 Permissions
```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
```
- GITHUB_TOKEN permissions can be restricted per workflow or job
- Default: permissive or restricted (configurable at org/repo level)
- Principle of least privilege: only grant what is needed

### Domain 2: Consume Workflows (20%)

#### 2.1 Using Actions
```yaml
- uses: actions/checkout@v4          # Tag
- uses: actions/setup-node@main      # Branch
- uses: actions/cache@a1b2c3d4e5...  # SHA (most secure)
```
- Pin to SHA for security (prevents supply chain attacks)
- Pin to tag for convenience
- Pin to branch only for development

#### 2.2 Starter Workflows
- Pre-built workflow templates for common patterns
- Available from repository "Actions" tab
- Organization starter workflows in `.github` repository
- Covers: CI, CD, security, code quality

### Domain 3: Author and Maintain Actions (25%)

#### 3.1 Action Types

| Type | Runtime | Platform | Speed |
|------|---------|----------|-------|
| JavaScript | Node.js | All platforms | Fast (no container) |
| Docker | Any language | Linux only | Slower (container build) |
| Composite | N/A (combines steps) | All platforms | Varies |

#### 3.2 action.yml Metadata
```yaml
name: 'My Action'
description: 'Does something useful'
inputs:
  who-to-greet:
    description: 'Who to greet'
    required: true
    default: 'World'
outputs:
  greeting:
    description: 'The greeting'
runs:
  using: 'node20'
  main: 'dist/index.js'
```

**[📖 Action Metadata](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions)** - action.yml syntax

#### 3.3 Toolkit Packages
- `@actions/core` - Input/output, logging, annotations, secrets masking
- `@actions/github` - Octokit client for GitHub API
- `@actions/exec` - Execute commands
- `@actions/io` - File system operations
- `@actions/cache` - Caching support

### Domain 4: Manage GitHub Actions for the Enterprise (15%)

#### 4.1 Self-Hosted Runners
- Run workflows on your own infrastructure
- Benefits: custom environments, compliance, cost control, network access
- Security: treat as untrusted (especially with public repos)
- Runner groups: control which repos can use which runners
- Auto-scaling with Actions Runner Controller (ARC) for Kubernetes

**[📖 Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)** - Runner documentation

#### 4.2 Enterprise Policies
- Allow or deny specific actions (all, local only, selected)
- Require approval for first-time contributors
- Set default GITHUB_TOKEN permissions
- Configure runner groups and access
- Audit log for all Actions activity

#### 4.3 OIDC for Cloud Authentication
- OpenID Connect for short-lived cloud credentials
- No stored secrets needed for cloud deployments
- Supports AWS, Azure, GCP
- Trust established via OIDC provider configuration
- Claims include repository, branch, environment

**[📖 OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)** - OIDC security guide

## Exam Tips

### MCQ Strategy
1. **Focus on workflow YAML (40%)** - Know the syntax cold
2. **Know all event triggers** - Including filter options
3. **Understand expressions** - Contexts, functions, conditionals
4. **Action types** - When to use JS vs Docker vs composite
5. **Security** - Secrets, OIDC, runner security, action pinning

### Common Pitfalls
- Confusing `pull_request` with `pull_request_target` (different security contexts)
- Not understanding that jobs run in parallel by default
- Confusing `secrets` with `vars` (secrets are encrypted and masked)
- Not knowing matrix strategy syntax (include/exclude)
- Mixing up reusable workflows (`workflow_call`) with composite actions

---

**Key Takeaway:** Master the workflow YAML syntax - it is 40% of the exam. Know triggers, expressions, contexts, matrix strategies, and reusable workflows. Understand the three action types and when to use each. Know enterprise features like self-hosted runners and OIDC.
