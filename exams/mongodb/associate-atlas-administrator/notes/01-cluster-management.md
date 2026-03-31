# Cluster Management

**[📖 Atlas Cluster Configuration](https://www.mongodb.com/docs/atlas/cluster-config/)** - Cluster setup guide
**[📖 Atlas Cluster Tiers](https://www.mongodb.com/docs/atlas/cluster-tier/)** - Tier comparison

## Cluster Tiers

### Free and Shared Tiers

**M0 (Free Tier):**
- 512 MB storage
- Shared RAM and vCPU
- No backup, no VPC peering, no Performance Advisor
- Limited to 500 connections
- Limited to 100 databases and 500 collections
- Available in AWS, Azure, and GCP
- Good for learning and prototyping only

**M2 and M5 (Shared Tiers):**
- M2: 2 GB storage, M5: 5 GB storage
- Shared infrastructure
- Limited features compared to dedicated
- No VPC peering or private endpoints
- Basic metrics and alerting
- Good for small applications and development

### Dedicated Tiers (M10+)

**[📖 Dedicated Clusters](https://www.mongodb.com/docs/atlas/cluster-config/dedicated-clusters/)** - Dedicated cluster options

| Tier | vCPU | RAM | Default Storage | Use Case |
|------|------|-----|-----------------|----------|
| M10 | 2 | 2 GB | 10 GB | Development, testing |
| M20 | 2 | 4 GB | 20 GB | Small production |
| M30 | 2 | 8 GB | 40 GB | Production |
| M40 | 4 | 16 GB | 80 GB | Production |
| M50 | 8 | 32 GB | 160 GB | Large production |
| M60 | 16 | 64 GB | 320 GB | High performance |
| M80 | 32 | 128 GB | 750 GB | High performance |
| M140 | 48 | 192 GB | 1000 GB | Enterprise |
| M200 | 64 | 256 GB | 1500 GB | Enterprise |
| M300 | 96 | 384 GB | 2000 GB | Enterprise |
| M400-M700 | 96-96 | 488-768 GB | Custom | Ultra-high performance |

**M10+ Features:**
- Cloud backup with snapshots and PIT restore
- VPC peering and private endpoints
- Performance Advisor and Query Profiler
- Auto-scaling (compute and storage)
- Analytics nodes
- LDAP integration
- Encryption at rest with customer-managed keys
- Online Archive
- Real-Time Performance Panel

## Multi-Cloud Deployments

**[📖 Multi-Cloud Clusters](https://www.mongodb.com/docs/atlas/cluster-config/multi-cloud-multi-region/)** - Multi-cloud configuration

### Multi-Region Configuration
- Deploy replica set members across multiple regions
- Reduce read latency for geographically distributed users
- Provide disaster recovery across regions
- Configure node types per region:
  - **Electable nodes** - Can become primary (participate in elections)
  - **Read-only nodes** - Serve reads, never become primary
  - **Analytics nodes** - Isolated analytical workloads

### Node Types

**Electable Nodes:**
- Participate in elections and can become primary
- Majority must be in one region (prevents split-brain)
- Minimum 3 electable nodes for HA
- Can be 3, 5, or 7 electable nodes

**Read-Only Nodes:**
- Replicate data but never become primary
- Reduce read latency in remote regions
- Up to 7 read-only nodes per cluster
- Do not affect election outcomes

**Analytics Nodes:**
- Isolated from operational workload
- Target with `readPreferenceTags=nodeType:ANALYTICS`
- Can be different tier than electable nodes
- Up to 50 analytics nodes per cluster
- Do not participate in elections

### Global Clusters

**[📖 Global Clusters](https://www.mongodb.com/docs/atlas/global-clusters/)** - Global write clusters

- Zone-based sharding for data locality
- Write data to specific regions based on zone key
- Requires M30+ tier
- Configure zones mapped to regions
- Shard key must include a zone key field (e.g., country, region)
- Ensures data residency compliance (GDPR, data sovereignty)

## Auto-Scaling

**[📖 Auto-Scaling](https://www.mongodb.com/docs/atlas/cluster-autoscaling/)** - Auto-scaling configuration

### Compute Auto-Scaling
- Automatically scales cluster tier up or down
- Configure minimum and maximum tier
- Scaling based on CPU and memory utilization
- Cooldown period between scaling events (default: varies)
- Scaling is a rolling process (no downtime)
- Available for M10+ clusters

**Configuration:**
- Minimum tier: Set the floor (e.g., M30)
- Maximum tier: Set the ceiling (e.g., M60)
- Scale down: Enabled/disabled independently
- Operates within the same provider and region

### Storage Auto-Scaling
- Enabled by default on all dedicated clusters
- Automatically increases disk space when utilization is high
- Scales up when disk utilization exceeds threshold
- Does not scale down (storage only increases)
- No downtime during storage scaling

## Cluster Operations

### Creating a Cluster
- Choose cloud provider (AWS, Azure, GCP)
- Select region(s) for deployment
- Choose cluster tier and configuration
- Configure replication and backup
- Set up network access and database users

### Modifying a Cluster
- Tier changes are rolling (no downtime for most changes)
- Can change: tier, storage, IOPS, region configuration
- Cannot change: cloud provider (must create new cluster)
- Some changes require maintenance window

### Pausing a Cluster
- Pauses a running cluster (M10+)
- Stops billing for compute (storage still billed)
- Data preserved during pause
- Auto-resumes after 30 days if not manually resumed
- Connections not accepted while paused

### Terminating a Cluster
- Permanently deletes the cluster and all data
- Requires manual confirmation
- Backup snapshots retained per retention policy
- Cannot be undone

## Atlas CLI for Cluster Management

**[📖 Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/)** - CLI documentation

```bash
# Create a cluster
atlas clusters create myCluster \
  --provider AWS \
  --region US_EAST_1 \
  --tier M30 \
  --mdbVersion 7.0

# List clusters
atlas clusters list

# Describe a cluster
atlas clusters describe myCluster

# Update a cluster (scale up)
atlas clusters update myCluster --tier M40

# Pause a cluster
atlas clusters pause myCluster

# Resume a cluster
atlas clusters start myCluster

# Delete a cluster
atlas clusters delete myCluster

# Load sample data
atlas clusters sampleData load myCluster

# Watch cluster status
atlas clusters watch myCluster
```

## Cluster Metrics

### Key Metrics to Monitor

| Metric | Description | Concern |
|--------|-------------|---------|
| Connections | Active client connections | > 80% of limit |
| Operations | CRUD operations per second | Unexpected spikes |
| CPU | CPU utilization percentage | > 80% sustained |
| Memory | WiredTiger cache usage | > 90% |
| Disk IOPS | Read/write operations per second | Approaching limit |
| Disk Utilization | Storage space used | > 80% |
| Network | Bytes in/out | Bandwidth limits |
| Replication Lag | Seconds behind primary | > 60 seconds |
| Oplog Window | Hours of oplog retained | < 12 hours |
| Query Targeting | Scanned vs returned ratio | > 1000:1 |

### Connection String

```
mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/mydb?retryWrites=true&w=majority
```

- `+srv` format auto-discovers replica set members via DNS SRV records
- `retryWrites=true` enables automatic write retries
- `w=majority` configures majority write concern
- Connection string available in Atlas UI under "Connect"
