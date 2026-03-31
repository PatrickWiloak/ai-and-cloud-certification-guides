# Hands-On Project: Build a Data Pipeline

Build an end-to-end ETL/ELT pipeline from data ingestion to warehouse.

**Estimated Time:** 4-5 hours
**Difficulty:** Intermediate to Advanced
**Prerequisites:** SQL knowledge, basic Python, a cloud account

---

## Architecture Overview

```
Data Sources              Transform                    Load
  |                         |                           |
  +-- API (REST)            +-- Spark/SQL              +-- Data Warehouse
  +-- Database (CDC)        +-- Data quality checks    +-- Dashboard
  +-- Files (CSV/JSON)      +-- Schema validation      +-- ML features
  |                         |                           |
  v                         v                           v
[Ingestion Layer]     [Processing Layer]         [Storage Layer]

Cloud Options:
  AWS:   Kinesis/S3 --> Glue --> Redshift/Athena
  Azure: Event Hub/Blob --> Data Factory --> Synapse
  GCP:   Pub/Sub/GCS --> Dataflow --> BigQuery
```

---

## Step 1: Set Up Data Source

### Option A: REST API Ingestion

```python
# ingest_api.py
import requests
import json
import boto3  # or google.cloud.storage, azure.storage.blob
from datetime import datetime

def ingest_from_api():
    """Fetch data from a REST API and store as JSON in cloud storage."""
    url = "https://api.example.com/v1/data"
    headers = {"Authorization": "Bearer YOUR_TOKEN"}

    response = requests.get(url, headers=headers)
    response.raise_for_status()
    data = response.json()

    # Add metadata
    payload = {
        "ingested_at": datetime.utcnow().isoformat(),
        "source": "api.example.com",
        "record_count": len(data["results"]),
        "data": data["results"]
    }

    # Store in S3 (raw zone)
    s3 = boto3.client("s3")
    key = f"raw/api-data/{datetime.utcnow().strftime('%Y/%m/%d/%H%M%S')}.json"
    s3.put_object(
        Bucket="my-data-lake",
        Key=key,
        Body=json.dumps(payload),
        ContentType="application/json"
    )
    return key
```

### Option B: Database CDC (Change Data Capture)

**AWS DMS (Database Migration Service)**
```bash
aws dms create-replication-task \
  --replication-task-identifier cdc-task \
  --source-endpoint-arn arn:aws:dms:xxx:endpoint:source \
  --target-endpoint-arn arn:aws:dms:xxx:endpoint:target \
  --migration-type cdc \
  --table-mappings file://table-mappings.json \
  --replication-task-settings file://task-settings.json
```

### Data Lake Storage Layout

```
s3://my-data-lake/
  raw/                    # Raw ingested data (immutable)
    api-data/
      2024/01/15/
    database-cdc/
      orders/
  staging/                # Cleaned and validated data
    orders/
  curated/                # Business-ready datasets
    daily-metrics/
    customer-360/
```

---

## Step 2: Transform with AWS Glue

### Glue ETL Job

```python
# glue_transform.py
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from pyspark.sql import functions as F

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
job.init(args["JOB_NAME"], args)

# Read raw data
raw_df = spark.read.json("s3://my-data-lake/raw/api-data/2024/01/15/")

# Transform
transformed_df = (
    raw_df
    .select(F.explode("data").alias("record"))
    .select(
        F.col("record.id").alias("record_id"),
        F.col("record.name").alias("name"),
        F.col("record.amount").cast("decimal(10,2)").alias("amount"),
        F.to_timestamp("record.created_at").alias("created_at"),
        F.current_timestamp().alias("processed_at")
    )
    .filter(F.col("amount").isNotNull())
    .dropDuplicates(["record_id"])
)

# Write to staging
transformed_df.write \
    .mode("overwrite") \
    .partitionBy("created_at") \
    .parquet("s3://my-data-lake/staging/records/")

job.commit()
```

### Create Glue Job

```bash
aws glue create-job \
  --name transform-api-data \
  --role arn:aws:iam::123456789012:role/GlueServiceRole \
  --command '{"Name": "glueetl", "ScriptLocation": "s3://my-scripts/glue_transform.py", "PythonVersion": "3"}' \
  --default-arguments '{"--TempDir": "s3://my-data-lake/temp/", "--enable-metrics": "true"}'
```

---

## Step 3: Transform with Azure Data Factory

### Pipeline Configuration

```json
{
  "name": "TransformPipeline",
  "properties": {
    "activities": [
      {
        "name": "CopyFromSource",
        "type": "Copy",
        "inputs": [{"referenceName": "SourceDataset"}],
        "outputs": [{"referenceName": "StagingDataset"}],
        "typeProperties": {
          "source": {"type": "RestSource", "httpRequestTimeout": "00:01:00"},
          "sink": {"type": "ParquetSink"}
        }
      },
      {
        "name": "TransformData",
        "type": "DataFlow",
        "dependsOn": [{"activity": "CopyFromSource", "dependencyConditions": ["Succeeded"]}],
        "typeProperties": {
          "dataflow": {"referenceName": "TransformFlow"}
        }
      }
    ]
  }
}
```

### Create with Azure CLI

```bash
# Create Data Factory
az datafactory create --resource-group myRG --name my-adf

# Create linked services, datasets, and pipelines
az datafactory pipeline create --resource-group myRG \
  --factory-name my-adf --name TransformPipeline \
  --pipeline @pipeline.json
```

**Docs:** https://learn.microsoft.com/en-us/azure/data-factory/introduction

---

## Step 4: Transform with GCP Dataflow

### Apache Beam Pipeline

```python
# dataflow_transform.py
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

class ParseRecord(beam.DoFn):
    def process(self, element):
        import json
        record = json.loads(element)
        if record.get("amount") is not None:
            yield {
                "record_id": record["id"],
                "name": record["name"],
                "amount": float(record["amount"]),
                "created_at": record["created_at"]
            }

def run():
    options = PipelineOptions([
        "--runner=DataflowRunner",
        "--project=my-project",
        "--region=us-central1",
        "--temp_location=gs://my-data-lake/temp/"
    ])

    with beam.Pipeline(options=options) as p:
        (
            p
            | "ReadFromGCS" >> beam.io.ReadFromText("gs://my-data-lake/raw/api-data/*.json")
            | "ParseRecords" >> beam.ParDo(ParseRecord())
            | "WriteToBigQuery" >> beam.io.WriteToBigQuery(
                "my-project:my_dataset.records",
                schema="record_id:STRING,name:STRING,amount:FLOAT,created_at:TIMESTAMP",
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
            )
        )

if __name__ == "__main__":
    run()
```

**Docs:** https://cloud.google.com/dataflow/docs/overview

---

## Step 5: Load into Data Warehouse

### AWS Redshift

```sql
-- Load from S3 to Redshift
COPY records
FROM 's3://my-data-lake/staging/records/'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftLoadRole'
FORMAT AS PARQUET;
```

### Azure Synapse

```sql
-- Load from Blob Storage to Synapse
COPY INTO dbo.records
FROM 'https://mystorageacct.blob.core.windows.net/staging/records/'
WITH (
    FILE_TYPE = 'PARQUET',
    CREDENTIAL = (IDENTITY = 'Managed Identity')
);
```

### GCP BigQuery

```bash
# Load from GCS to BigQuery
bq load --source_format=PARQUET \
  my_dataset.records \
  gs://my-data-lake/staging/records/*.parquet
```

---

## Step 6: Data Quality Checks

### Using Great Expectations

```python
# data_quality.py
import great_expectations as gx

context = gx.get_context()

# Define expectations
validator = context.sources.pandas_default.read_parquet(
    "s3://my-data-lake/staging/records/"
)

validator.expect_column_values_to_not_be_null("record_id")
validator.expect_column_values_to_be_unique("record_id")
validator.expect_column_values_to_be_between("amount", min_value=0, max_value=1000000)
validator.expect_column_values_to_match_regex("name", r"^[A-Za-z\s]+$")

results = validator.validate()

if not results.success:
    raise Exception(f"Data quality check failed: {results}")
```

### Simple SQL-Based Checks

```sql
-- Check for nulls
SELECT COUNT(*) AS null_count
FROM staging.records
WHERE record_id IS NULL;

-- Check for duplicates
SELECT record_id, COUNT(*) AS cnt
FROM staging.records
GROUP BY record_id
HAVING COUNT(*) > 1;

-- Check value ranges
SELECT COUNT(*) AS out_of_range
FROM staging.records
WHERE amount < 0 OR amount > 1000000;

-- Freshness check
SELECT MAX(created_at) AS latest_record,
       CURRENT_TIMESTAMP - MAX(created_at) AS data_lag
FROM staging.records;
```

---

## Step 7: Orchestration

### AWS Step Functions

```json
{
  "StartAt": "IngestData",
  "States": {
    "IngestData": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:ingest",
      "Next": "TransformData"
    },
    "TransformData": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {"JobName": "transform-api-data"},
      "Next": "QualityCheck"
    },
    "QualityCheck": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:quality-check",
      "Next": "LoadToWarehouse"
    },
    "LoadToWarehouse": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:load-redshift",
      "End": true
    }
  }
}
```

### Apache Airflow DAG

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

dag = DAG(
    "data_pipeline",
    schedule_interval="0 6 * * *",  # Daily at 6 AM
    start_date=datetime(2024, 1, 1),
    catchup=False,
    default_args={"retries": 2, "retry_delay": timedelta(minutes=5)}
)

ingest = PythonOperator(task_id="ingest", python_callable=ingest_from_api, dag=dag)
transform = PythonOperator(task_id="transform", python_callable=run_transform, dag=dag)
quality = PythonOperator(task_id="quality_check", python_callable=run_quality_checks, dag=dag)
load = PythonOperator(task_id="load", python_callable=load_to_warehouse, dag=dag)

ingest >> transform >> quality >> load
```

---

## Monitoring

**Key Metrics to Track**
- Pipeline execution time and success rate
- Record count per run (detect anomalies)
- Data freshness (time since last successful load)
- Data quality check pass/fail rates
- Cost per pipeline run

**Alerting**
- Pipeline failure
- Data quality check failure
- Data freshness exceeding threshold
- Unexpected record count changes (more than 50% variance)

---

## Verification Checklist

- [ ] Data is ingested from the source and stored in raw format
- [ ] Transformation produces clean, validated data
- [ ] Data quality checks run and block bad data
- [ ] Data warehouse is loaded with the latest data
- [ ] Pipeline runs on schedule without manual intervention
- [ ] Monitoring and alerting are configured

---

## Cleanup

1. Delete data warehouse / BigQuery dataset
2. Remove Glue jobs / Data Factory pipelines / Dataflow jobs
3. Delete S3 buckets / Storage accounts / GCS buckets
4. Remove IAM roles and service accounts
5. Delete orchestration resources (Step Functions, Airflow)

---

## Additional Resources

- [AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)
- [Azure Data Factory Documentation](https://learn.microsoft.com/en-us/azure/data-factory/)
- [GCP Dataflow Documentation](https://cloud.google.com/dataflow/docs)
- [Great Expectations Documentation](https://docs.greatexpectations.io/docs/)
- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
