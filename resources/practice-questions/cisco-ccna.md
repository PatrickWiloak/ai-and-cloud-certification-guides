# Cisco CCNA (200-301) - Practice Questions

25 scenario-based questions for CCNA prep.

> **Cert page:** [exams/cisco/ccna-200-301/](../../exams/cisco/ccna-200-301/)

---

### Question 1
**Scenario:** Hosts on VLAN 10 (10.10.10.0/24) can't reach hosts on VLAN 20 (10.10.20.0/24) on the same switch. The L2 switch is fine. What's missing?

A. Inter-VLAN routing on a router-on-a-stick or L3 switch SVI
B. A trunk between switches
C. STP convergence
D. DNS

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** L2 switches don't route between VLANs. Need either a router with subinterfaces (router-on-a-stick) using `encapsulation dot1q <vlan>` or L3 switch SVIs (`interface vlan 10`) with `ip routing` enabled.
</details>

---

### Question 2
**Scenario:** Network 192.168.10.0/26 - what's the broadcast address?

A. 192.168.10.63
B. 192.168.10.64
C. 192.168.10.255
D. 192.168.10.62

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** /26 = 26 mask bits, 6 host bits, 64 addresses per subnet. First subnet is 192.168.10.0; broadcast is 192.168.10.63 (last in range). Block size is 64 (256 - 192 mask = 64).
</details>

---

### Question 3
**Scenario:** OSPF neighbors stuck in EXSTART state. Most likely cause?

A. Different areas
B. MTU mismatch on the interface
C. Different OSPF process IDs
D. Authentication mismatch

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** EXSTART negotiation includes MTU. Mismatched MTU causes the DBD packet exchange to fail, neighbors get stuck. Other causes (area mismatch, hello/dead timer mismatch) usually fail at INIT or 2-WAY. Process IDs can differ between routers; only network statements + areas need matching.
</details>

---

### Question 4
**Scenario:** PortFast and BPDUguard - what do they do together on an access port?

A. Skip listening/learning STP states (PortFast); shut the port if a BPDU arrives (BPDUguard) - prevents loops if someone plugs in another switch
B. Speed up trunks
C. Block all traffic
D. They conflict

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** PortFast brings access ports up immediately (no 30s STP wait). BPDUguard err-disables the port if a BPDU is received - protecting against unauthorized switches/loops. Standard pattern on user-facing access ports.
</details>

---

### Question 5
**Scenario:** Standard ACL `access-list 10 permit 10.0.0.0 0.255.255.255` - where to apply for best practice?

A. Inbound on the source interface
B. Inbound on the destination interface (closest to destination)
C. Outbound on the destination interface
D. Anywhere works

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Standard ACLs match by source IP only. Place close to the **destination** to avoid blocking traffic the source might legitimately need to send elsewhere. Extended ACLs (which match source+destination+protocol+ports) go close to source.
</details>

---

### Question 6
**Scenario:** Convert subnet mask 255.255.255.224 to CIDR?

A. /27
B. /26
C. /28
D. /24

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** 224 = 11100000 = 3 bits set in the last octet. 24 + 3 = /27. Gives 32 addresses per subnet, 30 hosts.
</details>

---

### Question 7
**Scenario:** Create a Layer 2 trunk between two switches, allowing only VLANs 10, 20, 99 (native)?

A. `switchport mode trunk; switchport trunk allowed vlan 10,20,99; switchport trunk native vlan 99`
B. `switchport mode access; switchport access vlan 10`
C. `no switchport`
D. `switchport mode dynamic auto`

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Explicit trunk config: `mode trunk` (don't rely on DTP), `allowed vlan` for the list, `native vlan 99` to map untagged traffic. Native VLAN must match on both sides.
</details>

---

### Question 8
**Scenario:** A static route as backup for an OSPF route - how to ensure it's only used if OSPF fails?

A. Make its administrative distance higher than OSPF's (default 110): `ip route ... 200`
B. Use a higher metric
C. Put both in the table
D. Disable OSPF

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** "Floating static" - set AD higher than the dynamic protocol's. AD 200 > OSPF's 110, so static is only installed when OSPF route disappears. Default AD for static is 1, which would override OSPF.
</details>

---

### Question 9
**Scenario:** Configure SSH on a Cisco router (replacing Telnet)?

A. `hostname R1; ip domain-name x.com; crypto key generate rsa modulus 2048; line vty 0 4; transport input ssh; login local`
B. `enable telnet`
C. SSH is enabled by default
D. Reboot to enable

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** SSH requires hostname, domain name (for FQDN), RSA keys, then VTY config. `transport input ssh` (not `all`) restricts to SSH only. `login local` uses local users (created with `username admin secret X`).
</details>

---

### Question 10
**Scenario:** Default routing protocol administrative distance order (lowest = most preferred)?

A. Connected (0) < Static (1) < EBGP (20) < EIGRP (90) < OSPF (110) < RIP (120) < IBGP (200)
B. All zero
C. RIP < OSPF
D. They have no AD

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Lower AD = more trusted. Memorize: Connected 0, Static 1, EBGP 20, internal EIGRP 90, OSPF 110, RIP 120, external EIGRP 170, IBGP 200, unknown 255.
</details>

---

### Question 11
**Scenario:** EtherChannel between two switches with LACP - what mode combinations work?

A. active/active and active/passive
B. on/passive
C. desirable/passive
D. on/active

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** LACP modes: active (initiates negotiation) and passive (only responds). Active/active and active/passive negotiate successfully. Passive/passive does not. PAgP modes (desirable/auto) and `on` (static, no negotiation) don't mix with LACP.
</details>

---

### Question 12
**Scenario:** Stateless Network Address Translation (NAT) maps:

A. 1:1 inside-local to inside-global, no port differentiation
B. Many-to-one with port (PAT)
C. 1:1 with port (impossible)
D. None

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Static NAT and dynamic NAT (without overload) are 1:1. PAT (port address translation, NAT overload) is the many-to-one form using ephemeral ports to differentiate sessions.
</details>

---

### Question 13
**Scenario:** What's an SDN controller's main role?

A. Run the data plane
B. Centralize the control plane: compute paths and push flow rules to forwarding devices via southbound APIs (OpenFlow, NETCONF, RESTCONF, gRPC)
C. Replace switches
D. Encrypt traffic

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SDN separates control plane (controller) from data plane (devices). Controller has global view, computes paths, pushes flow rules. Devices forward according to those rules. Cisco DNA Center, ACI APIC, OpenDaylight are SDN controllers.
</details>

---

### Question 14
**Scenario:** Standard NTP client config?

A. `ntp server 10.0.0.1` (and possibly multiple); routers learn time and can serve downstream clients
B. NTP isn't supported
C. Configure manually
D. Use cron

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `ntp server <IP>` configures an NTP source. Multiple servers improve resilience. To act as server: `ntp master <stratum>`. Verify with `show ntp associations` and `show ntp status`.
</details>

---

### Question 15
**Scenario:** Cisco AAA: TACACS+ vs RADIUS?

A. TACACS+ is Cisco proprietary, encrypts entire packet, separates auth/authz/acct (TCP 49); RADIUS is open standard, encrypts only the password, combines auth+authz (UDP 1812/1813)
B. They're identical
C. RADIUS is Cisco
D. Neither encrypts

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Memorize this exact contrast. TACACS+ is preferred for network device admin (separates command authorization). RADIUS is more common for user auth (Wi-Fi 802.1X, VPN). Cisco supports both.
</details>

---

### Question 16
**Scenario:** Two switches are connected by a trunk link. VLAN 10 traffic passes but VLAN 20 doesn't. What's the most likely cause?

A. STP blocked
B. VLAN 20 not allowed on the trunk (allowed-vlan list missing it) or VLAN 20 not created on one of the switches
C. CDP disabled
D. PoE issue

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Trunks default to allowing all VLANs but operators often prune. Also, both ends must have the VLAN created in the VLAN database for traffic to forward. Check `show interfaces trunk` and `show vlan brief`.
</details>

---

### Question 17
**Scenario:** RSTP convergence after a link failure is dramatically faster than 802.1D STP. Why?

A. Different math
B. RSTP uses proposal/agreement handshakes and per-port roles (alternate, backup) that pre-compute alternate paths, instead of waiting for the 30-50s timer-based transitions
C. RSTP runs at L1
D. RSTP doesn't use BPDUs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RSTP (802.1w) replaces timer-based listening/learning with explicit handshakes; alternate ports already know they're backups and can take over immediately. Convergence drops from ~30-50s to sub-second on simple topologies.
</details>

---

### Question 18
**Scenario:** A LAN has a single DHCP server in VLAN 10. Hosts in VLAN 20 don't get IPs. What's needed on the VLAN 20 SVI?

A. NAT
B. `ip helper-address <DHCP-server-IP>` - relays DHCP broadcasts as unicast to the server
C. Disable DHCP snooping
D. ACL deny

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** DHCP DISCOVER is a broadcast; routers don't forward broadcasts. The `ip helper-address` command on the receiving SVI converts the broadcast to a unicast aimed at the DHCP server, which uses the giaddr to determine which subnet to allocate from.
</details>

---

### Question 19
**Scenario:** A small office shares one public IP across 50 internal hosts. Which NAT type?

A. Static NAT
B. PAT (NAT overload) - one public IP, many internal hosts disambiguated by source port
C. Dynamic NAT one-to-one
D. Twice NAT

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** PAT (Port Address Translation) overloads a single public IP using the L4 source port to disambiguate connections. Standard for SOHO and most enterprise edge cases. Static NAT is one-to-one (servers); dynamic NAT pools require multiple public IPs.
</details>

---

### Question 20
**Scenario:** Configuring a wireless LAN: which mode is most common in enterprise deployments?

A. Standalone autonomous APs
B. Lightweight APs managed by a Wireless LAN Controller (WLC) using CAPWAP, with central config and roaming
C. Mesh only
D. Ad-hoc

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Controller-based (lightweight + WLC) deployment is standard for enterprise: centralized policy, fast roaming, RF management. Standalone APs scale poorly past a handful. CAPWAP tunnels traffic between AP and WLC.
</details>

---

### Question 21
**Scenario:** Network monitoring: which protocol is best for collecting traffic flow records (source/dest IPs, bytes, ports)?

A. SNMP
B. NetFlow / IPFIX - exports per-flow metadata to a collector for traffic analysis
C. Syslog
D. ICMP

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** NetFlow (Cisco) and IPFIX (standards-based) export flow records summarizing traffic, used for security, capacity, and billing analysis. SNMP polls counters; Syslog is event log; ICMP is ping/diagnostics.
</details>

---

### Question 22
**Scenario:** IPv6: how does a host learn its global unicast address on a typical enterprise LAN?

A. DHCPv4
B. SLAAC (Stateless Address Autoconfiguration) using router advertisements + EUI-64 or random IID, optionally combined with DHCPv6 for DNS info
C. Manual only
D. ARP

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Routers advertise a /64 prefix; hosts append a 64-bit interface ID (EUI-64 from MAC, or RFC 7217 stable random) to form the global unicast. DHCPv6 is optional and often used for "other" config (DNS) only.
</details>

---

### Question 23
**Scenario:** Spine-leaf vs traditional 3-tier (core/distribution/access) - the key architectural difference?

A. Spine-leaf has more layers
B. Spine-leaf provides predictable East-West latency (every leaf is one hop from any spine, no oversubscription) - better for data center workloads dominated by server-to-server traffic
C. They're identical
D. Spine-leaf is wireless

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Modern data centers run heavy East-West (server-to-server) traffic that 3-tier handles poorly. Spine-leaf flattens the topology: every leaf connects to every spine, ECMP routing balances load, predictable two-hop max between any servers.
</details>

---

### Question 24
**Scenario:** SD-WAN replaces or augments which traditional WAN technology in most deployments?

A. Replaces L2 switching
B. Replaces or augments MPLS by using multiple internet/broadband links with application-aware overlay routing, encrypted tunnels, and centralized policy
C. Replaces Wi-Fi
D. Replaces L1 cabling

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SD-WAN abstracts the underlay (broadband, LTE, MPLS) and steers traffic per-application based on real-time link quality. Cuts MPLS spend, simplifies branch deployment, integrates security. Cisco's offerings: Viptela, Meraki SD-WAN.
</details>

---

### Question 25
**Scenario:** Network automation: a team wants to push the same VLAN config to 50 switches reliably. Best approach?

A. Telnet from a script with copy-paste
B. Use Ansible (or similar) with idempotent network modules over SSH/NETCONF, version the config in git
C. Manual SSH each switch
D. SNMP write

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Idempotent automation tools handle drift, partial failures, and rollback. Ansible's `ios_*` modules (or NETCONF/RESTCONF for newer platforms) are the standard. Git provides change history and review. Telnet copy-paste is brittle and unauditable.
</details>

---

## Scoring guide

- **22-25:** Schedule the exam.
- **17-21:** Re-read OSPF + ACL + IP services sections; subnetting drills.
- **<17:** Subnetting fluency first, then re-attempt.

CCNA: ~100-120 questions, 120 minutes. Includes simulation labs (Packet Tracer-style configuration tasks). These multiple-choice questions test concepts; build hands-on fluency in Packet Tracer / GNS3 too.
