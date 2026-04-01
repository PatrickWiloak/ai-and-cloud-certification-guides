# High-Yield Scenarios and Patterns - ML Engineer Associate (MLA-C01)

## Data Preparation Scenarios

### Building a Feature Engineering Pipeline
**Scenario**: A company has raw customer transaction data in S3 and needs to build reusable features for multiple ML models.

**Solution Pattern**:
- **Storage**: Raw data in S3 data lake with Parquet format
- **Catalog**: Glue Crawler discovers schema, stores in Data Catalog
- **Transform**: Glue ETL job for initial cleaning and aggregation
- **Features**: SageMaker Feature Store for feature management
- **Reuse**: Online store for real-time inference, offline store for training

**Common Distractors**:
- Store features in RDS (wrong - Feature Store is purpose-built for ML features)
- Process data on EC2 instances (wrong - use managed Glue or SageMaker Processing)
- Create separate feature copies per model (wrong - Feature Store enables sharing)

### Real-Time Feature Engineering
**Scenario**: An ML model needs real-time features computed from streaming data for fraud detection.

**Solution Pattern**:
- **Ingestion**: Kinesis Data Streams for real-time transaction data
- **Processing**: Lambda or Kinesis Data Analytics for feature computation
- **Storage**: Feature Store online store for low-latency feature serving
- **Inference**: SageMaker real-time endpoint reads features at prediction time

**Common Distractors**:
- Batch process features hourly (wrong - fraud detection needs real-time)
- Store features in DynamoDB directly (wrong - Feature Store provides ML-specific features)
- Use S3 for real-time feature serving (wrong - too slow for real-time)

### Data Quality Issues
**Scenario**: Model performance has degraded in production. The team suspects data quality issues in the input data.

**Solution Pattern**:
- **Detection**: SageMaker Model Monitor data quality checks
- **Analysis**: Compare current data distribution against training baseline
- **Investigation**: Check for schema changes, missing values, distribution shifts
- **Remediation**: Fix data pipeline, retrain model with updated data

**Common Distractors**:
- Retrain model immediately (wrong - diagnose the problem first)
- Increase endpoint instance size (wrong - data quality, not compute issue)
- Add more training data (wrong - need to fix quality, not quantity)

## Model Development Scenarios

### Choosing the Right Algorithm
**Scenario**: Company needs to predict customer churn using structured tabular data with 50 features.

**Solution Pattern**:
- **Algorithm**: SageMaker XGBoost (best for tabular data)
- **Alternative**: SageMaker Autopilot for automated algorithm selection
- **Training**: Managed training job with Spot instances for cost savings
- **Tuning**: Automatic Model Tuning with Bayesian optimization

**Common Distractors**:
- Deep learning neural network (wrong - XGBoost typically better for tabular data)
- Linear Learner only (wrong - XGBoost handles non-linear relationships better)
- Train on notebook instance (wrong - use managed training jobs for production)

### Cost-Effective Training
**Scenario**: Training a large deep learning model takes 48 hours and costs $2,000 per run. The team needs to reduce costs.

**Solution Pattern**:
- **Spot Instances**: Use managed Spot training (up to 90% savings)
- **Checkpointing**: Enable checkpoints to resume from interruptions
- **Distributed Training**: Use data parallelism to reduce wall-clock time
- **Instance Selection**: Use GPU instances (P3/P4) for deep learning

**Common Distractors**:
- Use smaller dataset (wrong - may reduce model quality)
- Use CPU instances (wrong - much slower for deep learning)
- Run on notebook instance (wrong - not cost-effective for long training)

### Model Versioning and Approval
**Scenario**: Data science team trains multiple model versions. Only approved models should be deployed to production.

**Solution Pattern**:
- **Registry**: SageMaker Model Registry for version management
- **Package**: Create model package with metrics and artifacts
- **Approval**: Manual or automated approval workflow
- **Deployment**: Pipeline deploys only approved models to endpoints

**Common Distractors**:
- Store models in S3 with naming conventions (wrong - no approval workflow)
- Deploy directly from training job (wrong - bypasses approval process)
- Use Git for model versioning (wrong - Model Registry is purpose-built)

## Deployment Scenarios

### Choosing the Right Endpoint Type
**Scenario**: Application needs ML predictions with varying traffic - heavy during business hours, minimal at night.

**Solution Pattern**:
- **Endpoint**: SageMaker Serverless Inference
- **Reasoning**: Auto-scales to zero during idle periods
- **Cost**: Pay only for inference compute used
- **Alternative**: Real-time endpoint with auto-scaling (if latency is critical)

**When to use which endpoint**:
- **Real-time**: Consistent traffic, low latency requirements (<100ms)
- **Serverless**: Intermittent traffic, cost optimization priority
- **Async**: Large payloads, long processing time (>60 seconds)
- **Batch Transform**: Large datasets, no real-time requirement

**Common Distractors**:
- Always-on endpoint with fixed instances (wrong - wasted cost at night)
- Batch Transform on schedule (wrong - not real-time during business hours)
- Lambda with model (wrong - SageMaker endpoints are better for ML inference)

### Multi-Model Serving
**Scenario**: Company has 500 customer-specific models and needs to serve predictions with minimal infrastructure cost.

**Solution Pattern**:
- **Endpoint**: SageMaker Multi-Model Endpoint
- **Storage**: Models stored in S3, loaded on demand
- **Caching**: Frequently used models cached in memory
- **Cost**: Single endpoint hosts all models

**Common Distractors**:
- 500 separate endpoints (wrong - extremely expensive)
- Single large model for all customers (wrong - loses personalization)
- Lambda per model (wrong - not designed for this scale)

### Safe Model Deployment
**Scenario**: Deploy new model version to production without risking service disruption.

**Solution Pattern**:
- **Strategy**: Blue/green deployment with deployment guardrails
- **Validation**: Canary traffic (10%) to new model for validation
- **Monitoring**: CloudWatch alarms on error rate and latency
- **Rollback**: Automatic rollback if alarms trigger

**Common Distractors**:
- Direct endpoint update (wrong - causes brief outage)
- Manual A/B testing (wrong - not automated, slow rollback)
- Deploy to new endpoint and switch DNS (wrong - more complex than needed)

## ML Pipeline Scenarios

### End-to-End Automation
**Scenario**: Team needs to automate the full ML lifecycle from data processing to model deployment.

**Solution Pattern**:
- **Pipeline**: SageMaker Pipelines with steps:
  1. Processing step: data preparation and feature engineering
  2. Training step: model training with best hyperparameters
  3. Evaluation step: compute metrics on test set
  4. Condition step: deploy only if metrics meet threshold
  5. Register step: register model in Model Registry
  6. Deploy step: update endpoint with new model

**Common Distractors**:
- Manual notebook execution (wrong - not automated)
- Airflow for everything (wrong - SageMaker Pipelines has native integration)
- Separate pipelines per step (wrong - single pipeline for end-to-end)

### Scheduled Retraining
**Scenario**: Model performance degrades monthly as data patterns change. The team needs automated retraining.

**Solution Pattern**:
- **Trigger**: EventBridge scheduled rule (monthly)
- **Pipeline**: SageMaker Pipeline for training and evaluation
- **Validation**: Compare new model against current production model
- **Deployment**: Auto-deploy if new model performs better
- **Alternative Trigger**: Model Monitor alarm triggers retraining

**Common Distractors**:
- Retrain weekly regardless of performance (wrong - wasteful)
- Manual retraining when complaints arise (wrong - reactive, not proactive)
- Increase endpoint instances instead (wrong - does not fix model degradation)

## Monitoring Scenarios

### Model Drift Detection
**Scenario**: Deployed model's predictions are becoming less accurate over time. The team needs to detect and address this.

**Solution Pattern**:
- **Data Drift**: Model Monitor data quality monitoring against baseline
- **Model Drift**: Model Monitor model quality monitoring with ground truth
- **Alerts**: CloudWatch alarms when drift exceeds thresholds
- **Response**: Trigger retraining pipeline via EventBridge

**Drift Types**:
- **Data drift** - input feature distributions change
- **Concept drift** - relationship between features and target changes
- **Prediction drift** - model output distribution changes

**Common Distractors**:
- Monitor only endpoint latency (wrong - misses accuracy degradation)
- Check model quality quarterly (wrong - too infrequent)
- Retrain on original data (wrong - need updated data that reflects current patterns)

### Bias Detection in Production
**Scenario**: Regulatory requirement to continuously monitor ML model for fairness across demographic groups.

**Solution Pattern**:
- **Baseline**: SageMaker Clarify pre-training bias analysis
- **Monitoring**: Model Monitor bias drift detection on endpoint
- **Metrics**: Statistical parity difference, disparate impact ratio
- **Reporting**: Model Cards documenting bias assessments
- **Alert**: EventBridge notification when bias metrics exceed thresholds

**Common Distractors**:
- Check bias only during development (wrong - must be continuous)
- Use accuracy only as fairness metric (wrong - accuracy can hide bias)
- Remove protected attributes (wrong - does not eliminate proxy bias)

## Security Scenarios

### Secure ML Environment
**Scenario**: Healthcare company needs to train ML models on sensitive patient data with strict security requirements.

**Solution Pattern**:
- **Network**: SageMaker in VPC with no internet access
- **Storage**: S3 with SSE-KMS encryption, bucket policies
- **Compute**: VPC endpoints for SageMaker API and S3 access
- **Access**: IAM roles with least-privilege permissions
- **Audit**: CloudTrail for API logging, VPC Flow Logs

**Common Distractors**:
- Public SageMaker notebook (wrong - data exposed)
- Encrypt only at rest (wrong - need transit encryption too)
- Single IAM user for team (wrong - use roles, not shared credentials)

### Cross-Account Model Sharing
**Scenario**: Data science team in one account needs to deploy models to production in another account.

**Solution Pattern**:
- **Registry**: Model Registry in shared account
- **Access**: Cross-account IAM roles for model access
- **Pipeline**: CI/CD pipeline deploys from registry to production account
- **Artifacts**: Model artifacts in S3 with cross-account bucket policy

**Common Distractors**:
- Copy models manually (wrong - not automated or tracked)
- Give data science full production access (wrong - violates least privilege)
- Share AWS credentials (wrong - use IAM roles)

## Generative AI Scenarios

### RAG Application
**Scenario**: Company needs a customer support chatbot that answers questions using internal documentation.

**Solution Pattern**:
- **Foundation Model**: Amazon Bedrock with Claude or Titan
- **Knowledge Base**: Bedrock Knowledge Base with S3 data source
- **Embedding**: Titan Embeddings for vector representation
- **Vector Store**: OpenSearch Serverless for vector search
- **Guardrails**: Bedrock Guardrails for content filtering

**Common Distractors**:
- Train custom LLM from scratch (wrong - unnecessary, use foundation models)
- Fine-tune model on all company data (wrong - RAG is more appropriate)
- Use SageMaker endpoint for LLM (wrong - Bedrock is managed and simpler)

## Key Decision Factors

### Service Selection
1. **SageMaker vs Bedrock**: SageMaker for custom ML, Bedrock for foundation models
2. **Built-in vs Custom**: Built-in algorithms for common problems, custom for unique needs
3. **Real-time vs Batch**: Latency requirements determine endpoint type
4. **Feature Store vs S3**: Feature Store for shared/reusable features, S3 for raw data

### Common Anti-Patterns
- Training in notebooks instead of managed training jobs
- Deploying without monitoring for drift
- Hardcoding hyperparameters instead of tuning
- Manual model deployment instead of pipeline automation
- Ignoring cost optimization (Spot training, right-sizing)
