# Hands-On Project: Disaster Recovery Drill

Plan and execute a disaster recovery drill to validate backup and recovery procedures.

**Estimated Time:** 4-6 hours
**Difficulty:** Advanced
**Prerequisites:** Existing cloud infrastructure, understanding of backup concepts, production-like environment

---

## Architecture Overview

```
DR Patterns (increasing cost and complexity):

1. Backup and Restore
   Primary Region --> Backups (S3/GCS/Azure Storage) --> Restore in DR Region
   RTO: Hours | RPO: Hours

2. Pilot Light
   Primary Region (full stack) --> DR Region (minimal: DB replica, AMIs ready)
   RTO: 30-60 min | RPO: Minutes

3. Warm Standby
   Primary Region (full stack) --> DR Region (scaled-down running copy)
   RTO: 10-30 min | RPO: Seconds-Minutes

4. Active-Active (Multi-Region)
   Region A (full stack) <--> Region B (full stack) with GSLB
   RTO: ~0 | RPO: ~0
```

---

## Step 1: Document RTO and RPO

### Define Recovery Objectives

| System | RTO (Recovery Time) | RPO (Recovery Point) | DR Pattern | Priority |
|---|---|---|---|---|
| Customer-facing API | 15 minutes | 1 minute | Warm Standby | P1 |
| Database | 30 minutes | 5 minutes | Cross-region replica | P1 |
| Admin dashboard | 2 hours | 1 hour | Pilot Light | P2 |
| Batch processing | 4 hours | 24 hours | Backup/Restore | P3 |
| Static website | 10 minutes | N/A (immutable) | Active-Active CDN | P1 |

### Document Dependencies

```
Customer API
  +-- Database (PostgreSQL) - Cross-region replica
  +-- Cache (Redis) - Recreate from DB
  +-- Secrets Manager - Replicated
  +-- DNS (Route 53) - Global service
  +-- Certificate (ACM) - Must exist in DR region
  +-- Container Images (ECR) - Cross-region replication
```

---

## Step 2: Verify Backups

### Database Backups

**AWS RDS**
```bash
# List automated backups
aws rds describe-db-instance-automated-backups \
  --db-instance-identifier my-database

# List manual snapshots
aws rds describe-db-snapshots \
  --db-instance-identifier my-database

# Verify cross-region snapshot copies
aws rds describe-db-snapshots --region us-west-2 \
  --query 'DBSnapshots[?SourceRegion==`us-east-1`]'

# Check read replica status
aws rds describe-db-instances --db-instance-identifier my-database-replica-west \
  --query 'DBInstances[0].{Status:DBInstanceStatus,ReplicaLag:StatusInfos}'
```

**Azure SQL**
```bash
# Check backup status
az sql db show --resource-group myRG --server myserver --name mydb \
  --query '{backupRetention:earliestRestoreDate}'

# List long-term retention backups
az sql db ltr-backup list --resource-group myRG --server myserver --database mydb
```

**GCP Cloud SQL**
```bash
# List backups
gcloud sql backups list --instance my-instance

# Check replica status
gcloud sql instances describe my-replica --format="get(replicaConfiguration)"
```

### Storage Backups

```bash
# AWS - Verify S3 cross-region replication
aws s3api get-bucket-replication --bucket my-bucket

# AWS - Check S3 versioning
aws s3api get-bucket-versioning --bucket my-bucket

# Azure - Check storage account replication
az storage account show --name mystorageacct --query '{sku:sku.name,replication:primaryEndpoints}'

# GCP - Check dual-region or multi-region bucket
gsutil ls -L -b gs://my-bucket | grep "Location"
```

### Infrastructure as Code

```bash
# Verify Terraform state is backed up
aws s3 ls s3://my-terraform-state-bucket/ --recursive

# Verify container images are replicated
aws ecr describe-repositories --region us-west-2

# Verify secrets are replicated
aws secretsmanager list-secrets --region us-west-2
```

---

## Step 3: Simulate Failure

### Simulation Options (choose one)

**Option A: Database Failover Test**
```bash
# AWS - Force failover of Multi-AZ RDS
aws rds reboot-db-instance --db-instance-identifier my-database --force-failover

# Azure - Failover Azure SQL
az sql db failover --resource-group myRG --server myserver --name mydb

# GCP - Promote replica
gcloud sql instances promote-replica my-replica
```

**Option B: Region Failure Simulation**
```bash
# Simulate by routing all traffic away from primary region
# Update DNS to point to DR region
aws route53 change-resource-record-sets --hosted-zone-id ZONE_ID \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "api.example.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "DR_LB_ZONE_ID",
          "DNSName": "dr-alb.us-west-2.elb.amazonaws.com",
          "EvaluateTargetHealth": true
        }
      }
    }]
  }'
```

**Option C: Application Failure Simulation**
```bash
# Scale down the primary application to zero
kubectl scale deployment my-app --replicas=0 -n production

# Or terminate instances in the primary ASG
aws autoscaling set-desired-capacity --auto-scaling-group-name primary-asg --desired-capacity 0
```

---

## Step 4: Execute Failover

### Failover Runbook

**Phase 1: Detect and Declare (0-5 minutes)**
1. Monitoring alerts trigger (automated)
2. On-call engineer confirms the outage is not transient
3. Incident commander declares DR activation
4. Notify stakeholders via status page

**Phase 2: Activate DR Infrastructure (5-30 minutes)**

```bash
# 1. Promote database replica (if not auto-failover)
aws rds promote-read-replica --db-instance-identifier my-database-replica-west

# 2. Scale up DR compute resources
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name dr-asg --desired-capacity 3

# Or scale up Kubernetes deployment in DR cluster
kubectl scale deployment my-app --replicas=3 -n production \
  --context dr-cluster

# 3. Verify application health in DR region
curl -f https://dr-alb.us-west-2.elb.amazonaws.com/health

# 4. Update DNS to DR region
aws route53 change-resource-record-sets --hosted-zone-id ZONE_ID \
  --change-batch file://failover-dns.json
```

**Phase 3: Validate (30-60 minutes)**
```bash
# Run smoke tests against DR endpoint
./scripts/smoke-tests.sh --endpoint https://api.example.com

# Verify data integrity
./scripts/data-integrity-check.sh

# Check monitoring in DR region
# - Application metrics flowing
# - Error rates normal
# - Latency acceptable
```

---

## Step 5: Validate Recovery

### Validation Checklist

```bash
# API responds correctly
curl -s https://api.example.com/health | jq .

# Authentication works
curl -s -H "Authorization: Bearer $TOKEN" https://api.example.com/me | jq .

# Data is consistent
# Compare record counts or checksums
psql -h dr-database -c "SELECT COUNT(*) FROM orders WHERE created_at > NOW() - INTERVAL '1 hour'"

# All services are communicating
kubectl get pods -n production --context dr-cluster
kubectl logs -l app=my-app -n production --context dr-cluster --tail=50
```

### Performance Validation

```bash
# Check response times are within SLA
curl -w "DNS: %{time_namelookup}s, Connect: %{time_connect}s, Total: %{time_total}s\n" \
  -o /dev/null -s https://api.example.com/health

# Run a light load test
# Use a tool like k6, vegeta, or hey
hey -n 1000 -c 10 https://api.example.com/health
```

---

## Step 6: Document Lessons Learned

### Post-Drill Report Template

```markdown
# DR Drill Report - [Date]

## Summary
- Drill type: [Region failover / Database failover / Application failover]
- Start time: [HH:MM UTC]
- Recovery time achieved: [X minutes]
- RPO achieved: [X minutes of data]

## Objectives Met
- [ ] RTO target of [X minutes] - Actual: [Y minutes]
- [ ] RPO target of [X minutes] - Actual: [Y minutes]
- [ ] All critical services recovered
- [ ] Data integrity verified
- [ ] Monitoring operational in DR region

## Issues Found
1. [Issue description] - [Impact] - [Action item]
2. [Issue description] - [Impact] - [Action item]

## Runbook Updates Needed
- [Step X needs clarification]
- [Missing step: Y]

## Action Items
| Item | Owner | Due Date | Priority |
|---|---|---|---|
| Fix backup replication lag | DBA team | [date] | High |
| Update DNS TTL to 60s | Platform team | [date] | Medium |
| Add missing monitoring in DR | SRE team | [date] | High |

## Participants
- Incident Commander: [name]
- Database: [name]
- Application: [name]
- Networking: [name]
```

---

## DR Patterns in Detail

### Pattern 1: Backup and Restore

```
Primary Region                     DR Region (inactive)
  [App] -> [DB]                      (nothing running)
              |
         [Backups] ---------> [S3/GCS cross-region copy]
                                        |
                               (on activation, restore)
                               [App] <- [Restored DB]
```

**When to Use:** Non-critical systems, cost-sensitive, RTO of hours is acceptable
**Cost:** Lowest - only paying for storage of backups
**Key Actions:** Regular backup testing, automated restore scripts

### Pattern 2: Pilot Light

```
Primary Region                     DR Region (minimal)
  [App (3 replicas)]                 (no app running)
  [DB Primary] --------replica-----> [DB Replica]
  [AMIs/Images]                      [AMIs/Images copied]
```

**When to Use:** Important systems, need faster recovery than backup/restore
**Cost:** Low - only DB replica and stored images
**Key Actions:** Keep images updated, automate scaling of compute on activation

### Pattern 3: Warm Standby

```
Primary Region                     DR Region (scaled down)
  [App (3 replicas)]                 [App (1 replica)]
  [DB Primary] --------replica-----> [DB Replica]
  [LB (active)]                      [LB (standby)]
```

**When to Use:** Business-critical systems, RTO under 30 minutes
**Cost:** Medium - running minimal infrastructure
**Key Actions:** Regular traffic testing to DR, automated scaling

### Pattern 4: Active-Active

```
Region A                           Region B
  [App (3 replicas)]                 [App (3 replicas)]
  [DB Primary] <----replication----> [DB Primary]
  [LB (active)]                      [LB (active)]
        \                                /
         \--------- GSLB (DNS) --------/
```

**When to Use:** Mission-critical, zero downtime requirement
**Cost:** Highest - full duplicate infrastructure
**Key Actions:** Conflict resolution strategy, data consistency checks

---

## Runbook Template

```markdown
# DR Activation Runbook

## Prerequisites
- [ ] DR credentials accessible and tested
- [ ] Runbook reviewed within last 30 days
- [ ] DR region infrastructure baseline verified

## Step 1: Declare DR Event
- [ ] Confirm outage is not transient (wait 5 minutes)
- [ ] Page incident commander
- [ ] Update status page

## Step 2: Database
- [ ] Promote read replica: `[exact command]`
- [ ] Verify promotion: `[exact command]`
- [ ] Update connection strings if needed

## Step 3: Application
- [ ] Scale DR compute: `[exact command]`
- [ ] Verify health checks pass: `[exact command]`
- [ ] Verify application logs show normal operation

## Step 4: Traffic Cutover
- [ ] Update DNS: `[exact command]`
- [ ] Wait for propagation (check with `dig`)
- [ ] Verify traffic flowing to DR: check LB metrics

## Step 5: Validate
- [ ] Run smoke tests: `[exact command]`
- [ ] Verify data integrity
- [ ] Confirm monitoring is active
- [ ] Notify stakeholders of recovery

## Rollback (return to primary)
- [ ] Resync data from DR to primary
- [ ] Verify primary health
- [ ] Gradually shift traffic back
- [ ] Rebuild DR replica
```

---

## Verification Checklist

- [ ] RTO and RPO targets are documented for all systems
- [ ] Backups are verified and restorable
- [ ] Failover was executed within the target RTO
- [ ] Data loss was within the target RPO
- [ ] All critical services function correctly in DR
- [ ] Monitoring and alerting work in DR region
- [ ] Lessons learned are documented with action items
- [ ] Runbook is updated based on drill findings

---

## Additional Resources

- [AWS Disaster Recovery Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html)
- [Azure Business Continuity](https://learn.microsoft.com/en-us/azure/reliability/overview)
- [GCP Disaster Recovery Planning](https://cloud.google.com/architecture/dr-scenarios-planning-guide)
- [AWS Elastic Disaster Recovery](https://docs.aws.amazon.com/drs/latest/userguide/what-is-drs.html)
