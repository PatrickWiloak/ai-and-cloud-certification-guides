# MongoDB Associate Atlas Administrator - Fact Sheet

## 📋 Exam Overview

**Exam Name:** MongoDB Associate Atlas Administrator
**Duration:** 75 minutes
**Questions:** 62 multiple-choice questions
**Passing Score:** 65%
**Cost:** $150 USD
**Valid For:** 3 years
**Delivery:** Online proctored

**[📖 Official Certification Page](https://learn.mongodb.com/pages/certification)** - Registration and details
**[📖 Atlas Documentation](https://www.mongodb.com/docs/atlas/)** - Complete Atlas reference
**[📖 MongoDB University](https://learn.mongodb.com/)** - Free learning resources

## 🎯 Target Audience

This certification is designed for:
- Cloud database administrators managing Atlas deployments
- DevOps engineers responsible for Atlas infrastructure
- Solutions architects designing Atlas-based architectures
- Platform engineers building self-service database platforms
- Professionals with 6+ months Atlas administration experience

## 📚 Exam Domains

### Domain 1: Cluster Management (25%)

**Cluster Tiers:**

| Tier | Type | Storage | RAM | Use Case |
|------|------|---------|-----|----------|
| M0 | Free shared | 512 MB | Shared | Learning, prototyping |
| M2 | Shared | 2 GB | Shared | Small apps |
| M5 | Shared | 5 GB | Shared | Small apps |
| M10 | Dedicated | 10 GB | 2 GB | Development |
| M20 | Dedicated | 20 GB | 4 GB | Small production |
| M30 | Dedicated | 40 GB | 8 GB | Production |
| M40 | Dedicated | 80 GB | 16 GB | Production |
| M50 | Dedicated | 160 GB | 32 GB | Large production |
| M60+ | Dedicated | 320 GB+ | 64 GB+ | Enterprise |
| M80-M700 | Dedicated | Custom | 128-768 GB | High performance |

**Shared vs Dedicated:**
- M0/M2/M5: Shared infrastructure, limited features
- M10+: Dedicated infrastructure, full feature set
- M10 minimum for: backup, VPC peering, private endpoints, sharding

**[📖 Cluster Tiers](https://www.mongodb.com/docs/atlas/cluster-tier/)** - Tier comparison

**Multi-Cloud and Multi-Region:**
- Deploy across AWS, Azure, and GCP simultaneously
- Multi-region deployments for HA and low latency
- Global Clusters for data locality (zone sharding)
- Cross-region replication for disaster recovery

**Auto-Scaling:**
- **Compute auto-scaling** - Automatically adjusts cluster tier up/down
- **Storage auto-scaling** - Automatically increases disk space (enabled by default)
- Configurable scaling limits (min/max tier)
- Cooldown period between scaling events

**[📖 Auto-Scaling](https://www.mongodb.com/docs/atlas/cluster-autoscaling/)** - Auto-scaling configuration

### Domain 2: Security and Access (20%)

**Network Security:**

| Feature | Description | Minimum Tier |
|---------|-------------|-------------|
| IP Access List | Allow specific IPs/CIDR ranges | All tiers |
| VPC Peering | Private network connection | M10+ |
| AWS PrivateLink | Private endpoint (AWS) | M10+ |
| Azure Private Link | Private endpoint (Azure) | M10+ |
| GCP Private Service Connect | Private endpoint (GCP) | M10+ |

**Database Users:**
- SCRAM authentication (username/password)
- x.509 certificate authentication
- AWS IAM authentication
- LDAP authentication (M10+)
- Custom database roles

**Atlas Organization Structure:**
- **Organization** - Top level, billing entity
- **Project** - Groups clusters, users, and settings
- **Cluster** - The actual MongoDB deployment

**API Keys:**
- Organization-level and project-level API keys
- Programmatic access for automation
- IP access list for API keys
- Used with Atlas CLI and Admin API

**[📖 Atlas Security](https://www.mongodb.com/docs/atlas/security/)** - Security documentation

### Domain 3: Data Management (20%)

**Atlas Search:**
- Full-text search powered by Lucene
- Search indexes on Atlas collections
- $search aggregation stage
- Autocomplete, fuzzy, compound queries

**Performance Advisor:**
- Analyzes slow queries (M10+ clusters)
- Suggests index creation
- Shows index usage and recommendations
- Identifies redundant indexes

**Data Explorer:**
- Browse collections and documents in Atlas UI
- Run queries and aggregations
- Insert, edit, and delete documents
- View collection statistics

**Online Archive:**
- Automatically archive infrequently accessed data
- Data moved to cheaper cloud storage
- Queryable alongside live data using Data Federation
- Archiving rules based on date or custom criteria

**[📖 Performance Advisor](https://www.mongodb.com/docs/atlas/performance-advisor/)** - Performance optimization

### Domain 4: Performance (15%)

**Key Performance Features:**
- Real-Time Performance Panel - Live view of active operations
- Query Profiler - Analyze slow queries
- Performance Advisor - Index suggestions
- Cluster Metrics - Historical performance data

### Domain 5: Monitoring and Alerts (10%)

**Built-in Metrics:**
- Connections, operations, network I/O
- Disk utilization, IOPS, latency
- CPU utilization, memory usage
- Replication lag, oplog window
- Cache utilization

**Alert Configuration:**
- Pre-configured alerts for common issues
- Custom alert conditions on any metric
- Notification channels: email, Slack, PagerDuty, webhooks

**[📖 Atlas Monitoring](https://www.mongodb.com/docs/atlas/monitoring-alerts/)** - Monitoring documentation

### Domain 6: Backup and Restore (10%)

**Snapshot Policies:**
- Hourly snapshots (configurable retention)
- Daily snapshots (configurable retention)
- Weekly snapshots (configurable retention)
- Monthly snapshots (configurable retention)
- On-demand snapshots

**Point-in-Time Restore:**
- Restore to any second within the oplog window
- Available for M10+ dedicated clusters
- Restores to a new cluster or existing
- Oplog window typically 24 hours

**[📖 Atlas Backup](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)** - Backup documentation

## 🔑 Key Facts to Remember

| Feature | Minimum Tier |
|---------|-------------|
| Cloud Backup | M10 |
| VPC Peering | M10 |
| Private Endpoints | M10 |
| Sharding | M30 |
| Analytics Nodes | M10 |
| Performance Advisor | M10 |
| Query Profiler | M10 |
| Auto-Scaling (compute) | M10 |
| LDAP Integration | M10 |
| Encryption at Rest (CMK) | M10 |
| Online Archive | M10 |
| Global Clusters | M30 |
