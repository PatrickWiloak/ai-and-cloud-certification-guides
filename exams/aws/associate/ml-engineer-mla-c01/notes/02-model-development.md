# ML Model Development (Domain 2 - 26%)

## Overview

This domain covers selecting algorithms, training models, tuning hyperparameters, and evaluating model performance using AWS services.

**📖 [Train Models](https://docs.aws.amazon.com/sagemaker/latest/dg/train-model.html)** - SageMaker training guide

---

## SageMaker Built-in Algorithms

SageMaker provides optimized implementations of common ML algorithms. Know when to use each.

### Supervised Learning — Classification & Regression

| Algorithm | Type | Use Case |
|-----------|------|----------|
| **XGBoost** | Gradient boosted trees | Tabular data, classification, regression (most versatile) |
| **Linear Learner** | Linear/logistic models | Binary/multiclass classification, regression |
| **KNN** | Instance-based | Classification, regression (small-medium datasets) |
| **Factorization Machines** | Matrix factorization | Recommendations, sparse data, click prediction |

**📖 [XGBoost Algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost.html)**
**📖 [Linear Learner](https://docs.aws.amazon.com/sagemaker/latest/dg/linear-learner.html)**

### Supervised Learning — NLP

| Algorithm | Use Case |
|-----------|----------|
| **BlazingText** | Text classification (supervised mode), Word2Vec (unsupervised mode) |
| **Sequence-to-Sequence** | Machine translation, text summarization |

**📖 [BlazingText](https://docs.aws.amazon.com/sagemaker/latest/dg/blazingtext.html)**

### Supervised Learning — Computer Vision

| Algorithm | Use Case |
|-----------|----------|
| **Image Classification** | Classify images into categories |
| **Object Detection** | Detect and locate objects in images |
| **Semantic Segmentation** | Pixel-level classification of images |

### Unsupervised Learning

| Algorithm | Use Case |
|-----------|----------|
| **K-Means** | Clustering |
| **PCA** | Dimensionality reduction |
| **Random Cut Forest** | Anomaly detection |
| **IP Insights** | Detect anomalous IP usage patterns |
| **LDA** | Topic modeling for text |
| **NTM** | Neural topic modeling |

**📖 [Random Cut Forest](https://docs.aws.amazon.com/sagemaker/latest/dg/randomcutforest.html)** - Anomaly detection

### Time Series

| Algorithm | Use Case |
|-----------|----------|
| **DeepAR** | Forecasting multiple related time series |

---

## SageMaker Training Jobs

### Key Configuration
- **Algorithm source**: Built-in algorithm, custom container, or pre-built framework container
- **Instance type**: ml.m5 (general), ml.c5 (compute), ml.p3/p4 (GPU), ml.g5 (GPU)
- **Instance count**: 1 for single-instance, >1 for distributed training
- **Input data**: S3 paths with channel names (train, validation, test)
- **Hyperparameters**: Algorithm-specific tuning parameters
- **Output**: Model artifacts saved to S3

### Training Input Modes
- **File Mode**: Downloads entire dataset to instance storage before training
- **Pipe Mode**: Streams data directly from S3 (faster start, lower disk usage)
- **FastFile Mode**: POSIX-like access to S3 (streams on demand)

### Cost Optimization
- **Managed Spot Training**: Use EC2 Spot Instances for up to 90% savings
- **Checkpointing**: Save progress to resume after Spot interruptions
- **Right-sizing**: Choose appropriate instance types for workload
- **Early stopping**: Stop training when metrics plateau

**📖 [Training Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)**
**📖 [Managed Spot Training](https://docs.aws.amazon.com/sagemaker/latest/dg/model-managed-spot-training.html)**

---

## Distributed Training

### Data Parallelism
- Split training data across multiple instances
- Each instance trains on a subset, gradients are synchronized
- Use for: Large datasets with models that fit in single GPU memory
- SageMaker Data Parallel library optimizes gradient synchronization

### Model Parallelism
- Split model across multiple instances/GPUs
- Use for: Models too large for single GPU memory (large language models)
- SageMaker Model Parallel library handles tensor/pipeline parallelism

**📖 [Distributed Training](https://docs.aws.amazon.com/sagemaker/latest/dg/distributed-training.html)**

---

## Hyperparameter Tuning

### SageMaker Automatic Model Tuning
- Runs multiple training jobs with different hyperparameter combinations
- Supports **Bayesian optimization** (recommended), random search, grid search, and Hyperband
- Define hyperparameter ranges (continuous, integer, categorical)
- Specify objective metric to optimize (e.g., validation:accuracy)

### Best Practices
- Start with random search to explore parameter space, then switch to Bayesian
- Set reasonable ranges based on algorithm documentation
- Use **warm start** to continue from previous tuning job results
- Enable **early stopping** to terminate poor-performing jobs
- Limit max concurrent jobs to let Bayesian optimization learn from results

**📖 [Automatic Model Tuning](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning.html)**

---

## SageMaker Autopilot

Automated ML (AutoML) service that automatically:
1. Explores data and selects features
2. Selects algorithms and trains multiple candidates
3. Tunes hyperparameters
4. Ranks models by objective metric

### Key Features
- Supports tabular data (classification and regression)
- Generates notebooks showing candidate pipeline definitions
- Provides model explainability (feature importance)
- Can deploy best model directly to endpoint

### When to Use
- Baseline model creation
- Non-ML-expert teams needing quick models
- Exploring which algorithms work best for your data

**📖 [SageMaker Autopilot](https://docs.aws.amazon.com/sagemaker/latest/dg/autopilot-automate-model-development.html)**

---

## SageMaker Experiments

Track and organize ML experiments across iterations.

### Key Concepts
- **Experiment**: Top-level grouping (e.g., "customer-churn-prediction")
- **Run**: Individual training attempt with specific parameters
- **Parameters**: Hyperparameters and configuration logged per run
- **Metrics**: Training and validation metrics tracked over time
- **Artifacts**: Input data, output models, and other files linked to runs

### Benefits
- Compare runs side-by-side
- Track lineage from data to model
- Reproduce past experiments
- Integrate with SageMaker Pipelines

**📖 [SageMaker Experiments](https://docs.aws.amazon.com/sagemaker/latest/dg/experiments.html)**

---

## SageMaker Debugger

Real-time monitoring and debugging of training jobs.

### Capabilities
- **Built-in rules**: Detect common issues (vanishing gradients, overfitting, loss not decreasing)
- **Custom rules**: Define your own debugging rules
- **Profiling**: Monitor hardware utilization (CPU, GPU, memory, I/O)
- **Tensor analysis**: Inspect intermediate tensors during training

### Common Issues Detected
- Overfitting (validation loss increasing while training loss decreases)
- Underfitting (both losses remain high)
- Vanishing/exploding gradients
- Class imbalance problems
- Poorly utilized resources

**📖 [SageMaker Debugger](https://docs.aws.amazon.com/sagemaker/latest/dg/train-debugger.html)**

---

## Model Evaluation Metrics

### Classification Metrics
| Metric | Formula | When to Use |
|--------|---------|-------------|
| **Accuracy** | Correct / Total | Balanced classes |
| **Precision** | TP / (TP + FP) | Minimize false positives (spam detection) |
| **Recall** | TP / (TP + FN) | Minimize false negatives (disease detection) |
| **F1 Score** | 2 × (P × R) / (P + R) | Balance precision and recall |
| **AUC-ROC** | Area under ROC curve | Overall model discrimination ability |

### Regression Metrics
| Metric | When to Use |
|--------|-------------|
| **RMSE** | Penalize large errors |
| **MAE** | Robust to outliers |
| **R²** | Proportion of variance explained |
| **MAPE** | Percentage-based error |

---

## Exam Tips for Domain 2

1. **Know the built-in algorithms** — especially XGBoost (most common), Linear Learner, BlazingText, and Random Cut Forest
2. **Understand hyperparameter tuning strategies** — Bayesian is default and recommended
3. **Spot Training** — Always relevant for cost optimization questions
4. **Autopilot vs manual training** — Autopilot for quick baselines; manual for production optimization
5. **Data parallel vs model parallel** — Data parallel for large datasets, model parallel for large models
