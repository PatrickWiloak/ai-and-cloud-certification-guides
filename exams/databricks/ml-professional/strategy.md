# Databricks ML Professional - Study Strategy

## Study Approach

### Phase 1: Feature Engineering and MLOps (Weeks 1-3)

**Goal:** Master Feature Store, production ML pipelines, and CI/CD patterns.

1. **Feature Engineering (20%)**
   - Learn offline and online Feature Store architecture
   - Master point-in-time lookups to prevent target leakage
   - Understand feature selection methods (SHAP, mutual information, L1)
   - Practice feature freshness monitoring and scheduled computation

2. **MLOps Pipeline (30%)**
   - Design multi-step ML pipelines with Databricks Workflows
   - Understand CI/CD patterns: dev, staging, production promotion
   - Master model aliases (champion, challenger) and webhooks
   - Implement validation gates for automated model promotion
   - Build custom pyfunc models for ensembles and routing
   - Learn A/B testing with traffic splitting

3. **Resources for Phase 1**
   - **[Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature management
   - **[Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** - Deployment
   - **[Model Registry](https://docs.databricks.com/en/mlflow/model-registry.html)** - Model lifecycle
   - **[Custom PyFunc](https://mlflow.org/docs/latest/python_api/mlflow.pyfunc.html)** - Custom models

### Phase 2: Advanced ML and Deployment (Weeks 3-5)

**Goal:** Master distributed training, serving patterns, and monitoring.

1. **Advanced ML (25%)**
   - Understand data parallelism vs model parallelism
   - Learn DeepSpeed ZeRO stages for large model training
   - Master advanced Hyperopt: conditional spaces, early stopping
   - Implement ensemble methods with custom pyfunc models
   - Practice TorchDistributor for distributed PyTorch

2. **Deployment and Serving (15%)**
   - Configure serverless and provisioned throughput endpoints
   - Learn deployment strategies: canary, blue/green, shadow
   - Understand inference tables for request logging
   - Master batch, streaming, and real-time inference patterns

3. **Monitoring (10%)**
   - Distinguish data drift, concept drift, and prediction drift
   - Learn statistical tests: KS test, PSI, chi-squared
   - Configure Lakehouse Monitoring for automated drift detection
   - Design retraining triggers: scheduled, performance-based, drift-based

4. **Resources for Phase 2**
   - **[Distributed Training](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html)** - DL distribution
   - **[Model Serving](https://docs.databricks.com/en/machine-learning/model-serving/index.html)** - Serving endpoints
   - **[Lakehouse Monitoring](https://docs.databricks.com/en/lakehouse-monitoring/index.html)** - Monitoring

### Phase 3: Exam Preparation (Week 6)

**Goal:** Integrate knowledge, practice end-to-end scenarios, and build confidence.

1. **End-to-End System Design**
   - Design complete ML systems from data ingestion to monitoring
   - Practice scenario questions that span multiple domains
   - Review all notes and fact sheet comprehensively
   - Focus on MLOps (30%) and Advanced ML (25%) as the largest domains

2. **Practice and Review**
   - Work through scenarios.md and practice exams
   - Review incorrect answers to understand reasoning
   - Focus on production-readiness patterns
   - Create a summary of key code patterns

3. **Resources for Phase 3**
   - **[Exam Page](https://www.databricks.com/learn/certification/machine-learning-professional)** - Official exam details
   - **[Databricks Academy](https://www.databricks.com/learn)** - Professional ML courses

## Study Resources

### Official Resources
- **[Databricks Academy](https://www.databricks.com/learn)** - Professional-level ML courses
- **[MLflow Documentation](https://mlflow.org/docs/latest/index.html)** - Complete MLflow reference
- **[Exam Registration](https://www.databricks.com/learn/certification/machine-learning-professional)** - Official exam page

## Exam Tactics

### Question Strategy
1. **Think about production systems** - Every answer should consider reliability, scale, and monitoring
2. **Prefer platform-native solutions** - Feature Store, MLflow, Model Serving over custom implementations
3. **Consider the full ML lifecycle** - Training, deployment, monitoring, retraining
4. **Look for safety patterns** - Canary over immediate deployment, validation gates before promotion

### Time Management
- **60 questions in 120 minutes** = 2 minutes per question
- **First pass (80 minutes):** Answer confident questions, flag complex scenarios
- **Second pass (30 minutes):** Return to flagged questions
- **Final review (10 minutes):** Check for unanswered questions

### Key Differentiators to Study

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| Point-in-time lookup | Latest value lookup | Prevents target leakage vs uses current features |
| Data drift | Concept drift | Input distributions change vs feature-target relationship changes |
| Data parallelism | Model parallelism | Replicate model, split data vs split model across GPUs |
| Canary deployment | Blue/green deployment | Gradual traffic shift vs instant switch |
| Serverless serving | Provisioned throughput | Auto-scale (variable latency) vs dedicated (consistent latency) |
| Champion alias | Version number | Semantic (production model) vs specific (version 5) |
| Online Feature Store | Offline Feature Store | Low-latency serving vs batch training |

### Common Pitfalls
- **Ignoring point-in-time correctness** - Causes target leakage with inflated training metrics
- **Skipping validation gates** - Risks deploying degraded models to production
- **Using data parallelism for oversized models** - Need model parallelism or DeepSpeed ZeRO
- **PSI misinterpretation** - Know the thresholds: < 0.1 (ok), 0.1-0.25 (watch), > 0.25 (act)
- **Deploying without monitoring** - Silent model degradation is worse than visible failure
