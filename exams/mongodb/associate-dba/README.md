# MongoDB Associate DBA

## Exam Overview

The MongoDB Associate DBA exam validates the ability to administer and operate MongoDB deployments. This certification demonstrates proficiency in server administration, replica set management, sharding, security configuration, and backup/recovery operations.

**Exam Details:**
- **Exam Code:** MongoDB Associate DBA
- **Duration:** 75 minutes
- **Number of Questions:** 62 multiple-choice questions
- **Passing Score:** 65%
- **Cost:** $150 USD
- **Delivery:** Online proctored
- **Validity:** 3 years
- **Prerequisites:** None (hands-on MongoDB administration experience recommended)

## Exam Domains

### Domain 1: Server Administration (25%)
- mongod and mongos configuration
- Storage engines (WiredTiger)
- Journaling and durability
- Database profiler and logging
- Configuration file and command-line options

**Key Concepts:**
- WiredTiger storage engine internals
- mongod process management
- Server configuration and tuning
- Log management and analysis

### Domain 2: Replication (20%)
- Replica set architecture and configuration
- Elections and failover
- Oplog mechanics
- Read preferences and write concerns
- Replica set member types

**Key Concepts:**
- Primary/secondary/arbiter roles
- Automatic failover and election protocol
- Oplog sizing and maintenance
- Read preference modes

### Domain 3: Sharding (20%)
- Shard key selection and strategies
- Chunk management and balancer
- Zones and zone-based sharding
- Hashed vs ranged sharding
- Config servers and mongos routers

**Key Concepts:**
- Shard key selection criteria
- Chunk splitting and migration
- Balancer operations
- Query routing

### Domain 4: Security (15%)
- Authentication methods
- Authorization and roles
- TLS/SSL encryption
- Audit logging
- Encryption at rest

**Key Concepts:**
- SCRAM, x.509, LDAP, Kerberos authentication
- Built-in and custom roles
- Transport encryption
- Client-Side Field Level Encryption (CSFLE)

### Domain 5: Backup and Recovery (10%)
- mongodump and mongorestore
- Oplog-based backup
- Point-in-time recovery
- Snapshot backups

### Domain 6: Monitoring (10%)
- mongostat and mongotop
- Database profiler
- Server status and monitoring tools
- Performance metrics

## Study Materials

### Official Resources
- **[📖 MongoDB Administration](https://www.mongodb.com/docs/manual/administration/)** - Administration documentation
- **[📖 MongoDB University](https://learn.mongodb.com/)** - Free DBA courses
- **[📖 MongoDB Operations](https://www.mongodb.com/docs/manual/administration/production-notes/)** - Production deployment guide
- **[📖 MongoDB Security](https://www.mongodb.com/docs/manual/security/)** - Security documentation

### Study Guide Files
| Resource | Description |
|----------|-------------|
| [Fact Sheet](fact-sheet.md) | Quick reference with exam details and key facts |
| [Study Strategy](strategy.md) | Recommended study approach and timeline |
| [Practice Plan](practice-plan.md) | Week-by-week study schedule with hands-on labs |
| [Scenarios](scenarios.md) | High-yield exam scenarios and solution patterns |
| [Notes](notes/) | Detailed topic notes organized by domain |

### Notes Index
| File | Topics Covered |
|------|---------------|
| [01 - Server Administration](notes/01-server-administration.md) | mongod/mongos config, storage engines, journaling |
| [02 - Replication](notes/02-replication.md) | Replica sets, elections, oplog, read preferences |
| [03 - Sharding](notes/03-sharding.md) | Shard keys, chunks, balancer, zones |
| [04 - Security](notes/04-security.md) | Authentication, authorization, TLS, audit |
| [05 - Backup & Monitoring](notes/05-backup-monitoring.md) | mongodump, mongorestore, monitoring tools |
