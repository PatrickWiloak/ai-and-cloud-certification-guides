# 06 - Architecture Patterns and Cost Optimization

This note ties services together into common patterns the exam asks about.

## Pattern 1 - Lakehouse on S3 with Iceberg

```
Sources (RDBMS, SaaS, files)
    │
    ├─ DMS (full + CDC) ────┐
    ├─ AppFlow ─────────────┤
    ├─ Transfer Family ─────┤
    └─ Kinesis Firehose ────┴──→ S3 (raw, partitioned)
                                      │
                                      ▼
                                Glue ETL (Spark)
                                      │
                                      ▼
                                S3 Iceberg (curated)
                                      │
                              ┌───────┼────────┐
                              ▼       ▼        ▼
                          Athena  Redshift  EMR
                                  Spectrum
```

### Why Iceberg

- ACID transactions
- Schema evolution
- Time travel for reproducible queries
- Hidden partitioning (no Hive-style directory layout required)
- Cross-engine compatibility (Athena, Glue, EMR, Redshift Spectrum, Spark)

### Cost optimizations

- Partition by query-predicate columns (date, region).
- Compact small files via Iceberg `OPTIMIZE`.
- Parquet + Snappy.
- S3 lifecycle to Glacier for cold partitions.

---

## Pattern 2 - Streaming pipeline (lambda / kappa)

### Kappa (single streaming path)

```
Producers ──▶ Kinesis Data Streams
                  │
                  ├─▶ Managed Flink (real-time aggregation)
                  │       │
                  │       └─▶ DynamoDB (state) + OpenSearch (dashboards)
                  │
                  └─▶ Firehose ──▶ S3 (Parquet)
                                       │
                                       └─▶ Athena (ad-hoc historical)
```

### Lambda architecture (batch + streaming)

```
Streaming path:
  Kinesis ──▶ Flink ──▶ DynamoDB / OpenSearch (real-time view)

Batch path:
  Kinesis ──▶ Firehose ──▶ S3 ──▶ Glue ETL ──▶ Iceberg ──▶ Redshift / Athena (corrected view)
```

### When to choose what

- **Kappa** simpler; reprocess by replaying Kinesis or re-running on the S3 archive.
- **Lambda** when batch needs different (more accurate / heavier) transformations than streaming can handle.

---

## Pattern 3 - CDC to lakehouse

```
RDS Postgres
    │
    └─▶ DMS (full load + CDC)
            │
            └─▶ S3 (raw CDC events as JSON)
                    │
                    └─▶ Glue ETL (Spark with Iceberg writer)
                            │
                            └─▶ S3 Iceberg (merge upserts/deletes)
                                    │
                                    └─▶ Athena / Redshift Spectrum
```

For Aurora source: prefer **Aurora Zero-ETL to Redshift / OpenSearch** instead of DMS when the destination is one of those (less infra to manage).

---

## Pattern 4 - Operational data store with analytics offload

```
Application
    │
    ▼
DynamoDB (sub-ms reads/writes)
    │
    ├─▶ DAX (microsecond read cache)
    │
    ├─▶ DynamoDB Streams ──▶ Lambda ──▶ Kinesis Firehose ──▶ S3 ──▶ Athena
    │
    └─▶ DynamoDB Export to S3 (full / incremental, no consumed capacity)
                      │
                      └─▶ Iceberg / Athena / EMR for analytics
```

For RDS / Aurora: **Aurora Zero-ETL to Redshift / OpenSearch** is the modern equivalent.

---

## Pattern 5 - Multi-account data mesh

```
Account A (Producer)
  └─ S3 + Glue Data Catalog + Lake Formation
        │
        └─▶ LF cross-account share (via LF-Tags)

Account B (Consumer)
  └─ Resource link to shared database
        │
        └─▶ Athena / Redshift Spectrum / Glue ETL

Account C (Consumer)
  └─ Same pattern
```

**Why Lake Formation cross-account share:**

- No data copy
- Centralized governance in producer account
- Tag-based access control scales to many tables
- Auditable via CloudTrail

---

## Pattern 6 - Hot / warm / cold tiering

```
Hot     - DynamoDB / OpenSearch / Redshift RA3
Warm    - S3 Standard / Standard-IA + Athena
Cold    - S3 Glacier Instant Retrieval / Flexible Retrieval
Frozen  - S3 Glacier Deep Archive
```

Lifecycle policies move data automatically based on age. Match the tier to the access pattern, not the data age alone (Intelligent-Tiering is the safe default if unsure).

---

## Pattern 7 - Orchestrated batch ETL

```
EventBridge schedule (cron)
    │
    └─▶ Step Functions Standard
            │
            ├─▶ Glue Crawler (discover new partitions)
            │
            ├─▶ Map state (per source table):
            │       └─▶ Glue ETL job
            │       └─▶ Glue Data Quality
            │
            ├─▶ Athena CTAS (publish curated tables)
            │
            ├─▶ Lambda (post-success notifications)
            │
            └─▶ Catch ──▶ SNS / Slack / DLQ on failure
```

Variant: **MWAA (Airflow)** when the team's existing skills are Airflow-based.

---

## Pattern 8 - Real-time alerting from streaming KPIs

```
Producers ──▶ KDS ──▶ Managed Flink (windowed agg)
                              │
                              └─▶ CloudWatch Custom Metric
                                       │
                                       └─▶ CloudWatch Alarm ──▶ SNS / Lambda
```

Or for simpler thresholds: **Lambda consumer** on KDS that emits metrics and triggers alarms directly.

---

## Cost-optimization playbook

### S3

- Parquet over JSON / CSV
- Snappy compression
- Partition by query predicates
- Lifecycle to cheaper classes
- Intelligent-Tiering when access pattern is unknown
- Multipart upload for >100 MB
- Inventory + Storage Lens to find waste

### Athena

- Workgroup data scan limits per team
- CTAS to materialize repeat-use datasets
- Result reuse cache
- Partition projection for high-cardinality partitions
- Federated queries for "ingest avoidance" when joining one-off

### Glue

- Job bookmarks
- Push-down predicates
- Right-size workers (start with G.1X)
- Glue 4.0/5.0 for newest Spark
- Use Spot for EMR alternative when Spark workload is heavy

### EMR

- Spot for task nodes (recoverable)
- Auto-termination
- Graviton (m7g/r7g) for cost savings
- EMR Serverless for spiky / unpredictable workloads
- Persist data in S3 (EMRFS), use HDFS only as scratch

### Redshift

- RA3 + Reserved Instances for steady workloads
- Serverless for spiky / intermittent
- Concurrency Scaling for read bursts (free credits available)
- Materialized views for repeated heavy aggregations
- Result caching reduces repeat-query cost
- Data sharing instead of copies for cross-team analytics

### Kinesis / Firehose / MSK

- KDS On-Demand only for unpredictable; Provisioned for predictable
- Firehose: large buffer sizes reduce S3 PUT cost; GZIP + Parquet conversion
- MSK Serverless when workload is variable

### DynamoDB

- On-demand for unpredictable
- Provisioned + auto-scaling for predictable
- Reserved capacity for very steady, large
- DAX only when microsecond reads are required (it's expensive)

---

## Reliability patterns

| Pattern | Tooling |
|---|---|
| Dead letter queue | SQS DLQ on Lambda async / SNS / Step Functions |
| Idempotency | Idempotency keys; Iceberg merge-on-read |
| Retries with backoff | Step Functions Retry; SDK retries |
| Circuit breakers | Custom Lambda logic; AWS App Mesh |
| Replay | Kinesis retention (24h-365d); replay from S3 archive |
| Multi-region DR | Aurora Global Database; S3 CRR; DynamoDB Global Tables; Redshift cross-region snapshot copy |

---

## Decision flowcharts

### "Where do I put this data?"

```
Need single-digit ms key-value? ──▶ DynamoDB
Need OLTP relational? ───────────▶ RDS or Aurora
Need MPP SQL warehouse? ─────────▶ Redshift
Need search / log analytics? ────▶ OpenSearch
Need cheap durable lake? ────────▶ S3 (+ Iceberg if ACID needed)
Need cache? ─────────────────────▶ ElastiCache or DAX
```

### "How do I move this data?"

```
Real-time (sub-sec)? ──────▶ Kinesis Data Streams
Real-time → S3/Redshift? ──▶ Kinesis Firehose
Apache Kafka? ─────────────▶ MSK
Database CDC? ─────────────▶ DMS (or Aurora Zero-ETL)
SaaS source? ──────────────▶ AppFlow
SFTP / FTP? ───────────────▶ Transfer Family
Bulk migration NFS / SMB? ─▶ DataSync (or Snowball offline)
Catalog new files? ────────▶ Glue Crawler
```

### "How do I transform this?"

```
Spark batch with no infra? ──▶ Glue ETL (or EMR Serverless)
Long-running Spark / Hive? ──▶ EMR on EC2
Lightweight per-record? ─────▶ Lambda
Visual ETL? ─────────────────▶ Glue Studio
Existing Airflow DAGs? ──────▶ MWAA
AWS-native orchestration? ───▶ Step Functions
Stream processing windowed? ─▶ Managed Service for Apache Flink
```

### "How do I query this?"

```
Ad-hoc SQL on S3? ──────────▶ Athena
BI dashboards? ─────────────▶ QuickSight
Heavy MPP analytics? ───────▶ Redshift
Search / aggregations? ─────▶ OpenSearch
Single-row key lookup? ─────▶ DynamoDB
Federated SQL? ─────────────▶ Athena federated query or Redshift federated query
```

These flowcharts cover at least 50% of likely exam scenario questions. Combine with the security stack from [05-security-governance.md](05-security-governance.md) and you have answers for ~70% of the exam.
