# High-Yield Scenarios and Patterns

## Replication Scenarios

### Primary Failure and Election
**Scenario**: 3-node replica set (P, S1, S2). Primary fails. What happens?

**Expected Behavior**:
1. Secondaries detect primary failure (heartbeat timeout - 10 seconds)
2. Election triggered - remaining members vote
3. Member with highest priority (or most up-to-date) becomes primary
4. Clients automatically reconnect to new primary
5. When old primary recovers, it joins as secondary

**Configuration Impact:**
- `priority: 0` members cannot become primary
- `votes: 0` members cannot vote (max 7 voting members)
- Majority of voting members must agree (2 of 3)

**Common Distractors**:
- Arbiter becomes primary (wrong - arbiters cannot hold data)
- Election fails (wrong - 2 of 3 is majority)
- Manual intervention required (wrong - automatic failover)

### Read Preference Selection
**Scenario**: Application needs real-time reads for writes it just performed, but can use eventual consistency for other reads.

**Solution Pattern**:
- Use `readPreference: "primaryPreferred"` for consistency-sensitive reads
- Use `readPreference: "secondaryPreferred"` for analytics/reporting queries
- Use `readConcern: "majority"` for strong consistency
- Use causal consistency sessions for "read your writes" guarantee

**Common Distractors**:
- `secondary` for all reads (wrong - may miss recent writes)
- `primary` for all reads (wrong - unnecessary load on primary)
- No write concern needed (wrong - must acknowledge writes for consistency)

### Oplog Sizing Issue
**Scenario**: Secondary falls behind and cannot catch up because oplog entries it needs have been overwritten.

**Resolution**:
1. Resync the secondary: `rs.syncFrom("primary:27017")` or initial sync
2. Increase oplog size: `db.adminCommand({replSetResizeOplog: 1, size: 10240})` (10 GB)
3. Monitor replication lag: `rs.printReplicationInfo()`
4. Consider increasing oplog size based on write volume

**Prevention**:
- Size oplog to cover at least 24-48 hours of writes
- Monitor `repl.lag` metric
- Alert when lag exceeds threshold

## Sharding Scenarios

### Shard Key Selection
**Scenario**: E-commerce platform needs to shard the orders collection. Most queries filter by customerId with date ranges.

**Analysis of Options:**

| Shard Key | Pros | Cons |
|-----------|------|------|
| `{ customerId: 1 }` | Targeted queries by customer | Possible hotspot if some customers have many orders |
| `{ orderDate: 1 }` | Good range queries by date | Monotonically increasing - all writes to one shard |
| `{ customerId: 1, orderDate: 1 }` | Targeted customer queries, good distribution | Compound key, more complex |
| `{ customerId: "hashed" }` | Even distribution | No targeted range queries |

**Best Choice**: `{ customerId: 1, orderDate: 1 }` - supports common queries and provides reasonable distribution.

**Common Distractors**:
- `{ _id: 1 }` (wrong - ObjectId is monotonically increasing)
- `{ orderDate: 1 }` (wrong - monotonic, creates hotspot)
- Random field (wrong - no query benefit)

### Chunk Migration Issues
**Scenario**: Balancer is running but chunks are not migrating. Some shards have significantly more chunks.

**Diagnostic Steps**:
1. Check balancer status: `sh.getBalancerState()` and `sh.isBalancerRunning()`
2. Check for jumbo chunks: `db.chunks.find({jumbo: true})` in config database
3. Check balancer window: `sh.getBalancerWindow()`
4. Check migration errors: `db.actionlog.find()` in config database
5. Check chunk size: `db.settings.find({_id: "chunksize"})`

**Common Causes**:
- Jumbo chunks exceed max size and cannot be split or migrated
- Balancer window is too restrictive
- Config server issues
- Network problems between shards

**Common Distractors**:
- Increasing shard count (wrong - does not fix migration issues)
- Reducing chunk size (wrong - may cause more migrations, not fix root cause)
- Disabling balancer (wrong - makes problem worse)

### Zone-Based Sharding
**Scenario**: Global application needs European customer data to stay in EU data centers.

**Solution Pattern**:
```javascript
// Add zone to shards
sh.addShardTag("shard-eu-1", "EU");
sh.addShardTag("shard-eu-2", "EU");
sh.addShardTag("shard-us-1", "US");
sh.addShardTag("shard-us-2", "US");

// Shard with region field in key
sh.shardCollection("mydb.customers", { region: 1, customerId: 1 });

// Define zone ranges
sh.updateZoneKeyRange("mydb.customers",
  { region: "EU", customerId: MinKey },
  { region: "EU", customerId: MaxKey },
  "EU"
);
sh.updateZoneKeyRange("mydb.customers",
  { region: "US", customerId: MinKey },
  { region: "US", customerId: MaxKey },
  "US"
);
```

## Security Scenarios

### Enabling Authentication on Existing Deployment
**Scenario**: Production replica set needs authentication enabled with zero downtime.

**Solution Pattern**:
1. Create admin user with root role (while auth is disabled)
2. Set `security.transitionToAuth: true` in mongod.conf on all members
3. Rolling restart all members (allows both authenticated and unauthenticated connections)
4. Verify all clients are updated to use credentials
5. Remove `transitionToAuth` and set `security.authorization: enabled`
6. Final rolling restart

**Common Distractors**:
- Enable auth on all nodes simultaneously (wrong - causes outage)
- Skip the transition period (wrong - breaks existing connections)
- Only enable on primary (wrong - must be cluster-wide)

### Role-Based Access Control
**Scenario**: Team needs read access to all databases but write access only to their team database.

**Solution Pattern**:
```javascript
db.createUser({
  user: "team-member",
  pwd: "password",
  roles: [
    { role: "readAnyDatabase", db: "admin" },
    { role: "readWrite", db: "team-db" }
  ]
});

// Or create a custom role
db.createRole({
  role: "teamRole",
  privileges: [
    { resource: { db: "team-db", collection: "" }, actions: ["find", "insert", "update", "remove"] },
    { resource: { db: "", collection: "" }, actions: ["find"] }
  ],
  roles: []
});
```

## Backup and Recovery Scenarios

### Point-in-Time Recovery
**Scenario**: Accidental deletion of collection at 2:30 PM. Need to restore to 2:29 PM.

**Solution Pattern**:
1. Restore from most recent backup (before 2:30 PM):
   ```bash
   mongorestore --oplogReplay --oplogLimit "1704107340:1" dump/
   ```
2. Or use Atlas continuous backup with point-in-time restore
3. Or replay oplog entries from backup to target timestamp

**mongodump with oplog:**
```bash
# Backup with oplog for consistency
mongodump --oplog --out /backup/$(date +%Y%m%d)

# Restore with oplog replay to specific timestamp
mongorestore --oplogReplay --oplogLimit "Timestamp(1704107340, 1)" /backup/20240101/
```

### Backup Strategy for Sharded Cluster
**Scenario**: Design backup strategy for a 3-shard cluster.

**Solution Pattern**:
1. Stop the balancer: `sh.stopBalancer()`
2. Take consistent snapshots of all shards and config servers
3. Ensure all backups are taken at approximately the same time
4. Restart the balancer: `sh.startBalancer()`

**Alternative - Use mongodump:**
```bash
# Backup from mongos (includes all shards)
mongodump --host mongos1:27017 --oplog --out /backup/
```

## Monitoring Scenarios

### Diagnosing Slow Queries
**Scenario**: Application reports intermittent slow responses from MongoDB.

**Diagnostic Steps**:
1. Enable profiler: `db.setProfilingLevel(1, { slowms: 100 })`
2. Check slow queries: `db.system.profile.find().sort({ts: -1}).limit(10)`
3. Check current operations: `db.currentOp({"secs_running": {$gt: 5}})`
4. Analyze with explain: `db.collection.find({...}).explain("executionStats")`
5. Check mongostat for overall throughput and queue depth

**Common Causes**:
- Missing indexes (COLLSCAN in explain)
- Lock contention (queued operations in mongostat)
- Working set exceeds cache (cache evictions in serverStatus)
- Network latency (check replication lag)

### Connection Exhaustion
**Scenario**: Application logs show "connection refused" errors from MongoDB.

**Diagnostic Steps**:
1. Check current connections: `db.serverStatus().connections`
2. Check max connections: `db.adminCommand({getParameter: 1, maxIncomingConnections: 1})`
3. Check client connection pool settings
4. Look for connection leaks in application

**Resolution**:
- Increase `maxIncomingConnections` if needed
- Implement connection pooling in application
- Close idle connections
- Add read replicas to distribute connection load
