# CompTIA Network+ (N10-009)

## Overview

The CompTIA Network+ (N10-009) certification validates the core skills required to design, configure, manage, and troubleshoot wired and wireless networks. It is a vendor-neutral cert recognized as the industry standard for entry-level networking professionals and is approved by the US Department of Defense to meet directive 8140 / 8570.01-M baseline requirements.

The N10-009 version (released June 2024) modernizes the previous N10-008 by deepening cloud, SDN/SD-WAN, IPv6, and zero-trust networking content. It remains valid until CompTIA retires the version (typically 3 years after release).

## Quick Reference

| Item | Detail |
|------|--------|
| **Exam Code** | N10-009 |
| **Duration** | 90 minutes |
| **Questions** | Up to 90 (MCQ + performance-based) |
| **Passing Score** | 720 / 900 |
| **Cost** | $369 USD |
| **Languages** | English (additional languages roll out post-launch) |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Validity** | 3 years (renewable via CE program) |
| **Prerequisites** | None required (CompTIA A+ and 9-12 months networking experience recommended) |

## Exam Domains

| Domain | Topic | Weight |
|--------|-------|--------|
| 1.0 | Networking Concepts | 23% |
| 2.0 | Network Implementation | 20% |
| 3.0 | Network Operations | 19% |
| 4.0 | Network Security | 14% |
| 5.0 | Network Troubleshooting | 24% |

## Domain Summary

### Domain 1: Networking Concepts (23%)
OSI model layers and PDUs, encapsulation/decapsulation, common ports and protocols (TCP/UDP), traffic types, IPv4 and IPv6 addressing, public vs private IPv4, subnetting (VLSM, CIDR), network types and topologies (star, mesh, hybrid, point-to-point), service models (IaaS, PaaS, SaaS), cloud connectivity, network services (DHCP, DNS, NTP, SNMP), and the role of fundamental devices (routers, switches, firewalls, load balancers, proxies, IDS/IPS).

### Domain 2: Network Implementation (20%)
Routing technologies (static vs dynamic, OSPF, BGP, EIGRP, RIP), administrative distance, switching (VLANs, trunking 802.1Q, STP/RSTP, link aggregation LACP, port security, jumbo frames, MTU), wireless standards (802.11a/b/g/n/ac/ax/be) and security (WPA2, WPA3, 802.1X, EAP), wireless deployment (channel planning, antenna types, controllers), and physical installation (racks, cable management, PoE, environmental factors).

### Domain 3: Network Operations (19%)
Documentation (logical/physical diagrams, IP address management, baseline configurations, asset inventories, audits), monitoring (SNMP, NetFlow, syslog, SIEM), performance metrics (latency, jitter, throughput, packet loss), disaster recovery (RTO, RPO, MTBF, MTTR), high availability (active/active, active/passive, clustering, NIC teaming), and organizational documents (SLA, MOU, NDA, AUP, BYOD, SOP, change management).

### Domain 4: Network Security (14%)
CIA triad applied to networking, common attacks (DoS/DDoS, ARP poisoning, DNS poisoning, on-path/MITM, VLAN hopping, evil twin, deauthentication), security devices and protocols (NGFW, IDS/IPS, NAC, IPsec, TLS, SSH), authentication (RADIUS, TACACS+, Kerberos, LDAP, SAML, EAP variants), network hardening (port security, DHCP snooping, dynamic ARP inspection, BPDU guard, root guard), and physical security.

### Domain 5: Network Troubleshooting (24%)
The CompTIA 7-step troubleshooting methodology, command-line tools (ping, tracert/traceroute, nslookup/dig, ipconfig/ifconfig/ip, netstat/ss, arp, route, nmap, tcpdump, pathping, iperf), hardware tools (cable tester, tone generator, OTDR, multimeter, loopback adapter, Wi-Fi analyzer), and patterns for diagnosing cabling, connectivity, performance, wireless, routing, switching, DNS, DHCP, and security issues.

## Study Materials

### Notes
- [01 - Networking Concepts](notes/01-networking-concepts.md) - OSI model, ports/protocols, IP addressing, subnetting, services, topologies
- [02 - Network Implementation](notes/02-network-implementation.md) - Routing, switching, VLANs, STP, wireless standards/security
- [03 - Network Operations](notes/03-network-operations.md) - Documentation, monitoring, DR/BCP, organizational documents
- [04 - Network Security](notes/04-network-security.md) - Threats, hardening, security devices, authentication, physical security
- [05 - Network Troubleshooting](notes/05-network-troubleshooting.md) - Methodology, CLI tools, hardware tools, common issue patterns

### Study Resources
- [Fact Sheet](fact-sheet.md) - Port numbers, subnetting tables, cable specs, command reference
- [Practice Plan](practice-plan.md) - Structured 6-week study schedule
- [Scenarios](scenarios.md) - Troubleshooting and lab scenarios
- [Strategy](strategy.md) - Exam-day strategy and PBQ approach

## Recommended Study Time

| Background | Estimated Hours | Calendar Time |
|------------|-----------------|---------------|
| New to networking (no A+) | 120-160 hours | 10-14 weeks |
| Have A+ or 6 months IT exposure | 80-120 hours | 6-10 weeks |
| 1+ year of helpdesk / sysadmin work | 60-80 hours | 4-6 weeks |
| Active network admin / CCNA candidate | 30-50 hours | 2-4 weeks |

Plan for 2-3 hours per weekday plus a longer weekend block. Schedule the exam at week 5 to create a deadline.

## Lab Setup

Network+ is a hands-on exam. The PBQs lean heavily on subnetting, configuring switches/routers, wireless setup, and troubleshooting symptoms. Build at least one of these labs:

- **Free virtual labs** - Cisco Packet Tracer (free with Networking Academy account), GNS3, EVE-NG community edition
- **Cheap home lab** - Used Cisco 2960 switch + 2911 router on eBay (~$60), or MikroTik hAP for full routing/firewall practice
- **Cloud labs** - AWS VPC free tier (subnets, route tables, security groups, NACLs, VPN), Azure free tier
- **Wireless** - Any modern home router exposes WPA2/WPA3, channel selection, and 2.4/5/6 GHz bands
- **Linux networking** - WSL2 or a small VM to practice ip, ss, tcpdump, dig, nmap, iperf3

Spend at least 15-20 hours in a lab. Subnetting and troubleshooting questions are much easier after you have actually configured the things.

## Companion Materials

- **[CompTIA Security+ (SY0-701)](../security-plus/README.md)** - Direct follow-on cert. Network security overlaps heavily; many candidates take Net+ then Sec+ within the same year.
- **[AWS Advanced Networking - Specialty (ANS-C01)](../../aws/specialty/advanced-networking/README.md)** - Cloud networking deep dive. Network+ subnetting, BGP, and VPN concepts are direct prerequisites in spirit.
- **[Cisco CCNA (200-301)](../../cisco/ccna/README.md)** - Vendor-specific deeper dive into routing/switching. CCNA covers everything in Network+ plus Cisco IOS configuration. Many people study them in parallel.
- **[GCP Professional Cloud Network Engineer](../../gcp/professional/cloud-network-engineer/README.md)** - GCP analogue to AWS ANS. Useful if your stack is on Google Cloud.

## Exam-Day Tips

- **Subnetting cheat sheet from memory** - Use the first 2 minutes of the exam to dump powers of 2, the /24 - /30 host counts, and the magic-number table on the scratch pad before touching any questions.
- **Read the scenario twice on PBQs** - PBQs cost 3-5 minutes each. Identify what is being asked (which port to open, which VLAN to assign, which cable type) before clicking anything.
- **Skip and flag** - If a question takes more than ~75 seconds, flag and move on. Come back at the end.
- **Watch for "BEST" vs "FIRST" vs "MOST LIKELY"** - These keywords change the right answer. "First step" almost always means a non-destructive verification (ping, check link lights, verify physical layer).
- **Layer 1 first** - When troubleshooting questions say "user cannot connect," the answer is usually a Layer 1 (cable, port, link light) or Layer 2 (VLAN, MAC) issue, not a routing problem. Apply OSI bottom-up unless the symptoms point higher.
- **Eliminate clearly wrong answers** - You can usually drop 2 of 4 options immediately; pick best of remaining two.

## After This Cert

### Career Paths
- Junior Network Administrator
- Network Technician
- Helpdesk / Tier 2 Support (with networking focus)
- NOC Analyst
- Junior Systems Administrator
- Field Service Technician
- Cable / Infrastructure Installer

### Recommended Next Certifications
- **CompTIA Security+ (SY0-701)** - Same vendor, security focus, often paired
- **Cisco CCNA (200-301)** - Vendor-specific routing/switching depth
- **CompTIA CySA+** - Cybersecurity analyst (if security is your direction)
- **AWS Certified Solutions Architect - Associate** - Cloud entry point
- **Juniper JNCIA-Junos** - Alternative to CCNA for Juniper shops
- **CompTIA Cloud+** - Vendor-neutral cloud follow-on

---

**Good luck with your CompTIA Network+ certification!** This is the cert that turns "I know how computers connect" into "I can read a packet capture and explain why the printer in VLAN 30 can't reach the file server in VLAN 50." It is the foundation that makes every other infrastructure cert easier.
