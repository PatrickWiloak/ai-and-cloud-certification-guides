# Databricks Data Engineer Associate - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Data Engineer Associate
**Duration:** 90 minutes
**Questions:** 45 multiple-choice questions
**Passing Score:** 70% (approximately 32 correct)
**Cost:** $200 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/data-engineer-associate)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - Free learning paths and courses
**[📖 Databricks Community Edition](https://community.cloud.databricks.com/)** - Free practice environment

## Target Audience

This certification is designed for:
- Data engineers building ELT pipelines on Databricks
- SQL analysts transitioning to data engineering
- Data professionals with 6+ months Databricks experience
- Engineers familiar with Spark SQL and Python
- Professionals working with Delta Lake and Lakehouse architecture

## Domain 1: Databricks Lakehouse Platform (24%)

### Lakehouse Architecture

**[📖 What is a Lakehouse?](https://docs.databricks.com/en/lakehouse/index.html)** - Lakehouse architecture overview
**[📖 Delta Lake Overview](https://docs.databricks.com/en/delta/index.html)** - Delta Lake fundamentals
**[📖 Databricks Architecture](https://docs.databricks.com/en/getting-started/overview.html)** - Platform architecture

**Key Facts:**
- Lakehouse combines the best of data warehouses and data lakes
- Built on open formats (Delta Lake, Parquet) for data openness
- Single platform for BI, data science, ML, and streaming
- ACID transactions on data lake storage
- Schema enforcement prevents bad data from entering tables
- Supports both structured and unstructured data

**Lakehouse vs Data Warehouse vs Data Lake:**
| Feature | Data Lake | Data Warehouse | Lakehouse |
|---------|-----------|----------------|-----------|
| Data Types | All types | Structured | All types |
| ACID | No | Yes | Yes |
| Schema | Schema-on-read | Schema-on-write | Both |
| Cost | Low | High | Medium |
| BI Support | Limited | Strong | Strong |
| ML Support | Strong | Limited | Strong |

### Workspace and Notebooks

**[📖 Databricks Workspace](https://docs.databricks.com/en/workspace/index.html)** - Workspace navigation
**[📖 Notebooks](https://docs.databricks.com/en/notebooks/index.html)** - Notebook development
**[📖 Databricks Repos](https://docs.databricks.com/en/repos/index.html)** - Git integration

**Key Facts:**
- Notebooks support Python, SQL, Scala, and R
- Magic commands: `%sql`, `%python`, `%scala`, `%r`, `%md`
- `%run` executes another notebook in the same context
- `dbutils` provides utilities for file operations, secrets, and widgets
- Repos integrate with Git providers (GitHub, GitLab, Bitbucket, Azure DevOps)
- Notebooks can be scheduled as jobs

### Compute Resources

**[📖 Clusters](https://docs.databricks.com/en/compute/index.html)** - Cluster configuration
**[📖 SQL Warehouses](https://docs.databricks.com/en/sql/admin/sql-endpoints.html)** - SQL warehouse setup
**[📖 Cluster Pools](https://docs.databricks.com/en/compute/pool-index.html)** - Instance pools

**Key Facts:**
- All-purpose clusters: interactive development, shared by multiple users
- Job clusters: created and terminated per job run, cost-effective
- SQL warehouses: optimized for SQL workloads and BI tools
- Serverless compute: fully managed, no cluster management
- Cluster autoscaling: scales workers between min and max
- Photon: native vectorized query engine for faster SQL
- Cluster pools: pre-provisioned instances for faster cluster startup

## Domain 2: ELT with Spark SQL and Python (29%)

### Reading Data

**[📖 Data Sources](https://docs.databricks.com/en/connect/storage/index.html)** - Connecting to data sources
**[📖 File Format Options](https://docs.databricks.com/en/sql/language-manual/sql-ref-syntax-ddl-create-table-using.html)** - Supported file formats

**Key Facts:**
- `spark.read.format("csv").option("header", "true").load(path)` - Read CSV
- `spark.read.json(path)` - Read JSON
- `spark.read.parquet(path)` - Read Parquet
- `spark.table("table_name")` - Read from table
- COPY INTO loads data from files into Delta tables
- `inferSchema` option auto-detects column types (slower)
- `multiLine` option for multi-line JSON records

### Transformations

**[📖 Spark SQL Functions](https://docs.databricks.com/en/sql/language-manual/sql-ref-functions-builtin-alpha.html)** - Built-in SQL functions
**[📖 DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)** - Python DataFrame reference

**Key Transformations:**
- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `HAVING`
- `JOIN` types: INNER, LEFT, RIGHT, FULL, CROSS, SEMI, ANTI
- Window functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`
- `PIVOT` and `UNPIVOT` for reshaping data
- `explode()` - Flatten arrays into rows
- `posexplode()` - Flatten with position index
- `collect_set()`, `collect_list()` - Aggregate into arrays
- `from_json()`, `to_json()` - JSON parsing and creation
- `regexp_extract()`, `regexp_replace()` - Regex operations

### Writing Data

**[📖 Write to Delta](https://docs.databricks.com/en/delta/delta-batch.html)** - Writing to Delta tables
**[📖 MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)** - Upsert operations

**Key Facts:**
- `df.write.format("delta").mode("overwrite").saveAsTable("table")` - Create/overwrite table
- `df.write.mode("append")` - Append data
- MERGE INTO for upserts (insert, update, delete in one statement)
- CTAS: `CREATE TABLE t AS SELECT ...` creates Delta table by default
- `CREATE OR REPLACE TABLE` for idempotent table creation
- `INSERT OVERWRITE` replaces partition data
- Save modes: append, overwrite, errorIfExists, ignore

### Multi-Hop Architecture

**[📖 Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)** - Bronze, Silver, Gold pattern

**Key Facts:**
- Bronze: Raw data ingestion, minimal transformation
- Silver: Cleaned, filtered, augmented data
- Gold: Business-level aggregations and reporting
- Each layer adds data quality and business value
- Delta Lake enables ACID transactions at each layer

## Domain 3: Incremental Data Processing (17%)

### Structured Streaming

**[📖 Structured Streaming](https://docs.databricks.com/en/structured-streaming/index.html)** - Streaming overview
**[📖 Streaming with Delta](https://docs.databricks.com/en/structured-streaming/delta-lake.html)** - Delta as source and sink

**Key Facts:**
- `spark.readStream` starts a streaming read
- `df.writeStream` starts a streaming write
- Trigger modes:
  - `processingTime="10 seconds"` - micro-batch interval
  - `availableNow=True` - process all available data then stop
  - `once=True` - process one micro-batch then stop (deprecated)
- Checkpointing: stores streaming state for fault tolerance
- Output modes: append (new rows only), complete (all rows), update (changed rows)
- Exactly-once semantics with checkpointing and idempotent sinks

### Auto Loader

**[📖 Auto Loader](https://docs.databricks.com/en/ingestion/auto-loader/index.html)** - Incremental file ingestion
**[📖 Auto Loader Options](https://docs.databricks.com/en/ingestion/auto-loader/options.html)** - Configuration options

**Key Facts:**
- Uses `cloudFiles` format for incremental file discovery
- File notification mode (recommended for large directories) vs directory listing mode
- Schema inference: automatically detects schema from data
- Schema evolution: `cloudFiles.schemaEvolutionMode` (addNewColumns, rescue, failOnNewColumns, none)
- Rescue data column: `_rescued_data` captures schema mismatches
- `cloudFiles.format` specifies underlying file format (csv, json, parquet)
- More efficient than COPY INTO for streaming workloads

**Auto Loader vs COPY INTO:**
| Feature | Auto Loader | COPY INTO |
|---------|-------------|-----------|
| Approach | Streaming | Batch |
| File Discovery | Automatic | Manual/Scheduled |
| Schema Evolution | Built-in | Limited |
| Scalability | Millions of files | Thousands of files |
| Use Case | Continuous ingestion | Ad-hoc loading |

## Domain 4: Production Pipelines (13%)

### Delta Live Tables

**[📖 Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html)** - DLT overview
**[📖 DLT Expectations](https://docs.databricks.com/en/delta-live-tables/expectations.html)** - Data quality constraints

**Key Facts:**
- DLT simplifies ETL pipeline development with declarative syntax
- `@dlt.table` decorator defines a materialized table
- `@dlt.view` decorator defines a temporary view (not persisted)
- Expectations enforce data quality:
  - `@dlt.expect("valid_id", "id IS NOT NULL")` - Warn and keep invalid records
  - `@dlt.expect_or_drop("valid_id", "id IS NOT NULL")` - Drop invalid records
  - `@dlt.expect_or_fail("valid_id", "id IS NOT NULL")` - Fail pipeline on invalid
- Pipeline modes: triggered (runs once) vs continuous (always running)
- Event log tracks pipeline metrics and data quality results

### Databricks Jobs

**[📖 Databricks Jobs](https://docs.databricks.com/en/workflows/jobs/create-run-jobs.html)** - Job creation and scheduling
**[📖 Multi-task Jobs](https://docs.databricks.com/en/workflows/jobs/use-task-values.html)** - Task dependencies

**Key Facts:**
- Jobs can run notebooks, Python scripts, JARs, SQL, DLT pipelines
- Multi-task workflows with DAG-style dependencies
- Task types: notebook, Python script, SQL, DLT pipeline, dbt
- Scheduling: cron-based scheduling with timezone support
- Notifications: email, webhook, Slack on job events
- Retry policies: configurable retries on failure
- Job clusters: ephemeral clusters created per run (cost-effective)
- Parameters: pass runtime values to tasks

## Domain 5: Data Governance (17%)

### Unity Catalog

**[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - UC overview
**[📖 UC Privileges](https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html)** - Permission model
**[📖 Data Lineage](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html)** - Lineage tracking

**Key Facts:**
- Three-level namespace: `catalog.schema.table`
- Metastore: top-level container for all data assets
- Catalogs: organize schemas, typically per environment or domain
- Schemas: organize tables, views, functions
- Managed tables: data stored in metastore-managed storage
- External tables: data stored in customer-managed storage
- Volumes: manage non-tabular data (files, images, logs)
- Permissions: GRANT, REVOKE on securables
- Privilege inheritance: catalog -> schema -> table
- Data lineage: automatic tracking of data flow
- Dynamic views: row/column-level security
- Information schema: metadata queries

**Common GRANT Statements:**
```sql
GRANT USE CATALOG ON CATALOG catalog_name TO group_name;
GRANT USE SCHEMA ON SCHEMA catalog.schema TO group_name;
GRANT SELECT ON TABLE catalog.schema.table TO group_name;
GRANT CREATE TABLE ON SCHEMA catalog.schema TO group_name;
GRANT ALL PRIVILEGES ON SCHEMA catalog.schema TO group_name;
```

## Exam Tips

1. **Spark SQL and ELT (29%)** is the largest domain - master common SQL operations
2. **Delta Lake** concepts appear across all domains
3. **Auto Loader vs COPY INTO** - know when to use each
4. **DLT expectations** - understand the three constraint behaviors
5. **Unity Catalog namespace** - know the three-level hierarchy
6. **Cluster types** - all-purpose vs job clusters and their use cases
7. **Streaming triggers** - know each trigger mode and when to use it
8. **MERGE INTO** - understand upsert syntax and behavior
9. **Multi-hop architecture** - know Bronze, Silver, Gold purpose
10. **Time management** - 2 minutes per question average

## Quick Reference

### Essential SQL Commands
```sql
-- Delta Lake operations
DESCRIBE HISTORY table_name;
DESCRIBE DETAIL table_name;
OPTIMIZE table_name ZORDER BY (col);
VACUUM table_name RETAIN 168 HOURS;
RESTORE TABLE table_name TO VERSION AS OF 5;

-- Streaming
CREATE OR REFRESH STREAMING TABLE t AS SELECT * FROM STREAM(source);
CREATE OR REFRESH MATERIALIZED VIEW v AS SELECT * FROM source;

-- Unity Catalog
SHOW CATALOGS;
SHOW SCHEMAS IN catalog_name;
SHOW TABLES IN catalog_name.schema_name;
SHOW GRANTS ON TABLE catalog.schema.table;
```
