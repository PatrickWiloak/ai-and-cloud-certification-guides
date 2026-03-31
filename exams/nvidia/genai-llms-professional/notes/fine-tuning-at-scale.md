# Fine-Tuning at Scale - NCP-GENL

## Overview

This document covers the methods, strategies, and best practices for fine-tuning large language models using NVIDIA tools. Topics include Parameter-Efficient Fine-Tuning (PEFT) methods, supervised fine-tuning, RLHF, data preparation, and distributed training configurations for fine-tuning workflows.

**[📖 NeMo PEFT Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/peft/landing_page.html)** - PEFT methods in NeMo Framework
**[📖 NeMo Aligner](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Alignment training documentation

## Key Topics

### 1. Fine-Tuning Methods Overview

**Full Fine-Tuning**
- Update all model parameters on new data
- Highest quality but most expensive in compute and memory
- Requires storing full optimizer states (2x model size for AdamW)
- Risk of catastrophic forgetting without careful learning rate
- Total memory: ~16x model parameters in FP32 (model + optimizer + gradients + activations)

**Parameter-Efficient Fine-Tuning (PEFT)**
- Update only a small fraction of parameters
- Much lower memory and compute requirements
- Preserves base model knowledge (reduced catastrophic forgetting)
- Adapter weights can be swapped without reloading base model
- Multiple PEFT adapters can share one base model

**When to Use Each**
- Full fine-tuning: Maximum quality, significant domain shift, sufficient resources
- PEFT: Limited resources, domain adaptation, multiple use cases from one base
- Prompt tuning: Very limited compute, simple task adaptation

### 2. LoRA (Low-Rank Adaptation)

**How LoRA Works**
- Injects trainable low-rank matrices alongside frozen pre-trained weights
- For weight matrix W, adds delta: W + BA where B is (d x r) and A is (r x d)
- Rank r is much smaller than d (typically 8-64 vs 4096-8192)
- Only trains B and A matrices, W stays frozen
- At inference, merge BA into W for zero overhead

**Key Hyperparameters**
- **Rank (r):** 8-64 typical. Higher rank = more capacity, more parameters
- **Alpha:** Scaling factor, usually alpha = 2 * rank
- **Target Modules:** Which layers to apply LoRA (q_proj, k_proj, v_proj, o_proj, mlp)
- **Dropout:** 0.05-0.1 for regularization

**LoRA Best Practices**
- Apply to attention projections (q, k, v, output) for best results
- Adding LoRA to MLP layers can help for larger domain shifts
- Start with rank 16, increase if quality is insufficient
- Use alpha = 2 * rank as starting point
- Monitor validation loss to detect overfitting

**Parameter Counts**
- 7B model with LoRA rank 16 on attention: ~4M trainable parameters (~0.06%)
- 70B model with LoRA rank 32 on attention: ~25M trainable parameters (~0.04%)
- Dramatically less than full fine-tuning

### 3. QLoRA (Quantized LoRA)

**How QLoRA Works**
- Quantize base model to 4-bit (NF4 quantization)
- Apply LoRA adapters in FP16/BF16
- Backpropagation through quantized weights using double quantization
- Paged optimizers to handle memory spikes

**Memory Benefits**
- 70B model: ~140GB in FP16, ~35GB in 4-bit
- LoRA adapters add minimal overhead (~100MB-1GB)
- Enables fine-tuning 70B models on 4x A100 80GB
- Quality very close to full FP16 LoRA

**When to Use QLoRA**
- Limited GPU memory
- Need to fine-tune models larger than available VRAM
- Acceptable to trade small quality loss for memory savings
- Single-node fine-tuning of very large models

### 4. P-Tuning and Prompt Tuning

**P-Tuning v2**
- Trainable continuous prompt tokens prepended to input
- Prompt encoder (small neural network) generates prompt embeddings
- Applied at every transformer layer (not just input)
- More capacity than simple prompt tuning

**Soft Prompt Tuning**
- Trainable vectors prepended to input embeddings only
- Simplest PEFT method, fewest parameters
- Works well for classification and simple tasks
- Limited capacity for complex domain adaptation

**Comparison with LoRA**
- P-tuning: Changes what the model sees (input modification)
- LoRA: Changes how the model processes (weight modification)
- LoRA generally outperforms P-tuning for most tasks
- P-tuning uses fewer parameters but has lower ceiling

**[📖 NeMo P-Tuning](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/peft/landing_page.html)** - P-tuning documentation in NeMo

### 5. Supervised Fine-Tuning (SFT)

**Data Format**
- Instruction-response pairs for instruction tuning
- Chat format with system/user/assistant turns
- JSONL format with structured fields
- Quality of data matters more than quantity

**Data Quality Principles**
- Diverse, high-quality instruction-response pairs
- Consistent formatting and style
- Balanced task distribution
- Remove duplicates and low-quality examples
- Typical: 10K-100K high-quality examples sufficient

**Training Configuration**
- Lower learning rate than pre-training (1e-5 to 5e-5)
- Fewer epochs (1-3 typically, more risks overfitting)
- Gradient accumulation for effective batch size of 32-128
- Cosine or linear learning rate decay
- Pack multiple short examples into single sequences

**NeMo SFT Workflow**
- Prepare data in NeMo-compatible format
- Configure training YAML with model path and data
- Launch training with NeMo trainer
- Evaluate on held-out validation set
- Export fine-tuned model for inference

### 6. RLHF and Alignment

**RLHF Pipeline**
1. **SFT:** Fine-tune base model on demonstration data
2. **Reward Model:** Train a model to predict human preferences
3. **RL Training:** Optimize SFT model using PPO against reward model

**Reward Model Training**
- Trained on comparison pairs (preferred vs rejected responses)
- Predicts scalar reward for each response
- Bradley-Terry model for pairwise preference learning
- Important: Reward model quality directly impacts RLHF quality

**Proximal Policy Optimization (PPO)**
- Reinforcement learning algorithm for language model alignment
- Optimizes expected reward while staying close to SFT policy
- KL penalty prevents reward hacking (degenerate high-reward outputs)
- Requires reward model, reference policy, and actor policy

**Direct Preference Optimization (DPO)**
- Alternative to PPO that doesn't require separate reward model
- Directly optimizes policy from preference data
- Simpler implementation, no reward model needed
- Loss function: log probability ratio of preferred vs rejected
- Generally more stable training than PPO

**SteerLM**
- NVIDIA's attribute-conditioned generation approach
- Label responses with multiple attributes (quality, helpfulness, toxicity)
- Train model to generate responses conditioned on attribute values
- More controllable than standard RLHF

**[📖 NeMo Alignment](https://docs.nvidia.com/nemo-framework/user-guide/latest/nemotoolkit/nlp/nemo_megatron/intro.html)** - Alignment training in NeMo

### 7. Data Preparation for Fine-Tuning

**Data Collection**
- Curate domain-specific instruction-response pairs
- Use existing datasets (Open Assistant, Dolly, ShareGPT)
- Generate synthetic data with strong teacher models
- Expert annotation for specialized domains

**Data Processing**
- Deduplication to remove redundant examples
- Length filtering (remove very short/long examples)
- Quality scoring with automated classifiers
- Format validation and consistency checks
- Toxicity and safety filtering

**Data Formatting**
- Standardize to chat template format
- Ensure correct special token usage
- Validate tokenization doesn't exceed context length
- Split into train/validation sets (90/10 typical)

**NeMo Data Curator for Fine-Tuning**
- Automated quality filtering pipelines
- PII detection and removal
- Deduplication at scale
- Integration with NeMo training format

### 8. Distributed Fine-Tuning

**Parallelism for Fine-Tuning**
- LoRA fine-tuning: Usually data parallelism sufficient
- Full fine-tuning large models: May need TP + DP
- QLoRA: Typically single-node, data parallelism across GPUs

**Memory Optimization**
- Gradient checkpointing: Recompute activations instead of storing
- Activation offloading: Move activations to CPU during backward pass
- Flash Attention: Reduce attention memory from O(n^2) to O(n)
- Mixed precision: BF16/FP16 for compute, FP32 for loss

**Multi-Node Fine-Tuning with NeMo**
- NeMo Launcher for cluster orchestration
- NCCL for GPU-to-GPU communication
- Checkpoint saving across distributed GPUs
- Resume training from distributed checkpoints

## Exam Focus Areas

### Critical Concepts
- Understand LoRA mechanics and hyperparameter selection
- Know when to use QLoRA vs LoRA vs full fine-tuning
- Understand the RLHF pipeline (SFT, reward model, PPO)
- Know DPO as an alternative to PPO
- Be familiar with data preparation best practices

### Common Exam Questions
- "Which method for 70B fine-tuning on 4 GPUs?" - QLoRA
- "What does LoRA rank control?" - Capacity of the adaptation
- "How does DPO differ from PPO?" - No separate reward model needed
- "Most important factor for SFT quality?" - Training data quality
- "How to prevent catastrophic forgetting?" - Low learning rate + PEFT methods
