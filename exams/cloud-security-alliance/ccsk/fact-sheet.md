# CCSK v5 Fact Sheet

## Exam Logistics

| Item | Detail |
|------|--------|
| Exam Name | Certificate of Cloud Security Knowledge v5 |
| Issuer | Cloud Security Alliance (CSA) |
| Format | Online, open-book, multiple choice |
| Duration | 120 minutes |
| Question Count | 60 |
| Passing Score | 80% (48/60) |
| Cost (USD) | $395 (includes 2 attempts) |
| Languages | English |
| Delivery | Online via ccsk.cloudsecurityalliance.org portal |
| Proctoring | None (trust-based, open book) |
| Retakes | 2nd attempt included; additional attempts $395 each |
| Validity | Does not expire |
| Prerequisites | None |
| Experience Required | None |

## Source Materials

Exam questions are drawn from:

1. **CSA Security Guidance for Critical Areas of Focus in Cloud Computing v5** (primary)
2. **Cloud Controls Matrix v4**
3. **ENISA Cloud Computing Risk Assessment** (historical, still referenced)

All are free PDF downloads from cloudsecurityalliance.org.

## Guidance v5 - 12 Domains

1. Cloud Computing Concepts and Architectures
2. Cloud Governance
3. Risk, Audit, and Compliance
4. Organization Management
5. Identity and Access Management
6. Security Monitoring
7. Infrastructure and Networking
8. Cloud Workload Security
9. Data Security
10. Application Security
11. Incident Response and Resilience
12. Related Technologies and Strategies

## Cloud Controls Matrix (CCM) v4 - 17 Domains

1. Audit and Assurance (A&A)
2. Application and Interface Security (AIS)
3. Business Continuity Management and Operational Resilience (BCR)
4. Change Control and Configuration Management (CCC)
5. Cryptography, Encryption, and Key Management (CEK)
6. Datacenter Security (DCS)
7. Data Security and Privacy Lifecycle Management (DSP)
8. Governance, Risk Management, and Compliance (GRC)
9. Human Resources (HRS)
10. Identity and Access Management (IAM)
11. Interoperability and Portability (IPY)
12. Infrastructure and Virtualization Security (IVS)
13. Logging and Monitoring (LOG)
14. Security Incident Management, E-Discovery, and Cloud Forensics (SEF)
15. Supply Chain Management, Transparency, and Accountability (STA)
16. Threat and Vulnerability Management (TVM)
17. Universal Endpoint Management (UEM)

Total: **197 control objectives** (varies slightly by CCM version).

Each control has:
- Control ID (e.g., IAM-01, CEK-03)
- Control title
- Control specification (description)
- CAIQ mapping
- Mappings to other frameworks (ISO 27001, NIST SP 800-53, PCI DSS, HIPAA, etc.)

## CSA STAR Levels

| Level | Type | Cost |
|-------|------|------|
| Level 1 | Self-assessment (CAIQ submission) | Free |
| Level 2 | Third-party audit | Varies |
| Level 2 - STAR Attestation | SOC 2 Type 2 + CCM | Audit cost |
| Level 2 - STAR Certification | ISO 27001 + CCM | Audit cost |
| Level 2 - C-STAR | China-specific | Varies |
| Level 3 | Continuous auditing | In development |

## NIST Cloud Definition (SP 800-145) - Memorize

### 5 Essential Characteristics
1. On-demand self-service
2. Broad network access
3. Resource pooling
4. Rapid elasticity
5. Measured service

### 3 Service Models
- IaaS
- PaaS
- SaaS

### 4 Deployment Models
- Public
- Private
- Community
- Hybrid

## Shared Responsibility Model

| Responsibility | IaaS | PaaS | SaaS |
|---------------|------|------|------|
| Data classification | Customer | Customer | Customer |
| Identity and access | Customer | Customer | Customer |
| Application | Customer | Customer | Provider |
| Runtime, middleware | Customer | Provider | Provider |
| Operating system | Customer | Provider | Provider |
| Virtualization | Provider | Provider | Provider |
| Network | Shared | Provider | Provider |
| Physical | Provider | Provider | Provider |

Customer always responsible for:
- Data (classification, content, quality)
- Identity (who has access)
- Configuration of provided services

## Key Cloud Concepts

### Metastructure
The connection between provider and customer, primarily the management plane and APIs. CSA concept.

### Applistructure
Applications running in the cloud and services used to build them.

### Infrastructure Layer
Foundational cloud resources: compute, storage, network.

### Management Plane vs Data Plane
- **Management plane** - Control APIs for configuring cloud (high-value target)
- **Data plane** - Actual data/workload interactions

Management plane attacks are particularly damaging (e.g., creating new accounts, exfiltrating keys).

## Cloud-Specific Security Principles

- Shared responsibility
- Identity is the primary perimeter
- Assume compromise
- Automate security (IaC, policy as code)
- Data-centric protection
- Immutable infrastructure
- Zero trust networking
- Continuous monitoring and compliance
- Least privilege and just-in-time access

## Cloud Risk Categories (ENISA taxonomy still useful)

- **Policy and organizational** - Lock-in, loss of governance, compliance challenges
- **Technical** - Resource exhaustion, isolation failure, malicious insider, intercepts, data leakage, insecure/ineffective deletion
- **Legal** - Subpoena, data protection risks, licensing, jurisdictional issues
- **Non-cloud-specific but amplified** - Network attacks, escalation of privilege, social engineering, natural disasters

## Cloud Computing Threats (CSA Top Threats v4 / "Pandemic 11")

1. Insufficient identity, credential, access, and key management
2. Insecure interfaces and APIs
3. Misconfiguration and inadequate change control
4. Lack of cloud security architecture and strategy
5. Insecure software development
6. Unsecured third-party resources
7. System vulnerabilities
8. Accidental cloud data disclosure
9. Misconfiguration of serverless / container workloads
10. Organized crime / hackers / APT
11. Cloud storage data exfiltration

## Key Frameworks Referenced

- NIST SP 800-145 (Cloud definition)
- NIST SP 800-53 (Controls)
- NIST SP 800-37 (RMF)
- NIST SP 800-61 (IR)
- ISO 27001, 27002, 27017, 27018, 27701
- ISO 31000 (Risk management)
- PCI DSS
- HIPAA
- GDPR
- COBIT
- ITIL
- COSO ERM

## Privacy Regulation Quick Reference

- **GDPR** (EU) - 72-hour breach notification
- **CCPA/CPRA** (California) - Consumer rights
- **HIPAA** (US healthcare) - PHI, BAA
- **GLBA** (US financial) - Safeguards Rule
- **SOX** (US public) - Financial controls
- **PCI DSS** - Payment cards (contractual)
- **LGPD** (Brazil), **PIPEDA** (Canada), **APPI** (Japan), **PIPL** (China), **POPIA** (South Africa)

## Audit Report Types

- **SOC 1 Type 2** - Financial reporting controls, period
- **SOC 2 Type 2** - Trust Services Criteria (Security mandatory; Availability, Processing Integrity, Confidentiality, Privacy optional), period. Gold standard for SaaS.
- **SOC 3** - Public summary of SOC 2
- **ISO 27001** - ISMS certification
- **ISO 27017** - Cloud-specific controls
- **ISO 27018** - PII in public cloud
- **FedRAMP** - US federal (Low, Moderate, High)
- **CSA STAR** - Cloud-specific, multi-level

## Encryption Approaches

| Approach | Customer Control |
|----------|------------------|
| Provider-managed | Low |
| BYOK (customer-managed in provider KMS) | Medium |
| Customer-supplied (per request) | High |
| HYOK (external KMS) | Highest |
| Client-side encryption | Highest |
| Confidential computing (in-use) | Highest |

## Documentation Links

- **Guidance v5:** https://cloudsecurityalliance.org/research/guidance
- **CCM v4:** https://cloudsecurityalliance.org/research/cloud-controls-matrix
- **CAIQ:** https://cloudsecurityalliance.org/research/cai/
- **STAR Registry:** https://cloudsecurityalliance.org/star/registry
- **Top Threats:** https://cloudsecurityalliance.org/research/topics/top-threats
- **CCSK Exam Portal:** https://ccsk.cloudsecurityalliance.org

## Exam Strategy (Key Points)

- Open book: have Guidance v5 PDF with bookmarks, CCM spreadsheet with filters
- 120 min / 60 questions = 2 min per question average
- Plan ~90 min for direct answers, ~30 min for references on marked questions
- Question style often uses exact phrases from Guidance (CTRL+F is your friend)
- CCM questions may ask about specific control domains (memorize the 17)
- Many questions test understanding of shared responsibility boundaries
