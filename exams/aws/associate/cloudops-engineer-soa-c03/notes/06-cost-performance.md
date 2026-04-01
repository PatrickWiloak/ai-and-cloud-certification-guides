# Cost and Performance Optimization

**[AWS Cost Management](https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costmanagement.html)** - Cost optimization tools

## AWS Cost Explorer

**[Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html)** - Visualize and analyze costs

### Key Features
- Visualize cost and usage data over time
- Filter by service, account, region, tag, instance type
- Daily or monthly granularity
- Forecasting for future cost estimates
- Reservation and Savings Plan recommendations

### Common Reports
- **Monthly costs by service** - identify top spending services
- **Daily costs with trend** - spot cost anomalies
- **Cost by linked account** - multi-account cost tracking
- **Instance type usage** - identify right-sizing opportunities
- **Reserved Instance utilization** - track RI usage efficiency

### Cost Allocation Tags
- **AWS-generated tags** - `aws:createdBy`, `aws:cloudformation:stack-name`
- **User-defined tags** - custom key-value pairs for cost tracking
- Activate tags in Billing console to appear in Cost Explorer
- Use for: department, project, environment, cost center

**[Cost Allocation Tags](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html)** - Organize costs with tags

## AWS Budgets

**[AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)** - Budget alerts and actions

### Budget Types
- **Cost budget** - track spending against a threshold
- **Usage budget** - track service usage (hours, GB, requests)
- **Reservation budget** - track RI and Savings Plan utilization
- **Savings Plans budget** - track Savings Plan coverage

### Alerts and Actions
- Email and SNS notifications when thresholds are reached
- Configurable thresholds: actual cost, forecasted cost
- **Budget Actions** - automated responses to budget alerts:
  - Apply IAM policy to restrict access
  - Apply SCP to restrict account actions
  - Stop EC2 or RDS instances

### Best Practices
- Set budgets at account and service level
- Configure both actual and forecasted alerts
- Set alerts at 50%, 75%, 90%, and 100% thresholds
- Use budget actions for automated cost control

## AWS Trusted Advisor

**[Trusted Advisor](https://docs.aws.amazon.com/awssupport/latest/user/trusted-advisor.html)** - Best practice recommendations

### Check Categories
- **Cost Optimization** - idle resources, underutilized instances, unused EIPs
- **Performance** - high utilization instances, CloudFront optimization
- **Security** - open security groups, IAM use, MFA on root
- **Fault Tolerance** - Multi-AZ, backup, replication
- **Service Limits** - approaching service quotas

### Access Levels
- **Basic/Developer support** - 7 core security checks (limited)
- **Business/Enterprise support** - all checks available
- **API access** - programmatic access to check results

### Key Checks for Operations
- Underutilized EC2 instances
- Idle load balancers
- Unassociated Elastic IP addresses
- Amazon RDS idle DB instances
- Low utilization Amazon EBS volumes
- Security groups with unrestricted access (0.0.0.0/0)
- Service limits approaching threshold

## AWS Compute Optimizer

**[Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is-compute-optimizer.html)** - Right-sizing recommendations

### Supported Resources
- EC2 instances
- Auto Scaling Groups
- EBS volumes
- Lambda functions
- ECS services on Fargate

### How It Works
- Analyzes CloudWatch metrics (CPU, memory, network, disk)
- Uses ML to identify optimal resource configurations
- Provides recommendations with estimated savings
- Risk levels: Very Low, Low, Medium, High

### Recommendation Types
- **Over-provisioned** - reduce instance size for cost savings
- **Under-provisioned** - increase instance size for performance
- **Optimized** - current configuration is appropriate
- **Not optimized** - change instance family for better fit

## Reserved Instances and Savings Plans

### Reserved Instances

**[Reserved Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-reserved-instances.html)** - Capacity reservations

**Standard RIs**:
- Up to 72% discount vs On-Demand
- 1-year or 3-year term
- Payment options: All Upfront, Partial Upfront, No Upfront
- Can modify AZ, instance size (within family), network type
- Cannot change instance family, OS, or tenancy

**Convertible RIs**:
- Up to 66% discount vs On-Demand
- Can change instance family, OS, tenancy
- Must exchange for equal or greater value
- 1-year or 3-year term

### Savings Plans

**[Savings Plans](https://docs.aws.amazon.com/savingsplans/latest/userguide/what-is-savings-plans.html)** - Flexible pricing

**Compute Savings Plans**:
- Up to 66% discount
- Applies to any EC2, Fargate, or Lambda usage
- Any instance family, region, OS, or tenancy
- Most flexible option

**EC2 Instance Savings Plans**:
- Up to 72% discount
- Specific instance family and region
- Flexible on size, OS, and tenancy
- Best discount for predictable EC2 usage

### Spot Instances

**[Spot Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html)** - Spare capacity pricing

- Up to 90% discount vs On-Demand
- Can be interrupted with 2-minute warning
- Best for: batch processing, data analysis, CI/CD, testing
- Use Spot Fleet for diversification across instance types and AZs
- Not suitable for: databases, stateful applications, production web servers

## Performance Optimization

### EC2 Performance

**Right-Sizing**:
- Use Compute Optimizer recommendations
- Monitor CloudWatch metrics for utilization patterns
- Consider burstable instances (T3/T4g) for variable workloads
- Test with different instance families before committing

**Enhanced Networking**:
- Elastic Network Adapter (ENA) - up to 100 Gbps
- Elastic Fabric Adapter (EFA) - HPC workloads
- Placement groups for low-latency communication
- EBS-optimized instances for dedicated storage bandwidth

**[Enhanced Networking](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking.html)** - High performance networking

### EBS Performance

**Volume Types**:
- **gp3** - general purpose SSD, 3000 IOPS baseline, up to 16,000
- **gp2** - general purpose SSD, burst performance based on size
- **io2 Block Express** - highest performance, up to 256,000 IOPS
- **st1** - throughput optimized HDD, sequential reads
- **sc1** - cold HDD, infrequent access

**Optimization Tips**:
- Use gp3 instead of gp2 for cost savings with predictable IOPS
- Pre-warm volumes restored from snapshots (first read penalty)
- Enable EBS-optimized on supported instances
- Monitor VolumeQueueLength for I/O bottlenecks

### Database Performance

**RDS Proxy**:
- Connection pooling for RDS and Aurora
- Reduces database connection overhead
- Improves failover times (60% faster)
- Supports IAM authentication

**[RDS Proxy](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html)** - Database connection management

**DynamoDB DAX**:
- In-memory cache for DynamoDB
- Microsecond read latency
- Write-through caching
- Compatible with DynamoDB API

**[DynamoDB DAX](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html)** - In-memory acceleration

**Aurora Serverless v2**:
- Auto-scaling database capacity
- Scales in increments of 0.5 ACU
- Minimum and maximum ACU settings
- Scales to zero with Aurora Serverless v2 (with limitations)

**[Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)** - Auto-scaling database

**Read Replicas**:
- Offload read traffic from primary database
- Up to 5 read replicas for RDS, 15 for Aurora
- Cross-region read replicas for global performance
- Can be promoted to standalone database

### Caching Strategies

**ElastiCache**:
- **Redis** - complex data types, persistence, pub/sub, replication
- **Memcached** - simple caching, multi-threaded, no persistence
- Lazy loading: load data into cache on cache miss
- Write-through: write to cache when writing to database
- TTL: set expiration to prevent stale data

### CloudFront Performance
- Cache static and dynamic content at edge locations
- Custom cache policies for different content types
- Origin Shield for reducing origin load
- Compress content for faster delivery

## Cost Optimization Strategies

### Quick Wins
1. Delete unattached EBS volumes
2. Release unused Elastic IPs
3. Terminate idle instances
4. Clean up old snapshots
5. Review and delete unused security groups and load balancers

### Medium-Term Strategies
1. Right-size instances based on utilization data
2. Purchase Reserved Instances or Savings Plans for steady-state
3. Use Spot Instances for fault-tolerant workloads
4. Implement S3 lifecycle policies for storage tiering
5. Use VPC endpoints to reduce NAT Gateway costs

### Long-Term Architecture
1. Adopt serverless where appropriate (Lambda, Fargate, Aurora Serverless)
2. Design for auto-scaling to match demand
3. Implement data lifecycle management
4. Use multi-tier storage strategies
5. Consolidate accounts with Organizations for volume discounts

## Key Takeaways

1. **Cost Explorer** - primary tool for cost analysis and forecasting
2. **Budgets** - set alerts and automated actions on spending thresholds
3. **Trusted Advisor** - best practice checks (full access requires Business support)
4. **Compute Optimizer** - ML-based right-sizing recommendations
5. **Right-size first** - before committing to Reserved Instances
6. **Savings Plans** - more flexible than Reserved Instances for most use cases
7. **Spot Instances** - up to 90% savings for fault-tolerant workloads
8. **Caching** - ElastiCache, DAX, and CloudFront reduce load and improve performance
