# Incremental Data Processing - Databricks Data Engineer Associate

## Overview

This section covers Structured Streaming and Auto Loader for incremental data processing, representing 17% of the exam. You need to understand streaming fundamentals, trigger modes, checkpointing, and Auto Loader configuration.

**[📖 Structured Streaming](https://docs.databricks.com/en/structured-streaming/index.html)** - Streaming overview
**[📖 Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - Incremental file ingestion

## Key Topics

### 1. Structured Streaming Fundamentals

Structured Streaming treats data streams as unbounded tables that grow continuously. New data arriving is treated as new rows appended to the table.

**[📖 Structured Streaming Concepts](https://docs.databricks.com/en/structured-streaming/index.html)** - Core streaming concepts

**Basic Streaming Pattern:**
```python
# Read a stream
stream_df = spark.readStream.format("delta").table("source_table")

# Apply transformations (same as batch)
transformed = stream_df.filter(col("status") == "active")

# Write the stream
query = (transformed.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/path/to/checkpoint")
    .table("target_table"))
```

**Key Concepts:**
- `spark.readStream` starts a streaming read (vs `spark.read` for batch)
- `.writeStream` starts a streaming write (vs `.write` for batch)
- Streaming DataFrames support the same transformations as batch
- Every streaming write requires a checkpoint location
- Streams run continuously until explicitly stopped or an error occurs

### 2. Trigger Modes

Trigger modes control when the streaming engine processes data.

**[📖 Streaming Triggers](https://docs.databricks.com/en/structured-streaming/triggers.html)** - Trigger configuration

| Trigger | Behavior | Use Case |
|---------|----------|----------|
| Default (unspecified) | Process as soon as previous batch completes | Low-latency continuous processing |
| `processingTime="10 seconds"` | Process at fixed intervals | Controlled resource usage |
| `availableNow=True` | Process all available data then stop | Scheduled batch-like streaming |
| `once=True` (deprecated) | Process one micro-batch then stop | Legacy; use `availableNow` instead |

```python
# Processing time trigger
query = df.writeStream.trigger(processingTime="30 seconds").start()

# Available now trigger (recommended for scheduled jobs)
query = df.writeStream.trigger(availableNow=True).start()
```

**Key Concepts:**
- `availableNow` is the recommended replacement for `once`
- `availableNow` processes all available data in multiple batches then stops
- `once` only processes one batch and may leave data unprocessed
- For scheduled jobs, `availableNow` is the best choice

### 3. Output Modes

**[📖 Output Modes](https://docs.databricks.com/en/structured-streaming/index.html)** - How results are written

| Mode | Behavior | Supported Operations |
|------|----------|---------------------|
| Append | Only new rows written to sink | No aggregations (default) |
| Complete | Entire result table written | Aggregations only |
| Update | Only changed rows written | Aggregations and maps |

**Key Concepts:**
- Append mode is the default and most common for Delta Lake sinks
- Complete mode rewrites the entire result - used with aggregations
- Update mode writes only rows that changed - efficient for aggregations
- Not all combinations of output mode and operations are supported

### 4. Checkpointing and Fault Tolerance

**Key Concepts:**
- Checkpoints store the state of a streaming query for fault recovery
- Checkpoint location must be a reliable, durable storage path (cloud storage)
- Each streaming query needs its own unique checkpoint directory
- Checkpoints enable exactly-once processing guarantees
- If a stream fails, it resumes from the last checkpoint on restart
- Never share checkpoint directories between different streaming queries
- Do not delete checkpoint directories unless you want to reprocess all data

### 5. Watermarking

Watermarking handles late-arriving data in streaming queries.

**[📖 Watermarks](https://docs.databricks.com/en/structured-streaming/watermarks.html)** - Late data handling

```python
# Allow data up to 10 minutes late
stream_df = (spark.readStream
    .format("delta")
    .table("events")
    .withWatermark("event_time", "10 minutes"))
```

**Key Concepts:**
- Watermark defines how late data can arrive and still be processed
- Data arriving after the watermark threshold is dropped
- Required for streaming aggregations with event-time windows
- Required for stream-stream joins
- Format: `.withWatermark("timestamp_column", "threshold")`
- Threshold examples: "10 minutes", "1 hour", "1 day"

### 6. Auto Loader

Auto Loader incrementally discovers and processes new files as they arrive in cloud storage. It is the recommended approach for file ingestion on Databricks.

**[📖 Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - Auto Loader overview
**[📖 Auto Loader Options](https://docs.databricks.com/en/ingestion/auto-loader/options.html)** - Configuration reference

```python
# Basic Auto Loader read
stream_df = (spark.readStream
    .format("cloudFiles")
    .option("cloudFiles.format", "json")
    .option("cloudFiles.schemaLocation", "/path/to/schema")
    .load("/path/to/source/files"))

# Write with checkpoint
(stream_df.writeStream
    .format("delta")
    .option("checkpointLocation", "/path/to/checkpoint")
    .trigger(availableNow=True)
    .table("target_table"))
```

**File Discovery Modes:**
| Mode | How It Works | Best For |
|------|-------------|----------|
| Directory listing | Scans directory for new files | Small directories, simple setup |
| File notification | Uses cloud events (SQS, Event Grid) | Large directories, production |

**Key Concepts:**
- Uses `cloudFiles` format identifier
- `cloudFiles.format` specifies the underlying file format (csv, json, parquet)
- `cloudFiles.schemaLocation` stores the inferred schema for consistency
- Schema inference detects schema automatically from the data
- Schema evolution handles new columns appearing in source files

### 7. Auto Loader Schema Evolution

**[📖 Schema Evolution](https://docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html)** - Handling schema changes

| Mode | Behavior |
|------|----------|
| `addNewColumns` | Automatically adds new columns to the table |
| `rescue` | Captures new/mismatched data in `_rescued_data` column |
| `failOnNewColumns` | Fails the stream when new columns appear |
| `none` | Ignores new columns silently |

```python
# Configure schema evolution
stream_df = (spark.readStream
    .format("cloudFiles")
    .option("cloudFiles.format", "json")
    .option("cloudFiles.schemaEvolutionMode", "addNewColumns")
    .option("cloudFiles.schemaLocation", "/path/to/schema")
    .load("/path/to/files"))
```

**Key Concepts:**
- The `_rescued_data` column captures data that does not match the schema
- `schemaHints` can provide type hints for columns with ambiguous types
- Schema location must be specified for Auto Loader to track schema changes

### 8. Auto Loader vs COPY INTO

| Feature | Auto Loader | COPY INTO |
|---------|-------------|-----------|
| Processing Model | Streaming | Batch |
| File Discovery | Automatic and continuous | Manual or scheduled |
| Schema Evolution | Built-in support | Limited |
| Scalability | Millions of files | Thousands of files |
| Setup Complexity | Moderate | Simple |
| Best For | Continuous ingestion at scale | Ad-hoc or one-time loading |

**Exam Tip:** Auto Loader is preferred when files arrive continuously and at scale. COPY INTO is suitable for simpler, one-time, or ad-hoc data loading tasks.

## Exam Tips for This Domain

1. **Auto Loader vs COPY INTO** - Know when to recommend each approach
2. **Trigger modes** - Understand `availableNow` vs `processingTime` vs default
3. **Checkpointing** - Every streaming write needs a unique checkpoint location
4. **Output modes** - Know which mode works with which operations
5. **Schema evolution modes** - Understand the four Auto Loader schema evolution options
6. **Watermarking** - Required for windowed aggregations and stream-stream joins
7. **File notification vs directory listing** - Know the tradeoffs

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Structured Streaming | [docs.databricks.com/en/structured-streaming/index.html](https://docs.databricks.com/en/structured-streaming/index.html) |
| Auto Loader | [docs.databricks.com/en/ingestion/auto-loader/index.html](https://docs.databricks.com/en/ingestion/auto-loader/index.html) |
| Auto Loader Options | [docs.databricks.com/en/ingestion/auto-loader/options.html](https://docs.databricks.com/en/ingestion/auto-loader/options.html) |
| Watermarks | [docs.databricks.com/en/structured-streaming/watermarks.html](https://docs.databricks.com/en/structured-streaming/watermarks.html) |
| Schema Evolution | [docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html](https://docs.databricks.com/en/ingestion/auto-loader/schema-evolution.html) |
