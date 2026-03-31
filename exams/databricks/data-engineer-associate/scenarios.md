# Databricks Data Engineer Associate - Exam-Style Scenarios

## Scenario 1: Choosing a Compute Resource

### Scenario
A data engineering team needs to run a nightly ETL pipeline that reads data from cloud storage, transforms it, and writes to Delta Lake tables. The pipeline takes approximately 45 minutes to run. The team wants to minimize costs while ensuring reliable execution.

**Question:** Which compute configuration should the team use?

**Options:**
A. An all-purpose cluster with autoscaling enabled, shared across the team
B. A job cluster configured in the job definition, terminated automatically after the job completes
C. A SQL warehouse with auto-stop set to 10 minutes
D. A serverless all-purpose cluster running continuously

**Correct Answer:** B

**Explanation:**
- Job clusters are created specifically for each job run and terminated when the job completes
- This is the most cost-effective option for scheduled ETL workloads
- Job clusters avoid paying for idle compute time between runs
- The cluster configuration is defined in the job, ensuring consistency

**Why other options are wrong:**
- **A:** All-purpose clusters remain running and cost money even when idle; they are for interactive development
- **C:** SQL warehouses are optimized for SQL queries and BI tools, not general ETL pipelines with Python/Spark
- **D:** Running continuously means paying for compute 24/7 when the job only needs 45 minutes

---

## Scenario 2: Incremental File Ingestion

### Scenario
A data engineer needs to ingest JSON files that arrive continuously in a cloud storage directory. The directory already contains 500,000 historical files and receives approximately 10,000 new files daily. The engineer needs to process new files incrementally and handle potential schema changes in the source data.

**Question:** Which approach should the engineer use?

**Options:**
A. COPY INTO with a scheduled job running every hour
B. Auto Loader with file notification mode and `cloudFiles.schemaEvolutionMode` set to `addNewColumns`
C. A batch Spark job that reads the entire directory each time and uses a watermark column to filter new data
D. Auto Loader with directory listing mode and no schema evolution

**Correct Answer:** B

**Explanation:**
- Auto Loader is designed for continuous incremental file ingestion at scale
- File notification mode is recommended for large directories (500,000+ files) as it uses cloud events instead of scanning the directory
- `addNewColumns` schema evolution mode automatically handles new columns appearing in the JSON data
- This combination provides scalability, efficiency, and schema flexibility

**Why other options are wrong:**
- **A:** COPY INTO is less scalable for this volume of files and does not handle schema evolution as well as Auto Loader
- **C:** Reading the entire directory each time is extremely inefficient with 500,000+ files
- **D:** Directory listing mode scans the entire directory each time - file notification mode is better for large directories; ignoring schema evolution is risky

---

## Scenario 3: Data Quality with Delta Live Tables

### Scenario
A pipeline processes financial transaction data through Bronze, Silver, and Gold layers. At the Silver layer, the team needs to enforce the following rules:
1. Transaction IDs must not be null (critical - pipeline should fail)
2. Transaction amounts must be positive (important - drop invalid records)
3. Currency codes should be in the allowed list (informational - log but keep)

**Question:** Which DLT expectation configuration correctly implements these rules?

**Options:**
A.
```python
@dlt.table
@dlt.expect_or_fail("valid_id", "transaction_id IS NOT NULL")
@dlt.expect_or_drop("positive_amount", "amount > 0")
@dlt.expect("valid_currency", "currency IN ('USD', 'EUR', 'GBP')")
def silver_transactions():
    return spark.read.table("bronze_transactions")
```

B.
```python
@dlt.table
@dlt.expect("valid_id", "transaction_id IS NOT NULL")
@dlt.expect("positive_amount", "amount > 0")
@dlt.expect("valid_currency", "currency IN ('USD', 'EUR', 'GBP')")
def silver_transactions():
    return spark.read.table("bronze_transactions")
```

C.
```python
@dlt.table
@dlt.expect_or_drop("valid_id", "transaction_id IS NOT NULL")
@dlt.expect_or_fail("positive_amount", "amount > 0")
@dlt.expect_or_drop("valid_currency", "currency IN ('USD', 'EUR', 'GBP')")
def silver_transactions():
    return spark.read.table("bronze_transactions")
```

D.
```python
@dlt.table
@dlt.expect_or_fail("valid_id", "transaction_id IS NOT NULL")
@dlt.expect_or_fail("positive_amount", "amount > 0")
@dlt.expect_or_fail("valid_currency", "currency IN ('USD', 'EUR', 'GBP')")
def silver_transactions():
    return spark.read.table("bronze_transactions")
```

**Correct Answer:** A

**Explanation:**
- `expect_or_fail` for transaction ID: null IDs are critical errors that should stop the pipeline
- `expect_or_drop` for amount: negative amounts are invalid records that should be silently removed
- `expect` for currency: unknown currencies are logged as warnings but records are kept for review
- Each rule uses the appropriate severity level matching the business requirements

**Why other options are wrong:**
- **B:** Using `expect` for all rules only logs warnings - invalid records are never removed or blocked
- **C:** The severity levels are reversed - it drops null IDs (should fail) and fails on invalid amounts (should drop)
- **D:** Failing on all rules is too aggressive - unknown currency codes should not stop the entire pipeline

---

## Scenario 4: Unity Catalog Permissions

### Scenario
A company has set up Unity Catalog with the following structure:
- Catalog: `production`
- Schema: `production.sales`
- Table: `production.sales.transactions`

The analytics team needs to read data from the transactions table but should not be able to modify any data or create new objects.

**Question:** What is the minimum set of GRANT statements required?

**Options:**
A.
```sql
GRANT SELECT ON TABLE production.sales.transactions TO analytics_team;
```

B.
```sql
GRANT USE CATALOG ON CATALOG production TO analytics_team;
GRANT USE SCHEMA ON SCHEMA production.sales TO analytics_team;
GRANT SELECT ON TABLE production.sales.transactions TO analytics_team;
```

C.
```sql
GRANT ALL PRIVILEGES ON CATALOG production TO analytics_team;
```

D.
```sql
GRANT USE CATALOG ON CATALOG production TO analytics_team;
GRANT SELECT ON TABLE production.sales.transactions TO analytics_team;
```

**Correct Answer:** B

**Explanation:**
- `USE CATALOG` is required to access any object within the catalog
- `USE SCHEMA` is required to access any object within the schema
- `SELECT` grants read access to the specific table
- All three grants are necessary - without USE CATALOG or USE SCHEMA, the team cannot navigate to the table

**Why other options are wrong:**
- **A:** Missing USE CATALOG and USE SCHEMA - the team cannot access the catalog or schema hierarchy
- **C:** ALL PRIVILEGES grants far more access than needed, including modify, create, and delete permissions
- **D:** Missing USE SCHEMA - even with USE CATALOG, the team cannot access the schema containing the table

---

## Scenario 5: Streaming Trigger Selection

### Scenario
A data engineering team runs a streaming pipeline that ingests data from a Delta table and writes to a downstream table. The pipeline is scheduled as a nightly Databricks job. The team wants the pipeline to process all data that has arrived since the last run and then stop, so the job cluster can be terminated.

**Question:** Which trigger mode should the team use?

**Options:**
A. `trigger(processingTime="1 minute")`
B. `trigger(availableNow=True)`
C. `trigger(continuous=True)`
D. No trigger specified (default)

**Correct Answer:** B

**Explanation:**
- `availableNow=True` processes all available data since the last checkpoint in multiple batches, then stops
- This is ideal for scheduled jobs where you want incremental processing without keeping the cluster running
- The stream maintains its checkpoint so it knows where to resume on the next run
- After processing completes, the job finishes and the cluster can terminate

**Why other options are wrong:**
- **A:** `processingTime` runs continuously at the specified interval - it never stops on its own
- **C:** There is no `continuous=True` trigger for writeStream; this is not valid syntax for this context
- **D:** The default trigger processes micro-batches as fast as possible and runs continuously - it never stops

---

## Scenario 6: Delta Lake Time Travel

### Scenario
A data engineer accidentally ran an UPDATE statement that corrupted data in a production table. The table was last known to be correct at version 12 (the current version is 15). The engineer needs to restore the table to its correct state.

**Question:** Which approach should the engineer use?

**Options:**
A. `DELETE FROM my_table WHERE 1=1` and then reinsert all historical data
B. `RESTORE TABLE my_table TO VERSION AS OF 12`
C. `SELECT * FROM my_table VERSION AS OF 12` and manually compare with current data
D. Run VACUUM immediately to remove the corrupted versions

**Correct Answer:** B

**Explanation:**
- RESTORE TABLE rolls back the table to a previous version, creating a new version in the process
- This is the simplest and most reliable way to undo accidental changes
- The table history is preserved - the current state becomes version 16 (a copy of version 12)
- No manual data manipulation or reprocessing is needed

**Why other options are wrong:**
- **A:** Deleting all data and reinserting is unnecessarily complex and error-prone
- **C:** Selecting from a historical version only reads the data - it does not restore the table
- **D:** VACUUM removes old data files and would make time travel to version 12 impossible if retention is exceeded

---

## Scenario 7: Auto Loader Schema Evolution

### Scenario
A data engineer uses Auto Loader to ingest JSON files into a Bronze Delta table. The source system recently added a new field called `loyalty_tier` to the JSON records. The engineer wants to automatically add this new column to the target table without manual intervention or pipeline failures.

**Question:** Which Auto Loader configuration should the engineer use?

**Options:**
A. `cloudFiles.schemaEvolutionMode` set to `failOnNewColumns`
B. `cloudFiles.schemaEvolutionMode` set to `none`
C. `cloudFiles.schemaEvolutionMode` set to `addNewColumns`
D. `cloudFiles.schemaEvolutionMode` set to `rescue`

**Correct Answer:** C

**Explanation:**
- `addNewColumns` automatically detects new fields in the source data and adds them as new columns to the target table
- This requires no manual intervention and does not cause pipeline failures
- The schema location stores the updated schema for future consistency
- This is the best option for Bronze tables where you want to capture all source data

**Why other options are wrong:**
- **A:** `failOnNewColumns` would cause the streaming pipeline to fail when the new field appears
- **B:** `none` silently ignores new columns - the `loyalty_tier` data would be lost
- **D:** `rescue` captures new column data in a `_rescued_data` column rather than adding a proper new column

---

## Scenario 8: Multi-Hop Architecture Design

### Scenario
A retail company wants to build a data pipeline with the following requirements:
1. Ingest raw transaction data from CSV files (preserving original data)
2. Clean and deduplicate records, joining with a customer dimension table
3. Create daily revenue aggregations by product category for the BI dashboard

**Question:** How should this pipeline be structured using the medallion architecture?

**Options:**
A. One Gold table that handles ingestion, cleaning, and aggregation in a single step
B. Bronze: ingest raw CSV data as-is; Silver: clean, deduplicate, and join with customers; Gold: aggregate daily revenue by category
C. Silver: ingest and clean data; Gold: join with customers and aggregate
D. Bronze: ingest and aggregate data; Silver: join with customers; Gold: clean and deduplicate

**Correct Answer:** B

**Explanation:**
- Bronze layer ingests raw CSV data with minimal transformation, preserving the original data for reprocessing
- Silver layer applies business logic: cleaning (removing nulls, fixing types), deduplication, and enrichment (joining with customer dimension)
- Gold layer creates business-level aggregations (daily revenue by product category) optimized for the BI dashboard
- Each layer adds data quality and business value

**Why other options are wrong:**
- **A:** A single table violates the medallion architecture principle of progressive data quality
- **C:** Skipping the Bronze layer means raw data is not preserved for reprocessing or auditing
- **D:** Aggregation should not happen at the Bronze layer, and cleaning should not happen at the Gold layer - this reverses the data quality progression
