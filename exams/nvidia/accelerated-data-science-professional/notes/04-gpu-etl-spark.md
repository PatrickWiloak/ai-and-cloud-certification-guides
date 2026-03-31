# GPU ETL and Spark Integration

**[📖 Spark RAPIDS Documentation](https://docs.nvidia.com/spark-rapids/)** - RAPIDS Accelerator for Apache Spark

## GPU-Accelerated ETL Pipelines

### ETL with cuDF

**Extract:**
```python
import cudf

# Read from multiple sources
csv_data = cudf.read_csv('raw_data.csv')
parquet_data = cudf.read_parquet('warehouse/*.parquet')
json_data = cudf.read_json('events.json', lines=True)
```

**Transform:**
```python
# Clean data
df = df.dropna(subset=['key_column'])
df = df.drop_duplicates(subset=['id'])

# Type conversions
df['date'] = cudf.to_datetime(df['date_string'])
df['amount'] = df['amount'].astype('float32')

# Feature engineering
df['revenue_per_unit'] = df['revenue'] / df['units']
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month

# String cleaning
df['name'] = df['name'].str.strip().str.lower()

# Joins and enrichment
enriched = df.merge(lookup_table, on='category_id', how='left')

# Aggregation
summary = enriched.groupby(['year', 'month', 'category']).agg({
    'revenue': 'sum',
    'units': 'sum',
    'customer_id': 'nunique'
})
```

**Load:**
```python
# Write to Parquet (most efficient)
df.to_parquet('output/processed_data.parquet')

# Write to CSV
df.to_csv('output/report.csv', index=False)
```

### Performance Best Practices

**Data Formats:**
- Use Parquet or ORC for columnar storage (fastest I/O)
- Avoid CSV for large datasets (slow parsing)
- Compress with snappy or zstd for Parquet
- Partition data by common filter columns

**Memory Management:**
- Process in chunks if data exceeds GPU memory
- Delete intermediate DataFrames to free memory
- Use float32 instead of float64 where precision allows
- Select only needed columns at load time

**Pipeline Design:**
- Filter early to reduce data volume
- Push projections (column selection) to read operations
- Minimize data transfers between CPU and GPU
- Chain operations to reduce materialization

## Dask-cuDF for Multi-GPU Processing

### Setup

```python
from dask_cuda import LocalCUDACluster
from dask.distributed import Client
import dask_cudf

# Create multi-GPU cluster (single node)
cluster = LocalCUDACluster()
client = Client(cluster)
print(f"Dashboard: {client.dashboard_link}")
```

### Operations

```python
# Read distributed dataset
ddf = dask_cudf.read_parquet('data/*.parquet')

# Lazy operations (not computed until .compute())
filtered = ddf[ddf['value'] > 0]
grouped = filtered.groupby('category').agg({'value': 'mean'})

# Trigger computation
result = grouped.compute()  # Returns cuDF DataFrame
```

### Scaling Patterns

**Single GPU (cuDF):**
- Datasets that fit in GPU memory
- Simplest API, best performance per-GPU
- Typical: datasets up to 16-80GB depending on GPU

**Multi-GPU Single Node (Dask-cuDF):**
- Datasets that exceed single GPU memory
- LocalCUDACluster distributes across GPUs in one node
- Typical: 100GB-1TB with 8 GPUs

**Multi-Node (Dask-cuDF + Dask Distributed):**
- Datasets that exceed single node capacity
- Dask distributed scheduler across multiple machines
- Typical: 1TB+ across multiple GPU nodes

### Dask-cuDF Best Practices
- Partition data into evenly sized chunks
- Repartition if partitions become unbalanced after filtering
- Use persist() for frequently accessed intermediate results
- Monitor Dask dashboard for task distribution and memory usage

## RAPIDS Accelerator for Apache Spark

### Overview
- Spark SQL and DataFrame plugin for GPU acceleration
- No code changes required - drop-in GPU acceleration
- Supports common Spark operations on GPU
- Falls back to CPU for unsupported operations

### Configuration

```python
# SparkSession with GPU acceleration
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("GPU-Accelerated") \
    .config("spark.plugins", "com.nvidia.spark.SQLPlugin") \
    .config("spark.rapids.sql.enabled", "true") \
    .config("spark.rapids.memory.pinnedPool.size", "2G") \
    .config("spark.rapids.sql.concurrentGpuTasks", "2") \
    .config("spark.executor.resource.gpu.amount", "1") \
    .config("spark.task.resource.gpu.amount", "0.5") \
    .getOrCreate()
```

### Supported Operations
- **Data Sources:** Parquet, ORC, CSV, JSON readers
- **SQL Operations:** SELECT, WHERE, GROUP BY, JOIN, ORDER BY
- **Aggregations:** COUNT, SUM, AVG, MIN, MAX
- **Window Functions:** ROW_NUMBER, RANK, LAG, LEAD
- **String Functions:** Most common string operations
- **Date/Time Functions:** Date arithmetic and extraction

### Operations NOT on GPU (CPU Fallback)
- User-defined functions (UDFs) unless specifically written for GPU
- Some complex nested data types
- Certain aggregate functions with custom logic
- Operations requiring precise decimal arithmetic

### Performance Tuning

**Key Configuration:**
```
# Memory
spark.rapids.memory.pinnedPool.size=2G
spark.rapids.sql.concurrentGpuTasks=2

# Batch sizing
spark.rapids.sql.batchSizeBytes=2147483647

# Enable specific operations
spark.rapids.sql.hasNans=false  # If data has no NaNs
```

**Best Practices:**
- Use Parquet format for best GPU acceleration
- Ensure data partitions are large enough for GPU efficiency
- Monitor GPU utilization during Spark jobs
- Check Spark UI for GPU vs CPU execution breakdown
- Adjust `concurrentGpuTasks` based on GPU memory

**[📖 RAPIDS Accelerator Config](https://docs.nvidia.com/spark-rapids/)** - Tuning guide

### Qualification Tool
- Analyzes Spark event logs to estimate GPU speedup
- Identifies operations that would benefit from GPU
- Recommends configuration changes
- Useful for evaluating migration effort

```bash
# Run qualification tool
$SPARK_HOME/bin/spark-submit \
  --class com.nvidia.spark.rapids.tool.qualification.QualificationMain \
  rapids-4-spark-tools.jar \
  /path/to/spark/event/logs
```

## Key Exam Concepts

- cuDF ETL pipeline patterns (extract, transform, load)
- Performance best practices for GPU ETL
- Dask-cuDF scaling: single GPU, multi-GPU, multi-node
- RAPIDS Accelerator for Spark configuration
- Supported vs unsupported Spark operations on GPU
- Performance tuning for Spark with GPU
