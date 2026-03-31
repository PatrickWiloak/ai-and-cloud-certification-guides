# Databricks ML Associate - Study Strategy

## Study Approach

### Phase 1: ML Platform Fundamentals (Weeks 1-2)

**Goal:** Master MLflow, Feature Store, and the ML workflow on Databricks.

1. **ML Workloads on Databricks (29%)**
   - Learn MLflow tracking: experiments, runs, parameters, metrics, artifacts
   - Master autologging for sklearn, TensorFlow, PyTorch, and XGBoost
   - Understand Model Registry: versions, aliases, Unity Catalog integration
   - Learn Feature Store: create tables, write features, create training sets
   - Practice AutoML for classification, regression, and forecasting

2. **ML Workflow (29%)**
   - Understand data preparation: train/test splits, stratified sampling, cross-validation
   - Master Hyperopt: fmin, search spaces, SparkTrials, tpe.suggest
   - Learn evaluation metrics and when to use each (precision, recall, F1, RMSE)
   - Understand overfitting vs underfitting diagnosis and solutions

3. **Resources for Phase 1**
   - **[MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)** - Experiment tracking
   - **[Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature management
   - **[Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)** - Distributed tuning
   - **[AutoML](https://docs.databricks.com/en/machine-learning/automl/index.html)** - Automated ML

### Phase 2: Spark ML, DL, and Scaling (Weeks 3-4)

**Goal:** Master the Spark ML Pipeline API, deep learning integration, and scaling patterns.

1. **Spark ML (17%)**
   - Learn Transformers, Estimators, and Pipeline concepts
   - Practice common transformers: VectorAssembler, StringIndexer, OneHotEncoder
   - Master CrossValidator and TrainValidationSplit for model selection
   - Understand evaluators for classification, regression, and clustering

2. **Deep Learning (13%)**
   - Understand GPU runtime and when to use it
   - Learn transfer learning concepts: freeze, fine-tune, task-specific heads
   - Know distributed training options: TorchDistributor, Horovod
   - Practice MLflow integration with DL frameworks

3. **Scaling ML (12%)**
   - Master pandas UDFs for distributed single-node model inference
   - Learn mlflow.pyfunc.spark_udf for batch inference at scale
   - Understand Pandas API on Spark for scalable data exploration
   - Know the tradeoffs between batch, streaming, and real-time inference

4. **Resources for Phase 2**
   - **[Pipeline API](https://spark.apache.org/docs/latest/ml-pipeline.html)** - Spark ML pipelines
   - **[Deep Learning](https://docs.databricks.com/en/machine-learning/deep-learning/index.html)** - DL on Databricks
   - **[Pandas UDFs](https://docs.databricks.com/en/udf/pandas.html)** - Distributed pandas
   - **[Batch Inference](https://docs.databricks.com/en/machine-learning/model-inference/index.html)** - Inference patterns

### Phase 3: Exam Preparation (Week 5)

**Goal:** Review, practice scenarios, and build exam confidence.

1. **Comprehensive Review**
   - Re-read all notes and fact sheet
   - Focus on the two largest domains: ML Workloads (29%) and ML Workflow (29%)
   - Create a summary of key API patterns and code snippets
   - Review MLflow APIs, Hyperopt configuration, and Spark ML stages

2. **Practice and Scenarios**
   - Work through scenarios.md exam-style questions
   - Take practice exams and review incorrect answers
   - Focus on distinguishing similar concepts (precision vs recall, CrossValidator vs TVS)

3. **Resources for Phase 3**
   - **[Exam Page](https://www.databricks.com/learn/certification/machine-learning-associate)** - Official exam details
   - **[Databricks Academy](https://www.databricks.com/learn)** - ML learning paths

## Study Resources

### Official Resources
- **[Databricks Academy](https://www.databricks.com/learn)** - ML learning paths and courses
- **[Databricks Documentation](https://docs.databricks.com/)** - Platform documentation
- **[MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - MLflow reference
- **[Exam Registration](https://www.databricks.com/learn/certification/machine-learning-associate)** - Official exam page

### Key Documentation
- **[ML on Databricks](https://docs.databricks.com/en/machine-learning/index.html)** - ML platform
- **[MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)** - Experiment tracking
- **[Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html)** - Distributed ML
- **[Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Features

## Exam Tactics

### Question Strategy
1. **Identify the Databricks way** - Prefer MLflow, Feature Store, and AutoML over manual approaches
2. **Read all options carefully** - Wrong answers often use valid tools in wrong contexts
3. **Consider scalability** - The correct answer usually leverages distributed computing
4. **Match metrics to problems** - Classification metrics for classification, regression metrics for regression

### Time Management
- **45 questions in 90 minutes** = 2 minutes per question
- **First pass (60 minutes):** Answer confident questions, flag uncertain ones
- **Second pass (20 minutes):** Return to flagged questions
- **Final review (10 minutes):** Check for unanswered questions

### Key Differentiators to Study

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| SparkTrials | Trials | Distributed vs single-node tuning |
| CrossValidator | TrainValidationSplit | K-fold (robust) vs single split (fast) |
| Precision | Recall | Minimize FP vs minimize FN |
| Autologging | Manual logging | Automatic vs explicit API calls |
| Feature Store | Manual joins | Centralized with governance vs ad-hoc |
| pandas UDF | Python UDF | Vectorized (fast) vs row-by-row (slow) |
| Batch inference | Model serving | High throughput vs low latency |
| Transfer learning | Training from scratch | Faster with less data vs full training |

### Common Pitfalls
- **Confusing precision and recall** - Precision minimizes false positives; recall minimizes false negatives
- **Using accuracy for imbalanced data** - F1 or AUC-ROC are better choices
- **Forgetting VectorAssembler** - Required before all Spark ML algorithms
- **Mixing up SparkTrials and Trials** - SparkTrials distributes across cluster
- **Ignoring autologging** - Know which frameworks support it
