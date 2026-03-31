# Hands-On Project: Deploy a Machine Learning Model

Train a simple model and deploy it to a production inference endpoint.

**Estimated Time:** 3-4 hours
**Difficulty:** Intermediate
**Prerequisites:** Python basics, a cloud account, familiarity with ML concepts

---

## Architecture Overview

```
Training Pipeline:
  Data Prep --> Training --> Evaluation --> Model Registry

Inference Pipeline:
  Client Request --> API Endpoint --> Model Server --> Response
                                         |
                                    Model Monitoring
                                    (data drift, performance)
```

---

## Step 1: Prepare Training Data

### Sample Dataset

Using a simple classification problem for demonstration.

```python
# data_prep.py
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import joblib

# Load dataset (example: customer churn prediction)
df = pd.read_csv("data/customers.csv")

# Feature engineering
features = ["tenure", "monthly_charges", "total_charges", "contract_type", "payment_method"]
target = "churn"

# Handle categoricals
df_encoded = pd.get_dummies(df[features], drop_first=True)

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    df_encoded, df[target], test_size=0.2, random_state=42, stratify=df[target]
)

# Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Save scaler for inference
joblib.dump(scaler, "artifacts/scaler.joblib")

print(f"Training set: {X_train.shape[0]} samples")
print(f"Test set: {X_test.shape[0]} samples")
```

---

## Step 2: Train the Model

### Training Script

```python
# train.py
import joblib
import json
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score

# Load prepared data
X_train_scaled = joblib.load("artifacts/X_train_scaled.joblib")
X_test_scaled = joblib.load("artifacts/X_test_scaled.joblib")
y_train = joblib.load("artifacts/y_train.joblib")
y_test = joblib.load("artifacts/y_test.joblib")

# Train model
model = GradientBoostingClassifier(
    n_estimators=100,
    max_depth=5,
    learning_rate=0.1,
    random_state=42
)
model.fit(X_train_scaled, y_train)

# Evaluate
y_pred = model.predict(X_test_scaled)
y_proba = model.predict_proba(X_test_scaled)[:, 1]

metrics = {
    "accuracy": accuracy_score(y_test, y_pred),
    "precision": precision_score(y_test, y_pred),
    "recall": recall_score(y_test, y_pred),
    "f1_score": f1_score(y_test, y_pred),
    "roc_auc": roc_auc_score(y_test, y_proba)
}

print("Model Metrics:")
for k, v in metrics.items():
    print(f"  {k}: {v:.4f}")

# Save model and metrics
joblib.dump(model, "artifacts/model.joblib")
with open("artifacts/metrics.json", "w") as f:
    json.dump(metrics, f, indent=2)
```

---

## Step 3: Register the Model

### AWS SageMaker Model Registry

```python
import boto3
import sagemaker
from sagemaker.model import Model

session = sagemaker.Session()
role = "arn:aws:iam::123456789012:role/SageMakerRole"

# Upload model artifacts to S3
model_data = session.upload_data("artifacts/model.tar.gz", key_prefix="models/churn")

# Register in Model Registry
model_package_group = "ChurnPredictionModels"

sm_client = boto3.client("sagemaker")
sm_client.create_model_package(
    ModelPackageGroupName=model_package_group,
    InferenceSpecification={
        "Containers": [{
            "Image": "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:1.2-1-cpu-py3",
            "ModelDataUrl": model_data
        }],
        "SupportedContentTypes": ["application/json"],
        "SupportedResponseMIMETypes": ["application/json"]
    },
    ModelApprovalStatus="PendingManualApproval"
)
```

**Docs:** https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html

### Azure ML Model Registry

```python
from azure.ai.ml import MLClient
from azure.ai.ml.entities import Model
from azure.identity import DefaultAzureCredential

ml_client = MLClient(DefaultAzureCredential(), "subscription-id", "resource-group", "workspace")

model = ml_client.models.create_or_update(
    Model(
        name="churn-prediction",
        path="artifacts/model.joblib",
        type="custom_model",
        description="Customer churn prediction model"
    )
)
```

**Docs:** https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-models

### GCP Vertex AI Model Registry

```bash
gcloud ai models upload \
  --region us-central1 \
  --display-name churn-prediction \
  --container-image-uri us-docker.pkg.dev/vertex-ai/prediction/sklearn-cpu.1-2:latest \
  --artifact-uri gs://my-bucket/models/churn/
```

**Docs:** https://cloud.google.com/vertex-ai/docs/model-registry/introduction

---

## Step 4: Deploy to Inference Endpoint

### AWS SageMaker Endpoint

```python
from sagemaker.sklearn import SKLearnModel

model = SKLearnModel(
    model_data=model_data,
    role=role,
    entry_point="inference.py",
    framework_version="1.2-1"
)

predictor = model.deploy(
    initial_instance_count=1,
    instance_type="ml.m5.large",
    endpoint_name="churn-prediction-endpoint"
)

# Test the endpoint
result = predictor.predict({"features": [12, 79.50, 954.00, 1, 0]})
print(f"Prediction: {result}")
```

### Inference Script (inference.py)

```python
import joblib
import numpy as np
import json

def model_fn(model_dir):
    model = joblib.load(f"{model_dir}/model.joblib")
    scaler = joblib.load(f"{model_dir}/scaler.joblib")
    return {"model": model, "scaler": scaler}

def input_fn(request_body, content_type):
    data = json.loads(request_body)
    return np.array(data["features"]).reshape(1, -1)

def predict_fn(input_data, model_dict):
    scaled = model_dict["scaler"].transform(input_data)
    prediction = model_dict["model"].predict(scaled)
    probability = model_dict["model"].predict_proba(scaled)
    return {"prediction": int(prediction[0]), "probability": float(probability[0][1])}

def output_fn(prediction, accept):
    return json.dumps(prediction)
```

### Azure ML Managed Online Endpoint

```python
from azure.ai.ml.entities import ManagedOnlineEndpoint, ManagedOnlineDeployment

endpoint = ManagedOnlineEndpoint(name="churn-prediction", auth_mode="key")
ml_client.online_endpoints.begin_create_or_update(endpoint).result()

deployment = ManagedOnlineDeployment(
    name="v1",
    endpoint_name="churn-prediction",
    model=model,
    instance_type="Standard_DS2_v2",
    instance_count=1,
    scoring_script="inference.py",
    environment="AzureML-sklearn-1.2"
)
ml_client.online_deployments.begin_create_or_update(deployment).result()
```

**Docs:** https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-online-endpoints

### GCP Vertex AI Endpoint

```bash
# Create endpoint
gcloud ai endpoints create --display-name churn-prediction --region us-central1

# Deploy model to endpoint
gcloud ai endpoints deploy-model ENDPOINT_ID \
  --region us-central1 \
  --model MODEL_ID \
  --display-name v1 \
  --machine-type n1-standard-4 \
  --min-replica-count 1 \
  --max-replica-count 3
```

**Docs:** https://cloud.google.com/vertex-ai/docs/predictions/get-predictions

---

## Step 5: A/B Testing

### Traffic Splitting

**AWS SageMaker**
```python
# Deploy a second model variant
predictor_v2 = model_v2.deploy(
    initial_instance_count=1,
    instance_type="ml.m5.large",
    endpoint_name="churn-prediction-endpoint",
    variant_name="v2",
    initial_variant_weight=0.1  # 10% of traffic
)

# Update traffic split
sm_client.update_endpoint_weights_and_capacities(
    EndpointName="churn-prediction-endpoint",
    DesiredWeightsAndCapacities=[
        {"VariantName": "v1", "DesiredWeight": 0.5},
        {"VariantName": "v2", "DesiredWeight": 0.5}
    ]
)
```

**Azure ML**
```python
# Set traffic split
endpoint.traffic = {"v1": 90, "v2": 10}
ml_client.online_endpoints.begin_create_or_update(endpoint).result()
```

**GCP Vertex AI**
```bash
gcloud ai endpoints deploy-model ENDPOINT_ID \
  --region us-central1 \
  --model MODEL_V2_ID \
  --display-name v2 \
  --traffic-split v1=90,v2=10
```

---

## Step 6: Monitor for Drift

### Data Drift Detection

```python
# drift_detection.py
import numpy as np
from scipy import stats

def detect_drift(reference_data, production_data, threshold=0.05):
    """Detect data drift using Kolmogorov-Smirnov test."""
    drift_results = {}

    for column in reference_data.columns:
        statistic, p_value = stats.ks_2samp(
            reference_data[column], production_data[column]
        )
        drift_results[column] = {
            "statistic": statistic,
            "p_value": p_value,
            "drift_detected": p_value < threshold
        }

    return drift_results
```

### Model Performance Monitoring

**Key Metrics to Track**
- Prediction latency (p50, p95, p99)
- Prediction distribution (are outputs shifting?)
- Feature value distributions (input drift)
- Actual vs predicted comparison (when ground truth is available)
- Error rates and outlier predictions

### Cloud-Native Monitoring

**AWS SageMaker Model Monitor**
```python
from sagemaker.model_monitor import DefaultModelMonitor

monitor = DefaultModelMonitor(
    role=role,
    instance_count=1,
    instance_type="ml.m5.large",
    max_runtime_in_seconds=3600
)

monitor.create_monitoring_schedule(
    endpoint_input="churn-prediction-endpoint",
    output_s3_uri="s3://my-bucket/monitoring/",
    schedule_cron_expression="cron(0 * ? * * *)"  # Hourly
)
```

**GCP Vertex AI Model Monitoring**
```bash
gcloud ai model-monitoring-jobs create \
  --display-name churn-monitoring \
  --endpoint ENDPOINT_ID \
  --region us-central1 \
  --prediction-sampling-rate 0.1 \
  --monitoring-frequency 24
```

---

## Verification Checklist

- [ ] Model is trained and metrics meet acceptance criteria
- [ ] Model artifacts are stored in a model registry
- [ ] Inference endpoint is deployed and accepting requests
- [ ] Endpoint returns correct predictions for test inputs
- [ ] A/B testing routes traffic to multiple model versions
- [ ] Monitoring is configured for drift and performance
- [ ] Endpoint auto-scales based on traffic (if configured)

---

## Cleanup

1. Delete inference endpoints
2. Remove model versions from the registry
3. Delete training artifacts from cloud storage
4. Remove monitoring schedules and alerts
5. Delete IAM roles and service accounts

---

## Additional Resources

- [AWS SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)
- [Azure Machine Learning Documentation](https://learn.microsoft.com/en-us/azure/machine-learning/)
- [GCP Vertex AI Documentation](https://cloud.google.com/vertex-ai/docs)
- [MLflow Documentation](https://mlflow.org/docs/latest/index.html)
- [scikit-learn Documentation](https://scikit-learn.org/stable/documentation.html)
