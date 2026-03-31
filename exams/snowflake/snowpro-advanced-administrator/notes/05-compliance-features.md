# Compliance Features

**[📖 Security and Compliance](https://docs.snowflake.com/en/user-guide/security-compliance)** - Compliance documentation

## Overview

This document covers compliance features in Snowflake including Time Travel, Fail-safe, data classification, audit logging, and regulatory compliance. Understanding data management and compliance requirements by Snowflake edition is essential for the Advanced Administrator exam.

## Time Travel

### Configuration
- Allows querying data as it existed at a point in the past
- Enables undropping accidentally deleted objects
- Retention period configurable per object (tables, schemas, databases)
- Storage cost for historical data during retention period

**[📖 Time Travel](https://docs.snowflake.com/en/user-guide/data-time-travel)** - Time Travel documentation

### Retention by Table Type and Edition
| Table Type | Standard Edition | Enterprise+ |
|-----------|-----------------|-------------|
| Permanent | 0-1 day | 0-90 days |
| Transient | 0-1 day | 0-1 day |
| Temporary | 0-1 day | 0-1 day |

```sql
-- Set retention at table level
ALTER TABLE customers SET DATA_RETENTION_TIME_IN_DAYS = 30;

-- Set retention at schema level (applies to new tables)
ALTER SCHEMA public SET DATA_RETENTION_TIME_IN_DAYS = 14;

-- Set retention at database level (applies to new schemas/tables)
ALTER DATABASE analytics SET DATA_RETENTION_TIME_IN_DAYS = 7;

-- View current retention setting
SHOW PARAMETERS LIKE 'DATA_RETENTION%' IN TABLE customers;
```

### Time Travel Queries
```sql
-- Query at a specific timestamp
SELECT * FROM customers AT(TIMESTAMP => '2024-01-15 10:00:00'::TIMESTAMP_LTZ);

-- Query at a relative offset (seconds ago)
SELECT * FROM customers AT(OFFSET => -3600);  -- 1 hour ago

-- Query before a specific statement
SELECT * FROM customers BEFORE(STATEMENT => '01a12345-0001-abcd-0000-000000000001');

-- Clone a table from a point in time
CREATE TABLE customers_backup CLONE customers
  AT(TIMESTAMP => '2024-01-15 10:00:00'::TIMESTAMP_LTZ);
```

### UNDROP Operations
```sql
-- Undrop a table
UNDROP TABLE accidentally_dropped;

-- Undrop a schema
UNDROP SCHEMA accidentally_dropped_schema;

-- Undrop a database
UNDROP DATABASE accidentally_dropped_db;
```

- UNDROP restores the object to its state at drop time
- Only works within the Time Travel retention period
- If a new object with the same name exists, rename it first
- UNDROP restores all child objects (tables in schema, schemas in database)

### Extended Time Travel
```sql
-- MAX_DATA_EXTENSION_TIME_IN_DAYS (default: 14)
-- Extends Time Travel when Snowflake needs additional retention
ALTER ACCOUNT SET MAX_DATA_EXTENSION_TIME_IN_DAYS = 28;
```

- Snowflake may extend retention beyond configured period to maintain data integrity
- Extension period is configurable (0-90 days for Enterprise+)
- Extended data incurs storage cost

## Fail-safe

### Overview
- 7-day protection period after Time Travel retention expires
- Snowflake-managed - not user-accessible
- Recovery requires contacting Snowflake support
- Last resort for disaster recovery
- Not available for transient or temporary tables

**[📖 Fail-safe](https://docs.snowflake.com/en/user-guide/data-cdp-storage-costs#label-data-retention-time)** - Fail-safe documentation

### Data Lifecycle Timeline
```
Data Modified --> Time Travel Period --> Fail-safe Period --> Data Purged
                  (0-90 days)           (7 days)
                  User accessible       Snowflake support only
```

### Storage Cost Implications
| Table Type | Active | Time Travel | Fail-safe | Total |
|-----------|--------|-------------|-----------|-------|
| Permanent (90d TT) | Yes | Up to 90 days | 7 days | Active + 97 days history |
| Permanent (1d TT) | Yes | 1 day | 7 days | Active + 8 days history |
| Transient (1d TT) | Yes | 1 day | None | Active + 1 day history |
| Transient (0d TT) | Yes | None | None | Active only |
| Temporary | Yes | 0-1 day | None | Active + 0-1 day |

### Cost Optimization with Table Types
```sql
-- Use transient for staging/ETL data (no Fail-safe cost)
CREATE TRANSIENT TABLE staging_events (
  raw_data VARIANT,
  loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Use transient for development tables
CREATE TRANSIENT SCHEMA dev_schema;

-- Check storage by table type
SELECT table_type,
       COUNT(*) AS table_count,
       SUM(active_bytes)/1024/1024/1024 AS active_gb,
       SUM(time_travel_bytes)/1024/1024/1024 AS tt_gb,
       SUM(failsafe_bytes)/1024/1024/1024 AS failsafe_gb
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE active_bytes > 0
GROUP BY table_type;
```

## Data Classification and Tagging

### Object Tagging
```sql
-- Create classification tags
CREATE TAG data_sensitivity ALLOWED_VALUES 'PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED';
CREATE TAG pii_type ALLOWED_VALUES 'NAME', 'EMAIL', 'SSN', 'PHONE', 'ADDRESS', 'DOB';
CREATE TAG data_owner;
CREATE TAG retention_policy ALLOWED_VALUES '30_DAYS', '90_DAYS', '1_YEAR', '7_YEARS';

-- Apply tags to objects
ALTER DATABASE customer_db SET TAG data_sensitivity = 'CONFIDENTIAL';
ALTER TABLE customers SET TAG data_owner = 'customer_team';
ALTER TABLE customers MODIFY COLUMN ssn SET TAG pii_type = 'SSN';
ALTER TABLE customers MODIFY COLUMN email SET TAG pii_type = 'EMAIL';
ALTER TABLE customers MODIFY COLUMN name SET TAG pii_type = 'NAME';

-- Query tag assignments
SELECT * FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES(
  'customers', 'TABLE'
));

-- Find all objects with a specific tag
SELECT * FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
  'customers', 'TABLE'
));
```

**[📖 Object Tagging](https://docs.snowflake.com/en/user-guide/object-tagging)** - Tag management

### Tag-Based Masking
```sql
-- Create masking policy
CREATE MASKING POLICY pii_mask AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('DATA_ADMIN', 'SECURITY_ADMIN') THEN val
    WHEN CURRENT_ROLE() = 'ANALYST' THEN SHA2(val)
    ELSE '***MASKED***'
  END;

-- Associate masking policy with tag
ALTER TAG pii_type SET MASKING POLICY pii_mask;

-- Now ALL columns tagged with pii_type automatically get masked
-- Adding the tag to a new column automatically applies masking
```

### Automatic Data Classification
```sql
-- Classify columns automatically (Enterprise+ feature)
SELECT *
FROM TABLE(
  SNOWFLAKE.CORE.CLASSIFY(
    'customers',
    {'auto_tag': true}
  )
);

-- Review classification results
SELECT * FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
  'customers', 'TABLE'
))
WHERE tag_name IN ('SNOWFLAKE.CORE.SEMANTIC_CATEGORY', 'SNOWFLAKE.CORE.PRIVACY_CATEGORY');
```

**[📖 Data Classification](https://docs.snowflake.com/en/user-guide/governance-classify)** - Automatic classification

## Audit Logging

### ACCESS_HISTORY
- Tracks which objects were accessed and by whom
- Records both direct and base (underlying) object access
- Essential for data lineage and compliance auditing
- 365-day retention in ACCOUNT_USAGE

**[📖 Access History](https://docs.snowflake.com/en/user-guide/access-history)** - Access audit trail

```sql
-- Recent data access by user
SELECT user_name,
       query_start_time,
       direct_objects_accessed,
       base_objects_accessed
FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
WHERE query_start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
ORDER BY query_start_time DESC
LIMIT 100;

-- Access to sensitive tables
SELECT user_name, role_name,
       query_start_time,
       f.value:objectName::STRING AS table_accessed
FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY,
     LATERAL FLATTEN(base_objects_accessed) f
WHERE f.value:objectName::STRING LIKE '%CUSTOMERS%'
  AND query_start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
ORDER BY query_start_time DESC;
```

### LOGIN_HISTORY
```sql
-- Login activity summary
SELECT user_name,
       reported_client_type,
       COUNT(*) AS login_count,
       COUNT_IF(is_success = 'YES') AS successful,
       COUNT_IF(is_success = 'NO') AS failed,
       MIN(event_timestamp) AS first_login,
       MAX(event_timestamp) AS last_login
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE event_timestamp >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY user_name, reported_client_type
ORDER BY failed DESC;

-- Suspicious login patterns
SELECT user_name, client_ip, reported_client_type,
       event_timestamp, error_code, error_message
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE is_success = 'NO'
  AND event_timestamp >= DATEADD('hour', -24, CURRENT_TIMESTAMP())
ORDER BY event_timestamp DESC;
```

### GRANTS_TO_ROLES (Privilege Audit)
```sql
-- Current role grants
SELECT privilege, granted_on, name AS object_name,
       grantee_name, granted_by, created_on
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE deleted_on IS NULL
  AND grantee_name = 'DATA_ANALYST'
ORDER BY granted_on, name;

-- Excessive privileges detection
SELECT grantee_name, granted_on, COUNT(*) AS grant_count
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE deleted_on IS NULL
  AND privilege IN ('OWNERSHIP', 'ALL')
GROUP BY grantee_name, granted_on
HAVING grant_count > 10
ORDER BY grant_count DESC;
```

## Regulatory Compliance

### Compliance Certifications by Edition
| Certification | Standard | Enterprise | Business Critical | VPS |
|--------------|----------|-----------|-------------------|-----|
| SOC 1 Type II | Yes | Yes | Yes | Yes |
| SOC 2 Type II | Yes | Yes | Yes | Yes |
| ISO 27001 | Yes | Yes | Yes | Yes |
| HIPAA | No | No | Yes | Yes |
| PCI DSS | No | No | Yes | Yes |
| FedRAMP Moderate | No | No | Select regions | Select regions |
| HITRUST CSF | No | No | Yes | Yes |

### HIPAA Compliance Requirements
- Business Critical edition or higher required
- Snowflake signs BAA (Business Associate Agreement)
- Customer responsible for access controls and monitoring
- PHI must be in tables with appropriate governance
- Encryption at rest and in transit (automatic)
- Audit logging must be monitored (ACCESS_HISTORY)

### PCI DSS Requirements
- Business Critical edition or higher required
- Cardholder data must be masked or tokenized
- Access controls enforced via RBAC and network policies
- Regular access reviews using GRANTS_TO_ROLES
- Audit trail maintained via LOGIN_HISTORY and ACCESS_HISTORY

## Compliance Monitoring Checklist

### Regular Admin Tasks
1. **Daily:** Review failed login attempts (LOGIN_HISTORY)
2. **Weekly:** Review privileged role usage (QUERY_HISTORY for ACCOUNTADMIN)
3. **Monthly:** Audit role grants and remove unused permissions
4. **Quarterly:** Review data classification tags and masking policies
5. **Annually:** Full compliance assessment and documentation update

### Automated Monitoring
```sql
-- Alert on excessive ACCOUNTADMIN usage
CREATE TASK monitor_admin_usage
  WAREHOUSE = admin_wh
  SCHEDULE = 'USING CRON 0 8 * * * UTC'
AS
  INSERT INTO admin_alerts
  SELECT user_name, COUNT(*) AS admin_query_count, CURRENT_TIMESTAMP()
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE role_name = 'ACCOUNTADMIN'
    AND start_time >= DATEADD('day', -1, CURRENT_TIMESTAMP())
    AND user_name NOT IN ('ADMIN_SERVICE')
  GROUP BY user_name
  HAVING admin_query_count > 10;
```
