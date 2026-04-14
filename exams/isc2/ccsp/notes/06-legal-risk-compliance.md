# 06 - Legal, Risk, and Compliance (Domain 6, 13%)

## Domain Overview

Domain 6 covers the legal, regulatory, contractual, and risk management aspects of cloud computing. It is the smallest domain by weight but has historically tripped up technically-oriented candidates. Cloud introduces unique legal concerns due to multi-jurisdictional data location, shared responsibility, and reliance on third-party providers.

## Cloud-Specific Legal Risks

### Jurisdictional Issues
- Data may be physically located in countries with different laws than:
  - Where the cloud customer is based
  - Where the data subjects reside
  - Where the cloud provider is based
- Conflicting legal obligations possible (e.g., US CLOUD Act vs GDPR)
- Subpoena and law enforcement access varies by jurisdiction

### Data Sovereignty
- Whose laws govern the data
- Often based on data location, but not always (residency vs sovereignty distinction)
- Some countries require data localization (Russia, China for certain data)

### Cross-Border Transfer
- GDPR restricts personal data transfer outside EEA without safeguards
- Adequacy decisions: countries deemed safe (UK, Switzerland, Japan, Canada partially, others)
- Standard Contractual Clauses (SCCs)
- Binding Corporate Rules (BCRs)
- EU-US Data Privacy Framework (post-Schrems II)
- Specific Article 49 derogations (consent, contract necessity, vital interests, important public interest)

### Schrems I and II
- Schrems I (2015): invalidated US Safe Harbor
- Schrems II (2020): invalidated US Privacy Shield
- Required transfer impact assessment for any non-adequate destination
- Surveillance laws of destination must be assessed

## Privacy Regulations

### GDPR (EU General Data Protection Regulation)
- In force May 2018
- Applies to processing of EU residents' personal data, regardless of processor location
- Key principles: lawfulness, fairness, transparency, purpose limitation, data minimization, accuracy, storage limitation, integrity and confidentiality, accountability
- Lawful bases: consent, contract, legal obligation, vital interests, public task, legitimate interests
- Data subject rights: access, rectification, erasure, restriction of processing, portability, object, not be subject to automated decision-making
- Roles: controller, processor, sub-processor, DPO, supervisory authority
- Data Protection Impact Assessment (DPIA) for high-risk processing
- Records of Processing Activities (RoPA)
- 72-hour breach notification to supervisory authority
- Breach notification to data subjects without undue delay if high risk
- Fines: up to EUR 20M or 4% of global annual turnover, whichever higher

### CCPA / CPRA (California)
- CCPA effective 2020; CPRA amendments effective 2023
- Applies to businesses meeting size or activity thresholds
- Consumer rights: know, delete, correct (CPRA), opt-out of sale, opt-out of sharing for cross-context behavioral advertising
- Sensitive personal information additional protections
- California Privacy Protection Agency (CPPA) enforcement
- Fines per violation

### Other US State Laws
- Virginia VCDPA, Colorado CPA, Connecticut CTDPA, Utah UCPA, Texas TDPSA, etc.
- Increasing patchwork; many similar to GDPR-lite

### HIPAA (US Healthcare)
- Privacy Rule, Security Rule, Breach Notification Rule
- Covered entities (providers, plans, clearinghouses) and business associates
- Business Associate Agreement (BAA) required between covered entity and BA
- Cloud providers as BAs require BAA before storing/processing PHI
- Breach notification: 60 days to individuals; HHS notification depends on breach size
- Civil monetary penalties; criminal penalties possible

### GLBA (US Financial)
- Safeguards Rule, Privacy Rule, Pretexting Provisions
- Applies to financial institutions

### SOX (US Public Companies)
- Section 302: CEO/CFO certification of financial reports
- Section 404: management assessment of internal controls
- Section 802: criminal penalties for tampering with records
- Cloud impact: financial-reporting-relevant cloud services need control environment

### PCI DSS (Payment Cards)
- Contractual standard, not law
- 12 requirements, 6 control objectives
- Applies anywhere card data is stored, processed, transmitted
- Compliance levels based on transaction volume
- ROC by QSA (Qualified Security Assessor) for level 1; SAQ for smaller
- Tokenization can reduce scope

### Other International Regs
- **PIPEDA** (Canada)
- **LGPD** (Brazil)
- **POPIA** (South Africa)
- **APPI** (Japan)
- **PIPL** (China) - Strict cross-border transfer requirements
- **DPA** (UK) - Post-Brexit
- **PDPA** (Singapore, Thailand, Malaysia)
- **Australian Privacy Act**

## Cloud Audit Process

### Adaptations for Cloud
- Customer cannot inspect provider infrastructure directly
- Reliance on provider attestations
- Right-to-audit clauses often replaced with right-to-receive audit reports
- Audit scope limited to customer-controlled configuration, data, identity
- Provider's audit reports validate provider controls

### Audit Methodology
1. Planning - scope, criteria, methodology
2. Fieldwork - evidence collection (control plane logs, configurations, policies)
3. Reporting - findings, recommendations
4. Follow-up - remediation tracking

### Audit Reports for Cloud Providers
| Report | Scope | Audience |
|--------|-------|----------|
| SOC 1 Type 1 | Controls relevant to financial reporting; design point-in-time | Financial auditors |
| SOC 1 Type 2 | Same scope; over period (6-12 mo); operating effectiveness tested | Financial auditors |
| SOC 2 Type 1 | Trust Services Criteria; design only | Customers |
| SOC 2 Type 2 | Trust Services Criteria; over period | Customers (preferred) |
| SOC 3 | Public summary of SOC 2 | Anyone |

### Trust Services Criteria (TSC)
- **Security** (mandatory) - Common Criteria
- **Availability** (optional)
- **Processing Integrity** (optional)
- **Confidentiality** (optional)
- **Privacy** (optional)

### CSA STAR Levels
- **Level 1** - Self-assessment (CAIQ), free, in STAR Registry
- **Level 2** - Third-party audit:
  - **STAR Attestation** = SOC 2 Type 2 + CCM
  - **STAR Certification** = ISO 27001 + CCM
  - **C-STAR** = China-specific
- **Level 3** - Continuous auditing (in development)

### ISO Certifications
- **ISO 27001** - ISMS certification with surveillance and recertification
- **ISO 27017** - Cloud-specific 27002 controls
- **ISO 27018** - PII in public clouds
- **ISO 27701** - Privacy management on top of 27001/27002
- **ISO 22301** - Business continuity management
- **ISO 9001** - Quality management

### Government Authorizations
- **FedRAMP** - US federal; Low (LATO), Moderate, High impact levels
- **StateRAMP** - US state government
- **DoD IL2/IL4/IL5/IL6** - US Department of Defense impact levels
- **BSI C5** - German federal
- **IRAP** - Australian government
- **MTCS** - Singapore IMDA
- **ENS** - Spanish national security framework
- **Cyber Essentials Plus** - UK government baseline

## Cloud Risk Management

### Frameworks
- **NIST RMF (SP 800-37)** - 7-step lifecycle: Prepare, Categorize, Select, Implement, Assess, Authorize, Monitor
- **ISO 31000** - General risk management
- **ISO/IEC 27005** - InfoSec risk management
- **ENISA Cloud Computing Risk Assessment** - European cloud-specific

### Cloud-Specific Risk Categories
- **Policy and organizational** - Lock-in, governance loss, compliance challenges
- **Technical** - Resource exhaustion, isolation failure, malicious insider, intercepts in transit, data leakage
- **Legal** - Subpoena, jurisdictional challenges, licensing risks, data protection
- **Non-cloud-specific but amplified** - Network breaks, network attacks, privilege escalation, social engineering

### Risk Treatment in Cloud
- **Mitigate** - Apply technical controls, contract terms, vendor selection
- **Transfer** - Cyber insurance, contractual indemnification (limited in cloud)
- **Accept** - Document acceptance with risk owner approval
- **Avoid** - Don't use cloud for that workload

### Cloud Risk Assessment Considerations
- Service model (IaaS/PaaS/SaaS) shifts risk distribution
- Deployment model (public/private/hybrid/community) affects exposure
- Data classification drives required controls
- Vendor lock-in and reversibility
- Dependencies and supply chain
- Physical and political risks (region selection)
- Compliance overlap with cloud customer obligations

## Cloud Contract Design

### Core Contract Elements
| Element | Purpose |
|---------|---------|
| Master Service Agreement (MSA) | Overall terms and conditions |
| Statement of Work (SOW) | Specific deliverables |
| Service Level Agreement (SLA) | Availability, performance commitments |
| Data Processing Agreement (DPA) | GDPR-required for processors |
| Business Associate Agreement (BAA) | HIPAA-required for PHI |
| Standard Contractual Clauses (SCCs) | EU cross-border transfer |
| Acceptable Use Policy | Restrictions on use |
| Privacy Policy | Data handling commitments |

### SLA Components
- Availability commitment (e.g., 99.9%, 99.99%)
- Performance metrics
- Service credits for non-compliance (rarely actual damages)
- Exclusions (force majeure, scheduled maintenance)
- Remedy process
- Sole and exclusive remedy clauses to be reviewed

### Critical Contract Provisions
- Data ownership (customer retains)
- Data location and residency
- Sub-processor disclosure and approval
- Data return / destruction at termination
- Right to audit / right to receive audit reports
- Liability limits
- Indemnification
- Insurance requirements
- Breach notification SLA
- Compliance commitments
- Confidentiality
- IP ownership
- Term and termination
- Exit transition assistance
- Dispute resolution and governing law

### Common Cloud Contract Pitfalls
- Auto-renewal with insufficient notice
- Unilateral changes to terms (read amendment process)
- Limited liability that doesn't cover data breach impact
- Unclear data deletion timelines
- Missing right to audit or audit report
- Sub-processor lists hidden or changeable without notice
- Force majeure too broad
- Choice of law unfavorable

## Vendor Management

### Vendor Lifecycle
1. **Identification** - business need, candidate vendors
2. **Due diligence** - questionnaires, attestations, references
3. **Negotiation** - contract terms, pricing, security additions
4. **Onboarding** - integration, access provisioning, baseline assessment
5. **Ongoing management** - periodic reassessment, performance review, incident handling
6. **Offboarding** - data return/destruction, access revocation, lessons learned

### Vendor Risk Tiers
- **Tier 1** (critical) - Material business impact, sensitive data; deepest review, annual reassessment, continuous monitoring
- **Tier 2** (important) - Significant impact; annual review
- **Tier 3** (low risk) - Minimal impact; periodic review

### Continuous Monitoring
- BitSight, SecurityScorecard, Black Kite, RiskRecon (third-party risk ratings)
- News and breach disclosure monitoring
- SOC 2 Type 2 reissue tracking
- Sub-processor change notifications

## E-Discovery in Cloud

### Considerations
- Customer data may be in multiple cloud regions/services
- Provider may need to participate in evidence preservation
- Cloud data formats may complicate review
- Legal hold processes must extend to cloud (suspend deletion, retention)
- ESI (Electronically Stored Information) standards

### Cloud Provider Cooperation
- Most major providers have eDiscovery support documentation
- Subpoenas served on the cloud provider for customer data
- Customer typically notified unless gag order
- Cross-border eDiscovery: jurisdictional complications

## Forensic Data Collection Legal Considerations

### Search and Seizure
- US 4th Amendment (warrant required for government)
- Private organizations: per acceptable use policy
- Cloud: provider may require legal process for some evidence
- Cross-border: MLAT (Mutual Legal Assistance Treaties) for international

### CLOUD Act (US)
- US providers can be compelled to produce data regardless of location
- Conflicts with GDPR for EU-resident data
- Mitigations: encryption with customer-controlled keys, data localization, certified frameworks

### Chain of Custody in Cloud
- Cloud API actions logged with timestamp, identity, action
- Snapshot creation timestamps
- Hash verification at each handling step
- Documented operator and rationale

## Privacy Impact Assessments / DPIAs

### When Required
- GDPR DPIA: high-risk processing
  - Systematic and extensive evaluation of personal aspects
  - Large-scale processing of special category data
  - Systematic monitoring of public areas
- US, Canada, others: increasingly required for new systems

### DPIA Process
1. Describe the processing
2. Assess necessity and proportionality
3. Identify and assess risks to data subject rights
4. Identify mitigating measures
5. Consult DPO (and supervisory authority if high residual risk)
6. Document and review periodically

## Common Exam Pitfalls

- Confusing data residency (where) with data sovereignty (whose laws)
- Mixing SOC 1 (financial) with SOC 2 (security/etc.)
- Selecting SOC 3 when SOC 2 Type 2 is needed (SOC 3 is summary)
- Forgetting BAA for HIPAA cloud workloads
- Choosing right-to-audit when right-to-receive-audit-reports is realistic for cloud
- Missing transfer mechanisms for cross-border (SCCs, DPF, BCRs)
- Forgetting CLOUD Act vs GDPR conflict
- Not knowing CSA STAR levels and what they include

## Quick Reference: Audit/Attestation Selection

| Need | Choice |
|------|--------|
| Trust a SaaS provider's security | SOC 2 Type 2 (request the full report) |
| Demonstrate a specific compliance framework | ISO 27001, FedRAMP, PCI DSS, etc. |
| Cloud-specific assurance | CSA STAR Level 2 (Attestation or Certification) |
| Public-facing summary | SOC 3 |
| Financial reporting controls | SOC 1 Type 2 |
| Privacy controls | ISO 27701, SOC 2 with Privacy criterion |
| US Federal customer requirements | FedRAMP at appropriate impact level |
| German/EU cloud assurance | BSI C5 |
