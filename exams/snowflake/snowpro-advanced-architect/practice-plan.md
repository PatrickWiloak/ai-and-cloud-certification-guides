# SnowPro Advanced - Architect Study Plan

## 6-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Architecture and Micro-Partitions

#### Day 1-2: Architecture Deep Dive
- [ ] Review three-layer architecture at advanced level
- [ ] Study micro-partition internals: size, structure, metadata
- [ ] Understand partition pruning and how metadata enables it
- [ ] Learn about natural clustering vs explicit clustering keys
- [ ] **Lab:** Query SYSTEM$CLUSTERING_INFORMATION to analyze clustering

#### Day 3-4: Caching and Query Processing
- [ ] Study all three caching layers in detail
- [ ] Understand result cache invalidation rules
- [ ] Learn local disk cache behavior with warehouse suspend/resume
- [ ] Study query compilation and optimization in cloud services
- [ ] **Lab:** Run queries and observe cache behavior in Query Profile

#### Day 5-7: Snowflake Editions and Features
- [ ] Map features to editions: Standard, Enterprise, Business Critical, VPS
- [ ] Study Business Critical features: Tri-Secret, failover, Private Link
- [ ] Learn VPS (Virtual Private Snowflake) use cases
- [ ] Review Snowpark architecture and execution model
- [ ] **Lab:** Review edition feature comparison in documentation

### Week 2: Multi-Account and Data Sharing

#### Day 1-2: Organizations and Account Management
- [ ] Study Snowflake Organizations structure
- [ ] Learn ORGADMIN role capabilities
- [ ] Understand account creation across regions and clouds
- [ ] Practice cross-account operations and management
- [ ] **Lab:** Explore organization-level views and functions

#### Day 3-4: Replication and Failover
- [ ] Study database replication: primary and secondary replicas
- [ ] Learn replication groups and failover groups
- [ ] Understand client redirect for connection failover
- [ ] Study cross-region and cross-cloud replication patterns
- [ ] **Lab:** Set up database replication between accounts

#### Day 5-7: Data Sharing Patterns
- [ ] Study direct shares and listings
- [ ] Learn reader account setup and management
- [ ] Understand data exchange for group sharing
- [ ] Practice secure views and secure UDFs for sharing
- [ ] **Lab:** Create shares with secure views and test consumer access

### Phase 2: Core Skills (Weeks 3-4)

#### Week 3: Security Architecture

#### Day 1-2: Network Security
- [ ] Study network policies: IP allowlists and blocklists
- [ ] Learn AWS PrivateLink configuration for Snowflake
- [ ] Understand Azure Private Link and GCP Private Service Connect
- [ ] Study internal stages with private connectivity
- [ ] **Lab:** Configure network policies and test access restrictions

#### Day 3-4: Encryption and Key Management
- [ ] Study Snowflake encryption architecture (AES-256, TLS 1.2)
- [ ] Learn automatic key rotation and rekeying
- [ ] Understand Tri-Secret Secure with customer-managed keys
- [ ] Study cloud KMS integration (AWS KMS, Azure Key Vault, GCP KMS)
- [ ] **Lab:** Review encryption configuration options in documentation

#### Day 5-7: Data Governance
- [ ] Study dynamic data masking policies
- [ ] Learn row access policies for fine-grained security
- [ ] Understand object tagging and tag-based governance
- [ ] Practice combining masking, row access, and tagging
- [ ] **Lab:** Create masking and row access policies, test with different roles

### Week 4: Performance Optimization

#### Day 1-2: Warehouse Strategy
- [ ] Study warehouse sizing for different workload types
- [ ] Learn multi-cluster warehouse configuration
- [ ] Understand auto-scaling vs maximized mode
- [ ] Study scaling policies: standard vs economy
- [ ] **Lab:** Test query performance across different warehouse sizes

#### Day 3-4: Query Profiling and Optimization
- [ ] Master Query Profile interpretation
- [ ] Study common performance issues: spilling, exploding joins
- [ ] Learn pruning metrics and how to improve them
- [ ] Understand query acceleration service
- [ ] **Lab:** Analyze Query Profile for slow queries and identify fixes

#### Day 5-7: Cost Management and Resource Monitors
- [ ] Study resource monitor configuration and triggers
- [ ] Learn warehouse scheduling and auto-suspend settings
- [ ] Understand credit usage tracking and attribution
- [ ] Practice clustering key selection and measurement
- [ ] **Lab:** Create resource monitors and configure warehouse auto-suspend

### Phase 3: Exam Preparation (Weeks 5-6)

#### Week 5: Integration and Review

#### Day 1-2: Data Movement Patterns
- [ ] Study Snowpipe and Snowpipe Streaming architecture
- [ ] Learn tasks and streams for CDC patterns
- [ ] Understand dynamic tables for declarative pipelines
- [ ] Review external tables and data lake integration
- [ ] **Lab:** Set up a Snowpipe pipeline and dynamic table chain

#### Day 3-4: Snowpark and Advanced Features
- [ ] Study Snowpark execution model and DataFrame API
- [ ] Learn UDFs and stored procedures with Snowpark
- [ ] Understand external functions and API integrations
- [ ] Review hybrid tables and Unistore concepts
- [ ] **Lab:** Write a Snowpark Python stored procedure

#### Day 5-7: Practice Exam Round 1
- [ ] Take Snowflake official practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify knowledge gaps by domain
- [ ] Create focused study notes for weak areas
- [ ] **Review:** Re-read fact sheet and key concepts for weak domains

### Week 6: Final Review and Exam

#### Day 1-2: Gap Analysis
- [ ] Review multi-account patterns and data sharing trade-offs
- [ ] Study security features and edition requirements
- [ ] Review performance optimization strategies
- [ ] Practice architecture decision scenarios
- [ ] **Practice:** Work through scenario-based questions

#### Day 3-4: Practice Exam Round 2
- [ ] Take second practice exam
- [ ] Target 80%+ score before scheduling real exam
- [ ] Review any remaining weak areas
- [ ] Focus on multi-account and security (highest weight domains)
- [ ] **Review:** Final review of fact sheet and common exam traps

#### Day 5: Exam Day Preparation
- [ ] Light review of key architecture concepts
- [ ] Review edition-specific feature availability
- [ ] Review data sharing vs replication decision criteria
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
3. **Practice (30 min):** Hands-on lab in Snowflake trial account
4. **Quiz (15 min):** Self-assessment on the day's topics

## Key Milestones

- [ ] **Week 1:** Can explain micro-partitions, caching, and architecture in depth
- [ ] **Week 2:** Can design multi-account topologies and data sharing patterns
- [ ] **Week 3:** Can implement security: Private Link, masking, row access, tagging
- [ ] **Week 4:** Can analyze Query Profile and optimize warehouse configuration
- [ ] **Week 5:** Score 70%+ on first practice exam
- [ ] **Week 6:** Score 80%+ on practice exam, pass certification
