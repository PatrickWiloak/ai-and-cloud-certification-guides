---
last-updated: 2026-05-03
---

# Microsoft Azure Administrator (AZ-104) - Fact Sheet

## Quick Reference

**Exam Code:** AZ-104
**Duration:** 120 minutes (2 hours)
**Questions:** 40-60 questions
**Passing Score:** 700/1000
**Cost:** $165 USD
**Validity:** 1 year (annual renewal required)
**Delivery:** Pearson VUE
**Difficulty:** ⭐⭐⭐⭐ (Hands-on focus with lab simulations)

## Exam Domain Breakdown

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Manage Azure identities and governance | 20-25% | Azure AD, RBAC, subscriptions, governance |
| Implement and manage storage | 15-20% | Storage accounts, Azure Files, backup, data transfer |
| Deploy and manage Azure compute resources | 20-25% | VMs, containers, App Services, scaling |
| Implement and manage virtual networking | 15-20% | VNets, NSGs, load balancers, DNS, VPN |
| Monitor and maintain Azure resources | 10-15% | Azure Monitor, Log Analytics, backup, updates |

## Key Services by Domain

### Manage Azure Identities and Governance (20-25%)

**Azure Active Directory (Azure AD)**
- Identity and access management service
- Single sign-on (SSO) and multi-factor authentication (MFA)
- User and group management
- Self-service password reset (SSPR)
- Azure AD Connect for hybrid identity
- **[📖 Azure AD Documentation](https://learn.microsoft.com/en-us/azure/active-directory/)** - Complete Azure AD guide
- **[📖 Azure AD Users](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory)** - User management
- **[📖 Azure AD Groups](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal)** - Group management
- **[📖 Azure MFA](https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks)** - Multi-factor authentication
- **[📖 SSPR Configuration](https://learn.microsoft.com/en-us/azure/active-directory/authentication/tutorial-enable-sspr)** - Self-service password reset
- **[📖 Azure AD Connect](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect)** - Hybrid identity

**Role-Based Access Control (RBAC)**
- Fine-grained access management
- Built-in roles: Owner, Contributor, Reader, User Access Administrator
- Custom roles for specific permissions
- Scope: Management group, subscription, resource group, resource
- Role assignments with Azure AD principals
- **[📖 Azure RBAC Overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)** - RBAC fundamentals
- **[📖 Built-in Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)** - Role reference
- **[📖 Custom Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)** - Create custom roles
- **[📖 Assign Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)** - Role assignments
- **[📖 RBAC Best Practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices)** - Security guidelines

**Azure Policy**
- Enforce organizational standards and compliance
- Policy definitions: Rules for resource properties
- Initiatives: Groups of policy definitions
- Remediation: Automatic or manual fixes
- Compliance reporting
- **[📖 Azure Policy Overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)** - Policy fundamentals
- **[📖 Policy Definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)** - Policy structure
- **[📖 Initiative Definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)** - Policy initiatives
- **[📖 Remediation Tasks](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)** - Fix non-compliant resources
- **[📖 Compliance Evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)** - Compliance reporting

**Subscriptions and Management Groups**
- Management groups: Hierarchical organization of subscriptions
- Subscription management: Create, move, cancel
- Resource tags: Metadata for organization and billing
- Cost management and budgets
- **[📖 Management Groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)** - Hierarchy management
- **[📖 Subscription Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)** - Subscription operations
- **[📖 Resource Tags](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)** - Tagging strategy
- **[📖 Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/quick-acm-cost-analysis)** - Cost analysis
- **[📖 Budgets](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-acm-create-budgets)** - Budget creation

### Implement and Manage Storage (15-20%)

**Storage Accounts**
- Blob storage: Object storage for unstructured data
- File storage: Managed file shares (SMB/NFS)
- Queue storage: Message storage
- Table storage: NoSQL key-value store
- Storage tiers: Hot, Cool, Archive
- Replication: LRS, ZRS, GRS, GZRS, RA-GRS, RA-GZRS
- **[📖 Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)** - Storage fundamentals
- **[📖 Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)** - Object storage
- **[📖 Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction)** - File shares
- **[📖 Storage Tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)** - Access tiers
- **[📖 Storage Replication](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy)** - Redundancy options
- **[📖 Storage Security](https://learn.microsoft.com/en-us/azure/storage/common/storage-security-guide)** - Security best practices

**Azure Blob Storage**
- Block blobs, append blobs, page blobs
- Blob access tiers: Hot, Cool, Archive
- Lifecycle management policies
- Soft delete for blobs and containers
- Versioning and point-in-time restore
- **[📖 Blob Types](https://learn.microsoft.com/en-us/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs)** - Blob comparison
- **[📖 Lifecycle Management](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview)** - Automated tiering
- **[📖 Blob Soft Delete](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview)** - Data protection
- **[📖 Blob Versioning](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview)** - Version control
- **[📖 Point-in-Time Restore](https://learn.microsoft.com/en-us/azure/storage/blobs/point-in-time-restore-overview)** - Recovery options

**Azure Files**
- SMB and NFS file shares
- Azure File Sync for hybrid scenarios
- Identity-based authentication (Azure AD DS or AD DS)
- Snapshots for backup
- Premium and standard performance tiers
- **[📖 Azure Files Planning](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-planning)** - Deployment guide
- **[📖 File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction)** - Hybrid file sync
- **[📖 File Share Authentication](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-active-directory-overview)** - Identity integration
- **[📖 File Snapshots](https://learn.microsoft.com/en-us/azure/storage/files/storage-snapshots-files)** - Backup and restore
- **[📖 File Share Performance](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-scale-targets)** - Performance tiers

**Storage Security**
- Shared access signatures (SAS): Delegated access
- Stored access policies: Revocable SAS
- Storage service encryption (SSE): Encryption at rest
- Encryption in transit: HTTPS/TLS
- Network rules: Firewall and virtual networks
- **[📖 Shared Access Signatures](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)** - SAS fundamentals
- **[📖 Stored Access Policies](https://learn.microsoft.com/en-us/rest/api/storageservices/define-stored-access-policy)** - Policy management
- **[📖 Storage Encryption](https://learn.microsoft.com/en-us/azure/storage/common/storage-service-encryption)** - Encryption at rest
- **[📖 Storage Firewalls](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security)** - Network security
- **[📖 Private Endpoints](https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints)** - Private connectivity

**Data Transfer and Management**
- AzCopy: Command-line utility for bulk transfer
- Azure Storage Explorer: GUI management tool
- Azure Data Box: Physical data transfer device
- Azure Import/Export service
- **[📖 AzCopy](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** - Bulk transfer tool
- **[📖 Storage Explorer](https://learn.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer)** - GUI tool
- **[📖 Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/data-box-overview)** - Physical transfer
- **[📖 Import/Export Service](https://learn.microsoft.com/en-us/azure/import-export/storage-import-export-service)** - Disk shipping

### Deploy and Manage Azure Compute Resources (20-25%)

**Virtual Machines**
- VM sizes: General purpose, compute, memory, storage, GPU optimized
- Availability sets: Fault and update domains
- Availability zones: Physical datacenter separation
- VM extensions: Post-deployment configuration
- Custom script extension for automation
- **[📖 VM Overview](https://learn.microsoft.com/en-us/azure/virtual-machines/overview)** - VM fundamentals
- **[📖 VM Sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes)** - Size categories
- **[📖 Availability Sets](https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview)** - High availability
- **[📖 Availability Zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview)** - Zone redundancy
- **[📖 VM Extensions](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/overview)** - Extension overview
- **[📖 Custom Script Extension](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows)** - Script automation

**VM Configuration and Management**
- Managed disks: OS and data disks
- Disk types: Standard HDD, Standard SSD, Premium SSD, Ultra Disk
- VM images: Marketplace and custom images
- Azure Compute Gallery (Shared Image Gallery)
- VM deployment: Portal, CLI, PowerShell, ARM templates
- **[📖 Managed Disks](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)** - Disk management
- **[📖 Disk Types](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types)** - Performance comparison
- **[📖 VM Images](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/imaging)** - Image management
- **[📖 Azure Compute Gallery](https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery)** - Shared images
- **[📖 ARM Templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)** - Infrastructure as code

**Virtual Machine Scale Sets (VMSS)**
- Auto-scaling: Metric-based or schedule-based
- Load balancing: Azure Load Balancer or Application Gateway
- Update management: Rolling upgrades
- Instance protection
- Orchestration modes: Uniform and Flexible
- **[📖 VMSS Overview](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)** - Scale sets fundamentals
- **[📖 Autoscaling](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview)** - Auto-scale configuration
- **[📖 VMSS Upgrades](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-upgrade-policy)** - Upgrade policies
- **[📖 Orchestration Modes](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes)** - Mode comparison
- **[📖 Instance Protection](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-protection)** - Protect instances

**Azure App Service**
- Web apps: Host web applications
- App Service plans: Shared, Basic, Standard, Premium, Isolated
- Deployment slots: Staging environments
- Auto-scaling rules
- Custom domains and SSL/TLS certificates
- **[📖 App Service Overview](https://learn.microsoft.com/en-us/azure/app-service/overview)** - App Service fundamentals
- **[📖 App Service Plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)** - Pricing tiers
- **[📖 Deployment Slots](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots)** - Staging environments
- **[📖 App Service Scaling](https://learn.microsoft.com/en-us/azure/app-service/manage-scale-up)** - Scaling options
- **[📖 Custom Domains](https://learn.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain)** - Domain configuration
- **[📖 SSL Certificates](https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-certificate)** - Certificate management

**Azure Container Instances (ACI)**
- Serverless containers
- Fast startup without VM management
- Public IP and DNS name support
- Persistent storage with Azure Files
- Container groups for multi-container deployments
- **[📖 ACI Overview](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview)** - Container instances
- **[📖 Container Groups](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-container-groups)** - Multi-container pods
- **[📖 ACI Networking](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-virtual-network-concepts)** - Network configuration
- **[📖 ACI Storage](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files)** - Persistent volumes

**Azure Kubernetes Service (AKS)**
- Managed Kubernetes cluster
- Node pools: System and user node pools
- Scaling: Cluster autoscaler and horizontal pod autoscaler
- Networking: kubenet and Azure CNI
- Azure AD integration for RBAC
- **[📖 AKS Overview](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes)** - AKS fundamentals
- **[📖 AKS Node Pools](https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools)** - Node pool management
- **[📖 AKS Scaling](https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler)** - Auto-scaling
- **[📖 AKS Networking](https://learn.microsoft.com/en-us/azure/aks/concepts-network)** - Network plugins
- **[📖 AKS RBAC](https://learn.microsoft.com/en-us/azure/aks/azure-ad-rbac)** - Azure AD integration

### Implement and Manage Virtual Networking (15-20%)

**Virtual Networks (VNet)**
- Address space: CIDR notation
- Subnets: Segmentation within VNet
- VNet peering: Connect VNets (same or different regions)
- Service endpoints: Secure Azure service access
- Private endpoints: Private IP for Azure services
- **[📖 VNet Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)** - VNet fundamentals
- **[📖 Plan VNets](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-vnet-plan-design-arm)** - Network design
- **[📖 Subnets](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet)** - Subnet management
- **[📖 VNet Peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)** - Network connectivity
- **[📖 Service Endpoints](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview)** - Service integration
- **[📖 Private Endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)** - Private connectivity

**Network Security Groups (NSGs)**
- Inbound and outbound security rules
- Priority-based rule evaluation (100-4096)
- Default rules: Allow VNet, Azure Load Balancer, deny all
- Application Security Groups (ASGs): Logical grouping
- Flow logs: NSG traffic logging
- **[📖 NSG Overview](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)** - NSG fundamentals
- **[📖 NSG Rules](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works)** - Rule processing
- **[📖 Application Security Groups](https://learn.microsoft.com/en-us/azure/virtual-network/application-security-groups)** - ASG usage
- **[📖 NSG Flow Logs](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)** - Traffic analysis

**Azure Load Balancer**
- Layer 4 (TCP/UDP) load balancing
- Public and internal load balancers
- Health probes: TCP, HTTP, HTTPS
- Load balancing rules and NAT rules
- Standard SKU: Zone redundancy, diagnostics
- **[📖 Load Balancer Overview](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)** - Load balancer fundamentals
- **[📖 Load Balancer SKUs](https://learn.microsoft.com/en-us/azure/load-balancer/skus)** - Basic vs Standard
- **[📖 Health Probes](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview)** - Health monitoring
- **[📖 Load Balancing Rules](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-distribution-mode)** - Distribution algorithms

**Application Gateway**
- Layer 7 (HTTP/HTTPS) load balancing
- Web Application Firewall (WAF)
- URL path-based routing
- SSL/TLS termination
- Multi-site hosting
- Auto-scaling
- **[📖 Application Gateway Overview](https://learn.microsoft.com/en-us/azure/application-gateway/overview)** - App Gateway fundamentals
- **[📖 Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)** - WAF protection
- **[📖 URL Routing](https://learn.microsoft.com/en-us/azure/application-gateway/url-route-overview)** - Path-based routing
- **[📖 SSL Termination](https://learn.microsoft.com/en-us/azure/application-gateway/ssl-overview)** - Certificate management
- **[📖 Multi-site Hosting](https://learn.microsoft.com/en-us/azure/application-gateway/multiple-site-overview)** - Host multiple sites

**Azure DNS**
- Public DNS zones: Internet-facing domains
- Private DNS zones: VNet name resolution
- Alias records: Point to Azure resources
- DNS forwarding and conditional forwarding
- **[📖 Azure DNS Overview](https://learn.microsoft.com/en-us/azure/dns/dns-overview)** - DNS fundamentals
- **[📖 Public DNS Zones](https://learn.microsoft.com/en-us/azure/dns/dns-zones-records)** - Zone management
- **[📖 Private DNS Zones](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview)** - Private name resolution
- **[📖 DNS Alias Records](https://learn.microsoft.com/en-us/azure/dns/dns-alias)** - Dynamic DNS

**VPN Gateway and ExpressRoute**
- VPN Gateway: Site-to-site, point-to-site, VNet-to-VNet
- Gateway SKUs: Basic, VpnGw1-5, VpnGw1AZ-5AZ
- ExpressRoute: Private connection to Azure
- ExpressRoute circuits: 50 Mbps to 10 Gbps
- **[📖 VPN Gateway Overview](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)** - VPN fundamentals
- **[📖 Site-to-Site VPN](https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal)** - S2S configuration
- **[📖 Point-to-Site VPN](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-about)** - P2S overview
- **[📖 ExpressRoute Overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)** - Private connectivity
- **[📖 ExpressRoute Circuits](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)** - Circuit configuration

**Azure Firewall**
- Managed cloud-based network security
- Application and network rules
- Threat intelligence-based filtering
- FQDN filtering for outbound traffic
- SNAT and DNAT support
- **[📖 Azure Firewall Overview](https://learn.microsoft.com/en-us/azure/firewall/overview)** - Firewall fundamentals
- **[📖 Firewall Rules](https://learn.microsoft.com/en-us/azure/firewall/rule-processing)** - Rule processing
- **[📖 Threat Intelligence](https://learn.microsoft.com/en-us/azure/firewall/threat-intel)** - Security filtering
- **[📖 DNAT Rules](https://learn.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat)** - Destination NAT

### Monitor and Maintain Azure Resources (10-15%)

**Azure Monitor**
- Metrics: Numerical time-series data
- Logs: Text-based event data
- Application Insights: Application performance monitoring
- VM Insights: VM performance and dependencies
- Network Watcher: Network diagnostics
- **[📖 Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)** - Monitoring fundamentals
- **[📖 Azure Monitor Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)** - Metrics platform
- **[📖 Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)** - Logs platform
- **[📖 Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)** - APM solution
- **[📖 VM Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview)** - VM monitoring
- **[📖 Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview)** - Network diagnostics

**Log Analytics**
- Centralized log storage and analysis
- Kusto Query Language (KQL) for queries
- Workspaces: Log data storage
- Query results export and visualization
- Log Analytics agent for data collection
- **[📖 Log Analytics Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)** - Log Analytics fundamentals
- **[📖 Log Analytics Workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)** - Workspace design
- **[📖 KQL Overview](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/)** - Query language
- **[📖 Log Queries](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)** - Query examples
- **[📖 Log Analytics Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/log-analytics-agent)** - Agent deployment

**Alerts and Action Groups**
- Metric alerts: Threshold-based alerts
- Log alerts: KQL query-based alerts
- Activity log alerts: Resource changes
- Action groups: Notification and automation
- Alert rules and processing rules
- **[📖 Azure Monitor Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)** - Alerts fundamentals
- **[📖 Metric Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-overview)** - Metric-based alerts
- **[📖 Log Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-unified-log)** - Query-based alerts
- **[📖 Activity Log Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/activity-log-alerts)** - Resource alerts
- **[📖 Action Groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)** - Alert actions

**Azure Backup**
- Azure VM backup: Agent-based and agentless
- File and folder backup: MARS agent
- Azure Files backup: Snapshot-based
- SQL Server and SAP HANA backup
- Recovery Services vault: Backup storage
- Backup policies: Schedule and retention
- **[📖 Azure Backup Overview](https://learn.microsoft.com/en-us/azure/backup/backup-overview)** - Backup fundamentals
- **[📖 VM Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction)** - VM protection
- **[📖 MARS Agent](https://learn.microsoft.com/en-us/azure/backup/backup-azure-about-mars)** - File backup agent
- **[📖 Azure Files Backup](https://learn.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview)** - File share protection
- **[📖 Recovery Services Vault](https://learn.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview)** - Vault management
- **[📖 Backup Policies](https://learn.microsoft.com/en-us/azure/backup/backup-azure-manage-vms)** - Policy configuration

**Azure Site Recovery**
- Disaster recovery orchestration
- Azure-to-Azure replication
- On-premises-to-Azure replication
- Recovery plans: Automated failover
- Test failover: DR testing without impact
- **[📖 Site Recovery Overview](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview)** - DR fundamentals
- **[📖 Azure VM Replication](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture)** - Azure-to-Azure DR
- **[📖 Recovery Plans](https://learn.microsoft.com/en-us/azure/site-recovery/recovery-plan-overview)** - Failover orchestration
- **[📖 Test Failover](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-test-failover-to-azure)** - DR testing

**Update Management**
- Azure Update Manager: Centralized patch management
- Update assessment: View available updates
- Update deployment: Schedule patching
- Windows Update and WSUS integration
- Linux package manager integration
- **[📖 Azure Update Manager](https://learn.microsoft.com/en-us/azure/update-manager/overview)** - Update management
- **[📖 Update Assessment](https://learn.microsoft.com/en-us/azure/update-manager/view-updates)** - Compliance reporting
- **[📖 Update Deployment](https://learn.microsoft.com/en-us/azure/update-manager/deploy-updates)** - Patch scheduling
- **[📖 Maintenance Configurations](https://learn.microsoft.com/en-us/azure/update-manager/scheduled-patching)** - Maintenance windows

## PowerShell and Azure CLI Commands

### Azure PowerShell

**Connect and Manage Context**
```powershell
Connect-AzAccount                              # Sign in to Azure
Get-AzContext                                  # Get current context
Set-AzContext -Subscription "subscription-id"  # Switch subscription
```

**Resource Group Management**
```powershell
New-AzResourceGroup -Name "rg-name" -Location "eastus"
Get-AzResourceGroup
Remove-AzResourceGroup -Name "rg-name"
```

**Virtual Machine Management**
```powershell
New-AzVM -ResourceGroupName "rg-name" -Name "vm-name" -Location "eastus"
Start-AzVM -ResourceGroupName "rg-name" -Name "vm-name"
Stop-AzVM -ResourceGroupName "rg-name" -Name "vm-name"
Restart-AzVM -ResourceGroupName "rg-name" -Name "vm-name"
Remove-AzVM -ResourceGroupName "rg-name" -Name "vm-name"
```

**Storage Account Management**
```powershell
New-AzStorageAccount -ResourceGroupName "rg-name" -Name "storageacct" -Location "eastus" -SkuName "Standard_LRS"
Get-AzStorageAccount -ResourceGroupName "rg-name"
Set-AzStorageAccount -ResourceGroupName "rg-name" -Name "storageacct" -SkuName "Standard_GRS"
```

**Virtual Network Management**
```powershell
New-AzVirtualNetwork -ResourceGroupName "rg-name" -Name "vnet-name" -AddressPrefix "10.0.0.0/16" -Location "eastus"
New-AzVirtualNetworkSubnetConfig -Name "subnet-name" -AddressPrefix "10.0.1.0/24"
Get-AzVirtualNetwork -ResourceGroupName "rg-name"
```

- **[📖 Azure PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/azure/)** - Complete PowerShell reference
- **[📖 Install Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell)** - Installation guide
- **[📖 Azure PowerShell Cmdlets](https://learn.microsoft.com/en-us/powershell/module/az.accounts/)** - Cmdlet reference

### Azure CLI

**Connect and Manage Account**
```bash
az login                                    # Sign in to Azure
az account list                             # List subscriptions
az account set --subscription "subscription-id"  # Switch subscription
az account show                             # Show current subscription
```

**Resource Group Management**
```bash
az group create --name rg-name --location eastus
az group list
az group delete --name rg-name
```

**Virtual Machine Management**
```bash
az vm create --resource-group rg-name --name vm-name --image UbuntuLTS
az vm start --resource-group rg-name --name vm-name
az vm stop --resource-group rg-name --name vm-name
az vm restart --resource-group rg-name --name vm-name
az vm list --resource-group rg-name
az vm delete --resource-group rg-name --name vm-name
```

**Storage Account Management**
```bash
az storage account create --name storageacct --resource-group rg-name --location eastus --sku Standard_LRS
az storage account list --resource-group rg-name
az storage account show --name storageacct --resource-group rg-name
az storage account delete --name storageacct --resource-group rg-name
```

**Virtual Network Management**
```bash
az network vnet create --resource-group rg-name --name vnet-name --address-prefix 10.0.0.0/16
az network vnet subnet create --resource-group rg-name --vnet-name vnet-name --name subnet-name --address-prefix 10.0.1.0/24
az network vnet list --resource-group rg-name
```

**NSG Management**
```bash
az network nsg create --resource-group rg-name --name nsg-name
az network nsg rule create --resource-group rg-name --nsg-name nsg-name --name rule-name --priority 100 --source-address-prefixes '*' --destination-port-ranges 80
az network nsg list --resource-group rg-name
```

- **[📖 Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)** - Complete CLI reference
- **[📖 Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)** - Installation guide
- **[📖 Azure CLI Command Reference](https://learn.microsoft.com/en-us/cli/azure/reference-index)** - Command reference

## Common Administrator Scenarios

### Scenario 1: Implement High Availability for Web Application
**Requirements:** Deploy web app across multiple regions with automatic failover
**Solution:**
1. Deploy App Service in primary region
2. Configure deployment slot for staging
3. Set up Azure Front Door or Traffic Manager for global load balancing
4. Configure health probes for automatic failover
5. Implement Azure SQL Database with geo-replication
6. Configure backup and disaster recovery

### Scenario 2: Secure Virtual Network for Multi-Tier Application
**Requirements:** Deploy web, app, and database tiers with proper isolation
**Solution:**
1. Create VNet with three subnets (web, app, database)
2. Configure NSGs with least privilege rules
3. Place VMs in availability zones
4. Deploy Azure Bastion for secure remote access
5. Configure service endpoints for Azure SQL
6. Implement Application Gateway with WAF for web tier

### Scenario 3: Hybrid Connectivity for On-Premises Integration
**Requirements:** Connect on-premises datacenter to Azure securely
**Solution:**
1. Create VPN Gateway in Azure VNet
2. Configure site-to-site VPN connection
3. Set up local network gateway for on-premises
4. Configure BGP for dynamic routing (optional)
5. Implement ExpressRoute for dedicated connection (production)
6. Set up DNS forwarding between environments

### Scenario 4: Centralized Monitoring and Alerting
**Requirements:** Monitor all Azure resources with automated alerting
**Solution:**
1. Create Log Analytics workspace
2. Deploy diagnostic settings on all resources
3. Install Log Analytics agent on VMs
4. Configure metric and log alerts
5. Create action groups for notifications
6. Build custom dashboards in Azure Monitor
7. Set up workbooks for reporting

### Scenario 5: Automated Backup and Recovery
**Requirements:** Protect VMs and databases with automated backup
**Solution:**
1. Create Recovery Services vault
2. Configure VM backup policies (daily, weekly, monthly retention)
3. Enable Azure Files backup with snapshots
4. Set up Azure SQL Database automated backups
5. Implement Azure Site Recovery for DR
6. Test recovery procedures regularly
7. Configure backup alerts and monitoring

## Exam Tips

### Hands-On Focus
- AZ-104 includes performance-based testing (lab simulations)
- Must demonstrate actual Azure portal, PowerShell, and CLI skills
- Practice in real Azure environment is essential (use free tier)
- Know how to navigate Azure portal efficiently

### Common Exam Scenarios
- Configure RBAC for least privilege access
- Implement VM backup and restore
- Create and configure virtual networks with NSGs
- Deploy and scale VMs and App Services
- Configure Azure AD users and groups
- Implement storage account security
- Set up monitoring and alerts
- Configure site-to-site VPN connectivity
- Manage resource tags and cost optimization

### Question Keywords
- **"Most secure"** → Private endpoints, managed identities, least privilege RBAC
- **"High availability"** → Availability zones, scale sets, load balancers, geo-replication
- **"Cost-effective"** → Reserved instances, spot VMs, storage tiers, right-sizing
- **"Monitor"** → Azure Monitor, Log Analytics, Application Insights, alerts
- **"Automate"** → PowerShell, Azure CLI, ARM templates, Azure Automation
- **"Hybrid"** → VPN Gateway, ExpressRoute, Azure Arc, File Sync

### Azure RBAC Key Roles
- **Owner:** Full access including access management
- **Contributor:** Full access except access management
- **Reader:** View-only access
- **User Access Administrator:** Manage user access only
- Know when to use built-in vs. custom roles

### Storage Replication Options
- **LRS:** Locally redundant (3 copies, one datacenter) - cheapest
- **ZRS:** Zone redundant (3 availability zones)
- **GRS:** Geo-redundant (6 copies, 2 regions)
- **GZRS:** Geo-zone redundant (best protection)
- **RA-GRS/RA-GZRS:** Read access to secondary region

### VM Availability Options
- **Availability Set:** 99.95% SLA (fault/update domains)
- **Availability Zone:** 99.99% SLA (physical separation)
- **Single VM:** 99.9% SLA (Premium SSD required)

## Essential Documentation

### Core Resources
- **[📖 AZ-104 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/az-104)** - Official exam information
- **[📖 AZ-104 Study Guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/az-104)** - Microsoft study guide
- **[📖 Microsoft Learn - AZ-104](https://learn.microsoft.com/en-us/training/courses/az-104t00)** - Learning path
- **[📖 Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)** - Architecture best practices
- **[📖 Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/)** - Design principles

### Hands-On Resources
- **[📖 Azure Free Account](https://azure.microsoft.com/en-us/free/)** - 12 months free + $200 credit
- **[📖 Microsoft Learn Sandbox](https://learn.microsoft.com/en-us/training/support/faq?pivots=sandbox)** - Free practice environment
- **[📖 Azure Quickstart Templates](https://learn.microsoft.com/en-us/samples/browse/?expanded=azure&products=azure-resource-manager)** - ARM template examples
- **[📖 Azure Solutions](https://azure.microsoft.com/en-us/solutions/)** - Solution architectures

## Final Checklist

### Knowledge Requirements
- [ ] Configure and manage Azure AD users, groups, and RBAC
- [ ] Implement and manage storage accounts with appropriate security
- [ ] Deploy and manage VMs, scale sets, and App Services
- [ ] Configure virtual networks, NSGs, and load balancers
- [ ] Set up Azure Monitor, Log Analytics, and alerts
- [ ] Implement backup and disaster recovery solutions
- [ ] Use Azure PowerShell and Azure CLI proficiently
- [ ] Understand Azure Policy and governance
- [ ] Configure hybrid connectivity (VPN, ExpressRoute)
- [ ] Manage costs and optimize resources

### Skills Requirements
- [ ] Azure portal navigation and management
- [ ] PowerShell scripting for Azure
- [ ] Azure CLI command-line operations
- [ ] ARM template deployment
- [ ] Troubleshooting Azure resources
- [ ] Network configuration and troubleshooting
- [ ] Security implementation and management

### Preparation Milestones
- [ ] 6+ months Azure administration experience (recommended)
- [ ] Completed Microsoft Learn training modules
- [ ] Hands-on practice with all core services
- [ ] Lab simulations and practice tests (75%+ score)
- [ ] Understand all exam objectives
- [ ] Reviewed Microsoft documentation
- [ ] Practiced PowerShell and CLI commands

---

**Pro Tip:** AZ-104 is a hands-on administrator exam with lab simulations. You MUST have practical experience deploying and managing Azure resources. Focus on the Azure portal, PowerShell, and CLI - you'll need to perform actual tasks during the exam. Set up a free Azure account and practice every day!

**Good luck!** 🚀
