# cuGraph - GPU Graph Analytics

**[📖 cuGraph Documentation](https://docs.rapids.ai/api/cugraph/stable/)** - GPU graph analytics reference

## Graph Construction

### From Edge Lists

```python
import cugraph
import cudf

# Create edge list DataFrame
edges = cudf.DataFrame({
    'src': [0, 1, 2, 3, 4],
    'dst': [1, 2, 3, 4, 0],
    'weight': [1.0, 2.0, 3.0, 4.0, 5.0]
})

# Create graph
G = cugraph.Graph(directed=True)
G.from_cudf_edgelist(edges, source='src', destination='dst', edge_attr='weight')

# Undirected graph
G_undirected = cugraph.Graph(directed=False)
G_undirected.from_cudf_edgelist(edges, source='src', destination='dst')
```

### Graph Properties

```python
# Number of nodes and edges
print(G.number_of_vertices())
print(G.number_of_edges())

# Get edge list
edge_df = G.view_edge_list()

# Get adjacency list
adj = G.view_adj_list()

# Degree information
degrees = G.degree()
in_degrees = G.in_degree()
out_degrees = G.out_degree()
```

## Graph Algorithms

### Centrality Algorithms

**PageRank:**
```python
# Compute PageRank
pr = cugraph.pagerank(G, alpha=0.85, max_iter=100, tol=1e-5)
# Returns DataFrame with 'vertex' and 'pagerank' columns

# Top 10 most important nodes
top_nodes = pr.nlargest(10, 'pagerank')
```

**Betweenness Centrality:**
```python
bc = cugraph.betweenness_centrality(G, k=100)  # k = sample size
```

**Katz Centrality:**
```python
katz = cugraph.katz_centrality(G, alpha=0.1)
```

### Traversal Algorithms

**Breadth-First Search (BFS):**
```python
# BFS from vertex 0
bfs_result = cugraph.bfs(G, start=0)
# Returns: vertex, distance, predecessor
```

**Single-Source Shortest Path (SSSP):**
```python
# Shortest paths from vertex 0 (weighted)
sssp = cugraph.sssp(G, source=0)
# Returns: vertex, distance, predecessor
```

### Community Detection

**Louvain:**
```python
# Community detection
parts, modularity = cugraph.louvain(G, resolution=1.0)
# parts: DataFrame with 'vertex' and 'partition' columns
# modularity: quality score of partition
```

**Leiden:**
```python
parts, modularity = cugraph.leiden(G, resolution=1.0)
```

**Triangle Counting:**
```python
count = cugraph.triangle_count(G)
```

**Connected Components:**
```python
# Weakly connected components
labels = cugraph.weakly_connected_components(G)

# Strongly connected components (directed graphs)
labels = cugraph.strongly_connected_components(G)
```

### Similarity

**Jaccard Similarity:**
```python
# Compute Jaccard similarity for all edges
jaccard = cugraph.jaccard(G)
```

**Overlap Coefficient:**
```python
overlap = cugraph.overlap(G)
```

### Link Prediction
```python
# Jaccard-based link prediction
jaccard_coeff = cugraph.jaccard_coefficient(G, vertex_pair=vertex_pairs)
```

## Integration with cuDF

### Workflow Pattern

```python
import cudf
import cugraph

# 1. Load data with cuDF
edges_df = cudf.read_csv('edges.csv')
nodes_df = cudf.read_csv('nodes.csv')

# 2. Build graph
G = cugraph.Graph()
G.from_cudf_edgelist(edges_df, source='src', destination='dst', edge_attr='weight')

# 3. Run algorithm
pr = cugraph.pagerank(G)

# 4. Join results back to node data
result = nodes_df.merge(pr, left_on='node_id', right_on='vertex')

# 5. Filter and analyze
important = result[result['pagerank'] > 0.01]
```

### Data Preparation
- Clean edge data with cuDF before graph construction
- Handle missing values and duplicates
- Ensure vertex IDs are contiguous integers for best performance
- Use `renumber=True` if IDs are non-contiguous

## Scalability

### Performance Characteristics
- cuGraph can handle millions to billions of edges
- Algorithms run entirely on GPU memory
- Significant speedup over NetworkX (100-1000x)
- Memory-limited by GPU capacity

### Multi-GPU with Dask-cuGraph
```python
from dask_cuda import LocalCUDACluster
from dask.distributed import Client
import dask_cudf
import cugraph.dask as dcg

# Set up multi-GPU cluster
cluster = LocalCUDACluster()
client = Client(cluster)

# Multi-GPU PageRank
ddf = dask_cudf.read_parquet('edges/*.parquet')
G = dcg.Graph()
G.from_dask_cudf_edgelist(ddf, source='src', destination='dst')
pr = dcg.pagerank(G)
```

## Use Cases

- **Social network analysis** - community detection, influence ranking
- **Fraud detection** - anomalous subgraph identification
- **Recommendation systems** - collaborative filtering via graph
- **Knowledge graphs** - entity relationship analysis
- **Cybersecurity** - network traffic graph analysis
- **Supply chain** - dependency and risk analysis

## Key Exam Concepts

- Graph construction from cuDF edge lists
- Core algorithms: PageRank, BFS, SSSP, Louvain, connected components
- Integration pattern: cuDF data loading, graph construction, analysis, merge results
- Directed vs undirected graph creation
- Multi-GPU scaling with Dask-cuGraph
- Algorithm selection for different use cases
