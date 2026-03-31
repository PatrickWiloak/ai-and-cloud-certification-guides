# Custom Action Development

**[📖 Creating Actions](https://docs.github.com/en/actions/creating-actions)** - Action development guide
**[📖 Action Metadata](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions)** - action.yml syntax

## Action Types

### JavaScript Actions
- Run directly on the runner using Node.js
- Fastest execution (no container overhead)
- Cross-platform (Linux, Windows, macOS)
- Use `@actions/core` and other toolkit packages
- Entry point: JavaScript file specified in action.yml

```yaml
# action.yml
name: 'My JS Action'
description: 'Does something useful'
inputs:
  name:
    description: 'Name to greet'
    required: true
outputs:
  greeting:
    description: 'The greeting message'
runs:
  using: 'node20'
  main: 'dist/index.js'
  post: 'dist/cleanup.js'     # Optional cleanup step
```

### Docker Actions
- Run inside a Docker container
- Support any programming language
- Linux runners only
- Slower startup (container build/pull)
- Isolated environment with custom dependencies

```yaml
# action.yml
name: 'My Docker Action'
description: 'Runs in a container'
inputs:
  config:
    description: 'Config file path'
    required: true
runs:
  using: 'docker'
  image: 'Dockerfile'          # Build from Dockerfile
  # Or: image: 'docker://alpine:3.18'  # Pre-built image
  args:
  - ${{ inputs.config }}
  env:
    MY_VAR: 'value'
```

### Composite Actions
- Combine multiple steps into a single action
- Can use existing actions and run commands
- Cross-platform (Linux, Windows, macOS)
- No separate runtime - runs on the caller's runner
- Simplest to create

```yaml
# action.yml
name: 'Setup and Test'
description: 'Install deps and run tests'
inputs:
  node-version:
    description: 'Node.js version'
    default: '20'
outputs:
  test-result:
    description: 'Test outcome'
    value: ${{ steps.test.outputs.result }}
runs:
  using: 'composite'
  steps:
  - uses: actions/setup-node@v4
    with:
      node-version: ${{ inputs.node-version }}
  - name: Install dependencies
    shell: bash                 # Required for composite run steps
    run: npm ci
  - name: Run tests
    id: test
    shell: bash
    run: |
      npm test && echo "result=pass" >> $GITHUB_OUTPUT
```

### When to Use Each

| Criteria | JavaScript | Docker | Composite |
|----------|-----------|--------|-----------|
| Cross-platform | Yes | Linux only | Yes |
| Speed | Fast | Slower | Fast |
| Language | JavaScript/TypeScript | Any | N/A (uses other actions) |
| Dependencies | Node.js only | Any | N/A |
| Complexity | Medium | Medium-High | Low |
| Best for | API interactions, complex logic | Custom tooling, any language | Combining existing actions |

## action.yml Metadata

### Required Fields
- `name`: Action name (displayed in marketplace and UI)
- `description`: Short description of what the action does
- `runs`: How the action is executed

### Optional Fields
- `inputs`: Input parameters (name, description, required, default)
- `outputs`: Output values
- `branding`: Icon and color for the Marketplace

### Input Types
```yaml
inputs:
  required-input:
    description: 'This is required'
    required: true
  optional-input:
    description: 'This has a default'
    required: false
    default: 'hello'
  deprecated-input:
    description: 'Old input'
    deprecationMessage: 'Use new-input instead'
```

### Branding
```yaml
branding:
  icon: 'check-circle'
  color: 'green'
```

## Toolkit Packages

### @actions/core
```javascript
const core = require('@actions/core');

// Get inputs
const name = core.getInput('name', { required: true });

// Set outputs
core.setOutput('greeting', `Hello ${name}`);

// Logging
core.info('Information message');
core.warning('Warning message');
core.error('Error message');
core.debug('Debug message');

// Set failed
core.setFailed('Action failed with error');

// Mask a value in logs
core.setSecret('sensitive-value');

// Export variable
core.exportVariable('MY_VAR', 'value');

// Add to PATH
core.addPath('/my/tool/path');

// Annotations
core.notice('Notice annotation');
core.warning('Warning annotation', { file: 'app.js', startLine: 10 });
core.error('Error annotation', { file: 'app.js', startLine: 20 });

// Group
core.startGroup('Install dependencies');
// ... commands
core.endGroup();
```

### @actions/github
```javascript
const github = require('@actions/github');

// Get Octokit client
const octokit = github.getOctokit(core.getInput('token'));

// Access context
const { owner, repo } = github.context.repo;
const sha = github.context.sha;

// Use the GitHub API
await octokit.rest.issues.createComment({
  owner, repo,
  issue_number: github.context.issue.number,
  body: 'Hello from my action!'
});
```

### @actions/exec
```javascript
const exec = require('@actions/exec');

// Execute a command
await exec.exec('npm', ['install']);

// Capture output
let output = '';
await exec.exec('git', ['log', '--oneline', '-5'], {
  listeners: {
    stdout: (data) => { output += data.toString(); }
  }
});
```

## Publishing to Marketplace

### Steps
1. Create a public repository with action.yml
2. Add README.md with usage examples
3. Create a release with semantic versioning
4. Tag with major version (v1, v2) for easy consumption
5. Publish to Marketplace from release page

### Versioning Best Practices
- Tag releases with semver: v1.0.0, v1.1.0, v2.0.0
- Maintain major version tags (v1, v2) that point to latest minor/patch
- Users reference major version: `uses: owner/action@v1`
- Breaking changes require major version bump
- Use `ncc` or similar to bundle Node.js dependencies into single file

## Testing Custom Actions

### Local Testing
- For JavaScript: Run the entry point directly with environment variables
- For Docker: Build and run the container locally
- For Composite: Test individual steps

### GitHub-Based Testing
- Create a test workflow in the same repository
- Use `uses: ./` to reference the local action
- Test with various input combinations
- Verify outputs and side effects
