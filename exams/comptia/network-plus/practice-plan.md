# CompTIA Network+ (N10-009) Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: Networking Concepts - Foundations

#### Day 1-2: OSI Model and TCP/IP
- [ ] OSI 7 layers, PDUs at each layer, devices per layer
- [ ] TCP/IP 4-layer model and how it maps to OSI
- [ ] Encapsulation/decapsulation walkthrough
- [ ] TCP handshake (SYN, SYN-ACK, ACK) and flags (FIN, RST, PSH, URG)
- [ ] UDP vs TCP - when to use each, examples
- [ ] Review Notes: `01-networking-concepts.md`

#### Day 3-4: Ports, Protocols, and Services
- [ ] Memorize port table from fact sheet (FTP through 8080)
- [ ] Map insecure -> secure protocol pairs (HTTP/HTTPS, FTP/SFTP, etc.)
- [ ] DNS record types (A, AAAA, CNAME, MX, NS, SOA, PTR, TXT, SRV)
- [ ] DHCP DORA process, relay/IP helper, lease/reservation/exclusion
- [ ] NTP, SNMP (v1/v2c/v3), syslog severity levels
- [ ] Review Notes: `01-networking-concepts.md`

#### Day 5-6: IP Addressing and Subnetting
- [ ] Classful addressing (A/B/C/D/E)
- [ ] RFC 1918 private ranges
- [ ] Special addresses: APIPA, loopback, multicast, CGNAT
- [ ] CIDR/VLSM math: hosts = 2^n - 2
- [ ] Practice subnetting at /24 - /30 until you can do them in <30 sec each
- [ ] Magic number trick on the fourth octet
- [ ] IPv6 format, address types (GUA, ULA, link-local, multicast, loopback)
- [ ] SLAAC, DHCPv6, EUI-64
- [ ] Review Notes: `01-networking-concepts.md`

#### Day 7: Week 1 Review
- [ ] Subnetting drills - 25 problems in 25 minutes
- [ ] Port number flashcards
- [ ] Practice questions on OSI, ports, addressing (target: 65%+)

### Week 2: Network Implementation - Routing and Switching

#### Day 8-9: Switching
- [ ] How switches learn MAC addresses (CAM/MAC table)
- [ ] Broadcast domains vs collision domains (VLAN per broadcast domain)
- [ ] VLANs, 802.1Q tagging, native VLAN, voice VLAN
- [ ] Trunking (802.1Q) and access ports
- [ ] STP/RSTP - port states, port roles, root bridge election, BPDU
- [ ] STP protections: BPDU Guard, Root Guard, PortFast
- [ ] Link aggregation - LACP (802.3ad), PAgP, static
- [ ] Review Notes: `02-network-implementation.md`

#### Day 10-11: Routing
- [ ] Static vs dynamic routing - when to use each
- [ ] Administrative distance values (memorize: connected 0, static 1, EBGP 20, EIGRP 90, OSPF 110, RIP 120, IBGP 200)
- [ ] OSPF basics: areas, LSAs, DR/BDR, cost metric
- [ ] EIGRP basics: composite metric, DUAL, feasible successor
- [ ] BGP basics: AS, EBGP vs IBGP, path attributes
- [ ] RIP basics: hop count, max 15, slow convergence
- [ ] Default route 0.0.0.0/0 and route summarization
- [ ] Review Notes: `02-network-implementation.md`

#### Day 12-13: Wireless and Physical
- [ ] 802.11 alphabet soup: a/b/g/n/ac/ax/be, frequencies, max speeds
- [ ] 2.4 GHz (1, 6, 11) vs 5 GHz vs 6 GHz channel planning
- [ ] WPA2 vs WPA3 (SAE), 802.1X enterprise auth, EAP variants
- [ ] AP modes: autonomous, lightweight, controller-based
- [ ] Antenna types: omni, directional (yagi, panel, parabolic)
- [ ] Cabling - Cat 5e/6/6a/7/8, fiber OM1-5/OS1-2, connectors
- [ ] PoE 802.3af/at/bt power budgets
- [ ] Review Notes: `02-network-implementation.md`

#### Day 14: Week 2 Review
- [ ] Practice questions on routing/switching/wireless (target: 65%+)
- [ ] Build a 2-VLAN topology in Packet Tracer/GNS3 with router-on-a-stick
- [ ] Trace the path of a frame between VLANs

### Week 3: Network Operations

#### Day 15-16: Documentation and Monitoring
- [ ] Logical vs physical network diagrams
- [ ] IPAM (IP Address Management)
- [ ] Baseline configurations and configuration management
- [ ] Asset inventories and labeling standards
- [ ] SNMP polling vs traps; OIDs and MIBs
- [ ] NetFlow / sFlow / IPFIX flow records
- [ ] Syslog facility/severity, centralized log servers
- [ ] SIEM concepts and correlation
- [ ] Review Notes: `03-network-operations.md`

#### Day 17-18: Performance and Availability
- [ ] Performance metrics: latency, jitter, throughput, packet loss, bandwidth
- [ ] Bandwidth vs throughput vs goodput
- [ ] QoS: classification, marking (DSCP, CoS), queuing, shaping vs policing
- [ ] HA: active/active, active/passive, clustering
- [ ] First-hop redundancy: HSRP, VRRP, GLBP
- [ ] NIC teaming and bonding modes
- [ ] Load balancers: L4 vs L7, algorithms (round robin, least connections, weighted)
- [ ] Review Notes: `03-network-operations.md`

#### Day 19-20: DR/BCP and Organizational Documents
- [ ] BCP vs DR plan - difference and overlap
- [ ] RTO, RPO, MTBF, MTTR - definitions and how to compute
- [ ] Backup strategies: full, incremental, differential, synthetic
- [ ] DR sites: hot, warm, cold (cost and recovery time tradeoff)
- [ ] Organizational documents: SLA, MOU, NDA, AUP, BYOD policy, SOP
- [ ] Change management lifecycle
- [ ] Review Notes: `03-network-operations.md`

#### Day 21: Week 3 Review
- [ ] Practice questions on operations (target: 70%+)
- [ ] Draw a logical diagram of your home/lab network
- [ ] Practice SLA scenario calculations

### Week 4: Network Security

#### Day 22-23: Threats and Attacks
- [ ] Layer 2 attacks: MAC flooding, VLAN hopping, ARP poisoning, DHCP starvation/spoofing, STP attacks
- [ ] Layer 3 attacks: IP spoofing, ICMP-based, smurf
- [ ] Wireless attacks: deauthentication, evil twin, rogue AP, jamming, KRACK
- [ ] DNS attacks: cache poisoning, DNS tunneling, DDoS reflection
- [ ] On-path / MITM, replay, password attacks (brute force, dictionary, rainbow)
- [ ] DDoS types: volumetric, protocol, application
- [ ] Review Notes: `04-network-security.md`

#### Day 24-25: Hardening and Security Devices
- [ ] Port security, sticky MAC, max MAC addresses
- [ ] DHCP snooping, dynamic ARP inspection, IP source guard
- [ ] BPDU guard, root guard, control plane policing
- [ ] Disable unused ports, change default native VLAN
- [ ] NGFW, IDS/IPS (signature vs anomaly), proxy, WAF
- [ ] NAC and 802.1X enforcement (deny, quarantine, remediate)
- [ ] Network segmentation: VLANs, ACLs, microsegmentation, screened subnet (DMZ)
- [ ] Review Notes: `04-network-security.md`

#### Day 26-27: AAA, VPN, Physical Security
- [ ] RADIUS vs TACACS+ (UDP vs TCP, encryption scope, AAA separation)
- [ ] Kerberos basics (KDC, TGT, port 88)
- [ ] LDAP/LDAPS for directory auth
- [ ] SAML, OAuth, OIDC for federation/SSO
- [ ] Site-to-site VPN: IPsec (IKE phase 1/2, ESP vs AH, transport vs tunnel)
- [ ] Remote access VPN: SSL/TLS VPN, split tunnel vs full tunnel
- [ ] Physical security: badges, mantraps, smart locks, CCTV, asset tags
- [ ] Review Notes: `04-network-security.md`

#### Day 28: Week 4 Review
- [ ] Practice questions on security (target: 70%+)
- [ ] Map each attack to its mitigation in a table
- [ ] Compare RADIUS vs TACACS+ verbally without notes

### Week 5: Network Troubleshooting

#### Day 29-30: Methodology and CLI Tools
- [ ] Memorize CompTIA 7-step methodology
- [ ] Practice OSI bottom-up troubleshooting framework
- [ ] ping, tracert/traceroute, pathping/mtr - flags and interpretation
- [ ] ipconfig vs ifconfig vs ip; show/renew/release DHCP
- [ ] nslookup vs dig; querying specific record types
- [ ] netstat / ss for sockets, listening ports, connection state
- [ ] arp / ip neigh; route / ip route
- [ ] nmap basic scans (SYN, version, OS)
- [ ] tcpdump / Wireshark filters
- [ ] iperf3 for bandwidth tests
- [ ] Review Notes: `05-network-troubleshooting.md`

#### Day 31-32: Hardware Tools and Cable/Wireless Issues
- [ ] Cable tester, tone generator + probe, OTDR, light meter
- [ ] Loopback adapter, multimeter, punch-down, crimper
- [ ] Wi-Fi analyzer, spectrum analyzer
- [ ] Cable issues: shorts, opens, crosstalk, attenuation, EMI
- [ ] Connector and termination problems
- [ ] Wireless issues: low signal, interference, channel overlap, AP placement, hidden node
- [ ] Power issues: PoE budget exceeded, wrong injector class
- [ ] Review Notes: `05-network-troubleshooting.md`

#### Day 33-34: Routing, Switching, Service Issues
- [ ] Routing loops, missing routes, asymmetric routing, MTU mismatches/fragmentation
- [ ] Switching loops, STP misconfig, broadcast storms, MAC flapping
- [ ] VLAN mismatches, native VLAN mismatches, trunking problems
- [ ] DHCP exhaustion, rogue DHCP, APIPA address received
- [ ] DNS misconfig, slow DNS, wrong resolver, hosts file overrides
- [ ] Duplex mismatch (half/full), speed auto-negotiation issues
- [ ] Review Notes: `05-network-troubleshooting.md`

#### Day 35: Week 5 Review
- [ ] Practice questions on troubleshooting (target: 75%+)
- [ ] Walk through 10 scenarios from `scenarios.md` out loud
- [ ] Build a troubleshooting decision tree from the OSI model

### Week 6: Review and Exam Preparation

#### Day 36-37: Full Practice Exams
- [ ] Complete full-length practice exam 1 in 90 minutes
- [ ] Review every wrong answer thoroughly with documentation lookup
- [ ] Identify weak domains by score
- [ ] Target score: 80%+

#### Day 38-39: Weak Area Deep Dive
- [ ] Re-read notes for weakest 1-2 domains
- [ ] Drill 50 more questions in weak areas
- [ ] Subnetting speed drill (target: <20 sec per question)
- [ ] Complete full-length practice exam 2

#### Day 40-41: Performance-Based Question Practice
- [ ] Practice configuring switch ports, VLANs, ACLs in Packet Tracer
- [ ] Practice cable type / connector matching
- [ ] Practice firewall rule ordering exercises
- [ ] Practice troubleshooting from log/diagram screenshots
- [ ] Time management under PBQ pressure (max 5 min per PBQ)

#### Day 42: Final Review and Exam Day Prep
- [ ] Skim fact sheet (especially port table and subnetting)
- [ ] Review acronym list
- [ ] Verify exam logistics, ID, testing environment
- [ ] Light review only - no new material the day before
- [ ] 8 hours of sleep

## Daily Study Routine (2-3 hours/day)

### Recommended Schedule
1. **30 minutes**: Read or re-read study notes
2. **45 minutes**: Hands-on lab work (Packet Tracer, GNS3, home lab)
3. **45 minutes**: Practice questions / scenario walkthrough
4. **15 minutes**: Subnetting drills (every day, no exceptions)
5. **15 minutes**: Review wrong answers, update flashcards

## Practice Exam Strategy

### Target Scores by Week
- [ ] Week 2: 60%+ on domain-specific practice
- [ ] Week 3: 65%+ on domain-specific practice
- [ ] Week 4: 70%+ on mixed practice exams
- [ ] Week 5: 75%+ on mixed practice exams
- [ ] Week 6: 80%+ consistently on full practice exams

## Subnetting Drill Plan

Subnetting appears 5-10 times on the exam, both as MCQs and inside PBQs. You must be fast.

| Week | Drill | Time target |
|------|-------|-------------|
| 1 | Identify network/broadcast for /24-/30 | 60 sec each |
| 2 | Find usable host count, fit X hosts in smallest subnet | 45 sec each |
| 3 | VLSM: divide /24 into N unequal subnets | 3 min each |
| 4 | Magic number on /17-/22 (third octet) | 60 sec each |
| 5-6 | Mixed under exam pressure | 30 sec MCQ, 90 sec scenario |

Use [subnettingpractice.com](https://subnettingpractice.com/) or Professor Messer's drills.

## Study Resources

### Free Resources
- **[Professor Messer Network+ N10-009](https://www.professormesser.com/network-plus/n10-009/n10-009-video/n10-009-comptia-network-plus-course/)** - Complete free video course
- **[CompTIA N10-009 Exam Objectives](https://www.comptia.org/certifications/network#examdetails)** - Official scope document
- **[Cisco Packet Tracer](https://www.netacad.com/courses/packet-tracer)** - Free network simulator (NetAcad signup)
- **[GNS3](https://www.gns3.com/)** - Free network emulator with real images
- **[Wireshark](https://www.wireshark.org/)** - Packet analyzer for protocol learning
- **[RFC Editor](https://www.rfc-editor.org/)** - Authoritative protocol references

### Paid Resources
- **CompTIA CertMaster Learn for Network+** - Official self-paced training
- **CompTIA CertMaster Practice for Network+** - Official adaptive practice
- **CompTIA CertMaster Labs for Network+** - Hands-on browser labs
- **Jason Dion Network+ N10-009** (Udemy) - Video course + 6 practice exams
- **Mike Meyers Network+ N10-009** (Total Seminars) - Comprehensive course + book
- **CompTIA Network+ Study Guide (N10-009)** by Todd Lammle - Sybex/Wiley book
- **CompTIA Network+ All-in-One Exam Guide (N10-009)** - McGraw Hill / Mike Meyers

## Final Exam Checklist

### Content Preparation
- [ ] All five domain notes reviewed at least twice
- [ ] Fact sheet port table memorized
- [ ] Subnetting fluent at all common masks
- [ ] OSI layers, devices per layer memorized
- [ ] Cable categories and distances memorized
- [ ] 802.11 standards and frequencies memorized
- [ ] Administrative distance values memorized
- [ ] DHCP DORA and DNS record types memorized

### Exam Day Strategy
- [ ] Time management: ~1 minute per question, ~5 min per PBQ
- [ ] Skip PBQs initially, return after MCQs (PBQs cluster at start)
- [ ] Read questions twice - watch for "BEST", "FIRST", "MOST LIKELY"
- [ ] Apply OSI bottom-up to troubleshooting questions
- [ ] Eliminate clearly wrong answers first
- [ ] Flag uncertain questions, return at end
- [ ] Reserve 10-15 minutes for review of flagged items
- [ ] Dump subnetting cheat (powers of 2, host counts) on scratch pad in first 2 minutes
