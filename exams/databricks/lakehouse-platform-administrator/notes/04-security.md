# Security - Databricks Lakehouse Platform Administrator

## Overview

Security covers 10% of the exam. This domain focuses on network security, encryption, audit logging, and compliance for Databricks deployments.

**[📖 Security Guide](https://docs.databricks.com/en/security/index.html)** - Security documentation hub

## Network Security

### VPC/VNet Injection (Customer-Managed VPC)

**[📖 Customer-Managed VPC](https://docs.databricks.com/en/security/network/classic/customer-managed-vpc.html)** - Network customization

**Purpose**: Deploy Databricks data plane resources in your own VPC/VNet for network control.

**AWS:**
- Provide your own VPC with required subnets
- Two private subnets in different AZs (for clusters)
- Security groups controlled by you
- NAT gateway for outbound internet (or VPC endpoints for private)
- S3 gateway endpoint required for DBFS access

**Azure:**
- VNet injection places clusters in your VNet
- Two subnets: public (for control plane communication) and private (for clusters)
- NSG rules managed by Databricks (do not modify required rules)
- UDR support for custom routing

**Benefits:**
- Apply existing network security controls
- Use corporate firewall and proxy
- VPC peering to other internal services
- Private connectivity to data sources

### Private Link / Private Endpoints

**[📖 AWS PrivateLink](https://docs.databricks.com/en/security/network/classic/privatelink.html)** - Private connectivity

- **Front-end Private Link**: Users access workspace UI/API via private endpoint (no public internet)
- **Back-end Private Link**: Data plane to control plane communication stays private
- Eliminates public IP exposure for Databricks access
- Requires customer-managed VPC

**Configuration components:**
- VPC endpoint (AWS) or Private endpoint (Azure)
- DNS configuration for private resolution
- Network security group rules
- Workspace configuration to require private access

### IP Access Lists

**[📖 IP Access Lists](https://docs.databricks.com/en/security/network/front-end/ip-access-list.html)** - Network restrictions

- Restrict workspace access to specific IP ranges
- Allow list: Only specified IPs can access
- Block list: Specified IPs are denied
- Applies to workspace UI and API access
- Configure at workspace level
- Does not affect cluster-to-data-source traffic

### Connectivity to Data Sources

- **VPC peering**: Connect Databricks VPC to data source VPC
- **Transit gateway**: Hub-and-spoke connectivity
- **VPN**: Encrypted tunnel to on-premises data centers
- **Private endpoints**: Direct connection to cloud services (S3, ADLS, etc.)
- Network traffic stays within cloud provider network

## Encryption

### Encryption at Rest

**[📖 Encryption at Rest](https://docs.databricks.com/en/security/keys/index.html)** - Data encryption

**Default encryption:**
- All data encrypted at rest using cloud provider default encryption
- DBFS root storage, managed tables, cluster EBS volumes

**Customer-managed keys (CMK/BYOK):**
- Use your own encryption keys from KMS (AWS), Key Vault (Azure), or Cloud KMS (GCP)
- Apply to: Managed services (notebook results), workspace storage (DBFS), cluster EBS volumes
- Key rotation managed by customer
- Provides additional control and compliance

**[📖 Customer-Managed Keys](https://docs.databricks.com/en/security/keys/customer-managed-keys.html)** - CMK configuration

### Encryption in Transit

- All control plane communication uses TLS 1.2+
- Cluster-to-cluster communication encrypted
- JDBC/ODBC connections use SSL
- API calls use HTTPS
- Intra-cluster encryption can be enabled for additional security

### Secret Management

**[📖 Secrets](https://docs.databricks.com/en/security/secrets/index.html)** - Credential storage

- Store sensitive values (passwords, tokens, keys) as secrets
- **Secret scopes**: Containers for secrets
  - Databricks-backed scopes: Managed by Databricks
  - Key Vault-backed scopes (Azure): Backed by Azure Key Vault
- Access control: Manage, Read, Write permissions per scope
- Reference in notebooks: `dbutils.secrets.get(scope="my-scope", key="my-key")`
- Secrets are redacted in notebook output (displayed as `[REDACTED]`)

## Audit Logging

**[📖 Audit Logs](https://docs.databricks.com/en/admin/account-settings/audit-logs.html)** - Activity tracking

### What Is Logged

- **Account-level events**: Workspace creation, user management, SSO events
- **Workspace-level events**: Cluster operations, job runs, notebook actions, SQL queries
- **Unity Catalog events**: Table access, permission changes, data lineage
- **DBFS events**: File operations on DBFS

### Log Delivery

**[📖 Configure Audit Log Delivery](https://docs.databricks.com/en/admin/account-settings/audit-log-delivery.html)** - Log destination

- Configure log delivery to cloud storage (S3, ADLS, GCS)
- JSON format with standardized schema
- Delivered every ~15 minutes
- Retain logs for compliance requirements
- Query audit logs using Databricks SQL or notebooks

### Key Audit Events

| Category | Events |
|----------|--------|
| Authentication | Login, logout, token creation, SSO events |
| Clusters | Create, edit, delete, start, terminate |
| Jobs | Create, run, cancel, delete |
| Notebooks | Create, run command, attach, detach |
| Unity Catalog | Create table, grant permission, access data |
| SQL Warehouse | Create, edit, start, stop, query execution |
| Secrets | Get secret, list scopes, create scope |

### System Tables for Audit

**[📖 System Tables](https://docs.databricks.com/en/admin/system-tables/index.html)** - Built-in monitoring

- `system.access.audit` - Audit log events queryable via SQL
- `system.billing.usage` - Compute usage and costs
- `system.compute.clusters` - Cluster metadata and events
- Query with SQL for dashboards and alerting
- Enabled by account admin

## Compliance

### Compliance Certifications

Databricks maintains compliance with:
- SOC 2 Type II
- ISO 27001, 27017, 27018
- HIPAA (with BAA)
- FedRAMP (select regions)
- GDPR
- PCI DSS

### Data Residency

- Deploy workspaces in specific cloud regions
- Unity Catalog metastore is regional
- Data stays in the region where it is stored
- Control plane region may differ from data plane region

### Best Practices for Compliance

1. Enable audit logging and deliver to secure storage
2. Use customer-managed keys for sensitive data
3. Deploy in customer-managed VPC with Private Link
4. Implement Unity Catalog for data governance
5. Use IP access lists to restrict workspace access
6. Enable SCIM for automated user lifecycle
7. Implement cluster policies to enforce security standards
8. Review system tables regularly for anomalies

## Common Exam Patterns

1. **"No public internet access to workspace"** - Private Link (front-end)
2. **"Encrypt with own keys"** - Customer-managed keys (CMK)
3. **"Track who accessed what data"** - Audit logs + Unity Catalog events
4. **"Restrict workspace to corporate network"** - IP access lists
5. **"Store database password securely"** - Secret scopes
6. **"Deploy in customer's network"** - VPC/VNet injection (customer-managed VPC)
7. **"Query audit logs with SQL"** - System tables (system.access.audit)
