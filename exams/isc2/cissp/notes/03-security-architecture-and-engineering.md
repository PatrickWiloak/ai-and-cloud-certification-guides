# 03 - Security Architecture and Engineering (Domain 3, 13%)

## Domain Overview

Domain 3 covers how security is built into systems: architecture principles, security models, hardware/software security primitives, cryptography, and physical security. It contains some of the most memorization-heavy material on the exam, especially around cryptographic algorithms and security models.

## Secure Design Principles

These principles guide architecture decisions and frequently appear in scenario questions:

- **Least privilege** - Grant the minimum access needed
- **Defense in depth** - Multiple, layered controls
- **Fail secure / fail safe** - Default to denial on error (fail-safe favors safety; fail-secure favors security; not always synonymous)
- **Separation of duties (SoD)** - No single person can complete a sensitive transaction
- **Two-person integrity** - Two people required for critical action (e.g., nuclear launch, key ceremony)
- **Need-to-know** - Access only to information necessary for one's job
- **Open design (Kerckhoffs)** - Security through algorithm secrecy fails; security must rely on key secrecy
- **Economy of mechanism** - Simple, easy-to-verify designs
- **Complete mediation** - Every access checked
- **Psychological acceptability** - Users will work around painful controls
- **Least common mechanism** - Minimize shared mechanisms across users
- **Trust but verify** - Older model
- **Zero trust** - Never trust, always verify, assume breach
- **Privacy by design** - Privacy baked in, not bolted on
- **Secure by default** - Out-of-box configuration is secure; users must explicitly weaken
- **Shared responsibility** - Cloud and outsourced models

## Security Models

Security models formalize policy. CISSP requires distinguishing several:

### Bell-LaPadula (BLP)
- Confidentiality model
- Multi-level security (MLS)
- **Simple Security Property (ss-property)**: No read up
- **Star Property (*-property)**: No write down
- **Strong Star Property**: No read or write at different levels
- Use case: military classified data

### Biba
- Integrity model
- Mirror image of BLP
- **Simple Integrity Property**: No read down
- **Star Integrity Property**: No write up
- **Invocation Property**: Subject cannot invoke higher integrity subjects
- Use case: integrity-critical data

### Clark-Wilson
- Integrity model emphasizing well-formed transactions and separation of duties
- Subject -> Program -> Object (transformation procedures, TPs)
- Constrained data items (CDIs) and unconstrained data items (UDIs)
- Integrity verification procedures (IVPs)
- Use case: commercial integrity (banking, accounting)

### Brewer-Nash (Chinese Wall)
- Conflict-of-interest model
- Dynamic access based on prior accesses
- Use case: consulting firms with competitive clients

### Take-Grant
- Token-based rights propagation
- Operations: take, grant, create, revoke

### Harrison-Ruzzo-Ullman (HRU)
- Access matrix model
- Proves general safety problem is undecidable

### Graham-Denning
- 8 protection rules for create/delete subject/object, transfer rights, etc.

### Lattice-Based Access Control
- Mathematical model where subjects/objects are at lattice nodes
- Foundation for MAC

### Non-interference
- Higher-level activity does not affect lower-level observations
- Confidentiality property

### Information Flow
- Direction-based controls preventing flow violations
- BLP and Biba can both be modeled as information flow

## System Security Capabilities

### Trusted Computing Base (TCB)
- All hardware, software, and firmware components critical to security policy enforcement
- Must be trusted; compromise of TCB compromises security
- Smaller TCB is easier to evaluate

### Reference Monitor
- Abstract concept enforcing access control
- Must be: tamperproof, always invoked, small enough to verify
- Implemented as the security kernel

### Security Kernel
- Hardware, firmware, software implementing the reference monitor

### Trusted Computing
- TPM (Trusted Platform Module) - hardware root of trust, secure key storage, attestation
- Secure boot - chain of trust from firmware to OS
- HSM (Hardware Security Module) - tamper-resistant cryptographic processing
- Secure enclaves: Intel SGX, AMD SEV, ARM TrustZone, Apple Secure Enclave

### Common Criteria (ISO/IEC 15408)
- Evaluation Assurance Levels (EAL1 to EAL7)
- Protection Profiles (PP) - implementation-independent requirements
- Security Targets (ST) - specific product claims
- Targets of Evaluation (TOE) - product being evaluated
- Higher EAL = more rigorous evaluation, NOT necessarily more secure

### TCSEC (Orange Book) - historical context
- Replaced by Common Criteria
- Levels A1, B3, B2, B1, C2, C1, D

## System Architecture Vulnerabilities

### Client-server
- Trust boundary at network
- Threats: MITM, replay, server compromise

### Distributed systems
- Microservices: more attack surface, complex auth
- API gateways, service mesh (mTLS, identity)

### IoT
- Resource-constrained: limited crypto, often no patching
- Long lifespans, often deployed in physically accessible locations
- Default credentials, weak update mechanisms
- Standards: NIST IR 8259, ISO/IEC 27400

### Industrial Control Systems (ICS) and SCADA
- Purdue model: levels 0 to 5 from physical process to enterprise
- Long lifecycle (decades), patching difficult
- Safety > security trade-offs
- Standards: IEC 62443

### Cloud
- Shared responsibility model varies by service model:
  - **IaaS**: customer responsible OS up
  - **PaaS**: customer responsible apps and data
  - **SaaS**: customer responsible identity and data classification
- Multi-tenancy, side-channel risks
- Vendor lock-in
- Compliance (data residency, sovereignty)

### Containers
- Shared kernel; escape risk
- Image scanning and signing required
- Runtime threat detection
- Pod security standards (Kubernetes)

### Serverless
- No server to patch but execution context still requires security
- IAM permissions per function
- Cold start telemetry visibility limits
- Dependency vulnerabilities still apply

### Embedded
- Firmware update mechanisms
- Secure boot, code signing
- Physical attacks (JTAG, glitching, side-channel)

## Cryptography

### Goals
- **Confidentiality** - Encryption
- **Integrity** - Hashes, MACs
- **Authenticity** - Digital signatures, MACs
- **Non-repudiation** - Digital signatures (asymmetric only)

### Symmetric Ciphers
| Algorithm | Block Size | Key Length | Notes |
|-----------|-----------|-----------|-------|
| DES | 64-bit | 56-bit | Deprecated |
| 3DES | 64-bit | 168-bit (effective 112) | Deprecated |
| AES | 128-bit | 128/192/256 | Current standard, Rijndael |
| Blowfish | 64-bit | up to 448-bit | Bruce Schneier |
| Twofish | 128-bit | up to 256-bit | AES finalist |
| IDEA | 64-bit | 128-bit | PGP early use |
| RC4 | Stream | up to 2048-bit | Deprecated (TLS prohibited) |
| RC5/RC6 | Variable | Variable | Less common |
| ChaCha20 | Stream | 256-bit | Modern, often Poly1305 MAC |

### Block Cipher Modes
- **ECB** - Electronic Codebook; identical plaintext = identical ciphertext (BAD)
- **CBC** - Cipher Block Chaining; uses IV, sequential
- **CFB / OFB** - Stream-like with block cipher
- **CTR** - Counter mode; parallelizable
- **GCM** - Galois Counter Mode; AEAD (authenticated encryption); current standard
- **CCM** - Counter with CBC-MAC; AEAD

### Asymmetric Algorithms
| Algorithm | Use | Key Length |
|-----------|-----|-----------|
| RSA | Encryption, signing, key exchange | 2048+ recommended (3072+ for long-term) |
| Diffie-Hellman | Key agreement | 2048+ (use ephemeral DHE for PFS) |
| DSA | Signing only | Deprecated for new use |
| ECDH | Key agreement (elliptic curve) | 256+ |
| ECDSA | Signing (elliptic curve) | 256+ |
| EdDSA (Ed25519) | Signing | 256-bit |
| ElGamal | Encryption | 1024+ |

ECC provides equivalent security with smaller keys: ECC 256 ≈ RSA 3072.

### Hash Functions
| Algorithm | Output | Notes |
|-----------|--------|-------|
| MD5 | 128-bit | Broken |
| SHA-1 | 160-bit | Deprecated |
| SHA-2 family | 224/256/384/512 | Current standard |
| SHA-3 family | 224/256/384/512 | Newer, different construction (Keccak) |
| BLAKE2/3 | Variable | Fast, modern |

### Password Hashing
- **PBKDF2** - acceptable, configurable iterations
- **bcrypt** - widely used, work factor adjustable
- **scrypt** - memory-hard
- **Argon2** - winner of Password Hashing Competition; modern recommendation

Always use a salt; never use a fast hash (SHA-256) directly for passwords.

### MACs
- **HMAC** - keyed hash; authenticates and verifies integrity
- **CMAC, GMAC** - block-cipher-based MACs
- **Poly1305** - paired with ChaCha20

### Public Key Infrastructure (PKI)

Components:
- **Certificate Authority (CA)** - issues certificates
- **Registration Authority (RA)** - validates identity
- **Certificate Revocation List (CRL)** - list of revoked certs
- **Online Certificate Status Protocol (OCSP)** - real-time revocation check
- **OCSP Stapling** - server attaches OCSP response, reduces client burden
- **Certificate** - X.509 standard format
- **Subject** - identity certificate is issued to
- **Issuer** - CA that signed
- **Public key** - subject's public key
- **Validity period** - notBefore, notAfter
- **Extensions** - SAN, key usage, EKU, basic constraints
- **CRL Distribution Points (CDP)**
- **Authority Information Access (AIA)** - OCSP responder URL

Certificate types:
- **Domain Validated (DV)** - basic, automated
- **Organization Validated (OV)** - org existence verified
- **Extended Validation (EV)** - extensive verification, browser UI signal
- **Wildcard** - covers all subdomains
- **SAN** - covers multiple domains
- **Code signing** - for executable signing

### Cryptographic Attacks
- **Brute force** - Try all keys
- **Dictionary** - Try common passwords
- **Rainbow table** - Pre-computed hash lookups
- **Birthday attack** - Find collisions
- **Known-plaintext** - Attacker has plaintext-ciphertext pairs
- **Chosen-plaintext** - Attacker chooses plaintexts
- **Chosen-ciphertext** - Attacker chooses ciphertexts to decrypt
- **Side-channel** - Timing, power, electromagnetic, cache (Spectre, Meltdown)
- **Replay** - Reuse captured authenticator
- **Meet-in-the-middle** - Reduces effective key strength of double encryption
- **Padding oracle** - Exploits padding error responses (POODLE)
- **Implementation flaws** - Heartbleed, weak RNG

### Quantum Threat
- Shor's algorithm threatens RSA, ECC (factoring/discrete log)
- Grover's algorithm halves symmetric key strength (AES-128 -> 64-bit equivalent)
- Post-quantum cryptography (PQC): NIST announced first standards 2024 (Kyber for KEM, Dilithium and Falcon for signatures, SPHINCS+)
- Crypto-agility important for migration

### Key Management
- Generation: high-quality RNG, hardware-backed preferred
- Distribution: secure channels (KDC, PKI)
- Storage: HSM, KMS, secure enclave
- Rotation: scheduled or on compromise
- Escrow: third-party key holding for recovery
- Destruction: secure key erasure

## Physical Security

### CPTED (Crime Prevention Through Environmental Design)
- Natural surveillance (sight lines)
- Natural access control (fencing, landscaping)
- Territorial reinforcement (clear boundaries)
- Maintenance (broken windows theory)

### Perimeter Controls
- Fencing classifications:
  - 3-4 ft: deters casual intrusion
  - 6-7 ft: deters most
  - 8 ft + barbed wire: prevents determined intruders
- Bollards
- Lighting (continuous, standby, movable, emergency)
- CCTV

### Access Controls
- Locks (key, combination, smart, biometric)
- Mantraps / sally ports / interlocking doors
- Turnstiles
- Badge readers (proximity, smart card)
- Biometric readers
- Visitor management systems

### Inside the Facility
- Datacenter zone separation
- Server rack locks, cage locks
- Cable management (prevent tampering)
- Secure media storage
- Shredders, secure disposal containers

### Environmental Controls
- HVAC (temperature 18-27 C, humidity 40-60%)
- Power: UPS for ride-through, generator for sustained
- Power conditioning, surge protection
- Fire detection: smoke, heat, flame
- Fire suppression:
  - Wet pipe (most common, water always in pipes)
  - Dry pipe (water released on activation)
  - Pre-action (two-stage activation)
  - Deluge (open sprinklers, large discharge)
  - Gas (FM-200, Inergen, CO2 - safe for electronics)
  - Older Halon banned by Montreal Protocol (ozone)
- Class A, B, C, D, K fire types

### Personnel Safety in Physical Security
- Emergency exits unlocked from inside even when fail-secure on entry
- Evacuation routes
- Assembly points
- Buddy systems
- Active shooter / incident plans

## Site and Facility Design

- Location: avoid flood plains, fault lines, high-crime areas
- Building construction: hardened walls, secure roof, blast resistance for high-risk
- Adjacent occupants matter (shared building risks)
- Concealment: avoid obvious signage for sensitive sites
- Layered zones (public lobby -> employee area -> sensitive zones)

## Common Exam Pitfalls

- Confusing BLP (confidentiality) with Biba (integrity)
- Mixing up symmetric and asymmetric algorithm uses
- Picking ECB mode (always wrong for any modern use)
- Choosing fast hashes (SHA-256) for password storage
- Forgetting digital signatures require asymmetric crypto
- Confusing fail-safe (life) with fail-secure (data)
- Selecting wrong fire suppression for the asset type
- Forgetting non-repudiation requires asymmetric (MACs cannot provide)
