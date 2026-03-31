# Performance Concepts

**[📖 Performance Optimization](https://docs.snowflake.com/en/user-guide/performance)** - Performance tuning overview

## Caching Mechanisms

Understanding Snowflake's three caching layers is critical for the exam.

### Result Cache

**[📖 Persisted Query Results](https://docs.snowflake.com/en/user-guide/querying-persisted-results)** - Result caching details

- Stores complete query results for 24 hours
- Served from cloud services layer - no warehouse needed
- Conditions for cache hit:
  - Exact same SQL text (including whitespace and comments)
  - Same role context
  - Underlying data has not changed
  - Micro-partitions have not changed
  - Query does not use non-deterministic functions (CURRENT_TIMESTAMP, RANDOM)
  - Query does not use external functions
  - Table's result cache has not been invalidated

**Controlling Result Cache:**
```sql
-- Disable for a session
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

-- Check if result came from cache
SELECT * FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE QUERY_ID = 'your_query_id';
-- Look at BYTES_SCANNED = 0 for cache hit
```

### Warehouse Cache (Local Disk Cache)

- SSD storage on compute nodes in the virtual warehouse
- Caches raw data read from remote storage (S3/Azure Blob/GCS)
- Reduces need to re-read data from remote storage
- Cleared when warehouse is suspended
- Not shared across different warehouses
- No configuration options - fully automatic
- Helps with: repeated scans of the same tables or partitions

**Implication:** Setting auto-suspend too aggressively clears the cache. For workloads that frequently access the same data, consider longer auto-suspend values.

### Metadata Cache

- Always available in cloud services layer
- Stores per-micro-partition statistics:
  - MIN and MAX values per column
  - Number of distinct values
  - Number of NULL values
  - Row count per partition
- Used for partition pruning (skipping irrelevant partitions)
- Can answer simple queries without scanning data:
  - `SELECT COUNT(*) FROM table` (exact count from metadata)
  - `SELECT MIN(col) FROM table` (if well-clustered)

## Clustering

**[📖 Clustering Keys](https://docs.snowflake.com/en/user-guide/tables-clustering-keys)** - Clustering fundamentals

### Micro-Partition Organization

- Data naturally clustered by ingestion order
- Over time, DML operations can degrade natural clustering
- Poor clustering leads to scanning more partitions than necessary
- Clustering depth measures how well data is organized

### When to Use Clustering Keys

**Good candidates:**
- Tables larger than 1 TB
- Queries consistently filter on the same columns
- Clustering depth is high (poor natural clustering)
- Significant percentage of partitions scanned for filtered queries

**Bad candidates:**
- Tables smaller than 1 TB (overhead outweighs benefit)
- Tables that are primarily INSERT-only without updates
- Tables where queries don't use consistent filter patterns
- Tables already well-clustered by natural ingestion

### Clustering Key Selection

```sql
-- Check current clustering information
SELECT SYSTEM$CLUSTERING_INFORMATION('my_table', '(date_column, region_column)');

-- Add clustering key
ALTER TABLE my_table CLUSTER BY (date_column, region_column);

-- Check clustering depth
SELECT SYSTEM$CLUSTERING_DEPTH('my_table');

-- Remove clustering key
ALTER TABLE my_table DROP CLUSTERING KEY;
```

**Best Practices:**
- Choose 3-4 columns maximum
- Put the most selective column first
- Date/timestamp columns are common choices
- Avoid high-cardinality columns (like unique IDs)
- Consider query patterns - cluster by most common filter columns

### Automatic Clustering (Enterprise+)

**[📖 Automatic Clustering](https://docs.snowflake.com/en/user-guide/tables-auto-reclustering)** - Auto-clustering details

- Snowflake automatically maintains clustering after key is set
- Background process reorganizes micro-partitions
- Runs as needed based on clustering depth
- Billed using serverless compute (credits)
- Can be suspended: `ALTER TABLE my_table SUSPEND RECLUSTER`
- Ongoing cost - not a one-time operation

## Query Optimization

### Query Profile

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Analyzing query execution

The Query Profile is the primary tool for understanding query performance.

**Key Metrics to Watch:**
- **Partitions Scanned vs Total:** Low ratio indicates good pruning
- **Bytes Scanned:** Compare to table size for pruning efficiency
- **Spillage to Local/Remote Storage:** Indicates warehouse is too small
- **Bytes Sent Over Network:** Data transfer between nodes
- **Percentage Scanned from Cache:** Higher is better

**Common Performance Issues:**

1. **Spillage to Disk**
   - Query needs more memory than available
   - Solution: Scale up warehouse size
   - Local disk spillage is less concerning than remote disk spillage

2. **Exploding Joins**
   - Cartesian products or missing join conditions
   - Output rows >> input rows
   - Solution: Add proper join conditions, review data model

3. **Inefficient Pruning**
   - Scanning most/all partitions despite filters
   - Solution: Add clustering keys on filter columns
   - Check if WHERE clause uses functions that prevent pruning

4. **Full Table Scans**
   - No WHERE clause or non-selective filters
   - Solution: Add appropriate filters, use LIMIT for exploration

### Warehouse Sizing Guidelines

**[📖 Warehouse Considerations](https://docs.snowflake.com/en/user-guide/warehouses-considerations)** - Sizing guidance

**Scale Up (larger warehouse) when:**
- Complex queries with many joins
- Large data scans
- Spillage to disk in Query Profile
- Query complexity is the bottleneck

**Scale Out (multi-cluster) when:**
- Many concurrent queries from multiple users
- Queries are queuing (waiting for resources)
- Concurrency is the bottleneck
- Individual queries run fast but throughput is low

**General Guidelines:**
- Start with X-Small or Small and size up as needed
- Doubling warehouse size halves query time (approximately)
- Monitor credit usage with resource monitors
- Different workloads should use different warehouses

## Resource Monitors

**[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Credit monitoring

### Configuration

```sql
CREATE RESOURCE MONITOR monthly_monitor
  WITH CREDIT_QUOTA = 1000
  FREQUENCY = MONTHLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND
    ON 110 PERCENT DO SUSPEND_IMMEDIATE;

-- Apply to warehouse
ALTER WAREHOUSE my_wh SET RESOURCE_MONITOR = monthly_monitor;

-- Apply to account
ALTER ACCOUNT SET RESOURCE_MONITOR = monthly_monitor;
```

### Actions
- **NOTIFY:** Send alert notification only
- **SUSPEND:** Allow running queries to complete, then suspend
- **SUSPEND_IMMEDIATE:** Kill running queries and suspend immediately

### Scope
- **Account level:** Monitors total credit usage across all warehouses
- **Warehouse level:** Monitors specific warehouse credit usage
- Only ACCOUNTADMIN can create resource monitors (by default)

## Materialized Views (Enterprise+)

**[📖 Materialized Views](https://docs.snowflake.com/en/user-guide/views-materialized)** - Pre-computed results

- Pre-compute and store query results
- Automatically maintained by Snowflake when base data changes
- Best for queries that are expensive and frequently run
- Cannot contain joins, UDFs, HAVING, ORDER BY, LIMIT
- Must query a single table
- Uses serverless compute for maintenance (ongoing cost)
- Query optimizer automatically routes to materialized views when beneficial

```sql
CREATE MATERIALIZED VIEW daily_summary AS
SELECT date_col, region, SUM(amount) AS total_amount
FROM transactions
GROUP BY date_col, region;
```

## Search Optimization Service (Enterprise+)

**[📖 Search Optimization](https://docs.snowflake.com/en/user-guide/search-optimization-service)** - Point lookup acceleration

- Improves performance of selective point lookups
- Best for: equality predicates, IN lists, LIKE patterns on large tables
- Maintained automatically as data changes
- Adds storage and compute cost
- Not a substitute for clustering keys (complementary)

```sql
ALTER TABLE my_table ADD SEARCH OPTIMIZATION ON EQUALITY(id_column);
```

## Performance Monitoring

### Account Usage Views
- QUERY_HISTORY - detailed query execution information
- WAREHOUSE_METERING_HISTORY - credit consumption
- STORAGE_USAGE - storage consumption over time
- LOGIN_HISTORY - authentication events

**[📖 Account Usage](https://docs.snowflake.com/en/sql-reference/account-usage)** - Monitoring views

### Information Schema
- Real-time metadata about objects and operations
- Scoped to current database
- No latency (unlike Account Usage which has up to 45-minute delay)

**[📖 Information Schema](https://docs.snowflake.com/en/sql-reference/info-schema)** - Real-time metadata
