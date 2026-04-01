# AWS ML Engineer Associate (MLA-C01) Study Plan

## 10-Week Comprehensive Study Schedule

### Week 1: Data Ingestion and Storage

#### Day 1-2: S3 Data Lake Fundamentals
- [ ] Study S3 as the primary data lake for ML workloads
- [ ] Learn data formats for ML: Parquet, CSV, JSON, RecordIO, TFRecord
- [ ] Understand S3 performance optimization: prefixes, multipart upload
- [ ] Study S3 lifecycle policies for training data management
- [ ] Hands-on: Create S3 data lake with structured and unstructured data
- [ ] Review Notes: `notes/01-data-preparation.md`

#### Day 3-4: Data Ingestion Services
- [ ] Study Kinesis Data Streams and Firehose for streaming data
- [ ] Learn AWS Database Migration Service for database sources
- [ ] Understand data catalog and metadata management
- [ ] Hands-on: Set up Kinesis pipeline to S3 for real-time data
- [ ] Lab: Configure Glue Crawler to catalog S3 data

#### Day 5-6: AWS Glue ETL
- [ ] Study Glue ETL job types: Spark, Python Shell, Ray
- [ ] Learn Glue Data Catalog and crawlers
- [ ] Understand Glue Studio for visual ETL authoring
- [ ] Study Glue DataBrew for visual data preparation
- [ ] Hands-on: Build Glue ETL job to transform raw data
- [ ] Lab: Use Glue DataBrew for data profiling and cleaning

#### Day 7: Week 1 Review and Practice
- [ ] Complete data ingestion practice questions
- [ ] Build end-to-end data pipeline
- [ ] Review any weak areas identified

### Week 2: Data Preparation with SageMaker

#### Day 8-9: SageMaker Data Wrangler
- [ ] Study Data Wrangler import sources and connectors
- [ ] Learn data transformation steps and custom transforms
- [ ] Understand data visualization and analysis features
- [ ] Study export options: Pipeline, Processing, Feature Store
- [ ] Hands-on: Create Data Wrangler flow with transformations
- [ ] Lab: Export Data Wrangler flow to SageMaker Pipeline

#### Day 10-11: SageMaker Processing
- [ ] Study Processing job configuration and containers
- [ ] Learn built-in containers: scikit-learn, Spark, custom
- [ ] Understand distributed processing with Spark on Processing
- [ ] Hands-on: Run Processing job for feature engineering
- [ ] Lab: Implement custom processing container

#### Day 12-13: Feature Engineering Techniques
- [ ] Study encoding methods: one-hot, label, target encoding
- [ ] Learn scaling and normalization techniques
- [ ] Understand feature selection and dimensionality reduction
- [ ] Study handling missing data and outliers
- [ ] Hands-on: Implement feature engineering pipeline
- [ ] Review Notes: `notes/01-data-preparation.md`

#### Day 14: Week 2 Review and Integration
- [ ] Complete data preparation practice questions
- [ ] Design end-to-end feature engineering workflow
- [ ] Practice data quality assessment scenarios

### Week 3: Feature Store and Data Quality

#### Day 15-16: SageMaker Feature Store
- [ ] Study Feature Store concepts: feature groups, records, features
- [ ] Learn online store (low-latency reads) vs offline store (batch)
- [ ] Understand feature group creation and ingestion
- [ ] Study time-travel queries for point-in-time correctness
- [ ] Hands-on: Create feature groups and ingest data
- [ ] Lab: Query features for training and inference

#### Day 17-18: Data Quality and Validation
- [ ] Study SageMaker Data Quality monitoring
- [ ] Learn data profiling and schema validation
- [ ] Understand data distribution checks and statistics
- [ ] Study SageMaker Clarify for data bias detection
- [ ] Hands-on: Set up data quality baseline and monitoring
- [ ] Lab: Run Clarify bias analysis on training data

#### Day 19-20: Data Pipeline Integration
- [ ] Study end-to-end data pipeline patterns
- [ ] Learn pipeline orchestration with SageMaker Pipelines
- [ ] Understand data versioning and lineage tracking
- [ ] Hands-on: Build automated data preparation pipeline
- [ ] Review Notes: `notes/01-data-preparation.md`

#### Day 21: Week 3 Review and Practice
- [ ] Complete Feature Store and data quality practice questions
- [ ] Design complete data preparation architecture
- [ ] Practice data pipeline troubleshooting

### Week 4: Model Development - Training

#### Day 22-23: SageMaker Training Jobs
- [ ] Study training job configuration: instance types, input/output
- [ ] Learn distributed training: data parallelism, model parallelism
- [ ] Understand managed Spot training for cost optimization
- [ ] Study checkpointing for training resumption
- [ ] Hands-on: Run training jobs with different configurations
- [ ] Lab: Implement distributed training with data parallelism
- [ ] Review Notes: `notes/02-model-development.md`

#### Day 24-25: Built-in Algorithms
- [ ] Study XGBoost for tabular classification and regression
- [ ] Learn Linear Learner for linear models
- [ ] Understand BlazingText for text classification and Word2Vec
- [ ] Study Image Classification and Object Detection
- [ ] Study K-Means, PCA, and other unsupervised algorithms
- [ ] Hands-on: Train models with multiple built-in algorithms
- [ ] Lab: Compare algorithm performance on same dataset

#### Day 26-27: Custom Training
- [ ] Study Bring Your Own Container (BYOC) requirements
- [ ] Learn Script Mode with framework containers
- [ ] Understand TensorFlow, PyTorch, and Hugging Face on SageMaker
- [ ] Study SageMaker Training Compiler for optimization
- [ ] Hands-on: Train custom model using Script Mode
- [ ] Lab: Build and push custom training container

#### Day 28: Week 4 Review and Integration
- [ ] Complete training practice questions
- [ ] Compare different training approaches
- [ ] Practice instance type selection for training

### Week 5: Model Development - Tuning and Evaluation

#### Day 29-30: Hyperparameter Tuning
- [ ] Study SageMaker Automatic Model Tuning (AMT)
- [ ] Learn search strategies: Bayesian, random, grid, hyperband
- [ ] Understand warm start for tuning job continuation
- [ ] Study early stopping for poorly performing jobs
- [ ] Hands-on: Run hyperparameter tuning jobs
- [ ] Lab: Compare tuning strategies on same model

#### Day 31-32: Model Evaluation and Experiments
- [ ] Study evaluation metrics: accuracy, precision, recall, F1, AUC-ROC
- [ ] Learn regression metrics: RMSE, MAE, R-squared
- [ ] Understand SageMaker Experiments for tracking runs
- [ ] Study SageMaker Debugger for training insights
- [ ] Hands-on: Track experiments and compare models
- [ ] Lab: Use Debugger to analyze training issues

#### Day 33-34: Model Registry and Autopilot
- [ ] Study SageMaker Model Registry for versioning
- [ ] Learn model package groups and approval workflows
- [ ] Understand SageMaker Autopilot for AutoML
- [ ] Study SageMaker JumpStart for pretrained models
- [ ] Hands-on: Register models and set up approval workflow
- [ ] Lab: Run Autopilot experiment and analyze results
- [ ] Review Notes: `notes/02-model-development.md`

#### Day 35: Week 5 Review and Practice
- [ ] Complete model development practice questions
- [ ] Design model training and evaluation workflow
- [ ] Practice model selection scenarios

### Week 6: Deployment - Endpoints and Inference

#### Day 36-37: Real-Time Inference
- [ ] Study SageMaker endpoint creation and configuration
- [ ] Learn multi-model endpoints for cost optimization
- [ ] Understand multi-container endpoints for pipeline inference
- [ ] Study auto-scaling configuration for endpoints
- [ ] Hands-on: Deploy model to real-time endpoint with auto-scaling
- [ ] Lab: Set up multi-model endpoint
- [ ] Review Notes: `notes/03-deployment-orchestration.md`

#### Day 38-39: Batch and Serverless Inference
- [ ] Study Batch Transform for large-scale predictions
- [ ] Learn Serverless Inference for intermittent traffic
- [ ] Understand Asynchronous Inference for large payloads
- [ ] Study inference optimization with SageMaker Neo
- [ ] Hands-on: Run batch transform job on large dataset
- [ ] Lab: Deploy serverless inference endpoint

#### Day 40-41: Deployment Strategies
- [ ] Study blue/green deployments for endpoints
- [ ] Learn canary deployments with traffic shifting
- [ ] Understand shadow deployments for testing
- [ ] Study deployment guardrails and rollback
- [ ] Hands-on: Implement blue/green endpoint update
- [ ] Lab: Configure canary deployment with auto-rollback

#### Day 42: Week 6 Review and Integration
- [ ] Complete deployment practice questions
- [ ] Compare inference options for different scenarios
- [ ] Practice endpoint troubleshooting

### Week 7: ML Pipelines and MLOps

#### Day 43-44: SageMaker Pipelines
- [ ] Study Pipeline steps: Processing, Training, Tuning, Transform
- [ ] Learn conditional steps and parallel execution
- [ ] Understand pipeline parameters and caching
- [ ] Study pipeline execution and monitoring
- [ ] Hands-on: Build end-to-end ML pipeline
- [ ] Lab: Add conditional logic and approval steps

#### Day 45-46: Step Functions and CI/CD
- [ ] Study Step Functions for ML workflow orchestration
- [ ] Learn SageMaker integration with Step Functions
- [ ] Understand CodePipeline for ML CI/CD
- [ ] Study SageMaker Projects and MLOps templates
- [ ] Hands-on: Create Step Functions ML workflow
- [ ] Lab: Set up CI/CD pipeline for model deployment

#### Day 47-48: MLOps Best Practices
- [ ] Study infrastructure management for ML
- [ ] Learn container management with ECR
- [ ] Understand model lineage tracking
- [ ] Study SageMaker Model Cards for documentation
- [ ] Hands-on: Implement complete MLOps workflow
- [ ] Review Notes: `notes/03-deployment-orchestration.md`

#### Day 49: Week 7 Review
- [ ] Complete MLOps practice questions
- [ ] Design automated ML pipeline architecture
- [ ] Practice pipeline troubleshooting scenarios

### Week 8: Monitoring and Maintenance

#### Day 50-51: SageMaker Model Monitor
- [ ] Study data quality monitoring - schema and distribution drift
- [ ] Learn model quality monitoring - accuracy and performance drift
- [ ] Understand bias drift detection with Clarify
- [ ] Study feature attribution drift
- [ ] Hands-on: Set up Model Monitor for deployed endpoint
- [ ] Lab: Configure drift detection alerts
- [ ] Review Notes: `notes/04-monitoring-maintenance.md`

#### Day 52-53: Observability and Retraining
- [ ] Study CloudWatch metrics for SageMaker
- [ ] Learn endpoint logging and monitoring
- [ ] Understand retraining triggers and strategies
- [ ] Study A/B testing for model comparison
- [ ] Hands-on: Build automated retraining pipeline
- [ ] Lab: Implement A/B testing with production variants

#### Day 54-55: Maintenance Strategies
- [ ] Study model versioning and rollback procedures
- [ ] Learn endpoint update strategies
- [ ] Understand data capture for monitoring
- [ ] Study cost optimization for inference
- [ ] Hands-on: Implement model update with rollback capability

#### Day 56: Week 8 Review
- [ ] Complete monitoring and maintenance practice questions
- [ ] Design comprehensive monitoring architecture
- [ ] Practice incident response scenarios

### Week 9: Security, Bedrock, and GenAI

#### Day 57-58: ML Security
- [ ] Study IAM roles for SageMaker execution
- [ ] Learn VPC configuration for training and inference
- [ ] Understand encryption at rest and in transit
- [ ] Study compliance and data privacy for ML
- [ ] Hands-on: Configure SageMaker in VPC with encryption
- [ ] Lab: Implement least-privilege IAM policies
- [ ] Review Notes: `notes/05-security.md`

#### Day 59-60: Amazon Bedrock and Generative AI
- [ ] Study Bedrock foundation models and providers
- [ ] Learn knowledge bases for RAG patterns
- [ ] Understand fine-tuning and customization options
- [ ] Study Agents for Bedrock for autonomous tasks
- [ ] Study Guardrails for responsible AI
- [ ] Hands-on: Build RAG application with Bedrock
- [ ] Lab: Configure Guardrails for content filtering
- [ ] Review Notes: `notes/06-bedrock-genai.md`

#### Day 61-62: Responsible AI
- [ ] Study SageMaker Clarify for bias and explainability
- [ ] Learn SHAP values for feature attribution
- [ ] Understand model cards for documentation
- [ ] Study human-in-the-loop with Ground Truth

#### Day 63: Week 9 Review
- [ ] Complete security and GenAI practice questions
- [ ] Review Bedrock use cases and patterns

### Week 10: Final Review and Exam Preparation

#### Day 64-65: Comprehensive Practice Exams
- [ ] Take official AWS practice exam
- [ ] Complete third-party practice exams
- [ ] Identify and document weak areas
- [ ] Review exam feedback and explanations

#### Day 66-67: Weak Area Remediation
- [ ] Review topics missed in practice exams
- [ ] Re-read relevant notes and documentation
- [ ] Complete additional hands-on labs for weak areas
- [ ] Take targeted practice questions per domain

#### Day 68-69: Final Knowledge Consolidation
- [ ] Review all notes and key concepts
- [ ] Practice end-to-end ML pipeline design
- [ ] Review SageMaker service limits and quotas
- [ ] Take final practice exam (target 80%+)

#### Day 70: Pre-Exam Preparation
- [ ] Light review of key concepts only
- [ ] Confirm exam logistics and requirements
- [ ] Prepare exam day materials and environment
- [ ] Get adequate rest and mental preparation

## Daily Study Routine (3-4 hours/day)

### Recommended Schedule
1. **60 minutes**: Read study materials and AWS documentation
2. **90 minutes**: Hands-on labs with SageMaker
3. **45 minutes**: Practice questions and review
4. **15 minutes**: Note-taking and concept reinforcement

## Progress Tracking

### Weekly Milestones
- [ ] Week 1: Master data ingestion and Glue ETL
- [ ] Week 2: Complete SageMaker data preparation
- [ ] Week 3: Understand Feature Store and data quality
- [ ] Week 4: Train models with built-in and custom algorithms
- [ ] Week 5: Master tuning, evaluation, and model registry
- [ ] Week 6: Deploy with all endpoint types
- [ ] Week 7: Build ML pipelines and MLOps workflows
- [ ] Week 8: Implement monitoring and maintenance
- [ ] Week 9: Secure ML workloads and learn Bedrock
- [ ] Week 10: Ready for exam with 80%+ practice scores

### Practice Exam Targets
- [ ] Week 4 end: Score 60%+ on practice exams
- [ ] Week 7 end: Score 70%+ on practice exams
- [ ] Week 9 end: Score 80%+ on practice exams
- [ ] Week 10 end: Score 85%+ consistently

## Study Resources

**Official:**
- **[MLA-C01 Official Exam Page](https://aws.amazon.com/certification/certified-machine-learning-engineer-associate/)** - Registration
- **[AWS Skill Builder](https://skillbuilder.aws/)** - Free training and labs
- **[SageMaker Documentation](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)** - Service documentation
- **[SageMaker Examples](https://github.com/aws/amazon-sagemaker-examples)** - Code examples

---

## Final Exam Checklist

### One Week Before
- [ ] Complete all practice exams with target scores
- [ ] Review weak areas identified in practice
- [ ] Confirm exam appointment and requirements

### Day Before Exam
- [ ] Light review of key concepts
- [ ] Ensure technology setup works (for online proctoring)
- [ ] Prepare identification and workspace
- [ ] Get adequate sleep

### Exam Day
- [ ] Arrive early or log in 30 minutes before
- [ ] Bring required identification documents
- [ ] Stay calm and manage time (2 minutes per question)
- [ ] Read questions carefully - focus on ML engineering aspects
- [ ] Use elimination strategy for multiple choice
