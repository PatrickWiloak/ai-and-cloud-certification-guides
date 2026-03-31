# High-Yield Scenarios and Patterns

## Cluster Operations Scenarios

### Broker Decommissioning
**Scenario**: Need to remove a broker from a 5-broker cluster without data loss or downtime.

**Solution Pattern**:
1. Generate reassignment plan: `kafka-reassign-partitions --generate --broker-list "1,2,3,4"` (exclude broker 5)
2. Execute reassignment: `kafka-reassign-partitions --execute --reassignment-json-file plan.json`
3. Verify completion: `kafka-reassign-partitions --verify --reassignment-json-file plan.json`
4. Monitor replication until all partitions are fully replicated
5. Stop the broker process after all partitions are moved
6. Remove broker configuration

**Common Distractors**:
- Stopping the broker first (wrong - causes under-replicated partitions)
- Only moving leader partitions (wrong - must move all replicas)
- Reducing replication factor instead (wrong - reduces durability)

### Rolling Upgrade from 3.4 to 3.5
**Scenario**: Upgrade a 3-broker cluster from Kafka 3.4 to 3.5 with zero downtime.

**Solution Pattern**:
1. Set `inter.broker.protocol.version=3.4` in server.properties on all brokers
2. Upgrade broker binary on broker 1, restart
3. Verify broker 1 is healthy and ISR is stable
4. Repeat for broker 2, then broker 3
5. After all brokers are running 3.5, set `inter.broker.protocol.version=3.5`
6. Rolling restart all brokers again

**Common Distractors**:
- Upgrading all brokers simultaneously (wrong - causes full cluster outage)
- Setting new protocol version before upgrading all brokers (wrong - incompatible)
- Skipping the second rolling restart (wrong - protocol version change needs restart)

### Partition Count Increase
**Scenario**: Topic with 6 partitions needs more throughput; consumer group has 12 instances.

**Solution Pattern**:
- Increase partitions: `kafka-topics --alter --topic my-topic --partitions 12`
- 6 consumers were idle before, now all 12 have work
- Warning: key-based routing will change for some existing keys
- New messages with existing keys may go to different partitions

**Common Distractors**:
- Adding more consumers beyond 12 (wrong - still limited by partition count)
- Decreasing partitions for optimization (wrong - cannot decrease partitions)
- Creating a new topic (wrong - unnecessary, can increase partitions in place)

## Monitoring and Troubleshooting Scenarios

### Under-Replicated Partitions
**Scenario**: Alerts show 20 under-replicated partitions across the cluster.

**Diagnostic Steps**:
1. Check which brokers host the under-replicated partitions
2. Check broker logs for errors (disk I/O, network, GC pauses)
3. Monitor `IsrShrinksPerSec` and `IsrExpandsPerSec`
4. Check disk space and I/O utilization on affected brokers
5. Check network connectivity between brokers
6. Verify `replica.lag.time.max.ms` is not too aggressive

**Common Causes**:
- Disk I/O saturation on follower brokers
- Network issues between brokers
- Long GC pauses on follower brokers
- Broker overloaded with too many partitions
- Follower falling behind due to slow disk

**Resolution**:
- Fix underlying resource issue (disk, network, memory)
- Reassign partitions to less loaded brokers
- Increase `replica.lag.time.max.ms` temporarily (masks issue, not a fix)

**Common Distractors**:
- Restarting all brokers (wrong - disruptive, may not fix root cause)
- Reducing replication factor (wrong - reduces durability)
- Increasing partition count (wrong - unrelated to replication issues)

### High Consumer Lag
**Scenario**: Consumer group shows increasing lag across all partitions, lag growing over time.

**Diagnostic Steps**:
1. Check `kafka-consumer-groups --describe` for lag per partition
2. Verify consumer processing time per message
3. Check `max.poll.interval.ms` for rebalance issues
4. Monitor consumer commit rate and rebalance frequency
5. Check if consumers are blocked on external dependencies

**Resolution Approaches**:
- Increase `max.poll.records` if processing is fast per record
- Add more consumers (up to partition count)
- Increase partitions if consumer count is at limit
- Optimize consumer processing logic
- Check for rebalance storms (frequent rebalances waste time)

**Common Distractors**:
- Adding consumers beyond partition count (wrong - extras are idle)
- Reducing `session.timeout.ms` (wrong - causes more rebalances)
- Increasing `fetch.max.wait.ms` (wrong - delays fetching)

### Controller Election Issues
**Scenario**: `ActiveControllerCount` metric shows 0 across all brokers intermittently.

**Diagnostic Steps**:
1. Check ZooKeeper/KRaft connectivity from all brokers
2. Review broker logs for controller election failures
3. Check ZooKeeper session timeouts and latency
4. Verify network stability between brokers and ZooKeeper
5. Check ZooKeeper logs for session expiration events

**Common Causes**:
- ZooKeeper session expiration due to GC pauses
- Network partitions between brokers and ZooKeeper
- ZooKeeper overloaded or unhealthy
- Broker JVM issues causing long pauses

**Common Distractors**:
- Restarting Kafka brokers only (wrong - may be a ZooKeeper issue)
- Increasing partition count (wrong - unrelated)
- Changing `min.insync.replicas` (wrong - unrelated to controller)

## Security Scenarios

### Enabling Authentication on Existing Cluster
**Scenario**: Production cluster currently uses PLAINTEXT; need to add SASL/SCRAM authentication.

**Solution Pattern**:
1. Create SCRAM credentials: `kafka-configs --alter --add-config 'SCRAM-SHA-256=[password=secret]' --entity-type users --entity-name admin`
2. Configure brokers to listen on both PLAINTEXT and SASL_SSL:
   - `listeners=PLAINTEXT://0.0.0.0:9092,SASL_SSL://0.0.0.0:9093`
   - `inter.broker.listener.name=SASL_SSL`
3. Rolling restart brokers with dual listeners
4. Migrate clients to use SASL_SSL on port 9093
5. After all clients migrated, remove PLAINTEXT listener
6. Final rolling restart

**Common Distractors**:
- Switching directly to SASL_SSL only (wrong - breaks existing clients)
- Using SASL/PLAIN without SSL (wrong - passwords sent in cleartext)
- Skipping inter-broker authentication (wrong - incomplete security)

### ACL Configuration for Multi-Team Access
**Scenario**: Two teams need isolated access to their topics with shared read access to a common topic.

**Solution Pattern**:
```bash
# Team A - full access to team-a-* topics
kafka-acls --add --allow-principal User:team-a --operation All \
  --topic team-a --resource-pattern-type prefixed

# Team B - full access to team-b-* topics
kafka-acls --add --allow-principal User:team-b --operation All \
  --topic team-b --resource-pattern-type prefixed

# Both teams - read access to shared topic
kafka-acls --add --allow-principal User:team-a --operation Read --topic shared-events
kafka-acls --add --allow-principal User:team-b --operation Read --topic shared-events

# Both teams - consumer group access
kafka-acls --add --allow-principal User:team-a --operation Read --group team-a-group
kafka-acls --add --allow-principal User:team-b --operation Read --group team-b-group
```

**Common Distractors**:
- Using wildcard ACLs (wrong - too permissive)
- Forgetting consumer group ACLs (wrong - consumers cannot commit offsets)
- Using DENY ACLs only (wrong - default is deny, need ALLOW entries)

## Confluent Platform Scenarios

### Schema Registry High Availability
**Scenario**: Schema Registry must survive single node failure without impact.

**Solution Pattern**:
- Deploy 3+ Schema Registry instances
- Configure all instances with same `schema.registry.group.id`
- Place behind a load balancer (leader handles writes, any handles reads)
- Set `master.eligibility=true` on all instances
- Monitor leader election and failover

**Common Distractors**:
- Single instance with backup (wrong - downtime during failover)
- Multiple instances with different group IDs (wrong - independent clusters)
- Active-active writes (wrong - only leader accepts writes)

### Connect Worker Failure
**Scenario**: One of three Connect workers fails; connectors and tasks need to continue.

**Expected Behavior**:
- Distributed mode automatically rebalances tasks to surviving workers
- Tasks from failed worker are redistributed
- Connectors continue without manual intervention
- When failed worker recovers, tasks rebalance again

**What to Monitor**:
- Connector status via REST API: `GET /connectors/{name}/status`
- Task status: look for FAILED tasks that need restart
- Worker logs for rebalance events
- Consumer lag on Connect internal topics

**Common Distractors**:
- Manual task reassignment required (wrong - automatic in distributed mode)
- All connectors stop (wrong - only affected tasks rebalance)
- Standalone mode handles this (wrong - no fault tolerance in standalone)

## Capacity Planning Scenarios

### Disk Sizing
**Scenario**: Calculate disk requirements for a topic with 100 MB/s throughput, RF=3, 7-day retention.

**Calculation**:
- Data per day: 100 MB/s x 86400 seconds = 8.64 TB/day
- With RF=3: 8.64 TB x 3 = 25.92 TB/day across cluster
- 7-day retention: 25.92 TB x 7 = 181.44 TB total
- Per broker (3 brokers): 181.44 TB / 3 = 60.48 TB per broker
- Add 20% buffer: ~72.6 TB per broker

**Common Distractors**:
- Forgetting replication factor in calculation (wrong - each replica uses disk)
- Using uncompressed size with compression enabled (wrong - compressed on disk)
- Not accounting for log segment overhead (wrong - indexes and metadata use space)

### Broker Count Planning
**Scenario**: Need to handle 500 MB/s aggregate throughput with RF=3.

**Considerations**:
- Network bandwidth per broker (typically 1-10 Gbps)
- With RF=3, each message is written 3 times (leader + 2 followers)
- Actual network usage: 500 MB/s produce + 500 MB/s x 2 replication = 1.5 GB/s
- Plus consumer fetch traffic
- Minimum 5 brokers for distribution and fault tolerance
- Consider disk I/O capacity per broker
