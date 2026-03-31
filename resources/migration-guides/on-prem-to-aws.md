# On-Premises to AWS Migration Guide

## Overview

Migrating from on-premises infrastructure to AWS requires a structured approach covering assessment, planning, migration execution, and optimization. This guide covers the AWS migration methodology, key tools, and best practices for a successful migration.

---

## AWS Migration Methodology - The 7 Rs

### 1. Rehost (Lift and Shift)

- Move applications as-is to AWS without code changes
- Fastest migration path with lowest initial effort
- Use AWS Application Migration Service (AWS MGN) for automated lift-and-shift
- Best for applications that need to move quickly or have limited remaining lifespan
- Can optimize after migration (re-platform or refactor later)

### 2. Replatform (Lift, Tinker, and Shift)

- Make targeted optimizations during migration without changing core architecture
- Examples: move to managed database (RDS), switch to Elastic Beanstalk
- Moderate effort with meaningful operational benefits
- Common replatforming targets:
  - Self-managed databases to Amazon RDS or Aurora
  - Application servers to Elastic Beanstalk
  - Message queues to Amazon SQS or Amazon MQ

### 3. Repurchase (Drop and Shop)

- Replace existing application with a SaaS or marketplace equivalent
- Examples: CRM to Salesforce, email to Amazon WorkMail, HR system to Workday
- Eliminates infrastructure management entirely
- Consider licensing costs, data migration, and user retraining

### 4. Refactor (Re-architect)

- Redesign application to be cloud-native
- Highest effort but greatest long-term benefit
- Leverage serverless, containers, managed services
- Best for applications with strong business value that need scalability
- Common refactoring patterns:
  - Monolith to microservices
  - Batch processing to event-driven architecture
  - Traditional databases to purpose-built databases

### 5. Retire

- Identify and decommission applications no longer needed
- Typically 10-20% of an application portfolio can be retired
- Reduces migration scope and operational costs
- Validate with stakeholders before decommissioning

### 6. Retain (Revisit)

- Keep applications on-premises for now
- Reasons: recent upgrades, compliance requirements, end-of-life planned
- Plan to revisit during future migration waves
- May require hybrid connectivity (Direct Connect or VPN)

### 7. Relocate (Hypervisor-Level Lift and Shift)

- Move VMware-based workloads to VMware Cloud on AWS
- No need to change OS, applications, or operations
- Preserves existing VMware investments and tooling
- Fast migration with minimal disruption

---

## Phase 1 - Discovery and Assessment

### AWS Application Discovery Service

- Agentless discovery: deploys OVA in VMware vCenter, collects VM metadata
- Agent-based discovery: installs on each server, collects detailed performance data
- Discovers server dependencies and communication patterns
- Data stored in AWS Migration Hub
- Documentation: https://docs.aws.amazon.com/application-discovery/latest/userguide/what-is-apds.html

### AWS Migration Evaluator (formerly TSO Logic)

- Builds a business case for migration
- Analyzes on-premises inventory and utilization
- Provides right-sizing recommendations for AWS
- Generates projected cost comparison (on-prem vs AWS)
- Free service - request an assessment through your AWS account team
- Documentation: https://docs.aws.amazon.com/migrationevaluator/latest/userguide/what-is-me.html

### AWS Migration Hub

- Central location to track migration progress across AWS tools
- Aggregates data from Application Discovery Service, MGN, and DMS
- Provides migration status dashboards
- Strategy recommendations based on discovered workloads
- Documentation: https://docs.aws.amazon.com/migrationhub/latest/ug/whatishub.html

### Discovery Checklist

- [ ] Inventory all servers, databases, and applications
- [ ] Map application dependencies and data flows
- [ ] Document network topology and firewall rules
- [ ] Identify compliance and regulatory requirements
- [ ] Assess current licensing (Windows, Oracle, SQL Server)
- [ ] Measure baseline performance metrics (CPU, memory, IOPS, network)
- [ ] Identify data volumes and change rates
- [ ] Document current backup and disaster recovery procedures

---

## Phase 2 - Planning and Landing Zone

### AWS Control Tower

- Automates multi-account setup with best practices
- Creates organizational units (OUs) for security, sandbox, production
- Deploys guardrails (preventive and detective)
- Integrates with AWS SSO for centralized identity management
- Documentation: https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html

### AWS Organizations

- Centralized management of multiple AWS accounts
- Service Control Policies (SCPs) for permission boundaries
- Consolidated billing across all accounts
- Recommended account structure:
  - Management account (billing and governance only)
  - Security account (GuardDuty, Security Hub, CloudTrail)
  - Shared services account (Active Directory, CI/CD)
  - Network account (Transit Gateway, Direct Connect)
  - Workload accounts (dev, staging, production per application)
- Documentation: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html

### AWS Service Catalog

- Create approved product portfolios for self-service provisioning
- Enforce standards through CloudFormation templates
- Control which services and configurations teams can deploy
- Documentation: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/introduction.html

---

## Phase 3 - Network Connectivity

### AWS Direct Connect

- Dedicated private network connection from on-premises to AWS
- Consistent network performance (1 Gbps, 10 Gbps, or 100 Gbps)
- Lower data transfer costs compared to internet
- Lead time: 2-4 weeks for hosted connections, longer for dedicated
- Use Direct Connect Gateway for multi-region connectivity
- Documentation: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html

### AWS Site-to-Site VPN

- Encrypted IPsec tunnel over the internet
- Quick to set up (hours vs weeks for Direct Connect)
- Use as primary connection or as backup for Direct Connect
- Supports BGP for dynamic routing
- AWS VPN CloudHub for hub-and-spoke connectivity
- Documentation: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html

### AWS Transit Gateway

- Central hub connecting VPCs, VPNs, and Direct Connect
- Simplifies network architecture at scale
- Supports inter-region peering
- Route tables for network segmentation
- Documentation: https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html

### Network Planning Checklist

- [ ] Determine bandwidth requirements between on-premises and AWS
- [ ] Order Direct Connect (if needed) early - long lead times
- [ ] Set up Site-to-Site VPN as initial or backup connectivity
- [ ] Plan IP address ranges to avoid conflicts (CIDR blocks)
- [ ] Configure DNS resolution (Route 53 Resolver for hybrid DNS)
- [ ] Set up Transit Gateway if connecting multiple VPCs
- [ ] Test failover between Direct Connect and VPN

---

## Phase 4 - Migration Execution

### AWS Application Migration Service (AWS MGN)

- Primary service for lift-and-shift server migration
- Continuous block-level replication from source to AWS
- Supports Windows and Linux servers
- Non-disruptive testing before cutover
- Automated machine conversion (drivers, networking, boot)
- Workflow:
  1. Install replication agent on source servers
  2. Continuous replication begins automatically
  3. Launch test instances for validation
  4. Perform cutover when ready
  5. Finalize and decommission source servers
- Documentation: https://docs.aws.amazon.com/mgn/latest/ug/what-is-application-migration-service.html

### AWS Database Migration Service (DMS)

- Migrate databases to AWS with minimal downtime
- Supports homogeneous and heterogeneous migrations
- Continuous replication keeps source and target in sync
- Supported sources: Oracle, SQL Server, MySQL, PostgreSQL, MongoDB, and more
- Supported targets: RDS, Aurora, Redshift, DynamoDB, S3
- Documentation: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html

### AWS Schema Conversion Tool (SCT)

- Converts database schemas between different engines
- Identifies conversion issues and provides remediation guidance
- Supports stored procedures, functions, triggers, and views
- Use with DMS for heterogeneous database migrations
- Documentation: https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html

### AWS DataSync

- Automated data transfer for file systems and object storage
- Transfers data to S3, EFS, or FSx
- Built-in data integrity verification
- Bandwidth throttling to avoid impact on production
- Documentation: https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html

### AWS Snow Family (Large Data Transfers)

- Snowcone: 8-14 TB, portable edge computing
- Snowball Edge: 80 TB storage, optional compute
- Snowmobile: up to 100 PB (exabyte-scale)
- Use when network transfer would take weeks or months
- Documentation: https://docs.aws.amazon.com/snowball/latest/developer-guide/whatissnowball.html

---

## Phase 5 - Validation and Cutover

### Pre-Cutover Checklist

- [ ] All applications tested in AWS environment
- [ ] Performance benchmarks meet or exceed on-premises baselines
- [ ] Security controls validated (security groups, NACLs, IAM policies)
- [ ] Backup and disaster recovery procedures tested
- [ ] Monitoring and alerting configured (CloudWatch, SNS)
- [ ] DNS TTLs lowered in advance of cutover
- [ ] Rollback procedures documented and tested
- [ ] Stakeholders notified of cutover window
- [ ] Change management approvals obtained

### Cutover Steps

1. Freeze changes on source environment
2. Perform final data synchronization
3. Validate data consistency between source and target
4. Update DNS records to point to AWS resources
5. Run smoke tests against AWS environment
6. Monitor application performance and errors
7. Keep source environment available for rollback (minimum 48 hours)
8. Decommission source environment after validation period

### Post-Migration Checklist

- [ ] Verify all applications are functioning correctly
- [ ] Confirm monitoring alerts are triggering properly
- [ ] Validate backup schedules are running
- [ ] Review and right-size instances (AWS Compute Optimizer)
- [ ] Enable AWS Cost Explorer and set up budgets
- [ ] Document updated architecture and runbooks
- [ ] Conduct post-migration review and lessons learned
- [ ] Plan optimization phase (Reserved Instances, Savings Plans)

---

## Key AWS Documentation Links

| Resource | URL |
|----------|-----|
| AWS Migration Hub | https://docs.aws.amazon.com/migrationhub/latest/ug/whatishub.html |
| AWS MGN | https://docs.aws.amazon.com/mgn/latest/ug/what-is-application-migration-service.html |
| AWS DMS | https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html |
| AWS SCT | https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html |
| Control Tower | https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html |
| Direct Connect | https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html |
| AWS Prescriptive Guidance | https://docs.aws.amazon.com/prescriptive-guidance/latest/migration-guide/welcome.html |

---

## Migration Anti-Patterns to Avoid

- Migrating everything at once instead of in waves
- Skipping the discovery and assessment phase
- Not testing rollback procedures before cutover
- Ignoring licensing implications (bring-your-own-license vs included)
- Underestimating network bandwidth requirements
- Not involving security teams early in the planning process
- Treating migration as only an infrastructure project (train your teams)
- Skipping the optimization phase after migration completes
