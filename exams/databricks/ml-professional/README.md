# Databricks Certified Machine Learning Professional

## Exam Overview

The Databricks Certified Machine Learning Professional certification validates advanced machine learning engineering skills on the Databricks Lakehouse Platform. This certification targets experienced ML engineers and data scientists who design, implement, and manage production ML systems including feature stores, ML pipelines, model serving, and monitoring.

**Exam Details:**
- **Exam Code:** Databricks Certified Machine Learning Professional
- **Duration:** 120 minutes
- **Number of Questions:** 60 multiple-choice questions
- **Passing Score:** 70% (approximately 42 correct answers)
- **Cost:** $300 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (ML Associate recommended; 2+ years ML experience recommended)

## Exam Domains

### Domain 1: Feature Engineering (20%)
- Design and implement feature stores
- Create complex feature engineering pipelines
- Manage feature lifecycle and versioning

**Key Concepts:**
- Databricks Feature Store architecture and APIs
- Online vs offline feature stores
- Point-in-time lookups for training data
- Feature computation and scheduling
- Feature tables with Delta Lake
- Feature serving for real-time inference
- Feature freshness and monitoring
- Cross-table feature joins

### Domain 2: MLOps and ML Pipeline (30%)
- Design production ML pipelines
- Implement CI/CD for ML
- Manage model lifecycle at scale
- Orchestrate ML workflows

**Key Concepts:**
- MLflow Model Registry advanced workflows
- Model versioning and stage transitions
- Webhooks for model lifecycle events
- Multi-step ML pipelines with Databricks Workflows
- CI/CD patterns for ML (testing, validation, deployment)
- A/B testing framework design
- Experiment tracking at enterprise scale
- Model packaging and dependencies
- Databricks Asset Bundles for ML deployment
- Reproducibility (environment, data, code versioning)

### Domain 3: Advanced ML (25%)
- Implement advanced ML techniques
- Optimize model performance
- Handle complex ML scenarios

**Key Concepts:**
- Advanced hyperparameter tuning (Hyperopt, Optuna integration)
- Distributed training strategies (Horovod, TorchDistributor, DeepSpeed)
- Transfer learning and fine-tuning
- Ensemble methods and model stacking
- Time-series forecasting at scale
- Graph-based ML approaches
- Custom MLflow models (pyfunc)
- Advanced feature selection and engineering
- Handling data drift in training

### Domain 4: Deployment and Serving (15%)
- Deploy models to production
- Implement real-time and batch serving
- Manage serving infrastructure

**Key Concepts:**
- Model Serving endpoints (serverless and provisioned)
- Real-time inference endpoint configuration
- Batch inference with Spark
- A/B testing and traffic splitting
- Model serving autoscaling
- Endpoint monitoring and logging
- Containerized model deployment
- Edge deployment considerations
- Latency and throughput optimization

### Domain 5: Monitoring (10%)
- Monitor model performance in production
- Detect and handle data and model drift
- Implement alerting for ML systems

**Key Concepts:**
- Data drift detection (statistical tests, distribution comparison)
- Model performance monitoring (accuracy degradation)
- Concept drift vs data drift
- Lakehouse Monitoring for ML tables
- Custom monitoring dashboards
- Alert configuration for model degradation
- Retraining trigger strategies
- Feature importance drift
- Inference table logging and analysis

## Key Concepts to Master

### Production ML Architecture
- End-to-end ML pipeline design
- Feature Store as the central feature management layer
- Model Registry as the model governance layer
- Serving layer for inference (real-time and batch)
- Monitoring layer for drift detection

### MLOps Best Practices
- Version control for code, data, and models
- Automated testing (unit, integration, model validation)
- Continuous training pipelines
- Model governance and approval workflows
- Rollback strategies for failed deployments

### Advanced Techniques
- Distributed hyperparameter tuning at scale
- Multi-GPU training strategies
- Custom MLflow model flavors
- Feature Store point-in-time correctness
- Model explainability (SHAP, LIME)

## Study Approach

### Phase 1: Advanced Foundations (Week 1-3)
1. Master Feature Store APIs and design patterns
2. Deep dive into MLflow Model Registry advanced features
3. Study distributed training frameworks
4. Review advanced hyperparameter tuning

### Phase 2: Production Systems (Week 4-6)
1. Design end-to-end ML pipelines with orchestration
2. Implement model serving and A/B testing
3. Study monitoring and drift detection
4. Practice CI/CD for ML workflows

### Phase 3: Exam Preparation (Week 7-8)
1. Take practice exams under timed conditions
2. Focus on MLOps scenarios (30% of exam)
3. Review complex pipeline design questions
4. Practice explaining deployment tradeoffs

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - ML Professional learning path
- **[Exam Guide](https://www.databricks.com/learn/certification/machine-learning-professional)** - Official exam page
- **[MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - MLflow reference
- **[Feature Store Documentation](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature Store guide
- **[Model Serving Documentation](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Model serving guide

## Tips for Success

1. **MLOps is the largest domain** - 30% of the exam covers ML pipelines and lifecycle
2. **Feature Store mastery** - Understand online/offline stores and point-in-time lookups
3. **Think production-first** - Every answer should consider scalability and reliability
4. **A/B testing knowledge** - Know how to design and evaluate model experiments
5. **Drift detection** - Understand statistical methods for identifying drift
6. **Custom pyfunc models** - Know when and how to create custom MLflow models
7. **Distributed training** - Understand Horovod and TorchDistributor patterns
8. **CI/CD for ML** - Know how to automate model testing and deployment
9. **Scenario-based questions** - Professional questions require deeper reasoning
10. **Time management** - 2 minutes per question; budget extra time for complex scenarios

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule with checkboxes |
| [scenarios.md](scenarios.md) | Exam-style scenarios with solutions |
| [strategy.md](strategy.md) | Study phases, resources, and exam tactics |
| [notes/01-feature-engineering.md](notes/01-feature-engineering.md) | Feature Store and feature engineering |
| [notes/02-mlops-pipelines.md](notes/02-mlops-pipelines.md) | MLOps and ML pipeline design |
| [notes/03-advanced-ml.md](notes/03-advanced-ml.md) | Advanced ML techniques |
| [notes/04-deployment-serving.md](notes/04-deployment-serving.md) | Model deployment and serving |
| [notes/05-monitoring.md](notes/05-monitoring.md) | Model monitoring and drift detection |
