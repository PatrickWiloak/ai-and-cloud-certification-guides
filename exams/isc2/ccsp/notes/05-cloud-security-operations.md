# 05 - Cloud Security Operations (Domain 5, 16%)

## Domain Overview

Domain 5 covers the day-to-day execution of security in cloud environments: implementing and operating infrastructure, managing operations, supporting forensics, vulnerability management, change management, communication, and security operations centers (SOCs).

## Implement and Build Physical and Logical Infrastructure

### Physical Infrastructure (Provider-Managed)
While cloud customers do not implement physical infrastructure, CCSP candidates must understand provider expectations:
- Tier I-IV data centers (Uptime Institute)
- Power: dual feeds, UPS, generators
- Cooling: redundant HVAC
- Fire suppression
- Physical access controls
- Environmental monitoring
- Customer assurance via SOC 2, ISO 27001, FedRAMP attestations

### Logical Infrastructure (Customer-Managed)
- Virtual networks (VPC/VNet)
- Compute resources (VMs, containers, serverless)
- Storage
- Identity and access management
- Security services (firewalls, IDS, KMS)
- Logging and monitoring
- Backup and DR

### Implementation via Infrastructure as Code (IaC)
- Declarative definitions: Terraform, CloudFormation, ARM, Bicep, Pulumi, CDK
- Version controlled
- Peer reviewed
- Tested (validation, plan)
- Scanned for security (Checkov, tfsec, Terrascan, OPA)
- Deployed via CI/CD with approvals
- Drift detection (cloud configuration vs IaC source of truth)

## Operate Physical and Logical Infrastructure

### Image Management
- Hardened baseline images per OS family
- CIS Benchmarks, vendor security baselines, custom corporate baselines
- Patched regularly (image refresh cadence)
- Stored in trusted artifact repositories
- Signed and version-controlled

### Patch Management
- Inventory all assets
- Subscribe to vendor security feeds
- Test patches in non-production
- Phased rollout (rings)
- Verification via vulnerability scan
- Exception tracking with compensating controls
- Cloud-managed services: provider patches; customer schedules maintenance windows

### Configuration Management
- Maintain desired state
- Tools: Ansible, Puppet, Chef, SaltStack, cloud-native (Azure Automation, AWS Systems Manager)
- Drift detection and remediation
- Audit trail of changes

### Vulnerability Management
- Continuous scanning (CSPM for posture, agent/agentless for workload vulns)
- Risk-based prioritization (CVSS, EPSS, KEV catalog, business context)
- SLAs by severity
- Remediation tracking
- Exception process

### Cloud-Native Security Operations Tools
- **CSPM (Cloud Security Posture Management)** - Configuration risk
- **CWPP (Cloud Workload Protection Platform)** - Runtime protection
- **CIEM (Cloud Infrastructure Entitlement Management)** - Identity and access risk
- **CNAPP (Cloud-Native Application Protection Platform)** - Convergent of above
- **SaaS Security Posture Management (SSPM)** - SaaS application configuration
- **Data Security Posture Management (DSPM)** - Data discovery and access risk

## Manage Physical and Logical Infrastructure

### Inventory Management
- Asset inventory (servers, services, identities, keys, data stores)
- Cloud-native: AWS Config, Azure Resource Graph, GCP Asset Inventory
- Tagging strategy (owner, environment, classification, cost center)
- CMDB integration

### Capacity Management
- Monitoring resource utilization
- Right-sizing recommendations
- Cost optimization (FinOps overlap)
- Auto-scaling policies

### Availability Management
- SLA tracking
- Multi-AZ and multi-region design
- Redundancy at every layer
- Failover and DR testing

### Maintenance Management
- Scheduled maintenance windows
- Communication to stakeholders
- Rollback plans
- Post-maintenance verification

## Operational Standards and Frameworks

### ITIL 4
- Service value chain
- Practices: incident management, change enablement, problem management, service desk, etc.
- Cloud operations align well with ITIL

### ISO/IEC 20000
- Service management standard
- Aligned with ITIL

### ISO/IEC 27035
- Information security incident management

### NIST SP 800-61
- Computer Security Incident Handling Guide
- IR lifecycle: Preparation, Detection and Analysis, Containment Eradication and Recovery, Post-Incident Activity

### NIST SP 800-86
- Integration of Forensic Techniques into Incident Response

## Logging and Monitoring

### Cloud-Native Logging
- AWS: CloudTrail (API), CloudWatch Logs, S3 Access Logs, VPC Flow Logs, ELB Access Logs
- Azure: Activity Log, Diagnostic Logs, NSG Flow Logs, Storage logs
- GCP: Cloud Audit Logs (Admin Activity, Data Access, System Event, Policy Denied), VPC Flow Logs

### Centralized Log Management / SIEM
- Aggregate from all sources
- Examples: Splunk, Microsoft Sentinel, Elastic Security, Sumo Logic, Chronicle, Exabeam
- Correlation, alerting, retention

### Log Best Practices
- Centralize across regions and accounts
- Immutable storage (Object Lock / WORM)
- Cross-account log delivery for separation
- Time synchronization (NTP)
- Restricted access (separation of duties)
- Retention per compliance and operational need
- Avoid logging sensitive data (PII, secrets, full PANs)

### What to Log
- API control plane (CloudTrail, Activity Log)
- Identity events (sign-ins, role changes, secret access)
- Network flow (VPC Flow Logs)
- Application logs
- Database audit
- File access (data plane)
- Storage access (S3 Access, Blob diagnostic)
- Container/Kubernetes audit
- Serverless function logs
- Security service findings (GuardDuty, Defender, Security Command Center)

## Security Operations Center (SOC) in Cloud

### Functions
- Continuous monitoring
- Incident detection and triage
- Investigation
- Response coordination
- Threat hunting
- Threat intelligence integration
- Reporting

### Tooling Stack
- SIEM
- SOAR (Security Orchestration, Automation, Response): playbook automation
- EDR/XDR for endpoints
- CSPM/CWPP for cloud
- TI platforms (MISP, Recorded Future, Mandiant)
- Communication and case management (PagerDuty, ServiceNow)

### SOC Models
- Internal SOC
- Outsourced SOC (MSSP, MDR)
- Hybrid (internal + augmentation)
- Follow-the-sun for 24/7

## Incident Response in Cloud

### Cloud-Specific IR Considerations
- Rapid elasticity affects scope (auto-scaled instances may have varied state)
- Ephemeral instances may terminate before evidence collected
- API-driven actions (rapid containment via API automation)
- Provider coordination required for hypervisor or platform-level evidence
- Multi-tenancy impacts evidence handling
- Documentation of cloud control plane actions
- Cross-region or cross-cloud incidents

### IR Lifecycle Adaptation for Cloud (NIST SP 800-61 + cloud)
1. **Preparation**:
   - Cloud-aware playbooks
   - Pre-approved containment automation
   - Provider contact information and escalation paths
   - Forensic tools cloud-ready
   - Identity for IR responders (break-glass with monitoring)
2. **Detection and Analysis**:
   - Cloud SIEM correlation
   - CNAPP alerts
   - Provider-side detections (GuardDuty, Defender, Security Command Center)
3. **Containment**:
   - Network isolation via security group/NSG/firewall changes
   - IAM revocation via API
   - Snapshot before terminate (preserve evidence)
   - Quarantine resources via tags + restrictive policies
4. **Eradication**:
   - Replace compromised resources from clean baseline (immutable infrastructure)
   - Rotate credentials, keys, tokens
   - Apply patches
5. **Recovery**:
   - Restore from clean backups (immutable, separate account)
   - Validate cleanliness via re-scan
   - Phased traffic restoration
6. **Post-Incident**:
   - Lessons learned
   - Update playbooks and detections
   - Share with stakeholders and authorities as required

## Digital Forensics in Cloud

### Cloud Forensics Adaptations
- Evidence acquisition typically via API (snapshots, log exports)
- Volatility: capture memory before instance termination if possible
- Chain of custody documented across cloud APIs (who took action, when, what)
- Provider must cooperate for some evidence (hypervisor, infrastructure, multi-tenant correlation)
- Legal process (subpoena, warrant) for provider-held evidence
- Multi-jurisdictional considerations

### Forensic Process (NIST SP 800-86)
1. **Collection** - Snapshot volumes, capture memory, export logs
2. **Examination** - Mount snapshots in read-only forensic environment
3. **Analysis** - Identify TTPs, scope, attribution
4. **Reporting** - Document findings for IR, legal, audit, leadership

### Evidence Preservation
- Hash computed at collection (SHA-256)
- Hash re-verified at each handling step
- Original preserved; analysis on copies
- Immutable storage for evidence (S3 Object Lock)

### Cloud Service Provider Cooperation
- Many providers publish IR contact info
- Some have customer-facing IR support (paid)
- Subpoenas/warrants for cross-tenant or hypervisor evidence
- Customers should pre-establish IR communication channels with providers

## Communication with Stakeholders

### Internal Communication
- IR command structure (incident commander, scribe, technical lead, comms lead)
- Status updates at defined intervals
- Executive briefing
- Affected business unit liaison
- Privacy/legal notifications

### External Communication
- Customers (per contractual SLA)
- Regulators (per regulation; GDPR 72-hour, HIPAA 60-day, etc.)
- Law enforcement (when warranted)
- Industry ISACs for intel sharing
- Insurance carrier
- Vendors and partners
- Public/media (typically through PR with legal review)

### Crisis Communication Best Practices
- Prepared templates
- Single source of truth (status page, customer notification)
- Honest, factual; avoid speculation
- Regular cadence even when no new info
- Coordinate with legal, PR, executive

## Change and Configuration Management in Cloud

### Change Management
- RFCs for non-trivial changes
- CAB for risk review
- Standard / Normal / Emergency change types
- Documentation and audit trail
- Automated where safe (low-risk, well-tested)

### Configuration Management
- Infrastructure as Code as source of truth
- Drift detection and reconciliation
- Compliance scanning (Config, Policy, Forseti, OPA)
- Change auditing via cloud audit logs

### Cloud-Native Tools
- AWS Config, Azure Policy, GCP Organization Policy
- AWS Systems Manager, Azure Automation, GCP Cloud Build
- Open-source: Terraform, Ansible, Puppet

## Vulnerability Management in Cloud

### Continuous Scanning
- CSPM for misconfigurations
- Vuln management for OS/app CVEs
- Container image scanning
- Serverless dependency scanning (SCA)
- IaC scanning

### Cloud-Specific Vulnerabilities
- Misconfigured public access (S3 buckets, security groups, databases)
- Over-permissive IAM (CIEM helps)
- Stale identities and unused permissions
- Exposed secrets in public repos
- Unpatched managed services (where customer responsibility)
- Vulnerable container images
- Vulnerable serverless dependencies

### Risk Prioritization
- CVSS score
- EPSS (Exploit Prediction Scoring System)
- KEV (CISA Known Exploited Vulnerabilities) catalog
- Asset criticality
- Exploit availability
- Exposure (public-facing vs internal)
- Compensating controls

## Operational Controls and Standards

### Resource Protection
- Encryption at rest and in transit
- Access controls (IAM, network)
- Backup and recovery
- Anti-malware (where applicable)

### Personnel Controls
- Background checks
- Training and awareness
- Acceptable use policies
- Need-to-know and least privilege
- Separation of duties
- Job rotation, mandatory vacation for high-trust roles

### Technical Controls
- Identity-aware access (zero trust)
- MFA for all privileged actions
- Just-in-time elevation (PAM)
- Session recording for sensitive operations
- Logging and monitoring

### Process Controls
- Incident response procedures
- Change management
- Vulnerability management
- Access certification (UARs)
- Vendor management

## Common Exam Pitfalls

- Treating cloud forensics like on-prem (ignoring volatility, ephemeral resources)
- Forgetting to snapshot before terminating compromised instance
- Not centralizing logs across accounts/regions
- Choosing wrong logging destination (logs in same account as production, deletable by attacker)
- Skipping immutable backup tier
- Forgetting provider coordination for hypervisor/infrastructure evidence
- Confusing CSPM (config) with CWPP (runtime)
- Missing the role of CIEM for identity risk

## Quick Reference: Cloud SecOps Tool Categories

| Need | Tool Category |
|------|---------------|
| Cloud configuration risk | CSPM |
| VM/container/serverless runtime | CWPP |
| Cloud identity/permissions risk | CIEM |
| All of above unified | CNAPP |
| SaaS app configuration | SSPM |
| Data discovery and access | DSPM |
| Log aggregation and detection | SIEM |
| Automated response | SOAR |
| Endpoint detection | EDR / XDR |
| Container/K8s runtime | Container security platform (Defender, Wiz, Sysdig, Aqua, Prisma Compute) |
