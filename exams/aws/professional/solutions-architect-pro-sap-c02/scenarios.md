---
last-updated: 2026-05-03
---

# AWS Solutions Architect Pro (SAP-C02) - Exam Scenarios

> Eight worked scenarios mirroring SAP-C02 question style. These are illustrative, not real exam questions. SAP-C02 questions are long (often a paragraph of context), have 4-5 plausible options, and frequently come down to "which is *most* cost-effective" or "which has *least* operational overhead" - not "which works." Read every word; the constraint that decides the answer is often a single phrase.

## How to use this

1. Read the scenario, attempt your own answer before reading the analysis.
2. For each option, articulate why it's right or wrong - "feels right" doesn't transfer to the exam.
3. The takeaway at the bottom is the principle to remember when you see this pattern again.

---

## Scenario 1 - Multi-account governance at scale (Domain 1: 26%)

A holding company has 200 AWS accounts across 30 OUs in AWS Organizations. Engineering teams need self-service account creation with mandatory baseline guardrails (encrypted S3 buckets, no public access, CloudTrail in every region) and automatic membership in a security OU. The platform team wants minimal ongoing operational overhead.

Which approach best meets the requirements?

A. Use AWS Control Tower with Account Factory; enforce guardrails as Service Control Policies (SCPs) on the OU; enable detective guardrails via Config managed rules.
B. Build a custom Lambda + Step Functions pipeline that uses CreateAccount and applies a CloudFormation StackSet for the baseline.
C. Use AWS Service Catalog with launch constraints to provision new accounts; attach IAM policies for baseline.
D. Manually create accounts via the Organizations console and apply tagging on top.

**Analysis**

A is right: Control Tower is the AWS-native answer for multi-account governance. Account Factory + guardrails (preventive via SCP, detective via Config) is the documented best practice and has the least operational overhead. B works but is the "build it yourself" answer - SAP-C02 punishes choosing custom over managed. C is for resource provisioning within an account, not new-account creation. D is the wrong answer to almost every multi-account question.

**Answer:** A

**Key takeaway:** When the question mentions *governance*, *guardrails*, *baseline*, or *new-account creation* with low operational overhead, default to AWS Control Tower unless the question explicitly rules it out (e.g., regulatory or technical constraints).

---

## Scenario 2 - Hybrid connectivity and DNS (Domain 1: 26%)

A company has 50 on-premises sites connected to AWS via Direct Connect with a Transit Gateway in us-east-1. They are deploying a new application across us-east-1 and eu-west-1 and need: bidirectional DNS resolution between on-prem and both VPCs, encrypted traffic over the DX path, and minimum changes to existing on-prem DNS.

Which combination should they implement?

A. Route 53 Resolver inbound + outbound endpoints in each VPC; conditional forwarding rules on on-prem DNS pointing at the inbound endpoints; enable MACsec on the Direct Connect connections.
B. Route 53 Private Hosted Zones associated with both VPCs; on-prem DNS configured with public Route 53 forwarders.
C. AWS Managed Microsoft AD with conditional forwarders; site-to-site VPN over the Direct Connect for encryption.
D. Route 53 Resolver inbound endpoints only; rely on the existing on-prem DNS as the authoritative source for all queries.

**Analysis**

A is right: inbound endpoints serve VPC-resident DNS to on-prem; outbound endpoints forward queries from VPC to on-prem; conditional forwarding on on-prem points the AWS-owned domain at the inbound endpoints. MACsec is the AWS-recommended encryption for DX (where supported - 100 Gbps). B doesn't solve on-prem-to-VPC resolution. C is over-engineered. D is one-way.

**Answer:** A

**Key takeaway:** Hybrid DNS = inbound + outbound Resolver endpoints. MACsec is the encryption-in-transit answer for Direct Connect. Site-to-site VPN over DX is also legitimate but generally chosen when MACsec isn't available.

---

## Scenario 3 - Large database migration (Domain 4: 20%)

A retail company is migrating a 50 TB on-premises Oracle database to AWS with these constraints: maximum 8-hour cutover window, schema conversion required (target is Aurora PostgreSQL), and the source must remain primary during migration with continuous data replication.

Which approach minimizes risk and downtime?

A. AWS Schema Conversion Tool (SCT) for schema conversion, then DMS with full-load + CDC ongoing replication; cut over by stopping writes on source after CDC catches up.
B. Native Oracle Data Pump export to S3, then Aurora PostgreSQL import; manual schema conversion on the fly.
C. AWS Snowball Edge to ship the database; reload into Aurora.
D. AWS Application Migration Service (MGN) lift-and-shift to EC2 running Oracle, then re-platform later.

**Analysis**

A is right: SCT handles schema/PL-SQL conversion to PostgreSQL; DMS does a full-load followed by change data capture (CDC) so the source stays primary; cutover is just stopping writes once CDC lag is near zero. B requires downtime equal to the export+import duration (way more than 8h for 50 TB) and manual schema work. C is for one-time bulk transfer with no CDC - useless when source must remain primary. D doesn't change the engine (still Oracle, plus EC2 ops overhead).

**Answer:** A

**Key takeaway:** Heterogeneous DB migration with low downtime = SCT + DMS with CDC. Snowball is for offline bulk transfer only. MGN is lift-and-shift, not engine conversion.

---

## Scenario 4 - Cost optimization for steady workload (Domain 3: 25%)

A SaaS company runs 800 m6i.xlarge EC2 instances 24/7 in us-east-1 for a steady production workload. The instances are stable in size; engineering doesn't change instance types. The CFO wants the largest possible cost reduction while maintaining flexibility to switch instance families if a better fit emerges.

Which purchase option fits best?

A. 3-year all-upfront EC2 Reserved Instances for the m6i.xlarge family.
B. 3-year Compute Savings Plans with no upfront.
C. 3-year EC2 Instance Savings Plans for the m6i family with no upfront.
D. Spot Instances managed via Spot Fleet with diversification.

**Analysis**

C is right: EC2 Instance Savings Plans give the deepest discount at the family level (~72% on 3-year all-upfront m6i) while preserving flexibility within the family. A locks you to specific size/region with the highest savings but is *less* flexible than Instance SP because it's region-locked and can't be modified. B (Compute SP) covers any instance family / region / OS at a smaller discount - more flexible but lower savings. D is inappropriate for steady production where availability matters.

**Answer:** C

**Key takeaway:** Savings Plans hierarchy: Compute SP (most flexible, lowest discount) → EC2 Instance SP (family-locked, mid discount) → RIs (size+region-locked, highest discount but legacy). For steady production where the family is stable, Instance SP is usually the sweet spot in modern question framing.

---

## Scenario 5 - Multi-region active-active for global app (Domain 2: 29%)

A media platform serves users in NA, EU, and APAC. They need a globally-replicated relational data layer with sub-second writes from any region, automatic conflict resolution, and 99.999% availability. Cost is secondary to user experience.

Which design fits?

A. Aurora Global Database with one primary region and read replicas in two secondaries; failover via Route 53.
B. Aurora PostgreSQL with cross-region read replicas; application logic to route writes to the primary.
C. Amazon DynamoDB Global Tables across three regions.
D. RDS Multi-AZ in three separate regions with custom logic to replicate writes.

**Analysis**

C is right: DynamoDB Global Tables are multi-active; writes accepted in any region with last-writer-wins conflict resolution and ~1s replication. The 99.999% SLA matches. The catch: it's NoSQL, so the question's framing of "relational data layer" is a trap to test whether the candidate forces a relational design when the requirements (multi-active globally) actually demand DynamoDB. A: Aurora Global is one-write-region only. B: same problem. D: lots of operational overhead and no built-in conflict resolution.

**Answer:** C

**Key takeaway:** "Relational" in the prompt doesn't override "multi-active globally + sub-second writes from any region." When all three of those constraints appear, DynamoDB Global Tables is the AWS answer; if the workload truly requires SQL, expect to push back on the latency or write-locality requirement.

---

## Scenario 6 - Disaster recovery design tradeoffs (Domain 2: 29%)

An insurance company's core claims-processing app runs on EC2 + RDS Multi-AZ in us-east-1. RPO target is 5 minutes; RTO target is 1 hour. The DR region must be us-west-2. Cost-conscious but cannot compromise the RPO/RTO.

Which DR strategy fits?

A. Backup and restore from automated RDS snapshots and AMIs.
B. Pilot light: keep core data tier replicated to us-west-2 (Aurora cross-region replicas or DMS), keep app servers stopped, scale up on disaster.
C. Warm standby: full but scaled-down stack always running in us-west-2 with continuous replication.
D. Multi-site active-active across both regions with global LB.

**Analysis**

B is right: Pilot light meets a 1-hour RTO comfortably (auto-scaling app servers from a tested AMI in DR ~10-15 min) and a 5-min RPO (cross-region replicated DB). Backup-and-restore (A) blows the 1-hour RTO since restoring a 50 GB+ DB takes ~30 min plus full app reconfig. Warm standby (C) is overkill for a 1-hour RTO and significantly more expensive. Active-active (D) is overkill and expensive when the workload has a clear primary.

**Answer:** B

**Key takeaway:** Map RTO/RPO targets to DR pattern: minutes/zero → multi-site, minutes/seconds → warm standby, hours/minutes → pilot light, days/hours → backup-restore. SAP-C02 loves to test the boundary between pilot light and warm standby.

---

## Scenario 7 - Centralized network egress (Domain 1: 26%)

A company has 30 spoke VPCs and wants centralized egress to the internet through a single shared VPC running NAT Gateways and a perimeter firewall, with traffic between spokes also inspected.

Which architecture fits?

A. AWS Transit Gateway connecting all VPCs; route tables on TGW direct egress and inter-VPC traffic through a central inspection VPC running AWS Network Firewall and NAT Gateways.
B. VPC peering mesh between all 30 VPCs and the central VPC; security groups for inspection.
C. AWS PrivateLink endpoints in each spoke VPC pointing at services in the central VPC.
D. Direct Connect Gateway with associated VIFs for each VPC.

**Analysis**

A is right: this is the canonical "centralized inspection + egress" pattern. TGW with route table tricks (or now AWS Cloud WAN) directs east-west and north-south through a dedicated inspection VPC. B doesn't scale (peering is non-transitive; 30 VPCs = 435 peering connections for full mesh) and provides no inspection. C is for service exposure, not network routing. D is for hybrid connectivity to on-prem.

**Answer:** A

**Key takeaway:** Centralized inspection / egress = TGW + dedicated inspection VPC + AWS Network Firewall (or third-party Gateway Load Balancer pattern). Peering is for small fixed topologies; PrivateLink is for service exposure.

---

## Scenario 8 - SaaS multi-tenant data isolation (Domain 2: 29%)

A B2B SaaS startup has 5,000 enterprise tenants. They store tenant data in S3. Tenants vary in compliance requirements; some need their data encrypted with their own KMS keys, others share a service-owned key. Tenants must never access another tenant's data even via a misconfigured app.

Which design provides the strongest isolation with manageable cost?

A. One S3 bucket per tenant, IAM policies scoped per bucket, customer-managed KMS key per tenant where required.
B. Shared S3 bucket, prefix-per-tenant, single SSE-S3 key, application-layer authorization.
C. S3 Access Points per tenant against a shared bucket, with each access point's policy scoping to a tenant prefix and (optionally) a tenant-specific KMS key.
D. AWS Organizations with one account per tenant; S3 buckets inside each account.

**Analysis**

C is right: S3 Access Points are designed exactly for this pattern - per-tenant policies, per-tenant KMS keys, scoped prefixes, all on a single underlying bucket so you don't blow through the 1000-bucket-per-account limit at 5000 tenants. A hits bucket limits. B is no isolation - one bug and tenants see each other's data. D is the strongest isolation but operationally expensive at 5000 accounts; usually only justified for the highest-compliance tenants.

**Answer:** C

**Key takeaway:** Multi-tenant S3 isolation hierarchy: shared bucket + access points (default) → bucket per tenant (high compliance subset) → account per tenant (regulated workloads only). Access Points are the SAP-C02 answer to "thousands of tenants with varied policy requirements."
