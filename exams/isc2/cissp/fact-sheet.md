# CISSP Fact Sheet

## Exam Logistics

| Item | Detail (English CAT) | Detail (Linear) |
|------|----------------------|-----------------|
| Exam Code | CISSP | CISSP |
| Format | Computerized Adaptive Testing (CAT) | Linear, fixed-form |
| Duration | 3 hours | 6 hours |
| Question Count | 100 to 150 | 250 |
| Passing Score | 700 / 1000 (scaled) | 700 / 1000 (scaled) |
| Cost (USD) | $749 | $749 |
| Languages | English | Chinese, German, Japanese, Korean, Spanish, French, Brazilian Portuguese |
| Delivery | Pearson VUE only | Pearson VUE only |
| Retake Wait | 30 days first retake, 60 days second, 90 days third (max 4 attempts in 12 months) | Same |
| Validity | 3 years | 3 years |
| Maintenance | 120 CPE / 3 years (40 CPE/yr min) + $135/yr AMF | Same |

## Domain Weights (2024 Refresh)

| Domain | Weight |
|--------|--------|
| 1. Security and Risk Management | 16% |
| 2. Asset Security | 10% |
| 3. Security Architecture and Engineering | 13% |
| 4. Communication and Network Security | 13% |
| 5. Identity and Access Management (IAM) | 13% |
| 6. Security Assessment and Testing | 12% |
| 7. Security Operations | 13% |
| 8. Software Development Security | 10% |

## Eligibility

| Path | Requirement |
|------|-------------|
| Standard | 5 years of cumulative, paid work experience in 2 or more CBK domains |
| Degree waiver | A 4-year college degree (or regional equivalent) or approved credential waives 1 year (4 years required) |
| Approved credential waiver list | CCSP, SSCP, CISA, CISM, CRISC, GIAC GSEC, etc. - full list at isc2.org |
| Associate of ISC2 | Pass exam without required experience; 6 years to gain experience |

## Computerized Adaptive Testing (CAT) Mechanics

- Algorithm tailors next question difficulty to candidate's running ability estimate
- Score after each question, with confidence interval
- Exam ends when:
  - Algorithm has 95% confidence in pass/fail (most candidates around 100 questions)
  - Maximum 150 questions reached
  - 3-hour time limit reached
- 25 of the 100 to 150 questions are unscored "pre-test" items used for future calibration; you cannot identify them
- You CANNOT skip or return to previous questions
- Only available in English; non-English candidates take the linear 6-hour, 250-question form

## Question Types

- Multiple choice (MC) - one correct from four options (the majority)
- Drag and drop - sequence steps or match items
- Hotspot - click an area on a diagram

## Code of Ethics (Memorize)

ISC2 Code of Ethics canons (in priority order):

1. Protect society, the common good, necessary public trust and confidence, and the infrastructure
2. Act honorably, honestly, justly, responsibly, and legally
3. Provide diligent and competent service to principals
4. Advance and protect the profession

When ethics questions appear, choose the answer aligned with the highest applicable canon (society > honor > diligent service > profession).

## Key Frameworks to Know

| Framework | Domain Focus |
|-----------|--------------|
| NIST CSF | Risk management overall |
| NIST RMF (SP 800-37) | Risk Management Framework lifecycle |
| NIST SP 800-53 | Security and privacy controls |
| NIST SP 800-37 | RMF |
| NIST SP 800-30 | Risk assessment |
| NIST SP 800-61 | Incident handling |
| NIST SP 800-88 | Media sanitization |
| NIST SP 800-115 | Security testing and assessment |
| ISO/IEC 27001 | ISMS |
| ISO/IEC 27002 | Controls catalog |
| ISO/IEC 27005 | Risk management |
| ISO/IEC 27017 | Cloud security |
| ISO/IEC 27018 | Cloud privacy |
| ISO/IEC 27701 | PIMS |
| ISO/IEC 31000 | Risk management general |
| COBIT 2019 | IT governance |
| ITIL 4 | Service management |
| OCTAVE | Risk assessment |
| FAIR | Quantitative risk analysis |
| TOGAF/SABSA | Enterprise/security architecture |
| Zachman | Enterprise architecture |

## Security Models

| Model | Property | Notes |
|-------|----------|-------|
| Bell-LaPadula | Confidentiality | No read up, no write down (simple/star) |
| Biba | Integrity | No read down, no write up (inverse of BLP) |
| Clark-Wilson | Integrity | Well-formed transactions, separation of duties (subject-program-object) |
| Brewer-Nash (Chinese Wall) | Conflict of interest | Dynamic, based on prior access |
| Take-Grant | Access control | Token-based rights propagation |
| HRU (Harrison-Ruzzo-Ullman) | Access control | Access matrix, undecidable |
| Graham-Denning | Access control | 8 protection rules |
| Lattice | Access control | Mathematical sets, basis of MAC |
| Non-interference | Confidentiality | Higher-level activity does not affect lower |
| Information Flow | Confidentiality and integrity | Direction-based controls |

## Common Cryptographic Standards

| Algorithm | Type | Key Length | Notes |
|-----------|------|-----------|-------|
| AES | Symmetric block | 128/192/256 | NIST standard, replaces DES/3DES |
| 3DES | Symmetric block | 168 (effective 112) | Deprecated |
| ChaCha20 | Symmetric stream | 256 | Modern stream cipher, often paired with Poly1305 |
| RSA | Asymmetric | 2048+ | Key exchange and signing |
| ECC | Asymmetric | 256+ | Smaller keys, equivalent strength |
| ECDSA | Asymmetric signing | 256+ | ECC-based digital signature |
| Diffie-Hellman | Key agreement | 2048+ | Provides PFS when ephemeral |
| ECDH | Key agreement | 256+ | Elliptic curve DH |
| SHA-256 / SHA-3 | Hash | 256 | Current standard |
| SHA-1, MD5 | Hash | 160 / 128 | Deprecated, collision-vulnerable |
| HMAC | MAC | Variable | Key + hash for authenticated integrity |
| bcrypt, scrypt, Argon2 | Password hash | Variable | Use for password storage |
| PBKDF2 | Password hash | Variable | Older but acceptable |

## Risk Management Formulas

- **SLE** (Single Loss Expectancy) = Asset Value (AV) x Exposure Factor (EF)
- **ALE** (Annualized Loss Expectancy) = SLE x ARO (Annualized Rate of Occurrence)
- **Risk** = Likelihood x Impact (qualitative)
- **Residual Risk** = Inherent Risk - Controls

## BCP/DR Recovery Metrics

- **RTO** (Recovery Time Objective) - Max acceptable downtime
- **RPO** (Recovery Point Objective) - Max acceptable data loss
- **MTD** (Maximum Tolerable Downtime) - Hard ceiling; RTO must be less
- **WRT** (Work Recovery Time) - Time to restore data and validate after RTO
- **MTTR** (Mean Time to Repair) - Average repair time
- **MTBF** (Mean Time Between Failures) - Reliability metric
- **MTTF** (Mean Time to Failure) - For non-repairable items

## Site Recovery Options

| Site | Cost | Setup Time | Notes |
|------|------|-----------|-------|
| Cold | Lowest | Weeks | Empty space, utilities only |
| Warm | Medium | Days | Partial equipment, no data |
| Hot | High | Hours | Fully operational, current data |
| Mirrored | Highest | Real-time | Active-active, near-zero RTO/RPO |
| Reciprocal/Mutual aid | Lowest | Days | Agreement with another org |
| Cloud DR | Variable | Hours | DRaaS |

## Authentication Factor Types

- **Type 1** - Something you know (password, PIN)
- **Type 2** - Something you have (token, smart card)
- **Type 3** - Something you are (biometric)
- **Type 4** - Something you do (behavior)
- **Type 5** - Somewhere you are (location, geofence)

MFA = at least two different factor types. Two of the same type does not count.

## Access Control Models

- **DAC** - Discretionary; owner decides (Windows ACLs)
- **MAC** - Mandatory; system enforces labels (military)
- **RBAC** - Role-based; permissions via roles
- **ABAC** - Attribute-based; rules over user/resource/env attrs
- **RuBAC** - Rule-based; firewalls, ACLs
- **Risk-based / Adaptive** - Decisions based on contextual risk
- **HRBAC** - Hierarchical role-based

## OSI Model Quick Reference

| Layer | Name | Examples | PDU |
|-------|------|----------|-----|
| 7 | Application | HTTP, SMTP, DNS, FTP | Data |
| 6 | Presentation | TLS, JPEG, ASCII | Data |
| 5 | Session | NetBIOS, RPC, PPTP | Data |
| 4 | Transport | TCP, UDP, SCTP | Segment |
| 3 | Network | IP, ICMP, IPsec, OSPF | Packet |
| 2 | Data Link | Ethernet, ARP, PPP | Frame |
| 1 | Physical | Cables, NIC | Bit |

Mnemonic top-down: All People Seem To Need Data Processing.

## Penetration Test Knowledge Levels

- **Black box** - Tester knows nothing
- **Gray box** - Partial knowledge
- **White box** (crystal box) - Full knowledge

## Investigation Types and Evidence Standards

| Type | Standard of Proof |
|------|-------------------|
| Criminal | Beyond a reasonable doubt |
| Civil | Preponderance of the evidence |
| Regulatory | Industry-defined |
| Administrative | More likely than not |

Evidence types: real, documentary, testimonial, demonstrative. Best evidence rule: original preferred.

## Privacy Regulations

- **GDPR** (EU) - $20M or 4% global turnover; data subject rights, DPO, breach notification 72 hours
- **CCPA / CPRA** (California) - opt-out, opt-in for under 16
- **HIPAA** (US healthcare) - PHI protection, BAA required
- **GLBA** (US financial) - safeguards, privacy rule
- **SOX** (US public companies) - financial controls
- **PCI DSS** (payment cards) - 12 requirements, contractual not legal
- **FERPA** (US education)
- **COPPA** (US children online)
- **PIPEDA** (Canada)
- **LGPD** (Brazil)
- **POPIA** (South Africa)
- **APPI** (Japan)

## Official Documentation Links

- **ISC2 CISSP page:** https://www.isc2.org/certifications/cissp
- **Exam outline:** https://www.isc2.org/certifications/cissp/cissp-exam-outline
- **NIST publications:** https://csrc.nist.gov/publications
- **ISO standards catalog:** https://www.iso.org/standards.html

## CPE Categories

- **Group A** - Directly related to information security (75 CPEs minimum over 3 years)
- **Group B** - Professional development not security-specific (up to 45 CPEs)

Earned via: training, conferences, webinars, podcasts, books, articles, teaching, volunteering, exam authoring.
