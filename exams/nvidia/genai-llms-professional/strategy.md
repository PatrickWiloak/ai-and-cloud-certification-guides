# NCP-GENL Study Strategy

## Study Approach

### Phase 1: Foundation (2-3 weeks)
1. **LLM Architecture Fundamentals**
   - Complete NVIDIA Deep Learning Institute generative AI courses
   - Study transformer architecture components in depth
   - Understand model families (GPT, LLaMA, Mixtral) and design choices
   - Review scaling laws and their practical implications

2. **NVIDIA Stack Overview**
   - Install and explore NeMo Framework using NGC containers
   - Set up TensorRT-LLM development environment
   - Familiarize with NVIDIA NIM deployment
   - Browse NVIDIA NGC catalog for pre-trained models

### Phase 2: Hands-On Practice (3-4 weeks)
1. **Training and Fine-Tuning**
   - Fine-tune a model using NeMo Framework with LoRA
   - Compare PEFT methods (LoRA, QLoRA, P-tuning) on a task
   - Run distributed training across multiple GPUs
   - Practice data preparation with NeMo Data Curator

2. **Inference Optimization**
   - Compile a model with TensorRT-LLM
   - Apply different quantization levels and measure impact
   - Set up continuous batching and measure throughput
   - Deploy a model with NVIDIA NIM

3. **RAG Pipeline Development**
   - Build an end-to-end RAG pipeline with NVIDIA tools
   - Experiment with chunking strategies and embedding models
   - Implement hybrid search with re-ranking
   - Evaluate RAG quality with standard metrics

### Phase 3: Exam Preparation (1-2 weeks)
1. **Practice Exams**
   - Work through scenario-based questions
   - Review incorrect answers and identify knowledge gaps
   - Focus on questions that combine multiple domains

2. **Final Review**
   - Review fact sheet and key reference numbers
   - Practice explaining concepts without notes
   - Final walkthrough of all NVIDIA tool configurations

## Study Resources

### Official NVIDIA Resources
- **[NVIDIA Deep Learning Institute](https://www.nvidia.com/en-us/training/)** - Official certification training courses
- **[NVIDIA NeMo Framework Docs](https://docs.nvidia.com/nemo-framework/user-guide/latest/overview.html)** - Comprehensive framework documentation
- **[TensorRT-LLM Documentation](https://nvidia.github.io/TensorRT-LLM/)** - Inference optimization reference
- **[NVIDIA NIM Documentation](https://docs.nvidia.com/nim/index.html)** - Model deployment microservices
- **[NVIDIA NGC Catalog](https://catalog.ngc.nvidia.com/)** - Pre-trained models and containers
- **[NVIDIA AI Enterprise Docs](https://docs.nvidia.com/ai-enterprise/latest/index.html)** - Enterprise AI platform

### GitHub Repositories
- **[NeMo Framework](https://github.com/NVIDIA/NeMo)** - Training and fine-tuning framework
- **[TensorRT-LLM](https://github.com/NVIDIA/TensorRT-LLM)** - High-performance inference
- **[NeMo Guardrails](https://github.com/NVIDIA/NeMo-Guardrails)** - LLM safety framework
- **[GenerativeAIExamples](https://github.com/NVIDIA/GenerativeAIExamples)** - End-to-end RAG examples

### NVIDIA Developer Blog
- **[NVIDIA Technical Blog](https://developer.nvidia.com/blog/)** - Deep technical articles on AI topics
- **[GTC Conference Sessions](https://www.nvidia.com/en-us/on-demand/)** - Recorded conference presentations

### Supplementary Resources
- Attention Is All You Need paper (original transformer)
- LoRA paper (Low-Rank Adaptation)
- Chinchilla scaling laws paper
- NVIDIA GTC on-demand sessions on LLM deployment
- HuggingFace documentation for model architecture reference

## Exam Tactics

### Question Strategy
1. **Read Carefully:** Identify the specific NVIDIA tool or technology referenced
2. **Eliminate:** Remove answers that use incorrect tools for the scenario
3. **Think NVIDIA-First:** Prefer NVIDIA solutions (NeMo, TensorRT-LLM, NIM) over generic alternatives
4. **Consider Constraints:** Pay attention to GPU memory, latency, and cost requirements
5. **Production Focus:** Prefer scalable, production-ready approaches

### Time Management
- **~1.7-2 minutes per question** average
- **Flag and move:** Don't spend more than 3 minutes on any question
- **Reserve 15-20 minutes** for reviewing flagged questions
- **Quick wins first:** Answer confident questions to build momentum

### Common Patterns in Questions
- **"Most efficient method"** - Think about the specific resource constraint
- **"Best approach for production"** - Think NIM, Triton, monitoring
- **"Optimize for latency"** - Think quantization, batching, TensorRT-LLM
- **"Reduce training cost"** - Think PEFT methods, mixed precision
- **"Improve RAG quality"** - Think re-ranking, hybrid search, chunking

## Common Pitfalls

### Study Mistakes
- Memorizing API syntax instead of understanding architecture concepts
- Skipping hands-on practice with NVIDIA tools
- Not understanding when to use NeMo vs TensorRT-LLM vs NIM
- Focusing only on training and ignoring inference optimization
- Not practicing with actual GPU hardware

### Exam Mistakes
- Choosing generic open-source solutions over NVIDIA-specific tools
- Not considering GPU memory constraints in architecture decisions
- Confusing data parallelism with tensor parallelism
- Overlooking quantization as an optimization strategy
- Not reading the full question including constraints and requirements

### Conceptual Confusions to Avoid
- LoRA vs full fine-tuning tradeoffs (memory, quality, speed)
- Static vs continuous batching performance implications
- Tensor parallelism (for latency) vs data parallelism (for throughput)
- Pre-training vs fine-tuning vs inference optimization
- RAG vs fine-tuning for domain knowledge (when to use each)

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** Transformer architecture, NeMo setup, distributed training basics
- **Week 3-4:** Fine-tuning methods, TensorRT-LLM optimization
- **Week 5:** RAG pipeline development and evaluation
- **Week 6:** Production deployment with NIM, guardrails, monitoring
- **Week 7:** Practice exams and gap analysis
- **Week 8:** Final review and exam

### Self-Assessment Questions
- Can I explain how multi-head attention works and why it matters?
- Do I know the memory requirements for different model sizes and precisions?
- Can I select the right PEFT method for a given constraint?
- Can I design a TensorRT-LLM deployment with the right quantization?
- Can I architect a production RAG pipeline with NVIDIA tools?
- Do I understand NeMo Guardrails and how to implement safety rails?
