# NeMo Framework - NCP-GENL

## Overview

NVIDIA NeMo Framework is an end-to-end platform for building, training, fine-tuning, and deploying large language models and other generative AI models. It integrates Megatron-LM for distributed training, supports multiple model architectures, and provides tools for data curation, training orchestration, and model export.

**[📖 NeMo Framework Documentation](https://docs.nvidia.com/nemo-framework/user-guide/latest/overview.html)** - Complete NeMo documentation
**[📖 NeMo GitHub Repository](https://github.com/NVIDIA/NeMo)** - Source code, examples, and tutorials

## Key Topics

### 1. NeMo Architecture and Components

**Core Components**
- **NeMo Toolkit:** Core training and fine-tuning library built on PyTorch
- **Megatron Core:** Distributed training engine for large-scale parallelism
- **NeMo Data Curator:** Data processing and filtering pipeline
- **NeMo Aligner:** RLHF and alignment training tools
- **NeMo Export:** Model conversion for inference deployment

**Configuration System**
- Uses Hydra/OmegaConf for hierarchical configuration
- YAML config files define model architecture, training, and data
- Command-line overrides for experiment management
- Reproducible experiments through configuration versioning

**[📖 NeMo Configuration](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/gpt/gpt_training.html)** - Configuration guide for NeMo training

### 2. Supported Model Architectures

**GPT Models**
- GPT-2, GPT-3 style decoder-only architectures
- Configurable model size, layers, attention heads
- Support for custom vocabulary and tokenizers

**LLaMA Family**
- LLaMA, LLaMA 2, LLaMA 3 architectures
- RoPE, SwiGLU, GQA built-in
- Various model sizes from 7B to 70B+

**Mixtral/MoE**
- Mixture of Experts with configurable expert count
- Top-k routing with load balancing
- Expert parallelism support

**Other Architectures**
- Falcon, Gemma, StarCoder
- Custom architectures through modular design
- Easy architecture extension via NeMo modules

**[📖 NeMo Model Zoo](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Supported models and configurations

### 3. Distributed Training with Megatron

**Data Parallelism**
- Replicate model across GPUs, split data batches
- Gradient all-reduce synchronization
- Effective for models that fit in single GPU memory
- Scales throughput linearly with GPU count

**Tensor Parallelism (TP)**
- Split individual layers across GPUs
- Column-parallel and row-parallel linear layers
- Reduces memory per GPU for large models
- Requires high-bandwidth interconnect (NVLink/NVSwitch)

**Pipeline Parallelism (PP)**
- Split model layers into stages across GPUs
- Micro-batching to reduce pipeline bubbles
- Interleaved scheduling for better efficiency
- Useful for very deep models

**Sequence Parallelism (SP)**
- Distribute sequence-length dimension across GPUs
- Reduces activation memory for long sequences
- Often combined with tensor parallelism
- Especially useful for long-context training

**Expert Parallelism (EP)**
- Distribute MoE experts across GPUs
- All-to-all communication for expert routing
- Can combine with tensor and data parallelism

**Configuration Examples**
- 7B model: TP=1, PP=1, DP=8 on 8 GPUs
- 13B model: TP=2, PP=1, DP=4 on 8 GPUs
- 70B model: TP=8, PP=4, DP=4 on 128 GPUs

**[📖 NeMo Parallelism Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/parallelisms.html)** - Distributed training strategies
**[📖 Megatron Core Documentation](https://docs.nvidia.com/megatron-core/developer-guide/latest/index.html)** - Megatron distributed training library

### 4. Training Configuration

**Mixed Precision**
- BF16 training on Ampere and Hopper GPUs
- FP16 with dynamic loss scaling on older GPUs
- Transformer Engine for FP8 on Hopper
- Reduces memory by ~2x compared to FP32

**Optimizer Settings**
- AdamW optimizer with decoupled weight decay
- Fused Adam for GPU-optimized updates
- Gradient accumulation for large effective batch sizes
- Gradient clipping (typically 1.0) for stability

**Learning Rate Schedule**
- Linear warmup phase (typically 1-5% of total steps)
- Cosine decay to minimum learning rate
- Minimum LR typically 10% of peak LR
- Peak LR depends on model size (smaller for larger models)

**Data Loading**
- Memory-mapped datasets for efficient I/O
- Blended datasets from multiple sources
- Data sampling ratios for multi-source training
- Streaming data loading for large datasets

**[📖 NeMo Training Configuration](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/gpt/gpt_training.html)** - Training parameters and configuration

### 5. NeMo Data Curator

**Data Processing Pipeline**
- Document extraction from diverse sources (Common Crawl, PDF, HTML)
- Language identification using FastText classifiers
- Quality scoring with heuristic and model-based filters
- Near-duplicate detection using MinHash LSH
- PII (Personally Identifiable Information) detection and removal

**Quality Filtering**
- Perplexity-based quality scoring
- Document length and repetition filters
- URL-based filtering (blocklists, allowlists)
- Classifier-based content filtering

**Scaling**
- Distributed processing with Dask and RAPIDS
- GPU-accelerated deduplication
- Handles TB-scale datasets efficiently
- Configurable pipeline stages

**[📖 NeMo Data Curator](https://docs.nvidia.com/nemo-framework/user-guide/latest/datacuration/index.html)** - Data curation documentation

### 6. Checkpointing and Model Management

**Checkpoint Types**
- NeMo checkpoints (.nemo format) - bundled model + config
- Distributed checkpoints - sharded across GPUs
- Megatron checkpoints - legacy format support

**Checkpoint Operations**
- Save/resume training from any checkpoint
- Convert between checkpoint formats
- Merge distributed checkpoints for deployment
- Extract model weights for inference export

**Model Hub Integration**
- Download models from NGC catalog
- Upload custom models to NGC
- HuggingFace model conversion support

### 7. NeMo Launcher

**Multi-Node Training Orchestration**
- Launch training across multiple nodes seamlessly
- Support for Slurm, Kubernetes, and cloud platforms
- Automatic resource allocation and scheduling
- Experiment tracking and logging

**Cluster Configuration**
- GPU topology awareness
- Network configuration for NCCL
- Storage configuration for checkpoints and data
- Environment variable management

**[📖 NeMo Launcher](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Multi-node training launcher documentation

## Exam Focus Areas

### Critical Concepts
- Understand when to use each parallelism strategy (TP, PP, DP, SP, EP)
- Know how to configure NeMo for different model sizes and GPU counts
- Understand the NeMo Data Curator pipeline and its capabilities
- Be familiar with checkpoint management and model export
- Know mixed precision options and their hardware requirements

### Common Exam Questions
- "Which parallelism reduces per-GPU memory for large layers?" - Tensor parallelism
- "What tool processes TB-scale training data?" - NeMo Data Curator
- "How to reduce pipeline bubble overhead?" - Micro-batching and interleaved scheduling
- "Which precision requires Hopper GPUs?" - FP8 via Transformer Engine
- "Best parallelism for 70B model on 128 GPUs?" - 3D parallelism (TP+PP+DP)
