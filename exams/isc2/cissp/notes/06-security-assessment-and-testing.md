# 06 - Security Assessment and Testing (Domain 6, 12%)

## Domain Overview

Domain 6 addresses how organizations test and evaluate security controls: vulnerability scanning, penetration testing, code review, audits, and overall assessment programs. It tests both technical understanding and the governance around independent assurance.

## Assessment vs Audit vs Test

| Term | Description |
|------|-------------|
| Test | Specific evaluation of a control (e.g., firewall rule test) |
| Assessment | Broader evaluation including tests, observations, document review |
| Audit | Formal, often third-party, independent evaluation against criteria, with findings |

Internal audits provide value but cannot substitute for external when independence is required.

## Test Strategy and Coverage

A mature security assessment program includes:
- Vulnerability assessment (cadence: weekly to monthly)
- Penetration testing (cadence: annual minimum, often quarterly for high-risk)
- Red team exercises (annual or per major release)
- Code review (continuous, every PR)
- Secure config compliance scanning (continuous)
- Tabletop exercises (annual)
- DR/BCP tests (annual to quarterly)
- Audit campaigns (annual SOC 2, annual ISO 27001 surveillance, etc.)

## Vulnerability Assessment

Identifies known vulnerabilities (CVEs) in systems and applications.

### Tools
- Nessus, Qualys, Rapid7 InsightVM, OpenVAS
- Cloud-native: AWS Inspector, Defender for Cloud, Wiz
- Container scanners: Trivy, Snyk Container, Anchore

### Scan types
- **Authenticated/credentialed** - more accurate, deeper visibility
- **Unauthenticated** - what attacker sees externally
- **Internal** - network insider perspective
- **External** - public internet perspective
- **Agent-based** - persistent, continuous
- **Network-based** - active probing

### Vulnerability scoring
- **CVSS** v3.1 / v4.0 - base, temporal, environmental scores; 0-10
- **EPSS** - exploit prediction probability
- **KEV catalog** (CISA) - known exploited vulnerabilities

### Patch management
- Inventory
- Risk-based prioritization
- Test in non-production
- Phased rollout
- Verification
- Exception tracking with compensating controls

## Penetration Testing

Authorized simulated attack to identify exploitable weaknesses.

### Methodologies
- **NIST SP 800-115** - Technical Guide to InfoSec Testing
- **PTES** - Penetration Testing Execution Standard
- **OSSTMM** - Open Source Security Testing Methodology Manual
- **OWASP Web Security Testing Guide** - web app focus
- **MITRE ATT&CK** - threat-informed technique catalog

### Phases
1. Planning and pre-engagement (rules of engagement, scope, NDA, get-out-of-jail letter)
2. Reconnaissance (passive then active)
3. Scanning and enumeration
4. Vulnerability identification
5. Exploitation
6. Post-exploitation (lateral movement, persistence, exfil simulation)
7. Reporting (findings, evidence, remediation guidance)
8. Cleanup

### Knowledge levels
- **Black box** (zero knowledge) - simulates external attacker
- **Gray box** (partial) - simulates compromised user or internal threat
- **White box / crystal box** (full knowledge) - architecture review with maximum efficiency

### Authorization
- Written authorization required (rules of engagement document)
- Defines scope, timing, methods allowed/forbidden, contact escalation, emergency stop conditions
- Without written auth = unauthorized access (potentially criminal)

### Red Team / Blue Team / Purple Team
- **Red team** - offensive, simulates adversary TTPs
- **Blue team** - defensive, monitors and responds
- **Purple team** - red and blue collaborate to improve detection and response
- **White team** - oversight and rules enforcement

## Code Review and Application Testing

### Static Application Security Testing (SAST)
- Source code analysis
- Examples: SonarQube, Veracode, Checkmarx, Snyk Code, Semgrep, GitHub CodeQL
- Pros: shifts left, finds OWASP-style issues
- Cons: false positives, doesn't catch runtime issues

### Dynamic Application Security Testing (DAST)
- Runtime testing of running app
- Examples: OWASP ZAP, Burp Suite, Acunetix, Veracode DAST
- Pros: catches runtime vulnerabilities
- Cons: requires deployed app, less coverage of code paths

### Interactive Application Security Testing (IAST)
- Combines SAST + DAST via agent in running app
- Examples: Contrast Security, Veracode IAST

### Runtime Application Self-Protection (RASP)
- Embedded protection that detects and blocks at runtime
- Examples: Contrast Protect, Imperva RASP

### Software Composition Analysis (SCA)
- Identifies open-source components and their CVEs/licenses
- Examples: Dependabot, Snyk, Mend (formerly WhiteSource), Sonatype Nexus
- Critical given OSS prevalence and supply chain attacks (Log4Shell, etc.)

### Manual Code Review
- Human review for logic flaws, business logic, design issues
- Critical for high-sensitivity code (auth, crypto, payments)
- Pair with checklists (OWASP code review guide)

### Fuzz Testing
- Inject malformed/random input to find crashes and unexpected behavior
- Coverage-guided fuzzers (AFL, libFuzzer)
- Effective for parsers, protocol handlers

### Mutation Testing
- Mutate code or input to evaluate test suite quality

### Misuse Case Testing
- Negative testing: explicitly test "what if user does the wrong thing"
- Complements use case testing

### Test Coverage Analysis
- Code coverage (line, branch, path)
- Functional coverage
- Security-specific coverage (e.g., AuthN/AuthZ paths tested)

### Interface Testing
- API contract testing
- Interface boundary security (input validation, output encoding)
- Postman, REST Assured, Pact

### Synthetic Transactions
- Scripted user actions to verify ongoing application behavior
- Used in monitoring and after deployments

### Real User Monitoring (RUM)
- Captures actual user experience
- Identifies issues affecting real users

## Breach and Attack Simulation (BAS)

- Continuous, automated simulation of attacker techniques
- Validates detection and response capabilities
- Examples: SafeBreach, AttackIQ, Cymulate

## Security Audits

### SOC Reports (AICPA SSAE 18 / ISAE 3402)
| Type | Audience | Detail |
|------|----------|--------|
| SOC 1 Type 1 | Financial auditors | Controls related to financial reporting; design point-in-time |
| SOC 1 Type 2 | Financial auditors | Same scope; over period (usually 6-12 months), tests operating effectiveness |
| SOC 2 Type 1 | Customers | Trust Services Criteria (Security, Availability, Processing Integrity, Confidentiality, Privacy); design only |
| SOC 2 Type 2 | Customers | Same; over period; the gold standard for SaaS providers |
| SOC 3 | Public | Summary of SOC 2; can be shared publicly |

### ISO Audits
- **ISO 27001** - ISMS certification with surveillance and recertification cycle
- **Stage 1** - documentation review
- **Stage 2** - implementation audit
- **Surveillance** - annual
- **Recertification** - every 3 years

### PCI DSS Audits
- **SAQ** (Self-Assessment Questionnaire) - smaller merchants
- **ROC** (Report on Compliance) - level 1 merchants, by QSA (Qualified Security Assessor)
- Annual cadence

### Internal Audits
- Independent function (separate from operations)
- Reports to audit committee or board
- Focus on governance and control adherence

### External / Independent Audits
- Required for regulatory and compliance frameworks
- Provide external assurance to stakeholders

## Log Review

- SIEM aggregation (Splunk, Sentinel, Elastic, Chronicle)
- Detection rules / correlation
- Alert tuning (reduce false positives)
- Review of:
  - Authentication logs (success/fail patterns)
  - Privilege escalation logs
  - Configuration change logs
  - Network logs
  - Application logs
  - System logs

### Log integrity
- Centralized collection (write-once or append-only)
- Time synchronization (NTP)
- Hashing or chained hashing for tamper-evidence
- Restricted access to log servers

## Security Process Data Collection

Metrics to collect for management reporting:
- Patch compliance percentage
- Mean time to detect (MTTD), respond (MTTR), recover
- Number and severity of incidents
- Vulnerability scan coverage and aging
- Phishing simulation click rate
- Training completion
- Audit findings open and aging
- Risk register trend
- Account access review completion
- Compliance posture by framework

## KRIs, KPIs, KGIs

- **KGI** (Key Goal Indicator) - did we achieve the strategic goal?
- **KPI** (Key Performance Indicator) - how well are we performing relative to objectives?
- **KRI** (Key Risk Indicator) - early warning of increasing risk

Example: Goal = reduce breach risk. KPI = patch SLA compliance %. KRI = unmitigated critical vulnerabilities count.

## Continuous Monitoring

- NIST SP 800-137: Information Security Continuous Monitoring (ISCM)
- Continuous control monitoring (CCM)
- Automated where possible
- Risk-based prioritization

## Common Exam Pitfalls

- Treating vuln scan as substitute for pen test
- Performing pen test without written authorization
- Choosing internal audit when external/independent required
- Mixing SAST and DAST capabilities
- Selecting wrong SOC report type
- Forgetting that audit independence is foundational
- Ignoring service organization audits when relying on third parties

## Quick Reference: Test Type to Use Case

| Need | Tool/Method |
|------|-------------|
| Find known CVEs | Vulnerability scanner |
| Find exploitable paths | Penetration test |
| Find code-level flaws | SAST + manual review |
| Find runtime app flaws | DAST |
| Find OSS vulns | SCA |
| Find dependency licenses | SCA |
| Validate detection works | Red team / BAS |
| Find DR weaknesses | DR test |
| Validate IR readiness | Tabletop |
| Find process compliance gaps | Audit |
