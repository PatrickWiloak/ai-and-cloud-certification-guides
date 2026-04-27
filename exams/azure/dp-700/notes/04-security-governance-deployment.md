# 04 - Security, Governance, and Deployment

## Identity

Fabric uses **Microsoft Entra ID** (formerly Azure AD) for authentication and identity. Three principal types:

- **Users** - human accounts
- **Service Principals** - app identities (created in Entra ID)
- **Managed Identities** - Fabric-managed app identities for calling external services without storing credentials

Service Principals can own most operations now (workspace ops, capacity ops, item runs).

---

## Workspace roles

| Role | What they can do |
|---|---|
| **Admin** | Full control: add/remove members, change capacity, delete the workspace |
| **Member** | Edit content, share to others, manage data sources |
| **Contributor** | Edit content, build reports, run pipelines |
| **Viewer** | Read content (reports, semantic models) |

### Best practice

Grant **groups**, not individuals. Use Entra ID security groups managed via your IdP. RBAC scales when you grant 5 groups instead of 50 users.

---

## Item-level permissions

Beyond workspace roles, individual items can have explicit permissions:

| Permission | Effect |
|---|---|
| **Read** | Can see/use the item |
| **ReadAll** (semantic model only) | Can see + query underlying data |
| **Write** | Can edit |
| **Reshare** | Can grant Read to others |
| **Build** (semantic model) | Can build reports on top |

Useful when you want broad workspace access for Member but restrict a specific Lakehouse to a smaller group.

---

## OneLake security (preview)

Row/column-level security at OneLake item level using **security predicates**.

```sql
-- Define a row filter
CREATE SECURITY POLICY sales.region_policy
ADD FILTER PREDICATE sales.region_filter(region)
ON sales.fact_orders;

-- Function returns rows visible to current user
CREATE FUNCTION sales.region_filter(@region nvarchar(50))
RETURNS TABLE WITH SCHEMABINDING
AS RETURN SELECT 1 AS visible
WHERE @region = USER_NAME() OR IS_ROLEMEMBER('admins') = 1;
```

Pattern: store the user's region in a mapping, use a function predicate to filter rows.

For column-level: dynamic data masking or omit columns from views the user can access.

---

## Sensitivity labels (Microsoft Purview)

Microsoft Purview Information Protection (MPIP) labels tag content with classifications like:

- **Public**
- **General**
- **Confidential** (often with sub-tiers)
- **Highly Confidential**

Labels:

- Inherit from sources (e.g., a Power BI semantic model inherits from underlying SQL DB labels)
- Apply policies (e.g., "Confidential" data can't be exported to CSV without re-authentication)
- Show as visual badges on items

### How labels propagate

Source DB → ingestion → Lakehouse table → Power BI semantic model → Report. The label flows downstream so policies apply at every stage.

---

## Microsoft Purview integration

The Purview governance suite hooks into Fabric:

- **Data Catalog** - auto-discovers Fabric items, makes them searchable
- **Data Lineage** - traces flow from source to Lakehouse to report
- **Data Quality** - measures freshness, completeness, validity
- **Policies** - centralize access policy across Fabric, Synapse, Snowflake, SQL DB, etc.

For DP-700: know that Purview integrates with Fabric for catalog + lineage; specifics tested less heavily.

---

## Deployment Pipelines

Fabric's CI/CD-lite. Promotes content between **Dev → Test → Prod** workspaces.

### Pipeline stages

```
Dev workspace → Test workspace → Prod workspace
```

Each stage is a separate workspace. Deployment Pipeline knows which item maps to which.

### Deploy

Click "Deploy" from Dev to Test. Diff shows changes (additions, modifications, deletions). Approve, deploy.

### Deployment rules

Rules swap parameters per environment:

- Data source rules: Dev points to dev DB; Prod points to prod DB
- Parameter rules: capacity, semantic model parameters, etc.

### Limits

- Sequential stages only (no parallel branches)
- 3 stages max in a single pipeline (Dev/Test/Prod common)
- Some items have full support; some have partial

For more complex CI/CD, combine with Git integration.

---

## Git integration

Workspace ↔ Git repo (Azure DevOps or GitHub).

### Setup

1. Create a feature branch in the repo
2. Connect the workspace to that branch
3. Items in the workspace become source-controlled (notebook content, pipeline JSON, report DAX, etc.)
4. Commit changes from the workspace UI
5. PR to main; trigger CI/CD pipeline

### Workflow

```
Dev workspace ↔ feature branch (commit/sync from UI)
                     │
                     ▼ PR
                  main branch
                     │
                     ▼ deploy via API or pipeline
              Prod workspace
```

### What's synced

- Notebooks (full source)
- Pipelines (JSON)
- Semantic models (TMDL/BIM)
- Reports (PBIR JSON format)
- Lakehouse / Warehouse: schema and a metadata representation (data is not in git)

---

## Network security

Fabric is a SaaS service. Network controls:

- **Private Link to OneLake** - prevent OneLake access from the public internet
- **Trusted workspace access** - allow specific workspaces to access firewalled Azure resources
- **Outbound rules from Spark** - restrict where notebooks can call out

Less detailed than IaaS networking; for DP-700, know the high-level options.

---

## Common exam triggers

- "Restrict access to a specific Lakehouse for a subset of users" → Item-level Read permission
- "Promote Dev workspace items to Prod with parameter swap" → Deployment Pipeline + deployment rules
- "Source-control all workspace items" → Git integration
- "PII rows visible only to specific users" → OneLake security / row-level filter (preview)
- "Sensitive data flagged at source must propagate" → Sensitivity labels (MPIP)
- "Block public access to OneLake" → Private Link
- "External catalog discovers Fabric items" → Microsoft Purview integration
- "Service Principal runs scheduled pipelines" → Service Principal with workspace Contributor or item Write

---

## Quick decision matrix

| Need | Use |
|---|---|
| Coarse-grained access | Workspace roles |
| Per-item access | Item permissions |
| Per-row filter | OneLake security predicates |
| Per-column mask | Dynamic data masking / view restriction |
| Classify data sensitivity | Purview sensitivity labels |
| Catalog + lineage across data estate | Microsoft Purview |
| Promote items Dev → Test → Prod | Deployment Pipelines |
| Version control for items | Git integration |
| Private network access | Private Link |
