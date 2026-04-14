# Security, Privacy, and Data Handling

## Data Flow Overview

When a user asks Copilot for a completion or chat response:

1. The IDE gathers context (current file, tabs, selection, attachments)
2. The IDE sends the request to the GitHub Copilot proxy
3. The proxy authenticates, enforces policies (content exclusions, duplicate detection), and routes to the model provider
4. The provider returns a response
5. The proxy applies post-processing (duplicate detection filter) and returns the suggestion
6. The IDE renders the suggestion

Requests are encrypted in transit via TLS. For Business and Enterprise, prompts and suggestions are not retained after the response is delivered, and they are not used to train models.

**[Trust Center](https://resources.github.com/copilot-trust-center/)** - Complete privacy reference
**[Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot)** - Responsible-use guidance

## Data Retention by Plan

| Plan | Prompts retained | Suggestions retained | Used for training |
|------|------------------|---------------------|-------------------|
| Individual (Free/Pro/Pro+) | No (default) | No (default) | Opt-in only |
| Business | No | No | No |
| Enterprise | No | No | No |

Telemetry (feature usage, errors) is collected but does not include prompt or suggestion content for Business/Enterprise.

## Duplicate Detection Filter

### What It Does

Scans each suggestion for matches against public code on GitHub. If a suggestion matches ~150 characters of public code, it is blocked (or flagged in Individual).

### Where It Is Configured

- **Individual** - Personal Copilot settings
- **Business/Enterprise** - Organization or enterprise policy

### Why It Matters

- Reduces the chance of receiving output that closely mirrors a specific public repo
- Is a prerequisite for IP indemnification on Business and Enterprise

## IP Indemnification

Available to Copilot Business and Copilot Enterprise customers when duplicate detection is enabled. GitHub will defend customers against third-party IP claims arising from Copilot suggestions, subject to the contract terms.

Key conditions:
- Duplicate detection filter enabled
- Suggestions not materially modified in a way that introduces new issues
- Standard contract applies

## Content Exclusions

Content exclusions prevent specific paths from being used as context for Copilot and suppress suggestions inside excluded files.

### Scope Hierarchy

- Repository (most local)
- Organization
- Enterprise (broadest)

A rule applied at a higher scope extends to all lower scopes.

### Rule Syntax

Exclusion rules use glob-like path patterns. Examples:

```
- paths:
    - "**/*.pem"
    - "secrets/**"
    - "legacy/**"
```

### What Exclusions Do

- Prevent files matching a rule from being sent as context
- Suppress suggestions inside editors for files matching a rule
- Apply to completions AND chat

### What Exclusions Do Not Do

- Do not retroactively delete data already received by Copilot
- Do not affect data already indexed by public code search
- Do not block the user from editing excluded files; only Copilot behavior changes

**[Content Exclusions](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization/excluding-content-from-github-copilot)** - Full exclusion guide

## Secrets Handling

Copilot does not have a built-in secret scanner. Best practices:

- Use content exclusions to prevent secret-containing files from being used as context
- Rely on GitHub Advanced Security or dedicated secret scanning for detection
- Train developers not to paste secrets into chat

## Bias, Hallucinations, and Security

AI models can produce:
- Outdated APIs or deprecated code patterns
- Hallucinations (fictional APIs or functions)
- Insecure code (missing input validation, weak crypto defaults)
- Bias in variable names or example data

Mitigations:
- Human review of all AI output
- Automated tests and code scanning
- Security testing for authentication, cryptography, and authorization changes
- Clear, specific prompts with verified context

## Network and MCP Policies

- **Network policy** - Controls whether Copilot Chat can fetch external web content for a response
- **MCP policy** - Controls whether local Model Context Protocol servers can be used
- Configured at organization or enterprise level for Business/Enterprise

## Audit Logs

Copilot emits audit log events including:

- Seat assigned/unassigned
- Copilot policies changed
- Content exclusion rules created, updated, deleted
- Copilot Chat policy changes
- External model or MCP policy changes

Events are visible in the organization audit log for Business and Enterprise.

## Accessibility

- Copilot provides keyboard navigation for all features
- Ghost text can be styled for contrast
- Screen reader support in supported IDEs
- Chat history can be exported for note-taking

**[Copilot Accessibility](https://docs.github.com/en/copilot/configuring-github-copilot/configuring-github-copilot-in-the-cli)** - Accessibility docs

## Compliance and Region Considerations

- Copilot proxy is hosted on Azure; specific region availability varies
- Data processing addendums available for Business and Enterprise
- GDPR, CCPA covered under the Business/Enterprise DPA
- FedRAMP and regulated workloads: consult GitHub for current status

## Quick Reference: Controls per Plan

| Control | Free/Pro | Business | Enterprise |
|---------|----------|----------|------------|
| Duplicate detection | User setting | Admin policy | Admin policy |
| Content exclusions | Not available | Yes | Yes |
| Audit logs | Not available | Yes | Yes |
| Network policy | Not admin-controlled | Admin | Admin |
| MCP policy | Not admin-controlled | Admin | Admin |
| IP indemnity | No | Yes with duplicate detection | Yes with duplicate detection |

## Key Exam Facts

- Business and Enterprise do NOT retain prompts or suggestions and do NOT train on them
- IP indemnity requires Business/Enterprise AND duplicate detection enabled
- Content exclusions are path-based and apply to both completions and chat
- Content exclusions have scope hierarchy: repo < org < enterprise
- Network and MCP policies are admin-controlled in Business/Enterprise
- Audit logs cover seat assignment and policy changes

## Study Checklist

- [ ] I can draw the Copilot data flow from IDE to model provider and back
- [ ] I know which plans retain prompts and which do not
- [ ] I can write a content exclusion rule for a given path
- [ ] I can state the conditions for IP indemnity
- [ ] I know where duplicate detection is configured per plan
