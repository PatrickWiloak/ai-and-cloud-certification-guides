# Scaling ML - Databricks ML Associate

## Overview

This section covers scaling ML workloads on Databricks, representing 12% of the exam. You need to understand pandas UDFs, pandas API on Spark, batch and streaming inference, and patterns for scaling single-node models.

**[📖 Pandas UDFs](https://docs.databricks.com/en/udf/pandas.html)** - Distributed pandas functions
**[📖 Batch Inference](https://docs.databricks.com/en/machine-learning/model-inference/index.html)** - Scalable inference

## Key Topics

### 1. Pandas API on Spark

**[📖 Pandas API on Spark](https://docs.databricks.com/en/pandas/pandas-on-spark.html)** - Scalable pandas

```python
import pyspark.pandas as ps

# Create a pandas-on-Spark DataFrame
pdf = ps.read_csv("/path/to/data.csv")

# Use familiar pandas syntax
pdf.describe()
pdf.groupby("category").mean()
pdf["new_col"] = pdf["col1"] * pdf["col2"]

# Convert to/from Spark DataFrame
spark_df = pdf.to_spark()
pandas_on_spark_df = spark_df.pandas_api()
```

**Key Concepts:**
- Provides pandas-like syntax with Spark distributed execution
- Scales to large datasets that do not fit in memory on a single node
- Not all pandas operations are supported (check compatibility docs)
- Good for data scientists familiar with pandas who need to scale
- Performance may differ from native Spark operations

### 2. Pandas UDFs

Pandas UDFs apply pandas functions distributed across Spark partitions, enabling efficient use of single-node libraries at scale.

**[📖 Pandas UDFs](https://docs.databricks.com/en/udf/pandas.html)** - UDF reference

**Types of Pandas UDFs:**
```python
from pyspark.sql.functions import pandas_udf
import pandas as pd

# Series to Series (scalar)
@pandas_udf("double")
def multiply(a: pd.Series, b: pd.Series) -> pd.Series:
    return a * b

df = df.withColumn("product", multiply(col("x"), col("y")))

# Series to Scalar (aggregate)
@pandas_udf("double")
def weighted_mean(values: pd.Series, weights: pd.Series) -> float:
    return (values * weights).sum() / weights.sum()

# Iterator of Series (for expensive initialization like loading a model)
@pandas_udf("double")
def predict(iterator: Iterator[pd.Series]) -> Iterator[pd.Series]:
    model = load_model()  # Load once, apply to many batches
    for batch in iterator:
        yield pd.Series(model.predict(batch))
```

**Key Concepts:**
- Pandas UDFs are much faster than regular Python UDFs (vectorized execution)
- Data is transferred between JVM and Python using Apache Arrow (efficient)
- Series-to-Series: transforms individual columns
- Iterator pattern: loads expensive resources once, processes many batches
- Ideal for applying single-node model predictions at scale

### 3. Batch Inference with MLflow

**[📖 Batch Inference](https://docs.databricks.com/en/machine-learning/model-inference/index.html)** - Inference patterns

```python
import mlflow

# Create Spark UDF from MLflow model
predict_udf = mlflow.pyfunc.spark_udf(spark, model_uri="models:/my_model/1")

# Apply to large dataset
predictions = df.withColumn("prediction",
    predict_udf(struct("feature1", "feature2", "feature3")))
```

**Key Concepts:**
- `mlflow.pyfunc.spark_udf()` creates a Spark UDF from any MLflow model
- The model is broadcast to all workers for efficient distributed inference
- Input features are passed as a struct of column names
- Works with any model flavor: sklearn, TensorFlow, PyTorch, XGBoost, custom pyfunc
- Ideal for scoring large datasets in parallel

### 4. Streaming Inference

```python
# Apply model to streaming data
stream_df = spark.readStream.table("events")

predict_udf = mlflow.pyfunc.spark_udf(spark, model_uri="models:/my_model/1")
scored = stream_df.withColumn("prediction",
    predict_udf(struct("feature1", "feature2")))

scored.writeStream.table("predictions").start()
```

**Key Concepts:**
- Same `spark_udf` pattern works for both batch and streaming
- Model is applied to each micro-batch automatically
- Low-latency scoring without a separate serving endpoint
- Useful for real-time feature scoring and anomaly detection

### 5. Real-Time Inference (Model Serving)

**[📖 Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving endpoints

**Key Concepts:**
- Model Serving provides REST API endpoints for real-time predictions
- Serverless Model Serving manages infrastructure automatically
- Endpoints auto-scale based on traffic
- Suitable for applications requiring sub-second latency
- Use for interactive applications, APIs, and web services

### 6. Choosing the Right Inference Pattern

| Pattern | Latency | Throughput | Use Case |
|---------|---------|------------|----------|
| Batch inference | Minutes to hours | Very high | Scoring large datasets offline |
| Streaming inference | Seconds to minutes | High | Near-real-time scoring |
| Real-time serving | Milliseconds | Per-request | Interactive applications |

### 7. Scaling Strategies Summary

| Single-Node Library | Scaling Approach |
|--------------------|-----------------|
| scikit-learn | pandas UDFs or mlflow.pyfunc.spark_udf |
| XGBoost | pandas UDFs or Spark MLlib wrapper |
| TensorFlow/PyTorch | TorchDistributor or Horovod |
| Custom models | Custom pyfunc with pandas UDF pattern |
| Hyperparameter tuning | Hyperopt with SparkTrials |

## Exam Tips for This Domain

1. **pandas UDFs** - Know the decorator pattern and when to use iterator variant
2. **mlflow.pyfunc.spark_udf** - Key pattern for batch inference at scale
3. **Pandas API on Spark** - Pandas syntax with Spark execution
4. **Inference patterns** - Know batch vs streaming vs real-time tradeoffs
5. **SparkTrials** - Distribute hyperparameter tuning across the cluster
6. **Arrow optimization** - Pandas UDFs use Apache Arrow for fast data transfer

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Pandas UDFs | [docs.databricks.com/en/udf/pandas.html](https://docs.databricks.com/en/udf/pandas.html) |
| Pandas API on Spark | [docs.databricks.com/en/pandas/pandas-on-spark.html](https://docs.databricks.com/en/pandas/pandas-on-spark.html) |
| Batch Inference | [docs.databricks.com/en/machine-learning/model-inference/index.html](https://docs.databricks.com/en/machine-learning/model-inference/index.html) |
| Model Serving | [docs.databricks.com/en/machine-learning/model-serving/index.html](https://docs.databricks.com/en/machine-learning/model-serving/index.html) |
