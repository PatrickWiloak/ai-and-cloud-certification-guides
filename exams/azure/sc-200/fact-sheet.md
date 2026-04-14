# SC-200 Fact Sheet

## Exam Logistics

| Item | Detail |
|------|--------|
| Exam Code | SC-200 |
| Full Name | Microsoft Security Operations Analyst |
| Credential | Microsoft Certified: Security Operations Analyst Associate |
| Duration | 100 minutes |
| Seat Time | Approximately 120 minutes including sign-in and survey |
| Question Count | 40 to 60 |
| Passing Score | 700 / 1000 (scaled, not a percentage) |
| Cost (USD) | $165 |
| Retake Policy | 24 hours after first failure, 14 days after subsequent failures, max 5 attempts per year |
| Delivery | Pearson VUE in-person or online proctored |
| Languages | EN, JP, KO, ZH-CN, DE, FR, ES, PT-BR |
| Validity | 1 year, renewable free on Microsoft Learn |

## Domain Weights

| Domain | Weight |
|--------|--------|
| Manage a security operations environment | 25 to 30% |
| Configure protections and detections | 15 to 20% |
| Manage incident response | 35 to 40% |
| Perform threat hunting | 15 to 20% |

## Question Types Encountered

- **Multiple choice** - single correct answer
- **Multiple response** - select N correct answers
- **Drag and drop** - order steps or match items
- **Hot area** - click areas of an image or screenshot
- **Build list** - select and order items
- **Active screen** - interact with simulated Azure portal
- **Case study** - 4 to 7 questions based on a scenario, cannot return after leaving
- **Yes/No series** - multiple related yes/no statements (no return)

## Core Microsoft Security Stack

### Microsoft Defender XDR (Extended Detection and Response)
Unified pre- and post-breach enterprise defense suite that natively coordinates detection, prevention, investigation, and response across:
- **Microsoft Defender for Endpoint (MDE)** - Endpoints, servers (P1/P2 plans)
- **Microsoft Defender for Office 365 (MDO)** - Email, Teams, SharePoint, OneDrive
- **Microsoft Defender for Identity (MDI)** - On-prem AD, hybrid identity
- **Microsoft Defender for Cloud Apps (MDA)** - SaaS apps, CASB
- **Microsoft Entra ID Protection** - Identity risk signals

### Microsoft Defender for Cloud
Cloud-native CNAPP that combines:
- **CSPM (Cloud Security Posture Management)** - Foundational free; Defender CSPM premium tier
- **CWPP (Cloud Workload Protection)** - Servers, storage, databases, containers, AI, APIs, Key Vault
- Multi-cloud: Azure, AWS, GCP

### Microsoft Sentinel
Cloud-native SIEM + SOAR built on Azure Log Analytics:
- Ingestion via data connectors (100+)
- Analytics rules produce alerts and incidents
- SOAR via Logic Apps playbooks
- UEBA add-on for behavioral analytics
- KQL for all queries

## Key Terminology

| Term | Definition |
|------|-----------|
| Alert | Single detection signal |
| Incident | Aggregation of related alerts |
| Entity | Identifiable artifact: user, host, IP, file, URL, mailbox |
| IoC | Indicator of Compromise - observable hash, IP, domain |
| TTP | Tactics, Techniques, Procedures (MITRE ATT&CK) |
| Playbook | Logic App workflow triggered by alert, incident, or entity |
| Automation rule | Sentinel rule engine that acts on incidents |
| Watchlist | Custom reference data uploaded as table |
| Bookmark | Saved hunting query result of interest |
| Workbook | Interactive visualization and reporting |
| Fusion | ML-based multistage attack detection |
| Hunting | Proactive TTP search without prior alert |

## Analytics Rule Types in Sentinel

| Rule Type | Description |
|-----------|-------------|
| Scheduled | KQL query run on a schedule |
| Microsoft security | Forward MS product alerts into Sentinel |
| Fusion | ML-correlated multistage attacks (enabled by default) |
| ML behavioral analytics | Microsoft-proprietary ML detections |
| Anomaly | Customizable UEBA anomalies |
| Near-real-time (NRT) | Runs every minute, ~1 min latency, limited operators |
| Threat intelligence | Match logs to TI indicators |

## MITRE ATT&CK Tactics (covered by Sentinel/XDR)

Reconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, Command and Control, Exfiltration, Impact.

## Essential KQL Operators

| Operator | Purpose |
|----------|---------|
| `where` | Filter rows |
| `project` | Select/rename columns |
| `extend` | Add calculated columns |
| `summarize` | Aggregate |
| `join` | Combine tables |
| `union` | Merge tables |
| `parse` | Extract structured data from strings |
| `mv-expand` | Expand arrays to rows |
| `make-series` | Time series arrays |
| `evaluate` | Plugins like autocluster, basket |
| `iff` / `case` | Conditional values |
| `top` / `take` | Limit results |

## Key Tables in Advanced Hunting (Defender XDR)

- `DeviceEvents`, `DeviceProcessEvents`, `DeviceNetworkEvents`, `DeviceFileEvents`, `DeviceLogonEvents`
- `EmailEvents`, `EmailAttachmentInfo`, `EmailUrlInfo`, `UrlClickEvents`
- `IdentityLogonEvents`, `IdentityQueryEvents`, `IdentityDirectoryEvents`
- `CloudAppEvents`
- `AlertInfo`, `AlertEvidence`

## Key Tables in Sentinel

- `SecurityEvent` (Windows Security log via MMA/AMA)
- `SigninLogs`, `AuditLogs`, `AADNonInteractiveUserSignInLogs`
- `AzureActivity`
- `OfficeActivity`, `CommonSecurityLog` (CEF)
- `Syslog`, `W3CIISLog`
- `SecurityAlert`, `SecurityIncident`
- `ThreatIntelligenceIndicator`

## Microsoft Sentinel Workspace Design

- Single tenant, single workspace - simplest
- Multi-tenant via Azure Lighthouse for MSSP
- Workspace-level RBAC: Sentinel Reader, Responder, Contributor, Automation Contributor, Playbook Operator
- Resource-context RBAC for granular table access
- Data residency at workspace creation (region cannot change)

## Pricing Model Highlights

- **Sentinel ingestion:** Pay-as-you-go per GB or commitment tier (100 GB/day up to 5000+ GB/day)
- **Log retention:** 90 days interactive free with Sentinel; archive tier cheap up to 12 years
- **Basic Logs / Auxiliary Logs:** Lower-cost tier for high-volume, low-query data
- **Defender for Cloud:** Per-resource per-hour for workload plans; CSPM plans per billable resource

## Integration Points

- **Microsoft Purview** - Insider Risk, DLP alerts flow into Defender XDR
- **Entra ID Protection** - Risky user/signin feeds XDR
- **Microsoft Copilot for Security** - Generative AI on top of XDR/Sentinel data
- **Defender TI (Threat Intelligence)** - Premium TI feed
- **Microsoft Security Exposure Management** - Unified attack surface management

## Official Documentation Links

- **Sentinel:** https://learn.microsoft.com/azure/sentinel/
- **Defender XDR:** https://learn.microsoft.com/defender-xdr/
- **Defender for Cloud:** https://learn.microsoft.com/azure/defender-for-cloud/
- **Defender for Endpoint:** https://learn.microsoft.com/defender-endpoint/
- **KQL reference:** https://learn.microsoft.com/kusto/query/
- **Advanced hunting schema:** https://learn.microsoft.com/defender-xdr/advanced-hunting-schema-tables

## Renewal

Free renewal 6 months before expiration on Microsoft Learn. Unproctored, open book, unlimited retakes. Covers any new content added to the exam objectives since certification.
