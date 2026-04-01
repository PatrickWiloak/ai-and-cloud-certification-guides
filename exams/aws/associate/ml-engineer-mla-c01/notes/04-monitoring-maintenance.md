# ML Solution Monitoring, Maintenance, and Security

**[SageMaker Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html)** - Production monitoring overview

## SageMaker Model Monitor

### Overview
Model Monitor continuously monitors ML models in production for data quality, model quality, bias, and feature attribution drift. It compares current data and predictions against a baseline established from training data.

### Data Quality Monitoring

**[Data Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html)** - Detect data drift

**What It Monitors**:
- Schema changes (new/missing columns, data type changes)
- Statistical distribution changes (mean, std, min, max)
- Missing value percentages
- Feature value ranges

**How It Works**:
1. Create baseline from training data (statistics and constraints)
2. Schedule monitoring job on deployed endpoint
3. Capture inference data using data capture configuration
4. Compare current data against baseline
5. Generate violation report and CloudWatch metrics

**Baseline**:
- Run baseline job on training dataset
- Generates statistics (JSON) and constraints (JSON)
- Statistics: mean, median, std, percentiles, distinct values
- Constraints: data types, completeness, value ranges

### Model Quality Monitoring

**[Model Quality](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html)** - Detect performance degradation

**What It Monitors**:
- Model accuracy metrics (accuracy, precision, recall, F1)
- Regression metrics (RMSE, MAE, R-squared)
- Prediction distribution changes

**Requirements**:
- Ground truth labels (may be delayed)
- Merge predictions with ground truth for evaluation
- Configure ingestion of ground truth labels
- Set thresholds for acceptable performance

### Bias Drift Monitoring

**[Bias Drift](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-model-monitor-bias-drift.html)** - Detect fairness changes

- Monitor for changes in bias metrics over time
- Uses SageMaker Clarify under the hood
- Pre-training bias: data distribution across groups
- Post-training bias: model prediction fairness
- Alert when bias metrics exceed thresholds

### Feature Attribution Drift

- Monitor changes in feature importance over time
- Uses SHAP values for feature attribution
- Detect when model relies on different features than expected
- Indicates concept drift or data distribution changes

### Data Capture

**[Data Capture](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-capture.html)** - Capture endpoint data

- Capture input and output data from endpoints
- Configure sampling percentage (e.g., 100% or sampling)
- Store captured data in S3 for monitoring and analysis
- Support for CSV and JSON capture formats

### Monitoring Schedule
- Run monitoring jobs on schedule (hourly, daily, custom cron)
- Each job compares recent data against baseline
- Generate violation reports in S3
- Emit CloudWatch metrics for alerting

## CloudWatch Integration

### SageMaker CloudWatch Metrics

**[CloudWatch Metrics](https://docs.aws.amazon.com/sagemaker/latest/dg/monitoring-cloudwatch.html)** - SageMaker metrics

**Endpoint Metrics**:
- `Invocations` - number of inference requests
- `InvocationErrors` - number of failed invocations (4xx/5xx)
- `ModelLatency` - time for model to respond
- `OverheadLatency` - SageMaker overhead
- `InvocationsPerInstance` - requests per instance (for auto-scaling)
- `CPUUtilization`, `MemoryUtilization`, `GPUUtilization`

**Training Metrics**:
- `train:loss` - training loss
- Algorithm-specific metrics (accuracy, RMSE, etc.)
- Resource utilization during training

### CloudWatch Alarms
- Set alarms on endpoint metrics (error rate, latency)
- Trigger SNS notifications for operational alerts
- Trigger auto-scaling actions
- Example: alarm if InvocationErrors > 5% for 5 minutes

### CloudWatch Logs
- Training job logs - algorithm output, errors
- Endpoint logs - inference requests, errors
- Processing job logs - data preparation output
- Use Logs Insights for querying and analysis

## A/B Testing

### Production Variants
- Deploy multiple model versions on same endpoint
- Configure traffic distribution percentages
- Compare performance metrics between variants
- Gradually shift traffic to better performing model

**Configuration Example**:
- Variant A (current model): 90% traffic
- Variant B (new model): 10% traffic
- Monitor for 1-2 weeks
- If Variant B performs better, shift to 100%

### Shadow Testing
- Route all traffic to both models
- Only return primary model's response
- Compare predictions offline
- No risk to production users
- More data for comparison than A/B testing

## Retraining Strategies

### Scheduled Retraining
- Retrain on fixed schedule (weekly, monthly)
- Use EventBridge scheduled rules to trigger pipeline
- Include latest data in training dataset
- Compare new model against current before deploying

### Trigger-Based Retraining
- Retrain when drift is detected
- Model Monitor alarm triggers EventBridge rule
- EventBridge triggers SageMaker Pipeline for retraining
- Automated validation and deployment if metrics improve

### Continuous Training
- Pipeline continuously ingests new data
- Incremental training on latest batches
- Faster than full retraining
- Requires careful data management

### Retraining Pipeline Pattern
1. Model Monitor detects drift -> CloudWatch Alarm
2. Alarm triggers EventBridge rule
3. EventBridge starts SageMaker Pipeline
4. Pipeline: data prep -> training -> evaluation -> condition check
5. If new model better -> register in Model Registry
6. Approval (manual or auto) -> deploy with canary strategy

## Drift Detection

### Types of Drift

**Data Drift** (covariate shift):
- Input feature distributions change over time
- Detected by: Model Monitor data quality monitoring
- Example: average transaction amount increases significantly
- Fix: retrain with recent data

**Concept Drift**:
- Relationship between features and target changes
- Detected by: Model Monitor model quality monitoring (needs ground truth)
- Example: customer behavior patterns change post-pandemic
- Fix: retrain with recent labeled data

**Prediction Drift**:
- Model output distribution changes
- Detected by: monitoring prediction distributions
- May indicate data drift or concept drift
- Early warning before ground truth available

### Drift Response Strategy
1. **Detect** - continuous monitoring with Model Monitor
2. **Assess** - determine severity and type of drift
3. **Investigate** - root cause analysis (data pipeline, external factors)
4. **Respond** - retrain, roll back, or adjust thresholds
5. **Prevent** - improve data pipeline monitoring

## Model Maintenance

### Endpoint Updates
- Update model without downtime using deployment guardrails
- Blue/green deployment for safe transitions
- Rollback capability if issues detected
- Monitor CloudWatch metrics during update

### Model Rollback
- Keep previous model version in Model Registry
- Quick rollback by updating endpoint to previous model
- Auto-rollback with deployment guardrails and CloudWatch alarms
- Document rollback procedures

### Cost Optimization for Inference
- Right-size endpoint instances based on utilization
- Use auto-scaling to match demand
- Consider serverless inference for intermittent traffic
- Use Spot instances for batch transform
- Multi-model endpoints for sparse traffic patterns
- SageMaker Savings Plans for committed usage

### Logging and Audit
- CloudTrail for API call auditing
- CloudWatch Logs for operational logs
- Data capture for inference data retention
- Model Cards for model documentation
- SageMaker Lineage for artifact tracking

## Key Takeaways

1. **Model Monitor** - four types: data quality, model quality, bias drift, feature attribution
2. **Data capture** - must be enabled on endpoint to collect monitoring data
3. **Baseline** - created from training data, compared against current data
4. **CloudWatch** - monitor endpoint metrics and set alarms for operational issues
5. **A/B testing** - use production variants for safe model comparison
6. **Drift types** - data drift (features change), concept drift (relationship changes)
7. **Retraining** - trigger-based (on drift detection) is more efficient than scheduled
8. **Deployment guardrails** - canary and linear strategies with auto-rollback
9. **Ground truth** - needed for model quality monitoring (may be delayed)
10. **Cost** - auto-scaling, serverless inference, multi-model endpoints for optimization
