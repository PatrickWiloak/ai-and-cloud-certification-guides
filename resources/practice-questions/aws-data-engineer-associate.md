# AWS Certified Data Engineer - Associate (DEA-C01) - Practice Questions

20 scenario-based questions mapped to the four exam domains. Use these alongside [the official AWS sample questions](https://d1.awsstatic.com/training-and-certification/docs-data-engineer-associate/AWS-Certified-Data-Engineer-Associate_Sample-Questions.pdf) and the AWS Skill Builder Official Practice Exam.

> **Cert page:** [exams/aws/associate/data-engineer-dea-c01/](../../exams/aws/associate/data-engineer-dea-c01/)
> **Fact sheet:** [fact-sheet.md](../../exams/aws/associate/data-engineer-dea-c01/fact-sheet.md)
> **Notes:** [notes/](../../exams/aws/associate/data-engineer-dea-c01/notes/)

---

## Domain 1 - Data Ingestion and Transformation (34%)

### Question 1
**Scenario:** A retail platform produces clickstream events at 50,000 events/sec peak. The fraud team needs sub-second access; the analytics team wants the same data archived to S3 in Parquet for daily queries. Each team must operate independently of the other.

A. Use a single Kinesis Data Firehose stream and have both teams read from S3.
B. Use Amazon MSK with two consumer groups.
C. Use Amazon Kinesis Data Streams with Enhanced Fan-Out for fraud, plus a Firehose subscriber for archival to S3 with format conversion to Parquet.
D. Use AWS DMS with Kinesis source.

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** KDS provides sub-second latency. Enhanced Fan-Out gives each consumer dedicated throughput per shard. Firehose attached to KDS provides managed S3 delivery with built-in JSON-to-Parquet conversion via Glue Data Catalog schema. Option A fails the latency requirement. Option B is technically valid but adds Kafka operational overhead. Option D doesn't fit (DMS is for database CDC, not stream ingest from apps).

**Key concept:** [01-data-ingestion.md](../../exams/aws/associate/data-engineer-dea-c01/notes/01-data-ingestion.md)
</details>

---

### Question 2
**Scenario:** A company is migrating an on-prem Oracle 12c database to Aurora PostgreSQL with continuous replication. Schema dialects differ.

A. AWS DataSync + DMS Full Load
B. AWS Schema Conversion Tool (SCT) + DMS Full Load + CDC
C. AWS Glue ETL + Lambda
D. Native Oracle Data Pump export to S3 + Glue Crawler

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SCT converts schema (PL/SQL → PL/pgSQL). DMS handles bulk load and ongoing CDC. This is the canonical heterogeneous migration pattern. DataSync is for filesystem transfers, not databases. Glue + Lambda doesn't solve schema conversion or CDC. Data Pump exports are one-time, not continuous.

**Key concept:** [01-data-ingestion.md - DMS section](../../exams/aws/associate/data-engineer-dea-c01/notes/01-data-ingestion.md)
</details>

---

### Question 3
**Scenario:** A team uses Apache Airflow extensively. They need to orchestrate a nightly Glue + Athena CTAS + Redshift COPY pipeline while keeping their existing DAGs.

A. AWS Step Functions with the Glue and Redshift Data API integrations
B. Amazon MWAA
C. Amazon EventBridge schedules
D. AWS Lambda with cron

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** MWAA preserves existing Airflow DAGs and operator ecosystem. Step Functions would require rewriting orchestration logic. EventBridge alone can't represent multi-step DAGs with branching and retries. Lambda has a 15-minute cap and isn't a full orchestrator.

**Key concept:** [02-data-transformation.md - MWAA section](../../exams/aws/associate/data-engineer-dea-c01/notes/02-data-transformation.md)
</details>

---

### Question 4
**Scenario:** A nightly Spark batch job processes 100 GB and is interruption-tolerant. Cost is the primary requirement.

A. EMR on EC2 with all on-demand instances
B. AWS Glue ETL with G.8X workers
C. EMR on EC2 with Spot task nodes, on-demand core nodes, auto-termination after job completion
D. Lambda functions in parallel

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Spot reduces task-node cost by 70-90%. Auto-termination prevents idle billing. Core nodes stay on-demand to protect HDFS data. Glue with G.8X is more expensive than Spot EMR for this workload. Lambda has a 15-min cap and isn't suited for 100 GB Spark jobs.

**Key concept:** [02-data-transformation.md - EMR section](../../exams/aws/associate/data-engineer-dea-c01/notes/02-data-transformation.md)
</details>

---

### Question 5
**Scenario:** A pipeline must convert streaming JSON to Parquet during S3 delivery, with no infrastructure to manage.

A. Kinesis Data Streams + Lambda consumer that writes Parquet
B. Kinesis Data Firehose with format conversion enabled (Glue Data Catalog schema)
C. MSK Connect with S3 sink
D. AWS Glue Streaming ETL

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Firehose's built-in format conversion (JSON → Parquet/ORC) using a Glue Data Catalog schema is the lowest-overhead, fully-managed solution. Lambda or Glue Streaming would also work but require code/config. MSK Connect is overkill if the source isn't already Kafka.

**Key concept:** [01-data-ingestion.md - Firehose section](../../exams/aws/associate/data-engineer-dea-c01/notes/01-data-ingestion.md)
</details>

---

## Domain 2 - Data Store Management (26%)

### Question 6
**Scenario:** A 5 PB lake of historical sensor data is queried weekly. Reads must complete in seconds. Cost is critical.

A. S3 Standard
B. S3 Glacier Deep Archive
C. S3 Glacier Instant Retrieval
D. S3 Standard-IA

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Glacier Instant Retrieval gives ms-level retrieval at ~50% lower cost than Standard. Glacier Deep Archive can't meet the seconds requirement (12+ hours retrieval). Standard-IA fits monthly access, not weekly with cost criticality.

**Key concept:** [03-data-stores.md - S3 storage classes](../../exams/aws/associate/data-engineer-dea-c01/notes/03-data-stores.md)
</details>

---

### Question 7
**Scenario:** Auditors require ACID transactions, time-travel reads, and schema evolution on the data lake.

A. Plain Parquet on S3 + Athena
B. Apache Iceberg tables on S3 + Athena
C. Apache Avro + Glue
D. CSV with versioned S3 buckets

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Iceberg natively provides ACID, time travel, and schema evolution; Athena/Glue/EMR/Redshift Spectrum all support it. Plain Parquet doesn't have ACID or time travel. Avro is row-oriented and doesn't add ACID. S3 versioning isn't a query-level time-travel mechanism.

**Key concept:** [03-data-stores.md - Iceberg section](../../exams/aws/associate/data-engineer-dea-c01/notes/03-data-stores.md)
</details>

---

### Question 8
**Scenario:** A 50 TB Redshift RA3 cluster sees long queue waits during business-hour peaks with 200 concurrent BI users.

A. Resize to a larger node type
B. Migrate to Redshift Serverless
C. Enable Concurrency Scaling
D. Switch to DynamoDB

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Concurrency Scaling adds transient compute for short read bursts and provides free credits proportional to baseline usage. It addresses queue waits with no migration. Resizing helps for steady throughput but doesn't add elasticity. Redshift Serverless is a bigger migration. DynamoDB is wrong for analytical SQL.

**Key concept:** [03-data-stores.md - Redshift section](../../exams/aws/associate/data-engineer-dea-c01/notes/03-data-stores.md)
</details>

---

### Question 9
**Scenario:** A multi-region IoT app needs single-digit-ms key-value reads with active-active replication across us-east-1 and eu-west-1.

A. Aurora Global Database
B. DynamoDB Global Tables
C. RDS Multi-AZ
D. ElastiCache Global Datastore

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Global Tables provide active-active multi-region replication with single-digit-ms latency. Aurora Global is active-passive (one writer region). RDS Multi-AZ is single-region HA only. ElastiCache Global Datastore is for Redis caching, not primary key-value persistence.

**Key concept:** [03-data-stores.md - DynamoDB section](../../exams/aws/associate/data-engineer-dea-c01/notes/03-data-stores.md)
</details>

---

### Question 10
**Scenario:** A producer account wants to share a curated lake table with three consumer accounts. Data must not be copied. Permissions should be centrally managed.

A. Replicate the S3 bucket to each consumer account
B. Lake Formation cross-account share with LF-Tags
C. S3 bucket policies granting consumer accounts read access
D. AWS DataSync to consumer-account buckets

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Lake Formation cross-account sharing avoids copies, scales via LF-Tags, and centralizes governance in the producer account. Bucket policies work at the S3 level but don't provide table-level / column-level control. Replication and DataSync make copies.

**Key concept:** [05-security-governance.md - Lake Formation section](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

## Domain 3 - Data Operations and Support (22%)

### Question 11
**Scenario:** A team is concerned about runaway Athena queries scanning the full 200 TB lake. They need a hard cap on data scanned per query.

A. CloudWatch alarm on Athena DataScannedInBytes
B. Athena workgroup with per-query data scan limit
C. IAM policy limiting Athena calls
D. Restrict Glue Data Catalog access

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Workgroups enforce per-query and per-workgroup data scan limits. Queries exceeding the limit are killed automatically. CloudWatch alarms are reactive, not preventive. IAM and Glue restrictions block access entirely, not specific costly queries.

**Key concept:** [04-data-operations.md - Athena workgroups](../../exams/aws/associate/data-engineer-dea-c01/notes/04-data-operations.md)
</details>

---

### Question 12
**Scenario:** A nightly Glue ETL job sometimes silently produces empty output when upstream data is stale. Detect this without writing custom Spark code.

A. Add a Lambda post-processor that counts rows
B. AWS Glue Data Quality with DQDL rules (RowCount, Freshness), set to fail the job
C. CloudWatch metric filter on Glue logs
D. Step Functions Catch state

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Glue Data Quality (built on Deequ) provides RowCount, Freshness, Completeness, and Uniqueness rules without custom code. Rule failures can fail the job. Other options work but require custom code or only catch errors, not data-quality issues.

**Key concept:** [04-data-operations.md - Glue Data Quality](../../exams/aws/associate/data-engineer-dea-c01/notes/04-data-operations.md)
</details>

---

### Question 13
**Scenario:** A Lambda Kinesis consumer is falling behind. Alert before SLA breach.

A. Lambda Errors metric alarm
B. Lambda Duration metric alarm
C. CloudWatch alarm on IteratorAgeMilliseconds
D. CloudTrail event on Kinesis

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** IteratorAgeMilliseconds directly measures consumer lag. Errors / Duration measure other things. CloudTrail logs API calls, not consumer state.

**Key concept:** [04-data-operations.md - CloudWatch section](../../exams/aws/associate/data-engineer-dea-c01/notes/04-data-operations.md)
</details>

---

### Question 14
**Scenario:** Reduce Athena cost by 80% on a noisy CSV-heavy lake.

A. Switch all data to JSON
B. Convert CSV to Parquet, partition by date, compress with Snappy
C. Increase the EC2 instance type behind Athena
D. Cache results in Redshift

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Columnar Parquet + partitioning + compression reduces scan size by 10-100x, directly reducing Athena cost (which is per-TB-scanned). JSON is no better than CSV for cost. Athena has no EC2 instance type. Caching in Redshift is a different system.

**Key concept:** [04-data-operations.md - Athena cost reduction](../../exams/aws/associate/data-engineer-dea-c01/notes/04-data-operations.md)
</details>

---

### Question 15
**Scenario:** Long-term log retention with cost-effective ad-hoc query.

A. Keep all logs in CloudWatch Logs forever
B. CloudWatch Logs subscription filter → Firehose → S3 → Athena
C. Stream logs to OpenSearch Provisioned with 7-year retention
D. Store logs in DynamoDB

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Firehose to S3 (Parquet) provides cheap durable storage. Athena gives ad-hoc query. CloudWatch Logs storage is expensive long-term. OpenSearch is expensive for long retention. DynamoDB is wrong for log analysis.

**Key concept:** [04-data-operations.md](../../exams/aws/associate/data-engineer-dea-c01/notes/04-data-operations.md)
</details>

---

## Domain 4 - Data Security and Governance (18%)

### Question 16
**Scenario:** Encrypt all S3 data at rest with customer-managed keys, with a complete audit trail of every decryption.

A. SSE-S3
B. SSE-KMS with a customer-managed CMK + CloudTrail data events on KMS
C. SSE-C with rotating client-side keys
D. Enable S3 Versioning

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SSE-KMS with a customer-managed CMK gives full key policy control. CloudTrail data events on KMS log every Decrypt call. SSE-S3 uses AWS-managed keys (less control, less audit). SSE-C requires the client to send the key on every request and isn't centrally auditable. Versioning has nothing to do with encryption.

**Key concept:** [05-security-governance.md - Encryption](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

### Question 17
**Scenario:** EU analysts must see only EU customer rows; NA analysts only NA rows. Same source table.

A. Build separate physical tables per region
B. Lake Formation row-level filter using a region column with LF-Tags
C. IAM policy with conditional resource ARNs
D. Athena views per analyst persona

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Lake Formation row-level security with LF-Tags is the canonical row-filter pattern at scale. Separate tables explode storage and ETL. IAM resource ARNs can't filter rows. Views are workable but harder to govern at scale and audit.

**Key concept:** [05-security-governance.md - Lake Formation](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

### Question 18
**Scenario:** Identify any S3 buckets with unprotected PII before opening them to a broader analyst group.

A. Run a custom Glue ETL job scanning every object
B. Amazon Macie scheduled discovery jobs
C. AWS Config rule
D. CloudTrail data events filtered for sensitive prefixes

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Macie performs ML-based PII / credentials / secrets discovery in S3. Pre-broader-access scans are a canonical Macie use case. Custom Glue ETL is reinventing Macie. Config evaluates resource configuration, not file content. CloudTrail logs API calls.

**Key concept:** [05-security-governance.md - Macie](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

### Question 19
**Scenario:** A Glue ETL job in a private subnet can't reach S3. Internet egress is blocked.

A. Add a NAT Gateway
B. Add an S3 Gateway VPC Endpoint to the subnet's route table
C. Move the Glue job to a public subnet
D. Allowlist S3 IP ranges in the security group

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Gateway endpoints route to S3 without internet egress and are free. NAT Gateway works but costs $$ and is overkill. Public subnet violates security policy. S3 IP ranges change frequently and aren't operationally sound to allowlist.

**Key concept:** [05-security-governance.md - VPC endpoints](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

### Question 20
**Scenario:** A Lambda Firehose transformer must call a third-party API with an API key. Compliance prohibits hardcoded secrets in code or plain-text environment variables.

A. Hardcode the key in the Lambda
B. Store in AWS Secrets Manager and fetch at runtime
C. Store in a public S3 bucket with restrictive ACLs
D. Pass via Firehose record headers

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Secrets Manager (or Parameter Store SecureString) is purpose-built for this. Hardcoding violates basic security. Public S3 is wrong on its face. Firehose record headers aren't a secrets channel.

**Key concept:** [05-security-governance.md - Secrets management](../../exams/aws/associate/data-engineer-dea-c01/notes/05-security-governance.md)
</details>

---

## Scoring guide

- **18-20 correct (90%+):** Strong. Schedule the exam.
- **15-17 correct (75-89%):** Solid. Targeted re-study on any wrong-answer domain, then schedule.
- **12-14 correct (60-74%):** Re-read the relevant notes and try again in a week.
- **<12 correct (<60%):** Spend 2-3 more weeks on weak domains before retesting.

Pair these with the [official sample questions](https://d1.awsstatic.com/training-and-certification/docs-data-engineer-associate/AWS-Certified-Data-Engineer-Associate_Sample-Questions.pdf) and an AWS Skill Builder practice exam for full coverage.
