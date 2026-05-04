---
last-updated: 2026-05-03
---

# AWS Machine Learning Specialty (MLS-C01) - Exam Strategy

> Cert-specific tactics. MLS-C01 is unique among AWS exams in that ~40-50% of questions test ML fundamentals (algorithms, metrics, data prep) independent of AWS, and ~50-60% test the AWS service mapping.

## Format reminder

- 65 scored questions, 180 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response

## Top traps

1. **Metric selection**: accuracy is rarely the answer. F1 / precision / recall / AUC-ROC / AUC-PR depending on imbalance. RMSE / MAE for regression. Confusion matrices show up as questions.

2. **Algorithm-to-problem matching**: memorize built-in algorithms:
   - DeepAR for many time series
   - XGBoost for tabular
   - Linear Learner for high-dim sparse
   - Random Cut Forest for anomaly
   - PCA for dimensionality reduction
   - K-Means for clustering
   - LDA / NTM for topic modeling
   - Factorization Machines for recommendation

3. **SageMaker inference modes**:
   - Real-time = sync, low-latency, always-on
   - Serverless = sync, low-latency, pay-per-use, intermittent
   - Asynchronous = up-to-1-hour, queued
   - Batch transform = offline, bulk
   - MME = many models, shared endpoint, cost optimization

4. **Class imbalance**: SMOTE / oversampling + class weights + F1 / AUC-PR. Accuracy is misleading.

5. **Data leakage**: features that include the target (or post-target info) inflate eval metrics. Common trap: using "future" data to predict the past.

6. **Hyperparameter tuning strategies**: Bayesian (default, sample-efficient), Random (works but more samples), Grid (small spaces), Hyperband (early stopping for larger budgets).

7. **Feature Store**: online (low-latency serving via DynamoDB) vs offline (S3 for training). They sync; use online for inference, offline for training data.

8. **Bias and fairness**: Clarify computes pre-training bias (in data) and post-training bias (in model predictions). SHAP for explainability.

9. **Encryption hierarchy**: SageMaker training data encrypted at rest in S3; in transit via TLS; volume encryption for instances; network isolation via VPC endpoints. Know which KMS key applies where.

10. **Streaming vs batch features**: streaming pipeline = Kinesis + Flink/Lambda + Feature Store online; batch = S3 + Glue + Feature Store offline.

## High-yield topics easy to miss

- Amazon Forecast (purpose-built for time series, alternative to DeepAR)
- Amazon Personalize (recommendation, alternative to Factorization Machines)
- Amazon Comprehend (managed NLP)
- Amazon Rekognition (managed CV)
- Amazon Transcribe / Polly / Translate (managed speech / TTS / translation)
- SageMaker Ground Truth + Ground Truth Plus for labeling
- SageMaker Pipelines (MLOps)
- SageMaker Autopilot (AutoML)
- SageMaker JumpStart (pre-trained models, foundation models)
- SageMaker Edge / Edge Manager (on-device deployment)
- Augmented AI (A2I) for human-in-the-loop review

## Time management

180 / 65 = 2.8 min/question. Pace: Q20 by 50 min, Q40 by 100 min, Q65 by 165 min. Leave 15 min for flagged review. Several questions will look like brain teasers - if a math/algorithm question is taking >3 min, flag and move on.

## When stuck

1. **Read the metric and the data shape** - they often dictate the algorithm.
2. **Pick the AWS-native managed service over BYO model** unless the question specifies BYO.
3. **For inference questions, latency + traffic shape decides the mode** (real-time vs serverless vs async vs batch).
4. **Eliminate non-AWS answers** if a managed AWS service does the job (Personalize beats "build a custom recommender on EC2").

## Day-of logistics

180 min, 65 questions: similar pacing as Pro tier. Bring two IDs. Online proctored: clear the room.

## After

**Pass:** Specialty cert valid 3 years.

**Fail:** ML fundamentals (Domain 3 - Modeling 36%) is the most common failure area. Spend retake prep on algorithm-metric pairing, feature engineering, and bias/variance trade-offs.

## MLS-C01 patterns

- "Imbalanced data" = SMOTE + class_weight + F1/PR-AUC
- "Many related time series" = DeepAR or Forecast
- "Per-prediction feature attribution" = Clarify (SHAP)
- "Streaming feature engineering" = Kinesis + Flink + Feature Store online
- "Hyperparameter tuning small budget" = Bayesian
- "Cheap training" = Managed Spot Training
- "Real-time inference + intermittent traffic" = Serverless inference
- "Many models share traffic" = Multi-Model Endpoint
- "Drift monitoring" = SageMaker Model Monitor
- "Tabular regression/classification" = XGBoost, Linear Learner, AutoPilot
