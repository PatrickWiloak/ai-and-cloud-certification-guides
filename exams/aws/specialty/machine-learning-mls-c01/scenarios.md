---
last-updated: 2026-05-03
---

# AWS Machine Learning Specialty (MLS-C01) - Exam Scenarios

> Eight worked scenarios mirroring MLS-C01 question style. Illustrative, not real exam questions. MLS-C01 tests both ML fundamentals (algorithms, metrics, statistics) and the AWS service mapping (SageMaker, Glue, Kinesis). Questions often have plausible non-AWS answers; pick the AWS-native pattern unless the question specifically allows third-party.

---

## Scenario 1 - Class imbalance (Domain 3: 36% Modeling)

A fraud detection dataset is 99.5% non-fraud / 0.5% fraud. A model trained on it gets 99.5% accuracy and detects almost no fraud.

Which actions improve recall on the fraud class?

A. Apply SMOTE oversampling on the minority class; use class_weight balanced; switch primary metric to F1 or recall on fraud class.
B. Train on more data without rebalancing; accuracy will improve.
C. Use accuracy as the metric and tune hyperparameters.
D. Drop minority-class samples to reduce imbalance.

**Analysis**

A is right: the textbook combination for severe imbalance. SMOTE / SMOTE-NC creates synthetic minority samples; class weights penalize the loss for missed minority predictions; F1 / recall / PR-AUC are the appropriate metrics (accuracy is misleading when classes are imbalanced). B doesn't fix the imbalance. C optimizes the wrong thing. D throws away signal.

**Answer:** A

**Key takeaway:** Imbalanced data → resample (SMOTE / oversample / undersample) + class weights + use F1/recall/AUC-PR as the metric. Accuracy is the wrong metric for imbalanced problems.

---

## Scenario 2 - SageMaker training cost optimization (Domain 4: 20%)

A team trains XGBoost on a 200 GB dataset weekly. Training takes 6 hours on ml.m5.4xlarge. They want lower training time and cost.

Which fits?

A. Use SageMaker Distributed Training with Pipe input mode and FastFile mode; switch to a multi-instance ml.m5.4xlarge cluster.
B. Switch to ml.r5.4xlarge for more memory.
C. Run on Lambda for cheaper compute.
D. Use SageMaker Managed Spot Training with Pipe input mode and increase ml.m5 cluster size.

**Analysis**

D is right: Managed Spot Training cuts training cost up to 90%; Pipe / FastFile streams from S3 instead of downloading the entire dataset to instance storage; cluster scaling reduces wall time. A is partially right but misses spot. B doesn't address the cost or time goal. C - Lambda has 15-min limits and isn't an ML training platform.

**Answer:** D

**Key takeaway:** Cheap training = Managed Spot. Fast I/O = Pipe / FastFile / S3 input. Scale = distributed across multiple instances. Combine all three.

---

## Scenario 3 - Real-time inference at scale (Domain 4: 20%)

An app makes 10,000 inference requests per second to a model. Latency must be <50ms p99. Cost matters.

Which architecture fits?

A. SageMaker real-time endpoint with autoscaling; Multi-Model Endpoint if multiple models share traffic.
B. SageMaker Batch Transform jobs every minute.
C. Lambda invoking SageMaker per request.
D. SageMaker Asynchronous Inference for queueing.

**Analysis**

A is right: SageMaker real-time endpoints + autoscaling are designed for low-latency synchronous inference. MME is the cost optimization when traffic is spread across many models. B is for offline batch (hours, not ms). C adds Lambda hop overhead and cost. D queues requests; designed for jobs that take seconds-to-minutes, not <50ms.

**Answer:** A

**Key takeaway:** SageMaker inference modes:
- Real-time endpoint = sync, low-latency
- MME = many models, shared endpoint
- Serverless inference = sync, low-latency, intermittent traffic, pay-per-use
- Asynchronous = up-to-1-hour timeouts, queued
- Batch transform = bulk offline scoring

---

## Scenario 4 - Hyperparameter tuning (Domain 3: 36%)

A team needs to tune 8 hyperparameters with continuous and discrete values; budget is 200 training runs.

Which fits?

A. SageMaker Automatic Model Tuning with Bayesian optimization strategy.
B. SageMaker Automatic Model Tuning with Random Search.
C. Manual grid search across all 8 dimensions.
D. SageMaker Autopilot for fully automated tuning.

**Analysis**

A is right when the budget is small (200 runs is small for 8 dims): Bayesian uses prior runs to guide the next, much more efficient than random. B (random) works but needs more runs. C is computationally infeasible at 8 dims. D is for "AutoML on a labeled dataset" and selects the model and tunes - bigger scope than the question asks.

**Answer:** A

**Key takeaway:** Hyperparameter Tuning strategies in SageMaker AMT: Bayesian (default, sample-efficient), Random, Grid (small spaces), Hyperband (early stopping, larger budgets). Bayesian is the default winning answer for moderate budgets.

---

## Scenario 5 - Data drift monitoring (Domain 4: 20%)

A team deployed a model to a SageMaker endpoint. They want to detect drift in input feature distribution and trigger retraining if drift exceeds a threshold.

Which fits?

A. SageMaker Model Monitor with a Data Quality monitoring job; baseline from training data; CloudWatch alarm on drift metric → EventBridge → retraining pipeline.
B. CloudWatch custom metrics emitted by the inference container; Lambda compares to baseline.
C. Run Glue ETL daily over endpoint logs to compute drift; manual review.
D. SageMaker Clarify for bias detection.

**Analysis**

A is right: Model Monitor has Data Quality, Model Quality, Bias Drift, and Feature Attribution Drift monitor types. Data Quality is the right one for input distribution. Baseline + scheduled monitoring + CloudWatch alarms is the AWS-native pattern. B is custom and re-implements Model Monitor. C is manual. D is for fairness / bias, not general drift.

**Answer:** A

**Key takeaway:** SageMaker Model Monitor has four monitor types: Data Quality (inputs), Model Quality (predictions vs labels), Bias Drift, Feature Attribution Drift. Pick by what you're tracking.

---

## Scenario 6 - Streaming feature engineering (Domain 1: 20% Data Engineering)

A model needs features computed from clickstream data with sub-second latency. Raw events arrive at 50K/s in Kinesis Data Streams.

Which architecture fits?

A. Kinesis Data Streams → Managed Service for Apache Flink → SageMaker Feature Store online store; model reads features at inference time.
B. Kinesis → S3 → Glue daily batch → Feature Store offline store.
C. Kinesis → Lambda → DynamoDB; SageMaker reads DynamoDB.
D. Kinesis → Kinesis Data Analytics SQL → Redshift.

**Analysis**

A is right: Flink for streaming feature engineering, Feature Store online store for low-latency serving (sub-10ms reads from DynamoDB-backed online store), and the offline store (S3-backed) sync for training. B is batch, not streaming. C reinvents Feature Store. D is analytics, not feature serving.

**Answer:** A

**Key takeaway:** SageMaker Feature Store = online store (low-latency serving) + offline store (training data). Stream into online via Flink/Lambda; batch into offline via Glue or pipelines.

---

## Scenario 7 - Model interpretability (Domain 3: 36%)

A model used in lending must produce per-prediction feature attribution (which features pushed the decision toward "deny") for regulatory compliance.

Which fits?

A. SageMaker Clarify with SHAP-based feature attribution; integrate explanation into the inference response.
B. Train a simpler model (logistic regression) and read coefficients.
C. Use SageMaker Autopilot's leaderboard to pick the model.
D. Run permutation feature importance offline.

**Analysis**

A is right: Clarify uses SHAP (Shapley) values for per-prediction attribution and is the AWS-native answer. B is one approach (interpretable-by-design) but the question said "produce per-prediction attribution" which Clarify does without sacrificing model choice. C doesn't address the question. D gives global, not per-prediction, importance.

**Answer:** A

**Key takeaway:** SageMaker Clarify = bias detection + explainability via SHAP. Per-prediction attribution is its core feature for regulated workloads.

---

## Scenario 8 - Algorithm selection for time series (Domain 3: 36%)

A retailer needs hourly demand forecasts per SKU for 50,000 SKUs, 4 weeks ahead, with cold-start support for new SKUs.

Which fits?

A. SageMaker DeepAR for global model across all SKUs.
B. Linear Regression per SKU.
C. Train one ARIMA per SKU.
D. Random Forest with lag features per SKU.

**Analysis**

A is right: DeepAR is purpose-built for many related time series; learns one global RNN that handles all SKUs and supports cold-start (new SKU with limited history) by leveraging cross-SKU patterns. B doesn't model temporal structure. C scales poorly (50K models, no cross-series learning). D works for tabular but doesn't naturally support cold-start across series.

**Answer:** A

**Key takeaway:** Built-in SageMaker algorithms by problem type:
- Forecasting many related series → DeepAR (or Forecast service)
- Tabular regression/classification → XGBoost, Linear Learner
- Recommendation → Factorization Machines
- Topic modeling → LDA, NTM
- Object detection → SSD, YOLO via algorithms or BYO
- Anomaly detection → Random Cut Forest
