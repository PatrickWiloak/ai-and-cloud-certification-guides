# Management and Operations - AWS Database Specialty

## Overview

Management and operations covers 18% of the DBS-C01 exam. This domain focuses on database configuration, maintenance, backup strategies, and operational best practices.

## Parameter Groups

**[📖 RDS Parameter Groups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html)** - Database configuration

### DB Parameter Groups

- Control database engine configuration (like my.cnf for MySQL)
- Default parameter groups are read-only - create custom groups to modify
- Changes can be **dynamic** (applied immediately) or **static** (require reboot)
- Each DB instance is associated with one parameter group
- Can be applied to multiple instances

**Common Parameters:**
- `max_connections` - Maximum concurrent connections
- `innodb_buffer_pool_size` - InnoDB cache size (MySQL)
- `shared_buffers` - Shared memory for caching (PostgreSQL)
- `slow_query_log` - Enable slow query logging
- `log_min_duration_statement` - Slow query threshold (PostgreSQL)

### DB Cluster Parameter Groups (Aurora)

- Apply to all instances in an Aurora cluster
- Contains engine-level settings shared across writer and readers
- Instance-level parameter group for instance-specific settings

## Option Groups

**[📖 RDS Option Groups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html)** - Engine-specific features

- Enable optional database engine features
- Primarily used for Oracle and SQL Server
- Examples:
  - Oracle: TDE (Transparent Data Encryption), Oracle Enterprise Manager
  - SQL Server: TDE, Native Backup/Restore to S3
  - MySQL: memcached plugin, audit plugin
- Associated with a DB instance, can be changed

## Maintenance Windows

**[📖 RDS Maintenance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html)** - Maintenance management

### Scheduled Maintenance

- 30-minute weekly maintenance window
- OS patches, engine patches, hardware maintenance
- **Required maintenance**: Applied automatically in the window (or immediately if critical)
- **Optional maintenance**: Deferred until you apply manually
- Multi-AZ: Maintenance on standby first, then failover, then patch primary
- Can modify the maintenance window timing

### Engine Version Upgrades

**Minor version upgrades:**
- Can enable auto minor version upgrade
- Applied during maintenance window
- Generally backward compatible

**Major version upgrades:**
- Manual process - you initiate the upgrade
- Test in non-production first
- Use blue-green deployment for zero-downtime upgrades
- Review release notes for breaking changes
- Some require Aurora cloning or snapshot-restore

## Snapshots and Backups

### Automated Backups

**[📖 RDS Automated Backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html)** - Continuous backup

- Daily full backup during backup window
- Transaction logs backed up every 5 minutes
- Point-in-time recovery (PITR) to any second within retention period
- Retention: 0 to 35 days (0 disables automated backups)
- Backups stored in S3 (managed by AWS, not visible in your S3 console)
- I/O may be briefly suspended during backup (Single-AZ without Multi-AZ)
- Multi-AZ: Backup taken from standby - no performance impact on primary

### Aurora Backups

- Continuous backup to S3 (no backup window needed)
- PITR accurate to 1 second
- Retention: 1 to 35 days
- Backtrack: Rewind Aurora cluster to specific point in time without restore (MySQL-compatible only)
- Backtrack is in-place - faster than restore from snapshot

**[📖 Aurora Backtrack](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Managing.Backtrack.html)** - Point-in-time rewind

### Manual Snapshots

- User-initiated, retained until manually deleted
- Not subject to retention period limits
- Can share with other AWS accounts or make public
- Can copy cross-region for disaster recovery
- Encrypted snapshots can only be shared if using customer managed KMS key (not AWS managed)

### Snapshot Management

- **Copy snapshots cross-region**: For disaster recovery
- **Share snapshots cross-account**: For environment replication
- **Export to S3**: For analytics (Aurora and RDS - Parquet format)
- **Restore**: Creates a new DB instance from snapshot (new endpoint)

**Exam Tip:** Restoring from a snapshot or PITR always creates a new DB instance with a new endpoint. You cannot restore to an existing instance.

## Performance Insights

**[📖 Performance Insights](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html)** - Database performance monitoring

### Key Features

- Visualize database load by wait events, SQL statements, hosts, users
- **DB Load**: Number of active sessions (compare to vCPU count)
- **Top SQL**: Identify most expensive queries
- **Wait events**: Understand what database is waiting on (I/O, locks, CPU, etc.)
- Free tier: 7-day retention
- Paid tier: Up to 2 years retention
- Supported: RDS (all engines), Aurora (all engines)

### Common Wait Events

| Wait Event | Engine | Meaning |
|-----------|--------|---------|
| io/table/sql/handler | MySQL | Table I/O waits |
| CPU | All | CPU saturation |
| io/aurora_redo_log_flush | Aurora MySQL | Redo log write latency |
| Lock:transactionid | PostgreSQL | Row-level lock contention |
| wait/io/data_file/innodb | MySQL | InnoDB data file reads |

### Using Performance Insights

1. Check if DB Load exceeds vCPU count (indicates bottleneck)
2. Identify top wait events (I/O, CPU, or locks)
3. Drill into top SQL statements causing the load
4. Optimize queries or scale instance

## DynamoDB Operations

**[📖 DynamoDB Operations](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)** - Operational management

### Capacity Management

- **On-demand mode**: Automatic scaling, pay per request
- **Provisioned mode**: Specify RCU/WCU, with optional auto-scaling
- Auto-scaling uses target tracking policies (target utilization %)
- Reserved capacity: 1-3 year commitments for cost savings
- Switch between modes once every 24 hours

### Backup and Restore

- **On-demand backup**: Full table backup, no performance impact
- **Point-in-time recovery (PITR)**: Continuous backups, restore to any second in last 35 days
- **AWS Backup integration**: Centralized backup management with lifecycle policies
- Restores always create a new table

### Global Tables

- Multi-region, multi-active (read and write in any region)
- Eventual consistency across regions (typically < 1 second)
- Last-writer-wins conflict resolution
- Requires DynamoDB Streams enabled
- All replicas have same table name

## Automation with CloudFormation and Terraform

**[📖 CloudFormation RDS](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbinstance.html)** - Infrastructure as code

### Best Practices

- Use parameter groups as separate CloudFormation resources
- Enable deletion protection for production databases
- Use `DeletionPolicy: Snapshot` to take final snapshot on stack deletion
- Store credentials in Secrets Manager (not plaintext in templates)
- Use `AWS::RDS::DBCluster` for Aurora, `AWS::RDS::DBInstance` for RDS

## Common Exam Patterns

1. **"Tune database performance"** - Check Performance Insights for load and wait events
2. **"Change database configuration"** - Custom parameter group (not default)
3. **"No downtime for maintenance"** - Multi-AZ handles failover during patching
4. **"Cross-region backup"** - Copy snapshot to another region
5. **"Rewind database to undo mistake"** - Aurora Backtrack (if enabled)
6. **"Restore to specific point in time"** - PITR (creates new instance)
7. **"Share database for testing"** - Share snapshot cross-account
8. **"DynamoDB cost optimization"** - Switch to provisioned with auto-scaling or reserved capacity
