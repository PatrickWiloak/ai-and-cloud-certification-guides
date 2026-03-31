# Databricks Lakehouse Platform Administrator - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Lakehouse Platform Administrator
**Duration:** 90 minutes
**Questions:** 45 multiple-choice questions
**Passing Score:** 70% (approximately 32 correct)
**Cost:** $200 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/lakehouse-platform-administrator)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - Administration learning paths
**[📖 Administration Guide](https://docs.databricks.com/en/admin/index.html)** - Admin documentation

## Target Audience

This certification is designed for:
- Databricks platform administrators
- Cloud infrastructure engineers managing Databricks
- DevOps engineers responsible for Databricks environments
- IT administrators transitioning to Databricks
- Professionals with 6+ months Databricks administration experience

## Domain 1: Workspace Administration (30%)

### Workspace Configuration

**[📖 Workspace Administration](https://docs.databricks.com/en/admin/workspace-settings/index.html)** - Workspace settings
**[📖 Account Console](https://docs.databricks.com/en/admin/account-settings/index.html)** - Account management
**[📖 Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/index.html)** - CLI administration

**Key Facts:**
- Account-level administration: manage workspaces, users, billing
- Workspace-level administration: manage workspace settings and resources
- Account admin vs workspace admin roles
- Workspace deployment: cloud-specific setup (AWS, Azure, GCP)
- Workspace settings: enable/disable features, set defaults
- Workspace object permissions: notebooks, repos, folders
- `databricks workspace` CLI commands for automation
- REST API for programmatic administration
- Terraform provider for infrastructure-as-code

### Secret Management

**[📖 Secret Management](https://docs.databricks.com/en/security/secrets/index.html)** - Secrets overview
**[📖 Secret Scopes](https://docs.databricks.com/en/security/secrets/secret-scopes.html)** - Managing scopes

**Key Facts:**
- Secret scopes: organize secrets by project or environment
- Databricks-backed scopes: managed by Databricks
- Key vault-backed scopes: backed by Azure Key Vault (Azure only)
- `dbutils.secrets.get(scope, key)` retrieves secret values
- Secrets are redacted in notebook output
- ACLs control access to secret scopes
- CLI commands: `databricks secrets create-scope`, `put-secret`, `list-secrets`

### Cost Management

**[📖 Billing](https://docs.databricks.com/en/admin/account-settings/billable-usage-delivery.html)** - Usage tracking
**[📖 Budgets](https://docs.databricks.com/en/admin/account-settings/budgets.html)** - Budget management

**Key Facts:**
- Databricks Units (DBU): consumption metric for billing
- DBU rates vary by compute type and tier
- Billable usage logs for cost analysis
- Budget alerts for spending thresholds
- System tables: `system.billing.usage` for querying usage data
- Tag-based cost allocation for chargeback
- Serverless compute has different pricing model
- Spot instances reduce compute costs (but may be interrupted)

## Domain 2: Identity and Access (25%)

### Identity Federation

**[📖 Identity Setup](https://docs.databricks.com/en/admin/users-groups/index.html)** - User management
**[📖 SCIM Provisioning](https://docs.databricks.com/en/admin/users-groups/scim/index.html)** - Automated user sync
**[📖 SSO Configuration](https://docs.databricks.com/en/admin/account-settings/single-sign-on/index.html)** - Single sign-on

**Key Facts:**
- SCIM (System for Cross-domain Identity Management): sync users/groups from IdP
- Supported IdPs: Azure AD (Entra ID), Okta, OneLogin, PingFederate
- SCIM provisioning: automated user lifecycle (create, update, deactivate)
- SSO protocols: SAML 2.0 and OpenID Connect (OIDC)
- Account-level SSO: single sign-on for all workspaces
- Workspace-level SSO: per-workspace SSO configuration
- Identity federation: sync account-level identities to workspaces

### User and Group Management

**[📖 Users and Groups](https://docs.databricks.com/en/admin/users-groups/index.html)** - Managing identities
**[📖 Service Principals](https://docs.databricks.com/en/admin/users-groups/service-principals.html)** - Automation identities

**Key Facts:**
- Account-level groups: shared across all workspaces
- Workspace-level groups: local to a workspace (legacy)
- Service principals: non-human identities for automation
- Service principal OAuth tokens for secure API access
- Personal access tokens (PATs): user-specific API authentication
- Token lifetime policies: set maximum token duration
- Entitlements: workspace access, cluster creation, SQL access, Repos
- Group nesting: groups can contain other groups
- `account admins` group: full account administration
- `workspace admins` group: full workspace administration

### Access Control

**[📖 Access Control](https://docs.databricks.com/en/security/auth/index.html)** - Authentication overview
**[📖 Workspace Permissions](https://docs.databricks.com/en/security/auth/access-control/index.html)** - Object-level permissions

**Key Facts:**
- Workspace object ACLs: notebooks, repos, folders, experiments
- Permission levels: No Permissions, Can Read, Can Run, Can Edit, Can Manage
- Cluster permissions: Can Attach To, Can Restart, Can Manage
- Job permissions: Can View, Can Manage Run, Is Owner, Can Manage
- SQL warehouse permissions: Can Use, Can Monitor, Can Manage, Is Owner
- Admin permissions override object-level ACLs
- Default permissions for new objects: creator is owner

## Domain 3: Data Management (20%)

### Unity Catalog Administration

**[📖 Unity Catalog Setup](https://docs.databricks.com/en/data-governance/unity-catalog/get-started.html)** - Initial configuration
**[📖 Metastore Admin](https://docs.databricks.com/en/data-governance/unity-catalog/manage-metastore.html)** - Metastore management
**[📖 Storage Credentials](https://docs.databricks.com/en/sql/language-manual/sql-ref-storage-credentials.html)** - External storage access

**Key Facts:**
- Metastore: top-level container, one per region
- Metastore admin: manages catalogs, storage credentials, external locations
- Metastore assignment: bind metastore to workspaces
- Managed storage: metastore-managed cloud storage for managed tables
- Storage credentials: IAM role (AWS), managed identity (Azure), service account (GCP)
- External locations: map cloud storage paths to Unity Catalog
- `CREATE STORAGE CREDENTIAL`, `CREATE EXTERNAL LOCATION` SQL commands
- Catalog isolation: separate data domains with catalogs

### Delta Sharing

**[📖 Delta Sharing](https://docs.databricks.com/en/delta-sharing/index.html)** - Cross-organization sharing
**[📖 Create Shares](https://docs.databricks.com/en/delta-sharing/create-share.html)** - Setting up shares

**Key Facts:**
- Open protocol for secure cross-organization data sharing
- Provider: organization sharing data
- Recipient: organization receiving data
- Share: collection of tables/schemas shared with recipients
- No data copying: recipients query data in place
- Recipient authentication: token-based or Databricks-to-Databricks
- Sharing notebooks and AI models (not just tables)
- Audit sharing access through system tables

### System Tables

**[📖 System Tables](https://docs.databricks.com/en/administration-guide/system-tables/index.html)** - Monitoring and auditing

**Key Facts:**
- `system.billing.usage`: compute and storage usage
- `system.access.audit`: workspace audit events
- `system.information_schema`: metadata about data objects
- `system.billing.list_prices`: current pricing information
- `system.compute.clusters`: cluster configuration history
- Enable system tables through account console
- Query with SQL for custom dashboards and alerts
- Retention policies for system table data

## Domain 4: Cluster and Warehouse Management (15%)

### Cluster Configuration

**[📖 Cluster Configuration](https://docs.databricks.com/en/compute/configure.html)** - Cluster settings
**[📖 Cluster Policies](https://docs.databricks.com/en/admin/clusters/policies.html)** - Policy management
**[📖 Cluster Pools](https://docs.databricks.com/en/compute/pool-index.html)** - Instance pools

**Key Facts:**
- All-purpose clusters: interactive, long-running, multi-user
- Job clusters: ephemeral, created per job run, cost-effective
- Cluster policies: restrict and set default cluster configurations
- Policy elements: allowed instance types, max workers, autoscaling limits
- Fixed policies: users cannot change the value
- Range policies: users can choose within a range
- Cluster pools: pre-provisioned idle instances for faster startup
- Pool settings: min/max idle instances, instance types
- Autoscaling: min/max workers, auto-termination timeout
- Spot instances: significant cost savings, potential interruptions
- Init scripts: global, cluster-scoped, and cluster-named

### SQL Warehouses

**[📖 SQL Warehouses](https://docs.databricks.com/en/sql/admin/sql-endpoints.html)** - Warehouse configuration
**[📖 Serverless SQL](https://docs.databricks.com/en/sql/admin/serverless.html)** - Serverless warehouses

**Key Facts:**
- SQL warehouse types:
  - Classic: customer-managed compute
  - Pro: enhanced features (query federation, serverless)
  - Serverless: fully managed by Databricks (fastest startup)
- Warehouse sizing: 2X-Small to 4X-Large (T-shirt sizing)
- Auto-stop: automatically stop after idle timeout
- Scaling: min/max clusters for concurrent query handling
- Spot instance policy: cost-optimized or reliability-optimized
- Photon: enabled by default on Pro and Serverless
- Channel: preview (latest features) vs current (stable)
- Query queuing: when all clusters are busy
- Warehouse permissions: Can Use, Can Monitor, Can Manage

### Serverless Compute

**[📖 Serverless Compute](https://docs.databricks.com/en/compute/serverless.html)** - Serverless overview

**Key Facts:**
- Serverless clusters: managed by Databricks, no infrastructure to manage
- Instant startup: no cluster provisioning wait
- Auto-scaling: automatically scales based on workload
- Available for: SQL warehouses, notebooks, jobs, DLT
- Serverless networking: secure by default
- Pricing: based on DBU consumption
- No cluster policies needed for serverless

## Domain 5: Security (10%)

### Network Security

**[📖 Network Security](https://docs.databricks.com/en/security/network/index.html)** - Network configuration
**[📖 Private Link](https://docs.databricks.com/en/security/network/classic/private-link.html)** - Private connectivity
**[📖 IP Access Lists](https://docs.databricks.com/en/security/network/front-end/ip-access-list.html)** - IP restrictions

**Key Facts:**
- VPC/VNet peering: connect Databricks to customer network
- Private Link (AWS/Azure): private connectivity without public internet
- Private Service Connect (GCP): Google Cloud private access
- IP access lists: restrict access to specific IP ranges
- Secure cluster connectivity: no public IP addresses on cluster nodes
- Network security groups: control inbound/outbound traffic
- Hub-and-spoke network topology support
- Data exfiltration prevention: restrict outbound access

### Encryption

**[📖 Encryption](https://docs.databricks.com/en/security/keys/index.html)** - Encryption options
**[📖 Customer-Managed Keys](https://docs.databricks.com/en/security/keys/customer-managed-keys.html)** - CMK setup

**Key Facts:**
- Encryption at rest: enabled by default for all data
- Encryption in transit: TLS 1.2+ for all communications
- Customer-managed keys (CMK): bring your own encryption keys
- CMK for managed services: encrypt control plane data
- CMK for workspace storage: encrypt data plane storage
- AWS KMS, Azure Key Vault, or GCP Cloud KMS
- Key rotation policies and procedures

### Compliance

**[📖 Security Best Practices](https://docs.databricks.com/en/security/index.html)** - Security overview
**[📖 Audit Logs](https://docs.databricks.com/en/admin/account-settings/audit-logs.html)** - Audit logging

**Key Facts:**
- Compliance certifications: SOC 2 Type II, ISO 27001, HIPAA, FedRAMP, PCI DSS
- Audit logs: capture all administrative and data access events
- Diagnostic logs: workspace-level activity logging
- Log delivery: cloud storage destination for audit logs
- System tables for queryable audit data
- GDPR compliance: data processing agreements available
- Regular security assessments and penetration testing

## Exam Tips

1. **Workspace admin (30%)** is the largest domain - know settings and configurations
2. **Identity management** - SCIM, SSO, service principals are essential topics
3. **Unity Catalog administration** - not just usage, but setup and governance
4. **Cluster policies** - know how to restrict and set defaults
5. **SQL warehouse types** - Classic vs Pro vs Serverless differences
6. **Network security** - Private Link, VPC peering, IP access lists
7. **Secret management** - scopes, ACLs, and retrieval
8. **Cost management** - DBUs, billing, budgets, tag-based allocation
9. **Cloud-specific details** - some configuration differs by cloud provider
10. **System tables** - know which tables exist and what they contain

## Quick Reference

### Essential Admin Commands
```sql
-- Unity Catalog Administration
CREATE CATALOG catalog_name;
CREATE SCHEMA catalog_name.schema_name;
CREATE STORAGE CREDENTIAL cred_name WITH (AZURE MANAGED IDENTITY resource_id);
CREATE EXTERNAL LOCATION loc_name URL 'abfss://...' WITH (STORAGE CREDENTIAL cred_name);

-- Permissions
GRANT USE CATALOG ON CATALOG catalog_name TO group_name;
GRANT CREATE SCHEMA ON CATALOG catalog_name TO group_name;
GRANT ALL PRIVILEGES ON SCHEMA catalog.schema TO group_name;
REVOKE SELECT ON TABLE catalog.schema.table FROM group_name;
SHOW GRANTS ON CATALOG catalog_name;

-- System Tables
SELECT * FROM system.billing.usage WHERE usage_date > '2024-01-01';
SELECT * FROM system.access.audit WHERE event_date > current_date() - 7;
SELECT * FROM system.compute.clusters WHERE cluster_name LIKE '%prod%';

-- Delta Sharing
CREATE SHARE share_name;
ALTER SHARE share_name ADD TABLE catalog.schema.table;
CREATE RECIPIENT recipient_name;
GRANT SELECT ON SHARE share_name TO RECIPIENT recipient_name;
```

### CLI Commands
```bash
# Workspace management
databricks workspace list /
databricks clusters list
databricks clusters policies list

# Secret management
databricks secrets create-scope scope_name
databricks secrets put-secret scope_name key_name
databricks secrets list-secrets scope_name
databricks secrets list-acls scope_name

# User management
databricks users list
databricks groups list
databricks service-principals list
```
