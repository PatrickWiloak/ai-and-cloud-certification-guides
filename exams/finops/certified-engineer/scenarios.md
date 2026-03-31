# FinOps Certified Engineer - Practice Scenarios

## Scenario 1: Cost Data Pipeline Design

**Situation:** A company processes $2M/month in AWS spending across 50 accounts in an AWS Organization. The FinOps team needs to build a cost data pipeline that provides near-real-time cost visibility, enables cross-account cost allocation, and supports custom reporting. They currently rely on manual Cost Explorer analysis.

**Question:** What is the most effective architecture for this cost data pipeline?

A) Use AWS Cost Explorer API to pull data into an RDS database and build reports with custom scripts
B) Enable CUR delivery to S3 in Parquet format, use Glue crawler to catalog the data, query with Athena, and visualize with QuickSight
C) Export billing data to CSV and process it with Excel macros shared across teams
D) Use AWS Budgets API to pull spending data into a Lambda function that stores results in DynamoDB

**Correct Answer:** B

**Explanation:** The Cost and Usage Report (CUR) in Parquet format provides the most detailed billing data with efficient storage and querying. Delivering to S3 with Glue cataloging enables SQL queries via Athena without managing infrastructure. QuickSight provides automated dashboards. This pattern scales to any number of accounts and supports complex cost allocation queries using CUR resource tags and account fields.

**Why other answers are wrong:**
- A) Cost Explorer API has rate limits and does not provide resource-level detail like CUR
- C) CSV/Excel does not scale - manual processing of $2M monthly billing data is error-prone and slow
- D) Budgets API is for budget management, not detailed cost analytics - DynamoDB is wrong data store for analytical queries

---

## Scenario 2: Tagging Enforcement Automation

**Situation:** A company has a tagging policy requiring `cost-center`, `environment`, `owner`, and `project` tags on all resources. Despite the policy, tag compliance is only 40%. The FinOps engineer needs to improve compliance to 95%+ while minimizing disruption to engineering teams.

**Question:** What is the best engineering approach to achieve 95%+ tag compliance?

A) Send weekly email reports showing untagged resources and ask teams to fix them manually
B) Implement a multi-layer approach: preventive controls (SCPs/Azure Policy to deny untagged resource creation), detective controls (AWS Config rules to identify non-compliant resources), and corrective controls (Lambda function to auto-tag resources using owner lookup from CloudTrail)
C) Delete all untagged resources immediately to enforce compliance
D) Add tags to all existing resources using a one-time script and hope teams tag future resources correctly

**Correct Answer:** B

**Explanation:** A multi-layer approach addresses the problem at every stage. Preventive controls stop untagged resources from being created. Detective controls identify existing non-compliant resources. Corrective controls auto-remediate by looking up the resource creator from CloudTrail and applying default tags. This approach is automated, scalable, and minimizes manual effort while achieving high compliance.

**Why other answers are wrong:**
- A) Manual email-based processes do not scale and have low compliance rates
- C) Deleting resources is destructive and would cause outages - never appropriate
- D) One-time scripts do not address ongoing compliance - tag drift will recur immediately

---

## Scenario 3: Spot Instance Architecture

**Situation:** A company runs a batch processing pipeline that processes 10TB of data daily. The pipeline uses 100 r5.2xlarge instances running for 8 hours. Currently running on-demand at ~$4,000/day. The FinOps engineer wants to reduce costs using spot instances while maintaining reliable pipeline completion.

**Question:** How should the FinOps engineer architect the spot instance strategy?

A) Replace all 100 on-demand instances with spot instances of the same type
B) Use a Spot Fleet with capacity-optimized allocation across multiple instance types (r5.2xlarge, r5a.2xlarge, r5d.2xlarge, r6i.2xlarge) and multiple AZs, with checkpointing every 15 minutes, and a 20% on-demand base capacity
C) Use spot instances only during off-peak hours when prices are lowest
D) Purchase 1-year Reserved Instances for the full 100 instances since usage is predictable

**Correct Answer:** B

**Explanation:** The capacity-optimized allocation strategy across multiple instance types and AZs maximizes availability and minimizes interruptions. Instance diversification reduces the impact of capacity shortages in any single pool. Checkpointing every 15 minutes ensures minimal work loss on interruption. The 20% on-demand base guarantees minimum pipeline capacity even during spot shortages. This can save 60-70% vs full on-demand.

**Why other answers are wrong:**
- A) Single instance type in a single pool has high interruption risk - no diversification
- C) Spot pricing is dynamic and not predictable by time of day
- D) RIs for 8-hour daily usage wastes 67% of the commitment - batch workloads are ideal for spot

---

## Scenario 4: Kubernetes Cost Allocation

**Situation:** A company runs a shared EKS cluster with 200 nodes serving 15 application teams. Monthly cluster cost is $150K. Teams deploy using namespaces with resource requests and limits. The FinOps engineer needs to implement per-team cost allocation that accounts for shared cluster overhead (kube-system, monitoring, ingress controllers).

**Question:** What is the best approach to implement Kubernetes cost allocation?

A) Divide total cost equally among 15 teams ($10K each)
B) Deploy Kubecost to calculate per-namespace costs based on actual CPU and memory usage, allocate shared overhead proportionally to each team's resource consumption, and integrate with the company's FinOps reporting pipeline
C) Only track node-level costs and assign nodes to specific teams
D) Use AWS CUR data to allocate costs based on EC2 instance tags only

**Correct Answer:** B

**Explanation:** Kubecost provides granular Kubernetes cost allocation at the namespace, deployment, and pod level based on actual resource consumption. It can separate shared costs (cluster overhead) and distribute them proportionally. Integration with the FinOps reporting pipeline ensures Kubernetes costs appear alongside other cloud costs for holistic visibility. This approach is accurate, automated, and scalable.

**Why other answers are wrong:**
- A) Equal division ignores actual usage - a team using 50% of resources pays the same as one using 2%
- C) Node-level allocation loses visibility into multi-tenant namespaces sharing the same nodes
- D) CUR data shows EC2 costs but cannot attribute them to specific Kubernetes workloads

---

## Scenario 5: CI/CD Cost Validation

**Situation:** A company deploys infrastructure changes via Terraform through GitHub Actions CI/CD pipelines. Engineers frequently deploy resources that exceed budget expectations, and the FinOps team only discovers cost impacts weeks later. The FinOps engineer needs to add cost visibility before changes are applied.

**Question:** What is the most effective approach to prevent unexpected cost increases from infrastructure changes?

A) Require FinOps team manual review of every Terraform change before deployment
B) Integrate Infracost into the GitHub Actions pipeline to estimate cost changes, post cost impact as a PR comment, enforce a cost threshold policy that requires approval for changes exceeding $500/month, and log all cost estimates for trending
C) Block all Terraform changes and only allow the FinOps team to deploy infrastructure
D) Run a daily cost report and compare against yesterday's spending

**Correct Answer:** B

**Explanation:** Infracost analyzes Terraform plan output and estimates the cost impact of infrastructure changes. Integrating it into the PR workflow gives engineers immediate visibility into cost implications before merging. A threshold policy requiring approval for significant cost increases adds a governance layer. Logging estimates enables tracking estimation accuracy over time. This approach is automated, non-blocking for small changes, and scales to any number of pipelines.

**Why other answers are wrong:**
- A) Manual review creates a bottleneck and does not scale
- C) Blocking all changes would halt engineering productivity entirely
- D) Daily cost reports are reactive - changes are already deployed and costs are already incurred

---

## Scenario 6: Multi-Cloud Cost Normalization

**Situation:** A company runs workloads across AWS (60%), Azure (25%), and GCP (15%). Each cloud has different billing data formats, tagging conventions, and pricing structures. The FinOps engineer needs to create a unified cost reporting system that allows apples-to-apples comparison across providers.

**Question:** What architecture should the FinOps engineer build?

A) Export all billing data to a single cloud provider's native tool (AWS Cost Explorer)
B) Build an ETL pipeline that ingests billing data from all three providers (CUR from S3, Azure exports from Storage, GCP from BigQuery), normalizes schemas to a common data model, applies unified tag mapping, and stores in a centralized data warehouse for cross-cloud reporting
C) Use three separate dashboards - one per cloud provider
D) Manually combine monthly invoices from each provider in a spreadsheet

**Correct Answer:** B

**Explanation:** Cross-cloud cost management requires a normalization layer. An ETL pipeline ingests provider-specific billing formats and transforms them into a common schema. Unified tag mapping ensures that cost allocation works consistently across providers (e.g., AWS tags, Azure tags, and GCP labels mapped to the same business entities). A centralized data warehouse enables cross-cloud queries, comparisons, and reporting.

**Why other answers are wrong:**
- A) AWS Cost Explorer only shows AWS costs - it cannot ingest Azure or GCP billing data
- C) Separate dashboards prevent cross-cloud comparison and create siloed views
- D) Manual spreadsheet processes do not scale and are error-prone

---

## Scenario 7: Automated Waste Remediation

**Situation:** A FinOps engineer has identified $50K/month in waste: 300 unattached EBS volumes, 45 idle EC2 instances (CPU <1% for 30 days), 80 unused Elastic IPs, and 200 snapshots older than 90 days. The engineer needs to build an automated remediation system that safely removes waste without impacting production.

**Question:** What is the safest and most effective approach to automated waste remediation?

A) Write a script that immediately deletes all identified waste resources
B) Implement a staged remediation pipeline: (1) detect waste using AWS Config and Lambda, (2) notify resource owners with 7-day warning, (3) tag resources for deletion, (4) snapshot before deletion for safety, (5) delete after grace period with audit logging
C) Create a ticket for each waste resource and assign to teams for manual cleanup
D) Only remediate resources that have been idle for over 6 months to be safe

**Correct Answer:** B

**Explanation:** A staged remediation pipeline balances safety with automation. Detection identifies waste automatically. Owner notification provides a grace period to reclaim resources that are actually needed. Tagging creates an audit trail. Pre-deletion snapshots provide a safety net for accidental deletions. The grace period prevents impact from false positives. Audit logging supports compliance and troubleshooting.

**Why other answers are wrong:**
- A) Immediate deletion is risky - some "waste" resources may be needed (e.g., disaster recovery instances at 0% CPU)
- C) Manual ticket-based cleanup does not scale for 625 resources and has low completion rates
- D) Waiting 6 months for remediation means paying for waste for months longer than necessary

---

## Scenario 8: Commitment Management Automation

**Situation:** A company has $500K/month in EC2 spending with 45% RI/Savings Plan coverage. Current commitments are a mix of 1-year Standard RIs purchased at various times. Some RIs are underutilized (70% utilization), and there are no Savings Plans. The FinOps engineer needs to optimize the commitment portfolio.

**Question:** What is the best engineering approach to improve commitment management?

A) Purchase 3-year All Upfront RIs to cover the remaining 55% of spend
B) Build a commitment management system that: analyzes 90-day usage trends to identify stable baseline, models different commitment scenarios (RI vs Savings Plans), monitors existing commitment utilization with alerts at 80% threshold, automates recommendations for expiring commitments, and gradually migrates from Standard RIs to Compute Savings Plans for flexibility
C) Cancel all existing RIs and start fresh with Savings Plans
D) Do nothing until existing RIs expire and then evaluate

**Correct Answer:** B

**Explanation:** A systematic commitment management approach uses data-driven analysis of usage patterns to determine optimal coverage. Modeling different scenarios helps choose between RIs and Savings Plans based on workload characteristics. Monitoring utilization ensures existing commitments are fully used. Automating recommendations for expiring commitments prevents coverage gaps. Migrating to Compute Savings Plans provides more flexibility as workloads evolve.

**Why other answers are wrong:**
- A) Covering 100% with 3-year commitments is risky - workloads may change significantly
- C) Standard RIs cannot be cancelled - they must be sold on the marketplace or allowed to expire
- D) Waiting does nothing about the underutilized RIs or the 55% uncovered spend
