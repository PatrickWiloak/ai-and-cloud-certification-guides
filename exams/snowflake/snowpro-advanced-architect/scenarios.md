# SnowPro Advanced - Architect - High-Yield Scenarios and Patterns

## Multi-Account Architecture

### Cross-Region Disaster Recovery
**Scenario:** A financial services company needs to ensure business continuity for their Snowflake data platform. If their primary region (AWS us-east-1) goes down, analysts should be able to continue querying data in a secondary region (AWS us-west-2) with minimal data loss.

**Solution Pattern:**
- **Replication:** Configure database replication from primary to secondary account
- **Failover Groups:** Bundle databases, shares, and account objects into a failover group
- **Client Redirect:** Configure connection URLs to automatically redirect on failover
- **RPO:** Replication frequency determines recovery point objective (minutes to hours)
- **Failover Trigger:** Promote secondary account when primary is unavailable

**Common Distractors:**
- Using data sharing instead of replication (wrong - sharing requires the source account to be available)
- Storing backup copies in S3 as disaster recovery (wrong - not integrated, manual recovery process)
- Using Time Travel as disaster recovery (wrong - Time Travel is account-local, lost if region is down)
- Creating a read-only reader account (wrong - reader accounts depend on the provider account being active)

### Data Marketplace Provider
**Scenario:** A weather data company wants to share their datasets with hundreds of Snowflake customers globally. They need to monetize the data while ensuring consumers get low-latency access regardless of their cloud region.

**Solution Pattern:**
- **Snowflake Marketplace:** List datasets as a paid listing on Snowflake Marketplace
- **Cross-Region Replication:** Replicate data to accounts in multiple regions
- **Secure Views:** Protect underlying data logic and limit visible columns
- **Auto-Fulfillment:** Marketplace handles access provisioning automatically
- **Usage Tracking:** Monitor consumer access and query patterns

**Common Distractors:**
- Creating direct shares to each consumer (wrong - does not scale to hundreds of consumers)
- Exporting data as files for distribution (wrong - loses Snowflake sharing benefits, creates copies)
- Using a single region with no replication (wrong - high latency for distant consumers)
- Reader accounts for all consumers (wrong - provider pays compute, not scalable for monetization)

### Non-Snowflake Customer Sharing
**Scenario:** A healthcare analytics firm needs to share curated datasets with partner hospitals that do not have Snowflake accounts. The data contains PHI and requires strict access controls.

**Solution Pattern:**
- **Reader Accounts:** Create managed reader accounts for each partner
- **Secure Views:** Expose only approved columns through secure views
- **Masking Policies:** Apply dynamic masking on PHI fields based on role
- **Network Policies:** Restrict reader account access to specific IP ranges
- **Warehouse Management:** Provider manages and pays for reader compute
- **Edition:** Business Critical edition for HIPAA compliance

**Common Distractors:**
- Direct sharing (wrong - requires the consumer to have a Snowflake account)
- Exporting CSV files via email (wrong - no governance, no audit trail, HIPAA risk)
- Creating full Snowflake accounts for each partner (wrong - unnecessary cost and complexity)
- Using external tables shared via S3 (wrong - no access control, data leaves Snowflake)

## Security Architecture

### Multi-Tenant Data Isolation
**Scenario:** A SaaS company stores data for 500 tenants in a single Snowflake account. Each tenant should only see their own data, and the security model must scale without per-tenant policy maintenance.

**Solution Pattern:**
```sql
-- Row access policy using session variable
CREATE ROW ACCESS POLICY tenant_isolation AS (tenant_id VARCHAR) RETURNS BOOLEAN ->
  CURRENT_ROLE() = 'ADMIN'
  OR tenant_id = CURRENT_SESSION()::VARCHAR;

-- Apply to all tenant tables
ALTER TABLE orders ADD ROW ACCESS POLICY tenant_isolation ON (tenant_id);
ALTER TABLE customers ADD ROW ACCESS POLICY tenant_isolation ON (tenant_id);

-- Set tenant context on login
ALTER SESSION SET QUERY_TAG = 'tenant_123';
```

**Common Distractors:**
- Creating separate databases per tenant (wrong - does not scale to 500 tenants, management overhead)
- Using views with WHERE clause per tenant (wrong - requires per-tenant view maintenance)
- Relying solely on role-based access without row access policies (wrong - RBAC controls object access, not row-level filtering)
- Using column masking instead of row access (wrong - masking hides column values, not rows)

### Zero-Trust Network Architecture
**Scenario:** An enterprise requires that all Snowflake connectivity uses private network paths with no public internet exposure. They use AWS for their primary infrastructure.

**Solution Pattern:**
- **AWS PrivateLink:** Configure VPC endpoint for Snowflake access
- **Internal Stages:** Use PrivateLink for stage data transfer
- **Network Policies:** Block all public IP access to the account
- **SCIM:** Provision users via private connectivity to identity provider
- **Edition:** Business Critical or VPS edition required

**Common Distractors:**
- Using only network policies with IP allowlists (wrong - traffic still traverses public internet)
- VPN connection to Snowflake (wrong - Snowflake does not support direct VPN connections)
- Standard edition with network policies (wrong - Private Link requires Business Critical or higher)
- Using a proxy server in the VPC (wrong - adds complexity, PrivateLink is the native solution)

### Customer-Managed Key Revocation
**Scenario:** A regulated company needs the ability to immediately revoke Snowflake's access to their data if they terminate the relationship. They need cryptographic control over their data at rest.

**Solution Pattern:**
- **Tri-Secret Secure:** Enable customer-managed key alongside Snowflake's key
- **Cloud KMS:** Configure AWS KMS (or Azure Key Vault, GCP KMS) key
- **Composite Key:** Master key derived from both Snowflake key and customer key
- **Revocation:** Disable or delete the customer key in cloud KMS to revoke access
- **Edition:** Business Critical edition required

**Common Distractors:**
- Relying on Snowflake's default encryption only (wrong - no customer control over keys)
- Using account deletion as the revocation mechanism (wrong - slow, not cryptographic)
- Encrypting data before loading into Snowflake (wrong - breaks query functionality)
- Standard edition with encryption (wrong - Tri-Secret Secure requires Business Critical)

## Performance Optimization

### Slow Dashboard Queries
**Scenario:** An analytics dashboard runs 50 concurrent queries during business hours. Users report slow response times. The Query Profile shows minimal spilling but long queue times. The warehouse is a Large single-cluster warehouse.

**Solution Pattern:**
- **Diagnosis:** Queue times indicate concurrency bottleneck, not compute bottleneck
- **Solution:** Convert to multi-cluster warehouse with auto-scaling
- **Configuration:** Set min clusters = 1, max clusters = 3-5
- **Scaling Policy:** Standard policy for responsive scaling
- **Auto-Suspend:** Configure appropriate auto-suspend to manage cost

**Common Distractors:**
- Scaling up to XL warehouse (wrong - larger warehouse does not help with concurrency)
- Adding clustering keys to tables (wrong - clustering helps scan performance, not queue times)
- Increasing warehouse timeout (wrong - does not address concurrency limit)
- Disabling result cache (wrong - result cache improves performance, should stay enabled)

### Large Table Scan Performance
**Scenario:** A 10 TB fact table is queried frequently with filters on date and region columns. Query Profile shows 90% of micro-partitions scanned for most queries. Queries take 5-10 minutes on an XL warehouse.

**Solution Pattern:**
- **Diagnosis:** Poor partition pruning - 90% scan means clustering is ineffective
- **Clustering Key:** Add clustering key on (date, region) columns
- **Verification:** Monitor SYSTEM$CLUSTERING_INFORMATION for improvement
- **Metrics:** Clustering depth should approach 1, overlap should decrease
- **Timeline:** Reclustering a 10 TB table may take hours to days

**Common Distractors:**
- Scaling up to 2XL warehouse (wrong - scans same data faster but does not reduce data scanned)
- Creating materialized views (wrong - MVs help with pre-aggregation, not base table scan efficiency)
- Adding more filters to queries (wrong - application change, does not fix underlying data organization)
- Partitioning the table manually (wrong - Snowflake does not support manual partitioning)

### Spilling to Remote Storage
**Scenario:** A data engineering pipeline runs complex multi-join transformations. Query Profile shows significant spilling to both local and remote storage. The warehouse is Medium-sized.

**Solution Pattern:**
- **Diagnosis:** Spilling indicates insufficient memory for the operation
- **Immediate Fix:** Scale up warehouse size (Medium to Large or XL)
- **Long-Term:** Optimize query to reduce intermediate result sets
- **Techniques:** Filter early, reduce columns in SELECT, break into stages
- **Monitoring:** Check Query Profile for spill volumes after changes

**Common Distractors:**
- Adding more clusters (wrong - multi-cluster helps concurrency, not individual query memory)
- Enabling query acceleration (wrong - QAS helps scan-heavy queries, not memory-heavy joins)
- Adding clustering keys (wrong - clustering helps pruning, not join memory usage)
- Increasing result cache duration (wrong - caching does not affect active query memory)

## Data Architecture Decisions

### Streaming vs Batch Ingestion
**Scenario:** An e-commerce platform needs to load order data into Snowflake. Orders need to be queryable within 2 minutes of placement for fraud detection, and historical orders need daily batch reconciliation.

**Solution Pattern:**
- **Real-Time:** Snowpipe Streaming for sub-minute latency fraud detection
- **Batch:** Scheduled COPY INTO with tasks for daily reconciliation
- **Architecture:** Landing table for streaming, separate curated table for batch
- **Dynamic Tables:** Chain dynamic tables for transformation after landing
- **Monitoring:** PIPE_USAGE_HISTORY for Snowpipe, TASK_HISTORY for batch

**Common Distractors:**
- Using only batch loading with 2-minute schedule (wrong - COPY INTO has overhead, hard to guarantee 2-minute SLA)
- Using only Snowpipe for everything (wrong - daily reconciliation is better served by batch)
- Loading directly to final table (wrong - landing table pattern separates ingestion from transformation)
- External tables for real-time access (wrong - external tables have query performance overhead)

### Data Sharing vs Replication
**Scenario:** Two business units within the same company need access to a shared reference dataset. Both units have separate Snowflake accounts in the same region.

**Solution Pattern:**
- **Data Sharing:** Use direct share - same region, no data copying
- **Advantages:** Zero storage cost for consumer, instant availability
- **Access Control:** Secure views limit visible data per consumer
- **No Latency:** Consumer queries run against live data
- **Cost:** Only consumer compute costs for querying

**Common Distractors:**
- Database replication (wrong - unnecessary data copy for same-region accounts)
- ETL pipeline to copy data nightly (wrong - creates stale copies, extra cost)
- External stages with shared S3 bucket (wrong - loses Snowflake governance and performance)
- Reader accounts (wrong - both units already have Snowflake accounts)

## Key Decision Factors

### Architecture Selection Guide
1. **Same region sharing:** Direct share (no copy, live data)
2. **Cross-region access:** Database replication (data copied, independent compute)
3. **Non-Snowflake consumers:** Reader accounts (provider manages compute)
4. **Public data distribution:** Marketplace listing (auto-provisioning)
5. **Disaster recovery:** Failover groups with client redirect
6. **Multi-tenant isolation:** Row access policies (scalable, declarative)
7. **Concurrency issues:** Multi-cluster warehouse (scale out)
8. **Scan performance:** Clustering keys (reduce partitions scanned)
9. **Memory issues:** Scale up warehouse (more memory per node)
10. **Real-time ingestion:** Snowpipe Streaming (sub-second latency)
