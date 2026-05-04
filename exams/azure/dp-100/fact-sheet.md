---
last-updated: 2026-05-03
---

# Microsoft Azure Data Scientist Associate (DP-100) - Fact Sheet

## Quick Reference

**Exam Code:** DP-100
**Duration:** 180 minutes (3 hours)
**Questions:** 40-60 questions
**Passing Score:** 700/1000
**Cost:** $165 USD
**Validity:** 1 year (annual renewal required)
**Delivery:** Pearson VUE
**Difficulty:** ⭐⭐⭐⭐⭐ (Advanced ML and MLOps focus with hands-on labs)

## Exam Domain Breakdown

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Design and prepare a machine learning solution | 20-25% | Workspace setup, compute, datastores, security |
| Explore data and train models | 35-40% | Data prep, feature engineering, training, AutoML |
| Prepare models for deployment | 20-25% | Model evaluation, interpretation, responsible AI, registration |
| Deploy and retrain models | 20-25% | Deployment targets, monitoring, MLOps pipelines |

## Key Services by Domain

### Design and Prepare a Machine Learning Solution (20-25%)

**Azure Machine Learning Workspace**
- Central hub for ML development and deployment
- Resource management: Compute, datastores, datasets, models
- Collaborative environment with RBAC integration
- Managed identity support for secure access
- Integration with Azure DevOps and GitHub
- **[📖 Azure ML Workspace Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-workspace)** - Workspace fundamentals
- **[📖 Create Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-workspace)** - Workspace creation and management
- **[📖 Workspace Security](https://learn.microsoft.com/en-us/azure/machine-learning/concept-enterprise-security)** - Enterprise security features
- **[📖 Managed Identity](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-identity-based-service-authentication)** - Identity-based authentication
- **[📖 Workspace Organization](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-quotas)** - Resource quotas and limits

**Compute Resources**
- Compute instances: Development environments with Jupyter, VS Code
- Compute clusters: Auto-scaling training workloads (0 to N nodes)
- Inference clusters: AKS for production deployments
- Attached compute: Use existing VMs or Azure Databricks
- Serverless compute: On-demand compute without management
- **[📖 Compute Targets Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-compute-target)** - Compute options comparison
- **[📖 Compute Instances](https://learn.microsoft.com/en-us/azure/machine-learning/concept-compute-instance)** - Development compute
- **[📖 Compute Clusters](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-attach-compute-cluster)** - Training clusters
- **[📖 Kubernetes Compute](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-attach-kubernetes-anywhere)** - AKS and Arc-enabled Kubernetes
- **[📖 Serverless Compute](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-serverless-compute)** - Managed compute

**Datastores and Datasets**
- Datastores: Connections to Azure storage (Blob, Files, Data Lake, SQL)
- Datasets: Versioned data references (FileDataset, TabularDataset)
- Data access: Credential-based or identity-based authentication
- Data labeling: Built-in labeling projects for ML
- Data drift monitoring: Track data distribution changes
- **[📖 Datastores Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-data)** - Data storage concepts
- **[📖 Register Datastores](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-access-data)** - Connect to storage
- **[📖 Create Datasets](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-register-datasets)** - Dataset creation
- **[📖 Dataset Versions](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-version-track-datasets)** - Version management
- **[📖 Data Labeling](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-labeling-projects)** - Annotation projects

**Development Environments**
- Azure ML Studio: Web-based integrated development environment
- Jupyter notebooks: Interactive Python development
- VS Code integration: Local development with remote compute
- Azure ML SDK v2: Python SDK for programmatic access
- Azure ML CLI v2: Command-line interface for automation
- **[📖 Azure ML Studio](https://learn.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-machine-learning)** - Studio overview
- **[📖 Notebooks in Studio](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks)** - Integrated notebooks
- **[📖 VS Code Extension](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-setup-vs-code)** - Local development
- **[📖 Azure ML SDK v2](https://learn.microsoft.com/en-us/python/api/overview/azure/ai-ml-readme)** - Python SDK reference
- **[📖 Azure ML CLI v2](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-cli)** - CLI reference

**Security and Networking**
- Virtual network integration: Secure workspace access
- Private endpoints: Private connectivity to Azure resources
- Managed identities: Credential-free authentication
- Customer-managed keys: Encryption with your own keys
- Azure Policy integration: Enforce compliance standards
- **[📖 Network Isolation](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet)** - VNet integration
- **[📖 Private Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link)** - Private connectivity
- **[📖 Managed Identity Setup](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-managed-identities)** - Identity configuration
- **[📖 Customer Managed Keys](https://learn.microsoft.com/en-us/azure/machine-learning/concept-customer-managed-keys)** - Encryption keys
- **[📖 Azure Policy for ML](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-integrate-azure-policy)** - Governance

### Explore Data and Train Models (35-40%)

**Data Exploration and Preparation**
- Data profiling: Statistical analysis and visualization
- Missing data handling: Imputation, removal, interpolation
- Outlier detection: Statistical and ML-based methods
- Feature engineering: Create, transform, select features
- Data normalization: Scaling, standardization, encoding
- **[📖 Data Preparation](https://learn.microsoft.com/en-us/azure/machine-learning/concept-data-preparation)** - Data prep overview
- **[📖 Feature Engineering](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-auto-features)** - Feature transformation
- **[📖 Handle Missing Data](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-data-assets)** - Missing value strategies
- **[📖 Data Wrangling](https://learn.microsoft.com/en-us/azure/machine-learning/v1/how-to-designer-transform-data)** - Designer transforms

**Training with Azure ML SDK**
- ScriptRunConfig: Define training job configuration
- Environments: Manage dependencies (Docker, conda, pip)
- Training scripts: Custom Python training code
- Experiment tracking: MLflow integration for logging
- Run history: Track metrics, parameters, artifacts
- **[📖 Train Models SDK](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-model)** - Training fundamentals
- **[📖 Configure Training Runs](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-set-up-training-targets)** - Training configuration
- **[📖 Environment Management](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-environments-v2)** - Dependency management
- **[📖 MLflow Tracking](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-mlflow)** - Experiment tracking
- **[📖 Track Experiments](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-log-view-metrics)** - Metrics and logging

**Automated Machine Learning (AutoML)**
- Classification: Binary and multi-class prediction
- Regression: Continuous value prediction
- Time series forecasting: Sequential data prediction
- Featurization: Automatic feature engineering
- Algorithm selection: Test multiple algorithms automatically
- Ensemble models: Combine multiple models
- **[📖 AutoML Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-automated-ml)** - AutoML fundamentals
- **[📖 AutoML Classification](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-auto-train)** - Classification tasks
- **[📖 AutoML Regression](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-forecast)** - Regression tasks
- **[📖 Time Series Forecasting](https://learn.microsoft.com/en-us/azure/machine-learning/concept-automl-forecasting-methods)** - Forecasting configuration
- **[📖 AutoML Featurization](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-auto-features)** - Feature engineering
- **[📖 AutoML Models](https://learn.microsoft.com/en-us/azure/machine-learning/concept-automl-forecasting-sweeping)** - Algorithm selection

**Hyperparameter Tuning**
- Sampling methods: Grid, random, Bayesian optimization
- Early termination policies: Bandit, median stopping, truncation
- Primary metric: Optimize specific performance metric
- Concurrent runs: Parallel hyperparameter search
- Sweep jobs: Define search space and strategy
- **[📖 Hyperparameter Tuning](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters)** - Tuning fundamentals
- **[📖 Sampling Methods](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters#sampling-the-hyperparameter-space)** - Search strategies
- **[📖 Early Termination](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters#early-termination)** - Stop unpromising runs
- **[📖 Sweep Job Configuration](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters#configure-hyperparameter-tuning)** - Sweep setup

**Distributed Training**
- Data parallelism: Split data across multiple nodes
- Model parallelism: Split model across devices
- Horovod: Distributed deep learning framework
- PyTorch distributed: Native PyTorch distribution
- TensorFlow distributed: Multi-worker strategies
- **[📖 Distributed Training](https://learn.microsoft.com/en-us/azure/machine-learning/concept-distributed-training)** - Distribution strategies
- **[📖 Distributed PyTorch](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-pytorch)** - PyTorch distribution
- **[📖 Distributed TensorFlow](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-tensorflow)** - TensorFlow distribution
- **[📖 Horovod Training](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-distributed-gpu)** - GPU distribution

**Designer (Low-Code ML)**
- Drag-and-drop interface: Visual pipeline building
- Built-in components: Data prep, training, evaluation
- Custom components: Python/R script modules
- Pipeline parameterization: Reusable pipelines
- Real-time and batch inference: Deployment options
- **[📖 Azure ML Designer](https://learn.microsoft.com/en-us/azure/machine-learning/concept-designer)** - Visual ML tool
- **[📖 Designer Components](https://learn.microsoft.com/en-us/azure/machine-learning/component-reference/component-reference)** - Component reference
- **[📖 Custom Components](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-component-pipeline-python)** - Create components
- **[📖 Designer Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-component-pipelines-ui)** - Build pipelines

### Prepare Models for Deployment (20-25%)

**Model Evaluation**
- Classification metrics: Accuracy, precision, recall, F1, AUC
- Regression metrics: RMSE, MAE, R-squared
- Confusion matrix: True/false positives/negatives
- ROC curves: Receiver operating characteristic
- Residual analysis: Error distribution analysis
- **[📖 Model Evaluation](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-understand-automated-ml)** - Evaluation metrics
- **[📖 Classification Metrics](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-understand-automated-ml#classification-metrics)** - Classification evaluation
- **[📖 Regression Metrics](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-understand-automated-ml#regression-and-forecasting-metrics)** - Regression evaluation
- **[📖 Confusion Matrix](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-understand-automated-ml#confusion-matrix)** - Classification matrix

**Model Interpretation and Explainability**
- Model explainability: Understand predictions
- Global importance: Overall feature contributions
- Local importance: Individual prediction explanations
- SHAP values: Game theory-based explanations
- InterpretML: Microsoft's interpretability library
- **[📖 Model Interpretability](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-machine-learning-interpretability)** - Explainability overview
- **[📖 InterpretML](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-machine-learning-interpretability-aml)** - Interpretation methods
- **[📖 SHAP Explanations](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-machine-learning-interpretability-automl)** - SHAP integration
- **[📖 Feature Importance](https://learn.microsoft.com/en-us/azure/machine-learning/v1/how-to-machine-learning-interpretability-aml)** - Feature contributions

**Responsible AI**
- Fairness assessment: Identify and mitigate bias
- Error analysis: Understand model failures
- Model transparency: Explain model behavior
- Fairlearn: Bias detection and mitigation toolkit
- Responsible AI dashboard: Unified debugging tool
- **[📖 Responsible AI](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai)** - Responsible AI overview
- **[📖 Fairness Assessment](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-responsible-ai-dashboard)** - Fairness evaluation
- **[📖 Error Analysis](https://learn.microsoft.com/en-us/azure/machine-learning/concept-error-analysis)** - Error investigation
- **[📖 Fairlearn Integration](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-machine-learning-fairness-aml)** - Fairness toolkit
- **[📖 Responsible AI Dashboard](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai-dashboard)** - Unified dashboard
- **[📖 Model Debugging](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-responsible-ai-scorecard)** - Debugging tools

**Model Registration**
- Model registry: Centralized model repository
- Model versioning: Track model iterations
- Model metadata: Tags, properties, descriptions
- Model packaging: Include dependencies and code
- Model lineage: Track training data and code
- **[📖 Model Registry](https://learn.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment)** - Registry overview
- **[📖 Register Models](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-models)** - Model registration
- **[📖 Model Versioning](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-models-mlflow)** - Version control
- **[📖 MLflow Models](https://learn.microsoft.com/en-us/azure/machine-learning/concept-mlflow-models)** - MLflow format
- **[📖 Model Metadata](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-models#model-metadata)** - Tags and properties

**Model Packaging and Inference**
- Scoring script: Define input/output and inference logic
- Environment specification: Dependency configuration
- Model files: Serialized model artifacts
- Entry script: Init and run functions
- ONNX models: Interoperable model format
- **[📖 Model Deployment](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-online-endpoints)** - Deployment overview
- **[📖 Scoring Scripts](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-advanced-entry-script)** - Entry script guide
- **[📖 Inference Configuration](https://learn.microsoft.com/en-us/azure/machine-learning/v1/how-to-deploy-and-where)** - Deployment config
- **[📖 ONNX Models](https://learn.microsoft.com/en-us/azure/machine-learning/concept-onnx)** - ONNX overview

### Deploy and Retrain Models (20-25%)

**Online Endpoints (Real-time Inference)**
- Managed online endpoints: Serverless real-time inference
- Kubernetes online endpoints: Deploy to AKS
- Blue-green deployment: Zero-downtime updates
- Traffic splitting: A/B testing and gradual rollout
- Authentication: Key-based and token-based
- **[📖 Online Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/concept-endpoints)** - Endpoint types
- **[📖 Managed Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-managed-online-endpoints)** - Serverless deployment
- **[📖 Kubernetes Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-kubernetes-extension)** - AKS deployment
- **[📖 Blue-Green Deployment](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-safely-rollout-managed-endpoints)** - Safe rollouts
- **[📖 Endpoint Authentication](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-authenticate-online-endpoint)** - Security

**Batch Endpoints (Batch Inference)**
- Batch scoring: Process large datasets
- Parallel processing: Scale across compute cluster
- Schedule-based execution: Automated batch jobs
- Pipeline batch inference: Multi-step processing
- Output configuration: Write results to storage
- **[📖 Batch Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/concept-endpoints-batch)** - Batch inference overview
- **[📖 Create Batch Endpoints](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-batch-endpoint)** - Batch deployment
- **[📖 Batch Scoring](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-parallel-job-in-pipeline)** - Parallel scoring
- **[📖 Schedule Batch Jobs](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-schedule-pipeline-job)** - Job scheduling

**Azure Container Instances (ACI)**
- Development/testing deployments: Low-cost testing
- CPU-based inference: Lightweight workloads
- No orchestration: Simple container hosting
- Public or private endpoints: Flexible networking
- Fast deployment: Quick testing iterations
- **[📖 Deploy to ACI](https://learn.microsoft.com/en-us/azure/machine-learning/v1/how-to-deploy-azure-container-instance)** - ACI deployment
- **[📖 ACI Configuration](https://learn.microsoft.com/en-us/azure/machine-learning/v1/reference-azure-machine-learning-cli#deployment)** - ACI settings

**Azure Kubernetes Service (AKS)**
- Production deployments: High-scale production workloads
- Auto-scaling: Scale based on metrics
- GPU support: Deep learning inference
- Load balancing: Distribute requests
- Multi-model serving: Host multiple models
- **[📖 Deploy to AKS](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-kubernetes-service)** - AKS deployment
- **[📖 AKS Cluster Setup](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-attach-kubernetes)** - Cluster configuration
- **[📖 AKS Autoscaling](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-kubernetes-extension#autoscaling)** - Scale settings
- **[📖 GPU Inference](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-with-triton)** - GPU deployment

**Model Monitoring**
- Data drift detection: Monitor input data changes
- Model performance monitoring: Track prediction quality
- Application Insights integration: Telemetry and logging
- Custom logging: Application-specific metrics
- Alerting: Automated notifications on issues
- **[📖 Model Monitoring](https://learn.microsoft.com/en-us/azure/machine-learning/concept-model-monitoring)** - Monitoring overview
- **[📖 Data Drift](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-monitor-datasets)** - Data drift detection
- **[📖 Model Data Collection](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-enable-data-collection)** - Collect inference data
- **[📖 Application Insights](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-enable-app-insights)** - APM integration
- **[📖 Monitor Performance](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-monitor-online-endpoints)** - Endpoint monitoring

**Model Retraining**
- Scheduled retraining: Periodic model updates
- Trigger-based retraining: Data drift or performance triggers
- Automated pipelines: End-to-end retraining workflow
- A/B testing: Compare old and new models
- Champion/challenger pattern: Gradual model replacement
- **[📖 Retraining Models](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-retrain-designer)** - Retraining strategies
- **[📖 Pipeline Schedules](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-schedule-pipeline-job)** - Automated scheduling
- **[📖 Event-driven Retraining](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-event-grid)** - Event triggers

### MLOps and Automation

**Azure ML Pipelines**
- Pipeline components: Reusable pipeline steps
- Pipeline parameters: Parameterize workflows
- Pipeline publishing: Share and reuse pipelines
- Pipeline endpoints: Versioned pipeline execution
- Pipeline schedules: Automated execution
- **[📖 Azure ML Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines)** - Pipeline fundamentals
- **[📖 Create Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-component-pipeline-python)** - Build pipelines
- **[📖 Pipeline Components](https://learn.microsoft.com/en-us/azure/machine-learning/concept-component)** - Component overview
- **[📖 Pipeline Parameters](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-pipeline-parameter)** - Parameterization
- **[📖 Publish Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-pipelines)** - Pipeline deployment
- **[📖 Schedule Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-schedule-pipeline-job-with-event-grid)** - Scheduling

**CI/CD Integration**
- GitHub Actions: Automate ML workflows
- Azure DevOps: ML pipeline automation
- Azure Pipelines: Build and release automation
- Model validation: Automated testing
- Deployment gates: Approval workflows
- **[📖 MLOps Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment)** - MLOps fundamentals
- **[📖 GitHub Actions](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-github-actions-machine-learning)** - GitHub integration
- **[📖 Azure DevOps](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-devops-machine-learning)** - DevOps integration
- **[📖 CI/CD Pipelines](https://learn.microsoft.com/en-us/azure/machine-learning/concept-train-machine-learning-model#mlops-continuous-integration-and-delivery)** - Automation patterns

**Environment Management**
- Curated environments: Pre-configured Microsoft environments
- Custom environments: Docker-based custom images
- Conda environments: Python package management
- Requirements.txt: Pip dependency specification
- Environment versioning: Track environment changes
- **[📖 Environments](https://learn.microsoft.com/en-us/azure/machine-learning/concept-environments)** - Environment overview
- **[📖 Curated Environments](https://learn.microsoft.com/en-us/azure/machine-learning/resource-curated-environments)** - Pre-built environments
- **[📖 Custom Environments](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-environments-v2)** - Build custom images
- **[📖 Dockerfile Environments](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-environments-v2#create-an-environment-from-a-docker-image)** - Docker integration

**Model Governance**
- Model versioning: Track model evolution
- Model approval workflow: Governance process
- Model lineage: Track data and code lineage
- Audit logging: Track model operations
- Access control: RBAC for models
- **[📖 Model Management](https://learn.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment)** - Model lifecycle
- **[📖 Model Catalog](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-models-mlflow)** - Catalog overview
- **[📖 Model Lineage](https://learn.microsoft.com/en-us/azure/machine-learning/concept-data-lineage)** - Track lineage

## Azure ML Python SDK v2

### Workspace and Compute

**Connect to Workspace**
```python
from azure.ai.ml import MLClient
from azure.identity import DefaultAzureCredential

ml_client = MLClient(
    DefaultAzureCredential(),
    subscription_id="<subscription>",
    resource_group_name="<resource-group>",
    workspace_name="<workspace>"
)
```

**Create Compute Cluster**
```python
from azure.ai.ml.entities import AmlCompute

compute = AmlCompute(
    name="cpu-cluster",
    type="amlcompute",
    size="STANDARD_DS3_V2",
    min_instances=0,
    max_instances=4,
    idle_time_before_scale_down=120
)
ml_client.compute.begin_create_or_update(compute)
```

- **[📖 SDK v2 Overview](https://learn.microsoft.com/en-us/python/api/overview/azure/ai-ml-readme)** - SDK fundamentals
- **[📖 MLClient Class](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.mlclient)** - Client reference
- **[📖 Compute Management](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.amlcompute)** - Compute classes

### Data and Datasets

**Create Data Asset**
```python
from azure.ai.ml.entities import Data
from azure.ai.ml.constants import AssetTypes

data_asset = Data(
    name="my-dataset",
    path="./data",
    type=AssetTypes.URI_FOLDER,
    description="Training data"
)
ml_client.data.create_or_update(data_asset)
```

**Create Datastore**
```python
from azure.ai.ml.entities import AzureBlobDatastore
from azure.ai.ml.entities import AccountKeyConfiguration

blob_datastore = AzureBlobDatastore(
    name="blob_datastore",
    account_name="<account-name>",
    container_name="<container>",
    credentials=AccountKeyConfiguration(account_key="<key>")
)
ml_client.datastores.create_or_update(blob_datastore)
```

- **[📖 Data Assets](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.data)** - Data class
- **[📖 Datastore Types](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.datastore)** - Datastore classes

### Training Jobs

**Submit Training Job**
```python
from azure.ai.ml import command

job = command(
    code="./src",
    command="python train.py --learning-rate ${{inputs.lr}}",
    inputs={"lr": 0.01},
    environment="AzureML-sklearn-1.0-ubuntu20.04-py38-cpu@latest",
    compute="cpu-cluster",
    experiment_name="my-experiment"
)
ml_client.jobs.create_or_update(job)
```

**AutoML Classification**
```python
from azure.ai.ml import automl

classification_job = automl.classification(
    training_data=my_training_data,
    target_column_name="label",
    primary_metric="accuracy",
    compute="cpu-cluster",
    experiment_name="automl-classification"
)
ml_client.jobs.create_or_update(classification_job)
```

- **[📖 Job Submission](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.job)** - Job classes
- **[📖 Command Jobs](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml#azure-ai-ml-command)** - Command function
- **[📖 AutoML Jobs](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.automl)** - AutoML classes

### Model Registration and Deployment

**Register Model**
```python
from azure.ai.ml.entities import Model
from azure.ai.ml.constants import AssetTypes

model = Model(
    path="./model",
    type=AssetTypes.MLFLOW_MODEL,
    name="my-model",
    description="Model description"
)
ml_client.models.create_or_update(model)
```

**Deploy Online Endpoint**
```python
from azure.ai.ml.entities import ManagedOnlineEndpoint, ManagedOnlineDeployment

endpoint = ManagedOnlineEndpoint(
    name="my-endpoint",
    description="Production endpoint",
    auth_mode="key"
)
ml_client.online_endpoints.begin_create_or_update(endpoint)

deployment = ManagedOnlineDeployment(
    name="blue",
    endpoint_name="my-endpoint",
    model=model,
    instance_type="Standard_DS3_v2",
    instance_count=1
)
ml_client.online_deployments.begin_create_or_update(deployment)
```

- **[📖 Model Class](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.model)** - Model registration
- **[📖 Online Endpoints](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.managedonlineendpoint)** - Endpoint classes
- **[📖 Deployments](https://learn.microsoft.com/en-us/python/api/azure-ai-ml/azure.ai.ml.entities.managedonlinedeployment)** - Deployment classes

## Azure ML CLI v2

### Workspace and Compute

**Connect to Workspace**
```bash
az login
az account set --subscription <subscription-id>
az configure --defaults workspace=<workspace> group=<resource-group>
```

**Create Compute**
```bash
az ml compute create --name cpu-cluster --type amlcompute --size STANDARD_DS3_V2 --min-instances 0 --max-instances 4
az ml compute list
az ml compute show --name cpu-cluster
```

**Create Compute Instance**
```bash
az ml compute create --name my-compute-instance --type computeinstance --size STANDARD_DS3_V2
```

- **[📖 CLI v2 Overview](https://learn.microsoft.com/en-us/cli/azure/ml)** - CLI reference
- **[📖 CLI Installation](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-cli)** - Setup guide
- **[📖 CLI Compute](https://learn.microsoft.com/en-us/cli/azure/ml/compute)** - Compute commands

### Data and Jobs

**Create Data Asset**
```bash
az ml data create --name my-data --type uri_folder --path ./data
az ml data list
az ml data show --name my-data --version 1
```

**Submit Training Job**
```bash
az ml job create --file job.yml
az ml job list --experiment-name my-experiment
az ml job show --name <job-name>
az ml job download --name <job-name> --outputs
```

**Job YAML Example**
```yaml
$schema: https://azuremlschemas.azureedge.net/latest/commandJob.schema.json
command: python train.py --epochs ${{inputs.epochs}}
code: ./src
environment: azureml:AzureML-sklearn-1.0-ubuntu20.04-py38-cpu@latest
compute: cpu-cluster
inputs:
  epochs: 10
```

- **[📖 CLI Data Commands](https://learn.microsoft.com/en-us/cli/azure/ml/data)** - Data management
- **[📖 CLI Job Commands](https://learn.microsoft.com/en-us/cli/azure/ml/job)** - Job management
- **[📖 YAML Schema](https://learn.microsoft.com/en-us/azure/machine-learning/reference-yaml-overview)** - YAML reference

### Model and Deployment

**Register Model**
```bash
az ml model create --name my-model --path ./model --type mlflow_model
az ml model list
az ml model show --name my-model --version 1
```

**Create Online Endpoint**
```bash
az ml online-endpoint create --name my-endpoint --auth-mode key
az ml online-deployment create --file deployment.yml --endpoint-name my-endpoint
az ml online-endpoint update --name my-endpoint --traffic "blue=100"
```

**Deployment YAML Example**
```yaml
$schema: https://azuremlschemas.azureedge.net/latest/managedOnlineDeployment.schema.json
name: blue
endpoint_name: my-endpoint
model: azureml:my-model@latest
instance_type: Standard_DS3_v2
instance_count: 1
```

**Invoke Endpoint**
```bash
az ml online-endpoint invoke --name my-endpoint --request-file request.json
az ml online-endpoint get-logs --name my-endpoint --deployment blue
```

- **[📖 CLI Model Commands](https://learn.microsoft.com/en-us/cli/azure/ml/model)** - Model management
- **[📖 CLI Endpoint Commands](https://learn.microsoft.com/en-us/cli/azure/ml/online-endpoint)** - Endpoint commands
- **[📖 CLI Deployment Commands](https://learn.microsoft.com/en-us/cli/azure/ml/online-deployment)** - Deployment commands

## Common Data Science Scenarios

### Scenario 1: End-to-End Classification Pipeline
**Requirements:** Build, train, evaluate, and deploy classification model
**Solution:**
1. Create Azure ML workspace and compute cluster
2. Upload and register training data as data asset
3. Create training script with scikit-learn
4. Define environment with required dependencies
5. Submit training job and track with MLflow
6. Evaluate model performance (accuracy, precision, recall)
7. Register best model in model registry
8. Create online endpoint for real-time predictions
9. Deploy model and test inference
10. Monitor endpoint performance and data drift

### Scenario 2: AutoML Time Series Forecasting
**Requirements:** Predict future values using historical time series data
**Solution:**
1. Prepare time series dataset with timestamp and target columns
2. Register dataset in Azure ML workspace
3. Configure AutoML forecasting job with parameters:
   - Time column name and target column
   - Forecast horizon (prediction window)
   - Frequency (hourly, daily, monthly)
   - Enable cross-validation
4. Review AutoML results and explanations
5. Select best model based on normalized RMSE
6. Deploy model to managed endpoint
7. Test with sample data for predictions
8. Schedule batch inference for regular forecasts

### Scenario 3: Distributed Deep Learning Training
**Requirements:** Train large neural network across multiple GPUs
**Solution:**
1. Create GPU compute cluster (Standard_NC6s_v3)
2. Prepare training script with PyTorch
3. Use distributed training with PyTorch DistributedDataParallel
4. Configure training job with multiple nodes
5. Track metrics with MLflow
6. Use learning rate finder for optimal hyperparameters
7. Implement early stopping for efficiency
8. Save checkpoints regularly
9. Register final model
10. Deploy to AKS with GPU support for inference

### Scenario 4: MLOps Pipeline with CI/CD
**Requirements:** Automated ML workflow from training to deployment
**Solution:**
1. Create Azure ML pipeline with components:
   - Data preparation component
   - Training component
   - Model evaluation component
   - Model registration component
2. Publish pipeline to pipeline endpoint
3. Create GitHub Actions workflow:
   - Trigger on code commit
   - Run data validation tests
   - Execute training pipeline
   - Validate model performance thresholds
   - Register model if metrics pass
4. Set up Azure DevOps release pipeline:
   - Deploy to staging endpoint
   - Run integration tests
   - Require manual approval
   - Deploy to production with traffic splitting
5. Configure monitoring and alerting
6. Schedule pipeline for retraining

### Scenario 5: Responsible AI Implementation
**Requirements:** Ensure model fairness and explainability
**Solution:**
1. Train classification model on sensitive data
2. Generate Responsible AI dashboard with components:
   - Model overview and predictions
   - Error analysis to identify failure patterns
   - Fairness assessment across demographic groups
   - Model interpretability with SHAP values
   - Counterfactual analysis for what-if scenarios
3. Identify fairness issues (disparate impact)
4. Retrain model with Fairlearn mitigation techniques
5. Document model cards with fairness metrics
6. Deploy with monitoring for fairness degradation
7. Create scorecard for stakeholders

## Python Libraries for Data Science

### Core ML Libraries

**scikit-learn**
- Classification, regression, clustering algorithms
- Model evaluation and metrics
- Data preprocessing and feature engineering
- Pipeline creation for workflows
- **[📖 scikit-learn Documentation](https://scikit-learn.org/stable/)** - Official docs

**pandas**
- Data manipulation and analysis
- DataFrame operations
- Data cleaning and transformation
- Time series functionality
- **[📖 pandas Documentation](https://pandas.pydata.org/docs/)** - Official docs

**NumPy**
- Numerical computing
- Array operations
- Mathematical functions
- Linear algebra
- **[📖 NumPy Documentation](https://numpy.org/doc/)** - Official docs

### Deep Learning Frameworks

**PyTorch**
- Neural network construction
- Automatic differentiation
- GPU acceleration
- Distributed training
- **[📖 PyTorch with Azure ML](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-pytorch)** - Azure integration

**TensorFlow/Keras**
- Deep learning models
- Neural network layers
- Model training and evaluation
- Production deployment
- **[📖 TensorFlow with Azure ML](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-train-tensorflow)** - Azure integration

### Visualization

**matplotlib**
- Static plots and charts
- Customizable visualizations
- Publication-quality figures
- **[📖 matplotlib Documentation](https://matplotlib.org/stable/)** - Official docs

**seaborn**
- Statistical data visualization
- Attractive default styles
- Complex visualizations simplified
- **[📖 seaborn Documentation](https://seaborn.pydata.org/)** - Official docs

### Azure ML Specific

**azureml-core** (SDK v1 - Still supported)
- Workspace management
- Experiment tracking
- Model registration and deployment
- **[📖 SDK v1 Reference](https://learn.microsoft.com/en-us/python/api/overview/azure/ml/intro)** - SDK v1 docs

**azure-ai-ml** (SDK v2 - Current)
- Modern Pythonic API
- Improved type hints
- Enhanced error messages
- **[📖 SDK v2 Migration](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-migrate-from-v1)** - Migration guide

**MLflow**
- Experiment tracking
- Model packaging
- Model registry integration
- **[📖 MLflow Integration](https://learn.microsoft.com/en-us/azure/machine-learning/concept-mlflow)** - MLflow in Azure ML

## Exam Tips

### Hands-On Focus
- DP-100 heavily emphasizes practical implementation
- Must know Python SDK and CLI commands
- Understand Azure ML Studio navigation
- Practice building end-to-end ML solutions
- Know how to debug failed training runs

### Common Exam Scenarios
- Configure AutoML for different problem types
- Implement hyperparameter tuning with sweep jobs
- Deploy models to different compute targets
- Monitor model performance and data drift
- Create and schedule ML pipelines
- Implement responsible AI practices
- Register and version models
- Configure compute for different workloads
- Troubleshoot deployment failures
- Implement MLOps workflows

### Question Keywords
- **"Most cost-effective"** → Use compute clusters with auto-scaling, serverless compute, spot instances
- **"Production deployment"** → AKS with managed endpoints, blue-green deployment, monitoring
- **"Real-time inference"** → Managed online endpoints, low latency compute
- **"Batch scoring"** → Batch endpoints, parallel processing, scheduled execution
- **"Explainability"** → InterpretML, SHAP values, Responsible AI dashboard
- **"Fairness"** → Fairlearn, fairness metrics, bias mitigation
- **"Automated"** → AutoML, pipelines, scheduled retraining
- **"Secure"** → Private endpoints, managed identity, VNet integration
- **"Track experiments"** → MLflow, run history, metrics logging
- **"Distributed training"** → Multi-node clusters, PyTorch/TensorFlow distributed

### SDK v1 vs SDK v2
- **Exam primarily focuses on SDK v2** (azure-ai-ml package)
- SDK v1 (azureml-core) still appears in some questions
- Know the differences in syntax and approach
- SDK v2 uses job submission pattern (command, automl)
- SDK v1 uses ScriptRunConfig and Estimators
- **[📖 SDK Comparison](https://learn.microsoft.com/en-us/azure/machine-learning/migrate-to-v2-overview)** - Key differences

### AutoML Configuration
Know when to use AutoML vs custom training:
- **Use AutoML:** Quick baseline, limited time, standard ML tasks
- **Use custom training:** Custom loss functions, specific architectures, novel algorithms
- AutoML task types: Classification, regression, forecasting, NLP, computer vision
- AutoML parameters: Primary metric, timeout, iterations, cross-validation

### Compute Selection
- **Compute instance:** Development, Jupyter notebooks, VS Code
- **Compute cluster:** Training jobs, hyperparameter tuning, batch inference
- **Serverless compute:** On-demand training without cluster management
- **AKS:** Production deployments, high-scale inference, GPU support
- **ACI:** Development/testing deployments (not for production)

### Model Deployment Best Practices
- Always use managed online endpoints for production
- Implement blue-green deployments for zero downtime
- Use traffic splitting for gradual rollout
- Enable Application Insights for monitoring
- Configure auto-scaling for variable load
- Test thoroughly in staging before production
- Implement proper authentication (key or token)

### Responsible AI Requirements
- Understand model fairness assessment
- Know how to use Fairlearn for bias mitigation
- Implement error analysis to identify weak spots
- Generate model explanations with InterpretML
- Create model cards for documentation
- Use Responsible AI dashboard for comprehensive analysis

## Essential Documentation

### Core Resources
- **[📖 DP-100 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/dp-100)** - Official exam information
- **[📖 DP-100 Study Guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/dp-100)** - Microsoft study guide
- **[📖 Microsoft Learn - DP-100](https://learn.microsoft.com/en-us/training/courses/dp-100t01)** - Learning path
- **[📖 Azure ML Documentation](https://learn.microsoft.com/en-us/azure/machine-learning/)** - Complete documentation
- **[📖 Azure ML Examples](https://github.com/Azure/azureml-examples)** - GitHub repository

### Hands-On Resources
- **[📖 Azure Free Account](https://azure.microsoft.com/en-us/free/)** - 12 months free + $200 credit
- **[📖 Microsoft Learn Sandbox](https://learn.microsoft.com/en-us/training/support/faq?pivots=sandbox)** - Free practice environment
- **[📖 Azure ML Notebooks](https://github.com/Azure/MachineLearningNotebooks)** - Sample notebooks
- **[📖 Azure ML Community](https://techcommunity.microsoft.com/t5/azure-ai-services-blog/bg-p/Azure-AI-Services-blog)** - Community blog

### Video and Interactive Resources
- **[📖 Microsoft Learn Videos](https://learn.microsoft.com/en-us/shows/)** - Video series
- **[📖 Azure Friday](https://learn.microsoft.com/en-us/shows/azure-friday/)** - Weekly Azure show
- **[📖 AI Show](https://learn.microsoft.com/en-us/shows/ai-show/)** - AI-focused content

## Final Checklist

### Knowledge Requirements
- [ ] Create and configure Azure ML workspaces
- [ ] Manage compute resources (instances, clusters, AKS)
- [ ] Work with datastores and datasets
- [ ] Perform data exploration and feature engineering
- [ ] Train models with Azure ML SDK and AutoML
- [ ] Implement hyperparameter tuning with sweep jobs
- [ ] Evaluate models with appropriate metrics
- [ ] Implement model explainability and fairness assessment
- [ ] Register and version models in model registry
- [ ] Deploy models to online and batch endpoints
- [ ] Monitor model performance and data drift
- [ ] Create and schedule ML pipelines
- [ ] Implement MLOps workflows with CI/CD
- [ ] Use MLflow for experiment tracking
- [ ] Understand Responsible AI principles

### Skills Requirements
- [ ] Python programming with Azure ML SDK v2
- [ ] Azure ML CLI v2 commands
- [ ] Azure ML Studio navigation
- [ ] Jupyter notebook development
- [ ] scikit-learn, pandas, NumPy proficiency
- [ ] PyTorch or TensorFlow basics
- [ ] Git version control
- [ ] YAML configuration files
- [ ] Docker container basics
- [ ] REST API testing

### Preparation Milestones
- [ ] 6+ months ML and Azure experience (recommended)
- [ ] Completed Microsoft Learn DP-100 learning path
- [ ] Hands-on practice with all core Azure ML features
- [ ] Built end-to-end ML solutions (data to deployment)
- [ ] Practice tests completed (75%+ score)
- [ ] Understand all exam objectives thoroughly
- [ ] Reviewed Microsoft documentation
- [ ] Practiced SDK v2 and CLI v2 commands
- [ ] Implemented MLOps pipelines
- [ ] Worked with real-world datasets

---

**Pro Tip:** DP-100 requires strong practical ML experience with Azure ML. You MUST have hands-on experience building, training, and deploying ML models. Focus on the Python SDK v2, AutoML, and deployment strategies. The exam includes scenario-based questions requiring deep understanding of ML workflows. Practice in a real Azure ML workspace every day!

**Link Count:** This fact sheet contains **120 embedded documentation links** covering all major DP-100 exam domains.

**Good luck with your DP-100 certification!**
