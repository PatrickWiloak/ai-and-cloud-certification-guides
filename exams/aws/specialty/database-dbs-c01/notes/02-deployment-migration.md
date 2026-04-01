# Deployment and Migration - AWS Database Specialty

## Overview

Deployment and migration covers 20% of the DBS-C01 exam. This domain focuses on database provisioning, migration strategies, and deployment patterns including DMS, SCT, blue-green deployments, and replication topologies.

## AWS Database Migration Service (DMS)

**[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)** - Database migration

### Architecture

- **Replication Instance**: EC2 instance that runs migration tasks
- **Source Endpoint**: Connection to source database
- **Target Endpoint**: Connection to target database
- **Replication Task**: Defines what to migrate and how
- Replication instance should be in the same VPC/region as the target for best performance

### Migration Types

| Type | Description | Use Case |
|------|-------------|----------|
| Full load | Migrate all existing data | One-time migration |
| CDC only | Capture ongoing changes | Keep target in sync |
| Full load + CDC | Initial load then ongoing sync | Zero-downtime migration |

### Change Data Capture (CDC)

- Captures INSERT, UPDATE, DELETE from source after initial load
- Source requirements vary by engine (binlog for MySQL, redo logs for Oracle)
- Transaction ordering maintained per table
- CDC applies changes to target in near real-time
- Can replicate to Kinesis Data Streams or Kafka for streaming analytics

**[📖 CDC with DMS](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html)** - Change data capture

### Key Considerations

- **Instance sizing**: Larger instance for more tables or higher throughput
- **Multi-AZ**: Enable for production migrations (automatic failover)
- **LOB handling**: Full LOB mode (slow, complete) vs Limited LOB mode (fast, truncated)
- **Table mappings**: Selection rules (include/exclude) and transformation rules (rename, add column)
- **Validation**: Enable data validation to compare source and target
- **Pre-migration assessment**: Identify potential issues before migration

**[📖 DMS Best Practices](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_BestPractices.html)** - Migration best practices

### Supported Sources and Targets

**Sources**: Oracle, SQL Server, MySQL, PostgreSQL, MariaDB, SAP ASE, MongoDB, S3, IBM Db2, Azure SQL
**Targets**: All sources + Redshift, DynamoDB, S3, OpenSearch, Kinesis, Kafka, Neptune, DocumentDB, Redis

## AWS Schema Conversion Tool (SCT)

**[📖 SCT User Guide](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html)** - Schema conversion

### Purpose

- Convert database schema from one engine to another
- Generate assessment report of conversion complexity
- Identify manual conversion items (stored procedures, triggers)
- Data extraction agents for large-scale data migration from data warehouses

### Common Conversions

| Source | Target | Complexity |
|--------|--------|-----------|
| Oracle to Aurora PostgreSQL | Medium-High | PL/SQL to PL/pgSQL |
| SQL Server to Aurora MySQL | Medium | T-SQL conversion |
| Oracle to Aurora MySQL | High | PL/SQL to MySQL |
| Teradata to Redshift | Medium | Data warehouse migration |
| Netezza to Redshift | Low-Medium | Similar SQL dialects |

### SCT Assessment Report

- **Green (auto-converted)**: Automatic conversion, no manual work
- **Yellow (needs review)**: Converted but verify behavior
- **Red (manual conversion)**: Cannot auto-convert, requires manual rewrite
- Focus manual effort on red items first

**Exam Tip:** SCT is for heterogeneous migrations (different engines). Homogeneous migrations (same engine) do not need SCT - DMS handles schema directly.

## Blue-Green Deployments

**[📖 RDS Blue-Green Deployments](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html)** - Zero-downtime updates

### RDS Blue-Green Deployments

- Create a staging (green) environment as a copy of production (blue)
- Green environment stays in sync via replication
- Make changes on green: engine upgrades, parameter changes, schema changes
- Switchover promotes green to production with minimal downtime (< 1 minute)
- Automatic rollback if switchover guardrails fail

**Supported engines**: MySQL, MariaDB, PostgreSQL (RDS and Aurora)

### Use Cases

- Major version upgrades
- Schema changes (add columns, indexes)
- Parameter group changes
- Instance class changes
- Testing changes against production data

### Limitations

- Not available for Oracle or SQL Server
- Green environment uses same storage as blue (additional cost)
- Cannot switch back automatically after successful switchover

## Multi-AZ Deployments

### RDS Multi-AZ

**[📖 RDS Multi-AZ](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)** - High availability

**Single standby (standard):**
- Synchronous physical replication to standby in different AZ
- Automatic failover in < 60 seconds
- Standby is not readable - failover only
- DNS endpoint does not change on failover

**Multi-AZ DB cluster (new):**
- One writer + two readable standbys in different AZs
- Transaction log-based replication (faster than physical)
- Readable standbys can serve read traffic
- Failover in < 35 seconds
- Supported for MySQL and PostgreSQL only

### Aurora Multi-AZ

- Up to 15 replicas across multiple AZs
- All replicas are readable (not standby-only)
- Automatic failover to replica with highest priority (tier)
- Failover time: < 30 seconds
- Storage is shared - no replication delay for storage

## Read Replicas

**[📖 RDS Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)** - Read scaling

### Key Facts

- Asynchronous replication (eventual consistency)
- Can be in same AZ, cross-AZ, or cross-region
- Read replicas can be promoted to standalone database
- Cross-region replicas useful for disaster recovery and low-latency reads

### RDS vs Aurora Read Replicas

| Feature | RDS Read Replicas | Aurora Read Replicas |
|---------|-------------------|---------------------|
| Max count | 5 (MySQL/MariaDB/PostgreSQL), 5 (Oracle/SQL Server) | 15 |
| Replication | Asynchronous (binlog/WAL) | Shared storage (sub-10ms lag) |
| Failover target | Manual promotion only | Automatic failover |
| Cross-region | Yes | Yes (or use Global Database) |

### Replication Lag Considerations

- Read replicas have replication lag (seconds to minutes for RDS)
- Aurora replicas typically < 10ms lag due to shared storage
- Monitor `ReplicaLag` CloudWatch metric
- Application must handle eventual consistency

## Aurora Global Database

**[📖 Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)** - Cross-region replication

- Storage-level replication (not logical) - < 1 second cross-region lag
- Primary region: Read-write
- Secondary regions (up to 5): Read-only, each with up to 16 replicas
- **Managed planned failover**: Controlled switchover, RPO = 0
- **Unplanned failover (detach)**: Promote secondary, RPO typically < 1 second
- **Write forwarding**: Secondary region forwards writes to primary (adds latency)

### When to Use

- Global applications needing low-latency reads in multiple regions
- Cross-region disaster recovery with < 1 second RPO
- Read-heavy workloads distributed globally

## Migration Strategies

### The 7 Rs of Migration

| Strategy | Description | Database Relevance |
|----------|-------------|--------------------|
| Rehost | Lift and shift | EC2-based database, same engine |
| Replatform | Lift and optimize | Move to RDS (same engine) |
| Repurchase | Move to SaaS | Not typical for databases |
| Refactor | Re-architect | Change database engine |
| Retire | Decommission | Remove unused databases |
| Retain | Keep as-is | On-premises stays |
| Relocate | VMware migration | VMware-based databases |

### Migration Decision Tree

```
Same database engine?
├── Yes (Homogeneous)
│   ├── Small database (< 100 GB)? -> Native export/import or DMS
│   ├── Large database? -> DMS full load + CDC
│   └── Need zero downtime? -> DMS CDC + cutover
└── No (Heterogeneous)
    ├── Run SCT assessment first
    ├── Convert schema with SCT
    ├── Migrate data with DMS
    └── Manual conversion for red items
```

## Common Exam Patterns

1. **"Zero-downtime migration"** - DMS full load + CDC, then cutover
2. **"Different database engine"** - SCT for schema + DMS for data
3. **"Upgrade major version safely"** - Blue-green deployment
4. **"Cross-region disaster recovery"** - Aurora Global Database
5. **"Reduce failover time for Lambda"** - RDS Proxy
6. **"Read scaling"** - Read replicas (Aurora for best lag)
7. **"Oracle to Aurora"** - SCT assessment + DMS migration
8. **"Large LOB columns"** - DMS Limited LOB mode for speed, Full LOB for completeness
