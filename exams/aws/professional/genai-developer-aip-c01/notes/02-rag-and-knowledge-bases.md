# RAG Patterns, Vector Databases, and Amazon Bedrock Knowledge Bases

**📖 [Bedrock Knowledge Bases Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)** - Complete guide to managed RAG on AWS

## 📋 Retrieval Augmented Generation (RAG)

### What Is RAG?

Retrieval Augmented Generation (RAG) is an architecture pattern that enhances foundation model responses by retrieving relevant information from external knowledge sources before generating a response. This grounds the model's output in factual, up-to-date data.

**📖 [RAG on AWS](https://aws.amazon.com/what-is/retrieval-augmented-generation/)** - Understanding RAG architecture

**Why Use RAG?**
- **Reduces hallucinations** - Grounds responses in retrieved factual data
- **Keeps information current** - No need to retrain the model for new data
- **Domain-specific knowledge** - Augment with proprietary documents
- **Cost-effective** - Cheaper than fine-tuning for knowledge updates
- **Auditable** - Can trace answers back to source documents
- **Data privacy** - Knowledge stays in your environment

### RAG Architecture Flow

```
1. User submits a query
   ↓
2. Query is converted to an embedding vector (embedding model)
   ↓
3. Vector similarity search finds relevant document chunks (vector store)
   ↓
4. Retrieved chunks are combined with the original query (augmentation)
   ↓
5. Augmented prompt is sent to the foundation model (generation)
   ↓
6. Model generates a grounded response with context
```

### RAG vs Fine-Tuning

| Aspect | RAG | Fine-Tuning |
|--------|-----|-------------|
| **Knowledge Updates** | Add documents to vector store (minutes) | Retrain model (hours/days) |
| **Cost** | Lower (no training compute) | Higher (GPU training costs) |
| **Freshness** | Always current with latest documents | Static until retrained |
| **Accuracy** | Grounded in source documents | Learned from training data |
| **Use Case** | Dynamic knowledge, Q&A, search | Domain adaptation, style/behavior |
| **Traceability** | Can cite source documents | No direct source attribution |
| **Data Volume** | Works with any amount | Needs sufficient training examples |

## 🎯 Amazon Bedrock Knowledge Bases

**📖 [Creating a Knowledge Base](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-create.html)** - Step-by-step setup guide

### Architecture Overview

```
Data Sources (S3, Web Crawler, Confluence, SharePoint)
  ↓ (ingestion)
Document Processing (chunking, preprocessing)
  ↓
Embedding Generation (Titan Embeddings, Cohere Embed)
  ↓
Vector Store (OpenSearch Serverless, Pinecone, Redis, Aurora PostgreSQL)
  ↓
At Query Time:
User Query → Embedding → Vector Search → Retrieved Chunks → FM → Response
```

### Key Components

**Data Sources:**
- **Amazon S3** - Documents stored in S3 buckets (PDF, TXT, MD, HTML, CSV, DOCX, XLS)
- **Web Crawler** - Crawl web pages for knowledge ingestion
- **Confluence** - Enterprise wiki and documentation
- **SharePoint** - Microsoft document management
- **Salesforce** - CRM data and knowledge articles

**📖 [Data Source Configuration](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-ds.html)** - Supported data sources

**Supported File Types:**
- PDF, TXT, MD, HTML, DOC/DOCX, CSV, XLS/XLSX
- Maximum file size: 50 MB per document
- Documents must be in supported formats for automatic parsing

### Document Chunking Strategies

**📖 [Chunking Configurations](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-chunking.html)** - Chunking options

| Strategy | Description | Best For |
|----------|-------------|----------|
| **Default** | Automatic chunking by Bedrock (300 tokens, 20% overlap) | General use, quick setup |
| **Fixed-Size** | Split by token count with configurable overlap | Uniform documents |
| **Hierarchical** | Parent-child chunks for multi-level retrieval | Long documents with structure |
| **Semantic** | Split by meaning/topic boundaries | Documents with varied topics |
| **No Chunking** | Treat each file as a single chunk | Short documents, FAQs |

**Chunking Best Practices:**
- **Overlap** - Include 10-20% overlap between chunks to preserve context at boundaries
- **Chunk Size** - Balance between context richness (larger) and retrieval precision (smaller)
- **Metadata** - Attach metadata to chunks for filtering (source, date, category)
- **Preprocessing** - Clean documents before ingestion (remove headers, footers, noise)

### Vector Store Options

**📖 [Vector Store Configuration](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html)** - Supported vector databases

| Vector Store | Type | Key Features |
|-------------|------|--------------|
| **Amazon OpenSearch Serverless** | AWS Managed | k-NN search, serverless scaling, hybrid search |
| **Amazon Aurora PostgreSQL** | AWS Managed | pgvector extension, relational + vector |
| **Pinecone** | Third-party | Purpose-built vector DB, fast similarity search |
| **Redis Enterprise** | Third-party | In-memory vector search, low latency |
| **MongoDB Atlas** | Third-party | Document store with vector search |

**OpenSearch Serverless for Vector Search:**

**📖 [OpenSearch Serverless](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless.html)** - Managed vector search

- **k-NN Plugin** - k-nearest neighbor vector similarity search
- **HNSW Algorithm** - Hierarchical Navigable Small World for approximate nearest neighbor
- **Hybrid Search** - Combine keyword (BM25) and semantic (vector) search
- **Auto-scaling** - Compute and storage scale independently
- **Collection Types** - Search, Time Series, Vector Search

```python
# Example: OpenSearch Serverless k-NN query
query = {
    "size": 5,
    "query": {
        "knn": {
            "embedding_vector": {
                "vector": query_embedding,
                "k": 5
            }
        }
    }
}
```

## 📚 Embeddings Deep Dive

### What Are Embeddings?

Embeddings are dense numerical vectors that capture the semantic meaning of text. Similar meanings produce similar vectors, enabling semantic search.

**📖 [Titan Embeddings](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-embedding-models.html)** - Amazon's embedding models

**Key Properties:**
- **Dimensionality** - Number of values in the vector (e.g., 256, 512, 1024, 1536)
- **Similarity Metrics** - Cosine similarity, dot product, Euclidean distance
- **Normalization** - Vectors normalized to unit length for cosine similarity

### Embedding Models on Bedrock

| Model | Dimensions | Max Tokens | Best For |
|-------|-----------|------------|----------|
| **Titan Embeddings V2** | 256, 512, 1024 | 8,192 | General RAG, configurable dimensions |
| **Titan Embeddings V1** | 1,536 | 8,192 | General RAG, high-dimensional |
| **Titan Multimodal Embeddings** | 256, 512, 1024 | Text + Image | Multimodal search (text + images) |
| **Cohere Embed English** | 1,024 | 512 | English-specific RAG |
| **Cohere Embed Multilingual** | 1,024 | 512 | Multilingual RAG |

### Generating Embeddings

```python
import boto3
import json

bedrock_runtime = boto3.client('bedrock-runtime')

# Generate embedding with Titan Embeddings V2
response = bedrock_runtime.invoke_model(
    modelId='amazon.titan-embed-text-v2:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "inputText": "Amazon Bedrock provides access to foundation models.",
        "dimensions": 1024,
        "normalize": True
    })
)

result = json.loads(response['body'].read())
embedding_vector = result['embedding']  # List of 1024 floats
```

### Vector Similarity Search

**Distance Metrics:**

| Metric | Formula | Best For |
|--------|---------|----------|
| **Cosine Similarity** | cos(A, B) = A·B / (‖A‖ × ‖B‖) | Normalized text embeddings |
| **Dot Product** | A·B = Σ(ai × bi) | Pre-normalized vectors |
| **Euclidean (L2)** | √(Σ(ai - bi)²) | Dense, non-normalized vectors |

**Cosine similarity is the most common** for text embeddings because it measures directional similarity regardless of vector magnitude.

## 🎯 Building RAG Applications

### Using Bedrock Knowledge Bases API

**📖 [RetrieveAndGenerate API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_RetrieveAndGenerate.html)** - Combined retrieval and generation

```python
import boto3

bedrock_agent_runtime = boto3.client('bedrock-agent-runtime')

# RetrieveAndGenerate - One-step RAG
response = bedrock_agent_runtime.retrieve_and_generate(
    input={
        "text": "What is Amazon Bedrock's pricing model?"
    },
    retrieveAndGenerateConfiguration={
        "type": "KNOWLEDGE_BASE",
        "knowledgeBaseConfiguration": {
            "knowledgeBaseId": "KNOWLEDGE_BASE_ID",
            "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
            "retrievalConfiguration": {
                "vectorSearchConfiguration": {
                    "numberOfResults": 5
                }
            }
        }
    }
)

# Response includes generated answer and source citations
answer = response['output']['text']
citations = response['citations']  # Source document references
```

### Retrieve API (Retrieval Only)

**📖 [Retrieve API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_Retrieve.html)** - Retrieval without generation

```python
# Retrieve - Get relevant chunks without generation
response = bedrock_agent_runtime.retrieve(
    knowledgeBaseId="KNOWLEDGE_BASE_ID",
    retrievalQuery={
        "text": "What are the supported vector stores?"
    },
    retrievalConfiguration={
        "vectorSearchConfiguration": {
            "numberOfResults": 10
        }
    }
)

# Process retrieved chunks
for result in response['retrievalResults']:
    content = result['content']['text']
    score = result['score']
    source = result['location']
    metadata = result.get('metadata', {})
    print(f"Score: {score:.4f} | Source: {source}")
    print(f"Content: {content[:200]}...")
```

### Custom RAG Implementation

For more control, build RAG without Knowledge Bases:

```python
import boto3
import json
from opensearchpy import OpenSearch

# Step 1: Generate query embedding
bedrock_runtime = boto3.client('bedrock-runtime')
query = "How does Amazon Bedrock pricing work?"

embed_response = bedrock_runtime.invoke_model(
    modelId='amazon.titan-embed-text-v2:0',
    body=json.dumps({"inputText": query, "dimensions": 1024, "normalize": True})
)
query_embedding = json.loads(embed_response['body'].read())['embedding']

# Step 2: Search vector store
opensearch_client = OpenSearch(
    hosts=[{'host': 'your-opensearch-endpoint', 'port': 443}],
    use_ssl=True
)

search_response = opensearch_client.search(
    index='knowledge-base-index',
    body={
        "size": 5,
        "query": {
            "knn": {
                "embedding": {
                    "vector": query_embedding,
                    "k": 5
                }
            }
        }
    }
)

# Step 3: Build augmented prompt
context_chunks = [hit['_source']['text'] for hit in search_response['hits']['hits']]
augmented_prompt = f"""Based on the following context, answer the question.

Context:
{chr(10).join(context_chunks)}

Question: {query}

Answer:"""

# Step 4: Generate response with context
gen_response = bedrock_runtime.invoke_model(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "messages": [{"role": "user", "content": augmented_prompt}]
    })
)

answer = json.loads(gen_response['body'].read())['content'][0]['text']
```

## 📋 Amazon Kendra for Enterprise Search

**📖 [Amazon Kendra Documentation](https://docs.aws.amazon.com/kendra/latest/dg/)** - Intelligent enterprise search

### Kendra vs OpenSearch for RAG

| Feature | Amazon Kendra | Amazon OpenSearch |
|---------|--------------|-------------------|
| **Search Type** | NLU-based intelligent search | Keyword + vector (k-NN) search |
| **Setup** | Pre-built connectors, low code | More configuration required |
| **Data Sources** | 30+ built-in connectors | Custom ingestion pipeline |
| **Best For** | Enterprise search, FAQ, document Q&A | Custom RAG, high-volume vector search |
| **Cost** | Higher (enterprise pricing) | Lower (pay for compute/storage) |
| **Ranking** | ML-based relevance ranking | BM25 + vector similarity |

### Kendra Features for GenAI
- **Natural Language Queries** - Understands questions in natural language
- **Document Connectors** - S3, SharePoint, Salesforce, ServiceNow, databases, and more
- **FAQ Extraction** - Automatically extract and rank FAQ pairs
- **Relevance Tuning** - Boost or bury results by field, source, or freshness
- **Access Control** - Document-level security based on user identity

## 🎯 RAG Optimization Techniques

### Retrieval Quality Improvement

**Chunking Optimization:**
- Test different chunk sizes (100-1000 tokens) for your content
- Use semantic chunking for documents with varied topics
- Add overlap (10-20%) to preserve context at chunk boundaries
- Include metadata (title, section, date) with chunks for filtering

**Query Enhancement:**
- **Query Rewriting** - Rephrase queries for better retrieval
- **Hypothetical Document Embeddings (HyDE)** - Generate a hypothetical answer, then search for similar content
- **Multi-Query** - Generate multiple query variations and combine results
- **Query Decomposition** - Break complex queries into sub-queries

**Retrieval Strategies:**
- **Hybrid Search** - Combine keyword (BM25) and semantic (vector) search
- **Re-ranking** - Apply a cross-encoder to re-rank retrieved results
- **Metadata Filtering** - Filter by document source, date, category before search
- **Maximum Marginal Relevance (MMR)** - Diversify retrieved results

### Response Quality Improvement

**Prompt Engineering for RAG:**
```
System: You are a helpful assistant that answers questions based on provided context.
If the context does not contain enough information, say "I don't have enough
information to answer this question." Always cite the source document.

Context:
{retrieved_chunks}

Question: {user_question}

Instructions:
1. Answer based ONLY on the provided context
2. Cite source documents in your answer
3. If unsure, acknowledge the limitation
```

**Grounding Techniques:**
- Instruct the model to only use provided context
- Request citations and source attribution
- Use Bedrock Guardrails contextual grounding checks
- Implement answer verification against source documents

## Exam Tips

### Key Concepts to Remember
- RAG = Retrieval + Augmentation + Generation (three distinct steps)
- Bedrock Knowledge Bases is the managed RAG solution (prefer over custom)
- RetrieveAndGenerate API = one-step RAG (retrieval + generation combined)
- Retrieve API = retrieval only (for custom generation logic)
- Titan Embeddings V2 supports configurable dimensions (256, 512, 1024)
- OpenSearch Serverless with k-NN is the default vector store for Knowledge Bases
- Chunking strategy significantly impacts retrieval quality
- Hybrid search (keyword + semantic) often outperforms pure vector search
- Cosine similarity is the standard metric for text embedding comparison

### Common Exam Traps
- ❌ Using fine-tuning when RAG is more appropriate for knowledge updates
- ❌ Ignoring chunking configuration (default may not be optimal)
- ❌ Not considering metadata filtering for large knowledge bases
- ❌ Choosing Kendra when OpenSearch Serverless is more cost-effective
- ❌ Forgetting that embeddings model must match between indexing and querying
- ❌ Overlooking the Retrieve API when custom generation logic is needed
