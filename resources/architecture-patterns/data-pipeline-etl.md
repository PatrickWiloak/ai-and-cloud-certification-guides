# Data Pipeline ETL Architecture

A comprehensive guide to designing and implementing scalable Extract, Transform, Load (ETL) data pipelines across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Data Pipeline Patterns](#data-pipeline-patterns)
8. [Security Considerations](#security-considerations)
9. [Performance and Scalability](#performance-and-scalability)
10. [Cost Estimates](#cost-estimates)
11. [Monitoring and Data Quality](#monitoring-and-data-quality)
12. [Best Practices](#best-practices)
13. [Common Use Cases](#common-use-cases)
14. [Common Pitfalls](#common-pitfalls)

---

## Architecture Overview

### What is ETL?

ETL is a data integration process that:

1. **Extract**: Retrieves data from various sources (databases, APIs, files, streams)
2. **Transform**: Cleans, validates, enriches, and restructures data
3. **Load**: Writes processed data to target destinations (data warehouses, data lakes, databases)

### Modern Data Pipeline Characteristics

- **Scalable**: Handles growing data volumes
- **Fault-Tolerant**: Recovers from failures automatically
- **Idempotent**: Safe to retry without data duplication
- **Observable**: Comprehensive monitoring and logging
- **Schema-Aware**: Handles schema evolution gracefully
- **Cost-Efficient**: Optimizes resource utilization

### ETL vs ELT

**ETL (Extract-Transform-Load)**:
- Transform before loading
- Good for structured data
- Pre-processing required
- Traditional approach

**ELT (Extract-Load-Transform)**:
- Load raw data first, transform later
- Leverage data warehouse compute
- More flexible for ad-hoc analysis
- Modern cloud-native approach

### Use Cases

- Business intelligence and analytics
- Data warehouse consolidation
- Real-time streaming analytics
- Machine learning feature engineering
- Data lake ingestion
- Cross-system data synchronization
- Regulatory compliance and auditing
- Customer 360 views

---

## Architecture Diagram Description

### Batch Processing Pipeline

```mermaid
flowchart LR
  subgraph SRC[Sources]
    DB[(Relational DBs)]
    NOSQL[(NoSQL)]
    API[APIs]
    FILES[Files: S3 / GCS / Blob]
    SAAS[SaaS: Salesforce, HubSpot]
  end
  SRC --> EXT[Extract<br/>scheduled or CDC]
  EXT --> RAW[(Raw / staging)]
  RAW --> XF[Transform<br/>Spark / dbt / SQL]
  XF --> DQ[Data quality checks]
  DQ --> DW[(Data warehouse<br/>Snowflake / BigQuery / Redshift)]
  DW --> BI[BI / dashboards]
  DW --> ML[ML / feature store]
```

```
[Data Sources]
    |
    ├── Relational Databases (PostgreSQL, MySQL, SQL Server)
    ├── NoSQL Databases (MongoDB, Cassandra)
    ├── APIs (REST, GraphQL)
    ├── Files (S3, Blob Storage, GCS)
    └── SaaS Applications (Salesforce, HubSpot)
    |
    ↓
[Ingestion Layer]
    |
    ├── Change Data Capture (CDC)
    ├── Batch Extraction
    ├── API Polling
    └── File Upload
    |
    ↓
[Raw Data Storage]
    |
    └── Data Lake (S3/ADLS/GCS) - Raw Zone
    |
    ↓
[Orchestration]
    |
    └── Workflow Engine (Airflow, Step Functions, Data Factory)
    |
    ↓
[Transformation Layer]
    |
    ├── Data Cleaning
    ├── Validation
    ├── Enrichment
    ├── Aggregation
    └── Denormalization
    |
    ↓
[Processed Data Storage]
    |
    ├── Data Lake - Curated Zone
    └── Data Warehouse (Redshift/Synapse/BigQuery)
    |
    ↓
[Consumption Layer]
    |
    ├── BI Tools (Tableau, Power BI, Looker)
    ├── Analytics Applications
    ├── Machine Learning Models
    └── Data APIs
```

### Real-Time Streaming Pipeline

```
[Streaming Sources]
    |
    ├── IoT Devices
    ├── Application Logs
    ├── Clickstreams
    ├── CDC Streams
    └── Event Sources
    |
    ↓
[Stream Ingestion]
    |
    └── Message Broker (Kinesis/Event Hubs/Pub/Sub)
    |
    ↓
[Stream Processing]
    |
    ├── Real-time Transformations
    ├── Windowing Operations
    ├── Aggregations
    └── Enrichment
    |
    ↓
[Storage & Analytics]
    |
    ├── Real-time Dashboard
    ├── Time-Series Database
    ├── Data Warehouse (micro-batches)
    └── Alerts & Notifications
```

### Lambda Architecture (Batch + Real-Time)

```
                    [Data Sources]
                         |
        +----------------+----------------+
        |                                 |
  [Batch Layer]                    [Speed Layer]
        |                                 |
  [Batch Processing]              [Stream Processing]
        |                                 |
        ↓                                 ↓
  [Batch Views]                     [Real-time Views]
        |                                 |
        +----------------+----------------+
                         |
                   [Serving Layer]
                         |
                   [Query Interface]
                         |
                    [End Users]
```

### Data Lake Zones

```
[Bronze Zone - Raw Data]
    ↓ (Minimal Processing)
[Silver Zone - Cleaned & Validated]
    ↓ (Business Logic Applied)
[Gold Zone - Analytics-Ready]
    ↓ (Aggregated & Optimized)
[Consumption Layer]
```

---

## Component Breakdown

### Data Sources

#### Relational Databases
- **Full Load**: Complete table export
- **Incremental Load**: Load only changed records
- **Change Data Capture (CDC)**: Real-time change tracking
- **Replication**: Database replication streams

#### APIs and Web Services
- **REST APIs**: Paginated data fetching
- **GraphQL**: Selective field queries
- **Webhooks**: Event-driven data push
- **File Exports**: Scheduled exports from SaaS

#### Files
- **CSV/JSON/XML**: Structured data files
- **Parquet/Avro/ORC**: Columnar formats
- **Excel/PDF**: Document processing
- **Images/Videos**: Unstructured data

### Ingestion Tools

**AWS**:
- AWS Glue: Serverless ETL
- AWS Data Migration Service (DMS): Database replication
- AWS Transfer Family: SFTP/FTPS file transfer
- Amazon Kinesis: Streaming data ingestion
- Amazon MSK: Kafka-managed service

**Azure**:
- Azure Data Factory: Cloud ETL service
- Azure Database Migration Service: Database migration
- Azure Event Hubs: Event streaming
- Azure Stream Analytics: Real-time analytics

**GCP**:
- Cloud Data Fusion: Visual ETL builder
- Dataflow: Apache Beam pipelines
- Dataproc: Managed Spark/Hadoop
- Pub/Sub: Message streaming
- Cloud Composer: Managed Airflow

### Transformation Engines

- **Apache Spark**: Distributed processing (AWS EMR, Azure HDInsight, GCP Dataproc)
- **SQL-Based**: dbt, Matillion, stored procedures
- **Dataflow/Beam**: Unified batch and streaming
- **Custom Code**: Python, Java, Scala scripts

### Orchestration

- **Apache Airflow**: Workflow orchestration (open-source)
- **AWS Step Functions**: Serverless orchestration
- **Azure Data Factory Pipelines**: Integrated orchestration
- **GCP Cloud Composer**: Managed Airflow
- **Prefect/Dagster**: Modern orchestration frameworks

### Storage

**Data Warehouses**:
- AWS Redshift: Columnar data warehouse
- Azure Synapse Analytics: Unified analytics platform
- Google BigQuery: Serverless data warehouse
- Snowflake: Multi-cloud data warehouse

**Data Lakes**:
- AWS S3: Object storage
- Azure Data Lake Storage Gen2: Hierarchical namespace
- Google Cloud Storage: Unified object storage

---

## AWS Implementation

### Architecture Components

#### Data Ingestion (Batch)

**AWS Glue Crawler and ETL Job**:

```python
# glue_etl_job.py
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read from data source
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="source_db",
    table_name="customers",
    transformation_ctx="datasource"
)

# Apply transformations
# 1. Drop null records
dropnullfields = DropNullFields.apply(
    frame=datasource,
    transformation_ctx="dropnullfields"
)

# 2. Map fields
applymapping = ApplyMapping.apply(
    frame=dropnullfields,
    mappings=[
        ("customer_id", "string", "customer_id", "string"),
        ("first_name", "string", "first_name", "string"),
        ("last_name", "string", "last_name", "string"),
        ("email", "string", "email", "string"),
        ("created_date", "string", "created_date", "timestamp"),
        ("country", "string", "country", "string")
    ],
    transformation_ctx="applymapping"
)

# 3. Resolve choice (for columns with multiple types)
resolvechoice = ResolveChoice.apply(
    frame=applymapping,
    choice="make_struct",
    transformation_ctx="resolvechoice"
)

# Convert to Spark DataFrame for custom transformations
df = resolvechoice.toDF()

# Custom transformations
from pyspark.sql.functions import col, when, upper, regexp_replace

df_transformed = df \
    .withColumn("email", regexp_replace(col("email"), r"^\s+|\s+$", "")) \
    .withColumn("email", lower(col("email"))) \
    .withColumn("full_name", concat(col("first_name"), lit(" "), col("last_name"))) \
    .withColumn("country_code", upper(col("country"))) \
    .withColumn("is_valid_email", col("email").rlike(r"^[\w\.-]+@[\w\.-]+\.\w+$"))

# Filter invalid records
df_valid = df_transformed.filter(col("is_valid_email") == True)

# Convert back to DynamicFrame
dynamic_frame_write = DynamicFrame.fromDF(df_valid, glueContext, "dynamic_frame_write")

# Write to S3 in Parquet format
datasink = glueContext.write_dynamic_frame.from_options(
    frame=dynamic_frame_write,
    connection_type="s3",
    connection_options={
        "path": "s3://my-data-lake/curated/customers/",
        "partitionKeys": ["country_code"]
    },
    format="parquet",
    transformation_ctx="datasink"
)

job.commit()
```

#### Data Ingestion (Streaming)

**Kinesis Data Streams to Firehose to S3**:

```python
# lambda_kinesis_processor.py
import json
import base64
import boto3

def lambda_handler(event, context):
    output = []

    for record in event['records']:
        # Decode base64
        payload = base64.b64decode(record['data']).decode('utf-8')
        data = json.loads(payload)

        # Transform data
        transformed_data = {
            'timestamp': data['timestamp'],
            'user_id': data['user_id'],
            'event_type': data['event_type'],
            'event_data': data.get('event_data', {}),
            'processed_at': context.invoked_function_arn
        }

        # Encode back to base64
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': base64.b64encode(
                json.dumps(transformed_data).encode('utf-8')
            ).decode('utf-8')
        }
        output.append(output_record)

    return {'records': output}
```

#### Orchestration (Step Functions)

```json
{
  "Comment": "ETL Pipeline Orchestration",
  "StartAt": "StartCrawler",
  "States": {
    "StartCrawler": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startCrawler",
      "Parameters": {
        "Name": "source-data-crawler"
      },
      "Next": "WaitForCrawler"
    },
    "WaitForCrawler": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "CheckCrawlerStatus"
    },
    "CheckCrawlerStatus": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:getCrawler",
      "Parameters": {
        "Name": "source-data-crawler"
      },
      "Next": "IsCrawlerComplete"
    },
    "IsCrawlerComplete": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.Crawler.State",
          "StringEquals": "READY",
          "Next": "RunGlueJob"
        }
      ],
      "Default": "WaitForCrawler"
    },
    "RunGlueJob": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "customer-etl-job"
      },
      "Next": "LoadToRedshift"
    },
    "LoadToRedshift": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "redshift-loader",
        "Payload": {
          "source": "s3://my-data-lake/curated/customers/",
          "target_table": "customers"
        }
      },
      "Next": "DataQualityChecks"
    },
    "DataQualityChecks": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "data-quality-validator"
      },
      "Next": "Success"
    },
    "Success": {
      "Type": "Succeed"
    }
  }
}
```

#### Infrastructure as Code (Terraform)

```hcl
# AWS ETL Pipeline Infrastructure

# S3 Data Lake Buckets
resource "aws_s3_bucket" "data_lake_raw" {
  bucket = "my-data-lake-raw"

  tags = {
    Environment = "production"
    Zone        = "bronze"
  }
}

resource "aws_s3_bucket" "data_lake_curated" {
  bucket = "my-data-lake-curated"

  tags = {
    Environment = "production"
    Zone        = "silver"
  }
}

# Glue Database
resource "aws_glue_catalog_database" "source_db" {
  name = "source_database"
}

# Glue Crawler
resource "aws_glue_crawler" "source_crawler" {
  name          = "source-data-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.source_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.data_lake_raw.bucket}/customers/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "LOG"
  }

  schedule = "cron(0 0 * * ? *)"
}

# Glue ETL Job
resource "aws_glue_job" "etl_job" {
  name     = "customer-etl-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://my-scripts-bucket/glue_etl_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                          = "s3://my-temp-bucket/glue-temp/"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-spark-ui"                  = "true"
    "--spark-event-logs-path"            = "s3://my-logs-bucket/spark-logs/"
  }

  max_retries       = 1
  timeout           = 60
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 10
}

# Kinesis Data Stream
resource "aws_kinesis_stream" "events_stream" {
  name             = "events-stream"
  shard_count      = 2
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Environment = "production"
  }
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "s3_stream" {
  name        = "events-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.data_lake_raw.arn
    prefix     = "events/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"

    buffering_size     = 5
    buffering_interval = 300

    compression_format = "GZIP"

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.stream_processor.arn
        }
      }
    }

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_database.source_db.name
        table_name    = "events"
        role_arn      = aws_iam_role.firehose_role.arn
      }
    }
  }
}

# Redshift Cluster
resource "aws_redshift_cluster" "analytics_cluster" {
  cluster_identifier = "analytics-cluster"
  database_name      = "analytics"
  master_username    = "admin"
  master_password    = random_password.redshift_password.result
  node_type          = "dc2.large"
  number_of_nodes    = 2

  cluster_subnet_group_name    = aws_redshift_subnet_group.main.name
  vpc_security_group_ids       = [aws_security_group.redshift.id]
  iam_roles                    = [aws_iam_role.redshift_role.arn]
  encrypted                    = true
  kms_key_id                   = aws_kms_key.redshift.arn
  automated_snapshot_retention_period = 7

  tags = {
    Environment = "production"
  }
}

# Step Functions State Machine
resource "aws_sfn_state_machine" "etl_pipeline" {
  name     = "etl-pipeline"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = file("${path.module}/step_functions_definition.json")

  tags = {
    Environment = "production"
  }
}

# EventBridge Rule (Daily Schedule)
resource "aws_cloudwatch_event_rule" "daily_etl" {
  name                = "daily-etl-schedule"
  description         = "Trigger ETL pipeline daily at 2 AM UTC"
  schedule_expression = "cron(0 2 * * ? *)"
}

resource "aws_cloudwatch_event_target" "etl_pipeline" {
  rule      = aws_cloudwatch_event_rule.daily_etl.name
  target_id = "ETLPipeline"
  arn       = aws_sfn_state_machine.etl_pipeline.arn
  role_arn  = aws_iam_role.eventbridge_role.arn
}
```

### AWS Cost Breakdown (Monthly)

**Assumptions**:
- 100 GB daily data ingestion (3 TB/month)
- 2-hour daily Glue job (dc2.large instances)
- Redshift cluster (2 x dc2.large nodes)
- Kinesis stream (2 shards, 1 million records/day)

#### Storage
- **S3 Data Lake**: 10 TB total
  - Standard tier: $0.023/GB × 10,240 GB = $235.52
  - Glacier for archives: 5 TB × $0.004/GB × 5,120 GB = $20.48

#### Compute (Batch Processing)
- **Glue ETL**: 2 hours/day, 10 DPUs
  - $0.44/DPU-hour × 10 DPUs × 2 hours × 30 days = $264
- **Glue Crawler**: 10 minutes/day
  - $0.44/DPU-hour × 2 DPUs × 0.167 hours × 30 days = $4.40

#### Data Warehouse
- **Redshift**: 2 × dc2.large nodes
  - $0.25/hour × 2 nodes × 730 hours = $365
- **Redshift Storage**: 1 TB
  - Included in compute cost

#### Streaming
- **Kinesis Data Streams**: 2 shards
  - $0.015/shard-hour × 2 × 730 hours = $21.90
  - PUT payload units: $0.014/million × 30 million = $0.42
- **Kinesis Firehose**:
  - Data ingested: $0.029/GB × 100 GB/day × 30 days = $87

#### Orchestration
- **Step Functions**: 100 executions/day
  - $0.025/1000 state transitions × 6 transitions × 100 × 30 = $4.50

#### Data Transfer
- **Inter-region**: Minimal (same region architecture)
- **S3 to Redshift**: Free (same region)

**Total Monthly Cost (AWS): ~$1,003**

---

## Azure Implementation

### Architecture Components

#### Data Factory Pipeline

```json
{
  "name": "CustomerETLPipeline",
  "properties": {
    "activities": [
      {
        "name": "CopyFromSQL",
        "type": "Copy",
        "inputs": [
          {
            "referenceName": "SourceSQLDataset",
            "type": "DatasetReference"
          }
        ],
        "outputs": [
          {
            "referenceName": "ADLSRawDataset",
            "type": "DatasetReference"
          }
        ],
        "typeProperties": {
          "source": {
            "type": "SqlSource",
            "sqlReaderQuery": "SELECT * FROM customers WHERE updated_date > '@{pipeline().parameters.watermark}'"
          },
          "sink": {
            "type": "ParquetSink",
            "storeSettings": {
              "type": "AzureBlobFSWriteSettings"
            },
            "formatSettings": {
              "type": "ParquetWriteSettings"
            }
          }
        }
      },
      {
        "name": "TransformData",
        "type": "DatabricksNotebook",
        "dependsOn": [
          {
            "activity": "CopyFromSQL",
            "dependencyConditions": ["Succeeded"]
          }
        ],
        "typeProperties": {
          "notebookPath": "/ETL/customer_transformation",
          "baseParameters": {
            "input_path": "abfss://raw@mydatalake.dfs.core.windows.net/customers/",
            "output_path": "abfss://curated@mydatalake.dfs.core.windows.net/customers/"
          }
        }
      },
      {
        "name": "LoadToSynapse",
        "type": "Copy",
        "dependsOn": [
          {
            "activity": "TransformData",
            "dependencyConditions": ["Succeeded"]
          }
        ],
        "inputs": [
          {
            "referenceName": "ADLSCuratedDataset",
            "type": "DatasetReference"
          }
        ],
        "outputs": [
          {
            "referenceName": "SynapseDataset",
            "type": "DatasetReference"
          }
        ],
        "typeProperties": {
          "source": {
            "type": "ParquetSource"
          },
          "sink": {
            "type": "SqlDWSink",
            "preCopyScript": "TRUNCATE TABLE staging.customers"
          },
          "enableStaging": true,
          "stagingSettings": {
            "linkedServiceName": {
              "referenceName": "AzureBlobStorage",
              "type": "LinkedServiceReference"
            },
            "path": "staging"
          }
        }
      }
    ],
    "parameters": {
      "watermark": {
        "type": "String",
        "defaultValue": "1900-01-01"
      }
    }
  }
}
```

#### Databricks Transformation Notebook

```python
# Databricks notebook
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, lower, upper, concat, lit, regexp_replace
from delta.tables import DeltaTable

# Get parameters
dbutils.widgets.text("input_path", "")
dbutils.widgets.text("output_path", "")

input_path = dbutils.widgets.get("input_path")
output_path = dbutils.widgets.get("output_path")

# Read data
df = spark.read.parquet(input_path)

# Transformations
df_transformed = df \
    .withColumn("email", regexp_replace(lower(col("email")), r"^\s+|\s+$", "")) \
    .withColumn("full_name", concat(col("first_name"), lit(" "), col("last_name"))) \
    .withColumn("country_code", upper(col("country"))) \
    .withColumn("is_valid_email", col("email").rlike(r"^[\w\.-]+@[\w\.-]+\.\w+$")) \
    .filter(col("is_valid_email") == True) \
    .drop("is_valid_email")

# Write as Delta table with merge logic
if DeltaTable.isDeltaTable(spark, output_path):
    delta_table = DeltaTable.forPath(spark, output_path)

    delta_table.alias("target").merge(
        df_transformed.alias("source"),
        "target.customer_id = source.customer_id"
    ).whenMatchedUpdateAll().whenNotMatchedInsertAll().execute()
else:
    df_transformed.write.format("delta").partitionBy("country_code").save(output_path)

print(f"Processed {df_transformed.count()} records")
```

#### Infrastructure as Code (Bicep)

```bicep
// Azure Data Pipeline Infrastructure

param location string = resourceGroup().location
param dataLakeName string = 'mydatalake${uniqueString(resourceGroup().id)}'

// Data Lake Storage Gen2
resource dataLake 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: dataLakeName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// Containers
resource rawContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${dataLake.name}/default/raw'
  properties: {
    publicAccess: 'None'
  }
}

resource curatedContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${dataLake.name}/default/curated'
  properties: {
    publicAccess: 'None'
  }
}

// Azure Synapse Workspace
resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: 'synapse-${uniqueString(resourceGroup().id)}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: dataLake.properties.primaryEndpoints.dfs
      filesystem: 'synapse'
    }
    sqlAdministratorLogin: 'sqladmin'
    sqlAdministratorLoginPassword: 'P@ssw0rd123!'
  }
}

// Dedicated SQL Pool
resource sqlPool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  parent: synapseWorkspace
  name: 'analytics_pool'
  location: location
  sku: {
    name: 'DW200c'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 263882790666240
    storageAccountType: 'LRS'
  }
}

// Data Factory
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'adf-${uniqueString(resourceGroup().id)}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

// Event Hub Namespace (for streaming)
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: 'events-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    zoneRedundant: true
  }
}

// Event Hub
resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  parent: eventHubNamespace
  name: 'clickstream'
  properties: {
    messageRetentionInDays: 1
    partitionCount: 4
  }
}

// Databricks Workspace
resource databricksWorkspace 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
  name: 'databricks-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'premium'
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', 'databricks-managed-rg')
  }
}
```

### Azure Cost Breakdown (Monthly)

**Same assumptions as AWS**

#### Storage
- **Data Lake Storage Gen2**: 10 TB
  - Hot tier: $0.018/GB × 10,240 GB = $184.32
  - Archive tier: 5 TB × $0.002/GB × 5,120 GB = $10.24

#### Compute
- **Data Factory**:
  - Pipeline orchestration: $1 per 1,000 runs × 0.1 = $0.10
  - Data movement: $0.25 per DIU-hour × 4 DIU × 2 hours × 30 = $60
- **Databricks** (Standard, 2 workers):
  - DBU cost: $0.15/DBU × 2 workers × 4 DBU × 2 hours × 30 = $144
  - VM cost: $0.14/hour × 2 VMs × 2 hours × 30 = $16.80

#### Data Warehouse
- **Synapse Dedicated SQL Pool**: DW200c
  - $1.50/hour × 730 hours = $1,095 (paused when not in use)
  - Realistic with pause: $1.50/hour × 8 hours/day × 30 days = $360

#### Streaming
- **Event Hubs**: Standard tier, 2 TUs
  - $0.028/hour × 2 TUs × 730 hours = $40.88
  - Ingress: $0.028 per million events × 30 million = $0.84

**Total Monthly Cost (Azure): ~$817**

---

## GCP Implementation

### Architecture Components

#### Cloud Composer (Airflow) DAG

```python
# gcp_etl_dag.py
from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import (
    BigQueryCreateEmptyTableOperator,
    BigQueryInsertJobOperator,
)
from airflow.providers.google.cloud.operators.gcs import GCSToGCSOperator
from airflow.providers.google.cloud.operators.dataflow import DataflowStartFlexTemplateOperator
from airflow.providers.google.cloud.sensors.gcs import GCSObjectExistenceSensor
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'customer_etl_pipeline',
    default_args=default_args,
    description='Customer data ETL pipeline',
    schedule_interval='0 2 * * *',
    catchup=False,
    tags=['etl', 'customers'],
)

# Check if source files exist
check_source_files = GCSObjectExistenceSensor(
    task_id='check_source_files',
    bucket='my-raw-data-bucket',
    object='customers/{{ ds }}/*.csv',
    google_cloud_conn_id='google_cloud_default',
    dag=dag,
)

# Run Dataflow job for transformation
transform_data = DataflowStartFlexTemplateOperator(
    task_id='transform_data',
    project_id='my-gcp-project',
    location='us-central1',
    body={
        'launchParameter': {
            'containerSpecGcsPath': 'gs://my-templates/customer-transform',
            'jobName': 'customer-transform-{{ ds_nodash }}',
            'parameters': {
                'input': 'gs://my-raw-data-bucket/customers/{{ ds }}/',
                'output': 'gs://my-processed-data-bucket/customers/{{ ds }}/',
            },
            'environment': {
                'maxWorkers': '10',
                'serviceAccountEmail': 'dataflow-sa@my-gcp-project.iam.gserviceaccount.com',
            },
        },
    },
    dag=dag,
)

# Load to BigQuery
load_to_bigquery = BigQueryInsertJobOperator(
    task_id='load_to_bigquery',
    configuration={
        'load': {
            'sourceUris': ['gs://my-processed-data-bucket/customers/{{ ds }}/*.parquet'],
            'destinationTable': {
                'projectId': 'my-gcp-project',
                'datasetId': 'analytics',
                'tableId': 'customers',
            },
            'sourceFormat': 'PARQUET',
            'writeDisposition': 'WRITE_TRUNCATE',
            'createDisposition': 'CREATE_IF_NEEDED',
            'autodetect': True,
        }
    },
    dag=dag,
)

# Data quality checks
def data_quality_checks(**context):
    from google.cloud import bigquery
    client = bigquery.Client()

    # Check row count
    query = """
        SELECT COUNT(*) as row_count
        FROM `my-gcp-project.analytics.customers`
        WHERE DATE(_PARTITIONTIME) = '{{ ds }}'
    """
    result = client.query(query).result()
    row_count = list(result)[0]['row_count']

    if row_count < 1000:
        raise ValueError(f"Row count too low: {row_count}")

    # Check for nulls in critical fields
    null_check_query = """
        SELECT
            COUNTIF(customer_id IS NULL) as null_ids,
            COUNTIF(email IS NULL) as null_emails
        FROM `my-gcp-project.analytics.customers`
        WHERE DATE(_PARTITIONTIME) = '{{ ds }}'
    """
    result = client.query(null_check_query).result()
    null_counts = list(result)[0]

    if null_counts['null_ids'] > 0 or null_counts['null_emails'] > 0:
        raise ValueError(f"Null values found: {null_counts}")

    print(f"Data quality checks passed: {row_count} rows processed")

quality_checks = PythonOperator(
    task_id='data_quality_checks',
    python_callable=data_quality_checks,
    provide_context=True,
    dag=dag,
)

# Set dependencies
check_source_files >> transform_data >> load_to_bigquery >> quality_checks
```

#### Dataflow Pipeline (Apache Beam)

```python
# dataflow_transform.py
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io import ReadFromText, WriteToParquet
import json
import re

class TransformCustomerData(beam.DoFn):
    def process(self, element):
        # Parse CSV
        fields = element.split(',')

        if len(fields) < 6:
            return  # Skip invalid rows

        customer = {
            'customer_id': fields[0].strip(),
            'first_name': fields[1].strip(),
            'last_name': fields[2].strip(),
            'email': fields[3].strip().lower(),
            'country': fields[4].strip(),
            'created_date': fields[5].strip(),
        }

        # Validate email
        email_pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
        if not re.match(email_pattern, customer['email']):
            return  # Skip invalid emails

        # Add computed fields
        customer['full_name'] = f"{customer['first_name']} {customer['last_name']}"
        customer['country_code'] = customer['country'].upper()

        yield customer

def run_pipeline(input_path, output_path, pipeline_args):
    pipeline_options = PipelineOptions(pipeline_args)

    with beam.Pipeline(options=pipeline_options) as pipeline:
        (
            pipeline
            | 'Read CSV' >> ReadFromText(input_path, skip_header_lines=1)
            | 'Transform' >> beam.ParDo(TransformCustomerData())
            | 'Write Parquet' >> WriteToParquet(
                output_path,
                schema={
                    'customer_id': 'str',
                    'first_name': 'str',
                    'last_name': 'str',
                    'full_name': 'str',
                    'email': 'str',
                    'country': 'str',
                    'country_code': 'str',
                    'created_date': 'str',
                },
            )
        )

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)

    known_args, pipeline_args = parser.parse_known_args()

    run_pipeline(known_args.input, known_args.output, pipeline_args)
```

#### Infrastructure as Code (Terraform)

```hcl
# GCP Data Pipeline Infrastructure

# Cloud Storage Buckets
resource "google_storage_bucket" "raw_data" {
  name          = "my-raw-data-bucket"
  location      = "US"
  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
}

resource "google_storage_bucket" "processed_data" {
  name          = "my-processed-data-bucket"
  location      = "US"
  storage_class = "STANDARD"
}

# BigQuery Dataset
resource "google_bigquery_dataset" "analytics" {
  dataset_id  = "analytics"
  description = "Analytics data warehouse"
  location    = "US"

  default_table_expiration_ms = 31536000000  # 1 year

  labels = {
    environment = "production"
  }
}

# BigQuery Table
resource "google_bigquery_table" "customers" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = "customers"

  time_partitioning {
    type  = "DAY"
    field = "created_date"
  }

  clustering = ["country_code"]

  schema = <<EOF
[
  {
    "name": "customer_id",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "first_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "last_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "full_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "email",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "country",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "country_code",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "created_date",
    "type": "DATE",
    "mode": "REQUIRED"
  }
]
EOF
}

# Pub/Sub Topic (for streaming)
resource "google_pubsub_topic" "events" {
  name = "events-topic"

  message_retention_duration = "86400s"  # 1 day
}

# Pub/Sub Subscription
resource "google_pubsub_subscription" "events_sub" {
  name  = "events-subscription"
  topic = google_pubsub_topic.events.name

  ack_deadline_seconds = 20

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }
}

# Cloud Composer (Airflow)
resource "google_composer_environment" "etl_orchestration" {
  name   = "etl-composer"
  region = "us-central1"

  config {
    software_config {
      image_version = "composer-2-airflow-2"

      pypi_packages = {
        "apache-airflow-providers-google" = ">=8.0.0"
      }

      env_variables = {
        ENVIRONMENT = "production"
      }
    }

    node_config {
      service_account = google_service_account.composer_sa.email
    }

    workloads_config {
      scheduler {
        cpu        = 2
        memory_gb  = 4
        storage_gb = 10
        count      = 1
      }
      web_server {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 10
      }
      worker {
        cpu        = 2
        memory_gb  = 4
        storage_gb = 10
        min_count  = 1
        max_count  = 3
      }
    }
  }
}

# Dataflow Flex Template
resource "google_storage_bucket_object" "dataflow_template" {
  name   = "templates/customer-transform"
  bucket = google_storage_bucket.processed_data.name
  source = "dataflow_template.json"
}
```

### GCP Cost Breakdown (Monthly)

**Same assumptions as AWS and Azure**

#### Storage
- **Cloud Storage**: 10 TB total
  - Standard: $0.020/GB × 10,240 GB = $204.80
  - Nearline (archives): 5 TB × $0.010/GB × 5,120 GB = $51.20

#### Compute
- **Dataflow**: 2 hours/day, 10 workers (n1-standard-4)
  - $0.056/vCPU-hour × 4 vCPUs × 10 workers × 2 hours × 30 days = $1,344
  - Dataflow service cost: $0.013/vCPU-hour × 4 × 10 × 2 × 30 = $312
  - With committed use discount (-30%): ~$1,159

#### Data Warehouse
- **BigQuery**:
  - Storage: 1 TB × $0.020/GB × 1,024 GB = $20.48
  - Queries: 5 TB processed/month × $5/TB = $25
  - Streaming inserts: 1 GB/day × $0.05/GB × 30 = $1.50

#### Orchestration
- **Cloud Composer**: Small environment
  - $300/month base (includes managed Airflow + GKE cluster)

#### Streaming
- **Pub/Sub**:
  - Data ingested: $0.06/GB × 100 GB/day × 30 days = $180
  - Streaming egress: Included

**Total Monthly Cost (GCP): ~$2,238**

*Note: GCP Dataflow can be expensive for long-running jobs. Consider BigQuery Dataproc for cost optimization.*

**Optimized GCP Cost (using Dataproc instead of Dataflow): ~$950**

---

## Data Pipeline Patterns

### 1. Full Load Pattern
- Complete table extraction
- Replace entire target dataset
- Simple but resource-intensive
- Use for small, frequently changing datasets

### 2. Incremental Load Pattern
- Load only new/changed records
- Track watermark (timestamp, ID)
- Efficient for large datasets
- Requires tracking mechanism

### 3. CDC (Change Data Capture)
- Real-time capture of database changes
- Log-based or trigger-based
- Low latency data replication
- Tools: Debezium, AWS DMS, Azure DMS

### 4. Lambda Architecture
- Batch layer: Complete, accurate historical data
- Speed layer: Real-time approximate data
- Serving layer: Merge both views
- Complex but comprehensive

### 5. Kappa Architecture
- Everything is a stream
- Simplified Lambda (no batch layer)
- Real-time processing only
- Replayable streams for corrections

### 6. Medallion Architecture (Databricks)
- Bronze: Raw data (as-is)
- Silver: Cleaned and validated
- Gold: Business-level aggregates
- Progressive data refinement

---

## Security Considerations

### Data Encryption

#### At Rest
- Encrypt all data stores (S3, ADLS, GCS)
- Use customer-managed keys (CMK) for compliance
- Encrypt databases and data warehouses
- Enable encryption for backups

#### In Transit
- TLS/SSL for all data transfers
- VPN or private endpoints for on-premises connectivity
- Encrypted connections to databases
- Secure API authentication

### Access Control

#### IAM and RBAC
- Principle of least privilege
- Service accounts for applications
- Separate roles for read/write/admin
- Regular access reviews

#### Network Security
- Private subnets for processing
- VPC/VNet isolation
- Security groups/firewall rules
- NAT gateways for outbound only

### Data Governance

#### Data Classification
- PII identification and masking
- Sensitive data encryption
- Data lineage tracking
- Retention policies

#### Compliance
- GDPR, CCPA, HIPAA considerations
- Audit logging enabled
- Data residency requirements
- Right to deletion support

---

## Performance and Scalability

### Optimization Techniques

#### Partitioning
- Time-based partitioning (common for logs, events)
- Range partitioning (numerical data)
- Hash partitioning (even distribution)
- Benefits: Faster queries, easier maintenance

#### Compression
- Reduce storage costs (70-90% reduction)
- Faster I/O (less data to read)
- Formats: Parquet (columnar), ORC, Avro
- Trade-off: CPU overhead for compression/decompression

#### Columnar Storage
- Parquet, ORC for analytics workloads
- Query only needed columns
- Better compression ratios
- Ideal for data warehouses

#### Caching
- Cache frequently accessed data
- Reduce redundant computations
- Tools: Redis, Memcached, built-in warehouse caching

### Scaling Strategies

#### Horizontal Scaling
- Add more worker nodes
- Distribute data processing
- Auto-scaling based on load

#### Vertical Scaling
- Increase instance sizes
- More memory for large joins
- Limited by instance type maximums

#### Parallel Processing
- Spark, Dataflow parallelize automatically
- Partition data for parallel reads
- Tune parallelism parameters

---

## Monitoring and Data Quality

### Pipeline Monitoring

#### Key Metrics
- **Pipeline Success Rate**: % of successful runs
- **Duration**: Time to complete
- **Data Volume**: Records processed
- **Error Rate**: Failed records
- **Resource Utilization**: CPU, memory, I/O
- **Cost per Run**: Track spending

#### Alerting
- Pipeline failures
- SLA breaches (long-running jobs)
- Data quality issues
- Cost anomalies

### Data Quality Framework

#### Data Quality Dimensions
1. **Completeness**: All expected data present
2. **Accuracy**: Data matches source of truth
3. **Consistency**: Data consistent across systems
4. **Timeliness**: Data available when needed
5. **Validity**: Data conforms to business rules
6. **Uniqueness**: No duplicate records

#### Quality Checks

```python
# Example data quality checks
def data_quality_checks(df):
    checks = []

    # Check 1: Row count
    row_count = df.count()
    checks.append({
        'check': 'row_count',
        'value': row_count,
        'passed': row_count > 1000
    })

    # Check 2: Null values in critical columns
    null_counts = df.select([
        count(when(col(c).isNull(), c)).alias(c)
        for c in ['customer_id', 'email']
    ]).collect()[0].asDict()

    checks.append({
        'check': 'null_critical_fields',
        'value': null_counts,
        'passed': all(v == 0 for v in null_counts.values())
    })

    # Check 3: Email format validation
    valid_email_count = df.filter(
        col('email').rlike(r'^[\w\.-]+@[\w\.-]+\.\w+$')
    ).count()
    checks.append({
        'check': 'email_format',
        'value': f'{valid_email_count}/{row_count}',
        'passed': valid_email_count / row_count > 0.95
    })

    # Check 4: Duplicate detection
    duplicate_count = df.groupBy('customer_id').count().filter('count > 1').count()
    checks.append({
        'check': 'duplicates',
        'value': duplicate_count,
        'passed': duplicate_count == 0
    })

    return checks
```

---

## Best Practices

### Design Principles

1. **Idempotency**: Rerunning produces same result
2. **Fault Tolerance**: Graceful handling of failures
3. **Backfill Capability**: Reprocess historical data
4. **Incremental Processing**: Avoid full reloads
5. **Schema Evolution**: Handle schema changes
6. **Data Lineage**: Track data provenance
7. **Testing**: Unit test transformations
8. **Documentation**: Document pipeline logic

### Code Organization

```
data-pipeline/
├── dags/                    # Airflow DAGs
│   ├── customer_etl.py
│   └── orders_etl.py
├── transformations/         # Transformation logic
│   ├── customers.py
│   ├── orders.py
│   └── utils.py
├── sql/                     # SQL scripts
│   ├── staging/
│   └── prod/
├── tests/                   # Unit tests
│   ├── test_customers.py
│   └── test_orders.py
├── config/                  # Configuration
│   ├── dev.yaml
│   └── prod.yaml
└── README.md
```

### Testing Strategy

```python
# Example unit test for transformation
import pytest
from transformations.customers import transform_customer_data

def test_email_lowercase():
    input_data = [{'email': 'Test@EXAMPLE.com'}]
    result = transform_customer_data(input_data)
    assert result[0]['email'] == 'test@example.com'

def test_invalid_email_filtered():
    input_data = [
        {'email': 'valid@example.com'},
        {'email': 'invalid'},
    ]
    result = transform_customer_data(input_data)
    assert len(result) == 1
    assert result[0]['email'] == 'valid@example.com'
```

---

## Common Use Cases

### 1. Customer 360 View
- Consolidate data from CRM, support, sales, marketing
- Unified customer profile
- Enable personalization

### 2. Real-Time Analytics
- Stream processing of clickstream, IoT, logs
- Dashboards with sub-second latency
- Anomaly detection

### 3. Data Lake Ingestion
- Ingest all raw data to data lake
- Transform on-demand (ELT approach)
- Enable data science and ML

### 4. Regulatory Reporting
- Aggregate transactional data
- Ensure data quality and compliance
- Audit trail and lineage

### 5. ML Feature Engineering
- Transform raw data into ML features
- Real-time feature serving
- Feature stores

---

## Common Pitfalls

1. **No Incremental Loading**: Full loads waste resources
2. **Ignoring Data Quality**: Garbage in, garbage out
3. **No Monitoring**: Failures go unnoticed
4. **Poor Error Handling**: Pipelines fail silently
5. **No Backfill Strategy**: Can't reprocess historical data
6. **Tight Coupling**: Hard to change or maintain
7. **No Schema Management**: Breaking changes cause failures
8. **Insufficient Testing**: Issues in production
9. **Ignoring Costs**: Runaway spending
10. **No Documentation**: Tribal knowledge

---

## Conclusion

Building scalable, reliable data pipelines requires careful design, appropriate technology choices, and adherence to best practices. Whether you're implementing batch ETL, real-time streaming, or hybrid architectures, focus on:

- **Reliability**: Fault-tolerant, idempotent, well-tested
- **Scalability**: Handle growing data volumes
- **Observability**: Comprehensive monitoring and alerting
- **Data Quality**: Validate and ensure accuracy
- **Cost Efficiency**: Optimize resource utilization
- **Security**: Encrypt, control access, comply with regulations

By following the patterns and practices outlined in this guide, you can build robust data pipelines that power analytics, machine learning, and business intelligence across your organization.

---

**Document Version**: 1.0
**Last Updated**: 2024-10-13
**Author**: Cloud Architecture Team
