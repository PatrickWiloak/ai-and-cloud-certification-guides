# Advanced Performance Tuning

**[📖 Performance Optimization](https://docs.snowflake.com/en/user-guide/performance-query)** - Query optimization guide

## Overview

This document covers advanced performance tuning in Snowflake including warehouse strategy, Query Profile analysis, caching behavior, resource monitors, and cost optimization. Performance tuning is a critical skill for the Advanced Architect exam, with questions testing both diagnostic ability and solution design.

## Virtual Warehouse Strategy

### Warehouse Sizing Guidelines
| Workload Type | Size Recommendation | Reasoning |
|--------------|-------------------|-----------|
| Ad-hoc analyst queries | XS to S | Simple queries, low concurrency |
| BI dashboard refresh | S to M | Moderate complexity, concurrent users |
| ETL/ELT pipelines | M to L | Complex joins, large data volumes |
| Large data loads (COPY INTO) | L to XL | Bulk data processing |
| ML training (Snowpark) | L to 2XL | Memory-intensive operations |
| Complex analytics | L to XL | Multi-table joins, window functions |

**[📖 Warehouse Sizing](https://docs.snowflake.com/en/user-guide/warehouses-considerations)** - Sizing best practices

### Scaling Up vs Scaling Out
| Approach | When to Use | Effect |
|----------|------------|--------|
| Scale Up (larger size) | Complex queries, spilling | More compute and memory per query |
| Scale Out (multi-cluster) | High concurrency, queue times | More parallel query capacity |
| Both | Complex queries + high concurrency | Combined benefits |

### Multi-Cluster Warehouse Configuration
```sql
-- Create multi-cluster warehouse
CREATE WAREHOUSE analytics_mc
  WAREHOUSE_SIZE = 'MEDIUM'
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 5
  SCALING_POLICY = 'STANDARD'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;
```

**[📖 Multi-Cluster Warehouses](https://docs.snowflake.com/en/user-guide/warehouses-multicluster)** - Multi-cluster configuration

### Scaling Policies
| Policy | Behavior | Use Case |
|--------|----------|----------|
| Standard | Start cluster when query queued, shut down after 2-3 checks | Performance-sensitive workloads |
| Economy | Start cluster only after 6 minutes of queueing | Cost-sensitive workloads |

- Standard: favors performance, starts clusters quickly
- Economy: favors cost savings, tolerates some queueing
- Both policies shut down clusters when load decreases
- Cluster start/stop decisions based on query queue depth

### Auto-Suspend and Auto-Resume
```sql
-- Configure auto-suspend (seconds)
ALTER WAREHOUSE my_wh SET AUTO_SUSPEND = 60;    -- Suspend after 1 minute idle
ALTER WAREHOUSE my_wh SET AUTO_RESUME = TRUE;    -- Resume on query submission

-- Warehouse scheduling via tasks
CREATE TASK start_warehouse
  SCHEDULE = 'USING CRON 0 8 * * 1-5 America/New_York'
AS
  ALTER WAREHOUSE analytics_wh RESUME;

CREATE TASK stop_warehouse
  SCHEDULE = 'USING CRON 0 20 * * 1-5 America/New_York'
AS
  ALTER WAREHOUSE analytics_wh SUSPEND;
```

- Minimum auto-suspend: 60 seconds (or 0 for immediate)
- Suspended warehouses consume zero credits
- Resuming a warehouse takes a few seconds
- Short auto-suspend saves cost but clears local disk cache

## Query Profile Analysis

### Reading the Query Profile
- Available in Snowflake web UI under Query History
- Shows operator tree with execution steps
- Each operator shows rows processed, execution time, and statistics
- Identify bottlenecks by finding operators with highest execution time

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Profile analysis guide

### Common Performance Issues

#### 1. Spilling to Local Storage
- **Symptom:** "Bytes spilled to local storage" in Query Profile
- **Cause:** Intermediate results exceed warehouse memory
- **Fix:** Scale up warehouse size for more memory
- **Prevention:** Optimize joins, reduce intermediate result sets

#### 2. Spilling to Remote Storage
- **Symptom:** "Bytes spilled to remote storage" in Query Profile
- **Cause:** Intermediate results exceed both memory and local SSD
- **Fix:** Significantly scale up warehouse size
- **Prevention:** Break complex queries into stages, filter early

#### 3. Exploding Joins
- **Symptom:** Output rows far exceed input rows, long execution
- **Cause:** Missing or incorrect join conditions (cartesian product)
- **Fix:** Add proper join conditions, verify join keys
- **Prevention:** Always validate join cardinality expectations

#### 4. Poor Partition Pruning
- **Symptom:** High ratio of partitions scanned to total partitions
- **Cause:** Filters on non-clustered columns
- **Fix:** Add clustering keys on frequently filtered columns
- **Prevention:** Design clustering strategy based on query patterns

#### 5. Queuing
- **Symptom:** Long "Queue" time in Query Profile
- **Cause:** All warehouse threads occupied by concurrent queries
- **Fix:** Add multi-cluster scaling or separate workloads
- **Prevention:** Right-size concurrency with multi-cluster warehouses

### Query Profile Statistics
| Metric | Location | What It Tells You |
|--------|----------|------------------|
| Partitions scanned vs total | TableScan operator | Pruning effectiveness |
| Bytes spilled (local) | Join/Sort operators | Memory pressure |
| Bytes spilled (remote) | Join/Sort operators | Severe memory pressure |
| Rows produced vs input | Join operators | Join explosion risk |
| Network bytes sent | Result operator | Result set size |
| Queue time | Overview | Concurrency bottleneck |
| Compilation time | Overview | Query complexity |

## Caching Deep Dive

### Result Cache
- Stores query results for 24 hours
- Exact query text match required (including whitespace)
- Invalidated when underlying data changes
- No warehouse needed - served from cloud services
- Same user and role required for cache hit
- Persists through warehouse suspend/resume

**[📖 Result Cache](https://docs.snowflake.com/en/user-guide/querying-persisted-results)** - Result caching behavior

### Local Disk Cache (SSD)
- Stores recently accessed micro-partitions on warehouse SSD
- Faster than reading from remote cloud storage
- Cache populated as queries scan data
- Cleared when warehouse is suspended
- Each cluster in a multi-cluster warehouse has its own cache
- Benefit: subsequent queries on same data are faster

### Remote Disk Cache
- Cloud storage layer (S3, Azure Blob, GCS)
- Persistent across warehouse suspend/resume
- Slowest cache tier but always available
- Shared across all warehouses in the account

### Cache Optimization Strategies
1. **Result Cache:** Use consistent query text, avoid unnecessary variations
2. **Local Disk Cache:** Balance auto-suspend timeout vs cache retention
3. **Warehouse Routing:** Route similar queries to the same warehouse for cache hits
4. **Separate Warehouses:** Different workloads on different warehouses to avoid cache eviction

## Resource Monitors

### Configuration
```sql
-- Account-level resource monitor
CREATE RESOURCE MONITOR account_monthly
  WITH CREDIT_QUOTA = 5000
  FREQUENCY = MONTHLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 50 PERCENT DO NOTIFY
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO SUSPEND
    ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Assign to account
ALTER ACCOUNT SET RESOURCE_MONITOR = account_monthly;

-- Warehouse-level resource monitor
CREATE RESOURCE MONITOR etl_monitor
  WITH CREDIT_QUOTA = 1000
  FREQUENCY = WEEKLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 80 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE etl_wh SET RESOURCE_MONITOR = etl_monitor;
```

**[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Cost control

### Trigger Actions
| Action | Behavior |
|--------|----------|
| NOTIFY | Send notification, no disruption |
| SUSPEND | Suspend warehouse after current queries complete |
| SUSPEND_IMMEDIATE | Suspend warehouse immediately, cancel running queries |

### Monitoring and Alerting
```sql
-- Credit usage by warehouse
SELECT warehouse_name, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP())
GROUP BY warehouse_name
ORDER BY total_credits DESC;

-- Query execution history
SELECT query_type, COUNT(*) AS query_count,
       AVG(execution_time)/1000 AS avg_seconds,
       SUM(bytes_scanned)/1024/1024/1024 AS total_gb_scanned
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
GROUP BY query_type
ORDER BY total_gb_scanned DESC;
```

## Query Acceleration Service

### Overview
- Offloads portions of eligible queries to shared compute resources
- Best for queries with large scans and selective filters
- Complements warehouse compute with additional serverless resources
- Charged per query based on serverless compute used

**[📖 Query Acceleration](https://docs.snowflake.com/en/user-guide/query-acceleration-service)** - QAS documentation

### Configuration
```sql
-- Enable query acceleration on warehouse
ALTER WAREHOUSE analytics_wh SET
  ENABLE_QUERY_ACCELERATION = TRUE
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = 8;

-- Check eligible queries
SELECT query_id, eligible_query_acceleration_time
FROM TABLE(INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
  DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
));
```

### When QAS Helps
- Large table scans with selective filters
- Queries that would benefit from parallel scan
- Ad-hoc analytical queries on large tables
- Does NOT help with: small queries, join-heavy queries, or spilling queries

## Cost Optimization Strategies

### Warehouse Optimization
1. **Right-size warehouses** - match size to workload complexity
2. **Set appropriate auto-suspend** - balance cache retention vs idle cost
3. **Use multi-cluster only when needed** - single cluster for low concurrency
4. **Separate workloads** - different warehouses for ETL, BI, ad-hoc
5. **Schedule warehouses** - suspend during non-business hours

### Query Optimization
1. **Filter early** - push WHERE clauses as close to source as possible
2. **Select only needed columns** - reduce data scanned
3. **Use clustering keys** - improve partition pruning
4. **Avoid SELECT*** - explicitly name required columns
5. **Break complex queries** - stage intermediate results for very complex pipelines

### Storage Optimization
1. **Set appropriate Time Travel retention** - shorter retention for transient data
2. **Use transient tables** - no Fail-safe storage for non-critical data
3. **Drop unused objects** - tables, stages, and clones consume storage
4. **Monitor storage** - use ACCOUNT_USAGE views for visibility
5. **Compress data** - Snowflake compresses automatically, but efficient data types help

### Credit Usage Tracking
```sql
-- Daily credit trend
SELECT DATE_TRUNC('day', start_time) AS usage_date,
       warehouse_name,
       SUM(credits_used) AS daily_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP())
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- Serverless credit usage
SELECT service_type, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_TASK_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP())
GROUP BY service_type;
```
