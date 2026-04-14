# 03. Workload Rightsizing and Architectural Efficiency

## The Two Levers: Rate and Usage

Rate optimization changes price per unit. Usage optimization changes units consumed. At the Professional level, architectural efficiency is the third lever, often the largest, and the slowest to realize.

## Rightsizing Loop

1. **Observe**: CPU, memory, network, disk, queue depth, p99 latency
2. **Recommend**: provider recommender or custom analysis
3. **Implement**: change size, document expected savings
4. **Validate**: compare before/after; measure actual savings
5. **Close feedback loop**: retrain recommendations on validated outcomes

Rightsizing is not a one-time project. It is a continuous, governed process.

## Rightsizing Signals

- CPU utilization consistently below 20-30 percent (candidate for downsize)
- Memory headroom above 50 percent (candidate for smaller memory SKU)
- Consistently hitting burst credits on burstable instances (candidate for non-burstable)
- Overnight idle workloads (candidate for scheduling)
- Overprovisioned database (read replicas idle, storage unused)

## Provider Rightsizing Tools

- AWS Compute Optimizer: EC2, ASG, Lambda, EBS, RDS recommendations
- Azure Advisor: VM rightsize, unused disks, reserved capacity recs
- GCP Recommender: idle VMs, rightsize, CUD recs

Trust but verify. Recommendations are based on observed utilization windows and may miss seasonal or burst patterns.

## Idle Detection and Scheduling

Classic wastes:

- Dev/test environments running 24/7
- Orphaned load balancers, unattached disks, old snapshots
- Idle RDS / Aurora instances
- Unused Elastic IPs and idle NAT gateways
- Forgotten workloads after team reorgs

Instance Scheduler, AWS Systems Manager Automation, Azure Automation, GCP Cloud Scheduler can enforce on/off schedules. Expected savings: 40-65 percent for non-prod environments.

## Storage Tiering and Lifecycle

### AWS
- S3 Standard, Intelligent-Tiering, Standard-IA, One Zone-IA, Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier Deep Archive
- Lifecycle rules transition objects by age or tag
- Intelligent-Tiering auto-moves based on access pattern (small monitoring fee)

### Azure
- Blob Storage: Hot, Cool, Cold, Archive
- Lifecycle management policies
- Premium for high-performance; Standard for general

### GCP
- Cloud Storage classes: Standard, Nearline, Coldline, Archive
- Object lifecycle management
- Autoclass: auto-transition based on access

Lifecycle is one of the highest-ROI, lowest-risk optimizations available. Yet often missed because no team owns "old objects."

## Compute Architecture Levers

### ARM / Graviton (AWS), Ampere (Azure, GCP)
20-40 percent better price/performance for compatible workloads. Migration typically requires rebuilding binaries but is well-supported in managed services (Lambda, Fargate, RDS, ElastiCache).

### Serverless
Lambda, Cloud Functions, Azure Functions eliminate idle cost. Break-even vs always-on compute depends on utilization; below 30-40 percent utilization, serverless often wins.

### Containers and density
Packing more workloads per node via Kubernetes or ECS increases utilization. Tools: Karpenter (AWS), Cluster Autoscaler, Goldilocks (for vertical pod sizing recs), Kubecost for visibility.

### Spot and preemptible
For stateless, horizontally scalable, or interruption-tolerant workloads, spot can save 60-90 percent. Patterns: diversified instance pools, graceful termination hooks, fallback to on-demand.

## Data Transfer Optimization

Data transfer is frequently the hidden cost.

### AWS data transfer patterns
- Cross-AZ: 0.01-0.02 per GB each way
- Internet egress: tiered, starts around 0.09/GB
- NAT Gateway: 0.045/GB plus per-hour charge
- VPC endpoints: reduce NAT traversal for AWS services
- CloudFront: can be cheaper than direct egress at scale

### Optimization moves
- Use VPC endpoints for S3, DynamoDB, other services
- Co-locate workloads and data in the same AZ when possible
- Front with CloudFront / Azure Front Door / Cloud CDN
- Use private connectivity (Direct Connect, ExpressRoute, Interconnect) for heavy outbound

## Managed Database Economics

- Right-size and right-class (Aurora Serverless v2, Azure SQL Serverless, Spanner autoscaler)
- Storage lifecycle and backup retention
- Read replicas: essential for some workloads, wasted cost in others
- I/O optimized tiers vs standard
- Graviton / ARM for database engines that support it

## Kubernetes Efficiency

- Set requests and limits sanely; over-requesting is the top K8s waste
- Vertical Pod Autoscaler in recommend mode, then selectively enforce
- Cluster Autoscaler or Karpenter for node elasticity
- Spot node pools for batch and stateless
- Right-size worker node instance families (ARM where compatible)
- Monitor idle allocation with Kubecost/OpenCost

## Case Study Pattern: Before/After

Any architecture move should be documented with:

- Baseline cost and usage
- Proposed change
- Expected savings with assumptions
- Risk and fallback
- Actual realized savings post-migration
- Lessons learned

This discipline is what distinguishes mature workload optimization from opportunistic cost-chasing.

## Common Exam Traps

- Assuming rightsizing recommendations are always safe (seasonal workloads)
- Overlooking storage lifecycle as a quick win
- Confusing Compute SP (rate) with rightsizing (usage)
- Recommending serverless for steady-state high-utilization workloads
- Ignoring data transfer in cross-region / cross-AZ scenarios
- Treating spot as free capacity without resilience design
