# 01 - Cloud Computing Concepts and Architectures (Guidance Domain 1)

## Domain Overview

Guidance Domain 1 establishes the foundational vocabulary and models for cloud computing. Mastery here is essential because all other domains build on these concepts. The definitions from NIST SP 800-145 and ISO/IEC 17788 are frequently referenced in exam questions.

## NIST Definition of Cloud Computing (SP 800-145)

"Cloud computing is a model for enabling ubiquitous, convenient, on-demand network access to a shared pool of configurable computing resources that can be rapidly provisioned and released with minimal management effort or service provider interaction."

### Five Essential Characteristics
1. **On-demand self-service** - Customer can provision resources without human interaction with the provider
2. **Broad network access** - Available over the network via standard mechanisms (browsers, APIs, thin/thick clients)
3. **Resource pooling** - Provider's resources pooled to serve multiple consumers using a multi-tenant model
4. **Rapid elasticity** - Capabilities can be elastically provisioned and released, sometimes automatically
5. **Measured service** - Cloud systems automatically control and optimize resource use through metering

### Three Service Models
- **IaaS (Infrastructure as a Service)** - Customer provisions compute, storage, network; manages OS up
- **PaaS (Platform as a Service)** - Customer deploys applications; provider manages runtime, OS, middleware
- **SaaS (Software as a Service)** - Customer uses the application; provider manages everything below

### Four Deployment Models
- **Public** - Infrastructure provisioned for open use by the general public
- **Private** - Infrastructure provisioned for exclusive use by a single organization
- **Community** - Infrastructure shared by organizations with common concerns (security, compliance)
- **Hybrid** - Composition of two or more models; unique entities bound by standardized or proprietary technology

## CSA-Specific Architectural Concepts

### Metastructure
The connection between the cloud provider and customer, primarily:
- APIs and management interfaces
- Identity and access management
- The "glue" between the customer's environment and the provider

Metastructure is unique to cloud and a high-value attack target.

### Applistructure
Applications deployed in the cloud and services used to build them:
- Application code
- Application services (databases, queues)
- Application data

### Infrastructure Layer
Foundational cloud resources: compute, storage, network.

### Management Plane vs Data Plane
- **Management plane** - APIs and consoles that configure cloud resources
- **Data plane** - Actual interaction with data (reads, writes, compute)

Attacks on the management plane are typically more damaging because they allow creation of new resources, modification of policies, and exfiltration of keys.

## Shared Responsibility Model

Cloud security is a shared responsibility. The division shifts by service model:

| Responsibility | IaaS | PaaS | SaaS |
|----------------|------|------|------|
| Data classification | Customer | Customer | Customer |
| Data governance | Customer | Customer | Customer |
| Client protection | Customer | Customer | Customer |
| Identity and access | Customer | Customer/Shared | Shared |
| Application | Customer | Customer | Provider |
| Runtime | Customer | Provider | Provider |
| Middleware | Customer | Provider | Provider |
| Operating system | Customer | Provider | Provider |
| Virtualization | Provider | Provider | Provider |
| Network controls | Shared | Provider | Provider |
| Host infrastructure | Provider | Provider | Provider |
| Physical | Provider | Provider | Provider |

Key principles:
- Customer always responsible for data classification and identity
- Provider always responsible for physical and underlying hypervisor
- Middle layers shift based on service model
- SaaS has most provider responsibility but customer retains data and identity
- IaaS has most customer responsibility but provider retains physical/hypervisor

## Other Service Models (Beyond NIST)

- **DBaaS** - Database as a Service
- **DRaaS** - Disaster Recovery as a Service
- **DaaS** - Desktop as a Service (VDI in cloud)
- **FaaS** - Function as a Service (serverless compute)
- **STaaS** - Storage as a Service
- **CaaS** - Container as a Service
- **NaaS** - Network as a Service
- **SECaaS** - Security as a Service
- **IDaaS** - Identity as a Service
- **MBaaS** - Mobile Backend as a Service

These are typically considered subsets of PaaS or SaaS.

## Multi-Tenancy

Resources shared across customers with logical isolation. Implications:
- Side-channel attacks possible in theory
- Noisy neighbor performance impact
- Strong isolation required from provider
- Customer verifies isolation via attestations (SOC 2, ISO 27001)
- Single-tenant / dedicated options for sensitive workloads (at higher cost)

## Self-Service and Automation

- Customer provisions via portal, CLI, API
- Infrastructure as Code (IaC) enables repeatable, auditable deployments
- Automation is double-edged: faster provisioning, but also faster misconfiguration at scale
- Governance-as-code (policy as code) is the countermeasure

## Elasticity

- Scaling up/out on demand
- Scaling down when not needed (cost benefit)
- Auto-scaling based on metrics
- Security implications:
  - Ephemeral resources complicate forensics
  - Rapid change challenges static security tools
  - Cost control impacts security (cutting corners)

## APIs Everywhere

Cloud is API-first. Everything is an API call:
- Provisioning resources
- Configuring IAM
- Reading/writing data
- Monitoring and logging

Security implications:
- API security is cloud security
- API credentials are crown jewels
- API logging critical (who called what, when)
- Rate limiting and throttling protect against abuse

## Cloud Reference Architecture (ISO/IEC 17789)

Roles:
- **Cloud Service Customer (CSC)**
- **Cloud Service Provider (CSP)**
- **Cloud Service Partner (CSN)** - broker, auditor, integrator
- **Cloud Service User** - individual using the service on behalf of CSC
- **Cloud Service Administrator** - manages services for CSC
- **Cloud Service Business Manager** - business-level management
- **Cloud Service Integrator** - composes services
- **Cloud Service Developer** - builds apps on cloud

Cross-cutting aspects:
- Auditability
- Availability
- Governance
- Interoperability
- Maintenance and versioning
- Performance
- Portability
- Protection of PII
- Regulatory compliance
- Resiliency
- Reversibility (termination and data recovery)
- Security
- Service levels and SLA
- SOA

## Cloud-Specific Security Concerns

### Concerns Inherent to Cloud
- Vendor lock-in (proprietary services, data formats)
- Loss of control (infrastructure in provider hands)
- Multi-tenancy risks
- Data residency and sovereignty
- Compliance complexity across jurisdictions
- Supply chain dependencies
- Reversibility (can you get your data out?)

### Concerns Amplified by Cloud
- Misconfiguration (CSA top threat)
- Over-permissioned identities
- Exposed APIs
- Insecure defaults
- Speed of change outpacing governance

### Cloud-Unique Advantages
- Provider scale (better physical security, redundancy)
- Automation opportunity (IaC, policy as code)
- Elastic capacity for peak or incident response
- Geographic distribution for resiliency
- Managed services that offload security burden (DBaaS eliminates DB patching for customer)

## Trust Boundaries in Cloud

Trust boundaries:
- Between customer and provider (defined by shared responsibility)
- Between customer tenants (provider enforces isolation)
- Between customer environments (dev/prod via account separation)
- Between workloads (network segmentation, service mesh)

Identifying trust boundaries is the first step in threat modeling cloud architectures.

## Cloud Architecture Patterns

### High Availability
- Multi-AZ within region
- Multi-region for disaster tolerance
- Redundancy at every layer

### Disaster Recovery
- Backup-restore (lowest cost, highest RTO)
- Pilot light (minimal always-on)
- Warm standby (reduced capacity)
- Hot multi-region (active-active or active-passive)

### Microservices
- Decomposition into independently deployable services
- API contracts
- Service mesh for secure communication

### Serverless
- Event-driven functions
- No server management
- Ephemeral, per-invocation security context

### Edge Computing
- Compute at the edge, closer to users
- CDN integration
- Cloud edge services (Lambda@Edge, CloudFront Functions, CloudFlare Workers)

## Cloud Security Responsibilities for the Customer

The customer never delegates responsibility for:
- Data classification and content
- Identity (who has access)
- Configuration of their cloud services
- Compliance with regulations applicable to them
- Risk management for their use of cloud

## Common Exam Pitfalls

- Confusing service model responsibilities (IaaS vs PaaS vs SaaS)
- Forgetting that SaaS customers still own data classification
- Mixing metastructure and applistructure
- Not recognizing management plane vs data plane distinction
- Choosing private cloud when hybrid is more appropriate
- Assuming multi-tenancy is automatically insecure (provider controls matter)

## Quick Reference

### NIST Cloud Model
- 5 essential characteristics + 3 service models + 4 deployment models = 12 key items to memorize cold

### Cloud Responsibility Rule of Thumb
- Physical -> Provider always
- Virtualization -> Provider always in public cloud
- Data and identity -> Customer always
- Middle layers shift by service model

### CSA-Specific Vocabulary
- Metastructure = cloud management layer connection
- Applistructure = apps and app services
- Infrastructure = compute, storage, network
- Management plane = control APIs
- Data plane = data interactions
