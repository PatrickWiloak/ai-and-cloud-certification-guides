# Production RAG Systems - NCP-GENL

## Overview

Retrieval-Augmented Generation (RAG) combines information retrieval with LLM generation to produce accurate, grounded responses. This document covers the end-to-end RAG pipeline architecture, optimization strategies, and production deployment patterns using NVIDIA tools and frameworks.

**[📖 NVIDIA RAG Pipeline Guide](https://docs.nvidia.com/ai-enterprise/workflows-generative-ai/latest/rag/index.html)** - Building RAG with NVIDIA stack
**[📖 NVIDIA GenerativeAIExamples](https://github.com/NVIDIA/GenerativeAIExamples)** - Reference RAG implementations

## Key Topics

### 1. RAG Pipeline Architecture

**Ingestion Pipeline**
- Document loading: PDF, HTML, Markdown, databases, APIs
- Document parsing: Extract text, tables, images from documents
- Text splitting: Break documents into manageable chunks
- Embedding generation: Convert chunks to dense vector representations
- Index storage: Store embeddings in vector database

**Query Pipeline**
- Query processing: Clean, expand, or reformulate user query
- Embedding: Convert query to vector representation
- Retrieval: Search vector database for relevant chunks
- Re-ranking: Refine retrieved results for better precision
- Augmentation: Construct prompt with retrieved context
- Generation: LLM generates response using augmented prompt

**[📖 NeMo Retriever](https://docs.nvidia.com/nim/nemo-retriever/latest/index.html)** - NVIDIA embedding and retrieval microservices

### 2. Embedding Models

**Embedding Model Selection**
- Model dimensions: 384, 768, 1024, 4096 common sizes
- Higher dimensions capture more information but use more memory
- Context length: Must accommodate your chunk sizes
- Domain fit: General vs domain-specific embeddings

**NVIDIA Embedding Models**
- NV-Embed: High-quality embeddings optimized for retrieval
- Available through NIM microservices
- Support for batch embedding generation
- GPU-accelerated for high throughput

**Embedding Best Practices**
- Use the same model for indexing and querying
- Normalize embeddings for cosine similarity
- Benchmark embedding models on your domain data
- Consider multilingual models for multi-language content

**[📖 NVIDIA NV-Embed](https://build.nvidia.com/)** - NVIDIA embedding models on build.nvidia.com

### 3. Chunking Strategies

**Fixed-Size Chunking**
- Split text into fixed token/character counts
- Add overlap between chunks (10-20% of chunk size)
- Simple and predictable behavior
- May split sentences or paragraphs mid-thought

**Semantic Chunking**
- Split at natural content boundaries (paragraphs, sections)
- Preserves semantic coherence within chunks
- Variable chunk sizes
- Better retrieval quality for structured documents

**Recursive Character Text Splitting**
- Hierarchical splitting: paragraphs, sentences, characters
- Maintains semantic boundaries when possible
- Falls back to character splitting for very long sections
- Most common approach in practice

**Chunk Size Optimization**
- Small chunks (128-256 tokens): More precise retrieval, less context
- Medium chunks (256-512 tokens): Balance of precision and context
- Large chunks (512-1024 tokens): More context, less precise matching
- Optimal size depends on document type and query patterns
- Test multiple sizes and measure retrieval quality

### 4. Vector Databases

**Popular Options**
- **Milvus:** Open-source, GPU-accelerated, enterprise-ready
- **FAISS:** Facebook AI Similarity Search, library (not database)
- **pgvector:** PostgreSQL extension for vector search
- **Weaviate:** Cloud-native vector database with hybrid search
- **Chroma:** Lightweight, developer-friendly vector store
- **Pinecone:** Managed vector database service

**Index Types**
- **Flat (brute force):** Exact search, O(n) per query, best accuracy
- **IVF (Inverted File):** Cluster-based approximate search, faster
- **HNSW (Hierarchical Navigable Small World):** Graph-based, excellent recall
- **GPU-accelerated indices:** FAISS GPU, Milvus GPU for high throughput

**Similarity Metrics**
- Cosine similarity: Measures angle between vectors (most common)
- Dot product: Faster, equivalent to cosine for normalized vectors
- L2 (Euclidean) distance: Measures absolute distance
- Choose based on embedding model recommendations

### 5. Retrieval Optimization

**Hybrid Search**
- Combine dense vector search with sparse keyword search (BM25)
- Dense captures semantic similarity
- Sparse captures exact keyword matches
- Reciprocal Rank Fusion (RRF) to combine results
- Better coverage than either approach alone

**Re-Ranking**
- Cross-encoder models score query-document pairs jointly
- More accurate than bi-encoder (embedding) similarity
- Applied to top-k results from initial retrieval (typically top 20-50)
- Final top results (typically 3-5) sent to LLM
- NVIDIA NeMo Retriever includes re-ranking models

**Query Processing**
- Query expansion: Add related terms to improve recall
- Query decomposition: Break complex queries into sub-queries
- HyDE (Hypothetical Document Embeddings): Generate hypothetical answer, search with that
- Multi-query: Generate multiple query variants and merge results

**Metadata Filtering**
- Filter by document type, date, source, permission
- Pre-filter before vector search for efficiency
- Post-filter after retrieval for flexibility
- Combine with vector search for precise results

**[📖 NeMo Retriever Re-ranking](https://docs.nvidia.com/nim/nemo-retriever/latest/index.html)** - Re-ranking models documentation

### 6. Context Window Management

**Context Assembly**
- Order retrieved chunks by relevance
- Include source citations for traceability
- Respect model context window limits
- Balance context quantity with quality

**Long-Context Strategies**
- Summarize retrieved chunks before insertion
- Use map-reduce for processing many documents
- Hierarchical retrieval: summary-level then detail-level
- Compressed context representations

**Prompt Engineering for RAG**
- System prompt establishes RAG behavior rules
- Include instructions to cite sources
- Specify behavior when context doesn't contain the answer
- Format context clearly (numbered, with source labels)

### 7. RAG Evaluation

**Retrieval Metrics**
- **Precision@k:** Fraction of relevant documents in top-k results
- **Recall@k:** Fraction of relevant documents found in top-k
- **MRR (Mean Reciprocal Rank):** Average of 1/rank of first relevant result
- **NDCG:** Normalized Discounted Cumulative Gain - considers ranking quality
- **Hit Rate:** Fraction of queries with at least one relevant result in top-k

**Generation Metrics**
- **Faithfulness:** Does the answer reflect the retrieved context?
- **Relevance:** Does the answer address the user's question?
- **Completeness:** Does the answer cover all relevant information?
- **Hallucination Rate:** Frequency of claims not supported by context

**Evaluation Frameworks**
- RAGAS: Automated RAG evaluation framework
- LLM-as-judge: Use a strong LLM to evaluate answer quality
- Human evaluation: Gold standard for quality assessment
- A/B testing: Compare RAG configurations in production

**[📖 NVIDIA RAG Evaluation](https://developer.nvidia.com/blog/build-enterprise-retrieval-augmented-generation-apps-with-nvidia-retrieval-qa-embedding-model/)** - RAG evaluation approaches

### 8. Production RAG Deployment

**Architecture for Scale**
- Separate ingestion and serving pipelines
- Horizontally scale embedding service
- Shard vector database across nodes
- Cache frequent queries and results
- Async document ingestion via message queues

**NVIDIA Stack for RAG**
- NIM for LLM inference
- NeMo Retriever NIM for embedding and re-ranking
- Milvus or pgvector for vector storage
- NeMo Guardrails for safety
- Kubernetes for orchestration

**Monitoring**
- Track retrieval latency (p50, p95, p99)
- Monitor generation quality metrics
- Log retrieval results for debugging
- Alert on quality degradation
- Track cache hit rates

**Common Failure Modes**
- Retrieval misses: Important context not found
- Context pollution: Irrelevant chunks dilute useful context
- Hallucination despite context: LLM ignores retrieved information
- Stale data: Index not updated with latest documents
- Embedding drift: Query distribution shifts from indexed content

## Exam Focus Areas

### Critical Concepts
- Understand the complete RAG pipeline from ingestion to generation
- Know chunking strategies and their tradeoffs
- Understand hybrid search and re-ranking benefits
- Know evaluation metrics for both retrieval and generation
- Be familiar with NVIDIA tools for production RAG

### Common Exam Questions
- "How to improve retrieval when keyword matches matter?" - Hybrid search (dense + BM25)
- "What improves precision after initial retrieval?" - Cross-encoder re-ranking
- "Optimal chunk size for detailed technical documents?" - 256-512 tokens with overlap
- "How to handle RAG when context doesn't have the answer?" - System prompt instruction
- "Which NVIDIA service for embeddings?" - NeMo Retriever NIM
