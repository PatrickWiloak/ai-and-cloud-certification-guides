# Domain 5: Security Program Management and Oversight (20%)

## Overview
This domain covers security governance, risk management, compliance, third-party risk assessment, auditing, and security awareness. Understanding how security programs are managed, measured, and maintained is crucial for both the exam and real-world security practice.

## Security Governance

**[📖 NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)** - Core cybersecurity governance framework

### Governance Structure

**Board and Executive Level:**
- Set security strategy and risk appetite
- Approve security policies and budgets
- Receive regular security reports and metrics
- Ultimate accountability for security posture

**Security Leadership:**
- **CISO** (Chief Information Security Officer) - Leads security program
- **CSO** (Chief Security Officer) - Physical and cyber security
- **DPO** (Data Protection Officer) - GDPR requirement for some organizations

**Security Team:**
- Security analysts and engineers
- Incident response team
- Security architects
- Compliance and audit staff
- Security awareness trainers

### Security Policies

**Policy Hierarchy:**
```
Policies (mandatory, high-level "what")
  └── Standards (mandatory, specific requirements)
        └── Procedures (mandatory, step-by-step "how")
              └── Guidelines (recommended, best practices)
```

**Key Policy Types:**
| Policy | Purpose | Example |
|--------|---------|---------|
| **Acceptable Use (AUP)** | Define acceptable system usage | No personal use of work email |
| **Information Security** | Overall security framework | Data must be encrypted at rest |
| **Access Control** | Who can access what | Role-based access required |
| **Data Classification** | Data handling requirements | Four levels: public to restricted |
| **Incident Response** | How to handle security incidents | Report within 1 hour |
| **Remote Work** | Security for remote employees | VPN required, MFA mandatory |
| **BYOD** | Personal device usage | MDM enrollment required |
| **Password** | Credential requirements | 12+ characters, MFA required |
| **Change Management** | How changes are approved | CAB approval for production |
| **Data Retention** | How long data is kept | Logs retained for 1 year |
| **Disaster Recovery** | Recovery procedures | RTO of 4 hours for critical systems |

### Data Governance

**Data Classification Levels:**
| Level | Description | Handling | Example |
|-------|-------------|----------|---------|
| **Public** | No restrictions | Open access | Marketing materials |
| **Internal** | Organization only | Basic access controls | Internal memos |
| **Confidential** | Restricted access | Encryption, access controls | Financial reports |
| **Restricted/Secret** | Highest protection | Strong encryption, strict access | PII, PHI, trade secrets |

**Data Roles:**
- **Data owner** - Business executive responsible for data classification and policy
- **Data custodian** - IT staff responsible for implementing technical controls
- **Data processor** - Entity that processes data on behalf of controller (GDPR)
- **Data controller** - Entity that determines purposes of data processing (GDPR)
- **Data steward** - Ensures data quality and compliance with policies
- **Data subject** - Individual whose data is being processed

**Data Lifecycle:**
1. **Create/Collect** - Classification at creation
2. **Store** - Encrypted, access controlled
3. **Use** - Access logged, DLP monitored
4. **Share** - Secure transmission, need-to-know
5. **Archive** - Retained per policy, still protected
6. **Destroy** - Secure deletion, certificate of destruction

### Data Destruction Methods
| Method | Media | Description |
|--------|-------|-------------|
| **Overwriting** | HDD | Write patterns over data (DoD 5220.22-M) |
| **Degaussing** | HDD, tape | Magnetic field destroys data |
| **Crypto-shredding** | Any encrypted | Destroy encryption keys |
| **Physical destruction** | Any | Shredding, incineration, pulverizing |
| **Secure erase** | SSD | Manufacturer command for SSDs |

## Risk Management

**[📖 NIST SP 800-30 - Risk Assessment Guide](https://csrc.nist.gov/publications/detail/sp/800-30/rev-1/final)** - Guide for conducting risk assessments

### Risk Concepts

**Core Terms:**
- **Risk** - Potential for loss or damage
- **Threat** - Potential danger that could exploit a vulnerability
- **Vulnerability** - Weakness that could be exploited by a threat
- **Impact** - Business consequence if risk materializes
- **Likelihood** - Probability the risk will occur
- **Risk appetite** - Amount of risk an organization is willing to accept
- **Risk tolerance** - Acceptable variation from risk appetite
- **Residual risk** - Risk remaining after controls are applied
- **Inherent risk** - Risk before any controls are applied

### Risk Assessment Process
1. **Identify assets** - What are we protecting?
2. **Identify threats** - What could go wrong?
3. **Identify vulnerabilities** - What weaknesses exist?
4. **Analyze likelihood** - How probable is the risk?
5. **Analyze impact** - What is the consequence?
6. **Calculate risk** - Combine likelihood and impact
7. **Prioritize** - Rank risks for treatment
8. **Document** - Record in risk register

### Qualitative Risk Analysis
- Subjective assessment using descriptive scales
- Likelihood: High, Medium, Low
- Impact: High, Medium, Low
- Risk matrix combines likelihood and impact
- Faster and simpler, but less precise

**Risk Matrix:**
| | Low Impact | Medium Impact | High Impact |
|---|-----------|---------------|-------------|
| **High Likelihood** | Medium | High | Critical |
| **Medium Likelihood** | Low | Medium | High |
| **Low Likelihood** | Low | Low | Medium |

### Quantitative Risk Analysis
- Numerical values for likelihood and impact
- More precise but requires more data

**Key Formulas:**
- **Asset Value (AV)** - Dollar value of the asset
- **Exposure Factor (EF)** - Percentage of asset lost in incident (0-100%)
- **Single Loss Expectancy (SLE)** = AV x EF
- **Annual Rate of Occurrence (ARO)** - Expected incidents per year
- **Annualized Loss Expectancy (ALE)** = SLE x ARO

**Example:**
- Server worth $50,000 (AV)
- Fire would destroy 80% (EF = 0.8)
- SLE = $50,000 x 0.8 = $40,000
- Fire expected once every 20 years (ARO = 0.05)
- ALE = $40,000 x 0.05 = $2,000/year
- Spend up to $2,000/year on fire prevention controls

### Risk Response Strategies

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| **Mitigate/Reduce** | Implement controls to reduce likelihood or impact | Risk exceeds appetite, cost-effective controls available |
| **Accept** | Acknowledge risk, no action taken | Risk within appetite, cost of control exceeds risk |
| **Transfer/Share** | Shift risk to third party | Insurance, outsourcing, SLA |
| **Avoid** | Eliminate activity causing risk | Risk too high, no acceptable mitigation |

### Risk Register
- Document of all identified risks
- Contains: Risk description, likelihood, impact, risk score, owner, response, status
- Living document - updated regularly
- Reviewed by management and governance bodies
- Tracks risk treatment progress

### Business Impact Analysis (BIA)
- Identifies critical business functions
- Determines impact of disruption to each function
- Establishes RTO and RPO for each function
- Prioritizes recovery efforts
- Informs disaster recovery and business continuity planning

**Key Metrics:**
- **Maximum Tolerable Downtime (MTD)** - Longest acceptable outage
- **Recovery Time Objective (RTO)** - Target time to restore
- **Recovery Point Objective (RPO)** - Maximum acceptable data loss
- **Mean Time Between Failures (MTBF)** - Average uptime between failures
- **Mean Time to Repair (MTTR)** - Average time to fix

## Compliance Frameworks

### NIST Cybersecurity Framework (CSF)

**[📖 NIST CSF 2.0](https://www.nist.gov/cyberframework)** - Latest framework documentation

**Functions:**
1. **Govern** - Establish and monitor cybersecurity risk management (new in 2.0)
2. **Identify** - Understand assets, risks, and business context
3. **Protect** - Implement safeguards for critical services
4. **Detect** - Identify cybersecurity events
5. **Respond** - Take action regarding detected events
6. **Recover** - Restore capabilities after an incident

**Implementation Tiers:**
- Tier 1: Partial - Ad hoc, reactive
- Tier 2: Risk Informed - Awareness but inconsistent
- Tier 3: Repeatable - Formal, consistent processes
- Tier 4: Adaptive - Continuous improvement, proactive

### NIST Risk Management Framework (RMF)

**[📖 NIST SP 800-37 - RMF Guide](https://csrc.nist.gov/publications/detail/sp/800-37/rev-2/final)** - Risk Management Framework for information systems

**Steps:**
1. **Prepare** - Establish context and priorities
2. **Categorize** - Information system based on impact
3. **Select** - Security controls (from SP 800-53)
4. **Implement** - Deploy security controls
5. **Assess** - Evaluate control effectiveness
6. **Authorize** - Senior official accepts residual risk
7. **Monitor** - Ongoing assessment and reporting

### ISO 27001
- International standard for Information Security Management System (ISMS)
- Requires formal risk assessment process
- Annex A: 93 controls across 4 themes (organizational, people, physical, technological)
- Third-party certification audit
- Plan-Do-Check-Act continuous improvement cycle
- Globally recognized certification

### CIS Controls (v8)

**[📖 CIS Controls](https://www.cisecurity.org/controls)** - Prioritized cybersecurity best practices

- 18 control categories prioritized by effectiveness
- Implementation Groups (IG1, IG2, IG3) based on organization maturity
- Prescriptive and actionable security guidance

**Top CIS Controls:**
1. Inventory and Control of Enterprise Assets
2. Inventory and Control of Software Assets
3. Data Protection
4. Secure Configuration of Enterprise Assets and Software
5. Account Management

### SOC Reports (Service Organization Control)
| Report | Audience | Content |
|--------|----------|---------|
| **SOC 1** | Financial auditors | Controls relevant to financial reporting |
| **SOC 2 Type I** | Management | Design of controls at a point in time |
| **SOC 2 Type II** | Management | Operating effectiveness over a period |
| **SOC 3** | Public | General use report, summary of SOC 2 |

### Regulatory Compliance

**GDPR (General Data Protection Regulation):**
- Scope: Personal data of EU/EEA data subjects
- Data subject rights: Access, rectification, erasure, portability, restrict processing
- Requires: DPO, DPIA, breach notification within 72 hours
- Penalties: Up to 4% of global annual revenue or 20M EUR
- Applies to any organization processing EU personal data

**HIPAA (Health Insurance Portability and Accountability Act):**
- Scope: Protected Health Information (PHI) in US healthcare
- Rules: Privacy Rule, Security Rule, Breach Notification Rule
- Covered entities: Healthcare providers, health plans, clearinghouses
- Business associates must also comply
- Breach notification: 60 days for breaches affecting 500+ individuals

**PCI-DSS (Payment Card Industry Data Security Standard):**
- Scope: Cardholder data environment
- 12 requirements across 6 goals
- Compliance levels based on transaction volume
- Annual assessment: SAQ or QSA audit depending on level
- Network segmentation of cardholder data environment

**SOX (Sarbanes-Oxley Act):**
- Scope: US publicly traded companies
- Financial reporting controls and audits
- IT controls that impact financial reporting
- CEO/CFO personal certification of financial statements

## Third-Party Risk Management

### Vendor Assessment Process
1. **Due diligence** - Research vendor security posture before engagement
2. **Risk assessment** - Evaluate risks of vendor relationship
3. **Contract review** - Security requirements in agreements
4. **Ongoing monitoring** - Continuous assessment of vendor compliance
5. **Exit strategy** - Plan for terminating vendor relationship

### Assessment Methods
| Method | Description | Depth |
|--------|-------------|-------|
| **Questionnaire** | Self-assessment by vendor | Low - relies on vendor honesty |
| **Documentation review** | Review vendor policies and procedures | Medium |
| **SOC 2 review** | Review independent audit report | High |
| **On-site audit** | Visit vendor facilities | Highest |
| **Penetration test** | Test vendor's security posture | High (if permitted) |

### Key Contract Provisions
- **SLA** - Service level commitments with penalties
- **Right to audit** - Ability to assess vendor security
- **Breach notification** - Timeline and requirements for disclosure
- **Data handling** - Encryption, access controls, retention
- **Liability and indemnification** - Who bears the cost of incidents
- **Insurance** - Cyber insurance requirements
- **Termination** - Data return and destruction upon contract end
- **Compliance** - Regulatory compliance requirements

### Supply Chain Risk
- Software composition analysis for third-party libraries
- Hardware supply chain integrity verification
- Vendor security assessment and monitoring
- Software Bill of Materials (SBOM) for transparency
- Code signing and integrity verification

## Audits and Assessments

### Audit Types
| Type | Conducted By | Purpose |
|------|-------------|---------|
| **Internal** | Organization's audit team | Self-assessment, process improvement |
| **External** | Third-party auditors | Independent verification |
| **Regulatory** | Government/regulatory body | Compliance verification |

### Assessment Types
- **Vulnerability assessment** - Identify security weaknesses
- **Penetration test** - Attempt to exploit vulnerabilities
- **Risk assessment** - Evaluate threats and their impact
- **Gap analysis** - Compare current state to desired state/framework
- **Compliance assessment** - Verify adherence to regulations
- **Tabletop exercise** - Discussion-based incident simulation
- **Security audit** - Formal review of security controls

## Security Awareness Training

### Training Program Components
1. **Phishing simulations** - Regular simulated phishing campaigns
2. **Security awareness modules** - Interactive training content
3. **Role-based training** - Specific training for high-risk roles
4. **New hire orientation** - Security training during onboarding
5. **Annual refresher** - Yearly training updates
6. **Incident-driven** - Training after security events

### Training Topics
- Password security and MFA importance
- Phishing and social engineering recognition
- Data handling and classification
- Physical security awareness
- Reporting procedures for suspicious activity
- Clean desk policy
- Mobile device security
- Social media risks
- Remote work security practices

### Measuring Effectiveness
- Phishing simulation click rates (should decrease over time)
- Number of reported suspicious emails (should increase)
- Security incident frequency (should decrease)
- Training completion rates
- Post-training assessment scores
- Help desk security-related ticket trends

### Gamification and Engagement
- Rewards for reporting phishing attempts
- Departmental competitions
- Security champion programs
- Leaderboards and badges
- Real-world examples and case studies

---

## Key Takeaways for the Exam

1. Know the policy hierarchy: policies -> standards -> procedures -> guidelines
2. Risk formula: Quantitative uses ALE = SLE x ARO; Qualitative uses likelihood x impact matrix
3. Know risk responses: mitigate, accept, transfer, avoid
4. NIST CSF functions: Govern, Identify, Protect, Detect, Respond, Recover
5. Know data roles: owner (classifies), custodian (implements), processor, controller
6. Know compliance: GDPR (EU data), HIPAA (healthcare), PCI-DSS (payments), SOX (financial)
7. Third-party risk: due diligence before, monitoring during, exit strategy after
8. BIA determines MTD, RTO, RPO for business continuity planning
