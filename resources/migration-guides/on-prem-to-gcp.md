# On-Premises to Google Cloud Migration Guide

## Overview

Google Cloud provides a structured migration framework organized into four phases - Assess, Plan, Deploy, and Optimize. This guide covers GCP migration tools, networking, and best practices for moving on-premises workloads to Google Cloud Platform.

---

## Google Cloud Migration Framework

### Phase 1 - Assess

- Build a comprehensive inventory of existing workloads
- Catalog applications, databases, and infrastructure components
- Identify dependencies between systems
- Evaluate total cost of ownership (TCO) for cloud migration
- Determine migration complexity and risk for each workload
- Documentation: https://cloud.google.com/architecture/migration-to-gcp-getting-started

### Phase 2 - Plan

- Choose the migration strategy for each workload:
  - **Rehost (Lift and Shift)**: move as-is to Compute Engine VMs
  - **Replatform**: make minor adjustments (e.g., move to managed databases)
  - **Refactor**: redesign for cloud-native services
  - **Replace**: switch to SaaS alternatives
  - **Retire**: decommission unused applications
- Define migration waves and prioritization
- Design target architecture on GCP
- Plan networking, identity, and security foundations
- Documentation: https://cloud.google.com/architecture/migration-to-gcp-building-your-foundation

### Phase 3 - Deploy

- Set up the GCP foundation (projects, networking, IAM)
- Execute migration using appropriate tools
- Validate migrated workloads
- Perform cutover and decommission source systems
- Documentation: https://cloud.google.com/architecture/migration-to-gcp-transferring-your-large-datasets

### Phase 4 - Optimize

- Right-size compute instances
- Implement committed use discounts (CUDs)
- Optimize storage tiers and lifecycle policies
- Implement auto-scaling and managed instance groups
- Continuously improve cost efficiency and performance
- Documentation: https://cloud.google.com/architecture/migration-to-gcp-optimizing-your-environment

---

## Discovery and Assessment Tools

### Migration Center

- Unified platform for discovering, assessing, and planning migrations
- Collects data from on-premises infrastructure
- Generates TCO reports and right-sizing recommendations
- Provides migration complexity scores
- Documentation: https://cloud.google.com/migration-center/docs/migration-center-overview

### StratoZone (Assessment Tool)

- Collects detailed infrastructure data via discovery agents
- Generates fit assessments for Google Cloud
- Provides cost projections and right-sizing recommendations
- Supports VMware, Hyper-V, and physical servers

### Assessment Checklist

- [ ] Deploy discovery agents or appliances on-premises
- [ ] Collect performance data for minimum 2-4 weeks
- [ ] Map application dependencies and data flows
- [ ] Identify compliance and data residency requirements
- [ ] Document licensing requirements (especially Oracle, SQL Server, SAP)
- [ ] Calculate TCO comparison (on-premises vs GCP)
- [ ] Classify workloads by migration strategy
- [ ] Prioritize migration waves based on complexity and business value

---

## GCP Foundation - Resource Hierarchy and Landing Zone

### Resource Hierarchy

- **Organization**: root node tied to Google Workspace or Cloud Identity domain
- **Folders**: group projects by department, team, or environment
- **Projects**: fundamental unit for resource management and billing
- **Resources**: compute instances, storage buckets, databases, etc.
- Documentation: https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy

### Organization Setup

- Create a Google Cloud Organization linked to your domain
- Configure Cloud Identity for user management
- Set up organizational policies to enforce compliance
- Enable audit logging at the organization level

### Recommended Project Structure

```
Organization
├── Shared Services (folder)
│   ├── networking-hub (project)
│   ├── security-logging (project)
│   └── shared-images (project)
├── Production (folder)
│   ├── app-a-prod (project)
│   └── app-b-prod (project)
├── Non-Production (folder)
│   ├── app-a-dev (project)
│   └── app-b-staging (project)
└── Sandbox (folder)
    └── developer-sandbox (project)
```

### IAM Best Practices

- Use Google Groups for role assignment, not individual users
- Follow the principle of least privilege
- Use custom roles when predefined roles are too broad
- Enable Organization Policy constraints for guardrails
- Set up VPC Service Controls for sensitive data protection
- Documentation: https://cloud.google.com/iam/docs/overview

### Terraform Landing Zone

- Use the Cloud Foundation Toolkit for standardized Terraform modules
- Modules available for project creation, networking, IAM, and logging
- Documentation: https://cloud.google.com/docs/terraform/blueprints/terraform-blueprint-factory

---

## Network Connectivity

### Cloud Interconnect

- **Dedicated Interconnect**: direct physical connection to Google's network
  - 10 Gbps or 100 Gbps circuits
  - Available at Google colocation facilities
  - Lowest latency and highest bandwidth
- **Partner Interconnect**: connect through a supported service provider
  - 50 Mbps to 50 Gbps (varies by partner)
  - Available in more locations than Dedicated Interconnect
  - Faster setup than Dedicated Interconnect
- Documentation: https://cloud.google.com/network-connectivity/docs/interconnect/concepts/overview

### Cloud VPN

- **HA VPN**: high-availability VPN with 99.99% SLA
  - Two tunnels for redundancy
  - Supports BGP for dynamic routing
- **Classic VPN**: single tunnel, 99.9% SLA (being deprecated)
- Use as primary connection for smaller workloads or as backup for Interconnect
- Documentation: https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview

### Network Connectivity Center

- Central hub for managing hybrid and multi-cloud connectivity
- Connects on-premises networks, VPCs, and other clouds
- Supports hub-and-spoke topology
- Documentation: https://cloud.google.com/network-connectivity/docs/network-connectivity-center/concepts/overview

### Shared VPC

- Central networking model for multi-project environments
- Host project owns the VPC network
- Service projects use shared subnets
- Centralized network administration and firewall rules
- Documentation: https://cloud.google.com/vpc/docs/shared-vpc

### Network Planning Checklist

- [ ] Design IP address ranges (avoid overlap with on-premises)
- [ ] Choose Shared VPC or standalone VPC per project
- [ ] Order Cloud Interconnect circuits if needed (lead time varies)
- [ ] Set up HA VPN as primary or backup connectivity
- [ ] Configure Cloud DNS for hybrid name resolution
- [ ] Set up Cloud NAT for outbound internet access
- [ ] Configure firewall rules and hierarchical firewall policies
- [ ] Enable VPC Flow Logs for network monitoring

---

## Migration Tools and Services

### Migrate to Virtual Machines

- Migrate VMs from VMware, AWS, Azure, or physical servers to Compute Engine
- Continuous replication with minimal impact on source workloads
- Non-disruptive test clones for validation
- Supports Windows and Linux operating systems
- Workflow:
  1. Deploy Migrate Connector in source environment
  2. Add source VMs to a migration wave
  3. Continuous replication runs in the background
  4. Create test clones to validate in GCP
  5. Perform cutover when ready
  6. Clean up source resources
- Documentation: https://cloud.google.com/migrate/virtual-machines/docs/5.0/concepts/overview

### Database Migration Service

- Fully managed migration service for databases
- Supports MySQL, PostgreSQL, SQL Server, Oracle, and AlloyDB migrations
- Continuous replication for minimal downtime migrations
- Targets: Cloud SQL, AlloyDB, Cloud Spanner
- Documentation: https://cloud.google.com/database-migration/docs/overview

### Transfer Appliance (Large Data Transfers)

- Physical appliance for transferring large datasets to Google Cloud
- Available in 100 TB and 480 TB capacities
- Ship data to Google for upload to Cloud Storage
- Data encrypted with AES-256
- Use when network transfer would take more than one week
- Documentation: https://cloud.google.com/transfer-appliance/docs/4.0/overview

### Storage Transfer Service

- Transfer data from other clouds (AWS S3, Azure Blob), HTTP/HTTPS sources, or on-premises
- Scheduled and recurring transfers
- Bandwidth management to minimize impact on production
- Documentation: https://cloud.google.com/storage-transfer/docs/overview

### Transfer Service for On Premises Data

- High-performance data transfer from on-premises to Cloud Storage
- Requires on-premises agent installation
- Supports file system sources (NFS, POSIX)
- Documentation: https://cloud.google.com/storage-transfer/docs/on-prem-overview

---

## Anthos for Hybrid Deployments

### Overview

- Platform for managing applications across on-premises, GCP, and other clouds
- Consistent Kubernetes-based application platform
- Centralized policy and configuration management
- Documentation: https://cloud.google.com/anthos/docs/concepts/overview

### Key Components

- **Anthos on-premises (GKE Enterprise)**: run GKE clusters on VMware or bare metal
- **Anthos Config Management**: GitOps-based configuration management
- **Anthos Service Mesh**: managed Istio service mesh
- **Anthos Connect Gateway**: secure access to on-premises clusters from GCP console

### When to Use Anthos

- Hybrid cloud strategy where some workloads stay on-premises
- Gradual migration with consistent platform across environments
- Multi-cloud application deployment requirements
- Need for centralized management of Kubernetes clusters

---

## Validation and Cutover

### Pre-Cutover Checklist

- [ ] All test migrations (clones) validated successfully
- [ ] Application functionality verified in GCP
- [ ] Performance benchmarks meet requirements
- [ ] Security controls validated (firewall rules, IAM, VPC Service Controls)
- [ ] Backup and disaster recovery tested
- [ ] Monitoring configured (Cloud Monitoring, alerting policies)
- [ ] DNS TTLs reduced before cutover
- [ ] Rollback plan documented and tested
- [ ] Stakeholders notified of cutover window

### Cutover Steps

1. Freeze changes on source environment
2. Perform final data synchronization
3. Validate data consistency between source and target
4. Update DNS records to point to GCP resources
5. Run smoke tests and validation scripts
6. Monitor application health and performance
7. Keep source environment for rollback (minimum 48 hours)
8. Decommission source after successful validation

### Post-Migration Optimization Checklist

- [ ] Review Recommender for right-sizing suggestions
- [ ] Implement committed use discounts for stable workloads
- [ ] Configure auto-scaling for variable workloads
- [ ] Optimize storage classes (Standard, Nearline, Coldline, Archive)
- [ ] Set up Cloud Billing budgets and alerts
- [ ] Enable sustained use discounts (automatic for Compute Engine)
- [ ] Review and optimize network egress costs
- [ ] Document updated architecture and operations runbooks

---

## Key Google Cloud Documentation Links

| Resource | URL |
|----------|-----|
| Migration to Google Cloud | https://cloud.google.com/architecture/migration-to-gcp-getting-started |
| Migration Center | https://cloud.google.com/migration-center/docs/migration-center-overview |
| Migrate to VMs | https://cloud.google.com/migrate/virtual-machines/docs/5.0/concepts/overview |
| Database Migration Service | https://cloud.google.com/database-migration/docs/overview |
| Cloud Interconnect | https://cloud.google.com/network-connectivity/docs/interconnect/concepts/overview |
| Cloud VPN | https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview |
| Cloud Foundation Toolkit | https://cloud.google.com/docs/terraform/blueprints/terraform-blueprint-factory |

---

## Migration Anti-Patterns to Avoid

- Migrating without establishing a proper resource hierarchy first
- Using default VPC networks instead of designing a proper network topology
- Granting Owner roles broadly instead of using least-privilege IAM
- Not enabling audit logging before migration begins
- Skipping test migrations and going directly to production cutover
- Ignoring sustained use and committed use discounts after migration
- Not planning for hybrid DNS resolution between on-premises and GCP
- Treating migration as a one-time event instead of iterating and optimizing
