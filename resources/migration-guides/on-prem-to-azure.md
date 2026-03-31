# On-Premises to Azure Migration Guide

## Overview

Migrating to Microsoft Azure follows the Cloud Adoption Framework (CAF), a structured methodology that covers strategy, planning, readiness, migration, and governance. This guide covers Azure migration tools, landing zones, and best practices for a successful on-premises to Azure migration.

---

## Azure Cloud Adoption Framework Phases

### 1. Strategy

- Define business motivations (cost reduction, agility, innovation)
- Identify business outcomes and success metrics
- Build a business justification with financial analysis
- Choose the first migration project (start small, prove value)
- Documentation: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/strategy/

### 2. Plan

- Inventory digital estate (applications, data, infrastructure)
- Rationalize workloads using the 5 Rs (Rehost, Refactor, Rearchitect, Rebuild, Replace)
- Create a cloud adoption plan with prioritized waves
- Define organizational readiness and skills gaps
- Documentation: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/

### 3. Ready

- Deploy Azure landing zones
- Set up governance, security, and management baselines
- Establish naming conventions and tagging standards
- Configure network connectivity
- Documentation: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/

### 4. Migrate

- Assess workloads with Azure Migrate
- Replicate and migrate servers, databases, and applications
- Optimize migrated workloads
- Documentation: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/

### 5. Govern and Manage

- Implement governance policies (Azure Policy, Blueprints)
- Set up monitoring and management baselines
- Establish cost management practices
- Continuous improvement of cloud operations

---

## Azure Migrate Hub

### Overview

- Central hub for discovering, assessing, and migrating on-premises workloads
- Unified dashboard for tracking migration progress
- Integrates with first-party and third-party tools
- Documentation: https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview

### Discovery and Assessment

- Deploy the Azure Migrate appliance (lightweight VM) on-premises
- Agentless discovery of VMware, Hyper-V, and physical servers
- Collects performance data (CPU, memory, disk, network)
- Dependency mapping (agentless or agent-based with Service Map)
- Generates Azure readiness reports and cost estimates
- Right-sizing recommendations based on actual utilization

### Assessment Types

- **Azure VM Assessment**: readiness and sizing for Azure VMs
- **Azure SQL Assessment**: readiness for Azure SQL Database, SQL Managed Instance, or SQL on Azure VMs
- **Azure App Service Assessment**: readiness for Azure App Service
- **AVS Assessment**: readiness for Azure VMware Solution
- **Web App Assessment**: readiness for Azure App Service or Azure Kubernetes Service

### Assessment Checklist

- [ ] Deploy Azure Migrate appliance in each datacenter
- [ ] Run discovery for minimum 2 weeks to capture performance patterns
- [ ] Enable dependency analysis for critical applications
- [ ] Review readiness reports and address blockers
- [ ] Validate cost estimates against current on-premises costs
- [ ] Identify applications suitable for each migration strategy
- [ ] Document application owners and stakeholders

---

## Azure Landing Zones

### What is a Landing Zone?

- Pre-configured Azure environment following best practices
- Provides governance, security, networking, and identity foundations
- Scales from small deployments to enterprise-grade environments
- Documentation: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/

### Landing Zone Architecture

- **Management groups**: hierarchical organization of subscriptions
- **Subscriptions**: isolation boundaries for workloads (production, dev, sandbox)
- **Resource groups**: logical containers for related resources
- **Azure Policy**: enforce organizational standards and compliance
- **RBAC**: role-based access control for least-privilege access

### Deployment Options

- **Azure Landing Zone Accelerator**: Bicep/Terraform templates for full enterprise deployment
- **Start small and expand**: begin with a single subscription and add governance over time
- **Enterprise-scale**: full topology with hub-and-spoke or Virtual WAN networking

### Key Components

- Identity: Azure AD (Entra ID) integration with on-premises AD via Azure AD Connect
- Networking: hub-and-spoke topology with Azure Firewall
- Management: Azure Monitor, Log Analytics, Microsoft Defender for Cloud
- Governance: Azure Policy, cost management, resource locks
- Security: Microsoft Defender, Key Vault, DDoS Protection

---

## Network Connectivity

### Azure ExpressRoute

- Private dedicated connection from on-premises to Azure
- Bandwidth options: 50 Mbps to 100 Gbps
- Lower latency and higher reliability than internet connections
- ExpressRoute Global Reach for connecting on-premises sites through Azure
- Two peering types: Azure private peering and Microsoft peering
- Lead time varies by provider (days to weeks)
- Documentation: https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction

### Azure VPN Gateway

- Site-to-Site VPN: IPsec/IKE tunnel over the internet
- Point-to-Site VPN: individual client connections
- VPN Gateway SKUs determine throughput (up to 10 Gbps)
- Active-active configuration for high availability
- Use as primary connection for small workloads or backup for ExpressRoute
- Documentation: https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways

### Azure Virtual WAN

- Centralized networking hub connecting branches, VPNs, and ExpressRoute
- Simplifies large-scale branch connectivity
- Integrated routing and security with Azure Firewall
- Documentation: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about

### Network Planning Checklist

- [ ] Design IP address space to avoid overlap with on-premises
- [ ] Choose hub-and-spoke or Virtual WAN topology
- [ ] Order ExpressRoute circuit (if needed) early
- [ ] Configure VPN Gateway as backup or primary connectivity
- [ ] Set up Azure DNS Private Zones for hybrid name resolution
- [ ] Deploy Azure Firewall or NVA for traffic inspection
- [ ] Configure Network Security Groups and route tables

---

## Migration Tools and Services

### Azure Site Recovery (Server Migration)

- Replicates VMs from VMware, Hyper-V, or physical servers to Azure
- Continuous replication with minimal impact on source workloads
- Non-disruptive test migrations
- Orchestrated failover and failback
- Supports Windows and Linux operating systems
- Workflow:
  1. Set up Recovery Services vault
  2. Configure replication for source servers
  3. Continuous replication runs in the background
  4. Run test migrations to validate
  5. Execute planned failover for cutover
  6. Clean up source resources
- Documentation: https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview

### Azure Database Migration Service (DMS)

- Fully managed service for database migrations
- Supports online (minimal downtime) and offline migrations
- Source databases: SQL Server, MySQL, PostgreSQL, MongoDB, Oracle
- Target databases: Azure SQL Database, Azure SQL Managed Instance, Azure Database for MySQL/PostgreSQL, Cosmos DB
- Schema migration and data movement in a single workflow
- Documentation: https://learn.microsoft.com/en-us/azure/dms/dms-overview

### Azure Data Box (Large Data Transfers)

- Data Box Disk: up to 40 TB per order (SSD disks)
- Data Box: 80 TB capacity (rugged appliance)
- Data Box Heavy: up to 1 PB capacity
- Ship data to Azure when network transfer is impractical
- Data encrypted with AES-256 in transit
- Documentation: https://learn.microsoft.com/en-us/azure/databox/data-box-overview

### Azure File Sync

- Synchronize on-premises file servers with Azure Files
- Cloud tiering to free up local storage
- Multi-site sync for distributed file access
- Supports Windows Server 2012 R2 and later
- Documentation: https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction

### Additional Migration Tools

- **Azure App Service Migration Assistant**: migrate .NET and Java web apps
- **Azure Migrate: App Containerization**: containerize and move to AKS or App Service
- **Data Migration Assistant (DMA)**: assess SQL Server databases for migration readiness
- **Azure Storage Migration Service**: migrate file servers to Azure

---

## Migration Phases and Timeline

### Phase 1 - Assessment (Weeks 1-4)

- Deploy Azure Migrate appliance
- Run discovery and performance data collection
- Map application dependencies
- Generate assessment reports
- Build business case and migration plan

### Phase 2 - Landing Zone Setup (Weeks 3-6)

- Deploy Azure Landing Zone (management groups, subscriptions, policies)
- Configure networking (ExpressRoute/VPN, hub-and-spoke)
- Set up identity (Azure AD Connect, conditional access)
- Establish monitoring and security baselines
- Create CI/CD pipelines for infrastructure

### Phase 3 - Pilot Migration (Weeks 5-8)

- Migrate 2-3 non-critical applications
- Validate migration process and tooling
- Test monitoring, backup, and disaster recovery
- Refine runbooks and documentation
- Train operations teams

### Phase 4 - Migration Waves (Weeks 8-24+)

- Group applications into migration waves (5-10 apps per wave)
- Execute each wave: replicate, test, cutover
- Wave cadence: 2-4 weeks per wave
- Address blockers and adjust plans between waves
- Track progress in Azure Migrate hub

### Phase 5 - Optimization (Ongoing)

- Right-size VMs using Azure Advisor recommendations
- Implement Reserved Instances and Savings Plans
- Enable Azure Hybrid Benefit for Windows and SQL Server
- Review and optimize storage tiers
- Implement auto-scaling where applicable

---

## Validation and Cutover

### Pre-Cutover Checklist

- [ ] All test migrations completed successfully
- [ ] Application functionality verified in Azure
- [ ] Performance baselines met or exceeded
- [ ] Security controls validated (NSGs, Azure Policy, Defender)
- [ ] Backup and disaster recovery tested
- [ ] Monitoring and alerting configured (Azure Monitor, alerts)
- [ ] DNS TTLs reduced before cutover
- [ ] Rollback plan documented and tested
- [ ] Change advisory board approval obtained
- [ ] Communication sent to stakeholders

### Cutover Steps

1. Freeze changes on source environment
2. Perform final replication sync
3. Validate data consistency
4. Update DNS records to point to Azure resources
5. Run smoke tests against Azure environment
6. Monitor for errors and performance issues
7. Maintain source environment for rollback (48-72 hours minimum)
8. Decommission source after validation period

### Post-Migration Checklist

- [ ] Verify application health and performance
- [ ] Confirm monitoring alerts are functioning
- [ ] Validate backup schedules are running
- [ ] Review Azure Advisor recommendations
- [ ] Set up Azure Cost Management budgets and alerts
- [ ] Update documentation and runbooks
- [ ] Conduct lessons learned session
- [ ] Plan next migration wave

---

## Key Azure Documentation Links

| Resource | URL |
|----------|-----|
| Cloud Adoption Framework | https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ |
| Azure Migrate | https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview |
| Azure Site Recovery | https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview |
| Azure Database Migration Service | https://learn.microsoft.com/en-us/azure/dms/dms-overview |
| Azure Landing Zones | https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/ |
| ExpressRoute | https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction |
| Azure Advisor | https://learn.microsoft.com/en-us/azure/advisor/advisor-overview |

---

## Migration Anti-Patterns to Avoid

- Skipping the assessment phase and migrating blindly
- Not involving application owners in migration planning
- Ignoring Azure Hybrid Benefit (significant cost savings for Windows/SQL Server licenses)
- Deploying everything in a single subscription without governance
- Not planning for hybrid connectivity before migration starts
- Underestimating the time needed for application testing
- Forgetting to update monitoring and alerting for the new environment
- Not establishing cost management practices from day one
