# Feature Engineering - Databricks ML Professional

## Overview

This section covers advanced feature engineering, representing 20% of the exam. You need to master the Feature Store architecture, point-in-time lookups, online feature serving, and advanced feature engineering techniques.

**[📖 Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)** - Feature Store overview
**[📖 Online Feature Store](https://docs.databricks.com/en/machine-learning/feature-store/online-tables.html)** - Real-time serving

## Key Topics

### 1. Feature Store Architecture

**[📖 Feature Engineering Client](https://docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html)** - Feature APIs

**Offline Feature Store:**
- Feature tables are Delta tables with defined primary keys
- Used for batch training and batch inference
- Governed through Unity Catalog
- Supports scheduled feature computation pipelines

**Online Feature Store:**
- Low-latency serving for real-time inference
- Synced from offline tables to online serving infrastructure
- Supports Cosmos DB, DynamoDB, and Databricks Online Tables
- Critical for applications requiring sub-millisecond feature lookups

```python
from databricks.feature_engineering import FeatureEngineeringClient, FeatureLookup

fe = FeatureEngineeringClient()

# Create feature table with timestamp for point-in-time
fe.create_table(
    name="catalog.schema.customer_features",
    primary_keys=["customer_id"],
    timestamp_keys=["feature_timestamp"],
    df=features_df
)
```

### 2. Point-in-Time Lookups

**[📖 Point-in-Time](https://docs.databricks.com/en/machine-learning/feature-store/time-series.html)** - Time-series features

```python
training_set = fe.create_training_set(
    df=labels_df,
    feature_lookups=[
        FeatureLookup(
            table_name="catalog.schema.customer_features",
            lookup_key="customer_id",
            timestamp_lookup_key="event_timestamp"
        )
    ],
    label="target"
)
```

**Key Concepts:**
- Point-in-time lookups prevent target leakage in time-series features
- Features are joined as-of the label timestamp (not the latest available)
- Without point-in-time correctness, future information leaks into training data
- `timestamp_lookup_key` specifies which column in the labels DataFrame to use
- Critical for any feature that changes over time (account balance, activity counts)

### 3. Advanced Feature Engineering Techniques

**Time-Series Features:**
- Rolling window aggregations (7-day average, 30-day sum)
- Lag features (value from N periods ago)
- Seasonal decomposition (day of week, month, holiday flags)
- Exponential moving averages

**Text Features:**
- TF-IDF for document similarity and classification
- Word embeddings (Word2Vec, BERT embeddings)
- Tokenization and n-gram extraction
- Character-level features for short text

**Interaction Features:**
- Polynomial features (x1 * x2, x1^2)
- Cross-product features for categorical combinations
- Ratio features (revenue / orders = avg order value)

### 4. Feature Selection

| Method | How It Works | Pros |
|--------|-------------|------|
| Correlation analysis | Drop highly correlated features | Simple, fast |
| Mutual information | Measure feature-target dependency | Works with non-linear relationships |
| L1 regularization | Shrinks unimportant weights to zero | Automatic during training |
| Permutation importance | Measure accuracy drop when feature is shuffled | Model-agnostic |
| SHAP values | Measure each feature's contribution to prediction | Interpretable |
| Recursive feature elimination | Iteratively remove least important features | Thorough |

### 5. Feature Freshness and Monitoring

**Key Concepts:**
- Feature freshness tracks how stale features are
- Scheduled pipelines update feature tables on a defined cadence
- Monitor for feature drift (distribution changes over time)
- Track feature usage across models for governance
- Version features with Delta Lake for reproducibility

## Exam Tips for This Domain

1. **Point-in-time lookups** - Know why they prevent target leakage
2. **Online vs offline Feature Store** - Understand latency and use case differences
3. **Feature Store workflow** - create_table, write_table, create_training_set
4. **Feature selection methods** - Know when to use each approach
5. **Feature freshness** - Monitoring and scheduled computation pipelines

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Feature Store | [docs.databricks.com/en/machine-learning/feature-store/index.html](https://docs.databricks.com/en/machine-learning/feature-store/index.html) |
| Feature Engineering | [docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html](https://docs.databricks.com/en/machine-learning/feature-store/feature-engineering.html) |
| Online Tables | [docs.databricks.com/en/machine-learning/feature-store/online-tables.html](https://docs.databricks.com/en/machine-learning/feature-store/online-tables.html) |
| Point-in-Time | [docs.databricks.com/en/machine-learning/feature-store/time-series.html](https://docs.databricks.com/en/machine-learning/feature-store/time-series.html) |
