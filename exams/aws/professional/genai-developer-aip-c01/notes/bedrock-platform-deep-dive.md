# Amazon Bedrock Platform Deep-Dive

> **Cross-cutting deep-dive.** Bedrock is the single most-tested service surface on the AIP-C01. Every domain references it. This note unifies all Bedrock features the exam touches into one reference.

## Table of contents

- [The Bedrock surface area](#the-bedrock-surface-area)
- [Foundation models on Bedrock](#foundation-models-on-bedrock)
- [APIs: Invoke, Converse, Streaming](#apis-invoke-converse-streaming)
- [Provisioned Throughput, Cross-Region Inference, Batch](#provisioned-throughput-cross-region-inference-batch)
- [Customization: Fine-tuning + Continued Pre-training](#customization-fine-tuning--continued-pre-training)
- [Bedrock Knowledge Bases](#bedrock-knowledge-bases)
- [Bedrock Guardrails](#bedrock-guardrails)
- [Bedrock Agents](#bedrock-agents)
- [Bedrock AgentCore](#bedrock-agentcore)
- [Bedrock Prompt Management](#bedrock-prompt-management)
- [Bedrock Prompt Flows](#bedrock-prompt-flows)
- [Bedrock Model Evaluation](#bedrock-model-evaluation)
- [Bedrock Data Automation](#bedrock-data-automation)
- [Bedrock Studio + Playground](#bedrock-studio--playground)
- [Bedrock observability and security](#bedrock-observability-and-security)
- [Bedrock pricing model](#bedrock-pricing-model)
- [Quick-recall summary](#quick-recall-summary)

## The Bedrock surface area

Bedrock is a **family of services** under one banner. Memorize what each piece does and how they fit together:

```
                   +-----------------------------+
                   |     Bedrock (root API)      |
                   |  InvokeModel / Converse     |
                   +-------------+---------------+
                                 |
       +-------------+-----------+-----------+--------------+--------------+
       |             |           |           |              |              |
       v             v           v           v              v              v
  Knowledge       Guardrails    Agents    AgentCore     Prompt Mgmt    Prompt Flows
  Bases (RAG)     (safety)     (managed)  (production)  (templates)    (orchestration)
       |             |           |           |              |              |
       +-------------+-----------+-----------+--------------+--------------+
                                 |
                                 v
                +-----------------------------------+
                | Cross-cutting:                    |
                | - Model Evaluation                |
                | - Data Automation                 |
                | - Studio / Playground             |
                | - Provisioned Throughput          |
                | - Cross-Region Inference          |
                | - Model Invocation Logs           |
                +-----------------------------------+
```

## Foundation models on Bedrock

Providers (the exam expects you to recognize them by name):

| Provider | Models in scope | Strengths |
|----------|-----------------|-----------|
| **Anthropic** | Claude 3 / 3.5 / 3.7 family (Haiku, Sonnet, Opus); Claude 4 family | Strong reasoning, tool use, vision (multimodal), large context (200K+ tokens) |
| **Amazon** | **Titan Text** (G1 family), **Titan Text Embeddings v2**, **Titan Multimodal Embeddings**, **Titan Image Generator**, **Amazon Nova** family (Micro, Lite, Pro, Premier; multimodal) | First-party; cost-effective; deep AWS integration |
| **AI21 Labs** | Jamba family | Long context |
| **Cohere** | Command R / R+; Embed (English, Multilingual); Rerank | Retrieval-optimized; reranking |
| **Meta** | Llama 3.1 / 3.2 / 3.3 (8B / 70B / 405B / Vision) | Open-weight; popular for fine-tuning |
| **Mistral** | Mistral Small / Large / 8x7B / 8x22B | Open-weight; cost-effective for code |
| **Stability AI** | Stable Diffusion family | Image generation |

**Choosing a model** (decision factors):
- Task fit (text, image, embedding, code, multimodal)
- Quality (benchmarks + your eval set)
- Latency
- Cost per token
- Context window
- Tool use / function calling support quality
- Region availability
- Customization options

Common fast/cheap options: Anthropic **Haiku**, **Nova Micro / Lite**, Mistral **Small**.
Common quality options: Anthropic **Sonnet** / **Opus**, **Nova Pro / Premier**, Llama **70B / 405B**.

## APIs: Invoke, Converse, Streaming

| API | Purpose |
|-----|---------|
| **InvokeModel** | Provider-specific raw API. JSON body schema differs per provider. |
| **InvokeModelWithResponseStream** | Streaming version of InvokeModel. |
| **Converse** | **Unified conversation API** across providers. Same shape regardless of model. |
| **ConverseStream** | Streaming version of Converse. |
| **GetFoundationModel / ListFoundationModels** | Model catalog APIs. |
| **CreateModelInvocationJob (batch)** | Batch inference over S3 inputs. |
| **CreateModelCustomizationJob** | Fine-tuning / continued pre-training. |

**Converse API conveniences (exam-relevant)**:
- Uniform `messages` array with `role` and `content`
- Native tool use config (`toolConfig`)
- Native system prompt (`system`)
- Native inference config (`inferenceConfig`: `temperature`, `topP`, `topK`, `maxTokens`, `stopSequences`)
- Native multimodal content blocks (text + image + video + document)
- Native Guardrails reference
- Returns standardized usage tokens (input / output / total)

**Use Converse over InvokeModel** unless you need provider-specific features not yet exposed in Converse.

## Provisioned Throughput, Cross-Region Inference, Batch

### On-demand vs Provisioned Throughput

| Mode | Billing | When |
|------|---------|------|
| **On-demand** | Pay per token | Default. Bursty, unpredictable, low-mid volume. |
| **Provisioned Throughput** | Pay per **model unit** per hour, with optional 1-month or 6-month commitment | Predictable / sustained traffic, SLA-required, **and required to invoke fine-tuned models on Bedrock**. |

Provisioned Throughput buys you a **model unit (MU)** which guarantees throughput (model-dependent: TPM tokens-per-minute, RPM requests-per-minute). Scale by buying more MUs.

### Cross-Region Inference

A managed feature where AWS automatically routes inference requests to alternate Regions to handle traffic surges and improve resilience.

How it works:
- You target an **inference profile** (a logical handle that maps to a model across multiple Regions).
- Bedrock routes the request to the best available Region (capacity, latency).
- Single API call from your perspective.

Use cases:
- Bursty workloads where a single Region might throttle
- HA / DR for FM access
- Models with limited regional availability

Distinguish from manual cross-Region failover (where you implement retry logic in your code) - **Cross-Region Inference is the managed pattern**.

### Batch inference

`CreateModelInvocationJob` runs an inference job over an S3 input dataset, writes results to S3.

When to use:
- Async processing of many records (e.g., classify 10M support tickets)
- Cost-sensitive (batch is cheaper than on-demand per-token in many cases)
- Latency doesn't matter

## Customization: Fine-tuning + Continued Pre-training

| Mode | Description | Bedrock support |
|------|-------------|-----------------|
| **Fine-tuning** | Supervised training on your labeled examples. Adapts model behavior. | Supported for select Bedrock models (Anthropic Haiku, Llama, Cohere, Titan) |
| **Continued pre-training** | Unsupervised training on your domain corpus. Adapts vocabulary / domain knowledge. | Supported for select Titan models |
| **LoRA / parameter-efficient adapters** | Train a small adapter matrix instead of full weights. | Available via SageMaker AI; not exposed in Bedrock as a first-class option |

Workflow on Bedrock:
1. Prepare dataset in S3 (JSONL, model-specific schema)
2. Call `CreateModelCustomizationJob`
3. Bedrock trains a private fine-tuned copy
4. Job completes → custom model ARN
5. **Purchase Provisioned Throughput** to invoke the custom model (this is mandatory; no on-demand for custom models)

**SageMaker Model Registry** complements this for governance:
- Register fine-tuned model artifacts as model packages
- Approval status (Pending / Approved / Rejected)
- CI/CD pipelines deploy on Approved
- Roll back by deploying prior version

## Bedrock Knowledge Bases

Managed RAG. See [RAG deep-dive](rag-architecture-deep-dive.md) for the full pipeline.

Capabilities:
- **Data sources** (connectors): S3, Web Crawler, Confluence, SharePoint, Salesforce, custom
- **Chunking strategies**: default, fixed-size, hierarchical, semantic, no chunking
- **Embedding models**: Titan v2, Titan Multimodal, Cohere Embed
- **Vector stores**: OpenSearch Serverless (default), Aurora pgvector, MongoDB Atlas, Pinecone, Redis Enterprise, Neptune Analytics
- **Retrieve API** - returns top-K chunks for a query
- **RetrieveAndGenerate API** - retrieve + invoke FM with retrieved context, returns response with citations
- **Metadata filters** at query time (`retrievalConfiguration.vectorSearchConfiguration.filter`)
- **Hybrid search** (`searchType: HYBRID`)
- **Reranking** with Bedrock reranker models
- **Multimodal data** (images, charts, audio) via Bedrock Data Automation pre-processing
- **Knowledge Base evaluations** for retrieval and generation quality
- **Sync API** for incremental ingestion + scheduled refresh

When to use Knowledge Bases vs roll-your-own:
- Use Knowledge Bases unless you have specific reason to roll your own (custom chunking logic, custom embedding, etc.).

## Bedrock Guardrails

The orthogonal safety layer applied to any Bedrock model invocation.

Six types of policies:

| Policy | Purpose |
|--------|---------|
| **Content filters** | Block harmful categories (hate, insults, sexual, violence, misconduct, prompt attacks). Severity thresholds: NONE, LOW, MEDIUM, HIGH. |
| **Denied topics** | Custom topics you define ("legal advice", "medical diagnosis", competitor names). The guardrail blocks discussion of those topics. |
| **Word filters** | Block specific words/phrases (profanity, internal codenames). |
| **Sensitive information filters** | Detect and either block or mask PII (SSN, credit card, email, etc.) and custom regex patterns. |
| **Contextual grounding check** | Ensure the model's response is grounded in (faithful to) provided context. Filters out hallucinated/ungrounded responses. Configurable threshold. |
| **Image content filters** | Apply filters to image inputs/outputs (in supported models). |

Application:
- **At invocation time** via `guardrailIdentifier` and `guardrailVersion` in InvokeModel / Converse.
- **Inline with Bedrock Agents** by associating a guardrail with the agent.
- **Inline with Knowledge Bases RetrieveAndGenerate** by passing the guardrail identifier.
- **Independently** via `ApplyGuardrail` API to validate any text without invoking a model.

Guardrails work on **both input and output**:
- Input: filter user input before it reaches the model (prompt injection defense)
- Output: filter model output before returning to user

## Bedrock Agents

Managed agentic runtime. See [Agentic AI systems deep-dive](agentic-ai-systems.md) for the full pattern reference.

Features:
- **Action groups**: Lambda functions or OpenAPI-defined APIs as the agent's tools
- **Knowledge Base association** for built-in RAG
- **Guardrails association** for safety on every model invocation
- **Prompt overrides** at each agent stage (pre-processing, orchestration, knowledge base, post-processing)
- **Agent versions and aliases**
- **Trace** of reasoning + tool calls + observations
- **Session state** for multi-turn memory
- **Return of control** to caller for client-side actions
- **Memory** (legacy; AgentCore Memory is the newer managed memory layer)
- **Multi-agent collaboration** (a supervisor agent invoking sub-agents)

## Bedrock AgentCore

Production-grade agent runtime. Components:
- **AgentCore Runtime** - secure isolated execution
- **AgentCore Memory** - managed semantic + episodic memory
- **AgentCore Identity** - per-agent IAM-style identity for fine-grained access
- **AgentCore Gateway** - bridges to enterprise tools (MCP, OpenAPI)
- **AgentCore Browser** - sandboxed browser tool
- **AgentCore Code Interpreter** - sandboxed code execution
- **AgentCore Observability** - tracing, metrics, logs

Decision: **Bedrock Agents** for fastest path; **AgentCore** when you need production-grade scale, observability, identity, browser/code interpreter as built-in tools.

## Bedrock Prompt Management

Centralized prompt template repository.

Features:
- **Parameterized templates** with `{{variables}}`
- **Versioning** - immutable versions
- **Aliases** to point at versions (e.g., `prod`, `staging`)
- **Approval workflows** - status gates before promotion
- **Test in console** before saving
- **Reusable across agents and Prompt Flows**

When to use vs putting prompts in S3 / repo:
- Choose Prompt Management when you need first-class prompt versioning, approval, and reuse across multiple Bedrock features.
- S3-versioned files are fine for simple cases.

## Bedrock Prompt Flows

Visual / no-code prompt orchestration.

Capabilities:
- **Sequential prompt chains**: output of one prompt feeds into the next
- **Conditional branching** based on classifier outputs (e.g., route by intent)
- **Reusable prompt components** (call existing Prompt Management templates)
- **Pre / post-processing nodes**: invoke Lambda or AWS service calls in-flow
- **Knowledge Base nodes**: in-flow retrieval
- **Versioning + alias deployment**

When to choose Prompt Flows vs Step Functions:
- **Prompt Flows**: prompt-centric workflows, non-developer authors, built-in Bedrock integration, simpler authoring
- **Step Functions**: developer-built, full AWS service access, complex error handling, long-running

## Bedrock Model Evaluation

Built-in evaluation jobs.

Three types:

| Type | Description |
|------|-------------|
| **Automatic** | Pre-built tasks (Q&A, summarization, classification, text generation) with built-in metrics |
| **Human** | Workforce (your team or AWS-managed) reviews and rates outputs |
| **LLM-as-judge** | A judge FM scores the outputs of a candidate model on your rubric |

Evaluation supports:
- **Single-model** evaluation (test one model on your data)
- **Multi-model comparison** (run two models head-to-head)
- **RAG evaluation** specifically for Knowledge Bases (retrieval and generation metrics)

Outputs report cards with metric scores, qualitative judge feedback, and links to traces.

## Bedrock Data Automation (BDA)

End-to-end document understanding without writing the pipeline.

Inputs: PDF, image, audio, video.
Outputs: structured insights (text, summary, entities, classifications, custom-defined fields, transcripts, scene descriptions).

Features:
- **Blueprints** define what fields to extract from a class of documents (invoices, contracts, etc.)
- Multimodal: handles documents with mixed text, images, charts
- Replaces hand-built pipelines of Textract + Transcribe + Comprehend + Lambda

When to use:
- Document processing workloads where you want managed extraction
- Knowledge Base ingestion of complex docs (BDA pre-processes; KB indexes)

## Bedrock Studio + Playground

| Tool | Purpose |
|------|---------|
| **Playground** | Console-based testing of prompts against any Bedrock model. Compare outputs side-by-side. |
| **Studio** | Workspace where teams build and share GenAI apps without code; integrates Knowledge Bases, Prompt Flows, Guardrails. |

Both are POC / experimentation accelerators. The exam mentions Bedrock for POCs (skill 1.1.2).

## Bedrock observability and security

| Concern | Service / feature |
|---------|-------------------|
| **API call audit** | **AWS CloudTrail** management + data events for Bedrock |
| **Per-invocation logs (prompt + response)** | **Bedrock Model Invocation Logs** to S3 and/or CloudWatch Logs |
| **Metrics (token usage, latency, errors)** | **Amazon CloudWatch** (Bedrock namespace) |
| **Distributed traces** | **AWS X-Ray** (instrument your Lambda / API Gateway) |
| **Network isolation** | **VPC endpoints (PrivateLink)** for Bedrock - keep traffic off the public internet |
| **Encryption at rest** | **AWS KMS** customer-managed keys for fine-tuned model artifacts and Knowledge Base data |
| **Encryption in transit** | TLS by default; private connectivity via VPC endpoints |
| **Access control** | IAM with `bedrock:InvokeModel`, `bedrock:Retrieve`, etc. ABAC via tags. |
| **Data privacy** | By default, AWS does not use your inputs/outputs to train provider models. |

## Bedrock pricing model

Cost categories (the exam asks scenario questions about cost levers):

| Category | Lever |
|----------|-------|
| **On-demand inference** | Per input token + per output token, model-dependent |
| **Batch inference** | Lower per-token cost than on-demand |
| **Provisioned Throughput** | Per model unit per hour; commit terms reduce cost |
| **Custom (fine-tuned) model invocation** | Provisioned Throughput required (no on-demand) |
| **Knowledge Base ingestion** | Per token of embedding + storage cost on backing vector DB |
| **Knowledge Base retrieval** | Per Retrieve / RetrieveAndGenerate call + downstream FM tokens |
| **Guardrails** | Per text unit of input/output evaluated |
| **Prompt caching** | Reduces input token cost for repeated prefix portions of prompts |
| **Cross-Region Inference** | Same as base model pricing; doesn't increase cost |

Cost-reduction tactics (Domain 4):
- Smaller / cheaper model when quality permits
- Model cascading (cheap → expensive escalation)
- **Prompt caching** for repeated system prompts / context
- Semantic caching at the application layer (cache responses for similar queries)
- Batch inference for non-interactive workloads
- Provisioned Throughput when sustained traffic justifies the commit

## Quick-recall summary

- Bedrock = umbrella over: model APIs, Knowledge Bases, Guardrails, Agents, AgentCore, Prompt Management, Prompt Flows, Model Evaluation, Data Automation, Studio/Playground.
- Providers in scope: Anthropic, Amazon (Titan, Nova), AI21, Cohere, Meta (Llama), Mistral, Stability.
- **Converse API** is unified across providers; prefer it over InvokeModel.
- Streaming: **InvokeModelWithResponseStream / ConverseStream**.
- **Provisioned Throughput** = per-MU per-hour, predictable workloads, **mandatory for custom fine-tuned models**.
- **Cross-Region Inference** = managed routing across Regions for resilience / capacity.
- **Batch inference** for cheaper async over S3.
- Customization: fine-tune (select models), continued pre-training (Titan), or LoRA via SageMaker.
- **Knowledge Bases**: managed RAG; connectors (S3, Web Crawler, Confluence, SharePoint, Salesforce, custom); chunking; embeddings (Titan/Cohere); vector stores (OpenSearch Serverless default, Aurora pgvector, etc.); Retrieve and RetrieveAndGenerate APIs; metadata filters; HYBRID search; reranking.
- **Guardrails** policies: content, denied topics, word, sensitive info, contextual grounding, image. Apply on input + output. `ApplyGuardrail` for standalone validation.
- **Bedrock Agents**: action groups, KB assoc, Guardrails assoc, prompt overrides, versions/aliases, trace, session state, return of control.
- **AgentCore**: Runtime, Memory, Identity, Gateway, Browser, Code Interpreter, Observability - production runtime.
- **Prompt Management**: parameterized templates, versions, aliases, approval workflows.
- **Prompt Flows**: visual no-code orchestration; chains, branching, KB nodes, Lambda nodes.
- **Model Evaluation**: automatic, human, LLM-as-judge; single or multi-model; RAG-specific.
- **Data Automation (BDA)**: end-to-end PDF/image/audio/video → structured.
- **Studio / Playground** for POC and team workspaces.
- Observability: **CloudTrail**, **Model Invocation Logs**, CloudWatch metrics, X-Ray traces.
- Security: **VPC endpoints**, IAM, KMS, default no-train-on-customer-data.
- Cost levers: model choice, cascading, prompt caching, semantic caching, batch, Provisioned Throughput commits.
