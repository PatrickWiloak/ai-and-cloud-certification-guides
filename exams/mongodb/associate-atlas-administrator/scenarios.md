# High-Yield Scenarios and Patterns

## Cluster Management Scenarios

### Choosing the Right Cluster Tier
**Scenario**: A startup needs a MongoDB deployment for a new application. They expect low initial traffic but rapid growth. Budget is a concern but they need production-ready features.

**Solution Pattern**:
- Start with M10 (lowest dedicated tier) for production features
- Enable compute auto-scaling with M10 minimum and M30 maximum
- Enable storage auto-scaling
- Use a single region initially, expand to multi-region as needed

**Key Points**:
- M0/M2/M5 lack features like backups, VPC peering, and Performance Advisor
- M10 is the minimum tier for production workloads
- Auto-scaling prevents over-provisioning while handling growth
- Scaling up is seamless (rolling process, no downtime)

**Common Distractors**:
- Using M0 for production (wrong - missing critical features)
- Starting with M30+ (wrong - over-provisioned for a startup)
- Manual scaling only (wrong - misses auto-scaling capability)

### Multi-Region Deployment
**Scenario**: A global e-commerce platform needs low-latency reads in US, EU, and Asia-Pacific, with writes in the US.

**Solution Pattern**:
- Deploy primary and one electable node in US-East
- Add one electable node in US-West (maintains US majority)
- Add read-only nodes in EU-West and AP-Southeast
- Configure read preference as `nearest` for reads

**Key Points**:
- Electable nodes participate in elections (majority must be in one region)
- Read-only nodes provide low-latency reads without affecting elections
- Analytics nodes isolate analytical workloads from operational traffic
- Global clusters with zone sharding can direct writes to specific regions

**Common Distractors**:
- Electable nodes in all regions (wrong - split-brain risk if network partition)
- Only using read preferences without additional nodes (wrong - still routes to primary region)
- Using separate clusters per region (wrong - no replication between them)

### Analytics Node Configuration
**Scenario**: A company needs to run heavy analytical queries without impacting their operational workload.

**Solution Pattern**:
- Add analytics nodes to the existing cluster
- Configure analytics read preference tag for BI tools
- Analytics nodes never become primary
- Isolates analytical queries from operational traffic

**Key Points**:
- Analytics nodes are provisioned separately from electable nodes
- They can be a different tier than electable nodes
- Use `readPreference=secondary&readPreferenceTags=nodeType:ANALYTICS` to target them
- They do not participate in elections

## Security and Access Scenarios

### Setting Up Private Connectivity
**Scenario**: A company policy requires that MongoDB connections never traverse the public internet. They use AWS.

**Solution Pattern**:
- Set up AWS PrivateLink for private endpoint connectivity
- Create a VPC endpoint in the application's VPC
- Configure Atlas private endpoint in the project settings
- Remove all entries from the IP access list (or keep only private IPs)

**Key Points**:
- PrivateLink traffic stays within the cloud provider's network
- No need for VPC peering with PrivateLink
- Each cloud provider has a different private endpoint mechanism
- Can combine with VPC peering for different connectivity needs

**Common Distractors**:
- VPC peering alone (partially correct - traffic stays private but uses different routing)
- IP access list with private IPs (wrong - does not prevent public internet routing)
- Using M0 with PrivateLink (wrong - M0 does not support private endpoints)

### Database User Access Control
**Scenario**: An application team needs read-write access to the "orders" database but read-only access to the "products" database.

**Solution Pattern**:
```
Database User Configuration:
- Username: app_user
- Authentication: SCRAM-SHA-256
- Roles:
  - readWrite on database "orders"
  - read on database "products"
```

**Key Points**:
- Atlas database users are separate from Atlas organization/project users
- Database users authenticate to the MongoDB cluster
- Organization/project users authenticate to the Atlas UI/API
- Custom roles can be created for fine-grained access

**Common Distractors**:
- Using Atlas project roles (wrong - those control Atlas UI access, not database access)
- Using root role (wrong - violates principle of least privilege)
- Creating separate clusters (wrong - unnecessary isolation)

### API Key Management
**Scenario**: A CI/CD pipeline needs to deploy Atlas clusters programmatically.

**Solution Pattern**:
- Create a project-scoped API key (not organization-scoped)
- Assign the "Project Cluster Manager" role
- Whitelist the CI/CD runner's IP address in the API key access list
- Store the API key securely in CI/CD secrets

**Key Points**:
- API keys have their own IP access list (separate from cluster access list)
- Organization keys have broader access than project keys
- Use the minimum required role for the task
- API keys can be used with Atlas CLI, Terraform, and REST API

## Data Management Scenarios

### Implementing Atlas Search
**Scenario**: An e-commerce site needs to add product search with autocomplete, filtering by category, and fuzzy matching.

**Solution Pattern**:
1. Create a search index with custom field mappings
2. Map "name" as autocomplete type
3. Map "description" as string type with English analyzer
4. Map "category" as stringFacet type
5. Use compound queries with must, should, and filter clauses

**Key Points**:
- Search indexes are separate from database indexes
- Dynamic mapping indexes all fields (convenience but less efficient)
- Static mapping provides better control and performance
- $search is the first stage in the aggregation pipeline (cannot follow $match)

**Common Distractors**:
- Using regular MongoDB text indexes (wrong - less powerful than Atlas Search)
- Putting $match before $search (wrong - $search must be the first stage)
- Using dynamic mapping for production (less optimal - static is preferred)

### Configuring Online Archive
**Scenario**: An IoT application stores sensor data with 2 years of history. Only the last 30 days is frequently queried. Storage costs are increasing.

**Solution Pattern**:
- Create an Online Archive rule on the sensor data collection
- Set the date field to the timestamp field
- Set the age-out threshold to 30 days
- Use Data Federation to query both live and archived data

**Key Points**:
- Online Archive moves data from the cluster to cheaper cloud storage
- Archived data is read-only
- Data Federation provides a unified query interface
- Reduces cluster storage size and improves performance

## Monitoring and Backup Scenarios

### Setting Up Comprehensive Alerting
**Scenario**: A production Atlas cluster needs monitoring alerts for common failure scenarios.

**Solution Pattern**:
Configure alerts for:
- CPU utilization > 80% for 10 minutes
- Available connections < 20%
- Replication lag > 60 seconds
- Disk utilization > 80%
- Query targeting ratio > 100 (scanned-to-returned ratio)

**Key Points**:
- Alerts can notify via email, Slack, PagerDuty, or webhook
- Host-level alerts apply to individual nodes
- Cluster-level alerts apply to the entire deployment
- Third-party integrations (Datadog, New Relic) provide additional visualization

### Point-in-Time Recovery
**Scenario**: A developer accidentally dropped a production collection at 2:15 PM. The team needs to recover the data.

**Solution Pattern**:
1. Note the exact time of the incident (2:15 PM)
2. Navigate to Atlas Backup > Restore
3. Select "Point in Time" restore
4. Set the restore point to 2:14 PM (one minute before the drop)
5. Restore to a new cluster to avoid overwriting current data
6. Use mongodump/mongorestore to move the recovered collection back

**Key Points**:
- PIT restore requires continuous backup (M10+ with cloud backup)
- Restore to a new cluster to avoid data loss
- PIT restore creates a full cluster restore (not collection-level)
- Recovery point objective depends on oplog retention window

**Common Distractors**:
- Restoring over the existing cluster (risky - loses data written after the drop)
- Using the latest snapshot (wrong - snapshot may be from before the last good state)
- Collection-level PIT restore (wrong - Atlas PIT restore is cluster-level)
