# Domain 1: Data Ingestion (Part 1 of 2)

## Overview

Data ingestion is the process of bringing data into AWS from various sources. This is part of Domain 1 (Data Ingestion and Transformation), which makes up 34% of the DEA-C01 exam. This document covers the ingestion services; transformation services are covered in `02-data-transformation.md`.

Understanding when to use each ingestion service and the trade-offs between batch and streaming approaches is critical for the exam.

---

## Amazon Kinesis

Amazon Kinesis is a family of services for collecting, processing, and analyzing real-time streaming data. The exam tests all three Kinesis services extensively.

**📖 [Amazon Kinesis Overview](https://docs.aws.amazon.com/kinesis/)**

### Kinesis Data Streams

Kinesis Data Streams is a massively scalable, real-time data streaming service. You manage capacity through shards.

**📖 [Kinesis Data Streams Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)**

#### Core Concepts

- **Stream**: A named, ordered sequence of data records. A stream is composed of one or more shards.
- **Shard**: The base throughput unit. Each shard supports 1 MB/s or 1,000 records/s for writes and 2 MB/s for reads.
- **Record**: The unit of data stored. Contains a partition key, sequence number, and data blob (up to 1 MB).
- **Partition Key**: Determines which shard a record is routed to via MD5 hashing.
- **Sequence Number**: Unique identifier assigned by Kinesis after a record is written.
- **Retention Period**: 24 hours by default, configurable up to 365 days. Extended retention incurs additional cost.

**📖 [Kinesis Key Concepts](https://docs.aws.amazon.com/streams/latest/dev/key-concepts.html)**

#### Producers

| Producer | Description | Use Case |
|----------|-------------|----------|
| **AWS SDK** | PutRecord (single) / PutRecords (batch up to 500) | Simple, low-volume producers |
| **Kinesis Producer Library (KPL)** | High-throughput library with micro-batching and aggregation | High-volume producers needing efficiency |
| **Kinesis Agent** | Pre-built Java agent for monitoring log files | Log file ingestion from EC2 instances |
| **Third-party** | Fluentd, Logstash, Apache Flume | Integration with existing logging stacks |

**📖 [Kinesis Producer Library](https://docs.aws.amazon.com/streams/latest/dev/developing-producers-with-kpl.html)**

#### Consumers

| Consumer | Throughput Model | Latency | Use Case |
|----------|-----------------|---------|----------|
| **KCL (Kinesis Client Library)** | Shared: 2 MB/s per shard across all consumers | ~200 ms | Long-running consumer applications |
| **AWS Lambda** | Event source mapping, auto-scaling | ~200 ms | Serverless stream processing |
| **Enhanced Fan-Out** | Dedicated: 2 MB/s per shard per consumer | ~70 ms | Multiple consumers needing independent throughput |
| **Kinesis Data Analytics** | Managed Flink/SQL processing | Sub-second | Real-time analytics on stream data |

**📖 [Enhanced Fan-Out Consumers](https://docs.aws.amazon.com/streams/latest/dev/enhanced-consumers.html)**

#### Shard Management and Scaling

- **Splitting a shard**: Doubles capacity by dividing one shard into two. Use when write throughput is exceeded.
- **Merging shards**: Combines two adjacent shards into one. Use when reducing capacity to save cost.
- **On-Demand mode**: Automatically manages shard count (up to 200 MB/s write, 400 MB/s read by default). No shard management needed.
- **Provisioned mode**: You specify exact shard count. Better cost control for predictable workloads.

**📖 [Kinesis Resharding](https://docs.aws.amazon.com/streams/latest/dev/kinesis-record-processor-scaling.html)**

#### Exam Tips for Kinesis Data Streams
- Calculate required shards: `max(incoming_data_MB / 1, incoming_records / 1000)` shards
- Hot shards occur when partition keys are not evenly distributed
- Enhanced fan-out is required when you have multiple consumers that each need full throughput
- On-Demand mode eliminates the need for capacity planning but costs more per GB

---

### Kinesis Data Firehose

Kinesis Data Firehose is a fully managed service for delivering real-time streaming data to destinations. Unlike Data Streams, Firehose handles scaling automatically and requires no consumer code.

**📖 [Kinesis Data Firehose Developer Guide](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html)**

#### Delivery Destinations

| Destination | How It Works |
|-------------|-------------|
| **Amazon S3** | Direct delivery; most common data lake destination |
| **Amazon Redshift** | Stages in S3 first, then issues COPY command |
| **Amazon OpenSearch** | Direct delivery for search and log analytics |
| **HTTP Endpoint** | Custom HTTP endpoints including partner integrations |
| **Third-party** | Splunk, Datadog, New Relic, MongoDB, Snowflake |

**📖 [Firehose Destinations](https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html)**

#### Buffering Configuration

Firehose buffers incoming data before delivering. Delivery occurs when either condition is met first:
- **Buffer Size**: 1 MB to 128 MB (for S3 destination)
- **Buffer Interval**: 60 to 900 seconds (minimum 60 seconds)

This means Firehose is **near real-time**, not true real-time. The minimum delivery latency is approximately 60 seconds.

**📖 [Firehose Buffering Hints](https://docs.aws.amazon.com/firehose/latest/dev/basic-deliver.html)**

#### Data Transformation with Lambda

Firehose can invoke a Lambda function to transform records before delivery:

```python
# Lambda transformation function for Firehose
import base64
import json

def lambda_handler(event, context):
    output = []
    for record in event['records']:
        payload = base64.b64decode(record['data']).decode('utf-8')
        data = json.loads(payload)

        # Apply transformation
        data['processed'] = True
        data['region'] = 'us-east-1'

        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',  # Ok, Dropped, or ProcessingFailed
            'data': base64.b64encode(
                json.dumps(data).encode('utf-8')
            ).decode('utf-8')
        }
        output.append(output_record)

    return {'records': output}
```

**📖 [Firehose Data Transformation](https://docs.aws.amazon.com/firehose/latest/dev/data-transformation.html)**

#### Format Conversion

Firehose can convert JSON source data to Parquet or ORC format using a Glue Data Catalog table definition as the schema. This is a zero-code way to deliver data in columnar format to your data lake.

**📖 [Firehose Record Format Conversion](https://docs.aws.amazon.com/firehose/latest/dev/record-format-conversion.html)**

#### Compression Options
- S3 destination: GZIP, Snappy, ZIP, Hadoop-compatible Snappy
- When format conversion (Parquet/ORC) is enabled, Firehose uses the format's built-in compression (Snappy for Parquet by default)

---

### Kinesis Data Analytics

Kinesis Data Analytics enables real-time processing of streaming data using SQL or Apache Flink.

**📖 [Kinesis Data Analytics Developer Guide](https://docs.aws.amazon.com/kinesisanalytics/latest/dev/what-is.html)**

#### SQL Applications
- Write SQL queries against streaming data
- Use in-application streams, pumps, and reference tables
- Window functions: tumbling (fixed intervals), sliding (overlapping), stagger (per-key)

#### Apache Flink Applications
- Write Java, Scala, or Python Flink applications
- More powerful than SQL: complex event processing, stateful computations
- Automatic scaling based on throughput
- Checkpointing for fault tolerance

#### When to Use Kinesis Data Analytics
- Real-time aggregations (e.g., clickstream counts per minute)
- Anomaly detection on streaming data
- Real-time dashboards with continuous query results
- Stream enrichment by joining with reference data

---

### Kinesis Service Comparison

| Feature | Data Streams | Firehose | Data Analytics |
|---------|-------------|----------|----------------|
| **Purpose** | Collect and process streams | Deliver streams to destinations | Analyze streams in real-time |
| **Latency** | ~200 ms | 60-900 sec | Sub-second |
| **Scaling** | Manual shards or On-Demand | Fully automatic | Automatic (KPU-based) |
| **Custom code** | Yes (consumers) | Lambda only (optional) | SQL or Flink |
| **Data retention** | 24 hrs - 365 days | None (deliver and discard) | None |
| **Replay capability** | Yes | No | No |
| **Pricing** | Per shard-hour + per GB | Per GB ingested | Per KPU-hour |

---

## AWS DMS (Database Migration Service)

AWS DMS migrates databases to AWS with minimal downtime. It supports homogeneous (e.g., Oracle to Oracle) and heterogeneous (e.g., Oracle to PostgreSQL) migrations.

**📖 [AWS DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)**

### Migration Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Full Load** | One-time migration of all existing data | Initial database migration |
| **CDC (Change Data Capture)** | Ongoing replication of changes only | Continuous sync after initial load |
| **Full Load + CDC** | Full load followed by ongoing CDC | Complete migration with zero downtime |

**📖 [DMS Migration Tasks](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.html)**

### Architecture

```
Source Database --> Replication Instance --> Target Database/Store
                   (runs migration tasks)
```

- **Replication Instance**: An EC2 instance that runs the DMS migration engine. Size it based on data volume and number of tables.
- **Source Endpoint**: Connection to the source database (on-premises, EC2, RDS, Aurora, etc.)
- **Target Endpoint**: Connection to the target (RDS, Aurora, S3, Redshift, DynamoDB, Kinesis, OpenSearch, etc.)

**📖 [DMS Replication Instances](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html)**

### CDC Prerequisites and Configuration

For CDC to work, the source database must have change logging enabled:
- **MySQL/MariaDB**: Binary logging (binlog) must be enabled with ROW format
- **PostgreSQL**: Logical replication (wal_level = logical) must be enabled
- **Oracle**: Supplemental logging and ARCHIVELOG mode required
- **SQL Server**: MS-CDC or MS-Replication must be enabled

**📖 [DMS CDC Configuration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html)**

### DMS to S3 as Target

DMS can write to S3 in CSV or Parquet format, making it useful for building a data lake from operational databases:
- Full load creates files with all existing data
- CDC creates incremental files with insert, update, and delete operations
- Files are organized by schema and table name in the S3 prefix

**📖 [Using S3 as a DMS Target](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html)**

### AWS Schema Conversion Tool (SCT)

For heterogeneous migrations (different database engines), use SCT before DMS:
- Converts source schema to target-compatible format
- Generates assessment reports identifying conversion issues
- Converts stored procedures, functions, triggers, and views
- Data extraction agents for large-scale data warehouse migrations

**📖 [AWS SCT User Guide](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/)**

### Exam Tips for DMS
- DMS handles the data migration; SCT handles schema conversion for heterogeneous migrations
- CDC requires proper logging configuration on the source database
- DMS can target Kinesis Data Streams or Apache Kafka for real-time CDC event streaming
- For S3 targets, Parquet format is recommended for analytics workloads
- Replication instance size affects migration throughput; multi-AZ provides HA

---

## AWS DataSync

AWS DataSync automates and accelerates data transfer between on-premises storage and AWS storage services, or between AWS storage services.

**📖 [AWS DataSync User Guide](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html)**

### Supported Transfer Paths

| Source | Target |
|--------|--------|
| On-premises NFS/SMB | Amazon S3, EFS, FSx |
| HDFS (Hadoop) | Amazon S3 |
| Amazon S3 | Amazon S3 (cross-region, cross-account) |
| Amazon EFS | Amazon EFS |
| AWS Snowcone | Amazon S3 |

### Key Features

- **DataSync Agent**: Deployed on-premises as a VM (VMware, Hyper-V, KVM) to connect to local storage
- **Automatic Scheduling**: Cron-based task scheduling (hourly, daily, weekly)
- **Bandwidth Throttling**: Control network utilization during transfers
- **Data Integrity Verification**: Automatic checksum validation during and after transfer
- **Encryption in Transit**: TLS 1.2 encryption for all data in transit
- **Include/Exclude Filters**: Selective file transfer based on patterns
- **Transfer speeds**: Up to 10 Gbps over a single agent

**📖 [DataSync Task Configuration](https://docs.aws.amazon.com/datasync/latest/userguide/creating-task.html)**

### DataSync vs Other Transfer Services

| Service | Use Case | Transfer Type |
|---------|----------|---------------|
| **DataSync** | On-premises storage to AWS, AWS-to-AWS storage | File-based (NFS, SMB, HDFS, S3, EFS) |
| **DMS** | Database migration and replication | Database-level (tables, schemas, CDC) |
| **Transfer Family** | SFTP/FTPS/FTP to S3 or EFS | File-based (protocol-specific) |
| **Snow Family** | Petabyte-scale offline data transfer | Physical device shipping |
| **S3 Transfer Acceleration** | Fast uploads to S3 from distant locations | S3 object uploads via CloudFront edge |

---

## Amazon AppFlow

Amazon AppFlow is a fully managed integration service for transferring data between SaaS applications and AWS services without writing code.

**📖 [Amazon AppFlow User Guide](https://docs.aws.amazon.com/appflow/latest/userguide/what-is-appflow.html)**

### Supported Sources (SaaS Connectors)

AppFlow provides built-in connectors for 50+ SaaS applications:
- **CRM**: Salesforce, ServiceNow, Zendesk
- **Marketing**: Google Analytics, Marketo, Amplitude
- **ERP**: SAP, Veeva
- **Collaboration**: Slack
- **Custom**: Custom connectors via AppFlow API

### Supported Destinations

- Amazon S3
- Amazon Redshift
- Amazon EventBridge
- Salesforce (bi-directional)
- Snowflake, Upsolver, and other partners

### Flow Types

| Type | Description | Use Case |
|------|-------------|----------|
| **On-Demand** | Manual, one-time transfer | Ad-hoc data pulls |
| **Scheduled** | Recurring on a schedule | Regular data syncs (hourly, daily) |
| **Event-Driven** | Triggered by source events | Real-time sync (Salesforce events) |

### Key Features

- **Field mapping**: Map source fields to destination columns
- **Data transformation**: Filtering, masking, merging, truncating during transfer
- **Encryption**: KMS encryption for data at rest and in transit
- **Private connectivity**: AWS PrivateLink for Salesforce and other sources

**📖 [AppFlow Flow Configuration](https://docs.aws.amazon.com/appflow/latest/userguide/create-flow-console.html)**

### Exam Tips for AppFlow
- Use AppFlow when you need SaaS-to-AWS data integration without custom code
- AppFlow supports event-driven flows for near real-time syncs (Salesforce only for events)
- Data can be filtered and transformed during the flow without Lambda
- PrivateLink connectivity avoids data traversing the public internet

---

## Batch vs Streaming Ingestion Patterns

Understanding when to use batch vs streaming ingestion is heavily tested on the DEA-C01 exam.

### Batch Ingestion

Batch ingestion processes data in discrete, scheduled chunks. Use when data freshness requirements are measured in minutes to hours.

| Service | Description | Best For |
|---------|-------------|----------|
| **AWS Glue ETL** | Serverless Spark-based batch processing | Scheduled ETL from S3, JDBC, Data Catalog sources |
| **AWS DMS (Full Load)** | One-time database migration | Initial database migration to AWS |
| **Amazon EMR** | Managed Hadoop/Spark clusters | Large-scale batch processing (TB to PB) |
| **Redshift COPY** | Bulk load from S3 into Redshift | Loading data warehouse from data lake |
| **AWS DataSync** | Scheduled file transfers | Regular on-premises to S3 data syncs |
| **Amazon AppFlow** | Scheduled SaaS data pulls | Periodic CRM/ERP data integration |

**📖 [AWS Glue ETL Jobs](https://docs.aws.amazon.com/glue/latest/dg/author-job.html)**
**📖 [Redshift COPY Command](https://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html)**

### Streaming Ingestion

Streaming ingestion processes data continuously as it arrives. Use when data freshness requirements are measured in seconds to minutes.

| Service | Latency | Scaling | Best For |
|---------|---------|---------|----------|
| **Kinesis Data Streams** | ~200 ms | Manual shards or On-Demand | Custom real-time consumers, replay needed |
| **Kinesis Data Firehose** | 60-900 sec | Fully automatic | Managed delivery to S3/Redshift/OpenSearch |
| **Amazon MSK** | Milliseconds | Manual or MSK Serverless | Kafka ecosystem migration, complex event streaming |
| **DynamoDB Streams** | ~100 ms | Automatic | CDC from DynamoDB tables |

**📖 [Amazon MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html)**

### Change Data Capture (CDC) Patterns

CDC captures changes (inserts, updates, deletes) from a source system and streams them for downstream processing.

| CDC Source | Service | Target Options |
|------------|---------|----------------|
| Relational databases | AWS DMS (CDC mode) | S3, Kinesis, Kafka, Redshift, RDS |
| DynamoDB tables | DynamoDB Streams | Lambda, Kinesis Data Streams |
| Custom applications | Kinesis Data Streams | Any consumer |
| Kafka-based sources | MSK Connect (Debezium) | S3, Redshift, OpenSearch |

**📖 [DMS CDC Tasks](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html)**
**📖 [DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)**

### Common Ingestion Architecture Patterns

#### Pattern 1: Real-Time Clickstream Analytics
```
Web App --> Kinesis Data Streams --> Lambda (enrich) --> DynamoDB (real-time)
                                 --> Firehose --> S3 (data lake, Parquet)
                                 --> Kinesis Data Analytics --> Dashboard
```

#### Pattern 2: Database Migration with Zero Downtime
```
On-Prem DB --> SCT (schema) --> Target DB (empty schema)
           --> DMS (full load) --> Target DB (data)
           --> DMS (CDC) --> Target DB (ongoing sync until cutover)
```

#### Pattern 3: SaaS Data Integration
```
Salesforce --> AppFlow (scheduled) --> S3 (raw)
                                   --> Glue Crawler --> Data Catalog
                                   --> Athena (analytics)
```

#### Pattern 4: Log Aggregation Pipeline
```
EC2/Containers --> Kinesis Agent --> Firehose --> S3 (raw logs)
                                              --> OpenSearch (search/dashboards)
                                              --> Lambda (alerts)
```

#### Pattern 5: Event-Driven Data Lake Ingestion
```
S3 Upload --> EventBridge --> Step Functions --> Glue Crawler
                                             --> Glue ETL (transform)
                                             --> S3 (processed/Parquet)
                                             --> Redshift (COPY, warehouse)
```

#### Pattern 6: On-Premises Data Migration to Data Lake
```
On-Prem NFS --> DataSync Agent --> S3 (raw zone)
On-Prem DB  --> DMS (full + CDC) --> S3 (CDC files)
Both        --> Glue ETL --> S3 (curated zone, Parquet)
```

---

## Common Exam Scenarios

1. **"Real-time ingestion with custom processing"** --> Kinesis Data Streams + KCL or Lambda
2. **"Deliver streaming data to S3 with no code"** --> Kinesis Data Firehose
3. **"Migrate on-premises database with minimal downtime"** --> DMS with Full Load + CDC
4. **"Transfer files from on-premises NFS to S3 on a schedule"** --> DataSync with agent
5. **"Integrate Salesforce data into S3 data lake"** --> Amazon AppFlow
6. **"Existing Kafka workload moving to AWS"** --> Amazon MSK
7. **"Stream data to S3 in Parquet format"** --> Firehose with format conversion
8. **"Multiple consumers need independent stream throughput"** --> Kinesis Data Streams with enhanced fan-out
9. **"CDC from relational database to Kinesis"** --> DMS with Kinesis target endpoint
10. **"Calculate shard count for 5 MB/s write throughput"** --> 5 shards minimum (1 MB/s per shard)

---

## CLI Quick Reference

```bash
# Kinesis Data Streams
aws kinesis create-stream --stream-name my-stream --shard-count 2
aws kinesis put-record --stream-name my-stream --partition-key pk1 --data "base64data"
aws kinesis describe-stream-summary --stream-name my-stream

# Kinesis Data Firehose
aws firehose create-delivery-stream --delivery-stream-name my-firehose \
    --s3-destination-configuration RoleARN=arn:...,BucketARN=arn:...
aws firehose put-record --delivery-stream-name my-firehose --record '{"Data":"base64data"}'

# DMS
aws dms create-replication-instance --replication-instance-identifier my-instance \
    --replication-instance-class dms.r5.large
aws dms create-replication-task --replication-task-identifier my-task \
    --migration-type full-load-and-cdc

# DataSync
aws datasync create-task --source-location-arn arn:... --destination-location-arn arn:...
aws datasync start-task-execution --task-arn arn:...

# AppFlow
aws appflow create-flow --flow-name my-flow \
    --source-flow-config '{"connectorType":"Salesforce",...}' \
    --destination-flow-config-list '[{"connectorType":"S3",...}]'
```
