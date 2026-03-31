# Backup and Monitoring

**[📖 Backup Methods](https://www.mongodb.com/docs/manual/core/backups/)** - Backup documentation
**[📖 Monitoring](https://www.mongodb.com/docs/manual/administration/monitoring/)** - Monitoring documentation

## Backup Methods

### mongodump and mongorestore

**[📖 mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)** - mongodump reference
**[📖 mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)** - mongorestore reference

**Basic Backup:**
```bash
# Backup entire instance
mongodump --host localhost:27017 --out /backup/$(date +%Y%m%d)

# Backup specific database
mongodump --db mydb --out /backup/

# Backup specific collection
mongodump --db mydb --collection users --out /backup/

# Backup with authentication
mongodump --host localhost:27017 --username admin --password secret \
  --authenticationDatabase admin --out /backup/

# Backup with oplog (point-in-time consistency for replica sets)
mongodump --oplog --out /backup/

# Compressed backup
mongodump --gzip --out /backup/

# Backup to archive file
mongodump --archive=/backup/mydb.archive --db mydb
```

**Restore:**
```bash
# Restore entire backup
mongorestore /backup/20240101/

# Restore specific database
mongorestore --db mydb /backup/20240101/mydb/

# Restore specific collection
mongorestore --db mydb --collection users /backup/20240101/mydb/users.bson

# Restore with oplog replay
mongorestore --oplogReplay /backup/

# Restore with oplog limit (point-in-time)
mongorestore --oplogReplay --oplogLimit "Timestamp(1704107340, 1)" /backup/

# Restore from archive
mongorestore --archive=/backup/mydb.archive

# Restore with drop (replace existing)
mongorestore --drop /backup/20240101/

# Restore from compressed backup
mongorestore --gzip /backup/
```

**Key Options:**

| Option | Description |
|--------|-------------|
| `--oplog` | Include oplog for consistent backup |
| `--oplogReplay` | Replay oplog during restore |
| `--oplogLimit` | Stop oplog replay at timestamp |
| `--gzip` | Compress/decompress BSON files |
| `--archive` | Write/read from archive file |
| `--drop` | Drop collections before restore |
| `--dryRun` | Show what would happen without doing it |
| `--numParallelCollections` | Parallel collection restore (default: 4) |
| `--query` | Filter documents during backup |
| `--excludeCollection` | Exclude specific collections |

### Oplog-Based Backup

**How It Works:**
1. `mongodump --oplog` captures oplog entries during backup
2. Provides point-in-time consistent backup for replica sets
3. On restore, `--oplogReplay` applies captured oplog entries
4. `--oplogLimit` stops replay at specific timestamp

**Point-in-Time Recovery:**
```bash
# Step 1: Restore from last backup
mongorestore --drop --oplogReplay --oplogLimit "Timestamp(1704107340, 1)" /backup/

# Timestamp format: Timestamp(seconds_since_epoch, ordinal)
# Use rs.printReplicationInfo() to find oplog timestamps
```

### Filesystem Snapshots

**Requirements:**
- Journaling must be enabled (default)
- Snapshot must capture the entire data directory
- For replica sets, snapshot while member is secondary (or locked)

**LVM Snapshot Example:**
```bash
# Lock writes (flush and lock)
mongosh --eval "db.fsyncLock()"

# Create LVM snapshot
lvcreate --size 100G --snapshot --name mongo-snap /dev/vg0/mongo-data

# Unlock writes
mongosh --eval "db.fsyncUnlock()"

# Mount snapshot and copy data
mount /dev/vg0/mongo-snap /mnt/snapshot
cp -r /mnt/snapshot/* /backup/
```

**Cloud Snapshots:**
- AWS EBS snapshots
- Azure Managed Disk snapshots
- GCP Persistent Disk snapshots
- Must be crash-consistent (journaling handles recovery)

### Backup Comparison

| Method | Type | Consistent | Speed | Impact | Granularity |
|--------|------|------------|-------|--------|-------------|
| mongodump | Logical | With --oplog | Moderate | I/O load | Collection-level |
| Filesystem snapshot | Physical | With journal | Fast | Brief lock | Full instance |
| Atlas Backup | Cloud | Continuous | N/A | Minimal | Point-in-time |
| Ops Manager | Managed | Continuous | N/A | Minimal | Point-in-time |

### Backup Best Practices
1. **Test restores regularly** - A backup is only useful if it can be restored
2. **Use --oplog** for replica set backups for consistency
3. **Store backups off-site** - Different region or cloud provider
4. **Automate backup scheduling** - Cron jobs or backup management tools
5. **Monitor backup completion** - Alert on failures
6. **Document recovery procedures** - Include steps and expected timelines
7. **Consider retention policies** - How long to keep backups

## Monitoring Tools

### mongostat

**[📖 mongostat](https://www.mongodb.com/docs/database-tools/mongostat/)** - mongostat reference

```bash
# Basic usage (updates every second)
mongostat --host localhost:27017

# With authentication
mongostat --host localhost:27017 --username admin --password secret \
  --authenticationDatabase admin

# Custom update interval (5 seconds)
mongostat --rowcount 0 5
```

**Key Columns:**

| Column | Description |
|--------|-------------|
| `insert` | Inserts per second |
| `query` | Queries per second |
| `update` | Updates per second |
| `delete` | Deletes per second |
| `getmore` | getMore operations (cursor batches) |
| `command` | Commands per second |
| `dirty` | WiredTiger dirty cache percentage |
| `used` | WiredTiger cache usage percentage |
| `vsize` | Virtual memory size |
| `res` | Resident memory size |
| `conn` | Current connections |
| `net_in` / `net_out` | Network I/O (bytes) |
| `qrw` | Queue: read/write |
| `arw` | Active: read/write |

### mongotop

**[📖 mongotop](https://www.mongodb.com/docs/database-tools/mongotop/)** - mongotop reference

```bash
# Show per-collection read/write time
mongotop --host localhost:27017

# Update interval (10 seconds)
mongotop 10

# Show locks instead of time
mongotop --locks
```

**Output Columns:**
- `ns` - Namespace (database.collection)
- `total` - Total time in collection
- `read` - Time spent reading
- `write` - Time spent writing

### db.serverStatus()

```javascript
// Full server status
db.serverStatus();

// Key sections:
const status = db.serverStatus();

// Connections
status.connections;
// { current: 42, available: 65494, totalCreated: 1500, active: 10 }

// Operations
status.opcounters;
// { insert: 1000, query: 5000, update: 2000, delete: 100, getmore: 500, command: 8000 }

// WiredTiger Cache
status.wiredTiger.cache;
// "bytes currently in the cache", "tracked dirty bytes in the cache"
// "pages read into cache", "pages written from cache"

// Locks
status.globalLock;
// { totalTime: ..., activeClients: { total: 10, readers: 5, writers: 5 }, currentQueue: { total: 0, readers: 0, writers: 0 } }

// Network
status.network;
// { bytesIn: ..., bytesOut: ..., numRequests: ... }

// Memory
status.mem;
// { bits: 64, resident: 4096, virtual: 8192, supported: true }
```

### db.currentOp()

```javascript
// All running operations
db.currentOp();

// Long-running operations
db.currentOp({ secs_running: { $gt: 10 } });

// Operations on specific database
db.currentOp({ ns: /^mydb\./ });

// Write operations only
db.currentOp({ op: { $in: ["insert", "update", "remove"] } });

// Waiting for lock
db.currentOp({ waitingForLock: true });

// Kill operation
db.killOp(opId);
```

### Database Profiler

```javascript
// Enable profiler (level 1 = slow queries)
db.setProfilingLevel(1, { slowms: 100 });

// Enable profiler (level 2 = all operations)
db.setProfilingLevel(2);

// Disable profiler
db.setProfilingLevel(0);

// Check profiler status
db.getProfilingStatus();

// Query profile data
db.system.profile.find({ millis: { $gt: 200 } }).sort({ ts: -1 });

// Find collection scans
db.system.profile.find({ planSummary: "COLLSCAN" }).sort({ millis: -1 });

// Find specific operation types
db.system.profile.find({ op: "query", ns: "mydb.users" }).sort({ ts: -1 });
```

## Performance Metrics

### Critical Metrics to Monitor

| Category | Metric | Concern |
|----------|--------|---------|
| Connections | `connections.current` | > 80% of max |
| Operations | `opcounters.*` | Unexpected changes |
| Queue | `globalLock.currentQueue` | > 0 sustained |
| Cache | `wiredTiger.cache.dirty` | > 20% |
| Cache | `wiredTiger.cache.used` | > 95% |
| Replication | `replSetGetStatus.lag` | Increasing |
| Disk | I/O utilization | > 80% |
| Memory | Resident memory | Exceeding available |
| Network | Bytes in/out | Approaching limit |

### Index Statistics

```javascript
// Index usage statistics
db.collection.aggregate([{ $indexStats: {} }]);
// Shows: accesses.ops (usage count), accesses.since (since when)

// Identify unused indexes (0 accesses)
db.collection.aggregate([
  { $indexStats: {} },
  { $match: { "accesses.ops": 0 } }
]);
```

### Collection Statistics

```javascript
db.collection.stats({ scale: 1048576 });  // In MB
// Key fields:
// size - data size
// storageSize - storage allocated
// nindexes - number of indexes
// totalIndexSize - total index size
// wiredTiger.cache - cache statistics
```

## Monitoring Best Practices

1. **Set up alerts** for critical metrics (connections, cache, lag, disk)
2. **Monitor trends** - Track metrics over time, not just current values
3. **Use profiler judiciously** - Level 2 adds overhead, use Level 1 for production
4. **Monitor replication lag** - Alert when lag exceeds acceptable threshold
5. **Track index usage** - Remove unused indexes
6. **Monitor disk space** - Data, oplog, and journal all use disk
7. **Set up dashboards** - Visualize key metrics with Grafana or similar
8. **Automate health checks** - Regular validation of cluster health
