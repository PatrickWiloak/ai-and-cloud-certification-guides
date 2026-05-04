---
last-updated: 2026-05-03
---

# Azure DP-300 Certification Fact Sheet

## Comprehensive Quick Reference Guide for Administering Microsoft Azure SQL Solutions

---

## Table of Contents
1. [Exam Overview](#exam-overview)
2. [Database Deployment](#database-deployment)
3. [Security](#security)
4. [Monitoring & Performance](#monitoring--performance)
5. [Optimization](#optimization)
6. [High Availability & Disaster Recovery](#high-availability--disaster-recovery)
7. [Automation](#automation)
8. [Cost Management](#cost-management)

---

## Exam Overview

### Exam Structure
- **Exam Code:** DP-300: Administering Microsoft Azure SQL Solutions
- **Duration:** 180 minutes (3 hours)
- **Questions:** 40-60 questions
- **Passing Score:** 700/1000
- **Cost:** $165 USD
- **Question Types:** Multiple choice, multiple select, drag-drop, case studies, hot areas

### Official Resources
- **[📖 DP-300 Official Exam Page](https://learn.microsoft.com/en-us/certifications/exams/dp-300/)** - Official exam registration and overview
- **[📖 DP-300 Learning Path](https://learn.microsoft.com/en-us/certifications/azure-database-administrator-associate/)** - Microsoft Learn official certification path
- **[📖 Exam Skills Outline](https://learn.microsoft.com/en-us/certifications/resources/study-guides/dp-300)** - Detailed skills measured document
- **[📖 Azure SQL Documentation Hub](https://learn.microsoft.com/en-us/azure/azure-sql/)** - Complete Azure SQL documentation portal

### Exam Domain Breakdown
1. **Plan and Implement Data Platform Resources** (20-25%)
2. **Implement a Secure Environment** (15-20%)
3. **Monitor, Configure, and Optimize Database Resources** (20-25%)
4. **Configure and Manage Automation of Tasks** (15-20%)
5. **Plan and Configure High Availability and Disaster Recovery** (20-25%)

---

## Database Deployment

### Azure SQL Deployment Options

#### Azure SQL Database
- **[📖 Azure SQL Database Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview)** - PaaS database service fundamentals
- **[📖 SQL Database Quickstart](https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart)** - Deploy your first SQL Database
- **[📖 Service Tiers and Compute Sizes](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-general-purpose-business-critical)** - General Purpose vs Business Critical
- **[📖 vCore Model](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-vcore)** - vCore-based purchasing model explained
- **[📖 DTU Model](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu)** - DTU-based purchasing model explained
- **[📖 Serverless Compute Tier](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview)** - Auto-scaling compute with auto-pause
- **[📖 Hyperscale Service Tier](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale)** - Scalable architecture for large databases (100TB+)
- **[📖 Elastic Pools](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview)** - Share resources across multiple databases
- **[📖 Elastic Pool Management](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-manage)** - Configure and manage elastic pools

#### Azure SQL Managed Instance
- **[📖 SQL Managed Instance Overview](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)** - Near 100% SQL Server compatibility
- **[📖 Managed Instance Deployment](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/instance-create-quickstart)** - Create your first managed instance
- **[📖 Instance Pools](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/instance-pools-overview)** - Cost-efficient deployment for small instances
- **[📖 VNet Configuration](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/connectivity-architecture-overview)** - Network architecture and connectivity
- **[📖 Service Tiers for Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/service-tiers-managed-instance-vcore)** - General Purpose vs Business Critical tiers
- **[📖 Management Operations](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/management-operations-overview)** - Long-running operations and monitoring

#### SQL Server on Azure VMs
- **[📖 SQL Server on Azure VMs Overview](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)** - IaaS SQL Server deployment
- **[📖 VM Deployment Guide](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/create-sql-vm-portal)** - Deploy SQL Server VM from Azure portal
- **[📖 VM Size Selection](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist)** - Performance best practices and sizing
- **[📖 Storage Configuration](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/storage-configuration)** - Configure optimal storage for SQL VMs
- **[📖 SQL IaaS Agent Extension](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-iaas-agent-extension-automate-management)** - Automated management features
- **[📖 Automated Backup for SQL VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/automated-backup)** - Configure automated backups

### Deployment Methods and Tools
- **[📖 Azure Portal Deployment](https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?tabs=azure-portal)** - Deploy using Azure portal
- **[📖 Azure CLI for SQL](https://learn.microsoft.com/en-us/cli/azure/sql)** - Command-line deployment and management
- **[📖 PowerShell Az.Sql Module](https://learn.microsoft.com/en-us/powershell/module/az.sql/)** - PowerShell automation for Azure SQL
- **[📖 ARM Templates for SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/arm-templates-content-guide)** - Infrastructure as Code with ARM
- **[📖 Bicep for Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-bicep-quickstart)** - Modern IaC with Bicep language
- **[📖 Terraform for Azure SQL](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)** - Third-party IaC deployment

### Migration and Hybrid Scenarios
- **[📖 Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview)** - Managed migration service overview
- **[📖 Data Migration Assistant](https://learn.microsoft.com/en-us/sql/dma/dma-overview)** - Assess and migrate on-premises databases
- **[📖 Azure SQL Migration Extension](https://learn.microsoft.com/en-us/azure/dms/migration-using-azure-data-studio)** - Migrate using Azure Data Studio
- **[📖 SQL Server to Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/migrate-to-database-from-sql-server)** - Database migration strategies
- **[📖 Azure Arc-enabled SQL Server](https://learn.microsoft.com/en-us/sql/sql-server/azure-arc/overview)** - Hybrid management with Azure Arc

---

## Security

### Authentication and Authorization

#### Azure Active Directory Integration
- **[📖 Azure AD Authentication](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-overview)** - Configure Azure AD for SQL authentication
- **[📖 Configure Azure AD Admin](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure)** - Set up Azure AD administrator
- **[📖 Managed Identity Support](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-azure-ad-user-assigned-managed-identity)** - Use managed identities for authentication
- **[📖 Multi-Factor Authentication](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-mfa-ssms-overview)** - MFA with SSMS and Azure AD

#### SQL Authentication and Access Control
- **[📖 SQL Authentication](https://learn.microsoft.com/en-us/azure/azure-sql/database/logins-create-manage)** - Manage logins and users
- **[📖 Contained Database Users](https://learn.microsoft.com/en-us/sql/relational-databases/security/contained-database-users-making-your-database-portable)** - Create users without server-level logins
- **[📖 Database Roles](https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles)** - Manage database-level permissions
- **[📖 Row-Level Security](https://learn.microsoft.com/en-us/sql/relational-databases/security/row-level-security)** - Implement row-level access control

#### Network Security
- **[📖 Firewall Rules](https://learn.microsoft.com/en-us/azure/azure-sql/database/firewall-configure)** - Configure server and database firewall rules
- **[📖 Virtual Network Rules](https://learn.microsoft.com/en-us/azure/azure-sql/database/vnet-service-endpoint-rule-overview)** - Secure with VNet service endpoints
- **[📖 Private Endpoint](https://learn.microsoft.com/en-us/azure/azure-sql/database/private-endpoint-overview)** - Private connectivity using Azure Private Link
- **[📖 Connection Policies](https://learn.microsoft.com/en-us/azure/azure-sql/database/connectivity-architecture)** - Understand Proxy vs Redirect connection modes

### Data Encryption

#### Transparent Data Encryption (TDE)
- **[📖 TDE Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview)** - Encryption at rest with TDE
- **[📖 TDE with Customer-Managed Keys](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-byok-overview)** - Bring Your Own Key (BYOK)
- **[📖 Configure TDE](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-byok-configure)** - Set up TDE with Azure Key Vault

#### Always Encrypted
- **[📖 Always Encrypted Overview](https://learn.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-database-engine)** - Client-side encryption for sensitive data
- **[📖 Always Encrypted with Secure Enclaves](https://learn.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-enclaves)** - Enhanced functionality with secure enclaves
- **[📖 Configure Always Encrypted](https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-azure-key-vault-configure)** - Setup with Azure Key Vault
- **[📖 Key Management for Always Encrypted](https://learn.microsoft.com/en-us/sql/relational-databases/security/encryption/overview-of-key-management-for-always-encrypted)** - Column encryption and master keys

#### Other Encryption Features
- **[📖 Dynamic Data Masking](https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview)** - Mask sensitive data from non-privileged users
- **[📖 Configure Data Masking](https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-configure-portal)** - Set up masking rules
- **[📖 Transport Layer Security](https://learn.microsoft.com/en-us/azure/azure-sql/database/connect-query-content)** - TLS encryption for data in transit

### Security Monitoring and Compliance

#### Microsoft Defender for SQL
- **[📖 Defender for SQL Overview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-sql-introduction)** - Advanced threat protection
- **[📖 Enable Defender for SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql)** - Configure advanced security features
- **[📖 Vulnerability Assessment](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-vulnerability-assessment)** - Discover and remediate vulnerabilities
- **[📖 Advanced Threat Protection](https://learn.microsoft.com/en-us/azure/azure-sql/database/threat-detection-overview)** - Detect anomalous activities

#### Auditing and Compliance
- **[📖 SQL Auditing](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview)** - Track database events and write audit logs
- **[📖 Configure Auditing](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-setup)** - Set up server and database auditing
- **[📖 Audit Log Destinations](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-write-to-storage)** - Write to Storage, Log Analytics, Event Hub
- **[📖 Ledger for SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/ledger-overview)** - Tamper-evident ledger capabilities
- **[📖 Information Protection](https://learn.microsoft.com/en-us/azure/azure-sql/database/data-discovery-and-classification-overview)** - Data discovery and classification

---

## Monitoring & Performance

### Azure Monitor Integration

#### Monitoring Fundamentals
- **[📖 Monitor Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/monitor-tune-overview)** - Comprehensive monitoring overview
- **[📖 Azure Monitor for SQL](https://learn.microsoft.com/en-us/azure/azure-monitor/insights/azure-sql)** - Centralized monitoring with Azure Monitor
- **[📖 Diagnostic Settings](https://learn.microsoft.com/en-us/azure/azure-sql/database/metrics-diagnostic-telemetry-logging-streaming-export-configure)** - Configure metrics and logs export
- **[📖 SQL Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/insights/sql-insights-overview)** - Advanced monitoring with SQL Insights

#### Metrics and Alerts
- **[📖 Database Metrics](https://learn.microsoft.com/en-us/azure/azure-sql/database/metrics-diagnostic-telemetry-logging-streaming-export-configure?tabs=azure-portal#metrics)** - Available performance metrics
- **[📖 Create Metric Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric)** - Set up threshold-based alerts
- **[📖 Resource Health](https://learn.microsoft.com/en-us/azure/service-health/resource-health-overview)** - Monitor database health status
- **[📖 Service Health Monitoring](https://learn.microsoft.com/en-us/azure/service-health/service-health-overview)** - Track Azure service incidents

### Query Performance Monitoring

#### Query Performance Insight
- **[📖 Query Performance Insight](https://learn.microsoft.com/en-us/azure/azure-sql/database/query-performance-insight-use)** - Identify top resource-consuming queries
- **[📖 Query Store](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store)** - Capture and analyze query execution history
- **[📖 Query Store Best Practices](https://learn.microsoft.com/en-us/sql/relational-databases/performance/best-practice-with-the-query-store)** - Configuration recommendations
- **[📖 Query Store Hints](https://learn.microsoft.com/en-us/sql/relational-databases/performance/query-store-hints)** - Force query plans using hints

#### Query Analysis Tools
- **[📖 Execution Plans](https://learn.microsoft.com/en-us/sql/relational-databases/performance/execution-plans)** - Analyze query execution plans
- **[📖 Live Query Statistics](https://learn.microsoft.com/en-us/sql/relational-databases/performance/live-query-statistics)** - Real-time query execution monitoring
- **[📖 SQL Server Profiler](https://learn.microsoft.com/en-us/sql/tools/sql-server-profiler/sql-server-profiler)** - Legacy trace and profiling tool
- **[📖 Extended Events](https://learn.microsoft.com/en-us/azure/azure-sql/database/xevent-db-diff-from-svr)** - Lightweight event tracing system
- **[📖 Database Watcher](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-watcher-overview)** - Real-time monitoring and analytics

### Dynamic Management Views (DMVs)

#### Essential DMVs
- **[📖 DMV Overview](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/system-dynamic-management-views)** - Dynamic management views and functions
- **[📖 sys.dm_db_resource_stats](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-resource-stats-azure-sql-database)** - Database resource consumption metrics
- **[📖 sys.dm_exec_requests](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-requests-transact-sql)** - Currently executing requests
- **[📖 sys.dm_exec_query_stats](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql)** - Aggregated query performance statistics
- **[📖 sys.dm_exec_sessions](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql)** - Active user connections and sessions

### Wait Statistics and Blocking
- **[📖 Wait Statistics](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-wait-stats-transact-sql)** - Identify performance bottlenecks with wait types
- **[📖 Blocking Monitoring](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-tran-locks-transact-sql)** - Track locks and blocking chains
- **[📖 Deadlock Detection](https://learn.microsoft.com/en-us/sql/relational-databases/sql-trace/deadlock-graph-event-class)** - Analyze and resolve deadlocks
- **[📖 Intelligent Query Processing](https://learn.microsoft.com/en-us/sql/relational-databases/performance/intelligent-query-processing)** - Automatic performance enhancements

---

## Optimization

### Index Management

#### Index Strategies
- **[📖 Index Architecture](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide)** - Comprehensive index design guide
- **[📖 Clustered Index Design](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described)** - Clustered vs nonclustered indexes
- **[📖 Columnstore Indexes](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview)** - High-performance analytics with columnstore
- **[📖 Index Maintenance](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/reorganize-and-rebuild-indexes)** - Rebuild and reorganize strategies
- **[📖 Online Index Operations](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/perform-index-operations-online)** - Minimize downtime during index maintenance

#### Automatic Tuning
- **[📖 Automatic Tuning](https://learn.microsoft.com/en-us/azure/azure-sql/database/automatic-tuning-overview)** - AI-driven performance tuning
- **[📖 Enable Automatic Tuning](https://learn.microsoft.com/en-us/azure/azure-sql/database/automatic-tuning-enable)** - Configure automatic index management
- **[📖 Automatic Plan Correction](https://learn.microsoft.com/en-us/sql/relational-databases/automatic-tuning/automatic-tuning)** - Fix plan regression automatically
- **[📖 Tuning Recommendations](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-advisor-find-recommendations-portal)** - Database Advisor recommendations

### Query Optimization

#### Query Tuning Techniques
- **[📖 Query Tuning](https://learn.microsoft.com/en-us/sql/relational-databases/performance/query-tuning)** - Query performance tuning guide
- **[📖 Parameter Sniffing](https://learn.microsoft.com/en-us/sql/relational-databases/query-processing-architecture-guide#parameter-sensitivity)** - Understand and handle parameter sniffing
- **[📖 Plan Guides](https://learn.microsoft.com/en-us/sql/relational-databases/performance/plan-guides)** - Force query plans without code changes
- **[📖 Statistics Management](https://learn.microsoft.com/en-us/sql/relational-databases/statistics/statistics)** - Optimize query optimizer statistics

#### Performance Features
- **[📖 In-Memory OLTP](https://learn.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios)** - Memory-optimized tables and indexes
- **[📖 Batch Mode Processing](https://learn.microsoft.com/en-us/sql/relational-databases/query-processing-architecture-guide#batch-mode-execution)** - Batch mode on rowstore
- **[📖 Adaptive Query Processing](https://learn.microsoft.com/en-us/sql/relational-databases/performance/adaptive-query-processing)** - Runtime query optimization
- **[📖 Memory Grant Feedback](https://learn.microsoft.com/en-us/sql/relational-databases/performance/intelligent-query-processing-memory-grant-feedback)** - Automatic memory grant adjustments

### Resource Governance and Scaling

#### Compute and Storage Scaling
- **[📖 Scale Resources](https://learn.microsoft.com/en-us/azure/azure-sql/database/scale-resources)** - Scale compute and storage dynamically
- **[📖 Resource Limits - vCore](https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-single-databases)** - vCore resource limits for single databases
- **[📖 Resource Limits - DTU](https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-dtu-single-databases)** - DTU resource limits for single databases
- **[📖 Elastic Pool Resource Limits](https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-elastic-pools)** - Elastic pool vCore limits

#### Read Scale-Out and Replicas
- **[📖 Read Scale-Out](https://learn.microsoft.com/en-us/azure/azure-sql/database/read-scale-out)** - Offload read workloads to secondary replicas
- **[📖 Application Intent](https://learn.microsoft.com/en-us/sql/relational-databases/native-client/features/sql-server-native-client-support-for-high-availability-disaster-recovery#ApplicationIntent)** - Route queries with ApplicationIntent connection parameter
- **[📖 Hyperscale Read Replicas](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale-replicas)** - Named replicas in Hyperscale tier

#### Resource Governor
- **[📖 Resource Governor](https://learn.microsoft.com/en-us/sql/relational-databases/resource-governor/resource-governor)** - Control resource consumption (SQL VM)
- **[📖 Workload Groups](https://learn.microsoft.com/en-us/sql/relational-databases/resource-governor/resource-governor-workload-group)** - Configure workload isolation
- **[📖 Connection Limits](https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-logical-server)** - Logical server connection limits

---

## High Availability & Disaster Recovery

### High Availability Architecture

#### Built-in High Availability
- **[📖 High Availability Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla)** - Azure SQL HA architecture and SLA
- **[📖 Business Critical Availability](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla#business-critical-service-tier-zone-redundant-availability)** - Always On availability groups in Business Critical
- **[📖 Zone Redundancy](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla#zone-redundant-availability)** - Deploy across availability zones
- **[📖 SLA Details](https://www.azure.com/support/legal/sla/azure-sql-database/)** - Service level agreements

#### Active Geo-Replication
- **[📖 Active Geo-Replication](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview)** - Asynchronous replication to multiple regions
- **[📖 Configure Geo-Replication](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-configure-portal)** - Set up readable secondary databases
- **[📖 Failover Process](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview#failover-process)** - Manual and forced failover procedures
- **[📖 Monitoring Replication Lag](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview#monitoring-geo-replication)** - Track replication performance

#### Auto-Failover Groups
- **[📖 Auto-Failover Groups](https://learn.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview)** - Automatic regional failover solution
- **[📖 Configure Failover Groups](https://learn.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-configure-sql-db)** - Setup and configuration guide
- **[📖 Failover Group DNS](https://learn.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview#using-read-write-listener-for-oltp-workload)** - Read-write and read-only listener endpoints
- **[📖 Failover Policies](https://learn.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-configure-sql-db?tabs=azure-portal#configure-failover-policy)** - Automatic vs manual failover policies

### SQL Server Always On (IaaS)
- **[📖 Always On Availability Groups](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server)** - High availability for SQL Server VMs
- **[📖 Configure Always On in Azure](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/availability-group-overview)** - Deploy availability groups on Azure VMs
- **[📖 Failover Cluster Instances](https://learn.microsoft.com/en-us/sql/sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server)** - FCI for SQL Server VMs
- **[📖 Distributed Availability Groups](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/distributed-availability-groups)** - AG across multiple clusters

### Backup and Restore

#### Automated Backups
- **[📖 Automated Backups](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview)** - Built-in backup service for Azure SQL
- **[📖 Backup Frequency and Retention](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview#backup-frequency)** - Full, differential, and log backup schedules
- **[📖 Short-term Retention](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview#backup-retention)** - Configure backup retention (1-35 days)
- **[📖 Long-term Retention (LTR)](https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-retention-overview)** - Keep backups for up to 10 years
- **[📖 Configure LTR](https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-backup-retention-configure)** - Set up long-term retention policies

#### Point-in-Time Restore (PITR)
- **[📖 Point-in-Time Restore](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#point-in-time-restore)** - Restore to any point within retention period
- **[📖 Perform PITR](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups)** - Step-by-step restore procedures
- **[📖 Restore Deleted Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#deleted-database-restore)** - Recover accidentally deleted databases
- **[📖 PITR Limitations](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#recovery-time)** - Recovery time and considerations

#### Geo-Restore
- **[📖 Geo-Restore](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#geo-restore)** - Restore from geo-redundant backups
- **[📖 Geo-Redundant Backups](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview#backup-storage-redundancy)** - Backup storage redundancy options (LRS, ZRS, GRS)
- **[📖 Configure Backup Storage](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-change-settings)** - Change backup storage redundancy

#### Copy and Export
- **[📖 Database Copy](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-copy)** - Create transactionally consistent copy
- **[📖 Export to BACPAC](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-export)** - Export schema and data to BACPAC file
- **[📖 Import from BACPAC](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-import)** - Import database from BACPAC
- **[📖 SqlPackage Utility](https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage)** - Command-line tool for import/export

### Disaster Recovery Planning
- **[📖 Business Continuity Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview)** - Complete BC/DR strategy guide
- **[📖 Recovery Time Objective (RTO)](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview#recovery-time-objective)** - RTO comparison across solutions
- **[📖 Recovery Point Objective (RPO)](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview#recovery-point-objective)** - RPO comparison across solutions
- **[📖 Disaster Recovery Drills](https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-drills)** - Test your DR plan

---

## Automation

### Infrastructure as Code (IaC)

#### ARM Templates
- **[📖 ARM Template Reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers)** - SQL Server ARM template schema
- **[📖 Deploy with ARM](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-portal)** - Deploy templates via portal, CLI, PowerShell
- **[📖 Template Best Practices](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices)** - ARM template design guidelines

#### Bicep
- **[📖 Bicep Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)** - Modern declarative IaC language
- **[📖 Bicep for SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-bicep-quickstart)** - Deploy SQL Database with Bicep
- **[📖 Bicep Modules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules)** - Reusable Bicep templates

### PowerShell Automation
- **[📖 Az.Sql Module](https://learn.microsoft.com/en-us/powershell/module/az.sql/)** - Complete PowerShell cmdlet reference
- **[📖 New-AzSqlDatabase](https://learn.microsoft.com/en-us/powershell/module/az.sql/new-azsqldatabase)** - Create SQL Database with PowerShell
- **[📖 Set-AzSqlDatabase](https://learn.microsoft.com/en-us/powershell/module/az.sql/set-azsqldatabase)** - Modify database properties
- **[📖 Get-AzSqlDatabaseActivity](https://learn.microsoft.com/en-us/powershell/module/az.sql/get-azsqldatabaseactivity)** - Monitor database operations
- **[📖 PowerShell Runbooks](https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types)** - Automate with Azure Automation

### Azure CLI Automation
- **[📖 az sql Reference](https://learn.microsoft.com/en-us/cli/azure/sql)** - Complete Azure CLI command reference
- **[📖 az sql db create](https://learn.microsoft.com/en-us/cli/azure/sql/db#az-sql-db-create)** - Create database via CLI
- **[📖 az sql db update](https://learn.microsoft.com/en-us/cli/azure/sql/db#az-sql-db-update)** - Update database configuration
- **[📖 az sql db list-usages](https://learn.microsoft.com/en-us/cli/azure/sql/db#az-sql-db-list-usages)** - Monitor resource usage

### Database Automation

#### Elastic Jobs
- **[📖 Elastic Jobs Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-jobs-overview)** - Automated T-SQL job execution across databases
- **[📖 Create Elastic Job Agent](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-jobs-tutorial)** - Setup and configuration tutorial
- **[📖 Job Scheduling](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-jobs-tsql-create-manage)** - Schedule jobs with T-SQL

#### Azure Automation
- **[📖 Azure Automation Overview](https://learn.microsoft.com/en-us/azure/automation/overview)** - Automation service for cloud and on-premises
- **[📖 Automation Runbooks](https://learn.microsoft.com/en-us/azure/automation/automation-runbook-execution)** - Execute PowerShell and Python scripts
- **[📖 Update Management](https://learn.microsoft.com/en-us/azure/automation/update-management/overview)** - Automate patching for SQL VMs
- **[📖 Azure Logic Apps for SQL](https://learn.microsoft.com/en-us/azure/connectors/connectors-create-api-sqlazure)** - Workflow automation with Logic Apps

#### Maintenance Plans and Jobs
- **[📖 SQL Server Agent Jobs](https://learn.microsoft.com/en-us/sql/ssms/agent/sql-server-agent)** - Scheduled job automation for SQL VMs and MI
- **[📖 Maintenance Plans](https://learn.microsoft.com/en-us/sql/relational-databases/maintenance-plans/maintenance-plans)** - Automated database maintenance tasks
- **[📖 Index Maintenance Jobs](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/reorganize-and-rebuild-indexes)** - Automate index rebuilds and reorgs

### CI/CD for Databases

#### Azure DevOps Integration
- **[📖 Azure DevOps for SQL](https://learn.microsoft.com/en-us/azure/devops/pipelines/targets/azure-sqldb)** - Deploy databases with Azure Pipelines
- **[📖 SQL Database Projects](https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-pipelines)** - Database projects in CI/CD pipelines
- **[📖 DACPAC Deployment](https://learn.microsoft.com/en-us/sql/relational-databases/data-tier-applications/data-tier-applications)** - Deploy schema changes with DACPAC

#### GitHub Actions
- **[📖 GitHub Actions for Azure SQL](https://github.com/Azure/sql-action)** - Deploy to Azure SQL with GitHub Actions
- **[📖 Azure SQL Deploy Action](https://github.com/marketplace/actions/azure-sql-deploy)** - Official GitHub marketplace action

---

## Cost Management

### Pricing Models and Optimization
- **[📖 Azure SQL Pricing](https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/single/)** - Official pricing page
- **[📖 vCore vs DTU Comparison](https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models)** - Choose the right purchasing model
- **[📖 Reserved Capacity](https://learn.microsoft.com/en-us/azure/azure-sql/database/reserved-capacity-overview)** - Save up to 80% with reserved instances
- **[📖 Cost Optimization](https://learn.microsoft.com/en-us/azure/azure-sql/database/cost-management)** - Best practices for cost reduction
- **[📖 Serverless Cost Benefits](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview#cost-considerations)** - Pay-per-use pricing model

### Resource Monitoring for Cost
- **[📖 Azure Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/quick-acm-cost-analysis)** - Track and analyze spending
- **[📖 Cost Alerts](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending)** - Set up budget alerts
- **[📖 Azure Advisor Cost Recommendations](https://learn.microsoft.com/en-us/azure/advisor/advisor-cost-recommendations)** - Get personalized cost optimization tips

---

## Additional Resources

### Tools and Utilities
- **[📖 Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/what-is-azure-data-studio)** - Modern cross-platform database tool
- **[📖 SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)** - Comprehensive SQL Server management
- **[📖 Azure Portal](https://portal.azure.com/)** - Web-based management interface
- **[📖 Azure Mobile App](https://azure.microsoft.com/en-us/get-started/azure-portal/mobile-app/)** - Manage Azure on the go

### Learning and Practice
- **[📖 Microsoft Learn - DP-300 Path](https://learn.microsoft.com/en-us/training/browse/?roles=database-administrator&products=azure-sql-database)** - Free training modules
- **[📖 Azure Free Account](https://azure.microsoft.com/en-us/free/)** - $200 credit for 30 days
- **[📖 DP-300 Sample Questions](https://learn.microsoft.com/en-us/certifications/resources/dp-300-sample-questions)** - Practice questions from Microsoft
- **[📖 Azure SQL Workshop](https://github.com/microsoft/sqlworkshops-azuresqlworkshop)** - Hands-on GitHub workshop

### Community and Support
- **[📖 Azure SQL Blog](https://techcommunity.microsoft.com/t5/azure-sql-blog/bg-p/AzureSQLBlog)** - Official product updates and tips
- **[📖 SQL Server Blog](https://cloudblogs.microsoft.com/sqlserver/)** - SQL Server team blog
- **[📖 Microsoft Q&A](https://learn.microsoft.com/en-us/answers/topics/azure-sql-database.html)** - Community support forum
- **[📖 Azure Updates](https://azure.microsoft.com/en-us/updates/?category=databases)** - Latest Azure SQL features

### Best Practices Guides
- **[📖 Azure SQL Best Practices](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-advisor-find-recommendations-portal)** - Comprehensive best practices
- **[📖 Performance Best Practices](https://learn.microsoft.com/en-us/azure/azure-sql/database/performance-guidance)** - Optimize performance
- **[📖 Security Best Practices](https://learn.microsoft.com/en-us/azure/azure-sql/database/security-best-practice)** - Secure your databases
- **[📖 Connectivity Best Practices](https://learn.microsoft.com/en-us/azure/azure-sql/database/troubleshoot-common-connectivity-issues)** - Connection troubleshooting

---

## Quick Reference Commands

### Azure CLI Quick Reference
```bash
# Create SQL Server
az sql server create --name myserver --resource-group myRG --location eastus --admin-user myadmin --admin-password MyP@ssw0rd

# Create SQL Database
az sql db create --resource-group myRG --server myserver --name mydb --service-objective S0

# Scale database
az sql db update --resource-group myRG --server myserver --name mydb --service-objective S2

# Configure geo-replication
az sql db replica create --resource-group myRG --server myserver --name mydb --partner-server mysecondaryserver --partner-resource-group mySecondaryRG

# Create failover group
az sql failover-group create --name myfailovergroup --resource-group myRG --server myserver --partner-server mysecondaryserver --failover-policy Automatic --grace-period 1

# PITR restore
az sql db restore --dest-name mydb-restored --resource-group myRG --server myserver --name mydb --time "2024-01-15T10:30:00Z"
```

### PowerShell Quick Reference
```powershell
# Create SQL Server
New-AzSqlServer -ResourceGroupName "myRG" -ServerName "myserver" -Location "East US" -SqlAdministratorCredentials (Get-Credential)

# Create SQL Database
New-AzSqlDatabase -ResourceGroupName "myRG" -ServerName "myserver" -DatabaseName "mydb" -Edition "Standard" -RequestedServiceObjectiveName "S2"

# Scale database
Set-AzSqlDatabase -ResourceGroupName "myRG" -ServerName "myserver" -DatabaseName "mydb" -Edition "Premium" -RequestedServiceObjectiveName "P2"

# Configure geo-replication
New-AzSqlDatabaseSecondary -ResourceGroupName "myRG" -ServerName "myserver" -DatabaseName "mydb" -PartnerResourceGroupName "mySecondaryRG" -PartnerServerName "mysecondaryserver"

# Create failover group
New-AzSqlDatabaseFailoverGroup -ResourceGroupName "myRG" -ServerName "myserver" -PartnerServerName "mysecondaryserver" -FailoverGroupName "myfailovergroup" -FailoverPolicy Automatic -GracePeriodWithDataLossHours 1

# PITR restore
Restore-AzSqlDatabase -FromPointInTimeBackup -PointInTime "2024-01-15T10:30:00Z" -ResourceGroupName "myRG" -ServerName "myserver" -TargetDatabaseName "mydb-restored" -ResourceId /subscriptions/{SubID}/resourceGroups/myRG/providers/Microsoft.Sql/servers/myserver/databases/mydb
```

### T-SQL Quick Reference
```sql
-- Check database size and usage
SELECT
    database_name,
    SUM(size_gb) as total_size_gb,
    SUM(allocated_gb) as allocated_gb
FROM sys.dm_db_resource_stats;

-- View current connections
SELECT
    session_id,
    login_name,
    status,
    database_name
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-- Check running queries
SELECT
    r.session_id,
    r.status,
    r.command,
    r.wait_type,
    r.total_elapsed_time,
    t.text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t;

-- Create database user from Azure AD
CREATE USER [user@domain.com] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [user@domain.com];

-- Enable Query Store
ALTER DATABASE [mydb] SET QUERY_STORE = ON;
ALTER DATABASE [mydb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);

-- Configure geo-replication (primary)
ALTER DATABASE [mydb] ADD SECONDARY ON SERVER [mysecondaryserver];

-- Failover to secondary
ALTER DATABASE [mydb] FAILOVER;
```

---

## Exam Tips and Strategy

### Key Focus Areas
1. **Deployment Models**: Understand when to use SQL Database vs Managed Instance vs SQL VM
2. **Security Layers**: Know all security features (TDE, Always Encrypted, DDM, firewall, AAD)
3. **HA/DR Solutions**: Master geo-replication, failover groups, PITR, and Always On
4. **Monitoring Tools**: Query Performance Insight, Query Store, Extended Events, DMVs
5. **Performance Tuning**: Indexes, automatic tuning, query optimization, resource scaling
6. **Backup/Restore**: Understand PITR, LTR, geo-restore, and retention policies
7. **Automation**: Know PowerShell, CLI, ARM/Bicep, Elastic Jobs

### Common Exam Scenarios
- Choosing the right deployment option based on requirements
- Implementing security for compliance requirements
- Designing HA/DR solutions with RTO/RPO requirements
- Troubleshooting performance issues using monitoring tools
- Automating maintenance and deployment tasks
- Configuring backup retention and performing restores
- Migrating on-premises databases to Azure
- Optimizing costs while meeting performance requirements

### Study Approach
1. Complete Microsoft Learn DP-300 learning path
2. Get hands-on experience with all deployment options
3. Practice backup/restore and failover scenarios
4. Learn to use monitoring and troubleshooting tools
5. Master PowerShell and CLI commands
6. Understand pricing models and cost optimization
7. Review official documentation linked in this fact sheet
8. Take practice exams to identify knowledge gaps

---

**Document Statistics:**
- **Total Sections:** 8 major domains
- **Embedded Links:** 120 documentation links
- **Lines:** 700+ comprehensive coverage
- **Last Updated:** 2025-10-13

**Good luck with your DP-300 certification exam!**
