# SnowPro Advanced - Architect - Fact Sheet

## Quick Reference

**Exam Code:** ARA-C01
**Duration:** 115 minutes
**Questions:** 65 questions
**Passing Score:** 750/1000
**Cost:** $375 USD
**Validity:** 2 years
**Prerequisite:** SnowPro Core (active)
**Difficulty:** ⭐⭐⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Accounts and Security | 25-30% | Multi-account, network security, governance |
| Snowflake Architecture | 25-30% | Micro-partitions, data sharing, replication |
| Performance Optimization | 20-25% | Warehouses, query profiling, clustering |
| Data Movement and Integration | 15-20% | Snowpipe, replication, CDC patterns |

## Multi-Account Strategy

### Snowflake Organizations
- Central management of multiple Snowflake accounts
- Organization admin role (ORGADMIN) for account management
- Create and manage accounts across regions and cloud providers
- Centralized billing and usage monitoring
- **[📖 Organizations](https://docs.snowflake.com/en/user-guide/organizations)** - Organization management

### Account Replication
- Replicate databases, shares, users, roles across accounts
- Cross-region and cross-cloud replication supported
- Replication groups bundle multiple objects for coordinated replication
- Failover groups enable automated failover for business continuity
- Primary and secondary (read-only) database replicas
- **[📖 Replication](https://docs.snowflake.com/en/user-guide/account-replication-intro)** - Replication overview
- **[📖 Failover Groups](https://docs.snowflake.com/en/user-guide/failover-groups)** - Failover configuration

### Data Sharing
| Sharing Method | Use Case | Data Movement |
|---------------|----------|---------------|
| Direct Share | Known Snowflake consumer | None - shared in place |
| Listing (Private) | Select Snowflake consumers | None - shared in place |
| Listing (Public) | Any Snowflake consumer | None - shared in place |
| Reader Account | Non-Snowflake consumers | None - provider manages compute |
| Data Exchange | Curated group sharing | None - shared in place |

- Shared data is read-only for consumers
- Consumers use their own compute (except reader accounts)
- Secure views and secure UDFs protect shared data logic
- **[📖 Data Sharing](https://docs.snowflake.com/en/user-guide/data-sharing-intro)** - Sharing overview
- **[📖 Reader Accounts](https://docs.snowflake.com/en/user-guide/data-sharing-reader-create)** - Reader account setup

## Advanced Security

### Network Security
| Feature | Purpose | Configuration |
|---------|---------|---------------|
| Network Policies | IP allowlist/blocklist | Account or user level |
| AWS PrivateLink | Private AWS connectivity | VPC endpoint to Snowflake |
| Azure Private Link | Private Azure connectivity | Private endpoint to Snowflake |
| GCP Private Service Connect | Private GCP connectivity | Service attachment |
| Internal Stages | Private storage access | Stage with private connectivity |

- **[📖 Network Policies](https://docs.snowflake.com/en/user-guide/network-policies)** - IP-based access control
- **[📖 Private Connectivity](https://docs.snowflake.com/en/user-guide/private-connectivity)** - Private Link setup

### Encryption
- All data encrypted at rest (AES-256) and in transit (TLS 1.2)
- Automatic key rotation every 30 days (Snowflake-managed keys)
- Tri-Secret Secure: composite master key from Snowflake key + customer key
- Customer-managed keys via cloud provider KMS (AWS KMS, Azure Key Vault, GCP KMS)
- Periodic rekeying of encrypted data with new keys
- **[📖 Encryption](https://docs.snowflake.com/en/user-guide/security-encryption)** - Encryption details
- **[📖 Tri-Secret Secure](https://docs.snowflake.com/en/user-guide/security-encryption-manage)** - Customer-managed keys

### Data Governance
```sql
-- Column-level masking policy
CREATE MASKING POLICY ssn_mask AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '***-**-' || RIGHT(val, 4)
  END;

-- Apply masking policy
ALTER TABLE customers MODIFY COLUMN ssn SET MASKING POLICY ssn_mask;

-- Row access policy
CREATE ROW ACCESS POLICY region_policy AS (region_col VARCHAR) RETURNS BOOLEAN ->
  CURRENT_ROLE() = 'ADMIN' OR region_col = CURRENT_SESSION()::VARCHAR;

-- Object tagging
CREATE TAG sensitivity ALLOWED_VALUES 'PII', 'CONFIDENTIAL', 'PUBLIC';
ALTER TABLE customers SET TAG sensitivity = 'PII';
```

- **[📖 Dynamic Data Masking](https://docs.snowflake.com/en/user-guide/security-column-ddm-intro)** - Column masking
- **[📖 Row Access Policies](https://docs.snowflake.com/en/user-guide/security-row-intro)** - Row-level security
- **[📖 Object Tagging](https://docs.snowflake.com/en/user-guide/object-tagging)** - Tag-based governance

## Architecture Deep Dive

### Micro-Partitions
- 50-500 MB compressed, immutable, columnar storage units
- Metadata tracked per partition: min/max, null count, distinct count
- Pruning skips partitions based on metadata during query execution
- Natural clustering follows data ingestion order
- Explicit clustering keys reorganize data for query patterns
- Clustering depth and overlap measure clustering effectiveness
- **[📖 Micro-Partitions](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)** - Partition details
- **[📖 Clustering Keys](https://docs.snowflake.com/en/user-guide/tables-clustering-keys)** - Clustering configuration

### Caching Layers
| Cache | Location | Duration | Scope |
|-------|----------|----------|-------|
| Result Cache | Cloud Services | 24 hours | Per-user, exact query match |
| Local Disk Cache | Warehouse SSD | Warehouse lifetime | Per-warehouse |
| Remote Disk Cache | Cloud Storage | Persistent | Shared across warehouses |

- Result cache serves identical queries without warehouse compute
- Local disk cache stores recently accessed micro-partitions on SSD
- Suspending warehouse clears local disk cache
- **[📖 Query Caching](https://docs.snowflake.com/en/user-guide/querying-persisted-results)** - Result caching behavior

### Snowpark
- Developer framework for data pipelines and applications
- Languages: Python, Java, Scala
- DataFrame API executes on Snowflake virtual warehouses
- Stored procedures and UDFs with Snowpark runtime
- Pushdown execution - code runs where data lives
- Anaconda integration for Python package management
- **[📖 Snowpark Overview](https://docs.snowflake.com/en/developer-guide/snowpark/index)** - Snowpark developer guide
- **[📖 Snowpark Python](https://docs.snowflake.com/en/developer-guide/snowpark/python/index)** - Python API reference

## Performance Optimization

### Virtual Warehouse Sizing
| Workload Type | Recommended Approach |
|--------------|---------------------|
| Simple queries (SELECT, filters) | Smaller warehouse (XS-S) |
| Complex joins and aggregations | Medium-Large warehouse |
| Large data loads (COPY INTO) | Scale up warehouse size |
| High concurrency | Multi-cluster warehouse |
| Mixed workloads | Separate warehouses by workload |

### Multi-Cluster Warehouses
- Scale out for concurrent query handling
- Auto-scaling mode: 1 to N clusters based on demand
- Maximized mode: all clusters always running
- Scaling policy controls cluster start/stop behavior
- Economy policy: favor queuing over spinning up clusters
- Standard policy: favor performance over cost
- **[📖 Multi-Cluster Warehouses](https://docs.snowflake.com/en/user-guide/warehouses-multicluster)** - Scaling configuration

### Query Profile Analysis
- **Operator tree:** Visual execution plan
- **Statistics:** Rows processed, bytes scanned, spilling
- **Pruning metrics:** Partitions scanned vs total partitions
- **Spilling:** Local spill (SSD) and remote spill (cloud storage) indicate undersized warehouse
- **Exploding joins:** Cartesian products from missing join conditions
- **[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Profile analysis guide

### Resource Monitors
```sql
CREATE RESOURCE MONITOR monthly_limit
  WITH CREDIT_QUOTA = 1000
  FREQUENCY = MONTHLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE analytics_wh SET RESOURCE_MONITOR = monthly_limit;
```

- **[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Cost control

## Data Movement

### Snowpipe
- Continuous, serverless data loading
- Triggered by cloud event notifications (S3, Azure Blob, GCS)
- REST API endpoint for manual file submission
- Serverless compute - no warehouse required
- Near-real-time loading (typically 1-2 minute latency)
- **[📖 Snowpipe](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)** - Automated loading

### Snowpipe Streaming
- Low-latency streaming ingestion via API
- Row-level insert without staging files
- Sub-second latency for real-time use cases
- Snowflake Ingest SDK for Java-based clients
- Kafka connector with Snowpipe Streaming mode
- **[📖 Snowpipe Streaming](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-streaming-overview)** - Streaming ingestion

### Dynamic Tables
- Declarative data pipelines without tasks and streams
- Define target state with SQL query
- Snowflake manages incremental refresh automatically
- Target lag controls freshness (e.g., 1 minute, 1 hour)
- Chain dynamic tables for multi-step pipelines
- **[📖 Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)** - Declarative pipelines

## Exam Tips

### High-Value Topics
1. **Multi-account (25-30%):** Organization setup, replication, failover, data sharing
2. **Security (25-30%):** Private Link, Tri-Secret, masking, row access, governance
3. **Architecture (25-30%):** Micro-partitions, clustering, caching, Snowpark
4. **Performance (20-25%):** Warehouse sizing, query profile, resource monitors

### Common Exam Traps
- Confusing account replication with data sharing (replication copies data, sharing does not)
- Thinking reader accounts use consumer compute (provider pays for reader account compute)
- Not knowing Tri-Secret Secure requires Business Critical edition or higher
- Confusing result cache (cloud services, 24h) with local disk cache (warehouse SSD)
- Thinking clustering keys always improve performance (only for large tables with selective queries)
- Not knowing that suspending a warehouse clears its local disk cache
- Confusing dynamic tables with materialized views (dynamic tables support more complex transformations)
- Thinking Snowpipe Streaming requires file staging (it uses row-level API inserts)
