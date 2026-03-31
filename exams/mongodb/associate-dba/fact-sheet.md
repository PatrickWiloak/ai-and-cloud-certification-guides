# MongoDB Associate DBA - Fact Sheet

## 📋 Exam Overview

**Exam Name:** MongoDB Associate DBA
**Duration:** 75 minutes
**Questions:** 62 multiple-choice questions
**Passing Score:** 65%
**Cost:** $150 USD
**Valid For:** 3 years
**Delivery:** Online proctored

**[📖 Official Certification Page](https://learn.mongodb.com/pages/certification)** - Registration and details
**[📖 MongoDB Administration Docs](https://www.mongodb.com/docs/manual/administration/)** - Admin reference
**[📖 MongoDB University](https://learn.mongodb.com/)** - Free learning resources

## 🎯 Target Audience

This certification is designed for:
- Database administrators managing MongoDB deployments
- System administrators responsible for MongoDB infrastructure
- DevOps engineers deploying and maintaining MongoDB
- Site reliability engineers ensuring MongoDB availability
- Professionals with 6+ months MongoDB administration experience

## 📚 Exam Domains

### Domain 1: Server Administration (25%)

**mongod Configuration:**
```yaml
# mongod.conf
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 4
    collectionConfig:
      blockCompressor: snappy

systemLog:
  destination: file
  path: /var/log/mongodb/mongod.log
  logAppend: true

net:
  port: 27017
  bindIp: 0.0.0.0

processManagement:
  fork: true
```

**WiredTiger Storage Engine:**
- Default storage engine since MongoDB 3.2
- Document-level concurrency control
- Compression: snappy (default), zlib, zstd, none
- Cache size: `max(256 MB, 50% of RAM - 1 GB)` by default
- Checkpoint interval: 60 seconds
- Journal: write-ahead log for durability

**Key Server Commands:**
- `db.serverStatus()` - Comprehensive server metrics
- `db.stats()` - Database statistics
- `db.collection.stats()` - Collection statistics
- `db.currentOp()` - Currently running operations
- `db.killOp(opId)` - Kill a running operation

**[📖 mongod Reference](https://www.mongodb.com/docs/manual/reference/program/mongod/)** - mongod documentation

### Domain 2: Replication (20%)

**Replica Set Configuration:**
```javascript
rs.initiate({
  _id: "myReplicaSet",
  members: [
    { _id: 0, host: "mongo1:27017", priority: 2 },
    { _id: 1, host: "mongo2:27017", priority: 1 },
    { _id: 2, host: "mongo3:27017", priority: 1 }
  ]
});
```

**Member Types:**
| Type | Votes | Can be Primary | Data | Purpose |
|------|-------|---------------|------|---------|
| Primary | 1 | Yes | Full | Read/write |
| Secondary | 1 | Yes | Full | Read replicas |
| Arbiter | 1 | No | None | Tiebreaker |
| Hidden | 1 | No | Full | Backup/reporting |
| Delayed | 1 | No | Full (delayed) | Rolling backup |
| Priority 0 | 1 | No | Full | Never primary |

**Read Preferences:**
| Mode | Description |
|------|-------------|
| `primary` | Read from primary only (default) |
| `primaryPreferred` | Primary, fallback to secondary |
| `secondary` | Read from secondary only |
| `secondaryPreferred` | Secondary, fallback to primary |
| `nearest` | Lowest latency member |

**Write Concerns:**
| Setting | Description |
|---------|-------------|
| `w: 1` | Primary acknowledgment (default) |
| `w: "majority"` | Majority of voting members |
| `w: <number>` | Specific number of members |
| `j: true` | Wait for journal commit |

**[📖 Replication](https://www.mongodb.com/docs/manual/replication/)** - Replication documentation

### Domain 3: Sharding (20%)

**Shard Key Selection Criteria:**
- **High cardinality** - Many unique values
- **Low frequency** - Values are evenly distributed
- **Non-monotonic** - Avoids hotspotting on one shard
- **Supports query patterns** - Included in common queries

**Sharding Types:**

| Type | Strategy | Pros | Cons |
|------|----------|------|------|
| Ranged | Values in ranges | Range queries efficient | Hotspots possible |
| Hashed | Hash of shard key | Even distribution | No range queries |
| Zone | Range + zone mapping | Data locality | Complex management |

**Sharding Commands:**
```javascript
// Enable sharding on database
sh.enableSharding("mydb");

// Shard a collection (ranged)
sh.shardCollection("mydb.orders", { customerId: 1 });

// Shard a collection (hashed)
sh.shardCollection("mydb.events", { eventId: "hashed" });

// Check sharding status
sh.status();
```

**[📖 Sharding](https://www.mongodb.com/docs/manual/sharding/)** - Sharding documentation

### Domain 4: Security (15%)

**Authentication Methods:**
| Method | Description |
|--------|-------------|
| SCRAM-SHA-256 | Default, password-based |
| x.509 | Certificate-based |
| LDAP | External directory service |
| Kerberos | Enterprise authentication |

**Built-in Roles:**

| Role | Level | Access |
|------|-------|--------|
| `read` | Database | Read all non-system collections |
| `readWrite` | Database | Read and write |
| `dbAdmin` | Database | Schema management, indexing |
| `userAdmin` | Database | User and role management |
| `clusterAdmin` | Cluster | Cluster administration |
| `root` | All | Superuser access |
| `backup` | Cluster | Backup operations |
| `restore` | Cluster | Restore operations |

**[📖 Security](https://www.mongodb.com/docs/manual/security/)** - Security documentation

### Domain 5: Backup and Recovery (10%)

**Backup Methods:**
| Method | Type | Consistent | Impact |
|--------|------|------------|--------|
| `mongodump` | Logical | Point-in-time with oplog | Some load |
| Filesystem snapshot | Physical | Yes (with journaling) | Low |
| Atlas Backup | Cloud | Continuous | None |
| Ops Manager | Managed | Continuous | Minimal |

**[📖 Backup Methods](https://www.mongodb.com/docs/manual/core/backups/)** - Backup documentation

### Domain 6: Monitoring (10%)

**Key Monitoring Tools:**
- `mongostat` - Real-time server statistics
- `mongotop` - Per-collection read/write time
- `db.serverStatus()` - Comprehensive metrics
- `db.currentOp()` - Running operations
- Database Profiler - Slow query analysis

**Critical Metrics:**

| Metric | Description | Concern |
|--------|-------------|---------|
| opcounters | Operation counts | Unusual spikes |
| connections.current | Active connections | Approaching limit |
| mem.resident | Resident memory | Exceeding available |
| wiredTiger.cache | Cache utilization | Cache pressure |
| repl.lag | Replication lag | Increasing lag |
| globalLock.activeClients | Active operations | Queue buildup |

**[📖 Monitoring](https://www.mongodb.com/docs/manual/administration/monitoring/)** - Monitoring documentation

## 🔑 Key Defaults to Remember

| Setting | Default |
|---------|---------|
| Port | 27017 |
| Max connections | 65536 |
| Max document size | 16 MB |
| WiredTiger cache | 50% of RAM - 1 GB |
| Oplog default size | 5% of free disk |
| Journal commit interval | 100 ms |
| Checkpoint interval | 60 seconds |
| Chunk size (sharding) | 128 MB |
| Balancer window | Always active |
| Write concern | w: 1 |
| Read preference | primary |
