# NCP-GENL Generative AI & LLMs Professional Study Plan

## 8-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: LLM Architecture and Transformer Fundamentals
**Focus:** Core architecture concepts and model families

#### Day 1-2: Transformer Deep Dive
- [ ] Review transformer architecture - attention, FFN, normalization
- [ ] Study self-attention mechanism and multi-head attention math
- [ ] Understand positional encoding - sinusoidal, learned, RoPE
- [ ] Read about pre-norm vs post-norm layer normalization
- [ ] **Reference:** [NVIDIA NeMo GPT Training Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/gpt/gpt_training.html)

#### Day 3-4: Model Families and Tokenization
- [ ] Study GPT-style decoder-only architectures
- [ ] Learn LLaMA design choices - RoPE, SwiGLU, GQA
- [ ] Understand Mixture of Experts (MoE) architecture and routing
- [ ] Study tokenization - BPE, SentencePiece, vocabulary tradeoffs
- [ ] **Lab:** Explore different tokenizers using HuggingFace tokenizers library

#### Day 5-7: Scaling Laws and Model Selection
- [ ] Study Chinchilla scaling laws and compute-optimal training
- [ ] Learn about training FLOPS estimation
- [ ] Understand model size vs data size tradeoffs
- [ ] Review multi-modal architectures (vision-language models)
- [ ] **Practice:** Calculate memory requirements for different model sizes

### Week 2: NeMo Framework and Training Basics
**Focus:** Setting up NeMo and understanding distributed training

#### Day 1-2: NeMo Framework Setup
- [ ] Install NeMo Framework using NGC containers
- [ ] Explore NeMo configuration system (Hydra/OmegaConf)
- [ ] Understand NeMo model checkpoints and formats
- [ ] Run a basic NeMo training example
- [ ] **Reference:** [NeMo Framework Documentation](https://docs.nvidia.com/nemo-framework/user-guide/latest/overview.html)

#### Day 3-4: Distributed Training Fundamentals
- [ ] Study data parallelism and gradient synchronization
- [ ] Learn tensor parallelism (Megatron-style column/row splits)
- [ ] Understand pipeline parallelism and micro-batching
- [ ] Study 3D parallelism combinations
- [ ] **Reference:** [NeMo Parallelism Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/parallelisms.html)

#### Day 5-7: Training Best Practices
- [ ] Study mixed precision training - BF16, FP16, loss scaling
- [ ] Learn gradient accumulation and effective batch size
- [ ] Understand learning rate schedules - warmup, cosine decay
- [ ] Practice gradient clipping and training stability techniques
- [ ] **Lab:** Configure and run a multi-GPU training job with NeMo

### Phase 2: Fine-Tuning and Inference (Weeks 3-5)

#### Week 3: Fine-Tuning Methods

#### Day 1-2: PEFT Methods
- [ ] Study LoRA - low-rank matrix decomposition in attention layers
- [ ] Learn QLoRA - quantized base model with LoRA adapters
- [ ] Understand P-tuning - soft prompt optimization
- [ ] Compare adapter methods and their memory profiles
- [ ] **Reference:** [NeMo PEFT Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/peft/landing_page.html)

#### Day 3-4: SFT and RLHF
- [ ] Study Supervised Fine-Tuning (SFT) data formats and pipelines
- [ ] Learn reward model training from preference data
- [ ] Understand PPO for RLHF training
- [ ] Study Direct Preference Optimization (DPO) as alternative
- [ ] **Lab:** Fine-tune a model with LoRA using NeMo Framework

#### Day 5-7: Data Preparation
- [ ] Study NeMo Data Curator for data processing
- [ ] Learn data quality filtering and deduplication
- [ ] Understand instruction formatting and chat templates
- [ ] Practice data curation for fine-tuning workflows
- [ ] **Practice:** Prepare a custom dataset for fine-tuning

### Week 4: Inference Optimization with TensorRT-LLM

#### Day 1-2: TensorRT-LLM Fundamentals
- [ ] Install and configure TensorRT-LLM
- [ ] Understand model compilation to TensorRT engines
- [ ] Learn the TensorRT-LLM Python API
- [ ] Study supported model architectures
- [ ] **Reference:** [TensorRT-LLM Quick Start](https://nvidia.github.io/TensorRT-LLM/quick-start-guide.html)

#### Day 3-4: Quantization
- [ ] Study FP8 quantization on Hopper GPUs
- [ ] Learn INT8 and INT4 quantization techniques
- [ ] Understand AWQ and GPTQ post-training quantization
- [ ] Practice calibration and accuracy validation
- [ ] **Reference:** [TensorRT-LLM Quantization](https://nvidia.github.io/TensorRT-LLM/reference/precision.html)

#### Day 5-7: Batching and Performance
- [ ] Study continuous batching and in-flight batching
- [ ] Learn KV cache management and paged attention
- [ ] Understand speculative decoding for latency reduction
- [ ] Practice benchmarking with TensorRT-LLM tools
- [ ] **Lab:** Compile and benchmark a model with different quantization levels

### Week 5: RAG Pipelines

#### Day 1-2: RAG Architecture
- [ ] Study end-to-end RAG pipeline architecture
- [ ] Learn document ingestion - loading, parsing, chunking
- [ ] Understand embedding model selection and tradeoffs
- [ ] Explore vector database options (Milvus, FAISS, pgvector)
- [ ] **Reference:** [NVIDIA RAG Pipeline Guide](https://docs.nvidia.com/ai-enterprise/workflows-generative-ai/latest/rag/index.html)

#### Day 3-4: Retrieval Optimization
- [ ] Study chunking strategies - fixed-size, semantic, recursive
- [ ] Learn hybrid search - dense vector + sparse keyword
- [ ] Understand re-ranking with cross-encoder models
- [ ] Practice query expansion and reformulation
- [ ] **Reference:** [NeMo Retriever](https://docs.nvidia.com/nim/nemo-retriever/latest/index.html)

#### Day 5-7: RAG Evaluation and Production
- [ ] Study retrieval metrics - precision, recall, MRR, NDCG
- [ ] Learn generation evaluation - faithfulness, relevance
- [ ] Understand end-to-end RAG evaluation frameworks
- [ ] Practice building a complete RAG pipeline with NVIDIA tools
- [ ] **Lab:** Build and evaluate a RAG system end-to-end

### Phase 3: Production and Exam Prep (Weeks 6-8)

#### Week 6: Production Deployment

#### Day 1-2: NVIDIA NIM Deployment
- [ ] Study NIM architecture and deployment options
- [ ] Deploy a model using NIM containers
- [ ] Learn NIM API endpoints (OpenAI-compatible)
- [ ] Understand NIM configuration and optimization
- [ ] **Reference:** [NIM Getting Started](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)

#### Day 3-4: Serving and Scaling
- [ ] Study load balancing for inference services
- [ ] Learn auto-scaling with Kubernetes HPA
- [ ] Understand Triton Inference Server for multi-model serving
- [ ] Practice A/B testing and canary deployments
- [ ] **Reference:** [Triton Inference Server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)

#### Day 5-7: Safety and Monitoring
- [ ] Study NeMo Guardrails framework
- [ ] Learn input/output safety filtering
- [ ] Understand monitoring - latency, throughput, GPU metrics
- [ ] Practice implementing guardrails for an LLM application
- [ ] **Reference:** [NeMo Guardrails](https://docs.nvidia.com/nemo/guardrails/latest/index.html)

### Week 7: Review and Practice Exams

#### Day 1-3: Domain Review
- [ ] Review all five domains systematically
- [ ] Create flashcards for key concepts and numbers
- [ ] Re-read NVIDIA documentation for weak areas
- [ ] Complete any unfinished labs

#### Day 4-5: Practice Questions
- [ ] Work through scenario-based practice questions
- [ ] Focus on questions combining multiple domains
- [ ] Review answers and identify remaining gaps
- [ ] Study common distractors and traps

#### Day 6-7: Gap Analysis
- [ ] Identify weakest domain areas
- [ ] Deep-dive into areas with lowest confidence
- [ ] Re-read relevant documentation sections
- [ ] Practice explaining concepts out loud

### Week 8: Final Preparation

#### Day 1-3: Intensive Review
- [ ] Review fact sheet and key reference numbers
- [ ] Practice rapid-fire concept identification
- [ ] Review all NVIDIA tool configurations and commands
- [ ] Focus on production deployment patterns

#### Day 4-5: Final Practice
- [ ] Complete a full-length timed practice session (120 minutes)
- [ ] Review all incorrect answers
- [ ] Final review of weak areas

#### Day 6: Rest and Light Review
- [ ] Light review of fact sheet only
- [ ] Prepare exam logistics and setup
- [ ] Get good rest before exam day

#### Day 7: Exam Day
- [ ] Review key concepts briefly (30 minutes max)
- [ ] Verify exam environment and connectivity
- [ ] Take the exam with confidence
- [ ] Use flagging strategy for uncertain questions

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** Understand transformer architecture, NeMo basics, distributed training
- **Week 3:** Master fine-tuning methods (LoRA, RLHF, data prep)
- **Week 4:** Proficient with TensorRT-LLM optimization and quantization
- **Week 5:** Build and evaluate RAG pipelines end-to-end
- **Week 6:** Deploy production systems with NIM, guardrails, monitoring
- **Week 7:** Complete practice questions, identify and fill gaps
- **Week 8:** Final review and exam

### Self-Assessment Questions
- Can I explain the transformer architecture and its variants?
- Do I know when to use LoRA vs QLoRA vs full fine-tuning?
- Can I select the right quantization strategy for a given constraint?
- Can I design a production RAG pipeline with NVIDIA tools?
- Do I understand NIM deployment and scaling strategies?
- Can I implement guardrails for safe LLM applications?
