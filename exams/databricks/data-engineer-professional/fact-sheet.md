# Databricks Data Engineer Professional - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Data Engineer Professional
**Duration:** 120 minutes
**Questions:** 60 multiple-choice questions
**Passing Score:** 70% (approximately 42 correct)
**Cost:** $300 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/data-engineer-professional)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - Advanced learning paths
**[📖 Databricks Documentation](https://docs.databricks.com/)** - Complete platform documentation

## Target Audience

This certification is designed for:
- Experienced data engineers building production pipelines on Databricks
- Engineers designing complex data architectures at scale
- Data platform architects optimizing Lakehouse performance
- Engineers with 2+ years of Databricks or Spark experience
- Professionals managing enterprise data governance

## Domain 1: Designing and Implementing Data Pipelines (34%)

### Advanced Pipeline Design

**[📖 Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)** - Multi-hop pipeline patterns
**[📖 MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)** - Upsert operations
**[📖 Delta Lake Best Practices](https://docs.databricks.com/en/delta/best-practices.html)** - Production patterns

**Key Facts:**
- Medallion architecture (Bronze/Silver/Gold) for data quality layers
- Idempotent pipeline design: re-running produces same results
- MERGE INTO for upserts with match conditions
- `WHEN MATCHED`, `WHEN NOT MATCHED`, `WHEN NOT MATCHED BY SOURCE`
- Schema evolution: `mergeSchema` option for appending new columns
- `overwriteSchema` for replacing table schema entirely

### Change Data Capture (CDC)

**[📖 Change Data Feed](https://docs.databricks.com/en/delta/delta-change-data-feed.html)** - CDC with Delta Lake
**[📖 CDC Patterns](https://docs.databricks.com/en/delta/delta-change-data-feed.html#read-changes-in-batch-queries)** - Reading change data

**Key Facts:**
- Change Data Feed (CDF) captures row-level changes (insert, update, delete)
- Enable with `ALTER TABLE SET TBLPROPERTIES (delta.enableChangeDataFeed = true)`
- Read changes: `spark.read.format("delta").option("readChangeFeed", "true").option("startingVersion", 5).table("t")`
- `_change_type` column: insert, update_preimage, update_postimage, delete
- CDF is efficient for downstream incremental processing
- Use with MERGE to propagate changes through medallion layers

### Slowly Changing Dimensions (SCD)

**Key Facts:**
- SCD Type 1: Overwrite old values (simple MERGE with UPDATE)
- SCD Type 2: Maintain history with effective dates and current flag
- SCD Type 2 implementation:
  1. Expire current records that are being updated
  2. Insert new records with current effective date
  3. Use MERGE with complex WHEN clauses
- Use window functions to derive `is_current` flags

### Complex Data Handling

**[📖 Semi-structured Data](https://docs.databricks.com/en/optimizations/semi-structured.html)** - Nested data processing
**[📖 Higher-Order Functions](https://docs.databricks.com/en/sql/language-manual/sql-ref-functions-builtin-alpha.html)** - Array and map functions

**Key Facts:**
- `explode()` for flattening arrays
- `posexplode()` for arrays with position
- `from_json()` with schema for parsing JSON strings
- `inline()` for flattening arrays of structs
- Higher-order functions: `transform()`, `filter()`, `aggregate()`, `exists()`
- Dot notation for accessing nested struct fields
- `:` notation for accessing variant/JSON fields
- Schema-on-read for semi-structured data

## Domain 2: Incremental Data Processing (20%)

### Advanced Structured Streaming

**[📖 Structured Streaming Guide](https://docs.databricks.com/en/structured-streaming/index.html)** - Streaming reference
**[📖 Stream-Stream Joins](https://docs.databricks.com/en/structured-streaming/joining-streams.html)** - Joining streams
**[📖 Watermarking](https://docs.databricks.com/en/structured-streaming/watermarks.html)** - Late data handling

**Key Facts:**
- Stream-stream joins require watermarks on both sides
- Stream-static joins: streaming side drives the join, static side refreshed per batch
- Watermarking: `withWatermark("event_time", "10 minutes")` drops late data
- `foreachBatch` for custom sink operations in each micro-batch
- Deduplication: `dropDuplicatesWithinWatermark()` for streaming dedup
- Stateful operations accumulate state; monitor state size
- `availableNow` trigger processes all available data incrementally then stops

### Advanced Auto Loader

**[📖 Auto Loader Options](https://docs.databricks.com/en/ingestion/auto-loader/options.html)** - Full configuration
**[📖 Schema Evolution](https://docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html)** - Handling schema changes

**Key Facts:**
- File notification mode uses cloud events (SQS, Event Grid, Pub/Sub)
- Directory listing mode scans directory (simpler but slower for large directories)
- `cloudFiles.schemaEvolutionMode`:
  - `addNewColumns`: adds new columns automatically
  - `rescue`: captures new columns in `_rescued_data`
  - `failOnNewColumns`: fails stream on schema change
  - `none`: ignores new columns
- `cloudFiles.schemaLocation` stores inferred schema
- `cloudFiles.schemaHints` provides type hints for ambiguous columns
- Rescue data column preserves data that doesn't match schema

## Domain 3: Data Governance (18%)

### Advanced Unity Catalog

**[📖 Unity Catalog Best Practices](https://docs.databricks.com/en/data-governance/unity-catalog/best-practices.html)** - Governance patterns
**[📖 Dynamic Views](https://docs.databricks.com/en/data-governance/unity-catalog/create-views.html)** - Row/column security
**[📖 External Locations](https://docs.databricks.com/en/sql/language-manual/sql-ref-syntax-ddl-create-location.html)** - External data access
**[📖 System Tables](https://docs.databricks.com/en/administration-guide/system-tables/index.html)** - Audit and monitoring

**Key Facts:**
- Dynamic views for column masking: `CASE WHEN is_member('admins') THEN ssn ELSE 'REDACTED' END`
- Dynamic views for row filtering: `WHERE region = current_user()`
- Storage credentials: cloud-provider credentials for external storage
- External locations: map cloud storage paths to Unity Catalog
- Information schema: `system.information_schema` for metadata queries
- System tables: `system.access.audit` for audit logs
- Privilege inheritance: permissions cascade from catalog to schema to table
- `GRANT` on securable with `WITH GRANT OPTION` allows re-granting
- Data lineage: automatic tracking through Unity Catalog

### Compliance and Auditing

**[📖 Audit Logs](https://docs.databricks.com/en/administration-guide/account-settings/audit-logs.html)** - Audit log configuration
**[📖 Data Lineage](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html)** - Lineage tracking

**Key Facts:**
- Audit logs capture workspace events (logins, queries, data access)
- System tables provide queryable audit data
- Lineage tracks table-to-table and column-to-column dependencies
- `DESCRIBE EXTENDED table_name` shows table metadata and lineage info
- Tags for classifying sensitive data
- Row-level security with dynamic views

## Domain 4: Performance Optimization (15%)

### Data Layout Optimization

**[📖 OPTIMIZE](https://docs.databricks.com/en/sql/language-manual/delta-optimize.html)** - File compaction
**[📖 Z-Ordering](https://docs.databricks.com/en/delta/data-skipping.html)** - Multi-dimensional clustering
**[📖 Liquid Clustering](https://docs.databricks.com/en/delta/clustering.html)** - Modern clustering approach

**Key Facts:**
- `OPTIMIZE table_name` compacts small files into larger files
- Z-ordering: `OPTIMIZE table ZORDER BY (col1, col2)` for multi-column filtering
- Liquid clustering: `ALTER TABLE SET TBLPROPERTIES ('delta.clusteringColumns' = 'col1,col2')`
- Liquid clustering is recommended over Z-ordering and partitioning for new tables
- Partitioning: use for high-cardinality columns with clear filter patterns
- Over-partitioning creates too many small files (avoid)
- `VACUUM table_name RETAIN 168 HOURS` removes old files
- Default retention for VACUUM is 7 days (168 hours)

### Query Optimization

**[📖 Adaptive Query Execution](https://docs.databricks.com/en/optimizations/aqe.html)** - AQE features
**[📖 Photon Engine](https://docs.databricks.com/en/compute/photon.html)** - Vectorized engine
**[📖 Join Hints](https://docs.databricks.com/en/sql/language-manual/sql-ref-syntax-qry-select-hints.html)** - Join optimization

**Key Facts:**
- Adaptive Query Execution (AQE): dynamically optimizes query plans at runtime
- AQE features: coalescing shuffle partitions, converting joins, handling skew
- Broadcast join: small table broadcast to all nodes (< 10MB default threshold)
- Sort-merge join: for large tables, requires shuffle
- Shuffle hash join: medium-sized tables
- Predicate pushdown: filters pushed to data source level
- Column pruning: only reads required columns
- Photon: C++ vectorized engine, 2-8x faster for SQL workloads
- Cost-based optimizer: `ANALYZE TABLE table_name COMPUTE STATISTICS`

### Spark Tuning

**[📖 Spark Configuration](https://docs.databricks.com/en/compute/configure.html)** - Cluster configuration
**[📖 Caching](https://docs.databricks.com/en/optimizations/disk-cache.html)** - Caching strategies

**Key Facts:**
- `spark.sql.shuffle.partitions` controls post-shuffle partition count (default 200)
- `spark.sql.adaptive.enabled` enables AQE (default true in Databricks)
- `spark.sql.autoBroadcastJoinThreshold` sets broadcast join threshold
- Disk cache: automatic caching of remote data on local SSDs
- `CACHE TABLE` for explicit in-memory caching
- Spill: when memory is insufficient, data spills to disk (monitor in Spark UI)
- Data skew: uneven partition sizes cause stragglers
- Salting: add random prefix to skewed keys for better distribution

## Domain 5: Monitoring and Troubleshooting (13%)

### Spark UI and Debugging

**[📖 Spark UI](https://docs.databricks.com/en/compute/sparkling/index.html)** - Understanding Spark UI
**[📖 Query Profile](https://docs.databricks.com/en/sql/user/queries/query-profile.html)** - SQL query analysis

**Key Facts:**
- Spark UI tabs: Jobs, Stages, Storage, Environment, SQL
- Stages view: shows task distribution, shuffle read/write, duration
- Skew indicators: max task time much higher than median
- Shuffle: data redistribution across nodes (expensive operation)
- Spill: memory overflow to disk (indicates need for more memory or fewer partitions)
- GC time: excessive garbage collection indicates memory pressure
- DAG visualization: shows physical execution plan
- Query profile: visual breakdown of SQL query execution

### Pipeline Monitoring

**[📖 Job Monitoring](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html)** - Job run monitoring
**[📖 Delta Table History](https://docs.databricks.com/en/delta/history.html)** - Table version history

**Key Facts:**
- `DESCRIBE HISTORY table_name` shows all operations on a table
- `DESCRIBE DETAIL table_name` shows table metadata (size, files, partitions)
- System tables for monitoring: `system.billing.usage`, `system.access.audit`
- Job run monitoring: duration, status, task-level details
- Alert configuration: email, webhook, Slack notifications
- Event log for DLT pipelines: data quality metrics, pipeline state
- Cluster metrics: CPU, memory, network utilization

## Exam Tips

1. **Pipeline design (34%)** is the largest domain - focus on complex scenarios
2. **CDC and SCD patterns** are heavily tested - know MERGE with CDF
3. **Performance optimization** requires understanding tradeoffs
4. **Spark UI interpretation** is critical for troubleshooting questions
5. **Z-ordering vs Liquid Clustering vs Partitioning** - know when to use each
6. **Unity Catalog governance** at enterprise scale with dynamic views
7. **Streaming edge cases** - late data, deduplication, schema evolution
8. **AQE features** - understand what it optimizes automatically
9. **Think at scale** - solutions must work for large datasets
10. **Time management** - 2 minutes per question; scenario questions take longer

## Quick Reference

### Essential Commands
```sql
-- CDC
ALTER TABLE t SET TBLPROPERTIES (delta.enableChangeDataFeed = true);
SELECT * FROM table_changes('t', 5);

-- Performance
OPTIMIZE table_name ZORDER BY (col1, col2);
ANALYZE TABLE t COMPUTE STATISTICS FOR ALL COLUMNS;
VACUUM table_name RETAIN 168 HOURS;

-- Monitoring
DESCRIBE HISTORY table_name;
DESCRIBE DETAIL table_name;
EXPLAIN FORMATTED SELECT ...;

-- Governance
CREATE DYNAMIC VIEW v AS SELECT CASE WHEN is_member('admins') THEN ssn ELSE '***' END AS ssn FROM t;
GRANT SELECT ON TABLE catalog.schema.table TO group_name;
```
