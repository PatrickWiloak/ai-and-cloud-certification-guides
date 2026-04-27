# 04 - Data Operations and Support (Domain 3, ~22% of exam)

## Amazon Athena

### Athena fundamentals

- Serverless interactive SQL on S3 (and federated sources).
- **Athena V3** uses Trino engine (current default).
- Pay per TB scanned ($5/TB at standard pricing).
- Reads tables defined in Glue Data Catalog or Lake Formation.
- Supports CSV, JSON, Parquet, ORC, Avro, Iceberg, Hudi, Delta.

**[📖 Athena User Guide](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)**

### Cost-reduction levers

1. **Convert to columnar (Parquet/ORC)** with compression. Reduces scan size by 10-100x.
2. **Partition** by predicate columns. Queries only scan matching partitions.
3. **Use partition projection** for very high-cardinality partition keys (avoids the catalog round-trip).
4. **CTAS (CREATE TABLE AS SELECT)** to materialize transformed datasets in optimal format.
5. **Workgroup data scan limits** to cap accidental large queries.
6. **Result reuse cache** (within a workgroup) reuses results for repeated queries up to 7 days.

### Athena workgroups

- Isolate query history, costs, IAM permissions per team.
- Per-query and per-workgroup data scan limits.
- Workgroup-level encryption settings.
- Enforce result location.

### Federated queries

- Athena Data Source Connectors (Lambda-based) query DynamoDB, RDS, Redshift, CloudWatch Logs, OpenSearch, MySQL, Postgres, etc.
- Useful for joining S3 data with operational stores without ingesting first.

### Athena exam triggers

- "Reduce Athena cost by 80%" → Parquet + compression + partitioning
- "Query S3 + DynamoDB in one SQL" → Athena federated query
- "Cap a team's monthly Athena spend" → Workgroup with per-query data scan limit
- "Materialize a transformed dataset for downstream jobs" → CTAS or INSERT INTO

---

## Amazon QuickSight

- BI / dashboarding service. SPICE in-memory engine for fast dashboards.
- **Editions:** Standard, Enterprise (adds row/column-level security, Q natural language, embedded analytics).
- **Data sources:** S3 (via Athena), Redshift, RDS / Aurora, Snowflake, on-prem JDBC, Salesforce, etc.
- **Embed** dashboards in apps (Enterprise).
- **QuickSight Q** - natural language Q&A on data.

### Common patterns

- Athena → SPICE refresh → QuickSight dashboard for cost-optimized self-service BI.
- Redshift direct query for live operational dashboards.

---

## Amazon CloudWatch

### Metrics

- Built-in metrics for AWS services (Glue, EMR, Kinesis, Lambda, Step Functions, Redshift, etc.).
- **Custom metrics** via PutMetricData (1-second resolution available with high-resolution metrics).
- **Embedded Metric Format (EMF)** to emit metrics from logs.
- **Metric math** for derived metrics (e.g., error rate = errors / invocations).

### Alarms

- Threshold-based or anomaly-detection-based.
- Targets: SNS, EC2 Auto Scaling, Systems Manager, Lambda.
- **Composite alarms** combine multiple alarms with AND/OR logic.

### Logs

- **Log groups** and **log streams**.
- **Subscription filters** stream logs to Kinesis / Firehose / Lambda for downstream analytics or OpenSearch indexing.
- **CloudWatch Logs Insights** - ad-hoc query language for logs.
  - Common pipelines for ETL job error analysis: `fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 100`
- **Logs to Lake** - export to S3 for long-term retention and Athena analysis.

### Synthetics

- Canary scripts to monitor APIs / web pages.
- Useful for monitoring downstream consumer health (e.g., does the BI dashboard load).

### Common pipeline monitoring patterns

- Glue job state metric → CloudWatch Alarm → SNS email on `FAILED`.
- Kinesis `IteratorAgeMilliseconds` alarm → notify when consumers fall behind.
- Lambda errors > N → Alarm → DLQ inspection.
- Step Functions `ExecutionsFailed` metric → Alarm.

---

## Amazon EventBridge

### Common pipeline uses

- **Schedule** Glue jobs / Step Functions on cron.
- Route **S3 events** (object created) to a Glue start-job-run target.
- Subscribe to **Glue / EMR / Step Functions state-change events** for downstream automation.
- **EventBridge Pipes** for source-filter-enrich-target without writing Lambda glue code.

### Schedules

- Modern replacement for CloudWatch Events scheduled rules.
- One-time, cron, or rate-based schedules.

---

## Data quality

### AWS Glue Data Quality

- Built on **Deequ** (open-source).
- Define rules in **Data Quality Definition Language (DQDL)** - e.g., `Completeness "user_id" > 0.99` or `Uniqueness "id" = 1.0`.
- Anomaly detection learns historical patterns.
- Run as part of Glue ETL job, on demand, or scheduled.
- Rule failures can fail the job or just emit metrics.

**[📖 Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)**

### Exam triggers

- "Detect schema drift in nightly job" → Glue Data Quality recommendations + DQDL rules
- "Block bad data from progressing in pipeline" → DQ rule failure → fail job
- "Monitor data freshness" → DQ rule on max(timestamp) + alarm

---

## Cost monitoring and FinOps

### Tools

- **AWS Cost Explorer** - 13 months of cost / usage with filters, groupings, forecasts.
- **AWS Budgets** - alert when spend / usage exceed thresholds.
- **Cost and Usage Reports (CUR)** - hourly granular CSV/Parquet to S3, queryable via Athena.
- **AWS Trusted Advisor** - cost-optimization checks (idle resources, RI underutilization).
- **Compute Savings Plans / Reserved Instances** for steady workloads.
- **S3 Storage Lens** - org-wide S3 cost visibility, recommendations.

### Pipeline-specific cost levers

| Service | Lever |
|---|---|
| S3 | Lifecycle policies, Intelligent-Tiering, Parquet, compression |
| Athena | Workgroup limits, partitioning, columnar formats |
| Glue | Job bookmarks, push-down predicates, right-sized workers |
| EMR | Spot for task nodes, auto-termination, Graviton instances |
| EMR Serverless | Pre-initialized capacity vs dynamic |
| Redshift | RA3 + Reserved, Serverless for spiky, concurrency scaling for read bursts |
| DynamoDB | Capacity mode (on-demand vs provisioned), reserved capacity |
| Kinesis | On-demand vs provisioned shards |
| Firehose | Buffer size, GZIP compression, format conversion |

---

## Recovery and resiliency patterns

### Failure modes

- **Dead letter queues (DLQs):**
  - Lambda → SQS DLQ on async invokes
  - SNS → SQS DLQ on failed deliveries
  - Step Functions → Catch state with SQS / SNS target
- **Idempotency:**
  - Idempotency keys on writes
  - Use Iceberg / Hudi merge-on-read for streaming upserts
- **Retries:**
  - Built-in retry on Glue, EMR steps, Lambda async invokes
  - Step Functions Retry block with exponential backoff and jitter
- **Replays:**
  - Kinesis 24h-365d retention → reprocess from older shard iterator
  - Firehose has no native replay (data lands in S3 - replay from S3 instead)
  - MSK retention configurable per topic

### Disaster recovery

- **S3:** cross-region replication (CRR) for warm DR; versioning + MFA delete for accidental delete protection.
- **Redshift:** automated snapshots, cross-region snapshot copy, RA3 cross-region data sharing.
- **DynamoDB:** PITR (35d), Global Tables for active-active.
- **RDS / Aurora:** automated backups, cross-region snapshot copy, Aurora Global Database.

---

## Common operations exam triggers

- "Alert when ETL job fails" → CloudWatch Alarm on Glue/EMR job state metric → SNS
- "Detect Kinesis consumer lag" → IteratorAgeMilliseconds alarm
- "Cap monthly Athena cost per team" → Athena workgroup with data scan limit
- "Long-term log retention with cheap query" → CloudWatch Logs subscription → Firehose → S3 → Athena
- "Validate data quality before loading to warehouse" → Glue Data Quality with DQDL rules
- "Recover failed Lambda invocations" → SQS DLQ; reprocess via separate consumer
- "Replay last week's stream" → Use KDS retention (extend to 7d) or replay from S3 archive
- "Detect anomalies in nightly KPI" → Glue Data Quality anomaly detection or CloudWatch anomaly detection alarm
