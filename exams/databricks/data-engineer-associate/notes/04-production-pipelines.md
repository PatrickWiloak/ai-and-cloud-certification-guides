# Production Pipelines - Databricks Data Engineer Associate

## Overview

This section covers Delta Live Tables (DLT) and Databricks Jobs for production pipeline orchestration, representing 13% of the exam. You need to understand DLT syntax, expectations (data quality), pipeline modes, and job scheduling.

**[📖 Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html)** - DLT overview
**[📖 Databricks Jobs](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html)** - Job orchestration

## Key Topics

### 1. Delta Live Tables (DLT) Fundamentals

DLT provides a declarative framework for building reliable data pipelines. Instead of writing imperative code that specifies how to process data, you declare what transformations to apply and DLT manages the execution.

**[📖 DLT Concepts](https://docs.databricks.com/en/delta-live-tables/index.html)** - Core DLT concepts
**[📖 DLT Python](https://docs.databricks.com/en/delta-live-tables/python-ref.html)** - Python API reference
**[📖 DLT SQL](https://docs.databricks.com/en/delta-live-tables/sql-ref.html)** - SQL API reference

**Python DLT Syntax:**
```python
import dlt

# Materialized table (persisted to storage)
@dlt.table(comment="Cleaned customer data")
def silver_customers():
    return spark.read.table("bronze_customers").filter(col("id").isNotNull())

# Streaming table
@dlt.table
def bronze_events():
    return spark.readStream.format("cloudFiles").option("cloudFiles.format", "json").load("/data/events")

# View (not persisted, intermediate computation)
@dlt.view
def valid_orders():
    return spark.read.table("bronze_orders").filter(col("amount") > 0)
```

**SQL DLT Syntax:**
```sql
-- Materialized view
CREATE OR REFRESH MATERIALIZED VIEW silver_customers AS
SELECT * FROM bronze_customers WHERE id IS NOT NULL;

-- Streaming table
CREATE OR REFRESH STREAMING TABLE bronze_events AS
SELECT * FROM STREAM(LIVE.raw_events);

-- Live table reference
SELECT * FROM LIVE.source_table;
```

**Key Concepts:**
- `@dlt.table` creates a materialized (persisted) table
- `@dlt.view` creates a temporary view (not persisted, used for intermediate steps)
- Streaming tables process data incrementally using Structured Streaming
- The `LIVE` keyword references other tables in the same pipeline
- DLT handles dependency resolution automatically based on table references

### 2. DLT Expectations (Data Quality)

Expectations are declarative data quality constraints that enforce rules on your pipeline data.

**[📖 DLT Expectations](https://docs.databricks.com/en/delta-live-tables/expectations.html)** - Data quality constraints

**Three Expectation Behaviors:**

| Decorator | Behavior on Violation | Use Case |
|-----------|----------------------|----------|
| `@dlt.expect("name", "condition")` | Warn and keep invalid records | Monitor quality without blocking |
| `@dlt.expect_or_drop("name", "condition")` | Drop invalid records silently | Filter out bad data |
| `@dlt.expect_or_fail("name", "condition")` | Fail the entire pipeline | Critical data quality requirements |

```python
@dlt.table
@dlt.expect("valid_id", "id IS NOT NULL")
@dlt.expect_or_drop("positive_amount", "amount > 0")
@dlt.expect_or_fail("known_country", "country IN ('US', 'UK', 'CA')")
def silver_orders():
    return spark.read.table("bronze_orders")
```

```sql
-- SQL expectations
CREATE OR REFRESH MATERIALIZED VIEW silver_orders (
  CONSTRAINT valid_id EXPECT (id IS NOT NULL),
  CONSTRAINT positive_amount EXPECT (amount > 0) ON VIOLATION DROP ROW,
  CONSTRAINT known_country EXPECT (country IN ('US', 'UK', 'CA')) ON VIOLATION FAIL UPDATE
) AS SELECT * FROM LIVE.bronze_orders;
```

**Key Concepts:**
- Multiple expectations can be applied to a single table
- Expectation results are tracked in the DLT event log
- `expect` logs violations as warnings but keeps all records (default)
- `expect_or_drop` silently removes records that violate the constraint
- `expect_or_fail` stops the pipeline to prevent bad data from propagating

### 3. DLT Pipeline Modes

**[📖 Pipeline Modes](https://docs.databricks.com/en/delta-live-tables/updates.html)** - Triggered vs continuous

| Mode | Behavior | Cost | Use Case |
|------|----------|------|----------|
| Triggered | Processes data once then stops | Lower (compute stops) | Scheduled batch processing |
| Continuous | Runs continuously, processes as data arrives | Higher (always running) | Low-latency streaming |

**Key Concepts:**
- Triggered mode is used with scheduled jobs for batch processing
- Continuous mode keeps the pipeline running for real-time data
- Development mode allows faster iteration with relaxed error handling
- Production mode enforces strict error handling and retries
- Pipeline updates can be full refresh (reprocess everything) or incremental

### 4. DLT Event Log

The event log captures pipeline execution details and data quality metrics.

**Key Concepts:**
- Event log records pipeline start, progress, and completion events
- Data quality metrics show how many records pass or fail each expectation
- Accessible through the DLT pipeline UI or by querying the event log table
- Useful for monitoring pipeline health and data quality trends

### 5. Databricks Jobs

Databricks Jobs allow you to schedule and orchestrate tasks including notebooks, Python scripts, SQL queries, and DLT pipelines.

**[📖 Create and Run Jobs](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html)** - Job management
**[📖 Multi-task Jobs](https://docs.databricks.com/en/workflows/jobs/use-task-values.html)** - Task dependencies

**Task Types:**
| Task Type | Description |
|-----------|-------------|
| Notebook | Run a Databricks notebook |
| Python script | Run a Python file |
| SQL | Execute SQL statements |
| DLT pipeline | Trigger a DLT pipeline update |
| dbt | Run dbt transformations |
| JAR | Run a Java/Scala application |

**Key Concepts:**
- Jobs can contain multiple tasks with DAG-style dependencies
- Tasks can share values using `dbutils.jobs.taskValues`
- Each task can use its own cluster or share a job cluster
- Job clusters are more cost-effective than all-purpose clusters for jobs

### 6. Job Scheduling and Monitoring

**[📖 Job Scheduling](https://docs.databricks.com/en/workflows/jobs/schedule-jobs.html)** - Schedule configuration
**[📖 Job Monitoring](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html)** - Monitoring runs

**Key Concepts:**
- Cron-based scheduling with timezone support
- Manual triggers for ad-hoc runs
- Notifications via email, webhook, or Slack on job events (start, success, failure)
- Retry policies: configure number of retries on task failure
- Timeout settings prevent runaway jobs
- Run history shows status, duration, and logs for each run
- Concurrent run settings control whether multiple instances can run simultaneously

### 7. Job Parameters and Task Values

```python
# Set a task value
dbutils.jobs.taskValues.set(key="row_count", value=1000)

# Get a task value from an upstream task
count = dbutils.jobs.taskValues.get(taskKey="upstream_task", key="row_count")
```

**Key Concepts:**
- Task values enable data passing between tasks in a multi-task job
- Parameters can be set at the job level and passed to all tasks
- Dynamic values enable conditional execution in downstream tasks

## Exam Tips for This Domain

1. **DLT expectations** - Know all three behaviors (warn, drop, fail) and their SQL equivalents
2. **Pipeline modes** - Triggered for scheduled batch, continuous for real-time
3. **DLT table vs view** - Tables are persisted, views are intermediate computations
4. **Job clusters vs all-purpose** - Job clusters are recommended for production jobs
5. **Task dependencies** - Understand DAG-style orchestration in multi-task jobs
6. **Streaming tables** - Know the difference between streaming and materialized tables in DLT

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Delta Live Tables | [docs.databricks.com/en/delta-live-tables/index.html](https://docs.databricks.com/en/delta-live-tables/index.html) |
| DLT Expectations | [docs.databricks.com/en/delta-live-tables/expectations.html](https://docs.databricks.com/en/delta-live-tables/expectations.html) |
| DLT Python API | [docs.databricks.com/en/delta-live-tables/python-ref.html](https://docs.databricks.com/en/delta-live-tables/python-ref.html) |
| DLT SQL API | [docs.databricks.com/en/delta-live-tables/sql-ref.html](https://docs.databricks.com/en/delta-live-tables/sql-ref.html) |
| Databricks Jobs | [docs.databricks.com/en/workflows/jobs/create-run-jobs.html](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html) |
| Job Monitoring | [docs.databricks.com/en/workflows/jobs/monitor-job-runs.html](https://docs.databricks.com/en/workflows/jobs/monitor-job-runs.html) |
