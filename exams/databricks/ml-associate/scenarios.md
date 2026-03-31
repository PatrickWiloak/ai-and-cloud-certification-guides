# Databricks ML Associate - Exam-Style Scenarios

## Scenario 1: MLflow Experiment Tracking

### Scenario
A data scientist is training multiple models to compare performance. They want to log hyperparameters, evaluation metrics, and the trained model for each experiment. They also want to easily compare results across runs in the Databricks UI.

**Question:** Which approach should the data scientist use?

**Options:**
A. Save each model to a separate file path and maintain a spreadsheet of results
B. Use MLflow tracking with `mlflow.start_run()` to log parameters, metrics, and models for each run, all within the same experiment
C. Print results to the notebook output and take screenshots for comparison
D. Save all models to the same MLflow run with different artifact names

**Correct Answer:** B

**Explanation:**
- MLflow experiments organize related runs for easy comparison
- Each run captures parameters (inputs), metrics (outputs), and artifacts (models)
- The MLflow UI provides built-in comparison charts and tables
- This is the standard and recommended approach on Databricks

**Why other options are wrong:**
- **A:** Manual file management and spreadsheets are error-prone and not scalable
- **C:** Screenshots are not reproducible and cannot be queried or filtered
- **D:** All models in one run prevents meaningful per-model comparison of metrics

---

## Scenario 2: Hyperparameter Tuning at Scale

### Scenario
A team needs to tune a gradient boosting model with 5 hyperparameters. They have a large dataset and want to efficiently explore the hyperparameter space. The Databricks cluster has 8 worker nodes available.

**Question:** Which tuning approach is most efficient?

**Options:**
A. Grid search using sklearn's GridSearchCV on the driver node
B. Manual tuning by trying different parameter combinations one at a time
C. Hyperopt with `fmin`, `tpe.suggest`, and `SparkTrials(parallelism=8)` to distribute trials across workers
D. Random search using sklearn's RandomizedSearchCV on the driver node

**Correct Answer:** C

**Explanation:**
- Hyperopt uses Bayesian optimization (TPE) which is more efficient than grid or random search
- `SparkTrials` distributes trials across all 8 worker nodes in parallel
- `tpe.suggest` uses results from completed trials to guide future trials toward promising regions
- This maximizes both search efficiency and cluster utilization

**Why other options are wrong:**
- **A:** Grid search is exhaustive and slow; running on the driver node wastes the 8 worker nodes
- **B:** Manual tuning is the least efficient approach and does not scale
- **D:** Random search is better than grid search but does not leverage Bayesian optimization or the cluster

---

## Scenario 3: Choosing an Evaluation Metric

### Scenario
A healthcare company is building a model to predict whether patients have a rare disease. Only 2% of patients in the dataset are positive. The cost of missing a true positive (failing to diagnose) is much higher than the cost of a false positive (unnecessary follow-up test).

**Question:** Which evaluation metric should the team prioritize?

**Options:**
A. Accuracy, because it measures overall correctness
B. Precision, because it minimizes unnecessary follow-up tests
C. Recall, because it minimizes missed diagnoses of the disease
D. R-squared, because it measures how well the model fits the data

**Correct Answer:** C

**Explanation:**
- Recall (sensitivity) measures the proportion of actual positives correctly identified
- High recall means fewer missed diagnoses, which is the primary concern
- With 2% positive rate, a model predicting all negatives would have 98% accuracy but 0% recall
- In medical diagnosis, missing a true positive (low recall) has severe consequences

**Why other options are wrong:**
- **A:** With 2% positive rate, accuracy is misleading - a naive model gets 98% by predicting all negative
- **B:** Precision minimizes false positives, but the scenario states missing true positives is more costly
- **D:** R-squared is a regression metric, not applicable to classification problems

---

## Scenario 4: Spark ML Pipeline

### Scenario
A data engineer needs to build a Spark ML pipeline for a classification task. The dataset has three numeric features and one categorical feature (city names with 50 unique values). The pipeline must handle preprocessing and model training in a single, reproducible workflow.

**Question:** What is the correct sequence of pipeline stages?

**Options:**
A. VectorAssembler -> StringIndexer -> RandomForestClassifier
B. StringIndexer -> OneHotEncoder -> VectorAssembler -> RandomForestClassifier
C. RandomForestClassifier -> VectorAssembler -> StringIndexer
D. VectorAssembler -> RandomForestClassifier -> StringIndexer -> OneHotEncoder

**Correct Answer:** B

**Explanation:**
- StringIndexer first converts city names to numeric indices
- OneHotEncoder converts the indices to binary vectors
- VectorAssembler combines the three numeric features and the one-hot vector into a single feature vector
- RandomForestClassifier trains on the assembled feature vector
- This order ensures all preprocessing happens before the model receives input

**Why other options are wrong:**
- **A:** VectorAssembler cannot process string columns directly - StringIndexer must come first
- **C:** The model cannot be first - it needs preprocessed features as input
- **D:** Preprocessing must happen before the model, not after

---

## Scenario 5: Feature Store Usage

### Scenario
A company has multiple ML models that all use the same customer features (purchase history, browsing patterns, demographics). Each team currently computes these features independently, leading to inconsistencies and duplicated effort. They want to centralize feature computation and ensure consistency.

**Question:** Which approach best addresses this problem?

**Options:**
A. Create a shared notebook that each team copies and runs independently
B. Use Databricks Feature Store to create a centralized feature table with automated lookups for training and inference
C. Store features in a CSV file on shared storage and have each team read from it
D. Schedule a job that emails feature CSVs to each team weekly

**Correct Answer:** B

**Explanation:**
- Feature Store centralizes feature computation in a single location
- All teams use `FeatureLookup` to join features automatically during training and inference
- Features are stored as Delta tables with governance through Unity Catalog
- Consistency is guaranteed because all teams use the same computed features
- Feature lineage tracks how features are used across models

**Why other options are wrong:**
- **A:** Copied notebooks can diverge over time, leading to the same inconsistency problem
- **C:** CSV files lack governance, versioning, and automated joins for training/inference
- **D:** Manual distribution is error-prone and does not scale

---

## Scenario 6: Scaling Inference

### Scenario
A data scientist has trained a scikit-learn model on a small dataset. Now they need to score 100 million records stored in a Delta table using this model. The model prediction takes about 1 millisecond per record on a single CPU.

**Question:** What is the most efficient approach to score all records?

**Options:**
A. Load all 100 million records into pandas on the driver node and call `model.predict()` in a loop
B. Use `mlflow.pyfunc.spark_udf()` to create a Spark UDF from the MLflow model and apply it to the DataFrame in parallel
C. Export the data to CSV, score it on a separate machine, and re-import the results
D. Create a Model Serving endpoint and send each record individually via REST API

**Correct Answer:** B

**Explanation:**
- `mlflow.pyfunc.spark_udf()` creates a Spark UDF that distributes inference across all workers
- The model is broadcast to all executors, and each partition is scored in parallel
- With a Spark cluster, 100 million records can be scored in minutes instead of hours
- Works with any MLflow model flavor including scikit-learn

**Why other options are wrong:**
- **A:** 100 million records will not fit in memory on a single driver node
- **C:** Export/import is slow, manual, and unnecessary when Spark can process the data in place
- **D:** Sending 100 million individual REST API calls would take days and incur enormous cost

---

## Scenario 7: Overfitting Diagnosis

### Scenario
A data scientist trains a random forest model and observes the following metrics:
- Training accuracy: 99.5%
- Validation accuracy: 72.3%
- Test accuracy: 71.8%

**Question:** What is the most likely issue and the best solution?

**Options:**
A. The model is underfitting - increase the number of trees and max depth
B. The model is overfitting - reduce max depth, limit number of features, or increase regularization
C. The model is performing well - deploy it to production
D. The dataset is too small - collect more test data

**Correct Answer:** B

**Explanation:**
- The large gap between training accuracy (99.5%) and validation/test accuracy (72%) is the classic sign of overfitting
- The model has memorized training data patterns that do not generalize to new data
- Solutions: reduce model complexity (lower max_depth), limit max_features, add regularization, or use more training data
- Cross-validation can help confirm that the issue is overfitting and not a bad split

**Why other options are wrong:**
- **A:** Underfitting would show low accuracy on both training AND validation - here training is very high
- **C:** 72% test accuracy with 99.5% training accuracy indicates a serious generalization problem
- **D:** The training set has enough data for 99.5% accuracy; the issue is model complexity, not data volume

---

## Scenario 8: AutoML Baseline

### Scenario
A team has a new classification problem with a dataset of 500,000 rows and 30 features. They want to quickly establish a baseline model before investing time in custom feature engineering and model development.

**Question:** Which approach is best for establishing a quick baseline?

**Options:**
A. Spend two weeks implementing a custom neural network from scratch
B. Use Databricks AutoML to automatically train and compare multiple model types, then review the generated notebooks
C. Manually train a logistic regression model with default parameters
D. Use only Spark MLlib's DecisionTreeClassifier with default settings

**Correct Answer:** B

**Explanation:**
- AutoML automatically tries multiple model types (random forest, XGBoost, logistic regression, etc.)
- It performs automatic feature preprocessing and hyperparameter tuning
- Generated notebooks are editable, allowing the team to learn from and improve upon the baseline
- All results are logged to MLflow for comparison
- This provides a strong baseline in minutes rather than days

**Why other options are wrong:**
- **A:** Two weeks is too long for a baseline; custom neural networks are not appropriate before understanding the problem
- **C:** A single model with default parameters may be a weak baseline; AutoML tries many models
- **D:** A single default model misses the opportunity to compare approaches automatically
