# Databricks Lakehouse Platform Administrator High-Yield Scenarios

## Scenario 1: Cost Control for Data Science Team

**Scenario**: A data science team of 20 users is creating large clusters (up to 100 workers) for experimentation, driving up compute costs. The platform admin needs to limit cluster sizes while still allowing the team to create their own clusters.

**Solution Pattern**:
- Create a **cluster policy** that limits max workers (e.g., 10)
- Restrict instance types to cost-effective options via allowlist
- Set auto-termination to 60 minutes (fixed, cannot be overridden)
- Enable spot instances for workers (fixed)
- Assign the policy to the data-science group with "Can Use" permission
- Remove "Allow cluster creation" entitlement - users can only create clusters via policies

**Common Distractors**:
- Removing all compute access (too restrictive, blocks work)
- Setting budget alerts only (reactive, does not prevent overspend)
- Manually reviewing each cluster request (does not scale)

**Key Takeaway**: Cluster policies are the primary tool for cost governance. Combine with entitlement removal so users can only create clusters matching policy constraints.

---

## Scenario 2: New Team Onboarding with Unity Catalog

**Scenario**: A new analytics team of 15 members needs access to production data for reporting. They should be able to read specific schemas but not modify data or create new tables in production. They also need their own development schema.

**Solution Pattern**:
1. Create an account-level group `analytics-team`
2. Add 15 users to the group (via SCIM or manually)
3. Grant workspace access entitlement and SQL access entitlement
4. Unity Catalog grants:
   - `USE CATALOG` on production catalog
   - `USE SCHEMA` + `SELECT` on specific production schemas
   - `USE CATALOG` + `USE SCHEMA` + `CREATE TABLE` + `SELECT` + `MODIFY` on development catalog
5. Assign a SQL warehouse policy with "Can Use" permission
6. No "Allow cluster creation" entitlement (use SQL warehouses only)

**Common Distractors**:
- Granting ALL PRIVILEGES on production catalog (violates least privilege)
- Creating separate copies of production data (expensive, stale data)
- Using workspace-local groups instead of account-level (harder to manage)

**Key Takeaway**: Unity Catalog permissions follow the principle of least privilege. Use groups for scalable permission management, and grant at the schema level for appropriate access.

---

## Scenario 3: Automated User Lifecycle with SCIM

**Scenario**: A company with 500 Databricks users manages identities through Okta. When employees join, change teams, or leave, their Databricks access should update automatically. Currently, an admin manually manages users, leading to stale accounts.

**Solution Pattern**:
- Configure **account-level SCIM** provisioning with Okta
- Map Okta groups to Databricks groups (engineering, analytics, admin)
- SCIM automatically:
  - Creates new users when added to Okta Databricks groups
  - Updates group memberships when employees change teams
  - Deactivates users when removed from Okta groups
- Configure **SAML SSO** for authentication
- Unity Catalog permissions tied to groups - group membership changes flow to data access

**Common Distractors**:
- Workspace-level SCIM for each workspace (fragmented management)
- SAML without SCIM (SSO works but no automated provisioning)
- Manual user management scripts (error-prone, not real-time)

**Key Takeaway**: Account-level SCIM with group sync is the standard for enterprise user lifecycle management. Combined with SSO, it provides complete identity automation.

---

## Scenario 4: Securing a Workspace for Regulated Industry

**Scenario**: A healthcare company must ensure their Databricks workspace meets HIPAA requirements. Data must not traverse the public internet, encryption must use company-managed keys, and all data access must be audited.

**Solution Pattern**:
1. **Network isolation**:
   - Customer-managed VPC with Private Link (front-end and back-end)
   - IP access lists as additional restriction
   - No public IP addresses on cluster nodes
2. **Encryption**:
   - Customer-managed keys for workspace storage (DBFS)
   - Customer-managed keys for managed services (notebook results)
   - Customer-managed keys for cluster EBS volumes
3. **Audit**:
   - Enable audit log delivery to secure S3 bucket
   - Enable verbose audit logging
   - Query system.access.audit for data access tracking
   - Unity Catalog for fine-grained access logging
4. **Access control**:
   - Unity Catalog for data governance
   - Cluster policies enforcing security configurations
   - Secret scopes for credentials (not hardcoded)

**Common Distractors**:
- Using only IP access lists without Private Link (data still crosses internet)
- Default encryption only (does not meet customer-managed key requirement)
- Workspace-level audit only without Unity Catalog (misses data access detail)

**Key Takeaway**: Regulated environments require defense in depth - Private Link for network, CMK for encryption, audit logs for monitoring, and Unity Catalog for data governance.

---

## Scenario 5: SQL Warehouse Performance for BI Users

**Scenario**: A BI team uses Tableau connected to a Databricks SQL warehouse. During peak hours (9 AM - 11 AM), users experience long query queuing times. The warehouse is configured as Medium size with 1 min cluster, 1 max cluster.

**Solution Pattern**:
- Increase **max clusters** to 3-5 for concurrency scaling during peak
- Keep min clusters at 1 for off-peak cost efficiency
- Consider increasing warehouse **size** if individual queries are slow (not just queued)
- Set auto-stop to 15 minutes for cost control during idle periods
- Use **Serverless SQL warehouse** for faster auto-scaling response
- Review query patterns - optimize slow queries with indexes or caching

**Common Distractors**:
- Increasing warehouse size only (helps single query speed, not concurrency)
- Creating multiple warehouses (splits compute, harder to manage)
- Disabling auto-stop (wastes money during off-hours)

**Key Takeaway**: SQL warehouse concurrency is controlled by the number of clusters (horizontal scaling), while query complexity is addressed by warehouse size (vertical scaling).

---

## Scenario 6: Service Principal for Production Pipeline

**Scenario**: A data engineering team runs a nightly ETL pipeline using Databricks Jobs. Currently, the job runs under an individual engineer's account. When that engineer goes on leave, the job fails due to expired credentials. The team needs a sustainable production setup.

**Solution Pattern**:
1. Create a **service principal** at the account level
2. Add the service principal to the workspace
3. Generate OAuth credentials (client ID + secret)
4. Create a group `production-pipelines` and add the service principal
5. Grant Unity Catalog permissions to the group (SELECT on source, MODIFY on target)
6. Transfer job ownership to the service principal
7. Configure job to run as the service principal
8. Store OAuth secret in a secure vault, rotated periodically

**Common Distractors**:
- Using a shared human account (violates security best practices, no individual accountability)
- Using a PAT with long expiry (less secure than OAuth, manual rotation)
- Running as workspace admin (violates least privilege)

**Key Takeaway**: Service principals with OAuth credentials are the standard for production automation. They are not tied to individual employees and support proper access management.

---

## Scenario 7: External Data Access with Unity Catalog

**Scenario**: A company stores raw data in an S3 bucket (`s3://company-raw-data/`) managed by a separate team. The Databricks workspace needs to create external tables pointing to this data. Multiple schemas should access different prefixes in the bucket.

**Solution Pattern**:
1. Create a **storage credential** using an IAM role that can access the S3 bucket
2. Create **external locations** for each prefix:
   - `s3://company-raw-data/sales/` for sales schema
   - `s3://company-raw-data/marketing/` for marketing schema
3. Grant `CREATE EXTERNAL TABLE` on each external location to appropriate groups
4. Teams create external tables:
   ```sql
   CREATE EXTERNAL TABLE sales_catalog.raw.transactions
   LOCATION 's3://company-raw-data/sales/transactions/';
   ```
5. Unity Catalog governs access to external tables same as managed tables

**Common Distractors**:
- Granting direct S3 access via instance profiles (bypasses Unity Catalog governance)
- Copying data to managed storage (unnecessary data duplication)
- Single external location for entire bucket (too broad, no prefix-level control)

**Key Takeaway**: External locations provide governed access to cloud storage. Create granular external locations per use case rather than one broad location.
