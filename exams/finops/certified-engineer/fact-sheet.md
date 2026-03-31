# FinOps Certified Engineer - Fact Sheet

## Exam Overview

**Certification:** FinOps Certified Engineer (FOCE)
**Provider:** FinOps Foundation (The Linux Foundation)
**Duration:** 60 minutes
**Questions:** 50 multiple choice
**Passing Score:** 70%
**Cost:** $300 USD
**Delivery:** Online proctored
**Prerequisites:** FinOps Certified Practitioner (FOCP)
**Validity:** 2 years

**[📖 FinOps Certified Engineer](https://learn.finops.org/path/finops-certified-engineer)** - Official certification page
**[📖 FinOps Framework](https://www.finops.org/framework/)** - Complete FinOps framework
**[📖 FinOps Foundation](https://www.finops.org/)** - FinOps Foundation homepage

## Target Audience

This certification is designed for:
- Cloud engineers implementing FinOps automation
- DevOps engineers integrating cost into CI/CD pipelines
- Platform engineers building cost-aware infrastructure
- Data engineers working with cloud billing data
- SREs balancing reliability with cost efficiency

**[📖 FinOps Personas](https://www.finops.org/framework/personas/)** - Engineering roles in FinOps
**[📖 FinOps Training](https://learn.finops.org/)** - Official training paths

## Domain 1: FinOps Engineering Fundamentals (15%)

### Engineering Role in FinOps

Engineers are responsible for implementing the technical components of FinOps - from data pipelines to automation to governance controls. The engineer translates FinOps strategy into working systems.

**Engineering Responsibilities:**
- Build and maintain cost data pipelines
- Implement tagging automation and enforcement
- Create optimization automation workflows
- Integrate cost validation into CI/CD
- Build custom tools and dashboards

**[📖 FinOps Capabilities](https://www.finops.org/framework/capabilities/)** - Technical capabilities
**[📖 FinOps Lifecycle](https://www.finops.org/framework/phases/)** - Engineering in each phase

### Infrastructure as Code for FinOps

**Terraform Cost Integration:**
- Use Infracost for pre-deployment cost estimation
- Tag enforcement through required variable blocks
- Module standardization with cost-optimized defaults
- State management for resource tracking

**CloudFormation Cost Integration:**
- AWS Config rules for compliance checking
- Stack tags inherited by all resources
- Service Catalog for approved templates
- Parameter constraints for instance types

**[📖 Infracost](https://www.infracost.io/docs/)** - Terraform cost estimation tool
**[📖 Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)** - AWS Terraform provider

### Cost in CI/CD Pipelines

**Pre-deployment Checks:**
- Estimate infrastructure cost changes
- Validate tagging compliance
- Check against budget thresholds
- Verify approved resource types

**Post-deployment Monitoring:**
- Track cost impact of deployments
- Alert on unexpected cost increases
- Correlate deployments with cost changes
- Automated rollback for cost anomalies

## Domain 2: Cloud Cost Data and Analytics (25%)

### AWS Cost and Usage Report (CUR)

**CUR Structure:**
- Delivered to S3 in CSV or Parquet format
- Contains line items for every charge
- Includes resource-level detail
- Updated multiple times per day
- Supports Athena, Redshift, and QuickSight integration

**Key CUR Columns:**
| Column | Description |
|--------|------------|
| `lineItem/UsageType` | Type of usage |
| `lineItem/UnblendedCost` | Actual cost charged |
| `lineItem/BlendedCost` | Average rate across organization |
| `lineItem/ResourceId` | Specific resource ID |
| `product/ProductName` | AWS service name |
| `resourceTags/user:*` | User-defined tags |
| `savingsPlan/SavingsPlanARN` | Associated Savings Plan |
| `reservation/ReservationARN` | Associated reservation |

**[📖 AWS CUR Documentation](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html)** - CUR user guide
**[📖 CUR Data Dictionary](https://docs.aws.amazon.com/cur/latest/userguide/data-dictionary.html)** - Column reference
**[📖 Athena CUR Integration](https://docs.aws.amazon.com/cur/latest/userguide/cur-query-athena.html)** - Querying CUR with Athena

### Azure Cost Management API

**REST API Endpoints:**
- `/providers/Microsoft.CostManagement/query` - Cost queries
- `/providers/Microsoft.Consumption/usageDetails` - Detailed usage
- `/providers/Microsoft.Consumption/budgets` - Budget management
- `/providers/Microsoft.Advisor/recommendations` - Cost recommendations

**Export Options:**
- Scheduled exports to Azure Storage
- Cost Management connector for Power BI
- Azure Resource Graph queries
- Azure Monitor integration

**[📖 Azure Cost Management API](https://learn.microsoft.com/en-us/rest/api/cost-management/)** - REST API reference
**[📖 Azure Billing APIs](https://learn.microsoft.com/en-us/azure/cost-management-billing/automate/)** - Automation guide

### GCP BigQuery Billing Export

**Export Types:**
- Standard export: Daily aggregated data
- Detailed export: Resource-level usage data
- Pricing export: SKU pricing information

**Key BigQuery Tables:**
| Table | Content |
|-------|---------|
| `gcp_billing_export_v1` | Standard billing data |
| `gcp_billing_export_resource_v1` | Resource-level data |
| `cloud_pricing_export` | Pricing catalog |

**[📖 GCP Billing Export](https://cloud.google.com/billing/docs/how-to/export-data-bigquery)** - BigQuery export setup
**[📖 GCP Billing Queries](https://cloud.google.com/billing/docs/how-to/bq-examples)** - Example BigQuery queries

### Cost Data Pipeline Architecture

**Typical Pipeline:**
1. **Ingest:** Pull billing data from cloud APIs/exports
2. **Transform:** Normalize, enrich, and aggregate data
3. **Store:** Data warehouse or lakehouse
4. **Analyze:** Query and analyze cost trends
5. **Visualize:** Dashboards and reports
6. **Alert:** Anomaly detection and notifications

**Tools by Stage:**
| Stage | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Ingest | S3 (CUR) | Storage (exports) | BigQuery (export) |
| Transform | Glue, Lambda | Data Factory | Dataflow |
| Store | Athena, Redshift | Synapse | BigQuery |
| Visualize | QuickSight | Power BI | Looker Studio |
| Alert | CloudWatch, SNS | Monitor, Logic Apps | Cloud Monitoring |

### Anomaly Detection

**Threshold-based:**
- Static thresholds (alert when spending exceeds $X)
- Percentage change (alert when spending increases Y%)
- Per-service thresholds

**ML-based:**
- AWS Cost Anomaly Detection
- Azure Anomaly Detector
- Custom models using historical data

**[📖 AWS Cost Anomaly Detection](https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html)** - AWS anomaly detection

## Domain 3: Rate and Usage Optimization (30%)

### Automated Right-sizing

**Implementation Approach:**
1. Collect utilization metrics (CloudWatch, Azure Monitor, Cloud Monitoring)
2. Analyze against thresholds (CPU <40%, Memory <50%)
3. Generate right-sizing recommendations
4. Create change requests or auto-implement
5. Validate performance post-change

**AWS Compute Optimizer Integration:**
- API: `GetEC2InstanceRecommendations`
- Returns recommended instance type and projected savings
- Considers 14 days of utilization data
- Exportable to S3 for batch processing

**[📖 AWS Compute Optimizer API](https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/Welcome.html)** - API reference
**[📖 Azure Advisor REST API](https://learn.microsoft.com/en-us/rest/api/advisor/)** - Azure recommendations API

### Spot Instance Engineering

**AWS Spot Best Practices:**
- Use Spot Fleet with capacity-optimized allocation
- Implement instance diversification (multiple types/AZs)
- Handle interruption notifications via EC2 metadata
- Use Spot placement scores for capacity prediction
- Integrate with Auto Scaling Groups mixed instances policy

**Interruption Handling:**
- Poll EC2 metadata endpoint every 5 seconds
- Drain connections and save state on 2-minute warning
- Use SQS for spot interruption events via EventBridge
- Implement checkpointing for long-running jobs

**[📖 Spot Instance Advisor](https://aws.amazon.com/ec2/spot/instance-advisor/)** - Interruption frequency data
**[📖 Spot Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html)** - AWS spot documentation

### Resource Scheduling

**AWS Instance Scheduler:**
- CloudFormation-based solution
- DynamoDB for schedule configuration
- Lambda functions for start/stop operations
- Tag-based resource selection

**Custom Scheduling with Lambda:**
- EventBridge cron rules trigger Lambda
- Lambda starts/stops tagged resources
- CloudWatch metrics track savings
- SNS notifications for schedule events

**[📖 AWS Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/solution-overview.html)** - AWS scheduling solution

### Waste Detection Automation

**Automated Checks:**
- Unattached EBS volumes (describe-volumes with no attachments)
- Idle EC2 instances (CloudWatch CPU <2% for 7 days)
- Unused Elastic IPs (describe-addresses with no association)
- Old snapshots (beyond retention policy)
- Unused load balancers (no healthy targets)

## Domain 4: Automation and Tooling (20%)

### Policy as Code

**Open Policy Agent (OPA):**
- Write policies in Rego language
- Evaluate Terraform plans before apply
- Enforce instance type restrictions
- Validate tagging requirements

**HashiCorp Sentinel:**
- Integrated with Terraform Enterprise/Cloud
- Enforce cost policies on infrastructure changes
- Require approval for expensive resources
- Block non-compliant deployments

**AWS Service Control Policies:**
- Restrict services and regions at organization level
- Prevent creation of expensive instance types
- Require encryption on all storage
- Enforce tag requirements

**[📖 OPA Documentation](https://www.openpolicyagent.org/docs/latest/)** - Open Policy Agent
**[📖 Sentinel Documentation](https://docs.hashicorp.com/sentinel)** - HashiCorp Sentinel

### FinOps Tool Ecosystem

**Cloud-Native Tools:**
| Tool | Provider | Purpose |
|------|----------|---------|
| Cost Explorer | AWS | Cost analysis and forecasting |
| Compute Optimizer | AWS | Right-sizing recommendations |
| Trusted Advisor | AWS | Optimization checks |
| Cost Management | Azure | Cost analysis and budgets |
| Azure Advisor | Azure | Optimization recommendations |
| Cloud Billing | GCP | Cost reporting and analysis |
| Recommender | GCP | Optimization suggestions |

**Third-Party Platforms:**
| Platform | Key Features |
|----------|-------------|
| Apptio Cloudability | Multi-cloud cost management, RI optimization |
| CloudHealth (VMware) | Multi-cloud governance and optimization |
| Spot by NetApp | Spot management, container optimization |
| Kubecost | Kubernetes cost allocation and optimization |
| Infracost | Terraform cost estimation in CI/CD |
| Vantage | Cost reporting and optimization |

**[📖 FinOps Landscape](https://www.finops.org/landscape/)** - Complete tool ecosystem
**[📖 FinOps Certified Platforms](https://www.finops.org/members/certified-platforms/)** - Certified platforms

### Event-Driven Cost Management

**Architecture Pattern:**
- CloudTrail/Activity Log events trigger Lambda/Functions
- Evaluate new resources against cost policies
- Auto-tag resources missing required tags
- Alert on creation of expensive resources
- Enforce scheduling tags on non-production resources

## Domain 5: Governance and Compliance (10%)

### Budget Automation

**AWS Budgets API:**
- Create budgets programmatically
- Set alerts with SNS notifications
- Trigger Lambda actions on budget thresholds
- Track budget vs actual spending

**Budget Actions:**
- Apply IAM policies to restrict spending
- Apply SCPs to limit service access
- Trigger custom Lambda functions
- Send notifications to stakeholders

**[📖 AWS Budgets API](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_budgets_CreateBudget.html)** - Budgets API reference
**[📖 Azure Budgets API](https://learn.microsoft.com/en-us/rest/api/consumption/budgets)** - Azure budget management

### Compliance Monitoring

**AWS Config Rules for Cost:**
- `required-tags` - Ensure mandatory tags exist
- `desired-instance-type` - Restrict instance types
- `ebs-optimized-instance` - Require EBS optimization
- Custom rules for organization-specific policies

**Azure Policy for Cost:**
- Require tags on resource groups
- Allowed resource types
- Allowed locations
- Allowed VM SKUs

**[📖 AWS Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)** - Managed rules list
**[📖 Azure Policy Built-in](https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies)** - Built-in policies

## Exam Tips

1. **Focus on automation** - The engineer exam emphasizes building, not just understanding
2. **Know the APIs** - CUR schema, Cost Management API, BigQuery billing tables
3. **Understand data pipelines** - How billing data flows from source to dashboard
4. **Policy as code is critical** - OPA, Sentinel, SCPs, Azure Policy
5. **Practice with real tools** - Hands-on experience with cloud cost APIs helps
6. **Multi-cloud awareness** - Know equivalent tools across AWS, Azure, and GCP
7. **Integration patterns** - How FinOps connects to CI/CD, IaC, and monitoring
8. **Spot engineering** - Interruption handling, fleet management, and diversification
9. **Tagging automation** - Enforcement, remediation, and compliance monitoring
10. **Unit economics at scale** - Building systems that measure business value metrics
