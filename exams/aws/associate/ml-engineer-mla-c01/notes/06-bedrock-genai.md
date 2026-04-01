# Amazon Bedrock and Generative AI

**[Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)** - Managed foundation model service

## Amazon Bedrock Overview

### What is Bedrock
- Fully managed service for foundation models (FMs)
- Access models from multiple providers through a single API
- No infrastructure management required
- Pay-per-use pricing based on input/output tokens
- Serverless - no capacity planning needed

### Foundation Model Providers

**Available Models**:
- **Anthropic Claude** - text generation, analysis, coding
- **Amazon Titan** - text generation, embeddings, image generation
- **Meta Llama** - open-source text generation
- **Cohere** - text generation, embeddings, reranking
- **Stability AI** - image generation (Stable Diffusion)
- **Mistral AI** - text generation, coding

**[Model Access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html)** - Enable model access in Bedrock

### Bedrock API

**InvokeModel API**:
- Synchronous inference for single requests
- Model-specific request/response format
- Specify model ID and input parameters

**InvokeModelWithResponseStream**:
- Streaming responses for real-time generation
- Reduces time to first token
- Better user experience for chatbots

**Converse API**:
- Unified API across all text models
- Consistent message format (no model-specific formatting)
- Supports multi-turn conversations
- Recommended for new applications

**[Bedrock API](https://docs.aws.amazon.com/bedrock/latest/userguide/api-methods-run.html)** - Invoke models

## Knowledge Bases for RAG

**[Knowledge Bases](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)** - Retrieval-Augmented Generation

### RAG Architecture

**Retrieval-Augmented Generation (RAG)**:
1. **Ingest** - process documents and create embeddings
2. **Store** - save embeddings in vector database
3. **Retrieve** - find relevant documents for user query
4. **Augment** - add retrieved context to the prompt
5. **Generate** - foundation model generates response with context

### Knowledge Base Components

**Data Sources**:
- S3 buckets with documents (PDF, TXT, HTML, MD, CSV, DOCX)
- Confluence pages
- SharePoint sites
- Salesforce data
- Web crawling

**Embedding Models**:
- Amazon Titan Embeddings - general-purpose text embeddings
- Cohere Embed - multilingual embeddings
- Converts text chunks to vector representations

**Vector Stores**:
- **Amazon OpenSearch Serverless** - managed vector search
- **Amazon Aurora PostgreSQL** - with pgvector extension
- **Pinecone** - third-party vector database
- **Redis Enterprise Cloud** - in-memory vector search
- **MongoDB Atlas** - document database with vector search

### Chunking Strategies
- **Fixed-size chunking** - split by character/token count
- **Hierarchical chunking** - parent-child chunk relationships
- **Semantic chunking** - split by meaning/topic boundaries
- **No chunking** - each document is one chunk

### Knowledge Base Configuration
- Select data source and sync schedule
- Choose embedding model
- Select vector store
- Configure chunking strategy
- Define retrieval parameters (number of results, search type)

## Fine-Tuning and Customization

**[Model Customization](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)** - Customize foundation models

### Fine-Tuning
- Customize model with your own labeled data
- Training data format: JSONL with prompt-completion pairs
- Stored in S3, encrypted with KMS
- Creates a new model version (provisioned throughput required)
- Use when: need domain-specific behavior, consistent format

### Continued Pre-Training
- Train on unlabeled domain-specific data
- Teach model new domain knowledge
- Does not require labeled examples
- Use when: model needs to understand specialized terminology

### When to Fine-Tune vs RAG

**Use RAG when**:
- Need access to frequently updated information
- Want to cite sources
- Have large document collections
- Need to keep model general-purpose

**Use Fine-Tuning when**:
- Need specific output format or style
- Domain-specific language is important
- Want lower latency (no retrieval step)
- Have labeled training data

**Use Both when**:
- Need domain-specific model with current information
- Fine-tune for style, RAG for facts

## Agents for Bedrock

**[Agents for Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)** - Autonomous AI agents

### Agent Capabilities
- Orchestrate multi-step tasks autonomously
- Break down complex requests into subtasks
- Call external APIs and tools (action groups)
- Access knowledge bases for information retrieval
- Maintain conversation context

### Action Groups
- Define actions the agent can perform
- Backed by Lambda functions or API schemas
- OpenAPI schema defines available operations
- Agent decides when and how to call actions
- Example: query database, create ticket, send email

### Agent Architecture
1. User sends request to agent
2. Agent analyzes request and plans steps
3. Agent calls action groups (Lambda) as needed
4. Agent queries knowledge bases for context
5. Agent synthesizes response from all sources
6. Response returned to user

## Bedrock Guardrails

**[Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)** - Responsible AI controls

### Guardrail Types

**Content Filters**:
- Filter harmful content categories (hate, violence, sexual, etc.)
- Configurable strength: none, low, medium, high
- Applied to both input and output

**Denied Topics**:
- Define topics the model should not discuss
- Natural language topic definitions
- Example: "Do not provide financial investment advice"

**Word Filters**:
- Block specific words or phrases
- Managed word lists (profanity)
- Custom word lists

**Sensitive Information Filters**:
- Detect and mask PII (names, emails, phone numbers, SSN)
- Regex-based custom patterns
- Options: block or mask sensitive data

**Contextual Grounding**:
- Check if responses are grounded in provided context
- Reduce hallucinations by verifying against source documents
- Configurable grounding threshold

### Guardrail Configuration
- Create guardrail with desired policies
- Associate with Bedrock model or agent
- Applied automatically to all requests
- Monitor blocked requests via CloudWatch

## Bedrock Security

### Access Control
- IAM policies for Bedrock API access
- Model access management (enable/disable per model)
- VPC endpoints for private API access
- Resource-based policies for cross-account access

### Data Privacy
- Customer data not used to train foundation models
- Data encrypted in transit (TLS) and at rest (KMS)
- Fine-tuning data stored in your S3 bucket
- Knowledge base data stays in your account
- CloudTrail logging for all API calls

### Compliance
- Bedrock is HIPAA-eligible
- SOC 1, SOC 2, SOC 3 compliant
- ISO 27001, 27017, 27018 certified
- Data processing agreement available

## Bedrock vs SageMaker for ML

### Use Amazon Bedrock When
- Need foundation model capabilities (text generation, embeddings)
- Building conversational AI or RAG applications
- Want serverless, no infrastructure management
- Need quick deployment of GenAI features

### Use SageMaker When
- Training custom ML models from scratch
- Need full control over model architecture
- Working with tabular data, computer vision, or time series
- Need advanced MLOps and pipeline automation
- Require custom inference logic

### Use Both When
- SageMaker for custom models (classification, regression)
- Bedrock for generative AI features (summarization, chatbot)
- SageMaker Pipelines orchestrating both custom and FM workflows

## Key Takeaways

1. **Bedrock** - managed foundation model service, no infrastructure needed
2. **Converse API** - unified API for all text models (recommended for new apps)
3. **Knowledge Bases** - RAG with vector search for grounded responses
4. **Chunking** - strategy affects retrieval quality (fixed, hierarchical, semantic)
5. **Fine-tuning** - customize model behavior with labeled data
6. **RAG vs Fine-tuning** - RAG for facts, fine-tuning for style, both for best results
7. **Agents** - autonomous multi-step task execution with action groups
8. **Guardrails** - content filtering, topic blocking, PII masking, grounding checks
9. **Security** - customer data not used for training, encrypted, IAM-controlled
10. **Bedrock vs SageMaker** - Bedrock for GenAI, SageMaker for custom ML
