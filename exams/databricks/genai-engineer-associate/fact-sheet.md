# Databricks Generative AI Engineer Associate - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Generative AI Engineer Associate
**Duration:** 90 minutes
**Questions:** 45 multiple-choice questions
**Passing Score:** 70% (approximately 32 correct)
**Cost:** $200 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/genai-engineer-associate)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - GenAI learning paths
**[📖 Generative AI Documentation](https://docs.databricks.com/en/generative-ai/index.html)** - GenAI on Databricks

## Target Audience

This certification is designed for:
- Engineers building RAG applications on Databricks
- Data scientists working with LLMs and generative AI
- ML engineers implementing GenAI production systems
- Developers integrating LLMs into data workflows
- Professionals familiar with Databricks and Python

## Domain 1: RAG Application Design (30%)

### RAG Architecture

**[📖 RAG Overview](https://docs.databricks.com/en/generative-ai/retrieval-augmented-generation.html)** - RAG on Databricks
**[📖 AI Cookbook](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/index.html)** - RAG tutorial
**[📖 Vector Search](https://docs.databricks.com/en/generative-ai/vector-search.html)** - Vector database

**Key Facts:**
- RAG combines retrieval from a knowledge base with LLM generation
- RAG reduces hallucination by grounding responses in retrieved documents
- RAG architecture components:
  1. Document processing pipeline (ingest, chunk, embed)
  2. Vector store (index and search embeddings)
  3. Retriever (find relevant documents for a query)
  4. Generator (LLM produces answer using retrieved context)
- RAG vs fine-tuning:
  - RAG: use when knowledge changes frequently, no training needed
  - Fine-tuning: use when you need to change model behavior/style
  - Prompt engineering: use for simple instruction-following tasks

### Chunking Strategies

**[📖 Document Processing](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/quality-iteration/chunking.html)** - Chunking approaches

**Key Facts:**
- Fixed-size chunking: split by character/token count (simple, fast)
- Recursive character splitting: split by separators hierarchically
- Semantic chunking: split by meaning boundaries
- Document-aware chunking: respect document structure (headers, paragraphs)
- Chunk size considerations:
  - Smaller chunks: more precise retrieval, may lose context
  - Larger chunks: more context, may include irrelevant information
  - Typical range: 256-1024 tokens
- Chunk overlap: 10-20% overlap prevents losing context at boundaries
- Metadata enrichment: add source, title, section to each chunk

### Embedding Models

**[📖 Foundation Model APIs](https://docs.databricks.com/en/machine-learning/foundation-models/index.html)** - Model serving
**[📖 External Models](https://docs.databricks.com/en/generative-ai/external-models/index.html)** - Third-party model access

**Key Facts:**
- Embedding models convert text to dense vector representations
- Databricks-hosted embedding models (e.g., BGE, GTE)
- External model endpoints (OpenAI, Cohere embeddings)
- Embedding dimensions affect storage and retrieval performance
- Similarity metrics: cosine similarity, dot product, Euclidean distance
- Embedding model selection: domain relevance, dimension size, latency

### Retrieval Strategies

**Key Facts:**
- Similarity search: find nearest vectors to query embedding
- Maximum Marginal Relevance (MMR): balance relevance and diversity
- Filtered search: combine vector similarity with metadata filters
- Hybrid search: combine dense (vector) and sparse (keyword) retrieval
- Re-ranking: use a cross-encoder to re-score retrieved documents
- Top-k selection: number of documents to retrieve (typically 3-10)
- Multi-query retrieval: generate multiple query variations for better recall

## Domain 2: RAG Application Implementation (30%)

### Databricks Vector Search

**[📖 Vector Search Setup](https://docs.databricks.com/en/generative-ai/vector-search.html)** - Configuration guide
**[📖 Vector Search Index](https://docs.databricks.com/en/generative-ai/create-query-vector-search.html)** - Creating indexes
**[📖 Query Vector Search](https://docs.databricks.com/en/generative-ai/create-query-vector-search.html#query)** - Querying indexes

**Key Facts:**
- Vector Search is a managed vector database service on Databricks
- Two index types:
  - Delta Sync Index: automatically syncs from a Delta table (managed embeddings)
  - Direct Vector Access Index: manually manage embeddings (more control)
- Delta Sync Index modes:
  - Triggered: sync on demand
  - Continuous: real-time sync as Delta table changes
- Embedding source:
  - Compute embeddings: Vector Search computes embeddings using specified model
  - Use pre-computed embeddings: provide your own embedding column
- Vector Search endpoint: serves the index for low-latency queries
- Query with `similarity_search()` or REST API
- Filter support: combine vector search with column filters

### Foundation Model APIs

**[📖 Foundation Models](https://docs.databricks.com/en/machine-learning/foundation-models/index.html)** - Model serving overview
**[📖 Pay-per-Token](https://docs.databricks.com/en/machine-learning/foundation-models/deploy-ppt-models.html)** - Pay-per-token models
**[📖 Provisioned Throughput](https://docs.databricks.com/en/machine-learning/foundation-models/deploy-provisioned-throughput-foundation-models.html)** - Dedicated capacity

**Key Facts:**
- Pay-per-token: shared compute, pay for tokens used (variable latency)
- Provisioned throughput: dedicated compute, guaranteed throughput (consistent latency)
- Available models: DBRX, Llama (Meta), Mixtral, and more
- External model endpoints: proxy to OpenAI, Anthropic, Google, etc.
- Unified API: consistent interface regardless of model provider
- Token limits: model-specific context window sizes
- Temperature: controls randomness (0 = deterministic, 1 = creative)
- Top-p (nucleus sampling): probability threshold for token selection

### Mosaic AI Agent Framework

**[📖 Agent Framework](https://docs.databricks.com/en/generative-ai/agent-framework/index.html)** - Building AI agents
**[📖 Agent Deployment](https://docs.databricks.com/en/generative-ai/agent-framework/deploy-agent.html)** - Deploying agents

**Key Facts:**
- Agent Framework for building compound AI systems
- Supports LangChain, custom pyfunc, and code-based agents
- Agents can use tools: Vector Search, SQL, Python code execution
- Chain components: retriever, LLM, tools, memory
- Agent deployment to Model Serving endpoints
- MLflow integration for logging and tracing agents
- `mlflow.models.set_model()` to register the chain
- Playground UI for testing agents interactively

### LangChain on Databricks

**[📖 LangChain Integration](https://docs.databricks.com/en/generative-ai/agent-framework/langchain.html)** - LangChain on Databricks

**Key Facts:**
- LangChain provides building blocks for LLM applications
- `ChatDatabricks`: LangChain chat model for Databricks endpoints
- `DatabricksVectorSearch`: LangChain retriever for Vector Search
- `DatabricksEmbeddings`: LangChain embeddings wrapper
- Chain construction: prompt template -> LLM -> output parser
- RAG chain: retriever -> prompt with context -> LLM
- Memory management for conversational RAG

### MLflow for GenAI

**[📖 MLflow Tracing](https://docs.databricks.com/en/mlflow/llm-tracing.html)** - LLM observability
**[📖 MLflow GenAI](https://docs.databricks.com/en/mlflow/log-model.html)** - Logging GenAI models

**Key Facts:**
- MLflow Tracing: traces LLM calls for debugging and monitoring
- `mlflow.langchain.autolog()` auto-traces LangChain calls
- Log chains as MLflow models for deployment
- Model signatures for GenAI: input/output schema definition
- Artifact logging for prompts, configs, and evaluation data
- Experiment tracking for prompt engineering iterations

## Domain 3: Governance and Evaluation (20%)

### RAG Evaluation

**[📖 Agent Evaluation](https://docs.databricks.com/en/generative-ai/agent-evaluation/index.html)** - Evaluation framework
**[📖 MLflow Evaluate](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html)** - LLM evaluation

**Key Facts:**
- Evaluation dimensions:
  - Retrieval quality: are the right documents retrieved?
  - Answer relevance: does the answer address the question?
  - Faithfulness/groundedness: is the answer supported by retrieved context?
  - Answer correctness: is the answer factually correct?
- Mosaic AI Agent Evaluation:
  - Automated evaluation with LLM-as-judge
  - Human evaluation workflows
  - Evaluation datasets with ground truth
  - Per-request quality scores
- `mlflow.evaluate()` with GenAI metrics
- Evaluation metrics: answer_correctness, faithfulness, relevance
- Custom evaluation metrics for domain-specific quality
- Evaluation harness: standardized testing across model versions

### Governance for GenAI

**[📖 AI Governance](https://docs.databricks.com/en/generative-ai/governance.html)** - GenAI governance
**[📖 Unity Catalog Models](https://docs.databricks.com/en/mlflow/models-in-uc.html)** - Model governance

**Key Facts:**
- Unity Catalog for model and data governance
- PII detection and handling in training data
- Guardrails: input/output filtering for safety
- Content filtering: block harmful or inappropriate content
- Data lineage for GenAI: track data used in embeddings
- Cost management: monitor token usage and compute costs
- Compliance: audit logging for GenAI requests
- Inference table logging: capture all requests and responses
- Data retention policies for inference logs

## Domain 4: LLM Fundamentals (20%)

### Transformer Architecture

**[📖 Foundation Models Overview](https://docs.databricks.com/en/machine-learning/foundation-models/index.html)** - Available models

**Key Facts:**
- Transformers use self-attention mechanism
- Tokens: text is split into subword units (tokenization)
- Context window: maximum number of tokens a model can process
- Attention: allows model to focus on relevant parts of input
- Encoder-only: BERT-style (good for classification, embeddings)
- Decoder-only: GPT-style (good for generation)
- Encoder-decoder: T5-style (good for translation, summarization)

### Generation Parameters

**Key Facts:**
- Temperature: controls randomness of output
  - 0: deterministic (greedy decoding)
  - 0.1-0.3: focused, factual responses
  - 0.7-1.0: creative, diverse responses
- Top-p (nucleus sampling): cumulative probability threshold
- Top-k: limit sampling to top-k most likely tokens
- Max tokens: maximum length of generated response
- Stop sequences: tokens that signal generation completion
- Frequency penalty: reduce repetition of tokens
- Presence penalty: encourage diversity of topics

### Prompt Engineering

**[📖 Prompt Engineering](https://docs.databricks.com/en/generative-ai/prompt-engineering.html)** - Prompt techniques

**Key Facts:**
- System prompt: defines the model's role and behavior
- Zero-shot: no examples provided
- Few-shot: provide examples of desired input-output pairs
- Chain-of-thought: instruct model to reason step-by-step
- Retrieval-augmented prompts: include retrieved context in prompt
- Prompt template variables: dynamically insert context and queries
- Output formatting: instruct model to respond in specific format (JSON, etc.)
- Prompt injection awareness: sanitize user inputs

### Model Selection

**Key Facts:**
- Model size vs quality tradeoff: larger models generally better but slower/costlier
- Latency requirements drive model selection
- Cost per token varies significantly between models
- Open-source models (Llama, Mixtral): more control, self-hosted
- Proprietary models (GPT-4, Claude): typically higher quality, API-based
- Domain-specific fine-tuned models for specialized tasks
- DBRX: Databricks' open-source foundation model
- Benchmark evaluation: MMLU, HellaSwag, etc. for model comparison

## Exam Tips

1. **RAG is 60% of the exam** - master both design and implementation
2. **Vector Search** - know Delta Sync vs Direct Vector Access Index deeply
3. **Chunking strategy selection** - understand tradeoffs for different approaches
4. **Foundation Model APIs** - pay-per-token vs provisioned throughput
5. **Agent Framework** - know how to build and deploy agents
6. **Evaluation metrics** - faithfulness, relevance, groundedness
7. **LLM-as-judge** - understand automated evaluation patterns
8. **Prompt engineering** - practical techniques for RAG systems
9. **Governance** - PII handling, guardrails, cost management
10. **Hands-on practice** - build at least one RAG app on Databricks

## Quick Reference

### Essential Code Patterns
```python
# Vector Search Index Creation
from databricks.vector_search.client import VectorSearchClient
vsc = VectorSearchClient()
index = vsc.create_delta_sync_index(
    endpoint_name="vs_endpoint",
    source_table_name="catalog.schema.chunks",
    index_name="catalog.schema.chunks_index",
    pipeline_type="TRIGGERED",
    primary_key="chunk_id",
    embedding_source_column_name="text",
    embedding_model_endpoint_name="databricks-bge-large-en"
)

# Query Vector Search
results = index.similarity_search(
    query_text="What is Delta Lake?",
    columns=["text", "source"],
    num_results=5
)

# Foundation Model API
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()
response = w.serving_endpoints.query(
    name="databricks-meta-llama-3-1-70b-instruct",
    messages=[{"role": "user", "content": "What is RAG?"}],
    temperature=0.1,
    max_tokens=500
)

# LangChain RAG Chain
from langchain_community.chat_models import ChatDatabricks
from langchain_community.vectorstores import DatabricksVectorSearch
retriever = DatabricksVectorSearch(index, text_column="text").as_retriever()
llm = ChatDatabricks(endpoint="databricks-meta-llama-3-1-70b-instruct")

# Agent Evaluation
import mlflow
results = mlflow.evaluate(
    model=rag_chain,
    data=eval_dataset,
    model_type="databricks-agent"
)
```
