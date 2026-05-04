---
last-updated: 2026-05-03
---

# Azure AZ-305: Designing Microsoft Azure Infrastructure Solutions - Fact Sheet

## Quick Reference

**Exam Code:** AZ-305
**Duration:** 120 minutes (2 hours)
**Questions:** 40-60 questions (case studies + multiple choice)
**Passing Score:** 700/1000
**Cost:** $165 USD
**Validity:** 1 year (renewable annually)
**Prerequisites:** AZ-104 (Azure Administrator) recommended
**Difficulty:** ⭐⭐⭐⭐⭐ (Expert-level certification)
**Experience:** 3+ years of IT experience, including advanced Azure design skills

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Design Identity, Governance, and Monitoring Solutions | 25-30% | Azure AD, RBAC, governance, policy, monitoring |
| Design Data Storage Solutions | 25-30% | Storage accounts, databases, caching, data integration |
| Design Business Continuity Solutions | 10-15% | Backup, disaster recovery, high availability |
| Design Infrastructure Solutions | 25-30% | Compute, networking, containers, migration |

## Azure Well-Architected Framework

**[📖 Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/)** - Complete architecture framework
**[📖 Well-Architected Review](https://learn.microsoft.com/azure/well-architected/)** - Assessment tool and guidance

**Five Pillars:**
1. **Reliability** - Availability, resiliency, recovery
2. **Security** - Identity, data protection, network security
3. **Cost Optimization** - Resource optimization, monitoring
4. **Operational Excellence** - DevOps, monitoring, automation
5. **Performance Efficiency** - Scalability, load balancing

**Key Resources:**
- **[📖 Azure Architecture Center](https://learn.microsoft.com/azure/architecture/)** - Reference architectures
- **[📖 Cloud Design Patterns](https://learn.microsoft.com/azure/architecture/patterns/)** - Common architecture patterns
- **[📖 Best Practices for Cloud Applications](https://learn.microsoft.com/azure/architecture/best-practices/index-best-practices)** - Design guidance
- **[📖 Design Principles](https://learn.microsoft.com/azure/architecture/guide/design-principles/)** - Architecture principles

## Identity and Governance Architecture

### Azure Active Directory (Azure AD / Entra ID)

**Identity Foundation:**
- Cloud-based identity and access management
- Single sign-on (SSO) across applications
- Multi-factor authentication (MFA)
- Conditional Access policies
- **[📖 Azure Active Directory Overview](https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis)** - Core concepts
- **[📖 Azure AD Architecture](https://learn.microsoft.com/azure/active-directory/architecture/architecture)** - Design patterns
- **[📖 Azure AD Editions](https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis#which-license-do-i-need)** - Free, P1, P2 comparison
- **[📖 Azure AD Licensing](https://www.microsoft.com/security/business/identity-access-management/azure-ad-pricing)** - Feature comparison

**Advanced Identity Features:**
- **Azure AD B2B** - Guest user access and collaboration
- **[📖 Azure AD B2B](https://learn.microsoft.com/azure/active-directory/external-identities/what-is-b2b)** - Business-to-business identity
- **Azure AD B2C** - Customer identity and access management
- **[📖 Azure AD B2C](https://learn.microsoft.com/azure/active-directory-b2c/overview)** - Consumer identity platform
- **Azure AD Domain Services** - Managed domain services (LDAP, Kerberos)
- **[📖 Azure AD Domain Services](https://learn.microsoft.com/azure/active-directory-domain-services/overview)** - Managed domain controllers
- **Privileged Identity Management (PIM)** - Just-in-time privileged access
- **[📖 Azure AD PIM](https://learn.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure)** - Privileged access management
- **Identity Protection** - Risk-based conditional access
- **[📖 Azure AD Identity Protection](https://learn.microsoft.com/azure/active-directory/identity-protection/overview-identity-protection)** - Risk detection

### Authentication and Authorization

**Authentication Methods:**
- Password Hash Synchronization (PHS)
- Pass-through Authentication (PTA)
- Federated Authentication (ADFS)
- Seamless SSO
- **[📖 Azure AD Authentication Methods](https://learn.microsoft.com/azure/active-directory/hybrid/choose-ad-authn)** - Choosing authentication
- **[📖 Azure AD Connect](https://learn.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect)** - Hybrid identity integration
- **[📖 Azure AD Connect Health](https://learn.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect#what-is-azure-ad-connect-health)** - Monitoring hybrid identity

**Conditional Access:**
- User and group-based policies
- Location-based access
- Device compliance requirements
- Risk-based access control
- **[📖 Conditional Access Overview](https://learn.microsoft.com/azure/active-directory/conditional-access/overview)** - Policy framework
- **[📖 Conditional Access Policies](https://learn.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policies)** - Policy design
- **[📖 Common Conditional Access Policies](https://learn.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policy-common)** - Best practices

**Multi-Factor Authentication:**
- **[📖 Azure AD MFA](https://learn.microsoft.com/azure/active-directory/authentication/concept-mfa-howitworks)** - How MFA works
- **[📖 MFA Deployment Guide](https://learn.microsoft.com/azure/active-directory/authentication/howto-mfa-getstarted)** - Implementation
- **[📖 MFA Methods](https://learn.microsoft.com/azure/active-directory/authentication/concept-authentication-methods)** - Available methods

### Role-Based Access Control (RBAC)

**Authorization Model:**
- Management group, subscription, resource group, resource scopes
- Built-in roles vs custom roles
- Role assignments (security principal + role + scope)
- Deny assignments for Azure Blueprints
- **[📖 Azure RBAC Overview](https://learn.microsoft.com/azure/role-based-access-control/overview)** - Core concepts
- **[📖 Azure Built-in Roles](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles)** - Complete role list
- **[📖 Custom Roles](https://learn.microsoft.com/azure/role-based-access-control/custom-roles)** - Creating custom roles
- **[📖 RBAC Best Practices](https://learn.microsoft.com/azure/role-based-access-control/best-practices)** - Security guidelines

**Key Built-in Roles:**
- **Owner** - Full access including access management
- **Contributor** - Full access except access management
- **Reader** - View all resources
- **User Access Administrator** - Manage user access only

### Governance and Compliance

**Management Groups:**
- Hierarchical organization structure
- Policy and RBAC inheritance
- Up to 6 levels deep (excluding root and subscription)
- **[📖 Management Groups](https://learn.microsoft.com/azure/governance/management-groups/overview)** - Organizational hierarchy
- **[📖 Management Group Design](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)** - Design patterns

**Azure Policy:**
- Enforce organizational standards
- Assess compliance at scale
- Built-in and custom policy definitions
- Policy initiatives (policy sets)
- Remediation tasks for non-compliant resources
- **[📖 Azure Policy Overview](https://learn.microsoft.com/azure/governance/policy/overview)** - Policy framework
- **[📖 Policy Definitions](https://learn.microsoft.com/azure/governance/policy/concepts/definition-structure)** - Policy structure
- **[📖 Policy Assignment Structure](https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure)** - Assignment design
- **[📖 Built-in Policies](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies)** - Policy library
- **[📖 Remediation Tasks](https://learn.microsoft.com/azure/governance/policy/how-to/remediate-resources)** - Fixing non-compliance

**Azure Blueprints:**
- Repeatable environment deployment
- Artifacts: Resource groups, ARM templates, policies, role assignments
- Blueprint versioning and lifecycle
- **[📖 Azure Blueprints](https://learn.microsoft.com/azure/governance/blueprints/overview)** - Environment orchestration
- **[📖 Blueprint Lifecycle](https://learn.microsoft.com/azure/governance/blueprints/concepts/lifecycle)** - Version management

**Resource Organization:**
- **[📖 Resource Naming Conventions](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)** - Naming standards
- **[📖 Resource Tagging](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)** - Tag strategy
- **[📖 Subscription Organization](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)** - Subscription design

## Data Storage Architecture

### Storage Accounts

**Storage Account Types:**
- **Standard General-purpose v2** - Blobs, files, queues, tables
- **Premium Block Blobs** - High transaction rates, low latency
- **Premium File Shares** - Enterprise file shares
- **Premium Page Blobs** - Managed/unmanaged disks
- **[📖 Storage Account Overview](https://learn.microsoft.com/azure/storage/common/storage-account-overview)** - Account types
- **[📖 Storage Account Performance](https://learn.microsoft.com/azure/storage/common/storage-account-overview#performance-tiers)** - Standard vs Premium
- **[📖 Storage Replication](https://learn.microsoft.com/azure/storage/common/storage-redundancy)** - Redundancy options

**Redundancy Options:**
- **LRS (Locally Redundant)** - 3 copies in single datacenter, 99.999999999% (11 9's)
- **ZRS (Zone Redundant)** - 3 copies across AZs, 99.9999999999% (12 9's)
- **GRS (Geo-Redundant)** - LRS + async copy to secondary region
- **GZRS (Geo-Zone Redundant)** - ZRS + async copy to secondary region
- **RA-GRS / RA-GZRS** - Read access to secondary region
- **[📖 Azure Storage Redundancy](https://learn.microsoft.com/azure/storage/common/storage-redundancy)** - Complete comparison

**Blob Storage:**
- **Access Tiers:**
  - **Hot** - Frequently accessed, highest storage cost, lowest access cost
  - **Cool** - Infrequently accessed, 30-day minimum, lower storage cost
  - **Cold** - Rarely accessed, 90-day minimum, even lower storage cost
  - **Archive** - Offline, 180-day minimum, lowest storage cost, hours to rehydrate
- **[📖 Blob Storage Overview](https://learn.microsoft.com/azure/storage/blobs/storage-blobs-overview)** - Architecture
- **[📖 Blob Access Tiers](https://learn.microsoft.com/azure/storage/blobs/access-tiers-overview)** - Tier comparison
- **[📖 Blob Lifecycle Management](https://learn.microsoft.com/azure/storage/blobs/lifecycle-management-overview)** - Automated tiering
- **[📖 Blob Versioning](https://learn.microsoft.com/azure/storage/blobs/versioning-overview)** - Version control
- **[📖 Blob Soft Delete](https://learn.microsoft.com/azure/storage/blobs/soft-delete-blob-overview)** - Data protection
- **[📖 Blob Immutable Storage](https://learn.microsoft.com/azure/storage/blobs/immutable-storage-overview)** - Compliance storage

**Azure Files:**
- SMB and NFS file shares
- Lift-and-shift scenarios
- Azure File Sync for hybrid scenarios
- **[📖 Azure Files Overview](https://learn.microsoft.com/azure/storage/files/storage-files-introduction)** - Managed file shares
- **[📖 Azure File Sync](https://learn.microsoft.com/azure/storage/file-sync/file-sync-introduction)** - Hybrid file sync
- **[📖 Azure Files Networking](https://learn.microsoft.com/azure/storage/files/storage-files-networking-overview)** - Private endpoints

**Data Lake Storage Gen2:**
- Hierarchical namespace for big data analytics
- Compatible with Hadoop and Spark
- POSIX permissions
- **[📖 Data Lake Storage Gen2](https://learn.microsoft.com/azure/storage/blobs/data-lake-storage-introduction)** - Big data storage
- **[📖 Data Lake Access Control](https://learn.microsoft.com/azure/storage/blobs/data-lake-storage-access-control)** - POSIX ACLs

### Azure Databases

**Azure SQL Database:**
- Fully managed PaaS database
- Purchasing models: vCore (predictable) vs DTU (simplified)
- Service tiers: General Purpose, Business Critical, Hyperscale
- **[📖 Azure SQL Database Overview](https://learn.microsoft.com/azure/azure-sql/database/sql-database-paas-overview)** - PaaS database
- **[📖 SQL Database Purchasing Models](https://learn.microsoft.com/azure/azure-sql/database/purchasing-models)** - vCore vs DTU
- **[📖 SQL Database Service Tiers](https://learn.microsoft.com/azure/azure-sql/database/service-tiers-general-purpose-business-critical)** - Tier comparison
- **[📖 Hyperscale Service Tier](https://learn.microsoft.com/azure/azure-sql/database/service-tier-hyperscale)** - 100TB+ databases
- **[📖 Elastic Pools](https://learn.microsoft.com/azure/azure-sql/database/elastic-pool-overview)** - Shared resources

**High Availability for Azure SQL:**
- **[📖 SQL Database High Availability](https://learn.microsoft.com/azure/azure-sql/database/high-availability-sla)** - Built-in HA
- **[📖 Active Geo-Replication](https://learn.microsoft.com/azure/azure-sql/database/active-geo-replication-overview)** - Multi-region read replicas
- **[📖 Auto-Failover Groups](https://learn.microsoft.com/azure/azure-sql/database/auto-failover-group-overview)** - Automatic failover
- **[📖 SQL Database Backup](https://learn.microsoft.com/azure/azure-sql/database/automated-backups-overview)** - Automated backups

**Azure SQL Managed Instance:**
- Near 100% compatibility with SQL Server
- VNet integration, private IP addresses
- Instance-level features (SQL Agent, CLR, etc.)
- **[📖 SQL Managed Instance Overview](https://learn.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)** - Instance features
- **[📖 SQL MI Connectivity](https://learn.microsoft.com/azure/azure-sql/managed-instance/connectivity-architecture-overview)** - Network architecture

**Azure Cosmos DB:**
- Globally distributed, multi-model database
- Multiple consistency levels
- Automatic and manual failover
- APIs: Core (SQL), MongoDB, Cassandra, Gremlin, Table
- **[📖 Azure Cosmos DB Overview](https://learn.microsoft.com/azure/cosmos-db/introduction)** - Multi-model database
- **[📖 Cosmos DB Consistency Levels](https://learn.microsoft.com/azure/cosmos-db/consistency-levels)** - Consistency trade-offs
- **[📖 Cosmos DB Global Distribution](https://learn.microsoft.com/azure/cosmos-db/distribute-data-globally)** - Multi-region replication
- **[📖 Cosmos DB Partitioning](https://learn.microsoft.com/azure/cosmos-db/partitioning-overview)** - Partition key design
- **[📖 Cosmos DB Request Units](https://learn.microsoft.com/azure/cosmos-db/request-units)** - Throughput management
- **[📖 Cosmos DB Pricing](https://learn.microsoft.com/azure/cosmos-db/understand-your-bill)** - Cost optimization

**Azure Database Services:**
- **Azure Database for PostgreSQL** - Managed PostgreSQL
- **[📖 Azure Database for PostgreSQL](https://learn.microsoft.com/azure/postgresql/overview)** - PostgreSQL on Azure
- **Azure Database for MySQL** - Managed MySQL
- **[📖 Azure Database for MySQL](https://learn.microsoft.com/azure/mysql/overview)** - MySQL on Azure
- **Azure Database for MariaDB** - Managed MariaDB
- **[📖 Azure Database for MariaDB](https://learn.microsoft.com/azure/mariadb/overview)** - MariaDB on Azure

**Azure Cache for Redis:**
- In-memory data store
- Enterprise, Premium, Basic, Standard tiers
- Clustering and geo-replication
- **[📖 Azure Cache for Redis](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-overview)** - Managed Redis
- **[📖 Redis Cache Tiers](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-overview#service-tiers)** - Tier comparison
- **[📖 Redis Clustering](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-how-to-premium-clustering)** - Scale-out architecture

### Data Integration and Analytics

**Azure Synapse Analytics:**
- Unified analytics platform
- Dedicated SQL pools (data warehouse)
- Serverless SQL pools (query on data lake)
- Spark pools for big data processing
- **[📖 Azure Synapse Analytics](https://learn.microsoft.com/azure/synapse-analytics/overview-what-is)** - Unified analytics
- **[📖 Synapse SQL Architecture](https://learn.microsoft.com/azure/synapse-analytics/sql/overview-architecture)** - SQL architecture
- **[📖 Synapse Spark Pools](https://learn.microsoft.com/azure/synapse-analytics/spark/apache-spark-overview)** - Spark processing

**Azure Data Factory:**
- ETL/ELT orchestration
- Data integration pipelines
- SSIS integration runtime
- **[📖 Azure Data Factory](https://learn.microsoft.com/azure/data-factory/introduction)** - Data integration
- **[📖 Data Factory Pipelines](https://learn.microsoft.com/azure/data-factory/concepts-pipelines-activities)** - Pipeline architecture
- **[📖 Data Factory Mapping Data Flows](https://learn.microsoft.com/azure/data-factory/concepts-data-flow-overview)** - Visual ETL

**Azure Databricks:**
- Apache Spark-based analytics platform
- Interactive notebooks
- MLflow integration
- **[📖 Azure Databricks](https://learn.microsoft.com/azure/databricks/introduction/)** - Spark platform

## Business Continuity Solutions

### Backup Solutions

**Azure Backup:**
- Centralized backup service
- Supports VMs, SQL, SAP HANA, Azure Files
- Retention: 9999 days max
- **[📖 Azure Backup Overview](https://learn.microsoft.com/azure/backup/backup-overview)** - Backup service
- **[📖 Azure VM Backup](https://learn.microsoft.com/azure/backup/backup-azure-vms-introduction)** - VM backup architecture
- **[📖 Backup Policies](https://learn.microsoft.com/azure/backup/backup-architecture)** - Retention and scheduling
- **[📖 Recovery Services Vault](https://learn.microsoft.com/azure/backup/backup-azure-recovery-services-vault-overview)** - Vault management

**Application-Specific Backup:**
- **[📖 SQL Database Backup](https://learn.microsoft.com/azure/azure-sql/database/automated-backups-overview)** - Automated SQL backups
- **[📖 SQL Server on VM Backup](https://learn.microsoft.com/azure/backup/backup-azure-sql-database)** - SQL Server backup
- **[📖 SAP HANA Backup](https://learn.microsoft.com/azure/backup/sap-hana-db-about)** - SAP HANA on Azure

### Disaster Recovery

**Azure Site Recovery (ASR):**
- Disaster recovery as a service
- VM replication to Azure or secondary region
- On-premises to Azure replication
- Failover and failback orchestration
- **[📖 Azure Site Recovery](https://learn.microsoft.com/azure/site-recovery/site-recovery-overview)** - DR service
- **[📖 ASR Architecture](https://learn.microsoft.com/azure/site-recovery/azure-to-azure-architecture)** - Replication architecture
- **[📖 ASR Networking](https://learn.microsoft.com/azure/site-recovery/azure-to-azure-about-networking)** - Network design for DR
- **[📖 ASR Recovery Plans](https://learn.microsoft.com/azure/site-recovery/recovery-plan-overview)** - Orchestrated failover

**Disaster Recovery Strategies:**
- **Backup and Restore** - Lowest cost, highest RTO/RPO
- **Pilot Light** - Minimal resources, scale on failover
- **Warm Standby** - Scaled-down environment always running
- **Active-Active** - Multi-region active workloads

### High Availability Architecture

**Availability Zones:**
- Physically separate datacenters within region
- Zone-redundant services (automatic)
- Zonal services (manual placement)
- 99.99% SLA with zone redundancy
- **[📖 Availability Zones](https://learn.microsoft.com/azure/reliability/availability-zones-overview)** - Zone architecture
- **[📖 Zone-Redundant Services](https://learn.microsoft.com/azure/reliability/availability-zones-service-support)** - Service support

**Availability Sets:**
- Fault domains (rack-level separation)
- Update domains (maintenance isolation)
- 99.95% SLA for 2+ VMs
- Legacy option (use Availability Zones when possible)
- **[📖 Availability Sets](https://learn.microsoft.com/azure/virtual-machines/availability-set-overview)** - VM availability

**Load Balancing:**
- **Azure Load Balancer** - Layer 4, regional
- **Application Gateway** - Layer 7, regional, WAF
- **Azure Front Door** - Global Layer 7, WAF, CDN
- **Traffic Manager** - DNS-based global routing
- **[📖 Load Balancing Decision Tree](https://learn.microsoft.com/azure/architecture/guide/technology-choices/load-balancing-overview)** - Choose load balancer

## Infrastructure Solutions

### Compute Services

**Azure Virtual Machines:**
- IaaS compute offering
- VM sizes: General purpose, Compute optimized, Memory optimized, Storage optimized, GPU
- Spot VMs for up to 90% savings
- **[📖 Azure Virtual Machines](https://learn.microsoft.com/azure/virtual-machines/overview)** - VM overview
- **[📖 VM Sizes](https://learn.microsoft.com/azure/virtual-machines/sizes)** - Complete size list
- **[📖 Spot VMs](https://learn.microsoft.com/azure/virtual-machines/spot-vms)** - Interruptible compute
- **[📖 Reserved Instances](https://learn.microsoft.com/azure/cost-management-billing/reservations/save-compute-costs-reservations)** - 1 or 3 year commitment

**VM Scale Sets:**
- Autoscaling VM groups
- Up to 1,000 VMs (custom images) or 600 (marketplace)
- Automatic instance management
- **[📖 Virtual Machine Scale Sets](https://learn.microsoft.com/azure/virtual-machine-scale-sets/overview)** - Autoscaling VMs
- **[📖 Scale Set Autoscaling](https://learn.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview)** - Scaling rules

**Azure App Service:**
- PaaS for web applications
- App Service Plans (pricing tiers)
- Auto-scaling, deployment slots
- **[📖 App Service Overview](https://learn.microsoft.com/azure/app-service/overview)** - PaaS hosting
- **[📖 App Service Plans](https://learn.microsoft.com/azure/app-service/overview-hosting-plans)** - Pricing tiers
- **[📖 Deployment Slots](https://learn.microsoft.com/azure/app-service/deploy-staging-slots)** - Blue-green deployment
- **[📖 App Service Networking](https://learn.microsoft.com/azure/app-service/networking-features)** - Network integration

### Containers and Orchestration

**Azure Container Instances (ACI):**
- Serverless containers
- Per-second billing
- Fast startup time
- **[📖 Azure Container Instances](https://learn.microsoft.com/azure/container-instances/container-instances-overview)** - Serverless containers
- **[📖 ACI Container Groups](https://learn.microsoft.com/azure/container-instances/container-instances-container-groups)** - Multi-container groups

**Azure Kubernetes Service (AKS):**
- Managed Kubernetes
- Free control plane
- Integration with Azure services
- **[📖 Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/intro-kubernetes)** - Managed Kubernetes
- **[📖 AKS Architecture](https://learn.microsoft.com/azure/aks/concepts-clusters-workloads)** - Cluster architecture
- **[📖 AKS Network Concepts](https://learn.microsoft.com/azure/aks/concepts-network)** - Network models
- **[📖 AKS Storage](https://learn.microsoft.com/azure/aks/concepts-storage)** - Persistent volumes
- **[📖 AKS Scaling](https://learn.microsoft.com/azure/aks/concepts-scale)** - Cluster and pod autoscaling
- **[📖 AKS Security](https://learn.microsoft.com/azure/aks/concepts-security)** - Security best practices

**Azure Container Registry (ACR):**
- Private Docker registry
- Geo-replication for global distribution
- Security scanning
- **[📖 Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-intro)** - Container images
- **[📖 ACR Geo-Replication](https://learn.microsoft.com/azure/container-registry/container-registry-geo-replication)** - Multi-region registry

**Azure Container Apps:**
- Serverless Kubernetes-based platform
- Automatic scaling to zero
- Managed ingress and certificates
- **[📖 Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview)** - Serverless containers

### Serverless Computing

**Azure Functions:**
- Event-driven serverless compute
- Consumption, Premium, Dedicated plans
- Durable Functions for stateful workflows
- **[📖 Azure Functions](https://learn.microsoft.com/azure/azure-functions/functions-overview)** - Serverless functions
- **[📖 Functions Hosting Plans](https://learn.microsoft.com/azure/azure-functions/functions-scale)** - Plan comparison
- **[📖 Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview)** - Stateful workflows

**Azure Logic Apps:**
- Workflow automation and integration
- Designer-based workflow creation
- 400+ connectors
- **[📖 Azure Logic Apps](https://learn.microsoft.com/azure/logic-apps/logic-apps-overview)** - Workflow automation
- **[📖 Logic Apps Connectors](https://learn.microsoft.com/connectors/connector-reference/)** - Integration connectors

### Network Architecture

**Virtual Networks (VNet):**
- Address space: RFC 1918 private addresses
- Subnets with network security groups
- Service endpoints and private endpoints
- **[📖 Virtual Networks Overview](https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview)** - VNet architecture
- **[📖 VNet Planning](https://learn.microsoft.com/azure/virtual-network/virtual-network-vnet-plan-design-arm)** - Design guidance
- **[📖 Subnet Delegation](https://learn.microsoft.com/azure/virtual-network/subnet-delegation-overview)** - Service integration

**Network Security Groups (NSG):**
- Layer 4 firewall (port and protocol)
- Inbound and outbound rules
- Can be applied to subnet or NIC
- **[📖 Network Security Groups](https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview)** - Traffic filtering
- **[📖 NSG Rules](https://learn.microsoft.com/azure/virtual-network/network-security-group-how-it-works)** - Rule evaluation

**Azure Firewall:**
- Managed stateful firewall
- Layer 7 filtering with FQDN tags
- Threat intelligence
- Standard, Premium tiers
- **[📖 Azure Firewall](https://learn.microsoft.com/azure/firewall/overview)** - Managed firewall
- **[📖 Firewall Architecture](https://learn.microsoft.com/azure/firewall/firewall-faq)** - Common patterns

**Application Gateway:**
- Layer 7 load balancer
- Web Application Firewall (WAF)
- SSL termination, URL-based routing
- **[📖 Application Gateway](https://learn.microsoft.com/azure/application-gateway/overview)** - Layer 7 load balancer
- **[📖 Application Gateway Components](https://learn.microsoft.com/azure/application-gateway/application-gateway-components)** - Architecture
- **[📖 Web Application Firewall](https://learn.microsoft.com/azure/web-application-firewall/ag/ag-overview)** - WAF features

**Azure Front Door:**
- Global HTTP load balancer
- CDN, WAF, DDoS protection
- Anycast protocol
- **[📖 Azure Front Door](https://learn.microsoft.com/azure/frontdoor/front-door-overview)** - Global delivery
- **[📖 Front Door Routing](https://learn.microsoft.com/azure/frontdoor/front-door-routing-architecture)** - Global routing

**Traffic Manager:**
- DNS-based global traffic routing
- Routing methods: Priority, Weighted, Performance, Geographic, MultiValue, Subnet
- Health monitoring and automatic failover
- **[📖 Traffic Manager](https://learn.microsoft.com/azure/traffic-manager/traffic-manager-overview)** - DNS load balancing
- **[📖 Routing Methods](https://learn.microsoft.com/azure/traffic-manager/traffic-manager-routing-methods)** - Traffic distribution

**Virtual Network Peering:**
- Connect VNets in same or different regions
- Low latency, high bandwidth
- No gateway required
- **[📖 VNet Peering](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview)** - VNet connectivity
- **[📖 Hub-Spoke Topology](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)** - Network design pattern

**VPN Gateway:**
- Site-to-Site, Point-to-Site, VNet-to-VNet
- Active-active for high availability
- BGP support
- **[📖 VPN Gateway](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)** - VPN connectivity
- **[📖 VPN Gateway SKUs](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku)** - Performance tiers
- **[📖 Highly Available VPN](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-highlyavailable)** - HA design

**ExpressRoute:**
- Private connection to Azure
- 50 Mbps to 100 Gbps
- Standard (single region) vs Premium (global)
- **[📖 ExpressRoute Overview](https://learn.microsoft.com/azure/expressroute/expressroute-introduction)** - Private connectivity
- **[📖 ExpressRoute Connectivity Models](https://learn.microsoft.com/azure/expressroute/expressroute-connectivity-models)** - Connection types
- **[📖 ExpressRoute SKUs](https://learn.microsoft.com/azure/expressroute/expressroute-about-virtual-network-gateways)** - Gateway SKUs

**Azure Virtual WAN:**
- Unified hub-and-spoke architecture
- Automated branch connectivity
- Global transit network
- **[📖 Azure Virtual WAN](https://learn.microsoft.com/azure/virtual-wan/virtual-wan-about)** - Global networking
- **[📖 Virtual WAN Architecture](https://learn.microsoft.com/azure/virtual-wan/virtual-wan-global-transit-network-architecture)** - Hub-spoke design

**Private Endpoint and Private Link:**
- Private IP access to PaaS services
- Traffic stays on Microsoft network
- No data exfiltration risk
- **[📖 Azure Private Link](https://learn.microsoft.com/azure/private-link/private-link-overview)** - Private connectivity
- **[📖 Private Endpoints](https://learn.microsoft.com/azure/private-link/private-endpoint-overview)** - PaaS private access

**Azure DNS:**
- DNS hosting service
- Private DNS zones for internal name resolution
- **[📖 Azure DNS](https://learn.microsoft.com/azure/dns/dns-overview)** - Managed DNS
- **[📖 Private DNS Zones](https://learn.microsoft.com/azure/dns/private-dns-overview)** - Internal DNS

### Hybrid and Migration Solutions

**Azure Arc:**
- Extend Azure management to any infrastructure
- Arc-enabled servers, Kubernetes, data services
- Unified governance and compliance
- **[📖 Azure Arc](https://learn.microsoft.com/azure/azure-arc/overview)** - Hybrid management
- **[📖 Arc-enabled Servers](https://learn.microsoft.com/azure/azure-arc/servers/overview)** - Server management
- **[📖 Arc-enabled Kubernetes](https://learn.microsoft.com/azure/azure-arc/kubernetes/overview)** - K8s anywhere

**Azure Migrate:**
- Centralized migration hub
- Discovery, assessment, and migration
- Support for VMs, databases, web apps
- **[📖 Azure Migrate](https://learn.microsoft.com/azure/migrate/migrate-services-overview)** - Migration service
- **[📖 Azure Migrate Appliance](https://learn.microsoft.com/azure/migrate/migrate-appliance)** - Discovery tool

**Azure Database Migration Service:**
- Online and offline database migrations
- SQL Server, MySQL, PostgreSQL sources
- **[📖 Database Migration Service](https://learn.microsoft.com/azure/dms/dms-overview)** - Database migration

## Application Architecture

### Messaging Services

**Azure Service Bus:**
- Enterprise messaging
- Queues (point-to-point) and Topics (pub-sub)
- Sessions, transactions, dead-letter queues
- **[📖 Azure Service Bus](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview)** - Enterprise messaging
- **[📖 Service Bus Queues](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-queues-topics-subscriptions)** - Queues and topics

**Azure Event Hubs:**
- Big data streaming platform
- Millions of events per second
- Capture to storage or Data Lake
- **[📖 Azure Event Hubs](https://learn.microsoft.com/azure/event-hubs/event-hubs-about)** - Event streaming
- **[📖 Event Hubs Capture](https://learn.microsoft.com/azure/event-hubs/event-hubs-capture-overview)** - Stream capture

**Azure Event Grid:**
- Serverless event routing
- Publish-subscribe model
- Event filtering and routing
- **[📖 Azure Event Grid](https://learn.microsoft.com/azure/event-grid/overview)** - Event routing
- **[📖 Event Grid Concepts](https://learn.microsoft.com/azure/event-grid/concepts)** - Architecture

**Azure Queue Storage:**
- Simple queue service
- Part of storage account
- HTTP/HTTPS access
- **[📖 Azure Queue Storage](https://learn.microsoft.com/azure/storage/queues/storage-queues-introduction)** - Simple queues

### API Management

**Azure API Management:**
- API gateway and developer portal
- Rate limiting, caching, transformation
- OAuth, JWT validation
- **[📖 API Management](https://learn.microsoft.com/azure/api-management/api-management-key-concepts)** - API gateway
- **[📖 API Management Policies](https://learn.microsoft.com/azure/api-management/api-management-howto-policies)** - Request/response policies
- **[📖 APIM Networking](https://learn.microsoft.com/azure/api-management/virtual-network-concepts)** - Network integration

## Monitoring and Management

### Azure Monitor

**Monitoring Platform:**
- Metrics and logs
- Application Insights for APM
- Log Analytics workspace
- Alerts and action groups
- **[📖 Azure Monitor Overview](https://learn.microsoft.com/azure/azure-monitor/overview)** - Monitoring platform
- **[📖 Azure Monitor Metrics](https://learn.microsoft.com/azure/azure-monitor/essentials/data-platform-metrics)** - Time-series data
- **[📖 Azure Monitor Logs](https://learn.microsoft.com/azure/azure-monitor/logs/data-platform-logs)** - Log data
- **[📖 Log Analytics Workspace](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview)** - Log storage

**Application Insights:**
- Application performance monitoring (APM)
- Distributed tracing
- Live metrics and profiling
- **[📖 Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)** - APM service
- **[📖 Application Map](https://learn.microsoft.com/azure/azure-monitor/app/app-map)** - Dependency visualization

**Alerts and Actions:**
- Metric, log, and activity log alerts
- Action groups (email, SMS, webhook, runbook)
- Smart groups for alert aggregation
- **[📖 Azure Monitor Alerts](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-overview)** - Alert types
- **[📖 Action Groups](https://learn.microsoft.com/azure/azure-monitor/alerts/action-groups)** - Alert actions

### Azure Advisor

**Optimization Recommendations:**
- Cost, security, reliability, operational excellence, performance
- AI-powered recommendations
- Free service
- **[📖 Azure Advisor](https://learn.microsoft.com/azure/advisor/advisor-overview)** - Recommendations

### Security Monitoring

**Microsoft Defender for Cloud:**
- Cloud security posture management (CSPM)
- Cloud workload protection platform (CWPP)
- Secure score and recommendations
- **[📖 Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-cloud-introduction)** - Security center
- **[📖 Secure Score](https://learn.microsoft.com/azure/defender-for-cloud/secure-score-security-controls)** - Security posture

**Azure Sentinel:**
- Cloud-native SIEM
- Security analytics and threat intelligence
- Playbooks for automation
- **[📖 Azure Sentinel](https://learn.microsoft.com/azure/sentinel/overview)** - SIEM solution

## Cost Optimization

### Cost Management and Billing

**Cost Analysis:**
- Cost breakdown by resource, service, location
- Budgets and alerts
- Cost allocation with tags
- **[📖 Cost Management](https://learn.microsoft.com/azure/cost-management-billing/cost-management-billing-overview)** - Cost visibility
- **[📖 Cost Analysis](https://learn.microsoft.com/azure/cost-management-billing/costs/quick-acm-cost-analysis)** - Analyze spending
- **[📖 Budgets](https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-acm-create-budgets)** - Budget alerts

**Pricing Models:**
- Pay-as-you-go
- Reserved Instances (1 or 3 year, up to 72% savings)
- Spot VMs (up to 90% savings)
- Azure Hybrid Benefit (use existing licenses)
- **[📖 Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)** - Estimate costs
- **[📖 Azure Hybrid Benefit](https://learn.microsoft.com/azure/cost-management-billing/manage/azure-hybrid-benefit-windows-server)** - License portability

**Cost Optimization Strategies:**
- Right-sizing VMs
- Scaling and auto-scaling
- Storage lifecycle management
- Dev/test pricing
- Reserved capacity for databases

## Common Architecture Patterns

### Pattern 1: N-Tier Web Application

**Architecture:**
- **Web Tier:** Azure Front Door + App Service or VM Scale Set
- **Application Tier:** App Service or AKS
- **Data Tier:** Azure SQL Database with geo-replication
- **Caching:** Azure Cache for Redis
- **Storage:** Azure Storage for static content

**Key Services:**
- Azure Front Door for global load balancing
- Azure CDN for static assets
- Application Gateway with WAF
- Azure SQL Database with failover groups
- Azure Monitor for observability

### Pattern 2: Microservices on AKS

**Architecture:**
- AKS cluster with multiple node pools
- Azure Container Registry for images
- Service mesh (Istio/Linkerd) for traffic management
- Azure Monitor and Application Insights for observability
- Key Vault for secrets

**Key Services:**
- AKS with Azure CNI networking
- Azure Load Balancer or Application Gateway
- Azure Database for PostgreSQL
- Event Hubs for event streaming
- Azure DevOps or GitHub Actions for CI/CD

### Pattern 3: Event-Driven Serverless

**Architecture:**
- Event Grid for event routing
- Azure Functions for compute
- Service Bus or Event Hubs for messaging
- Cosmos DB for state
- Logic Apps for workflows

**Key Services:**
- Event Grid subscriptions
- Functions with Consumption plan
- Cosmos DB with geo-replication
- API Management for API gateway

### Pattern 4: Big Data Analytics

**Architecture:**
- Event Hubs or IoT Hub for ingestion
- Azure Synapse Analytics for warehousing
- Data Lake Storage Gen2 for raw data
- Azure Databricks for processing
- Power BI for visualization

**Key Services:**
- Synapse Analytics workspace
- Data Factory for orchestration
- Azure Purview for data governance

### Pattern 5: Hybrid Cloud with Azure Arc

**Architecture:**
- Azure Arc-enabled servers for on-premises
- VPN Gateway or ExpressRoute for connectivity
- Azure Policy for governance
- Azure Monitor for unified monitoring
- Site Recovery for disaster recovery

**Key Services:**
- Azure Arc
- Azure Policy
- ExpressRoute with redundancy
- Azure Backup and Site Recovery

## Security and Compliance

### Data Protection

**Encryption:**
- Encryption at rest (Azure Storage Service Encryption)
- Encryption in transit (TLS 1.2+)
- Azure Key Vault for key management
- Customer-managed keys (CMK)
- **[📖 Azure Encryption Overview](https://learn.microsoft.com/azure/security/fundamentals/encryption-overview)** - Data protection
- **[📖 Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview)** - Key management
- **[📖 Key Vault Best Practices](https://learn.microsoft.com/azure/key-vault/general/best-practices)** - Security guidelines

**Azure Information Protection:**
- Classify and label sensitive data
- Encrypt and protect documents
- **[📖 Azure Information Protection](https://learn.microsoft.com/azure/information-protection/what-is-information-protection)** - Data classification

### Network Security

**Defense in Depth:**
- Network Security Groups (NSG)
- Azure Firewall or Network Virtual Appliances
- DDoS Protection Standard
- Application Gateway with WAF
- **[📖 Azure DDoS Protection](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview)** - DDoS mitigation
- **[📖 Network Security Best Practices](https://learn.microsoft.com/azure/security/fundamentals/network-best-practices)** - Network security

### Compliance

**Compliance Offerings:**
- ISO 27001, SOC 1/2/3, HIPAA, GDPR, FedRAMP
- Azure Compliance Manager
- Regional compliance (data residency)
- **[📖 Azure Compliance](https://learn.microsoft.com/azure/compliance/)** - Compliance offerings
- **[📖 Microsoft Compliance Manager](https://learn.microsoft.com/microsoft-365/compliance/compliance-manager)** - Compliance assessment

## Migration Strategies

### Assessment and Planning

**Azure Migrate Hub:**
- Discovery and assessment
- Dependency mapping
- Right-sizing recommendations
- **[📖 Azure Migrate Assessment](https://learn.microsoft.com/azure/migrate/concepts-assessment-calculation)** - Assessment methodology

### Migration Approaches (5 Rs)

**Migration Strategies:**
1. **Rehost** - Lift-and-shift to VMs
2. **Refactor** - Containerize or use PaaS
3. **Rearchitect** - Cloud-native redesign
4. **Rebuild** - Rebuild from scratch
5. **Replace** - SaaS solutions

**Migration Tools:**
- Azure Migrate for VMs
- Database Migration Service for databases
- Azure Data Box for large data transfers
- Azure Import/Export service

## Exam Scenarios and Decision Trees

### Scenario 1: Identity Solution Selection

**Decision Tree:**
```
Need directory services?
├─ Cloud-only → Azure AD (Entra ID)
├─ Hybrid (AD + Azure AD) → Azure AD Connect
└─ Lift-and-shift domain controllers → Azure AD Domain Services
```

### Scenario 2: Database Selection

**Decision Tree:**
```
Relational needed?
├─ YES → SQL Server compatibility?
│  ├─ 100% compatibility → SQL Managed Instance
│  ├─ Modern cloud features → Azure SQL Database
│  └─ Other RDBMS → Azure Database for PostgreSQL/MySQL
└─ NO → Data model?
   ├─ Multi-model, global distribution → Cosmos DB
   ├─ Cache → Azure Cache for Redis
   └─ Analytics → Synapse Analytics
```

### Scenario 3: Compute Selection

**Decision Tree:**
```
Container-based?
├─ YES → Orchestration needed?
│  ├─ YES (Kubernetes) → AKS
│  ├─ NO (simple) → Container Instances
│  └─ Serverless → Container Apps
└─ NO → Code-based?
   ├─ YES → Event-driven?
   │  ├─ YES → Azure Functions
   │  └─ NO → App Service
   └─ NO → Virtual Machines
```

### Scenario 4: Load Balancing Selection

**Decision Tree:**
```
Layer 7 or Layer 4?
├─ Layer 7 (HTTP/HTTPS) → Scope?
│  ├─ Global → Azure Front Door
│  ├─ Regional with WAF → Application Gateway
│  └─ DNS-based → Traffic Manager
└─ Layer 4 (TCP/UDP) → Azure Load Balancer
```

## Key Numbers to Memorize

**Service Limits:**
- Azure Functions: 10 min default (30 min max on Premium), 1.5 GB memory default
- Storage Account: 5 PB max capacity, 20,000 IOPS (standard), 500 TB per blob
- VNet: 65,536 IPs per VNet, 500 VNets per subscription (default)
- Azure SQL Database: 4 TB (General Purpose), 100 TB (Hyperscale)
- VM Scale Sets: 1,000 VMs (custom images), 600 (marketplace)

**SLA Numbers:**
- Single VM with Premium SSD: 99.9%
- Availability Set: 99.95%
- Availability Zones: 99.99%
- Multi-region with Traffic Manager: 99.99%+

**Retention Periods:**
- Azure Backup: 9999 days maximum
- SQL Database automated backups: 7-35 days (default 7)
- Activity Log: 90 days
- Log Analytics: 30 days to 730 days

## Exam Tips and Strategy

### Question Analysis Keywords

**Watch for these keywords:**
- **"Most cost-effective"** → Spot VMs, Reserved Instances, storage tiers, auto-scaling
- **"Least administrative effort"** → PaaS over IaaS, managed services, serverless
- **"High availability"** → Availability Zones, geo-replication, load balancing
- **"Disaster recovery"** → Site Recovery, geo-redundant storage, backup
- **"Security"** → Private endpoints, NSGs, Azure Firewall, encryption
- **"Hybrid"** → ExpressRoute, VPN Gateway, Azure Arc, AD Connect
- **"Real-time"** → Event Hubs, Stream Analytics, Azure Functions
- **"Compliance"** → Azure Policy, Blueprints, encryption, audit logs

### Time Management

- 120 minutes ÷ 50 questions = 2.4 minutes per question
- Case studies: 10-15 minutes per case (3-5 questions each)
- Multiple choice: 1-2 minutes each
- First pass: Answer confident questions (60 minutes)
- Second pass: Review flagged questions (50 minutes)
- Final pass: Review all answers (10 minutes)

### Common Traps

- ❌ Choosing IaaS when PaaS is appropriate
- ❌ Over-engineering solutions
- ❌ Ignoring cost constraints
- ❌ Missing "hybrid" requirements
- ❌ Confusing service capabilities (tiers, limits)
- ❌ Not considering operational overhead
- ❌ Forgetting about compliance requirements

### Study Checklist

**Technical Knowledge:**
- [ ] Understand Azure AD vs Azure AD DS vs AD Connect
- [ ] Know all load balancing options and when to use each
- [ ] Can design multi-region architectures
- [ ] Understand VNet peering, VPN, ExpressRoute trade-offs
- [ ] Know database options and selection criteria
- [ ] Understand Azure Policy, RBAC, Management Groups
- [ ] Can design backup and disaster recovery solutions
- [ ] Familiar with all compute options (VMs, App Service, AKS, Functions)
- [ ] Know storage types and redundancy options
- [ ] Understand monitoring and logging architecture

**Preparation:**
- [ ] Hands-on experience with Azure (build projects)
- [ ] Read Azure Well-Architected Framework
- [ ] Review Azure Architecture Center patterns
- [ ] Complete practice exams (80%+ score)
- [ ] Understand cost optimization strategies
- [ ] Practice designing solutions on paper/whiteboard

---

**Pro Tip:** AZ-305 tests your ability to design complete solutions balancing cost, security, performance, and operational overhead. Always read the entire scenario, identify all constraints, and choose the solution that best meets ALL requirements - not just technically correct, but most appropriate for the business context.

**Documentation Count:** This fact sheet contains 115+ embedded documentation links to official Microsoft Learn and Azure documentation.

**Good luck!** This certification demonstrates expert-level Azure architecture skills and is highly valued in the industry.
