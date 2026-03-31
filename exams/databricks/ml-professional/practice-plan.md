# Databricks ML Professional - Study Plan

## 6-Week Study Schedule

### Week 1: Feature Engineering (Domain 1)

#### Day 1-2: Feature Store Architecture
- [ ] Understand offline vs online Feature Store
- [ ] Learn Feature Engineering Client APIs
- [ ] Practice create_table, write_table, create_training_set workflow
- [ ] Review Notes: `notes/01-feature-engineering.md`
- [ ] Read: [Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)

#### Day 3-4: Point-in-Time Lookups
- [ ] Understand why point-in-time prevents target leakage
- [ ] Practice timestamp_lookup_key configuration
- [ ] Design time-series feature pipelines
- [ ] Read: [Point-in-Time](https://docs.databricks.com/en/machine-learning/feature-store/time-series.html)

#### Day 5-7: Advanced Feature Engineering
- [ ] Practice time-series features: rolling windows, lag features
- [ ] Understand feature selection methods (SHAP, mutual information, L1)
- [ ] Learn feature freshness monitoring
- [ ] Review feature versioning with Delta Lake

### Week 2: MLOps Pipeline (Domain 2 - Part 1)

#### Day 8-9: Production ML Pipeline Design
- [ ] Design multi-step training pipelines with Databricks Workflows
- [ ] Understand idempotent pipeline design
- [ ] Learn Databricks Asset Bundles for deployment
- [ ] Review Notes: `notes/02-mlops-pipeline.md`
- [ ] Read: [Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)

#### Day 10-11: CI/CD for ML
- [ ] Understand dev/staging/production promotion patterns
- [ ] Learn automated testing for ML pipelines
- [ ] Practice model validation gates
- [ ] Read: [Workflows](https://docs.databricks.com/en/workflows/index.html)

#### Day 12-14: Model Lifecycle Management
- [ ] Master model aliases (champion, challenger)
- [ ] Understand webhooks for model event automation
- [ ] Practice model lineage and reproducibility
- [ ] Learn model packaging: signatures, environments, requirements
- [ ] Read: [Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)

### Week 3: MLOps and Advanced ML (Domains 2-3)

#### Day 15-16: A/B Testing and Custom Models
- [ ] Understand traffic splitting for model comparison
- [ ] Learn champion/challenger deployment patterns
- [ ] Implement custom pyfunc models for ensembles
- [ ] Practice load_context and predict methods
- [ ] Read: [Custom PyFunc](https://mlflow.org/docs/latest/python_api/mlflow.pyfunc.html)

#### Day 17-18: Advanced Hyperparameter Tuning
- [ ] Practice conditional search spaces with Hyperopt
- [ ] Learn early stopping and warm-starting
- [ ] Understand parallelism tradeoffs in SparkTrials
- [ ] Review Notes: `notes/03-advanced-ml.md`
- [ ] Read: [Hyperopt](https://docs.databricks.com/en/machine-learning/automl-hyperparam-tuning/index.html)

#### Day 19-21: Distributed Training
- [ ] Understand data parallelism vs model parallelism
- [ ] Learn TorchDistributor for PyTorch distribution
- [ ] Study DeepSpeed ZeRO stages for memory efficiency
- [ ] Practice mixed precision training concepts
- [ ] Read: [Distributed Training](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html)

### Week 4: Deployment and Monitoring (Domains 4-5)

#### Day 22-23: Model Serving Endpoints
- [ ] Configure serverless and provisioned throughput endpoints
- [ ] Practice REST API queries to serving endpoints
- [ ] Understand auto-scaling and scale-to-zero
- [ ] Review Notes: `notes/04-deployment-serving.md`
- [ ] Read: [Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)

#### Day 24-25: Deployment Strategies
- [ ] Understand canary, blue/green, and shadow deployments
- [ ] Learn inference table logging and configuration
- [ ] Practice batch inference with mlflow.pyfunc.spark_udf
- [ ] Read: [Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)

#### Day 26-28: Monitoring and Drift Detection
- [ ] Understand data drift vs concept drift vs prediction drift
- [ ] Learn statistical tests: KS test, PSI, chi-squared
- [ ] Practice Lakehouse Monitoring setup
- [ ] Design retraining triggers and automated pipelines
- [ ] Review Notes: `notes/05-monitoring.md`
- [ ] Read: [Lakehouse Monitoring](https://docs.databricks.com/en/lakehouse-monitoring/index.html)

### Week 5: Integration and Scenario Practice

#### Day 29-31: End-to-End ML System Design
- [ ] Design complete ML systems: features to monitoring
- [ ] Combine Feature Store, MLflow, serving, and monitoring
- [ ] Practice cross-domain scenario questions
- [ ] Review all notes for integration points

#### Day 32-35: Practice Scenarios
- [ ] Work through `scenarios.md` exam-style questions
- [ ] Take available practice exams under timed conditions
- [ ] Review incorrect answers and understand reasoning
- [ ] Identify and focus on weak areas

### Week 6: Final Preparation

#### Day 36-38: Comprehensive Review
- [ ] Re-read all notes and fact sheet
- [ ] Focus on MLOps (30%) and Advanced ML (25%) - the largest domains
- [ ] Create summary of key API patterns and code snippets
- [ ] Review deployment and monitoring concepts

#### Day 39-42: Final Review and Exam
- [ ] Light review of key differentiators
- [ ] Review common pitfalls and exam tactics
- [ ] Take the exam with confidence

## Study Tips

### Time Allocation by Domain Weight
| Domain | Weight | Suggested Hours |
|--------|--------|----------------|
| MLOps and ML Pipeline | 30% | 18-22 hours |
| Advanced ML | 25% | 15-18 hours |
| Feature Engineering | 20% | 12-15 hours |
| Deployment and Serving | 15% | 8-10 hours |
| Monitoring | 10% | 5-7 hours |

### Recommended Daily Schedule
- **45 min** reading documentation and notes
- **45 min** hands-on practice with advanced patterns
- **15 min** reviewing concepts and code patterns
- **Total: ~1.75 hours/day**
