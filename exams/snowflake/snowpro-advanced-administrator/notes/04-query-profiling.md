# Query Profiling and Performance Monitoring

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Profile analysis guide

## Overview

This document covers query profiling, ACCOUNT_USAGE monitoring views, caching strategies, and performance troubleshooting. Understanding how to diagnose and resolve performance issues is a key skill tested on the Advanced Administrator exam.

## Query Profile

### Accessing the Query Profile
- Available in Snowflake web UI under Activity > Query History
- Click on any query to see its profile
- Shows operator tree, statistics, and execution details
- Also available via GET_QUERY_OPERATOR_STATS table function

### Operator Tree
- Visual representation of the execution plan
- Each node represents an operation (scan, join, filter, aggregate, sort)
- Data flows from bottom to top
- Width of arrows indicates data volume
- Color coding indicates relative execution time

### Key Operators
| Operator | Function | What to Look For |
|----------|----------|-----------------|
| TableScan | Reads from table | Partitions scanned vs total |
| Filter | Applies WHERE conditions | Rows filtered out |
| Join | Combines tables | Join type, row count explosion |
| Aggregate | GROUP BY operations | Output rows vs input rows |
| Sort | ORDER BY operations | Spilling to disk |
| Result | Returns to client | Network bytes sent |
| WithClause | CTE evaluation | Multiple evaluations |

### Performance Indicators

#### Pruning Metrics (TableScan)
```
Partitions scanned: 150
Partitions total: 10,000
Percentage scanned: 1.5%  -- Good (< 10-20% is ideal)
```

- Low percentage scanned = effective pruning
- High percentage scanned = clustering may be needed
- 100% scanned = filter not aligned with data organization

#### Spilling Metrics (Join/Sort)
```
Bytes spilled to local storage: 2.5 GB
Bytes spilled to remote storage: 0 B
```

- Local spilling = moderate memory pressure (SSD overflow)
- Remote spilling = severe memory pressure (cloud storage overflow)
- Both indicate warehouse may need to be scaled up

#### Join Explosion
```
Input rows (left): 1,000,000
Input rows (right): 500,000
Output rows: 50,000,000  -- 100x explosion!
```

- Output exceeding product of inputs = cartesian product
- Usually caused by missing or incorrect join conditions
- Fix: verify join keys and add proper conditions

### Common Performance Issues Summary
| Issue | Symptom | Root Cause | Fix |
|-------|---------|------------|-----|
| Full table scan | High partitions scanned % | No clustering or wrong filters | Add clustering key |
| Spilling (local) | Bytes spilled to local | Insufficient memory | Scale up warehouse |
| Spilling (remote) | Bytes spilled to remote | Severely insufficient memory | Scale up significantly |
| Join explosion | Output >> input rows | Missing join condition | Fix join predicate |
| Long queue time | High queue duration | Concurrency bottleneck | Multi-cluster warehouse |
| Slow compilation | High compilation time | Complex query | Simplify or break into parts |

## ACCOUNT_USAGE Views

### Key Views and Latency
| View | Latency | Retention | Purpose |
|------|---------|-----------|---------|
| QUERY_HISTORY | 45 min | 365 days | Query execution details |
| WAREHOUSE_METERING_HISTORY | 3 hours | 365 days | Warehouse credit usage |
| STORAGE_USAGE | 3 hours | 365 days | Storage consumption |
| LOGIN_HISTORY | 2 hours | 365 days | Authentication events |
| ACCESS_HISTORY | 3 hours | 365 days | Data access audit |
| COPY_HISTORY | 45 min | 365 days | Data loading history |
| TASK_HISTORY | 45 min | 365 days | Task execution history |
| GRANTS_TO_ROLES | 3 hours | 365 days | Role privilege grants |
| GRANTS_TO_USERS | 3 hours | 365 days | User role assignments |
| TABLE_STORAGE_METRICS | 3 hours | N/A | Table-level storage |

**[📖 Account Usage](https://docs.snowflake.com/en/sql-reference/account-usage)** - All usage views

### INFORMATION_SCHEMA vs ACCOUNT_USAGE
| Feature | INFORMATION_SCHEMA | ACCOUNT_USAGE |
|---------|-------------------|---------------|
| Latency | Real-time | 45 min to 3 hours |
| Retention | 7-14 days | 365 days |
| Scope | Per-database | Entire account |
| Access | Any role with grants | ACCOUNTADMIN (or granted) |
| Performance | Session-specific | Pre-computed |

### Common Monitoring Queries

#### Slow Query Detection
```sql
SELECT query_id, query_text, user_name, warehouse_name,
       execution_time/1000 AS exec_seconds,
       bytes_scanned/1024/1024/1024 AS gb_scanned,
       partitions_scanned, partitions_total,
       ROUND(partitions_scanned/NULLIF(partitions_total, 0) * 100, 2) AS pct_scanned
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('day', -1, CURRENT_TIMESTAMP())
  AND execution_time > 60000
  AND query_type IN ('SELECT', 'INSERT', 'CREATE_TABLE_AS_SELECT')
ORDER BY execution_time DESC
LIMIT 20;
```

#### User Activity Analysis
```sql
SELECT user_name,
       COUNT(*) AS query_count,
       AVG(execution_time)/1000 AS avg_seconds,
       SUM(bytes_scanned)/1024/1024/1024 AS total_gb_scanned,
       SUM(credits_used_cloud_services) AS cloud_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
GROUP BY user_name
ORDER BY total_gb_scanned DESC
LIMIT 20;
```

#### Failed Query Analysis
```sql
SELECT error_code, error_message,
       COUNT(*) AS failure_count,
       ARRAY_AGG(DISTINCT user_name) AS affected_users
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
  AND execution_status = 'FAIL'
GROUP BY error_code, error_message
ORDER BY failure_count DESC;
```

## Caching Strategy

### Result Cache Management
```sql
-- Disable result cache for a session (testing purposes)
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

-- Check if query used result cache
SELECT query_id, query_text, execution_status,
       CASE WHEN bytes_scanned = 0 AND rows_produced > 0
            THEN 'RESULT_CACHE_HIT' ELSE 'COMPUTED' END AS cache_status
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('hour', -1, CURRENT_TIMESTAMP())
ORDER BY start_time DESC;
```

### Result Cache Invalidation
- Underlying data changes (DML on source tables)
- 24 hours since last cache entry
- Different user or role executes the same query
- Query text differs (even whitespace changes)
- Session parameter changes that affect results

### Cache Optimization Recommendations
1. **Standardize queries:** Use consistent SQL text for cache hits
2. **Balance auto-suspend:** Longer = better local disk cache, higher cost
3. **Workload routing:** Same queries to same warehouse for cache locality
4. **Avoid unnecessary DISTINCT/ORDER BY:** May prevent cache reuse
5. **Monitor cache effectiveness:** Track bytes_scanned = 0 queries

## Clustering Management

### Monitoring Clustering Effectiveness
```sql
-- Check clustering information
SELECT SYSTEM$CLUSTERING_INFORMATION('my_db.public.large_table', '(date_col, region_col)');

-- Clustering history and cost
SELECT table_name, SUM(credits_used) AS clustering_credits,
       SUM(num_rows_reclustered) AS rows_reclustered
FROM SNOWFLAKE.ACCOUNT_USAGE.AUTOMATIC_CLUSTERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY table_name
ORDER BY clustering_credits DESC;
```

### Clustering Key Management
```sql
-- Add clustering key
ALTER TABLE large_facts CLUSTER BY (sale_date, region);

-- Change clustering key
ALTER TABLE large_facts CLUSTER BY (sale_date, product_category);

-- Remove clustering key
ALTER TABLE large_facts DROP CLUSTERING KEY;

-- Suspend reclustering (save credits while investigating)
ALTER TABLE large_facts SUSPEND RECLUSTER;

-- Resume reclustering
ALTER TABLE large_facts RESUME RECLUSTER;
```

### When to Cluster
| Indicator | Value | Action |
|-----------|-------|--------|
| Table size | > 1 TB | Consider clustering |
| Pruning % | > 50% partitions scanned | Clustering needed |
| Clustering depth | > 5 | Reclustering needed |
| Overlap | High | Reclustering needed |
| DML frequency | High | Monitor degradation |

## Health Check Dashboard Queries

```sql
-- Daily health check summary
SELECT 'Active Queries' AS metric, COUNT(*) AS value
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE())
WHERE execution_status = 'RUNNING'
UNION ALL
SELECT 'Failed Queries (24h)', COUNT(*)
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE execution_status = 'FAIL'
  AND start_time >= DATEADD('day', -1, CURRENT_TIMESTAMP())
UNION ALL
SELECT 'Failed Logins (24h)', COUNT(*)
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE is_success = 'NO'
  AND event_timestamp >= DATEADD('day', -1, CURRENT_TIMESTAMP())
UNION ALL
SELECT 'Credits Used (today)', SUM(credits_used)::VARCHAR
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATE_TRUNC('day', CURRENT_TIMESTAMP());
```
