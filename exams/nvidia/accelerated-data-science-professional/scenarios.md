# NCP-ADS High-Yield Scenarios and Practice Problems

## Scenario 1: Choosing the Right RAPIDS Component

**Scenario**: A data scientist needs to process a 50GB CSV dataset, train a random forest classifier, and analyze user relationships as a graph. The workflow must be entirely GPU-accelerated. Which RAPIDS components should be used?

**Solution Pattern**:
- **cuDF** for loading and preprocessing the 50GB CSV
- **cuML RandomForestClassifier** for training the classifier
- **cuGraph** for analyzing user relationship graph
- Pipeline: cuDF read_csv -> cuDF transformations -> cuML for ML -> cuGraph for graph analysis

**Common Distractors**:
- pandas + scikit-learn + NetworkX - CPU-only, much slower
- cuDF only - does not cover ML or graph analytics
- Spark only - unnecessary complexity for single-node workload that fits in GPU memory
- cuPy for all operations - cuPy is for array operations, not DataFrames or ML

**Key Takeaway**: Map each task to the appropriate RAPIDS component: cuDF for data, cuML for ML, cuGraph for graphs.

---

## Scenario 2: Dataset Too Large for GPU Memory

**Scenario**: A 200GB Parquet dataset needs to be processed on a server with 4x A100 80GB GPUs (320GB total GPU memory). The pipeline involves filtering, groupby aggregation, and writing results. What approach should be used?

**Solution Pattern**:
- **Use Dask-cuDF** with LocalCUDACluster (4 GPUs)
- Read data as Dask-cuDF partitioned DataFrame
- Dask distributes partitions across 4 GPUs
- Operations execute in parallel across GPUs
- 200GB fits across 4x 80GB GPUs with room for intermediate results

**Common Distractors**:
- Single cuDF on one GPU - 200GB exceeds 80GB GPU memory
- pandas on CPU - much slower, defeats purpose of GPU infrastructure
- Spark RAPIDS - viable but Dask-cuDF is simpler for this single-node case
- Process 50GB chunks sequentially on one GPU - slower than parallel multi-GPU

**Key Takeaway**: When data exceeds single GPU memory, use Dask-cuDF to distribute across multiple GPUs. LocalCUDACluster for single node.

---

## Scenario 3: Spark Migration to GPU

**Scenario**: An existing Spark ETL pipeline processes 5TB of Parquet data daily. It runs on a 20-node CPU cluster with 3-hour runtime. The company wants to evaluate GPU acceleration. How should they approach this?

**Solution Pattern**:
1. Run RAPIDS Qualification Tool on Spark event logs to estimate speedup
2. Add RAPIDS Accelerator plugin to existing Spark configuration
3. No code changes - plugin transparently accelerates supported operations
4. Start with GPU-enabled executor nodes (e.g., 4 nodes with A100 GPUs)
5. Monitor GPU utilization and compare runtime to CPU baseline
6. Tune `concurrentGpuTasks` and `batchSizeBytes` for optimal performance

**Common Distractors**:
- Rewrite entire pipeline in cuDF - unnecessary, Spark RAPIDS is drop-in
- Only use GPU for training, not ETL - ETL is the 3-hour bottleneck
- Replace Spark with Dask-cuDF immediately - risky for 5TB production pipeline
- Add GPUs without the RAPIDS plugin - Spark cannot use GPUs without the plugin

**Key Takeaway**: RAPIDS Accelerator for Spark is a drop-in plugin - no code changes needed. Use the Qualification Tool first to estimate benefits.

---

## Scenario 4: cuML Algorithm Selection

**Scenario**: A dataset has 10 million rows and 500 features. The task is to identify natural groupings in the data without labels. The data scientist does not know the number of clusters in advance. Which cuML algorithm is best?

**Solution Pattern**:
- **Best Choice**: HDBSCAN
- Does not require specifying number of clusters
- Handles clusters of varying density and shape
- Scales well on GPU for 10M rows
- Returns noise label for outliers

**Common Distractors**:
- K-Means - requires specifying K (number of clusters) in advance
- DBSCAN - requires careful epsilon tuning, less flexible than HDBSCAN
- PCA - dimensionality reduction, not clustering
- Random Forest - supervised classifier, requires labels

**Key Takeaway**: HDBSCAN is the best choice for clustering when number of clusters is unknown. K-Means requires K, DBSCAN requires precise epsilon.

---

## Scenario 5: Graph Analytics for Fraud Detection

**Scenario**: A financial company has a transaction network with 50 million edges. They want to identify suspicious communities and rank important nodes. How should cuGraph be used?

**Solution Pattern**:
1. Load edge list with cuDF: `cudf.read_parquet('transactions.parquet')`
2. Build graph: `G.from_cudf_edgelist(edges, source='sender', destination='receiver', edge_attr='amount')`
3. Run **Louvain** community detection to identify clusters
4. Run **PageRank** to find important nodes within suspicious communities
5. Join results back to node data with cuDF for analysis

**Common Distractors**:
- NetworkX - cannot handle 50M edges efficiently (too slow)
- Only PageRank without community detection - misses cluster structure
- cuML clustering on edge features - does not capture graph topology
- SQL aggregations only - misses graph-based relationships

**Key Takeaway**: Combine community detection (Louvain) with centrality (PageRank) for comprehensive graph analysis. cuGraph handles 50M+ edges efficiently.

---

## Scenario 6: Memory Management

**Scenario**: A cuDF pipeline processing a 60GB dataset on an 80GB A100 GPU runs out of memory during a groupby aggregation that creates large intermediate results. How should this be addressed?

**Solution Pattern**:
- **Immediate fixes**:
  - Delete unused DataFrames before the aggregation: `del temp_df`
  - Select only needed columns before groupby
  - Use smaller dtypes (float32 instead of float64)
  - Filter rows before aggregation to reduce data volume
- **If still insufficient**:
  - Configure RMM with managed memory: `rmm.reinitialize(managed_memory=True)`
  - Managed memory allows spilling to host memory automatically
  - Split processing into chunks
- **Long-term**: Use Dask-cuDF to distribute across multiple GPUs

**Common Distractors**:
- Add more system RAM - does not help GPU memory
- Use pandas for this step - loses GPU acceleration
- Increase GPU clock speed - does not affect memory capacity
- Compress the data in GPU memory - not supported for active DataFrames

**Key Takeaway**: GPU memory management requires active cleanup of intermediates, efficient dtypes, and RMM managed memory as a safety net.

---

## Scenario 7: Parquet vs CSV Performance

**Scenario**: A data pipeline reads the same 10GB dataset daily. Currently using CSV format with cuDF, read time is 45 seconds. How can loading performance be improved?

**Solution Pattern**:
- **Convert to Parquet format**: `df.to_parquet('data.parquet')`
- Parquet benefits:
  - Columnar storage - only reads needed columns
  - Built-in compression - smaller file size
  - Metadata - avoids type inference
  - GPU-optimized reader in cuDF
- Expected improvement: 5-10x faster loading (4-9 seconds)
- Additional: specify `columns` parameter to read only needed columns

**Common Distractors**:
- Use faster NVMe storage - helps but Parquet is a bigger win
- Increase CPU cores for CSV parsing - GPU parses CSV, not CPU
- Split CSV into multiple files - helps parallelism but Parquet is still better
- Compress CSV with gzip - slower to decompress, Parquet compression is better

**Key Takeaway**: Always use Parquet (or ORC) for GPU-accelerated data loading. Columnar format + compression + metadata = significant speedup over CSV.
