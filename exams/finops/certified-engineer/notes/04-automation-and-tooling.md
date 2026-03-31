# Automation and Tooling

**[📖 FinOps Capabilities](https://www.finops.org/framework/capabilities/)** - All FinOps capabilities

## Overview

This document covers FinOps automation, tooling, and engineering practices for implementing cost management at scale. Automation reduces manual effort and ensures consistent cost governance across cloud environments.

## Cost Automation Patterns

### Automated Tagging
```python
# AWS Lambda function to auto-tag untagged EC2 instances
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    # Find instances without required tags
    instances = ec2.describe_instances(
        Filters=[{'Name': 'tag-key', 'Values': ['team']}]
    )
    
    all_instances = ec2.describe_instances()
    
    for reservation in all_instances['Reservations']:
        for instance in reservation['Instances']:
            tags = {t['Key']: t['Value'] for t in instance.get('Tags', [])}
            if 'team' not in tags:
                # Tag with default and alert
                ec2.create_tags(
                    Resources=[instance['InstanceId']],
                    Tags=[
                        {'Key': 'team', 'Value': 'unassigned'},
                        {'Key': 'needs-tagging', 'Value': 'true'}
                    ]
                )
```

### Scheduled Resource Management
```python
# Start/stop development instances on schedule
# AWS CloudWatch Events + Lambda or AWS Instance Scheduler

# Pattern:
# 1. Tag dev resources: schedule=business-hours
# 2. Lambda runs on cron: stop at 7 PM, start at 7 AM
# 3. Skip weekends
# 4. Savings: ~65% on dev/test compute

# AWS:
# - AWS Instance Scheduler (official solution)
# - CloudWatch Events + Lambda (custom)

# Azure:
# - Azure Automation with Start/Stop VMs
# - Azure DevTest Labs auto-shutdown

# GCP:
# - Cloud Scheduler + Cloud Functions
# - Instance schedules (native)
```

### Automated Right-Sizing
```
# Right-sizing automation workflow:
1. Collect metrics (CloudWatch, Azure Monitor, GCP Monitoring)
   - CPU utilization (14-day average and P95)
   - Memory utilization
   - Network I/O

2. Generate recommendations
   - AWS Compute Optimizer API
   - Azure Advisor API
   - GCP Recommender API

3. Create tickets (Jira, ServiceNow)
   - Include current size, recommended size, estimated savings
   - Assign to resource owner

4. Implement (with approval)
   - Automated for non-production
   - Approval workflow for production

5. Validate
   - Monitor performance post-change
   - Rollback if issues detected
```

### Budget Alerts and Enforcement
```json
# AWS Budget with actions
{
  "BudgetName": "team-platform-monthly",
  "BudgetLimit": {
    "Amount": "10000",
    "Unit": "USD"
  },
  "BudgetType": "COST",
  "TimePeriod": {
    "Start": "2024-01-01",
    "End": "2087-06-15"
  },
  "TimeUnit": "MONTHLY",
  "CostFilters": {
    "TagKeyValue": ["user:team$platform"]
  },
  "NotificationsWithSubscribers": [
    {
      "Notification": {
        "NotificationType": "ACTUAL",
        "ComparisonOperator": "GREATER_THAN",
        "Threshold": 80,
        "ThresholdType": "PERCENTAGE"
      },
      "Subscribers": [
        {"SubscriptionType": "EMAIL", "Address": "platform-leads@company.com"},
        {"SubscriptionType": "SNS", "Address": "arn:aws:sns:us-east-1:123456:budget-alerts"}
      ]
    }
  ]
}
```

## Infrastructure as Code (IaC) for FinOps

### Terraform Cost Estimation
```hcl
# Use Infracost for Terraform cost estimation
# infracost breakdown --path=.

# Example: estimate cost before applying
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "m5.xlarge"  # $0.192/hr = ~$140/month
  
  tags = {
    team        = "platform"
    environment = "production"
    cost-center = "CC-1001"
  }
}

# Infracost output:
# Name                 Monthly Cost
# aws_instance.web     $140.16
# Total                $140.16
```

**[📖 Infracost](https://www.infracost.io/docs/)** - Terraform cost estimation

### Policy as Code
```python
# Open Policy Agent (OPA) / Cloud Custodian examples

# Cloud Custodian: Find untagged resources
# policies:
#   - name: untagged-ec2
#     resource: aws.ec2
#     filters:
#       - "tag:team": absent
#     actions:
#       - type: notify
#         subject: "Untagged EC2 Instance Found"
#         to: ["finops@company.com"]

# Cloud Custodian: Stop idle instances
# policies:
#   - name: stop-idle-instances
#     resource: aws.ec2
#     filters:
#       - type: metrics
#         name: CPUUtilization
#         statistics: Average
#         period: 604800  # 7 days
#         value: 5
#         op: less-than
#     actions:
#       - type: stop
```

**[📖 Cloud Custodian](https://cloudcustodian.io/docs/)** - Policy engine documentation

### CI/CD Cost Gates
```yaml
# GitHub Actions example: cost estimation in PR
name: Cost Estimation
on: pull_request
jobs:
  infracost:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: infracost/actions/setup@v3
        with:
          api-key: ${{ secrets.INFRACOST_API_KEY }}
      - run: infracost breakdown --path=. --format=json --out-file=/tmp/infracost.json
      - uses: infracost/actions/comment@v3
        with:
          path: /tmp/infracost.json
          behavior: update
```

## Cloud Provider Cost APIs

### AWS Cost Explorer API
```python
import boto3

client = boto3.client('ce')

# Get cost and usage
response = client.get_cost_and_usage(
    TimePeriod={
        'Start': '2024-01-01',
        'End': '2024-02-01'
    },
    Granularity='DAILY',
    Metrics=['BlendedCost', 'UnblendedCost', 'UsageQuantity'],
    GroupBy=[
        {'Type': 'DIMENSION', 'Key': 'SERVICE'},
        {'Type': 'TAG', 'Key': 'team'}
    ]
)

# Get right-sizing recommendations
compute_optimizer = boto3.client('compute-optimizer')
recommendations = compute_optimizer.get_ec2_instance_recommendations()
```

**[📖 AWS Cost Explorer API](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/)** - Cost API

### Azure Cost Management API
```python
# Azure Cost Management REST API
import requests

url = "https://management.azure.com/subscriptions/{sub_id}/providers/Microsoft.CostManagement/query"
headers = {"Authorization": f"Bearer {token}"}
body = {
    "type": "ActualCost",
    "timeframe": "MonthToDate",
    "dataset": {
        "granularity": "Daily",
        "aggregation": {
            "totalCost": {"name": "Cost", "function": "Sum"}
        },
        "grouping": [
            {"type": "Dimension", "name": "ServiceName"}
        ]
    }
}
```

**[📖 Azure Cost Management API](https://learn.microsoft.com/en-us/rest/api/cost-management/)** - Cost API

### GCP Cloud Billing API
```sql
-- BigQuery billing export query
SELECT
  service.description AS service,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS total_usage
FROM `project.dataset.gcp_billing_export_v1_XXXXXX`
WHERE invoice.month = '202401'
GROUP BY service
ORDER BY total_cost DESC;
```

**[📖 GCP Billing API](https://cloud.google.com/billing/docs/reference/rest)** - Billing API

## Monitoring and Alerting

### Cost Anomaly Detection
| Provider | Service | Configuration |
|----------|---------|---------------|
| AWS | Cost Anomaly Detection | Service-level or account-level monitors |
| Azure | Cost alerts with anomaly detection | Budget-based anomaly alerts |
| GCP | Budget alerts | Threshold-based with forecasting |

### Alert Strategy
```
Tier 1 (Immediate): > 50% daily increase - page on-call
Tier 2 (Urgent): > 25% daily increase - Slack notification to team
Tier 3 (Informational): > 10% weekly trend - weekly report
Tier 4 (Forecast): Projected to exceed budget - monthly review
```

## Automation Maturity

### Crawl
- Manual cost reports (spreadsheets)
- Basic budget alerts via email
- Ad-hoc tagging

### Walk
- Automated cost dashboards
- Scheduled start/stop for dev environments
- Automated tagging enforcement
- Right-sizing recommendations reviewed monthly

### Run
- CI/CD cost gates blocking expensive deployments
- Automated right-sizing with approval workflows
- Real-time anomaly detection and response
- Policy-as-code enforcement for all resources
- Commitment purchasing automation
