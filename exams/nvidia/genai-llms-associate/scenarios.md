# NCA-GENL High-Yield Scenarios and Practice Problems

## Scenario 1: Choosing the Right Model Architecture

**Scenario**: A company needs to build a document classification system that categorizes customer support tickets into predefined categories. The system needs to analyze the full content of each ticket and assign one or more labels. Which model architecture is most appropriate?

**Solution Pattern**:
- **Best Choice**: Encoder-only model (BERT/RoBERTa) fine-tuned for multi-label classification
- **Reasoning**: Classification requires understanding the full input bidirectionally, not generating new text
- **Approach**: Fine-tune with classification head on labeled ticket data

**Common Distractors**:
- Decoder-only model (GPT) - can work but is over-engineered for classification, less efficient
- Encoder-decoder model (T5) - unnecessary sequence-to-sequence capability for simple labels
- Zero-shot prompting without fine-tuning - lower accuracy than fine-tuned classifier for this use case

**Key Takeaway**: Match the model architecture to the task type. Encoder models excel at understanding/classification tasks.

---

## Scenario 2: RAG Pipeline Design

**Scenario**: A legal firm wants to build a Q&A system over 50,000 legal documents (contracts, case briefs, regulations). Documents range from 5 to 200 pages. Users ask specific legal questions and need precise, referenced answers. How should the RAG pipeline be designed?

**Solution Pattern**:
- **Chunking**: Document-aware chunking that respects section boundaries (headers, clauses); chunk size of 512 tokens with 10-15% overlap
- **Embedding Model**: High-quality legal-domain or general embedding model (NVIDIA NV-Embed)
- **Vector Database**: Milvus for production-scale deployment with HNSW indexing
- **Retrieval**: Hybrid search (dense + sparse/BM25) with cross-encoder re-ranking
- **Generation**: LLM with retrieved chunks as context, instructed to cite sources

**Common Distractors**:
- Fixed-size character splitting - loses document structure and splits mid-sentence/clause
- Flat index for 50K documents - HNSW or IVF needed for efficient search at scale
- Returning only the top-1 result - legal questions often need multiple relevant sections
- Skipping re-ranking - significantly reduces answer quality for legal precision

**Key Takeaway**: Document type and user requirements should drive chunking strategy. Production scale demands efficient indexing and re-ranking.

---

## Scenario 3: Fine-Tuning Method Selection

**Scenario**: A healthcare startup has a 7B parameter LLM and wants to adapt it for medical question answering. They have 5,000 high-quality medical Q&A pairs curated by doctors. Their infrastructure includes a single NVIDIA A100 80GB GPU. Which fine-tuning approach should they use?

**Solution Pattern**:
- **Best Choice**: LoRA fine-tuning with NeMo Framework
- **Configuration**: Rank 16-32, applied to attention layers (Q, K, V projections)
- **Reasoning**: 5,000 examples is sufficient for LoRA; single A100 has enough memory for 7B model with LoRA; PEFT preserves general knowledge while adapting to medical domain

**Common Distractors**:
- Full fine-tuning - 7B model full fine-tuning requires 4-6x model size in memory (~120-168GB), exceeds single A100 capacity
- QLoRA - works but unnecessary when LoRA fits in memory; QLoRA adds quantization overhead
- RAG only without fine-tuning - misses the opportunity to embed medical reasoning into the model
- Training from scratch - completely impractical with only 5,000 examples

**Key Takeaway**: LoRA is the sweet spot when you have moderate data, limited compute, and want to preserve the base model's general capabilities.

---

## Scenario 4: Inference Optimization

**Scenario**: An e-commerce company is deploying an LLM-based chatbot that handles 1,000 concurrent users. Average response needs to be under 2 seconds for the first token. They are using NVIDIA H100 GPUs. How should they optimize the deployment?

**Solution Pattern**:
- **Deployment**: NVIDIA NIM for containerized, optimized serving
- **Optimization**: TensorRT-LLM with FP8 quantization (H100 supports FP8 natively)
- **Batching**: Continuous (in-flight) batching to maximize GPU utilization across concurrent users
- **KV-Cache**: Paged attention to efficiently manage memory across many concurrent sessions
- **Scaling**: Multiple NIM instances behind a load balancer for horizontal scaling

**Common Distractors**:
- Static batching - inefficient for variable-length chat responses, wastes GPU time waiting for longest sequence
- FP32 inference - massive waste of H100 capabilities, uses 4x memory vs FP8
- Single instance deployment - cannot handle 1,000 concurrent users on one instance
- INT4 quantization - unnecessary quality loss when H100 has native FP8 support with minimal quality impact

**Key Takeaway**: Match quantization to GPU capabilities (FP8 on H100), use continuous batching for chat workloads, and scale horizontally for high concurrency.

---

## Scenario 5: Prompt Engineering for Complex Tasks

**Scenario**: A financial analyst needs to extract structured data from earnings call transcripts. The output should include: company name, revenue figures, growth percentage, and key risks mentioned. The data needs to be in JSON format. Design an effective prompting strategy.

**Solution Pattern**:
- **Approach**: Few-shot prompting with structured output specification
- **System Prompt**: Define role as financial data extraction specialist
- **Few-Shot Examples**: 2-3 examples showing transcript input and correct JSON output
- **Temperature**: Set to 0.0-0.1 for deterministic, accurate extraction
- **Output Format**: Explicitly specify JSON schema in the prompt

**Example Prompt Structure**:
```
System: You are a financial data extraction specialist. Extract structured data from earnings call transcripts and return valid JSON.

Example 1:
[Transcript excerpt]
Output: {"company": "...", "revenue": "...", "growth": "...", "risks": [...]}

Example 2:
[Transcript excerpt]
Output: {"company": "...", "revenue": "...", "growth": "...", "risks": [...]}

Now extract data from the following transcript:
[New transcript]
```

**Common Distractors**:
- Zero-shot without format specification - output format will be inconsistent
- High temperature (0.8+) - introduces randomness in factual extraction tasks
- Chain-of-thought prompting - adds unnecessary reasoning steps for extraction; slows response
- Fine-tuning for this task - overkill when prompt engineering achieves reliable extraction

**Key Takeaway**: For structured extraction tasks, use few-shot prompting with explicit output schemas and low temperature for consistency.

---

## Scenario 6: Responsible AI Implementation

**Scenario**: A company is deploying a customer-facing chatbot for insurance inquiries. The chatbot must not provide specific medical advice, must not generate discriminatory responses, and must accurately represent policy information. How should they implement safety guardrails?

**Solution Pattern**:
- **Safety Layer**: NVIDIA NeMo Guardrails
- **Topical Rails**: Restrict to insurance-related topics, redirect medical questions to professionals
- **Content Rails**: Block discriminatory, harmful, or misleading content
- **Factual Rails**: Ground responses in official policy documents using RAG
- **Monitoring**: Log conversations for periodic human review and audit

**Implementation Layers**:
1. Input filtering - detect and block harmful/off-topic inputs
2. RAG grounding - retrieve from verified policy documents
3. Output filtering - verify response does not contain medical advice or discriminatory content
4. Jailbreak detection - identify attempts to bypass safety rails
5. Escalation - route complex or sensitive queries to human agents

**Common Distractors**:
- Relying only on the model's training for safety - insufficient for production deployment
- Blocking all questions outside a narrow list - creates poor user experience
- Post-deployment monitoring only without proactive guardrails - reactive instead of preventive
- Using a different LLM to check outputs - adds latency and complexity; NeMo Guardrails is purpose-built

**Key Takeaway**: Defense in depth with NeMo Guardrails provides programmable, layered safety that is more reliable than relying on model training alone.

---

## Scenario 7: RAG vs Fine-Tuning Decision

**Scenario**: A company has a large internal knowledge base that changes weekly with new product documentation. They want their LLM assistant to always provide current, accurate product information. Their knowledge base contains 10,000 documents totaling 50GB of text. Should they use RAG, fine-tuning, or both?

**Solution Pattern**:
- **Primary Approach**: RAG with the internal knowledge base
- **Reasoning**:
  - Knowledge changes weekly - RAG handles updates by re-indexing documents without retraining
  - 50GB of text is too large to embed into model parameters through fine-tuning alone
  - RAG provides source attribution for answers
  - New documents are immediately available after indexing
- **Optional Enhancement**: Light fine-tuning (LoRA) to teach the model company-specific terminology and response style

**Common Distractors**:
- Fine-tuning only - cannot keep up with weekly changes, requires retraining each time
- Increasing context window to fit all documents - impractical for 50GB of text
- Caching all documents in the prompt - exceeds any model's context window
- Re-training the model weekly - extremely expensive and time-consuming

**Key Takeaway**: RAG is the right choice when knowledge is dynamic, large, or needs source attribution. Fine-tuning is better for teaching style, reasoning patterns, or domain-specific behavior.

---

## Scenario 8: Vector Database Selection and Configuration

**Scenario**: A startup is building a semantic search engine over 10 million product descriptions. They need sub-100ms query latency, the ability to filter by product category, and they expect the index to grow by 1 million documents per month. Which vector database and configuration should they choose?

**Solution Pattern**:
- **Vector Database**: Milvus - supports filtering, horizontal scaling, and high-volume ingestion
- **Index Type**: HNSW for sub-100ms latency with high recall
- **Embedding Dimensions**: 768-1024 (balance between quality and storage)
- **Filtering**: Use Milvus attribute filtering combined with vector search for category constraints
- **Scaling**: Configure Milvus cluster with multiple query nodes for read scaling

**Architecture**:
1. Embedding service (NVIDIA NIM with NV-Embed model)
2. Milvus cluster (distributed deployment with separate query and data nodes)
3. API layer for query processing and result formatting
4. Batch ingestion pipeline for monthly document updates

**Common Distractors**:
- FAISS without a database layer - lacks built-in filtering, persistence, and horizontal scaling
- Flat index - O(n) search on 10M vectors will not meet latency requirements
- Chroma - designed for smaller-scale development, not 10M+ production workloads
- Re-computing embeddings on every query - FAISS/vector DBs store pre-computed embeddings for fast retrieval

**Key Takeaway**: Production vector search at scale requires a purpose-built database (Milvus, Pinecone) with efficient indexing (HNSW) and metadata filtering capabilities.
