# Incremental Data Processing - Databricks Data Engineer Professional

## Overview

This section covers advanced incremental data processing, representing 20% of the exam. You need to master stream-stream joins, advanced Auto Loader patterns, stateful streaming, and the foreachBatch sink.

**[📖 Structured Streaming](https://docs.databricks.com/en/structured-streaming/index.html)** - Streaming reference
**[📖 Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - Incremental file ingestion

## Key Topics

### 1. Advanced Structured Streaming

**[📖 Streaming Guide](https://docs.databricks.com/en/structured-streaming/index.html)** - Complete streaming reference

**Key Concepts:**
- Streaming DataFrames are lazily evaluated like batch DataFrames
- Each micro-batch processes new data since the last checkpoint
- State management tracks intermediate results for aggregations and joins
- Monitor state size to prevent out-of-memory errors on long-running streams

### 2. Stream-Stream Joins

**[📖 Stream-Stream Joins](https://docs.databricks.com/en/structured-streaming/joining-streams.html)** - Joining two streams

```python
# Both streams must have watermarks
impressions = (spark.readStream.table("impressions")
    .withWatermark("impression_time", "2 hours"))

clicks = (spark.readStream.table("clicks")
    .withWatermark("click_time", "3 hours"))

# Join with time range condition
joined = impressions.join(
    clicks,
    expr("""
        impression_id = click_impression_id AND
        click_time >= impression_time AND
        click_time <= impression_time + interval 1 hour
    """),
    "leftOuter"
)
```

**Key Concepts:**
- Both streams must define watermarks for the join to work
- Time range conditions limit how long state is kept (bounds the join window)
- Without time bounds, state grows indefinitely and causes memory issues
- Supported join types: inner, left outer, right outer
- Outer joins produce null results after the watermark expires

### 3. Stream-Static Joins

**Key Concepts:**
- Streaming side drives the join - each micro-batch joins with the static table
- Static side is re-read in each micro-batch (latest version)
- No watermark required for the static side
- Useful for enriching streaming data with dimension tables
- Only the streaming side determines when processing occurs

```python
# Stream-static join
stream_df = spark.readStream.table("events")
static_df = spark.read.table("dim_users")

enriched = stream_df.join(static_df, "user_id", "left")
```

### 4. Watermarking and Late Data

**[📖 Watermarks](https://docs.databricks.com/en/structured-streaming/watermarks.html)** - Late data handling

```python
# Define watermark threshold
events = (spark.readStream.table("events")
    .withWatermark("event_time", "30 minutes"))

# Windowed aggregation with watermark
windowed = (events
    .groupBy(window("event_time", "10 minutes"))
    .count())
```

**Key Concepts:**
- Watermark = max event time seen - threshold
- Data arriving after the watermark is dropped
- Required for windowed aggregations and stream-stream joins
- Watermark threshold balances completeness vs latency
- Larger thresholds keep more state but handle more late data

### 5. foreachBatch Sink

The foreachBatch sink allows custom processing logic for each micro-batch using standard batch APIs.

```python
def process_batch(batch_df, batch_id):
    # Custom logic for each micro-batch
    batch_df.write.format("delta").mode("append").saveAsTable("target")
    # Can also write to external systems, call APIs, etc.

query = (stream_df.writeStream
    .foreachBatch(process_batch)
    .option("checkpointLocation", "/path/to/checkpoint")
    .start())
```

**Key Concepts:**
- `foreachBatch` receives a DataFrame and batch_id for each micro-batch
- Enables MERGE operations in streaming (write batch DataFrame with MERGE)
- Can write to multiple sinks from a single stream
- Supports calling external APIs or writing to non-Delta sinks
- The batch DataFrame is a regular DataFrame - all batch operations work

### 6. Streaming Deduplication

**[📖 Deduplication](https://docs.databricks.com/en/structured-streaming/stateful-processing.html)** - Streaming dedup

```python
# Deduplicate within watermark window
deduped = (stream_df
    .withWatermark("event_time", "1 hour")
    .dropDuplicatesWithinWatermark(["event_id"]))

# Deduplicate without watermark (keeps all state - use carefully)
deduped = stream_df.dropDuplicates(["event_id"])
```

**Key Concepts:**
- `dropDuplicatesWithinWatermark` limits state to the watermark window
- `dropDuplicates` without watermark keeps all state indefinitely (memory risk)
- Deduplication uses event keys to track which records have been seen
- Combine with watermark to bound state size

### 7. Advanced Auto Loader

**[📖 Auto Loader Options](https://docs.databricks.com/en/ingestion/auto-loader/options.html)** - Full configuration
**[📖 Schema Evolution](https://docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html)** - Schema handling

**File Notification Mode:**
```python
stream_df = (spark.readStream
    .format("cloudFiles")
    .option("cloudFiles.format", "json")
    .option("cloudFiles.useNotifications", "true")
    .option("cloudFiles.schemaLocation", "/path/to/schema")
    .load("/path/to/files"))
```

**Key Concepts:**
- File notification mode uses cloud-native events (SQS, Event Grid, Pub/Sub)
- More efficient than directory listing for directories with millions of files
- Auto Loader automatically sets up the cloud notification infrastructure
- `cloudFiles.schemaHints` provides type hints for ambiguous columns
- `cloudFiles.schemaLocation` persists inferred schema across restarts
- Rescue data column (`_rescued_data`) captures mismatched records

### 8. availableNow Trigger

```python
# Process all available data then stop
query = (stream_df.writeStream
    .trigger(availableNow=True)
    .option("checkpointLocation", "/path/to/checkpoint")
    .table("target"))
```

**Key Concepts:**
- Processes all data available since last checkpoint in multiple batches
- Stops automatically after all data is processed
- Ideal for scheduled jobs that need incremental processing
- Maintains checkpoint for consistent state tracking
- Replacement for the deprecated `trigger(once=True)`
- `availableNow` can split large backlogs into multiple batches for better memory management

## Exam Tips for This Domain

1. **Stream-stream joins** - Both sides need watermarks; time range conditions are critical
2. **foreachBatch** - Key pattern for MERGE operations in streaming
3. **State management** - Monitor state size; use watermarks to bound state
4. **availableNow vs once** - availableNow processes all data in multiple batches
5. **Deduplication** - Prefer `dropDuplicatesWithinWatermark` to bound state
6. **File notification mode** - Required for large-scale Auto Loader deployments

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Structured Streaming | [docs.databricks.com/en/structured-streaming/index.html](https://docs.databricks.com/en/structured-streaming/index.html) |
| Stream-Stream Joins | [docs.databricks.com/en/structured-streaming/joining-streams.html](https://docs.databricks.com/en/structured-streaming/joining-streams.html) |
| Watermarks | [docs.databricks.com/en/structured-streaming/watermarks.html](https://docs.databricks.com/en/structured-streaming/watermarks.html) |
| Auto Loader Options | [docs.databricks.com/en/ingestion/auto-loader/options.html](https://docs.databricks.com/en/ingestion/auto-loader/options.html) |
| Schema Evolution | [docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html](https://docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html) |
