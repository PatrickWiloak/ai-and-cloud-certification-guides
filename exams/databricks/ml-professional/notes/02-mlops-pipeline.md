# MLOps Pipeline - Databricks ML Professional

## Overview

This section covers MLOps and ML pipeline orchestration, representing the largest domain at 30% of the exam. You need to master production ML pipelines, CI/CD patterns, model lifecycle management, and A/B testing.

**[📖 Databricks Workflows](https://docs.databricks.com/en/workflows/index.html)** - Job orchestration
**[📖 Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** - Deployment bundles

## Key Topics

### 1. Production ML Pipeline Design

**Multi-Step ML Pipeline:**
```
Data Ingestion -> Feature Engineering -> Model Training -> Model Evaluation -> Model Registration -> Model Deployment
```

**Key Concepts:**
- Each step should be a separate task in a Databricks Workflow
- Tasks communicate through task values or shared storage (Delta tables)
- Pipelines should be idempotent - re-running produces the same result
- Separate pipelines for training (periodic) and inference (continuous or scheduled)
- Version everything: data, code, model, environment

### 2. CI/CD for ML

**[📖 Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** - Infrastructure as code

**Environment Promotion Pattern:**
| Environment | Purpose | Activities |
|-------------|---------|------------|
| Dev | Experimentation | Interactive notebooks, MLflow tracking |
| Staging | Validation | Automated tests, model validation |
| Production | Serving | Approved model deployment, monitoring |

**Key Concepts:**
- Databricks Asset Bundles package code, configuration, and infrastructure together
- Git-based development with branch protection and code review
- Automated testing on PR merge: unit tests, integration tests, model validation
- Model promotion requires passing validation gates
- Infrastructure-as-code for reproducible environments

### 3. Model Lifecycle Management

**[📖 Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Model lifecycle
**[📖 Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving endpoints

**Model Aliases:**
```python
from mlflow import MlflowClient
client = MlflowClient()

# Set alias for production model
client.set_registered_model_alias("catalog.schema.model", "champion", version=5)

# Load model by alias
model = mlflow.pyfunc.load_model("models:/catalog.schema.model@champion")
```

**Key Concepts:**
- Model aliases replace stage transitions (champion, challenger, etc.)
- Each registration creates a new version with metadata and tags
- Webhooks trigger automated actions on model events (registration, alias changes)
- Model lineage tracks data, code, and environment dependencies
- Model signatures define input/output schemas for validation
- Model packaging includes conda environment and pip requirements

### 4. Model Validation Gates

```python
def validate_model(model_uri, test_data):
    model = mlflow.pyfunc.load_model(model_uri)
    predictions = model.predict(test_data)

    # Accuracy threshold
    accuracy = calculate_accuracy(predictions, test_data["label"])
    assert accuracy > 0.85, f"Accuracy {accuracy} below threshold"

    # Latency check
    start = time.time()
    model.predict(test_data.head(100))
    latency = (time.time() - start) / 100
    assert latency < 0.01, f"Latency {latency}s exceeds 10ms threshold"

    # Input schema validation
    assert model.metadata.signature is not None, "Model signature required"
```

**Key Concepts:**
- Validation gates prevent bad models from reaching production
- Check accuracy, latency, fairness, and input/output schema
- Compare new model performance against current champion
- Automated validation in CI/CD pipeline
- Manual approval gates for high-risk deployments

### 5. A/B Testing

**Key Concepts:**
- Traffic splitting between model versions (e.g., 90% champion, 10% challenger)
- Statistical significance testing to determine if the challenger is better
- Champion/challenger pattern for safe model rollouts
- Gradual rollout: start with small traffic percentage, increase if metrics are good
- Endpoint traffic configuration in Model Serving

```python
# Configure traffic split on serving endpoint
endpoint_config = {
    "served_models": [
        {"model_name": "my_model", "model_version": "5", "workload_size": "Small", "scale_to_zero_enabled": True, "traffic_percentage": 90},
        {"model_name": "my_model", "model_version": "6", "workload_size": "Small", "scale_to_zero_enabled": True, "traffic_percentage": 10}
    ]
}
```

### 6. Automated Retraining

**Trigger Types:**
| Trigger | When to Use |
|---------|-------------|
| Scheduled | Regular retraining (daily, weekly) regardless of performance |
| Drift-based | Retrain when data or concept drift is detected |
| Performance-based | Retrain when model accuracy drops below threshold |
| Event-based | Retrain when new labeled data becomes available |

**Key Concepts:**
- Schedule retraining pipelines as Databricks Workflows
- Monitor model performance to trigger on-demand retraining
- Automated pipelines should include validation before deployment
- Track retraining lineage: which data was used for each model version

### 7. Custom MLflow Models (PyFunc)

**[📖 Custom PyFunc](https://mlflow.org/docs/latest/python_api/mlflow.pyfunc.html)** - Custom model flavors

```python
class EnsembleModel(mlflow.pyfunc.PythonModel):
    def load_context(self, context):
        self.model_a = mlflow.sklearn.load_model(context.artifacts["model_a"])
        self.model_b = mlflow.sklearn.load_model(context.artifacts["model_b"])

    def predict(self, context, model_input):
        pred_a = self.model_a.predict(model_input)
        pred_b = self.model_b.predict(model_input)
        return (pred_a + pred_b) / 2  # Average ensemble

# Log custom model
mlflow.pyfunc.log_model(
    artifact_path="ensemble",
    python_model=EnsembleModel(),
    artifacts={"model_a": model_a_uri, "model_b": model_b_uri},
    pip_requirements=["scikit-learn", "mlflow"]
)
```

**Key Concepts:**
- `PythonModel` base class for custom inference logic
- `load_context()` loads resources once (models, config files)
- `predict()` runs inference on each batch
- Use for ensembles, preprocessing pipelines, or multi-step inference
- Package dependencies with `conda_env` or `pip_requirements`
- Model signature defines expected input/output schema

## Exam Tips for This Domain

1. **MLOps is 30% of the exam** - invest the most study time here
2. **CI/CD patterns** - Know the dev/staging/production promotion workflow
3. **Custom pyfunc models** - Understand load_context and predict methods
4. **A/B testing** - Traffic splitting and statistical significance
5. **Model aliases** - Replace legacy stage transitions (champion, challenger)
6. **Validation gates** - Accuracy, latency, schema checks before promotion
7. **Asset Bundles** - Package code and config for deployment

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Workflows | [docs.databricks.com/en/workflows/index.html](https://docs.databricks.com/en/workflows/index.html) |
| Asset Bundles | [docs.databricks.com/en/dev-tools/bundles/index.html](https://docs.databricks.com/en/dev-tools/bundles/index.html) |
| Model Registry | [docs.databricks.com/en/mlflow/model-registry.html](https://docs.databricks.com/en/mlflow/model-registry.html) |
| Model Serving | [docs.databricks.com/en/machine-learning/model-serving/index.html](https://docs.databricks.com/en/machine-learning/model-serving/index.html) |
| Custom PyFunc | [mlflow.org/docs/latest/python_api/mlflow.pyfunc.html](https://mlflow.org/docs/latest/python_api/mlflow.pyfunc.html) |
