# Replication

**[📖 Replication](https://www.mongodb.com/docs/manual/replication/)** - Complete replication documentation
**[📖 Replica Set Configuration](https://www.mongodb.com/docs/manual/reference/replica-configuration/)** - Configuration reference

## Replica Set Architecture

### Overview
- A replica set is a group of mongod instances maintaining the same data
- Provides redundancy, high availability, and read scalability
- Minimum recommended: 3 data-bearing members
- Maximum members: 50 (maximum 7 voting members)
- One primary receives all writes; secondaries replicate from primary

### Member Configuration

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

**Member Options:**

| Option | Default | Description |
|--------|---------|-------------|
| `priority` | 1 | Election priority (0 = cannot be primary) |
| `votes` | 1 | Voting participation (0 or 1) |
| `hidden` | false | Hidden from client discovery |
| `secondaryDelaySecs` | 0 | Delay in replication (delayed member) |
| `arbiterOnly` | false | Arbiter (no data) |
| `buildIndexes` | true | Build indexes on secondary |
| `tags` | {} | Custom tags for read preferences |

### Member Types

**Primary:**
- Receives all write operations
- Records all changes in its oplog
- Only one primary per replica set
- Elected by majority vote

**Secondary:**
- Replicates the primary's oplog
- Applies operations asynchronously
- Can serve read operations (with read preference)
- Can participate in elections

**Arbiter:**
- Does not hold data
- Participates in elections only (casts votes)
- Used to break ties in even-member sets
- Cannot become primary
- Uses minimal resources

**[📖 Replica Set Members](https://www.mongodb.com/docs/manual/core/replica-set-members/)** - Member types and roles

**Hidden Members:**
- Not visible to client applications
- Cannot be elected primary (priority must be 0)
- Do replicate data
- Useful for dedicated backup or reporting
- Still vote in elections

**Delayed Members:**
- Maintain a delayed copy of the data
- Act as a "rolling backup"
- Must be hidden and priority 0
- `secondaryDelaySecs` specifies the delay
- Useful for recovering from accidental operations

## Elections

**[📖 Replica Set Elections](https://www.mongodb.com/docs/manual/core/replica-set-elections/)** - Election process documentation

### Election Triggers
- Replica set initialization
- Primary stepdown (manual or automatic)
- Primary unreachable (heartbeat timeout)
- Adding a new member with higher priority
- Network partition

### Election Rules
- Majority of voting members must participate (N/2 + 1)
- Candidate must have the most recent oplog entry (or close to it)
- Higher priority members preferred (if data is up-to-date)
- Member with priority 0 cannot be elected
- Member must be reachable by the majority

### Heartbeat and Timeout
- Members send heartbeats every 2 seconds
- `electionTimeoutMillis` (default: 10000 / 10 sec) - Time before election starts
- If primary is unreachable for 10 seconds, election begins

### Election Scenarios

| Scenario (3 members) | Result |
|-----------------------|--------|
| Primary fails, 2 secondaries up | Election succeeds, new primary |
| Primary + 1 secondary fail | No election (1/3 is not majority) |
| Network partition: Primary alone | Primary steps down, other 2 elect |
| All same priority, primary fails | Most up-to-date secondary wins |

## Oplog

**[📖 Oplog](https://www.mongodb.com/docs/manual/core/replica-set-oplog/)** - Oplog documentation

### Oplog Mechanics
- Capped collection: `local.oplog.rs`
- Contains idempotent operations (replayable)
- Each operation is a single document in the oplog
- Secondaries continuously tail the oplog for new entries
- Initial sync copies data then continues from oplog

### Oplog Sizing
- Default: 5% of free disk space (minimum 990 MB, maximum 50 GB)
- Configure: `replication.oplogSizeMB` in mongod.conf
- Can resize without restart (MongoDB 4.0+):
  ```javascript
  db.adminCommand({ replSetResizeOplog: 1, size: 16384 })  // 16 GB
  ```

### Oplog Monitoring

```javascript
// Oplog information
rs.printReplicationInfo();
// Output: log length start to end (hours), oplog first/last event times

// Replication lag per member
rs.printSecondaryReplicationInfo();
// Output: sync source, seconds behind, timestamp

// Oplog size
use local
db.oplog.rs.stats().maxSize  // Max size in bytes
db.oplog.rs.stats().size     // Current size in bytes
```

### Oplog Operations
- Inserts: one oplog entry per document
- Updates: one oplog entry per affected document
- Deletes: one oplog entry per deleted document
- Multi-document operations are recorded as individual ops
- Idempotent: safe to replay multiple times

## Read Preferences

**[📖 Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)** - Read preference documentation

### Read Preference Modes

| Mode | Behavior |
|------|----------|
| `primary` | Read from primary only (default, strongest consistency) |
| `primaryPreferred` | Read from primary; if unavailable, read from secondary |
| `secondary` | Read from secondary only |
| `secondaryPreferred` | Read from secondary; if unavailable, read from primary |
| `nearest` | Read from the member with lowest network latency |

### Read Preference Tags
```javascript
// Configure member tags
cfg = rs.conf();
cfg.members[0].tags = { dc: "east", rack: "1" };
cfg.members[1].tags = { dc: "east", rack: "2" };
cfg.members[2].tags = { dc: "west", rack: "1" };
rs.reconfig(cfg);

// Read with tag set
db.collection.find().readPref("secondary", [{ dc: "east" }]);
```

### Considerations
- **Stale reads**: Secondaries may be behind the primary
- **Primary only**: Guaranteed latest data
- **Secondary**: May return stale data, reduces primary load
- **Nearest**: Best for geographically distributed clusters
- **Causal consistency**: Use sessions for "read your writes"

## Write Concerns

**[📖 Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)** - Write concern documentation

### Write Concern Options

| Setting | Description |
|---------|-------------|
| `w: 0` | No acknowledgment (fire and forget) |
| `w: 1` | Primary acknowledgment (default) |
| `w: 2` | Primary + 1 secondary acknowledgment |
| `w: "majority"` | Majority of voting members |
| `j: true` | Wait for journal commit |
| `wtimeout: <ms>` | Timeout for write concern |

### Interaction with Read Concern

**For strongest consistency:**
```javascript
// Write with majority concern
db.collection.insertOne(
  { data: "value" },
  { writeConcern: { w: "majority" } }
);

// Read with majority concern
db.collection.find().readConcern("majority");
```

### Write Concern Trade-offs

| Write Concern | Durability | Performance | Use Case |
|---------------|------------|-------------|----------|
| `w: 0` | None | Fastest | Logging, metrics |
| `w: 1` | Primary disk | Fast | General use |
| `w: 1, j: true` | Primary journal | Moderate | Important writes |
| `w: "majority"` | Majority members | Slower | Critical data |
| `w: "majority", j: true` | Majority journals | Slowest | Financial data |

## Replica Set Management

### Common Operations

```javascript
// Check replica set status
rs.status();

// Check configuration
rs.conf();

// Add a member
rs.add("mongo4:27017");
rs.add({ host: "mongo4:27017", priority: 0, hidden: true });

// Remove a member
rs.remove("mongo4:27017");

// Step down primary
rs.stepDown(60);  // Step down for 60 seconds

// Force reconfiguration
rs.reconfig(newConfig, { force: true });

// Set member priority
cfg = rs.conf();
cfg.members[0].priority = 2;
rs.reconfig(cfg);
```

### Initial Sync
- New member copies all data from an existing member
- Then applies oplog entries accumulated during sync
- Can take significant time for large datasets
- Member must have empty data directory or use `--resync`
- Source selection: closest secondary (or primary if needed)

### Maintenance Operations
- **Step down primary**: `rs.stepDown()` - graceful primary handoff
- **Freeze a member**: `rs.freeze(seconds)` - prevent election participation
- **Sync from specific member**: `db.adminCommand({replSetSyncFrom: "host:port"})`
- **Compact**: `db.runCommand({compact: "collection"})` - defragment collection
