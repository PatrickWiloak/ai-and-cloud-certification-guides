# 02 - Governance, Risk, and Compliance (Guidance Domains 2 and 3)

## Domain Overview

This combined topic covers two Guidance domains: Cloud Governance (Domain 2) and Risk, Audit, and Compliance (Domain 3). Together they address how organizations establish policy authority, manage risk, and achieve regulatory compliance in cloud environments.

## Cloud Governance (Domain 2)

### Definition
Governance is the set of processes, policies, roles, and responsibilities that guide decision-making and enforce accountability within an organization.

Cloud governance extends traditional governance to address cloud-specific challenges: rapid self-service provisioning, cross-border data flows, shared responsibility, vendor relationships.

### Governance Hierarchy
1. **Policies** - High-level statements of intent, approved by senior leadership
2. **Standards** - Specific, measurable requirements supporting policies
3. **Procedures** - Step-by-step instructions for executing standards
4. **Guidelines** - Recommended practices (not mandatory)
5. **Baselines** - Minimum acceptable configuration standards

### Cloud-Specific Governance Challenges
- **Speed of adoption** outpaces governance structures
- **Shadow IT** (departments adopting cloud without governance)
- **Shared responsibility** requires clear delineation of ownership
- **Vendor relationships** replace traditional in-house controls
- **Continuous change** makes point-in-time governance inadequate
- **Multi-cloud complexity** multiplies governance burden

### Cloud Governance Components
- **Cloud center of excellence (CoE)** - Internal team guiding adoption, policy, architecture
- **Policies** - Acceptable cloud use, data handling, approved providers
- **Architecture standards** - Reference architectures, landing zones
- **Risk management framework** - Cloud-aware risk methodology
- **Compliance approach** - Frameworks to apply, attestation strategy
- **Vendor management** - Due diligence, contracts, ongoing monitoring
- **Financial management** - Budgets, cost allocation, FinOps
- **Security operations** - Integration with SOC, incident response

### Governance Artifacts for Cloud
- Approved cloud provider list
- Acceptable service catalog
- Data classification and handling matrix mapping to cloud storage
- Identity and access standards
- Network architecture standards
- Security baselines (per OS, per service)
- Incident response playbooks with cloud-specific scenarios
- BC/DR standards with cloud recovery patterns

### Cloud Governance Tools
- **Policy as code** - OPA, Sentinel, AWS Config Rules, Azure Policy, GCP Organization Policy
- **Cloud Security Posture Management (CSPM)** - Continuous compliance monitoring
- **Cloud cost management** - FinOps tooling
- **Service catalogs** - Pre-approved templates (Service Catalog, Azure Managed Applications)
- **Landing zone automation** - AWS Control Tower, Azure Landing Zones, GCP Cloud Foundation

## Risk Management (Part of Domain 3)

### Risk Management Frameworks
- **NIST RMF (SP 800-37)** - Prepare, Categorize, Select, Implement, Assess, Authorize, Monitor
- **ISO 31000** - General risk management
- **ISO/IEC 27005** - Information security risk management
- **FAIR (Factor Analysis of Information Risk)** - Quantitative
- **OCTAVE / OCTAVE Allegro** - Asset-based
- **ENISA Cloud Computing Risk Assessment** - Cloud-specific (archived but influential)

### Cloud Risk Assessment Process
1. **Asset identification** - What's in the cloud?
2. **Threat identification** - Who/what might attack? (actors, TTPs)
3. **Vulnerability assessment** - What weaknesses exist?
4. **Impact assessment** - What happens if threats realize?
5. **Likelihood assessment** - How probable?
6. **Risk calculation** - Impact x Likelihood
7. **Risk treatment** - Accept, mitigate, transfer, avoid
8. **Monitor and review** - Continuous

### Cloud-Specific Risk Categories (ENISA-inspired)
- **Policy and organizational** - Lock-in, governance loss, compliance challenges, reputation
- **Technical** - Resource exhaustion, isolation failure, malicious insider, data interception, data leakage, insecure deletion, DoS
- **Legal** - Subpoena, data protection, licensing, jurisdictional disputes
- **Non-cloud-specific but amplified** - Network attacks, privilege escalation, social engineering, physical disasters

### Risk Treatment in Cloud
| Option | Example |
|--------|---------|
| Accept | Document acceptance with risk owner signoff |
| Mitigate | Apply controls (technical, process, contractual) |
| Transfer | Cyber insurance, contractual indemnification |
| Avoid | Don't use cloud for that workload |

Transfer is limited in cloud: most SLAs provide service credits, not actual damages for breach.

### Risk Appetite and Tolerance
- **Risk appetite** - Amount of risk organization is willing to accept
- **Risk tolerance** - Acceptable variation around risk appetite
- Both should be approved by senior leadership and board
- Cloud risk must map to overall organizational risk appetite

## Compliance (Part of Domain 3)

### Common Frameworks Applied to Cloud
- **NIST CSF** - US voluntary (now 2.0 with Govern function)
- **NIST SP 800-53** - Federal controls
- **ISO/IEC 27001** - ISMS standard
- **ISO/IEC 27002** - Controls catalog
- **ISO/IEC 27017** - Cloud-specific 27002
- **ISO/IEC 27018** - PII in cloud
- **ISO/IEC 27701** - Privacy management
- **CSA CCM** - Cloud Controls Matrix (most cloud-comprehensive)
- **COBIT 2019** - IT governance
- **COSO ERM** - Enterprise risk

### Industry Frameworks
- **PCI DSS** - Payment cards
- **HIPAA / HITRUST** - US healthcare
- **NIST SP 800-171** - CUI (Controlled Unclassified Information)
- **CMMC** - US defense contractors
- **SWIFT Customer Security Programme** - Financial messaging
- **NERC CIP** - US power grid

### Government Authorizations
- **FedRAMP** - US federal (Low, Moderate, High)
- **StateRAMP** - US state government
- **DoD IL2/IL4/IL5/IL6** - US Department of Defense impact levels
- **BSI C5** - German federal
- **IRAP** - Australian
- **MTCS** - Singapore
- **ENS** - Spanish

### Privacy Regulations
- **GDPR** (EU) - 72-hour breach notification, data subject rights
- **CCPA/CPRA** (California)
- **HIPAA** (US health)
- **GLBA** (US financial)
- **PIPEDA** (Canada)
- **LGPD** (Brazil)
- **POPIA** (South Africa)
- **APPI** (Japan)
- **PIPL** (China)
- **UK DPA**

### Compliance in Cloud Adaptations
- **Shared compliance** - Provider handles their scope; customer handles theirs
- **Inherited controls** - Provider's controls satisfy some customer requirements
- **Customer-responsibility matrix** - Provider documents what customer must do
- **Continuous compliance monitoring** - CSPM tools
- **Attestation reliance** - Customer uses provider's SOC 2, ISO 27001, FedRAMP ATO as evidence

## Audit in Cloud

### Audit Adaptations
- **Cannot inspect provider infrastructure** directly
- **Reliance on provider attestations** (SOC 2, ISO 27001)
- **Right-to-audit clauses** replaced by **right-to-receive audit reports**
- **Audit scope limited** to customer-controlled configuration, data, access
- **Shared assessments** - CAIQ reduces duplicative vendor questionnaires

### Audit Report Types
| Report | Scope | Period | Audience |
|--------|-------|--------|----------|
| SOC 1 Type 1 | Financial reporting controls | Point-in-time | Financial auditors |
| SOC 1 Type 2 | Same + operating effectiveness | 6-12 months | Financial auditors |
| SOC 2 Type 1 | Trust Services Criteria | Point-in-time | Customers |
| SOC 2 Type 2 | Same + operating effectiveness | 6-12 months | Customers (gold standard) |
| SOC 3 | Summary of SOC 2 | Same | Public |
| ISO 27001 certificate | ISMS | Annual + surveillance | Customers |
| FedRAMP ATO | US federal authorization | Continuous | Government |

### Trust Services Criteria (TSC) for SOC 2
- **Security** (mandatory) - Common Criteria
- **Availability** (optional)
- **Processing Integrity** (optional)
- **Confidentiality** (optional)
- **Privacy** (optional)

Most cloud vendors cover Security + Availability minimum.

## CSA STAR Program

The Security, Trust, Assurance and Risk (STAR) Registry is CSA's transparency initiative.

### STAR Levels
- **Level 1: Self-Assessment** - CAIQ submitted to registry; free
- **Level 2: Third-Party Audit**:
  - **STAR Attestation** - SOC 2 Type 2 + CCM
  - **STAR Certification** - ISO 27001 + CCM
  - **C-STAR** - China-specific
- **Level 3: Continuous Auditing** - In development

### Using STAR for Procurement
- Search STAR Registry for vendor name
- Download CAIQ to review self-attested controls
- Request STAR Attestation / Certification reports
- Use CCM to align vendor responses to your control framework

## Regulatory Requirements by Industry

### Healthcare
- HIPAA (US): PHI, BAA required, breach notification
- HITECH (US): strengthens HIPAA
- HITRUST: comprehensive framework combining HIPAA, PCI, NIST, ISO

### Financial Services
- GLBA (US): Safeguards Rule, Privacy Rule
- SOX (US): public company financial controls
- PCI DSS: payment cards
- FFIEC guidance
- FINRA (US): broker-dealer
- MAS TRM (Singapore): Monetary Authority

### Government
- FedRAMP (US): cloud authorization
- FISMA (US): federal information security
- ITAR / EAR (US): export-controlled data
- CMMC (US defense): cybersecurity maturity

### Specific Data Types
- GDPR (EU): personal data
- CCPA/CPRA (California): consumer data
- COPPA (US children): under 13
- FERPA (US education): student records

## Cloud Contract Considerations

### Key Contract Elements
- Master Service Agreement (MSA)
- SLA (availability, performance, credits)
- Data Processing Agreement (DPA) per GDPR
- BAA per HIPAA
- Standard Contractual Clauses (SCCs) for EU transfer
- Acceptable Use Policy
- Privacy Policy
- Termination and exit terms
- Data return/destruction commitments
- Sub-processor disclosure
- Liability and indemnification
- Audit rights (or audit report access)
- Insurance requirements
- Breach notification SLA

### Provider Selection Criteria
- Certifications and attestations
- Financial stability
- Geographic coverage and residency
- Data export formats
- SLA
- Historical outage record
- Customer references
- Security and privacy stance
- Industry fit (vertical-specific features)

## Common Exam Pitfalls

- Confusing SOC 1 (financial) with SOC 2 (security)
- Picking SOC 3 when SOC 2 Type 2 is needed (SOC 3 is summary)
- Missing Type 1 vs Type 2 distinction (design-only vs operating effectiveness)
- Forgetting STAR Attestation combines SOC 2 + CCM
- Missing BAA requirement for HIPAA cloud workloads
- Choosing right-to-audit when right-to-receive-audit-reports is realistic
- Not knowing GDPR breach notification is 72 hours

## Quick Reference: Framework to Use Case

| Need | Framework |
|------|-----------|
| Overall risk management | NIST RMF or ISO 31000 |
| ISMS certification | ISO 27001 |
| Cloud-specific controls catalog | CSA CCM |
| Cloud-specific 27002 | ISO 27017 |
| PII in cloud | ISO 27018 |
| US federal cloud | FedRAMP |
| German cloud | BSI C5 |
| Payment cards | PCI DSS |
| US healthcare | HIPAA + HITRUST |
| Comprehensive customer assurance | CSA STAR Level 2 |
| Quick vendor assessment | CAIQ |
