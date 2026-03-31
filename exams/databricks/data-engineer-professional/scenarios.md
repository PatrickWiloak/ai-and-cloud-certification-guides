# Databricks Data Engineer Professional - Exam-Style Scenarios

## Scenario 1: CDC Pipeline Design

### Scenario
A data engineering team needs to propagate changes from a Bronze table to a Silver table in their medallion architecture. The source system sends inserts, updates, and deletes. The team wants to capture all changes efficiently and use them for incremental Silver layer processing.

**Question:** What is the best approach to implement this incremental CDC pipeline?

**Options:**
A. Schedule a full table scan of the Bronze table every hour and compare with the Silver table using a LEFT ANTI JOIN to find changes
B. Enable Change Data Feed (CDF) on the Bronze table and use a streaming read with `readChangeFeed` to process changes incrementally, applying MERGE to the Silver table using foreachBatch
C. Use Auto Loader to watch the Bronze table's underlying files and reprocess changed files
D. Create a separate audit table that logs all changes and join it with the Bronze table on each run

**Correct Answer:** B

**Explanation:**
- Change Data Feed captures row-level changes (insert, update, delete) efficiently
- Streaming read of the change feed ensures only new changes are processed
- `foreachBatch` allows using MERGE within a streaming pipeline for proper upserts
- This approach is incremental, efficient, and handles all change types

**Why other options are wrong:**
- **A:** Full table scans are expensive and do not capture deletes efficiently
- **C:** Auto Loader watches file directories, not Delta table changes; it cannot detect row-level modifications
- **D:** Maintaining a separate audit table adds complexity and does not leverage built-in Delta features

---

## Scenario 2: SCD Type 2 Implementation

### Scenario
A retail company tracks customer dimension data and needs to maintain full history of changes for regulatory compliance. When a customer's address changes, the old record must be preserved with an end date, and a new current record must be created.

**Question:** Which approach correctly implements SCD Type 2 for the customer dimension?

**Options:**
A. Use a single MERGE statement with WHEN MATCHED THEN UPDATE SET address = source.address
B. Use a two-step process: first MERGE to expire current records (set is_current = false, end_date = current_date), then INSERT new records with is_current = true
C. Delete the old record and insert the new record in a single transaction
D. Use REPLACE WHERE to overwrite records matching the customer ID

**Correct Answer:** B

**Explanation:**
- SCD Type 2 requires maintaining both old and new records for history
- Step 1: MERGE expires the current record by setting is_current = false and setting the end_date
- Step 2: INSERT creates a new current record with is_current = true and a start_date of today
- This preserves the complete history chain for each customer

**Why other options are wrong:**
- **A:** This is SCD Type 1 (overwrite) - it loses the history of the previous address
- **C:** Deleting the old record destroys history, defeating the purpose of SCD Type 2
- **D:** REPLACE WHERE overwrites data without preserving history

---

## Scenario 3: Stream-Stream Join

### Scenario
An ad-tech platform needs to join an impressions stream with a clicks stream to calculate click-through rates. Clicks can arrive up to 2 hours after the corresponding impression. The join should match on impression_id and only count clicks that occurred within 1 hour of the impression.

**Question:** Which implementation correctly handles this stream-stream join?

**Options:**
A. Join both streams without watermarks using impression_id as the join key
B. Define watermarks on both streams (2 hours for impressions, 3 hours for clicks), and include a time range condition in the join limiting clicks to within 1 hour of the impression
C. Use a stream-static join where impressions are streaming and clicks are read as a batch table
D. Define a watermark only on the clicks stream and join on impression_id

**Correct Answer:** B

**Explanation:**
- Stream-stream joins require watermarks on both sides
- The impression watermark (2 hours) and click watermark (3 hours) define how long state is kept
- The time range condition (`click_time >= impression_time AND click_time <= impression_time + interval 1 hour`) bounds the join window
- This prevents unbounded state growth while capturing all relevant click-impression pairs

**Why other options are wrong:**
- **A:** Without watermarks, state grows indefinitely and eventually causes out-of-memory errors
- **C:** A stream-static join re-reads the static side each batch - inefficient and does not handle the continuous nature of clicks
- **D:** Both streams require watermarks for stream-stream joins to work properly

---

## Scenario 4: Performance Optimization

### Scenario
A data engineering team has a 10 TB Delta table that is queried frequently with filters on `region` and `date` columns. The table currently has no partitioning or clustering. Queries are slow due to full table scans. The team is creating a new replacement table.

**Question:** What is the recommended optimization strategy for the new table?

**Options:**
A. Partition by both `region` and `date`, then run OPTIMIZE with ZORDER BY on the same columns
B. Use liquid clustering with `CLUSTER BY (region, date)` and let Databricks handle optimization automatically
C. Partition by `date` only and add a secondary index on `region`
D. Do not partition or cluster; instead run OPTIMIZE daily and increase the SQL warehouse size

**Correct Answer:** B

**Explanation:**
- Liquid clustering is the recommended approach for new tables
- It provides automatic incremental clustering without manual OPTIMIZE runs
- Clustering columns can be changed later without rewriting the table
- It replaces the need for both partitioning and Z-ordering

**Why other options are wrong:**
- **A:** Partitioning and Z-ordering on the same columns is redundant and over-optimized; liquid clustering is simpler
- **C:** Delta Lake does not support secondary indexes; this is a relational database concept
- **D:** Without any data organization, queries will still require scanning large portions of the table regardless of warehouse size

---

## Scenario 5: Dynamic Views for Security

### Scenario
A healthcare company stores patient records in Unity Catalog. The compliance team requires that:
1. Only the medical team can see full patient names and diagnoses
2. The billing team can see patient IDs and billing amounts but not diagnoses
3. All other users can only see anonymized aggregate data

**Question:** Which approach correctly implements these requirements?

**Options:**
A. Create three separate tables with different data and grant each team access to their table
B. Create a single dynamic view that uses `is_member()` to conditionally show or mask columns based on group membership
C. Use row-level security only to filter records by department
D. Create separate schemas for each team and copy the data with appropriate columns

**Correct Answer:** B

**Explanation:**
- Dynamic views use `is_member()` to check group membership at query time
- Column masking with CASE statements can show full data to medical team, partial data to billing, and anonymized data to others
- Single source of truth - no data duplication or synchronization issues
- Permissions are enforced at the view level by Unity Catalog

**Why other options are wrong:**
- **A:** Maintaining three separate tables creates data duplication and synchronization challenges
- **C:** Row-level security alone does not address column-level masking requirements
- **D:** Copying data to separate schemas creates redundancy and governance complexity

---

## Scenario 6: Spark UI Troubleshooting

### Scenario
A data engineer notices that a Spark job has been running for 3 hours instead of the usual 30 minutes. Looking at the Spark UI, they observe:
- 199 out of 200 tasks in the current stage completed in under 2 minutes
- 1 task has been running for over 2.5 hours
- The long-running task shows significant spill to disk

**Question:** What is the most likely cause and the best solution?

**Options:**
A. The cluster needs more nodes - scale up the cluster size
B. Data skew is causing one partition to be much larger than others - enable AQE or apply salting to the skewed key
C. The checkpoint directory is corrupted - delete it and restart the job
D. The network is slow between nodes - switch to a different availability zone

**Correct Answer:** B

**Explanation:**
- The pattern of 199 fast tasks and 1 extremely slow task is the classic signature of data skew
- One partition contains far more data than others, causing the single task to process disproportionately more data
- Spill to disk confirms the task is handling too much data for its memory allocation
- AQE automatically detects and splits skewed partitions; salting redistributes data more evenly

**Why other options are wrong:**
- **A:** Adding nodes does not help because the bottleneck is a single task on a single partition
- **C:** Checkpoint corruption would cause errors, not slow performance with normal task completion
- **D:** Network slowness would affect all tasks, not just one

---

## Scenario 7: Auto Loader at Scale

### Scenario
A data platform receives 50,000 new JSON files daily into a cloud storage directory that already contains 10 million historical files. The team needs to ingest only new files incrementally. Files occasionally contain new fields that should be added to the target table.

**Question:** What is the optimal Auto Loader configuration?

**Options:**
A. Directory listing mode with `cloudFiles.schemaEvolutionMode` set to `none`
B. File notification mode with `cloudFiles.schemaEvolutionMode` set to `addNewColumns` and a schema location configured
C. File notification mode with `cloudFiles.schemaEvolutionMode` set to `failOnNewColumns`
D. Directory listing mode with `cloudFiles.schemaEvolutionMode` set to `rescue`

**Correct Answer:** B

**Explanation:**
- File notification mode uses cloud events to discover new files, which is critical for directories with millions of files
- Directory listing mode would need to scan 10 million files each time, which is slow and expensive
- `addNewColumns` automatically adds new fields to the target table as they appear
- Schema location persists the inferred schema for consistency across restarts

**Why other options are wrong:**
- **A:** Directory listing is inefficient for 10 million files; `none` ignores new columns (data loss)
- **C:** `failOnNewColumns` would cause the pipeline to fail when new fields appear, requiring manual intervention
- **D:** Directory listing is too slow; `rescue` captures new fields in `_rescued_data` rather than adding proper columns

---

## Scenario 8: VACUUM and Time Travel

### Scenario
A data engineer runs `VACUUM my_table RETAIN 24 HOURS` on a production table. Shortly after, a downstream consumer reports that their query using `SELECT * FROM my_table VERSION AS OF 50` (from 3 days ago) is failing with a file-not-found error.

**Question:** What caused this issue and how should it be prevented in the future?

**Options:**
A. The VACUUM command is buggy and should not be used on production tables
B. VACUUM removed the data files referenced by version 50 because the 24-hour retention was shorter than the 3-day age of that version; set VACUUM retention to at least 7 days (the default)
C. The downstream consumer needs to refresh their cache; no changes needed to VACUUM
D. Time travel does not work with VACUUM; use Delta Lake snapshots instead

**Correct Answer:** B

**Explanation:**
- VACUUM removes data files that are no longer referenced by the current version and are older than the retention period
- With 24-hour retention, files from version 50 (3 days old) were deleted
- The default retention of 7 days (168 hours) prevents this issue for most use cases
- Setting retention below 7 days requires explicitly disabling a safety check and risks breaking concurrent readers

**Why other options are wrong:**
- **A:** VACUUM works correctly; the issue is the misconfigured retention period
- **C:** The files are physically deleted; no amount of cache refreshing can recover them
- **D:** Time travel works with VACUUM as long as the retention period covers the desired version
