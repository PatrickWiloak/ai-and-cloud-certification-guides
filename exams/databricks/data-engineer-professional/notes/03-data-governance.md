# Data Governance - Databricks Data Engineer Professional

## Overview

This section covers advanced Unity Catalog governance, representing 18% of the exam. You need to master dynamic views, external locations, storage credentials, system tables, and enterprise governance patterns.

**[📖 Unity Catalog Best Practices](https://docs.databricks.com/en/data-governance/unity-catalog/best-practices.html)** - Governance patterns
**[📖 System Tables](https://docs.databricks.com/en/administration-guide/system-tables/index.html)** - Audit and monitoring

## Key Topics

### 1. Dynamic Views for Data Security

Dynamic views implement fine-grained access control at the row and column level using SQL functions.

**[📖 Dynamic Views](https://docs.databricks.com/en/data-governance/unity-catalog/create-views.html)** - Row and column security

**Column-Level Security (Data Masking):**
```sql
CREATE OR REPLACE VIEW catalog.schema.masked_employees AS
SELECT
  employee_id,
  name,
  department,
  CASE
    WHEN is_member('hr_team') THEN ssn
    ELSE CONCAT('XXX-XX-', RIGHT(ssn, 4))
  END AS ssn,
  CASE
    WHEN is_member('finance_team') THEN salary
    ELSE NULL
  END AS salary
FROM catalog.schema.employees;
```

**Row-Level Security:**
```sql
CREATE OR REPLACE VIEW catalog.schema.regional_data AS
SELECT * FROM catalog.schema.all_data
WHERE region IN (
  SELECT allowed_region FROM catalog.schema.user_region_mapping
  WHERE user_email = current_user()
)
OR is_member('global_admins');
```

**Key Functions:**
| Function | Purpose |
|----------|---------|
| `is_member('group')` | Check workspace group membership |
| `is_account_group_member('group')` | Check account-level group membership |
| `current_user()` | Returns the current user's email |

### 2. Storage Credentials and External Locations

**[📖 Storage Credentials](https://docs.databricks.com/en/sql/language-manual/sql-ref-storage-credentials.html)** - External storage access
**[📖 External Locations](https://docs.databricks.com/en/sql/language-manual/sql-ref-syntax-ddl-create-location.html)** - Cloud storage mapping

```sql
-- Create storage credential (cloud-specific)
CREATE STORAGE CREDENTIAL my_credential
WITH (AWS_IAM_ROLE = 'arn:aws:iam::123456789:role/my-role');

-- Create external location
CREATE EXTERNAL LOCATION my_location
URL 's3://my-bucket/data/'
WITH (STORAGE CREDENTIAL my_credential);

-- Create external table using the location
CREATE TABLE catalog.schema.external_table
LOCATION 's3://my-bucket/data/table_path'
AS SELECT * FROM source;
```

**Key Concepts:**
- Storage credentials wrap cloud-provider IAM roles or managed identities
- External locations map cloud storage paths to Unity Catalog for governance
- External locations require a storage credential
- Only users with access to the external location can create external tables there
- Managed tables do not need external locations (stored in metastore-managed storage)

### 3. System Tables for Monitoring and Auditing

**[📖 System Tables](https://docs.databricks.com/en/administration-guide/system-tables/index.html)** - System table reference

| System Table | Purpose |
|-------------|---------|
| `system.billing.usage` | Compute and storage usage for cost analysis |
| `system.access.audit` | Workspace audit events (logins, queries, data access) |
| `system.information_schema` | Metadata about data objects |
| `system.billing.list_prices` | Current Databricks pricing |
| `system.compute.clusters` | Cluster configuration and history |

```sql
-- Query audit events for the last 7 days
SELECT * FROM system.access.audit
WHERE event_date >= current_date() - 7
AND action_name = 'getTable';

-- Analyze compute costs by workspace
SELECT workspace_id, sku_name, SUM(usage_quantity) AS total_dbus
FROM system.billing.usage
WHERE usage_date >= '2024-01-01'
GROUP BY workspace_id, sku_name;
```

**Key Concepts:**
- System tables must be enabled by an account admin
- Provide queryable data for monitoring, auditing, and cost management
- Audit tables capture all access events for compliance
- Billing tables enable cost analysis and chargeback

### 4. Privilege Inheritance and Advanced Permissions

**[📖 Privileges](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html)** - Permission model

**Key Concepts:**
- Permissions cascade: catalog -> schema -> table
- `WITH GRANT OPTION` allows the grantee to grant the same privilege to others
- `OWNER` privilege provides full control including the ability to drop objects
- Metastore admin can manage all objects across all catalogs
- Catalog owners can manage all objects within their catalog
- Data access requires both USE CATALOG and USE SCHEMA

**Advanced Grant Patterns:**
```sql
-- Grant with re-grant ability
GRANT SELECT ON TABLE t TO team_lead WITH GRANT OPTION;

-- Transfer ownership
ALTER TABLE catalog.schema.table OWNER TO new_owner_group;

-- View effective permissions
SHOW GRANTS ON TABLE catalog.schema.table;
```

### 5. Data Lineage and Impact Analysis

**[📖 Data Lineage](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html)** - Lineage tracking

**Key Concepts:**
- Lineage is automatically captured for SQL queries, notebooks, and jobs
- Table-level lineage shows upstream and downstream dependencies
- Column-level lineage tracks how individual columns are derived
- Useful for impact analysis: what downstream tables are affected by a change?
- Lineage data is accessible through the Unity Catalog UI and REST API
- Tags can be applied to tables and columns for classification (e.g., PII)

### 6. Delta Sharing

**[📖 Delta Sharing](https://docs.databricks.com/en/delta-sharing/index.html)** - Cross-organization sharing

```sql
-- Create a share
CREATE SHARE my_share;
ALTER SHARE my_share ADD TABLE catalog.schema.table;

-- Create a recipient
CREATE RECIPIENT my_recipient;

-- Grant access
GRANT SELECT ON SHARE my_share TO RECIPIENT my_recipient;
```

**Key Concepts:**
- Open protocol for secure cross-organization data sharing
- No data copying - recipients query data in place
- Provider shares data; recipient consumes data
- Supports Databricks-to-Databricks and open sharing (any client)
- Audit sharing access through system tables

### 7. Enterprise Governance Patterns

**Key Concepts:**
- Catalog-per-environment pattern: dev, staging, production catalogs
- Catalog-per-domain pattern: sales, marketing, finance catalogs
- Use groups for permission management (not individual users)
- Service principals for automated pipelines and CI/CD
- Tag sensitive data for compliance (PII, PHI, financial)
- Regular access reviews using system tables

## Exam Tips for This Domain

1. **Dynamic views** - Know `is_member()` and `current_user()` patterns
2. **Storage credentials and external locations** - Understand the hierarchy
3. **System tables** - Know which table provides which data (audit, billing, compute)
4. **Privilege inheritance** - Permissions cascade from catalog to schema to table
5. **Delta Sharing** - Understand provider/recipient model and audit capabilities
6. **Enterprise patterns** - Catalog-per-environment vs catalog-per-domain

## Documentation Links Summary

| Topic | Link |
|-------|------|
| UC Best Practices | [docs.databricks.com/en/data-governance/unity-catalog/best-practices.html](https://docs.databricks.com/en/data-governance/unity-catalog/best-practices.html) |
| Dynamic Views | [docs.databricks.com/en/data-governance/unity-catalog/create-views.html](https://docs.databricks.com/en/data-governance/unity-catalog/create-views.html) |
| System Tables | [docs.databricks.com/en/administration-guide/system-tables/index.html](https://docs.databricks.com/en/administration-guide/system-tables/index.html) |
| Data Lineage | [docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html) |
| Delta Sharing | [docs.databricks.com/en/delta-sharing/index.html](https://docs.databricks.com/en/delta-sharing/index.html) |
| Privileges | [docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html) |
