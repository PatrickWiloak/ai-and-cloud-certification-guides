# AWS Certified Machine Learning - Specialty (MLS-C01) - RETIRED

## Important Notice

**The AWS Certified Machine Learning - Specialty (MLS-C01) certification was retired on April 15, 2025.**

This certification is no longer available for new candidates. If you hold this certification, your credential will remain valid for three years from the date you earned it.

## Replacement Certification

AWS has launched the **AWS Certified Machine Learning Engineer - Associate (MLA-C01)** as the modern replacement.

**[📖 AWS Machine Learning Engineer - Associate](https://aws.amazon.com/certification/certified-machine-learning-engineer-associate/)** - Official certification page

### Key Differences
- **Level**: Associate (vs. Specialty for MLS-C01)
- **Focus**: SageMaker-centric ML engineering and MLOps, with strong coverage of Bedrock and generative AI
- **Modern Services**: Updated to include current SageMaker capabilities, Bedrock, and contemporary MLOps tooling
- **Career Alignment**: Better aligned with today's ML engineer / MLOps roles

## For Current Credential Holders

If you currently hold the MLS-C01 certification:
- Your certification remains valid for 3 years from the date earned
- Maintain your credential by earning other AWS certifications
- Consider AWS Certified Machine Learning Engineer - Associate (MLA-C01) to stay current

---

> The historical study material below is preserved for credential holders and as a reference. For new candidates, study the [MLA-C01 fact sheet](../../associate/ml-engineer-mla-c01/fact-sheet.md) instead.

## Historical Exam Overview (MLS-C01)

The AWS Certified Machine Learning - Specialty (MLS-C01) exam validated expertise in building, training, tuning, and deploying machine learning models using AWS Cloud. This certification demonstrated the ability to design, implement, deploy, and maintain machine learning solutions for given business problems.

### Exam Details
- **Exam Code**: MLS-C01
- **Duration**: 180 minutes (3 hours)
- **Format**: Multiple choice and multiple response
- **Number of Questions**: 65 scored questions
- **Passing Score**: 750/1000
- **Cost**: $300 USD
- **Language**: Available in multiple languages
- **Delivery**: Testing center or online proctoring
- **Validity**: 3 years
- **Prerequisites**: 1-2 years hands-on experience developing, architecting, or running ML workloads on AWS

## Exam Domains

### Domain 1: Data Engineering (20% of scored content)
- Create data repositories for machine learning
- Identify and implement a data ingestion solution
- Identify and implement a data transformation solution

#### Key Focus Areas:
- Data lake and data warehouse architectures
- ETL/ELT pipelines with AWS Glue and other services
- Data formats and storage optimization
- Real-time and batch data processing
- Data versioning and lineage tracking
- Feature stores and data preparation

### Domain 2: Exploratory Data Analysis (24% of scored content)
- Sanitize and prepare data for modeling
- Perform feature engineering
- Analyze and visualize data for machine learning

#### Key Focus Areas:
- Data cleaning and preprocessing techniques
- Feature engineering and selection strategies
- Statistical analysis and hypothesis testing
- Data visualization with Amazon QuickSight
- Outlier detection and handling
- Data bias identification and mitigation

### Domain 3: Modeling (36% of scored content)
- Frame business problems as machine learning problems
- Select the appropriate model(s) for a given machine learning problem
- Train machine learning models
- Perform hyperparameter optimization
- Evaluate machine learning models

#### Key Focus Areas:
- ML problem formulation and approach selection
- Algorithm selection for different problem types
- Amazon SageMaker training jobs and built-in algorithms
- Custom model development and containerization
- Hyperparameter tuning strategies and automation
- Model evaluation metrics and validation techniques

### Domain 4: Machine Learning Implementation and Operations (20% of scored content)
- Build machine learning solutions for performance, availability, scalability, resiliency, and fault tolerance
- Recommend and implement the appropriate machine learning services and features for a given problem
- Apply basic AWS security practices to machine learning solutions
- Deploy and operationalize machine learning solutions

#### Key Focus Areas:
- Model deployment strategies and endpoints
- Auto-scaling and performance optimization
- A/B testing and canary deployments
- Model monitoring and drift detection
- CI/CD for machine learning pipelines
- Security and compliance in ML workflows

## Core AWS Machine Learning Services

### Amazon SageMaker

#### SageMaker Studio
- **Integrated Development Environment**: Web-based IDE for ML development
- **Jupyter Notebooks**: Managed Jupyter notebook instances
- **Experiment Management**: Track and compare ML experiments
- **Model Registry**: Centralized model repository with versioning
- **Feature Store**: Centralized repository for ML features
- **Data Wrangler**: Visual data preparation and feature engineering

#### SageMaker Training
- **Built-in Algorithms**: Pre-built algorithms for common ML tasks
- **Bring Your Own Container**: Custom algorithm containerization
- **Distributed Training**: Multi-instance and multi-GPU training
- **Spot Training**: Cost-effective training with EC2 Spot instances
- **Automatic Model Tuning**: Hyperparameter optimization service
- **Debugger**: Real-time training job monitoring and debugging

#### SageMaker Inference
- **Real-time Endpoints**: Low-latency model serving
- **Batch Transform**: Batch inference for large datasets
- **Multi-Model Endpoints**: Host multiple models on single endpoint
- **Auto Scaling**: Automatic endpoint scaling based on traffic
- **Inference Pipelines**: Chain multiple containers for preprocessing and inference
- **Edge Deployment**: Deploy models to edge devices with SageMaker Neo

#### SageMaker Pipelines
- **ML Workflows**: Define and orchestrate ML workflows
- **Pipeline Steps**: Data processing, training, and deployment steps
- **Conditional Execution**: Dynamic workflow execution based on conditions
- **Caching**: Step-level caching for efficiency
- **Integration**: Native integration with other SageMaker services
- **Monitoring**: Pipeline execution monitoring and alerting

### AI Services

#### Amazon Comprehend
- **Natural Language Processing**: Text analysis and insights
- **Sentiment Analysis**: Detect sentiment in text
- **Entity Recognition**: Identify people, places, and things
- **Key Phrase Extraction**: Extract important phrases
- **Language Detection**: Identify the language of text
- **Custom Models**: Train custom NLP models

#### Amazon Rekognition
- **Computer Vision**: Image and video analysis
- **Object Detection**: Identify objects and scenes
- **Facial Analysis**: Detect and analyze faces
- **Text Detection**: Extract text from images
- **Content Moderation**: Detect inappropriate content
- **Custom Labels**: Train custom image classification models

#### Amazon Textract
- **Document Analysis**: Extract text and data from documents
- **Form Processing**: Extract key-value pairs from forms
- **Table Extraction**: Extract structured data from tables
- **Handwriting Recognition**: Process handwritten text
- **Async Processing**: Handle large document processing jobs
- **Output Formats**: Multiple output formats for downstream processing

#### Amazon Transcribe
- **Speech-to-Text**: Convert audio to text
- **Real-time Streaming**: Live audio transcription
- **Speaker Identification**: Identify different speakers
- **Custom Vocabulary**: Improve accuracy with domain-specific terms
- **Language Support**: Multiple language support
- **Medical Transcription**: Specialized medical vocabulary and formatting

#### Amazon Translate
- **Neural Machine Translation**: High-quality text translation
- **Real-time Translation**: Low-latency translation service
- **Batch Translation**: Process large volumes of text
- **Custom Terminology**: Domain-specific translation customization
- **Language Detection**: Automatic source language detection
- **Formality Control**: Adjust translation formality level

#### Amazon Polly
- **Text-to-Speech**: Convert text to lifelike speech
- **Neural Voices**: High-quality neural text-to-speech
- **SSML Support**: Speech Synthesis Markup Language
- **Lexicons**: Custom pronunciation controls
- **Speech Marks**: Synchronize speech with visual content
- **Multiple Output Formats**: Various audio format support

### Data Processing and Analytics

#### AWS Glue
- **ETL Service**: Managed extract, transform, and load service
- **Data Catalog**: Centralized metadata repository
- **Crawlers**: Automatic schema discovery and cataloging
- **Job Scheduling**: Automated ETL job execution
- **DataBrew**: Visual data preparation service
- **Schema Registry**: Manage and evolve data schemas

#### Amazon Kinesis
- **Data Streaming**: Real-time data ingestion and processing
- **Kinesis Data Streams**: Scalable real-time data streaming
- **Kinesis Data Firehose**: Load streaming data into data stores
- **Kinesis Analytics**: Real-time analytics on streaming data
- **Video Streams**: Capture and process video streams
- **Integration**: ML model integration for real-time inference

#### Amazon EMR
- **Big Data Processing**: Managed cluster platform for big data frameworks
- **Spark and Hadoop**: Support for Apache Spark, Hadoop, and other frameworks
- **Notebooks**: Managed Jupyter notebook environments
- **Auto Scaling**: Automatic cluster scaling based on workload
- **Cost Optimization**: Spot instances and reserved capacity
- **Integration**: SageMaker and other AWS service integration

### Storage and Databases

#### Amazon S3
- **Data Lake Storage**: Scalable object storage for ML datasets
- **Storage Classes**: Optimize costs with different storage classes
- **Data Partitioning**: Optimize query performance with partitioning
- **Event Notifications**: Trigger ML workflows on data changes
- **Access Patterns**: Optimize for different ML access patterns
- **Security**: Encryption and access control for ML data

#### Amazon DynamoDB
- **NoSQL Database**: Fast, scalable NoSQL database
- **Feature Storage**: Store ML features with low-latency access
- **Streams**: Capture data changes for real-time ML
- **Global Tables**: Multi-region replication for global ML applications
- **Performance**: Consistent single-digit millisecond latency
- **Integration**: Native integration with ML services

## Machine Learning Fundamentals

### Problem Types and Algorithms

#### Supervised Learning
- **Linear and Logistic Regression**: Fundamental regression and classification
- **Decision Trees and Random Forest**: Tree-based algorithms
- **Support Vector Machines**: Margin-based classification
- **Neural Networks**: Deep learning approaches
- **Ensemble Methods**: Combining multiple models
- **Time Series Forecasting**: Temporal data prediction

#### Unsupervised Learning
- **Clustering**: K-means, hierarchical, and density-based clustering
- **Dimensionality Reduction**: PCA, t-SNE, and autoencoders
- **Anomaly Detection**: Statistical and ML-based approaches
- **Association Rules**: Market basket analysis and recommendations
- **Topic Modeling**: Text analysis and document clustering
- **Generative Models**: GANs and variational autoencoders

#### Reinforcement Learning
- **Q-Learning**: Value-based reinforcement learning
- **Policy Gradient**: Policy-based approaches
- **Actor-Critic**: Hybrid value and policy methods
- **Multi-Armed Bandits**: Exploration vs exploitation
- **Deep Reinforcement Learning**: Neural network-based RL
- **Applications**: Game playing, robotics, and optimization

### Feature Engineering

#### Data Preprocessing
- **Data Cleaning**: Handle missing values, outliers, and inconsistencies
- **Data Normalization**: Scaling and standardization techniques
- **Categorical Encoding**: One-hot encoding, label encoding, target encoding
- **Text Processing**: Tokenization, stemming, and vectorization
- **Image Processing**: Resizing, normalization, and augmentation
- **Time Series**: Seasonality, trends, and lag features

#### Feature Selection
- **Filter Methods**: Statistical tests and correlation analysis
- **Wrapper Methods**: Forward/backward selection and recursive elimination
- **Embedded Methods**: L1/L2 regularization and tree-based importance
- **Dimensionality Reduction**: PCA, LDA, and feature extraction
- **Domain Knowledge**: Expert-driven feature creation
- **Automated Feature Engineering**: Tools and techniques for automation

### Model Evaluation and Validation

#### Evaluation Metrics
- **Classification**: Accuracy, precision, recall, F1-score, AUC-ROC
- **Regression**: MAE, MSE, RMSE, R-squared, MAPE
- **Ranking**: NDCG, MAP, MRR
- **Clustering**: Silhouette score, Davies-Bouldin index
- **Time Series**: MASE, sMAPE, MSIS
- **Business Metrics**: Custom metrics aligned with business objectives

#### Validation Techniques
- **Cross-Validation**: K-fold, stratified, and time series cross-validation
- **Hold-out Validation**: Train/validation/test splits
- **Bootstrap Sampling**: Resampling techniques for uncertainty estimation
- **Nested Cross-Validation**: Hyperparameter tuning with proper validation
- **Temporal Validation**: Time-aware validation for temporal data
- **A/B Testing**: Online evaluation and experimentation

### Hyperparameter Optimization

#### Search Strategies
- **Grid Search**: Exhaustive search over parameter grid
- **Random Search**: Random sampling of parameter space
- **Bayesian Optimization**: Efficient search using Gaussian processes
- **Evolutionary Algorithms**: Genetic algorithms and particle swarm optimization
- **Multi-Fidelity**: Early stopping and successive halving
- **Neural Architecture Search**: Automated neural network design

#### SageMaker Automatic Model Tuning
- **Hyperparameter Tuning Jobs**: Automated hyperparameter optimization
- **Search Strategies**: Bayesian, random, and grid search
- **Early Stopping**: Automatic stopping of unpromising training jobs
- **Warm Start**: Initialize tuning with previous results
- **Multi-Objective**: Optimize for multiple metrics simultaneously
- **Integration**: Seamless integration with SageMaker training

## MLOps and Production Deployment

### Model Deployment Strategies

#### Real-time Inference
- **SageMaker Endpoints**: Managed model hosting with auto-scaling
- **Multi-Model Endpoints**: Cost-effective hosting for multiple models
- **Inference Pipelines**: Chaining preprocessing and inference
- **Container Optimization**: Performance tuning for inference containers
- **Load Testing**: Ensuring performance under production load
- **Monitoring**: Real-time monitoring of inference performance

#### Batch Inference
- **Batch Transform Jobs**: Large-scale batch inference
- **Distributed Processing**: Parallel processing for large datasets
- **Cost Optimization**: Using Spot instances for batch jobs
- **Scheduling**: Automated batch job scheduling and orchestration
- **Output Management**: Efficient handling of batch inference results
- **Error Handling**: Robust error handling and retry mechanisms

#### Edge Deployment
- **SageMaker Neo**: Model optimization for edge devices
- **IoT Greengrass**: Deploy ML models to IoT devices
- **Model Compression**: Techniques to reduce model size
- **Quantization**: Reduce model precision for edge deployment
- **Hardware Optimization**: Leverage specialized hardware accelerators
- **Offline Inference**: Deploy models for offline operation

### Model Monitoring and Management

#### Model Performance Monitoring
- **Data Drift Detection**: Monitor changes in input data distribution
- **Model Drift Detection**: Monitor degradation in model performance
- **Concept Drift**: Detect changes in the relationship between features and target
- **Feature Attribution**: Understanding model predictions and decisions
- **Bias Detection**: Monitor for bias in model predictions
- **Explainability**: Techniques for model interpretation and explanation

#### Model Versioning and Registry
- **Model Registry**: Centralized repository for model artifacts
- **Version Control**: Track model versions and lineage
- **Model Approval**: Automated and manual model approval workflows
- **A/B Testing**: Compare model versions in production
- **Rollback Mechanisms**: Quick rollback to previous model versions
- **Metadata Management**: Track model metrics, hyperparameters, and performance

### CI/CD for Machine Learning

#### MLOps Pipelines
- **Code Integration**: Version control for ML code and experiments
- **Automated Testing**: Unit tests, integration tests, and model validation
- **Pipeline Orchestration**: Automated ML workflow execution
- **Artifact Management**: Track datasets, models, and experiment results
- **Deployment Automation**: Automated model deployment and promotion
- **Monitoring Integration**: Automated monitoring and alerting setup

#### Infrastructure as Code
- **CloudFormation**: Infrastructure automation for ML workloads
- **CDK**: Programmatic infrastructure definition and deployment
- **Terraform**: Multi-cloud infrastructure automation
- **Container Orchestration**: Kubernetes and ECS for ML workloads
- **Serverless ML**: Lambda and serverless architectures for ML
- **Cost Management**: Automated cost optimization and resource management

## Study Strategy

### Prerequisites
- **Statistics and Mathematics**: Strong foundation in statistics, linear algebra, and calculus
- **Programming Skills**: Python/R programming with ML libraries (scikit-learn, pandas, numpy)
- **AWS Foundation**: AWS Associate-level knowledge and hands-on experience
- **ML Experience**: 1-2 years of hands-on ML project experience
- **Data Engineering**: Understanding of data pipelines and processing

### Phase 1: AWS ML Services (4-5 weeks)
1. **SageMaker Deep Dive**
   - Studio environment and notebook management
   - Training jobs and built-in algorithms
   - Hyperparameter tuning and experiments
   - Model deployment and inference

2. **AI Services**
   - Comprehend for NLP tasks
   - Rekognition for computer vision
   - Textract for document processing
   - Transcribe and Translate for multimedia

### Phase 2: Data Engineering and Processing (3-4 weeks)
1. **Data Pipeline Design**
   - AWS Glue for ETL operations
   - Kinesis for real-time processing
   - EMR for big data processing
   - S3 optimization for ML workloads

2. **Feature Engineering**
   - Data preparation techniques
   - Feature selection and extraction
   - SageMaker Data Wrangler
   - Feature store implementation

### Phase 3: Advanced ML Concepts (4-5 weeks)
1. **Algorithm Selection and Implementation**
   - Supervised learning algorithms
   - Unsupervised learning techniques
   - Deep learning with SageMaker
   - Custom algorithm development

2. **Model Optimization**
   - Hyperparameter tuning strategies
   - Model evaluation and validation
   - Performance optimization
   - Bias detection and mitigation

### Phase 4: MLOps and Production (2-3 weeks)
1. **Deployment and Monitoring**
   - Production deployment strategies
   - Model monitoring and drift detection
   - A/B testing and experimentation
   - Performance optimization

2. **Automation and Orchestration**
   - ML pipeline automation
   - CI/CD for ML workflows
   - Infrastructure as code
   - Cost optimization strategies

## Hands-on Lab Recommendations

### Essential ML Labs
1. **End-to-End ML Pipeline**
   - Data ingestion and preprocessing
   - Feature engineering and selection
   - Model training and hyperparameter tuning
   - Deployment and monitoring

2. **Computer Vision Project**
   - Image classification with SageMaker
   - Custom model training with transfer learning
   - Real-time inference endpoint
   - Performance optimization and monitoring

3. **Natural Language Processing**
   - Text classification and sentiment analysis
   - Custom entity recognition
   - Document processing pipeline
   - Multi-language support implementation

4. **Time Series Forecasting**
   - Data preparation for time series
   - Feature engineering for temporal data
   - Model selection and evaluation
   - Production deployment and monitoring

## Exam Preparation Tips

### Study Resources
- **AWS ML Whitepapers**: Machine learning best practices and architectures
- **SageMaker Documentation**: Comprehensive service documentation
- **Research Papers**: Stay current with ML research and techniques
- **Hands-on Tutorials**: AWS ML tutorials and workshops
- **Re:Invent Sessions**: Latest ML features and case studies

### Practical Experience
- **Real Projects**: Work on end-to-end ML projects
- **Kaggle Competitions**: Practice with diverse datasets and problems
- **Open Source Contributions**: Contribute to ML open source projects
- **Industry Use Cases**: Study ML applications in different industries
- **Performance Optimization**: Experience with production ML systems

### Exam Strategy
- **Problem Analysis**: Identify ML problem type and appropriate approach
- **Service Selection**: Choose the right AWS service for each use case
- **Best Practices**: Apply ML and AWS best practices
- **Cost Optimization**: Consider cost implications of different approaches
- **Scalability**: Design for production scale and performance

## Common Exam Scenarios

### Business Problem Formulation
- Converting business requirements to ML problems
- Selecting appropriate algorithms and approaches
- Defining success metrics and evaluation criteria
- Considering data availability and quality constraints

### Data Engineering and Preparation
- Designing data pipelines for ML workloads
- Implementing feature engineering strategies
- Handling missing data and outliers
- Optimizing data storage and access patterns

### Model Development and Training
- Selecting appropriate algorithms for different problem types
- Implementing hyperparameter optimization strategies
- Handling imbalanced datasets and bias
- Evaluating model performance and generalization

### Production Deployment and Operations
- Designing scalable inference architectures
- Implementing model monitoring and drift detection
- Setting up A/B testing and experimentation
- Automating ML workflows and operations

## Next Steps After Certification

### Career Advancement
- ML engineer and data scientist roles
- ML architect and consultant positions
- Research scientist and applied researcher roles
- ML platform and infrastructure engineering

### Continuous Learning
- Advanced ML techniques and research
- Other AWS specialty certifications
- Industry-specific ML applications
- Emerging technologies (MLOps, AutoML, etc.)

### Professional Development
- ML community participation and contribution
- Conference speaking and content creation
- Open-source ML project leadership
- Mentoring and knowledge sharing in ML teams