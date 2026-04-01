# Databricks Lakehouse Platform Administrator - Practice Plan

## Week 1: Workspace and Identity Fundamentals

### Day 1-2: Account and Workspace Setup
- [ ] Explore account console vs workspace console
- [ ] Create and configure a workspace
- [ ] Review workspace settings and feature toggles
- [ ] Practice with Databricks CLI basics
- **[📖 Administration Guide](https://docs.databricks.com/en/admin/index.html)**

### Day 3-4: Identity Management
- [ ] Create users and groups at account level
- [ ] Assign users to workspaces
- [ ] Configure service principals with OAuth
- [ ] Set up entitlements (workspace access, SQL access, cluster creation)
- **[📖 Users and Groups](https://docs.databricks.com/en/admin/users-groups/index.html)**

### Day 5: Git Integration and Repos
- [ ] Connect a Git provider to workspace
- [ ] Clone a repository, create branches, commit changes
- [ ] Configure admin restrictions on Git providers
- **[📖 Repos](https://docs.databricks.com/en/repos/index.html)**

## Week 2: Compute and Data Management

### Day 1-2: Clusters and Policies
- [ ] Create all-purpose and job clusters
- [ ] Configure auto-scaling (min/max workers)
- [ ] Set auto-termination timeout
- [ ] Create cluster policies with restrictions (instance types, max workers)
- [ ] Assign cluster policies to groups
- **[📖 Cluster Policies](https://docs.databricks.com/en/admin/clusters/policy-definition.html)**

### Day 3: SQL Warehouses
- [ ] Create Serverless, Pro, and Classic SQL warehouses
- [ ] Configure warehouse scaling (min/max clusters)
- [ ] Set auto-stop timeout
- [ ] Assign warehouse permissions to groups
- **[📖 SQL Warehouses](https://docs.databricks.com/en/sql/admin/sql-endpoints.html)**

### Day 4-5: Unity Catalog
- [ ] Explore metastore, catalog, schema hierarchy
- [ ] Create managed and external tables
- [ ] Create volumes for file management
- [ ] Set up external locations and storage credentials
- [ ] Grant permissions (SELECT, MODIFY, CREATE TABLE)
- [ ] View data lineage in Catalog Explorer
- **[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)**

## Week 3: Security and Advanced Topics

### Day 1-2: Network Security
- [ ] Review VPC/VNet injection concepts
- [ ] Understand Private Link configuration (front-end and back-end)
- [ ] Configure IP access lists
- [ ] Review network connectivity options (peering, transit gateway)
- **[📖 Network Security](https://docs.databricks.com/en/security/network/index.html)**

### Day 3: Encryption and Secrets
- [ ] Review default encryption vs customer-managed keys
- [ ] Create secret scopes and store secrets
- [ ] Access secrets from notebooks using dbutils
- [ ] Manage secret scope permissions
- **[📖 Secrets](https://docs.databricks.com/en/security/secrets/index.html)**

### Day 4-5: Audit and Monitoring
- [ ] Enable and configure audit log delivery
- [ ] Query system tables for audit events
- [ ] Review billing usage via system tables
- [ ] Build a simple audit dashboard
- **[📖 Audit Logs](https://docs.databricks.com/en/admin/account-settings/audit-logs.html)**

## Week 4: Exam Preparation

### Day 1-2: Review and Practice
- [ ] Review all notes and key concepts
- [ ] Focus on weak areas identified during hands-on practice
- [ ] Re-read exam guide and domain breakdown

### Day 3-4: Scenario Practice
- [ ] Work through scenarios.md scenario-by-scenario
- [ ] Practice identifying correct answers and eliminating distractors
- [ ] Review decision trees for common choices

### Day 5: Final Review
- [ ] Quick review of key facts from fact-sheet.md
- [ ] Review strategy.md exam tactics
- [ ] Ensure you can answer: workspace vs account level, managed vs external, cluster policy constraints

## Practice Environment

### Databricks Community Edition
- Free tier for basic practice
- Limited to single-node clusters
- No Unity Catalog, SQL warehouses, or admin features
- Good for notebook and Spark basics

### Databricks Trial
- 14-day full-featured trial
- Includes Unity Catalog, SQL warehouses
- Best for practicing admin features
- Sign up at databricks.com

### Key Commands to Practice

```bash
# CLI
databricks workspace list /
databricks clusters list
databricks clusters create --json @config.json
databricks secrets create-scope --scope test-scope
databricks secrets put-secret --scope test-scope --key test-key

# SQL (Unity Catalog)
CREATE CATALOG my_catalog;
CREATE SCHEMA my_catalog.my_schema;
GRANT USE CATALOG ON CATALOG my_catalog TO `data-team`;
GRANT SELECT ON SCHEMA my_catalog.my_schema TO `data-team`;
SHOW GRANTS ON SCHEMA my_catalog.my_schema;
```
