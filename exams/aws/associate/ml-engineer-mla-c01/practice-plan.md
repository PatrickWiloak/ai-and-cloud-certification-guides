# AWS ML Engineer Associate (MLA-C01) Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: ML Fundamentals and SageMaker Overview

#### Day 1-2: ML Concepts Review
- [ ] Review supervised vs unsupervised vs reinforcement learning
- [ ] Study classification, regression, and clustering problem types
- [ ] Understand ML lifecycle: data collection → preprocessing → training → evaluation → deployment
- [ ] Review common evaluation metrics (accuracy, precision, recall, F1, RMSE)
- [ ] Explore SageMaker Studio interface

**📖 [What is Machine Learning?](https://docs.aws.amazon.com/machine-learning/latest/dg/what-is-machine-learning.html)** - AWS ML concepts

#### Day 3-4: SageMaker Core Services
- [ ] Study SageMaker Studio environment and notebooks
- [ ] Understand SageMaker domains and user profiles
- [ ] Learn SageMaker execution roles and IAM integration
- [ ] Hands-on: Set up SageMaker Studio domain
- [ ] Explore SageMaker built-in algorithm categories

**📖 [Amazon SageMaker Overview](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)** - Service documentation

#### Day 5-7: SageMaker Data Wrangler and Processing
- [ ] Study Data Wrangler data flows and transformations
- [ ] Learn SageMaker Processing jobs for data prep
- [ ] Understand data formats for ML (CSV, RecordIO, Parquet)
- [ ] Hands-on: Create a data transformation with Data Wrangler
- [ ] Week 1 review and practice questions

---

### Week 2: Data Preparation and Feature Engineering

#### Day 8-9: Feature Store
- [ ] Study SageMaker Feature Store architecture (online + offline)
- [ ] Learn feature group creation and ingestion
- [ ] Understand online vs offline store access patterns
- [ ] Hands-on: Create a feature group and ingest features

**📖 [SageMaker Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)**

#### Day 10-11: AWS Glue for ML Data
- [ ] Study Glue crawlers and Data Catalog for ML datasets
- [ ] Learn Glue ETL jobs for data transformation
- [ ] Understand Glue DataBrew for visual data prep
- [ ] Hands-on: Build a Glue ETL pipeline for ML data

#### Day 12-14: Data Quality and Validation
- [ ] Study data quality assessment techniques
- [ ] Learn handling missing values, outliers, and class imbalance
- [ ] Understand data labeling with SageMaker Ground Truth
- [ ] Practice: End-to-end data prep pipeline
- [ ] Week 2 review and practice questions

---

### Week 3: Model Development

#### Day 15-16: Built-in Algorithms
- [ ] Study XGBoost (classification and regression)
- [ ] Learn Linear Learner (linear models)
- [ ] Understand BlazingText (text classification, Word2Vec)
- [ ] Study Image Classification and Object Detection algorithms
- [ ] Know when to use each built-in algorithm

**📖 [Built-in Algorithms](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)**

#### Day 17-18: Training Jobs
- [ ] Study SageMaker training job configuration
- [ ] Learn instance type selection for training
- [ ] Understand distributed training (data parallel, model parallel)
- [ ] Study Spot Training for cost optimization
- [ ] Hands-on: Run a training job with XGBoost

#### Day 19-21: Hyperparameter Tuning and Autopilot
- [ ] Study SageMaker Automatic Model Tuning
- [ ] Learn Bayesian optimization vs random search
- [ ] Understand SageMaker Autopilot for AutoML
- [ ] Study SageMaker Experiments for tracking
- [ ] Hands-on: Run a hyperparameter tuning job
- [ ] Week 3 review and practice questions

---

### Week 4: Model Deployment and Inference

#### Day 22-23: Deployment Options
- [ ] Study real-time endpoints (single model, multi-model, multi-container)
- [ ] Learn serverless inference endpoints
- [ ] Understand async inference for large payloads
- [ ] Study batch transform for offline inference
- [ ] Compare deployment options and use cases

**📖 [Deploy Models for Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html)**

#### Day 24-25: Inference Optimization
- [ ] Study auto-scaling for SageMaker endpoints
- [ ] Learn SageMaker Neo for model compilation
- [ ] Understand inference pipelines (preprocessing + inference)
- [ ] Study A/B testing with production variants
- [ ] Hands-on: Deploy a model endpoint with auto-scaling

#### Day 26-28: ML Pipelines and CI/CD
- [ ] Study SageMaker Pipelines (steps, conditions, parameters)
- [ ] Learn Model Registry for model versioning and approval
- [ ] Understand CI/CD patterns for ML (CodePipeline integration)
- [ ] Hands-on: Build a SageMaker Pipeline
- [ ] Week 4 review and practice questions

---

### Week 5: Monitoring, Maintenance, and GenAI

#### Day 29-30: Model Monitoring
- [ ] Study SageMaker Model Monitor (data quality, model quality, bias, feature attribution)
- [ ] Learn drift detection (data drift, concept drift)
- [ ] Understand monitoring schedules and alerts
- [ ] Hands-on: Set up Model Monitor for an endpoint

**📖 [SageMaker Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)**

#### Day 31-32: Bias and Explainability
- [ ] Study SageMaker Clarify for bias detection
- [ ] Learn pre-training and post-training bias metrics
- [ ] Understand SHAP values for model explainability
- [ ] Study responsible AI practices on AWS

#### Day 33-35: Amazon Bedrock and Foundation Models
- [ ] Study Amazon Bedrock service overview
- [ ] Learn foundation model selection and invocation
- [ ] Understand fine-tuning foundation models
- [ ] Study Bedrock Knowledge Bases for RAG patterns
- [ ] Week 5 review and practice questions

**📖 [Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)**

---

### Week 6: Review and Practice Exams

#### Day 36-37: Weak Areas Review
- [ ] Review notes on weakest domains
- [ ] Re-do hands-on labs for challenging topics
- [ ] Create flashcards for key service comparisons

#### Day 38-39: Practice Exams
- [ ] Take full-length practice exam #1
- [ ] Review all incorrect answers thoroughly
- [ ] Take full-length practice exam #2
- [ ] Identify remaining gaps

#### Day 40-42: Final Review
- [ ] Review SageMaker service limits and quotas
- [ ] Study exam scenarios and decision frameworks
- [ ] Quick review of all domain key concepts
- [ ] Exam day preparation and logistics

---

## Key Study Resources

- **📖 [MLA-C01 Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-ml-engineer-associate/AWS-Certified-Machine-Learning-Engineer-Associate_Exam-Guide.pdf)** - Official exam objectives
- **📖 [SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)** - Complete documentation
- **📖 [Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)** - GenAI services
- **📖 [AWS ML Blog](https://aws.amazon.com/blogs/machine-learning/)** - Latest ML features and use cases
