# SC-200 Real-World Scenarios

These scenarios replicate the case-study format of the real exam. Work each from start to finish, then compare with the provided answer and reasoning.

## Scenario 1: Suspicious PowerShell on a Finance Workstation

**Context:** A Defender for Endpoint alert fires on a Windows 11 workstation in the Finance OU: "Suspicious PowerShell command line." The user reports clicking a link in an emailed invoice from an unknown sender earlier in the day. The user's mailbox is protected by Defender for Office 365.

**Q1:** Which portal should the SOC analyst open first to investigate the full attack story?

**A1:** security.microsoft.com (the unified Microsoft Defender XDR portal). It correlates signals from MDE, MDO, MDI, and MDA into a single incident with an attack story timeline. Opening Sentinel first or the MDE standalone portal fragments visibility.

**Q2:** Which advanced hunting query retrieves the email that likely delivered the payload?

**A2:**
```kql
EmailEvents
| where RecipientEmailAddress == "user@contoso.com"
| where Timestamp > ago(24h)
| join kind=inner EmailUrlInfo on NetworkMessageId
| where Url contains "invoice" or SenderFromAddress !endswith "@contoso.com"
| project Timestamp, Subject, SenderFromAddress, Url, NetworkMessageId
```

**Q3:** What immediate containment action should the analyst take?

**A3:** Isolate the device via MDE ("Isolate device" response action), which blocks all non-Defender network connections. Optionally also disable the user's sign-in in Entra ID if credential compromise is suspected. Purge the malicious email across the tenant using "Action center" or Threat Explorer's "Take action" to prevent other users from clicking.

**Q4:** To prevent recurrence at scale, the analyst wants a custom detection to fire whenever a Finance-group user receives an email with a document attachment from a new external sender that is then opened. Which detection source should they use and why?

**A4:** A Defender XDR custom detection rule built on advanced hunting. Advantages: already has EmailEvents, EmailAttachmentInfo, and DeviceProcessEvents unified; can auto-trigger AIR and response actions; runs across all XDR data without Sentinel ingestion costs. A Sentinel scheduled rule would work but requires those tables to be forwarded and adds cost.

## Scenario 2: Impossible Travel for a C-Suite Executive

**Context:** Entra ID Protection raises an "Atypical travel" risk for the CFO: sign-in from Chicago at 09:02 and from Lagos at 10:14 local times. MFA was completed successfully on both.

**Q1:** Is MFA success a reason to dismiss this alert?

**A1:** No. The travel is physically impossible regardless of MFA. The analyst must assume session token theft, adversary-in-the-middle (AiTM), or consented OAuth app abuse until proven otherwise.

**Q2:** What data should be pulled to confirm token theft?

**A2:** Query `AADSignInEventsBeta` and `SigninLogs` for the user, correlating:
- Session IDs and Correlation IDs
- User agents and device IDs
- Authentication method and conditional access result
- ASN, country, and IP reputation
Also check `OAuthAppInfo` and `CloudAppEvents` for newly consented OAuth apps in the last 7 days.

**Q3:** What containment actions should be taken simultaneously?

**A3:**
1. Confirm user compromised in Entra ID Protection (forces risk remediation)
2. Revoke all refresh tokens via Entra ID
3. Require password change
4. Review and revoke suspicious OAuth consents
5. Review mailbox for auto-forwarding rules and inbox rules (Defender for Office 365 > Threat Explorer)
6. Flag the user as VIP priority account in Defender XDR for ongoing enhanced monitoring

**Q4:** Which Sentinel analytics rule type would best detect AiTM phishing kit sessions ongoing?

**A4:** Fusion is already Microsoft's default for AiTM + session cookie theft multistage detection (the "AiTM phishing attack followed by mailbox manipulation" Fusion scenario). Ensure Fusion is enabled and the relevant data connectors (Defender for Office 365, Entra ID Sign-ins) are active.

## Scenario 3: Unusual Data Egress from an Azure Storage Account

**Context:** Microsoft Defender for Storage raises an alert: "Unusual amount of data extracted from a storage account." The storage account hosts financial reports. Access was from an IP not previously observed.

**Q1:** Which Defender for Cloud plan must be enabled for this alert to exist?

**A1:** Microsoft Defender for Storage (enabled at subscription or per-account level). It must include malware scanning for blobs and the activity monitoring feature.

**Q2:** How can the analyst identify the principal behind the action?

**A2:** Query `StorageBlobLogs` (diagnostic logs) and `AzureActivity` correlated by CorrelationId or OperationName. Look for `AuthenticationType` (shared key, Entra ID, SAS), `CallerIpAddress`, `RequesterObjectId`, and `UserAgentHeader`. SAS token usage complicates attribution; if it was SAS, identify which account generated the SAS from AzureActivity.

**Q3:** What hardening should be recommended after containment?

**A3:**
- Disable shared key authentication; require Entra ID authorization only
- Restrict public network access; use Private Endpoints
- Enable immutable storage for compliance blobs
- Enable Microsoft Purview sensitive data discovery (included in Defender CSPM)
- Configure storage firewall and resource instance rules
- Rotate or revoke active SAS tokens and move to user delegation SAS

**Q4:** How should this event be captured in Sentinel for long-term correlation?

**A4:** Ensure the Microsoft Defender for Cloud data connector is enabled in Sentinel so `SecurityAlert` receives this alert. Create a scheduled analytics rule that correlates storage egress with recent Entra ID risky users to catch "data staging" during credential compromise.

## Scenario 4: Ransomware Precursor on a Domain Controller

**Context:** MDI alerts on "Suspected DCSync attack" against a Domain Controller. Source is a non-admin workstation. Within 30 minutes, MDE alerts on "Credential dumping" from the same workstation.

**Q1:** Why does Defender for Identity see the DCSync before MDE?

**A1:** MDI inspects traffic to and from Domain Controllers (via AD DS sensor on the DC itself) and recognizes the `DRSUAPI` / `GetNCChanges` protocol misuse pattern. MDE sees credential dumping when LSASS memory is read by a non-authorized process. The two perspectives (network protocol vs endpoint behavior) complement each other.

**Q2:** Which Defender XDR capability correlates these as one incident?

**A2:** Incident correlation in Defender XDR automatically links MDI, MDE, and MDO alerts that share entities (users, devices, IPs). The attack story timeline visualizes the sequence. UEBA in MDE/MDI enriches user risk.

**Q3:** The analyst wants to isolate the workstation and disable the compromised user. Which response actions and where?

**A3:**
- MDE: "Isolate device" (full or selective)
- MDE: "Run antivirus scan"
- MDE: "Collect investigation package"
- Entra ID / Defender XDR: "Disable user in Microsoft Entra ID" (requires MDI with AD connected)
- Optional: "Force password reset"
The unified response action bar in Defender XDR can execute all of these without switching portals.

**Q4:** How should detection be strengthened going forward?

**A4:**
- Enforce Tier 0 asset protection: DCs, privileged accounts, ADFS
- Enable LAPS for local admin credentials
- Enable ASR rules: "Block credential stealing from LSASS", "Block process creations originating from PSExec and WMI commands"
- Ensure MDI sensors on all DCs and AD FS
- Tune MDI action accounts and honeytokens for early warning

## Scenario 5: Data Connector Misconfiguration Causing Missed Alerts

**Context:** The SOC manager noticed that Windows Security events from 50 servers have not been ingested for 3 days. An analyst sees the data connector shows "Received data" but specific servers are missing.

**Q1:** How to quickly confirm which servers are not reporting?

**A1:**
```kql
Heartbeat
| where TimeGenerated > ago(7d)
| summarize LastHeartbeat = max(TimeGenerated) by Computer
| where LastHeartbeat < ago(24h)
| sort by LastHeartbeat asc
```

**Q2:** Root cause investigation steps?

**A2:**
- Check Azure Monitor Agent installation and status on affected servers
- Verify Data Collection Rule (DCR) is associated with the VMs
- Confirm the DCR includes `Security!*` XPath for the Security log
- Confirm network egress to Log Analytics endpoints (*.ods.opinsights.azure.com, *.oms.opinsights.azure.com)
- Check VM extensions blade for failed AMA deployments

**Q3:** What preventative monitoring should be added?

**A3:** A Sentinel analytics rule based on `Heartbeat` staleness:
```kql
Heartbeat
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId
| where LastHeartbeat < ago(2h)
```
Plus automation rule that creates a ticket in ServiceNow via a Logic App playbook.

## Scenario 6: Insider Threat - Mass SharePoint Downloads

**Context:** An employee serving 2 weeks notice is observed downloading 5 GB of SharePoint content in 24 hours, much of it from sites outside their team's scope.

**Q1:** Which product provides the primary signal?

**A1:** Microsoft Purview Insider Risk Management (policies like "Data theft by departing users"). Alerts surface in the Purview portal and can be forwarded to Defender XDR (via the Microsoft Purview connector) for unified triage.

**Q2:** What additional Microsoft 365 data reinforces the hypothesis?

**A2:**
- `OfficeActivity` in Sentinel for FileDownloaded, FileSyncDownloadedFull
- Defender for Cloud Apps session policies (block downloads from unmanaged devices)
- Entra ID Sign-in logs for unusual device/IP combinations
- Endpoint DLP data via Defender for Endpoint (if attached to removable storage or synced to unmanaged device)

**Q3:** What blocking action is appropriate?

**A3:**
- Defender for Cloud Apps conditional access app control: block downloads for the user's sessions
- Purview adaptive protection: auto-tighten DLP for elevated insider risk users
- Entra ID conditional access: require compliant device for SharePoint access
- Revoke sync relationships in SharePoint admin center

## Scenario 7: Building a Custom Detection for Golden SAML

**Context:** After the SolarWinds-era campaigns, the organization wants to proactively detect Golden SAML abuse against AD FS and Entra ID.

**Q1:** What telemetry is necessary?

**A1:**
- AD FS audit logs (Event IDs 307, 324, 410, 411, 412, 1200, 1202)
- AD FS diagnostic logging forwarded via AMA to Sentinel
- Entra ID Sign-in logs, specifically `federatedTokenId` and `federatedTokenIssuer`
- Defender for Identity with AD FS sensor

**Q2:** What is one indicator that differentiates Golden SAML from normal federation?

**A2:** Sign-ins to Entra ID that federate from the on-prem AD FS but which have no corresponding AD FS issuance audit event (Event 324 or 1200) around the same timestamp. This indicates tokens forged offline with the stolen signing certificate.

**Q3:** Sketch the Sentinel scheduled rule logic.

**A3:**
```kql
let federationIssuer = "sts.contoso.com";
let window = 1h;
SigninLogs
| where TimeGenerated > ago(window)
| where FederatedIdpMfaBehavior == "federated"
| extend tokenIssuer = tostring(AuthenticationDetails[0].authenticationStepRequirement)
| join kind=leftanti (
    ADFSSignInLogs_CL
    | where TimeGenerated > ago(window)
    | project CorrelationId = tostring(CorrelationId_g)
) on CorrelationId
| project TimeGenerated, UserPrincipalName, IPAddress, AppDisplayName, CorrelationId
```
Tune based on your AD FS logging schema. Entity map UserPrincipalName and IPAddress.

## Scenario 8: Cost Overrun in Sentinel

**Context:** Sentinel ingestion has spiked from 80 GB/day to 400 GB/day after onboarding a new firewall. Finance is requesting a cost plan.

**Q1:** How to identify the top-volume tables?

**A1:**
```kql
Usage
| where TimeGenerated > ago(7d)
| where IsBillable == true
| summarize BillableGB = sum(Quantity) / 1000 by DataType
| sort by BillableGB desc
```

**Q2:** What tier strategies can lower cost without losing visibility?

**A2:**
- Move verbose firewall tables to **Auxiliary Logs** (low-cost, long retention, limited KQL)
- Move traffic logs to **Basic Logs** with KQL-limited queries at low ingestion cost
- Use **archive tier** for tables older than 90 days (up to 12 years)
- Purchase a **commitment tier** (100, 200, 300, 400, 500, 1000+ GB/day) for 15 to 60% discount
- Evaluate filtering at the AMA DCR or firewall syslog level to drop low-value events before ingestion
- Summarization rules: aggregate raw logs into summary tables for long-term analytics

**Q3:** Which tables still support analytics rules at each tier?

**A3:** Analytics tier = all features (analytics rules, long retention, alerts). Basic Logs = limited KQL, 30-day interactive retention, cannot be used directly in analytics rules (must be transformed via summary). Auxiliary Logs = long retention, very limited query performance, not for real-time detection.

## Scenario 9: Multi-Cloud Onboarding

**Context:** The org wants to protect 200 AWS EC2 instances and GCP GKE clusters alongside Azure VMs in the same Defender for Cloud tenant.

**Q1:** How is AWS onboarded?

**A1:** Via the **AWS connector** in Defender for Cloud (Environment settings > Add environment > AWS). Uses CloudFormation template to create an IAM role and permissions. The connector supports CSPM, Defender for Servers, SQL on AWS, and Containers. Agentless scanning uses snapshot-based approach.

**Q2:** How do GKE nodes get protected?

**A2:** GCP connector similarly creates a service account and workload identity federation. Defender for Containers deploys a Kubernetes cluster extension via Arc-enabled Kubernetes plus the Defender profile, providing runtime threat detection, vuln assessment, and Kubernetes data plane protection.

**Q3:** Where do cross-cloud alerts appear?

**A3:** All flow into Defender for Cloud > Security alerts and into Defender XDR incidents (if cloud platform integration with XDR is enabled). From there, Sentinel ingests via the Defender for Cloud data connector.

## Scenario 10: KQL Hunt for Persistence via Scheduled Task

**Context:** Hunt for attackers establishing persistence via `schtasks.exe` with suspicious parameters.

**Answer query:**
```kql
DeviceProcessEvents
| where Timestamp > ago(14d)
| where FileName =~ "schtasks.exe"
| where ProcessCommandLine has_any ("/create", "/change") 
| where ProcessCommandLine has_any ("powershell", "cmd", "rundll32", "mshta", "regsvr32", "http://", "https://")
| extend InitiatingParent = InitiatingProcessParentFileName, InitiatingProcess = InitiatingProcessFileName
| project Timestamp, DeviceName, AccountName, ProcessCommandLine, InitiatingProcess, InitiatingParent, SHA256
| join kind=leftouter (
    AlertEvidence
    | where EntityType == "Process"
) on $left.SHA256 == $right.SHA256
| sort by Timestamp desc
```

This maps to MITRE T1053.005 (Scheduled Task/Job: Scheduled Task). Productionize by creating a scheduled analytics rule grouping by DeviceName and AccountName, mapping entities, and setting severity Medium with `IncidentConfiguration` grouping.

## Scenario 11: Playbook Design for Phishing

**Context:** Design an automation rule and playbook pair so every phishing incident automatically: enriches the sender domain with VirusTotal, posts to a Teams channel, disables the user on repeat, and waits for analyst approval to purge.

**Design:**
1. **Automation rule** triggered on "When incident created" filtered to analytics rule name = "Phishing email detected"
2. Run **Playbook A** (no approval) that:
   - Gets incident entities (users, URLs, domains, mailboxes)
   - Calls VirusTotal via HTTP connector with API key in Key Vault
   - Posts a Teams adaptive card summarizing findings
   - Adds VT verdict as comment on incident
3. Run **Playbook B** (requires analyst approval) that:
   - Posts adaptive card to Teams with "Purge" / "Keep" buttons
   - On Purge: calls Defender for Office 365 API or Microsoft Graph `threatAssessmentRequests` to remove mail
   - Adds comment with action taken
4. **Conditional action** in the automation rule: if user has 3+ phishing incidents in 30 days (lookup via Sentinel query in Playbook C), auto-disable the user via Entra ID Graph API

**Permissions:** Managed identity for the Logic App assigned Sentinel Responder on the workspace, `User.EnableDisableAccount.All` on Graph, Key Vault secret read.

## Scenario 12: Exam-Style Case Study Composite

**Context:** Contoso Ltd has the following environment:
- 5000 Windows 11 endpoints managed by Intune
- 300 Linux servers (mix of Ubuntu and RHEL)
- Microsoft 365 E5 with Defender XDR enabled
- Azure: 2 subscriptions, 50 VMs, 5 App Services, 3 SQL DBs
- AWS: 80 EC2 instances, 10 RDS instances
- Compliance requirements: PCI-DSS for payment-related subscriptions, HIPAA for the healthcare division

**Q1:** Which single Microsoft product set gives unified incident visibility across all of this?

**A1:** Microsoft Sentinel (for SIEM/long-retention across all sources and AWS) combined with Microsoft Defender XDR (for unified Microsoft-stack incidents). Integrate Defender XDR > Sentinel bidirectionally so incidents sync. Enable Defender for Cloud across Azure and AWS, which feeds alerts into both.

**Q2:** How should compliance dashboards be implemented?

**A2:** Defender for Cloud's **Regulatory Compliance** dashboard supports PCI-DSS and HIPAA/HITRUST out of the box. Assign the respective initiatives to in-scope subscriptions. The dashboard surfaces non-compliant resources and remediation steps. Export findings to Sentinel via the Defender for Cloud connector for long-term tracking and audit.

**Q3:** How should the SOC be structured for minimum admin effort?

**A3:**
- Tier 1: Work in Defender XDR portal for day-to-day incident triage (unified queue, single UI)
- Tier 2/3: Pivot to Sentinel for hunting and custom analytics across non-Microsoft sources
- Use **Unified RBAC** in Defender XDR and Sentinel-specific RBAC for least-privilege assignments
- Automate routine tasks (assignment, tagging, first-touch enrichment) via automation rules and playbooks
