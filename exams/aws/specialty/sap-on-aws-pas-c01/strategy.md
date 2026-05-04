---
last-updated: 2026-05-03
---

# AWS SAP on AWS Specialty (PAS-C01) - Exam Strategy

> Cert-specific tactics. PAS-C01 is the most niche of the AWS Specialties; it assumes substantial SAP basis / Solution Architect experience. The exam is half SAP-on-AWS architecture and half AWS specifics; neither alone is enough.

## Format reminder

- 65 scored questions, 170 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response

## Top traps

1. **SAP-certified instance types**: only specific families are SAP-certified for HANA (u-*, x1, x1e, x2idn, x2iedn, r5.metal, r6i.metal). m5/m6 are NOT certified for HANA scale-up. The certified list changes; check SAP Note 1656099 for the current list.

2. **HANA storage profile**: log volume needs IOPS (io2 Block Express); data volume needs throughput (gp3); /hana/shared on EFS or FSx. Don't put log on gp3 when the dataset is large.

3. **HSR vs DB native backup**: System Replication is the HA mechanism; Backint is the backup integration. Different things.

4. **SAP tooling vs AWS tooling**: SAP DMO, SUM, BackInt - these are SAP tools that integrate with AWS. Generic AWS migration tools (DMS, MGN) are usually wrong for SAP migrations.

5. **Cluster manager requirement**: HSR alone doesn't do automatic failover. SUSE HAE or RHEL HA Add-On is required.

6. **Overlay IP for VIP**: AWS doesn't have native gratuitous ARP for VIPs. The pattern is Route 53 → ENI / EIP shift, or specific AWS implementations like Overlay IP using a Lambda + route table updates.

7. **SAP licensing on AWS**: BYOL is the default for SAP licenses. License-included is for Microsoft / Windows, not SAP. Don't confuse.

8. **High Memory (u-*) instances**: dedicated host model historically; now also as bare metal instances. Some only available in select regions.

9. **EC2 Dedicated Hosts vs Dedicated Instances**: dedicated hosts let you BYOL with explicit visibility into the physical host; dedicated instances just guarantee single-tenant hardware. SAP workloads sometimes need dedicated hosts for licensing.

10. **SAP-aware backup/restore tooling**: AWS Backint Agent is the supported integration with HANA's native backup APIs; raw EBS snapshots are valid for instance-level recovery but not the SAP-certified backup path.

## High-yield topics easy to miss

- AWS Launch Wizard for SAP (automates HANA / NetWeaver provisioning following SAP Reference Architectures)
- SAP HANA Quick Start (CloudFormation templates)
- AWS Migration Evaluator (sizing tool, formerly TSO Logic) for SAP migrations
- AWS Application Migration Service (MGN) for non-database SAP server migrations (NetWeaver app servers, lift-and-shift)
- Amazon FSx for ONTAP and FSx for OpenZFS - both increasingly used for SAP shared storage
- Reserved instances for SAP-licensed workloads - consider regional vs zonal RIs
- SAP S/4HANA Cloud (managed by SAP) vs self-managed S/4HANA on AWS - know the difference

## Time management

170 / 65 = 2.6 min/question. Bank time on AWS-fundamentals questions you know cold; spend the saved time on SAP-specific scenarios with multiple plausible answers. Pace: Q20 by 50 min, Q40 by 100 min, finish by 160 min, leave 10 min for flagged review.

## When stuck

1. **Default to SAP-supported tooling** when in doubt - if SAP supplies a tool for the task, that's usually the right answer.
2. **Match the HANA storage tier to the volume type** - log = IOPS-bound = io2; data = throughput-bound = gp3.
3. **Eliminate non-certified instances** for HANA workloads.
4. **Read the RTO/RPO/cost constraints** like any DR question to choose pilot light vs warm standby vs active-active.

## Day-of logistics

170 min, 65 questions: standard pacing. Bring two IDs.

## After

**Pass:** Specialty cert valid 3 years.

**Fail:** Most failures are on Domain 1 (Design - 30%) due to specific HANA sizing / storage / certified-instance trivia. Re-review SAP Note 1656099 (HANA-certified instances), the SAP on AWS general guide, and the HANA storage white paper.

## PAS-C01 patterns

- "HANA scale-up >3 TB RAM" = u-* High Memory instances (most certified)
- "HANA scale-up <2 TB RAM" = x1 / x1e or x2idn / x2iedn
- "HANA log volume" = io2 Block Express
- "HANA data volume" = gp3
- "HANA HA in same region" = HSR sync + cluster manager + Overlay IP
- "HANA DR cross-region" = HSR async + pilot light
- "HANA backup to S3" = Backint Agent
- "OS migration + DB migration in one outage" = DMO with System Move
- "Lift-and-shift SAP NetWeaver server" = AWS MGN
- "SAP licensing isolation" = Dedicated Host
