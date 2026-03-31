# Consuming Workflows and Actions

**[📖 Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)** - Reusable workflow documentation
**[📖 GitHub Marketplace](https://github.com/marketplace?type=actions)** - Browse available actions

## Using Actions from the Marketplace

### Action References
```yaml
# SHA pinning (most secure - immutable)
- uses: actions/checkout@a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0

# Tag pinning (convenient, but tags can be moved)
- uses: actions/checkout@v4

# Branch reference (least stable - not recommended for production)
- uses: actions/checkout@main
```

**Security Best Practice:** Pin to full SHA to prevent supply chain attacks. Tags can be moved to point to different commits. SHA references are immutable.

### Action Sources
```yaml
# Public repository action
- uses: actions/checkout@v4

# Same repository action (local)
- uses: ./.github/actions/my-action

# Docker Hub image
- uses: docker://alpine:3.18

# GitHub Container Registry
- uses: docker://ghcr.io/owner/action:v1
```

### Action Inputs and Outputs
```yaml
- uses: actions/setup-node@v4
  with:                          # Inputs to the action
    node-version: '20'
    cache: 'npm'
  id: setup                      # ID to reference outputs

- run: echo "${{ steps.setup.outputs.cache-hit }}"
```

## Starter Workflows

### What They Are
- Pre-built workflow templates for common CI/CD patterns
- Available from the repository "Actions" tab
- Cover many languages and frameworks (Node.js, Python, Java, Go, etc.)
- Include security, deployment, and automation templates

### Organization Starter Workflows
- Created in the organization's `.github` repository
- Located in `workflow-templates/` directory
- Each template needs a `.yml` workflow file and a `.properties.json` metadata file
- Available to all repositories in the organization

## Reusable Workflows

### Creating a Reusable Workflow
```yaml
# .github/workflows/reusable-ci.yml
name: Reusable CI
on:
  workflow_call:
    inputs:
      node-version:
        description: 'Node.js version'
        type: string
        default: '20'
      run-lint:
        description: 'Run linting'
        type: boolean
        default: true
    outputs:
      test-result:
        description: 'Test result'
        value: ${{ jobs.test.outputs.result }}
    secrets:
      npm-token:
        description: 'NPM token'
        required: false
jobs:
  test:
    runs-on: ubuntu-latest
    outputs:
      result: ${{ steps.test.outputs.result }}
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
    - run: npm ci
      env:
        NPM_TOKEN: ${{ secrets.npm-token }}
    - name: Lint
      if: inputs.run-lint
      run: npm run lint
    - name: Test
      id: test
      run: npm test && echo "result=pass" >> $GITHUB_OUTPUT
```

### Calling a Reusable Workflow
```yaml
jobs:
  ci:
    uses: org/shared-workflows/.github/workflows/reusable-ci.yml@main
    with:
      node-version: '20'
      run-lint: true
    secrets:
      npm-token: ${{ secrets.NPM_TOKEN }}
    # Or pass all secrets:
    # secrets: inherit
```

### Reusable Workflow Rules
- Maximum nesting depth: 4 levels
- Maximum 20 reusable workflows called in a single workflow file
- `env` context is not available in the called workflow's `with` or `secrets`
- Called workflow inherits `permissions` from the caller (unless overridden)
- `secrets: inherit` passes all caller's secrets to the reusable workflow

### Reusable Workflows vs Composite Actions

| Feature | Reusable Workflow | Composite Action |
|---------|------------------|-----------------|
| Defined by | `workflow_call` trigger | `action.yml` with `using: composite` |
| Contains | Full jobs with runners | Steps only (no runner selection) |
| Secrets | Has own secrets context | Uses caller's secrets via inputs |
| Runners | Can specify own runners | Runs on caller's runner |
| Visibility | Separate workflow file | Referenced as an action |
| Nesting | Max 4 levels | Max 10 levels |
| Best for | Full CI/CD pipelines | Reusable step sequences |

## Triggering Workflows from Other Workflows

### workflow_dispatch (API/UI)
```yaml
# Trigger another workflow via API
- uses: actions/github-script@v7
  with:
    script: |
      await github.rest.actions.createWorkflowDispatch({
        owner: context.repo.owner,
        repo: context.repo.repo,
        workflow_id: 'deploy.yml',
        ref: 'main',
        inputs: { environment: 'staging' }
      })
```

### repository_dispatch (Custom Events)
```yaml
# Send custom event
- uses: peter-evans/repository-dispatch@v3
  with:
    event-type: deploy-trigger
    client-payload: '{"env": "staging"}'
```

```yaml
# Receive custom event
on:
  repository_dispatch:
    types: [deploy-trigger]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - run: echo "Deploying to ${{ github.event.client_payload.env }}"
```
