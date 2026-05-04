---
last-updated: 2026-05-03
---

# Hands-on projects

Fifteen guided builds: ten cloud, five AI. Each has an estimated time, a goal you can articulate to an interviewer, and inline code or commands. Most run on free-tier accounts; the AI builds list cheap cloud-GPU options where local hardware isn't enough.

## Cloud builds (10)

| Build | Time | What you'll have at the end |
|---|---|---|
| [Deploy a 3-tier app](./deploy-3-tier-app.md) | 3-4 hours | LB → app servers → DB on AWS, Azure, or GCP |
| [Build a CI/CD pipeline](./build-ci-cd-pipeline.md) | 4-5 hours | Auto-build, test, and deploy on commit |
| [Set up a monitoring stack](./setup-monitoring-stack.md) | 3-4 hours | Prometheus + Grafana + alertmanager wired end-to-end |
| [Implement zero-trust security](./implement-zero-trust.md) | 4-5 hours | Identity-aware access, no-implicit-trust networking |
| [Build a data pipeline](./build-data-pipeline.md) | 4-5 hours | Ingest → transform → load with scheduled runs |
| [Deploy an ML model](./deploy-ml-model.md) | 3-4 hours | Trained model behind an API endpoint |
| [Set up a Kubernetes cluster](./kubernetes-cluster-setup.md) | 4-5 hours | Production-shaped cluster, ingress, observability |
| [Build infra with Terraform](./terraform-infrastructure.md) | 3-4 hours | VPC + compute + DB declared as code, with state |
| [Build a serverless app](./serverless-application.md) | 3-4 hours | API + queue + function + storage, event-driven |
| [Run a DR drill](./disaster-recovery-drill.md) | 4-6 hours | Tested failover, measured RTO/RPO |

## AI builds (5)

| Build | Time | What you'll have at the end |
|---|---|---|
| [Build a RAG pipeline](./build-rag-pipeline.md) | ~30 min | Docs → chunks → pgvector → Claude with retrieval + evals |
| [Build a Claude agent with MCP](./build-claude-agent-with-mcp.md) | ~30 min | Agent SDK + custom MCP server reading files + SQLite |
| [Run Llama on a single GPU](./run-llama-on-single-gpu.md) | ~45 min | Open-weights model serving locally or on a cheap rented GPU |
| [Set up an eval harness](./set-up-eval-harness.md) | ~30 min | Reproducible eval suite for prompt and model comparisons |
| [Fine-tune with LoRA](./fine-tune-with-lora.md) | 1-2 hours | LoRA-trained small model, merged + served + benchmarked |

## How to pick

- **First-ever cloud build:** [Deploy a 3-tier app](./deploy-3-tier-app.md). Touches networking, compute, identity, and storage in one project.
- **First-ever AI build:** [Build a RAG pipeline](./build-rag-pipeline.md). Most hireable AI pattern in 2026.
- **Interview prep:** [Set up a Kubernetes cluster](./kubernetes-cluster-setup.md), [Build infra with Terraform](./terraform-infrastructure.md), [Build a CI/CD pipeline](./build-ci-cd-pipeline.md). These map to the most common practitioner questions.
- **Cheapest to run:** the five AI builds (under $5 each on rented GPUs); serverless and Terraform on the cloud side (free-tier friendly).
- **Most production-shaped:** [Implement zero-trust](./implement-zero-trust.md), [Run a DR drill](./disaster-recovery-drill.md), [Set up a monitoring stack](./setup-monitoring-stack.md).

## Related

- [Concepts](../../learn/concepts/) - the "why" behind each pattern
- [Architecture patterns](../architecture-patterns/) - reference designs each build follows
- [Topic indexes](../../topics/) - all four pillars per subject
