# GHAS Overview and Licensing

## What GHAS Is

GitHub Advanced Security (GHAS) is a set of application security features built into the GitHub platform. It brings together static analysis, secrets detection, supply chain controls, and vulnerability management under a single license on GitHub Enterprise Cloud and GitHub Enterprise Server.

**[About GHAS](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)** - Official overview
**[GHAS Product Page](https://github.com/features/security)** - Feature summary

## Feature Inventory

GHAS bundles the following features:

- **Code scanning** - Static analysis using CodeQL or any SARIF-compatible tool
- **Secret scanning** - Detection of known secret formats, plus push protection
- **Push protection** - Blocks pushes containing detected secrets
- **Custom patterns** - Customer-defined secret patterns
- **Validity checks** - Verifies whether detected tokens are still active (where supported)
- **Security overview** - Org- and enterprise-level dashboards and reporting
- **Security configurations** - Reusable bundles for applying GHAS features at scale
- **Advanced secret scanning options** - Delegated bypass, non-provider patterns, etc.

Features adjacent to GHAS but free everywhere:

- Dependency graph
- Dependabot alerts
- Dependabot security updates
- Dependabot version updates
- Repository security advisories
- Global Advisory Database

## Free vs Licensed

| Feature | Public repos | Private repos (paid plans) |
|---------|--------------|---------------------------|
| Dependency graph | Free | Free |
| Dependabot alerts | Free | Free |
| Dependabot security/version updates | Free | Free |
| Repository security advisories | Free | Free |
| Code scanning (CodeQL + SARIF) | Free | GHAS required |
| Secret scanning (alerts + push protection) | Free | GHAS required |
| Security overview | Partial | GHAS required |
| Custom patterns | Free | GHAS required |

## Licensing Model

### Per-Committer Licensing

- A GHAS seat is consumed per **active committer** per enterprise
- An **active committer** is a user who has pushed a commit to a GHAS-enabled private repository in the last 90 days
- A user who commits to many GHAS-enabled repos still consumes only one seat at the enterprise level
- Committers to public repos do not consume GHAS seats

### Seat Counting Examples

- 500 enterprise users, 120 pushed to GHAS-enabled private repos in the last 90 days: **120 seats**
- A developer who made one commit 95 days ago: **0 seats** (not active within 90 days)
- A developer who pushed to 10 different GHAS-enabled repos: **1 seat**

**[GHAS Billing](https://docs.github.com/en/billing/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security)** - Billing details

## Where GHAS Runs

- **GitHub Enterprise Cloud (GHEC)** - The most commonly tested deployment
- **GitHub Enterprise Server (GHES)** - Self-hosted; GHAS features are available but may lag GHEC
- **GitHub Team** - Some features (like secret scanning with push protection) are available, but full GHAS is an enterprise feature

## Enabling GHAS

### Repository-Level Enablement

1. Repo Settings > Code security
2. Toggle each feature: code scanning, secret scanning, push protection, etc.
3. Features that require GHAS are gated; the UI indicates whether a license exists

### Organization-Level Enablement

1. Org Settings > Code security and analysis
2. Toggle defaults for new repos
3. Apply to existing repos or rely on security configurations

### Security Configurations

Security configurations are reusable bundles of security feature settings that can be applied across many repositories.

**A configuration specifies:**
- Which features are enabled (code scanning, secret scanning, push protection, dependency graph, Dependabot, etc.)
- Code scanning setup type (default or advanced)
- Auto-apply rules for new repos
- Enforcement settings (required vs recommended)

**Benefits:**
- Eliminates repo-by-repo clicking
- Enforces consistent policy
- Enables bulk application and auditability
- Can be marked as the default for all new repositories

**[Security Configurations](https://docs.github.com/en/code-security/securing-your-organization/introduction-to-securing-your-organization-at-scale/about-enabling-security-features-at-scale)** - Configuration guide

## Roles and Permissions

| Role | Typical Responsibility |
|------|------------------------|
| Repository admin | Enable/disable security features for a repo |
| Organization owner | Create security configurations, apply to repos |
| Enterprise owner | Manage GHAS billing, enterprise-wide policies |
| Security manager | Read security alerts across org repos |
| Member | Triage and fix alerts in repos they have access to |

## Security Manager Role

- A custom org role with read access to all security alerts across the org
- Does not grant code write permissions
- Useful for security engineers who need visibility without broad access

## Audit Log Events

Events you will see related to GHAS:

- `repo.add_advanced_security` / `repo.remove_advanced_security`
- `security_configuration.create/update/apply`
- `code_scanning.alert_*`
- `secret_scanning.alert_*`
- `secret_scanning_push_protection.bypass`
- `dependabot_alert.*`

## Common Pitfalls

- Thinking all users consume a GHAS seat; only active committers do
- Believing public repo scanning requires GHAS; it does not
- Enabling features repo by repo when a security configuration would be faster
- Forgetting that Dependabot works without GHAS

## Key Exam Facts

- GHAS is per-active-committer; 90-day push window; one seat per committer per enterprise
- Public repos get code scanning and secret scanning for free
- Private repos require GHAS for code scanning, secret scanning, push protection, custom patterns
- Dependabot features are free on both public and private repos
- Security configurations are the recommended way to apply GHAS at scale

## Study Checklist

- [ ] I can define an active committer
- [ ] I can list every feature included in GHAS
- [ ] I know which features are free on public repos
- [ ] I can describe a security configuration and its benefits
- [ ] I can walk through enabling GHAS at repo and org levels
