# Reliability and Business Continuity

**[AWS Well-Architected - Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html)** - Reliability best practices

## EC2 Auto Scaling

**[EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)** - Automatic capacity management

### Auto Scaling Group Components

**Launch Templates** (preferred over launch configurations):
- AMI ID, instance type, key pair, security groups
- Supports multiple instance types and purchase options
- Versioning for template updates
- Can include user data and IAM instance profiles

**Auto Scaling Group Settings**:
- Minimum, maximum, and desired capacity
- Availability Zones and subnets
- Health check type (EC2 or ELB) and grace period
- Termination policies (default, OldestInstance, NewestInstance, etc.)
- Instance protection and scale-in protection

### Scaling Policies

**Target Tracking Scaling**:
- Maintain a target value for a specific metric
- Examples: Average CPU at 50%, ALB request count per target at 1000
- Automatically creates CloudWatch alarms
- Best for most common scaling scenarios

**Step Scaling**:
- Scale based on CloudWatch alarm breach size
- Different scaling amounts for different thresholds
- More granular control than target tracking
- Example: Add 1 instance at 60% CPU, add 3 instances at 80% CPU

**Simple Scaling**:
- Single scaling action per alarm breach
- Cooldown period before next action (default 300 seconds)
- Legacy - step scaling preferred for new configurations

**Scheduled Scaling**:
- Scale based on predictable time patterns
- Cron expressions or one-time schedules
- Example: Scale up at 8 AM, scale down at 6 PM

**Predictive Scaling**:
- Machine learning to forecast traffic patterns
- Proactively scales before demand increases
- Combine with reactive policies for best results

**[Scaling Policies](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scale-based-on-demand.html)** - Dynamic and predictive scaling

### Health Checks

**EC2 Health Checks** - instance status (running, impaired, stopped)
**ELB Health Checks** - application-level health (HTTP status codes)
**Custom Health Checks** - set instance health via API

**Health Check Grace Period**:
- Time after launch before health checks begin
- Allows instance to finish bootstrapping
- Default: 300 seconds
- Set long enough for application to fully start

### Lifecycle Hooks

- Pause instances during launch or termination
- Perform custom actions (register with external systems, drain connections)
- Heartbeat timeout (default 3600 seconds)
- Complete action: CONTINUE or ABANDON

**[Lifecycle Hooks](https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html)** - Custom launch and termination actions

### Instance Refresh

- Rolling update of instances in Auto Scaling Group
- Specify minimum healthy percentage during refresh
- Triggers replacement of instances with new launch template version
- Useful for AMI updates and configuration changes

## Elastic Load Balancing

**[Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)** - Load balancer types and features

### Application Load Balancer (ALB)

**Layer 7** - HTTP/HTTPS traffic:
- Host-based and path-based routing
- Support for WebSockets and HTTP/2
- Redirect and fixed-response actions
- Target types: instances, IP addresses, Lambda functions
- Sticky sessions (cookies)
- Cross-zone load balancing (enabled by default)

**[ALB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)** - Application Load Balancer guide

### Network Load Balancer (NLB)

**Layer 4** - TCP/UDP/TLS traffic:
- Ultra-low latency (millions of requests per second)
- Static IP per AZ (or Elastic IP)
- Preserves source IP address
- Target types: instances, IP addresses, ALB
- Cross-zone load balancing (disabled by default)

**[NLB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html)** - Network Load Balancer guide

### Gateway Load Balancer (GLB)

**Layer 3** - Network appliances:
- Deploy, scale, and manage third-party virtual appliances
- Transparent network gateway and load balancer
- GENEVE protocol on port 6081
- Use case: firewalls, IDS/IPS, deep packet inspection

### Health Checks
- Protocol, port, and path for health checks
- Healthy/unhealthy thresholds and intervals
- Cross-zone load balancing distributes traffic evenly across AZs
- Connection draining (deregistration delay) - default 300 seconds

## Amazon Route 53

**[Amazon Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)** - DNS and traffic management

### Routing Policies

**Simple** - single resource, no health checks
**Weighted** - distribute traffic by percentage
**Latency-based** - route to lowest latency region
**Failover** - active-passive with health checks
**Geolocation** - route based on user location
**Geoproximity** - route based on resource location with bias
**Multivalue** - return multiple healthy records

**[Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)** - Traffic routing options

### Health Checks

- **Endpoint health checks** - monitor IP address or domain
- **Calculated health checks** - combine multiple health checks
- **CloudWatch alarm health checks** - based on CloudWatch alarm state
- Health check interval: 10 or 30 seconds
- Failure threshold: 1-10 consecutive failures

**[Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)** - Endpoint monitoring and failover

### DNS Failover Patterns
- Active-passive: primary with failover to secondary
- Active-active: multiple active endpoints with health checks
- Combine with weighted routing for gradual traffic shifting

## Backup Strategies

### AWS Backup

**[AWS Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html)** - Centralized backup management

**Backup Plans**:
- Define backup frequency, retention, and lifecycle
- Schedule using cron expressions or frequency
- Transition to cold storage after specified days
- Cross-region backup copies

**Backup Vaults**:
- Encrypted storage for backup data
- Vault lock for WORM (write once, read many) compliance
- Access policies for vault-level access control
- Cross-account backup support

**Supported Services**:
- EC2, EBS, RDS, Aurora, DynamoDB, EFS, FSx
- S3, Storage Gateway, DocumentDB, Neptune
- VMware Cloud on AWS

### Service-Specific Backups

**EBS Snapshots**:
- Incremental backups stored in S3
- Data Lifecycle Manager for automated snapshot management
- Fast Snapshot Restore for instant volume creation
- Copy snapshots across regions and accounts

**[EBS Snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html)** - Volume backup and restore

**RDS Backups**:
- Automated backups with point-in-time recovery (PITR)
- Retention period: 1-35 days
- Manual snapshots with no retention limit
- Cross-region automated backups

**[RDS Backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html)** - Database backup options

**DynamoDB Backups**:
- On-demand backup and restore
- Point-in-time recovery (PITR) - continuous, 35-day window
- Backups do not affect table performance
- Cross-region restore supported

**S3 Protection**:
- Versioning for object-level protection
- Cross-Region Replication (CRR) for DR
- Same-Region Replication (SRR) for compliance
- Object Lock for WORM compliance

## Disaster Recovery

**[DR on AWS](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)** - DR strategies whitepaper

### DR Strategies (by cost and recovery speed)

**Backup and Restore** (lowest cost, highest RTO/RPO):
- RPO: Hours | RTO: Hours to days
- Regular backups to S3 with cross-region replication
- Restore from backups when disaster occurs
- Suitable for non-critical workloads

**Pilot Light** (low cost, moderate RTO/RPO):
- RPO: Minutes | RTO: Minutes to hours
- Core infrastructure running at minimum in DR region
- Database replication active (RDS cross-region read replica)
- Scale up compute and other resources during failover

**Warm Standby** (moderate cost, low RTO/RPO):
- RPO: Seconds to minutes | RTO: Minutes
- Scaled-down version of production running in DR region
- All services running but at reduced capacity
- Scale up during failover event

**Multi-Site Active-Active** (highest cost, lowest RTO/RPO):
- RPO: Near zero | RTO: Near zero
- Full production in multiple regions
- Route 53 for traffic distribution
- DynamoDB Global Tables or Aurora Global Database

### AWS Elastic Disaster Recovery

**[AWS DRS](https://docs.aws.amazon.com/drs/latest/userguide/what-is-drs.html)** - Application-level DR

- Continuous block-level replication to AWS
- Automated machine conversion and orchestration
- Non-disruptive recovery drills
- Point-in-time recovery for ransomware protection

## High Availability Patterns

### Multi-AZ Architecture
- Distribute resources across at least 2 AZs (3 recommended)
- Auto Scaling Group with instances in multiple AZs
- Load balancer with cross-zone load balancing
- RDS Multi-AZ for automatic database failover
- ElastiCache Multi-AZ with automatic failover

### Stateless Design
- Store session state in ElastiCache or DynamoDB
- Use S3 for shared file storage
- Design instances to be replaceable
- Bootstrap instances using user data or configuration management

### Fault Isolation
- Use multiple AZs within a region
- Consider multi-region for critical applications
- Implement circuit breakers for service dependencies
- Use SQS for decoupling components

## Key Takeaways

1. **Auto Scaling** - know all scaling policy types and when to use each
2. **Health checks** - understand EC2 vs ELB health checks and grace periods
3. **Load balancers** - ALB for HTTP/HTTPS, NLB for TCP/UDP, GLB for appliances
4. **Route 53 failover** - health checks trigger DNS failover automatically
5. **AWS Backup** - centralized backup with cross-region and cross-account support
6. **DR strategies** - understand cost vs RTO/RPO trade-offs for each strategy
7. **Multi-AZ** - minimum requirement for production high availability
8. **Stateless design** - enables scaling and fault tolerance
