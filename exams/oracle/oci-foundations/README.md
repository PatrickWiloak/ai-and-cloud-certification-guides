# Oracle Cloud Infrastructure Foundations (1Z0-1085-24)

The OCI Foundations certification validates foundational knowledge of core cloud computing concepts and Oracle Cloud Infrastructure services. This is the entry-level certification for anyone starting with OCI.

## 📋 Quick Links

- [**Fact Sheet**](fact-sheet.md) - Exam logistics and objectives
- [**Practice Plan**](practice-plan.md) - Structured study schedule
- [**Study Strategy**](strategy.md) - Focused preparation approach
- [**One-Page Cram**](cram-1p.md) - Critical concepts at a glance

## 📚 Study Materials

### Core Notes
- [Cloud Fundamentals And OCI Architecture](notes/01-cloud-fundamentals-and-oci-architecture.md)
- [Core Services](notes/02-core-services.md)
- [Security IAM Observability](notes/03-security-iam-observability.md)
## 🎯 Exam Details

- **Exam Code**: 1Z0-1085-24
- **Duration**: 90 minutes
- **Number of Questions**: 60 questions
- **Passing Score**: 68%
- **Question Types**: Multiple choice, multiple select
- **Cost**: $95 USD
- **Validity**: Lifetime (no expiration)
- **Language**: Available in multiple languages
- **Delivery**: Pearson VUE (online proctored or test center)

## 📖 Exam Topics

### 1. Cloud Concepts (10%)
- **Cloud Computing Models**
  - IaaS, PaaS, SaaS characteristics
  - Public, private, hybrid cloud
  - Cloud deployment strategies

- **Cloud Benefits**
  - Elasticity and scalability
  - Cost efficiency and CapEx vs OpEx
  - High availability and disaster recovery
  - Global reach and performance

- **Oracle Cloud Infrastructure**
  - OCI value proposition
  - OCI vs competitors (AWS, Azure, GCP)
  - Oracle's generation 2 cloud advantages

### 2. OCI Architecture and Core Services (30%)
- **Physical Architecture**
  - Regions and availability domains
  - Fault domains for high availability
  - Edge locations and FastConnect

- **Logical Architecture**
  - Tenancy and compartments
  - Identity and Access Management (IAM)
  - Resources and resource managers

- **Core OCI Services Overview**
  - Compute: VM, bare metal, GPU instances
  - Storage: Block, object, file, archive
  - Networking: VCN, subnets, gateways
  - Database: Autonomous, VM DB, Exadata

### 3. Compute Services (15%)
- **Compute Instances**
  - Shapes: VM.Standard, VM.DenseIO, BM (bare metal)
  - Custom images and boot volumes
  - Instance metadata and cloud-init

- **Instance Scaling**
  - Vertical scaling (change shape)
  - Horizontal scaling (instance pools)
  - Autoscaling policies

- **Container Services**
  - Oracle Container Engine for Kubernetes (OKE)
  - Container Registry (OCIR)
  - Container Instances

- **Other Compute**
  - Functions (serverless)
  - Dedicated VM hosts

### 4. Storage Services (15%)
- **Block Volume**
  - Block volume characteristics
  - Volume performance tiers
  - Backup and cloning
  - Boot volumes vs block volumes

- **Object Storage**
  - Buckets and objects
  - Storage tiers (Standard, Infrequent Access, Archive)
  - Pre-authenticated requests
  - Lifecycle policies

- **File Storage**
  - Network File System (NFS)
  - Mount targets and export paths
  - Snapshots and cloning

- **Archive Storage**
  - Long-term retention
  - Retrieval times and costs

### 5. Networking (15%)
- **Virtual Cloud Network (VCN)**
  - CIDR blocks and subnets
  - Public vs private subnets
  - Route tables and routing rules

- **Gateways**
  - Internet Gateway (IG)
  - NAT Gateway
  - Service Gateway (for Oracle services)
  - Dynamic Routing Gateway (DRG) for hybrid

- **Security**
  - Security lists (stateful)
  - Network Security Groups (NSGs)
  - Security best practices

- **Load Balancing**
  - Load balancer types (public, private)
  - Backend sets and health checks
  - SSL/TLS termination

### 6. Database Services (10%)
- **Autonomous Database**
  - Autonomous Transaction Processing (ATP)
  - Autonomous Data Warehouse (ADW)
  - Autonomous JSON Database
  - Serverless vs dedicated infrastructure

- **DB Systems**
  - VM DB systems
  - Bare metal DB systems
  - Exadata DB systems
  - RAC and Data Guard

- **NoSQL and Other Databases**
  - NoSQL Database Cloud Service
  - MySQL Database Service
  - PostgreSQL (coming)

### 7. Security and Identity (20%)
- **Identity and Access Management (IAM)**
  - Users, groups, and dynamic groups
  - Policies and policy syntax
  - Federation with external identity providers
  - MFA and password policies

- **Compartments**
  - Organizational hierarchy
  - Resource isolation
  - Policy inheritance

- **Security Services**
  - Vault (key management, secrets)
  - Web Application Firewall (WAF)
  - Cloud Guard (threat detection)
  - Security Zones (enforce policies)

- **Data Protection**
  - Encryption at rest and in transit
  - Customer-managed keys vs Oracle-managed
  - Data Safe for database security

### 8. Observability and Management (10%)
- **Monitoring**
  - Metrics and alarms
  - Service metrics and custom metrics
  - Alarm notifications

- **Logging**
  - Audit logs
  - Service logs
  - Custom logs

- **Notifications**
  - Topics and subscriptions
  - Email, SMS, PagerDuty, Slack

- **Resource Management**
  - Tagging (free-form and defined tags)
  - Cost tracking and budgets
  - Resource Manager (Terraform)

### 9. Pricing and Support (5%)
- **Pricing Models**
  - Pay-as-you-go vs monthly flex
  - Universal Credits
  - Bring Your Own License (BYOL)
  - Free tier and always free resources

- **Cost Management**
  - Cost analysis and reporting
  - Budgets and cost tracking tags
  - Cost optimization tools

- **Support Tiers**
  - Basic (included)
  - Premier Support
  - SLAs and response times

## 🎓 Prerequisites & Target Audience

### No Prerequisites Required
This is an entry-level certification with no formal prerequisites. However, beneficial background includes:
- Basic understanding of cloud computing concepts
- Familiarity with IT infrastructure (compute, storage, networking)
- Interest in Oracle Cloud technologies

### Target Audience
- **Cloud beginners**: Starting their cloud journey
- **IT professionals**: Evaluating OCI for their organization
- **Students**: Building cloud computing knowledge
- **Technical sales**: Understanding OCI capabilities
- **Developers**: Planning to build on OCI
- **Administrators**: Managing OCI resources

## 🌟 OCI Service Coverage

### Compute
- **Compute Instances**: VMs, bare metal, GPU shapes
- **Autoscaling**: Instance pools with scaling policies
- **Container Engine**: Managed Kubernetes (OKE)
- **Functions**: Serverless event-driven compute
- **Container Registry**: Docker image repository

### Storage
- **Block Volume**: High-performance block storage
- **Object Storage**: Scalable object storage with tiers
- **File Storage**: NFSv3-compatible shared file system
- **Archive Storage**: Long-term cold storage

### Networking
- **Virtual Cloud Network**: Software-defined networking
- **Load Balancer**: Layer 4 and Layer 7 load balancing
- **FastConnect**: Dedicated private connectivity
- **VPN**: Site-to-site IPSec VPN
- **DNS**: Managed DNS service

### Database
- **Autonomous Database**: Self-driving, self-securing, self-repairing
- **DB Systems**: VM, bare metal, and Exadata options
- **MySQL Database Service**: Fully managed MySQL with HeatWave
- **NoSQL Database**: Flexible schema database

### Security
- **Identity and Access Management**: User and policy management
- **Vault**: Key management and secrets storage
- **Cloud Guard**: Automated threat detection
- **Security Zones**: Policy enforcement for maximum security

### Observability
- **Monitoring**: Metrics, alarms, and dashboards
- **Logging**: Centralized log management
- **Notifications**: Event-driven alerting
- **Events**: Event routing service

## Study Strategy

### Recommended Timeline: 4-6 Weeks

**Week 1: Cloud Fundamentals and OCI Architecture**
- Cloud computing models and benefits
- OCI regions, ADs, and fault domains
- Tenancy and compartment structure
- IAM basics

**Week 2: Core Services (Compute and Storage)**
- Compute instance types and shapes
- Block volume and object storage
- File storage and archive storage
- Hands-on: Launch compute instances, create storage

**Week 3: Networking and Database**
- VCN components and architecture
- Gateways and routing
- Security lists and NSGs
- Autonomous Database overview
- Hands-on: Build VCN, deploy database

**Week 4: Security, Observability, and Practice**
- IAM policies and compartments
- Security services (Vault, Cloud Guard)
- Monitoring and logging
- Practice exams and review
- Hands-on: Configure IAM, set up monitoring

**Weeks 5-6: Review and Weak Areas (if needed)**
- Take multiple practice exams
- Review incorrect answers
- Deep dive into weak topics
- Final cram session

### Essential Hands-on Practice
- Create and configure a VCN with subnets
- Launch compute instances (VM and bare metal shapes)
- Create and attach block volumes
- Upload objects to Object Storage
- Deploy an Autonomous Database
- Configure IAM policies and compartments
- Set up monitoring alarms
- Create and test a load balancer

## 📚 Study Resources

### Official Oracle Resources (FREE)
- **[OCI Foundations Learning Path](https://mylearn.oracle.com/ou/learning-path/become-an-oci-foundations-associate-2024/136196)** - Official Oracle training
- **[OCI Documentation](https://docs.oracle.com/en-us/iaas/Content/home.htm)** - Comprehensive service docs
- **[OCI Architecture Center](https://docs.oracle.com/solutions/)** - Reference architectures
- **[Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)** - Always free resources + $300 credit
- **[OCI YouTube Channel](https://www.youtube.com/c/OracleCloudInfrastructure)** - Tutorial videos

### Recommended Study Materials
1. **Oracle University**: Official OCI Foundations course (FREE on mylearn.oracle.com)
2. **Oracle Cloud Infrastructure for Architects** by Prasenjit Sarkar (Book)
3. **Practice Tests**: Oracle's official practice exam
4. **Hands-on Labs**: Oracle Cloud Free Tier (required!)

### OCI Free Tier (Essential for Practice)
**Always Free Resources:**
- 2 AMD Compute VMs (1/8 OCPU, 1 GB RAM each)
- 4 ARM Ampere A1 cores and 24 GB RAM
- 200 GB total block volume storage
- 10 GB object storage (Standard tier)
- 10 GB archive storage
- Autonomous Database (2 instances, 20 GB each)
- Load balancer (10 Mbps)
- Monitoring, notifications, logging

**30-Day Free Trial:**
- $300 USD in free credits
- Access to all OCI services
- No automatic charge after trial

## Exam Tips

### Question Strategy
- Read questions carefully - OCI terminology differs from AWS/Azure
- Eliminate obviously wrong answers first
- Look for keywords indicating specific services
- Consider cost, security, and high availability
- Remember that multiple answers may be "technically correct" but one is "most correct"

### Common Question Themes
- IAM policy syntax and effect
- Compartment hierarchy and inheritance
- VCN architecture and routing
- Autonomous Database features
- Storage tier selection
- High availability with ADs and fault domains
- Security best practices
- Cost optimization strategies

### OCI-Specific Concepts to Master
- **Tenancy vs Compartment**: Root container vs organizational units
- **Availability Domains**: Isolated data centers within a region
- **Fault Domains**: Anti-affinity within an AD
- **Security Lists vs NSGs**: Subnet-level vs resource-level security
- **Autonomous Database**: Self-managing database capabilities
- **Dynamic Groups**: IAM for resources (not just users)
- **Service Gateway**: Private access to Oracle services without internet

### Time Management
- 90 minutes for 60 questions = 1.5 minutes per question
- Flag uncertain questions for review
- Don't spend more than 2 minutes on any single question
- Leave 10-15 minutes at the end for review

## 📈 Success Criteria

- Understand cloud computing fundamentals and OCI value proposition
- Explain OCI architecture: regions, ADs, fault domains, compartments
- Identify appropriate compute, storage, and networking services
- Understand IAM components and policy structure
- Recognize security best practices and services
- Demonstrate knowledge of database options
- Understand basic cost management and pricing models
- Apply observability and monitoring concepts

## Next Steps After OCI Foundations

### Career Path
1. **OCI Architect Associate** - Design solutions on OCI
2. **OCI Developer Associate** - Build applications on OCI
3. **OCI Operations Associate** - Manage and operate OCI
4. **Specialty Certifications** - Database, Security, etc.

### Related Certifications
- **OCI Architect Associate** (1Z0-1072-24) - Next recommended step
- **OCI Developer Associate** (1Z0-1084-24) - For developers
- **OCI Operations Associate** (1Z0-1067-24) - For operations focus

---

**Good luck with your OCI Foundations certification journey!** 🚀
