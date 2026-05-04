---
last-updated: 2026-05-03
difficulty: intermediate
---

# Cloud Service Comparison: Database Services

## Quick Reference

This guide provides a comprehensive comparison of database services across AWS, Google Cloud Platform (GCP), and Microsoft Azure. Use this to understand equivalent services when switching cloud providers or studying multiple certifications.

## Relational Databases (Managed SQL)

| Feature | AWS RDS | GCP Cloud SQL | Azure SQL Database |
|---------|---------|---------------|-------------------|
| **Service Name** | RDS (Relational Database Service) | Cloud SQL | Azure SQL Database, Azure Database for MySQL/PostgreSQL |
| **Database Engines** | MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, Aurora | MySQL, PostgreSQL, SQL Server | SQL Server, MySQL, PostgreSQL |
| **Proprietary Engine** | Aurora (MySQL/PostgreSQL compatible) | N/A | N/A |
| **Max Storage** | 64 TiB (most engines), Aurora: 128 TiB | 64 TB (MySQL/PostgreSQL), 10 TB (SQL Server) | 4 TB (General Purpose), 100 TB (Hyperscale) |
| **Read Replicas** | Up to 15 (Aurora), 5 (others) | Up to 10 | Up to 5 (readable secondaries) |
| **Multi-AZ/HA** | Multi-AZ deployments | Regional HA, cross-region replicas | Zone-redundant, geo-replication |
| **Automatic Backups** | 35 days retention | 365 days retention | 7-35 days retention |
| **Point-in-Time Recovery** | Yes (5-minute granularity) | Yes (transaction log backups) | Yes (automated backups) |
| **Encryption** | At rest (KMS), in transit (SSL/TLS) | At rest (Cloud KMS), in transit (SSL/TLS) | At rest (TDE), in transit (SSL/TLS) |
| **Performance Insights** | Yes | Query Insights | Intelligent Performance |
| **Serverless Option** | Aurora Serverless v2 | N/A | Serverless (auto-pause) |
| **Connection Pooling** | RDS Proxy | Cloud SQL Auth Proxy | Built-in connection pooling |
| **Pricing Model** | Instance hours + storage + I/O | Instance hours + storage | DTU or vCore model |

**Key Differences:**
- **AWS Aurora**: Proprietary engine with superior performance (5x MySQL, 3x PostgreSQL), storage auto-scales
- **GCP Cloud SQL**: Simplified management, excellent for standard workloads, best MySQL compatibility
- **Azure SQL Database**: Best SQL Server features, Hyperscale architecture for massive databases

**Documentation:**
- **[📖 AWS RDS Documentation](https://docs.aws.amazon.com/rds/)** - Complete RDS guide
- **[📖 AWS Aurora Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)** - Aurora-specific features
- **[📖 GCP Cloud SQL Documentation](https://cloud.google.com/sql/docs)** - Cloud SQL guide
- **[📖 Azure SQL Database Documentation](https://learn.microsoft.com/en-us/azure/azure-sql/database/)** - SQL Database guide
- **[📖 Azure Database for MySQL Documentation](https://learn.microsoft.com/en-us/azure/mysql/)** - Managed MySQL
- **[📖 Azure Database for PostgreSQL Documentation](https://learn.microsoft.com/en-us/azure/postgresql/)** - Managed PostgreSQL

---

## NoSQL Databases: Key-Value & Document

| Feature | AWS DynamoDB | GCP Firestore | GCP Bigtable | Azure Cosmos DB |
|---------|--------------|---------------|--------------|-----------------|
| **Type** | Key-Value, Document | Document | Wide-column | Multi-model (document, key-value, graph, column-family) |
| **Data Model** | JSON documents | Hierarchical documents | Column families | JSON documents, key-value, graph |
| **Consistency** | Eventual, Strong | Strong | Eventual | Tunable (5 levels) |
| **Max Item Size** | 400 KB | 1 MB | 10 MB per cell | 2 MB |
| **Transactions** | ACID transactions | ACID transactions | Single-row transactions | ACID transactions |
| **Indexing** | Primary key + secondary indexes | Automatic indexing | N/A (row key only) | Automatic indexing |
| **Scaling** | Auto-scaling, On-Demand | Automatic | Manual node scaling | Automatic partitioning |
| **Capacity Modes** | Provisioned, On-Demand | N/A | Provisioned nodes | Provisioned, Serverless, Autoscale |
| **Global Distribution** | Global Tables | Multi-region | Multi-region replication | Turnkey global distribution (99.999% SLA) |
| **Query Language** | PartiQL (SQL-like) | Firestore queries | N/A (API-based) | SQL, MongoDB, Gremlin, Cassandra |
| **Real-time** | DynamoDB Streams | Real-time listeners | N/A | Change Feed |
| **TTL** | Item-level TTL | N/A | Column-level TTL | Document-level TTL |
| **Pricing** | Read/Write units or On-Demand | Document reads/writes/deletes | Node hours + storage | RU/s (Request Units) |
| **Best For** | High-scale key-value, gaming, IoT | Mobile/web apps, real-time sync | Analytics, time-series, IoT | Global apps, multi-model needs |

**Key Differences:**
- **DynamoDB**: Fastest key-value store, complex pricing, excellent for high-throughput apps
- **Firestore**: Best mobile/web SDK integration, real-time synchronization, hierarchical data
- **Bigtable**: Analytical workloads, petabyte-scale, based on Google's internal Bigtable
- **Cosmos DB**: Most flexible (multi-model, multi-API), global distribution leader, complex pricing

**Documentation:**
- **[📖 AWS DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)** - DynamoDB guide
- **[📖 GCP Firestore Documentation](https://cloud.google.com/firestore/docs)** - Firestore guide
- **[📖 GCP Bigtable Documentation](https://cloud.google.com/bigtable/docs)** - Bigtable guide
- **[📖 Azure Cosmos DB Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/)** - Cosmos DB guide
- **[📖 Cosmos DB API for MongoDB Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/mongodb/)** - MongoDB API

---

## Data Warehouses (Analytical Databases)

| Feature | AWS Redshift | GCP BigQuery | Azure Synapse Analytics |
|---------|--------------|--------------|------------------------|
| **Architecture** | Cluster-based (nodes) | Serverless | Dedicated SQL pools + Serverless |
| **Storage/Compute** | Coupled (RA3: decoupled) | Fully decoupled | Decoupled |
| **Scaling** | Resize cluster (minutes-hours) | Automatic, instant | Scale compute independently |
| **Query Performance** | Very fast (optimized clusters) | Extremely fast (distributed) | Very fast (MPP engine) |
| **Concurrency** | Concurrency Scaling | Automatic (virtually unlimited) | Workload management |
| **Data Format** | Columnar (compressed) | Columnar (Capacitor format) | Columnar (optimized) |
| **Max Storage** | 2 PB (RA3.16xlarge) | Petabytes+ (virtually unlimited) | 240 TB per SQL pool |
| **Pricing Model** | Node hours + storage (RA3) | Storage + query processing (slots) | DWU (Data Warehouse Units) or serverless |
| **Serverless** | Redshift Serverless | Native serverless | Synapse Serverless SQL |
| **External Tables** | Redshift Spectrum (S3) | External tables (GCS, BigLake) | External tables (ADLS, Blob) |
| **ML Integration** | SageMaker integration | BigQuery ML (built-in) | Azure ML integration |
| **Streaming Ingestion** | Kinesis Data Firehose | BigQuery Storage Write API | Azure Stream Analytics |
| **Materialized Views** | Yes | Yes | Yes |
| **Result Caching** | Yes | Yes (24 hours) | Yes |
| **Best For** | Enterprise DW, complex ETL | Ad-hoc analysis, big data, ML | Hybrid (DW + big data analytics) |

**Key Differences:**
- **Redshift**: Traditional cluster model, excellent for predictable workloads, complex tuning
- **BigQuery**: Truly serverless, fastest for ad-hoc queries, pay-per-query model, built-in ML
- **Synapse Analytics**: Unified analytics platform (DW + Spark + Data Explorer), best Azure integration

**Documentation:**
- **[📖 AWS Redshift Documentation](https://docs.aws.amazon.com/redshift/)** - Redshift guide
- **[📖 GCP BigQuery Documentation](https://cloud.google.com/bigquery/docs)** - BigQuery guide
- **[📖 Azure Synapse Analytics Documentation](https://learn.microsoft.com/en-us/azure/synapse-analytics/)** - Synapse guide

---

## In-Memory Databases & Caching

| Feature | AWS ElastiCache | GCP Memorystore | Azure Cache for Redis |
|---------|-----------------|-----------------|----------------------|
| **Engines** | Redis, Memcached | Redis, Memcached | Redis (including Enterprise) |
| **Redis Versions** | Redis 6.x, 7.x | Redis 6.x, 7.x | Redis 6.x, 7.x + Redis Enterprise |
| **Max Memory** | 317 GB (r6g.16xlarge) | 300 GB (M5) | 120 GB (Premium), 13 TB (Enterprise) |
| **Clustering** | Redis Cluster mode | Redis Cluster | Redis Cluster (Premium+) |
| **High Availability** | Multi-AZ with auto-failover | Standard Tier (HA replica) | Standard/Premium (replica), Enterprise (Active-Active) |
| **Persistence** | Redis AOF, RDB snapshots | Redis RDB snapshots | AOF, RDB (Premium+) |
| **Replication** | Up to 5 read replicas | 1 replica (Standard Tier) | Up to 3 replicas |
| **Backup/Restore** | Manual/automated snapshots | Automated backups | Export/Import, Scheduled backups |
| **Security** | VPC, encryption at rest/transit | VPC, TLS, CMEK | VNet, TLS, CMK |
| **Scaling** | Vertical (resize), Horizontal (sharding) | Vertical (tier change) | Vertical, Horizontal (clustering) |
| **Pricing Model** | Node hours | Instance hours + network | Instance hours (Basic/Standard/Premium/Enterprise) |

**Key Differences:**
- **ElastiCache**: Mature service, both Redis and Memcached, good for AWS-native apps
- **Memorystore**: Simpler management, automatic failover in Standard tier, GCP integration
- **Azure Cache for Redis**: Redis Enterprise option (active-active geo-replication, 99.999% SLA)

**Documentation:**
- **[📖 AWS ElastiCache Documentation](https://docs.aws.amazon.com/elasticache/)** - ElastiCache guide
- **[📖 ElastiCache for Redis Documentation](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/)** - Redis-specific
- **[📖 GCP Memorystore Documentation](https://cloud.google.com/memorystore/docs)** - Memorystore guide
- **[📖 Azure Cache for Redis Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/)** - Redis cache guide

---

## Graph Databases

| Feature | AWS Neptune | GCP (N/A) | Azure Cosmos DB (Gremlin API) |
|---------|-------------|-----------|-------------------------------|
| **Graph Models** | Property Graph (Gremlin), RDF (SPARQL) | N/A | Property Graph (Gremlin) |
| **Query Languages** | Gremlin, SPARQL | N/A | Gremlin |
| **Max Storage** | 128 TB | N/A | Unlimited (partitioned) |
| **Read Replicas** | Up to 15 | N/A | Global distribution |
| **High Availability** | Multi-AZ | N/A | 99.999% SLA (multi-region) |
| **Transactions** | ACID | N/A | ACID |
| **Backup** | Continuous (35 days) | N/A | Automatic backups |
| **Streams** | Neptune Streams | N/A | Change Feed |
| **ML Integration** | Neptune ML (SageMaker) | N/A | Azure ML integration |
| **Best For** | Knowledge graphs, fraud detection, social networks | N/A | Global graph applications |

**GCP Alternative**: Use **Neo4j on GKE** or third-party graph databases.

**Key Differences:**
- **Neptune**: Purpose-built graph DB, supports both property graph and RDF, excellent performance
- **Cosmos DB Gremlin**: Multi-model flexibility, global distribution, but can be expensive

**Documentation:**
- **[📖 AWS Neptune Documentation](https://docs.aws.amazon.com/neptune/)** - Neptune guide
- **[📖 Neptune Gremlin Documentation](https://docs.aws.amazon.com/neptune/latest/userguide/gremlin.html)** - Gremlin support
- **[📖 Azure Cosmos DB Gremlin API Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/gremlin/)** - Gremlin API guide

---

## Time-Series Databases

| Feature | AWS Timestream | GCP (N/A) | Azure Data Explorer (ADX) |
|---------|----------------|-----------|--------------------------|
| **Purpose** | Time-series analytics | N/A | Fast data exploration, time-series |
| **Data Retention** | Memory store (hours-days) + Magnetic store (years) | N/A | Hot cache + Cold storage |
| **Ingestion Rate** | Millions of events/sec | N/A | Millions of events/sec |
| **Query Language** | SQL-like | N/A | KQL (Kusto Query Language) |
| **Compression** | Automatic (high ratio) | N/A | Automatic compression |
| **Scaling** | Serverless, automatic | N/A | Auto-scale clusters |
| **Data Tiering** | Automatic (memory to magnetic) | N/A | Hot/Cold tiering |
| **Pricing** | Writes + queries + storage | N/A | Compute + storage |
| **Best For** | IoT, DevOps metrics | N/A | Log analytics, telemetry, IoT |

**GCP Alternative**: Use **Bigtable** for time-series workloads or **InfluxDB on GKE**.

**AWS Alternative for ADX**: Combine **Timestream + Athena + QuickSight** or use **OpenSearch Service**.

**Key Differences:**
- **Timestream**: Purpose-built for time-series, serverless, automatic data lifecycle management
- **Azure Data Explorer**: More versatile (logs + time-series), powerful KQL language, Synapse integration

**Documentation:**
- **[📖 AWS Timestream Documentation](https://docs.aws.amazon.com/timestream/)** - Timestream guide
- **[📖 Azure Data Explorer Documentation](https://learn.microsoft.com/en-us/azure/data-explorer/)** - ADX guide

---

## Database Migration Services

| Feature | AWS DMS | GCP Database Migration Service | Azure Database Migration Service |
|---------|---------|-------------------------------|----------------------------------|
| **Full Name** | Database Migration Service | Database Migration Service | Azure Database Migration Service |
| **Source Databases** | Oracle, SQL Server, MySQL, PostgreSQL, MongoDB, SAP, DB2 | MySQL, PostgreSQL, SQL Server, Oracle | SQL Server, MySQL, PostgreSQL, MongoDB, Oracle |
| **Target Databases** | RDS, Aurora, DynamoDB, Redshift, S3 | Cloud SQL, AlloyDB | Azure SQL, MySQL, PostgreSQL, Cosmos DB |
| **Migration Types** | Full load, CDC (ongoing replication), Full+CDC | One-time, Continuous | Online, Offline |
| **Schema Conversion** | AWS SCT (Schema Conversion Tool) | N/A (manual) | Database Migration Assistant |
| **Homogeneous** | Yes (e.g., MySQL to MySQL) | Yes | Yes |
| **Heterogeneous** | Yes (e.g., Oracle to Aurora) | Limited | Yes (e.g., SQL Server to Azure SQL) |
| **Minimal Downtime** | Yes (CDC) | Yes (continuous migration) | Yes (online migration) |
| **Validation** | Data validation | N/A | Built-in assessment |
| **Pricing** | Instance hours + storage | Free (serverless) | Free service (pay for target DB) |

**Key Differences:**
- **AWS DMS**: Most mature, supports widest range of sources/targets, complex heterogeneous migrations
- **GCP DMS**: Simplified, free, best for Cloud SQL migrations, limited heterogeneous support
- **Azure DMS**: Free service, excellent for SQL Server migrations, integrated assessment tools

**Documentation:**
- **[📖 AWS DMS Documentation](https://docs.aws.amazon.com/dms/)** - Database Migration Service
- **[📖 AWS SCT Documentation](https://docs.aws.amazon.com/SchemaConversionTool/)** - Schema Conversion Tool
- **[📖 GCP Database Migration Service Documentation](https://cloud.google.com/database-migration/docs)** - DMS guide
- **[📖 Azure Database Migration Service Documentation](https://learn.microsoft.com/en-us/azure/dms/)** - DMS guide

---

## High Availability & Disaster Recovery

### Relational Databases

| Feature | AWS RDS/Aurora | GCP Cloud SQL | Azure SQL Database |
|---------|---------------|---------------|-------------------|
| **Multi-AZ/Zone** | Multi-AZ (synchronous standby) | Regional HA (automatic) | Zone-redundant |
| **Failover Time** | 60-120 seconds (RDS), 30-60 seconds (Aurora) | Automatic (seconds) | Automatic (seconds) |
| **Cross-Region** | Read replicas, Aurora Global | Cross-region replicas | Geo-replication, Failover groups |
| **RPO (Recovery Point)** | Near zero (sync replication) | Near zero | Near zero (sync geo-replication) |
| **RTO (Recovery Time)** | 60-120 seconds | < 60 seconds | < 30 seconds |
| **Backup Retention** | 1-35 days | 1-365 days | 7-35 days |
| **PITR** | 5-minute granularity | Transaction log-based | Automated backups |

### NoSQL Databases

| Feature | AWS DynamoDB | GCP Firestore/Bigtable | Azure Cosmos DB |
|---------|--------------|----------------------|-----------------|
| **Multi-Region** | Global Tables | Multi-region | Global distribution (turnkey) |
| **Consistency** | Eventual or Strong | Strong (Firestore) | 5 consistency levels |
| **Automatic Failover** | Yes | Yes | Yes (automatic) |
| **RPO** | Near zero | Near zero | Near zero |
| **RTO** | Automatic | Automatic | < 1 minute |
| **Backup** | On-demand, PITR (35 days) | Backups (Firestore), backups (Bigtable) | Continuous backups (30 days) |

**Documentation:**
- **[📖 RDS Multi-AZ Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)** - Multi-AZ deployments
- **[📖 Aurora Global Database Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)** - Global Aurora
- **[📖 Cloud SQL High Availability Documentation](https://cloud.google.com/sql/docs/mysql/high-availability)** - HA configuration
- **[📖 Azure SQL Database High Availability Documentation](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla)** - HA architecture

---

## Pricing Comparison (Approximate)

### Relational Databases (General Purpose, 2 vCPU, 8 GB RAM, 100 GB Storage)

| Provider | Service | Monthly Cost (Approx) |
|----------|---------|----------------------|
| **AWS** | RDS MySQL (Multi-AZ) | ~$250 |
| **AWS** | Aurora MySQL | ~$300 (higher performance) |
| **GCP** | Cloud SQL MySQL (HA) | ~$220 |
| **Azure** | Azure SQL Database (4 vCores) | ~$500 (vCore model) |
| **Azure** | Azure Database for MySQL | ~$240 |

### NoSQL Databases (1000 RU/s or equivalent)

| Provider | Service | Monthly Cost (Approx) |
|----------|---------|----------------------|
| **AWS** | DynamoDB (On-Demand) | ~$350 (1M reads, 1M writes) |
| **AWS** | DynamoDB (Provisioned) | ~$150 |
| **GCP** | Firestore | ~$300 (1M reads, 1M writes) |
| **Azure** | Cosmos DB (1000 RU/s) | ~$175 |

### Data Warehouses (1 TB Storage, 10 hours query/day)

| Provider | Service | Monthly Cost (Approx) |
|----------|---------|----------------------|
| **AWS** | Redshift (dc2.large, 1 node) | ~$180 + storage |
| **GCP** | BigQuery (on-demand) | ~$200 (queries) + $20 (storage) |
| **Azure** | Synapse Analytics (DW100c) | ~$145 + storage |

*Note: Prices vary by region and usage patterns. Always use official pricing calculators.*

**Pricing Calculators:**
- **[📖 AWS Pricing Calculator](https://calculator.aws/)** - AWS cost estimates
- **[📖 GCP Pricing Calculator](https://cloud.google.com/products/calculator)** - GCP cost estimates
- **[📖 Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)** - Azure cost estimates

---

## CLI Command Comparison

### Create a Relational Database

**AWS RDS:**
```bash
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password MyPassword123 \
  --allocated-storage 20 \
  --backup-retention-period 7 \
  --multi-az
```

**GCP Cloud SQL:**
```bash
gcloud sql instances create mydb \
  --database-version=MYSQL_8_0 \
  --tier=db-n1-standard-1 \
  --region=us-central1 \
  --root-password=MyPassword123 \
  --backup \
  --availability-type=REGIONAL
```

**Azure SQL Database:**
```bash
az sql server create \
  --name myserver \
  --resource-group myResourceGroup \
  --location eastus \
  --admin-user myadmin \
  --admin-password MyPassword123

az sql db create \
  --resource-group myResourceGroup \
  --server myserver \
  --name mydb \
  --service-objective S0
```

### Create a NoSQL Database

**AWS DynamoDB:**
```bash
aws dynamodb create-table \
  --table-name Users \
  --attribute-definitions \
    AttributeName=UserId,AttributeType=S \
  --key-schema \
    AttributeName=UserId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

**GCP Firestore:**
```bash
# Firestore database is created via console or automatically
# Create a document via API:
gcloud firestore databases create \
  --location=us-central \
  --type=firestore-native
```

**Azure Cosmos DB:**
```bash
az cosmosdb create \
  --name mycosmosdb \
  --resource-group myResourceGroup \
  --default-consistency-level Eventual \
  --locations regionName=eastus failoverPriority=0

az cosmosdb sql database create \
  --account-name mycosmosdb \
  --resource-group myResourceGroup \
  --name mydb
```

### Create a Data Warehouse

**AWS Redshift:**
```bash
aws redshift create-cluster \
  --cluster-identifier mycluster \
  --node-type dc2.large \
  --number-of-nodes 2 \
  --master-username admin \
  --master-user-password MyPassword123
```

**GCP BigQuery:**
```bash
# BigQuery is serverless, create dataset:
bq mk --dataset --location=US my_dataset

# Create table:
bq mk --table my_dataset.my_table schema.json
```

**Azure Synapse Analytics:**
```bash
az synapse workspace create \
  --name myworkspace \
  --resource-group myResourceGroup \
  --storage-account mystorageaccount \
  --file-system myfilesystem \
  --sql-admin-login-user sqladmin \
  --sql-admin-login-password MyPassword123 \
  --location eastus

az synapse sql pool create \
  --name mydatawarehouse \
  --workspace-name myworkspace \
  --resource-group myResourceGroup \
  --performance-level DW100c
```

### Create a Cache Instance

**AWS ElastiCache (Redis):**
```bash
aws elasticache create-cache-cluster \
  --cache-cluster-id mycache \
  --engine redis \
  --cache-node-type cache.t3.micro \
  --num-cache-nodes 1
```

**GCP Memorystore (Redis):**
```bash
gcloud redis instances create mycache \
  --size=1 \
  --region=us-central1 \
  --tier=basic
```

**Azure Cache for Redis:**
```bash
az redis create \
  --name mycache \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Basic \
  --vm-size c0
```

---

## Decision Tree: Which Database Service?

### Relational Database (SQL)

**Use AWS Aurora when:**
- ✅ Need maximum performance (5x MySQL, 3x PostgreSQL)
- ✅ Require global database with < 1 second replication
- ✅ Auto-scaling storage needs
- ✅ Heavy read workloads (15 read replicas)
- ❌ Budget-constrained (more expensive than standard RDS)

**Use GCP Cloud SQL when:**
- ✅ Standard MySQL/PostgreSQL workloads
- ✅ Want simplified management
- ✅ Need automatic storage expansion
- ✅ Prioritize ease of use over maximum performance
- ❌ Need proprietary database (Oracle, SQL Server)

**Use Azure SQL Database when:**
- ✅ SQL Server applications
- ✅ Need Hyperscale architecture (100 TB+)
- ✅ Want serverless with auto-pause
- ✅ Azure-native applications
- ❌ Need MySQL/PostgreSQL (use Azure Database for MySQL/PostgreSQL instead)

### NoSQL Database

**Use DynamoDB when:**
- ✅ Extreme scale (millions of requests/sec)
- ✅ Key-value or simple document needs
- ✅ Predictable access patterns
- ✅ Gaming, IoT, or mobile backends
- ❌ Complex queries or joins needed
- ❌ Flexible data exploration

**Use Firestore when:**
- ✅ Mobile or web applications
- ✅ Real-time synchronization needed
- ✅ Hierarchical data structures
- ✅ Offline support required
- ❌ Large analytical queries
- ❌ Need for complex indexing

**Use Bigtable when:**
- ✅ Petabyte-scale data
- ✅ Time-series or IoT data
- ✅ Low-latency, high-throughput needs
- ✅ Analytics and machine learning
- ❌ Transactional workloads
- ❌ Small datasets (< 1 TB)

**Use Cosmos DB when:**
- ✅ Global distribution critical (99.999% SLA)
- ✅ Multi-model needs (document, graph, key-value)
- ✅ Need multiple API compatibility (MongoDB, Cassandra, Gremlin)
- ✅ Tunable consistency required
- ❌ Budget-constrained (can be expensive)

### Data Warehouse

**Use Redshift when:**
- ✅ Complex ETL pipelines
- ✅ Predictable workloads
- ✅ Need fine-grained control (tuning, vacuuming)
- ✅ Large data (multi-petabyte)
- ❌ Unpredictable query patterns
- ❌ Want zero administration

**Use BigQuery when:**
- ✅ Ad-hoc analysis and exploration
- ✅ Want serverless (no clusters to manage)
- ✅ Need built-in ML capabilities
- ✅ Sporadic usage patterns
- ✅ Massive datasets with fast queries
- ❌ Need full SQL Server compatibility

**Use Synapse Analytics when:**
- ✅ Unified analytics (DW + Spark + Data Explorer)
- ✅ Azure-native data pipelines
- ✅ Need both serverless and dedicated options
- ✅ Power BI integration
- ❌ Need BigQuery-like simplicity

### Caching

**Use ElastiCache when:**
- ✅ AWS-native applications
- ✅ Need both Redis and Memcached
- ✅ Mature service with extensive features
- ❌ Need Redis Enterprise features

**Use Memorystore when:**
- ✅ GCP-native applications
- ✅ Want simplified management
- ✅ Standard Redis/Memcached needs
- ❌ Need advanced Redis features

**Use Azure Cache for Redis when:**
- ✅ Azure-native applications
- ✅ Need Redis Enterprise (active-active geo-replication)
- ✅ Require 99.999% SLA
- ✅ Large cache sizes (13 TB)
- ❌ Need Memcached

### Graph Database

**Use Neptune when:**
- ✅ Knowledge graphs
- ✅ Fraud detection patterns
- ✅ Social networks
- ✅ Need both property graph (Gremlin) and RDF (SPARQL)
- ✅ ML-powered predictions (Neptune ML)

**Use Cosmos DB Gremlin API when:**
- ✅ Global graph distribution
- ✅ Azure-native applications
- ✅ Need multi-model capabilities
- ❌ Budget-constrained

### Time-Series Database

**Use Timestream when:**
- ✅ IoT applications
- ✅ DevOps monitoring
- ✅ Application metrics
- ✅ Want serverless time-series
- ✅ Automatic data lifecycle management

**Use Azure Data Explorer when:**
- ✅ Log analytics
- ✅ Telemetry data
- ✅ Need powerful query language (KQL)
- ✅ Azure Monitor integration
- ✅ Combined time-series and log analysis

**Use Bigtable (GCP) when:**
- ✅ Need time-series on GCP
- ✅ Petabyte-scale time-series
- ✅ Integration with Dataflow/Dataproc

---

## Key Takeaways

### AWS Strengths
- ✅ Most comprehensive database portfolio (13+ database services)
- ✅ Aurora: Best-performing relational database
- ✅ DynamoDB: Proven at massive scale (Amazon.com)
- ✅ Redshift: Mature data warehouse with extensive features
- ✅ Neptune: Only major provider with purpose-built graph database
- ✅ Database Migration Service: Most mature migration tools

### GCP Strengths
- ✅ BigQuery: Best serverless data warehouse
- ✅ Bigtable: Proven at Google scale (powers Search, Maps, Gmail)
- ✅ Firestore: Best real-time database for mobile/web
- ✅ Cloud SQL: Simplified relational database management
- ✅ AlloyDB: New PostgreSQL-compatible DB with extreme performance
- ✅ Free Database Migration Service

### Azure Strengths
- ✅ Cosmos DB: Best globally distributed multi-model database
- ✅ Azure SQL Database: Best SQL Server features and Hyperscale
- ✅ Synapse Analytics: Unified analytics platform
- ✅ Azure Cache for Redis: Redis Enterprise with 99.999% SLA
- ✅ Azure Data Explorer: Powerful log and time-series analytics
- ✅ Hybrid scenarios: Azure Arc for on-premises databases

---

## Common Patterns & Best Practices

### Multi-Database Architectures

**Polyglot Persistence Pattern:**
```
Application Layer
├── User Profiles → DynamoDB/Cosmos DB (fast key-value)
├── Product Catalog → RDS/Cloud SQL (relational)
├── Shopping Cart → ElastiCache/Memorystore (in-memory)
├── Order History → Redshift/BigQuery (analytics)
└── Recommendations → Neptune/Cosmos DB Gremlin (graph)
```

### High Availability Configuration

**AWS Multi-Region Setup:**
```
Primary Region (us-east-1)
├── Aurora Global Database (primary)
├── DynamoDB Global Tables
└── ElastiCache (cluster mode)

Secondary Region (us-west-2)
├── Aurora Global Database (read replica, < 1s lag)
├── DynamoDB Global Tables (active-active)
└── ElastiCache (independent cluster)
```

**GCP Multi-Region Setup:**
```
Primary Region (us-central1)
├── Cloud SQL (primary with cross-region replicas)
├── Firestore (multi-region)
└── Memorystore (regional)

Secondary Region (us-east1)
├── Cloud SQL (read replica)
├── Firestore (automatic replication)
└── Memorystore (independent instance)
```

**Azure Multi-Region Setup:**
```
Primary Region (East US)
├── Azure SQL Database (geo-replication)
├── Cosmos DB (global distribution)
└── Azure Cache for Redis (geo-replication)

Secondary Region (West US)
├── Azure SQL Database (readable secondary)
├── Cosmos DB (automatic replication)
└── Azure Cache for Redis (replica)
```

### Backup Strategies

**3-2-1 Backup Rule (adapted for cloud):**
- **3 copies**: Primary + automated backups + manual snapshots
- **2 storage types**: Database storage + object storage (S3/GCS/Blob)
- **1 off-site**: Cross-region backups

**Example AWS Backup Strategy:**
```
RDS Database
├── Automated Backups (35 days, same region)
├── Manual Snapshots (copied to second region)
└── Export to S3 (long-term retention, lifecycle to Glacier)
```

### Security Best Practices

**Defense in Depth:**
```
Network Layer
├── Private subnets/VPCs
├── Security groups/firewall rules
└── VPN/Private connectivity

Identity & Access
├── IAM roles (least privilege)
├── Service accounts
└── Secrets management

Data Protection
├── Encryption at rest (KMS/Cloud KMS/Key Vault)
├── Encryption in transit (TLS/SSL)
└── Field-level encryption (sensitive data)

Monitoring
├── Database activity monitoring
├── Query performance monitoring
└── Anomaly detection
```

---

## Migration Strategies

### Database Migration Approaches

**1. Lift and Shift (Rehost)**
- Migrate database as-is to managed service
- Example: On-premises MySQL → RDS MySQL
- **Tools**: AWS DMS, GCP DMS, Azure DMS
- **Downtime**: Minimal (with CDC)

**2. Re-platform**
- Migrate to cloud-native equivalent
- Example: On-premises PostgreSQL → Aurora PostgreSQL
- **Tools**: AWS DMS + SCT, native tools
- **Benefits**: Better performance, lower costs

**3. Re-architect**
- Change database type
- Example: Oracle → DynamoDB (NoSQL)
- **Tools**: AWS SCT, custom migration scripts
- **Effort**: High, requires application changes

**4. Hybrid Migration**
- Keep some data on-premises, some in cloud
- **Tools**: AWS Outposts, Azure Arc, Anthos

### Migration Phases

```
Phase 1: Assessment (1-2 weeks)
├── Inventory databases
├── Analyze workloads
├── Estimate costs
└── Plan migration strategy

Phase 2: Proof of Concept (2-4 weeks)
├── Migrate test database
├── Performance testing
├── Compatibility testing
└── Validate backup/restore

Phase 3: Data Migration (varies)
├── Schema migration
├── Full data load
├── Enable CDC (change data capture)
└── Validation

Phase 4: Cutover (1-4 hours)
├── Sync final changes
├── Switch application endpoints
├── Monitor performance
└── Decommission old database
```

---

## Performance Optimization Tips

### Relational Databases

**Query Optimization:**
- Use **EXPLAIN/EXPLAIN ANALYZE** to understand query plans
- Create appropriate **indexes** (avoid over-indexing)
- Use **connection pooling** (RDS Proxy, Cloud SQL Auth Proxy)
- Enable **query caching** where available
- Partition large tables by time or key range

**AWS RDS/Aurora:**
- Use **Performance Insights** to identify slow queries
- Enable **Enhanced Monitoring**
- Consider **Aurora Serverless v2** for variable workloads
- Use **read replicas** for read-heavy workloads

**GCP Cloud SQL:**
- Enable **Query Insights**
- Use **Cloud SQL Auth Proxy** for secure connections
- Configure **read replicas** for scaling reads
- Adjust **memory and CPU** based on workload

**Azure SQL Database:**
- Use **Intelligent Performance** features
- Enable **Automatic Tuning**
- Consider **Hyperscale** tier for large databases
- Use **Query Store** for performance tracking

### NoSQL Databases

**DynamoDB:**
- Design for **uniform data access** (avoid hot partitions)
- Use **Global Secondary Indexes** efficiently
- Enable **DynamoDB Accelerator (DAX)** for microsecond latency
- Consider **On-Demand** mode for unpredictable traffic

**Cosmos DB:**
- Choose appropriate **consistency level** (tradeoff: consistency vs. latency)
- Design **partition keys** carefully (avoid hot partitions)
- Use **Time to Live (TTL)** to automatically expire data
- Monitor **Request Units (RUs)** consumption

**Firestore:**
- Design **shallow document structure** (avoid deeply nested)
- Use **composite indexes** for complex queries
- Implement **pagination** (avoid fetching large result sets)
- Leverage **real-time listeners** efficiently

### Data Warehouses

**General Optimization:**
- Use **columnar storage** and **compression**
- Implement **partitioning** (by date is common)
- Create **materialized views** for frequent queries
- Use **result caching**

**Redshift:**
- Choose appropriate **distribution style** (KEY, EVEN, ALL)
- Define **sort keys** for query patterns
- Run **VACUUM** and **ANALYZE** regularly
- Use **Redshift Spectrum** for cold data in S3

**BigQuery:**
- **Partition** tables by date/timestamp
- **Cluster** tables by frequently filtered columns
- Use **approximate aggregation** functions where possible
- Leverage **cached results** (24-hour cache)

**Synapse Analytics:**
- Choose appropriate **distribution type** (hash, round-robin, replicated)
- Use **columnstore indexes**
- Implement **statistics** for query optimization
- Scale **compute** independently from storage

---

**Related Guides:**
- [Compute Service Comparison](./service-comparison-compute.md)
- [Storage Service Comparison](./service-comparison-storage.md)
- [Networking Service Comparison](./service-comparison-networking.md)
- [Serverless Service Comparison](./service-comparison-serverless.md)
