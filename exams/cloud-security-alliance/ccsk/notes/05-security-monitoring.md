# 05 - Security Monitoring (Guidance Domain 6)

## Domain Overview

Guidance Domain 6 covers logging, monitoring, detection, and SIEM/SOAR capabilities for cloud environments. Cloud introduces new log sources (control plane, API access, shared services) while also enabling new detection approaches (native services, cross-region visibility, API-based automation).

## What to Monitor in Cloud

### Control Plane Activity
Every API call that configures cloud resources:
- AWS CloudTrail (management and data events)
- Azure Activity Log + Resource diagnostic logs
- GCP Cloud Audit Logs:
  - Admin Activity (always on, free)
  - Data Access (optional, higher volume)
  - System Event
  - Policy Denied

Control plane monitoring is the foundation: it tells you who did what in your cloud account.

### Identity Events
- Sign-ins (successful and failed)
- MFA challenges
- Risky sign-ins (anomalous geo, device, behavior)
- Account lockouts
- Privilege elevations and role assumptions
- OAuth consents
- Token issuance
- Password changes

### Network Flow
- VPC Flow Logs
- DNS query logs
- TLS inspection logs (if enabled)
- Egress gateway logs
- Load balancer access logs
- WAF logs
- CDN logs

### Application Logs
- Request/response logs (at application layer, with sensitive data redacted)
- Error logs
- Custom business logic events

### Database Audit
- Queries (especially against sensitive tables)
- Schema changes
- Privilege changes
- Connection attempts

### Endpoint / Workload Logs
- Process execution
- File access
- Network connections
- OS audit trail

### Security Service Logs
- Cloud security service findings (GuardDuty, Defender, Security Command Center)
- Third-party tool logs (CSPM, CWPP, CNAPP, SIEM)
- WAF, IDS, endpoint protection

## Cloud-Native Logging Services

### AWS
- CloudWatch Logs (general log aggregation)
- CloudTrail (control plane)
- S3 Access Logs (bucket access)
- VPC Flow Logs (network)
- ELB/ALB/NLB Access Logs

### Azure
- Azure Monitor + Log Analytics Workspace
- Activity Log (subscription-level control plane)
- Resource Diagnostic Logs (per-service)
- NSG Flow Logs
- Sign-in and Audit Logs (Entra ID)

### GCP
- Cloud Logging (unified)
- Cloud Audit Logs (Admin Activity, Data Access, System Event, Policy Denied)
- VPC Flow Logs
- Firewall Rules Logs

## Log Centralization

### Multi-Account / Multi-Project
- Aggregate logs from all accounts into a dedicated log archive account/project
- Cross-account delivery (AWS) or diagnostic settings (Azure) or log sinks (GCP)
- Separate identity scope (attackers with workload access cannot delete logs)

### Multi-Region
- Consolidate across regions
- Account for data residency (some logs contain regulated data)

### Multi-Cloud
- Cross-cloud aggregation to a cloud-agnostic SIEM
- Common schema/normalization (OCSF, ECS, CIM)

## Log Retention and Storage

### Tiered Storage
- **Hot** (searchable, interactive) - recent logs for detection
- **Warm** (searchable slower) - extended detection window
- **Cold / Archive** (cheap, restore required) - compliance retention

### Retention Drivers
- Regulatory (HIPAA 6yr, PCI 1yr online + 1yr archive, SOX 7yr)
- Business incident investigation window
- Audit support
- Forensic readiness

### Immutability
- Object Lock (AWS S3 Compliance mode)
- Azure Blob immutability policy
- GCP Bucket Lock
- Protects against insider tampering and ransomware

## What NOT to Log

Avoid logging:
- Passwords (even hashed)
- Full PANs (payment card numbers) per PCI DSS
- SSN, government IDs in plaintext
- Session tokens
- API keys, secrets
- OAuth bearer tokens
- PHI (HIPAA-restricted unless specifically necessary)
- Personal data beyond data minimization

Implement structured logging with field-level redaction. Review log content during design.

## SIEM (Security Information and Event Management)

Centralizes logs, correlates events, raises alerts, supports investigation.

### Cloud-Native or Cloud-Hosted SIEMs
- Microsoft Sentinel (cloud-native on Azure)
- Splunk Cloud
- Elastic Security (self-hosted or cloud)
- Google Chronicle / SecOps
- Sumo Logic
- Exabeam
- Securonix
- Rapid7 InsightIDR

### Detection Use Cases
- Unauthorized access attempts
- Unusual data access patterns
- Privilege escalations
- Suspicious network connections
- Compliance violations (e.g., new public bucket)
- Malware indicators
- Insider threat patterns

### Correlation and Enrichment
- Threat intelligence matching (IOCs)
- User and entity behavior analytics (UEBA)
- Geolocation enrichment
- Asset criticality weighting

## SOAR (Security Orchestration, Automation, and Response)

Automates routine incident response tasks:
- Runbook automation
- Ticket creation and enrichment
- Notification and escalation
- Automated containment (e.g., isolate VM, disable user)
- Integration with SIEM, EDR, ticketing, ChatOps

Cloud advantage: everything is API; automation is native.

Examples: Palo Alto Cortex XSOAR, Splunk SOAR (Phantom), IBM Resilient, Microsoft Sentinel playbooks (Logic Apps), Tines, Torq.

## Cloud-Specific Detection Services

Each cloud provider offers native threat detection:

### AWS
- GuardDuty - threat detection on VPC flow, DNS, CloudTrail, EKS audit, S3 data events, Lambda, Malware protection
- Macie - S3 sensitive data discovery
- Inspector - vulnerability assessment
- Security Hub - findings aggregation
- Detective - investigation (graph-based)

### Azure
- Microsoft Defender for Cloud - CSPM + CWPP across workloads
- Microsoft Sentinel - SIEM/SOAR
- Microsoft Defender XDR - endpoint/identity/email XDR
- Entra ID Protection - identity risk

### GCP
- Security Command Center (SCC) - unified CSPM + threat detection
- Chronicle / SecOps - SIEM
- Event Threat Detection
- Container Threat Detection
- Virtual Machine Threat Detection

## Third-Party CNAPP / Cloud Security Platforms

- Wiz
- Palo Alto Prisma Cloud
- Check Point CloudGuard
- Lacework
- Orca Security
- Rapid7 InsightCloudSec
- Aqua Security (container-focused)
- Sysdig
- CrowdStrike Falcon Cloud Security

## Detection Engineering

### Tactics
- Rule-based detections (KQL, SPL, YARA)
- Anomaly detection (statistical, ML)
- UEBA (behavior baselines)
- Threat intelligence matching
- Correlation across sources
- Known-bad and known-good allowlists

### MITRE ATT&CK Alignment
Map detections to MITRE techniques:
- Coverage visualization (identify gaps)
- Priority tuning (common techniques first)
- Response playbook mapping

Cloud-specific MITRE ATT&CK matrices:
- Cloud matrix (IaaS, PaaS, SaaS, Office 365, Google Workspace, Entra ID)
- Containers matrix
- Kubernetes extensions

### Detection Lifecycle
1. Hypothesis (threat to detect)
2. Data requirements (what sources needed)
3. Query/rule development
4. Testing (true positives and false positives)
5. Tuning (reduce noise)
6. Operational deployment
7. Continuous review

## Continuous Compliance Monitoring

### CSPM Functions
- Continuous assessment against benchmarks (CIS, vendor best practices)
- Multi-framework compliance mapping (PCI, HIPAA, GDPR, NIST, ISO)
- Drift detection
- Auto-remediation (optional, carefully scoped)
- Reporting and trending

### Key Misconfigurations Detected
- Public storage buckets
- Unencrypted resources
- Open security groups (0.0.0.0/0)
- MFA not enforced
- Logging not enabled
- Stale snapshots
- Unused identities
- Overpermissioned roles
- Deprecated service versions

## Log Integrity

- Append-only destinations
- Cryptographic hashing or chained hashing
- Restricted access (separation of duties)
- Time synchronization (NTP, cloud-provided)
- Monitoring for log gaps or tampering attempts
- Separate identity scope for log storage

## Time Synchronization

Critical for cross-source correlation:
- Cloud providers offer reliable NTP
- All systems should use cloud provider's NTP
- UTC standardization
- Sub-second precision for incident timeline reconstruction

## Alert Management

### Alert Quality
- Actionable (analyst knows what to do)
- Well-contextualized (enrichment)
- Prioritized (severity, asset criticality)
- Low false positive rate (tune or suppress)
- Integrated with ticketing and ChatOps

### Alert Fatigue
Leading cause of missed incidents. Mitigations:
- Aggressive tuning
- Suppression rules for known benign
- Risk-based scoring
- UEBA to reduce noise
- Regular review of alert effectiveness

## Threat Intelligence Integration

### Sources
- Commercial feeds (Recorded Future, Mandiant, CrowdStrike)
- Government (CISA, NCSC)
- Industry ISACs
- Open source (MISP, AlienVault OTX)

### Integration Patterns
- IOC matching in SIEM
- Enrichment of alerts
- Threat actor and campaign attribution
- Vulnerability prioritization (exploit availability)

## Security Data Lake

Emerging pattern: separate security data lake for cost-effective long-term retention and analytics:
- Raw logs in low-cost object storage
- Schema-on-read (Parquet, Iceberg, Delta Lake)
- Query with Athena, BigQuery, Synapse
- SIEM ingests only high-value data; data lake holds everything

## Cloud Monitoring Best Practices

- Enable control plane logging from day one (CloudTrail, Activity Log, Cloud Audit Logs)
- Centralize logs cross-account
- Protect log destination (separate account, immutable)
- Monitor identity events heavily
- Integrate native detection services
- Build detection engineering capability
- Tune aggressively (alert quality over quantity)
- Automate response where safe (SOAR)
- Continuous compliance via CSPM
- Document what is being monitored and what is not (known gaps)

## Common Exam Pitfalls

- Storing logs in the same account as the workload
- Missing data access logs (expensive but critical for DPP)
- Forgetting time synchronization
- Logging sensitive data
- Treating CSPM as sufficient (it detects config, not runtime threats)
- Not integrating threat intelligence
- Leaving default verbose logging enabled in production (cost + privacy)

## Quick Reference: Monitoring Decision

| Need | Tool Category |
|------|---------------|
| Configuration compliance | CSPM |
| Runtime workload threats | CWPP |
| Identity risk | Entra ID Protection / equivalent + CIEM |
| SaaS configuration | SSPM |
| Log aggregation and detection | SIEM |
| Automated response | SOAR |
| Native cloud threats | Provider-specific (GuardDuty, Defender, SCC) |
| Sensitive data discovery | Macie, Purview, DSPM |
| Cross-cloud unified | CNAPP |
