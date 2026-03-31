# Spark ML - Databricks ML Associate

## Overview

This section covers Spark MLlib and the Pipeline API, representing 17% of the exam. You need to understand Transformers, Estimators, Pipelines, and distributed model training with Spark.

**[📖 MLlib Guide](https://spark.apache.org/docs/latest/ml-guide.html)** - Spark ML reference
**[📖 Pipeline API](https://spark.apache.org/docs/latest/ml-pipeline.html)** - Pipeline components

## Key Topics

### 1. Pipeline API Concepts

The Spark ML Pipeline API provides a uniform interface for building ML workflows. It chains together data preparation and model training steps.

**Core Components:**
| Component | Description | Example |
|-----------|-------------|---------|
| Transformer | Transforms a DataFrame (adds columns) | VectorAssembler, StringIndexer |
| Estimator | Fits on data to produce a Transformer | LogisticRegression, RandomForestClassifier |
| Pipeline | Chain of Transformers and Estimators | Full ML workflow |
| PipelineModel | Fitted Pipeline (all stages fitted) | Ready for predictions |

**Basic Pipeline Example:**
```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import VectorAssembler, StringIndexer, StandardScaler
from pyspark.ml.classification import LogisticRegression

# Define stages
indexer = StringIndexer(inputCol="category", outputCol="category_index")
assembler = VectorAssembler(inputCols=["feature1", "feature2", "category_index"],
                            outputCol="features")
scaler = StandardScaler(inputCol="features", outputCol="scaled_features")
lr = LogisticRegression(featuresCol="scaled_features", labelCol="label")

# Build and fit pipeline
pipeline = Pipeline(stages=[indexer, assembler, scaler, lr])
model = pipeline.fit(train_df)

# Make predictions
predictions = model.transform(test_df)
```

### 2. Common Transformers

**[📖 Feature Transformers](https://spark.apache.org/docs/latest/ml-features.html)** - Feature transformation

| Transformer | Purpose | Input | Output |
|------------|---------|-------|--------|
| VectorAssembler | Combine columns into feature vector | Multiple columns | Single vector column |
| StringIndexer | Convert strings to numeric indices | String column | Numeric column |
| OneHotEncoder | Convert indices to binary vectors | Numeric index | Sparse vector |
| StandardScaler | Standardize features (zero mean, unit variance) | Vector column | Scaled vector |
| MinMaxScaler | Scale features to [0, 1] | Vector column | Scaled vector |
| Imputer | Fill missing values | Numeric columns | Filled columns |
| Bucketizer | Bin continuous values into buckets | Numeric column | Bucket index |
| Tokenizer | Split text into words | String column | Array of words |
| HashingTF | Convert words to term frequency vectors | Array of words | Feature vector |

```python
# VectorAssembler - required before any ML algorithm
assembler = VectorAssembler(
    inputCols=["age", "income", "score"],
    outputCol="features"
)

# StringIndexer - convert categorical strings to numbers
indexer = StringIndexer(inputCol="city", outputCol="city_index")

# OneHotEncoder - create binary vectors from indices
encoder = OneHotEncoder(inputCol="city_index", outputCol="city_vec")
```

**Key Concepts:**
- VectorAssembler is almost always required - ML algorithms expect a single feature vector
- StringIndexer assigns indices by frequency (most frequent = 0)
- OneHotEncoder creates sparse vectors (memory efficient)
- Order of transformers matters - indexing before encoding, assembly before scaling

### 3. Common Estimators (ML Algorithms)

**Classification:**
| Algorithm | Use Case | Key Parameters |
|-----------|----------|----------------|
| LogisticRegression | Binary/multiclass | maxIter, regParam, elasticNetParam |
| RandomForestClassifier | Ensemble classification | numTrees, maxDepth, maxBins |
| GBTClassifier | Gradient-boosted trees | maxIter, maxDepth, stepSize |
| DecisionTreeClassifier | Simple interpretable model | maxDepth, maxBins |

**Regression:**
| Algorithm | Use Case | Key Parameters |
|-----------|----------|----------------|
| LinearRegression | Linear relationships | maxIter, regParam, elasticNetParam |
| RandomForestRegressor | Ensemble regression | numTrees, maxDepth |
| GBTRegressor | Gradient-boosted trees | maxIter, maxDepth |

**Clustering:**
| Algorithm | Use Case | Key Parameters |
|-----------|----------|----------------|
| KMeans | Partitioning clusters | k, maxIter, seed |
| BisectingKMeans | Hierarchical clustering | k, maxIter |

### 4. Model Selection and Tuning

**[📖 CrossValidator](https://spark.apache.org/docs/latest/ml-tuning.html)** - Model selection

**CrossValidator:**
```python
from pyspark.ml.tuning import CrossValidator, ParamGridBuilder
from pyspark.ml.evaluation import BinaryClassificationEvaluator

# Define parameter grid
paramGrid = (ParamGridBuilder()
    .addGrid(lr.regParam, [0.01, 0.1, 1.0])
    .addGrid(lr.maxIter, [50, 100, 200])
    .build())

# Define evaluator
evaluator = BinaryClassificationEvaluator(metricName="areaUnderROC")

# Cross-validate
cv = CrossValidator(
    estimator=pipeline,
    estimatorParamMaps=paramGrid,
    evaluator=evaluator,
    numFolds=5
)
cv_model = cv.fit(train_df)
best_model = cv_model.bestModel
```

**TrainValidationSplit:**
```python
from pyspark.ml.tuning import TrainValidationSplit

tvs = TrainValidationSplit(
    estimator=pipeline,
    estimatorParamMaps=paramGrid,
    evaluator=evaluator,
    trainRatio=0.8
)
tvs_model = tvs.fit(train_df)
```

**Key Concepts:**
- CrossValidator: k-fold cross-validation (more robust, slower)
- TrainValidationSplit: single train/validation split (faster, less robust)
- ParamGridBuilder defines the hyperparameter search space
- Evaluator defines the metric to optimize
- Both return the best model automatically

### 5. Evaluators

| Evaluator | Metrics | Use Case |
|-----------|---------|----------|
| BinaryClassificationEvaluator | areaUnderROC, areaUnderPR | Binary classification |
| MulticlassClassificationEvaluator | accuracy, f1, precision, recall | Multi-class classification |
| RegressionEvaluator | rmse, mse, mae, r2 | Regression |
| ClusteringEvaluator | silhouette | Clustering |

### 6. Saving and Loading Models

```python
# Save a pipeline model
model.save("/path/to/model")

# Load a pipeline model
from pyspark.ml import PipelineModel
loaded_model = PipelineModel.load("/path/to/model")

# Make predictions with loaded model
predictions = loaded_model.transform(new_data)
```

## Exam Tips for This Domain

1. **Pipeline stages** - Know the order: indexers, encoders, assembler, scaler, algorithm
2. **VectorAssembler** - Required before all Spark ML algorithms
3. **CrossValidator vs TrainValidationSplit** - CV is more robust; TVS is faster
4. **ParamGridBuilder** - Know how to define search grids
5. **Evaluator metrics** - Match the evaluator to the problem type
6. **StringIndexer + OneHotEncoder** - Standard pattern for categorical features

## Documentation Links Summary

| Topic | Link |
|-------|------|
| MLlib Guide | [spark.apache.org/docs/latest/ml-guide.html](https://spark.apache.org/docs/latest/ml-guide.html) |
| Pipeline API | [spark.apache.org/docs/latest/ml-pipeline.html](https://spark.apache.org/docs/latest/ml-pipeline.html) |
| Feature Transformers | [spark.apache.org/docs/latest/ml-features.html](https://spark.apache.org/docs/latest/ml-features.html) |
| Model Tuning | [spark.apache.org/docs/latest/ml-tuning.html](https://spark.apache.org/docs/latest/ml-tuning.html) |
