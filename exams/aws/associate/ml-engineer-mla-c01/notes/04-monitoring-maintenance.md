# ML Solution Monitoring and Maintenance (Domain 4 - 24%)

## 📋 Overview

This domain covers monitoring ML models in production, detecting drift, implementing retraining strategies, and securing ML workloads. It emphasizes the operational lifecycle of ML solutions after deployment.

**📖 [Monitor Models](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - SageMaker monitoring guide

---

## 🎯 SageMaker Model Monitor

**📖 [Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - Monitoring overview

### Data Capture

Before monitoring, you must enable data capture on your endpoint to collect inference inputs and outputs.

- Captures request and response payloads from real-time endpoints
- Stores captured data in S3 in JSON format
- Configurable sampling percentage (e.g., capture 10% of requests)
- Supports both input data and output prediction capture

**📖 [Capture Data](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-capture.html)** - Endpoint data capture

### Monitoring Types

| Monitor Type | What It Detects | Baseline |
|-------------|-----------------|----------|
| **Data Quality** | Changes in input data distribution (data drift) | Statistics from training data |
| **Model Quality** | Degradation in model predictions | Metrics from evaluation |
| **Bias Drift** | Changes in bias metrics over time | Clarify bias baseline |
| **Feature Attribution** | Changes in feature importance | Clarify SHAP baseline |

### Data Quality Monitoring

**📖 [Data Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)** - Data drift detection

- **Baseline**: Generate statistics and constraints from training dataset
  - Statistics: mean, median, standard deviation, min, max, unique count
  - Constraints: data types, completeness, value ranges
- **Monitoring Schedule**: Run periodically (hourly, daily) to compare live data against baseline
- **Violations**: Report deviations from baseline constraints
- **CloudWatch Integration**: Emit metrics and trigger alarms on violations

#### Common Data Quality Violations

| Violation | Description |
|-----------|-------------|
| **Data Type Mismatch** | Feature type changed (string vs numeric) |
| **Missing Values** | Higher missing rate than baseline |
| **Distribution Shift** | Statistical distribution changed significantly |
| **Out of Range** | Values outside expected min/max range |
| **New Categories** | Categorical values not seen in training |

### Model Quality Monitoring

**📖 [Model Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html)** - Performance drift

- Monitors actual model performance metrics over time
- Requires ground truth labels (provided via S3 or merged with predictions)
- Compares live metrics against baseline evaluation metrics
- Tracks: accuracy, precision, recall, F1, AUC-ROC (classification); RMSE, MAE, R-squared (regression)

> **Exam Tip:** Model quality monitoring requires ground truth labels. If labels are delayed (common in many use cases), data quality monitoring provides an earlier signal of potential issues.

---

## SageMaker Clarify

**📖 [SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-fairness-and-explainability.html)** - Bias and explainability

### Bias Detection

#### Pre-Training Bias Metrics

Analyze training data before model training:

| Metric | What It Measures |
|--------|-----------------|
| **Class Imbalance (CI)** | Imbalance between facet groups |
| **Difference in Proportions of Labels (DPL)** | Difference in positive outcome rates between groups |
| **Kullback-Leibler Divergence (KL)** | Divergence between label distributions |

#### Post-Training Bias Metrics

Analyze model predictions after training:

| Metric | What It Measures |
|--------|-----------------|
| **Disparate Impact (DI)** | Ratio of positive predictions between groups |
| **Demographic Parity Difference (DPD)** | Difference in positive prediction rates |
| **Accuracy Difference (AD)** | Difference in accuracy between groups |

**📖 [Bias Drift](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-model-monitor-bias-drift.html)** - Fairness monitoring

### Explainability

- Uses SHAP (SHapley Additive exPlanations) values for feature attribution
- Explains individual predictions (local explainability) and overall model behavior (global)
- Feature importance ranking across the dataset
- Integration with Model Monitor for tracking feature attribution drift

**📖 [Explainability](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-model-explainability.html)** - SHAP values

---

## 📚 CloudWatch Integration for ML

**📖 [CloudWatch Metrics](https://docs.aws.amazon.com/sagemaker/latest/dg/monitoring-cloudwatch.html)** - SageMaker metrics

### Key SageMaker CloudWatch Metrics

#### Training Metrics

| Metric | Description |
|--------|-------------|
| `train:loss` | Training loss (algorithm-specific) |
| `validation:accuracy` | Validation accuracy |
| `CPUUtilization` | Instance CPU usage |
| `GPUUtilization` | GPU usage |
| `MemoryUtilization` | Memory usage |
| `DiskUtilization` | Disk usage |

#### Endpoint Metrics

| Metric | Description |
|--------|-------------|
| `Invocations` | Number of inference requests |
| `InvocationsPerInstance` | Requests per instance (for auto-scaling) |
| `ModelLatency` | Time for model to generate prediction |
| `OverheadLatency` | SageMaker processing overhead |
| `Invocation4XXErrors` | Client error count |
| `Invocation5XXErrors` | Server error count |
| `InvocationModelErrors` | Model container errors |

### CloudWatch Alarms for ML

**📖 [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Alerting

Common alarm configurations for ML endpoints:
- **ModelLatency > threshold**: Alert when inference latency exceeds SLA
- **Invocation5XXErrors > 0**: Alert on server errors
- **InvocationsPerInstance > threshold**: Trigger auto-scaling
- **Model Monitor violations**: Alert when data drift detected

### CloudWatch Logs for ML

**📖 [CloudWatch Logs](https://docs.aws.amazon.com/sagemaker/latest/dg/logging-cloudwatch.html)** - Log collection

- Training job logs: `/aws/sagemaker/TrainingJobs`
- Endpoint logs: `/aws/sagemaker/Endpoints/{endpoint-name}`
- Processing job logs: `/aws/sagemaker/ProcessingJobs`
- Use CloudWatch Logs Insights to query and analyze ML logs

---

## Drift Detection and Retraining

### Types of Drift

| Drift Type | Description | Detection Method |
|-----------|-------------|-----------------|
| **Data Drift** | Input feature distributions change | Model Monitor Data Quality |
| **Concept Drift** | Relationship between features and target changes | Model Monitor Model Quality |
| **Prediction Drift** | Model output distribution changes | Monitor prediction statistics |
| **Feature Attribution Drift** | Feature importance rankings change | Clarify feature attribution |

### Retraining Strategies

| Strategy | Trigger | Best For |
|----------|---------|----------|
| **Scheduled** | Fixed interval (daily, weekly, monthly) | Predictable data changes |
| **Drift-Triggered** | Model Monitor violation alarm | Unpredictable changes |
| **Performance-Triggered** | Model quality metric below threshold | When ground truth is available |
| **Manual** | Human decision based on business context | Sensitive applications |

### Automated Retraining Pipeline

1. Model Monitor detects drift violation
2. CloudWatch alarm triggers EventBridge rule
3. EventBridge triggers Lambda function
4. Lambda starts SageMaker Pipeline execution
5. Pipeline: process data -> train model -> evaluate -> register in Model Registry
6. Approved model deployed via deployment guardrails

---

## Deployment Guardrails

**📖 [Deployment Guardrails](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)** - Safe deployment

### Traffic Shifting Strategies

| Strategy | Description | Risk Level |
|----------|-------------|------------|
| **All-at-Once** | Shift all traffic immediately | Highest |
| **Canary** | Shift small % first, then all | Medium |
| **Linear** | Gradually increase traffic over time | Lowest |

### Canary Deployment

- Route small percentage (e.g., 10%) to new model
- Monitor for errors and latency during baking period
- If healthy, shift remaining traffic
- Automatic rollback on CloudWatch alarm trigger

### Linear Deployment

- Increase traffic in equal increments over time
- Example: 10% every 10 minutes until 100%
- Provides gradual confidence building
- Automatic rollback at any stage if alarms fire

### Rollback Configuration

- Define CloudWatch alarms that trigger automatic rollback
- Monitor: ModelLatency, Invocation5XXErrors, custom metrics
- Rollback shifts all traffic back to original model
- Baking period: minimum time before proceeding with traffic shift

**📖 [Traffic Routing](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-routing-create.html)** - Production variants

---

## Security for ML Workloads

### IAM for SageMaker

**📖 [IAM for SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam.html)** - Access control

- **Execution Role**: IAM role assumed by SageMaker for training, processing, and hosting
- Needs access to: S3 (data/artifacts), ECR (containers), CloudWatch (logs/metrics), KMS (encryption)
- Principle of least privilege: grant only required permissions
- Use condition keys to restrict SageMaker actions by VPC, instance type, or encryption

**📖 [SageMaker Roles](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html)** - Execution roles

### VPC Configuration

**📖 [VPC Configuration](https://docs.aws.amazon.com/sagemaker/latest/dg/infrastructure-connect-to-resources.html)** - Private networking

- Run training jobs and endpoints within a VPC for network isolation
- Use VPC endpoints (PrivateLink) for SageMaker API access without internet
- Configure security groups to control traffic to/from ML instances
- Use NAT Gateway for internet access from private subnets (e.g., downloading packages)

### Encryption

**📖 [Data Encryption](https://docs.aws.amazon.com/sagemaker/latest/dg/encryption-at-rest.html)** - Encryption at rest

| What to Encrypt | How |
|----------------|-----|
| **Training data in S3** | SSE-S3, SSE-KMS, or client-side |
| **Model artifacts in S3** | KMS encryption via SageMaker configuration |
| **Training instance volumes** | KMS key specified in training job |
| **Endpoint instance volumes** | KMS key specified in endpoint configuration |
| **Data in transit** | TLS encryption (automatic for SageMaker API calls) |
| **Inter-container traffic** | Enable inter-container encryption for distributed training |

**📖 [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key management

### CloudTrail for ML Auditing

**📖 [CloudTrail Logging](https://docs.aws.amazon.com/sagemaker/latest/dg/logging-using-cloudtrail.html)** - API auditing

- All SageMaker API calls logged in CloudTrail
- Track who created/deleted training jobs, endpoints, and models
- Monitor for unauthorized access or configuration changes
- Integrate with EventBridge for automated responses

---

## Model Governance

### Model Cards

**📖 [Model Cards](https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html)** - Model documentation

- Standardized documentation for ML models
- Include: model purpose, training data, evaluation metrics, limitations, ethical considerations
- JSON schema for consistent formatting
- Exportable as PDF for stakeholder review
- Integration with Model Registry for version-specific documentation

### SageMaker Model Dashboard

- Centralized view of all models across accounts
- Monitor model quality, data quality, and bias metrics
- Track endpoint performance and utilization
- Identify models that need attention (violations, drift)

### Model Lineage

**📖 [SageMaker Lineage](https://docs.aws.amazon.com/sagemaker/latest/dg/lineage-tracking.html)** - Track artifacts

- Automatic tracking of ML workflow artifacts
- Trace from data source → processing → training → model → endpoint
- Lineage entities: artifacts, contexts, actions, associations
- Useful for debugging, compliance, and reproducibility

---

## Key Exam Scenarios

1. **Detect when input data distribution changes** - Set up Model Monitor Data Quality with baseline from training data; schedule hourly monitoring
2. **Model accuracy degrading over time** - Model Monitor Model Quality monitoring with ground truth labels; trigger retraining pipeline
3. **Safely deploy new model to production** - Use deployment guardrails with canary traffic shifting; configure CloudWatch alarm-based rollback
4. **Ensure ML data is encrypted** - KMS encryption for S3 data, training volumes, model artifacts; enable inter-container encryption
5. **Detect bias in production predictions** - SageMaker Clarify bias drift monitoring with scheduled checks against baseline
6. **Automated retraining on drift** - Model Monitor violation -> CloudWatch alarm -> EventBridge -> Lambda -> SageMaker Pipeline
7. **Audit who modified ML resources** - CloudTrail logging for all SageMaker API calls; integrate with CloudWatch Logs for alerting
8. **Document model for compliance** - Create Model Card with training data, metrics, limitations; attach to Model Registry version
