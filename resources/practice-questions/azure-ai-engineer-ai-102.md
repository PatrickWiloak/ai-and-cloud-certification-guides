# Azure AI Engineer Associate (AI-102) - Practice Questions

25 scenario-based questions for AI-102 prep.

> **Cert page:** [exams/azure/ai-102/](../../exams/azure/ai-102/)

---

### Question 1
**Scenario:** A company wants to use GPT-4 via Azure OpenAI Service. What's the correct way to deploy?

A. Public endpoint with API key only
B. Provision an Azure OpenAI resource, deploy a model in Azure AI Studio, and call it from an Azure-resident app or via private endpoint
C. Use OpenAI's public API directly
D. Self-host on a VM

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Azure OpenAI is a managed service with enterprise features: customer-controlled networking, RBAC, content filtering, regional residency. Provision the resource, deploy the model in your subscription, and use Managed Identity or Entra ID for auth.
</details>

---

### Question 2
**Scenario:** A team needs to translate documents into 30 languages with formatting preserved. Which service?

A. Azure Translator (Document Translation feature)
B. Azure Speech
C. Azure Form Recognizer
D. Custom Translator

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Translator's Document Translation translates entire documents (Word, PDF, PowerPoint) preserving format. Custom Translator builds custom translation models on parallel corpora; not needed for standard translation.
</details>

---

### Question 3
**Scenario:** Which Azure service extracts structured data (key-value pairs, tables) from invoices and receipts?

A. Azure Computer Vision OCR (text extraction only)
B. Azure AI Document Intelligence (formerly Form Recognizer) - has prebuilt models for invoices, receipts, IDs
C. Azure Cognitive Search
D. Azure OpenAI

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Document Intelligence has prebuilt models for invoices, receipts, IDs, business cards, contracts. Custom models train on your forms. OCR is just text; Document Intelligence understands structure.
</details>

---

### Question 4
**Scenario:** A chatbot must use company-specific knowledge. Which architecture?

A. Train GPT-4 from scratch
B. RAG: Azure AI Search with vector index + Azure OpenAI for generation, "use your data" feature in Azure AI Studio
C. Custom NLU model only
D. Bot Framework alone

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RAG with Azure AI Search is the canonical pattern. AI Studio's "use your data" feature provides a low-code path to ingest documents, embed, index, and ground LLM responses. Bot Framework provides the chat UI.
</details>

---

### Question 5
**Scenario:** Real-time speech-to-text with speaker diarization (who said what)?

A. Azure Speech Service - speech-to-text with speaker recognition
B. Azure Cognitive Search
C. Azure Video Indexer
D. Azure OpenAI

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Speech Service includes speech-to-text with diarization, custom acoustic models, and pronunciation assessment. Video Indexer adds video-specific features but speech is at the Speech Service level.
</details>

---

### Question 6
**Scenario:** Computer Vision custom image classification on 5000 product images?

A. Azure Custom Vision (custom image classification + object detection)
B. Built-in Computer Vision API only
C. Train from scratch in Azure ML
D. Document Intelligence

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Custom Vision is purpose-built for custom image classification and object detection. Upload labeled images, train, deploy via REST or container. Built-in Computer Vision is generic; Azure ML is overkill for standard image-classification.
</details>

---

### Question 7
**Scenario:** Azure Cognitive Search vs Azure AI Search?

A. They're the same service - rebranded
B. Different services
C. Cognitive Search is older
D. AI Search has fewer features

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Same service, renamed to Azure AI Search to align with the broader Azure AI portfolio. Capabilities: full-text search, vector search, semantic ranking, AI enrichment via skillsets.
</details>

---

### Question 8
**Scenario:** Content moderation for user-generated text (hate speech, harassment, sexual content)?

A. Azure Content Safety (hate, sexual, self-harm, violence with severity levels) - successor to Content Moderator
B. Azure OpenAI alone
C. Azure Translator
D. Azure Form Recognizer

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Azure AI Content Safety provides modern moderation across 4 categories with multi-level severity (Safe / Low / Medium / High). Content Moderator is the legacy product still operational but Content Safety is the recommended path.
</details>

---

### Question 9
**Scenario:** Which Azure service generates speech from text in 50+ languages with voice customization?

A. Azure Speech Service - text-to-speech with neural voices and Custom Neural Voice
B. Azure OpenAI
C. Azure Translator
D. Azure AI Studio

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Speech Service text-to-speech: prebuilt neural voices in 100+ languages, plus Custom Neural Voice for brand-specific voices (requires application + speaker recordings).
</details>

---

### Question 10
**Scenario:** Securing an Azure OpenAI deployment - key controls?

A. Public access only
B. Private endpoint + Microsoft Entra ID auth + Managed Identity from caller + content filtering + abuse monitoring
C. API key in code
D. No security needed

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Layered security: network isolation via private endpoints, identity-based auth (RBAC + Managed Identity, not just API keys), content filtering tuned to your use case, abuse monitoring on logs. API keys in code are a recipe for credential leaks.
</details>

---

### Question 11
**Scenario:** A team needs to fine-tune a GPT model on customer support tickets. What's required?

A. Azure OpenAI fine-tuning support for the model + curated training file in JSONL format + sufficient examples (50-100k typical) + hyperparameter tuning
B. Just upload tickets
C. Train from scratch
D. Fine-tuning isn't supported in Azure OpenAI

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Azure OpenAI supports fine-tuning for select models. Requires JSONL training file (prompt-completion pairs or chat format), validation set, and capacity for fine-tuned hosting. Often RAG is faster/cheaper for knowledge updates; fine-tune for stylistic / instruction-following adaptation.
</details>

---

### Question 12
**Scenario:** Which feature controls LLM output to follow a specific JSON schema?

A. Function calling / structured output / response_format
B. System prompts only
C. Random sampling
D. Temperature = 0

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Modern OpenAI models support structured output: `response_format={"type": "json_schema", ...}` enforces a JSON schema. Function calling has the model produce arguments matching a function signature. Both are reliable for parseable output.
</details>

---

### Question 13
**Scenario:** Azure AI Studio's primary value?

A. Cheaper than other clouds
B. A unified workspace for building, testing, evaluating, and deploying generative AI applications, including prompt flow, evaluation, and "use your data" RAG
C. Only for data scientists
D. Replaces Azure ML

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AI Studio is the GenAI workbench: prompt flow for orchestration, evaluations, fine-tuning, model catalog, content filtering config, deployment. Azure ML is for traditional ML (training/deployment of custom models). They complement each other.
</details>

---

### Question 14
**Scenario:** Detecting prompt injection on user input?

A. Azure AI Content Safety Prompt Shield
B. Hardcoded blocklists
C. Cannot be detected
D. Azure Active Directory

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Prompt Shield (part of Content Safety) detects prompt injection attempts in user input or in retrieved documents (indirect injection). Use as part of layered defense - sanitize, then filter via Prompt Shield, then evaluate response.
</details>

---

### Question 15
**Scenario:** A team wants to evaluate LLM response quality across 100 prompts on 3 model deployments. What feature?

A. Azure AI Studio Evaluation (groundedness, relevance, similarity, fluency metrics with built-in or LLM-as-judge evaluators)
B. Manual review only
C. Azure Test Plans
D. Application Insights

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** AI Studio Evaluation runs prompts across multiple deployments and scores outputs on relevance, groundedness (RAG-specific), fluency, similarity to ground truth, plus custom metrics. Tracks results over time for regression detection.
</details>

---

### Question 16
**Scenario:** A team uses Azure AI Search with vector index for a RAG bot. Retrieval relevance is poor on multi-sentence questions. Which change usually helps most?

A. Switch from cosine similarity to dot product
B. Enable hybrid retrieval (BM25 keyword + vector) and add a semantic ranker
C. Increase the embedding model temperature
D. Reduce chunk size to 50 tokens

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Hybrid (keyword + vector) + semantic ranking consistently outperforms vector-only on multi-sentence queries because the ranker re-orders the top-N candidates using a cross-encoder. AI Search exposes both as a single query option. Embedding similarity metric and temperature have far smaller effects.
</details>

---

### Question 17
**Scenario:** Your application sends 8K-token prompts to GPT-4o thousands of times a day, often with the same long system prompt. Cost is high. What helps most?

A. Switch to GPT-3.5
B. Enable prompt caching on the static system prompt prefix so cached input tokens are billed at a discounted rate
C. Disable streaming
D. Add more context

**Correct: B**

**Why:** Azure OpenAI supports prompt caching for repeated prompt prefixes (and a "global standard" deployment uses it). Cached tokens are charged at a fraction of normal input rate. Splitting the static system prompt up front and the variable user content at the end maximizes hit rate.

---

### Question 18
**Scenario:** A developer wants to enrich documents in AI Search with custom logic during indexing (e.g., call an internal classifier). Which feature?

A. Custom skill - exposed as a Web API skill in the AI Search skillset
B. Built-in OCR
C. Indexer schedule
D. Power Automate

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** AI Search skillsets chain enrichment steps. Custom skills are HTTPS endpoints (Azure Function is common) that follow the skill input/output contract, letting you plug in classification, redaction, or domain-specific extractors during indexing.
</details>

---

### Question 19
**Scenario:** Bot Framework: which choice connects a published bot to Microsoft Teams without rewriting code?

A. Build a separate Teams app
B. Add a Microsoft Teams channel in Azure Bot resource configuration
C. Webhook proxy
D. Azure Logic Apps

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Azure Bot resources support multiple "channels" (Teams, Web Chat, Direct Line, SMS, etc.) via configuration. The bot logic runs once; channels handle protocol translation. Each channel has its own configuration page in the portal.
</details>

---

### Question 20
**Scenario:** Document Intelligence: which model type is best for extracting fields from a custom contract layout that varies slightly across vendors?

A. Prebuilt invoice model
B. Custom neural model trained on labeled samples (5+ per layout)
C. Read API only
D. Layout API only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Custom neural models handle layout variation (vs custom template models which are stricter on positioning). Train on 5+ labeled samples per variant and the model generalizes across similar but non-identical layouts. Layout API gives you raw structure but no field labels.
</details>

---

### Question 21
**Scenario:** A team needs to generate captions for product images at scale, in multiple languages. Which combination is most direct?

A. Computer Vision describe + Translator
B. Custom Vision
C. Document Intelligence + Speech
D. Azure OpenAI vision input + multilingual prompt

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** GPT-4o (and similar) accept image input plus a multilingual prompt and produce captions in any target language in one call. Computer Vision describe + Translator works but adds latency and a translation step. Custom Vision classifies, doesn't caption.
</details>

---

### Question 22
**Scenario:** Responsible AI: a chatbot occasionally outputs ungrounded answers ("hallucinations") despite having retrieval-based context. Which mitigations stack best?

A. Lower temperature only
B. Layered: tighter retrieval + system prompt that says "if not in context, say I don't know" + Azure AI Studio Groundedness evaluation in CI + Content Safety Groundedness Detection at runtime
C. Switch models
D. Add more training data

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Hallucinations are a multi-cause problem - retrieval, prompting, and evaluation all contribute. Stacked defenses: improve retrieval quality, instruct the model to abstain, evaluate offline with Groundedness metric, detect at runtime with Content Safety. Single levers (temperature, model swap) rarely solve it alone.
</details>

---

### Question 23
**Scenario:** Speech Service: how do you build a voicebot that can be interrupted mid-sentence by the user?

A. Polling
B. Speech SDK with continuous recognition + push-to-talk on the synthesized audio so the engine can stop output when user speech is detected (barge-in)
C. Cancel after each turn
D. Use REST API only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Barge-in / interruption requires continuous recognition (not single-shot) plus the ability to stop the TTS playback when speech is detected. Speech SDK exposes both. REST API is request/response, not appropriate for full-duplex conversation.
</details>

---

### Question 24
**Scenario:** A team builds a multi-agent app in Azure AI Studio's prompt flow. Which design ensures observability and reproducibility across runs?

A. Print to console
B. Enable trace + log to Application Insights, save flow versions, parameterize models so swapping deployments is one-line
C. Manual notes
D. Disable telemetry

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Prompt flow tracing emits per-node spans to App Insights (latency, tokens, errors). Versioned flows + parameterized model deployments make A/B comparison and rollback trivial. This is the GenAI equivalent of structured logging + feature flags.
</details>

---

### Question 25
**Scenario:** Pricing: which decision lever has the largest direct impact on monthly Azure OpenAI spend for a bursty workload?

A. Choosing PTU (provisioned throughput units) for steady high volume vs pay-as-you-go for bursty
B. Number of API keys
C. Region
D. Resource group name

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** PTU buys reserved throughput at a flat hourly rate - cheaper if utilization is high, expensive if idle. Pay-as-you-go is per-token, no commitment - fits bursty / unpredictable load. Wrong choice can swing costs 5-10x. Region affects availability and data residency, not directly the unit price for the same SKU.
</details>

---

## Scoring guide

- **22-25:** Schedule the exam.
- **17-21:** Re-read prompt engineering + responsible AI sections.
- **<17:** Hands-on with Azure AI Studio + re-read fact-sheet.

AI-102: ~50 questions, 100 minutes, 700/1000 to pass. Strong focus on Azure AI services portfolio and modern GenAI patterns (RAG, prompt flow, evaluation).
