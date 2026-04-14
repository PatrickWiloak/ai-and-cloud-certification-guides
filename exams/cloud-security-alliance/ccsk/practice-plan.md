# CCSK v5 Practice Plan - 5 Week Schedule

CCSK v5 is an open-book exam based on the CSA Security Guidance v5 and Cloud Controls Matrix v4. Most candidates prepare in 3 to 6 weeks depending on cloud experience. This plan assumes 6 to 10 hours per week and is suited for someone with some cloud familiarity.

Compress to 3 weeks if you are an experienced cloud security professional. Extend to 8 weeks if new to cloud.

## Materials Required

### Required (free)
- **CSA Security Guidance v5** - 200+ page PDF, cloudsecurityalliance.org/research/guidance
- **Cloud Controls Matrix v4** - Spreadsheet, cloudsecurityalliance.org/research/cloud-controls-matrix
- **CAIQ v4** - Spreadsheet

### Recommended additions
- **CSA CCSK Prep Kit** (paid via CSA) - Includes practice questions; highly useful
- **Daniel Greer's CCSK v5 Prep Guide** (paid) - Condensed study guide with quizzes
- Note-taking app (Obsidian, Notion, OneNote) for building your searchable reference

## Exam Strategy (Open Book)

CCSK allows referencing the Guidance PDF and CCM during the exam. To use this effectively:
- Create bookmarks in the PDF for each of the 12 domains and their key sections
- Build a keyword index (e.g., "SCIM" -> Domain 5 IAM page X)
- Filter the CCM spreadsheet by control domain before the exam
- Practice CTRL+F searching quickly

## Week-by-Week Plan

### Week 1: Guidance v5 Domains 1-4 (Concepts, Governance, Risk/Audit, Organization)

**Goals:** Master cloud fundamentals and governance context.

**Topics:**
- Domain 1: Cloud definitions (NIST SP 800-145), service models, deployment models, shared responsibility, metastructure vs applistructure vs data plane
- Domain 2: Cloud governance, policy hierarchy, cloud-aware governance
- Domain 3: Risk management in cloud, audit adaptations, compliance frameworks, regulatory requirements
- Domain 4: Organization management, cloud account structure, landing zones, hierarchies

**Activities:**
- Read Guidance v5 Domains 1-4 cover-to-cover
- Build bookmarks/index for these sections
- 50 practice questions from CCSK Prep Kit
- Skim CCM for related control domains (GRC, A&A, STA, DCS)

### Week 2: Guidance v5 Domains 5-7 (IAM, Security Monitoring, Infra & Networking)

**Topics:**
- Domain 5: Cloud IAM, federated identity, CIEM, workload identity, least privilege
- Domain 6: Security monitoring, logging, SIEM/SOAR in cloud, cloud-native detection services
- Domain 7: Cloud infrastructure security, virtual networking, zero trust networking, segmentation, DDoS

**Activities:**
- Read Guidance v5 Domains 5-7
- Review CCM domains: IAM, LOG, IVS
- 60 practice questions
- Build a one-page summary of zero trust concepts

### Week 3: Guidance v5 Domains 8-10 (Workload, Data, Application Security)

**Topics:**
- Domain 8: Cloud workload types (VM, container, serverless, PaaS), workload protection
- Domain 9: Data security lifecycle, classification, encryption approaches, tokenization, DLP, residency
- Domain 10: Application security, cloud SDLC, API security, DevSecOps

**Activities:**
- Read Guidance v5 Domains 8-10
- Review CCM domains: CEK, DSP, AIS, TVM
- 75 practice questions
- Review encryption approach decision tree (BYOK, HYOK, etc.)

### Week 4: Guidance v5 Domains 11-12 + CCM Deep Dive

**Topics:**
- Domain 11: Incident response and resilience, cloud forensics, DR in cloud
- Domain 12: Related technologies (DevSecOps, zero trust architecture, AI/ML security considerations)
- CCM v4 structure: 17 domains, 197 controls, mappings to other frameworks
- CAIQ structure and usage

**Activities:**
- Read Guidance v5 Domains 11-12
- Review CCM in full; read control specifications for each of the 17 domains
- Understand how CCM maps to ISO 27001, NIST SP 800-53, PCI DSS
- Review STAR Registry levels (1, 2 Attestation, 2 Certification, 3)
- 75 practice questions

### Week 5: Full Practice Exams + Final Review

**Activities:**
- Take a full 60-question practice exam under open-book conditions, timed 120 minutes
- Review every incorrect answer; find the Guidance section in the PDF
- Second full practice exam (different set if possible)
- Target 85%+ on practice (exam requires 80%)
- Finalize bookmarks in the PDF for the 12 domains
- Build index of key terms with domain location
- Review CCM domain names and short descriptions (memorize the 17)
- Review NIST SP 800-145 (5 essentials, 3 service, 4 deployment)
- Rest the day before the exam

### Exam Day

- Quiet room, reliable internet
- Browser recommended by CSA (usually Chrome or Firefox)
- Have open in separate tabs/windows:
  - Guidance v5 PDF with bookmarks
  - CCM v4 spreadsheet
  - Your notes and index
  - Possibly STAR level quick reference
- 120 minutes, 60 questions
- First pass: answer all you know (mark uncertain)
- Second pass: look up marked questions
- Submit when done or at time; not all 120 minutes needed if you know material

## Daily Habits During Study

- **30 to 45 minutes reading Guidance** per session
- **10 to 20 practice questions** per day
- **Note-taking** in a searchable format (mental models, diagrams)
- **Spaced repetition** for acronyms and key definitions

## Practice Question Targets

- Week 1: 50% baseline
- Week 2: 65%
- Week 3: 75%
- Week 4: 80%+
- Week 5: 85%+ consistently

## Key Concepts to Memorize

Despite open-book, memorization saves lookup time:

1. **NIST SP 800-145** - 5 essentials, 3 service, 4 deployment
2. **Shared responsibility model** - who does what in IaaS/PaaS/SaaS
3. **12 Guidance domains** - names and high-level content
4. **17 CCM domains** - names and short descriptions
5. **CSA STAR Levels** - 1, 2 Attestation, 2 Certification, 3
6. **Top Threats** - 11 threats from CSA Top Threats v4
7. **Cloud lifecycle (data)** - Create, Store, Use, Share, Archive, Destroy
8. **Encryption approaches** - Provider-managed, BYOK, HYOK, CSE, CSE-C
9. **Audit report types** - SOC 1/2/3, Type 1 vs 2
10. **Privacy regs** - GDPR, CCPA, HIPAA key points

## CCM Domain Memorization (17)

Use a mnemonic or repeated review:
- A&A (Audit & Assurance)
- AIS (Application & Interface Security)
- BCR (Business Continuity & Resilience)
- CCC (Change Control & Configuration Mgmt)
- CEK (Cryptography, Encryption, Keys)
- DCS (Datacenter Security)
- DSP (Data Security & Privacy)
- GRC (Governance, Risk, Compliance)
- HRS (Human Resources)
- IAM (Identity and Access Management)
- IPY (Interoperability & Portability)
- IVS (Infrastructure & Virtualization)
- LOG (Logging & Monitoring)
- SEF (Security Incident, E-Discovery, Forensics)
- STA (Supply Chain, Transparency, Accountability)
- TVM (Threat & Vulnerability Management)
- UEM (Universal Endpoint Management)

## After You Pass

- Digital certificate via CSA portal immediately
- Add to LinkedIn, resume
- Consider CCSK Plus for hands-on lab validation
- Plan for CCSP if you meet experience requirements (CCSK waives 1 year CCSP CBK-domain experience)
- Consider CCZT for zero trust specialization
- Stay current by following CSA research and attending CSA webinars

## If You Do Not Pass

- 2 attempts included in $395 fee; schedule second within reasonable window
- Review which areas you were weak on (prep kit analysis)
- Re-read weak Guidance domains
- Additional practice exams
- Consider CSA Authorized Training Provider course for instructor-led reinforcement
- Additional retakes beyond 2nd are $395 each
