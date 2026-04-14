# SC-200 Practice Plan - 7 Week Schedule

This plan assumes approximately 8 to 12 hours per week of focused study. Adjust up to 10 weeks if you have no prior Microsoft security platform exposure, or compress to 5 weeks if you are an active SOC analyst already using these tools.

## Prerequisites Check

Before starting, confirm comfort with:
- Azure portal navigation, Entra ID basics, subscription structure
- Reading JSON and common log formats
- Windows event logs and Linux syslog conceptually
- Basic networking (DNS, HTTP, TCP/IP)
- MITRE ATT&CK framework at a high level

If gaps exist, spend a preparatory week on AZ-900 and SC-900 content.

## Lab Environment Setup

Set up these resources in week 1 and keep them running throughout the study period:
- **Microsoft 365 E5 trial** (30 days, renewable) - unlocks Defender XDR workloads
- **Azure free account** with credits for Sentinel workspace
- **Microsoft Sentinel Training Lab** (GitHub: Azure/Azure-Sentinel) - deploys sample data
- **Defender for Cloud free tier** plus a 30-day trial of Defender plans
- Optional: deploy a Windows 11 VM and onboard to MDE to generate real telemetry

Budget: Expect $50 to $150 for Azure spend across study period if trials are used aggressively.

## Week 1: Foundations and Defender XDR

**Goals:** Understand the Microsoft security stack, set up labs, get oriented in the unified portal.

**Topics:**
- Microsoft security portfolio: Defender XDR, Defender for Cloud, Sentinel, Purview, Entra
- security.microsoft.com portal navigation
- Incident queue, Alert queue, Action center, Settings
- RBAC: Unified RBAC for Defender XDR, roles and permissions

**Activities:**
- Stand up M365 E5 trial tenant
- Enable Defender for Endpoint, Office 365, Identity, Cloud Apps
- Onboard at least one Windows endpoint to MDE
- Simulate an attack using the MDE evaluation lab
- Read: notes/01-microsoft-defender-xdr.md

**Deliverable:** Screenshot your Defender XDR portal with at least one incident present.

## Week 2: Microsoft Sentinel Architecture and Data Ingestion

**Goals:** Deploy Sentinel, connect core data sources, understand workspace design.

**Topics:**
- Log Analytics workspace as Sentinel foundation
- Sentinel deployment prerequisites and costs
- Data connectors: Entra ID, Activity, M365, Defender XDR, AWS, GCP, syslog/CEF
- Azure Monitor Agent (AMA) vs Microsoft Monitoring Agent (MMA, legacy)
- Data collection rules (DCRs)
- Commitment tiers, Basic Logs, Auxiliary Logs, archive

**Activities:**
- Deploy a Sentinel workspace
- Connect Entra ID Sign-in Logs, Azure Activity, Microsoft 365 Defender
- Install AMA on a VM, configure DCR for Windows Security events
- Browse Content Hub, install the Azure Activity solution
- Read: notes/02-microsoft-sentinel-fundamentals.md

**Deliverable:** Table inventory showing your connected tables with last received timestamps.

## Week 3: KQL Deep Dive

**Goals:** Write comfortable, accurate KQL queries for investigation and hunting.

**Topics:**
- KQL query structure and tabular expressions
- Filtering (`where`), projection, aggregation (`summarize`)
- Time functions, `ago()`, `bin()`, `startofday()`
- `join` kinds: inner, leftouter, rightsemi, leftanti
- String functions: `parse`, `extract`, `split`, `has`, `contains`, `matches regex`
- Arrays and dynamic: `mv-expand`, `mv-apply`, `bag_unpack`
- `make-series` and time charts
- Performance: datatype choices, filter early, avoid `contains` when `has` works

**Activities:**
- Complete Microsoft Learn "Write your first query with KQL" module
- Solve 20+ queries against SecurityEvent, SigninLogs, DeviceProcessEvents
- Practice on the KQL Detective game (detective.kusto.io)
- Read: notes/03-kql-for-security.md

**Deliverable:** Your own KQL cheat sheet with 30 queries you can adapt.

## Week 4: Detections, Analytics Rules, and Automation

**Goals:** Create, tune, and automate detections across Sentinel and Defender XDR.

**Topics:**
- Analytics rule types and when to use each
- Entity mapping, custom details, alert enrichment
- Grouping alerts into incidents, alert suppression
- Automation rules: triggers, conditions, actions, ordering
- Playbooks with Logic Apps: triggers, connectors, permissions
- Defender XDR custom detection rules

**Activities:**
- Create 5 scheduled analytics rules mapped to MITRE tactics
- Build an automation rule that tags and assigns incidents by severity
- Author a playbook that posts incident details to Teams and enriches with IP geolocation
- Create a Defender XDR custom detection rule in advanced hunting
- Read: notes/04-incident-investigation-and-response.md

**Deliverable:** At least one incident routed end-to-end from alert to Teams post.

## Week 5: Incident Response and Investigation

**Goals:** Execute full IR workflow in both Defender XDR and Sentinel.

**Topics:**
- Incident triage: severity, status, assignment
- Attack story timeline in Defender XDR
- Evidence and response actions: isolate device, collect investigation package, run antivirus scan, restrict app execution, live response
- Automated investigation and response (AIR) and pending actions
- Sentinel investigation graph and entity behavior pages
- Comments, tags, and hand-off between analysts

**Activities:**
- Use the MDE attack simulation or Attack Simulation Training to generate an incident
- Execute a full IR workflow including device isolation and live response
- Practice investigating a phishing incident end-to-end in Defender for Office 365
- Use UEBA (if enabled) to pivot on a suspicious user
- Read: notes/06-defender-for-cloud-and-endpoint.md

**Deliverable:** Written incident report following the NIST IR lifecycle based on a simulated attack.

## Week 6: Threat Hunting

**Goals:** Develop and execute hypothesis-driven hunts.

**Topics:**
- Hunting methodology: hypothesis, data sources, query, validate, escalate
- Hunting page in Sentinel and Defender XDR
- Livestream hunting
- Bookmarks and handoff to incidents
- Notebooks in Sentinel (MSTICpy, Jupyter)
- Threat intelligence integration: TAXII, MDTI, Platforms connector

**Activities:**
- Build 10 hunting queries mapped to MITRE techniques (T1566, T1078, T1110, T1059, etc.)
- Enable UEBA and review anomalies
- Import MITRE ATT&CK workbook
- Explore a Sentinel notebook via Azure ML
- Read: notes/05-threat-hunting.md

**Deliverable:** 10 custom hunting queries saved in Sentinel with MITRE mapping.

## Week 7: Defender for Cloud, Review, Practice Exams

**Goals:** Close gaps on Defender for Cloud; simulate exam conditions.

**Topics:**
- Defender for Cloud plans: Servers, Storage, SQL, Containers, App Service, Key Vault, DNS, APIs, AI
- Secure Score, recommendations, governance rules
- Regulatory compliance dashboard
- Attack path analysis, cloud security graph, risk prioritization (Defender CSPM)
- Multi-cloud onboarding: AWS, GCP connectors

**Activities:**
- Enable at least 3 Defender for Cloud plans in your lab
- Remediate 10 Secure Score recommendations
- Enable CSPM and review the attack path for a public VM
- Take 2 full-length practice exams (MeasureUp, Whizlabs)
- Review all domain notes and fact sheet twice

**Deliverable:** Practice exam scores of 80%+ consistently before sitting the real exam.

## Final Week Readiness Checklist

- Can write a KQL query from memory that summarizes failed logons by account over the last 24 hours
- Can explain the difference between scheduled, NRT, and Fusion rules
- Can describe the full incident response workflow end-to-end
- Know which Defender plan covers which workload
- Can list 10 MITRE tactics in order
- Can describe the difference between automation rules and playbooks
- Have reviewed 3+ Microsoft case study style questions
- Scored 80%+ on 2 full practice exams within the last 7 days
- Tested your exam environment (online proctor) or confirmed test center logistics

## Exam Day

- Review strategy.md the night before
- Sleep 7 to 8 hours
- Eat a protein-rich meal, hydrate
- Arrive 30 minutes early (in-person) or do check-in 30 minutes early (online)
- Scratch paper/whiteboard allowed online; one laminated sheet in-person
- 100 minutes for 40 to 60 questions = 1.6 to 2.5 minutes/question
- Use mark-for-review liberally; case studies come last and cannot be revisited
