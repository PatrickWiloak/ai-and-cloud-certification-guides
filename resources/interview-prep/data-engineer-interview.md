# Data Engineer Interview Preparation Guide

## Overview

Data Engineer interviews focus on data pipeline design, data modeling, SQL proficiency, data quality, and system design for data-intensive applications. This guide covers common questions and scenarios across batch and streaming architectures.

---

## Data Pipeline Design

### Batch vs Streaming Processing

| Factor | Batch | Streaming |
|--------|-------|-----------|
| Latency | Minutes to hours | Milliseconds to seconds |
| Complexity | Lower | Higher |
| Cost | Lower (run periodically) | Higher (always running) |
| Data completeness | Complete dataset available | Dealing with late and out-of-order data |
| Use cases | Reports, ETL, ML training | Real-time dashboards, fraud detection, alerting |
| Tools | Spark, Hive, Airflow | Kafka, Flink, Spark Streaming, Kinesis |

### Design a Batch ETL Pipeline

**Requirements**: ingest data from multiple sources daily, transform and load into a data warehouse

- Architecture:
  1. **Extract**: pull data from sources (APIs, databases, files)
  2. **Land in raw layer**: store raw data in cloud storage (S3, GCS) - immutable
  3. **Transform**: clean, validate, and transform using Spark or SQL
  4. **Load**: write to data warehouse (Redshift, BigQuery, Snowflake)
  5. **Orchestrate**: schedule and manage dependencies with Airflow or Dagster
- Key principles:
  - Idempotent operations (re-running produces the same result)
  - Partitioned by date for efficient processing and querying
  - Schema validation at ingestion (fail fast on bad data)
  - Separate raw, staging, and production layers (medallion architecture)
- Monitoring: track row counts, data freshness, and processing time

### Design a Streaming Data Pipeline

**Requirements**: process clickstream events in real-time for a recommendation engine

- Architecture:
  1. **Ingest**: events published to Kafka/Kinesis/Pub/Sub
  2. **Process**: stream processing with Flink or Spark Structured Streaming
  3. **Enrich**: join with reference data (user profiles, product catalog)
  4. **Sink**: write to real-time serving layer (Redis, DynamoDB) and analytics store (BigQuery, Redshift)
  5. **Monitor**: track throughput, latency, consumer lag
- Key considerations:
  - Event time vs processing time (use event time for accuracy)
  - Windowing: tumbling, sliding, session windows
  - Watermarks for handling late data
  - Exactly-once semantics (Kafka transactions, Flink checkpoints)

### Exactly-Once Processing

- **At-most-once**: messages may be lost, never duplicated (fire and forget)
- **At-least-once**: messages are never lost, may be duplicated (retry on failure)
- **Exactly-once**: messages are processed exactly one time (hardest to achieve)
- Approaches to exactly-once:
  - Idempotent producers + transactional consumers (Kafka exactly-once)
  - Checkpoint-based recovery (Flink savepoints)
  - Deduplication at the consumer (use unique event IDs)
  - Write-ahead logs with two-phase commit
- In practice: design for at-least-once delivery with idempotent processing

---

## Data Modeling Questions

### Star Schema Design

- **Fact tables**: contain measurable business events (sales, clicks, transactions)
  - Foreign keys to dimension tables
  - Numeric measures (amount, quantity, duration)
  - Typically very large (billions of rows)
- **Dimension tables**: contain descriptive attributes (who, what, where, when)
  - Customer, Product, Date, Location dimensions
  - Relatively small (thousands to millions of rows)
  - Denormalized for query performance
- Benefits: simple to understand, fast for analytical queries, works well with BI tools
- Documentation: https://docs.aws.amazon.com/redshift/latest/dg/c_best-practices-star-schema.html

### Slowly Changing Dimensions (SCD)

**Type 1 - Overwrite**
- Update the dimension record in place
- No history preserved
- Use when: historical values are not important (fixing typos)

**Type 2 - Add New Row**
- Insert a new row with a new surrogate key
- Mark old row as inactive (effective date, expiry date, is_current flag)
- Preserves full history
- Use when: you need to track changes over time (address changes, status changes)

**Type 3 - Add New Column**
- Add a column for the previous value
- Only tracks one level of history
- Use when: you only need the current and previous value

**Type 6 - Hybrid (1 + 2 + 3)**
- Combines Type 1, 2, and 3 approaches
- New row for history + current value column for easy querying

### Normalization vs Denormalization

| Factor | Normalized | Denormalized |
|--------|-----------|--------------|
| Data redundancy | Minimal | Significant |
| Write performance | Better (update one place) | Worse (update many places) |
| Read performance | Slower (many joins) | Faster (fewer joins) |
| Storage | Less | More |
| Use case | OLTP (transactional) | OLAP (analytical) |

- OLTP systems: normalize to 3NF for data integrity
- OLAP/data warehouse: denormalize for query performance
- Data lake: store raw (normalized), transform to denormalized for consumption

### Data Vault Modeling

- Hub tables: business keys (customer ID, product ID)
- Link tables: relationships between hubs
- Satellite tables: descriptive attributes with timestamps
- Benefits: handles schema changes gracefully, full auditability
- Best for: enterprise data warehouses with many sources and frequent changes

---

## SQL and Query Optimization

### Common SQL Interview Questions

**Window Functions**
```sql
-- Rank customers by total spend per region
SELECT 
    customer_id,
    region,
    total_spend,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_spend DESC) AS rank,
    SUM(total_spend) OVER (PARTITION BY region) AS region_total,
    total_spend / SUM(total_spend) OVER (PARTITION BY region) AS pct_of_region
FROM customer_spend;
```

**Finding Duplicates**
```sql
-- Find duplicate records
SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

**Running Totals**
```sql
-- Calculate running total of daily revenue
SELECT 
    date,
    revenue,
    SUM(revenue) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) AS running_total
FROM daily_revenue;
```

**Gap Analysis**
```sql
-- Find gaps in sequential IDs
SELECT 
    id + 1 AS gap_start,
    next_id - 1 AS gap_end
FROM (
    SELECT id, LEAD(id) OVER (ORDER BY id) AS next_id
    FROM orders
) t
WHERE next_id - id > 1;
```

### Query Optimization Techniques

1. **Use EXPLAIN ANALYZE** to understand query execution plans
2. **Indexing**: create indexes on columns used in WHERE, JOIN, and ORDER BY
3. **Avoid SELECT ***: only select columns you need
4. **Partition pruning**: partition large tables by date or region
5. **Predicate pushdown**: filter early in the query to reduce data scanned
6. **Avoid correlated subqueries**: rewrite as JOINs or window functions
7. **Statistics**: keep table statistics updated for the query optimizer
8. **Materialized views**: pre-compute expensive aggregations
9. **Distribution keys**: choose keys that minimize data shuffling (Redshift, BigQuery)
10. **Columnar formats**: use Parquet or ORC for analytical queries

### Data Warehouse Query Patterns

- **Fact-dimension join**: the fundamental analytical query pattern
- **Aggregate and filter**: GROUP BY with HAVING for summarization
- **Time-series analysis**: window functions for trends and comparisons
- **Cohort analysis**: group users by acquisition date, track behavior over time
- **Funnel analysis**: measure conversion through sequential steps

---

## Data Quality and Governance

### Data Quality Dimensions

- **Completeness**: are all required fields populated?
- **Accuracy**: does the data reflect reality?
- **Consistency**: is the same entity represented the same way across systems?
- **Timeliness**: is the data available when needed?
- **Uniqueness**: are there duplicate records?
- **Validity**: does the data conform to defined rules and formats?

### Data Quality Checks in Pipelines

- Schema validation: verify column names, types, and constraints
- Null checks: alert on unexpected NULL values in required fields
- Range checks: verify numeric values fall within expected ranges
- Referential integrity: verify foreign keys exist in dimension tables
- Row count validation: compare expected vs actual row counts
- Freshness checks: verify data is not stale
- Tools: Great Expectations, dbt tests, Soda, AWS Deequ
- Documentation: https://docs.greatexpectations.io/docs/

### Data Governance Concepts

- **Data catalog**: searchable inventory of data assets (AWS Glue Catalog, Google Data Catalog, Azure Purview)
- **Data lineage**: track where data comes from and how it is transformed
- **Access control**: role-based access to datasets and columns
- **Data classification**: label data by sensitivity (public, internal, confidential, restricted)
- **Retention policies**: define how long data is kept and when it is deleted
- **PII handling**: masking, tokenization, or encryption of personal data

---

## Tool Comparison

### Spark vs Flink

| Factor | Apache Spark | Apache Flink |
|--------|-------------|--------------|
| Primary strength | Batch processing | Stream processing |
| Streaming model | Micro-batch (Structured Streaming) | True event-at-a-time |
| Latency | Seconds to minutes | Milliseconds to seconds |
| State management | Checkpointing | Savepoints and checkpoints |
| Ecosystem | Larger (MLlib, GraphX, SparkSQL) | Growing (FlinkML, Gelly) |
| Managed options | EMR, Dataproc, Databricks | Kinesis Data Analytics, Managed Flink |

**Use Spark when**: batch is primary, streaming latency of seconds is acceptable, need ML libraries
**Use Flink when**: true real-time processing is required, complex event processing, low-latency streaming

### Airflow vs Dagster

| Factor | Apache Airflow | Dagster |
|--------|---------------|---------|
| Scheduling | Cron-based, calendar scheduling | Cron, sensors, asset-based |
| Data awareness | Task-centric (runs tasks) | Asset-centric (produces data assets) |
| Testing | Harder to test locally | Built-in testing and type checking |
| UI | Mature, widely adopted | Modern, asset-lineage focused |
| Managed options | MWAA (AWS), Cloud Composer (GCP) | Dagster Cloud |

**Use Airflow when**: established team familiarity, complex task dependencies, broad integrations
**Use Dagster when**: new projects, data asset-centric workflows, strong testing requirements

### Cloud Data Warehouse Comparison

| Factor | Redshift | BigQuery | Snowflake |
|--------|----------|----------|-----------|
| Pricing model | Per-node (provisioned) or serverless | Per-query (on-demand) or slots | Per-credit (compute) + storage |
| Scaling | Resize cluster or use serverless | Auto-scales | Auto-scales warehouse |
| Storage format | Columnar | Columnar | Columnar |
| Semi-structured | SUPER type | STRUCT, ARRAY, JSON | VARIANT type |
| Cloud | AWS | GCP (multi-cloud available) | Multi-cloud |

---

## System Design - Design a Real-Time Analytics Pipeline

### Requirements

- Process 100,000 events per second
- Sub-second dashboard updates
- 90-day data retention for detailed data
- 2-year retention for aggregated data

### Architecture

1. **Ingestion**: Kafka cluster with partitioned topics (partition by user_id or event_type)
2. **Stream processing**: Flink job for real-time aggregation
   - Windowed aggregations (1-minute, 5-minute, 1-hour)
   - Sessionization for user behavior analysis
   - Enrichment with user and product dimensions
3. **Real-time serving**: Redis or Druid for sub-second dashboard queries
4. **Batch layer**: daily Spark jobs for historical aggregation
5. **Long-term storage**: Parquet files in S3/GCS partitioned by date
6. **Query layer**: BigQuery/Redshift for ad hoc analysis on historical data
7. **Visualization**: Grafana or Looker connected to serving layer

### Key Design Decisions

- **Lambda vs Kappa architecture**:
  - Lambda: separate batch and stream paths (more complex, handles reprocessing well)
  - Kappa: stream-only with replay capability (simpler, requires robust streaming)
- **Partitioning strategy**: partition by time for analytics, by key for user-level queries
- **Compaction**: merge small files into larger files periodically for query performance
- **Schema evolution**: use Avro or Protobuf with schema registry for forward/backward compatibility

---

## Recommended Preparation Resources

- Designing Data-Intensive Applications by Martin Kleppmann
- Fundamentals of Data Engineering by Joe Reis and Matt Housley
- The Data Warehouse Toolkit by Ralph Kimball
- Apache Spark Documentation: https://spark.apache.org/docs/latest/
- Apache Kafka Documentation: https://kafka.apache.org/documentation/
- dbt Documentation: https://docs.getdbt.com/docs/introduction
- Great Expectations: https://docs.greatexpectations.io/docs/
