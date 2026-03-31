# Databricks Certified Lakehouse Platform Administrator

## Exam Overview

The Databricks Certified Lakehouse Platform Administrator certification validates the ability to administer and manage the Databricks Lakehouse Platform. This certification covers workspace administration, identity and access management, data management, cluster and warehouse configuration, and security best practices.

**Exam Details:**
- **Exam Code:** Databricks Certified Lakehouse Platform Administrator
- **Duration:** 90 minutes
- **Number of Questions:** 45 multiple-choice questions
- **Passing Score:** 70% (approximately 32 correct answers)
- **Cost:** $200 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (6+ months Databricks administration experience recommended)

## Exam Domains

### Domain 1: Workspace Administration (30%)
- Configure and manage Databricks workspaces
- Manage workspace settings and features
- Implement workspace-level governance
- Manage workspace objects and permissions

**Key Concepts:**
- Workspace deployment and configuration
- Account-level vs workspace-level administration
- Workspace settings (features, defaults, quotas)
- Notebook and repo management
- Secret management (Databricks secrets, secret scopes)
- Workspace object permissions
- Databricks CLI and REST API for administration
- Terraform provider for Databricks
- Workspace monitoring and audit logs
- Cost management and budgets

### Domain 2: Identity and Access (25%)
- Configure identity providers and SSO
- Manage users, groups, and service principals
- Implement role-based access control
- Manage authentication and authorization

**Key Concepts:**
- Identity federation with cloud identity providers
- SCIM provisioning for user/group sync
- Single Sign-On (SSO) configuration (SAML, OIDC)
- Service principals for automation
- Personal access tokens and OAuth
- Account-level groups vs workspace-level groups
- Workspace assignment for users and groups
- Entitlements (workspace access, cluster creation, SQL access)
- Admin roles (account admin, workspace admin, metastore admin)

### Domain 3: Data Management (20%)
- Administer Unity Catalog
- Manage data access and permissions
- Configure external data sources
- Implement data lifecycle management

**Key Concepts:**
- Unity Catalog metastore setup and configuration
- Catalog and schema management
- Managed vs external tables and volumes
- Storage credentials and external locations
- GRANT and REVOKE administration
- Data lineage configuration
- Delta Sharing for data sharing
- System tables for monitoring and auditing
- Catalog federation
- Information schema queries

### Domain 4: Cluster and Warehouse Management (15%)
- Configure and manage compute resources
- Implement cluster policies
- Manage SQL warehouses
- Optimize compute costs

**Key Concepts:**
- All-purpose clusters vs job clusters
- Cluster policies for governance and cost control
- Cluster pool configuration for faster startup
- Autoscaling configuration and behavior
- Spot instance and preemptible VM strategies
- SQL warehouse types (classic, pro, serverless)
- SQL warehouse sizing and scaling
- Serverless compute configuration
- Runtime version management
- Init scripts and cluster libraries

### Domain 5: Security (10%)
- Implement network security
- Configure data encryption
- Manage compliance requirements
- Implement security best practices

**Key Concepts:**
- VPC/VNet peering and private connectivity
- Private Link and private endpoints
- Network security groups and firewall rules
- IP access lists
- Customer-managed keys (CMK) for encryption
- Encryption at rest and in transit
- Compliance certifications (SOC 2, HIPAA, FedRAMP)
- Audit log configuration and analysis
- Secure cluster connectivity (no public IPs)
- Data exfiltration prevention

## Key Concepts to Master

### Unity Catalog Administration
- Metastore-workspace binding
- Three-level namespace management
- Permission inheritance model
- Storage credential lifecycle
- External location configuration
- System tables for auditing

### Compute Governance
- Cluster policy design and enforcement
- Cost control through policies and quotas
- Resource allocation strategies
- Serverless compute benefits and configuration
- Pool management for startup optimization

### Security Architecture
- Network isolation patterns
- Data encryption layers
- Identity federation design
- Audit logging and compliance
- Secret management best practices

## Study Approach

### Phase 1: Foundation (Week 1-2)
1. Review Databricks workspace architecture
2. Learn identity and access management concepts
3. Understand Unity Catalog administration model
4. Study basic cluster configuration

### Phase 2: Core Skills (Week 3-4)
1. Practice workspace administration tasks
2. Configure identity providers and SCIM
3. Set up Unity Catalog with proper permissions
4. Design cluster policies and SQL warehouses

### Phase 3: Exam Prep (Week 5-6)
1. Take practice exams and review incorrect answers
2. Focus on workspace admin and identity (55% of exam)
3. Review security and network configuration
4. Practice scenario-based administration questions

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - Platform administration learning path
- **[Exam Guide](https://www.databricks.com/learn/certification/lakehouse-platform-administrator)** - Official exam page
- **[Administration Guide](https://docs.databricks.com/en/admin/index.html)** - Admin documentation
- **[Unity Catalog Documentation](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Unity Catalog guide
- **[Security Guide](https://docs.databricks.com/en/security/index.html)** - Security best practices

## Tips for Success

1. **Workspace admin is the largest domain** - 30% covers workspace configuration
2. **Identity management is critical** - SCIM, SSO, and service principals are key topics
3. **Unity Catalog administration** - Not just using UC, but administering it
4. **Cluster policies** - Know how to create and enforce governance
5. **Security layers** - Understand network, identity, data, and audit security
6. **Know the admin console** - Understand what can be configured and where
7. **Cloud provider differences** - Be aware of AWS/Azure/GCP differences
8. **Cost management** - Cluster policies, serverless, and monitoring costs
9. **API and CLI** - Know Databricks CLI and REST API for automation
10. **Scenario-based thinking** - Questions often present real admin challenges

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule with checkboxes |
| [scenarios.md](scenarios.md) | Exam-style scenarios with solutions |
| [strategy.md](strategy.md) | Study phases, resources, and exam tactics |
| [notes/01-workspace-administration.md](notes/01-workspace-administration.md) | Workspace configuration and management |
| [notes/02-identity-access.md](notes/02-identity-access.md) | Identity, SSO, and access control |
| [notes/03-data-management.md](notes/03-data-management.md) | Unity Catalog administration |
| [notes/04-compute-management.md](notes/04-compute-management.md) | Clusters, policies, and warehouses |
| [notes/05-security.md](notes/05-security.md) | Network and data security |
