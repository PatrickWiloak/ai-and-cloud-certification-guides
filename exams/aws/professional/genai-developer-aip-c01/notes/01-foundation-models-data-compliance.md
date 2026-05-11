# Domain 1: Foundation Model Integration, Data Management, and Compliance (31%)

> **The largest domain. Master this and you've covered nearly a third of the exam.**
>
> This domain is about taking foundation models from "API call" to "production system." It tests architecture decisions, FM selection, data pipelines, vector stores, retrieval (RAG), and prompt engineering as a discipline.

## Table of contents

- [Exam tasks and skills (verbatim from official guide)](#exam-tasks-and-skills)
- [Task 1.1: Analyze requirements and design GenAI solutions](#task-11-analyze-requirements-and-design-genai-solutions)
- [Task 1.2: Select and configure FMs](#task-12-select-and-configure-fms)
- [Task 1.3: Implement data validation and processing pipelines](#task-13-implement-data-validation-and-processing-pipelines)
- [Task 1.4: Design and implement vector store solutions](#task-14-design-and-implement-vector-store-solutions)
- [Task 1.5: Design retrieval mechanisms for FM augmentation (RAG)](#task-15-design-retrieval-mechanisms-for-fm-augmentation-rag)
- [Task 1.6: Implement prompt engineering strategies and governance](#task-16-implement-prompt-engineering-strategies-and-governance)
- [Gotchas and exam traps](#gotchas-and-exam-traps)
- [Quick-recall summary](#quick-recall-summary)

## Exam tasks and skills

### Task 1.1: Analyze requirements and design GenAI solutions
- **1.1.1** Create comprehensive architectural designs aligned with business needs and technical constraints (FM choice, integration patterns, deployment strategies).
- **1.1.2** Develop technical proof-of-concept implementations to validate feasibility, performance, and business value (e.g., Bedrock).
- **1.1.3** Create standardized technical components for consistent implementation across deployments (Well-Architected Framework, Generative AI Lens).

### Task 1.2: Select and configure FMs
- **1.2.1** Assess and choose FMs for use case fit (perf benchmarks, capability analysis, limitations).
- **1.2.2** Create flexible architecture for dynamic model selection / provider switching without code changes (Lambda, API Gateway, AppConfig).
- **1.2.3** Design resilient AI systems for service disruptions (Step Functions circuit breaker, Bedrock Cross-Region Inference, cross-Region deployment, graceful degradation).
- **1.2.4** Implement FM customization deployment and lifecycle (SageMaker AI for fine-tuned models, LoRA / adapters, SageMaker Model Registry, automated deployment, rollback, retire/replace).

### Task 1.3: Implement data validation and processing pipelines for FM consumption
- **1.3.1** Comprehensive data validation workflows (Glue Data Quality, SageMaker Data Wrangler, Lambda, CloudWatch metrics).
- **1.3.2** Data processing for text/image/audio/tabular for FM consumption (Bedrock multimodal, SageMaker Processing, Transcribe, multimodal pipelines).
- **1.3.3** Format input for FM inference per model-specific requirements (JSON for Bedrock, structured data for SageMaker AI endpoints, conversation formatting).
- **1.3.4** Enhance input data quality (Bedrock to reformat, Comprehend for entities, Lambda for normalization).

### Task 1.4: Design and implement vector store solutions
- **1.4.1** Vector DB architectures for FM augmentation (Bedrock Knowledge Bases, OpenSearch Service Neural plugin, RDS + S3, DynamoDB + vector DB).
- **1.4.2** Metadata frameworks for search precision (S3 object metadata, custom attributes, tagging).
- **1.4.3** High-performance vector DB at scale (OpenSearch sharding, multi-index, hierarchical indexing).
- **1.4.4** Integration components to connect knowledge sources (DMS, internal wikis).
- **1.4.5** Data maintenance for current/accurate vector stores (incremental updates, real-time change detection, automated sync, scheduled refresh).

### Task 1.5: Design retrieval mechanisms for FM augmentation
- **1.5.1** Document segmentation / chunking (Bedrock chunking, Lambda fixed-size, hierarchical chunking by content structure).
- **1.5.2** Embedding solutions (Titan embeddings, dimensionality and domain fit, batch embedding via Lambda).
- **1.5.3** Vector search deployment (OpenSearch with vector, Aurora pgvector, Bedrock Knowledge Bases managed).
- **1.5.4** Advanced search (semantic in OpenSearch, hybrid keyword+vector, Bedrock reranker models).
- **1.5.5** Query handling (Bedrock query expansion, Lambda query decomposition, Step Functions query transformation).
- **1.5.6** Consistent access for FM integration (function calling for vector search, MCP clients, standardized API patterns).

### Task 1.6: Implement prompt engineering strategies and governance
- **1.6.1** Model instruction frameworks (Bedrock Prompt Management for role definitions, Bedrock Guardrails, template configurations).
- **1.6.2** Interactive AI for context maintenance (Step Functions clarification, Comprehend intent recognition, DynamoDB conversation history).
- **1.6.3** Prompt management and governance (Bedrock Prompt Management with parameterized templates and approval flows, S3 template repos, CloudTrail audit, CloudWatch Logs).
- **1.6.4** Quality assurance for prompts (Lambda for expected-output verification, Step Functions for edge cases, CloudWatch for prompt regression).
- **1.6.5** Iterative prompt refinement (structured input, output format specs, chain-of-thought, feedback loops).
- **1.6.6** Complex prompt systems (Bedrock Prompt Flows for sequential chains, conditional branching, reusable components, pre/post-processing).

---

## Task 1.1: Analyze requirements and design GenAI solutions

### Core concepts

**The GenAI design decision tree** (mental model for architecture questions):

1. **Is this a one-shot generative task or a knowledge-grounded task?** If knowledge-grounded → RAG. If one-shot → direct FM call.
2. **Does the task need tools, multi-step reasoning, or external system access?** If yes → agentic (Bedrock Agents, AgentCore, Strands). If no → single FM invocation.
3. **Does latency matter (interactive UX)?** If yes → streaming + smaller FM + caching. If no → batch / async.
4. **Is the data sensitive (PII, regulated)?** If yes → VPC endpoints + Guardrails + Macie + KMS. If no → standard Bedrock.
5. **Is the workload predictable in volume?** If yes → Bedrock Provisioned Throughput. If no → on-demand.
6. **Does response need to be deterministic?** If yes → low temperature + structured output (JSON Schema) + Guardrails contextual grounding. If no → tune temperature/top-p for creativity.

### AWS Well-Architected Generative AI Lens

The exam expects you to know the **Generative AI Lens** exists and that it extends the Well-Architected Framework with GenAI-specific guidance. Use it (and the Well-Architected Tool) when designing solutions. Pillar mappings stay the same (Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability) but each gets GenAI-specific best practices.

Related AWS frameworks worth knowing by name:
- **AWS Cloud Adoption Framework for AI/ML/GenAI (CAF-AI)** - org-level adoption
- **Generative AI Lifecycle Operational Excellence framework** - delivery / ops
- **AWS Prescriptive Guidance: Maturity model for adopting GenAI on AWS** - maturity assessment
- **AWS Prescriptive Guidance: Generative AI workload assessment** - per-workload review

### POC strategy with Bedrock

Why Bedrock for POCs:
- **No infrastructure**: API-only access to multiple model providers (Anthropic, AI21, Cohere, Meta, Stability, Mistral, Amazon Titan)
- **Quick model swapping**: change model ID, re-run, compare
- **Bedrock Playground / Bedrock Studio** for non-coders to test prompts
- **Bedrock Knowledge Bases** for fast RAG POCs without standing up your own vector DB

POC checklist for an exam scenario:
1. Pick the simplest FM that **could** work (start with Haiku/Nova Lite, escalate to Sonnet/Opus only if needed)
2. Use Bedrock Playground or `InvokeModel` with sample data
3. Quantify cost (tokens per query × queries per day × model price)
4. Quantify latency (p50/p95)
5. Quantify quality (small eval set, human or LLM-as-judge)
6. Decide go/no-go before scaling

### Standardized components

Repeatable, deployable building blocks - the pattern the exam wants you to recognize:

- **CDK / CloudFormation modules** for FM-backed services (one stack = "any team can deploy a Bedrock-backed API")
- **Reusable Bedrock Prompt Templates** stored in Bedrock Prompt Management or S3 with versioning
- **Reusable Bedrock Guardrails** applied to multiple agents / apps
- **Reusable Bedrock Prompt Flows** for shared multi-step orchestrations
- **Service Catalog products** for governance-approved patterns

---

## Task 1.2: Select and configure FMs

### How to pick a foundation model (the framework the exam tests)

Decision factors (in approximate order of weight):

1. **Task fit** - text generation, summarization, code, vision, audio, embedding, multimodal? Match capability.
2. **Quality** - benchmark scores on relevant tasks (MMLU, HumanEval, etc.) AND your eval set.
3. **Latency budget** - smaller models = faster (Haiku, Nova Lite, Mistral Small). Larger = better quality (Opus, Nova Pro, Llama 70B).
4. **Cost per token** - Haiku < Sonnet < Opus. Often a small model + good prompt beats a big model + bad prompt.
5. **Context window** - if you're stuffing long docs, you need 100K+ tokens (Claude 3+, Nova).
6. **Tool use / function calling** - Anthropic Claude, Cohere Command-R+, Llama 3.1+, Nova all support, but support quality varies.
7. **Region availability** - some models limited to certain regions; consider Bedrock Cross-Region Inference.
8. **Provider terms** - data retention, training opt-out (default with Bedrock: AWS does not use your inputs/outputs to train providers' models).
9. **Customization needs** - fine-tuning supported? continued pre-training supported? (Bedrock supports both for select models.)

### Flexible model selection (skill 1.2.2)

The pattern: **decouple model choice from application code**.

Reference architecture:

```
Client -> API Gateway -> Lambda
                          |
                          +-- AWS AppConfig: read current model_id (per env / canary group)
                          |
                          +-- Bedrock InvokeModel(model_id=...)
                          |
                          +-- Optional: Bedrock Cross-Region Inference profile for HA
```

Key services:
- **AWS AppConfig** holds the model selection (and other knobs: temperature, max tokens) as feature flags / config. Update without redeploy. Supports gradual rollout.
- **API Gateway** is the entry point and can shape requests / handle auth.
- **Lambda** reads AppConfig, calls Bedrock with the selected model_id.

This pattern shows up in scenarios where: "swap models without redeploying" or "A/B test two models" or "fall back to cheaper model under load."

### Resilient AI systems (skill 1.2.3)

Failure modes to design for:

| Failure | Mitigation |
|---------|-----------|
| FM throttled (too many requests) | Exponential backoff in SDK, retry with jitter |
| FM regional outage | **Bedrock Cross-Region Inference** (single API call, AWS routes to alternate Region automatically), or app-level cross-Region failover |
| FM provider returns error / hangs | Step Functions **circuit breaker** pattern (track recent failures, short-circuit invocations when threshold exceeded) |
| FM returns garbage / hallucinates | Guardrails contextual grounding, validation Lambda, fallback to deterministic SQL/rule-based path |
| Latency spike | Timeout + fallback to smaller faster model (graceful degradation) |
| Cost spike | Cost Anomaly Detection alarm + circuit breaker triggered by spend |

**Bedrock Cross-Region Inference** specifically: a managed feature where AWS automatically routes inference requests to alternate Regions to handle traffic surges and improve resilience. You target an "inference profile" instead of a single Region, and AWS picks the best Region. Reduces your need to implement cross-Region failover yourself.

### FM customization (skill 1.2.4)

Customization options on AWS, ordered by cost and complexity:

1. **Prompt engineering** - free, no model change. Always try first.
2. **RAG (retrieval augmented)** - cheap, no model change. Best when you need fresh / proprietary knowledge.
3. **Few-shot in-context examples** - free, larger prompts though.
4. **Fine-tuning** - changes model weights. Bedrock supports for select models (Claude Haiku, Llama, Cohere, Titan). Provide labeled examples in S3, Bedrock trains a private fine-tuned copy. Pay for Provisioned Throughput to use it.
5. **Continued pre-training** - on Bedrock for some Titan models. Pre-train on your unlabeled corpus to adapt the base model to your domain vocabulary. More expensive than fine-tuning.
6. **LoRA / parameter-efficient adaptation** - via SageMaker AI. Trains a small "adapter" matrix instead of full model weights. Much cheaper than full fine-tune. Multiple adapters can hot-swap on the same base model.
7. **Train from scratch** - rare; SageMaker AI training jobs on GPU/Trainium. Out of scope for the AIP-C01 candidate.

**SageMaker Model Registry** is the catalog. Pattern:
- Train / fine-tune → produce a model artifact
- Register in SageMaker Model Registry with version + status (Pending, Approved, Rejected)
- CI/CD pipeline picks up Approved versions and deploys
- Maintain rollback by re-deploying a previous Approved version

**Lifecycle:**
- **Versioning**: every model artifact gets a version in the Registry
- **Approval workflows**: status gates in the Registry; `aws sagemaker update-model-package` flips status
- **Automated deployment**: CodePipeline / Step Functions watches Registry, triggers SageMaker Endpoint update on approval
- **Rollback**: keep previous endpoint config; `update-endpoint` to roll back
- **Retire / replace**: schedule cutover, monitor blue/green, decommission old endpoints to control cost

---

## Task 1.3: Implement data validation and processing pipelines

### Data quality before FM consumption

Why this matters: garbage in → garbage out, especially for RAG (bad source data → bad retrieval → bad answers).

| Check | AWS service |
|-------|-------------|
| Schema/type/null/range validation at scale | **AWS Glue Data Quality** (define rules, runs as part of Glue jobs/crawlers) |
| Interactive data exploration + cleanup recipes | **SageMaker Data Wrangler** |
| Custom per-record validation | **AWS Lambda** functions invoked from Step Functions |
| Operational metrics on quality | **Amazon CloudWatch** custom metrics |

A typical pipeline: S3 raw → Glue/Lambda validation → S3 curated → Bedrock Knowledge Base ingestion (or downstream FM call).

### Multimodal pre-processing

The exam's multimodal pipeline service map:

| Modality | Service for prep | What it does |
|----------|-----------------|--------------|
| Text (raw documents) | **Amazon Textract** | OCR, table/form extraction, document layout |
| Audio | **Amazon Transcribe** | Speech-to-text, speaker diarization, custom vocabulary |
| Images | **Amazon Rekognition** | Object/face/text detection (use to extract metadata before embedding) |
| Tabular | **AWS Glue / SageMaker Processing** | Cleaning, joining, filtering |
| Multimodal embedding | **Amazon Titan Multimodal Embeddings** (via Bedrock) | Combined image+text vectors |
| Multimodal generation | **Bedrock multimodal models** (Claude 3+, Nova, Llama 3.2 Vision) | Take images and text as input |

Reference multimodal RAG pipeline (e.g., for support tickets with screenshots):
1. Textract extracts text from screenshots
2. Transcribe transcribes audio attachments
3. Comprehend extracts entities + sentiment from text
4. Titan Multimodal Embeddings generates vectors over both text and images
5. Store vectors + metadata in OpenSearch Service or Bedrock Knowledge Bases
6. At query time: embed the question, retrieve top-K, send context + question to Bedrock multimodal model

### Formatting input for FMs

Each FM has its own input contract. Critical rules the exam tests:

- **Bedrock InvokeModel** body is **JSON**, but the **schema differs per provider**. Anthropic uses `messages` with `role` + `content`. AI21, Cohere, Meta, Titan each have different schemas.
- **Bedrock Converse API** is the **unified** conversation API across providers - use this when you want code that doesn't change if you swap providers. Returns a uniform response shape.
- **InvokeModelWithResponseStream / ConverseStream** for streaming responses (chunked tokens).
- **SageMaker AI endpoints** use Content-Type-driven serialization (CSV / JSON / parquet, etc.) - configure the inference container.
- **Conversation formatting**: keep system prompt in `system`, alternate `user` / `assistant` turns, never repeat `user` twice in a row (most providers reject).

### Enhancing input quality (skill 1.3.4)

Pre-processing patterns the exam likes:

- **Use a small Bedrock model to clean / reformat raw text** before sending to a more expensive model (e.g., normalize transcripts, summarize long context).
- **Amazon Comprehend** to extract entities, key phrases, language, PII - pass extracted structure to the LLM as part of the prompt.
- **Lambda functions** for deterministic normalization (date formats, currencies, casing).
- **Amazon Bedrock Data Automation** (BDA) for end-to-end document understanding: pass a PDF/image/audio/video, get structured insights without writing the pipeline yourself.

---

## Task 1.4: Design and implement vector store solutions

> Deeper dive: see [RAG architecture deep-dive](rag-architecture-deep-dive.md).

### Vector store options on AWS

| Option | When to pick |
|--------|--------------|
| **Amazon Bedrock Knowledge Bases** | Default. Managed end-to-end RAG: ingestion + chunking + embedding + vector store + retrieval. Choose this unless you have specific requirements. Supports OpenSearch Serverless, Aurora pgvector, MongoDB Atlas, Pinecone, Redis Enterprise, Neptune Analytics as backing stores. |
| **Amazon OpenSearch Service** (with **Neural plugin**) | When you need full-text + vector hybrid search at scale, advanced sharding/index control, or already use OpenSearch. Neural plugin integrates Bedrock embedding models directly. |
| **Amazon OpenSearch Serverless (vector engine)** | Fully managed vector index. Default backing store for Bedrock Knowledge Bases. |
| **Amazon Aurora PostgreSQL with pgvector** | When you want vectors next to relational data, enabling SQL joins between embeddings and structured business data. Good for hybrid metadata filtering. |
| **Amazon RDS for PostgreSQL with pgvector** | Same as Aurora, for non-Aurora deployments. |
| **Amazon DynamoDB** + external vector DB | DynamoDB stores metadata + IDs; separate vector DB stores embeddings. Use when low-latency metadata reads dominate and vectors live elsewhere. |
| **Amazon Neptune Analytics** | Graph + vector. Pick when relationships between entities matter (e.g., knowledge graphs). |
| **Amazon DocumentDB (MongoDB-compatible)** | Vector search support; pick if you already use Mongo. |
| **Amazon ElastiCache (Redis with vector)** | Cache-tier vector search; pick for hot embeddings + low-latency. |
| **Amazon Kendra** | Not technically a vector DB, but enterprise search with semantic understanding. Can be used as a retriever for RAG, especially if you already have Kendra connectors to enterprise sources. |

### Metadata frameworks

The exam expects you to know that **metadata is what makes retrieval precise**. Without metadata filtering, vector search returns "semantically similar" results that may be irrelevant (wrong author, wrong date, wrong product line).

Patterns:
- **S3 object metadata** for source-of-truth attributes (uploaded-by, content-type, customer-id)
- **Custom attributes** on chunks (e.g., document_title, section, last_modified, language, region, sensitivity_level)
- **Tagging systems** on the source documents that propagate to chunks
- **Bedrock Knowledge Bases metadata filters** at query time - retrieve only docs matching `region = 'EU'` AND `language = 'fr'` (set with `retrievalConfiguration.vectorSearchConfiguration.filter`)

### High-performance vector DBs at scale

For OpenSearch:
- **Sharding**: more shards = more parallelism but more overhead. Common rule: 30-50 GB per shard.
- **Multi-index strategy**: separate index per domain (legal, support, products) to improve precision and reduce noise.
- **Hierarchical indexing**: route queries to a coarse index first, then drill into a fine index based on classification.
- **HNSW vs IVF**: HNSW (default in OpenSearch k-NN) is the standard; tune `m`, `ef_construction`, `ef_search` for recall/latency trade-off.

### Integration with knowledge sources

Bedrock Knowledge Bases connectors (most are first-party, exam-relevant):
- Amazon S3 (most common)
- Web Crawler (for public sites and authenticated wikis)
- Confluence
- Microsoft SharePoint
- Salesforce
- Custom data source via direct ingestion API

Other patterns:
- **AWS DataSync** / **AWS Transfer Family** to land enterprise FS data in S3 first, then ingest
- **AppFlow** for SaaS connectors not natively supported

### Data maintenance (skill 1.4.5)

Why it matters: stale vectors return outdated answers.

Patterns:
- **Incremental ingestion**: Bedrock Knowledge Bases supports incremental sync (only re-embed changed objects). Trigger via API or schedule.
- **Real-time change detection**: S3 event notifications → EventBridge → Lambda → Knowledge Base ingestion API.
- **Scheduled refresh**: EventBridge Scheduler or Step Functions cron runs full re-sync nightly/weekly.
- **DynamoDB Streams** for change-driven ingestion if source-of-truth is in DynamoDB.

---

## Task 1.5: Design retrieval mechanisms for FM augmentation (RAG)

> Deeper dive: see [RAG architecture deep-dive](rag-architecture-deep-dive.md).

### Chunking strategies

| Strategy | When to use | AWS implementation |
|----------|-------------|--------------------|
| **Default chunking** (Bedrock KB default ~300 tokens with overlap) | Simple unstructured text | Bedrock Knowledge Bases native |
| **Fixed-size chunking** | Uniform documents | Bedrock KB built-in or Lambda |
| **Hierarchical chunking** | Long structured docs (legal, technical manuals) - parent chunk + child chunks; child retrieved, parent context returned to FM | Bedrock KB advanced parsing or custom Lambda |
| **Semantic chunking** | Where boundaries should align with topic shifts (e.g., chapter boundaries) | Bedrock KB semantic chunking |
| **No chunking (return full doc)** | Short docs | Bedrock KB fixed-size with large size |
| **Custom chunking** | Domain-specific (e.g., per legal section) | Lambda function pre-processor before ingestion |

**Chunk overlap**: typical 10-20% so context isn't cut at sentence boundaries.

### Embedding model selection

| Model | Where | Notes |
|-------|-------|-------|
| **Amazon Titan Text Embeddings v2** | Bedrock | 256, 512, or 1024 dimensions configurable; multilingual; good cost/perf |
| **Amazon Titan Multimodal Embeddings** | Bedrock | Image + text combined embeddings |
| **Cohere Embed (English / Multilingual / v3)** | Bedrock | Strong on retrieval benchmarks; specific compression modes |
| **Custom on SageMaker AI** | SageMaker | When you need a domain-specific embedder |

Decision factors:
- **Dimensionality** vs **storage cost** - 1024-dim embeddings cost ~4x what 256-dim do in storage; quality gap is often small for well-defined domains.
- **Multilingual** support - Titan v2 multilingual or Cohere multilingual if your corpus isn't English-only.
- **Domain fit** - test on a held-out eval set; don't assume the highest-priced is best.

**Batch embedding pattern**: Lambda function reads from SQS queue of doc IDs, calls Bedrock Titan embeddings in batched calls (more efficient than one-at-a-time), writes vectors to OpenSearch / Aurora.

### Vector search deployment

Three primary patterns:

1. **Bedrock Knowledge Bases with managed OpenSearch Serverless** - zero-ops; pick by default.
2. **Amazon OpenSearch Service with k-NN plugin (or Neural plugin)** - more control, you manage cluster.
3. **Aurora PostgreSQL with pgvector** - vectors next to relational data; SQL queries can filter by structured fields and order by vector distance.

### Advanced search architectures

- **Pure vector search** - good for semantic similarity, can miss exact keyword matches.
- **Pure keyword search** (BM25) - good for exact terms (product codes, names), bad at synonymy.
- **Hybrid search** - run both, combine scores. OpenSearch supports natively. Bedrock Knowledge Bases offers HYBRID search type. Almost always beats pure vector for production.
- **Reranking with Bedrock reranker models** (e.g., Cohere Rerank, Amazon Rerank) - retrieve top-N, then have a smaller cross-encoder model score each hit against the query, return top-K. Adds latency but big quality boost on noisy corpora.

### Query handling

The retrieval is only as good as the query. Techniques:

- **Query expansion** - generate synonyms / paraphrases with a small Bedrock model, run multiple retrievals, merge.
- **Query decomposition** - break a multi-part question into sub-questions (Lambda invokes Bedrock to decompose), retrieve per sub-question, fuse.
- **Query transformation** - rewrite a conversational follow-up ("when was that?") into a standalone query ("when was the iPhone 15 released?") using prior chat history.
- **Step Functions** is the orchestration layer for multi-step query handling.

### Consistent access for FM integration

- **Function calling / tool use**: define a `vector_search` tool in your FM tool schema. The FM decides when to call it. Standard for Anthropic Claude tool use, Cohere Command-R, Llama 3.1+, Nova.
- **Model Context Protocol (MCP)**: open standard for connecting FMs to external tools. AWS supports MCP servers running on Lambda (stateless tools) or ECS (stateful/complex tools). MCP clients in your agent let it discover and call tools without bespoke wiring.
- **Standardized API patterns**: define a single retrieval API (e.g., POST /retrieve with `query`, `filter`, `top_k`) that wraps Bedrock KB / OpenSearch / Kendra. Clients don't care which backend.

---

## Task 1.6: Implement prompt engineering strategies and governance

> Deeper dive: see [Prompt engineering and management deep-dive](prompt-engineering-and-management.md).

### Model instruction frameworks

Components of a robust prompt:

1. **Role / persona** ("You are a senior cloud architect...")
2. **Task description** ("Given the following S3 bucket policy, identify any IAM principles violated.")
3. **Context** (retrieved docs, conversation history)
4. **Constraints** ("Only return JSON. Never include reasoning. Maximum 200 tokens.")
5. **Examples** (few-shot)
6. **Output format** (JSON Schema, XML tags)

Bedrock features that operationalize these:
- **Bedrock Prompt Management** stores templates with variables (`{{customer_name}}`), versions them, and supports approval flows.
- **Bedrock Guardrails** are an orthogonal control layer (content filters, denied topics, contextual grounding, sensitive info). They enforce response policy independently of the prompt.

### Interactive AI / conversational systems

| Concern | AWS service |
|---------|-------------|
| Conversation history | **Amazon DynamoDB** (or ElastiCache for hot history) |
| Intent recognition | **Amazon Comprehend** (custom classifiers) or Bedrock with prompt |
| Clarification flows | **AWS Step Functions** with Choice states |
| Voice + chat front-end | **Amazon Lex** (intents + slots) backed by Bedrock for free-form |
| Conversational FM | Bedrock Converse API |

Pattern: Lex/Connect routes structured intents to Lambda; ambiguous turns get sent to Bedrock with conversation history from DynamoDB.

### Prompt management and governance

| Capability | Service |
|------------|---------|
| Parameterized prompt templates | **Bedrock Prompt Management** |
| Prompt versions | **Bedrock Prompt Management** |
| Approval workflows | Bedrock Prompt Management + SNS / Lambda gate |
| Source-of-truth template repo | Optionally **Amazon S3** (versioned) for audited storage |
| Audit logging of prompt runs | **AWS CloudTrail** (Bedrock data events) |
| Real-time prompt logs | **Bedrock Model Invocation Logs** to S3 + CloudWatch Logs |
| Track usage per template | CloudWatch metrics tagged with prompt template ID |

### Quality assurance for prompts

Operationalize prompt testing as code:

- **Unit-style tests**: Lambda runs the prompt against a fixture set, checks expected output (regex / JSON schema validation).
- **Edge-case suites**: Step Functions iterates through difficult inputs (long contexts, adversarial inputs, non-English) and reports pass/fail.
- **Regression detection**: CloudWatch metric on test pass rate per prompt version; alarm on regressions.
- **Bedrock Model Evaluations** for built-in automated and human evaluations (more on this in Domain 5).

### Iterative prompt refinement (skill 1.6.5)

Beyond "try and tweak":

- **Structured input components**: separate fields with XML tags (`<context>`, `<question>`, `<constraints>`) so the model can attend to them clearly.
- **Output format specifications**: require JSON conforming to a schema; validate post-hoc; reject and retry on schema violation.
- **Chain-of-thought (CoT)**: ask the model to reason step-by-step before final answer. Improves quality on multi-step problems but increases token usage.
- **Self-consistency / self-critique**: have the model generate multiple answers and pick the most consistent, or critique its own answer and revise.
- **Feedback loops**: collect user rating + final outcome; periodically re-evaluate prompts against this dataset.

### Complex prompt systems with Bedrock Prompt Flows

**Bedrock Prompt Flows** is a visual/no-code orchestrator for prompt chains. Capabilities:

- Sequential prompt chains (output of one feeds into the next)
- Conditional branching based on model output (e.g., if classification = "billing", route to billing prompt)
- Reusable prompt components (call existing Bedrock Prompt Management templates)
- Pre/post-processing nodes (Lambda or AWS service calls)
- Integration with Knowledge Bases for in-flow retrieval
- Versioning + alias-based deployment (similar to Lambda aliases)

When to choose Prompt Flows vs Step Functions:
- **Prompt Flows**: prompt-centric workflows; non-developer authors; built-in Bedrock integration
- **Step Functions**: developer-built; needs full AWS service access, complex error handling, long-running execution

---

## Gotchas and exam traps

- **"Switch FM without redeploying"** → AppConfig + Lambda, **not** a code change. The exam loves this distinction.
- **"Resilience to regional FM outage"** → Bedrock **Cross-Region Inference**, not just retry. Cross-Region Inference is a managed feature distinct from app-level multi-Region.
- **"Most cost-effective for occasional bursty workload"** → On-demand Bedrock invocation, **not** Provisioned Throughput. Provisioned Throughput is for predictable / sustained.
- **"Need consistent throughput / SLA"** → Bedrock **Provisioned Throughput** with model units.
- **"Custom fine-tuned model"** → After fine-tuning on Bedrock, you **must purchase Provisioned Throughput** to invoke the fine-tuned model. This is a frequent trap.
- **"Vectors next to relational data with SQL access"** → Aurora **pgvector**, not OpenSearch.
- **"Already use Mongo / want managed Mongo with vectors"** → DocumentDB.
- **"Need both keyword and semantic"** → **Hybrid search** (OpenSearch native or Bedrock KB HYBRID). Pure vector is a trap distractor.
- **"PII detection in prompt input"** → Comprehend PII or **Bedrock Guardrails sensitive info filter**. Macie is for **data at rest in S3**, not real-time prompt content.
- **"Rerank top-N retrieved docs"** → Bedrock **rerankers** (Cohere / Amazon Rerank). Don't confuse with embedding models.
- **"FM extension via custom tools"** → MCP servers on Lambda (stateless) or ECS (stateful/heavy). Function calling alone is the in-FM mechanism; MCP is the AWS-native pattern for shareable tool servers.
- **"Visual / no-code prompt orchestrator"** → Bedrock **Prompt Flows**, not Step Functions.
- **"Approval-gated prompt deployment"** → Bedrock **Prompt Management** versions + approval, not just S3.
- **"Audit prompts that hit Bedrock"** → **CloudTrail** (data events for Bedrock) + **Bedrock Model Invocation Logs** to S3/CloudWatch. Together, not either alone.
- **"Multimodal embedding for image+text search"** → **Titan Multimodal Embeddings**, not separate text and image embeddings.
- **"Document understanding for PDFs/images/audio without writing pipeline"** → **Bedrock Data Automation (BDA)**, not Textract+Transcribe+Lambda by hand.

---

## Quick-recall summary

- Largest domain: **31%**. Six tasks; the heaviest are vector stores (1.4), retrieval (1.5), prompt eng (1.6).
- Design framework: Well-Architected **Generative AI Lens**, CAF-AI, GenAI Lifecycle Operational Excellence framework.
- POC tool: **Bedrock Playground / Bedrock Studio** + Bedrock InvokeModel/Converse.
- Model selection knobs: task fit, quality, latency, cost, context window, tool use, region availability, customization needs.
- Decoupled model selection: **AppConfig** (config) + **Lambda** (read config + call Bedrock) + **API Gateway**.
- Resilience: **Bedrock Cross-Region Inference** for regional fail; **Step Functions circuit breaker** for repeated FM failures; graceful degradation to smaller models.
- Customization ladder: prompt eng → RAG → few-shot → fine-tune → continued pre-training → LoRA on SageMaker → train from scratch.
- Custom fine-tuned Bedrock model **requires Provisioned Throughput** to invoke.
- **SageMaker Model Registry** holds versions + approval status; CI/CD pipelines deploy on approval; rollback by re-deploying prior version.
- Data quality: **Glue Data Quality** (rules at scale), **Data Wrangler** (interactive), Lambda (custom), CloudWatch (metrics).
- Multimodal: Textract (docs), Transcribe (audio), Rekognition (images), Titan Multimodal Embeddings (joint), **Bedrock Data Automation** for end-to-end.
- Bedrock input formats per provider; **Converse API** is unified across providers.
- Vector store default: **Bedrock Knowledge Bases**. Variants: **OpenSearch Service Neural plugin**, **Aurora pgvector**, DocumentDB, Neptune Analytics, Kendra (search-not-vector but works as retriever).
- Bedrock KB connectors: S3, Web Crawler, Confluence, SharePoint, Salesforce, custom.
- Metadata filters at retrieval time make vector search precise.
- Chunking: default, fixed-size, hierarchical (parent+child), semantic, custom.
- Embeddings: **Titan v2 Text** (256/512/1024 dim multilingual), **Titan Multimodal**, Cohere Embed.
- Hybrid (keyword+vector) search beats pure vector in production.
- **Bedrock rerankers** for top-K refinement.
- Query handling: expansion, decomposition, transformation; orchestrate with Step Functions.
- Function calling = in-FM; **MCP** = AWS-native external tool servers (Lambda stateless / ECS stateful).
- Prompt structure: role, task, context, constraints, examples, output format.
- **Bedrock Prompt Management**: parameterized templates, versions, approval workflows.
- **Bedrock Guardrails**: orthogonal layer (content filters, denied topics, contextual grounding, sensitive info, word filters).
- Prompt audit: **CloudTrail** + **Bedrock Model Invocation Logs**.
- **Bedrock Prompt Flows**: no-code/visual prompt orchestration; pick over Step Functions when prompt-centric and non-dev authors.
