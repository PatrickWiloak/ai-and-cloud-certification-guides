# Workflow Authoring

**[📖 Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - Complete YAML reference
**[📖 Events](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)** - All trigger events

## Workflow Structure

Workflow files live in `.github/workflows/` and are written in YAML.

```yaml
name: CI Pipeline                    # Workflow name (displayed in UI)
on:                                  # Trigger events
  push:
    branches: [main, develop]
    paths: ['src/**', 'tests/**']
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * 1'            # Every Monday at midnight
  workflow_dispatch:                  # Manual trigger
    inputs:
      environment:
        type: choice
        options: [staging, production]

permissions:                         # GITHUB_TOKEN permissions
  contents: read
  pull-requests: write

env:                                 # Workflow-level environment variables
  NODE_VERSION: '20'

jobs:                                # One or more jobs
  build:
    runs-on: ubuntu-latest           # Runner selection
    steps:                           # Sequential steps
    - uses: actions/checkout@v4      # Action step
    - name: Install dependencies     # Run step
      run: npm ci
    - name: Run tests
      run: npm test
```

## Event Triggers

### Common Triggers

| Trigger | When It Fires |
|---------|---------------|
| `push` | Push commits to a branch or tag |
| `pull_request` | PR opened, synchronize (new commits), reopened |
| `pull_request_target` | Same as PR but runs in context of base branch (for forks) |
| `schedule` | Cron schedule (UTC) |
| `workflow_dispatch` | Manual trigger from UI/API with optional inputs |
| `repository_dispatch` | Custom webhook event from external systems |
| `workflow_call` | Called as a reusable workflow |
| `release` | Release created, published, edited, etc. |
| `issues` | Issue created, edited, labeled, closed, etc. |
| `issue_comment` | Comment on issue or PR |

### Trigger Filters

```yaml
on:
  push:
    branches: [main, 'release/**']        # Include these branches
    branches-ignore: ['feature/**']        # Exclude these branches
    paths: ['src/**', '*.js']              # Only if these paths changed
    paths-ignore: ['docs/**', '*.md']      # Ignore these paths
    tags: ['v*']                           # Tags matching pattern
    tags-ignore: ['v*-beta']               # Exclude tags
```

**Rules:**
- Cannot use `branches` and `branches-ignore` together
- Cannot use `paths` and `paths-ignore` together
- `paths` is useful for monorepos (only run when relevant files change)
- `branches` uses glob patterns (e.g., `release/**` matches `release/1.0`)

### workflow_dispatch Inputs

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options: [staging, production]
      debug:
        description: 'Enable debug mode'
        type: boolean
        default: false
      version:
        description: 'Version to deploy'
        type: string
        required: true
```

## Jobs

### Job Configuration

```yaml
jobs:
  build:
    name: Build Application              # Display name
    runs-on: ubuntu-latest               # Runner
    timeout-minutes: 30                  # Job timeout
    if: github.event_name == 'push'      # Conditional execution
    environment: staging                  # Deployment environment
    concurrency:
      group: deploy-${{ github.ref }}
      cancel-in-progress: true
    outputs:
      version: ${{ steps.version.outputs.value }}
    steps:
      # ...
```

### Runners

| Runner | Label | Notes |
|--------|-------|-------|
| Ubuntu | `ubuntu-latest`, `ubuntu-22.04` | Most common, Linux tools |
| Windows | `windows-latest`, `windows-2022` | Windows builds, .NET |
| macOS | `macos-latest`, `macos-14` | iOS/macOS builds, Apple tools |
| Self-hosted | `self-hosted`, custom labels | Custom environments |

### Job Dependencies

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps: # ...
  test:
    needs: build              # Runs after build completes
    runs-on: ubuntu-latest
    steps: # ...
  deploy:
    needs: [build, test]      # Runs after both complete
    runs-on: ubuntu-latest
    steps: # ...
```

- Jobs run in parallel by default
- `needs` creates sequential dependencies
- If a needed job fails, dependent jobs are skipped (unless `if: always()`)

### Job Outputs

```yaml
jobs:
  build:
    outputs:
      version: ${{ steps.get-version.outputs.version }}
    steps:
    - id: get-version
      run: echo "version=1.2.3" >> $GITHUB_OUTPUT
  deploy:
    needs: build
    steps:
    - run: echo "Deploying version ${{ needs.build.outputs.version }}"
```

## Steps

### Action Steps
```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0           # Full history for git operations
    token: ${{ secrets.PAT }} # Custom token for private repos
```

### Run Steps
```yaml
- name: Run script
  run: |
    echo "Multi-line"
    echo "commands"
  shell: bash                 # Specify shell (bash, pwsh, python, etc.)
  working-directory: ./app
  env:
    API_KEY: ${{ secrets.API_KEY }}
```

## Matrix Strategy

```yaml
strategy:
  fail-fast: false            # Don't cancel others if one fails
  max-parallel: 3             # Limit concurrent jobs
  matrix:
    node: [16, 18, 20]
    os: [ubuntu-latest, windows-latest]
    exclude:
    - node: 16
      os: windows-latest
    include:
    - node: 20
      os: ubuntu-latest
      coverage: true          # Extra variable for this combo
```

## Artifacts and Caching

### Artifacts
```yaml
# Upload
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/
    retention-days: 5

# Download (in another job)
- uses: actions/download-artifact@v4
  with:
    name: build-output
    path: dist/
```

### Caching
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Secrets and Variables

### Access
```yaml
env:
  SECRET_VALUE: ${{ secrets.MY_SECRET }}     # Encrypted, masked in logs
  CONFIG_VALUE: ${{ vars.MY_VARIABLE }}       # Non-sensitive configuration
```

### Scope Hierarchy
1. **Environment secrets/variables** - Highest priority, scoped to environment
2. **Repository secrets/variables** - Scoped to repository
3. **Organization secrets/variables** - Shared across repos in the org

## Concurrency

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true    # Cancel in-progress run when new one starts
```

- Prevents duplicate runs for the same branch/PR
- Group key determines what constitutes a "duplicate"
- Useful for deployments and expensive CI runs

## Permissions (GITHUB_TOKEN)

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
  id-token: write             # Required for OIDC
  packages: write             # Required for GHCR
```

- Principle of least privilege: only grant what is needed
- Can be set at workflow level or job level
- Job-level permissions override workflow-level
