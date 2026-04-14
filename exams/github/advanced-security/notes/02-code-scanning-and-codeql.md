# Code Scanning and CodeQL

## What Code Scanning Is

Code scanning is GitHub's integrated static analysis system for finding vulnerabilities and quality issues. Results appear as alerts in the Security tab and as annotations on pull requests.

**[About Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)** - Overview

## Analysis Engines

### CodeQL

- GitHub's SAST engine, used by default
- Builds a relational database from source code and runs queries against it
- Supported languages: C, C++, C#, Go, Java, Kotlin, JavaScript, TypeScript, Python, Ruby, Swift

### Third-Party Tools via SARIF

- Any tool producing SARIF 2.1.0 output can upload results
- Results appear in the Security tab alongside CodeQL results
- Common: Semgrep, Snyk, Checkmarx, Veracode, SonarQube

## Setup Options

### Default Setup

- Enabled in one click from the Security tab or via security configuration
- GitHub auto-detects languages
- Runs on push, PR, and weekly schedule
- Uses the standard `code-scanning` query suite
- No YAML file to maintain

### Advanced Setup

- Creates `.github/workflows/codeql.yml`
- Full control over:
  - Languages and matrix
  - Query suites and custom queries
  - Schedule
  - Paths-ignore and paths filtering
  - Custom build steps (for compiled languages)
  - Custom runners (self-hosted)

### Switching

- Can convert from default to advanced at any time
- Converting back from advanced to default removes the custom workflow

**[Configuring Code Scanning](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning)** - Customization guide

## A Sample CodeQL Workflow

```yaml
name: "CodeQL"

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 6 * * 1'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      actions: read
      contents: read
    strategy:
      fail-fast: false
      matrix:
        language: ['javascript', 'python']
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: ${{ matrix.language }}
          queries: security-extended
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
```

Key actions:
- `init` - Creates the CodeQL database config
- `autobuild` - Attempts to build compiled languages
- `analyze` - Runs queries and uploads results

## Query Suites

| Suite | Scope |
|-------|-------|
| `code-scanning` | Default; high-precision security queries |
| `security-extended` | Default plus lower-precision security queries |
| `security-and-quality` | Extended plus code quality queries |

Configure via the `queries` input:

```yaml
- uses: github/codeql-action/init@v3
  with:
    languages: javascript
    queries: security-extended
```

**[Query Suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/codeql-query-suites)** - Reference

## CodeQL Packs

CodeQL packs distribute custom queries. Two types:

- **Query packs** - Bundle queries you want to run
- **Library packs** - Provide reusable CodeQL logic for other packs

Install a pack in a workflow:

```yaml
- uses: github/codeql-action/init@v3
  with:
    packs: myorg/custom-js-queries@1.0.0
```

## Custom Queries

Custom `.ql` queries let teams detect organization-specific patterns (e.g., banned APIs, internal risky functions). Queries are written in CodeQL language with metadata headers:

```ql
/**
 * @name Use of deprecated internal logger
 * @kind problem
 * @problem.severity warning
 * @id myorg/js/deprecated-logger
 */
import javascript

from CallExpr ce
where ce.getCalleeName() = "oldLogger"
select ce, "Use newLogger instead."
```

## SARIF Uploads

Upload SARIF from any tool:

```yaml
- uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: results.sarif
    category: semgrep
```

Important SARIF fields:
- `ruleId` - Unique rule identifier
- `level` - note, warning, error
- `message.text` - Human-readable description
- `locations[].physicalLocation` - File path and region
- `partialFingerprints` - Used to de-duplicate alerts across runs

`category` helps GitHub keep separate tools' results distinct.

**[SARIF Support](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning)** - SARIF reference

## Alerts Lifecycle

Alert states:

- **Open** - New or still present
- **Fixed** - Code change resolved the issue
- **Dismissed** - Closed with a reason

Dismissal reasons:
- **False positive** - Not actually a vulnerability
- **Used in tests** - Intentional for testing purposes
- **Won't fix** - Acknowledged but no remediation planned

Dismissals can be required to include a comment via organization rules.

## Branch Protection Integration

- Make code scanning a required status check so PRs cannot merge with unresolved new alerts
- Rulesets can gate merges by severity (e.g., block on critical/high new alerts)

**[Protecting Branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)** - Branch protection

## Copilot Autofix for Code Scanning

- Generates a suggested fix directly on the alert
- Developer reviews, edits, or accepts the suggestion
- Commits a patch via the PR
- Requires GHAS and an eligible plan
- Responsible-use note: always review AI-generated fixes for correctness and security implications

## CodeQL CLI

Useful for local development and CI pipelines outside default Actions flow.

```bash
# Create a database
codeql database create mydb --language=javascript --source-root=.

# Run the default query suite
codeql database analyze mydb javascript-code-scanning.qls --format=sarif-latest --output=results.sarif
```

Upload the SARIF using `upload-sarif` or the REST API.

## Common Configuration Patterns

### Ignore Paths

```yaml
- uses: github/codeql-action/init@v3
  with:
    config: |
      paths-ignore:
        - 'vendor/**'
        - '**/*.generated.ts'
```

### Increase Memory or Threads

```yaml
- uses: github/codeql-action/analyze@v3
  env:
    CODEQL_RAM: 8192
    CODEQL_THREADS: 4
```

### Self-Hosted Runners

```yaml
runs-on: [self-hosted, security]
```

## Key Exam Facts

- Default setup requires no YAML; advanced setup creates a workflow
- CodeQL supports C, C++, C#, Go, Java, Kotlin, JavaScript, TypeScript, Python, Ruby, Swift
- Query suites: `code-scanning` < `security-extended` < `security-and-quality`
- SARIF upload uses `github/codeql-action/upload-sarif@v3`
- Alert states: open, fixed, dismissed (with reason)
- Copilot Autofix suggests patches but human review remains required

## Study Checklist

- [ ] I can write a minimal CodeQL workflow from scratch
- [ ] I can choose the correct query suite for a scenario
- [ ] I can upload a SARIF file from a third-party tool
- [ ] I know all alert states and dismissal reasons
- [ ] I can describe Copilot Autofix and its responsible-use implications
