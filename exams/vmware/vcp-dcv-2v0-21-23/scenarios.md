---
last-updated: 2026-05-03
---

# VMware VCP-DCV (2V0-21.23) - Exam Scenarios

> Six worked scenarios mirroring VCP-DCV question style. VCP-DCV tests vSphere 8 administration: ESXi, vCenter, networking (vSS / vDS), storage (vSAN, VMFS, NFS), HA / DRS, lifecycle management.

---

## Scenario 1 - HA configuration for critical VMs

A cluster runs 50 VMs; 5 are mission-critical and must restart fastest on host failure.

**Options:** A. Enable vSphere HA; configure VM restart priority (Highest for critical 5, Medium for others); admission control: cluster resources reserved at host-failure tolerance; ensure isolation response. B. Enable HA without priorities. C. Use FT for everything. D. Manual restart on failure.

**Analysis:** A is right - HA + restart priority is the canonical pattern. Admission control reserves capacity. B treats all VMs equally. C - FT (Fault Tolerance) is for zero-downtime per-VM but limited (max 8 vCPU per FT VM, doubles host load). D defeats the purpose.

**Answer:** A

**Key takeaway:** vSphere HA = host failure restart. FT = zero-downtime mirror per VM (limited). DRS = load balance across hosts.

---

## Scenario 2 - vSAN storage policy

A team wants critical VMs replicated 2 ways across hosts (FTT=1) with SSD performance tier; other VMs at FTT=0 (no replication) for cheap storage.

**Options:** A. Two storage policies: critical (FTT=1, RAID-1, all-flash, IOPS limit 5000); non-critical (FTT=0, performance reservation 0). Apply per VM via VM storage policy. B. Single policy for all. C. Two separate datastores. D. RDM for critical VMs.

**Analysis:** A is right - vSAN storage policies are per-VM, configurable for FTT (Failures To Tolerate), FTM (RAID-1, RAID-5/6), IOPS, performance reservation. Apply per VM at provisioning or change later. B treats all VMs equally. C - vSAN is one datastore per cluster. D bypasses vSAN.

**Answer:** A

**Key takeaway:** vSAN storage policy attributes: FTT (1, 2, 3), FTM (RAID-1 mirror, RAID-5/6 erasure coding), IOPS limit, object space reservation, flash read cache reservation.

---

## Scenario 3 - vDS migration

A team has hosts on vSwitch (vSS) and wants to migrate to a Distributed vSwitch (vDS) without downtime.

**Options:** A. Create vDS at the cluster level; add hosts to the vDS; migrate VMkernel adapters one-by-one (mgmt, vMotion, storage); migrate VM port groups; remove vSS. B. Replace vSS with vDS instantly. C. Recreate VMs on new switch. D. Disconnect hosts during migration.

**Analysis:** A is right - the in-place migration: add hosts to vDS, migrate VMkernel and uplinks one at a time, migrate VM networking, remove vSS. B is impossible (no instant swap). C is unnecessary. D causes downtime.

**Answer:** A

**Key takeaway:** vSS → vDS migration is in-place via the host network migration wizard. Migrate VMkernel and VM port groups in stages.

---

## Scenario 4 - Lifecycle management

An admin needs to upgrade ESXi versions across 20 hosts consistently, with rollback support.

**Options:** A. vSphere Lifecycle Manager (vLCM) with cluster-level images: define a desired-state image (ESXi version + drivers + add-ons); remediate hosts; rollback via VUM-style snapshot if needed. B. Update each host manually via SSH. C. Hand-rolled scripts. D. Ignore version drift.

**Analysis:** A is right - vLCM is the modern declarative lifecycle tool (replaces VMware Update Manager). Cluster image defines the desired state; hosts are remediated to match. B / C don't enforce consistency. D causes drift.

**Answer:** A

**Key takeaway:** vSphere Lifecycle Manager (vLCM) is declarative cluster-level lifecycle. Replaces the older VMware Update Manager (VUM).

---

## Scenario 5 - vCenter HA

vCenter is critical; the team wants HA for vCenter itself.

**Options:** A. vCenter HA (Active / Passive / Witness): three nodes, automatic failover via cloned passive node and a separate witness for quorum. B. vSphere HA on the vCenter VM. C. Multiple vCenter instances. D. Backup only.

**Analysis:** A is right - vCenter HA is the native solution: active vCenter, passive standby (clone), witness for split-brain prevention. Automatic failover. B is partial (host-level, not service-level HA). C is for ELM (Enhanced Linked Mode) federation, not HA. D is recovery, not HA.

**Answer:** A

**Key takeaway:** vCenter HA = active + passive + witness, automatic failover. Distinct from vSphere HA (which protects VMs from host failure).

---

## Scenario 6 - VM migration with shared storage

An admin needs to migrate VMs across hosts and across storage simultaneously without downtime.

**Options:** A. Storage vMotion + Compute vMotion (cross-vCenter or cross-host with cross-storage). B. Power off, copy files, power on. C. Snapshot, copy snapshot, restore. D. P2V conversion.

**Analysis:** A is right - Storage vMotion changes datastore; vMotion changes host; combined operation moves both with no downtime. Cross-vCenter vMotion supports cross-vCenter migrations. B / C cause downtime. D is for physical-to-virtual.

**Answer:** A

**Key takeaway:** vMotion (compute), Storage vMotion (storage), Cross-vCenter vMotion (across vCenter), Long Distance vMotion (RTT up to 150ms). Combine for compute + storage move.
