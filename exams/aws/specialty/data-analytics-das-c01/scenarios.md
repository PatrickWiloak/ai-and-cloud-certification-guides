# AWS Data Analytics Specialty (DAS-C01) High-Yield Scenarios

## Scenario 1: Real-Time Clickstream Analytics

**Scenario**: An e-commerce company wants to analyze user clickstream data in real-time. They need to detect anomalous user behavior within seconds, store all raw data in a data lake, and generate hourly aggregate reports. Data volume is 50,000 events per second at peak.

**Solution Pattern**:
- **Ingestion**: Kinesis Data Streams with enough shards for 50K events/sec
- **Real-time anomaly detection**: Kinesis Data Analytics (SQL) with RANDOM_CUT_FOREST
- **Data lake storage**: Kinesis Data Firehose to S3 in Parquet format (format conversion via Glue Data Catalog)
- **Hourly reports**: Athena scheduled queries or Glue ETL on S3 data
- **Dashboards**: QuickSight connected to Athena with SPICE for caching

**Common Distractors**:
- Using Firehose alone (60-sec buffer does not support real-time anomaly detection)
- Using Lambda for anomaly detection (not designed for continuous stream analytics)
- Storing raw data in Redshift (S3 data lake is more cost-effective for raw storage)

**Key Takeaway**: Use Kinesis Data Streams for real-time processing needs, Firehose for delivery to S3. They can work in parallel from the same stream using enhanced fan-out.

---

## Scenario 2: Data Lake Migration from On-Premises

**Scenario**: A company has 500 TB of historical data on-premises and generates 2 TB daily. They want to build a data lake on AWS with centralized governance, allow multiple teams to query data with column-level access control, and transform data from CSV to Parquet.

**Solution Pattern**:
- **Initial transfer**: AWS Snowball Edge devices for 500 TB (would take weeks over network)
- **Ongoing replication**: Direct Connect for 2 TB daily with DMS for database sources
- **Data lake**: S3 with Glue Crawlers for schema discovery
- **Transformation**: Glue ETL to convert CSV to Parquet, partitioned by date
- **Governance**: Lake Formation for centralized permissions with column-level security
- **Querying**: Athena for ad-hoc, Redshift Spectrum for complex analytics

**Common Distractors**:
- Transferring 500 TB over internet (too slow)
- Using IAM policies for column-level access (IAM is too coarse for column-level)
- Skipping format conversion (CSV queries are 5-10x more expensive in Athena)

**Key Takeaway**: Snow family for large initial transfers, Lake Formation for fine-grained governance, and always convert to columnar formats for analytics.

---

## Scenario 3: Streaming ETL Pipeline

**Scenario**: A financial services company receives trade data via Kinesis Data Streams. They need to enrich each trade with reference data from DynamoDB, validate data quality, transform to Parquet, and load to both Redshift and S3. Failed records should be sent to a dead-letter queue.

**Solution Pattern**:
- **Processing**: Kinesis Data Analytics (Apache Flink) for enrichment and validation
- **Reference data**: Flink async I/O to DynamoDB for trade enrichment
- **S3 delivery**: Flink sink to S3 in Parquet format
- **Redshift loading**: Firehose from a second Kinesis stream to Redshift (via S3 staging)
- **Error handling**: Flink side output for failed records to SQS dead-letter queue
- **Exactly-once**: Flink checkpointing for processing guarantees

**Common Distractors**:
- Using Glue Streaming ETL (works but Flink is better for complex enrichment with external lookups)
- Loading directly to Redshift without S3 staging (COPY from S3 is the standard pattern)
- Using Lambda for enrichment (15-min timeout, harder to manage state)

**Key Takeaway**: Kinesis Data Analytics with Flink is ideal for complex stream processing with enrichment, stateful processing, and exactly-once guarantees.

---

## Scenario 4: Multi-Team Analytics Platform

**Scenario**: A company has data engineering, data science, and business intelligence teams. Data engineers need EMR for Spark jobs, data scientists need interactive notebooks, and BI analysts need SQL dashboards. All teams should query the same data catalog but with different access levels.

**Solution Pattern**:
- **Shared catalog**: Glue Data Catalog as the central metastore
- **Data engineering**: EMR with Spark, using Glue Data Catalog as Hive metastore
- **Data science**: EMR notebooks or SageMaker Studio with Athena/Spark
- **BI analysts**: QuickSight dashboards connected to Athena and Redshift
- **Access control**: Lake Formation for per-team column and row-level permissions
- **Cost management**: Athena workgroups with per-team scan limits

**Common Distractors**:
- Separate data copies per team (expensive, data inconsistency)
- Using S3 bucket policies per team (does not support column-level restrictions)
- Single Redshift cluster for all workloads (BI and ETL compete for resources)

**Key Takeaway**: Glue Data Catalog provides a shared metastore across all analytics services. Lake Formation enables team-specific access on the same data.

---

## Scenario 5: Cost Optimization for Analytics Queries

**Scenario**: A company spends $50,000/month on Athena queries. Most queries scan entire datasets. Tables are stored as gzipped JSON files in S3 with no partitioning. How should they reduce costs?

**Solution Pattern**:
1. **Convert to Parquet**: Use Glue ETL with CTAS or Athena CTAS - reduces scan by 75%+
2. **Partition data**: Re-organize by date (most common filter) - `s3://bucket/year=/month=/day=/`
3. **Compress with Snappy**: Parquet with Snappy compression for best balance
4. **Update Glue Catalog**: Run crawlers on new partitioned Parquet data
5. **Workgroups**: Set per-query data scan limits to prevent expensive mistakes
6. **Projected savings**: JSON to Parquet = ~75% reduction; add partitioning = ~90%+ reduction

**Common Distractors**:
- Adding LIMIT to queries (does not reduce data scanned)
- Moving to Redshift (might be more expensive for ad-hoc patterns)
- Using S3 Select (works per-object, not for cross-object analytics)

**Key Takeaway**: The top three cost optimizations for Athena are always: columnar format, partitioning, and compression.

---

## Scenario 6: Database Change Capture to Data Lake

**Scenario**: An application uses Amazon Aurora PostgreSQL. The analytics team needs near real-time access to database changes in their data lake. They also need to maintain a full historical record with the ability to query any point-in-time state.

**Solution Pattern**:
- **Initial load**: DMS full load from Aurora to S3 (Parquet format)
- **Ongoing CDC**: DMS change data capture to Kinesis Data Streams
- **Processing**: Lambda or Glue Streaming to transform CDC records
- **Storage**: S3 with date-partitioned Parquet files
- **History**: Append-only pattern with operation type (INSERT/UPDATE/DELETE) and timestamps
- **Point-in-time queries**: Use Athena with window functions to reconstruct state at any time
- **Catalog**: Glue Crawler to maintain table definitions

**Common Distractors**:
- Aurora zero-ETL to Redshift (good for Redshift, not for general data lake)
- DMS directly to S3 without Kinesis (works but no real-time stream processing)
- Full daily exports (not near real-time, wastes resources)

**Key Takeaway**: DMS with CDC to Kinesis enables near real-time data lake updates. Maintain full history by appending change records rather than overwriting.

---

## Scenario 7: Secure Analytics Environment

**Scenario**: A healthcare company must ensure all analytics data is encrypted at rest and in transit, restrict data access by department, audit all data access, and ensure no data leaves the VPC. They use Redshift, Athena, and S3.

**Solution Pattern**:
- **Encryption at rest**: SSE-KMS with customer managed key for S3, KMS encryption for Redshift
- **Encryption in transit**: Redshift `require_ssl`, HTTPS endpoints for all services
- **Network isolation**: Redshift Enhanced VPC Routing, S3 VPC gateway endpoint, interface endpoints for KMS/Glue
- **VPC endpoint policies**: Restrict to specific S3 buckets only
- **Access control**: Lake Formation for department-level column/row restrictions
- **Audit**: CloudTrail data events for S3, Redshift audit logging, Lake Formation audit logs
- **Data classification**: Amazon Macie for PII detection in S3

**Common Distractors**:
- SSE-S3 for compliance (SSE-KMS provides audit trail via CloudTrail)
- IAM policies alone for department access (does not provide column-level)
- Public Redshift endpoint with security groups (Enhanced VPC Routing keeps traffic private)

**Key Takeaway**: Defense in depth - encryption (KMS), network isolation (VPC endpoints + Enhanced VPC Routing), access control (Lake Formation), and auditing (CloudTrail) together.

---

## Scenario 8: OpenSearch Log Analytics

**Scenario**: A company wants centralized logging across 200 microservices. They need full-text search, real-time dashboards, and 90-day retention with the ability to search older logs. Log volume is 5 TB per day.

**Solution Pattern**:
- **Collection**: CloudWatch Logs from each microservice
- **Delivery**: CloudWatch Logs subscription filter to Kinesis Data Firehose
- **Primary storage**: OpenSearch Service with hot nodes for recent 14 days
- **Warm storage**: UltraWarm for 14-90 day data (read-only, lower cost)
- **Cold/archive**: S3 Glacier for 90+ days via OpenSearch index lifecycle policies
- **Dashboards**: OpenSearch Dashboards for real-time visualization
- **Alerts**: OpenSearch alerting for error rate thresholds

**Common Distractors**:
- Storing all 90 days on hot nodes (extremely expensive at 5 TB/day)
- Using Athena for real-time log search (not optimized for full-text search)
- CloudWatch Logs Insights for 200 services (works but OpenSearch is better for complex queries and dashboards)

**Key Takeaway**: OpenSearch with tiered storage (hot - UltraWarm - cold) balances search performance and cost for log analytics.
