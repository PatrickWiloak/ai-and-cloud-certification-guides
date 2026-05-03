# Embeddings and Vector Search

> **7-minute read.**

## The one-line answer

An **embedding** is a list of numbers (a vector) that represents the *meaning* of a piece of text. Two pieces of text with similar meaning have similar vectors. **Vector search** is finding the nearest vectors to a query - which translates to "find me text that means roughly the same thing."

This is how semantic search, RAG, recommendations, and most modern "find similar things" systems work.

## The shift from keyword to meaning

Old-school search: keyword matching. You type "automobile" and the engine looks for documents containing the word "automobile." Documents about "cars," "vehicles," or "Toyotas" won't match unless they happen to also use that exact word.

Embeddings fix that. The vector for "automobile" lives near the vector for "car," "vehicle," and "Toyota." A query gets converted to a vector, then you find the nearest document vectors. Meaning, not literals.

## What an embedding looks like

A high-dimensional vector. Typical sizes:

| Model | Dimensions |
|-------|------------|
| OpenAI text-embedding-3-small | 1536 |
| OpenAI text-embedding-3-large | 3072 |
| Cohere embed-v3 | 1024 |
| Voyage voyage-3 | 1024 |
| All-MiniLM-L6-v2 (open) | 384 |

A 1536-dimensional vector is just a list of 1536 floating-point numbers. By itself, the numbers are meaningless. What matters is *relative distances* between vectors.

## How "similar" gets measured

The standard metric is **cosine similarity**: the cosine of the angle between two vectors.

- `1.0` = identical direction (very similar meaning)
- `0.0` = orthogonal (unrelated)
- `-1.0` = opposite (rare in practice with text embeddings)

Most text embedding pairs land between 0.2 and 0.9. There's no universal "similar enough" threshold - it depends on your data. Calibrate empirically.

Other distance metrics: dot product (sometimes faster), Euclidean (rare for text). Cosine is the safe default.

## Where embeddings come from

You feed text to an embedding model, it returns a vector. The embedding model is a neural network (often a smaller transformer) that's been trained specifically to produce vectors where semantically similar inputs land close.

You don't train your own embedding model in 99% of cases. You call an API (OpenAI, Cohere, Voyage, Google) or run a small open one (sentence-transformers).

```python
# Pseudocode
vector_for_query = embed("how do I reset my password?")
# vector_for_query is now a list of 1536 floats
```

## The vector database

You can compute a query embedding in milliseconds. The hard part is finding nearest neighbors in a corpus of millions of pre-computed embeddings, fast.

That's what a **vector database** does. It indexes vectors so you can ask "find me the K nearest vectors to this one" in tens of milliseconds.

| Type | Examples |
|------|----------|
| **Dedicated vector DBs** | Pinecone, Weaviate, Qdrant, Milvus |
| **General DBs with vector support** | PostgreSQL (pgvector), Elasticsearch, MongoDB Atlas, Redis |
| **In-process libraries** | FAISS, Annoy, hnswlib |
| **Cloud services** | AWS OpenSearch, Azure AI Search, Vertex AI Vector Search |

For small corpora (<1M vectors), pgvector on a Postgres you already have is usually the right answer. Don't reach for a dedicated vector DB until you have a real reason.

## Approximate nearest neighbor (ANN)

Exact nearest-neighbor search is O(n) - you compare to every vector. At a million vectors that's slow.

Vector DBs use **approximate** algorithms (HNSW is the most common) that trade tiny accuracy for huge speed wins. Typical setup: 99% recall, 50ms p99 latency on 10M vectors. The "approximate" part rarely matters in practice for retrieval.

## A small concrete example

You're building a help center search.

1. **Indexing time** (once, or whenever docs change):
   - Take each help article.
   - Chunk into ~500-token pieces (more on chunking in [RAG explained](./rag-explained.md)).
   - Embed each chunk.
   - Store `(chunk_id, chunk_text, vector, metadata)` in a vector DB.

2. **Query time** (every user search):
   - User types "I can't log in."
   - Embed the query.
   - Vector DB returns the 10 nearest chunks.
   - Show them, ranked by similarity.

That's semantic search. The user typed "log in" but you might surface chunks about "password recovery," "account locked," "two-factor authentication" - all because their vectors are nearby.

## Embeddings for things that aren't text

The same idea applies to any modality:

- **Image embeddings**: CLIP, DINOv2. Search images by description or by example image.
- **Audio embeddings**: Wav2Vec, Whisper internals.
- **Multimodal embeddings**: CLIP again - put text and images in the same vector space, so a text query can retrieve images.
- **Code embeddings**: code-specific models that understand syntax + semantics.

The pattern is the same: train a model to produce vectors where similar things land near each other, then nearest-neighbor.

## Common pitfalls

### Mixing embedding models
Vectors from OpenAI's `text-embedding-3-small` are not comparable to vectors from Cohere's `embed-v3`. Different model = different vector space. Pick one and stick with it. If you change models, re-embed everything.

### Mixing models within the same store
Same problem at smaller scale: don't index half your corpus with v2 and half with v3.

### Asking embeddings to do reasoning
Embeddings encode similarity, not logic. "Documents that *contradict* this claim" is not what cosine similarity gives you. You need re-ranking, NLI models, or LLM-based filtering for that.

### Forgetting metadata filtering
Sometimes you want "the most similar doc *that's tagged 'public'*." Most vector DBs support metadata filters - use them. They also matter for tenant isolation in multi-tenant apps.

### Treating raw similarity as quality
A query can match a doc with cosine 0.9 that's still totally wrong for the user's intent. Always evaluate retrieval end-to-end (does the right answer make it into top-K?), not just by score.

## Cost reality

Embeddings are cheap. Embedding a million chunks of 500 tokens each on OpenAI's `text-embedding-3-small`: a few dollars. Storing them in pgvector: free if you have Postgres.

The expensive part is when you don't think about chunking strategy and end up re-embedding 100K documents because you changed your mind about chunk size. Plan that once.

## What to look at next

- **[RAG explained](./rag-explained.md)** - the most common use of embeddings
- **[LLM basics](./llm-basics.md)** - what's downstream of retrieval
- **[Service comparison: AI/ML](../../resources/service-comparison-ai-ml.md)** - vector DB options across clouds
- **[Glossary: Embedding, Vector DB, ANN](../glossary.md)**
