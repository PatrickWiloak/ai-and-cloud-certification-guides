# VCP-DCV (2V0-21.23) Study Plan

## 8-Week Comprehensive Study Schedule

This plan assumes 1.5-2 hours of study per day plus 30-60 minutes of hands-on lab work. If you have less time, stretch to 12 weeks. If you are already a working VMware admin, compress to 4-6 weeks and double the lab time.

### Week 1: Foundations and Architecture (Section 1)

#### Day 1-2: Virtualization concepts and VMware portfolio
- [ ] Hypervisor types (Type 1 ESXi, Type 2 Workstation/Fusion)
- [ ] vSphere 8 component map (ESXi, vCenter, vDS, vSAN, NSX, Aria)
- [ ] Post-Broadcom changes: VCF, VVF, vSphere Standard, Essentials Plus
- [ ] Per-core licensing model (16-core minimum per CPU)
- [ ] Read: `notes/01-architecture-technologies.md`

#### Day 3-4: Hardware compatibility and platform services
- [ ] Hardware Compatibility List (HCL) - servers, NICs, HBAs, storage
- [ ] CPU compatibility for vMotion (EVC modes, Intel/AMD baselines)
- [ ] vSphere 8 deprecations: PSC removed, VUM removed, USB-only boot deprecated
- [ ] Lab: install ESXi 8 (ISO or HOL); explore DCUI

#### Day 5-7: vCenter, ESXi, and vDS introduction
- [ ] VCSA architecture (PostgreSQL embedded, no Windows option)
- [ ] vCenter SSO domain (default `vsphere.local`)
- [ ] Enhanced Linked Mode (ELM) for multi-vCenter
- [ ] Lab: deploy VCSA in Tiny size into your ESXi host
- [ ] Read: `notes/02-vmware-solution.md` first half

### Week 2: VMware Solution Components (Section 2)

#### Day 8-10: Networking - vSwitch and vDS
- [ ] Standard vSwitch (VSS) layout, port groups, VMkernel ports
- [ ] vDS architecture, distributed port groups, uplink port groups
- [ ] Teaming and failover policies (port ID, IP hash, LBT)
- [ ] LACPv2 on vDS
- [ ] NIOC (Network I/O Control) v3 reservations and shares
- [ ] Lab: create vDS, migrate VMkernel from VSS to vDS

#### Day 11-13: Storage - VMFS, NFS, vSAN, vVols
- [ ] VMFS-5 vs VMFS-6 (automatic UNMAP, 4Kn)
- [ ] iSCSI software initiator, dynamic vs static discovery
- [ ] NFS v3 vs v4.1 (Kerberos, session trunking)
- [ ] vSAN OSA (cache + capacity disk groups) vs ESA (storage pool)
- [ ] vVols and VASA provider concept
- [ ] Lab: add iSCSI software adapter, mount NFS datastore

#### Day 14: Cluster services - HA, DRS, FT
- [ ] HA failover, master/slave election, datastore heartbeats
- [ ] HA admission control policies (Cluster resource percentage default)
- [ ] DRS automation modes and migration threshold
- [ ] FT lockstep secondary VM, vSphere 8 limits (8 vCPU, 128 GB)
- [ ] Read: `notes/02-vmware-solution.md` second half

### Week 3: Installation and Configuration (Section 4 part 1)

#### Day 15-17: ESXi installation
- [ ] Interactive install from ISO
- [ ] Scripted install (kickstart `ks.cfg`)
- [ ] Auto Deploy (PXE + image profiles)
- [ ] vLCM image-based cluster deployment
- [ ] DCUI navigation, initial host networking, root password
- [ ] Lab: install ESXi via interactive installer; rebuild via kickstart
- [ ] Read: `notes/03-installation-configuration.md` first third

#### Day 18-19: vCenter Server Appliance (VCSA) deployment
- [ ] Stage 1 (deploy OVA), Stage 2 (configure SSO/network)
- [ ] Sizing: Tiny / Small / Medium / Large / X-Large
- [ ] Embedded PostgreSQL, file-based backup
- [ ] vCenter HA (active/passive/witness) - basic concept
- [ ] Lab: redeploy VCSA in Small size to a different cluster

#### Day 20-21: Datacenter and cluster setup
- [ ] Create datacenter, cluster, add hosts
- [ ] Enable vSphere HA on cluster
- [ ] Enable DRS, choose automation level
- [ ] Configure EVC mode for cluster
- [ ] Lab: build a 3-host nested cluster, enable HA + DRS

### Week 4: Installation and Configuration (Section 4 part 2)

#### Day 22-24: Networking configuration
- [ ] Build VSS, add port groups, assign uplinks
- [ ] Create vDS, add hosts, migrate VMkernel adapters
- [ ] Configure VLAN tagging (VST), private VLANs (vDS only)
- [ ] vMotion network design, dedicated VMkernel
- [ ] Lab: create vDS, add 3 hosts, create port groups for management/vMotion/VM traffic

#### Day 25-27: Storage configuration
- [ ] Create VMFS datastore, expand vs grow, multipathing (NMP, PSP)
- [ ] Software iSCSI adapter, target binding, dynamic discovery
- [ ] NFS mount and unmount, AUTH_SYS vs Kerberos
- [ ] Storage policies, VM Storage Policy assignment
- [ ] vSAN: claim disks, create disk groups, enable services
- [ ] Lab: create VMFS-6 datastore, mount NFS, build a 3-node vSAN cluster
- [ ] Read: `notes/03-installation-configuration.md` middle third

#### Day 28: Virtual machine creation
- [ ] Create VM from scratch (HW version, BIOS vs EFI, VMware Tools)
- [ ] OVF/OVA deploy
- [ ] Clone, template, customization specifications
- [ ] Content Library upload and deploy
- [ ] Lab: create Linux VM, install Tools, convert to template, deploy 3 clones

### Week 5: Performance and Optimization (Section 5)

#### Day 29-30: Resource management
- [ ] Resource pools: shares, limits, reservations
- [ ] Expandable reservations
- [ ] Memory overcommit techniques: page sharing, ballooning, compression, swapping
- [ ] Storage I/O Control (SIOC), Network I/O Control (NIOC)
- [ ] Read: `notes/04-performance-optimization-upgrades.md` first half

#### Day 31-33: vMotion / DRS / Storage DRS tuning
- [ ] vMotion network sizing (1 GbE 4-vMotion, 10 GbE 8-vMotion)
- [ ] Long Distance vMotion (150 ms RTT, 250 Mbps)
- [ ] Encrypted vMotion modes
- [ ] DRS migration threshold tuning
- [ ] Predictive DRS with Aria Operations
- [ ] Storage DRS (SDRS) clusters, IO metric inclusion
- [ ] Lab: vMotion a VM, Storage vMotion to a different datastore

#### Day 34-35: Lifecycle Manager and upgrades
- [ ] vLCM baseline mode (legacy) vs image mode
- [ ] Cluster image: ESXi base image + vendor add-on + components + firmware (HSM)
- [ ] Stage / remediate workflow
- [ ] Upgrade path: 7.0 → 8.0 (no direct from 6.7; 6.7 must go to 7.0 first)
- [ ] Lab: stage and remediate a host with vLCM in image mode
- [ ] Read: `notes/04-performance-optimization-upgrades.md` second half

### Week 6: Troubleshooting (Section 6)

#### Day 36-38: Logs and triage tools
- [ ] vmkernel.log, hostd.log, vpxa.log, vpxd.log, fdm.log, vmware.log per VM
- [ ] vm-support bundle generation
- [ ] esxtop counters: %RDY, %CSTP, DAVG, KAVG, GAVG, %SWP, %MCTL
- [ ] esxcli storage / network / vsan diagnostic commands
- [ ] Read: `notes/05-troubleshooting-repairing.md` first half

#### Day 39-40: Common failure modes
- [ ] APD vs PDL behavior, HA reactions
- [ ] vMotion failures (CPU mismatch, network MTU, EVC)
- [ ] HA isolation response (Disabled / Power off / Shut down)
- [ ] DRS migration failed (anti-affinity, host pinning, resource shortage)
- [ ] vSAN: degraded vs absent components, resync

#### Day 41-42: VM and host repair workflows
- [ ] VM restart on isolated host (HA action)
- [ ] Host disconnected: vpxa restart, services.sh restart on host
- [ ] Datastore unmount errors (active VM, locked file)
- [ ] vCenter unable to manage host: agent reset
- [ ] Lab: simulate APD by disabling iSCSI target, watch HA behavior
- [ ] Read: `notes/05-troubleshooting-repairing.md` second half

### Week 7: Administrative and Operational Tasks (Section 7)

#### Day 43-45: VM lifecycle
- [ ] Power operations (power on, power off, suspend, reset)
- [ ] Snapshot create / consolidate / revert / delete
- [ ] Snapshot disk types (delta, sesparse, vsanSparse)
- [ ] Snapshot best practices (max 32 in chain, but operational target <3, <72h)
- [ ] Clone vs template, customization specs
- [ ] Lab: take snapshots, revert, consolidate; clone with customization spec

#### Day 46-47: Permissions, roles, identity
- [ ] vCenter SSO domain `vsphere.local`, identity sources
- [ ] Built-in roles: No access, Read-only, Administrator
- [ ] Custom role creation, privilege selection
- [ ] Permission inheritance and override at child objects
- [ ] Global vs vCenter-scoped permissions
- [ ] Federated identity with AD FS / Okta / Entra ID
- [ ] Read: `notes/06-administrative-operational-tasks.md`

#### Day 48-49: Content Library, tags, categories
- [ ] Local library, published library, subscribed library
- [ ] Subscribed-on-demand vs subscribed-immediate
- [ ] Cross-vCenter content sharing
- [ ] Tag categories and cardinality
- [ ] Tag-based VM Storage Policies
- [ ] Lab: create local content library, publish, subscribe from second vCenter

### Week 8: Practice Exams and Final Review

#### Day 50-52: Full practice exams
- [ ] Take a full 70-question practice exam (target: 70%+)
- [ ] Identify weak sections from results
- [ ] Re-read notes for the weakest two sections
- [ ] Take a second full practice exam (target: 75%+)

#### Day 53-54: Maximums and recall drilling
- [ ] Drill the configuration maximums table from `fact-sheet.md` until automatic
- [ ] Drill the VCSA sizing table
- [ ] Drill the license bundle contents (VCF vs VVF)
- [ ] Drill the esxtop counters and thresholds

#### Day 55-56: Final exam preparation
- [ ] Skim every notes file
- [ ] Re-read fact-sheet.md and strategy.md
- [ ] Take a third practice exam (target: 80%+)
- [ ] Review every wrong answer; understand why

#### Exam Day
- [ ] Verify ID and exam appointment
- [ ] Review configuration maximums one more time
- [ ] Read each question fully; flag uncertain ones (you can return)
- [ ] Use the full 135 minutes if needed
- [ ] Trust your hands-on time

## Daily Study Routine (1.5-2 hours/day)

### Recommended Schedule
1. **15 minutes**: Review yesterday's notes
2. **45 minutes**: New material from notes file
3. **30 minutes**: Hands-on lab practicing what you read
4. **15 minutes**: Practice questions on the day's topic

## Practice Exam Strategy

### Target Scores by Week
- [ ] Week 4: 60%+ on section-specific questions
- [ ] Week 5: 65%+ on mixed practice
- [ ] Week 6: 70%+ on mixed practice
- [ ] Week 7: 75%+ on full-length practice exams
- [ ] Week 8: 80%+ consistently before scheduling the real exam

## Study Resources

### Free
- **[VMware Hands-On Labs](https://labs.hol.vmware.com/)** - free browser-based vSphere environments
- **[VMware Configuration Maximums Tool](https://configmax.broadcom.com/)** - authoritative maximums
- **[VMware Compatibility Guide](https://www.vmware.com/resources/compatibility/search.php)** - HCL
- **[VMware Docs - vSphere 8](https://docs.vmware.com/en/VMware-vSphere/index.html)** - official docs
- **William Lam's blog** ([williamlam.com](https://williamlam.com/)) - automation, nested ESXi tips
- **Yellow Bricks** ([yellow-bricks.com](https://www.yellow-bricks.com/)) - Duncan Epping (HA/DRS book author)

### Paid
- **VMUG Advantage** ($200/year) - EVALExperience licenses for vSphere 8 Enterprise Plus, vSAN, NSX
- **Pluralsight VCP-DCV path** - video course covering exam blueprint
- **Hands-on Lab subscriptions** (Pluralsight, INE, CBT Nuggets)
- **VMware Learning Zone / Broadcom Learning** - official course recordings
- **VMware vSphere 8 Cookbook** by Abhilash GB - reference book

## Final Exam Checklist

### Content Preparation
- [ ] All six notes files reviewed at least twice
- [ ] Fact sheet maximums and esxtop counters memorized
- [ ] License bundles (VCF vs VVF) memorized
- [ ] Logs by component memorized
- [ ] vSAN OSA vs ESA differences clear
- [ ] HA, DRS, FT defaults memorized

### Logistics
- [ ] Authorized training course completed (first-time VCPs only)
- [ ] Pearson VUE account set up
- [ ] Exam scheduled at least 1 week out
- [ ] Valid ID ready
- [ ] Testing environment cleared if online proctoring (no second screens, clean desk)

### Exam Day Strategy
- [ ] Time management: 70 questions in 135 minutes = ~115 sec each (very comfortable)
- [ ] Read every option before selecting
- [ ] Flag uncertain questions and use the review screen at the end
- [ ] Watch for "by default" wording in scenarios
- [ ] Reject any answer mentioning VUM, PSC, or external Windows vCenter
