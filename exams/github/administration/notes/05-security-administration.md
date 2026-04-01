# Security Administration - GitHub Administration

## Overview

Security administration covers 15% of the exam (Advanced Security) plus aspects of Enterprise Administration (15%). This domain focuses on GitHub Advanced Security (GHAS) rollout, code scanning, secret scanning, Dependabot, and the security overview dashboard.

**[📖 GitHub Advanced Security](https://docs.github.com/en/enterprise-cloud@latest/get-started/learning-about-github/about-github-advanced-security)** - GHAS overview

## GitHub Advanced Security (GHAS)

### What GHAS Includes

| Feature | Public Repos | Private Repos (GHAS License) |
|---------|-------------|------------------------------|
| Code scanning | Free | Requires GHAS |
| Secret scanning | Free | Requires GHAS |
| Secret scanning push protection | Free | Requires GHAS |
| Dependency review | Free | Requires GHAS |
| Security overview | N/A | Requires GHAS |
| Custom auto-triage rules | N/A | Requires GHAS |

**Note**: Dependabot (alerts, updates, security updates) is free for all repositories.

### GHAS Licensing

**[📖 GHAS Billing](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security)** - License model

- Licensed per **active committer** to private/internal repos with GHAS enabled
- Active committer: Anyone who authored a commit in the last 90 days
- A user counts once even if committing to multiple GHAS-enabled repos
- Enable per-repository or at organization level
- Monitor usage in enterprise billing settings

### GHAS Rollout Strategy

**[📖 GHAS Rollout](https://docs.github.com/en/enterprise-cloud@latest/code-security/adopting-github-advanced-security-at-scale)** - Deployment guide

**Phased approach (recommended):**
1. **Pilot**: Enable on 5-10 high-risk repositories
2. **Triage initial findings**: Address critical alerts, tune false positives
3. **Expand**: Roll out to additional teams/repos incrementally
4. **Enterprise-wide**: Enable across all repositories
5. **Enforce**: Require security checks in branch protection/rulesets

## Code Scanning

**[📖 Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)** - Static analysis

### How Code Scanning Works

- Static Application Security Testing (SAST)
- Default tool: **CodeQL** - semantic analysis engine by GitHub
- Runs as a GitHub Actions workflow
- Analyzes code on push, PR, and schedule
- Results appear as alerts in the Security tab

### CodeQL

**[📖 CodeQL](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql)** - CodeQL analysis

- Supported languages: C/C++, C#, Go, Java/Kotlin, JavaScript/TypeScript, Python, Ruby, Swift
- Query suites: `security-extended` (default), `security-and-quality`
- Custom queries: Write organization-specific queries
- Default setup: Automatic configuration (recommended for most repos)
- Advanced setup: Customizable workflow file for complex needs

### Code Scanning Policies

**Organization-level:**
- Set default CodeQL configuration for all repositories
- Enforce code scanning as required status check via rulesets
- Configure alert severity thresholds for blocking merges

**Enterprise-level:**
- Enforce code scanning across all organizations
- Set default security configurations
- Require code scanning results in rulesets

### Third-Party Tools

- Upload SARIF (Static Analysis Results Interchange Format) files
- Integrate tools: Snyk, Checkmarx, SonarQube, Semgrep
- Results appear alongside CodeQL findings
- Use `github/codeql-action/upload-sarif` action

## Secret Scanning

**[📖 Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)** - Credential detection

### How Secret Scanning Works

- Scans repository content (commits, issues, PRs, discussions) for known secret patterns
- Partners program: Notify service providers when their tokens are found
- 200+ secret patterns from 100+ service providers
- Custom patterns: Define organization-specific patterns (regex)

**[📖 Secret Scanning Patterns](https://docs.github.com/en/code-security/secret-scanning/introduction/supported-secret-scanning-patterns)** - Supported patterns

### Push Protection

**[📖 Push Protection](https://docs.github.com/en/code-security/secret-scanning/introduction/about-push-protection)** - Prevent secret commits

- Blocks pushes that contain detected secrets
- Developer sees the detected secret and can:
  - Remove the secret and push again
  - Mark as false positive
  - Mark as used in tests
  - Bypass with justification (if allowed)
- Admin controls:
  - Enable/disable push protection per repository or organization
  - Allow bypasses (with or without approval requirement)
  - Delegated bypass: Require reviewer approval to bypass

### Secret Scanning Administration

- Enable at repository, organization, or enterprise level
- Custom patterns: Define regex patterns for proprietary secrets
- Dry-run custom patterns before enforcing
- Alert notification: Repository admins, security managers, custom recipients
- Validity checks: Verify if detected secret is still active (for supported providers)

## Dependabot

**[📖 Dependabot](https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide)** - Dependency management

### Dependabot Features

| Feature | Description | Configuration |
|---------|-------------|---------------|
| Dependabot alerts | Notify about vulnerable dependencies | Automatic (GitHub Advisory Database) |
| Dependabot security updates | Auto-create PRs for vulnerable dependencies | Enable in settings |
| Dependabot version updates | Auto-create PRs for outdated dependencies | `dependabot.yml` config file |

### Dependabot Alerts

**[📖 Dependabot Alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)** - Vulnerability alerts

- Generated from GitHub Advisory Database
- Severity levels: Critical, High, Medium, Low
- Auto-dismiss: Configure rules to auto-dismiss low-risk alerts
- Grouped alerts: Group related vulnerabilities
- Notification: Email, web, mobile based on user preferences

### Dependabot Configuration

**[📖 Dependabot Config](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)** - dependabot.yml

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "org/security-team"
    labels:
      - "dependencies"
    open-pull-requests-limit: 10
```

### Auto-Triage Rules

**[📖 Auto-Triage](https://docs.github.com/en/code-security/dependabot/dependabot-auto-triage-rules/about-dependabot-auto-triage-rules)** - Automated alert management

- Automatically dismiss alerts based on criteria
- GitHub-curated rules: Dismiss alerts unlikely to be exploitable
- Custom rules: Define based on severity, ecosystem, scope (runtime/dev)
- Reduce alert fatigue for security teams

## Security Overview Dashboard

**[📖 Security Overview](https://docs.github.com/en/enterprise-cloud@latest/code-security/security-overview/about-security-overview)** - Enterprise security view

### Dashboard Features

- Enterprise-wide and organization-wide security posture
- Views:
  - **Risk**: Repositories with open security alerts
  - **Coverage**: Which repos have security features enabled
  - **Alert trends**: Alert creation and resolution over time
- Filter by: Organization, repository, severity, tool, alert state
- Export data for compliance reporting

### Key Metrics

- Number of open critical/high alerts
- Mean time to remediation
- Security feature enablement percentage
- Alert trends (improving or degrading)
- Repositories with no security features enabled

## Audit Log

**[📖 Audit Log](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise)** - Activity tracking

### Audit Log Features

- Records admin and security events across the enterprise
- Searchable via web UI, API, and GraphQL
- Events include: Authentication, repository changes, policy changes, Actions runs
- Retention: 180 days (web), indefinite via streaming
- Audit log streaming: Send to Azure Blob, Azure Event Hubs, AWS S3, Datadog, Google Cloud, Splunk

**[📖 Audit Log Streaming](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise)** - Log streaming

### Key Audit Events

| Category | Example Events |
|----------|---------------|
| Authentication | SSO login, 2FA changes, PAT creation |
| Repository | Create, delete, visibility change, transfer |
| Organization | Member add/remove, policy change |
| Actions | Workflow run, secret access, runner registration |
| Security | GHAS enable, alert dismiss, push protection bypass |

## Common Exam Patterns

1. **"Prevent secrets from being committed"** - Push protection
2. **"Auto-fix vulnerable dependencies"** - Dependabot security updates
3. **"Enterprise security posture"** - Security overview dashboard
4. **"Roll out GHAS cost-effectively"** - Phased rollout, start with high-risk repos
5. **"Custom secret patterns"** - Organization-level custom patterns with regex
6. **"Code scanning for all repos"** - Default CodeQL setup + required in rulesets
7. **"Audit log retention beyond 180 days"** - Audit log streaming to external storage
8. **"Block merges with critical vulnerabilities"** - Code scanning as required status check
