# MongoDB Associate Atlas Administrator - Fact Sheet

## Exam Overview

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

## Target Audience

This certification is designed for:
- Cloud database administrators managing Atlas deployments
- DevOps engineers automating Atlas infrastructure
- Operations engineers responsible for Atlas clusters
- Architects designing Atlas-based solutions
- Professionals with 6+ months Atlas administration experience

## Exam Domains

### Domain 1: Cluster Management (25%)

**Cluster Tiers:**
| Tier | Type | Description |
|------|------|-------------|
| M0 | Free | 512 MB storage, shared resources, limited features |
| M2/M5 | Shared | Low-cost shared clusters for development |
| M10/M20 | Dedicated | Production-ready, full feature support |
| M30-M700 | Dedicated | High-performance, large-scale workloads |

**Key Cluster Features:**
- **Multi-cloud** - Deploy across AWS, Azure, and GCP
- **Multi-region** - Replicate across geographic regions
- **Auto-scaling** - Compute and storage auto-scaling
- **Electable nodes** - Participate in elections (3, 5, or 7)
- **Analytics nodes** - Isolated read workloads (no election)
- **Read-only nodes** - Cross-region read replicas

**Cluster Operations:**
- Cluster creation, modification, and termination
- Tier upgrades and downgrades (no downtime for M10+)
- Cluster pause/resume (saves cost during inactivity)
- Rolling maintenance windows

**[📖 Cluster Configuration](https://www.mongodb.com/docs/atlas/cluster-config/multi-cloud-distribution/)** - Cluster setup guide

### Domain 2: Security and Access (20%)

**Authentication Methods:**
| Method | Description |
|--------|-------------|
| SCRAM | Default username/password authentication |
| x.509 | Certificate-based authentication |
| LDAP | Enterprise LDAP directory integration |
| AWS IAM | AWS IAM role-based authentication |

**Network Security:**
| Feature | Description |
|---------|-------------|
| IP Access List | Allow connections from specific IPs/CIDRs |
| VPC Peering | Private network connection to your VPC |
| AWS PrivateLink | Private endpoint (no public internet) |
| Azure Private Link | Azure private endpoint |
| GCP Private Service Connect | GCP private endpoint |

**Atlas Organization Structure:**
- **Organization** - Top-level entity, billing, and users
- **Project** - Container for clusters, teams, and settings
- **Teams** - Groups of users with shared project access
- **API Keys** - Programmatic access at org or project level

**Built-in Atlas Roles:**
| Role | Description |
|------|-------------|
| Organization Owner | Full organization control |
| Organization Member | View organization, access assigned projects |
| Project Owner | Full project control |
| Project Cluster Manager | Create and manage clusters |
| Project Data Access Admin | Manage database users and access |
| Project Read Only | View-only access |

**[📖 Atlas Security](https://www.mongodb.com/docs/atlas/security/)** - Security documentation

### Domain 3: Data Management (20%)

**Atlas Search:**
- Full-text search powered by Apache Lucene
- Create and manage search indexes via Atlas UI or API
- Access via `$search` aggregation stage
- Supports autocomplete, fuzzy matching, faceted search

**Data Federation:**
- Query data across Atlas clusters and cloud storage (S3, Azure Blob)
- Federated database instances for cross-source queries
- No data movement required

**Online Archive:**
- Automatically archive infrequently accessed data
- Archive rules based on date criteria
- Query archived data alongside live data via Data Federation
- Reduces cluster storage costs

**Data Explorer:**
- Browse collections and documents in Atlas UI
- Run queries and aggregation pipelines
- Insert, edit, and delete documents

**[📖 Atlas Search](https://www.mongodb.com/docs/atlas/atlas-search/)** - Search documentation

### Domain 4: Performance (15%)

**Performance Advisor:**
- Suggests indexes based on slow queries
- Identifies drop index recommendations
- Available for M10+ clusters
- Analyzes queries from the last 24 hours

**Real-Time Performance Panel:**
- Active operations and their duration
- Query targeting (documents scanned vs returned)
- Hottest collections

**Index Management:**
- Create, drop, and manage indexes via Atlas UI
- Rolling index builds (no downtime on M10+)
- Index suggestions from Performance Advisor

**[📖 Performance Advisor](https://www.mongodb.com/docs/atlas/performance-advisor/)** - Performance recommendations

### Domain 5: Monitoring and Alerts (10%)

**Monitoring Metrics:**
| Category | Key Metrics |
|----------|-------------|
| Connections | Current, available, created |
| Operations | Insert, query, update, delete rates |
| Storage | Data size, index size, disk usage |
| Cache | WiredTiger cache usage and dirty percentage |
| Replication | Replication lag, oplog window |
| Network | Bytes in/out, request count |

**Alert Types:**
- Host-level alerts (CPU, memory, disk, connections)
- Replica set alerts (election, replication lag)
- Custom metric alerts (thresholds and conditions)
- Billing alerts (spending thresholds)

**Integrations:**
- PagerDuty, Slack, email notifications
- Datadog, New Relic, Prometheus integration
- Webhook-based custom integrations

**[📖 Atlas Monitoring](https://www.mongodb.com/docs/atlas/monitoring-alerts/)** - Monitoring documentation

### Domain 6: Backup and Restore (10%)

**Cloud Backup (M10+):**
| Feature | Description |
|---------|-------------|
| Continuous Backup | Oplog-based continuous backup |
| Snapshots | Configurable snapshot schedule |
| PIT Restore | Restore to any second within retention |
| Cross-Region | Restore to different region |
| Retention | Configurable per frequency (hourly/daily/weekly/monthly) |

**Snapshot Schedule (default):**
| Frequency | Retention |
|-----------|-----------|
| Hourly | 2 days |
| Daily | 7 days |
| Weekly | 4 weeks |
| Monthly | 12 months |

**Backup Compliance Policy:**
- Prevent unauthorized backup deletion
- Enforce minimum retention periods
- Require point-in-time restore capability
- Cannot be disabled once enabled

**[📖 Atlas Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)** - Backup documentation

## Key Limits to Remember

| Limit | Value |
|-------|-------|
| Max clusters per project | 25 |
| Max projects per organization | 250 |
| Max database users per project | 100 |
| Max IP access list entries | 200 |
| Free tier (M0) storage | 512 MB |
| M0 max connections | 500 |
| M10+ max connections | Varies by tier |
