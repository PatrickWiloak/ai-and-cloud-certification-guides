# Domain 1: Data Transformation (Part 2 of 2)

## Overview

Data transformation converts raw ingested data into a format suitable for analytics, reporting, and machine learning. This document covers the transformation and orchestration services within Domain 1 (Data Ingestion and Transformation, 34% of the exam).

Key decisions include choosing between ETL and ELT approaches, selecting the right compute service (Glue vs EMR vs Lambda), and orchestrating multi-step pipelines.

---

## ETL vs ELT

Understanding the difference between ETL and ELT is fundamental for the exam.

| Approach | Flow | When to Use | AWS Services |
|----------|------|-------------|--------------|
| **ETL** (Extract, Transform, Load) | Extract from source, transform in a processing engine, load to target | Transform before loading into the data store | Glue ETL, EMR, Lambda |
| **ELT** (Extract, Load, Transform) | Extract from source, load into target, transform within the target | Target system has powerful compute for transformation | Redshift (SQL), Athena (CTAS), Redshift Spectrum |

**Key exam insight**: ELT is preferred when the target data store (e.g., Redshift) can efficiently perform transformations using SQL. ETL is preferred when the target does not have strong compute capabilities or when transformations are complex.

---

## AWS Glue

AWS Glue is the primary serverless ETL service on AWS. It provides ETL job execution, a central Data Catalog, crawlers for schema discovery, and DataBrew for visual data preparation.

**📖 [AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)**

### Glue ETL Jobs

Glue ETL jobs run Apache Spark (PySpark or Scala), Python Shell, or Ray-based transformations in a serverless environment.

**📖 [Glue ETL Programming Guide](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)**

#### Job Types

| Job Type | Engine | Use Case | Scaling |
|----------|--------|----------|---------|
| **Spark** | Apache Spark (PySpark or Scala) | Large-scale distributed ETL | DPUs (2-100+), auto-scaling |
| **Python Shell** | Python runtime | Small-scale scripts, API calls, simple transforms | 1 DPU or 0.0625 DPU |
| **Ray** | Ray distributed framework | ML workloads, Python-native parallel processing | Workers (2-100+) |
| **Spark Streaming** | Spark Structured Streaming | Streaming ETL from Kinesis/Kafka | DPUs (2-100+) |

**📖 [Glue Job Types](https://docs.aws.amazon.com/glue/latest/dg/add-job.html)**

#### DynamicFrames vs DataFrames

Glue extends Spark with DynamicFrames, which handle schema inconsistencies better than native Spark DataFrames.

| Feature | DynamicFrame | DataFrame |
|---------|-------------|-----------|
| **Schema handling** | Resolves schema on read, handles mixed types per column | Requires a fixed, uniform schema |
| **Null handling** | Better null handling with resolveChoice | Standard Spark null handling |
| **Glue integrations** | Native Data Catalog, job bookmarks support | Requires explicit catalog integration |
| **Performance** | Slightly slower due to schema flexibility overhead | Faster for complex Spark operations |
| **Conversion** | `.toDF()` converts to DataFrame | `.fromDF()` converts to DynamicFrame |

**Exam tip**: Use DynamicFrames for data with inconsistent schemas (e.g., JSON with varying fields). Convert to DataFrames (`.toDF()`) when you need Spark SQL or advanced DataFrame operations, then convert back if needed.

```python
# Glue ETL Job Example
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read from Data Catalog (supports job bookmarks via transformation_ctx)
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="my_database",
    table_name="raw_data",
    transformation_ctx="datasource"
)

# Apply column mapping (rename and cast)
mapped = ApplyMapping.apply(
    frame=datasource,
    mappings=[
        ("id", "long", "customer_id", "long"),
        ("name", "string", "customer_name", "string"),
        ("amount", "double", "purchase_amount", "double")
    ]
)

# Filter records
filtered = Filter.apply(
    frame=mapped,
    f=lambda x: x["purchase_amount"] > 0
)

# Resolve ambiguous column types
resolved = ResolveChoice.apply(
    frame=filtered,
    choice="make_struct",
    transformation_ctx="resolved"
)

# Drop null fields
cleaned = DropNullFields.apply(frame=resolved)

# Write to S3 in Parquet format with partitioning
glueContext.write_dynamic_frame.from_options(
    frame=cleaned,
    connection_type="s3",
    connection_options={
        "path": "s3://output-bucket/processed/",
        "partitionKeys": ["category"]
    },
    format="parquet",
    transformation_ctx="output"
)

job.commit()
```

**📖 [DynamicFrame Class](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-crawler-pyspark-extensions-dynamic-frame.html)**

#### Job Bookmarks

Job bookmarks track previously processed data so Glue jobs only process new data on subsequent runs. This is essential for incremental ETL.

| State | Behavior | Use Case |
|-------|----------|----------|
| **Enabled** | Process only new data since last successful run | Standard incremental ETL |
| **Disabled** | Process all data every run | Full refresh scenarios |
| **Pause** | Remember bookmark position but process all data | One-time backfill without losing bookmark state |

How bookmarks work:
- **S3 sources**: Tracks file modification timestamps; only processes files added since last run
- **JDBC sources**: Tracks a specified bookmark key column (e.g., `updated_at`); only processes rows with newer values
- **Requires `transformation_ctx`**: The `transformation_ctx` parameter must be set on read and write operations for bookmarks to function

**📖 [Glue Job Bookmarks](https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html)**

#### Auto Scaling

Glue 3.0+ supports auto scaling for Spark jobs:
- Automatically adds or removes workers based on workload demand
- Set a maximum number of workers; Glue scales within that limit
- Reduces cost for jobs with variable processing stages (e.g., heavy shuffle followed by light write)
- Enabled by setting `--enable-auto-scaling` parameter to `true`

**📖 [Glue Auto Scaling](https://docs.aws.amazon.com/glue/latest/dg/auto-scaling.html)**

---

### Glue Crawlers

Crawlers automatically discover data schemas and populate the Glue Data Catalog with table definitions.

**📖 [Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)**

#### How Crawlers Work

1. Crawler connects to a data store (S3, JDBC, DynamoDB, etc.)
2. Built-in or custom classifiers examine data to determine format and schema
3. Crawler creates or updates table definitions in the Data Catalog
4. Partitions are discovered and registered automatically (Hive-style paths)

#### Crawler Configuration Options

| Setting | Options | Impact |
|---------|---------|--------|
| **Data store** | S3 path, JDBC connection, DynamoDB table | What data to crawl |
| **Classifiers** | Built-in (JSON, CSV, Parquet, ORC, Avro) or custom (Grok) | How to parse the data |
| **Schedule** | On-demand, hourly, daily, weekly, custom cron | When to crawl |
| **Recrawl policy** | All folders, new folders only, event-based | What to re-examine |
| **Schema change policy** | Update table, add columns only, log changes | How to handle schema evolution |

**Exam tips for crawlers**:
- Crawlers may create unexpected tables if S3 data is not well-organized (e.g., mixed file formats in same prefix)
- Use S3 event notifications to trigger crawlers only when new data arrives (more efficient than scheduled crawling)
- Crawlers automatically detect Hive-style partitions (e.g., `year=2024/month=01/`)
- Custom Grok classifiers handle non-standard log formats

---

### Glue Data Catalog

The Data Catalog is a centralized metadata repository compatible with the Apache Hive metastore. It is shared across Athena, Redshift Spectrum, EMR, Lake Formation, and Glue ETL.

**📖 [Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)**

#### Components

| Component | Description |
|-----------|-------------|
| **Databases** | Logical groupings of tables (namespaces) |
| **Tables** | Metadata definitions: schema, location, format, SerDe, partitions |
| **Partitions** | Subsets of table data organized by partition key values |
| **Connections** | JDBC, MongoDB, Kafka, and other data store connection configurations |
| **Schema Registry** | Schema versioning and compatibility checks for streaming data (Avro, JSON Schema) |

#### Service Integration

| Service | How It Uses the Data Catalog |
|---------|------------------------------|
| **Amazon Athena** | Table definitions for SQL queries on S3 data |
| **Redshift Spectrum** | External table definitions for querying S3 from Redshift |
| **Amazon EMR** | Hive metastore replacement (EMR 5.8+) |
| **AWS Lake Formation** | Permissions layer on top of catalog tables and columns |
| **AWS Glue ETL** | Source and target table definitions for ETL jobs |
| **Kinesis Firehose** | Schema reference for format conversion (JSON to Parquet) |

**📖 [Data Catalog and Crawlers](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)**

---

### AWS Glue DataBrew

DataBrew is a visual data preparation tool that enables analysts and data stewards to clean and normalize data without writing code.

**📖 [AWS Glue DataBrew User Guide](https://docs.aws.amazon.com/databrew/latest/dg/what-is.html)**

#### Core Concepts

| Concept | Description |
|---------|-------------|
| **Dataset** | A connection to your data: S3, Glue Data Catalog, JDBC, Redshift |
| **Project** | An interactive workspace for exploring and transforming a dataset visually |
| **Recipe** | An ordered set of transformation steps (reusable, versionable, publishable) |
| **Recipe Job** | Executes a recipe on a full dataset and writes output to a destination |
| **Profile Job** | Analyzes data to generate quality statistics: completeness, uniqueness, distribution, correlations |

#### Common DataBrew Transformations

- **Clean**: Remove duplicates, handle missing values, trim whitespace, fix encoding
- **Normalize**: Standardize date formats, convert units, encode categorical values
- **Aggregate**: Group by columns, compute statistics (sum, avg, count, percentiles)
- **Pivot/Unpivot**: Reshape data between wide and long formats
- **Filter**: Include or exclude rows based on conditions
- **Format**: Convert between JSON, CSV, Parquet, ORC, Avro, XML
- **Merge/Join**: Combine datasets on matching keys

#### DataBrew vs Glue ETL

| Factor | DataBrew | Glue ETL |
|--------|----------|----------|
| **Interface** | Visual, point-and-click, no code | Code-based (PySpark, Scala, Python) |
| **Target users** | Analysts, data stewards, business users | Data engineers, developers |
| **Complexity** | Simple to medium transformations | Complex, multi-step ETL with custom logic |
| **Data profiling** | Built-in profiling with statistics | Requires custom code or Glue Data Quality |
| **Scalability** | Good for medium datasets | Better for very large-scale processing |
| **Reusability** | Recipes are versionable and reusable | Scripts are reusable across jobs |

**📖 [DataBrew Recipes](https://docs.aws.amazon.com/databrew/latest/dg/recipes.html)**

---

## Amazon EMR

Amazon EMR (Elastic MapReduce) provides managed clusters running open-source big data frameworks. Use EMR when workloads require the full Spark/Hive/Presto ecosystem or exceed what Glue can handle efficiently.

**📖 [Amazon EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)**

### Cluster Architecture

```
              +-----------------+
              | Primary Node    |
              | (YARN RM,       |
              |  HDFS NameNode) |
              +--------+--------+
                       |
          +------------+------------+
          |                         |
+---------+---------+   +-----------+---------+
| Core Nodes        |   | Task Nodes          |
| (HDFS DataNode +  |   | (Compute only,      |
|  YARN NodeMgr)    |   |  no HDFS storage)   |
| Min 1 required    |   | Optional, ideal     |
|                   |   | for Spot Instances   |
+-------------------+   +---------------------+
```

- **Primary Node** (formerly Master): Runs YARN ResourceManager, HDFS NameNode, and cluster coordination. Single point of management.
- **Core Nodes**: Run YARN NodeManager and HDFS DataNode. Store data and execute tasks. At least one required.
- **Task Nodes**: Run YARN NodeManager only. Pure compute, no HDFS storage. Can be added/removed without data loss. Ideal for Spot Instances to reduce cost.

**📖 [EMR Cluster Architecture](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-overview.html)**

### Apache Spark on EMR

Spark is the most widely used framework on EMR for data transformation:

| Component | Description | Data Engineering Use |
|-----------|-------------|---------------------|
| **SparkSQL** | SQL interface over structured data | SQL-based transformations, compatible with Hive tables |
| **DataFrames** | Distributed, typed data collections with schema | Primary API for ETL transformations |
| **RDDs** | Low-level distributed data abstraction | Rarely needed; use DataFrames instead |
| **Spark Structured Streaming** | Micro-batch stream processing | Near real-time ETL (prefer Kinesis Data Analytics for native streaming) |

```python
# Spark on EMR - transformation example
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, year, month, sum, countDistinct

spark = SparkSession.builder \
    .appName("EMR-Transform") \
    .enableHiveSupport() \
    .getOrCreate()

# Read from S3 (using Glue Data Catalog as Hive metastore)
df = spark.read.parquet("s3://data-lake/raw/events/")

# Transform: filter, derive columns, aggregate
result = (df
    .filter(col("event_type") == "purchase")
    .withColumn("year", year(col("event_date")))
    .withColumn("month", month(col("event_date")))
    .groupBy("year", "month", "product_id")
    .agg(
        sum("amount").alias("total_revenue"),
        countDistinct("user_id").alias("unique_customers")
    )
)

# Write partitioned Parquet to S3
result.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .parquet("s3://data-lake/processed/monthly_revenue/")
```

**📖 [EMR Spark Documentation](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark.html)**

### Apache Hive on EMR

Hive provides SQL-like queries (HiveQL) over large datasets in S3 or HDFS:

- Uses Glue Data Catalog as its metastore by default (EMR 5.8+)
- Supports Parquet, ORC, Avro, JSON, CSV formats
- Optimized for batch SQL workloads and data warehouse-style queries
- Partitioned and bucketed tables for efficient querying

**📖 [EMR Hive Documentation](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-hive.html)**

### EMR Deployment Options

| Option | Description | Best For |
|--------|-------------|----------|
| **EMR on EC2** | Traditional managed clusters with full control | Persistent or transient clusters, fine-tuned configurations |
| **EMR on EKS** | Run Spark jobs on existing EKS clusters | Organizations already using Kubernetes |
| **EMR Serverless** | No cluster management, automatic scaling | Intermittent workloads, no infrastructure management desired |

**📖 [EMR Serverless](https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/emr-serverless.html)**

### Glue ETL vs EMR Decision Guide

| Factor | Choose Glue ETL | Choose EMR |
|--------|-----------------|------------|
| **Infrastructure** | Fully serverless, zero management | Cluster management (or EMR Serverless) |
| **Data scale** | Small to medium datasets | Medium to very large (PB-scale) |
| **Customization** | Glue APIs, limited Spark tuning | Full Spark, Hive, Presto, Flink ecosystem |
| **Cost model** | Per DPU-hour (predictable) | Per EC2 instance-hour (Spot discounts available) |
| **Job bookmarks** | Built-in incremental processing | Must implement manually |
| **Data Catalog** | Native integration | Native integration (EMR 5.8+) |
| **Use case** | Standard ETL pipelines | Complex analytics, ML, interactive queries, multi-framework |

---

## AWS Lambda for Lightweight Transforms

AWS Lambda is a serverless compute service ideal for event-driven, lightweight data transformations. It complements Glue and EMR rather than replacing them.

**📖 [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)**

### Lambda Limits (Critical for Exam)

| Limit | Value |
|-------|-------|
| **Timeout** | 15 minutes maximum |
| **Memory** | 128 MB to 10,240 MB (10 GB) |
| **Ephemeral storage (/tmp)** | 512 MB to 10,240 MB (10 GB) |
| **Deployment package** | 50 MB zipped, 250 MB unzipped (layers included) |
| **Concurrent executions** | 1,000 per region (default, can request increase) |
| **Payload size** | 6 MB synchronous, 256 KB asynchronous |

### Lambda Event Sources for Data Processing

| Event Source | Processing Model | Batch Size | Use Case |
|--------------|-----------------|------------|----------|
| **S3 Events** | Asynchronous invocation | 1 event per invocation | Process new files on upload |
| **Kinesis Data Streams** | Event source mapping (polling) | Up to 10,000 records | Real-time stream processing |
| **DynamoDB Streams** | Event source mapping (polling) | Up to 1,000 records | React to table changes |
| **SQS** | Event source mapping (polling) | Up to 10,000 messages | Queue-based processing |
| **Kinesis Firehose** | Synchronous transformation | Up to 6 MB per batch | Transform records before delivery |

**📖 [Lambda Event Source Mappings](https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventsourcemapping.html)**
**📖 [Lambda with S3](https://docs.aws.amazon.com/lambda/latest/dg/with-s3.html)**
**📖 [Lambda with Kinesis](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html)**

### Lambda Transformation Example (S3 Event-Driven)

```python
import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    """Process new S3 files on upload - lightweight transform"""
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Read raw data
        response = s3.get_object(Bucket=bucket, Key=key)
        raw_data = json.loads(response['Body'].read().decode('utf-8'))

        # Transform each record
        transformed = []
        for item in raw_data:
            transformed.append({
                'user_id': item['userId'],
                'event_type': item['type'].lower(),
                'timestamp': item['ts'],
                'amount': float(item.get('amount', 0)),
            })

        # Write transformed data to processed prefix
        output_key = key.replace('raw/', 'processed/')
        s3.put_object(
            Bucket=bucket,
            Key=output_key,
            Body=json.dumps(transformed),
            ContentType='application/json'
        )

    return {'statusCode': 200}
```

### When to Use Lambda vs Glue ETL vs EMR

| Scenario | Best Choice | Why |
|----------|-------------|-----|
| Transform individual S3 files on arrival | **Lambda** | Event-driven, sub-second startup, no cluster overhead |
| Batch transform millions of records in S3 | **Glue ETL** | Distributed Spark processing, job bookmarks |
| Process Kinesis stream records | **Lambda** | Built-in event source mapping, auto-scaling |
| Transform TB-scale data with complex joins | **EMR** | Full Spark power, cost-effective at scale with Spot |
| Simple format conversion (JSON to Parquet) | **Glue ETL** | Built-in format conversion, no custom code needed |
| Enrich records in Firehose delivery | **Lambda** | Native Firehose transformation integration |
| Interactive data exploration | **EMR (Spark/Presto)** | Notebooks, interactive query engines |
| ML feature engineering at scale | **EMR** or **Glue (Ray)** | Distributed compute for ML workloads |

---

## AWS Step Functions for Pipeline Orchestration

Step Functions coordinates multiple AWS services into serverless visual workflows. It is the recommended AWS-native orchestration service for data pipelines.

**📖 [Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)**

### State Types

| State | Purpose | Data Pipeline Example |
|-------|---------|----------------------|
| **Task** | Execute work (invoke Lambda, Glue, EMR, etc.) | Run a Glue ETL job |
| **Choice** | Branch based on conditions | Route based on data quality results |
| **Parallel** | Execute branches concurrently | Run independent transforms simultaneously |
| **Map** | Iterate over a collection | Process each partition file in parallel |
| **Wait** | Delay execution for a specified time | Wait for external system readiness |
| **Pass** | Pass input to output with optional transformation | Inject default values or restructure payloads |
| **Succeed** | Terminal success state | Mark pipeline as complete |
| **Fail** | Terminal failure state with error and cause | Mark pipeline as failed with details |

**📖 [Step Functions States](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-states.html)**

### Workflow Types

| Type | Max Duration | Start Rate | Pricing | Use Case |
|------|-------------|------------|---------|----------|
| **Standard** | Up to 1 year | 2,000/sec | Per state transition ($0.025/1000) | Long-running ETL pipelines, orchestration |
| **Express** | Up to 5 minutes | 100,000/sec | Per execution + duration | High-volume, short-duration processing |

### Error Handling

Step Functions provides robust error handling with Retry and Catch mechanisms:

```json
{
  "StartGlueJob": {
    "Type": "Task",
    "Resource": "arn:aws:states:::glue:startJobRun.sync",
    "Parameters": {
      "JobName": "my-etl-job"
    },
    "Retry": [
      {
        "ErrorEquals": ["Glue.ConcurrentRunsExceededException"],
        "IntervalSeconds": 60,
        "MaxAttempts": 3,
        "BackoffRate": 2.0
      }
    ],
    "Catch": [
      {
        "ErrorEquals": ["States.ALL"],
        "Next": "SendFailureNotification"
      }
    ],
    "Next": "VerifyResults"
  }
}
```

**📖 [Step Functions Error Handling](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html)**

### Native Service Integrations for Data Pipelines

Step Functions uses optimized integrations with `.sync` (wait for completion) pattern:

| Service | Integration | What It Does |
|---------|------------|-------------|
| **AWS Glue** | `glue:startJobRun.sync` | Start ETL job and wait for completion |
| **Amazon EMR** | `elasticmapreduce:addStep.sync` | Submit EMR step and wait |
| **Amazon Athena** | `athena:startQueryExecution.sync` | Run query and wait for results |
| **AWS Lambda** | Direct invoke | Run transformation function |
| **Redshift Data API** | `redshift-data:executeStatement.sync` | Execute SQL and wait |
| **Amazon S3** | `s3:getObject`, `s3:putObject` | Read/write S3 objects |
| **Amazon SQS** | `sqs:sendMessage` | Decouple pipeline stages |
| **Amazon SNS** | `sns:publish` | Send notifications (success/failure alerts) |

**📖 [Step Functions Service Integrations](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-service-integrations.html)**

---

## Amazon MWAA (Managed Workflows for Apache Airflow)

Amazon MWAA is a managed service for Apache Airflow, the widely-used open-source workflow orchestration platform. Use MWAA for complex DAG-based pipelines, especially when teams have Airflow experience or need features beyond Step Functions.

**📖 [Amazon MWAA User Guide](https://docs.aws.amazon.com/mwaa/latest/userguide/what-is-mwaa.html)**

### Core Apache Airflow Concepts

| Concept | Description |
|---------|-------------|
| **DAG** (Directed Acyclic Graph) | A workflow definition written in Python |
| **Task** | A single unit of work within a DAG |
| **Operator** | Defines what a task does (PythonOperator, BashOperator, GlueJobOperator, etc.) |
| **Sensor** | A special operator that waits for an external condition (S3KeySensor, ExternalTaskSensor) |
| **XCom** | Cross-communication mechanism to pass small data between tasks |
| **Connection** | Stored credentials for external systems (AWS, databases, APIs) |
| **Variable** | Stored key-value configuration accessible from any DAG |
| **Hook** | Interface to external systems used by operators (S3Hook, RedshiftHook) |

### MWAA Environment Configuration

| Setting | Description |
|---------|-------------|
| **Environment class** | mw1.small, mw1.medium, mw1.large (scheduler and worker capacity) |
| **Min/Max workers** | Auto-scaling range for Celery workers |
| **DAG source** | S3 bucket containing DAG Python files |
| **requirements.txt** | S3 file listing additional Python packages to install |
| **plugins.zip** | S3 file containing custom operators, hooks, and sensors |
| **Execution role** | IAM role used by Airflow workers to access AWS services |

**📖 [MWAA Environment Configuration](https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html)**

### DAG Example for AWS Data Pipeline

```python
from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.providers.amazon.aws.operators.athena import AthenaOperator
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-engineering',
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': True,
    'email': ['team@example.com'],
}

with DAG(
    'daily_etl_pipeline',
    default_args=default_args,
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['etl', 'production'],
) as dag:

    # Wait for source data to arrive
    wait_for_data = S3KeySensor(
        task_id='wait_for_data',
        bucket_name='raw-data',
        bucket_key='daily/{{ ds }}/_SUCCESS',
        timeout=3600,
        poke_interval=60,
    )

    # Run Glue ETL transformation
    run_glue_job = GlueJobOperator(
        task_id='run_glue_etl',
        job_name='daily-transform',
        script_args={'--date': '{{ ds }}'},
        wait_for_completion=True,
        verbose=True,
    )

    # Run data quality check via Athena
    quality_check = AthenaOperator(
        task_id='quality_check',
        query="SELECT COUNT(*) as cnt FROM processed WHERE dt = '{{ ds }}' HAVING COUNT(*) > 0",
        database='analytics_db',
        output_location='s3://query-results/quality/',
    )

    # Define task dependencies
    wait_for_data >> run_glue_job >> quality_check
```

**📖 [MWAA DAG Best Practices](https://docs.aws.amazon.com/mwaa/latest/userguide/best-practices-tuning.html)**

### Step Functions vs MWAA Comparison

| Feature | Step Functions | MWAA (Airflow) |
|---------|---------------|----------------|
| **Interface** | JSON/YAML state machine + Workflow Studio | Python DAGs + Airflow web UI |
| **AWS integration** | Native optimized integrations (200+ services) | Via Airflow AWS providers (operators/hooks) |
| **Learning curve** | Low (AWS-native concepts) | Higher (Airflow ecosystem knowledge required) |
| **Pricing** | Per state transition ($0.025/1000 transitions) | Per environment-hour ($0.49-$1.69/hr always running) |
| **Best for** | AWS-centric workflows, event-driven pipelines | Complex DAGs, existing Airflow teams, multi-cloud |
| **Error handling** | Built-in Retry/Catch states | Airflow retry, callback, and alerting mechanisms |
| **Scheduling** | External (EventBridge rules or triggers) | Built-in cron and interval scheduler |
| **Visibility** | Execution history in console | Rich Airflow UI with Gantt charts, tree views, logs |
| **Community** | AWS-specific | Large open-source Airflow community and plugins |

**Exam tip**: Choose Step Functions for AWS-native, event-driven, or simpler orchestration. Choose MWAA when you need complex dependencies, have existing Airflow DAGs, or want the Airflow ecosystem features (sensors, XComs, rich UI).

---

## Data Format Selection

Choosing the right data format directly impacts cost, performance, and flexibility, particularly with Athena and Redshift Spectrum.

### Format Comparison

| Format | Type | Splittable | Schema Evolution | Compression | Best For |
|--------|------|------------|-----------------|-------------|----------|
| **Parquet** | Columnar | Yes | Limited (add columns) | Snappy, GZIP, LZO, ZSTD | Athena, Spark, Redshift Spectrum |
| **ORC** | Columnar | Yes | Limited (add columns) | Zlib, Snappy, LZO | Hive on EMR workloads |
| **Avro** | Row-based | Yes | Strong (add/remove/rename) | Snappy, Deflate | Streaming, CDC, schema evolution |
| **JSON** | Row-based | Yes (NDJSON) | Self-describing | GZIP | APIs, semi-structured data, logs |
| **CSV** | Row-based | Yes | None | GZIP | Simple data exchange, legacy systems |

**📖 [Athena Supported Formats](https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html)**
**📖 [Glue Format Options](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-format.html)**

### Key Exam Points on Formats

- **Parquet** reduces Athena costs by up to 99% vs CSV (columnar = only scan needed columns)
- **ORC** is optimized for Hive; Parquet is more universal across AWS services
- **Avro** supports schema evolution best (adding, removing, renaming fields with compatibility checks)
- **Compression** (Snappy for speed, GZIP for ratio) further reduces storage and scan costs
- **Splittable** formats allow parallel processing; non-splittable files must be processed by one worker
- Firehose can convert JSON to Parquet or ORC using the Glue Data Catalog schema (no Lambda required)

---

## Glue Data Quality

AWS Glue Data Quality lets you define, measure, and enforce data quality rules using DQDL (Data Quality Definition Language).

**📖 [AWS Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)**

### DQDL Rule Examples

```
Rules = [
    ColumnExists "user_id",
    IsComplete "user_id",
    IsUnique "user_id",
    ColumnValues "amount" > 0,
    ColumnValues "status" in ["active", "inactive", "pending"],
    Completeness "email" > 0.95,
    RowCount between 1000 and 1000000,
    DataFreshness "updated_at" <= 24 hours
]
```

### Data Quality in Pipelines

- **Recommendations**: Glue automatically suggests quality rules based on data profiling
- **Evaluation**: Run rules as part of Glue ETL jobs or standalone
- **Actions**: Fail the job, publish metrics to CloudWatch, or quarantine bad records
- **Integration**: Embed quality checks in Step Functions or MWAA pipelines as a gate

---

## Common Exam Scenarios

1. **"Serverless ETL with incremental processing"** --> Glue ETL with job bookmarks enabled
2. **"Visual data preparation for non-developers"** --> AWS Glue DataBrew
3. **"Large-scale Spark with cost optimization"** --> Amazon EMR with task nodes on Spot Instances
4. **"Transform files as they arrive in S3"** --> Lambda triggered by S3 event notification
5. **"Orchestrate Glue, Athena, and Redshift in sequence"** --> Step Functions with `.sync` integrations
6. **"Complex DAG with sensors and scheduling"** --> Amazon MWAA (Airflow)
7. **"Convert JSON to Parquet in a streaming pipeline"** --> Firehose format conversion via Glue Data Catalog
8. **"Reduce Athena query costs"** --> Convert to Parquet + partition data + compress
9. **"Schema discovery for new S3 data"** --> Glue Crawlers with built-in classifiers
10. **"Data quality gate before loading to warehouse"** --> Glue Data Quality rules in pipeline
