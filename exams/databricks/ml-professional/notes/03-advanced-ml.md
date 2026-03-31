# Advanced ML - Databricks ML Professional

## Overview

This section covers advanced ML techniques, representing 25% of the exam. You need to master advanced hyperparameter tuning, distributed training, custom MLflow models, and ensemble methods.

**[📖 Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)** - Distributed tuning
**[📖 Distributed Training](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html)** - Distributed DL

## Key Topics

### 1. Advanced Hyperparameter Tuning

**[📖 Hyperopt Concepts](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/hyperopt-concepts.html)** - Advanced Hyperopt

**Conditional Search Spaces:**
```python
from hyperopt import hp

space = hp.choice("model_type", [
    {"type": "rf", "n_estimators": hp.choice("rf_n", [100, 200, 500]),
     "max_depth": hp.quniform("rf_depth", 3, 20, 1)},
    {"type": "xgb", "n_estimators": hp.choice("xgb_n", [100, 200, 500]),
     "learning_rate": hp.loguniform("xgb_lr", -5, 0)}
])
```

**Key Concepts:**
- Conditional search spaces define different parameters per model type
- Early stopping terminates unpromising trials to save compute
- Nested cross-validation: outer loop for model evaluation, inner for tuning
- Warm-starting reuses results from previous tuning runs
- `SparkTrials(parallelism=N)` runs N trials simultaneously across workers
- Higher parallelism means faster total time but less informed search

### 2. Distributed Training

**[📖 TorchDistributor](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html)** - PyTorch distributed
**[📖 DeepSpeed](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/deepspeed.html)** - Large model training

**Data Parallelism:**
- Replicate the full model to each worker
- Split training data across workers
- Each worker computes gradients on its data subset
- Gradients are averaged (all-reduce) across workers
- Most common approach; works when model fits on one GPU

**Model Parallelism:**
- Split the model itself across multiple workers
- Each worker holds a portion of the model layers
- Required for very large models that do not fit on one GPU
- More complex to implement than data parallelism

**DeepSpeed ZeRO:**
- Memory-efficient distributed training
- ZeRO Stage 1: partition optimizer states
- ZeRO Stage 2: partition gradients
- ZeRO Stage 3: partition model parameters
- Enables training models that would not fit on a single GPU

**Mixed Precision Training:**
- Use float16 for forward/backward pass (faster, less memory)
- Keep float32 master weights for numerical stability
- 2x memory savings and faster computation on modern GPUs
- Gradient accumulation simulates larger batch sizes

### 3. Ensemble Methods

**Common Ensemble Approaches:**
| Method | Description | When to Use |
|--------|-------------|-------------|
| Bagging | Train same model on random subsets (Random Forest) | Reduce variance |
| Boosting | Sequentially train models on residuals (XGBoost, GBT) | Reduce bias |
| Stacking | Train meta-model on base model predictions | Maximum accuracy |
| Averaging | Average predictions from multiple models | Simple improvement |
| Weighted averaging | Weighted combination based on model quality | Fine-tuned improvement |

**Custom Ensemble with PyFunc:**
```python
class StackedModel(mlflow.pyfunc.PythonModel):
    def load_context(self, context):
        self.base_models = [
            mlflow.sklearn.load_model(context.artifacts[f"model_{i}"])
            for i in range(3)
        ]
        self.meta_model = mlflow.sklearn.load_model(context.artifacts["meta"])

    def predict(self, context, model_input):
        base_preds = np.column_stack([
            m.predict(model_input) for m in self.base_models
        ])
        return self.meta_model.predict(base_preds)
```

### 4. Advanced Model Architectures

**Key Concepts:**
- Transformer models for NLP tasks (BERT, GPT, T5)
- Fine-tuning pre-trained models on domain-specific data
- Hugging Face integration for model loading and fine-tuning
- Multi-task learning: one model solves multiple related tasks
- Graph neural networks for relational data

### 5. Experiment Design

**Key Concepts:**
- Ablation studies: systematically remove features or components to measure impact
- Statistical significance: ensure results are not due to random chance
- Reproducibility: set random seeds, log environments, version data
- Experiment logging: track every decision for future reference
- Baseline comparisons: always compare against a simple baseline

## Exam Tips for This Domain

1. **Distributed training patterns** - Data parallelism vs model parallelism
2. **DeepSpeed** - ZeRO stages for memory-efficient training
3. **Advanced Hyperopt** - Conditional spaces, early stopping, warm-starting
4. **Custom pyfunc ensembles** - Implement stacking and averaging with MLflow
5. **Mixed precision** - float16 for speed and memory savings
6. **TorchDistributor** - Native PyTorch distribution on Databricks

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Hyperopt | [docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html) |
| TorchDistributor | [docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html) |
| DeepSpeed | [docs.databricks.com/en/machine-learning/deep-learning/distributed-training/deepspeed.html](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/deepspeed.html) |
| Horovod | [docs.databricks.com/en/machine-learning/deep-learning/distributed-training/horovod-runner.html](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/horovod-runner.html) |
