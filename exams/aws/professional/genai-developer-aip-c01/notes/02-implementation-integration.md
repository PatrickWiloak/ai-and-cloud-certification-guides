# Domain 2: Implementation and Integration (26%)

> **Second-largest domain.** Tests how you take a designed solution and actually wire it into AWS, enterprise systems, and developer workflows. Heavy on agents, API patterns, deployment models, and integration architectures.

## Table of contents

- [Exam tasks and skills](#exam-tasks-and-skills)
- [Task 2.1: Implement agentic AI solutions and tool integrations](#task-21-implement-agentic-ai-solutions-and-tool-integrations)
- [Task 2.2: Implement model deployment strategies](#task-22-implement-model-deployment-strategies)
- [Task 2.3: Design and implement enterprise integration architectures](#task-23-design-and-implement-enterprise-integration-architectures)
- [Task 2.4: Implement FM API integrations](#task-24-implement-fm-api-integrations)
- [Task 2.5: Implement application integration patterns and development tools](#task-25-implement-application-integration-patterns-and-development-tools)
- [Gotchas and exam traps](#gotchas-and-exam-traps)
- [Quick-recall summary](#quick-recall-summary)

## Exam tasks and skills

### Task 2.1: Implement agentic AI solutions and tool integrations
- **2.1.1** Autonomous systems with memory + state (Strands Agents, AWS Agent Squad multi-agent, MCP for agent-tool interactions).
- **2.1.2** Problem-solving via structured reasoning (Step Functions for ReAct + chain-of-thought).
- **2.1.3** Safeguarded AI workflows (Step Functions stopping conditions, Lambda timeouts, IAM policy boundaries, circuit breakers).
- **2.1.4** Model coordination across capabilities (specialized FMs, custom aggregation, model selection frameworks).
- **2.1.5** Collaborative AI with human expertise (Step Functions for review/approval, API Gateway feedback collection, human augmentation).
- **2.1.6** Tool integrations (Strands API, function definitions, Lambda for error handling/parameter validation).
- **2.1.7** Model extension frameworks (Lambda for stateless MCP servers, ECS for complex MCP servers, MCP client libraries).

### Task 2.2: Implement model deployment strategies
- **2.2.1** Deploy FMs by needs (Lambda for on-demand, Bedrock provisioned throughput, SageMaker AI endpoints for hybrid).
- **2.2.2** LLM-specific deployment (container-based with memory/GPU/token throughput optimization, specialized model loading).
- **2.2.3** Optimized FM deployment (model selection, smaller pre-trained models, API-based model cascading).

### Task 2.3: Design and implement enterprise integration architectures
- **2.3.1** Enterprise connectivity (API integrations with legacy, event-driven for loose coupling, data sync).
- **2.3.2** Integrated AI capabilities (API Gateway microservices, Lambda webhooks, EventBridge event-driven).
- **2.3.3** Secure access (identity federation, RBAC, least-privilege API access).
- **2.3.4** Cross-environment AI (Outposts on-prem, Wavelength edge, secure routing).
- **2.3.5** CI/CD + GenAI gateway architectures (CodePipeline, CodeBuild, automated tests, security scans, rollback, central abstraction).

### Task 2.4: Implement FM API integrations
- **2.4.1** Flexible model interaction (Bedrock APIs sync, AWS SDKs + SQS async, API Gateway with validation).
- **2.4.2** Real-time AI (Bedrock streaming APIs, WebSockets / SSE, API Gateway chunked transfer).
- **2.4.3** Resilient FM systems (SDK exponential backoff, API Gateway rate limiting, fallback, X-Ray observability).
- **2.4.4** Intelligent model routing (static routing, Step Functions content-based routing, intelligent metric-based routing, API Gateway transformations).

### Task 2.5: Implement application integration patterns and development tools
- **2.5.1** FM API interfaces (API Gateway streaming, token limit mgmt, retry strategies).
- **2.5.2** Accessible AI interfaces (Amplify declarative UI, OpenAPI specs, Bedrock Prompt Flows no-code).
- **2.5.3** Business system enhancements (Lambda CRM enhancements, Step Functions document orchestration, Q Business data sources, Bedrock Data Automation).
- **2.5.4** Developer productivity (Q Developer for code gen, refactoring, suggestions, AI component testing, perf optimization).
- **2.5.5** Advanced GenAI applications (Strands Agents, AWS Agent Squad, Step Functions agent patterns, Bedrock prompt chaining).
- **2.5.6** Troubleshooting (CloudWatch Logs Insights for prompt analysis, X-Ray for FM API tracing, Q Developer for GenAI error patterns).

---

## Task 2.1: Implement agentic AI solutions and tool integrations

> Deeper dive: see [Agentic AI systems deep-dive](agentic-ai-systems.md).

### What "agentic AI" means on AWS

An **AI agent** is an FM-driven system that:
1. Receives a goal (user query / task)
2. Plans steps to achieve it
3. Calls tools (APIs, vector search, code, other agents) to gather info or take action
4. Observes results
5. Repeats until done

Versus a single FM call (one prompt → one response), an agent is a **loop** with memory, state, and external actions.

### AWS agent stack

| Layer | AWS option | When to use |
|-------|-----------|-------------|
| **Managed agent runtime** | **Amazon Bedrock Agents** | Quickest path. Managed orchestration, action groups (your APIs), Knowledge Base integration, Guardrails. |
| **Production agent runtime** | **Amazon Bedrock AgentCore** | New service. Secure runtime for production agents at scale, multi-agent coordination, identity, observability built in. |
| **Agent SDK / framework** | **Strands Agents** (AWS open-source) | Code-first agent framework with tool calling, streaming, state management. Pair with Bedrock for the FM. |
| **Multi-agent orchestrator** | **AWS Agent Squad** (AWS open-source) | Open-source framework to coordinate multiple specialized agents. |
| **Tool protocol** | **Model Context Protocol (MCP)** | Open standard. AWS-native runtime: Lambda for stateless tools, ECS for stateful/heavy tools. |
| **Custom orchestration** | **AWS Step Functions** | Build agent loops by hand. Used when you want full control of the ReAct flow. |

### Memory and state management

- **Short-term (in-context)**: conversation history in the prompt itself. Bounded by context window.
- **Long-term (persistent)**: store conversation history + user state in **DynamoDB** (low-latency reads), retrieve relevant slices, inject into prompt.
- **Episodic memory** (past interactions referenced semantically): write past messages as embeddings into a vector store; retrieve like RAG.
- **Bedrock AgentCore Memory**: managed memory for agents (semantic + episodic) so you don't reinvent it.

### Reasoning patterns

| Pattern | Description | Use case |
|---------|-------------|----------|
| **Chain-of-thought (CoT)** | Ask FM to reason step-by-step before answering | Multi-step math/logic |
| **ReAct (Reason + Act)** | Alternate Thought → Action → Observation → Thought ... until done | Tool-using agents |
| **Plan-and-Execute** | Generate a full plan first, then execute steps | Long-horizon tasks |
| **Reflection** | Generate, critique, revise | Quality-sensitive outputs |
| **Tree of Thoughts** | Explore multiple reasoning branches, pick best | Combinatorial problems |

**Step Functions implementation of ReAct:**
- A loop state machine
- Each iteration: Lambda invokes Bedrock for "next action" (tool name + args)
- Choice state branches to the right tool (also Lambda)
- Result fed back to Bedrock as "observation"
- Exit when FM signals "final answer" or max iterations

### Safeguards on agent behavior

Critical for production. The exam loves "stop the runaway agent":

| Safeguard | Implementation |
|-----------|----------------|
| **Stopping conditions** | Step Functions max iterations / time / cost |
| **Timeouts** | Lambda function timeout, Step Functions execution timeout |
| **Resource boundaries** | IAM execution role with least privilege; agent can only call permitted tools |
| **Cost circuit breakers** | Track token usage in DynamoDB / CloudWatch; abort over threshold |
| **Failure circuit breakers** | After N consecutive tool failures, stop and return error |
| **Output validation** | JSON Schema check on each FM response; reject malformed |
| **Guardrails** | Apply Bedrock Guardrails on every model invocation in the loop |

### Multi-agent coordination

Patterns:
- **Supervisor + workers**: a coordinator agent dispatches sub-tasks to specialist agents (e.g., research agent, coding agent, summarizer). Combine with **AWS Agent Squad**.
- **Pipeline**: agents in sequence, each handing off (e.g., extract → classify → respond).
- **Voting / ensemble**: multiple agents independently solve the same problem; aggregate.

Custom aggregation logic: Lambda functions that take multiple agent outputs, score them (e.g., LLM-as-judge), pick the best or merge.

### Human-in-the-loop

| Need | AWS service |
|------|-------------|
| Generic ML human review of model output | **Amazon Augmented AI (A2I)** |
| Approval gate in workflow | Step Functions wait-for-callback + SNS / Email / Slack |
| Feedback collection from end users | API Gateway endpoint → Lambda → DynamoDB / S3 |
| Labeling / annotation | **SageMaker Ground Truth** |

### Tool integration patterns

**Function calling / tool use** (in-FM mechanism):
- Define tool schema (name, description, parameters) in the prompt
- FM emits a tool call; your code executes it; result fed back
- Native in Bedrock Converse API (`toolConfig`)

**MCP servers** (out-of-FM, AWS-native):
- **Stateless tools** → **AWS Lambda** as MCP server (lightweight, scale-to-zero)
- **Stateful / complex tools** → **Amazon ECS** or **EKS** as MCP server (long-running, heavier deps)
- **MCP clients** in your agent discover tool schemas dynamically

Why MCP matters for the exam: it's the AWS-native pattern for **shareable, reusable** tool servers across multiple agents.

---

## Task 2.2: Implement model deployment strategies

### Three deployment models for FMs

| Model | When |
|-------|------|
| **Bedrock on-demand** (per-token billing) | Default. Bursty / unpredictable / low volume. Pay per token. |
| **Bedrock Provisioned Throughput** (model units) | Predictable / sustained / SLA-required. Pay per model unit per hour. **Required to invoke fine-tuned models on Bedrock.** |
| **SageMaker AI endpoints** | Custom / fine-tuned / open-source models you bring yourself. Real-time, async, batch, or serverless. |

### Bedrock Provisioned Throughput specifics

- Reserve **model units** (capacity); each model unit guarantees throughput (tokens per minute / requests per minute, model-dependent).
- Term commitments (no commit / 1 month / 6 month) - longer = cheaper.
- **Custom fine-tuned models on Bedrock require Provisioned Throughput** to invoke (no on-demand).
- Use Cross-Region Inference if regional capacity isn't enough.

### SageMaker AI endpoint types

| Endpoint type | Use case |
|---------------|----------|
| **Real-time** | Always-on, low-latency synchronous inference |
| **Serverless inference** | Pay-per-use, auto scales to zero, cold starts |
| **Asynchronous (async inference)** | Long-running predictions, payloads up to 1 GB, internal queue |
| **Batch transform** | Offline batch predictions over S3 datasets |
| **Multi-model endpoints (MME)** | Many small models share an endpoint to save cost |
| **Multi-container endpoints** | Different containers (frameworks) on one endpoint |

For LLMs specifically:
- **GPU instances** (g5, g6, p4d/p5, etc.) for hosting open-source LLMs (Llama, Mistral, Falcon).
- **AWS Inferentia (inf2)** for cost-optimized large-model inference; supported by SageMaker AI.
- **SageMaker JumpStart** to deploy popular open-source LLMs with one click on managed infrastructure.
- **SageMaker LMI (Large Model Inference) containers** with optimizations (TensorRT-LLM, vLLM, DJL Serving) - the exam doesn't go deep here but expects you to know SageMaker handles LLM-specific concerns (memory, GPU, token throughput).

### Optimized FM deployment

Patterns to reduce cost / improve throughput:

- **Model cascading**: route easy queries to a cheap model; escalate hard ones. E.g., Haiku → Sonnet → Opus only on retry. Use API Gateway / Step Functions / Lambda for routing.
- **Smaller pre-trained models for narrow tasks**: classification, extraction, intent detection often work great with small models or even custom-trained encoders on SageMaker.
- **Batch inference** when latency isn't required: Bedrock batch inference jobs over S3 inputs are cheaper than online.

---

## Task 2.3: Design and implement enterprise integration architectures

### Connecting FMs to existing enterprise systems

| Enterprise need | Pattern / service |
|-----------------|-------------------|
| Synchronous REST integration with legacy app | **API Gateway** + Lambda calling Bedrock |
| Event-driven loose coupling | **EventBridge** event bus, partners + targets |
| File-based legacy systems | **AWS Transfer Family** (SFTP/FTPS/AS2) → S3 → ingestion pipeline |
| SaaS data sync | **AWS AppFlow** (Salesforce, ServiceNow, Slack, Marketo, etc.) → S3 / Knowledge Base |
| Database CDC | **AWS DMS** (or DynamoDB Streams natively) |
| On-prem network | **Direct Connect** + VPN; FMs called over **VPC endpoints** for Bedrock |

### Secure access

- **Identity federation**: enterprise IdP → IAM Identity Center (formerly AWS SSO) → app roles. Federate ML/FM access without managing IAM users.
- **Role-based access control**: IAM policies on Bedrock InvokeModel / Knowledge Base actions, scoped per role. Tag-based ABAC for tenant-level access.
- **Least privilege**: each Lambda / agent role can only invoke specific models, specific Knowledge Bases, specific Guardrails.
- **VPC endpoints (PrivateLink)** for Bedrock and SageMaker - keeps traffic off the public internet.
- **AWS Secrets Manager** / **SSM Parameter Store** for any third-party API keys used by tools.

### Cross-environment AI (hybrid + edge)

- **AWS Outposts**: rack of AWS infrastructure on-prem. Gives you SageMaker AI / EC2 with same APIs locally - useful when data can't leave premises.
- **AWS Wavelength**: AWS infra inside telecom carrier networks for low-latency 5G edge.
- **AWS Local Zones**: out of scope per official guide.
- **Lambda@Edge / CloudFront Functions**: trigger logic at CloudFront edge for low-latency.
- **SageMaker Neo**: compile models for edge devices (then deploy to non-AWS edge).

For data sovereignty (skill 2.3.4):
- Keep data in compliant region with Outposts on-prem ingestion
- Bedrock Cross-Region Inference is opt-in - pin to compliant Regions only if required
- VPC endpoints + IAM resource policies to prevent data egress

### CI/CD for GenAI applications

Pattern (the "GenAI gateway" architecture):

```
Code repo (CodeCommit / GitHub) -> CodePipeline -> CodeBuild (build + test)
                                                          |
                                                          v
                                            Automated test suite
                                            (Lambda runs prompts, asserts on output;
                                             security scans on dependencies and IaC;
                                             evaluation suite via Bedrock Model Eval)
                                                          |
                                                          v
                                            CodeDeploy / SAM / CDK deploy
                                                          |
                                                          v
                                  Centralized GenAI gateway (API Gateway + Lambda):
                                  - Auth
                                  - Bedrock Guardrails
                                  - Rate limiting
                                  - Usage tracking + cost tagging
                                  - Audit logging (CloudTrail + Bedrock Invocation Logs)
                                  - Routing across providers/models
```

The "centralized abstraction layer" is the **GenAI gateway** - an enterprise pattern where all FM calls go through one controlled entry point.

---

## Task 2.4: Implement FM API integrations

### Synchronous vs asynchronous FM calls

| Pattern | When |
|---------|------|
| **Synchronous (blocking)** | Interactive UI, chat, immediate need for response |
| **Asynchronous (queue)** | Batch processing, large generations (long PDFs), non-interactive workloads |
| **Streaming** | Interactive UI where you want token-by-token display (better perceived latency) |

Async pattern:
```
Request -> API Gateway -> Lambda -> SQS queue
                                      |
                                      v
                             Worker Lambda / ECS task -> Bedrock InvokeModel
                                      |
                                      v
                             Result to S3 / DynamoDB / SNS notification
```

### Streaming

- **Bedrock InvokeModelWithResponseStream** / **ConverseStream** returns chunks as the FM generates.
- **API Gateway WebSockets** push chunks to browser as they arrive.
- **AWS AppSync subscriptions** for GraphQL real-time push.
- **Server-Sent Events (SSE)** as an alternative to WebSockets for one-way streaming.
- **API Gateway chunked transfer encoding** for HTTP/1.1 chunked responses.

### Resilience patterns

| Concern | Pattern |
|---------|---------|
| Throttling | SDK exponential backoff with jitter; on-demand burst handled by AWS, otherwise Provisioned Throughput |
| Rate limiting your own clients | API Gateway usage plans + API keys |
| Transient errors | Retry with backoff (built into AWS SDK, configurable) |
| Long failures | Circuit breaker (Step Functions / Lambda counter in DynamoDB) |
| Graceful degradation | Fallback chain: primary model → secondary cheaper model → cached response → static reply |
| Observability | **AWS X-Ray** distributed traces across API Gateway → Lambda → Bedrock |

### Intelligent model routing

| Routing strategy | Implementation |
|------------------|----------------|
| **Static** | Hard-code model in app config (AppConfig) |
| **Content-based** | Step Functions Choice state on input characteristics (length, language, intent) |
| **Metric-based** | Lambda picks model based on current latency / cost / error rate metrics from CloudWatch |
| **Provider-aware** | API Gateway with request transformations to route to different Bedrock providers |

Use cases:
- Route short questions to Haiku, long-context to Sonnet/Opus
- Route code questions to a code-specialized model
- Route non-English queries to a multilingual model
- Route classification tasks to a small fine-tuned model, generation to a big general one

---

## Task 2.5: Implement application integration patterns and development tools

### Frontend integration

- **AWS Amplify** for declarative UI components, AppSync GraphQL backends, and direct integration with Bedrock-backed APIs.
- **API Gateway** + Lambda proxy as the API tier for web/mobile clients.
- **Cognito** for user pools (auth) and identity pools (AWS resource access).

### API-first / OpenAPI

- Define your GenAI APIs with **OpenAPI specifications** so SDKs can be generated for clients in any language.
- API Gateway can import OpenAPI definitions directly.
- This pattern makes the "GenAI gateway" approach consistent across teams.

### No-code GenAI workflows

- **Amazon Bedrock Prompt Flows**: visual workflow builder for prompt chains - good for non-developers building automations.
- **Amazon Q Business Apps**: build internal GenAI apps over your enterprise data with no code (knowledge base + actions).
- **Step Functions Workflow Studio**: visual editor for state machines (developer-oriented).

### Business system enhancements

| Use case | Pattern |
|----------|---------|
| **CRM enhancement** | Lambda triggered by Salesforce / HubSpot webhook → Bedrock to summarize/classify → write back via API |
| **Document processing** | Step Functions orchestrating Textract → Comprehend → Bedrock → DynamoDB |
| **Internal knowledge** | Amazon Q Business with data sources (S3, SharePoint, Salesforce, ServiceNow, Confluence, etc.) |
| **End-to-end automation of doc workflows** | **Amazon Bedrock Data Automation** for unified PDF/image/audio/video extraction + summarization without writing the pipeline |

### Developer productivity with Q Developer

- Inline code suggestions in IDE (VS Code, JetBrains, Visual Studio)
- Code refactoring / explaining
- Generating unit tests
- AWS-aware: knows IAM policies, CloudFormation, CDK, AWS SDK
- Q Developer Agents: multi-step refactor, feature implementation across files
- **Q Developer for transformation**: Java upgrades, .NET porting

Useful exam framing: Q Developer is the **developer-side** GenAI assistant; Q Business is the **end-user / employee-side** assistant.

### Advanced GenAI applications via orchestration

- **Strands Agents** for code-first agents
- **AWS Agent Squad** for multi-agent orchestration
- **Step Functions** for explicit workflow logic (great for ReAct, retries, human approval)
- **Bedrock prompt chaining** via Prompt Flows for sequential prompts

### Troubleshooting tooling

- **CloudWatch Logs Insights** queries over Bedrock invocation logs for prompt analysis (e.g., find all prompts with token count > 1000).
- **AWS X-Ray** distributed traces for end-to-end latency and bottleneck identification across API Gateway → Lambda → Bedrock.
- **Q Developer** for explaining stack traces and recognizing GenAI-specific error patterns.

---

## Gotchas and exam traps

- **"Quickest way to integrate FM into existing enterprise app without writing code"** → **Bedrock Prompt Flows** (no-code) or **Q Business Apps** (no-code with enterprise data). Don't pick Step Functions.
- **"Long-running batch generation over many docs"** → SQS + Lambda worker (or **Bedrock batch inference**), not synchronous API Gateway calls (would time out).
- **"Token-by-token UI experience"** → **streaming Bedrock APIs (ConverseStream)** + WebSockets / AppSync subscriptions / SSE. Polling is wrong.
- **"Stop a runaway agent"** → Step Functions stopping conditions + Lambda timeouts + IAM resource boundaries + Guardrails. The exam wants the **layered** answer.
- **"Coordinate multiple specialized agents"** → **AWS Agent Squad** (open source) or Bedrock AgentCore.
- **"Reusable, AWS-native tool layer for many agents"** → **MCP servers**, Lambda for stateless / ECS for stateful. Function calling alone is not the answer when the question emphasizes reusability.
- **"On-prem regulated data with FM access"** → **AWS Outposts** + VPC + Bedrock VPC endpoints.
- **"Cost spike protection on FM usage"** → **AWS Cost Anomaly Detection** + Lambda / EventBridge to disable / throttle. Cost Explorer alone is reactive, not preventive.
- **"Fine-tuned Bedrock model invocation"** → **Provisioned Throughput**, not on-demand.
- **"Build internal employee assistant over SharePoint + Salesforce + S3"** → **Amazon Q Business**, not custom RAG.
- **"AI helps developers refactor / explain code"** → **Amazon Q Developer**, not Q Business.
- **"Centralized FM access with auth, rate limiting, audit, routing"** → **GenAI gateway** pattern with API Gateway + Lambda + Guardrails + CloudTrail + AppConfig.
- **"Test prompts as part of CI/CD"** → CodePipeline + CodeBuild + Lambda test runner + **Bedrock Model Evaluations** for evaluation jobs.
- **"Distributed trace across FM call chain"** → **AWS X-Ray**, not just CloudWatch Logs.
- **"FM provider switch without redeploy"** → **AppConfig** (config-only switch) or API Gateway with request transformations.

---

## Quick-recall summary

- **Agentic stack**: Bedrock **Agents** (managed) → Bedrock **AgentCore** (production runtime) → **Strands Agents** (code SDK) → **AWS Agent Squad** (multi-agent) → **Step Functions** (custom orchestration).
- **MCP**: AWS-native tool servers; Lambda for stateless, ECS for stateful, MCP clients in agents.
- **Reasoning**: CoT, ReAct, plan-and-execute, reflection, tree of thoughts.
- **Memory**: short (in-context), long (DynamoDB), episodic (vector store), AgentCore Memory (managed).
- **Safeguards**: Step Functions stopping conditions, Lambda timeouts, IAM boundaries, circuit breakers, Guardrails, output validation.
- **Multi-agent**: supervisor + workers (AWS Agent Squad), pipelines, ensembles.
- **HITL**: A2I (review), Ground Truth (labeling), Step Functions wait-for-callback (approval), API Gateway (feedback).
- **Deployment**: Bedrock on-demand vs Provisioned Throughput vs SageMaker endpoints (real-time / async / serverless / batch / MME).
- **Fine-tuned Bedrock model = Provisioned Throughput required.**
- **Model cascading**: cheap → expensive escalation; reduces cost.
- **SageMaker JumpStart** for one-click open-source LLM deployment; **SageMaker Neo** for edge compilation.
- **Enterprise connectivity**: API Gateway (sync), EventBridge (async), AppFlow (SaaS), DataSync (file), DMS (CDC), VPC endpoints (private).
- **Identity**: IAM Identity Center for federation; IAM RBAC; tag-based ABAC; least privilege.
- **Hybrid/edge**: Outposts (on-prem), Wavelength (5G edge), Lambda@Edge.
- **CI/CD pattern**: CodePipeline + CodeBuild + automated tests + Bedrock Model Evaluations + GenAI gateway deploy.
- **GenAI gateway** = central abstraction layer with auth, Guardrails, rate limit, audit, routing.
- **Sync / async / streaming** decision: interactive (sync), large/batch (SQS+Lambda or Bedrock batch), real-time UX (streaming + WebSockets/SSE/AppSync).
- **Resilience**: SDK backoff, API Gateway rate limit, circuit breakers, fallback chain, X-Ray traces.
- **Routing**: static (AppConfig), content-based (Step Functions Choice), metric-based (Lambda+CloudWatch), provider-aware (API Gateway transforms).
- **Frontend**: Amplify, API Gateway, Cognito.
- **No-code workflows**: Bedrock Prompt Flows, Q Business Apps.
- **Business systems**: Lambda+webhook for CRM, Step Functions for doc workflows, Q Business for internal knowledge, Bedrock Data Automation for end-to-end doc understanding.
- **Q Developer** = developer-side; **Q Business** = employee-side. Don't confuse.
- **Troubleshooting**: CloudWatch Logs Insights for prompt analysis, X-Ray for traces, Q Developer for error pattern recognition.
