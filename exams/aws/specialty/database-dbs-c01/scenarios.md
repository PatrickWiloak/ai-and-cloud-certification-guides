# AWS Database Specialty (DBS-C01) High-Yield Scenarios

## Scenario 1: Multi-Region Active-Active Application

**Scenario**: A gaming company needs a database for player profiles and leaderboards. The application serves players in North America, Europe, and Asia-Pacific. Each region must support both reads and writes with single-digit millisecond latency. Data must be consistent across regions within a few seconds.

**Solution Pattern**:
- **Database**: DynamoDB Global Tables (multi-region, multi-active)
- **Design**: Partition key on player_id for profiles, composite key (game_id + score) for leaderboards
- **Leaderboards**: Use GSI with inverted sort key for top-N queries
- **Caching**: DAX in each region for microsecond reads on hot data
- **Conflict resolution**: Last-writer-wins (built into Global Tables)

**Common Distractors**:
- Aurora Global Database (read-only in secondary regions, not active-active writes)
- ElastiCache Global Datastore (caching layer, not primary database)
- RDS with cross-region read replicas (read-only replicas, not multi-active)

**Key Takeaway**: DynamoDB Global Tables is the only AWS database service that supports multi-region active-active (read/write in all regions) natively.

---

## Scenario 2: Oracle to Aurora PostgreSQL Migration

**Scenario**: A company wants to migrate a 2 TB Oracle database to Aurora PostgreSQL. The Oracle database uses PL/SQL stored procedures, materialized views, and Oracle-specific data types. The application must have less than 1 hour of downtime during cutover.

**Solution Pattern**:
1. **Assessment**: Run AWS SCT to generate assessment report
2. **Schema conversion**: SCT auto-converts green items, manually rewrite red items (PL/SQL to PL/pgSQL)
3. **Test schema**: Deploy converted schema to Aurora PostgreSQL
4. **Data migration**: DMS full load + CDC from Oracle to Aurora PostgreSQL
5. **Validation**: Enable DMS data validation to compare source and target
6. **Cutover**: Stop application writes, wait for CDC to catch up, switch application endpoint
7. **Rollback plan**: Keep Oracle running for rollback period

**Common Distractors**:
- Using DMS alone without SCT (DMS migrates data, not stored procedures or complex schema)
- Native Oracle export/import (does not work for heterogeneous migration)
- Attempting to use Oracle compatibility mode in PostgreSQL (limited, not recommended)

**Key Takeaway**: Heterogeneous migrations require SCT for schema conversion and DMS for data migration. Manual effort is needed for complex PL/SQL stored procedures.

---

## Scenario 3: Encrypting an Existing Database

**Scenario**: A compliance audit requires that all RDS MySQL databases be encrypted at rest. One production database (500 GB) is currently unencrypted. The database serves a critical application with a 4-hour maintenance window on Sundays.

**Solution Pattern**:
1. Take a manual snapshot of the unencrypted instance
2. Copy the snapshot with encryption enabled (specify KMS CMK)
3. Restore a new DB instance from the encrypted snapshot
4. Update application connection string to new endpoint
5. Verify application functionality
6. Delete the old unencrypted instance after validation period

**Alternative (less downtime)**: Use blue-green deployment if available for the engine version:
1. Create encrypted read replica (requires snapshot copy method first)
2. Promote read replica and switch traffic

**Common Distractors**:
- Enabling encryption on the existing instance (not possible after creation)
- Using TDE for MySQL (TDE is for Oracle and SQL Server only)
- Modifying the instance to add encryption (no such option exists)

**Key Takeaway**: RDS encryption cannot be enabled on an existing instance. The snapshot-copy-restore workflow is the standard approach.

---

## Scenario 4: Lambda Connection Management

**Scenario**: A serverless application uses AWS Lambda to query an Aurora MySQL database. Under load (1,000 concurrent Lambda invocations), the database hits `max_connections` limit and returns "Too many connections" errors. The database is an r6g.large (1,000 max connections).

**Solution Pattern**:
- **Implement RDS Proxy**: Place between Lambda and Aurora
- RDS Proxy pools and reuses connections (1,000 Lambda functions share ~100 database connections)
- Configure proxy with Secrets Manager for credentials
- IAM authentication from Lambda to RDS Proxy
- RDS Proxy also reduces failover time from ~30 sec to < 1 sec for Aurora

**Common Distractors**:
- Increasing max_connections (hits memory limits, does not scale)
- Scaling up the instance (more memory helps, but connections still spike)
- Adding read replicas (if workload is write-heavy, does not help)
- Connection pooling in Lambda code (each invocation is isolated, pool is per-instance)

**Key Takeaway**: RDS Proxy is specifically designed for Lambda-to-database connection management. Lambda functions cannot maintain traditional connection pools.

---

## Scenario 5: DynamoDB Hot Partition

**Scenario**: A social media application uses DynamoDB with user_id as the partition key. A celebrity with millions of followers posts content, causing their user_id partition to receive 100x normal traffic. The table is in provisioned mode with auto-scaling, but requests are being throttled.

**Solution Pattern**:
1. **Immediate**: Switch to on-demand capacity mode (instant scaling)
2. **Short-term**: Use DAX for caching celebrity profile reads
3. **Long-term redesign options**:
   - Write sharding: Append random suffix to partition key (user_id#1, user_id#2)
   - Separate hot-item table with higher provisioned capacity
   - Cache popular items in ElastiCache Redis
4. **Monitoring**: Enable CloudWatch Contributor Insights to identify hot keys

**Common Distractors**:
- Adding a GSI (does not help with partition-level throttling on base table)
- Increasing provisioned capacity (auto-scaling already tried; problem is single partition limit)
- Adding more attributes to partition key (changes access pattern, breaks existing queries)

**Key Takeaway**: DynamoDB partition limit is 3,000 RCU or 1,000 WCU per partition. Hot partitions require design changes (write sharding, caching) rather than just capacity increases.

---

## Scenario 6: Cross-Region Disaster Recovery

**Scenario**: A financial services application uses Aurora PostgreSQL. Regulatory requirements mandate: RPO < 5 seconds, RTO < 2 minutes, and the ability to fail over to a different AWS region. The application must also serve read traffic from the DR region for reporting.

**Solution Pattern**:
- **Aurora Global Database** with primary in us-east-1, secondary in eu-west-1
- Storage-level replication with < 1 second lag (meets RPO < 5 seconds)
- Secondary region has up to 16 read replicas for reporting workload
- **Planned failover**: Managed process, RPO = 0, RTO < 2 minutes
- **Unplanned failover**: Detach secondary, promote to standalone (RPO typically < 1 second)
- Application uses Route 53 health checks for automatic DNS failover

**Common Distractors**:
- Cross-region read replica (higher replication lag, manual promotion process)
- DMS for cross-region replication (higher latency than Aurora Global Database)
- Multi-AZ deployment (same region only, does not provide cross-region DR)

**Key Takeaway**: Aurora Global Database provides the lowest RPO (< 1 second) for cross-region relational database DR on AWS.

---

## Scenario 7: Database Performance Troubleshooting

**Scenario**: An Aurora MySQL database that previously handled 5,000 transactions per second is now struggling at 2,000 TPS. Response times have increased from 5ms to 50ms. No application changes were made. The instance is a r6g.2xlarge with CPUUtilization at 45%.

**Solution Pattern**:
1. **Check Performance Insights**: Look at DB Load and top wait events
2. **Likely finding**: Lock waits or I/O waits dominating (not CPU - only 45%)
3. **If lock waits**: Check for long-running transactions, deadlocks, missing indexes
4. **If I/O waits**: Check BufferCacheHitRatio - if low, working set exceeds memory
5. **Check slow query log**: Identify queries with high lock time or rows examined
6. **Check for table growth**: Large table scans due to missing indexes
7. **Resolution**: Add indexes, optimize queries, or scale instance for more memory

**Common Distractors**:
- Scaling up CPU (CPU is only at 45%, not the bottleneck)
- Adding read replicas (if problem is write locks, replicas do not help)
- Increasing storage IOPS (check if I/O is actually the bottleneck first)

**Key Takeaway**: Always use Performance Insights to identify the actual bottleneck (CPU, I/O, locks) before scaling. Scaling the wrong dimension wastes money.

---

## Scenario 8: Secrets Rotation Strategy

**Scenario**: A company has 50 RDS instances across multiple accounts. Database credentials are stored in application configuration files. The security team requires automatic credential rotation every 30 days with zero application downtime.

**Solution Pattern**:
- **Migrate credentials to Secrets Manager** for all 50 instances
- **Multi-user rotation strategy** for zero downtime:
  1. Secrets Manager maintains two database users (user_A, user_B)
  2. During rotation, updates the inactive user's password
  3. Switches the active user pointer
  4. Application always uses the current active user
- **Application change**: Replace hardcoded credentials with Secrets Manager SDK calls
- **Cross-account**: Use Secrets Manager resource policies for cross-account access
- **Caching**: Use Secrets Manager caching SDK to reduce API calls

**Common Distractors**:
- Single-user rotation (brief downtime when password changes)
- Parameter Store for credentials (no built-in rotation)
- IAM database authentication for all instances (not supported for Oracle/SQL Server)

**Key Takeaway**: Multi-user rotation in Secrets Manager provides zero-downtime credential rotation. Single-user rotation has a brief window where the old password is invalid.
