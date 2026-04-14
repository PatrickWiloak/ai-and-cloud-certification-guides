# GitHub Advanced Security (GHAS) Certification Fact Sheet

## Exam Overview

**Exam Name:** GitHub Advanced Security
**Duration:** 120 minutes
**Questions:** ~75 multiple choice and multiple response
**Passing Score:** 70%
**Cost:** $99 USD
**Delivery:** Online proctored (PSI)
**Prerequisites:** None (hands-on GHAS experience recommended)
**Validity:** 2 years

**[Official Exam Page](https://resources.github.com/learn/certifications/)** - Registration
**[GHAS Docs](https://docs.github.com/en/code-security)** - Product documentation
**[GHAS Product Page](https://github.com/features/security)** - Overview

## Target Audience

- Application security engineers and analysts
- DevSecOps and platform engineers
- Security-focused administrators of GitHub Enterprise
- Developers responsible for triaging and fixing security findings
- Consultants advising on GitHub security rollouts

## Domain 1: GHAS Overview, Licensing, and Enablement (15%)

### What GHAS Is

GitHub Advanced Security is a bundle of application security features integrated into GitHub Enterprise Cloud (GHEC), GitHub Enterprise Server (GHES), and selectively on GitHub Team. Features include:

- Code scanning (CodeQL + third-party SARIF)
- Secret scanning (detection, push protection, validity checks, custom patterns)
- Dependency review and GHAS UI integrations
- Security overview
- Security advisories

Dependabot alerts, dependency graph, and Dependabot updates are free on all repositories and are not gated by GHAS licensing for core functionality.

**[About GHAS](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)** - Overview

### Free vs Licensed

| Feature | Public repos | Private repos |
|---------|--------------|---------------|
| Dependency graph | Free | Free |
| Dependabot alerts | Free | Free |
| Dependabot security updates | Free | Free |
| Dependabot version updates | Free | Free |
| Code scanning (CodeQL + SARIF) | Free | GHAS required |
| Secret scanning (alerts + push protection) | Free | GHAS required |
| Security advisories | Free | Free |
| Security overview | Partial | GHAS required |

### Licensing Model

- GHAS is licensed per **active committer**
- An active committer is a user who pushed a commit to a GHAS-enabled private repository in the last 90 days
- Seats are consumed at the enterprise level
- Committers across many GHAS repos still consume only one seat

**[GHAS Billing](https://docs.github.com/en/billing/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security)** - Billing details

### Security Configurations

- Reusable bundles of GHAS settings that can be applied to many repositories
- Define which features are enabled (code scanning, secret scanning, push protection, etc.)
- Can be marked default for new repos in the org
- Replace legacy repo-by-repo manual enablement

## Domain 2: Code Scanning and CodeQL (25%)

### What Code Scanning Is

Code scanning finds vulnerabilities and errors in code by running static analysis and surfacing results as alerts in the repo's Security tab. It supports:

- **CodeQL** - GitHub's SAST engine; default scanner
- **Third-party tools** - Upload SARIF from any supported tool (Checkmarx, Semgrep, Snyk, etc.)

**[About Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)** - Overview

### Setup Options

| Option | What It Does |
|--------|--------------|
| **Default setup** | GitHub auto-detects languages and runs CodeQL with the standard query suite on push/PR/weekly schedule; no YAML required |
| **Advanced setup** | A workflow YAML under `.github/workflows/codeql.yml` gives full control over languages, queries, schedule, and custom steps |

Default setup is the fastest path. Advanced setup is needed for custom queries, extra build steps, or non-standard language configurations.

### CodeQL Languages

C, C++, C#, Go, Java, Kotlin, JavaScript, TypeScript, Python, Ruby, Swift

### Query Suites

| Suite | Scope |
|-------|-------|
| `code-scanning` | Default for code scanning alerts |
| `security-extended` | Adds lower-precision security queries |
| `security-and-quality` | Adds quality queries in addition to security |

Configure in the workflow:

```yaml
- uses: github/codeql-action/init@v3
  with:
    languages: javascript, python
    queries: security-extended
```

**[CodeQL Query Suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/codeql-query-suites)** - Suite reference

### SARIF Uploads

```yaml
- uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: results.sarif
```

Key SARIF fields: `ruleId`, `level`, `message`, `locations`, `partialFingerprints` (used for deduplication).

**[SARIF Support](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning)** - SARIF reference

### Alert States

- **Open** - New or still present
- **Fixed** - Removed by a subsequent commit
- **Dismissed** - Closed with reason: `false positive`, `won't fix`, `used in tests`

### Copilot Autofix

- Suggests a fix for a code scanning alert directly in the PR
- Developer reviews and commits the fix
- Available on GHAS for eligible plans

### Branch Protection Integration

- Require the code scanning check to pass before merging
- Severity thresholds can gate merges via rulesets

## Domain 3: Secret Scanning and Push Protection (20%)

### Secret Scanning

Scans repos for leaked credentials. Uses:

- **Partner patterns** - Regex-plus-validation provided by service providers (AWS, Stripe, GitHub, etc.)
- **GitHub patterns** - GitHub-supplied patterns
- **Custom patterns** - Defined by customers at repo/org/enterprise scope
- **Non-provider patterns** - Generic credentials (e.g., detected via ML) when enabled

**[About Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)** - Overview

### Push Protection

Blocks pushes that contain detected secrets before they reach the default branch. Works in:

- `git push` via command line
- Web editor and REST API commits

When blocked, the developer can:
1. Remove the secret and force push (or new commit)
2. Bypass with a reason: "it's used in tests," "it's a false positive," or "I'll fix it later"

Bypasses are auditable. Delegated bypass lets reviewers grant bypass instead of the developer.

**[Push Protection](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/push-protection-for-repositories-and-organizations)** - Guide

### Validity Checks

For supported partners, GitHub verifies whether a detected token is still live by calling the partner's verification API. State can be **Active** or **Inactive**.

### Custom Patterns

Define at repo, org, or enterprise level. Fields include:
- Pattern name
- Secret format (regex)
- Before secret / after secret patterns
- Additional match requirements (e.g., a companion value)

### Alert Lifecycle

- **Detected** - Secret identified
- **Revoked** - Partner auto-revoked, or manual revocation recorded
- **Reused elsewhere** - Same secret found in another location
- **Bypassed** - Push protection bypass recorded with reason

## Domain 4: Dependency Review and Dependabot (20%)

### Dependency Graph

GitHub derives dependencies from manifests and lockfiles across ecosystems (npm, pip, maven, gem, go, cargo, composer, NuGet, Actions, etc.).

### Dependabot Alerts

Notify when a dependency in the graph has a known vulnerability from the GitHub Advisory Database.

### Dependabot Security Updates

Automated PRs to bump a vulnerable dependency to a patched version. Enabled per repo or via security configurations.

### Dependabot Version Updates

Scheduled PRs to keep dependencies up to date even if no vulnerability is known. Configured via `.github/dependabot.yml`.

Example:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "daily"
```

**[Dependabot Configuration](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference)** - `dependabot.yml` reference

### Dependency Review

- UI shows added/removed dependencies on a PR
- Action: `actions/dependency-review-action` blocks PRs that add vulnerable dependencies or disallowed licenses

```yaml
- uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: moderate
    deny-licenses: GPL-3.0, AGPL-3.0
```

### GitHub Advisory Database

Curated database of vulnerabilities with GHSA IDs. Maps to CVE identifiers when available. Drives Dependabot alerts.

## Domain 5: Security Advisories and Vulnerability Management (10%)

### Repository Security Advisories

- Private space for maintainers to coordinate on a vulnerability
- Private fork for writing and testing the fix
- Request a CVE from GitHub if none exists
- Publish the advisory; it appears in the Global Advisory Database

**[About Advisories](https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/about-repository-security-advisories)** - Advisory guide

### Private Vulnerability Reporting

- Enabled at repo or org level
- Allows external researchers to report privately through GitHub UI
- Creates a draft advisory for maintainers

### Global Advisory Database

- Public, searchable list of GHSA entries
- Sourced from maintainers, CVE feeds, and GitHub Security Lab
- Powers Dependabot alerts

### Severity and Scoring

- CVSS v3.x base score
- GitHub severity buckets: Low, Moderate, High, Critical
- CWE mapping for the vulnerability class

## Domain 6: GHAS Administration and Enterprise Rollout (10%)

### Security Configurations

Bundled security settings applied to many repos. Managed at org level.

### Security Overview

Org and enterprise dashboards showing:
- Open code scanning alerts by severity
- Dependabot alerts by ecosystem
- Secret scanning alerts
- Coverage: which repos have which features enabled

### Audit Logs

Events include:
- `security_configuration.create/update/apply`
- `code_scanning.*` alert events
- `secret_scanning.*` alert and bypass events
- `dependabot_alert.*` state transitions

### API Access

| API | Purpose |
|-----|---------|
| `GET /repos/{owner}/{repo}/code-scanning/alerts` | List code scanning alerts |
| `GET /repos/{owner}/{repo}/secret-scanning/alerts` | List secret scanning alerts |
| `GET /repos/{owner}/{repo}/dependabot/alerts` | List Dependabot alerts |
| `GET /orgs/{org}/secret-scanning/alerts` | Org-wide secret scanning |
| Webhooks | `code_scanning_alert`, `secret_scanning_alert`, `dependabot_alert` |

## Exam Tips

### High-Priority Topics (by weight)
1. Code Scanning and CodeQL (25%) - default vs advanced setup, query suites, SARIF
2. Secret Scanning and Push Protection (20%) - partner vs custom, bypass flow
3. Dependency Review and Dependabot (20%) - `dependabot.yml`, security vs version updates
4. GHAS Overview and Licensing (15%) - active committer, free vs licensed
5. Security Advisories (10%) - repo advisories, Global Advisory Database
6. Administration (10%) - security configurations, overview, audit logs

### Key Differentiators to Remember
- **Default setup** vs **advanced setup** - Default is auto-YAML-less; advanced is workflow-driven
- **Dependabot security updates** vs **version updates** - Security updates are vulnerability-driven; version updates are schedule-driven
- **Partner patterns** vs **custom patterns** - Partner is vendor-supplied; custom is customer-defined
- **Repo advisory** vs **Global Advisory Database** - Repo advisory is coordination space; database is the public feed
- **Code scanning alerts** (code issues) vs **Dependabot alerts** (dependency CVEs) vs **Secret scanning alerts** (leaked credentials)
