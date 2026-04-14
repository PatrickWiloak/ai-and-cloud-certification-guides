# CISSP Real-World Scenarios

These scenarios mimic the judgment-under-uncertainty style of CISSP questions. Each one tests both knowledge and CISSP mindset (manager perspective, root cause, life safety).

## Scenario 1: Newly Discovered Critical Vulnerability

**Context:** A senior engineer informs you that a critical RCE vulnerability (CVSS 9.8) was just disclosed for the version of an open-source library used in your customer-facing payment portal. Patches will not be available from the vendor for at least 7 days. Active exploitation is reported in the wild.

**Q:** What is the FIRST action a security manager should take?

**A:** Convene the change advisory board / incident response team and assess scope and risk. The manager's first action is to gather facts (which systems use this library, which are externally exposed, what compensating controls exist) and engage decision authority. Patching first without scoping risks missing affected systems; disconnecting the system without authorization may breach SLAs. The first step in a security manager mindset is risk assessment and stakeholder engagement, not technical action.

**Follow-up:** What compensating controls might be implemented while awaiting patches?
- WAF rules to block known exploit signatures
- Increased logging and monitoring on affected endpoints
- Network segmentation to limit blast radius
- Geofencing or IP allowlisting if business-acceptable
- Temporary feature flags to disable affected functionality

## Scenario 2: Departing Employee with Privileged Access

**Context:** A senior systems administrator with domain admin privileges resigned this morning, giving 2 weeks notice. The employee has access to production AD, payroll systems, and the secrets vault.

**Q1:** What is the FIRST step?

**A1:** Engage HR and legal to confirm the appropriate offboarding procedure for a privileged user. The CISSP-correct answer is procedural, not technical: confirm policy, document decisions. Acting unilaterally to revoke access could violate HR policy or create legal exposure if the employee disputes termination terms.

**Q2:** Given the privileged access level, should access be revoked immediately or maintained through the notice period?

**A2:** This is a risk-based decision driven by HR policy and the employee's situation. Best practice for high-privilege departures is to:
- Immediately remove standing privileged access; transition to monitored, just-in-time access for the notice period
- Increase monitoring on remaining accounts
- Document a complete inventory of all access (including SaaS, cloud, secrets, GitHub keys)
- Plan credential and key rotations effective on the departure date

**Q3:** What controls should be permanent improvements after this incident?

**A3:** Standing privileged access is the root cause weakness. Implement:
- PAM with vaulted credentials and session recording
- Just-in-time elevation requiring ticket/approval
- Periodic access reviews (UARs)
- Mandatory vacation and job rotation policies for privileged roles
- Two-person integrity for high-impact actions (production changes, key generation)

## Scenario 3: BYOD Phishing Compromise

**Context:** An executive's personal phone, used to access corporate email under a BYOD policy, was compromised by a phishing attack. The attacker accessed her mailbox and exfiltrated 3 months of emails before detection.

**Q1:** What is the immediate priority?

**A1:** Contain the breach: revoke all sessions on the user's account, force password reset, revoke OAuth tokens, remove the device's MDM enrollment. Then assess what was exfiltrated (sensitive data inventory) for breach notification obligations.

**Q2:** What policy gaps does this incident reveal?

**A2:**
- BYOD policy may lack adequate controls (e.g., no MDM enforcement, no required device encryption, no mobile threat defense)
- MFA may have been bypassed via session token theft
- Conditional access policies may not require compliant device for mailbox access
- Email DLP and external sharing controls may be insufficient

**Q3:** What is the breach notification consideration if customer PII was in the emails?

**A3:** Engage legal and privacy counsel immediately. Notification timelines vary:
- GDPR: 72 hours to supervisory authority if EU resident data
- HIPAA: 60 days for covered entities (in US healthcare)
- US state breach laws: vary by state, often "without unreasonable delay"
- Contractual: review customer contracts for negotiated notification windows
The legal team owns notification timelines; security advises on technical scope and forensics.

## Scenario 4: Cloud Misconfiguration Causing Public Data Exposure

**Context:** A misconfigured AWS S3 bucket containing customer financial records was publicly accessible for 18 days. Discovery came via a security researcher's responsible disclosure.

**Q1:** What is the appropriate first response to the disclosure?

**A1:** Acknowledge the report, validate the finding, and immediately remediate (make the bucket private, audit access logs). Thank the researcher; engage legal on bug bounty / safe harbor processes. Avoid threatening or dismissive responses to security researchers.

**Q2:** What forensic data should be collected before changes?

**A2:** Preserve:
- S3 access logs for the entire exposure window
- CloudTrail records of bucket ACL/policy changes
- Any web crawler indexing evidence (Google cache, archive.org)
- IAM and configuration history for the bucket and parent account
- Deploy a CloudFront access log review for any cache fronting

This evidence supports breach notification scope determination and any potential litigation.

**Q3:** What systemic controls should be implemented?

**A3:**
- Enable Amazon S3 Block Public Access at the account level
- Implement CSPM (Defender for Cloud, AWS Security Hub, Wiz, Prisma) with continuous compliance checks
- IaC scanning in CI/CD with policy-as-code (OPA, Checkov, tfsec)
- Service Control Policies preventing public bucket creation
- Mandatory peer review and approval for storage configuration changes
- Quarterly access review of all storage with sensitive data labels

## Scenario 5: Acquisition Due Diligence

**Context:** Your company is acquiring a smaller competitor. As CISO, you have 30 days for security due diligence before close.

**Q1:** What are your top priorities?

**A1:**
- Inventory of customer data held (volume, sensitivity, jurisdictions)
- Active or recent security incidents and breach disclosures
- Compliance status (SOC 2, ISO 27001, PCI-DSS, GDPR posture)
- Outstanding security risks and known unpatched vulnerabilities
- Legal liabilities and pending litigation related to security
- Open-source license compliance
- M&A integration risks (network connection, identity merge, IT consolidation)
- Insurance coverage (cyber liability)
- Vendor and supply chain risks

**Q2:** What constitutes a "deal-breaker" finding?

**A2:** Material findings such as:
- Active, undisclosed breach
- Pending regulatory action (GDPR, HHS OCR, etc.)
- Critical vulnerability patterns indicating systemic neglect
- Material misrepresentation in seller's disclosures
- Hidden contractual obligations creating major remediation cost

These do not always kill the deal but should result in price adjustment, escrow, or specific representations and warranties in the purchase agreement.

**Q3:** What is the day-1 security integration plan?

**A3:** Defer network interconnection until basic posture validation. Establish:
- Separate identity domain merged later via federation, not immediate AD trust
- Defined zero-trust network segments separating acquired environment
- Common SIEM ingestion to centralize visibility
- Day-1 communication to all employees on incident reporting and acceptable use
- Inventory all admin credentials and rotate

## Scenario 6: Ransomware in Manufacturing OT Environment

**Context:** A ransomware variant has infected the IT network of a manufacturing facility. The OT network is air-gapped but technician laptops cross between zones.

**Q1:** What is the FIRST priority?

**A1:** Personnel safety. Confirm OT systems controlling physical processes are not affected, and if there is any potential for safety impact (chemical, mechanical, electrical), engage safety teams immediately to consider safe shutdown procedures. Life safety always precedes asset preservation in CISSP mindset.

**Q2:** Should the IT network be isolated by disconnecting the OT bridge?

**A2:** Yes, immediately. Isolate the IT-OT boundary to prevent lateral movement. Validate that any technician laptops that crossed zones recently are quarantined for forensic examination. The Purdue model and IEC 62443 emphasize strict zone separation; an air-gapped OT network is meaningless if the bridge is unmanaged.

**Q3:** Should the ransom be paid?

**A3:** Generally no, but it is a business decision involving:
- Legal counsel (sanctions concerns - OFAC may prohibit payment to designated groups)
- Insurance carrier (coverage and approval)
- Law enforcement engagement (FBI in US)
- Restorability from backups (offsite, immutable, tested)
- Operational impact and ability to operate manually

Security recommends; senior leadership decides. Pre-incident playbooks should answer this in advance.

## Scenario 7: Insider Threat - Suspected IP Theft

**Context:** HR informs you that a research scientist accepted a job at a competitor. Audit logs show the scientist downloaded 2 TB of proprietary research data over the past 30 days, much from outside her project scope.

**Q1:** What is the immediate course of action?

**A1:** Engage HR, legal, and senior leadership before any action visible to the employee. This is potentially a litigation matter; preserving evidence and following lawful process is critical. Do not directly confront the employee; do not unilaterally disable access in a way that tips off the employee until investigative path is decided.

**Q2:** What evidence should be preserved?

**A2:**
- Forensic image of the employee's workstation (if accessible without alerting)
- Mailbox archive
- File access logs from DLP, file servers, cloud storage
- VPN, badge, and physical access logs
- Email and chat for any external coordination
- Cloud sync records (OneDrive, Google Drive, Dropbox, GitHub)
- USB and removable media records (DLP, MDM, Group Policy)
- Print spooler logs

Maintain chain of custody throughout; expect potential discovery in litigation.

**Q3:** What policy/control improvements does this surface?

**A3:**
- Insider risk management (Microsoft Purview IRM or equivalent)
- DLP for high-sensitivity research data with adaptive enforcement on departing-employee status
- Periodic UEBA review
- Pre-employment NDA and exit interviews acknowledging IP retention obligations
- Need-to-know enforcement on data repositories (least privilege)
- Departure protocol that includes 30-day pre-departure access review

## Scenario 8: Third-Party Vendor Breach

**Context:** A SaaS vendor that handles your HR data notifies you of a security incident. They claim limited customer impact and are still investigating.

**Q1:** What contractual rights should you exercise?

**A1:**
- Right to receive timely breach notifications (per data processing agreement)
- Right to detailed forensic reporting and root cause
- Right to audit (or at least review independent audit reports such as SOC 2 Type 2)
- Right to terminate the contract if breach materially affects services
- Right to require specific remediations
- Right to receive a list of impacted records
- Right to financial remedies (typically capped per contract)

**Q2:** What internal actions should be taken?

**A2:**
- Convene incident response team
- Notify legal, privacy, compliance, communications, and senior leadership
- Begin scoping: what HR data was held by this vendor, for what employees, in what format
- Determine breach notification obligations (employees, regulators, contracts with affected parties)
- Review your own logs for any indicators of compromise originating from the vendor
- Consider rotating any shared credentials, API keys, OAuth grants
- Update incident timeline as vendor provides new information

**Q3:** How should this incident influence vendor risk management going forward?

**A3:**
- Reassess this vendor's risk tier; may require enhanced monitoring or replacement
- Review portfolio of similar vendors for lateral risk
- Strengthen vendor security questionnaire and require evidence (SOC 2, pen test reports)
- Add or strengthen contractual breach notification SLAs
- Consider continuous third-party risk monitoring tools (SecurityScorecard, BitSight, Black Kite)
- Ensure data minimization: do vendors need all the data they hold?

## Scenario 9: New Privacy Regulation Impacting Operations

**Context:** A new state privacy law passes giving consumers rights similar to GDPR (access, deletion, opt-out of sale). Your company must comply within 18 months and operates in that state.

**Q1:** What is the FIRST step?

**A1:** Conduct a data inventory and gap assessment. You cannot comply with rules over data you do not inventory. The CISSP-correct first step in any new compliance regime is scoping and assessment, not implementing controls.

**Q2:** What cross-functional team is required?

**A2:**
- Privacy / DPO function (lead)
- Legal counsel
- IT/Security (data discovery, deletion mechanisms, access controls)
- HR (employee data flows)
- Marketing and Sales (consent, opt-outs)
- Customer service (handling DSAR requests)
- Engineering (build deletion/access APIs)
- Vendor management (subprocessor compliance)

**Q3:** What technical capabilities will be required?

**A3:**
- Data discovery and classification across all stores (structured and unstructured)
- Subject access request (DSAR) workflow with identity verification
- Right-to-deletion mechanisms (and associated retention exceptions)
- Consent management platform for opt-outs
- Audit logging of all privacy-related actions
- Data lineage tracking (where did this data originate, where has it flowed)
- Privacy by design in new system development

## Scenario 10: Disaster Recovery Test Reveals Failures

**Context:** During a parallel DR test, three out of ten critical applications failed to recover within their stated RTOs. The CIO asks for your recommendations.

**Q1:** Should the BCP be considered failed?

**A1:** No - the test succeeded in its primary purpose: identifying gaps before a real disaster. The DR/BCP is a continuous improvement program, not a binary pass/fail. The failure to detect these gaps would be the worse outcome.

**Q2:** What are the next steps?

**A2:**
- Root cause analysis on each failed application
- Update the BCP/DRP with corrective actions, owners, and target dates
- Reassess RTOs and RPOs against actual recovery capability; either fix the recovery or revise the stated objective with business buy-in
- Schedule retest after remediation
- Communicate findings and remediation plan to senior leadership and the board
- Update the BIA if business priorities shifted

**Q3:** What test type might catch issues that the parallel test missed?

**A3:** A full interruption test (failing over completely while production is offline) is the most realistic but also the most disruptive. Tabletop exercises focused on decision-making under pressure can also reveal process and personnel gaps not visible in technical tests. In CISSP context, the order of test types from least to most disruptive is: read-through, walk-through, tabletop, simulation, parallel, full interruption.

## Scenario 11: Engineering Team Wants to Adopt a New Open-Source Library

**Context:** An engineering team requests adoption of a popular open-source library for a new feature. The library has 50,000 GitHub stars but minimal corporate backing.

**Q1:** What due diligence is required?

**A1:**
- License analysis (MIT, Apache, GPL, AGPL?) with legal team review
- Security analysis: known CVEs, dependency tree, maintainer responsiveness to issues
- Code quality and maintenance signals: commit frequency, contributor diversity, release cadence
- Functional alternatives: are there commercial or more-maintained options?
- Operational fit: does this match the supported runtime, language version, framework?
- Update path: how easy is it to switch if abandoned?

**Q2:** What ongoing controls should govern OSS use?

**A2:**
- Software composition analysis (SCA) in CI/CD (Snyk, Dependabot, Mend, Sonatype)
- SBOM generation and storage
- Internal policy on OSS licenses (allowed, conditional, prohibited)
- Patching SLA tied to vulnerability severity
- Mirror critical OSS in internal artifact repository (Artifactory, Nexus) to mitigate supply chain attacks
- Periodic re-assessment of OSS dependencies (annual or risk-triggered)

## Scenario 12: Board Asks "Are We Secure?"

**Context:** During a board meeting, a director asks the CISO directly: "Are we secure?"

**Q1:** What is the right answer framing?

**A1:** "Security is not a binary state; it is a continuous risk management discipline." The CISSP-mature answer reframes the question:
- We maintain a risk register prioritized by impact and likelihood
- Our top 5 risks are X, Y, Z (sized in business terms)
- We have invested in A, B, C controls reducing those risks
- Our residual risk in each domain is at or below the appetite the board set
- We test our defenses regularly via X (pen test, red team, IR drills)
- We benchmark against frameworks (NIST CSF, ISO 27001) at maturity level Y
- Going forward, we are investing in W to address rising threats

**Q2:** What metrics best communicate security posture to the board?

**A2:** Business-aligned metrics, not technical metrics:
- Risk register trend (residual risk reduction over time)
- Mean time to detect / contain / recover from incidents
- Coverage and maturity by NIST CSF function
- Patch SLA compliance
- Phishing simulation click rate trend
- Audit and regulatory finding closure rate
- Cyber insurance coverage adequacy and premium trend
- Third-party risk distribution
- Cost per breach avoided (where modelable)

Avoid feeding the board firewall packet counts, EPS metrics, or tool-by-tool dashboards - these communicate volume, not value.
