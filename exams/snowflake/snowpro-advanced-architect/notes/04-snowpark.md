# Snowpark

**[📖 Snowpark Overview](https://docs.snowflake.com/en/developer-guide/snowpark/index)** - Snowpark developer guide

## Overview

This document covers the Snowpark developer framework, including the DataFrame API, stored procedures, user-defined functions (UDFs), and the execution model. Snowpark enables developers to build data pipelines and applications using Python, Java, and Scala that execute directly on Snowflake's compute infrastructure.

## Snowpark Architecture

### Execution Model
- Code runs on Snowflake virtual warehouses (pushdown execution)
- DataFrame operations translated to SQL and executed by Snowflake
- No data movement out of Snowflake for processing
- Lazy evaluation - operations build a query plan, executed on action
- Warehouses provide the compute resources for Snowpark execution

**[📖 Snowpark Python](https://docs.snowflake.com/en/developer-guide/snowpark/python/index)** - Python developer guide

### Supported Languages
| Language | API | Runtime | Package Management |
|----------|-----|---------|-------------------|
| Python | DataFrame, UDF, UDTF, Stored Proc | Python 3.8-3.11 | Anaconda channel |
| Java | DataFrame, UDF, UDTF, Stored Proc | JVM | Maven dependencies |
| Scala | DataFrame, UDF, UDTF, Stored Proc | JVM | Maven/SBT dependencies |

### Session and Connection
```python
from snowflake.snowpark import Session

connection_params = {
    "account": "myaccount",
    "user": "myuser",
    "password": "mypassword",
    "role": "DATA_ENGINEER",
    "warehouse": "COMPUTE_WH",
    "database": "MY_DB",
    "schema": "PUBLIC"
}

session = Session.builder.configs(connection_params).create()
```

## DataFrame API

### Creating DataFrames
```python
# From table
df = session.table("customers")

# From SQL query
df = session.sql("SELECT * FROM customers WHERE region = 'US'")

# From values
from snowflake.snowpark.types import StructType, StructField, StringType, IntegerType
schema = StructType([
    StructField("name", StringType()),
    StructField("age", IntegerType())
])
df = session.create_dataframe([("Alice", 30), ("Bob", 25)], schema)

# From staged files
df = session.read.csv("@my_stage/data.csv")
df = session.read.parquet("@my_stage/data.parquet")
df = session.read.json("@my_stage/data.json")
```

### DataFrame Operations
```python
from snowflake.snowpark.functions import col, lit, avg, sum, count, when

# Filter
df_filtered = df.filter(col("age") > 25)

# Select and rename
df_selected = df.select(col("name"), col("age").alias("customer_age"))

# Aggregation
df_agg = df.group_by("region").agg(
    avg("revenue").alias("avg_revenue"),
    count("*").alias("customer_count")
)

# Join
df_joined = orders.join(customers, orders["customer_id"] == customers["id"])

# Window functions
from snowflake.snowpark import Window
window = Window.partition_by("region").order_by(col("revenue").desc())
df_ranked = df.with_column("rank", rank().over(window))
```

### Lazy Evaluation and Actions
```python
# Transformations (lazy - build query plan)
df2 = df.filter(col("status") == "active")
df3 = df2.select("name", "email")

# Actions (trigger execution)
df3.show()           # Display results
df3.collect()        # Return rows as list
df3.count()          # Count rows
df3.write.save_as_table("output_table")  # Write to table
df3.to_pandas()      # Convert to pandas DataFrame
```

**[📖 DataFrame API](https://docs.snowflake.com/en/developer-guide/snowpark/python/working-with-dataframes)** - DataFrame operations

## User-Defined Functions (UDFs)

### Python UDFs
```python
from snowflake.snowpark.functions import udf
from snowflake.snowpark.types import StringType, IntegerType

# Inline UDF (registered in session)
@udf(name="categorize_age", return_type=StringType(),
     input_types=[IntegerType()], replace=True)
def categorize_age(age: int) -> str:
    if age < 18:
        return "minor"
    elif age < 65:
        return "adult"
    else:
        return "senior"

# Use in DataFrame operations
df.with_column("category", categorize_age(col("age")))
```

**[📖 Python UDFs](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udfs)** - UDF documentation

### SQL UDF Registration
```sql
-- Register UDF via SQL
CREATE OR REPLACE FUNCTION categorize_age(age INTEGER)
  RETURNS VARCHAR
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  HANDLER = 'categorize'
AS $$
def categorize(age):
    if age < 18:
        return "minor"
    elif age < 65:
        return "adult"
    else:
        return "senior"
$$;
```

### Vectorized UDFs
```python
from snowflake.snowpark.functions import udf
import pandas as pd

# Vectorized UDF processes batches (much faster for large datasets)
@udf(name="normalize_score", return_type=FloatType(),
     input_types=[FloatType(), FloatType(), FloatType()],
     packages=["pandas"], replace=True)
def normalize_score(score: pd.Series, min_val: pd.Series, max_val: pd.Series) -> pd.Series:
    return (score - min_val) / (max_val - min_val)
```

- Vectorized UDFs receive pandas Series instead of scalar values
- Process data in batches for significantly better performance
- Ideal for operations that benefit from vectorized computation
- Require the `pandas` package declaration

### User-Defined Table Functions (UDTFs)
```python
from snowflake.snowpark.functions import udtf
from snowflake.snowpark.types import StructType, StructField, StringType

# UDTF returns multiple rows per input
class SplitText:
    def process(self, text: str, delimiter: str):
        for part in text.split(delimiter):
            yield (part.strip(),)

split_udtf = session.udtf.register(
    SplitText,
    output_schema=StructType([StructField("word", StringType())]),
    input_types=[StringType(), StringType()],
    name="split_text",
    replace=True
)

# Use UDTF
df.join_table_function(split_udtf(col("description"), lit(",")))
```

**[📖 UDTFs](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udtfs)** - UDTF documentation

## Stored Procedures

### Python Stored Procedures
```python
from snowflake.snowpark import Session

# Register stored procedure
@session.sproc(name="process_daily_data", replace=True,
               packages=["snowflake-snowpark-python"])
def process_daily_data(session: Session, date: str) -> str:
    # Read source data
    source_df = session.table("raw_events").filter(col("event_date") == date)

    # Transform
    transformed = source_df.group_by("category").agg(
        count("*").alias("event_count"),
        sum("revenue").alias("total_revenue")
    )

    # Write results
    transformed.write.mode("overwrite").save_as_table("daily_summary")

    return f"Processed {transformed.count()} categories for {date}"

# Call stored procedure
session.call("process_daily_data", "2024-01-15")
```

**[📖 Stored Procedures](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-sprocs)** - Stored procedure guide

### Caller's Rights vs Owner's Rights
| Property | Caller's Rights | Owner's Rights |
|----------|----------------|----------------|
| Execution context | Caller's role and permissions | Owner's role and permissions |
| Access | Limited to caller's grants | Uses owner's grants |
| Use case | General utility functions | Privileged operations |
| Default | Yes (default) | Must specify EXECUTE AS OWNER |

```sql
-- Owner's rights stored procedure
CREATE OR REPLACE PROCEDURE admin_task()
  RETURNS VARCHAR
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
  EXECUTE AS OWNER
AS $$
def run(session):
    # Runs with owner's permissions
    session.sql("GRANT USAGE ON WAREHOUSE compute_wh TO ROLE analyst").collect()
    return "Grant applied"
$$;
```

## Package Management

### Anaconda Integration
- Snowflake provides curated Anaconda packages for Python
- Packages available without external network access
- Common packages: pandas, numpy, scikit-learn, xgboost, scipy
- Package versions managed by Snowflake for compatibility
- Custom packages can be uploaded to stages

**[📖 Anaconda Packages](https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-packages)** - Available packages

### Specifying Packages
```python
# In Python API
@udf(packages=["pandas", "numpy", "scikit-learn==1.3.0"])
def my_function(...):
    ...

# In SQL
CREATE FUNCTION my_function(...)
  RETURNS ...
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('pandas', 'numpy', 'scikit-learn==1.3.0')
  HANDLER = 'handler_function';
```

### Custom Packages
```python
# Upload custom package to stage
session.file.put("my_package.zip", "@my_stage/packages/", auto_compress=False)

# Reference in UDF
@udf(imports=["@my_stage/packages/my_package.zip"])
def my_function(...):
    import my_package
    ...
```

## Snowpark for Data Engineering

### Integration with Tasks
```sql
-- Create task that calls Snowpark stored procedure
CREATE TASK daily_processing
  WAREHOUSE = compute_wh
  SCHEDULE = 'USING CRON 0 6 * * * America/New_York'
AS
  CALL process_daily_data(CURRENT_DATE()::VARCHAR);

-- Start the task
ALTER TASK daily_processing RESUME;
```

### Integration with Streams
```python
# Read from stream in stored procedure
def process_changes(session: Session) -> str:
    changes = session.table("my_stream")
    inserts = changes.filter(col("METADATA$ACTION") == "INSERT")
    deletes = changes.filter(col("METADATA$ACTION") == "DELETE")

    # Process changes
    inserts.write.mode("append").save_as_table("target_table")
    return f"Processed {inserts.count()} inserts"
```

## External Functions

### Overview
- Call external APIs from within Snowflake SQL
- Implemented via API integrations and cloud functions (AWS Lambda, Azure Functions, GCP Cloud Functions)
- Enable integration with external services (ML models, third-party APIs)
- Request/response model with JSON payload

**[📖 External Functions](https://docs.snowflake.com/en/sql-reference/external-functions-introduction)** - External function guide

```sql
-- Create API integration
CREATE API INTEGRATION my_api_integration
  API_PROVIDER = aws_api_gateway
  API_AWS_ROLE_ARN = 'arn:aws:iam::123456789:role/my-role'
  API_ALLOWED_PREFIXES = ('https://api.example.com/')
  ENABLED = TRUE;

-- Create external function
CREATE EXTERNAL FUNCTION sentiment_analysis(text VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = my_api_integration
  AS 'https://api.example.com/sentiment';

-- Use in queries
SELECT text, sentiment_analysis(text) AS sentiment FROM reviews;
```

## Key Architecture Decisions

### When to Use Snowpark vs SQL
| Scenario | Recommendation |
|----------|---------------|
| Simple transformations (filter, join, aggregate) | SQL or Snowpark DataFrame |
| Complex business logic with conditionals | Snowpark stored procedures |
| ML model training and inference | Snowpark with ML packages |
| Integration with Python libraries | Snowpark UDFs |
| Performance-critical simple queries | SQL (lower overhead) |
| Reusable transformation libraries | Snowpark packages |
