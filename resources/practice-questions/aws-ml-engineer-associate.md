# AWS Certified Machine Learning Engineer - Associate (MLA-C01) - Practice Questions

15 scenario-based questions for MLA-C01 prep. The current AWS ML credential, replacing the retired MLS-C01 (Specialty).

> **Cert page:** [exams/aws/associate/ml-engineer-mla-c01/](../../exams/aws/associate/ml-engineer-mla-c01/)

---

### Question 1
**Scenario:** A team has 1 TB of training data in S3 and runs SageMaker training jobs. The job is read-bound. What feature optimizes I/O?

A. Use SageMaker File mode (download all data first)
B. Use SageMaker FastFile mode or Pipe mode (stream data, no full download)
C. Move data to EBS
D. Use smaller instances

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** File mode downloads everything before training (slow startup). FastFile / Pipe streams from S3 during training, faster startup and lower disk needs. FastFile is the modern default; Pipe is legacy.
</details>

---

### Question 2
**Scenario:** Hyperparameter tuning across 100 candidate configs - what SageMaker feature?

A. SageMaker Automatic Model Tuning (AMT) with Bayesian search
B. Manual grid search via shell scripts
C. SageMaker Pipelines
D. EC2 Spot Fleet

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** AMT runs hyperparameter tuning jobs with Bayesian, random, grid, or Hyperband strategies. Bayesian is most efficient for expensive training. Stop early if a config underperforms (early stopping).
</details>

---

### Question 3
**Scenario:** A batch inference job needs to score 10M records overnight. What endpoint type?

A. Real-time endpoint
B. SageMaker Batch Transform
C. SageMaker Serverless inference
D. Lambda

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Batch Transform is purpose-built for large-scale batch inference - distributed, fault-tolerant, no idle endpoint cost. Real-time endpoints have idle cost; Serverless has cold-start latency; Lambda has 15-min limit.
</details>

---

### Question 4
**Scenario:** A team needs A/B testing between model v1 and v2. Which SageMaker feature?

A. Inference recommender
B. SageMaker endpoints with multiple production variants and traffic split (e.g., 90/10)
C. Two separate endpoints + manual routing
D. Lambda function with random routing

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SageMaker endpoints support production variants - multiple models behind one endpoint with weighted traffic split. Built-in for A/B and canary patterns.
</details>

---

### Question 5
**Scenario:** Data drift detection on a deployed model - which SageMaker feature?

A. SageMaker Model Monitor
B. CloudWatch only
C. Amazon Macie
D. AWS Config

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Model Monitor watches input/output distributions for drift (data drift, model quality drift, bias drift, feature attribution drift). Captures inference data, compares against a baseline computed from training data, alerts on deviation.
</details>

---

### Question 6
**Scenario:** A team trains a custom image classifier. They want to use a pre-trained backbone (ResNet) and fine-tune the final layers. Which approach?

A. Train from scratch
B. Transfer learning with a pre-trained model from SageMaker JumpStart
C. Use only Amazon Rekognition
D. Custom hardware

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Transfer learning is the standard pattern for image/NLP - start with a pre-trained backbone, fine-tune on your task. JumpStart provides 500+ pre-trained models with one-click deployment and fine-tuning.
</details>

---

### Question 7
**Scenario:** Data labeling at scale - which AWS service?

A. SageMaker Ground Truth (managed labeling with human workforce + ML-assisted labeling)
B. AWS Lambda
C. Amazon Mechanical Turk only
D. SageMaker Studio

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Ground Truth manages labeling jobs - public workforce (Mechanical Turk), private workforce (your employees), or vendors. ML-assisted active labeling reduces cost (~70%) by auto-labeling high-confidence items.
</details>

---

### Question 8
**Scenario:** A SageMaker Pipelines pipeline orchestrates: preprocess → train → evaluate → register → deploy. What's the value vs raw scripts?

A. Versioned, reproducible, lineage-tracked, integrated with SageMaker Model Registry, conditional steps
B. Faster execution
C. Lower cost
D. They're identical

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Pipelines provide ML-aware orchestration with experiment tracking, model lineage, conditional logic, and Model Registry integration. Better than raw scripts for production ML reliability.
</details>

---

### Question 9
**Scenario:** A model needs to serve predictions in <100ms. What endpoint configuration?

A. Real-time endpoint with provisioned instances; enable auto-scaling on InvocationsPerInstance
B. Batch Transform
C. Serverless inference
D. Lambda only

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Real-time endpoints with appropriately-sized instances meet sub-100ms latency. Auto-scaling adapts to traffic. Serverless has variable cold start (could be slower). Batch is high-throughput, not low-latency.
</details>

---

### Question 10
**Scenario:** Which is the AWS-managed feature store?

A. SageMaker Feature Store
B. Amazon RDS
C. DynamoDB
D. ElasticSearch

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** SageMaker Feature Store is the managed feature store: online (low-latency lookup) + offline (S3-backed for training). Solves train/serve skew by ensuring features are computed identically for both.
</details>

---

### Question 11
**Scenario:** A model is in production. Its accuracy slowly degrades over weeks. What's the most likely cause?

A. The model was always broken
B. Concept drift (the underlying relationship between features and target shifts over time, e.g., user preferences change)
C. Hardware failure
D. Network latency

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Concept drift = the world changes, so a model trained on yesterday's patterns underperforms. Mitigated by periodic retraining, online learning, or change-detection alarms (Model Monitor).
</details>

---

### Question 12
**Scenario:** A model trained on US data underperforms in EU markets. What's the issue?

A. Network latency
B. Distribution shift / data drift between training and deployment populations
C. Model size
D. The model is broken

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Distribution shift = the deployed population differs from the training population (different demographics, behaviors, etc.). Mitigation: train per-region, ensemble, fine-tune on local data, or domain adaptation techniques.
</details>

---

### Question 13
**Scenario:** SageMaker Clarify is for:

A. Encryption
B. Bias detection in data and models, plus model explainability (SHAP values)
C. Cost optimization
D. Networking

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Clarify analyzes datasets and models for bias across protected attributes, and provides SHAP-based explanations of individual predictions. Required for high-stakes regulated applications.
</details>

---

### Question 14
**Scenario:** Multi-model endpoint vs multiple single-model endpoints?

A. Multi-model endpoint hosts many models on shared compute (low traffic per model = cost savings)
B. They're identical
C. Multi-model is always slower
D. Multi-model only works for one framework

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Multi-model endpoints (MME) host hundreds of models on shared instances - models loaded on demand. Best when you have many low-traffic models (per-customer model). Bigger ratio of models to instances = bigger savings.
</details>

---

### Question 15
**Scenario:** Bedrock vs SageMaker - high-level distinction?

A. Bedrock = managed access to foundation models via API (no model hosting); SageMaker = full ML platform including custom training, hosting, MLOps
B. Identical
C. SageMaker only does training; Bedrock only does inference
D. Bedrock is for non-ML

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Bedrock = "I want to call Claude/Llama via API." SageMaker = "I want to train, tune, deploy, and monitor my own models" (with optional access to foundation models via JumpStart). They complement each other - many architectures use both.
</details>

---

## Scoring guide

- **13-15:** Schedule the exam.
- **10-12:** Re-read SageMaker / Bedrock sections.
- **<10:** Hands-on with SageMaker Studio + re-read fact-sheet.

MLA-C01: 65 questions, 130 minutes, 720/1000 passing. Tests applied SageMaker / Bedrock judgment. Less algorithmic depth than MLS-C01, more MLOps + GenAI focus.
