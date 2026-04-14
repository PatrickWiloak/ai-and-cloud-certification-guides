# Secret Scanning and Push Protection

## What Secret Scanning Is

Secret scanning detects exposed credentials in your code: API keys, tokens, private keys, passwords in specific known formats. It runs on the default branch and on all historical commits, and surfaces alerts in the Security tab.

**[About Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)** - Overview

## Pattern Types

### Partner Patterns

- Provided by service providers (AWS, Stripe, Google, Azure, Slack, etc.)
- Include a high-confidence regex and a validation endpoint
- When a match is found, GitHub can notify the partner for automatic revocation
- Available on public repos by default; GHAS required on private repos

### GitHub Patterns

- GitHub-supplied detection for its own and partner tokens
- Same behavior as partner patterns

### Custom Patterns

- Customer-defined regexes
- Configured at repo, org, or enterprise scope
- Use fields:
  - Name
  - Secret format (regex)
  - Before/after secret patterns (to reduce false positives)
  - Additional match requirements (e.g., a companion value)

### Non-Provider Patterns

- Generic credentials (passwords, private keys) not tied to a specific vendor
- Detection uses pattern matching and/or ML
- Must be explicitly enabled

**[Supported Patterns](https://docs.github.com/en/code-security/secret-scanning/introduction/supported-secret-scanning-patterns)** - Pattern reference

## Validity Checks

For supported partners, GitHub calls the partner's verification API to determine whether the detected token is still active.

Alert state values:
- **Active** - Token is live according to partner
- **Inactive** - Token is revoked or expired
- **Unknown** - Validity not supported or cannot be determined

Validity checks help prioritize remediation: active tokens are more urgent than already-revoked ones.

## Push Protection

Push protection prevents secrets from entering the repository in the first place. It inspects commits during `git push` and blocks the push if a secret is detected.

### Supported Surfaces

- Command line git push
- Web-based commit/editor
- REST API content creation endpoints

### Blocking Behavior

When a push is blocked, the developer sees a message identifying:
- The type of secret detected
- The file and line
- Options to bypass or remove

### Bypass Reasons

Standard reasons include:
- **False positive** - Not a real secret
- **Used in tests** - Intentional test fixture
- **I'll fix it later** - Will remove soon

Each bypass is recorded in the audit log.

### Delegated Bypass

- Instead of the developer choosing to bypass, a designated reviewer (security team or approver) must approve the bypass
- Configured at org level
- Used in regulated environments where developers should not self-approve

**[Push Protection](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/push-protection-for-repositories-and-organizations)** - Push protection guide

## Alert Lifecycle

| State | Meaning |
|-------|---------|
| Open | Detected, not yet addressed |
| Revoked | Marked as revoked by user or partner |
| False positive | Marked as not a real secret |
| Used in tests | Intentional |
| Won't fix | Acknowledged but not remediating |
| Pattern deleted | Underlying pattern removed; alert auto-closed |

## Custom Pattern Example

Internal tokens in the format `INTX-` followed by 32 hex characters:

```
Name: Internal Token
Secret format: INTX-[A-Fa-f0-9]{32}
Before secret: (?:^|[^A-Za-z0-9])
After secret: (?:$|[^A-Za-z0-9])
```

Scope: Organization (applies to every repo in the org).

Testing: dry-run against existing repos before enabling push protection for the pattern.

**[Custom Patterns](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/custom-patterns/about-custom-patterns)** - Custom pattern guide

## Non-Provider Patterns

Enable "detect non-provider patterns" in org security settings to surface generic credentials (e.g., a detected password-like string or an SSH private key). These are higher-noise than partner patterns but cover gaps.

## Alerting and Notifications

- Repo security alerts UI
- Email notifications to repo admins and security managers
- Webhook event `secret_scanning_alert`
- REST API: `GET /repos/{owner}/{repo}/secret-scanning/alerts`

## Automatic Partner Revocation

For supported partners, GitHub notifies the partner when a secret is exposed publicly. The partner may automatically revoke the credential. This only applies to public exposure.

## Integration with Push Protection Audit

Audit log events:
- `secret_scanning_push_protection.bypass` - Developer bypassed
- `secret_scanning_push_protection.delegated_bypass_request` - Request created
- `secret_scanning_push_protection.delegated_bypass_response` - Reviewer decision

## Common Pitfalls

- Assuming `--no-verify` bypasses push protection (it does not; push protection is server-side)
- Forgetting to enable push protection for custom patterns specifically
- Not rotating secrets even after an alert is marked "used in tests" (always rotate if exposed publicly)
- Relying only on partner patterns when internal tokens exist

## Remediation Workflow

1. Alert raised
2. Rotate the exposed secret at the source (provider console)
3. Remove the secret from the codebase (new commit)
4. If needed, scrub from history (filter-repo or BFG)
5. Mark the alert as revoked with a note
6. Review why it leaked and add a custom pattern or education to prevent recurrence

## Key Exam Facts

- Partner patterns, GitHub patterns, custom patterns, and non-provider patterns all exist
- Push protection is server-side; `--no-verify` does not bypass it
- Bypass reasons are audited; delegated bypass routes approval to reviewers
- Validity checks tell you whether a token is still active (partner-dependent)
- Automatic partner revocation applies to public exposure
- Custom patterns have regex plus before/after context; configurable at repo/org/enterprise

## Study Checklist

- [ ] I can list the four pattern types and when to use each
- [ ] I can configure a custom pattern with before/after contexts
- [ ] I know the push protection bypass reasons and where they appear in audit
- [ ] I can describe delegated bypass and its target use case
- [ ] I understand validity checks and how they drive prioritization
