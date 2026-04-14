# GitHub Advanced Security (GHAS) Certification Exam Guide

## Exam Overview

The GitHub Advanced Security (GHAS) certification validates the ability to configure, operate, and remediate findings using GitHub's application security features: code scanning with CodeQL, secret scanning with push protection, dependency review, Dependabot, and security advisories. It targets security engineers, DevSecOps practitioners, and platform administrators.

### Exam Details
- **Exam Name:** GitHub Advanced Security
- **Duration:** 120 minutes
- **Format:** Multiple choice and multiple response
- **Number of Questions:** ~75 questions
- **Passing Score:** 70%
- **Cost:** $99 USD
- **Delivery:** Online proctored via PSI
- **Prerequisites:** None required; recommended to have GHAS hands-on experience and familiarity with Git, GitHub, and CI concepts
- **Validity:** 2 years
- **Retake Policy:** 24-hour wait for first retake, 14 days thereafter

### Official Resources
- **[GitHub Certifications](https://resources.github.com/learn/certifications/)** - Program overview
- **[Code Security Docs](https://docs.github.com/en/code-security)** - Complete GHAS documentation
- **[GitHub Advanced Security](https://github.com/features/security)** - Product page
- **[CodeQL Documentation](https://codeql.github.com/)** - CodeQL resources
- **[GitHub Skills](https://skills.github.com/)** - Interactive courses

## Exam Domains

### Domain 1: GHAS Overview, Licensing, and Enablement (15%)

Covers what GHAS is, where it runs, and how it is licensed and enabled.

**Key Topics:**
- GHAS as a feature set on GitHub Enterprise Cloud, GitHub Enterprise Server, and GitHub Team (select features)
- Per-committer licensing model; definition of active committer
- Features included: code scanning, secret scanning, push protection, dependency review, Dependabot, security overview
- Feature availability per plan and SKU (GHAS on GHEC vs GHES)
- Enabling security features at organization and repository scope
- Security configurations (reusable security policy bundles)

**What to Study:**
- Who counts as an active committer and when a seat is consumed
- Which features are free on public repos vs paid on private
- The purpose and scope of security configurations

### Domain 2: Code Scanning and CodeQL (25%)

The largest domain. Covers code scanning setup, CodeQL queries, third-party tools, and alert triage.

**Key Topics:**
- Code scanning architecture: CodeQL analysis, third-party SARIF upload, default vs advanced setup
- Supported languages for CodeQL (C/C++, C#, Go, Java/Kotlin, JavaScript/TypeScript, Python, Ruby, Swift)
- Default setup (auto-configured, GitHub-managed) vs advanced setup (workflow YAML)
- CodeQL packs, queries, and query suites (code-scanning, security-extended, security-and-quality)
- SARIF uploads from third-party tools
- Alert states: open, fixed, dismissed (won't fix, false positive, used in tests)
- Autofix for code scanning alerts (Copilot Autofix)
- Branch protection and required status checks tied to scanning

**What to Study:**
- Difference between default setup and advanced setup
- How to switch between setups
- Query suite differences and when to use each
- How Copilot Autofix generates fixes and what remains the developer's responsibility

### Domain 3: Secret Scanning and Push Protection (20%)

Covers detecting and blocking leaked secrets.

**Key Topics:**
- Partner patterns (vendor-provided regexes) vs GitHub patterns vs custom patterns
- Push protection: blocks pushes containing detected secrets
- Delegated bypass: reviewers can grant bypass
- Validity checks (GitHub verifies whether a detected token is still live where supported)
- Non-provider patterns (generic credentials, e.g., detected by Copilot-powered experiences)
- Alert lifecycle: detected, revoked, reused, bypassed
- Notifications to partners for automatic revocation

**What to Study:**
- Difference between partner, GitHub, and custom patterns
- How push protection integrates with git push and the web editor
- How to configure and audit bypasses
- How delegated bypass works at scale

### Domain 4: Dependency Review and Dependabot (20%)

Covers supply chain security.

**Key Topics:**
- Dependency graph (how GitHub derives dependencies from manifests and lockfiles)
- Dependabot alerts (for known vulnerable dependencies in the graph)
- Dependabot security updates (automated PRs to remediate vulnerabilities)
- Dependabot version updates (scheduled PRs to bump dependency versions)
- Dependency review action and the dependency review PR block
- GitHub Advisory Database and CVE/GHSA identifiers
- License compliance via dependency review
- Grouped updates; repository and ecosystem scoping

**What to Study:**
- The difference between Dependabot security updates and version updates
- `dependabot.yml` configuration syntax: ecosystems, schedule, directories, groups, reviewers, labels
- How dependency review blocks PRs introducing vulnerable dependencies
- Advisory levels and severity mapping

### Domain 5: Security Advisories and Vulnerability Management (10%)

Covers advisories, CVEs, and coordinated disclosure.

**Key Topics:**
- Repository security advisories (private forks for coordinated disclosure)
- Global Advisory Database (GHSA entries, CVE mapping)
- Publishing an advisory and requesting a CVE
- Private vulnerability reporting workflow
- SECURITY.md and how maintainers communicate expectations
- Severity scoring (CVSS), CWE mapping, affected version ranges

**What to Study:**
- End-to-end flow for reporting, triaging, fixing, and publishing an advisory
- Differences between repo-level advisories and the Global Advisory Database
- Enabling private vulnerability reporting at org level

### Domain 6: GHAS Administration and Enterprise Rollout (10%)

Covers enterprise-level rollout, reporting, and operations.

**Key Topics:**
- Security configurations (apply GHAS features in a managed way)
- Security overview (alerts across orgs/repos, risk posture)
- Audit logs and security-relevant events
- API access to alerts (REST and GraphQL)
- Webhooks for alerts
- Exemptions, auto-dismiss rules, and integration with SIEM/ticketing

**What to Study:**
- How security configurations differ from manual repo enablement
- The security overview dashboard's widgets and filters
- API endpoints for listing code scanning, secret scanning, and Dependabot alerts

## Key Concepts to Master

### Product Knowledge
1. Feature matrix: free on public, GHAS-licensed on private
2. Active committer definition; seat counting
3. Code scanning setup options (default vs advanced)
4. CodeQL query suite hierarchy (code-scanning < security-extended < security-and-quality)

### Operational Skills
1. Writing and tuning CodeQL queries; using packs
2. Configuring secret scanning custom patterns
3. Writing `dependabot.yml` for multi-ecosystem repos
4. Triage patterns for each alert type

### Administration
1. Organization-wide enablement via security configurations
2. Security overview dashboards and filters
3. API-based reporting and SIEM integration

## Study Approach

### Recommended Path
1. **Week 1:** GHAS overview and licensing; secret scanning basics (Domains 1, 3)
2. **Week 2:** Code scanning with CodeQL (Domain 2)
3. **Week 3:** Dependency management, Dependabot, advisories (Domains 4, 5)
4. **Week 4:** Administration, security configurations, and review (Domain 6 plus review)
5. **Week 5:** Mock exams and remediation

### Hands-On Practice
- Enable code scanning on a sample vulnerable repo
- Upload a third-party SARIF file to code scanning
- Write a simple CodeQL query
- Enable secret scanning and push protection; attempt to push a fake AWS key
- Create a `dependabot.yml` with version and security updates
- Create a repository security advisory and walk through publication

### Study Materials
- **[Code Security Guides](https://docs.github.com/en/code-security)** - Primary docs
- **[CodeQL Learning Lab](https://codeql.github.com/docs/writing-codeql-queries/)** - Writing queries
- **[Dependabot docs](https://docs.github.com/en/code-security/dependabot)** - Dependabot reference
- **[Secret scanning docs](https://docs.github.com/en/code-security/secret-scanning)** - Secret scanning
- **[GitHub Skills - Security](https://skills.github.com/)** - Interactive labs

### Tips for Success
- Domain 2 (Code Scanning) is the largest; allocate the most time there
- Learn the CLI behavior of secret scanning and push protection, not just the UI
- Memorize `dependabot.yml` fields; exam questions often show partial YAML
- Understand how SARIF uploads work and what fields they require
- Be precise about which features are public-repo free vs GHAS-licensed private
