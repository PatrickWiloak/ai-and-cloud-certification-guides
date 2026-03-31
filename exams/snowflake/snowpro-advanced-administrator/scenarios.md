# SnowPro Advanced - Administrator - High-Yield Scenarios and Patterns

## Access Control Scenarios

### Enterprise Role Hierarchy Design
**Scenario:** A company with 500 employees across 4 departments (Engineering, Analytics, Finance, Marketing) needs a Snowflake role hierarchy. Each department has read and write users, plus department admins. A central data team manages the platform.

**Solution Pattern:**
- **Access Roles:** Object-level roles (db_reader, db_writer per database)
- **Functional Roles:** User-facing roles (eng_analyst, fin_writer, etc.)
- **Admin Roles:** Department admin roles granted to SYSADMIN
- **Hierarchy:** Functional roles granted access roles, all admin roles granted to SYSADMIN
- **Future Grants:** Auto-grant on new objects to access roles

```sql
-- Access roles (object-level)
CREATE ROLE analytics_db_reader;
CREATE ROLE analytics_db_writer;
GRANT SELECT ON ALL TABLES IN DATABASE analytics_db TO ROLE analytics_db_reader;
GRANT ALL ON ALL TABLES IN DATABASE analytics_db TO ROLE analytics_db_writer;
GRANT SELECT ON FUTURE TABLES IN DATABASE analytics_db TO ROLE analytics_db_reader;

-- Functional roles (user-facing)
CREATE ROLE eng_analyst;
GRANT ROLE analytics_db_reader TO ROLE eng_analyst;
GRANT USAGE ON WAREHOUSE eng_wh TO ROLE eng_analyst;

-- Department admin
CREATE ROLE eng_admin;
GRANT ROLE analytics_db_writer TO ROLE eng_admin;
GRANT ROLE eng_analyst TO ROLE eng_admin;

-- Connect to SYSADMIN
GRANT ROLE eng_admin TO ROLE SYSADMIN;
```

**Common Distractors:**
- Granting ACCOUNTADMIN to department leads (wrong - violates least privilege)
- Single shared role for all departments (wrong - no isolation or audit trail)
- Granting custom roles to ACCOUNTADMIN instead of SYSADMIN (wrong - best practice is SYSADMIN)
- Using only RBAC without future grants (wrong - new objects would be inaccessible)

### Service Account Configuration
**Scenario:** A data pipeline application needs programmatic access to Snowflake. The application runs in a Kubernetes cluster and should authenticate without passwords stored in configuration files.

**Solution Pattern:**
- **Authentication:** Key pair authentication with RSA keys
- **Role:** Dedicated service role with minimum required privileges
- **Network Policy:** Restrict to Kubernetes cluster IP range
- **No MFA:** Service accounts do not use interactive MFA
- **Rotation:** Regular key rotation via automated process

```sql
-- Create service user with key pair auth
CREATE USER pipeline_svc
  DEFAULT_ROLE = pipeline_role
  DEFAULT_WAREHOUSE = pipeline_wh
  RSA_PUBLIC_KEY = 'MIIBIjANBgkq...';

-- Restrict network access
CREATE NETWORK POLICY pipeline_policy
  ALLOWED_IP_LIST = ('10.0.0.0/16');
ALTER USER pipeline_svc SET NETWORK_POLICY = pipeline_policy;
```

**Common Distractors:**
- Using username/password with MFA (wrong - MFA requires interactive approval)
- Storing passwords in Kubernetes secrets (wrong - key pair is more secure, no password to leak)
- Using ACCOUNTADMIN role for the pipeline (wrong - violates least privilege)
- No network policy restriction (wrong - service accounts should be IP-restricted)

## Resource Management Scenarios

### Cost Overrun Prevention
**Scenario:** A company's Snowflake bill has been growing 30% month over month. The CFO requires immediate cost controls and a plan to reduce spend by 20% without impacting critical workloads.

**Solution Pattern:**
1. **Immediate:** Create resource monitors with SUSPEND triggers
2. **Analysis:** Query WAREHOUSE_METERING_HISTORY for top credit consumers
3. **Quick Wins:** Reduce auto-suspend timeout on idle warehouses
4. **Optimization:** Right-size warehouses based on actual usage
5. **Governance:** Implement warehouse-level monitors per team

```sql
-- Identify top credit consumers
SELECT warehouse_name, SUM(credits_used) AS monthly_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATE_TRUNC('month', CURRENT_TIMESTAMP())
GROUP BY warehouse_name
ORDER BY monthly_credits DESC;

-- Find idle warehouses
SELECT warehouse_name,
       SUM(credits_used) AS credits,
       COUNT(DISTINCT DATE_TRUNC('hour', start_time)) AS active_hours
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY warehouse_name
HAVING active_hours < 10;

-- Implement controls
CREATE RESOURCE MONITOR team_a_limit
  WITH CREDIT_QUOTA = 200
  FREQUENCY = WEEKLY
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND;
```

**Common Distractors:**
- Suspending all warehouses immediately (wrong - impacts critical workloads)
- Only setting account-level monitor without per-warehouse controls (wrong - no granular management)
- Reducing warehouse sizes without analyzing workloads (wrong - may cause performance degradation)
- Relying on email notifications only (wrong - SUSPEND triggers needed for hard limits)

### Multi-Cluster Warehouse Sizing
**Scenario:** An analytics team of 50 users runs ad-hoc queries during business hours (8 AM - 6 PM). During peak hours, users report long query queue times. Current setup is a single Large warehouse.

**Solution Pattern:**
- **Diagnosis:** Queue times indicate concurrency bottleneck
- **Solution:** Convert to multi-cluster warehouse with auto-scaling
- **Configuration:** Min 1, Max 4 clusters, Standard scaling policy
- **Schedule:** Auto-suspend during non-business hours
- **Monitor:** Resource monitor for cost control

```sql
ALTER WAREHOUSE analytics_wh SET
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 4
  SCALING_POLICY = 'STANDARD'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;

-- Schedule-based management
CREATE TASK start_analytics
  SCHEDULE = 'USING CRON 0 8 * * 1-5 America/New_York'
AS ALTER WAREHOUSE analytics_wh SET MIN_CLUSTER_COUNT = 2;

CREATE TASK reduce_analytics
  SCHEDULE = 'USING CRON 0 18 * * 1-5 America/New_York'
AS ALTER WAREHOUSE analytics_wh SET MIN_CLUSTER_COUNT = 1;
```

**Common Distractors:**
- Scaling up to XL warehouse (wrong - larger size does not improve concurrency)
- Creating separate warehouses per user (wrong - unmanageable, wasteful)
- Setting MAX_CLUSTER_COUNT very high without monitors (wrong - uncontrolled cost)
- Using Economy scaling policy for performance-sensitive users (wrong - Economy tolerates longer queues)

## Security Scenarios

### Data Breach Response
**Scenario:** An administrator notices unusual query patterns in ACCESS_HISTORY suggesting a compromised user account. The account is querying sensitive tables it does not normally access.

**Solution Pattern:**
1. **Immediate:** Disable the compromised user account
2. **Investigate:** Query LOGIN_HISTORY for unusual login sources
3. **Audit:** Query ACCESS_HISTORY for data accessed by the user
4. **Contain:** Review and revoke unnecessary grants
5. **Remediate:** Reset credentials, enable MFA, add network policy

```sql
-- Disable user immediately
ALTER USER suspicious_user SET DISABLED = TRUE;

-- Check login sources
SELECT user_name, client_ip, reported_client_type, event_timestamp
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE user_name = 'SUSPICIOUS_USER'
  AND event_timestamp >= DATEADD('day', -30, CURRENT_TIMESTAMP())
ORDER BY event_timestamp DESC;

-- Check data access
SELECT user_name, direct_objects_accessed, base_objects_accessed,
       query_start_time
FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
WHERE user_name = 'SUSPICIOUS_USER'
  AND query_start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
ORDER BY query_start_time DESC;
```

**Common Distractors:**
- Only changing the password without disabling (wrong - attacker may have active sessions)
- Dropping the user (wrong - destroys audit trail and owned objects)
- Waiting to investigate before disabling (wrong - containment is first priority)
- Only checking QUERY_HISTORY (wrong - ACCESS_HISTORY shows object-level access)

### Compliance Audit Preparation
**Scenario:** The company is preparing for a SOC 2 audit. Auditors need to verify access controls, data encryption, and activity logging. The administrator must provide evidence of security controls.

**Solution Pattern:**
- **Access Controls:** Export role hierarchy, grants, and user assignments
- **Encryption:** Document Snowflake's default AES-256 encryption
- **Activity Logs:** Provide LOGIN_HISTORY and ACCESS_HISTORY data
- **Network Security:** Document network policies and Private Link config
- **MFA:** Show MFA enforcement for privileged users

```sql
-- Role hierarchy documentation
SELECT grantee_name, role, granted_by, created_on
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE deleted_on IS NULL
ORDER BY role, grantee_name;

-- User listing with security settings
SELECT name, login_name, default_role, has_rsa_public_key,
       ext_authn_duo, last_success_login
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS
WHERE deleted_on IS NULL;

-- Login activity summary
SELECT DATE_TRUNC('day', event_timestamp) AS login_date,
       user_name, COUNT(*) AS login_count,
       COUNT_IF(is_success = 'NO') AS failed_count
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE event_timestamp >= DATEADD('month', -12, CURRENT_TIMESTAMP())
GROUP BY 1, 2
ORDER BY 1, 2;
```

**Common Distractors:**
- Saying Snowflake handles all compliance automatically (wrong - customer responsibilities exist)
- Not documenting network policies (wrong - auditors need evidence of network controls)
- Only providing current state (wrong - auditors need historical activity logs)
- Ignoring MFA for privileged accounts (wrong - SOC 2 expects strong auth for admins)

## Performance Scenarios

### Identifying Query Performance Issues
**Scenario:** Users report that a dashboard query that used to take 5 seconds now takes 2 minutes. No changes were made to the query or warehouse.

**Solution Pattern:**
1. **Check data growth:** Table may have grown significantly
2. **Check clustering:** Clustering may have degraded from DML operations
3. **Check cache:** Result cache may have been invalidated
4. **Check concurrency:** Other queries may be competing for resources
5. **Check Query Profile:** Compare recent vs historical execution plans

```sql
-- Compare query execution over time
SELECT DATE_TRUNC('day', start_time) AS day,
       AVG(execution_time)/1000 AS avg_seconds,
       AVG(bytes_scanned)/1024/1024/1024 AS avg_gb_scanned,
       AVG(partitions_scanned) AS avg_partitions
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text LIKE '%dashboard_query%'
  AND start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 1;

-- Check table growth
SELECT table_name, active_bytes/1024/1024/1024 AS gb_active
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE table_name = 'LARGE_FACT_TABLE';
```

**Common Distractors:**
- Immediately scaling up the warehouse (wrong - diagnose before acting)
- Blaming Snowflake infrastructure (wrong - check data and clustering first)
- Adding an index (wrong - Snowflake does not support traditional indexes)
- Recreating the table (wrong - would not address the root cause)

## Key Decision Factors

### Administration Decision Guide
1. **Access issues:** Check role grants, future grants, and privilege hierarchy
2. **Cost overruns:** Resource monitors with SUSPEND, ACCOUNT_USAGE analysis
3. **Performance degradation:** Query Profile, clustering info, data growth
4. **Security incidents:** Disable user first, then investigate LOGIN_HISTORY and ACCESS_HISTORY
5. **Compliance audits:** GRANTS_TO_ROLES, LOGIN_HISTORY, ACCESS_HISTORY, network policies
6. **Concurrency issues:** Multi-cluster warehouse with Standard scaling policy
7. **Storage costs:** Time Travel retention, transient tables, unused object cleanup
