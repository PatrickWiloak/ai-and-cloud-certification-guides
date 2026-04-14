# 08 - Software Development Security (Domain 8, 10%)

## Domain Overview

Domain 8 covers integrating security throughout the software development lifecycle (SDLC), secure coding practices, application security testing, software acquisition risks, and database security. While the smallest domain by weight (10%), it touches concepts critical to modern enterprise security.

## Software Development Lifecycle (SDLC)

Generic SDLC phases:

1. **Requirements / Planning** - Define what to build
2. **Design / Architecture** - How to build it
3. **Implementation / Coding** - Build it
4. **Testing / Verification** - Validate it
5. **Deployment / Release** - Push to production
6. **Operation / Maintenance** - Run and update
7. **Disposal / Retirement** - End of life

Security must be integrated into every phase, not bolted on at the end ("shift left").

## Development Methodologies

### Waterfall
- Sequential, linear
- Each phase complete before next
- Suited for stable requirements
- Limited adaptability to change

### Spiral
- Iterative with risk analysis at each turn
- Boehm 1986
- Suited for high-risk projects

### Agile
- Iterative, incremental
- Frequent delivery (typically 2-week sprints)
- Adaptive to change
- Manifesto principles
- Frameworks: Scrum, Kanban, XP, SAFe (scaled)

### DevOps
- Cultural movement combining Dev and Ops
- Automation, CI/CD, IaC, monitoring
- Faster delivery, more frequent deployments

### DevSecOps
- DevOps with security integrated
- Security in pipelines (SAST, DAST, SCA, IaC scanning)
- Shared responsibility for security across roles
- Automation of security testing

### Other models
- **RAD** (Rapid Application Development) - prototyping
- **JAD** (Joint Application Development) - business and dev together
- **Cleanroom** - mathematically rigorous, used in safety-critical (NASA, medical)
- **Lean** - eliminate waste, fast feedback

## Maturity Models

### CMMI (Capability Maturity Model Integration)
| Level | Name | Description |
|-------|------|-------------|
| 1 | Initial | Ad hoc, chaotic |
| 2 | Managed | Project-level discipline |
| 3 | Defined | Standardized across organization |
| 4 | Quantitatively Managed | Measured, controlled |
| 5 | Optimizing | Continuous improvement |

### BSIMM (Building Security In Maturity Model)
- Descriptive (observed practices), not prescriptive
- 12 practices across 4 domains: Governance, Intelligence, SSDL Touchpoints, Deployment

### OpenSAMM / SAMM (Software Assurance Maturity Model)
- OWASP project
- Prescriptive
- 5 business functions: Governance, Design, Implementation, Verification, Operations
- Maturity levels 0-3

### Microsoft SDL (Security Development Lifecycle)
- Specific to Microsoft, widely emulated
- Phases: Training, Requirements, Design, Implementation, Verification, Release, Response

## Source Code Management

- Version control (Git the standard)
- Branching strategies: GitFlow, trunk-based, feature branch
- Code review via pull/merge requests
- Signed commits (GPG, SSH signing)
- Branch protection rules (no direct push to main, required reviews, required status checks)
- Audit logging of repository actions

## CI/CD Security

- Pipelines as code (declarative)
- Pipeline triggers (push, schedule, manual approval)
- Security gates: SAST, DAST, SCA, IaC scan, secret scan, container scan, license check
- Artifacts signed (Sigstore, GPG)
- Provenance and SLSA framework
- Pipeline secrets vaulted (not in code)
- Least privilege for pipeline service accounts

### Supply Chain Security
- SLSA (Supply chain Levels for Software Artifacts) - levels 1-4
- SBOM (Software Bill of Materials) - SPDX, CycloneDX standards
- in-toto attestations
- Reproducible builds
- Mitigate against incidents like SolarWinds, Codecov, ua-parser-js, xz

## Secure Coding Practices

### OWASP Top 10 (2021 - keep current)
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Identification and Authentication Failures
8. Software and Data Integrity Failures
9. Security Logging and Monitoring Failures
10. Server-Side Request Forgery (SSRF)

### OWASP API Security Top 10 (2023)
1. Broken Object Level Authorization
2. Broken Authentication
3. Broken Object Property Level Authorization
4. Unrestricted Resource Consumption
5. Broken Function Level Authorization
6. Unrestricted Access to Sensitive Business Flows
7. Server Side Request Forgery
8. Security Misconfiguration
9. Improper Inventory Management
10. Unsafe Consumption of APIs

### CWE/SANS Top 25
- Common Weakness Enumeration most dangerous
- Includes integer overflow, race conditions, hardcoded credentials, etc.

### Secure Coding Principles
- Input validation (allowlist > denylist)
- Output encoding (context-appropriate: HTML, JS, URL, SQL)
- Parameterized queries (prevent SQL injection)
- Strong authentication and session management
- Strong authorization (object-level checks)
- Cryptographic best practices (use libraries, no homegrown crypto)
- Error handling without information disclosure
- Logging without sensitive data
- Dependency hygiene (SCA, regular updates)
- Secrets management (no hardcoded creds)
- Defense in depth at the app layer

### Common Vulnerabilities
- **Injection** (SQL, NoSQL, OS command, LDAP) - parameterize, validate
- **XSS** (Reflected, Stored, DOM-based) - encode output, CSP
- **CSRF** - tokens, SameSite cookies
- **SSRF** - validate URLs, limit egress
- **XXE** (XML External Entity) - disable external entity processing
- **Insecure deserialization** - integrity checks, type allowlists
- **Race conditions** - locks, atomic operations
- **Buffer overflows** - bounds checking, modern languages, ASLR/DEP
- **Use after free** - safe languages or careful memory management
- **Path traversal** - validate paths, use canonical form
- **Open redirect** - allowlist redirect targets
- **Mass assignment** - explicit field allowlists

## Application Security Testing

(Reviewed in Domain 6)

- SAST - source code
- DAST - running app
- IAST - both
- SCA - dependencies
- RASP - runtime protection
- Manual code review
- Pen test (web, mobile, API)
- Threat modeling

## Operation and Maintenance

### Patch and update management for applications
- Application-level patches (vendor and custom)
- Dependency updates (with regression testing)
- Configuration drift monitoring
- Deprecation and end-of-life planning

### Vulnerability remediation
- Triage by severity
- SLA-driven timelines
- Compensating controls when patch unavailable

### Software change management
- All changes through CI/CD
- Approval workflows for production
- Rollback capability
- Audit trail

## Acquired Software Security

### Commercial Off-the-Shelf (COTS)
- Vendor due diligence (SOC 2, ISO 27001, security questionnaire)
- Contractual security requirements
- Vulnerability disclosure expectations
- Update/patch SLAs
- Right to audit (often limited)
- End-of-life and migration plan

### Open-Source Software (OSS)
- License analysis (legal review)
- Security analysis (CVE history, maintainer responsiveness)
- Project health (commits, contributors, releases)
- SCA tooling for ongoing visibility
- Internal artifact mirror to mitigate supply chain compromise
- Contribution policy if engineers contribute back

### SaaS
- BAA / DPA / MSA
- Identity federation (SSO, SCIM)
- Data residency
- Data ownership and portability
- Sub-processor disclosure
- Encryption (at rest, in transit, customer-managed keys for sensitive data)
- Audit log access
- Termination data return / destruction

### Code Escrow
- Source code held by neutral third party
- Released to licensee under specified conditions (vendor bankruptcy, breach)
- Mitigates vendor lock-in / discontinuation risk

## API Security

### Authentication
- API keys (basic, often static - low security)
- OAuth 2.0 with bearer tokens
- mTLS for service-to-service

### Authorization
- Object-level (BOLA - top API risk)
- Function-level
- Field-level / property-level

### Other concerns
- Rate limiting
- Input validation
- Schema validation (OpenAPI, JSON Schema)
- Versioning (deprecation gracefully)
- Logging without sensitive data
- API gateway for centralized policy
- WAF for application-layer protection

## Containers and Serverless

### Container security
- Image scanning (Trivy, Snyk Container, Anchore)
- Image signing (Cosign, Notary)
- Trusted registries (private, signed)
- Minimal base images (distroless, Alpine)
- Non-root containers
- Read-only filesystems
- Capability dropping
- Namespaces and cgroups
- Pod Security Standards (Kubernetes): Restricted, Baseline, Privileged
- Network policies
- Runtime threat detection (Falco, Defender for Containers, Sysdig)
- Admission controllers (OPA Gatekeeper, Kyverno)

### Serverless security
- IAM per function (least privilege)
- Secrets in vault, not env vars when possible
- Dependency management (SCA)
- Cold start telemetry visibility limits
- Event source authentication
- API Gateway in front for control

## Database Security

### Concepts
- **Aggregation** - combining low-sensitivity data to derive high-sensitivity insight
- **Inference** - deducing sensitive value from non-sensitive clues
- **Polyinstantiation** - storing different "truths" at different classification levels
- **Views** - restrict columns/rows visible to a user
- **Database access control** - role-based privileges
- **Stored procedures** - encapsulate business logic with limited access
- **Database activity monitoring (DAM)** - detect unusual access

### Database threats
- SQL injection (most common)
- Excessive privileges (DBAs)
- Backup theft (unencrypted backups)
- Audit trail tampering
- Inference attacks

### Controls
- Parameterized queries / prepared statements
- Least privilege for app database accounts
- Encryption at rest (TDE)
- Encryption in transit
- Database firewalls / WAFs
- DAM tools (IBM Guardium, Imperva)
- Periodic privilege review

### Big data and NoSQL
- Same fundamental concerns
- Often less mature security tooling
- Data lake governance challenging (data quality + classification + access)

## Effectiveness of Software Security

Measure with:
- Defect density (security defects per KLOC)
- Vulnerability count by severity over time
- Mean time to remediate vulnerabilities
- Code coverage of security tests
- Pre-production vs production discovered vulnerabilities (shift-left effectiveness)
- Compliance with secure coding standard
- Security training completion for developers

## Integrated Product Team (IPT)

Cross-functional team including security from the start. Avoids late-stage rework.

## Common Exam Pitfalls

- Treating security as a phase, not a continuous activity
- Confusing maturity models (CMMI levels vs OpenSAMM levels)
- Overlooking aggregation/inference as DB threats
- Selecting denylist when allowlist is the secure choice
- Choosing API key when OAuth is appropriate
- Forgetting that OSS is acquired software with security responsibility
- Mixing up SAST and DAST
- Hardcoded credentials in code (always wrong)
- Skipping threat modeling in design phase

## Quick Reference

### Secure Coding Standards
- OWASP ASVS (Application Security Verification Standard)
- CERT Secure Coding Standards (C, C++, Java)
- OWASP Cheat Sheet Series
- SEI CERT Top 10 secure coding practices

### Frameworks for AppSec Programs
- BSIMM
- OWASP SAMM
- Microsoft SDL
- NIST SSDF (SP 800-218 Secure Software Development Framework)

### Key Tools by Need
| Need | Tool |
|------|------|
| Source code flaws | SAST (SonarQube, CodeQL, Snyk Code) |
| Running app flaws | DAST (ZAP, Burp) |
| Dependency vulns | SCA (Snyk, Dependabot, Mend) |
| Container vulns | Trivy, Snyk Container |
| Secrets in code | TruffleHog, Gitleaks |
| IaC misconfiguration | Checkov, tfsec, OPA |
| Runtime protection | RASP, WAF |
| Threat modeling | STRIDE, OWASP Threat Dragon, Microsoft Threat Modeling Tool |
