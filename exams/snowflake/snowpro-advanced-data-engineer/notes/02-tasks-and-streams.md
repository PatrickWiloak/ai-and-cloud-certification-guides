# Tasks and Streams

**[📖 Tasks](https://docs.snowflake.com/en/user-guide/tasks-intro)** - Task orchestration
**[📖 Streams](https://docs.snowflake.com/en/user-guide/streams-intro)** - Change data capture

## Overview

This document covers Snowflake tasks and streams in depth, including task DAGs, stream types, CDC patterns, and monitoring. Tasks provide scheduling and orchestration, while streams provide change data capture. Together they form the foundation for event-driven data pipelines in Snowflake.

## Tasks

### Task Types
| Type | Compute | Use Case |
|------|---------|----------|
| Warehouse-based | User-specified warehouse | Complex queries, large transforms |
| Serverless | Snowflake-managed compute | Simple operations, variable workloads |

### Task Scheduling
```sql
-- CRON-based schedule
CREATE TASK hourly_load
  WAREHOUSE = pipeline_wh
  SCHEDULE = 'USING CRON 0 * * * * America/New_York'
AS
  COPY INTO raw_data FROM @source_stage;

-- Interval-based schedule (minutes)
CREATE TASK frequent_check
  WAREHOUSE = pipeline_wh
  SCHEDULE = '5 MINUTE'
AS
  CALL check_data_quality();
```

**[📖 Task Scheduling](https://docs.snowflake.com/en/user-guide/tasks-intro#scheduling-tasks)** - CRON and interval scheduling

### CRON Expression Format
```
# ┌───────── minute (0-59)
# │ ┌───────── hour (0-23)
# │ │ ┌───────── day of month (1-31)
# │ │ │ ┌───────── month (1-12)
# │ │ │ │ ┌───────── day of week (0-6, Sun=0)
# │ │ │ │ │
# * * * * *

# Examples:
'USING CRON 0 6 * * * UTC'              -- Daily at 6 AM UTC
'USING CRON 0 */2 * * * America/Chicago' -- Every 2 hours
'USING CRON 0 0 * * 1-5 UTC'            -- Midnight weekdays
'USING CRON 30 8 1 * * UTC'             -- 8:30 AM on 1st of month
```

### Task DAGs (Directed Acyclic Graphs)

#### Structure
- Root task: has a SCHEDULE, triggers the DAG
- Child tasks: use AFTER clause, run when parent completes
- Only root tasks can have SCHEDULE
- Child tasks can have multiple predecessors (AND logic - all must complete)
- Maximum depth: 1000 tasks in a single DAG

```sql
-- Root task
CREATE TASK ingest_task
  WAREHOUSE = pipeline_wh
  SCHEDULE = '10 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('source_stream')
AS
  INSERT INTO staging FROM source_stream;

-- First-level children (run after ingest_task)
CREATE TASK transform_a
  WAREHOUSE = pipeline_wh
  AFTER ingest_task
AS
  INSERT INTO dim_customers SELECT ... FROM staging;

CREATE TASK transform_b
  WAREHOUSE = pipeline_wh
  AFTER ingest_task
AS
  INSERT INTO dim_products SELECT ... FROM staging;

-- Second-level child (runs after BOTH transform_a and transform_b)
CREATE TASK aggregate_task
  WAREHOUSE = pipeline_wh
  AFTER transform_a, transform_b
AS
  INSERT INTO fact_sales SELECT ... FROM dim_customers JOIN dim_products;
```

**[📖 Task DAGs](https://docs.snowflake.com/en/user-guide/tasks-intro#dag-of-tasks)** - DAG configuration

#### Resuming and Suspending DAGs
```sql
-- Resume: children first, then root (bottom-up)
ALTER TASK aggregate_task RESUME;
ALTER TASK transform_a RESUME;
ALTER TASK transform_b RESUME;
ALTER TASK ingest_task RESUME;  -- Root task last

-- Suspend: root first (top-down)
ALTER TASK ingest_task SUSPEND;  -- Root task first
-- Children will not run since root is suspended
```

- Root task must be resumed LAST (after all children)
- Root task must be suspended FIRST (before modifying children)
- Cannot modify a child task while root task is running

### Serverless Tasks
```sql
-- Serverless task (no warehouse specified)
CREATE TASK cleanup_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON 0 0 * * * UTC'
AS
  DELETE FROM temp_data WHERE created_at < DATEADD('day', -7, CURRENT_DATE());
```

- Snowflake manages compute resources automatically
- Initial size hint provided, Snowflake auto-scales as needed
- Billed at serverless credit rate (different from warehouse credits)
- Best for variable workloads or simple operations
- No warehouse management overhead

**[📖 Serverless Tasks](https://docs.snowflake.com/en/user-guide/tasks-intro#serverless-tasks)** - Serverless compute

### Conditional Execution
```sql
-- WHEN clause with stream check
CREATE TASK process_changes
  WAREHOUSE = pipeline_wh
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
  MERGE INTO orders_summary ...;

-- WHEN clause with custom condition
CREATE TASK monthly_report
  WAREHOUSE = report_wh
  SCHEDULE = 'USING CRON 0 0 * * * UTC'
  WHEN DAY(CURRENT_DATE()) = 1
AS
  CALL generate_monthly_report();
```

- WHEN evaluates before warehouse starts (no compute cost if false)
- SYSTEM$STREAM_HAS_DATA checks if stream has unconsumed changes
- Boolean expressions can use SQL functions
- Task skipped silently when WHEN evaluates to FALSE

### Task Error Handling
```sql
-- Configure error notifications
CREATE NOTIFICATION INTEGRATION task_errors
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AWS_SNS
  DIRECTION = OUTBOUND
  AWS_SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789:task-errors'
  AWS_SNS_ROLE_ARN = 'arn:aws:iam::123456789:role/sns-role'
  ENABLED = TRUE;

-- Set error integration on task
ALTER TASK ingest_task SET ERROR_INTEGRATION = task_errors;

-- Configure retry
ALTER TASK ingest_task SET
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3;
```

- Tasks suspended after configurable number of consecutive failures
- Error notifications via cloud messaging (SNS, Event Grid, Pub/Sub)
- TASK_HISTORY tracks success, failure, and skip states
- Failed tasks do not trigger child tasks in the DAG

## Streams

### Stream Architecture
- Streams track changes (CDC) on source tables
- Changes tracked via hidden offset metadata on the table
- Stream does not store data - it references the source table
- Consuming a stream (DML within transaction) advances the offset
- Stream data is available until consumed or retention period expires

**[📖 Stream Internals](https://docs.snowflake.com/en/user-guide/streams-intro)** - Stream mechanics

### Stream Types
| Type | Tracks | Source Object | Use Case |
|------|--------|---------------|----------|
| Standard | INSERT, UPDATE, DELETE | Tables, views | Full CDC with all changes |
| Append-only | INSERT only | Tables | Log/event data, append workloads |
| Insert-only | INSERT only | External tables, directory tables | External data tracking |

### Metadata Columns
| Column | Type | Description |
|--------|------|-------------|
| METADATA$ACTION | VARCHAR | 'INSERT' or 'DELETE' |
| METADATA$ISUPDATE | BOOLEAN | TRUE if row is part of an UPDATE |
| METADATA$ROW_ID | VARCHAR | Unique row identifier |

- UPDATE appears as DELETE (old row) + INSERT (new row)
- Both rows have METADATA$ISUPDATE = TRUE
- DELETE appears as DELETE with METADATA$ISUPDATE = FALSE
- INSERT appears as INSERT with METADATA$ISUPDATE = FALSE

### Stream Consumption
```sql
-- Create stream
CREATE STREAM orders_stream ON TABLE orders;

-- View current changes
SELECT * FROM orders_stream;

-- Consume changes (advances offset on commit)
BEGIN;
  INSERT INTO orders_archive
    SELECT order_id, amount, CURRENT_TIMESTAMP()
    FROM orders_stream
    WHERE METADATA$ACTION = 'INSERT';
COMMIT;
-- Stream offset advances after commit

-- Stream is now empty (changes consumed)
SELECT * FROM orders_stream;  -- Returns 0 rows
```

### Stream Staleness
- Streams have a data retention period (matches source table Time Travel)
- If stream is not consumed within retention period, it becomes stale
- Stale streams cannot be consumed and must be recreated
- Default retention: 1 day (Standard edition), up to 90 days (Enterprise+)
- Monitor stream freshness to avoid staleness

```sql
-- Check stream staleness
SELECT name, stale, stale_after
FROM INFORMATION_SCHEMA.STREAMS
WHERE name = 'ORDERS_STREAM';
```

### Streams on Views
```sql
-- Stream on a view (Enterprise edition required)
CREATE VIEW active_orders AS
  SELECT * FROM orders WHERE status = 'ACTIVE';

CREATE STREAM active_orders_stream ON VIEW active_orders;
```

- Streams on views track changes that affect the view's result set
- Useful for tracking changes to a filtered or joined dataset
- Requires Enterprise edition or higher

## Combined Patterns

### Pattern 1: Simple Incremental Load
```sql
-- Source stream
CREATE STREAM new_events ON TABLE raw_events APPEND_ONLY = TRUE;

-- Scheduled task to process new events
CREATE TASK process_events
  WAREHOUSE = etl_wh
  SCHEDULE = '5 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('new_events')
AS
  INSERT INTO processed_events
  SELECT event_id, event_type, payload,
         PARSE_JSON(payload):user_id::INTEGER AS user_id,
         CURRENT_TIMESTAMP() AS processed_at
  FROM new_events;
```

### Pattern 2: SCD Type 2 Implementation
```sql
-- Track all changes on source
CREATE STREAM customer_changes ON TABLE customers;

-- Task implements SCD Type 2
CREATE TASK update_customer_dim
  WAREHOUSE = etl_wh
  SCHEDULE = '10 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('customer_changes')
AS
  MERGE INTO dim_customer t
  USING (
    SELECT *, METADATA$ACTION AS action, METADATA$ISUPDATE AS is_update
    FROM customer_changes
  ) s
  ON t.customer_id = s.customer_id AND t.is_current = TRUE
  WHEN MATCHED AND s.is_update THEN
    UPDATE SET t.is_current = FALSE, t.end_date = CURRENT_TIMESTAMP()
  WHEN NOT MATCHED AND s.action = 'INSERT' THEN
    INSERT (customer_id, name, email, start_date, end_date, is_current)
    VALUES (s.customer_id, s.name, s.email, CURRENT_TIMESTAMP(), NULL, TRUE);
```

## Monitoring

### Task History
```sql
-- Recent task executions
SELECT name, state, error_code, error_message,
       query_start_time, completed_time,
       DATEDIFF('second', query_start_time, completed_time) AS duration_seconds
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  SCHEDULED_TIME_RANGE_START => DATEADD('day', -1, CURRENT_TIMESTAMP()),
  RESULT_LIMIT => 100
))
ORDER BY scheduled_time DESC;

-- Task run states
-- SUCCEEDED: completed successfully
-- FAILED: execution error
-- SKIPPED: WHEN condition was FALSE
-- CANCELLED: task was suspended during execution
```

### Stream Monitoring
```sql
-- Check all streams
SELECT name, table_name, type, stale, stale_after, owner
FROM INFORMATION_SCHEMA.STREAMS;

-- Check if stream has data (lightweight check)
SELECT SYSTEM$STREAM_HAS_DATA('my_stream');
```
