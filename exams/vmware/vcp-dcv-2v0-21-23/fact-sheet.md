---
last-updated: 2026-05-03
---

# VCP-DCV (2V0-21.23) - Fact Sheet

## Quick Reference

**Exam Code:** 2V0-21.23
**Duration:** 135 minutes
**Questions:** 70 (multiple choice, single and multiple answer)
**Passing Score:** 300 / 500
**Cost:** $250 USD

**[Official 2V0-21.23 Exam Prep Guide](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/certification/vmw-vcp-dcv-2024-exam-prep-guide.pdf)**
**[VMware Configuration Maximums Tool](https://configmax.broadcom.com/)** - authoritative source for all maximums
**[VMware Compatibility Guide](https://www.vmware.com/resources/compatibility/search.php)** - HCL

---

## vSphere 8 Configuration Maximums (high-yield)

Source: [configmax.broadcom.com](https://configmax.broadcom.com/) (vSphere 8.0 U3).

### Per virtual machine

| Resource | Max |
|---|---:|
| vCPUs per VM | 768 |
| RAM per VM | 24 TB |
| Virtual NICs per VM | 10 |
| Virtual SCSI adapters | 4 |
| Virtual disks per VM | 256 (PVSCSI), 60 (LSI), 32k (NVMe) |
| Virtual disk size | 62 TB |
| Virtual NVMe controllers per VM | 4 |
| PCI passthrough devices per VM | 32 |
| vGPUs per VM | 8 |
| Serial ports per VM | 32 |

### Per ESXi host

| Resource | Max |
|---|---:|
| Logical CPUs per host | 1,920 |
| RAM per host | 24 TB |
| VMs per host | 1,024 |
| Powered-on VMs per host | 1,024 |
| Virtual NICs per host | 4,096 |
| Datastores per host (VMFS) | 1,024 |
| LUNs per host | 1,024 |
| Paths per host | 4,096 |
| Paths per LUN | 32 |
| Concurrent vMotions per host (10 GbE) | 8 |
| Concurrent vMotions per host (1 GbE) | 4 |

### Per cluster

| Resource | Max |
|---|---:|
| Hosts per non-vSAN HA/DRS cluster | 96 |
| Hosts per vSAN cluster (standard) | 96 |
| Hosts per vSAN stretched cluster | 30 (15 per site + 1 witness) |
| VMs per cluster | 10,000 |
| VMs per host (powered on) | 1,024 |
| FT-protected VMs per cluster | 128 |
| FT-protected VMs per host | 4 |

> **Note.** vSphere 7 capped clusters at 64 hosts. The 96-host cap is a vSphere 8 increase. Some study material still says 64; trust [configmax.broadcom.com](https://configmax.broadcom.com/).

### Per vCenter Server

| Resource | Max |
|---|---:|
| Hosts per vCenter | 2,500 |
| Powered-on VMs per vCenter | 40,000 |
| Registered VMs per vCenter | 45,000 |
| Linked vCenters (Enhanced Linked Mode) | 15 |
| Hosts across linked vCenters | 15,000 |
| Powered-on VMs across linked vCenters | 150,000 |

### vSphere Distributed Switch (vDS)

| Resource | Max |
|---|---:|
| vDS instances per vCenter | 128 |
| Hosts per vDS | 2,000 |
| Distributed port groups per vDS | 10,000 |
| Static ports per vDS | 60,000 |
| Distributed ports per vCenter | 60,000 |

---

## VCSA Sizing (Tiny / Small / Medium / Large / X-Large)

| Size | vCPU | RAM | Storage (default) | Hosts | VMs |
|---|---:|---:|---:|---:|---:|
| Tiny | 2 | 14 GB | 463 GB | 10 | 100 |
| Small | 4 | 21 GB | 533 GB | 100 | 1,000 |
| Medium | 8 | 30 GB | 658 GB | 400 | 4,000 |
| Large | 16 | 39 GB | 989 GB | 1,000 | 10,000 |
| X-Large | 24 | 58 GB | 1,786 GB | 2,500 | 45,000 |

Storage profiles add additional disk for /storage/seat (stats/events/alarms/tasks): Default, Large, X-Large.

---

## License Editions and Subscription Bundles

### Pre-Broadcom (legacy perpetual SKUs - still on questions you may see)

| Edition | Key Features |
|---|---|
| vSphere Standard | ESXi, vCenter Standard, basic HA, vMotion |
| vSphere Enterprise Plus | Adds DRS, Storage DRS, vDS, Host Profiles, FT (multi-vCPU), Storage I/O Control, Network I/O Control |
| vSphere with Operations Management | Adds vRealize Operations |
| vSphere Essentials Plus Kit | Up to 3 hosts, 2 sockets each, small business bundle |

### Post-Broadcom subscription bundles (Nov 2023 onward)

VMware retired most perpetual licenses and consolidated into two main subscription bundles:

| Bundle | Includes | Target |
|---|---|---|
| **VCF (VMware Cloud Foundation)** | vSphere Enterprise Plus, vSAN, NSX, Aria Suite, HCX, full SDDC stack | Enterprise private cloud |
| **VVF (VMware vSphere Foundation)** | vSphere Enterprise Plus, vSAN (limited 100 GiB/core), Aria Operations, Aria Log Insight | Mid-market virtualization |
| **vSphere Standard** | Standalone, kept for small deployments | Small business / edge |
| **vSphere Essentials Plus** | Small-business bundle, kept post-Broadcom | <100 VMs, 3 hosts |

VCF is licensed per-core (16-core minimum per CPU). VVF is also per-core. Standalone vSphere Standard is still per-CPU with 32-core minimum.

---

## ESXi Boot Media Requirements (vSphere 8)

- Boot device must be at least **32 GB**.
- USB / SD-card-only boot is **deprecated**: vSphere 8 still allows it but with persistent local disk for /scratch and tools, and shows warnings. New deployments should use a dedicated drive.
- ESX-OSData partition holds /scratch, system swap, ESX-OSData; sized 32-128 GB depending on disk size.
- M.2 SATA / NVMe SSD or local HDD/SSD recommended.

---

## VM Hardware Versions (compatibility)

| HW Version | Introduced | Max vCPU | Max RAM | Notes |
|---:|---|---:|---:|---|
| 11 | vSphere 6.0 | 128 | 4 TB | |
| 13 | vSphere 6.5 | 128 | 6 TB | |
| 14 | vSphere 6.7 | 128 | 6 TB | |
| 15 | vSphere 6.7 U2 | 256 | 6 TB | |
| 17 | vSphere 7.0 | 256 | 6 TB | vTPM, vWatchdog Timer |
| 19 | vSphere 7.0 U2 | 768 | 24 TB | |
| 20 | vSphere 8.0 | 768 | 24 TB | vNVMe 1.3, vGPU profiles |
| 21 | vSphere 8.0 U2 | 768 | 24 TB | NVMe 1.3 controller, NVMe TRIM/UNMAP |

`vmx-XX` is the on-disk identifier. Older VMs run fine on newer hosts, but newer features need a HW upgrade.

---

## esxcli Cheat Sheet

`esxcli` is the modern host-level CLI. Run on the ESXi shell or via SSH.

### Host info

```bash
esxcli system version get
esxcli system hostname get
esxcli system maintenanceMode get
esxcli system maintenanceMode set --enable=true
esxcli hardware platform get
esxcli hardware cpu list
esxcli hardware memory get
```

### Networking

```bash
esxcli network nic list                              # physical NICs (vmnicX)
esxcli network nic get -n vmnic0
esxcli network ip interface list                     # vmkernel ports (vmkX)
esxcli network ip interface ipv4 get
esxcli network vswitch standard list
esxcli network vswitch standard portgroup list
esxcli network vswitch standard add -v vSwitch1
esxcli network vswitch standard uplink add -u vmnic1 -v vSwitch1
esxcli network firewall ruleset list
esxcli network firewall ruleset set -e true -r sshServer
```

### Storage

```bash
esxcli storage core adapter list
esxcli storage core device list
esxcli storage core path list
esxcli storage filesystem list                       # mounted datastores
esxcli storage vmfs extent list
esxcli storage nfs list
esxcli storage nfs add -H 10.0.0.5 -s /export/nfs01 -v NFS01
esxcli storage core device set -d <NAA.id> --state=on
```

### vSAN

```bash
esxcli vsan cluster get
esxcli vsan cluster list
esxcli vsan storage list
esxcli vsan health cluster list
esxcli vsan policy getdefault
```

### VM operations

```bash
vim-cmd vmsvc/getallvms                              # list VMs (use vim-cmd, not esxcli)
vim-cmd vmsvc/power.on <vmid>
vim-cmd vmsvc/power.off <vmid>
vim-cmd vmsvc/snapshot.create <vmid>
esxcli vm process list                                # running VM worlds
esxcli vm process kill --type=soft --world-id=<wid>
```

### Software / patching

```bash
esxcli software vib list
esxcli software vib install -d /vmfs/volumes/datastore1/patch.zip
esxcli software profile update -p <profile> -d <depot>
esxcli software vib remove -n <vibname>
```

### Logs

```bash
esxcli system syslog config get
esxcli system syslog config set --loghost='udp://10.0.0.50:514'
esxcli system syslog reload
```

---

## PowerCLI Cheat Sheet

PowerShell module for vCenter / ESXi automation. Install: `Install-Module VMware.PowerCLI`.

### Connect / disconnect

```powershell
Connect-VIServer -Server vcenter.lab.local -User administrator@vsphere.local
Disconnect-VIServer -Server vcenter.lab.local -Confirm:$false
Get-VIServer
```

### Inventory

```powershell
Get-Datacenter
Get-Cluster
Get-VMHost
Get-VMHost esx01.lab.local | Format-List Name, Version, Build, ConnectionState, PowerState
Get-Datastore
Get-VirtualSwitch -VMHost esx01
Get-VDSwitch
Get-VDPortgroup
```

### VM operations

```powershell
Get-VM
Get-VM web01 | Select Name, NumCpu, MemoryGB, PowerState, Folder, ResourcePool
New-VM -Name web02 -Template "Ubuntu-22-Template" -Datastore ds01 -ResourcePool ProdPool
Start-VM -VM web01
Stop-VM -VM web01 -Confirm:$false
Restart-VMGuest -VM web01
Move-VM -VM web01 -Destination esx02.lab.local                   # vMotion
Move-VM -VM web01 -Datastore ds02                                  # Storage vMotion
New-Snapshot -VM web01 -Name "before-patch" -Memory -Quiesce
Get-Snapshot -VM web01
Remove-Snapshot -Snapshot $snap -Confirm:$false
```

### Bulk reporting

```powershell
Get-VM | Select Name, NumCpu, MemoryGB,
    @{N='UsedSpaceGB';E={[math]::Round($_.UsedSpaceGB,1)}},
    @{N='Host';E={$_.VMHost.Name}} |
    Export-Csv vm-inventory.csv -NoTypeInformation
```

### Cluster / DRS / HA

```powershell
Get-Cluster Prod | Select Name, HAEnabled, DrsEnabled, DrsAutomationLevel
Set-Cluster -Cluster Prod -DrsAutomationLevel FullyAutomated -Confirm:$false
New-DrsRule -Cluster Prod -Name "AffinityWeb" -KeepTogether -VM web01,web02
```

### Host config

```powershell
Get-VMHost esx01 | Set-VMHost -State Maintenance
Get-VMHost esx01 | Set-VMHost -State Connected
Get-VMHost | Get-VMHostNetworkAdapter -VMKernel
```

---

## Networking - vSwitch (VSS) vs vSphere Distributed Switch (vDS)

| Feature | VSS (Standard) | vDS (Distributed) |
|---|---|---|
| Scope | Per-host | Cluster / datacenter, managed at vCenter |
| Configuration | Manual per host | Centralized |
| Edition required | Any | Enterprise Plus / VCF / VVF |
| LACP | No | Yes (LACPv2) |
| NetFlow | No | Yes |
| Port mirroring | No | Yes |
| Network I/O Control (NIOC) | No | Yes (v3 in vSphere 8) |
| Private VLANs | No | Yes |
| Health check (MTU, teaming, VLAN) | No | Yes |

### vSwitch policy stack

- **Security**: Promiscuous mode, MAC address changes, Forged transmits (default Reject for the latter two on VSS, Accept on default vDS)
- **Traffic shaping**: Average bandwidth, peak, burst (egress only on VSS, ingress+egress on vDS)
- **Teaming and failover**: Load balancing (Route based on originating port ID, IP hash, source MAC, NIC load), active/standby/unused uplinks

### NIC teaming load-balancing modes

| Mode | When to use | Caveats |
|---|---|---|
| Route based on originating port ID | Default; safe everywhere | No real load distribution per VM |
| Route based on source MAC hash | Rarely used | Similar to port ID |
| Route based on IP hash | EtherChannel / static LAG only | Requires switch-side LAG |
| Route based on physical NIC load | Best for vDS | "Load Based Teaming" (LBT); rebalances every 30s |
| Use explicit failover order | Failover only | No load balancing |

---

## Storage

### VMFS versions

| Version | vSphere | Block size | Max LUN | Max file |
|---:|---|---:|---:|---:|
| VMFS-3 | 3.x-5.x (deprecated) | 1-8 MB | 2 TB | 2 TB |
| VMFS-5 | 5.x-7.x | 1 MB unified | 64 TB | 62 TB |
| VMFS-6 | 6.0+ | 1 MB unified | 64 TB | 62 TB |

VMFS-6 adds: automatic UNMAP, 4K native (4Kn) sector support, SE Sparse improvements.

> **vSphere 7.0 U1+** dropped VMFS-3 support. **vSphere 8.0** does not support VMFS-3. VMFS-5 is supported but VMFS-6 is the default for new datastores.

### NFS versions

| Version | vSphere | Auth | Multipathing |
|---:|---|---|---|
| NFS v3 | All | AUTH_SYS only | Single TCP session, no native MP |
| NFS v4.1 | 6.0+ | AUTH_SYS, Kerberos (krb5, krb5i) | Session trunking |

NFS v3 and NFS v4.1 datastores cannot be mounted by both protocols on the same host simultaneously.

### vSAN concepts

- **Hybrid vs all-flash.** Hybrid uses SSD cache + HDD capacity. All-flash uses SSD cache + SSD capacity. All-flash supports dedupe and compression.
- **Disk groups.** 1 cache device + 1-7 capacity devices = 1 disk group. Up to 5 disk groups per host.
- **OSA vs ESA.** Original Storage Architecture (OSA) uses disk groups. **Express Storage Architecture (ESA)**, new in vSphere 8, uses a flat NVMe-only "storage pool" with no cache tier. ESA needs vSAN ReadyNodes certified for ESA.
- **Storage policies.** FTT (Failures to Tolerate), FTM (RAID-1 mirror, RAID-5/6 erasure coding), stripe width, IOPS limit, force provision.
- **Stretched cluster.** Two sites + witness host for quorum.
- **Hosts in vSAN cluster:** 2-host (ROBO), 3-64 standard, 96 max in vSphere 8.

### Datastore types comparison

| Type | Backing | Use |
|---|---|---|
| VMFS | Block (FC, FCoE, iSCSI, local) | General purpose |
| NFS | NFS server | Often used for templates, ISOs, archive VMs |
| vSAN | HCI - local disks aggregated | Production HCI |
| vVols | SAN with VASA provider | Per-VM granularity, snapshots offloaded to array |

---

## High Availability (vSphere HA)

- Restarts VMs on surviving hosts after a host failure.
- Master/slave model. One host is the master, talks to vCenter and tracks the cluster.
- Heartbeats: management network + heartbeat datastores (default 2).
- **Admission control**: prevents over-commitment so the cluster can recover from N host failures. Default policy: Cluster resource percentage. Alternatives: Slot policy, Dedicated failover hosts.
- **VM monitoring**: restarts a VM if VMware Tools heartbeat stops.
- **Application monitoring**: requires SDK integration.
- **Proactive HA**: vendor health provider triggers maintenance migration before a host fails.

### HA states for hosts

- Connected, Maintenance, Disconnected, Not Responding, Isolated, Network Partitioned

---

## DRS (Distributed Resource Scheduler)

- Balances VM placement across hosts based on CPU/memory load.
- Automation modes: Manual, Partially Automated (placement only), **Fully Automated** (default).
- Migration threshold: 1 (conservative) to 5 (aggressive). Default 3.
- **Predictive DRS** (with Aria Operations) uses 24h forecasts.
- **DRS rules**: VM-VM affinity (keep together), anti-affinity (separate), VM-Host (must / should run on / not run on).

---

## vMotion / Storage vMotion

- **vMotion** moves a running VM's CPU/memory state between hosts. Requires shared storage or vSphere 6.0+ with cross-vSwitch / cross-vCenter / cross-VC vMotion.
- **Storage vMotion** moves VM files between datastores while running.
- **Long Distance vMotion**: up to 150 ms RTT, requires 250 Mbps+ per concurrent vMotion.
- **Encrypted vMotion**: Required, Opportunistic (default), Disabled.

### vMotion network requirements

- Dedicated VMkernel adapter with vMotion service enabled.
- 1 GbE supports 4 concurrent vMotions; 10 GbE supports 8.
- 25/40/100 GbE supported and recommended for high-density.

---

## Fault Tolerance (FT)

- Lock-step secondary VM stays in sync with primary. Zero-downtime failover.
- vSphere 8 FT: up to 8 vCPUs and 128 GB RAM per FT VM.
- Max 4 FT-protected VMs per host, 8 vCPUs total per host.
- Requires dedicated 10 GbE FT logging network. Hardware Virtualization (HV) must be enabled.

---

## Lifecycle Manager (vLCM)

Replaces vSphere Update Manager (VUM). Two modes:

- **Baselines** (legacy, vSphere 7-8): manage hosts with patch and upgrade baselines.
- **Image-based** (vSphere 7+, recommended): single desired-state image (ESXi base + vendor add-ons + components + firmware) applied cluster-wide.

vLCM also patches VMware Tools, VM hardware, and standalone hosts. Image-based clusters cannot mix vendors (e.g., all Dell, or all HPE).

---

## Logs to know (Section 6)

| Log | Where | Contents |
|---|---|---|
| `vmkernel.log` | `/var/log/` on ESXi | VMkernel events: storage, networking, hardware |
| `hostd.log` | `/var/log/` on ESXi | Host management agent (vSphere Client to host) |
| `vpxa.log` | `/var/log/` on ESXi | vCenter agent on host |
| `vpxd.log` | `/var/log/vmware/vpxd/` on VCSA | vCenter Server main log |
| `fdm.log` | `/var/log/` on ESXi | HA Fault Domain Manager |
| `vmware.log` | VM directory on datastore | Per-VM log; one per power-on |
| `auth.log`, `shell.log` | `/var/log/` on ESXi | Login / shell activity |
| `syslog.log` | `/var/log/` on ESXi | Generic syslog |

Bundle support logs with `vm-support` on ESXi or "Export System Logs" in the vSphere Client.

---

## esxtop counters (high-yield)

Press the listed key in `esxtop` to switch view.

| Key | View | Critical counter |
|---|---|---|
| `c` | CPU | %RDY (>10% per vCPU = contention), %CSTP (co-stop, multi-vCPU contention) |
| `m` | Memory | %SWP (swapping = bad), %MCTL (ballooning), N%L (NUMA locality, want >80%) |
| `n` | Network | %DRPTX, %DRPRX (drops) |
| `d` | Disk adapter | DAVG/cmd (device avg latency, want <10 ms), KAVG (kernel, want <1 ms) |
| `u` | Disk device | DAVG, KAVG, GAVG = DAVG+KAVG |
| `v` | Disk VM | Per-VM I/O |
| `i` | Interrupts | CPU interrupt distribution |
| `p` | Power | C-states |

---

## Identity, RBAC, SSO

- **vCenter SSO**: domain default `vsphere.local`. First user `administrator@vsphere.local`.
- **Identity sources**: Integrated Windows Authentication, AD over LDAP, OpenLDAP, vsphere.local. **AD over LDAPS** recommended.
- **Federated identity**: vCenter 7.0+ supports OIDC federation with AD FS, Okta, PingFederate, Azure AD/Entra ID.
- **Roles**: Default - No access, Read-only, Administrator, plus sample roles (Virtual Machine Power User, Datastore Consumer, Network Administrator, etc).
- **Permissions**: assigned at object level (vCenter, datacenter, cluster, host, folder, VM, network, datastore). Permissions propagate down by default.
- **Global permissions** (across linked vCenters) vs **vCenter-scoped permissions**.

---

## Tags and Categories

- **Categories** group related tags (e.g., "Environment" → Prod, Dev, QA).
- Cardinality: One tag per object, or many tags per object (per category).
- Used for: search, content library publishing, storage policies, DRS host groups, backup product policies.

---

## Content Library

- Stores templates (OVF/OVA), ISOs, and other files. Replaces ad-hoc template folders.
- **Local library** vs **Subscribed library** (pull from a published one). Subscribed-on-demand vs Subscribed-immediate.
- Cross-vCenter publish/subscribe is supported.
- Storage backend: any datastore (VMFS, NFS, vSAN). NFS recommended for large libraries.

---

## Common confusions

- **VUM is gone.** vSphere 8 uses vLCM. Don't pick "Update Manager" answers.
- **PSC is gone.** Platform Services Controller was retired with vSphere 7. SSO/CA/VMDir now run inside VCSA.
- **External vCenter database is gone.** VCSA uses an internal embedded vPostgres database. Windows vCenter Server was retired with vSphere 7.
- **NFS v4.1 with Kerberos and VAAI**: VAAI-NAS plugin needed for offloads.
- **APD vs PDL.** All Paths Down (APD) is transient; storage might come back. Permanent Device Loss (PDL) is final - array reports the LUN gone. HA reactions differ.
- **HA vs FT.** HA restarts VMs (downtime). FT runs a lockstep secondary (zero downtime, but performance cost).
- **Memory ballooning vs swapping.** Ballooning is benign reclaim via VMware Tools driver. Host swapping (`.vswp`) means real RAM exhaustion. Compression is in-between.
- **Reservations vs Shares vs Limits.** Reservation = guaranteed minimum. Limit = hard cap. Shares = priority during contention.

---

## High-yield memorization list

- vSphere 8 maximums table above (per VM, per host, per cluster, per vCenter)
- VCSA sizing: Tiny / Small / Medium / Large / X-Large host counts
- License bundles post-Broadcom: VCF vs VVF vs vSphere Standard contents
- vSwitch teaming modes and when each is required
- VMFS-5 vs VMFS-6 differences (UNMAP, 4Kn)
- vSAN OSA disk groups (1 cache + 1-7 capacity, max 5 per host)
- vSAN ESA storage pool concept (vSphere 8 NVMe-only)
- HA admission control policies (Cluster resource percentage default)
- DRS automation modes and migration threshold default of 3
- FT vSphere 8 limits: 8 vCPU, 128 GB RAM, 4 VMs per host
- Logs by component (vmkernel, hostd, vpxa, vpxd, fdm)
- esxtop counters and thresholds (%RDY, DAVG, %SWP)
