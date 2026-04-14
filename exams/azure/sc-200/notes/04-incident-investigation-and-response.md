# 04 - Incident Investigation and Response

## Incident Lifecycle

The NIST SP 800-61 incident response lifecycle (Preparation -> Detection & Analysis -> Containment, Eradication, Recovery -> Post-Incident Activity) maps directly to Microsoft tooling.

| NIST Phase | Microsoft Capability |
|-----------|---------------------|
| Preparation | Defender for Cloud baselines, MDE configuration management, Sentinel content hub solutions, playbook development |
| Detection | Defender workloads, Sentinel analytics rules, custom detections, Fusion |
| Analysis | Attack story timeline, advanced hunting, Sentinel investigation graph, UEBA |
| Containment | MDE isolate device, disable user, revoke sessions, block file/IOC |
| Eradication | Stop and quarantine, run AV scan, soft/hard delete email, suspend OAuth app |
| Recovery | Re-enable, re-onboard, force password change, validate via hunting |
| Post-incident | Bookmarks, comments, after-action reports, tune detections, update playbooks |

## Defender XDR Incident Page Components

When you open an incident at security.microsoft.com:

- **Attack story** - timeline + visual graph of related entities
- **Alerts** - constituent alerts grouped into the incident
- **Assets** - affected devices, mailboxes, identities, apps
- **Investigations** - AIR runs related to this incident
- **Evidence and response** - files, processes, IPs, URLs with verdicts and actions taken
- **Summary** - severity, status, classification, owner, tags
- **Comments and history** - audit trail of analyst actions

## Triage Workflow

### Step 1: Severity and scope
- Confirm severity in queue (High/Medium/Low/Informational)
- Quick scan of asset count and tactic
- Check classification: True Positive / Informational, expected / False Positive / Benign Positive

### Step 2: Assign and tag
- Set owner (analyst or queue)
- Apply tags (e.g., "ransomware", "credential-theft", "VIP")
- Status -> In progress

### Step 3: Pivot for context
- Asset list -> click each entity -> see device timeline, user sign-in history, mailbox details
- Use advanced hunting queries linked from the alert page
- Check threat analytics for known-actor TTPs

### Step 4: Decide containment
- Isolate device
- Disable user
- Block file hash (organization-wide IOC)
- Purge email cluster

### Step 5: Eradicate
- Run live response to remove persistence
- Re-image if compromise depth uncertain
- Reset credentials, revoke tokens
- Remove malicious OAuth grants

### Step 6: Recover
- Validate clean via follow-up hunt
- Re-enable user (require password change + MFA reregistration)
- Re-onboard device
- Confirm no residual alerts

### Step 7: Close incident with classification
- True positive - malicious activity
  - Multistage attack
  - Malicious user activity
  - Compromised account
  - Malware
  - Phishing
  - Suspicious activity (BAU but worth tracking)
  - Unwanted software
  - Other
- Informational, expected
  - Penetration testing
  - Red team activity
  - Confirmed activity
  - Other
- False positive
  - Not malicious
  - Not enough data to validate
  - Other

Provide a comment with rationale for future tuning and audit.

## Sentinel Incident Workflow

Sentinel adds investigation graph (visual entity exploration), bookmarks, and tighter SOAR. Workflow mirrors XDR but with these unique tools:

- **Investigation graph** - opens for incidents with mapped entities; pivot to expand related logs
- **Entity insights pages** - account, host, IP, mailbox detail pages with anomalies and timelines
- **Bookmarks** - hunting findings attached to incident
- **Tasks** - per-incident checklist (preview/GA depending on tenant)
- **Notebooks** - launch Jupyter for advanced analysis

## Automation Rules

Automation rules act on incidents (and optionally alerts). Triggers:
- When incident is created
- When incident is updated
- When alert is created (limited)

Conditions chain on:
- Analytics rule name (Contains, equals)
- Severity, status
- Tactic, technique
- Tag presence
- Owner change
- Custom conditions on entities (preview)

Actions:
- Run playbook (Logic App)
- Change status, severity, owner
- Add/remove tags
- Add task

Rule order matters: rules execute top-down. Use ordering and stop-after-first-match logic where appropriate.

## Playbooks (Logic Apps)

Playbooks are Azure Logic Apps with security-specific triggers. Trigger types:

- **Microsoft Sentinel incident** - fires on incident create/update via automation rule
- **Microsoft Sentinel alert** - fires on alert
- **Microsoft Sentinel entity** - manual run from entity page

Logic Apps connectors include:
- Microsoft Defender XDR (response actions)
- Microsoft Sentinel (update incident)
- Microsoft Graph Security
- Azure AD/Entra ID
- Office 365 Outlook (for email)
- Microsoft Teams (post messages, adaptive cards)
- ServiceNow, Jira (ticketing)
- VirusTotal, Recorded Future, AbuseIPDB (TI enrichment)
- HTTP (call any REST API)

### Identity for playbooks

- **Managed identity** (preferred) - assign workspace and Graph permissions
- **Service principal** - legacy
- **OAuth user delegation** - for connectors that require user context

Permissions: Sentinel Responder on workspace for incident updates; Microsoft Sentinel Automation Contributor for rule configuration.

## Action Center (Defender XDR)

Two tabs:
- **Pending** - actions awaiting analyst approval (semi-auto AIR results)
- **History** - all completed actions with revert option for some (e.g., release quarantined file)

Bulk approve/reject for efficiency.

## Live Response (MDE)

Remote shell-like session to a Windows or Linux endpoint:
- Browse file system
- Get/put files
- Run scripts (PowerShell library)
- Run binaries from approved library
- Process tree, services, persistence checks

Permissions: requires "Active remediation actions" in role; library access controlled separately. Sessions logged in `DeviceEvents`.

## Defender for Office 365 Investigation Tools

- **Threat Explorer** (Explorer for E5; Real-time detections for P1) - search for emails by sender, recipient, subject, URL, attachment, verdict
- **Email entity page** - full email detail with headers, URLs, attachments, delivery actions
- **Submissions** - report missed phishing or false positives to Microsoft
- **Quarantine** - manage held messages
- **Attack simulation training** - phishing simulations and training assignments

### Take action from Threat Explorer
- Move to Junk/Inbox/Deleted Items
- Soft delete (recoverable from Deleted Items)
- Hard delete (purged)
- Block sender (creates allow/block list entry)
- Submit to Microsoft

## Defender for Cloud Investigation

Defender for Cloud alert page provides:
- Alert description, severity, status
- Affected resource and subscription
- Entities involved
- Suggested remediation steps
- MITRE technique mapping
- Sample queries to investigate

Alerts forward to Sentinel via the connector and to Defender XDR via the integration.

## Microsoft Purview Integration

Insider risk and DLP alerts can flow into Defender XDR:
- Risky behaviors: data exfil by departing users, file mass-download, USB transfer
- DLP policy matches: sensitive data shared externally
- Communication compliance: harassment, misconduct, regulatory phrases

Configure forwarding in Purview portal; alerts appear under Defender XDR with compliance origin tags.

## Investigation Best Practices

### Build a working hypothesis
"User X clicked phishing -> credentials stolen -> attacker logged in from Y -> attempted lateral movement to Z."

Test each step with a query. Confirm or refute, then refine.

### Time-bound your queries
Always specify a time window (`ago(7d)` or absolute range). Prevents runaway costs and clarifies temporal context.

### Pivot on entities, not events
A single user, IP, or device may be the unifying thread. Pivot from one event to all activity by that entity to find broader scope.

### Document as you go
Comments on the incident every 15 to 30 minutes during active investigation. Future analysts (or auditors) need the trail.

### Tag for trend analysis
Consistent tagging ("ransomware-precursor", "credential-theft", "successful-phish") enables monthly metrics and detection tuning.

## Common Exam Pitfalls

- Confusing automation rules (act on incidents, no Logic App) with playbooks (Logic Apps)
- Forgetting that disabling a user from XDR requires MDI on-prem AD integration for hybrid users
- Selecting hard delete when soft delete is appropriate (or vice versa)
- Not knowing classification options for incident closure
- Forgetting that Defender for Cloud alerts route to both Sentinel and XDR
- Picking live response for actions better done via API (e.g., bulk file collection across many devices)

## Quick Reference: Response Action Permissions

| Action | Required Role |
|--------|---------------|
| Isolate device | MDE Active remediation actions |
| Run AV scan | MDE Active remediation actions |
| Live response basic | MDE Live response basic |
| Live response advanced (run scripts) | MDE Live response advanced |
| Soft/hard delete email | MDO Search and purge |
| Disable user (cloud) | Entra User Admin or Privileged role |
| Disable user (on-prem via MDI) | MDI write to AD configuration |
| Block file hash org-wide | MDE manage indicators |
| Run playbook | Sentinel Playbook Operator + Logic App permissions |
