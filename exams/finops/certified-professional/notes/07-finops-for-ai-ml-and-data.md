# 07. FinOps for AI/ML and Data Platforms

## Why AI/ML Changes the FinOps Game

AI/ML workloads have cost profiles that do not behave like traditional cloud usage:

- GPU scarcity creates non-linear pricing
- Training is bursty and large; inference is steady and scales with users
- LLM API calls are priced per token, not per compute-hour
- Vector databases and retrieval pipelines add new cost categories
- Cost can grow 10x in weeks when a product succeeds

FinOps for AI is the fastest-evolving area of the practice. The Professional exam treats it as an applied domain, not a memorization topic.

## Cost Profiles by AI/ML Workload Type

### Training
- GPU-dominated, often multi-day runs
- Bursty: minimal baseline, large peaks
- Commitment-friendly only if utilization is steady (rare for experimentation)
- Spot and reserved capacity both play a role
- Cost per run is the natural unit

### Fine-tuning
- Smaller than full training but still GPU-intensive
- Often iterative; governance can bloat cost
- Caching of base model artifacts matters

### Inference (hosted models)
- Steady-state if product has traffic
- Cost scales with users and prompt complexity
- Latency-sensitive, limits spot and scheduling options
- Quantization, batching, and caching are the core levers

### LLM API (OpenAI, Anthropic, Bedrock, Gemini)
- Per-token pricing with different rates for input and output
- Context window size affects cost
- Cached prompts and prefix caching often 50-90 percent cheaper
- No infrastructure cost directly, but integration and egress cost elsewhere

### RAG and retrieval
- Vector DB cost (Pinecone, Weaviate, OpenSearch, pgvector, etc.)
- Embedding generation cost (model calls for each document)
- Reranker cost (often a smaller model call)
- Data freshness tradeoffs (reindex cost)

### Data engineering
- Ingestion, cleaning, labeling (often labor-dominated, not cloud-dominated)
- Feature stores (storage + compute)
- Experimentation platforms (tracking, artifacts)

## Core Cost Levers by Workload

### For inference (in order of impact)
1. Model selection (smaller model often matches quality with 10x lower cost)
2. Quantization (int8, int4, FP8) and distillation
3. Caching (prompt prefix cache, response cache)
4. Batching and micro-batching
5. Provisioned capacity where predictable
6. Request routing by complexity (cheap path for easy queries)

### For training
1. Spot / preemptible GPU capacity
2. Multi-node efficiency (avoid communication bottleneck waste)
3. Checkpointing strategy (balance compute redo vs storage cost)
4. Off-peak scheduling
5. Right-sized GPU generation for workload

### For LLM APIs
1. Cached prompt usage (dramatically cheaper for repeated prefixes)
2. Model tier selection (Haiku vs Sonnet vs Opus; GPT-4o-mini vs GPT-4o)
3. Output length control (max_tokens caps)
4. Retrieval augmentation to reduce context size
5. Batch endpoints for non-realtime work

## Pricing Patterns to Understand

### GPU on-demand tiers
- H100, H200, B200: premium, often scarce
- A100: previous generation, still widely used
- L40S, L4: inference-optimized, cheaper per request
- T4: older inference
- Trainium/Inferentia (AWS): custom silicon, often competitive
- TPU (GCP): Google custom silicon for training and inference

### GPU reserved and committed capacity
- AWS: Capacity Blocks, Capacity Reservations, EC2 Savings Plans (limited GPU applicability)
- Azure: Reservations for specific VM sizes
- GCP: Committed Use Discounts for specific GPU families

### LLM API
- Per-token input and output pricing
- Cached prompt pricing (large discount for prefix reuse)
- Batch API pricing (often 50 percent discount)
- Fine-tuned model pricing (often higher per token)
- Provisioned throughput (flat rate for guaranteed capacity)

## Data Platform FinOps

Snowflake, Databricks, BigQuery, Redshift each have distinct cost levers.

### Snowflake
- Warehouse sizing and auto-suspend
- Materialized views and result caching
- Resource monitors and query timeouts
- Storage lifecycle (Time Travel retention)
- Multi-cluster warehouse scaling policy

### Databricks
- Cluster auto-termination
- Job clusters vs all-purpose clusters
- Photon runtime (performance uplift often pays for itself)
- Delta optimize, Z-order, liquid clustering
- SQL warehouse sizing and caching

### BigQuery
- On-demand vs capacity (editions)
- Partitioning and clustering
- Query cost optimization (SELECT * avoidance)
- Materialized views and BI Engine

### Redshift
- RA3 nodes with managed storage
- Concurrency scaling
- Workload management (WLM)
- Reserved nodes vs serverless

Unit economics for data platforms: cost per transformation, cost per query, cost per dashboard view, cost per feature build.

## Governance for AI/ML

### Prevention
- Per-team budget caps on API keys
- Model whitelist (approved models with cost tiers)
- Context window limits
- Prompt and output size limits
- Experimentation quotas

### Detection
- Per-key, per-model daily spend tracking
- Anomaly detection on token usage
- Caching hit rate monitoring
- Idle GPU detection

### Review
- Cost review gate before production promotion
- Architecture review for new AI features
- Quarterly model portfolio review (retire what is not cost-effective)

## Unit Economics for AI

Choose units that expose efficiency:

- Cost per inference
- Cost per session
- Cost per active user
- Cost per successful task (if outputs are graded)
- Cost per prompt token cached vs not cached
- Cost per 1000 embeddings
- GPU hour utilization (training)

Report these alongside quality metrics. A 30 percent cost reduction at 5 percent quality loss is not always a win; context matters.

## Common Exam Traps

- Applying traditional rightsizing to GPUs without knowing generation fit
- Committing long-term on experimental workloads
- Ignoring caching as a first-line LLM lever
- Treating training and inference as the same cost problem
- Confusing LLM API egress with model training cost
- Overlooking vector DB and embedding cost in RAG economics
- Missing batch API discounts for non-realtime workloads
- Governing experimentation to death instead of providing guardrails
