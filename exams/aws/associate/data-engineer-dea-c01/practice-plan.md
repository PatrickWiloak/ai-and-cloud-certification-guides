# AWS Data Engineer Associate (DEA-C01) - 6-Week Study Plan

## Overview

A structured 6-week plan with daily checkbox tasks covering all 4 exam domains. Each day targets 1.5-2 hours of focused study. Adjust pace based on your experience level.

**Exam Domains and Weights:**
| Domain | Weight |
|--------|--------|
| 1. Data Ingestion and Transformation | 34% |
| 2. Data Store Management | 26% |
| 3. Data Operations and Support | 22% |
| 4. Data Security and Governance | 18% |

**Resources:**
- **[DEA-C01 Exam Guide](https://aws.amazon.com/certification/certified-data-engineer-associate/)** - Official exam page
- **[AWS Skill Builder](https://skillbuilder.aws/)** - Free exam prep courses
- Study notes in the `notes/` directory alongside this plan

---

## Week 1: Data Ingestion - Streaming and Migration (Domain 1)

### Monday - Amazon Kinesis Data Streams
- [ ] Read Kinesis Data Streams key concepts: streams, shards, records, partition keys
- [ ] Understand shard throughput limits: 1 MB/s write, 2 MB/s read per shard
- [ ] Study producers: AWS SDK (PutRecord/PutRecords), KPL, Kinesis Agent
- [ ] Study consumers: KCL, Lambda, enhanced fan-out (dedicated 2 MB/s per consumer)
- [ ] Review retention periods: 24 hours default, configurable up to 365 days
- [ ] Read `notes/01-data-ingestion.md` - Kinesis Data Streams section

### Tuesday - Amazon Kinesis Data Firehose
- [ ] Understand Firehose delivery destinations: S3, Redshift, OpenSearch, HTTP, Splunk
- [ ] Study buffering configuration: size (1-128 MB) and interval (60-900 seconds)
- [ ] Learn Lambda-based data transformation within Firehose
- [ ] Understand format conversion: JSON to Parquet/ORC using Glue Data Catalog schema
- [ ] Compare Firehose (near real-time, fully managed) vs Data Streams (real-time, custom)
- [ ] Read `notes/01-data-ingestion.md` - Firehose section

### Wednesday - Amazon Kinesis Data Analytics
- [ ] Study SQL-based analytics on streaming data with in-application streams
- [ ] Understand Apache Flink applications in Kinesis Data Analytics
- [ ] Learn about reference data tables for stream enrichment
- [ ] Review tumbling windows, sliding windows, and stagger windows
- [ ] Identify when to use Kinesis Analytics vs Lambda for stream processing

### Thursday - AWS DMS (Database Migration Service)
- [ ] Understand migration types: full load, CDC, full load + CDC
- [ ] Study source and target endpoint configuration
- [ ] Learn about replication instances and right-sizing
- [ ] Review task settings, table mappings, and selection rules
- [ ] Understand CDC prerequisites: binary logging on source databases
- [ ] Read `notes/01-data-ingestion.md` - DMS section

### Friday - AWS DataSync and Amazon AppFlow
- [ ] Study DataSync for on-premises to AWS transfers: NFS, SMB, HDFS to S3/EFS/FSx
- [ ] Understand DataSync agents, scheduling, and bandwidth throttling
- [ ] Learn Amazon AppFlow for SaaS integrations: Salesforce, SAP, Google Analytics to S3/Redshift
- [ ] Compare DataSync (storage transfer) vs DMS (database migration) vs Transfer Family (SFTP)
- [ ] Read `notes/01-data-ingestion.md` - DataSync and AppFlow sections

### Saturday - Batch vs Streaming Ingestion Patterns
- [ ] Review batch patterns: Glue ETL, DMS full load, EMR, Redshift COPY
- [ ] Review streaming patterns: Kinesis Streams, Kinesis Firehose, MSK, DynamoDB Streams
- [ ] Study CDC patterns: DMS CDC, DynamoDB Streams, Kinesis as CDC target
- [ ] Create a comparison chart of ingestion services mapped to use cases
- [ ] Complete 15 practice questions on data ingestion topics
- [ ] Read `notes/01-data-ingestion.md` - Batch vs Streaming section

### Sunday - Week 1 Review and Consolidation
- [ ] Review all Kinesis service differences (Streams vs Firehose vs Analytics)
- [ ] Quiz yourself on DMS migration types and CDC requirements
- [ ] Summarize DataSync vs DMS vs AppFlow decision criteria
- [ ] Re-read notes on weak areas from the week
- [ ] Complete 15 practice questions covering all Week 1 topics

---

## Week 2: Data Transformation and ETL (Domain 1 continued)

### Monday - AWS Glue ETL Jobs
- [ ] Study Glue ETL job types: Spark (PySpark/Scala), Python Shell, Ray
- [ ] Understand DynamicFrames vs Spark DataFrames in Glue
- [ ] Learn Glue job bookmarks for incremental data processing
- [ ] Study DPU allocation, auto-scaling, and job metrics
- [ ] Review Glue job parameters, timeouts, and retry configuration

### Tuesday - AWS Glue Crawlers and Data Catalog
- [ ] Understand how crawlers discover schemas from S3, JDBC, DynamoDB sources
- [ ] Study Data Catalog structure: databases, tables, partitions, versions
- [ ] Learn about classifiers (built-in and custom) for schema detection
- [ ] Review crawler scheduling, recrawl policies, and schema change handling
- [ ] Understand Data Catalog as the Hive-compatible metastore for Athena, EMR, Redshift Spectrum

### Wednesday - AWS Glue DataBrew
- [ ] Study DataBrew projects, datasets, recipes, and jobs
- [ ] Understand visual data profiling and data quality statistics
- [ ] Learn DataBrew transformations: clean, normalize, encode, aggregate
- [ ] Review recipe publishing, versioning, and scheduling
- [ ] Compare DataBrew (no-code/visual) vs Glue ETL (code-based) use cases
- [ ] Read `notes/02-data-transformation.md` - DataBrew section

### Thursday - Amazon EMR (Spark and Hive)
- [ ] Study EMR cluster architecture: primary, core, and task nodes
- [ ] Understand Apache Spark on EMR: RDDs, DataFrames, SparkSQL
- [ ] Learn Apache Hive on EMR for SQL-based transformations and HiveQL
- [ ] Review EMR instance fleets vs instance groups, Spot instances
- [ ] Study EMR Serverless and EMR on EKS deployment options
- [ ] Read `notes/02-data-transformation.md` - EMR section

### Friday - AWS Lambda for Lightweight Transforms
- [ ] Study Lambda event sources for data: S3, Kinesis, SQS, DynamoDB Streams
- [ ] Understand Lambda limits: 15 min timeout, 10 GB memory, 10 GB ephemeral storage
- [ ] Learn Lambda layers for shared libraries and Lambda destinations
- [ ] Review concurrency models: reserved, provisioned, unreserved
- [ ] Identify when Lambda is appropriate vs Glue ETL or EMR
- [ ] Read `notes/02-data-transformation.md` - Lambda section

### Saturday - Orchestration: Step Functions and MWAA
- [ ] Study Step Functions state types: Task, Choice, Parallel, Map, Wait, Pass, Fail, Succeed
- [ ] Understand Standard (long-running) vs Express (high-volume) workflows
- [ ] Learn MWAA (Managed Apache Airflow) DAGs, operators, and sensors
- [ ] Compare Step Functions (AWS-native, per-transition pricing) vs MWAA (Airflow, per-hour pricing)
- [ ] Review Glue Workflows as a Glue-centric orchestration alternative
- [ ] Read `notes/02-data-transformation.md` - Step Functions and MWAA sections

### Sunday - Week 2 Review and Consolidation
- [ ] Summarize ETL vs ELT patterns and when to use each approach
- [ ] Create a decision tree: Lambda vs Glue ETL vs EMR for transformations
- [ ] Review orchestration options: Step Functions vs MWAA vs Glue Workflows vs EventBridge
- [ ] Complete 20 practice questions on data transformation topics

---

## Week 3: Data Stores - S3, Redshift, and Formats (Domain 2)

### Monday - Amazon S3 as a Data Lake Foundation
- [ ] Study S3 storage classes: Standard, IA, One Zone-IA, Glacier Instant/Flexible/Deep Archive
- [ ] Understand lifecycle policies for automated data tiering between classes
- [ ] Learn S3 versioning, object lock, and MFA delete for data protection
- [ ] Review S3 event notifications triggering Lambda, SQS, SNS, or EventBridge
- [ ] Study S3 inventory, analytics, and Storage Lens for optimization
- [ ] Read `notes/03-data-stores.md` - S3 section

### Tuesday - S3 Data Lake Patterns and File Formats
- [ ] Study Hive-style partitioning: `s3://bucket/year=2024/month=01/day=15/`
- [ ] Understand columnar formats: Parquet (Athena/Spark optimized) and ORC (Hive optimized)
- [ ] Compare row-based formats: Avro (schema evolution), JSON, CSV
- [ ] Learn data compaction strategies for small files problem
- [ ] Study medallion architecture: raw/bronze, curated/silver, consumption/gold layers
- [ ] Read `notes/03-data-stores.md` - Partitioning and Formats section

### Wednesday - Amazon Redshift Architecture
- [ ] Study Redshift cluster architecture: leader node, compute nodes, slices
- [ ] Understand node types: RA3 (managed storage) vs DC2 (dense compute, local SSD)
- [ ] Learn distribution styles: EVEN, KEY, ALL, AUTO and their performance impact
- [ ] Review sort keys: compound (prefix queries) vs interleaved (multi-column)
- [ ] Study workload management (WLM), concurrency scaling, and query queues
- [ ] Read `notes/03-data-stores.md` - Redshift Architecture section

### Thursday - Redshift Loading, Querying, and Spectrum
- [ ] Master the COPY command for bulk loading from S3 (manifest files, compression)
- [ ] Understand UNLOAD for exporting Redshift data to S3
- [ ] Study Redshift Spectrum: external schemas, external tables, query S3 from Redshift
- [ ] Learn materialized views with automatic refresh
- [ ] Review data sharing across clusters and accounts
- [ ] Read `notes/03-data-stores.md` - Redshift Operations section

### Friday - Redshift Serverless and Advanced Features
- [ ] Study Redshift Serverless: RPU-based compute, auto-scaling, no cluster management
- [ ] Understand Redshift Streaming Ingestion from Kinesis and MSK
- [ ] Learn Redshift ML for in-database machine learning with SageMaker
- [ ] Review Redshift federated queries to RDS and Aurora
- [ ] Compare Redshift provisioned vs Serverless use cases and pricing

### Saturday - Hands-on Lab Day
- [ ] Create an S3 bucket with Hive-style partitioned data in Parquet format
- [ ] Set up a Redshift Serverless endpoint (or provisioned cluster via Free Trial)
- [ ] Load data from S3 into Redshift using COPY command
- [ ] Create external tables and run Redshift Spectrum queries
- [ ] Configure an S3 lifecycle policy transitioning data to Glacier after 90 days
- [ ] Complete 15 practice questions on S3 and Redshift

### Sunday - Week 3 Review and Consolidation
- [ ] Compare Redshift provisioned vs Serverless: when to choose each
- [ ] Review S3 storage class transitions and lifecycle policy rules
- [ ] Summarize data loading best practices: COPY, Spectrum, streaming ingestion
- [ ] Review file format trade-offs: Parquet vs ORC vs Avro vs JSON vs CSV
- [ ] Complete 15 practice questions covering all Week 3 topics

---

## Week 4: Data Stores - Athena, DynamoDB, RDS, Lake Formation (Domain 2 continued)

### Monday - Amazon Athena Fundamentals
- [ ] Study Athena serverless architecture and pay-per-query pricing ($5 per TB scanned)
- [ ] Understand Athena workgroups for cost control, access management, and query limits
- [ ] Learn partition projection to avoid MSCK REPAIR TABLE overhead
- [ ] Review performance tuning: partitioning, columnar formats, compression, bucketing
- [ ] Read `notes/03-data-stores.md` - Athena section

### Tuesday - Athena Advanced Features
- [ ] Study Athena federated queries with Lambda-based data source connectors
- [ ] Understand CTAS (CREATE TABLE AS SELECT) for data transformation and format conversion
- [ ] Learn about Athena views, prepared statements, and parameterized queries
- [ ] Review Athena integration with Glue Data Catalog for schema management
- [ ] Practice writing cost-optimized queries (SELECT specific columns, use partitions)

### Wednesday - Amazon DynamoDB for Data Engineering
- [ ] Study DynamoDB table design: partition keys, sort keys, LSIs, GSIs
- [ ] Understand DynamoDB Streams for change data capture (24-hour retention)
- [ ] Learn DynamoDB export to S3 for analytics (full export, incremental export)
- [ ] Review capacity modes: provisioned (with auto-scaling) vs on-demand
- [ ] Study global tables for multi-region replication
- [ ] Read `notes/03-data-stores.md` - DynamoDB section

### Thursday - Amazon RDS, Aurora, and Database Integration
- [ ] Study RDS engines: MySQL, PostgreSQL, SQL Server, Oracle, MariaDB
- [ ] Understand Aurora architecture: shared storage, up to 15 read replicas, multi-AZ
- [ ] Learn Aurora Serverless v2 for variable workloads with auto-scaling
- [ ] Review RDS/Aurora as sources for Glue ETL (JDBC connections) and DMS
- [ ] Study RDS Proxy for connection pooling in serverless architectures
- [ ] Read `notes/03-data-stores.md` - RDS/Aurora section

### Friday - AWS Lake Formation
- [ ] Study Lake Formation architecture: data lake registration, blueprints, workflows
- [ ] Understand the Lake Formation permissions model vs traditional S3/IAM policies
- [ ] Learn LF-Tags for scalable tag-based access control
- [ ] Review data filters for column-level and row-level security
- [ ] Study cross-account data sharing using Lake Formation and RAM
- [ ] Read `notes/03-data-stores.md` - Lake Formation section

### Saturday - Hands-on Lab Day
- [ ] Create an Athena workgroup and run queries on partitioned S3 data
- [ ] Set up partition projection on an Athena table
- [ ] Create a DynamoDB table with Streams, export data to S3
- [ ] Configure Lake Formation permissions on Glue Data Catalog tables
- [ ] Run a federated query from Athena to a DynamoDB data source
- [ ] Complete 15 practice questions on Athena, DynamoDB, and Lake Formation

### Sunday - Week 4 Review and Consolidation
- [ ] Build a data store selection decision tree: S3 vs Redshift vs Athena vs DynamoDB vs RDS
- [ ] Review Lake Formation permissions model vs IAM-based S3 access control
- [ ] Compare CDC options: DynamoDB Streams vs Kinesis vs DMS
- [ ] Summarize Athena optimization techniques
- [ ] Complete 20 practice questions covering all Domain 2 topics

---

## Week 5: Data Operations, Monitoring, and Quality (Domain 3)

### Monday - Step Functions Deep Dive for Data Pipelines
- [ ] Study Step Functions Workflow Studio for visual design
- [ ] Understand error handling: Retry (with backoff), Catch, and Fallback states
- [ ] Learn Map state for parallel iteration over datasets
- [ ] Review native service integrations: Glue, EMR, Lambda, Athena, Redshift Data API
- [ ] Study Step Functions input/output processing with JSONPath

### Tuesday - Amazon MWAA (Managed Apache Airflow)
- [ ] Study MWAA environment configuration: environment class, min/max workers
- [ ] Understand DAG structure: tasks, operators, sensors, dependencies, XComs
- [ ] Learn about Airflow connections and variables for AWS service integration
- [ ] Review DAG deployment via S3 bucket, requirements.txt for Python dependencies
- [ ] Compare MWAA pricing (per environment-hour) vs Step Functions (per state transition)
- [ ] Read `notes/02-data-transformation.md` - MWAA section

### Wednesday - CloudWatch Monitoring for Data Pipelines
- [ ] Study CloudWatch metrics for Glue, Kinesis, Redshift, EMR, Lambda
- [ ] Understand CloudWatch Alarms with SNS notifications for pipeline alerts
- [ ] Learn CloudWatch Logs Insights for querying Glue and Lambda logs
- [ ] Review CloudWatch dashboards for centralized pipeline monitoring
- [ ] Study CloudWatch contributor insights for identifying top-N contributors

### Thursday - Data Quality and Validation
- [ ] Study AWS Glue Data Quality rules and DQDL (Data Quality Definition Language)
- [ ] Understand quality dimensions: completeness, uniqueness, freshness, accuracy, consistency
- [ ] Learn about Glue Data Quality recommendations (auto-suggested rules)
- [ ] Review data quality gates in pipelines: fail, warn, or quarantine bad data
- [ ] Study CloudWatch integration for data quality metric alerting

### Friday - EventBridge and Event-Driven Pipelines
- [ ] Study EventBridge rules, event patterns, and target configuration
- [ ] Understand EventBridge Scheduler for cron-based and rate-based schedules
- [ ] Learn S3 event notifications triggering Lambda, Step Functions, or Glue
- [ ] Review event-driven architecture patterns for data pipelines
- [ ] Study dead-letter queues (DLQ) and retry policies for failed events

### Saturday - Troubleshooting and Operational Patterns
- [ ] Study common Glue ETL failures: OOM errors, data type mismatches, schema drift
- [ ] Understand Kinesis iterator age metric for detecting consumer lag
- [ ] Learn Redshift query troubleshooting with STL/SVL system tables
- [ ] Review EMR step logs, YARN logs, and application logs for debugging
- [ ] Practice identifying root causes from CloudWatch metrics and log patterns
- [ ] Complete 15 practice questions on data operations and monitoring

### Sunday - Week 5 Review and Consolidation
- [ ] Compare orchestration services: Step Functions vs MWAA vs Glue Workflows vs EventBridge
- [ ] Review monitoring strategy for each major data service
- [ ] Summarize data quality implementation approaches
- [ ] Create a troubleshooting runbook for common pipeline failures
- [ ] Complete 20 practice questions covering all Domain 3 topics

---

## Week 6: Data Security, Governance, and Final Review (Domain 4 + All Domains)

### Monday - IAM for Data Services
- [ ] Study IAM roles for Glue (service role), EMR (instance profile), Lambda (execution role)
- [ ] Understand resource-based policies for S3 buckets, KMS keys, and Lambda functions
- [ ] Learn service-linked roles and cross-service trust relationships
- [ ] Review IAM policy evaluation logic and permission boundaries
- [ ] Study cross-account access patterns: resource policies, assume-role, Organizations
- [ ] Read `notes/04-data-security-governance.md` - IAM section

### Tuesday - Encryption with KMS
- [ ] Study KMS key types: AWS managed keys, customer managed keys (CMK), AWS owned keys
- [ ] Understand envelope encryption: CMK encrypts data key, data key encrypts data
- [ ] Learn S3 encryption options: SSE-S3, SSE-KMS, SSE-C, client-side encryption
- [ ] Review Redshift encryption at rest (KMS/HSM) and in transit (SSL)
- [ ] Study encryption for Kinesis, Glue, EMR, DynamoDB, and RDS
- [ ] Read `notes/04-data-security-governance.md` - Encryption section

### Wednesday - Lake Formation Security Deep Dive
- [ ] Deep dive into Lake Formation permissions model (grant/revoke on databases, tables, columns)
- [ ] Study LF-Tags: creating tags, assigning to resources, tag-based permission policies
- [ ] Understand data filters for row-level security (cell-level = row + column filtering)
- [ ] Learn governed tables and ACID transactions in Lake Formation
- [ ] Review cross-account sharing with Resource Access Manager (RAM)
- [ ] Read `notes/04-data-security-governance.md` - Lake Formation Security section

### Thursday - Audit, Compliance, and Sensitive Data Discovery
- [ ] Study CloudTrail for API auditing: management events, data events, insights events
- [ ] Understand CloudTrail Lake for SQL-based querying of audit events
- [ ] Learn Amazon Macie for PII and sensitive data discovery in S3 buckets
- [ ] Review VPC endpoints (gateway for S3/DynamoDB, interface for other services)
- [ ] Study compliance considerations: data residency, retention, and classification
- [ ] Read `notes/04-data-security-governance.md` - Audit and Compliance section

### Friday - Full Practice Exam #1
- [ ] Take a full-length 65-question practice exam under timed conditions (170 minutes)
- [ ] Score the exam and calculate per-domain accuracy
- [ ] Review all incorrect answers with detailed explanations
- [ ] Create a list of topics needing additional review
- [ ] Re-read study notes for the weakest 2-3 topics

### Saturday - Targeted Review and Practice Exam #2
- [ ] Review weak areas identified from Friday's practice exam
- [ ] Re-study services or concepts with lowest accuracy
- [ ] Take a second full-length practice exam (different question source if possible)
- [ ] Score and compare improvement from the first attempt
- [ ] Complete 20 additional targeted practice questions on weak areas

### Sunday - Final Review and Exam Prep
- [ ] Review the DEA-C01 fact sheet one final time
- [ ] Go through "Common Exam Scenarios" from the fact sheet
- [ ] Review service limits: Kinesis shards, Glue DPUs, Redshift nodes, S3 object sizes
- [ ] Skim all four study notes files for key takeaways
- [ ] Confirm exam logistics: testing center or online proctoring, ID, arrival time
- [ ] Get a good night's rest before exam day

---

## Progress Tracking

### Domain Confidence (Rate 1-5 after each milestone)

| Domain | After Week 2 | After Week 4 | After Week 6 |
|--------|-------------|-------------|-------------|
| 1. Data Ingestion and Transformation (34%) | ___ / 5 | ___ / 5 | ___ / 5 |
| 2. Data Store Management (26%) | ___ / 5 | ___ / 5 | ___ / 5 |
| 3. Data Operations and Support (22%) | ___ / 5 | ___ / 5 | ___ / 5 |
| 4. Data Security and Governance (18%) | ___ / 5 | ___ / 5 | ___ / 5 |

### Practice Exam Scores

| Attempt | Date | Score | Weakest Domain |
|---------|------|-------|----------------|
| 1 | __________ | ___ / 65 | ________________ |
| 2 | __________ | ___ / 65 | ________________ |
| 3 | __________ | ___ / 65 | ________________ |

### Readiness Checklist

- [ ] Scored 80%+ on at least two practice exams
- [ ] Confident in all four domains (rated 4+ out of 5)
- [ ] Completed hands-on labs for core services (Kinesis, Glue, S3, Redshift, Athena, Lake Formation)
- [ ] Reviewed all common exam scenarios from the fact sheet
- [ ] Exam scheduled and logistics confirmed
