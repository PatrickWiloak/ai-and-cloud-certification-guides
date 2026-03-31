# ML Workflow - Databricks ML Associate

## Overview

This section covers the ML workflow including data preparation, hyperparameter tuning, and model evaluation, representing 29% of the exam. You need to understand data splits, feature engineering, Hyperopt, and evaluation metrics.

**[📖 Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)** - Distributed tuning
**[📖 Model Evaluation](https://docs.databricks.com/en/machine-learning/model-evaluation.html)** - Evaluation techniques

## Key Topics

### 1. Data Preparation

**[📖 Pandas API on Spark](https://docs.databricks.com/en/pandas/pandas-on-spark.html)** - Scalable pandas

**Train/Test Split:**
```python
# Random split
train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)

# Stratified split (for imbalanced datasets)
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42)
```

**Key Concepts:**
- Typical split: 70-80% training, 20-30% testing
- Use a validation set (or cross-validation) for hyperparameter tuning
- Stratified split preserves class distribution in imbalanced datasets
- Always set a random seed for reproducibility
- Never use test data during training or hyperparameter tuning

### 2. Feature Engineering

**Missing Value Handling:**
| Strategy | When to Use |
|----------|-------------|
| Mean/median imputation | Numerical features, data is roughly symmetric |
| Mode imputation | Categorical features |
| Drop rows | Small number of missing values, data is plentiful |
| Indicator column | Missingness itself is informative |

**Categorical Encoding:**
| Method | When to Use |
|--------|-------------|
| One-hot encoding | Low cardinality (< 20 categories) |
| Label encoding | Ordinal categories (low, medium, high) |
| Target encoding | High cardinality categoricals |

**Feature Scaling:**
| Method | Result | When to Use |
|--------|--------|-------------|
| StandardScaler | Zero mean, unit variance | Linear models, neural networks |
| MinMaxScaler | Values in [0, 1] | Features with bounded ranges |
| No scaling needed | Original values | Tree-based models (RF, GBT, XGBoost) |

### 3. Hyperparameter Tuning

**[📖 Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/hyperopt-concepts.html)** - Hyperopt concepts

**Hyperopt Implementation:**
```python
from hyperopt import fmin, tpe, hp, SparkTrials, STATUS_OK
import mlflow

# Define search space
search_space = {
    "n_estimators": hp.choice("n_estimators", [50, 100, 200, 500]),
    "max_depth": hp.quniform("max_depth", 3, 15, 1),
    "learning_rate": hp.loguniform("learning_rate", -5, 0),
}

# Define objective function
def objective(params):
    with mlflow.start_run(nested=True):
        model = XGBClassifier(**params)
        model.fit(X_train, y_train)
        accuracy = model.score(X_val, y_val)
        mlflow.log_metric("accuracy", accuracy)
        return {"loss": -accuracy, "status": STATUS_OK}

# Run distributed tuning
with mlflow.start_run():
    best = fmin(
        fn=objective,
        space=search_space,
        algo=tpe.suggest,
        max_evals=100,
        trials=SparkTrials(parallelism=4)
    )
```

**Search Space Functions:**
| Function | Description | Example |
|----------|-------------|---------|
| `hp.choice` | Choose from a list | `hp.choice("x", [1, 2, 3])` |
| `hp.uniform` | Uniform distribution | `hp.uniform("x", 0, 1)` |
| `hp.loguniform` | Log-uniform distribution | `hp.loguniform("x", -5, 0)` |
| `hp.quniform` | Quantized uniform (integers) | `hp.quniform("x", 1, 10, 1)` |

**Tuning Approaches:**
| Method | How It Works | Efficiency |
|--------|-------------|------------|
| Grid search | Try all combinations | Exhaustive but slow |
| Random search | Random sampling | Often more efficient than grid |
| Bayesian (Hyperopt) | Uses past results to guide search | Most efficient |

**Key Concepts:**
- `SparkTrials` distributes trials across the Spark cluster (one trial per worker)
- `Trials` runs trials on the driver node only (single-node)
- `tpe.suggest` is the Tree-structured Parzen Estimator algorithm
- `max_evals` controls the total number of trials
- Nested MLflow runs keep hyperparameter trials organized under a parent run
- Hyperopt minimizes the loss function - use negative accuracy for maximization

### 4. Cross-Validation

```python
from sklearn.model_selection import cross_val_score

# K-fold cross-validation
scores = cross_val_score(model, X, y, cv=5, scoring="accuracy")
print(f"Mean accuracy: {scores.mean():.3f} (+/- {scores.std():.3f})")
```

**Key Concepts:**
- K-fold cross-validation splits data into k folds, training on k-1 and testing on 1
- Typical values: 5-fold or 10-fold
- More robust than a single train/test split
- Stratified K-fold preserves class distribution in each fold
- Spark MLlib provides CrossValidator and TrainValidationSplit

### 5. Model Evaluation Metrics

**Classification Metrics:**
| Metric | Formula | When to Use |
|--------|---------|-------------|
| Accuracy | Correct / Total | Balanced classes |
| Precision | TP / (TP + FP) | Minimize false positives (spam detection) |
| Recall | TP / (TP + FN) | Minimize false negatives (disease detection) |
| F1 Score | 2 * (P * R) / (P + R) | Balance precision and recall |
| AUC-ROC | Area under ROC curve | Overall model discrimination |
| Log loss | Penalizes confident wrong predictions | Probabilistic predictions |

**Regression Metrics:**
| Metric | Characteristic | When to Use |
|--------|---------------|-------------|
| RMSE | Penalizes large errors | General purpose, sensitive to outliers |
| MAE | Equal weight to all errors | Robust to outliers |
| R-squared | Proportion of variance explained | Comparing models on same dataset |
| MAPE | Percentage error | Business-interpretable metrics |

### 6. Overfitting and Underfitting

| Condition | Training Performance | Test Performance | Solution |
|-----------|---------------------|------------------|----------|
| Overfitting | High | Low | Regularization, more data, simpler model |
| Underfitting | Low | Low | More complex model, more features, less regularization |
| Good fit | High | High (similar to training) | Deploy the model |

**Key Concepts:**
- Overfitting: model memorizes training data but fails on new data (high variance)
- Underfitting: model is too simple to capture patterns (high bias)
- Bias-variance tradeoff: increasing model complexity reduces bias but increases variance
- Regularization (L1, L2) reduces overfitting by penalizing large weights
- Early stopping prevents overfitting in iterative algorithms

## Exam Tips for This Domain

1. **Hyperopt** - Know fmin, search spaces, SparkTrials vs Trials, tpe.suggest
2. **Evaluation metrics** - Know when to use precision vs recall vs F1
3. **Overfitting vs underfitting** - Diagnose from train/test performance gap
4. **Cross-validation** - K-fold for robust evaluation, stratified for imbalanced data
5. **Feature scaling** - Not needed for tree models; required for linear/neural models
6. **SparkTrials parallelism** - Distributes hyperparameter trials across workers

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Hyperopt | [docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html) |
| Hyperopt Concepts | [docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/hyperopt-concepts.html](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/hyperopt-concepts.html) |
| Model Evaluation | [docs.databricks.com/en/machine-learning/model-evaluation.html](https://docs.databricks.com/en/machine-learning/model-evaluation.html) |
| Pandas API on Spark | [docs.databricks.com/en/pandas/pandas-on-spark.html](https://docs.databricks.com/en/pandas/pandas-on-spark.html) |
