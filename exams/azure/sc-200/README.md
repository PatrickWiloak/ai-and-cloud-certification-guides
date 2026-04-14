# Microsoft Security Operations Analyst Associate (SC-200)

## Exam Overview

The Microsoft Security Operations Analyst Associate (SC-200) certification validates the skills required to collaborate with organizational stakeholders to secure IT systems. The role mitigates threats by using Microsoft Sentinel, Microsoft Defender XDR, Microsoft Defender for Cloud, and third-party security products. Security operations analysts investigate, respond to, and hunt for threats using these tools and recommend improvements to security posture.

**Exam Details:**
- **Exam Code:** SC-200
- **Duration:** 100 minutes
- **Number of Questions:** 40 to 60 questions
- **Question Types:** Multiple choice, multiple response, drag and drop, case studies, hot area, build list, active screen
- **Passing Score:** 700 out of 1000
- **Cost:** $165 USD (varies by region)
- **Languages:** English, Japanese, Chinese (Simplified), Korean, German, French, Spanish, Portuguese (Brazil)
- **Delivery:** Pearson VUE testing center or online proctoring
- **Validity:** 1 year (renewable free via online assessment on Microsoft Learn)
- **Prerequisites:** None required. Recommended: foundational understanding of Microsoft 365, Azure services, and Windows/Linux operating systems.

## Exam Domains

### Domain 1: Manage a security operations environment (25 to 30%)
- Configure settings in Microsoft Defender XDR
- Manage assets and environments
- Design and configure a Microsoft Sentinel workspace
- Configure ingestion of data sources in Microsoft Sentinel

**Key Topics:**
- Microsoft Defender XDR portal configuration and role-based access
- Custom detection rules and alert policies
- Sentinel workspace architecture and multi-tenant design
- Data connectors: Microsoft 365, Azure Activity, Entra ID, AWS, GCP, syslog/CEF
- Content hub solutions and workbooks
- Commitment tiers and data retention planning

### Domain 2: Configure protections and detections (15 to 20%)
- Configure protections in Microsoft Defender security technologies
- Configure detections in Microsoft Defender XDR
- Configure detections in Microsoft Sentinel

**Key Topics:**
- Defender for Endpoint: attack surface reduction rules, EDR, ASR
- Defender for Cloud Apps: app discovery, CASB policies, conditional access app control
- Defender for Identity: identity threat detection, ITDR
- Defender for Office 365: Safe Links, Safe Attachments, anti-phishing
- Analytics rules in Sentinel: scheduled, Microsoft security, NRT, Fusion, anomaly
- MITRE ATT&CK mapping

### Domain 3: Manage incident response (35 to 40%)
- Respond to alerts and incidents in Microsoft Defender XDR
- Respond to alerts and incidents identified by Microsoft Defender for Cloud
- Enrich investigations by using other Microsoft tools
- Respond to incidents in Microsoft Sentinel

**Key Topics:**
- Incident triage, investigation, and assignment
- Evidence collection and attack story review
- Live response sessions on endpoints
- Automated investigation and response (AIR)
- Defender for Cloud alert handling and secure score remediation
- Playbooks using Logic Apps and automation rules
- Microsoft Purview integration for insider risk and data loss

### Domain 4: Perform threat hunting (15 to 20%)
- Identify threats by using Kusto Query Language (KQL)
- Hunt for threats by using Microsoft Defender XDR
- Hunt for threats by using Microsoft Sentinel

**Key Topics:**
- KQL operators: where, project, summarize, join, extend, parse, make-series
- Advanced hunting schema in Defender XDR
- Sentinel hunting queries, bookmarks, livestream
- Hunting hypothesis development and MITRE mapping
- Notebooks and Jupyter integration

## Study Materials

### Notes
- [01 - Microsoft Defender XDR](notes/01-microsoft-defender-xdr.md) - Unified portal, workloads, incident correlation
- [02 - Microsoft Sentinel Fundamentals](notes/02-microsoft-sentinel-fundamentals.md) - SIEM/SOAR architecture, workspace design
- [03 - KQL for Security](notes/03-kql-for-security.md) - Query language for hunting and analytics
- [04 - Incident Investigation and Response](notes/04-incident-investigation-and-response.md) - Triage workflow, automation
- [05 - Threat Hunting](notes/05-threat-hunting.md) - Proactive hunting techniques and queries
- [06 - Defender for Cloud and Endpoint](notes/06-defender-for-cloud-and-endpoint.md) - CSPM, CWPP, EDR

### Study Resources
- [Fact Sheet](fact-sheet.md) - Quick reference with key facts and doc links
- [Practice Plan](practice-plan.md) - Structured 6 to 8 week study schedule
- [Scenarios](scenarios.md) - Real-world SOC scenario-based practice
- [Strategy](strategy.md) - Exam day strategy and tips

## Official Resources

- **Microsoft SC-200 Certification Page:** https://learn.microsoft.com/en-us/credentials/certifications/security-operations-analyst/
- **SC-200 Study Guide (official):** https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-200
- **Microsoft Learn SC-200 Learning Path:** https://learn.microsoft.com/en-us/training/courses/sc-200t00
- **Microsoft Sentinel Documentation:** https://learn.microsoft.com/en-us/azure/sentinel/
- **Microsoft Defender XDR Documentation:** https://learn.microsoft.com/en-us/defender-xdr/
- **Microsoft Defender for Cloud Documentation:** https://learn.microsoft.com/en-us/azure/defender-for-cloud/

## Recommended Training

### Video Courses
1. **Microsoft Learn SC-200 Learning Path** - Free official modules
2. **John Savill SC-200 Study Cram** (YouTube) - Free comprehensive review
3. **Pluralsight SC-200 Path** - Paid structured video training
4. **Tim Warner SC-200** (O'Reilly/Pluralsight) - Detailed walkthroughs

### Practice and Labs
1. **Microsoft Applied Skills assessments** - Free hands-on Sentinel and Defender assessments
2. **Microsoft Sentinel Training Lab** - GitHub-hosted lab deployment
3. **MeasureUp SC-200 Practice Test** - Official Microsoft practice provider
4. **Whizlabs SC-200 Practice** - Additional practice question bank

### Books and References
1. **Microsoft Sentinel in Action** (Packt) by Richard Diver, Gary Bushey
2. **Microsoft Defender for Cloud book** (Packt)
3. **The Definitive Guide to KQL** by Mark Morowczynski, Rod Trent

## Next Steps After Certification

### Career Paths
- SOC Analyst (Tier 1/2/3)
- Security Operations Engineer
- Incident Responder
- Threat Hunter
- Microsoft Security Consultant
- Detection Engineer

### Related Microsoft Certifications
- **SC-100** - Microsoft Cybersecurity Architect Expert
- **AZ-500** - Azure Security Engineer Associate
- **SC-300** - Identity and Access Administrator Associate
- **SC-400** - Information Protection Administrator Associate
- **MS-500** - Microsoft 365 Security Administrator

---

**Good luck with your SC-200 certification!** Strong KQL skills and hands-on time in a Sentinel workspace are the two highest-leverage investments you can make for this exam.
