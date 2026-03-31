# Server Administration

**[📖 mongod Reference](https://www.mongodb.com/docs/manual/reference/program/mongod/)** - mongod process documentation
**[📖 Configuration Options](https://www.mongodb.com/docs/manual/reference/configuration-options/)** - Complete configuration reference

## mongod Process

### Starting mongod

**Command Line:**
```bash
mongod --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log \
  --port 27017 --bind_ip 0.0.0.0 --fork
```

**Configuration File:**
```bash
mongod --config /etc/mongod.conf
# or
mongod -f /etc/mongod.conf
```

### mongod.conf Structure

```yaml
# Storage configuration
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
    commitIntervalMs: 100
  directoryPerDB: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 4
      journalCompressor: snappy
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: snappy
    indexConfig:
      prefixCompression: true

# System logging
systemLog:
  destination: file
  path: /var/log/mongodb/mongod.log
  logAppend: true
  logRotate: reopen
  verbosity: 0
  component:
    command:
      verbosity: 1

# Network
net:
  port: 27017
  bindIp: 0.0.0.0
  maxIncomingConnections: 65536
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/ssl/mongodb.pem
    CAFile: /etc/ssl/ca.pem

# Process management
processManagement:
  fork: true
  pidFilePath: /var/run/mongodb/mongod.pid

# Security
security:
  authorization: enabled
  keyFile: /etc/mongodb/keyfile

# Replication
replication:
  replSetName: myReplicaSet
  oplogSizeMB: 10240

# Sharding
sharding:
  clusterRole: shardsvr  # or configsvr

# Profiling
operationProfiling:
  mode: slowOp
  slowOpThresholdMs: 100
```

### Key Configuration Sections

| Section | Purpose |
|---------|---------|
| `storage` | Data directory, journal, WiredTiger settings |
| `systemLog` | Log file location, rotation, verbosity |
| `net` | Port, bind IP, TLS, max connections |
| `processManagement` | Forking, PID file |
| `security` | Authentication, authorization, keyfile |
| `replication` | Replica set name, oplog size |
| `sharding` | Cluster role |
| `operationProfiling` | Profiler mode and threshold |

## WiredTiger Storage Engine

**[📖 WiredTiger](https://www.mongodb.com/docs/manual/core/wiredtiger/)** - Storage engine documentation

### Architecture

**Key Components:**
- **Internal Cache** - Working set data in memory
- **Journal** - Write-ahead log for durability
- **Checkpoints** - Consistent snapshots of data on disk
- **Compression** - On-disk data and index compression

### Cache Management

**Default Cache Size:**
```
50% of (RAM - 1 GB)
Minimum: 256 MB
```

**Configure Cache:**
```yaml
storage:
  wiredTiger:
    engineConfig:
      cacheSizeGB: 8
```

**Cache Monitoring:**
```javascript
db.serverStatus().wiredTiger.cache
// Key metrics:
// "bytes currently in the cache"
// "maximum bytes configured"
// "pages read into cache"
// "pages written from cache"
// "tracked dirty bytes in the cache"
// "unmodified pages evicted"
```

**Cache Pressure:**
- When dirty pages exceed 5% of cache, background eviction starts
- When dirty pages exceed 20%, application threads assist eviction
- Sudden cache pressure indicates working set exceeds cache size
- Solution: increase cache size or optimize queries to use less data

### Compression

| Target | Options | Default | Notes |
|--------|---------|---------|-------|
| Collection data | snappy, zlib, zstd, none | snappy | Balance of speed and ratio |
| Indexes | none, prefix | prefix | Prefix compression for indexes |
| Journal | snappy, zlib, zstd, none | snappy | Applied to journal records |

**Changing Compression:**
```javascript
// Per-collection compression
db.createCollection("myCollection", {
  storageEngine: {
    wiredTiger: {
      configString: "block_compressor=zstd"
    }
  }
});
```

- `snappy` - Fast compression, moderate ratio (default)
- `zlib` - Higher ratio, more CPU
- `zstd` - Best ratio at reasonable CPU
- `none` - No compression, fastest but most disk space

### Checkpoints

- WiredTiger creates checkpoints every 60 seconds
- A checkpoint is a consistent snapshot of data on disk
- Journal entries between checkpoints ensure durability
- If mongod crashes, recovery replays journal from last checkpoint
- `storage.syncPeriodSecs` (default: 60) - Not typically changed

### Journaling

**[📖 Journaling](https://www.mongodb.com/docs/manual/core/journaling/)** - Journaling documentation

- Write-ahead log (WAL) for crash recovery
- Enabled by default and should not be disabled in production
- Journal commit interval: 100 ms (default)
- With `j: true` write concern, wait for journal commit before acknowledging
- Journal files stored in `journal/` subdirectory of dbPath
- Recovery: replay journal entries after last checkpoint

**Journal Commit Interval:**
```yaml
storage:
  journal:
    commitIntervalMs: 100  # Default, reduce for lower durability gap
```

## mongos Process

**[📖 mongos Reference](https://www.mongodb.com/docs/manual/reference/program/mongos/)** - mongos documentation

```yaml
# mongos.conf
sharding:
  configDB: configReplicaSet/config1:27019,config2:27019,config3:27019

net:
  port: 27017
  bindIp: 0.0.0.0

security:
  keyFile: /etc/mongodb/keyfile

systemLog:
  destination: file
  path: /var/log/mongodb/mongos.log
```

**Key Differences from mongod:**
- No `storage` section (mongos does not store data)
- No `replication` section
- Must specify `configDB` connection string
- Routes queries to appropriate shards
- Multiple mongos instances for high availability

## Database Profiler

**[📖 Database Profiler](https://www.mongodb.com/docs/manual/tutorial/manage-the-database-profiler/)** - Profiler documentation

### Profiler Levels

| Level | Description |
|-------|-------------|
| 0 | Off (default) |
| 1 | Profile slow operations (> slowOpThresholdMs) |
| 2 | Profile all operations |

### Configuration

```javascript
// Set profiler level
db.setProfilingLevel(1, { slowms: 100 });

// Check current profiling level
db.getProfilingStatus();
// { was: 1, slowms: 100, sampleRate: 1 }

// Set with sample rate (profile 50% of slow ops)
db.setProfilingLevel(1, { slowms: 100, sampleRate: 0.5 });
```

### Querying Profile Data

```javascript
// Find slow queries
db.system.profile.find({ millis: { $gt: 200 } })
  .sort({ ts: -1 }).limit(10);

// Find collection scans
db.system.profile.find({ "planSummary": "COLLSCAN" })
  .sort({ millis: -1 });

// Find queries on specific collection
db.system.profile.find({ ns: "mydb.mycollection" })
  .sort({ ts: -1 }).limit(5);
```

**Profile Document Fields:**
| Field | Description |
|-------|-------------|
| `op` | Operation type (query, insert, update, etc.) |
| `ns` | Namespace (database.collection) |
| `millis` | Execution time in milliseconds |
| `ts` | Timestamp |
| `planSummary` | Query plan summary (IXSCAN, COLLSCAN) |
| `nreturned` | Number of documents returned |
| `docsExamined` | Number of documents examined |
| `keysExamined` | Number of index keys examined |
| `command` | The command that was profiled |

## Server Diagnostic Commands

### db.serverStatus()

```javascript
const status = db.serverStatus();

// Connection info
status.connections
// { current: 42, available: 65494, totalCreated: 1500 }

// Operations counters
status.opcounters
// { insert: 1000, query: 5000, update: 2000, delete: 100, command: 8000 }

// Memory info
status.mem
// { bits: 64, resident: 4096, virtual: 8192 }

// WiredTiger cache
status.wiredTiger.cache
// { "bytes currently in the cache": ..., "maximum bytes configured": ... }

// Replication info
status.repl
// { hosts: [...], setName: "rs0", primary: "host:27017", me: "host:27017" }
```

### db.currentOp()

```javascript
// All current operations
db.currentOp();

// Long-running operations (> 5 seconds)
db.currentOp({ "secs_running": { $gt: 5 } });

// Operations on specific namespace
db.currentOp({ "ns": "mydb.mycollection" });

// Kill a long-running operation
db.killOp(opId);
```

### db.stats() and Collection Stats

```javascript
// Database stats
db.stats();
// { db: "mydb", collections: 10, objects: 50000, dataSize: ..., storageSize: ..., indexes: 25, indexSize: ... }

// Collection stats
db.collection.stats();
// { count: 10000, size: ..., storageSize: ..., nindexes: 3, totalIndexSize: ... }

// Collection stats with scale
db.collection.stats({ scale: 1048576 });  // In MB
```

## Log Management

### Log Configuration

```yaml
systemLog:
  destination: file
  path: /var/log/mongodb/mongod.log
  logAppend: true
  logRotate: reopen  # or rename
  verbosity: 0
  component:
    accessControl:
      verbosity: 1
    command:
      verbosity: 0
    replication:
      verbosity: 1
    storage:
      verbosity: 0
```

### Log Rotation

```javascript
// Trigger log rotation
db.adminCommand({ logRotate: 1 });
```

**With logRotate: reopen:**
- MongoDB closes and reopens the log file
- External tool (logrotate) handles file rename
- Send SIGUSR1 to rotate

**With logRotate: rename:**
- MongoDB renames the file and opens a new one
- Simpler but less flexible

### Structured Logging (MongoDB 4.4+)
- Logs in JSON format by default
- Machine-parseable for log aggregation tools
- Component-based verbosity control
- Log messages have severity levels: F, E, W, I, D1-D5

### Key Log Messages to Watch
- `"msg":"Slow query"` - Slow operations
- `"msg":"Connection accepted"` / `"Connection ended"` - Connection lifecycle
- `"msg":"Transition"` - Replica set state changes
- `"msg":"WiredTiger"` - Storage engine events
- `"msg":"authentication"` - Authentication attempts
