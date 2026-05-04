---
last-updated: 2026-05-03
---

# PCNSA - Practice Plan

A 4-week study plan for the Palo Alto Networks Certified Network Security Administrator (PCNSA) on PAN-OS 11.x. Pace assumes 5-7 hours per week. The exam has a heavy hands-on flavor; you cannot pass it cleanly by reading alone - you need a firewall to click through.

Prerequisite: a working Palo Alto Networks NGFW you can administer. Options:
- **VM-Series eval** (90 days) on AWS, Azure, GCP, ESXi, KVM, or Hyper-V
- **PA-200 / PA-220 / PA-410** lab firewall on eBay (~$100-200, fine for the GUI/CLI)
- A friend with admin access to a PAN-OS 11.x firewall in a non-production environment
- The official EDU-210 course lab

## Setup (week 0)

- [ ] Read [README.md](./README.md) and [fact-sheet.md](./fact-sheet.md)
- [ ] Spin up a PAN-OS 11.x firewall (VM-Series eval is easiest)
- [ ] Bookmark the [PAN-OS 11.1 admin guide](https://docs.paloaltonetworks.com/pan-os/11-1/pan-os-admin)
- [ ] Bookmark [LIVEcommunity](https://live.paloaltonetworks.com/) for real-world Q&A

## Week 1 - Portfolio + Architecture + Initial Config (Domain 1, 22%)

**Concepts:** Strata / Prisma / Cortex families, PA-Series form factors, single-pass parallel processing (SP3), management plane vs data plane, zones, virtual routers.

- [ ] Read fact-sheet "The Three IDs", "Single-Pass Parallel Processing", "Portfolio"
- [ ] Lab: bring a fresh PAN-OS firewall up; complete initial config (mgmt IP, hostname, DNS, NTP)
- [ ] Lab: create three zones (untrust, trust, dmz); create three virtual routers, observe routing isolation
- [ ] Lab: explore the GUI tabs (Dashboard, ACC, Monitor, Policies, Objects, Network, Device); know what each is for
- [ ] Practice: 20 questions on portfolio + architecture

## Week 2 - Networking + Connect Components (Domain 3, 30%)

**Concepts:** layer 3 vs layer 2 vs virtual-wire vs tap interfaces, sub-interfaces with VLAN tagging, NAT (source, destination, U-turn), policy-based forwarding (PBF), routing (static, BGP basics), HA active/passive.

- [ ] Lab: configure interfaces in all four modes; understand when to use each
- [ ] Lab: configure source NAT for outbound and destination NAT for inbound; verify with packet captures
- [ ] Lab: build a U-turn NAT scenario where an internal host reaches a published service via the firewall
- [ ] Lab: configure a static default route + a more-specific route; observe routing table
- [ ] Lab: bring up HA active/passive; trigger failover and watch state sync
- [ ] Practice: 25 questions on networking + NAT

## Week 3 - Manage and Configure NGFW (Domain 2, 30%)

**Concepts:** App-ID, User-ID (server monitoring, GlobalProtect, Captive Portal, syslog parsing, TS Agent), Content-ID (AV, Anti-Spyware, Vulnerability, URL filtering, file blocking, WildFire, data filtering), security profiles, security profile groups.

- [ ] Lab: enable User-ID via Server Monitoring on a Windows AD; verify users appear in `show user user-ids-allowed-from-monitor-ad`
- [ ] Lab: enable WildFire on a security profile; submit a test file through the firewall
- [ ] Lab: create a custom URL category with 5 sites; build a security profile that blocks it
- [ ] Lab: build a security profile group with all 7 profile types; attach to a policy rule
- [ ] Practice: 25 questions on App-ID + User-ID + Content-ID

## Week 4 - Security Policies + Profiles + Cumulative (Domain 4, 18%)

**Concepts:** security policy evaluation (top-down, first match), implicit deny, intra-zone vs inter-zone vs universal, application override, decryption policy basics, address objects + groups, service objects + groups.

- [ ] Lab: build a small ruleset with 5 rules; observe traffic logs; understand which rule a flow matched and why
- [ ] Lab: enable SSL forward-proxy decryption on a test endpoint; observe decrypted apps in App-ID
- [ ] Lab: use Application Override to force a flow to be classified as a different App-ID
- [ ] Lab: set up Application Filter and Application Group; understand the difference
- [ ] Practice: 30 questions covering all four domains
- [ ] Take 2 full-length practice exams (Boson, official, or community)
- [ ] Review every miss, map to domain, revisit relevant fact-sheet section
- [ ] Schedule the exam for late this week or early next

## Pass-day reminders

- Reading the question carefully matters more than knowing every PAN-OS feature - the exam often hides the answer in the wording
- "First match wins" - if a question shows multiple rules, find the FIRST one that matches and stop
- Implicit deny is intra-zone allow + inter-zone deny - know which way each implicit rule goes
- Application Override is rare in production but loved by exam writers; understand when it's needed (custom protocols on standard ports)
- For NAT questions, remember: NAT is evaluated, then security policy is evaluated against the **post-NAT** zones

## Tracking

| Week | Hours actual | Practice score | Confidence (1-5) |
|---|---|---|---|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |
| 4 |  |  |  |
