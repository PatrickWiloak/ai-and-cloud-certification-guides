# Domain 2: Data Store Management (26%)

## Overview
This domain covers choosing appropriate data stores for analytics workloads, managing data catalogs and metadata, implementing data lifecycle policies, and optimizing storage for cost and performance.

## Key AWS Data Store Services

### Amazon S3 - Data Lake Foundation

**[📖 Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)** - Complete guide to S3 object storage

#### Storage Classes

| Storage Class | Use Case | Availability | Min Duration | Retrieval |
|--------------|----------|--------------|--------------|-----------|
| **S3 Standard** | Frequently accessed data | 99.99% | None | Immediate |
| **S3 Intelligent-Tiering** | Unknown access patterns | 99.9% | None | Immediate |
| **S3 Standard-IA** | Infrequently accessed | 99.9% | 30 days | Immediate |
| **S3 One Zone-IA** | Non-critical infrequent data | 99.5% | 30 days | Immediate |
| **S3 Glacier Instant** | Archive with instant access | 99.9% | 90 days | Milliseconds |
| **S3 Glacier Flexible** | Archive with flexible retrieval | 99.99% | 90 days | Minutes to hours |
| **S3 Glacier Deep Archive** | Long-term archive | 99.99% | 180 days | 12-48 hours |

**[📖 S3 Storage Classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)** - Compare storage tiers and pricing

#### Lifecycle Policies
```json
{
    "Rules": [
        {
            "ID": "DataLakeLifecycle",
            "Status": "Enabled",
            "Filter": {
                "Prefix": "processed/"
            },
            "Transitions": [
                {
                    "Days": 30,
                    "StorageClass": "STANDARD_IA"
                },
                {
                    "Days": 90,
                    "StorageClass": "GLACIER"
                },
                {
                    "Days": 365,
                    "StorageClass": "DEEP_ARCHIVE"
                }
            ],
            "Expiration": {
                "Days": 2555
            }
        }
    ]
}
```

**[📖 S3 Lifecycle Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)** - Automate storage class transitions

#### Data Lake Organization
```
s3://data-lake/
├── raw/                          # Unprocessed source data
│   ├── database/
│   │   └── table_name/
│   │       └── year=2024/month=01/day=15/
│   └── streaming/
│       └── topic_name/
│           └── year=2024/month=01/day=15/hour=08/
├── processed/                    # Cleaned and transformed data
│   ├── domain/
│   │   └── dataset/
│   │       └── year=2024/month=01/
├── curated/                      # Business-ready data
│   └── analytics/
│       └── aggregated_metrics/
└── archive/                      # Historical data (Glacier)
    └── year=2023/
```

**[📖 Building Data Lakes on AWS](https://docs.aws.amazon.com/whitepapers/latest/building-data-lakes/building-data-lake-aws.html)** - Data lake architecture patterns

#### S3 Select
```python
import boto3

s3 = boto3.client('s3')

# Query CSV data in S3 without downloading entire object
response = s3.select_object_content(
    Bucket='data-lake',
    Key='raw/events/events.csv',
    ExpressionType='SQL',
    Expression="SELECT s.user_id, s.amount FROM s3object s WHERE s.amount > '100'",
    InputSerialization={'CSV': {'FileHeaderInfo': 'USE'}},
    OutputSerialization={'JSON': {}}
)

for event in response['Payload']:
    if 'Records' in event:
        print(event['Records']['Payload'].decode('utf-8'))
```

**[📖 S3 Select](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)** - Query data in place with SQL

### Amazon Redshift - Cloud Data Warehouse

**[📖 Amazon Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)** - Complete Redshift documentation

#### Architecture
- **Leader Node**: Query planning, optimization, and result aggregation
- **Compute Nodes**: Execute queries in parallel across data slices
- **Slices**: Partition of compute node's memory and disk
- **Node Types**: dc2 (dense compute, SSD), ra3 (managed storage, S3-backed)

**[📖 Redshift Architecture](https://docs.aws.amazon.com/redshift/latest/dg/c_high_level_system_architecture.html)** - Node types and cluster architecture

#### Distribution Styles

| Style | Description | Best For |
|-------|-------------|----------|
| **KEY** | Rows with same key on same node | Join columns, large fact tables |
| **EVEN** | Round-robin distribution | No joins or aggregation keys |
| **ALL** | Full copy on every node | Small dimension tables |
| **AUTO** | Redshift chooses automatically | Default (recommended) |

```sql
-- Create table with distribution and sort keys
CREATE TABLE fact_orders (
    order_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2),
    product_category VARCHAR(50)
)
DISTKEY(customer_id)
SORTKEY(order_date);

-- Create dimension table with ALL distribution
CREATE TABLE dim_products (
    product_id BIGINT NOT NULL,
    product_name VARCHAR(200),
    category VARCHAR(50)
)
DISTSTYLE ALL;
```

**[📖 Redshift Distribution Styles](https://docs.aws.amazon.com/redshift/latest/dg/c_choosing_dist_sort.html)** - Choose optimal distribution and sort keys

#### COPY Command (Bulk Loading)
```sql
-- Load from S3 (recommended for bulk loading)
COPY fact_orders
FROM 's3://data-lake/processed/orders/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
FORMAT AS PARQUET;

-- Load CSV with options
COPY fact_orders
FROM 's3://data-lake/raw/orders.csv'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
CSV
IGNOREHEADER 1
DATEFORMAT 'YYYY-MM-DD'
GZIP
REGION 'us-east-1';

-- Load from multiple files (manifest)
COPY fact_orders
FROM 's3://data-lake/manifests/orders.manifest'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
MANIFEST
FORMAT AS PARQUET;
```

**[📖 Redshift COPY Command](https://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html)** - Bulk data loading reference

#### UNLOAD Command
```sql
-- Export query results to S3
UNLOAD ('SELECT * FROM fact_orders WHERE order_date >= ''2024-01-01''')
TO 's3://data-lake/exports/orders_2024/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftUnloadRole'
FORMAT AS PARQUET
PARTITION BY (product_category);
```

**[📖 Redshift UNLOAD](https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html)** - Export data to S3

#### Redshift Spectrum
```sql
-- Create external schema pointing to Glue Data Catalog
CREATE EXTERNAL SCHEMA spectrum_schema
FROM DATA CATALOG
DATABASE 'my_datalake_db'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftSpectrumRole'
CREATE EXTERNAL DATABASE IF NOT EXISTS;

-- Query S3 data through Spectrum
SELECT
    s.product_category,
    SUM(s.amount) AS total_revenue,
    COUNT(*) AS order_count
FROM spectrum_schema.raw_orders s
WHERE s.year = '2024' AND s.month = '01'
GROUP BY s.product_category
ORDER BY total_revenue DESC;

-- Join Redshift table with Spectrum external table
SELECT
    r.customer_name,
    SUM(s.amount) AS total_spent
FROM local_schema.customers r
JOIN spectrum_schema.raw_orders s ON r.customer_id = s.customer_id
GROUP BY r.customer_name;
```

**[📖 Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)** - Query S3 data without loading
**[📖 Redshift Serverless](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-serverless.html)** - Serverless data warehouse

#### Materialized Views
```sql
-- Create materialized view for pre-computed aggregations
CREATE MATERIALIZED VIEW mv_daily_revenue AS
SELECT
    order_date,
    product_category,
    SUM(amount) AS daily_revenue,
    COUNT(*) AS order_count
FROM fact_orders
GROUP BY order_date, product_category;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW mv_daily_revenue;

-- Auto-refresh materialized view
ALTER MATERIALIZED VIEW mv_daily_revenue AUTO REFRESH YES;
```

**[📖 Redshift Materialized Views](https://docs.aws.amazon.com/redshift/latest/dg/materialized-view-overview.html)** - Pre-computed query results

### Amazon Athena - Serverless SQL on S3

**[📖 Amazon Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)** - Serverless interactive query service

#### Query Optimization
```sql
-- Use partition projection for automatic partition management
CREATE EXTERNAL TABLE events (
    event_id STRING,
    user_id STRING,
    event_type STRING,
    amount DOUBLE
)
PARTITIONED BY (
    year STRING,
    month STRING,
    day STRING
)
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
    'storage.location.template' = 's3://data-lake/events/year=${year}/month=${month}/day=${day}/'
);

-- CTAS: Create Table As Select (results stored in S3)
CREATE TABLE processed_events
WITH (
    format = 'PARQUET',
    external_location = 's3://data-lake/processed/events/',
    partitioned_by = ARRAY['year', 'month'],
    bucketed_by = ARRAY['user_id'],
    bucket_count = 10
) AS
SELECT
    event_id,
    user_id,
    event_type,
    amount,
    year(event_date) AS year,
    month(event_date) AS month
FROM raw_events
WHERE event_date >= DATE '2024-01-01';
```

**[📖 Athena Partition Projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)** - Automatic partition management
**[📖 Athena CTAS](https://docs.aws.amazon.com/athena/latest/ug/ctas.html)** - Create Table As Select

#### Athena Performance Best Practices
1. **Use columnar formats**: Parquet or ORC reduce data scanned
2. **Partition data**: Query only relevant partitions
3. **Use partition projection**: Avoid MSCK REPAIR TABLE
4. **Compress data**: Snappy or GZIP compression
5. **Optimize file sizes**: 128 MB - 512 MB optimal file size
6. **Use CTAS**: Materialize frequently-used query results
7. **Avoid SELECT ***: Select only needed columns

**[📖 Athena Performance Tuning](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)** - Query optimization best practices

#### Athena Federated Query
- **Lambda-based connectors**: Query DynamoDB, RDS, Redshift, CloudWatch, and more
- **Cross-account queries**: Query S3 data in other AWS accounts
- **Custom connectors**: Build connectors for any data source

**[📖 Athena Federated Query](https://docs.aws.amazon.com/athena/latest/ug/connect-to-a-data-source.html)** - Query across data sources

### Amazon DynamoDB

**[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)** - Fully managed NoSQL database

#### DynamoDB in Data Pipelines
- **Key-value lookups**: Enrichment data for streaming pipelines
- **DynamoDB Streams**: Change data capture for downstream processing
- **Export to S3**: Full table export for analytics
- **Global Tables**: Multi-region replication

**[📖 DynamoDB Export to S3](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DataExport.html)** - Export table data for analytics

#### DynamoDB Streams for CDC
```python
# Lambda function processing DynamoDB Streams
def lambda_handler(event, context):
    for record in event['Records']:
        event_name = record['eventName']  # INSERT, MODIFY, REMOVE

        if event_name == 'INSERT':
            new_image = record['dynamodb']['NewImage']
            # Process new item - send to Kinesis, write to S3, etc.

        elif event_name == 'MODIFY':
            old_image = record['dynamodb']['OldImage']
            new_image = record['dynamodb']['NewImage']
            # Process change - compare old and new values

        elif event_name == 'REMOVE':
            old_image = record['dynamodb']['OldImage']
            # Process deletion

    return {'statusCode': 200}
```

**[📖 DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)** - Change data capture
**[📖 DynamoDB Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)** - Multi-region replication

### Amazon RDS and Aurora

**[📖 Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)** - Managed relational databases
**[📖 Amazon Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html)** - High-performance managed databases

#### Data Engineering Use Cases
- **OLTP source**: Transactional data source for ETL pipelines
- **DMS source**: Source endpoint for database migration
- **Aurora Serverless**: Auto-scaling for variable workloads
- **Read replicas**: Offload reporting queries from production
- **Aurora zero-ETL**: Direct integration with Redshift (no ETL needed)

**[📖 Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)** - Auto-scaling Aurora
**[📖 Aurora Zero-ETL with Redshift](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.html)** - Direct Aurora to Redshift integration

### Amazon OpenSearch Service

**[📖 Amazon OpenSearch Service Developer Guide](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)** - Search, log analytics, and visualization

#### Data Engineering Use Cases
- **Log analytics**: Centralized log aggregation and analysis
- **Full-text search**: Search across large document collections
- **Real-time dashboards**: Kibana/OpenSearch Dashboards visualization
- **Anomaly detection**: ML-based anomaly detection on time-series data

#### Ingestion Patterns
```
Application Logs → Kinesis Data Firehose → OpenSearch
CloudWatch Logs → Subscription Filter → Lambda → OpenSearch
DynamoDB Streams → Lambda → OpenSearch
S3 Data → OpenSearch Ingestion Pipeline → OpenSearch
```

**[📖 OpenSearch Ingestion](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ingestion.html)** - Managed ingestion pipelines

## Data Store Selection Guide

### Decision Matrix

| Requirement | Recommended Service |
|-------------|-------------------|
| **Data lake storage** | Amazon S3 |
| **Complex SQL analytics** | Amazon Redshift |
| **Ad-hoc SQL queries on S3** | Amazon Athena |
| **Low-latency key-value** | Amazon DynamoDB |
| **OLTP workloads** | Amazon RDS/Aurora |
| **Full-text search** | Amazon OpenSearch |
| **Real-time dashboards** | Amazon QuickSight |
| **Data catalog/metadata** | AWS Glue Data Catalog |
| **Data lake governance** | AWS Lake Formation |

### Cost Optimization Strategies
1. **S3 lifecycle policies**: Automate tier transitions
2. **Redshift reserved nodes**: Up to 75% savings
3. **Athena columnar formats**: Reduce data scanned (and cost)
4. **DynamoDB on-demand**: For unpredictable workloads
5. **Redshift pause/resume**: Stop clusters when not in use
6. **S3 Intelligent-Tiering**: Automatic cost optimization

## Study Tips

1. **S3 mastery**: Storage classes, lifecycle, partitioning strategies
2. **Redshift loading**: COPY command, distribution styles, sort keys
3. **Athena optimization**: Partitioning, formats, partition projection
4. **Data store selection**: Know when to use each service
5. **Spectrum vs Athena**: Both query S3 but different architectures
6. **DynamoDB Streams**: CDC for event-driven data pipelines

## Common Exam Scenarios

- Choosing between Redshift and Athena for analytics
- Designing S3 data lake with partitioning and lifecycle
- Optimizing Athena query performance and reducing costs
- Loading data into Redshift with COPY command
- Using Redshift Spectrum to query S3 data
- Implementing DynamoDB Streams for change data capture
- Selecting storage classes for data retention requirements

## CLI Quick Reference

```bash
# S3
aws s3 ls s3://data-lake/raw/
aws s3 cp s3://source/ s3://destination/ --recursive
aws s3api put-bucket-lifecycle-configuration --bucket data-lake --lifecycle-configuration file://lifecycle.json

# Redshift
aws redshift create-cluster --cluster-identifier my-cluster --node-type ra3.xlplus --number-of-nodes 2
aws redshift-data execute-statement --cluster-identifier my-cluster --database analytics --sql "SELECT COUNT(*) FROM fact_orders"

# Athena
aws athena start-query-execution --query-string "SELECT * FROM events LIMIT 10" --result-configuration OutputLocation=s3://athena-results/
aws athena get-query-execution --query-execution-id abc-123

# DynamoDB
aws dynamodb describe-table --table-name my-table
aws dynamodb export-table-to-point-in-time --table-arn arn:... --s3-bucket exports --export-format DYNAMODB_JSON

# OpenSearch
aws opensearch describe-domain --domain-name my-domain
```
