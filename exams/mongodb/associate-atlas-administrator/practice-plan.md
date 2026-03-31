# MongoDB Associate Atlas Administrator - Study Plan

## 5-Week Comprehensive Study Schedule

### Week 1: Cluster Management

#### Day 1-2: Atlas Organization and Project Setup
- [ ] Create Atlas account and explore the UI
- [ ] Study organization, project, and team structure
- [ ] Learn cluster tier differences (M0, M2/M5, M10+)
- [ ] Deploy a free tier (M0) cluster
- [ ] Lab: Create organization, project, and invite team members
- [ ] Review Notes: `01-cluster-management.md`

#### Day 3-4: Cluster Configuration and Multi-Region
- [ ] Study multi-cloud and multi-region deployment options
- [ ] Learn electable, analytics, and read-only node configuration
- [ ] Understand global clusters and zone sharding
- [ ] Practice modifying cluster tiers and regions
- [ ] Lab: Configure a multi-region cluster (use Atlas UI)
- [ ] Lab: Add analytics nodes to a cluster

#### Day 5-6: Auto-Scaling and Cluster Operations
- [ ] Study compute auto-scaling (min/max tier configuration)
- [ ] Learn storage auto-scaling behavior
- [ ] Practice cluster pause/resume for cost management
- [ ] Understand rolling maintenance and upgrade processes
- [ ] Lab: Configure auto-scaling policies
- [ ] Lab: Practice cluster tier upgrades

#### Day 7: Week 1 Review
- [ ] Complete cluster management practice questions
- [ ] Review tier features and limitations
- [ ] Review multi-region configuration options

### Week 2: Security and Access Control

#### Day 8-9: Authentication and User Management
- [ ] Study SCRAM authentication for database users
- [ ] Learn x.509 certificate authentication setup
- [ ] Understand LDAP integration for enterprise
- [ ] Practice creating database users with different roles
- [ ] Lab: Create users with various authentication methods
- [ ] Review Notes: `02-security-access.md`

#### Day 10-11: Network Security
- [ ] Study IP access list configuration
- [ ] Learn VPC peering setup for AWS, Azure, and GCP
- [ ] Understand private endpoints (PrivateLink, Private Link, Private Service Connect)
- [ ] Practice configuring network access controls
- [ ] Lab: Configure IP access list and test connectivity
- [ ] Lab: Set up VPC peering (if cloud access available)

#### Day 12-13: Atlas Roles and API Keys
- [ ] Study Atlas organization and project role hierarchy
- [ ] Learn API key creation and management
- [ ] Understand team-based access control
- [ ] Practice Atlas CLI authentication and commands
- [ ] Lab: Create API keys and test programmatic access
- [ ] Lab: Configure teams with different project roles

#### Day 14: Week 2 Review
- [ ] Complete security practice questions
- [ ] Review authentication methods
- [ ] Review network security configuration

### Week 3: Data Management and Performance

#### Day 15-16: Atlas Search
- [ ] Study Atlas Search index creation and configuration
- [ ] Learn search index field mappings and analyzers
- [ ] Practice $search aggregation queries
- [ ] Understand autocomplete and compound search
- [ ] Lab: Create search indexes and run search queries
- [ ] Review Notes: `03-data-performance.md`

#### Day 17-18: Data Federation and Online Archive
- [ ] Study Data Federation for cross-source queries
- [ ] Learn Online Archive configuration and rules
- [ ] Understand data tiering strategies
- [ ] Practice querying federated data sources
- [ ] Lab: Configure Online Archive with date-based rules
- [ ] Lab: Query archived data via Data Federation

#### Day 19-20: Performance Optimization
- [ ] Study Performance Advisor recommendations
- [ ] Learn real-time performance panel metrics
- [ ] Understand index management in Atlas UI
- [ ] Practice identifying and resolving slow queries
- [ ] Lab: Use Performance Advisor to identify missing indexes
- [ ] Lab: Analyze query targeting ratios

#### Day 21: Week 3 Review
- [ ] Complete data management practice questions
- [ ] Review Atlas Search configuration
- [ ] Review Performance Advisor usage

### Week 4: Monitoring, Backup, and Advanced Topics

#### Day 22-23: Monitoring and Alerts
- [ ] Study Atlas monitoring metrics and dashboards
- [ ] Learn custom alert configuration (thresholds, conditions)
- [ ] Configure notification integrations (Slack, PagerDuty, email)
- [ ] Practice reading and interpreting cluster metrics
- [ ] Lab: Set up alerts for CPU, memory, and connections
- [ ] Review Notes: `04-monitoring-backup.md`

#### Day 24-25: Backup and Restore
- [ ] Study cloud backup and snapshot configuration
- [ ] Learn point-in-time restore procedures
- [ ] Understand backup compliance policies
- [ ] Practice configuring snapshot schedules and retention
- [ ] Lab: Configure backup policies and perform a test restore
- [ ] Lab: Practice point-in-time restore to a new cluster

#### Day 26-27: Atlas CLI and Automation
- [ ] Study Atlas CLI commands for cluster management
- [ ] Learn Atlas Admin API for programmatic control
- [ ] Practice automation scenarios with CLI/API
- [ ] Review Atlas Terraform provider basics
- [ ] Lab: Create and manage clusters via Atlas CLI
- [ ] Lab: Automate common operations with API

#### Day 28: Week 4 Review
- [ ] Complete monitoring and backup practice questions
- [ ] Review alert configuration
- [ ] Review backup and restore procedures

### Week 5: Exam Preparation

#### Day 29-30: Full Practice Exams
- [ ] Take first full-length practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify weak domains and knowledge gaps
- [ ] Create flashcards for missed concepts

#### Day 31-32: Targeted Review
- [ ] Focus study on weakest domains
- [ ] Review cluster tier features and limitations
- [ ] Review security and networking configuration
- [ ] Review Performance Advisor and Atlas Search

#### Day 33-34: Final Review
- [ ] Take second full-length practice exam
- [ ] Review Atlas role hierarchy
- [ ] Review backup policies and compliance
- [ ] Quick review of all notes

#### Day 35: Exam Day Preparation
- [ ] Quick review of fact sheet
- [ ] Review common pitfalls
- [ ] Ensure exam environment is ready
- [ ] Rest and prepare mentally

## Domain Study Time Allocation

| Domain | Weight | Recommended Hours |
|--------|--------|-------------------|
| Cluster Management | 25% | 14-18 hours |
| Security/Access | 20% | 12-15 hours |
| Data Management | 20% | 12-15 hours |
| Performance | 15% | 8-10 hours |
| Monitoring/Alerts | 10% | 6-8 hours |
| Backup/Restore | 10% | 6-8 hours |
| **Total** | **100%** | **58-74 hours** |
