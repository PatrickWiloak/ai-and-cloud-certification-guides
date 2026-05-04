---
last-updated: 2026-05-03
---

# Azure AI-900 Generative AI: Comprehensive Fact Sheet

## Exam Overview

This Azure GenAI certification pathway validates your ability to design, implement, and deploy generative AI solutions using Azure OpenAI Service, Azure AI Studio, and related Azure AI services. This represents Microsoft's latest focus on empowering developers and AI engineers to build production-ready generative AI applications.

**Certification Details:**
- **Focus Area:** Generative AI on Azure
- **Target Role:** AI Engineers, Developers, Solution Architects
- **Core Technologies:** Azure OpenAI Service, Azure AI Studio, Prompt Engineering
- **Prerequisites:** Basic understanding of Azure AI services and cloud concepts
- **Related Certifications:** AI-102 (Azure AI Engineer Associate)

## Core Domains and Focus Areas

1. **Azure OpenAI Service Fundamentals (25-30%)**
2. **Prompt Engineering and Optimization (20-25%)**
3. **Azure AI Studio and Model Deployment (20-25%)**
4. **Responsible AI and Model Deployment (15-20%)**
5. **Integration and Production Scenarios (15-20%)**

---

## 1. Azure OpenAI Service Fundamentals (25-30%)

### Azure OpenAI Service Overview

**[📖 Azure OpenAI Service Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview)** - Enterprise-grade access to OpenAI's powerful language models with Azure security and compliance

**[📖 Azure OpenAI Service Models](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models)** - Available models including GPT-4, GPT-4 Turbo, GPT-3.5 Turbo, Embeddings, DALL-E 3, and Whisper

**[📖 Azure OpenAI Service Quotas and Limits](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits)** - Token limits, rate limits, model availability by region, and capacity management

**[📖 Azure OpenAI Service Pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)** - Detailed pricing for models, embeddings, fine-tuning, and image generation

**[📖 Request Access to Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview#how-do-i-get-access-to-azure-openai)** - Application process for Azure OpenAI service access

### GPT Models and Capabilities

**[📖 GPT-4 and GPT-4 Turbo](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo-models)** - Most capable models for complex tasks, reasoning, and multi-modal inputs

**[📖 GPT-3.5 Turbo](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-35-models)** - Fast and cost-effective model for most language tasks

**[📖 Chat Completions API](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/chatgpt)** - Build conversational AI applications with GPT models

**[📖 Completions API](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/completions)** - Generate text completions for various use cases

**[📖 Understanding Tokens](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/tokens)** - Token counting, pricing calculation, and context window management

**[📖 Model Parameters: Temperature and Top-p](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/advanced-prompt-engineering)** - Control randomness and creativity in model outputs

### DALL-E Image Generation

**[📖 DALL-E 3 Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#dall-e-models)** - Generate high-quality images from text descriptions

**[📖 Image Generation API](https://learn.microsoft.com/en-us/azure/ai-services/openai/dall-e-quickstart)** - Create, edit, and generate variations of images programmatically

**[📖 Image Generation Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/dall-e-best-practices)** - Crafting effective image prompts and managing quality

### Embeddings and Semantic Search

**[📖 Embeddings Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings)** - Vector representations of text for semantic search and similarity

**[📖 Embeddings API](https://learn.microsoft.com/en-us/azure/ai-services/openai/tutorials/embeddings)** - Generate embeddings for text analysis and search

**[📖 Similarity and Distance Metrics](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings#cosine-similarity)** - Cosine similarity, dot product, and Euclidean distance for vector comparison

**[📖 Vector Search with Azure Cognitive Search](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)** - Implement semantic search using embeddings

### Whisper Speech Recognition

**[📖 Whisper Model Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#whisper-models)** - Speech-to-text and translation capabilities with high accuracy

**[📖 Whisper API Usage](https://learn.microsoft.com/en-us/azure/ai-services/openai/whisper-quickstart)** - Transcribe and translate audio files using Whisper

---

## 2. Prompt Engineering and Optimization (20-25%)

### Prompt Engineering Fundamentals

**[📖 Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering)** - Comprehensive guide to crafting effective prompts

**[📖 System Messages](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/system-message)** - Set model behavior, tone, and context with system messages

**[📖 Few-Shot Learning](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering#few-shot-learning)** - Provide examples to guide model behavior

**[📖 Zero-Shot vs Few-Shot Prompting](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering)** - Understanding different prompting approaches

**[📖 Chain-of-Thought Prompting](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/advanced-prompt-engineering#chain-of-thought-prompting)** - Break down complex reasoning into steps

### Advanced Prompt Techniques

**[📖 Advanced Prompt Engineering Guide](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/advanced-prompt-engineering)** - Meta prompts, prompt injection prevention, and optimization

**[📖 Prompt Engineering Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering#best-practices)** - Guidelines for clear, specific, and effective prompts

**[📖 Managing Context Windows](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/chatgpt#managing-conversations)** - Handle long conversations and token limits

**[📖 Prompt Iteration and Testing](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering#iterative-prompt-development)** - Systematic approach to improving prompts

### Function Calling and Tools

**[📖 Function Calling](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling)** - Enable models to call external functions and APIs

**[📖 Parallel Function Calling](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling#parallel-function-calling)** - Execute multiple functions in a single request

**[📖 Function Calling Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling#best-practices)** - Design effective function definitions and error handling

### Retrieval Augmented Generation (RAG)

**[📖 RAG Pattern Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/use-your-data)** - Ground model responses with your own data

**[📖 Azure OpenAI On Your Data](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/use-your-data)** - Integrate GPT models with Azure Cognitive Search, Cosmos DB, or custom data

**[📖 Data Preparation for RAG](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/use-your-data#data-formats-and-file-types)** - Prepare and format data for grounding

**[📖 RAG with Azure Cognitive Search](https://learn.microsoft.com/en-us/azure/search/search-how-to-index-for-gpt)** - Build semantic search for grounded generation

---

## 3. Azure AI Studio and Model Deployment (20-25%)

### Azure AI Studio

**[📖 Azure AI Studio Overview](https://learn.microsoft.com/en-us/azure/ai-studio/what-is-ai-studio)** - Unified platform for building, evaluating, and deploying AI applications

**[📖 Azure AI Studio Quickstart](https://learn.microsoft.com/en-us/azure/ai-studio/quickstarts/get-started-playground)** - Get started with the playground and experimentation

**[📖 Azure AI Studio Projects](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/create-projects)** - Organize and manage AI development projects

**[📖 Prompt Flow in AI Studio](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/prompt-flow)** - Visual tool for building and testing prompts and flows

**[📖 Model Catalog](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/model-catalog)** - Browse and deploy models from the Azure model catalog

### Model Deployment and Management

**[📖 Deploy Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource)** - Create and deploy OpenAI model deployments

**[📖 Model Versions and Updates](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/model-versions)** - Manage model versions and auto-update settings

**[📖 Deployment Types](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/deployment-types)** - Standard, Provisioned Throughput, and Global deployments

**[📖 Provisioned Throughput Units (PTU)](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/provisioned-throughput)** - Dedicated capacity for predictable performance

**[📖 Global Deployment](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/global-deployments)** - Deploy models across multiple regions for high availability

### Fine-Tuning and Customization

**[📖 Fine-Tuning Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/fine-tuning)** - Customize models with your own training data

**[📖 Prepare Training Data](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/fine-tuning#prepare-training-data)** - Format and structure data for fine-tuning

**[📖 Fine-Tuning Job Management](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/fine-tuning#create-a-fine-tuning-job)** - Create, monitor, and deploy fine-tuned models

**[📖 Evaluation and Validation](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/fine-tuning#analyze-your-fine-tuned-model)** - Assess fine-tuned model performance

---

## 4. Responsible AI and Model Safety (15-20%)

### Content Filtering and Safety

**[📖 Content Filtering](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter)** - Built-in safety systems for detecting and filtering harmful content

**[📖 Content Filter Categories](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter#content-filtering-categories)** - Hate, sexual, violence, self-harm, and protected material detection

**[📖 Configure Content Filters](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/content-filters)** - Customize filtering thresholds and configurations

**[📖 Prompt Shields](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter#prompt-shields)** - Detect and block prompt injection attacks and jailbreak attempts

**[📖 Protected Material Detection](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter#protected-material-text)** - Identify known copyrighted text, song lyrics, and recipes

### Responsible AI Practices

**[📖 Responsible AI for Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/responsible-ai)** - Microsoft's principles and practices for responsible AI

**[📖 Transparency Notes](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/transparency-note)** - Understanding capabilities, limitations, and appropriate uses

**[📖 Limited Access and Registration](https://learn.microsoft.com/en-us/azure/ai-services/openai/limited-access)** - Features requiring additional approval for responsible deployment

**[📖 Red Teaming for Generative AI](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/red-teaming)** - Test systems for vulnerabilities and edge cases

**[📖 Abuse Monitoring](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/abuse-monitoring)** - Monitor for misuse and policy violations

### Data Privacy and Security

**[📖 Data Privacy for Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/faq#how-does-azure-openai-use-my-data)** - Data residency, retention, and usage policies

**[📖 Customer Copyright Commitment](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/customer-copyright-commitment)** - Microsoft's copyright indemnification for Azure OpenAI

**[📖 GDPR and Compliance](https://learn.microsoft.com/en-us/azure/ai-services/openai/faq#is-azure-openai-compliant-with-gdpr)** - Data protection and regulatory compliance

---

## 5. Integration and Production Scenarios (15-20%)

### SDK and API Integration

**[📖 Azure OpenAI Python SDK](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart)** - Python client library for Azure OpenAI

**[📖 Azure OpenAI .NET SDK](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?pivots=programming-language-csharp)** - C# client library integration

**[📖 Azure OpenAI JavaScript SDK](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?pivots=programming-language-javascript)** - Node.js and JavaScript library

**[📖 Azure OpenAI REST API](https://learn.microsoft.com/en-us/azure/ai-services/openai/reference)** - HTTP API reference for direct integration

**[📖 LangChain with Azure OpenAI](https://python.langchain.com/docs/integrations/llms/azure_openai)** - Use LangChain framework with Azure OpenAI models

### Authentication and Security

**[📖 Azure OpenAI Authentication](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity)** - API keys, Azure AD, and managed identities

**[📖 Managed Identity for Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity)** - Secure authentication without credentials

**[📖 Virtual Network and Private Endpoints](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks)** - Network security for Azure OpenAI

**[📖 Customer-Managed Keys](https://learn.microsoft.com/en-us/azure/ai-services/encryption/cognitive-services-encryption-keys-portal)** - Encrypt data with your own keys

### Monitoring and Optimization

**[📖 Monitor Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/monitoring)** - Track usage, performance, and errors

**[📖 Diagnostic Logging](https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging)** - Enable logging for troubleshooting and auditing

**[📖 Application Insights Integration](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/monitoring#application-insights)** - Advanced monitoring and analytics

**[📖 Rate Limiting and Throttling](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/quota)** - Manage API rate limits and implement retry logic

**[📖 Cost Management](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/manage-costs)** - Monitor and optimize Azure OpenAI spending

### Production Best Practices

**[📖 Azure OpenAI Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/best-practices)** - Guidelines for production deployments

**[📖 Error Handling and Retry Logic](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/retries)** - Implement robust error handling

**[📖 Scaling Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits#how-to-request-increases-to-the-default-quotas-and-limits)** - Request quota increases and plan for scale

**[📖 Multi-Region Deployments](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#model-summary-table-and-region-availability)** - Deploy across regions for resilience

---

## Common Generative AI Scenarios

### Scenario 1: Intelligent Chatbot with RAG
**Requirement:** Build customer service chatbot with company knowledge base

**Solution Components:**
- Azure OpenAI Service (GPT-4)
- Azure Cognitive Search (vector search)
- Azure Blob Storage (document storage)
- Application Insights (monitoring)
- Function calling for actions

### Scenario 2: Content Generation Platform
**Requirement:** Generate marketing content with brand guidelines

**Solution Components:**
- Azure OpenAI (GPT-4 Turbo)
- System messages for brand voice
- Few-shot examples for style
- Content filtering for safety
- Azure Functions for orchestration

### Scenario 3: Document Analysis and Summarization
**Requirement:** Analyze and summarize large document sets

**Solution Components:**
- Azure OpenAI (GPT-4)
- Document Intelligence (text extraction)
- Embeddings for document clustering
- Azure Cognitive Search (indexing)
- Prompt engineering for summaries

### Scenario 4: Code Generation Assistant
**Requirement:** Help developers write and understand code

**Solution Components:**
- Azure OpenAI (GPT-4)
- Function calling for code execution
- Context management for long files
- Code-specific prompting techniques
- Azure DevOps integration

### Scenario 5: Image Generation Service
**Requirement:** Generate product images from descriptions

**Solution Components:**
- Azure OpenAI (DALL-E 3)
- Azure Storage (image storage)
- Content filtering (safety)
- API Management (rate limiting)
- CDN for delivery

---

## Key Concepts to Master

### Token Management
- Understanding token counting and limits
- Managing context windows effectively
- Optimizing token usage for cost
- Handling truncation and completion

### Model Selection
- Choosing between GPT-4 and GPT-3.5 Turbo
- Understanding model capabilities and costs
- Selecting appropriate deployment type
- Evaluating model versions

### Prompt Design
- Writing clear, specific instructions
- Using system messages effectively
- Providing examples (few-shot learning)
- Managing conversation context
- Preventing prompt injection

### Safety and Compliance
- Implementing content filtering
- Monitoring for abuse
- Ensuring data privacy
- Meeting regulatory requirements
- Testing for edge cases

### Production Readiness
- Error handling and retries
- Rate limiting management
- Cost optimization
- Monitoring and alerting
- Multi-region deployment

---

## Important Terms and Definitions

### Generative AI Terms
- **LLM (Large Language Model):** AI model trained on vast text data for language tasks
- **Token:** Basic unit of text processing (roughly 4 characters or ¾ of a word)
- **Context Window:** Maximum tokens model can process in single request
- **Temperature:** Parameter controlling randomness (0=deterministic, 2=very random)
- **Top-p:** Nucleus sampling parameter for output diversity
- **Embedding:** Vector representation of text for semantic operations

### Azure OpenAI Terms
- **Deployment:** Instance of a model available for inference
- **PTU (Provisioned Throughput Unit):** Reserved capacity unit
- **Global Deployment:** Multi-region model deployment for high availability
- **Fine-Tuning:** Customizing model with additional training data
- **System Message:** Initial instruction defining model behavior

### RAG Terms
- **Grounding:** Providing external data to inform model responses
- **Vector Search:** Finding similar items using embedding vectors
- **Semantic Search:** Search based on meaning rather than keywords
- **Retrieval:** Process of fetching relevant documents for context

### Safety Terms
- **Content Filter:** System for detecting harmful content
- **Prompt Shield:** Protection against prompt injection attacks
- **Jailbreak:** Attempt to bypass model safety measures
- **Red Teaming:** Testing for vulnerabilities and edge cases
- **Abuse Monitoring:** Detecting misuse of AI services

---

## Quick Reference Guide

### Model Selection Matrix

| Use Case | Recommended Model | Reason |
|----------|------------------|---------|
| Complex reasoning | GPT-4 | Best capabilities |
| Cost-effective chat | GPT-3.5 Turbo | Good balance |
| Long documents | GPT-4 Turbo (128k) | Large context window |
| Code generation | GPT-4 | Superior code understanding |
| Simple tasks | GPT-3.5 Turbo | Faster and cheaper |
| Image generation | DALL-E 3 | High-quality images |
| Semantic search | text-embedding-ada-002 | Cost-effective embeddings |
| Speech transcription | Whisper | Accurate speech-to-text |

### Deployment Types Comparison

| Feature | Standard | Provisioned | Global |
|---------|----------|------------|--------|
| Billing | Pay-per-token | Monthly PTU | Pay-per-token |
| Throughput | Shared | Reserved | High availability |
| Latency | Variable | Predictable | Optimized |
| Best For | Variable workloads | High volume | Mission-critical |

### Prompt Engineering Checklist
- [ ] Clear and specific instructions
- [ ] Appropriate system message
- [ ] Few-shot examples if needed
- [ ] Proper context management
- [ ] Output format specified
- [ ] Edge case handling
- [ ] Token limit awareness

---

## Study Resources

### Official Microsoft Resources

**[📖 Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)** - Complete documentation hub

**[📖 Azure AI Studio Documentation](https://learn.microsoft.com/en-us/azure/ai-studio/)** - AI Studio guides and tutorials

**[📖 Microsoft Learn: Generative AI](https://learn.microsoft.com/en-us/training/paths/introduction-generative-ai/)** - Free learning paths

**[📖 Azure OpenAI Samples](https://github.com/Azure-Samples/openai)** - Official code samples and quickstarts

### Hands-On Practice

1. **Basic Chat Application**
   - Deploy GPT-3.5 Turbo model
   - Implement chat completions
   - Add system messages
   - Manage conversation history

2. **RAG Implementation**
   - Prepare document dataset
   - Generate embeddings
   - Implement vector search
   - Build grounded chat

3. **Prompt Engineering**
   - Practice zero-shot prompting
   - Create few-shot examples
   - Optimize for specific tasks
   - Test and iterate

4. **Content Generation**
   - Generate DALL-E images
   - Create marketing content
   - Summarize documents
   - Translate text

5. **Production Deployment**
   - Implement authentication
   - Add error handling
   - Set up monitoring
   - Optimize costs

---

## Exam Tips

### Focus Areas
- Azure OpenAI Service capabilities and limitations
- Prompt engineering techniques
- RAG pattern implementation
- Content filtering and safety
- Model selection and deployment
- Cost optimization strategies
- Production best practices

### Common Topics
- Difference between GPT-4 and GPT-3.5 Turbo
- When to use RAG vs fine-tuning
- Token counting and management
- Content filter configuration
- Deployment types (Standard vs PTU)
- Function calling implementation
- Monitoring and diagnostics

### Hands-On Skills Required
- Deploy and configure Azure OpenAI models
- Write effective prompts
- Implement RAG with Azure Cognitive Search
- Configure content filtering
- Integrate using SDK or REST API
- Monitor and optimize costs
- Handle errors and rate limits

---

**Last Updated:** 2025-01-13
**Focus:** Azure OpenAI Service and Generative AI
**Total Documentation Links:** 80+

---

## Notes

This fact sheet covers the essential aspects of building generative AI applications with Azure OpenAI Service and Azure AI Studio. As this is an emerging certification area, candidates should stay updated with the latest Azure OpenAI features and best practices through the official Microsoft Learn documentation.

**Good luck with your Azure GenAI journey!**
