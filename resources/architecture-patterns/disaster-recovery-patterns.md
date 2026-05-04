---
last-updated: 2026-05-03
---

# Disaster Recovery Patterns

A comprehensive guide to implementing disaster recovery strategies across AWS, Azure, and Google Cloud Platform to ensure business continuity.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Security Considerations](#security-considerations)
8. [Performance Optimization](#performance-optimization)
9. [Cost Estimates](#cost-estimates)
10. [Best Practices](#best-practices)
11. [DR Strategy Comparison](#dr-strategy-comparison)
12. [Monitoring and Observability](#monitoring-and-observability)
13. [CI/CD for Disaster Recovery](#cicd-for-disaster-recovery)
14. [Common Pitfalls](#common-pitfalls)

---

## Architecture Overview

### What is Disaster Recovery?

Disaster recovery (DR) is the process of preparing for and recovering from events that affect IT systems:
- **Natural Disasters**: Earthquakes, floods, fires
- **Hardware Failures**: Server crashes, storage failures
- **Software Failures**: Bugs, corrupted data
- **Human Errors**: Accidental deletion, misconfigurations
- **Cyber Attacks**: Ransomware, DDoS attacks
- **Regional Outages**: Cloud provider regional failures

### Key Metrics

#### RTO (Recovery Time Objective)
- **Definition**: Maximum acceptable time to restore service after a disaster
- **Example**: RTO of 4 hours means service must be restored within 4 hours
- **Impact**: Determines DR strategy complexity and cost

#### RPO (Recovery Point Objective)
- **Definition**: Maximum acceptable amount of data loss measured in time
- **Example**: RPO of 1 hour means you can lose up to 1 hour of data
- **Impact**: Determines backup frequency and replication strategy

```
Timeline During Disaster:

Last Backup    Disaster    Recovery Complete
     │             │              │
     ▼             ▼              ▼
─────●─────────────●──────────────●──────────▶ Time
     │◄────────────┤◄─────────────┤
           RPO           RTO
      (Data Loss)   (Downtime)
```

### DR Strategies Overview

| Strategy | RTO | RPO | Cost | Complexity |
|----------|-----|-----|------|------------|
| Backup & Restore | Hours-Days | Hours | $ | Low |
| Pilot Light | 10-30 min | Minutes | $$ | Medium |
| Warm Standby | Minutes | Seconds | $$$ | High |
| Multi-Site Active-Active | Near Zero | Near Zero | $$$$ | Very High |

### Core Components

1. **Backup Storage**: Durable storage for backups (S3, Blob, GCS)
2. **Data Replication**: Sync or async replication to DR region
3. **DNS/Traffic Management**: Route traffic to healthy region
4. [**Infrastructure as Code**](../../learn/glossary.md#term-iac-infrastructure-as-code): Quickly provision DR environment
5. **Monitoring/Alerting**: Detect failures and trigger failover
6. **Runbooks**: Documented procedures for failover/failback

### When to Use Each Strategy

**Backup & Restore**:
- Non-critical systems
- Cost-sensitive applications
- Development/test environments
- Can tolerate hours of downtime

**Pilot Light**:
- Core business applications
- Moderate criticality
- Balance of cost and recovery time
- Database-centric applications

**Warm Standby**:
- Important business applications
- Need faster recovery
- Can justify higher cost
- Mission-critical databases

**Multi-Site Active-Active**:
- Zero-downtime requirements
- Global user base
- Highest criticality (payments, healthcare)
- Regulatory requirements

---

## Architecture Diagram Description

### The four DR patterns by RTO / RPO

```mermaid
flowchart LR
  subgraph BR[Backup + Restore<br/>RTO: hours, RPO: hours<br/>Cheapest]
    BR1[Primary] --> BR2[(Backups)]
    BR2 -. restore on disaster .-> BR3[Standby spun up<br/>from backup]
  end
  subgraph PL[Pilot Light<br/>RTO: 10s of min, RPO: minutes]
    PL1[Primary] --> PL2[(Replicated DB)]
    PL3[Stopped app servers<br/>start on disaster]
    PL2 -. always replicating .-> PL3
  end
  subgraph WS[Warm Standby<br/>RTO: minutes, RPO: seconds]
    WS1[Primary] --> WS2[Scaled-down<br/>secondary always running]
    WS1 -. continuous sync .-> WS2
  end
  subgraph AA[Multi-site Active-Active<br/>RTO: ~0, RPO: ~0<br/>Most expensive]
    AA1[Region A active] <-. bidirectional<br/>sync .-> AA2[Region B active]
    LB[Global LB] --> AA1
    LB --> AA2
  end
```

```
Normal Operation:                    Disaster Recovery:
────────────────                    ────────────────

Primary Region                      DR Region
┌─────────────────┐                ┌─────────────────┐
│  [Application]  │                │                 │
│       │         │                │  [Restore from  │
│  [Database]     │                │   Backup]       │
│       │         │                │       │         │
│  [Backup] ──────┼───Replicate───▶│  [S3/Blob/GCS]  │
└─────────────────┘                │       │         │
                                   │  [Provision     │
                                   │   Infrastructure│
                                   │   from IaC]     │
                                   └─────────────────┘

RTO: Hours    RPO: Hours (last backup)
```

### Pilot Light

```
Normal Operation:                    Disaster Recovery:
────────────────                    ────────────────

Primary Region                      DR Region
┌─────────────────┐                ┌─────────────────┐
│  [Application]  │                │  [Application]  │
│  (Running)      │                │  (Stopped)      │
│       │         │                │       │         │
│  [Database]     │═══Replicate═══▶│  [Database]     │
│  (Active)       │                │  (Standby)      │
│       │         │                │       │         │
│  [Load Balancer]│                │  [Start on      │
│  (Active)       │                │   Failover]     │
└─────────────────┘                └─────────────────┘

On Failover:
1. Promote standby database
2. Start application servers
3. Update DNS to DR region

RTO: 10-30 min    RPO: Minutes (replication lag)
```

### Warm Standby

```
Normal Operation:                    Disaster Recovery:
────────────────                    ────────────────

Primary Region                      DR Region
┌─────────────────┐                ┌─────────────────┐
│  [Application]  │                │  [Application]  │
│  (Full Scale)   │                │  (Reduced Scale)│
│   ████████████  │                │   ██            │
│       │         │                │       │         │
│  [Database]     │═══Replicate═══▶│  [Database]     │
│  (Primary)      │                │  (Sync Replica) │
│       │         │                │       │         │
│  [Load Balancer]│                │  [Load Balancer]│
│  (Active)       │                │  (Standby)      │
└─────────────────┘                └─────────────────┘
         │                                  │
         └──────────[Route 53/Traffic Manager]──────┘

On Failover:
1. Scale up DR application
2. Promote database replica
3. Switch DNS routing

RTO: Minutes    RPO: Seconds (sync replication)
```

### Multi-Site Active-Active

```
Normal Operation (Both Regions Active):
─────────────────────────────────────

                    [Global DNS]
                    (Route 53/Traffic Manager)
                         │
         ┌───────────────┴───────────────┐
         │                               │
         ▼                               ▼
Primary Region                      Secondary Region
┌─────────────────┐                ┌─────────────────┐
│  [Application]  │                │  [Application]  │
│  (Full Scale)   │                │  (Full Scale)   │
│   ████████████  │◄═══Traffic════▶│   ████████████  │
│       │         │                │       │         │
│  [Database]     │◄═══Bi-dir═════▶│  [Database]     │
│  (Multi-Master) │  Replication   │  (Multi-Master) │
│       │         │                │       │         │
│  [Load Balancer]│                │  [Load Balancer]│
│  (Active)       │                │  (Active)       │
└─────────────────┘                └─────────────────┘

Both regions serve traffic simultaneously.
If one fails, the other absorbs all traffic.

RTO: ~0    RPO: ~0 (synchronous replication)
```

### Data Replication Flow

```
Synchronous Replication:
────────────────────────
Write ──▶ Primary DB ══▶ Replica DB ══▶ Ack ──▶ Commit
              │                               │
              └───────────────────────────────┘
                    (Wait for replica)

RPO: 0 (no data loss)
Impact: Higher latency

Asynchronous Replication:
─────────────────────────
Write ──▶ Primary DB ──▶ Commit
              │
              └──────▶ Replica DB (eventually)

RPO: Seconds to minutes (replication lag)
Impact: Lower latency, possible data loss
```

---

## Component Breakdown

### Data Replication Technologies

#### Database Replication
- [**AWS**](../../learn/glossary.md#term-aws): RDS Multi-AZ, Aurora Global Database, DynamoDB Global Tables
- [**Azure**](../../learn/glossary.md#term-azure): SQL Always On, Cosmos DB Multi-region
- [**GCP**](../../learn/glossary.md#term-gcp): Cloud SQL HA, Spanner, Firestore Multi-region

#### Storage Replication
- **AWS**: S3 Cross-Region Replication (CRR), EBS Snapshots
- **Azure**: Blob GRS/GZRS, Azure Site Recovery
- **GCP**: Cloud Storage dual-region, Cross-region replication

### Traffic Management

#### DNS-Based Failover
- **AWS Route 53**: Health checks, failover routing
- **Azure Traffic Manager**: Priority, weighted, geographic routing
- **GCP Cloud DNS**: Geolocation routing policies

#### Global Load Balancing
- **AWS Global Accelerator**: Anycast IP, automatic failover
- **Azure Front Door**: Global HTTP load balancing
- **GCP Cloud Load Balancing**: Global external load balancer

### Backup Services

| Provider | Service | Features |
|----------|---------|----------|
| AWS | AWS Backup | Centralized backup, cross-region copy |
| AWS | RDS Automated Backups | Point-in-time recovery |
| Azure | Azure Backup | VM, SQL, files backup |
| Azure | Azure Site Recovery | Full VM replication |
| GCP | Cloud Storage | Object versioning, lifecycle |
| GCP | Persistent Disk Snapshots | Incremental snapshots |

### Infrastructure as Code

#### Purpose in DR
- Consistent environment provisioning
- Fast recovery (no manual setup)
- Version-controlled infrastructure
- Drift detection

#### Tools
- [**Terraform**](../../learn/glossary.md#term-terraform): Multi-cloud, declarative
- **AWS CloudFormation**: AWS-native
- **Azure Resource Manager**: Azure-native
- **Google Cloud Deployment Manager**: GCP-native

---

## AWS Implementation

### Pilot Light with Terraform

```hcl
# dr-pilot-light.tf

# Primary Region Resources
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# DR Region Resources
provider "aws" {
  alias  = "dr"
  region = "us-west-2"
}

# Primary RDS with Multi-AZ
resource "aws_db_instance" "primary" {
  provider               = aws.primary
  identifier             = "${var.project_name}-primary-db"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.r6g.large"
  allocated_storage      = 100
  storage_encrypted      = true
  multi_az               = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  # Enable automated backups to DR region
  replicate_source_db = null

  tags = {
    Name        = "${var.project_name}-primary-db"
    Environment = "production"
    DR          = "primary"
  }
}

# Cross-Region Read Replica (Pilot Light)
resource "aws_db_instance" "dr_replica" {
  provider             = aws.dr
  identifier           = "${var.project_name}-dr-replica"
  replicate_source_db  = aws_db_instance.primary.arn
  instance_class       = "db.r6g.medium"  # Smaller for cost savings
  storage_encrypted    = true
  skip_final_snapshot  = true

  # Can be promoted to standalone in DR scenario
  tags = {
    Name        = "${var.project_name}-dr-replica"
    Environment = "dr"
    DR          = "replica"
  }
}

# S3 Cross-Region Replication
resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "${var.project_name}-primary-assets"
}

resource "aws_s3_bucket" "dr" {
  provider = aws.dr
  bucket   = "${var.project_name}-dr-assets"
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id
  role     = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.dr.arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.dr.arn
      }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
  }
}

# Route 53 Health Check and Failover
resource "aws_route53_health_check" "primary" {
  fqdn              = "primary.${var.domain}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "primary-health-check"
  }
}

resource "aws_route53_record" "failover_primary" {
  zone_id = var.zone_id
  name    = "app.${var.domain}"
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  health_check_id = aws_route53_health_check.primary.id

  alias {
    name                   = aws_lb.primary.dns_name
    zone_id                = aws_lb.primary.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "failover_dr" {
  zone_id = var.zone_id
  name    = "app.${var.domain}"
  type    = "A"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "dr"

  alias {
    name                   = aws_lb.dr.dns_name
    zone_id                = aws_lb.dr.zone_id
    evaluate_target_health = true
  }
}

# DR Application (Stopped by default)
resource "aws_autoscaling_group" "dr" {
  provider            = aws.dr
  name                = "${var.project_name}-dr-asg"
  desired_capacity    = 0  # Start with zero instances
  min_size            = 0
  max_size            = 10
  vpc_zone_identifier = var.dr_subnet_ids

  launch_template {
    id      = aws_launch_template.dr.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-dr"
    propagate_at_launch = true
  }
}

# Lambda for automated failover
resource "aws_lambda_function" "failover" {
  provider      = aws.primary
  function_name = "${var.project_name}-failover"
  role          = aws_iam_role.failover_lambda.arn
  handler       = "failover.handler"
  runtime       = "python3.11"

  filename         = "failover.zip"
  source_code_hash = filebase64sha256("failover.zip")

  environment {
    variables = {
      DR_ASG_NAME     = aws_autoscaling_group.dr.name
      DR_DB_IDENTIFIER = aws_db_instance.dr_replica.identifier
      DR_REGION       = "us-west-2"
    }
  }
}

# CloudWatch Alarm to trigger failover
resource "aws_cloudwatch_metric_alarm" "primary_unhealthy" {
  provider            = aws.primary
  alarm_name          = "primary-region-unhealthy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    LoadBalancer = aws_lb.primary.arn_suffix
    TargetGroup  = aws_lb_target_group.primary.arn_suffix
  }

  alarm_actions = [aws_sns_topic.dr_alerts.arn]
}
```

### Failover Lambda Function

```python
# failover.py
import boto3
import os
import time

def handler(event, context):
    """Automated failover to DR region."""

    dr_region = os.environ['DR_REGION']
    dr_asg_name = os.environ['DR_ASG_NAME']
    dr_db_identifier = os.environ['DR_DB_IDENTIFIER']

    # Initialize clients
    rds = boto3.client('rds', region_name=dr_region)
    autoscaling = boto3.client('autoscaling', region_name=dr_region)

    print(f"Starting failover to DR region: {dr_region}")

    # Step 1: Promote RDS read replica
    print(f"Promoting database replica: {dr_db_identifier}")
    try:
        rds.promote_read_replica(
            DBInstanceIdentifier=dr_db_identifier,
            BackupRetentionPeriod=7
        )

        # Wait for promotion
        waiter = rds.get_waiter('db_instance_available')
        waiter.wait(DBInstanceIdentifier=dr_db_identifier)
        print("Database promotion complete")
    except Exception as e:
        print(f"Database promotion error: {e}")
        raise

    # Step 2: Scale up DR application
    print(f"Scaling up ASG: {dr_asg_name}")
    try:
        autoscaling.update_auto_scaling_group(
            AutoScalingGroupName=dr_asg_name,
            MinSize=2,
            DesiredCapacity=4,
            MaxSize=10
        )

        # Wait for instances
        time.sleep(120)  # Allow time for instances to start
        print("ASG scaled up")
    except Exception as e:
        print(f"ASG scaling error: {e}")
        raise

    # Step 3: Verify DR health
    # Route 53 will automatically detect healthy DR endpoint

    return {
        'statusCode': 200,
        'body': 'Failover completed successfully'
    }
```

### Aurora Global Database (Warm Standby)

```hcl
# aurora-global.tf

resource "aws_rds_global_cluster" "main" {
  global_cluster_identifier = "${var.project_name}-global"
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
  database_name             = "app"
  storage_encrypted         = true
}

# Primary cluster
resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  cluster_identifier        = "${var.project_name}-primary"
  engine                    = aws_rds_global_cluster.main.engine
  engine_version            = aws_rds_global_cluster.main.engine_version
  global_cluster_identifier = aws_rds_global_cluster.main.id
  master_username           = "admin"
  master_password           = var.db_password
  database_name             = "app"

  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"

  db_subnet_group_name   = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.db_primary.id]
}

resource "aws_rds_cluster_instance" "primary" {
  count              = 2
  provider           = aws.primary
  identifier         = "${var.project_name}-primary-${count.index}"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.primary.engine
}

# Secondary cluster (DR region)
resource "aws_rds_cluster" "secondary" {
  provider                  = aws.dr
  cluster_identifier        = "${var.project_name}-secondary"
  engine                    = aws_rds_global_cluster.main.engine
  engine_version            = aws_rds_global_cluster.main.engine_version
  global_cluster_identifier = aws_rds_global_cluster.main.id

  # Secondary cluster - no master credentials needed
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.dr.name
  vpc_security_group_ids = [aws_security_group.db_dr.id]

  depends_on = [aws_rds_cluster_instance.primary]
}

resource "aws_rds_cluster_instance" "secondary" {
  count              = 1  # Fewer instances for cost savings
  provider           = aws.dr
  identifier         = "${var.project_name}-secondary-${count.index}"
  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = "db.r6g.medium"
  engine             = aws_rds_cluster.secondary.engine
}
```

### DynamoDB Global Tables (Active-Active)

```hcl
# dynamodb-global.tf

resource "aws_dynamodb_table" "main" {
  provider         = aws.primary
  name             = "${var.project_name}-data"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "pk"
  range_key        = "sk"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  # Global table replication
  replica {
    region_name = "us-west-2"
  }

  replica {
    region_name = "eu-west-1"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-data"
  }
}
```

### AWS Backup Configuration

```hcl
# aws-backup.tf

resource "aws_backup_vault" "primary" {
  provider = aws.primary
  name     = "${var.project_name}-backup-vault"
}

resource "aws_backup_vault" "dr" {
  provider = aws.dr
  name     = "${var.project_name}-backup-vault-dr"
}

resource "aws_backup_plan" "main" {
  provider = aws.primary
  name     = "${var.project_name}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = "cron(0 3 * * ? *)"

    lifecycle {
      delete_after = 30
    }

    # Cross-region copy
    copy_action {
      destination_vault_arn = aws_backup_vault.dr.arn
      lifecycle {
        delete_after = 30
      }
    }
  }

  rule {
    rule_name         = "weekly-backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = "cron(0 4 ? * SUN *)"

    lifecycle {
      delete_after = 90
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.dr.arn
      lifecycle {
        delete_after = 90
      }
    }
  }
}

resource "aws_backup_selection" "main" {
  provider     = aws.primary
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.project_name}-backup-selection"
  plan_id      = aws_backup_plan.main.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
```

---

## Azure Implementation

### Warm Standby with Azure Site Recovery

```bicep
// dr-warm-standby.bicep

// Recovery Services Vault
resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-04-01' = {
  name: 'dr-recovery-vault'
  location: drLocation
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

// Replication Policy
resource replicationPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2023-04-01' = {
  parent: recoveryVault
  name: 'vm-replication-policy'
  properties: {
    providerSpecificInput: {
      instanceType: 'A2A'
      multiVmSyncStatus: 'Enable'
      appConsistentFrequencyInMinutes: 60
      crashConsistentFrequencyInMinutes: 5
      recoveryPointHistory: 1440  // 24 hours
    }
  }
}

// Primary VM to replicate
resource primaryVM 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: 'app-vm-primary'
  location: primaryLocation
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '22.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: primaryNic.id
        }
      ]
    }
  }
}

// Azure SQL with Geo-Replication
resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: 'sql-primary'
  location: primaryLocation
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    minimalTlsVersion: '1.2'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: 'appdb'
  location: primaryLocation
  sku: {
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
    capacity: 2
  }
  properties: {
    zoneRedundant: true
  }
}

// DR SQL Server
resource sqlServerDR 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: 'sql-dr'
  location: drLocation
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    minimalTlsVersion: '1.2'
  }
}

// Geo-Replication Link
resource geoReplication 'Microsoft.Sql/servers/databases/geoBackupPolicies@2023-05-01-preview' = {
  parent: sqlDatabase
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
}

// Failover Group
resource failoverGroup 'Microsoft.Sql/servers/failoverGroups@2023-05-01-preview' = {
  parent: sqlServer
  name: 'sql-failover-group'
  properties: {
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
    readOnlyEndpoint: {
      failoverPolicy: 'Enabled'
    }
    partnerServers: [
      {
        id: sqlServerDR.id
      }
    ]
    databases: [
      sqlDatabase.id
    ]
  }
}

// Traffic Manager for DNS failover
resource trafficManager 'Microsoft.Network/trafficmanagerprofiles@2022-04-01' = {
  name: 'app-traffic-manager'
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: 'app'
      ttl: 30
    }
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/health'
      intervalInSeconds: 30
      toleratedNumberOfFailures: 3
      timeoutInSeconds: 10
    }
    endpoints: [
      {
        name: 'primary-endpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          targetResourceId: primaryAppService.id
          endpointStatus: 'Enabled'
          priority: 1
        }
      }
      {
        name: 'dr-endpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          targetResourceId: drAppService.id
          endpointStatus: 'Enabled'
          priority: 2
        }
      }
    ]
  }
}

// Azure Front Door for global load balancing
resource frontDoor 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: 'app-front-door'
  location: 'global'
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2023-05-01' = {
  parent: frontDoor
  name: 'app-endpoint'
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2023-05-01' = {
  parent: frontDoor
  name: 'app-origin-group'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/health'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 30
    }
  }
}
```

### Azure Automation Runbook for Failover

```powershell
# failover-runbook.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$FailoverGroupName,

    [Parameter(Mandatory=$true)]
    [string]$ServerName
)

# Connect to Azure
Connect-AzAccount -Identity

Write-Output "Starting failover for failover group: $FailoverGroupName"

try {
    # Get current failover group status
    $failoverGroup = Get-AzSqlDatabaseFailoverGroup `
        -ResourceGroupName $ResourceGroupName `
        -ServerName $ServerName `
        -FailoverGroupName $FailoverGroupName

    Write-Output "Current primary: $($failoverGroup.ReplicationRole)"

    # Initiate failover
    Switch-AzSqlDatabaseFailoverGroup `
        -ResourceGroupName $ResourceGroupName `
        -ServerName $ServerName `
        -FailoverGroupName $FailoverGroupName

    Write-Output "Failover initiated successfully"

    # Wait for failover to complete
    $maxRetries = 30
    $retryCount = 0

    do {
        Start-Sleep -Seconds 10
        $failoverGroup = Get-AzSqlDatabaseFailoverGroup `
            -ResourceGroupName $ResourceGroupName `
            -ServerName $ServerName `
            -FailoverGroupName $FailoverGroupName

        $retryCount++
        Write-Output "Waiting for failover... Attempt $retryCount"
    } while ($failoverGroup.ReplicationRole -ne 'Primary' -and $retryCount -lt $maxRetries)

    if ($failoverGroup.ReplicationRole -eq 'Primary') {
        Write-Output "Failover completed successfully"
    } else {
        throw "Failover did not complete within expected time"
    }
}
catch {
    Write-Error "Failover failed: $_"
    throw
}
```

---

## GCP Implementation

### Multi-Region with Cloud Spanner

```yaml
# spanner-multiregion.yaml (Terraform)

resource "google_spanner_instance" "main" {
  name         = "${var.project_name}-spanner"
  config       = "nam-eur-asia1"  # Multi-region config
  display_name = "${var.project_name} Spanner"

  num_nodes = 3

  labels = {
    environment = "production"
  }
}

resource "google_spanner_database" "main" {
  instance = google_spanner_instance.main.name
  name     = "appdb"

  deletion_protection = true

  version_retention_period = "7d"
  ddl = [
    "CREATE TABLE Users (UserId STRING(36) NOT NULL, Email STRING(255), CreatedAt TIMESTAMP) PRIMARY KEY (UserId)",
    "CREATE TABLE Orders (OrderId STRING(36) NOT NULL, UserId STRING(36), Total FLOAT64, CreatedAt TIMESTAMP) PRIMARY KEY (OrderId)"
  ]
}
```

### Cloud SQL with Cross-Region Replicas

```hcl
# cloudsql-dr.tf

# Primary instance
resource "google_sql_database_instance" "primary" {
  name             = "${var.project_name}-primary"
  database_version = "POSTGRES_15"
  region           = var.primary_region

  settings {
    tier              = "db-custom-4-16384"
    availability_type = "REGIONAL"

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
    }
  }

  deletion_protection = true
}

# Cross-region read replica
resource "google_sql_database_instance" "replica" {
  name                 = "${var.project_name}-replica"
  master_instance_name = google_sql_database_instance.primary.name
  region               = var.dr_region
  database_version     = "POSTGRES_15"

  replica_configuration {
    failover_target = true
  }

  settings {
    tier              = "db-custom-2-8192"  # Smaller for cost
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }

  deletion_protection = true
}
```

### Global HTTP Load Balancer with Health Checks

```hcl
# global-lb.tf

# Health check
resource "google_compute_health_check" "app" {
  name               = "${var.project_name}-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  https_health_check {
    port         = 443
    request_path = "/health"
  }
}

# Primary backend
resource "google_compute_backend_service" "primary" {
  name                  = "${var.project_name}-backend-primary"
  protocol              = "HTTPS"
  port_name             = "https"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.app.id]

  backend {
    group           = google_compute_region_instance_group_manager.primary.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  circuit_breakers {
    max_connections = 1000
  }

  outlier_detection {
    consecutive_errors = 5
    interval {
      seconds = 10
    }
    base_ejection_time {
      seconds = 30
    }
  }
}

# DR backend
resource "google_compute_backend_service" "dr" {
  name                  = "${var.project_name}-backend-dr"
  protocol              = "HTTPS"
  port_name             = "https"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.app.id]

  backend {
    group           = google_compute_region_instance_group_manager.dr.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.5  # Lower capacity for warm standby
  }
}

# URL map with failover
resource "google_compute_url_map" "app" {
  name            = "${var.project_name}-url-map"
  default_service = google_compute_backend_service.primary.id

  host_rule {
    hosts        = ["app.example.com"]
    path_matcher = "app-paths"
  }

  path_matcher {
    name            = "app-paths"
    default_service = google_compute_backend_service.primary.id

    route_rules {
      priority = 1
      service  = google_compute_backend_service.primary.id

      route_action {
        retry_policy {
          num_retries = 3
          retry_conditions = [
            "5xx",
            "reset",
            "connect-failure"
          ]
        }

        # Failover to DR if primary fails
        fault_injection_policy {
          abort {
            http_status = 503
            percentage  = 0
          }
        }
      }
    }
  }
}

# Global forwarding rule
resource "google_compute_global_forwarding_rule" "app" {
  name                  = "${var.project_name}-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.app.id
  ip_address            = google_compute_global_address.app.id
}
```

### Cloud Storage Cross-Region Replication

```hcl
# storage-replication.tf

# Dual-region bucket for automatic replication
resource "google_storage_bucket" "app_assets" {
  name     = "${var.project_name}-assets"
  location = "NAM4"  # Dual-region: us-central1 and us-east1

  storage_class = "STANDARD"
  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }

  uniform_bucket_level_access = true
}

# Turbo replication for critical data
resource "google_storage_bucket" "critical_data" {
  name     = "${var.project_name}-critical"
  location = "US"  # Multi-region

  storage_class = "STANDARD"

  custom_placement_config {
    data_locations = ["US-CENTRAL1", "US-EAST1"]
  }

  versioning {
    enabled = true
  }

  # Turbo replication enabled
  rpo = "ASYNC_TURBO"
}
```

---

## Security Considerations

### Encryption in Transit and at Rest

```hcl
# AWS: KMS key replication for DR
resource "aws_kms_replica_key" "dr" {
  provider        = aws.dr
  primary_key_arn = aws_kms_key.primary.arn
  description     = "DR replica of primary KMS key"
}

# Azure: Customer-managed keys
resource "azurerm_key_vault_key" "dr_encryption" {
  name         = "dr-encryption-key"
  key_vault_id = azurerm_key_vault.dr.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "wrapKey"]
}
```

### Access Control During Failover

```yaml
# IAM roles for DR operations
Resources:
  DROperatorRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: dr-operator
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: dr-operations
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - rds:PromoteReadReplica
                  - rds:ModifyDBInstance
                  - autoscaling:UpdateAutoScalingGroup
                  - route53:ChangeResourceRecordSets
                Resource: '*'
                Condition:
                  StringEquals:
                    aws:RequestTag/Environment: dr
```

### Security Checklist

| Area | Requirement |
|------|-------------|
| Encryption | Same encryption keys/policies in DR region |
| IAM | DR-specific roles with least privilege |
| Network | VPC peering or Transit Gateway for secure connectivity |
| Secrets | Replicate secrets to DR region |
| Certificates | SSL certificates valid for both regions |
| Audit | CloudTrail/activity logs in DR region |

---

## Performance Optimization

### Replication Lag Monitoring

```python
# check_replication_lag.py
import boto3
import time

def check_rds_lag(instance_identifier, region):
    """Check replication lag for RDS read replica."""
    cloudwatch = boto3.client('cloudwatch', region_name=region)

    response = cloudwatch.get_metric_statistics(
        Namespace='AWS/RDS',
        MetricName='ReplicaLag',
        Dimensions=[
            {'Name': 'DBInstanceIdentifier', 'Value': instance_identifier}
        ],
        StartTime=time.time() - 300,
        EndTime=time.time(),
        Period=60,
        Statistics=['Average']
    )

    if response['Datapoints']:
        lag = response['Datapoints'][-1]['Average']
        print(f"Replication lag: {lag} seconds")
        return lag
    return None

def check_aurora_lag(cluster_identifier, region):
    """Check replication lag for Aurora Global Database."""
    rds = boto3.client('rds', region_name=region)

    response = rds.describe_global_clusters(
        GlobalClusterIdentifier=cluster_identifier
    )

    for member in response['GlobalClusters'][0]['GlobalClusterMembers']:
        if not member['IsWriter']:
            lag = member.get('GlobalWriteForwardingStatus', 'Unknown')
            print(f"Region {member['DBClusterArn']}: Lag status = {lag}")
```

### Network Optimization

```hcl
# AWS: Use Global Accelerator for optimized routing
resource "aws_globalaccelerator_accelerator" "app" {
  name            = "${var.project_name}-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = aws_s3_bucket.flow_logs.bucket
    flow_logs_s3_prefix = "globalaccelerator/"
  }
}

resource "aws_globalaccelerator_listener" "app" {
  accelerator_arn = aws_globalaccelerator_accelerator.app.id
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "primary" {
  listener_arn                  = aws_globalaccelerator_listener.app.id
  endpoint_group_region         = "us-east-1"
  health_check_interval_seconds = 10
  health_check_path             = "/health"
  health_check_protocol         = "HTTPS"
  threshold_count               = 3
  traffic_dial_percentage       = 100

  endpoint_configuration {
    endpoint_id                    = aws_lb.primary.arn
    weight                         = 100
    client_ip_preservation_enabled = true
  }
}

resource "aws_globalaccelerator_endpoint_group" "dr" {
  listener_arn          = aws_globalaccelerator_listener.app.id
  endpoint_group_region = "us-west-2"
  traffic_dial_percentage = 0  # DR standby

  endpoint_configuration {
    endpoint_id = aws_lb.dr.arn
    weight      = 100
  }
}
```

---

## Cost Estimates

### Monthly Cost by Strategy

| Strategy | AWS | Azure | GCP | Notes |
|----------|-----|-------|-----|-------|
| **Backup & Restore** | $50-200 | $50-200 | $50-200 | Storage + restore compute |
| **Pilot Light** | $200-500 | $200-500 | $200-500 | Minimal DR compute + replicas |
| **Warm Standby** | $500-2000 | $500-2000 | $500-2000 | Reduced-scale DR environment |
| **Active-Active** | $2000+ | $2000+ | $2000+ | Full duplicate infrastructure |

### Cost Breakdown: Pilot Light (AWS Example)

| Component | Monthly Cost |
|-----------|-------------|
| RDS Read Replica (db.r6g.medium) | $120 |
| S3 Cross-Region Replication (100GB) | $5 |
| Route 53 Health Checks (2) | $2 |
| Stopped EC2 (EBS storage, 500GB) | $50 |
| NAT Gateway (DR VPC, minimal) | $35 |
| **Total** | **~$212** |

### Cost Optimization Tips

1. **Use smaller instance sizes** in DR region
2. **Stop non-essential resources** until needed
3. **Use reserved capacity** if DR instances run continuously
4. **Delete old backups** with lifecycle policies
5. **Use appropriate storage tiers** for backups
6. **Monitor replication** to avoid unnecessary data transfer

---

## Best Practices

### Runbook Example

```markdown
# Failover Runbook

## Pre-Failover Checklist
- [ ] Confirm primary region is unavailable
- [ ] Notify stakeholders (estimated downtime)
- [ ] Verify DR resources are healthy
- [ ] Check replication lag before failover

## Failover Steps

### 1. Database Failover
1. Promote RDS read replica OR trigger Aurora Global failover
2. Verify new primary is accepting writes
3. Update application connection strings if needed

### 2. Application Failover
1. Scale up DR Auto Scaling Group
2. Verify instances pass health checks
3. Test application functionality

### 3. DNS Failover
1. Verify Route 53 health checks detect failure
2. Confirm DNS has failed over to DR endpoint
3. Monitor traffic shift

### 4. Verification
1. Run smoke tests against DR endpoint
2. Verify database connectivity
3. Check application logs for errors
4. Monitor key metrics (latency, errors)

## Post-Failover
- [ ] Update status page
- [ ] Notify stakeholders of completion
- [ ] Document any issues
- [ ] Begin root cause analysis

## Failback Procedure
(Document steps to return to primary when ready)
```

### Testing Strategy

```yaml
# DR Test Schedule
Monthly:
  - Verify backups are current
  - Test backup restoration to isolated environment
  - Review DR documentation

Quarterly:
  - Tabletop exercise with team
  - Test database failover (read replica promotion)
  - Verify runbook accuracy

Annually:
  - Full DR test with actual failover
  - Measure actual RTO and RPO
  - Update documentation based on lessons learned
```

---

## DR Strategy Comparison

### Decision Matrix

| Factor | Backup & Restore | Pilot Light | Warm Standby | Active-Active |
|--------|-----------------|-------------|--------------|---------------|
| **RTO** | 24+ hours | 10-30 min | 1-10 min | < 1 min |
| **RPO** | 24 hours | 1-24 hours | < 1 hour | Near zero |
| **Cost** | $ | $$ | $$$ | $$$$ |
| **Complexity** | Low | Medium | High | Very High |
| **Data Consistency** | Eventual | Eventual | Near-sync | Synchronous |
| **Automated Failover** | No | Partial | Yes | Yes |

### Strategy Selection Guide

```
                    ┌─────────────────────────────────────────┐
                    │        What is your RTO requirement?     │
                    └────────────────────┬────────────────────┘
                                         │
                ┌────────────────────────┼────────────────────────┐
                │                        │                        │
           Hours/Days               10-30 minutes            < 1 minute
                │                        │                        │
                ▼                        ▼                        ▼
    ┌───────────────────┐    ┌───────────────────┐    ┌───────────────────┐
    │  Backup & Restore │    │    Pilot Light    │    │   What's budget?  │
    │                   │    │        or         │    │                   │
    │  • Non-critical   │    │   Warm Standby    │    │ High → Active-    │
    │  • Dev/test       │    │                   │    │        Active     │
    │  • Cost-sensitive │    │  • Production     │    │                   │
    └───────────────────┘    │  • Business-      │    │ Medium → Warm     │
                             │    critical       │    │          Standby  │
                             └───────────────────┘    └───────────────────┘
```

---

## Monitoring and Observability

### Key Metrics to Monitor

```yaml
# CloudWatch Dashboard - DR Metrics
Metrics:
  Replication:
    - RDS ReplicaLag (seconds)
    - Aurora GlobalDatabaseReplicationLag
    - DynamoDB ReplicationLatency
    - S3 ReplicationLatency

  Health:
    - Route53 HealthCheckStatus
    - ALB HealthyHostCount (both regions)
    - RDS InstanceStatus

  Failover:
    - Route53 DNSQueries (per region)
    - ALB RequestCount (per region)
    - Time since last successful backup
```

### Alerting Rules

```yaml
# CloudWatch Alarms
Resources:
  ReplicationLagAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: high-replication-lag
      MetricName: ReplicaLag
      Namespace: AWS/RDS
      Dimensions:
        - Name: DBInstanceIdentifier
          Value: !Ref DRReplica
      Period: 60
      EvaluationPeriods: 5
      Threshold: 300  # 5 minutes
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref AlertTopic

  BackupAgeAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: backup-too-old
      MetricName: TimeSinceLastRecoveryPointCreation
      Namespace: AWS/Backup
      Period: 86400  # 24 hours
      EvaluationPeriods: 1
      Threshold: 86400
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref AlertTopic
```

---

## CI/CD for Disaster Recovery

### Infrastructure Validation

```yaml
# GitHub Actions - DR Infrastructure Test
name: DR Infrastructure Validation

on:
  schedule:
    - cron: '0 6 * * 1'  # Weekly on Monday
  workflow_dispatch:

jobs:
  validate-dr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.DR_TEST_ROLE }}
          aws-region: us-west-2

      - name: Validate Terraform
        run: |
          cd terraform/dr
          terraform init
          terraform validate
          terraform plan -var-file=dr.tfvars

      - name: Test backup restoration
        run: |
          ./scripts/test-backup-restore.sh

      - name: Verify replication health
        run: |
          ./scripts/check-replication-status.sh

      - name: Generate DR report
        run: |
          ./scripts/generate-dr-report.sh > dr-report.md

      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: dr-report
          path: dr-report.md
```

### Automated DR Testing

```bash
#!/bin/bash
# test-dr-failover.sh

set -e

echo "Starting DR failover test..."

# 1. Take snapshot of current state
echo "Creating test snapshot..."
aws rds create-db-snapshot \
  --db-instance-identifier prod-db \
  --db-snapshot-identifier dr-test-$(date +%Y%m%d)

# 2. Simulate failover in test environment
echo "Promoting test replica..."
aws rds promote-read-replica \
  --db-instance-identifier dr-test-replica

# 3. Verify application connectivity
echo "Testing application connectivity..."
for i in {1..10}; do
  if curl -sf https://dr-test.example.com/health; then
    echo "Health check passed"
    break
  fi
  sleep 30
done

# 4. Run integration tests
echo "Running integration tests..."
npm run test:integration -- --env=dr-test

# 5. Measure recovery time
echo "DR test completed in $SECONDS seconds"

# 6. Cleanup test environment
echo "Cleaning up..."
aws rds delete-db-instance \
  --db-instance-identifier dr-test-replica \
  --skip-final-snapshot
```

---

## Common Pitfalls

### 1. Untested Failover

**Problem**: DR plan looks good on paper but fails in practice.

**Solution**: Regular testing.

```
Test Schedule:
- Monthly: Backup restoration test
- Quarterly: Partial failover test
- Annually: Full failover test

Document:
- Actual RTO achieved
- Issues encountered
- Runbook updates needed
```

### 2. Replication Lag Ignored

**Problem**: Data loss during failover due to unmonitored lag.

```python
# Monitor and alert on replication lag
def check_replication_health():
    lag = get_replication_lag()

    if lag > 60:  # More than 1 minute
        alert("WARNING: Replication lag is {lag} seconds")

    if lag > 300:  # More than 5 minutes
        alert("CRITICAL: Replication lag exceeds RPO!")
        # Consider manual intervention

    return lag
```

### 3. DNS TTL Too High

**Problem**: Long DNS TTL delays failover.

```hcl
# Set low TTL for failover records
resource "aws_route53_record" "app" {
  ttl = 60  # 1 minute, not 3600!

  # Or use alias record for instant failover
  alias {
    name    = aws_lb.app.dns_name
    zone_id = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
```

### 4. Missing Dependencies

**Problem**: Application fails because dependencies weren't replicated.

```
DR Checklist - Don't Forget:
- [ ] Secrets/credentials in DR region
- [ ] SSL certificates
- [ ] External API allowlists
- [ ] DNS records
- [ ] IAM roles/policies
- [ ] VPC peering/connectivity
- [ ] Third-party integrations
```

### 5. No Failback Plan

**Problem**: Stuck in DR region after failover.

```markdown
# Failback Runbook

## Prerequisites
- Primary region is healthy
- Root cause has been identified and resolved
- Stakeholders notified

## Failback Steps
1. Re-establish replication from DR to Primary
2. Wait for replication to catch up (0 lag)
3. Schedule maintenance window
4. Reverse failover (promote primary)
5. Update DNS/routing
6. Scale down DR region
7. Verify application health

## Post-Failback
- Resume normal backup schedule
- Update documentation
- Conduct post-mortem
```

### 6. Cost Surprise

**Problem**: DR costs spiral out of control.

```
Cost Controls:
- Use smaller instances in DR region
- Stop non-essential resources
- Set billing alerts for DR region
- Review monthly and right-size
- Consider reserved capacity if DR runs continuously
```

---

## Documentation Links

### AWS
- [AWS Disaster Recovery Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/)
- [Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)
- [AWS Backup](https://docs.aws.amazon.com/aws-backup/)
- [Route 53 Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)

### Azure
- [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/)
- [Azure SQL Geo-Replication](https://docs.microsoft.com/azure/azure-sql/database/active-geo-replication-overview)
- [Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/)
- [Azure Business Continuity](https://docs.microsoft.com/azure/architecture/framework/resiliency/backup-and-recovery)

### GCP
- [Disaster Recovery Planning Guide](https://cloud.google.com/architecture/dr-scenarios-planning-guide)
- [Cloud Spanner Multi-Region](https://cloud.google.com/spanner/docs/instances)
- [Cloud SQL High Availability](https://cloud.google.com/sql/docs/postgres/high-availability)
- [Global Load Balancing](https://cloud.google.com/load-balancing/docs/https)

### General
- [NIST Contingency Planning Guide](https://csrc.nist.gov/publications/detail/sp/800-34/rev-1/final)
- [ISO 22301 Business Continuity](https://www.iso.org/standard/75106.html)
