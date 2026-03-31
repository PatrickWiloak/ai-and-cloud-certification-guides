# RAG Application Design - Databricks GenAI Engineer Associate

## Overview

This section covers RAG (Retrieval-Augmented Generation) application design, representing 30% of the exam. You need to understand RAG architecture, chunking strategies, embedding models, and retrieval approaches.

**[📖 RAG Overview](https://docs.databricks.com/en/generative-ai/retrieval-augmented-generation.html)** - RAG on Databricks
**[📖 Vector Search](https://docs.databricks.com/en/generative-ai/vector-search.html)** - Vector database

## Key Topics

### 1. RAG Architecture

**[📖 AI Cookbook](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/index.html)** - RAG tutorial

**RAG Pipeline Components:**
```
Documents -> Chunking -> Embedding -> Vector Store -> Retrieval -> LLM Generation -> Response
```

| Component | Purpose |
|-----------|---------|
| Document processing | Ingest, parse, and chunk source documents |
| Embedding model | Convert text chunks to dense vector representations |
| Vector store | Index and search embeddings for similarity |
| Retriever | Find relevant documents for a given query |
| Generator (LLM) | Produce an answer using retrieved context |

**Key Concepts:**
- RAG combines retrieval from a knowledge base with LLM generation
- Reduces hallucination by grounding responses in retrieved documents
- No model training required - knowledge is updated by refreshing the document store
- Suitable when knowledge changes frequently or is domain-specific

**RAG vs Fine-Tuning vs Prompt Engineering:**
| Approach | When to Use | Training Required |
|----------|-------------|-------------------|
| Prompt engineering | Simple instruction-following tasks | No |
| RAG | Knowledge changes frequently, factual grounding needed | No |
| Fine-tuning | Need to change model behavior, style, or format | Yes |

### 2. Chunking Strategies

**[📖 Chunking](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/quality-iteration/chunking.html)** - Chunking approaches

| Strategy | How It Works | Pros | Cons |
|----------|-------------|------|------|
| Fixed-size | Split by character/token count | Simple, predictable | May split mid-sentence |
| Recursive character | Split by separators hierarchically | Respects text boundaries | Slightly more complex |
| Semantic | Split by meaning boundaries | Best quality chunks | Computationally expensive |
| Document-aware | Respect structure (headers, sections) | Preserves document logic | Requires format parsing |

**Chunk Size Considerations:**
| Size | Retrieval Precision | Context Coverage |
|------|--------------------|--------------------|
| Small (128-256 tokens) | High (more targeted) | Low (may miss context) |
| Medium (256-512 tokens) | Balanced | Balanced |
| Large (512-1024 tokens) | Lower (may include noise) | High (more context) |

**Key Concepts:**
- Chunk overlap (10-20%) prevents losing context at chunk boundaries
- Metadata enrichment adds source, title, section, and page number to each chunk
- Smaller chunks improve retrieval precision but may lose surrounding context
- Larger chunks provide more context but may retrieve irrelevant information
- Typical production range: 256-512 tokens with 10-20% overlap

### 3. Embedding Models

**[📖 Foundation Model APIs](https://docs.databricks.com/en/machine-learning/foundation-models/index.html)** - Model serving

**Available Options:**
| Provider | Models | Integration |
|----------|--------|-------------|
| Databricks-hosted | BGE, GTE | Direct endpoint access |
| External (proxied) | OpenAI, Cohere | External model endpoints |
| Custom | Fine-tuned embeddings | Custom serving endpoint |

**Key Concepts:**
- Embedding models convert text to dense vector representations
- Vectors capture semantic meaning (similar text has similar vectors)
- Embedding dimensions affect storage, performance, and quality (768-1536 typical)
- Use the same embedding model for both indexing and querying
- Similarity metrics: cosine similarity (most common), dot product, Euclidean distance

### 4. Retrieval Strategies

| Strategy | Description | Use Case |
|----------|-------------|----------|
| Similarity search | Find nearest vectors to query | Basic retrieval |
| MMR (Maximum Marginal Relevance) | Balance relevance and diversity | Avoid redundant results |
| Filtered search | Combine vector similarity with metadata filters | Scoped search (by date, source) |
| Hybrid search | Combine dense (vector) and sparse (keyword) | Best of both approaches |
| Re-ranking | Use cross-encoder to re-score retrieved docs | Improved precision |
| Multi-query | Generate multiple query variations | Better recall |

**Key Concepts:**
- Top-k selection: typically retrieve 3-10 documents
- More documents provide more context but risk diluting relevance
- Filtered search narrows results by metadata before vector similarity
- Hybrid search combines semantic understanding with keyword matching
- Re-ranking is a second pass that improves precision at the cost of latency

## Exam Tips for This Domain

1. **RAG vs fine-tuning** - RAG for changing knowledge; fine-tuning for changing behavior
2. **Chunking tradeoffs** - Smaller chunks = more precise retrieval; larger = more context
3. **Embedding consistency** - Same model for indexing and querying
4. **Retrieval strategies** - Know MMR, filtered search, hybrid search, and re-ranking
5. **Chunk overlap** - Prevents information loss at boundaries

## Documentation Links Summary

| Topic | Link |
|-------|------|
| RAG Overview | [docs.databricks.com/en/generative-ai/retrieval-augmented-generation.html](https://docs.databricks.com/en/generative-ai/retrieval-augmented-generation.html) |
| AI Cookbook | [docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/index.html](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/index.html) |
| Chunking | [docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/quality-iteration/chunking.html](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/quality-iteration/chunking.html) |
| Vector Search | [docs.databricks.com/en/generative-ai/vector-search.html](https://docs.databricks.com/en/generative-ai/vector-search.html) |
| Foundation Models | [docs.databricks.com/en/machine-learning/foundation-models/index.html](https://docs.databricks.com/en/machine-learning/foundation-models/index.html) |
