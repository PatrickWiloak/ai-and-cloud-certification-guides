# Databricks Machine Learning Associate - Fact Sheet

## Exam Overview

**Exam Name:** Databricks Certified Machine Learning Associate
**Duration:** 90 minutes
**Questions:** 45 multiple-choice questions
**Passing Score:** 70% (approximately 32 correct)
**Cost:** $200 USD
**Delivery:** Online proctored
**Valid For:** 2 years

**[📖 Official Exam Page](https://www.databricks.com/learn/certification/machine-learning-associate)** - Registration and exam details
**[📖 Databricks Academy](https://www.databricks.com/learn)** - ML learning paths
**[📖 MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - MLflow reference

## Target Audience

This certification is designed for:
- Data scientists building ML models on Databricks
- ML engineers implementing ML workflows
- Data engineers adding ML capabilities to pipelines
- Professionals with 6+ months of ML experience on Databricks
- Python developers transitioning to ML engineering

## Domain 1: ML Workloads on Databricks (29%)

### Databricks ML Runtime

**[📖 ML Runtime](https://docs.databricks.com/en/release-notes/runtime/index.html)** - Runtime versions and libraries
**[📖 ML Runtime Libraries](https://docs.databricks.com/en/machine-learning/index.html)** - Included ML libraries

**Key Facts:**
- ML Runtime includes pre-installed libraries: scikit-learn, TensorFlow, PyTorch, XGBoost
- GPU-enabled ML Runtime for deep learning workloads
- Versions aligned with Databricks Runtime (e.g., 14.3 ML, 15.4 ML)
- Includes MLflow, Hyperopt, and other ML-specific tools
- Notebooks support `%pip install` for additional packages
- Cluster libraries vs notebook-scoped libraries

### MLflow Tracking

**[📖 MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)** - Experiment tracking
**[📖 MLflow APIs](https://mlflow.org/docs/latest/tracking.html)** - Tracking API reference
**[📖 Autologging](https://docs.databricks.com/en/mlflow/databricks-autologging.html)** - Automatic logging

**Key Facts:**
- Experiments organize related runs (training iterations)
- Runs track parameters, metrics, artifacts, and models
- Key APIs:
  - `mlflow.start_run()` - Start a new run
  - `mlflow.log_param("param_name", value)` - Log a parameter
  - `mlflow.log_metric("metric_name", value)` - Log a metric
  - `mlflow.log_artifact("path/to/file")` - Log an artifact
  - `mlflow.log_model(model, "model_name")` - Log a model
- Autologging: `mlflow.autolog()` automatically logs params, metrics, and models
- Autologging supports: sklearn, TensorFlow, PyTorch, XGBoost, LightGBM, Spark
- Experiment comparison UI for comparing runs side-by-side
- Nested runs for hyperparameter tuning hierarchies

### MLflow Model Registry

**[📖 Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Model lifecycle management
**[📖 Unity Catalog Models](https://docs.databricks.com/en/mlflow/models-in-uc.html)** - Models in Unity Catalog

**Key Facts:**
- Model Registry manages model versions and lifecycle stages
- Unity Catalog Model Registry (recommended): `models:/catalog.schema.model_name/version`
- Workspace Model Registry (legacy): `models:/model_name/stage`
- Stage transitions: None -> Staging -> Production -> Archived
- Model versions: each registration creates a new version
- Model descriptions and tags for documentation
- Permissions control who can transition model stages
- `mlflow.register_model()` registers a model from a run

### Feature Store

**[📖 Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature management
**[📖 Feature Engineering](https://docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html)** - Feature engineering client

**Key Facts:**
- Feature Store centralizes feature computation and serving
- Feature tables are Delta tables with a primary key
- `FeatureEngineeringClient` for creating and managing features
- `fe.create_table()` creates a feature table
- `fe.write_table()` writes features to a table
- `fe.create_training_set()` creates a training dataset with point-in-time lookups
- Feature lookup: automatically joins features at training and inference time
- Feature serving for real-time inference

### AutoML

**[📖 AutoML](https://docs.databricks.com/en/machine-learning/automl/index.html)** - Automated model training

**Key Facts:**
- AutoML automatically trains and tunes multiple models
- Supports classification, regression, and forecasting
- Generates editable notebooks for each trial
- Uses Spark MLlib and popular libraries
- Performs automatic feature engineering
- Provides model leaderboard with metrics
- `databricks.automl.classify()`, `databricks.automl.regress()`, `databricks.automl.forecast()`
- Good for establishing baseline models quickly

## Domain 2: ML Workflow (29%)

### Data Preparation

**[📖 Data Exploration](https://docs.databricks.com/en/notebooks/visualizations/index.html)** - Data visualization in notebooks
**[📖 Pandas API on Spark](https://docs.databricks.com/en/pandas/pandas-on-spark.html)** - Scalable pandas

**Key Facts:**
- Train/test split: typically 70-80% train, 20-30% test
- Stratified split for imbalanced datasets
- Cross-validation: k-fold (typically 5 or 10 folds)
- Feature scaling: StandardScaler (z-score), MinMaxScaler (0-1)
- Missing value handling: imputation (mean, median, mode) or dropping
- Categorical encoding: one-hot, label encoding, target encoding
- Feature selection: correlation, mutual information, recursive feature elimination

### Hyperparameter Tuning

**[📖 Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)** - Distributed tuning
**[📖 Hyperopt on Databricks](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/hyperopt-concepts.html)** - Hyperopt concepts

**Key Facts:**
- Grid search: exhaustive search over all parameter combinations
- Random search: random sampling from parameter space (often more efficient)
- Bayesian optimization (Hyperopt): uses past results to guide search
- Hyperopt key components:
  - `fmin()` - minimize an objective function
  - `hp.choice()`, `hp.uniform()`, `hp.loguniform()` - search space definitions
  - `tpe.suggest` - Tree-structured Parzen Estimator algorithm
  - `SparkTrials` - distribute tuning across Spark cluster
  - `Trials` - single-node tuning
- Hyperopt integrates with MLflow for experiment tracking
- `max_evals` controls the number of trials

### Model Evaluation

**[📖 Model Evaluation](https://docs.databricks.com/en/machine-learning/model-evaluation.html)** - Evaluation techniques

**Key Facts:**
- Classification metrics:
  - Accuracy: correct predictions / total predictions
  - Precision: true positives / (true positives + false positives)
  - Recall: true positives / (true positives + false negatives)
  - F1 Score: harmonic mean of precision and recall
  - AUC-ROC: area under receiver operating characteristic curve
  - Log loss: penalizes confident wrong predictions
- Regression metrics:
  - RMSE: root mean squared error (penalizes large errors)
  - MAE: mean absolute error (robust to outliers)
  - R-squared: proportion of variance explained
  - MAPE: mean absolute percentage error
- Confusion matrix: visualizes classification performance
- Overfitting: model performs well on training, poorly on test
- Underfitting: model performs poorly on both training and test
- Bias-variance tradeoff: high bias = underfitting, high variance = overfitting

## Domain 3: Spark ML (17%)

### Spark MLlib Pipeline API

**[📖 MLlib Guide](https://spark.apache.org/docs/latest/ml-guide.html)** - Spark ML reference
**[📖 Pipeline API](https://spark.apache.org/docs/latest/ml-pipeline.html)** - Pipeline components
**[📖 Feature Transformers](https://spark.apache.org/docs/latest/ml-features.html)** - Feature transformation

**Key Facts:**
- Transformer: transforms DataFrames (e.g., VectorAssembler, StringIndexer)
- Estimator: fits on data to produce a Transformer (e.g., LogisticRegression)
- Pipeline: chain of stages (Transformers and Estimators)
- `pipeline.fit(train_df)` returns a PipelineModel
- `pipeline_model.transform(test_df)` makes predictions

**Common Transformers:**
- `VectorAssembler`: combines multiple columns into a feature vector
- `StringIndexer`: converts string labels to numeric indices
- `OneHotEncoder`: converts indices to binary vectors
- `StandardScaler`: standardizes features (zero mean, unit variance)
- `MinMaxScaler`: scales features to [0, 1] range
- `Imputer`: fills missing values with mean/median
- `Bucketizer`: bins continuous features into buckets

**Common Estimators:**
- `LogisticRegression`: binary/multiclass classification
- `RandomForestClassifier`: ensemble classification
- `GBTClassifier`: gradient-boosted tree classification
- `LinearRegression`: linear regression
- `RandomForestRegressor`: ensemble regression
- `KMeans`: unsupervised clustering

### Model Selection

**[📖 CrossValidator](https://spark.apache.org/docs/latest/ml-tuning.html)** - Cross-validation and tuning

**Key Facts:**
- `CrossValidator`: k-fold cross-validation with parameter grid
- `TrainValidationSplit`: single train/validation split (faster)
- `ParamGridBuilder`: defines hyperparameter search space
- `evaluator`: metric to optimize (BinaryClassificationEvaluator, etc.)
- `numFolds`: number of cross-validation folds
- Save and load pipeline models: `model.save(path)`, `PipelineModel.load(path)`

## Domain 4: Deep Learning (13%)

### Deep Learning on Databricks

**[📖 Deep Learning](https://docs.databricks.com/en/machine-learning/deep-learning/index.html)** - DL overview
**[📖 TensorFlow on Databricks](https://docs.databricks.com/en/machine-learning/deep-learning/tensorflow.html)** - TF integration
**[📖 PyTorch on Databricks](https://docs.databricks.com/en/machine-learning/deep-learning/pytorch.html)** - PyTorch integration

**Key Facts:**
- Single-node training: run TF/PyTorch on driver node with GPU
- GPU clusters: select GPU instance types for deep learning
- MLflow integration: log DL models with `mlflow.tensorflow` or `mlflow.pytorch`
- TensorBoard: integrated visualization in Databricks notebooks
- Transfer learning: use pre-trained models (ResNet, BERT) as starting point
- Fine-tuning: unfreeze layers and train on domain-specific data

### Distributed Deep Learning

**[📖 Distributed Training](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html)** - Distributed DL options
**[📖 TorchDistributor](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html)** - PyTorch distribution

**Key Facts:**
- Horovod: distributed training framework (data parallelism)
- TorchDistributor: native PyTorch distributed training on Spark
- Data parallelism: replicate model, split data across workers
- `HorovodRunner`: Databricks integration for Horovod
- Petastorm: read Parquet data directly into DL frameworks
- Single-node multi-GPU: use for models that fit in one node
- Distributed training: for large models or datasets

## Domain 5: Scaling ML (12%)

### Scaling Techniques

**[📖 Pandas API on Spark](https://docs.databricks.com/en/pandas/pandas-on-spark.html)** - Scalable pandas operations
**[📖 Pandas UDFs](https://docs.databricks.com/en/udf/pandas.html)** - Distributed pandas functions
**[📖 Batch Inference](https://docs.databricks.com/en/machine-learning/model-inference/index.html)** - Scalable inference

**Key Facts:**
- Pandas API on Spark: pandas syntax with Spark execution (scalable)
- pandas UDFs: apply pandas functions distributed across partitions
- `@pandas_udf("return_type")` decorator for UDF definition
- Use pandas UDFs for model inference at scale
- Spark MLlib: native distributed ML (scales automatically)
- Single-node libraries (sklearn, XGBoost): use for smaller datasets
- Hyperopt with `SparkTrials`: distribute hyperparameter tuning
- Feature Store for centralized feature management at scale
- Delta Lake for versioned ML datasets

### Inference Patterns

**Key Facts:**
- Batch inference: apply model to large datasets using Spark
- `mlflow.pyfunc.spark_udf()` creates a Spark UDF from MLflow model
- Streaming inference: apply model to streaming data
- Real-time inference: Model Serving endpoints
- pandas UDFs for custom inference logic
- Broadcast model for efficient distributed inference

## Exam Tips

1. **MLflow is the backbone** - tracking, registry, and serving appear throughout
2. **Know the Pipeline API** - Transformers, Estimators, Pipeline stages
3. **Hyperopt specifics** - `fmin`, search spaces, `SparkTrials` vs `Trials`
4. **Feature Store workflow** - create, write, training set, inference
5. **Evaluation metrics** - when to use each metric (precision vs recall vs F1)
6. **AutoML** - know capabilities and limitations
7. **pandas UDFs** - key pattern for scaling single-node code
8. **Cross-validation** - CrossValidator vs TrainValidationSplit
9. **Deep learning** - focus on Databricks integration, not DL theory
10. **Autologging** - which frameworks support it and what gets logged

## Quick Reference

### Essential Code Patterns
```python
# MLflow Tracking
with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_metric("accuracy", 0.95)
    mlflow.sklearn.log_model(model, "model")

# Hyperopt
from hyperopt import fmin, tpe, hp, SparkTrials
best = fmin(fn=objective, space=search_space, algo=tpe.suggest,
            max_evals=100, trials=SparkTrials(parallelism=4))

# Spark MLlib Pipeline
from pyspark.ml import Pipeline
from pyspark.ml.feature import VectorAssembler, StringIndexer
from pyspark.ml.classification import RandomForestClassifier
pipeline = Pipeline(stages=[indexer, assembler, rf])
model = pipeline.fit(train_df)
predictions = model.transform(test_df)

# Feature Store
from databricks.feature_engineering import FeatureEngineeringClient
fe = FeatureEngineeringClient()
fe.create_table(name="catalog.schema.features", primary_keys=["id"], df=features_df)

# Batch Inference with MLflow
predict_udf = mlflow.pyfunc.spark_udf(spark, model_uri="models:/my_model/1")
predictions = df.withColumn("prediction", predict_udf(struct("feature1", "feature2")))
```
