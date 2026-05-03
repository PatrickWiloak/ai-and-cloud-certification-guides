# VMware Certified Professional - Data Center Virtualization 2024 (VCP-DCV, 2V0-21.23)

## Overview

The VCP-DCV certification validates skills in installing, configuring, managing, and troubleshooting a VMware vSphere 8 environment. It is the flagship VMware infrastructure certification and the de facto standard for virtualization and private-cloud admins.

VCP-DCV remains relevant in 2026 even after the Broadcom acquisition: the vSphere stack is still the dominant on-prem hypervisor in the Fortune 500, VMware Cloud Foundation (VCF) is the primary product bundle, and large enterprises run VCF on AWS, Azure, Google Cloud, and Oracle Cloud as the standard re-host path for legacy workloads. Anyone running a private cloud, hybrid platform, or VMware Cloud on AWS environment benefits from VCP-DCV-depth knowledge.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | 2V0-21.23 |
| **Full Name** | VMware vSphere 8.x Professional |
| **Certification Awarded** | VMware Certified Professional - Data Center Virtualization 2024 |
| **Provider** | VMware (Broadcom) |
| **Format** | Multiple choice, single and multiple answer |
| **Duration** | 135 minutes (includes 30 min for non-native English) |
| **Questions** | 70 |
| **Passing Score** | 300 (scaled 100-500) |
| **Cost** | $250 USD |
| **Validity** | No expiration since 2019 (recertification optional) |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Prerequisites** | None formally; VMware Training course required for first-time VCPs |

**[Official VCP-DCV 2024 page](https://www.vmware.com/learning/certification/vcp-dcv.html)**
**[2V0-21.23 Exam Guide PDF](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/certification/vmw-vcp-dcv-2024-exam-prep-guide.pdf)**

> **Note on training requirement.** VMware (and now Broadcom) requires that first-time VCP candidates complete an authorized training course before being eligible to sit the exam. Existing VCP holders renewing or upgrading do not need it. Authorized courses include "VMware vSphere: Install, Configure, Manage [V8]" (ICM) and "VMware vSphere: Optimize and Scale [V8]". This requirement adds $4,000-5,000 to total certification cost.

---

## Exam Sections

The 2V0-21.23 blueprint defines seven sections. Sections 3 and 4 (planning/designing and installation) are weighted more heavily on the exam. Section 3 is listed by VMware as not scored separately but is covered in the question pool.

| # | Section | Weight |
|---|---|---|
| 1 | IT Architectures, Technologies, Standards | low |
| 2 | VMware Solution | medium |
| 3 | Planning and Designing (not scored) | n/a |
| 4 | Installation, Configuring, Setup | high |
| 5 | Performance-Tuning, Optimization, Upgrades | medium-high |
| 6 | Troubleshooting and Repairing | medium |
| 7 | Administrative and Operational Tasks | high |

---

## Section Summary

### 1 - IT Architectures, Technologies, Standards

vSphere licensing tiers and editions, the move to subscription bundles (VCF, VVF), what each bundle includes, hardware compatibility (HCL/VCG), virtualization concepts, supported guest OS list.

### 2 - VMware Solution

Core components: ESXi hypervisor, vCenter Server (VCSA), vSphere Distributed Switch (vDS), vSAN, vMotion, Storage vMotion, HA, DRS, FT, vSphere Replication, Lifecycle Manager (vLCM). How they fit together in a cluster.

### 3 - Planning and Designing

Compute, storage, network sizing. Cluster sizing rules (max 96 hosts in vSAN cluster, 128 in non-vSAN). vCenter sizing (Tiny / Small / Medium / Large / X-Large). Topology decisions (Enhanced Linked Mode, single vs multi-vCenter SSO).

### 4 - Installation, Configuring, Setup

ESXi installation (interactive, scripted, Auto Deploy, vLCM image-based). vCenter Server Appliance (VCSA) deployment. Datacenter and cluster creation. vSwitch and vDS configuration. VMFS, NFS, vSAN, vVols datastore creation. VM provisioning, OVF/OVA deployment, VM hardware versions.

### 5 - Performance-Tuning, Optimization, Upgrades

Resource pools (shares, limits, reservations). DRS automation modes and migration thresholds. Storage DRS. vMotion/sVMotion network tuning. CPU/memory hot-add. Lifecycle Manager baselines and image management. Patching and upgrades. esxtop counters for performance triage.

### 6 - Troubleshooting and Repairing

Logs (vmkernel.log, hostd.log, vpxa.log, vpxd.log). esxcli for host triage. vmkfstools for VMFS/VMDK ops. Common failure modes: APD, PDL, isolated host, HA failures, vMotion failures, datastore latency.

### 7 - Administrative and Operational Tasks

VM lifecycle (power, snapshot, clone, template, content library). Permissions and roles (RBAC), vCenter SSO domains, identity sources. Tags and categories. Backup strategy and VM-level snapshots. Host maintenance mode, evacuation, cluster expansion.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | vSphere 8 maximums, esxcli/PowerCLI cheat sheet, license tiers |
| [notes/01-architecture-technologies.md](notes/01-architecture-technologies.md) | Section 1 - virtualization, licensing, editions, HCL |
| [notes/02-vmware-solution.md](notes/02-vmware-solution.md) | Section 2 - vCenter, ESXi, vDS, vSAN, vMotion, HA, DRS, FT |
| [notes/03-installation-configuration.md](notes/03-installation-configuration.md) | Section 4 - ESXi install, VCSA, networking, storage, VM creation |
| [notes/04-performance-optimization-upgrades.md](notes/04-performance-optimization-upgrades.md) | Section 5 - resource pools, DRS, vLCM, performance tuning |
| [notes/05-troubleshooting-repairing.md](notes/05-troubleshooting-repairing.md) | Section 6 - logs, esxtop, common failures |
| [notes/06-administrative-operational-tasks.md](notes/06-administrative-operational-tasks.md) | Section 7 - VMs, snapshots, content library, RBAC, tags |
| [practice-plan.md](practice-plan.md) | 8-week structured study schedule |
| [scenarios.md](scenarios.md) | 15 vSphere admin and troubleshooting scenarios |
| [strategy.md](strategy.md) | Exam-day tactics and time management |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Current VMware admin (1+ year vSphere) | 4-6 weeks |
| Adjacent virtualization (Hyper-V, KVM, Nutanix) | 6-8 weeks |
| General sysadmin, no virt experience | 10-14 weeks |

Plan on 1.5-2 hours daily of theory plus 30-60 minutes of hands-on lab work in a nested ESXi environment.

---

## Lab Setup

You cannot pass VCP-DCV without hands-on time. Options ranked from cheapest to most realistic:

- **VMware Hands-On Labs (HOL)** - free, browser-based, full vSphere environments. Best starting point. [labs.hol.vmware.com](https://labs.hol.vmware.com/)
- **Nested ESXi on VMware Workstation Pro** - run ESXi as a VM on a Windows/Linux host. Requires 32 GB RAM minimum, 64 GB recommended. Workstation Pro is now free for personal use as of late 2024.
- **Nested ESXi on a homelab** - dedicated machine (Intel NUC, used Dell R730, mini PC with 64-128 GB RAM). Closest to production feel.
- **VMUG Advantage subscription** - $200/year, gets you EVALExperience licenses for vSphere 8 Enterprise Plus, vSAN, NSX, Aria, and more. Best value if you plan to lab seriously. [vmug.com/membership/vmug-advantage](https://www.vmug.com/membership/vmug-advantage/)

---

## Companion Materials in This Repo

- **[AWS Solutions Architect Associate](../../aws/associate/solutions-architect-associate/)** - VMware Cloud on AWS context, hybrid migration patterns
- **[Azure Administrator AZ-104](../../azure/administrator-az-104/)** - Azure VMware Solution as the hyperscale equivalent
- **[Kubernetes CKA](../../kubernetes/cka/)** - vSphere with Tanzu (TKG) is the Kubernetes side of vSphere
- **[HashiCorp Terraform Associate](../../hashicorp/terraform-associate/)** - Terraform vSphere provider for IaC of vSphere environments
- **[Cisco CCNA](../../cisco/ccna-200-301/)** - vSwitch / vDS networking concepts overlap with physical networking

---

## Exam-Day Tips

1. **Know the maximums.** Several questions are pure recall: max vCPU per VM (768), max RAM per VM (24 TB), max hosts per cluster (96 vSAN, 128 non-vSAN), max VMs per host (1024). See [fact-sheet.md](fact-sheet.md).
2. **Subscription bundles matter.** Post-Broadcom, VMware sells VCF (VMware Cloud Foundation) and VVF (vSphere Foundation) as the main SKUs. Standalone vSphere Standard is still available but de-emphasized. Be ready to identify which features come with which bundle.
3. **vLCM, not Update Manager.** VMware Update Manager (VUM) was retired with vSphere 7. Lifecycle Manager (vLCM) replaced it. If an answer says "VUM", it is wrong.
4. **Watch for "by default" wording.** DRS default automation level is Fully Automated; HA admission control default is "Cluster resource percentage"; default vMotion network is 1 GbE but 10 GbE+ is recommended.
5. **Time management.** 70 questions in 135 minutes = ~115 seconds per question. Generous. No need to rush. Flag and review.
6. **You CAN return to questions** in the VCP-DCV exam. Use the review screen.

---

## After VCP-DCV

Common next steps:

- **VCAP-DCV Design (3V0-21.23)** - advanced design certification
- **VCAP-DCV Deploy** - lab-based advanced deployment exam
- **VCDX-DCV** - expert-tier, design defense, the hardest VMware cert
- **VCP-NV (NSX)** - network virtualization specialization
- **VMware Cloud Foundation Specialist** - VCF-focused exam tied to current bundling
- **AWS Advanced Networking + VMware Cloud on AWS** - hybrid cloud focus
