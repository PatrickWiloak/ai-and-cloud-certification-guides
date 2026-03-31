# Monitoring, Alerts, and Backup

**[📖 Atlas Monitoring](https://www.mongodb.com/docs/atlas/monitoring-alerts/)** - Monitoring documentation
**[📖 Atlas Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)** - Backup documentation

## Monitoring Metrics

### Cluster Metrics Dashboard

**[📖 Cluster Metrics](https://www.mongodb.com/docs/atlas/monitor-cluster-metrics/)** - Metrics reference

**Connection Metrics:**
| Metric | Description |
|--------|-------------|
| Connections | Current number of open connections |
| Connection Pool Size | Total connections in the pool |
| Created Connections | New connections created per second |

**Operation Metrics:**
| Metric | Description |
|--------|-------------|
| Opcounters | Insert, query, update, delete, getmore, command rates |
| Document Metrics | Documents inserted, returned, updated, deleted |
| Operation Execution Time | Average execution time per operation type |

**Storage Metrics:**
| Metric | Description |
|--------|-------------|
| Data Size | Uncompressed logical data size |
| Storage Size | On-disk storage including compression |
| Index Size | Total index storage size |
| Disk IOPS | Read and write I/O operations per second |
| Disk Latency | Average disk operation latency |
| Disk Space Used | Percentage of provisioned disk used |

**Memory and Cache Metrics:**
| Metric | Description |
|--------|-------------|
| WiredTiger Cache Used | Percentage of cache in use |
| WiredTiger Dirty Cache | Percentage of dirty data in cache |
| System Memory | Total and available system memory |
| Page Faults | Number of page faults per second |

**Replication Metrics:**
| Metric | Description |
|--------|-------------|
| Replication Lag | Time behind primary (seconds) |
| Replication Headroom | Time before oplog window closes |
| Oplog Rate | Rate of oplog entries per hour |
| Oplog Window | Time range covered by the oplog |

**Network Metrics:**
| Metric | Description |
|--------|-------------|
| Bytes In | Network bytes received per second |
| Bytes Out | Network bytes sent per second |
| Num Requests | Number of requests per second |

### Viewing Metrics
- Atlas UI: Cluster > Metrics tab
- Real-Time Performance Panel: Live view of active operations
- Atlas CLI: `atlas metrics processes <hostname>:<port>`
- Atlas Admin API: GET /groups/{groupId}/processes/{processId}/measurements

### Time Granularity
| Period | Granularity |
|--------|-------------|
| Last hour | 10 seconds |
| Last 24 hours | 1 minute |
| Last 7 days | 5 minutes |
| Last 30 days | 1 hour |
| Last year | 1 day |

## Alerts

### Alert Configuration

**[📖 Alert Configuration](https://www.mongodb.com/docs/atlas/configure-alerts/)** - Alert setup guide

**Alert Components:**
1. **Target** - What to monitor (host, replica set, cluster)
2. **Condition** - Threshold or event trigger
3. **Notification** - How to notify (email, Slack, PagerDuty, webhook)

### Common Alert Conditions

**Host Alerts:**
| Condition | Recommended Threshold |
|-----------|----------------------|
| CPU % above | 80% for 10 minutes |
| Memory % above | 90% for 10 minutes |
| Disk % above | 80% |
| Connections % above | 80% of max |
| Page faults above | Baseline dependent |
| Query targeting above | 1000 (docs scanned/returned) |

**Replica Set Alerts:**
| Condition | Description |
|-----------|-------------|
| Replication lag above | Seconds behind primary |
| No primary detected | Primary election failed |
| Too few healthy members | Below quorum |

**Cluster Alerts:**
| Condition | Description |
|-----------|-------------|
| Cluster deleted | Cluster was terminated |
| Cluster scaled | Auto-scaling event occurred |

**Billing Alerts:**
| Condition | Description |
|-----------|-------------|
| Monthly bill estimate above | Spending threshold |
| Credit card expiring | Payment method expiring |

### Notification Channels

| Channel | Configuration |
|---------|---------------|
| Email | User email or team distribution list |
| Slack | Webhook URL or Slack integration |
| PagerDuty | Service key |
| Datadog | API key |
| VictorOps | API key and routing key |
| OpsGenie | API key |
| Webhook | Custom URL endpoint |
| Microsoft Teams | Webhook URL |

### Third-Party Integrations

**[📖 Integrations](https://www.mongodb.com/docs/atlas/tutorial/third-party-service-integrations/)** - Integration guide

| Integration | Type | Description |
|------------|------|-------------|
| Datadog | Monitoring | Push metrics to Datadog |
| New Relic | Monitoring | Push metrics to New Relic |
| Prometheus | Monitoring | Scrape endpoint for metrics |
| PagerDuty | Alerting | Incident management |
| Slack | Alerting | Channel notifications |
| Terraform | Automation | Infrastructure as code |

## Cloud Backup

### Overview

**[📖 Cloud Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)** - Backup overview

- Available for M10+ dedicated clusters
- Continuous backup using oplog for point-in-time recovery
- Automated snapshots on configurable schedule
- Stored in the same cloud provider and region as the cluster
- Encrypted at rest

### Snapshot Schedule

**Default Schedule:**
| Frequency | Retention |
|-----------|-----------|
| Every 6 hours | 2 days |
| Daily | 7 days |
| Weekly (Saturday) | 4 weeks |
| Monthly (last day) | 12 months |

**Customizable Settings:**
- Snapshot frequency (1, 2, 4, 6, 8, 12, or 24 hours)
- Retention period for each frequency
- Reference time zone
- Reference hour for daily snapshots

### Point-in-Time Restore

**[📖 PIT Restore](https://www.mongodb.com/docs/atlas/backup/cloud-backup/restore-from-continuous/)** - PIT restore guide

**How It Works:**
1. Atlas continuously captures oplog entries
2. Oplog window defines how far back you can restore
3. Restore to any second within the oplog window
4. Typically 24-hour oplog window

**Restore Options:**
| Option | Description |
|--------|-------------|
| Restore to same cluster | Overwrites current data |
| Restore to new cluster | Creates a new cluster with restored data |
| Download snapshot | Download BSON files for local restore |

**Restore Procedure:**
1. Navigate to Backup > Continuous Backup
2. Choose "Restore" and select restore type
3. For PIT: Select the exact date and time
4. For snapshot: Select a specific snapshot
5. Choose target (same cluster, new cluster, or download)
6. Confirm and start restore

### On-Demand Snapshots
- Trigger a snapshot at any time
- Useful before major operations (migrations, deployments)
- Counts toward snapshot retention
- Available via Atlas UI, CLI, or API

```bash
# Create on-demand snapshot via CLI
atlas backups snapshots create <clusterName> \
  --desc "Pre-deployment backup"
```

### Backup Compliance Policy

**[📖 Backup Compliance](https://www.mongodb.com/docs/atlas/backup/cloud-backup/backup-compliance-policy/)** - Compliance settings

**Features:**
- Prevent unauthorized backup deletion
- Enforce minimum retention periods
- Require point-in-time restore capability
- Prevent cluster deletion without backup

**Key Points:**
- Once enabled, cannot be disabled without support
- Applies to all clusters in the project
- Overrides individual cluster backup policies
- Requires Organization Owner to enable

### Backup for Sharded Clusters
- Snapshots capture all shards at the same point
- Atlas coordinates snapshot timing across shards
- Restore restores the entire sharded cluster
- Cannot restore individual shards

## Atlas CLI Monitoring Commands

```bash
# List processes
atlas processes list --projectId <projectId>

# Get process metrics
atlas metrics processes <hostname>:<port> \
  --granularity PT1M \
  --period PT24H \
  --type CONNECTIONS

# List alerts
atlas alerts list --projectId <projectId>

# Acknowledge alert
atlas alerts acknowledge <alertId>

# List backups
atlas backups snapshots list <clusterName>

# Restore from snapshot
atlas backups restores start <clusterName> \
  --snapshotId <snapshotId> \
  --targetClusterName <targetCluster>
```

## Monitoring Best Practices

1. **Configure alerts early** - Set up before production traffic
2. **Start with recommended alerts** - CPU, memory, disk, connections, replication lag
3. **Set appropriate thresholds** - Avoid alert fatigue from overly sensitive alerts
4. **Use multiple notification channels** - Email + Slack/PagerDuty for redundancy
5. **Monitor query targeting** - High ratios indicate missing indexes
6. **Track metrics over time** - Look for trends, not just current values
7. **Test restore procedures** - Regularly verify backup integrity
8. **Configure backup compliance** - For production workloads with compliance needs
9. **Use on-demand snapshots** - Before major changes
10. **Review and update alerts** - As workload patterns change
