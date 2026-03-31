# Databricks Data Engineer Associate - Study Strategy

## Study Approach

### Phase 1: Foundation Building (Weeks 1-2)

**Goal:** Master the Lakehouse platform and Spark SQL fundamentals.

1. **Lakehouse Architecture**
   - Understand why Lakehouse combines the best of data warehouses and data lakes
   - Learn the Databricks workspace, notebooks, and Repos
   - Know compute types: all-purpose clusters, job clusters, SQL warehouses, serverless
   - Understand Delta Lake as the storage layer (ACID, time travel, schema enforcement)

2. **Spark SQL and ELT**
   - Practice reading data from CSV, JSON, Parquet, and Delta sources
   - Master core SQL operations: SELECT, JOIN, GROUP BY, window functions
   - Learn MERGE INTO for upsert operations
   - Understand the medallion architecture (Bronze, Silver, Gold)
   - Practice higher-order functions on arrays and complex types

3. **Resources for Phase 1**
   - **[Databricks Community Edition](https://community.cloud.databricks.com/)** - Free practice environment
   - **[Lakehouse Architecture](https://docs.databricks.com/en/lakehouse/index.html)** - Lakehouse concepts
   - **[SQL Reference](https://docs.databricks.com/en/sql/language-manual/index.html)** - Complete SQL manual
   - **[Delta Lake Overview](https://docs.databricks.com/en/delta/index.html)** - Delta Lake fundamentals

### Phase 2: Core Skills (Weeks 3-4)

**Goal:** Master incremental processing, production pipelines, and data governance.

1. **Incremental Data Processing**
   - Learn Structured Streaming: readStream, writeStream, triggers, checkpointing
   - Master Auto Loader: cloudFiles format, schema evolution, file discovery modes
   - Understand when to use Auto Loader vs COPY INTO
   - Practice watermarking for late-arriving data

2. **Production Pipelines**
   - Learn Delta Live Tables: @dlt.table, @dlt.view, expectations
   - Know the three expectation behaviors: warn, drop, fail
   - Understand pipeline modes: triggered vs continuous
   - Master Databricks Jobs: scheduling, multi-task workflows, notifications

3. **Data Governance**
   - Learn Unity Catalog three-level namespace: catalog.schema.table
   - Practice GRANT and REVOKE statements
   - Understand managed vs external tables and volumes
   - Learn dynamic views for row-level and column-level security
   - Explore data lineage capabilities

4. **Resources for Phase 2**
   - **[Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - Incremental file ingestion
   - **[Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html)** - Declarative pipelines
   - **[Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Data governance
   - **[Databricks Jobs](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html)** - Job orchestration

### Phase 3: Exam Preparation (Week 5)

**Goal:** Review, practice, and build confidence for exam day.

1. **Comprehensive Review**
   - Re-read all five notes files and the fact sheet
   - Focus on the highest-weight domains: ELT (29%) and Lakehouse Platform (24%)
   - Create a summary of key differentiators (Auto Loader vs COPY INTO, managed vs external tables)
   - Review all Delta Lake commands: OPTIMIZE, VACUUM, RESTORE, DESCRIBE HISTORY

2. **Practice and Scenarios**
   - Work through scenarios.md exam-style questions
   - Take available practice exams from Databricks Academy
   - Review incorrect answers and understand why
   - Practice identifying wrong answers through elimination

3. **Resources for Phase 3**
   - **[Exam Guide](https://www.databricks.com/learn/certification/data-engineer-associate)** - Official exam page
   - **[Databricks Academy](https://www.databricks.com/learn)** - Practice exams and courses
   - **[Delta Lake Best Practices](https://docs.databricks.com/en/delta/best-practices.html)** - Production patterns

## Study Resources

### Official Databricks Resources
- **[Databricks Academy](https://www.databricks.com/learn)** - Free learning paths and courses
- **[Databricks Documentation](https://docs.databricks.com/)** - Complete platform documentation
- **[Databricks Community Edition](https://community.cloud.databricks.com/)** - Free practice environment
- **[Exam Registration](https://www.databricks.com/learn/certification/data-engineer-associate)** - Official exam page

### Documentation Deep Dives
- **[Delta Lake](https://docs.databricks.com/en/delta/index.html)** - Storage layer fundamentals
- **[Structured Streaming](https://docs.databricks.com/en/structured-streaming/index.html)** - Streaming reference
- **[Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - File ingestion
- **[Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html)** - Declarative pipelines
- **[Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Governance

### Community Resources
- **[Databricks Community Forum](https://community.databricks.com/)** - Community discussions
- **[Delta Lake Documentation](https://docs.delta.io/)** - Open-source Delta Lake docs
- **[Spark SQL Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)** - Apache Spark reference

## Exam Tactics

### Question Strategy
1. **Read the full question** - Look for keywords like "minimal effort," "most cost-effective," or "best practice"
2. **Eliminate wrong answers** - Remove options that use wrong compute types, incorrect syntax, or violate best practices
3. **Focus on the Databricks way** - Prefer platform-native solutions (Auto Loader over manual scripts, DLT over custom streaming)
4. **Consider production readiness** - Questions often test whether a solution works at scale
5. **Watch for subtle syntax differences** - MERGE INTO clauses, DLT decorators, and GRANT statements have specific syntax

### Time Management
- **45 questions in 90 minutes** = 2 minutes per question
- **First pass (60 minutes):** Answer confident questions, flag uncertain ones
- **Second pass (20 minutes):** Return to flagged questions with fresh perspective
- **Final review (10 minutes):** Check for unanswered questions and verify flagged answers
- Do not spend more than 3 minutes on any single question

### Key Differentiators to Study
These pairs are commonly tested because they are easy to confuse:

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| Auto Loader | COPY INTO | Streaming vs batch; Auto Loader scales to millions of files |
| All-purpose cluster | Job cluster | Interactive vs automated; job clusters are more cost-effective |
| Managed table | External table | Data deleted on DROP vs data preserved on DROP |
| `expect` | `expect_or_fail` | Warn and keep vs stop the pipeline |
| Temp view | Global temp view | Session-scoped vs cluster-scoped (global_temp database) |
| `availableNow` | `once` | Processes all data vs one batch; availableNow is preferred |
| Schema enforcement | Schema evolution | Rejects vs adapts to new columns |
| OPTIMIZE | VACUUM | Compacts small files vs removes old files |

### Common Pitfalls
- **Forgetting USE CATALOG/USE SCHEMA** - Both are required before accessing tables in Unity Catalog
- **Confusing DLT expectations** - Know the exact behavior of expect, expect_or_drop, and expect_or_fail
- **Mixing up trigger modes** - `availableNow` stops after processing; `processingTime` runs continuously
- **Ignoring checkpoint requirements** - Every streaming write needs a unique checkpoint location
- **VACUUM retention** - Default is 7 days (168 hours); setting too low can break time travel
