# 05 - Threat Hunting

## What Is Threat Hunting?

Threat hunting is the proactive search for adversaries who have evaded existing detections. Unlike alert-driven investigation (reactive), hunting begins with a hypothesis grounded in threat intelligence, MITRE ATT&CK, or environmental anomalies, then queries data to validate or refute that hypothesis.

A mature SOC includes both alert response and continuous hunting. Hunting findings should feed back into detection engineering as new analytics rules.

## Hunting Methodology

The PEAK framework (Prepare, Execute, Act, Knowledge) and David Bianco's Pyramid of Pain are common references. A simplified loop:

1. **Hypothesis** - "Adversaries may use rundll32.exe to execute malicious DLLs from temp directories"
2. **Data sources** - Identify which tables hold relevant telemetry
3. **Query** - Build KQL to surface candidate events
4. **Validate** - Determine if results are benign or suspicious
5. **Escalate** - If suspicious, create a bookmark and attach to a new incident
6. **Operationalize** - Convert validated hunt into a scheduled analytics or custom detection rule

## Hunting Sources for SC-200

### Microsoft Defender XDR Advanced Hunting
- Located at security.microsoft.com > Hunting > Advanced hunting
- 30 days of raw telemetry across MDE, MDO, MDI, MDA, Entra ID Protection
- Built-in queries linked to MITRE techniques
- Custom detection rules elevate hunts to scheduled detections
- Up to 10,000 results per query, with export

### Microsoft Sentinel Hunting
- Located in Sentinel > Hunting
- Queries against any data ingested into the workspace (longer retention possible)
- Bookmarks save findings
- Livestream pins a query to alert on new matches
- Notebooks for advanced multi-step analysis

### Hunting query structure
```kql
// Hypothesis: rundll32 launching from temp dirs is uncommon and suspicious
DeviceProcessEvents
| where Timestamp > ago(30d)
| where FileName =~ "rundll32.exe"
| where ProcessCommandLine has_any (@"\Temp\", @"\AppData\Local\Temp\", @"\Users\Public\")
| where InitiatingProcessFileName !in~ ("setup.exe", "msiexec.exe")
| project Timestamp, DeviceName, AccountName, ProcessCommandLine, InitiatingProcessCommandLine
```

## MITRE ATT&CK Mapping

Map every hunt to one or more techniques. The MITRE matrix has 14 tactics (the "why") and 200+ techniques (the "how").

Sentinel and XDR support MITRE tagging on:
- Hunting queries
- Analytics rules
- Custom detections
- Workbooks (the MITRE ATT&CK workbook in Sentinel visualizes coverage)

Common high-value technique families for SC-200 hunting:

| Technique | ID | Notable hunts |
|-----------|-----|---------------|
| Phishing | T1566 | EmailUrlInfo joins to UrlClickEvents |
| Valid Accounts | T1078 | SigninLogs unusual geo/time |
| Brute Force | T1110 | Failed logon spikes |
| OS Credential Dumping | T1003 | LSASS memory access via DeviceEvents |
| Command and Scripting Interpreter | T1059 | PowerShell -enc, encoded cmd |
| Scheduled Task/Job | T1053 | schtasks.exe with download/exec patterns |
| WMI | T1047 | Wmic.exe spawning from Office apps |
| Lateral Movement | T1021 | RDP/SMB from new sources |
| Impair Defenses | T1562 | Disabling AV, firewall, audit |
| Exfiltration Over Web Service | T1567 | Large outbound to SaaS endpoints |

## Hunting Hypotheses Library

### Endpoint
- LOLBAS (living off the land binaries) executing scripts: certutil, bitsadmin, regsvr32, mshta, rundll32, msiexec downloading from URLs
- Office macros spawning child processes (winword.exe -> powershell.exe)
- Persistence via registry Run keys, scheduled tasks, services, WMI subscriptions
- Credential access via vssadmin, ntdsutil, comsvcs.dll on DCs
- Defender disablement: Set-MpPreference, registry edits to ASR rules

### Identity
- New device registrations from atypical locations
- Service accounts with interactive logons
- Privilege escalations not linked to a change ticket
- Token-replay anomalies (same SessionId from different IPs)
- OAuth app consents with high-risk scopes

### Email
- New domain senders impersonating internal brand keywords
- Auto-forwarding rules created on mailboxes (T1114.003)
- BEC patterns: external sender, finance recipient, invoice/payment language
- Safe Links clicks where verdict was malicious or suspicious

### Cloud
- Public exposure changes on storage accounts, S3 buckets, SQL servers
- Privileged role assignment outside CI/CD
- Disabled diagnostic logging (T1562.008)
- Anonymous access to KMS/Key Vault secrets
- Container privileged escalations, hostPath mounts

## Bookmarks

Bookmarks save query results that warrant follow-up. Workflow:

1. Run a hunting query in Sentinel
2. Select rows of interest
3. Click "Add bookmark"
4. Map entities (account, host, IP, etc.)
5. Optionally attach to a new or existing incident

Bookmarks are stored in the `HuntingBookmark` table and surface in Sentinel's Hunting > Bookmarks tab.

## Livestream

Pin a hunting query to run continuously against newly arriving data. Useful for active investigations: pin the IOC search and get pop-up alerts as new events arrive without creating a full analytics rule.

## Notebooks

Jupyter notebooks integrated with Sentinel via Azure ML workspace:
- Pre-built MSTICpy library (Microsoft Threat Intelligence Center Python)
- IOC enrichment, geolocation, TI lookups
- Pandas dataframes for complex transformations
- Visualizations beyond KQL (folium maps, networkx graphs)
- Long-running multi-step investigations not feasible in KQL alone

## UEBA (User and Entity Behavior Analytics)

Add-on Sentinel feature that:
- Builds 30-day baselines for users, hosts, IPs
- Detects anomalies: unusual sign-in time, geo, app, resource
- Populates `BehaviorAnalytics` and `IdentityInfo` tables
- Provides entity insight pages with anomaly history
- Powers anomaly analytics rules with tunable thresholds

UEBA query example:
```kql
BehaviorAnalytics
| where ActivityType == "Logon"
| where ActivityInsights has "UnusualForUser"
| project TimeGenerated, UserName, SourceIPAddress, ActivityInsights
```

## Threat Intelligence Hunting

Match logs against IOC feeds:
```kql
ThreatIntelligenceIndicator
| where ExpirationDateTime > now() and Active == true
| where ThreatType == "MaliciousUrl"
| project IndicatorTime = TimeGenerated, IndicatorId, Description, Url
| join (
    DeviceNetworkEvents
    | where Timestamp > ago(7d)
) on $left.Url == $right.RemoteUrl
```

The built-in threat intelligence analytics rule does this automatically. Use TI hunting queries for ad-hoc verification or when investigating a fresh IOC.

## Building a Hunt Plan

Schedule recurring hunts on a cadence. Example monthly plan:

| Week | Theme | Sample hunts |
|------|-------|--------------|
| 1 | Initial access | Phishing, valid accounts, exposed services |
| 2 | Execution & persistence | LOLBAS, scheduled tasks, registry persistence |
| 3 | Credential access & lateral movement | Mimikatz, DCSync, RDP/WMI lateral |
| 4 | Defense evasion & exfil | AV disablement, log clearing, abnormal egress |

Document each hunt: hypothesis, data sources, query, results, decision (close, escalate, productionize).

## Tracking Detection Coverage

Use the **Microsoft Sentinel MITRE ATT&CK workbook** (Content Hub) to visualize which tactics and techniques have detections. Identify gaps and prioritize hunting/detection development against missing coverage.

The **Defender XDR Threat Analytics > Mitigations** view shows alignment to active campaigns and how your protections reduce risk.

## Hunting Outputs

Successful hunts should produce one of:

1. **Detection rule** - convert hunt into scheduled analytics or custom detection
2. **Workbook** - turn the hunt into an ongoing visualization for monitoring
3. **Bookmark on incident** - context for an active investigation
4. **Documentation** - hypothesis disproved, recorded so future analysts skip duplicate work

## Common Exam Pitfalls

- Confusing hunting (proactive) with investigation (reactive) - know that hunts often have no prior alert
- Forgetting that Sentinel hunting can use longer retention than XDR's 30 days
- Missing the bookmark workflow as the bridge between hunt and incident
- Selecting livestream when a scheduled analytics rule is more appropriate (or vice versa)
- Not knowing UEBA must be explicitly enabled before BehaviorAnalytics tables populate
- Overlooking the Threat Intelligence rule auto-match instead of manual hunting

## Quick Reference

| Need | Tool |
|------|------|
| One-time exploration | Hunting page (Sentinel or XDR) |
| Track findings | Bookmark |
| Realtime watch | Livestream |
| Complex multi-step | Notebook |
| Production detection | Custom detection (XDR) or Scheduled analytics rule (Sentinel) |
| Visualize coverage | MITRE ATT&CK workbook |
| Behavioral baseline | UEBA |
| IOC matching | Threat Intelligence connector + analytics rule |
