# cuDF and cuML

**[📖 cuDF Documentation](https://docs.rapids.ai/api/cudf/stable/)** - GPU DataFrame API
**[📖 cuML Documentation](https://docs.rapids.ai/api/cuml/stable/)** - GPU ML algorithms

## cuDF - GPU DataFrames

### Data Loading

```python
import cudf

# CSV (GPU-accelerated parsing)
df = cudf.read_csv('data.csv', usecols=['col1', 'col2'], dtype={'col1': 'int32'})

# Parquet (GPU-accelerated, columnar format - fastest)
df = cudf.read_parquet('data.parquet', columns=['col1', 'col2'])

# JSON
df = cudf.read_json('data.json', lines=True)

# ORC
df = cudf.read_orc('data.orc')
```

**Performance Tips:**
- Parquet is the fastest format (columnar, compressed)
- Specify dtypes to avoid type inference overhead
- Select only needed columns to reduce memory
- Use `nrows` parameter for sampling large files

### DataFrame Operations

**Selection and Filtering:**
```python
# Column selection
subset = df[['col1', 'col2']]

# Boolean filtering
filtered = df[df['value'] > 100]

# Multiple conditions
result = df[(df['age'] > 25) & (df['city'] == 'NYC')]

# Query syntax
result = df.query('age > 25 and city == "NYC"')
```

**Transformations:**
```python
# Apply function (limited to simple operations on GPU)
df['new_col'] = df['value'] * 2 + 1

# String operations
df['upper'] = df['name'].str.upper()
df['contains'] = df['text'].str.contains('pattern')
df['length'] = df['text'].str.len()

# Date operations
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month

# Type casting
df['col'] = df['col'].astype('float32')
```

**Aggregation:**
```python
# GroupBy
result = df.groupby('category').agg({
    'value': ['mean', 'sum', 'count', 'std'],
    'quantity': 'sum'
})

# Rolling windows
df['rolling_mean'] = df['value'].rolling(window=7).mean()

# Value counts
counts = df['category'].value_counts()
```

**Joins:**
```python
# Inner join
merged = df1.merge(df2, on='key', how='inner')

# Left join with multiple keys
merged = df1.merge(df2, on=['key1', 'key2'], how='left')

# Concat
combined = cudf.concat([df1, df2], axis=0)
```

### pandas Differences
- Not all pandas functions are available in cuDF
- Custom `.apply()` requires Numba-compiled functions
- Some operations may have slightly different behavior for edge cases
- GroupBy with custom aggregation functions is more limited
- Use `.to_pandas()` for unsupported operations, then convert back

### Memory Optimization
- Use smallest appropriate dtype (int32 vs int64, float32 vs float64)
- Drop unused columns early in pipeline
- Process in chunks for large datasets
- Monitor GPU memory: `cudf.utils.utils.get_gpu_memory_info()`
- Delete intermediate DataFrames: `del temp_df`

## cuML - GPU Machine Learning

### Classification

```python
from cuml.ensemble import RandomForestClassifier
from cuml.linear_model import LogisticRegression
from cuml.neighbors import KNeighborsClassifier
from cuml.svm import SVC

# Random Forest
rf = RandomForestClassifier(n_estimators=100, max_depth=16, n_streams=4)
rf.fit(X_train, y_train)
pred = rf.predict(X_test)

# Logistic Regression
lr = LogisticRegression(max_iter=1000)
lr.fit(X_train, y_train)

# KNN
knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)
```

### Regression

```python
from cuml.linear_model import LinearRegression, Ridge, Lasso, ElasticNet

# Linear Regression
lr = LinearRegression()
lr.fit(X_train, y_train)

# Ridge (L2 regularization)
ridge = Ridge(alpha=1.0)

# Lasso (L1 regularization)
lasso = Lasso(alpha=0.1)

# ElasticNet (L1 + L2)
enet = ElasticNet(alpha=0.1, l1_ratio=0.5)
```

### Clustering

```python
from cuml.cluster import KMeans, DBSCAN, HDBSCAN

# K-Means
kmeans = KMeans(n_clusters=5, max_iter=300)
labels = kmeans.fit_predict(X)

# DBSCAN
dbscan = DBSCAN(eps=0.5, min_samples=5)
labels = dbscan.fit_predict(X)

# HDBSCAN
hdbscan = HDBSCAN(min_cluster_size=25)
labels = hdbscan.fit_predict(X)
```

### Dimensionality Reduction

```python
from cuml.decomposition import PCA, TruncatedSVD
from cuml.manifold import UMAP, TSNE

# PCA
pca = PCA(n_components=50)
X_reduced = pca.fit_transform(X)
explained = pca.explained_variance_ratio_

# UMAP (very fast on GPU)
umap = UMAP(n_components=2, n_neighbors=15)
X_embedded = umap.fit_transform(X)

# t-SNE
tsne = TSNE(n_components=2, perplexity=30)
X_embedded = tsne.fit_transform(X)
```

### Model Evaluation

```python
from cuml.metrics import accuracy_score, log_loss
from cuml.model_selection import train_test_split

# Train/test split (GPU)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Metrics
acc = accuracy_score(y_test, predictions)

# Cross-validation (via cuML or sklearn wrapper)
from cuml.model_selection import GridSearchCV
gs = GridSearchCV(estimator, param_grid, cv=5)
gs.fit(X, y)
```

### Hyperparameter Tuning
- cuML supports GridSearchCV and RandomizedSearchCV
- GPU-accelerated search is much faster than CPU
- Can also integrate with Optuna or Ray Tune
- Leverage Dask for distributed hyperparameter search

## Key Exam Concepts

- cuDF data loading: CSV, Parquet (fastest), JSON, ORC
- DataFrame operations: filter, groupby, merge, string ops
- pandas API differences and limitations in cuDF
- cuML algorithm categories and usage patterns
- Model evaluation metrics on GPU
- Memory management best practices
