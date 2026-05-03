# CompTIA CySA+ (CS0-003) Study Plan

## 8-Week Comprehensive Study Schedule

This plan assumes 2-3 hours per day, 5-6 days per week, with hands-on lab practice woven through every domain. CySA+ is heavily tool-and-output focused, so reading alone is not enough.

### Week 1: Foundations and Security Operations Part 1

#### Day 1-2: Architecture and Telemetry Sources
- [ ] System and network architecture - log collection points, sensors, taps
- [ ] Operating system telemetry - Windows EventIDs, Linux audit logs, sysmon
- [ ] Cloud telemetry - CloudTrail, VPC Flow Logs, Azure Activity, GCP Audit
- [ ] Application logs - web servers, databases, identity providers
- [ ] Review Notes: `01-security-operations.md`

#### Day 3-4: Threat Actors and Methodology Frameworks
- [ ] Threat actor types - nation-state, APT, organized crime, insider, hacktivist
- [ ] MITRE ATT&CK Enterprise matrix - 14 tactics, common techniques
- [ ] Cyber Kill Chain (Lockheed Martin) - 7 phases
- [ ] Diamond Model - adversary, capability, infrastructure, victim
- [ ] OWASP Top 10 web app risks
- [ ] Review Notes: `01-security-operations.md`

#### Day 5-6: IoCs and IoAs
- [ ] Network IoCs - IPs, domains, beaconing, DGA, JA3 fingerprints
- [ ] Host IoCs - hashes, registry, processes, services, scheduled tasks
- [ ] Behavioral IoAs - impossible travel, log clearing, mass file access
- [ ] STIX/TAXII threat intelligence formats
- [ ] Hands-on: walk through ATT&CK Navigator, build a layer
- [ ] Review Notes: `01-security-operations.md`

#### Day 7: Week 1 Review
- [ ] Practice questions on Domain 1 part 1 (target: 60%+)
- [ ] Memorize MITRE ATT&CK tactics in order
- [ ] Memorize top 20 ATT&CK technique IDs

### Week 2: Security Operations Part 2 - Tools and Hunting

#### Day 8-9: Log Analysis Deep Dive
- [ ] Windows EventIDs - 4624, 4625, 4688, 4697, 4720, 4768, 4769, 1102
- [ ] Linux logs - auth.log, audit.log, journalctl, last/lastb
- [ ] Web server logs - access logs, status codes, user agents
- [ ] DNS and proxy logs - query patterns, blocked domains
- [ ] Hands-on: parse Apache and IIS logs, find injection attempts
- [ ] Review Notes: `01-security-operations.md`

#### Day 10-11: SIEM and Network Analysis
- [ ] SIEM concepts - normalization, correlation, enrichment
- [ ] Splunk SPL basics - search, stats, eval, lookup
- [ ] Sentinel KQL basics - where, summarize, project, join
- [ ] Wireshark display filters and packet inspection
- [ ] Zeek logs - conn, http, dns, ssl, files
- [ ] tcpdump capture and reading
- [ ] Hands-on: complete TryHackMe SOC Level 1 SIEM rooms
- [ ] Review Notes: `01-security-operations.md`

#### Day 12-13: Threat Intelligence and Threat Hunting
- [ ] Threat intel types - tactical, operational, strategic
- [ ] Sources - OSINT, ISACs, commercial feeds, government, dark web
- [ ] Threat hunting hypothesis-driven model
- [ ] Pyramid of Pain - hashes (easy) -> TTPs (hardest for adversary)
- [ ] Sigma rules - structure, conversion to vendor formats
- [ ] Hands-on: write Sigma rule for PowerShell encoded command
- [ ] Review Notes: `01-security-operations.md`

#### Day 14: Week 2 Review
- [ ] Practice questions on Domain 1 part 2 (target: 65%+)
- [ ] Practice reading Splunk and KQL queries
- [ ] Practice reading Snort/Suricata signatures

### Week 3: Vulnerability Management Part 1

#### Day 15-16: Asset Discovery and Scan Types
- [ ] Asset inventory - active, passive, agent-based discovery
- [ ] Scanning types - unauthenticated, authenticated, agent, passive
- [ ] Web app scanning - DAST vs SAST vs IAST
- [ ] Container scanning - Trivy, Grype, image SBOM
- [ ] IaC scanning - Checkov, tfsec, Terrascan
- [ ] Mobile app scanning - MobSF, OWASP MASVS
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 17-18: Vulnerability Scanning Tools
- [ ] Nessus / Tenable.io - scan policies, plugin families
- [ ] Qualys VMDR - assets, vuln dashboards
- [ ] OpenVAS / Greenbone - free open source option
- [ ] Nmap - port scan, service detection, NSE scripts
- [ ] Nikto - web server scanner
- [ ] Burp Suite, OWASP ZAP - web app proxies
- [ ] Hands-on: run Nessus essentials against a lab VM
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 19-20: CVSS and Prioritization
- [ ] CVSS v3.1 base metrics - AV, AC, PR, UI, S, C, I, A
- [ ] CVSS v4.0 changes - new metric groups
- [ ] CVE, CWE, CAPEC distinctions
- [ ] EPSS - exploit prediction scoring
- [ ] CISA KEV catalog - must-patch vulnerabilities
- [ ] SSVC - stakeholder-specific decision tree
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 21: Week 3 Review
- [ ] Practice questions on Domain 2 part 1 (target: 65%+)
- [ ] Practice CVSS calculator with sample CVEs
- [ ] Match CWEs to common attack types

### Week 4: Vulnerability Management Part 2

#### Day 22-23: Common Vulnerabilities to Recognize
- [ ] Web - SQLi, XSS, CSRF, SSRF, IDOR, XXE, path traversal
- [ ] Memory - buffer overflow, use-after-free, race condition
- [ ] Crypto - weak ciphers, key reuse, padding oracles
- [ ] Auth - broken auth, session fixation, weak passwords
- [ ] Cloud - misconfigured S3 buckets, exposed credentials, SSRF to metadata
- [ ] Network - default creds, weak SNMP, exposed admin panels
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 24-25: Validation and Controls
- [ ] False positive vs true positive validation
- [ ] Manual verification techniques (Burp, curl, manual review)
- [ ] Compensating controls when patching is not possible
- [ ] Patching strategies - test, stage, rollout, rollback
- [ ] Configuration management - hardening guides (CIS Benchmarks)
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 26-27: Risk Response and Vulnerability Lifecycle
- [ ] Risk responses - accept, transfer, mitigate, avoid
- [ ] Risk acceptance documentation and approval
- [ ] Exception management and exception expiration
- [ ] SLA tracking by severity tier
- [ ] Patch tuesday and emergency patch processes
- [ ] Hands-on: build a vuln remediation tracker spreadsheet
- [ ] Review Notes: `02-vulnerability-management.md`

#### Day 28: Week 4 Review
- [ ] Practice questions on Domain 2 part 2 (target: 70%+)
- [ ] Practice prioritization scenarios
- [ ] Review patch management edge cases

### Week 5: Incident Response and Management

#### Day 29-30: IR Lifecycle and Preparation
- [ ] NIST SP 800-61 four phases
- [ ] SANS PICERL six phases
- [ ] Incident classification and severity
- [ ] IRP, runbooks, playbooks
- [ ] Communication plans, escalation matrix, war room
- [ ] Tabletop exercises and red team drills
- [ ] Review Notes: `03-incident-response.md`

#### Day 31-32: Detection, Analysis, Containment
- [ ] Indicator validation and incident scoping
- [ ] Triage prioritization (CIA impact, blast radius)
- [ ] Short-term vs long-term containment
- [ ] Network isolation, account disable, segmentation
- [ ] Eradication - malware removal, account purge, patching
- [ ] Recovery - rebuild, restore from backup, monitoring
- [ ] Review Notes: `03-incident-response.md`

#### Day 33-34: Forensics and Evidence Handling
- [ ] Order of volatility (RFC 3227)
- [ ] Chain of custody, evidence labeling, hash verification
- [ ] Forensic imaging - dd, dcfldd, FTK Imager
- [ ] Memory acquisition - Volatility, LiME, WinPMEM
- [ ] Disk analysis - Autopsy, Sleuth Kit, EnCase
- [ ] Timeline analysis - Plaso, log2timeline
- [ ] Hands-on: complete a CyberDefenders.org case
- [ ] Review Notes: `03-incident-response.md`

#### Day 35: Week 5 Review
- [ ] Practice questions on Domain 3 (target: 70%+)
- [ ] Walk through a tabletop exercise scenario
- [ ] Review legal hold and law enforcement coordination

### Week 6: Reporting and Communication

#### Day 36-37: Vulnerability Reports
- [ ] Technical reports - finding, evidence, impact, recommendation
- [ ] Executive summaries - business risk language
- [ ] Trending - vuln counts over time, by severity, by team
- [ ] SLA compliance reporting
- [ ] Risk register and acceptance tracking
- [ ] Review Notes: `04-reporting-communication.md`

#### Day 38-39: Incident Reports and Post-Mortems
- [ ] Incident report sections - summary, timeline, impact, RCA, lessons
- [ ] Blameless post-mortems
- [ ] After-action reviews and improvement actions
- [ ] Regulatory notifications - GDPR 72 hours, HIPAA 60 days, state laws
- [ ] Customer notifications and PR coordination
- [ ] Review Notes: `04-reporting-communication.md`

#### Day 40-41: Metrics, KPIs, and Stakeholders
- [ ] MTTD, MTTR, MTTA, dwell time
- [ ] False positive rate, alert volume, escalation rate
- [ ] Vulnerability backlog, remediation rate
- [ ] Executive dashboards vs SOC dashboards
- [ ] Stakeholder mapping - SOC, IR, legal, exec, board, regulators
- [ ] Ticketing systems - Jira, ServiceNow, TheHive
- [ ] Review Notes: `04-reporting-communication.md`

#### Day 42: Week 6 Review
- [ ] Practice questions on Domain 4 (target: 75%+)
- [ ] Draft a sample incident report from a scenario
- [ ] Compare regulatory notification windows side by side

### Week 7: Integration and Practice

#### Day 43-44: Full Practice Exam 1
- [ ] Take a timed full-length practice exam (165 minutes)
- [ ] Review every incorrect answer
- [ ] Identify weakest 2 domains
- [ ] Target score: 75%+

#### Day 45-46: Weak Area Deep Dive
- [ ] Re-read notes for weak domains
- [ ] Hands-on labs in weak areas (LetsDefend, BTLO, TryHackMe)
- [ ] Re-read fact sheet
- [ ] Practice domain-specific question sets

#### Day 47-48: Performance-Based Question Practice
- [ ] PBQ types - log analysis, packet analysis, configuration matching
- [ ] Practice reading Splunk SPL output
- [ ] Practice reading PCAPs in Wireshark
- [ ] Practice CVSS scoring drag-and-drop
- [ ] Practice ATT&CK technique mapping
- [ ] Review common PBQ formats

#### Day 49: Week 7 Review
- [ ] Take a second full practice exam
- [ ] Target score: 80%+
- [ ] Final weak area review

### Week 8: Final Preparation

#### Day 50-51: Tool and Output Recognition
- [ ] Recognize Nessus output by section structure
- [ ] Recognize Splunk vs KQL syntax
- [ ] Recognize Snort/Suricata rule fields
- [ ] Recognize Sigma rule YAML
- [ ] Recognize Wireshark interface elements
- [ ] Recognize Volatility plugin output

#### Day 52-53: Frameworks and Acronyms
- [ ] MITRE ATT&CK 14 tactics in order
- [ ] NIST 800-61 four phases
- [ ] SANS PICERL six phases
- [ ] CVSS metric groups
- [ ] OWASP Top 10 current list
- [ ] All acronyms from fact sheet

#### Day 54: Final Practice Exam
- [ ] Third full practice exam, timed
- [ ] Target: 85%+
- [ ] Light review only

#### Day 55: Exam Day
- [ ] Light review of fact sheet
- [ ] Review key acronyms and ATT&CK IDs
- [ ] Get exam logistics confirmed
- [ ] Rest

## Daily Study Routine (2-3 hours/day)

### Recommended Schedule
1. **30 minutes**: Read study notes and review concepts
2. **60 minutes**: Hands-on lab work (TryHackMe, LetsDefend, BTLO)
3. **45 minutes**: Practice questions and scenario walkthroughs
4. **15 minutes**: Review missed answers, update notes

## Practice Exam Strategy

### Target Scores by Week
- [ ] Week 2: 60%+ on Domain 1 questions
- [ ] Week 4: 65%+ on Domain 1+2 mixed
- [ ] Week 5: 70%+ on Domain 1+2+3 mixed
- [ ] Week 6: 75%+ on full mixed practice
- [ ] Week 7: 80%+ on full timed practice exams
- [ ] Week 8: 85%+ consistently

## Hands-On Lab Roadmap

### Free Platforms
- **TryHackMe SOC Level 1** - SIEM, log analysis, threat intel
- **TryHackMe SOC Level 2** - DFIR, threat hunting, malware analysis
- **LetsDefend.io free tier** - Live SOC alerts, IR challenges
- **Blue Team Labs Online (BTLO) free tier** - investigation challenges
- **CyberDefenders.org** - DFIR cases with sample evidence
- **Splunk Boss of the SOC (BOTS)** - free Splunk dataset
- **MalwareBazaar** - real malware samples for analysis

### Suggested Lab Sequence
1. TryHackMe SOC Level 1 path (4 weeks alongside Weeks 1-4)
2. CyberDefenders Easy cases (Weeks 5-6)
3. LetsDefend live SOC (Weeks 6-7)
4. BTLO Investigations (Weeks 7-8)

## Study Resources

### Free Resources
- **[CompTIA CySA+ Objectives](https://www.comptia.org/certifications/cybersecurity-analyst#examdetails)** - Official exam objectives
- **[MITRE ATT&CK Framework](https://attack.mitre.org/)** - Adversary tactics reference
- **[MITRE ATT&CK Navigator](https://mitre-attack.github.io/attack-navigator/)** - Interactive matrix
- **[NIST Publications](https://csrc.nist.gov/publications)** - 800-61, 800-86, 800-150
- **[SIGMA HQ](https://github.com/SigmaHQ/sigma)** - Public Sigma rule repository
- **[OWASP Top 10](https://owasp.org/www-project-top-ten/)** - Web app security risks
- **[CISA KEV Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)** - Known exploited vulns

### Paid Resources
- **[CertMaster Learn for CySA+](https://www.comptia.org/training/certmaster-learn/cybersecurity-analyst)** - Official training
- **[CertMaster Practice for CySA+](https://www.comptia.org/training/certmaster-practice/cybersecurity-analyst)** - Official practice
- **Jason Dion CySA+ CS0-003** (Udemy) - Video course and 6 practice exams
- **CompTIA CySA+ Study Guide CS0-003** by Mike Chapple - Sybex book

## Final Exam Checklist

### Content Preparation
- [ ] All four domain notes reviewed at least twice
- [ ] Fact sheet memorized
- [ ] Top 20 ATT&CK technique IDs memorized
- [ ] Key Windows EventIDs memorized
- [ ] CVSS thresholds memorized
- [ ] NIST IR phases memorized

### Hands-On Confidence
- [ ] Can read Splunk SPL and KQL queries
- [ ] Can read Snort/Suricata signatures
- [ ] Can interpret Nessus scan output
- [ ] Can match attack to ATT&CK technique
- [ ] Can navigate Wireshark and apply filters

### Exam Day Strategy
- [ ] Time management: 165 min / 85 questions = ~2 min per question
- [ ] PBQs first or last (your preference, but commit to choice)
- [ ] Read questions twice before answering
- [ ] Eliminate wrong answers first
- [ ] Flag uncertain questions and return
- [ ] Reserve 20 minutes for review at end
