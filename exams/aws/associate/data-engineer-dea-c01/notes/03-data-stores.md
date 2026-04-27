# 03 - Data Stores (Domain 2, ~26% of exam)

## Amazon S3 - the data lake substrate

### Storage classes

| Class | Use case | Min storage duration |
|---|---|---|
| Standard | Hot, frequent access | none |
| Standard-IA | Infrequent access, multi-AZ | 30 days |
| One Zone-IA | Recreatable, single-AZ | 30 days |
| Intelligent-Tiering | Unknown / changing access pattern | none |
| Glacier Instant Retrieval | Rare reads, ms retrieval | 90 days |
| Glacier Flexible Retrieval | Archive, minutes-to-hours retrieval | 90 days |
| Glacier Deep Archive | Long-term archive, hours retrieval | 180 days |

**Lifecycle policies** transition objects between classes and expire them. Common pattern: Standard → Standard-IA after 30d → Glacier after 90d → Deep Archive after 1y.

**Intelligent-Tiering** is the default safe choice when access pattern is unknown. Adds a small monitoring fee per object.

**[📖 S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)**

### File formats for analytics

| Format | Type | Best for |
|---|---|---|
| **Parquet** | Columnar | Analytical reads, predicate pushdown, compression |
| **ORC** | Columnar | Hive-heavy environments |
| **Avro** | Row-oriented | Streaming writes, schema evolution |
| **JSON / CSV** | Row, plain text | Ingest layer, human-readable |

For exam purposes: **Parquet** is the right answer for almost any "optimize Athena cost" or "speed up columnar query" question.

### Partitioning

- Hive-style partitions: `s3://bucket/table/year=2026/month=04/day=26/`.
- Athena and Spark can prune partitions if the query filter matches partition keys.
- **Partition projection** (Athena) avoids the catalog round-trip and works for very high-cardinality partition keys (millions of partitions).

### Compression

- Use Snappy or GZIP for Parquet/ORC. Snappy is faster, GZIP compresses harder.
- Avoid plain text without compression for any volume of data.

### S3 features relevant to data engineering

- **S3 Object Lambda** - transform on read (e.g., redact PII before delivering to a consumer).
- **S3 Select** - SQL-style filter on a single object server-side.
- **S3 Storage Lens** - org-wide visibility, optimization recommendations.
- **S3 Replication** - same-region (SRR) and cross-region (CRR) replication for DR or compliance.
- **S3 Inventory** - daily/weekly CSV/Parquet listing of objects with metadata.
- **S3 Event Notifications** to Lambda / SQS / SNS / EventBridge.
- **Multipart upload** for objects > 100 MB.
- **Strong consistency** for all read-after-write operations (since Dec 2020).

---

## Open table formats on S3 (lakehouse)

### Apache Iceberg

- ACID transactions, schema evolution, partition evolution, time travel.
- First-class support: Athena, Glue, EMR, Redshift Spectrum, Spark.
- **Best answer** for any question mentioning ACID, schema evolution, or time travel on a data lake.

**[📖 Iceberg in Athena](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg.html)**

### Apache Hudi

- Upserts and deletes via two storage modes:
  - **Copy-on-Write (CoW):** rewrite affected files. Read-optimized.
  - **Merge-on-Read (MoR):** delta logs + base. Write-optimized.
- Common for CDC sinks where many small upserts are expected.

### Delta Lake

- Originated at Databricks. Glue and Athena now read Delta tables.
- ACID on top of Parquet via a `_delta_log/` directory.

### Choosing between them on the exam

- "Schema evolution + time travel" → Iceberg
- "Heavy upserts from CDC source" → Hudi (MoR) or Iceberg
- "Coming from Databricks workloads" → Delta Lake

---

## Amazon Redshift

### Cluster types

- **Provisioned RA3** (with managed storage) - separates compute and storage. Resize compute without moving data. **Default modern choice.**
- **Provisioned DC2** - legacy SSD-attached. Smaller, older.
- **Redshift Serverless** - no cluster sizing. Auto-scales RPUs (Redshift Processing Units). Pay for usage. Best for spiky/intermittent workloads.

**[📖 Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)**
**[📖 Redshift Serverless](https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-whatis.html)**

### Distribution styles

- **AUTO** - Redshift picks (default). EVEN until table reaches threshold, then KEY if pattern detected, otherwise EVEN.
- **EVEN** - round-robin. Use when no clear join key.
- **KEY** - hash on a column. Use when the column is consistently used in joins.
- **ALL** - replicate full table to every node. Use for small dimension tables (< few million rows).

### Sort keys

- **Compound** - sorted by columns in declared order. Best for queries filtering on prefix columns.
- **Interleaved** - equal weight per column. Better when filters vary across multiple columns. Higher VACUUM cost.
- AUTO sort key lets Redshift choose.

### Materialized views

- Pre-computed query results. Refresh on demand or auto-refresh.
- Massive speedup for repeated heavy queries (joins, aggregates).

### Other Redshift features

- **Concurrency Scaling** - automatic transient compute for read-heavy spikes.
- **AQUA** (Advanced Query Accelerator) - hardware-accelerated cache (RA3 only).
- **Result caching** - 24h cache on identical queries.
- **Redshift Spectrum** - query S3 directly via Glue Data Catalog. No data load needed.
- **Federated queries** - query RDS/Aurora Postgres or MySQL from Redshift.
- **Data sharing** - share live data across clusters/accounts (RA3 only) without copies.
- **Redshift ML** - SQL function calls SageMaker model.
- **Zero-ETL** integrations with Aurora, RDS, DynamoDB.

### Loading data into Redshift

- **COPY** from S3, DynamoDB, or remote SSH. Always parallelize from multiple files (one file per slice = fastest).
- **Auto Copy from S3** - automatic continuous load (newer feature).
- **Streaming ingest** from KDS / MSK directly into Redshift materialized views.
- **Redshift Data API** - HTTP API for asynchronous queries (no JDBC needed).

### Exam triggers

- "Petabyte warehouse, predictable workload, lots of concurrent BI" → Redshift RA3 with concurrency scaling
- "Don't want to manage clusters, intermittent workload" → Redshift Serverless
- "Query S3 from SQL without loading into the warehouse" → Redshift Spectrum
- "Share dataset across BUs without copying" → Redshift data sharing
- "Fast load from 5 TB of S3 Parquet" → COPY with manifest, multiple files (1 per slice)

---

## Operational databases

### Amazon RDS

- Managed Postgres, MySQL, MariaDB, Oracle, SQL Server.
- **Multi-AZ** for HA - synchronous standby in another AZ, automatic failover.
- **Read replicas** for read scaling - asynchronous, in-region or cross-region.
- **Automated backups** (1-35 day retention) plus manual snapshots.
- **Performance Insights** for diagnosing query performance.

### Amazon Aurora

- Cloud-native MySQL- and PostgreSQL-compatible. Storage layer is shared across up to 15 read replicas.
- **Aurora Serverless v2** - auto-scaling per ACU.
- **Aurora Global Database** - cross-region replication (typically < 1s lag) with up to 5 secondary regions.
- **Zero-ETL** to Redshift and OpenSearch (continuous CDC, no DMS).

### Amazon DynamoDB

- Fully managed key-value + document NoSQL. Single-digit ms latency.
- **Capacity modes:**
  - **On-demand** - per-request pricing, automatic scaling. Use for unpredictable / spiky.
  - **Provisioned** - configured RCU/WCU with auto-scaling. Cheaper for steady predictable load.
- **Keys:**
  - **Partition key** alone, or **Partition + Sort key** (composite).
- **Indexes:**
  - **Global Secondary Index (GSI)** - different partition key. Eventually consistent. Up to 20 per table.
  - **Local Secondary Index (LSI)** - same partition key, different sort key. Strongly consistent. Created at table creation only.
- **DynamoDB Streams** - 24h ordered CDC; fed into Lambda or Kinesis Data Streams (for KCL consumers).
- **DynamoDB Accelerator (DAX)** - in-memory cache, microsecond reads.
- **Global Tables** - active-active multi-region replication.
- **TTL** - auto-delete expired items.
- **PartiQL** - SQL-like syntax for DynamoDB.
- **Zero-ETL** to OpenSearch and Redshift.
- **Backup** - PITR (point-in-time recovery, 35d) plus on-demand backups.
- **Export to S3** - full-table or incremental DynamoDB → S3 export, no consumed capacity.

**[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)**

#### DynamoDB design exam triggers

- "Single-digit ms reads at scale" → DynamoDB
- "Microsecond reads" → DAX in front of DynamoDB
- "Active-active multi-region" → Global Tables
- "Auto-archive old items" → TTL
- "Stream changes to Lambda" → DynamoDB Streams or Kinesis Data Streams for DynamoDB
- "Bulk export DynamoDB to data lake without burning capacity" → Export to S3

### Amazon ElastiCache

- Managed Redis (or Memcached). In-memory caching layer.
- Use to offload reads from RDS / DynamoDB / Aurora.

---

## Catalog and lake governance

### AWS Glue Data Catalog

- Hive-metastore-compatible. Stores tables, columns, partitions, classifiers.
- Used by Athena, Redshift Spectrum, EMR, Glue ETL, Lake Formation.
- Tables can be:
  - **Standard** - typically managed by Glue Crawlers
  - **Iceberg / Hudi / Delta** - lakehouse table types

### AWS Lake Formation

- Centralized permissions layer above Glue Data Catalog.
- Permission grants:
  - Database, table, column, row, and cell-level
  - **LF-Tags** for tag-based access control (recommended at scale)
  - **Data filters** for row-level security
- **Cross-account sharing** via LF-Tags.
- **Governed tables** support ACID transactions on S3.

**[📖 Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**

#### Lake Formation exam triggers

- "Restrict to specific columns" → Lake Formation column-level
- "Restrict by user region" → Lake Formation row-level / data filter
- "Centralized governance across many accounts" → Lake Formation cross-account share with LF-Tags

---

## Search and observability stores

### Amazon OpenSearch Service

- Managed OpenSearch (Elasticsearch fork). Both **Provisioned** and **Serverless**.
- Common targets:
  - Log analytics (CloudWatch Logs subscription)
  - Application search
  - Real-time dashboards (Kibana / OpenSearch Dashboards)
- **Index State Management (ISM)** for hot/warm/cold tiering and index rollover.

---

## When to pick which store

| Workload | Store |
|---|---|
| Cheap durable raw data lake | S3 |
| ACID lakehouse with schema evolution | S3 + Iceberg |
| MPP analytical SQL warehouse | Redshift (RA3 or Serverless) |
| OLTP relational | RDS / Aurora |
| Single-digit ms key-value at scale | DynamoDB |
| Microsecond reads | DAX (in front of DynamoDB) |
| Search and log analytics | OpenSearch |
| Caching | ElastiCache |
| Graph | Neptune |
| Time series | Timestream |
| Wide-column on Hadoop ecosystem | HBase on EMR |

---

## Cost optimization across stores

- **S3:** lifecycle policies to cheaper classes; Intelligent-Tiering when unsure; Parquet over JSON.
- **Redshift:** RA3 + Reserved capacity for predictable; Serverless for spiky; concurrency scaling for short read bursts.
- **DynamoDB:** on-demand for unpredictable; provisioned with auto-scaling for steady; reserved capacity for very steady.
- **RDS / Aurora:** Reserved Instances; Aurora I/O-Optimized for write-heavy.
- **OpenSearch:** UltraWarm and cold storage tiers; reserved instances.
