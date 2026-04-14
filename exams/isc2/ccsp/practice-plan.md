# CCSP Practice Plan - 10 Week Schedule

CCSP covers 6 domains across cloud security architecture, data, infrastructure, applications, operations, and legal/compliance. Most successful candidates spend 8 to 12 weeks of focused preparation. This plan assumes 10 to 12 hours per week and is suitable for someone with prior cloud and security experience.

If you hold CISSP and have hands-on cloud security experience, 6 to 8 weeks may be sufficient. If you are new to cloud, expand to 14 to 16 weeks and add hands-on labs in at least one major cloud (AWS, Azure, or GCP).

## Materials Required

### Required
- **Official ISC2 CCSP CBK Reference, 4th Edition** OR **Official ISC2 CCSP Study Guide, 4th Edition** (Sybex) - primary text
- **Official ISC2 CCSP Practice Tests, 3rd Edition** (Sybex)
- **CSA Security Guidance v5** - free PDF from cloudsecurityalliance.org
- **Cloud Controls Matrix v4** - free spreadsheet from CSA

### Recommended additions
- **Pete Zerger CCSP Exam Cram** (free on YouTube) for final review
- **Boson ExSim CCSP** for difficulty calibration
- **Destination Certification CCSP MasterClass** (paid) for video coverage
- **CCSP All-in-One Exam Guide** (McGraw Hill) for alternative perspective

## Lab Environment (Recommended)

While CCSP is vendor-neutral, hands-on cloud experience strengthens understanding:
- AWS Free Tier or $100 Azure trial
- Build a VPC/VNet, deploy a VM, configure storage encryption, KMS keys, IAM roles
- Enable native security services (GuardDuty, Defender for Cloud, Security Command Center)
- Use Terraform or CloudFormation to practice IaC

## Week-by-Week Plan

### Week 1: Domain 1 (Cloud Concepts, Architecture, and Design) - 17%

**Goals:** Master the cloud vocabulary and reference architectures.

**Topics:**
- NIST SP 800-145 definition (5 essential characteristics, 3 service models, 4 deployment models)
- Cloud reference architecture (ISO/IEC 17789)
- Roles: CSC, CSP, CSN, CSB, Cloud Auditor
- Shared responsibility model variations across IaaS/PaaS/SaaS
- Security concepts: defense in depth, least privilege, zero trust in cloud
- Cloud-specific risks: multi-tenancy, vendor lock-in, data residency, jurisdiction
- Cryptographic concepts in cloud (BYOK, HYOK, KMS, HSM)
- Trusted Computing concepts (TPM, secure enclaves, confidential computing)
- Cloud architecture patterns

**Activities:**
- Read Domain 1 study guide chapters
- Read CSA Guidance v5 Domains 1, 2, 3
- Memorize NIST SP 800-145 cold
- 60 practice questions
- Build a one-page summary of shared responsibility per service model

### Week 2: Domain 2 Part 1 (Cloud Data Security) - 20% - Largest Domain

**Topics:**
- Cloud data lifecycle (Create, Store, Use, Share, Archive, Destroy)
- Cloud data storage types per service model
- Data security technologies: encryption, tokenization, masking, anonymization, pseudonymization
- Encryption key management approaches: provider-managed, BYOK, HYOK, customer-supplied
- KMS, CloudHSM, Azure Key Vault, GCP Cloud KMS / Cloud HSM concepts
- Data classification and discovery in cloud (Macie, Purview, Cloud DLP)

**Activities:**
- Read Domain 2 first half
- Build a chart of encryption approaches and trade-offs
- Lab: enable encryption with customer-managed keys on a cloud storage service
- 60 practice questions

### Week 3: Domain 2 Part 2 - Data Protection, Retention, and Governance

**Topics:**
- Information Rights Management (IRM/DRM)
- Data retention, archiving, and deletion in cloud
- Data sovereignty and residency
- Data Loss Prevention in cloud (Cloud DLP, Purview, Macie)
- Data subject rights handling in cloud (GDPR DSAR processes)
- Data security in different storage types (object, block, file, database, archive)
- Backup and recovery considerations
- Auditability and traceability of data events

**Activities:**
- Practice mapping data lifecycle phase to controls and threats
- 60 practice questions
- Take a 50-question Domain 2 mini-exam

### Week 4: Domain 3 (Cloud Platform and Infrastructure Security) - 17%

**Topics:**
- Cloud infrastructure components: physical (data center) through virtual (compute, storage, network)
- Hypervisor types and security (Type 1 bare-metal, Type 2 hosted)
- Virtualization risks: VM escape, side-channel, snapshot exposure
- Container security: image, registry, runtime, orchestration (Kubernetes)
- Serverless / FaaS security
- Cloud network security: SDN, microsegmentation, security groups, NACLs
- Cloud-native firewalling, WAF, DDoS protection
- Identity-aware proxies and zero trust network access (ZTNA)
- Privileged access in cloud
- Disaster recovery in cloud (backup-only, pilot light, warm standby, multi-region active-active)

**Activities:**
- Lab: Configure security groups, network policies, and a WAF
- Build a comparison: hypervisor security vs container security vs serverless security
- 75 practice questions

### Week 5: Domain 4 (Cloud Application Security) - 17%

**Topics:**
- Cloud SDLC and DevSecOps
- Common cloud application vulnerabilities (OWASP Top 10, OWASP API Top 10)
- Application security testing in cloud (SAST, DAST, IAST, SCA, RASP)
- Cloud application architectures (microservices, serverless, event-driven)
- Sandboxing and application virtualization
- Cryptography in applications (TLS, mTLS, JWT, signing)
- IAM for cloud applications: federated identity (SAML, OAuth, OIDC), MFA, conditional access
- API security (gateways, rate limiting, AuthN/AuthZ, schema validation)
- Secrets management (vaults, secret rotation, never in code)
- IaC security (policy as code, scanning)
- Supply chain security (SBOM, signed artifacts, SLSA)

**Activities:**
- Lab: Build a small cloud app with TLS, OIDC auth, secrets in a vault, API gateway
- 75 practice questions

### Week 6: Domain 5 (Cloud Security Operations) - 16%

**Topics:**
- Implement and manage physical infrastructure (provider responsibility, customer awareness)
- Logical infrastructure operations: image management, patching, configuration management
- Logging and monitoring in cloud (CloudTrail, Activity Log, audit logs, native SIEM/CSPM)
- Incident response in cloud: differences from on-prem (provider coordination, ephemeral evidence)
- Digital forensics in cloud: snapshot acquisition, log preservation, chain of custody
- Vulnerability management in cloud (CSPM, CWPP, posture vs runtime)
- Change and configuration management (drift detection, IaC reconciliation)
- ITIL alignment for cloud operations
- Service Operations: ITSM integration, communication with stakeholders
- Operations security: separation of duties for cloud admin, JIT/PAM in cloud

**Activities:**
- Lab: enable CloudTrail / Activity Log; create an alert; review a snapshot for forensics
- 75 practice questions

### Week 7: Domain 6 (Legal, Risk, and Compliance) - 13%

**Topics:**
- Legal frameworks affecting cloud: GDPR, CCPA/CPRA, HIPAA, GLBA, SOX, PCI DSS
- Cross-border data transfer (Schrems II, SCCs, BCRs, EU-US Data Privacy Framework)
- Cloud contract design: SLA, MSA, DPA, BAA, exit clauses, data return/destruction
- Vendor risk management for cloud
- Cloud audit considerations and adaptations
- Audit reports and attestations: SOC 1/2/3, ISO 27001/27017/27018, CSA STAR, FedRAMP, BSI C5
- Cloud risk management: ENISA Cloud Computing Risk Assessment, NIST SP 800-37, ISO 31000
- E-discovery in cloud
- Forensic data collection legal considerations
- Privacy impact assessments / DPIAs in cloud context

**Activities:**
- Memorize SOC report types and uses
- Memorize CSA STAR levels
- Build a contract checklist for cloud vendors
- 75 practice questions

### Week 8: First Full-Length Practice Exam + Weak Domain Focus

**Activities:**
- Take Boson ExSim CCSP full 150-question exam under 3-hour conditions
- Review every wrong answer
- Identify weakest 1-2 domains
- Targeted re-read of weak chapters
- Re-read CSA Guidance chapters tied to weak domains
- Update flashcards based on missed concepts

### Week 9: Second Full-Length + Cross-Domain Integration

**Activities:**
- Take Sybex Official Practice Test full-length under exam conditions
- Target 75%+ on each
- Watch Pete Zerger CCSP Exam Cram or equivalent in single sitting
- Review CSA Guidance v5 quick-read of all 14 domains
- 50 practice questions per day on weak areas

### Week 10: Final Review and Exam

**Days 1-3:**
- Re-read Domain 6 (legal/compliance) - frequently underestimated
- Practice questions in batches of 50, focused on weak domains
- Mind map review
- Walk through key cloud reference architectures verbally

**Days 4-5:**
- Light review only
- Memorize:
  - NIST SP 800-145 cold
  - SOC report types
  - Encryption approaches (BYOK, HYOK, etc.)
  - CSA STAR levels
  - Cross-border transfer mechanisms
  - Backup/DR pattern naming

**Day 6:**
- Rest. No new material after lunch.
- Confirm exam logistics, ID, route, time

**Exam Day:**
- Protein breakfast
- Arrive 30 min early at Pearson VUE
- 3 hours, 150 questions = 1 minute 12 seconds per question
- Mark and return liberally for unsure items
- Trust your preparation

## Daily Habits

- **30 to 45 minutes practice questions** every study day
- **15 minutes flashcard review** (Anki suggested)
- **Concept journal entry** on the day's hardest concept (in your own words)
- **Weekly study group call** if possible

## Practice Exam Score Targets

- Week 4: 50%+ on completed domains
- Week 7: 65% across all domains
- Week 8: 75% on first full-length
- Week 9: 80%+ on second full-length
- Exam day: ready when consistently 80%+ on Boson, 85%+ on Sybex

## Mindset Reminders

1. CCSP rewards architect-level thinking, not single-vendor expertise
2. Best answer: cloud-aware, neutral, vendor-agnostic
3. Read shared responsibility into every scenario (who is responsible here?)
4. Legal/compliance answers prioritize jurisdiction and contract over technology
5. Cloud forensics differs from on-prem (volatility, provider coordination)

## After You Pass

- Endorsement application within 9 months
- Pay first AMF after endorsement approval
- Plan 30+ CPEs in year 1 (CSA webinars, ISC2 webinars, podcasts, books, conferences)
- Update LinkedIn and resume
- Consider follow-on: AWS Security Specialty, Azure SC-100, GCP Cloud Security Engineer for vendor depth; CCAK for cloud audit specialization
