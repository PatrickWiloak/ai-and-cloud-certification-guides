# MongoDB Associate DBA - Study Strategy

## 🎯 Study Approach

### Phase 1: Server Fundamentals (1-2 weeks)
1. **mongod Configuration**
   - Master mongod configuration file format
   - Understand WiredTiger storage engine internals
   - Learn journaling and durability mechanisms
   - Study server commands and diagnostics

2. **Hands-on Setup**
   - Install MongoDB locally and configure mongod.conf
   - Deploy standalone instance with custom configuration
   - Practice server management commands
   - Explore log files and server status output

### Phase 2: Replication and Sharding (2-3 weeks)
1. **Replication**
   - Deploy a 3-node replica set
   - Practice elections and failover scenarios
   - Configure read preferences and write concerns
   - Study oplog mechanics and sizing

2. **Sharding**
   - Deploy a sharded cluster (config servers, mongos, shards)
   - Practice shard key selection for different workloads
   - Study chunk management and the balancer
   - Configure zone-based sharding

### Phase 3: Security, Backup, and Monitoring (2-3 weeks)
1. **Security**
   - Configure SCRAM authentication
   - Set up TLS/SSL encryption
   - Implement role-based access control
   - Practice user and role management

2. **Backup and Monitoring**
   - Practice mongodump and mongorestore
   - Set up database profiler
   - Monitor with mongostat and mongotop
   - Analyze server metrics and performance

### Phase 4: Exam Preparation (1 week)
1. **Practice Exams**
   - Take practice exams and review answers
   - Focus on Server Admin (25%) and Replication/Sharding (40% combined)

2. **Final Review**
   - Review configuration defaults
   - Review replica set member types and roles
   - Review shard key selection criteria

## 📚 Study Resources

### Official Resources
- **[📖 MongoDB University - DBA Path](https://learn.mongodb.com/)** - Free DBA courses
- **[📖 MongoDB Administration](https://www.mongodb.com/docs/manual/administration/)** - Admin reference
- **[📖 Production Notes](https://www.mongodb.com/docs/manual/administration/production-notes/)** - Production guide
- **[📖 MongoDB Manual](https://www.mongodb.com/docs/manual/)** - Complete reference

### Practice
- **[📖 MongoDB Atlas](https://www.mongodb.com/atlas)** - Free tier for practice
- **[📖 MongoDB Enterprise](https://www.mongodb.com/try/download/enterprise)** - Enterprise features
- **[📖 MongoDB Tools](https://www.mongodb.com/docs/database-tools/)** - CLI tools reference

## 🧠 Exam Tactics

### Domain Priorities (by weight)
1. **Server Administration (25%)** - Configuration and storage engine
2. **Replication (20%)** - Replica sets and failover
3. **Sharding (20%)** - Shard keys and cluster management
4. **Security (15%)** - Auth, roles, encryption
5. **Backup/Recovery (10%)** - Backup methods and restore
6. **Monitoring (10%)** - Metrics and profiling tools

### Key Areas to Master
- mongod.conf structure and key settings
- WiredTiger cache sizing and behavior
- Replica set election rules and priority
- Shard key selection criteria and trade-offs
- Authentication methods and built-in roles
- mongodump/mongorestore options

## ⚠️ Common Pitfalls

1. **WiredTiger cache is not total memory** - It uses 50% of RAM minus 1 GB by default
2. **Arbiter cannot hold data** - Only votes in elections
3. **Shard key cannot be changed** after collection is sharded (can refine with reshardCollection)
4. **Oplog is capped collection** - Fixed size, old entries removed automatically
5. **Read preference secondary** - May return stale data
6. **w: "majority" not w: "all"** - Majority is most common for strong consistency
7. **mongodump is not a snapshot** - Use with --oplog for consistency
8. **Hidden members can vote** - They just cannot be discovered by drivers
