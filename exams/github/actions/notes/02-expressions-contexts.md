# Expressions and Contexts

**[📖 Expressions](https://docs.github.com/en/actions/reference/expressions)** - Expression syntax reference
**[📖 Contexts](https://docs.github.com/en/actions/reference/contexts)** - Available contexts

## Expression Syntax

Expressions use the `${{ }}` syntax and can include literals, operators, functions, and context references.

### Literals
- Strings: `'hello'` (single quotes)
- Numbers: `42`, `3.14`
- Booleans: `true`, `false`
- Null: `null`

### Operators
| Operator | Description |
|----------|-------------|
| `()` | Grouping |
| `!` | Not |
| `<`, `<=`, `>`, `>=` | Comparison |
| `==`, `!=` | Equality |
| `&&` | And |
| `\|\|` | Or |

### Type Coercion
- Strings are compared case-insensitively
- `null` is coerced to `0` for comparisons and `''` for string operations

## Contexts

### github Context
```yaml
github.event_name        # push, pull_request, schedule, etc.
github.ref               # refs/heads/main, refs/tags/v1.0
github.ref_name          # main, v1.0 (short ref)
github.sha               # Full commit SHA
github.actor             # User who triggered the workflow
github.repository         # owner/repo
github.repository_owner  # Organization or user
github.workspace         # Runner workspace path
github.run_id            # Unique run identifier
github.run_number        # Sequential run number
github.event             # Full event payload (JSON)
github.token             # GITHUB_TOKEN
github.base_ref          # Base branch for PRs
github.head_ref          # Head branch for PRs
```

### secrets Context
```yaml
secrets.GITHUB_TOKEN     # Auto-generated token
secrets.MY_SECRET        # User-defined secret
```
- Secrets are masked in logs (replaced with ***)
- Cannot be used in `if` conditions directly
- Not available in reusable workflows unless explicitly passed or inherited

### env Context
```yaml
env.MY_VAR               # Environment variable set in workflow
```

### inputs Context
```yaml
inputs.environment       # workflow_dispatch or workflow_call input
```

### steps Context
```yaml
steps.step-id.outputs.name     # Output from a previous step
steps.step-id.outcome          # success, failure, cancelled, skipped
steps.step-id.conclusion       # Same as outcome but respects continue-on-error
```

### needs Context
```yaml
needs.job-id.outputs.name     # Output from a dependent job
needs.job-id.result            # success, failure, cancelled, skipped
```

### matrix Context
```yaml
matrix.node-version            # Current matrix value
matrix.os                      # Current matrix OS
```

### runner Context
```yaml
runner.os                       # Linux, Windows, macOS
runner.arch                     # X64, ARM64
runner.temp                     # Temp directory path
runner.tool_cache               # Tool cache directory
```

## Conditional Execution

### Job-Level Conditions
```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
```

### Step-Level Conditions
```yaml
steps:
- name: Deploy
  if: success()
  run: ./deploy.sh
- name: Notify failure
  if: failure()
  run: ./notify-failure.sh
- name: Cleanup
  if: always()
  run: ./cleanup.sh
```

### Status Functions

| Function | Returns True When |
|----------|------------------|
| `success()` | All previous steps succeeded (default implicit condition) |
| `failure()` | Any previous step failed |
| `always()` | Always (run regardless of previous status) |
| `cancelled()` | Workflow was cancelled |

**Important:** Without `if`, a step only runs if all previous steps succeeded. To run on failure, you must explicitly use `if: failure()` or `if: always()`.

### Common Conditional Patterns

```yaml
# Only on push to main
if: github.event_name == 'push' && github.ref == 'refs/heads/main'

# Only on PRs
if: github.event_name == 'pull_request'

# Skip for bot users
if: github.actor != 'dependabot[bot]'

# Run on failure to send notifications
if: failure()

# Check a step output
if: steps.check.outputs.changed == 'true'

# Contains check
if: contains(github.event.pull_request.labels.*.name, 'deploy')

# Starts with check
if: startsWith(github.ref, 'refs/tags/v')
```

## Built-in Functions

### String Functions
| Function | Description |
|----------|-------------|
| `contains(search, item)` | True if search contains item |
| `startsWith(string, prefix)` | True if string starts with prefix |
| `endsWith(string, suffix)` | True if string ends with suffix |
| `format(string, args...)` | String formatting |
| `join(array, separator)` | Join array elements |

### Object Functions
| Function | Description |
|----------|-------------|
| `toJSON(value)` | Convert to JSON string |
| `fromJSON(value)` | Parse JSON string |
| `hashFiles(pattern)` | SHA-256 hash of file(s) matching pattern |

## Environment Files

### Setting Outputs
```bash
echo "name=value" >> $GITHUB_OUTPUT
```

### Setting Environment Variables
```bash
echo "MY_VAR=value" >> $GITHUB_ENV
```

### Adding to PATH
```bash
echo "/my/path" >> $GITHUB_PATH
```

### Multiline Values
```bash
echo "result<<EOF" >> $GITHUB_OUTPUT
echo "line 1" >> $GITHUB_OUTPUT
echo "line 2" >> $GITHUB_OUTPUT
echo "EOF" >> $GITHUB_OUTPUT
```

### Job Summaries
```bash
echo "### Build Results" >> $GITHUB_STEP_SUMMARY
echo "- Tests passed: 42" >> $GITHUB_STEP_SUMMARY
```
