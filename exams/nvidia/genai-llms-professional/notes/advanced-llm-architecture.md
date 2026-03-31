# Advanced LLM Architecture - NCP-GENL

## Overview

This document covers the foundational architecture concepts for large language models, including transformer internals, model families, tokenization strategies, and scaling laws. Understanding these architectural choices is critical for making informed decisions about model selection, training, and deployment.

**[📖 NVIDIA AI Foundation Models](https://docs.nvidia.com/ai-foundation-models/index.html)** - Catalog of NVIDIA pre-trained and fine-tuned models

## Key Topics

### 1. Transformer Architecture Deep Dive

The transformer architecture is the foundation of all modern LLMs. Key components include:

**Self-Attention Mechanism**
- Computes Query (Q), Key (K), Value (V) projections from input embeddings
- Attention scores = softmax(QK^T / sqrt(d_k)) * V
- Allows each token to attend to all other tokens in the sequence
- Computational complexity is O(n^2) with sequence length n

**Multi-Head Attention**
- Multiple attention heads learn different representation subspaces
- Each head has independent Q, K, V projections
- Outputs concatenated and projected back to model dimension
- Typical head counts: 32 (7B), 40 (13B), 64 (70B)

**[📖 NeMo GPT Architecture](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/gpt/gpt_training.html)** - NeMo implementation of GPT-style models

### 2. Attention Variants

**Multi-Query Attention (MQA)**
- Single K, V head shared across all query heads
- Dramatically reduces KV cache size (important for inference)
- Used in Falcon, PaLM, and other models

**Grouped-Query Attention (GQA)**
- Groups of query heads share K, V heads
- Balance between MQA efficiency and MHA quality
- Used in LLaMA 2 70B, Mixtral
- Typical groups: 8 KV heads for 32 query heads

**Flash Attention**
- Memory-efficient attention computation
- Avoids materializing the full attention matrix
- Reduces memory from O(n^2) to O(n)
- Provides significant speedup for long sequences

**[📖 Flash Attention in TensorRT-LLM](https://nvidia.github.io/TensorRT-LLM/advanced/gpt-attention.html)** - Attention optimizations in TensorRT-LLM

### 3. Positional Encoding

**Sinusoidal Encoding (original Transformer)**
- Fixed positional embeddings using sine and cosine functions
- Limited to trained maximum sequence length

**Learned Positional Embeddings**
- Trainable position vectors
- Also limited to trained maximum length

**Rotary Position Embedding (RoPE)**
- Encodes position through rotation of embedding vectors
- Naturally extends to longer sequences
- Used in LLaMA, Mistral, and most modern models
- Supports position interpolation for context extension

**ALiBi (Attention with Linear Biases)**
- Adds linear bias to attention scores based on position distance
- No positional embeddings needed
- Good extrapolation to longer sequences

### 4. Model Architecture Components

**Feed-Forward Networks (FFN)**
- Two-layer MLP after each attention block
- Standard: Linear -> Activation -> Linear
- SwiGLU variant: Gated activation (LLaMA, Mistral)
- FFN hidden dimension typically 4x or 8/3x model dimension

**Normalization**
- **Pre-Norm:** Normalization before attention/FFN (GPT-2+, LLaMA)
- **Post-Norm:** Normalization after attention/FFN (original Transformer)
- **RMSNorm:** Root Mean Square normalization, simpler than LayerNorm (LLaMA)

**Residual Connections**
- Skip connections around attention and FFN blocks
- Critical for gradient flow in deep networks
- Enable training of models with hundreds of layers

### 5. Model Families

**GPT-Style (Decoder-Only)**
- Autoregressive generation with causal attention mask
- Pre-trained on next-token prediction
- Most popular architecture for generative tasks
- Examples: GPT-4, LLaMA, Mistral, Falcon

**LLaMA Architecture Specifics**
- RoPE positional encoding
- SwiGLU activation function in FFN
- RMSNorm instead of LayerNorm
- Pre-norm architecture
- Grouped-query attention (in LLaMA 2 70B+)
- Sizes: 7B, 13B, 34B, 70B

**Mixtral/MoE Architecture**
- Mixture of Experts with sparse activation
- Each token routed to top-k experts (typically k=2)
- 8 experts per MoE layer, 2 active per token
- Total parameters much larger than active parameters
- Requires expert parallelism for efficient training

**[📖 NeMo Supported Models](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - All model architectures supported by NeMo

### 6. Tokenization Strategies

**Byte Pair Encoding (BPE)**
- Iteratively merges most frequent byte/character pairs
- Creates subword vocabulary from training corpus
- Vocabulary size typically 32K-100K tokens
- Used by GPT models

**SentencePiece**
- Language-agnostic subword tokenizer
- Treats input as raw character stream (no pre-tokenization)
- Supports both BPE and unigram models
- Used by LLaMA, T5, and many multilingual models

**Vocabulary Size Tradeoffs**
- Larger vocabulary: Shorter sequences, more embedding parameters
- Smaller vocabulary: Longer sequences, fewer parameters
- Typical sizes: 32K (LLaMA), 50K (GPT-2), 100K+ (GPT-4)

**Special Tokens**
- BOS (beginning of sequence), EOS (end of sequence)
- PAD (padding for batching)
- System/user/assistant tokens for chat formatting
- Tool call tokens for function calling

### 7. Scaling Laws

**Chinchilla Scaling**
- Optimal training: tokens = 20x parameters
- 7B model should train on ~140B tokens
- 70B model should train on ~1.4T tokens
- Compute-optimal allocation between model and data

**Memory Estimation**
- FP32: 4 bytes per parameter (7B = 28GB)
- FP16/BF16: 2 bytes per parameter (7B = 14GB)
- INT8: 1 byte per parameter (7B = 7GB)
- INT4: 0.5 bytes per parameter (7B = 3.5GB)
- Training memory includes optimizer states, gradients, activations

**Training Compute**
- Approximate training FLOPS = 6 * parameters * tokens
- 7B model on 140B tokens ~ 5.9e21 FLOPS
- Estimate GPU hours from FLOPS and GPU throughput

### 8. Multi-Modal Architectures

**Vision-Language Models**
- Visual encoder (ViT) + language model + projection layer
- Image tokens projected into LLM embedding space
- Can process interleaved image-text inputs
- Examples: LLaVA, VILA, Kosmos

**Architecture Patterns**
- Cross-attention between visual and text representations
- Visual tokens as prefix to language model
- Adapter-based fusion of modalities

**[📖 NVIDIA Visual Language Models](https://docs.nvidia.com/nim/nvlm/latest/index.html)** - NVIDIA multi-modal model documentation

## Exam Focus Areas

### Critical Concepts
- Know the differences between MHA, MQA, and GQA
- Understand RoPE and why it enables context extension
- Know model sizes and their memory requirements at different precisions
- Understand MoE routing and sparse activation
- Be familiar with each model family's architectural choices

### Common Exam Questions
- "Which attention variant reduces KV cache size?" - GQA/MQA
- "What positional encoding supports context extension?" - RoPE
- "How much memory for a 70B model in FP16?" - ~140GB
- "What distinguishes LLaMA architecture?" - RoPE + SwiGLU + RMSNorm
- "How does MoE reduce compute?" - Only top-k experts active per token
