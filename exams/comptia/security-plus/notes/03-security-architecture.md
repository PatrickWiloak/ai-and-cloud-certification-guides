# Domain 3: Security Architecture (18%)

## Overview
This domain covers security implications of different architecture models, network security infrastructure, cryptographic implementations, secure protocols, cloud security, and resilience and recovery concepts. Understanding how security is built into architecture is essential for both defense and exam success.

## Network Security Devices

**[📖 NIST SP 800-41 - Firewall Guidelines](https://csrc.nist.gov/publications/detail/sp/800-41/rev-1/final)** - Guidelines on firewalls and firewall policy

### Firewalls

**Packet Filtering Firewall:**
- Operates at Layer 3-4 (network/transport)
- Filters based on source/destination IP, ports, protocol
- Stateless - each packet evaluated independently
- Fast but limited security capabilities

**Stateful Inspection Firewall:**
- Tracks connection state (established, new, related)
- Maintains connection table for context
- More secure than packet filtering
- Can identify TCP session anomalies

**Next-Generation Firewall (NGFW):**
- Deep packet inspection at Layer 7 (application)
- Application awareness and control
- Integrated IPS, threat intelligence
- User identity-based policies
- URL and content filtering
- SSL/TLS inspection capability

**Web Application Firewall (WAF):**
- Specifically protects web applications
- Operates at Layer 7 (HTTP/HTTPS)
- Defends against OWASP Top 10 attacks
- SQL injection, XSS, CSRF protection
- Custom rules and managed rule sets
- Can be cloud-based, on-premises, or inline

### Intrusion Detection and Prevention

**IDS (Intrusion Detection System):**
- Monitors network traffic for suspicious activity
- Generates alerts but does NOT block traffic
- Passive - receives copy of traffic (mirror port/TAP)
- False positives require investigation

**IPS (Intrusion Prevention System):**
- Monitors AND blocks suspicious traffic
- Inline deployment - traffic flows through it
- Active - can drop or modify malicious packets
- Risk of false positives blocking legitimate traffic

**Detection Methods:**
| Method | Description | Strengths | Weaknesses |
|--------|-------------|-----------|------------|
| **Signature-based** | Match known attack patterns | Accurate for known threats | Cannot detect zero-day |
| **Anomaly-based** | Detect deviation from baseline | Can detect unknown threats | Higher false positive rate |
| **Behavior-based** | Analyze behavior patterns | Detects novel attacks | Requires tuning |
| **Heuristic** | Rule-based analysis | Flexible detection | Complex to configure |

### Network Access Control (NAC)
- Controls device access to the network
- Checks device compliance before granting access
- **Pre-admission** - Verify before connecting
- **Post-admission** - Monitor after connection
- Checks: AV status, patch level, configuration compliance
- Non-compliant devices placed in quarantine VLAN
- Protocol: 802.1X for port-based authentication

### Proxy Servers

**Forward Proxy:**
- Sits between internal users and internet
- Filters outbound web requests
- Caches content for performance
- Provides anonymity for internal users
- URL filtering and content inspection

**Reverse Proxy:**
- Sits between internet and internal servers
- Protects backend servers from direct access
- Load balancing across multiple servers
- SSL termination
- WAF functionality

### Other Security Devices

**UTM (Unified Threat Management):**
- All-in-one security appliance
- Combines: firewall, IDS/IPS, antivirus, content filtering, VPN
- Suitable for small to medium businesses
- Single point of management but also single point of failure

**SIEM (Security Information and Event Management):**
- Collects and correlates logs from multiple sources
- Real-time alerting on security events
- Historical log analysis and reporting
- Compliance reporting
- Examples: Splunk, Microsoft Sentinel, IBM QRadar

**SOAR (Security Orchestration, Automation, and Response):**
- Automates repetitive security tasks
- Playbooks for incident response
- Integrates with SIEM and other security tools
- Reduces mean time to respond (MTTR)

## Cryptography in Practice

### Symmetric Encryption Algorithms

| Algorithm | Key Size | Block Size | Status |
|-----------|----------|------------|--------|
| **AES** | 128/192/256 bit | 128 bit | Current standard |
| **3DES** | 168 bit (effective 112) | 64 bit | Deprecated |
| **ChaCha20** | 256 bit | Stream cipher | Modern, used in TLS |
| **Blowfish** | 32-448 bit | 64 bit | Legacy |
| **Twofish** | 128/192/256 bit | 128 bit | AES finalist |

**Block Cipher Modes:**
- **ECB** - Electronic Codebook (insecure, patterns visible)
- **CBC** - Cipher Block Chaining (secure, sequential)
- **CTR** - Counter mode (parallelizable)
- **GCM** - Galois/Counter Mode (authenticated encryption, recommended)

### Asymmetric Encryption Algorithms

| Algorithm | Key Size | Use Case | Status |
|-----------|----------|----------|--------|
| **RSA** | 2048/4096 bit | Encryption, signatures, key exchange | Widely used |
| **ECC** | 256/384 bit | Signatures, key exchange | More efficient than RSA |
| **Diffie-Hellman** | 2048+ bit | Key exchange only | Foundation of TLS |
| **ECDH** | 256+ bit | Key exchange | Preferred over DH |
| **DSA** | 2048+ bit | Digital signatures only | Being replaced by ECDSA |
| **EdDSA** | 256 bit | Digital signatures | Modern, efficient |

### Hashing Algorithms

| Algorithm | Output Size | Status | Use Case |
|-----------|-------------|--------|----------|
| **SHA-256** | 256 bit | Current standard | Integrity verification |
| **SHA-3** | 224-512 bit | Current standard | Next-gen hashing |
| **SHA-1** | 160 bit | Deprecated | Legacy compatibility |
| **MD5** | 128 bit | Broken | Legacy only (NOT for security) |
| **bcrypt** | 184 bit | Recommended | Password hashing |
| **Argon2** | Variable | Recommended | Password hashing (newest) |
| **PBKDF2** | Variable | Acceptable | Key derivation, passwords |

### Key Exchange Methods
- **Diffie-Hellman (DH)** - Allows two parties to establish shared secret over insecure channel
- **ECDH** - Elliptic curve variant of DH (smaller keys, same security)
- **RSA key transport** - Encrypt symmetric key with recipient's public key
- **Perfect Forward Secrecy (PFS)** - Use ephemeral keys so compromising long-term key doesn't expose past sessions

## Public Key Infrastructure (PKI)

**[📖 NIST SP 800-57 - Key Management Recommendations](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)** - Key management guidance

### PKI Components
- **Certificate Authority (CA)** - Issues, signs, and manages certificates
- **Registration Authority (RA)** - Verifies identity of certificate requestors
- **Certificate Revocation List (CRL)** - Published list of revoked certificates
- **OCSP (Online Certificate Status Protocol)** - Real-time certificate status checking
- **OCSP stapling** - Server includes OCSP response with certificate (faster)
- **Certificate repository** - Storage for issued certificates and CRLs

### Certificate Types
| Type | Purpose | Validation |
|------|---------|-----------|
| **DV (Domain Validation)** | Basic encryption, domain ownership | Domain only |
| **OV (Organization Validation)** | Business identity verification | Organization verified |
| **EV (Extended Validation)** | Highest trust, green bar (legacy) | Extensive verification |
| **Wildcard** | All subdomains (*.example.com) | Domain + subdomains |
| **SAN (Subject Alternative Name)** | Multiple domains on one cert | Specified domains |
| **Self-signed** | Internal/testing use | No external verification |
| **Code signing** | Verify software publisher | Developer identity |

### Certificate Lifecycle
1. **Key generation** - Create public/private key pair
2. **CSR (Certificate Signing Request)** - Request with public key and identity
3. **Issuance** - CA validates and signs the certificate
4. **Installation** - Deploy certificate on server/device
5. **Monitoring** - Track expiration, verify validity
6. **Renewal** - Generate new certificate before expiration
7. **Revocation** - Invalidate compromised or unnecessary certificates

### Certificate Chain of Trust
```
Root CA (self-signed, stored in trust stores)
  └── Intermediate CA (signed by Root CA)
        └── End-Entity Certificate (signed by Intermediate CA)
```
- Browsers/OS maintain trusted root CA lists
- Chain must be complete and verifiable
- Root CA kept offline for security

## Secure Protocols

### TLS (Transport Layer Security)

**TLS 1.2:**
- Current minimum acceptable version
- Supports multiple cipher suites
- RSA and ECDHE key exchange
- AES-GCM and ChaCha20 encryption

**TLS 1.3:**
- Latest version, improved security and performance
- Removed insecure algorithms (RC4, 3DES, MD5)
- Mandatory Perfect Forward Secrecy (ECDHE)
- Reduced handshake (1-RTT vs 2-RTT)
- 0-RTT resumption for returning connections

**TLS Handshake (simplified):**
1. Client Hello - supported cipher suites, TLS version
2. Server Hello - selected cipher suite, server certificate
3. Key Exchange - establish shared secret
4. Finished - encrypted communication begins

### IPsec
- Network layer (Layer 3) encryption
- Two modes:
  - **Transport mode** - Encrypts payload only, original header intact
  - **Tunnel mode** - Encrypts entire original packet, new header added
- Protocols:
  - **AH** (Authentication Header) - Integrity and authentication only
  - **ESP** (Encapsulating Security Payload) - Encryption + integrity + authentication
- **IKE** (Internet Key Exchange) - Establishes security association
- Ports: UDP 500 (IKE), UDP 4500 (NAT traversal), IP protocol 50 (ESP), 51 (AH)

### Secure vs Insecure Protocol Pairs
| Insecure | Secure Replacement | Port Change |
|----------|-------------------|-------------|
| HTTP (80) | HTTPS (443) | TLS encryption |
| Telnet (23) | SSH (22) | Encrypted terminal |
| FTP (21) | SFTP (22) or FTPS (990) | Encrypted file transfer |
| SNMP v1/v2 (161) | SNMPv3 (161) | Authentication + encryption |
| LDAP (389) | LDAPS (636) | TLS encryption |
| DNS (53) | DNSSEC (53) or DoH (443) | Integrity/encryption |
| SMTP (25) | SMTPS (465/587) | TLS encryption |
| POP3 (110) | POP3S (995) | TLS encryption |
| IMAP (143) | IMAPS (993) | TLS encryption |

## Cloud Security Models

### Shared Responsibility Model
- Provider responsible for security OF the cloud (infrastructure)
- Customer responsible for security IN the cloud (data, access, configuration)
- Boundary shifts with service model (IaaS vs PaaS vs SaaS)

### Cloud Security Technologies

**CASB (Cloud Access Security Broker):**
- Intermediary between users and cloud services
- Visibility into cloud usage and shadow IT
- Policy enforcement for cloud applications
- Data loss prevention for cloud data
- Deployment: Forward proxy, reverse proxy, or API-based

**SASE (Secure Access Service Edge):**
- Combines network and security functions in cloud
- Components: SD-WAN, CASB, ZTNA, FWaaS, SWG
- Network security delivered as a service
- Reduces need for on-premises security appliances

**ZTNA (Zero Trust Network Access):**
- Application-level access control
- Replaces traditional VPN
- Identity-verified access to specific applications
- No network-level access granted

**SWG (Secure Web Gateway):**
- Filters web traffic for threats
- URL filtering and malicious content blocking
- SSL inspection capabilities
- Protection against web-based threats

## Network Architecture Security

### Network Segmentation
- Divide network into separate zones
- Control traffic flow between zones
- Limit lateral movement of attackers

**Common Zones:**
- **DMZ** - Demilitarized zone for public-facing services
- **Internal** - Corporate network for employees
- **Guest** - Isolated network for visitors
- **IoT** - Separate network for IoT devices
- **Management** - Restricted network for admin access

### Micro-Segmentation
- Fine-grained security policies within a network segment
- Control east-west (internal) traffic
- Policy applied at workload level
- Key zero trust implementation technique

### Software-Defined Networking (SDN)
- Separates control plane from data plane
- Centralized network management
- Programmable network configuration
- Dynamic security policy enforcement

## Resilience and Recovery

### High Availability
- **Geographic dispersal** - Resources in multiple locations
- **Load balancing** - Distribute across healthy instances
- **Clustering** - Active-active or active-passive
- **Redundant storage** - RAID levels for disk redundancy

### RAID Levels
| Level | Description | Min Disks | Fault Tolerance |
|-------|-------------|-----------|-----------------|
| **RAID 0** | Striping (no redundancy) | 2 | None |
| **RAID 1** | Mirroring | 2 | 1 disk failure |
| **RAID 5** | Striping with parity | 3 | 1 disk failure |
| **RAID 6** | Striping with double parity | 4 | 2 disk failures |
| **RAID 10** | Mirroring + striping | 4 | 1 per mirror |

### Backup Strategies
| Type | Description | Speed | Storage |
|------|-------------|-------|---------|
| **Full** | Complete copy of all data | Slowest backup, fastest restore | Most |
| **Incremental** | Only changes since last backup | Fastest backup, slowest restore | Least |
| **Differential** | Changes since last full backup | Medium backup, medium restore | Medium |
| **Snapshot** | Point-in-time copy of storage | Fast, storage-efficient | Variable |

### Backup Best Practices
- **3-2-1 Rule**: 3 copies, 2 different media types, 1 offsite
- Test restore procedures regularly
- Encrypt backup data
- Immutable backups for ransomware protection
- Define retention policies per compliance requirements

### Disaster Recovery
- **RTO** (Recovery Time Objective) - Maximum acceptable downtime
- **RPO** (Recovery Point Objective) - Maximum acceptable data loss
- **DR site types**: Hot (immediate), warm (hours), cold (days)
- Test DR plans regularly (tabletop, simulation, full test)

---

## Key Takeaways for the Exam

1. Know firewall types and what layer they operate at (NGFW = Layer 7)
2. IDS detects and alerts; IPS detects and blocks - know the difference
3. Know symmetric (AES) vs asymmetric (RSA, ECC) vs hashing (SHA-256) algorithms
4. Understand PKI: CA issues certs, CRL/OCSP for revocation, chain of trust
5. Know secure protocol replacements (Telnet->SSH, FTP->SFTP, HTTP->HTTPS)
6. TLS 1.3 improvements: mandatory PFS, fewer round trips, removed weak algorithms
7. Cloud security: CASB for visibility, SASE for network+security, ZTNA for app access
8. Backup types: full (complete), incremental (since last any backup), differential (since last full)
