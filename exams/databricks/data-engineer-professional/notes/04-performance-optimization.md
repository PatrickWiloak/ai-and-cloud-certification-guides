# Performance Optimization - Databricks Data Engineer Professional

## Overview

This section covers performance optimization for data engineering workloads, representing 15% of the exam. You need to understand data layout strategies, query optimization, Spark tuning, and when to use each optimization technique.

**[📖 Optimization Guide](https://docs.databricks.com/en/optimizations/index.html)** - Performance best practices
**[📖 Delta Lake Best Practices](https://docs.databricks.com/en/delta/best-practices.html)** - Delta optimization

## Key Topics

### 1. Data Layout Optimization

**[📖 OPTIMIZE](https://docs.databricks.com/en/sql/language-manual/delta-optimize.html)** - File compaction
**[📖 Z-Ordering](https://docs.databricks.com/en/delta/data-skipping.html)** - Multi-dimensional clustering

**OPTIMIZE Command:**
```sql
-- Compact small files into larger files
OPTIMIZE catalog.schema.my_table;

-- Compact with Z-ordering on specific columns
OPTIMIZE catalog.schema.my_table ZORDER BY (region, date);

-- Compact a specific partition
OPTIMIZE catalog.schema.my_table WHERE date = '2024-01-01';
```

**Key Concepts:**
- OPTIMIZE compacts small files into larger, more efficient files
- Small files degrade read performance due to metadata overhead
- Target file size is typically 1 GB for Delta tables
- Run OPTIMIZE on tables that receive frequent small writes (streaming, appends)
- OPTIMIZE is incremental - it only compacts files that need it

### 2. Z-Ordering vs Partitioning vs Liquid Clustering

**[📖 Liquid Clustering](https://docs.databricks.com/en/delta/clustering.html)** - Modern clustering

| Strategy | How It Works | Best For |
|----------|-------------|----------|
| Partitioning | Physically separates data by column value | High-cardinality columns with equality filters |
| Z-Ordering | Co-locates related data within files | Multi-column range filters |
| Liquid Clustering | Automatic incremental clustering | New tables; replaces both partitioning and Z-ordering |

**Liquid Clustering:**
```sql
-- Enable liquid clustering on a new table
CREATE TABLE my_table (id INT, region STRING, date DATE)
CLUSTER BY (region, date);

-- Change clustering columns (no rewrite needed)
ALTER TABLE my_table CLUSTER BY (date, product_id);
```

**Key Concepts:**
- Liquid clustering is recommended for new tables
- Automatically clusters data incrementally during writes
- Clustering columns can be changed without rewriting the table
- Replaces the need for partitioning and Z-ordering
- Z-ordering requires running OPTIMIZE explicitly; liquid clustering is automatic
- Partitioning creates directory-level separation; Z-ordering co-locates within files

**Partitioning Guidelines:**
- Use for columns with low-to-medium cardinality (date, region)
- Avoid over-partitioning (creates too many small files)
- Rule of thumb: each partition should contain at least 1 GB of data
- Partitioning cannot be changed after table creation

### 3. VACUUM

**[📖 VACUUM](https://docs.databricks.com/en/sql/language-manual/delta-vacuum.html)** - File cleanup

```sql
-- Remove files older than default retention (7 days)
VACUUM catalog.schema.my_table;

-- Specify retention period
VACUUM catalog.schema.my_table RETAIN 168 HOURS;

-- Dry run to see what would be deleted
VACUUM catalog.schema.my_table DRY RUN;
```

**Key Concepts:**
- VACUUM removes data files no longer referenced by the Delta log
- Default retention is 7 days (168 hours)
- Do not set retention below 7 days (breaks concurrent reads and time travel)
- VACUUM does not remove log files (they have separate retention)
- Run VACUUM regularly to manage storage costs
- After VACUUM, time travel to versions older than the retention period fails

### 4. Query Optimization

**[📖 Adaptive Query Execution](https://docs.databricks.com/en/optimizations/aqe.html)** - AQE features
**[📖 Photon Engine](https://docs.databricks.com/en/compute/photon.html)** - Vectorized engine

**Adaptive Query Execution (AQE):**
- Dynamically optimizes query plans at runtime based on actual data statistics
- Coalesces shuffle partitions to reduce overhead from too many small partitions
- Converts sort-merge joins to broadcast joins when one side is small enough
- Handles data skew by splitting large partitions
- Enabled by default in Databricks

**Join Optimization:**
| Join Type | When Used | Mechanism |
|-----------|-----------|-----------|
| Broadcast join | Small table (< 10 MB) | Small table sent to all nodes |
| Sort-merge join | Large tables | Both sides sorted and shuffled |
| Shuffle hash join | Medium tables | Hash-based partitioning |

```sql
-- Force broadcast join with hint
SELECT /*+ BROADCAST(small_table) */ *
FROM large_table JOIN small_table ON large_table.id = small_table.id;
```

**Key Concepts:**
- Predicate pushdown: filters pushed to the data source to reduce I/O
- Column pruning: only reads required columns from storage
- Photon: C++ vectorized engine, 2-8x faster for SQL and DataFrame workloads
- Cost-based optimizer uses table statistics for better join strategies
- `ANALYZE TABLE t COMPUTE STATISTICS` generates statistics for the optimizer

### 5. Spark Configuration Tuning

**[📖 Spark Configuration](https://docs.databricks.com/en/compute/configure.html)** - Cluster settings

**Key Configuration Parameters:**
| Parameter | Default | Purpose |
|-----------|---------|---------|
| `spark.sql.shuffle.partitions` | 200 | Number of partitions after shuffle |
| `spark.sql.adaptive.enabled` | true | Enable AQE |
| `spark.sql.autoBroadcastJoinThreshold` | 10 MB | Threshold for broadcast join |
| `spark.databricks.delta.autoCompact.enabled` | false | Auto-compact small files |
| `spark.databricks.delta.optimizeWrite.enabled` | false | Optimize file sizes on write |

**Key Concepts:**
- Reduce shuffle partitions for small datasets; increase for large datasets
- Auto-compact automatically runs OPTIMIZE after writes
- Optimize write rebalances data before writing to avoid small files
- Monitor the Spark UI for shuffle, spill, and GC metrics
- Data skew causes stragglers - use salting or AQE skew handling

### 6. Caching Strategies

**[📖 Caching](https://docs.databricks.com/en/optimizations/disk-cache.html)** - Caching reference

**Key Concepts:**
- Delta cache (disk cache): automatically caches remote data on local SSDs
- `CACHE TABLE t` explicitly caches a table in memory
- `UNCACHE TABLE t` removes a table from cache
- Caching is beneficial for tables read multiple times in the same session
- Disk cache is transparent and requires no code changes
- Memory cache uses cluster memory and reduces available memory for computation

## Exam Tips for This Domain

1. **Liquid clustering vs Z-ordering vs partitioning** - Know when to use each
2. **VACUUM retention** - Default 7 days; never set below 7 days
3. **AQE features** - Partition coalescing, join conversion, skew handling
4. **Broadcast join threshold** - 10 MB default; use hints for manual control
5. **Small file problem** - Auto-compact, optimize write, and OPTIMIZE solve this
6. **Statistics** - ANALYZE TABLE enables cost-based optimization

## Documentation Links Summary

| Topic | Link |
|-------|------|
| OPTIMIZE | [docs.databricks.com/en/sql/language-manual/delta-optimize.html](https://docs.databricks.com/en/sql/language-manual/delta-optimize.html) |
| Liquid Clustering | [docs.databricks.com/en/delta/clustering.html](https://docs.databricks.com/en/delta/clustering.html) |
| VACUUM | [docs.databricks.com/en/sql/language-manual/delta-vacuum.html](https://docs.databricks.com/en/sql/language-manual/delta-vacuum.html) |
| AQE | [docs.databricks.com/en/optimizations/aqe.html](https://docs.databricks.com/en/optimizations/aqe.html) |
| Photon | [docs.databricks.com/en/compute/photon.html](https://docs.databricks.com/en/compute/photon.html) |
| Disk Cache | [docs.databricks.com/en/optimizations/disk-cache.html](https://docs.databricks.com/en/optimizations/disk-cache.html) |
