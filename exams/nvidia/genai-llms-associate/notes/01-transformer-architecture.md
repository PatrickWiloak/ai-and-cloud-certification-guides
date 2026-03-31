# Transformer Architecture, Attention, and Tokenization

**[📖 NeMo Framework Documentation](https://docs.nvidia.com/nemo-framework/user-guide/latest/index.html)** - NVIDIA's framework for building and training transformer models

## The Transformer Architecture

**[📖 Attention Is All You Need](https://arxiv.org/abs/1706.03762)** - Original transformer paper by Vaswani et al.

### Core Components

The transformer architecture consists of stacked layers, each containing two main sub-layers:

1. **Multi-Head Self-Attention** - allows the model to attend to different positions in the input
2. **Position-wise Feed-Forward Network (FFN)** - applies non-linear transformations

Each sub-layer has:
- **Residual connection** - input is added to sub-layer output (skip connections)
- **Layer normalization** - normalizes activations for training stability
- Pre-norm (modern) vs post-norm (original) placement affects training dynamics

### Architecture Variants

**Encoder-Only (BERT, RoBERTa):**
- Bidirectional attention - each token can attend to all other tokens
- Pre-training: Masked Language Modeling (MLM) - predict masked tokens
- Best for: text classification, named entity recognition, sentiment analysis, embeddings
- Cannot generate text autoregressively

**Decoder-Only (GPT, LLaMA, Mistral):**
- Causal (masked) attention - each token can only attend to previous tokens
- Pre-training: Causal Language Modeling (CLM) - predict next token
- Best for: text generation, chat, code generation, reasoning
- Most common architecture for modern LLMs

**Encoder-Decoder (T5, BART):**
- Encoder processes input with bidirectional attention
- Decoder generates output with causal attention + cross-attention to encoder
- Pre-training: Span corruption or denoising objectives
- Best for: translation, summarization, question answering

## Self-Attention Mechanism

**[📖 NVIDIA Megatron-LM](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotron/index.html)** - Large-scale transformer training

### How Self-Attention Works

1. **Input**: Sequence of token embeddings X (shape: sequence_length x d_model)
2. **Linear projections**: Create Query (Q), Key (K), Value (V) matrices
   - Q = X * W_Q
   - K = X * W_K
   - V = X * W_V
3. **Attention scores**: Compute compatibility between queries and keys
   - Score = Q * K^T / sqrt(d_k)
   - The sqrt(d_k) scaling prevents dot products from growing too large
4. **Softmax**: Normalize scores to get attention weights (sum to 1)
5. **Weighted sum**: Multiply attention weights by values
   - Output = softmax(Q * K^T / sqrt(d_k)) * V

### Multi-Head Attention

- Multiple attention heads run in parallel (typically 12-96 heads)
- Each head operates on a subset of the embedding dimensions
- d_head = d_model / num_heads (e.g., 768 / 12 = 64 dimensions per head)
- Different heads can learn different relationship types:
  - Syntactic relationships (subject-verb agreement)
  - Semantic relationships (topic relevance)
  - Positional patterns (nearby token relationships)
- Head outputs are concatenated and linearly projected

### Attention Variants

**Grouped-Query Attention (GQA):**
- Multiple query heads share a single key-value head
- Reduces KV-cache memory usage significantly
- Used by LLaMA 2 (70B), Mistral, and many modern models
- Groups typically: 4-8 query heads per KV head

**Multi-Query Attention (MQA):**
- All query heads share one key-value head
- Maximum KV-cache savings
- Can slightly reduce model quality
- Used by some efficiency-focused models

**Flash Attention:**
- IO-aware implementation that reduces memory reads/writes
- Computes exact attention (not an approximation)
- Significantly faster and more memory-efficient
- Tiling-based approach that works with GPU memory hierarchy
- Flash Attention 2 further improves parallelism

**[📖 Flash Attention Paper](https://arxiv.org/abs/2205.14135)** - Memory-efficient exact attention

## Positional Encoding

Transformers process all tokens in parallel, so they need explicit position information.

### Methods

**Absolute Positional Encoding (Original Transformer):**
- Sinusoidal functions of different frequencies
- Added to token embeddings at input layer
- Fixed maximum sequence length

**Learned Positional Embeddings:**
- Trainable position embedding vectors
- Used by BERT, GPT-2
- Limited to training sequence length

**Rotary Position Embedding (RoPE):**
- Encodes position through rotation of embedding vectors
- Naturally handles relative positions
- Good extrapolation to longer sequences
- Used by LLaMA, Mistral, and most modern models

**ALiBi (Attention with Linear Biases):**
- Adds linear bias to attention scores based on distance
- No additional parameters
- Strong length generalization

## Tokenization

**[📖 Hugging Face Tokenizers](https://huggingface.co/docs/tokenizers/index)** - Fast tokenizer library

### Byte-Pair Encoding (BPE)

**Algorithm:**
1. Start with character-level vocabulary
2. Count frequency of adjacent character pairs
3. Merge the most frequent pair into a new token
4. Repeat until desired vocabulary size is reached

**Properties:**
- Bottom-up approach - builds larger tokens from smaller ones
- Used by GPT-2, GPT-3, GPT-4
- Handles rare words through subword decomposition
- Vocabulary size typically 32,000-100,000 tokens

### WordPiece

**Algorithm:**
- Similar to BPE but merges based on likelihood improvement
- Uses "##" prefix for subword continuations
- Example: "playing" might tokenize as ["play", "##ing"]

**Properties:**
- Used by BERT and related models
- Optimizes for language model likelihood
- Typically 30,000 vocabulary tokens

### SentencePiece

**Properties:**
- Language-agnostic - works directly on raw text (no pre-tokenization)
- Can implement BPE or Unigram models
- Used by LLaMA, T5, and multilingual models
- Treats space as regular character (no language-specific rules)

**[📖 SentencePiece](https://github.com/google/sentencepiece)** - Language-agnostic tokenizer

### Tokenization Considerations

- **Vocabulary size trade-offs**: Larger vocab = more direct token mappings but larger embedding table
- **Token efficiency**: English text typically tokenizes at ~1.3 tokens per word
- **Multilingual**: Non-English languages often need more tokens per concept
- **Context window**: Token count determines effective input length
- **Special tokens**: BOS (beginning), EOS (end), PAD (padding), UNK (unknown)

## Pre-training Objectives

### Causal Language Modeling (CLM)
- Predict the next token given all previous tokens
- Used by GPT, LLaMA, Mistral
- Training data: large text corpora (books, web, code)
- Natural fit for text generation tasks

### Masked Language Modeling (MLM)
- Randomly mask 15% of tokens; predict the masked tokens
- Used by BERT, RoBERTa
- Bidirectional context for predictions
- Better for understanding tasks than generation

### Span Corruption
- Replace random spans with sentinel tokens; generate the missing spans
- Used by T5
- Spans of variable length (typically averaging 3 tokens)
- More efficient than single-token masking

## Scaling Laws and Model Sizes

**[📖 Scaling Laws Paper](https://arxiv.org/abs/2001.08361)** - Neural language model scaling laws

### Key Insights

- Model performance scales as a power law with compute, data, and parameters
- **Chinchilla scaling**: Optimal training uses ~20 tokens per parameter
  - 7B model should train on ~140B tokens
  - 70B model should train on ~1.4T tokens
- Emergent abilities appear at certain scale thresholds
  - Chain-of-thought reasoning
  - In-context learning
  - Code generation
  - Mathematical reasoning

### Common Model Sizes

| Model | Parameters | Layers | Hidden Size | Heads |
|---|---|---|---|---|
| GPT-2 | 1.5B | 48 | 1600 | 25 |
| LLaMA 7B | 7B | 32 | 4096 | 32 |
| LLaMA 13B | 13B | 40 | 5120 | 40 |
| LLaMA 70B | 70B | 80 | 8192 | 64 |
| Mistral 7B | 7B | 32 | 4096 | 32 |

### NVIDIA Model Family

**[📖 NVIDIA Nemotron](https://developer.nvidia.com/nemotron)** - NVIDIA's model family

- **Nemotron** - NVIDIA's family of LLMs
- Trained using NeMo Framework and NVIDIA DGX infrastructure
- Available through NVIDIA NIM for optimized deployment
- Designed for enterprise use cases

## Key Concepts for the Exam

### Architecture Selection
- **Text generation/chat**: Decoder-only (GPT, LLaMA)
- **Classification/understanding**: Encoder-only (BERT) or decoder-only with fine-tuning
- **Translation/summarization**: Encoder-decoder (T5) or decoder-only
- **Embeddings**: Encoder-only or specialized embedding models

### Memory and Compute
- Model size in memory (FP16) is roughly 2 bytes per parameter
  - 7B model = ~14GB in FP16
  - 70B model = ~140GB in FP16
- Training requires 4-6x model size (optimizer states, gradients)
- Inference primarily limited by KV-cache and model size
- Flash Attention reduces memory overhead during training and inference

### Common Exam Questions
- What is the role of the softmax in attention? (normalize scores to probability distribution)
- Why scale by sqrt(d_k)? (prevent large dot products that push softmax into saturated regions)
- Difference between self-attention and cross-attention? (self = within one sequence, cross = between encoder and decoder)
- Why use multi-head attention? (learn diverse relationship patterns in parallel)
- BPE vs WordPiece? (BPE merges by frequency, WordPiece by likelihood)
