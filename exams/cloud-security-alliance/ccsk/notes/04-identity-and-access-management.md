# 04 - Identity and Access Management (Guidance Domain 5)

## Domain Overview

Guidance Domain 5 covers how identities are managed and access is controlled in cloud environments. In cloud, identity is the primary perimeter: traditional network boundaries dissolve, and control shifts to who can do what.

## Foundational Concepts

### Identity
A unique representation of a principal (user, service, device) that can authenticate and be authorized.

### Authentication
Verifying a claimed identity via credentials (factors).

### Authorization
Determining what an authenticated identity may do.

### Accounting
Logging actions attributable to identities.

### Federated Identity
Using an external identity system to authenticate users within your environment. Core to cloud and multi-cloud.

## Human Identity vs Workload (Non-Human) Identity

### Human Identities
- Employees, contractors, customers
- Managed in IdP (Identity Provider)
- Authenticate with password + MFA, passkeys, smart cards
- Authorized through roles and permissions

### Workload Identities
- Applications, services, scripts, CI/CD pipelines, VMs, containers
- Traditionally the most-neglected and highest-risk
- Should use cloud-native workload identity (managed identity, IAM role, workload identity federation)
- No long-lived static secrets when possible

CSA Guidance and CCM emphasize treating non-human identities with the same rigor as human ones.

## Federated Identity Protocols

### SAML 2.0
- XML-based assertion
- Primarily for browser SSO
- Enterprise SaaS standard
- Components: Identity Provider (IdP), Service Provider (SP), Assertion, metadata

### OAuth 2.0
- Authorization framework, NOT authentication
- Delegated access to resources
- Grants: authorization code (+ PKCE), client credentials, device code
- Tokens: access (short-lived), refresh
- Scopes define permissions

### OpenID Connect (OIDC)
- Authentication layer on top of OAuth 2.0
- ID token (JWT) with identity claims
- Modern standard for web/mobile

### WS-Federation
- Older SOAP-based federation
- Still seen in Microsoft ADFS environments

### Kerberos
- Intra-domain SSO
- Used in AD, some UNIX environments

## Cloud IAM Patterns

### Centralized IdP with Federation
- Single source of truth for identity
- Federate to each cloud provider (SAML, OIDC)
- Consistent MFA enforcement
- Centralized lifecycle (provisioning, deprovisioning)

### Examples
- Microsoft Entra ID (formerly Azure AD) federated to AWS, GCP, SaaS
- Okta federated to Azure, AWS, GCP, SaaS
- Ping Identity as enterprise hub
- ForgeRock, Auth0 for customer identity

### Provisioning Automation
- **SCIM** (System for Cross-domain Identity Management) - Standard protocol for user lifecycle across SaaS
- HR system integration (Workday, SuccessFactors as source of truth)
- Closed-loop offboarding from HR termination to access revocation

## Multi-Factor Authentication (MFA)

### Factor Types
- Type 1: something you know (password, PIN)
- Type 2: something you have (token, phone, smartcard)
- Type 3: something you are (biometric)
- Type 4: something you do (behavior)
- Type 5: somewhere you are (location)

MFA = at least 2 different types.

### Modern MFA Methods
- TOTP (Time-based OTP) - apps like Authy, Google Authenticator
- Push notifications (vulnerable to MFA fatigue / push bombing)
- Hardware tokens (YubiKey, RSA SecurID)
- **FIDO2 / WebAuthn / Passkeys** - phishing-resistant, public-key based (strongest practical method)

### MFA Anti-Patterns
- SMS as primary MFA (SIM swap vulnerability)
- Security questions (often guessable)
- Push-only without number matching (vulnerable to fatigue)

## Authorization Models in Cloud

### RBAC (Role-Based Access Control)
- Permissions grouped into roles
- Users assigned to roles
- Industry standard; cloud providers implement variants
- AWS IAM, Azure RBAC, GCP IAM all support RBAC

### ABAC (Attribute-Based Access Control)
- Decisions based on attributes of user, resource, action, environment
- More flexible than RBAC
- AWS IAM tags-as-policy-condition, Azure ABAC, GCP IAM Conditions
- XACML is a standard policy language

### PBAC (Policy-Based Access Control)
- Rules and policies evaluated at access time
- Often combined with ABAC

## Least Privilege and Just-in-Time Access

### Least Privilege
- Identities granted minimum permissions needed
- Periodic review to remove excess
- Evidence: CIEM tools show actual vs granted permissions

### JIT (Just-in-Time)
- No standing elevated privilege
- Elevation on request, approval required for sensitive roles
- Time-bounded (e.g., 1 hour access)
- Examples: Azure PIM, AWS IAM Identity Center with approval workflows

### PAM (Privileged Access Management)
- Vaulted credentials for admin accounts
- Session recording
- Approval workflows
- Automatic credential rotation post-use
- Examples: CyberArk, BeyondTrust, Delinea, HashiCorp Boundary

## Workload Identity Federation

The modern pattern for service-to-cloud authentication without static secrets.

### How It Works
1. Workload runs in trusted environment (K8s, CI/CD, another cloud)
2. Workload obtains OIDC token proving its identity
3. Token exchanged for short-lived cloud credentials
4. No long-lived access keys stored anywhere

### Examples
- GitHub Actions -> AWS (OIDC trust)
- GitLab CI -> GCP (Workload Identity Federation)
- Kubernetes Service Account -> Cloud IAM
- Azure Managed Identity -> Azure resources
- EKS IRSA (IAM Roles for Service Accounts) / EKS Pod Identity

Benefits:
- No secrets to steal
- Automatic short-lived credentials
- Audit trail via OIDC
- Easier compliance

## Identity Governance and Administration (IGA)

### Capabilities
- Access certification (UARs - User Access Reviews)
- Role engineering and management
- Segregation of duties enforcement
- Policy management
- Audit and reporting

### Tools
- SailPoint IdentityIQ, IdentityNow
- Saviynt
- Microsoft Entra ID Governance
- Omada

## Cloud Infrastructure Entitlement Management (CIEM)

Focused category addressing cloud-specific identity and permission analysis:
- Discovers all identities (human and non-human)
- Analyzes granted vs used permissions
- Identifies over-privileged identities
- Detects toxic combinations (e.g., prod access + backup access = ransomware risk)
- Provides least-privilege recommendations
- Continuous monitoring

Tools: Wiz, Prisma Cloud, Defender for Cloud (part of CNAPP), Ermetic, SailPoint CIEM.

## Account Access Review (UAR)

Periodic recertification of access rights:
- Per data owner / business manager
- Risk-based frequency (quarterly for privileged; annual for standard)
- Tool-assisted with automated reminders
- Closed-loop revocation of unapproved access
- Audit evidence for compliance

## Provisioning and Deprovisioning

### Provisioning
- Tied to HR system / business approval
- Automated via SCIM where supported
- Role assignment based on job function
- Baseline access on day one

### Deprovisioning
- Triggered by HR termination or role change
- Immediate for high-sensitivity roles (privileged, regulated)
- All access channels: cloud accounts, SaaS apps, VPN, physical
- Confirmed via audit

## Conditional Access

Rules that allow/deny/require additional controls based on context:
- Location (geo, IP)
- Device compliance (managed, encrypted, not jailbroken)
- Risk score (sign-in risk, user risk)
- Application being accessed
- Time of day

Examples:
- Entra Conditional Access
- Okta Adaptive MFA
- Google Context-Aware Access

### Continuous Access Evaluation (CAE)
- Beyond one-time auth
- Sessions revoked on risk events (user disabled, password changed, IP change)
- Implemented in Microsoft ecosystem

## Zero Trust Identity

Core to zero trust architecture:
- Verify every access request (not just at boundary)
- Strong identity (phishing-resistant MFA)
- Device trust (compliance, posture)
- Least privilege
- Assume breach
- Continuous verification

## Identity in Different Service Models

### IaaS Identity
- VM instance profiles / managed identities
- SSH keys (avoid long-lived; use cloud-native session)
- IAM roles for workloads

### PaaS Identity
- Application identity for database and storage access
- Service accounts per function/app

### SaaS Identity
- Federated login (SAML/OIDC)
- API access tokens
- Delegated OAuth grants (be wary of scopes)
- SCIM provisioning

## Identity Threats

| Threat | Description |
|--------|-------------|
| Credential stuffing | Reused passwords from breaches |
| Password spray | Few common passwords, many accounts |
| Phishing | Trick user into entering credentials |
| AiTM | Adversary-in-the-middle bypasses some MFA |
| Push bombing (MFA fatigue) | Spam push notifications |
| Session hijacking | Steal session/token |
| OAuth consent phishing | Trick user into granting OAuth app access |
| Forged tokens | SAML, JWT, Kerberos forgery (Golden SAML, Golden Ticket) |
| Service account compromise | Long-lived secrets stolen |
| Over-permissioned accounts | Lateral movement and privilege escalation |
| Insider misuse | Legitimate access abused |

## Best Practices Summary

- Central IdP federated everywhere
- MFA for all users, phishing-resistant for admins
- Workload identity federation (no static secrets)
- Least privilege, verified by CIEM
- JIT elevation via PAM
- Periodic UARs
- Continuous monitoring (UEBA, risk-based)
- Conditional access with device trust
- Break-glass accounts documented and tested
- Service account inventory and hygiene

## Common Exam Pitfalls

- Confusing OAuth (authorization) with authentication
- Selecting password+security question as MFA (same type)
- Allowing long-lived cloud access keys in pipelines (use workload identity)
- Missing break-glass accounts for IdP outage
- Picking RBAC when ABAC is needed for attribute-based decisions
- Forgetting non-human identities in IAM strategy
- Not knowing CIEM as the cloud-specific identity analytics category

## Quick Reference

### MFA Strength Ranking (best to worst)
1. FIDO2 / WebAuthn / Passkeys (phishing-resistant)
2. Hardware TOTP token
3. TOTP authenticator app
4. Push notification with number matching
5. Push notification (plain, vulnerable to fatigue)
6. SMS OTP (vulnerable to SIM swap)
7. Email OTP (weakest)

### Federation Protocol Selection
- Browser SSO to SaaS: SAML 2.0 or OIDC
- API access: OAuth 2.0
- Provisioning: SCIM
- Service-to-cloud: Workload Identity Federation (OIDC-based)
