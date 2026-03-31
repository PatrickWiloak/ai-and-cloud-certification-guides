# SnowPro Advanced - Administrator - Fact Sheet

## Quick Reference

**Exam Code:** ADA-C01
**Duration:** 115 minutes
**Questions:** 65 questions
**Passing Score:** 750/1000
**Cost:** $375 USD
**Validity:** 2 years
**Prerequisite:** SnowPro Core (active)
**Difficulty:** ⭐⭐⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Account and Organization Management | 20-25% | ORGADMIN, parameters, replication |
| Security and Access Control | 25-30% | RBAC, network security, governance |
| Resource Management and Cost Control | 20-25% | Resource monitors, warehouses, credits |
| Performance Monitoring and Tuning | 15-20% | Query Profile, caching, clustering |
| Data Management and Compliance | 10-15% | Time Travel, Fail-safe, audit |

## Organization-Level Management

### ORGADMIN Role
- Top-level organization administrator
- Creates and manages Snowflake accounts within the organization
- Views usage and billing across all accounts
- Enables features at the organization level
- Cannot access data within individual accounts
- **[📖 Organizations](https://docs.snowflake.com/en/user-guide/organizations)** - Organization management

### System-Defined Roles
| Role | Responsibilities | Inherits From |
|------|-----------------|---------------|
| ORGADMIN | Organization management | None (org-level) |
| ACCOUNTADMIN | Account-level superuser | SECURITYADMIN, SYSADMIN |
| SECURITYADMIN | Users, roles, grants | USERADMIN |
| USERADMIN | User and role creation | None |
| SYSADMIN | Databases, warehouses, objects | None |
| PUBLIC | Default role for all users | None |

**[📖 System Roles](https://docs.snowflake.com/en/user-guide/security-access-control-overview)** - Role hierarchy

### Parameter Management
| Level | Scope | Set By | Example |
|-------|-------|--------|---------|
| Account | All sessions in account | ACCOUNTADMIN | STATEMENT_TIMEOUT_IN_SECONDS |
| Session | Current session only | User | USE_CACHED_RESULT |
| Object | Specific object | Object owner | DATA_RETENTION_TIME_IN_DAYS |

```sql
-- Set account parameter
ALTER ACCOUNT SET STATEMENT_TIMEOUT_IN_SECONDS = 172800;

-- Set session parameter
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

-- Set object parameter
ALTER TABLE my_table SET DATA_RETENTION_TIME_IN_DAYS = 30;

-- View parameters
SHOW PARAMETERS IN ACCOUNT;
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT%' IN ACCOUNT;
```

**[📖 Parameters](https://docs.snowflake.com/en/sql-reference/parameters)** - Parameter reference

## Advanced Access Control

### Role Hierarchy Design
```
ACCOUNTADMIN
  ├── SECURITYADMIN
  │     └── USERADMIN
  ├── SYSADMIN
  │     ├── DATA_ADMIN
  │     │     ├── ETL_ROLE
  │     │     └── DBA_ROLE
  │     ├── ANALYTICS_ADMIN
  │     │     ├── ANALYST_ROLE
  │     │     └── BI_ROLE
  │     └── APP_ADMIN
  │           └── APP_SERVICE_ROLE
  └── PUBLIC
```

### Custom Role Best Practices
- Grant all custom roles to SYSADMIN (ensures ACCOUNTADMIN can access all objects)
- Use functional roles (what users do) mapped to access roles (what objects they touch)
- Avoid granting ACCOUNTADMIN to regular users
- Use database roles for object-level modularity

### Database Roles
```sql
-- Create database role
CREATE DATABASE ROLE analytics_db.reader;
CREATE DATABASE ROLE analytics_db.writer;

-- Grant privileges
GRANT USAGE ON ALL SCHEMAS IN DATABASE analytics_db TO DATABASE ROLE analytics_db.reader;
GRANT SELECT ON ALL TABLES IN DATABASE analytics_db TO DATABASE ROLE analytics_db.reader;

-- Grant database role to account role
GRANT DATABASE ROLE analytics_db.reader TO ROLE analyst_role;
```

**[📖 Database Roles](https://docs.snowflake.com/en/user-guide/security-access-control-database-roles)** - Scoped roles

### Future Grants
```sql
-- Auto-grant SELECT on future tables in schema
GRANT SELECT ON FUTURE TABLES IN SCHEMA my_db.public TO ROLE analyst_role;

-- Auto-grant USAGE on future schemas in database
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE my_db TO ROLE analyst_role;

-- View future grants
SHOW FUTURE GRANTS IN SCHEMA my_db.public;
```

**[📖 Future Grants](https://docs.snowflake.com/en/sql-reference/sql/grant-privilege#future-grants-on-database-or-schema-objects)** - Automatic grants

### Authentication Methods
| Method | Use Case | Configuration |
|--------|----------|---------------|
| Password | Basic authentication | User creation |
| MFA (Multi-Factor) | Enhanced security | TOTP via Duo Mobile |
| SSO (SAML 2.0) | Enterprise SSO | IdP configuration |
| SCIM | Automated provisioning | Okta, Azure AD |
| Key Pair | Programmatic access | RSA key pair |
| OAuth | Third-party app access | OAuth integration |

**[📖 Authentication](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-overview)** - Auth methods

## Resource Monitors

### Configuration
```sql
-- Account-level monitor
CREATE RESOURCE MONITOR company_monthly
  WITH CREDIT_QUOTA = 10000
  FREQUENCY = MONTHLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 50 PERCENT DO NOTIFY
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO SUSPEND
    ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER ACCOUNT SET RESOURCE_MONITOR = company_monthly;

-- Warehouse-level monitor
CREATE RESOURCE MONITOR team_weekly
  WITH CREDIT_QUOTA = 500
  FREQUENCY = WEEKLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 80 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE team_wh SET RESOURCE_MONITOR = team_weekly;
```

**[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Cost control

### Monitor Properties
| Property | Options | Description |
|----------|---------|-------------|
| CREDIT_QUOTA | Integer | Monthly/weekly credit limit |
| FREQUENCY | MONTHLY, DAILY, WEEKLY, YEARLY, NEVER | Reset interval |
| START_TIMESTAMP | IMMEDIATELY or timestamp | When monitoring begins |
| END_TIMESTAMP | Timestamp | When monitoring ends |

### Trigger Actions
| Action | Effect | Running Queries |
|--------|--------|----------------|
| NOTIFY | Send notification only | Continue running |
| SUSPEND | Suspend warehouse | Complete, then suspend |
| SUSPEND_IMMEDIATE | Suspend immediately | Cancelled |

## Query Profiling

### Query Profile Analysis
- Available in Snowflake web UI under Query History
- Shows execution plan as operator tree
- Statistics per operator: rows, bytes, time, partitions
- Identifies common performance issues

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Profile analysis

### Key Metrics to Monitor
```sql
-- Long-running queries
SELECT query_id, query_text, user_name, warehouse_name,
       execution_time/1000 AS exec_seconds,
       bytes_scanned/1024/1024/1024 AS gb_scanned,
       rows_produced
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('day', -1, CURRENT_TIMESTAMP())
  AND execution_time > 60000  -- > 60 seconds
ORDER BY execution_time DESC
LIMIT 20;

-- Warehouse utilization
SELECT warehouse_name,
       DATE_TRUNC('hour', start_time) AS hour,
       SUM(credits_used) AS credits,
       AVG(avg_running) AS avg_queries_running,
       AVG(avg_queued_load) AS avg_queued
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
GROUP BY 1, 2
ORDER BY 1, 2;

-- Failed logins
SELECT user_name, client_ip, reported_client_type,
       error_code, error_message, event_timestamp
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE is_success = 'NO'
  AND event_timestamp >= DATEADD('day', -7, CURRENT_TIMESTAMP())
ORDER BY event_timestamp DESC;
```

### ACCOUNT_USAGE Views
| View | Purpose | Latency |
|------|---------|---------|
| QUERY_HISTORY | Query execution details | 45 minutes |
| WAREHOUSE_METERING_HISTORY | Warehouse credit usage | 3 hours |
| STORAGE_USAGE | Account storage consumption | 3 hours |
| LOGIN_HISTORY | Authentication events | 2 hours |
| ACCESS_HISTORY | Data access audit trail | 3 hours |
| COPY_HISTORY | Data loading history | 45 minutes |
| TASK_HISTORY | Task execution history | 45 minutes |

**[📖 Account Usage](https://docs.snowflake.com/en/sql-reference/account-usage)** - Usage views

## Data Management and Compliance

### Time Travel
| Table Type | Default Retention | Max Retention |
|-----------|-------------------|---------------|
| Permanent (Standard) | 1 day | 1 day |
| Permanent (Enterprise+) | 1 day | 90 days |
| Transient | 0 or 1 day | 1 day |
| Temporary | 0 or 1 day | 1 day |

```sql
-- Set Time Travel retention
ALTER TABLE my_table SET DATA_RETENTION_TIME_IN_DAYS = 30;

-- Query historical data
SELECT * FROM my_table AT(TIMESTAMP => '2024-01-15 10:00:00'::TIMESTAMP);
SELECT * FROM my_table AT(OFFSET => -3600);  -- 1 hour ago
SELECT * FROM my_table BEFORE(STATEMENT => '<query_id>');

-- Undrop table
UNDROP TABLE accidentally_dropped_table;
```

**[📖 Time Travel](https://docs.snowflake.com/en/user-guide/data-time-travel)** - Time Travel documentation

### Fail-safe
- 7-day protection period after Time Travel expires
- Snowflake-managed, not user-accessible
- Recovery requires contacting Snowflake support
- Not available for transient or temporary tables
- Adds to storage costs

### Data Classification
```sql
-- Classify data with tags
CREATE TAG data_classification ALLOWED_VALUES 'PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED';
ALTER TABLE customers SET TAG data_classification = 'CONFIDENTIAL';
ALTER TABLE customers MODIFY COLUMN ssn SET TAG data_classification = 'RESTRICTED';

-- View classification
SELECT * FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES(
  'customers', 'TABLE'
));
```

**[📖 Data Classification](https://docs.snowflake.com/en/user-guide/governance-classify)** - Classification guide

## Exam Tips

### High-Value Topics
1. **Security (25-30%):** RBAC design, network policies, governance, audit
2. **Account Management (20-25%):** ORGADMIN, parameters, organization structure
3. **Resource Management (20-25%):** Monitors, warehouse strategy, cost control
4. **Performance (15-20%):** Query Profile, ACCOUNT_USAGE views, caching
5. **Compliance (10-15%):** Time Travel, Fail-safe, data classification

### Common Exam Traps
- Confusing SECURITYADMIN (manages grants) with USERADMIN (creates users/roles)
- Not knowing that SYSADMIN should be granted all custom roles
- Thinking resource monitors can track serverless credits (they track warehouse credits)
- Confusing account parameters with session parameters
- Not knowing Time Travel max retention by edition (1 day Standard, 90 days Enterprise+)
- Thinking Fail-safe is user-accessible (it requires Snowflake support)
- Forgetting that transient tables have no Fail-safe protection
- Not knowing ACCOUNT_USAGE view latency (most are 2-3 hours behind)
