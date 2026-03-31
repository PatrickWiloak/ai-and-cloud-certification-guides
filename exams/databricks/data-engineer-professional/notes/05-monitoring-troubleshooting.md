# Monitoring and Troubleshooting - Databricks Data Engineer Professional

## Overview

This section covers monitoring, debugging, and troubleshooting data engineering workloads, representing 13% of the exam. You need to interpret the Spark UI, diagnose performance issues, and monitor production pipelines.

**[📖 Spark UI](https://docs.databricks.com/en/compute/sparkling/index.html)** - Spark UI reference
**[📖 Job Monitoring](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html)** - Job run monitoring

## Key Topics

### 1. Spark UI Interpretation

**[📖 Spark UI](https://docs.databricks.com/en/compute/sparkling/index.html)** - Understanding the Spark UI

**Spark UI Tabs:**
| Tab | Purpose |
|-----|---------|
| Jobs | Shows all Spark jobs and their status |
| Stages | Shows stages within jobs with task-level metrics |
| Storage | Shows cached RDDs and DataFrames |
| Environment | Shows Spark configuration and environment variables |
| SQL | Shows SQL queries and their execution plans |

**Stage-Level Metrics to Watch:**
- **Task duration distribution** - Large gap between median and max indicates skew
- **Shuffle read/write** - Large shuffle sizes indicate expensive data redistribution
- **Spill (memory/disk)** - Data overflow from memory to disk (needs more memory or fewer partitions)
- **GC time** - High garbage collection time indicates memory pressure

### 2. Diagnosing Data Skew

**Symptoms of Skew:**
- One or few tasks take much longer than others in a stage
- Max task time is significantly higher than median task time
- Some partitions are much larger than others

**Solutions for Skew:**
- **AQE skew handling** - Enabled by default; splits large partitions automatically
- **Salting** - Add a random prefix to skewed keys to distribute data more evenly
- **Broadcast join** - Eliminate shuffle entirely for small tables
- **Repartition** - Redistribute data before processing

```python
# Salting example for skewed join
from pyspark.sql.functions import lit, rand, floor, concat

# Add salt to both sides
salted_large = large_df.withColumn("salt", floor(rand() * 10))
salted_small = small_df.crossJoin(
    spark.range(10).withColumnRenamed("id", "salt")
)

# Join on original key + salt
result = salted_large.join(salted_small,
    (salted_large.key == salted_small.key) &
    (salted_large.salt == salted_small.salt))
```

### 3. Diagnosing Shuffle Issues

**Key Concepts:**
- Shuffle moves data between nodes for operations like JOIN, GROUP BY, and DISTINCT
- Shuffle is expensive: involves serialization, network I/O, and disk I/O
- Excessive shuffle partitions create overhead from too many small tasks
- Too few shuffle partitions create large tasks that may spill

**Optimization Strategies:**
- AQE coalesces empty or small shuffle partitions automatically
- Adjust `spark.sql.shuffle.partitions` for non-AQE workloads
- Use broadcast joins to avoid shuffle entirely for small tables
- Use bucketing for frequently joined large tables

### 4. Memory and Spill Issues

**Key Concepts:**
- Spill occurs when data does not fit in memory and overflows to disk
- Spill to disk is significantly slower than in-memory processing
- Visible in the Spark UI Stages tab as "Spill (Memory)" and "Spill (Disk)"

**Solutions:**
- Increase executor memory (`spark.executor.memory`)
- Increase the number of partitions (smaller data per task)
- Reduce the amount of data being processed (filter earlier)
- Use more efficient data formats (avoid parsing in UDFs)

### 5. Query Profile for SQL

**[📖 Query Profile](https://docs.databricks.com/en/sql/user/queries/query-profile.html)** - SQL query analysis

**Key Concepts:**
- Query profile provides a visual breakdown of SQL query execution
- Shows the physical plan as a tree of operators
- Each operator shows row count, time, and memory usage
- Identify bottlenecks by finding operators with the highest time
- Available for SQL queries run on SQL warehouses

### 6. Pipeline Monitoring

**[📖 Job Monitoring](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html)** - Monitoring jobs
**[📖 Delta History](https://docs.databricks.com/en/delta/history.html)** - Table version history

**Delta Table Monitoring:**
```sql
-- View table operation history
DESCRIBE HISTORY catalog.schema.my_table;

-- View table metadata (size, files, partitions)
DESCRIBE DETAIL catalog.schema.my_table;

-- View execution plan
EXPLAIN FORMATTED SELECT * FROM my_table WHERE region = 'US';
```

**Key Concepts:**
- `DESCRIBE HISTORY` shows all operations (writes, deletes, optimizes) with timestamps
- `DESCRIBE DETAIL` shows table size, number of files, and partition info
- Use these to identify when tables grew unexpectedly or had issues
- Monitor file count - increasing small files indicates a need for OPTIMIZE

### 7. DLT Pipeline Monitoring

**Key Concepts:**
- DLT event log tracks pipeline execution, data quality, and errors
- Expectation metrics show pass/fail counts for each data quality rule
- Pipeline lineage shows data flow between tables
- Monitor for:
  - Increasing data quality violations over time
  - Pipeline duration trends (growing duration may indicate scaling issues)
  - Failed expectations that should trigger alerts

### 8. System Tables for Operational Monitoring

```sql
-- Monitor cluster usage
SELECT cluster_id, cluster_name, state, driver_node_type, worker_node_type
FROM system.compute.clusters
WHERE change_time > current_date() - 7;

-- Monitor job costs
SELECT workspace_id, sku_name, usage_quantity, usage_date
FROM system.billing.usage
WHERE usage_date >= current_date() - 30
ORDER BY usage_quantity DESC;

-- Audit data access
SELECT event_date, user_identity.email, action_name, request_params
FROM system.access.audit
WHERE action_name IN ('getTable', 'commandSubmit')
AND event_date >= current_date() - 1;
```

### 9. Alerting and Notifications

**Key Concepts:**
- Databricks Jobs support notifications on start, success, and failure
- SQL Alerts can trigger on query result conditions
- System tables can be queried by scheduled jobs to create custom alerts
- Integration with email, Slack, PagerDuty, and webhook endpoints
- Set up alerts for: pipeline failures, data quality degradation, cost thresholds

## Exam Tips for This Domain

1. **Spark UI interpretation** - Know how to identify skew, shuffle, and spill
2. **Skew solutions** - AQE, salting, broadcast joins, repartitioning
3. **DESCRIBE HISTORY/DETAIL** - Key commands for table monitoring
4. **System tables** - Know billing, audit, and compute system tables
5. **Query profile** - Understand how to read SQL execution plans
6. **Pipeline monitoring** - DLT event log for data quality tracking

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Spark UI | [docs.databricks.com/en/compute/sparkling/index.html](https://docs.databricks.com/en/compute/sparkling/index.html) |
| Query Profile | [docs.databricks.com/en/sql/user/queries/query-profile.html](https://docs.databricks.com/en/sql/user/queries/query-profile.html) |
| Job Monitoring | [docs.databricks.com/en/workflows/jobs/monitor-job-runs.html](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html) |
| Delta History | [docs.databricks.com/en/delta/history.html](https://docs.databricks.com/en/delta/history.html) |
| System Tables | [docs.databricks.com/en/administration-guide/system-tables/index.html](https://docs.databricks.com/en/administration-guide/system-tables/index.html) |
| Audit Logs | [docs.databricks.com/en/admin/account-settings/audit-logs.html](https://docs.databricks.com/en/admin/account-settings/audit-logs.html) |
