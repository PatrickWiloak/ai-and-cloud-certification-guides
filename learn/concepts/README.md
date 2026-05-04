# 💡 Concepts - Bite-Size Topic Pages

> **Single-topic explanations. 5-10 minute reads. No exam scaffolding.**
>
> Read one when you keep seeing a term and want to actually understand it.

---

## How these are organized

Each page covers one concept:
- What it is, in plain English
- Why it exists (the problem it solves)
- A small concrete example
- What to look at next

These are not exam-objective summaries. They're "explain it like I'm a smart engineer who just hasn't been exposed to this yet."

If you want exam coverage, head back to the [Study Hub](../../STUDY-HUB.md).

**Brand new to all of this?** Start with **[Day One](../day-one/)** - terminal, git, HTTP, and servers - then come back here once that vocabulary feels familiar.

**Want a curated path through these?** Try **[Cloud from Scratch](../cloud-from-scratch.md)** or **[AI from Scratch](../ai-from-scratch.md)**, which order the concepts into 8-phase paths.

**Want them grouped by subject across the whole repo?** See the **[topic indexes](../../topics/)**.

---

## ☁️ Cloud Computing

| Topic | Read when... |
|-------|--------------|
| [What is cloud computing?](./what-is-cloud-computing.md) | You want the foundational mental model |
| [IaaS vs PaaS vs SaaS](./iaas-paas-saas.md) | The three terms keep coming up |
| [Regions and availability zones](./regions-and-availability-zones.md) | You're asking "where does my code actually run?" |
| [Shared responsibility model](./shared-responsibility-model.md) | You're wondering "what's AWS's job vs mine?" |
| [VPC explained](./vpc-explained.md) | Networking inside the cloud confuses you |
| [IAM explained](./iam-explained.md) | "Roles vs policies vs federation" is fuzzy |
| [Serverless explained](./serverless-explained.md) | You keep hearing "serverless" without a clear definition |
| [CDN explained](./cdn-explained.md) | You see CloudFront/CloudFlare/Akamai and wonder what they do |

## ☸️ Containers and Orchestration

| Topic | Read when... |
|-------|--------------|
| [Containers vs VMs](./containers-vs-vms.md) | You don't know why containers replaced VMs |
| [Kubernetes in 10 minutes](./kubernetes-in-10-minutes.md) | Everyone uses K8s; you want to know why |

## 🛠️ DevOps / Infrastructure

| Topic | Read when... |
|-------|--------------|
| [Terraform explained](./terraform-explained.md) | You want to understand IaC without diving into HCL |
| [CI/CD explained](./cicd-explained.md) | "Pipelines" is hand-waved everywhere; you want specifics |
| [Observability basics](./observability-basics.md) | "Logs vs metrics vs traces" needs a one-page answer |
| [Idempotency explained](./idempotency-explained.md) | You're worried about retries doing things twice |
| [Eventual consistency](./eventual-consistency.md) | A read returned stale data and you want to know why |
| [Queues vs streams](./queues-vs-streams.md) | You can't pick between SQS and Kinesis |

## 🌐 Networking and Security

| Topic | Read when... |
|-------|--------------|
| [DNS explained](./dns-explained.md) | You want to understand how the internet finds things |
| [TLS and HTTPS](./tls-and-https.md) | You want to know what the lock icon actually means |

## 🤖 AI / Machine Learning - foundations

| Topic | Read when... |
|-------|--------------|
| [LLM basics](./llm-basics.md) | You want to understand what a language model actually does |
| [Transformer architecture](./transformer-architecture.md) | You're ready to look inside the model |
| [Embeddings and vector search](./embeddings-and-vector-search.md) | You want to understand semantic search |
| [Context windows and management](./context-windows-and-management.md) | You're hitting token limits in production |
| [Multimodal models](./multimodal-models.md) | You want to use images / audio / video in prompts |

## 🤖 AI / Machine Learning - building with LLMs

| Topic | Read when... |
|-------|--------------|
| [Prompt engineering](./prompt-engineering.md) | You want to write prompts that actually work |
| [Tool use and function calling](./tool-use-and-function-calling.md) | You want the model to call your code |
| [MCP explained](./mcp-explained.md) | "Model Context Protocol" keeps coming up |
| [Structured outputs](./structured-outputs.md) | You want guaranteed-valid JSON from the model |
| [RAG explained](./rag-explained.md) | "Retrieval-augmented generation" is everywhere |
| [Fine-tuning vs RAG](./fine-tuning-vs-rag.md) | You want to know which one to reach for |
| [AI agents explained](./agents-explained.md) | You're trying to figure out what "agent" really means |
| [Agentic loops](./agentic-loops.md) | You want the deep-dive on the loop, not just the concept |
| [Prompt caching](./prompt-caching.md) | Your input costs are higher than they should be |

## 🤖 AI / Machine Learning - operations

| Topic | Read when... |
|-------|--------------|
| [Evals for LLMs](./evals-for-llms.md) | You're shipping LLM features and wondering how to test them |
| [Guardrails and safety](./guardrails-and-safety.md) | You're worried about prompt injection or unsafe output |
| [Inference servers](./inference-servers.md) | You're considering self-hosting an open-weights model |
| [Quantization and distillation](./quantization-and-distillation.md) | You want a smaller, faster model |

---

## 🔁 Companion docs

- **[Glossary](../glossary.md)** - 200+ terms, one-line definitions
- **[Cloud from Scratch](../cloud-from-scratch.md)** - structured 8-phase cloud path
- **[AI from Scratch](../ai-from-scratch.md)** - structured AI/LLM learning path
- **[YouTube curation](../youtube.md)** - videos for visual learners
- **[Topic indexes](../../topics/)** - browse Learn + Build + Compare + Certify by subject

---

## 🤝 Suggest a topic

Missing a concept you keep getting asked about? Open an issue or PR. Criteria for new pages:
- One topic, focused
- 5-10 minute read
- Plain English, no exam framing
- Concrete example included

[Contributing Guide](../../CONTRIBUTING.md)
