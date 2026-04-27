# Cisco Certified Network Associate (CCNA) - 200-301

## Overview

The CCNA (200-301) is the industry-standard entry-level networking certification. It validates fundamental knowledge of network engineering: IP services, network access (switching, VLANs), IP connectivity (routing), security fundamentals, and network automation / programmability.

Despite the rise of cloud, CCNA remains relevant because cloud networking still depends on the same underlying protocols (TCP/IP, BGP, OSPF, VLANs, NAT, ACLs). Cloud engineers, SREs, and platform engineers benefit from CCNA-depth networking knowledge.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | 200-301 (CCNA) |
| **Full Name** | Cisco Certified Network Associate |
| **Provider** | Cisco |
| **Format** | Multiple choice + drag-and-drop + simulation lab items |
| **Duration** | 120 minutes |
| **Questions** | ~100-120 |
| **Passing Score** | Cisco does not publish a fixed cut score; commonly cited target: 825/1000 |
| **Cost** | $300 USD |
| **Validity** | 3 years |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Prerequisites** | None formally |

**[📖 Official CCNA page](https://learningnetwork.cisco.com/s/ccna)**
**[📖 200-301 Exam Topics](https://learningnetwork.cisco.com/s/ccna-exam-topics)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Network Fundamentals | 20% |
| 2 | Network Access | 20% |
| 3 | IP Connectivity | 25% |
| 4 | IP Services | 10% |
| 5 | Security Fundamentals | 15% |
| 6 | Automation and Programmability | 10% |

---

## Domain Summary

### 1 - Network Fundamentals (20%)

OSI model, TCP/IP stack, network topologies, cable types, IPv4 / IPv6 addressing and subnetting, wireless basics, virtualization concepts (VMs, containers, switches in the cloud).

### 2 - Network Access (20%)

VLANs and trunking (802.1Q), Spanning Tree Protocol (STP, RSTP), EtherChannel (LACP, PAgP), wireless architecture (WLC, autonomous APs, lightweight APs), Layer 2 discovery (CDP, LLDP).

### 3 - IP Connectivity (25%)

Routing fundamentals, static routing, OSPFv2 single-area, default routes, first-hop redundancy (HSRP, VRRP, GLBP at concept level).

### 4 - IP Services (10%)

NAT (static, dynamic, PAT), NTP, DHCP, DNS, SNMP, Syslog, QoS basics, SSH for management.

### 5 - Security Fundamentals (15%)

Access lists (standard, extended, named), port security, AAA (TACACS+, RADIUS), security program elements (user awareness, training, physical security), VPN concepts (site-to-site, remote access), wireless security (WPA2, WPA3, 802.1X).

### 6 - Automation and Programmability (10%)

REST APIs, JSON, SDN (controller-based vs traditional), Cisco DNA Center, Ansible / Puppet / Chef concepts, configuration management at high level.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Reference with subnetting tables, command reference, and high-yield facts |
| [notes/01-network-fundamentals.md](notes/01-network-fundamentals.md) | OSI, TCP/IP, addressing, subnetting |
| [notes/02-network-access-vlans.md](notes/02-network-access-vlans.md) | VLANs, trunking, STP, EtherChannel |
| [notes/03-ip-connectivity-routing.md](notes/03-ip-connectivity-routing.md) | Static routing, OSPF, FHRP |
| [notes/04-services-security.md](notes/04-services-security.md) | NAT, DHCP, DNS, ACLs, port security, AAA |
| [notes/05-automation-programmability.md](notes/05-automation-programmability.md) | REST, JSON, SDN, Ansible |
| [practice-plan.md](practice-plan.md) | 12-week study plan |
| [scenarios.md](scenarios.md) | 15 lab/simulation scenarios |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Networking experience (5+ years), no Cisco | 6-8 weeks |
| Some networking knowledge, no Cisco | 10-12 weeks |
| New to networking | 14-18 weeks |

Plan on 1-2 hours daily of theory plus 1 hour of hands-on lab.

---

## Lab Setup

You **cannot pass CCNA without hands-on practice**. Free / cheap options:

- **Cisco Packet Tracer** (free, requires Cisco Networking Academy account) - simulator covering most CCNA topics
- **GNS3** (free) - run real Cisco IOS images (you supply licensed images)
- **EVE-NG Community** (free) - similar to GNS3, web-based

For physical labs, used Cisco 2900 / 3500 series switches and 1900 / 2900 series routers are inexpensive on the secondary market but unnecessary for exam prep.

---

## Companion Materials in This Repo

- **[Networking deep dives](../../../resources/networking-deep-dives/)** - hybrid connectivity, multi-cloud networking, DNS, load balancing
- **[AWS Advanced Networking ANS-C01](../../aws/specialty/advanced-networking-ans-c01/)** - AWS counterpart
- **[GCP Cloud Network Engineer](../../gcp/cloud-network-engineer/)** - GCP counterpart

---

## Exam-Day Tips

1. **Subnetting must be automatic.** Practice until you can subnet IPv4 (/24, /23, /22, /28, /30) in under 30 seconds without paper. The exam doesn't give you a calculator.
2. **Simulations are weighted heavily.** Cisco includes simulation labs that take 8-15 minutes each. Practice in Packet Tracer until config is muscle memory.
3. **Watch for "best" answers.** Some multi-choice questions have multiple working answers; Cisco wants the BEST.
4. **Memorize port numbers**: SSH 22, Telnet 23, DNS 53, DHCP 67/68, HTTP 80, HTTPS 443, SNMP 161/162, Syslog 514, NTP 123.
5. **Time management.** ~120 minutes for ~110 items including labs. Budget 8-12 minutes for each lab.
6. **You cannot return to a question** in the CCNA exam once you submit it. Be sure before clicking Next.

---

## After CCNA

Common next steps:

- **CCNP Enterprise (350-401 ENCOR + concentration)** - professional-tier, broader and deeper
- **CCNP Security, Data Center, Service Provider, Collaboration**
- **CCIE Enterprise** - expert-tier (8-hour lab exam, hardcore)
- **AWS Advanced Networking Specialty** - cloud networking
- **Juniper JNCIA / JNCIS** - vendor-neutral networking parallel
