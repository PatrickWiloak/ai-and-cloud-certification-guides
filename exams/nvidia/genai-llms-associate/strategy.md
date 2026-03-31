# NCA-GENL Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **AI and Deep Learning Basics**
   - Review neural network fundamentals if needed
   - Understand the evolution from RNNs to transformers
   - Study the original "Attention Is All You Need" paper concepts
   - Learn key terminology (parameters, tokens, embeddings, inference)

2. **Transformer Architecture Deep Dive**
   - Self-attention mechanism and multi-head attention
   - Encoder vs decoder vs encoder-decoder architectures
   - Tokenization methods (BPE, WordPiece, SentencePiece)
   - Positional encoding and why it matters
   - Pre-training objectives (CLM, MLM, span corruption)

3. **Model Landscape**
   - GPT family (decoder-only, autoregressive)
   - BERT family (encoder-only, bidirectional)
   - T5 family (encoder-decoder, text-to-text)
   - LLaMA, Mistral, Mixtral (open-weight models)
   - NVIDIA Nemotron models

### Phase 2: Applied Techniques (2-3 weeks)
1. **Prompt Engineering**
   - Zero-shot, few-shot, and chain-of-thought prompting
   - System prompts and instruction formatting
   - Sampling parameters (temperature, top-k, top-p)
   - Output formatting and structured responses
   - Prompt injection awareness

2. **RAG and Vector Databases**
   - End-to-end RAG pipeline architecture
   - Embedding models and similarity search
   - Vector database options (FAISS, Milvus, Pinecone)
   - Chunking strategies and their trade-offs
   - Indexing methods (HNSW, IVF, flat)
   - NVIDIA NeMo Retriever components

3. **Fine-Tuning Methods**
   - Full fine-tuning vs PEFT trade-offs
   - LoRA and QLoRA concepts and configuration
   - RLHF and DPO alignment techniques
   - Training data preparation and quality
   - Evaluation metrics and methodology

4. **Hands-on Practice**
   - Build a basic RAG pipeline
   - Experiment with prompt engineering techniques
   - Run LoRA fine-tuning on a small model
   - Deploy a model with NVIDIA NIM

### Phase 3: Exam Preparation (1-2 weeks)
1. **NVIDIA Ecosystem Review**
   - NeMo Framework capabilities and use cases
   - NIM deployment and configuration
   - TensorRT-LLM optimization features
   - Triton Inference Server fundamentals
   - NeMo Guardrails for safety

2. **Practice and Review**
   - Take practice assessments
   - Review incorrect answers and identify gaps
   - Create flashcards for key concepts
   - Focus on areas with lowest confidence

3. **Final Review**
   - Review fact sheet and quick reference tables
   - Practice scenario-based reasoning
   - Refresh NVIDIA-specific tool knowledge
   - Review responsible AI concepts

## Recommended Resources

### Official NVIDIA Resources
- **[NVIDIA DLI - Generative AI Explained](https://www.nvidia.com/en-us/training/)** - Foundational course
- **[NVIDIA DLI - Building RAG Agents](https://www.nvidia.com/en-us/training/)** - RAG hands-on course
- **[NVIDIA NeMo Documentation](https://docs.nvidia.com/nemo-framework/user-guide/latest/index.html)** - Framework reference
- **[NVIDIA NIM Documentation](https://docs.nvidia.com/nim/index.html)** - Deployment guides
- **[NVIDIA Developer Blog](https://developer.nvidia.com/blog/)** - Technical articles and tutorials

### Free Learning Resources
- **[Hugging Face NLP Course](https://huggingface.co/learn/nlp-course)** - Transformer fundamentals
- **[Hugging Face Transformers Docs](https://huggingface.co/docs/transformers/index)** - Library documentation
- **[LangChain Documentation](https://python.langchain.com/docs/get_started/introduction)** - RAG framework
- **[NVIDIA AI Playground](https://build.nvidia.com/)** - Interactive model testing
- **[Stanford CS224N](https://web.stanford.edu/class/cs224n/)** - NLP with deep learning lectures

### Recommended Reading
- "Attention Is All You Need" (Vaswani et al., 2017) - transformer architecture
- "BERT: Pre-training of Deep Bidirectional Transformers" (Devlin et al., 2018) - encoder models
- "Language Models are Few-Shot Learners" (Brown et al., 2020) - GPT-3 and in-context learning
- "LoRA: Low-Rank Adaptation of Large Language Models" (Hu et al., 2021) - PEFT method
- "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020) - RAG

## Exam Tactics

### Question Strategy
1. **Read the entire question** - identify what is actually being asked
2. **Look for NVIDIA-specific angles** - many questions will test NVIDIA tool knowledge
3. **Keywords to watch for:**
   - "Most efficient" - think PEFT, quantization, NIM
   - "Production deployment" - think NIM, TensorRT-LLM, Triton
   - "Reduce hallucination" - think RAG, guardrails, grounding
   - "Customize model" - think fine-tuning, LoRA, NeMo
   - "Responsible" - think guardrails, bias testing, privacy
4. **Eliminate obviously wrong answers** - narrow to 2 choices, then reason carefully
5. **When in doubt** - choose the NVIDIA-native solution

### Time Management
- 60 minutes for 50-60 questions
- Approximately 1 minute per question
- Flag and skip questions that take longer than 90 seconds
- Reserve 10 minutes for reviewing flagged questions
- Don't change answers unless you have a clear reason

### Common Pitfalls

**Conceptual Confusion:**
- Mixing up encoder (BERT) and decoder (GPT) model capabilities
- Confusing RAG with fine-tuning - they solve different problems
- Not understanding when to use full fine-tuning vs LoRA vs QLoRA
- Thinking quantization always significantly degrades quality

**NVIDIA Tool Confusion:**
- NIM is for deployment/inference, not training
- NeMo Framework is for training/customization, not just inference
- TensorRT-LLM is an optimization engine, NIM wraps it for deployment
- Triton can serve any framework, not just TensorRT models
- NeMo Guardrails is separate from model training

**RAG Misconceptions:**
- Bigger chunks are not always better (precision vs context trade-off)
- Vector search is not the same as keyword search
- Embedding model choice significantly impacts retrieval quality
- RAG does not eliminate hallucination entirely, it reduces it

**Fine-Tuning Mistakes:**
- LoRA rank does not need to match model dimensions
- QLoRA quantizes the base model, not the LoRA matrices
- More training data is not always better - quality matters more
- Fine-tuning can cause catastrophic forgetting if done carelessly

## Progress Tracking

### Weekly Milestones
- **Week 1**: Complete transformer architecture and LLM fundamentals
- **Week 2**: Master prompt engineering and start RAG concepts
- **Week 3**: Complete RAG and vector database topics
- **Week 4**: Cover fine-tuning methods and NVIDIA tools
- **Week 5**: Deployment, inference optimization, responsible AI
- **Week 6**: Practice assessments, review weak areas, exam readiness

### Self-Assessment Questions
- Can I explain how self-attention works in a transformer?
- Do I understand the difference between encoder and decoder models?
- Can I design a RAG pipeline and choose appropriate components?
- Do I know when to use LoRA vs QLoRA vs full fine-tuning?
- Can I select the right NVIDIA tool for a given task?
- Do I understand quantization methods and their trade-offs?
- Can I describe responsible AI practices and guardrail concepts?
