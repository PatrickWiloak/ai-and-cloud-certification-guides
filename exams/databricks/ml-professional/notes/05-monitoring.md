# Monitoring - Databricks ML Professional

## Overview

This section covers model and data monitoring, representing 10% of the exam. You need to understand drift detection, performance monitoring, Lakehouse Monitoring, and retraining triggers.

**[📖 Lakehouse Monitoring](https://docs.databricks.com/en/lakehouse-monitoring/index.html)** - Data and model monitoring
**[📖 Inference Tables](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html)** - Prediction logging

## Key Topics

### 1. Types of Drift

| Drift Type | What Changes | Example |
|-----------|-------------|---------|
| Data drift | Input feature distributions | Customer demographics shift over time |
| Concept drift | Relationship between features and target | User preferences change due to market trends |
| Prediction drift | Model output distributions | Predictions become more extreme or clustered |
| Label drift | Target variable distribution | Fraud rate increases seasonally |

**Key Concepts:**
- Data drift means the model receives different inputs than it was trained on
- Concept drift means the underlying patterns have changed
- Data drift does not always cause model degradation (features may still be predictive)
- Concept drift usually requires retraining because the learned patterns are outdated

### 2. Statistical Tests for Drift

| Test | What It Measures | Use Case |
|------|-----------------|----------|
| KS test (Kolmogorov-Smirnov) | Distribution difference for continuous features | Numerical feature drift |
| Chi-squared test | Distribution difference for categorical features | Categorical feature drift |
| PSI (Population Stability Index) | Overall distribution shift magnitude | Production monitoring dashboards |
| Jensen-Shannon divergence | Symmetric distribution difference | Comparing probability distributions |

**PSI Interpretation:**
| PSI Value | Interpretation |
|-----------|---------------|
| < 0.1 | No significant drift |
| 0.1 - 0.25 | Moderate drift - investigate |
| > 0.25 | Significant drift - action needed |

### 3. Lakehouse Monitoring

**[📖 Lakehouse Monitoring](https://docs.databricks.com/en/lakehouse-monitoring/index.html)** - Monitoring setup

```python
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()

# Create a monitor on a table
monitor = w.quality_monitors.create(
    table_name="catalog.schema.predictions",
    output_schema_name="catalog.schema",
    time_series={
        "timestamp_col": "prediction_timestamp",
        "granularities": ["1 day"]
    }
)
```

**Key Concepts:**
- Automated profiling of table statistics over time
- Tracks column-level statistics: mean, stddev, null counts, distinct counts
- Time-series analysis shows how distributions change over time
- Custom metrics for domain-specific monitoring
- Drift detection with configurable alerting thresholds
- Profile tables store monitoring results for querying and dashboarding

### 4. Model Performance Monitoring

**Key Concepts:**
- Inference table logging captures all requests and responses
- Ground truth joins: match predictions with actual outcomes when available
- Delayed labels: some outcomes are known hours or days after prediction
- Performance dashboards track accuracy, latency, and throughput over time
- Alert thresholds trigger notifications when performance degrades

**Monitoring Pipeline:**
```
Inference Tables -> Ground Truth Join -> Metric Calculation -> Dashboard -> Alerts
```

### 5. Retraining Triggers

| Trigger Type | Condition | Response |
|-------------|-----------|----------|
| Scheduled | Fixed interval (weekly, monthly) | Retrain on latest data |
| Performance-based | Accuracy drops below threshold | Retrain immediately |
| Drift-based | PSI exceeds threshold | Investigate and retrain |
| Data-based | New labeled data available | Retrain to incorporate new data |

**Key Concepts:**
- Combine scheduled and triggered retraining for robust monitoring
- Validation gates ensure retrained models pass quality checks before deployment
- Track retraining history: which data, model version, and performance metrics
- Automated retraining pipelines as Databricks Workflows

### 6. Feature Importance Monitoring

**Key Concepts:**
- Track feature importance over time to detect shifts in model behavior
- Sudden changes in feature importance may indicate data quality issues
- SHAP values provide interpretable feature contribution scores
- Compare feature importance between training and production data
- Missing or degraded features can cause silent model degradation

### 7. Cost and Operational Monitoring

**Key Concepts:**
- Track serving endpoint compute costs per model
- Monitor request volume and latency percentiles (p50, p95, p99)
- Set up alerts for error rate spikes or latency budget violations
- Optimize endpoint sizing based on actual traffic patterns
- Scale-to-zero for low-traffic endpoints to reduce costs

## Exam Tips for This Domain

1. **Data drift vs concept drift** - Know the difference and how to detect each
2. **PSI thresholds** - < 0.1 (no drift), 0.1-0.25 (investigate), > 0.25 (action needed)
3. **Lakehouse Monitoring** - Automated profiling and drift detection on tables
4. **Inference tables** - Automatic request/response logging from serving endpoints
5. **Retraining triggers** - Scheduled, performance-based, drift-based, data-based
6. **Ground truth joins** - Required for accurate performance monitoring

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Lakehouse Monitoring | [docs.databricks.com/en/lakehouse-monitoring/index.html](https://docs.databricks.com/en/lakehouse-monitoring/index.html) |
| Inference Tables | [docs.databricks.com/en/machine-learning/model-serving/inference-tables.html](https://docs.databricks.com/en/machine-learning/model-serving/inference-tables.html) |
