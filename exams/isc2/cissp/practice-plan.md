# CISSP Practice Plan - 16 Week Schedule

CISSP is a breadth-over-depth exam covering 8 domains. Most successful candidates spend 3 to 6 months preparing. This plan assumes 10 to 15 hours per week of focused study and is designed for someone with some hands-on security experience.

If you are already a senior security practitioner, you can compress this to 10 to 12 weeks. If new to multiple domains, plan 20+ weeks.

## Materials Required

Before starting:
- **Official ISC2 CISSP Study Guide, 10th Edition** (Sybex) - primary text
- **Official ISC2 CISSP Practice Tests, 4th Edition** (Sybex) - practice question bank
- **Destination Certification CISSP MasterClass** OR **Pete Zerger CISSP Exam Cram** (free) - video course
- **Boson ExSim CISSP** OR **LearnZapp CISSP** - high-quality practice exams
- **Eleventh Hour CISSP** by Eric Conrad - final-week review

Optional additions:
- **Sunflower CISSP study notes** (free PDF)
- **Memory palace** materials for memorization-heavy items (cryptography, ports, OSI layers)
- **Mind maps** by Destination Certification (excellent visualization)

## Week-by-Week Plan

### Week 1: Orientation and Domain 1 (Security and Risk Management) - Part 1

**Goals:** Understand exam format, ethics, governance, foundational risk concepts.

**Topics:**
- ISC2 Code of Ethics (memorize order)
- CIA triad and beyond (DAD, AAA, IAAA)
- Security governance: policies, standards, procedures, guidelines, baselines
- Due care vs due diligence
- Compliance landscape: GDPR, HIPAA, SOX, PCI DSS, GLBA

**Activities:**
- Read Study Guide Chapters 1 to 4 (varies by edition; aim for first 100-150 pages)
- Watch Domain 1 video content
- Take 50 practice questions on Domain 1
- Begin building flashcards (Anki recommended) for ethics, frameworks

**Deliverable:** Written one-page summary of Domain 1 in your own words.

### Week 2: Domain 1 Part 2 - Risk Management Deep Dive

**Topics:**
- Risk management lifecycle (NIST RMF, ISO 31000)
- Quantitative risk analysis: AV, EF, SLE, ARO, ALE
- Qualitative risk analysis
- Risk treatment options: accept, avoid, mitigate, transfer (and share)
- Threat modeling (STRIDE, PASTA, DREAD, attack trees)
- Supply chain risk management
- Business continuity requirements (BIA, RTO, RPO, MTD)

**Activities:**
- Practice 5 quantitative risk problems by hand
- Read Eleventh Hour Domain 1 chapter
- 75 practice questions

### Week 3: Domain 2 (Asset Security)

**Topics:**
- Information classification schemes (government and commercial)
- Data ownership: owner, steward, custodian, user, processor, controller
- Data lifecycle (create, store, use, share, archive, destroy)
- Data states: at rest, in transit, in use
- Data sanitization: clearing, purging, destruction (NIST SP 800-88)
- DRM, DLP fundamentals
- Privacy concepts and PII handling

**Activities:**
- Build a chart mapping classifications to handling/destruction methods
- 60 practice questions

### Week 4: Domain 3 Part 1 - Architecture Models and Cryptography Basics

**Topics:**
- Secure design principles (least privilege, defense in depth, fail secure, separation of duties, zero trust)
- Security models (Bell-LaPadula, Biba, Clark-Wilson, Brewer-Nash, Take-Grant, HRU)
- Trusted Computing Base (TCB), reference monitor, security kernel
- Common Criteria, EAL levels
- Cryptography fundamentals: confidentiality, integrity, authenticity, non-repudiation
- Symmetric vs asymmetric vs hashing
- Block vs stream ciphers, modes (ECB, CBC, CFB, OFB, CTR, GCM)

**Activities:**
- Memorize security model properties
- Build crypto cheat sheet (algorithms, key sizes, use cases)
- 75 practice questions

### Week 5: Domain 3 Part 2 - Advanced Cryptography and Physical Security

**Topics:**
- Asymmetric algorithms: RSA, ECC, DH/ECDH, ElGamal
- Hashing: SHA family, HMAC, password hashes (bcrypt, scrypt, Argon2, PBKDF2)
- PKI: CA, RA, CRL, OCSP, X.509, certificate types
- Digital signatures, code signing
- Cryptanalytic attacks: brute force, known-plaintext, chosen-plaintext, side-channel, birthday, meet-in-the-middle
- Hardware security: TPM, HSM, secure enclave
- Physical security: CPTED, perimeter, fencing classifications, locks, mantraps, fire suppression

**Activities:**
- Walk through a PKI certificate validation in your head end-to-end
- 75 practice questions

### Week 6: Domain 4 Part 1 - Networking Fundamentals

**Topics:**
- OSI 7-layer model (memorize layer names, PDUs, examples)
- TCP/IP 4-layer model
- Common protocols by layer
- IP addressing, subnetting, CIDR, IPv4 vs IPv6
- DNS, DHCP, ARP, ICMP
- TCP handshake, three-way and four-way termination
- Network device types (hub, switch, router, firewall, IDS/IPS, WAF, proxy, load balancer)

**Activities:**
- Diagram a packet's journey from app to wire and back
- Subnet 5 networks by hand
- 60 practice questions

### Week 7: Domain 4 Part 2 - Secure Network Design and Wireless

**Topics:**
- Network segmentation (VLAN, microsegmentation, zero trust networking)
- Firewall types (stateful, stateless, NGFW, application proxy)
- VPN: IPsec (AH, ESP, modes), SSL/TLS VPN, SSH tunnels
- Wireless: 802.11 standards, WPA2/WPA3, EAP variants, rogue AP, evil twin
- Bluetooth, Zigbee, NFC, RFID
- Cellular: 4G/5G concepts
- VoIP and converged protocols (FCoE, iSCSI)
- CDN, edge computing, SD-WAN, SASE

**Activities:**
- 75 practice questions
- Take Domain 4 mini-exam (~50 questions)

### Week 8: Mid-Course Assessment + Domain 5 Part 1

**Goals:** Review weeks 1 to 7. Take a 100-question diagnostic. Address weak areas.

**Topics:**
- Identification, authentication, authorization, accounting (IAAA)
- Authentication factors and types (1 to 5)
- Biometrics: FAR, FRR, CER, enrollment, throughput
- Single sign-on (SSO): Kerberos, SAML, OAuth, OIDC
- Federation models

**Activities:**
- Take 100-question diagnostic across all 8 domains
- Build a remediation list of low-scoring topics
- Complete Domain 5 reading

### Week 9: Domain 5 Part 2 - Access Control Models and PAM

**Topics:**
- DAC, MAC, RBAC, ABAC, RuBAC, risk-based
- Identity provisioning lifecycle
- Privileged access management (PAM): vaulting, JIT, session recording
- Account access reviews (UARs)
- Identity as a Service (IDaaS)
- Just-in-time access, just-enough-access (JEA)

**Activities:**
- Compare/contrast DAC vs MAC vs RBAC vs ABAC in writing
- 75 practice questions

### Week 10: Domain 6 (Security Assessment and Testing)

**Topics:**
- Assessment vs audit vs test
- Vulnerability assessment vs pen test
- Pen test methodologies (PTES, OSSTMM, NIST SP 800-115)
- Knowledge levels: black, gray, white box
- Code review (static, dynamic, IAST, RASP, SAST, DAST, SCA)
- Misuse case testing, fuzz testing, mutation testing
- Synthetic transactions and real user monitoring
- Security audits: SOC 1, SOC 2 Type 1/2, SOC 3
- KRIs, KPIs, KGIs

**Activities:**
- Map test types to SDLC phases
- 75 practice questions

### Week 11: Domain 7 Part 1 - Operations Foundations and Incident Response

**Topics:**
- Need to know, least privilege, separation of duties, two-person integrity
- Job rotation, mandatory vacation
- Privileged account management
- Configuration management vs change management
- Patch management
- IR lifecycle: preparation, detection, analysis, containment, eradication, recovery, lessons learned (NIST SP 800-61)
- Forensic process: identify, preserve, collect, examine, analyze, present, decide
- Chain of custody
- Detective and preventive controls

**Activities:**
- Walk through an IR scenario end-to-end
- 75 practice questions

### Week 12: Domain 7 Part 2 - DR/BCP and Physical Operations

**Topics:**
- BCP/DRP differences and relationship
- BIA: identify, prioritize, calculate
- RPO, RTO, MTD, WRT
- Recovery sites (cold, warm, hot, mirrored, reciprocal, cloud)
- DR strategies: backups (full/incremental/differential, GFS), replication, snapshots
- DR testing: read-through, walk-through, tabletop, simulation, parallel, full interruption
- Personnel safety always first
- Physical security operations: access logs, visitor management, CCTV

**Activities:**
- Build a comparison chart of recovery sites and test types
- 75 practice questions

### Week 13: Domain 8 (Software Development Security)

**Topics:**
- SDLC models: Waterfall, Spiral, Agile, DevOps, DevSecOps, SAFe
- Maturity models: CMMI (5 levels), BSIMM, OpenSAMM
- Secure coding standards: OWASP Top 10, CWE/SANS Top 25
- Code repositories: version control, branching strategies, signed commits
- Application security testing: SAST, DAST, IAST, SCA, RASP
- Software acquisition: COTS, OSS, SaaS, escrow agreements
- API security
- Containers and serverless security
- Database security: views, polyinstantiation, aggregation, inference

**Activities:**
- Memorize OWASP Top 10 (current version)
- Memorize CMMI levels and BSIMM domains
- 75 practice questions

### Week 14: First Full-Length Practice Exam + Weak Domain Focus

**Goals:** Take a full 150-question simulated exam. Identify weak domains.

**Activities:**
- Take Boson ExSim full-length exam under exam conditions (3 hours, no reference materials)
- Review every wrong answer in depth (write out explanation)
- Re-read weak chapters
- Build new flashcards for missed concepts

### Week 15: Second Full-Length Practice Exam + Cross-Domain Integration

**Topics:**
- How domains intersect: a phishing incident touches all 8
- Practice "best answer" question approach
- Memorize ethics order, OSI layers, security models, key crypto values
- Re-read Eleventh Hour CISSP cover-to-cover

**Activities:**
- Take second full-length exam from a different vendor (LearnZapp or Sybex)
- Target 80%+ pass rate on practice exams
- Daily 30 minutes flashcard review

### Week 16: Final Review and Exam

**Days 1-3:** 
- Re-read Eleventh Hour CISSP
- Review all flashcards twice
- Watch Pete Zerger Exam Cram or equivalent in single sitting
- 50 practice questions per day, focused on weakest 2 domains

**Day 4-5:**
- Light review only - no new material
- Mind maps and summary sheets
- Mental rehearsal of CAT format and exam-day logistics
- Confirm Pearson VUE appointment, ID, route

**Day 6:** 
- REST. No studying after early afternoon.
- Light exercise, normal sleep, hydration

**Exam Day:**
- Eat protein-rich breakfast
- Arrive 30 minutes early at Pearson VUE
- Photo ID required (passport + secondary ID)
- 3 hours, no breaks built in (you can take a break but the clock keeps running)
- Trust your preparation

## Daily Habits Throughout

- **30 to 60 minutes of practice questions** every day except rest day
- **Anki flashcards** - 15 minutes/day; new cards from current chapter, review old cards
- **Concept journal** - one page per day on a confusing topic, written in your own words
- **Study group** - weekly call with 1 to 3 other CISSP candidates if possible

## Practice Exam Score Targets

- Week 4: 50%+ on completed domains
- Week 8: 65% on full diagnostic
- Week 14: 75% on first full-length
- Week 15: 80%+ on second full-length
- Exam day: ready when consistently 80%+ on Boson and 85%+ on Sybex

## Mindset Daily Reminders

1. CISSP rewards manager-level thinking, not technician-level
2. Best answer, not only correct answer
3. People > assets > reputation when prioritizing
4. Address root cause, not symptom
5. The exam is not a knowledge dump - it is judgment under uncertainty

## After You Pass

- Get endorsed within 9 months (find an ISC2 member or use ISC2 endorsement)
- Pay $135 first AMF
- Plan 40+ CPEs in year 1 (free webinars, books, podcasts count)
- Update LinkedIn, resume, and any clearance/role paperwork
- Consider concentration certs: ISSAP (architecture), ISSEP (engineering), ISSMP (management)
