# AWS Certified Generative AI Developer - Professional (AIP-C01) Study Plan

## 8-Week Study Schedule

> **Time Commitment**: 10-15 hours/week
> **Difficulty**: Professional

---

## Study Approach

### Weekly Breakdown
- **Days 1-4**: Study domain concepts, read AWS documentation, watch training videos
- **Days 5-6**: Hands-on labs with Amazon Bedrock and supporting services
- **Day 7**: Practice questions and review

---

## Week-by-Week Plan

### Week 1: Generative AI Foundations & Amazon Bedrock Overview
- [ ] Understand generative AI concepts: transformers, LLMs, tokenization, embeddings
- [ ] Learn the difference between foundation models, fine-tuned models, and custom models
- [ ] Explore the Amazon Bedrock console and model catalog
- [ ] Review available model providers: Anthropic, Meta, Amazon, Cohere, Mistral, AI21 Labs, Stability AI
- [ ] Practice invoking models using the Bedrock playground
- [ ] Read: **📖 [Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/)**
- [ ] Read: **📖 [Generative AI on AWS Overview](https://aws.amazon.com/generative-ai/)**
- [ ] Hands-on: **📖 [Amazon Bedrock Workshop](https://catalog.workshops.aws/amazon-bedrock-workshop)**

### Week 2: Foundation Model Selection & Implementation
- [ ] Study model selection criteria: latency, cost, accuracy, context window, task suitability
- [ ] Learn Amazon Titan models: Text, Embeddings, Image Generator, Multimodal Embeddings
- [ ] Understand model parameters: temperature, top-p, top-k, max tokens, stop sequences
- [ ] Practice InvokeModel API, Converse API, and streaming responses
- [ ] Compare model providers for different use cases (text, code, image, embeddings)
- [ ] Understand on-demand vs Provisioned Throughput pricing
- [ ] Read: **📖 [Amazon Titan Models](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-models.html)**
- [ ] Read: **📖 [Bedrock API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/)**
- [ ] Hands-on: Build a simple application invoking multiple Bedrock models via AWS SDK

### Week 3: RAG and Knowledge Bases
- [ ] Understand Retrieval Augmented Generation (RAG) architecture and benefits
- [ ] Learn Amazon Bedrock Knowledge Bases: setup, data sources, ingestion
- [ ] Study vector databases: OpenSearch Serverless k-NN, Pinecone, Redis Enterprise
- [ ] Understand embedding models and vector similarity search
- [ ] Learn document chunking strategies (fixed-size, semantic, hierarchical)
- [ ] Practice creating a Knowledge Base with S3 data source
- [ ] Study retrieval strategies: semantic search, hybrid search
- [ ] Read: **📖 [Bedrock Knowledge Bases](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)**
- [ ] Read: **📖 [Amazon OpenSearch k-NN](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/knn.html)**
- [ ] Hands-on: Build a RAG application with Bedrock Knowledge Bases and OpenSearch Serverless

### Week 4: Agents and Application Architecture
- [ ] Study Amazon Bedrock Agents: architecture, reasoning, action groups
- [ ] Learn how to define action groups with OpenAPI schemas
- [ ] Practice building Lambda functions as agent action handlers
- [ ] Understand agent session management and conversation memory
- [ ] Study multi-step reasoning and chain-of-thought in agents
- [ ] Learn Amazon Q Developer capabilities and use cases
- [ ] Study GenAI application patterns: chatbots, document processing, code generation
- [ ] Practice orchestrating GenAI workflows with AWS Step Functions
- [ ] Read: **📖 [Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)**
- [ ] Read: **📖 [Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/)**
- [ ] Read: **📖 [AWS Step Functions](https://docs.aws.amazon.com/step-functions/)**
- [ ] Hands-on: Build a Bedrock Agent with action groups that queries an API and a Knowledge Base

### Week 5: Prompt Engineering & Fine-Tuning
- [ ] Master prompt engineering techniques: zero-shot, few-shot, chain-of-thought
- [ ] Learn system prompt design for persona and behavior control
- [ ] Study prompt templates and variable injection patterns
- [ ] Understand Bedrock model customization: fine-tuning vs continued pre-training
- [ ] Learn training data preparation (JSONL format, data quality)
- [ ] Study hyperparameter tuning: epochs, batch size, learning rate, warmup steps
- [ ] Understand RLHF concepts and human feedback collection
- [ ] Practice prompt engineering with different models and tasks
- [ ] Read: **📖 [Prompt Engineering Guidelines](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html)**
- [ ] Read: **📖 [Bedrock Model Customization](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)**
- [ ] Hands-on: Experiment with prompt engineering techniques across different models

### Week 6: Evaluation, Metrics & Responsible AI
- [ ] Study evaluation metrics: BLEU, ROUGE, BERTScore, perplexity
- [ ] Learn RAG-specific metrics: faithfulness, answer relevancy, context precision/recall
- [ ] Practice using Amazon Bedrock Model Evaluation (automatic and human)
- [ ] Understand model comparison and benchmarking approaches
- [ ] Study responsible AI: bias detection, fairness, transparency
- [ ] Learn hallucination detection and mitigation strategies
- [ ] Study Amazon Bedrock Guardrails: content filters, denied topics, PII, grounding
- [ ] Configure Guardrails for content safety and compliance
- [ ] Read: **📖 [Bedrock Model Evaluation](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html)**
- [ ] Read: **📖 [Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)**
- [ ] Read: **📖 [Responsible AI on AWS](https://aws.amazon.com/ai/responsible-ai/)**
- [ ] Hands-on: Set up model evaluation jobs and configure Guardrails

### Week 7: Security, Compliance & Cost Optimization
- [ ] Study IAM policies for Bedrock: model access, resource-level permissions
- [ ] Learn VPC endpoint configuration for private Bedrock access
- [ ] Understand KMS encryption for GenAI data at rest and in transit
- [ ] Configure CloudTrail logging for Bedrock API audit trail
- [ ] Set up CloudWatch dashboards for GenAI monitoring (invocations, latency, tokens)
- [ ] Study data privacy: customer data isolation, no training on customer data
- [ ] Learn cost optimization: model tiering, caching, Provisioned Throughput, batch inference
- [ ] Study AWS CloudFormation for GenAI infrastructure as code
- [ ] Review cross-account model sharing and governance patterns
- [ ] Read: **📖 [Bedrock Security](https://docs.aws.amazon.com/bedrock/latest/userguide/security.html)**
- [ ] Read: **📖 [Bedrock Data Protection](https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html)**
- [ ] Read: **📖 [Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)**
- [ ] Hands-on: Configure VPC endpoints, IAM policies, Guardrails, and CloudWatch monitoring

### Week 8: Review, Practice Exams & Final Preparation
- [ ] Review all four exam domains and key concepts
- [ ] Take full-length practice exam #1
- [ ] Review incorrect answers thoroughly and study weak areas
- [ ] Take full-length practice exam #2 (aim for 80%+)
- [ ] Review common exam scenarios: RAG design, agent development, model selection, security
- [ ] Practice end-to-end architecture design on whiteboard/paper
- [ ] Review key service comparisons and decision criteria
- [ ] Light review and rest before exam day

---

## 📚 Study Resources

**👉 [Complete AWS Study Resources Guide](../../../../.templates/resources-aws.md)**

### Quick Links (AIP-C01 Specific)
- **📖 [AIP-C01 Exam Page](https://aws.amazon.com/certification/certified-generative-ai-developer-professional/)** - Registration
- **📖 [AWS Skill Builder](https://skillbuilder.aws/)** - FREE GenAI exam prep courses
- **📖 [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)** - Service docs
- **📖 [Amazon Bedrock Workshop](https://catalog.workshops.aws/amazon-bedrock-workshop)** - Hands-on labs
- **📖 [AWS Free Tier](https://aws.amazon.com/free/)** - Hands-on practice

### Recommended Training
- **📖 [AWS Skill Builder - Generative AI Learning Plan](https://skillbuilder.aws/)** - Structured learning path
- **📖 [Amazon Bedrock Getting Started](https://docs.aws.amazon.com/bedrock/latest/userguide/getting-started.html)** - Quick start guide
- **📖 [Generative AI on AWS Workshop](https://catalog.workshops.aws/generative-ai-on-aws)** - Comprehensive hands-on

---

## 📊 Progress Tracker

### Weekly Completion
- [ ] Week 1: GenAI Foundations & Bedrock Overview
- [ ] Week 2: Foundation Model Selection & Implementation
- [ ] Week 3: RAG and Knowledge Bases
- [ ] Week 4: Agents and Application Architecture
- [ ] Week 5: Prompt Engineering & Fine-Tuning
- [ ] Week 6: Evaluation, Metrics & Responsible AI
- [ ] Week 7: Security, Compliance & Cost Optimization
- [ ] Week 8: Review & Practice Exams

### Practice Exam Scores
- [ ] Practice Exam 1: ___% (Target: 70%+)
- [ ] Practice Exam 2: ___% (Target: 80%+)
- [ ] Official Practice Exam: ___% (Target: 85%+)

### Key Hands-on Labs Completed
- [ ] Invoked models via Bedrock APIs (InvokeModel, Converse, Streaming)
- [ ] Built a RAG application with Bedrock Knowledge Bases
- [ ] Created a Bedrock Agent with action groups and Lambda
- [ ] Configured Guardrails for content safety
- [ ] Set up VPC endpoints and IAM policies for Bedrock
- [ ] Ran model evaluation jobs on Bedrock
- [ ] Designed a multi-step GenAI workflow with Step Functions

Good luck on your AIP-C01 certification journey! 🚀
