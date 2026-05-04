---
last-updated: 2026-05-03
---

# OCI Foundations (1Z0-1085-24) - Fact Sheet

## Quick Reference

**Exam Code:** 1Z0-1085-24
**Duration:** 90 minutes
**Questions:** 60 questions
**Passing Score:** 68%
**Cost:** $95 USD
**Validity:** Lifetime (no expiration)
**Delivery:** Pearson VUE (Testing center or online proctored)

## Exam Topic Breakdown

| Topic | Weight | Focus Areas |
|-------|--------|-------------|
| Cloud Concepts | 10% | IaaS, PaaS, SaaS, deployment models |
| OCI Architecture & Core Services | 30% | Regions, ADs, FDs, tenancy, compartments |
| Compute Services | 15% | VM, bare metal, autoscaling, containers |
| Storage Services | 15% | Block, object, file, archive storage |
| Networking | 15% | VCN, subnets, gateways, load balancing |
| Database Services | 10% | Autonomous DB, DB Systems, NoSQL |
| Security & Identity | 20% | IAM, compartments, encryption, Cloud Guard |
| Observability & Management | 10% | Monitoring, logging, notifications |
| Pricing & Support | 5% | Pricing models, BYOL, support tiers |

## OCI Architecture Quick Reference

### Global Infrastructure

**Regions:**
- Localized geographic area
- 40+ regions worldwide
- Multi-AD (3 ADs) or Single-AD (1 AD with 3 FDs)
- Independent and isolated
- Format: `[country]-[city]-[number]` (e.g., us-phoenix-1)

**Availability Domains (ADs):**
- One or more isolated data centers within a region
- Physically separated (different buildings, power, cooling)
- 1-3 ADs per region
- AD numbers are customer-specific (randomized)
- Purpose: High availability and fault tolerance

**Fault Domains (FDs):**
- Logical grouping of hardware within an AD
- 3 FDs per AD
- Separate racks, switches, hardware
- Purpose: Protection against hardware failures

### Organizational Structure

**Tenancy:**
- Root compartment for your OCI account
- Unique OCID identifier
- Home region (cannot be changed)
- Billing entity

**Compartments:**
- Logical containers for organizing resources
- Maximum depth: 6 levels (root + 5 nested)
- Used for organization, access control, cost tracking
- Resources belong to one compartment (can be moved)
- Policies inherited from parent compartments

## Core Services by Category

### Compute Services

| Service | Type | Use Case |
|---------|------|----------|
| **VM Instances** | Virtual machines | Standard workloads |
| **Bare Metal** | Physical servers | High performance, licensing |
| **Dedicated VM Host** | Isolated physical server | Compliance, licensing |
| **Autoscaling** | Auto scale instances | Dynamic workload scaling |
| **OKE** | Managed Kubernetes | Container orchestration |
| **Container Instances** | Serverless containers | Run containers without K8s |
| **Functions** | Serverless compute | Event-driven functions |

**Compute Shapes:**
- **VM.Standard**: General purpose (AMD, Intel, Ampere ARM)
- **VM.DenseIO**: Local NVMe storage
- **VM.GPU**: GPU-accelerated (NVIDIA)
- **VM.Optimized**: Compute or memory optimized
- **BM** (Bare Metal): Physical servers

### Storage Services

| Service | Type | Protocol | Use Case |
|---------|------|----------|----------|
| **Block Volume** | Block storage | iSCSI | Boot/data volumes for instances |
| **Object Storage** | Object storage | HTTP/REST | Unstructured data, backups, archives |
| **File Storage** | File storage | NFS v3 | Shared file systems |
| **Archive Storage** | Cold storage | HTTP/REST | Long-term retention (10+ years) |

**Object Storage Tiers:**
- **Standard:** Hot data, frequent access, instant retrieval
- **Infrequent Access:** Cool data, occasional access, instant retrieval (lower cost)
- **Archive:** Cold data, rare access, retrieval time ~1 hour (lowest cost)

**Block Volume Performance:**
- **Lower Cost:** 2 IOPS/GB, 240 KB/s/GB
- **Balanced:** 60 IOPS/GB, 480 KB/s/GB
- **Higher Performance:** 75 IOPS/GB, 600 KB/s/GB
- **Ultra High Performance:** 225 IOPS/GB, 2,680 KB/s/GB

### Networking Services

**VCN (Virtual Cloud Network):**
- Software-defined network in OCI
- CIDR block: /16 to /30
- Regional resource (spans all ADs in region)
- Subnets: Public (internet-facing) or Private (internal)

**Gateways:**
- **Internet Gateway (IG):** Public internet access
- **NAT Gateway:** Outbound-only internet access for private subnets
- **Service Gateway:** Private access to Oracle services (Object Storage, Autonomous DB)
- **Dynamic Routing Gateway (DRG):** On-premises connectivity (VPN, FastConnect)

**Load Balancers:**
- **Public Load Balancer:** Internet-facing
- **Private Load Balancer:** Internal traffic only
- Layer 4 (TCP) and Layer 7 (HTTP/HTTPS)
- SSL/TLS termination
- Health checks and backend sets

**Security:**
- **Security Lists:** Stateful rules at subnet level (allow/deny)
- **Network Security Groups (NSGs):** Stateful rules at resource level (allow only)
- NSGs recommended over security lists (more flexible)

### Database Services

**Autonomous Database:**
- Self-driving, self-securing, self-repairing
- **ATP:** Autonomous Transaction Processing (OLTP workloads)
- **ADW:** Autonomous Data Warehouse (analytics/OLAP)
- **Autonomous JSON Database:** JSON document workloads
- Deployment: Serverless (shared) or Dedicated (isolated infrastructure)

**DB Systems:**
- **VM DB Systems:** Virtual machine databases
- **Bare Metal DB Systems:** Physical server databases
- **Exadata DB Systems:** High-performance Exadata infrastructure
- Oracle Database editions: Standard, Enterprise, Enterprise Extreme Performance
- RAC (Real Application Clusters) for high availability
- Data Guard for disaster recovery

**Other Databases:**
- **MySQL Database Service:** Fully managed MySQL with HeatWave (analytics)
- **NoSQL Database:** Flexible schema, high-performance key-value database

### Security & Identity

**IAM (Identity and Access Management):**
- **Users:** Individual identities
- **Groups:** Collection of users
- **Dynamic Groups:** Collection of resources (instances, functions)
- **Policies:** Rules defining access (who can do what, where)
- **Federation:** SAML 2.0, external identity providers

**IAM Policy Syntax:**
```
Allow <subject> to <verb> <resource-type> in <location> where <conditions>

Examples:
Allow group Developers to manage instance-family in compartment Development
Allow group NetworkAdmins to manage virtual-network-family in tenancy
Allow dynamic-group AppServers to read secret-family in compartment Production
```

**Policy Verbs (Permissions):**
- **inspect:** List resources (least privilege)
- **read:** Inspect + view details
- **use:** Read + use resource (e.g., attach volume)
- **manage:** Full access (all permissions)

**Security Services:**
- **Vault:** Key management (encryption keys, secrets storage)
- **Cloud Guard:** Automated threat detection and remediation
- **Security Zones:** Enforce security policies (e.g., encryption required)
- **Web Application Firewall (WAF):** Protect web applications from threats

**Encryption:**
- **At Rest:** All data encrypted by default (Oracle-managed keys)
- **In Transit:** TLS/SSL for all OCI services
- **Customer-Managed Keys:** Use Vault for your own keys
- **Bring Your Own Key (BYOK):** Import your encryption keys

### Observability & Management

**Monitoring:**
- Metrics for all OCI services
- Custom metrics support
- Alarms with notifications
- Metric queries and aggregation
- Free service (no additional cost)

**Logging:**
- **Audit Logs:** All API calls (who did what, when)
- **Service Logs:** Service-specific logs (VCN flow logs, load balancer logs)
- **Custom Logs:** Application logs
- Log retention: 6 months (audit), configurable (service/custom)

**Notifications:**
- Topics and subscriptions
- Protocols: Email, SMS, PagerDuty, Slack, Functions, HTTPS
- Integration with Alarms, Events

**Events:**
- Event-driven automation
- Triggers on state changes
- Actions: Notifications, Functions, Streaming

**Tagging:**
- **Free-form tags:** User-defined key-value pairs
- **Defined tags:** Namespace-based, governance policies
- Use cases: Cost tracking, automation, organization

## Pricing & Support

### Pricing Models

**Pay As You Go (PAYG):**
- Per-second billing (compute, block storage)
- No upfront commitment
- Most flexible

**Monthly Flex:**
- Commit to monthly spend
- Discounts for commitment
- Flexibility to use any services

**Annual Flex:**
- Commit to annual spend (1-year term)
- Deeper discounts (33% or more)
- Flexibility to use any services

**Universal Credits:**
- Credits can be used for any OCI service
- No specific service commitment
- Flexibility to allocate as needed

**Bring Your Own License (BYOL):**
- Use existing Oracle licenses in OCI
- Significant cost savings
- License mobility from on-premises

### Free Tier

**Always Free Resources:**
- 2 AMD Compute VMs (1/8 OCPU, 1 GB RAM each)
- 4 ARM Ampere A1 cores, 24 GB RAM
- 200 GB total block storage
- 10 GB Object Storage (Standard)
- 10 GB Archive Storage
- 2 Autonomous Databases (20 GB each)
- Load Balancer (10 Mbps)
- Monitoring, Logging, Notifications (all included)

**30-Day Trial:**
- $300 USD in free credits
- Access to all OCI services
- 30 days to use credits
- No automatic charge after trial

### Support Tiers

**Basic Support:**
- Included with all accounts (FREE)
- 24x7 access to support
- Online documentation
- Community forums
- Response time: Best effort

**Premier Support:**
- 24x7 phone support
- Faster response times (15 minutes for severity 1)
- Technical Account Manager (TAM)
- Proactive monitoring
- Cost: % of monthly OCI spend

## Common Exam Scenarios

### Scenario 1: High Availability Architecture
**Question:** Design HA architecture for web application
**Answer:** Deploy resources across multiple ADs, use load balancer, configure database standby

**Key points:**
- Multi-AD for maximum availability
- Load balancer distributes traffic
- Database replication (Data Guard)
- Multiple fault domains within each AD

### Scenario 2: Compartment Design
**Question:** How to organize resources for multiple projects and environments
**Answer:** Create compartment hierarchy by project, then by environment (dev/test/prod)

**Example:**
```
Tenancy
├── Project-A
│   ├── Dev
│   ├── Test
│   └── Prod
└── Project-B
    ├── Dev
    └── Prod
```

### Scenario 3: Storage Selection
**Question:** Choose storage for frequently accessed unstructured data
**Answer:** Object Storage Standard tier

**Storage decision tree:**
- **Block Volume:** Boot/data disks for compute instances
- **Object Storage Standard:** Frequently accessed objects
- **Object Storage Infrequent Access:** Occasionally accessed objects
- **Archive Storage:** Rarely accessed, long-term retention
- **File Storage:** Shared file system (NFS)

### Scenario 4: Network Security
**Question:** Allow web traffic to public subnet, block everything else
**Answer:** Configure security list or NSG with allow rule for ports 80/443, implicit deny for rest

**Security rules:**
- Ingress: Allow TCP 80, 443 from 0.0.0.0/0
- Egress: Allow all (or specific as needed)
- Default: Deny all (implicit)

### Scenario 5: IAM Policy
**Question:** Allow developers to manage compute instances in Dev compartment
**Answer:** `Allow group Developers to manage instance-family in compartment Dev`

**Policy components:**
- Subject: group Developers
- Verb: manage (full control)
- Resource: instance-family
- Location: compartment Dev

## Key Terminology

| Term | Definition |
|------|------------|
| **Region** | Geographic area with one or more ADs |
| **Availability Domain (AD)** | Isolated data center within region |
| **Fault Domain (FD)** | Hardware grouping within AD |
| **Tenancy** | Your OCI root account/compartment |
| **Compartment** | Logical container for resources |
| **OCID** | Oracle Cloud Identifier (unique ID) |
| **VCN** | Virtual Cloud Network (software-defined network) |
| **CIDR** | Classless Inter-Domain Routing (IP address range) |
| **IGW** | Internet Gateway (public internet access) |
| **NAT** | Network Address Translation (outbound-only internet) |
| **SGW** | Service Gateway (private Oracle service access) |
| **DRG** | Dynamic Routing Gateway (on-premises connectivity) |
| **NSG** | Network Security Group (resource-level firewall) |
| **ATP** | Autonomous Transaction Processing |
| **ADW** | Autonomous Data Warehouse |
| **OKE** | Oracle Container Engine for Kubernetes |
| **BYOL** | Bring Your Own License |

## Critical Facts to Memorize

**Architecture:**
- Multi-AD region = 3 ADs
- Single-AD region = 1 AD with 3 FDs
- Compartments max depth = 6 levels (root + 5)
- AD numbers are customer-specific (randomized)

**Networking:**
- VCN CIDR range: /16 to /30
- Security Lists = subnet level (allow/deny)
- NSGs = resource level (allow only)
- DRG connects to on-premises

**Storage:**
- Block Volume max size = 32 TB
- Object Storage max object size = 10 TB
- Archive retrieval time = ~1 hour
- File Storage protocol = NFS v3

**Database:**
- Autonomous DB types: ATP (OLTP), ADW (OLAP/analytics), JSON
- Deployment modes: Serverless (shared), Dedicated (isolated)
- Data Guard = disaster recovery/standby

**IAM:**
- Policy verbs: inspect < read < use < manage
- Dynamic Groups = group of resources (not users)
- Federation = SAML 2.0

**Pricing:**
- Always Free: 2 VMs, 4 ARM cores, 2 Autonomous DBs
- Trial: $300 credits for 30 days
- BYOL = use existing Oracle licenses

## Last-Minute Review Checklist

- [ ] Know difference between AD and FD
- [ ] Understand compartment hierarchy (max 6 levels)
- [ ] Memorize IAM policy syntax
- [ ] Know storage types and use cases
- [ ] Understand gateway types (IG, NAT, SGW, DRG)
- [ ] Know Autonomous DB types (ATP, ADW)
- [ ] Understand security lists vs NSGs
- [ ] Know Always Free tier limits
- [ ] Understand BYOL benefits
- [ ] Know region/AD architecture for HA

## Common Gotchas

**Architecture:**
- ❌ AD numbers are the same for all customers → ✅ AD numbers are customer-specific
- ❌ Compartments can be 10 levels deep → ✅ Maximum 6 levels
- ❌ Tenancy home region can be changed → ✅ Home region is permanent

**Networking:**
- ❌ Security lists are resource-level → ✅ Security lists are subnet-level (NSGs are resource-level)
- ❌ NAT Gateway allows inbound traffic → ✅ NAT is outbound-only
- ❌ Service Gateway requires internet access → ✅ Service Gateway is private (no internet)

**IAM:**
- ❌ Dynamic Groups contain users → ✅ Dynamic Groups contain resources
- ❌ 'use' verb gives full access → ✅ 'manage' verb gives full access

**Storage:**
- ❌ Archive Storage has instant retrieval → ✅ Archive has ~1 hour retrieval time
- ❌ Block Volume is for unstructured data → ✅ Block Volume is for structured data (boot/data disks)

---

**Good luck on your OCI Foundations exam!** Focus on hands-on practice with the Free Tier.
