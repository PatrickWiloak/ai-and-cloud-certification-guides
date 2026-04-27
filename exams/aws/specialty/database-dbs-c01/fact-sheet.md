# AWS Database Specialty (DBS-C01) - Fact Sheet

> ⚠️ **RETIRED April 29, 2024.** No longer available for new candidates. Replaced by **[AWS Data Engineer - Associate (DEA-C01)](../../associate/data-engineer-dea-c01/fact-sheet.md)** for data-engineering roles. Material preserved as historical reference.

## Quick Reference

**Exam Code:** DBS-C01
**Duration:** 180 minutes
**Questions:** 65 questions
**Passing Score:** 750/1000
**Cost:** $300 USD
**Validity:** 3 years
**Difficulty:** ⭐⭐⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Workload-Specific Database Design | 26% | Choose right database, data modeling |
| Deployment & Migration | 20% | Provisioning, DMS, migration strategies |
| Management & Operations | 18% | Monitoring, maintenance, automation |
| Monitoring & Troubleshooting | 18% | Performance tuning, diagnostics |
| Database Security | 18% | Encryption, IAM, network security |

## AWS Database Services

### Relational Databases

**Amazon RDS**
- Engines: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server
- Multi-AZ: Synchronous replication, automatic failover < 60 sec
- Read Replicas: Up to 15, asynchronous, cross-region
- Automated backups: 0-35 days retention
- Manual snapshots: Unlimited retention
- **[📖 RDS Documentation](https://docs.aws.amazon.com/rds/)** - Main documentation hub
- **[📖 RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)** - Complete user guide
- **[📖 RDS Multi-AZ](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)** - High availability
- **[📖 Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)** - Read scaling
- **[📖 RDS Backup](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html)** - Automated backups
- **[📖 RDS Snapshots](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html)** - Manual snapshots
- **[📖 RDS Proxy](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html)** - Connection pooling

**Amazon Aurora**
- MySQL and PostgreSQL compatible
- 5x MySQL, 3x PostgreSQL performance
- Storage: Auto-scales 10GB to 128TB
- 6 copies across 3 AZs
- Up to 15 read replicas
- Global Database: < 1 sec cross-region replication, 5 secondary regions
- Serverless v2: Scales 0.5-128 ACUs
- **[📖 Aurora Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)** - Complete Aurora guide
- **[📖 Aurora Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.BestPractices.html)** - Performance and optimization
- **[📖 Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)** - Multi-region
- **[📖 Aurora Serverless](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)** - Auto-scaling
- **[📖 Aurora Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Replication.html)** - Read scaling
- **[📖 Aurora Backup](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Backups.html)** - Backup and restore

### NoSQL Databases

**Amazon DynamoDB**
- Key-value and document database
- Single-digit millisecond latency
- Capacity modes: On-demand or provisioned
- Global Tables: Multi-region active-active
- DynamoDB Streams: Change data capture
- DAX: In-memory cache, microsecond latency
- Backup: On-demand and PITR (point-in-time recovery)
- **[📖 DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)** - Main documentation hub
- **[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/)** - Complete developer guide
- **[📖 Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)** - Multi-region replication
- **[📖 DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)** - Change data capture
- **[📖 DAX](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html)** - In-memory acceleration
- **[📖 DynamoDB Backup](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html)** - Backup and PITR
- **[📖 Capacity Modes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadWriteCapacityMode.html)** - On-demand vs provisioned

**Amazon DocumentDB**
- MongoDB 3.6/4.0/5.0 compatible
- Fully managed, scales to millions of requests/sec
- Storage: Auto-scales to 128TB
- 6-way replication across 3 AZs
- **[📖 DocumentDB Documentation](https://docs.aws.amazon.com/documentdb/)** - Complete guide
- **[📖 DocumentDB Developer Guide](https://docs.aws.amazon.com/documentdb/latest/developerguide/)** - Getting started
- **[📖 DocumentDB Clusters](https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-manage.html)** - Cluster management
- **[📖 DocumentDB Backup](https://docs.aws.amazon.com/documentdb/latest/developerguide/backup-restore.html)** - Backup strategies

**Amazon Keyspaces**
- Apache Cassandra compatible
- Serverless, pay-per-request
- Single-digit millisecond latency at scale
- PITR up to 35 days
- **[📖 Keyspaces Documentation](https://docs.aws.amazon.com/keyspaces/)** - Main documentation
- **[📖 Keyspaces Developer Guide](https://docs.aws.amazon.com/keyspaces/latest/devguide/)** - Complete guide
- **[📖 Keyspaces Data Modeling](https://docs.aws.amazon.com/keyspaces/latest/devguide/working-with-tables.html)** - Table design
- **[📖 Keyspaces PITR](https://docs.aws.amazon.com/keyspaces/latest/devguide/PointInTimeRecovery.html)** - Point-in-time recovery

### Specialized Databases

**Amazon Neptune**
- Graph database
- Property graph (Gremlin) and RDF (SPARQL)
- Use cases: Knowledge graphs, fraud detection, social networks
- **[📖 Neptune Documentation](https://docs.aws.amazon.com/neptune/)** - Main documentation hub
- **[📖 Neptune User Guide](https://docs.aws.amazon.com/neptune/latest/userguide/)** - Complete user guide
- **[📖 Neptune Graph Data Model](https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-data-model.html)** - Property graphs and RDF
- **[📖 Gremlin Query Language](https://docs.aws.amazon.com/neptune/latest/userguide/access-graph-gremlin.html)** - Graph traversal queries
- **[📖 SPARQL Query Language](https://docs.aws.amazon.com/neptune/latest/userguide/access-graph-sparql.html)** - RDF queries
- **[📖 Neptune High Availability](https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-db-clusters.html)** - Cluster architecture

**Amazon Timestream**
- Time-series database
- 1,000x faster, 1/10th cost vs relational DBs for time-series
- Automatic tiering: Memory to magnetic storage
- **[📖 Timestream Documentation](https://docs.aws.amazon.com/timestream/)** - Main documentation hub
- **[📖 Timestream Developer Guide](https://docs.aws.amazon.com/timestream/latest/developerguide/)** - Complete developer guide
- **[📖 Timestream Data Model](https://docs.aws.amazon.com/timestream/latest/developerguide/data-modeling.html)** - Time-series design
- **[📖 Timestream Queries](https://docs.aws.amazon.com/timestream/latest/developerguide/code-samples.query.html)** - Query examples
- **[📖 Timestream Scheduled Queries](https://docs.aws.amazon.com/timestream/latest/developerguide/scheduled-queries.html)** - Automated queries

**Amazon QLDB**
- Quantum Ledger Database
- Immutable, cryptographically verifiable transaction log
- Use cases: Compliance, audit trails, supply chain
- **[📖 QLDB Documentation](https://docs.aws.amazon.com/qldb/)** - Main documentation hub
- **[📖 QLDB Developer Guide](https://docs.aws.amazon.com/qldb/latest/developerguide/)** - Complete developer guide
- **[📖 QLDB Journal](https://docs.aws.amazon.com/qldb/latest/developerguide/journal.html)** - Immutable transaction log
- **[📖 QLDB PartiQL](https://docs.aws.amazon.com/qldb/latest/developerguide/ql-reference.html)** - SQL-compatible query language
- **[📖 QLDB Verification](https://docs.aws.amazon.com/qldb/latest/developerguide/verification.html)** - Cryptographic verification

**Amazon MemoryDB for Redis**
- Redis-compatible in-memory database
- Microsecond read, single-digit millisecond write latency
- Durable with Multi-AZ
- **[📖 MemoryDB Documentation](https://docs.aws.amazon.com/memorydb/)** - Main documentation hub
- **[📖 MemoryDB Developer Guide](https://docs.aws.amazon.com/memorydb/latest/devguide/)** - Complete developer guide
- **[📖 MemoryDB Durability](https://docs.aws.amazon.com/memorydb/latest/devguide/data-durability.html)** - Multi-AZ durability
- **[📖 MemoryDB Snapshots](https://docs.aws.amazon.com/memorydb/latest/devguide/snapshots.html)** - Backup and restore
- **[📖 MemoryDB Redis Compatibility](https://docs.aws.amazon.com/memorydb/latest/devguide/redis-compatibility.html)** - Redis commands

### Data Warehousing

**Amazon Redshift**
- Petabyte-scale data warehouse
- Columnar storage, MPP architecture
- RA3 nodes: Managed storage, scales compute/storage independently
- Redshift Spectrum: Query S3 directly
- Concurrency Scaling: Handle burst traffic
- **[📖 Redshift Documentation](https://docs.aws.amazon.com/redshift/)** - Main documentation hub
- **[📖 Redshift Management Guide](https://docs.aws.amazon.com/redshift/latest/mgmt/)** - Cluster management
- **[📖 Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/)** - SQL and optimization
- **[📖 Redshift Clusters](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html)** - Cluster management
- **[📖 Redshift Distribution Styles](https://docs.aws.amazon.com/redshift/latest/dg/c_choosing_dist_sort.html)** - KEY, EVEN, ALL
- **[📖 Redshift Sort Keys](https://docs.aws.amazon.com/redshift/latest/dg/t_Sorting_data.html)** - Query optimization
- **[📖 Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)** - Query S3 data
- **[📖 Redshift Concurrency Scaling](https://docs.aws.amazon.com/redshift/latest/dg/concurrency-scaling.html)** - Handle query spikes
- **[📖 Redshift WLM](https://docs.aws.amazon.com/redshift/latest/dg/cm-c-defining-query-queues.html)** - Workload management
- **[📖 Redshift Snapshots](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html)** - Backup and restore

### Caching

**Amazon ElastiCache**
- **Redis:** Advanced data structures, persistence, backup, Multi-AZ
- **Memcached:** Simple key-value, multi-threaded, no persistence
- **[📖 ElastiCache Documentation](https://docs.aws.amazon.com/elasticache/)** - Main documentation hub
- **[📖 ElastiCache User Guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/)** - Complete user guide
- **[📖 ElastiCache for Redis](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/)** - Redis features
- **[📖 ElastiCache for Memcached](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/)** - Memcached features
- **[📖 Redis Replication](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Replication.html)** - Multi-AZ with failover
- **[📖 Redis Cluster Mode](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Replication.Redis.Groups.html)** - Sharding for scale
- **[📖 ElastiCache Backup](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups.html)** - Snapshots and restore

## Database Migration

**AWS Database Migration Service (DMS)**
- Homogeneous: Oracle → Oracle, MySQL → Aurora MySQL
- Heterogeneous: Oracle → PostgreSQL (requires SCT)
- Continuous replication (CDC - Change Data Capture)
- Zero downtime migration
- **[📖 DMS Documentation](https://docs.aws.amazon.com/dms/)** - Main documentation hub
- **[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/)** - Complete migration guide
- **[📖 DMS Migration Planning](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_BestPractices.html)** - Best practices
- **[📖 DMS Endpoints](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html)** - Source and target configuration
- **[📖 DMS Replication Tasks](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.html)** - Migration tasks
- **[📖 DMS CDC](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html)** - Change data capture
- **[📖 DMS Monitoring](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Monitoring.html)** - Task monitoring

**Schema Conversion Tool (SCT)**
- Converts database schemas
- Oracle/SQL Server → Aurora/RDS PostgreSQL/MySQL
- Assessment report for migration complexity
- **[📖 SCT Documentation](https://docs.aws.amazon.com/SchemaConversionTool/)** - Main documentation hub
- **[📖 SCT User Guide](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/)** - Complete user guide
- **[📖 SCT Installation](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Installing.html)** - Setup guide
- **[📖 SCT Assessment Report](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_AssessmentReport.html)** - Migration complexity
- **[📖 SCT Conversion Rules](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Converting.html)** - Schema conversion

## Database Design Patterns

### Choosing the Right Database

**Relational (RDS/Aurora):**
- ✅ ACID transactions, complex queries, joins, foreign keys
- Use cases: ERP, CRM, e-commerce transactions

**Key-Value (DynamoDB):**
- ✅ Single-digit ms latency, massive scale, simple access patterns
- Use cases: Session store, user profiles, real-time bidding

**Document (DocumentDB):**
- ✅ Flexible schema, nested documents, MongoDB compatibility
- Use cases: Content management, catalogs, user profiles

**Graph (Neptune):**
- ✅ Relationship queries, connected data
- Use cases: Social networks, recommendation engines, fraud detection

**Time-Series (Timestream):**
- ✅ Time-stamped data, high ingestion rate
- Use cases: IoT, DevOps metrics, financial trading

**Ledger (QLDB):**
- ✅ Immutable, cryptographically verifiable
- Use cases: Financial transactions, supply chain, audit logs

## Performance Optimization

### RDS/Aurora
- Read replicas for read scaling
- Provision IOps (io1/io2) for consistent performance
- Parameter groups for tuning
- Enhanced Monitoring for OS metrics
- Performance Insights for query analysis
- Connection pooling with RDS Proxy
- **[📖 RDS Performance Insights](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html)** - Query performance analysis
- **[📖 RDS Enhanced Monitoring](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html)** - OS-level metrics
- **[📖 RDS Parameter Groups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html)** - Database tuning
- **[📖 Aurora Performance](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Performance.html)** - Optimization techniques
- **[📖 RDS Storage Types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html)** - IOPS provisioning

### DynamoDB
- Partition key design: High cardinality, uniform access
- GSI for alternate access patterns
- LSI for sort key variations (must create at table creation)
- DynamoDB Accelerator (DAX) for caching
- Auto Scaling for capacity management
- On-demand for unpredictable workloads
- **[📖 DynamoDB Partition Keys](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-partition-key-design.html)** - Key design best practices
- **[📖 Global Secondary Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html)** - GSI design and usage
- **[📖 Local Secondary Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/LSI.html)** - LSI design and usage
- **[📖 DynamoDB Auto Scaling](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/AutoScaling.html)** - Automatic capacity management
- **[📖 DynamoDB Performance](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)** - Performance optimization

### Redshift
- Distribution styles: KEY, EVEN, ALL
- Sort keys for range queries
- Compression encoding
- Vacuum and analyze regularly
- Workload Management (WLM) for query prioritization
- Result caching
- **[📖 Redshift Table Design](https://docs.aws.amazon.com/redshift/latest/dg/tutorial-tuning-tables.html)** - Distribution and sort keys
- **[📖 Redshift Vacuum](https://docs.aws.amazon.com/redshift/latest/dg/t_Reclaiming_storage_space202.html)** - Reclaim storage
- **[📖 Redshift Analyze](https://docs.aws.amazon.com/redshift/latest/dg/t_Analyzing_tables.html)** - Update statistics
- **[📖 Redshift Compression](https://docs.aws.amazon.com/redshift/latest/dg/t_Compressing_data_on_disk.html)** - Column encoding
- **[📖 Redshift Query Performance](https://docs.aws.amazon.com/redshift/latest/dg/c-optimizing-query-performance.html)** - Optimization techniques

## Security Best Practices

**Encryption**
- At rest: KMS encryption (enable at creation)
- In transit: SSL/TLS for all connections
- Transparent Data Encryption (TDE) for Oracle/SQL Server
- **[📖 RDS Encryption](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html)** - Encryption at rest
- **[📖 DynamoDB Encryption](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html)** - Encryption at rest
- **[📖 KMS Key Management](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Customer managed keys

**Network Security**
- VPC for network isolation
- Security groups for access control
- Private subnets for database instances
- VPC endpoints for S3/DynamoDB access
- **[📖 RDS VPC](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.html)** - VPC configuration
- **[📖 VPC Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)** - Access control
- **[📖 VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)** - Private connectivity

**Access Control**
- IAM database authentication (RDS/Aurora)
- IAM policies for service-level control
- Database users for application access
- Least privilege principle
- Secrets Manager for credential rotation
- **[📖 IAM Database Authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html)** - Token-based auth
- **[📖 DynamoDB IAM](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/authentication-and-access-control.html)** - Fine-grained access
- **[📖 Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)** - Credential rotation
- **[📖 RDS Master User](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.MasterAccounts.html)** - Master account management

**Auditing**
- CloudTrail for API calls
- Database audit logs
- Enhanced Monitoring
- Performance Insights
- CloudWatch Logs
- **[📖 RDS Database Logs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.html)** - Log file access
- **[📖 DynamoDB CloudTrail](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/logging-using-cloudtrail.html)** - API logging
- **[📖 Aurora Audit Logs](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Auditing.html)** - Database activity
- **[📖 CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)** - Log analysis

## Common Scenarios

**Scenario 1: High Write Throughput**
- Solution: DynamoDB with on-demand capacity or Aurora Serverless v2

**Scenario 2: Complex Analytics**
- Solution: Redshift or Athena (query S3)

**Scenario 3: Multi-Region DR**
- Solution: Aurora Global Database or DynamoDB Global Tables

**Scenario 4: Heterogeneous Migration**
- Solution: DMS + SCT with continuous replication

**Scenario 5: Caching Layer**
- Solution: ElastiCache Redis (complex data) or DAX (DynamoDB-specific)

## Essential Documentation

- [📖 AWS Database Blog](https://aws.amazon.com/blogs/database/)
- [📖 Database Migration Guides](https://docs.aws.amazon.com/dms/latest/userguide/)
- [📖 RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)
- [📖 DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)
- [📖 Aurora Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.BestPractices.html)

## Exam Tips

**Keywords:**
- "High availability" → Multi-AZ, Aurora, Global Tables
- "Read-heavy" → Read replicas, DAX, ElastiCache
- "Write-heavy" → DynamoDB, Aurora Serverless
- "Analytics" → Redshift, Athena, Redshift Spectrum
- "Migration" → DMS, SCT, Snowball (large data)
- "Graph data" → Neptune
- "Time-series" → Timestream

**Focus Areas:**
- Database selection for specific workloads
- Performance tuning and optimization
- Migration strategies (DMS, SCT)
- Backup, recovery, and DR
- Security and encryption
- Monitoring with Performance Insights

---

**Pro Tip:** This exam requires deep database expertise. Know when to use each database type, how to optimize performance, and how to migrate databases. Focus on real-world scenarios and trade-offs!
