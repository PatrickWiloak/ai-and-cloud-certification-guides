# Enterprise Administration

## Administrative Surface

Copilot Business and Copilot Enterprise introduce administrative controls that are not available in Individual plans. These controls live at the organization and enterprise levels on GitHub.com or GitHub Enterprise Cloud.

## Enabling Copilot

### Copilot Business

1. In organization settings, open **Copilot** > **Access**
2. Choose who has access: No one, Selected users/teams, or All members
3. Purchase seats via billing
4. Configure policies (duplicate detection, chat, network, MCP, content exclusions)

### Copilot Enterprise

1. In enterprise settings, enable Copilot for specific organizations or all organizations
2. Set enterprise-wide policies and exclusions that cascade down
3. Org admins can further restrict within their org

**[Managing Copilot in your org](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization)** - Admin guide

## Seat Management

### Assigning Seats

- Assign individual users via UI
- Assign teams via UI (everyone in the team gets a seat)
- Assign programmatically via the REST API or GraphQL API

### Seat Lifecycle

1. Admin assigns a seat
2. Email invitation sent to the user
3. User authenticates and activates Copilot in their IDE
4. Usage tracked in seat management reports
5. Admin can unassign unused seats at any time

### Seat Reports

- Last activity timestamp per user
- Utilization statistics
- Export via API for integration with HR or IT systems

## Copilot Policies

Policies are set at org (Business/Enterprise) or enterprise (Enterprise) level.

### Suggestions Matching Public Code (Duplicate Detection)

- **Block** - Suggestions matching public code are blocked
- **Allow** - Matches are permitted (not recommended for licensing)

### Chat in IDE and on GitHub.com

- Enable or disable chat features per surface

### Copilot in the CLI

- Enable or disable `gh copilot` usage for org members

### Copilot Extensions

- Allow all, selected, or no extensions
- Approve specific extensions before members can install

### MCP (Model Context Protocol)

- Allow or disallow MCP server use in chat

### Network Access for Chat

- Allow chat to fetch external web content for responses

### Model Availability

- Allow or restrict which models users can pick in chat

## Content Exclusions Administration

### Setup

1. Organization settings > **Copilot** > **Content exclusions**
2. Add rules in YAML-like format listing repository patterns and paths
3. Save and verify in a test repository

### Example

```
- repo: "myorg/legacy-app"
  paths:
    - "secrets/**"
    - "**/*.pem"
- repo: "myorg/another-repo"
  paths:
    - "config/production/**"
```

### Verification

- Open a file matching a rule; confirm Copilot does not suggest in it
- Open chat in that repo; confirm context from excluded files is not used

**[Excluding content](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization/excluding-content-from-github-copilot)** - Exclusion guide

## Knowledge Bases (Enterprise)

### What They Are

A knowledge base is a curated collection of markdown-heavy repositories that Copilot Chat on github.com can use as additional context.

### Setup

1. Enterprise admin creates a knowledge base
2. Add repositories (often internal docs, wikis-as-repos, runbooks)
3. Users select the knowledge base from Copilot Chat on github.com
4. Chat retrieves relevant passages to answer questions

### Use Cases

- Internal engineering handbooks
- Platform documentation
- Runbooks and SOPs
- Onboarding materials

**[Knowledge Bases](https://docs.github.com/en/enterprise-cloud@latest/copilot/managing-copilot/managing-github-copilot-in-your-organization/managing-copilot-knowledge-bases)** - Enterprise docs

## PR Summaries and Code Review (Enterprise)

- **PR summaries** - Draft PR descriptions from the diff; admins enable per-org
- **Copilot code review** - Request Copilot as a reviewer; receive inline comments and suggestions

## Custom Models (Enterprise Preview)

An enterprise can fine-tune a Copilot model on their own code to improve suggestion relevance for internal languages and frameworks. This is an Enterprise preview feature.

## SSO and Identity

- Copilot inherits the org/enterprise SSO configuration
- Users must authenticate through the configured IdP to use Copilot
- Session controls are governed by the GitHub Enterprise Cloud SSO policy

## Audit Logging

Copilot emits events including:

| Event | Meaning |
|-------|---------|
| `copilot.seat_assigned` | Seat assigned to a user |
| `copilot.seat_unassigned` | Seat removed |
| `copilot.policy_updated` | Any Copilot policy changed |
| `copilot.content_excluded` | Content exclusion rule updated |
| `copilot.cli_enabled` | CLI access toggled |

Filter the audit log with `action:copilot` to see Copilot-only events.

## Rollout Playbook

### Pilot (Weeks 1-2)

- Assign seats to a small pilot group (20-50 developers)
- Enable duplicate detection; set default policies
- Communicate responsible use guidelines

### Broader Rollout (Weeks 3-6)

- Expand to full teams or the org
- Add content exclusions for sensitive repos
- Roll out training: prompt engineering, chat, CLI, responsible use
- Set up usage reporting

### Ongoing Operations

- Review audit logs monthly
- Review seat utilization; reclaim inactive seats
- Update exclusions as new sensitive repos are added
- Communicate new features as they GA

## API Highlights

- **Seats API** - List, add, remove seats programmatically
- **Usage metrics API** - Query Copilot usage by org
- **Audit log API** - Pull Copilot events into SIEM

## Billing

- Per-seat pricing; monthly or annual
- Assigned seats are billed; unassigned seats stop billing at cycle end per contract
- Billing manager role can access invoices; admins manage seats

## Key Exam Facts

- Copilot Business and Enterprise are managed at the organization level; Enterprise adds enterprise-level cascading
- Content exclusions are YAML-like, path-based, configured per repo/org/enterprise
- Knowledge bases, PR summaries, Copilot code review, and custom models are Enterprise-only
- Audit log events use the `copilot` action namespace
- Seat assignment and policy changes are auditable

## Study Checklist

- [ ] I can enable Copilot for an org and assign seats to a team
- [ ] I can create content exclusion rules at org level
- [ ] I know which policies exist and what they control
- [ ] I know which features require Enterprise vs Business
- [ ] I can describe a phased Copilot rollout plan
