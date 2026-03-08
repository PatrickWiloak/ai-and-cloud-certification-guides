# ML Model Deployment and Operations (Domain 3 - 22%)

## 📋 Overview

This domain covers deploying ML models to production, selecting appropriate inference patterns, orchestrating ML pipelines, and implementing CI/CD for ML workflows. The focus is on operational aspects of serving models at scale.

**📖 [Deploy Models for Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html)** - SageMaker deployment guide

---

## 🎯 SageMaker Inference Options

### Real-Time Endpoints

Real-time endpoints provide persistent, low-latency inference for synchronous requests.

**📖 [Real-Time Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html)** - Hosting models

#### Endpoint Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Single-Model** | One model per endpoint | Dedicated, high-traffic model |
| **Multi-Model (MME)** | Multiple models on shared infrastructure | Many models with variable traffic |
| **Multi-Container** | Multiple containers in serial or direct invocation | Preprocessing + inference pipeline |
| **Serverless** | Scales to zero, pay per invocation | Intermittent or unpredictable traffic |

#### Single-Model Endpoint

- One model hosted on one or more instances
- Specify instance type and count
- Supports auto-scaling based on CloudWatch metrics
- Best for: High-traffic, latency-sensitive production models

#### Multi-Model Endpoints (MME)

- Host thousands of models on a single endpoint
- Models loaded/unloaded dynamically from S3
- Cost-effective for many models with sparse traffic
- Trade-off: Cold start latency when loading models not in memory

**📖 [Multi-Model Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/multi-model-endpoints.html)** - Multiple models

#### Serverless Inference

- No instances to manage; scales to zero when idle
- Pay only for compute time during inference
- Configurable memory (1024 MB - 6144 MB) and max concurrency
- Cold start latency when scaling from zero
- Best for: Infrequent or unpredictable traffic patterns

**📖 [Serverless Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/serverless-endpoints.html)** - Serverless deployment

---

### Batch Transform

Run inference on large datasets without deploying a persistent endpoint.

**📖 [Batch Transform](https://docs.aws.amazon.com/sagemaker/latest/dg/batch-transform.html)** - Batch predictions

#### Key Configuration

- **Instance type and count**: Scale horizontally for throughput
- **Max payload size**: Maximum request size (up to 100 MB)
- **Batch strategy**: MultiRecord (batch multiple records per request) or SingleRecord
- **Max concurrent transforms**: Control parallelism
- **Join source**: Append predictions to input data
- **Data distribution**: FullyReplicated or ShardedByS3Key

#### When to Use Batch Transform

- Large-scale offline predictions (millions of records)
- Pre-compute predictions for a dataset
- No need for real-time latency
- Cost-effective for one-time or periodic inference jobs

---

### Asynchronous Inference

Handle long-running predictions with queue-based processing.

**📖 [Async Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/async-inference.html)** - Asynchronous endpoints

#### Key Features

- Requests queued internally; results stored in S3
- SNS notifications on completion (success or failure)
- Supports large payloads (up to 1 GB)
- Can scale to zero instances when queue is empty
- Best for: Large payloads, long processing times, video/audio inference

---

### Inference Endpoint Selection Guide

| Factor | Real-Time | Batch Transform | Async | Serverless |
|--------|-----------|----------------|-------|------------|
| **Latency** | Low (ms) | High (minutes-hours) | Medium (seconds-minutes) | Medium (cold start) |
| **Traffic Pattern** | Sustained | One-time/periodic | Sporadic, large payloads | Intermittent |
| **Payload Size** | Up to 6 MB | Up to 100 MB | Up to 1 GB | Up to 6 MB |
| **Cost Model** | Per-instance-hour | Per-instance-hour | Per-instance-hour | Per-invocation |
| **Scales to Zero** | No | N/A | Yes | Yes |

---

## 📚 Production Variants and A/B Testing

**📖 [Production Variants](https://docs.aws.amazon.com/sagemaker/latest/dg/model-ab-testing.html)** - A/B testing

### Traffic Splitting

- Deploy multiple model versions as production variants on the same endpoint
- Assign traffic weights (e.g., 90% to model A, 10% to model B)
- Use for A/B testing, canary deployments, and gradual rollouts
- Each variant can use different instance types and counts

### Shadow Testing

- Route a copy of production traffic to a shadow variant
- Compare shadow predictions against production without affecting users
- Validate new model performance before switching traffic

**📖 [Shadow Tests](https://docs.aws.amazon.com/sagemaker/latest/dg/shadow-tests.html)** - Shadow testing

---

## Endpoint Auto-Scaling

**📖 [Endpoint Auto Scaling](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-auto-scaling.html)** - Scale endpoints

### Scaling Policies

- **Target Tracking**: Maintain a target metric value (e.g., InvocationsPerInstance = 70)
- **Step Scaling**: Scale based on CloudWatch alarm thresholds
- **Scheduled Scaling**: Scale at predetermined times for known traffic patterns

### Key Metrics for Scaling

| Metric | Description |
|--------|-------------|
| `InvocationsPerInstance` | Average invocations per instance (most common scaling metric) |
| `ModelLatency` | Time to generate a prediction |
| `OverheadLatency` | SageMaker overhead (outside model inference) |
| `CPUUtilization` | Instance CPU usage |
| `GPUUtilization` | Instance GPU usage |

### Best Practices

- Use `InvocationsPerInstance` for target tracking (recommended default)
- Set scale-in cooldown period to prevent flapping (default 300 seconds)
- Configure minimum instances to handle baseline traffic
- Monitor `ModelLatency` and set alarms for SLA breaches

---

## SageMaker Pipelines

**📖 [SageMaker Pipelines](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)** - ML workflow orchestration

### Pipeline Step Types

| Step Type | Purpose |
|-----------|---------|
| **ProcessingStep** | Data preprocessing, evaluation, feature engineering |
| **TrainingStep** | Model training |
| **TuningStep** | Hyperparameter optimization |
| **TransformStep** | Batch inference |
| **ModelStep** | Create or register model |
| **ConditionStep** | Conditional branching (e.g., deploy only if accuracy > threshold) |
| **CallbackStep** | Invoke external processes (Lambda, custom) |
| **QualityCheckStep** | Data or model quality validation |
| **ClarifyCheckStep** | Bias and explainability checks |
| **FailStep** | Explicitly fail the pipeline |

**📖 [Pipeline Steps](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-steps.html)** - Defining steps

### Pipeline Features

- **Parameters**: Input parameters for pipeline execution (instance types, thresholds)
- **Caching**: Skip previously executed steps if inputs haven't changed
- **Conditions**: Branch pipeline execution based on step outputs
- **Parallelism**: Run independent steps concurrently
- **Retry Policies**: Automatically retry failed steps

### Typical ML Pipeline Flow

```
ProcessingStep (data prep)
    → TrainingStep (train model)
    → ProcessingStep (evaluate model)
    → ConditionStep (accuracy > threshold?)
        → Yes: ModelStep (register in Model Registry)
            → TransformStep or Endpoint deployment
        → No: FailStep (pipeline fails)
```

**📖 [Pipeline Parameters](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-parameters.html)** - Parameterization

---

## SageMaker Model Registry

**📖 [Model Registry](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html)** - Model versioning

### Key Concepts

- **Model Package Group**: Collection of model versions for a use case
- **Model Package**: Individual model version with artifacts, metrics, and metadata
- **Approval Status**: PendingManualApproval, Approved, Rejected
- **Model Lineage**: Track data, code, and parameters used to create each version

### Workflow

1. Train model and evaluate performance
2. Register model version in Model Registry
3. Set approval status (manual or automated)
4. Deploy approved model to endpoint
5. Track lineage from data source to production deployment

**📖 [Model Packages](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-version.html)** - Creating packages
**📖 [Model Approval](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-approve.html)** - Approval workflows

---

## SageMaker Neo (Model Optimization)

**📖 [SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)** - Model optimization

- Compiles models for specific target hardware (cloud instances, edge devices)
- Optimizes inference performance (up to 2x faster)
- Reduces model size and memory footprint
- Supports TensorFlow, PyTorch, MXNet, XGBoost, ONNX
- Target platforms: cloud (SageMaker), edge (Jetson, Raspberry Pi, etc.)

---

## CI/CD for ML (MLOps)

### SageMaker Projects

**📖 [SageMaker Projects](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html)** - MLOps templates

- Pre-built MLOps templates for common patterns
- Templates include: model build + deploy, model monitoring, drift detection
- Integration with CodePipeline, CodeBuild, and CodeCommit
- Customizable for organization-specific requirements

### AWS Step Functions for ML

**📖 [Step Functions ML](https://docs.aws.amazon.com/step-functions/latest/dg/connect-sagemaker.html)** - SageMaker integration

- Orchestrate ML workflows with state machine logic
- Native integration with SageMaker APIs
- Error handling, retries, and parallel execution
- Visual workflow designer
- Best for: Complex workflows with non-SageMaker steps (Lambda, Glue, etc.)

### SageMaker Pipelines vs Step Functions

| Feature | SageMaker Pipelines | Step Functions |
|---------|-------------------|----------------|
| Focus | ML-specific workflows | General-purpose orchestration |
| Caching | Built-in step caching | No native caching |
| ML Integration | Deep SageMaker integration | Broad AWS service integration |
| Lineage | Automatic ML lineage tracking | Manual tracking |
| Best For | Standard ML pipelines | Complex multi-service workflows |

---

## Key Exam Scenarios

1. **Deploy model with unpredictable traffic** - Use serverless inference endpoint (scales to zero, pay-per-use)
2. **Host 1000+ models cost-effectively** - Multi-model endpoint (shared infrastructure, dynamic loading)
3. **Process 10 million records for predictions** - Batch Transform with ShardedByS3Key for parallelism
4. **Gradually roll out new model version** - Production variants with traffic splitting (90/10 canary)
5. **Automate training-to-deployment pipeline** - SageMaker Pipeline with ConditionStep for quality gate and ModelStep for registry
6. **Large video inference (500 MB payload)** - Asynchronous inference endpoint with SNS completion notification
7. **Scale endpoint based on traffic** - Target tracking auto-scaling on InvocationsPerInstance metric
