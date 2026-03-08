# AWS Certified Generative AI Developer - Professional (AIP-C01) Exam Guide

## Exam Overview

The AWS Certified Generative AI Developer - Professional (AIP-C01) exam validates advanced technical skills in developing generative AI applications on AWS. Launched in beta in November 2025, this certification demonstrates expertise in selecting foundation models, building RAG-powered applications with Amazon Bedrock, implementing agents, and securing generative AI workloads at scale.

### Exam Details
- **Exam Code**: AIP-C01
- **Duration**: 170 minutes (2 hours 50 minutes)
- **Format**: Multiple choice and multiple response
- **Number of Questions**: 65 questions
- **Passing Score**: 750/1000
- **Cost**: $300 USD
- **Language**: Available in multiple languages
- **Delivery**: Pearson VUE (Testing center or online proctored)
- **Validity**: 3 years
- **Prerequisites**: Recommended 2+ years hands-on experience with generative AI on AWS

## Exam Domains

### Domain 1: Selection and Implementation of Foundation Models (26% of scored content)
- Evaluate and compare foundation models for specific use cases
- Select appropriate model providers and configurations
- Configure model parameters (temperature, top-p, max tokens)
- Implement model invocation using Bedrock APIs

#### Key Focus Areas:
- Amazon Bedrock model catalog and provider ecosystem
- Amazon Titan models (Text, Embeddings, Image, Multimodal)
- Model selection criteria (latency, cost, accuracy, context window)
- Bedrock InvokeModel, Converse, and streaming APIs
- Amazon SageMaker JumpStart for custom model deployment
- Model parameter tuning and inference configuration
- Understanding transformer architectures and tokenization

**📖 [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)** - Complete Bedrock service guide
**📖 [Amazon Titan Models](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-models.html)** - Amazon's foundation models
**📖 [Bedrock Model Access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html)** - Requesting model access

### Domain 2: Generative AI Application Development (30% of scored content)
- Build applications using Amazon Bedrock APIs
- Implement Retrieval Augmented Generation (RAG) patterns
- Develop autonomous agents with multi-step reasoning
- Integrate GenAI capabilities into existing applications

#### Key Focus Areas:
- Amazon Bedrock Knowledge Bases for managed RAG
- Amazon Bedrock Agents with action groups and Lambda
- Vector databases (OpenSearch Serverless, Pinecone, Redis)
- Embedding models and vector search (k-NN)
- Document ingestion, chunking, and preprocessing
- Conversation management and session state
- Amazon Kendra for enterprise search integration
- AWS Step Functions for GenAI workflow orchestration
- Amazon Q Developer for AI-assisted coding

**📖 [Bedrock Knowledge Bases](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)** - Managed RAG implementation
**📖 [Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)** - Autonomous task execution
**📖 [Amazon Kendra](https://docs.aws.amazon.com/kendra/)** - Intelligent enterprise search
**📖 [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/)** - Vector search capabilities

### Domain 3: Optimization and Evaluation of Generative AI Solutions (24% of scored content)
- Fine-tune foundation models with custom data
- Apply prompt engineering best practices
- Evaluate model performance with appropriate metrics
- Implement responsible AI practices

#### Key Focus Areas:
- Bedrock model customization (fine-tuning, continued pre-training)
- Prompt engineering (zero-shot, few-shot, chain-of-thought, system prompts)
- Evaluation metrics (BLEU, ROUGE, BERTScore, perplexity)
- RAG evaluation (faithfulness, relevancy, context precision)
- Amazon Bedrock Model Evaluation (automatic and human)
- RLHF (Reinforcement Learning from Human Feedback)
- Hallucination detection and mitigation strategies
- Inference parameter optimization (temperature, top-p, top-k)

**📖 [Bedrock Model Customization](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)** - Fine-tuning guide
**📖 [Prompt Engineering Guidelines](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html)** - Best practices
**📖 [Bedrock Model Evaluation](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html)** - Evaluation workflows

### Domain 4: Security, Compliance, and Governance (20% of scored content)
- Secure generative AI applications and data
- Implement data privacy and protection controls
- Configure model governance and access management
- Optimize costs for GenAI workloads

#### Key Focus Areas:
- IAM policies for Bedrock model access control
- Amazon Bedrock Guardrails (content filtering, PII, denied topics)
- VPC endpoints for private Bedrock connectivity
- KMS encryption for data at rest
- CloudTrail logging for Bedrock API auditing
- CloudWatch monitoring for GenAI workloads
- Data privacy (customer data not used for training)
- Cost optimization (model selection, caching, Provisioned Throughput)
- Responsible AI practices and bias mitigation
- Compliance frameworks and data residency

**📖 [Bedrock Security](https://docs.aws.amazon.com/bedrock/latest/userguide/security.html)** - Security best practices
**📖 [Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)** - Content safety controls
**📖 [Bedrock Data Protection](https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html)** - Privacy and encryption
**📖 [Monitoring Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/monitoring.html)** - CloudWatch metrics

## Key Services and Tools

### Core GenAI Services

#### Amazon Bedrock
- Fully managed access to foundation models via API
- Multiple model providers (Anthropic, Meta, Amazon, Cohere, Mistral, Stability AI, AI21 Labs)
- Knowledge Bases for managed RAG
- Agents for autonomous multi-step task execution
- Guardrails for content safety and PII protection
- Model customization (fine-tuning, continued pre-training)
- Model evaluation (automatic and human)
- Provisioned Throughput for consistent performance

#### Amazon SageMaker
- SageMaker JumpStart for pre-trained model deployment
- Custom model training and hosting
- SageMaker Studio notebooks for experimentation
- Model monitoring and A/B testing
- MLOps pipeline integration

#### Amazon Q Developer
- AI-powered coding assistant
- Code generation, explanation, and debugging
- Security vulnerability scanning
- AWS service integration guidance
- IDE plugins (VS Code, JetBrains, CLI)

### Supporting Services

#### Data and Search
- **Amazon OpenSearch Service** - Vector search with k-NN, hybrid search
- **Amazon Kendra** - Intelligent enterprise search with NLU
- **Amazon S3** - Document storage for RAG, training data
- **Amazon DynamoDB** - Session state, conversation history, metadata

#### Compute and Orchestration
- **AWS Lambda** - Serverless GenAI processing, agent action handlers
- **AWS Step Functions** - Multi-step GenAI workflow orchestration
- **Amazon API Gateway** - RESTful and WebSocket APIs for GenAI apps

#### Security and Monitoring
- **AWS IAM** - Fine-grained access control for Bedrock
- **AWS KMS** - Encryption key management
- **Amazon CloudWatch** - Metrics, logs, alarms for GenAI workloads
- **AWS CloudTrail** - API call auditing and compliance
- **AWS CloudFormation** - Infrastructure as code for GenAI stacks

## Study Strategy

### Phase 1: GenAI Foundations (Weeks 1-2)
- Understand generative AI concepts and architectures
- Learn transformer models, tokenization, embeddings
- Explore Amazon Bedrock console and model catalog
- Practice basic model invocation with Bedrock APIs

### Phase 2: Application Development (Weeks 3-4)
- Build RAG applications with Bedrock Knowledge Bases
- Implement Bedrock Agents with action groups
- Integrate vector search with OpenSearch
- Practice multi-turn conversation patterns

### Phase 3: Optimization and Evaluation (Weeks 5-6)
- Master prompt engineering techniques
- Fine-tune models with custom data on Bedrock
- Evaluate model performance with metrics
- Implement responsible AI practices

### Phase 4: Security and Architecture (Weeks 7-8)
- Configure IAM, VPC endpoints, encryption
- Set up Guardrails for content safety
- Design cost-optimized GenAI architectures
- Practice end-to-end scenarios

### Phase 5: Review and Practice (Final Weeks)
- Complete practice exams
- Hands-on scenario practice
- Review weak areas
- Time management practice

## Common Exam Scenarios

### RAG Application Design
- Document ingestion pipeline with S3 and Knowledge Bases
- Vector store selection (OpenSearch Serverless vs Pinecone)
- Chunking strategies for optimal retrieval
- Embedding model selection for search quality

### Agent Development
- Multi-step task automation with Bedrock Agents
- Lambda function action handlers
- Knowledge base integration for context
- Error handling and fallback strategies

### Model Selection and Optimization
- Choosing models based on task, latency, and cost
- Prompt engineering for better outputs
- Fine-tuning vs prompt engineering trade-offs
- Cost optimization with model tiering

### Security and Compliance
- Private Bedrock access with VPC endpoints
- Content filtering with Guardrails
- Audit logging and monitoring
- Data privacy and encryption patterns

## 📚 Comprehensive Study Resources

**👉 [Complete AWS Study Resources Guide](../../../../.templates/resources-aws.md)**

### Quick Links (AIP-C01 Specific)
- **📖 [AIP-C01 Official Exam Page](https://aws.amazon.com/certification/certified-generative-ai-developer-professional/)** - Registration
- **📖 [AWS Skill Builder - GenAI](https://skillbuilder.aws/)** - FREE GenAI courses
- **📖 [Amazon Bedrock Workshop](https://catalog.workshops.aws/amazon-bedrock-workshop)** - Hands-on labs
- **📖 [Generative AI on AWS](https://aws.amazon.com/generative-ai/)** - Overview and resources
- **📖 [AWS Documentation](https://docs.aws.amazon.com/)** - Service guides

## Exam Preparation Tips

### Study Approach
1. **Bedrock-First Mindset**: Amazon Bedrock is the central service for this exam
2. **Hands-on Practice**: Build real RAG and agent applications
3. **Real-world Experience**: 2+ years with GenAI on AWS recommended
4. **Practice Scenarios**: Work through complex multi-service architectures
5. **Time Management**: Practice with timed exams

### Exam Strategy
1. **Time Allocation**: ~2.6 minutes per question
2. **Scenario Analysis**: Identify requirements, constraints, and trade-offs
3. **Best Practices**: Choose managed services (Bedrock) over custom solutions when possible
4. **Eliminate Options**: Rule out clearly incorrect or over-engineered answers
5. **Mark for Review**: Flag uncertain questions and return if time permits

## Next Steps After Certification

### Career Advancement
- GenAI application architect and developer roles
- AI/ML solutions architect
- Generative AI consultant
- AI platform engineering leadership
- GenAI product development

### Continuous Learning
- Advanced RAG patterns and evaluation
- Multi-agent systems and orchestration
- Multimodal AI applications
- GenAI security and red teaming
- Emerging foundation model capabilities
