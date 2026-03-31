# Data Transformations

**[📖 SQL Reference](https://docs.snowflake.com/en/sql-reference)** - Complete SQL documentation

## Semi-Structured Data

**[📖 Semi-Structured Data](https://docs.snowflake.com/en/user-guide/semistructured-concepts)** - Working with VARIANT

### VARIANT Data Type

- Stores any type of semi-structured data (JSON, Avro, ORC, Parquet, XML)
- Maximum size: 16 MB per value
- Supports nested structures (objects within objects, arrays within arrays)
- Snowflake optimizes VARIANT storage using columnar techniques

### Data Types in VARIANT
- VARIANT - generic semi-structured container
- OBJECT - key-value pairs (similar to JSON object)
- ARRAY - ordered list of values

```sql
-- Create table with VARIANT column
CREATE TABLE raw_events (
  event_id NUMBER AUTOINCREMENT,
  event_data VARIANT,
  loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert JSON data
INSERT INTO raw_events (event_data)
SELECT PARSE_JSON('{
  "user": {"name": "John", "age": 30},
  "items": [{"product": "Widget", "qty": 5}],
  "timestamp": "2024-01-15T10:30:00Z"
}');
```

### Querying Semi-Structured Data

**Dot Notation:**
```sql
SELECT
  event_data:user.name::STRING AS user_name,
  event_data:user.age::NUMBER AS user_age,
  event_data:timestamp::TIMESTAMP AS event_time
FROM raw_events;
```

**Bracket Notation:**
```sql
SELECT
  event_data['user']['name']::STRING AS user_name,
  event_data['items'][0]['product']::STRING AS first_product
FROM raw_events;
```

**Key Points:**
- Always cast to specific types using `::TYPE` notation
- Dot notation is case-insensitive for keys
- Bracket notation preserves case sensitivity
- Array indexing is zero-based
- NULL is returned for non-existent paths (no error)

**[📖 Querying Semi-Structured Data](https://docs.snowflake.com/en/user-guide/querying-semistructured)** - Query patterns

### FLATTEN Function

**[📖 FLATTEN](https://docs.snowflake.com/en/sql-reference/functions/flatten)** - Array/object expansion

Converts nested arrays or objects into rows.

```sql
-- Flatten an array
SELECT
  e.event_data:user.name::STRING AS user_name,
  f.value:product::STRING AS product,
  f.value:qty::NUMBER AS quantity
FROM raw_events e,
LATERAL FLATTEN(input => e.event_data:items) f;
```

**FLATTEN Output Columns:**
- SEQ - sequence number
- KEY - key name (for objects) or index (for arrays)
- PATH - full path to the element
- INDEX - array index (NULL for objects)
- VALUE - the flattened value
- THIS - the element being flattened

**Recursive FLATTEN:**
```sql
-- Flatten all nested levels
SELECT f.path, f.key, f.value
FROM raw_events e,
LATERAL FLATTEN(input => e.event_data, RECURSIVE => TRUE) f;
```

### Semi-Structured Functions

```sql
-- Parse JSON string to VARIANT
SELECT PARSE_JSON('{"key": "value"}');

-- Convert VARIANT to JSON string
SELECT TO_JSON(variant_column);

-- Get array size
SELECT ARRAY_SIZE(event_data:items) FROM raw_events;

-- Construct arrays and objects
SELECT ARRAY_CONSTRUCT(1, 2, 3);
SELECT OBJECT_CONSTRUCT('key1', 'val1', 'key2', 'val2');

-- Check type
SELECT TYPEOF(event_data:user.name) FROM raw_events;

-- Array aggregation
SELECT ARRAY_AGG(column_name) FROM my_table;
```

**[📖 Semi-Structured Functions](https://docs.snowflake.com/en/sql-reference/functions-semistructured)** - Function reference

## Views

**[📖 Views](https://docs.snowflake.com/en/user-guide/views-introduction)** - View types and usage

### Regular Views
- Stores only the query definition (no data)
- Evaluated at query time
- View definition visible to users with sufficient privileges
- No performance benefit - runs the underlying query each time

```sql
CREATE VIEW sales_summary AS
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;
```

### Secure Views
- Definition hidden from consumers (SHOW VIEWS does not reveal SQL)
- Required for data sharing
- Optimizer may be less efficient (cannot push predicates through secure views)
- Use when data security outweighs performance considerations

```sql
CREATE SECURE VIEW customer_view AS
SELECT customer_id, name, email
FROM customers
WHERE region = CURRENT_USER_REGION();
```

### Materialized Views (Enterprise+)
- Pre-compute and store results
- Automatically updated when base data changes
- Serverless maintenance (compute cost)
- Restrictions: single table, no joins, no UDFs, no HAVING/ORDER BY/LIMIT
- Query optimizer can auto-route queries to materialized views

```sql
CREATE MATERIALIZED VIEW mv_daily_sales AS
SELECT date_trunc('day', sale_date) AS day, SUM(amount) AS daily_total
FROM sales
GROUP BY day;
```

**[📖 Materialized Views](https://docs.snowflake.com/en/user-guide/views-materialized)** - Materialized view details

## Streams (Change Data Capture)

**[📖 Streams](https://docs.snowflake.com/en/user-guide/streams-intro)** - CDC fundamentals

### Stream Types
- **Standard:** Tracks INSERT, UPDATE, DELETE
- **Append-Only:** Tracks INSERT only (lower overhead)
- **Insert-Only:** For external tables only

### Metadata Columns
- `METADATA$ACTION` - INSERT or DELETE
- `METADATA$ISUPDATE` - TRUE if row is part of an UPDATE (appears as DELETE + INSERT)
- `METADATA$ROW_ID` - Unique row identifier

```sql
-- Create a stream
CREATE STREAM my_stream ON TABLE source_table;

-- Query the stream (shows changes since last consumed)
SELECT * FROM my_stream;

-- Consume the stream in a DML transaction
INSERT INTO target_table
SELECT col1, col2 FROM my_stream WHERE METADATA$ACTION = 'INSERT';
```

### Stream Behavior
- Streams track changes between two transaction offsets
- Consuming a stream (via DML in a transaction) advances the offset
- Stale streams: offset falls behind Time Travel retention - stream becomes unusable
- STALE_AFTER column shows when stream may become stale
- Multiple streams can be created on the same table

### Check for Data in Stream
```sql
SELECT SYSTEM$STREAM_HAS_DATA('my_stream');
```

## Tasks

**[📖 Tasks](https://docs.snowflake.com/en/user-guide/tasks-intro)** - Task scheduling

### Creating Tasks

```sql
-- Cron-based schedule
CREATE TASK my_task
  WAREHOUSE = my_wh
  SCHEDULE = 'USING CRON 0 9 * * * America/New_York'
AS
  INSERT INTO target SELECT * FROM my_stream WHERE METADATA$ACTION = 'INSERT';

-- Interval-based schedule
CREATE TASK my_task
  WAREHOUSE = my_wh
  SCHEDULE = '5 MINUTE'
AS
  CALL my_procedure();

-- Serverless task (no warehouse needed)
CREATE TASK my_serverless_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '5 MINUTE'
AS
  INSERT INTO target SELECT * FROM source;
```

### Task Trees (DAGs)

```sql
-- Root task
CREATE TASK root_task
  WAREHOUSE = my_wh
  SCHEDULE = '10 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('my_stream')
AS
  INSERT INTO staging SELECT * FROM my_stream;

-- Child task (runs after root completes)
CREATE TASK child_task
  WAREHOUSE = my_wh
  AFTER root_task
AS
  MERGE INTO final_table ...;

-- Must resume child tasks before parent
ALTER TASK child_task RESUME;
ALTER TASK root_task RESUME;
```

**Key Rules:**
- Tasks are created in SUSPENDED state - must be explicitly resumed
- Child tasks must be resumed before parent tasks
- Only root tasks have a SCHEDULE - child tasks use AFTER
- WHEN clause only on root tasks (conditionally trigger the DAG)
- Maximum tree depth defined by Snowflake limits

## Stored Procedures

**[📖 Stored Procedures](https://docs.snowflake.com/en/sql-reference/stored-procedures)** - Procedure reference

### Languages
- SQL (Snowflake Scripting)
- JavaScript
- Python (Snowpark)
- Java (Snowpark)
- Scala (Snowpark)

### Execution Context
- **EXECUTE AS OWNER** (default) - runs with procedure owner's privileges
- **EXECUTE AS CALLER** - runs with caller's privileges

```sql
-- SQL stored procedure
CREATE PROCEDURE load_data(stage_name STRING)
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
AS
$$
BEGIN
  COPY INTO my_table FROM @stage_name;
  RETURN 'Load complete';
END;
$$;

CALL load_data('my_stage');
```

**[📖 Snowflake Scripting](https://docs.snowflake.com/en/developer-guide/snowflake-scripting/index)** - SQL procedural language

## User-Defined Functions (UDFs)

**[📖 UDFs](https://docs.snowflake.com/en/sql-reference/user-defined-functions)** - Function reference

### Scalar UDFs
```sql
-- SQL UDF
CREATE FUNCTION celsius_to_fahrenheit(celsius FLOAT)
  RETURNS FLOAT
AS
$$
  celsius * 9/5 + 32
$$;

SELECT celsius_to_fahrenheit(100); -- Returns 212
```

### Table Functions (UDTFs)
```sql
-- Return multiple rows
CREATE FUNCTION split_to_rows(input STRING, delimiter STRING)
  RETURNS TABLE (value STRING)
  LANGUAGE SQL
AS
$$
  SELECT value FROM TABLE(SPLIT_TO_TABLE(input, delimiter))
$$;
```

### UDF vs Stored Procedure

| Feature | UDF | Stored Procedure |
|---------|-----|-----------------|
| Returns | Value (required) | Optional |
| DML | No | Yes |
| DDL | No | Yes |
| Used in SQL | Yes (SELECT, WHERE) | No (CALL only) |
| Transaction | Cannot manage | Can manage |

## Common SQL Transformations

### MERGE Statement
```sql
MERGE INTO target t
USING source s ON t.id = s.id
WHEN MATCHED AND s.action = 'DELETE' THEN DELETE
WHEN MATCHED THEN UPDATE SET t.value = s.value
WHEN NOT MATCHED THEN INSERT (id, value) VALUES (s.id, s.value);
```

### Sequences
```sql
CREATE SEQUENCE my_seq START = 1 INCREMENT = 1;
SELECT my_seq.NEXTVAL; -- Returns next value
```

### CTAS and INSERT OVERWRITE
```sql
-- Create table from query
CREATE TABLE new_table AS SELECT * FROM old_table WHERE condition;

-- Replace all data in table
INSERT OVERWRITE INTO my_table SELECT * FROM source;
```

### Recursive CTEs
```sql
WITH RECURSIVE org_chart AS (
  SELECT employee_id, manager_id, name, 1 AS level
  FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.employee_id, e.manager_id, e.name, oc.level + 1
  FROM employees e JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;
```

**[📖 SQL Command Reference](https://docs.snowflake.com/en/sql-reference/sql-all)** - All SQL commands
