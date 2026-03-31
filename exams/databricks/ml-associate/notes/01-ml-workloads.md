# ML Workloads on Databricks - Databricks ML Associate

## Overview

This section covers ML workloads on the Databricks platform, representing 29% of the exam. You need to understand the ML Runtime, MLflow tracking, Model Registry, Feature Store, and AutoML.

**[📖 ML on Databricks](https://docs.databricks.com/en/machine-learning/index.html)** - ML platform overview
**[📖 MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)** - Experiment tracking

## Key Topics

### 1. Databricks ML Runtime

**[📖 ML Runtime](https://docs.databricks.com/en/release-notes/runtime/index.html)** - Runtime versions

**Key Concepts:**
- ML Runtime includes pre-installed libraries: scikit-learn, TensorFlow, PyTorch, XGBoost, LightGBM
- GPU-enabled ML Runtime includes CUDA and GPU-optimized libraries
- Versions align with Databricks Runtime (e.g., 14.3 ML, 15.4 ML)
- Includes MLflow, Hyperopt, and other ML-specific tools pre-configured
- `%pip install` for notebook-scoped additional packages
- Cluster libraries install packages for all notebooks on the cluster

### 2. MLflow Tracking

MLflow is the backbone of ML lifecycle management on Databricks. Tracking records experiments, parameters, metrics, and artifacts.

**[📖 MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)** - Tracking overview
**[📖 Autologging](https://docs.databricks.com/en/mlflow/databricks-autologging.html)** - Automatic logging

**Core APIs:**
```python
import mlflow

# Start a run and log manually
with mlflow.start_run(run_name="my_experiment"):
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("n_estimators", 100)
    mlflow.log_metric("accuracy", 0.95)
    mlflow.log_metric("f1_score", 0.93)
    mlflow.log_artifact("confusion_matrix.png")
    mlflow.sklearn.log_model(model, "model")

# Autologging - automatically logs params, metrics, and model
mlflow.autolog()
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)
```

**Key Concepts:**
- Experiments organize related runs (training iterations)
- Runs track parameters, metrics, artifacts, and models
- Parameters are inputs (learning_rate, n_estimators)
- Metrics are outputs (accuracy, RMSE, F1 score)
- Artifacts are files (plots, data samples, serialized models)
- Autologging works with: sklearn, TensorFlow, PyTorch, XGBoost, LightGBM, Spark
- Nested runs organize hyperparameter tuning hierarchies
- Experiment comparison UI enables side-by-side run comparison

### 3. MLflow Model Registry

**[📖 Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Model lifecycle
**[📖 Models in UC](https://docs.databricks.com/en/mlflow/models-in-uc.html)** - Unity Catalog models

**Registering Models:**
```python
# Register from a run
mlflow.register_model("runs:/run_id/model", "catalog.schema.model_name")

# Register during logging
with mlflow.start_run():
    mlflow.sklearn.log_model(model, "model",
        registered_model_name="catalog.schema.my_model")
```

**Key Concepts:**
- Unity Catalog Model Registry (recommended): `models:/catalog.schema.model_name/version`
- Workspace Model Registry (legacy): `models:/model_name/stage`
- Model versions are created each time a model is registered
- Model aliases (e.g., `champion`, `challenger`) replace stage transitions
- Model descriptions and tags provide documentation
- Permissions control who can register, view, and deploy models

### 4. Feature Store

**[📖 Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature management
**[📖 Feature Engineering](https://docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html)** - Feature APIs

```python
from databricks.feature_engineering import FeatureEngineeringClient, FeatureLookup

fe = FeatureEngineeringClient()

# Create a feature table
fe.create_table(
    name="catalog.schema.customer_features",
    primary_keys=["customer_id"],
    df=features_df,
    description="Customer behavioral features"
)

# Write features
fe.write_table(name="catalog.schema.customer_features", df=new_features)

# Create training set with feature lookups
training_set = fe.create_training_set(
    df=labels_df,
    feature_lookups=[
        FeatureLookup(table_name="catalog.schema.customer_features",
                      lookup_key="customer_id")
    ],
    label="churn"
)
training_df = training_set.load_df()
```

**Key Concepts:**
- Feature tables are Delta tables with a primary key
- Centralized feature computation avoids duplication across teams
- Feature lookups automatically join features at training and inference time
- Feature serving enables real-time inference with low-latency feature access
- Point-in-time lookups prevent target leakage in time-series features

### 5. AutoML

**[📖 AutoML](https://docs.databricks.com/en/machine-learning/automl/index.html)** - Automated ML

```python
import databricks.automl

# Classification
summary = databricks.automl.classify(train_df, target_col="label", timeout_minutes=30)

# Regression
summary = databricks.automl.regress(train_df, target_col="price", timeout_minutes=30)

# Forecasting
summary = databricks.automl.forecast(train_df, target_col="sales",
    time_col="date", timeout_minutes=30)
```

**Key Concepts:**
- AutoML automatically trains and tunes multiple model types
- Supports classification, regression, and time-series forecasting
- Generates editable notebooks for each trial (transparent, not a black box)
- Performs automatic feature engineering and preprocessing
- Provides a model leaderboard ranked by evaluation metric
- Good for establishing baseline models quickly
- All runs are logged to MLflow for comparison and reproducibility

## Exam Tips for This Domain

1. **MLflow tracking APIs** - Know log_param, log_metric, log_artifact, log_model
2. **Autologging** - Know which frameworks support it and what gets logged
3. **Model Registry** - Unity Catalog models vs workspace models
4. **Feature Store** - create_table, write_table, create_training_set workflow
5. **AutoML** - Know capabilities (classify, regress, forecast) and limitations
6. **ML Runtime** - Understand included libraries and GPU runtime options

## Documentation Links Summary

| Topic | Link |
|-------|------|
| ML on Databricks | [docs.databricks.com/en/machine-learning/index.html](https://docs.databricks.com/en/machine-learning/index.html) |
| MLflow Tracking | [docs.databricks.com/en/mlflow/tracking.html](https://docs.databricks.com/en/mlflow/tracking.html) |
| Autologging | [docs.databricks.com/en/mlflow/databricks-autologging.html](https://docs.databricks.com/en/mlflow/databricks-autologging.html) |
| Model Registry | [docs.databricks.com/en/mlflow/model-registry.html](https://docs.databricks.com/en/mlflow/model-registry.html) |
| Feature Store | [docs.databricks.com/en/machine-learning/feature-store/index.html](https://docs.databricks.com/en/machine-learning/feature-store/index.html) |
| AutoML | [docs.databricks.com/en/machine-learning/automl/index.html](https://docs.databricks.com/en/machine-learning/automl/index.html) |
