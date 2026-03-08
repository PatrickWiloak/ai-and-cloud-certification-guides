# Domain 2: Data Store Management (26%)

## Overview

Domain 2 covers choosing, configuring, and optimizing data stores for analytics workloads. This includes data lake storage (S3), data warehousing (Redshift), serverless querying (Athena), NoSQL (DynamoDB), relational databases (RDS/Aurora), and centralized governance (Lake Formation).

The exam tests your ability to select the right data store based on access patterns, cost requirements, and performance needs.

---

## Amazon S3 (Data Lake Foundation)

Amazon S3 is the foundation of virtually every data lake on AWS. Understanding S3 storage classes, partitioning strategies, and file formats is essential for the exam.

**📖 [Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)**

### Storage Classes

| Storage Class | Access Frequency | Min Duration | Retrieval Cost | Use Case |
|--------------|-----------------|-------------|----------------|----------|
| **S3 Standard** | Frequent | None | None | Active data lake, frequently queried data |
| **S3 Intelligent-Tiering** | Unknown/changing | None | None (monitoring fee) | Unpredictable access patterns |
| **S3 Standard-IA** | Monthly | 30 days | Per GB retrieved | Older data still needed occasionally |
| **S3 One Zone-IA** | Infrequent, non-critical | 30 days | Per GB retrieved | Re-creatable data, secondary copies |
| **S3 Glacier Instant Retrieval** | Quarterly | 90 days | Per GB retrieved | Archive needing instant access |
| **S3 Glacier Flexible Retrieval** | 1-2 times/year | 90 days | Per GB + per request | Archive with minutes-to-hours retrieval |
| **S3 Glacier Deep Archive** | Rarely/never | 180 days | Per GB + per request | Long-term compliance, 12-48 hour retrieval |

**📖 [S3 Storage Classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)**

### Lifecycle Policies

Lifecycle policies automate transitions between storage classes and object expiration:

```json
{
  "Rules": [
    {
      "ID": "DataLakeLifecycle",
      "Status": "Enabled",
      "Filter": {"Prefix": "processed/"},
      "Transitions": [
        {"Days": 30, "StorageClass": "STANDARD_IA"},
        {"Days": 90, "StorageClass": "GLACIER_IR"},
        {"Days": 365, "StorageClass": "DEEP_ARCHIVE"}
      ],
      "Expiration": {"Days": 2555}
    }
  ]
}
```

**Key rules**:
- Cannot transition from a lower-cost class to a higher-cost class
- Minimum 30 days in Standard before transitioning to IA
- Minimum 30 days in Standard-IA before transitioning to Glacier classes
- Objects smaller than 128 KB are not transitioned to IA or Glacier (charged minimum size)

**📖 [S3 Lifecycle Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)**

### Data Lake Partitioning Strategies

Partitioning organizes data into directories based on key values, dramatically reducing the amount of data scanned by Athena and Redshift Spectrum.

#### Hive-Style Partitioning

```
s3://data-lake/events/
  ├── year=2024/month=01/day=01/  (part-00000.parquet, part-00001.parquet)
  ├── year=2024/month=01/day=02/  (part-00000.parquet)
  └── year=2024/month=12/day=31/  (part-00000.parquet)
```

#### Partitioning Best Practices

| Practice | Explanation |
|----------|-------------|
| **Partition by query patterns** | Use columns that appear in WHERE clauses (date, region, etc.) |
| **Avoid over-partitioning** | Too many small partitions = too many small files = poor performance |
| **Target file sizes** | 128 MB - 512 MB per file for optimal Athena and Spark performance |
| **Compact small files** | Use Glue ETL or EMR to periodically merge small files into larger ones |
| **Use partition projection** | Athena feature to compute partition locations instead of querying the catalog |
| **Hive-style paths** | `key=value` format enables automatic partition discovery by crawlers |

**📖 [Athena Partition Projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)**
**📖 [Building Data Lakes on AWS](https://docs.aws.amazon.com/whitepapers/latest/building-data-lakes/building-data-lake-aws.html)**

### Data Lake Architecture (Medallion / Multi-Layer)

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Raw/Bronze │    │ Curated/     │    │ Consumption/ │
│              │───>│ Silver       │───>│ Gold         │
│ As-is from   │    │ Cleaned,     │    │ Aggregated,  │
│ source       │    │ validated,   │    │ business-    │
│ (JSON, CSV)  │    │ deduplicated │    │ ready views  │
│              │    │ (Parquet)    │    │ (Parquet)    │
└──────────────┘    └──────────────┘    └──────────────┘
```

- **Raw/Bronze**: Original data in source format, no transformations. Retained for auditability and reprocessing.
- **Curated/Silver**: Cleaned, deduplicated, schema-enforced. Converted to columnar format (Parquet). Partitioned.
- **Consumption/Gold**: Aggregated, denormalized, business-level tables optimized for specific analytics queries and dashboards.

### S3 Data File Formats

| Format | Type | Splittable | Schema | Compression | Best For |
|--------|------|------------|--------|-------------|----------|
| **Parquet** | Columnar | Yes | Embedded | Snappy, GZIP, ZSTD | Athena, Spark, Redshift Spectrum |
| **ORC** | Columnar | Yes | Embedded | Zlib, Snappy | Hive/EMR workloads |
| **Avro** | Row-based | Yes | Embedded (JSON) | Snappy, Deflate | Streaming, schema evolution |
| **JSON** | Row-based | Yes (NDJSON) | Self-describing | GZIP | APIs, semi-structured data |
| **CSV** | Row-based | Yes | None | GZIP | Simple data exchange |

**Exam tip**: Parquet + Snappy is the default recommendation for data lakes queried by Athena. ORC is preferred for Hive-centric workloads. Avro is best when you need strong schema evolution support.

**📖 [Athena Supported Formats](https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html)**

### S3 Select and Glacier Select

S3 Select retrieves a subset of data from an object using simple SQL, avoiding downloading the entire object:

- Works on CSV, JSON, and Parquet objects
- Supports simple SELECT, WHERE, and LIMIT (no joins, no subqueries)
- Up to 400% faster and 80% cheaper than full object retrieval for filtered access
- Maximum input: 256 MB compressed, 1 GB uncompressed

**📖 [S3 Select](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)**

### S3 Event Notifications

S3 can trigger actions when objects are created, deleted, or modified:

| Target | Use Case |
|--------|----------|
| **Lambda** | Process files immediately on arrival (transform, validate) |
| **SQS** | Queue events for decoupled, asynchronous processing |
| **SNS** | Fan out notifications to multiple consumers |
| **EventBridge** | Route to any EventBridge target (Step Functions, Lambda, etc.) |

**📖 [S3 Event Notifications](https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html)**

---

## Amazon Redshift

Amazon Redshift is a fully managed, petabyte-scale cloud data warehouse using columnar storage optimized for analytical queries.

**📖 [Amazon Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)**

### Architecture

```
┌──────────────────────────────────────────────┐
│                Leader Node                    │
│  (SQL parsing, query planning, aggregation)   │
└───────────────────┬──────────────────────────┘
                    │
     ┌──────────────┼──────────────┐
     │              │              │
┌────▼────┐   ┌────▼────┐   ┌────▼────┐
│ Compute │   │ Compute │   │ Compute │
│ Node 1  │   │ Node 2  │   │ Node N  │
│ ┌─────┐ │   │ ┌─────┐ │   │ ┌─────┐ │
│ │Slice│ │   │ │Slice│ │   │ │Slice│ │
│ ├─────┤ │   │ ├─────┤ │   │ ├─────┤ │
│ │Slice│ │   │ │Slice│ │   │ │Slice│ │
│ └─────┘ │   │ └─────┘ │   │ └─────┘ │
└─────────┘   └─────────┘   └─────────┘
```

- **Leader Node**: Receives SQL queries, develops execution plans, coordinates compute nodes, returns final results
- **Compute Nodes**: Execute queries in parallel. Each contains multiple slices.
- **Slices**: A slice processes a portion of the data assigned to its node. Parallelism = number of slices.

**📖 [Redshift System Architecture](https://docs.aws.amazon.com/redshift/latest/dg/c_high_level_system_architecture.html)**

### Node Types

| Node Type | Storage | Characteristics | Best For |
|-----------|---------|----------------|----------|
| **RA3** | Managed storage (S3-backed) | Virtually unlimited, hot data cached locally | Most workloads; decouple compute from storage |
| **DC2** | Local SSD | Fast local I/O, limited storage | Small datasets (<1 TB) needing lowest latency |

**Exam tip**: RA3 is the modern default. It automatically manages hot data on local SSDs and warm/cold data in S3. DC2 is legacy-oriented for small, latency-sensitive workloads.

### Distribution Styles

Distribution determines how rows are spread across compute nodes, directly impacting join performance:

| Style | How It Works | Best For |
|-------|-------------|----------|
| **KEY** | Rows with the same distribution key value go to the same node | Large fact tables frequently joined on a specific column |
| **EVEN** | Round-robin distribution across all nodes | Tables not involved in joins or without a clear join key |
| **ALL** | Full copy of the table on every node | Small dimension tables (<~2 million rows) frequently joined with large facts |
| **AUTO** | Redshift picks optimal strategy (starts EVEN, may switch to KEY or ALL) | Default when unsure; Redshift optimizes over time |

```sql
CREATE TABLE fact_orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date DATE,
    amount DECIMAL(10,2)
)
DISTKEY(customer_id)
SORTKEY(order_date);

CREATE TABLE dim_products (
    product_id BIGINT,
    product_name VARCHAR(200),
    category VARCHAR(50)
)
DISTSTYLE ALL;
```

**📖 [Redshift Distribution Styles](https://docs.aws.amazon.com/redshift/latest/dg/c_choosing_dist_sort.html)**

### Sort Keys

Sort keys determine the physical ordering of data on disk, enabling zone maps and efficient range scans:

| Type | How It Works | Best For |
|------|-------------|----------|
| **Compound** | Data sorted by columns in order (like a composite index) | Queries filtering on the leading column(s), e.g., date-based queries |
| **Interleaved** | Equal weight to all columns in the key | Ad-hoc queries filtering on any combination of key columns |

**Exam tip**: Compound sort keys are preferred in most cases (faster VACUUM, better for common query patterns). Interleaved sort keys are expensive to maintain and only worth it for highly varied ad-hoc query patterns.

### Loading Data into Redshift

#### COPY Command (Primary Loading Method)

```sql
-- Load Parquet files from S3
COPY fact_orders
FROM 's3://data-lake/processed/orders/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
FORMAT AS PARQUET;

-- Load compressed CSV with options
COPY fact_orders
FROM 's3://data-lake/raw/orders/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
CSV IGNOREHEADER 1 DATEFORMAT 'YYYY-MM-DD' GZIP;

-- Load using a manifest file (explicit file list)
COPY fact_orders
FROM 's3://data-lake/manifests/orders.manifest'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
MANIFEST FORMAT AS PARQUET;
```

**COPY best practices**:
- Split data into multiple files (one per slice) for parallel loading
- Use compressed files (GZIP, LZO, ZSTD) to reduce transfer time
- Use manifest files when you need to specify exact files
- Use columnar formats (Parquet) when possible
- COPY is significantly faster than INSERT for bulk loading

**📖 [Redshift COPY Command](https://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html)**

#### UNLOAD Command

Export Redshift query results to S3:

```sql
UNLOAD ('SELECT * FROM fact_orders WHERE order_date >= ''2024-01-01''')
TO 's3://data-lake/exports/orders_2024/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftUnloadRole'
FORMAT AS PARQUET
PARTITION BY (product_category);
```

**📖 [Redshift UNLOAD Command](https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html)**

### Redshift Spectrum

Spectrum extends Redshift queries to data in S3 without loading it:

- Creates **external tables** referencing S3 data through the Glue Data Catalog
- Query processing runs on dedicated Spectrum nodes (separate from your cluster compute)
- Supports Parquet, ORC, JSON, CSV, Avro
- Join external (S3) and local (Redshift) tables in a single query
- **Important**: Still requires a Redshift cluster (provisioned or Serverless) to use Spectrum

```sql
-- Create external schema pointing to Glue Data Catalog
CREATE EXTERNAL SCHEMA spectrum_schema
FROM DATA CATALOG
DATABASE 'datalake_db'
IAM_ROLE 'arn:aws:iam::123456789012:role/SpectrumRole';

-- Query S3 data alongside Redshift local tables
SELECT c.customer_name, SUM(s.amount) AS total_spent
FROM redshift_schema.customers c
JOIN spectrum_schema.purchases s ON c.customer_id = s.customer_id
WHERE s.year = '2024'
GROUP BY c.customer_name
ORDER BY total_spent DESC;
```

**📖 [Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)**

### Redshift Serverless

Automatically provisions and scales data warehouse capacity without cluster management:

- Pay for compute in RPU-hours (Redshift Processing Units) only when running queries
- Automatic scaling based on workload complexity and concurrency
- No cluster sizing, node type selection, or capacity planning
- Ideal for intermittent, unpredictable, or variable analytical workloads
- Supports Spectrum, data sharing, federated queries, and streaming ingestion

**📖 [Redshift Serverless](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-serverless.html)**

### Redshift Data Sharing

Share live Redshift data across clusters and accounts without copying:

- **Producer cluster** creates a datashare and adds schemas/tables
- **Consumer cluster** creates a database from the datashare and queries data live
- No data movement; consumers read from producer's managed storage
- Cross-account sharing supported via AWS RAM
- Consumer queries do not consume producer compute

**📖 [Redshift Data Sharing](https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html)**

### Additional Redshift Features

| Feature | Description |
|---------|-------------|
| **Materialized Views** | Pre-computed query results with automatic or manual refresh |
| **Concurrency Scaling** | Automatically adds transient clusters during peak demand |
| **WLM (Workload Management)** | Route queries to priority queues with memory/concurrency limits |
| **Streaming Ingestion** | Ingest directly from Kinesis Data Streams or MSK (no staging in S3) |
| **Federated Queries** | Query live data in RDS/Aurora from Redshift SQL |
| **Redshift ML** | Create ML models using SageMaker from Redshift SQL |

**📖 [Redshift Materialized Views](https://docs.aws.amazon.com/redshift/latest/dg/materialized-view-overview.html)**

---

## Amazon Athena

Amazon Athena is a serverless, interactive query service using standard SQL to analyze data stored in S3 via the Glue Data Catalog.

**📖 [Amazon Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)**

### Key Characteristics

- **Serverless**: No infrastructure to provision or manage
- **Pay per query**: $5 per TB of data scanned (cancelled queries not charged)
- **SQL engine**: Trino (formerly Presto) - ANSI SQL compatible
- **Schema-on-read**: Uses Glue Data Catalog table definitions
- **Formats**: Parquet, ORC, JSON, CSV, Avro, and more via SerDe libraries

### Cost Optimization Strategies

| Strategy | Cost Impact | How |
|----------|------------|-----|
| **Use columnar formats** | Up to 99% reduction | Convert CSV/JSON to Parquet or ORC |
| **Partition data** | Only scan relevant partitions | Hive-style partitioning by date, region, etc. |
| **Compress data** | Reduce bytes scanned | GZIP, Snappy, LZO, ZSTD compression |
| **Partition projection** | Faster partition resolution | Define patterns in table properties instead of catalog lookups |
| **SELECT specific columns** | Only scan needed columns (columnar) | Avoid `SELECT *` on wide tables |
| **Use workgroups** | Enforce cost limits | Set per-query and per-workgroup scan limits |
| **Compact small files** | Reduce overhead | Merge files to 128-512 MB optimal size |

**📖 [Athena Performance Tuning](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)**

### Workgroups

Workgroups provide cost control, access management, and query isolation:

- Set per-query data scan limit (e.g., max 100 GB per query)
- Set workgroup-wide scan limit per time period (e.g., max 1 TB per day)
- Separate query result locations per workgroup
- Control access via IAM policies (restrict users to specific workgroups)
- Track costs by workgroup with CloudWatch metrics and AWS Cost Explorer tags

**📖 [Athena Workgroups](https://docs.aws.amazon.com/athena/latest/ug/manage-queries-control-costs-with-workgroups.html)**

### Partition Projection

Partition projection lets Athena compute partition locations mathematically instead of reading them from the Glue Data Catalog. This eliminates MSCK REPAIR TABLE and speeds up query planning for tables with many partitions.

```sql
CREATE EXTERNAL TABLE events (
    event_id STRING,
    event_type STRING,
    payload STRING
)
PARTITIONED BY (year STRING, month STRING, day STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS PARQUET
LOCATION 's3://data-lake/events/'
TBLPROPERTIES (
    'projection.enabled' = 'true',
    'projection.year.type' = 'integer',
    'projection.year.range' = '2020,2030',
    'projection.month.type' = 'integer',
    'projection.month.range' = '1,12',
    'projection.month.digits' = '2',
    'projection.day.type' = 'integer',
    'projection.day.range' = '1,31',
    'projection.day.digits' = '2',
    'storage.location.template' =
        's3://data-lake/events/year=${year}/month=${month}/day=${day}/'
);
```

**📖 [Athena Partition Projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)**

### Federated Queries

Athena federated queries use Lambda-based data source connectors to query data beyond S3:

| Data Source | Connector | Use Case |
|-------------|-----------|----------|
| **DynamoDB** | Lambda connector | SQL queries on DynamoDB tables |
| **Amazon RDS/Aurora** | Lambda connector | Query relational databases with Athena SQL |
| **Amazon Redshift** | Lambda connector | Query Redshift from Athena |
| **CloudWatch Logs** | Lambda connector | SQL queries on log data |
| **Custom sources** | Athena Query Federation SDK | Build custom connectors for any source |

**📖 [Athena Federated Query](https://docs.aws.amazon.com/athena/latest/ug/connect-to-a-data-source.html)**

### CTAS (CREATE TABLE AS SELECT)

CTAS creates a new table from query results, useful for format conversion, data compaction, and creating materialized subsets:

```sql
CREATE TABLE processed_events
WITH (
    format = 'PARQUET',
    external_location = 's3://data-lake/processed/events/',
    partitioned_by = ARRAY['year', 'month'],
    bucketed_by = ARRAY['user_id'],
    bucket_count = 10
) AS
SELECT event_id, event_type, amount, year, month
FROM raw_events
WHERE year = '2024';
```

**Use cases**: Convert CSV to Parquet, compact small files, create pre-filtered subsets, add bucketing.

**📖 [Athena CTAS](https://docs.aws.amazon.com/athena/latest/ug/ctas.html)**

---

## Amazon DynamoDB

DynamoDB is a fully managed NoSQL key-value and document database. For the DEA-C01 exam, focus on DynamoDB as a data source for analytics and its CDC capabilities.

**📖 [Amazon DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)**

### Key Concepts for Data Engineering

| Concept | Description | Data Engineering Relevance |
|---------|-------------|--------------------------|
| **Partition Key** | Primary key for data distribution | Determines data placement and access patterns |
| **Sort Key** | Optional second key for range queries | Enables time-series and hierarchical queries |
| **GSI** | Global Secondary Index | Alternate query patterns, eventually consistent |
| **LSI** | Local Secondary Index | Same partition key, different sort key, strongly consistent |
| **Provisioned mode** | Specified RCU/WCU with optional auto-scaling | Predictable, cost-effective for steady workloads |
| **On-Demand mode** | Pay-per-request, auto-scales instantly | Variable workloads, unpredictable traffic |

### DynamoDB Streams

DynamoDB Streams captures item-level changes with 24-hour retention:

- **Stream Records**: Contain the item before and/or after modification
- **View Types**: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES
- **Processing**: Lambda (most common), KCL applications, Kinesis Data Streams adapter
- **Ordering**: Records appear in the same order as modifications to the table

**Use cases**: Trigger downstream ETL, replicate to other tables, build search indexes, maintain materialized views, send CDC events to analytics pipelines.

**📖 [DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)**

### DynamoDB Export to S3

Export full table data to S3 for analytics without consuming read capacity units:

| Feature | Description |
|---------|-------------|
| **Point-in-time export** | Export data as of a specific timestamp (requires PITR enabled) |
| **Incremental export** | Export only changes since a previous export |
| **Formats** | DynamoDB JSON or Amazon Ion |
| **RCU impact** | None - uses PITR backup, not table reads |
| **Integration** | Crawl exported data with Glue, query with Athena |

**📖 [DynamoDB Export to S3](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.html)**

### DynamoDB Global Tables

Multi-region, fully replicated tables for globally distributed applications:
- Active-active: read and write in any region
- Sub-second replication latency between regions
- Automatic conflict resolution (last writer wins)

**📖 [DynamoDB Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)**

---

## Amazon RDS and Aurora

Amazon RDS and Aurora provide managed relational databases. For the DEA-C01, focus on their role as data sources feeding analytics pipelines.

**📖 [Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)**
**📖 [Amazon Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html)**

### Aurora Key Features

| Feature | Description |
|---------|-------------|
| **Shared storage** | Distributed, fault-tolerant across 3 AZs, up to 128 TB auto-growing |
| **Read replicas** | Up to 15 Aurora replicas with <20 ms replication lag |
| **Multi-AZ** | Automatic failover (typically under 30 seconds) |
| **Serverless v2** | Auto-scales from 0.5 to 256 ACUs based on demand |
| **Global Database** | Cross-region replication with <1 second lag |
| **Zero-ETL to Redshift** | Direct replication from Aurora to Redshift without ETL pipelines |

**📖 [Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)**

### RDS/Aurora as Data Sources for Analytics

| Integration Path | How It Works | Use Case |
|-----------------|-------------|----------|
| **AWS DMS** | Full load + CDC replication to S3, Redshift, Kinesis | Continuous replication to data lake |
| **AWS Glue (JDBC)** | Glue ETL reads via JDBC connection | Batch ETL extraction |
| **Athena Federated Query** | Lambda connector queries live database | Ad-hoc queries without data movement |
| **Redshift Federated Query** | Redshift queries RDS/Aurora directly via SQL | Join warehouse data with operational data |
| **RDS Snapshot Export to S3** | Export DB snapshot to S3 in Parquet format | One-time analytics, cost-effective extraction |
| **Aurora Zero-ETL** | Automatic near-real-time replication to Redshift | Operational analytics without pipeline management |

**📖 [RDS Snapshot Export to S3](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html)**
**📖 [Aurora Zero-ETL with Redshift](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.html)**

---

## AWS Lake Formation

AWS Lake Formation simplifies setting up, securing, and managing a data lake. It provides centralized governance and fine-grained access control on top of S3 and the Glue Data Catalog.

**📖 [AWS Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**

### Core Components

| Component | Description |
|-----------|-------------|
| **Data Lake Registration** | Register S3 locations as part of the managed data lake |
| **Blueprints** | Pre-built ingestion workflows for databases and log sources |
| **Data Catalog** | Shared Glue Data Catalog with Lake Formation permissions overlay |
| **Permissions** | Grant/revoke at database, table, column, and row level |
| **LF-Tags** | Tag-based access control for scalable, attribute-based permissions |
| **Data Filters** | Named filters combining column and row-level restrictions |
| **Cross-Account Sharing** | Share data with other AWS accounts via RAM |

### Lake Formation Permissions Model

Lake Formation replaces complex S3 bucket policies and IAM policies with centralized GRANT/REVOKE:

```
-- Table-level access
GRANT SELECT ON TABLE analytics_db.customer_orders TO arn:aws:iam::123:role/AnalystRole

-- Column-level access (only specified columns)
GRANT SELECT (order_id, amount, order_date) ON TABLE analytics_db.customer_orders
    TO arn:aws:iam::123:role/LimitedAnalystRole
```

**📖 [Lake Formation Permissions](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)**

### LF-Tags (Tag-Based Access Control)

LF-Tags enable attribute-based access control that scales automatically as new resources are added:

1. **Define tags**: `sensitivity = [public, internal, confidential, restricted]`
2. **Assign tags to resources**: Tag the `salary` table with `sensitivity = confidential`
3. **Grant on tags**: Grant `SELECT` to `FinanceRole` on resources with `sensitivity = [internal, confidential]`

When new tables are tagged, matching permissions apply automatically without creating new grants.

**📖 [Lake Formation Tag-Based Access Control](https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html)**

### Data Filters (Row and Column Security)

Data filters combine row-level and column-level security into reusable, named definitions:

```
Filter: "US_Sales_Limited"
  Columns included: customer_name, amount, region, order_date
  Row filter expression: region = 'US'
```

Grant the filter to a principal, and they can only see the specified columns for matching rows. This is the most granular access control available.

**📖 [Lake Formation Data Filters](https://docs.aws.amazon.com/lake-formation/latest/dg/data-filters-about.html)**

### Lake Formation vs IAM S3 Policies

| Feature | Lake Formation | IAM S3 Policies |
|---------|---------------|-----------------|
| **Granularity** | Table, column, row, cell | Bucket, prefix, object |
| **Management** | Centralized GRANT/REVOKE | Distributed policies |
| **Column security** | Built-in | Not available |
| **Row security** | Data filters | Not available |
| **Tag-based** | LF-Tags (scalable) | Limited |
| **Cross-account** | Built-in with RAM | Bucket policies + IAM |

---

## Data Store Selection Guide

### Decision Matrix

| Requirement | Recommended Service | Why |
|-------------|-------------------|-----|
| Scalable data lake storage | **Amazon S3** | Unlimited scale, lowest cost, all services integrate |
| Complex analytical SQL with joins/aggregations | **Amazon Redshift** | Columnar MPP warehouse, optimized for analytics |
| Ad-hoc SQL on S3 data (no infrastructure) | **Amazon Athena** | Serverless, pay per query, no cluster needed |
| Sub-millisecond key-value lookups | **Amazon DynamoDB** | Single-digit ms latency at any scale |
| Transactional OLTP workloads | **Amazon RDS / Aurora** | Full SQL, ACID transactions, read replicas |
| Full-text search and log analytics | **Amazon OpenSearch** | Inverted index, Kibana dashboards |
| Centralized data lake governance | **AWS Lake Formation** | Fine-grained permissions, LF-Tags, cross-account |
| Query S3 from within Redshift SQL | **Redshift Spectrum** | Extend warehouse queries to data lake |

### Common Exam Scenarios

1. **"Most cost-effective storage for infrequently accessed data"** --> S3 with lifecycle policies to Glacier
2. **"Query S3 data without loading into a database"** --> Amazon Athena
3. **"Complex joins across billion-row fact and dimension tables"** --> Amazon Redshift
4. **"Real-time lookups by primary key for enrichment"** --> Amazon DynamoDB
5. **"Centralized permissions for data lake"** --> AWS Lake Formation with LF-Tags
6. **"Reduce Athena query costs"** --> Convert to Parquet + partition + compress
7. **"Query Redshift tables and S3 data in one SQL query"** --> Redshift Spectrum
8. **"Migrate Oracle to Aurora with minimal downtime"** --> AWS DMS + Schema Conversion Tool
9. **"Export DynamoDB for analytics without read impact"** --> DynamoDB Export to S3
10. **"Share Redshift data across accounts without copying"** --> Redshift Data Sharing
