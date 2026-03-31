# AWS Cost Optimization

## Overview

This guide covers AWS cost management tools, strategies, and best practices for reducing cloud spend while maintaining performance and reliability. Cost optimization is a key topic across all AWS certification exams.

---

## AWS Cost Management Tools

| Tool | Purpose | Access |
|------|---------|--------|
| Cost Explorer | Visualize and analyze spending | AWS Console / API |
| Budgets | Set spending alerts and thresholds | AWS Console |
| Cost and Usage Report (CUR) | Detailed billing data | S3 export |
| Compute Optimizer | Right-sizing recommendations | AWS Console |
| Trusted Advisor | Cost, security, and performance checks | AWS Console |
| Savings Plans | Flexible commitment pricing | AWS Console |
| Reserved Instances | Fixed commitment pricing | AWS Console |
| Cost Anomaly Detection | ML-based spending anomaly alerts | AWS Console |
| Billing Conductor | Custom billing and pricing | AWS Console |

---

## Compute Cost Optimization

### EC2 Pricing Models

| Model | Discount | Commitment | Best For |
|-------|----------|------------|----------|
| On-Demand | 0% | None | Unpredictable, short-term workloads |
| Savings Plans (Compute) | Up to 66% | 1 or 3 year | Flexible compute (EC2, Fargate, Lambda) |
| Savings Plans (EC2 Instance) | Up to 72% | 1 or 3 year | Specific instance family in a region |
| Reserved Instances | Up to 72% | 1 or 3 year | Steady-state workloads |
| Spot Instances | Up to 90% | None (can be interrupted) | Fault-tolerant, flexible workloads |
| Dedicated Hosts | Varies | On-demand or reserved | Licensing, compliance |

### Right-Sizing Strategies

| Strategy | Tool | Action |
|----------|------|--------|
| CPU/Memory analysis | Compute Optimizer | Resize to recommended instance type |
| Utilization monitoring | CloudWatch metrics | Identify under-utilized instances |
| Generation upgrade | Trusted Advisor | Move to latest instance generation (e.g., m5 to m7i) |
| ARM migration | Compute Optimizer | Move to Graviton for 20-40% savings |
| Auto-scaling | Auto Scaling Groups | Scale based on demand |

### Serverless Cost Optimization

| Strategy | Service | Impact |
|----------|---------|--------|
| Right-size memory | Lambda | Smaller memory = lower cost (use Power Tuning) |
| Optimize duration | Lambda | Faster execution = lower cost |
| Use Provisioned Concurrency wisely | Lambda | Only for latency-sensitive paths |
| Fargate Spot | ECS/EKS | Up to 70% savings for fault-tolerant tasks |
| Container right-sizing | ECS/EKS | Match CPU/memory to actual usage |

---

## Storage Cost Optimization

### S3 Storage Classes

| Class | Use Case | Cost (per GB/month, us-east-1) |
|-------|----------|-------------------------------|
| S3 Standard | Frequently accessed | ~$0.023 |
| S3 Intelligent-Tiering | Unknown access patterns | ~$0.023 + monitoring fee |
| S3 Standard-IA | Infrequent access (30+ days) | ~$0.0125 |
| S3 One Zone-IA | Non-critical infrequent access | ~$0.01 |
| S3 Glacier Instant Retrieval | Archive with instant access | ~$0.004 |
| S3 Glacier Flexible Retrieval | Archive (minutes to hours) | ~$0.0036 |
| S3 Glacier Deep Archive | Long-term archive (12+ hours) | ~$0.00099 |

### Storage Optimization Strategies

| Strategy | Action | Savings |
|----------|--------|---------|
| Lifecycle policies | Transition to cheaper classes | 50-90% |
| Intelligent-Tiering | Auto-tier based on access | 20-40% |
| Delete unused snapshots | Clean up old EBS snapshots | Variable |
| gp3 over gp2 | Migrate EBS volumes | 20% |
| EFS Infrequent Access | Lifecycle for EFS | 85% for IA files |

---

## Database Cost Optimization

| Strategy | Service | Action |
|----------|---------|--------|
| Reserved Instances | RDS, ElastiCache, Redshift | 1 or 3 year commitments |
| Aurora Serverless v2 | Aurora | Scale to zero for dev/test |
| Read replicas | RDS/Aurora | Offload reads, smaller primary |
| DynamoDB On-Demand | DynamoDB | For unpredictable workloads |
| DynamoDB Reserved | DynamoDB | For steady-state workloads |
| Graviton instances | RDS | 10-20% lower cost, better performance |

---

## Network Cost Optimization

| Strategy | Description | Savings |
|----------|-------------|---------|
| VPC endpoints | Avoid NAT Gateway data charges | ~$0.045/GB saved |
| CloudFront | Cache at edge, reduce origin traffic | 20-60% egress savings |
| Same-AZ traffic | Keep resources in same AZ when possible | $0.01/GB saved |
| S3 Transfer Acceleration | Only when needed (not always) | Avoid unnecessary charges |
| PrivateLink | Private connectivity without NAT | Avoid internet egress |
| Compress data | Reduce data transfer volume | Proportional to compression ratio |

---

## Organization-Level Optimization

| Strategy | Description |
|----------|-------------|
| Consolidated Billing | Aggregate usage for volume discounts |
| Savings Plans sharing | Share across accounts in Organizations |
| RI sharing | Share Reserved Instances across accounts |
| Tagging strategy | Tag all resources for cost allocation |
| Budget alerts | Set budgets per account/team/project |
| CUR analysis | Detailed billing analysis with Athena/QuickSight |

---

## Cost Optimization Checklist

- [ ] Enable Cost Explorer and set up Budgets
- [ ] Enable Compute Optimizer recommendations
- [ ] Review Trusted Advisor cost checks weekly
- [ ] Implement tagging strategy for cost allocation
- [ ] Analyze Savings Plans recommendations
- [ ] Right-size EC2 instances quarterly
- [ ] Set up S3 lifecycle policies
- [ ] Delete unused EBS volumes and snapshots
- [ ] Review and clean up unused Elastic IPs
- [ ] Optimize NAT Gateway usage with VPC endpoints
- [ ] Enable Cost Anomaly Detection
- [ ] Schedule non-production environments to stop outside business hours

---

## Documentation Links

- AWS Cost Management: https://docs.aws.amazon.com/cost-management/
- AWS Compute Optimizer: https://docs.aws.amazon.com/compute-optimizer/
- AWS Savings Plans: https://docs.aws.amazon.com/savingsplans/
- AWS Pricing Calculator: https://calculator.aws/
- AWS Cost Optimization Pillar: https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/
