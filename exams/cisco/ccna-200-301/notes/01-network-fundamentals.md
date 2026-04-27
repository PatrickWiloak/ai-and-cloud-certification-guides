# 01 - Network Fundamentals (Domain 1, 20%)

## OSI vs TCP/IP

(See [fact-sheet.md](../fact-sheet.md) for the layered table.) Memorize what protocols live at each layer.

### Why OSI vs TCP/IP

OSI is a teaching model with 7 layers. TCP/IP is the operational model with 4 layers. Cisco still tests OSI; real networks run TCP/IP.

Most CCNA questions ask "at which layer does X operate?" Examples:

- **TCP** - layer 4 (Transport)
- **UDP** - layer 4
- **IP** - layer 3 (Network)
- **ICMP** - layer 3 (network-layer, but encapsulated in IP)
- **MAC addresses, ARP, VLANs, STP** - layer 2 (Data Link)
- **Hubs, repeaters, cabling** - layer 1 (Physical)
- **Switches** - layer 2 (some are layer 3 capable)
- **Routers** - layer 3
- **Firewalls** - varies (L3, L4, L7 depending on type)
- **Load balancers** - L4 or L7
- **HTTP, DNS, DHCP, FTP** - layer 7 (Application)

---

## TCP vs UDP

| Feature | TCP | UDP |
|---|---|---|
| Connection | Connection-oriented (3-way handshake) | Connectionless |
| Reliability | Acknowledged, retransmitted | Best-effort |
| Ordering | Guaranteed | Not guaranteed |
| Header size | 20 bytes minimum | 8 bytes |
| Use cases | Web, email, SSH | DNS, VoIP, streaming, gaming, DHCP |

### TCP 3-way handshake

`SYN → SYN/ACK → ACK`

### TCP teardown

`FIN → ACK → FIN → ACK`

---

## IP addressing

### IPv4 classes (legacy, but tested)

| Class | First-octet range | Default mask | Use |
|---|---|---|---|
| A | 1-126 | /8 | Large networks |
| B | 128-191 | /16 | Medium |
| C | 192-223 | /24 | Small |
| D | 224-239 | n/a | Multicast |
| E | 240-255 | n/a | Reserved |

127.0.0.0/8 is loopback (technically class A but reserved).

### Special / reserved IPv4

- **127.0.0.1** - loopback
- **169.254.0.0/16** - APIPA (link-local)
- **0.0.0.0** - default route / unspecified
- **255.255.255.255** - limited broadcast (not routed)

### Private (RFC 1918)

- **10.0.0.0/8**
- **172.16.0.0/12**
- **192.168.0.0/16**

### CIDR (Classless Inter-Domain Routing)

VLSM (Variable Length Subnet Masking) lets you carve subnets of varying sizes. Mandatory on CCNA.

---

## Subnetting (the most-tested skill)

### The pattern

For a /N subnet:

- **Host bits** = `32 - N`
- **# Hosts** = `2^host_bits - 2` (subtract 2 for network and broadcast)
- **# Subnets** in a parent network = `2^borrowed_bits`
- **Block size** = `256 - last_octet_of_mask` (for /N where 24 < N < 32)

### Worked example

Network: `192.168.10.0/26`

- /26 = 26 mask bits, 6 host bits
- # Hosts = 2^6 - 2 = 62
- Block size = 256 - 192 = 64
- Subnets in 192.168.10.0/24:
  - 192.168.10.0/26   (network), .1-.62 (hosts), .63 (broadcast)
  - 192.168.10.64/26  (network), .65-.126, .127 (broadcast)
  - 192.168.10.128/26 (network), .129-.190, .191 (broadcast)
  - 192.168.10.192/26 (network), .193-.254, .255 (broadcast)

### Practice

You should be able to instantly answer:

- "What's the network address of 10.20.30.45/27?" → block size 32 → 10.20.30.32
- "How many hosts in 172.16.0.0/22?" → 2^10 - 2 = 1022
- "What's the broadcast of 192.168.5.100/28?" → block size 16; this is in the .96 subnet → broadcast .111

If this isn't fast yet, drill it.

---

## IPv6

### Address structure

- 128 bits = 32 hex chars = 8 groups of 4
- Compress runs of zero groups with `::` (only once per address)
- `2001:0db8:0000:0000:0000:0000:0000:0001` = `2001:db8::1`

### Address types

| Type | Prefix |
|---|---|
| Loopback | `::1/128` |
| Unspecified | `::/128` |
| Link-local | `fe80::/10` (every IPv6-enabled interface gets one) |
| Unique local (private) | `fc00::/7` |
| Global unicast | `2000::/3` |
| Multicast | `ff00::/8` |

### Common multicast groups

- `ff02::1` - all nodes on segment
- `ff02::2` - all routers
- `ff02::5` - OSPFv3 all routers
- `ff02::9` - RIPng

### EUI-64

Auto-generates a 64-bit interface ID from a 48-bit MAC:

1. Split MAC: `aabb:ccdd:eeff` → `aabb:cc | dd:eeff`
2. Insert `fffe`: `aabb:cc | fffe | dd:eeff`
3. Flip 7th bit (universal/local): `a8bb:ccff:fedd:eeff`

### IPv6 address acquisition

- **Static**
- **SLAAC** (StateLess Address AutoConfiguration) using router advertisements
- **DHCPv6** (stateful) - similar to DHCPv4
- **DHCPv6-PD** (prefix delegation) - get an entire prefix, common for ISP-to-customer

---

## Wireless basics

### Frequency bands

- **2.4 GHz** - longer range, more interference, fewer non-overlapping channels (1, 6, 11 in NA)
- **5 GHz** - shorter range, less interference, many non-overlapping channels
- **6 GHz** (Wi-Fi 6E / Wi-Fi 7) - newest, even less interference

### Wireless architectures

- **Autonomous AP** - standalone, manages itself
- **Lightweight AP** + **WLC** (controller) - centralized management; APs use CAPWAP to talk to WLC
- **Cloud-managed** - APs phone home to a SaaS controller (Cisco Meraki)

### CAPWAP

- **Control channel:** UDP 5246
- **Data channel:** UDP 5247

---

## Network virtualization concepts

CCNA touches lightly on:

- **Virtual machines** - hypervisors (VMware ESXi, KVM, Hyper-V)
- **Containers** - Docker, Kubernetes; share OS kernel; lighter than VMs
- **Virtual switches** - vSwitch (VMware), Open vSwitch (KVM); software-defined L2 inside hypervisor
- **Cloud networking** - VPCs, route tables, internet gateways. The same TCP/IP, applied to managed cloud constructs.

---

## Cabling and topologies

| Cable | Use |
|---|---|
| Straight-through Ethernet | PC ↔ switch, router ↔ switch |
| Crossover | Switch ↔ switch (modern hardware auto-MDIX makes this less critical) |
| Console (rollover) | PC ↔ router/switch console port |
| Single-mode fiber (SMF) | Long distance (km) |
| Multi-mode fiber (MMF) | Short distance (datacenter) |

### Topology types

- **Star** - all nodes connect to a central switch (most common)
- **Mesh** - every node connects to every other (full mesh) or many (partial mesh)
- **Ring** - rare in modern enterprise
- **Bus** - legacy
- **Hybrid** - combination

---

## Verification commands you should know

```
show version                  # IOS version, uptime, boot info
show running-config           # current config
show startup-config           # saved config
show ip interface brief       # quick interface status
show interfaces               # detailed
show interfaces gi0/1
show interfaces description
show interfaces status
show mac address-table
show arp
show cdp neighbors
show cdp neighbors detail
show lldp neighbors
ping 8.8.8.8
ping 8.8.8.8 source loopback0
traceroute 8.8.8.8
```
