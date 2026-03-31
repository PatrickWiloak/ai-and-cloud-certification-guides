# Domain 1: General Security Concepts (12%)

## Overview
This domain covers foundational security principles including the CIA triad, AAA framework, zero trust architecture, defense in depth, threat actor types, social engineering, and basic cryptographic concepts. While the lightest domain by weight, these concepts underpin every other domain.

## CIA Triad

**[📖 NIST SP 800-12 - Introduction to Information Security](https://csrc.nist.gov/publications/detail/sp/800-12/rev-1/final)** - Foundational information security guide

### Confidentiality
- Preventing unauthorized disclosure of information
- Only authorized users can access sensitive data
- Data classification determines required protection level

**Controls:**
- Encryption (at rest and in transit)
- Access control lists (ACLs)
- File permissions and RBAC
- Data masking and tokenization
- Network segmentation
- Steganography (hiding data within other data)

**Threats to Confidentiality:**
- Eavesdropping and sniffing
- Data breaches and exfiltration
- Social engineering
- Improper access controls
- Shoulder surfing

### Integrity
- Ensuring data is not modified by unauthorized parties
- Data remains accurate and trustworthy
- Detect any unauthorized changes

**Controls:**
- Hashing (SHA-256, SHA-3) for change detection
- Digital signatures for authentication and non-repudiation
- Checksums and cyclic redundancy checks (CRC)
- Version control systems
- Database integrity constraints
- Write protection mechanisms

**Threats to Integrity:**
- Man-in-the-middle attacks
- Unauthorized data modification
- Malware that modifies files
- SQL injection attacks
- Configuration tampering

### Availability
- Ensuring systems and data are accessible when needed
- Authorized users can access resources on demand
- Systems maintain acceptable performance levels

**Controls:**
- Redundancy and high availability
- Load balancing
- DDoS protection
- Backup and disaster recovery
- Patch management (prevent exploitation causing downtime)
- Capacity planning and auto-scaling

**Threats to Availability:**
- DDoS attacks
- Hardware failures
- Natural disasters
- Ransomware
- Misconfiguration causing outages

### Non-Repudiation
- Unable to deny having performed an action
- Proof of origin and proof of delivery
- Critical for legal and compliance requirements

**Controls:**
- Digital signatures
- Audit logging
- Timestamps
- Certificate-based authentication
- Transaction logs

## AAA Framework

### Authentication - "Who are you?"
Verifying the identity of a user, device, or system.

**Authentication Factors:**
| Factor | Type | Examples |
|--------|------|----------|
| **Knowledge** | Something you know | Password, PIN, security questions |
| **Possession** | Something you have | Smart card, hardware token, phone |
| **Inherence** | Something you are | Fingerprint, facial recognition, retina |
| **Location** | Somewhere you are | GPS, IP address, geofencing |
| **Behavior** | Something you do | Typing patterns, gait analysis |

**Multi-Factor Authentication (MFA):**
- Requires two or more different factor types
- Password + SMS code = MFA (knowledge + possession)
- Password + security question = NOT MFA (both knowledge factors)
- Significantly reduces account compromise risk

**Authentication Protocols:**
- **Kerberos** - Ticket-based, used in Active Directory, port 88
- **NTLM** - Legacy Windows authentication (avoid if possible)
- **RADIUS** - Remote Authentication Dial-In User Service, port 1812/1813
- **TACACS+** - Terminal Access Controller, port 49, separates AAA functions
- **LDAP/LDAPS** - Directory-based authentication, port 389/636
- **SAML** - XML-based federation for SSO
- **OAuth 2.0** - Authorization framework (not authentication)
- **OpenID Connect (OIDC)** - Authentication layer on top of OAuth 2.0

### Authorization - "What can you do?"
Determining what resources an authenticated entity can access.

**Access Control Models:**
- **RBAC** (Role-Based) - Permissions based on job role
- **ABAC** (Attribute-Based) - Dynamic rules based on attributes
- **MAC** (Mandatory) - Labels and clearance levels (government/military)
- **DAC** (Discretionary) - Owner controls access
- **Rule-Based** - Predefined rules regardless of identity (time-based access)

### Accounting - "What did you do?"
Recording and monitoring user activities.

**Accounting Components:**
- Session logging (login/logout times)
- Resource access tracking
- Command and action logging
- Data transfer monitoring
- Changes and modifications audit trail
- Failed access attempt tracking

## Zero Trust Architecture

**[📖 NIST SP 800-207 - Zero Trust Architecture](https://csrc.nist.gov/publications/detail/sp/800-207/final)** - Comprehensive zero trust guidance

### Core Principles
1. **Never trust, always verify** - No implicit trust based on network location
2. **Assume breach** - Design as if attackers are already inside the network
3. **Verify explicitly** - Authenticate and authorize every request
4. **Least privilege access** - Minimum permissions needed for the task
5. **Micro-segmentation** - Fine-grained network zones
6. **Continuous validation** - Ongoing monitoring and re-authentication

### Key Components
- **Identity provider (IdP)** - Central authentication authority
- **Policy engine** - Makes access decisions based on context
- **Policy enforcement point** - Enforces access decisions
- **Continuous diagnostics** - Real-time monitoring of security posture
- **Data access policies** - Define who can access what, when, and how

### Implementation Approaches
- **Identity-centric** - Focus on strong identity verification
- **Network-centric** - Focus on micro-segmentation
- **Data-centric** - Focus on protecting data regardless of location
- **Combined approach** - Best practice, all three together

### Zero Trust vs Traditional Security
| Aspect | Traditional (Perimeter) | Zero Trust |
|--------|------------------------|------------|
| **Trust model** | Trust inside, verify outside | Never trust, always verify |
| **Network focus** | Perimeter defense (firewall) | Micro-segmentation |
| **Access** | VPN for remote, open internal | Identity-based, every request |
| **Assumption** | Inside is safe | Assume breach |
| **Verification** | At network entry | Continuous |

## Defense in Depth

### Layered Security Model

**Physical Layer:**
- Building security (locks, guards, cameras, mantraps)
- Server room access controls
- Cable locks and hardware security
- Environmental controls (fire suppression, HVAC)

**Network Layer:**
- Firewalls and network segmentation
- IDS/IPS
- VPN for encrypted tunnels
- Network Access Control (NAC)
- DDoS protection

**Host Layer:**
- Endpoint protection (antivirus, EDR)
- Host-based firewall
- Patch management
- OS hardening and secure configuration
- Application whitelisting

**Application Layer:**
- Input validation
- Secure coding practices
- WAF (Web Application Firewall)
- Code review and SAST/DAST
- API security

**Data Layer:**
- Encryption at rest and in transit
- Data classification and labeling
- Data Loss Prevention (DLP)
- Access controls and permissions
- Backup and recovery

**Administrative Layer:**
- Security policies and procedures
- Security awareness training
- Background checks
- Change management
- Incident response plans

### Security Control Types

| Type | Purpose | Examples |
|------|---------|---------|
| **Preventive** | Stop threats before they occur | Firewall, access controls, encryption |
| **Detective** | Identify threats that have occurred | IDS, SIEM, log analysis, audit |
| **Corrective** | Fix after an incident | Patch management, restore from backup |
| **Deterrent** | Discourage threat actors | Warning banners, security cameras |
| **Compensating** | Alternative when primary control not feasible | Monitoring when patching is delayed |
| **Directive** | Guide behavior through policy | Acceptable use policy, training |

### Control Categories

| Category | Description | Examples |
|----------|-------------|---------|
| **Technical** | Implemented by technology | Firewalls, encryption, IDS, MFA |
| **Administrative** | Policies and procedures | Training, background checks, policies |
| **Physical** | Tangible, physical measures | Locks, cameras, guards, fencing |

## Threat Actors

### Threat Actor Types

**Nation-State (APT):**
- Government-sponsored attackers
- Highly sophisticated with extensive resources
- Motivations: espionage, sabotage, political influence
- Tactics: Zero-day exploits, supply chain attacks, persistent access
- Examples: APT29, APT28, Lazarus Group

**Organized Crime:**
- Financially motivated criminal groups
- Sophisticated tools and techniques
- Motivations: Financial gain, extortion
- Tactics: Ransomware, business email compromise, card fraud
- Well-funded with specialized roles

**Hacktivists:**
- Politically or socially motivated attackers
- Moderate sophistication
- Motivations: Ideology, political change, social cause
- Tactics: DDoS, website defacement, data leaks
- Examples: Anonymous (historical)

**Insider Threats:**
- Current or former employees, contractors, partners
- Have legitimate access to systems
- Motivations: Revenge, financial gain, negligence, coercion
- Types: Malicious (intentional) vs negligent (accidental)
- Most dangerous due to existing access and knowledge

**Script Kiddies:**
- Low-skill attackers using pre-built tools
- Motivations: Curiosity, bragging rights, notoriety
- Limited resources and capabilities
- Use publicly available exploit tools and scripts
- Can still cause significant damage with automated tools

**Shadow IT:**
- Employees using unauthorized technology
- Creates unmonitored attack surface
- Examples: Personal cloud storage, unapproved SaaS tools
- Risk: Data exposure, compliance violations

## Social Engineering Fundamentals

### Principles of Social Engineering
- **Authority** - Impersonating someone in power
- **Urgency** - Creating time pressure to bypass rational thinking
- **Social proof** - "Everyone else is doing it"
- **Familiarity/Liking** - Building rapport and trust
- **Scarcity** - Limited availability creates desire to act
- **Intimidation** - Using threats or fear
- **Consensus** - Leveraging group behavior

### Key Social Engineering Attacks
- **Phishing** - Mass fraudulent emails
- **Spear phishing** - Targeted at specific individuals
- **Whaling** - Targeting executives/senior leaders
- **Vishing** - Voice/phone-based social engineering
- **Smishing** - SMS-based social engineering
- **Pretexting** - Creating a fabricated scenario
- **Baiting** - Offering something enticing (infected USB drives)
- **Tailgating/Piggybacking** - Following authorized person through secured door
- **Watering hole** - Compromising websites frequently visited by targets
- **Typosquatting** - Registering misspelled domain names

## Change Management and Security

### Why Change Management Matters for Security
- Unauthorized changes are a leading cause of security incidents
- Changes can introduce new vulnerabilities
- Proper testing prevents security regressions
- Documentation maintains security posture visibility
- Rollback capability ensures recovery from bad changes

### Security Impact of Changes
- **Application updates** - May introduce new vulnerabilities
- **Configuration changes** - May weaken security controls
- **Network changes** - May expose previously isolated resources
- **Access changes** - May grant excessive permissions
- **Infrastructure changes** - May create new attack surfaces

## Basic Cryptographic Concepts

### Symmetric Encryption
- Same key for both encryption and decryption
- Fast and efficient for large data volumes
- Challenge: Secure key distribution
- **AES** (Advanced Encryption Standard) - 128/192/256-bit, current standard
- **3DES** - Triple DES, legacy, being phased out
- **Blowfish/Twofish** - Alternative symmetric algorithms

### Asymmetric Encryption
- Key pair: public key (encrypt) and private key (decrypt)
- Slower than symmetric, used for key exchange and digital signatures
- Solves the key distribution problem
- **RSA** - 2048/4096-bit, widely used
- **ECC** - Smaller key sizes for equivalent security
- **Diffie-Hellman (DH/ECDH)** - Key exchange protocol

### Hashing
- One-way function producing fixed-length output (digest)
- Cannot reverse hash to get original data
- Same input always produces same output
- Small change in input produces completely different output (avalanche effect)
- **SHA-256/SHA-3** - Current standard for integrity verification
- **MD5** - Deprecated due to collisions (still seen in legacy systems)
- **bcrypt/Argon2** - Password hashing with salt and work factor

### Digital Signatures
- Hash the message, then encrypt hash with sender's private key
- Provides: authentication, integrity, non-repudiation
- Recipient decrypts with sender's public key to verify
- Does NOT provide confidentiality (message itself is not encrypted)

### Key Concepts
- **Key length** - Longer keys = stronger encryption
- **Key exchange** - Diffie-Hellman, RSA key transport
- **Key escrow** - Third party holds copy of encryption keys
- **Key stretching** - Make weak passwords stronger (PBKDF2, bcrypt)
- **Salt** - Random data added before hashing to prevent rainbow table attacks
- **Nonce** - Number used once to prevent replay attacks
- **IV** - Initialization vector for encryption randomness

---

## Key Takeaways for the Exam

1. Know CIA triad - which controls protect each principle
2. Understand MFA requires different factor TYPES (not just two passwords)
3. Zero trust: "never trust, always verify" - applies everywhere, not just network edge
4. Defense in depth uses multiple layers - physical, network, host, application, data
5. Know control types (preventive, detective, corrective) and categories (technical, administrative, physical)
6. Identify threat actors by motivation and sophistication level
7. Social engineering exploits human psychology, not technology
8. Know symmetric (fast, same key) vs asymmetric (slow, key pair) vs hashing (one-way)
