# Azure AI Engineer Associate (AI-102) - Practice Questions

15 scenario-based questions for AI-102 prep.

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

## Scoring guide

- **13-15:** Schedule the exam.
- **10-12:** Re-read prompt engineering + responsible AI sections.
- **<10:** Hands-on with Azure AI Studio + re-read fact-sheet.

AI-102: ~50 questions, 100 minutes, 700/1000 to pass. Strong focus on Azure AI services portfolio and modern GenAI patterns (RAG, prompt flow, evaluation).
