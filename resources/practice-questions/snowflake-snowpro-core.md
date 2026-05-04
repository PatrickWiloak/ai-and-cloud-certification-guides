# Snowflake SnowPro Core - Practice Questions

25 scenario-based questions for SnowPro Core prep.

> **Cert page:** [exams/snowflake/snowpro-core/](../../exams/snowflake/snowpro-core/)

---

### Question 1
**Scenario:** A query is running slow. The team checks the query profile and sees 80% of time spent in Remote Spilling. What does that mean?

A. Network is slow
B. The warehouse ran out of memory and is spilling to local disk and remote storage; needs a bigger warehouse
C. Snowflake is broken
D. Storage is slow

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Spilling = warehouse memory insufficient for the query. First spills to local SSD, then to remote storage (much slower). Fix: scale up warehouse size (X-Small → Small → Medium...) or rewrite the query to be more memory-efficient.
</details>

---

### Question 2
**Scenario:** Which Snowflake feature lets you query data without loading it (read directly from cloud storage)?

A. External Tables
B. Internal Stages
C. Secure Views
D. Stored Procedures

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** External Tables let you query files in S3/Azure Blob/GCS directly. Pay only for compute (no storage charge in Snowflake). Performance is slower than native tables; useful for occasional access to lake data.
</details>

---

### Question 3
**Scenario:** A team accidentally drops a table. How do they recover it?

A. Restore from backup
B. `UNDROP TABLE <name>` (within Time Travel retention period, default 1 day for Standard, up to 90 for Enterprise)
C. Cannot recover
D. File a support ticket

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowflake's Time Travel retention covers DROPs. UNDROP within retention restores the table. Beyond retention, Fail-safe (7 days, Snowflake-managed) is the next safety net but requires Snowflake Support.
</details>

---

### Question 4
**Scenario:** Which Snowflake edition supports multi-cluster warehouses?

A. Standard
B. Enterprise and above (Enterprise, Business Critical, VPS)
C. Only VPS
D. All editions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Multi-cluster warehouses (auto-scale clusters for concurrent queries) require Enterprise+. Standard supports only single-cluster warehouses. Multi-cluster is for handling high concurrency, not bigger queries.
</details>

---

### Question 5
**Scenario:** Snowflake's storage layer is:

A. Replicated across cloud regions automatically
B. Centralized columnar storage on the cloud provider's object store (S3 / ADLS / GCS), separated from compute
C. EBS volumes attached to compute
D. Local SSD only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowflake's three-layer architecture: storage (columnar, on cloud object storage), compute (virtual warehouses), services (metadata, optimizer). Storage and compute scale independently. Replication is configurable, not automatic.
</details>

---

### Question 6
**Scenario:** A virtual warehouse is sized X-Small. To halve query time, you'd typically:

A. Resize to Small (X-Small × 2)
B. Resize to 4X-Large
C. Add more clusters
D. Restart Snowflake

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Each warehouse size doubles compute. X-Small → Small ~halves query time on parallelizable queries. Diminishing returns after queries can no longer split work. Multi-cluster doesn't speed up a single query - it adds capacity for concurrent queries.
</details>

---

### Question 7
**Scenario:** A team wants to share a curated dataset with an external partner without copying it. Which feature?

A. Secure Data Sharing (cross-account share, no copies, partner pays for compute)
B. Data export to S3
C. CSV email
D. CDC replication

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Secure Data Sharing lets you share live tables/views/UDFs with another Snowflake account at no cost to you. Partner pays compute when they query. The Marketplace is built on this primitive.
</details>

---

### Question 8
**Scenario:** What's a "zero-copy clone"?

A. A clone that costs nothing
B. Snowflake clones share underlying storage; only changed micro-partitions consume new storage
C. Empty clones
D. A backup mechanism

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Zero-copy clones are metadata operations - the clone references the same micro-partitions as the source. Storage cost grows only when the clone diverges (writes). Cheap for dev/test environments.
</details>

---

### Question 9
**Scenario:** Loading data: COPY INTO vs Snowpipe?

A. COPY INTO is bulk load on demand; Snowpipe is continuous, file-arrival-triggered serverless ingestion
B. Identical
C. Snowpipe is for real-time streams only
D. COPY INTO is faster

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** COPY INTO is run-to-completion bulk loading from a stage. Snowpipe auto-ingests new files arriving in cloud storage (notification-driven), serverless, with per-file billing. Use COPY INTO for batch; Snowpipe for streams of files.
</details>

---

### Question 10
**Scenario:** Role hierarchy in Snowflake?

A. Roles inherit privileges from parent roles in a DAG; ACCOUNTADMIN is at the top of the system roles hierarchy
B. Flat single tier
C. Per-table only
D. No hierarchy

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Roles are hierarchical (DAG, not strict tree). Granting role A to role B gives B all of A's privileges. System roles: ACCOUNTADMIN > SECURITYADMIN, SYSADMIN > USERADMIN, PUBLIC. Users get roles; roles get privileges.
</details>

---

### Question 11
**Scenario:** Resource Monitors do what?

A. Monitor warehouse usage and trigger actions (notify, suspend) when credit thresholds are crossed
B. Track query performance only
C. Track network
D. Backup data

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Resource Monitors are budgets at the account or warehouse level. Set credit quotas (daily, weekly, monthly) and actions (notify, suspend, suspend-immediate). Critical for cost control.
</details>

---

### Question 12
**Scenario:** Which is fastest for analytical aggregations over 100M rows?

A. Materialized View on the aggregation
B. Plain query
C. External Table
D. Stored procedure

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Materialized Views pre-compute aggregations and auto-refresh. Massive query speedup for repeated heavy queries. Cost: storage + maintenance compute. Available in Enterprise+.
</details>

---

### Question 13
**Scenario:** Search Optimization Service helps which workload?

A. Point-lookup queries (`WHERE id = ?`) on large tables
B. Big aggregations
C. Time-series
D. Streaming inserts

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** SOS adds an inverted-index-like structure to speed up selective filters and equality predicates. Bigger gain on text columns and high-cardinality keys. Adds cost; enable per-table.
</details>

---

### Question 14
**Scenario:** Snowpark vs SQL?

A. Snowpark is a programmatic API (Python, Scala, Java) that compiles to SQL and runs on Snowflake's engine - useful for complex data engineering and ML feature engineering
B. They're identical
C. Snowpark replaces SQL
D. Snowpark is slower

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Snowpark lets you write data transformations in Python/Scala/Java with DataFrame API; lazy-compiles to optimized SQL pushdown. UDFs and stored procs in those languages. Brings Spark-like ergonomics to Snowflake.
</details>

---

### Question 15
**Scenario:** A team wants to query semi-structured JSON. What's idiomatic?

A. Parse JSON in application code
B. Snowflake's VARIANT type and FLATTEN function allow native SQL on JSON / XML / Avro / Parquet
C. External Spark
D. JSON isn't supported

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** VARIANT stores semi-structured data; access via dot or `:` notation (`v:user.name`). FLATTEN pivots arrays into rows. Native, fast, and SQL-friendly.
</details>

---

### Question 16
**Scenario:** A team queries a 1 TB table frequently filtered by `transaction_date`. Performance is poor. What helps most?

A. Add a B-tree index
B. Define a clustering key on `transaction_date` so micro-partitions are co-located by date and pruning is effective
C. Larger warehouse only
D. Disable result cache

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowflake doesn't have B-tree indexes. Clustering keys re-organize micro-partitions on the chosen columns so queries that filter on those columns scan fewer partitions. Use Automatic Clustering for steady maintenance. Reclustering has cost - apply only on heavily filtered, large tables.
</details>

---

### Question 17
**Scenario:** A virtual warehouse is X-Small but queries are slow due to long scans. The bottleneck shows full-scan on a 5 TB table. What's the lever?

A. Add more rows
B. Resize the warehouse (X-Small to Small / Medium / Large) - more compute scales scan throughput linearly; combine with clustering / pruning to reduce data read
C. Switch to Standard edition
D. Disable result cache

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Warehouse size doubles with each step (X-Small=1 credit/hr, Small=2, etc.) and roughly doubles compute. For pure scan-bound queries, larger warehouses help proportionally. Better: prune so you scan less in the first place. The two strategies stack.
</details>

---

### Question 18
**Scenario:** Time Travel default retention for a permanent Standard-edition table?

A. 0 days
B. 1 day (configurable up to 1 day on Standard, up to 90 days on Enterprise+)
C. 30 days
D. Forever

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Standard edition: 1 day. Enterprise+: up to 90 days. Time Travel allows AT/BEFORE queries, UNDROP, and CLONE from a past point. Fail-safe (additional 7 days, recoverable only by Snowflake support) follows Time Travel.
</details>

---

### Question 19
**Scenario:** Loading a 1 TB nightly dump from S3 - what's the fastest approach?

A. Many small INSERT statements
B. COPY INTO from a stage with files split into ~100-250 MB compressed chunks, multiple files in parallel; the warehouse parallelizes file ingestion across compute nodes
C. Single 1 TB file
D. Bulk PUT from a laptop

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** COPY INTO scales by parallelizing file ingestion. Snowflake docs recommend ~100-250 MB compressed file size for best parallelism. Single huge file or many tiny files both hurt throughput. Use Snowpipe for continuous ingest.
</details>

---

### Question 20
**Scenario:** Streams and Tasks - which describes their relationship?

A. Streams replace tables
B. Streams capture row-level changes (CDC) on a table; Tasks schedule SQL/Procedure execution. Combine them: a task runs on a schedule, consumes the stream's changes, processes them, advancing the stream offset on commit
C. Tasks send email
D. Streams require external Kafka

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Streams + Tasks is the native CDC pipeline pattern. Stream tracks INSERTs/UPDATEs/DELETEs since last consumption. Task schedules a MERGE or other downstream load. Self-contained ELT inside Snowflake.
</details>

---

### Question 21
**Scenario:** Sharing data with a partner outside your account without copying?

A. SFTP export
B. Secure Data Sharing - producer creates a share with selected objects; consumer accounts query in real time without data movement
C. S3 bucket
D. Snowpipe

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Secure Data Sharing is the native Snowflake feature. Zero-copy, no ETL, near-real-time. Consumer pays only for compute when querying. Use the Marketplace for monetized sharing or for browsing public datasets.
</details>

---

### Question 22
**Scenario:** Data masking on PII columns visible only to authorized roles?

A. Manual filtering in every query
B. Column-level Dynamic Data Masking policy applied to the column - masks values for unauthorized roles, returns clear values for authorized roles, transparent at query time
C. Encrypt with KMS
D. Drop the column

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Dynamic Data Masking is policy-based: define a UDF-like masking policy and apply to columns. Row Access Policies handle row-level filtering. Both are transparent and cannot be bypassed by app-side code.
</details>

---

### Question 23
**Scenario:** A user reports: "the query returned in 0 ms, no compute used." What happened?

A. Bug
B. Result cache hit - identical query within the cache TTL (default 24h) returned the prior result without using a warehouse
C. Time Travel
D. Snowpipe

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowflake's result cache returns prior results for byte-identical queries (same SQL, same role, no time-dependent functions, underlying micro-partitions unchanged). Free, instantaneous. To force re-compute, suspend cache or modify the query.
</details>

---

### Question 24
**Scenario:** Query history shows a query "spilled to remote storage" - what does that mean?

A. Network failure
B. Query needed more memory than the warehouse had so it spilled intermediate results to local SSD and then to remote (S3) storage - significantly slower; resize warehouse, optimize query, or reduce data scanned
C. Backup completed
D. Streaming write

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowflake spills (1) to local SSD, then (2) to remote storage when local is exhausted. Remote spill is a strong signal that the warehouse is undersized for the workload or that the query is producing massive intermediate state.
</details>

---

### Question 25
**Scenario:** Account-level security baseline beyond basic users/roles?

A. Public access only
B. Network policies (allow-list IPs), MFA enforcement, SCIM for user lifecycle from your IdP, key-pair auth for service accounts, password policies, audit via ACCESS_HISTORY view
C. Disable encryption
D. Single shared admin

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Layered baseline: network controls + identity (MFA/SCIM) + service account keys + audit trail. ACCESS_HISTORY (Enterprise+) tracks who accessed what columns/tables - critical for compliance reporting.
</details>

---

## Scoring guide

- **22-25:** Schedule the exam.
- **17-21:** Re-read architecture + Time Travel sections.
- **<17:** Hands-on Snowflake practice + re-read fact-sheet.

SnowPro Core: 100 questions, 115 minutes, 750/1000 (~75%) to pass. Foundational - tests architecture, SQL, account admin, performance, and core features. Hands-on with a free trial highly recommended.
