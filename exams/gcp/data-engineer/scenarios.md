---
last-updated: 2026-05-03
---

# GCP Professional Data Engineer (PDE) - Exam Scenarios

> Eight worked scenarios mirroring PDE question style. PDE tests data ingestion, processing (batch + stream), storage, ML pipeline integration, and governance.

---

## Scenario 1 - Streaming pipeline with deduplication

A team ingests 200K events/sec from Pub/Sub, deduplicates by event ID, and writes to BigQuery for analytics within minutes.

**Options:** A. Pub/Sub → Dataflow streaming with `Distinct` transform on event ID, BigQuery streaming inserts. B. Pub/Sub → Cloud Functions → BigQuery batch load. C. Pub/Sub → Dataproc Spark Streaming. D. Direct Pub/Sub → BigQuery subscription without dedup.

**Analysis:** A is right - Dataflow is the GCP-native streaming engine with windowing and built-in dedup primitives. BigQuery streaming inserts (or Storage Write API for higher throughput) ingest in seconds. B doesn't scale to 200K/s. C works but Dataflow is the recommended GCP managed option. D loses dedup.

**Answer:** A

**Key takeaway:** Streaming dedup pattern: Pub/Sub → Dataflow → BigQuery. Use Storage Write API for higher throughput than legacy streaming inserts.

---

## Scenario 2 - Batch ETL with orchestration

A team has nightly ETL: read CSVs from Cloud Storage, transform with Spark, load to BigQuery. They need orchestration with retries, dependencies, and notification on failure.

**Options:** A. Cloud Composer DAG triggering Dataproc Serverless Spark + BigQuery load + Cloud Functions notification. B. Cron + bash scripts. C. Cloud Run scheduled jobs. D. BigQuery scheduled queries.

**Analysis:** A is right - Composer (managed Airflow) is the standard orchestrator with operator support for Dataproc, BigQuery, and notification. Dataproc Serverless removes cluster management. B lacks observability. C - Cloud Run jobs work for simple cases but lack dependency graphs. D doesn't do the Spark transform.

**Answer:** A

**Key takeaway:** GCP orchestration = Cloud Composer (managed Airflow). For simple schedules: Cloud Scheduler + Cloud Run/Functions. For Spark: Dataproc Serverless > Dataproc with cluster.

---

## Scenario 3 - Cost optimization in BigQuery

A team queries 50 TB monthly in BigQuery on-demand, cost is becoming a concern. Many queries are predictable analytics.

**Options:** A. Switch to BigQuery Editions (Standard or Enterprise) with reservations + autoscaling slots; partition + cluster tables; materialized views for repeated queries. B. Move to Cloud SQL. C. Use SELECT * with no filters. D. Increase machine size.

**Analysis:** A is right - the BigQuery cost-optimization triple: Editions/reservations for predictable spend, partitioning + clustering for less data scanned, materialized views for repeated aggregations. B abandons the analytics tool. C is anti-pattern. D - BigQuery is serverless, no machine size.

**Answer:** A

**Key takeaway:** BigQuery cost optimization: partitioning + clustering + materialized views (less data scanned) + Editions/reservations (predictable spend) + result caching (free repeated queries).

---

## Scenario 4 - Real-time analytics dashboard

Marketing wants near-real-time dashboards (data <30 sec old) on streaming clickstream data with SQL queries.

**Options:** A. Pub/Sub → Dataflow → BigQuery via Storage Write API; Looker / Looker Studio dashboards. B. Pub/Sub → Cloud Storage → BigQuery batch load. C. Pub/Sub → Cloud Functions writing to Firestore. D. Pub/Sub → BigTable.

**Analysis:** A is right - the real-time analytics pattern; Storage Write API is now the recommended ingestion (lower latency, exactly-once, higher throughput than legacy streaming). Looker/Studio for dashboards. B is batch (minutes-hours latency). C - Firestore isn't analytics. D - BigTable is wide-column, not the SQL analytics target.

**Answer:** A

**Key takeaway:** Real-time analytics on GCP: Pub/Sub → Dataflow → BigQuery (Storage Write API) → Looker / Looker Studio.

---

## Scenario 5 - Slowly changing dimension (SCD)

A retailer needs to track historical changes to customer addresses. Queries should support "What was the customer's address as of date X?"

**Options:** A. Type 2 SCD with effective_from / effective_to columns; partitioned by effective_from in BigQuery. B. Overwrite the row on change. C. Store JSON of every change. D. Type 1 SCD only.

**Analysis:** A is right - Type 2 SCD with date ranges is the textbook for "as of" queries. Partitioning by effective date supports efficient time-travel queries. B is Type 1 (overwrite), loses history. C is unstructured. D loses history.

**Answer:** A

**Key takeaway:** SCD Type 1 = overwrite (no history). Type 2 = new row per change with date ranges. Type 3 = previous-value column. PDE expects Type 2 for "track historical changes."

---

## Scenario 6 - ML feature pipeline

A team trains models that need consistent features computed in both batch (training) and streaming (inference). Feature drift between training and serving caused recent quality issues.

**Options:** A. Vertex AI Feature Store with online + offline stores. B. Two separate pipelines for batch and streaming. C. Compute features on the fly during inference. D. Cache features in Memorystore manually.

**Analysis:** A is right - Vertex AI Feature Store solves training-serving skew with shared feature definitions, offline store for training, online store for low-latency inference. B is the problem (drift). C is unscalable. D reinvents Feature Store.

**Answer:** A

**Key takeaway:** Feature consistency across train/serve = Vertex AI Feature Store (or BigQuery + Bigtable as a homemade variant). Avoid two pipelines for the same feature.

---

## Scenario 7 - Data governance with sensitive data

A company stores PII in BigQuery and must protect SSN, credit card numbers; analysts can see aggregated data but not raw PII.

**Options:** A. Data Catalog with policy tags on sensitive columns; column-level access control via taxonomy bound to IAM; analysts get access to non-PII columns or masked views. B. Two separate datasets, one with PII, one without. C. Application-layer redaction. D. Manual review of queries.

**Analysis:** A is right - the canonical GCP pattern. Data Catalog policy tags + BigQuery column-level security enforce per-column access. Authorized views for richer masking logic. B works but operationally expensive. C is bypassed by direct BigQuery access. D is manual.

**Answer:** A

**Key takeaway:** Sensitive data in BigQuery = Data Catalog policy tags + column-level access. Combine with row-level security and authorized views for layered control.

---

## Scenario 8 - Data lake architecture

A company has 100s of TB of raw data needing exploratory analytics, schema evolution, and integration with both Spark and SQL.

**Options:** A. Cloud Storage as data lake with Hive metastore in Dataproc Metastore; BigLake tables exposing Cloud Storage data as queryable in BigQuery. B. Load everything into BigQuery. C. Cloud SQL for everything. D. Bigtable for everything.

**Analysis:** A is right - the modern lakehouse pattern on GCP. BigLake tables let BigQuery query Cloud Storage data with fine-grained ACL. Dataproc Metastore is the Hive metastore for Spark interoperability. B loses lake flexibility (raw + schema-on-read). C/D are wrong storage tiers.

**Answer:** A

**Key takeaway:** GCP lakehouse = Cloud Storage + BigLake (BigQuery query layer over GCS) + Dataproc Metastore (Hive for Spark). Iceberg / Delta support is increasing.
