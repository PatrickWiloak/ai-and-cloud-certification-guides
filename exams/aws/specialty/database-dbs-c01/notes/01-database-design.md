# Workload-Specific Database Design - AWS Database Specialty

## Overview

Workload-specific database design covers 26% of the DBS-C01 exam - the largest domain. This domain focuses on choosing the right database service for specific use cases and understanding the design considerations for each.

**[📖 AWS Database Services](https://aws.amazon.com/products/databases/)** - Overview of all database offerings

## Amazon RDS

**[📖 RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)** - Relational Database Service

### Supported Engines

| Engine | Max Storage | Max Read Replicas | Use Case |
|--------|-----------|-------------------|----------|
| MySQL | 64 TB | 15 | Web apps, WordPress, general OLTP |
| PostgreSQL | 64 TB | 15 | Complex queries, PostGIS, extensions |
| MariaDB | 64 TB | 15 | MySQL-compatible, open source preference |
| Oracle | 64 TB | 5 | Enterprise apps, Oracle-specific features |
| SQL Server | 16 TB | 5 | .NET apps, Windows ecosystem |

### Key Features

- **Multi-AZ**: Synchronous standby replica, automatic failover (< 60 sec)
- **Read Replicas**: Asynchronous replication, can be cross-region
- **Storage Types**: gp3 (general), io1/io2 (provisioned IOPS), magnetic (legacy)
- **Automated Backups**: Point-in-time recovery, 0-35 day retention
- **Manual Snapshots**: User-initiated, unlimited retention
- **RDS Proxy**: Connection pooling, reduces failover time by 66%

**[📖 Multi-AZ Deployments](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)** - High availability
**[📖 Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)** - Read scaling
**[📖 RDS Proxy](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html)** - Connection management

### When to Use RDS

- Traditional relational workloads (OLTP)
- Existing applications using MySQL, PostgreSQL, Oracle, or SQL Server
- Need for complex queries, joins, and ACID transactions
- Do not need more than 64 TB storage or microsecond latency

## Amazon Aurora

**[📖 Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html)** - Cloud-native relational database

### Architecture

- Storage layer: 6 copies across 3 AZs, auto-scales 10 GB to 128 TB
- Quorum writes (4/6) and reads (3/6) for high durability
- Continuous backup to S3 with 1-second granularity
- Storage is independent of compute - shared across replicas
- Redo log-based replication (not binlog) - <100ms replica lag

### Aurora Variants

**Aurora Provisioned:**
- Writer instance + up to 15 read replicas
- Automatic failover to replica in < 30 seconds
- Reader endpoint for load-balanced reads

**Aurora Serverless v2:**
- Scales between 0.5 and 128 ACUs (Aurora Capacity Units)
- Fine-grained scaling in 0.5 ACU increments
- Sub-second scaling response
- Good for variable or unpredictable workloads

**Aurora Global Database:**
- Cross-region replication with < 1 second lag
- Up to 5 secondary regions
- RPO < 1 second, RTO < 1 minute for planned failover
- Write forwarding from secondary to primary region
- Managed planned failover and unplanned (detach) failover

**[📖 Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)** - Cross-region replication
**[📖 Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)** - Auto-scaling compute

### When to Use Aurora

- Need better performance than standard RDS (5x MySQL, 3x PostgreSQL)
- Need more than 5 read replicas
- Need auto-scaling storage beyond 64 TB
- Need cross-region disaster recovery with low RPO
- Variable workloads (Serverless v2)

## Amazon DynamoDB

**[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)** - NoSQL key-value and document

### Core Concepts

- **Tables, Items, Attributes**: Schema-less except for primary key
- **Primary Key**: Partition key (hash) or partition key + sort key (hash + range)
- **Secondary Indexes**: GSI (any attribute as key, separate throughput) and LSI (same partition key, different sort key, created at table creation)
- **Capacity Modes**: On-demand (pay per request) or Provisioned (specify RCU/WCU)

### Key Features

- Single-digit millisecond latency at any scale
- Automatic multi-AZ replication (3 AZs)
- **DAX (DynamoDB Accelerator)**: In-memory cache, microsecond reads
- **Global Tables**: Multi-region, multi-active replication
- **Streams**: Ordered change data capture (24-hour retention)
- **TTL**: Automatic item expiration
- **PartiQL**: SQL-compatible query language for DynamoDB

**[📖 DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)** - Design patterns
**[📖 Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)** - Multi-region

### Data Modeling

- Design for access patterns first (not entities)
- Single table design: Store multiple entity types in one table
- Composite sort keys: Combine attributes for flexible querying
- Sparse indexes: GSI on attribute that not all items have
- Overloaded GSI: Reuse GSI for multiple query patterns
- Avoid hot partitions: Distribute writes evenly across partition keys

### When to Use DynamoDB

- Key-value or simple document access patterns
- Need single-digit millisecond latency
- Need automatic scaling with unpredictable traffic
- Session management, shopping carts, gaming leaderboards
- IoT data with high write throughput

## Amazon DocumentDB

**[📖 DocumentDB Developer Guide](https://docs.aws.amazon.com/documentdb/latest/developerguide/what-is.html)** - MongoDB-compatible document database

- MongoDB 3.6, 4.0, 5.0 API compatibility
- Storage: Up to 128 TB, 6 copies across 3 AZs (Aurora-like architecture)
- Up to 15 read replicas
- Automatic failover, continuous backup to S3
- Not all MongoDB features supported (check compatibility matrix)

### When to Use DocumentDB

- MongoDB workloads on AWS with managed infrastructure
- Document-oriented data with flexible schema
- Need managed scaling and high availability
- Migrating from self-managed MongoDB

## Amazon Neptune

**[📖 Neptune User Guide](https://docs.aws.amazon.com/neptune/latest/userguide/intro.html)** - Graph database

- Supports Property Graph (Gremlin/openCypher) and RDF (SPARQL)
- Up to 15 read replicas, 6 copies across 3 AZs
- Neptune Serverless: Auto-scaling capacity
- Neptune ML: Graph neural networks via SageMaker integration
- Neptune Analytics: Analytical queries on large graphs

### When to Use Neptune

- Social networks (friends-of-friends queries)
- Fraud detection (relationship patterns)
- Knowledge graphs, recommendation engines
- Identity graphs, network topology
- Any workload where relationships between data are primary

## Amazon ElastiCache

**[📖 ElastiCache User Guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/WhatIs.html)** - In-memory caching

### Redis vs Memcached

| Feature | Redis | Memcached |
|---------|-------|-----------|
| Data structures | Strings, lists, sets, hashes, sorted sets | Simple key-value |
| Persistence | Yes (RDB/AOF) | No |
| Replication | Yes (primary-replica) | No |
| Multi-AZ | Yes (with failover) | No |
| Clustering | Yes (sharding) | Yes (sharding) |
| Pub/Sub | Yes | No |
| Lua scripting | Yes | No |
| Backup/restore | Yes | No |

### When to Use ElastiCache

- Database query result caching
- Session store management
- Real-time leaderboards (Redis sorted sets)
- Pub/sub messaging (Redis)
- Simple caching with multi-threading (Memcached)

## Amazon Keyspaces

**[📖 Keyspaces Developer Guide](https://docs.aws.amazon.com/keyspaces/latest/devguide/what-is-keyspaces.html)** - Apache Cassandra compatible

- Serverless, Cassandra Query Language (CQL) compatible
- On-demand or provisioned throughput
- Encryption at rest, point-in-time recovery
- Single-digit millisecond latency

### When to Use Keyspaces

- Migrating Cassandra workloads to managed service
- Wide-column time-series data
- High-volume write workloads with simple read patterns

## Amazon QLDB

**[📖 QLDB Developer Guide](https://docs.aws.amazon.com/qldb/latest/developerguide/what-is.html)** - Quantum Ledger Database

- Immutable, cryptographically verifiable transaction log
- Append-only journal with SHA-256 hash chain
- PartiQL query language
- Serverless with automatic scaling
- Full audit history of all changes

### When to Use QLDB

- Financial transactions requiring audit trail
- Supply chain tracking with verifiable history
- Regulatory compliance requiring immutable records
- Any application needing cryptographic proof of data integrity

## Amazon Timestream

**[📖 Timestream Developer Guide](https://docs.aws.amazon.com/timestream/latest/developerguide/what-is-timestream.html)** - Time-series database

- Purpose-built for time-series data
- Automatic tiering: in-memory (recent) to magnetic (historical)
- Built-in time-series functions (interpolation, smoothing, approximation)
- 1000x faster and 1/10th cost of relational for time-series queries
- SQL query interface with time-series extensions

### When to Use Timestream

- IoT sensor data and telemetry
- Application and infrastructure monitoring metrics
- DevOps monitoring and alerting
- Industrial equipment monitoring

## Database Selection Decision Tree

| Requirement | Database |
|------------|----------|
| Relational, standard engines | RDS |
| Relational, high performance, auto-scaling storage | Aurora |
| Key-value, millisecond latency, any scale | DynamoDB |
| Key-value, microsecond latency (caching) | ElastiCache (Redis) |
| Document (MongoDB compatible) | DocumentDB |
| Graph queries (relationships) | Neptune |
| Wide-column (Cassandra compatible) | Keyspaces |
| Immutable ledger with cryptographic verification | QLDB |
| Time-series data | Timestream |
| In-memory with persistence and data structures | ElastiCache (Redis) |
| Simple in-memory caching, multi-threaded | ElastiCache (Memcached) |

## Common Exam Patterns

1. **"Microsecond reads on DynamoDB"** - DAX (not ElastiCache)
2. **"Multi-region active-active relational"** - Not natively supported; use Aurora Global Database (active-passive with write forwarding)
3. **"Multi-region active-active NoSQL"** - DynamoDB Global Tables
4. **"Audit trail with cryptographic verification"** - QLDB
5. **"Graph relationships"** - Neptune
6. **"MongoDB migration"** - DocumentDB
7. **"Cassandra migration"** - Keyspaces
8. **"Variable relational workload"** - Aurora Serverless v2
9. **"Cross-region disaster recovery < 1 sec RPO"** - Aurora Global Database
10. **"Connection pooling for Lambda"** - RDS Proxy
