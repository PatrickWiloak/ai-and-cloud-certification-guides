# ELT with Spark SQL and Python - Databricks Data Engineer Associate

## Overview

This section covers ELT operations using Spark SQL and Python, which represents the largest domain at 29% of the exam. You need to master data extraction, transformation, and loading patterns using both SQL and DataFrame APIs.

**[📖 Spark SQL Reference](https://docs.databricks.com/en/sql/language-manual/index.html)** - Complete SQL language manual
**[📖 DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)** - PySpark DataFrame reference

## Key Topics

### 1. Reading Data from Various Sources

**[📖 Data Sources](https://docs.databricks.com/en/connect/storage/index.html)** - Connecting to data sources
**[📖 File Format Options](https://docs.databricks.com/en/sql/language-manual/sql-ref-syntax-ddl-create-table-using.html)** - Supported file formats

**Reading Files with Python:**
```python
# CSV with header and schema inference
df = spark.read.format("csv").option("header", "true").option("inferSchema", "true").load(path)

# JSON (single-line and multi-line)
df = spark.read.json(path)
df = spark.read.option("multiLine", "true").json(path)

# Parquet (schema embedded in file)
df = spark.read.parquet(path)

# Delta Lake table
df = spark.table("catalog.schema.table_name")
df = spark.read.format("delta").load(path)
```

**Reading Files with SQL:**
```sql
-- Query files directly
SELECT * FROM csv.`/path/to/files/`;
SELECT * FROM json.`/path/to/files/`;
SELECT * FROM parquet.`/path/to/files/`;

-- Create table from files
CREATE TABLE t USING CSV LOCATION '/path/to/files' OPTIONS (header = 'true');
```

**Key Concepts:**
- `inferSchema` auto-detects column types but is slower (reads data twice)
- `header` option tells Spark the first row of CSV contains column names
- Parquet and Delta files carry their schema - no inference needed
- `multiLine` is required for JSON records that span multiple lines

### 2. COPY INTO and Data Loading

**[📖 COPY INTO](https://docs.databricks.com/en/sql/language-manual/delta-copy-into.html)** - Incremental data loading

```sql
COPY INTO target_table
FROM '/path/to/source'
FILEFORMAT = CSV
FORMAT_OPTIONS ('header' = 'true', 'inferSchema' = 'true')
COPY_OPTIONS ('mergeSchema' = 'true');
```

**Key Concepts:**
- COPY INTO is idempotent - files already loaded are skipped
- Suitable for batch loading from cloud storage
- Tracks loaded files to avoid duplicates
- Less scalable than Auto Loader for large-scale continuous ingestion

### 3. Common Transformations

**[📖 Built-in Functions](https://docs.databricks.com/en/sql/language-manual/sql-ref-functions-builtin-alpha.html)** - SQL function reference

**SQL Transformations:**
```sql
-- Filtering and aggregation
SELECT department, COUNT(*) as count, AVG(salary) as avg_salary
FROM employees
WHERE status = 'active'
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY avg_salary DESC;

-- Window functions
SELECT name, department, salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as rank,
  LAG(salary) OVER (PARTITION BY department ORDER BY salary) as prev_salary
FROM employees;

-- Common Table Expressions (CTEs)
WITH ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY updated_at DESC) as rn
  FROM raw_data
)
SELECT * FROM ranked WHERE rn = 1;

-- PIVOT for reshaping data
SELECT * FROM sales
PIVOT (SUM(amount) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4'));
```

**DataFrame Transformations:**
```python
# Filtering
df.filter(col("status") == "active")
df.where("salary > 50000")

# Grouping and aggregation
df.groupBy("department").agg(
    count("*").alias("count"),
    avg("salary").alias("avg_salary")
)

# Joins
df1.join(df2, df1.id == df2.id, "left")
```

**Join Types:**
| Type | Description |
|------|-------------|
| INNER | Only matching rows from both tables |
| LEFT | All rows from left, matching from right |
| RIGHT | All rows from right, matching from left |
| FULL | All rows from both tables |
| CROSS | Cartesian product of both tables |
| SEMI | Rows from left that have a match in right |
| ANTI | Rows from left that have no match in right |

### 4. Complex Data Types and Higher-Order Functions

**[📖 Complex Types](https://docs.databricks.com/en/sql/language-manual/sql-ref-datatypes.html)** - Data type reference

```sql
-- Flatten arrays
SELECT explode(items) as item FROM orders;
SELECT posexplode(items) as (pos, item) FROM orders;

-- Collect into arrays
SELECT customer_id, collect_set(product) as unique_products FROM orders GROUP BY customer_id;

-- JSON parsing
SELECT from_json(json_col, 'struct<name:string,age:int>') as parsed FROM raw;

-- Higher-order functions
SELECT transform(array_col, x -> x * 2) as doubled FROM t;
SELECT filter(array_col, x -> x > 0) as positive FROM t;
SELECT exists(array_col, x -> x > 100) as has_large FROM t;
```

### 5. Writing Data to Delta Lake

**[📖 Write to Delta](https://docs.databricks.com/en/delta/delta-batch.html)** - Delta write operations
**[📖 MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)** - Upsert operations

**Write Operations:**
```python
# Create or overwrite table
df.write.format("delta").mode("overwrite").saveAsTable("catalog.schema.table")

# Append data
df.write.format("delta").mode("append").saveAsTable("catalog.schema.table")
```

```sql
-- Create Table As Select (CTAS)
CREATE TABLE target AS SELECT * FROM source;

-- Create or Replace Table (CRAS) - idempotent
CREATE OR REPLACE TABLE target AS SELECT * FROM source;

-- Insert overwrite
INSERT OVERWRITE target SELECT * FROM source;

-- MERGE INTO for upserts
MERGE INTO target USING source ON target.id = source.id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;
```

**Save Modes:**
| Mode | Behavior |
|------|----------|
| append | Add new rows to existing table |
| overwrite | Replace all data in the table |
| errorIfExists | Fail if the table already exists |
| ignore | Do nothing if the table already exists |

### 6. Multi-Hop (Medallion) Architecture

**[📖 Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)** - Bronze, Silver, Gold pattern

| Layer | Purpose | Data Quality |
|-------|---------|-------------|
| Bronze | Raw data ingestion, minimal transformation | Low - as-is from source |
| Silver | Cleaned, filtered, augmented, deduplicated | Medium - validated |
| Gold | Business-level aggregations and metrics | High - curated for consumption |

**Key Concepts:**
- Each layer uses Delta Lake for ACID transactions
- Bronze preserves raw data for reprocessing if needed
- Silver applies business rules, deduplication, and data quality checks
- Gold tables are optimized for BI dashboards and reporting
- Data flows from Bronze to Silver to Gold via ELT pipelines

### 7. Temporary Views

```sql
-- Temporary view (session-scoped)
CREATE OR REPLACE TEMP VIEW my_view AS SELECT * FROM source;

-- Global temporary view (cluster-scoped)
CREATE OR REPLACE GLOBAL TEMP VIEW my_view AS SELECT * FROM source;
SELECT * FROM global_temp.my_view;
```

**Key Concepts:**
- Temp views are visible only in the current SparkSession
- Global temp views are visible across all sessions in the same cluster
- Global temp views live in the `global_temp` database
- Neither type persists data - they are logical references to queries

## Exam Tips for This Domain

1. **This is the largest domain (29%)** - invest the most study time here
2. **Know both SQL and Python syntax** - questions may use either
3. **MERGE INTO** - understand all WHEN clauses and their behavior
4. **Window functions** - ROW_NUMBER, RANK, LAG, LEAD appear frequently
5. **CTAS vs CRAS** - CREATE OR REPLACE TABLE is idempotent; CREATE TABLE fails if exists
6. **Higher-order functions** - transform, filter, exists on arrays
7. **Join types** - especially SEMI and ANTI joins which are less common

## Documentation Links Summary

| Topic | Link |
|-------|------|
| SQL Reference | [docs.databricks.com/en/sql/language-manual/index.html](https://docs.databricks.com/en/sql/language-manual/index.html) |
| Built-in Functions | [docs.databricks.com/en/sql/language-manual/sql-ref-functions-builtin-alpha.html](https://docs.databricks.com/en/sql/language-manual/sql-ref-functions-builtin-alpha.html) |
| MERGE INTO | [docs.databricks.com/en/sql/language-manual/delta-merge-into.html](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html) |
| COPY INTO | [docs.databricks.com/en/sql/language-manual/delta-copy-into.html](https://docs.databricks.com/en/sql/language-manual/delta-copy-into.html) |
| Medallion Architecture | [docs.databricks.com/en/lakehouse/medallion.html](https://docs.databricks.com/en/lakehouse/medallion.html) |
