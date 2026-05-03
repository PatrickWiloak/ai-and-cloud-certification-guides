# CompTIA CySA+ (CS0-003)

## Exam Overview

The CompTIA Cybersecurity Analyst (CySA+) CS0-003 certification validates the ability to detect, prevent, and respond to cybersecurity threats by performing data analysis, threat hunting, vulnerability management, and incident response. It bridges Security+ and CASP+/PenTest+, focusing on the analyst-level "blue team" defensive role inside a security operations center (SOC).

**Exam Details:**
- **Exam Code:** CS0-003
- **Duration:** 165 minutes
- **Number of Questions:** Up to 85 questions
- **Question Types:** Multiple choice and performance-based questions (PBQs)
- **Passing Score:** 750 out of 900
- **Cost:** $404 USD
- **Language:** English (Japanese, Thai, Portuguese, Spanish planned)
- **Delivery:** Pearson VUE testing center or online proctoring
- **Validity:** 3 years (renewable via CE program)
- **Prerequisites:** None required (Network+ and Security+ recommended, plus 4+ years hands-on IT security experience)
- **DoD 8140/8570 Approved:** Yes (CSSP Analyst, CSSP Incident Responder, CSSP Auditor)

## Exam Domains

### Domain 1: Security Operations (33%)
- Importance of system and network architecture concepts in security operations
- Analyzing indicators of potentially malicious activity
- Tools or techniques to determine malicious activity
- Concepts related to attack methodology frameworks
- Threat intelligence and threat hunting concepts
- Importance of efficiency and process improvement in security operations

**Key Topics:**
- Log sources, log analysis, network analysis (Wireshark, Zeek, NetFlow)
- Indicators of compromise (IoCs) and indicators of attack (IoAs)
- Threat actor TTPs, threat modeling, threat feeds
- MITRE ATT&CK, Diamond Model, Cyber Kill Chain, OWASP, MITRE D3FEND
- SIEM correlation, EDR/XDR telemetry, packet capture, sandboxing
- SOAR playbooks, automation, ticketing, MTTD/MTTR

### Domain 2: Vulnerability Management (30%)
- Implement vulnerability scanning methods and concepts
- Analyze output from vulnerability assessment tools
- Prioritize vulnerabilities using CVSS, exploitability, and asset value
- Recommend controls to mitigate attacks and software vulnerabilities
- Vulnerability response, handling, and management concepts

**Key Topics:**
- Asset discovery, scanning types (credentialed, agent, passive), scope
- Tools - Nessus, Qualys, OpenVAS, Nikto, Burp Suite, OWASP ZAP, Nmap
- CVSS v3.1/v4.0, CVE, CWE, EPSS, KEV catalog
- Common vulnerabilities - SQLi, XSS, SSRF, RCE, IDOR, race conditions
- Validation - false positives, true positives, compensating controls
- Patch management, configuration management, risk acceptance, exceptions

### Domain 3: Incident Response and Management (20%)
- Apply incident response process concepts
- Detection and analysis of attack methodology frameworks
- Containment, eradication, recovery, and post-incident activities

**Key Topics:**
- NIST SP 800-61 lifecycle, SANS PICERL model
- Evidence handling, chain of custody, order of volatility, write blockers
- Forensic imaging (dd, FTK Imager), memory capture (Volatility, LiME)
- Root cause analysis, timeline reconstruction, lessons learned
- Communication, legal hold, regulatory notification, public relations

### Domain 4: Reporting and Communication (17%)
- Vulnerability management reporting and communication
- Incident response reporting and communication
- Metrics, KPIs, and stakeholder communication
- Compliance reports and ticketing systems

**Key Topics:**
- Vulnerability management reports (technical and executive)
- Incident reports, declaration, post-mortems, after-action reviews
- Metrics - MTTD, MTTR, dwell time, false-positive rate, SLA compliance
- Stakeholder mapping - SOC, IR team, legal, executives, regulators, customers
- Compliance frameworks - PCI-DSS, HIPAA, GDPR, SOX, FedRAMP, ISO 27001
- Ticketing - Jira, ServiceNow, Remedy, TheHive, RTIR

## Study Materials

### Notes
- [01 - Security Operations](notes/01-security-operations.md) - Logs, IoCs, threat intel, MITRE ATT&CK, hunting
- [02 - Vulnerability Management](notes/02-vulnerability-management.md) - Scanning, CVSS, prioritization, remediation
- [03 - Incident Response](notes/03-incident-response.md) - NIST 800-61, evidence handling, forensics
- [04 - Reporting and Communication](notes/04-reporting-communication.md) - Reports, metrics, stakeholders

### Study Resources
- [Fact Sheet](fact-sheet.md) - SIEM queries, Sigma rules, Snort/Suricata, MITRE ATT&CK, log cheatsheets
- [Practice Plan](practice-plan.md) - 8-week structured study schedule
- [Scenarios](scenarios.md) - 12+ incident response and threat hunting scenarios
- [Strategy](strategy.md) - Exam day strategy, PBQ tips, keyword decoding

## Official Resources

- **[CompTIA CySA+ Certification Page](https://www.comptia.org/certifications/cybersecurity-analyst)** - Official certification details
- **[CS0-003 Exam Objectives](https://www.comptia.org/certifications/cybersecurity-analyst#examdetails)** - Complete exam objectives PDF
- **[CompTIA CertMaster Learn CySA+](https://www.comptia.org/training/certmaster-learn/cybersecurity-analyst)** - Official interactive learning
- **[CompTIA CertMaster Practice CySA+](https://www.comptia.org/training/certmaster-practice/cybersecurity-analyst)** - Official practice questions
- **[CompTIA CertMaster Labs CySA+](https://www.comptia.org/training/certmaster-labs/cybersecurity-analyst)** - Official hands-on labs

## Recommended Training

### Video Courses
1. **Jason Dion CySA+ CS0-003** (Udemy) - Most popular, full video course plus practice
2. **CompTIA CertMaster Learn** - Official self-paced training with labs
3. **ITProTV/ACI Learning CySA+** - Video course with hands-on labs
4. **Pluralsight CySA+ Path** - Multi-instructor structured path

### Practice Exams
1. **CompTIA CertMaster Practice** - Official practice questions
2. **Jason Dion Practice Exams** (Udemy) - Six full-length practice exams
3. **Kaplan IT Training** - Practice exams with explanations
4. **CyberVista** - Adaptive practice platform

### Books
1. **CompTIA CySA+ Study Guide (CS0-003)** by Mike Chapple and David Seidl - Sybex
2. **CompTIA CySA+ Cert Guide (CS0-003)** by Troy McMillan - Pearson
3. **CompTIA CySA+ All-in-One Exam Guide (CS0-003)** by Brent Chapman - McGraw Hill

### Hands-On Labs
- **TryHackMe SOC Level 1** path - SIEM, log analysis, threat intel
- **Blue Team Labs Online** - Investigation challenges
- **LetsDefend.io** - Live SOC simulation with real alerts
- **CyberDefenders.org** - DFIR and blue team challenges
- **Splunk Boss of the SOC (BOTS)** - Splunk dataset challenges

## Companion Materials

| Cert | Why It Pairs |
|------|--------------|
| **CompTIA Security+ (SY0-701)** | Foundational layer; CySA+ assumes Security+ knowledge |
| **AWS Security Specialty (SCS-C02)** | Cloud-native detection, GuardDuty, Security Hub, CloudTrail |
| **Microsoft SC-200** | Sentinel KQL, Defender XDR, mirrors CySA+ analyst role for Azure |
| **(ISC)2 CISSP** | Strategic and managerial layer above CySA+ tactical work |
| **GIAC GCIH** | Deep dive on incident handling, complements Domain 3 |
| **GIAC GCIA** | Network intrusion analysis, complements packet/log work |
| **GIAC GCFA** | Forensic analysis, complements evidence handling |

## Next Steps After Certification

### Career Paths
- SOC Analyst (Tier 1, Tier 2, Tier 3)
- Incident Responder / DFIR Analyst
- Threat Hunter
- Vulnerability Management Analyst
- Cyber Threat Intelligence Analyst
- Detection Engineer
- Security Operations Engineer

### Advanced Certifications
- **CompTIA CASP+ (SecurityX)** - Senior security engineer/architect role
- **CompTIA PenTest+** - Offensive complement to CySA+
- **GIAC GCIH** - GIAC Certified Incident Handler
- **GIAC GCIA** - GIAC Certified Intrusion Analyst
- **GIAC GCFA** - GIAC Certified Forensic Analyst
- **(ISC)2 CISSP** - Senior leadership track
- **AWS Security Specialty / Microsoft SC-200** - Cloud-native blue team

---

**Good luck with your CompTIA CySA+ certification!** This is the gateway certification for SOC analyst and incident responder roles. Focus on log reading, tool output interpretation, and matching IoCs to MITRE ATT&CK techniques.
