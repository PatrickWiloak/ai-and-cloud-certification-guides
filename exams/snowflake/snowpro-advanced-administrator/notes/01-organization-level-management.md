# Organization-Level Management

**[📖 Organizations](https://docs.snowflake.com/en/user-guide/organizations)** - Organization management

## Overview

This document covers Snowflake organization-level management, including ORGADMIN capabilities, account management, parameter hierarchy, billing, and multi-account governance. Understanding organization-level administration is essential for the Advanced Administrator exam.

## Snowflake Organizations

### Organization Structure
- An organization groups multiple Snowflake accounts under centralized management
- Each account operates independently with its own users, roles, and data
- Organization enables cross-account operations: replication, failover, data sharing
- Centralized billing rolls up usage from all accounts
- ORGADMIN role manages the organization without accessing account data

**[📖 Managing Organizations](https://docs.snowflake.com/en/user-guide/organizations-manage-accounts)** - Account management

### ORGADMIN Role
```sql
-- Switch to ORGADMIN role
USE ROLE ORGADMIN;

-- List all accounts in the organization
SHOW ORGANIZATION ACCOUNTS;

-- Create a new account
CREATE ACCOUNT dev_account
  ADMIN_NAME = 'admin'
  ADMIN_PASSWORD = 'StrongPassword123!'
  EMAIL = 'admin@company.com'
  EDITION = 'ENTERPRISE'
  REGION = 'AWS_US_EAST_1';

-- View organization usage
SELECT * FROM SNOWFLAKE.ORGANIZATION_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP());
```

### ORGADMIN Capabilities
| Can Do | Cannot Do |
|--------|-----------|
| Create accounts | Access data in accounts |
| Drop accounts | Manage users within accounts |
| Enable replication | Execute queries on account databases |
| View organization billing | Modify account-level settings |
| Set organization properties | Grant roles within accounts |

### ORGANIZATION_USAGE Schema
| View | Purpose |
|------|---------|
| WAREHOUSE_METERING_HISTORY | Credit usage per warehouse across accounts |
| STORAGE_USAGE | Storage consumption across accounts |
| DATA_TRANSFER_HISTORY | Cross-region/cross-cloud transfer costs |
| AUTOMATIC_CLUSTERING_HISTORY | Clustering credit usage across accounts |
| MATERIALIZED_VIEW_REFRESH_HISTORY | MV refresh costs across accounts |
| PIPE_USAGE_HISTORY | Snowpipe costs across accounts |

**[📖 Organization Usage](https://docs.snowflake.com/en/sql-reference/organization-usage)** - Cross-account usage views

## Account Management

### Account Types and Editions
| Edition | Key Features | Use Case |
|---------|-------------|----------|
| Standard | Core features, 1-day Time Travel | Development, small teams |
| Enterprise | Multi-cluster, 90-day TT, masking, row access | Production workloads |
| Business Critical | Private Link, Tri-Secret, HIPAA, failover | Regulated industries |
| VPS | Dedicated infrastructure, isolated metadata | Highest security needs |

**[📖 Editions](https://docs.snowflake.com/en/user-guide/intro-editions)** - Edition comparison

### Account Lifecycle
```sql
-- Create account
CREATE ACCOUNT staging_account
  ADMIN_NAME = 'staging_admin'
  ADMIN_PASSWORD = 'Password123!'
  EMAIL = 'staging@company.com'
  EDITION = 'ENTERPRISE'
  REGION = 'AWS_US_WEST_2';

-- Rename account
ALTER ACCOUNT staging_account RENAME TO staging_v2;

-- Drop account (25 days to recover)
DROP ACCOUNT old_test_account;

-- Undrop account (within 25 days)
UNDROP ACCOUNT old_test_account;
```

### Account Identifiers
- **Account Name:** Human-readable name within the organization
- **Account Locator:** Legacy identifier (alphanumeric, region-specific)
- **Organization URL:** org_name-account_name.snowflakecomputing.com
- **Account URL:** account_locator.region.cloud.snowflakecomputing.com

## Parameter Hierarchy

### Parameter Levels
```
Account Parameters (broadest scope)
  └── User Parameters
        └── Session Parameters (narrowest scope)
              └── Object Parameters (per-object settings)
```

### Account Parameters
```sql
-- View all account parameters
SHOW PARAMETERS IN ACCOUNT;

-- Common account parameters
ALTER ACCOUNT SET
  STATEMENT_TIMEOUT_IN_SECONDS = 172800        -- 48 hours max query time
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 0      -- No queue timeout
  NETWORK_POLICY = 'corp_policy'               -- Default network policy
  REQUIRE_STORAGE_INTEGRATION_FOR_STAGE_CREATION = TRUE  -- Security
  ENABLE_ACCOUNT_DATABASE_REPLICATION = TRUE    -- Allow replication
  MIN_DATA_RETENTION_TIME_IN_DAYS = 1;         -- Minimum Time Travel
```

**[📖 Parameters](https://docs.snowflake.com/en/sql-reference/parameters)** - Complete parameter reference

### Key Parameters by Category
| Category | Parameter | Default | Description |
|----------|----------|---------|-------------|
| Query | STATEMENT_TIMEOUT_IN_SECONDS | 172800 | Max query execution time |
| Query | STATEMENT_QUEUED_TIMEOUT_IN_SECONDS | 0 | Max queue wait time |
| Cache | USE_CACHED_RESULT | TRUE | Enable result cache |
| Security | REQUIRE_STORAGE_INTEGRATION_FOR_STAGE_CREATION | FALSE | Force storage integration |
| Data | DATA_RETENTION_TIME_IN_DAYS | 1 | Time Travel retention |
| Data | MAX_DATA_EXTENSION_TIME_IN_DAYS | 14 | Extended Time Travel |
| Session | TIMEZONE | 'America/Los_Angeles' | Default timezone |
| Session | ROWS_PER_RESULTSET | 0 | Max rows returned (0=unlimited) |

### Parameter Override Rules
1. Object-level parameter overrides account default for that object
2. Session-level parameter overrides account/user default for that session
3. Not all parameters can be set at all levels
4. Some parameters are read-only (set by Snowflake)

```sql
-- Set at different levels
ALTER ACCOUNT SET STATEMENT_TIMEOUT_IN_SECONDS = 172800;  -- Account
ALTER USER analyst SET STATEMENT_TIMEOUT_IN_SECONDS = 3600;  -- User
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 1800;  -- Session
ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 7200;  -- Object
```

## Billing and Usage

### Credit Types
| Credit Type | Source | Billing Model |
|-------------|--------|---------------|
| Warehouse credits | User queries and DML | Per-second, per-warehouse |
| Serverless credits | Snowpipe, tasks, clustering | Per-operation |
| Cloud services credits | Query compilation, metadata | Free up to 10% of warehouse |

### Usage Monitoring
```sql
-- Monthly credit breakdown by service
SELECT service_type, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE start_time >= DATE_TRUNC('month', CURRENT_TIMESTAMP())
GROUP BY service_type
ORDER BY total_credits DESC;

-- Daily credit trend
SELECT DATE_TRUNC('day', start_time) AS day,
       warehouse_name,
       SUM(credits_used) AS credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP())
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- Storage breakdown
SELECT DATE_TRUNC('month', usage_date) AS month,
       AVG(storage_bytes)/1024/1024/1024/1024 AS avg_tb,
       AVG(stage_bytes)/1024/1024/1024/1024 AS avg_stage_tb,
       AVG(failsafe_bytes)/1024/1024/1024/1024 AS avg_failsafe_tb
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE
WHERE usage_date >= DATEADD('month', -6, CURRENT_DATE())
GROUP BY 1
ORDER BY 1;
```

### Cloud Services Credit
- Cloud services include: query compilation, metadata operations, login, SHOW commands
- Free up to 10% of daily warehouse credit consumption
- Only charged for cloud services exceeding the 10% threshold
- Monitor with METERING_HISTORY where service_type = 'CLOUD_SERVICES'

### Cross-Account Billing
```sql
-- Organization-level billing (requires ORGADMIN)
USE ROLE ORGADMIN;

SELECT account_name, service_type,
       SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ORGANIZATION_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATE_TRUNC('month', CURRENT_TIMESTAMP())
GROUP BY 1, 2
ORDER BY 3 DESC;
```

## Multi-Account Governance

### Account Naming Conventions
| Environment | Naming Pattern | Example |
|------------|---------------|---------|
| Production | {company}_{region}_prod | acme_useast1_prod |
| Staging | {company}_{region}_staging | acme_useast1_staging |
| Development | {company}_{region}_dev | acme_useast1_dev |
| Analytics | {company}_{region}_analytics | acme_useast1_analytics |

### Governance Patterns
1. **Centralized security:** Security team manages SECURITYADMIN across accounts
2. **Federated data:** Shared datasets via data sharing between accounts
3. **Environment isolation:** Separate accounts for dev/staging/prod
4. **Regional deployment:** Accounts per region for data residency compliance
5. **Cost allocation:** Resource monitors per account for budget management

### Replication Management
```sql
-- Enable replication from ORGADMIN
ALTER ACCOUNT prod_account ENABLE REPLICATION TO ACCOUNTS staging_account;

-- From source account: enable database replication
ALTER DATABASE analytics ENABLE REPLICATION TO ACCOUNTS org.staging_account;

-- From target account: create replica
CREATE DATABASE analytics AS REPLICA OF org.prod_account.analytics;

-- Monitor replication
SELECT * FROM TABLE(INFORMATION_SCHEMA.DATABASE_REPLICATION_USAGE_HISTORY());
```

**[📖 Replication](https://docs.snowflake.com/en/user-guide/account-replication-intro)** - Replication overview
