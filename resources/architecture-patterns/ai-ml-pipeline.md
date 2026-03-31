# AI/ML Pipeline Architecture

A comprehensive guide to building end-to-end machine learning pipelines with MLOps practices across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [MLOps Practices](#mlops-practices)
8. [Feature Stores](#feature-stores)
9. [Model Monitoring](#model-monitoring)
10. [Cost Estimation](#cost-estimation)
11. [Production Checklist](#production-checklist)

---

## Architecture Overview

### What is an ML Pipeline?

An ML pipeline is an automated workflow that covers the full machine learning lifecycle:
- **Data Preparation**: Collecting, cleaning, and transforming training data
- **Feature Engineering**: Creating and managing features for model training
- **Model Training**: Training models on prepared data with hyperparameter tuning
- **Model Evaluation**: Validating model performance against metrics and baselines
- **Model Deployment**: Serving models for real-time or batch inference
- **Model Monitoring**: Tracking model performance and detecting drift in production

### ML Pipeline Stages

1. **Data Ingestion**: Collect raw data from various sources
2. **Data Validation**: Check data quality, schema, and distribution
3. **Data Preprocessing**: Clean, normalize, and transform data
4. **Feature Engineering**: Create and select features
5. **Model Training**: Train models with experiment tracking
6. **Model Evaluation**: Compare against metrics and baselines
7. **Model Registration**: Version and store approved models
8. **Model Deployment**: Deploy to serving infrastructure
9. **Monitoring**: Track predictions, performance, and data drift
10. **Retraining**: Trigger retraining when performance degrades

### Benefits

- **Reproducibility**: Versioned data, code, and models enable reproducible experiments
- **Automation**: Reduce manual steps and accelerate iteration
- **Quality**: Automated validation catches issues before production
- **Governance**: Audit trail for model decisions and compliance
- **Scalability**: Handle large datasets and multiple models efficiently
- **Collaboration**: Teams share features, experiments, and models

### Trade-offs

- **Complexity**: ML pipelines have many moving parts
- **Cost**: GPU/TPU training, feature stores, and serving infrastructure add cost
- **Skill Requirements**: Requires ML engineering and platform expertise
- **Infrastructure Overhead**: Significant infrastructure for small projects
- **Debugging**: Distributed ML workflows are hard to debug

---

## Architecture Diagram Description

### High-Level Architecture

```
[Data Sources] --> [Data Ingestion] --> [Feature Store]
                                              |
                                    [Feature Engineering]
                                              |
                        [Experiment Tracking] -- [Model Training]
                                              |
                                    [Model Evaluation]
                                              |
                                    [Model Registry]
                                              |
                          +-------------------+-------------------+
                          |                   |                   |
                  [Real-time Serving]  [Batch Inference]  [Edge Deployment]
                          |                   |                   |
                  [Monitoring & Drift Detection]
                          |
                  [Retraining Trigger]
```

### MLOps Maturity Levels

| Level | Description | Automation | Key Characteristics |
|-------|-------------|------------|-------------------|
| **0** | Manual | None | Jupyter notebooks, manual deployment |
| **1** | ML Pipeline | Training automated | Automated training, manual deployment |
| **2** | CI/CD for ML | Training + deployment | Automated testing, deployment, monitoring |
| **3** | Full MLOps | End-to-end | Automated retraining, A/B testing, governance |

---

## Component Breakdown

### Data Layer

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Data Lake** | Raw data storage | Versioned, scalable, multi-format |
| **Feature Store** | Managed feature repository | Online/offline serving, feature sharing |
| **Data Validation** | Check data quality | Schema validation, distribution checks |
| **Data Versioning** | Track dataset changes | Reproducible training datasets |

### Training Layer

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Experiment Tracking** | Record experiments | Parameters, metrics, artifacts |
| **Training Infrastructure** | Compute for training | GPU/TPU clusters, spot instances |
| **Hyperparameter Tuning** | Optimize model parameters | Bayesian optimization, grid search |
| **Distributed Training** | Scale training across nodes | Data parallelism, model parallelism |

### Serving Layer

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Model Registry** | Store and version models | Staging, production, archived |
| **Real-time Serving** | Low-latency predictions | REST/gRPC endpoints, auto-scaling |
| **Batch Inference** | High-throughput predictions | Scheduled, large-scale processing |
| **Edge Deployment** | On-device inference | Optimized models, offline capability |

### Monitoring Layer

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Performance Monitoring** | Track prediction quality | Accuracy, latency, throughput |
| **Data Drift Detection** | Detect input distribution changes | Statistical tests, feature monitoring |
| **Model Drift Detection** | Detect output quality degradation | Prediction distribution, concept drift |
| **Alerting** | Notify on issues | Thresholds, anomaly detection |

---

## AWS Implementation

### Core Services

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **ML Platform** | Amazon SageMaker | End-to-end ML platform |
| **Feature Store** | SageMaker Feature Store | Online and offline feature storage |
| **Experiment Tracking** | SageMaker Experiments | Track training runs and metrics |
| **Training** | SageMaker Training Jobs | Managed training infrastructure |
| **Tuning** | SageMaker Hyperparameter Tuning | Automated hyperparameter optimization |
| **Model Registry** | SageMaker Model Registry | Model versioning and approval |
| **Serving** | SageMaker Endpoints | Real-time and serverless inference |
| **Batch** | SageMaker Batch Transform | Large-scale batch inference |
| **Pipelines** | SageMaker Pipelines | ML workflow orchestration |
| **Monitoring** | SageMaker Model Monitor | Data and model quality monitoring |

### Architecture Pattern

- S3 stores raw data and training datasets
- SageMaker Processing jobs handle data preparation
- Feature Store provides online (DynamoDB) and offline (S3) feature serving
- SageMaker Training jobs run on managed GPU instances
- SageMaker Experiments tracks all training runs
- Model Registry manages model versions with approval workflow
- SageMaker Endpoints serve models with auto-scaling
- Model Monitor detects data quality, model quality, and bias drift

### SageMaker Pipeline Example

```python
from sagemaker.workflow.pipeline import Pipeline
from sagemaker.workflow.steps import ProcessingStep, TrainingStep

pipeline = Pipeline(
    name="ml-pipeline",
    steps=[
        processing_step,   # Data preparation
        training_step,     # Model training
        evaluation_step,   # Model evaluation
        condition_step,    # Check metrics threshold
        register_step,     # Register in model registry
        deploy_step        # Deploy to endpoint
    ]
)
```

**Documentation:**
- [Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)
- [SageMaker Pipelines](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)
- [SageMaker Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)
- [SageMaker Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)

---

## Azure Implementation

### Core Services

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **ML Platform** | Azure Machine Learning | End-to-end ML platform |
| **Feature Store** | Azure ML Managed Feature Store | Feature management |
| **Experiment Tracking** | Azure ML Experiments | Track runs and metrics |
| **Training** | Azure ML Compute Clusters | Managed training compute |
| **Tuning** | Azure ML Hyperparameter Tuning (HyperDrive) | Automated tuning |
| **Model Registry** | Azure ML Model Registry | Model versioning |
| **Serving** | Azure ML Managed Endpoints | Real-time and batch endpoints |
| **Pipelines** | Azure ML Pipelines | ML workflow orchestration |
| **Monitoring** | Azure ML Data Collector + Monitoring | Model monitoring |
| **Responsible AI** | Responsible AI Dashboard | Fairness, interpretability |

### Architecture Pattern

- ADLS Gen2 or Blob Storage for data storage
- Azure ML Datasets for versioned training data
- Azure ML Compute Clusters with GPU VMs for training
- Managed Feature Store for feature engineering and serving
- MLflow integration for experiment tracking (built into Azure ML)
- Managed Online Endpoints for real-time inference with auto-scaling
- Batch Endpoints for scheduled large-scale predictions
- Data Collector captures inference data for monitoring

**Documentation:**
- [Azure Machine Learning](https://learn.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure ML Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines)
- [Managed Feature Store](https://learn.microsoft.com/en-us/azure/machine-learning/concept-what-is-managed-feature-store)
- [Managed Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/concept-endpoints-online)

---

## GCP Implementation

### Core Services

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **ML Platform** | Vertex AI | Unified ML platform |
| **Feature Store** | Vertex AI Feature Store | Online and offline features |
| **Experiment Tracking** | Vertex AI Experiments | Track training runs |
| **Training** | Vertex AI Training | Custom and AutoML training |
| **Tuning** | Vertex AI Vizier | Hyperparameter optimization |
| **Model Registry** | Vertex AI Model Registry | Model versioning |
| **Serving** | Vertex AI Prediction | Online and batch prediction |
| **Pipelines** | Vertex AI Pipelines (Kubeflow) | ML workflow orchestration |
| **Monitoring** | Vertex AI Model Monitoring | Drift and quality monitoring |
| **AutoML** | Vertex AI AutoML | Automated model building |

### Architecture Pattern

- GCS stores raw data and training datasets
- BigQuery for feature computation and analysis
- Vertex AI Feature Store serves features for training and serving
- Vertex AI Training runs on managed GPU/TPU instances
- Vertex AI Experiments with TensorBoard integration
- Model Registry manages versions with deployment targets
- Vertex AI Prediction endpoints with traffic splitting for A/B tests
- Model Monitoring tracks feature skew and prediction drift

### Vertex AI Pipeline Example

```python
from kfp.v2 import dsl
from google_cloud_pipeline_components.v1.custom_job import CustomTrainingJobOp

@dsl.pipeline(name="ml-pipeline")
def pipeline():
    data_prep = data_preparation_op(input_data=...)
    training = CustomTrainingJobOp(
        display_name="model-training",
        worker_pool_specs=[...],
    )
    evaluation = model_evaluation_op(model=training.outputs["model"])
    deployment = model_deploy_op(model=evaluation.outputs["model"])
```

**Documentation:**
- [Vertex AI](https://cloud.google.com/vertex-ai/docs/start/introduction-unified-platform)
- [Vertex AI Pipelines](https://cloud.google.com/vertex-ai/docs/pipelines/introduction)
- [Vertex AI Feature Store](https://cloud.google.com/vertex-ai/docs/featurestore/overview)
- [Vertex AI Model Monitoring](https://cloud.google.com/vertex-ai/docs/model-monitoring/overview)

---

## MLOps Practices

### Version Control

- **Code**: All training code, pipeline definitions, and configurations in Git
- **Data**: Version training datasets using DVC, Delta Lake, or platform tools
- **Models**: Version models in model registry with metadata
- **Experiments**: Track all experiment parameters and results
- **Infrastructure**: IaC for all ML infrastructure (Terraform, CloudFormation)

### CI/CD for ML

| Stage | Traditional CI/CD | ML CI/CD |
|-------|------------------|----------|
| **Source** | Code changes | Code + data + model changes |
| **Build** | Compile, package | Build training container |
| **Test** | Unit, integration tests | Unit tests + data validation + model tests |
| **Deploy** | Deploy application | Deploy model + monitor |
| **Monitor** | Application metrics | Model metrics + data drift |

### Testing Strategies

- **Unit Tests**: Test feature engineering functions and data transformations
- **Data Tests**: Validate data schema, distributions, and quality
- **Model Tests**: Check model accuracy against baselines and test sets
- **Integration Tests**: Verify end-to-end pipeline execution
- **Shadow Testing**: Run new models alongside production without serving
- **A/B Testing**: Gradually route traffic to new model versions

---

## Feature Stores

### Online vs Offline Serving

| Aspect | Online Store | Offline Store |
|--------|-------------|---------------|
| **Latency** | Milliseconds | Seconds to minutes |
| **Use Case** | Real-time inference | Training, batch inference |
| **Storage** | Key-value (DynamoDB, Bigtable) | Data lake (S3, GCS) |
| **Freshness** | Near real-time | Batch updated |
| **Scale** | High throughput reads | Large scan operations |

### Feature Store Benefits

- **Consistency**: Same features used in training and serving
- **Reusability**: Features shared across teams and models
- **Discovery**: Catalog of available features with documentation
- **Time Travel**: Access point-in-time correct features for training
- **Monitoring**: Track feature freshness and quality

### Cross-Cloud Comparison

| Feature | SageMaker Feature Store | Azure ML Feature Store | Vertex AI Feature Store |
|---------|------------------------|----------------------|------------------------|
| **Online Store** | DynamoDB | Managed (Azure SQL) | Bigtable |
| **Offline Store** | S3 (Parquet) | ADLS Gen2 | BigQuery |
| **Streaming Ingestion** | Kinesis | Event Hubs | Pub/Sub |
| **Point-in-Time** | Yes | Yes | Yes |
| **Feature Sharing** | Cross-account | Cross-workspace | Cross-project |

---

## Model Monitoring

### Types of Drift

| Drift Type | Description | Detection Method |
|-----------|-------------|-----------------|
| **Data Drift** | Input feature distributions change | Statistical tests (KS, PSI, Chi-squared) |
| **Concept Drift** | Relationship between features and target changes | Monitor prediction accuracy over time |
| **Prediction Drift** | Model output distribution changes | Compare prediction distributions |
| **Feature Skew** | Training vs serving feature differences | Compare training and serving statistics |

### Monitoring Strategy

1. **Baseline**: Capture statistics from training data as the baseline
2. **Capture**: Log all inference inputs and outputs
3. **Analyze**: Compare current data against baseline periodically
4. **Alert**: Notify when drift exceeds thresholds
5. **Investigate**: Root cause analysis of drift
6. **Retrain**: Trigger automated or manual retraining

### Key Metrics to Monitor

- **Model Performance**: Accuracy, precision, recall, F1, AUC (when labels available)
- **Prediction Distribution**: Mean, variance, percentiles of predictions
- **Feature Statistics**: Mean, standard deviation, null rate, cardinality
- **Operational Metrics**: Latency, throughput, error rate, GPU utilization
- **Business Metrics**: Revenue impact, customer satisfaction, conversion rate

---

## Cost Estimation

### AWS (Monthly Estimate - Moderate ML Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Training | SageMaker (ml.g4dn.xlarge, 100 hrs) | ~$530/month |
| Feature Store | Online + Offline | ~$100-300/month |
| Serving | SageMaker Endpoint (ml.m5.large) | ~$100/month |
| Storage | S3 (1 TB training data) | ~$23/month |
| Pipelines | SageMaker Pipelines | ~$50/month |
| Monitoring | Model Monitor | ~$50/month |
| **Total** | | **~$850-1,050/month** |

### Azure (Monthly Estimate - Moderate ML Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Training | Compute Cluster (NC6s, 100 hrs) | ~$600/month |
| Feature Store | Managed Feature Store | ~$100-200/month |
| Serving | Managed Endpoint | ~$100/month |
| Storage | Blob Storage (1 TB) | ~$21/month |
| Pipelines | Azure ML Pipelines | ~$50/month |
| **Total** | | **~$870-970/month** |

### GCP (Monthly Estimate - Moderate ML Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Training | Vertex AI (n1-standard-4 + T4, 100 hrs) | ~$450/month |
| Feature Store | Online + Offline | ~$100-200/month |
| Serving | Vertex AI Prediction | ~$80/month |
| Storage | GCS (1 TB) | ~$20/month |
| Pipelines | Vertex AI Pipelines | ~$50/month |
| Monitoring | Model Monitoring | ~$50/month |
| **Total** | | **~$750-850/month** |

---

## Production Checklist

### Data Pipeline

- [ ] Data ingestion pipeline automated and scheduled
- [ ] Data validation checks implemented
- [ ] Data versioning in place
- [ ] Feature engineering pipeline automated
- [ ] Feature store configured (online and offline)
- [ ] Data quality monitoring active

### Model Training

- [ ] Training pipeline automated with SageMaker/Azure ML/Vertex AI Pipelines
- [ ] Experiment tracking configured
- [ ] Hyperparameter tuning integrated
- [ ] Distributed training configured for large models
- [ ] Spot/preemptible instances used for cost savings
- [ ] Training reproducibility verified

### Model Management

- [ ] Model registry configured with approval workflow
- [ ] Model versioning with metadata and lineage
- [ ] Model evaluation criteria defined (minimum metrics)
- [ ] Model documentation and model cards created
- [ ] Responsible AI checks (bias, fairness) implemented

### Deployment

- [ ] Serving infrastructure deployed with auto-scaling
- [ ] A/B testing or canary deployment configured
- [ ] Rollback procedure tested
- [ ] Inference latency and throughput benchmarks met
- [ ] Shadow deployment for new models before full rollout

### Monitoring and Operations

- [ ] Data drift detection configured
- [ ] Model performance monitoring active
- [ ] Alerting thresholds defined and tested
- [ ] Retraining triggers configured (scheduled or drift-based)
- [ ] Cost monitoring and optimization in place
- [ ] Incident response runbooks documented

---

**Related Guides:**
- [Data Pipeline ETL Architecture](./data-pipeline-etl.md)
- [Lakehouse Architecture](./lakehouse-architecture.md)
- [Service Comparison - AI/ML](../service-comparison-ai-ml.md)
