# Monitoring and Troubleshooting - AWS Database Specialty

## Overview

Monitoring and troubleshooting covers 18% of the DBS-C01 exam. This domain focuses on CloudWatch metrics, Enhanced Monitoring, Performance Insights, log analysis, and diagnosing common database issues.

## CloudWatch Metrics for Databases

**[📖 RDS CloudWatch Metrics](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-metrics.html)** - Standard metrics

### Key RDS/Aurora Metrics

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| CPUUtilization | CPU usage percentage | > 80% sustained |
| FreeableMemory | Available RAM | < 25% of total |
| FreeStorageSpace | Available storage (RDS) | < 20% of allocated |
| DatabaseConnections | Active connections | Approaching max_connections |
| ReadIOPS / WriteIOPS | I/O operations per second | Compare to baseline |
| ReadLatency / WriteLatency | Average I/O latency | > 10-20ms |
| ReplicaLag | Replication delay (seconds) | > 0 for critical reads |
| SwapUsage | Swap space used | > 0 indicates memory pressure |
| DiskQueueDepth | Pending I/O requests | > 0 sustained |
| NetworkReceiveThroughput | Network bytes in | Approaching instance limit |

### Aurora-Specific Metrics

| Metric | Description |
|--------|-------------|
| AuroraReplicaLag | Replica lag in milliseconds (typically < 20ms) |
| VolumeBytesUsed | Total storage used |
| VolumeReadIOPs / VolumeWriteIOPs | Storage I/O operations |
| BufferCacheHitRatio | Percentage of requests served from cache |
| Deadlocks | Number of deadlocks detected |
| DDLLatency | DDL statement latency |
| DMLLatency | DML statement latency |
| SelectLatency | SELECT statement latency |
| CommitLatency | Commit operation latency |

### DynamoDB CloudWatch Metrics

**[📖 DynamoDB Metrics](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/metrics-dimensions.html)** - Table and index metrics

| Metric | Description | Action |
|--------|-------------|--------|
| ConsumedReadCapacityUnits | Actual read consumption | Compare to provisioned |
| ConsumedWriteCapacityUnits | Actual write consumption | Compare to provisioned |
| ThrottledRequests | Requests exceeding capacity | Scale up or switch to on-demand |
| SystemErrors | 5xx server errors | AWS-side issue |
| UserErrors | 4xx client errors | Fix application code |
| SuccessfulRequestLatency | Response time | Monitor for degradation |
| ReturnedItemCount | Items returned by queries | Optimize query patterns |
| TimeToLiveDeletedItemCount | Items deleted by TTL | Verify TTL working |

## Enhanced Monitoring

**[📖 Enhanced Monitoring](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html)** - OS-level metrics

### Key Differences from CloudWatch

| Feature | CloudWatch Metrics | Enhanced Monitoring |
|---------|-------------------|---------------------|
| Source | Hypervisor | OS agent on instance |
| Granularity | 60 seconds (free) or 1 second | 1 to 60 seconds |
| Metrics | Database and instance | OS processes, CPU, memory, I/O |
| Cost | Free (standard) | Per instance, varies by granularity |
| Destination | CloudWatch | CloudWatch Logs |

### OS Metrics Available

- **CPU**: User, system, idle, wait, steal (important for shared instances)
- **Memory**: Total, free, cached, buffered, active, inactive
- **I/O**: Read/write throughput, IOPS, latency, queue depth per device
- **Network**: Receive/transmit throughput
- **Processes**: Number of running, sleeping, zombie processes
- **File system**: Used space, free space

### When to Use Enhanced Monitoring

- Troubleshooting performance at the OS level
- Identifying CPU steal (noisy neighbor on shared hardware)
- Monitoring per-process resource usage
- Granularity finer than 60 seconds needed

## Performance Insights Deep Dive

**[📖 Performance Insights](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html)** - Advanced analysis

### Analyzing Database Load

**DB Load** = Average Active Sessions (AAS)
- If DB Load > vCPU count: Database is bottlenecked
- Breakdown by: wait events, SQL statements, hosts, users, databases

### Troubleshooting Workflow

1. **Check DB Load graph**: Is load exceeding Max vCPU line?
2. **Identify top wait type**: CPU, I/O, lock, or other
3. **Find top SQL**: Which queries contribute most to the load
4. **Analyze wait events**: What is the specific bottleneck
5. **Take action**: Optimize query, add indexes, scale instance

### Wait Event Categories

**CPU waits:**
- Database spending time on compute
- Fix: Optimize queries, add indexes, scale up instance class

**I/O waits:**
- Database waiting for disk reads/writes
- Fix: Scale storage (gp3 IOPS), add read replicas, optimize queries to reduce I/O

**Lock waits:**
- Transactions waiting for locks held by other transactions
- Fix: Optimize transactions (shorter), reduce lock contention, review isolation levels

**Network waits:**
- Waiting for network communication
- Fix: Check network configuration, reduce result set size

## Slow Query Analysis

### MySQL Slow Query Log

**[📖 MySQL Slow Query Log](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.MySQL.LogFileSize.html)** - Query logging

- Enable: `slow_query_log = 1` in parameter group
- Threshold: `long_query_time` (default 10 seconds, set to 1-2 for analysis)
- Log output: `log_output = FILE` (to RDS log files, downloadable)
- Publish to CloudWatch Logs for retention and analysis
- Key fields: query time, lock time, rows examined, rows sent

### PostgreSQL Query Logging

**[📖 PostgreSQL Logging](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html)** - PostgreSQL logs

- `log_min_duration_statement`: Log queries exceeding threshold (ms)
- `log_statement`: Log all, ddl, mod, or none
- `pg_stat_statements` extension: Aggregate query statistics
- `auto_explain` extension: Automatic EXPLAIN for slow queries
- Publish logs to CloudWatch Logs

### Aurora Query Analysis

- Performance Insights includes Top SQL
- Aurora MySQL: Enable `performance_schema`
- Aurora PostgreSQL: Enable `pg_stat_statements`
- Aurora Serverless: Use Query Editor in RDS console

## Deadlock Detection and Resolution

### Identifying Deadlocks

**MySQL/Aurora MySQL:**
- `SHOW ENGINE INNODB STATUS` - Shows last deadlock
- CloudWatch metric: `Deadlocks` (Aurora)
- Error log contains deadlock information
- InnoDB automatically rolls back one transaction

**PostgreSQL/Aurora PostgreSQL:**
- `deadlock_timeout` parameter (default 1 second)
- `log_lock_waits = on` logs long lock waits
- `pg_stat_activity` view shows current locks
- `pg_locks` view shows all locks
- PostgreSQL detects and breaks deadlocks automatically

### Common Deadlock Causes

1. Two transactions updating same rows in different order
2. Unindexed foreign key columns causing table locks
3. Long-running transactions holding locks
4. INSERT ... ON DUPLICATE KEY UPDATE with concurrent inserts

### Resolution Strategies

- Ensure consistent lock ordering across transactions
- Keep transactions short
- Add appropriate indexes (especially on foreign keys)
- Use lower isolation levels where possible
- Implement retry logic in application code

## Replication Troubleshooting

### Common Replication Issues

**High Replica Lag (RDS):**
- Cause: Heavy write load on primary, slow replica instance
- Fix: Scale replica instance class, reduce write load, check network

**Aurora Replica Lag:**
- Typically < 20ms due to shared storage
- If high: Check for long-running queries on replica that block redo log application
- Monitor `AuroraReplicaLag` metric

**Replication Stopped:**
- MySQL: Check `SHOW SLAVE STATUS` for error details
- Common causes: Duplicate key errors, missing tables, binary log issues
- Fix: Address root cause, reset replication if needed

## DynamoDB Troubleshooting

### Throttling Issues

- **ProvisionedThroughputExceededException**: Exceeded RCU/WCU
- **Hot partition**: One partition receiving disproportionate traffic
- **Burst capacity**: 300 seconds of unused capacity available for bursts
- **Adaptive capacity**: Automatically redistributes throughput to hot partitions

**Resolution:**
1. Check `ThrottledRequests` metric
2. Identify hot keys with CloudWatch Contributor Insights
3. Redesign partition key for better distribution
4. Switch to on-demand capacity mode
5. Enable DAX for read-heavy workloads

### GSI Throttling

- GSI has separate provisioned throughput
- If GSI throttled, base table writes are also throttled (back-pressure)
- Solution: Increase GSI capacity or switch table to on-demand mode

## CloudWatch Alarms Best Practices

### Recommended Alarms

| Alarm | Metric | Threshold |
|-------|--------|-----------|
| High CPU | CPUUtilization | > 80% for 5 min |
| Low memory | FreeableMemory | < 256 MB |
| Low storage | FreeStorageSpace | < 10% |
| High connections | DatabaseConnections | > 80% of max |
| Replication lag | ReplicaLag | > 30 seconds |
| Deadlocks | Deadlocks | > 0 |
| DynamoDB throttling | ThrottledRequests | > 0 for 5 min |

### Alarm Actions

- SNS notification for alerts
- Auto Scaling policies (DynamoDB)
- Lambda function for automated remediation
- Systems Manager Automation runbooks

## Common Exam Patterns

1. **"Database slow, need to identify cause"** - Performance Insights (DB Load, wait events, Top SQL)
2. **"OS-level metrics needed"** - Enhanced Monitoring
3. **"Identify hot partition in DynamoDB"** - CloudWatch Contributor Insights
4. **"Deadlock detection"** - Check engine status / pg_locks + CloudWatch Deadlocks metric
5. **"Slow queries in MySQL"** - Enable slow query log, check Performance Insights Top SQL
6. **"Replica lag increasing"** - Check replica instance class, write load, long-running queries on replica
7. **"DynamoDB throttling"** - Check partition key design, consider on-demand mode
8. **"Proactive alerting"** - CloudWatch Alarms with SNS notifications
