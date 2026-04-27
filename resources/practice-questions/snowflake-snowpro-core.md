# Snowflake SnowPro Core - Practice Questions

15 scenario-based questions for SnowPro Core prep.

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

## Scoring guide

- **13-15:** Schedule the exam.
- **10-12:** Re-read architecture + Time Travel sections.
- **<10:** Hands-on Snowflake practice + re-read fact-sheet.

SnowPro Core: 100 questions, 115 minutes, 750/1000 (~75%) to pass. Foundational - tests architecture, SQL, account admin, performance, and core features. Hands-on with a free trial highly recommended.
