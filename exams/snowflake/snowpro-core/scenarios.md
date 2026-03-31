# SnowPro Core Exam Scenarios

## Scenario 1: Virtual Warehouse Sizing and Scaling

**Scenario:** A retail company runs a Snowflake Enterprise account. During business hours (9 AM - 5 PM), their BI team of 50 analysts runs concurrent dashboards causing queuing. After hours, a data engineering team runs complex ETL transformations that take too long on their current Medium warehouse. The company wants to optimize both scenarios without over-spending.

**Question:** What is the best approach to address both the concurrency issue during business hours and the slow ETL transformations after hours?

**Solution:**
- **For BI team concurrency:** Configure a multi-cluster warehouse with auto-scaling (Standard scaling policy) to handle concurrent dashboard queries. Set MIN_CLUSTER_COUNT = 1 and MAX_CLUSTER_COUNT based on expected concurrency.
- **For ETL performance:** Create a separate, larger warehouse (Large or X-Large) for ETL workloads. Set auto-suspend to 5 minutes to avoid unnecessary costs. Schedule ETL tasks to use this dedicated warehouse.

**Why This Works:**
- Multi-cluster warehouses scale OUT (more clusters) for concurrency
- Larger warehouses scale UP (more resources per cluster) for complex queries
- Separating workloads prevents resource contention
- Auto-suspend minimizes idle costs

**Common Distractors:**
- Using a single 4X-Large warehouse for everything (expensive, doesn't solve concurrency)
- Scaling up the BI warehouse (doesn't help with concurrency, just query speed)
- Using economy scaling policy (slower to scale, causes more queuing)
- Adding clustering keys (addresses data organization, not compute issues)

---

## Scenario 2: Data Loading Strategy

**Scenario:** A logistics company needs to load data into Snowflake from two sources: (1) Daily CSV exports from their ERP system, each file approximately 5 GB, placed in S3 every night at 2 AM. (2) Real-time IoT sensor data from 10,000 delivery trucks streaming JSON events continuously throughout the day.

**Question:** What loading strategy should the company implement for each data source?

**Solution:**
- **ERP Daily Exports:** Use COPY INTO with an external stage pointing to S3. Create a task scheduled at 3 AM to run the COPY INTO command. Use PATTERN to match the daily file naming convention. Set ON_ERROR = 'SKIP_FILE' to avoid partial loads.
- **IoT Sensor Data:** Use Snowpipe with auto-ingest enabled on the S3 bucket. Configure S3 event notifications (SQS) to trigger Snowpipe. Store as VARIANT for flexible JSON schema handling.

**Why This Works:**
- COPY INTO is ideal for batch, scheduled loads of known files
- Snowpipe is designed for continuous, event-driven ingestion
- Snowpipe handles high-volume, small-file ingestion efficiently
- VARIANT handles evolving JSON schemas without schema changes

**Common Distractors:**
- Using Snowpipe for the daily ERP load (unnecessary overhead for batch files)
- Using COPY INTO with a manual trigger for IoT (not scalable for real-time)
- Loading IoT data as structured columns (brittle if schema evolves)
- Using INSERT INTO statements for batch loading (much slower than COPY INTO)

---

## Scenario 3: Security and Access Control Design

**Scenario:** A healthcare company is setting up Snowflake on Business Critical edition. They have three teams: Data Engineers (create and manage pipelines), Data Analysts (query production data), and Compliance Officers (audit access patterns). Patient data must be masked for analysts but visible to authorized users. All connections must come from the corporate network only.

**Question:** How should the company configure security to meet these requirements?

**Solution:**
1. **Role Hierarchy:**
   - Create custom roles: DATA_ENGINEER, DATA_ANALYST, COMPLIANCE_OFFICER
   - Grant DATA_ENGINEER to SYSADMIN
   - Grant DATA_ANALYST to SYSADMIN
   - Grant COMPLIANCE_OFFICER to SECURITYADMIN
   - DATA_ENGINEER gets CREATE privileges on databases and schemas
   - DATA_ANALYST gets SELECT on production tables/views

2. **Dynamic Data Masking:**
   - Create masking policies on PHI columns (SSN, patient name, DOB)
   - Apply policies that return masked values for DATA_ANALYST role
   - DATA_ENGINEER role sees full values when authorized

3. **Network Policy:**
   - Create a network policy with ALLOWED_IP_LIST containing corporate IP ranges
   - Apply at the account level to restrict all connections

4. **Audit:**
   - Grant COMPLIANCE_OFFICER access to ACCOUNT_USAGE schema
   - Use ACCESS_HISTORY and LOGIN_HISTORY views for auditing

**Common Distractors:**
- Using ACCOUNTADMIN for data engineering tasks (violates least privilege)
- Creating secure views instead of masking policies (less flexible, harder to maintain)
- Applying network policy only to specific users (leaves gaps in security)
- Granting SECURITYADMIN to data engineers (excessive privileges)

---

## Scenario 4: Performance Troubleshooting

**Scenario:** A financial services company has a 3 TB transaction table that is queried heavily for daily reporting. Reports filter by transaction_date and region. Recently, query times have increased from 10 seconds to over 3 minutes. The warehouse is an X-Large with no queuing observed. The Query Profile shows most time spent in "TableScan" with low pruning efficiency (scanning 80% of micro-partitions).

**Question:** What steps should the company take to resolve the performance issue?

**Solution:**
1. **Analyze Clustering:** Run SYSTEM$CLUSTERING_INFORMATION('transactions', '(transaction_date, region)') to check clustering depth
2. **Add Clustering Key:** ALTER TABLE transactions CLUSTER BY (transaction_date, region)
3. **Enable Automatic Clustering:** This is automatic on Enterprise edition when a clustering key is defined
4. **Monitor:** Use SYSTEM$CLUSTERING_DEPTH() to track improvement over time
5. **Consider materialized views** for the most common report queries

**Why This Works:**
- 3 TB table is large enough to benefit from clustering keys
- Filters on transaction_date and region align with the clustering key
- Poor pruning (80% scan) indicates natural clustering has degraded
- Automatic clustering maintains the optimization over time

**Common Distractors:**
- Scaling up the warehouse (doesn't fix the pruning issue - still scans 80% of data)
- Adding more indexes (Snowflake doesn't support traditional indexes)
- Partitioning the table manually (Snowflake handles partitioning automatically)
- Increasing the result cache duration (cache won't help if data changes daily)

---

## Scenario 5: Data Sharing and Collaboration

**Scenario:** A data analytics firm wants to share curated datasets with three types of consumers: (1) A partner company that already has a Snowflake account in the same region, (2) A client without a Snowflake account who needs to query the data, (3) Multiple unknown organizations through a public listing. The firm wants to share data without creating copies and needs to control access at the table level.

**Question:** What approach should the firm take for each consumer type?

**Solution:**
1. **Partner with Snowflake Account (Same Region):**
   - Create a Direct Share
   - Add specific databases, schemas, and tables/views to the share
   - Add the partner's account as a consumer
   - Partner creates a database from the share

2. **Client without Snowflake Account:**
   - Create a Reader Account for the client
   - Create a share and grant it to the reader account
   - Set up a virtual warehouse in the reader account (provider pays)
   - Client accesses data through the reader account

3. **Public Listing:**
   - Publish a listing on Snowflake Marketplace
   - Can be free or paid listing
   - Set terms and conditions
   - Consumers can discover and request access

**Why This Works:**
- Direct shares have zero data movement - consumers see live data
- Reader accounts extend sharing to non-Snowflake users
- Marketplace provides discovery and self-service onboarding
- All three methods avoid data copying

**Common Distractors:**
- Exporting data to S3 and sharing the bucket (creates copies, not live)
- Creating replicas for each consumer (unnecessary data duplication)
- Using database replication for same-region sharing (overkill, designed for cross-region)
- Giving direct access to the provider's account (security risk)

---

## Scenario 6: Time Travel and Data Recovery

**Scenario:** A data engineer on Snowflake Enterprise edition accidentally ran a DELETE statement without a WHERE clause on a critical production table at 2:15 PM. The table has DATA_RETENTION_TIME_IN_DAYS set to 30. The engineer discovers the mistake at 2:45 PM. The table contains 500 million rows and is actively used by downstream reports.

**Question:** What is the fastest way to recover the deleted data with minimal impact to downstream consumers?

**Solution:**
1. **Immediate recovery using Time Travel:**
```sql
-- Create a clone of the table at the point before the delete
CREATE TABLE production_table_recovered
  CLONE production_table
  AT(OFFSET => -1800); -- 30 minutes ago

-- Verify recovered data
SELECT COUNT(*) FROM production_table_recovered;

-- Swap the tables
ALTER TABLE production_table RENAME TO production_table_corrupted;
ALTER TABLE production_table_recovered RENAME TO production_table;

-- Clean up after verification
DROP TABLE production_table_corrupted;
```

2. **Alternative approach:**
```sql
-- Insert the deleted data back using Time Travel
INSERT INTO production_table
  SELECT * FROM production_table AT(TIMESTAMP => '2024-01-15 14:14:00'::TIMESTAMP);
```

**Why This Works:**
- Time Travel allows querying data at any point within the retention period
- Cloning with Time Travel creates an instant metadata copy at the specified point
- Table rename is instantaneous and doesn't affect downstream references if they use the same name
- 30-day retention means plenty of time to recover

**Common Distractors:**
- Contacting Snowflake Support for Fail-safe recovery (unnecessary when Time Travel is available)
- Restoring from a backup file (slower, Snowflake doesn't use traditional backups)
- Using UNDROP TABLE (only works for dropped tables, not deleted rows)
- Recreating and reloading the table from source (unnecessary and time-consuming)

---

## Scenario 7: Streams and Tasks Pipeline

**Scenario:** An e-commerce company wants to build a near real-time data pipeline in Snowflake. Raw order data lands in a staging table via Snowpipe. The pipeline needs to: (1) Transform raw JSON orders into a structured format, (2) Update a running aggregation of daily sales by product category, (3) Load transformed data into a star schema for reporting. The pipeline should run automatically every 5 minutes.

**Question:** How should the company design this pipeline using Snowflake-native features?

**Solution:**
1. **Create streams on source tables:**
```sql
CREATE STREAM orders_stream ON TABLE raw_orders;
```

2. **Create a task tree (DAG):**
```sql
-- Root task: Transform raw orders
CREATE TASK transform_orders
  WAREHOUSE = etl_wh
  SCHEDULE = '5 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
  INSERT INTO orders_structured
  SELECT
    raw:order_id::NUMBER AS order_id,
    raw:product_category::STRING AS category,
    raw:amount::DECIMAL(10,2) AS amount,
    raw:order_date::TIMESTAMP AS order_date
  FROM orders_stream;

-- Child task: Update daily aggregations
CREATE TASK update_daily_sales
  WAREHOUSE = etl_wh
  AFTER transform_orders
AS
  MERGE INTO daily_sales_summary t
  USING (SELECT category, order_date::DATE as sale_date, SUM(amount) as total
         FROM orders_structured
         WHERE order_date >= CURRENT_DATE()
         GROUP BY category, sale_date) s
  ON t.category = s.category AND t.sale_date = s.sale_date
  WHEN MATCHED THEN UPDATE SET t.total = s.total
  WHEN NOT MATCHED THEN INSERT VALUES (s.category, s.sale_date, s.total);

-- Resume tasks (required after creation)
ALTER TASK update_daily_sales RESUME;
ALTER TASK transform_orders RESUME;
```

**Why This Works:**
- Streams capture only new/changed data (CDC) - no reprocessing
- SYSTEM$STREAM_HAS_DATA prevents unnecessary task execution
- Task trees enforce execution order
- 5-minute schedule provides near real-time updates
- MERGE handles both inserts and updates for aggregations

**Common Distractors:**
- Using scheduled COPY INTO instead of streams (reprocesses all data)
- Running tasks without WHEN clause (wastes compute when no new data)
- Resuming parent task before child tasks (child won't execute)
- Using INSERT instead of MERGE for aggregations (creates duplicates)

---

## Scenario 8: Edition Selection and Cost Optimization

**Scenario:** A mid-size SaaS company is evaluating Snowflake for their analytics platform. Requirements: (1) Multi-cluster warehouses for 200+ concurrent BI users, (2) 90-day Time Travel for compliance, (3) Column-level security for PII data, (4) Cross-region replication for disaster recovery with automatic failover, (5) Budget is a concern - they want the minimum edition that meets all requirements.

**Question:** Which Snowflake edition should they select and why?

**Solution:**
**Business Critical Edition** is the minimum edition that meets all requirements.

| Requirement | Standard | Enterprise | Business Critical |
|-------------|----------|------------|-------------------|
| Multi-cluster warehouses | No | Yes | Yes |
| 90-day Time Travel | No | Yes | Yes |
| Column-level security | No | Yes | Yes |
| Cross-region failover | No | No | Yes |

**Why Business Critical:**
- Enterprise meets requirements 1-3 but NOT requirement 4
- Cross-region replication with automatic failover requires Business Critical
- Standard edition is insufficient for all listed requirements
- VPS would work but is more expensive than needed

**Common Distractors:**
- Enterprise edition (lacks automatic failover/failback for DR)
- Standard edition (lacks multi-cluster warehouses, 90-day Time Travel, and column security)
- VPS (meets all requirements but exceeds minimum needed)
- Selecting Enterprise with manual replication scripts (doesn't provide automatic failover)
