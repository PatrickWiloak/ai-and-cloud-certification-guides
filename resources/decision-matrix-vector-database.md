---
last-updated: 2026-05-03
---

# Decision matrix - Vector database

You have a RAG / semantic search workload. You need to pick a vector database. This page scores the major options against criteria that actually decide the choice in production. For a deeper write-up of each product, see [service-comparison-vector-databases.md](./service-comparison-vector-databases.md).

## Criteria

| # | Criterion | Why it matters |
|---|---|---|
| 1 | Hosted vs self-host | Ops burden vs control |
| 2 | Hybrid search (vector + keyword + filters) | Real-world queries are rarely pure vector |
| 3 | Metadata filtering at query time | Multi-tenant + RBAC + per-doc filters |
| 4 | Scale ceiling | Billions of vectors vs millions |
| 5 | Cost shape (per-query / storage / fixed) | Predictable spend at scale |
| 6 | Language SDK quality | Time-to-first-query in your stack |
| 7 | Integration with cloud-native services | If you're already on AWS / Azure / GCP |
| 8 | Vendor lock vs portable format | Switching costs |

## Scoring

Scale: 1 (poor) → 5 (excellent).

| Product | Hosted | Hybrid search | Metadata filter | Scale | Cost predictability | SDK | Cloud integration | Portability | Total |
|---|---|---|---|---|---|---|---|---|---|
| **Pinecone** | 5 | 4 | 5 | 5 | 3 (per-query + storage tiers) | 5 | 3 (cloud-agnostic) | 2 (proprietary) | 32 |
| **Weaviate** | 4 (cloud + self) | 5 (built-in BM25) | 5 | 5 | 4 | 4 | 3 | 4 (open-source) | 34 |
| **Qdrant** | 4 (cloud + self) | 4 | 5 | 5 | 4 | 4 | 3 | 4 (open-source) | 33 |
| **Milvus / Zilliz** | 4 (Zilliz hosted; Milvus self) | 4 | 5 | 5 (multi-billion) | 3 | 4 | 3 | 4 (open-source) | 32 |
| **pgvector (Postgres)** | 4 (any Postgres host) | 5 (full SQL + BM25 + vectors) | 5 | 3 (millions, billions with sharding) | 5 (your DB cost) | 5 (every Postgres SDK) | 5 (already there) | 5 (Postgres) | 37 |
| **OpenSearch / Elasticsearch** | 5 (managed services) | 5 (BM25 + vectors + filters native) | 5 | 5 | 3 | 4 | 5 (already there) | 4 (open-source) | 36 |
| **AWS Bedrock Knowledge Bases** | 5 | 4 | 4 | 4 | 3 | 4 | 5 (AWS-native) | 1 (lock-in) | 30 |
| **Azure AI Search** | 5 | 5 | 5 | 5 | 3 | 4 | 5 (Azure-native) | 2 | 34 |
| **Vertex Vector Search** | 5 | 3 (limited hybrid) | 4 | 5 | 3 | 4 | 5 (GCP-native) | 1 | 30 |
| **Chroma** | 3 (lighter hosted) | 3 | 4 | 3 (tens of millions) | 5 | 4 | 2 | 5 (OSS) | 29 |

## Recommendations by scenario

- **Already running Postgres, <50M vectors, want one fewer database to manage** → **pgvector**. Best total score; you avoid a new system entirely.
- **Already running OpenSearch or Elasticsearch** → **OpenSearch / Elasticsearch**. Native vector search shipped a few years ago; reuse what you have.
- **Cloud-native AWS, prefer fully managed RAG including chunking and ingestion** → **AWS Bedrock Knowledge Bases** if vendor lock is acceptable; otherwise **OpenSearch Serverless**.
- **Cloud-native Azure** → **Azure AI Search**. Best-in-class hybrid search and Azure-native.
- **Cloud-native GCP** → **Vertex Vector Search** if you need global low latency; **AlloyDB pgvector** if you want SQL too.
- **Want to self-host on K8s with great performance** → **Qdrant** or **Weaviate**. Both excellent OSS; Weaviate has stronger built-in hybrid search.
- **Need billions of vectors, willing to operate** → **Milvus** (or **Zilliz** hosted) - the one purpose-built for that scale.
- **Need fastest time-to-first-query for prototyping** → **Chroma** locally, then migrate when you outgrow it.
- **Don't want to think about it, willing to pay** → **Pinecone**. It just works; predictable behavior; the largest community of how-tos.

## Anti-patterns

- Running a dedicated vector DB to store <1M vectors when your existing Postgres / OpenSearch could handle it.
- Picking based on benchmarks alone - real-world hybrid + metadata filtering performance dominates pure vector recall benchmarks.
- Forgetting to budget for re-embedding when you change the embedding model.

## Related

- [Embeddings and vector search](../learn/concepts/embeddings-and-vector-search.md) - the underlying concept
- [RAG explained](../learn/concepts/rag-explained.md) - the most common use case
- [service-comparison-vector-databases.md](./service-comparison-vector-databases.md) - per-product detail
- [Build a RAG pipeline](./hands-on-projects/build-rag-pipeline.md) - hands-on with pgvector
