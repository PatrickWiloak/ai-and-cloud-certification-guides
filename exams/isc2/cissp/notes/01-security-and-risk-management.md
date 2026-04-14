# 01 - Security and Risk Management (Domain 1, 16%)

## Domain Overview

Domain 1 is the largest at 16% of the exam and forms the philosophical and governance foundation for all other domains. It establishes how security operates within an organization: who is responsible, how decisions get made, what frameworks govern behavior, and how risk is identified, measured, and treated.

## Foundational Security Concepts

### CIA Triad
- **Confidentiality** - Information is not disclosed to unauthorized parties
- **Integrity** - Information is not modified by unauthorized parties; data is accurate and complete
- **Availability** - Information is accessible when needed by authorized parties

### Opposite: DAD
- **Disclosure** - violation of confidentiality
- **Alteration** - violation of integrity
- **Destruction/Denial** - violation of availability

### IAAA (Identity Lifecycle)
- **Identification** - claim of identity
- **Authentication** - proof of identity
- **Authorization** - what the authenticated entity may do
- **Accountability** - logging actions to identity (often paired with auditing)

### Beyond CIA
- **Authenticity** - data is genuine
- **Non-repudiation** - sender cannot deny sending
- **Privacy** - PII handled per data subject expectations and law
- **Safety** - protection of life and physical environment (always priority 1 in CISSP)

## ISC2 Code of Ethics

The Code of Ethics canons must be applied in priority order on the exam. Memorize this order:

1. **Protect society**, the common good, necessary public trust and confidence, and the infrastructure
2. **Act honorably**, honestly, justly, responsibly, and legally
3. **Provide diligent and competent service** to principals (employer, client)
4. **Advance and protect the profession**

When ethics questions present competing canons, the higher-priority canon wins. Society > honor > service > profession.

ISC2 also publishes a code of professional ethics complaint procedure; violations can result in revocation.

## Governance: Policies, Standards, Procedures, Guidelines, Baselines

| Document | Audience | Mandatory? | Detail |
|----------|----------|------------|--------|
| Policy | Senior management to all | Yes | High-level, principles |
| Standard | Engineering, ops | Yes | Specific, measurable |
| Procedure | Operators | Yes | Step-by-step instructions |
| Guideline | Anyone | No | Recommendations |
| Baseline | Engineering, ops | Yes | Minimum acceptable configuration |

The hierarchy: policy gives the "why", standards give the "what", procedures give the "how", guidelines give the "could", baselines give the "must at least".

## Due Care vs Due Diligence

- **Due diligence** - investigation, research, planning (continuous, prudent person standard)
- **Due care** - implementation of reasonable safeguards (carrying out the diligence)

Mnemonic: Diligence Detects, Care Carries out.

Failure of either creates legal and regulatory exposure under negligence theories.

## Risk Management

### Key Definitions
- **Threat** - potential danger
- **Threat agent/actor** - entity that exploits a vulnerability
- **Vulnerability** - weakness exploitable by a threat
- **Risk** - likelihood x impact of a threat exploiting a vulnerability
- **Exposure** - condition of being at risk
- **Control / Countermeasure / Safeguard** - reduces risk

### Risk Treatment Options
1. **Mitigate** - reduce likelihood or impact via controls
2. **Avoid** - stop the activity creating risk
3. **Transfer** - shift to another party (insurance, outsourcing)
4. **Accept** - acknowledge and live with it
5. **Share** - distribute risk (joint venture, distributed liability)

Risk acceptance must be by appropriate authority and documented.

### Quantitative Risk Analysis
Formulas:
- **SLE** (Single Loss Expectancy) = AV (Asset Value) x EF (Exposure Factor, % loss per event)
- **ALE** (Annualized Loss Expectancy) = SLE x ARO (Annualized Rate of Occurrence)
- **Cost-benefit** = ALE before - ALE after - annual cost of safeguard

A control is justified when annual savings (ALE reduction) exceed annual cost.

### Qualitative Risk Analysis
- Subjective ratings (high/medium/low) based on expert judgment
- Faster, less data-intensive
- Useful when quantitative data unavailable
- Risk matrix (likelihood x impact)

### Hybrid: Semi-Quantitative
- Numeric scales (1-5) applied to qualitative ratings
- Allows arithmetic without claiming false precision

## Risk Frameworks

| Framework | Origin | Purpose |
|-----------|--------|---------|
| NIST RMF (SP 800-37) | NIST | 7-step risk management lifecycle |
| ISO 31000 | ISO | General risk management |
| ISO/IEC 27005 | ISO | InfoSec risk management |
| OCTAVE / OCTAVE Allegro | CMU/CERT | Asset-based risk assessment |
| FAIR (Factor Analysis of Information Risk) | The Open Group | Quantitative risk model |
| TARA (Threat Agent Risk Assessment) | Intel | Threat-centric |
| COSO ERM | COSO | Enterprise risk management |

NIST RMF steps: Prepare, Categorize, Select, Implement, Assess, Authorize, Monitor.

## Threat Modeling

Methodologies:

### STRIDE (Microsoft)
- **S**poofing
- **T**ampering
- **R**epudiation
- **I**nformation disclosure
- **D**enial of service
- **E**levation of privilege

### PASTA (Process for Attack Simulation and Threat Analysis)
7-stage methodology: define objectives, scope, decomposition, threat analysis, vulnerability analysis, attack modeling, risk analysis.

### DREAD (deprecated by Microsoft but tested)
- **D**amage potential
- **R**eproducibility
- **E**xploitability
- **A**ffected users
- **D**iscoverability

### Attack Trees (Schneier)
Goal at root, paths and steps as branches.

### VAST
Visual, Agile, Simple Threat modeling.

## Compliance and Legal

### Major US Regulations
- **HIPAA** - Health information (PHI), Privacy and Security Rules, BAA required for business associates
- **HITECH** - Strengthens HIPAA enforcement, breach notification
- **GLBA** - Financial institutions, Safeguards Rule, Privacy Rule, Pretexting Provisions
- **SOX** - Public companies, financial controls (Sec 302, 404, 802)
- **FISMA** - Federal agencies, NIST SP 800-53 controls
- **FedRAMP** - Cloud services to federal government
- **FERPA** - Student education records
- **COPPA** - Children online (under 13)
- **CFAA** - Computer Fraud and Abuse Act (criminal)
- **ECPA** - Electronic Communications Privacy Act
- **DMCA** - Digital Millennium Copyright Act

### Major Privacy Regulations
- **GDPR** (EU) - Data subject rights, lawful bases, DPO, breach notification 72 hours, fines up to 4% global revenue or EUR 20M
- **CCPA / CPRA** (California) - Consumer rights to know, delete, opt-out of sale, correct
- **PIPEDA** (Canada)
- **LGPD** (Brazil)
- **POPIA** (South Africa)
- **APPI** (Japan)
- **PIPL** (China)

### Industry Standards
- **PCI DSS** - Payment cards, contractual not legal, 12 requirements, 6 control objectives
- **NIST CSF** - Voluntary framework, 6 functions: Govern, Identify, Protect, Detect, Respond, Recover (CSF 2.0)
- **ISO 27001** - ISMS certification standard
- **SOC 1/2/3** - AICPA Service Organization Controls audits

## Investigation Types

| Type | Court | Standard of Proof | Example |
|------|-------|-------------------|---------|
| Criminal | Criminal court | Beyond a reasonable doubt | Computer fraud charges |
| Civil | Civil court | Preponderance of the evidence | Contract breach |
| Regulatory | Administrative | Industry-specific | HIPAA OCR investigation |
| Administrative | Internal | More likely than not | HR policy violation |

### Evidence Standards
- **Best evidence rule** - Original preferred over copy
- **Hearsay rule** - Out-of-court statements generally inadmissible (with exceptions like business records)
- **Chain of custody** - Documented handling from collection to court

### Evidence Types
- **Real evidence** - Physical objects
- **Documentary** - Documents, records
- **Testimonial** - Witness statements
- **Demonstrative** - Visual aids (charts, models)

### Evidence Properties (must be all)
- Sufficient
- Reliable
- Relevant
- Authentic
- Permissible (legally obtained)

## Business Continuity Requirements

### BCP Process
1. Project initiation and scoping
2. Business impact analysis (BIA)
3. Recovery strategy development
4. Plan design and implementation
5. Testing
6. Training and awareness
7. Maintenance

### Business Impact Analysis (BIA)
- Identify critical business functions
- Identify dependencies (people, systems, vendors, data)
- Determine impact of disruption (financial, regulatory, reputational, operational)
- Define recovery objectives (RTO, RPO, MTD, WRT)
- Prioritize recovery order

### Recovery Metrics
- **MTD** (Maximum Tolerable Downtime) - business cannot exceed
- **RTO** (Recovery Time Objective) - target restore time, must be less than MTD
- **RPO** (Recovery Point Objective) - acceptable data loss measured backward in time
- **WRT** (Work Recovery Time) - data validation and prep after RTO
- **MTBF** - reliability of components
- **MTTR** - time to repair/restore

## Personnel Security

### Pre-Employment
- Background checks (calibrated to role sensitivity)
- Reference checks
- Drug screening (where lawful)
- Credit checks (for financial roles)
- NDA signing

### During Employment
- Onboarding security training
- Annual security awareness (mandatory, attested)
- Role-based training
- Acceptable use policy acknowledgment
- Job rotation, mandatory vacation, separation of duties for high-trust roles

### Termination
- Friendly: notice period, knowledge transfer, controlled access reduction
- Unfriendly: immediate access revocation, escort out, change locks/credentials
- Account de-provisioning before notification when warranted

## Supply Chain Risk Management (SCRM)

### Concerns
- Counterfeit hardware/software
- Embedded backdoors
- Compromised vendor systems with access to customer data
- Vendor going out of business
- Data location, sub-processors, transfer mechanisms

### Controls
- Vendor security questionnaires (SIG, CAIQ)
- SOC 2 Type 2 review
- Contractual right to audit
- BAA, DPA, MSA addendums for security/privacy
- Continuous third-party risk monitoring (BitSight, SecurityScorecard)
- SBOM requirements
- Code escrow
- Defined offboarding procedures (data return/destruction)

### NIST SP 800-161 - SCRM guidance.

## Security Education, Training, Awareness (SETA)

- **Awareness** - what to do (posters, all-hands)
- **Training** - how to do (role-based modules)
- **Education** - why to do (formal courses, degrees)

Effectiveness measured via metrics: phishing test click-rates, training completion, policy attestation rates.

## Personnel Safety in Decisions

CISSP heavily tests the principle that personnel safety always takes priority over assets, data, or operations. In any scenario involving physical danger, the right answer is always the one that protects life first.

## Common Exam Pitfalls

- Misordering Code of Ethics canons (society first)
- Confusing due care (action) with due diligence (planning)
- Treating risk acceptance as approval-free (must be authorized)
- Choosing technical fix when policy/process is the root cause
- Forgetting that personnel safety always wins
- Mixing BCP (broad) with DRP (technical recovery subset)
- Not knowing breach notification timelines (GDPR 72h, HIPAA 60d)
