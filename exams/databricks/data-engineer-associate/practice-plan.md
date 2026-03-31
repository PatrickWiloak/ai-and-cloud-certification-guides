# Databricks Data Engineer Associate - Study Plan

## 5-Week Study Schedule

### Week 1: Lakehouse Platform and Spark SQL Basics (Domains 1-2)

#### Day 1-2: Lakehouse Architecture
- [ ] Understand Lakehouse vs data warehouse vs data lake
- [ ] Learn the Databricks platform architecture (control plane vs data plane)
- [ ] Explore the Databricks workspace interface
- [ ] Review Notes: `notes/01-lakehouse-platform.md`
- [ ] Read: [Lakehouse Architecture](https://docs.databricks.com/en/lakehouse/index.html)

#### Day 3-4: Compute Resources and Workspace
- [ ] Understand cluster types: all-purpose, job, SQL warehouse, serverless
- [ ] Learn autoscaling, spot instances, and cluster pools
- [ ] Practice notebook magic commands (`%sql`, `%python`, `%run`)
- [ ] Explore `dbutils` utilities (fs, secrets, widgets)
- [ ] Read: [Compute Overview](https://docs.databricks.com/en/compute/index.html)

#### Day 5-6: Spark SQL Fundamentals
- [ ] Review SELECT, JOIN, GROUP BY, and WHERE clauses
- [ ] Practice window functions (ROW_NUMBER, RANK, LAG, LEAD)
- [ ] Learn Common Table Expressions (CTEs)
- [ ] Understand temporary views vs global temporary views
- [ ] Review Notes: `notes/02-elt-spark-sql.md`
- [ ] Read: [SQL Reference](https://docs.databricks.com/en/sql/language-manual/index.html)

#### Day 7: Week 1 Review
- [ ] Review all notes from this week
- [ ] Quiz yourself on Lakehouse architecture benefits
- [ ] Practice identifying correct compute type for given scenarios
- [ ] Create flashcards for key SQL functions

### Week 2: ELT Deep Dive and Delta Lake (Domain 2)

#### Day 8-9: Reading and Writing Data
- [ ] Practice reading CSV, JSON, and Parquet files
- [ ] Learn COPY INTO for batch data loading
- [ ] Understand save modes (append, overwrite, errorIfExists, ignore)
- [ ] Practice CTAS and CREATE OR REPLACE TABLE statements
- [ ] Read: [Data Sources](https://docs.databricks.com/en/connect/storage/index.html)

#### Day 10-11: MERGE INTO and Complex Transformations
- [ ] Master MERGE INTO for upsert operations
- [ ] Practice complex data types: arrays, structs, maps
- [ ] Learn higher-order functions: transform, filter, exists
- [ ] Practice explode, posexplode, and collect_set/collect_list
- [ ] Read: [MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)

#### Day 12-13: Delta Lake Fundamentals
- [ ] Understand ACID transactions on Delta Lake
- [ ] Learn time travel (VERSION AS OF, TIMESTAMP AS OF, RESTORE)
- [ ] Practice OPTIMIZE, VACUUM, and Z-ordering commands
- [ ] Understand schema enforcement and schema evolution
- [ ] Read: [Delta Lake Overview](https://docs.databricks.com/en/delta/index.html)

#### Day 14: Week 2 Review
- [ ] Review the multi-hop (medallion) architecture pattern
- [ ] Practice writing MERGE INTO statements from scratch
- [ ] Review Delta Lake transaction log concepts
- [ ] Take notes on areas of confusion

### Week 3: Incremental Processing (Domain 3)

#### Day 15-16: Structured Streaming Basics
- [ ] Understand readStream vs read, writeStream vs write
- [ ] Learn trigger modes: default, processingTime, availableNow
- [ ] Understand output modes: append, complete, update
- [ ] Learn checkpointing and exactly-once guarantees
- [ ] Review Notes: `notes/03-incremental-processing.md`
- [ ] Read: [Structured Streaming](https://docs.databricks.com/en/structured-streaming/index.html)

#### Day 17-18: Auto Loader
- [ ] Learn the cloudFiles format and configuration options
- [ ] Understand file notification vs directory listing modes
- [ ] Practice schema inference and schema evolution settings
- [ ] Know when to use Auto Loader vs COPY INTO
- [ ] Read: [Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)

#### Day 19-20: Streaming Advanced Topics
- [ ] Understand watermarking for late-arriving data
- [ ] Learn stream-static joins
- [ ] Practice streaming with Delta Lake as source and sink
- [ ] Understand deduplication in streaming contexts
- [ ] Read: [Watermarks](https://docs.databricks.com/en/structured-streaming/watermarks.html)

#### Day 21: Week 3 Review
- [ ] Compare Auto Loader vs COPY INTO in a reference table
- [ ] Review all trigger modes and output modes
- [ ] Practice writing streaming pipelines from scratch
- [ ] Quiz yourself on checkpointing requirements

### Week 4: Production Pipelines and Governance (Domains 4-5)

#### Day 22-23: Delta Live Tables
- [ ] Learn DLT table and view decorators (Python) and SQL syntax
- [ ] Master all three expectation types (expect, expect_or_drop, expect_or_fail)
- [ ] Understand pipeline modes: triggered vs continuous
- [ ] Learn about the DLT event log for monitoring
- [ ] Review Notes: `notes/04-production-pipelines.md`
- [ ] Read: [Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html)

#### Day 24-25: Databricks Jobs and Workflows
- [ ] Create multi-task jobs with dependencies
- [ ] Learn task types: notebook, Python, SQL, DLT, dbt
- [ ] Understand scheduling (cron), notifications, and retry policies
- [ ] Practice passing values between tasks with dbutils.jobs.taskValues
- [ ] Read: [Databricks Jobs](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html)

#### Day 26-27: Unity Catalog and Governance
- [ ] Master the three-level namespace: catalog.schema.table
- [ ] Practice GRANT and REVOKE statements
- [ ] Understand managed vs external tables
- [ ] Learn dynamic views for row and column security
- [ ] Review Notes: `notes/05-data-governance.md`
- [ ] Read: [Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)

#### Day 28: Week 4 Review
- [ ] Review DLT expectations and their behaviors
- [ ] Practice writing GRANT statements from scratch
- [ ] Review data lineage and information schema concepts
- [ ] Compare managed vs external tables

### Week 5: Exam Preparation and Practice

#### Day 29-30: Comprehensive Review
- [ ] Re-read all five notes files
- [ ] Review the fact sheet for quick reference
- [ ] Focus on the two largest domains: ELT (29%) and Lakehouse Platform (24%)
- [ ] Create a one-page summary of key concepts

#### Day 31-32: Practice Scenarios
- [ ] Work through `scenarios.md` exam-style questions
- [ ] Take any available practice exams
- [ ] Review incorrect answers and identify weak areas
- [ ] Re-read documentation for topics you struggle with

#### Day 33-34: Final Preparation
- [ ] Review key differentiators (Auto Loader vs COPY INTO, managed vs external)
- [ ] Practice time management: 2 minutes per question
- [ ] Review Delta Lake commands one final time
- [ ] Skim the strategy guide for exam-day tactics

#### Day 35: Exam Day
- [ ] Light review of fact sheet only - no heavy studying
- [ ] Ensure stable internet and quiet environment
- [ ] Have valid ID ready for proctoring
- [ ] Take the exam with confidence

## Study Tips

### Time Allocation by Domain Weight
| Domain | Weight | Suggested Hours |
|--------|--------|----------------|
| ELT with Spark SQL and Python | 29% | 15-18 hours |
| Databricks Lakehouse Platform | 24% | 12-15 hours |
| Incremental Data Processing | 17% | 8-10 hours |
| Data Governance | 17% | 8-10 hours |
| Production Pipelines | 13% | 6-8 hours |

### Recommended Daily Schedule
- **30 min** reading documentation or notes
- **30 min** hands-on practice on Databricks Community Edition
- **15 min** reviewing flashcards or key concepts
- **Total: ~1.25 hours/day**

### Key Resources
- **[Databricks Community Edition](https://community.cloud.databricks.com/)** - Free practice environment
- **[Databricks Academy](https://www.databricks.com/learn)** - Free learning paths
- **[Exam Guide](https://www.databricks.com/learn/certification/data-engineer-associate)** - Official exam page
