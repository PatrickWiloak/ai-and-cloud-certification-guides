# GHAS Administration and Enterprise Rollout

## Administrative Surface

Enterprise GHAS rollout involves enabling features across many repositories consistently, monitoring alerts across the organization, integrating with existing security tools, and governing usage.

## Security Configurations

Security configurations are the primary mechanism for enabling GHAS at scale.

**[Security Configurations](https://docs.github.com/en/code-security/securing-your-organization/introduction-to-securing-your-organization-at-scale/about-enabling-security-features-at-scale)** - Official guide

### What a Configuration Specifies

- Dependency graph on/off
- Dependabot alerts on/off
- Dependabot security updates on/off
- Code scanning: disabled, default setup, or advanced setup placeholder
- Secret scanning and push protection on/off
- Custom pattern push protection behavior
- Non-provider secret patterns on/off
- Private vulnerability reporting on/off

### Applying a Configuration

1. Create at org level
2. Apply to:
   - Selected repositories
   - All repositories (with or without overrides)
   - New repositories as they are created
3. Changes propagate asynchronously

### Default Configurations

- **GitHub-recommended** - A preset with sensible defaults
- **Custom** - Org-specific configurations

Mark a configuration as default for new repositories to automate onboarding.

## Organization-Level Enablement Options

For each feature, org admins can:
- Enable/disable for all new repos
- Enable/disable for all existing repos
- Leave control to individual repo admins

For advanced setup code scanning, repos keep their own workflow YAML.

## Security Overview

**[Security Overview Docs](https://docs.github.com/en/code-security/security-overview/about-the-security-overview)** - Overview

### What It Shows

- Open alerts by type (code scanning, secret scanning, Dependabot)
- Alerts by severity (Critical, High, Moderate, Low)
- Coverage: which repos have which features enabled
- Enforcement gaps: repos without required features

### Filters

- Repository, team, owner
- Feature
- Time range
- Severity

### Audiences

- **Security managers** - Read-only visibility across all repos in the org
- **Org owners** - Full admin
- **Enterprise owners** - Cross-org view at enterprise level

## Audit Logs

Security-related events include:

| Event | Meaning |
|-------|---------|
| `repo.add_advanced_security` | GHAS enabled on a repo |
| `repo.remove_advanced_security` | GHAS disabled |
| `security_configuration.create` | New configuration |
| `security_configuration.update` | Configuration changed |
| `security_configuration.apply` | Applied to repos |
| `code_scanning.alert_created` | New code scanning alert |
| `code_scanning.alert_fixed` | Alert fixed |
| `code_scanning.alert_dismissed` | Alert dismissed |
| `secret_scanning.alert_created` | Secret alert |
| `secret_scanning_push_protection.bypass` | Push protection bypassed |
| `dependabot_alert.create/resolve` | Dependabot state changes |

Forward audit logs to a SIEM via streaming export or polling.

**[Audit Log Reference](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/reviewing-the-audit-log-for-your-organization)** - Audit log guide

## REST API Highlights

### Code Scanning

```
GET /repos/{owner}/{repo}/code-scanning/alerts
GET /orgs/{org}/code-scanning/alerts
PATCH /repos/{owner}/{repo}/code-scanning/alerts/{alert_number}
```

### Secret Scanning

```
GET /repos/{owner}/{repo}/secret-scanning/alerts
GET /orgs/{org}/secret-scanning/alerts
PATCH /repos/{owner}/{repo}/secret-scanning/alerts/{alert_number}
```

### Dependabot

```
GET /repos/{owner}/{repo}/dependabot/alerts
GET /orgs/{org}/dependabot/alerts
PATCH /repos/{owner}/{repo}/dependabot/alerts/{alert_number}
```

### Security Configurations

```
GET /orgs/{org}/code-security/configurations
POST /orgs/{org}/code-security/configurations
POST /orgs/{org}/code-security/configurations/{config_id}/attach
```

## Webhooks

Useful events:

- `code_scanning_alert`
- `secret_scanning_alert`
- `secret_scanning_alert_location`
- `dependabot_alert`
- `repository_advisory`

Route to a ticketing or SOC platform for auto-triage.

## Exemptions and Auto-Dismissal

- Dismissal reasons (false positive, won't fix, used in tests) provide a trail
- Auto-dismiss rules can dismiss alerts matching specific criteria (by severity, rule ID, etc.)
- Keep dismissals auditable and require comments where possible

## SIEM and Ticketing Integration

Patterns:

1. **Audit log streaming** - Forward Copilot, security, and admin events to SIEM
2. **Alerts via API** - Pull alerts into ticketing platform (Jira, ServiceNow)
3. **Webhooks** - Real-time push for alerts
4. **SARIF repositories** - Export SARIF for long-term analysis

## Rollout Playbook

### Phase 1: Baseline (Weeks 1-2)

- Identify GHAS-eligible orgs
- Enable dependency graph and Dependabot alerts on all repos (free)
- Communicate roadmap to engineering leaders

### Phase 2: Pilot (Weeks 3-6)

- Select 3-5 pilot repos representing major languages and frameworks
- Enable default code scanning and secret scanning with push protection
- Triage initial alert backlog
- Tune custom patterns and dismissal rules

### Phase 3: Broad Rollout (Weeks 7-12)

- Build a security configuration with the pilot-validated settings
- Apply to all repos via configuration
- Mark configuration as default for new repos
- Train developers on triage workflows

### Phase 4: Optimize (Ongoing)

- Review security overview weekly
- Tune query suites and custom queries
- Add custom patterns as new token formats appear
- Integrate with SIEM and ticketing
- Report to leadership on MTTR, coverage, and risk trends

## Metrics That Matter

- Alert MTTR (mean time to remediation) by severity
- Coverage (% of eligible repos with feature enabled)
- Open critical and high alerts (raw counts and trend)
- Push protection bypass rate (should be low)
- CVE-to-fix time for dependencies

## Common Pitfalls

- Turning on GHAS without a plan, creating alert fatigue
- Skipping security configurations and clicking repo by repo
- Not assigning the security manager role
- Failing to integrate with existing ticketing
- Ignoring audit logs for bypasses and dismissals

## Key Exam Facts

- Security configurations are the recommended way to enable GHAS at scale
- Security overview is the org/enterprise dashboard for alerts and coverage
- Audit log events exist for every major security state change
- REST API supports listing and updating code scanning, secret scanning, and Dependabot alerts at repo and org scope
- Webhooks enable real-time downstream automation
- Security manager is a custom org role with read-only security access

## Study Checklist

- [ ] I can create a security configuration and attach it to multiple repos
- [ ] I can describe every widget in the security overview
- [ ] I know the audit log events for code scanning, secret scanning, and Dependabot
- [ ] I can list REST API endpoints for each alert type
- [ ] I can outline a four-phase GHAS rollout plan
