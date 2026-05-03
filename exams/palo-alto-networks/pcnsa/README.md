# Palo Alto Networks Certified Network Security Administrator (PCNSA)

## Overview

The PCNSA validates day-to-day administrator skill on Palo Alto Networks next-generation firewalls (NGFW) running PAN-OS 11.x. It covers NGFW configuration, network connectivity, policy authoring, and the basics of the Palo Alto Networks portfolio. It is the first role-based certification in the Strata (network security) track and assumes you can operate the GUI, CLI, and API of a single firewall.

Unlike legacy port-based firewalls, Palo Alto Networks NGFWs classify traffic with App-ID (application), User-ID (user), and Content-ID (content). Most of the exam revolves around how those work together with security policy, security profiles, and zones to enforce a Zero Trust posture.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | PCNSA |
| **Full Name** | Palo Alto Networks Certified Network Security Administrator |
| **PAN-OS Version** | 11.x (currently aligned to 11.0/11.1) |
| **Format** | Multiple choice and scenario-based |
| **Duration** | 80 minutes |
| **Questions** | 60 |
| **Passing Score** | ~70% (Palo Alto Networks does not publish exact cut score; ~42 of 60 typical) |
| **Cost** | $155 USD |
| **Validity** | 2 years |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Prerequisites** | None formally; PCCET or basic networking recommended |
| **Recommended Course** | EDU-210 Firewall Essentials: Configuration and Management |

**[Official PCNSA page](https://www.paloaltonetworks.com/services/education/certification/pcnsa)**
**[PAN-OS TechDocs](https://docs.paloaltonetworks.com/pan-os)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Palo Alto Networks Portfolio and Architecture | 22% |
| 2 | Manage and Configure Palo Alto Networks NGFW | 30% |
| 3 | Connect Palo Alto Networks NGFWs to Production Networks | 30% |
| 4 | Manage and Configure Security Policies and Profiles | 18% |

---

## Domain Summary

### 1 - Palo Alto Networks Portfolio and Architecture (22%)

Strata (NGFW, Panorama), Prisma (Cloud, Access, SD-WAN, SASE), Cortex (XDR, XSOAR, XSIAM, Data Lake). Single-pass parallel processing (SP3) architecture: traffic is parsed once, classified by App-ID, User-ID, Content-ID, then policy and profiles run in parallel. Zero Trust principles applied at the firewall: never trust, always verify, assume breach.

### 2 - Manage and Configure NGFW Devices (30%)

PAN-OS administration: GUI, CLI, XML API, REST API. Initial config wizard, MGT interface, role-based admin accounts, authentication profiles. Dynamic updates: Applications, Applications and Threats, Antivirus, WildFire, URL filtering. Software updates and content versions. Panorama for centralized management of multiple firewalls (device groups, templates, log collectors). High availability: active/passive (default) and active/active with HA1 (control), HA2 (state sync), HA3 (packet forwarding for active/active). Licensing: Threat Prevention, WildFire, URL Filtering (Advanced URL Filtering), DNS Security, GlobalProtect, SD-WAN, IoT Security.

### 3 - Connect Network Components (30%)

Interface types: Layer 3, Layer 2, Virtual Wire (vwire), Tap, HA, Aggregate Ethernet (AE), Loopback, Tunnel, VLAN. Security Zones (intrazone vs interzone), Virtual Routers (multiple per device for routing isolation), Virtual Systems (vsys, multi-tenant). Static routing, dynamic routing (OSPF, BGP, RIP intro), policy-based forwarding (PBF). DHCP server / relay / client. NAT: source NAT (dynamic IP, dynamic IP and port aka PAT, static IP), destination NAT (port forwarding), U-turn NAT (intrazone NAT for hairpin traffic). NAT rule fields: original packet (source/dest zones, source/dest addresses, service) and translated packet (source/dest translation).

### 4 - Manage and Configure Security Policies (18%)

Security policy rules with rule types intrazone, interzone, universal (default for new rules). Match criteria: source zone/address/user, destination zone/address, application, service/URL category, HIP profile (with GlobalProtect). App-ID classifies the application regardless of port. User-ID maps usernames to IPs (User-ID agent, Server Monitoring, syslog parsing, Captive Portal, GlobalProtect, XML API). Content-ID provides threat prevention via security profiles: Antivirus, Anti-Spyware, Vulnerability Protection, URL Filtering, File Blocking, WildFire Analysis, Data Filtering, DoS Protection. Profile groups bundle profiles into a single attachment. Policy evaluation: top-down, first match wins, with implicit intrazone-default (allow) and interzone-default (deny). Log forwarding profile sends Traffic, Threat, URL, Data, WildFire, GlobalProtect, Auth, Tunnel logs to Panorama, syslog, SNMP, email, or HTTP.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Quick reference - App-ID/User-ID/Content-ID, NAT types, CLI cheat sheet, security profile reference |
| [notes/01-portfolio-architecture.md](notes/01-portfolio-architecture.md) | Strata/Prisma/Cortex, SP3 architecture, Zero Trust |
| [notes/02-manage-configure-ngfw.md](notes/02-manage-configure-ngfw.md) | PAN-OS admin, Panorama, dynamic updates, HA, licensing |
| [notes/03-connect-network-components.md](notes/03-connect-network-components.md) | Interfaces, zones, VRs, NAT, routing, DHCP |
| [notes/04-security-policies.md](notes/04-security-policies.md) | Policy rules, App-ID, User-ID, security profiles, log forwarding |
| [practice-plan.md](practice-plan.md) | 8-week study plan |
| [scenarios.md](scenarios.md) | 14 firewall configuration and troubleshooting scenarios |
| [strategy.md](strategy.md) | Exam-day strategy and common pitfalls |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Existing NGFW admin (Cisco ASA/FTD, Fortinet, Check Point) | 3-4 weeks |
| General networking / Security+ / CCNA holder | 5-6 weeks |
| New to firewalls and networking | 8-10 weeks |

Plan 1-1.5 hours daily of theory plus 30-60 minutes hands-on in a VM lab.

---

## Lab Setup

You can pass PCNSA without a paid license, but you will absolutely need hands-on time:

- **Free PAN-OS VM trial** - request a 30-day evaluation through your Palo Alto Networks partner or [Palo Alto Networks support portal](https://support.paloaltonetworks.com/) for VM-50 or VM-100
- **AWS Marketplace VM-Series BYOL** - hourly billing if you have AWS credit
- **Palo Alto Networks LIVEcommunity sandbox** - occasional free time-limited access
- **Beacon EDU-210 lab** - included with the official course

GUI is at `https://<mgt-ip>` (default `192.168.1.1`, admin/admin). CLI access via SSH on the same management IP.

---

## Companion Materials in This Repo

- **[CompTIA Security+](../../comptia/security-plus/)** - foundational security concepts that map directly to Palo Alto features (zero trust, defense in depth, IDS/IPS)
- **[Cisco CCNA 200-301](../../cisco/ccna-200-301/)** - networking fundamentals required to operate any firewall (subnetting, routing, VLANs, NAT)
- **[AWS Security Specialty](../../aws/specialty/security-specialty/)** - cloud security parallels to Prisma Cloud and VM-Series in AWS
- **[Cloud Security Alliance CCSK](../../cloud-security-alliance/ccsk/)** - vendor-neutral cloud security knowledge that complements Prisma certifications

---

## Exam-Day Tips

1. **App-ID is everything.** If a question mentions ports, services, or "block port 443," ask yourself if App-ID would classify it differently. The PAN-OS philosophy is that ports lie - applications do not.
2. **Know rule type defaults.** New rules default to `universal` (matches both intrazone and interzone traffic). Implicit defaults: intrazone-default = allow, interzone-default = deny. Both are logged only if you override and enable logging.
3. **NAT rules use pre-NAT zones, post-NAT addresses.** Security policy then matches on the post-NAT zone but pre-NAT IP for destination NAT. This trips up most candidates.
4. **First match wins.** Security policies are evaluated top-down. Move specific rules above general rules.
5. **Read the question for the rule TYPE.** "User downloaded a malicious PDF" = WildFire / File Blocking / Antivirus, not URL filtering. "Phishing site" = URL filtering / DNS Security.
6. **Time management.** 60 questions in 80 minutes = ~80 seconds per question. Flag and move on; come back to scenarios at the end.
7. **You CAN return to flagged questions.** Unlike CCNA, PCNSA lets you review and change answers before submission.

---

## After PCNSA

Common next steps:

- **PCNSE** - the engineer-level certification, deeper in HA, GlobalProtect, decryption, troubleshooting, and Panorama
- **PCCSE** - Prisma Cloud (CSPM, CWP) for cloud security focus
- **Prisma Access SASE Engineer** - SASE design and ZTNA
- **Cortex XSIAM / XSOAR** - SOC and automation tracks
- **AWS Security Specialty** - parallel cloud security certification
