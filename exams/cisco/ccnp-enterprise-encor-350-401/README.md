# Cisco Certified Network Professional (CCNP) Enterprise - ENCOR 350-401

## Overview

The CCNP Enterprise certification is Cisco's professional-tier enterprise networking credential. To earn it, you must pass **two exams**: the **350-401 ENCOR** core exam (this guide) plus one **concentration exam** of your choice (ENARSI, ENSLD, ENWLSI, ENWLSD, ENAUTO, or SPCOR).

ENCOR 350-401 ("Implementing Cisco Enterprise Network Core Technologies") covers enterprise infrastructure, dual-stack architecture (IPv4/IPv6), virtualization, network assurance, security, and automation. It is also one of the qualifying exams for the **CCIE Enterprise Infrastructure** lab. Passing ENCOR alone is enough to earn the **Cisco Certified Specialist - Enterprise Core** badge.

This is a **professional-tier core exam**. Expect significantly more depth than CCNA - especially on OSPF (multi-area, LSAs, virtual links), BGP path selection, wireless RF behavior, programmability, and SD-Access / SD-WAN architectures.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | 350-401 (ENCOR) |
| **Full Name** | Implementing Cisco Enterprise Network Core Technologies |
| **Provider** | Cisco |
| **Tier** | Professional (core exam) |
| **Format** | Multiple choice + drag-and-drop + simulations + testlets |
| **Duration** | 120 minutes |
| **Questions** | ~90-110 |
| **Passing Score** | Cisco does not publish a fixed cut score; commonly cited target: 825/1000 |
| **Cost** | $400 USD |
| **Validity** | 3 years |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Prerequisites** | None formally; CCNA-level knowledge strongly recommended |
| **Earns** | Cisco Certified Specialist - Enterprise Core |
| **Counts toward** | CCNP Enterprise (with concentration), CCIE Enterprise Infrastructure |

**[Official ENCOR page](https://learningnetwork.cisco.com/s/encor-exam-topics)**
**[Cisco Learning Network CCNP Enterprise hub](https://learningnetwork.cisco.com/s/ccnp-enterprise)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Architecture | 15% |
| 2 | Virtualization | 10% |
| 3 | Infrastructure | 30% |
| 4 | Network Assurance | 10% |
| 5 | Security | 20% |
| 6 | Automation | 15% |

Infrastructure is the heaviest domain - routing, switching, wireless, and IP services together. Plan study time accordingly.

---

## Domain Summary

### 1 - Architecture (15%)

Enterprise design (2-tier vs 3-tier, fabric, spine-leaf), high availability (HSRP, VRRP, GLBP, SSO/NSF, StackWise, VSS), wireless deployment models (autonomous, centralized WLC, FlexConnect, cloud-managed/Meraki, embedded), Cisco SD-WAN architecture (vManage, vSmart, vBond, vEdge/cEdge), Cisco SD-Access / DNA Center (control plane, fabric edge, border, underlay/overlay), QoS components (classification, marking, queuing, policing, shaping), hardware/software switching (CEF, FIB, RIB, TCAM, control vs data plane).

### 2 - Virtualization (10%)

Device virtualization (hypervisors, VMs, containers, virtual switching, VRF-Lite, VDCs), data path virtualization (GRE, IPsec site-to-site, LISP, VXLAN with EVPN), network virtualization concepts.

### 3 - Infrastructure (30%)

Layer 2 (STP variants - PVST+, RPVST+, MST; EtherChannel - LACP/PAgP; trunking and VTP), Layer 3 (EIGRP, multi-area OSPFv2/v3 including LSA types and virtual links, eBGP single-AS basics with attributes and best-path selection), wireless (RF behavior, AP modes, antennas, FlexConnect, OEAP, location services), IP services (NAT/PAT, NTP, FHRPs in depth, IP multicast - PIM-SM, IGMP, RPs).

### 4 - Network Assurance (10%)

Diagnostic tools (ping, traceroute, debug, conditional debugging, SPAN/RSPAN/ERSPAN), NetFlow vs Flexible NetFlow vs IPFIX, IP SLA (operations, scheduling, reactions), syslog (severity levels, facilities, structured), SNMPv2c vs v3, Cisco DNA Center Assurance (telemetry, sensors, AI-driven insights), streaming telemetry (gNMI/gRPC, model-driven).

### 5 - Security (20%)

Device access control (line passwords, AAA - TACACS+/RADIUS, RBAC), infrastructure security (ACLs, CoPP, uRPF, DHCP snooping, DAI, IP source guard), wireless security (WPA2/WPA3, EAP variants, 802.1X with RADIUS, PSK vs Enterprise), Cisco TrustSec (SGT, SXP, SGACL), MACsec (802.1AE), management plane (SSH, NETCONF over SSH, REST API auth - tokens, OAuth, certificates).

### 6 - Automation (15%)

Data formats (JSON, XML, YAML), REST APIs (verbs, status codes, payloads, pagination, auth), Python (interpret existing scripts, construct REST calls with `requests`, work with JSON), configuration management (Ansible, Puppet, Chef - architecture and use cases), Cisco DNA Center APIs (intent API, command runner), NETCONF over SSH (port 830), RESTCONF over HTTPS, YANG data models (open vs Cisco-native), SDN concepts and Cisco SD-Access fabric.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | High-yield reference: routing metrics, QoS markings, IPv6, wireless, IOS commands, REST/Python |
| [notes/01-architecture.md](notes/01-architecture.md) | Enterprise design, SD-WAN, SD-Access, QoS, hardware/software switching |
| [notes/02-virtualization.md](notes/02-virtualization.md) | VRFs, VDCs, GRE, IPsec, LISP, VXLAN |
| [notes/03-infrastructure.md](notes/03-infrastructure.md) | STP, EtherChannel, EIGRP, OSPF, BGP, wireless, IP services |
| [notes/04-network-assurance.md](notes/04-network-assurance.md) | NetFlow, IP SLA, syslog, SNMP, DNA Center Assurance, streaming telemetry |
| [notes/05-security.md](notes/05-security.md) | AAA, CoPP, TrustSec, MACsec, WPA3, REST API security |
| [notes/06-automation.md](notes/06-automation.md) | JSON/XML/YAML, Python, Ansible, NETCONF/RESTCONF, YANG, DNA Center APIs |
| [practice-plan.md](practice-plan.md) | 14-18 week study plan |
| [scenarios.md](scenarios.md) | 15+ enterprise lab scenarios |
| [strategy.md](strategy.md) | Test-taking tactics and pitfalls |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Active CCNA + 2-3 years enterprise networking | 10-12 weeks |
| Recent CCNA, no production experience | 14-16 weeks |
| Older CCNA or self-taught networking | 16-18 weeks |
| No CCNA but strong networking background | 18-20 weeks |

Plan on 1.5-2 hours daily of theory plus 1-1.5 hours of hands-on lab.

---

## Lab Setup

ENCOR is **harder to lab than CCNA** because it covers technologies (VXLAN, EVPN, SD-WAN, DNA Center, MPLS) that Packet Tracer cannot simulate. You need real Cisco IOS images:

- **Cisco CML (Modeling Labs) Personal** - $199/year, official Cisco simulator with IOSv, IOS XE, IOS XR, NX-OS images. Best option for ENCOR.
- **EVE-NG Community / Pro** - free / $110/year, supports IOSv, vIOS-L2, CSR1000v, ASAv, and NX-OSv. You supply images.
- **GNS3** - free, similar to EVE-NG. Solid for routing/switching topics.
- **DevNet Sandbox** - free Cisco DevNet labs for DNA Center, IOS XE programmability, NETCONF/RESTCONF.
- **Cisco Modeling Labs Free Tier** - limited topology but free.

Avoid Packet Tracer for ENCOR - it does not support multi-area OSPF LSAs, BGP, MPLS, VRFs at the depth ENCOR tests.

---

## Companion Materials in This Repo

- **[CCNA 200-301](../ccna-200-301/)** - prerequisite-level foundation (subnetting, single-area OSPF, basic VLANs)
- **[Networking deep dives](../../../resources/networking-deep-dives/)** - hybrid connectivity, multi-cloud networking, BGP, DNS, load balancing
- **[AWS Advanced Networking ANS-C01](../../aws/specialty/advanced-networking-ans-c01/)** - cloud-side counterpart (Direct Connect, Transit Gateway, VPN, Route 53)
- **[GCP Cloud Network Engineer](../../gcp/cloud-network-engineer/)** - GCP networking (VPC, Cloud Interconnect, Cloud Router/BGP)

---

## Exam-Day Tips

1. **Time pressure is real.** ~90-110 questions in 120 minutes including 1-3 simulations. Budget 60-90 seconds per multiple-choice item; reserve 8-15 minutes for each sim.
2. **No back-button.** Like CCNA, ENCOR does not let you return to a question after submitting. Be sure before clicking Next.
3. **Sims are weighted heavily.** Practice multi-area OSPF, EtherChannel, BGP neighbor setup, and basic Python REST snippets in CML or EVE-NG until config is muscle memory.
4. **Read carefully on "best" answers.** ENCOR is notorious for multiple technically correct answers. Cisco wants the BEST per their design guides.
5. **OSPF LSA types and BGP attributes** show up repeatedly - memorize cold.
6. **Python and REST aren't optional.** Automation is 15% and you will see Python snippets to interpret. Practice reading `requests` library calls and JSON parsing.
7. **Wireless RF concepts** trip people up - know RSSI, SNR, channel reuse, and power output basics.
8. **Don't memorize show-command output verbatim**, but recognize what each command tells you (e.g., `show ip ospf database` shows LSAs by type; `show bgp ipv4 unicast` shows the BGP table).

---

## After ENCOR

To complete CCNP Enterprise, pass one concentration exam:

| Concentration | Code | Focus |
|---|---|---|
| Advanced Routing & Services | 300-410 ENARSI | Routing in depth (BGP, MPLS, VPN), troubleshooting |
| Network Design | 300-420 ENSLD | Enterprise design |
| Wireless Implementation | 300-430 ENWLSI | WLC/AP deployment |
| Wireless Design | 300-425 ENWLSD | RF and wireless design |
| Automation | 300-435 ENAUTO | Python, Ansible, DNA Center, model-driven programmability |
| SP Core | 350-501 SPCOR | Service provider track |

Common next steps after CCNP:

- **CCIE Enterprise Infrastructure** - 8-hour expert-level lab (ENCOR is your qualifying written)
- **Cloud networking specialties** - AWS Advanced Networking, Azure Network Engineer, GCP Cloud Network Engineer
- **Adjacent stack** - DevNet Professional (300-435 ENAUTO crosses both), Juniper JNCIP, vendor security certs
