# Exam Tips - AWS Database Specialty

## Overview

Quick-reference guide for the DBS-C01 exam with decision trees, key numbers, and common patterns.

## Database Selection Decision Tree

```
What is the primary workload?
├── Relational (SQL, ACID, joins)
│   ├── Need > 64 TB or auto-scaling storage? -> Aurora
│   ├── Need specific engine (Oracle, SQL Server)? -> RDS
│   ├── Variable/unpredictable workload? -> Aurora Serverless v2
│   ├── Global DR with < 1 sec RPO? -> Aurora Global Database
│   └── Standard OLTP? -> RDS or Aurora
├── Key-value / Document
│   ├── Need single-digit ms latency at scale? -> DynamoDB
│   ├── Need microsecond reads? -> DynamoDB + DAX
│   ├── Need MongoDB compatibility? -> DocumentDB
│   └── Need Cassandra compatibility? -> Keyspaces
├── In-memory
│   ├── Need data structures (sorted sets, pub/sub)? -> ElastiCache Redis
│   ├── Need multi-threaded simple caching? -> ElastiCache Memcached
│   └── Need session store with persistence? -> ElastiCache Redis
├── Graph -> Neptune
├── Ledger / Immutable audit -> QLDB
├── Time-series -> Timestream
└── Full-text search -> OpenSearch
```

## Migration Decision Tree

```
Migration type?
├── Same engine (homogeneous)
│   ├── Small (< 5 GB)? -> Native dump/restore
│   ├── Medium? -> DMS full load
│   └── Large with zero downtime? -> DMS full load + CDC
└── Different engine (heterogeneous)
    ├── Step 1: Run SCT assessment
    ├── Step 2: Convert schema with SCT
    ├── Step 3: Manual conversion for red items
    └── Step 4: DMS for data migration
```

## High Availability Decision Tree

```
HA requirement?
├── Automatic failover (same region)
│   ├── RDS: Multi-AZ (< 60 sec failover)
│   ├── Aurora: Multi-AZ replicas (< 30 sec failover)
│   └── DynamoDB: Automatic (built-in, 3 AZs)
├── Cross-region DR
│   ├── Aurora Global Database (< 1 sec RPO)
│   ├── RDS cross-region read replica (minutes RPO)
│   └── DynamoDB Global Tables (active-active)
└── Zero-downtime upgrades -> Blue-green deployment
```

## Key Numbers to Remember

### RDS/Aurora

| Metric | Value |
|--------|-------|
| RDS max storage | 64 TB (16 TB for SQL Server) |
| Aurora max storage | 128 TB |
| RDS read replicas (MySQL/PostgreSQL) | Up to 15 |
| RDS read replicas (Oracle/SQL Server) | Up to 5 |
| Aurora read replicas | Up to 15 |
| Multi-AZ failover time | < 60 sec (RDS), < 30 sec (Aurora) |
| Automated backup retention | 0-35 days |
| Aurora Global Database secondary regions | Up to 5 |
| Aurora Global Database replication lag | < 1 second |
| IAM auth token validity | 15 minutes |
| RDS Proxy idle connection timeout | 1,800 sec default |
| Blue-green switchover downtime | < 1 minute |

### DynamoDB

| Metric | Value |
|--------|-------|
| Max item size | 400 KB |
| Max GSI per table | 20 |
| Max LSI per table | 5 |
| LSI creation | At table creation only |
| Partition key max size | 2,048 bytes |
| Sort key max size | 1,024 bytes |
| DynamoDB Streams retention | 24 hours |
| On-demand to provisioned switch | Once per 24 hours |
| DAX read latency | Microseconds |
| Global Tables replication | < 1 second (typical) |
| PITR retention | 35 days |

### ElastiCache

| Metric | Value |
|--------|-------|
| Redis max nodes per cluster | 500 (250 shards x 2 replicas) |
| Redis max item size | 512 MB |
| Memcached max nodes | 40 |
| Memcached max item size | 1 MB |

## Common Traps and Distractors

1. **"Encrypt existing RDS instance"** - Cannot enable encryption on existing instance. Must snapshot, copy with encryption, restore.
2. **"DynamoDB LSI after table creation"** - Cannot add LSI after creation. Must recreate table.
3. **"Aurora Multi-Master"** - Discontinued. Use Aurora Global Database with write forwarding instead.
4. **"RDS Proxy for Oracle"** - RDS Proxy supports MySQL and PostgreSQL only.
5. **"IAM auth for SQL Server"** - Not supported. Use native SQL Server authentication.
6. **"DynamoDB strong consistency on GSI"** - Not possible. GSIs are eventually consistent only.
7. **"Restore to same instance"** - PITR and snapshot restore always create new instances.
8. **"Read replica as Multi-AZ standby"** - Different features. Read replicas are readable and async. Multi-AZ standby is not readable and sync.
9. **"ElastiCache Memcached persistence"** - Memcached has no persistence. Use Redis for durability.
10. **"DynamoDB Global Tables without Streams"** - Streams must be enabled for Global Tables.

## Scenario Quick-Match

| Scenario Keyword | Answer |
|-----------------|--------|
| Connection spike from Lambda | RDS Proxy |
| Microsecond reads | DAX |
| MongoDB migration | DocumentDB |
| Cassandra migration | Keyspaces |
| Immutable audit trail | QLDB |
| IoT time-series | Timestream |
| Social network graphs | Neptune |
| Cross-region active-active NoSQL | DynamoDB Global Tables |
| Cross-region DR for Aurora | Aurora Global Database |
| Zero-downtime engine upgrade | Blue-green deployment |
| Credential rotation | Secrets Manager |
| Fine-grained Redis access | Redis RBAC (ACLs) |
| Tamper-proof database audit | Database Activity Streams |

## Last-Minute Review Checklist

- [ ] You can select the right database for any workload description
- [ ] You understand RDS vs Aurora architecture differences
- [ ] You know DynamoDB data modeling (partition keys, GSI, LSI)
- [ ] You can plan a heterogeneous migration (SCT + DMS)
- [ ] You understand Multi-AZ vs read replicas vs Global Database
- [ ] You know encryption options for each database service
- [ ] You can troubleshoot using Performance Insights and CloudWatch
- [ ] You understand IAM database authentication flow and limitations
- [ ] You know backup and restore options (PITR, snapshots, backtrack)
- [ ] You can explain Secrets Manager rotation strategies
- [ ] You score 75%+ consistently on practice exams
