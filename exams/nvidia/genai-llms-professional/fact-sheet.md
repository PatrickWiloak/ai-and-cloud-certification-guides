# NVIDIA Generative AI & LLMs Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-GENL
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| LLM Architecture and Foundations | 20% | Transformer internals, model families, tokenization, scaling |
| Training and Fine-Tuning at Scale | 20% | NeMo Framework, PEFT, RLHF, distributed training |
| Inference Optimization | 20% | TensorRT-LLM, quantization, batching, KV cache |
| Prompt Engineering and RAG | 20% | RAG pipelines, vector DBs, prompt strategies, evaluation |
| Production Deployment and Operations | 20% | NIM, serving at scale, monitoring, guardrails |

## Domain 1: LLM Architecture and Foundations

### Transformer Architecture
- Self-attention mechanism computes query, key, value projections
- Multi-head attention enables learning different representation subspaces
- Layer normalization variants - pre-norm (GPT-style) vs post-norm
- Positional encoding - sinusoidal, learned, RoPE (Rotary Position Embedding)
- Feed-forward networks with activation functions (GeLU, SwiGLU)
- Residual connections for gradient flow in deep networks
- **[📖 Transformer Architecture](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/gpt/gpt_training.html)** - NeMo GPT training architecture guide
- **[📖 NVIDIA AI Foundation Models](https://docs.nvidia.com/ai-foundation-models/index.html)** - Pre-trained model catalog and capabilities

### Model Families and Design Choices
- **GPT-style (decoder-only):** Autoregressive generation, causal attention masks
- **LLaMA family:** RoPE, SwiGLU activation, RMS normalization, grouped-query attention
- **Mixtral/MoE:** Sparse mixture of experts, router networks, expert parallelism
- **Gemma:** Efficient small models, multi-query attention
- **Falcon:** Multi-query attention, refined data curation
- **[📖 NeMo Supported Models](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Models supported in NeMo Framework

### Tokenization
- Byte Pair Encoding (BPE) - iterative merging of frequent byte pairs
- SentencePiece - language-agnostic subword tokenization
- WordPiece - vocabulary-based subword splitting
- Vocabulary size tradeoffs - larger vocab = shorter sequences but more parameters
- Special tokens - BOS, EOS, PAD, system/user/assistant tokens for chat
- **[📖 NeMo Tokenizers](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/batching.html)** - Tokenization in NeMo

### Scaling Laws
- Chinchilla scaling - optimal compute allocation between model size and data
- Training FLOPS estimation and compute budgets
- Loss prediction based on model and data scaling
- Diminishing returns at extreme scales
- Implications for model architecture selection

## Domain 2: Training and Fine-Tuning at Scale

### Distributed Training Strategies
- **Data Parallelism:** Replicate model across GPUs, split data batches
- **Tensor Parallelism:** Split individual layers across GPUs (Megatron-style)
- **Pipeline Parallelism:** Split model layers across GPUs in stages
- **Expert Parallelism:** Distribute MoE experts across GPUs
- **3D Parallelism:** Combine data, tensor, and pipeline parallelism
- **ZeRO optimization:** Partition optimizer states, gradients, parameters
- **[📖 NeMo Distributed Training](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/parallelisms.html)** - Parallelism strategies in NeMo
- **[📖 Megatron Core](https://docs.nvidia.com/megatron-core/developer-guide/latest/index.html)** - Megatron-LM distributed training library

### NVIDIA NeMo Framework
- End-to-end framework for training, fine-tuning, and deploying LLMs
- Built on PyTorch with Megatron-LM integration
- Supports GPT, LLaMA, Mixtral, Falcon, and other architectures
- NeMo Launcher for cluster-scale training orchestration
- NeMo Data Curator for training data processing and filtering
- **[📖 NeMo Framework Overview](https://docs.nvidia.com/nemo-framework/user-guide/latest/overview.html)** - Complete NeMo documentation
- **[📖 NeMo GitHub Repository](https://github.com/NVIDIA/NeMo)** - Source code and examples
- **[📖 NeMo Launcher](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Multi-node training launcher

### Parameter-Efficient Fine-Tuning (PEFT)
- **LoRA:** Low-rank adaptation - inject trainable low-rank matrices into attention layers
- **QLoRA:** Quantized base model + LoRA adapters for memory efficiency
- **P-tuning:** Trainable soft prompts prepended to input
- **Adapter layers:** Small trainable modules inserted between frozen layers
- LoRA rank selection - higher rank = more capacity but more parameters
- Typical LoRA alpha and dropout hyperparameters
- **[📖 NeMo PEFT Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/peft/landing_page.html)** - PEFT methods in NeMo

### RLHF and Alignment
- Supervised Fine-Tuning (SFT) as initial alignment step
- Reward model training from human preference data
- Proximal Policy Optimization (PPO) for RLHF
- Direct Preference Optimization (DPO) as simpler alternative to PPO
- SteerLM - attribute-conditioned generation for controllability
- **[📖 NeMo Aligner](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - RLHF and alignment in NeMo

### Training Best Practices
- Mixed precision training with BF16/FP16 and loss scaling
- Gradient accumulation for effective large batch sizes
- Learning rate scheduling - warmup, cosine decay, linear decay
- Gradient clipping for training stability
- Checkpoint management and resumption strategies
- Data loading optimization for multi-node training

## Domain 3: Inference Optimization

### TensorRT-LLM
- High-performance inference library for LLMs on NVIDIA GPUs
- Compiles models into optimized TensorRT engines
- Supports multi-GPU inference with tensor parallelism
- Built-in support for popular model architectures
- Custom plugin system for extending functionality
- **[📖 TensorRT-LLM Documentation](https://nvidia.github.io/TensorRT-LLM/)** - Complete TensorRT-LLM guide
- **[📖 TensorRT-LLM GitHub](https://github.com/NVIDIA/TensorRT-LLM)** - Source code and examples
- **[📖 TensorRT-LLM Quick Start](https://nvidia.github.io/TensorRT-LLM/quick-start-guide.html)** - Getting started guide

### Quantization Techniques
- **FP8:** Native on Hopper GPUs, minimal accuracy loss
- **INT8:** 2x memory reduction, supported on Ampere+
- **INT4:** 4x memory reduction, best for memory-constrained deployments
- **AWQ (Activation-Aware Weight Quantization):** Preserves salient weights
- **GPTQ:** Post-training quantization using calibration data
- **SmoothQuant:** Migrate quantization difficulty from activations to weights
- Calibration datasets and accuracy validation after quantization
- **[📖 TensorRT-LLM Quantization](https://nvidia.github.io/TensorRT-LLM/reference/precision.html)** - Quantization support and methods

### KV Cache Management
- KV cache stores key-value pairs for all previous tokens
- Memory grows linearly with sequence length and batch size
- Paged attention - allocate KV cache in non-contiguous memory pages
- KV cache quantization (INT8/FP8) for memory savings
- Multi-query attention and grouped-query attention reduce KV cache size
- Cache eviction strategies for long-context scenarios

### Batching Strategies
- **Static batching:** Fixed batch size, wait for all requests
- **Continuous batching:** Insert new requests as slots become available
- **In-flight batching:** Process prefill and generation simultaneously
- Token-level scheduling for optimal GPU utilization
- Dynamic batch size based on sequence lengths
- **[📖 TensorRT-LLM Batching](https://nvidia.github.io/TensorRT-LLM/advanced/batch-manager.html)** - Batch management in TensorRT-LLM

### Performance Optimization
- **Speculative decoding:** Draft model generates candidates, target model verifies
- **Flash Attention:** Memory-efficient attention computation
- **Kernel fusion:** Combine multiple operations into single GPU kernels
- **CUDA graphs:** Reduce CPU overhead for repetitive GPU operations
- Throughput vs latency tradeoffs in serving configuration
- **[📖 NVIDIA Triton Inference Server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)** - Multi-model serving platform

## Domain 4: Prompt Engineering and RAG

### Advanced Prompt Engineering
- **Zero-shot:** Direct task instruction without examples
- **Few-shot:** Include examples to guide model behavior
- **Chain-of-thought (CoT):** Elicit step-by-step reasoning
- **Self-consistency:** Sample multiple reasoning paths and vote
- **Tree of thought:** Explore multiple reasoning branches
- System prompts for persona and behavior control
- Output format control - JSON, XML, structured responses
- **[📖 NVIDIA AI Playground](https://build.nvidia.com/)** - Test prompts with NVIDIA models

### RAG Pipeline Architecture
- **Ingestion:** Document loading, parsing, chunking
- **Embedding:** Convert text to dense vector representations
- **Indexing:** Store embeddings in vector database
- **Retrieval:** Query vector DB for relevant documents
- **Generation:** Augment LLM prompt with retrieved context
- **[📖 NVIDIA RAG Example](https://docs.nvidia.com/ai-enterprise/workflows-generative-ai/latest/rag/index.html)** - RAG pipeline with NVIDIA stack
- **[📖 NVIDIA Retrieval QA](https://developer.nvidia.com/blog/build-enterprise-retrieval-augmented-generation-apps-with-nvidia-retrieval-qa-embedding-model/)** - Enterprise RAG with NVIDIA

### Vector Databases and Embeddings
- Embedding model selection - dimensions, context length, performance
- NVIDIA NeMo Retriever for embedding and re-ranking
- Vector similarity search - cosine similarity, dot product, L2 distance
- Approximate nearest neighbor (ANN) algorithms - HNSW, IVF
- Integration with Milvus, FAISS, Weaviate, pgvector, Chroma
- **[📖 NeMo Retriever](https://docs.nvidia.com/nim/nemo-retriever/latest/index.html)** - NVIDIA embedding and retrieval microservices

### Chunking and Retrieval Optimization
- Fixed-size chunking with overlap
- Semantic chunking based on content boundaries
- Recursive character text splitting
- Chunk size optimization - balance between context and specificity
- Hybrid search - combine dense vector and sparse keyword retrieval
- Re-ranking with cross-encoder models for improved precision
- Query expansion and reformulation techniques

### RAG Evaluation
- Retrieval metrics - precision, recall, MRR, NDCG
- Generation metrics - faithfulness, relevance, completeness
- End-to-end evaluation frameworks
- Human evaluation protocols
- Automated evaluation with LLM judges

## Domain 5: Production Deployment and Operations

### NVIDIA NIM Microservices
- Pre-packaged, optimized containers for model inference
- One-command deployment with Docker or Kubernetes
- Built-in TensorRT-LLM optimization
- OpenAI-compatible API endpoints
- Support for multiple GPU architectures
- Auto-scaling with Kubernetes HPA
- **[📖 NVIDIA NIM Overview](https://docs.nvidia.com/nim/index.html)** - NIM documentation
- **[📖 NIM Quick Start](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Deploy your first NIM
- **[📖 NIM API Reference](https://docs.nvidia.com/nim/large-language-models/latest/reference.html)** - API documentation

### Model Serving at Scale
- Load balancing across multiple GPU instances
- Auto-scaling based on queue depth and latency metrics
- Multi-model serving with Triton Inference Server
- A/B testing frameworks for model comparison
- Blue-green deployments for zero-downtime updates
- Resource allocation and GPU sharing strategies
- **[📖 Triton Model Analyzer](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/user_guide/model_analyzer.html)** - Performance analysis tool

### Monitoring and Observability
- Inference latency tracking (time-to-first-token, inter-token latency)
- Throughput monitoring (tokens/second, requests/second)
- GPU utilization and memory monitoring
- Model quality metrics in production
- Alerting on SLA violations
- Logging and distributed tracing
- **[📖 NVIDIA DCGM](https://docs.nvidia.com/datacenter/dcgm/latest/user-guide/index.html)** - GPU monitoring and management

### Safety and Guardrails
- Input filtering for harmful content
- Output guardrails for factuality and safety
- NVIDIA NeMo Guardrails framework
- Topical guardrails - keep conversations on-topic
- Jailbreak detection and prevention
- Content moderation integration
- **[📖 NeMo Guardrails](https://docs.nvidia.com/nemo/guardrails/latest/index.html)** - Guardrails framework documentation
- **[📖 NeMo Guardrails GitHub](https://github.com/NVIDIA/NeMo-Guardrails)** - Open-source guardrails toolkit

### Cost Optimization
- Right-sizing GPU instances for workloads
- Quantization to reduce GPU memory and increase throughput
- Batching optimization to maximize GPU utilization
- Spot/preemptible instances for non-critical workloads
- Multi-tenancy and resource sharing
- Cost-per-token analysis and budgeting

## Exam Tips

### Key Concepts to Master
1. Understand the full lifecycle - from training to production inference
2. Know when to use each PEFT method (LoRA vs P-tuning vs full fine-tuning)
3. Understand quantization tradeoffs (accuracy vs speed vs memory)
4. Know RAG pipeline components and optimization strategies
5. Be familiar with NIM deployment and configuration options

### Common Exam Patterns
- "Which optimization would best improve..." - think about the specific bottleneck
- "What is the most cost-effective approach..." - consider quantization and batching
- "How would you deploy..." - think NIM and Triton first
- "What fine-tuning method..." - match PEFT method to constraints

### Critical Numbers to Know
- Typical model sizes: 7B, 13B, 34B, 70B parameters
- FP16 memory = parameters x 2 bytes (7B model ~ 14GB)
- INT8 memory = parameters x 1 byte (7B model ~ 7GB)
- INT4 memory = parameters x 0.5 bytes (7B model ~ 3.5GB)
- KV cache grows with batch_size x seq_len x num_layers x hidden_dim x 2
- Common LoRA rank values: 8, 16, 32, 64
