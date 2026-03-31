# MongoDB Associate DBA - Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: Server Administration

#### Day 1-2: mongod Configuration
- [ ] Study mongod.conf file structure and options
- [ ] Learn command-line options vs configuration file
- [ ] Understand storage configuration (dbPath, journal, directoryPerDB)
- [ ] Hands-on: Deploy mongod with custom configuration
- [ ] Lab: Modify runtime settings with db.adminCommand()
- [ ] Review Notes: `01-server-administration.md`

#### Day 3-4: WiredTiger Storage Engine
- [ ] Study WiredTiger architecture (cache, checkpoints, journal)
- [ ] Learn cache sizing and monitoring
- [ ] Understand compression options (snappy, zlib, zstd)
- [ ] Hands-on: Configure WiredTiger cache and compression
- [ ] Lab: Monitor cache utilization and checkpoint behavior

#### Day 5-6: Profiling and Logging
- [ ] Study database profiler (levels 0, 1, 2)
- [ ] Learn log file analysis and slow query identification
- [ ] Understand log rotation and management
- [ ] Hands-on: Enable profiler and analyze slow operations
- [ ] Lab: Configure structured logging and log rotation

#### Day 7: Week 1 Review
- [ ] Complete server administration practice questions
- [ ] Review key configuration parameters
- [ ] Practice server diagnostic commands

### Week 2: Replication

#### Day 8-9: Replica Set Setup
- [ ] Study replica set architecture and member roles
- [ ] Learn replica set initialization and member management
- [ ] Understand priority, votes, and member configuration
- [ ] Hands-on: Deploy 3-node replica set
- [ ] Lab: Add/remove members, reconfigure replica set
- [ ] Review Notes: `02-replication.md`

#### Day 10-11: Elections and Failover
- [ ] Study election protocol and triggers
- [ ] Learn priority-based election behavior
- [ ] Understand network partitions and split-brain prevention
- [ ] Hands-on: Simulate primary failure and observe election
- [ ] Lab: Test different priority configurations

#### Day 12-13: Oplog and Read/Write Concerns
- [ ] Study oplog mechanics (capped collection, sizing)
- [ ] Learn read preferences (primary, secondary, nearest)
- [ ] Understand write concerns (w:1, w:majority, j:true)
- [ ] Hands-on: Monitor oplog size and replication lag
- [ ] Lab: Test different read preference and write concern combinations

#### Day 14: Week 2 Review
- [ ] Complete replication practice questions
- [ ] Review member types and their properties
- [ ] Practice replica set management commands

### Week 3: Sharding

#### Day 15-16: Sharded Cluster Architecture
- [ ] Study sharded cluster components (config servers, mongos, shards)
- [ ] Learn shard key selection criteria
- [ ] Understand ranged vs hashed sharding
- [ ] Hands-on: Deploy a sharded cluster
- [ ] Lab: Shard a collection with different shard keys
- [ ] Review Notes: `03-sharding.md`

#### Day 17-18: Chunks and Balancer
- [ ] Study chunk splitting and migration mechanics
- [ ] Learn balancer configuration and scheduling
- [ ] Understand jumbo chunks and troubleshooting
- [ ] Hands-on: Monitor chunk distribution
- [ ] Lab: Configure balancer window and observe migrations

#### Day 19-20: Zones and Query Routing
- [ ] Study zone-based sharding for data locality
- [ ] Learn how mongos routes queries to shards
- [ ] Understand targeted vs scatter-gather queries
- [ ] Hands-on: Configure zone ranges and observe data placement
- [ ] Lab: Analyze query routing with explain()

#### Day 21: Week 3 Review
- [ ] Complete sharding practice questions
- [ ] Review shard key selection decision tree
- [ ] Practice sharding management commands

### Week 4: Security

#### Day 22-23: Authentication
- [ ] Study SCRAM-SHA-256 authentication
- [ ] Learn x.509 certificate authentication
- [ ] Understand LDAP and Kerberos integration
- [ ] Hands-on: Enable SCRAM authentication on replica set
- [ ] Lab: Create users with different authentication methods
- [ ] Review Notes: `04-security.md`

#### Day 24-25: Authorization and Roles
- [ ] Study built-in roles (read, readWrite, dbAdmin, etc.)
- [ ] Learn custom role creation
- [ ] Understand role inheritance and privileges
- [ ] Hands-on: Create users with appropriate roles
- [ ] Lab: Design role hierarchy for multi-team access

#### Day 26-27: Encryption and Auditing
- [ ] Study TLS/SSL configuration for mongod
- [ ] Learn encryption at rest options
- [ ] Understand audit logging (Enterprise)
- [ ] Hands-on: Configure TLS for client-server communication
- [ ] Lab: Enable audit logging for security events

#### Day 28: Week 4 Review
- [ ] Complete security practice questions
- [ ] Review authentication method comparison
- [ ] Practice security configuration

### Week 5: Backup, Recovery, and Monitoring

#### Day 29-30: Backup Methods
- [ ] Study mongodump and mongorestore options
- [ ] Learn oplog-based point-in-time recovery
- [ ] Understand filesystem snapshot backups
- [ ] Hands-on: Perform backup and restore operations
- [ ] Lab: Practice point-in-time recovery
- [ ] Review Notes: `05-backup-monitoring.md`

#### Day 31-32: Monitoring Tools
- [ ] Study mongostat and mongotop output interpretation
- [ ] Learn db.serverStatus() key metrics
- [ ] Understand database profiler configuration
- [ ] Hands-on: Set up monitoring dashboards
- [ ] Lab: Identify performance bottlenecks using metrics

#### Day 33-34: Performance Troubleshooting
- [ ] Study common performance issues and solutions
- [ ] Learn connection pool management
- [ ] Understand lock contention and write throughput
- [ ] Hands-on: Diagnose and resolve slow operations
- [ ] Lab: Optimize a poorly performing deployment

#### Day 35: Week 5 Review
- [ ] Complete backup and monitoring practice questions
- [ ] Review backup method comparison
- [ ] Practice monitoring command output interpretation

### Week 6: Exam Preparation

#### Day 36-37: Full Practice Exams
- [ ] Take first full-length practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify weak domains and knowledge gaps

#### Day 38-39: Targeted Review
- [ ] Focus study on weakest domains
- [ ] Review all configuration defaults
- [ ] Review replica set and sharding architecture
- [ ] Practice security setup commands

#### Day 40-41: Final Review
- [ ] Take second full-length practice exam
- [ ] Review shard key selection criteria
- [ ] Review authentication methods comparison
- [ ] Review backup method trade-offs

#### Day 42: Exam Day Preparation
- [ ] Quick review of fact sheet
- [ ] Review common pitfalls
- [ ] Rest and prepare mentally

## 📊 Domain Study Time Allocation

| Domain | Weight | Recommended Hours |
|--------|--------|-------------------|
| Server Administration | 25% | 16-20 hours |
| Replication | 20% | 14-16 hours |
| Sharding | 20% | 14-16 hours |
| Security | 15% | 10-12 hours |
| Backup/Recovery | 10% | 6-8 hours |
| Monitoring | 10% | 6-8 hours |
| **Total** | **100%** | **66-80 hours** |
