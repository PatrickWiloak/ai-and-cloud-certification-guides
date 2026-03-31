# Snowpark Python, Java, and Scala

**[📖 Snowpark Developer Guide](https://docs.snowflake.com/en/developer-guide/snowpark/index)** - Snowpark overview

## Overview

This document covers Snowpark development across Python, Java, and Scala, including the DataFrame API, UDF development, stored procedures, and integration patterns. For the Advanced Data Engineer exam, Python is the primary focus, but understanding cross-language capabilities is important.

## Snowpark Python

### Session Management
```python
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col, lit, when, sum, avg, count
from snowflake.snowpark.types import *

# Create session
session = Session.builder.configs({
    "account": "myaccount",
    "user": "myuser",
    "password": "mypassword",
    "role": "DATA_ENGINEER",
    "warehouse": "COMPUTE_WH",
    "database": "MY_DB",
    "schema": "PUBLIC"
}).create()

# Session context
session.use_warehouse("LARGE_WH")
session.use_database("ANALYTICS_DB")
session.use_schema("CURATED")
```

**[📖 Snowpark Python Setup](https://docs.snowflake.com/en/developer-guide/snowpark/python/setup)** - Installation and configuration

### DataFrame Operations

#### Reading Data
```python
# From table
customers = session.table("customers")

# From SQL
active_orders = session.sql("SELECT * FROM orders WHERE status = 'ACTIVE'")

# From staged files
csv_df = session.read.option("field_delimiter", ",").option("skip_header", 1).csv("@my_stage/data.csv")
parquet_df = session.read.parquet("@my_stage/data.parquet")
json_df = session.read.json("@my_stage/data.json")
```

#### Transformations
```python
# Filter
active = customers.filter(col("status") == "active")

# Select with expressions
selected = customers.select(
    col("id"),
    col("first_name"),
    col("last_name"),
    (col("first_name") + lit(" ") + col("last_name")).alias("full_name")
)

# Conditional columns
categorized = orders.with_column("size",
    when(col("amount") > 1000, lit("large"))
    .when(col("amount") > 100, lit("medium"))
    .otherwise(lit("small"))
)

# Aggregation
summary = orders.group_by("region", "product_category").agg(
    count("*").alias("order_count"),
    sum("amount").alias("total_revenue"),
    avg("amount").alias("avg_order_value")
)

# Join
enriched = orders.join(customers,
    orders["customer_id"] == customers["id"],
    join_type="left"
)

# Window functions
from snowflake.snowpark.functions import rank, row_number
from snowflake.snowpark import Window

window = Window.partition_by("region").order_by(col("revenue").desc())
ranked = sales.with_column("rank", rank().over(window))
```

**[📖 DataFrame Operations](https://docs.snowflake.com/en/developer-guide/snowpark/python/working-with-dataframes)** - DataFrame reference

#### Writing Data
```python
# Write to table (overwrite)
df.write.mode("overwrite").save_as_table("output_table")

# Write to table (append)
df.write.mode("append").save_as_table("output_table")

# Write to stage
df.write.csv("@my_stage/output/")
df.write.parquet("@my_stage/output/")

# Create or replace table
df.write.save_as_table("output_table", mode="overwrite", table_type="transient")
```

### Python UDFs

#### Scalar UDF
```python
from snowflake.snowpark.functions import udf
from snowflake.snowpark.types import StringType, IntegerType, FloatType

# Decorator-based registration
@udf(name="calculate_discount", return_type=FloatType(),
     input_types=[FloatType(), StringType()], replace=True,
     is_permanent=True, stage_location="@udf_stage")
def calculate_discount(price: float, tier: str) -> float:
    discounts = {"gold": 0.20, "silver": 0.10, "bronze": 0.05}
    return price * discounts.get(tier, 0)

# Use in DataFrame
orders.with_column("discount", calculate_discount(col("price"), col("tier")))
```

#### Vectorized UDF (Batch Processing)
```python
from snowflake.snowpark.functions import pandas_udf
from snowflake.snowpark.types import PandasSeriesType, PandasDataFrameType
import pandas as pd

# Vectorized UDF processes pandas Series (much faster)
@pandas_udf(name="normalize", return_type=PandasSeriesType(FloatType()),
            input_types=[PandasSeriesType(FloatType())], replace=True)
def normalize(series: pd.Series) -> pd.Series:
    return (series - series.mean()) / series.std()
```

- Vectorized UDFs process batches of rows as pandas Series
- Significantly faster than row-at-a-time scalar UDFs for large datasets
- Require pandas package declaration
- Best for numerical/statistical operations

**[📖 Vectorized UDFs](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udfs#vectorized-udfs)** - Batch processing

#### User-Defined Table Functions (UDTFs)
```python
from snowflake.snowpark.types import StructType, StructField, StringType, IntegerType

# Class-based UDTF
class SplitAndCount:
    def __init__(self):
        self.count = 0

    def process(self, text: str, delimiter: str):
        for word in text.split(delimiter):
            self.count += 1
            yield (word.strip(), self.count)

    def end_partition(self):
        yield ("TOTAL", self.count)

# Register UDTF
split_udtf = session.udtf.register(
    SplitAndCount,
    output_schema=StructType([
        StructField("word", StringType()),
        StructField("position", IntegerType())
    ]),
    input_types=[StringType(), StringType()],
    name="split_and_count",
    replace=True
)

# Use with table function
result = df.join_table_function(split_udtf(col("text"), lit(",")))
```

**[📖 UDTFs](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udtfs)** - Table function development

### Stored Procedures

#### Basic Stored Procedure
```python
from snowflake.snowpark import Session

@session.sproc(name="daily_etl", replace=True,
               packages=["snowflake-snowpark-python"])
def daily_etl(session: Session, target_date: str) -> str:
    # Read source data
    raw = session.table("raw_events").filter(col("event_date") == target_date)

    # Transform
    transformed = raw.select(
        col("event_id"),
        col("event_type"),
        col("user_id"),
        col("payload")
    ).filter(col("event_type").is_not_null())

    # Aggregate
    summary = transformed.group_by("event_type").agg(
        count("*").alias("event_count")
    )

    # Write
    summary.write.mode("overwrite").save_as_table(f"daily_summary_{target_date}")
    return f"Processed {transformed.count()} events for {target_date}"
```

#### Stored Procedure with Error Handling
```python
@session.sproc(name="safe_etl", replace=True,
               packages=["snowflake-snowpark-python"])
def safe_etl(session: Session, table_name: str) -> str:
    try:
        source = session.table(table_name)
        row_count = source.count()
        if row_count == 0:
            return "No data to process"

        result = source.filter(col("is_valid") == True)
        result.write.mode("append").save_as_table("processed_data")

        # Log success
        session.sql(f"""
            INSERT INTO etl_log (table_name, status, rows_processed, timestamp)
            VALUES ('{table_name}', 'SUCCESS', {row_count}, CURRENT_TIMESTAMP())
        """).collect()

        return f"Processed {row_count} rows from {table_name}"
    except Exception as e:
        session.sql(f"""
            INSERT INTO etl_log (table_name, status, error_message, timestamp)
            VALUES ('{table_name}', 'FAILED', '{str(e)}', CURRENT_TIMESTAMP())
        """).collect()
        raise
```

**[📖 Stored Procedures](https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-sprocs)** - Procedure guide

## Snowpark Java and Scala

### Java Example
```java
import com.snowflake.snowpark_java.*;
import com.snowflake.snowpark_java.Functions.*;

// Session creation
Session session = Session.builder().configs(properties).create();

// DataFrame operations
DataFrame orders = session.table("orders");
DataFrame filtered = orders.filter(Functions.col("amount").gt(100));
DataFrame summary = filtered.groupBy(Functions.col("region"))
    .agg(Functions.sum(Functions.col("amount")).as("total"));

summary.write().mode(SaveMode.Overwrite).saveAsTable("regional_summary");
```

**[📖 Snowpark Java](https://docs.snowflake.com/en/developer-guide/snowpark/java/index)** - Java developer guide

### Scala Example
```scala
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

// Session creation
val session = Session.builder.configs(Map(...)).create

// DataFrame operations
val orders = session.table("orders")
val filtered = orders.filter(col("amount") > 100)
val summary = filtered.groupBy(col("region"))
  .agg(sum(col("amount")).as("total"))

summary.write.mode(SaveMode.Overwrite).saveAsTable("regional_summary")
```

**[📖 Snowpark Scala](https://docs.snowflake.com/en/developer-guide/snowpark/scala/index)** - Scala developer guide

### Language Comparison
| Feature | Python | Java | Scala |
|---------|--------|------|-------|
| Package management | Anaconda channel | Maven | Maven/SBT |
| Vectorized UDFs | Yes (pandas) | No | No |
| ML libraries | scikit-learn, xgboost | Weka, DL4J | Spark MLlib |
| Pandas support | Native (to_pandas) | No | No |
| Community adoption | Highest | Moderate | Lower |
| Performance | Good (vectorized) | Good (JVM) | Good (JVM) |

## Package Management

### Available Anaconda Packages
```python
# Common packages available in Snowflake
# Data processing
import pandas as pd
import numpy as np

# ML/AI
from sklearn.ensemble import RandomForestClassifier
import xgboost as xgb
from scipy import stats

# Text processing
import re
import json

# Declare packages in UDF/procedure
@udf(packages=["pandas==2.0.3", "numpy", "scikit-learn==1.3.0"])
def my_function(...):
    ...
```

**[📖 Third-Party Packages](https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-packages)** - Package availability

### Custom Package Upload
```python
# Upload custom code to stage
session.file.put("local_module.py", "@code_stage/libs/", auto_compress=False)

# Reference in UDF
@udf(imports=["@code_stage/libs/local_module.py"])
def my_function(x):
    import local_module
    return local_module.process(x)
```

## Integration Patterns

### Snowpark with Tasks
```sql
-- Call Snowpark procedure from a task
CREATE TASK daily_transform
  WAREHOUSE = transform_wh
  SCHEDULE = 'USING CRON 0 6 * * * UTC'
AS
  CALL daily_etl(CURRENT_DATE()::VARCHAR);
```

### Snowpark with Streams
```python
@session.sproc(name="process_stream", replace=True)
def process_stream(session: Session) -> str:
    stream_df = session.table("my_stream")
    new_rows = stream_df.filter(col("METADATA$ACTION") == "INSERT")
    if new_rows.count() > 0:
        new_rows.write.mode("append").save_as_table("target")
        return f"Processed {new_rows.count()} new rows"
    return "No new data"
```

### Temporary vs Permanent Registration
| Registration | Scope | Persistence | Use Case |
|-------------|-------|-------------|----------|
| Temporary (default) | Session only | Dropped on session end | Ad-hoc analysis |
| Permanent | Database/schema | Persists across sessions | Production pipelines |

```python
# Permanent UDF (survives session end)
@udf(name="my_udf", is_permanent=True, stage_location="@udf_stage", replace=True)
def my_udf(...):
    ...

# Temporary UDF (session-scoped)
@udf(name="temp_udf")
def temp_udf(...):
    ...
```
