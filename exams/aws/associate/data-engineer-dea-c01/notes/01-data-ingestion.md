# 01 - Data Ingestion (Domain 1, ~17% of exam)

This note covers the ingestion side of Domain 1 (Data Ingestion and Transformation). Transformation is in [02-data-transformation.md](02-data-transformation.md).

## Streaming ingestion

### Amazon Kinesis Data Streams (KDS)

- Shard-based, low-latency stream (sub-second). Records up to 1 MiB.
- **Modes:** Provisioned (you manage shards) and **On-Demand** (automatic, more expensive per GB).
- **Throughput per shard:** 1 MB/s and 1000 records/s ingest; 2 MB/s aggregate read across consumers.
- **Enhanced fan-out (EFO):** dedicated 2 MB/s per consumer per shard. Use when you have many consumers.
- **Retention:** default 24h, up to 365 days.
- **Producers:** KPL (Kinesis Producer Library), AWS SDK PutRecord/PutRecords, Kinesis Agent, IoT Core, EventBridge.
- **Consumers:** KCL, Lambda, Firehose, Kinesis Data Analytics (now **Amazon Managed Service for Apache Flink**), Spark Streaming on EMR.
- **Ordering:** records with the same partition key route to the same shard, preserving order within that shard.

**[📖 Kinesis Data Streams Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)**

#### Exam triggers

- "Sub-second latency, custom consumers, multiple parallel readers" → KDS with EFO
- "Low cost, predictable throughput" → Provisioned mode
- "Bursty unpredictable traffic, no shard management" → On-Demand mode
- "Order matters per user" → Use userId as partition key

### Amazon Kinesis Data Firehose

- **Fully managed** delivery stream. No shards. No code to consume.
- **Destinations:** S3, Redshift (via S3 staging), OpenSearch, OpenSearch Serverless, Splunk, Datadog, New Relic, MongoDB, generic HTTP.
- **Buffering:** by size (1-128 MiB) and time (60-900 seconds). Whichever hits first triggers delivery.
- **Built-in transformations:** Lambda transformer (e.g., parse, enrich, redact). Format conversion **JSON → Parquet/ORC** using a Glue Data Catalog table for schema.
- **Compression:** GZIP, ZIP, Snappy.
- **Failures:** records that fail Lambda processing or delivery go to a configurable S3 error bucket.
- **Latency:** ~60s minimum (vs sub-second for KDS).

**[📖 Firehose Developer Guide](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html)**

#### Exam triggers

- "Real-time deliver to S3 in Parquet, no infrastructure" → Firehose with format conversion
- "Stream logs to OpenSearch and S3 in parallel" → Firehose with two destinations or a Lambda fanout
- "Latency tolerance of one minute, prefer simplicity" → Firehose over KDS

### Amazon Managed Streaming for Apache Kafka (MSK)

- **Apache Kafka compatible.** Use when team has existing Kafka producers/consumers, or needs Kafka-specific features (long retention, exactly-once semantics, Kafka Connect ecosystem).
- **MSK Provisioned:** you size brokers (kafka.m5/m7g/t3 family). Cluster-level configs.
- **MSK Serverless:** no broker sizing. Pay for ingress/egress. Topic-level autoscaling.
- **MSK Connect:** managed Kafka Connect. Source connectors (DB-CDC like Debezium) and sink connectors (S3, Redshift).
- **Schema Registry:** Glue Schema Registry integrates with MSK for schema evolution / compatibility checks.

**[📖 MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html)**

#### Exam triggers

- "Apache Kafka with no broker management" → MSK Serverless
- "Existing Kafka workloads on EC2 self-managed, want managed equivalent" → MSK Provisioned
- "Stream from RDS Postgres to Kafka with CDC" → MSK Connect with Debezium

### Amazon Managed Service for Apache Flink

- Formerly Kinesis Data Analytics. Stream processing in SQL or Java/Python (Apache Flink).
- Common for windowed aggregations, joins, anomaly detection on KDS / MSK streams.
- Good answer when the prompt mentions "stateful stream processing" or "tumbling / sliding window aggregation."

---

## Batch and database ingestion

### AWS Glue Crawlers

- Discover schema in S3, JDBC, DynamoDB, Delta, Iceberg, Hudi.
- Populate the **Glue Data Catalog** with tables, columns, partitions.
- Schedule on-demand or via EventBridge.
- Can detect schema changes and update existing catalog entries.

**[📖 Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)**

#### Exam triggers

- "Catalog new files arriving in S3 daily" → Crawler on schedule
- "Detect schema drift" → Crawler with `UPDATE_IN_DATABASE` configuration

### AWS DMS (Database Migration Service)

- **Migrations** between databases. **CDC** for ongoing replication.
- **Sources:** RDS, on-prem Oracle/SQL Server/MySQL/Postgres, MongoDB, S3 (with DMS source).
- **Targets:** RDS, Aurora, Redshift, S3 (in Parquet/CSV), DynamoDB, Kinesis, MSK, OpenSearch, Neptune.
- **Modes:** Full load, CDC only, Full load + CDC.
- **DMS Serverless:** auto-scales replication capacity.
- **Schema Conversion Tool (AWS SCT):** convert source schema to target dialect (e.g., Oracle PL/SQL → PostgreSQL). Often used alongside DMS for heterogeneous migrations.

**[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)**

#### Exam triggers

- "Continuous replication from on-prem Oracle to Aurora PostgreSQL" → DMS Full Load + CDC, with SCT for schema conversion
- "Mirror RDS Postgres changes into S3 Parquet" → DMS with S3 target + Parquet output
- "Stream RDS CDC to Kinesis for real-time downstream" → DMS with Kinesis target

### Amazon AppFlow

- **SaaS connector.** Salesforce, ServiceNow, Slack, SAP, Marketo, Google Analytics, Zendesk → S3, Redshift, EventBridge, Snowflake.
- Triggers: on-demand, schedule, event.
- Built-in field mapping and filtering. PrivateLink for Salesforce.

#### Exam triggers

- "Pull Salesforce opportunities into S3 nightly" → AppFlow scheduled flow
- "React to a ServiceNow ticket creation" → AppFlow event-triggered → EventBridge

### AWS Transfer Family

- Managed SFTP / FTPS / FTP / AS2 endpoints fronting S3 (and EFS).
- IAM-backed identity or custom identity provider (Active Directory, Lambda).

#### Exam triggers

- "Vendor sends CSVs over SFTP daily" → Transfer Family SFTP endpoint → S3 → S3 Event → Glue / Lambda

### AWS DataSync

- High-throughput bulk transfer. NFS, SMB, HDFS, object stores → S3, EFS, FSx for Windows / Lustre / OpenZFS / NetApp ONTAP.
- Used for one-time migrations or scheduled syncs.

#### Exam triggers

- "Migrate 100TB on-prem NFS to S3" → DataSync (over Direct Connect or Snowball if huge)

### Snow Family

- Snowcone / Snowball / Snowmobile for offline bulk migration.
- Snowball Edge can run Lambda or EC2 at the edge for pre-processing.

---

## Choosing the right ingestion service

| If the question says... | Pick... |
|---|---|
| Sub-second streaming, custom consumers | Kinesis Data Streams |
| Real-time delivery to S3/Redshift/OpenSearch with no infra | Kinesis Data Firehose |
| Apache Kafka compatibility | MSK (Serverless if no broker mgmt) |
| Stateful stream processing with SQL or Flink | Managed Service for Apache Flink |
| Full + ongoing replication of an RDBMS | AWS DMS |
| Scheduled SaaS data pull (Salesforce, etc.) | Amazon AppFlow |
| SFTP / FTPS landing zone | AWS Transfer Family |
| Bulk NFS / SMB / HDFS to S3 | DataSync (or Snowball if offline) |
| Catalog new S3 files automatically | Glue Crawler |

---

## Schema management for streams

- **AWS Glue Schema Registry** integrates with KDS, Firehose, MSK. Enforces compatibility (BACKWARD, FORWARD, FULL).
- Use when multiple producers and consumers need a contract on event shape.
- Avoids "schema drift breaks consumer" failures.

---

## Common cost optimizations

- Firehose: increase buffer size to reduce S3 PUT costs. Compress with GZIP. Convert to Parquet on the fly.
- KDS: prefer On-Demand only for unpredictable traffic. Steady traffic is cheaper on Provisioned.
- DMS: use Serverless for variable replication load.
- Crawler: target specific paths and use exclusions to avoid scanning the entire bucket.
