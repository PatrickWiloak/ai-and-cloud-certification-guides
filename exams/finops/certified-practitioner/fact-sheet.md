# FinOps Certified Practitioner - Fact Sheet

## Exam Overview

**Certification:** FinOps Certified Practitioner (FOCP)
**Provider:** FinOps Foundation (The Linux Foundation)
**Duration:** 60 minutes
**Questions:** 50 multiple choice
**Passing Score:** 70%
**Cost:** $300 USD
**Delivery:** Online proctored
**Prerequisites:** None
**Validity:** 2 years

**[📖 FinOps Certified Practitioner](https://learn.finops.org/path/finops-certified-practitioner)** - Official certification page
**[📖 FinOps Framework](https://www.finops.org/framework/)** - Complete FinOps framework documentation
**[📖 FinOps Foundation](https://www.finops.org/)** - FinOps Foundation homepage

## Target Audience

This certification is designed for:
- Cloud finance professionals managing cloud budgets
- Engineers responsible for cloud cost optimization
- IT managers overseeing cloud spending
- Business stakeholders involved in cloud financial decisions
- Anyone starting a FinOps practice in their organization

**[📖 FinOps Personas](https://www.finops.org/framework/personas/)** - Understanding FinOps stakeholder roles
**[📖 FinOps Training](https://learn.finops.org/)** - Official training and learning paths

## Domain 1: Understanding FinOps (20%)

This domain covers the foundational concepts of the FinOps framework, including principles, lifecycle phases, and organizational structure.

### FinOps Principles

The six principles of FinOps form the foundation of cloud financial management:

1. **Teams need to collaborate** - Finance, engineering, and business work together
2. **Everyone takes ownership for their cloud usage** - Decentralized decision-making with central governance
3. **A centralized team drives FinOps** - Dedicated team establishes best practices and processes
4. **Reports should be accessible and timely** - Real-time data available to all stakeholders
5. **Decisions are driven by the business value of cloud** - Cost optimization balanced with speed and quality
6. **Take advantage of the variable cost model of the cloud** - Leverage elasticity and pay-per-use pricing

**[📖 FinOps Principles](https://www.finops.org/framework/principles/)** - Detailed explanation of each principle
**[📖 FinOps Lifecycle](https://www.finops.org/framework/phases/)** - Inform, Optimize, Operate phases

### FinOps Lifecycle Phases

**Inform Phase:**
- Provide visibility into cloud spending
- Allocate costs to teams and projects
- Create shared understanding of cost data
- Enable data-driven decision making

**Optimize Phase:**
- Identify optimization opportunities
- Implement rate and usage optimizations
- Reduce waste and improve efficiency
- Balance cost with performance

**Operate Phase:**
- Establish governance and policies
- Automate cost management processes
- Continuously improve FinOps maturity
- Align cloud spending with business goals

**[📖 Inform Phase](https://www.finops.org/framework/phases/inform/)** - Building cost visibility
**[📖 Optimize Phase](https://www.finops.org/framework/phases/optimize/)** - Reducing cloud costs
**[📖 Operate Phase](https://www.finops.org/framework/phases/operate/)** - Running FinOps at scale

### FinOps Maturity Model

**Crawl:**
- Basic cost visibility and reporting
- Manual processes for cost management
- Limited organizational awareness
- Reactive cost optimization

**Walk:**
- Automated cost reporting and alerts
- Proactive optimization strategies
- Cross-functional collaboration emerging
- KPIs established and tracked

**Run:**
- Fully automated FinOps processes
- Real-time cost optimization
- FinOps embedded in engineering culture
- Continuous improvement driven by metrics

**[📖 FinOps Maturity Model](https://www.finops.org/framework/maturity-model/)** - Crawl, Walk, Run stages

## Domain 2: Inform Phase (30%)

### Cost Allocation and Tagging

**Tagging Strategies:**
- Mandatory tags: cost center, environment, owner, project
- Optional tags: team, application, service, compliance
- Tag governance: enforcement policies and automation
- Tag hygiene: regular audits and cleanup

**Cost Allocation Methods:**
- **Direct allocation**: Costs assigned directly to consuming teams
- **Shared costs**: Distributed across teams based on usage or agreed formula
- **Amortized costs**: Upfront commitments spread over time
- **Unallocated costs**: Costs that cannot be attributed to specific teams

**[📖 Cost Allocation](https://www.finops.org/framework/capabilities/cost-allocation/)** - Tagging and allocation strategies
**[📖 Data Analysis and Showback](https://www.finops.org/framework/capabilities/analysis-showback/)** - Cost reporting methods

### Showback vs Chargeback

**Showback:**
- Reports costs to teams without billing them
- Lower organizational friction
- Useful for building cost awareness
- Good starting point for FinOps adoption

**Chargeback:**
- Bills costs directly to responsible teams
- Drives stronger accountability
- Requires mature cost allocation
- May create organizational resistance

**[📖 Managing Shared Costs](https://www.finops.org/framework/capabilities/manage-shared-cloud-cost/)** - Handling shared infrastructure costs

### Cloud Billing Models

**AWS Billing:**
- Cost Explorer for analysis
- AWS Organizations for consolidated billing
- Cost and Usage Report (CUR) for detailed data
- Billing alerts and budgets

**Azure Billing:**
- Azure Cost Management + Billing
- Management Groups for hierarchy
- Azure Advisor for recommendations
- Cost analysis and budgets

**GCP Billing:**
- Cloud Billing Reports
- BigQuery export for detailed analysis
- Billing accounts and projects
- Budgets and alerts

**[📖 Cloud Cost Management](https://www.finops.org/framework/capabilities/)** - FinOps capabilities overview
**[📖 Forecasting](https://www.finops.org/framework/capabilities/forecasting/)** - Budgeting and forecasting practices

### Unit Economics

**Key Metrics:**
- Cost per customer
- Cost per transaction
- Cost per environment
- Cost per deployment
- Infrastructure cost as percentage of revenue

**[📖 Unit Economics](https://www.finops.org/framework/capabilities/measure-unit-costs/)** - Measuring cost efficiency

## Domain 3: Optimize Phase (25%)

### Rate Optimization

**Reserved Instances (RIs):**
- 1-year or 3-year commitments
- Standard vs convertible options
- All upfront, partial upfront, no upfront payment options
- Regional vs zonal scope
- 30-72% savings vs on-demand

**Savings Plans (AWS):**
- Compute Savings Plans (most flexible)
- EC2 Instance Savings Plans (most savings)
- SageMaker Savings Plans
- 1-year or 3-year terms

**Committed Use Discounts (GCP):**
- Spend-based commitments
- Resource-based commitments
- 1-year or 3-year terms

**Spot/Preemptible Instances:**
- 60-90% savings vs on-demand
- Can be interrupted with notice
- Best for fault-tolerant, flexible workloads
- Batch processing, CI/CD, data analysis

**[📖 Rate Optimization](https://www.finops.org/framework/capabilities/rate-optimization/)** - Commitment-based discount strategies
**[📖 Managing Commitment Discounts](https://www.finops.org/framework/capabilities/manage-commitment-based-discounts/)** - RI and Savings Plan management

### Usage Optimization

**Right-sizing:**
- Analyze CPU, memory, network utilization
- Identify over-provisioned resources
- Use provider recommendations (AWS Compute Optimizer, Azure Advisor)
- Consider performance requirements before downsizing

**Waste Reduction:**
- Unattached EBS volumes, elastic IPs
- Idle load balancers and databases
- Unused Reserved Instance capacity
- Orphaned snapshots and images
- Development resources running outside business hours

**[📖 Workload Optimization](https://www.finops.org/framework/capabilities/workload-optimization/)** - Right-sizing and resource management
**[📖 Onboarding Workloads](https://www.finops.org/framework/capabilities/onboarding-workloads/)** - Managing new workloads

### Storage Optimization

- Lifecycle policies for object storage
- Storage class transitions (hot to cold)
- Compression and deduplication
- Data retention policies
- Archive strategies (Glacier, Archive Storage)

## Domain 4: Operate Phase (25%)

### Governance and Policies

**Policy Types:**
- Spending limits and budgets
- Tagging requirements
- Approved instance types
- Region restrictions
- Approval workflows for large purchases

**Guardrails:**
- Automated policy enforcement
- Budget alerts and actions
- Resource provisioning restrictions
- Compliance monitoring

**[📖 FinOps Policy and Governance](https://www.finops.org/framework/capabilities/establish-finops-culture/)** - Building FinOps governance
**[📖 Cloud Policy and Governance](https://www.finops.org/framework/capabilities/policy-governance/)** - Policy management

### Organizational Alignment

**FinOps Team Structure:**
- FinOps lead or director
- Cloud financial analysts
- Cloud engineers
- Business stakeholders
- Executive sponsors

**Cultural Change:**
- Building cost awareness across teams
- Celebrating optimization wins
- Regular cost reviews and updates
- Training and enablement programs

**[📖 FinOps Team Structure](https://www.finops.org/framework/personas/)** - Roles and responsibilities
**[📖 FinOps Community](https://www.finops.org/community/)** - Community resources and events

### Automation and Tooling

**Native Cloud Tools:**
- AWS Cost Explorer, Budgets, Trusted Advisor
- Azure Cost Management, Advisor
- GCP Cloud Billing, Recommender

**Third-Party Tools:**
- Apptio Cloudability
- CloudHealth by VMware
- Spot by NetApp
- Kubecost (Kubernetes)

**[📖 FinOps Tools and Services](https://www.finops.org/landscape/)** - FinOps tool landscape
**[📖 FinOps Certified Platforms](https://www.finops.org/members/certified-platforms/)** - Certified FinOps platforms

## Exam Tips

1. **Focus on the framework** - The exam heavily tests FinOps principles and lifecycle phases
2. **Think cloud-agnostic** - Questions are not specific to one provider
3. **Prioritize collaboration** - FinOps emphasizes teamwork between finance, engineering, and business
4. **Know the maturity model** - Understand Crawl, Walk, Run stages and when to apply each
5. **Understand showback vs chargeback** - Key concept tested frequently
6. **Study unit economics** - Measuring business value of cloud spending is critical
7. **Review optimization types** - Rate vs usage vs architectural optimization
8. **Remember it is cultural** - FinOps is a practice and culture, not just tools
9. **Learn the personas** - Know who does what in a FinOps organization
10. **Practice with scenarios** - Many questions present real-world situations

## Quick Reference - FinOps Capabilities

| Capability | Phase | Description |
|-----------|-------|-------------|
| Cost Allocation | Inform | Map costs to teams and projects |
| Showback/Chargeback | Inform | Report or bill costs to teams |
| Forecasting | Inform | Predict future cloud spending |
| Budgeting | Inform | Set spending targets and alerts |
| Rate Optimization | Optimize | Leverage discounts and commitments |
| Workload Optimization | Optimize | Right-size and eliminate waste |
| Policy and Governance | Operate | Enforce standards and guardrails |
| FinOps Culture | Operate | Build organizational cost awareness |
