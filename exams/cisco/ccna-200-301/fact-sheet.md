# CCNA (200-301) - Fact Sheet

## Quick Reference

**Exam Code:** 200-301
**Duration:** 120 minutes
**Format:** Multiple choice + drag-and-drop + simulation/lab items
**Cost:** $300 USD
**Validity:** 3 years

**[📖 Cisco Learning Network CCNA hub](https://learningnetwork.cisco.com/s/ccna)**
**[📖 Official 200-301 exam topics](https://learningnetwork.cisco.com/s/ccna-exam-topics)**

---

## Domain Weights

| Domain | Weight |
|---|---|
| 1.0 Network Fundamentals | 20% |
| 2.0 Network Access | 20% |
| 3.0 IP Connectivity | 25% |
| 4.0 IP Services | 10% |
| 5.0 Security Fundamentals | 15% |
| 6.0 Automation and Programmability | 10% |

---

## OSI vs TCP/IP

| OSI | TCP/IP | Examples |
|---|---|---|
| 7. Application | Application | HTTP, HTTPS, FTP, DNS, SSH |
| 6. Presentation | Application | TLS, JPEG, ASCII |
| 5. Session | Application | NetBIOS, RPC |
| 4. Transport | Transport | TCP, UDP |
| 3. Network | Internet | IP, ICMP, OSPF, BGP |
| 2. Data Link | Network Access | Ethernet, PPP, ARP, VLAN, STP |
| 1. Physical | Network Access | Cables, hubs, signals |

---

## Common Port Numbers (memorize)

| Port | Protocol |
|---|---|
| 20/21 | FTP (data/control) |
| 22 | SSH / SCP / SFTP |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 67/68 | DHCP (server/client) |
| 69 | TFTP |
| 80 | HTTP |
| 110 | POP3 |
| 123 | NTP |
| 143 | IMAP |
| 161/162 | SNMP / SNMP traps |
| 443 | HTTPS |
| 514 | Syslog |
| 636 | LDAPS |
| 993 | IMAPS |
| 3389 | RDP |

---

## IPv4 Subnetting Cheat Sheet

| CIDR | Mask | # Hosts | Wildcard |
|---|---|---:|---|
| /24 | 255.255.255.0 | 254 | 0.0.0.255 |
| /25 | 255.255.255.128 | 126 | 0.0.0.127 |
| /26 | 255.255.255.192 | 62 | 0.0.0.63 |
| /27 | 255.255.255.224 | 30 | 0.0.0.31 |
| /28 | 255.255.255.240 | 14 | 0.0.0.15 |
| /29 | 255.255.255.248 | 6 | 0.0.0.7 |
| /30 | 255.255.255.252 | 2 | 0.0.0.3 |
| /31 | 255.255.255.254 | 0 (P2P) | 0.0.0.1 |
| /23 | 255.255.254.0 | 510 | 0.0.1.255 |
| /22 | 255.255.252.0 | 1022 | 0.0.3.255 |
| /20 | 255.255.240.0 | 4094 | 0.0.15.255 |
| /16 | 255.255.0.0 | 65534 | 0.0.255.255 |

`# Hosts = 2^h - 2` where h is host bits.

### Quick subnetting trick

For /N where 24 < N < 32:

- Bits in last octet = `N - 24`
- Block size = `2^(8 - bits_in_last_octet) = 256 - mask_value`

Example: /27 has 3 host-bit borrows; mask = 224; block size = 32. Subnets: 0, 32, 64, 96, 128, 160, 192, 224.

### Reserved IP ranges

- **127.0.0.0/8** - loopback
- **169.254.0.0/16** - APIPA (link-local)
- **0.0.0.0** - unspecified / default route
- **255.255.255.255** - limited broadcast

### Private (RFC 1918)

- **10.0.0.0/8**
- **172.16.0.0/12** (172.16.x.x - 172.31.x.x)
- **192.168.0.0/16**

---

## IPv6 Basics

- **128 bits**, written as 8 groups of 4 hex digits.
- **Compress** consecutive zero groups with `::` (only once per address).
- **Loopback:** `::1`
- **Unspecified:** `::`
- **Link-local:** `fe80::/10`
- **Unique local:** `fc00::/7` (RFC 4193, like IPv4 private)
- **Multicast:** `ff00::/8`
- **Global unicast:** `2000::/3`

### EUI-64

Auto-generate the host portion of an IPv6 address from the MAC:

1. Split the 48-bit MAC in half.
2. Insert `FFFE` in the middle.
3. Flip the 7th bit of the first byte (universally administered → locally administered).

---

## Cisco IOS Command Cheat Sheet

### Modes

```
Switch>                  user EXEC mode
Switch> enable
Switch#                  privileged EXEC mode
Switch# configure terminal
Switch(config)#          global config
Switch(config-if)#       interface config
Switch(config-vlan)#     VLAN config
Switch(config-router)#   routing protocol config
```

### Common configuration

```bash
hostname R1
no ip domain-lookup        # disable DNS lookups for typos
service password-encryption
enable secret cisco123
line console 0
 password cisco
 login
 logging synchronous
line vty 0 4
 transport input ssh
 login local
username admin privilege 15 secret cisco
```

### SSH setup (most common)

```
hostname R1
ip domain-name example.com
crypto key generate rsa modulus 2048
username admin privilege 15 secret cisco
line vty 0 4
 transport input ssh
 login local
exit
ip ssh version 2
```

### Interface config

```
interface gi0/1
 description Uplink to core
 ip address 192.168.1.1 255.255.255.0
 no shutdown

interface vlan 10
 ip address 10.10.10.1 255.255.255.0
 no shutdown
```

### Static route

```
ip route 0.0.0.0 0.0.0.0 192.168.1.1               # default route
ip route 10.0.0.0 255.0.0.0 10.10.10.1
ip route 10.20.0.0 255.255.0.0 GigabitEthernet0/1   # via interface
```

### OSPF (single area)

```
router ospf 1
 router-id 1.1.1.1
 network 10.0.0.0 0.0.255.255 area 0
 network 192.168.1.0 0.0.0.255 area 0
 passive-interface default
 no passive-interface gi0/1
```

### VLANs (switch)

```
vlan 10
 name SALES
vlan 20
 name ENG

interface fa0/1
 switchport mode access
 switchport access vlan 10

interface gi0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30
 switchport trunk native vlan 99
```

### Inter-VLAN routing on a router (router-on-a-stick)

```
interface gi0/0.10
 encapsulation dot1q 10
 ip address 10.10.10.1 255.255.255.0

interface gi0/0.20
 encapsulation dot1q 20
 ip address 10.10.20.1 255.255.255.0
```

### Inter-VLAN routing on L3 switch (SVI)

```
ip routing
interface vlan 10
 ip address 10.10.10.1 255.255.255.0
 no shutdown

interface vlan 20
 ip address 10.10.20.1 255.255.255.0
 no shutdown
```

### EtherChannel

```
interface range gi0/1 - 2
 channel-group 1 mode active                 # LACP
 ! or "channel-group 1 mode desirable"       # PAgP
 ! or "channel-group 1 mode on"              # static (no negotiation)
```

### Port security

```
interface fa0/1
 switchport mode access
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation restrict   # protect | restrict | shutdown
```

### NAT (PAT - port address translation)

```
ip nat inside source list 1 interface gi0/1 overload
access-list 1 permit 10.0.0.0 0.255.255.255
interface gi0/0
 ip nat inside
interface gi0/1
 ip nat outside
```

### DHCP server on Cisco router

```
ip dhcp excluded-address 10.10.10.1 10.10.10.10
ip dhcp pool LAN
 network 10.10.10.0 /24
 default-router 10.10.10.1
 dns-server 8.8.8.8
 lease 7
```

### NTP client

```
ntp server 10.0.0.1
clock timezone EST -5
clock summer-time EDT recurring
```

### Syslog

```
logging host 10.0.0.50
logging trap informational
service timestamps log datetime msec
```

### ACL (access list)

```
! Standard (1-99): match by source IP only
access-list 10 permit 10.0.0.0 0.255.255.255
access-list 10 deny any log
interface gi0/1
 ip access-group 10 in

! Extended (100-199): match by source, dest, protocol, ports
access-list 110 permit tcp 10.0.0.0 0.255.255.255 any eq 80
access-list 110 permit tcp 10.0.0.0 0.255.255.255 any eq 443
access-list 110 deny ip any any log

! Named ACL (preferred)
ip access-list extended WEB-ONLY
 permit tcp 10.0.0.0 0.255.255.255 any eq 80
 permit tcp 10.0.0.0 0.255.255.255 any eq 443
 deny ip any any log
interface gi0/1
 ip access-group WEB-ONLY in
```

### show / debug commands (high-yield)

```
show running-config
show startup-config
show ip interface brief                      # quick interface status
show interfaces                              # detailed
show interfaces gi0/1                        # specific
show vlan brief
show vlan id 10
show interfaces trunk
show etherchannel summary
show spanning-tree
show ip route
show ip route 192.168.1.0
show ip ospf
show ip ospf neighbor
show ip ospf interface
show ip protocols
show ip nat translations
show ip nat statistics
show ip dhcp binding
show port-security
show port-security interface fa0/1
show ssh
show users
show clock
show mac address-table
show cdp neighbors
show cdp neighbors detail
show lldp neighbors
show version
```

---

## Spanning Tree (STP)

- **STP** (802.1D) - blocks redundant paths to prevent loops. Default in older switches; convergence ~30s.
- **RSTP** (802.1w) - faster convergence (~6s). Default in modern Cisco.
- **PVST+** - per-VLAN STP. Each VLAN has its own STP topology.
- **Rapid-PVST+** - per-VLAN RSTP. Cisco default.
- **MSTP** (802.1s) - groups VLANs into instances.

### Bridge ID and root election

- Bridge ID = priority + MAC. Lowest BID = root.
- Default priority = 32768. Lower priority wins.
- `spanning-tree vlan 10 priority 4096` to make a switch the root for VLAN 10.
- `spanning-tree vlan 10 root primary` (sets priority to 24576 or 4096 less than current root).

### Port roles

- **Root port** - on a non-root switch, the port closest to the root.
- **Designated port** - on each segment, the port that forwards toward leaf.
- **Alternate / blocked port** - blocking port to prevent loop.

### Port states

`Disabled → Blocking → Listening → Learning → Forwarding` (STP)
`Discarding → Learning → Forwarding` (RSTP)

### PortFast

```
spanning-tree portfast default
interface fa0/1
 spanning-tree portfast
 spanning-tree bpduguard enable
```

PortFast skips listening/learning for end-host ports. BPDUguard shuts the port if a BPDU arrives (someone plugged in a switch).

---

## OSPF Quick Reference

- **Type:** Link-state
- **Algorithm:** Dijkstra (SPF)
- **Cost metric:** Reference bandwidth / interface bandwidth
- **Default reference bandwidth:** 100 Mbps (so 1Gbps and 10Gbps both end up cost=1; bump with `auto-cost reference-bandwidth 100000`)
- **Hello interval:** 10s on broadcast, 30s on NBMA
- **Dead interval:** 4× hello (40s / 120s)
- **Multicast addresses:** 224.0.0.5 (all OSPF), 224.0.0.6 (DR/BDR)
- **Router ID:** highest configured loopback IP, else highest active interface IP, or manually with `router-id`
- **Areas:** Single-area is on CCNA. Backbone is `area 0`. All areas connect to area 0.
- **Neighbor states:** Down → Init → 2-way → Exstart → Exchange → Loading → Full

### Adjacency requirements (must match)

- Hello / dead intervals
- Area ID
- Subnet (same subnet on the same OSPF interface)
- MTU
- Authentication (if enabled)
- Stub flags

If `show ip ospf neighbor` shows stuck in `Init` or `Exstart`, check these.

---

## First-Hop Redundancy (concept-level)

| Protocol | Vendor | Notes |
|---|---|---|
| **HSRP** | Cisco proprietary | Active/standby, virtual MAC `0000.0c07.acXX` |
| **VRRP** | Open standard (RFC 5798) | Master/backup |
| **GLBP** | Cisco proprietary | Active/active load balancing |

You won't be asked to configure these in depth on CCNA, just to recognize concepts and choose between them.

---

## Wireless Quick Reference

- **WLC** (Wireless LAN Controller) manages lightweight APs (LWAPP / CAPWAP).
- **Autonomous AP** has its own config; **Lightweight AP** depends on WLC.
- **CAPWAP** has separate control (5246) and data (5247) channels.
- **2.4 GHz** has channels 1, 6, 11 (non-overlapping in US).
- **5 GHz** has many non-overlapping channels.
- **Security:** WPA2-PSK (PSK), WPA2-Enterprise (802.1X), WPA3 (newer).

---

## Automation Quick Reference

- **REST API:** stateless HTTP-based. GET/POST/PUT/PATCH/DELETE. Body usually JSON.
- **JSON:** key-value, arrays, nested. Most APIs use it.
- **YAML:** indentation-based; common for configs (Ansible playbooks).
- **SDN:** Software-Defined Networking - separate control plane from data plane. Examples: Cisco DNA Center, Cisco SD-WAN, OpenFlow.
- **Traditional vs SDN:** traditional has distributed control (each device); SDN has centralized control via a controller.
- **Configuration management:** Ansible (agentless, SSH/network plugins), Puppet (agent-based), Chef (agent-based).

### Ansible playbook example

```yaml
- name: Configure interfaces
  hosts: routers
  gather_facts: no
  tasks:
    - name: Set hostname
      cisco.ios.ios_config:
        lines:
          - hostname R1
    - name: Configure GigabitEthernet0/1
      cisco.ios.ios_config:
        lines:
          - description Uplink
          - ip address 192.168.1.1 255.255.255.0
          - no shutdown
        parents: interface GigabitEthernet0/1
```

---

## Things candidates commonly forget

- **`no shutdown`** is required after configuring an interface.
- **`copy running-config startup-config`** to save (or `write memory`).
- **Wildcard mask** in OSPF / ACL is INVERTED from subnet mask (e.g., 255.255.255.0 → 0.0.0.255).
- **PortFast / BPDUguard** belong on access ports facing endpoints, not trunks.
- **Trunk native VLAN** must match on both sides (default 1; common to change to 99 to avoid).
- **OSPF router-id** sticks until cleared; reload or `clear ip ospf process` to apply changes.
- **Loopbacks** are always up; useful as router-id source.
- **`switchport mode access`** on user-facing ports prevents trunk negotiation issues (DTP).

---

## High-yield memorization list

- All port numbers in the table above
- Subnetting: be able to do /24 → /30 quickly without paper
- OSI vs TCP/IP layers and example protocols at each
- STP timers (default), port states, bridge ID
- OSPF metrics, neighbor states, adjacency requirements
- VLAN trunking with 802.1Q
- ACL placement: standard near destination, extended near source
- NAT: inside local / inside global / outside local / outside global terminology
- AAA: TACACS+ encrypts entire packet; RADIUS only password
