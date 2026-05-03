# CCNP Enterprise ENCOR (350-401) - 14-18 Week Practice Plan

This plan assumes 1.5-2 hours of theory + 1-1.5 hours of hands-on lab per day. Adjust pace based on how recently you passed CCNA and how much production experience you have. The biggest factor in passing ENCOR is **multi-area OSPF and BGP fluency**, **wireless RF understanding**, and **automation comfort (Python + REST + NETCONF)**.

---

## Lab setup (do this in week 1, day 1)

- [ ] Subscribe to **Cisco CML Personal** ($199/year) OR install **EVE-NG Community** + collect IOSv, vIOS-L2, CSR1000v, ASAv, NX-OSv9000 images
- [ ] Bookmark **Cisco DevNet Sandbox** for DNA Center, IOS XE Programmability, NETCONF/RESTCONF labs
- [ ] Build a baseline topology you can re-load: 6 routers in a partial mesh, 4 switches (2 L3 / 2 L2), 4 hosts. Save it.
- [ ] Install Python 3.11+, `requests`, `ncclient`, `netmiko`, `ansible` on your lab host
- [ ] Clone Cisco's `code-exchange` examples for DNA Center and NETCONF

---

## Week 1 - Architecture and Design

### Reading
- [ ] [README.md](./README.md), [fact-sheet.md](./fact-sheet.md) skim end to end
- [ ] [notes/01-architecture.md](./notes/01-architecture.md) deep read
- [ ] Cisco Validated Design (CVD) docs: Campus LAN and Wireless LAN Design Guide

### Self-check
- [ ] Difference between 2-tier collapsed core and 3-tier core/distribution/access
- [ ] Spine-leaf characteristics (every leaf = 1 hop from every spine)
- [ ] CEF / FIB / RIB / Adjacency table relationships

---

## Week 2 - SD-WAN and SD-Access

### Reading
- [ ] [notes/01-architecture.md](./notes/01-architecture.md) SD-WAN and SD-Access sections
- [ ] Cisco SD-WAN Design Guide
- [ ] Cisco SD-Access Solution Design Guide

### Hands-on
- [ ] DevNet Sandbox: log into a vManage and a DNA Center instance
- [ ] Walk through fabric provisioning workflow (don't apply - just observe)
- [ ] Identify VXLAN encapsulation in Wireshark capture

### Self-check
- [ ] Name the 4 SD-WAN components and what each does
- [ ] Name the 5 SD-Access components and what each does
- [ ] What is OMP and how does it relate to BGP?
- [ ] Underlay vs overlay - what protocol carries each in SD-Access?

---

## Week 3 - QoS

### Reading
- [ ] [notes/01-architecture.md](./notes/01-architecture.md) QoS section
- [ ] Cisco Enterprise QoS SRND

### Hands-on
- [ ] Build MQC (Modular QoS CLI) policy with class-map / policy-map / service-policy
- [ ] Mark voice with EF and rate-limit scavenger to 1 Mbps
- [ ] Apply LLQ with priority queue for voice
- [ ] Verify with `show policy-map interface`

### Self-check
- [ ] DSCP values for EF, CS6, AF41, AF31 from memory
- [ ] LLQ vs CBWFQ vs WFQ
- [ ] Policing vs shaping (when to use each)

---

## Week 4 - Virtualization

### Reading
- [ ] [notes/02-virtualization.md](./notes/02-virtualization.md) full

### Hands-on
- [ ] Configure VRF-Lite with two VRFs (RED, BLUE), verify traffic isolation
- [ ] Configure GRE tunnel between two routers
- [ ] Add IPsec protection to the GRE tunnel (`tunnel protection ipsec profile`)
- [ ] Lab basic VXLAN with EVPN (CSR1000v / Nexus 9000v in CML if available)

### Self-check
- [ ] Difference between VRF-Lite, MPLS L3VPN, and VXLAN-EVPN
- [ ] LISP control plane vs data plane
- [ ] What does GRE add to a packet? What does VXLAN add?

---

## Week 5 - Layer 2 (STP variants and EtherChannel)

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) Layer 2 section

### Hands-on
- [ ] Build a 4-switch topology with redundant trunks
- [ ] Configure RPVST+, observe blocked ports per VLAN
- [ ] Convert to MST with 2 instances, observe consolidation
- [ ] LACP EtherChannel between two switches; break a link and observe failover
- [ ] Configure Root Guard, Loop Guard, BPDU Guard, BPDU Filter and trigger each

### Self-check
- [ ] When to use MST vs RPVST+ in a multi-vendor fabric
- [ ] Where Root Guard goes vs Loop Guard
- [ ] LACP modes: active vs passive vs on (which negotiate?)

---

## Week 6 - EIGRP

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) EIGRP section

### Hands-on
- [ ] Named-mode EIGRP across 4 routers
- [ ] Configure unequal-cost load balancing with `variance`
- [ ] Configure stub router on a spoke
- [ ] Authenticate with key chain
- [ ] Diagnose Active/SIA conditions

### Self-check
- [ ] Composite metric formula and default K-values
- [ ] Successor vs feasible successor vs feasibility condition
- [ ] What triggers EIGRP query? When does SIA happen?

---

## Week 7 - OSPF Multi-Area

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) OSPF section
- [ ] Memorize LSA types and area types

### Hands-on
- [ ] 6-router OSPF with area 0 backbone + area 1 stub + area 2 NSSA
- [ ] Configure ABR summarization
- [ ] Configure virtual link to repair partitioned backbone
- [ ] Inject default route with `default-information originate`
- [ ] Authenticate with MD5 message-digest

### Self-check
- [ ] LSA types 1-5 and 7 - who originates, where flooded?
- [ ] What's blocked in stub vs totally stubby vs NSSA vs totally NSSA?
- [ ] OSPF best-path preference order (intra → inter → E1 → E2 → N1 → N2)

---

## Week 8 - BGP

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) BGP section
- [ ] Memorize best-path attribute order

### Hands-on
- [ ] eBGP between two ASNs in CML
- [ ] iBGP within an AS (use loopbacks + `update-source` + `next-hop-self`)
- [ ] Use route-maps to set local-preference, AS-PATH prepend, MED
- [ ] Filter prefixes with prefix-lists
- [ ] Verify with `show bgp ipv4 unicast` and `show bgp ipv4 unicast neighbors X advertised-routes`

### Self-check
- [ ] BGP states (Idle → Established) - what error stalls Active?
- [ ] Best-path attribute order (mnemonic memorized)
- [ ] When is `next-hop-self` required?

---

## Week 9 - Wireless (Architecture + RF)

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) Wireless section

### Hands-on (DevNet Sandbox or Catalyst 9800-CL on CML)
- [ ] Configure WLC with 2 SSIDs (open + WPA2-Enterprise via RADIUS)
- [ ] Walk through AP join via DHCP option 43 / DNS / broadcast
- [ ] Configure FlexConnect group + locally switched VLAN mapping
- [ ] Read `show ap summary`, `show wireless client summary`
- [ ] Identify RSSI / SNR readings on a client

### Self-check
- [ ] 802.11 standards table (a/b/g/n/ac/ax/be), bands, max rates
- [ ] AP modes (Local / FlexConnect / Sniffer / Monitor / OEAP)
- [ ] Healthy RSSI / SNR thresholds for voice and data
- [ ] WLC discovery order

---

## Week 10 - IP Services (FHRP, NTP, NAT, Multicast)

### Reading
- [ ] [notes/03-infrastructure.md](./notes/03-infrastructure.md) IP Services section

### Hands-on
- [ ] HSRPv2 with priority + preempt + interface tracking
- [ ] VRRP between two L3 switches
- [ ] GLBP with weighted load-balancing
- [ ] NAT/PAT with overload + static port mapping
- [ ] PIM-SM with a static RP, IGMPv2 join from a host
- [ ] NTP with auth and stratum

### Self-check
- [ ] HSRP virtual MAC range
- [ ] When to choose VRRP over HSRP (multi-vendor)
- [ ] PIM-SM RP vs SPT switchover

---

## Week 11 - Network Assurance

### Reading
- [ ] [notes/04-network-assurance.md](./notes/04-network-assurance.md) full

### Hands-on
- [ ] Conditional debug: `debug ip ospf hello`, then constrain with `debug condition interface gi0/0`
- [ ] SPAN session: monitor a port and capture in Wireshark
- [ ] RSPAN across a trunk (VLAN-based capture)
- [ ] Configure Flexible NetFlow exporting to a collector
- [ ] IP SLA tracking + static-route failover
- [ ] SNMPv3 with auth + priv

### Self-check
- [ ] SPAN vs RSPAN vs ERSPAN - when to use each
- [ ] NetFlow versions (v5 fixed vs v9 templated vs IPFIX)
- [ ] Syslog severity levels (0-7) and what each means

---

## Week 12 - Security

### Reading
- [ ] [notes/05-security.md](./notes/05-security.md) full

### Hands-on
- [ ] AAA with TACACS+ (use `tac_plus` on Linux or DevNet) + local fallback
- [ ] CoPP policy applied to control-plane
- [ ] DHCP snooping + DAI on access switches
- [ ] uRPF strict mode on the edge
- [ ] WPA3-Enterprise (or WPA2-Ent) on the WLC with EAP-TLS
- [ ] Lab MACsec between two L3 switches
- [ ] Test Cisco TrustSec SGT classification (manual SGT on a port)

### Self-check
- [ ] TACACS+ vs RADIUS (transport, encryption, AAA separation)
- [ ] WPA2-PSK vs WPA2-Enterprise vs WPA3
- [ ] Where CoPP applies in the data path
- [ ] TrustSec SGT lifecycle (classification → propagation → enforcement)

---

## Week 13 - Automation, Part 1 (Python + REST)

### Reading
- [ ] [notes/06-automation.md](./notes/06-automation.md) JSON/YAML/XML, REST, Python sections

### Hands-on
- [ ] Read 5 different Python scripts using `requests`; explain each line
- [ ] Hit DevNet always-on DNA Center sandbox: auth + GET network-device + parse JSON
- [ ] Write a script that POSTs a new VLAN to a Catalyst via RESTCONF
- [ ] Validate JSON / YAML in `jq` / `yamllint`

### Self-check
- [ ] HTTP verbs and status codes from memory
- [ ] Difference between `requests.get()` and `requests.post(json=...)`
- [ ] Identify a JSON syntax error at a glance
- [ ] Identify a YAML indentation error at a glance

---

## Week 14 - Automation, Part 2 (NETCONF / RESTCONF / Ansible / DNA Center)

### Reading
- [ ] [notes/06-automation.md](./notes/06-automation.md) NETCONF, YANG, Ansible, DNA Center sections

### Hands-on
- [ ] Enable `netconf-yang` and `restconf` on a CSR1000v
- [ ] Use `ncclient` to `get-config` and `edit-config` an interface description
- [ ] Use `curl` to RESTCONF GET an interface and PUT a description
- [ ] Run an Ansible playbook that pushes a banner to 5 routers
- [ ] DNA Center: Auth → Command Runner → Run `show version` on a device

### Self-check
- [ ] NETCONF datastores (running, candidate, startup)
- [ ] YANG: what's a leaf, list, container?
- [ ] Open vs native YANG models
- [ ] Why RESTCONF over NETCONF (or vice versa)?

---

## Week 15 - Practice Exams + Weak Areas

### Reading
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) end to end
- [ ] [scenarios.md](./scenarios.md) - work through all 15+

### Practice exams
- [ ] **Boson ExSim ENCOR** (paid; widely considered the closest to real exam difficulty)
- [ ] **Cisco Press CCNP/CCIE Enterprise Core ENCOR 350-401 Official Cert Guide** practice tests
- [ ] **CBT Nuggets / INE / KBITs / OCG** practice tests if you have access
- [ ] Score 80%+ on multiple practice exams before scheduling

### Drill weak areas
- [ ] Re-read notes for the weak domain
- [ ] Build a CML lab targeting that topic and complete it under time

---

## Week 16 - Final Review (or Week 16-18 if you need more time)

### Reviews
- [ ] OSPF: areas, LSAs, virtual links, summarization, authentication
- [ ] BGP: best-path order, attributes, route-maps, prefix-lists
- [ ] EIGRP: composite metric, FS/FC, named mode, stub
- [ ] STP: roles, states, RPVST+ vs MST
- [ ] EtherChannel: LACP/PAgP modes
- [ ] Wireless: 802.11 standards, AP modes, RF basics
- [ ] QoS: DSCP markings, LLQ
- [ ] Security: AAA, CoPP, TrustSec, MACsec
- [ ] Automation: Python REST, NETCONF/RESTCONF, YANG, Ansible

### Mock exams
- [ ] Two full mock exams, timed (120 minutes each)
- [ ] Score 80%+ on both
- [ ] Review every wrong answer; if a topic is shaky, lab it

### Schedule the exam
- [ ] Book through [Pearson VUE](https://home.pearsonvue.com/cisco)
- [ ] Choose testing center or online proctor (online has stricter rules)
- [ ] Budget for 120 minutes plus 15 minutes check-in

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30-45 min | Read notes / fact-sheet section |
| 60-90 min | Hands-on lab in CML / EVE-NG / DevNet |
| 30 min | Practice questions on the day's topic |
| 15 min | Review yesterday's notes (spaced repetition) |

---

## Stop signals (when you're ready)

- [ ] You can stand up multi-area OSPF + ABR summarization + virtual link in CML in <20 minutes
- [ ] You can stand up eBGP + iBGP with route-maps and prefix-lists in <20 minutes
- [ ] You can read a Python `requests` script and predict the JSON response shape
- [ ] You can configure HSRP, VRRP, and GLBP from memory and explain why each is chosen
- [ ] You can name the 4 SD-WAN components and the 5 SD-Access components without looking
- [ ] You can identify all OSPF LSA types (1-5, 7) and which area types block which
- [ ] You can write the BGP best-path attribute order from memory
- [ ] You score 80%+ on Boson ExSim ENCOR or equivalent

When all are true, schedule the exam.
