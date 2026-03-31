# TensorRT-LLM - NCP-GENL

## Overview

TensorRT-LLM is NVIDIA's high-performance inference library for large language models. It compiles models into optimized TensorRT engines with support for quantization, advanced batching, multi-GPU inference, and custom plugins. Understanding TensorRT-LLM is essential for deploying LLMs with optimal throughput and latency on NVIDIA GPUs.

**[📖 TensorRT-LLM Documentation](https://nvidia.github.io/TensorRT-LLM/)** - Complete documentation
**[📖 TensorRT-LLM GitHub](https://github.com/NVIDIA/TensorRT-LLM)** - Source code and examples

## Key Topics

### 1. TensorRT-LLM Architecture

**Compilation Pipeline**
- Define model architecture in TensorRT-LLM Python API
- Build TensorRT engine from model definition
- Engine optimizes operations for target GPU architecture
- Serialized engine file for deployment

**Supported Models**
- GPT, LLaMA, Mistral, Mixtral, Falcon, Gemma
- BLOOM, GPT-J, GPT-NeoX, StarCoder
- ChatGLM, Baichuan, Qwen
- Custom models through extensible architecture

**Key Features**
- Multi-GPU inference with tensor parallelism
- Pipeline parallelism for very large models
- In-flight batching for optimal GPU utilization
- Paged KV cache for memory efficiency
- Multiple quantization modes

**[📖 TensorRT-LLM Quick Start](https://nvidia.github.io/TensorRT-LLM/quick-start-guide.html)** - Getting started guide

### 2. Model Compilation Process

**Step 1: Convert Model Weights**
- Convert HuggingFace or NeMo checkpoints to TensorRT-LLM format
- Apply quantization during conversion if desired
- Handle sharding for multi-GPU configurations

**Step 2: Build TensorRT Engine**
- Specify model architecture and optimization parameters
- Set maximum batch size, input length, output length
- Configure tensor parallelism degree
- Select precision (FP16, BF16, FP8, INT8, INT4)

**Step 3: Deploy Engine**
- Load compiled engine for inference
- Configure runtime parameters (batching, KV cache)
- Serve through Triton or NIM

**Configuration Parameters**
- `max_batch_size` - maximum concurrent requests
- `max_input_len` - maximum input sequence length
- `max_output_len` - maximum generation length
- `max_beam_width` - beam search width
- `tp_size` - tensor parallelism degree
- `pp_size` - pipeline parallelism degree

**[📖 TensorRT-LLM Build](https://nvidia.github.io/TensorRT-LLM/quick-start-guide.html)** - Engine building guide

### 3. Quantization

**FP8 (Hopper GPUs)**
- Native hardware support on H100/H200
- E4M3 format for weights, E5M2 for gradients
- Minimal accuracy degradation (<1% on most benchmarks)
- 2x throughput improvement over FP16
- Requires Hopper architecture or newer

**INT8 (Ampere+)**
- Weight-only quantization: weights INT8, compute in FP16
- Weight-and-activation quantization: both INT8
- SmoothQuant: migrate quantization difficulty to weights
- ~2x memory reduction, significant throughput improvement

**INT4 (Weight-Only)**
- 4x memory reduction compared to FP16
- Enables running larger models on fewer GPUs
- AWQ (Activation-Aware Weight Quantization) - preserves important weights
- GPTQ - post-training quantization with calibration data
- Higher accuracy loss than INT8 - validate carefully

**Calibration Process**
- Run representative data through model to collect activation statistics
- Use calibration data to determine quantization scales
- Typically 128-512 samples sufficient for calibration
- Validate quantized model accuracy on evaluation benchmarks

**[📖 TensorRT-LLM Quantization](https://nvidia.github.io/TensorRT-LLM/reference/precision.html)** - Quantization methods and configuration

### 4. KV Cache Management

**KV Cache Basics**
- Stores key and value tensors for all generated tokens
- Avoids recomputing attention for previous tokens
- Memory = batch_size x num_layers x 2 x seq_len x head_dim x num_heads x precision_bytes

**Paged Attention**
- Allocate KV cache in fixed-size pages (not contiguous blocks)
- Pages allocated on demand as sequences grow
- Eliminates memory waste from pre-allocation
- Similar to virtual memory paging in operating systems

**KV Cache Quantization**
- Store KV cache in INT8 or FP8 instead of FP16
- Reduces KV cache memory by 2x
- Enables larger batch sizes or longer sequences
- Minimal impact on generation quality

**Memory Optimization**
- GQA reduces KV cache size by sharing KV heads
- KV cache reuse for shared prefixes (prompt caching)
- Dynamic memory allocation based on actual sequence lengths

**[📖 TensorRT-LLM KV Cache](https://nvidia.github.io/TensorRT-LLM/advanced/gpt-attention.html)** - Attention and KV cache optimization

### 5. Batching Strategies

**Static Batching**
- Collect requests until batch is full or timeout
- All requests processed together
- Must wait for longest sequence to complete
- Simple but inefficient for variable-length outputs

**Continuous Batching (Dynamic Batching)**
- New requests inserted as slots become available
- Finished requests immediately free their slots
- Much better GPU utilization than static batching
- Default mode for production deployments

**In-Flight Batching**
- Process prefill (prompt processing) and generation simultaneously
- New requests begin prefill while existing requests generate tokens
- Maximizes GPU utilization across both phases
- Supported in TensorRT-LLM executor

**Scheduling Considerations**
- Token budget per iteration limits total tokens processed
- Priority queuing for latency-sensitive requests
- Request cancellation for abandoned queries
- Fairness policies for multi-tenant environments

**[📖 TensorRT-LLM Batch Manager](https://nvidia.github.io/TensorRT-LLM/advanced/batch-manager.html)** - Batching configuration and management

### 6. Performance Optimization

**Speculative Decoding**
- Draft model generates multiple candidate tokens quickly
- Target model verifies candidates in parallel
- Accepted tokens skip individual generation steps
- Can reduce latency by 2-3x for compatible models
- Draft model should be much smaller than target (e.g., 1B drafting for 70B)

**Kernel Fusion**
- Combine multiple GPU operations into single kernels
- Reduce GPU kernel launch overhead
- Fuse attention, normalization, and activation operations
- TensorRT automatically identifies fusion opportunities

**CUDA Graphs**
- Capture and replay GPU operation sequences
- Eliminate CPU overhead from repeated kernel launches
- Especially effective for the decode (generation) phase
- Reduces per-token latency

**Throughput Optimization**
- Increase batch size to maximize GPU compute utilization
- Use continuous batching to keep GPU busy
- Apply quantization to process more tokens per GPU
- Scale horizontally across multiple GPUs

**Latency Optimization**
- Use tensor parallelism to split compute across GPUs
- Apply speculative decoding for faster generation
- Minimize KV cache overhead with paged attention
- Reduce first-token latency with optimized prefill

### 7. Multi-GPU Inference

**Tensor Parallelism**
- Split model layers across GPUs
- Requires NVLink/NVSwitch for efficient communication
- Reduces latency by distributing computation
- Typical configs: TP=2 for 13B, TP=4 for 34B, TP=8 for 70B

**Pipeline Parallelism**
- Split model depth across GPUs
- Can use standard network interconnect
- Better for throughput than latency
- Less communication overhead than tensor parallelism

**Choosing Parallelism**
- Single node with NVLink: prefer tensor parallelism
- Multi-node: consider pipeline parallelism for inter-node
- Latency-critical: maximize tensor parallelism
- Throughput-critical: balance TP and PP

### 8. Integration with Triton Inference Server

**Triton Backend**
- TensorRT-LLM Triton backend for model serving
- Supports all TensorRT-LLM features (batching, KV cache)
- Multi-model serving on same GPU
- Health checks and metrics endpoints

**Configuration**
- Model repository structure for Triton
- Config.pbtxt for model configuration
- Ensemble models for preprocessing + inference
- Dynamic batching configuration

**[📖 Triton Inference Server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)** - Triton documentation
**[📖 TensorRT-LLM Triton Backend](https://github.com/triton-inference-server/tensorrtllm_backend)** - Triton backend for TensorRT-LLM

## Exam Focus Areas

### Critical Concepts
- Understand the full compilation pipeline from model to engine
- Know quantization options and their hardware requirements
- Understand batching strategies and when to use each
- Know KV cache management and paged attention benefits
- Be familiar with multi-GPU parallelism for inference

### Common Exam Questions
- "Which quantization format is native on H100?" - FP8
- "What eliminates KV cache memory fragmentation?" - Paged attention
- "Which batching mode maximizes GPU utilization?" - In-flight batching
- "How to reduce per-token latency?" - Tensor parallelism + speculative decoding
- "Best approach for 70B model inference?" - FP8 quantization + tensor parallelism
