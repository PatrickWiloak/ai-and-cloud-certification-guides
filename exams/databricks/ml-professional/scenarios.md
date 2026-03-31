# Databricks ML Professional - Exam-Style Scenarios

## Scenario 1: Feature Store Point-in-Time Correctness

### Scenario
A team builds a churn prediction model using customer features like "30-day purchase count." During training, they join the feature table with labels using the customer's latest features. The model achieves 95% accuracy in training but only 60% in production.

**Question:** What is the most likely cause and solution?

**Options:**
A. The model is overfitting - reduce model complexity
B. Target leakage from using future feature values during training - implement point-in-time lookups with `timestamp_lookup_key`
C. The training data is too small - collect more data
D. The features need more engineering - add more derived features

**Correct Answer:** B

**Explanation:**
- Using the latest features during training means the model sees feature values computed after the label was determined
- For example, a customer's "30-day purchase count" at prediction time may include purchases made after the churn event
- Point-in-time lookups ensure features are joined as-of the label timestamp, preventing future data from leaking in
- This explains the large gap between training accuracy (with leaked info) and production accuracy (without it)

**Why other options are wrong:**
- **A:** Overfitting shows high train/low validation accuracy, but this issue is specific to temporal data leakage
- **C:** More data would not fix the leakage problem
- **D:** More features could worsen the problem if they also leak future information

---

## Scenario 2: CI/CD Model Promotion

### Scenario
A team needs to promote an ML model from staging to production. They want automated validation to ensure the new model meets quality standards before serving real traffic.

**Question:** Which approach best implements a safe model promotion pipeline?

**Options:**
A. Manually test the model in a notebook and update the serving endpoint
B. Implement an automated pipeline that runs validation tests (accuracy threshold, latency check, schema validation), compares against the current champion, and only promotes if all gates pass
C. Deploy directly to production and monitor for issues
D. Run A/B testing on 100% of traffic immediately

**Correct Answer:** B

**Explanation:**
- Automated validation gates ensure consistent quality standards
- Accuracy threshold prevents deploying models that perform worse than the current champion
- Latency checks ensure the model meets SLA requirements
- Schema validation confirms the model accepts the expected inputs
- Comparing against the champion prevents regression

**Why other options are wrong:**
- **A:** Manual testing is error-prone, not reproducible, and does not scale
- **C:** Deploying without validation risks serving bad predictions to users
- **D:** A/B testing on 100% traffic is not A/B testing - it replaces the old model entirely

---

## Scenario 3: Custom PyFunc Model

### Scenario
A team has two models: a fast lightweight model and a slower accurate model. They want to create a routing system where simple requests use the fast model and complex requests use the accurate model, deployed as a single serving endpoint.

**Question:** How should they implement this?

**Options:**
A. Deploy two separate serving endpoints and handle routing in the application layer
B. Create a custom pyfunc model that implements routing logic in the `predict()` method, choosing between the two models based on input complexity
C. Use A/B testing to randomly split traffic between the two models
D. Retrain both models into a single combined model

**Correct Answer:** B

**Explanation:**
- A custom pyfunc model can load both models in `load_context()` and implement routing logic in `predict()`
- The routing logic can assess input complexity and direct requests to the appropriate model
- Deployed as a single endpoint, simplifying the serving infrastructure
- Both models are packaged as artifacts in the MLflow model

**Why other options are wrong:**
- **A:** Two endpoints add complexity and require the application to implement routing
- **C:** Random splitting ignores input complexity and does not optimize for the right model per request
- **D:** Combining models into one loses the specialized strengths of each model

---

## Scenario 4: Drift Detection and Response

### Scenario
A fraud detection model has been in production for 6 months. The monitoring dashboard shows that the PSI for several key features has risen above 0.3. The model's precision has dropped from 0.92 to 0.78 over the last month.

**Question:** What should the team do?

**Options:**
A. Ignore the drift since the model is still performing above 50%
B. Investigate the drifted features, retrain the model on recent data including the drift period, validate against the current champion, and deploy if the retrained model is better
C. Immediately roll back to the first version of the model
D. Add more features to compensate for the drifted ones

**Correct Answer:** B

**Explanation:**
- PSI > 0.25 indicates significant data drift requiring action
- Precision dropping from 0.92 to 0.78 confirms the drift is causing performance degradation
- Retraining on recent data allows the model to learn the new patterns
- Validation against the champion ensures the retrained model is actually better
- Only deploy after passing quality gates

**Why other options are wrong:**
- **A:** PSI > 0.3 with measurable performance degradation requires immediate attention
- **C:** The first model version was trained on even older data and would likely perform worse
- **D:** Adding features without retraining does not address the fundamental distribution change

---

## Scenario 5: Distributed Training Selection

### Scenario
A team needs to fine-tune a large language model (15 billion parameters) on domain-specific data. The model does not fit on a single GPU (80 GB VRAM). They have a cluster with 8 GPU nodes, each with 80 GB VRAM.

**Question:** Which training approach should they use?

**Options:**
A. Single-node training on the driver node with the largest available GPU
B. Data parallelism with TorchDistributor, replicating the full model to each GPU
C. DeepSpeed with ZeRO Stage 3 to partition model parameters, gradients, and optimizer states across all GPUs
D. Horovod with standard data parallelism

**Correct Answer:** C

**Explanation:**
- The model (15B params) does not fit on a single GPU (80 GB)
- Standard data parallelism requires each GPU to hold a full copy of the model, which is not possible here
- DeepSpeed ZeRO Stage 3 partitions model parameters across GPUs, so each GPU only holds a fraction
- With 8 GPUs, each holds approximately 1/8 of the model parameters
- This enables training models that are much larger than single-GPU memory

**Why other options are wrong:**
- **A:** The model does not fit on a single GPU - this would fail with out-of-memory errors
- **B:** Data parallelism replicates the full model to each GPU - the model is too large for this
- **D:** Standard Horovod also uses data parallelism with full model replication

---

## Scenario 6: A/B Testing Strategy

### Scenario
A team has trained a new recommendation model that shows 5% improvement in offline metrics. Before fully replacing the production model, they want to validate the improvement with real users while minimizing risk.

**Question:** What is the recommended deployment approach?

**Options:**
A. Replace the production model immediately and monitor for one week
B. Deploy the new model as a shadow - run it in parallel without serving results, compare outputs, then gradually roll out via canary deployment (5% -> 25% -> 50% -> 100%)
C. Run an A/B test with 50/50 traffic split for one day
D. Deploy to a staging endpoint and test with synthetic data

**Correct Answer:** B

**Explanation:**
- Shadow deployment validates the model with real traffic without risk to users
- Canary deployment gradually increases traffic to catch issues early
- Progressive rollout (5% -> 25% -> 50% -> 100%) limits blast radius if problems arise
- Each stage includes monitoring for performance regressions
- This combines safety with real-world validation

**Why other options are wrong:**
- **A:** Immediate replacement risks all users if the model underperforms in production
- **C:** 50/50 split for one day may not have enough data for statistical significance and exposes half the users to risk
- **D:** Synthetic data does not capture real-world traffic patterns and user behavior

---

## Scenario 7: Model Serving Architecture

### Scenario
An e-commerce company needs model predictions in three contexts:
1. Real-time product recommendations when a user visits a page (< 100ms latency)
2. Nightly batch scoring of 50 million customers for email campaigns
3. Near-real-time fraud detection on transaction streams

**Question:** Which combination of serving patterns should they use?

**Options:**
A. Model Serving endpoint for all three use cases
B. Real-time: Model Serving endpoint; Batch: mlflow.pyfunc.spark_udf; Streaming: spark_udf on streaming DataFrame
C. Batch inference for all three, running hourly
D. Build a custom REST API for all three use cases

**Correct Answer:** B

**Explanation:**
- Real-time recommendations need < 100ms latency - Model Serving endpoint provides this
- Batch scoring of 50M customers needs high throughput - Spark UDF distributes inference across the cluster
- Streaming fraud detection needs near-real-time - Spark UDF applied to a streaming DataFrame processes continuously
- Each pattern is optimized for its specific latency and throughput requirements

**Why other options are wrong:**
- **A:** Model Serving endpoint for 50M batch records would be slow and expensive (per-request cost)
- **C:** Hourly batch is too slow for real-time recommendations and fraud detection
- **D:** Custom REST API requires building and maintaining infrastructure that Databricks already provides
