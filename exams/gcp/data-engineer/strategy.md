---
last-updated: 2026-05-03
---

# GCP Professional Data Engineer (PDE) - Exam Strategy

## Format reminder

- 50-60 questions, 120 minutes
- Pass mark ~70-75% (not officially published)
- Multiple choice + multiple response
- Includes some case studies (Flowlogistic, MJTelco, etc.)

## Top traps

1. **Dataflow vs Dataproc vs Dataflow Prime**:
   - Dataflow: serverless Apache Beam, the GCP-native streaming + batch
   - Dataproc: managed Hadoop/Spark on GCE clusters
   - Dataproc Serverless: serverless Spark
   - Dataflow Prime: enhanced Dataflow with vertical autoscaling
   PDE leans toward Dataflow for streaming.

2. **BigQuery on-demand vs Editions**:
   - On-demand: pay per TB scanned (100 GB free tier)
   - Editions (Standard / Enterprise / Enterprise Plus): slot reservations with autoscaling
   Switch when monthly spend exceeds break-even (~~$300-500).

3. **Storage classes**: Standard / Nearline (>30d) / Coldline (>90d) / Archive (>365d). Lifecycle policies for transitions.

4. **Streaming inserts vs Storage Write API**: Storage Write API is the modern recommendation - exactly-once, higher throughput, lower cost.

5. **Partitioning + clustering in BigQuery**:
   - Partitioning: divides table by date, integer range, or ingestion time
   - Clustering: sorts within partitions by up to 4 columns
   Both reduce data scanned (cost + speed).

6. **Materialized views vs scheduled queries**: MVs auto-refresh, queryable as tables. Scheduled queries write results to a destination on a cadence. Different use cases.

7. **Pub/Sub vs Pub/Sub Lite**:
   - Pub/Sub: global, autoscaling, pay per message
   - Pub/Sub Lite: regional/zonal, provisioned capacity, cheaper for high steady throughput
   Pub/Sub is the default modern answer.

8. **Bigtable vs Spanner vs Firestore**:
   - Bigtable: wide-column NoSQL, single-key access at petabyte scale (HBase API), no SQL
   - Spanner: global SQL, ACID
   - Firestore: document, mobile/web sync
   Don't confuse.

9. **Apache Beam concepts**: PCollection, PTransform, ParDo, GroupByKey, CoGroupByKey, windowing (fixed, sliding, session), watermarks, triggers. Tested often in PDE.

10. **Dataform vs dbt**: Dataform is GCP-native ELT (acquired into BigQuery). dbt is the third-party. PDE leans toward Dataform.

## High-yield topics easy to miss

- BigLake tables (BigQuery query Cloud Storage / Iceberg / Delta)
- BigQuery Omni (BQ on AWS, Azure)
- BigQuery ML (in-warehouse ML)
- Dataflow templates (provided + custom)
- Dataform repositories and version control
- Data Catalog policy tags + taxonomies
- Sensitive Data Protection (formerly DLP) for PII discovery / de-id
- Vertex AI Feature Store + Pipelines
- Cloud Composer (Airflow) operator library

## Time management

120 / ~55 = ~2.2 min/question. Pace: half done by minute 60. Leave 15 min for review.

## When stuck

1. **Identify whether the workload is batch or streaming** - filters compute and storage choices.
2. **Match data shape to storage**: SQL relational → Cloud SQL / Spanner; analytics → BigQuery; key-value at scale → Bigtable; document → Firestore.
3. **Default to managed > self-managed** - Dataflow over self-Spark.
4. **Eliminate "use Cloud Functions" for high-throughput** - Functions is for low-volume glue.

## Day-of logistics

120 min, ~55 questions. Bring two IDs.

## After

**Pass:** Cert valid 2 years.

**Fail:** Most failures are on Pipeline Design (~25%) or Data Storage (~25%). Re-review Beam concepts, BigQuery cost optimization, and SCD patterns.

## PDE patterns

- "Streaming with dedup + windowing" = Pub/Sub → Dataflow → BigQuery
- "Real-time analytics dashboard" = Pub/Sub → Dataflow → BigQuery (Storage Write API) → Looker
- "Batch ETL with retries + dependencies" = Cloud Composer
- "Cost-optimize BigQuery" = Editions reservations + partitioning + clustering + MVs
- "Globally consistent SQL transactional" = Spanner
- "Wide-column NoSQL at scale" = Bigtable
- "Sensitive data column-level access" = Data Catalog policy tags + BQ column ACL
- "Schema-on-read lake" = Cloud Storage + BigLake
- "Feature consistency train/serve" = Vertex AI Feature Store
- "ELT in BigQuery with version control" = Dataform
