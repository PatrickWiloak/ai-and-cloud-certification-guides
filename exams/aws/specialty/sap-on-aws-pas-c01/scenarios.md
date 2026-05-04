---
last-updated: 2026-05-03
---

# AWS SAP on AWS Specialty (PAS-C01) - Exam Scenarios

> Six worked scenarios mirroring PAS-C01 question style. Illustrative, not real exam questions. PAS-C01 is the most niche AWS Specialty - it tests knowledge of how to run SAP HANA / S/4HANA / NetWeaver on AWS, including SAP-certified instance types, storage profiles for HANA, and SAP-specific HA/DR patterns.

---

## Scenario 1 - Instance selection for HANA (Domain 1: 30%)

A customer needs to size a single-node HANA scale-up appliance for 6 TB RAM with 99.9% availability and SAP certification.

Which instance type fits?

A. u-9tb1.metal (High Memory) - SAP-certified for HANA scale-up.
B. r5.metal - 768 GB RAM only.
C. x1.32xlarge - 1.95 TB RAM, also SAP-certified but smaller.
D. m5.24xlarge - 384 GB RAM, not SAP-certified for HANA.

**Analysis**

A is right: AWS High Memory (u-*) instances are SAP-certified for very large HANA workloads (3 TB to 24 TB). u-9tb1.metal exposes 9 TB which fits a 6 TB requirement with headroom. C is too small. B and D aren't SAP-certified for HANA at this scale.

**Answer:** A

**Key takeaway:** SAP HANA on AWS instance families (memorize the certified list): u-* (High Memory, 3 TB-24 TB), x1/x1e (1.95 TB, 3.9 TB), x2idn / x2iedn (Sapphire Rapids, up to 4 TB), r5.metal / r6i.metal (smaller HANA workloads). m5/m6 are *not* SAP-certified for HANA.

---

## Scenario 2 - HANA storage profile (Domain 1: 30%)

A 4 TB HANA database needs storage that meets SAP's KPIs: log volume IOPS, data volume throughput, and snapshot capability for backup.

Which storage configuration fits?

A. EBS gp3 for /hana/data; EBS io2 Block Express for /hana/log; FSx for HANA backup.
B. EBS gp3 for everything.
C. Instance store NVMe for /hana/log; EBS gp3 for /hana/data.
D. EFS for /hana/data; EBS gp2 for /hana/log.

**Analysis**

A is right: SAP KPIs require very high IOPS for the log volume (io2 Block Express delivers 256K IOPS / 4 GB/s, the highest single-volume EBS); gp3 is sufficient and cost-effective for /hana/data. SAP storage white papers explicitly recommend this split. C uses instance store which is not durable. B undersizes the log. D - EFS doesn't meet HANA latency requirements.

**Answer:** A

**Key takeaway:** SAP HANA storage on AWS: log → io2 Block Express (IOPS-bound), data → gp3 (throughput-bound), shared → EFS or FSx for binary distribution. Backup → EBS snapshots or AWS Backint Agent to S3.

---

## Scenario 3 - HA architecture for HANA (Domain 1: 30%)

A productive S/4HANA system needs high availability with automatic failover and < 1 minute RTO.

Which fits?

A. SAP HANA System Replication (HSR) sync between two AZs in the same region; cluster manager (e.g., SUSE / RHEL HA) controls failover; Overlay IP managed via Route 53 / EIP attached to active node.
B. AWS RDS for HANA Multi-AZ.
C. EBS snapshots restored on a standby instance manually.
D. CloudFormation StackSet to redeploy HANA on failure.

**Analysis**

A is right: SAP HANA System Replication is THE supported HA pattern, paired with a cluster manager. Two AZs for AZ-failure tolerance. Overlay IP / virtual IP via Route 53 or secondary IP that moves to the active node. B doesn't exist (HANA isn't on RDS). C is manual recovery. D is too slow.

**Answer:** A

**Key takeaway:** HANA HA on AWS = HSR + cluster manager (SUSE HAE / RHEL HA Add-On) + Overlay IP for VIP. The cluster manager is required; HSR alone doesn't do automatic failover.

---

## Scenario 4 - Migration approach (Domain 2: 30%)

A customer is migrating SAP ECC on Oracle on HP-UX (4 TB) to S/4HANA on AWS. Downtime tolerance is 24 hours.

Which approach fits?

A. SAP Database Migration Option (DMO) with System Move - migrate from Oracle to HANA and move to AWS in one outage.
B. Re-platform Oracle on EC2 first; migrate to HANA in a second outage later.
C. AWS DMS for Oracle to HANA conversion.
D. Snowball Edge for offline data transfer.

**Analysis**

A is right: SAP DMO is the SAP-supplied tool for Oracle → HANA conversion *with* simultaneous OS/platform move (System Move option). It fits the 24-hour window for 4 TB. B is two outages and twice the work. C - DMS doesn't support HANA targets for SAP-aware migrations. D is for raw data offline only; doesn't handle SAP conversion.

**Answer:** A

**Key takeaway:** SAP migration tooling: SUM (SAP system upgrades), DMO (DB migration option), DMO with System Move (DB + platform), SAP Backint for backup, AWS Migration Evaluator for sizing. Memorize SAP's tools - generic AWS migration tools (DMS, MGN) rarely fit SAP-aware migrations.

---

## Scenario 5 - Backup strategy for HANA (Domain 3: 20%)

A 6 TB HANA database needs daily backups stored for 30 days with point-in-time recovery (log backups every 15 min). Cost matters; recovery should not exceed 4 hours.

Which fits?

A. EBS snapshots for HANA data + log via AWS Backup; AWS Backint for compressed log archival to S3 with intelligent tiering.
B. Manual scp of /hana/data to S3 daily.
C. Oracle RMAN backups (legacy approach).
D. Glacier Deep Archive for primary backups.

**Analysis**

A is right: AWS Backint Agent integrates with HANA native backup APIs to push backups (full + log) to S3 directly; lifecycle policies move older backups to cheaper tiers. AWS Backup adds policy and central management. B is manual and not HANA-aware. C - HANA, not Oracle. D blocks 4-hour RTO (Glacier Deep Archive has 12-48h restore).

**Answer:** A

**Key takeaway:** HANA backup on AWS = Backint Agent + S3 + lifecycle policies. EBS snapshots are also valid for instance-level backup. Glacier Deep Archive is too slow for the typical RTO.

---

## Scenario 6 - DR for SAP S/4HANA (Domain 3: 20%)

An SAP customer needs DR for a productive S/4HANA system in us-east-1 with RTO 4 hours, RPO 15 minutes, in us-west-2.

Which fits?

A. HANA System Replication async to us-west-2 standby; SAP application servers in us-west-2 stopped, brought up on failover via CloudFormation; DNS swap.
B. EBS snapshots replicated cross-region; rebuild in us-west-2 on disaster.
C. Multi-region active-active with sync replication.
D. AWS Backup cross-region copy of SAP volumes only.

**Analysis**

A is right: HSR async cross-region keeps RPO under 15 min; pilot-light architecture (data tier replicated, app tier off but ready) meets 4h RTO. B can hit 4h RTO but log RPO of 15 min is hard with snapshot intervals. C is overkill and impractical (sync HSR cross-region has unacceptable latency). D is incomplete.

**Answer:** A

**Key takeaway:** SAP DR on AWS: pilot light (HSR async + stopped app tier) for 4h RTO / 15min RPO. Warm standby (smaller running app tier) for tighter RTO. Active-active is rare due to sync HSR latency.
