# 05 - Identity and Access Management (Domain 5, 13%)

## Domain Overview

Domain 5 covers how identities are established, authenticated, authorized, and managed throughout their lifecycle. IAM is increasingly the primary security perimeter as networks dissolve under cloud and mobile adoption ("identity is the new perimeter").

## IAAA Framework

- **Identification** - claim ("I am Alice")
- **Authentication** - proof ("Here is my password / token / fingerprint")
- **Authorization** - permission ("Alice can read finance data")
- **Accountability** - logging actions back to identity ("Alice deleted file X at time Y")

## Authentication Factors

| Type | Category | Examples |
|------|----------|----------|
| Type 1 | Something you know | Password, PIN, security question |
| Type 2 | Something you have | Smart card, hardware token, phone, certificate |
| Type 3 | Something you are | Fingerprint, iris, face, voice, palm vein |
| Type 4 | Something you do | Typing rhythm, signature dynamics, gait |
| Type 5 | Somewhere you are | GPS, geofence, IP geolocation |

**MFA** = at least two DIFFERENT factor types. Password + security question = still single factor (both are Type 1).

## Authentication Mechanisms

### Passwords
- Best practices (NIST SP 800-63B):
  - Length minimum 8 chars (encourage longer)
  - No mandatory composition rules
  - No mandatory rotation (rotate on compromise)
  - Check against breached password lists (HaveIBeenPwned)
  - Allow paste, password managers
  - Ban common passwords
  - Account lockout or rate limiting
- Storage: salted, slow hash (bcrypt, Argon2)

### Tokens
- **OTP** - One-Time Password
- **HOTP** - HMAC-based OTP (RFC 4226), counter-based
- **TOTP** - Time-based OTP (RFC 6238), 30-second window typical
- **Hardware tokens** - YubiKey, RSA SecurID
- **Smart cards** - PIV (US gov), CAC (DoD)
- **FIDO2 / WebAuthn** - phishing-resistant, public-key based, passkeys

### Biometrics
- Properties:
  - **FAR** (False Acceptance Rate / Type II error) - imposter accepted
  - **FRR** (False Rejection Rate / Type I error) - legitimate user rejected
  - **CER** (Crossover Error Rate / EER) - point where FAR = FRR (lower = better system)
  - **Throughput** - users per minute
  - **Enrollment time** - time to register
- Types: fingerprint, iris, retina, face, voice, palm, vein, gait, signature
- Considerations: accuracy varies by demographic, environmental sensitivity, privacy concerns, irrevocability of biometric template if breached
- Templates should be hashed/encrypted, not stored as raw biometric

### FIDO2 / WebAuthn / Passkeys
- Phishing-resistant (origin-bound)
- Public/private keypair per service
- Private key in authenticator (TPM, security key)
- Replaces passwords with cryptographic auth
- Discoverable credentials (passkeys) sync across devices via cloud (iCloud Keychain, Google Password Manager, Microsoft Account)

## Single Sign-On (SSO)

User authenticates once, accesses multiple systems without re-authentication.

### Benefits
- Better user experience
- Centralized auth policy
- Centralized logging and monitoring
- Easier credential management
- Faster onboarding/offboarding

### Risks
- Single point of failure
- Compromise of SSO compromises all
- Concentrated attack target

### Kerberos
- MIT-developed, widely used in AD
- Components:
  - **KDC** (Key Distribution Center)
  - **AS** (Authentication Server) - verifies identity, issues TGT
  - **TGS** (Ticket Granting Server) - issues service tickets
  - **TGT** (Ticket Granting Ticket) - proves identity to TGS
  - **Service ticket** - access to specific service
- Time synchronization required (clock skew breaks tickets, default 5 min)
- Threats: Golden Ticket (forge TGT with KRBTGT key), Silver Ticket (forge service ticket), AS-REP roasting, Kerberoasting (offline crack of service ticket)

### SAML (Security Assertion Markup Language)
- XML-based federated SSO
- Components:
  - **IdP** (Identity Provider) - authenticates user
  - **SP** (Service Provider) - relies on IdP assertion
  - **Assertion** - signed XML document with auth, attribute, authorization statements
- Browser-based redirect or POST flows
- Used widely for enterprise SaaS

### OAuth 2.0
- Authorization framework, NOT authentication
- Roles:
  - **Resource owner** (user)
  - **Client** (app requesting access)
  - **Authorization server** (issues tokens)
  - **Resource server** (holds protected resources)
- Grant types: authorization code (most secure for web apps), PKCE (for public clients), client credentials, device code, implicit (deprecated), password (deprecated)
- Tokens: access (short-lived), refresh (long-lived)
- Scopes define permissions
- Common confusion: OAuth alone is NOT authentication

### OpenID Connect (OIDC)
- Identity layer on top of OAuth 2.0
- Adds ID token (JWT) with user identity claims
- Standard for federated authentication on the web
- iss, sub, aud, exp, iat claims

### WS-Federation
- Older SOAP-based federation
- Microsoft, ADFS

### LDAP
- Directory protocol
- Microsoft Active Directory, OpenLDAP, eDirectory
- Hierarchical: DN, RDN, OU, DC
- Authentication: simple bind (cleartext - bad), SASL, SSL/TLS (LDAPS)

### RADIUS
- Network access authentication (Wi-Fi, VPN, switches)
- UDP 1812/1813
- Centralized AAA
- Plaintext other than password (use IPsec, RadSec for protection)
- Used with 802.1X

### TACACS+
- Cisco-developed AAA
- TCP 49
- Encrypts entire packet
- Separates auth/authorization/accounting (RADIUS combines auth+authz)

### Diameter
- Successor to RADIUS
- Mobile networks (LTE/5G), VoIP

## Federated Identity

### Models
- **Cross-certification** - direct trust between organizations (does not scale)
- **Trusted third party** - shared IdP federates many SPs
- **Federated SSO** - protocols like SAML, OIDC enable cross-domain SSO

### Identity as a Service (IDaaS)
- Cloud-hosted identity management
- Examples: Okta, Microsoft Entra ID, Ping, Auth0, Google Identity
- Benefits: no on-prem infrastructure, rapid SaaS integration, MFA, conditional access
- Risks: vendor lock-in, dependency on availability, data residency

## Authorization Mechanisms

### DAC (Discretionary Access Control)
- Owner determines access
- ACLs on files and resources
- Windows file permissions
- Less secure (subject to misuse, propagation)

### MAC (Mandatory Access Control)
- System enforces classification labels
- Not at owner discretion
- Used in military, high-security
- Examples: SELinux, AppArmor, Bell-LaPadula

### RBAC (Role-Based Access Control)
- Permissions assigned to roles
- Users assigned to roles
- Easier to manage at scale
- Industry standard for enterprise applications

### ABAC (Attribute-Based Access Control)
- Decisions based on attributes (user, resource, action, environment)
- XACML standard policy language
- Highly flexible (e.g., "Allow read if user.department == resource.owner_department AND time is business hours AND device is compliant")

### RuBAC (Rule-Based Access Control)
- Rules-based, often global
- Firewalls, ACLs are rule-based

### Risk-based / Adaptive Access Control
- Context (geo, device posture, time, behavior anomaly) influences access decision
- May add MFA prompts or deny
- Modern IDaaS staple

### Hierarchical RBAC
- Roles inherit from parent roles
- Manager role inherits all employee permissions plus more

### Just-in-Time (JIT) Access
- Standing access removed; access granted on request for limited time
- Reduces standing privilege blast radius

### Just-Enough-Administration (JEA)
- Microsoft concept; constrained admin endpoints (PowerShell)
- Combined with JIT for least-privilege admin

### Privileged Access Management (PAM)
- Vault for privileged credentials
- Session brokering and recording
- Approval workflows
- Rotation of credentials after use
- Examples: CyberArk, BeyondTrust, HashiCorp Vault, Azure PIM

## Identity Provisioning Lifecycle

1. **Provisioning** - Account creation, role assignment
2. **Modification** - Role changes, transfers
3. **Deprovisioning** - Account removal/disable on departure
4. **Account access review (UAR)** - Periodic recertification

### SCIM
- System for Cross-domain Identity Management
- REST API standard for provisioning across SaaS
- Replaces fragile custom integrations

### IGA (Identity Governance and Administration)
- Policies, role engineering, access certification, segregation of duties enforcement
- Examples: SailPoint, Saviynt, Microsoft Entra ID Governance

## Account Access Review

- Periodic certification by managers/data owners
- Identifies stale, excessive, or unauthorized access
- Critical for SOX, PCI, HIPAA compliance
- Best practices:
  - Risk-based frequency (privileged accounts more often)
  - Sample-based for low-risk
  - Automated workflows
  - Closed-loop revocation
  - Track exceptions

## Identity Lifecycle for Privileged Accounts

- Pre-provisioning: justification, approval, training
- Provisioning: vaulted credentials, scoped access
- Use: JIT elevation, session recording, MFA required
- Review: monthly UARs
- Deprovisioning: immediate on role change or departure

## Service Accounts and Non-human Identities

- Service accounts: applications, scripts, system-to-system
- Often the riskiest accounts (high privilege, long-lived credentials)
- Best practices:
  - Vault credentials
  - Use managed identities (cloud)
  - Use workload identity federation (no static secrets)
  - Avoid interactive logon
  - Rotate regularly
  - Inventory all service accounts

## Identity Threats

| Threat | Description |
|--------|-------------|
| Credential stuffing | Reused breached passwords |
| Password spray | Few common passwords against many accounts |
| Brute force | All combinations against one account |
| Phishing | Trick user to enter credentials |
| AiTM (Adversary-in-the-Middle) | Real-time relay defeats some MFA |
| MFA fatigue | Push notification spam until user accepts |
| Session hijacking | Steal session token |
| Pass-the-hash / Pass-the-ticket | Use stolen NTLM hash or Kerberos ticket |
| Golden / Silver Ticket | Forged Kerberos tickets |
| Token theft | Steal OAuth/SAML tokens |
| Social engineering | Convince support to reset/disable controls |
| Insider misuse | Authorized users abusing access |

## Identity Best Practices

- MFA for all users (not just admins) using phishing-resistant methods
- Conditional access (device compliance, geo, app, risk)
- No standing privileged access (use PAM/JIT)
- Service account hygiene (no humans use service accounts)
- Periodic UARs
- Just-in-time provisioning where feasible
- Least privilege everywhere
- Continuous monitoring (UEBA, sign-in risk)

## Common Exam Pitfalls

- Confusing OAuth (authorization) with authentication
- Picking same-type factors as MFA (two passwords still single-factor)
- Forgetting Kerberos requires time synchronization
- Confusing RBAC and ABAC
- Selecting RADIUS over TACACS+ for full encryption (TACACS+ encrypts entire packet)
- Over-rotating passwords against modern guidance
- Choosing biometric without considering enrollment, FAR/FRR trade-offs

## Quick Reference: Federation Acronym Cheat

- **SAML** - browser SSO via XML assertion (enterprise SaaS standard)
- **OAuth 2.0** - authorization, delegated access (API access)
- **OIDC** - authentication on top of OAuth (modern SSO)
- **WS-Federation** - older Microsoft federation
- **Kerberos** - intra-domain/realm SSO (Windows AD, Linux MIT)
- **SCIM** - provisioning automation
- **FIDO2 / WebAuthn** - phishing-resistant MFA / passwordless
