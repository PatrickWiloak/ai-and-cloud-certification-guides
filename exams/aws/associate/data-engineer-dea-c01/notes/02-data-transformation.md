# 02 - Data Transformation and Orchestration (Domain 1, ~17% of exam)

This note covers the transformation and orchestration side of Domain 1. Ingestion is in [01-data-ingestion.md](01-data-ingestion.md).

## AWS Glue ETL

### Glue ETL fundamentals

- **Serverless Spark** (and Python shell) ETL service.
- **Glue 4.0** = Spark 3.3 + Python 3.10. **Glue 5.0** = Spark 3.5.
- **Worker types:** G.1X, G.2X, G.4X, G.8X (memory-optimized) and G.025X (Python shell only).
- **Job types:**
  - **Spark** - the main ETL engine
  - **Spark Streaming** - reads from KDS / MSK
  - **Python shell** - lightweight non-Spark scripts
  - **Ray** - distributed Python (newer)
- **Glue Studio** - visual job builder. **Glue notebooks** - interactive Jupyter on Glue.

**[📖 Glue ETL Programming Guide](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming.html)**

### DynamicFrame vs DataFrame

- **DynamicFrame** is Glue's flexible-schema abstraction. Useful when the source has heterogeneous or unknown schema (semi-structured JSON, evolving CSVs).
- **DataFrame** is standard Spark. Better when the schema is known and stable, and when you want full Spark SQL.
- Convert with `dynamicFrame.toDF()` and `DynamicFrame.fromDF()`.

### Job bookmarks

- Track which input data has already been processed so re-runs only pick up new files / records.
- Configurable per job: ENABLE, DISABLE, PAUSE.
- Use to avoid reprocessing the same S3 partitions on every run.

### Push-down predicates

- For partitioned data, push partition filters into Glue's catalog read so only matching partitions are loaded.
- Massive cost / time savings on large lakes.

### Glue Data Catalog

- The Hive-metastore-compatible catalog used by Athena, Redshift Spectrum, EMR, and Glue ETL.
- Stores tables, columns, partitions, classifiers, connections, and resource policies.

### Connections

- VPC-aware connectors to RDS, Redshift, JDBC, Kafka, Kinesis, etc.
- Required for ETL jobs that need to talk to private subnets.

### Common Glue exam triggers

- "Visual ETL with no Spark code" → Glue Studio
- "Skip already-processed input on next run" → Job bookmarks
- "Read only 2 of 365 partitions" → Push-down predicate
- "Schema flexibility for messy JSON" → DynamicFrame
- "Spark ML preprocessing" → Glue with PySpark / G.2X workers

---

## Amazon EMR

### EMR variants

| Variant | When to use |
|---|---|
| **EMR on EC2** | Long-running clusters, custom AMIs, transient batch with Spot |
| **EMR Serverless** | Spark / Hive jobs without managing cluster |
| **EMR on EKS** | You already run Kubernetes platforms |
| **EMR on Outposts** | On-prem hardware with AWS-managed control plane |

**[📖 EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)**
**[📖 EMR Serverless](https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/emr-serverless.html)**

### EMR cluster economics

- **Instance fleets** vs instance groups. Fleets allow mixed types and Spot+On-Demand mix.
- **Spot** for task nodes (recoverable). On-Demand or Reserved for core nodes (HDFS data).
- **Auto-termination** after N minutes idle. Critical for cost control.
- **Managed scaling** scales core/task nodes within configured min/max.

### Storage on EMR

- **HDFS** on core nodes (lost when cluster terminates unless you use long-running HDFS).
- **EMRFS** = S3-backed Hadoop-compatible filesystem. The standard pattern: keep data in S3, use HDFS only as scratch.
- **EMRFS consistent view** is no longer needed (S3 is strongly consistent for new writes since Dec 2020).

### EMR application stack

- **Apache Spark** for general compute and SQL
- **Apache Hive** for HQL on the catalog
- **Presto / Trino** for interactive SQL (Athena uses a managed Trino)
- **Apache HBase** for wide-column NoSQL on HDFS / S3
- **Hudi / Iceberg / Delta** lakehouse table format support
- **JupyterHub / Hue / Zeppelin** notebook UIs

### EMR exam triggers

- "Hadoop ecosystem with Spark and Hive, full control" → EMR on EC2
- "Spark batch jobs without cluster management" → EMR Serverless
- "Save 70% on transient ETL" → EMR with Spot task nodes + auto-termination
- "Already running Kubernetes" → EMR on EKS
- "Long-running HBase cluster" → EMR on EC2 with HBase, persistent HDFS

---

## AWS Lambda for transformation

- **15-minute max execution.** Up to 10 GB memory (also scales CPU). Up to 10 GB ephemeral `/tmp`.
- Common ETL roles:
  - Firehose data transformer (per-record, sub-second)
  - S3 trigger → small-record transform / fanout
  - Step Functions task for lightweight steps
- **Not the right tool** for large-scale Spark-style joins or shuffle-heavy work.

---

## AWS Step Functions

### Standard vs Express

- **Standard** - up to 1 year, durable, exactly-once. ~25 transitions/s. Use for ETL / batch orchestration.
- **Express** - up to 5 minutes, at-least-once or at-most-once. ~100k/s. Use for high-volume event processing.

**[📖 Step Functions Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)**

### Direct integrations

- Glue (start job, wait for completion)
- EMR (run step, run job flow)
- Lambda
- DynamoDB / S3 / SQS / SNS
- ECS / Fargate
- Athena (start query, get results)
- API Gateway

### Workflow patterns

- **Catch / Retry** for error handling per state
- **Map** state for parallel iteration over a list
- **Parallel** state for fan-out
- **Wait** for time-based delays
- **Choice** for branching

### Exam triggers

- "Coordinate Glue + EMR + Lambda + Athena with retries" → Step Functions Standard
- "10k events/sec event router" → Step Functions Express
- "Process each record in an S3 file in parallel" → Distributed Map

---

## Amazon MWAA (Managed Workflows for Apache Airflow)

- Managed Apache Airflow. DAG-based orchestration in Python.
- Use when:
  - The team already has Airflow expertise
  - You need rich Airflow operator ecosystem
  - You want DAG visualization, retries, SLAs, scheduling out of the box
- Charge model: environment hours + worker capacity.

### MWAA vs Step Functions

| Use case | Tool |
|---|---|
| Heavy AWS-native integration, no Airflow team | Step Functions |
| Existing Airflow DAGs, broad open-source operator ecosystem | MWAA |
| Cost-sensitive low-volume orchestration | Step Functions (event-driven, no idle cost) |
| Long-running scheduled DAGs across many systems | MWAA |

---

## Amazon EventBridge

- Event bus for event-driven architectures.
- **Default bus** for AWS service events. **Custom buses** for app events. **Partner buses** for SaaS.
- **Rules** route events to targets (Lambda, Step Functions, SQS, Kinesis, etc.).
- **Schedules** replace older CloudWatch Events rules; supports cron / rate / one-time.
- **EventBridge Pipes:** point-to-point with optional filter, transform (input template), enrich step.
- **EventBridge Schemas Registry** for event schema discovery.

### Common pipeline uses

- React to S3 object created → start a Glue Job
- Schedule a Step Functions workflow nightly
- Pipe MSK / Kinesis events through filter → enrichment → SQS

---

## Common transformation patterns

### Streaming ETL

```
Producers → KDS → Lambda or Flink → S3 (Parquet via Firehose)
                                  → DynamoDB (state)
                                  → OpenSearch (search/analytics)
```

### Batch ETL with Iceberg

```
S3 raw → Glue ETL (Spark) → S3 Iceberg (curated)
                          → Glue Data Catalog
                          → Athena / Redshift Spectrum / EMR consumers
```

### Database CDC to lakehouse

```
RDS Postgres → DMS (full load + CDC) → S3 → Glue ETL → Iceberg
                                                    → Lake Formation permissions
```

### Multi-source orchestration

```
Step Functions:
  └─ Map (per source)
      ├─ Glue Crawler (discover)
      ├─ Glue ETL (transform to Parquet)
      └─ Athena CTAS (publish)
  └─ Lambda (notify on completion)
  └─ Catch (DLQ on failure)
```

---

## Cost optimization

- Glue: prefer **G.1X** unless memory pressure forces larger workers. Use job bookmarks. Push-down predicates.
- EMR: Spot for task nodes, auto-termination, Graviton (m7g/r7g) instances.
- EMR Serverless: pre-initialized capacity if jobs are bursty and latency-sensitive; dynamic if they're spiky.
- Step Functions: use Express for high-frequency low-duration workflows (10x cheaper than Standard).
- Lambda: right-size memory; CPU scales with memory.
