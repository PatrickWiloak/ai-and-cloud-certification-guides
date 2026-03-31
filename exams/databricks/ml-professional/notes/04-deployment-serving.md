# Deployment and Serving - Databricks ML Professional

## Overview

This section covers model deployment and serving patterns, representing 15% of the exam. You need to understand serving endpoints, deployment strategies, inference tables, and production deployment patterns.

**[📖 Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving overview
**[📖 Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)** - Request logging

## Key Topics

### 1. Model Serving Endpoints

**[📖 Serverless Serving](https://docs.databricks.com/en/machine-learning/model-serving/create-manage-serving-endpoints.html)** - Endpoint management

**Serving Options:**
| Type | Description | Best For |
|------|-------------|----------|
| Serverless | Fully managed, auto-scaling | Most production workloads |
| Provisioned throughput | Dedicated compute, guaranteed performance | Latency-sensitive apps |

**Key Concepts:**
- Endpoints auto-scale based on traffic (including scale-to-zero)
- REST API for predictions: POST request with JSON payload
- Authentication via API keys or OAuth tokens
- Endpoint configuration specifies model version, compute size, and scaling
- Multiple model versions can be served from a single endpoint

```python
import requests

# Query serving endpoint
response = requests.post(
    f"https://{workspace_url}/serving-endpoints/{endpoint_name}/invocations",
    headers={"Authorization": f"Bearer {token}"},
    json={"dataframe_records": [{"feature1": 1.0, "feature2": "value"}]}
)
predictions = response.json()
```

### 2. Deployment Strategies

| Strategy | Description | Risk Level |
|----------|-------------|------------|
| Blue/green | Two identical environments, instant traffic switch | Low |
| Canary | Route small % of traffic to new model | Low |
| Shadow | Run new model in parallel, do not serve results | Lowest |
| Rolling | Gradually replace old model instances | Medium |

**Key Concepts:**
- Blue/green: maintain two environments, switch DNS to route traffic
- Canary deployment: start with 5-10% traffic to new model, increase if healthy
- Shadow deployment: test new model with real traffic without affecting users
- Feature flags enable/disable model versions without redeployment
- Rollback strategy: revert to previous model version immediately on issues

### 3. Inference Tables

**[📖 Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)** - Request logging

**Key Concepts:**
- Automatically log all requests and responses from serving endpoints
- Stored as Delta tables for analysis and monitoring
- Capture: inputs, outputs, timestamps, latency, endpoint metadata
- Enable ground truth joining for model evaluation
- Track prediction distributions for drift detection
- Retention policies manage storage for high-volume endpoints

### 4. Batch Inference Deployment

```python
# Batch inference with mlflow.pyfunc.spark_udf
predict_udf = mlflow.pyfunc.spark_udf(spark, model_uri="models:/my_model@champion")

# Score large dataset
predictions = (spark.table("features")
    .withColumn("prediction", predict_udf(struct("f1", "f2", "f3")))
    .write.format("delta").mode("overwrite")
    .saveAsTable("predictions"))
```

**Key Concepts:**
- Use model aliases (@champion) to always score with the production model
- Batch inference is scheduled as Databricks Workflows
- Results stored in Delta tables for downstream consumption
- Suitable for daily/hourly scoring of large datasets

### 5. Production Readiness

**Key Concepts:**
- Health checks: verify endpoint is responding correctly
- Circuit breakers: stop sending traffic to unhealthy endpoints
- Load testing: validate throughput and latency before production
- Latency budgets: define acceptable response time SLAs
- Error handling: graceful degradation when model fails
- Cost monitoring: track serving compute costs per endpoint

## Exam Tips for This Domain

1. **Deployment strategies** - Know canary, blue/green, and shadow patterns
2. **Inference tables** - Automatic logging for monitoring and drift detection
3. **Serverless vs provisioned** - Tradeoffs between flexibility and guaranteed performance
4. **Model aliases** - Use @champion for production model references
5. **Batch vs real-time** - Know when each pattern is appropriate

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Model Serving | [docs.databricks.com/en/machine-learning/model-serving/index.html](https://docs.databricks.com/en/machine-learning/model-serving/index.html) |
| Endpoint Management | [docs.databricks.com/en/machine-learning/model-serving/create-manage-serving-endpoints.html](https://docs.databricks.com/en/machine-learning/model-serving/create-manage-serving-endpoints.html) |
| Inference Tables | [docs.databricks.com/en/machine-learning/model-serving/inference-tables.html](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html) |
