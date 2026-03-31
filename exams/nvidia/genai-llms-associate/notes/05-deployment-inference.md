# Deployment and Inference Optimization

**[📖 NVIDIA NIM Documentation](https://docs.nvidia.com/nim/index.html)** - NVIDIA Inference Microservices
**[📖 TensorRT-LLM Documentation](https://nvidia.github.io/TensorRT-LLM/)** - High-performance LLM inference

## NVIDIA NIM (NVIDIA Inference Microservices)

### Overview

NIM provides pre-optimized, containerized inference microservices for deploying AI models on NVIDIA GPUs. It wraps TensorRT-LLM optimizations in an easy-to-deploy container with an OpenAI-compatible API.

**[📖 NVIDIA NIM for LLMs](https://docs.nvidia.com/nim/large-language-models/latest/index.html)** - LLM deployment with NIM

### Key Features

- **Pre-optimized containers** - ready-to-deploy Docker images
- **OpenAI-compatible API** - familiar chat completion and completion endpoints
- **Automatic optimization** - selects best configuration for the available GPU
- **Multiple model support** - LLMs, embedding models, reranking models
- **Health monitoring** - built-in health check endpoints
- **Enterprise support** - part of NVIDIA AI Enterprise platform

### Deployment

```bash
# Example NIM deployment
docker run -d --gpus all \
  -e NGC_API_KEY=<key> \
  -p 8000:8000 \
  nvcr.io/nim/meta/llama-3.1-8b-instruct:latest
```

### When to Use NIM

- Production model serving with minimal configuration
- Standard model architectures (LLaMA, Mistral, etc.)
- OpenAI API-compatible applications
- Quick deployment without manual optimization
- Enterprise deployments with support requirements

## TensorRT-LLM

### Overview

TensorRT-LLM is NVIDIA's open-source library for optimizing LLM inference performance. It compiles models into optimized TensorRT engines with LLM-specific optimizations.

**[📖 TensorRT-LLM GitHub](https://github.com/NVIDIA/TensorRT-LLM)** - Source code and examples

### Optimization Techniques

**Graph Optimization:**
- Operator fusion - combine multiple operations into single kernels
- Constant folding - pre-compute constant expressions
- Dead code elimination - remove unused computations
- Memory planning - optimize tensor memory allocation

**Kernel Optimization:**
- Custom CUDA kernels for transformer operations
- Fused attention kernels (Flash Attention integration)
- Optimized GEMM operations for different precisions
- Efficient softmax and layer normalization kernels

### NIM vs TensorRT-LLM

| Aspect | NVIDIA NIM | TensorRT-LLM |
|---|---|---|
| Level | High-level deployment | Low-level optimization |
| Ease of use | Simple (Docker pull and run) | Requires model compilation |
| Customization | Limited | Extensive |
| API | OpenAI-compatible REST API | Python/C++ library |
| Underlying engine | Uses TensorRT-LLM internally | Direct engine access |
| Best for | Production deployment | Custom optimization |

## Triton Inference Server

**[📖 Triton Inference Server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)** - Multi-framework model serving

### Features

- **Multi-framework support** - TensorRT, PyTorch, TensorFlow, ONNX, Python
- **Dynamic batching** - groups incoming requests for efficiency
- **Model ensembles** - chain multiple models in a pipeline
- **Concurrent model execution** - run multiple models on same GPU
- **Model versioning** - A/B testing and rolling updates
- **Metrics** - Prometheus-compatible monitoring
- **gRPC and HTTP** - dual protocol support

### When to Use Triton

- Serving multiple models on the same infrastructure
- Complex inference pipelines (preprocessing + model + postprocessing)
- Multi-framework environments
- Need for detailed performance monitoring
- Custom batching or scheduling requirements

**[📖 Triton Model Analyzer](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/user_guide/model_analyzer.html)** - Performance profiling tool

## Quantization Methods

### Overview

Quantization reduces model precision from higher-bit to lower-bit representations, decreasing memory usage and increasing inference speed with some quality trade-off.

### Precision Formats

**FP32 (32-bit floating point):**
- Full precision, baseline quality
- 4 bytes per parameter
- Rarely used for inference (wasteful)

**FP16 / BF16 (16-bit):**
- Half precision, negligible quality loss
- 2 bytes per parameter
- BF16 has larger dynamic range than FP16 (preferred for training)
- Standard for most inference workloads

**FP8 (8-bit floating point):**
- Available on H100 and newer GPUs (Hopper architecture)
- Minimal quality loss for most models
- 1 byte per parameter
- Hardware-native support for maximum speed
- Two formats: E4M3 (more precision) and E5M2 (more range)

**INT8 (8-bit integer):**
- Post-training quantization with calibration
- SmoothQuant - handles activation outliers for better INT8 quality
- 1 byte per parameter
- Widely supported across GPU generations

**INT4 (4-bit integer):**
- Aggressive compression, noticeable quality impact for some models
- 0.5 bytes per parameter
- Methods: AWQ, GPTQ

### Quantization Methods

**AWQ (Activation-aware Weight Quantization):**
- Identifies important weight channels based on activation magnitudes
- Preserves salient weights at higher precision
- Good quality-compression trade-off
- Popular for INT4 quantization

**GPTQ (Generative Pre-trained Transformer Quantization):**
- Layer-wise quantization with calibration data
- Uses approximate second-order information
- Requires calibration dataset (typically 128-256 samples)
- Good for INT4 and INT3 quantization

**SmoothQuant:**
- Migrates quantization difficulty from activations to weights
- Enables accurate INT8 quantization for both weights and activations (W8A8)
- Multiplicative transformation applied offline

### Quantization Comparison

| Method | Bits | Quality | Speed Gain | Memory Savings | GPU Support |
|---|---|---|---|---|---|
| FP16/BF16 | 16 | Baseline | 1x | 50% vs FP32 | All modern |
| FP8 | 8 | Near-baseline | 2x+ | 75% vs FP32 | H100+ |
| INT8 (SmoothQuant) | 8 | Good | 1.5-2x | 75% vs FP32 | A100+ |
| INT4 (AWQ) | 4 | Good | 2-3x | 87.5% vs FP32 | A100+ |
| INT4 (GPTQ) | 4 | Good | 2-3x | 87.5% vs FP32 | A100+ |

## KV-Cache and Memory Management

### KV-Cache Basics

- During autoregressive generation, each new token needs attention over all previous tokens
- KV-cache stores computed Key and Value tensors from previous tokens
- Avoids recomputing attention for the entire sequence at each step
- Memory grows linearly with: batch_size x sequence_length x num_layers x hidden_size

### KV-Cache Memory Calculation

```
KV-cache size = 2 (K and V) x batch_size x seq_length x num_layers x num_kv_heads x head_dim x bytes_per_element
```

For a 7B model (32 layers, 32 KV heads, 128 head dim) in FP16:
- Per-token per-batch: 2 x 32 x 32 x 128 x 2 bytes = 512 KB
- 2048 tokens, batch 32: ~33 GB of KV-cache alone

### Paged Attention

**[📖 vLLM Documentation](https://docs.vllm.ai/)** - PagedAttention and efficient serving

- Manages KV-cache like virtual memory pages
- Allocates memory in fixed-size blocks instead of contiguous allocation
- Eliminates internal fragmentation (wastes less memory)
- Enables memory sharing between requests with common prefixes
- Allows more concurrent requests on the same GPU

## Batching Strategies

### Static Batching
- Fixed batch of requests processed together
- All requests must complete before new batch starts
- Short requests wait for longest request in batch
- Simple but inefficient for variable-length outputs

### Dynamic Batching
- Groups incoming requests within a configurable time window
- Forms batches based on available requests
- Better utilization than static batching
- Still waits for entire batch to complete

### Continuous (In-Flight) Batching
- New requests can join as soon as a slot frees up
- Does not wait for entire batch to complete
- Completed requests are immediately returned
- Maximum GPU utilization for LLM serving
- Used by TensorRT-LLM, vLLM, and NIM

### Batching Comparison

| Strategy | Throughput | Latency | Complexity |
|---|---|---|---|
| Static | Low | Variable | Simple |
| Dynamic | Medium | Better | Medium |
| Continuous | High | Best | Complex |

## Model Parallelism

### Tensor Parallelism (TP)
- Splits individual layers across multiple GPUs
- Each GPU computes a portion of every layer
- Requires high-bandwidth interconnect (NVLink)
- Typical: TP=2, 4, or 8 within a single node
- Best for: reducing per-GPU memory, latency-sensitive workloads

### Pipeline Parallelism (PP)
- Assigns different layers to different GPUs
- Requests flow through GPUs sequentially
- Can work across nodes with lower bandwidth
- Introduces pipeline bubbles (some idle time)
- Best for: very large models spanning multiple nodes

### Expert Parallelism (EP)
- For Mixture-of-Experts (MoE) models
- Different experts placed on different GPUs
- Router determines which expert processes each token
- Reduces compute per token (only active experts run)

## Speculative Decoding

### How It Works
1. **Draft model** (small, fast) generates k candidate tokens
2. **Target model** (large, accurate) verifies all k tokens in one forward pass
3. Accepted tokens are kept; rejected tokens trigger re-generation
4. Net effect: multiple tokens generated per target model forward pass

### Benefits
- Reduces end-to-end latency for generation
- No quality loss (target model validates all tokens)
- Most effective when draft model has high acceptance rate

### Requirements
- Draft model must be significantly faster than target model
- Draft model should have reasonable agreement with target
- Additional memory for draft model parameters

## Key Concepts for the Exam

### Tool Selection
- **Easy deployment**: NIM (Docker container, OpenAI API)
- **Custom optimization**: TensorRT-LLM (compile and optimize)
- **Multi-model serving**: Triton Inference Server
- **Maximum throughput**: Continuous batching + quantization

### Common Exam Questions
- NIM vs TensorRT-LLM? (NIM wraps TensorRT-LLM for easy deployment)
- Best quantization for H100? (FP8 - native hardware support)
- What is paged attention? (virtual memory-style KV-cache management)
- Static vs continuous batching? (continuous removes batch completion bottleneck)
- Tensor vs pipeline parallelism? (tensor = within layers across GPUs, pipeline = layers across GPUs)
- Why use speculative decoding? (reduce latency without quality loss)
