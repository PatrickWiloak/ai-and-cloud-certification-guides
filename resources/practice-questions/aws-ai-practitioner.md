# AWS Certified AI Practitioner (AIF-C01) - Practice Questions

15 scenario-based questions for AIF-C01 prep.

> **Cert page:** [exams/aws/genai/](../../exams/aws/genai/)

---

### Question 1
**Scenario:** A company wants to add a chatbot trained on their internal product docs. They want to avoid model fine-tuning. What pattern?

A. Train a custom LLM from scratch
B. Retrieval Augmented Generation (RAG): retrieve relevant docs at query time and inject into the prompt
C. Continual pre-training
D. Quantization

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RAG retrieves company-specific context at query time without modifying the model. Cheaper, faster, no training data labeling, easier to update (just update the doc store). Fine-tuning is for stylistic adaptation, not knowledge updates.
</details>

---

### Question 2
**Scenario:** What is "hallucination" in the context of LLMs?

A. The model generates plausible-sounding but factually wrong content
B. The model crashes
C. The model refuses to answer
D. A specific technique

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Hallucination = confident but factually incorrect output. Mitigated via grounding (RAG with citations), guardrails, output validation, and clear "I don't know" instructions in the system prompt.
</details>

---

### Question 3
**Scenario:** Which Amazon service hosts foundation models from multiple providers (Anthropic, Meta, Cohere, Stability) behind a unified API?

A. Amazon SageMaker
B. Amazon Bedrock
C. Amazon Rekognition
D. AWS Lambda

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Bedrock is the managed foundation-model API. Models include Claude (Anthropic), Llama (Meta), Mistral, Cohere, Stability, plus Amazon's own Titan family. Pay per token. Bedrock Knowledge Bases adds RAG; Bedrock Agents adds tool-use.
</details>

---

### Question 4
**Scenario:** A bank wants to use AI for credit decisions. What responsible-AI consideration is paramount?

A. Speed of inference
B. Cost
C. Bias and fairness across protected demographics, plus explainability for regulatory compliance
D. Model size

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** High-stakes decisions (lending, hiring, medical) require fairness audits across protected demographics + interpretability for regulations like ECOA, FCRA, GDPR Article 22. Tools: SageMaker Clarify, Bedrock Guardrails, formal model cards.
</details>

---

### Question 5
**Scenario:** Which AWS service is best for analyzing sentiment in customer reviews at scale (no model training needed)?

A. Amazon Bedrock
B. Amazon Comprehend (pre-trained NLP, including sentiment analysis)
C. Amazon Rekognition
D. Amazon Polly

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Comprehend is pre-built NLP: sentiment, entity recognition, key phrases, language detection, PII redaction. No training needed. Bedrock can also do this but Comprehend is simpler and cheaper for the standard use case.
</details>

---

### Question 6
**Scenario:** Prompt engineering best practices include:

A. Clear instructions, examples (few-shot), specifying output format, role assignment
B. Long, complex prompts always
C. No instructions; let the model figure it out
D. Random examples

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Effective prompts are clear, structured, with examples for non-trivial tasks (few-shot), and specify the desired output format (JSON, list, etc.). Roles ("You are a helpful tax advisor") set context.
</details>

---

### Question 7
**Scenario:** What's an "embedding"?

A. A binary file
B. A numeric vector representing the semantic meaning of text/image/audio (similar items have similar vectors)
C. A type of model
D. A storage format

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Embeddings convert content into high-dimensional vectors where semantic similarity = vector closeness. Used in: similarity search, clustering, RAG retrieval, recommendation. Amazon Titan Embeddings, Cohere Embed are common providers.
</details>

---

### Question 8
**Scenario:** Which AWS service provides a serverless vector database for embeddings?

A. Amazon RDS
B. Amazon OpenSearch Serverless (with vector search) or Amazon Bedrock Knowledge Bases
C. Amazon DynamoDB
D. Amazon Athena

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** OpenSearch Serverless supports a vector engine for k-NN searches. Bedrock Knowledge Bases provides a managed RAG stack on top (embedding + vector store + retrieval). Aurora pgvector and Amazon MemoryDB also support vectors.
</details>

---

### Question 9
**Scenario:** A team wants to fine-tune a Bedrock foundation model on company-specific data. What's the prerequisite?

A. Custom hardware
B. A high-quality, labeled dataset; understanding of the cost-vs-RAG tradeoff
C. Permission from Anthropic
D. Bedrock doesn't support fine-tuning

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Bedrock supports fine-tuning for some models (e.g., Titan, Llama via custom models). Requires a labeled dataset. Often RAG is faster/cheaper for knowledge updates; fine-tuning is for stylistic / task-specific behavior. Customers should compare both.
</details>

---

### Question 10
**Scenario:** What's "model bias"?

A. The model is broken
B. The model produces systematically different outputs for different demographic groups due to training data imbalances or labeling
C. The model is too slow
D. A type of error metric

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Bias = systematic, group-correlated error. Sources: imbalanced training data, label noise, proxy features. Mitigation: diverse training data, fairness metrics, post-hoc bias correction, regular audits.
</details>

---

### Question 11
**Scenario:** Bedrock Guardrails do what?

A. Filter prompts and responses for unsafe content (hate, violence, PII), enforce topic restrictions, and apply contextual grounding
B. Speed up inference
C. Reduce cost
D. Cache responses

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Guardrails are configurable safety policies. Block harmful categories, deny topics, redact PII, enforce allowed input/output formats. Apply at the Bedrock API level.
</details>

---

### Question 12
**Scenario:** Which is true about generative AI cost?

A. Always free
B. Pay-per-token (input + output tokens billed separately, often at different rates)
C. Pay per user
D. Subscription only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Bedrock and most LLM APIs bill per token. Input tokens (your prompt) and output tokens (the response) often have different rates. Larger models cost more per token. Optimization: shorter prompts, prompt caching, smaller models when sufficient.
</details>

---

### Question 13
**Scenario:** A "context window" is:

A. The screen the user sees
B. The maximum number of tokens (input + output combined) a model can process in one call (e.g., Claude has up to 1M tokens, GPT-4 Turbo 128K)
C. The number of users
D. The time to respond

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Context window = max tokens per inference. Constrains how much input + output you can fit. Bigger windows enable longer documents, more conversation history, larger code files. Cost scales with tokens, not just window size.
</details>

---

### Question 14
**Scenario:** AWS Q is positioned as:

A. A search engine
B. An AI-powered assistant for AWS users (helps build apps, answer questions about your data, draft code) - separate from Bedrock
C. A foundation model
D. A storage service

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Amazon Q is a SaaS AI assistant: Q Developer (in IDE/CLI), Q Business (enterprise chat over your data), Q in QuickSight (analytics chat). Built on Bedrock under the hood but presented as an opinionated end-user product.
</details>

---

### Question 15
**Scenario:** Most cost-effective way to test if a use case benefits from GenAI:

A. Build a custom model from scratch
B. Use a pre-trained foundation model via Bedrock + RAG, evaluate quality on a test set, then decide whether to invest in fine-tuning or custom models
C. Skip evaluation
D. Hire an AI consultancy

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Standard "build vs buy vs adapt" pattern - start with the cheapest option (managed FM + RAG), evaluate on a representative test set, only invest in custom training when you have evidence the simpler approach falls short.
</details>

---

### Question 16
**Scenario:** A team wants to give Claude / Llama on Bedrock access to internal company docs without fine-tuning.

A. Bedrock Knowledge Bases (managed RAG)
B. SageMaker custom training
C. Embed docs in the prompt
D. Re-train the model from scratch

<details><summary>Answer</summary>

**Correct: A**

**Why:** Bedrock Knowledge Bases handles ingestion, chunking, embedding, vector storage (OpenSearch / Aurora pgvector / Pinecone), and retrieval-augmented prompting. Fully managed. C doesn't scale beyond a few KB.
</details>

---

### Question 17
**Scenario:** Risk that a model trained on biased data perpetuates that bias in predictions:

A. Hallucination
B. Drift
C. Bias / fairness issue
D. Overfitting

<details><summary>Answer</summary>

**Correct: C**

**Why:** Bias in training data leads to biased predictions. Detect with fairness metrics (demographic parity, equalized odds); mitigate by rebalancing training data, using bias-mitigation algorithms, or applying SageMaker Clarify.
</details>

---

### Question 18
**Scenario:** SageMaker feature for monitoring model quality drift over time:

A. SageMaker Model Monitor
B. SageMaker Pipelines
C. SageMaker Studio
D. SageMaker Ground Truth

<details><summary>Answer</summary>

**Correct: A**

**Why:** Model Monitor detects: data quality drift (input distribution), model quality drift (predictions vs labels), bias drift, feature attribution drift. Pipelines orchestrates training; Studio is the IDE; Ground Truth is for labeling.
</details>

---

### Question 19
**Scenario:** Choosing between training a custom model and using a foundation model:

A. Always train custom for accuracy
B. Use foundation model when the task is general (text gen, summarization, classification); train custom for narrow tasks at high volume where the cost math justifies it
C. Always use foundation models
D. Avoid foundation models

<details><summary>Answer</summary>

**Correct: B**

**Why:** Foundation models (Claude, Llama, Titan) handle general tasks out-of-the-box. Custom training pays off only for narrow, high-volume tasks where a smaller fine-tuned model is dramatically cheaper.
</details>

---

### Question 20
**Scenario:** Hallucinations in LLM output. Mitigation:

A. RAG with citations + temperature near 0 + clear system prompts + post-output validation against authoritative sources
B. Always trust LLM output
C. Train a second LLM to verify
D. Disable the LLM

<details><summary>Answer</summary>

**Correct: A**

**Why:** Layered defense: ground the model with retrieved context (RAG), cite sources, lower temperature for factual responses, validate critical output (e.g., extracted numbers) against ground truth.
</details>

---

### Question 21
**Scenario:** A team wants to reduce inference latency on Bedrock without sacrificing quality much.

A. Use a smaller / faster model variant (Haiku vs Sonnet vs Opus)
B. Use a larger model
C. Add more hops in the pipeline
D. Disable streaming

<details><summary>Answer</summary>

**Correct: A**

**Why:** Model size trades quality for speed and cost. Claude Haiku is faster and cheaper than Sonnet, which is faster and cheaper than Opus. Pick the smallest model that meets your quality bar.
</details>

---

### Question 22
**Scenario:** Token cost optimization for an app making many similar calls with a long stable system prompt:

A. Bedrock prompt caching (caches stable prefix across calls)
B. Send the same prompt every time
C. Increase max_tokens
D. Use a more expensive model

<details><summary>Answer</summary>

**Correct: A**

**Why:** Prompt caching dramatically reduces cost for stable-prefix prompts: cached input tokens cost ~10x less than uncached. Available on Bedrock Anthropic models, OpenAI, and others.
</details>

---

### Question 23
**Scenario:** Which service is BEST for transcribing audio recordings to text at scale?

A. Amazon Transcribe
B. Amazon Polly
C. Amazon Translate
D. Amazon Comprehend

<details><summary>Answer</summary>

**Correct: A**

**Why:** Transcribe = speech-to-text. Polly = text-to-speech. Translate = language translation. Comprehend = NLP (entities, sentiment, topics). Memorize the four "talk to AI" managed services.
</details>

---

### Question 24
**Scenario:** Bedrock with strict data residency in regulated industry (finance, healthcare):

A. Bedrock model invocation in your VPC via PrivateLink, AWS does not use customer data to train models, regional endpoints
B. Default Bedrock settings on us-east-1 only
C. Outbound internet from Bedrock
D. Cross-region replication

<details><summary>Answer</summary>

**Correct: A**

**Why:** Bedrock honors regional residency, supports VPC PrivateLink for private network access, and (per terms) doesn't use customer prompts/completions to train models. This is what makes Bedrock acceptable for regulated workloads where direct OpenAI / Anthropic calls aren't.
</details>

---

### Question 25
**Scenario:** Best evaluation approach for a generative AI feature:

A. Build an eval set of representative inputs + expected outputs (or grading rubric); run regularly; track quality metric over time; alert on regression
B. Manual review of every output
C. Trust user feedback
D. Skip evaluation

<details><summary>Answer</summary>

**Correct: A**

**Why:** Eval sets are the regression test for AI. Without them, you can't know if a prompt change, model change, or data change made things better or worse. AWS offers SageMaker Clarify; many teams use LangSmith / Langfuse / Helicone / Phoenix / Braintrust.
</details>

---

## Scoring guide

- **22-25:** Schedule the exam.
- **17-21:** Re-read responsible AI + Bedrock sections.
- **<17:** AWS Skill Builder AI Practitioner course + re-attempt.

AIF-C01 is foundational - tests **awareness** of AI/ML concepts and AWS AI services, not deep technical implementation. 65 questions, 90 minutes, 700/1000 to pass.
