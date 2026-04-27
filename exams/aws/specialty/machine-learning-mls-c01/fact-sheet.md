# AWS Certified Machine Learning - Specialty (MLS-C01) - Fact Sheet

> ⚠️ **RETIRED April 15, 2025.** No longer available for new candidates. Replaced by **[AWS Machine Learning Engineer - Associate (MLA-C01)](../../associate/ml-engineer-mla-c01/fact-sheet.md)**. Material preserved as historical reference.

## Quick Reference

### Exam Details
- **Exam Code**: MLS-C01
- **Duration**: 180 minutes (3 hours)
- **Number of Questions**: 65 questions
- **Passing Score**: 750/1000
- **Question Format**: Multiple choice, multiple response
- **Cost**: $300 USD
- **Validity**: 3 years
- **Prerequisites**: Recommended 1-2 years hands-on ML/DL on AWS

### Exam Domains
| Domain | % of Exam |
|--------|-----------|
| Domain 1: Data Engineering | 20% |
| Domain 2: Exploratory Data Analysis | 24% |
| Domain 3: Modeling | 36% |
| Domain 4: Machine Learning Implementation & Operations | 20% |

## Domain 1: Data Engineering (20%)

### Data Repositories for ML

#### Amazon S3
- **Primary data lake** - Store raw, processed, and model artifacts
- **[📖 S3 for ML Data](https://docs.aws.amazon.com/sagemaker/latest/dg/model-access-training-data.html)** - Best practices for ML datasets
- **S3 Select** - Query CSV/JSON/Parquet without full download
- **[📖 S3 Select Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)**
- **Lifecycle policies** - Archive old training data to Glacier
- **Versioning** - Track dataset versions over time

#### Amazon RDS / Aurora
- **Structured ML features** - Store feature stores and metadata
- **[📖 Aurora ML](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-ml.html)** - Invoke SageMaker directly from SQL
- **Aurora Serverless** - Auto-scaling for variable ML workloads

#### Amazon Redshift
- **Data warehouse** - Aggregate features from multiple sources
- **[📖 Redshift ML](https://docs.aws.amazon.com/redshift/latest/dg/machine_learning.html)** - CREATE MODEL SQL syntax
- **Redshift Spectrum** - Query S3 data lakes directly

#### Amazon DynamoDB
- **Real-time feature store** - Low-latency feature retrieval
- **[📖 DynamoDB for ML](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-dynamo.html)** - Online feature store patterns
- **TTL** - Automatically expire old features

#### Amazon Timestream
- **Time-series data** - IoT sensor data, application metrics
- **[📖 Timestream Documentation](https://docs.aws.amazon.com/timestream/)**

### Data Ingestion and Transformation

#### AWS Glue
- **ETL service** - Serverless data preparation
- **[📖 Glue for ML](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)** - ETL job authoring
- **Glue DataBrew** - Visual data preparation
- **[📖 DataBrew Transformations](https://docs.aws.amazon.com/databrew/latest/dg/transformations.html)** - 250+ pre-built transformations
- **Glue Crawler** - Auto-discover schema
- **Glue Data Catalog** - Centralized metadata repository

#### Amazon EMR
- **Big data processing** - Spark, Hadoop, Presto
- **[📖 EMR for ML](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-machine-learning.html)** - Spark MLlib on EMR
- **EMR Notebooks** - Jupyter-based data exploration

#### AWS Data Pipeline
- **Workflow orchestration** - Schedule and monitor pipelines
- **[📖 Data Pipeline Documentation](https://docs.aws.amazon.com/datapipeline/)**

#### Amazon Kinesis
- **Streaming data** - Real-time ML inference pipelines
- **[📖 Kinesis Data Streams](https://docs.aws.amazon.com/streams/latest/dev/)** - Real-time data ingestion
- **[📖 Kinesis Data Firehose](https://docs.aws.amazon.com/firehose/latest/dev/)** - Load streams to S3/Redshift
- **Kinesis Data Analytics** - SQL or Apache Flink for streaming ETL

#### AWS Lambda
- **Serverless transforms** - Lightweight data preprocessing
- **[📖 Lambda for ML](https://docs.aws.amazon.com/lambda/latest/dg/services-machinelearning.html)** - Trigger on S3 events

### Data Formats and Optimization

#### File Formats
- **Parquet** - Columnar, compressed, best for analytics (10x faster than CSV)
- **[📖 Parquet Format](https://parquet.apache.org/docs/)** - Column pruning and predicate pushdown
- **ORC** - Optimized Row Columnar, Hive-optimized
- **Avro** - Row-based, schema evolution
- **RecordIO-Protobuf** - SageMaker pipe mode format
- **[📖 SageMaker File Formats](https://docs.aws.amazon.com/sagemaker/latest/dg/cdf-training.html)** - Recommended formats

#### Data Partitioning
- **Hive-style partitioning** - `s3://bucket/year=2023/month=01/data.parquet`
- **[📖 Athena Partitioning](https://docs.aws.amazon.com/athena/latest/ug/partitions.html)** - Reduce scan costs

### Data Security and Compliance

#### Encryption
- **S3 encryption** - SSE-S3, SSE-KMS, SSE-C
- **[📖 S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)**
- **SageMaker encryption** - Encrypt training data, models, endpoints
- **[📖 SageMaker Encryption](https://docs.aws.amazon.com/sagemaker/latest/dg/encryption-at-rest.html)**

#### Access Control
- **IAM policies** - Least privilege access
- **S3 bucket policies** - Resource-based access control
- **VPC endpoints** - Private connectivity without internet
- **[📖 SageMaker VPC](https://docs.aws.amazon.com/sagemaker/latest/dg/host-vpc.html)** - Deploy in private subnets

#### Data Privacy
- **AWS Macie** - Discover and protect PII
- **[📖 Macie Documentation](https://docs.aws.amazon.com/macie/)**
- **Anonymization** - Remove/hash PII before training

## Domain 2: Exploratory Data Analysis (24%)

### Data Visualization and Analysis

#### Amazon SageMaker Data Wrangler
- **Visual data prep** - 300+ built-in transformations
- **[📖 Data Wrangler Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler.html)** - Import, transform, analyze
- **[📖 Data Wrangler Transformations](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler-transform.html)** - Encode, scale, handle missing
- **Quick Model** - Train XGBoost to assess feature importance
- **Data Quality Report** - Detect anomalies, outliers, duplicates
- **Target leakage detection** - Identify features too correlated with target

#### Amazon SageMaker Canvas
- **No-code ML** - Business analysts build models
- **[📖 Canvas Documentation](https://docs.aws.amazon.com/sagemaker/latest/dg/canvas.html)**

#### Amazon QuickSight
- **BI dashboards** - Visualize model performance metrics
- **[📖 QuickSight ML Insights](https://docs.aws.amazon.com/quicksight/latest/user/ml-insights.html)** - Anomaly detection, forecasting
- **[📖 Q (QuickSight NLP)](https://docs.aws.amazon.com/quicksight/latest/user/quicksight-q.html)** - Natural language queries

#### Amazon Athena
- **Serverless SQL** - Query S3 data lakes
- **[📖 Athena ML](https://docs.aws.amazon.com/athena/latest/ug/querying-mlmodel.html)** - USING FUNCTION for SageMaker inference

#### Jupyter Notebooks
- **SageMaker Studio** - Integrated Jupyter environment
- **[📖 SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio.html)** - Code, debug, visualize
- **SageMaker Notebook Instances** - Managed Jupyter on EC2

### Statistical Analysis

#### Descriptive Statistics
- **Central tendency** - Mean, median, mode
- **Dispersion** - Variance, standard deviation, IQR
- **Distribution** - Skewness, kurtosis
- **Correlation** - Pearson, Spearman correlation coefficients
- **[📖 Pandas Profiling](https://github.com/ydataai/pandas-profiling)** - Automated EDA reports

#### Data Quality Issues
- **Missing values** - Imputation strategies (mean, median, mode, forward-fill)
- **[📖 Handling Missing Data](https://scikit-learn.org/stable/modules/impute.html)** - Scikit-learn imputers
- **Outliers** - Z-score, IQR method, isolation forest
- **Imbalanced classes** - SMOTE, undersampling, class weights
- **[📖 Imbalanced-learn](https://imbalanced-learn.org/)** - Resampling techniques
- **Duplicates** - Detect and remove duplicate records
- **Data drift** - Monitor feature distributions over time

#### Feature Engineering
- **Numerical transformations** - Log, square root, polynomial features
- **Scaling** - StandardScaler, MinMaxScaler, RobustScaler
- **Encoding categorical** - One-hot, ordinal, target encoding
- **[📖 Feature Engineering](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler-transform.html)** - Data Wrangler techniques
- **Binning** - Convert continuous to categorical
- **Feature crosses** - Interaction features (A × B)
- **Time features** - Extract hour, day, month, season

#### Dimensionality Reduction
- **PCA (Principal Component Analysis)** - Linear dimensionality reduction
- **[📖 SageMaker PCA](https://docs.aws.amazon.com/sagemaker/latest/dg/pca.html)** - Built-in algorithm
- **t-SNE** - Non-linear, visualization in 2D/3D
- **Feature selection** - Remove low-variance, high-correlation features
- **[📖 Feature Selection Methods](https://scikit-learn.org/stable/modules/feature_selection.html)**

### Data Splitting Strategies

#### Train/Validation/Test Split
- **70/15/15** or **80/10/10** - Typical splits
- **Stratified split** - Preserve class distribution
- **Time-based split** - For time-series (no random shuffle)
- **[📖 Scikit-learn Split](https://scikit-learn.org/stable/modules/cross_validation.html)**

#### Cross-Validation
- **K-fold CV** - Split into k folds, train on k-1
- **Stratified K-fold** - Maintain class balance
- **Time-series CV** - Walk-forward validation
- **Leave-one-out CV** - For small datasets

## Domain 3: Modeling (36%)

### Amazon SageMaker Built-in Algorithms

#### Linear Models
- **Linear Learner** - Linear regression, logistic regression, multiclass
- **[📖 Linear Learner](https://docs.aws.amazon.com/sagemaker/latest/dg/linear-learner.html)** - L1/L2 regularization, auto-tuning
- **Use cases**: Regression, binary/multiclass classification

#### Tree-Based Models
- **XGBoost** - Gradient boosting, best for tabular data
- **[📖 XGBoost Algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost.html)** - Hyperparameters, tuning
- **Hyperparameters**: `max_depth`, `eta` (learning rate), `subsample`, `num_round`
- **[📖 XGBoost Tuning](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost-tuning.html)**

#### Deep Learning
- **Image Classification** - ResNet, transfer learning
- **[📖 Image Classification](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)** - Built-in CNN
- **Object Detection** - Single Shot Detector (SSD)
- **[📖 Object Detection](https://docs.aws.amazon.com/sagemaker/latest/dg/object-detection.html)** - Bounding boxes
- **Semantic Segmentation** - Pixel-level classification
- **[📖 Semantic Segmentation](https://docs.aws.amazon.com/sagemaker/latest/dg/semantic-segmentation.html)**
- **Seq2Seq** - Machine translation, text summarization
- **[📖 Sequence to Sequence](https://docs.aws.amazon.com/sagemaker/latest/dg/seq-2-seq.html)** - RNN/LSTM/GRU

#### Clustering and Anomaly Detection
- **K-Means** - Unsupervised clustering
- **[📖 K-Means Algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/k-means.html)** - Web-scale clustering
- **Random Cut Forest (RCF)** - Anomaly detection
- **[📖 Random Cut Forest](https://docs.aws.amazon.com/sagemaker/latest/dg/randomcutforest.html)** - Time-series anomalies
- **IP Insights** - Detect anomalous IP usage patterns
- **[📖 IP Insights](https://docs.aws.amazon.com/sagemaker/latest/dg/ip-insights.html)**

#### NLP Algorithms
- **BlazingText** - Word2Vec, text classification
- **[📖 BlazingText](https://docs.aws.amazon.com/sagemaker/latest/dg/blazingtext.html)** - FastText implementation
- **Modes**: Word2Vec (unsupervised), text classification (supervised)
- **Object2Vec** - General-purpose embeddings
- **[📖 Object2Vec](https://docs.aws.amazon.com/sagemaker/latest/dg/object2vec.html)** - Sentence similarity, recommendations

#### Recommendation Systems
- **Factorization Machines** - Sparse data, click prediction
- **[📖 Factorization Machines](https://docs.aws.amazon.com/sagemaker/latest/dg/fact-machines.html)** - High-dimensional sparse datasets
- **Neural Topic Model (NTM)** - Topic modeling
- **[📖 NTM Algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/ntm.html)** - Document classification

#### Time-Series Forecasting
- **DeepAR** - Probabilistic forecasting with RNNs
- **[📖 DeepAR Forecasting](https://docs.aws.amazon.com/sagemaker/latest/dg/deepar.html)** - Multiple time-series
- **Produces**: Quantile predictions (P10, P50, P90)

### Deep Learning Frameworks

#### TensorFlow
- **[📖 TensorFlow on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/tf.html)** - Bring your own TensorFlow script
- **Keras API** - High-level API on TensorFlow
- **TensorFlow Serving** - Production model serving

#### PyTorch
- **[📖 PyTorch on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/pytorch.html)** - Custom PyTorch training
- **Distributed training** - Data parallel, model parallel
- **[📖 Distributed PyTorch](https://docs.aws.amazon.com/sagemaker/latest/dg/data-parallel-use-api.html)**

#### Apache MXNet
- **[📖 MXNet on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/mxnet.html)**
- **Gluon API** - Imperative and symbolic programming

#### Hugging Face
- **[📖 Hugging Face on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/hugging-face.html)** - Pre-trained NLP models
- **Transformers** - BERT, GPT, T5, RoBERTa
- **Use cases**: Text classification, NER, Q&A, summarization

### Model Training Strategies

#### Training Job Types
- **SageMaker Training Jobs** - Fully managed training
- **[📖 Training Jobs](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-training.html)** - Automatic provisioning
- **Spot Instances** - Up to 90% cost savings with managed spot training
- **[📖 Managed Spot Training](https://docs.aws.amazon.com/sagemaker/latest/dg/model-managed-spot-training.html)**

#### Distributed Training
- **Data parallelism** - Replicate model, split data across GPUs
- **[📖 Data Parallel Library](https://docs.aws.amazon.com/sagemaker/latest/dg/data-parallel.html)** - Near-linear scaling
- **Model parallelism** - Split large models across GPUs
- **[📖 Model Parallel Library](https://docs.aws.amazon.com/sagemaker/latest/dg/model-parallel.html)** - For models too large for 1 GPU
- **Parameter servers** - Asynchronous SGD with parameter servers

#### Training Input Modes
- **File mode** - Download full dataset to training instance
- **Pipe mode** - Stream data from S3 (faster, less disk usage)
- **[📖 Pipe Mode](https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-training-algo-running-container.html#your-algorithms-training-algo-running-container-inputdataconfig)** - RecordIO-Protobuf format
- **Fast File mode** - S3 FUSE mount (random access)

#### Hyperparameter Optimization
- **SageMaker Automatic Model Tuning** - Bayesian optimization
- **[📖 Hyperparameter Tuning](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning.html)** - Find best hyperparameters
- **[📖 Tuning Strategies](https://docs.aws.amazon.com/sagemaker/latest/dg/automatic-model-tuning-how-it-works.html)** - Bayesian, random, grid search
- **Hyperband** - Early stopping for low-performing trials
- **Warm start** - Use previous tuning job results
- **Objective metrics** - Maximize accuracy, minimize loss

### Model Evaluation Metrics

#### Classification Metrics
- **Accuracy** - (TP + TN) / Total
- **Precision** - TP / (TP + FP) - "Of predicted positive, how many correct?"
- **Recall** - TP / (TP + FN) - "Of actual positive, how many found?"
- **F1 Score** - 2 × (Precision × Recall) / (Precision + Recall)
- **[📖 Classification Metrics](https://scikit-learn.org/stable/modules/model_evaluation.html#classification-metrics)**
- **ROC-AUC** - Area under ROC curve (TPR vs FPR)
- **PR-AUC** - Area under precision-recall curve (better for imbalanced)
- **Confusion matrix** - TP, TN, FP, FN breakdown

#### Regression Metrics
- **MAE (Mean Absolute Error)** - Average absolute difference
- **MSE (Mean Squared Error)** - Average squared difference
- **RMSE (Root Mean Squared Error)** - Square root of MSE
- **R² (R-squared)** - Proportion of variance explained
- **[📖 Regression Metrics](https://scikit-learn.org/stable/modules/model_evaluation.html#regression-metrics)**

#### Ranking Metrics
- **MAP (Mean Average Precision)** - Quality of ranked results
- **NDCG (Normalized Discounted Cumulative Gain)** - Ranking quality with position weighting

### Regularization and Overfitting

#### Techniques to Prevent Overfitting
- **L1 regularization (Lasso)** - Adds sum of absolute weights to loss
- **L2 regularization (Ridge)** - Adds sum of squared weights to loss
- **Elastic Net** - Combines L1 + L2
- **Dropout** - Randomly drop neurons during training (neural networks)
- **Early stopping** - Stop when validation loss stops improving
- **Data augmentation** - Synthetic data variations (images, text)
- **Cross-validation** - Robust performance estimation

### Transfer Learning and Pre-trained Models

#### Transfer Learning
- **Use pre-trained models** - ImageNet for computer vision, BERT for NLP
- **[📖 Transfer Learning Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification-transfer-learning.html)**
- **Fine-tuning** - Retrain last layers on your dataset
- **Feature extraction** - Use pre-trained as feature extractor

#### AWS AI Services (Pre-trained Models)
- **Amazon Rekognition** - Image and video analysis
- **[📖 Rekognition](https://docs.aws.amazon.com/rekognition/)** - Face detection, object detection, content moderation
- **Amazon Comprehend** - NLP (sentiment, entities, key phrases)
- **[📖 Comprehend](https://docs.aws.amazon.com/comprehend/)** - Custom classification and entity recognition
- **Amazon Translate** - Neural machine translation
- **Amazon Polly** - Text-to-speech
- **Amazon Transcribe** - Speech-to-text
- **[📖 Transcribe](https://docs.aws.amazon.com/transcribe/)** - Custom vocabulary, real-time
- **Amazon Textract** - OCR and form extraction
- **[📖 Textract](https://docs.aws.amazon.com/textract/)** - Tables, forms, key-value pairs
- **Amazon Forecast** - Time-series forecasting
- **[📖 Forecast](https://docs.aws.amazon.com/forecast/)** - AutoML for forecasting
- **Amazon Personalize** - Real-time recommendations
- **[📖 Personalize](https://docs.aws.amazon.com/personalize/)** - User-item interactions
- **Amazon Lex** - Conversational AI chatbots
- **Amazon Kendra** - Intelligent search service

## Domain 4: ML Implementation & Operations (20%)

### Model Deployment

#### SageMaker Hosting Options
- **Real-time endpoints** - Low-latency predictions
- **[📖 Real-time Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html)** - Deploy model behind HTTPS
- **Serverless inference** - Auto-scaling, pay-per-request
- **[📖 Serverless Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/serverless-endpoints.html)** - No instances to manage
- **Batch transform** - Process large datasets asynchronously
- **[📖 Batch Transform](https://docs.aws.amazon.com/sagemaker/latest/dg/batch-transform.html)** - No persistent endpoint
- **Asynchronous inference** - Queue requests, long processing times
- **[📖 Async Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/async-inference.html)** - Up to 1 hour timeout

#### Endpoint Configuration
- **Multi-model endpoints** - Host multiple models on one endpoint (cost savings)
- **[📖 Multi-Model Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/multi-model-endpoints.html)** - Dynamic model loading
- **Multi-container endpoints** - Serial or direct inference pipeline
- **[📖 Multi-Container Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/multi-container-endpoints.html)**
- **Auto-scaling** - Scale based on invocations or custom metrics
- **[📖 Endpoint Auto Scaling](https://docs.aws.amazon.com/sagemaker/latest/dg/endpoint-auto-scaling.html)**
- **Instance types** - ml.t2.medium (dev) to ml.p4d.24xlarge (GPU inference)

#### Deployment Strategies
- **Blue/green deployment** - New endpoint, shift traffic gradually
- **[📖 Blue/Green Deployment](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)** - Canary, linear, all-at-once
- **Shadow testing** - Send production traffic to new model without affecting users
- **A/B testing** - Split traffic between model variants
- **[📖 A/B Testing](https://docs.aws.amazon.com/sagemaker/latest/dg/model-ab-testing.html)** - Production variants

### Model Monitoring

#### Amazon SageMaker Model Monitor
- **Data quality monitoring** - Detect data drift
- **[📖 Data Quality Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)** - Baseline vs production data
- **Model quality monitoring** - Detect model performance degradation
- **[📖 Model Quality Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html)** - Ground truth labels
- **Bias drift monitoring** - Detect bias in predictions
- **Feature attribution drift** - SHAP value changes
- **[📖 Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - Continuous monitoring

#### Amazon CloudWatch
- **Metrics** - Invocations, latency, errors
- **[📖 SageMaker CloudWatch Metrics](https://docs.aws.amazon.com/sagemaker/latest/dg/monitoring-cloudwatch.html)**
- **Alarms** - Trigger notifications on thresholds
- **Logs** - Training logs, endpoint logs

### MLOps and CI/CD

#### SageMaker Pipelines
- **ML workflows** - Orchestrate data prep, training, evaluation, deployment
- **[📖 SageMaker Pipelines](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)** - CI/CD for ML
- **Pipeline steps** - Processing, training, tuning, model, condition, callback
- **[📖 Pipeline Steps](https://docs.aws.amazon.com/sagemaker/latest/dg/build-and-manage-steps.html)**
- **Model Registry** - Versioning, approval workflow
- **[📖 Model Registry](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html)** - Approved, pending, rejected

#### SageMaker Projects
- **MLOps templates** - Pre-built CI/CD with CodePipeline, CodeBuild
- **[📖 SageMaker Projects](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html)** - Model building, deployment

#### Model Versioning
- **Model Registry** - Track model lineage
- **Model packages** - Bundle model artifacts, inference code
- **Approval status** - Require approval before production deployment

### Edge Deployment

#### SageMaker Edge Manager
- **Deploy to edge devices** - IoT, mobile, on-premises
- **[📖 Edge Manager](https://docs.aws.amazon.com/sagemaker/latest/dg/edge.html)** - Manage models on fleets
- **Edge Agent** - Runtime for model inference on device
- **Model optimization** - Compile with SageMaker Neo

#### SageMaker Neo
- **Model compilation** - Optimize for target hardware
- **[📖 SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)** - Up to 2x performance
- **Supported frameworks** - TensorFlow, PyTorch, MXNet, XGBoost
- **Supported devices** - ARM, Intel, Nvidia, Xilinx, edge devices

#### AWS IoT Greengrass
- **Edge runtime** - Deploy Lambda functions and models to edge
- **[📖 Greengrass ML Inference](https://docs.aws.amazon.com/greengrass/)** - Local inference

### Security and Compliance

#### IAM and Access Control
- **IAM roles** - Execution role for training jobs, hosting
- **[📖 SageMaker IAM Roles](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html)**
- **Resource policies** - Control access to models, endpoints
- **Condition keys** - Fine-grained access control

#### Network Isolation
- **VPC mode** - Training and hosting in private subnets
- **[📖 VPC Training and Hosting](https://docs.aws.amazon.com/sagemaker/latest/dg/host-vpc.html)** - No internet access
- **VPC endpoints** - Private connectivity to S3, ECR
- **Network isolation** - Block all network traffic from containers

#### Data Protection
- **Encryption at rest** - S3, EBS volumes encrypted with KMS
- **Encryption in transit** - TLS 1.2 for all API calls
- **[📖 SageMaker Security](https://docs.aws.amazon.com/sagemaker/latest/dg/security.html)**

#### Compliance
- **HIPAA eligible** - Healthcare workloads
- **PCI DSS** - Payment card data
- **SOC, ISO, FedRAMP** - Various compliance programs
- **[📖 SageMaker Compliance](https://aws.amazon.com/sagemaker/compliance/)**

### Cost Optimization

#### Training Cost Optimization
- **Managed spot training** - Up to 90% savings
- **Checkpointing** - Resume from checkpoint if spot interrupted
- **[📖 Spot Training Best Practices](https://docs.aws.amazon.com/sagemaker/latest/dg/model-managed-spot-training.html#model-managed-spot-training-best-practices)**
- **Rightsizing instances** - Start small, scale up if needed

#### Inference Cost Optimization
- **Multi-model endpoints** - Share infrastructure across models
- **Serverless inference** - Pay only for compute time used
- **Auto-scaling** - Scale down during low traffic
- **Batch transform** - No persistent endpoint costs

#### Storage Cost Optimization
- **S3 lifecycle policies** - Archive old data to Glacier
- **Delete intermediate data** - Training outputs, checkpoints

## Common Exam Scenarios

### Scenario 1: Data Preparation Pipeline
**Problem**: Large dataset in S3, needs ETL before training
**Solution**:
- Use **AWS Glue** for serverless ETL
- **Glue Crawler** discovers schema, populates Data Catalog
- **Glue job** transforms data to Parquet with Hive partitioning
- Store in S3, query with **Athena** for validation
- **[📖 Glue ETL Best Practices](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-best-practices.html)**

### Scenario 2: Hyperparameter Tuning at Scale
**Problem**: Need to find best hyperparameters for XGBoost
**Solution**:
- **SageMaker Automatic Model Tuning** with Bayesian optimization
- Define hyperparameter ranges (`max_depth`: 3-10, `eta`: 0.01-0.3)
- Specify objective metric (validation:auc)
- Use **managed spot training** for cost savings
- **[📖 XGBoost Tuning Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/xgboost-tuning.html)**

### Scenario 3: Real-time Image Classification
**Problem**: Deploy image classification model for low-latency inference
**Solution**:
- Use **SageMaker built-in Image Classification** or custom CNN
- **Transfer learning** from ResNet-50 pre-trained on ImageNet
- Deploy to **real-time endpoint** with GPU instance (ml.p3.2xlarge)
- Enable **auto-scaling** based on InvocationsPerInstance
- **A/B testing** with production variants
- **[📖 Image Classification Deployment](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)**

### Scenario 4: Batch Predictions on Large Dataset
**Problem**: Score 1 million records without persistent endpoint
**Solution**:
- Use **SageMaker Batch Transform**
- Input data in S3 (CSV or JSON Lines format)
- Specify instance type and count for parallelization
- Output predictions to S3
- No endpoint costs after job completes
- **[📖 Batch Transform Best Practices](https://docs.aws.amazon.com/sagemaker/latest/dg/batch-transform.html)**

### Scenario 5: Model Monitoring and Retraining
**Problem**: Detect model drift and trigger retraining
**Solution**:
- **SageMaker Model Monitor** for data quality monitoring
- Set baseline from training data
- Schedule monitoring jobs (hourly, daily)
- **CloudWatch alarm** triggers when drift detected
- **Lambda function** triggers SageMaker training job
- **SageMaker Pipelines** for automated retraining workflow
- **[📖 Model Monitor Drift Detection](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)**

### Scenario 6: Multi-Class Imbalanced Classification
**Problem**: Dataset has 1000:1 class imbalance
**Solution**:
- **SMOTE** (Synthetic Minority Over-sampling) or **undersampling**
- Use **class weights** in loss function
- Evaluation metrics: **F1 score**, **PR-AUC** (not accuracy!)
- Consider **anomaly detection** (Random Cut Forest) if extreme imbalance
- **[📖 Handling Imbalanced Data](https://imbalanced-learn.org/)**

### Scenario 7: Distributed Training for Large Model
**Problem**: Train 10B parameter Transformer model
**Solution**:
- Use **SageMaker model parallel library**
- Pipeline parallelism or tensor parallelism
- Multi-GPU instances (ml.p4d.24xlarge with 8x A100 GPUs)
- **Distributed data parallel** for data parallelism across nodes
- **[📖 Model Parallel Training](https://docs.aws.amazon.com/sagemaker/latest/dg/model-parallel.html)**

### Scenario 8: Secure ML in VPC
**Problem**: Healthcare data, must stay in private network
**Solution**:
- **VPC mode** for training and hosting
- Private subnets with no internet gateway
- **VPC endpoints** for S3, SageMaker, ECR
- **KMS encryption** for S3, EBS volumes
- **IAM roles** with least privilege
- **[📖 VPC Security Configuration](https://docs.aws.amazon.com/sagemaker/latest/dg/host-vpc.html)**

## Exam Tips

### Key Topics to Master
1. **SageMaker algorithms** - When to use each (XGBoost, Linear Learner, DeepAR, etc.)
2. **Data formats** - Parquet vs CSV, RecordIO-Protobuf for pipe mode
3. **Hyperparameter tuning** - Bayesian vs random, objective metrics
4. **Evaluation metrics** - Precision vs recall, when to use F1 vs AUC
5. **Deployment options** - Real-time vs batch vs serverless vs async
6. **Model monitoring** - Data drift, model drift detection
7. **Security** - VPC, encryption, IAM roles
8. **Cost optimization** - Spot training, serverless inference, multi-model endpoints

### Common Pitfalls
- **Confusing accuracy with F1** - Use F1 or PR-AUC for imbalanced classes
- **Not using spot training** - Always consider for cost savings
- **Wrong deployment type** - Batch transform for large one-time scoring, not real-time
- **Forgetting data drift** - Production models need continuous monitoring
- **Not using pipe mode** - Faster training for large datasets vs file mode

### Calculation and Formula Questions
- **Precision** = TP / (TP + FP)
- **Recall** = TP / (TP + FN)
- **F1 Score** = 2 × (Precision × Recall) / (Precision + Recall)
- **Training time estimate** - Consider instance type, data size, algorithm complexity
- **Cost estimate** - Instance hours × instance price (don't forget spot savings)

### AWS AI Services Decision Tree
- **Pre-trained model sufficient?** → Use AWS AI service (Rekognition, Comprehend, etc.)
- **Need custom model on tabular data?** → SageMaker XGBoost or Linear Learner
- **Need custom deep learning?** → SageMaker with TensorFlow/PyTorch
- **Need transfer learning?** → SageMaker built-in (Image Classification, BlazingText)
- **Need AutoML?** → SageMaker Autopilot or Canvas

### Algorithm Selection Guide

| Problem Type | Best Algorithm(s) | Notes |
|--------------|-------------------|-------|
| Binary classification (tabular) | XGBoost, Linear Learner | XGBoost usually best |
| Multi-class classification (tabular) | XGBoost, Linear Learner | |
| Regression | XGBoost, Linear Learner | |
| Image classification | Image Classification (ResNet) | Transfer learning from ImageNet |
| Object detection | Object Detection (SSD) | Bounding boxes |
| Text classification | BlazingText | Fast, scalable |
| Sentiment analysis | BlazingText, Comprehend | Comprehend for pre-trained |
| Time-series forecasting | DeepAR, Forecast | Forecast for AutoML |
| Anomaly detection | Random Cut Forest, IP Insights | RCF for time-series |
| Clustering | K-Means | Web-scale |
| Recommendations | Factorization Machines, Personalize | Personalize for pre-built |
| Embeddings | Object2Vec, BlazingText Word2Vec | |

## Essential Documentation

### Core SageMaker Documentation
- **[📖 SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/)** - Complete reference
- **[📖 Built-in Algorithms](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)** - All algorithm details
- **[📖 API Reference](https://docs.aws.amazon.com/sagemaker/latest/APIReference/)** - API operations

### Deep Dive Topics
- **[📖 Distributed Training](https://docs.aws.amazon.com/sagemaker/latest/dg/distributed-training.html)** - Data and model parallelism
- **[📖 SageMaker Pipelines MLOps](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html)** - CI/CD for ML
- **[📖 Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)** - Online and offline feature storage
- **[📖 Clarify Bias and Explainability](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-fairness-and-explainability.html)** - Detect bias, SHAP values
- **[📖 Debugger](https://docs.aws.amazon.com/sagemaker/latest/dg/train-debugger.html)** - Debug training jobs

### Hands-on Resources
- **[SageMaker Examples GitHub](https://github.com/aws/amazon-sagemaker-examples)** - 100+ notebooks
- **[AWS ML Blog](https://aws.amazon.com/blogs/machine-learning/)** - Latest techniques and case studies
- **[SageMaker Studio Lab](https://studiolab.sagemaker.aws/)** - FREE Jupyter environment

## Study Strategy

### Week 1-2: Data Engineering and EDA
- AWS Glue, EMR, data formats (Parquet, RecordIO)
- SageMaker Data Wrangler, feature engineering
- Statistical analysis, handling imbalanced data
- **Hands-on**: ETL pipeline, EDA in notebooks

### Week 3-5: Modeling
- SageMaker built-in algorithms (all of them!)
- Deep learning frameworks (TensorFlow, PyTorch)
- Hyperparameter tuning, distributed training
- Evaluation metrics, cross-validation
- **Hands-on**: Train XGBoost, Image Classification, DeepAR

### Week 6-7: ML Implementation and Operations
- Deployment options, multi-model endpoints
- Model monitoring, SageMaker Pipelines
- Security (VPC, IAM, encryption)
- Cost optimization strategies
- **Hands-on**: Deploy endpoint, set up monitoring, build pipeline

### Week 8: Practice Exams and Review
- Take 3+ full-length practice exams
- Review incorrect answers thoroughly
- Focus on weak areas
- Memorize key formulas and decision trees

## Recommended Resources

### Official AWS Training
- **[Exam Readiness: AWS Certified Machine Learning - Specialty](https://explore.skillbuilder.aws/learn/course/external/view/elearning/27/exam-readiness-aws-certified-machine-learning-specialty)** - FREE on AWS Skill Builder

### Practice Exams
- **AWS Official Practice Exam** - $40 (highly recommended)
- **Tutorials Dojo** - Comprehensive practice tests
- **Whizlabs** - Multiple practice exams

### Books and Courses
- **AWS Certified Machine Learning Specialty MLS-C01** by Frank Kane (Udemy)
- **AWS Machine Learning Specialty 2023** by Stephane Maarek (Udemy)

### Hands-on Practice
- **SageMaker Free Tier** - 250 hours Studio notebooks (first 2 months)
- **SageMaker Examples** - Official GitHub repository with 100+ notebooks

---

**Good luck with your AWS Machine Learning Specialty certification!** 🚀
