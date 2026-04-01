# Storage and Data Management - AWS Data Analytics Specialty

## Overview

Storage and data management covers 22% of the DAS-C01 exam. This domain focuses on designing and implementing data storage solutions including S3 data lakes, data catalogs, and purpose-built databases for analytics workloads.

## Amazon S3 for Analytics

**[📖 S3 Developer Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)** - Core S3 documentation

### Storage Classes

| Class | Use Case | Retrieval | Min Duration |
|-------|----------|-----------|-------------|
| S3 Standard | Frequently accessed analytics data | Immediate | None |
| S3 Intelligent-Tiering | Unknown or changing access patterns | Immediate | None |
| S3 Standard-IA | Infrequently accessed reference data | Immediate | 30 days |
| S3 One Zone-IA | Reproducible infrequent data | Immediate | 30 days |
| S3 Glacier Instant | Archive with instant access | Immediate | 90 days |
| S3 Glacier Flexible | Archive data (minutes to hours) | 1-12 hours | 90 days |
| S3 Glacier Deep Archive | Long-term archive | 12-48 hours | 180 days |

**[📖 Storage Classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)** - Detailed class comparison

### Lifecycle Policies

- Transition actions: Move objects between storage classes
- Expiration actions: Delete objects after specified time
- Can filter by prefix or tags
- Minimum 30 days before transitioning from Standard to IA classes
- Cannot transition from Glacier back to Standard (must restore + copy)

**[📖 Lifecycle Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)** - Lifecycle rules

### S3 Data Formats for Analytics

**Columnar Formats (preferred for analytics):**
- **Parquet** - Column-oriented, supports nested data, Spark default
- **ORC** - Optimized Row Columnar, Hive optimized, built-in indexes
- Both support predicate pushdown and column pruning
- 75%+ compression vs CSV/JSON

**Row Formats:**
- **CSV/TSV** - Simple, human-readable, no schema
- **JSON** - Semi-structured, nested data support
- **Avro** - Schema evolution, compact binary, good for write-heavy

**Key Exam Insight:**
- Parquet is the go-to for Athena, Redshift Spectrum, and Spark queries
- ORC is optimal for Hive on EMR
- Use Glue ETL or Firehose format conversion to convert to columnar

### S3 Partitioning

- Organize data by common query patterns: `s3://bucket/year=2024/month=01/day=15/`
- Hive-style partitioning for automatic partition discovery
- Reduces data scanned by Athena, Redshift Spectrum, and EMR
- Common partition keys: date, region, customer ID, event type

**[📖 S3 Performance](https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html)** - Performance optimization

### S3 Select and Glacier Select

- Query subset of data using SQL expressions directly on S3 objects
- Works with CSV, JSON, and Parquet
- Reduces data transfer and processing costs
- Up to 400% performance improvement for filtered queries
- S3 Select is being replaced by S3 Object Lambda for complex filtering

## AWS Lake Formation

**[📖 Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)** - Data lake management

### Key Capabilities

- **Data Lake Setup** - Automated data ingestion, cataloging, transformation
- **Centralized Permissions** - Fine-grained access control beyond IAM
- **Data Catalog Integration** - Uses Glue Data Catalog as metadata store
- **Blueprints** - Pre-built ingestion workflows for common sources
- **Cross-Account Sharing** - Share data across AWS accounts via LF-tags or named resources

### Permission Model

**[📖 Lake Formation Permissions](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)** - Access control

- **Database permissions**: CREATE_TABLE, ALTER, DROP, DESCRIBE
- **Table permissions**: SELECT, INSERT, DELETE, DESCRIBE, ALTER, DROP
- **Column-level security**: Grant access to specific columns only
- **Row-level security**: Filter rows based on conditions
- **Cell-level security**: Combine column and row filters
- **LF-Tags**: Tag-based access control for scalable permission management
- **Data filters**: Named filters combining column and row restrictions

### Governed Tables

- ACID transactions on S3 data
- Automatic data compaction
- Time travel queries
- Storage optimization
- Row-level security enforcement

## AWS Glue Data Catalog

**[📖 Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)** - Metadata catalog

### Core Components

- **Databases**: Logical grouping of tables (namespace)
- **Tables**: Metadata definition - schema, location, format, partitions
- **Partitions**: Subset metadata for partitioned datasets
- **Connections**: Configuration for accessing data stores
- **Crawlers**: Automated schema discovery and table registration

### Crawlers

**[📖 Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)** - Automated discovery

- Scan data stores and populate the Data Catalog
- Detect schema changes and add new partitions
- Support S3, DynamoDB, JDBC, MongoDB, and more
- Built-in classifiers for CSV, JSON, Parquet, ORC, Avro
- Custom classifiers using Grok patterns, JSON paths, or XML tags
- Schedule: on-demand, hourly, daily, weekly, custom cron
- Crawler creates or updates table definitions automatically

### Integration

The Glue Data Catalog serves as the metastore for:
- Amazon Athena
- Amazon Redshift Spectrum
- Amazon EMR (replaces Hive Metastore)
- AWS Glue ETL jobs
- Lake Formation

## Amazon DynamoDB for Analytics

**[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)** - NoSQL database

### Analytics-Relevant Features

- **DynamoDB Streams** - Ordered stream of item-level changes (CDC)
  - Retain changes for 24 hours
  - Lambda triggers for real-time processing
  - Cross-region replication via Global Tables
- **Export to S3** - Full table export without consuming read capacity
  - Exports in DynamoDB JSON or Amazon Ion format
  - Point-in-time export from continuous backups
  - Use with Athena, EMR, or Glue for analytics
- **Kinesis Data Streams Integration** - Stream changes to KDS for extended retention and fan-out

**[📖 DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)** - Change data capture
**[📖 Export to S3](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.HowItWorks.html)** - Table exports

## Amazon Redshift Storage

**[📖 Redshift System Overview](https://docs.aws.amazon.com/redshift/latest/dg/c_redshift_system_overview.html)** - Architecture

### Storage Architecture

- **Columnar storage** - Data stored by column, not row
- **Data compression** - Automatic encoding per column (AZ64, LZO, ZSTD, etc.)
- **Zone maps** - Min/max values per block for skip scanning
- **Sort keys** - Compound or interleaved, determines physical data order
- **Distribution styles**: KEY, EVEN, ALL, AUTO
  - KEY: Colocate rows with same key on same node (for joins)
  - ALL: Full table copy on every node (small dimension tables)
  - EVEN: Round-robin distribution
  - AUTO: Redshift chooses based on table size

### Redshift Data Sharing

- Share live data across Redshift clusters without copying
- Producer cluster creates datashare, consumer cluster reads
- Cross-account and cross-region supported
- Near real-time access to producer data

**[📖 Data Sharing](https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html)** - Cross-cluster sharing

### AQUA (Advanced Query Accelerator)

- Hardware-accelerated cache for Redshift RA3 nodes
- Pushes filtering and aggregation to storage layer
- Automatic - no configuration needed
- Up to 10x performance for scan-heavy queries

## Storage Decision Tree

| Scenario | Service |
|----------|---------|
| Central data lake with governed access | S3 + Lake Formation |
| Metadata catalog for all analytics | Glue Data Catalog |
| High-performance analytics queries | Redshift (columnar storage) |
| Key-value with change capture for analytics | DynamoDB + Streams/Export |
| Schema discovery across data sources | Glue Crawlers |
| Cross-account data lake access | Lake Formation + LF-Tags |
| Archive with compliance retention | S3 Glacier + Object Lock |
| Column and row-level security on data lake | Lake Formation data filters |

## Common Exam Patterns

1. **"Optimize query cost in Athena"** - Convert to Parquet, partition by query pattern
2. **"Centralized permissions for data lake"** - Lake Formation (not just IAM)
3. **"Schema discovery across S3 data"** - Glue Crawlers
4. **"DynamoDB data in analytics queries"** - Export to S3 or DynamoDB Streams
5. **"Share Redshift data across clusters"** - Data Sharing (not UNLOAD/COPY)
6. **"Column-level access control"** - Lake Formation column permissions
7. **"Reduce storage costs over time"** - S3 lifecycle policies
8. **"Cross-account data lake"** - Lake Formation cross-account grants or LF-Tags
