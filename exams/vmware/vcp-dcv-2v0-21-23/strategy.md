---
last-updated: 2026-05-03
---

# VMware VCP-DCV (2V0-21.23) - Exam Strategy

## Format reminder

- 70 questions, 135 minutes
- Pass mark: 300 / 500 (scaled)
- Multiple choice + multiple response
- Tests vSphere 8.x administration

## Top traps

1. **vSphere HA vs FT vs DRS**:
   - HA: restart on host failure (downtime = boot time)
   - FT: zero-downtime per-VM mirror (limited to 8 vCPU per FT VM)
   - DRS: load balance across hosts (uses vMotion)
   Don't confuse.

2. **vSAN policies**: per-VM, define FTT (1, 2, 3) + FTM (mirror RAID-1 vs erasure coding RAID-5/6) + IOPS + performance reservations. Erasure coding requires more hosts (RAID-5 needs 4+, RAID-6 needs 6+).

3. **vSS vs vDS**: vSS is per-host, vDS is cluster-wide. vDS provides advanced features (Network I/O Control, port mirroring, LACP, NetFlow). VCP-DCV expects vDS in modern designs.

4. **Storage protocols**: VMFS (block, on iSCSI/FC), NFS (v3 vs v4.1), vSAN (HCI), vVols. Each has tradeoffs.

5. **vMotion variants**:
   - vMotion: compute, same datastore, same vCenter
   - Storage vMotion: change datastore, same host
   - Cross-vCenter vMotion: across vCenter
   - Cross-cloud vMotion: with VMware Cloud
   - Long Distance vMotion: RTT up to 150ms

6. **DRS automation levels**: Manual, Partially Automated, Fully Automated. Affinity vs anti-affinity rules.

7. **Resource pools**: hierarchical, shares + reservations + limits. Don't over-nest.

8. **Permissions model**: roles (predefined or custom) + inventory hierarchy. Permissions inherit; can be overridden per object.

9. **vCenter HA**: 3-node cluster (active + passive + witness), distinct from vSphere HA.

10. **Lifecycle Manager (vLCM)**: declarative image-based, replaces VUM. Cluster-level desired-state images.

## High-yield topics easy to miss

- vSphere Lifecycle Manager image vs baseline
- Content Library (templates + ISOs across vCenters)
- vSphere with Tanzu (Kubernetes integrated into vSphere)
- vSphere Trust Authority (key management for encrypted VMs)
- VM encryption with key management server
- Distributed Resource Scheduler (DRS) Affinity Rules + DRS Cluster Cost-based selection
- Predictive DRS (uses vRealize Operations)
- vSphere Replication for DR
- vCenter REST API + PowerCLI for automation

## Time management

135 / 70 = ~2 min/question.

## When stuck

1. **Match the use case to the right vSphere feature** (HA / FT / DRS / vMotion).
2. **Default to the modern recommendation** - vDS over vSS, vLCM over VUM, vSAN over traditional SAN where appropriate.
3. **Eliminate "manual workaround"** when a vSphere feature handles it natively.

## Day-of logistics

135 min, 70 questions. Pearson VUE.

## After

**Pass:** Cert valid 2 years (recertification path). VCAP and VCDX as advanced steps.

**Fail:** Most failures are on Storage (vSAN policies) or Networking (vDS / port groups). Build a home lab if you don't have access to vSphere through work.

## VCP-DCV patterns

- "Restart VMs on host failure" = vSphere HA + restart priority
- "Zero-downtime per-VM" = Fault Tolerance (max 8 vCPU)
- "Load balance across hosts" = DRS
- "Move VM compute + storage" = Combined vMotion + Storage vMotion
- "Cluster-level networking" = vDS
- "Per-VM storage policy" = vSAN storage policy with FTT + FTM
- "vCenter availability" = vCenter HA (active+passive+witness)
- "Cluster lifecycle" = vSphere Lifecycle Manager images
- "Encrypted VMs" = VM Encryption + KMS / vSphere Trust Authority
- "K8s on vSphere" = vSphere with Tanzu
