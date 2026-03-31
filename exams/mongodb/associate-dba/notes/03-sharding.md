# Sharding

**[📖 Sharding](https://www.mongodb.com/docs/manual/sharding/)** - Complete sharding documentation
**[📖 Shard Keys](https://www.mongodb.com/docs/manual/core/sharding-shard-key/)** - Shard key selection guide

## Sharded Cluster Architecture

### Components

**Config Servers:**
- Store cluster metadata (chunk ranges, shard locations)
- Deployed as a 3-member replica set
- Must use WiredTiger storage engine
- Default port: 27019
- Critical for cluster operation

**mongos Routers:**
- Route client requests to appropriate shard(s)
- Do not store data
- Cache config server metadata
- Multiple mongos for high availability
- Default port: 27017

**Shards:**
- Store the actual data
- Each shard is a replica set
- Data distributed across shards by shard key
- Default port: 27018

**[📖 Sharded Cluster Components](https://www.mongodb.com/docs/manual/core/sharded-cluster-components/)** - Architecture overview

### Deployment

```javascript
// Connect to mongos
mongosh --host mongos1:27017

// Enable sharding on a database
sh.enableSharding("mydb");

// Shard a collection (ranged)
sh.shardCollection("mydb.orders", { customerId: 1, orderDate: 1 });

// Shard a collection (hashed)
sh.shardCollection("mydb.events", { eventId: "hashed" });

// Check sharding status
sh.status();
```

## Shard Keys

### Shard Key Properties

**Good Shard Key Characteristics:**
1. **High Cardinality** - Many unique values for even distribution
2. **Low Frequency** - Values are evenly distributed (not skewed)
3. **Non-Monotonic** - Values do not increase/decrease monotonically
4. **Supports Common Queries** - Included in frequent query patterns

**Bad Shard Key Examples:**
- `{ _id: ObjectId }` - Monotonically increasing, all writes to last shard
- `{ status: 1 }` - Low cardinality (few unique values)
- `{ country: 1 }` - Skewed distribution (most users in few countries)
- Random field not in queries - Forces scatter-gather for every query

### Ranged Sharding

```javascript
sh.shardCollection("mydb.users", { lastName: 1 });
```

- Values are divided into contiguous ranges
- Each range assigned to a shard
- Efficient for range queries on shard key
- Risk of hotspots with monotonic keys
- Documents with close shard key values stored together

### Hashed Sharding

```javascript
sh.shardCollection("mydb.events", { _id: "hashed" });
```

- Hash function applied to shard key value
- More even data distribution
- No range query optimization on shard key
- Good for monotonically increasing keys (like ObjectId)
- Does not support compound shard keys (MongoDB 4.4+ allows hashed field in compound)

### Compound Shard Keys

```javascript
sh.shardCollection("mydb.orders", { customerId: 1, orderDate: 1 });
```

- First field provides coarse partitioning
- Additional fields provide finer distribution
- Supports queries on prefix fields
- Better cardinality than single field

### Shard Key Comparison

| Feature | Ranged | Hashed |
|---------|--------|--------|
| Distribution | Based on value ranges | Hash-based (uniform) |
| Range queries | Targeted | Broadcast |
| Monotonic keys | Hotspot risk | Even distribution |
| Compound key | Yes | Limited (4.4+) |
| Data locality | Close values together | Random distribution |

## Chunks

**[📖 Chunks](https://www.mongodb.com/docs/manual/core/sharding-data-partitioning/)** - Chunk management documentation

### Chunk Mechanics
- A chunk is a contiguous range of shard key values
- Default chunk size: 128 MB (configurable 1 MB - 1024 MB)
- MongoDB automatically splits chunks when they exceed the max size
- Chunks are distributed across shards by the balancer

### Chunk Operations

```javascript
// Check chunk size configuration
use config
db.settings.find({ _id: "chunksize" });

// Modify chunk size (in MB)
db.settings.updateOne(
  { _id: "chunksize" },
  { $set: { value: 64 } },
  { upsert: true }
);

// View chunk distribution
db.chunks.find({ ns: "mydb.orders" }).count();

// View chunk details
db.chunks.find({ ns: "mydb.orders" }).forEach(function(chunk) {
  print(chunk.shard + ": " + tojson(chunk.min) + " -> " + tojson(chunk.max));
});
```

### Chunk Splitting
- Automatic: when chunk size exceeds threshold during insert/update
- Manual: `sh.splitAt()` or `sh.splitFind()`
- Splitting is metadata-only (no data movement)
- Creates two chunks from one at the split point

### Jumbo Chunks
- Chunks that exceed the maximum size but cannot be split
- Occurs when too many documents have the same shard key value
- Marked as "jumbo" in chunk metadata
- Cannot be moved by the balancer
- Solution: choose a shard key with higher cardinality

## Balancer

**[📖 Balancer](https://www.mongodb.com/docs/manual/core/sharding-balancer-administration/)** - Balancer documentation

### Balancer Operation
- Background process that runs on config server primary
- Moves chunks between shards to achieve even distribution
- Triggers when chunk count difference between shards exceeds threshold
- Threshold varies by total chunk count (2 chunks for < 20, 8 for > 80)

### Balancer Management

```javascript
// Check balancer state
sh.getBalancerState();        // Is balancer enabled?
sh.isBalancerRunning();       // Is balancer currently active?

// Start/stop balancer
sh.startBalancer();
sh.stopBalancer();

// Set balancer window (only run during off-peak hours)
db.settings.updateOne(
  { _id: "balancer" },
  {
    $set: {
      activeWindow: { start: "23:00", stop: "06:00" }
    }
  },
  { upsert: true }
);

// Remove balancer window
db.settings.updateOne(
  { _id: "balancer" },
  { $unset: { activeWindow: "" } }
);
```

### Balancer Impact
- Chunk migration is resource-intensive (network, disk I/O)
- Use balancer windows for busy clusters
- Migration steps: copy data, apply oplog, commit, delete source
- `_secondaryThrottle` controls replication during migration
- `maxChunkSizeBytes` limits migration chunk size

## Zones (Tag-Based Sharding)

**[📖 Zones](https://www.mongodb.com/docs/manual/core/zone-sharding/)** - Zone sharding documentation

### Zone Configuration

```javascript
// Add tags to shards
sh.addShardTag("shard0001", "US");
sh.addShardTag("shard0002", "EU");
sh.addShardTag("shard0003", "APAC");

// Define zone ranges
sh.updateZoneKeyRange(
  "mydb.users",
  { region: "US", _id: MinKey },
  { region: "US", _id: MaxKey },
  "US"
);

sh.updateZoneKeyRange(
  "mydb.users",
  { region: "EU", _id: MinKey },
  { region: "EU", _id: MaxKey },
  "EU"
);

// Check zone configuration
sh.status();
```

### Zone Use Cases
- **Data locality** - Keep data in specific geographic regions
- **Hardware tiering** - Route hot data to SSD shards, cold to HDD
- **Compliance** - Keep sensitive data in specific jurisdictions
- **Workload isolation** - Separate read-heavy and write-heavy data

## Query Routing

### Targeted Queries
- Query includes the shard key (or prefix)
- mongos routes to specific shard(s)
- Most efficient query type
- Example: `db.orders.find({ customerId: "C123" })`

### Broadcast Queries (Scatter-Gather)
- Query does not include the shard key
- mongos sends query to all shards
- Results merged by mongos
- Less efficient but sometimes necessary
- Example: `db.orders.find({ status: "active" })` (if status is not shard key)

### Query Routing Summary

| Query Type | Includes Shard Key | Routing |
|------------|-------------------|---------|
| Exact match on shard key | Yes | Targeted to one shard |
| Range on shard key | Yes | Targeted to relevant shards |
| No shard key in query | No | Broadcast to all shards |
| Aggregation with $match on shard key | Yes | Targeted |
| Sort on shard key | Yes | Merge sort from targeted shards |

## Sharding Administration

### Resharding (MongoDB 5.0+)

```javascript
// Change shard key (resharding)
db.adminCommand({
  reshardCollection: "mydb.orders",
  key: { newShardKey: 1 }
});
```
- Introduced in MongoDB 5.0
- Allows changing the shard key of an existing collection
- Resource-intensive operation
- Creates new chunks with new key distribution

### Adding/Removing Shards

```javascript
// Add a shard (replica set)
sh.addShard("shard4/mongo4a:27018,mongo4b:27018,mongo4c:27018");

// Remove a shard (drains data first)
db.adminCommand({ removeShard: "shard0003" });
// Check drain status
db.adminCommand({ removeShard: "shard0003" });
```

### Monitoring Sharded Cluster

```javascript
// Overall status
sh.status();

// Balancer status
sh.getBalancerState();
sh.isBalancerRunning();

// Chunk distribution
db.chunks.aggregate([
  { $group: { _id: "$shard", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]);

// Migration history
use config
db.changelog.find({ what: "moveChunk.commit" }).sort({ time: -1 }).limit(10);
```
