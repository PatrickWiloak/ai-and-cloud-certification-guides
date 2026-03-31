# Snowpipe Streaming

**[📖 Snowpipe Streaming](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-streaming-overview)** - Streaming ingestion overview

## Overview

This document covers Snowpipe and Snowpipe Streaming, the two primary continuous data loading mechanisms in Snowflake. Understanding the differences, architecture, and use cases for each is critical for the Advanced Data Engineer exam.

## Snowpipe (File-Based Continuous Loading)

### Architecture
- Serverless compute layer processes staged files automatically
- Triggered by cloud event notifications when files land in a stage
- REST API available for manual file submission (insertFiles endpoint)
- No warehouse required - Snowflake manages the compute
- Billing based on serverless compute time per file processed

**[📖 Snowpipe Overview](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)** - Snowpipe documentation

### Auto-Ingest Configuration
```sql
-- Create storage integration
CREATE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789:role/snowflake-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-bucket/data/')
  ENABLED = TRUE;

-- Create external stage
CREATE STAGE my_stage
  STORAGE_INTEGRATION = s3_integration
  URL = 's3://my-bucket/data/'
  FILE_FORMAT = (TYPE = 'JSON');

-- Create pipe with auto-ingest
CREATE PIPE events_pipe AUTO_INGEST = TRUE AS
  COPY INTO raw_events
  FROM @my_stage
  FILE_FORMAT = (TYPE = 'JSON')
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
```

### Cloud Event Notifications
| Cloud Provider | Notification Service | Configuration |
|---------------|---------------------|---------------|
| AWS | S3 Event Notification to SQS | Configure SQS queue, Snowflake polls queue |
| Azure | Azure Event Grid | Event Grid subscription on Blob container |
| GCP | GCS Pub/Sub Notification | Pub/Sub subscription on GCS bucket |

**[📖 Auto-Ingest S3](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-s3)** - S3 auto-ingest setup
**[📖 Auto-Ingest Azure](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-azure)** - Azure auto-ingest setup
**[📖 Auto-Ingest GCS](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-gcs)** - GCS auto-ingest setup

### Snowpipe Monitoring
```sql
-- Check pipe status
SELECT SYSTEM$PIPE_STATUS('events_pipe');
-- Returns: executionState, pendingFileCount, lastReceivedMessageTimestamp

-- Copy history for a table
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'raw_events',
  START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
));

-- Pipe usage history (billing)
SELECT * FROM TABLE(INFORMATION_SCHEMA.PIPE_USAGE_HISTORY(
  DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP()),
  PIPE_NAME => 'events_pipe'
));
```

### Error Handling
- Files that fail to load are tracked in COPY_HISTORY with error details
- VALIDATION_MODE can test files before committing to pipe
- ON_ERROR options control behavior: CONTINUE, SKIP_FILE, ABORT_STATEMENT
- Failed files can be reprocessed after fixing issues

## Snowpipe Streaming

### Architecture
- Row-level API-based ingestion without file staging
- Client uses Snowflake Ingest SDK (Java) to push rows
- Rows buffered client-side in memory
- Client flushes buffered rows to Snowflake in micro-batches
- Snowflake processes micro-batches and commits to table
- Sub-second end-to-end latency achievable

**[📖 Snowpipe Streaming Overview](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-streaming-overview)** - Streaming architecture

### Ingest SDK Usage
```java
// Java Ingest SDK example
import net.snowflake.ingest.streaming.*;

// Create client
SnowflakeStreamingIngestClient client = SnowflakeStreamingIngestClientFactory
  .builder("MY_CLIENT")
  .setProperties(props)
  .build();

// Open channel to table
SnowflakeStreamingIngestChannel channel = client.openChannel(
  OpenChannelRequest.builder("MY_CHANNEL")
    .setDBName("MY_DB")
    .setSchemaName("PUBLIC")
    .setTableName("MY_TABLE")
    .setOnErrorOption(OpenChannelRequest.OnErrorOption.CONTINUE)
    .build()
);

// Insert rows
Map<String, Object> row = new HashMap<>();
row.put("id", 1);
row.put("name", "Alice");
row.put("timestamp", System.currentTimeMillis());
channel.insertRow(row, "offset_1");
```

### Kafka Connector Streaming Mode
- Snowflake Kafka Connector supports Snowpipe Streaming as ingestion method
- Configuration: `snowflake.ingestion.method=SNOWPIPE_STREAMING`
- Lower latency than standard Snowpipe mode (which stages files first)
- Exactly-once semantics with offset tracking
- Recommended for new Kafka integrations requiring low latency

**[📖 Kafka Connector](https://docs.snowflake.com/en/user-guide/kafka-connector-overview)** - Kafka integration

### Key Differences Summary
| Aspect | Snowpipe | Snowpipe Streaming |
|--------|----------|-------------------|
| Data input | Files in stages | Rows via Java SDK |
| Latency | 1-2 minutes typical | Sub-second |
| Trigger | Cloud event / REST API | Client push |
| File staging | Required | Not needed |
| Client SDK | None | Java Ingest SDK |
| Kafka mode | File-based staging | Direct streaming |
| Compute | Serverless (per file) | Serverless (per row batch) |
| Exactly-once | Deduplication by filename | Channel offset tracking |
| Schema evolution | Via file format options | Via channel configuration |

## COPY INTO (Bulk Loading)

### Syntax and Options
```sql
-- Basic COPY INTO
COPY INTO target_table
  FROM @source_stage/path/
  FILE_FORMAT = (TYPE = 'PARQUET')
  ON_ERROR = 'CONTINUE'
  PURGE = TRUE;

-- With transformation
COPY INTO target_table (id, name, created_at)
  FROM (
    SELECT $1:id::INTEGER,
           $1:name::STRING,
           TO_TIMESTAMP($1:created_at::STRING)
    FROM @source_stage/path/
  )
  FILE_FORMAT = (TYPE = 'JSON');

-- Validation mode (test without loading)
COPY INTO target_table
  FROM @source_stage/path/
  VALIDATION_MODE = 'RETURN_ALL_ERRORS';
```

**[📖 COPY INTO](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)** - COPY INTO reference

### ON_ERROR Options
| Option | Behavior |
|--------|----------|
| ABORT_STATEMENT | Abort entire load on first error (default) |
| CONTINUE | Skip error rows, load valid rows |
| SKIP_FILE | Skip entire file if any error found |
| SKIP_FILE_n | Skip file if error count exceeds n |
| SKIP_FILE_n% | Skip file if error percentage exceeds n% |

### File Format Options
```sql
-- CSV format
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', 'null', '')
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
);

-- JSON format
FILE_FORMAT = (
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE
  STRIP_NULL_VALUES = TRUE
);

-- Parquet format
FILE_FORMAT = (
  TYPE = 'PARQUET'
  SNAPPY_COMPRESSION = TRUE
);
```

### Loading Best Practices
1. **File size:** Target 100-250 MB compressed files for optimal loading
2. **Parallelism:** Multiple smaller files load faster than one large file
3. **Compression:** Use Gzip, Brotli, or Snappy for compressed loading
4. **Staging:** Stage files close to Snowflake region for lower latency
5. **Purging:** Set PURGE = TRUE to remove loaded files automatically

## Data Unloading

### COPY INTO Location
```sql
-- Unload to external stage
COPY INTO @my_stage/output/
  FROM my_table
  FILE_FORMAT = (TYPE = 'PARQUET')
  HEADER = TRUE
  OVERWRITE = TRUE
  MAX_FILE_SIZE = 268435456;  -- 256 MB

-- Unload with query
COPY INTO @my_stage/output/
  FROM (SELECT id, name, amount FROM orders WHERE order_date = CURRENT_DATE())
  FILE_FORMAT = (TYPE = 'CSV')
  HEADER = TRUE;
```

**[📖 Data Unloading](https://docs.snowflake.com/en/user-guide/data-unload-overview)** - Unloading documentation

### GET Command (Internal Stages)
```sql
-- Download from internal stage to local filesystem
GET @my_internal_stage/output/ file:///tmp/data/;
```

## Decision Framework

### When to Use Each Loading Method
| Requirement | Method | Reasoning |
|------------|--------|-----------|
| Continuous file loading | Snowpipe auto-ingest | Event-driven, serverless |
| Sub-second latency | Snowpipe Streaming | Row-level API, lowest latency |
| One-time bulk load | COPY INTO | Manual, warehouse-based |
| Kafka events | Kafka Connector (Streaming) | Native integration |
| Scheduled batch | COPY INTO via task | Task-scheduled loading |
| External data query | External tables | No loading, query in place |
