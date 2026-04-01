# Data Preparation for Machine Learning

**[Amazon SageMaker Data Preparation](https://docs.aws.amazon.com/sagemaker/latest/dg/data-prep.html)** - Data preparation overview

## S3 Data Lakes for ML

**[Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)** - Object storage for ML data

### Data Lake Architecture
- S3 is the primary storage layer for ML workloads on AWS
- Organize data in layers: raw, processed, features, model artifacts
- Use prefixes for partitioning: `/year=2025/month=04/day=01/`
- Enable versioning for data lineage and reproducibility

### Data Formats for ML

**Columnar Formats** (preferred for large datasets):
- **Apache Parquet** - columnar, compressed, schema-embedded, best for SageMaker
- **Apache ORC** - columnar, optimized for Hive/Spark
- Benefits: faster reads, smaller storage, column pruning

**Row Formats**:
- **CSV** - simple, widely supported, larger files
- **JSON/JSONL** - nested data, text/NLP workloads
- **RecordIO** - SageMaker native format, optimized for streaming

**SageMaker-Specific**:
- **RecordIO Protobuf** - optimized for SageMaker built-in algorithms
- **TFRecord** - TensorFlow native format
- **Pipe mode** - stream data directly from S3 (faster than File mode)

### S3 Performance for ML
- Use multiple prefixes for parallel data access
- Multipart upload for large files (>100 MB)
- S3 Transfer Acceleration for cross-region uploads
- S3 Select for retrieving subsets of data (reduce data transfer)

## AWS Glue ETL

**[AWS Glue](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)** - Serverless ETL service

### Glue Components

**Data Catalog**:
- Central metadata repository for all data assets
- Databases and tables with schema information
- Integration with Athena, EMR, Redshift, SageMaker
- Crawlers automatically discover and catalog data

**[Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html)** - Metadata management

**Crawlers**:
- Automatically discover data schema in S3, RDS, DynamoDB
- Create or update tables in the Data Catalog
- Schedule for regular schema updates
- Classify data formats automatically

**[Glue Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)** - Schema discovery

### ETL Jobs

**Job Types**:
- **Spark** - distributed processing for large datasets (PySpark/Scala)
- **Python Shell** - lightweight Python scripts for smaller datasets
- **Ray** - distributed Python for ML preprocessing
- **Streaming** - real-time ETL with micro-batches

**Common ML Transformations**:
- Data cleaning: remove duplicates, handle nulls, fix data types
- Aggregation: group-by operations, window functions
- Joins: combine data from multiple sources
- Format conversion: CSV to Parquet, JSON to columnar
- Partitioning: organize data for efficient queries

**[Glue ETL Jobs](https://docs.aws.amazon.com/glue/latest/dg/author-job.html)** - Creating ETL jobs

### Glue DataBrew

**[AWS Glue DataBrew](https://docs.aws.amazon.com/databrew/latest/dg/what-is.html)** - Visual data preparation

- Visual interface for data profiling and transformation
- 250+ pre-built transformations
- Data quality rules and validation
- Recipe-based transforms (reusable and shareable)
- Profile datasets to understand distributions and quality
- Export to S3, Glue Data Catalog, or SageMaker

### Glue Studio
- Visual ETL job authoring with drag-and-drop
- Built-in transforms for common operations
- Job monitoring and debugging
- Integration with Data Catalog and S3

## SageMaker Data Wrangler

**[SageMaker Data Wrangler](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler.html)** - Visual data preparation for ML

### Key Features
- Import data from S3, Athena, Redshift, Snowflake, and more
- Visual data exploration with built-in charts and statistics
- 300+ built-in data transformations
- Custom transforms using Pandas, PySpark, or SQL
- ML-specific transforms: encoding, scaling, imputation

### Data Flow
1. **Import** - connect to data sources
2. **Explore** - visualize distributions, correlations, statistics
3. **Transform** - apply transformations step by step
4. **Analyze** - data quality reports, target leakage detection
5. **Export** - to Pipeline, Processing job, Feature Store, or notebook

### Export Options
- **SageMaker Pipeline** - automated data preparation in pipeline
- **Processing Job** - standalone data processing
- **Feature Store** - ingest features for sharing and reuse
- **Python Script** - export as code for customization

**[Data Wrangler Transforms](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler-transform.html)** - Available transformations

## Feature Engineering

### Common Techniques

**Numerical Features**:
- **Standardization** (Z-score): mean=0, std=1 - good for SVM, logistic regression
- **Min-Max Scaling**: scale to [0,1] range - good for neural networks
- **Log Transform**: reduce skewness in distributions
- **Binning**: convert continuous to categorical

**Categorical Features**:
- **One-Hot Encoding**: binary column per category (sparse, no ordinality)
- **Label Encoding**: integer per category (implies ordinality)
- **Target Encoding**: replace with target mean (risk of leakage)
- **Embedding**: learned dense representations (deep learning)

**Text Features**:
- **TF-IDF**: term frequency-inverse document frequency
- **Word2Vec**: dense word embeddings (use BlazingText)
- **Tokenization**: split text into tokens
- **Bag of Words**: count-based representation

**Date/Time Features**:
- Extract components: year, month, day, hour, day of week
- Cyclical encoding for periodic features (sin/cos)
- Time since event, rolling aggregations

### Handling Missing Data
- **Remove** rows/columns with too many missing values
- **Mean/Median/Mode** imputation for numerical features
- **Forward/Backward fill** for time series
- **Indicator variable** to flag missing values
- **Model-based imputation** (KNN, regression)

### Feature Selection
- **Correlation analysis** - remove highly correlated features
- **Variance threshold** - remove low-variance features
- **Feature importance** - from tree-based models
- **Recursive Feature Elimination** - iteratively remove least important
- **PCA** - dimensionality reduction (SageMaker built-in algorithm)

## SageMaker Feature Store

**[SageMaker Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)** - Centralized feature management

### Core Concepts

**Feature Groups**:
- Collection of features with a schema
- Record identifier (unique key) and event time
- Online and/or offline store configuration
- KMS encryption and IAM access control

**[Feature Groups](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-create-feature-group.html)** - Creating feature groups

**Online Store**:
- Low-latency reads (single-digit millisecond)
- Latest feature values for real-time inference
- Backed by internal managed storage
- Automatic TTL for feature expiration

**Offline Store**:
- Historical feature values stored in S3
- Parquet format, partitioned by date
- Used for training and batch inference
- Supports time-travel queries for point-in-time correctness
- Integration with Athena for SQL queries

### Feature Ingestion
- **PutRecord API** - single record ingestion (real-time)
- **Batch ingestion** - using SageMaker Processing or Spark
- **Streaming ingestion** - from Kinesis Data Streams
- Data is written to both online and offline stores

### Point-in-Time Queries
- Retrieve feature values as they existed at a specific timestamp
- Prevents data leakage in training (no future feature values)
- Critical for training data consistency and reproducibility

## SageMaker Processing

**[SageMaker Processing](https://docs.aws.amazon.com/sagemaker/latest/dg/processing-job.html)** - Managed data processing

### Processing Job Configuration
- **Instance type and count** - select based on data size
- **Container** - built-in (scikit-learn, Spark) or custom
- **Input** - S3 data mounted to processing container
- **Output** - results written to S3
- **Network** - VPC configuration for security

### Built-in Containers
- **scikit-learn** - general-purpose ML preprocessing
- **Spark** - distributed processing for large datasets
- **Custom** - bring your own Docker container

### Common Use Cases
- Data preprocessing and cleaning
- Feature engineering at scale
- Model evaluation on test sets
- Data quality validation
- Post-training analysis

**[Processing Containers](https://docs.aws.amazon.com/sagemaker/latest/dg/processing-container-run-scripts.html)** - Using processing containers

## Data Quality and Validation

### SageMaker Data Quality Monitoring
- Create baseline from training data statistics
- Monitor incoming data against baseline
- Detect schema changes and distribution shifts
- Alert on violations via CloudWatch

### SageMaker Clarify for Data Analysis

**[SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-processing-job-run.html)** - Bias detection and data analysis

**Pre-Training Bias Metrics**:
- Class Imbalance (CI) - distribution of target classes
- Difference in Proportions of Labels (DPL) - label distribution across groups
- KL Divergence - distribution difference between groups
- Jensen-Shannon Divergence - symmetric distribution comparison

### Data Validation Best Practices
- Validate schema before training (column names, data types)
- Check for data leakage (target information in features)
- Monitor feature distributions for drift
- Verify data completeness and freshness
- Document data lineage and transformations

## Key Takeaways

1. **S3** is the primary data lake - use Parquet format for ML workloads
2. **Glue ETL** for large-scale data transformation and cataloging
3. **Data Wrangler** for visual, interactive data preparation
4. **Feature Store** for sharing and reusing features across models
5. **Online vs Offline Store** - online for real-time inference, offline for training
6. **Point-in-time queries** prevent data leakage in training datasets
7. **SageMaker Processing** for custom data processing at scale
8. **Clarify** for pre-training bias detection and data analysis
9. **Feature engineering** is critical - know encoding, scaling, and selection techniques
10. **Data quality** monitoring should be continuous, not one-time
