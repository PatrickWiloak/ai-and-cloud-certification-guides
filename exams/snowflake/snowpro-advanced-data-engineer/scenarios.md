# SnowPro Advanced - Data Engineer - High-Yield Scenarios and Patterns

## Data Loading Scenarios

### Real-Time Fraud Detection Pipeline
**Scenario:** An e-commerce company needs transaction data available in Snowflake within seconds of each purchase for real-time fraud scoring. Their fraud detection model runs as a Snowpark UDF on the transaction table.

**Solution Pattern:**
- **Ingestion:** Snowpipe Streaming via Ingest SDK for sub-second latency
- **Table:** Landing table receives raw transaction rows
- **UDF:** Snowpark Python UDF applies fraud scoring model
- **Dynamic Table:** Dynamic table with short target lag joins transactions with fraud scores
- **Monitoring:** PIPE_USAGE_HISTORY for ingestion monitoring

**Common Distractors:**
- Using standard Snowpipe (wrong - 1-2 minute latency too slow for real-time fraud detection)
- Scheduled COPY INTO every minute (wrong - batch loading, cannot achieve sub-second)
- External tables pointing to source (wrong - no real-time ingestion, read-only access to files)
- Loading directly into the final enriched table (wrong - separate landing and enrichment layers)

### Multi-Format Data Lake Ingestion
**Scenario:** A company has data arriving in S3 in CSV, JSON, and Parquet formats from different source systems. Each format has different schemas. Data needs to be loaded into Snowflake hourly with error handling.

**Solution Pattern:**
- **Stages:** External stage pointing to S3 bucket with storage integration
- **Pipes:** Separate Snowpipe for each format with appropriate FILE_FORMAT
- **Error Handling:** ON_ERROR = 'CONTINUE' to skip bad records
- **Monitoring:** COPY_HISTORY to track load success/failure per file
- **Reconciliation:** Scheduled task to check for missing data

**Common Distractors:**
- Single pipe for all formats (wrong - each format needs its own FILE_FORMAT)
- Manual COPY INTO (wrong - hourly schedule needs automation via Snowpipe)
- Loading all data as VARIANT (wrong - loses type safety for structured formats)
- Using Snowpipe Streaming (wrong - data is already in S3 files, Snowpipe is appropriate)

### Kafka Integration for Event Streaming
**Scenario:** A microservices platform publishes events to Apache Kafka. The data team needs these events in Snowflake for analytics with minimal latency.

**Solution Pattern:**
- **Connector:** Snowflake Kafka Connector with Snowpipe Streaming mode
- **Configuration:** Kafka connector reads topics and streams rows to Snowflake
- **Landing Table:** Events land in a raw events table
- **Schema:** VARIANT column for flexible event schema
- **Downstream:** Dynamic tables or tasks transform raw events into analytics tables

**Common Distractors:**
- Writing custom producer to call COPY INTO (wrong - Kafka connector is the native solution)
- Using Snowpipe with Kafka producing files to S3 (wrong - extra hop, higher latency)
- External tables on Kafka (wrong - Snowflake does not support external tables on Kafka)
- Standard Snowpipe mode connector (wrong - Streaming mode provides lower latency)

## Pipeline Design Scenarios

### CDC Pipeline for Order Processing
**Scenario:** An orders table receives inserts, updates, and deletes throughout the day. A downstream summary table needs to reflect all changes within 5 minutes for dashboard reporting.

**Solution Pattern:**
- **Stream:** Standard stream on orders table (tracks all DML)
- **Task:** Scheduled task every 1 minute with WHEN SYSTEM$STREAM_HAS_DATA
- **MERGE:** Task performs MERGE INTO summary table from stream
- **Handling:** INSERT, UPDATE, DELETE all processed in single MERGE statement

```sql
CREATE STREAM orders_stream ON TABLE orders;

CREATE TASK update_summary
  WAREHOUSE = pipeline_wh
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
  MERGE INTO order_summary t
  USING (
    SELECT order_id, customer_id, amount, METADATA$ACTION, METADATA$ISUPDATE
    FROM orders_stream
  ) s
  ON t.order_id = s.order_id
  WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' AND NOT s.METADATA$ISUPDATE THEN DELETE
  WHEN MATCHED AND s.METADATA$ISUPDATE THEN UPDATE SET t.amount = s.amount
  WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN INSERT VALUES (s.order_id, s.customer_id, s.amount);
```

**Common Distractors:**
- Using append-only stream (wrong - misses updates and deletes)
- Dynamic table (possible but less control for complex MERGE logic)
- Scheduled COPY INTO (wrong - COPY INTO is for loading from stages, not table-to-table)
- Task without WHEN clause (wrong - wastes compute when no changes exist)

### Event Log Processing
**Scenario:** An application generates millions of append-only log events daily. The events never get updated or deleted. A downstream table needs hourly aggregations by event type and severity.

**Solution Pattern:**
- **Stream:** Append-only stream on the log events table
- **Reasoning:** Append-only is more efficient since events are never updated/deleted
- **Alternative:** Dynamic table with 1-hour target lag for the aggregation
- **Monitoring:** Track stream offset advancement

**Common Distractors:**
- Standard stream (wrong - unnecessary overhead tracking updates/deletes that never happen)
- Insert-only stream (wrong - insert-only is for external tables, not regular tables)
- Materialized view (wrong - limited to single-table queries, no complex aggregation chains)
- Manual periodic queries (wrong - no automation, risk of missing data)

### Multi-Step Transformation Pipeline
**Scenario:** Raw sales data needs three transformation stages: cleansing, enrichment (join with dimensions), and aggregation. The final output feeds a BI dashboard that requires data no more than 2 hours stale.

**Solution Pattern:**
- **Stage 1:** Dynamic table for cleansing (target lag: 30 minutes)
- **Stage 2:** Dynamic table for enrichment with joins (target lag: 1 hour)
- **Stage 3:** Dynamic table for aggregation (target lag: 2 hours)
- **Chain:** Each dynamic table reads from the previous stage
- **Snowflake manages:** Incremental refresh and scheduling automatically

**Common Distractors:**
- Three separate tasks with manual scheduling (wrong - more complex than needed for SQL transformations)
- Single dynamic table with all logic (wrong - harder to debug, monitor, and maintain)
- Materialized views chained together (wrong - MVs cannot join multiple tables)
- External orchestration tool like Airflow (wrong - unnecessary complexity for SQL pipelines)

## Snowpark Scenarios

### Complex Business Logic Transformation
**Scenario:** A data pipeline needs to apply custom validation rules to incoming data. Rules include regex pattern matching, cross-field validation, and lookups against an external API for address standardization.

**Solution Pattern:**
- **Stored Procedure:** Snowpark Python stored procedure for orchestration
- **UDF:** Python UDF for regex validation (runs in Snowflake)
- **External Function:** External function for address standardization API
- **Task:** Scheduled task calls the stored procedure
- **Error Handling:** Invalid records routed to error table

**Common Distractors:**
- SQL-only approach (wrong - complex regex and API calls not practical in SQL)
- Processing data outside Snowflake (wrong - moves data out, loses governance)
- Single monolithic UDF (wrong - separate concerns: validation vs enrichment)
- JavaScript UDF for Python logic (wrong - Python is better suited for complex logic)

### ML Feature Engineering Pipeline
**Scenario:** A data science team needs to build a feature engineering pipeline that creates hundreds of features from raw data using pandas and scikit-learn transformations. Features need to be refreshed daily.

**Solution Pattern:**
- **Stored Procedure:** Snowpark Python with pandas and scikit-learn packages
- **DataFrame API:** Read source data using Snowpark DataFrames
- **Vectorized UDFs:** Use vectorized UDFs for batch feature calculations
- **Output:** Write feature table using save_as_table
- **Schedule:** Daily task calls the stored procedure

```python
@session.sproc(name="build_features", replace=True,
               packages=["snowflake-snowpark-python", "pandas", "scikit-learn"])
def build_features(session: Session, date: str) -> str:
    df = session.table("raw_data").filter(col("date") == date).to_pandas()
    from sklearn.preprocessing import StandardScaler
    scaler = StandardScaler()
    df[["feature_1_scaled", "feature_2_scaled"]] = scaler.fit_transform(df[["value_1", "value_2"]])
    session.write_pandas(df, "feature_store", auto_create_table=True, overwrite=True)
    return f"Built features for {len(df)} records"
```

**Common Distractors:**
- Extracting data to external compute (wrong - data movement overhead, governance risk)
- SQL-only feature engineering (wrong - complex ML transformations need Python libraries)
- Dynamic tables for ML features (wrong - cannot use Python packages in dynamic table SQL)
- Materialized views (wrong - limited SQL, no Python package support)

## Monitoring and Troubleshooting

### Pipeline Failure Diagnosis
**Scenario:** A nightly task DAG that processes sales data failed at 3 AM. The team needs to identify which step failed, understand the error, and determine data impact.

**Solution Pattern:**
```sql
-- Check task history for failures
SELECT name, state, error_code, error_message, scheduled_time
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  SCHEDULED_TIME_RANGE_START => DATEADD('hour', -12, CURRENT_TIMESTAMP()),
  RESULT_LIMIT => 50
))
WHERE state = 'FAILED'
ORDER BY scheduled_time DESC;

-- Check specific task run details
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  TASK_NAME => 'transform_sales'
))
ORDER BY scheduled_time DESC
LIMIT 5;
```

**Common Distractors:**
- Checking QUERY_HISTORY only (wrong - task failures may not have query history entries)
- Looking at PIPE_USAGE_HISTORY (wrong - this is for Snowpipe, not tasks)
- Checking ACCESS_HISTORY (wrong - this tracks data access, not execution errors)

## Key Decision Factors

### Pipeline Technology Selection
1. **File-based loading from cloud storage:** Snowpipe auto-ingest
2. **Sub-second streaming ingestion:** Snowpipe Streaming
3. **One-time or ad-hoc bulk load:** COPY INTO
4. **Simple SQL transformations with freshness SLA:** Dynamic tables
5. **Complex CDC with MERGE logic:** Tasks + streams
6. **Python/ML transformations:** Snowpark stored procedures
7. **Reusable row-level logic:** UDFs (scalar or vectorized)
8. **Row-expanding transformations:** UDTFs
9. **External API integration:** External functions
10. **Kafka event streaming:** Kafka connector with Streaming mode
