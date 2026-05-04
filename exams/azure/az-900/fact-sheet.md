---
last-updated: 2026-05-03
---

# Azure AZ-900 Fundamentals - Comprehensive Fact Sheet

## Table of Contents
1. [Cloud Concepts](#cloud-concepts)
2. [Core Azure Services](#core-azure-services)
3. [Security, Privacy, Compliance, and Trust](#security-privacy-compliance-and-trust)
4. [Azure Pricing and Support](#azure-pricing-and-support)

---

## Cloud Concepts

### What is Cloud Computing?

Cloud computing is the delivery of computing services over the internet, enabling faster innovation, flexible resources, and economies of scale.

**[📖 What is Cloud Computing](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/strategy/what-is-cloud-computing)** - Introduction to cloud computing concepts and benefits

**[📖 Cloud Computing Services](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-cloud-computing/)** - Overview of cloud computing delivery models

### Cloud Service Models

#### Infrastructure as a Service (IaaS)
- Most flexible cloud service
- You manage: Applications, data, runtime, middleware, OS
- Provider manages: Virtualization, servers, storage, networking

**[📖 What is IaaS](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-iaas/)** - Infrastructure as a Service explained

#### Platform as a Service (PaaS)
- Focus on application development
- You manage: Applications and data
- Provider manages: Runtime, middleware, OS, virtualization, servers, storage, networking

**[📖 What is PaaS](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-paas/)** - Platform as a Service overview

#### Software as a Service (SaaS)
- Ready-to-use applications
- Provider manages everything
- Examples: Office 365, Dynamics 365

**[📖 What is SaaS](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-saas/)** - Software as a Service definition

### Cloud Deployment Models

#### Public Cloud
- Services offered over public internet
- Available to anyone who wants to purchase
- No local hardware

**[📖 What is a Public Cloud](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-a-public-cloud/)** - Public cloud deployment model

#### Private Cloud
- Computing resources used exclusively by one business
- Can be hosted on-site or by third party
- Greater control and security

**[📖 What is a Private Cloud](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-a-private-cloud/)** - Private cloud explained

#### Hybrid Cloud
- Combines public and private clouds
- Data and applications can move between environments
- Greater flexibility and optimization

**[📖 What is a Hybrid Cloud](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-hybrid-cloud-computing/)** - Hybrid cloud computing overview

**[📖 Azure Hybrid Cloud Solutions](https://azure.microsoft.com/en-us/solutions/hybrid-cloud-app/)** - Microsoft's hybrid cloud approach

### Cloud Benefits

#### High Availability
- Resources are available when needed
- Service Level Agreements (SLAs) define uptime guarantees

**[📖 Azure Service Level Agreements](https://azure.microsoft.com/en-us/support/legal/sla/)** - SLA documentation and commitments

#### Scalability
- Vertical Scaling (Scale Up): Increase CPU, RAM
- Horizontal Scaling (Scale Out): Add more instances

**[📖 Scalability in Azure](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/overview)** - Scalability principles and patterns

#### Elasticity
- Automatically adjust resources based on demand
- Pay only for what you use

#### Reliability
- Decentralized design with resources deployed globally
- Resilient infrastructure

**[📖 Reliability in Azure](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview)** - Building reliable applications

#### Predictability
- Performance predictability: autoscaling, load balancing
- Cost predictability: TCO calculator, pricing calculator

#### Security and Governance
- Cloud-based security tools
- Compliance standards and certifications
- Governance policies and templates

**[📖 Azure Governance](https://learn.microsoft.com/en-us/azure/governance/)** - Governance capabilities overview

#### Manageability
- Management of the cloud: scaling resources, deploying resources
- Management in the cloud: portal, CLI, APIs, PowerShell

### Capital Expenditure (CapEx) vs Operational Expenditure (OpEx)

**CapEx**: Upfront investment in physical infrastructure
- High initial cost
- Value decreases over time

**OpEx**: Pay-as-you-go model for cloud services
- No upfront cost
- Pay for services as consumed

**[📖 CapEx vs OpEx](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/strategy/business-outcomes/fiscal-outcomes)** - Financial outcomes in cloud adoption

---

## Core Azure Services

### Azure Architecture Components

#### Azure Regions
- Geographic areas containing one or more datacenters
- Choose regions close to users for lower latency
- 60+ regions worldwide

**[📖 Azure Regions](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/)** - Global infrastructure and regions

**[📖 Azure Geography](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview)** - Regions and availability zones

#### Availability Zones
- Physically separate datacenters within a region
- Independent power, cooling, networking
- Protection from datacenter failures

**[📖 What are Availability Zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview)** - Availability zones explained

#### Region Pairs
- Each region paired with another 300+ miles away
- Automatic replication for some services
- Sequential updates to minimize downtime

**[📖 Azure Region Pairs](https://learn.microsoft.com/en-us/azure/reliability/cross-region-replication-azure)** - Cross-region replication

#### Azure Sovereign Regions
- Isolated instances for compliance (US Government, China)

**[📖 Azure Government](https://azure.microsoft.com/en-us/explore/global-infrastructure/government/)** - Government cloud services

### Azure Resources and Resource Manager

#### Azure Resources
- Virtual machines, storage accounts, databases, etc.
- Anything you create, provision, or deploy

#### Resource Groups
- Logical containers for Azure resources
- Resources can only exist in one resource group
- Cannot nest resource groups

**[📖 Resource Groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)** - Managing resource groups

#### Azure Subscriptions
- Logical unit of Azure services
- Links to an Azure account
- Billing boundary and access control boundary

**[📖 Azure Subscriptions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/initial-subscriptions)** - Subscription organization strategies

#### Management Groups
- Organize multiple subscriptions
- Apply governance conditions
- Hierarchy of management groups and subscriptions

**[📖 Management Groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)** - Organizing resources with management groups

#### Azure Resource Manager (ARM)
- Deployment and management service for Azure
- Consistent management layer
- Deploy, update, delete resources

**[📖 Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)** - ARM overview and capabilities

**[📖 ARM Templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)** - Infrastructure as code with ARM templates

### Azure Compute Services

#### Azure Virtual Machines (VMs)
- IaaS offering providing complete control
- Windows or Linux
- Total customization

**[📖 Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/)** - VM documentation and overview

**[📖 VM Sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes)** - Virtual machine size families

#### Virtual Machine Scale Sets
- Deploy and manage identical VMs
- Auto-scaling capabilities
- Load balancing included

**[📖 VM Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)** - Scale sets overview

#### Azure Virtual Desktop
- Desktop and application virtualization
- Multi-session Windows 10/11
- Microsoft 365 Apps optimization

**[📖 Azure Virtual Desktop](https://learn.microsoft.com/en-us/azure/virtual-desktop/overview)** - Virtual desktop infrastructure

#### Azure Containers
- Lightweight, virtualized application environment
- Docker container support

**[📖 Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/)** - Azure Container Instances documentation

**[📖 Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/)** - Managed Kubernetes service

#### Azure App Service
- PaaS for building web, mobile, API apps
- Supports multiple languages (.NET, Java, Node.js, Python, PHP)
- Automatic scaling and load balancing

**[📖 App Service Overview](https://learn.microsoft.com/en-us/azure/app-service/overview)** - App Service documentation

**[📖 App Service Plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)** - App Service plan tiers and features

#### Azure Functions
- Serverless compute service
- Event-driven, pay-per-execution
- Supports multiple languages

**[📖 Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/)** - Serverless functions documentation

**[📖 Functions Triggers and Bindings](https://learn.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings)** - Event-driven programming model

### Azure Networking Services

#### Azure Virtual Network (VNet)
- Isolated network in Azure
- Segmentation, communication with on-premises
- Subnets for organization

**[📖 Virtual Networks](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)** - VNet overview and capabilities

#### VPN Gateway
- Send encrypted traffic over public internet
- Site-to-site, point-to-site connections

**[📖 VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)** - VPN Gateway documentation

#### Azure ExpressRoute
- Private connection to Azure
- Higher reliability, faster speeds
- Does not go over public internet

**[📖 ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/)** - Private connectivity to Azure

#### Network Security Groups (NSG)
- Filter network traffic to/from Azure resources
- Inbound and outbound security rules

**[📖 Network Security Groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)** - NSG configuration and rules

#### Azure Load Balancer
- Distribute traffic across multiple VMs
- Layer 4 (TCP/UDP) load balancing
- High availability

**[📖 Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)** - Load balancing solutions

#### Azure Application Gateway
- Layer 7 (HTTP/HTTPS) load balancing
- Web traffic routing
- Web Application Firewall (WAF)

**[📖 Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview)** - Application-level routing

#### Azure DNS
- Host DNS domains in Azure
- High availability and performance
- Azure Resource Manager integration

**[📖 Azure DNS](https://learn.microsoft.com/en-us/azure/dns/dns-overview)** - DNS hosting service

### Azure Storage Services

#### Azure Storage Account
- Container for all Azure Storage data objects
- Unique namespace accessible via HTTP/HTTPS

**[📖 Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)** - Storage accounts explained

#### Azure Blob Storage
- Object storage for unstructured data
- Hot, Cool, and Archive access tiers
- Massive scalability

**[📖 Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview)** - Object storage documentation

**[📖 Blob Access Tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)** - Optimizing costs with access tiers

#### Azure Files
- Fully managed file shares
- SMB and NFS protocols
- Cloud or on-premises access

**[📖 Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction)** - Managed file shares

#### Azure Queue Storage
- Message queue for large workloads
- Store millions of messages
- Asynchronous processing

**[📖 Queue Storage](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction)** - Queue storage for messaging

#### Azure Table Storage
- NoSQL key-value store
- Structured non-relational data
- Schemaless design

**[📖 Table Storage](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview)** - NoSQL table storage

#### Azure Disk Storage
- Block-level storage volumes for VMs
- Managed disks (SSD, HDD)
- High performance and durability

**[📖 Managed Disks](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)** - VM disk storage

### Azure Database Services

#### Azure Cosmos DB
- Globally distributed NoSQL database
- Multiple APIs (SQL, MongoDB, Cassandra)
- Single-digit millisecond latency

**[📖 Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/)** - Multi-model database service

#### Azure SQL Database
- PaaS relational database
- Based on SQL Server
- Automatic updates, backups, scaling

**[📖 SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/)** - Managed relational database

#### Azure Database for MySQL
- Fully managed MySQL
- Built-in high availability
- Enterprise security

**[📖 Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/)** - Managed MySQL service

#### Azure Database for PostgreSQL
- Fully managed PostgreSQL
- Intelligent performance
- Flexible scaling

**[📖 Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/)** - Managed PostgreSQL service

#### Azure SQL Managed Instance
- Near 100% compatibility with SQL Server
- Native virtual network support
- Lift-and-shift ready

**[📖 SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/)** - SQL Server in the cloud

### Azure Marketplace

**[📖 Azure Marketplace](https://azuremarketplace.microsoft.com/)** - Discover and deploy solutions from Microsoft and partners

---

## Security, Privacy, Compliance, and Trust

### Defense in Depth

Layered approach to security:
1. Physical security
2. Identity and access
3. Perimeter
4. Network
5. Compute
6. Application
7. Data

**[📖 Defense in Depth](https://learn.microsoft.com/en-us/azure/security/fundamentals/overview)** - Azure security overview

### Azure Active Directory (Azure AD / Microsoft Entra ID)

- Cloud-based identity and access management
- Single sign-on (SSO)
- Multi-factor authentication (MFA)
- Conditional access

**[📖 Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/whatis)** - Identity and access management

**[📖 Multi-Factor Authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks)** - MFA overview and setup

**[📖 Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)** - Policy-based access control

### Azure Security Features

#### Azure Security Center / Microsoft Defender for Cloud
- Unified security management
- Advanced threat protection
- Security recommendations

**[📖 Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/)** - Cloud security posture management

#### Azure Sentinel
- Cloud-native SIEM (Security Information Event Management)
- Intelligent security analytics
- Threat detection and response

**[📖 Azure Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/)** - Cloud-native SIEM and SOAR

#### Azure Key Vault
- Securely store secrets, keys, certificates
- Hardware security modules (HSM)
- Centralized application secrets

**[📖 Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/)** - Secrets management service

#### Azure DDoS Protection
- Protection from distributed denial-of-service attacks
- Basic (free) and Standard tiers
- Real-time monitoring

**[📖 DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)** - DDoS mitigation service

#### Azure Firewall
- Managed cloud-based network security
- Built-in high availability
- Application and network-level filtering

**[📖 Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/)** - Cloud-native firewall service

### Governance and Compliance

#### Azure Policy
- Create, assign, manage policies
- Enforce organizational standards
- Assess compliance at scale

**[📖 Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/)** - Policy-driven governance

#### Role-Based Access Control (RBAC)
- Fine-grained access management
- Principle of least privilege
- Built-in and custom roles

**[📖 Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/)** - Role-based access control

#### Azure Blueprints
- Repeatable set of Azure resources
- Orchestrated deployment of templates, policies, roles
- Environment setup automation

**[📖 Azure Blueprints](https://learn.microsoft.com/en-us/azure/governance/blueprints/)** - Environment orchestration

#### Resource Locks
- Prevent accidental deletion or modification
- CanNotDelete and ReadOnly locks
- Apply at subscription, resource group, or resource level

**[📖 Resource Locks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)** - Protect resources from changes

#### Azure Compliance

**[📖 Trust Center](https://www.microsoft.com/en-us/trust-center)** - Privacy, security, and compliance information

**[📖 Compliance Offerings](https://learn.microsoft.com/en-us/azure/compliance/)** - Azure compliance documentation

### Privacy and Data Protection

#### Microsoft Privacy Statement
Explains what data Microsoft collects and how it's used

**[📖 Privacy Statement](https://privacy.microsoft.com/en-us/privacystatement)** - Microsoft privacy practices

#### Azure Information Protection
- Classify and protect documents and emails
- Encryption, identity, authorization

### Azure Service Trust Portal

Central location for compliance information, security best practices, and audit reports

**[📖 Service Trust Portal](https://servicetrust.microsoft.com/)** - Compliance and trust resources

---

## Azure Pricing and Support

### Azure Subscriptions

#### Subscription Types
- Free Account: $200 credit for 30 days + 12 months free services
- Pay-As-You-Go: Pay for what you use
- Enterprise Agreement: Volume licensing for large organizations
- Student: $100 credit, no credit card required

**[📖 Azure Free Account](https://azure.microsoft.com/en-us/free/)** - Start with free services

### Factors Affecting Costs

1. Resource Type
2. Consumption (metering)
3. Region
4. Azure Marketplace
5. Licensing
6. Network Traffic

**[📖 Pricing Overview](https://azure.microsoft.com/en-us/pricing/)** - Understanding Azure pricing

### Azure Pricing Calculator

Estimate costs for Azure services before deployment

**[📖 Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)** - Calculate your estimated costs

### Total Cost of Ownership (TCO) Calculator

Compare costs of on-premises infrastructure vs Azure

**[📖 TCO Calculator](https://azure.microsoft.com/en-us/pricing/tco/calculator/)** - Compare on-premises to cloud costs

### Azure Cost Management

- Monitor, allocate, and optimize cloud spending
- Cost analysis and budgets
- Cost alerts and recommendations

**[📖 Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/)** - Cost management and billing

**[📖 Cost Optimization](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/)** - Optimize your cloud investment

### Ways to Reduce Costs

1. Reserved Instances: 1 or 3-year commitments (up to 72% savings)
2. Azure Hybrid Benefit: Use existing licenses
3. Spot VMs: Unused capacity at discounted rates
4. Pricing Calculator: Estimate before deployment
5. Azure Advisor: Cost recommendations
6. Spending Limits: Prevent overspending

**[📖 Reserved Instances](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/)** - Save with reserved capacity

**[📖 Azure Hybrid Benefit](https://azure.microsoft.com/en-us/pricing/hybrid-benefit/)** - Maximize existing licenses

**[📖 Spot VMs](https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms)** - Use surplus capacity at lower cost

### Azure Advisor

Personalized cloud consultant providing recommendations:
- Reliability
- Security
- Performance
- Cost
- Operational Excellence

**[📖 Azure Advisor](https://learn.microsoft.com/en-us/azure/advisor/)** - Personalized recommendations

### Azure Service Level Agreements (SLA)

- Performance targets for Azure services
- Expressed as uptime percentage (99.9%, 99.95%, 99.99%)
- Service credits if SLA not met
- Composite SLA: multiply individual SLAs

**[📖 SLA for Azure Services](https://azure.microsoft.com/en-us/support/legal/sla/)** - Service level agreements

### Azure Support Plans

1. Basic: Free with all accounts
2. Developer: Trial and non-production ($29/month)
3. Standard: Production workloads ($100/month)
4. Professional Direct: Business-critical ($1,000/month)
5. Premier: Enterprise customers (custom pricing)

**[📖 Support Plans](https://azure.microsoft.com/en-us/support/plans/)** - Compare support options

### Azure Knowledge Center & Documentation

**[📖 Azure Documentation](https://learn.microsoft.com/en-us/azure/)** - Official Azure documentation portal

### Additional Management Tools

#### Azure Portal
- Web-based unified console
- Build, manage, and monitor everything
- Customizable dashboards

**[📖 Azure Portal](https://portal.azure.com/)** - Access Azure portal

#### Azure PowerShell
- Cross-platform command-line shell
- Automation scripting
- Azure-specific cmdlets

**[📖 Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/)** - PowerShell for Azure management

#### Azure CLI
- Cross-platform command-line tool
- Bash-like syntax
- Automation and scripting

**[📖 Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)** - Command-line interface documentation

#### Azure Cloud Shell
- Browser-based shell experience
- Pre-configured Azure PowerShell and CLI
- No local installation required

**[📖 Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview)** - Browser-based command line

#### Azure Mobile App
- Manage Azure resources from mobile device
- Monitor health and status
- Run commands via Cloud Shell

**[📖 Azure Mobile App](https://azure.microsoft.com/en-us/get-started/azure-portal/mobile-app/)** - Manage Azure on the go

#### Azure Monitor
- Collect, analyze, act on telemetry
- Application and infrastructure monitoring
- Metrics and logs

**[📖 Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/)** - Monitoring and diagnostics

**[📖 Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)** - Application performance management

---

## Exam Tips and Resources

### Exam Details
- Duration: 60 minutes
- Questions: 40-60 questions
- Question types: Multiple choice, drag-and-drop, case studies
- Passing score: 700 out of 1000
- Cost: $99 USD

### Skills Measured

1. Describe cloud concepts (25-30%)
2. Describe Azure architecture and services (35-40%)
3. Describe Azure management and governance (30-35%)

### Study Resources

**[📖 AZ-900 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/az-900/)** - Official exam information

**[📖 Learning Path](https://learn.microsoft.com/en-us/certifications/azure-fundamentals/)** - Azure Fundamentals certification path

**[📖 Free Training](https://learn.microsoft.com/en-us/training/courses/az-900t00)** - Microsoft Learn training modules

### Key Study Areas

1. Understand cloud computing concepts thoroughly
2. Know the differences between IaaS, PaaS, and SaaS
3. Understand Azure architecture (regions, availability zones)
4. Familiarize yourself with core services (Compute, Storage, Networking, Databases)
5. Learn security and compliance features
6. Understand pricing models and cost management
7. Know the support options available

### Recommended Hands-On Practice

1. Create a free Azure account
2. Deploy virtual machines
3. Create storage accounts and upload data
4. Explore the Azure Portal
5. Use the Pricing Calculator
6. Review Azure Advisor recommendations
7. Configure basic networking (VNet, NSG)

### Important Terminology

- **Azure Resource**: Manageable item available through Azure
- **Resource Group**: Container holding related resources
- **Subscription**: Logical container for resources, linked billing unit
- **Management Group**: Container for managing access, policies across subscriptions
- **ARM**: Azure Resource Manager deployment and management layer
- **Availability Zone**: Physically separate datacenter within region
- **Region Pair**: Two regions 300+ miles apart for disaster recovery
- **SLA**: Service Level Agreement defining uptime guarantees
- **TCO**: Total Cost of Ownership comparison tool
- **RBAC**: Role-Based Access Control for fine-grained permissions

---

## Quick Reference Summary

### Cloud Models
- **IaaS**: Maximum control, manage OS and above
- **PaaS**: Focus on applications, platform managed
- **SaaS**: Fully managed applications

### Deployment Types
- **Public**: Shared infrastructure, internet accessible
- **Private**: Dedicated infrastructure, more control
- **Hybrid**: Combination of public and private

### Core Compute
- **VMs**: Full control IaaS
- **App Service**: PaaS web/API hosting
- **Functions**: Serverless, event-driven
- **AKS**: Managed Kubernetes
- **Container Instances**: Simple container hosting

### Core Storage
- **Blob**: Object storage (Hot/Cool/Archive)
- **Files**: SMB file shares
- **Queue**: Message queue
- **Table**: NoSQL key-value
- **Disk**: VM block storage

### Core Database
- **Cosmos DB**: Global NoSQL
- **SQL Database**: Managed SQL Server
- **MySQL/PostgreSQL**: Managed open-source

### Core Networking
- **VNet**: Isolated network
- **VPN Gateway**: Encrypted site-to-site
- **ExpressRoute**: Private dedicated connection
- **NSG**: Network traffic filtering
- **Load Balancer**: Layer 4 traffic distribution
- **Application Gateway**: Layer 7 web traffic routing

### Identity and Security
- **Azure AD / Entra ID**: Identity management, SSO, MFA
- **Defender for Cloud**: Security posture, threat protection
- **Key Vault**: Secrets and key management
- **Azure Policy**: Governance and compliance
- **RBAC**: Fine-grained access control

### Management Tools
- **Portal**: Web-based GUI
- **CLI**: Cross-platform command line
- **PowerShell**: Scripting and automation
- **Cloud Shell**: Browser-based shell
- **ARM Templates**: Infrastructure as code

### Cost Management
- **Pricing Calculator**: Estimate costs
- **TCO Calculator**: Compare on-prem vs cloud
- **Cost Management**: Monitor and optimize
- **Reserved Instances**: 1-3 year commitments
- **Hybrid Benefit**: Use existing licenses
- **Azure Advisor**: Personalized recommendations

---

## Final Notes

This fact sheet covers the essential topics for the AZ-900 Azure Fundamentals certification. The exam tests foundational knowledge of cloud services and how Azure implements them. Focus on understanding concepts rather than memorizing specific details.

Remember:
- The exam is foundational level - broad knowledge over deep expertise
- Hands-on experience with Azure Portal is invaluable
- Understand the "why" behind services, not just "what" they are
- Know when to use each service type
- Understand cost implications and optimization strategies

Good luck with your certification!

**Last Updated**: 2025-10-13
