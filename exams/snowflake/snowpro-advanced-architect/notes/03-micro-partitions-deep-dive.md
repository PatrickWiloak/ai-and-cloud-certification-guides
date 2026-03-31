# Micro-Partitions Deep Dive

**[📖 Micro-Partitions](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)** - Partition internals

## Overview

This document provides a deep dive into Snowflake's micro-partition architecture, clustering strategies, pruning optimization, and the Search Optimization Service. Understanding micro-partitions at a detailed level is essential for the Advanced Architect exam, as it underpins query performance, storage efficiency, and cost optimization.

## Micro-Partition Fundamentals

### Structure
- Contiguous units of storage, 50-500 MB compressed
- Data stored in columnar format within each partition
- Each column stored and compressed independently
- Immutable - never updated in place, always replaced
- Automatically created during data loading and DML operations

### Metadata Per Partition
- Min and max values for each column
- Number of distinct values per column
- Number of null values per column
- Partition size and row count
- Metadata stored in cloud services layer (not in storage)

**[📖 Micro-Partition Metadata](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)** - Metadata details

### How Partitions Are Created
| Operation | Partition Behavior |
|-----------|-------------------|
| COPY INTO (bulk load) | New partitions from loaded data |
| INSERT | New partitions from inserted rows |
| UPDATE | Old partitions marked deleted, new partitions created |
| DELETE | Old partitions marked deleted, new partitions with remaining rows |
| MERGE | Combination of insert, update, delete behaviors |
| RECLUSTER | Existing partitions reorganized into new partitions |

### Natural Clustering
- Data naturally clusters by ingestion order
- Rows loaded together end up in the same partitions
- Time-series data naturally clusters on timestamp columns
- Random inserts (e.g., from multiple sources) create poor natural clustering
- Natural clustering degrades over time with updates and deletes

## Partition Pruning

### How Pruning Works
1. Query optimizer reads partition metadata (min/max per column)
2. Compares filter predicates against partition min/max ranges
3. Eliminates partitions that cannot contain matching rows
4. Only scans partitions that may contain results
5. Pruning happens before any data is read from storage

### Pruning Effectiveness
```sql
-- Check pruning in Query Profile
-- Look for: "Partitions scanned" vs "Partitions total"

-- Good pruning example (date filter on naturally clustered data)
SELECT * FROM events WHERE event_date = '2024-01-15';
-- Partitions scanned: 5 out of 10,000 (99.95% pruned)

-- Poor pruning example (filter on non-clustered column)
SELECT * FROM events WHERE user_id = 12345;
-- Partitions scanned: 9,500 out of 10,000 (5% pruned)
```

### Factors Affecting Pruning
| Factor | Impact on Pruning |
|--------|------------------|
| Column in filter matches clustering | High pruning (good) |
| Filter on time/date columns (natural order) | High pruning (good) |
| Filter on random/non-clustered columns | Low pruning (bad) |
| Wide min/max ranges in partitions | Low pruning (bad) |
| Equality predicates | Best pruning efficiency |
| Range predicates | Good pruning efficiency |
| LIKE/ILIKE predicates | Limited pruning |
| Functions on columns (e.g., UPPER(col)) | No pruning possible |

### Query Profile Pruning Metrics
- **Partitions scanned:** Number of partitions actually read
- **Partitions total:** Total partitions in the table
- **Bytes scanned:** Volume of data read from storage
- **Percentage scanned:** Ratio of scanned to total (lower is better)
- Target: less than 10-20% of partitions scanned for selective queries

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Profile analysis

## Clustering Keys

### When to Use Clustering Keys
- Large tables (typically multi-terabyte)
- Queries consistently filter on specific columns
- Natural clustering has degraded significantly
- Pruning metrics show high percentage of partitions scanned
- Do NOT use on small tables - overhead exceeds benefit

**[📖 Clustering Keys](https://docs.snowflake.com/en/user-guide/tables-clustering-keys)** - Clustering configuration

### Choosing Clustering Key Columns
- Columns frequently used in WHERE clauses
- Columns frequently used in JOIN conditions
- Prefer low-to-medium cardinality columns (date, region, category)
- High cardinality columns (unique IDs) are poor clustering candidates
- Maximum 3-4 columns in a clustering key (order matters)

```sql
-- Define clustering key
ALTER TABLE sales CLUSTER BY (sale_date, region);

-- Check clustering information
SELECT SYSTEM$CLUSTERING_INFORMATION('sales', '(sale_date, region)');

-- Result includes:
-- cluster_by_keys: columns in clustering key
-- total_partition_count: total micro-partitions
-- average_depth: average clustering depth (target: close to 1)
-- average_overlap: average partition overlap (target: close to 0)
```

### Clustering Depth and Overlap
- **Depth:** Average number of partitions that overlap for a given value range
  - Depth of 1 = perfect clustering (each value range in exactly one partition)
  - Depth of 5 = each value range spans 5 partitions (poor clustering)
- **Overlap:** How many partitions share overlapping value ranges
  - Overlap of 0 = no partitions have overlapping ranges (ideal)
  - High overlap = partitions contain redundant value ranges

### Automatic Reclustering
- Snowflake automatically maintains clustering over time
- Background service reorganizes partitions when clustering degrades
- Serverless compute - separate from user warehouses
- Credit cost for reclustering (serverless credit rate)
- Reclustering can be suspended and resumed

```sql
-- Suspend automatic reclustering
ALTER TABLE sales SUSPEND RECLUSTER;

-- Resume automatic reclustering
ALTER TABLE sales RESUME RECLUSTER;

-- Monitor reclustering history
SELECT * FROM TABLE(INFORMATION_SCHEMA.AUTOMATIC_CLUSTERING_HISTORY(
  TABLE_NAME => 'sales',
  DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
));
```

**[📖 Automatic Clustering](https://docs.snowflake.com/en/user-guide/tables-auto-reclustering)** - Background reclustering

### Clustering Key Column Order
- First column should be the most commonly filtered column
- Column order determines clustering priority
- Data sorted primarily by first column, then second, etc.
- Example: `CLUSTER BY (date, region)` optimizes date filters most

### Clustering Key Expressions
```sql
-- Cluster by expression (reduce cardinality)
ALTER TABLE events CLUSTER BY (TO_DATE(event_timestamp), event_type);

-- Cluster by substring
ALTER TABLE logs CLUSTER BY (SUBSTRING(log_message, 1, 10), log_level);
```

- Expressions reduce cardinality for high-cardinality columns
- TO_DATE on timestamps is a common pattern
- Substring or truncation for string columns
- Expressions must be deterministic

## Search Optimization Service

### Overview
- Supplemental data structure for point lookup queries
- Optimizes equality and IN predicates on high-cardinality columns
- Builds and maintains a search access path (background process)
- Serverless compute for building and maintaining the index
- Complements (not replaces) clustering keys

**[📖 Search Optimization](https://docs.snowflake.com/en/user-guide/search-optimization-service)** - Search optimization guide

### When to Use
| Use Case | Clustering Key | Search Optimization |
|----------|---------------|-------------------|
| Range queries on low-cardinality | Best choice | Not optimal |
| Point lookups on high-cardinality | Poor choice | Best choice |
| Equality on unique IDs | Poor choice | Best choice |
| Queries on VARIANT/OBJECT columns | Not supported | Supported |
| Substring/regex searches | Not effective | Supported |

### Configuration
```sql
-- Enable search optimization on table
ALTER TABLE users ADD SEARCH OPTIMIZATION;

-- Enable for specific columns
ALTER TABLE users ADD SEARCH OPTIMIZATION ON EQUALITY(user_id);
ALTER TABLE users ADD SEARCH OPTIMIZATION ON EQUALITY(email);

-- Check optimization status
SELECT * FROM TABLE(INFORMATION_SCHEMA.SEARCH_OPTIMIZATION_HISTORY(
  TABLE_NAME => 'users'
));

-- Disable search optimization
ALTER TABLE users DROP SEARCH OPTIMIZATION;
```

### Cost Considerations
- Storage cost for the search access path structure
- Compute cost for building and maintaining the structure (serverless credits)
- Most beneficial for tables with frequent point lookups
- Not cost-effective for tables rarely queried with equality predicates
- Monitor cost vs benefit using SEARCH_OPTIMIZATION_HISTORY

## Materialized Views vs Dynamic Tables

### Materialized Views
- Pre-computed results stored as micro-partitions
- Automatically refreshed when base table changes
- Best for simple aggregations and filters
- Limited to single-table queries (no joins in standard MVs)
- Query optimizer can use MV transparently (even if query does not reference MV)

**[📖 Materialized Views](https://docs.snowflake.com/en/user-guide/views-materialized)** - Materialized view documentation

### Dynamic Tables
- Declarative data pipelines defined by SQL query
- Support joins, aggregations, and complex transformations
- Target lag controls maximum staleness
- Snowflake manages incremental refresh automatically
- Can be chained for multi-step transformation pipelines

**[📖 Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)** - Dynamic table documentation

### Comparison
| Feature | Materialized View | Dynamic Table |
|---------|------------------|---------------|
| Joins | No (single table) | Yes |
| Complex SQL | Limited | Full SQL support |
| Refresh | Automatic on change | Based on target lag |
| Chaining | No | Yes |
| Optimizer rewrite | Yes (transparent) | No |
| Use case | Simple aggregations | Data pipelines |

## Performance Impact Summary

### Storage Layer Optimization Techniques
1. **Clustering keys** - Reorganize partitions for better pruning
2. **Search optimization** - Index for point lookups
3. **Materialized views** - Pre-compute common aggregations
4. **Dynamic tables** - Declarative pipeline with controlled freshness
5. **Table design** - Choose appropriate data types, avoid overly wide tables
