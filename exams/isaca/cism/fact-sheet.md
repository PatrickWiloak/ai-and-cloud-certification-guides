# CISM Fact Sheet

## Exam Logistics

| Item | Detail |
|------|--------|
| Exam Code | CISM |
| Format | Linear, fixed-form |
| Duration | 4 hours (240 minutes) |
| Question Count | 150 multiple-choice |
| Passing Score | 450 / 800 (scaled) |
| Cost (USD) | $575 ISACA member / $760 non-member |
| Languages | English, Chinese (Simplified), Japanese, Korean, Spanish |
| Delivery | PSI testing centers and online proctored |
| Retake Policy | 4 attempts per 12 months; minimum 30 days between attempts |
| Validity | 3 years (perpetual with maintenance) |
| Maintenance | 120 CPE / 3 years (20 CPE/yr min) + annual maintenance fee |
| Experience Requirement | 5 years infosec, 3 years specifically in security management, in 3+ domains, within 10-year window |

## Domain Weights (2022 Refresh)

| Domain | Weight |
|--------|--------|
| 1. Information Security Governance | 17% |
| 2. Information Security Risk Management | 20% |
| 3. Information Security Program | 33% |
| 4. Incident Management | 30% |

Domains 3 and 4 together account for 63% of the exam. Programs and incidents are where the most points are.

## Eligibility and Application

| Path | Requirement |
|------|-------------|
| Standard | 5 years information security experience, with 3 years specifically in security management |
| Domain coverage | Experience must cover at least 3 of the 4 CISM domains |
| Time window | Experience earned within 10 years before application or within 5 years after passing exam |
| Substitutions | 2 years of substitution allowed: CISA, CISSP, MS in InfoSec, ISO 27001 LA/LI, etc. each count for some experience credit |
| Verification | Employer or supervisor confirmation required |

You may sit the exam without the experience and complete the application later.

## ISACA Code of Professional Ethics

CISM holders must agree to and comply with seven principles:

1. Support the implementation of, and encourage compliance with, appropriate standards and procedures for the effective governance and management of enterprise information systems and technology.
2. Perform duties with objectivity, due diligence, and professional care, in accordance with professional standards.
3. Serve in the interest of stakeholders in a lawful manner, while maintaining high standards of conduct and character, and not discrediting the profession.
4. Maintain privacy and confidentiality of information obtained except for required disclosures.
5. Maintain competency, undertaking only those activities they can reasonably expect to complete with the necessary skills, knowledge, and competence.
6. Inform appropriate parties of the results of work performed including the disclosure of all significant facts.
7. Support the professional education of stakeholders in enhancing their understanding of the governance and management of enterprise information systems and technology, including security.

When the exam frames an ethics question, choose the response that supports stakeholders, transparency, and the profession over personal benefit.

## Risk Management Formulas

These appear directly on the exam as calculation questions. Memorize.

- **EF** (Exposure Factor) = percentage of asset value lost in a single event (0.0 to 1.0)
- **SLE** (Single Loss Expectancy) = AV (Asset Value) x EF
- **ARO** (Annualized Rate of Occurrence) = expected events per year (can be < 1, e.g., 0.1 = once per 10 years)
- **ALE** (Annualized Loss Expectancy) = SLE x ARO
- **ROSI** (Return on Security Investment) = (ALE before - ALE after - cost of control) / cost of control
- **Residual Risk** = Inherent Risk - Risk Reduction from Controls
- **Risk** = Likelihood x Impact (qualitative model)

A control is justified when ALE reduction over the control's lifetime exceeds total cost of ownership.

### Worked Example
- Asset value: $1,000,000
- Exposure factor: 30% per fire incident
- ARO: 0.05 (once every 20 years)
- SLE = $1,000,000 x 0.30 = $300,000
- ALE = $300,000 x 0.05 = $15,000/year
- Control cost: $5,000/year, reduces ARO to 0.01
- New ALE = $300,000 x 0.01 = $3,000/year
- Annual savings = $15,000 - $3,000 = $12,000
- ROSI = ($15,000 - $3,000 - $5,000) / $5,000 = 1.4 (140%) - control is justified.

## Risk Treatment Options

| Option | Description | Example |
|--------|-------------|---------|
| Mitigate (Reduce) | Implement controls to lower likelihood or impact | Deploy MFA, patch, segmentation |
| Transfer (Share) | Shift consequence to another party | Cyber insurance, outsourcing, contractual indemnity |
| Avoid | Stop the activity creating the risk | Discontinue a vulnerable feature or product line |
| Accept | Acknowledge and budget for residual risk | Sign-off by risk owner with documented rationale |

Risk acceptance must be by an authorized risk owner at appropriate seniority and recorded in the risk register.

## Governance Frameworks

| Framework | Origin | Purpose |
|-----------|--------|---------|
| COBIT 2019 | ISACA | IT governance, processes, performance management |
| NIST CSF 2.0 | NIST | Six functions: Govern, Identify, Protect, Detect, Respond, Recover |
| ISO/IEC 27001 | ISO/IEC | Information Security Management System (ISMS), certifiable |
| ISO/IEC 27002 | ISO/IEC | Code of practice / control catalog |
| ISO/IEC 27005 | ISO/IEC | Information security risk management |
| ISO/IEC 27014 | ISO/IEC | Governance of information security |
| ISO/IEC 27035 | ISO/IEC | Incident management |
| ISO 22301 | ISO | Business continuity management system |
| NIST SP 800-39 | NIST | Risk management approach (organization, mission, system) |
| NIST SP 800-37 | NIST | Risk Management Framework (RMF) lifecycle |
| NIST SP 800-30 | NIST | Risk assessment guide |
| NIST SP 800-53 | NIST | Security and privacy controls catalog |
| NIST SP 800-61 | NIST | Computer security incident handling guide |
| NIST SP 800-34 | NIST | Contingency planning (BCP/DR) |
| NIST SP 800-53A | NIST | Assessing security and privacy controls |
| FAIR | The Open Group | Quantitative risk analysis |
| OCTAVE / OCTAVE Allegro | CMU CERT | Asset-driven risk assessment |
| TOGAF | The Open Group | Enterprise architecture |
| SABSA | SABSA Institute | Security architecture |
| ITIL 4 | Axelos | IT service management |

## Three Lines of Defense (Three Lines Model)

| Line | Owner | Role |
|------|-------|------|
| First | Operational management | Owns and manages risk |
| Second | Risk management, security, compliance | Oversight, policy, monitoring |
| Third | Internal audit | Independent assurance |

External assurance (regulators, external audit) sits outside the model and provides additional oversight.

CISM holders typically sit in the second line; CISA holders typically sit in the third line.

## Governance Documents Hierarchy

| Document | Audience | Mandatory? | Detail |
|----------|----------|------------|--------|
| Policy | Senior management to all | Yes | High-level intent and direction |
| Standard | Engineering, operations | Yes | Specific, measurable requirements |
| Procedure | Operators | Yes | Step-by-step "how" |
| Guideline | Anyone | No | Recommendations |
| Baseline | Engineering, operations | Yes | Minimum acceptable configuration |

## Security Program Building Blocks

- People - org chart, RACI, awareness, training, role-based competency
- Process - SDLC integration, change management, vendor management, incident response
- Technology - controls, tooling, automation, platforms

A program out of balance (heavy on tech, weak on process) is a common CISM exam failure mode.

## Information Security Strategy: Inputs and Outputs

**Inputs:** business objectives, risk appetite, regulatory landscape, threat environment, current state, budget.

**Outputs:** strategic plan, target state, roadmap, metrics, governance structure, business case.

The strategy must originate from business objectives, not from threats or technology. Test answers that start with "align to business strategy" are usually correct.

## Incident Classification (Common Tiers)

| Severity | Definition | Example |
|----------|------------|---------|
| Critical / SEV-1 | Active business impact, regulatory or safety implications | Production-wide ransomware, large data breach |
| High / SEV-2 | Confirmed compromise of sensitive system, contained | Compromised privileged account |
| Medium / SEV-3 | Potential or limited compromise, contained | Phishing click on isolated user, no exfil |
| Low / SEV-4 | Suspicious activity, no confirmed impact | Failed brute force attempts, false positives |

Classification drives escalation, communication, and response intensity.

## Incident Response Phases (NIST SP 800-61)

1. **Preparation** - policy, runbooks, tooling, training, communication trees
2. **Detection and Analysis** - identify and classify the incident
3. **Containment, Eradication, and Recovery** - limit damage, remove threat, restore
4. **Post-Incident Activity** - lessons learned, evidence retention, improvements

ISO/IEC 27035 uses similar phases but groups differently:
1. Plan and Prepare
2. Detection and Reporting
3. Assessment and Decision
4. Responses
5. Lessons Learned

## BCP / DR Recovery Metrics

- **MTD** (Maximum Tolerable Downtime) - hard ceiling business cannot exceed
- **RTO** (Recovery Time Objective) - target restore time, must be less than MTD
- **RPO** (Recovery Point Objective) - acceptable data loss measured backward in time
- **WRT** (Work Recovery Time) - data validation and ramp-up after RTO
- **MTBF** (Mean Time Between Failures) - reliability of components
- **MTTR** (Mean Time to Repair) - time to restore a failed component
- **MTTD** (Mean Time to Detect) - detection performance metric
- **MTTC** (Mean Time to Contain) - containment performance metric

RTO + WRT must be less than or equal to MTD.

## Site Recovery Options

| Site | Cost | Setup Time | Notes |
|------|------|-----------|-------|
| Cold | Lowest | Weeks | Empty space, utilities only |
| Warm | Medium | Days | Partial equipment, no current data |
| Hot | High | Hours | Fully operational, current data |
| Mirrored | Highest | Real-time | Active-active, near-zero RTO/RPO |
| Reciprocal / Mutual aid | Lowest | Days | Agreement with another organization |
| Cloud DR (DRaaS) | Variable | Hours | Pay-as-you-go elasticity |

## Plan Test Types (Least to Most Disruptive)

1. **Read-through (Checklist)** - documentation review
2. **Walk-through (Tabletop)** - team discussion of scenario
3. **Simulation** - acting through scenario without real failover
4. **Parallel** - real failover to backup while production runs
5. **Full interruption** - real failover, production offline

CISM expects you to start with low-disruption tests and progress as the program matures.

## Metrics: KPI vs KRI vs KGI

- **KGI** (Key Goal Indicator) - did we achieve the goal? (Lagging.)
- **KPI** (Key Performance Indicator) - are processes performing well? (Leading or coincident.)
- **KRI** (Key Risk Indicator) - is risk emerging? (Leading risk signal.)

Examples:
- KGI: "100% of critical apps recovered within RTO during DR test."
- KPI: "Mean time to patch critical CVEs is < 7 days."
- KRI: "Phishing click rate exceeded 5% threshold."

## Awareness vs Training vs Education

| Term | Audience | Purpose |
|------|----------|---------|
| Awareness | All staff | What to do (phishing, posters, all-hands) |
| Training | Role-based | How to do (skill development) |
| Education | Specialists | Why to do (formal courses, conceptual understanding) |

## Privacy Regulations Touchpoints

- **GDPR** (EU) - 72-hour breach notification to supervisory authority, fines up to 4% global revenue
- **CCPA / CPRA** (California) - data subject rights, opt-out of sale
- **HIPAA / HITECH** (US healthcare) - 60-day breach notification, BAA
- **GLBA** (US financial) - Safeguards Rule, Privacy Rule
- **SOX** (US public companies) - financial reporting controls
- **PCI DSS** - contractual, not legal, 12 requirements
- **PIPEDA** (Canada), **LGPD** (Brazil), **PIPL** (China), **APPI** (Japan)

CISM does not test deep regulation specifics; it tests the manager's responsibility to know jurisdiction-specific obligations and to engage legal/privacy counsel.

## Vendor / Third-Party Risk Management

- Tiering by data sensitivity and access (Critical, High, Moderate, Low)
- Pre-engagement due diligence (questionnaires, SOC 2 Type 2 review, pen test reports)
- Contractual controls (DPA, BAA, MSA, SLA, right to audit, breach notification SLA, data return)
- Continuous monitoring (BitSight, SecurityScorecard, Black Kite)
- Offboarding (data return, certificate of destruction, account removal)
- Subprocessor inventory and chain-of-custody for outsourced data

## Business Case for Security

Security spend must be justified to business stakeholders. CISM-correct framing:

- Tie investment to specific risk reduction (in dollars, not technical jargon)
- Use ROSI calculations
- Show alignment to business objectives (revenue protection, regulatory avoidance, reputation, customer trust)
- Compare to industry benchmarks (e.g., 5 to 10% of IT spend)
- Map to maturity model targets (NIST CSF tier movement, CMMI level)

## Senior Leadership and Board Reporting

The CISO reports to the board on:
- Risk register trend (residual risk reduction)
- Compliance status (audits, regulatory)
- Major incidents and lessons learned
- Strategy progress vs roadmap
- Cyber insurance posture
- Comparative position to peers

Avoid technical detail at the board level; translate to business outcomes.

## Common Exam Triggers

| Stem language | Likely answer category |
|--------------|------------------------|
| "Best", "most effective", "primary" | Strategic / governance / business alignment |
| "FIRST step" | Establish scope, engage stakeholders, assess - rarely "implement" |
| "Greatest concern" | Misalignment with business or unmanaged risk |
| "Justify the investment" | Risk reduction tied to business value |
| "Mature program" | Process and metrics over technology |
| "Senior management responsibility" | Risk acceptance, strategy, accountability |
| "Steering committee" | Cross-functional governance |
| "Risk appetite" | Set by executive leadership, drives all treatment |
| "Compliance" | Identify obligation, then implement; never "compliance equals security" |

## Official Documentation Links

- **ISACA CISM page:** https://www.isaca.org/credentialing/cism
- **CISM Exam Content Outline:** https://www.isaca.org/credentialing/cism/cism-exam-content-outline
- **ISACA Code of Professional Ethics:** https://www.isaca.org/credentialing/code-of-professional-ethics
- **NIST publications:** https://csrc.nist.gov/publications
- **ISO standards catalog:** https://www.iso.org/standards.html

## CPE Categories

ISACA classifies CPE activities. Earn 120 CPE per 3-year cycle (20 minimum per year):

- ISACA professional education and meetings
- Non-ISACA professional education
- Self-study courses
- Vendor sales / marketing presentations (capped)
- Teaching / lecturing / presenting
- Publication of articles / books / monographs
- Exam item writing for ISACA
- Passing related professional exams
- Contributions to the profession

CPE submissions are subject to ISACA audit. Maintain documentation for 5 years.
