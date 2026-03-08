# AWS Certified Generative AI Developer - Professional (AIP-C01) - Fact Sheet

## Quick Reference

**Exam Code:** AIP-C01
**Duration:** 170 minutes (2 hours 50 minutes)
**Questions:** 65 questions
**Passing Score:** 750/1000 (estimated ~72%)
**Cost:** $300 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (Testing center or online proctored)
**Difficulty:** ⭐⭐⭐⭐⭐ (Professional-level)
**Prerequisites:** Recommended 2+ years hands-on experience with generative AI on AWS

## Exam Domain Breakdown

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Selection and Implementation of Foundation Models | 26% | Evaluate, select, and configure FMs for specific use cases |
| Generative AI Application Development | 30% | Build apps with Amazon Bedrock, RAG patterns, agents |
| Optimization and Evaluation of Generative AI Solutions | 24% | Fine-tuning, prompt engineering, evaluation metrics, responsible AI |
| Security, Compliance, and Governance | 20% | Secure GenAI apps, data privacy, model governance, cost optimization |

## Core Generative AI Services by Domain

### Domain 1: Selection and Implementation of Foundation Models (26%)

**Foundation Model Services:**
- **Amazon Bedrock** - Fully managed service to access foundation models via API
  - Model providers: Anthropic (Claude), Meta (Llama), Amazon (Titan), Cohere, AI21 Labs, Stability AI, Mistral AI
  - Single API for multiple model providers
  - No infrastructure management required
  - Pay-per-use pricing (input/output tokens)
  - [📖 Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)

- **Amazon SageMaker** - Build, train, and deploy custom ML models
  - SageMaker JumpStart for pre-trained model deployment
  - Custom model training with SageMaker Training
  - Model hosting with SageMaker Endpoints
  - SageMaker Studio for notebook-based development
  - [📖 Amazon SageMaker Documentation](https://docs.aws.amazon.com/sagemaker/)

- **Amazon Titan Models** - Amazon's own foundation models
  - Titan Text: Text generation, summarization, Q&A
  - Titan Embeddings: Text-to-vector conversion for semantic search
  - Titan Image Generator: Text-to-image and image editing
  - Titan Multimodal Embeddings: Combined text and image embeddings
  - [📖 Amazon Titan Models](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-models.html)

**Model Selection Criteria:**
- **Task Type** - Text generation, summarization, code generation, image generation, embeddings
- **Latency Requirements** - Real-time vs batch processing
- **Token Limits** - Context window size (input + output tokens)
- **Cost** - Price per input/output token varies by model
- **Accuracy** - Model performance on specific tasks
- **Customization** - Fine-tuning support availability
- **Responsible AI** - Content filtering and safety features

**Model Providers on Bedrock:**
| Provider | Models | Strengths |
|----------|--------|-----------|
| **Anthropic** | Claude 3.5 Sonnet, Claude 3 Opus/Haiku | Reasoning, analysis, coding, long context |
| **Meta** | Llama 3.1 (8B, 70B, 405B) | Open-source, customizable, multilingual |
| **Amazon** | Titan Text, Titan Embeddings, Titan Image | Native AWS integration, embeddings |
| **Cohere** | Command R/R+, Embed | RAG-optimized, enterprise search |
| **AI21 Labs** | Jamba-Instruct | Multilingual, summarization |
| **Stability AI** | Stable Diffusion XL | Image generation, creative content |
| **Mistral AI** | Mistral Large, Mixtral | Efficient, multilingual, coding |

### Domain 2: Generative AI Application Development (30%)

**Amazon Bedrock Application Features:**
- **Bedrock Knowledge Bases** - Managed RAG implementation
  - Automatic data ingestion and chunking
  - Vector store integration (OpenSearch Serverless, Pinecone, Redis)
  - S3 as data source for documents
  - Automatic embedding generation
  - [📖 Bedrock Knowledge Bases](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)

- **Bedrock Agents** - Autonomous multi-step task execution
  - Action groups for API integrations
  - Lambda functions as action handlers
  - Knowledge base integration for context
  - Chain-of-thought reasoning
  - Session management and memory
  - [📖 Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)

- **Bedrock Guardrails** - Content filtering and safety controls
  - Denied topics and word filters
  - PII detection and redaction
  - Content filters (hate, violence, sexual, insults)
  - Contextual grounding checks
  - [📖 Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)

**Supporting Application Services:**
- **Amazon Kendra** - Intelligent enterprise search
  - Natural language queries
  - Document connectors (S3, SharePoint, Salesforce, databases)
  - FAQ extraction and ranking
  - [📖 Amazon Kendra Documentation](https://docs.aws.amazon.com/kendra/)

- **Amazon OpenSearch Service** - Vector search and analytics
  - k-NN (k-nearest neighbor) vector search
  - Hybrid search (keyword + semantic)
  - OpenSearch Serverless for managed infrastructure
  - [📖 Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/)

- **Amazon Q Developer** - AI-powered coding assistant
  - Code generation and completion
  - Code explanation and debugging
  - Security vulnerability scanning
  - AWS service integration guidance
  - [📖 Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/)

- **AWS Lambda** - Serverless compute for GenAI applications
  - Invoke Bedrock APIs from Lambda functions
  - Event-driven GenAI processing
  - Action handlers for Bedrock Agents
  - [📖 AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)

- **AWS Step Functions** - Orchestrate GenAI workflows
  - Chain multiple Bedrock API calls
  - Human-in-the-loop approval patterns
  - Error handling and retry logic
  - Parallel processing of GenAI tasks
  - [📖 AWS Step Functions Documentation](https://docs.aws.amazon.com/step-functions/)

- **Amazon DynamoDB** - NoSQL database for GenAI applications
  - Session state and conversation history storage
  - Low-latency metadata retrieval
  - Caching of model responses
  - [📖 Amazon DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)

- **Amazon S3** - Object storage for GenAI data
  - Document storage for RAG knowledge bases
  - Training data storage for fine-tuning
  - Model artifact storage
  - [📖 Amazon S3 Documentation](https://docs.aws.amazon.com/s3/)

### Domain 3: Optimization and Evaluation of Generative AI Solutions (24%)

**Model Customization:**
- **Fine-Tuning on Bedrock** - Customize models with your data
  - Continued pre-training for domain adaptation
  - Instruction-based fine-tuning for task-specific behavior
  - Training data in JSONL format on S3
  - Hyperparameter tuning (epochs, batch size, learning rate)
  - [📖 Bedrock Model Customization](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)

- **RLHF (Reinforcement Learning from Human Feedback)**
  - Human preference data collection
  - Reward model training
  - Policy optimization with PPO
  - Alignment with human values

- **Prompt Engineering Techniques**
  - Zero-shot prompting: No examples provided
  - Few-shot prompting: Include examples in prompt
  - Chain-of-thought: Step-by-step reasoning
  - System prompts: Define model behavior and persona
  - Prompt templates: Reusable structured prompts
  - [📖 Prompt Engineering Guidelines](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html)

**Evaluation Metrics:**
- **Text Generation Metrics:**
  - BLEU: Translation quality (n-gram overlap)
  - ROUGE: Summarization quality (recall-based)
  - BERTScore: Semantic similarity using embeddings
  - Perplexity: Model confidence in predictions
  - Human evaluation: Relevance, coherence, factuality

- **RAG-Specific Metrics:**
  - Faithfulness: Answer grounded in retrieved context
  - Answer relevancy: Response matches the question
  - Context precision: Relevant chunks retrieved
  - Context recall: All relevant information retrieved

- **Amazon Bedrock Model Evaluation** - Automated and human evaluation
  - Automatic evaluation with built-in metrics
  - Human evaluation workflows
  - Model comparison capabilities
  - [📖 Bedrock Model Evaluation](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html)

### Domain 4: Security, Compliance, and Governance (20%)

**Access Control:**
- **AWS IAM** - Identity and access management
  - Bedrock-specific IAM policies
  - Model access permissions (bedrock:InvokeModel)
  - Fine-grained resource-level permissions
  - Cross-account model sharing
  - [📖 Bedrock Security](https://docs.aws.amazon.com/bedrock/latest/userguide/security.html)

- **Amazon CloudWatch** - Monitoring and observability
  - Bedrock API call metrics (invocation count, latency, errors)
  - Token usage tracking
  - Custom dashboards for GenAI workloads
  - Alarms for cost and performance thresholds
  - [📖 Monitoring Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/monitoring.html)

- **AWS CloudTrail** - API activity logging
  - Audit all Bedrock API calls
  - Track model invocations and access patterns
  - Compliance and governance auditing
  - [📖 Logging Bedrock API Calls](https://docs.aws.amazon.com/bedrock/latest/userguide/logging-using-cloudtrail.html)

**Data Privacy:**
- Customer data not used for model training by AWS
- Data encrypted in transit (TLS) and at rest (KMS)
- VPC endpoints for private connectivity to Bedrock
- No cross-region data transfer without explicit configuration
- PII detection and redaction with Guardrails
- [📖 Bedrock Data Protection](https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html)

**Responsible AI:**
- Content filtering with Bedrock Guardrails
- Bias detection and mitigation strategies
- Model cards for transparency and documentation
- Hallucination reduction through RAG and grounding
- Human-in-the-loop validation workflows

**Cost Management:**
- **On-Demand Pricing** - Pay per input/output token
- **Provisioned Throughput** - Reserved capacity for consistent workloads
- **Batch Inference** - Lower cost for non-real-time processing
- **Model Selection** - Choose cost-appropriate models per task
- **Caching** - Reduce redundant model invocations
- **Token Optimization** - Minimize prompt and response token usage
- [📖 Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)

## GenAI Architecture Patterns

### Pattern 1: Basic Bedrock Application
```
Client Application
  ↓ (API call)
AWS Lambda
  ↓ (InvokeModel API)
Amazon Bedrock (Foundation Model)
  ↓ (response)
Client Application
```

### Pattern 2: RAG with Knowledge Bases
```
Documents → S3 Bucket
  ↓ (ingestion)
Amazon Bedrock Knowledge Bases
  ↓ (chunking + embedding)
Vector Store (OpenSearch Serverless)

User Query → Bedrock Knowledge Base
  ↓ (retrieve + augment)
Foundation Model (generate response)
  ↓
User Response
```

### Pattern 3: Agentic Workflow
```
User Request → Bedrock Agent
  ↓ (reason + plan)
Action Group 1 → Lambda → External API
Action Group 2 → Lambda → Database
Knowledge Base → Vector Store → Context
  ↓ (synthesize)
Agent Response → User
```

### Pattern 4: Multi-Step GenAI Pipeline
```
Input Document → S3
  ↓
Step Functions Workflow
  ↓
Step 1: Extract text (Textract)
  ↓
Step 2: Summarize (Bedrock - Claude)
  ↓
Step 3: Generate embeddings (Bedrock - Titan)
  ↓
Step 4: Store in OpenSearch
  ↓
Step 5: Notify completion (SNS)
```

## Bedrock API Key Concepts

### InvokeModel API
```python
import boto3
import json

bedrock_runtime = boto3.client('bedrock-runtime')

# Invoke Claude on Bedrock
response = bedrock_runtime.invoke_model(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "messages": [
            {
                "role": "user",
                "content": "Explain RAG in 3 sentences."
            }
        ]
    })
)

result = json.loads(response['body'].read())
print(result['content'][0]['text'])
```

### InvokeModelWithResponseStream API
```python
# Streaming response for real-time output
response = bedrock_runtime.invoke_model_with_response_stream(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "messages": [
            {"role": "user", "content": "Write a short story."}
        ]
    })
)

stream = response.get('body')
for event in stream:
    chunk = json.loads(event['chunk']['bytes'])
    if chunk['type'] == 'content_block_delta':
        print(chunk['delta']['text'], end='')
```

### Converse API (Unified Interface)
```python
# Simplified multi-turn conversation API
response = bedrock_runtime.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[
        {
            "role": "user",
            "content": [{"text": "What is generative AI?"}]
        }
    ],
    inferenceConfig={
        "maxTokens": 512,
        "temperature": 0.7,
        "topP": 0.9
    }
)

print(response['output']['message']['content'][0]['text'])
```

## Key Comparisons

### When to Use Each Service

| Use Case | Service | Why |
|----------|---------|-----|
| Quick FM access via API | Amazon Bedrock | Managed, no infra, pay-per-use |
| Custom model training | Amazon SageMaker | Full control, custom algorithms |
| Enterprise document search | Amazon Kendra | Pre-built connectors, NLU |
| Vector similarity search | Amazon OpenSearch | k-NN, hybrid search, scalable |
| AI coding assistant | Amazon Q Developer | IDE integration, AWS-aware |
| Serverless GenAI logic | AWS Lambda | Event-driven, low cost |
| Complex GenAI workflows | AWS Step Functions | Orchestration, error handling |

### Model Selection Guide

| Task | Recommended Model | Reason |
|------|-------------------|--------|
| Complex reasoning | Claude 3 Opus/Sonnet | Strong analytical capabilities |
| Fast text generation | Claude 3 Haiku, Mistral | Low latency, cost-effective |
| Code generation | Claude 3.5 Sonnet | Excellent coding performance |
| Text embeddings | Titan Embeddings, Cohere Embed | Optimized for vector search |
| Image generation | Stable Diffusion XL, Titan Image | High-quality image output |
| RAG-optimized generation | Cohere Command R+ | Built-in citation, grounding |
| Multilingual tasks | Llama 3.1, Mistral Large | Broad language support |

## Common Exam Scenarios

### Scenario 1: Build a RAG-Powered Q&A System
**Q:** Company wants employees to query internal documents using natural language.
**A:**
- Store documents in S3 bucket
- Create Bedrock Knowledge Base with S3 data source
- Use OpenSearch Serverless as vector store
- Titan Embeddings for document vectorization
- Claude on Bedrock for answer generation
- Guardrails for content safety and PII filtering

### Scenario 2: Reduce Hallucinations in GenAI Application
**Q:** GenAI chatbot is producing inaccurate information about company products.
**A:**
- Implement RAG with Bedrock Knowledge Bases
- Ground responses in verified company documentation
- Use Guardrails with contextual grounding checks
- Add citation and source attribution
- Implement human feedback loop for continuous improvement
- Lower temperature parameter for more deterministic responses

### Scenario 3: Cost-Optimize a GenAI Workload
**Q:** GenAI application has high costs due to frequent model invocations.
**A:**
- Use smaller models (Haiku) for simple tasks, larger models for complex tasks
- Implement response caching with DynamoDB or ElastiCache
- Use Provisioned Throughput for predictable high-volume workloads
- Optimize prompts to reduce token usage
- Batch non-real-time requests
- Monitor token usage with CloudWatch metrics

### Scenario 4: Secure a GenAI Application
**Q:** Enterprise needs to deploy GenAI with strict security and compliance requirements.
**A:**
- Use VPC endpoints for private Bedrock access
- IAM policies with least-privilege model access
- KMS encryption for data at rest
- Guardrails for PII detection and content filtering
- CloudTrail for API audit logging
- CloudWatch for monitoring and alerting
- No customer data used for model training (AWS policy)

### Scenario 5: Customize a Foundation Model
**Q:** Organization needs a model that understands industry-specific terminology.
**A:**
- Continued pre-training on Bedrock for domain vocabulary
- Instruction-based fine-tuning for task-specific behavior
- Prepare training data in JSONL format on S3
- Evaluate fine-tuned model vs base model performance
- Use Bedrock Model Evaluation for comparison
- Monitor fine-tuned model performance over time

## Key Service Limits & Numbers

**Amazon Bedrock:**
- Max input/output tokens: Model-dependent (e.g., Claude 3: 200K input)
- Knowledge Base data sources: S3, Web Crawler, Confluence, SharePoint
- Max file size for ingestion: 50 MB per document
- Guardrails: Up to 30 denied topics per guardrail

**AWS Lambda:**
- 15 minutes max execution time
- 10 GB max memory
- 250 MB deployment package (unzipped)
- Consider timeout for large Bedrock responses

**Amazon OpenSearch Serverless:**
- k-NN vector dimensions: Up to 16,000
- Supports HNSW and IVF algorithms
- Auto-scaling compute and storage

## Exam Strategy

### Time Management
- 170 minutes / 65 questions = 2.6 minutes per question
- Scenario-based questions can be long
- Flag difficult questions and return later

### Question Keywords
- **"Least operational overhead"** → Amazon Bedrock (managed), Knowledge Bases, Guardrails
- **"Most cost-effective"** → Smaller models, caching, Provisioned Throughput, batch inference
- **"Reduce hallucinations"** → RAG, Knowledge Bases, Guardrails (grounding checks), lower temperature
- **"Secure"** → VPC endpoints, IAM policies, KMS, Guardrails (PII), CloudTrail
- **"Customize model"** → Fine-tuning on Bedrock, continued pre-training, prompt engineering
- **"Real-time responses"** → Streaming API, Provisioned Throughput, smaller models
- **"Enterprise search"** → Amazon Kendra, OpenSearch with k-NN

### Common Traps
- ❌ Choosing SageMaker when Bedrock is sufficient (overcomplicating)
- ❌ Ignoring Guardrails for content safety requirements
- ❌ Using large models for simple tasks (cost inefficient)
- ❌ Not considering RAG when grounding is needed
- ❌ Forgetting VPC endpoints for private connectivity
- ❌ Overlooking Provisioned Throughput for high-volume workloads

## Essential Documentation & Resources

### AWS Official Documentation
- [📖 Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/) - Complete Bedrock documentation
- [📖 Generative AI on AWS](https://aws.amazon.com/generative-ai/) - Overview and resources
- [📖 Amazon Bedrock API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/) - API documentation
- [📖 AWS Well-Architected Framework - Machine Learning Lens](https://docs.aws.amazon.com/wellarchitected/latest/machine-learning-lens/machine-learning-lens.html)
- [📖 Responsible AI on AWS](https://aws.amazon.com/ai/responsible-ai/) - Responsible AI practices
- [📖 AIP-C01 Exam Guide](https://aws.amazon.com/certification/certified-generative-ai-developer-professional/) - Official exam page

### Service-Specific Documentation
- [📖 Bedrock Knowledge Bases Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)
- [📖 Bedrock Agents Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)
- [📖 Bedrock Guardrails Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)
- [📖 Amazon SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/)
- [📖 Amazon Kendra Developer Guide](https://docs.aws.amazon.com/kendra/latest/dg/)
- [📖 Amazon OpenSearch Service Developer Guide](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/)

### Hands-on Resources
- [🧪 Amazon Bedrock Workshop](https://catalog.workshops.aws/amazon-bedrock-workshop) - Free hands-on labs
- [🧪 Generative AI on AWS Workshop](https://catalog.workshops.aws/generative-ai-on-aws) - End-to-end GenAI labs
- [🎥 AWS re:Invent GenAI Sessions](https://www.youtube.com/results?search_query=aws+reinvent+generative+ai+bedrock) - Annual conference talks

## Final Exam Checklist

### Knowledge
- [ ] Evaluate and select foundation models for specific use cases
- [ ] Build RAG applications with Bedrock Knowledge Bases
- [ ] Implement agents with action groups and Lambda functions
- [ ] Apply prompt engineering techniques (zero-shot, few-shot, chain-of-thought)
- [ ] Fine-tune models on Bedrock with custom training data
- [ ] Configure Guardrails for content safety and PII filtering
- [ ] Implement vector search with OpenSearch for RAG
- [ ] Design secure GenAI architectures with IAM, VPC endpoints, KMS
- [ ] Monitor GenAI workloads with CloudWatch and CloudTrail
- [ ] Optimize costs with model selection, caching, and Provisioned Throughput

### Experience
- [ ] 2+ years hands-on experience with generative AI
- [ ] Built applications using Amazon Bedrock APIs
- [ ] Implemented RAG patterns with knowledge bases
- [ ] Configured guardrails and content filtering
- [ ] Deployed production GenAI applications on AWS
- [ ] Evaluated and compared foundation model performance
- [ ] Managed security and compliance for GenAI workloads

### Preparation
- [ ] Read Amazon Bedrock documentation thoroughly
- [ ] Completed Bedrock hands-on workshops
- [ ] Practiced building RAG and agent applications
- [ ] Understand all Bedrock model providers and capabilities
- [ ] Familiar with GenAI evaluation metrics
- [ ] Practice exams scoring 80%+

---

**Pro Tip:** AIP-C01 emphasizes practical application development with Amazon Bedrock. The exam tests your ability to select appropriate models, build RAG-powered applications, implement agents, and secure GenAI workloads. Focus on Bedrock-specific features like Knowledge Bases, Agents, and Guardrails, not just general GenAI concepts!

**Good luck!** This certification validates professional-level generative AI development skills on AWS. 🚀
