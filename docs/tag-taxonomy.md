---
last-updated: 2026-05-03
---

# Tag taxonomy

This doc defines the canonical tag set for the optional `tags:` frontmatter field. Tags are not currently required - they're a forward-looking convention so future indexing, filtering, and cross-link tooling has a stable vocabulary to work against.

If you author or refresh a content page and want to tag it, pick from the lists below. **Don't invent new tags ad-hoc** - if a needed tag is missing, propose it via PR to this file first, then apply.

## Frontmatter shape

```yaml
---
last-updated: 2026-05-03
applies-to: AWS console as of 2026-Q2     # optional
difficulty: beginner                       # optional: beginner | intermediate | advanced
reading-time: 10 min                       # optional
tags: [aws, security, iam, identity]       # optional, lowercase, kebab-case
---
```

## Why a fixed taxonomy

A free-form tag field on 1000+ pages becomes useless within months: typos, near-synonyms (`k8s` vs `kubernetes`), inconsistent granularity (`security` vs `cloud-security` vs `iam-security`), and abandoned tags. A fixed vocabulary stays useful as the repo grows.

## The tag set

Tags fall into 5 dimensions. A page typically gets 3-6 tags total, picking one or two from each relevant dimension. Don't over-tag; a tag should be material to discovery.

### 1. Provider

One per page when the page is provider-specific. Skip when the page is provider-neutral (concepts, glossary, day-one).

| Tag | Meaning |
|---|---|
| `aws` | Amazon Web Services |
| `azure` | Microsoft Azure |
| `gcp` | Google Cloud Platform |
| `kubernetes` | CNCF / Kubernetes (vendor-neutral) |
| `oracle` | Oracle Cloud Infrastructure |
| `ibm` | IBM Cloud |
| `cisco` | Cisco |
| `redhat` | Red Hat |
| `salesforce` | Salesforce |
| `hashicorp` | HashiCorp (Terraform, Vault, Consul, Nomad) |
| `databricks` | Databricks |
| `snowflake` | Snowflake |
| `mongodb` | MongoDB |
| `confluent` | Confluent / Kafka |
| `nvidia` | NVIDIA |
| `anthropic` | Anthropic / Claude |
| `openai` | OpenAI |
| `google-deepmind` | Google DeepMind / Gemini |
| `multi-cloud` | Spans multiple providers |

### 2. Domain

Pick 1-3. These describe what the page is *about* at a domain level.

| Tag | Meaning |
|---|---|
| `compute` | VMs, containers, serverless |
| `storage` | Object, block, file storage |
| `database` | Relational, NoSQL, data warehouse, vector |
| `networking` | VPC, DNS, load balancing, hybrid, multi-cloud |
| `security` | Threat detection, posture, compliance, IAM |
| `iam` | Identity, access, RBAC, ABAC, federation |
| `observability` | Logging, metrics, tracing, APM |
| `devops` | CI/CD, IaC, GitOps |
| `data` | Pipelines, lakehouse, ETL, streaming |
| `ai-ml` | Training, serving, MLOps, GenAI |
| `llm` | LLM-specific topics (RAG, agents, prompt eng) |
| `serverless` | Functions, event-driven, managed runtimes |
| `containers` | Docker, container runtime, registries |
| `cost` | FinOps, cost optimization, pricing models |
| `compliance` | SOC 2, HIPAA, PCI, GDPR, FedRAMP |

### 3. Format

Pick 1. Describes the *shape* of the page, not its topic.

| Tag | Meaning |
|---|---|
| `concept` | Plain-English explanation page |
| `cert-prep` | Material specifically for an exam |
| `comparison` | Cross-provider or cross-product comparison |
| `decision-matrix` | Score-driven product pick |
| `playbook` | Operational runbook / step-by-step guide |
| `reference` | Reference / cheat sheet |
| `roadmap` | Career or learning path |
| `architecture-pattern` | Reusable architecture write-up |
| `postmortem` | Real-incident study |
| `playlist` | Curated reading sequence |
| `hands-on` | Hands-on build / lab |
| `interview-prep` | Interview preparation |
| `troubleshooting` | Diagnostic / problem-resolution guide |

### 4. Audience

Pick 0-2. Describes who the page is for.

| Tag | Meaning |
|---|---|
| `beginner` | No prior cloud experience needed |
| `practitioner` | Already working in the field |
| `architect` | Senior / decision-making level |
| `student` | Studying for a specific exam |
| `non-cert` | Reader is *not* studying for a cert |

### 5. Topic specifier (optional)

For pages where a more specific signal helps discovery. Use sparingly - if a topic specifier appears on fewer than ~5 pages it's not worth a global tag.

Currently sanctioned specifiers:
- `vector-db` (vector databases)
- `prompt-engineering`
- `evals` (LLM evaluation)
- `service-mesh`
- `gitops`
- `zero-trust`
- `disaster-recovery`
- `multi-region`
- `chaos-engineering`
- `observability-traces`
- `cost-anomaly`

Propose a new specifier via PR if you need it on 3+ pages.

## Examples

A vector-database comparison:
```yaml
tags: [comparison, ai-ml, llm, vector-db, multi-cloud]
```

An AWS hybrid-connectivity deep dive:
```yaml
tags: [aws, networking, reference, architect]
```

A beginner Day-One page on SSH:
```yaml
tags: [concept, beginner, non-cert, security]
```

A postmortem on the 2017 S3 outage:
```yaml
tags: [postmortem, aws, storage, architect]
```

A scenarios.md file in a cert dir:
```yaml
tags: [cert-prep, aws, security, student]
```

## Anti-patterns

- **Don't tag with the page's title** - "tag: vector-databases" duplicates the slug. The tag should be the *category*, not the *identity*.
- **Don't over-specialize** - "tag: aws-rds-postgres" is not useful. "tag: aws, database" is.
- **Don't synonym** - pick `iam` and stick with it; don't also use `identity` and `access-management` interchangeably.
- **Don't hierarchy in the tag** - tags are flat. "tag: security/compliance/soc2" should be "tags: [security, compliance]" with the page's title carrying SOC 2 context.

## When to backfill

Don't open a PR that adds tags to thousands of files in one pass. Tag pages opportunistically when you author or substantively edit them. The taxonomy grows in usefulness with consistent application over time, not with bulk backfills.
