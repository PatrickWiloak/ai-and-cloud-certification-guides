# 07 - Data, Application, and Workload Security (Guidance Domains 8, 9, 10)

## Domain Overview

This combined topic covers three Guidance domains: Cloud Workload Security (Domain 8), Data Security (Domain 9), and Application Security (Domain 10). These are the workload-level protection concerns spanning how you run code, how you protect data, and how you build applications securely in cloud.

## Cloud Workload Types (Domain 8)

### Virtual Machines
- Customer manages OS up
- Patching, hardening, antivirus
- Endpoint detection and response (EDR)
- Vulnerability assessment
- Backup and snapshots

### Containers
- Image-based packaging
- Shared kernel (less isolation than VMs)
- Orchestration via Kubernetes typically
- Image scanning, signing, runtime protection

### Platform Services (PaaS)
- Managed database, queues, caches
- Customer manages data and access; provider manages runtime
- Private endpoints, encryption, IAM

### Serverless (FaaS)
- Event-driven functions
- Per-function IAM
- Minimal duration, no persistent state
- Dependency management (SCA)
- Event source authentication

### AI/ML Workloads
- Model training (high-privilege, access to sensitive training data)
- Model serving (API security, inference protection)
- Prompt injection, jailbreak attacks (for LLMs)
- Data lineage and provenance

## Workload Security Controls

### For VMs
- Hardened baseline images (CIS Benchmarks, vendor guidance, custom)
- Patch management (cloud-native or third-party)
- EDR agents
- Vulnerability scanning (agent-based or agentless)
- File integrity monitoring
- Log forwarding to SIEM
- Just-in-time admin access (no standing SSH)

### For Containers
- **Image security**:
  - Minimal base images (distroless, Alpine)
  - Image scanning in CI/CD (Trivy, Snyk, Anchore)
  - Image signing (Sigstore Cosign, Notation)
  - Trusted registries only
- **Runtime security**:
  - Pod Security Standards: restricted level
  - Non-root containers
  - Read-only root filesystems
  - Capability dropping
  - Resource limits
  - Runtime threat detection (Falco, Defender for Containers, Sysdig Secure)
- **Kubernetes hardening**:
  - RBAC for cluster access
  - Network policies
  - Admission controllers (OPA Gatekeeper, Kyverno)
  - etcd encryption
  - Audit logging
  - CIS Kubernetes Benchmark

### For Serverless
- IAM per function (least privilege)
- Secrets from vault, not env vars for sensitive
- Dependency scanning (SCA)
- Input validation at function boundary
- Event source authentication (verify trigger origin)
- Concurrency and timeout limits
- API Gateway in front

### For PaaS
- Private endpoints (no public access)
- TLS required
- Customer-managed encryption keys
- IAM integration
- Service-specific hardening (database audit, queue policies)

## Data Security (Domain 9)

### Cloud Data Lifecycle
1. **Create** - Generated
2. **Store** - Saved to storage
3. **Use** - Processed
4. **Share** - Distributed
5. **Archive** - Long-term retention
6. **Destroy** - Permanent deletion

Each phase has different threats and controls.

### Data Classification
Apply sensitivity labels:
- Commercial: Public, Internal, Confidential, Restricted
- Government: Unclassified, CUI, Confidential, Secret, Top Secret
- Industry-specific (PHI, PCI, etc.)

### Data Discovery Tools
- AWS Macie (S3-focused)
- Azure Purview / Defender for Storage
- GCP Sensitive Data Protection (DLP)
- Third-party: BigID, Varonis, Concentric

### Data Security Technologies

#### Encryption
| Approach | Control | Use Case |
|----------|---------|----------|
| Provider-managed | Provider | Default, minimal admin |
| BYOK (customer-managed) | Customer | Control rotation and revocation |
| Customer-supplied | Customer (per request) | Provider doesn't store |
| HYOK (external KMS) | Customer (external) | Provider cannot decrypt |
| Client-side | Customer (pre-upload) | Strongest customer control |
| Confidential computing | Customer (TEE) | Data encrypted in use |

#### Tokenization
- Replace sensitive value (PAN) with token
- Vault stores the mapping
- PCI DSS scope reduction

#### Data Masking
- Obfuscate for display (XXX-XX-1234)
- Static (replace in storage) or dynamic (at query)

#### Anonymization
- Irreversible removal of identifiers
- Truly anonymized data is no longer personal data
- Technical: k-anonymity, l-diversity, differential privacy

#### Pseudonymization
- Reversible with key
- GDPR-recognized privacy-enhancing technique

### Key Management in Cloud
- Cloud KMS (AWS KMS, Azure Key Vault, GCP Cloud KMS)
- Cloud HSM for higher assurance (FIPS 140-2 Level 3)
- External KMS for HYOK
- Envelope encryption (DEK wrapped by KEK)
- Automated rotation
- Audit logging of all key operations
- Separation of duties (key admins vs data users)

### Data Loss Prevention (DLP) in Cloud
- Cloud DLP (Macie, Purview, Google Cloud DLP)
- CASB for SaaS inspection (Defender for Cloud Apps, Netskope, Zscaler CASB)
- Endpoint DLP for device-level
- Policy actions: block, alert, encrypt, redact

### Data Rights Management (DRM/IRM)
- Persistent encryption + policy
- Travels with file
- Examples: Microsoft Purview Information Protection, Box, Vera
- Policy: read-only, no print, no copy, expiration, revocation

### Data Residency and Sovereignty
- **Residency** - where data is stored
- **Sovereignty** - whose laws apply
- Regional cloud deployments
- Avoid services that replicate globally without explicit configuration
- Sovereign clouds (GovCloud, Azure Government, EU sovereign clouds)

### Data Retention and Deletion
- Driven by regulation and business need
- Do NOT retain longer than needed (privacy + cost)
- Cryptographic erasure (destroy key, data unrecoverable)
- Confirmed deletion (provider attestation)
- Legal hold processes

## Application Security (Domain 10)

### Cloud SDLC
- Phases: requirements, design, implementation, testing, deployment, operations, disposal
- Security in every phase (not bolted on)
- Threat modeling in design (STRIDE, PASTA)

### DevSecOps Principles
- Shift left (security early)
- Automation
- Shared responsibility across teams
- Continuous feedback
- Policy as code

### CI/CD Pipeline Security
Stages and gates:
1. **Commit** - Pre-commit hooks (secret scanning, linting)
2. **Build** - SAST, SCA, license check
3. **Container build** - Image scan
4. **IaC** - Policy-as-code scan
5. **Deploy (staging)** - DAST against staging
6. **Deploy (prod)** - Approval gate, canary deployment
7. **Runtime** - WAF, RASP, monitoring

### Secure Coding
- OWASP Top 10 (web app)
- OWASP API Security Top 10
- OWASP Serverless Top 10
- Input validation, output encoding
- Parameterized queries
- Secrets vaulted
- Dependency hygiene (SCA)

### Application Security Testing
| Type | What It Tests |
|------|---------------|
| SAST | Source code flaws |
| DAST | Running app vulnerabilities |
| IAST | Both combined via agent |
| SCA | Third-party dependency vulns |
| RASP | Runtime attack detection/prevention |
| Fuzzing | Input validation robustness |
| Manual code review | Logic/design flaws |
| Pen test | Realistic attack simulation |

### API Security
- Authentication (OAuth 2.0, mTLS for service-to-service)
- Authorization (object-level, BOLA is top API risk)
- Input validation via schema (OpenAPI, JSON Schema)
- Rate limiting
- Versioning
- Gateway in front (AWS API Gateway, Azure API Management, GCP API Gateway, Kong, Apigee)
- Inventory management (shadow APIs dangerous)

### Supply Chain Security
- SBOM (SPDX, CycloneDX)
- SLSA framework levels 1-4
- Signed artifacts (Sigstore)
- Private registry mirrors of critical OSS
- Provenance attestations
- in-toto for end-to-end supply chain integrity

### Secrets Management
- Vault for all secrets (AWS Secrets Manager, Azure Key Vault, GCP Secret Manager, HashiCorp Vault)
- Workload identity for retrieval (no static secrets)
- Automatic rotation
- Audit logging
- Secret scanning in CI/CD (TruffleHog, Gitleaks, GitHub Advanced Security)

### Infrastructure as Code (IaC) Security
- Version controlled, peer reviewed
- Policy-as-code enforcement (OPA, Sentinel, Checkov, tfsec, Terrascan)
- IaC drift detection
- Signed artifacts
- Secrets never in IaC (use references to vault)

## Common Cloud Application Architectures

### Monolithic (Lift-and-Shift)
- Moved from on-prem with minimal changes
- Less cloud-native benefit
- Security: perimeter firewall, host protection

### Microservices
- Decomposed services
- Service mesh for comm
- Independent deployment
- Security: identity per service, mTLS, API gateway

### Event-Driven
- Queues and streams
- Loose coupling
- Security: authenticate event sources

### Serverless
- Event-triggered functions
- Per-function IAM
- Security: function-level hardening

### AI / LLM Applications
- Model APIs or self-hosted
- Prompt injection, jailbreak defenses
- RAG (Retrieval Augmented Generation) data security
- Output filtering (PII leakage, sensitive data)
- Access control to models
- Audit of prompts and responses
- OWASP Top 10 for LLMs (2023)

## OWASP LLM Top 10 (awareness)

1. Prompt injection
2. Insecure output handling
3. Training data poisoning
4. Model DoS
5. Supply chain vulnerabilities
6. Sensitive information disclosure
7. Insecure plugin design
8. Excessive agency
9. Overreliance
10. Model theft

## Common Exam Pitfalls

- Confusing SAST (source) and DAST (running)
- Forgetting SCA for third-party dependencies
- Hardcoding secrets (always wrong; use vault)
- Missing workload identity (using long-lived secrets for services)
- Confusing encryption at rest with in transit or in use
- Choosing tokenization when masking is sufficient (or vice versa)
- Forgetting that data classification drives encryption requirements
- Assuming SaaS customer has no data security responsibility

## Quick Reference Tables

### Workload Type to Security Category
| Workload | Main Security Category |
|----------|----------------------|
| VM | CWPP, EDR, vuln scan |
| Container | Container security platform, K8s hardening |
| Serverless | Function IAM, SCA, event auth |
| Managed DB | IAM, encryption, audit, private endpoint |
| Bucket / object store | IAM, encryption, public-access block, logging |
| LLM / model API | Prompt injection defenses, output filtering, access audit |

### Encryption Decision Rule
- Data in transit: always TLS 1.2+
- Data at rest: always encrypted, customer-managed keys for sensitive
- Data in use: confidential computing for highest sensitivity
- Key location: external (HYOK) for "provider cannot decrypt" requirement
