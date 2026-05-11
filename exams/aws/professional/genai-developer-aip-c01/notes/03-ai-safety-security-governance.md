# Domain 3: AI Safety, Security, and Governance (20%)

> **20% of the exam.** Heavy emphasis on Bedrock Guardrails and the layered defense model. Don't underestimate this domain - "Pro" exams test nuanced safety/governance scenarios deeply.

## Table of contents

- [Exam tasks and skills](#exam-tasks-and-skills)
- [Task 3.1: Implement input and output safety controls](#task-31-implement-input-and-output-safety-controls)
- [Task 3.2: Implement data security and privacy controls](#task-32-implement-data-security-and-privacy-controls)
- [Task 3.3: Implement AI governance and compliance mechanisms](#task-33-implement-ai-governance-and-compliance-mechanisms)
- [Task 3.4: Implement responsible AI principles](#task-34-implement-responsible-ai-principles)
- [Defense-in-depth reference architecture](#defense-in-depth-reference-architecture)
- [Gotchas and exam traps](#gotchas-and-exam-traps)
- [Quick-recall summary](#quick-recall-summary)

## Exam tasks and skills

### Task 3.1: Implement input and output safety controls
- **3.1.1** Comprehensive content safety against harmful inputs (Bedrock Guardrails for content filtering, Step Functions + Lambda for custom moderation, real-time validation).
- **3.1.2** Content safety frameworks for harmful outputs (Bedrock Guardrails for response filtering, FM evaluations for moderation/toxicity, text-to-SQL for deterministic results).
- **3.1.3** Accuracy verification to reduce hallucinations (Bedrock Knowledge Base for grounding/fact-checking, confidence scoring + semantic similarity, JSON Schema for structured outputs).
- **3.1.4** Defense-in-depth (Comprehend pre-processing filters, Bedrock model-based guardrails, Lambda post-processing validation, API Gateway response filtering).
- **3.1.5** Advanced threat detection (prompt injection / jailbreak detection, input sanitization, safety classifiers, automated adversarial testing).

### Task 3.2: Implement data security and privacy controls
- **3.2.1** Protected AI environments (VPC endpoints, IAM policies, AWS Lake Formation for granular data access, CloudWatch monitoring).
- **3.2.2** Privacy-preserving systems (Comprehend + Macie for PII detection, Bedrock data privacy features, Bedrock Guardrails for PII filtering, S3 Lifecycle for retention).
- **3.2.3** Privacy-focused AI (data masking, Comprehend PII, anonymization, Bedrock Guardrails).

### Task 3.3: Implement AI governance and compliance mechanisms
- **3.3.1** Compliance frameworks (SageMaker AI model cards, AWS Glue for data lineage, metadata tagging, CloudWatch Logs for decision logs).
- **3.3.2** Data source tracking (Glue Data Catalog, metadata tagging for source attribution, CloudTrail audit logging).
- **3.3.3** Organizational governance (frameworks aligning policies, regulatory requirements, responsible AI).
- **3.3.4** Continuous monitoring + advanced governance (automated detection for misuse/drift/policy violations, bias drift, automated alerting/remediation, token-level redaction, response logging, AI output policy filters).

### Task 3.4: Implement responsible AI principles
- **3.4.1** Transparent AI (reasoning displays, CloudWatch confidence metrics, evidence presentation for source attribution, Bedrock agent tracing).
- **3.4.2** Fairness evaluations (CloudWatch fairness metrics, Bedrock Prompt Management + Prompt Flows for A/B testing, Bedrock LLM-as-judge for automated evaluations).
- **3.4.3** Policy-compliant AI (Bedrock Guardrails on policy requirements, model cards documenting limitations, Lambda for automated compliance).

---

## Task 3.1: Implement input and output safety controls

### Bedrock Guardrails - the core service

The single most-tested service in Domain 3.

**Six policy categories:**

| Policy | Detects / Blocks | Configurable? |
|--------|------------------|---------------|
| **Content filters** | Hate, insults, sexual, violence, misconduct, **prompt attacks** | Per-category severity threshold (NONE / LOW / MEDIUM / HIGH) |
| **Denied topics** | Custom topics (e.g., "investment advice", "competitor X") | Define via natural-language description + examples |
| **Word filters** | Specific words and phrases | Custom list + managed list (profanity) |
| **Sensitive information filters** | PII (SSN, credit card, email, phone, names, addresses, etc.) and custom regex patterns | Action: BLOCK or ANONYMIZE; pre-defined PII types or custom regex |
| **Contextual grounding check** | Hallucinated / ungrounded responses | Configurable groundedness threshold + relevance threshold |
| **Image content filters** | Image inputs/outputs (in supported models) | Category-based |

**Application points:**

| Where | How |
|-------|-----|
| Bedrock InvokeModel / Converse | Pass `guardrailIdentifier` + `guardrailVersion` |
| Bedrock Agents | Associate guardrail with the agent |
| Knowledge Base RetrieveAndGenerate | Pass guardrail identifier in request |
| Standalone validation | `ApplyGuardrail` API on any text without invoking a model |

**Guardrails apply to BOTH input and output by default**:
- Input filtering before the model sees the prompt (defends against prompt injection, sensitive info leak in, denied topics)
- Output filtering before response returns to user (catches harmful generations, hallucinations, PII leaks out)

### Reducing hallucinations

Patterns the exam tests:

- **Bedrock Guardrails contextual grounding** - dedicated check for response groundedness against provided context. Configurable threshold (e.g., 0.75 = require 75%+ groundedness score).
- **Knowledge Base for grounding** - retrieve facts, model uses them, Guardrails verifies grounding.
- **Confidence scoring** - request the model output a confidence score; reject responses below threshold; route low-confidence to human review (A2I).
- **Semantic similarity verification** - compare model claims against retrieved evidence with embedding similarity.
- **JSON Schema for structured outputs** - require model to output JSON conforming to a schema; deterministic parse + validate; reject malformed.
- **Text-to-SQL for deterministic results** - when the question is data lookup, use the FM to generate SQL, run it deterministically against the DB; the answer becomes facts, not hallucinations.

### Defense-in-depth (skill 3.1.4)

Layered controls. The exam wants the **multi-layer** answer, not a single point of defense:

```
[User input]
    |
    v
1. API Gateway request validation (schema, size limits)
    |
    v
2. AWS WAF rules (basic injection patterns, rate limits)
    |
    v
3. Lambda input sanitizer (escape, strip, normalize)
    |
    v
4. Amazon Comprehend (PII detection, language detection)
    |
    v
5. Bedrock Guardrails INPUT (content + denied topics + sensitive info + word filters)
    |
    v
6. Bedrock model invocation (with system prompt restrictions)
    |
    v
7. Bedrock Guardrails OUTPUT (content + sensitive info + contextual grounding)
    |
    v
8. Lambda post-processing validator (JSON schema, allow-list output formats, semantic checks)
    |
    v
9. API Gateway response transformer / filter
    |
    v
[Response to user]
```

### Advanced threat detection

| Threat | Defense |
|--------|---------|
| **Prompt injection** ("Ignore previous instructions and...") | Bedrock Guardrails **prompt attack** category, input sanitization, treat user input as data not instructions, separate user content from instructions with XML tags |
| **Jailbreak** (DAN-style attacks) | Same as above + Guardrails denied topics |
| **Indirect prompt injection** (poisoned content in retrieved docs) | Validate source content, content filters on retrieved chunks, Guardrails on the augmented prompt |
| **Data exfiltration via prompt** | Block sensitive info in input; restrict output via JSON Schema; monitor for suspicious patterns |
| **Adversarial inputs** (typos to bypass filters) | Multi-layer detection: input normalization + Guardrails + post-processing |

**Automated adversarial testing**: build a Step Functions workflow that runs known prompt-injection / jailbreak prompts as test cases against your application. Track pass rate over time as a regression metric. Pre-deployment gate.

---

## Task 3.2: Implement data security and privacy controls

### Network isolation

| Layer | Service |
|-------|---------|
| **Private model access** | **VPC endpoints (PrivateLink)** for Bedrock and SageMaker. No internet egress. |
| **Network controls** | Security groups + NACLs |
| **Egress prevention** | VPC endpoint policies + S3 bucket policies + IAM resource policies |

### IAM patterns

- **Least privilege**: Lambda execution role can invoke only specific Bedrock model ARNs / Knowledge Base ARNs / Guardrail ARNs.
- **Resource-based policies**: bucket policies restricting which IAM principals can read training data / vector store backups.
- **Tag-based access control (ABAC)**: tag models / KBs / agents with `tenant=acme`, IAM policy condition `aws:ResourceTag/tenant = ${aws:PrincipalTag/tenant}` so each tenant can only access its own resources.
- **IAM Access Analyzer**: detect unintended cross-account / public access on Bedrock / SageMaker / S3 resources.
- **IAM Identity Center**: federate enterprise IdP for human access; permission sets per role.

### Granular data access

- **AWS Lake Formation**: row-level + column-level + cell-level access control on data lake assets feeding RAG / training. Grant specific columns of a table to specific principals.
- **S3 bucket policies + Object Lambda Access Points** to filter / redact at read time.
- **Aurora row-level security** for vector data alongside relational records.

### PII detection and handling

| Need | Service |
|------|---------|
| **Detect PII in real-time text streams** | **Amazon Comprehend** PII detection API |
| **Detect PII at rest in S3** | **Amazon Macie** (continuous discovery + classification) |
| **Block / mask PII in FM input/output** | **Bedrock Guardrails** sensitive information filter |
| **Custom PII patterns** | Comprehend custom entity recognizers; Bedrock Guardrails custom regex |

**Don't confuse Comprehend vs Macie on the exam:**
- Comprehend: real-time text analysis (detect PII in a string passed to API)
- Macie: at-rest data scanning (continuously scans S3 buckets, classifies, alerts)

### Anonymization and masking

Patterns:
- **Bedrock Guardrails anonymize action** for PII (replaces SSN with `<SSN>`)
- **Comprehend + Lambda** for custom redaction logic
- **Tokenization**: replace PII with reversible tokens stored in DynamoDB / KMS; FM sees tokens, app de-tokenizes for the user
- **Differential privacy techniques** for training data (out of scope at the AIP-C01 candidate level; not a heavy exam topic)

### Data retention

- **Amazon S3 Lifecycle policies**: tier to S3 IA / Glacier / delete after N days. Enforce regulatory retention windows.
- **S3 Object Lock** for WORM (write-once-read-many) when required by regulation.
- **CloudWatch Logs retention** on Bedrock Model Invocation Logs / CloudTrail audit logs.
- **DynamoDB TTL** for ephemeral conversation history (e.g., 24h sessions auto-expire).

### Bedrock data privacy defaults

- AWS does **not** use your inputs/outputs to train provider FMs by default.
- Customer data stays in your AWS account.
- KMS encryption at rest for fine-tuning artifacts and Knowledge Base storage.
- Cross-Region Inference: data may transit through alternate Regions per the inference profile - know your compliance scope.

---

## Task 3.3: Implement AI governance and compliance mechanisms

### Model cards

**SageMaker Model Cards** (programmatic via API or console):
- Document intended use, limitations, training data, evaluation results
- Versioned with the model package
- Required for many regulatory regimes (NIST AI RMF, EU AI Act, internal policies)

The exam often pairs "document FM limitations" → SageMaker Model Cards.

### Data lineage

Why: regulators and risk teams need to know where training/inference data came from.

| Need | Service |
|------|---------|
| **Catalog data sources** | **AWS Glue Data Catalog** (databases, tables, schemas with metadata) |
| **Track lineage of transformations** | **AWS Glue** (lineage tracking for jobs) |
| **Tag data with source attribution** | S3 object tags, Glue Data Catalog metadata, custom attributes on chunks |
| **Audit access to data** | **AWS CloudTrail** + **CloudWatch Logs** + S3 access logs |

### Audit logging

The exam wants both:
- **AWS CloudTrail**: who called what API (control plane). Bedrock has data events for InvokeModel - enable to capture per-invocation audit trails.
- **Bedrock Model Invocation Logs**: per-call prompt + response payloads delivered to S3 and/or CloudWatch Logs. Configurable in Bedrock account settings.

Combine both:
- CloudTrail = "who, when, from where" (identity + time + IP)
- Bedrock Invocation Logs = "what prompts and what responses"
- Together = full audit story.

### Continuous monitoring and bias / drift

| Concern | Service |
|---------|---------|
| **Bias detection on classical ML predictions** | **SageMaker Clarify** (pre-training, post-training, real-time) |
| **Drift detection on classical ML in production** | **SageMaker Model Monitor** |
| **Bias drift, data quality drift, model quality drift** | SageMaker Model Monitor + Clarify |
| **Anomaly in token usage / behavior** | CloudWatch anomaly detection on Bedrock metrics |
| **Misuse detection** | CloudWatch metric filters on Bedrock Invocation Logs (e.g., suspicious prompt patterns) → alarms |
| **Automated remediation** | EventBridge + Lambda triggered by alarms (disable agent, throttle, alert) |
| **Output policy enforcement** | Bedrock Guardrails on every invocation; standalone Guardrails check via `ApplyGuardrail` |

### Token-level redaction and response logging

When you need to ship logs but redact sensitive info:
- Bedrock Guardrails sensitive-info filter with **anonymize** action - logs see redacted content
- Or: log full responses to a restricted S3 bucket (KMS encrypted, IAM restricted), redact for downstream consumers via Object Lambda

### Frameworks and standards

The exam expects you to know these names:
- **NIST AI Risk Management Framework (AI RMF)**
- **ISO/IEC 42001** (AI Management System)
- **EU AI Act**
- **AWS Cloud Adoption Framework for AI/ML/GenAI (CAF-AI)**
- **AWS Well-Architected Generative AI Lens**
- **AWS Generative AI Lifecycle Operational Excellence framework**

Map your governance to these frameworks; document compliance with **Service Catalog** standardized products and **AWS Audit Manager** (control catalogs - though Audit Manager itself isn't in the in-scope list, the concept of mapping controls to frameworks is).

---

## Task 3.4: Implement responsible AI principles

The 5 commonly cited Responsible AI dimensions (the exam references them implicitly):

1. **Fairness** - no biased outcomes across protected groups
2. **Explainability** - users can understand why the model said what it said
3. **Privacy and security** - data is protected
4. **Transparency** - model use, limits, and risks are documented
5. **Veracity and robustness** - model is reliable and accurate
6. **Governance** - clear roles, oversight, accountability

(Some sources list 8 dimensions including Safety, Controllability, Inclusivity - know the spirit, not the exact count.)

### Transparency

- **Reasoning displays** to users: show step-by-step reasoning when relevant (CoT outputs)
- **CloudWatch confidence metrics**: log per-response confidence score; surface to users
- **Evidence / source attribution**: Knowledge Base RetrieveAndGenerate returns citations; show them
- **Bedrock Agent traces**: log thought / action / observation steps; surface to internal users for debugging
- **Model cards**: external documentation of capabilities and limits

### Fairness

| Need | Service |
|------|---------|
| **Bias metrics on classical ML** | **SageMaker Clarify** (data + model bias metrics like DPL, DI, etc.) |
| **A/B test prompt versions** | **Bedrock Prompt Management** versions + **Bedrock Prompt Flows** for routed traffic + CloudWatch metrics |
| **Automated FM evaluation** | **Bedrock Model Evaluation** with **LLM-as-judge** to score outputs across demographic categories |
| **Demographic-balanced eval set** | Build a curated test set; track metrics per slice in CloudWatch |
| **Human evaluation** | **Bedrock Model Evaluation** with human workforce; **Augmented AI (A2I)** for production review |

### Policy compliance

- **Bedrock Guardrails configured per policy** (one guardrail per regulated topic / data class)
- **SageMaker Model Cards** documenting limitations
- **Lambda automated compliance checks** as part of CI/CD: validate that prompts respect policies, that Guardrails are attached, that logging is enabled
- **AWS Service Catalog** to publish only compliance-approved patterns

### Inclusivity / accessibility

- Multilingual support (Cohere Multilingual, Titan Multilingual)
- Audio input (Transcribe) and output (Polly - though Polly is borderline scope)
- Accommodations for disabled users surfaced via accessible UIs

---

## Defense-in-depth reference architecture

A canonical secure GenAI app pattern on AWS:

```
Client (web/mobile/Slack)
  | TLS
  v
Amazon CloudFront (with AWS WAF rules) - L7 protection, rate limiting
  |
  v
Amazon API Gateway (Cognito/IAM auth, request validation, usage plans)
  |
  v
AWS Lambda (in VPC)
  | input sanitization, Comprehend PII pre-check
  v
Bedrock InvokeModel (over VPC endpoint / PrivateLink)
  | with Guardrail (input + output filters)
  v
Bedrock model
  |
  v
Lambda (output validator: JSON Schema + grounding check)
  |
  v
API Gateway -> response

Cross-cutting:
  - All actions logged to CloudTrail (data events for Bedrock)
  - Bedrock Model Invocation Logs to S3 (KMS encrypted)
  - CloudWatch metrics + alarms on token usage, error rate, Guardrail blocks
  - X-Ray traces across the call chain
  - Macie scans S3 buckets that hold logs / KB data for PII drift
  - IAM roles least-privilege; ABAC tags for tenancy
  - SecretsManager for any third-party API keys
```

This pattern answers many "secure architecture for GenAI" exam questions directly.

---

## Gotchas and exam traps

- **"Block PII in real-time prompt"** → **Bedrock Guardrails** sensitive info OR **Amazon Comprehend** in Lambda. NOT Macie.
- **"Discover PII in S3 buckets at rest"** → **Amazon Macie**. Comprehend is for live text.
- **"Reduce hallucinations"** → layered: **Knowledge Base grounding** + **Guardrails contextual grounding** + JSON Schema. Don't pick a single one if "comprehensive" is in the question.
- **"Prompt injection defense"** → **Bedrock Guardrails prompt attack** category + input sanitization + structured prompt with user input in tags. Multi-layer answer.
- **"Validate text without invoking a model"** → `ApplyGuardrail` API.
- **"Document model intended use and limitations"** → **SageMaker Model Cards**.
- **"Audit who called Bedrock"** → **CloudTrail** (data events). For prompt + response content → **Bedrock Model Invocation Logs**. The exam often wants both.
- **"Detect bias drift in production"** → **SageMaker Clarify** + **Model Monitor**. Even though primary use is classical ML, it's the AWS service named in the official guide for fairness/bias.
- **"Granular row-level access on data lake"** → **AWS Lake Formation**. Not S3 ACLs.
- **"Tenant isolation"** → ABAC with IAM tag conditions OR per-tenant resource. Not just bucket prefixes.
- **"Auto-respond to misuse signals"** → CloudWatch alarm + EventBridge + Lambda for automated remediation.
- **"VPC-only Bedrock access"** → **VPC endpoint (PrivateLink)** for Bedrock.
- **"Encryption of fine-tuned model artifacts"** → **KMS** customer-managed key.
- **"Retain prompt logs for compliance, but redact PII"** → Bedrock Guardrails sensitive info **anonymize** + Model Invocation Logs to S3.
- **"Track lineage of training / RAG data"** → **AWS Glue Data Catalog** + Glue lineage; tagging.
- **"A/B test prompt versions for fairness"** → **Bedrock Prompt Management** versions + **Bedrock Prompt Flows** routing + Model Evaluation LLM-as-judge.
- **"Evidence/citations for transparency"** → **Knowledge Base RetrieveAndGenerate** citations + Bedrock Agent trace.
- **"Approval gate before deploying a model"** → **SageMaker Model Registry** approval status + CodePipeline.

---

## Quick-recall summary

- **Bedrock Guardrails** = input + output safety. Six policies: content, denied topics, word, sensitive info, contextual grounding, image. Apply at InvokeModel/Converse, Agents, Knowledge Bases, or standalone via `ApplyGuardrail`.
- Layered defense: API Gateway validation → WAF → Lambda sanitizer → Comprehend PII → **Guardrails input** → FM → **Guardrails output** → Lambda validator → response.
- Hallucination reduction: Knowledge Base grounding + Guardrails contextual grounding + JSON Schema + confidence scores + text-to-SQL.
- Prompt injection: Guardrails **prompt attack** + sanitization + tagged separation of user input from instructions.
- **Comprehend** = real-time text PII; **Macie** = at-rest S3 PII scanning. Don't swap.
- Granular data access: **Lake Formation** (row/column/cell), bucket policies, ABAC.
- Network: **VPC endpoints** (PrivateLink) for Bedrock and SageMaker.
- Encryption: **KMS** for at-rest, TLS in transit; CMKs for customer-managed.
- Retention: **S3 Lifecycle**, **Object Lock** (WORM), CloudWatch Logs retention, DynamoDB TTL.
- Defaults: Bedrock does **not** use customer data to train provider models.
- **SageMaker Model Cards** = documented model intent, training, evaluation, limits.
- Lineage: **Glue Data Catalog** + Glue lineage + tagging.
- Audit: **CloudTrail** (control + data events) + **Bedrock Model Invocation Logs** (prompts + responses) - both together.
- Bias / drift: **SageMaker Clarify** + **Model Monitor**.
- Misuse / anomaly: CloudWatch metrics + alarms + EventBridge → Lambda auto-remediation.
- Transparency: reasoning displays, **Bedrock Agent traces**, RetrieveAndGenerate citations, model cards.
- Fairness: **Clarify** (classical), **Bedrock Model Evaluation** with LLM-as-judge (FMs), Prompt Management/Flows for A/B.
- Frameworks: **NIST AI RMF**, **ISO/IEC 42001**, **EU AI Act**, **CAF-AI**, **Generative AI Lens**.
- Standards-driven deployment: **Service Catalog** for approved patterns; CodePipeline for compliance gating.
