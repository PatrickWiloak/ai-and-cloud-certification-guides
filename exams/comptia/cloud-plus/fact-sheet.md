# CompTIA Cloud+ (CV0-004) Fact Sheet

## Quick Reference

**Exam Code:** CV0-004
**Duration:** 90 minutes
**Questions:** Up to 90 (MCQ + performance-based)
**Passing Score:** 750/900
**Cost:** $369 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Cloud Architecture | 13% | Deployment models, service models, design principles |
| Security | 20% | IAM, data protection, network security, compliance |
| Deployment | 23% | Migration, automation, IaC, containers, CI/CD |
| Operations and Support | 22% | Monitoring, optimization, change management, SLAs |
| Troubleshooting | 22% | Connectivity, performance, security, automation |

## Cloud Deployment Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **Public** | Resources shared across tenants, provider-managed | Cost-effective, scalable workloads |
| **Private** | Dedicated infrastructure for single organization | Compliance, sensitive data, full control |
| **Hybrid** | Mix of public and private with orchestration | Burst capacity, data sovereignty |
| **Multi-cloud** | Services across multiple cloud providers | Avoid vendor lock-in, best-of-breed |
| **Community** | Shared by organizations with common concerns | Government, healthcare, research |

**Documentation:**
- **[📖 CompTIA Cloud+ Objectives](https://www.comptia.org/certifications/cloud#examdetails)** - Official exam objectives
- **[📖 NIST Cloud Computing Definition](https://csrc.nist.gov/publications/detail/sp/800-145/final)** - SP 800-145 cloud definitions
- **[📖 NIST Cloud Reference Architecture](https://csrc.nist.gov/publications/detail/sp/500-292/final)** - SP 500-292 reference architecture

## Cloud Service Models

| Model | Provider Manages | Customer Manages | Examples |
|-------|-----------------|-----------------|----------|
| **IaaS** | Hardware, networking, virtualization | OS, middleware, apps, data | EC2, Azure VMs, GCE |
| **PaaS** | IaaS + OS, middleware, runtime | Applications, data | Elastic Beanstalk, App Engine, Azure App Service |
| **SaaS** | Entire stack | Configuration, user access | Microsoft 365, Salesforce, Gmail |
| **FaaS** | Everything except function code | Function logic | Lambda, Azure Functions, Cloud Functions |
| **DBaaS** | Database infrastructure and management | Schema, queries, data | RDS, Cloud SQL, Cosmos DB |
| **XaaS** | Anything as a Service | Varies | Storage, networking, security, desktop |

**Documentation:**
- **[📖 NIST Cloud Service Models](https://csrc.nist.gov/publications/detail/sp/800-145/final)** - Service model definitions
- **[📖 CompTIA Cloud Essentials+](https://www.comptia.org/certifications/cloud-essentials)** - Foundation cloud concepts

## High Availability and Disaster Recovery

### HA Concepts
- **Redundancy** - Duplicate components to eliminate single points of failure
- **Fault tolerance** - System continues operating despite component failure
- **Failover** - Automatic switching to standby system
- **Load balancing** - Distribute traffic across multiple instances
- **Clustering** - Group of servers acting as a single system
- **Replication** - Synchronous or asynchronous data copying

### DR Metrics
| Metric | Definition | Example |
|--------|-----------|---------|
| **RTO** | Recovery Time Objective - max acceptable downtime | 4 hours |
| **RPO** | Recovery Point Objective - max acceptable data loss | 1 hour |
| **MTTR** | Mean Time to Recovery - average recovery time | 2 hours |
| **MTBF** | Mean Time Between Failures - average uptime | 720 hours |

### DR Strategies (Cost/Speed Trade-off)
1. **Backup and Restore** - Lowest cost, highest RTO (hours to days)
2. **Pilot Light** - Minimal core infrastructure running (minutes to hours)
3. **Warm Standby** - Scaled-down copy of production (minutes)
4. **Hot Standby/Active-Active** - Full duplicate running (near-zero RTO)

## Identity and Access Management

### Authentication Methods
- **Multi-factor authentication (MFA)** - Something you know, have, are
- **Single sign-on (SSO)** - One credential set for multiple systems
- **Federation** - Trust between identity providers (SAML, OIDC, OAuth 2.0)
- **Certificate-based** - PKI certificates for authentication
- **API keys/tokens** - Programmatic access credentials

### Access Control Models
| Model | Description | Use Case |
|-------|-------------|----------|
| **RBAC** | Role-Based Access Control | Enterprise environments, standard access |
| **ABAC** | Attribute-Based Access Control | Dynamic, context-aware decisions |
| **MAC** | Mandatory Access Control | Government, classified data |
| **DAC** | Discretionary Access Control | File systems, resource owners |

**Documentation:**
- **[📖 NIST Access Control Guide](https://csrc.nist.gov/publications/detail/sp/800-162/final)** - SP 800-162 ABAC guide
- **[📖 NIST Identity Management](https://csrc.nist.gov/publications/detail/sp/800-63-3/final)** - SP 800-63 digital identity guidelines

## Encryption and Data Security

### Encryption Types
| Type | Description | Use Case |
|------|-------------|----------|
| **At rest** | Stored data encryption (AES-256) | Databases, storage volumes, backups |
| **In transit** | Data moving between systems (TLS 1.2/1.3) | API calls, web traffic, replication |
| **In use** | Data being processed (confidential computing) | Sensitive computations |
| **Client-side** | Encrypted before sending to cloud | Maximum control, compliance |
| **Server-side** | Cloud provider encrypts at storage | Default protection, managed keys |

### Key Management
- **Provider-managed keys** - Cloud provider creates and manages keys
- **Customer-managed keys (CMK)** - Customer controls key lifecycle
- **Customer-supplied keys (CSEK)** - Customer provides encryption keys
- **Hardware Security Modules (HSM)** - FIPS 140-2 validated key storage
- **Key rotation** - Regular replacement of encryption keys

## Compliance Frameworks

| Framework | Scope | Industry |
|-----------|-------|----------|
| **SOC 2** | Security, availability, processing integrity, confidentiality, privacy | Technology, SaaS |
| **ISO 27001** | Information security management system | Global standard |
| **HIPAA** | Protected Health Information (PHI) | Healthcare (US) |
| **PCI-DSS** | Cardholder data protection | Payment card processing |
| **GDPR** | Personal data protection | EU/EEA data subjects |
| **FedRAMP** | Cloud security assessment | US Federal government |
| **NIST CSF** | Cybersecurity framework - Identify, Protect, Detect, Respond, Recover | US organizations |

## Migration Strategies (The 7 Rs)

| Strategy | Description | Effort | Cost |
|----------|-------------|--------|------|
| **Rehost** | Lift-and-shift - move as-is | Low | Low initial |
| **Replatform** | Lift-and-reshape - minor optimization | Medium | Medium |
| **Refactor** | Re-architect for cloud-native | High | High initial, low ongoing |
| **Repurchase** | Replace with SaaS solution | Medium | Variable |
| **Retire** | Decommission unused applications | Low | Savings |
| **Retain** | Keep on-premises for now | None | Existing |
| **Relocate** | Move to different cloud/region | Low-Medium | Medium |

## Automation and IaC Tools

| Tool | Type | Language | Provider |
|------|------|----------|----------|
| **Terraform** | IaC - provisioning | HCL | Multi-cloud |
| **CloudFormation** | IaC - provisioning | JSON/YAML | AWS |
| **ARM Templates/Bicep** | IaC - provisioning | JSON/Bicep | Azure |
| **Ansible** | Configuration management | YAML | Multi-platform |
| **Puppet** | Configuration management | Puppet DSL | Multi-platform |
| **Chef** | Configuration management | Ruby DSL | Multi-platform |
| **Docker** | Containerization | Dockerfile | Multi-platform |
| **Kubernetes** | Container orchestration | YAML | Multi-platform |

**Documentation:**
- **[📖 Terraform Documentation](https://developer.hashicorp.com/terraform/docs)** - IaC provisioning tool
- **[📖 Ansible Documentation](https://docs.ansible.com/)** - Configuration management
- **[📖 Kubernetes Documentation](https://kubernetes.io/docs/)** - Container orchestration

## Container Concepts

### Docker
- **Image** - Read-only template for creating containers
- **Container** - Running instance of an image
- **Dockerfile** - Build instructions for images
- **Registry** - Storage for container images (Docker Hub, ECR, ACR, GCR)
- **Compose** - Multi-container application definition

### Kubernetes
- **Pod** - Smallest deployable unit (one or more containers)
- **Service** - Network endpoint for accessing pods
- **Deployment** - Declarative pod management and scaling
- **Namespace** - Virtual cluster for resource isolation
- **Ingress** - HTTP/HTTPS routing rules
- **ConfigMap/Secret** - Configuration and sensitive data management

## Monitoring and Logging

### Key Metrics
| Category | Metrics | Tools |
|----------|---------|-------|
| **Compute** | CPU, memory, disk I/O | CloudWatch, Azure Monitor, Cloud Monitoring |
| **Network** | Bandwidth, latency, packet loss | VPC Flow Logs, NSG Flow Logs |
| **Storage** | IOPS, throughput, capacity | Provider-native monitoring |
| **Application** | Response time, error rate, throughput | APM tools, custom metrics |
| **Cost** | Spend, budget alerts, forecasts | Cost Explorer, Azure Cost Management |

### Logging Hierarchy
1. **Infrastructure logs** - OS, hypervisor, network devices
2. **Application logs** - Application events, errors, transactions
3. **Security logs** - Authentication, authorization, access events
4. **Audit logs** - Configuration changes, API calls, compliance events

## Service Level Agreements

| Metric | Definition | Typical Target |
|--------|-----------|----------------|
| **Availability** | Uptime percentage | 99.9% - 99.999% |
| **Response Time** | API/service response latency | < 200ms |
| **Throughput** | Transactions per second | Application-specific |
| **Support Response** | Time to acknowledge issues | 15 min - 4 hours |

### Uptime Calculations
| SLA | Annual Downtime | Monthly Downtime |
|-----|-----------------|------------------|
| 99% | 3.65 days | 7.31 hours |
| 99.9% | 8.77 hours | 43.83 minutes |
| 99.95% | 4.38 hours | 21.92 minutes |
| 99.99% | 52.60 minutes | 4.38 minutes |
| 99.999% | 5.26 minutes | 26.30 seconds |

## Troubleshooting Methodology

1. **Identify** - Gather information, define the problem
2. **Establish theory** - Consider probable causes
3. **Test theory** - Validate or eliminate causes
4. **Establish plan** - Define resolution steps
5. **Implement** - Execute the fix
6. **Verify** - Confirm resolution
7. **Document** - Record findings and resolution

## Common Exam Scenarios

1. **"Vendor-neutral high availability"** - Multi-cloud with load balancing and failover
2. **"Compliance requirement"** - Match framework to industry (HIPAA for healthcare, PCI-DSS for payments)
3. **"Cost optimization"** - Right-sizing, reserved instances, auto-scaling, spot instances
4. **"Migration strategy"** - Match application characteristics to migration approach
5. **"Secure data in transit"** - TLS/SSL, VPN, encrypted connections
6. **"Automate infrastructure"** - IaC tools (Terraform for multi-cloud, CloudFormation for AWS-only)
7. **"Container orchestration"** - Kubernetes for scaling, Docker for packaging
8. **"Troubleshoot connectivity"** - DNS, firewall rules, routing tables, VPN tunnels
9. **"Disaster recovery"** - Match RTO/RPO requirements to DR strategy
10. **"Identity federation"** - SAML, OIDC, SSO for cross-organization access

## Study Priorities

### High Priority (Must Know)
- Cloud deployment and service models
- Security controls and compliance frameworks
- Migration strategies and planning
- Monitoring, logging, and alerting
- Troubleshooting methodology and common issues
- High availability and disaster recovery concepts

### Medium Priority (Important)
- IaC tools and automation
- Container and orchestration concepts
- Identity and access management models
- Encryption and key management
- SLA management and calculations
- Change management processes

### Lower Priority (Good to Know)
- Specific cloud provider implementations
- Advanced networking concepts
- DevOps pipeline details
- Cost optimization strategies
- Performance tuning specifics

---

**Good luck on your exam!** Focus on understanding vendor-neutral cloud concepts that apply across all major cloud providers.
