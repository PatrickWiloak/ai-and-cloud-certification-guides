# Data Preparation for ML (Domain 1 - 28%)

## Overview

Data preparation is the largest domain on the MLA-C01 exam. It covers ingesting, transforming, validating, and engineering features from raw data for machine learning workloads.

**📖 [Prepare Data](https://docs.aws.amazon.com/sagemaker/latest/dg/data-prep.html)** - SageMaker data preparation guide

---

## Amazon SageMaker Data Wrangler

SageMaker Data Wrangler provides a visual interface for data preparation and feature engineering without writing code.

### Key Capabilities
- **Import data** from S3, Athena, Redshift, Snowflake, and other sources
- **Visual transformations** — 300+ built-in transformations
- **Data quality insights** — automated analysis of data quality issues
- **Feature engineering** — create new features with visual tools or custom code
- **Export** — generate processing job code, pipelines, or Feature Store ingestion

### Common Transformations
- Handle missing values (impute, drop, fill)
- Encode categorical variables (one-hot, ordinal, target)
- Scale numeric features (standard, min-max, robust)
- Parse and transform datetime features
- Text vectorization (TF-IDF, count vectorizer)

**📖 [SageMaker Data Wrangler](https://docs.aws.amazon.com/sagemaker/latest/dg/data-wrangler.html)** - Complete guide

---

## Amazon SageMaker Feature Store

Feature Store is a centralized repository for storing, sharing, and managing ML features across teams.

### Architecture
- **Online Store** — Low-latency reads (single-digit millisecond) for real-time inference
- **Offline Store** — S3-based storage for training data and batch inference
- **Feature Groups** — Logical grouping of features with a schema

### Key Concepts
- **Record identifier** — Unique key for each record (e.g., customer_id)
- **Event time** — Timestamp for feature values (enables point-in-time queries)
- **Feature definitions** — Schema defining feature names and types
- **Ingestion** — Streaming (PutRecord API) or batch (Processing jobs)

### When to Use Feature Store
- Multiple teams need access to the same features
- Need consistent features between training and inference
- Want point-in-time correctness for historical training data
- Need to reduce duplicate feature engineering work

**📖 [Feature Store](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html)** - Documentation
**📖 [Feature Store Concepts](https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-getting-started.html)** - Getting started

---

## SageMaker Processing Jobs

Processing jobs run data preprocessing, postprocessing, and evaluation scripts on managed infrastructure.

### Key Features
- Run custom Python/Spark scripts
- Choose instance types and count
- Input from S3, output to S3
- Built-in containers for scikit-learn and Spark
- Bring your own container for custom dependencies

### Common Use Cases
- Data validation and quality checks
- Feature engineering at scale
- Model evaluation and reporting
- Data format conversion

**📖 [SageMaker Processing](https://docs.aws.amazon.com/sagemaker/latest/dg/processing-job.html)** - Processing jobs guide

---

## AWS Glue for ML Data Preparation

AWS Glue provides serverless ETL for preparing data at scale before ML training.

### Key Components for ML
- **Glue Crawlers** — Auto-discover schemas and partition structures in S3
- **Data Catalog** — Central metadata repository (integrates with Athena, Redshift Spectrum)
- **Glue ETL Jobs** — PySpark-based data transformation at scale
- **Glue DataBrew** — Visual data preparation (250+ transforms)
- **Glue Data Quality** — Define and evaluate data quality rules

### ML Data Prep Patterns with Glue
1. Crawl raw data in S3 → catalog schema → ETL transform → write to processed S3 bucket
2. Use DataBrew for exploration and profiling before building ETL
3. Apply data quality rules to validate data before training

**📖 [AWS Glue](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)** - Developer guide
**📖 [Glue DataBrew](https://docs.aws.amazon.com/databrew/latest/dg/what-is.html)** - Visual data preparation

---

## SageMaker Ground Truth

Ground Truth provides data labeling services for creating training datasets.

### Labeling Options
- **Amazon Mechanical Turk** — Crowdsourced human labeling
- **Private workforce** — Internal team labeling
- **Third-party vendors** — Professional labeling services
- **Automated labeling** — ML-assisted labeling (active learning)

### Supported Task Types
- Image classification, object detection, semantic segmentation
- Text classification, named entity recognition
- 3D point cloud labeling
- Video frame object detection and tracking

**📖 [SageMaker Ground Truth](https://docs.aws.amazon.com/sagemaker/latest/dg/sms.html)** - Data labeling

---

## Data Formats for SageMaker

### Input Formats
| Format | Best For | Notes |
|--------|----------|-------|
| **CSV** | Tabular data | Most common, universal support |
| **RecordIO** | Built-in algorithms | Optimized for SageMaker, supports streaming |
| **Parquet** | Large datasets | Columnar format, efficient compression |
| **JSON/JSONL** | NLP, structured data | Flexible schema |
| **LibSVM** | Sparse data | Efficient for sparse feature sets |
| **Image files** | Computer vision | JPEG, PNG (with manifest files) |

### Best Practices
- Use **Pipe mode** for large datasets (streams from S3, reduces startup time)
- Use **File mode** for small datasets or algorithms that need random access
- Partition data in S3 by date/category for efficient processing
- Use **Parquet** for large tabular datasets (better compression, faster reads)

**📖 [Common Data Formats](https://docs.aws.amazon.com/sagemaker/latest/dg/cdf-training.html)** - Training data formats

---

## Feature Engineering Techniques

### Numeric Features
- **Standardization** (z-score): `(x - mean) / std` — when features have different scales
- **Min-Max Scaling**: `(x - min) / (max - min)` — when you need bounded [0,1] range
- **Log Transform**: `log(x + 1)` — for right-skewed distributions
- **Binning**: Convert continuous to categorical (age groups, price ranges)

### Categorical Features
- **One-Hot Encoding**: Create binary columns per category (low cardinality)
- **Label Encoding**: Map categories to integers (ordinal data)
- **Target Encoding**: Replace category with target mean (high cardinality)
- **Embedding**: Learn dense representations (deep learning)

### Text Features
- **Bag of Words / TF-IDF**: Traditional text vectorization
- **Word Embeddings**: Word2Vec, GloVe, FastText
- **Sentence Embeddings**: For semantic similarity tasks

### Handling Missing Data
- **Drop** rows/columns with too many missing values
- **Impute** with mean/median/mode for numeric data
- **Impute** with most frequent value or "Unknown" for categorical
- **Use algorithms that handle missing values** (XGBoost)

---

## Exam Tips for Domain 1

1. **Know when to use Feature Store vs processing jobs** — Feature Store for shared/reusable features; processing jobs for one-off transformations
2. **Understand Pipe mode vs File mode** — Pipe mode streams data, better for large datasets
3. **Know Ground Truth labeling workflows** — automatic labeling uses ML to reduce human labeling effort
4. **Glue vs Data Wrangler** — Glue for large-scale ETL; Data Wrangler for interactive, visual data exploration
5. **Data quality** — SageMaker Data Wrangler and Glue Data Quality both offer data quality checks
