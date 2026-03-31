# Databricks ML Associate - Study Plan

## 5-Week Study Schedule

### Week 1: ML Workloads on Databricks (Domain 1)

#### Day 1-2: Databricks ML Runtime and MLflow Tracking
- [ ] Understand ML Runtime libraries and GPU options
- [ ] Learn MLflow tracking: log_param, log_metric, log_artifact, log_model
- [ ] Practice MLflow autologging with sklearn and XGBoost
- [ ] Understand experiments, runs, and nested runs
- [ ] Review Notes: `notes/01-ml-workloads.md`
- [ ] Read: [MLflow Tracking](https://docs.databricks.com/en/mlflow/tracking.html)

#### Day 3-4: Model Registry and Feature Store
- [ ] Learn Unity Catalog Model Registry vs workspace registry
- [ ] Practice registering models and managing versions
- [ ] Understand model aliases (champion, challenger)
- [ ] Learn Feature Store: create_table, write_table, create_training_set
- [ ] Read: [Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)
- [ ] Read: [Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)

#### Day 5-6: AutoML
- [ ] Run AutoML for classification, regression, and forecasting
- [ ] Review generated notebooks and model leaderboard
- [ ] Understand AutoML capabilities and limitations
- [ ] Learn when to use AutoML vs custom training
- [ ] Read: [AutoML](https://docs.databricks.com/en/machine-learning/automl/index.html)

#### Day 7: Week 1 Review
- [ ] Review all MLflow APIs and patterns
- [ ] Quiz yourself on Feature Store workflow
- [ ] Practice Model Registry operations

### Week 2: ML Workflow (Domain 2)

#### Day 8-9: Data Preparation and Feature Engineering
- [ ] Practice train/test splits and stratified splitting
- [ ] Learn feature scaling: StandardScaler, MinMaxScaler
- [ ] Practice categorical encoding: one-hot, label encoding
- [ ] Understand missing value strategies
- [ ] Review Notes: `notes/02-ml-workflow.md`

#### Day 10-11: Hyperparameter Tuning with Hyperopt
- [ ] Learn Hyperopt: fmin, search spaces, tpe.suggest
- [ ] Practice SparkTrials for distributed tuning
- [ ] Understand search space functions: hp.choice, hp.uniform, hp.loguniform
- [ ] Integrate Hyperopt with MLflow tracking
- [ ] Read: [Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)

#### Day 12-13: Model Evaluation
- [ ] Master classification metrics: accuracy, precision, recall, F1, AUC-ROC
- [ ] Master regression metrics: RMSE, MAE, R-squared
- [ ] Understand overfitting vs underfitting diagnosis
- [ ] Practice cross-validation techniques
- [ ] Read: [Model Evaluation](https://docs.databricks.com/en/machine-learning/model-evaluation.html)

#### Day 14: Week 2 Review
- [ ] Compare Hyperopt search strategies (grid, random, Bayesian)
- [ ] Review when to use which evaluation metric
- [ ] Practice identifying overfitting from train/test metrics

### Week 3: Spark ML and Deep Learning (Domains 3-4)

#### Day 15-16: Spark MLlib Pipeline API
- [ ] Learn Transformers, Estimators, and Pipelines
- [ ] Practice VectorAssembler, StringIndexer, OneHotEncoder
- [ ] Build complete ML pipelines with preprocessing and training
- [ ] Review Notes: `notes/03-spark-ml.md`
- [ ] Read: [Pipeline API](https://spark.apache.org/docs/latest/ml-pipeline.html)

#### Day 17-18: Model Selection with Spark
- [ ] Practice CrossValidator with ParamGridBuilder
- [ ] Compare CrossValidator vs TrainValidationSplit
- [ ] Learn Spark ML evaluators for different problem types
- [ ] Save and load pipeline models
- [ ] Read: [Model Tuning](https://spark.apache.org/docs/latest/ml-tuning.html)

#### Day 19-20: Deep Learning on Databricks
- [ ] Understand GPU runtime and instance types
- [ ] Learn transfer learning concepts (freeze, fine-tune)
- [ ] Understand distributed training: TorchDistributor, Horovod
- [ ] Practice MLflow integration with TensorFlow and PyTorch
- [ ] Review Notes: `notes/04-deep-learning.md`
- [ ] Read: [Deep Learning](https://docs.databricks.com/en/machine-learning/deep-learning/index.html)

#### Day 21: Week 3 Review
- [ ] Build a complete Spark ML pipeline from scratch
- [ ] Review distributed training approaches
- [ ] Quiz yourself on Pipeline API components

### Week 4: Scaling ML and Integration (Domain 5)

#### Day 22-23: Pandas UDFs and Pandas API on Spark
- [ ] Practice pandas UDF decorator patterns
- [ ] Understand Series-to-Series vs iterator UDFs
- [ ] Use Pandas API on Spark for scalable data exploration
- [ ] Review Notes: `notes/05-scaling-ml.md`
- [ ] Read: [Pandas UDFs](https://docs.databricks.com/en/udf/pandas.html)

#### Day 24-25: Inference Patterns
- [ ] Practice batch inference with mlflow.pyfunc.spark_udf
- [ ] Understand streaming inference with MLflow models
- [ ] Learn Model Serving endpoint concepts
- [ ] Compare batch vs streaming vs real-time inference
- [ ] Read: [Batch Inference](https://docs.databricks.com/en/machine-learning/model-inference/index.html)

#### Day 26-28: Cross-Domain Integration
- [ ] Design end-to-end ML workflows: data prep to inference
- [ ] Combine Feature Store with MLflow tracking
- [ ] Practice full pipeline: features, training, registry, inference
- [ ] Review all notes files for connections between domains

### Week 5: Exam Preparation

#### Day 29-30: Comprehensive Review
- [ ] Re-read all five notes files and fact sheet
- [ ] Focus on highest-weight domains: ML Workloads (29%) and ML Workflow (29%)
- [ ] Create a summary of key API patterns
- [ ] Review key differentiators

#### Day 31-32: Practice Scenarios
- [ ] Work through `scenarios.md` exam-style questions
- [ ] Take available practice exams
- [ ] Review incorrect answers and understand reasoning
- [ ] Focus on weak areas

#### Day 33-35: Final Preparation and Exam
- [ ] Light review of key concepts
- [ ] Review exam tactics and time management strategy
- [ ] Take the exam with confidence

## Study Tips

### Time Allocation by Domain Weight
| Domain | Weight | Suggested Hours |
|--------|--------|----------------|
| ML Workloads on Databricks | 29% | 14-18 hours |
| ML Workflow | 29% | 14-18 hours |
| Spark ML | 17% | 8-10 hours |
| Deep Learning | 13% | 6-8 hours |
| Scaling ML | 12% | 5-7 hours |

### Recommended Daily Schedule
- **30 min** reading documentation or notes
- **30 min** hands-on practice with code examples
- **15 min** reviewing API patterns and key concepts
- **Total: ~1.25 hours/day**
