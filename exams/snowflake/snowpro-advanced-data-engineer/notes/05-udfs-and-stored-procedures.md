# UDFs and Stored Procedures

**[📖 UDF Overview](https://docs.snowflake.com/en/developer-guide/udf/udf-overview)** - User-defined functions
**[📖 Stored Procedures](https://docs.snowflake.com/en/developer-guide/stored-procedure/stored-procedures-overview)** - Procedure overview

## Overview

This document covers user-defined functions (UDFs), user-defined table functions (UDTFs), and stored procedures in Snowflake across all supported languages. Understanding when to use each type and how to implement them is a key topic for the Advanced Data Engineer exam.

## UDF Types

### Scalar UDFs
- Accept one or more scalar values, return a single scalar value
- Called once per row in a query
- Supported languages: SQL, JavaScript, Python, Java, Scala
- Can be used in SELECT, WHERE, and other SQL expressions

**[📖 Scalar UDFs](https://docs.snowflake.com/en/developer-guide/udf/udf-overview)** - UDF documentation

### SQL UDFs
```sql
-- Simple SQL UDF
CREATE OR REPLACE FUNCTION calculate_tax(amount FLOAT, rate FLOAT)
  RETURNS FLOAT
  LANGUAGE SQL
AS
$$
  amount * rate
$$;

-- SQL UDF with conditional logic
CREATE OR REPLACE FUNCTION get_quarter(dt DATE)
  RETURNS VARCHAR
  LANGUAGE SQL
AS
$$
  CASE
    WHEN MONTH(dt) BETWEEN 1 AND 3 THEN 'Q1'
    WHEN MONTH(dt) BETWEEN 4 AND 6 THEN 'Q2'
    WHEN MONTH(dt) BETWEEN 7 AND 9 THEN 'Q3'
    ELSE 'Q4'
  END
$$;

-- SQL table UDF
CREATE OR REPLACE FUNCTION date_range(start_date DATE, end_date DATE)
  RETURNS TABLE (dt DATE)
  LANGUAGE SQL
AS
$$
  SELECT DATEADD('day', SEQ4(), start_date) AS dt
  FROM TABLE(GENERATOR(ROWCOUNT => DATEDIFF('day', start_date, end_date) + 1))
$$;
```

### JavaScript UDFs
```sql
CREATE OR REPLACE FUNCTION parse_user_agent(ua VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
AS
$$
  var result = {};
  if (UA.indexOf('Chrome') !== -1) result.browser = 'Chrome';
  else if (UA.indexOf('Firefox') !== -1) result.browser = 'Firefox';
  else if (UA.indexOf('Safari') !== -1) result.browser = 'Safari';
  else result.browser = 'Other';

  if (UA.indexOf('Windows') !== -1) result.os = 'Windows';
  else if (UA.indexOf('Mac') !== -1) result.os = 'macOS';
  else if (UA.indexOf('Linux') !== -1) result.os = 'Linux';
  else result.os = 'Other';

  return result;
$$;
```

**[📖 JavaScript UDFs](https://docs.snowflake.com/en/developer-guide/udf/javascript/udf-javascript-introduction)** - JavaScript UDF guide

### Python UDFs
```sql
-- Python UDF via SQL
CREATE OR REPLACE FUNCTION sentiment_score(text VARCHAR)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('textblob')
  HANDLER = 'analyze'
AS
$$
from textblob import TextBlob

def analyze(text):
    if text is None:
        return 0.0
    blob = TextBlob(text)
    return float(blob.sentiment.polarity)
$$;

-- Python UDF with multiple inputs
CREATE OR REPLACE FUNCTION haversine_distance(
  lat1 FLOAT, lon1 FLOAT, lat2 FLOAT, lon2 FLOAT
)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('numpy')
  HANDLER = 'calculate'
AS
$$
import numpy as np

def calculate(lat1, lon1, lat2, lon2):
    R = 6371  # Earth radius in km
    dlat = np.radians(lat2 - lat1)
    dlon = np.radians(lon2 - lon1)
    a = np.sin(dlat/2)**2 + np.cos(np.radians(lat1)) * np.cos(np.radians(lat2)) * np.sin(dlon/2)**2
    c = 2 * np.arctan2(np.sqrt(a), np.sqrt(1-a))
    return float(R * c)
$$;
```

**[📖 Python UDFs](https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-introduction)** - Python UDF guide

### Java UDFs
```sql
CREATE OR REPLACE FUNCTION validate_email(email VARCHAR)
  RETURNS BOOLEAN
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  HANDLER = 'EmailValidator.validate'
AS
$$
import java.util.regex.Pattern;

class EmailValidator {
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    public static boolean validate(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }
}
$$;
```

**[📖 Java UDFs](https://docs.snowflake.com/en/developer-guide/udf/java/udf-java-introduction)** - Java UDF guide

## Vectorized UDFs (Python)

### Concept
- Process batches of rows as pandas Series instead of one row at a time
- Significantly faster for large datasets (10x-100x improvement possible)
- Snowflake partitions input data and sends batches to the UDF
- Each batch is a pandas Series or DataFrame
- Only available in Python

### Implementation
```sql
-- Vectorized UDF via SQL
CREATE OR REPLACE FUNCTION zscore_normalize(val FLOAT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('pandas', 'numpy')
  HANDLER = 'normalize'
AS
$$
import pandas as pd
import numpy as np

# _sf_vectorized_input decorator marks as vectorized
class normalize:
    @staticmethod
    def end_partition(series: pd.Series) -> pd.Series:
        mean = series.mean()
        std = series.std()
        if std == 0:
            return pd.Series([0.0] * len(series))
        return (series - mean) / std
$$;
```

```python
# Vectorized UDF via Snowpark Python API
from snowflake.snowpark.functions import pandas_udf
from snowflake.snowpark.types import PandasSeriesType, FloatType

@pandas_udf(name="batch_normalize", return_type=PandasSeriesType(FloatType()),
            input_types=[PandasSeriesType(FloatType())], replace=True)
def batch_normalize(series: pd.Series) -> pd.Series:
    return (series - series.mean()) / series.std()
```

### When to Use Vectorized UDFs
| Scenario | Scalar UDF | Vectorized UDF |
|----------|-----------|---------------|
| Small table (< 1M rows) | Good | Minimal benefit |
| Large table (> 1M rows) | Slow | Significant speedup |
| Simple logic (string ops) | Good | Some benefit |
| Numerical computation | Adequate | Best choice |
| Stateful across rows | Not possible | Possible (end_partition) |

## User-Defined Table Functions (UDTFs)

### Overview
- Return multiple rows per input (table expansion)
- Process input partitions with state
- Lifecycle: __init__ (per partition), process (per row), end_partition (cleanup)
- Called with TABLE() or JOIN TABLE() in SQL

**[📖 UDTFs](https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-tabular-functions)** - UDTF documentation

### Python UDTF
```sql
CREATE OR REPLACE FUNCTION explode_json_array(json_arr VARIANT)
  RETURNS TABLE (index INTEGER, value VARIANT)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  HANDLER = 'JsonExploder'
AS
$$
import json

class JsonExploder:
    def process(self, json_arr):
        if json_arr is None:
            return
        arr = json.loads(str(json_arr)) if isinstance(json_arr, str) else json_arr
        for i, item in enumerate(arr):
            yield (i, item)
$$;

-- Usage
SELECT t.id, j.index, j.value
FROM my_table t,
     TABLE(explode_json_array(t.json_column)) j;
```

### UDTF with Partitioning
```sql
CREATE OR REPLACE FUNCTION running_stats(val FLOAT)
  RETURNS TABLE (running_mean FLOAT, running_std FLOAT, running_count INTEGER)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('numpy')
  HANDLER = 'RunningStats'
AS
$$
import numpy as np

class RunningStats:
    def __init__(self):
        self.values = []

    def process(self, val):
        self.values.append(val)
        arr = np.array(self.values)
        yield (float(np.mean(arr)), float(np.std(arr)), len(self.values))

    def end_partition(self):
        pass  # No final output needed
$$;

-- Use with PARTITION BY
SELECT s.*
FROM my_table t,
     TABLE(running_stats(t.metric) OVER (PARTITION BY t.category ORDER BY t.ts)) s;
```

## Stored Procedures

### SQL Stored Procedures
```sql
CREATE OR REPLACE PROCEDURE swap_tables(table_a VARCHAR, table_b VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
AS
$$
BEGIN
  ALTER TABLE IDENTIFIER(:table_a) RENAME TO temp_swap_table;
  ALTER TABLE IDENTIFIER(:table_b) RENAME TO IDENTIFIER(:table_a);
  ALTER TABLE temp_swap_table RENAME TO IDENTIFIER(:table_b);
  RETURN 'Tables swapped successfully';
END;
$$;
```

### Python Stored Procedures
```sql
CREATE OR REPLACE PROCEDURE rebuild_aggregates(start_date DATE, end_date DATE)
  RETURNS VARCHAR
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
  EXECUTE AS CALLER
AS
$$
from snowflake.snowpark.functions import col, sum, count, avg

def run(session, start_date, end_date):
    # Read source
    orders = session.table("orders").filter(
        (col("order_date") >= start_date) & (col("order_date") <= end_date)
    )

    # Build aggregates
    daily = orders.group_by("order_date", "region").agg(
        count("*").alias("order_count"),
        sum("amount").alias("revenue"),
        avg("amount").alias("avg_order")
    )

    # Write results
    daily.write.mode("overwrite").save_as_table("daily_aggregates")
    return f"Rebuilt aggregates: {daily.count()} rows"
$$;
```

### Caller's Rights vs Owner's Rights
| Property | EXECUTE AS CALLER | EXECUTE AS OWNER |
|----------|------------------|-----------------|
| Permission context | Caller's role | Procedure owner's role |
| Object access | Caller must have grants | Uses owner's grants |
| Default | Yes | Must specify |
| Use case | User-context operations | Privileged admin tasks |
| Security | Less privileged | Elevated privileges |

```sql
-- Owner's rights - procedure can access objects the caller cannot
CREATE OR REPLACE PROCEDURE grant_access(role_name VARCHAR, db_name VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
  EXECUTE AS OWNER  -- Runs with owner's (admin) permissions
AS
$$
BEGIN
  EXECUTE IMMEDIATE 'GRANT USAGE ON DATABASE ' || :db_name || ' TO ROLE ' || :role_name;
  RETURN 'Access granted';
END;
$$;
```

**[📖 Caller vs Owner Rights](https://docs.snowflake.com/en/developer-guide/stored-procedure/stored-procedures-rights)** - Execution context

## Secure Functions

### Secure UDFs
```sql
-- Secure UDF hides implementation from non-owners
CREATE OR REPLACE SECURE FUNCTION proprietary_score(data VARIANT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  HANDLER = 'score'
AS
$$
def score(data):
    # Proprietary algorithm hidden from consumers
    weights = {"factor_a": 0.4, "factor_b": 0.35, "factor_c": 0.25}
    total = sum(data.get(k, 0) * v for k, v in weights.items())
    return total
$$;
```

- Secure functions hide the definition from non-owners
- Important for data sharing - consumers cannot see the logic
- Secure views and secure functions work together for sharing
- DESCRIBE FUNCTION returns limited info for secure functions

## Performance Considerations

### UDF Performance Hierarchy
1. **SQL UDFs** - fastest, inlined by optimizer
2. **Vectorized Python UDFs** - fast for batch processing
3. **Java/Scala UDFs** - JVM performance, good for complex logic
4. **Scalar Python UDFs** - slowest per-row, use for small datasets
5. **JavaScript UDFs** - adequate, but Python preferred for new development

### Optimization Tips
- Use SQL UDFs when possible (optimizer can inline them)
- Use vectorized UDFs for large-scale Python processing
- Minimize package imports in UDFs (cold start overhead)
- Avoid heavy initialization in __init__ for UDTFs
- Cache external resources in class variables for UDTFs
- Test UDF performance at production data volumes

## Key Decision Framework

### When to Use Each Type
| Need | Solution |
|------|----------|
| Simple calculation | SQL UDF |
| Row-level transformation | Scalar UDF (Python/Java) |
| Batch numerical processing | Vectorized Python UDF |
| Row expansion (1 to many) | UDTF |
| Multi-step pipeline logic | Stored procedure |
| Privileged operations | Owner's rights stored procedure |
| Shared logic protection | Secure UDF |
| External API call | External function (not UDF) |
