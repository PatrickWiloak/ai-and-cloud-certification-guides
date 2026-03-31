# Usage Optimization and Waste Reduction

**[📖 Workload Optimization](https://www.finops.org/framework/capabilities/workload-optimization/)** - FinOps workload optimization
**[📖 Onboarding Workloads](https://www.finops.org/framework/capabilities/onboarding-workloads/)** - New workload management

## Usage Optimization Overview

Usage optimization focuses on reducing the amount of cloud resources consumed by matching capacity to actual workload requirements. Unlike rate optimization (which reduces the price per unit), usage optimization reduces the number of units consumed.

**Two main strategies:**
1. **Right-sizing:** Adjusting resource capacity to match actual needs
2. **Waste elimination:** Removing resources that provide no value

## Right-sizing

### What is Right-sizing?
Right-sizing is the process of matching instance types and sizes to workload performance and capacity requirements at the lowest possible cost.

### Right-sizing Process

**Step 1: Collect utilization data**
- Monitor CPU utilization over 2-4 weeks minimum
- Track memory utilization patterns
- Measure network throughput
- Analyze disk I/O patterns
- Look at peak vs average utilization

**Step 2: Analyze patterns**
- Identify consistently underutilized resources (below 40% average CPU)
- Find resources with bursty patterns (may need different instance family)
- Detect over-provisioned memory or storage
- Look for resources that could benefit from different instance types

**Step 3: Recommend changes**
- Downsize to smaller instance types where utilization is low
- Change instance families to match workload characteristics
- Consider Graviton/ARM instances for compatible workloads
- Evaluate containerization for better resource density

**Step 4: Implement and validate**
- Make changes during maintenance windows
- Monitor performance after changes
- Roll back if performance degrades
- Document savings achieved

### Provider Right-sizing Tools

**AWS:**
- AWS Compute Optimizer - ML-based recommendations
- CloudWatch metrics for utilization data
- Trusted Advisor right-sizing checks
- Cost Explorer right-sizing recommendations

**Azure:**
- Azure Advisor resize recommendations
- Azure Monitor for utilization metrics
- Virtual Machine right-sizing in Cost Management

**GCP:**
- Recommender for VM right-sizing
- Cloud Monitoring for utilization data
- Active Assist recommendations

### Right-sizing Best Practices
- Always check memory utilization (not just CPU)
- Consider peak utilization, not just average
- Right-size before purchasing commitments
- Start with largest over-provisioned resources
- Use automation to implement recurring right-sizing
- Get application team approval before changes

## Waste Identification and Elimination

### Types of Cloud Waste

**Idle Resources:**
Resources that are running but not serving any useful purpose.

| Resource Type | Indicators | Action |
|--------------|-----------|--------|
| EC2 instances | 0-1% CPU for days | Terminate or stop |
| RDS instances | No connections for days | Terminate or snapshot and delete |
| Load balancers | No registered targets or traffic | Delete |
| NAT Gateways | No data processed | Delete if unused |
| ElastiCache clusters | No connections | Delete |

**Orphaned Resources:**
Resources left behind after related resources were deleted.

| Resource Type | How They Become Orphaned | Action |
|--------------|------------------------|--------|
| EBS volumes | EC2 instance terminated without deleting volume | Delete after backup |
| Elastic IPs | Instance terminated, IP not released | Release |
| Snapshots | Source volume deleted, snapshots remain | Delete old snapshots |
| AMIs | No longer used for launching instances | Deregister |
| Security Groups | Not attached to any resources | Delete unused |

**Development and Testing Waste:**
Resources running outside of business hours or after projects end.

| Waste Type | Solution |
|-----------|----------|
| Dev instances running 24/7 | Schedule to stop nights/weekends |
| Test environments left running | Auto-terminate after test completion |
| Sandbox environments | Set expiration dates and auto-cleanup |
| Demo environments | Schedule or delete when unused |

**Storage Waste:**
- Old snapshots beyond retention policy
- Uncompressed data that could be compressed
- Data in expensive storage tiers that could be tiered down
- Duplicate data across regions
- Logs retained beyond compliance requirements

### Waste Detection Methods

**Automated Scanning:**
- Use native cloud tools (Trusted Advisor, Azure Advisor, Recommender)
- Set up automated reports on idle and orphaned resources
- Create alerts for resources exceeding waste thresholds
- Use third-party tools for cross-cloud waste detection

**Regular Reviews:**
- Weekly waste review meetings
- Monthly resource audit reports
- Quarterly deep-dive waste assessments
- Annual cleanup events ("Cloud Cleanup Day")

## Scheduling and Automation

### Resource Scheduling

**Development Environments:**
- Stop instances outside business hours (save ~65%)
- Typical schedule: 8am-6pm weekdays
- Use AWS Instance Scheduler, Azure Start/Stop VMs, or GCP VM Scheduler
- Consider time zones for distributed teams

**Testing Environments:**
- Spin up for test runs, tear down after
- Use infrastructure as code (Terraform, CloudFormation)
- Implement auto-expiration for temporary resources
- Tag with end-date for cleanup automation

**Savings Calculation:**
- 24/7 = 168 hours/week
- Business hours only (10h x 5 days) = 50 hours/week
- Savings = (168 - 50) / 168 = ~70% reduction
- With some buffer = ~65% typical savings

### Auto-scaling

**Scaling Strategies for Cost:**
- Target tracking scaling (maintain target utilization)
- Predictive scaling (based on historical patterns)
- Step scaling (incremental capacity changes)
- Scheduled scaling (known traffic patterns)

**Auto-scaling Best Practices:**
- Set appropriate minimum and maximum limits
- Use target tracking at 60-70% CPU for cost optimization
- Implement scale-in protection for processing instances
- Use warm pools to reduce scale-out time
- Monitor scaling events for optimization opportunities

## Architectural Optimization

### Serverless Migration
- Move from EC2 to Lambda for event-driven workloads
- Use API Gateway instead of always-on web servers
- Consider DynamoDB instead of RDS for simple data models
- Use S3 event triggers instead of polling services
- Pay only for actual execution time

### Containerization
- Better resource density than VMs
- Multi-tenant clusters reduce per-workload overhead
- Kubernetes autoscaling for efficient resource use
- Right-size container resource requests and limits
- Use tools like Kubecost for container cost visibility

### Storage Optimization
- Implement lifecycle policies (S3, Azure Blob, GCS)
- Move infrequently accessed data to cheaper tiers
- Use intelligent tiering where available
- Compress data before storage
- Delete data past retention requirements
- Use appropriate storage types (block vs object vs file)

**Storage Tier Comparison (AWS S3):**

| Tier | Access Pattern | Cost Relative |
|------|---------------|---------------|
| S3 Standard | Frequent access | Highest |
| S3 Intelligent-Tiering | Unknown/changing | Auto-optimized |
| S3 Standard-IA | Infrequent access | ~45% less |
| S3 One Zone-IA | Infrequent, single AZ OK | ~60% less |
| S3 Glacier Instant | Archive, millisecond access | ~68% less |
| S3 Glacier Flexible | Archive, minutes to hours | ~75% less |
| S3 Glacier Deep Archive | Long-term archive, 12 hours | ~95% less |

### Data Transfer Optimization
- Use VPC endpoints to avoid NAT Gateway charges
- Leverage CDN for frequently accessed content
- Optimize cross-region data transfer
- Use AWS Direct Connect or Azure ExpressRoute for high-volume transfers
- Compress data before transfer

## Measuring Optimization Success

### Key Metrics
- Total waste eliminated (dollars/month)
- Average resource utilization (target: 60-70%)
- Number of idle resources detected and resolved
- Right-sizing recommendations implemented vs pending
- Storage optimization savings
- Scheduling savings from dev/test environments

### Optimization Targets

| Metric | Crawl | Walk | Run |
|--------|-------|------|-----|
| Resource utilization | >30% | >50% | >65% |
| Waste as % of spend | <20% | <10% | <5% |
| Right-sizing coverage | Monthly review | Weekly review | Automated |
| Scheduling adoption | Some dev envs | All non-prod | Automated |

## Key Exam Tips for This Domain

1. **Right-size before committing** - Always right-size resources before purchasing RIs or Savings Plans
2. **Waste has many forms** - Idle, orphaned, unscheduled, over-provisioned, and misarchitected
3. **Scheduling saves ~65%** - Stopping dev/test resources outside business hours
4. **Automation is key** - Manual optimization does not scale
5. **Consider all resource types** - Compute, storage, networking, and databases all have waste
6. **Architectural optimization has highest impact** - Moving to serverless can save 60-80%
7. **Always validate before deleting** - Confirm resources are truly unused before removal
