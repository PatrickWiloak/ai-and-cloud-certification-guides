# AWS Certified Data Engineer - Associate (DEA-C01) Fact Sheet

## Quick Reference

**Exam Code:** DEA-C01
**Duration:** 170 minutes
**Questions:** 65 scored questions
**Passing Score:** 720/1000
**Cost:** $150 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (Testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Data Ingestion and Transformation | 34% | Kinesis, Glue, MSK, DMS, Step Functions |
| Data Store Management | 26% | S3, Redshift, DynamoDB, RDS, Lake Formation |
| Data Operations and Support | 22% | MWAA, Step Functions, CloudWatch, Data Quality |
| Data Security and Governance | 18% | IAM, Lake Formation, KMS, encryption, compliance |

## Core Services to Master

### Data Ingestion and Transformation (34%)
- **Amazon Kinesis** - Real-time data streaming and analytics
  - **[📖 Kinesis Data Streams Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/)** - Complete Kinesis Data Streams documentation
  - **[📖 Kinesis Data Firehose User Guide](https://docs.aws.amazon.com/firehose/latest/dev/)** - Delivery stream configuration and destinations
  - **[📖 Kinesis Data Analytics Developer Guide](https://docs.aws.amazon.com/kinesisanalytics/latest/dev/)** - SQL and Apache Flink analytics
  - **[📖 Kinesis Scaling and Resharding](https://docs.aws.amazon.com/streams/latest/dev/kinesis-record-processor-scaling.html)** - Shard management and throughput
- **AWS Glue** - Serverless ETL and data catalog
  - **[📖 AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/)** - Complete Glue documentation
  - **[📖 Glue ETL Programming Guide](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)** - PySpark and Scala ETL scripts
  - **[📖 Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)** - Metadata catalog and crawlers
  - **[📖 Glue Job Bookmarks](https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html)** - Incremental data processing
- **Amazon MSK** - Managed Apache Kafka
  - **[📖 Amazon MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/)** - Complete MSK documentation
  - **[📖 MSK Connect](https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect.html)** - Managed Kafka Connect connectors
  - **[📖 MSK Serverless](https://docs.aws.amazon.com/msk/latest/developerguide/serverless.html)** - Serverless Kafka clusters
- **AWS DMS** - Database Migration Service
  - **[📖 AWS DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/)** - Complete DMS documentation
  - **[📖 DMS Migration Tasks](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.html)** - Full load, CDC, and ongoing replication
  - **[📖 DMS Source and Target Endpoints](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html)** - Supported databases and configurations
- **AWS DataSync** - Data transfer automation
  - **[📖 AWS DataSync User Guide](https://docs.aws.amazon.com/datasync/latest/userguide/)** - Automated data transfer between storage systems
  - **[📖 DataSync Task Configuration](https://docs.aws.amazon.com/datasync/latest/userguide/creating-task.html)** - Transfer task setup and scheduling
- **AWS Step Functions** - Workflow orchestration for data pipelines
  - **[📖 Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/)** - Complete Step Functions documentation
  - **[📖 Step Functions Workflow Studio](https://docs.aws.amazon.com/step-functions/latest/dg/workflow-studio.html)** - Visual workflow designer
  - **[📖 Step Functions Error Handling](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html)** - Retry and catch configurations
- **AWS Lambda** - Serverless data transformation
  - **[📖 Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)** - Complete Lambda documentation
  - **[📖 Lambda with Kinesis](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html)** - Stream processing with Lambda
  - **[📖 Lambda with S3](https://docs.aws.amazon.com/lambda/latest/dg/with-s3.html)** - Event-driven file processing

### Data Store Management (26%)
- **Amazon S3** - Data lake storage foundation
  - **[📖 Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/)** - Complete S3 documentation
  - **[📖 S3 Storage Classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)** - Standard, IA, Glacier tiers
  - **[📖 S3 Lifecycle Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)** - Automated data tiering
  - **[📖 S3 Select and Glacier Select](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)** - Query data in place
- **Amazon Redshift** - Cloud data warehouse
  - **[📖 Amazon Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/)** - Complete Redshift documentation
  - **[📖 Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)** - Query data in S3 without loading
  - **[📖 Redshift Data Sharing](https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html)** - Cross-cluster data sharing
  - **[📖 Redshift Serverless](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-serverless.html)** - Serverless data warehouse
- **Amazon DynamoDB** - NoSQL database for high-throughput workloads
  - **[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/)** - Complete DynamoDB documentation
  - **[📖 DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)** - Change data capture
  - **[📖 DynamoDB Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)** - Multi-region replication
- **Amazon RDS/Aurora** - Managed relational databases
  - **[📖 Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/)** - Complete RDS documentation
  - **[📖 Amazon Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)** - Aurora-specific features
  - **[📖 Aurora Serverless](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)** - Auto-scaling Aurora
- **Amazon Athena** - Serverless SQL queries on S3
  - **[📖 Amazon Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/)** - Complete Athena documentation
  - **[📖 Athena Performance Tuning](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)** - Query optimization
  - **[📖 Athena Federated Query](https://docs.aws.amazon.com/athena/latest/ug/connect-to-a-data-source.html)** - Query across data sources
- **Amazon OpenSearch Service** - Search and log analytics
  - **[📖 Amazon OpenSearch Service Developer Guide](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/)** - Complete OpenSearch documentation
  - **[📖 OpenSearch Ingestion](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ingestion.html)** - Data ingestion pipelines
- **AWS Lake Formation** - Data lake management and governance
  - **[📖 AWS Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/)** - Complete Lake Formation documentation
  - **[📖 Lake Formation Permissions](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)** - Fine-grained access control
  - **[📖 Lake Formation Data Filters](https://docs.aws.amazon.com/lake-formation/latest/dg/data-filters-about.html)** - Column and row-level security

### Data Operations and Support (22%)
- **Amazon MWAA** - Managed Workflows for Apache Airflow
  - **[📖 Amazon MWAA User Guide](https://docs.aws.amazon.com/mwaa/latest/userguide/)** - Complete MWAA documentation
  - **[📖 MWAA Apache Airflow CLI](https://docs.aws.amazon.com/mwaa/latest/userguide/airflow-cli-command-reference.html)** - Airflow CLI reference
  - **[📖 MWAA DAG Writing Best Practices](https://docs.aws.amazon.com/mwaa/latest/userguide/best-practices-tuning.html)** - DAG optimization
- **AWS CloudWatch** - Monitoring and observability
  - **[📖 CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/)** - Complete CloudWatch documentation
  - **[📖 CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/)** - Log aggregation and analysis
  - **[📖 CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Metric alarms and notifications
- **AWS CloudTrail** - API activity logging
  - **[📖 CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/)** - Complete CloudTrail documentation
  - **[📖 CloudTrail Lake](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake.html)** - Query and analyze events
- **Amazon EventBridge** - Event-driven pipeline orchestration
  - **[📖 EventBridge User Guide](https://docs.aws.amazon.com/eventbridge/latest/userguide/)** - Complete EventBridge documentation
  - **[📖 EventBridge Scheduler](https://docs.aws.amazon.com/scheduler/latest/UserGuide/)** - Scheduled event triggers
- **Amazon QuickSight** - Business intelligence and visualization
  - **[📖 Amazon QuickSight User Guide](https://docs.aws.amazon.com/quicksight/latest/user/)** - Complete QuickSight documentation
  - **[📖 QuickSight SPICE](https://docs.aws.amazon.com/quicksight/latest/user/spice.html)** - In-memory data engine
  - **[📖 QuickSight Data Sources](https://docs.aws.amazon.com/quicksight/latest/user/supported-data-sources.html)** - Supported data connections
- **AWS Glue DataBrew** - Visual data preparation
  - **[📖 AWS Glue DataBrew User Guide](https://docs.aws.amazon.com/databrew/latest/dg/)** - No-code data transformation
  - **[📖 DataBrew Recipes](https://docs.aws.amazon.com/databrew/latest/dg/recipes.html)** - Transformation steps and recipes
- **AWS Data Pipeline** - Data-driven workflow orchestration
  - **[📖 AWS Data Pipeline Developer Guide](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/)** - Complete Data Pipeline documentation

### Data Security and Governance (18%)
- **AWS IAM** - Identity and access management
  - **[📖 IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/)** - Complete IAM documentation
  - **[📖 IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)** - Role-based access for data services
  - **[📖 IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Policy syntax and evaluation
  - **[📖 IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Security guidelines
- **AWS KMS** - Key management and encryption
  - **[📖 KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/)** - Complete KMS documentation
  - **[📖 KMS Key Concepts](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html)** - Keys, aliases, and grants
  - **[📖 KMS Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping)** - Data key encryption pattern
- **AWS Lake Formation** - Data lake security and governance
  - **[📖 Lake Formation Security](https://docs.aws.amazon.com/lake-formation/latest/dg/security.html)** - Security configuration
  - **[📖 Lake Formation Tag-Based Access Control](https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html)** - LF-Tags for permissions
- **AWS Macie** - Sensitive data discovery
  - **[📖 Amazon Macie User Guide](https://docs.aws.amazon.com/macie/latest/user/)** - Complete Macie documentation
  - **[📖 Macie Findings](https://docs.aws.amazon.com/macie/latest/user/findings.html)** - Sensitive data classification
- **AWS CloudTrail** - Audit and compliance logging
  - **[📖 CloudTrail Data Events](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html)** - Data-level API logging

## Service Limits to Know

### Amazon Kinesis Data Streams
- **Shard throughput (write):** 1 MB/sec or 1,000 records/sec per shard
- **Shard throughput (read):** 2 MB/sec per shard
- **Record size:** 1 MB max
- **Retention period:** 24 hours (default), up to 365 days
- **Consumers per shard:** 5 standard, unlimited enhanced fan-out
- **Batch size:** 500 records per PutRecords call

### AWS Glue
- **Max DPUs per job:** 100 (default), can request increase
- **Concurrent job runs:** 50 (default)
- **Crawler timeout:** 48 hours max
- **Data Catalog databases:** 10,000 per account
- **Data Catalog tables:** 1,000,000 per account
- **ETL script size:** 50 KB max

### Amazon Redshift
- **Node types:** dc2 (dense compute), ra3 (managed storage)
- **Max nodes:** 128 per cluster
- **Max databases:** 60 per cluster
- **Max schemas:** 9,900 per database
- **Max tables:** 20,000 per cluster (large node types)
- **COPY command:** Recommended for bulk loading

### Amazon S3 (Data Lake)
- **Object size:** 5 TB max
- **Single PUT:** 5 GB max
- **Multipart upload:** Required for > 5 GB
- **Bucket limit:** 100 buckets per account (default)
- **S3 Select:** Up to 256 MB compressed input
- **Lifecycle rules:** 1,000 per bucket

## Data Ingestion Patterns

### Batch Ingestion
- **AWS Glue ETL** - Scheduled batch jobs for S3/JDBC sources
- **AWS DMS** - Full load migration from databases
- **Amazon EMR** - Large-scale Spark/Hive batch processing
- **COPY command** - Bulk load into Redshift from S3
- **[📖 Glue ETL Jobs](https://docs.aws.amazon.com/glue/latest/dg/author-job.html)** - ETL job authoring
- **[📖 Redshift COPY](https://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html)** - Bulk data loading
- **[📖 EMR Developer Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/)** - Managed Hadoop and Spark

### Real-Time / Streaming Ingestion
- **Kinesis Data Streams** - Custom consumer applications
- **Kinesis Data Firehose** - Auto-delivery to S3, Redshift, OpenSearch
- **Amazon MSK** - Apache Kafka for event streaming
- **DynamoDB Streams** - Change data capture from DynamoDB
- **[📖 Kinesis Firehose Destinations](https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html)** - S3, Redshift, OpenSearch, HTTP
- **[📖 MSK Producers and Consumers](https://docs.aws.amazon.com/msk/latest/developerguide/produce-consume.html)** - Kafka client configuration

### Change Data Capture (CDC)
- **AWS DMS** - Ongoing CDC replication from databases
- **DynamoDB Streams** - Item-level changes from DynamoDB
- **Kinesis Data Streams** - Stream CDC events for processing
- **[📖 DMS CDC](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html)** - Ongoing replication tasks

## Data Transformation Patterns

### ETL vs ELT

| Approach | Description | When to Use | AWS Services |
|----------|-------------|-------------|--------------|
| **ETL** | Extract, Transform, Load | Transform before loading | Glue, EMR, Lambda |
| **ELT** | Extract, Load, Transform | Transform after loading | Redshift, Athena, Redshift Spectrum |

### Data Formats

| Format | Type | Splittable | Schema | Best For |
|--------|------|------------|--------|----------|
| **Parquet** | Columnar | Yes | Embedded | Analytics, Athena, Redshift Spectrum |
| **ORC** | Columnar | Yes | Embedded | Hive/EMR workloads |
| **Avro** | Row-based | Yes | Embedded | Schema evolution, streaming |
| **JSON** | Row-based | Yes (newline-delimited) | Self-describing | APIs, semi-structured data |
| **CSV** | Row-based | Yes | None | Simple data exchange |

**Documentation:**
- **[📖 Athena Supported Formats](https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html)** - SerDe library reference
- **[📖 Glue Format Options](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-format.html)** - ETL format configuration

## Data Partitioning Strategies

### S3 Partitioning
```
s3://data-lake/
  ├── year=2024/month=01/day=15/
  ├── year=2024/month=01/day=16/
  └── year=2024/month=02/day=01/
```

### Partitioning Best Practices
- **Partition by query patterns** - Match how data is accessed
- **Avoid over-partitioning** - Too many small files degrades performance
- **Use Hive-style partitioning** - `key=value` format for automatic discovery
- **Compact small files** - Use Glue or EMR to merge small files
- **Consider partition projection** - Athena feature to avoid MSCKing

**Documentation:**
- **[📖 Athena Partition Projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)** - Automatic partition management
- **[📖 S3 Data Lake Best Practices](https://docs.aws.amazon.com/whitepapers/latest/building-data-lakes/building-data-lake-aws.html)** - Data lake architecture patterns

## Data Pipeline Orchestration

### Orchestration Service Comparison

| Service | Use Case | Complexity | Cost Model |
|---------|----------|------------|------------|
| **Step Functions** | AWS-native workflows | Low-Medium | Per state transition |
| **MWAA (Airflow)** | Complex DAG-based pipelines | High | Per environment hour |
| **EventBridge** | Event-driven triggers | Low | Per event |
| **Glue Workflows** | Glue-centric ETL orchestration | Medium | Per job run |
| **Data Pipeline** | Legacy EC2/EMR workflows | Medium | Per activity |

**Documentation:**
- **[📖 Step Functions for Data Pipelines](https://docs.aws.amazon.com/step-functions/latest/dg/sample-project-data-pipeline.html)** - Data processing workflows
- **[📖 Glue Workflows](https://docs.aws.amazon.com/glue/latest/dg/workflows_overview.html)** - ETL workflow orchestration

## Data Lake Architecture (Lake Formation)

### Lake Formation Components
- **Data Catalog** - Central metadata repository
- **Blueprints** - Automated data ingestion workflows
- **Permissions** - Fine-grained table/column-level access
- **LF-Tags** - Tag-based access control policies
- **Data Filters** - Row and column-level security
- **Cross-Account Sharing** - Share data across AWS accounts

**Documentation:**
- **[📖 Lake Formation Getting Started](https://docs.aws.amazon.com/lake-formation/latest/dg/getting-started-setup.html)** - Initial setup and configuration
- **[📖 Lake Formation Blueprints](https://docs.aws.amazon.com/lake-formation/latest/dg/blueprints.html)** - Automated ingestion workflows
- **[📖 Lake Formation Cross-Account](https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account.html)** - Data sharing across accounts

## Exam Tips - Key Concepts

### Data Ingestion Best Practices
- Use Kinesis Data Streams for custom real-time processing
- Use Kinesis Data Firehose for zero-administration delivery to S3/Redshift
- Use AWS DMS for database migration and ongoing CDC
- Use AWS Glue for batch ETL from diverse sources
- Use Amazon MSK for Apache Kafka-based event streaming

### Data Store Selection
- **S3** - Default data lake storage, most cost-effective at scale
- **Redshift** - Complex analytical queries, joins, aggregations
- **Athena** - Ad-hoc SQL queries on S3 data (no infrastructure)
- **DynamoDB** - Low-latency key-value lookups
- **RDS/Aurora** - Transactional OLTP workloads
- **OpenSearch** - Full-text search and log analytics

### Data Security Best Practices
- Use Lake Formation for centralized data lake permissions
- Enable encryption at rest with KMS for all data stores
- Use IAM roles for service-to-service access
- Enable CloudTrail for audit logging
- Use Macie for sensitive data discovery in S3
- Implement column-level and row-level security with Lake Formation

### Data Operations Best Practices
- Use CloudWatch metrics and alarms for pipeline monitoring
- Implement data quality checks with Glue Data Quality
- Use Step Functions or MWAA for pipeline orchestration
- Implement retry logic and dead-letter queues
- Monitor Glue job bookmarks for incremental processing

## Common Exam Scenarios

1. **"Most cost-effective data lake storage"** - S3 with lifecycle policies and Glacier tiers
2. **"Real-time data ingestion"** - Kinesis Data Streams or Kinesis Data Firehose
3. **"Migrate on-premises database to AWS"** - AWS DMS with CDC for ongoing replication
4. **"Serverless ETL transformation"** - AWS Glue ETL jobs
5. **"Query S3 data without loading"** - Amazon Athena or Redshift Spectrum
6. **"Orchestrate complex data pipelines"** - Step Functions or MWAA (Airflow)
7. **"Fine-grained data lake security"** - AWS Lake Formation with LF-Tags
8. **"Search and analyze logs"** - Amazon OpenSearch Service
9. **"Data warehouse for complex analytics"** - Amazon Redshift
10. **"Discover sensitive data in S3"** - Amazon Macie

## Study Priorities

### High Priority (Must Know)
- AWS Glue ETL jobs, crawlers, and Data Catalog
- Amazon Kinesis Data Streams and Firehose
- Amazon S3 data lake patterns and lifecycle
- Amazon Redshift loading, querying, and Spectrum
- AWS Lake Formation permissions and governance
- Amazon Athena queries and partitioning
- Data pipeline orchestration (Step Functions, MWAA)
- Data encryption and KMS integration

### Medium Priority (Important)
- Amazon MSK and Kafka concepts
- AWS DMS migration and CDC
- Amazon DynamoDB Streams
- Amazon EMR for Spark/Hive workloads
- Amazon QuickSight dashboards and SPICE
- AWS Glue DataBrew for visual transformation
- CloudWatch monitoring for data pipelines
- Amazon EventBridge for event-driven triggers

### Lower Priority (Good to Know)
- AWS Data Pipeline (legacy service)
- AWS DataSync for storage transfer
- Amazon OpenSearch ingestion pipelines
- Redshift Serverless configuration
- Aurora Serverless for variable workloads
- Glue Schema Registry
- CloudTrail Lake for event analysis
- Amazon Macie classification jobs

## Last-Minute Review

**Remember these:**
- Kinesis Data Streams: 1 MB/sec write, 2 MB/sec read per shard
- Kinesis Firehose: Near real-time (60-second minimum buffer)
- Glue job bookmarks: Track processed data for incremental ETL
- Redshift COPY: Best way to load bulk data from S3
- Athena: Charges per TB of data scanned (use partitions and columnar formats)
- Lake Formation: Centralized permissions replace S3/IAM policies
- Parquet/ORC: Columnar formats reduce scan costs in Athena
- S3 lifecycle: Automate data tiering to reduce storage costs

**Common gotchas:**
- Kinesis Data Streams requires manual shard management (vs Firehose auto-scaling)
- Glue crawlers may create too many tables if data is not well-organized
- Redshift Spectrum queries data in S3 but still needs a Redshift cluster
- Athena partition projection eliminates need for MSCK REPAIR TABLE
- Lake Formation permissions can conflict with IAM S3 policies
- DMS CDC requires source database binary logging enabled
- Firehose delivers in micro-batches (not true real-time like Streams)
- MWAA pricing is per environment hour (can be expensive for small workloads)

---

**Good luck on your exam!** Focus on hands-on practice - build actual data pipelines and data lake architectures with these services.
