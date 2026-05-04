---
last-updated: 2026-05-03
---

# GCP Professional Machine Learning Engineer (PMLE) - Exam Strategy

## Format reminder

- 50-60 questions, 120 minutes
- Pass mark ~70-75%
- Multiple choice + multiple response

## Top traps

1. **GCP ML service ladder**: pre-trained APIs (Vision, NL, Speech, Translate, Document AI) → AutoML (your data, no code) → custom training on Vertex AI → on-prem / Anthos. Climb only when needed.

2. **Vertex AI vs legacy AI Platform**: Vertex AI is the unified platform (renamed in 2021). AI Platform is legacy. Pick Vertex AI in modern questions.

3. **AutoML vs Custom Training on Vertex**: AutoML for tabular / image / text / video without writing model code. Custom for full control with TensorFlow / PyTorch / XGBoost / scikit-learn.

4. **Feature Store**: solves training-serving skew. Online store for low-latency serving (Bigtable-backed). Offline store for training (BigQuery-backed). Sync between them.

5. **Model Monitoring**: training-serving skew, prediction drift, feature attribution drift. Configure thresholds + alerts.

6. **Vizier (HPT service)**: Bayesian, Grid, Random; supports parallel trials and early stopping.

7. **Pipelines**: KFP SDK or TFX. Reproducible, parameterizable, conditional execution.

8. **TPUs vs GPUs**:
   - TPUs: best for large transformer models on TensorFlow / JAX (and now PyTorch via XLA)
   - GPUs (A100, H100, L4): general-purpose ML
   Pick TPU for large-scale training that fits the TF/JAX ecosystem.

9. **Explainability**: Vertex AI Explainable AI provides feature attribution (Sampled Shapley, Integrated Gradients, XRAI for images). For regulated workloads.

10. **Endpoints vs batch prediction**: Endpoints for sync low-latency. Batch for offline scoring at scale (Dataflow under the hood).

## High-yield topics easy to miss

- Vertex AI Search (RAG-as-a-service)
- Vertex AI Agent Builder (no-code agents)
- Generative AI Studio (foundation model playground)
- Vertex AI Workbench (managed Jupyter)
- Vertex AI Notebooks Executor (scheduled notebooks)
- Custom Container Training (BYO Docker image)
- Reduced-precision training (BF16 on TPU, FP16 on GPU)
- DataPlex for data governance + lineage

## Time management

120 / ~55 = ~2.2 min/question. Pace: half done by minute 60.

## When stuck

1. **Identify the problem type** - tabular / image / text / time series.
2. **Match to the right service** - AutoML for fast, custom for control, pre-trained for off-the-shelf.
3. **Default to managed Vertex AI services** over custom infrastructure.
4. **Eliminate "build it from scratch"** when an MLOps service exists.

## Day-of logistics

120 min, ~55 questions. Bring two IDs.

## After

**Pass:** Cert valid 2 years.

**Fail:** Most failures are on Modeling (~25%) or MLOps (~25%). Re-review Vertex AI components, Feature Store, Model Monitoring.

## PMLE patterns

- "Off-the-shelf NLP / vision / speech" = pre-trained API
- "Tabular / image classification, no code" = AutoML
- "Custom model with full control" = Vertex AI custom training
- "Training-serving skew" = Vertex AI Feature Store
- "Drift monitoring" = Vertex AI Model Monitoring
- "HPT" = Vertex AI Vizier
- "Reproducible pipelines" = Vertex AI Pipelines (KFP)
- "Cheap large-scale training" = Spot + checkpointing + distributed
- "Per-prediction explanation" = Vertex AI Explainable AI
- "Foundation model + RAG" = Vertex AI Search + Generative AI Studio
