# Fine-Tuning and Model Customization

**[📖 NVIDIA NeMo Framework - LLM Training](https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/index.html)** - Training LLMs with NeMo
**[📖 NVIDIA NeMo PEFT Guide](https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/nemo_framework_peft/index.html)** - Parameter-efficient fine-tuning

## Full Fine-Tuning

### Process Overview

1. Load pre-trained model with all weights
2. Prepare task-specific labeled training data
3. Update all model parameters on the training data
4. Evaluate on validation set to monitor overfitting
5. Select best checkpoint based on validation metrics

### GPU Memory Requirements

Full fine-tuning requires storing:
- **Model weights** - 2 bytes per parameter (FP16)
- **Gradients** - 2 bytes per parameter
- **Optimizer states** - 8 bytes per parameter (Adam: momentum + variance, FP32)
- **Activations** - varies with batch size and sequence length

**Approximate total**: 12-16 bytes per parameter (with FP16 mixed precision)
- 7B model: ~84-112 GB (needs multiple GPUs or A100 80GB)
- 13B model: ~156-208 GB (needs multi-GPU)
- 70B model: ~840-1120 GB (needs GPU cluster)

### When to Use Full Fine-Tuning
- Large, high-quality training dataset (10K+ examples)
- Significant domain shift from pre-training data
- Compute resources are available
- Maximum performance is required
- Plan to deploy a single specialized model

### Risks
- **Catastrophic forgetting** - model loses pre-trained knowledge
- **Overfitting** - too few examples relative to parameters
- **Expensive** - requires significant GPU compute
- **Not composable** - cannot easily switch between tasks

## Parameter-Efficient Fine-Tuning (PEFT)

### LoRA (Low-Rank Adaptation)

**[📖 LoRA Paper](https://arxiv.org/abs/2106.09685)** - Original LoRA research

**Core Idea:**
- Freeze all original model weights
- Add small trainable low-rank matrices to specific layers
- Original weight W remains frozen; learn decomposition: delta_W = A * B
- A has shape (d x r), B has shape (r x d), where r << d
- Only A and B matrices are trainable

**Key Parameters:**
- **Rank (r)**: Dimensionality of low-rank matrices
  - r=8: Very efficient, good for simple tasks
  - r=16-32: Good balance for most use cases
  - r=64+: Near full fine-tuning quality, more parameters
- **Alpha**: Scaling factor (typically alpha = 2 * rank)
- **Target modules**: Which layers to apply LoRA to
  - Common: Q, K, V projection layers in attention
  - Extended: also FFN layers for more capacity
- **Dropout**: Regularization for LoRA layers (0.05-0.1 typical)

**Advantages:**
- Reduces trainable parameters by 90-99%
- Fits on much smaller GPUs than full fine-tuning
- Multiple LoRA adapters can be trained and swapped
- Can be merged into base model for zero-overhead inference
- Quick training (minutes to hours vs hours to days)

**Adapter Merging:**
- LoRA weights can be merged: W_new = W_original + A * B
- Merged model has no additional inference overhead
- Multiple task-specific adapters can be served via adapter switching

### QLoRA (Quantized LoRA)

**[📖 QLoRA Paper](https://arxiv.org/abs/2305.14314)** - Quantized fine-tuning

**Core Idea:**
- Quantize base model to 4-bit precision (NF4 format)
- Apply LoRA on top of the quantized model
- LoRA weights remain in higher precision (FP16/BF16)
- Backpropagate through the quantized weights

**Key Features:**
- **NF4 (Normal Float 4-bit)**: Information-theoretically optimal 4-bit data type
- **Double quantization**: Quantize the quantization constants for additional savings
- **Paged optimizers**: Use CPU memory for optimizer state overflow

**Memory Savings:**
- 7B model full fine-tuning: ~84 GB
- 7B model LoRA: ~14-20 GB
- 7B model QLoRA: ~6-10 GB (fits on consumer GPU)
- Enables fine-tuning 70B models on single A100 80GB

**Trade-offs:**
- Slightly lower quality than full-precision LoRA
- Slower training due to quantization/dequantization overhead
- Cannot merge adapters as cleanly (base model is quantized)

### Other PEFT Methods

**Prefix Tuning:**
- Prepends trainable continuous vectors to each transformer layer
- Does not modify attention weights
- Very few trainable parameters (<0.1%)
- Can underperform LoRA on complex tasks

**P-Tuning v2:**
- Learnable prompt embeddings at every layer (not just input)
- More expressive than basic prompt tuning
- Works well for classification and extraction tasks

**Adapter Layers:**
- Inserts small bottleneck neural networks between transformer layers
- Typically adds 1-5% additional parameters
- Original PEFT method before LoRA
- Less popular now due to LoRA's simplicity

**IA3 (Infused Adapter by Inhibiting and Amplifying Inner Activations):**
- Scales activations with learned vectors
- Extremely few trainable parameters
- Fast training but can be less expressive
- Good for very resource-constrained scenarios

### PEFT Method Comparison

| Method | Params Added | Memory Savings | Quality | Complexity |
|---|---|---|---|---|
| LoRA | 0.1-1% | 60-90% | High | Low |
| QLoRA | 0.1-1% | 80-95% | Good-High | Medium |
| Prefix Tuning | <0.1% | 90-99% | Medium | Medium |
| Adapter Layers | 1-5% | 50-80% | High | Medium |
| IA3 | <0.01% | 95%+ | Medium | Low |

## Alignment Methods

### Supervised Fine-Tuning (SFT)

**[📖 NVIDIA NeMo Customization](https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/nemo_framework_custom/index.html)** - Model customization workflows

- First step in most alignment pipelines
- Train on high-quality instruction-response pairs
- Data format: (system prompt, user instruction, assistant response)
- Focus on data quality over quantity
- Teaches the model desired response format and style

### RLHF (Reinforcement Learning from Human Feedback)

**[📖 NVIDIA NeMo RLHF](https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/nemo_framework_rlhf/index.html)** - RLHF with NeMo
**[📖 InstructGPT Paper](https://arxiv.org/abs/2203.02155)** - RLHF methodology

**Pipeline:**
1. **SFT Model** - fine-tune base model on instruction data
2. **Reward Model Training**:
   - Collect human preferences (compare two responses, choose better one)
   - Train reward model to predict human preferences
3. **PPO Optimization**:
   - Generate responses from SFT model
   - Score with reward model
   - Update policy using PPO algorithm
   - KL divergence penalty prevents model from diverging too far from SFT model

**Challenges:**
- Expensive (requires human annotators for preference data)
- Complex training pipeline (multiple models, RL optimization)
- Reward hacking (model exploits reward model weaknesses)
- Training instability (RL can be unstable)

### DPO (Direct Preference Optimization)

**Core Idea:**
- Eliminates the need for a separate reward model
- Directly optimizes on preference pairs (chosen vs rejected responses)
- Reformulates RLHF objective into a classification loss
- Simpler, more stable training than PPO

**Data Format:**
```
{
  "prompt": "Explain quantum computing",
  "chosen": "Quantum computing uses quantum bits (qubits)...",
  "rejected": "Quantum computing is magic..."
}
```

**Advantages over RLHF:**
- No reward model to train
- No RL optimization (just supervised learning)
- More stable training
- Simpler implementation
- Comparable or better results

## Training Data Preparation

### Data Quality Principles

- **Diversity** - cover the range of expected use cases
- **Accuracy** - ensure labels and responses are correct
- **Consistency** - maintain uniform formatting and style
- **Balance** - represent all categories/tasks proportionally
- **Relevance** - match the target deployment scenario

### Data Formats

**Instruction Format (for SFT):**
```json
{
  "system": "You are a helpful assistant.",
  "instruction": "What is machine learning?",
  "response": "Machine learning is a subset of AI..."
}
```

**Chat Format (for multi-turn):**
```json
{
  "messages": [
    {"role": "system", "content": "You are a coding assistant."},
    {"role": "user", "content": "Write a Python function to sort a list."},
    {"role": "assistant", "content": "def sort_list(lst): ..."}
  ]
}
```

**Preference Format (for DPO):**
```json
{
  "prompt": "Explain gravity.",
  "chosen": "Gravity is a fundamental force...",
  "rejected": "Gravity makes things fall down."
}
```

### Data Size Guidelines

- **LoRA fine-tuning**: 1,000-10,000 examples (quality over quantity)
- **Full fine-tuning**: 10,000-100,000+ examples
- **RLHF/DPO**: 5,000-50,000 preference pairs
- **SFT alignment**: 10,000-50,000 instruction-response pairs

**[📖 NVIDIA NeMo Data Curator](https://docs.nvidia.com/nemo-framework/user-guide/latest/datacuration/index.html)** - Data preparation tools

## Evaluation Metrics

### Automated Metrics

- **Perplexity** - how well the model predicts held-out text (lower is better)
- **BLEU** - n-gram overlap with reference (translation, summarization)
- **ROUGE** - recall-based overlap with reference (summarization)
- **F1 Score** - balanced precision/recall for classification tasks
- **Exact Match** - percentage of exactly correct answers

### Human Evaluation

- **Helpfulness** - does the response address the question?
- **Accuracy** - is the information correct?
- **Harmlessness** - is the response safe and appropriate?
- **Coherence** - is the response well-organized and clear?
- **Preference ranking** - side-by-side comparison of model outputs

### Evaluation Best Practices

- Always evaluate on a held-out test set
- Use multiple metrics appropriate for the task
- Include human evaluation for subjective tasks
- Compare against baseline (pre-fine-tuning performance)
- Monitor for catastrophic forgetting on general tasks

## Key Concepts for the Exam

### Fine-Tuning Decision Tree
1. **Need to update factual knowledge?** - Use RAG instead
2. **Large dataset + ample compute?** - Consider full fine-tuning
3. **Limited compute or data?** - Use LoRA
4. **Very limited compute (consumer GPU)?** - Use QLoRA
5. **Need to align behavior?** - SFT then DPO (or RLHF)
6. **Multiple tasks from one base model?** - LoRA with adapter switching

### Common Exam Questions
- LoRA vs full fine-tuning? (LoRA: fewer params, less compute, composable)
- QLoRA benefit? (enables fine-tuning large models on small GPUs)
- LoRA rank selection? (higher rank = more capacity but more parameters)
- RLHF vs DPO? (DPO is simpler, no reward model needed)
- What is catastrophic forgetting? (model loses pre-trained knowledge during fine-tuning)
- SFT purpose? (teaches model desired response format and style)
