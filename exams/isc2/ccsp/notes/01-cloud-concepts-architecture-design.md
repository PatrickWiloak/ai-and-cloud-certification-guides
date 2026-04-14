# 01 - Cloud Concepts, Architecture, and Design (Domain 1, 17%)

## Domain Overview

Domain 1 establishes the vocabulary, models, and architectural foundation for cloud security. Master the NIST cloud definition, the ISO reference architecture, the shared responsibility model, and trusted cloud certifications. These concepts repeat throughout the exam.

## NIST SP 800-145 Cloud Computing Definition

The most-cited cloud definition. Memorize cold:

### Five Essential Characteristics
1. **On-demand self-service** - User provisions resources without human interaction
2. **Broad network access** - Available over the network via standard mechanisms
3. **Resource pooling** - Multi-tenant model; resources dynamically assigned
4. **Rapid elasticity** - Capabilities can be elastically provisioned and released
5. **Measured service** - Metering and reporting at a level of abstraction appropriate to the service

### Three Service Models
| Model | Customer Manages | Provider Manages |
|-------|------------------|------------------|
| IaaS | OS, runtime, middleware, apps, data, identity | Virtualization, hardware, network, facilities |
| PaaS | Apps, data, identity, configuration | Runtime, middleware, OS, virtualization, hardware, network, facilities |
| SaaS | Data classification, identity, basic configuration | Everything else |

### Four Deployment Models
- **Public** - Shared infrastructure, owned by cloud provider, available to general public
- **Private** - Single organization (can be on-premises or hosted by third party)
- **Community** - Shared by orgs with common requirements (e.g., specific compliance)
- **Hybrid** - Combination of two or more models with technology enabling portability

## Other Service Models (Beyond NIST)

- **DBaaS** - Database as a Service
- **DRaaS** - Disaster Recovery as a Service
- **DaaS** - Desktop as a Service (VDI in cloud)
- **FaaS** - Function as a Service (serverless)
- **STaaS** - Storage as a Service
- **CaaS** - Container as a Service
- **NaaS** - Network as a Service
- **SECaaS** - Security as a Service (managed security via cloud)
- **IDaaS** - Identity as a Service
- **MBaaS** - Mobile Backend as a Service

## Cloud Reference Architecture (ISO/IEC 17789)

### Roles
- **Cloud Service Customer (CSC)** - Uses cloud services
- **Cloud Service Provider (CSP)** - Provides cloud services
- **Cloud Service Partner (CSN)** - Supports CSP or CSC; types include broker, auditor, integrator
- **Cloud Service Broker (CSB)** - Negotiates relationships, aggregates services
- **Cloud Auditor** - Independent assessment of cloud services

### Sub-roles
- **Cloud Service User** - Individual using the service on behalf of CSC
- **Cloud Service Administrator** - Manages services for CSC
- **Cloud Service Business Manager** - Business-level management
- **Cloud Service Integrator** - Composes services
- **Cloud Service Developer** - Builds applications

### Cross-cutting aspects (must know)
- Auditability
- Availability
- Governance
- Interoperability (data and application portability)
- Maintenance and versioning
- Performance
- Portability (move to another provider)
- Protection of PII
- Regulatory compliance
- Resiliency
- Reversibility (terminate and recover data)
- Security
- Service levels and SLA
- Service-oriented architecture

## Shared Responsibility Model

The defining principle of cloud security. Different providers depict slightly differently, but the consistent pattern:

| Responsibility Area | IaaS | PaaS | SaaS |
|--------------------|------|------|------|
| Data classification & accountability | Customer | Customer | Customer |
| Client and end-point protection | Customer | Customer | Customer |
| Identity and access management | Customer | Shared | Shared |
| Application-level controls | Customer | Customer | Provider |
| Network controls | Shared | Provider | Provider |
| Host infrastructure | Provider | Provider | Provider |
| Physical security | Provider | Provider | Provider |

The customer NEVER fully delegates responsibility for data security or compliance, regardless of model. Even in SaaS, customer is responsible for what they put in and who can see it.

## Cloud-Specific Security Concepts

### Multi-tenancy
- Resources shared across customers
- Logical isolation enforced by provider
- Risks: side-channel attacks, hypervisor compromise, noisy neighbor
- Verification: customer cannot directly inspect; rely on attestations

### Elasticity and Auto-scaling
- Resources expand/contract on demand
- Security implications: ephemeral instances complicate forensics
- Auto-scaling triggers: CPU, custom metrics
- Cost implications

### Self-service Provisioning
- Risks: misconfiguration is the top cloud security threat
- Controls: IaC, policy as code, CSPM

### API-Driven Everything
- Cloud is API-first; control plane is via API
- Securing APIs is securing cloud
- API authentication: tokens, signatures, mTLS

### Vendor Lock-in
- Proprietary services, data formats, APIs
- Mitigations: open standards, abstraction layers, portability planning

### Reversibility
- Ability to terminate cloud services and recover data
- Contractual: data return format, deletion attestation, transition support
- Plan exit before signing

## Cryptography in Cloud

### Encryption Approaches
| Approach | Key Holder | Customer Control | Use Case |
|----------|-----------|------------------|----------|
| Provider-managed | Provider | Low | Default; minimal admin overhead |
| Customer-managed in provider KMS (BYOK) | Customer (KMS-based) | Medium | Common; key rotation, revocation control |
| Customer-supplied (CSE-C / SSE-C) | Customer (per-request) | High | Provider does not store key |
| Hold-Your-Own-Key (HYOK) | Customer (external KMS) | Highest | Provider cannot decrypt without external system |
| Confidential computing | Customer (in TEE) | Highest (in-use) | Sensitive computation, attestation-based |

### Key Management Services
- AWS KMS, Azure Key Vault, GCP Cloud KMS
- HSM-backed: AWS CloudHSM, Azure Dedicated HSM, GCP Cloud HSM (FIPS 140-2/3 Level 3)
- External KMS: Thales, Entrust, Fortanix, Ubiquity
- Standards: FIPS 140-2/3, KMIP for interoperability

### Cryptography Best Practices
- Customer-managed keys for sensitive data
- Envelope encryption (data key encrypted by master key)
- Key rotation (automatic where supported)
- Separation of duties (key admins vs data users)
- Audit logging of key operations
- Cryptographic agility (ready to swap algorithms for PQC)

## Trusted Computing in Cloud

### TPM (Trusted Platform Module)
- Hardware root of trust
- Secure key storage and attestation
- Cloud equivalent: virtual TPMs (vTPM) for cloud VMs

### Secure Enclaves / TEEs (Trusted Execution Environments)
- Intel SGX, AMD SEV/SEV-SNP, ARM TrustZone
- Code and data protected from rest of system
- Cloud offerings: Azure Confidential Computing, AWS Nitro Enclaves, GCP Confidential VMs

### Secure Boot
- Chain of trust from firmware
- Signature verification at each boot stage
- Cloud: most providers offer secure boot for VMs

### Confidential Computing
- Data encrypted in use, not just at rest and in transit
- Cloud Confidential Computing Consortium standards
- Use cases: regulated workloads, multi-party computation, key management

## Cloud Architecture Patterns

### High Availability
- Multi-AZ deployments within a region
- Load balancing across instances
- Database replication

### Disaster Recovery
- Multi-region deployments
- Backup-and-restore (highest RTO/RPO)
- Pilot light (minimal services running)
- Warm standby (reduced capacity always running)
- Hot multi-region (active-active or active-passive)

### Scalability
- Vertical (scale up) - bigger instances
- Horizontal (scale out) - more instances; cloud-preferred

### Microservices
- Decomposed services with APIs
- Service mesh for security (mTLS, traffic policies, identity)
- Containers and orchestration (Kubernetes)

### Serverless
- Functions as a Service (Lambda, Functions, Cloud Functions)
- Event-driven, ephemeral
- IAM per function (least privilege)
- Cold starts, observability challenges

## Cloud Architecture Frameworks

### AWS Well-Architected Framework
6 pillars: Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability

### Microsoft Azure Well-Architected Framework
5 pillars: Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency

### Google Cloud Architecture Framework
6 pillars: System Design, Operational Excellence, Security and Compliance, Reliability, Cost Optimization, Performance Optimization

These overlap heavily; CCSP is vendor-neutral and emphasizes the security pillar.

## Cloud Certifications and Frameworks

### Cloud-Specific Standards
- **CSA Cloud Controls Matrix (CCM) v4** - 197 controls in 17 domains, mapped to many frameworks
- **CSA Consensus Assessments Initiative Questionnaire (CAIQ)** - Standardized vendor questionnaire
- **CSA STAR Registry** - Levels 1 (self-assessment), 2 (third-party), 3 (continuous, in development)
- **ISO/IEC 27017** - Cloud-specific 27002 controls
- **ISO/IEC 27018** - PII protection in public clouds
- **ISO/IEC 27701** - Privacy management on top of 27001
- **ISO/IEC 17788** - Cloud vocabulary
- **ISO/IEC 17789** - Cloud reference architecture
- **ISO/IEC 19944** - Cross-cutting cloud information flow
- **NIST SP 800-145** - Cloud definition
- **NIST SP 500-291** - Cloud Standards Roadmap
- **NIST SP 800-144** - Security and Privacy in Public Cloud
- **NIST SP 800-210** - Access Control for Cloud
- **FedRAMP** - US Federal authorization (Low, Moderate, High impact levels)
- **BSI C5** - German Federal Office for Information Security
- **ENISA Cloud Computing Risk Assessment** - European
- **MTCS** - Singapore Multi-Tier Cloud Security

### General Frameworks Applied to Cloud
- ISO/IEC 27001 (ISMS)
- ISO/IEC 27002 (controls catalog)
- NIST CSF
- NIST RMF (SP 800-37)
- COBIT 2019

## Trusted Cloud Service Provider Validation

When evaluating a CSP, look for:
- SOC 2 Type 2 (Trust Services Criteria)
- ISO 27001 (ISMS)
- ISO 27017 / 27018 (cloud)
- CSA STAR Level 2 (CCM-aligned)
- FedRAMP if US government workloads
- Region-specific (BSI C5, MTCS, IRAP, ENS)
- PCI DSS (if processing payment data)
- HIPAA-eligibility (with BAA)
- FIPS 140-2/3 modules where customer-managed crypto

## Common Exam Pitfalls

- Forgetting customer always retains responsibility for data classification, even in SaaS
- Confusing service models (SaaS vs PaaS vs IaaS shared responsibility)
- Mixing deployment models (community vs hybrid)
- Choosing provider-managed encryption when question asks for maximum customer control
- Selecting wrong audit/attestation type (SOC 1 vs SOC 2)
- Forgetting reversibility / exit planning before signing
- Not knowing CSA vs ISO vs NIST cloud standards

## Quick Reference: Service Model Decision

| Need | Best Model |
|------|-----------|
| Application code, no infra management | PaaS |
| Off-the-shelf SaaS app for business function | SaaS |
| Custom OS, kernel-level control needed | IaaS |
| Run a database without managing it | DBaaS (PaaS) |
| Run code triggered by events, no servers | FaaS (PaaS) |
| Containerized workloads with managed orchestration | CaaS (PaaS) |
