# 02 - Microsoft Sentinel Fundamentals

## What Is Microsoft Sentinel?

Microsoft Sentinel is Microsoft's cloud-native SIEM (Security Information and Event Management) and SOAR (Security Orchestration, Automation, and Response) platform built atop Azure Log Analytics. It collects log data at cloud scale, applies analytics for detection, supports proactive hunting, and orchestrates automated response.

Sentinel is a workload added to a Log Analytics workspace. The same workspace can serve Azure Monitor logging and Sentinel; enabling Sentinel adds security-specific tables (`SecurityAlert`, `SecurityIncident`, etc.), the Sentinel UX in the Azure portal, and additional billing for Sentinel features beyond raw log ingestion.

## Architecture

```
Data Sources -> Data Connectors -> Log Analytics Workspace (Sentinel-enabled)
                                            |
                                    +-------+-------+
                                    |               |
                              Analytics Rules   Hunting
                                    |               |
                                  Alerts        Bookmarks
                                    |
                                Incidents
                                    |
                              +-----+-----+
                              |           |
                       Automation     SOAR Playbooks
                          Rules        (Logic Apps)
```

## Workspace Design

Considerations:
- **Region**: Pick a region close to data sources to minimize egress and latency. Cannot be changed after creation.
- **Single vs multi-workspace**: Single workspace is easiest. Multi-workspace needed for data sovereignty, RBAC isolation, or MSSP scenarios.
- **Multi-tenant**: Use Azure Lighthouse to delegate access to multiple customer tenants from a single MSSP workspace.
- **Cross-workspace queries**: KQL `workspace("name").Table` syntax allows querying multiple workspaces at once.
- **Pricing tier**: Pay-as-you-go vs commitment tier (100, 200, 300, 400, 500, 1000, 2000, 5000+ GB/day).

## Data Connectors

Sentinel includes 200+ out-of-the-box connectors. Categories:

- **Microsoft sources**: Microsoft 365 Defender, Defender for Cloud, Entra ID, Azure Activity, Office 365, Microsoft Purview Information Protection
- **Cloud platforms**: AWS (CloudTrail, GuardDuty, VPC Flow), GCP (Audit, Pub/Sub)
- **Network & security devices**: Palo Alto, Cisco, Fortinet, Check Point, Zscaler (CEF or syslog)
- **Threat intelligence**: TAXII, MDTI, Threat Intelligence Platforms
- **Custom**: REST API, Logstash, Logic Apps, Codeless Connector Framework (CCF)

### Connector deployment patterns

| Pattern | Use Case |
|---------|----------|
| API-based | Microsoft 365, Entra ID, AWS, GCP - direct cloud-to-cloud |
| Azure Monitor Agent (AMA) + DCR | Windows Security events, Linux syslog, IIS, custom logs |
| Syslog/CEF via AMA | Network appliances forwarding to a Linux collector |
| Codeless Connector Framework | Vendor-built JSON schema for new sources |
| Logstash | Custom pipelines with transformation needs |
| Direct API ingestion | Custom apps using HTTP Data Collector or Logs Ingestion API |

### Data Collection Rules (DCR)

DCRs define what AMA collects and where it sends. Components:
- **Data sources**: Windows event logs (XPath), performance counters, syslog facilities, custom text logs
- **Streams**: Named output streams matching destination tables
- **Destinations**: Log Analytics workspace(s)
- **Transformations**: KQL `transformKql` to filter or shape data at ingest time

## Sentinel Analytics Rules

Rule types:

| Type | Purpose | Latency |
|------|---------|---------|
| Scheduled | KQL query on a schedule (5 min to 14 days) | Per schedule |
| Microsoft security | Forwards alerts from Microsoft products as Sentinel alerts | Real-time |
| Fusion | ML-correlated multistage attacks (Microsoft-authored) | Continuous |
| ML behavioral analytics | Microsoft-proprietary ML detections | Continuous |
| Anomaly | Customizable UEBA-driven anomaly detections | Continuous |
| Near-real-time (NRT) | KQL run every minute on incoming data | ~1 min |
| Threat intelligence | Match logs against TI indicators | Continuous |

### Scheduled rule anatomy
- Name, description, severity, tactics/techniques (MITRE)
- KQL query
- Query scheduling: how often to run, lookup window
- Alert threshold: trigger when results > N
- Event grouping: single alert per query, alert per row
- Suppression: pause after firing for a period
- Entity mapping: account, host, IP, file, URL, mailbox, etc. (entity types are KQL columns)
- Custom details: additional context fields
- Alert details: dynamic name and description
- Incident creation: yes/no, grouping settings
- Automation: link automation rules

### Entity types (must memorize)
Account, Host, IP, Malware, File, Process, CloudApplication, DNS, AzureResource, FileHash, RegistryKey, RegistryValue, SecurityGroup, URL, IoTDevice, Mailbox, MailCluster, MailMessage, SubmissionMail.

## Incidents

Incidents are aggregations of alerts. Properties:
- Title, severity, status (New, Active, Closed)
- Owner (user/team)
- Tags
- Comments
- Linked alerts and entities
- Tactics and techniques

Incident grouping options on a rule:
- Group all alerts from this rule into a single incident
- Group alerts within a time window (5 min to 24 hr) by selected entities
- Group alerts triggered by this rule into per-alert incidents

## Workbooks

Interactive visualization built on KQL queries:
- Templates from Microsoft and partners
- Build custom with tabs, parameters, charts, grids
- Shared via Azure portal or exported as ARM
- Used for SOC dashboards, executive reports, threat hunting context

## Hunting

Hunting page provides:
- 100+ built-in hunting queries mapped to MITRE ATT&CK
- Run-on-demand and saved query results
- Bookmarks: save findings to revisit, attach to incidents
- Livestream: pin a query to run continuously, alert on new matches

## Notebooks

Jupyter notebooks for advanced investigation:
- Hosted in Azure Machine Learning workspace or Azure Synapse
- Pre-built MSTICpy library accelerates IOC enrichment, geolocation, TI lookup
- Suited for one-off deep dives or repeatable analytical workflows

## UEBA (User and Entity Behavior Analytics)

Add-on capability that:
- Builds behavior baselines for users and entities
- Surfaces anomalies (unusual sign-in time, geo, app, resource)
- Adds `BehaviorAnalytics` and `IdentityInfo` tables
- Powers anomaly analytics rules
- Enriches investigations with entity insights pages

UEBA must be explicitly enabled and incurs additional cost.

## Watchlists

Custom reference data (CSV uploads) used to enrich queries:
- VIP user lists
- Asset inventory with criticality
- IP allowlists
- Authorized service accounts

Query via `_GetWatchlist("WatchlistAlias")` in KQL.

## Threat Intelligence

- Ingest indicators via TAXII server connection or TI Platforms (Microsoft Graph Security API)
- Indicators stored in `ThreatIntelligenceIndicator` table
- Threat intelligence analytics rule auto-matches IOCs against logs
- MDTI premium connector adds Microsoft's curated TI

## Sentinel Pricing Tiers

| Tier | Use | Cost Notes |
|------|-----|-----------|
| Analytics Logs | Default; full features | ~$2.46/GB pay-as-you-go (varies by region) |
| Basic Logs | High-volume, low-query | ~$0.50/GB; 30-day interactive retention; limited KQL |
| Auxiliary Logs | Even higher volume, lower query | ~$0.15/GB; very limited query; long retention |
| Archive | Cold storage | ~$0.025/GB/month; restore for query |

Defender for Cloud customers receive 500 MB/day free for selected security tables.

## Sentinel Roles

- **Microsoft Sentinel Reader** - View incidents, workbooks, data
- **Microsoft Sentinel Responder** - All Reader + manage incidents
- **Microsoft Sentinel Contributor** - All Responder + create/edit content
- **Microsoft Sentinel Automation Contributor** - Create/edit playbooks
- **Microsoft Sentinel Playbook Operator** - Run playbooks
- **Logic App Contributor** - Required to author playbooks themselves

Resource-context RBAC: assign workspace permissions only over specific resources via Azure RBAC at the resource level for granular access (e.g., team owns its app insights data only).

## Content Hub

Marketplace of solution packages: connectors, analytics rules, workbooks, playbooks, hunting queries, parsers. Categories:
- Microsoft solutions
- Cloud Provider integrations
- Vendor security products
- Industry-specific (banking, healthcare)

Install solutions to standardize coverage; many include pre-built MITRE-mapped detections.

## Key Tables Cheat Sheet

| Table | Source |
|-------|--------|
| `SecurityEvent` | Windows Security event log via AMA |
| `Event` | Windows Application/System logs |
| `Syslog` | Linux syslog |
| `CommonSecurityLog` | CEF-formatted appliance logs |
| `AzureActivity` | Azure subscription control plane |
| `AzureDiagnostics` | Azure resource diagnostic logs |
| `SigninLogs` | Entra ID interactive sign-ins |
| `AADNonInteractiveUserSignInLogs` | Non-interactive sign-ins |
| `AuditLogs` | Entra ID directory audit |
| `OfficeActivity` | M365 audit log |
| `SecurityAlert` | All Sentinel alerts (raised + ingested) |
| `SecurityIncident` | Sentinel incidents |
| `ThreatIntelligenceIndicator` | TI feeds |
| `Heartbeat` | AMA / connected machines health |
| `Usage` | Workspace billing/data volume |

## Common Exam Pitfalls

- Mixing AMA with deprecated MMA; always answer AMA for new deployments
- Selecting Scheduled when NRT is more appropriate (or vice versa) - know NRT limitations (no `join`, no time-window aggregations)
- Missing entity mapping requirement: without it, automation rules cannot act on entities
- Assuming Sentinel auto-syncs Defender XDR incidents - the XDR connector is required and bidirectional sync must be enabled
- Forgetting incident grouping: many rules raising one alert each will flood the queue
- Choosing pay-as-you-go when commitment tier saves significantly above 100 GB/day
