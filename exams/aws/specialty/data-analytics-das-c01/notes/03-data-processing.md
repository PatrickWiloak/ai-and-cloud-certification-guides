# Data Processing - AWS Data Analytics Specialty

## Overview

Data processing covers 24% of the DAS-C01 exam - the largest domain. This domain focuses on designing and implementing data processing solutions using both batch and stream processing services.

## Amazon EMR

**[📖 EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)** - Cluster management
**[📖 EMR Release Guide](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-components.html)** - Application versions

### Architecture

- **Master Node (Primary)**: Runs YARN ResourceManager, HDFS NameNode, coordinates cluster
- **Core Nodes**: Run YARN NodeManager, HDFS DataNode, process tasks and store data
- **Task Nodes**: Run YARN NodeManager only, no HDFS - compute only (can use Spot)
- Core nodes should not use Spot instances (HDFS data loss risk)
- Task nodes are ideal for Spot instances (no data loss)

### EMR on EC2 vs EMR Serverless vs EMR on EKS

| Feature | EMR on EC2 | EMR Serverless | EMR on EKS |
|---------|-----------|---------------|------------|
| Infrastructure | You manage cluster | Fully managed | Kubernetes pods |
| Scaling | Auto Scaling policies | Automatic | Kubernetes autoscaler |
| Cost model | Per instance | Per vCPU/memory/sec | Per pod |
| Use case | Complex workloads | Simple jobs | Kubernetes shops |
| Customization | Full (bootstrap actions) | Limited | Container images |

**[📖 EMR Serverless](https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/emr-serverless.html)** - Serverless Spark and Hive

### Apache Spark on EMR

**[📖 Spark on EMR](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark.html)** - Configuration and optimization

**Key Concepts:**
- Distributed data processing engine for batch and streaming
- RDDs, DataFrames, and Datasets as core abstractions
- Lazy evaluation - transformations build a DAG, actions trigger execution
- In-memory processing - much faster than MapReduce for iterative workloads
- Spark SQL for structured data queries
- Spark Streaming (micro-batch) and Structured Streaming

**Performance Tuning:**
- **Partitioning**: Aim for 2-4x partitions per CPU core
- **Caching**: `persist()` for reused DataFrames, choose storage level
- **Broadcast joins**: Broadcast small tables to avoid shuffles
- **Dynamic allocation**: `spark.dynamicAllocation.enabled` for auto-scaling executors
- **Adaptive Query Execution (AQE)**: Auto-optimize joins and skew handling
- **Predicate pushdown**: Push filters to data source (S3/Parquet)
- **Columnar formats**: Parquet for read-heavy, Avro for write-heavy

### Apache Hive on EMR

**[📖 Hive on EMR](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-hive.html)** - SQL-based data warehouse

- SQL interface over Hadoop data
- Tables stored in HDFS or S3
- Uses Glue Data Catalog as metastore (or built-in Hive metastore)
- Partitioned and bucketed tables for query optimization
- ORC format is optimal for Hive
- ACID transactions with managed tables (Hive 3+)
- External tables for data lake queries without data ownership

### Presto/Trino on EMR

**[📖 Presto on EMR](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-presto.html)** - Interactive SQL queries

- Distributed SQL engine for interactive analytics
- Query data where it lives - S3, HDFS, RDS, DynamoDB, Cassandra
- Federated queries across multiple data sources
- Fast for interactive queries (seconds to minutes)
- Memory-based processing - no disk spillover for best performance
- Not suitable for large ETL jobs (Spark is better)

### EMR Cost Optimization

- **Spot Instances**: Use for task nodes (up to 90% savings)
- **Instance Fleets**: Mix instance types for better Spot availability
- **Managed Scaling**: Automatic cluster scaling based on workload
- **S3 Storage**: Use EMRFS (S3) instead of HDFS for persistent data
- **Transient Clusters**: Launch, process, terminate (vs long-running)
- **Graviton Instances**: Up to 30% better price-performance

**[📖 EMR Best Practices](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-instances-guidelines.html)** - Instance planning

## AWS Glue ETL

**[📖 Glue ETL Programming Guide](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)** - ETL development
**[📖 Glue Studio](https://docs.aws.amazon.com/glue/latest/ug/what-is-glue-studio.html)** - Visual ETL authoring

### Key Features

- **Serverless** - No infrastructure to manage
- **DynamicFrame** - Extension of Spark DataFrame with schema flexibility
- **Bookmarks** - Track processed data to avoid reprocessing
- **Job types**: Spark (Python/Scala), Spark Streaming, Ray (Python)
- **Workers**: Standard (1 DPU), G.1X (1 DPU + more memory), G.2X (2 DPU)
- **Auto Scaling**: Adjusts workers based on workload (Glue 3.0+)

### DynamicFrame vs DataFrame

| Feature | DynamicFrame | DataFrame |
|---------|-------------|-----------|
| Schema | Flexible, handles inconsistencies | Fixed schema |
| Null handling | ResolveChoice for ambiguous types | Errors or nulls |
| Transformations | ApplyMapping, ResolveChoice, Relationalize | Standard Spark |
| Performance | Slightly slower | Faster for clean data |

- Convert between them: `toDF()` and `fromDF()`
- Use DynamicFrame when source schema is inconsistent
- Use DataFrame for complex Spark operations

### Common Transformations

- **ApplyMapping**: Rename and retype columns
- **ResolveChoice**: Handle columns with multiple types (cast, make_struct, project)
- **Relationalize**: Flatten nested JSON/arrays into relational tables
- **Filter**: Remove records based on conditions
- **Join**: Combine datasets
- **SelectFields / DropFields**: Column selection

### Glue Job Bookmarks

**[📖 Job Bookmarks](https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html)** - Incremental processing

- Track previously processed data to enable incremental ETL
- Works with S3 (file timestamps), JDBC (primary key columns), DynamoDB
- States: enabled, disabled, pause
- Reset bookmark to reprocess all data
- Only processes new data since last successful run

### Glue Workflows

- Orchestrate multiple crawlers and ETL jobs
- Define dependencies and execution order
- Trigger-based: schedule, on-demand, or conditional
- Visual workflow designer in Glue Studio
- Alternative: Step Functions for more complex orchestration

## AWS Lambda for Analytics

**[📖 Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)** - Serverless compute

### Analytics Use Cases

- **Kinesis Data Streams consumer**: Process records in micro-batches
- **S3 event processing**: Trigger on object creation for ETL
- **Firehose transformation**: Transform records in-flight
- **DynamoDB Streams consumer**: React to table changes
- **API Gateway backend**: Serve analytics results

### Key Limits for Analytics

- Execution timeout: 15 minutes max
- Memory: 128 MB to 10,240 MB
- Payload: 6 MB synchronous, 256 KB asynchronous
- /tmp storage: 512 MB (configurable to 10 GB)
- Concurrent executions: 1,000 default (request increase)
- Kinesis batch size: up to 10,000 records
- Event source mapping: batch window up to 5 minutes

### Lambda vs Glue ETL vs EMR

| Criteria | Lambda | Glue ETL | EMR |
|----------|--------|----------|-----|
| Data size | Small (MBs) | Medium (GBs-TBs) | Large (TBs-PBs) |
| Duration | < 15 min | Hours | Hours-days |
| Management | Serverless | Serverless | Managed/Self |
| Cost model | Per invocation | Per DPU-hour | Per instance-hour |
| Complexity | Simple transforms | ETL pipelines | Complex analytics |

## AWS Step Functions

**[📖 Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)** - Workflow orchestration

### Analytics Orchestration

- Coordinate multi-step analytics pipelines
- State machine with visual workflow
- Built-in error handling, retries, and branching
- Direct integration with Glue, EMR, Lambda, Athena, ECS
- Standard workflows: up to 1 year, exactly-once execution
- Express workflows: up to 5 minutes, at-least-once (high-volume events)

**Common Pipeline Pattern:**
1. Start Glue Crawler to update catalog
2. Run Glue ETL job for transformation
3. Run Athena query for validation
4. Notify via SNS on completion or failure

**[📖 Step Functions Service Integrations](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-service-integrations.html)** - AWS service integrations

### Step Functions vs Glue Workflows

| Feature | Step Functions | Glue Workflows |
|---------|---------------|----------------|
| Scope | Any AWS service | Glue crawlers/jobs only |
| Error handling | Advanced (retry, catch, fallback) | Basic |
| Visual designer | Yes | Yes |
| Cost | Per state transition | No extra cost |
| Complexity | Any workflow | ETL-specific |

## Kinesis Data Analytics (Processing Context)

**[📖 Kinesis Analytics SQL Reference](https://docs.aws.amazon.com/kinesisanalytics/latest/sqlref/analytics-sql-reference.html)** - SQL functions

### Windowed Queries

- **Tumbling Window**: Fixed-size, non-overlapping time intervals
  - Example: Aggregate every 60 seconds
  - `GROUP BY STEP(event_time BY INTERVAL '60' SECOND)`
- **Sliding Window**: Fixed-size, overlapping intervals
  - Example: Count over last 10 minutes, updated every minute
  - `WINDOW w AS (RANGE INTERVAL '10' MINUTE PRECEDING)`
- **Stagger Window**: Groups by partition key and event time
  - Reduces late-arriving data issues
  - Opens window on first event per key

### Anomaly Detection

- `RANDOM_CUT_FOREST` function for real-time anomaly detection
- Unsupervised ML algorithm built into Kinesis Analytics SQL
- Returns anomaly score for each record
- Higher score indicates more anomalous

## Processing Decision Tree

| Scenario | Service |
|----------|---------|
| Simple event-driven transform (< 15 min) | Lambda |
| Serverless ETL with schema flexibility | Glue ETL |
| Large-scale batch processing (PB-scale) | EMR Spark |
| Interactive SQL on diverse data sources | EMR Presto/Trino |
| Real-time stream processing (SQL) | Kinesis Data Analytics |
| Real-time stream processing (complex) | Kinesis Data Analytics (Flink) |
| Multi-step pipeline orchestration | Step Functions |
| Glue-only pipeline orchestration | Glue Workflows |

## Common Exam Patterns

1. **"Serverless ETL"** - Glue ETL (not EMR)
2. **"Petabyte-scale processing"** - EMR with Spark
3. **"Cost-optimize EMR"** - Spot for task nodes, transient clusters, S3 instead of HDFS
4. **"Incremental processing"** - Glue job bookmarks
5. **"Flatten nested JSON"** - Glue Relationalize transform
6. **"Orchestrate analytics pipeline"** - Step Functions
7. **"Interactive queries across data sources"** - EMR Presto/Trino
8. **"Real-time anomaly detection"** - Kinesis Analytics RANDOM_CUT_FOREST
9. **"Schema inconsistencies in ETL"** - Glue DynamicFrame with ResolveChoice
10. **"Event-driven processing on S3 uploads"** - Lambda triggered by S3 events
