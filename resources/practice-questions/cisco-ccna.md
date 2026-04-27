# Cisco CCNA (200-301) - Practice Questions

15 scenario-based questions for CCNA prep.

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

## Scoring guide

- **13-15:** Schedule the exam.
- **10-12:** Re-read OSPF + ACL + IP services sections; subnetting drills.
- **<10:** Subnetting fluency first, then re-attempt.

CCNA: ~100-120 questions, 120 minutes. Includes simulation labs (Packet Tracer-style configuration tasks). These multiple-choice questions test concepts; build hands-on fluency in Packet Tracer / GNS3 too.
