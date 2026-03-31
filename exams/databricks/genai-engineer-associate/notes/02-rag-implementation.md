# RAG Application Implementation - Databricks GenAI Engineer Associate

## Overview

This section covers implementing RAG applications on Databricks, representing 30% of the exam. You need to master Vector Search, Foundation Model APIs, Mosaic AI Agent Framework, and LangChain integration.

**[📖 Vector Search](https://docs.databricks.com/en/generative-ai/create-query-vector-search.html)** - Vector index management
**[📖 Agent Framework](https://docs.databricks.com/en/generative-ai/agent-framework/index.html)** - Building AI agents

## Key Topics

### 1. Databricks Vector Search

**[📖 Vector Search Setup](https://docs.databricks.com/en/generative-ai/vector-search.html)** - Configuration guide

**Index Types:**
| Type | Description | Embedding Management |
|------|-------------|---------------------|
| Delta Sync Index | Auto-syncs from Delta table | Managed or pre-computed |
| Direct Vector Access Index | Manually manage embeddings | You provide embeddings |

**Delta Sync Index Modes:**
| Mode | Behavior | Use Case |
|------|----------|----------|
| Triggered | Sync on demand | Batch updates |
| Continuous | Real-time sync as Delta table changes | Always up-to-date |

```python
from databricks.vector_search.client import VectorSearchClient

vsc = VectorSearchClient()

# Create a Delta Sync index with managed embeddings
index = vsc.create_delta_sync_index(
    endpoint_name="vs_endpoint",
    source_table_name="catalog.schema.chunks",
    index_name="catalog.schema.chunks_index",
    pipeline_type="TRIGGERED",
    primary_key="chunk_id",
    embedding_source_column_name="text",
    embedding_model_endpoint_name="databricks-bge-large-en"
)

# Query the index
results = index.similarity_search(
    query_text="What is Delta Lake?",
    columns=["text", "source", "title"],
    num_results=5
)
```

**Key Concepts:**
- Vector Search endpoint serves the index for low-latency queries
- Delta Sync with compute embeddings: Vector Search generates embeddings automatically
- Delta Sync with pre-computed embeddings: you provide an embedding column
- Direct Vector Access: full control over embedding computation and updates
- Filter support: combine vector similarity with column-level metadata filters

### 2. Foundation Model APIs

**[📖 Pay-per-Token](https://docs.databricks.com/en/machine-learning/foundation-models/deploy-ppt-models.html)** - Shared compute
**[📖 Provisioned Throughput](https://docs.databricks.com/en/machine-learning/foundation-models/deploy-provisioned-throughput-foundation-models.html)** - Dedicated compute

| Serving Type | Compute | Latency | Cost Model |
|-------------|---------|---------|------------|
| Pay-per-token | Shared | Variable | Per token used |
| Provisioned throughput | Dedicated | Consistent | Per compute unit |

**[📖 External Models](https://docs.databricks.com/en/generative-ai/external-models/index.html)** - Third-party model access

```python
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()

# Query a foundation model
response = w.serving_endpoints.query(
    name="databricks-meta-llama-3-1-70b-instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is RAG?"}
    ],
    temperature=0.1,
    max_tokens=500
)
```

**Key Concepts:**
- Databricks hosts popular open models (Llama, Mixtral, DBRX)
- External model endpoints proxy to third-party APIs (OpenAI, Anthropic, Google)
- Unified API provides consistent interface regardless of model provider
- Temperature controls randomness (0 = deterministic, 1 = creative)
- Max tokens limits response length

### 3. Mosaic AI Agent Framework

**[📖 Agent Framework](https://docs.databricks.com/en/generative-ai/agent-framework/index.html)** - Building agents
**[📖 Agent Deployment](https://docs.databricks.com/en/generative-ai/agent-framework/deploy-agent.html)** - Deploying agents

**Key Concepts:**
- Framework for building compound AI systems (RAG, agents with tools)
- Supports LangChain, custom pyfunc, and code-based agent implementations
- Agents can use tools: Vector Search retrieval, SQL queries, Python code execution
- MLflow integration for logging, tracing, and deploying agents
- `mlflow.models.set_model()` registers the chain/agent for deployment
- Playground UI for interactive testing before deployment

### 4. LangChain on Databricks

**[📖 LangChain Integration](https://docs.databricks.com/en/generative-ai/agent-framework/langchain.html)** - LangChain on Databricks

```python
from langchain_community.chat_models import ChatDatabricks
from langchain_community.vectorstores import DatabricksVectorSearch
from langchain_community.embeddings import DatabricksEmbeddings
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough

# Components
embeddings = DatabricksEmbeddings(endpoint="databricks-bge-large-en")
llm = ChatDatabricks(endpoint="databricks-meta-llama-3-1-70b-instruct", temperature=0.1)
retriever = DatabricksVectorSearch(index, text_column="text").as_retriever(
    search_kwargs={"k": 5}
)

# RAG chain
prompt = ChatPromptTemplate.from_template("""
Answer based on the following context:
{context}

Question: {question}
""")

chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | llm
)

# Query
response = chain.invoke("What is Delta Lake?")
```

**Key Concepts:**
- `ChatDatabricks`: LangChain chat model wrapper for Databricks endpoints
- `DatabricksVectorSearch`: LangChain retriever for Vector Search indexes
- `DatabricksEmbeddings`: LangChain embeddings wrapper
- Chain construction: retriever -> prompt template -> LLM -> output
- Memory management for conversational RAG (chat history)

### 5. MLflow for GenAI

**[📖 MLflow Tracing](https://docs.databricks.com/en/mlflow/llm-tracing.html)** - LLM observability

```python
import mlflow

# Enable autologging for LangChain
mlflow.langchain.autolog()

# Log chain as MLflow model
with mlflow.start_run():
    mlflow.langchain.log_model(chain, "rag_chain",
        input_example={"question": "What is Delta Lake?"})
```

**Key Concepts:**
- MLflow Tracing records every LLM call for debugging and monitoring
- `mlflow.langchain.autolog()` automatically traces LangChain calls
- Log chains as MLflow models for versioning and deployment
- Model signatures define input/output schemas
- Experiment tracking for prompt engineering iterations

## Exam Tips for This Domain

1. **Delta Sync vs Direct Vector Access** - Know when to use each index type
2. **Triggered vs Continuous sync** - Tradeoff between freshness and cost
3. **Pay-per-token vs provisioned throughput** - Variable vs consistent latency
4. **LangChain components** - ChatDatabricks, DatabricksVectorSearch, DatabricksEmbeddings
5. **Agent Framework** - Know how to build, log, and deploy agents
6. **MLflow Tracing** - Debugging and monitoring LLM applications

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Vector Search | [docs.databricks.com/en/generative-ai/vector-search.html](https://docs.databricks.com/en/generative-ai/vector-search.html) |
| Create/Query Index | [docs.databricks.com/en/generative-ai/create-query-vector-search.html](https://docs.databricks.com/en/generative-ai/create-query-vector-search.html) |
| Foundation Models | [docs.databricks.com/en/machine-learning/foundation-models/index.html](https://docs.databricks.com/en/machine-learning/foundation-models/index.html) |
| Agent Framework | [docs.databricks.com/en/generative-ai/agent-framework/index.html](https://docs.databricks.com/en/generative-ai/agent-framework/index.html) |
| LangChain | [docs.databricks.com/en/generative-ai/agent-framework/langchain.html](https://docs.databricks.com/en/generative-ai/agent-framework/langchain.html) |
| MLflow Tracing | [docs.databricks.com/en/mlflow/llm-tracing.html](https://docs.databricks.com/en/mlflow/llm-tracing.html) |
