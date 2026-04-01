# Databricks Lakehouse Platform Administrator Study Strategy

## Study Approach

### Phase 1: Platform Fundamentals (Week 1)
1. **Account vs Workspace** - Account console, workspace console, admin roles
2. **Identity Management** - Users, groups, service principals, entitlements
3. **SCIM and SSO** - Automated provisioning, SAML/OIDC configuration
- **[📖 Administration Guide](https://docs.databricks.com/en/admin/index.html)**
- **[📖 Identity Management](https://docs.databricks.com/en/admin/users-groups/index.html)**

### Phase 2: Compute and Data (Week 2)
1. **Clusters** - Configuration, auto-scaling, spot instances, instance pools
2. **Cluster Policies** - Governance, cost control, security enforcement
3. **SQL Warehouses** - Types, sizing, scaling, permissions
4. **Unity Catalog** - Hierarchy, managed vs external tables, volumes, grants
- **[📖 Compute](https://docs.databricks.com/en/compute/index.html)**
- **[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)**

### Phase 3: Security and Exam Prep (Week 3)
1. **Network Security** - VPC injection, Private Link, IP access lists
2. **Encryption** - Default vs customer-managed keys, secrets
3. **Audit Logging** - Log delivery, system tables, compliance
4. **Practice exams and review**
- **[📖 Security Guide](https://docs.databricks.com/en/security/index.html)**
- **[📖 Audit Logs](https://docs.databricks.com/en/admin/account-settings/audit-logs.html)**

## Recommended Resources

### Primary Resources
- **[Databricks Academy](https://www.databricks.com/learn)** - Official training courses
- **[Databricks Certification Page](https://www.databricks.com/learn/certification/lakehouse-platform-administrator)** - Exam details
- **[Databricks Documentation](https://docs.databricks.com/en/index.html)** - Full documentation
- **[Databricks Community Forum](https://community.databricks.com/)** - Discussion and Q&A

### Documentation to Focus On
- **[📖 Admin Guide](https://docs.databricks.com/en/admin/index.html)** - Most exam-relevant section
- **[📖 Security Best Practices](https://docs.databricks.com/en/security/index.html)** - Security configuration
- **[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Data governance
- **[📖 Cluster Policies](https://docs.databricks.com/en/admin/clusters/policy-definition.html)** - Compute governance

## Exam Tactics

### Keywords to Watch For
- "Cost control" or "limit compute" - Cluster policies
- "Automate user management" - SCIM provisioning
- "Non-human identity" or "CI/CD" - Service principal
- "No public internet" - Private Link
- "Own encryption keys" - Customer-managed keys (CMK)
- "Track data access" - Audit logs + Unity Catalog
- "Share data externally" - Delta Sharing
- "Cloud storage access" - External locations + storage credentials
- "Query concurrency" - SQL warehouse scaling (clusters)
- "Restrict workspace access" - IP access lists
- "Account-level vs workspace-level" - Centralized (account) vs per-workspace

### Common Pitfalls
- Account-level SCIM is preferred over workspace-level SCIM
- Cluster policies restrict what users can configure - they do not create clusters
- Removing "Allow cluster creation" entitlement does not block policy-based cluster creation
- External table DROP removes metadata only, not data
- Managed table DROP removes both metadata and data
- SQL warehouse size controls single-query performance; cluster count controls concurrency
- Service principals should use OAuth, not PATs
- IP access lists restrict UI/API access, not cluster-to-data-source traffic
- Unity Catalog permissions require USE CATALOG and USE SCHEMA before table-level grants work

### Time Management
- 90 minutes for 45 questions - 2 minutes per question
- Workspace admin and Unity Catalog questions are most frequent (55% combined)
- Security questions are fewer but detail-oriented
- Eliminate obvious wrong answers first

### Readiness Indicators
- [ ] You understand account console vs workspace console responsibilities
- [ ] You can configure SCIM and SSO for identity management
- [ ] You know how to write cluster policies in JSON
- [ ] You understand Unity Catalog hierarchy and permission model
- [ ] You can explain managed vs external tables and volumes
- [ ] You know network security options (VPC injection, Private Link, IP lists)
- [ ] You understand customer-managed key configuration
- [ ] You can query system tables for audit information
- [ ] You score 70%+ consistently on practice questions
