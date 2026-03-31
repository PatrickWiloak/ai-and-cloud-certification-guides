# NCP-GENL High-Yield Scenarios & Patterns

## Scenario 1: Enterprise LLM Fine-Tuning

### Context
A financial services company wants to fine-tune a 70B parameter LLM on their proprietary documents for internal Q&A. They have limited GPU resources (4x A100 80GB GPUs) and need the model ready within a week.

**Solution Pattern:**
- **Method:** QLoRA fine-tuning with 4-bit quantized base model
- **Framework:** NVIDIA NeMo Framework with PEFT configuration
- **Rank:** LoRA rank 16-32 for good quality-efficiency balance
- **Data:** Instruction-formatted Q&A pairs from internal documents
- **Training:** Single-node 4-GPU setup with data parallelism

**Why QLoRA over full fine-tuning:**
- 70B model in FP16 requires ~140GB VRAM - exceeds 4x80GB even with parallelism overhead
- QLoRA with 4-bit quantization needs ~35GB for base model + small LoRA overhead
- Trains only ~0.1% of parameters - much faster convergence
- Quality nearly matches full fine-tuning for domain adaptation

**Common Distractors:**
- Full fine-tuning (wrong - insufficient VRAM for 70B model on 4 GPUs)
- P-tuning only (wrong - limited capacity for complex domain adaptation)
- Training from scratch (wrong - impractical compute and data requirements)
- Using a 7B model instead (wrong - question specifies 70B and doesn't mention switching)

---

## Scenario 2: Inference Latency Optimization

### Context
An AI chatbot serving 1000 concurrent users experiences high latency (8 seconds time-to-first-token). The deployment uses a 13B model on 2x A100 GPUs with static batching and FP16 precision.

**Solution Pattern:**
- **Step 1:** Switch from static to continuous/in-flight batching
- **Step 2:** Apply INT8 or FP8 quantization to reduce memory and increase throughput
- **Step 3:** Enable paged attention for efficient KV cache management
- **Step 4:** Use TensorRT-LLM to compile optimized inference engine
- **Tool:** Deploy with NVIDIA NIM for pre-optimized serving

**Why this approach works:**
- Continuous batching eliminates waiting for full batch completion
- Quantization doubles throughput with minimal accuracy loss
- Paged attention reduces memory waste from KV cache fragmentation
- TensorRT-LLM kernel fusion reduces GPU operation overhead

**Common Distractors:**
- Adding more GPUs without optimization (wrong - addresses symptom, not cause)
- Reducing model size (wrong - may degrade quality; optimize first)
- Increasing batch size with static batching (wrong - makes latency worse)
- Client-side caching only (wrong - doesn't solve inference bottleneck)

---

## Scenario 3: RAG Pipeline for Legal Documents

### Context
A law firm needs a RAG system that accurately retrieves relevant case law and generates legally precise answers. Documents range from 2 to 200 pages. Users report that answers sometimes cite irrelevant cases or miss key precedents.

**Solution Pattern:**
- **Chunking:** Semantic chunking with 512-token chunks and 50-token overlap
- **Embedding:** High-quality embedding model (e.g., NV-Embed) for legal text
- **Retrieval:** Hybrid search combining dense vector + BM25 keyword search
- **Re-ranking:** Cross-encoder re-ranker to improve precision in top results
- **Generation:** Instruct model with strict citation requirements in system prompt
- **Evaluation:** Measure retrieval recall and answer faithfulness metrics

**Why hybrid search + re-ranking:**
- Dense search captures semantic similarity but can miss exact legal terms
- BM25 keyword search catches precise legal terminology and case numbers
- Re-ranking refines initial retrieval results for higher precision
- Cross-encoder model compares query-document pairs more accurately than bi-encoder

**Common Distractors:**
- Larger chunks only (wrong - large chunks dilute relevance signal)
- Keyword search only (wrong - misses semantically similar but differently worded passages)
- Simply increasing top-k retrieval (wrong - adds noise without improving quality)
- Fine-tuning the LLM on all legal documents (wrong - RAG is better for up-to-date retrieval)

---

## Scenario 4: Multi-GPU Model Deployment

### Context
A company needs to serve a 70B parameter model for real-time inference with a latency SLA of under 2 seconds for 256-token responses. They have NVIDIA H100 GPUs available.

**Solution Pattern:**
- **Quantization:** FP8 quantization (native H100 support) - reduces to ~70GB
- **GPU Layout:** 2x H100 80GB with tensor parallelism
- **Engine:** TensorRT-LLM compiled engine with FP8 precision
- **Serving:** NVIDIA NIM with continuous batching enabled
- **KV Cache:** Paged attention with FP8 KV cache quantization

**Why FP8 on H100:**
- H100 has native FP8 Transformer Engine support
- FP8 provides 2x throughput over FP16 with negligible accuracy loss
- Model fits on 2 GPUs with room for KV cache
- Native hardware support means no software overhead

**Common Distractors:**
- INT4 quantization (wrong - FP8 is better on H100 with less accuracy loss)
- 4x GPU pipeline parallelism (wrong - tensor parallelism is better for latency)
- FP16 without quantization (wrong - needs 4 GPUs and higher latency)
- CPU offloading (wrong - violates latency SLA)

---

## Scenario 5: Training Data Preparation at Scale

### Context
A company has 10TB of web-crawled text data and wants to prepare it for pretraining a custom LLM. The data contains duplicates, low-quality text, toxic content, and multiple languages.

**Solution Pattern:**
- **Deduplication:** MinHash-based fuzzy deduplication to remove near-duplicates
- **Quality Filtering:** Perplexity-based filtering using a reference language model
- **Toxicity Filtering:** Classifier-based content filtering for harmful content
- **Language Detection:** FastText language ID to separate/filter languages
- **Tool:** NeMo Data Curator for scalable data processing pipeline
- **Format:** Convert to tokenized binary format for efficient training

**Why NeMo Data Curator:**
- Designed for large-scale training data processing
- Distributed processing for TB-scale datasets
- Built-in quality and toxicity classifiers
- Integrates directly with NeMo training pipelines

**Common Distractors:**
- Manual review of all documents (wrong - impractical at 10TB scale)
- Simple exact-match deduplication (wrong - misses near-duplicates)
- No filtering, rely on model robustness (wrong - garbage in, garbage out)
- Using only regex for quality filtering (wrong - too simplistic for content quality)

---

## Scenario 6: Guardrails for Customer-Facing Chatbot

### Context
A healthcare company deploys an LLM chatbot for patient inquiries. The bot must not provide medical diagnoses, must stay on-topic, and must refuse to discuss competitors. The system also needs protection against prompt injection attacks.

**Solution Pattern:**
- **Framework:** NVIDIA NeMo Guardrails
- **Topical Guardrails:** Define allowed topics (appointments, general health info, insurance)
- **Safety Guardrails:** Block medical diagnosis or treatment recommendations
- **Input Filtering:** Detect and block prompt injection attempts
- **Output Filtering:** Verify responses don't contain restricted medical advice
- **Competitor Filter:** Custom rail to detect and redirect competitor mentions
- **Fallback:** Graceful escalation to human agent for edge cases

**Why NeMo Guardrails:**
- Programmable rails for custom business logic
- Colang scripting for defining conversation flows
- Supports both input and output filtering
- Integrates with any LLM backend

**Common Distractors:**
- System prompt only (wrong - can be bypassed with prompt injection)
- Post-processing regex filters (wrong - too brittle for natural language)
- Fine-tuning the model to refuse (wrong - not reliable for all edge cases)
- Blocking all health-related queries (wrong - too restrictive, poor user experience)

---

## Scenario 7: Model Evaluation and Selection

### Context
A team has fine-tuned three variants of a 13B model for code generation: one with full SFT, one with LoRA rank 16, and one with LoRA rank 64. They need to select the best model for production deployment where both quality and inference cost matter.

**Solution Pattern:**
- **Benchmarks:** Evaluate on HumanEval, MBPP, and custom internal code benchmarks
- **Metrics:** Pass@1, Pass@10, functional correctness rate
- **Latency Test:** Measure time-to-first-token and tokens-per-second for each
- **Cost Analysis:** Compare GPU memory usage and throughput for each variant
- **Decision Framework:** If LoRA rank 64 matches SFT quality, prefer it for lower training cost and adapter flexibility

**Key Considerations:**
- Full SFT typically has best quality but highest training cost and no adapter merging
- LoRA rank 64 often approaches SFT quality for domain-specific tasks
- LoRA rank 16 is most memory-efficient but may underperform on complex tasks
- Adapter-based models can be swapped without reloading base model

**Common Distractors:**
- Choosing only by perplexity (wrong - perplexity doesn't directly measure code quality)
- Always choosing full SFT (wrong - may not justify cost if LoRA matches quality)
- Choosing lowest rank for cost (wrong - must validate quality first)
- Ignoring inference performance (wrong - production cost matters)

---

## Scenario 8: Scaling RAG for Enterprise

### Context
An enterprise RAG system serves 500 users with 10 million documents. Users report slow retrieval (5+ seconds) and the system struggles during peak hours. Current setup uses a single vector database instance and one embedding model replica.

**Solution Pattern:**
- **Embedding Service:** Scale NIM embedding microservice horizontally (3-5 replicas)
- **Vector Database:** Shard the vector index across multiple nodes (Milvus cluster)
- **Caching:** Implement query result caching for frequently asked questions
- **Async Ingestion:** Decouple document ingestion from serving with message queue
- **Load Balancing:** Distribute queries across embedding and retrieval replicas
- **Monitoring:** Track p95 latency, throughput, and cache hit rates

**Why horizontal scaling + sharding:**
- Single embedding replica is the bottleneck for concurrent users
- Vector DB with 10M documents benefits from index sharding
- Caching eliminates redundant computation for popular queries
- Decoupled ingestion prevents document updates from affecting search latency

**Common Distractors:**
- Reducing document count (wrong - business requirement to index all documents)
- Using larger GPU for single instance (wrong - horizontal scaling is more effective)
- Switching to keyword search (wrong - loses semantic retrieval quality)
- Increasing chunk size to reduce document count (wrong - degrades retrieval quality)

## Key Decision Factors

### Optimization Selection Criteria
1. **Identify the bottleneck first:** Is it compute, memory, I/O, or network?
2. **Match quantization to hardware:** FP8 for Hopper, INT8 for Ampere
3. **Consider the full pipeline:** Don't optimize one component while ignoring others
4. **Measure before and after:** Always benchmark with representative workloads
5. **Balance quality and cost:** Cheapest isn't always best if quality suffers
