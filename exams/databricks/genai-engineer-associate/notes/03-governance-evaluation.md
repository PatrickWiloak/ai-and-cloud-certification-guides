# Governance and Evaluation - Databricks GenAI Engineer Associate

## Overview

This section covers governance and evaluation for GenAI applications, representing 20% of the exam. You need to understand RAG evaluation metrics, LLM-as-judge patterns, guardrails, and GenAI governance.

**[📖 Agent Evaluation](https://docs.databricks.com/en/generative-ai/agent-evaluation/index.html)** - Evaluation framework
**[📖 AI Governance](https://docs.databricks.com/en/generative-ai/governance.html)** - GenAI governance

## Key Topics

### 1. RAG Evaluation Dimensions

| Dimension | What It Measures | Example Question |
|-----------|-----------------|------------------|
| Retrieval quality | Are the right documents retrieved? | Did we find relevant passages? |
| Answer relevance | Does the answer address the question? | Is the response on-topic? |
| Faithfulness/groundedness | Is the answer supported by context? | Does the answer match retrieved docs? |
| Answer correctness | Is the answer factually correct? | Does it match the ground truth? |

**Key Concepts:**
- Retrieval quality is evaluated separately from generation quality
- A good retriever with a poor generator produces grounded but poorly written answers
- A poor retriever with a good generator produces fluent but potentially hallucinated answers
- Evaluate both components independently to identify bottlenecks

### 2. Mosaic AI Agent Evaluation

**[📖 Agent Evaluation](https://docs.databricks.com/en/generative-ai/agent-evaluation/index.html)** - Evaluation framework

```python
import mlflow

# Evaluate RAG chain
eval_results = mlflow.evaluate(
    model=rag_chain,
    data=eval_dataset,
    model_type="databricks-agent"
)

# View metrics
print(eval_results.metrics)
```

**Key Concepts:**
- Automated evaluation using LLM-as-judge approach
- LLM judges assess quality dimensions (relevance, faithfulness, correctness)
- Evaluation datasets contain questions with optional ground truth answers
- Per-request quality scores for granular analysis
- Human evaluation workflows for subjective quality assessment
- Custom evaluation metrics for domain-specific quality requirements

### 3. LLM-as-Judge Pattern

**Key Concepts:**
- A powerful LLM evaluates the output of the RAG system
- Judge LLM receives the question, retrieved context, and generated answer
- Produces scores for each evaluation dimension
- More scalable than human evaluation but less accurate for nuanced judgments
- Combine with human evaluation for high-stakes applications
- Judge model should be at least as capable as the generation model

### 4. MLflow Evaluate for GenAI

**[📖 MLflow Evaluate](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html)** - LLM evaluation

```python
import mlflow

# Evaluate with specific metrics
results = mlflow.evaluate(
    model=rag_chain,
    data=eval_df,
    model_type="databricks-agent",
    evaluator_config={
        "databricks-agent": {
            "metrics": ["groundedness", "relevance", "answer_correctness"]
        }
    }
)
```

**Available Metrics:**
| Metric | What It Measures |
|--------|-----------------|
| answer_correctness | Factual accuracy against ground truth |
| faithfulness | Answer supported by retrieved context |
| relevance | Answer addresses the question |
| chunk_relevance | Retrieved chunks are relevant to the query |

### 5. Guardrails and Safety

**Key Concepts:**
- Input guardrails: filter or modify user inputs before processing
- Output guardrails: filter or modify model outputs before returning
- Content filtering: block harmful, inappropriate, or off-topic content
- PII detection and redaction in inputs and outputs
- Prompt injection awareness: sanitize user inputs to prevent manipulation
- Topic boundaries: constrain the model to answer only domain-relevant questions

**Common Guardrail Types:**
| Type | Purpose |
|------|---------|
| Input validation | Check for malicious prompts, PII, off-topic queries |
| Output filtering | Remove harmful content, PII, or hallucinated information |
| Token limits | Prevent excessive cost from long prompts or responses |
| Rate limiting | Protect against abuse and control costs |

### 6. GenAI Governance

**[📖 AI Governance](https://docs.databricks.com/en/generative-ai/governance.html)** - Governance patterns

**Key Concepts:**
- Unity Catalog governs models, data, and feature assets
- PII detection and handling in training data and embeddings
- Data lineage tracks which documents are embedded in the vector store
- Inference table logging captures all requests and responses for audit
- Cost management: monitor token usage and compute costs
- Data retention policies for inference logs and conversation history
- Compliance: audit logging for all GenAI requests

### 7. Cost Management for GenAI

**Key Concepts:**
- Token costs vary significantly between models (larger models cost more)
- Monitor input and output token counts per request
- Optimize prompt length to reduce costs (concise system prompts)
- Use smaller models for simple tasks, larger models for complex tasks
- Caching repeated queries can reduce token costs
- Set max_tokens to prevent unexpectedly long responses

## Exam Tips for This Domain

1. **Evaluation dimensions** - Know faithfulness, relevance, groundedness, correctness
2. **LLM-as-judge** - Understand automated evaluation and its limitations
3. **Guardrails** - Input/output filtering, PII handling, prompt injection
4. **mlflow.evaluate** - Know how to evaluate RAG chains with agent metrics
5. **Governance** - Unity Catalog for models, inference table logging for audit
6. **Cost management** - Token monitoring, model selection, prompt optimization

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Agent Evaluation | [docs.databricks.com/en/generative-ai/agent-evaluation/index.html](https://docs.databricks.com/en/generative-ai/agent-evaluation/index.html) |
| MLflow Evaluate | [mlflow.org/docs/latest/llms/llm-evaluate/index.html](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html) |
| AI Governance | [docs.databricks.com/en/generative-ai/governance.html](https://docs.databricks.com/en/generative-ai/governance.html) |
