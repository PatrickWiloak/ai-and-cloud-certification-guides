# NCA-GENL Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: LLM Fundamentals - Architecture and Theory

#### Day 1-2: Transformer Architecture
- [ ] Study the original transformer architecture (encoder, decoder, encoder-decoder)
- [ ] Understand self-attention mechanism (Q, K, V matrices)
- [ ] Learn multi-head attention and why it matters
- [ ] Study positional encoding methods (absolute, relative, rotary - RoPE)
- [ ] Understand layer normalization and residual connections
- [ ] Review feed-forward network role in transformer blocks
- [ ] Hands-on: Explore transformer visualization tools
- [ ] Review Notes: `notes/01-transformer-architecture.md`

#### Day 3-4: Tokenization and Embeddings
- [ ] Study Byte-Pair Encoding (BPE) algorithm
- [ ] Learn WordPiece tokenization (used by BERT)
- [ ] Understand SentencePiece (used by LLaMA, T5)
- [ ] Learn how vocabulary size affects model performance
- [ ] Study embedding layers and how tokens become vectors
- [ ] Understand special tokens (CLS, SEP, BOS, EOS, PAD)
- [ ] Hands-on: Experiment with different tokenizers on Hugging Face
- [ ] Review Notes: `notes/01-transformer-architecture.md`

#### Day 5-6: Model Families and Pre-training
- [ ] Study GPT family (decoder-only, autoregressive generation)
- [ ] Learn BERT family (encoder-only, bidirectional understanding)
- [ ] Understand T5 family (encoder-decoder, text-to-text)
- [ ] Study LLaMA, Mistral, and Mixtral architectures
- [ ] Learn NVIDIA Nemotron model family
- [ ] Understand pre-training objectives (CLM, MLM, span corruption)
- [ ] Study scaling laws and emergent abilities
- [ ] Hands-on: Load and compare different model architectures on Hugging Face
- [ ] Review Notes: `notes/01-transformer-architecture.md`

#### Day 7: Week 1 Review
- [ ] Create summary of key architecture concepts
- [ ] Quiz yourself on attention mechanism details
- [ ] Verify understanding of model type differences (encoder vs decoder)
- [ ] Review any weak areas identified during the week

### Week 2: Prompt Engineering

#### Day 8-9: Core Prompting Techniques
- [ ] Study zero-shot prompting and when it works best
- [ ] Learn one-shot and few-shot prompting strategies
- [ ] Understand in-context learning capabilities and limitations
- [ ] Practice writing effective task instructions
- [ ] Study prompt template design patterns
- [ ] Hands-on: Test zero-shot vs few-shot on NVIDIA AI Playground
- [ ] Review Notes: `notes/02-prompt-engineering.md`

#### Day 10-11: Advanced Prompting and Output Control
- [ ] Study chain-of-thought (CoT) prompting technique
- [ ] Learn self-consistency (multiple CoT paths)
- [ ] Understand system prompts and role-based instructions
- [ ] Study temperature, top-k, and top-p sampling parameters
- [ ] Learn output formatting (JSON, structured responses)
- [ ] Practice designing prompts for different task types
- [ ] Hands-on: Experiment with sampling parameters using NIM APIs
- [ ] Review Notes: `notes/02-prompt-engineering.md`

#### Day 12-13: Prompt Security and Best Practices
- [ ] Study prompt injection attacks (direct and indirect)
- [ ] Learn prompt injection mitigation strategies
- [ ] Understand prompt-response evaluation methods
- [ ] Study task decomposition for complex problems
- [ ] Learn about stop sequences and response truncation
- [ ] Hands-on: Test prompt injection scenarios and defenses
- [ ] Review Notes: `notes/02-prompt-engineering.md`

#### Day 14: Week 2 Review
- [ ] Practice writing prompts for 5 different task types
- [ ] Test understanding of sampling parameter effects
- [ ] Review prompt security concepts
- [ ] Identify knowledge gaps for further study

### Week 3: RAG and Vector Databases

#### Day 15-16: RAG Architecture Fundamentals
- [ ] Study the complete RAG pipeline (ingest, embed, index, retrieve, generate)
- [ ] Understand why RAG reduces hallucination
- [ ] Learn embedding models and how they create vector representations
- [ ] Study similarity metrics (cosine similarity, dot product, Euclidean)
- [ ] Understand bi-encoder vs cross-encoder models
- [ ] Learn about NVIDIA NeMo Retriever components
- [ ] Hands-on: Build a simple RAG pipeline with LangChain
- [ ] Review Notes: `notes/03-rag-vector-databases.md`

#### Day 17-18: Vector Databases Deep Dive
- [ ] Study FAISS - index types (Flat, IVF, HNSW), GPU acceleration
- [ ] Learn Milvus - features, scaling, production deployment
- [ ] Understand other options (Pinecone, Weaviate, Chroma, Qdrant)
- [ ] Study indexing methods (HNSW, IVF, PQ) and their trade-offs
- [ ] Learn about metadata filtering in vector search
- [ ] Understand approximate nearest neighbor (ANN) search
- [ ] Hands-on: Set up FAISS and Milvus, compare search performance
- [ ] Review Notes: `notes/03-rag-vector-databases.md`

#### Day 19-20: Chunking, Indexing, and Retrieval Quality
- [ ] Study chunking methods (fixed-size, recursive, semantic, document-aware)
- [ ] Understand chunk size trade-offs (precision vs context)
- [ ] Learn about chunk overlap and why it matters
- [ ] Study hybrid search (dense + sparse retrieval)
- [ ] Understand re-ranking and its impact on result quality
- [ ] Learn context window management strategies
- [ ] Hands-on: Experiment with different chunking strategies
- [ ] Review Notes: `notes/03-rag-vector-databases.md`

#### Day 21: Week 3 Review
- [ ] Design a complete RAG pipeline for a given use case
- [ ] Compare vector database options for different scenarios
- [ ] Practice chunking strategy selection
- [ ] Review retrieval quality evaluation methods

### Week 4: Fine-Tuning and Customization

#### Day 22-23: Fine-Tuning Fundamentals
- [ ] Study full fine-tuning process and requirements
- [ ] Understand GPU memory requirements for fine-tuning
- [ ] Learn about catastrophic forgetting and how to prevent it
- [ ] Study training data preparation and quality requirements
- [ ] Understand evaluation metrics (perplexity, BLEU, ROUGE)
- [ ] Learn about NVIDIA NeMo Framework for training
- [ ] Hands-on: Review NeMo Framework documentation and tutorials
- [ ] Review Notes: `notes/04-fine-tuning-customization.md`

#### Day 24-25: PEFT Methods (LoRA, QLoRA, Adapters)
- [ ] Study LoRA - low-rank matrices, rank selection, target modules
- [ ] Learn QLoRA - 4-bit quantization + LoRA, NF4 format
- [ ] Understand other PEFT methods (prefix tuning, adapters, IA3)
- [ ] Compare PEFT methods by memory efficiency, quality, and complexity
- [ ] Study when to choose each PEFT method
- [ ] Learn about adapter merging and multi-adapter serving
- [ ] Hands-on: Fine-tune a small model with LoRA using NeMo or Hugging Face
- [ ] Review Notes: `notes/04-fine-tuning-customization.md`

#### Day 26-27: Alignment Methods (RLHF, DPO)
- [ ] Study supervised fine-tuning (SFT) as alignment baseline
- [ ] Learn RLHF pipeline (reward model, PPO optimization)
- [ ] Understand DPO as simplified alternative to RLHF
- [ ] Study preference data collection and formatting
- [ ] Learn about KL divergence penalty in alignment
- [ ] Understand when to use SFT vs RLHF vs DPO
- [ ] Hands-on: Review NeMo alignment documentation
- [ ] Review Notes: `notes/04-fine-tuning-customization.md`

#### Day 28: Week 4 Review
- [ ] Compare all fine-tuning approaches (full, LoRA, QLoRA, RLHF, DPO)
- [ ] Practice selecting fine-tuning methods for different scenarios
- [ ] Create decision tree for fine-tuning method selection
- [ ] Review GPU memory requirements for different approaches

### Week 5: Deployment, Inference, and Ethics

#### Day 29-30: NVIDIA Deployment Stack
- [ ] Study NVIDIA NIM - architecture, deployment, API
- [ ] Learn TensorRT-LLM - optimization techniques, quantization
- [ ] Understand Triton Inference Server - multi-framework serving
- [ ] Study the relationship between NIM, TensorRT-LLM, and Triton
- [ ] Learn about containerized model deployment
- [ ] Hands-on: Deploy a model using NVIDIA NIM
- [ ] Review Notes: `notes/05-deployment-inference.md`

#### Day 31-32: Inference Optimization
- [ ] Study quantization methods (FP8, INT8, INT4, AWQ, GPTQ)
- [ ] Learn KV-cache and paged attention concepts
- [ ] Understand batching strategies (static, dynamic, continuous)
- [ ] Study model parallelism (tensor, pipeline)
- [ ] Learn speculative decoding for faster generation
- [ ] Understand throughput vs latency trade-offs
- [ ] Hands-on: Compare inference performance with different quantization
- [ ] Review Notes: `notes/05-deployment-inference.md`

#### Day 33-34: Ethics and Responsible AI
- [ ] Study bias sources in LLMs (data, training, output)
- [ ] Learn NVIDIA NeMo Guardrails (topical, safety, fact-checking rails)
- [ ] Understand hallucination types and mitigation strategies
- [ ] Study privacy considerations (PII handling, data governance)
- [ ] Learn about red-teaming and adversarial testing
- [ ] Understand regulatory frameworks (EU AI Act awareness)
- [ ] Hands-on: Configure NeMo Guardrails for a chatbot
- [ ] Review Notes: `notes/06-ethics-responsible-ai.md`

#### Day 35: Week 5 Review
- [ ] Create comparison chart of NVIDIA deployment tools
- [ ] Review quantization methods and trade-offs
- [ ] Summarize responsible AI practices
- [ ] Identify remaining knowledge gaps

### Week 6: Review, Practice, and Exam Preparation

#### Day 36-37: Comprehensive Review
- [ ] Review all notes files and fact sheet
- [ ] Create flashcards for key concepts and NVIDIA tools
- [ ] Review quick reference tables (architecture, PEFT, quantization)
- [ ] Study NVIDIA tool selection guide
- [ ] Revisit any topics with low confidence

#### Day 38-39: Scenario Practice
- [ ] Work through all scenarios in `scenarios.md`
- [ ] Practice reasoning through trade-off questions
- [ ] Design RAG pipelines for different use cases
- [ ] Select fine-tuning methods for various requirements
- [ ] Practice NVIDIA tool selection for deployment scenarios

#### Day 40-41: Mock Assessment and Gap Analysis
- [ ] Take any available practice assessments
- [ ] Time yourself (60 minutes for 50-60 questions)
- [ ] Review all incorrect answers thoroughly
- [ ] Focus additional study on weak areas
- [ ] Re-read NVIDIA documentation for missed topics

#### Day 42: Final Preparation
- [ ] Quick review of fact sheet and key tables
- [ ] Review common exam pitfalls from strategy guide
- [ ] Verify understanding of NVIDIA ecosystem tools
- [ ] Light review only - avoid cramming new material
- [ ] Prepare exam environment (online proctoring setup)
- [ ] Get a good night's rest before exam day

## Supplementary Study Activities

### Weekly Labs (Pick at Least One Per Week)
- [ ] Lab 1: Explore model architectures on Hugging Face Model Hub
- [ ] Lab 2: Build a chatbot with system prompts and sampling controls
- [ ] Lab 3: Create a RAG pipeline with FAISS and LangChain
- [ ] Lab 4: Fine-tune a model with LoRA on a custom dataset
- [ ] Lab 5: Deploy a model with NVIDIA NIM
- [ ] Lab 6: Implement NeMo Guardrails for safety

### Ongoing Activities
- [ ] Read NVIDIA developer blog posts weekly
- [ ] Follow GTC presentations on generative AI topics
- [ ] Practice explaining concepts to solidify understanding
- [ ] Join NVIDIA developer forums for community support
