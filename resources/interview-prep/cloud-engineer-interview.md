# Cloud Engineer Interview Preparation Guide

## Overview

Cloud Engineer interviews test your understanding of cloud fundamentals, networking, security, migration, troubleshooting, and cost management. This guide covers common questions and scenarios across AWS, Azure, and GCP to help you prepare.

---

## Cloud Fundamentals Questions

### What Is the Shared Responsibility Model?

- Cloud provider is responsible for security **of** the cloud:
  - Physical infrastructure (data centers, hardware, networking)
  - Hypervisor and host operating system
  - Managed service infrastructure
- Customer is responsible for security **in** the cloud:
  - Data classification and encryption
  - Identity and access management
  - Network configuration (security groups, NACLs)
  - Operating system patches (for IaaS)
  - Application code and dependencies

The boundary shifts depending on the service model:
- **IaaS** (EC2, Compute Engine, Azure VMs): customer manages OS and up
- **PaaS** (Elastic Beanstalk, App Engine, App Service): customer manages application and data
- **SaaS** (WorkMail, Google Workspace, Microsoft 365): customer manages data and access
- Documentation: https://aws.amazon.com/compliance/shared-responsibility-model/

### Explain Regions, Availability Zones, and Edge Locations

- **Region**: geographic area with multiple data centers (us-east-1, europe-west1)
  - Choose based on: latency to users, compliance requirements, service availability, cost
- **Availability Zone (AZ)**: one or more isolated data centers within a region
  - Connected via low-latency fiber within a region
  - Independent power, cooling, and networking
  - Deploy across multiple AZs for high availability
- **Edge locations**: CDN points of presence for content caching
  - CloudFront (AWS), Cloud CDN (GCP), Azure CDN
  - Reduce latency for static content delivery

### What Is the Difference Between Vertical and Horizontal Scaling?

- **Vertical scaling (scale up)**: increase the size of a single instance
  - Example: t3.medium to t3.xlarge
  - Simpler but has upper limits
  - Usually requires downtime
- **Horizontal scaling (scale out)**: add more instances
  - Example: 2 instances to 10 instances behind a load balancer
  - No upper limit, better fault tolerance
  - Requires stateless application design
  - Use auto-scaling groups/managed instance groups

### Explain IaaS, PaaS, SaaS, and FaaS

| Model | You Manage | Provider Manages | Examples |
|-------|-----------|------------------|----------|
| IaaS | OS, runtime, app, data | Hardware, networking, virtualization | EC2, Compute Engine, Azure VMs |
| PaaS | App code and data | OS, runtime, scaling, patching | Elastic Beanstalk, App Engine, App Service |
| FaaS | Function code | Everything else | Lambda, Cloud Functions, Azure Functions |
| SaaS | Data and access | Everything | Gmail, Salesforce, Microsoft 365 |

---

## Networking Scenarios

### Design a VPC for a Three-Tier Web Application

- VPC CIDR: /16 (e.g., 10.0.0.0/16 - 65,536 addresses)
- Subnet design across 2+ Availability Zones:
  - Public subnets: load balancers, bastion hosts (/24 per AZ)
  - Private subnets: application servers (/24 per AZ)
  - Data subnets: databases, caches (/24 per AZ)
- Internet Gateway for public subnets
- NAT Gateway in public subnet for private subnet outbound access
- Route tables: public subnets route 0.0.0.0/0 to IGW, private subnets route to NAT Gateway
- Security groups: layer-specific rules (ALB allows 80/443, app allows traffic from ALB only)
- Documentation: https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

### How Does DNS Resolution Work in the Cloud?

- **Public DNS**: Route 53 (AWS), Cloud DNS (GCP), Azure DNS
  - Managed authoritative DNS service
  - Routing policies: simple, weighted, latency-based, geolocation, failover
- **Private DNS**: resolve internal hostnames within VPCs
  - AWS: Route 53 Resolver, Private Hosted Zones
  - GCP: Cloud DNS Private Zones
  - Azure: Azure Private DNS Zones
- **Hybrid DNS**: resolve between on-premises and cloud
  - Forwarding rules for conditional DNS resolution
  - AWS Route 53 Resolver endpoints (inbound and outbound)
  - GCP Cloud DNS forwarding zones
  - Azure Private DNS Resolver

### Explain Load Balancing Options

#### Application Load Balancer (Layer 7)

- HTTP/HTTPS traffic routing
- Path-based and host-based routing
- WebSocket support
- AWS ALB, Azure Application Gateway, GCP HTTP(S) Load Balancer

#### Network Load Balancer (Layer 4)

- TCP/UDP traffic at high throughput
- Static IP support
- Ultra-low latency
- AWS NLB, Azure Load Balancer, GCP TCP/UDP Load Balancer

#### Global Load Balancing

- Distribute traffic across regions
- AWS Global Accelerator, Azure Front Door/Traffic Manager, GCP Global Load Balancer
- Anycast IP for nearest region routing

### What Is a VPN and When Would You Use One?

- Site-to-Site VPN: encrypted tunnel between on-premises network and cloud VPC
- Point-to-Site VPN: individual client connections to cloud network
- Use cases:
  - Hybrid connectivity before dedicated connections are ready
  - Backup connection for dedicated links (Direct Connect, ExpressRoute)
  - Secure remote access for administrators
  - Connecting multiple cloud environments

---

## Security Questions

### IAM Best Practices

- Follow the principle of least privilege - grant only necessary permissions
- Use roles instead of long-lived access keys
- Enable multi-factor authentication (MFA) for all human users
- Use groups or policies for permission management, not individual user assignments
- Regularly review and rotate credentials
- Use service-linked roles for AWS services
- Implement permission boundaries to limit maximum permissions
- Enable CloudTrail/Cloud Audit Logs for API activity monitoring
- Documentation: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

### Explain Encryption at Rest and in Transit

**Encryption at rest:**
- Protects data stored on disk
- AWS: KMS-managed keys, S3 SSE, EBS encryption
- GCP: default encryption with Google-managed keys, CMEK, CSEK
- Azure: Storage Service Encryption, Azure Disk Encryption
- Use customer-managed keys (CMK) when you need key rotation control

**Encryption in transit:**
- Protects data moving between services and users
- TLS/SSL for HTTPS connections
- VPN or private connectivity for network-level encryption
- Service-to-service encryption (mTLS in service mesh)
- Certificate management: ACM (AWS), Let's Encrypt, Azure App Service Certificates

### How Would You Secure a Public-Facing Web Application?

1. **Network layer**: WAF (Web Application Firewall), DDoS protection (Shield, Cloud Armor)
2. **Transport layer**: TLS 1.2+ only, HSTS headers, certificate management
3. **Application layer**: input validation, CSRF protection, Content Security Policy
4. **Authentication**: OAuth 2.0/OIDC, MFA, session management
5. **Authorization**: role-based access control, API keys with rate limiting
6. **Data layer**: encryption at rest and in transit, database access via private network only
7. **Monitoring**: logging all access, anomaly detection, automated alerts
8. **Compliance**: regular penetration testing, vulnerability scanning, patch management

### What Is VPC Service Controls / Private Link?

- Restrict access to cloud services from within your VPC only
- **AWS PrivateLink**: access AWS services and third-party services privately
- **GCP VPC Service Controls**: security perimeter around GCP services to prevent data exfiltration
- **Azure Private Link**: private connectivity to Azure PaaS services
- Benefits: no data traverses the public internet, reduced attack surface

---

## Migration Scenarios

### How Would You Migrate a Monolithic Application to the Cloud?

**Phase 1 - Rehost (Quick Win)**
1. Assess the application (dependencies, resources, networking)
2. Set up target cloud environment (VPC, security groups, IAM)
3. Use migration tools (AWS MGN, Azure Site Recovery, Migrate to VMs)
4. Test in cloud environment
5. Cut over with DNS change

**Phase 2 - Modernize (If Needed)**
1. Containerize the monolith as a first step
2. Extract services incrementally (strangler fig pattern)
3. Move to managed databases (RDS, Cloud SQL)
4. Add auto-scaling and load balancing
5. Implement CI/CD pipeline

### How Would You Migrate a Large Database (5 TB) with Minimal Downtime?

1. Set up target database in the cloud
2. Use continuous replication (DMS, Azure DMS, GCP DMS)
3. Perform initial full load (may take hours depending on bandwidth)
4. Monitor replication lag until it reaches near-zero
5. Schedule cutover window
6. Stop writes to source, wait for final sync
7. Switch application connection strings to target
8. Validate data integrity
9. Expected downtime: 5-30 minutes

### How Do You Handle Stateful Applications During Migration?

- Externalize state: move session data to Redis/ElastiCache/Memorystore
- Database migration: use replication for minimal downtime
- File storage: sync to cloud storage (S3, GCS, Azure Blob) before cutover
- Persistent volumes: replicate using storage migration tools
- Application configuration: environment variables and secret management

---

## Troubleshooting Exercises

### Scenario: Users Cannot Access the Application

Troubleshooting steps:
1. Check application health: is the service running? Check container/instance status
2. Check load balancer: are health checks passing? Are targets healthy?
3. Check DNS: does the domain resolve to the correct IP? `nslookup`, `dig`
4. Check security groups: is port 80/443 allowed from 0.0.0.0/0?
5. Check NACLs: are inbound and outbound rules correct?
6. Check route tables: is there a route to the internet gateway?
7. Check certificates: is the TLS certificate valid and not expired?
8. Check application logs: are there errors in the application itself?

### Scenario: Application Is Slow

Troubleshooting steps:
1. Identify the bottleneck: is it compute, database, network, or external dependency?
2. Check metrics: CPU, memory, disk I/O, network throughput
3. Check database: slow queries, connection pool exhaustion, lock contention
4. Check caching: cache hit rate, cache size, eviction rate
5. Check external calls: latency to third-party APIs
6. Check auto-scaling: are new instances being added? Is scaling policy correct?
7. Check CDN: is static content being cached? Check cache hit ratio
8. Profile the application: identify hot code paths and memory leaks

### Scenario: Costs Spiked Unexpectedly

Investigation steps:
1. Check billing dashboard for top cost drivers
2. Compare current usage with historical baseline
3. Look for: unintended instance types, unused resources, data transfer spikes
4. Check for runaway auto-scaling (scaling up but never down)
5. Review recent infrastructure changes (new services deployed)
6. Check for orphaned resources (EBS volumes, load balancers, NAT gateways)
7. Set up billing alerts and budgets to prevent future surprises

---

## Cost Management Questions

### How Do You Optimize Cloud Costs?

1. **Right-sizing**: match instance types to actual workload needs
   - Use AWS Compute Optimizer, Azure Advisor, GCP Recommender
2. **Commitment discounts**: Reserved Instances, Savings Plans, Committed Use
3. **Spot/Preemptible instances**: for fault-tolerant workloads (up to 90% savings)
4. **Auto-scaling**: scale down during off-peak hours
5. **Storage optimization**: lifecycle policies, appropriate storage tiers
6. **Unused resource cleanup**: unattached volumes, idle instances, old snapshots
7. **Tagging strategy**: tag all resources for cost allocation and reporting
8. **Monitoring**: set up budgets and alerts for anomaly detection

### Explain the Different Pricing Models

| Model | Best For | Savings | Commitment |
|-------|---------|---------|------------|
| On-demand | unpredictable workloads | None (baseline) | None |
| Reserved/Committed | steady-state workloads | 30-72% | 1-3 years |
| Savings Plans | flexible commitment | 20-66% | 1-3 years |
| Spot/Preemptible | fault-tolerant batch jobs | 60-90% | None (can be interrupted) |

### How Would You Implement a Tagging Strategy?

- Required tags: Environment, Owner, Project, CostCenter
- Optional tags: Application, Team, ExpirationDate
- Enforce tagging via:
  - AWS: Service Control Policies, AWS Config rules
  - Azure: Azure Policy (deny untagged resources)
  - GCP: Organization policies, labels
- Use tags for: cost allocation, automation (start/stop schedules), security policies
- Review and enforce compliance regularly

---

## Key Documentation Links

| Resource | URL |
|----------|-----|
| AWS Well-Architected | https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html |
| Azure Architecture Center | https://learn.microsoft.com/en-us/azure/architecture/ |
| GCP Architecture Framework | https://cloud.google.com/architecture/framework |
| AWS IAM Best Practices | https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| Kubernetes Docs | https://kubernetes.io/docs/home/ |
| Terraform Docs | https://developer.hashicorp.com/terraform/docs |

---

## Tips for Cloud Engineer Interviews

- Know at least one cloud provider deeply and be familiar with equivalents in others
- Practice drawing architecture diagrams and explaining them clearly
- Be prepared to troubleshoot live scenarios (think out loud)
- Understand networking fundamentals (TCP/IP, DNS, HTTP, TLS)
- Know the basics of Linux administration and command-line tools
- Be ready to discuss cost optimization - it comes up in almost every interview
- Show awareness of security best practices at every layer
- Demonstrate understanding of automation and infrastructure as code
- Practice the STAR method for behavioral questions
- Ask clarifying questions before answering - it shows experience
