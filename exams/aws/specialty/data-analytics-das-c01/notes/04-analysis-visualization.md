# Analysis and Visualization - AWS Data Analytics Specialty

## Overview

Analysis and visualization covers 18% of the DAS-C01 exam. This domain focuses on querying, analyzing, and visualizing data using Athena, Redshift, QuickSight, OpenSearch, and related services.

## Amazon Athena

**[📖 Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)** - Interactive query service

### Key Features

- Serverless interactive query service for S3 data
- Standard SQL (Presto/Trino engine)
- Pay per query: $5 per TB scanned
- Uses Glue Data Catalog for table definitions
- Supports CSV, JSON, ORC, Parquet, Avro, and more
- CTAS (Create Table As Select) for materialized results

### Cost Optimization

- **Use columnar formats**: Parquet or ORC reduce scanned data by 75%+
- **Partition data**: Partition by common filter columns (date, region)
- **Compress data**: GZIP, LZ4, Snappy, ZSTD
- **Use LIMIT**: Does not reduce cost (full scan still happens) - use partitions instead
- **Workgroups**: Set per-query and per-workgroup data scan limits
- **Athena engine v3**: Improved performance and cost via adaptive execution

**[📖 Athena Performance Tuning](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)** - Query optimization

### Athena Federated Query

**[📖 Federated Queries](https://docs.aws.amazon.com/athena/latest/ug/connect-to-a-data-source.html)** - Cross-source queries

- Query data across S3, DynamoDB, RDS, Redshift, CloudWatch, and more
- Uses Lambda-based data source connectors
- Pre-built connectors in AWS Serverless Application Repository
- Custom connectors via Athena Query Federation SDK
- Join data across multiple sources in a single query

### Athena for Apache Spark

- Run Spark notebooks directly in Athena
- Serverless Spark execution
- No EMR cluster management
- Uses Athena workgroups for resource management
- Good for ad-hoc exploratory analysis

### Key Limits

- Query timeout: 30 minutes
- Max query string length: 262,144 bytes
- Result size: Unlimited (writes to S3)
- DML query concurrency: 25 per account (adjustable)

## Amazon Redshift

**[📖 Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)** - Data warehouse

### Architecture

- **Leader Node**: Query planning, aggregation, client communication
- **Compute Nodes**: Execute queries in parallel, store data
- **Node Types**:
  - RA3: Managed storage (scales separately from compute), recommended
  - DC2: Dense compute with local SSD
  - DS2: Dense storage (legacy, use RA3 instead)
- **Slices**: Each compute node has slices that process portions of data

### Performance Optimization

**Sort Keys:**
- **Compound sort key**: Multiple columns, queries must use leading column
- **Interleaved sort key**: Equal weight to all columns, better for varied queries
- Best for columns used in WHERE, ORDER BY, JOIN
- Compound is better for most use cases (less VACUUM overhead)

**Distribution Styles:**
- **KEY**: Colocate joined rows on same node (join performance)
- **ALL**: Copy small tables to every node (dimension tables)
- **EVEN**: Round-robin (default for no clear key)
- **AUTO**: Redshift auto-selects based on table size and queries

**[📖 Distribution Styles](https://docs.aws.amazon.com/redshift/latest/dg/c_choosing_dist_sort.html)** - Choosing distribution

**Other Optimization:**
- **COPY command**: Fastest way to load data (parallel from S3, DynamoDB, EMR)
- **VACUUM**: Reclaim space and re-sort after deletes/updates
- **ANALYZE**: Update table statistics for query optimizer
- **WLM (Workload Management)**: Queue configuration for query prioritization
- **Concurrency Scaling**: Automatically add clusters for burst read queries
- **Materialized Views**: Pre-computed results, auto-refresh

**[📖 COPY Command](https://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html)** - Data loading
**[📖 WLM Configuration](https://docs.aws.amazon.com/redshift/latest/dg/cm-c-defining-query-queues.html)** - Workload management

### Redshift Spectrum

**[📖 Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)** - Query S3 data

- Query data in S3 without loading into Redshift
- Uses external tables defined in Glue Data Catalog or Redshift external schema
- Leverages Redshift compute for joins with local data
- Push-down predicates and aggregations to Spectrum layer
- Pay per TB scanned (like Athena)
- Use for infrequently queried data or data lake integration

### Redshift Serverless

- No cluster management
- Auto-scales compute based on workload
- Pay per RPU (Redshift Processing Unit) second
- Good for variable or unpredictable workloads
- Base capacity in RPUs (min 8, max 512)

### Redshift ML

- Create ML models using SQL (CREATE MODEL)
- Uses SageMaker Autopilot under the hood
- Training data stays in Redshift
- Inference via SQL functions
- Supports regression, classification, and forecasting

## Amazon QuickSight

**[📖 QuickSight User Guide](https://docs.aws.amazon.com/quicksight/latest/user/welcome.html)** - Business intelligence

### Key Features

- Serverless BI and visualization service
- **SPICE**: Super-fast, Parallel, In-memory Calculation Engine
  - In-memory data store for fast dashboard performance
  - 10 GB per user in Standard, 500 GB per user in Enterprise
  - Auto-refreshes on schedule
- ML-powered insights: Anomaly detection, forecasting, narratives
- Embedded analytics: Embed dashboards in applications
- Paginated reports: Pixel-perfect formatted reports

**[📖 SPICE](https://docs.aws.amazon.com/quicksight/latest/user/spice.html)** - In-memory engine

### Data Sources

- AWS: S3, Athena, Redshift, RDS, Aurora, OpenSearch, Timestream
- SaaS: Salesforce, Jira, ServiceNow
- On-premises: SQL Server, MySQL, PostgreSQL (via Direct Connect/VPN)
- File upload: CSV, TSV, Excel, JSON
- Direct query mode (live) or SPICE (cached)

### Visualization Types

- Bar charts, line charts, pie charts, scatter plots
- Pivot tables, heat maps, tree maps
- Geospatial maps, filled maps
- KPIs, gauges, word clouds
- Sankey diagrams, waterfall charts, funnel charts
- Custom visuals via QuickSight plugins

### Security

- **Row-level security (RLS)**: Restrict data rows by user/group
- **Column-level security (CLS)**: Restrict columns by user/group
- **VPC connectivity**: Access private data sources via VPC connection
- **IAM integration**: Federate with SAML or IAM for user management
- Enterprise edition: SAML federation, AD integration, private VPC

**[📖 Row-Level Security](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html)** - RLS configuration

## Amazon OpenSearch Service

**[📖 OpenSearch Service Guide](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)** - Search and analytics

### Key Features

- Managed OpenSearch (fork of Elasticsearch)
- Full-text search, log analytics, application monitoring
- Near real-time indexing and search
- Kibana/OpenSearch Dashboards for visualization
- UltraWarm: Cost-effective warm storage tier (read-only, S3-backed)
- Cold storage: Lowest cost tier for infrequent access

### Architecture

- **Domain**: Cluster of instances
- **Index**: Collection of documents (like a database table)
- **Shard**: Horizontal partition of an index
- **Replica**: Copy of a shard for availability and read throughput
- **Primary shards**: Set at index creation, cannot change
- **Replica shards**: Can adjust after creation

### Use Cases for Analytics

- **Log analytics**: Centralized logging with CloudWatch, Firehose, or Logstash
- **Clickstream analytics**: Real-time user behavior analysis
- **Security analytics**: SIEM - correlate logs for threat detection
- **Full-text search**: Product search, document search
- **Application monitoring**: Metrics and trace analysis

### Integration Pattern

Common pipeline: Kinesis Data Streams - Firehose - OpenSearch
- Firehose handles buffering, transformation, and delivery
- OpenSearch Dashboards for visualization
- Index lifecycle management for data retention

**[📖 Loading Streaming Data](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/integrations.html)** - Data ingestion

## Athena vs Redshift vs Redshift Spectrum

| Feature | Athena | Redshift | Redshift Spectrum |
|---------|--------|----------|-------------------|
| Data location | S3 only | Redshift cluster | S3 (external) |
| Infrastructure | Serverless | Provisioned/Serverless | Requires Redshift cluster |
| Best for | Ad-hoc queries | Complex analytics, joins | Extend Redshift to S3 |
| Performance | Good for simple | Best for complex | Good for filtered S3 |
| Cost model | Per TB scanned | Per node-hour / RPU | Per TB scanned |
| Data loading | No loading needed | COPY from S3 | No loading needed |
| Concurrency | 25 queries | WLM queues | Shared with Redshift |

## Common Exam Patterns

1. **"Ad-hoc query on S3 data"** - Athena
2. **"Complex joins, aggregations, dashboards"** - Redshift
3. **"Extend Redshift to query S3"** - Redshift Spectrum
4. **"Business dashboards for non-technical users"** - QuickSight
5. **"Log analytics with search"** - OpenSearch Service
6. **"Reduce Athena cost"** - Columnar format + partitions + compression
7. **"Burst query capacity"** - Redshift Concurrency Scaling
8. **"Real-time dashboard updates"** - QuickSight with SPICE auto-refresh
9. **"Query across multiple data sources"** - Athena Federated Query
10. **"ML predictions in SQL"** - Redshift ML
