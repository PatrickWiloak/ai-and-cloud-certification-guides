# CompTIA Security+ (SY0-701) Study Strategy

## Study Approach

### Phase 1: Foundation (2 weeks)
1. **Security Fundamentals**
   - CIA triad and AAA framework
   - Zero trust and defense in depth
   - Basic cryptography concepts
   - Threat actor types and motivations

2. **Threats and Attacks**
   - Malware types and characteristics
   - Social engineering techniques
   - Network and application attacks
   - Indicators of compromise

### Phase 2: Technical Depth (2-3 weeks)
1. **Security Architecture**
   - Network security devices and their functions
   - Cryptographic protocols and implementations
   - PKI and certificate management
   - Cloud security models

2. **Security Operations**
   - SIEM and monitoring concepts
   - Incident response lifecycle
   - Digital forensics procedures
   - Vulnerability management and penetration testing
   - Identity and access management

### Phase 3: Exam Preparation (1-2 weeks)
1. **Governance and Compliance**
   - Risk management processes
   - Security frameworks (NIST, ISO, CIS)
   - Regulations (GDPR, HIPAA, PCI-DSS)
   - Audit and assessment types

2. **Final Review**
   - Full-length practice exams
   - Performance-based question practice
   - Weak area remediation
   - Quick reference review

## Study Resources

### Free Resources (Highly Recommended)
- **[📖 Professor Messer SY0-701 Course](https://www.professormesser.com/security-plus/sy0-701/sy0-701-video/sy0-701-comptia-security-plus-course/)** - Complete free video course
- **[📖 MITRE ATT&CK Framework](https://attack.mitre.org/)** - Adversary tactics and techniques
- **[📖 OWASP Top 10](https://owasp.org/www-project-top-ten/)** - Web application security risks
- **[📖 NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)** - Security controls reference
- **[📖 NIST SP 800-61](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)** - Incident handling guide
- **[📖 CIS Controls](https://www.cisecurity.org/controls)** - Prioritized security actions

### Official CompTIA Resources
- **[📖 CompTIA Security+ Certification](https://www.comptia.org/certifications/security)** - Official certification page
- **[📖 SY0-701 Exam Objectives](https://www.comptia.org/certifications/security#examdetails)** - Download exam objectives PDF
- **[📖 CertMaster Learn](https://www.comptia.org/training/certmaster-learn/security)** - Official interactive training
- **[📖 CertMaster Practice](https://www.comptia.org/training/certmaster-practice/security)** - Official practice questions

### Paid Courses and Practice Exams
1. **Jason Dion Security+ SY0-701** (Udemy) - Video course + practice exams
2. **CompTIA CertMaster Learn** - Official self-paced training
3. **Professor Messer Practice Exams** - Quality questions with explanations
4. **Kaplan IT Training** - Practice exams with detailed explanations
5. **CompTIA Security+ Get Certified Get Ahead** by Darril Gibson - Comprehensive book

## Exam Tactics

### Question Strategy
1. **Read the entire question carefully** - Look for specific keywords and constraints
2. **Identify what is being asked** - "Best" answer, "first" action, "most" effective
3. **Eliminate wrong answers** - Usually 2 answers can be quickly eliminated
4. **Consider context** - The scenario provides important clues
5. **Choose the most correct answer** - There may be multiple "right" answers, pick the best

### Time Management
- **90 questions in 90 minutes** = approximately 1 minute per question
- **PBQs take longer** - Budget 3-5 minutes each, skip if stuck
- **Flag and move** - Do not spend more than 2 minutes on any MCQ
- **Review time** - Reserve 10-15 minutes for flagged questions
- **PBQ strategy** - Consider skipping PBQs initially, return after MCQs

### Performance-Based Questions (PBQs)
- Typically 3-5 PBQs per exam
- Appear at the beginning of the exam
- Types: drag-and-drop, matching, simulations, fill-in-the-blank
- May involve firewall rules, network diagrams, log analysis
- Partial credit may be available
- Skip complex ones and return after completing MCQs

### Keyword Decision Matrix

| Keyword | Points To |
|---------|-----------|
| "First step" in incident | Contain/isolate the threat |
| "Best prevents" | Technical control (firewall, encryption, MFA) |
| "Policy-based" | Administrative control (training, procedures) |
| "Compliance" | Match regulation to data type and industry |
| "Encrypt data at rest" | AES-256, disk encryption, database TDE |
| "Encrypt data in transit" | TLS 1.2+, VPN, IPsec, SSH |
| "Verify integrity" | Hashing (SHA-256), digital signatures |
| "Non-repudiation" | Digital signatures, audit logging |
| "Least privilege" | RBAC, just-in-time access, minimal permissions |
| "Defense in depth" | Multiple layered controls |
| "Zero trust" | Never trust, always verify, micro-segmentation |
| "Anomalous behavior" | UEBA, behavioral analytics, SIEM |
| "Evidence preservation" | Order of volatility, forensic imaging, chain of custody |

## Common Pitfalls

### Conceptual Pitfalls
- Confusing authentication (who are you?) with authorization (what can you do?)
- Mixing up symmetric (same key) and asymmetric (key pair) encryption
- Confusing IDS (detect and alert) with IPS (detect and block)
- Not understanding the difference between hashing (one-way) and encryption (two-way)
- Confusing risk transfer (insurance) with risk mitigation (controls)
- Mixing up vulnerability (weakness) with threat (potential danger)

### Technical Pitfalls
- Not knowing which ports belong to which protocols
- Confusing SAML (federation) with OAuth (authorization) with OIDC (authentication)
- Not understanding certificate chain of trust
- Mixing up security groups (stateful) with ACLs (stateless)
- Confusing qualitative (subjective) with quantitative (numerical) risk analysis

### Exam Pitfalls
- Spending too much time on PBQs at the beginning
- Choosing the most complex answer when a simpler one suffices
- Not reading all four answer choices before selecting
- Overthinking straightforward questions
- Selecting the "technically correct" answer instead of the "best practice" answer

## Domain-Specific Tips

### General Security Concepts (12%)
- Memorize the CIA triad and how each principle is protected
- Understand zero trust principles - "never trust, always verify"
- Know the difference between threat actors and their motivations
- Understand basic cryptography: symmetric vs asymmetric vs hashing

### Threats, Vulnerabilities, Mitigations (22%)
- Know all social engineering techniques and their characteristics
- Memorize malware types and how they spread
- Understand common attack types and their defenses
- Know MITRE ATT&CK framework at a high level
- Be able to match attacks to appropriate mitigations

### Security Architecture (18%)
- Know network security devices and which OSI layer they operate at
- Understand PKI components and certificate lifecycle
- Know secure vs insecure protocols (HTTPS vs HTTP, SSH vs Telnet)
- Understand cloud security shared responsibility model
- Know encryption algorithms and their appropriate use cases

### Security Operations (28%)
- This is the heaviest domain - allocate extra study time
- Know the incident response lifecycle (NIST SP 800-61)
- Understand SIEM functionality and alert investigation
- Know evidence handling procedures and order of volatility
- Understand vulnerability management lifecycle
- Know authentication protocols (SAML, OAuth, OIDC, Kerberos)

### Security Program Management (20%)
- Know risk management concepts and calculations (ALE = SLE x ARO)
- Understand compliance frameworks and their applicability
- Know the difference between policies, standards, procedures, guidelines
- Understand audit types and assessment methodologies
- Know data governance and classification schemes

## Important Acronyms to Memorize

### Security Concepts
- **CIA** - Confidentiality, Integrity, Availability
- **AAA** - Authentication, Authorization, Accounting
- **MFA** - Multi-Factor Authentication
- **SSO** - Single Sign-On
- **PAM** - Privileged Access Management

### Risk and Compliance
- **ALE** - Annualized Loss Expectancy
- **SLE** - Single Loss Expectancy
- **ARO** - Annual Rate of Occurrence
- **BIA** - Business Impact Analysis
- **RTO/RPO** - Recovery Time/Point Objective

### Security Tools
- **SIEM** - Security Information and Event Management
- **SOAR** - Security Orchestration, Automation, and Response
- **IDS/IPS** - Intrusion Detection/Prevention System
- **DLP** - Data Loss Prevention
- **WAF** - Web Application Firewall
- **NAC** - Network Access Control
- **CASB** - Cloud Access Security Broker

### Frameworks
- **NIST CSF** - National Institute of Standards and Technology Cybersecurity Framework
- **NIST RMF** - Risk Management Framework
- **MITRE ATT&CK** - Adversarial Tactics, Techniques, and Common Knowledge
- **CIS** - Center for Internet Security
- **OWASP** - Open Worldwide Application Security Project

## Pre-Exam Checklist

### One Week Before
- [ ] Scoring 80%+ consistently on practice exams
- [ ] All domain notes reviewed at least twice
- [ ] Port numbers memorized for common protocols
- [ ] Key acronyms memorized
- [ ] PBQ format familiar and practiced

### Day Before
- [ ] Light review of fact sheet only
- [ ] Review common exam scenarios
- [ ] Verify exam appointment details
- [ ] Prepare valid ID and testing environment
- [ ] Get a good night's rest

### Exam Day
- [ ] Arrive 15 minutes early
- [ ] Read each question fully before answering
- [ ] Consider skipping PBQs initially, return after MCQs
- [ ] Flag uncertain questions and move on
- [ ] Review flagged questions at the end
- [ ] Trust your preparation
