# RAPIDS Framework Overview

**[📖 RAPIDS Documentation](https://docs.rapids.ai/)** - Complete RAPIDS ecosystem reference

## RAPIDS Ecosystem

### Core Libraries

**cuDF - GPU DataFrames:**
- GPU-accelerated pandas-like DataFrame library
- Data loading, filtering, groupby, joins, string operations
- 10-100x faster than pandas for large datasets
- Primary data manipulation tool in RAPIDS

**cuML - GPU Machine Learning:**
- GPU-accelerated scikit-learn-like ML library
- Classification, regression, clustering, dimensionality reduction
- Compatible API with scikit-learn
- Significant speedup for training and inference

**cuGraph - GPU Graph Analytics:**
- GPU-accelerated graph analysis library
- PageRank, BFS, community detection, similarity
- NetworkX-compatible interface
- Scales to billion-edge graphs

**Dask-cuDF - Multi-GPU DataFrames:**
- Distributed cuDF across multiple GPUs
- Scales beyond single-GPU memory limits
- Integrates with Dask scheduler
- Partition-based parallel processing

### Supporting Libraries

**cuSpatial:** GPU-accelerated spatial and geospatial analysis
**cuCIM:** GPU-accelerated image processing for computational pathology
**cuSignal:** GPU-accelerated signal processing
**RMM:** RAPIDS Memory Manager for GPU memory allocation
**cuPy:** GPU-accelerated NumPy replacement

### CPU to GPU Mapping

| CPU Library | RAPIDS GPU Library | Speedup |
|-------------|-------------------|---------|
| pandas | cuDF | 10-100x |
| scikit-learn | cuML | 10-50x |
| NetworkX | cuGraph | 10-1000x |
| Dask DataFrame | Dask-cuDF | 10-100x |
| NumPy | cuPy | 5-50x |
| GeoPandas | cuSpatial | 10-100x |

## GPU-Accelerated Data Science Benefits

### Performance
- Massively parallel processing on GPU cores
- High memory bandwidth (GPU HBM vs CPU DDR)
- Efficient for columnar data operations
- Batch processing of large datasets

### Ease of Adoption
- API compatibility with popular CPU libraries
- Minimal code changes for migration
- Interoperability with pandas, NumPy, scikit-learn
- Docker containers with pre-configured environments

### Scalability
- Single GPU for medium datasets
- Multi-GPU with Dask-cuDF for larger datasets
- Multi-node scaling with Dask distributed scheduler
- Integration with Spark for enterprise data pipelines

## Installation and Setup

### Conda Installation
```bash
conda create -n rapids python=3.10
conda activate rapids
conda install -c rapidsai -c conda-forge -c nvidia \
  rapids=24.02 cuda-version=12.0
```

### Docker Container
```bash
# Pull RAPIDS container from NGC
docker pull nvcr.io/nvidia/rapidsai/base:24.02-cuda12.0-py3.10

# Run with GPU access
docker run --gpus all -it -p 8888:8888 \
  nvcr.io/nvidia/rapidsai/base:24.02-cuda12.0-py3.10
```

### Requirements
- NVIDIA GPU (Pascal or newer, compute capability 6.0+)
- CUDA toolkit (version matching RAPIDS release)
- Sufficient GPU memory for datasets
- Linux operating system (Ubuntu, CentOS, RHEL)

**[📖 RAPIDS Installation Guide](https://docs.rapids.ai/install)** - Setup instructions

## Memory Management with RMM

### RAPIDS Memory Manager (RMM)
- Manages GPU memory allocation for all RAPIDS libraries
- Pool allocator reduces allocation overhead
- Managed memory for automatic CPU-GPU data movement
- Memory logging for debugging

### Configuration
```python
import rmm
from rmm.allocators.cupy import rmm_cupy_allocator

# Pool allocator (pre-allocate GPU memory)
rmm.reinitialize(pool_allocator=True, initial_pool_size=2**30)

# Managed memory (allows oversubscription)
rmm.reinitialize(managed_memory=True)
```

### Memory Best Practices
- Use pool allocator for production workloads
- Monitor GPU memory with `nvidia-smi` or RMM logging
- Process data in chunks for datasets larger than GPU memory
- Release unused DataFrames to free GPU memory
- Use efficient data types (int32 vs int64 when possible)

## Interoperability

### pandas Integration
```python
import pandas as pd
import cudf

# pandas to cuDF
gpu_df = cudf.from_pandas(pd_df)

# cuDF to pandas
pd_df = gpu_df.to_pandas()
```

### NumPy/CuPy Integration
```python
import cupy as cp
import cudf

# cuDF to CuPy array
arr = gpu_df['column'].values

# CuPy to cuDF
gpu_df = cudf.DataFrame({'col': cp.array([1, 2, 3])})
```

### __cuda_array_interface__
- Standard protocol for sharing GPU memory between libraries
- Zero-copy data sharing between cuDF, cuML, cuPy
- Avoids unnecessary data copies on GPU

## Key Exam Concepts

- RAPIDS component mapping to CPU equivalents
- Benefits of GPU-accelerated data science
- Installation methods (conda, Docker, pip)
- RMM configuration for memory management
- Interoperability between RAPIDS and pandas/NumPy
- __cuda_array_interface__ for zero-copy sharing
