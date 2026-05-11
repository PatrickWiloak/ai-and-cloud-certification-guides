# Domain 5: Testing, Validation, and Troubleshooting (11%)

> **11% of the exam.** Smallest domain by weight, but heavily overlaps with Domain 4 (monitoring) and Domain 1 (RAG / prompts). Master Bedrock Model Evaluation and the GenAI failure modes here.

## Table of contents

- [Exam tasks and skills](#exam-tasks-and-skills)
- [Task 5.1: Implement evaluation systems for GenAI](#task-51-implement-evaluation-systems-for-genai)
- [Task 5.2: Troubleshoot GenAI applications](#task-52-troubleshoot-genai-applications)
- [Reference: GenAI failure mode decision matrix](#reference-genai-failure-mode-decision-matrix)
- [Gotchas and exam traps](#gotchas-and-exam-traps)
- [Quick-recall summary](#quick-recall-summary)

## Exam tasks and skills

### Task 5.1: Implement evaluation systems for GenAI
- **5.1.1** Comprehensive assessment for FM output quality (relevance, factual accuracy, consistency, fluency).
- **5.1.2** Systematic model evaluation (Bedrock Model Evaluations, A/B and canary testing, multi-model evaluation, cost-perf analysis: token efficiency, latency-to-quality ratios, business outcomes).
- **5.1.3** User-centered evaluation (feedback interfaces, rating systems, annotation workflows).
- **5.1.4** Quality assurance (continuous evaluation workflows, regression testing for outputs, automated quality gates for deployments).
- **5.1.5** Comprehensive assessment systems (RAG evaluation, automated quality assessment with LLM-as-Judge, human feedback collection).
- **5.1.6** Retrieval quality testing (relevance scoring, context matching verification, retrieval latency).
- **5.1.7** Agent performance frameworks (task completion rate, tool usage effectiveness, Bedrock Agent evaluations, reasoning quality).
- **5.1.8** Reporting (visualization tools, automated reporting, model comparison visualizations).
- **5.1.9** Deployment validation (synthetic user workflows, AI-specific output validation for hallucination rates and semantic drift, automated quality checks).

### Task 5.2: Troubleshoot GenAI applications
- **5.2.1** Content handling issues (context window overflow diagnostics, dynamic chunking, prompt design optimization, truncation analysis).
- **5.2.2** FM integration issues (error logging, request validation, response analysis).
- **5.2.3** Prompt engineering problems (prompt testing frameworks, version comparison, systematic refinement).
- **5.2.4** Retrieval system issues (response relevance analysis, embedding quality diagnostics, drift monitoring, vectorization issue resolution, chunking and preprocessing remediation, vector search perf optimization).
- **5.2.5** Prompt maintenance issues (template testing, CloudWatch Logs to diagnose prompt confusion, X-Ray for prompt observability, schema validation for format inconsistencies, systematic prompt refinement workflows).

---

## Task 5.1: Implement evaluation systems for GenAI

### Quality dimensions for FM outputs

The official guide names these explicitly:
- **Relevance** - response addresses the question
- **Factual accuracy** - claims match ground truth
- **Consistency** - same input → same / similar output across runs
- **Fluency** - grammatical, readable

Additional dimensions to know:
- **Faithfulness / groundedness** (RAG) - response stays within retrieved context
- **Helpfulness** - actually solves the user's problem
- **Tone / style** - matches brand voice / register
- **Safety** - no harmful content
- **Bias / fairness** - equal performance across demographic slices

### Bedrock Model Evaluation - the core service

Three evaluation types:

| Type | Description | When |
|------|-------------|------|
| **Automatic** | Pre-built tasks (Q&A, summarization, classification, text generation) with built-in metrics (ROUGE, BLEU, Bert-score, accuracy, F1) | Quick quantitative comparison; standard tasks |
| **Human** | Workforce (your team or AWS-managed) reviews and rates outputs | Subjective quality (tone, helpfulness); ground-truth-free tasks |
| **LLM-as-Judge** | A judge FM scores candidate outputs on your rubric | Cheap automated qualitative scoring; correlates well with human eval if rubric is clear |

Modes:
- **Single-model**: test one model on your data.
- **Multi-model comparison (head-to-head)**: run two models, compare metrics or human/judge preferences.
- **RAG evaluation**: specifically for Knowledge Bases - retrieval quality + generation quality.

### A/B and canary testing

Patterns:
- **Bedrock Prompt Management** with multiple versions; route % of traffic via Prompt Flows or AppConfig
- **Canary**: deploy new prompt / model to a small fraction of users; compare metrics (latency, cost, quality, error rate)
- **Roll forward** if canary passes; **roll back** by reverting alias if canary fails

### Cost-performance analysis

Track per-version metrics:
- **Token efficiency**: avg input tokens, avg output tokens per request
- **Latency-to-quality ratio**: quality score / p95 latency
- **Cost per successful task**: dollar amount / completed-task count
- **Business outcome metrics**: deflection rate, conversion, NPS

These let you make defensible "the smaller model is better here" arguments.

### User-centered evaluation

| Need | Implementation |
|------|----------------|
| **In-app rating (thumbs up/down)** | API Gateway endpoint → Lambda → DynamoDB; aggregate per prompt version |
| **Free-text feedback** | API Gateway → Lambda → S3 / DynamoDB; periodic Comprehend sentiment / topic modeling |
| **Annotation workflows** | **SageMaker Ground Truth** (general) or **Amazon Augmented AI (A2I)** (production review workflow) |
| **In-flight human review** | A2I triggered when confidence < threshold or Guardrail flags trigger |

### Quality assurance pipeline

Treat evaluation as part of CI/CD:

```
Code change / new prompt / new model
    -> CodePipeline kicks off CodeBuild
    -> CodeBuild runs unit tests on prompts (Lambda invokes against fixtures)
    -> Bedrock Model Evaluation job for the new variant on golden eval set
    -> Automated quality gates:
         - Pass rate > X% on fixture set?
         - Average judge score > baseline?
         - Cost per request within budget?
         - No regression on safety metrics?
    -> If gates pass: deploy via alias update / Prompt Management / AppConfig
    -> CloudWatch Synthetics canary monitors live behavior
    -> If post-deploy regression: auto-rollback alias
```

### Comprehensive RAG evaluation

(Tested specifically in skill 5.1.5 and 5.1.6)

**Retrieval metrics** (does the retriever find the right docs?):
- **Recall@K** - fraction of relevant docs in top-K
- **Precision@K** - fraction of top-K that are relevant
- **MRR (Mean Reciprocal Rank)** - 1 / rank of first relevant
- **NDCG (Normalized Discounted Cumulative Gain)** - rank-aware relevance
- **Context relevance** - measure of retrieved content's semantic match to query
- **Retrieval latency** - p50, p95 of retrieval call

**Generation metrics** (given context, is the answer good?):
- **Faithfulness / groundedness** - answer supported by context
- **Answer relevance** - addresses the question
- **Factual accuracy** - against ground truth
- **Citation accuracy** - cited sources actually appear in retrieved context

**AWS-native:**
- **Bedrock Knowledge Bases evaluations** - built-in eval jobs for retrieval and generation
- **Bedrock Model Evaluation** with RAG-specific metrics
- Custom Lambda runs of LLM-as-Judge on a labeled eval set

### Agent performance frameworks (skill 5.1.7)

Metrics:
- **Task completion rate** - what % reach successful final answer
- **Tool call accuracy** - right tool for the step
- **Tool argument correctness** - well-formed args
- **Reasoning quality** - LLM-as-judge on agent traces
- **Steps to completion** - efficiency proxy
- **Tool error rate** - reliability
- **Token usage per task** - cost proxy

AWS-native:
- **Bedrock Agent evaluations** for automated agent trace evaluation
- **CloudWatch metrics + Bedrock Model Invocation Logs** for per-step analytics
- **X-Ray traces** across agent + tool Lambdas

### Reporting and visualization

- **CloudWatch Dashboards** for ops metrics
- **Amazon Managed Grafana** for richer cross-source dashboards
- **Amazon QuickSight** for business-stakeholder reports (metrics in S3 / Athena)
- **Bedrock Model Evaluation report cards** for per-evaluation results (JSON + console)
- **Automated reports**: Lambda + EventBridge Scheduler emails dashboards as PDFs / markdown to stakeholders

### Deployment validation

Synthetic / continuous validation patterns:
- **CloudWatch Synthetics canaries** running representative prompts; alarm on regression
- **AI-specific output validation Lambda**: golden dataset runs scoring hallucination rate + semantic drift
- **Automated quality checks** as deploy gates: schema validation, eval set scores, cost / latency budgets
- **Blue/green or canary** with auto-rollback on metric regression (CodeDeploy traffic shifting)

---

## Task 5.2: Troubleshoot GenAI applications

### Content handling issues (skill 5.2.1)

| Symptom | Cause | Fix |
|---------|-------|-----|
| `ValidationException: input too long` | Prompt + context exceeds context window | Switch to longer-context model (Claude long-context, Nova Pro); summarize history; chunk input; reduce top_k retrieved chunks |
| Output truncated mid-sentence | `maxTokens` too low or model cap hit | Increase `maxTokens`; instruct model to be concise; stream and detect cutoff |
| Important info missing from response | Chunks too small; retrieved chunks lack context | Larger chunks; hierarchical chunking (parent context); raise top_k |
| Specific facts dropped | Lost in middle of long context (lost-in-the-middle problem) | Reorder context (most relevant first or last); reduce context size; structured input with tags |

**Dynamic chunking remediation**: switch chunking strategy at ingest (hierarchical / semantic) and re-ingest.

### FM integration issues (skill 5.2.2)

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `AccessDeniedException` on Bedrock | Model access not enabled or IAM | Enable model access in Bedrock console (one-time per account/region); fix IAM `bedrock:InvokeModel` permission |
| `ValidationException` on body | Request body schema doesn't match provider | Use **Converse API** (uniform) or check provider-specific schema |
| `ThrottlingException` | Rate limited (on-demand) | Exponential backoff; consider Provisioned Throughput; Cross-Region Inference |
| `ServiceQuotaExceededException` | Account-level quota hit | Request quota increase; PT |
| `ResourceNotFoundException` on custom model | Model ARN wrong / not in same Region / no PT | Verify Region; provision PT for custom models |
| Streaming abruptly ends | Network or model timeout | Implement reconnect; review max output tokens; check downstream timeouts |
| Tool call response malformed | FM didn't follow tool schema | Use Converse `toolConfig`; validate JSON; retry with schema in prompt |

Logging: enable **Bedrock Model Invocation Logs** + **CloudTrail data events**. Use **CloudWatch Logs Insights** queries on the log stream to find error patterns.

### Prompt engineering problems (skill 5.2.3)

(See [Prompt engineering and management deep-dive](prompt-engineering-and-management.md) for full troubleshooting matrix.)

Quick reference:
- **Inconsistent output format** → JSON Schema validation + retry; tool-use mode for guaranteed schema; lower temperature
- **Model ignores constraints** → Move constraints to top, repeat at bottom; use "MUST", "ONLY"; XML tag delimiters
- **Hallucinations** → Guardrails contextual grounding + explicit "say I don't know" + lower temp + better retrieval
- **Off-topic answers** → Better role/context priming; few-shot examples
- **New prompt version regressed** → Revert alias; diff against previous version; run regression tests against golden dataset

### Retrieval system issues (skill 5.2.4)

| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| **Right doc exists but isn't retrieved** | Bad embedding / no metadata filter / wrong query embedding | Try different embedding model; verify same model used for ingestion + query; add metadata filters; hybrid search |
| **Many irrelevant retrievals** | Pure vector search; semantic noise | Hybrid search; reranker; tighter top_k; metadata filters |
| **Stale retrievals** | Vector store not refreshed | Incremental sync via S3 events or scheduled re-sync |
| **Retrieval slow** | Index not optimized; large corpus; high `ef_search` | Tune HNSW params; smaller embeddings; sharding; caching hot queries; warm shards |
| **Wrong language doc retrieved** | English-only embedding model | Switch to multilingual embedder |
| **Specific terms (product codes) missed** | Pure vector search misses exact strings | Hybrid (BM25 + vector) |
| **One tenant gets another's docs** | No metadata filter on tenant | Always filter on `tenant_id` (or per-tenant index) |
| **Retrieval scores low across the board** | Index drift; chunking suboptimal | Re-ingest with different chunking; re-embed with newer model |
| **Queries against new docs return old answers** | Caching layer stale | Invalidate semantic cache on doc updates |

**Embedding quality diagnostics**: take a known query → known doc pair, compute similarity, compare across embedding model candidates; pick best.

**Drift monitoring**: schedule a Lambda to embed a fixed set of canary queries, store similarity to a reference set, alarm on drift.

### Prompt maintenance issues (skill 5.2.5)

The exam calls out specific tools:

| Tool | Use |
|------|-----|
| **CloudWatch Logs Insights** | Query Bedrock Model Invocation Logs for prompt confusion patterns (e.g., responses where model says "I don't have enough information" - indicates context problem) |
| **AWS X-Ray** | Distributed traces of prompt processing through Lambda → Bedrock → downstream |
| **Schema validation** | Parse model output against JSON Schema; reject and log malformed |
| **Template testing** | Lambda runs prompt against fixtures pre-deploy |
| **Systematic refinement workflows** | CI/CD with prompt eval gates; alias-based deployment; revert on regression |

Common Logs Insights query:
```
fields @timestamp, prompt_template_id, output_text
| filter output_text like /"I don't have enough information"/
| stats count() as failures by prompt_template_id, bin(1h)
```

---

## Reference: GenAI failure mode decision matrix

When troubleshooting, classify the failure first:

| Failure class | Signs | Where to investigate |
|---------------|-------|---------------------|
| **Authn / authz** | AccessDenied | IAM policies, model access, resource policies |
| **API contract** | ValidationException | Request schema, model body format, Converse API |
| **Capacity** | Throttling, timeouts | Bedrock PT, Cross-Region Inference, backoff |
| **Context window** | Input too long | Long-context model, summarize, chunk |
| **Retrieval quality** | Wrong/missing docs | Embeddings, metadata filters, hybrid search, reranker |
| **Prompt engineering** | Wrong output, hallucination, format | Prompt design, Guardrails, schema validation |
| **Output formatting** | Schema violations | JSON Schema + retry, tool-use mode |
| **Cost spike** | Bill anomaly | Cost Anomaly Detection, CloudWatch tokens, runaway agent |
| **Latency** | Slow p95 | Streaming, smaller model, parallel calls, retrieval opt |
| **Drift / quality regression** | Eval-set scores dropping | Golden dataset, output diffing, A/B comparison, revert |
| **Safety regression** | Guardrail blocks spike | New attack pattern? Guardrail config? Update policies |
| **Agent stuck in loop** | Excessive iterations | Stopping conditions, IAM bounds, circuit breakers |

---

## Gotchas and exam traps

- **"Compare two models head-to-head"** → **Bedrock Model Evaluation** multi-model comparison.
- **"Cheap automated quality scoring"** → **LLM-as-Judge** in Bedrock Model Evaluation.
- **"Subjective quality requiring expert review"** → **Bedrock Model Evaluation human evaluation** or **A2I**.
- **"Catch a regression before users see it"** → **CloudWatch Synthetics** canaries + automated quality gates pre-deploy.
- **"Roll back automatically on metric regression"** → **CodeDeploy** traffic shifting + alarms; or alias revert via Lambda.
- **"RAG-specific evaluation built-in"** → **Bedrock Knowledge Bases evaluations**.
- **"Evaluate agent reasoning quality"** → **Bedrock Agent evaluations** + LLM-as-judge on traces.
- **"Detect hallucinations in production"** → **golden dataset** runs + **Bedrock Guardrails contextual grounding** + output diffing.
- **"Diagnose 'right doc, wrong answer'"** → prompt design + Guardrails grounding, NOT a retrieval issue.
- **"Diagnose 'wrong doc retrieved'"** → embedding model, metadata filters, hybrid search, NOT a prompt issue.
- **"Same input gives inconsistent outputs"** → temperature too high; set to 0.
- **"Output format breaks downstream parsing"** → **JSON Schema validation + retry**; tool-use mode if available.
- **"Long input fails"** → long-context model OR summarize/chunk + raise context size.
- **"Auth failures on Bedrock"** → enable **model access** in console + IAM `bedrock:InvokeModel`.
- **"Throttling on bursty traffic"** → backoff + Cross-Region Inference; PT for sustained.
- **"Logs Insights query for prompt confusion"** → CloudWatch Logs Insights against Bedrock Model Invocation Logs.
- **"Distributed trace across FM call chain"** → **X-Ray**.
- **"Catch new injection attacks at runtime"** → Guardrails prompt-attack metric in CloudWatch; alarm on rate change.
- **"Annotate / label outputs for evaluation"** → **SageMaker Ground Truth**; **A2I** for in-line review.

---

## Quick-recall summary

- Quality dimensions: relevance, factual accuracy, consistency, fluency, faithfulness, helpfulness, tone, safety, fairness.
- **Bedrock Model Evaluation** types: **automatic** (built-in metrics), **human** (workforce review), **LLM-as-Judge** (judge model). Modes: single, multi-model, RAG-specific.
- A/B and canary: Prompt Management variants + alias routing; AppConfig flags; CloudWatch dashboards per variant.
- Cost-performance analysis: tokens per request, latency-to-quality, cost per successful task, business outcomes.
- User feedback: API Gateway + Lambda + DynamoDB; **A2I** for review; **Ground Truth** for labeling.
- QA pipeline: CodePipeline + CodeBuild + Bedrock Eval + automated quality gates + Synthetics canary + auto-rollback.
- RAG eval: retrieval (recall@K, precision@K, MRR, NDCG) + generation (faithfulness, answer relevance, factual accuracy, citation accuracy). Use **Bedrock Knowledge Bases evaluations**.
- Agent eval: task completion, tool call accuracy, reasoning quality. Use **Bedrock Agent evaluations** + LLM-as-judge + X-Ray + CloudWatch.
- Reporting: CloudWatch Dashboards + Managed Grafana + QuickSight (business); automated reports via Lambda + EventBridge.
- Deployment validation: Synthetics canaries, golden dataset runs, schema validation, hallucination/drift checks; auto-rollback.
- Content handling fixes: long-context model, summarize, hierarchical chunking, raise top_k, structured prompt, lost-in-middle awareness.
- FM integration fixes: Converse API, Bedrock model access enable, IAM permissions, exponential backoff, PT for throttling, Cross-Region Inference.
- Prompt fixes: tagged constraints, lower temperature, JSON Schema validation, alias revert on regression.
- Retrieval fixes: same embedding model for query+doc, metadata filters, hybrid search, reranker, multilingual embeddings, fresher sync.
- Tools: **CloudWatch Logs Insights** for log queries, **X-Ray** for traces, **Bedrock Model Invocation Logs** for full request/response, **Synthetics** canaries, **Cost Anomaly Detection** for billing.
- Failure-class triage matrix is the fastest path to the right answer in scenario questions.
