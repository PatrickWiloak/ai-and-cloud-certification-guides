# NVIDIA Accelerated Data Science Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-ADS
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| RAPIDS Framework Overview | 15% | Ecosystem, components, setup |
| cuDF - GPU DataFrames | 25% | DataFrame ops, pandas compat, memory |
| cuML - GPU Machine Learning | 25% | Algorithms, training, evaluation |
| cuGraph - GPU Graph Analytics | 15% | Graph algorithms, construction |
| GPU ETL and Spark Integration | 20% | ETL pipelines, Spark, Dask-cuDF |

## Domain 1: RAPIDS Framework

### RAPIDS Ecosystem

| Component | Purpose | CPU Equivalent |
|-----------|---------|---------------|
| cuDF | GPU DataFrames | pandas |
| cuML | GPU Machine Learning | scikit-learn |
| cuGraph | GPU Graph Analytics | NetworkX |
| cuSpatial | GPU Spatial Analytics | GeoPandas |
| Dask-cuDF | Multi-GPU DataFrames | Dask DataFrame |
| cuCIM | GPU Image Processing | scikit-image |

**Key Benefits:**
- 10-100x speedup over CPU equivalents
- pandas-like API - minimal code changes
- Interoperable with existing Python ecosystem
- Open-source (Apache 2.0 license)
- **[📖 RAPIDS Documentation](https://docs.rapids.ai/)**

### Installation
```bash
# Conda installation
conda install -c rapidsai -c conda-forge -c nvidia \
  rapids=24.02 python=3.10 cuda-version=12.0

# Docker container
docker run --gpus all nvcr.io/nvidia/rapidsai/base:24.02-cuda12.0-py3.10
```

## Domain 2: cuDF - GPU DataFrames

### Core Operations

**Data Loading:**
```python
import cudf

# Read CSV (GPU-accelerated)
df = cudf.read_csv('data.csv')

# Read Parquet (GPU-accelerated)
df = cudf.read_parquet('data.parquet')

# From pandas DataFrame
df = cudf.from_pandas(pandas_df)

# To pandas
pandas_df = df.to_pandas()
```

**DataFrame Operations:**
```python
# Filtering
filtered = df[df['age'] > 30]

# Groupby aggregation
result = df.groupby('category').agg({'value': ['mean', 'sum', 'count']})

# Joins
merged = df1.merge(df2, on='key', how='inner')

# Sorting
sorted_df = df.sort_values('column', ascending=False)

# String operations
df['name_upper'] = df['name'].str.upper()
```

### pandas Compatibility
- Most pandas operations have direct cuDF equivalents
- `.to_pandas()` and `cudf.from_pandas()` for conversion
- Some operations fall back to CPU if not GPU-implemented
- Custom apply functions may need cuDF UDFs or Numba kernels

### Memory Management
- GPU memory is limited compared to system memory
- Use `rmm` (RAPIDS Memory Manager) for allocation control
- Spilling to host memory when GPU memory is full
- Chunked processing for datasets larger than GPU memory
- Monitor with `nvidia-smi` or `rmm` utilities

**[📖 cuDF Documentation](https://docs.rapids.ai/api/cudf/stable/)** - API reference

## Domain 3: cuML - GPU Machine Learning

### Supported Algorithms

**Classification:**
- Logistic Regression
- Random Forest
- K-Nearest Neighbors (KNN)
- Support Vector Machine (SVM)
- Naive Bayes

**Regression:**
- Linear Regression, Ridge, Lasso
- Random Forest Regressor
- KNN Regressor
- ElasticNet

**Clustering:**
- K-Means
- DBSCAN
- HDBSCAN
- Agglomerative Clustering

**Dimensionality Reduction:**
- PCA (Principal Component Analysis)
- UMAP
- t-SNE
- Truncated SVD

**Time Series:**
- ARIMA
- Exponential Smoothing
- Holt-Winters

### Usage Pattern
```python
from cuml.ensemble import RandomForestClassifier
from cuml.model_selection import train_test_split

# Split data (GPU)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train (GPU-accelerated)
model = RandomForestClassifier(n_estimators=100, max_depth=16)
model.fit(X_train, y_train)

# Predict (GPU)
predictions = model.predict(X_test)

# Evaluate
from cuml.metrics import accuracy_score
accuracy = accuracy_score(y_test, predictions)
```

### scikit-learn Compatibility
- Similar API to scikit-learn
- Drop-in replacement for many algorithms
- Input: cuDF DataFrame or cuPy array
- Also accepts pandas/numpy (auto-converts)

**[📖 cuML Documentation](https://docs.rapids.ai/api/cuml/stable/)** - Algorithm reference

## Domain 4: cuGraph - GPU Graph Analytics

### Graph Construction
```python
import cugraph
import cudf

# From edge list
edges = cudf.DataFrame({
    'src': [0, 1, 2, 3],
    'dst': [1, 2, 3, 0],
    'weight': [1.0, 2.0, 3.0, 4.0]
})
G = cugraph.Graph()
G.from_cudf_edgelist(edges, source='src', destination='dst', edge_attr='weight')
```

### Key Algorithms

| Algorithm | Category | Use Case |
|-----------|----------|----------|
| PageRank | Centrality | Node importance ranking |
| BFS | Traversal | Shortest path (unweighted) |
| SSSP | Traversal | Shortest path (weighted) |
| Louvain | Community | Community detection |
| Triangle Count | Structure | Network density |
| Jaccard | Similarity | Node similarity |
| Connected Components | Structure | Graph connectivity |

**[📖 cuGraph Documentation](https://docs.rapids.ai/api/cugraph/stable/)** - Graph algorithms

## Domain 5: GPU ETL and Spark

### Dask-cuDF

**Multi-GPU Processing:**
```python
import dask_cudf

# Read large dataset across multiple GPUs
ddf = dask_cudf.read_parquet('large_data/*.parquet')

# Operations distribute across GPUs
result = ddf.groupby('key').agg({'value': 'mean'}).compute()
```

**Scaling Patterns:**
- Single GPU: cuDF for datasets that fit in GPU memory
- Multi-GPU (single node): Dask-cuDF with LocalCUDACluster
- Multi-node: Dask-cuDF with distributed scheduler

### RAPIDS Accelerator for Apache Spark

**Purpose:** Run Spark SQL and DataFrame operations on GPUs

**Key Features:**
- Transparent GPU acceleration of Spark queries
- No code changes required (plugin-based)
- GPU-accelerated joins, aggregations, sorts
- GPU-accelerated data format readers (Parquet, ORC, CSV)

**Configuration:**
```
spark.plugins=com.nvidia.spark.SQLPlugin
spark.rapids.sql.enabled=true
spark.rapids.memory.pinnedPool.size=2G
```

**[📖 Spark RAPIDS Documentation](https://docs.nvidia.com/spark-rapids/)** - Configuration guide

### Performance Tuning
- Maximize GPU memory utilization
- Use columnar data formats (Parquet, ORC) for best speedup
- Partition data to match GPU count
- Monitor GPU utilization during pipeline execution
- Profile with Nsight Systems for bottleneck identification

## Exam Tips

### Key Concepts to Master
1. RAPIDS component mapping to CPU equivalents
2. cuDF API for common DataFrame operations
3. cuML algorithm selection and API usage
4. cuGraph construction and algorithm execution
5. Dask-cuDF for multi-GPU scaling
6. Spark RAPIDS configuration and benefits
