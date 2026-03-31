# Cloud Cost Visibility and Allocation

**[📖 Cost Allocation](https://www.finops.org/framework/capabilities/cost-allocation/)** - FinOps cost allocation capability
**[📖 Data Analysis and Showback](https://www.finops.org/framework/capabilities/analysis-showback/)** - Reporting and visibility

## Cost Allocation Fundamentals

Cost allocation is the process of mapping cloud costs to business entities - teams, projects, products, environments, and cost centers. It is the foundation of the Inform phase and enables all downstream FinOps activities.

### Why Cost Allocation Matters
- Enables teams to understand their spending
- Supports showback and chargeback models
- Drives accountability and ownership
- Provides data for optimization decisions
- Supports budgeting and forecasting

## Tagging Strategies

**[📖 Managing Shared Costs](https://www.finops.org/framework/capabilities/manage-shared-cloud-cost/)** - Shared cost allocation

### Mandatory Tags
Every resource should have these tags at minimum:

| Tag Key | Purpose | Example Values |
|---------|---------|---------------|
| `cost-center` | Financial allocation | `CC-1234`, `engineering` |
| `environment` | Deployment stage | `production`, `staging`, `development` |
| `owner` | Responsible team or person | `platform-team`, `jsmith@company.com` |
| `project` | Project or product | `mobile-app`, `data-pipeline` |
| `application` | Application name | `web-frontend`, `api-backend` |

### Optional Tags
Additional tags for enhanced visibility:

| Tag Key | Purpose | Example Values |
|---------|---------|---------------|
| `team` | Team assignment | `frontend`, `data-science` |
| `service` | Microservice name | `user-auth`, `payment-processing` |
| `compliance` | Regulatory requirements | `hipaa`, `pci-dss`, `sox` |
| `created-by` | Provisioning method | `terraform`, `console`, `cdk` |
| `end-date` | Resource expiration | `2026-06-30` |

### Tag Governance

**Enforcement Methods:**
- AWS: Service Control Policies (SCPs), AWS Config rules, Tag Policies
- Azure: Azure Policy, Resource Locks
- GCP: Organization Policies, labels

**Tag Hygiene:**
- Regular tag audits (weekly or monthly)
- Automated tag compliance reporting
- Remediation workflows for untagged resources
- Tag naming conventions (lowercase, hyphens, no spaces)

## Cost Allocation Methods

### Direct Allocation
Costs assigned directly to the consuming team or project.

**When to use:**
- Resources used exclusively by one team
- Clear ownership of infrastructure
- Dedicated accounts or subscriptions per team

**Examples:**
- Team-specific EC2 instances
- Dedicated RDS databases
- Team-owned S3 buckets

### Shared Cost Allocation
Costs for shared infrastructure distributed across consuming teams.

**Distribution Methods:**
- **Proportional:** Based on actual resource consumption (CPU, memory, requests)
- **Even Split:** Divided equally among consuming teams
- **Fixed Percentage:** Pre-agreed allocation percentages
- **Weighted:** Based on business metrics (revenue, headcount)

**Common Shared Costs:**
- Kubernetes clusters
- Networking infrastructure (VPCs, Transit Gateways)
- Shared databases and caches
- Monitoring and logging platforms
- Security tools and services

### Amortized Costs
Upfront commitment costs spread over the commitment period.

**When to use:**
- Reserved Instance purchases
- Savings Plan commitments
- Enterprise agreements
- Annual license purchases

**Calculation:**
- Total upfront cost / number of months = monthly amortized cost
- Add recurring monthly charges
- Allocate to teams based on usage of committed resources

### Unallocated Costs
Costs that cannot be attributed to specific teams.

**Common Sources:**
- Support charges
- Tax and marketplace fees
- Data transfer between services
- Resources without tags
- Account-level charges

**Handling Strategies:**
- Distribute proportionally based on total team spending
- Assign to a shared cost center
- Include in platform team overhead
- Track and work to reduce over time

## Showback vs Chargeback

### Showback Model

**Definition:** Reporting cloud costs to teams without actual financial billing.

**Advantages:**
- Lower organizational friction
- Easier to implement
- Builds cost awareness gradually
- Good starting point for immature organizations
- Does not require changes to financial systems

**Implementation:**
- Monthly or weekly cost reports per team
- Dashboards showing team spending trends
- Anomaly alerts for unusual spending
- Cost comparisons between teams or periods

**Best Practices:**
- Start with showback before moving to chargeback
- Make reports clear and actionable
- Include optimization recommendations
- Show trends, not just current costs

### Chargeback Model

**Definition:** Billing cloud costs directly to responsible business units through financial systems.

**Advantages:**
- Strongest accountability mechanism
- Directly impacts team budgets
- Aligns cloud costs with business P&L
- Drives faster optimization behavior

**Challenges:**
- Requires mature cost allocation
- Can create organizational resistance
- Shared costs are difficult to allocate fairly
- Requires integration with financial systems
- May discourage cloud adoption if poorly implemented

**Implementation:**
- Define clear allocation rules
- Handle shared costs transparently
- Integrate with GL/ERP systems
- Provide dispute resolution process
- Start with large teams and expand gradually

## Cloud Provider Billing

### AWS Billing

**[📖 AWS Cost Management](https://docs.aws.amazon.com/cost-management/)** - AWS billing documentation

**Key Tools:**
- **Cost Explorer:** Visual cost analysis and forecasting
- **Cost and Usage Report (CUR):** Detailed billing data export
- **AWS Budgets:** Budget creation, tracking, and alerts
- **Billing Dashboard:** Account-level billing overview
- **AWS Organizations:** Consolidated billing across accounts

**Billing Concepts:**
- Consolidated billing rolls up member account charges
- Blended vs unblended rates
- Cost allocation tags (user-defined and AWS-generated)
- Billing alerts via CloudWatch and SNS

### Azure Billing

**[📖 Azure Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/)** - Azure billing documentation

**Key Tools:**
- **Cost Management + Billing:** Central cost analysis
- **Cost Analysis:** Visual cost exploration
- **Azure Advisor:** Optimization recommendations
- **Budgets:** Spending limits and alerts
- **Management Groups:** Hierarchical organization

**Billing Concepts:**
- Subscriptions as billing boundaries
- Resource groups for organization
- Management group hierarchy
- Enterprise Agreement vs Pay-As-You-Go

### GCP Billing

**[📖 GCP Cloud Billing](https://cloud.google.com/billing/docs)** - GCP billing documentation

**Key Tools:**
- **Cloud Billing Reports:** Visual cost reporting
- **BigQuery Billing Export:** Detailed billing data
- **Budgets and Alerts:** Spending notifications
- **Billing Accounts:** Payment and billing management
- **Recommender:** Optimization suggestions

**Billing Concepts:**
- Projects as billing units
- Billing accounts link to projects
- Labels for cost allocation
- Standard vs detailed billing export

## Budgeting and Forecasting

**[📖 Forecasting](https://www.finops.org/framework/capabilities/forecasting/)** - FinOps forecasting capability

### Budgeting Methods
- **Top-down:** Finance sets overall cloud budget, allocated to teams
- **Bottom-up:** Teams estimate their needs, aggregated to total
- **Hybrid:** Combination with guardrails and flexibility
- **Zero-based:** Justify all spending from scratch each period

### Forecasting Techniques
- **Trend-based:** Extrapolate from historical spending patterns
- **Driver-based:** Link to business metrics (users, transactions)
- **Commitment-aware:** Factor in existing reservations and plans
- **Scenario modeling:** Best case, worst case, expected case

### Anomaly Detection
- Set up automated alerts for spending spikes
- Define thresholds (percentage or dollar amount)
- Investigate anomalies promptly
- Document root causes and resolutions

## Unit Economics

**[📖 Measuring Unit Costs](https://www.finops.org/framework/capabilities/measure-unit-costs/)** - Unit economics capability

### Common Unit Metrics

| Metric | Formula | Purpose |
|--------|---------|---------|
| Cost per Customer | Total cloud cost / active customers | Customer profitability |
| Cost per Transaction | Total cost / transactions | Transaction efficiency |
| Cost per Request | Compute cost / API requests | Service efficiency |
| Cost per GB Stored | Storage cost / total GB | Storage efficiency |
| Infrastructure Cost Ratio | Cloud cost / revenue | Business efficiency |

### Using Unit Economics
- Track trends over time (improving or degrading)
- Compare across teams and services
- Set optimization targets
- Report to executives in business terms
- Identify services with poor cost efficiency

## Key Exam Tips for This Domain

1. **Tagging is foundational** - Without good tagging, cost allocation fails
2. **Showback before chargeback** - Always start with showback for immature organizations
3. **Know all three billing models** - AWS, Azure, and GCP billing concepts
4. **Shared costs need fair allocation** - Proportional based on usage is usually best
5. **Unit economics connect cost to business** - Critical for executive communication
6. **Anomaly detection prevents surprises** - Automated alerts are essential
7. **Budgets need forecasting** - Accurate forecasting improves budget accuracy
