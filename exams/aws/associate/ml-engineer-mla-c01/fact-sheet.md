---
last-updated: 2026-05-03
---

# AWS Certified Machine Learning Engineer - Associate (MLA-C01) Fact Sheet

## 📋 Exam Overview

**Exam Code:** MLA-C01
**Exam Name:** AWS Certified Machine Learning Engineer - Associate
**Duration:** 170 minutes (2 hours 50 minutes)
**Questions:** 65 questions
**Question Format:** Multiple choice and multiple response
**Passing Score:** 720/1000 (scaled scoring, approximately 72%)
**Cost:** $150 USD (50% discount for previous AWS certification holders)
**Valid For:** 3 years
**Prerequisites:** None required, but 1+ years experience with SageMaker recommended
**Language:** Available in English, with more languages coming
**Delivery:** Pearson VUE (online proctored or testing center)
**Launch Date:** April 2025

**📖 [Official Exam Page](https://aws.amazon.com/certification/certified-machine-learning-engineer-associate/)** - Registration and details
**📖 [Exam Guide PDF](https://d1.awsstatic.com/training-and-certification/docs-ml-engineer-associate/AWS-Certified-Machine-Learning-Engineer-Associate_Exam-Guide.pdf)** - Detailed exam objectives
**📖 [Sample Questions](https://d1.awsstatic.com/training-and-certification/docs-ml-engineer-associate/AWS-Certified-Machine-Learning-Engineer-Associate_Sample-Questions.pdf)** - Official practice questions

## 🎯 Target Audience

This certification is designed for:
- ML engineers deploying and maintaining ML models in production
- Data scientists moving into ML engineering roles
- Software engineers working with ML pipelines
- DevOps engineers managing ML infrastructure
- MLOps professionals implementing ML workflows

**Recommended Experience:**
- 1+ years working with Amazon SageMaker
- Experience with ML model development and deployment
- Understanding of MLOps practices
- Familiarity with AWS infrastructure services
- Python programming skills

**📖 [ML Engineering Learning Path](https://aws.amazon.com/training/learn-about/machine-learning/)** - Official learning path
**📖 [Amazon SageMaker](https://aws.amazon.com/sagemaker/)** - ML platform overview

## 📚 Exam Domains

### Domain 1: Data Preparation for Machine Learning (28%)

This is the largest domain, covering data ingestion, transformation, and preparation.

#### 1.1 Data Ingestion and Storage

**Data Sources:**
- S3 for object storage
- RDS and Redshift for structured data
- DynamoDB for NoSQL data
- Kinesis for streaming data
- AWS Glue Data Catalog for metadata

**📖 [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)** - Object storage
**📖 [S3 for ML](https://docs.aws.amazon.com/sagemaker/latest/dg/model-access-training-data.html)** - ML data storage
**📖 [Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)** - Relational databases
**📖 [Amazon Redshift](https://docs.aws.amazon.com/redshift/latest/mgmt/welcome.html)** - Data warehouse
**📖 [Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)** - NoSQL database
**📖 [Amazon Kinesis](https://docs.aws.amazon.com/kinesis/latest/dev/introduction.html)** - Streaming data

#### 1.2 Data Transformation with AWS Glue

**AWS Glue Components:**
- Glue Data Catalog
- Glue ETL jobs
- Glue DataBrew for visual data prep
- Glue crawlers for schema discovery
- Glue Studio for workflow creation

**📖 [AWS Glue](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)** - ETL service
**📖 [Glue ETL](https://docs.aws.amazon.com/glue/latest/dg/author-job.html)** - ETL jobs
**📖 [AWS Glue DataBrew](https://docs.aws.amazon.com/databrew/latest/dg/what-is.html)** - Visual data preparation
**📖 [Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)** - Schema discovery
**📖 [Glue Studio](https://docs.aws.amazon.com/glue/latest/ug/what-is-glue-studio.html)** - Visual workflow

#### 1.3 Data Preprocessing with SageMaker

**SageMaker Data Wrangler:**
- Visual data exploration
- Data transformation flows
- Feature engineering
- Export to SageMaker Processing or Pipelines

**📖 [SageMaker Data Wrangler](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler.html)** - Data preparation
**📖 [Data Wrangler Transformations](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler-transform.html)** - Transform data
**📖 [Data Wrangler Export](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler-data-export.html)** - Export options

**SageMaker Processing:**
- Distributed data processing
- Custom preprocessing scripts
- Built-in containers (scikit-learn, pandas)
- Integration with Spark

**📖 [SageMaker Processing](https://docs.aws.amazon.com/sagemaker/latest/dg/processing-job.html)** - Data processing jobs
**📖 [Processing Containers](https://docs.aws.amazon.com/sagemaker/latest/dg/processing-container-run-scripts.html)** - Using containers
**📖 [Spark Processing](https://docs.aws.amazon.com/sagemaker/latest/dg/use-spark-processing-container.html)** - Spark integration

#### 1.4 Feature Engineering

**Feature Store:**
- Online and offline feature stores
- Feature groups and definitions
- Feature versioning
- Real-time and batch access

**📖 [SageMaker Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)** - Feature management
**📖 [Feature Groups](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-create-feature-group.html)** - Creating features
**📖 [Feature Store Access](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-use-with-training.html)** - Using features

**Feature Engineering Techniques:**
- Encoding categorical variables
- Scaling and normalization
- Feature selection
- Dimensionality reduction
- Handling missing data

**📖 [Built-in Algorithms](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)** - SageMaker algorithms

#### 1.5 Data Validation and Quality

**Data Quality Checks:**
- Schema validation
- Data profiling
- Anomaly detection
- Distribution checks
- Missing value analysis

**📖 [SageMaker Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - Data quality monitoring
**📖 [Data Quality Monitoring](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)** - Quality metrics
**📖 [SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-processing-job-run.html)** - Data analysis

### Domain 2: ML Model Development (26%)

Covers model selection, training, and tuning.

#### 2.1 Selecting ML Approaches

**Problem Types:**
- Supervised learning (classification, regression)
- Unsupervised learning (clustering, anomaly detection)
- Reinforcement learning
- Deep learning approaches

**📖 [ML Concepts](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-mlconcepts.html)** - ML fundamentals
**📖 [Algorithm Selection](https://docs.aws.amazon.com/sagemaker/latest/dg/algorithms-choose.html)** - Choosing algorithms

**Built-in Algorithms:**
- XGBoost for tabular data
- Linear Learner for classification/regression
- Image Classification for computer vision
- Object Detection (SSD)
- Seq2Seq for NLP

**📖 [Built-in Algorithms](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)** - Algorithm reference
**📖 [XGBoost](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost.html)** - Gradient boosting
**📖 [Linear Learner](https://docs.aws.amazon.com/sagemaker/latest/dg/linear-learner.html)** - Linear models
**📖 [Image Classification](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)** - Computer vision
**📖 [BlazingText](https://docs.aws.amazon.com/sagemaker/latest/dg/blazingtext.html)** - Text classification

#### 2.2 Training Models with SageMaker

**Training Job Configuration:**
- Choosing instance types
- Distributed training strategies
- Spot instances for cost optimization
- Checkpointing and resuming
- Input/output data configuration

**📖 [SageMaker Training](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)** - Training overview
**📖 [Training Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)** - Creating training jobs
**📖 [Distributed Training](https://docs.aws.amazon.com/sagemaker/latest/dg/distributed-training.html)** - Multi-node training
**📖 [Managed Spot Training](https://docs.aws.amazon.com/sagemaker/latest/dg/model-managed-spot-training.html)** - Cost optimization
**📖 [Checkpointing](https://docs.aws.amazon.com/sagemaker/latest/dg/model-checkpoints.html)** - Save training state

**Custom Training:**
- Bring Your Own Container (BYOC)
- Script mode with framework containers
- Using TensorFlow, PyTorch, MXNet
- Custom training scripts

**📖 [Bring Your Own Container](https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-training-algo.html)** - Custom containers
**📖 [TensorFlow on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/tf.html)** - TensorFlow framework
**📖 [PyTorch on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/pytorch.html)** - PyTorch framework
**📖 [Script Mode](https://docs.aws.amazon.com/sagemaker/latest/dg/adapt-training-container.html)** - Framework containers

#### 2.3 Hyperparameter Tuning

**SageMaker Automatic Model Tuning:**
- Hyperparameter search strategies
- Bayesian optimization
- Random search
- Warm start tuning
- Early stopping

**📖 [Hyperparameter Tuning](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning.html)** - HPO overview
**📖 [Tuning Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning-how-it-works.html)** - How it works
**📖 [Warm Start](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning-warm-start.html)** - Transfer learning
**📖 [Early Stopping](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning-early-stopping.html)** - Stop poorly performing jobs

#### 2.4 Model Evaluation

**Evaluation Metrics:**
- Classification: Accuracy, precision, recall, F1, AUC-ROC
- Regression: RMSE, MAE, R²
- Clustering: Silhouette score, Davies-Bouldin
- Custom metrics

**📖 [Model Evaluation](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html)** - Model quality
**📖 [SageMaker Experiments](https://docs.aws.amazon.com/sagemaker/latest/dg/experiments.html)** - Experiment tracking
**📖 [SageMaker Debugger](https://docs.aws.amazon.com/sagemaker/latest/dg/train-debugger.html)** - Training insights

#### 2.5 Model Versioning and Registry

**SageMaker Model Registry:**
- Registering model versions
- Model approval workflows
- Model lineage tracking
- Metadata management

**📖 [Model Registry](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html)** - Model versioning
**📖 [Model Packages](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-version.html)** - Creating packages
**📖 [Model Approval](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-approve.html)** - Approval workflows
**📖 [SageMaker Lineage](https://docs.aws.amazon.com/sagemaker/latest/dg/lineage-tracking.html)** - Track artifacts

### Domain 3: Deployment and Orchestration (24%)

Covers model deployment, endpoints, and ML pipelines.

#### 3.1 Model Deployment Options

**Real-Time Inference:**
- SageMaker Endpoints
- Multi-model endpoints
- Multi-container endpoints
- Serverless inference
- Auto-scaling configuration

**📖 [SageMaker Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html)** - Deployment overview
**📖 [Real-Time Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html)** - Hosting models
**📖 [Multi-Model Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/multi-model-endpoints.html)** - Multiple models
**📖 [Serverless Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/serverless-endpoints.html)** - Serverless deployment
**📖 [Auto Scaling](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-auto-scaling.html)** - Scale endpoints

**Batch Inference:**
- Batch Transform jobs
- Large-scale predictions
- Output configuration
- Data filtering

**📖 [Batch Transform](https://docs.aws.amazon.com/sagemaker/latest/dg/batch-transform.html)** - Batch predictions
**📖 [Transform Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-batch.html)** - How it works

**Asynchronous Inference:**
- Long-running predictions
- Queue-based invocations
- Large payload support

**📖 [Async Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/async-inference.html)** - Asynchronous endpoints

#### 3.2 ML Model Optimization

**Model Optimization Techniques:**
- SageMaker Neo for compilation
- Model quantization
- Edge deployment with SageMaker Edge
- Inference optimization

**📖 [SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)** - Model optimization
**📖 [Neo Compilation](https://docs.aws.amazon.com/sagemaker/latest/dg/neo-job-compilation.html)** - Compile models
**📖 [Edge Manager](https://docs.aws.amazon.com/sagemaker/latest/dg/edge.html)** - Edge deployment

#### 3.3 ML Pipelines and Orchestration

**SageMaker Pipelines:**
- Pipeline creation and execution
- Pipeline steps (processing, training, tuning, etc.)
- Conditional execution
- Pipeline parameters
- CI/CD integration

**📖 [SageMaker Pipelines](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)** - ML workflows
**📖 [Pipeline Steps](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-steps.html)** - Defining steps
**📖 [Conditional Steps](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-steps.html#step-type-condition)** - Logic in pipelines
**📖 [Pipeline Parameters](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-parameters.html)** - Parameterization

**AWS Step Functions for ML:**
- State machine orchestration
- Parallel training jobs
- Error handling and retries
- SageMaker integration

**📖 [Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)** - Workflow orchestration
**📖 [Step Functions ML](https://docs.aws.amazon.com/step-functions/latest/dg/connect-sagemaker.html)** - SageMaker integration

#### 3.4 Infrastructure Management

**Compute Selection:**
- Training instance types
- Inference instance types
- GPU instances (P3, P4, G4)
- Inferentia instances (Inf1, Inf2)
- Graviton instances

**📖 [Instance Types](https://aws.amazon.com/sagemaker/pricing/)** - Pricing and types
**📖 [GPU Instances](https://docs.aws.amazon.com/sagemaker/latest/dg/training-compiler-support.html)** - Accelerated computing
**📖 [AWS Inferentia](https://aws.amazon.com/machine-learning/inferentia/)** - ML inference chips

**Container Management:**
- SageMaker managed containers
- Custom container registries (ECR)
- Container optimization
- Security scanning

**📖 [Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)** - Container registry
**📖 [Container Security](https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam.html)** - Secure containers

#### 3.5 CI/CD for ML

**MLOps Automation:**
- CodePipeline for ML
- CodeBuild for model building
- CodeDeploy for model deployment
- Integration with SageMaker Projects

**📖 [SageMaker Projects](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html)** - MLOps templates
**📖 [MLOps Workflows](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates.html)** - Project templates
**📖 [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)** - CI/CD automation

### Domain 4: ML Solution Monitoring, Maintenance, and Security (22%)

Covers monitoring, security, and ongoing maintenance.

#### 4.1 Model Monitoring

**SageMaker Model Monitor:**
- Data quality monitoring
- Model quality monitoring
- Bias drift detection
- Feature attribution drift
- Real-time monitoring

**📖 [Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - Monitoring overview
**📖 [Data Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)** - Data drift
**📖 [Model Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html)** - Performance drift
**📖 [Bias Drift](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-model-monitor-bias-drift.html)** - Fairness monitoring
**📖 [Capture Data](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-capture.html)** - Endpoint data

#### 4.2 Logging and Observability

**CloudWatch Integration:**
- Training and endpoint metrics
- Log aggregation
- Alarms and notifications
- Custom metrics

**📖 [CloudWatch Metrics](https://docs.aws.amazon.com/sagemaker/latest/dg/monitoring-cloudwatch.html)** - SageMaker metrics
**📖 [CloudWatch Logs](https://docs.aws.amazon.com/sagemaker/latest/dg/logging-cloudwatch.html)** - Log collection
**📖 [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Alerting

**AWS X-Ray for ML:**
- Distributed tracing
- Performance analysis
- Bottleneck identification

**📖 [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)** - Application tracing

#### 4.3 Model Retraining and Updates

**Retraining Strategies:**
- Scheduled retraining
- Trigger-based retraining
- Online learning approaches
- A/B testing and canary deployments

**📖 [Model Retraining](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-scheduling.html)** - Retraining pipelines
**📖 [Endpoint Updates](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)** - Safe deployment

**Deployment Strategies:**
- Blue/green deployments
- Canary deployments
- Shadow deployments
- Traffic shifting

**📖 [Deployment Guardrails](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)** - Safe updates
**📖 [Traffic Routing](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-routing-create.html)** - Production variants

#### 4.4 Security Best Practices

**Data Security:**
- Encryption at rest (S3, EBS)
- Encryption in transit (TLS)
- AWS KMS for key management
- VPC endpoints for private connectivity

**📖 [Security in SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/security.html)** - Security overview
**📖 [Data Encryption](https://docs.aws.amazon.com/sagemaker/latest/dg/encryption-at-rest.html)** - Encryption
**📖 [VPC Configuration](https://docs.aws.amazon.com/sagemaker/latest/dg/infrastructure-connect-to-resources.html)** - Private networking
**📖 [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key management

**IAM and Access Control:**
- IAM roles for SageMaker
- Resource-based policies
- Service Control Policies (SCPs)
- Fine-grained permissions

**📖 [IAM for SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam.html)** - Access control
**📖 [IAM Roles](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html)** - Execution roles
**📖 [Least Privilege](https://docs.aws.amazon.com/sagemaker/latest/dg/security_iam_id-based-policy-examples.html)** - Policy examples

#### 4.5 Compliance and Governance

**Model Governance:**
- Model cards for documentation
- SageMaker Model Registry
- Audit trails with CloudTrail
- Compliance certifications

**📖 [Model Cards](https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html)** - Model documentation
**📖 [CloudTrail Logging](https://docs.aws.amazon.com/sagemaker/latest/dg/logging-using-cloudtrail.html)** - API auditing
**📖 [Compliance](https://aws.amazon.com/compliance/)** - AWS compliance programs

**Responsible AI:**
- SageMaker Clarify for bias detection
- Explainability and interpretability
- Fairness metrics
- Human-in-the-loop workflows

**📖 [SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-fairness-and-explainability.html)** - Bias and explainability
**📖 [Explainability](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-model-explainability.html)** - SHAP values
**📖 [Ground Truth](https://docs.aws.amazon.com/sagemaker/latest/dg/sms.html)** - Data labeling

## 💡 Study Strategy

### Recommended Timeline (8-10 weeks, 12-18 hours/week)

**Weeks 1-3: Data Preparation and Feature Engineering**
- Study data ingestion and storage
- Learn AWS Glue and SageMaker Data Wrangler
- Practice feature engineering
- Work with Feature Store
- Study time: 15 hours/week

**Weeks 4-6: Model Development and Training**
- Study SageMaker built-in algorithms
- Practice training jobs
- Learn hyperparameter tuning
- Work with model registry
- Study time: 18 hours/week

**Weeks 7-8: Deployment and Pipelines**
- Study endpoint deployment options
- Learn SageMaker Pipelines
- Practice CI/CD for ML
- Build end-to-end workflows
- Study time: 15 hours/week

**Weeks 9-10: Monitoring, Security, and Review**
- Study Model Monitor
- Learn security best practices
- Take practice exams (aim for 75%+)
- Review weak areas
- Study time: 12-15 hours/week

### Study Resources

**Official AWS Training:**
**📖 [AWS Skill Builder](https://skillbuilder.aws/)** - Free AWS training
**📖 [ML Engineer Learning Plan](https://explore.skillbuilder.aws/learn/learning_plan/view/2191/machine-learning-engineer-learning-plan)** - Official study plan
**📖 [Exam Prep Course](https://aws.amazon.com/training/classroom/exam-prep-aws-certified-machine-learning-engineer-associate-mla-c01/)** - Official exam prep

**Hands-On Practice:**
- Build end-to-end ML pipelines in SageMaker
- Deploy models with different inference options
- Set up Model Monitor for drift detection
- Create MLOps workflows with SageMaker Projects
- Practice with SageMaker Studio

**📖 [SageMaker Examples](https://github.com/aws/amazon-sagemaker-examples)** - GitHub examples
**📖 [SageMaker Immersion Day](https://catalog.us-east-1.prod.workshops.aws/workshops/63069e26-921c-4ce1-9cc7-dd882ff62575/en-US)** - Hands-on workshop

## 🎯 Exam Day Tips

### Preparation
- Review SageMaker service limits and quotas
- Know endpoint deployment options
- Understand pipeline orchestration
- Review Model Monitor capabilities
- Get adequate rest before exam

### During Exam
- Read questions carefully - focus on ML engineering aspects
- Look for keywords: "MOST cost-effective", "LEAST operational effort"
- Consider scalability and production requirements
- Eliminate wrong answers first
- Flag uncertain questions for review
- Manage time: ~2.6 minutes per question

### Common Question Patterns
- Data preparation and feature engineering workflows
- Choosing appropriate training configurations
- Deployment strategy selection
- Pipeline orchestration and automation
- Monitoring and retraining strategies
- Security and access control
- Cost optimization approaches

### Technical Setup (Online Proctoring)
- Stable internet connection
- Webcam and microphone required
- Clear workspace
- Government-issued photo ID
- Close all applications
- 170 minutes - plan breaks strategically

**📖 [Certification Preparation](https://aws.amazon.com/certification/certified-machine-learning-engineer-associate/)** - Official resources

## 🚀 After Certification

### Career Benefits
- Demonstrates ML engineering expertise
- Validates SageMaker proficiency
- Opens MLOps and ML Engineer roles
- Industry recognition for ML production skills

### Next Certifications
**📖 [AWS Machine Learning Specialty](https://aws.amazon.com/certification/certified-machine-learning-specialty/)** - Advanced ML certification
**📖 [AWS Solutions Architect Professional](https://aws.amazon.com/certification/certified-solutions-architect-professional/)** - Architecture mastery
**📖 [AWS DevOps Engineer Professional](https://aws.amazon.com/certification/certified-devops-engineer-professional/)** - DevOps focus

### Continuous Learning
- Follow AWS Machine Learning blog
- Experiment with new SageMaker features
- Attend re:Invent ML sessions
- Build production ML systems
- Join MLOps communities

**📖 [AWS ML Blog](https://aws.amazon.com/blogs/machine-learning/)** - Latest updates
**📖 [SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)** - Complete documentation

---

## 📊 Quick Reference

### Exam Details at a Glance
- **65 questions** in **170 minutes** = **~2.6 minutes per question**
- **720/1000 to pass** = Approximately **72%**
- **28% Data preparation** = ~18 questions
- **26% Model development** = ~17 questions
- **24% Deployment** = ~16 questions
- **22% Monitoring & security** = ~14 questions

### Key SageMaker Components

| Component | Purpose | Use Cases |
|-----------|---------|-----------|
| **Data Wrangler** | Data preparation | Visual data transformation |
| **Processing** | Distributed processing | ETL, feature engineering |
| **Training** | Model training | Distributed training at scale |
| **Pipelines** | ML workflows | End-to-end automation |
| **Endpoints** | Model hosting | Real-time inference |
| **Batch Transform** | Batch inference | Large-scale predictions |
| **Model Monitor** | Monitoring | Drift detection |
| **Feature Store** | Feature management | Feature reuse and sharing |

### Instance Type Selection

| Workload | Instance Family | Example Types |
|----------|----------------|---------------|
| **Training (CPU)** | M5, C5 | ml.m5.xlarge, ml.c5.2xlarge |
| **Training (GPU)** | P3, P4 | ml.p3.2xlarge, ml.p4d.24xlarge |
| **Inference (CPU)** | M5, C5 | ml.m5.large, ml.c5.xlarge |
| **Inference (GPU)** | G4, P3 | ml.g4dn.xlarge, ml.p3.2xlarge |
| **Inference (Optimized)** | Inf1, Inf2 | ml.inf1.xlarge, ml.inf2.xlarge |

---

**Good luck with your AWS Certified Machine Learning Engineer - Associate exam! 🎉**
