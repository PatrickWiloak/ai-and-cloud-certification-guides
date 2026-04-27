# AWS Certified Data Engineer - Associate (DEA-C01) - Fact Sheet

## Quick Reference

**Exam Code:** DEA-C01
**Duration:** 130 minutes
**Questions:** 65 (50 scored + 15 unscored)
**Format:** Multiple choice and multiple response
**Passing Score:** 720 / 1000
**Cost:** $150 USD (50% discount voucher available for prior AWS cert holders)
**Validity:** 3 years
**Languages:** English, Japanese, Korean, Simplified Chinese, French, German, Italian, Portuguese, Spanish

**Official resources:**

- **[📖 Official Exam Page](https://aws.amazon.com/certification/certified-data-engineer-associate/)** - Registration and overview
- **[📖 Exam Guide PDF](https://d1.awsstatic.com/training-and-certification/docs-data-engineer-associate/AWS-Certified-Data-Engineer-Associate_Exam-Guide.pdf)** - Authoritative exam blueprint
- **[📖 Sample Questions](https://d1.awsstatic.com/training-and-certification/docs-data-engineer-associate/AWS-Certified-Data-Engineer-Associate_Sample-Questions.pdf)** - Official practice questions
- **[📖 AWS Skill Builder Exam Prep](https://skillbuilder.aws/)** - Free official prep courses
- **[📖 AWS Big Data Blog](https://aws.amazon.com/blogs/big-data/)** - Latest features and patterns

---

## Exam Domains and Weights

| # | Domain | Weight | Approx. scored questions |
|---|---|---|---|
| 1 | Data Ingestion and Transformation | 34% | ~17 |
| 2 | Data Store Management | 26% | ~13 |
| 3 | Data Operations and Support | 22% | ~11 |
| 4 | Data Security and Governance | 18% | ~9 |

---

## Domain 1 - Data Ingestion and Transformation (34%)

### Key services

#### Streaming ingestion

- **Amazon Kinesis Data Streams** - low-latency (~70ms) shard-based stream. Provisioned vs On-Demand mode. KCL/KPL libraries. Enhanced fan-out for parallel consumers.
  - **[📖 Kinesis Data Streams Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)**
- **Amazon Kinesis Data Firehose** - fully-managed delivery to S3 / Redshift / OpenSearch / Splunk / HTTP. Buffering by size or time. Built-in transformations via Lambda. Format conversion (JSON → Parquet/ORC).
  - **[📖 Firehose Developer Guide](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html)**
- **Amazon Managed Streaming for Apache Kafka (MSK)** - managed Kafka. Provisioned and Serverless. Integrates with Kafka Connect, MSK Connect, schema registry.
  - **[📖 MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html)**
  - **[📖 MSK Serverless](https://docs.aws.amazon.com/msk/latest/developerguide/serverless.html)**

#### Batch and database ingestion

- **AWS Glue Crawlers** - discover schema and populate the Glue Data Catalog from S3, JDBC, DynamoDB, Delta Lake, Iceberg, Hudi.
  - **[📖 Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)**
- **AWS DMS (Database Migration Service)** - homogeneous and heterogeneous database migrations. Full load + CDC. DMS Serverless. Common targets: S3, Redshift, Kinesis, MSK.
  - **[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)**
- **Amazon AppFlow** - SaaS-to-AWS data flows (Salesforce, Google Analytics, Slack, ServiceNow → S3, Redshift). On-demand, scheduled, or event-triggered.
  - **[📖 AppFlow User Guide](https://docs.aws.amazon.com/appflow/latest/userguide/what-is-appflow.html)**
- **AWS Transfer Family** - SFTP / FTPS / FTP / AS2 ingestion to S3.
  - **[📖 Transfer Family](https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html)**
- **AWS DataSync** - bulk data transfer from on-prem (NFS, SMB, HDFS) to S3, EFS, FSx.

#### Transformation

- **AWS Glue ETL** - serverless Spark and Python ETL. Glue Studio (visual), Glue notebooks. Job bookmarks, push-down predicates, dynamic frames vs DataFrames. Glue 4.0/5.0 (Spark 3.3/3.5).
  - **[📖 Glue ETL Programming Guide](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)**
- **Amazon EMR** - managed Hadoop/Spark/Hive/Presto. EMR on EC2, EMR Serverless, EMR on EKS, EMR on Outposts. Spot pricing, instance fleets, auto-termination, managed scaling.
  - **[📖 EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)**
  - **[📖 EMR Serverless](https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/emr-serverless.html)**
- **AWS Lambda** - lightweight transforms in event-driven pipelines, especially as Firehose transformers. 15-minute max, 10GB max memory.
- **AWS Step Functions** - workflow orchestration. Standard vs Express. Direct integrations with Glue, EMR, Lambda, DynamoDB, Athena, ECS.
  - **[📖 Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)**
- **Amazon MWAA (Managed Workflows for Apache Airflow)** - managed Airflow for DAG-based orchestration. Common when teams already use Airflow.

### Common patterns and exam triggers

- "Real-time, sub-second latency" → Kinesis Data Streams
- "Real-time, deliver to S3, no infrastructure" → Kinesis Data Firehose
- "Apache Kafka compatible" → MSK
- "Migrate Oracle to Aurora with continuous replication" → DMS
- "Pull from Salesforce on a schedule into S3" → AppFlow
- "Convert JSON to Parquet during stream delivery" → Firehose with format conversion
- "Orchestrate multi-step Glue + EMR + Lambda workflow" → Step Functions
- "Existing team uses Airflow DAGs" → MWAA
- "Catalog raw data on S3 automatically" → Glue Crawler

---

## Domain 2 - Data Store Management (26%)

### Object storage

- **Amazon S3** - the default data lake substrate.
  - Storage classes: Standard, Standard-IA, One Zone-IA, Intelligent-Tiering, Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier Deep Archive
  - File formats: **Parquet** and **ORC** are exam-favored for analytics (columnar, compressed, splittable). Avro for write-heavy streaming. Plain JSON / CSV is a common "wrong" answer.
  - Partitioning: Hive-style (`s3://bucket/table/year=2026/month=04/`) for predicate pushdown. Avoid too many small partitions or too few.
  - **S3 Object Lambda**, **S3 Select**, **S3 Storage Lens**
  - **[📖 S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)**

### Open table formats on S3

- **Apache Iceberg** - first-class support in Athena, Glue, EMR, Redshift Spectrum. ACID transactions, schema evolution, time travel.
  - **[📖 Iceberg with Glue / Athena](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg.html)**
- **Apache Hudi** - upserts, CDC-style sinks. Copy-on-Write vs Merge-on-Read.
- **Delta Lake** - Databricks-originated; Glue and Athena now support reads.

### Data warehouse

- **Amazon Redshift** - columnar MPP warehouse.
  - Provisioned (RA3 with managed storage, DC2 legacy) vs Redshift Serverless
  - Distribution styles: AUTO, EVEN, KEY, ALL. Sort keys: compound, interleaved.
  - Materialized views, result caching, concurrency scaling, AQUA
  - Redshift Spectrum reads S3 directly via Glue Data Catalog
  - Data sharing across clusters and accounts
  - Redshift ML, federated queries (RDS, Aurora)
  - **[📖 Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)**
  - **[📖 Redshift Serverless](https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-whatis.html)**

### Operational databases

- **Amazon RDS** - managed Postgres, MySQL, MariaDB, Oracle, SQL Server. Multi-AZ for HA. Read replicas (in-region and cross-region). Automated backups (1-35 day retention) plus manual snapshots.
- **Amazon Aurora** - cloud-native MySQL- and Postgres-compatible. Aurora Serverless v2, Aurora Global Database, Aurora Zero-ETL to Redshift / OpenSearch.
- **Amazon DynamoDB** - serverless NoSQL. Partition key + optional sort key. GSI / LSI. On-demand vs provisioned. DAX for caching. Streams for CDC. Global tables for multi-region. Zero-ETL to OpenSearch and Redshift.
  - **[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)**
- **Amazon ElastiCache** - Redis or Memcached caching layer in front of RDS / DynamoDB.

### Catalog and lake governance

- **AWS Glue Data Catalog** - Hive-metastore-compatible, used by Athena, Redshift Spectrum, EMR, Lake Formation. Tables, partitions, connections, classifiers, schema versioning.
- **AWS Lake Formation** - centralized lake permissions (resource, column, row, cell). Tag-based access control (LF-Tags). Cross-account data sharing.
  - **[📖 Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**

### Search

- **Amazon OpenSearch Service** - managed OpenSearch (Elasticsearch fork). Provisioned and Serverless. Common targets for log analytics, observability, and search-backed apps.

### Common patterns and exam triggers

- "Petabyte-scale columnar warehouse with concurrent BI queries" → Redshift (RA3 + concurrency scaling)
- "Don't manage capacity, infrequent / spiky warehouse" → Redshift Serverless
- "Single-digit millisecond key-value lookups at scale" → DynamoDB
- "Need ACID upserts on a data lake" → Iceberg or Hudi on S3
- "Time-travel queries on a data lake" → Iceberg
- "Centralized fine-grained permissions across many lake tables" → Lake Formation with LF-Tags
- "Cheapest long-term cold archival" → S3 Glacier Deep Archive
- "Frequent random access but want cost savings" → S3 Intelligent-Tiering

---

## Domain 3 - Data Operations and Support (22%)

### Querying and analytics

- **Amazon Athena** - serverless SQL on S3. V3 engine (Trino-based). Workgroups for cost control and query separation. Partition projection (faster, cheaper than partition queries against the catalog). Federated queries via Athena Data Source Connectors.
  - **[📖 Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)**
  - **[📖 Athena Partition Projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)**
- **Amazon QuickSight** - BI and dashboarding. SPICE in-memory engine, embedded analytics, ML insights, Q (natural language).

### Monitoring and observability

- **Amazon CloudWatch** - metrics, alarms, dashboards. CloudWatch Logs, **CloudWatch Logs Insights** for ad-hoc log queries. CloudWatch Synthetics for API monitoring.
- **Amazon EventBridge** - event-driven automation. Rules, targets, schedules. EventBridge Pipes for source-to-target with optional filtering and enrichment.
- **AWS X-Ray** - distributed tracing for Step Functions / Lambda / ECS / Glue jobs.

### Data quality

- **AWS Glue Data Quality** - managed data quality based on DeequRules. Anomaly detection, drift detection, ML-based recommendations.
  - **[📖 Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)**
- **Deequ** - open-source library, runs on EMR / Glue.

### Cost monitoring

- **AWS Cost Explorer**, **AWS Budgets**, **Cost and Usage Reports (CUR)**
- **S3 Storage Lens** - org-wide S3 visibility, cost optimization recommendations
- **Athena workgroups** - per-workgroup data scan limits and per-query limits

### Recovery patterns

- Glue job retries, EMR step failures, Step Functions Catch / Retry blocks
- DLQs (SQS / SNS) for failed Lambda / Firehose deliveries
- Idempotency: idempotency keys, exactly-once via Kinesis Firehose deduplication, Iceberg merge-on-read

### Common patterns and exam triggers

- "Ad-hoc SQL on S3 without provisioning a cluster" → Athena
- "Reduce Athena cost by 80%" → Parquet + partitioning + compression + workgroup limits
- "Real-time dashboard from Kinesis" → Firehose → S3 → Athena → QuickSight, or Kinesis Data Streams → Lambda → OpenSearch
- "Detect schema drift in nightly Glue job" → Glue Data Quality
- "Alert when ETL job fails" → CloudWatch Alarm on Glue job state metric → SNS

---

## Domain 4 - Data Security and Governance (18%)

### Identity and access

- **AWS IAM** - identity-based and resource-based policies. Use **least privilege**. Common patterns:
  - Service roles for Glue, EMR, Lambda, Step Functions
  - Cross-account access via assumed roles + S3 bucket policies
  - VPC endpoint policies to restrict by VPC
- **AWS Lake Formation permissions** - layered above IAM for fine-grained data lake access. Database, table, column, row, and cell-level. LF-Tags for tag-based access.

### Encryption

- **At rest:**
  - S3: SSE-S3, SSE-KMS, DSSE-KMS, SSE-C; bucket-default encryption
  - RDS / Aurora / Redshift / DynamoDB / OpenSearch: KMS-encrypted at rest by default for new resources
  - EBS, EFS, FSx, EMR HDFS / EMRFS encryption options
- **In transit:** TLS to all AWS endpoints. Force HTTPS via S3 bucket policy `aws:SecureTransport`. Redshift / RDS SSL connection enforcement.
- **KMS:**
  - AWS-managed keys (free, less control), customer-managed keys (CMK; full control + audit)
  - Key rotation (annual for CMKs)
  - Cross-account key sharing for multi-account lakes
  - **[📖 KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)**

### Network controls

- **VPC Endpoints** - **Gateway endpoints** for S3 and DynamoDB (free). **Interface endpoints (PrivateLink)** for everything else (Glue, KMS, STS, Athena, etc.).
- **Subnets and security groups** - isolate data resources in private subnets. Glue connections / EMR clusters in VPC.
- **AWS PrivateLink** for cross-account / cross-VPC service consumption without traversing the internet.

### Governance, compliance, audit

- **AWS Config** - posture, conformance packs (HIPAA, PCI, NIST), remediation
- **Amazon Macie** - sensitive-data discovery in S3 (PII, credentials, keys). Use to find unintended PII before granting broad lake access.
  - **[📖 Macie User Guide](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)**
- **AWS CloudTrail** - audit log of API calls; CloudTrail Lake for SQL queries on history
- **Amazon GuardDuty** - threat detection
- **AWS Audit Manager** - automated evidence collection for compliance frameworks

### Data sharing

- **Lake Formation cross-account sharing** via LF-Tags (preferred over manual S3 ACLs)
- **Redshift data sharing** between clusters / accounts (RA3 only)
- **AWS Resource Access Manager (RAM)** as the underlying sharing primitive

### Common patterns and exam triggers

- "Encrypt data at rest with our own keys, with audit log" → KMS customer-managed keys + CloudTrail
- "Restrict analysts so they can see only their region's rows" → Lake Formation row-level security (LF-Tags + filter expressions)
- "Identify PII in S3 before opening lake to broader access" → Macie
- "S3 access without traversing the internet" → S3 Gateway endpoint
- "Cross-account lake table sharing without copying data" → Lake Formation cross-account share
- "Audit who queried sensitive table" → CloudTrail data events on Lake Formation + Athena query history

---

## Highest-yield study facts

1. **Parquet over JSON** for any "reduce Athena scan cost" or "optimize columnar query" question.
2. **Partitioning + projection** beat catalog-driven partition discovery on large tables.
3. **Kinesis Data Streams** for sub-second; **Firehose** for managed S3/Redshift/OpenSearch delivery; **MSK** for Kafka compatibility.
4. **DMS** for source database → S3 or Redshift, with full load + CDC. **Zero-ETL** for Aurora → Redshift / OpenSearch when source is Aurora.
5. **Glue Data Catalog** is the metadata layer; **Lake Formation** is the permissions layer.
6. **Iceberg** for ACID + time travel + schema evolution on S3 (favored answer for modern lakehouse).
7. **Step Functions** for AWS-native orchestration; **MWAA** when the team uses Airflow DAGs.
8. **Redshift Serverless** when usage is spiky; **RA3 provisioned** when workload is steady, large, or cost-optimized with reserved capacity.
9. **DynamoDB on-demand** for unpredictable traffic; provisioned (with auto-scaling) for steady, predictable traffic.
10. **Macie + KMS + Lake Formation row/column security + CloudTrail data events** is the canonical "secure and audit a sensitive lake" stack.

---

## What changed vs the retired DAS-C01

- DEA-C01 adds operational databases (DynamoDB, RDS, Aurora) more centrally
- DEA-C01 includes Iceberg / Hudi / Delta lakehouse formats
- DEA-C01 emphasizes Lake Formation governance more heavily
- DEA-C01 is Associate-level (broader, less depth) compared to DAS-C01 Specialty (narrower, deeper)
- DEA-C01 is current; DAS-C01 was retired April 8, 2024

---

## What changed vs the retired DBS-C01

- DEA-C01 adds streaming and analytics (Kinesis, Glue ETL, Athena, EMR)
- DEA-C01 covers fewer database internals (less Aurora replication mechanics, less RDS parameter group depth)
- DEA-C01 is broader-but-shallower; DBS-C01 was a database-deep Specialty
- DBS-C01 was retired April 29, 2024

---

## Suggested companion certs

- **AWS Solutions Architect - Associate (SAA-C03)** - architectural framing for data systems
- **AWS Machine Learning Engineer - Associate (MLA-C01)** - if you build ML pipelines on top of your data lake
- **Databricks Data Engineer Associate** - cross-platform data engineering credential
- **Snowflake SnowPro Core** - non-AWS data warehouse credential

---

## Hands-on practice priorities

If you can only build a few labs, prioritize these:

1. End-to-end pipeline: Kinesis Data Firehose → S3 (Parquet) → Glue Crawler → Athena
2. Glue ETL job that joins three S3 tables, writes Iceberg, and uses job bookmarks
3. DMS full load + CDC from RDS Postgres to S3
4. Lake Formation row-level security with LF-Tags across two analyst personas
5. Step Functions workflow orchestrating a multi-step Glue + EMR + Athena job with retries and DLQs

These exercises hit at least 60% of likely exam scenarios.
