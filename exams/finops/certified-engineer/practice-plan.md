# FinOps Certified Engineer - Study Plan

## 7-Week Comprehensive Study Schedule

### Week 1: FinOps Engineering Foundations

#### Day 1-2: FinOps Framework Engineering Review
- [ ] Review FinOps lifecycle phases from engineering perspective
- [ ] Map engineering tasks to each FinOps capability
- [ ] Study the engineer persona responsibilities
- [ ] Review FinOps maturity model and engineering maturity indicators
- [ ] Review Notes: `notes/01-cost-data-engineering.md`

#### Day 3-4: Cloud Billing Data Structures
- [ ] Study AWS Cost and Usage Report (CUR) schema in detail
- [ ] Learn Azure Cost Management API data model
- [ ] Understand GCP BigQuery billing export tables and columns
- [ ] Compare billing data structures across providers
- [ ] Practice writing queries against billing data

#### Day 5-6: Infrastructure as Code for FinOps
- [ ] Review Terraform resource tagging patterns
- [ ] Study CloudFormation tag propagation
- [ ] Learn Infracost integration with Terraform
- [ ] Understand cost estimation in deployment pipelines
- [ ] Review Notes: `notes/04-finops-tooling.md`

#### Day 7: Week 1 Review
- [ ] Review all notes from the week
- [ ] Create flashcards for API endpoints and data schemas
- [ ] Take a mini quiz on billing data structures
- [ ] Identify weak areas for deeper study

### Week 2: Cloud Cost Data and Analytics

#### Day 8-9: Cost Data Pipeline Architecture
- [ ] Study data pipeline patterns for billing data
- [ ] Learn ETL processes for CUR data (S3 to Athena)
- [ ] Understand Azure Cost export to Storage and Synapse
- [ ] Study GCP BigQuery billing export and analysis
- [ ] Review Notes: `notes/01-cost-data-engineering.md`

#### Day 10-11: Cost Analysis and Querying
- [ ] Practice Athena queries against CUR data
- [ ] Study BigQuery billing query examples
- [ ] Learn Azure Cost Management query API
- [ ] Understand cost aggregation and normalization
- [ ] Practice filtering by tags, services, and time periods

#### Day 12-13: Anomaly Detection and Alerting
- [ ] Study AWS Cost Anomaly Detection service
- [ ] Learn threshold-based vs ML-based anomaly detection
- [ ] Understand alerting architectures (SNS, EventBridge, webhooks)
- [ ] Review custom anomaly detection approaches
- [ ] Practice setting up budget alerts programmatically

#### Day 14: Week 2 Review
- [ ] Review cost data and analytics concepts
- [ ] Practice with data pipeline architecture questions
- [ ] Take a mini quiz on billing APIs
- [ ] Update study notes

### Week 3: Tagging and Cost Allocation Engineering

#### Day 15-16: Tagging Automation
- [ ] Study AWS Tag Policies and enforcement mechanisms
- [ ] Learn Azure Policy for tag enforcement
- [ ] Understand GCP label management APIs
- [ ] Implement tag remediation automation patterns
- [ ] Review Notes: `notes/02-tagging-automation.md`

#### Day 17-18: Cost Allocation Engineering
- [ ] Study shared cost allocation algorithms
- [ ] Learn Kubernetes cost allocation (namespace, label-based)
- [ ] Understand multi-cloud cost normalization
- [ ] Practice building allocation rules programmatically

#### Day 19-20: Reporting and Dashboards
- [ ] Study AWS QuickSight for cost dashboards
- [ ] Learn Azure Power BI cost reporting
- [ ] Understand GCP Looker Studio billing reports
- [ ] Review custom dashboard approaches (Grafana, Superset)

#### Day 21: Week 3 Review
- [ ] Review tagging and allocation concepts
- [ ] Practice with tagging automation scenarios
- [ ] Take a mini quiz on cost allocation
- [ ] Update flashcards

### Week 4: Rate and Usage Optimization Engineering

#### Day 22-23: Automated Right-sizing
- [ ] Study AWS Compute Optimizer API in detail
- [ ] Learn Azure Advisor recommendation API
- [ ] Understand GCP Recommender API
- [ ] Build automated right-sizing workflow conceptually
- [ ] Review Notes: `notes/03-optimization-automation.md`

#### Day 24-25: Spot Instance Engineering
- [ ] Study Spot Fleet configuration and allocation strategies
- [ ] Learn interruption handling patterns (metadata, EventBridge)
- [ ] Understand Azure Spot VM scale set configuration
- [ ] Study GCP Preemptible/Spot VM management
- [ ] Practice designing fault-tolerant spot architectures

#### Day 26-27: Resource Scheduling and Waste Detection
- [ ] Study AWS Instance Scheduler solution architecture
- [ ] Learn custom scheduling with Lambda and EventBridge
- [ ] Implement waste detection scripts conceptually
- [ ] Understand automated remediation patterns

#### Day 28: Week 4 Review
- [ ] Review optimization engineering concepts
- [ ] Practice with optimization automation scenarios
- [ ] Take a mini quiz on spot engineering
- [ ] Review fact sheet for gaps

### Week 5: Automation, Tooling, and Governance

#### Day 29-30: Policy as Code
- [ ] Study Open Policy Agent (OPA) and Rego language
- [ ] Learn HashiCorp Sentinel policy framework
- [ ] Understand AWS Service Control Policies in depth
- [ ] Practice writing cost policies in code
- [ ] Review Notes: `notes/04-finops-tooling.md`

#### Day 31-32: CI/CD Cost Integration
- [ ] Study Infracost integration with GitHub Actions
- [ ] Learn cost estimation in Terraform plan
- [ ] Understand cost validation gates in pipelines
- [ ] Review deployment cost tracking patterns

#### Day 33-34: FinOps Tools and Governance
- [ ] Study native cloud cost tools across all providers
- [ ] Review third-party FinOps platforms (Apptio, CloudHealth)
- [ ] Learn budget API automation across providers
- [ ] Understand compliance monitoring automation
- [ ] Review Notes: `notes/05-unit-economics-kpis.md`

#### Day 35: Week 5 Review
- [ ] Review automation and governance concepts
- [ ] Practice with policy as code scenarios
- [ ] Take a comprehensive practice exam
- [ ] Identify remaining weak areas

### Week 6: Practice and Integration

#### Day 36-37: Full Practice Exams
- [ ] Take full-length practice exam 1
- [ ] Review all incorrect answers thoroughly
- [ ] Map missed questions to study domains
- [ ] Study explanations for each wrong answer

#### Day 38-39: Integration Patterns
- [ ] Review end-to-end FinOps engineering workflows
- [ ] Study multi-cloud cost management patterns
- [ ] Practice with complex scenario questions
- [ ] Review event-driven cost management architectures

#### Day 40-41: Weak Area Deep Dive
- [ ] Focus study on domains with lowest practice exam scores
- [ ] Re-read relevant documentation
- [ ] Practice additional questions in weak areas
- [ ] Review real-world case studies

#### Day 42: Week 6 Review
- [ ] Take full-length practice exam 2
- [ ] Target score: 80%+
- [ ] Review remaining gaps
- [ ] Plan final week study priorities

### Week 7: Final Preparation

#### Day 43-44: Final Review - High Weight Domains
- [ ] Deep review of Rate and Usage Optimization (30%)
- [ ] Deep review of Cloud Cost Data and Analytics (25%)
- [ ] Practice with domain-specific questions
- [ ] Review all API endpoints and data schemas

#### Day 45-46: Final Review - Remaining Domains
- [ ] Review Automation and Tooling (20%)
- [ ] Review Engineering Fundamentals (15%)
- [ ] Review Governance and Compliance (10%)
- [ ] Take final practice exam (target: 85%+)

#### Day 47-48: Exam Preparation
- [ ] Quick review of all fact sheets and notes
- [ ] Go through all flashcards
- [ ] Light review only - avoid cramming
- [ ] Ensure exam logistics are ready

#### Day 49: Exam Day
- [ ] Quick review of key APIs and data structures
- [ ] Review FinOps engineering principles
- [ ] Stay calm and confident
- [ ] Remember: 50 questions, 60 minutes, 70% to pass

## Progress Tracking

### Domain Confidence Levels

| Domain | Weight | Confidence | Status |
|--------|--------|------------|--------|
| Engineering Fundamentals | 15% | ☐ Low ☐ Medium ☐ High | Not Started |
| Cost Data and Analytics | 25% | ☐ Low ☐ Medium ☐ High | Not Started |
| Rate and Usage Optimization | 30% | ☐ Low ☐ Medium ☐ High | Not Started |
| Automation and Tooling | 20% | ☐ Low ☐ Medium ☐ High | Not Started |
| Governance and Compliance | 10% | ☐ Low ☐ Medium ☐ High | Not Started |

### Practice Exam Scores

| Attempt | Date | Score | Notes |
|---------|------|-------|-------|
| 1 | | | |
| 2 | | | |
| 3 | | | |
