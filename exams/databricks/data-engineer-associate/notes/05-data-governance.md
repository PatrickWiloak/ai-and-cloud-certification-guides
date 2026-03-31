# Data Governance - Databricks Data Engineer Associate

## Overview

This section covers Unity Catalog and data governance, representing 17% of the exam. You need to understand the Unity Catalog namespace hierarchy, permissions model, data lineage, and security features like dynamic views.

**[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Unity Catalog overview
**[📖 UC Privileges](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html)** - Permission model

## Key Topics

### 1. Unity Catalog Architecture

Unity Catalog provides centralized governance for all data and AI assets on Databricks. It implements a three-level namespace for organizing data objects.

**[📖 UC Architecture](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Architecture overview

**Three-Level Namespace:**
```
Metastore
  └── Catalog
        └── Schema (Database)
              ├── Tables
              ├── Views
              ├── Volumes
              └── Functions
```

**Referencing Objects:**
```sql
-- Full three-level reference
SELECT * FROM catalog_name.schema_name.table_name;

-- Set defaults to avoid specifying every time
USE CATALOG my_catalog;
USE SCHEMA my_schema;
SELECT * FROM table_name;
```

**Key Concepts:**
- Metastore is the top-level container - one per cloud region
- Catalogs organize schemas, typically by environment (dev, staging, prod) or domain
- Schemas (also called databases) group related tables, views, and functions
- Every table reference can use the full three-part name: `catalog.schema.table`
- Default catalog and schema can be set to simplify queries

### 2. Managed vs External Tables

**[📖 Tables in UC](https://docs.databricks.com/en/data-governance/unity-catalog/create-tables.html)** - Table types

| Feature | Managed Table | External Table |
|---------|--------------|----------------|
| Data Storage | Metastore-managed storage | Customer-managed storage |
| Lifecycle | Data deleted when table is dropped | Data persists when table is dropped |
| Best For | Most use cases | Shared storage or regulatory needs |

```sql
-- Managed table (default)
CREATE TABLE catalog.schema.managed_table (id INT, name STRING);

-- External table
CREATE TABLE catalog.schema.external_table
LOCATION 's3://bucket/path'
AS SELECT * FROM source;
```

**Key Concepts:**
- Managed tables store data in the metastore-managed cloud storage location
- Dropping a managed table deletes both the metadata and the underlying data
- External tables point to data in a customer-managed cloud storage location
- Dropping an external table removes only the metadata - data files remain
- Managed tables are recommended for most use cases

### 3. Volumes

Volumes manage non-tabular data (files, images, logs, models) within Unity Catalog.

**[📖 Volumes](https://docs.databricks.com/en/sql/language-manual/sql-ref-volumes.html)** - Volume management

```sql
-- Create a managed volume
CREATE VOLUME catalog.schema.my_volume;

-- Create an external volume
CREATE EXTERNAL VOLUME catalog.schema.ext_volume
LOCATION 's3://bucket/path';

-- Access files in a volume
LIST '/Volumes/catalog/schema/my_volume/';
```

**Key Concepts:**
- Volumes provide governed access to non-tabular data
- Managed volumes store data in metastore-managed storage
- External volumes reference data in customer-managed storage
- Files in volumes are accessible via `/Volumes/catalog/schema/volume_name/` paths
- Volumes follow the same permission model as tables

### 4. Permissions and Access Control

**[📖 Privileges](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html)** - Permission management

**Common GRANT Statements:**
```sql
-- Catalog-level access
GRANT USE CATALOG ON CATALOG my_catalog TO group_name;

-- Schema-level access
GRANT USE SCHEMA ON SCHEMA my_catalog.my_schema TO group_name;

-- Table-level access
GRANT SELECT ON TABLE my_catalog.my_schema.my_table TO group_name;
GRANT MODIFY ON TABLE my_catalog.my_schema.my_table TO group_name;

-- Create permissions
GRANT CREATE TABLE ON SCHEMA my_catalog.my_schema TO group_name;
GRANT CREATE SCHEMA ON CATALOG my_catalog TO group_name;

-- Revoke permissions
REVOKE SELECT ON TABLE my_catalog.my_schema.my_table FROM group_name;

-- View current grants
SHOW GRANTS ON TABLE my_catalog.my_schema.my_table;
```

**Key Privileges:**
| Privilege | Description |
|-----------|-------------|
| USE CATALOG | Required to access any object in the catalog |
| USE SCHEMA | Required to access any object in the schema |
| SELECT | Read data from a table or view |
| MODIFY | Insert, update, delete data in a table |
| CREATE TABLE | Create tables in a schema |
| CREATE SCHEMA | Create schemas in a catalog |
| ALL PRIVILEGES | Grants all applicable privileges |

**Privilege Inheritance:**
- `USE CATALOG` is required before any schema-level access
- `USE SCHEMA` is required before any table-level access
- Permissions cascade: granting on a catalog applies to all schemas and tables
- Granting `ALL PRIVILEGES` on a schema gives full access to all objects in that schema

### 5. Dynamic Views for Data Security

Dynamic views implement row-level and column-level security by using SQL functions to control what data each user sees.

**[📖 Dynamic Views](https://docs.databricks.com/en/data-governance/unity-catalog/create-views.html)** - Row and column security

```sql
-- Column-level security (data masking)
CREATE VIEW catalog.schema.masked_customers AS
SELECT
  id,
  name,
  CASE WHEN is_member('finance_team') THEN ssn ELSE 'XXX-XX-XXXX' END AS ssn,
  CASE WHEN is_member('finance_team') THEN salary ELSE NULL END AS salary
FROM catalog.schema.customers;

-- Row-level security
CREATE VIEW catalog.schema.regional_sales AS
SELECT * FROM catalog.schema.all_sales
WHERE region = current_user()
   OR is_member('global_admins');
```

**Key Functions for Dynamic Views:**
| Function | Purpose |
|----------|---------|
| `is_member('group')` | Check if user belongs to a group |
| `current_user()` | Returns the current user's email |
| `is_account_group_member()` | Check account-level group membership |

### 6. Data Lineage

Unity Catalog automatically tracks data lineage - the flow of data from source to destination.

**[📖 Data Lineage](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html)** - Lineage tracking

**Key Concepts:**
- Lineage is captured automatically for SQL queries, notebooks, and jobs
- Table-to-table lineage shows which tables depend on which sources
- Column-to-column lineage shows how individual columns are derived
- Lineage is viewable in the Unity Catalog UI
- Useful for impact analysis (what breaks if I change this table?)
- Supports compliance requirements by showing data flow

### 7. Information Schema

The information schema provides metadata about all objects in Unity Catalog.

**[📖 Information Schema](https://docs.databricks.com/en/sql/language-manual/sql-ref-information-schema.html)** - Metadata queries

```sql
-- List all tables in a schema
SELECT * FROM catalog_name.information_schema.tables
WHERE table_schema = 'my_schema';

-- List columns for a table
SELECT * FROM catalog_name.information_schema.columns
WHERE table_name = 'my_table';

-- List all grants
SELECT * FROM catalog_name.information_schema.table_privileges
WHERE table_name = 'my_table';
```

**Key Concepts:**
- Information schema is available in every catalog
- Provides programmatic access to metadata
- Useful for auditing, documentation, and automation
- Shows tables, columns, privileges, and other metadata

## Exam Tips for This Domain

1. **Three-level namespace** - Always know: catalog.schema.table
2. **USE CATALOG + USE SCHEMA** - Both required before accessing objects
3. **Managed vs external tables** - Know what happens on DROP for each
4. **Dynamic views** - `is_member()` and `current_user()` for row/column security
5. **GRANT inheritance** - Permissions cascade from catalog to schema to table
6. **Data lineage** - Tracked automatically, visible in Unity Catalog UI
7. **Volumes** - For non-tabular data; follow the same governance model as tables

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Unity Catalog | [docs.databricks.com/en/data-governance/unity-catalog/index.html](https://docs.databricks.com/en/data-governance/unity-catalog/index.html) |
| Privileges | [docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html) |
| Dynamic Views | [docs.databricks.com/en/data-governance/unity-catalog/create-views.html](https://docs.databricks.com/en/data-governance/unity-catalog/create-views.html) |
| Data Lineage | [docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html) |
| Volumes | [docs.databricks.com/en/sql/language-manual/sql-ref-volumes.html](https://docs.databricks.com/en/sql/language-manual/sql-ref-volumes.html) |
| Information Schema | [docs.databricks.com/en/sql/language-manual/sql-ref-information-schema.html](https://docs.databricks.com/en/sql/language-manual/sql-ref-information-schema.html) |
