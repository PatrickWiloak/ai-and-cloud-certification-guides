# SnowPro Advanced - Administrator Study Plan

## 6-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Account and Organization Management

#### Day 1-2: Organization Structure
- [ ] Study Snowflake Organizations and ORGADMIN role
- [ ] Learn account creation and management within an organization
- [ ] Understand cross-account operations and billing
- [ ] Review organization-level views and functions
- [ ] **Lab:** Explore organization-level commands and views

#### Day 3-4: Parameter Management
- [ ] Study account parameters vs session parameters vs object parameters
- [ ] Learn commonly tested parameters and their defaults
- [ ] Understand parameter inheritance and override behavior
- [ ] Practice setting and viewing parameters at different levels
- [ ] **Lab:** Configure parameters at account, session, and object levels

#### Day 5-7: System-Defined Roles
- [ ] Study all system-defined roles and their hierarchy
- [ ] Understand ACCOUNTADMIN, SECURITYADMIN, SYSADMIN, USERADMIN, PUBLIC
- [ ] Learn role inheritance and privilege flow
- [ ] Practice switching roles and understanding permission context
- [ ] **Lab:** Test privilege behavior with different roles

### Week 2: Security and Access Control

#### Day 1-2: Custom Role Design
- [ ] Study role hierarchy design patterns for enterprises
- [ ] Learn functional roles vs access roles pattern
- [ ] Practice creating custom role hierarchies
- [ ] Understand database roles for modular access
- [ ] **Lab:** Build a complete role hierarchy for a sample organization

#### Day 3-4: Authentication and Provisioning
- [ ] Study MFA configuration and enforcement
- [ ] Learn SAML 2.0 SSO setup with identity providers
- [ ] Understand SCIM provisioning (Okta, Azure AD)
- [ ] Practice key pair authentication for programmatic access
- [ ] **Lab:** Configure network policies and review auth options

#### Day 5-7: Data Governance
- [ ] Study dynamic data masking policies
- [ ] Learn row access policies for multi-tenant security
- [ ] Understand object tagging and tag-based masking
- [ ] Practice future grants for automatic permission management
- [ ] **Lab:** Create masking and row access policies, test with roles

### Phase 2: Core Skills (Weeks 3-4)

#### Week 3: Resource Management and Cost Control

#### Day 1-2: Resource Monitors
- [ ] Study resource monitor configuration in detail
- [ ] Learn trigger types: NOTIFY, SUSPEND, SUSPEND_IMMEDIATE
- [ ] Understand frequency options: MONTHLY, WEEKLY, DAILY, YEARLY
- [ ] Practice creating account-level and warehouse-level monitors
- [ ] **Lab:** Create resource monitors with multiple trigger levels

#### Day 3-4: Warehouse Management
- [ ] Study warehouse sizing strategies for different workloads
- [ ] Learn multi-cluster warehouse configuration and scaling policies
- [ ] Understand auto-suspend settings and cache implications
- [ ] Practice warehouse scheduling with tasks
- [ ] **Lab:** Configure warehouses with different auto-suspend/resume settings

#### Day 5-7: Cost Analysis
- [ ] Study WAREHOUSE_METERING_HISTORY for credit tracking
- [ ] Learn STORAGE_USAGE for storage cost analysis
- [ ] Understand serverless credit consumption tracking
- [ ] Practice building cost reports with ACCOUNT_USAGE views
- [ ] **Lab:** Build SQL queries for credit and storage cost analysis

### Week 4: Performance Monitoring and Tuning

#### Day 1-2: Query Profiling
- [ ] Master Query Profile interpretation
- [ ] Study common performance issues: spilling, pruning, queuing
- [ ] Learn to identify exploding joins and cartesian products
- [ ] Practice analyzing real Query Profile output
- [ ] **Lab:** Run queries with known issues and analyze profiles

#### Day 3-4: ACCOUNT_USAGE Views
- [ ] Study key views: QUERY_HISTORY, LOGIN_HISTORY, ACCESS_HISTORY
- [ ] Learn view latencies and data retention periods
- [ ] Understand INFORMATION_SCHEMA vs ACCOUNT_USAGE differences
- [ ] Practice monitoring queries for operational health
- [ ] **Lab:** Build monitoring dashboards with ACCOUNT_USAGE views

#### Day 5-7: Clustering and Caching
- [ ] Study clustering key management and monitoring
- [ ] Learn SYSTEM$CLUSTERING_INFORMATION interpretation
- [ ] Understand caching layers and admin management
- [ ] Practice cache optimization strategies
- [ ] **Lab:** Monitor clustering effectiveness and cache behavior

### Phase 3: Exam Preparation (Weeks 5-6)

#### Week 5: Compliance and Practice

#### Day 1-2: Data Management
- [ ] Study Time Travel configuration by table type and edition
- [ ] Learn Fail-safe behavior and limitations
- [ ] Understand data retention policies and storage impact
- [ ] Practice Time Travel queries and UNDROP operations
- [ ] **Lab:** Configure retention periods, test Time Travel scenarios

#### Day 3-4: Compliance and Audit
- [ ] Study ACCESS_HISTORY for data lineage and audit
- [ ] Learn LOGIN_HISTORY for security monitoring
- [ ] Understand compliance certifications by edition
- [ ] Practice building audit reports
- [ ] **Lab:** Build compliance monitoring queries

#### Day 5-7: Practice Exam Round 1
- [ ] Take Snowflake official practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify knowledge gaps by domain
- [ ] Create focused study notes for weak areas
- [ ] **Review:** Re-read fact sheet for weak domains

### Week 6: Final Review and Exam

#### Day 1-2: Gap Analysis
- [ ] Review security and access control patterns
- [ ] Study resource management and cost optimization
- [ ] Review performance monitoring tools and techniques
- [ ] Practice administration scenario questions
- [ ] **Practice:** Work through scenario-based questions

#### Day 3-4: Practice Exam Round 2
- [ ] Take second practice exam
- [ ] Target 80%+ score before scheduling real exam
- [ ] Focus on security domain (highest weight)
- [ ] Review common exam traps
- [ ] **Review:** Final review of fact sheet and key concepts

#### Day 5: Exam Day Preparation
- [ ] Light review of role hierarchy and permissions
- [ ] Review resource monitor configuration
- [ ] Review Time Travel/Fail-safe by edition
- [ ] Verify system requirements and test connection
- [ ] **Prepare:** Set up quiet workspace, check ID, ensure stable internet

#### Day 6-7: Exam and Post-Exam
- [ ] Take the exam
- [ ] Document questions you were unsure about
- [ ] If needed, plan retake strategy based on score report
- [ ] Celebrate your achievement

## Daily Study Routine

### Recommended Schedule (1.5-2 hours per day)
1. **Review (15 min):** Review previous day's notes
2. **Study (45 min):** New topic with documentation deep dive
3. **Practice (30 min):** Hands-on administration tasks
4. **Quiz (15 min):** Self-assessment on the day's topics

## Key Milestones

- [ ] **Week 1:** Can explain organization structure, parameters, and system roles
- [ ] **Week 2:** Can design role hierarchies and configure governance policies
- [ ] **Week 3:** Can configure resource monitors and analyze costs
- [ ] **Week 4:** Can interpret Query Profile and use ACCOUNT_USAGE views
- [ ] **Week 5:** Score 70%+ on first practice exam
- [ ] **Week 6:** Score 80%+ on practice exam, pass certification
