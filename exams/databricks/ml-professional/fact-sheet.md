# Databricks Machine Learning Professional - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Machine Learning Professional
**Duration:** 120 minutes
**Questions:** 60 multiple-choice questions
**Passing Score:** 70% (approximately 42 correct)
**Cost:** $300 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/machine-learning-professional)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - Professional ML learning paths
**[📖 MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - Complete MLflow reference

## Target Audience

This certification is designed for:
- Senior ML engineers managing production ML systems
- Data scientists transitioning to MLOps roles
- ML platform engineers building ML infrastructure
- Professionals with 2+ years of ML experience on Databricks
- Engineers responsible for model deployment and monitoring

## Domain 1: Feature Engineering (20%)

### Feature Store Architecture

**[📖 Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature Store overview
**[📖 Feature Engineering Client](https://docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html)** - Feature engineering APIs
**[📖 Online Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/online-tables.html)** - Real-time feature serving
**[📖 Point-in-Time Lookups](https://docs.databricks.com/en/machine-learning/feature-store/time-series.html)** - Time-series features

**Key Facts:**
- Offline Feature Store: Delta tables for batch training and inference
- Online Feature Store: low-latency serving for real-time inference
- Point-in-time lookups: prevent target leakage in time-series features
- `timestamp_lookup_key` ensures features are as-of the label timestamp
- Feature tables registered in Unity Catalog for governance
- Feature freshness monitoring tracks staleness
- Scheduled feature computation pipelines
- Cross-table feature joins with automatic key matching

### Advanced Feature Engineering

**Key Facts:**
- Time-series features: rolling windows, lag features, seasonal decomposition
- Text features: TF-IDF, word embeddings, tokenization
- Interaction features: polynomial features, cross-products
- Feature selection: mutual information, L1 regularization, recursive elimination
- Feature importance: permutation importance, SHAP values
- Handling high-cardinality categoricals: target encoding, hashing
- Feature transformation pipelines for reproducibility
- Feature versioning with Delta Lake

## Domain 2: MLOps and ML Pipeline (30%)

### Production ML Pipelines

**[📖 Databricks Workflows](https://docs.databricks.com/en/workflows/index.html)** - Job orchestration
**[📖 Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** - Deployment bundles
**[📖 Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Model lifecycle
**[📖 Webhooks](https://docs.databricks.com/en/mlflow/model-registry-webhooks.html)** - Model event automation

**Key Facts:**
- Multi-step ML pipelines: data prep -> feature engineering -> training -> evaluation -> registration
- Databricks Workflows for pipeline orchestration with dependencies
- Databricks Asset Bundles: package code, config, and infrastructure together
- CI/CD patterns:
  - Dev: experiment in notebooks, log to MLflow
  - Staging: automated testing, model validation
  - Production: approved model deployment
- Model validation gates before promotion
- Automated retraining triggers based on drift or schedule

### Model Lifecycle Management

**[📖 MLflow Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Registry features
**[📖 Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving endpoints

**Key Facts:**
- Unity Catalog Model Registry: enterprise governance for models
- Model versions with metadata, tags, and descriptions
- Stage transitions with approval workflows
- Webhooks for automated actions on model events
- Model aliases: `champion`, `challenger` for production routing
- Model lineage: track data, code, and environment dependencies
- Reproducibility: log environment, data version, and code version
- Model packaging: conda environment, requirements, and signatures

### A/B Testing

**Key Facts:**
- Traffic splitting between model versions
- Statistical significance testing for model comparison
- Champion/challenger pattern for safe rollouts
- Gradual rollout strategies (canary deployment)
- Endpoint traffic configuration for version routing
- Metrics comparison framework for model versions
- Rollback procedures for failed deployments

## Domain 3: Advanced ML (25%)

### Advanced Hyperparameter Tuning

**[📖 Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)** - Distributed tuning
**[📖 Optuna Integration](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/optuna.html)** - Optuna on Databricks

**Key Facts:**
- Hyperopt with `SparkTrials`: distributed Bayesian optimization
- Tree-structured Parzen Estimator (TPE) for efficient search
- Early stopping: terminate unpromising trials
- Nested cross-validation for robust hyperparameter selection
- Multi-objective optimization
- Warm-starting from previous tuning runs
- Hyperopt `fmin` with conditional search spaces
- Optuna: alternative framework with pruning and visualization

### Distributed Training

**[📖 TorchDistributor](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html)** - PyTorch distributed
**[📖 DeepSpeed](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/deepspeed.html)** - Large model training
**[📖 Horovod](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/horovod-runner.html)** - Horovod integration

**Key Facts:**
- Data parallelism: replicate model, split data across workers
- Model parallelism: split model across workers (for very large models)
- TorchDistributor: native PyTorch distributed training on Databricks
- DeepSpeed: memory-efficient training for large models (ZeRO optimizer)
- Horovod: framework-agnostic distributed training
- `HorovodRunner(np=num_workers)` for multi-node training
- Mixed precision training: float16 for faster training with less memory
- Gradient accumulation for effective large batch sizes

### Custom MLflow Models

**[📖 Custom PyFunc](https://mlflow.org/docs/latest/python_api/mlflow.pyfunc.html)** - Custom model flavors

**Key Facts:**
- `mlflow.pyfunc.PythonModel` base class for custom models
- Override `predict()` method for custom inference logic
- Override `load_context()` for loading additional resources
- Use for ensemble models, preprocessing pipelines, or custom logic
- Package custom dependencies with `conda_env` or `pip_requirements`
- Model signature: defines input/output schema
- Input example: sample data for documentation and testing

## Domain 4: Deployment and Serving (15%)

### Model Serving Endpoints

**[📖 Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving overview
**[📖 Serverless Serving](https://docs.databricks.com/en/machine-learning/model-serving/create-manage-serving-endpoints.html)** - Endpoint management
**[📖 Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)** - Request logging

**Key Facts:**
- Serverless Model Serving: fully managed, auto-scaling endpoints
- Provisioned throughput: dedicated compute for predictable latency
- Endpoint configuration: model version, compute size, scale-to-zero
- Traffic routing: split traffic between model versions
- Authentication: API keys, OAuth tokens
- REST API for predictions: POST to endpoint URL with JSON payload
- Batch inference: use Spark with `mlflow.pyfunc.spark_udf()`
- Streaming inference: apply model UDF to streaming DataFrame
- Inference tables: automatic logging of requests and responses

### Deployment Patterns

**Key Facts:**
- Blue/green deployment: two identical environments, switch traffic
- Canary deployment: route small percentage of traffic to new model
- Shadow deployment: run new model in parallel without serving results
- Feature flags for model version control
- Rollback strategy: revert to previous model version
- Health checks and circuit breakers for endpoint reliability
- Load testing before production deployment
- Latency budgets and SLA management

## Domain 5: Monitoring (10%)

### Drift Detection

**[📖 Lakehouse Monitoring](https://docs.databricks.com/en/lakehouse-monitoring/index.html)** - Data and model monitoring
**[📖 Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)** - Logging predictions

**Key Facts:**
- Data drift: input feature distributions change over time
- Concept drift: relationship between features and target changes
- Statistical tests for drift: KS test, chi-squared, PSI
- Population Stability Index (PSI): measures distribution shift
- Lakehouse Monitoring: automated profiling and drift detection
- Monitor profiles: time-series of table statistics
- Custom metrics: define domain-specific monitoring metrics
- Drift alerts: trigger retraining or human review

### Model Performance Monitoring

**Key Facts:**
- Inference table logging: capture inputs, outputs, timestamps
- Ground truth joins: match predictions with actual outcomes
- Performance dashboards: track accuracy, latency, throughput
- Alert thresholds: trigger notifications on performance degradation
- Retraining triggers: scheduled, drift-based, or performance-based
- Feature importance monitoring: track feature contribution changes
- Data quality monitoring: missing values, outliers, schema changes
- Cost monitoring: track serving compute costs

## Exam Tips

1. **MLOps is the largest domain** at 30% - master pipeline orchestration and CI/CD
2. **Feature Store** - understand online/offline stores and point-in-time correctness
3. **Custom pyfunc models** - know how to implement and package custom models
4. **A/B testing** - understand traffic splitting and statistical significance
5. **Drift detection** - know the difference between data drift and concept drift
6. **Distributed training** - TorchDistributor, Horovod, DeepSpeed patterns
7. **Model serving** - serverless vs provisioned, autoscaling, inference tables
8. **Deployment patterns** - canary, blue/green, shadow deployments
9. **End-to-end thinking** - questions test holistic ML system design
10. **Production focus** - every answer should consider reliability and scale

## Quick Reference

### Essential Code Patterns
```python
# Feature Store with Point-in-Time
from databricks.feature_engineering import FeatureEngineeringClient, FeatureLookup
fe = FeatureEngineeringClient()
training_set = fe.create_training_set(
    df=labels_df,
    feature_lookups=[FeatureLookup(table_name="catalog.schema.features",
                                    lookup_key="id",
                                    timestamp_lookup_key="event_timestamp")],
    label="target"
)

# Custom PyFunc Model
class CustomModel(mlflow.pyfunc.PythonModel):
    def load_context(self, context):
        self.model = load_model(context.artifacts["model_path"])
    def predict(self, context, model_input):
        return self.model.predict(model_input)

# Model Serving Endpoint
import requests
response = requests.post(
    f"https://{workspace_url}/serving-endpoints/{endpoint}/invocations",
    headers={"Authorization": f"Bearer {token}"},
    json={"dataframe_records": [{"feature1": 1.0, "feature2": "a"}]}
)

# Lakehouse Monitoring
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()
w.quality_monitors.create(
    table_name="catalog.schema.predictions",
    output_schema_name="catalog.schema",
    time_series={"timestamp_col": "timestamp", "granularities": ["1 day"]}
)
```
