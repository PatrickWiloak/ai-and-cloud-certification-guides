# Pipeline Design - Databricks Data Engineer Professional

## Overview

This section covers advanced pipeline design patterns, representing the largest domain at 34% of the exam. You need to master complex data pipeline architectures including medallion patterns, CDC, SCD, and advanced MERGE operations.

**[📖 Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)** - Multi-hop pipeline patterns
**[📖 Delta Lake Best Practices](https://docs.databricks.com/en/delta/best-practices.html)** - Production patterns

## Key Topics

### 1. Advanced Medallion Architecture

**[📖 Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)** - Multi-hop design

**Key Concepts:**
- Bronze: raw data ingestion with minimal transformation, append-only
- Silver: cleaned, deduplicated, enriched, conformed data
- Gold: business-level aggregations and domain-specific data products
- Each layer adds data quality and reduces data volume
- Design for idempotency - re-running the pipeline produces the same result
- Use Delta Lake MERGE for incremental updates across layers

**Design Principles:**
- Decouple ingestion from transformation for independent scaling
- Use checkpoint-based processing to handle failures gracefully
- Implement data quality checks at layer boundaries
- Design for schema evolution in Bronze and Silver layers
- Gold tables should be optimized for specific query patterns

### 2. Change Data Capture (CDC)

CDC captures row-level changes (inserts, updates, deletes) from source systems and propagates them through the pipeline.

**[📖 Change Data Feed](https://docs.databricks.com/en/delta/delta-change-data-feed.html)** - CDF in Delta Lake

**Enabling Change Data Feed:**
```sql
-- Enable on existing table
ALTER TABLE my_table SET TBLPROPERTIES (delta.enableChangeDataFeed = true);

-- Enable on new table
CREATE TABLE my_table (id INT, name STRING)
TBLPROPERTIES (delta.enableChangeDataFeed = true);
```

**Reading Change Data:**
```python
# Batch read changes from version 5
changes = (spark.read.format("delta")
    .option("readChangeFeed", "true")
    .option("startingVersion", 5)
    .table("my_table"))

# Streaming read of changes
changes_stream = (spark.readStream.format("delta")
    .option("readChangeFeed", "true")
    .option("startingVersion", 5)
    .table("my_table"))
```

**Change Types in `_change_type` Column:**
| Value | Description |
|-------|-------------|
| `insert` | New row was added |
| `update_preimage` | Row value before the update |
| `update_postimage` | Row value after the update |
| `delete` | Row was deleted |

**Key Concepts:**
- CDF is efficient for downstream incremental processing
- Only captures changes after CDF is enabled (not retroactive)
- Combine CDF with MERGE to propagate changes through medallion layers
- CDF adds `_change_type`, `_commit_version`, and `_commit_timestamp` columns

### 3. Slowly Changing Dimensions (SCD)

**SCD Type 1 - Overwrite:**
```sql
MERGE INTO dim_customer AS target
USING updates AS source
ON target.customer_id = source.customer_id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;
```

**SCD Type 2 - History Tracking:**
```sql
-- Step 1: Expire current records being updated
MERGE INTO dim_customer AS target
USING (
  SELECT source.* FROM updates source
  JOIN dim_customer target ON source.customer_id = target.customer_id
  WHERE target.is_current = true
) AS expired
ON target.customer_id = expired.customer_id AND target.is_current = true
WHEN MATCHED THEN UPDATE SET
  target.is_current = false,
  target.end_date = current_date();

-- Step 2: Insert new current records
INSERT INTO dim_customer
SELECT *, true AS is_current, current_date() AS start_date, NULL AS end_date
FROM updates;
```

**Key Concepts:**
- SCD Type 1 overwrites old values with no history
- SCD Type 2 maintains full history with effective dates and current flags
- SCD Type 2 requires a surrogate key since the business key has multiple rows
- Use window functions to derive `is_current` flags after the fact

### 4. Complex MERGE Operations

**[📖 MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)** - Advanced upsert patterns

```sql
MERGE INTO target
USING source
ON target.id = source.id
WHEN MATCHED AND source.action = 'DELETE' THEN DELETE
WHEN MATCHED AND source.action = 'UPDATE' THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *
WHEN NOT MATCHED BY SOURCE THEN DELETE;
```

**Key Concepts:**
- `WHEN NOT MATCHED BY SOURCE` handles records in target that have no match in source
- Multiple WHEN MATCHED clauses with conditions for different actions
- Schema evolution with MERGE: `SET * ` with `spark.conf.set("spark.databricks.delta.schema.autoMerge.enabled", "true")`
- MERGE is the primary mechanism for incremental updates in production pipelines

### 5. Semi-Structured Data Processing

**[📖 Semi-structured Data](https://docs.databricks.com/en/optimizations/semi-structured.html)** - Nested data

```sql
-- Access nested struct fields with dot notation
SELECT address.city, address.state FROM customers;

-- Access variant/JSON fields with colon notation
SELECT payload:user:name::string AS name FROM events;

-- Flatten arrays of structs
SELECT inline(items) FROM orders;

-- Higher-order functions
SELECT transform(prices, x -> x * 1.1) AS adjusted_prices FROM products;
SELECT filter(scores, x -> x > 80) AS passing_scores FROM students;
SELECT aggregate(values, 0, (acc, x) -> acc + x) AS total FROM data;
```

**Key Concepts:**
- Dot notation for struct fields: `column.field`
- Colon notation for variant/JSON fields: `column:field`
- `explode()` flattens arrays into rows
- `inline()` flattens arrays of structs into columns and rows
- Higher-order functions avoid expensive UDFs for array manipulation

### 6. Idempotent Pipeline Design

**Key Concepts:**
- Idempotent operations produce the same result when run multiple times
- Use `CREATE OR REPLACE TABLE` instead of `CREATE TABLE` for idempotency
- Use `INSERT OVERWRITE` instead of `INSERT INTO` for reprocessable partitions
- MERGE INTO is naturally idempotent when the join condition is correct
- Design pipelines so that re-running after a failure does not produce duplicates
- Store processing metadata (watermarks, versions) for recovery

## Exam Tips for This Domain

1. **CDC with CDF** - Know how to enable, read, and process change data feeds
2. **SCD Type 2** - Understand the two-step MERGE pattern for history tracking
3. **Idempotency** - Every pipeline should produce the same result on re-run
4. **Semi-structured data** - Know dot vs colon notation, explode vs inline
5. **Complex MERGE** - Multiple WHEN clauses, WHEN NOT MATCHED BY SOURCE
6. **Higher-order functions** - transform, filter, aggregate on arrays

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Medallion Architecture | [docs.databricks.com/en/lakehouse/medallion.html](https://docs.databricks.com/en/lakehouse/medallion.html) |
| Change Data Feed | [docs.databricks.com/en/delta/delta-change-data-feed.html](https://docs.databricks.com/en/delta/delta-change-data-feed.html) |
| MERGE INTO | [docs.databricks.com/en/sql/language-manual/delta-merge-into.html](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html) |
| Delta Best Practices | [docs.databricks.com/en/delta/best-practices.html](https://docs.databricks.com/en/delta/best-practices.html) |
| Semi-structured Data | [docs.databricks.com/en/optimizations/semi-structured.html](https://docs.databricks.com/en/optimizations/semi-structured.html) |
