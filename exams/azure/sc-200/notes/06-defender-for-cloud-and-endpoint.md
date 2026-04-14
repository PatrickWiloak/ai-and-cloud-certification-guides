# 06 - Defender for Cloud and Endpoint

## Microsoft Defender for Cloud (MDfC)

Microsoft Defender for Cloud is Microsoft's CNAPP (Cloud-Native Application Protection Platform) covering CSPM (Cloud Security Posture Management) and CWPP (Cloud Workload Protection Platform). It protects multi-cloud (Azure, AWS, GCP) and hybrid environments.

### Two pillars

**CSPM** answers: What am I deploying that is misconfigured?
- Continuous assessment against security baselines
- Secure Score
- Regulatory compliance dashboards
- Recommendations with remediation guidance

**CWPP** answers: What threats are happening to my running workloads?
- Per-workload threat detection plans (Servers, Storage, SQL, etc.)
- Runtime alerts forwarded to Sentinel/XDR

### CSPM Tiers

| Tier | Cost | Capabilities |
|------|------|--------------|
| Foundational CSPM | Free | Asset inventory, secure score, regulatory compliance, recommendations, attack paths (limited) |
| Defender CSPM | Per billable resource (~$5/asset/month) | Cloud Security Graph, attack path analysis, agentless secret scanning, agentless vuln scanning, sensitive data discovery, IaC scanning, container posture, EASM (preview), permissions management |

### Defender Plans (CWPP)

| Plan | Coverage |
|------|----------|
| Servers Plan 1 | MDE integration, vulnerability assessment, file integrity monitoring (preview at P1), security baselines |
| Servers Plan 2 | Adds Just-in-Time VM access, adaptive application controls, network hardening, regulatory compliance, 500MB free Sentinel ingestion for selected security data |
| Storage | Malware scanning of uploaded blobs, sensitive data threat detection, activity monitoring |
| SQL on Azure (PaaS and VMs) | Anomaly detection, SQL injection, vulnerability assessment |
| Containers | Vuln scanning of registry images and running images, runtime threat detection, K8s admission control, K8s data plane protection |
| App Service | Runtime threat detection for App Service environments |
| Key Vault | Anomalous access detection |
| Resource Manager | Suspicious ARM operations |
| DNS | Malicious DNS resolution detection |
| Open-source Relational DBs | PostgreSQL, MySQL, MariaDB threat detection |
| Cosmos DB | NoSQL anomaly detection |
| APIs (Azure API Management) | Runtime API protection |
| AI Workloads | LLM/genAI prompt injection, jailbreak, sensitive data |

### Multi-Cloud Onboarding

**AWS connector:**
- Created via Defender for Cloud > Environment Settings > Add environment > AWS
- Deploys CloudFormation stack to AWS account creating IAM roles
- Optional auto-provisioning of Arc agents for VM coverage
- Discovers EC2, EKS, RDS, S3, Lambda, etc.

**GCP connector:**
- Workload identity federation
- Service account in GCP project
- Cloud Build trigger for deploying agents

**On-prem and other clouds:**
- Azure Arc enables management of non-Azure servers and Kubernetes
- Once Arc-onboarded, Defender plans apply

### Secure Score

Numeric score (0-100%) representing security posture:
- Each recommendation worth a point value
- Implementing recommendations or marking exemptions improves score
- Group score = aggregated across subscriptions or management groups
- Used as KPI for security teams; not a compliance proxy

### Recommendations

Each recommendation has:
- Severity (High/Medium/Low)
- Affected resources
- Remediation steps
- Quick-fix automation (where supported)
- Mapping to compliance frameworks

Status options: Healthy, Unhealthy, Not Applicable, Exempt.

Governance rules assign owners and due dates to recommendations to drive remediation accountability.

### Regulatory Compliance

Built-in initiatives for:
- Microsoft Cloud Security Benchmark (MCSB) - default
- PCI-DSS v4
- HIPAA HITRUST
- ISO 27001:2013/2022
- SOC 2 Type 2
- NIST SP 800-53, SP 800-171, CSF
- CIS Microsoft Azure Foundations Benchmark
- FedRAMP H/M
- CMMC Level 3
- UK NHS, Australian PSPF, regional standards

Custom initiatives via Azure Policy. Compliance dashboard exports findings to PDF, supports continuous export to Sentinel and Event Hub.

### Cloud Security Graph (Defender CSPM)

Graph database of all discovered cloud resources, identities, workloads, exposures, and relationships. Enables:

- **Attack path analysis** - Visualizes chains of misconfigurations that attackers could exploit (e.g., public VM with high-sev vuln + identity with admin role + access to KV with secrets)
- **Cloud security explorer** - Custom queries against the graph (e.g., "Internet-exposed VMs with critical CVEs and managed identities with subscription-owner role")
- Risk-prioritized recommendations based on actual exposure

## Microsoft Defender for Endpoint (MDE)

Endpoint detection and response (EDR), antivirus (Microsoft Defender Antivirus), attack surface reduction, vulnerability management, and threat & vulnerability management.

### Plans

| Plan | Coverage |
|------|----------|
| MDE P1 | Next-gen AV, attack surface reduction, device control, web content filtering, endpoint firewall, application control |
| MDE P2 | All P1 + EDR, automated investigation and response, threat & vulnerability management, threat experts (paid), advanced hunting |
| MDE Server | MDE P2 features for server SKUs (covered by Defender for Servers Plan 1/2 in Defender for Cloud) |
| MDE for Business | SMB SKU bundled with Microsoft 365 Business Premium |

### Onboarding methods

- **Group Policy** - on-prem Windows
- **Microsoft Intune (MEM)** - cloud-managed Windows, macOS, iOS, Android, Linux
- **System Center Configuration Manager (SCCM)** - hybrid
- **Local script** - pilot/manual
- **VDI** - non-persistent VMs with VDI onboarding
- **Server via Defender for Cloud** - automatic for Azure Arc / Defender for Servers
- **macOS, Linux** - shell scripts and config profiles

### Attack Surface Reduction (ASR) Rules

15+ rules to block common attack vectors:
- Block credential stealing from LSASS
- Block Office apps from creating child processes
- Block Office apps from creating executable content
- Block executable content from email/webmail
- Block JavaScript or VBScript from launching downloaded executable content
- Block process creations from PsExec and WMI
- Block persistence through WMI event subscription
- Block untrusted/unsigned processes from USB
- Use advanced protection against ransomware

Modes: Audit, Block, Warn (limited), Disabled. Pilot in Audit, then enforce.

### Endpoint security policies (in Intune/MEM)

- Antivirus
- Disk encryption
- Firewall
- Endpoint detection and response (telemetry, isolation tag)
- Attack surface reduction
- Account protection
- Device compliance

### Threat and Vulnerability Management (TVM)

Built-in risk-based vuln management:
- Continuous discovery of CVEs across installed software
- Exposure score (lower is better, opposite of secure score)
- Recommendations prioritized by exploit availability, breach status, asset criticality
- Browser extension assessment
- Network share configuration assessment
- Authenticated scan for Windows and network devices
- Integration with Intune to push remediation

### Live Response

Remote shell to investigate or remediate endpoints:
- Browse file system
- Get/put files
- Run scripts (curated library)
- Run binaries from approved library
- View running processes, services, scheduled tasks, persistence locations
- Logged in `DeviceEvents` table

Permissions:
- Live response basic - browse, copy files, run commands
- Live response advanced - run unsigned scripts, run executable

### Web Content Filtering

Category-based blocking (Adult, Gambling, Liability, etc.) at network egress on managed endpoints. Reports surface in MDE > Reports > Web protection.

### Device Control

USB removable storage policies, printer redirection control, Bluetooth control. Defined via Intune or local Group Policy.

### Indicators (IOCs)

Block hashes, IPs, URLs, domains, certificates organization-wide. Limits: 15,000 indicators per type per tenant. Set via portal, MDE API, or via Defender XDR Threat Intelligence integration.

## Defender for Cloud + Defender for Endpoint Integration

Defender for Servers Plan 1 includes MDE deployment to Azure VMs and Arc-enabled servers automatically. The MDE agent provides:

- EDR telemetry to Defender XDR (advanced hunting)
- Vulnerability assessment to Defender for Cloud
- Behavioral analytics to both surfaces
- Live response capability
- ASR rules

Plan 2 adds JIT VM access, adaptive application controls (machine learning allowlist), network hardening (suggested NSG tightening), and 500MB/day Sentinel ingestion of selected MDC tables.

## Microsoft Defender for Identity (MDI)

Detects identity-based attacks against on-prem AD, AD FS, AD CS, and Entra Connect:

- Sensors installed on Domain Controllers, AD FS, AD CS servers (lightweight)
- Detects: DCSync, DCShadow, Golden Ticket, Silver Ticket, Pass-the-Hash, Pass-the-Ticket, Skeleton Key, AS-REP roasting, Kerberoasting, NTLM relay, suspicious LDAP/SAMR queries
- ITDR (Identity Threat Detection and Response) capability set
- Integration with Entra ID Protection for hybrid identity risk scoring
- Action accounts for response (disable user, force password reset on-prem)
- Honeytoken accounts to flag adversary recon

## Microsoft Defender for Office 365 (MDO)

Email and collaboration security:

- Safe Links (URL rewriting and time-of-click protection)
- Safe Attachments (sandbox detonation)
- Anti-phishing policies (impersonation protection, spoof intelligence, mailbox intelligence)
- Anti-spam, anti-malware policies
- Threat Explorer / Real-time Detections for hunting and remediation
- Attack Simulation Training for end-user phishing exercises
- Quarantine management

P1: Safe Links, Safe Attachments, anti-phish basic. P2: Adds Threat Explorer, AIR, Attack Simulation, campaign views.

## Microsoft Defender for Cloud Apps (MDA, formerly MCAS)

Cloud Access Security Broker (CASB):

- App discovery (analyzes proxy/firewall logs to find shadow IT)
- Cloud app catalog with risk scoring
- Connected apps via APIs (M365, Salesforce, Workday, GitHub, AWS, Azure, GCP) for monitoring and governance
- Conditional Access App Control for inline session monitoring (block download, block paste, etc.)
- Activity policies, file policies, anomaly policies, OAuth app policies
- App governance add-on for OAuth app risk management

## Common Exam Pitfalls

- Confusing Defender for Cloud (workloads) with Defender for Cloud Apps (SaaS apps)
- Mixing MDI (on-prem AD) with Entra ID Protection (cloud identity)
- Selecting Servers P1 when JIT/adaptive controls (P2) are required
- Forgetting that Defender CSPM is a separate paid plan beyond foundational CSPM
- Not knowing that ASR rules have Audit mode for piloting
- Picking AV settings via SCCM when Intune endpoint security is the modern path
- Misidentifying the right Defender plan for a workload (Storage vs Cosmos vs SQL)

## Quick Reference: Plan to Workload

| Workload | Plan |
|----------|------|
| Azure VM, Arc server | Defender for Servers P1/P2 |
| Azure Storage | Defender for Storage |
| Azure SQL DB / Managed Instance / SQL on VMs | Defender for SQL |
| Cosmos DB | Defender for Cosmos DB |
| Postgres/MySQL/MariaDB | Defender for open-source DBs |
| AKS, ARO, EKS, GKE | Defender for Containers |
| Azure App Service | Defender for App Service |
| Azure Key Vault | Defender for Key Vault |
| Azure Resource Manager | Defender for Resource Manager |
| Azure DNS | Defender for DNS |
| Azure API Management | Defender for APIs |
| Azure OpenAI / AI Studio | Defender for AI |
| Endpoint (workstation/laptop) | MDE P1 or P2 (via M365 license) |
| Email/M365 collaboration | MDO P1 or P2 |
| On-prem AD | MDI |
| SaaS apps / shadow IT | MDA |
