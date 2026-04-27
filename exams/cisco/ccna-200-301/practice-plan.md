# CCNA (200-301) - 12-Week Practice Plan

This plan assumes 1.5-2 hours of theory + 1 hour of hands-on lab per day. Adjust if you have less or more networking background.

The single biggest factor in passing CCNA is **subnetting fluency** + **simulator hands-on time**.

---

## Lab setup (do this in week 1, day 1)

- [ ] Install **Cisco Packet Tracer** (free, requires Cisco Networking Academy account)
- [ ] Optional: **GNS3** or **EVE-NG** if you have Cisco IOS images
- [ ] Build a baseline topology: 2 routers, 2 L3 switches, 2 L2 switches, 4 end hosts
- [ ] Save it as your default starting topology - load fresh each lab session

---

## Week 1 - Networking Fundamentals + Subnetting

### Reading
- [ ] [README.md](./README.md), [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-network-fundamentals.md](./notes/01-network-fundamentals.md) deep read
- [ ] OSI vs TCP/IP layers cold

### Hands-on
- [ ] In Packet Tracer: build a single-subnet network with two PCs and a switch; ping
- [ ] Add a router; configure interfaces; ping across router
- [ ] Practice console / SSH into devices

### Subnetting drills
- [ ] Daily 30-minute subnetting practice
- [ ] [subnettingpractice.com](https://subnettingpractice.com) or printed worksheets
- [ ] Goal: do any /24-/30 subnetting in <30 seconds without paper

---

## Week 2 - More Subnetting + IPv6

### Reading
- [ ] [notes/01-network-fundamentals.md](./notes/01-network-fundamentals.md) IPv6 section

### Hands-on
- [ ] Configure static IPv4 + IPv6 addresses on routers and PCs in Packet Tracer
- [ ] Configure SLAAC (`ipv6 address autoconfig`)
- [ ] Verify with `show ipv6 interface`

### Subnetting drills
- [ ] Continue daily 30 min
- [ ] Add VLSM (Variable Length Subnet Masking) practice: given a network, design subnets for different host counts

---

## Week 3 - Switches and VLANs

### Reading
- [ ] [notes/02-network-access-vlans.md](./notes/02-network-access-vlans.md) - VLANs section

### Hands-on
- [ ] Create VLANs on two switches; assign access ports
- [ ] Configure 802.1Q trunk between switches
- [ ] Native VLAN configuration
- [ ] Verify with `show vlan brief`, `show interfaces trunk`
- [ ] Add inter-VLAN routing with router-on-a-stick AND with L3 SVI

### Self-check
- [ ] Can I configure access ports and trunks from memory?
- [ ] Can I diagnose a native VLAN mismatch?
- [ ] Can I configure inter-VLAN routing both ways?

---

## Week 4 - STP and EtherChannel

### Reading
- [ ] [notes/02-network-access-vlans.md](./notes/02-network-access-vlans.md) - STP / EtherChannel sections

### Hands-on
- [ ] In Packet Tracer: create a triangle of 3 switches with redundant links; observe which port is blocked
- [ ] Identify root bridge, root ports, designated ports, blocked ports
- [ ] Manipulate root with `spanning-tree vlan X priority`
- [ ] Configure PortFast and BPDUguard on access ports
- [ ] Configure LACP EtherChannel between two switches; verify with `show etherchannel summary`

---

## Week 5 - Static Routing

### Reading
- [ ] [notes/03-ip-connectivity-routing.md](./notes/03-ip-connectivity-routing.md) - Routing fundamentals + Static section

### Hands-on
- [ ] 3-router topology: configure full reachability with static routes
- [ ] Add a default route on the edge router
- [ ] Configure floating static (backup with high AD)
- [ ] Verify with `show ip route`, `traceroute`

---

## Week 6 - OSPF Single-Area

### Reading
- [ ] [notes/03-ip-connectivity-routing.md](./notes/03-ip-connectivity-routing.md) - OSPF section

### Hands-on
- [ ] 3-router OSPF area 0 topology
- [ ] Configure router-IDs explicitly
- [ ] Use loopbacks
- [ ] Add `passive-interface default` + `no passive-interface` on uplinks
- [ ] Verify neighbors (`show ip ospf neighbor`)
- [ ] Diagnose adjacency issue (mismatch hello/dead, area, MTU - simulate one)
- [ ] Add `default-information originate` for default route

### Self-check
- [ ] Can I memorize OSPF neighbor states (Down→Init→2-Way→Exstart→Exchange→Loading→Full)?
- [ ] Can I diagnose stuck-in-EXSTART (MTU mismatch)?
- [ ] Can I make a router DR with `ip ospf priority`?

---

## Week 7 - IP Services

### Reading
- [ ] [notes/04-services-security.md](./notes/04-services-security.md) - NAT, DHCP, DNS, NTP, SNMP, Syslog sections

### Hands-on
- [ ] Configure PAT on edge router; verify with `show ip nat translations`
- [ ] Configure router as DHCP server with excluded addresses
- [ ] Configure DHCP relay (`ip helper-address`)
- [ ] Configure NTP client + server
- [ ] Configure Syslog to a remote server
- [ ] Configure SNMPv3 with auth and priv

---

## Week 8 - ACLs and Port Security

### Reading
- [ ] [notes/04-services-security.md](./notes/04-services-security.md) - ACL + Port Security sections

### Hands-on
- [ ] Standard numbered ACL: allow only one subnet
- [ ] Extended numbered ACL: allow only HTTP/HTTPS to a server
- [ ] Named extended ACL with insertions
- [ ] Apply inbound vs outbound on different interfaces
- [ ] Diagnose: trace why a packet is denied
- [ ] Configure port security with sticky MACs and shutdown violation
- [ ] Trigger a violation, recover with errdisable

---

## Week 9 - Security Fundamentals + AAA + VPN concepts

### Reading
- [ ] [notes/04-services-security.md](./notes/04-services-security.md) - AAA + VPN + Wireless security

### Hands-on
- [ ] Configure SSH-only access with `transport input ssh`
- [ ] Configure local users with privilege levels
- [ ] Configure AAA with RADIUS + local fallback (Packet Tracer has limited RADIUS support)
- [ ] Configure DHCP snooping concept
- [ ] Configure DAI (Dynamic ARP Inspection) concept

### Self-check
- [ ] TACACS+ vs RADIUS differences
- [ ] WPA2 vs WPA3
- [ ] What is 802.1X and where are the three roles?

---

## Week 10 - Wireless + Automation

### Reading
- [ ] [notes/01-network-fundamentals.md](./notes/01-network-fundamentals.md) - Wireless section
- [ ] [notes/05-automation-programmability.md](./notes/05-automation-programmability.md) full

### Hands-on
- [ ] Configure a WLC in Packet Tracer (basic SSID, security, AP onboarding)
- [ ] Read sample JSON / YAML; identify keys, values, types
- [ ] Read a sample Ansible playbook; identify hosts, tasks, modules
- [ ] Make a REST GET against any public API (httpbin.org, JSONPlaceholder)

### Self-check
- [ ] Can I tell apart 2.4 GHz and 5 GHz characteristics?
- [ ] Do I know REST verbs and common status codes?
- [ ] Can I identify YAML errors at a glance?

---

## Week 11 - Practice Exams + Weak Areas

### Reading
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) end to end
- [ ] [scenarios.md](./scenarios.md) - work through all 15

### Practice exams
- [ ] Boson ExSim CCNA (paid, considered hardest and best - if budget allows)
- [ ] Cisco Press CCNA Cert Library practice exams
- [ ] Free practice on [exam-labs](https://www.examtopics.com/exams/cisco/200-301/)
- [ ] Score 85%+ on multiple practice exams

### Drill weak areas
- [ ] Re-read notes for the weak domain
- [ ] Build a Packet Tracer lab for that topic and complete it under time

---

## Week 12 - Final Review and Schedule

### Reviews
- [ ] Subnetting: drill until /22, /23, /24, /26, /27, /28, /29, /30 are instant
- [ ] OSPF: states, adjacency requirements, DR election
- [ ] STP: roles, states, root election
- [ ] ACL placement: standard near destination, extended near source
- [ ] Port numbers (memorize the table in fact-sheet.md)

### Mock exams
- [ ] Two full mock exams, timed (120 minutes each)
- [ ] Score 85%+ on both
- [ ] Review every wrong answer

### Schedule the exam
- [ ] Book through [Pearson VUE](https://home.pearsonvue.com/cisco)
- [ ] Choose testing center or online proctor
- [ ] Budget for 120 minutes plus 15 minutes check-in

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30 min | Read notes / fact-sheet section |
| 30 min | Subnetting drills (every day, no exceptions) |
| 60 min | Hands-on lab in Packet Tracer |
| 30 min | Practice questions on the day's topic |

---

## Stop signals (when you're ready)

- [ ] Subnetting is automatic - any /22 to /30 in under 30 seconds without paper
- [ ] You can build a full multi-VLAN, multi-router, OSPF-routed network in Packet Tracer in <30 minutes
- [ ] You can write extended ACL syntax from memory
- [ ] You can configure port-security, OSPF, NAT, DHCP, syslog from memory
- [ ] You score 85%+ on two practice exams in a row

When all are true, schedule the exam.
