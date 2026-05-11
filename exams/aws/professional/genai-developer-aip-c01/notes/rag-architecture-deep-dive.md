# RAG Architecture Deep-Dive

> **Cross-cutting deep-dive.** RAG concepts are tested in Domain 1 (design), Domain 4 (optimization), and Domain 5 (evaluation/troubleshooting). Together those domains are 54% of the exam, so depth here matters.

## Table of contents

- [What RAG is and why it matters](#what-rag-is-and-why-it-matters)
- [The full RAG pipeline](#the-full-rag-pipeline)
- [Ingestion phase](#ingestion-phase)
- [Retrieval phase](#retrieval-phase)
- [Generation phase](#generation-phase)
- [Reference architectures](#reference-architectures)
- [Failure modes and fixes](#failure-modes-and-fixes)
- [RAG evaluation](#rag-evaluation)
- [When NOT to use RAG](#when-not-to-use-rag)
- [Quick-recall summary](#quick-recall-summary)

## What RAG is and why it matters

**Retrieval Augmented Generation** is the pattern of attaching external knowledge to a foundation model at inference time. The model itself isn't retrained; instead, relevant documents are retrieved and stuffed into the prompt as context.

Why it dominates GenAI architecture:

- **Fresh / proprietary knowledge** without retraining.
- **Cheaper** than fine-tuning when knowledge changes frequently.
- **Auditable** - you can show which document supported the answer (citations).
- **Less hallucination** when retrieval is good (the model has the facts in its context).

The exam tests the full RAG pipeline, not just "use Bedrock Knowledge Bases."

## The full RAG pipeline

```
[Source docs]
     |
     v
[Ingestion] -> chunking -> embedding -> indexing -> [Vector store + metadata]
                                                            |
[User query] -> [Query handling] -> embedding ->            |
     |                                  |                   |
     |                                  v                   |
     |                            [Vector search] <---------+
     |                                  |
     |                                  v
     |                          [Top-K candidates]
     |                                  |
     |                                  v
     |                          [Reranker (optional)]
     |                                  |
     |                                  v
     |                          [Top-N curated context]
     |                                  |
     |                                  v
     +--------------------> [Prompt assembly: question + context + instructions]
                                        |
                                        v
                                   [FM generation]
                                        |
                                        v
                            [Post-processing + citations]
                                        |
                                        v
                                    [Response]
```

## Ingestion phase

### Source connectors (Bedrock Knowledge Bases)

| Source | Notes |
|--------|-------|
| **Amazon S3** | Most common. PDF, HTML, MD, TXT, DOCX, CSV, XLSX, JSON. |
| **Web Crawler** | Public sites or authenticated wikis. Configurable seed URLs and crawl depth. |
| **Confluence** | OAuth-based. |
| **Microsoft SharePoint** | OAuth-based. |
| **Salesforce** | OAuth-based. Knowledge Articles + custom objects. |
| **Custom** | Direct ingestion API: you push pre-chunked text. |

For sources not natively supported: land in S3 first via **AWS DataSync**, **AWS Transfer Family**, **Amazon AppFlow**, or **AWS DMS**.

### Chunking strategies in depth

**Why chunk?** Foundation models have context limits, and even when they don't, dumping a 200-page PDF results in expensive prompts and worse retrieval (small relevant passages get lost).

| Strategy | Description | Best for | Trade-offs |
|----------|-------------|----------|-----------|
| **Default chunking** (Bedrock KB) | ~300 tokens, 20% overlap, sentence-boundary aware | General docs | Decent baseline, not optimized for any structure |
| **Fixed-size** | N tokens with M overlap | Uniform docs | Simple but ignores structure |
| **Hierarchical** | Parent chunk (large, e.g., section) + child chunks (small, e.g., paragraph). Search children, return parents to FM. | Long structured docs (legal, manuals) | More precise retrieval + richer context, but more storage |
| **Semantic** | Boundaries placed at semantic shifts using embedding similarity between sentences | When natural sections aren't marked | Requires extra computation at ingest |
| **Custom (Lambda preprocessor)** | Domain-specific (split by `##` markdown headers, by legal section number, etc.) | Specialized formats | Best precision, most engineering |

**Chunk size guidance:**
- Smaller chunks (100-300 tokens) → high precision, can miss broader context
- Larger chunks (500-1000 tokens) → more context, lower precision, more tokens billed
- Hierarchical chunking sidesteps this trade-off

**Overlap**: 10-20% prevents cutting concepts at chunk boundaries.

### Embedding generation

Models in scope:

| Model | Dimensions | Notes |
|-------|------------|-------|
| **Amazon Titan Text Embeddings v2** | 256, 512, 1024 | Configurable; multilingual |
| **Amazon Titan Multimodal Embeddings G1** | 1024 | Joint image + text |
| **Cohere Embed English v3** | 1024 | Strong English retrieval |
| **Cohere Embed Multilingual v3** | 1024 | 100+ languages |
| Custom on **SageMaker AI** | Anything | When you need a domain-specific embedder |

Decision criteria:
- **Storage / cost**: 1024-dim vectors take 4× the storage of 256-dim. For most enterprise corpora, 512 is a good sweet spot.
- **Multilingual**: pick a multilingual model if any documents or queries are non-English.
- **Domain fit**: embeddings trained on web text may underperform on legal, medical, code. If you have eval data, test 2-3 candidates.

**Important**: queries and documents must be embedded with the **same model** for similarity to be meaningful. Bedrock Knowledge Bases enforces this; if you build your own, store the model version with the index.

### Indexing

Backing store options for Bedrock Knowledge Bases:

| Store | Notes |
|-------|-------|
| **Amazon OpenSearch Serverless (vector engine)** | Default; zero-ops; scales automatically. |
| **Amazon Aurora PostgreSQL with pgvector** | Vectors next to relational data. Use when SQL filters matter. |
| **MongoDB Atlas** | Third-party. |
| **Pinecone** | Third-party SaaS. |
| **Redis Enterprise Cloud** | Third-party. |
| **Amazon Neptune Analytics** | Graph + vectors. Use when relationships between entities matter. |

When **rolling your own** outside Knowledge Bases, you typically write embeddings to **OpenSearch Service** with the k-NN plugin (or Neural plugin for direct Bedrock embedding integration).

### Metadata strategy

Every chunk should be stored with metadata fields you can filter on:

- `source_uri` (S3 path or URL)
- `document_id`, `document_title`
- `last_modified` (timestamp)
- `language`
- `region` / `tenant` / `customer_id`
- `sensitivity_level` (public, internal, confidential)
- `version`

**Bedrock Knowledge Bases metadata filtering** at retrieval time (`retrievalConfiguration.vectorSearchConfiguration.filter`) is the exam-relevant mechanism. Pre-filter before vector search to restrict to relevant scope (e.g., `tenant_id = 'acme'`).

## Retrieval phase

### Query embedding

The user's query is embedded with the same model used for documents. This gives a query vector to compare against indexed document vectors.

### Vector similarity

Standard distance metrics:
- **Cosine similarity** (most common) - measures angle, ignores magnitude.
- **Euclidean (L2)** - measures direct distance.
- **Dot product** - faster on normalized vectors.

ANN algorithms (you don't compute against every vector at scale):
- **HNSW** (Hierarchical Navigable Small World) - default in OpenSearch, balances speed and recall.
- **IVF** (Inverted File Index) - clusters then searches within nearest clusters; faster build, slower query than HNSW typically.

Tunable knobs:
- **`top_k`**: how many candidates to retrieve. 5-20 typical; larger for reranking pipelines.
- **`ef_search`** (HNSW): higher = better recall, slower latency.

### Hybrid search (keyword + vector)

Pure vector search misses exact-match terms (product codes, error codes, names). Hybrid search runs **BM25 keyword search** alongside vector search and combines scores.

Implementations:
- **OpenSearch** native `hybrid` query (combines `match` and `knn`)
- **Bedrock Knowledge Bases**: `searchType: HYBRID` in retrieve API
- **Custom** with reciprocal rank fusion (RRF) over two result sets

**Almost always preferred over pure vector for production.**

### Reranking

After retrieval, top-K candidates pass through a more accurate but slower **cross-encoder** model that scores each candidate against the query directly.

Bedrock-supported rerankers:
- **Amazon Rerank**
- **Cohere Rerank** (multiple versions)

When to use:
- Initial retrieval is noisy (large corpora, ambiguous queries)
- You need higher precision
- Latency budget allows ~50-200ms more

Pattern: retrieve `top_k=50` with vector search → rerank → keep `top_n=5` for the FM.

### Query handling techniques

| Technique | What it does | When to use |
|-----------|--------------|-------------|
| **Query expansion** | Use a small FM to generate synonyms / paraphrases. Run multiple retrievals and merge. | Short, ambiguous queries |
| **Query decomposition** | Split a multi-part question ("compare Bedrock Agents and AgentCore") into sub-questions. Retrieve each, fuse context. | Multi-hop questions |
| **Query transformation / rewriting** | Convert conversational queries ("how about that one?") into standalone queries using chat history. | Multi-turn conversations |
| **HyDE (Hypothetical Document Embeddings)** | Have the FM generate a hypothetical answer first, embed it, then retrieve docs similar to that. | Sparse-data domains where queries don't match doc style |

**Orchestration**: Step Functions handles the multi-call coordination. Lambda nodes call Bedrock to expand/decompose, then aggregate retrievals.

## Generation phase

### Prompt assembly

A solid RAG prompt:

```
You are a customer support specialist for ACME Corp. Answer the user's
question using ONLY the information in the <context> tags. If the context
does not contain the answer, say "I don't know" - do NOT use prior knowledge.

<context>
{retrieved_chunk_1}
[Source: docs/billing-faq.md, last updated 2026-04-12]

{retrieved_chunk_2}
[Source: docs/refunds.md, last updated 2026-03-01]
</context>

<question>
{user_question}
</question>

Respond in JSON with fields: answer (string), sources (array of source URIs).
```

Critical practices:
- **Wrap context in tags** so the model can reference it precisely.
- **Include source attribution inline** so the model can cite.
- **Constrain output format** for parseability.
- **Forbid out-of-context answers** to reduce hallucination.

### Citations and grounding

The exam tests how to ground responses:

- **Bedrock Knowledge Bases RetrieveAndGenerate** API returns citations linked to source chunks automatically.
- **Bedrock Guardrails contextual grounding** - dedicated check that the response is supported by provided context. Filters out ungrounded/hallucinated responses.
- **Manual grounding**: parse model JSON output, validate cited sources actually appear in retrieved chunks.

### Response streaming

For long responses, stream tokens to the user (better perceived latency):
- **Bedrock InvokeModelWithResponseStream** / **ConverseStream**
- API Gateway with WebSockets or chunked responses
- AWS AppSync for GraphQL streaming subscriptions

## Reference architectures

### A. Bedrock Knowledge Bases (managed - default choice)

```
S3 bucket (PDFs)
   |
   v
Bedrock Knowledge Base (handles chunking + Titan embedding + index)
   |
   v
OpenSearch Serverless vector engine (managed by KB)
   |
User query -> API Gateway -> Lambda -> Bedrock RetrieveAndGenerate(KB_ID) -> response with citations
```

Use when: minimal ops, standard requirements, time-to-prod matters.

### B. Custom RAG with OpenSearch Service + Bedrock

```
S3 -> EventBridge -> Lambda (chunking) -> Lambda (Titan embeddings) -> OpenSearch Service (k-NN index)

User query -> API Gateway -> Lambda
                              |-> Lambda calls Bedrock for query expansion (optional)
                              |-> OpenSearch hybrid search
                              |-> Lambda calls Bedrock Rerank (optional)
                              |-> Bedrock Converse with assembled prompt + context
                              |-> Apply Bedrock Guardrails (input + output)
                              |-> Return to user
```

Use when: you need fine-grained control over chunking/sharding, custom rerankers, or already use OpenSearch.

### C. Aurora pgvector with relational filtering

```
Source DB tables -> Lambda -> Bedrock Titan embeddings -> Aurora PostgreSQL (pgvector column on existing table)

User query -> Lambda -> Bedrock Titan embeddings -> Aurora SELECT ... WHERE tenant_id = $1 ORDER BY embedding <-> $2 LIMIT 10
                                                          |
                                                          v
                                                   Bedrock Converse
```

Use when: vectors must live next to operational relational data; rich SQL filters; consistent transactions.

### D. Multimodal RAG

```
PDFs / images / audio -> Bedrock Data Automation (BDA) -> structured insights + chunks
                                                                |
                                                                v
                                                Titan Multimodal Embeddings
                                                                |
                                                                v
                                                Bedrock Knowledge Base (multimodal)
                                                                |
User query (text or image) -> Bedrock multimodal model (Claude 3+, Nova) with retrieved context
```

Use when: documents include images, charts, diagrams that matter for retrieval.

### E. Kendra-backed RAG

```
Enterprise sources (SharePoint, ServiceNow, S3, etc.) -> Kendra connectors -> Kendra index

User query -> Lambda -> Kendra Query API -> top-N answers/passages -> Bedrock Converse with passages as context
```

Use when: you already use Kendra; want enterprise connectors out-of-box; care more about high-precision search than vector flexibility.

## Failure modes and fixes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| **Retrieved docs aren't relevant** | Bad chunking; wrong embedding model; missing metadata filters | Try hierarchical chunking; switch embedding model; add metadata filtering |
| **Right doc retrieved, wrong answer generated** | Prompt doesn't constrain to context; FM ignores instructions | Tighten prompt; use Guardrails contextual grounding; lower temperature |
| **Hallucinated facts** | Context insufficient; FM filling gaps; temperature too high | Add "say 'I don't know' if context insufficient"; Guardrails contextual grounding; lower temp; switch to a more capable model |
| **Latency too high** | Large top_k; reranker slow; large model | Reduce top_k; cache reranker results; switch to faster model (Haiku/Nova Lite); use streaming |
| **Costs too high** | Long context; expensive model; high top_k; no caching | **Prompt caching**; smaller chunks; cheaper model for retrieval-heavy paths; semantic caching |
| **Stale results** | Vector store not refreshed | Incremental sync via S3 events → EventBridge → Lambda → KB ingest |
| **Mixed-language corpus retrieves wrong language** | Single-language embedding model | Switch to Cohere multilingual or Titan multilingual |
| **Vector search misses exact terms (product codes)** | Pure vector search | Switch to **hybrid** search |
| **Different tenants leak data to each other** | Single index without metadata filter | Per-tenant index OR strict metadata filter on tenant_id |
| **Long docs lose detail** | Flat chunking; losing structure | Hierarchical chunking, return parent context with child match |

## RAG evaluation

Tested in Domain 5; previewed here.

Two categories of metrics:

**Retrieval quality** (does the retriever find the right docs?):
- **Recall@K** - of all relevant docs, how many appear in the top-K retrievals
- **Precision@K** - of the top-K retrievals, how many are relevant
- **MRR (Mean Reciprocal Rank)** - 1 / rank of the first relevant doc
- **NDCG (Normalized Discounted Cumulative Gain)** - relevance-weighted ranking quality

**Generation quality** (given the retrieved context, is the answer correct?):
- **Faithfulness / groundedness** - response is supported by retrieved context
- **Answer relevance** - response actually addresses the question
- **Context relevance** - retrieved context actually relates to the question
- **Factual accuracy** - against ground truth

AWS-native evaluation:
- **Bedrock Knowledge Bases evaluations** - built-in evaluation jobs that score retrieval and generation quality on a labeled eval set.
- **Bedrock Model Evaluations** - automated, human, and LLM-as-judge for generation quality.
- **SageMaker Clarify** - bias detection and explainability.

LLM-as-judge pattern (commonly tested): use a strong model (Claude Opus, Nova Pro) to score outputs of a smaller production model. Cheap, scalable, correlates well with human eval if rubric is solid.

## When NOT to use RAG

- **Stable, narrow knowledge that fits entirely in the FM's context window** - just put it in the system prompt.
- **The model already knows the facts** (e.g., generic public knowledge prior to its cutoff).
- **Strict deterministic SQL-style queries** - call the database directly, don't go through an FM.
- **Real-time computations** - use code/Lambda, not RAG.
- **Personalization with structured user state** - tool calling against an API beats RAG over user records.

If a question can be answered by **fine-tuning + prompt** alone and the knowledge is stable, fine-tuning may be cheaper at high query volume.

## Quick-recall summary

- RAG = retrieval + generation; cheaper than fine-tuning, fresher knowledge, fewer hallucinations.
- Pipeline: ingestion (chunk + embed + index) → retrieval (embed query, search, rerank) → generation (assemble prompt, call FM, ground).
- **Bedrock Knowledge Bases** = managed RAG. Connectors: S3, Web Crawler, Confluence, SharePoint, Salesforce, custom.
- Chunking: default, fixed-size, **hierarchical** (parent+child), semantic, custom Lambda. Overlap 10-20%.
- Embeddings: **Titan Text v2** (256/512/1024 dim), **Titan Multimodal**, **Cohere Embed**. Same model for queries + docs.
- Vector stores: **OpenSearch Serverless** (KB default), **Aurora pgvector**, OpenSearch Service Neural plugin, DocumentDB, Neptune Analytics, Pinecone/Mongo/Redis (third-party).
- Metadata filters at retrieval = precision. Tenant isolation = per-tenant filter or per-tenant index.
- **Hybrid search > pure vector** in production.
- **Bedrock rerankers** (Amazon Rerank, Cohere Rerank) for top-K refinement.
- Query techniques: **expansion**, **decomposition**, **transformation**. Step Functions orchestrates.
- Grounding: **Bedrock Guardrails contextual grounding**, RetrieveAndGenerate citations, JSON-schema validated outputs.
- Streaming: **InvokeModelWithResponseStream** / **ConverseStream**.
- Multimodal RAG: **Bedrock Data Automation** + **Titan Multimodal Embeddings** + multimodal FM.
- Kendra-backed RAG when enterprise connectors matter and high-precision search is needed.
- Eval: **Bedrock Knowledge Bases evaluations**, **Bedrock Model Evaluations**, LLM-as-judge.
- Don't RAG when knowledge fits in the prompt or task is deterministic.
