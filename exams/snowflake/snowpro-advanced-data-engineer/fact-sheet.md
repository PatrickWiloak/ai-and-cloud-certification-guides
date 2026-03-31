# SnowPro Advanced - Data Engineer - Fact Sheet

## Quick Reference

**Exam Code:** ADE-C01
**Duration:** 115 minutes
**Questions:** 65 questions
**Passing Score:** 750/1000
**Cost:** $375 USD
**Validity:** 2 years
**Prerequisite:** SnowPro Core (active)
**Difficulty:** ⭐⭐⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Data Movement | 25-30% | Snowpipe, Streaming, COPY INTO, Kafka |
| Data Pipelines and Transformations | 25-30% | Tasks, streams, dynamic tables, Snowpark |
| Performance and Optimization | 20-25% | Warehouse sizing, clustering, cost |
| Data Governance and Security | 15-20% | RBAC, masking, tagging, audit |

## Data Loading Methods

### Snowpipe (Continuous Loading)
- Event-driven loading from cloud storage stages
- Triggered by cloud notifications (S3 SQS, Azure Event Grid, GCP Pub/Sub)
- REST API available for manual file submission
- Serverless - no warehouse required
- Typical latency: 1-2 minutes
- Billed per file loaded (serverless credit rate)
- **[📖 Snowpipe](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)** - Snowpipe overview

```sql
-- Create pipe with auto-ingest
CREATE PIPE my_pipe AUTO_INGEST = TRUE AS
  COPY INTO my_table
  FROM @my_stage/data/
  FILE_FORMAT = (TYPE = 'PARQUET');

-- Check pipe status
SELECT SYSTEM$PIPE_STATUS('my_pipe');

-- View loading history
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'my_table',
  START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
));
```

### Snowpipe Streaming
- Row-level API-based ingestion (no file staging)
- Sub-second latency for real-time use cases
- Snowflake Ingest SDK (Java) for client integration
- Kafka connector supports Snowpipe Streaming mode
- Rows buffered client-side, flushed to Snowflake in micro-batches
- Serverless compute for ingestion processing
- **[📖 Snowpipe Streaming](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-streaming-overview)** - Streaming overview

### Snowpipe vs Snowpipe Streaming
| Feature | Snowpipe | Snowpipe Streaming |
|---------|----------|-------------------|
| Input | Files in stages | Rows via API |
| Latency | 1-2 minutes | Sub-second |
| Trigger | Cloud events / REST API | Client SDK push |
| File staging | Required | Not required |
| SDK | None (file-based) | Java Ingest SDK |
| Kafka support | Snowpipe mode | Streaming mode |
| Cost model | Per-file serverless | Per-row serverless |

### COPY INTO (Bulk Loading)
```sql
-- Bulk load from stage
COPY INTO my_table
  FROM @my_stage/data/2024/
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1)
  ON_ERROR = 'CONTINUE'
  PURGE = TRUE;

-- Load with transformation
COPY INTO my_table (id, name, created_date)
  FROM (SELECT $1, $2, TO_DATE($3, 'YYYY-MM-DD')
        FROM @my_stage/data/)
  FILE_FORMAT = (TYPE = 'CSV');

-- Validate before loading
COPY INTO my_table
  FROM @my_stage/data/
  VALIDATION_MODE = 'RETURN_ERRORS';
```

- **[📖 COPY INTO](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)** - Bulk loading reference

## Tasks and Streams

### Tasks
- Schedule SQL statements or stored procedure calls
- CRON or interval-based scheduling
- Task trees (DAGs) for multi-step pipelines
- Serverless tasks or warehouse-based execution
- Conditional execution with WHEN clause

**[📖 Tasks](https://docs.snowflake.com/en/user-guide/tasks-intro)** - Task orchestration

```sql
-- Root task (scheduled)
CREATE TASK load_raw
  WAREHOUSE = pipeline_wh
  SCHEDULE = 'USING CRON 0 */1 * * * America/New_York'
AS
  COPY INTO raw_events FROM @event_stage;

-- Child task (runs after parent)
CREATE TASK transform_events
  WAREHOUSE = pipeline_wh
  AFTER load_raw
AS
  INSERT INTO curated_events
  SELECT event_id, event_type, TO_TIMESTAMP(event_ts)
  FROM raw_events_stream;

-- Serverless task
CREATE TASK cleanup_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON 0 0 * * * UTC'
AS
  DELETE FROM staging_table WHERE load_date < DATEADD('day', -7, CURRENT_DATE());

-- Resume tasks (root task last)
ALTER TASK transform_events RESUME;
ALTER TASK load_raw RESUME;
```

### Task DAGs
- Root task has a schedule, child tasks use AFTER clause
- Only root task can have a SCHEDULE
- Child tasks execute when parent completes successfully
- Entire DAG fails if any task fails (configurable)
- Monitor with TASK_HISTORY function

### Streams (Change Data Capture)
- Track row-level changes on tables (inserts, updates, deletes)
- Consume changes transactionally - stream advances on DML commit
- Three types: standard, append-only, insert-only
- Metadata columns: METADATA$ACTION, METADATA$ISUPDATE, METADATA$ROW_ID

**[📖 Streams](https://docs.snowflake.com/en/user-guide/streams-intro)** - CDC documentation

```sql
-- Create standard stream
CREATE STREAM orders_stream ON TABLE orders;

-- Create append-only stream (only inserts, better for append workloads)
CREATE STREAM events_stream ON TABLE events APPEND_ONLY = TRUE;

-- Consume stream in transformation
INSERT INTO order_summary
  SELECT order_date, SUM(amount) AS daily_total
  FROM orders_stream
  WHERE METADATA$ACTION = 'INSERT'
  GROUP BY order_date;

-- Check if stream has data
SELECT SYSTEM$STREAM_HAS_DATA('orders_stream');
```

### Stream Types
| Type | Tracks | Use Case |
|------|--------|----------|
| Standard | INSERT, UPDATE, DELETE | Full CDC with all changes |
| Append-only | INSERT only | Log/event tables, append workloads |
| Insert-only | INSERT only (external tables) | External table change tracking |

### Task + Stream Pattern
```sql
-- Task triggered by stream data
CREATE TASK process_orders
  WAREHOUSE = pipeline_wh
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
  MERGE INTO order_summary t
  USING (SELECT * FROM orders_stream) s
  ON t.order_id = s.order_id
  WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN DELETE
  WHEN MATCHED THEN UPDATE SET t.amount = s.amount
  WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN INSERT VALUES (s.order_id, s.amount);
```

## Dynamic Tables

### Overview
- Declarative pipeline definition using SQL query
- Snowflake manages incremental refresh automatically
- Target lag controls maximum data staleness
- Chain multiple dynamic tables for multi-step pipelines
- Alternative to task + stream pattern for many use cases

**[📖 Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)** - Dynamic table guide

```sql
-- Create dynamic table with target lag
CREATE DYNAMIC TABLE daily_summary
  TARGET_LAG = '1 hour'
  WAREHOUSE = pipeline_wh
AS
  SELECT DATE_TRUNC('day', order_date) AS summary_date,
         region,
         COUNT(*) AS order_count,
         SUM(amount) AS total_revenue
  FROM orders
  GROUP BY 1, 2;

-- Chain dynamic tables
CREATE DYNAMIC TABLE regional_rollup
  TARGET_LAG = '2 hours'
  WAREHOUSE = pipeline_wh
AS
  SELECT summary_date, region,
         total_revenue,
         total_revenue / SUM(total_revenue) OVER (PARTITION BY summary_date) AS revenue_pct
  FROM daily_summary;

-- Monitor refresh history
SELECT * FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
  NAME => 'daily_summary'
));
```

### Dynamic Tables vs Tasks/Streams
| Feature | Dynamic Tables | Tasks + Streams |
|---------|---------------|----------------|
| Definition | Declarative SQL | Imperative SQL/procedures |
| Scheduling | Automatic (target lag) | Manual (CRON/interval) |
| Incremental | Automatic | Manual stream consumption |
| Complexity | Low | Higher (manage task DAG + streams) |
| Flexibility | SQL only | SQL, procedures, Snowpark |
| Error handling | Automatic retry | Custom error handling |
| Use case | Standard transformations | Complex logic, external calls |

## Snowpark for Data Engineering

### Stored Procedures
```python
@session.sproc(name="transform_orders", replace=True,
               packages=["snowflake-snowpark-python"])
def transform_orders(session: Session, date: str) -> str:
    orders = session.table("raw_orders").filter(col("order_date") == date)
    enriched = orders.join(
        session.table("customers"),
        orders["customer_id"] == customers["id"]
    )
    enriched.write.mode("overwrite").save_as_table("enriched_orders")
    return f"Processed {enriched.count()} orders"
```

**[📖 Snowpark Stored Procedures](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-sprocs)** - Procedure development

### UDFs and UDTFs
```python
# Scalar UDF
@udf(name="parse_json_field", return_type=StringType(),
     input_types=[VariantType(), StringType()], replace=True)
def parse_json_field(data, field_name):
    import json
    parsed = json.loads(str(data))
    return parsed.get(field_name, None)

# Table function (UDTF)
class FlattenArray:
    def process(self, arr):
        import json
        for item in json.loads(str(arr)):
            yield (item,)
```

**[📖 UDFs](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udfs)** - UDF development

## Pipeline Monitoring

### Key Monitoring Views
```sql
-- Task execution history
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  SCHEDULED_TIME_RANGE_START => DATEADD('hour', -24, CURRENT_TIMESTAMP()),
  RESULT_LIMIT => 100
));

-- Pipe usage history
SELECT * FROM TABLE(INFORMATION_SCHEMA.PIPE_USAGE_HISTORY(
  DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
));

-- Copy history
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'my_table',
  START_TIME => DATEADD('day', -1, CURRENT_TIMESTAMP())
));

-- Dynamic table refresh history
SELECT * FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY());
```

## Exam Tips

### High-Value Topics
1. **Data Movement (25-30%):** Snowpipe vs Streaming, COPY INTO options, Kafka connector
2. **Pipelines (25-30%):** Tasks/streams vs dynamic tables, Snowpark procedures
3. **Performance (20-25%):** Warehouse sizing, clustering for pipeline outputs
4. **Governance (15-20%):** Pipeline permissions, masking, audit

### Common Exam Traps
- Confusing Snowpipe (file-based) with Snowpipe Streaming (API-based)
- Not knowing that only root tasks can have a SCHEDULE
- Thinking streams store data (they track offsets, not data)
- Not knowing append-only streams skip UPDATE and DELETE tracking
- Confusing dynamic table target lag with task schedule interval
- Thinking COPY INTO requires a warehouse for Snowpipe (Snowpipe is serverless)
- Not knowing that task DAGs must be resumed bottom-up (children first, then root)
- Forgetting SYSTEM$STREAM_HAS_DATA for conditional task execution
