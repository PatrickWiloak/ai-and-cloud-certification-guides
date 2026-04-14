# Dependency Review and Dependabot

## Supply Chain Security Features

GitHub's supply chain surface has four pillars:

1. **Dependency graph** - Inventory of declared dependencies
2. **Dependabot alerts** - Vulnerability alerts for graph dependencies
3. **Dependabot updates** - Automated PRs (security updates and version updates)
4. **Dependency review** - PR-time gating of dependency changes

All four work on both public and private repos without GHAS licensing for core functionality.

**[About Supply Chain Security](https://docs.github.com/en/code-security/supply-chain-security)** - Overview

## Dependency Graph

GitHub parses manifests and lockfiles to build a graph of direct and transitive dependencies.

### Supported Ecosystems

- npm (`package.json`, `package-lock.json`, `yarn.lock`)
- pip (`requirements.txt`, `pyproject.toml`, `poetry.lock`, `Pipfile.lock`)
- Maven (`pom.xml`)
- Gradle (`build.gradle`, `build.gradle.kts`)
- RubyGems (`Gemfile`, `Gemfile.lock`)
- Go modules (`go.mod`, `go.sum`)
- Cargo (`Cargo.toml`, `Cargo.lock`)
- Composer (`composer.json`, `composer.lock`)
- NuGet (`.csproj`, `packages.config`)
- GitHub Actions workflows (`.github/workflows/*.yml`)
- Docker (experimental for certain base images)

Enable under Repo Settings > Code security.

## Dependabot Alerts

Alerts are raised when the Advisory Database has a known vulnerability matching a dependency in the graph.

### Alert Fields

- Advisory (GHSA ID, CVE ID)
- Severity (Low, Moderate, High, Critical)
- Affected package and version range
- Safe version (if known)
- Patched versions

### State Transitions

- Open
- Dismissed (fix started, no bandwidth, tolerable risk, inaccurate, not used)
- Auto-dismissed (when the vulnerability is fixed in a later commit)
- Fixed

**[About Dependabot Alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)** - Alert reference

## Dependabot Security Updates

- Automatically open PRs to bump a vulnerable dep to a patched version
- Triggered by Dependabot alerts
- Enabled per repo or via security configuration

## Dependabot Version Updates

- Scheduled PRs to keep deps up to date regardless of vulnerabilities
- Configured via `.github/dependabot.yml`

### `dependabot.yml` Structure

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "06:00"
      timezone: "America/Los_Angeles"
    open-pull-requests-limit: 10
    reviewers:
      - "myorg/platform-team"
    assignees:
      - "octocat"
    labels:
      - "dependencies"
    commit-message:
      prefix: "chore(deps)"
      include: "scope"
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
      security:
        applies-to: security-updates
        patterns: ["*"]
    ignore:
      - dependency-name: "express"
        versions: ["5.x"]
    allow:
      - dependency-type: "direct"
```

**[Dependabot Options Reference](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference)** - Full schema

### Key Fields

| Field | Purpose |
|-------|---------|
| `package-ecosystem` | Which package manager (npm, pip, maven, etc.) |
| `directory` | Location of the manifest within the repo |
| `schedule.interval` | `daily`, `weekly`, or `monthly` |
| `open-pull-requests-limit` | Cap to avoid PR flood |
| `groups` | Bundle multiple updates into one PR |
| `ignore` | Skip specific deps or versions |
| `allow` | Restrict to direct deps or specific names |
| `reviewers` / `assignees` / `labels` | PR metadata |

### Grouped Updates

Groups combine related updates into a single PR. Useful for monorepos or to reduce review load. The `applies-to: security-updates` option groups security updates specifically.

## Dependency Review

### PR UI

When a PR touches a manifest or lockfile, a Dependency Review UI shows:
- Added, removed, and updated dependencies
- Vulnerabilities introduced
- License changes

### Dependency Review Action

Blocks PRs that introduce problematic dependencies:

```yaml
name: Dependency Review
on: pull_request

jobs:
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/dependency-review-action@v4
        with:
          fail-on-severity: moderate
          deny-licenses: GPL-3.0, AGPL-3.0
          allow-licenses: MIT, Apache-2.0, BSD-3-Clause
          comment-summary-in-pr: true
```

**Inputs:**
- `fail-on-severity` - Block PRs with vulnerabilities at or above this level
- `allow-licenses` / `deny-licenses` - License gating
- `comment-summary-in-pr` - Post a summary comment
- `warn-only` - Surface findings without failing

**[Dependency Review](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review)** - Review guide

## GitHub Advisory Database

- Public database of vulnerabilities (GHSA entries)
- Maps to CVE identifiers when available
- Sourced from maintainers, security researchers, and feeds
- Drives Dependabot alerts

**[Advisory Database](https://github.com/advisories)** - Browse advisories

## Severity Levels

| Severity | Typical CVSS |
|----------|--------------|
| Critical | 9.0-10.0 |
| High | 7.0-8.9 |
| Moderate | 4.0-6.9 |
| Low | 0.1-3.9 |

## Alert Routing

- Repo admins and security managers receive notifications
- Webhook event `dependabot_alert`
- REST API: `GET /repos/{owner}/{repo}/dependabot/alerts`

## Common Pitfalls

- Assuming version updates fix vulnerabilities (no; security updates do)
- Forgetting `directory` per ecosystem entry in `dependabot.yml`
- Ignoring transitive dependencies (they are in the graph and raise alerts)
- Treating dependency review as a replacement for Dependabot alerts (they are complementary)

## End-to-End Example

Goal: a monorepo with npm (frontend and backend) and GitHub Actions.

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/frontend"
    schedule: { interval: "weekly" }
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
  - package-ecosystem: "npm"
    directory: "/backend"
    schedule: { interval: "weekly" }
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule: { interval: "daily" }
```

Plus a PR workflow:

```yaml
name: Dep Review
on: pull_request
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/dependency-review-action@v4
        with:
          fail-on-severity: high
```

## Key Exam Facts

- `dependabot.yml` requires `version: 2` and `package-ecosystem`, `directory`, and `schedule.interval` per entry
- Security updates are CVE-driven; version updates are schedule-driven
- Dependency review action blocks PRs on severity or license
- Dependabot alerts are free on all repos; push protection for supply chain is not a thing (secret scanning is)
- Advisory Database drives all Dependabot alerts

## Study Checklist

- [ ] I can write `dependabot.yml` for a multi-ecosystem repo from memory
- [ ] I can explain the difference between security updates and version updates
- [ ] I can configure `dependency-review-action` with severity and license rules
- [ ] I know the four supply chain features and how they relate
- [ ] I can read a Dependabot alert and identify severity and fix version
