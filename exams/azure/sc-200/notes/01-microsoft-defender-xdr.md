# 01 - Microsoft Defender XDR

## Overview

Microsoft Defender XDR (formerly Microsoft 365 Defender) is the unified pre- and post-breach enterprise defense suite that natively coordinates detection, prevention, investigation, and response across endpoints, identities, email, SaaS apps, and cloud workloads. The unified portal lives at **security.microsoft.com**.

Defender XDR is not a single product. It is the orchestration layer that brings together signals from individual workloads:

| Workload | Coverage | License |
|----------|----------|---------|
| Microsoft Defender for Endpoint (MDE) | Workstations, laptops, servers, mobile | M365 E5, MDE P1/P2 standalone |
| Microsoft Defender for Office 365 (MDO) | Exchange, Teams, SharePoint, OneDrive | M365 E5, MDO P1/P2 standalone |
| Microsoft Defender for Identity (MDI) | On-prem AD, AD FS, AD CS, Entra Connect | M365 E5, EMS E5 |
| Microsoft Defender for Cloud Apps (MDA) | SaaS apps, OAuth apps, CASB | M365 E5, MDA standalone |
| Microsoft Entra ID Protection | Identity risk signals | Entra ID P2 |
| Microsoft Defender for Cloud (alerts) | Azure, AWS, GCP workload alerts | Per Defender plan |

## Unified Portal Layout

The Defender XDR portal consolidates what were previously separate consoles (security.microsoft.com, securitycenter.microsoft.com, portal.atp.azure.com, security.microsoft.com).

Major navigation areas:

- **Home** - Customizable dashboard, secure score, threat analytics
- **Investigation & Response**
  - **Incidents & alerts** - Unified incident queue with attack story
  - **Hunting** - Advanced hunting (KQL), custom detection rules
  - **Action center** - Pending and history of automated remediation
  - **Threat analytics** - Microsoft TI threat reports with org impact
- **Threat Intelligence** - Defender TI premium, intel profiles
- **Assets** - Devices, identities, mailboxes inventory
- **Microsoft Sentinel** - When Sentinel is integrated, incidents and hunting accessible here
- **Identities** - Entra ID Protection insights
- **Endpoints** - MDE-specific configuration, vulnerability management, baselines
- **Email & collaboration** - MDO-specific submissions, policies, Threat Explorer
- **Cloud apps** - MDA-specific app catalog, OAuth apps, governance log
- **Reports** - Email and collaboration, devices, identities reports
- **System** - Permissions, settings, integrations

## Incident Correlation

The signature value of XDR is automatic incident correlation: alerts that share entities (users, devices, IPs, files, mailboxes) within a time window are grouped into a single incident, often spanning multiple Microsoft products.

Example correlation:
- MDO alert: phishing email delivered with malicious URL
- MDE alert: PowerShell process spawned from Outlook on the recipient's device
- MDI alert: same user attempted DCSync against domain controller
- MDA alert: same user authorized a suspicious OAuth app

All four roll up into one incident with a timeline showing the sequence and an attack story view.

## Attack Story

The Attack Story tab visualizes:
- Timeline of all events
- Affected assets
- Process tree (for endpoint-originated activity)
- Email flow (for MDO-originated)
- Sign-in chains (for identity)
- Recommended response actions

## Response Actions

### Endpoint actions (MDE)
- Isolate device (full or selective)
- Restrict app execution
- Run antivirus scan
- Collect investigation package
- Initiate live response session
- Stop and quarantine file (organization-wide)
- Add file indicator (block hash, IP, URL, certificate)
- Submit file for deep analysis

### Identity actions
- Confirm user compromised
- Confirm user safe
- Disable user in Entra ID (requires MDI integration with on-prem AD for hybrid)
- Force password reset
- Revoke all sessions

### Email actions (MDO)
- Soft delete email
- Hard delete email
- Move to junk/inbox/deleted items
- Block sender
- Submit to Microsoft for analysis

### Cloud apps actions (MDA)
- Suspend OAuth app
- Revoke OAuth consent
- Suspend user in connected apps
- Notify user

## Automated Investigation and Response (AIR)

When MDE or MDO detects a threat, AIR can automatically:
1. Collect related artifacts (files, processes, mail items)
2. Run remediation playbooks
3. Generate verdicts: malicious, suspicious, no threat
4. Apply remediation pending approval (semi-auto) or fully (full-auto)

Automation level configurable per device group (MDE) and per policy (MDO):
- No automated response
- Semi - require approval for any remediation
- Semi - approve core folders only
- Semi - approve non-temp folders only
- Full - automatic remediation

Action Center is where pending approvals live and where you audit completed actions.

## Microsoft Defender XDR Roles (Unified RBAC)

Unified RBAC (introduced 2023, GA 2024) replaces individual workload RBAC with one model:

- **Built-in roles**: Security Reader, Security Operator, Security Admin, etc.
- **Custom roles**: granular permissions across data sources, response actions, configuration
- **Data sources**: Endpoints, Office 365, Identity, Cloud Apps, Email & collaboration, Microsoft Secure Score
- **Permissions**: Read, Manage, Investigate, Respond

Best practice: enable Unified RBAC, then progressively migrate workload-specific roles. Workload-specific RBAC remains supported but is being phased out.

## Microsoft Secure Score

Centralized posture metric across:
- Identity (Entra ID configuration)
- Devices (MDE configuration)
- Apps (M365 app hardening)
- Data (sensitivity labels, DLP)
- Infrastructure (Defender for Cloud)

Each recommendation has:
- Points value
- Implementation guidance
- User impact rating
- Status (To address, Planned, Risk accepted, Resolved through third-party, Completed)

Secure Score is informational; it does not enforce. Use it for reporting and as a guided to-do list.

## Threat Analytics

Microsoft-curated threat intelligence reports with:
- Threat actor or campaign overview
- Affected products/configs
- Detections in your environment
- Recommended actions
- Mitigations status (which recommendations protect against this)

Each report shows your organization's exposure: affected assets, prevented attempts, active alerts.

## Custom Detection Rules

Custom detections turn advanced hunting queries into scheduled detections:

1. Write KQL in Advanced Hunting page
2. Validate it returns the entities you need (DeviceId, AccountObjectId, FileSha256, etc.)
3. Click "Create detection rule"
4. Configure: name, severity, MITRE technique, frequency (continuous, every hour, every 3/12/24 hours)
5. Configure impacted entities
6. Configure response actions (isolate device, run AV scan, disable user, block file)
7. Set scope (all devices or specific device groups)

Custom detections execute in the XDR data plane, no extra ingestion cost.

## Integration with Microsoft Sentinel

Bidirectional integration:
- **XDR -> Sentinel**: alerts and incidents flow into Sentinel via the Microsoft Defender XDR connector. Raw advanced hunting tables also available via "Microsoft 365 Defender" data connector.
- **Sentinel -> XDR**: with the integration enabled, Sentinel incidents created from non-Microsoft sources surface in the XDR portal too. Single incident queue across both.

When to use which:
- **Defender XDR portal**: day-to-day SOC operations on Microsoft-protected workloads, faster automation
- **Sentinel**: cross-cloud, custom log sources, long retention, complex SOAR workflows, multi-tenant MSSP

## Microsoft Copilot for Security

Generative AI assistant integrated into Defender XDR:
- Incident summarization in natural language
- KQL query authoring from English prompts
- Script analysis (PowerShell, command lines)
- Reverse-engineering assistance
- Promptbooks for repeated workflows

Pricing is consumption-based (Security Compute Units / SCUs).

## Threat Intelligence

- **Microsoft Defender Threat Intelligence (Defender TI)** - premium TI portal with intel profiles, articles, IOC search
- **Threat actor profiles** - tracked groups (e.g., Midnight Blizzard, Diamond Sleet)
- **IOC search** - hash, domain, IP, URL lookups across XDR data
- **Intel projects** - share TI within team

Free tier provides limited access; premium adds APIs, finished intel, and broader IOC catalogs.

## Common Exam Pitfalls

- Mixing up MDA (Cloud Apps) with Defender for Cloud (cloud workloads)
- Forgetting MDI requires on-prem AD sensors; Entra ID Protection covers cloud identity
- Assuming AIR runs without configuration; default automation level varies by device group
- Confusing Unified RBAC with Entra ID role assignments
- Forgetting that XDR Action Center is separate from Sentinel Automation rules
- Not knowing that custom detections are XDR-side, separate from Sentinel analytics rules

## Quick Reference: Where to Find What

| Task | Location |
|------|----------|
| Triage all incidents | Defender XDR > Incidents |
| Run advanced hunting query | Defender XDR > Hunting |
| Create custom detection rule | Hunting > Create detection rule |
| Approve AIR remediation | Defender XDR > Action center |
| Configure MDE policies | Endpoints > Configuration management |
| Configure MDO policies | Email & collab > Policies & rules |
| Manage MDA policies | Cloud apps > Policies |
| Review threat report | Threat analytics |
| Manage roles | Permissions > Microsoft Defender XDR roles |
| Review secure score | Microsoft Secure Score |
