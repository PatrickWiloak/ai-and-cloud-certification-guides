# DEA-C01 Exam-Style Scenarios

20 scenarios mapped to exam domains. Read the prompt, choose the best answer, then check the explanation.

---

## Domain 1 - Data Ingestion and Transformation

### Scenario 1

A retail company emits clickstream events from a mobile app at peak rates of ~50,000 events/sec. The data team needs sub-second latency for fraud detection consumers and also wants the full stream archived to S3 in Parquet for daily analytics. Multiple downstream consumers must read the same stream in parallel without affecting each other.

**Best answer:** Kinesis Data Streams (with Enhanced Fan-Out) for fraud detection consumers; Kinesis Data Firehose subscribing to KDS for archival to S3 with format conversion to Parquet.

**Why:** KDS provides sub-second latency. EFO gives each consumer dedicated 2 MB/s per shard so they don't contend. Firehose attached to KDS gives managed S3 archival with built-in JSON-to-Parquet conversion via Glue Data Catalog schema. MSK could also work but adds Kafka operational overhead the team doesn't need.

---

### Scenario 2

A SaaS provider needs to mirror an on-prem Oracle 12c database into Aurora PostgreSQL. The mirror must include initial load and ongoing CDC. Schema differences exist between Oracle and Postgres dialects.

**Best answer:** AWS Schema Conversion Tool (SCT) for schema conversion + AWS DMS Full Load + CDC.

**Why:** SCT handles dialect differences (PL/SQL → PL/pgSQL). DMS handles initial bulk load and ongoing CDC. Together they're the canonical heterogeneous migration pattern.

---

### Scenario 3

A team uses Apache Airflow extensively. They need to orchestrate a nightly pipeline that runs Glue jobs, Athena CTAS queries, and a Redshift COPY. They want to keep their existing Airflow DAGs.

**Best answer:** Amazon MWAA (Managed Workflows for Apache Airflow).

**Why:** MWAA preserves existing DAGs and Airflow operator ecosystem. Step Functions would require rewriting orchestration.

---

### Scenario 4

A financial services pipeline must process 100 GB of credit-card transactions per hour with Spark. Cost is the primary concern. The job is interruption-tolerant.

**Best answer:** EMR with Spot instances for task nodes, on-demand for core, and auto-termination after job completion. Alternatively, EMR Serverless with dynamic capacity.

**Why:** Spot reduces task-node cost by 70-90%. Auto-termination prevents idle billing. EMR Serverless is the cleanest answer if the team doesn't want to manage clusters.

---

### Scenario 5

A team needs a data quality gate that prevents bad data from being loaded into Redshift. Specifically: completeness on `customer_id` must be >99%, and the table's row count must be within 20% of the prior run.

**Best answer:** AWS Glue Data Quality with DQDL rules; configure the job to fail on rule violation, optionally with anomaly detection for the row-count check.

**Why:** Glue Data Quality (built on Deequ) supports these checks natively. Failure-stop integrates with the Glue ETL job lifecycle.

---

## Domain 2 - Data Store Management

### Scenario 6

A 5 PB lake of historical sensor data is queried infrequently (weekly) but reads must complete in seconds when needed. Cost is critical.

**Best answer:** S3 Glacier Instant Retrieval with Athena and partitioning + Parquet.

**Why:** Glacier Instant Retrieval offers ms-level retrieval at ~50% lower cost than S3 Standard, and Athena can query it. Partitioning + Parquet keep query scans low.

---

### Scenario 7

A medical-imaging analytics team needs ACID transactions on their data lake plus the ability to time-travel for audit and reproducibility.

**Best answer:** Apache Iceberg tables on S3, queried via Athena.

**Why:** Iceberg provides ACID, time travel, schema evolution, and is natively supported in Athena/Glue/EMR/Redshift Spectrum. Plain Parquet on S3 lacks these features.

---

### Scenario 8

A company runs analytical queries over a 50 TB Redshift warehouse with 200 concurrent BI users during business hours. Query queue waits are growing during peak.

**Best answer:** Enable Redshift Concurrency Scaling on the existing RA3 cluster.

**Why:** Concurrency Scaling automatically spins up transient compute for short read bursts. AWS gives you free Concurrency Scaling credits proportional to cluster usage.

---

### Scenario 9

A multi-region IoT product needs single-digit-ms reads from a key-value store with active-active replication across us-east-1 and eu-west-1.

**Best answer:** DynamoDB Global Tables.

**Why:** Global Tables provide active-active multi-region replication with eventual consistency and conflict resolution.

---

### Scenario 10

A team wants to query DynamoDB and S3 (Parquet) data together using SQL without ETL.

**Best answer:** Athena federated query with the DynamoDB connector.

**Why:** Federated queries allow joining live DynamoDB with S3 tables in a single SQL statement.

---

### Scenario 11

A company needs to share a curated lake table from a "data" account with three "analytics" accounts. Data must not be copied. Permissions should be managed centrally.

**Best answer:** Lake Formation cross-account share using LF-Tags.

**Why:** LF cross-account sharing avoids copies, centralizes governance in the producer account, and LF-Tags scale to many tables.

---

## Domain 3 - Data Operations and Support

### Scenario 12

The team is concerned about a runaway Athena query scanning the entire 200 TB lake. They need a hard cap on data scanned per query.

**Best answer:** Athena workgroup with a per-query data scan limit.

**Why:** Workgroups enforce per-query and per-workgroup data limits. Queries exceeding the limit are killed automatically.

---

### Scenario 13

A nightly Glue ETL job sometimes silently produces empty output when the upstream source has stale data. The team needs to detect this without writing custom Spark code.

**Best answer:** AWS Glue Data Quality rule on row count or recency, configured to fail the job.

**Why:** Glue Data Quality provides pre-built rules (RowCount, Freshness, Completeness, Uniqueness) without custom code. Rule failures can fail the job and trigger CloudWatch alarms.

---

### Scenario 14

A Kinesis consumer Lambda is falling behind. The team needs an automated alert before SLA breach.

**Best answer:** CloudWatch Alarm on the `IteratorAgeMilliseconds` metric → SNS notification.

**Why:** Iterator age directly measures consumer lag. Alarm thresholds map to SLA budgets.

---

### Scenario 15

The CFO demands a monthly cost report broken out by data team. Each team uses Athena, Glue, and Redshift.

**Best answer:** Cost allocation tags applied to all team resources, plus Cost Explorer or CUR-on-Athena queries grouped by tag.

**Why:** Tagging is the AWS-native way to attribute spend. Cost and Usage Reports in S3 + Athena gives detailed analysis.

---

## Domain 4 - Data Security and Governance

### Scenario 16

A pipeline must encrypt all S3 data at rest with customer-managed keys, and every decryption must be auditable.

**Best answer:** S3 SSE-KMS with a customer-managed CMK, CloudTrail data events on KMS.

**Why:** Customer-managed CMKs give the customer full key policy control. CloudTrail logs every Decrypt call.

---

### Scenario 17

European analysts must see only EU customer rows. North American analysts must see only NA customer rows. Same source table.

**Best answer:** Lake Formation row-level filter using a region column, separate filter expressions per analyst persona, applied via LF-Tags.

**Why:** Lake Formation row-level security with LF-Tags is the canonical row-filtering pattern at scale.

---

### Scenario 18

Compliance requires identifying any S3 buckets with unprotected PII before opening them to a broader analyst group.

**Best answer:** Amazon Macie scheduled discovery jobs, with findings routed to Security Hub or EventBridge.

**Why:** Macie performs ML-based PII discovery in S3. Pre-broader-access scans are a canonical use case.

---

### Scenario 19

A Glue ETL job in a private subnet cannot reach S3. Internet access is restricted by security policy.

**Best answer:** Add an S3 Gateway VPC Endpoint to the subnet's route table. Optionally add a Glue interface endpoint if Glue API calls are also blocked.

**Why:** Gateway endpoints route traffic to S3 without internet egress. Cost is zero. NAT Gateway would also work but is more expensive and overkill for S3.

---

### Scenario 20

A Lambda transformer in a Firehose pipeline needs to call an external HTTPS API and authenticate with a third-party API key. Compliance prohibits hardcoded secrets in code or environment variables in plain text.

**Best answer:** Store the API key in AWS Secrets Manager (with rotation if supported by the third party), and have the Lambda fetch the secret at runtime via the Secrets Manager API.

**Why:** Secrets Manager is purpose-built for this. Parameter Store SecureString is also acceptable. Hardcoded keys violate least-privilege and rotation requirements.

---

## How to use these scenarios

1. **First pass:** read the prompt, write down your answer before reading the explanation.
2. **Second pass:** for any you got wrong, re-read the relevant note section and revisit a week later.
3. **Pattern recognition:** note the **exam triggers** in each prompt (latency requirement, cost concern, compliance, multi-region, etc.). Identifying triggers is the fastest path to the right answer on the real exam.

These 20 scenarios cover the most common patterns. The real exam will have ~50 scored questions with broader coverage; use the AWS official sample questions and AWS Skill Builder practice exam for full breadth.
