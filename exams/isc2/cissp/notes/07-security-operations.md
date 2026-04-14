# 07 - Security Operations (Domain 7, 13%)

## Domain Overview

Domain 7 covers the day-to-day execution of security: monitoring, incident handling, logging, configuration management, change management, vulnerability and patch management, disaster recovery, and physical security operations. It is one of the largest domains by content volume and frequently overlaps with Domain 1 governance.

## Foundational Operations Concepts

### Need to Know
Access only to information necessary to perform job. Combined with Least Privilege (minimum permissions), these prevent over-exposure.

### Least Privilege
Grant minimum permissions required, no more. Applies to users, processes, and services.

### Separation of Duties (SoD)
No single person can complete a sensitive transaction unilaterally. Examples:
- Developer cannot deploy to production
- Approver cannot also be requestor
- Database admin cannot also be application admin

### Two-Person Integrity (Two-Person Control)
Two people physically required for an action. Used for:
- Cryptographic key ceremonies
- Nuclear launch
- High-value financial transfers

### Job Rotation
Periodically move people through different roles. Benefits:
- Prevents long-term unchecked control
- Detects ongoing fraud (successor sees abnormalities)
- Reduces single points of knowledge

### Mandatory Vacation
Required time away from job, typically 1-2 weeks. Detects fraud requiring continuous concealment.

### Privileged Account Management
Covered in Domain 5 in depth. Operations responsibility:
- Vaulted credentials (PAM)
- JIT elevation
- Session recording
- Periodic review

### Monitoring of Privileged Activity
Privileged actions logged, alerted, and reviewed. Essential for both detection and audit.

## Configuration Management (CM)

The process of maintaining systems in a desired secure state.

### Components
- **Configuration Items (CI)** - tracked elements (servers, network devices, applications)
- **Configuration Management Database (CMDB)** - inventory and relationship store
- **Baseline** - approved configuration state
- **Configuration item identification** - unique naming
- **Configuration audit** - verify actual matches baseline
- **Configuration control** - change approval workflow

### Tools
- Ansible, Puppet, Chef, SaltStack
- Cloud: Terraform, AWS Config, Azure Policy, GCP Config Validator
- Endpoint: SCCM, Intune, Jamf

### Drift Detection
Continuous comparison of running config to baseline. Drift indicates either unauthorized change or pending update.

## Change Management

Distinct from Configuration Management. CM is about state; Change Management is about process for modifying state.

### Process
1. **Request for Change (RFC)** - initiate
2. **Impact assessment** - technical, security, business risk
3. **Approval** - CAB (Change Advisory Board) or delegated approver
4. **Implementation planning** - schedule, rollback, communication
5. **Execution** - apply change
6. **Verification** - test, validate
7. **Documentation** - record in change log

### Change Types
- **Standard** - pre-approved, low-risk, repeatable
- **Normal** - requires CAB approval
- **Emergency** - expedited, post-approval review
- **Major** - significant scope, additional scrutiny

### Emergency Change
- Used for critical security patches, outage response
- Pre-approval may be deferred but documented promptly
- Post-implementation review required

## Patch Management

### Lifecycle
1. Inventory
2. Vulnerability awareness (CVE, vendor advisories, KEV catalog)
3. Risk-based prioritization
4. Test in non-production
5. Phased rollout (rings)
6. Verification of installation
7. Exception tracking (with compensating controls)

### SLA examples
- Critical: 7-14 days
- High: 30 days
- Medium: 60-90 days
- Low: best effort or next maintenance window

### Out-of-band patches
- Vendor releases outside normal cadence (Microsoft "Patch Tuesday" exceptions, Apache emergency)
- Emergency change process

## Vulnerability Management

Not the same as patch management; broader scope.

- Discovery (scanning, manual review, threat intel)
- Assessment (CVSS, EPSS, business context)
- Prioritization (risk-based)
- Remediation (patch, mitigate, accept)
- Verification (rescan)
- Reporting (metrics, trends)

### Mitigation when patching not possible
- Network segmentation to limit blast radius
- WAF rules for app vulns
- Endpoint detection signatures
- Disabling vulnerable feature
- Compensating controls documented

## Incident Response

### NIST SP 800-61 Lifecycle
1. **Preparation** - policy, IR team, tools, training, runbooks
2. **Detection and Analysis** - identify, scope, classify, prioritize
3. **Containment, Eradication, Recovery** - stop the bleeding, remove cause, restore
4. **Post-Incident Activity** - lessons learned, metrics, improvements

### IR Team Composition
- IR manager
- Technical responders (forensics, malware, network)
- Communications/PR
- Legal counsel
- HR
- Senior management liaison
- External (CIRT retainer, law enforcement contacts)

### Containment Strategies
- Short-term: isolate affected systems immediately
- Long-term: rebuild infrastructure with hardened baselines
- Decision factors: business impact, evidence preservation, attacker awareness

### Eradication
- Remove malware, attacker tools
- Reset credentials
- Apply patches and configuration fixes
- Validate cleanliness

### Recovery
- Restore from clean backups
- Rebuild systems
- Re-onboard
- Enhanced monitoring during stabilization

### Post-Incident
- Lessons learned meeting (within 2 weeks)
- Document findings, decisions, gaps
- Update playbooks
- Update detections
- Share intel (industry ISACs, internal awareness)

## Investigations and Forensics

### Investigation Types (covered Domain 1)
- Criminal, Civil, Regulatory, Administrative

### Digital Forensics Process (NIST SP 800-86)
1. **Collection** - acquire data from sources
2. **Examination** - extract relevant data
3. **Analysis** - interpret findings
4. **Reporting** - document with context for audience

### Evidence Handling
- **Chain of custody** - documented control of evidence from collection to presentation
- **Proper acquisition** - bit-by-bit imaging (FTK, EnCase, dd) with hash verification
- **Volatility order** (RFC 3227): registers/cache > RAM > network state > running processes > disk > removable media > remote logs > backups
- **Original preservation** - work on copies; original sealed
- **Hash verification** - SHA-256 of image, recorded, re-verified at each handling

### Evidence Types (also in Domain 1)
- Real (physical objects)
- Documentary
- Testimonial
- Demonstrative

### Evidence Properties
- Sufficient
- Reliable
- Relevant
- Authentic
- Permissible (legally obtained, chain of custody)

### Search and Seizure
- US 4th Amendment requires warrant for government seizure (with exceptions)
- Private organizations may search per acceptable use policy
- Different jurisdictions vary

### eDiscovery
- Identification, preservation, collection, processing, review, analysis, production, presentation of electronically stored information (ESI)
- Legal hold notice suspends deletion

## Logging and Monitoring

### Log Sources
- OS (Windows Event Log, syslog)
- Application logs
- Security devices (firewall, IDS/IPS, WAF, EDR)
- Network (NetFlow, sFlow, packet capture)
- Identity (AD, IdP, PAM)
- Cloud (CloudTrail, Activity Log, audit logs)
- Database audit
- File access audit

### Log Centralization
- SIEM (Splunk, Microsoft Sentinel, Elastic, Chronicle, Sumo Logic)
- Ingestion, normalization, correlation, alerting, retention

### Log Retention
- Driven by regulations (HIPAA 6 yrs, PCI 1 yr online + 1 yr archive, SOX 7 yrs)
- Operational need (forensics window)
- Cost vs value

### Log Integrity
- Append-only / write-once storage
- Centralized collection (logs stored elsewhere from source)
- Hashing or chaining
- Time sync (NTP) for cross-source correlation
- Monitoring for log tampering or gaps

### SIEM Use Cases
- Brute force detection
- Insider threat indicators
- Privilege abuse
- Data exfiltration
- Malware behavior
- Compliance reporting

### UEBA
- Baseline normal behavior per user/entity
- Detect deviations
- Reduce alert volume by adding behavioral context

### SOAR
- Security Orchestration, Automation, and Response
- Playbooks automate routine response
- Integrates SIEM with ticketing, IT systems, security tools

## Detective Controls

- IDS/IPS
- SIEM alerts
- DLP detection
- Audit logs review
- Honeypots and honeytokens
- File Integrity Monitoring (FIM)
- Network traffic analysis (NTA)

## Preventive Controls

- Firewalls
- Allowlisting (application control)
- Endpoint protection (NGAV, EPP)
- Patch management
- Hardening baselines
- Encryption
- Access controls
- MFA
- Network segmentation

## Sandboxing and Detonation

- Isolated execution environment
- Files detonated to observe behavior (Cuckoo, joe sandbox, Windows Defender ATP cloud)
- Network sandboxes (FireEye NX, Palo Alto WildFire)
- Browser sandboxes (Chromium, Edge isolation)

## Resource Protection

- Hardware protection: secure storage, environmental controls
- Software protection: integrity validation, signed binaries, secure boot
- Data protection: encryption, access controls, backups

## Disaster Recovery (DR)

DR is the technical subset of BCP focused on restoring IT services after a disruption.

### DR Strategies
- **Backups**:
  - Full
  - Incremental (since last backup of any type)
  - Differential (since last full)
  - Synthetic full (created from incrementals)
  - GFS rotation (Grandfather-Father-Son)
- **Replication**:
  - Synchronous (zero RPO, geo-limited by latency)
  - Asynchronous (some lag, broader geo)
- **Snapshots**:
  - Point-in-time, fast restore
  - Not a replacement for backups (often co-located)
- **Mirrored data**:
  - Real-time, often within active-active DR

### Backup Considerations
- Off-site storage (3-2-1 rule: 3 copies, 2 media, 1 off-site)
- Immutable backups (ransomware resilience)
- Encryption of backup media
- Periodic restore testing (untested backup ≠ backup)

### Recovery Sites
| Site | Cost | Setup | Notes |
|------|------|-------|-------|
| Cold | Lowest | Weeks | Empty space, utilities |
| Warm | Medium | Days | Hardware ready, no data |
| Hot | High | Hours | Fully ready, current data |
| Mirrored | Highest | Real-time | Active-active |
| Reciprocal | Lowest | Days | Mutual aid agreement |
| Cloud DR (DRaaS) | Variable | Hours | Cloud-hosted recovery |

### DR Test Types (least to most disruptive)
1. **Read-through (checklist)** - paper review
2. **Walk-through** - team discussion of plan
3. **Tabletop** - role-play scenario without systems
4. **Simulation** - simulate disaster, exercise systems without affecting production
5. **Parallel** - bring DR online while production stays up
6. **Full interruption** - failover; production stops

### After Each Test
- Identify gaps
- Update plan
- Track remediation
- Communicate to leadership

## Personnel Safety in Operations

Always priority. Examples:
- Evacuation drills
- Safety training
- Travel security
- Workplace violence prevention
- Active shooter procedures
- Telework safety
- Substance abuse programs

## Physical Security Operations

- Visitor management (escorted, time-limited badges)
- Mail handling (suspicious package procedures)
- Datacenter procedures (badge in/out, dual-control on access to cages)
- CCTV monitoring
- Perimeter patrols
- Access log review

## Common Exam Pitfalls

- Confusing CM (state) with change management (process)
- Skipping containment in IR (going straight to eradication)
- Forgetting personnel safety as priority
- Treating snapshots as backups
- Choosing wrong DR site (warm when hot is required for RTO)
- Missing evidence preservation steps
- Picking the most disruptive DR test when a less disruptive one suffices
- Overlooking off-site backup requirement

## Quick Reference: IR Decision Tree

1. Is human safety at risk? -> Address first
2. Is the attack ongoing? -> Containment priority
3. Is evidence at risk? -> Preserve before changing state
4. Is regulatory notification triggered? -> Engage legal/compliance
5. What is the business impact tier? -> Prioritize accordingly
6. Are external resources needed? -> Engage CIRT/IR retainer
