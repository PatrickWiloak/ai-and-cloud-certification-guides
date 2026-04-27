# Databricks Certified Data Engineer Associate

## Exam Overview

The Databricks Certified Data Engineer Associate certification validates foundational knowledge of the Databricks Lakehouse Platform and the ability to use Spark SQL and Python to build and manage ELT pipelines. This certification demonstrates proficiency in data engineering concepts including Delta Lake, Structured Streaming, Delta Live Tables, and Unity Catalog.

**Exam Details:**
- **Exam Code:** Databricks Certified Data Engineer Associate
- **Duration:** 90 minutes
- **Number of Questions:** 45 multiple-choice questions
- **Passing Score:** 70% (approximately 32 correct answers)
- **Cost:** $200 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (6+ months hands-on Databricks experience recommended)

## Exam Domains

### Domain 1: Databricks Lakehouse Platform (24%)
- Understand the Lakehouse architecture and its advantages
- Navigate the Databricks workspace
- Understand compute resources (clusters, SQL warehouses)
- Use Databricks Repos and notebooks
- Understand the relationship between Databricks and Apache Spark

**Key Concepts:**
- Lakehouse vs Data Warehouse vs Data Lake
- Databricks workspace organization (notebooks, repos, jobs)
- All-purpose clusters vs job clusters
- Cluster configuration (autoscaling, spot instances, pools)
- SQL warehouses and serverless compute
- Databricks Runtime versions

### Domain 2: ELT with Spark SQL and Python (29%)
- Extract data from various sources
- Transform data using Spark SQL and Python
- Load data into Delta Lake tables
- Write queries to explore and manipulate data
- Use Spark SQL built-in functions

**Key Concepts:**
- Reading data from files (CSV, JSON, Parquet) and databases
- DataFrame API vs Spark SQL syntax
- Common transformations (filtering, joining, aggregating, pivoting)
- Writing to Delta Lake tables (append, overwrite, merge)
- Higher-order functions and complex data types
- User-defined functions (UDFs) and when to avoid them
- Multi-hop architecture (Bronze, Silver, Gold)
- CTAS (CREATE TABLE AS SELECT) statements

### Domain 3: Incremental Data Processing (17%)
- Understand Structured Streaming concepts
- Configure streaming reads and writes
- Use Auto Loader for file ingestion
- Understand trigger modes and checkpointing

**Key Concepts:**
- Structured Streaming fundamentals (sources, sinks, triggers)
- Auto Loader (cloudFiles) for incremental file ingestion
- Schema inference and schema evolution with Auto Loader
- Trigger modes (availableNow, processingTime, continuous)
- Checkpointing and exactly-once semantics
- Watermarking for late-arriving data
- Output modes (append, complete, update)

### Domain 4: Production Pipelines (13%)
- Create and manage Delta Live Tables pipelines
- Schedule and orchestrate jobs
- Understand pipeline modes (triggered vs continuous)
- Handle pipeline errors and data quality

**Key Concepts:**
- Delta Live Tables (DLT) fundamentals
- DLT expectations for data quality constraints
- Pipeline modes: triggered vs continuous
- Databricks Jobs and job orchestration
- Task dependencies and multi-task workflows
- Job scheduling and notifications
- Monitoring pipeline health

### Domain 5: Data Governance (17%)
- Understand Unity Catalog architecture
- Manage data access with Unity Catalog
- Implement data governance best practices
- Understand data lineage and auditing

**Key Concepts:**
- Unity Catalog three-level namespace (catalog.schema.table)
- Metastore, catalogs, schemas, and tables
- Managed vs external tables and volumes
- GRANT and REVOKE permissions
- Data lineage tracking
- Row-level and column-level security
- Dynamic views for data masking
- Information schema for metadata queries

## Key Concepts to Master

### Delta Lake Fundamentals
- ACID transactions on data lakes
- Time travel (versioning, RESTORE)
- Schema enforcement and evolution
- OPTIMIZE and VACUUM commands
- Z-ordering for query optimization
- Delta Lake transaction log

### Spark SQL Essentials
- SELECT, JOIN, GROUP BY, WINDOW functions
- Common Table Expressions (CTEs)
- Temporary views vs global temporary views
- MERGE INTO for upsert operations
- COPY INTO for data loading

### Streaming Concepts
- Micro-batch vs continuous processing
- Exactly-once processing guarantees
- Stream-static joins
- Incremental data ingestion patterns

## Study Approach

### Phase 1: Foundation (Week 1-2)
1. Understand the Lakehouse architecture and how Databricks implements it
2. Get comfortable with the Databricks workspace and notebook environment
3. Review Spark SQL basics and DataFrame API operations
4. Learn Delta Lake fundamentals (ACID, time travel, schema enforcement)

### Phase 2: Core Skills (Week 3-4)
1. Practice ELT operations with Spark SQL and Python
2. Learn Structured Streaming and Auto Loader
3. Understand Delta Live Tables pipeline creation
4. Study Unity Catalog governance model

### Phase 3: Exam Prep (Week 5-6)
1. Take practice exams and review incorrect answers
2. Focus on weak areas identified in practice tests
3. Review all domain-specific notes and fact sheets
4. Time yourself on practice questions (2 min per question)

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - Free learning paths and courses
- **[Databricks Documentation](https://docs.databricks.com/)** - Official documentation
- **[Databricks Community Edition](https://community.cloud.databricks.com/)** - Free practice environment
- **[Exam Guide](https://www.databricks.com/learn/certification/data-engineer-associate)** - Official exam page and registration
- **[Delta Lake Documentation](https://docs.delta.io/)** - Open-source Delta Lake docs
- **[Spark SQL Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)** - Apache Spark SQL reference

## Tips for Success

1. **Hands-on practice is essential** - Use Databricks Community Edition to practice
2. **Focus on Spark SQL** - Domain 2 is the largest at 29%
3. **Understand the "why"** - Know why Lakehouse is better than alternatives for specific use cases
4. **Delta Lake is foundational** - It appears in almost every domain
5. **Auto Loader vs COPY INTO** - Know when to use each approach
6. **DLT expectations** - Understand how constraints affect data quality
7. **Unity Catalog permissions** - Know the GRANT model and namespace hierarchy
8. **Read questions carefully** - Look for keywords like "minimal effort" or "most cost-effective"
9. **Eliminate wrong answers** - Many distractors use real services in wrong contexts
10. **Time management** - 2 minutes per question, flag and return to difficult ones

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule with checkboxes |
| [scenarios.md](scenarios.md) | Exam-style scenarios with solutions |
| [strategy.md](strategy.md) | Study phases, resources, and exam tactics |
| [notes/01-lakehouse-platform.md](notes/01-lakehouse-platform.md) | Lakehouse architecture and workspace |
| [notes/02-elt-spark-sql.md](notes/02-elt-spark-sql.md) | ELT with Spark SQL and Python |
| [notes/03-incremental-processing.md](notes/03-incremental-processing.md) | Structured Streaming and Auto Loader |
| [notes/04-production-pipelines.md](notes/04-production-pipelines.md) | Delta Live Tables and job orchestration |
| [notes/05-data-governance.md](notes/05-data-governance.md) | Unity Catalog and data governance |
