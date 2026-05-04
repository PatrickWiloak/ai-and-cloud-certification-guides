---
last-updated: 2026-05-03
---

# GCP Professional Machine Learning Engineer (PMLE) - Exam Scenarios

> Six worked scenarios mirroring PMLE question style. PMLE tests ML problem framing, data engineering for ML, model development, MLOps, and Vertex AI specifically.

---

## Scenario 1 - Pre-built model vs custom (Domain: Architecture)

A team needs to extract entities and sentiment from product reviews. They have no labeled data and want to ship in 2 weeks.

**Options:** A. Vertex AI Natural Language API (pre-trained). B. Custom BERT trained on Vertex AI. C. AutoML Natural Language. D. Self-hosted Hugging Face model.

**Analysis:** A is right for time-to-ship and zero labeling. B requires labeling. C - AutoML still needs labels. D adds infra. The PMLE rule: build > buy only when pre-trained doesn't meet quality.

**Answer:** A

**Key takeaway:** GCP ML hierarchy: pre-trained APIs (Vision, NL, Speech, Translate) → AutoML (your data, no code) → custom training on Vertex AI. Climb the ladder only when needed.

---

## Scenario 2 - Training-serving skew (Domain: MLOps)

A team's online inference quality degrades over weeks. Training data is processed differently than inference data; features differ.

**Options:** A. Vertex AI Feature Store with the same feature definitions for training and serving. B. Two pipelines, audit weekly. C. Train on smaller batches more often. D. Add monitoring without changing the cause.

**Analysis:** A is right - Feature Store is the canonical fix for training-serving skew (offline + online stores share feature definitions). B is the problem. C / D don't fix the cause.

**Answer:** A

**Key takeaway:** Training-serving skew → Feature Store. Monitor with Vertex AI Model Monitoring (data drift + feature attribution drift).

---

## Scenario 3 - Distributed training cost (Domain: Modeling)

Training a 1B-param model takes 14 days on a single A100. Cost matters; some interruption is acceptable.

**Options:** A. Multi-node distributed training on Vertex AI with Spot VMs (preemptible) and checkpointing. B. Single A100 always-on. C. CPU-only training. D. AutoML Tables.

**Analysis:** A is right - distributed training scales out time; Spot/preemptible cuts cost ~70%; checkpointing handles preemption. B is the baseline cost. C is computationally infeasible at 1B params. D is for tabular AutoML.

**Answer:** A

**Key takeaway:** Cheap distributed training on Vertex AI = Spot + checkpointing + multi-node. Use TPU pods for very large models if available.

---

## Scenario 4 - Model monitoring (Domain: MLOps)

A deployed model needs alerts when input feature distribution drifts or prediction quality drops.

**Options:** A. Vertex AI Model Monitoring with feature drift + prediction drift jobs; Cloud Monitoring alerts. B. Manual monthly reports. C. Custom Lambda comparing percentiles. D. Cloud Monitoring metrics on infra only.

**Analysis:** A is right - Model Monitoring is purpose-built for drift detection on Vertex Endpoints. B is reactive. C reinvents the tool. D misses model-level drift.

**Answer:** A

**Key takeaway:** Vertex AI Model Monitoring detects: training-serving skew, prediction drift, feature attribution drift. Configure baselines, thresholds, and alert routes.

---

## Scenario 5 - Hyperparameter tuning (Domain: Modeling)

A team has 6 hyperparameters and 100-run budget. They want maximum quality.

**Options:** A. Vertex AI Vizier with Bayesian optimization. B. Random search with 100 runs. C. Grid search. D. Manual tuning.

**Analysis:** A is right - Vizier (the GCP HPT service) uses Bayesian optimization (default) or Grid/Random. Bayesian is sample-efficient for moderate budgets. B is less efficient. C is infeasible at 6 dims. D doesn't scale.

**Answer:** A

**Key takeaway:** Vertex AI Vizier = HPT service. Bayesian default; supports parallel trials and early stopping (Hyperband-like).

---

## Scenario 6 - Pipeline orchestration (Domain: MLOps)

A team needs reproducible ML pipelines: data prep → train → eval → register → deploy, with conditional logic and observability.

**Options:** A. Vertex AI Pipelines with KFP SDK; pipelines triggered on new data via Cloud Functions. B. Cloud Composer DAG calling Vertex AI APIs. C. Custom Cloud Run services chained. D. Manual Jupyter execution.

**Analysis:** A is right - Vertex AI Pipelines (managed Kubeflow Pipelines) is the GCP-native MLOps orchestrator with native ML primitives. B works but Composer is general-purpose; Pipelines is ML-aware. C lacks ML semantics. D isn't reproducible.

**Answer:** A

**Key takeaway:** Vertex AI Pipelines (KFP SDK or TFX) = ML pipelines. Cloud Composer for general ETL. Both can coexist but Pipelines is ML-first.
