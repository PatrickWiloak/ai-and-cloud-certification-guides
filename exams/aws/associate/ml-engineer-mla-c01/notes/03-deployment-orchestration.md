# Deployment and Orchestration of ML Workflows

**[SageMaker Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html)** - Model deployment overview

## SageMaker Endpoints

### Real-Time Inference

**[Real-Time Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html)** - Low-latency predictions

**Endpoint Components**:
- **Model** - trained model artifacts from S3
- **Endpoint Configuration** - instance type, count, variants
- **Endpoint** - hosted inference service

**Key Features**:
- Persistent, always-on inference
- Low-latency responses (milliseconds)
- Multiple production variants for A/B testing
- Auto-scaling based on traffic patterns
- HTTPS endpoint with IAM authentication

**When to Use**: Consistent traffic, low-latency requirements (<100ms), interactive applications

### Endpoint Auto-Scaling

**[Auto Scaling](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-auto-scaling.html)** - Scale endpoints automatically

- Target tracking scaling policy (e.g., InvocationsPerInstance)
- Step scaling for more granular control
- Scheduled scaling for predictable patterns
- Scale-in cooldown to prevent premature scale-down
- Minimum and maximum instance counts

### Multi-Model Endpoints

**[Multi-Model Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/multi-model-endpoints.html)** - Host many models

- Host thousands of models on single endpoint
- Models loaded from S3 on demand
- Frequently used models cached in memory
- Shared infrastructure reduces costs
- Use when: many models with sparse traffic per model

### Multi-Container Endpoints
- Multiple containers behind single endpoint
- Serial inference pipeline (preprocessing -> model -> postprocessing)
- Direct invocation of specific containers
- Use when: complex inference workflows

### Serverless Inference

**[Serverless Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/serverless-endpoints.html)** - On-demand inference

- Scales to zero when no traffic (cost savings)
- Automatic scaling based on requests
- Configure memory size (1-6 GB) and max concurrency
- Cold start latency when scaling from zero
- Pay only for compute time used

**When to Use**: Intermittent traffic, cost-sensitive, cold start acceptable

### Asynchronous Inference

**[Async Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/async-inference.html)** - Queue-based inference

- Queue requests for processing
- Large payload support (up to 1 GB)
- Long processing time support (up to 1 hour)
- SNS notification on completion
- Scale to zero instances when queue empty

**When to Use**: Large payloads, long processing, batch-like workloads

### Batch Transform

**[Batch Transform](https://docs.aws.amazon.com/sagemaker/latest/dg/batch-transform.html)** - Offline predictions

- Process entire datasets in S3
- No persistent endpoint required
- Parallel processing across instances
- Input/output filtering with JSONPath
- Join input with predictions in output

**When to Use**: Large offline datasets, no real-time requirement, periodic predictions

### Endpoint Type Comparison

| Feature | Real-Time | Serverless | Async | Batch |
|---------|-----------|------------|-------|-------|
| Latency | Milliseconds | Seconds (cold start) | Minutes | Minutes-hours |
| Always on | Yes | No (scales to 0) | Optional | No |
| Max payload | 6 MB | 6 MB | 1 GB | Unlimited |
| Cost model | Per instance-hour | Per inference | Per instance-hour | Per instance-hour |
| Best for | Interactive apps | Sporadic traffic | Large payloads | Offline bulk |

## Model Optimization

### SageMaker Neo

**[SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)** - Model compilation

- Compile models for specific hardware targets
- Optimize inference performance (up to 2x faster)
- Reduce model size for edge deployment
- Supports: TensorFlow, PyTorch, MXNet, XGBoost, ONNX
- Target platforms: cloud instances, edge devices (Jetson, ARM)

### Inference Optimization Techniques
- **Model quantization** - reduce precision (FP32 to INT8)
- **Model pruning** - remove unimportant weights
- **Knowledge distillation** - train smaller model from larger one
- **Batching** - process multiple requests together for GPU efficiency

## Deployment Strategies

### Blue/Green Deployment

**[Deployment Guardrails](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)** - Safe deployment

- Deploy new model to new fleet (green)
- Shift traffic gradually from old (blue) to new (green)
- Monitor CloudWatch metrics during traffic shift
- Auto-rollback if alarms trigger
- Types: all-at-once, canary, linear

### Canary Deployment
- Route small percentage of traffic to new model (e.g., 10%)
- Monitor for errors and performance degradation
- If successful, shift remaining traffic
- Configurable bake time between traffic shifts

### Linear Deployment
- Gradually increase traffic to new model in equal steps
- Example: 10% every 10 minutes until 100%
- Slower but safer than canary
- Auto-rollback at any step if issues detected

### A/B Testing with Production Variants

**[Production Variants](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-routing-create.html)** - Traffic routing

- Multiple model versions on same endpoint
- Configure traffic distribution percentages
- Compare model performance with live traffic
- Use for: model comparison, gradual rollouts

### Shadow Deployments
- Route traffic to both old and new models
- Only return responses from old model
- Compare predictions offline
- No impact to production users

## SageMaker Pipelines

**[SageMaker Pipelines](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)** - ML workflow automation

### Pipeline Concepts
- **Pipeline** - DAG of ML workflow steps
- **Steps** - individual tasks in the pipeline
- **Parameters** - configurable inputs at execution time
- **Conditions** - branch logic based on step outputs
- **Caching** - skip unchanged steps for faster execution

### Step Types

**[Pipeline Steps](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-steps.html)** - Defining pipeline steps

- **ProcessingStep** - data preparation with SageMaker Processing
- **TrainingStep** - model training with SageMaker Training
- **TuningStep** - hyperparameter tuning
- **TransformStep** - batch inference with Batch Transform
- **ConditionStep** - branch based on conditions (e.g., accuracy > threshold)
- **RegisterModelStep** - register model in Model Registry
- **CreateModelStep** - create SageMaker model from artifacts
- **LambdaStep** - run Lambda function for custom logic
- **QualityCheckStep** - data/model quality check
- **ClarifyCheckStep** - bias and explainability check
- **FailStep** - explicitly fail pipeline with message
- **CallbackStep** - wait for external process (human approval)

### Pipeline Parameters
- Define at pipeline creation, set at execution time
- Types: String, Integer, Float, Boolean
- Example: instance type, training data S3 path, epochs

**[Pipeline Parameters](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-parameters.html)** - Parameterize pipelines

### Conditional Execution
- Branch pipeline based on step outputs
- Example: deploy only if model accuracy exceeds 0.95
- Use ConditionStep with comparison operators
- Supports multiple conditions with AND/OR logic

### Pipeline Caching
- Cache step outputs to skip re-execution
- Based on step definition and input hash
- Reduces pipeline execution time
- Configurable TTL for cache entries

## AWS Step Functions for ML

**[Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)** - Workflow orchestration

### SageMaker Integration

**[Step Functions ML](https://docs.aws.amazon.com/step-functions/latest/dg/connect-sagemaker.html)** - SageMaker integration

- Native integration with SageMaker APIs
- States for: training, tuning, transform, endpoint creation
- Error handling and retry logic
- Parallel execution of training jobs
- Human approval steps with callbacks

### When to Use Step Functions vs SageMaker Pipelines

**SageMaker Pipelines**:
- ML-specific workflow with SageMaker services
- Built-in caching, lineage tracking
- Tight integration with Model Registry
- Best for: standard ML workflows within SageMaker

**Step Functions**:
- General-purpose workflow orchestration
- Integration with 200+ AWS services
- Complex branching and error handling
- Best for: workflows involving many AWS services beyond SageMaker

## MLOps Patterns

### SageMaker Projects

**[SageMaker Projects](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html)** - MLOps templates

- Pre-built templates for common MLOps patterns
- CI/CD integration with CodePipeline, CodeBuild, CodeCommit
- Templates include: build, train, deploy pipelines
- Custom templates using Service Catalog

### CI/CD for ML

**Training Pipeline**:
1. Code change triggers CodePipeline
2. CodeBuild runs unit tests and linting
3. SageMaker Pipeline executes training workflow
4. Model registered in Model Registry
5. Manual or automated approval

**Deployment Pipeline**:
1. Model approval triggers deployment pipeline
2. Deploy to staging endpoint
3. Run integration tests
4. Manual approval for production
5. Deploy to production with canary strategy

### Infrastructure Management

**Container Registry (ECR)**:
- Store custom training and inference containers
- Image scanning for vulnerabilities
- Lifecycle policies for image cleanup
- Cross-region and cross-account replication

**[Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)** - Container registry

## Key Takeaways

1. **Endpoint types** - know when to use real-time, serverless, async, and batch
2. **Auto-scaling** - configure for real-time endpoints based on InvocationsPerInstance
3. **Multi-model endpoints** - cost-effective for many models with sparse traffic
4. **Deployment guardrails** - canary and linear strategies with auto-rollback
5. **SageMaker Pipelines** - primary tool for ML workflow automation
6. **Step types** - know all pipeline step types and their purposes
7. **Conditional steps** - deploy only when quality thresholds are met
8. **Step Functions** - use for complex workflows beyond SageMaker
9. **MLOps** - CI/CD for ML with CodePipeline and SageMaker Projects
10. **Production variants** - A/B testing with traffic distribution
