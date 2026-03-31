# CompTIA Security+ (SY0-701) Fact Sheet

## Quick Reference

**Exam Code:** SY0-701
**Duration:** 90 minutes
**Questions:** Up to 90 (MCQ + performance-based)
**Passing Score:** 750/900
**Cost:** $404 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| General Security Concepts | 12% | CIA triad, AAA, zero trust, cryptography basics |
| Threats, Vulnerabilities, Mitigations | 22% | Malware, attacks, vulnerability types, MITRE ATT&CK |
| Security Architecture | 18% | Network security, cryptography, PKI, cloud security |
| Security Operations | 28% | Monitoring, IR, forensics, SIEM, vulnerability mgmt |
| Security Program Management | 20% | Risk management, frameworks, compliance, governance |

## Core Security Concepts

### CIA Triad
| Principle | Definition | Controls |
|-----------|-----------|----------|
| **Confidentiality** | Prevent unauthorized disclosure | Encryption, access controls, classification |
| **Integrity** | Prevent unauthorized modification | Hashing, digital signatures, checksums |
| **Availability** | Ensure authorized access when needed | Redundancy, backups, DDoS protection |

### AAA Framework
- **Authentication** - Verify identity (who are you?)
- **Authorization** - Determine permissions (what can you do?)
- **Accounting** - Track actions (what did you do?)

**Documentation:**
- **[📖 CompTIA Security+ Objectives](https://www.comptia.org/certifications/security#examdetails)** - Official exam objectives
- **[📖 NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)** - Security and privacy controls

### Zero Trust Principles
- Never trust, always verify
- Assume breach mentality
- Verify explicitly - authenticate and authorize every request
- Least privilege access - minimum permissions required
- Micro-segmentation - network divided into secure zones
- Continuous validation - ongoing authentication and monitoring

### Defense in Depth
- Multiple layers of security controls
- Physical, technical, and administrative controls
- If one layer fails, others still protect
- Layers: physical security, network security, host security, application security, data security

## Threat Actors

| Actor | Motivation | Sophistication | Resources |
|-------|-----------|---------------|-----------|
| **Nation-state** | Espionage, warfare, disruption | Very high (APT) | Extensive |
| **Organized crime** | Financial gain | High | Significant |
| **Hacktivists** | Political/social cause | Medium | Moderate |
| **Insider threat** | Revenge, financial, accidental | Varies | Internal access |
| **Script kiddies** | Notoriety, curiosity | Low | Limited |
| **Competitors** | Competitive advantage | Medium-high | Moderate |

**Documentation:**
- **[📖 MITRE ATT&CK Framework](https://attack.mitre.org/)** - Adversary tactics and techniques
- **[📖 NIST SP 800-30](https://csrc.nist.gov/publications/detail/sp/800-30/rev-1/final)** - Guide for conducting risk assessments

## Malware Types

| Type | Description | Vector |
|------|-------------|--------|
| **Ransomware** | Encrypts data, demands payment | Phishing, exploits |
| **Trojan** | Disguised as legitimate software | Downloads, email |
| **Worm** | Self-replicating across networks | Network exploitation |
| **Rootkit** | Hides in OS kernel/firmware | Exploits, trojans |
| **Spyware** | Collects information covertly | Bundled software, exploits |
| **Keylogger** | Records keystrokes | Trojans, physical |
| **RAT** | Remote Access Trojan | Phishing, downloads |
| **Logic bomb** | Triggers on specific condition | Insider, supply chain |
| **Fileless** | Lives in memory, no files on disk | Scripts, macros |
| **Cryptominer** | Uses resources to mine crypto | Web exploits, trojan |

## Attack Vectors and Techniques

### Social Engineering
| Attack | Description | Defense |
|--------|-------------|---------|
| **Phishing** | Fraudulent email to steal credentials | Training, email filtering |
| **Spear phishing** | Targeted phishing at specific individuals | Advanced email security |
| **Whaling** | Phishing targeting executives | Executive awareness |
| **Vishing** | Voice phishing via phone calls | Call verification policies |
| **Smishing** | SMS-based phishing | Mobile security awareness |
| **Pretexting** | Fabricated scenario to gain trust | Verification procedures |
| **Baiting** | Entice with something appealing | Physical security, policies |
| **Tailgating** | Following authorized person through door | Badge access, awareness |
| **Watering hole** | Compromise frequently visited website | Web filtering, patching |
| **Business email compromise** | Impersonate executive for wire transfer | Out-of-band verification |

### Network Attacks
| Attack | Description | Defense |
|--------|-------------|---------|
| **Man-in-the-middle** | Intercept communication between parties | TLS, certificate pinning |
| **DDoS** | Overwhelm service with traffic | DDoS protection, CDN |
| **DNS poisoning** | Corrupt DNS cache entries | DNSSEC, secure DNS |
| **ARP poisoning** | Associate attacker MAC with target IP | Static ARP, DAI |
| **Replay attack** | Re-send captured authentication | Timestamps, nonces |
| **Session hijacking** | Take over authenticated session | Secure cookies, re-auth |
| **SSL stripping** | Downgrade HTTPS to HTTP | HSTS, certificate pinning |

### Application Attacks
| Attack | Description | Defense |
|--------|-------------|---------|
| **SQL injection** | Insert SQL commands via input | Parameterized queries, WAF |
| **XSS** | Inject scripts into web pages | Input validation, CSP |
| **CSRF** | Force authenticated user actions | Anti-CSRF tokens |
| **Buffer overflow** | Write beyond allocated memory | Bounds checking, ASLR |
| **Directory traversal** | Access files outside web root | Input validation, chroot |
| **XML injection/XXE** | Exploit XML parser | Disable external entities |
| **LDAP injection** | Inject LDAP queries | Input sanitization |

## Cryptography

### Symmetric Encryption
- Same key for encryption and decryption
- Fast, efficient for large data
- Key distribution challenge
- **AES** - 128/192/256-bit, current standard
- **3DES** - Legacy, being deprecated
- **ChaCha20** - Stream cipher, used in TLS

### Asymmetric Encryption
- Public key (encrypt) and private key (decrypt)
- Slower than symmetric, used for key exchange and signatures
- **RSA** - 2048/4096-bit, widely used
- **ECC** - Elliptic Curve, smaller keys, same security
- **Diffie-Hellman** - Key exchange protocol
- **DSA** - Digital signatures

### Hashing
- One-way function producing fixed-size output
- Verify integrity, store passwords
- **SHA-256/SHA-3** - Current standard
- **MD5** - Deprecated, collision vulnerabilities
- **HMAC** - Hash-based message authentication code
- **bcrypt/scrypt/Argon2** - Password hashing with salt

### PKI (Public Key Infrastructure)
- **Certificate Authority (CA)** - Issues and manages digital certificates
- **Registration Authority (RA)** - Verifies identity before cert issuance
- **Certificate** - Binds public key to identity (X.509 standard)
- **Certificate Revocation List (CRL)** - List of revoked certificates
- **OCSP** - Online Certificate Status Protocol (real-time revocation check)
- **Certificate chain** - Root CA -> Intermediate CA -> End-entity cert

**Documentation:**
- **[📖 NIST SP 800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)** - Key management recommendations
- **[📖 NIST SP 800-175B](https://csrc.nist.gov/publications/detail/sp/800-175b/rev-1/final)** - Guideline for using cryptographic standards

## Secure Protocols

| Protocol | Port | Purpose | Replaces |
|----------|------|---------|----------|
| **HTTPS** | 443 | Secure web traffic | HTTP (80) |
| **SSH** | 22 | Secure remote access | Telnet (23) |
| **SFTP** | 22 | Secure file transfer | FTP (21) |
| **FTPS** | 990 | FTP over TLS | FTP (21) |
| **LDAPS** | 636 | Secure directory | LDAP (389) |
| **SNMPv3** | 161/162 | Secure network management | SNMPv1/v2 |
| **DNSSEC** | 53 | DNS integrity verification | DNS (53) |
| **IPsec** | 500/4500 | Network layer encryption | - |
| **TLS 1.2/1.3** | - | Transport encryption | SSL, TLS 1.0/1.1 |
| **S/MIME** | - | Secure email | - |
| **SRTP** | - | Secure real-time media | RTP |

## Network Security Devices

| Device | Function | OSI Layer |
|--------|----------|-----------|
| **Firewall** | Traffic filtering based on rules | Layer 3-4 (NGFW: 7) |
| **IDS** | Detect suspicious activity (alert) | Layer 3-7 |
| **IPS** | Detect and block suspicious activity | Layer 3-7 |
| **WAF** | Protect web applications | Layer 7 |
| **NAC** | Network access control and compliance | Layer 2-3 |
| **Proxy** | Intermediary for client requests | Layer 7 |
| **SIEM** | Security log aggregation and correlation | - |
| **SOAR** | Security orchestration and automated response | - |
| **UTM** | Unified threat management (all-in-one) | Layer 3-7 |
| **DLP** | Data loss prevention | Layer 3-7 |

## Incident Response

### IR Lifecycle (NIST SP 800-61)
1. **Preparation** - Policies, procedures, tools, training, communication plans
2. **Detection and Analysis** - Identify incidents, determine scope and severity
3. **Containment, Eradication, Recovery** - Limit damage, remove threat, restore systems
4. **Post-Incident Activity** - Lessons learned, documentation, process improvements

### Evidence Handling
- **Order of volatility**: Registers > Cache > RAM > Swap > Disk > Logs > Archives
- **Chain of custody**: Document who handled evidence and when
- **Legal hold**: Preserve relevant data for legal proceedings
- **Write blockers**: Prevent modification of original evidence
- **Imaging**: Create forensic copy (bit-for-bit) of evidence

**Documentation:**
- **[📖 NIST SP 800-61](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)** - Computer security incident handling guide
- **[📖 NIST SP 800-86](https://csrc.nist.gov/publications/detail/sp/800-86/final)** - Guide to integrating forensic techniques

## Risk Management

### Risk Concepts
- **Risk = Threat x Vulnerability x Impact**
- **Threat** - Potential danger to an asset
- **Vulnerability** - Weakness that can be exploited
- **Impact** - Business consequence if risk materializes
- **Likelihood** - Probability of risk occurring

### Risk Response Strategies
| Strategy | Description | Example |
|----------|-------------|---------|
| **Mitigate** | Reduce likelihood or impact | Install firewall, patch systems |
| **Accept** | Acknowledge and monitor risk | Low-impact risk within tolerance |
| **Transfer** | Shift risk to third party | Cyber insurance, SLA |
| **Avoid** | Eliminate the risk entirely | Stop using risky technology |

### Risk Assessment Methods
- **Qualitative** - Subjective ratings (High/Medium/Low)
- **Quantitative** - Numerical values (ALE = SLE x ARO)
  - **SLE** - Single Loss Expectancy
  - **ARO** - Annual Rate of Occurrence
  - **ALE** - Annualized Loss Expectancy

## Compliance and Frameworks

### Security Frameworks
| Framework | Type | Focus |
|-----------|------|-------|
| **NIST CSF** | Voluntary | Identify, Protect, Detect, Respond, Recover |
| **NIST RMF** | Required (federal) | Risk management lifecycle |
| **ISO 27001** | Certification | Information security management system |
| **CIS Controls** | Best practices | Prioritized security actions (18 controls) |
| **COBIT** | Governance | IT governance and management |
| **CSA CCM** | Cloud-specific | Cloud security controls matrix |

### Regulations
| Regulation | Scope | Key Requirements |
|------------|-------|------------------|
| **GDPR** | EU personal data | Consent, right to erasure, DPO, breach notification |
| **HIPAA** | US health data | PHI protection, business associate agreements |
| **PCI-DSS** | Payment cards | 12 requirements for cardholder data |
| **SOX** | US public companies | Financial reporting controls and audits |
| **FERPA** | US student records | Education records privacy |
| **GLBA** | US financial | Financial data privacy and security |

**Documentation:**
- **[📖 NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)** - CSF 2.0 documentation
- **[📖 CIS Controls](https://www.cisecurity.org/controls)** - Prioritized cybersecurity best practices
- **[📖 NIST SP 800-37](https://csrc.nist.gov/publications/detail/sp/800-37/rev-2/final)** - Risk Management Framework

## Vulnerability Management

### Process
1. **Discover** - Identify all assets in scope
2. **Scan** - Run vulnerability scans against assets
3. **Analyze** - Prioritize by CVSS score and business impact
4. **Remediate** - Patch, configure, or mitigate findings
5. **Verify** - Rescan to confirm remediation
6. **Report** - Document findings and remediation status

### CVSS (Common Vulnerability Scoring System)
| Score | Severity | Response |
|-------|----------|----------|
| 9.0-10.0 | Critical | Immediate remediation |
| 7.0-8.9 | High | Remediate within days |
| 4.0-6.9 | Medium | Remediate within weeks |
| 0.1-3.9 | Low | Remediate at next cycle |

## Common Exam Scenarios

1. **"Prevent unauthorized access"** - MFA, least privilege, zero trust, NAC
2. **"Protect data in transit"** - TLS 1.2+, VPN, IPsec, SSH
3. **"Detect malicious activity"** - SIEM, IDS/IPS, log analysis, behavioral analytics
4. **"Respond to incident"** - Follow IR lifecycle, contain first, preserve evidence
5. **"Comply with regulation"** - Match regulation to industry and data type
6. **"Reduce attack surface"** - Patch management, hardening, disable unused services
7. **"Secure remote access"** - VPN, MFA, zero trust, conditional access
8. **"Prevent data loss"** - DLP, encryption, access controls, classification
9. **"Assess risk"** - Identify threats and vulnerabilities, calculate impact
10. **"Verify identity"** - Certificate-based, biometric, MFA, federation

---

**Good luck on your exam!** Security+ is a mile wide and an inch deep - focus on understanding concepts rather than deep technical details.
