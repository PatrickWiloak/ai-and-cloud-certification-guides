# Databricks Certified Generative AI Engineer Associate

## Exam Overview

The Databricks Certified Generative AI Engineer Associate certification validates the ability to design and implement generative AI solutions on the Databricks platform, with a heavy focus on Retrieval-Augmented Generation (RAG) applications. This certification covers Vector Search, Foundation Model APIs, prompt engineering, evaluation frameworks, and governance for GenAI applications.

**Exam Details:**
- **Exam Code:** Databricks Certified Generative AI Engineer Associate
- **Duration:** 90 minutes
- **Number of Questions:** 45 multiple-choice questions
- **Passing Score:** 70% (approximately 32 correct answers)
- **Cost:** $200 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (familiarity with LLMs and Databricks recommended)

## Exam Domains

### Domain 1: RAG Application Design (30%)
- Design RAG application architectures
- Select appropriate chunking and embedding strategies
- Design retrieval pipelines
- Understand RAG tradeoffs and patterns

**Key Concepts:**
- RAG architecture components (retriever, generator, knowledge base)
- Document chunking strategies (fixed-size, semantic, recursive)
- Chunk size and overlap tradeoffs
- Embedding model selection and considerations
- Vector database design and indexing
- Hybrid search (dense + sparse retrieval)
- Re-ranking strategies
- Multi-step RAG and agentic RAG patterns
- Context window management
- RAG vs fine-tuning decision criteria

### Domain 2: RAG Application Implementation (30%)
- Implement RAG pipelines on Databricks
- Use Vector Search for retrieval
- Integrate Foundation Model APIs
- Build end-to-end RAG applications

**Key Concepts:**
- Databricks Vector Search setup and configuration
- Delta Sync Index vs Direct Vector Access Index
- Embedding computation and storage
- Foundation Model APIs (pay-per-token and provisioned throughput)
- External model endpoints (OpenAI, Anthropic, etc.)
- Mosaic AI Agent Framework
- LangChain integration on Databricks
- Prompt engineering for RAG (system prompts, few-shot)
- Chain deployment and serving
- MLflow for GenAI (tracing, logging)

### Domain 3: Governance and Evaluation (20%)
- Evaluate RAG application quality
- Implement governance for GenAI
- Monitor GenAI applications
- Handle safety and compliance

**Key Concepts:**
- RAG evaluation metrics (relevance, faithfulness, answer quality)
- Mosaic AI Agent Evaluation framework
- LLM-as-judge evaluation patterns
- Human evaluation workflows
- Data governance for GenAI (PII, sensitive data)
- Unity Catalog for model and data governance
- Guardrails and safety filters
- Cost management for LLM usage
- Inference table logging
- A/B testing for GenAI applications

### Domain 4: LLM Fundamentals (20%)
- Understand large language model concepts
- Select appropriate models for use cases
- Understand prompt engineering principles
- Know LLM limitations and mitigation strategies

**Key Concepts:**
- Transformer architecture fundamentals
- Token-based processing and context windows
- Temperature, top-p, and generation parameters
- Prompt engineering techniques (zero-shot, few-shot, chain-of-thought)
- Foundation models available on Databricks (DBRX, Llama, etc.)
- Model selection criteria (size, latency, cost, quality)
- Hallucination causes and mitigation
- Fine-tuning vs RAG vs prompt engineering
- Instruction tuning and RLHF concepts
- Multi-modal model awareness

## Key Concepts to Master

### RAG Architecture
- Document processing pipeline (ingest, chunk, embed, index)
- Retrieval strategies (similarity search, MMR, filtered search)
- Generation with retrieved context
- End-to-end latency optimization
- Error handling and fallback strategies

### Databricks GenAI Stack
- Vector Search (managed service on Databricks)
- Foundation Model APIs (serving layer)
- Mosaic AI Agent Framework (building agents)
- Mosaic AI Agent Evaluation (quality assessment)
- MLflow Tracing (observability)
- Unity Catalog (governance)

### Evaluation and Quality
- Component-level evaluation (retriever, generator)
- End-to-end evaluation (answer quality)
- Automated evaluation with LLMs
- Evaluation datasets and ground truth
- Continuous monitoring of GenAI applications

## Study Approach

### Phase 1: Foundation (Week 1-2)
1. Review LLM fundamentals and transformer concepts
2. Understand RAG architecture and design patterns
3. Learn Databricks Vector Search capabilities
4. Study Foundation Model APIs and available models

### Phase 2: Implementation (Week 3-4)
1. Build a RAG application on Databricks
2. Practice Vector Search indexing and querying
3. Learn Mosaic AI Agent Framework
4. Study evaluation and governance patterns

### Phase 3: Exam Prep (Week 5-6)
1. Take practice exams and review incorrect answers
2. Focus on RAG design and implementation (60% of exam)
3. Review evaluation frameworks and governance
4. Practice scenario-based questions

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - GenAI learning paths
- **[Exam Guide](https://www.databricks.com/learn/certification/genai-engineer-associate)** - Official exam page
- **[Vector Search Documentation](https://docs.databricks.com/en/generative-ai/vector-search.html)** - Vector Search guide
- **[Foundation Model APIs](https://docs.databricks.com/en/machine-learning/foundation-models/index.html)** - Model serving docs
- **[Mosaic AI Documentation](https://docs.databricks.com/en/generative-ai/agent-framework/index.html)** - Agent framework guide
- **[RAG Tutorial](https://docs.databricks.com/en/generative-ai/tutorials/ai-cookbook/index.html)** - Hands-on RAG guide

## Tips for Success

1. **RAG dominates the exam** - 60% covers RAG design and implementation
2. **Know Vector Search deeply** - Delta Sync Index vs Direct Vector Access Index
3. **Chunking strategies matter** - Understand tradeoffs of different approaches
4. **Evaluation is critical** - Know how to assess RAG quality systematically
5. **Foundation Model APIs** - Know pay-per-token vs provisioned throughput
6. **Governance for GenAI** - PII handling, safety filters, and compliance
7. **Prompt engineering** - Practical techniques, not just theory
8. **Mosaic AI tools** - Agent Framework and Agent Evaluation
9. **Hands-on practice** - Build at least one RAG application on Databricks
10. **LLM limitations** - Know hallucination causes and mitigation strategies

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | 5-week study schedule with checkboxes |
| [notes/01-rag-design.md](notes/01-rag-design.md) | RAG application architecture and design |
| [notes/02-rag-implementation.md](notes/02-rag-implementation.md) | Building RAG on Databricks |
| [notes/03-governance-evaluation.md](notes/03-governance-evaluation.md) | Evaluation and governance |
