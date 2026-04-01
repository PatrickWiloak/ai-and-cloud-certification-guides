# ML Model Development

**[SageMaker Training](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)** - Model training overview

## SageMaker Training Jobs

### Training Job Configuration

**Key Parameters**:
- **Algorithm/Container** - built-in algorithm, framework container, or custom
- **Instance Type** - CPU or GPU based on algorithm requirements
- **Instance Count** - single or distributed training
- **Input Data** - S3 location and data channel configuration
- **Output** - S3 location for model artifacts
- **Hyperparameters** - algorithm-specific settings
- **IAM Role** - execution role with S3 and other service access

**[Training Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)** - Creating training jobs

### Data Input Modes

**File Mode** (default):
- Downloads entire dataset to instance before training
- Good for small to medium datasets
- All data available on local disk

**Pipe Mode**:
- Streams data directly from S3 during training
- Faster start time - no download wait
- Reduces disk storage requirements
- Best for large datasets

**Fast File Mode**:
- Lazy loading from S3 with POSIX file interface
- Data loaded on demand as accessed
- Combines benefits of File and Pipe mode

### Instance Type Selection

| Workload | Instance Family | When to Use |
|----------|----------------|-------------|
| Tabular data (XGBoost) | ml.m5, ml.c5 | CPU-based algorithms |
| Deep learning training | ml.p3, ml.p4d | GPU-intensive training |
| Large model training | ml.p4d.24xlarge | Multi-GPU distributed |
| NLP models | ml.p3, ml.g5 | GPU with good memory |
| Small experiments | ml.m5.large | Cost-effective testing |

### Managed Spot Training

**[Managed Spot Training](https://docs.aws.amazon.com/sagemaker/latest/dg/model-managed-spot-training.html)** - Cost optimization

- Up to 90% savings compared to On-Demand
- SageMaker manages Spot interruption and resumption
- Requires checkpointing for training state preservation
- Set maximum wait time and maximum run time
- Best for: long training jobs, fault-tolerant training

### Checkpointing

**[Checkpointing](https://docs.aws.amazon.com/sagemaker/latest/dg/model-checkpoints.html)** - Save training state

- Save model state periodically to S3
- Resume training from last checkpoint after interruption
- Essential for Spot training
- Configure checkpoint interval and S3 location
- Framework-specific implementation (TensorFlow, PyTorch callbacks)

### Distributed Training

**[Distributed Training](https://docs.aws.amazon.com/sagemaker/latest/dg/distributed-training.html)** - Multi-node training

**Data Parallelism**:
- Same model replicated across multiple GPUs/instances
- Each replica processes different mini-batch
- Gradients synchronized across replicas
- Use when: dataset is large, model fits in single GPU memory
- SageMaker Distributed Data Parallel library

**Model Parallelism**:
- Model split across multiple GPUs
- Each GPU holds a portion of the model
- Use when: model too large for single GPU memory
- SageMaker Distributed Model Parallel library
- Tensor parallelism and pipeline parallelism

## Built-in Algorithms

**[Built-in Algorithms](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)** - Algorithm reference

### Supervised Learning - Classification/Regression

**XGBoost**:
- Gradient boosted trees for tabular data
- Best for: structured/tabular data, feature importance
- Input: CSV, LibSVM, Parquet, RecordIO
- Key hyperparameters: num_round, max_depth, eta, subsample
- Supports regression, binary classification, multi-class

**[XGBoost](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost.html)** - Gradient boosting algorithm

**Linear Learner**:
- Linear regression and classification
- Best for: large-scale linear problems, baseline models
- Built-in feature normalization
- Key hyperparameters: predictor_type, learning_rate, l1/l2 regularization

**[Linear Learner](https://docs.aws.amazon.com/sagemaker/latest/dg/linear-learner.html)** - Linear models

**K-Nearest Neighbors (KNN)**:
- Classification and regression using nearest neighbors
- Best for: small-medium datasets, recommendation systems
- Supports dimensionality reduction for large feature spaces

### Supervised Learning - Computer Vision

**Image Classification**:
- ResNet-based image classification
- Transfer learning from pre-trained models
- Best for: image categorization tasks

**[Image Classification](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)** - Image classification algorithm

**Object Detection**:
- SSD (Single Shot MultiBox Detector)
- Detect and locate objects in images
- Best for: object localization, counting

**Semantic Segmentation**:
- Pixel-level image classification
- Fully Convolutional Network (FCN)
- Best for: image segmentation, autonomous driving

### Supervised Learning - NLP

**BlazingText**:
- Word2Vec and text classification
- Highly optimized for speed
- Best for: text classification, word embeddings

**[BlazingText](https://docs.aws.amazon.com/sagemaker/latest/dg/blazingtext.html)** - Text classification

**Seq2Seq**:
- Sequence-to-sequence with attention
- Best for: machine translation, text summarization

### Unsupervised Learning

**K-Means**:
- Clustering algorithm
- Best for: customer segmentation, grouping similar items
- Key hyperparameters: k (number of clusters), init_method

**Principal Component Analysis (PCA)**:
- Dimensionality reduction
- Best for: reducing feature space, denoising
- Modes: regular, randomized

**Random Cut Forest (RCF)**:
- Anomaly detection
- Best for: detecting outliers in streaming or batch data
- Unsupervised, no labels needed

**IP Insights**:
- Learn associations between IPs and entities
- Best for: fraud detection, suspicious login detection

## Hyperparameter Tuning

**[Automatic Model Tuning](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning.html)** - Hyperparameter optimization

### Search Strategies

**Bayesian Optimization** (recommended):
- Treats tuning as regression problem
- Builds probabilistic model of objective function
- Balances exploration and exploitation
- Best for: expensive evaluations, limited budget

**Random Search**:
- Random hyperparameter combinations
- Good for: initial exploration, many hyperparameters
- Parallelizable - run many jobs simultaneously

**Grid Search**:
- Exhaustive search of defined grid
- Best for: small hyperparameter space
- Can be expensive for large spaces

**Hyperband**:
- Early stopping of poor performers
- Dynamically allocates resources to promising configs
- Efficient for large search spaces

### Tuning Job Configuration
- Define objective metric (e.g., validation:accuracy)
- Specify hyperparameter ranges (continuous, integer, categorical)
- Set max number of training jobs and parallel jobs
- Configure warm start to continue from previous tuning

**[Warm Start](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning-warm-start.html)** - Continue from previous tuning

### Early Stopping
- Stop training jobs that are unlikely to improve
- Reduces cost by not running poor configurations to completion
- Median stopping rule: stop if below median of completed jobs

## Model Evaluation

### Classification Metrics
- **Accuracy** - correct predictions / total predictions
- **Precision** - true positives / predicted positives (avoid false positives)
- **Recall** - true positives / actual positives (avoid false negatives)
- **F1 Score** - harmonic mean of precision and recall
- **AUC-ROC** - area under receiver operating characteristic curve
- **Confusion Matrix** - visualize true/false positives/negatives

### Regression Metrics
- **RMSE** - root mean squared error (penalizes large errors)
- **MAE** - mean absolute error (robust to outliers)
- **R-squared** - proportion of variance explained
- **MAPE** - mean absolute percentage error

### Cross-Validation
- K-fold cross-validation for robust evaluation
- Stratified folds for imbalanced datasets
- Holdout validation for large datasets

## SageMaker Autopilot

**[SageMaker Autopilot](https://docs.aws.amazon.com/sagemaker/latest/dg/autopilot-automate-model-development.html)** - Automated ML

- AutoML service that automatically explores algorithms and hyperparameters
- Input: tabular data in CSV or Parquet
- Output: best model, candidate notebooks, feature importance
- Modes: Ensembling (best accuracy) and HPO (single algorithm)
- Generates explainable notebooks showing the process

## SageMaker JumpStart

**[SageMaker JumpStart](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-jumpstart.html)** - Pre-trained models

- Pre-trained models for common ML tasks
- Foundation models: Llama, Falcon, Stable Diffusion
- One-click deployment and fine-tuning
- Solution templates for common ML use cases
- Transfer learning capabilities

## SageMaker Experiments

**[SageMaker Experiments](https://docs.aws.amazon.com/sagemaker/latest/dg/experiments.html)** - Experiment tracking

- Track training runs with parameters, metrics, and artifacts
- Compare experiments side by side
- Organize experiments into groups
- Visualize metrics across runs
- Integration with training jobs and pipelines

## SageMaker Debugger

**[SageMaker Debugger](https://docs.aws.amazon.com/sagemaker/latest/dg/train-debugger.html)** - Training insights

- Real-time monitoring of training metrics
- Built-in rules for detecting training issues:
  - Vanishing/exploding gradients
  - Overfitting detection
  - Loss not decreasing
  - Class imbalance
- Profiling for hardware utilization (CPU, GPU, memory)
- Automatic actions when rules trigger (stop training, send alert)

## Model Registry

**[SageMaker Model Registry](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html)** - Model versioning

### Key Concepts
- **Model Package Group** - collection of model versions
- **Model Package** - specific model version with metadata
- **Approval Status** - Pending, Approved, Rejected
- **Model Metrics** - accuracy, latency, and custom metrics

### Workflow
1. Train model and evaluate metrics
2. Create model package with metrics and artifacts
3. Set approval status (manual or automated)
4. Pipeline deploys only approved models
5. Track model lineage and provenance

**[Model Packages](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-version.html)** - Creating model versions

## Key Takeaways

1. **Training jobs** - always use managed training, not notebooks, for production
2. **Spot training** - up to 90% savings, requires checkpointing
3. **Instance selection** - CPU for tabular (XGBoost), GPU for deep learning
4. **Built-in algorithms** - XGBoost for tabular, BlazingText for text, RCF for anomaly
5. **Bayesian optimization** - preferred tuning strategy for most cases
6. **Autopilot** - AutoML for quick baseline and algorithm exploration
7. **Model Registry** - version control with approval workflow for production
8. **Experiments** - track and compare training runs systematically
9. **Debugger** - detect training issues early (gradients, overfitting)
10. **Distributed training** - data parallelism for large data, model parallelism for large models
