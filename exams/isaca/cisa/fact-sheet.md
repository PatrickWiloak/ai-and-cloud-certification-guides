---
last-updated: 2026-05-03
---

# CISA Fact Sheet

## Exam Logistics

| Item | Detail |
|------|--------|
| Exam Code | CISA |
| Format | Linear, fixed-form, computer-based |
| Duration | 4 hours (240 minutes) |
| Question Count | 150 multiple-choice |
| Passing Score | 450 / 800 (scaled) |
| Cost (USD) | $575 ISACA member / $760 non-member |
| Languages | English, Chinese (Simplified), French, German, Hebrew, Italian, Japanese, Korean, Spanish, Turkish |
| Delivery | PSI test centers OR online-proctored |
| Retake Wait | 1st: 30 days; 2nd-3rd: 90 days; 4th: 6 months. Max 4 attempts in 12 months. |
| Validity | 3-year CPE cycle |
| Maintenance | 120 CPE / 3 years (20 CPE/yr min) + $45/yr AMF (member) / $85/yr (non-member) |
| Application Window | 5 years from exam pass date to apply for certification |

## Domain Weights (Current Job Practice)

| Domain | Weight | Approx. Questions |
|--------|--------|-------------------|
| 1. Information System Auditing Process | 21% | ~32 |
| 2. Governance and Management of IT | 17% | ~26 |
| 3. IS Acquisition, Development, and Implementation | 12% | ~18 |
| 4. IS Operations and Business Resilience | 23% | ~35 |
| 5. Protection of Information Assets | 27% | ~40 |

## Eligibility and Substitutions

| Path | Requirement |
|------|-------------|
| Standard | 5 years of professional IS audit, control, or security work experience |
| 1 year IS experience OR non-IS audit | -1 year (max 1) |
| 2-year associate's degree | -1 year |
| 4-year bachelor's degree | -2 years |
| Master's degree (ISACA-accredited university) in IS or IT | -1 additional year (combined max 3) |
| 2 years full-time university instructor in related field | -1 year |
| Pass exam without experience | OK; 5-year window to verify experience |

## Audit Lifecycle (ITAF-Aligned)

The IS audit process per ITAF (Information Technology Audit Framework):

1. **Audit Planning** - audit charter, audit universe, risk assessment, annual audit plan
2. **Risk Assessment** - identify risks per auditable unit; prioritize engagements
3. **Engagement Planning** - scope, objectives, criteria, resources, timing
4. **Fieldwork / Execution** - control identification, walkthroughs, testing (compliance and substantive)
5. **Reporting** - findings, recommendations, management response, audit opinion
6. **Follow-up** - validate remediation; close findings or escalate

## Audit Standards Hierarchy (ITAF)

| Tier | Document | Authority |
|------|----------|-----------|
| Tier 1 | Standards | Mandatory; "must" or "shall" language |
| Tier 2 | Guidelines | Recommended; "should" language; explain how to apply standards |
| Tier 3 | Tools and Techniques | Optional; provide examples and templates |

CISA candidates must know that ITAF Standards are mandatory for ISACA members performing IS audits.

## Types of Audits

| Type | Purpose |
|------|---------|
| Financial audit | Validates financial statements |
| Operational audit | Evaluates effectiveness/efficiency of operations |
| Integrated audit | Combines financial + operational + IT |
| Compliance audit | Validates adherence to laws, regs, contracts |
| Forensic audit | Investigates fraud, litigation support |
| IS audit | Validates IT systems, controls, governance |
| SOC 1 (SSAE 18, ISAE 3402) | Controls relevant to financial reporting |
| SOC 2 (Type 1: design; Type 2: design + operating effectiveness) | Trust Services Criteria (security, availability, processing integrity, confidentiality, privacy) |
| SOC 3 | Public-facing summary of SOC 2 |
| Pre/post-implementation review | Before or after deploying a system |
| Administrative audit | Verifies operational policies/procedures |

## Types of Controls

| Classification | Examples |
|----------------|----------|
| **By Function** | Preventive (firewall, encryption), Detective (logs, IDS), Corrective (backup restore), Recovery (DR site), Deterrent (warning banner), Compensating (manager review for SoD) |
| **By Implementation** | Administrative (policy, training), Technical/Logical (ACL, encryption), Physical (locks, guards) |
| **By Origin** | General controls (org-wide: change mgmt, access mgmt, BCP) vs Application controls (input/process/output edits in a specific app) |
| **By Audit Approach** | Compliance testing (control exists and is followed) vs Substantive testing (data is accurate / transactions are valid) |

## Compliance vs Substantive Testing

- **Compliance testing** - tests whether controls operated as designed. Example: sample 25 user access requests to verify each has manager approval.
- **Substantive testing** - tests whether data is materially accurate. Example: recalculate interest on a sample of loans.

If compliance testing reveals control failures, expand substantive testing.

## Sampling Methods

| Method | Purpose |
|--------|---------|
| **Statistical sampling** | Each item has a known, non-zero probability of selection; results are mathematically projectable to the population |
| **Non-statistical (judgmental)** | Auditor selects based on judgment; not projectable |
| **Attribute sampling** | Tests rate of compliance with a control (yes/no exists). Used in compliance testing. |
| **Variable sampling** | Tests numerical accuracy (dollar amounts). Used in substantive testing. |
| **Stop-or-go sampling** | Halts when low error rate is confirmed early |
| **Discovery sampling** | Tests for at least one occurrence of a critical anomaly (e.g., fraud) |
| **Frequency-estimating** | Estimates how often an attribute occurs in the population |

Key sampling terms:
- **Population** - complete set of items
- **Sample size** - influenced by confidence level, expected error rate, tolerable error rate
- **Confidence coefficient (level)** - typically 90-95%
- **Tolerable error rate** - max acceptable rate of deviation
- **Expected error rate** - auditor's prior expectation
- **Sampling risk** - sample does not represent population

## Audit Evidence Hierarchy (Reliability)

From most to least reliable:

1. **Auditor's direct observation / re-performance** (most reliable)
2. **Externally generated** documents addressed to auditor (e.g., bank confirmations)
3. **Externally generated** documents in client's possession
4. **Internally generated** documents from a strong control environment
5. **Internally generated** documents from a weak control environment
6. **Oral evidence / management representation** (least reliable)

Evidence types: documentary, observational, analytical, oral, electronic (CAATs output), physical.

## Audit Evidence Quality Criteria

- **Sufficiency** - enough quantity to support conclusion
- **Reliability** - source and method of collection
- **Relevance** - directly addresses audit objective
- **Usefulness** - helps achieve the engagement objective

## Risk Formulas

- **Inherent Risk (IR)** - risk before considering controls
- **Control Risk (CR)** - risk a control fails to detect/prevent
- **Detection Risk (DR)** - risk auditor fails to detect a material misstatement
- **Audit Risk (AR)** = IR x CR x DR
- **Residual Risk** = Inherent Risk - effect of Controls

The auditor cannot directly influence IR or CR but can adjust DR by changing the nature, timing, and extent of testing. Lower acceptable AR -> more substantive testing -> larger sample sizes.

## Quantitative Risk (Same as CISSP)

- **SLE** = Asset Value x Exposure Factor
- **ALE** = SLE x ARO
- **Cost-benefit** = ALE before - ALE after - Annualized Cost of Safeguard
- **ROSI (Return on Security Investment)** = (ALE reduction - Cost) / Cost

## COBIT 2019 Core

COBIT 2019 separates **governance** (set direction, monitor) from **management** (plan, build, run, monitor).

### Governance Objectives Domain (5 objectives, EDM)
- **EDM** = Evaluate, Direct, and Monitor
- EDM01 Ensured Governance Framework Setting and Maintenance
- EDM02 Ensured Benefits Delivery
- EDM03 Ensured Risk Optimization
- EDM04 Ensured Resource Optimization
- EDM05 Ensured Stakeholder Engagement

### Management Objectives Domains (35 objectives, APO + BAI + DSS + MEA)
- **APO** (Align, Plan, and Organize) - 14 objectives
- **BAI** (Build, Acquire, and Implement) - 11 objectives
- **DSS** (Deliver, Service, and Support) - 6 objectives
- **MEA** (Monitor, Evaluate, and Assess) - 4 objectives

### COBIT 2019 Components (Enablers)
1. Processes
2. Organizational structures
3. Information flows
4. People, skills, and competencies
5. Culture, ethics, and behavior
6. Services, infrastructure, and applications
7. Principles, policies, and frameworks

### Six Governance System Principles
1. Provide stakeholder value
2. Holistic approach
3. Dynamic governance system
4. Governance distinct from management
5. Tailored to enterprise needs
6. End-to-end governance system

## Key Frameworks (Memorize)

| Framework | Origin | Focus |
|-----------|--------|-------|
| **COBIT 2019** | ISACA | IT governance and management |
| **ITAF** | ISACA | IS audit standards/guidelines |
| **ISO/IEC 27001** | ISO/IEC | ISMS (Information Security Management System) |
| **ISO/IEC 27002** | ISO/IEC | Security controls catalog (companion to 27001) |
| **ISO/IEC 27005** | ISO/IEC | Information security risk management |
| **ISO/IEC 27017** | ISO/IEC | Cloud security controls |
| **ISO/IEC 27018** | ISO/IEC | Cloud privacy (PII processors) |
| **ISO/IEC 27701** | ISO/IEC | PIMS (privacy management) |
| **ISO/IEC 38500** | ISO/IEC | Corporate governance of IT |
| **ISO/IEC 31000** | ISO/IEC | General risk management |
| **ITIL 4** | AXELOS | IT service management |
| **NIST CSF 2.0** | NIST | Cybersecurity framework (Govern, Identify, Protect, Detect, Respond, Recover) |
| **NIST SP 800-53** | NIST | Security and privacy controls (federal) |
| **NIST SP 800-37** | NIST | Risk Management Framework (RMF) |
| **NIST SP 800-30** | NIST | Risk assessment |
| **NIST SP 800-61** | NIST | Incident handling |
| **NIST SP 800-115** | NIST | Security testing and assessment |
| **NIST SP 800-88** | NIST | Media sanitization |
| **COSO ICIF** (2013) | COSO | Internal control over financial reporting |
| **COSO ERM** (2017) | COSO | Enterprise risk management |
| **TOGAF** | The Open Group | Enterprise architecture |
| **Zachman** | Zachman Inst. | Enterprise architecture taxonomy |
| **CMMI** | ISACA/SEI | Capability maturity (5 levels) |
| **PMBOK / PRINCE2** | PMI / AXELOS | Project management |
| **FAIR** | Open Group | Quantitative risk |

## ISO 27001 Annex A (2022 Revision)

The 93 controls in Annex A of ISO/IEC 27001:2022 are organized into 4 themes (down from 14 domains in the 2013 version):

| Theme | Controls | Examples |
|-------|----------|----------|
| **5. Organizational** | 37 | Policies, roles, threat intel, supplier relationships, incident management |
| **6. People** | 8 | Screening, terms of employment, awareness, disciplinary process |
| **7. Physical** | 14 | Physical perimeters, secure areas, equipment, clear desk |
| **8. Technological** | 34 | Access control, cryptography, secure development, network controls, monitoring |

## NIST SP 800-53 Rev. 5 Control Families (20)

AC, AT, AU, CA, CM, CP, IA, IR, MA, MP, PE, PL, PM, PS, PT, RA, SA, SC, SI, SR.

| Family | Name |
|--------|------|
| AC | Access Control |
| AT | Awareness and Training |
| AU | Audit and Accountability |
| CA | Assessment, Authorization, and Monitoring |
| CM | Configuration Management |
| CP | Contingency Planning |
| IA | Identification and Authentication |
| IR | Incident Response |
| MA | Maintenance |
| MP | Media Protection |
| PE | Physical and Environmental Protection |
| PL | Planning |
| PM | Program Management |
| PS | Personnel Security |
| PT | PII Processing and Transparency |
| RA | Risk Assessment |
| SA | System and Services Acquisition |
| SC | System and Communications Protection |
| SI | System and Information Integrity |
| SR | Supply Chain Risk Management |

## COSO Internal Control - Integrated Framework (5 Components)

1. **Control Environment** (tone at the top)
2. **Risk Assessment**
3. **Control Activities**
4. **Information and Communication**
5. **Monitoring Activities**

Mnemonic: CRIME (Control env, Risk, Info, Monitoring, control activitiEs).

## SDLC Phases (Generic Waterfall, CISA Domain 3)

1. Feasibility study (cost-benefit, risk, alternatives)
2. Requirements definition
3. Design (logical and physical)
4. Development (coding)
5. Testing (unit, integration, system, UAT, regression)
6. Implementation (deployment, conversion, training)
7. Post-implementation review (was the business case realized?)

## Testing Types

| Test | Purpose |
|------|---------|
| Unit | Smallest testable component |
| Integration | Modules together |
| System | Entire application |
| UAT (User Acceptance) | End-user validation against business requirements |
| Regression | New changes did not break existing functions |
| Performance / Stress / Load | Behavior under load |
| Volume | Large data quantities |
| Recovery | System recovery after failure |
| Security / Penetration | Vulnerabilities |
| Parallel | Old and new run side-by-side, compare results |
| Pilot | Subset of users on new system |
| Black box | No knowledge of internals |
| White box | Full knowledge |
| Gray box | Partial knowledge |

## Cutover (Implementation) Strategies

- **Direct (big-bang)** - cut over instantly; highest risk
- **Parallel** - old and new run together; safest, costliest
- **Phased** - module by module; balanced
- **Pilot** - one location/group first; localized risk

## BCP/DR Recovery Metrics (Same as CISSP)

- **RTO** - Max acceptable downtime
- **RPO** - Max acceptable data loss
- **MTD / MTPD** - Maximum Tolerable Downtime; RTO must be less
- **WRT** - Work Recovery Time (data restore + validation after RTO)
- **MTTR** - Mean Time to Repair
- **MTBF** - Mean Time Between Failures
- **SDO** - Service Delivery Objective (degraded service level during DR)
- **MTO** - Maximum Tolerable Outage in alternate process mode

RTO + WRT must fit within MTD.

## Recovery Sites

| Site | Cost | Setup Time | Notes |
|------|------|-----------|-------|
| Cold | Lowest | Weeks | Empty space, utilities only |
| Warm | Medium | Days | Partial equipment, no current data |
| Hot | High | Hours | Fully operational, current data |
| Mirrored / Mobile | Highest | Real-time | Active-active, near-zero RTO/RPO |
| Reciprocal/Mutual aid | Lowest | Days | Agreement with another org |
| Cloud DR (DRaaS) | Variable | Hours | Pay-as-you-go |

## Backup Schemes

| Scheme | What is backed up | Restore complexity |
|--------|-------------------|-------------------|
| Full | Everything | 1 tape |
| Incremental | Changes since last backup of any type | Last full + all incrementals |
| Differential | Changes since last full | Last full + last differential |
| Mirror | Real-time replica | Immediate |
| GFS (Grandfather-Father-Son) | Tiered rotation | Standard enterprise approach |

## DR Test Types (Least to Most Disruptive)

1. Read-through (checklist)
2. Walk-through (structured discussion)
3. Tabletop (scenario-based discussion)
4. Simulation (operational exercise; no real failover)
5. Parallel (alternate site processes in parallel with prod)
6. Full interruption (production fails over to alternate; highest risk, highest realism)

## Network Devices and OSI Layers

| Device | Layer | Function |
|--------|-------|----------|
| Hub | 1 | Repeats signal |
| Switch | 2 | Forwards frames by MAC |
| Router | 3 | Routes packets by IP |
| Firewall | 3-7 | Filters traffic |
| WAF | 7 | Filters HTTP(S) |
| IDS/IPS | 3-7 | Detects/prevents intrusions |
| Proxy | 7 | Acts as intermediary |
| Load balancer | 4 or 7 | Distributes load |

## Identity and Access Models

- **DAC** - owner-controlled (Windows ACLs)
- **MAC** - system-enforced labels (military, SELinux)
- **RBAC** - permissions via roles
- **ABAC** - attribute-based rules
- **RuBAC** - rule-based (firewalls)

## Cryptography Cheat Sheet

| Algorithm | Type | Key Length | Notes |
|-----------|------|-----------|-------|
| AES | Symmetric | 128/192/256 | NIST standard |
| 3DES | Symmetric | 168 (eff. 112) | Deprecated |
| RSA | Asymmetric | 2048+ | Key exchange + signing |
| ECC | Asymmetric | 256+ | Smaller keys, equivalent strength |
| DH/ECDH | Key agreement | 2048+ / 256+ | PFS when ephemeral |
| SHA-256 / SHA-3 | Hash | 256 | Current standards |
| MD5, SHA-1 | Hash | Deprecated | Collision-vulnerable |
| HMAC | MAC | Variable | Authenticated integrity |
| bcrypt, scrypt, Argon2, PBKDF2 | Password hash | Variable | Use for password storage |

## Common Audit Findings (Severity Levels)

| Severity | Description | Example |
|----------|-------------|---------|
| Critical / High | Could cause significant loss; immediate action | No segregation of duties in payments |
| Medium | Material weakness; remediate near-term | Quarterly access reviews missing |
| Low | Minor; remediate per management plan | Documentation gaps |
| Observation / Recommendation | Not a finding; improvement opportunity | Strengthen monitoring |

## Finding Structure (5 C's)

A well-written audit finding contains:

1. **Criteria** - the standard / requirement (policy, regulation, framework)
2. **Condition** - what was observed
3. **Cause** - why the condition exists
4. **Consequence** - the impact / risk
5. **Corrective action** (recommendation) - what management should do

## ISACA Code of Professional Ethics (Memorize)

ISACA members and certification holders shall:

1. Support the implementation of and encourage compliance with appropriate **standards, procedures, and controls**.
2. Perform their duties with **objectivity, due diligence, and professional care**, in accordance with professional standards.
3. Serve in the **interest of stakeholders** in a lawful manner, while maintaining high standards of conduct and not engaging in acts discreditable to the profession or association.
4. Maintain the **privacy and confidentiality** of information obtained in the course of duties unless disclosure is required by legal authority. Such information shall not be used for personal benefit nor released to inappropriate parties.
5. Maintain **competency** in their respective fields and undertake only those activities they can reasonably expect to complete with the necessary skills, knowledge, and competence.
6. Inform appropriate parties of the **results of work performed**, including the disclosure of all significant facts known to them that, if not disclosed, may distort the reporting of the results.
7. Support the **professional education** of stakeholders in enhancing their understanding of the governance and management of enterprise IT, including audit, control, and security.

The exam tests application of these canons. When in doubt, prioritize objectivity, confidentiality, and competence.

## Independence

- **Independence in fact** - actual freedom from bias
- **Independence in appearance** - perception of objectivity to outsiders

Independence applies to:
- The audit function (organizational placement, ideally reporting to audit committee or board)
- The individual auditor (no involvement in design/operation of audited area)

If independence is impaired, the auditor must disclose and may need to recuse.

## Audit Charter

A foundational document approved by the board / audit committee that:
- Establishes audit's authority and scope
- Confirms reporting line (audit committee)
- Establishes independence
- Defines responsibilities

The audit charter is the FIRST artifact for any internal audit function and is required by ITAF.

## CAATs (Computer-Assisted Audit Techniques)

Tools auditors use to test electronically:
- **Generalized audit software** (ACL, IDEA) - read, analyze, sample data
- **Test data / Integrated test facility (ITF)** - submit test transactions through production code
- **Parallel simulation** - re-perform processing with auditor's logic; compare to production
- **Embedded audit modules / SCARF** (Systems Control Audit Review File) - real-time monitoring of transactions
- **Snapshots** - capture state of data at points in time
- **Mapping / Tracing** - follow execution paths

CAATs increase efficiency and enable 100% population testing on large datasets.

## Privacy Regulations (Domain 5 / Domain 2 Overlap)

- **GDPR** (EU) - DPO, DPIA, 72-hour breach notification, $20M / 4% global turnover fines
- **CCPA / CPRA** (California) - opt-out, opt-in for under 16
- **HIPAA** (US) - PHI, BAA, breach notification 60 days
- **GLBA** (US financial) - Safeguards Rule, Privacy Rule
- **SOX** (US public companies) - Section 302/404, IT general controls
- **PCI DSS v4.0** (payment cards) - 12 requirements; contractual not legal
- **PIPEDA** (Canada), **LGPD** (Brazil), **POPIA** (South Africa), **APPI** (Japan)

## Official Documentation Links

- **ISACA CISA page:** https://www.isaca.org/credentialing/cisa
- **CISA exam content outline:** https://www.isaca.org/credentialing/cisa/cisa-exam-content-outline
- **ITAF:** https://www.isaca.org/resources/itaf
- **COBIT 2019:** https://www.isaca.org/resources/cobit
- **NIST publications:** https://csrc.nist.gov/publications
- **ISO standards catalog:** https://www.iso.org/standards.html
- **COSO:** https://www.coso.org

## CPE Categories (ISACA)

CPEs may be earned via: ISACA chapter meetings, conferences (ISACA, RSA, BlackHat), webinars, ISACA Journal articles, vendor training, college courses, teaching, exam authoring, mentoring, publication. The ISACA portal tracks CPEs in real time. Audit retention: 12 months past the reporting cycle.

## Quick Mnemonic Reference

- **5 C's of findings** - Criteria, Condition, Cause, Consequence, Corrective action
- **CRIME (COSO)** - Control env, Risk assessment, Info & communication, Monitoring, control activitiEs
- **EDM-APO-BAI-DSS-MEA (COBIT 2019)** - the 5 domains
- **PDCA (ISO 27001)** - Plan, Do, Check, Act
- **NIST CSF 2.0** - Govern, Identify, Protect, Detect, Respond, Recover (GIPDRR)
