# Domain 1: Data Ingestion and Transformation - Transformation (34%)

## Overview
This section covers transforming and enriching data for analytics using AWS services. Understanding ETL vs ELT approaches, data formats, and the right transformation service for each workload is essential for the DEA-C01 exam.

## Key AWS Services for Data Transformation

### AWS Glue

**[📖 AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)** - Complete guide to serverless ETL and data integration

#### Glue Components
- **Data Catalog**: Central metadata repository (Hive-compatible metastore)
- **Crawlers**: Automatic schema detection and catalog population
- **ETL Jobs**: PySpark, Scala, or Python Shell transformation scripts
- **Job Bookmarks**: Track processed data for incremental ETL
- **DataBrew**: Visual no-code data preparation
- **Schema Registry**: Schema management for streaming data
- **Data Quality**: Data quality rule definitions and evaluations

**[📖 Glue Architecture](https://docs.aws.amazon.com/glue/latest/dg/components-key-concepts.html)** - Key concepts and components

#### Glue Data Catalog

**[📖 Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)** - Central metadata repository

##### Crawlers
```python
# Crawler configuration
{
    "Name": "my-s3-crawler",
    "Role": "arn:aws:iam::123456789012:role/GlueCrawlerRole",
    "DatabaseName": "my_database",
    "Targets": {
        "S3Targets": [
            {
                "Path": "s3://my-data-lake/raw/",
                "Exclusions": ["**.tmp", "**.log"]
            }
        ]
    },
    "SchemaChangePolicy": {
        "UpdateBehavior": "UPDATE_IN_DATABASE",
        "DeleteBehavior": "LOG"
    },
    "RecrawlPolicy": {
        "RecrawlBehavior": "CRAWL_NEW_FOLDERS_ONLY"
    }
}
```

**[📖 Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)** - Automatic schema discovery and cataloging

##### Catalog Integration
- **Amazon Athena**: Uses Glue Data Catalog as metastore
- **Amazon Redshift Spectrum**: Queries external tables via catalog
- **Amazon EMR**: Hive metastore integration with catalog
- **AWS Lake Formation**: Permissions layer on top of catalog

#### Glue ETL Jobs

**[📖 Glue ETL Programming](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)** - PySpark and Scala ETL development

##### DynamicFrame Operations
```python
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
job.init(args['JOB_NAME'], args)

# Read from Data Catalog
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="my_database",
    table_name="raw_data",
    transformation_ctx="datasource"
)

# Apply mapping (rename and cast columns)
mapped = ApplyMapping.apply(
    frame=datasource,
    mappings=[
        ("user_id", "string", "user_id", "string"),
        ("event_time", "string", "event_timestamp", "timestamp"),
        ("amount", "string", "amount", "double"),
        ("category", "string", "category", "string")
    ],
    transformation_ctx="mapped"
)

# Filter records
filtered = Filter.apply(
    frame=mapped,
    f=lambda x: x["amount"] > 0
)

# Resolve choice (handle ambiguous types)
resolved = ResolveChoice.apply(
    frame=filtered,
    choice="make_struct",
    transformation_ctx="resolved"
)

# Drop null fields
cleaned = DropNullFields.apply(
    frame=resolved,
    transformation_ctx="cleaned"
)

# Write to S3 in Parquet format
glueContext.write_dynamic_frame.from_options(
    frame=cleaned,
    connection_type="s3",
    connection_options={
        "path": "s3://my-data-lake/processed/",
        "partitionKeys": ["category"]
    },
    format="parquet",
    transformation_ctx="output"
)

job.commit()
```

**[📖 DynamicFrame Class](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-crawler-pyspark-extensions-dynamic-frame.html)** - DynamicFrame API reference

##### Glue Job Types

| Job Type | Use Case | Runtime | DPU |
|----------|----------|---------|-----|
| **Spark** | Large-scale ETL with PySpark/Scala | Apache Spark | 2-100 |
| **Spark Streaming** | Streaming ETL from Kinesis/Kafka | Spark Structured Streaming | 2-100 |
| **Python Shell** | Lightweight scripts, small datasets | Python 3.9 | 0.0625 or 1 |
| **Ray** | Distributed Python for ML workloads | Ray framework | 2-100 |

**[📖 Glue Job Types](https://docs.aws.amazon.com/glue/latest/dg/add-job.html)** - Configure ETL job properties

#### Glue Job Bookmarks

**[📖 Job Bookmarks](https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html)** - Track processed data for incremental ETL

- **Purpose**: Prevent reprocessing of already-processed data
- **Mechanism**: Tracks processed files (S3) or rows (JDBC) between job runs
- **States**: Enabled, disabled, or paused
- **Reset**: Can reset bookmarks to reprocess all data

```python
# Enable job bookmarks in job parameters
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'TempDir'])

# Read with bookmark tracking
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="my_database",
    table_name="raw_data",
    transformation_ctx="datasource"  # Required for bookmarks
)
```

#### Glue Data Quality

**[📖 Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/data-quality.html)** - Define and evaluate data quality rules

```python
# Data Quality Rule Language (DQDL) examples
rules = """
Rules = [
    ColumnExists "user_id",
    IsComplete "user_id",
    IsUnique "user_id",
    ColumnValues "amount" > 0,
    ColumnValues "category" in ["electronics", "clothing", "food"],
    Completeness "email" > 0.95,
    RowCount between 1000 and 1000000
]
"""
```

### Amazon EMR

**[📖 Amazon EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)** - Managed big data platform for Spark, Hive, Presto, and more

#### EMR Frameworks
- **Apache Spark**: Distributed data processing and analytics
- **Apache Hive**: SQL-like queries on large datasets
- **Presto/Trino**: Interactive SQL query engine
- **Apache HBase**: NoSQL database on Hadoop
- **Apache Flink**: Stream and batch processing

**[📖 EMR Release Guide](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/)** - Framework versions and compatibility

#### EMR Deployment Options

| Option | Use Case | Management | Scaling |
|--------|----------|------------|---------|
| **EMR on EC2** | Full control, persistent clusters | You manage | Manual/Auto |
| **EMR on EKS** | Kubernetes-based spark jobs | Container-based | Kubernetes |
| **EMR Serverless** | No cluster management | Fully managed | Automatic |

**[📖 EMR Serverless](https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/)** - Run Spark and Hive without managing clusters

#### Spark on EMR
```python
# PySpark job on EMR
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, year, month, dayofmonth

spark = SparkSession.builder \
    .appName("DataTransformation") \
    .enableHiveSupport() \
    .getOrCreate()

# Read from S3
df = spark.read.parquet("s3://data-lake/raw/events/")

# Transform
transformed = df \
    .filter(col("event_type") == "purchase") \
    .withColumn("year", year(col("event_date"))) \
    .withColumn("month", month(col("event_date"))) \
    .groupBy("year", "month", "category") \
    .agg({"amount": "sum", "user_id": "countDistinct"}) \
    .withColumnRenamed("sum(amount)", "total_revenue") \
    .withColumnRenamed("count(DISTINCT user_id)", "unique_customers")

# Write partitioned output
transformed.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .parquet("s3://data-lake/processed/monthly_revenue/")
```

**[📖 Spark Best Practices on EMR](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-spark-performance.html)** - Performance tuning for Spark jobs

#### EMR vs Glue Comparison

| Feature | AWS Glue | Amazon EMR |
|---------|----------|------------|
| **Management** | Fully serverless | Cluster management required |
| **Scaling** | Automatic | Manual/Auto Scaling |
| **Cost Model** | Per DPU-hour | Per EC2 instance-hour |
| **Frameworks** | Spark, Python Shell, Ray | Spark, Hive, Presto, HBase, Flink |
| **Customization** | Limited | Full control |
| **Best For** | Standard ETL workloads | Complex/large-scale processing |
| **Data Catalog** | Built-in integration | Hive metastore or Glue Catalog |

### AWS Lambda for Data Transformation

**[📖 AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)** - Serverless compute for event-driven transformation

#### Lambda Transformation Patterns
```python
import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    """Process S3 event and transform data"""
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Read raw data
        response = s3.get_object(Bucket=bucket, Key=key)
        raw_data = json.loads(response['Body'].read().decode('utf-8'))

        # Transform
        transformed = []
        for item in raw_data:
            transformed.append({
                'user_id': item['userId'],
                'event_type': item['type'].lower(),
                'timestamp': item['ts'],
                'amount': float(item.get('amount', 0)),
                'processed': True
            })

        # Write transformed data
        output_key = key.replace('raw/', 'processed/')
        s3.put_object(
            Bucket=bucket,
            Key=output_key,
            Body=json.dumps(transformed),
            ContentType='application/json'
        )

    return {'statusCode': 200, 'body': f'Processed {len(event["Records"])} files'}
```

**[📖 Lambda with S3](https://docs.aws.amazon.com/lambda/latest/dg/with-s3.html)** - Event-driven file processing
**[📖 Lambda with Kinesis](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html)** - Stream record transformation

#### Lambda Limitations for Data Engineering
- **Timeout**: 15 minutes max (not suitable for long ETL jobs)
- **Memory**: 128 MB - 10 GB
- **Payload**: 6 MB synchronous, 256 KB asynchronous
- **Temp storage**: 512 MB - 10 GB (/tmp)
- **Best for**: Lightweight transformations, event-driven processing, Firehose transformation

### AWS Step Functions

**[📖 AWS Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)** - Orchestrate multi-step data pipelines

#### Data Pipeline State Machine
```json
{
  "Comment": "Data Pipeline Orchestration",
  "StartAt": "StartCrawler",
  "States": {
    "StartCrawler": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startCrawler",
      "Parameters": {
        "Name": "raw-data-crawler"
      },
      "Next": "WaitForCrawler",
      "Retry": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "IntervalSeconds": 30,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ]
    },
    "WaitForCrawler": {
      "Type": "Wait",
      "Seconds": 60,
      "Next": "StartGlueJob"
    },
    "StartGlueJob": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "transform-raw-data",
        "Arguments": {
          "--input_path": "s3://data-lake/raw/",
          "--output_path": "s3://data-lake/processed/"
        }
      },
      "Next": "CheckJobResult",
      "Catch": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "Next": "HandleError"
        }
      ]
    },
    "CheckJobResult": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.JobRunState",
          "StringEquals": "SUCCEEDED",
          "Next": "LoadToRedshift"
        }
      ],
      "Default": "HandleError"
    },
    "LoadToRedshift": {
      "Type": "Task",
      "Resource": "arn:aws:states:::redshift-data:executeStatement.sync",
      "Parameters": {
        "ClusterIdentifier": "my-cluster",
        "Database": "analytics",
        "Sql": "COPY fact_events FROM 's3://data-lake/processed/' IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole' FORMAT AS PARQUET"
      },
      "End": true
    },
    "HandleError": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:pipeline-alerts",
        "Message": "Pipeline failed - check logs"
      },
      "End": true
    }
  }
}
```

**[📖 Step Functions with Glue](https://docs.aws.amazon.com/step-functions/latest/dg/connect-glue.html)** - Orchestrate Glue ETL jobs
**[📖 Step Functions Error Handling](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html)** - Retry and catch configurations

## Data Formats and Optimization

### Format Comparison

| Format | Type | Compression | Splittable | Schema | Best For |
|--------|------|-------------|------------|--------|----------|
| **Parquet** | Columnar | Snappy, GZIP, LZO | Yes | Embedded | Analytics (Athena, Redshift Spectrum) |
| **ORC** | Columnar | Zlib, Snappy, LZO | Yes | Embedded | Hive/EMR workloads |
| **Avro** | Row-based | Snappy, Deflate | Yes | Embedded | Schema evolution, streaming |
| **JSON** | Row-based | GZIP | Yes (NDJSON) | Self-describing | APIs, semi-structured |
| **CSV** | Row-based | GZIP | Yes | None | Simple interchange |

**[📖 Athena Supported Formats](https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html)** - SerDe libraries and format support
**[📖 Glue Format Options](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-format.html)** - ETL format configuration

### Format Conversion with Glue
```python
# Convert JSON to Parquet
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="raw_db",
    table_name="json_data"
)

# Write as Parquet with Snappy compression
glueContext.write_dynamic_frame.from_options(
    frame=datasource,
    connection_type="s3",
    connection_options={
        "path": "s3://data-lake/optimized/",
        "partitionKeys": ["year", "month"]
    },
    format="parquet",
    format_options={"compression": "snappy"}
)
```

### Firehose Format Conversion
- **Input**: JSON records
- **Output**: Parquet or ORC in S3
- **Schema Source**: Glue Data Catalog table
- **No Lambda required**: Built-in conversion

**[📖 Firehose Format Conversion](https://docs.aws.amazon.com/firehose/latest/dev/record-format-conversion.html)** - Convert JSON to Parquet/ORC

## ETL vs ELT Patterns

### ETL (Extract, Transform, Load)
```
Source → AWS Glue/EMR (Transform) → Load into Redshift/S3
```
- Transform data before loading into target
- Better for complex transformations
- Reduces storage costs (only store transformed data)
- AWS Services: Glue, EMR, Lambda

### ELT (Extract, Load, Transform)
```
Source → Load into Redshift/S3 → Transform with SQL (Athena/Redshift)
```
- Load raw data first, transform with SQL
- Leverage target system's compute power
- Faster initial load, transform on demand
- AWS Services: Athena, Redshift, Redshift Spectrum

**[📖 Building Data Lakes on AWS](https://docs.aws.amazon.com/whitepapers/latest/building-data-lakes/building-data-lake-aws.html)** - Architecture patterns for ETL and ELT

## Study Tips

1. **Master Glue ETL**: Understand DynamicFrames, crawlers, job bookmarks
2. **Know data formats**: When to use Parquet vs ORC vs Avro vs JSON
3. **EMR vs Glue**: Understand when to choose each service
4. **Step Functions**: Know how to orchestrate multi-step pipelines
5. **Lambda limits**: Understand when Lambda is appropriate for transformation
6. **Format conversion**: Firehose built-in conversion vs Glue ETL conversion

## Common Exam Scenarios

- Choosing Glue vs EMR for ETL workloads
- Designing incremental ETL with Glue job bookmarks
- Converting JSON to Parquet for Athena query optimization
- Orchestrating multi-step pipeline with Step Functions
- Using Lambda for lightweight event-driven transformation
- Implementing data quality checks in ETL pipelines
- Selecting ETL vs ELT based on requirements

## CLI Quick Reference

```bash
# Glue
aws glue create-crawler --name my-crawler --role GlueCrawlerRole --database-name my_db --targets '{"S3Targets":[{"Path":"s3://bucket/prefix/"}]}'
aws glue start-crawler --name my-crawler
aws glue start-job-run --job-name my-etl-job --arguments '{"--input":"s3://bucket/raw/"}'
aws glue get-job-runs --job-name my-etl-job

# EMR
aws emr create-cluster --name "Spark Cluster" --release-label emr-6.10.0 --applications Name=Spark
aws emr add-steps --cluster-id j-XXXXX --steps Type=Spark,Name="ETL Job",ActionOnFailure=CONTINUE,Args=[s3://bucket/scripts/etl.py]

# Step Functions
aws stepfunctions create-state-machine --name data-pipeline --definition file://pipeline.json --role-arn arn:aws:iam::123456789012:role/StepFunctionsRole
aws stepfunctions start-execution --state-machine-arn arn:... --input '{"date":"2024-01-01"}'
```
