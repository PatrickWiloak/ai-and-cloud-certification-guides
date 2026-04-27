# Databricks Certified Machine Learning Associate

## Exam Overview

The Databricks Certified Machine Learning Associate certification validates foundational knowledge of machine learning on the Databricks Lakehouse Platform. This certification demonstrates proficiency in using MLflow, Spark MLlib, and Databricks tools for building, tracking, and deploying machine learning models.

**Exam Details:**
- **Exam Code:** Databricks Certified Machine Learning Associate
- **Duration:** 90 minutes
- **Number of Questions:** 45 multiple-choice questions
- **Passing Score:** 70% (approximately 32 correct answers)
- **Cost:** $200 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (6+ months ML experience on Databricks recommended)

## Exam Domains

### Domain 1: ML Workloads on Databricks (29%)
- Understand the Databricks ML ecosystem
- Use Databricks tools for ML development
- Manage ML experiments and models
- Use Feature Store and AutoML

**Key Concepts:**
- Databricks ML Runtime and included libraries
- MLflow tracking (experiments, runs, parameters, metrics, artifacts)
- MLflow Model Registry (model stages, transitions, webhooks)
- Databricks Feature Store fundamentals
- AutoML for baseline model creation
- Notebook-based ML development workflows
- Databricks Repos for ML code versioning

### Domain 2: ML Workflow (29%)
- Understand the end-to-end ML lifecycle
- Perform data preparation for ML
- Evaluate and select models
- Handle common ML challenges

**Key Concepts:**
- Data exploration and profiling for ML
- Feature engineering techniques
- Train/test/validation splits
- Cross-validation strategies
- Hyperparameter tuning (grid search, random search, Bayesian)
- Model evaluation metrics (accuracy, precision, recall, F1, AUC-ROC)
- Handling imbalanced datasets
- Bias-variance tradeoff
- Overfitting and underfitting detection
- Model selection criteria

### Domain 3: Spark ML (17%)
- Use Spark MLlib for distributed ML
- Build ML pipelines with Spark
- Understand distributed computing for ML

**Key Concepts:**
- Spark MLlib Pipeline API (Transformers, Estimators, Pipelines)
- Common transformers (VectorAssembler, StringIndexer, OneHotEncoder)
- Common estimators (LogisticRegression, RandomForestClassifier, GBTClassifier)
- Pipeline stages and parameter grids
- CrossValidator and TrainValidationSplit
- Feature transformation at scale
- Distributed model training concepts

### Domain 4: Deep Learning (13%)
- Understand deep learning fundamentals on Databricks
- Use deep learning frameworks (TensorFlow, PyTorch)
- Distribute deep learning training

**Key Concepts:**
- Single-node deep learning on Databricks
- TensorFlow/Keras and PyTorch on Databricks
- GPU cluster configuration
- Transfer learning concepts
- MLflow integration with deep learning frameworks
- TensorBoard integration
- Distributed training basics (Horovod, TorchDistributor)
- Petastorm for data loading

### Domain 5: Scaling ML (12%)
- Scale ML workloads on Databricks
- Optimize ML pipeline performance
- Use distributed computing for ML

**Key Concepts:**
- Pandas API on Spark (formerly Koalas)
- pandas UDFs for distributed inference
- Spark MLlib vs single-node libraries tradeoffs
- Model inference at scale (batch and streaming)
- Hyperparameter tuning at scale (Hyperopt)
- Feature Store for serving
- Delta Lake for ML data management

## Key Concepts to Master

### MLflow
- Tracking API (log_param, log_metric, log_artifact, log_model)
- Experiment organization and comparison
- Model Registry workflow (staging, production, archived)
- Model flavors (sklearn, spark, tensorflow, pytorch)
- Model serving basics
- Autologging capabilities

### Feature Engineering
- Numerical feature scaling (StandardScaler, MinMaxScaler)
- Categorical encoding (StringIndexer, OneHotEncoder)
- Feature selection techniques
- Handling missing values
- Feature importance analysis
- Time-series feature engineering

### Model Evaluation
- Classification metrics (confusion matrix, ROC, precision-recall)
- Regression metrics (RMSE, MAE, R-squared)
- Model comparison techniques
- Visualization of model performance

## Study Approach

### Phase 1: Foundation (Week 1-2)
1. Review ML fundamentals (supervised/unsupervised learning, bias-variance)
2. Get comfortable with Databricks ML Runtime
3. Learn MLflow tracking and experiment management
4. Understand the Feature Store concept

### Phase 2: Core Skills (Week 3-4)
1. Practice building Spark MLlib pipelines
2. Learn hyperparameter tuning with Hyperopt
3. Study deep learning basics on Databricks
4. Practice model evaluation and selection

### Phase 3: Exam Prep (Week 5-6)
1. Take practice exams and review incorrect answers
2. Focus on MLflow and ML workflow (58% of exam)
3. Review scaling and distributed ML concepts
4. Time yourself on practice questions

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - ML learning paths
- **[Exam Guide](https://www.databricks.com/learn/certification/machine-learning-associate)** - Official exam page
- **[MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - MLflow reference
- **[Spark MLlib Guide](https://spark.apache.org/docs/latest/ml-guide.html)** - Spark ML reference
- **[Databricks ML Documentation](https://docs.databricks.com/en/machine-learning/index.html)** - Databricks ML docs

## Tips for Success

1. **MLflow is central** - Domains 1 and 2 cover 58% of the exam
2. **Know the Pipeline API** - Transformers, Estimators, and Pipeline stages
3. **Understand metrics** - Know when to use each evaluation metric
4. **Feature Store basics** - How to create, read, and use feature tables
5. **AutoML awareness** - Know what AutoML does and its limitations
6. **Hyperopt for tuning** - Understand Bayesian optimization basics
7. **Scaling patterns** - Know when to use pandas UDFs vs Spark MLlib
8. **Deep learning scope** - Focus on Databricks integration, not DL theory
9. **Hands-on practice** - Use Databricks Community Edition for experimentation
10. **Read questions carefully** - Some answers are correct but not the best answer

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule with checkboxes |
| [scenarios.md](scenarios.md) | Exam-style scenarios with solutions |
| [strategy.md](strategy.md) | Study phases, resources, and exam tactics |
| [notes/01-ml-workloads.md](notes/01-ml-workloads.md) | Databricks ML ecosystem and MLflow |
| [notes/02-ml-workflow.md](notes/02-ml-workflow.md) | End-to-end ML lifecycle |
| [notes/03-spark-ml.md](notes/03-spark-ml.md) | Spark MLlib pipelines |
| [notes/04-deep-learning.md](notes/04-deep-learning.md) | Deep learning on Databricks |
| [notes/05-scaling-ml.md](notes/05-scaling-ml.md) | Scaling ML workloads |
