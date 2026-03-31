# Data Loading and Unloading

**[📖 Data Loading Overview](https://docs.snowflake.com/en/user-guide/data-load-overview)** - Complete loading guide

## Stages

Stages are locations where data files are stored for loading into or unloading from Snowflake.

**[📖 Stages Overview](https://docs.snowflake.com/en/user-guide/data-load-overview#stages)** - Stage types and usage

### Internal Stages

**User Stage (@~):**
- Every user has one automatically
- Cannot be altered, dropped, or shared
- Referenced as `@~`
- Good for: personal data loading
- Cannot set file format options on the stage itself

**Table Stage (@%table_name):**
- Every table has one automatically
- Cannot be altered or dropped
- Referenced as `@%my_table`
- Files can only be loaded into the associated table
- Cannot set file format options on the stage itself
- Does not support transformations during load

**Named Internal Stage (CREATE STAGE):**
- Most flexible internal stage type
- Can set default file format and COPY options
- Can be granted to roles for shared access
- Supports directory tables for file listing

```sql
CREATE STAGE my_internal_stage
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|' SKIP_HEADER = 1)
  COPY_OPTIONS = (ON_ERROR = 'CONTINUE');
```

**[📖 Internal Stages](https://docs.snowflake.com/en/user-guide/data-load-local-file-system-create-stage)** - Creating internal stages

### External Stages

Point to cloud storage locations outside Snowflake.

**Amazon S3:**
```sql
CREATE STAGE my_s3_stage
  URL = 's3://mybucket/path/'
  STORAGE_INTEGRATION = my_s3_integration
  FILE_FORMAT = (TYPE = 'PARQUET');
```

**Azure Blob Storage:**
```sql
CREATE STAGE my_azure_stage
  URL = 'azure://myaccount.blob.core.windows.net/mycontainer/path/'
  STORAGE_INTEGRATION = my_azure_integration;
```

**Google Cloud Storage:**
```sql
CREATE STAGE my_gcs_stage
  URL = 'gcs://mybucket/path/'
  STORAGE_INTEGRATION = my_gcs_integration;
```

**[📖 S3 External Stage](https://docs.snowflake.com/en/user-guide/data-load-s3-create-stage)** - S3 stage setup
**[📖 Azure External Stage](https://docs.snowflake.com/en/user-guide/data-load-azure-create-stage)** - Azure stage setup
**[📖 GCS External Stage](https://docs.snowflake.com/en/user-guide/data-load-gcs-create-stage)** - GCS stage setup

### Storage Integrations

- Avoid embedding credentials directly in stage definitions
- Created at the account level by ACCOUNTADMIN
- Reference a cloud storage location with IAM role (AWS) or service principal (Azure)
- More secure than using direct credentials

**[📖 Storage Integrations](https://docs.snowflake.com/en/sql-reference/sql/create-storage-integration)** - Integration setup

## PUT Command

- Uploads files from local machine to an internal stage
- Only works with internal stages (not external)
- Automatically compresses files with gzip (configurable)
- Parallel upload support

```sql
PUT file:///path/to/local/file.csv @my_stage AUTO_COMPRESS=TRUE;
```

**[📖 PUT Command](https://docs.snowflake.com/en/sql-reference/sql/put)** - Upload syntax

## GET Command

- Downloads files from an internal stage to local machine
- Only works with internal stages

```sql
GET @my_stage/file.csv file:///path/to/local/directory/;
```

**[📖 GET Command](https://docs.snowflake.com/en/sql-reference/sql/get)** - Download syntax

## COPY INTO (Loading Data)

**[📖 COPY INTO Table](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)** - Complete syntax reference

### Basic Syntax

```sql
COPY INTO my_table
FROM @my_stage/path/
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1)
PATTERN = '.*[.]csv'
ON_ERROR = 'CONTINUE';
```

### Loading with Transformations

```sql
COPY INTO my_table (col1, col2, col3)
FROM (
  SELECT $1, $2, TO_DATE($3, 'YYYY-MM-DD')
  FROM @my_stage/data.csv
)
FILE_FORMAT = (TYPE = 'CSV');
```

### ON_ERROR Options

| Option | Behavior |
|--------|----------|
| ABORT_STATEMENT | Stop entire load on first error (default) |
| CONTINUE | Skip error rows, load valid rows |
| SKIP_FILE | Skip entire file if any error found |
| SKIP_FILE_n | Skip file after n errors |
| SKIP_FILE_n% | Skip file if error rate exceeds n% |

### VALIDATION_MODE

- Does NOT load data - only validates
- `RETURN_n_ROWS` - validate and return first n rows
- `RETURN_ERRORS` - validate all rows, return errors
- `RETURN_ALL_ERRORS` - same as RETURN_ERRORS but returns all errors
- Useful for dry-run testing before actual load

```sql
COPY INTO my_table
FROM @my_stage
VALIDATION_MODE = 'RETURN_ERRORS';
```

### Load History and Idempotency

- COPY INTO tracks loaded files for 64 days
- Will not re-load files that have already been loaded
- Use FORCE = TRUE to override this behavior
- Load history visible in COPY_HISTORY table function and Account Usage

```sql
-- Check load history
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'my_table',
  START_TIME => DATEADD(hours, -24, CURRENT_TIMESTAMP())
));
```

**[📖 Data Loading Best Practices](https://docs.snowflake.com/en/user-guide/data-load-considerations-prepare)** - Optimization tips

### File Preparation Best Practices

- Split large files into 100-250 MB compressed chunks
- Use gzip or bzip2 compression
- UTF-8 encoding recommended
- Consistent delimiter and escape characters
- Remove BOM (Byte Order Mark) from files
- Consistent date/time formats

## File Formats

**[📖 File Format Options](https://docs.snowflake.com/en/sql-reference/sql/create-file-format)** - Format configuration

### Supported Formats

| Format | Structured | Semi-Structured | Notes |
|--------|-----------|----------------|-------|
| CSV | Yes | No | Most common for structured data |
| JSON | No | Yes | Loaded into VARIANT column |
| Avro | No | Yes | Schema embedded in file |
| ORC | No | Yes | Optimized Row Columnar |
| Parquet | No | Yes | Columnar, efficient for analytics |
| XML | No | Yes | Loaded into VARIANT column |

### Named File Formats

```sql
CREATE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null', '')
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  COMPRESSION = 'GZIP';
```

## Snowpipe

**[📖 Snowpipe](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)** - Continuous loading

### Architecture
- Serverless, event-driven continuous data loading
- Uses its own compute resources (not your virtual warehouses)
- Near real-time ingestion (typically within minutes)
- Per-second billing based on compute used

### Auto-Ingest Setup

1. Create an external stage
2. Create a pipe with AUTO_INGEST = TRUE
3. Configure cloud event notifications:
   - AWS: S3 event notification to SQS queue
   - Azure: Event Grid to Storage Queue
   - GCP: Pub/Sub notification

```sql
CREATE PIPE my_pipe
  AUTO_INGEST = TRUE
AS
  COPY INTO my_table
  FROM @my_external_stage
  FILE_FORMAT = (TYPE = 'JSON');
```

### REST API

- Alternative to auto-ingest
- Application calls Snowpipe REST endpoint with file list
- `insertFiles` endpoint triggers loading
- `insertReport` and `loadHistoryScan` for monitoring

**[📖 Snowpipe REST API](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-rest-apis)** - API endpoints

### Snowpipe vs COPY INTO

| Feature | COPY INTO | Snowpipe |
|---------|-----------|----------|
| Compute | Virtual warehouse | Serverless (Snowpipe) |
| Trigger | Manual/scheduled | Event-driven/REST API |
| Latency | Batch (minutes-hours) | Near real-time (minutes) |
| Best for | Large batch loads | Continuous streaming data |
| Cost model | Warehouse credits | Per-second serverless |
| File tracking | 64 days | 14 days |

## Data Unloading

**[📖 COPY INTO Location](https://docs.snowflake.com/en/sql-reference/sql/copy-into-location)** - Unloading syntax

```sql
-- Unload to internal stage
COPY INTO @my_stage/output/
FROM my_table
FILE_FORMAT = (TYPE = 'CSV' COMPRESSION = 'GZIP')
HEADER = TRUE
OVERWRITE = TRUE;

-- Unload to external stage
COPY INTO @my_s3_stage/exports/
FROM (SELECT col1, col2 FROM my_table WHERE date_col > '2024-01-01')
FILE_FORMAT = (TYPE = 'PARQUET')
MAX_FILE_SIZE = 268435456; -- 256 MB

-- Unload with single file output
COPY INTO @my_stage/single_file
FROM my_table
FILE_FORMAT = (TYPE = 'CSV')
SINGLE = TRUE;
```

### Unloading Options
- HEADER - include column headers (CSV only)
- SINGLE - output as single file (not recommended for large datasets)
- MAX_FILE_SIZE - control output file size
- OVERWRITE - replace existing files
- INCLUDE_QUERY_ID - add query ID to file name
- Partitioned unloading for organized output

**[📖 Unloading Best Practices](https://docs.snowflake.com/en/user-guide/data-unload-considerations)** - Optimization tips
