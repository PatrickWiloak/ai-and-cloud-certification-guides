# CompTIA Network+ (N10-009) Fact Sheet

## Quick Reference

**Exam Code:** N10-009
**Duration:** 90 minutes
**Questions:** Up to 90 (MCQ + performance-based)
**Passing Score:** 720/900
**Cost:** $369 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Networking Concepts | 23% | OSI, ports/protocols, IP addressing, subnetting, services, topologies |
| Network Implementation | 20% | Routing, switching, VLANs, STP, wireless |
| Network Operations | 19% | Documentation, monitoring, DR/BCP, organizational docs |
| Network Security | 14% | Threats, hardening, security devices, AAA, physical |
| Network Troubleshooting | 24% | Methodology, CLI/hardware tools, common issues |

## OSI Model

| Layer | Name | PDU | Devices | Examples |
|-------|------|-----|---------|----------|
| 7 | Application | Data | - | HTTP, HTTPS, FTP, SMTP, DNS, DHCP, SNMP |
| 6 | Presentation | Data | - | TLS/SSL encryption, JPEG, ASCII, MIME |
| 5 | Session | Data | - | NetBIOS, RPC, PPTP, session establishment |
| 4 | Transport | Segment (TCP) / Datagram (UDP) | - | TCP, UDP, ports |
| 3 | Network | Packet | Router, Layer 3 switch | IP, ICMP, IPsec, OSPF, BGP, EIGRP |
| 2 | Data Link | Frame | Switch, bridge, NIC, AP | Ethernet, MAC, ARP, 802.1Q, STP, PPP |
| 1 | Physical | Bits | Hub, repeater, cable, transceiver | Copper, fiber, wireless RF, RJ-45 |

**Mnemonic (top to bottom):** All People Seem To Need Data Processing
**Mnemonic (bottom to top):** Please Do Not Throw Sausage Pizza Away

**TCP/IP model mapping:**
- Application (OSI 5-7) -> HTTP, DNS, etc.
- Transport (OSI 4) -> TCP/UDP
- Internet (OSI 3) -> IP, ICMP
- Link / Network Access (OSI 1-2) -> Ethernet, Wi-Fi

## Common Ports and Protocols

### Memorize these for the exam

| Port | Protocol | TCP/UDP | Purpose |
|------|----------|---------|---------|
| 20 | FTP-Data | TCP | FTP data channel |
| 21 | FTP | TCP | FTP control channel |
| 22 | SSH / SCP / SFTP | TCP | Secure shell, secure copy, secure FTP |
| 23 | Telnet | TCP | Insecure remote shell |
| 25 | SMTP | TCP | Mail submission/relay |
| 53 | DNS | TCP/UDP | Name resolution (UDP for queries, TCP for zone transfer / >512 byte) |
| 67 | DHCP server | UDP | DHCP server listens here |
| 68 | DHCP client | UDP | DHCP client listens here |
| 69 | TFTP | UDP | Trivial FTP, no auth |
| 80 | HTTP | TCP | Web (cleartext) |
| 88 | Kerberos | TCP/UDP | Authentication |
| 110 | POP3 | TCP | Email retrieval |
| 119 | NNTP | TCP | Network news |
| 123 | NTP | UDP | Time synchronization |
| 137-139 | NetBIOS | TCP/UDP | Legacy Windows networking |
| 143 | IMAP | TCP | Email retrieval (server-side folders) |
| 161 | SNMP | UDP | Network management agent |
| 162 | SNMP trap | UDP | Asynchronous SNMP notification |
| 389 | LDAP | TCP/UDP | Directory services (cleartext) |
| 443 | HTTPS | TCP | HTTP over TLS |
| 445 | SMB | TCP | Windows file sharing (modern) |
| 465 | SMTPS (legacy) | TCP | SMTP over TLS (implicit) |
| 514 | Syslog | UDP | Centralized logging |
| 587 | SMTP submission | TCP | Authenticated mail submission with STARTTLS |
| 636 | LDAPS | TCP | LDAP over TLS |
| 989/990 | FTPS | TCP | FTP over TLS (data/control) |
| 993 | IMAPS | TCP | IMAP over TLS |
| 995 | POP3S | TCP | POP3 over TLS |
| 1433 | MS SQL | TCP | Microsoft SQL Server |
| 1521 | Oracle DB | TCP | Oracle database |
| 1645/1646 | RADIUS (legacy) | UDP | Older RADIUS ports |
| 1701 | L2TP | UDP | Layer 2 Tunneling Protocol |
| 1720 | H.323 | TCP | VoIP signaling |
| 1812/1813 | RADIUS | UDP | Authentication / accounting |
| 3306 | MySQL | TCP | MySQL database |
| 3389 | RDP | TCP/UDP | Remote Desktop Protocol |
| 5060 | SIP | TCP/UDP | VoIP signaling (cleartext) |
| 5061 | SIP-TLS | TCP | SIP over TLS |
| 5432 | PostgreSQL | TCP | PostgreSQL database |
| 5900 | VNC | TCP | Virtual Network Computing |
| 6514 | Syslog over TLS | TCP | Encrypted syslog |
| 8080 | HTTP-alt | TCP | Common alternate web port (proxies) |

### Tricky pairs to remember

| Insecure | Port | Secure equivalent | Port |
|----------|------|-------------------|------|
| FTP | 21 | SFTP / FTPS | 22 / 989-990 |
| Telnet | 23 | SSH | 22 |
| HTTP | 80 | HTTPS | 443 |
| SMTP | 25 | SMTPS / submission+TLS | 465 / 587 |
| LDAP | 389 | LDAPS | 636 |
| POP3 | 110 | POP3S | 995 |
| IMAP | 143 | IMAPS | 993 |
| SNMPv1/v2c | 161 | SNMPv3 | 161 |
| DNS | 53 | DNS over TLS / DoH | 853 / 443 |

## IPv4 Addressing

### Address Classes (legacy classful, still tested)

| Class | First Octet | Default Mask | CIDR | Hosts per network |
|-------|-------------|--------------|------|-------------------|
| A | 1-126 | 255.0.0.0 | /8 | 16,777,214 |
| B | 128-191 | 255.255.0.0 | /16 | 65,534 |
| C | 192-223 | 255.255.255.0 | /24 | 254 |
| D | 224-239 | - | - | Multicast |
| E | 240-255 | - | - | Reserved/experimental |

127.0.0.0/8 is loopback (not Class A in practice).

### Private (RFC 1918)

| Range | Mask | CIDR |
|-------|------|------|
| 10.0.0.0 - 10.255.255.255 | 255.0.0.0 | 10.0.0.0/8 |
| 172.16.0.0 - 172.31.255.255 | 255.240.0.0 | 172.16.0.0/12 |
| 192.168.0.0 - 192.168.255.255 | 255.255.0.0 | 192.168.0.0/16 |

### Other reserved ranges

| Range | Purpose |
|-------|---------|
| 127.0.0.0/8 | Loopback |
| 169.254.0.0/16 | APIPA / link-local (DHCP failure) |
| 100.64.0.0/10 | Carrier-grade NAT (RFC 6598) |
| 224.0.0.0/4 | Multicast |
| 0.0.0.0/8 | "This network" / default route prefix |
| 255.255.255.255 | Limited broadcast |

## Subnetting Cheat Sheet

### Powers of 2

| Bits | Value | Bits | Value |
|------|-------|------|-------|
| 1 | 2 | 9 | 512 |
| 2 | 4 | 10 | 1,024 |
| 3 | 8 | 11 | 2,048 |
| 4 | 16 | 12 | 4,096 |
| 5 | 32 | 13 | 8,192 |
| 6 | 64 | 14 | 16,384 |
| 7 | 128 | 15 | 32,768 |
| 8 | 256 | 16 | 65,536 |

### CIDR / mask / hosts (most common)

| CIDR | Subnet Mask | Wildcard | Host bits | Total IPs | Usable hosts |
|------|-------------|----------|-----------|-----------|--------------|
| /16 | 255.255.0.0 | 0.0.255.255 | 16 | 65,536 | 65,534 |
| /20 | 255.255.240.0 | 0.0.15.255 | 12 | 4,096 | 4,094 |
| /22 | 255.255.252.0 | 0.0.3.255 | 10 | 1,024 | 1,022 |
| /23 | 255.255.254.0 | 0.0.1.255 | 9 | 512 | 510 |
| /24 | 255.255.255.0 | 0.0.0.255 | 8 | 256 | 254 |
| /25 | 255.255.255.128 | 0.0.0.127 | 7 | 128 | 126 |
| /26 | 255.255.255.192 | 0.0.0.63 | 6 | 64 | 62 |
| /27 | 255.255.255.224 | 0.0.0.31 | 5 | 32 | 30 |
| /28 | 255.255.255.240 | 0.0.0.15 | 4 | 16 | 14 |
| /29 | 255.255.255.248 | 0.0.0.7 | 3 | 8 | 6 |
| /30 | 255.255.255.252 | 0.0.0.3 | 2 | 4 | 2 |
| /31 | 255.255.255.254 | 0.0.0.1 | 1 | 2 | 2 (point-to-point, RFC 3021) |
| /32 | 255.255.255.255 | 0.0.0.0 | 0 | 1 | 1 (host route) |

**Formula:** Usable hosts = 2^(host bits) - 2 (network and broadcast addresses).
**Exception:** /31 used for point-to-point links per RFC 3021 has 2 usable.

### Magic number trick

For a given /N mask, the "magic number" is 256 - last non-zero octet of the mask. Subnet boundaries fall on multiples of the magic number in that octet.

Example: 192.168.1.100/26
- Mask = 255.255.255.192, magic number = 256 - 192 = 64
- Subnets in fourth octet: .0, .64, .128, .192
- 100 falls in .64 subnet -> network 192.168.1.64, broadcast 192.168.1.127, usable .65 - .126

## IPv6

### Format
- 128 bits, written as 8 groups of 4 hex digits separated by colons
- Leading zeros in a group can be dropped: `2001:0db8:0000:0000:0000:0000:0000:0001` -> `2001:db8::1`
- Double colon `::` collapses one run of consecutive zero groups (only once per address)

### Address Types

| Prefix | Type | Notes |
|--------|------|-------|
| `2000::/3` | Global unicast | Internet-routable, equivalent to public IPv4 |
| `fc00::/7` | Unique local (ULA) | Equivalent to RFC 1918 private |
| `fe80::/10` | Link-local | Auto-assigned per interface, never routed |
| `ff00::/8` | Multicast | No broadcast in IPv6 |
| `::1/128` | Loopback | Equivalent to 127.0.0.1 |
| `::/128` | Unspecified | Equivalent to 0.0.0.0 |
| `2001:db8::/32` | Documentation | Use in examples |

### Address assignment
- **SLAAC** - Stateless Address Autoconfig: derives address from prefix + interface ID (EUI-64 or random)
- **DHCPv6** - Stateful, similar to DHCPv4
- **EUI-64** - Builds last 64 bits from 48-bit MAC: split MAC, insert ff:fe in middle, flip 7th bit

### Key differences from IPv4
- No broadcast (uses multicast)
- No NAT typically (every host is globally addressable)
- Built-in IPsec support (originally mandatory, now recommended)
- Neighbor Discovery Protocol (NDP) replaces ARP, uses ICMPv6
- No fragmentation by routers (only by source)

## Cable Types and Standards

### Twisted Pair Copper

| Category | Max Speed | Max Distance | Frequency | Common use |
|----------|-----------|--------------|-----------|------------|
| Cat 3 | 10 Mbps | 100 m | 16 MHz | Legacy phone, 10BASE-T |
| Cat 5 | 100 Mbps | 100 m | 100 MHz | 100BASE-TX (Fast Ethernet) |
| Cat 5e | 1 Gbps | 100 m | 100 MHz | 1000BASE-T (Gigabit), most common legacy |
| Cat 6 | 1 Gbps (10 Gbps to 55 m) | 100 m / 55 m for 10G | 250 MHz | Modern enterprise |
| Cat 6a | 10 Gbps | 100 m | 500 MHz | 10GBASE-T full distance |
| Cat 7 | 10 Gbps | 100 m | 600 MHz | Shielded, less common |
| Cat 8 | 25/40 Gbps | 30 m | 2000 MHz | Data center top-of-rack |

**Shielding codes:** UTP (unshielded), STP / FTP (shielded/foiled), S/FTP (overall braid + foiled pairs).

### Fiber

| Type | Mode | Wavelength | Max Distance | Color jacket |
|------|------|------------|--------------|--------------|
| OM1 | Multi-mode 62.5/125 | 850/1300 nm | 33 m at 10G | Orange |
| OM2 | Multi-mode 50/125 | 850/1300 nm | 82 m at 10G | Orange |
| OM3 | Multi-mode 50/125 (laser optimized) | 850 nm | 300 m at 10G | Aqua |
| OM4 | Multi-mode 50/125 | 850 nm | 400 m at 10G | Aqua / erika violet |
| OM5 | Multi-mode wideband | 850-953 nm | 400 m at 10G, supports SWDM | Lime green |
| OS1 | Single-mode | 1310/1550 nm | ~10 km | Yellow |
| OS2 | Single-mode | 1310/1550 nm | ~40+ km | Yellow |

**Connector types:** LC (small form, common in data centers), SC (square push-pull), ST (bayonet, legacy), MTRJ, MPO/MTP (ribbon, multi-fiber), FC (screw-on).

### Ethernet Standards

| Standard | Speed | Media | Max Distance |
|----------|-------|-------|--------------|
| 10BASE-T | 10 Mbps | Cat 3+ | 100 m |
| 100BASE-TX | 100 Mbps | Cat 5+ | 100 m |
| 1000BASE-T | 1 Gbps | Cat 5e+ | 100 m |
| 1000BASE-SX | 1 Gbps | MMF | 220-550 m |
| 1000BASE-LX | 1 Gbps | SMF | 5 km |
| 10GBASE-T | 10 Gbps | Cat 6a/7 | 100 m (Cat 6 to 55 m) |
| 10GBASE-SR | 10 Gbps | MMF | 300-400 m |
| 10GBASE-LR | 10 Gbps | SMF | 10 km |
| 40GBASE-SR4 | 40 Gbps | MMF (MPO) | 100-150 m |
| 100GBASE-SR4 | 100 Gbps | MMF (MPO) | 70-100 m |

### Wiring

| Standard | Pin pairs | Use case |
|----------|-----------|----------|
| **T568A** | Green/white-green / orange/white-orange / blue/white-blue / brown/white-brown | Residential (older), US gov |
| **T568B** | Orange/white-orange / green/white-green / blue/white-blue / brown/white-brown | Most common in commercial |
| **Straight-through** | Same standard both ends (B-B or A-A) | Host-to-switch, switch-to-router |
| **Crossover** | A on one end, B on other | Same-device-type connection (legacy; modern Auto-MDIX makes obsolete) |
| **Rollover (console)** | Reversed pin order | Cisco console cable |

## Wireless

### 802.11 Standards

| Standard | Wi-Fi name | Frequency | Max Speed (theoretical) | MIMO |
|----------|-----------|-----------|-------------------------|------|
| 802.11a | - | 5 GHz | 54 Mbps | No |
| 802.11b | - | 2.4 GHz | 11 Mbps | No |
| 802.11g | - | 2.4 GHz | 54 Mbps | No |
| 802.11n | Wi-Fi 4 | 2.4/5 GHz | 600 Mbps | Yes (4x4) |
| 802.11ac | Wi-Fi 5 | 5 GHz | 6.9 Gbps | MU-MIMO (DL) |
| 802.11ax | Wi-Fi 6 / 6E | 2.4/5/6 GHz | 9.6 Gbps | MU-MIMO (UL+DL), OFDMA |
| 802.11be | Wi-Fi 7 | 2.4/5/6 GHz | 46 Gbps | 320 MHz channels, MLO |

**Channels to know:**
- 2.4 GHz: only channels 1, 6, 11 are non-overlapping in North America (each 22 MHz wide)
- 5 GHz: many non-overlapping 20 MHz channels; some require DFS (Dynamic Frequency Selection) due to radar
- 6 GHz: 7 non-overlapping 80 MHz or 14 non-overlapping 40 MHz channels (Wi-Fi 6E)

### Wireless Security

| Standard | Encryption | Authentication | Notes |
|----------|-----------|----------------|-------|
| WEP | RC4 (broken) | Static key | Deprecated, never use |
| WPA | TKIP | PSK or 802.1X | Legacy, broken |
| WPA2 | AES-CCMP | PSK or 802.1X | Long-time standard, KRACK vulnerable |
| WPA3 | AES-GCMP-256 (Enterprise) / SAE | SAE (Personal), 802.1X+SuiteB (Enterprise) | Current, mandatory PMF |

**802.1X / EAP variants:**
- **EAP-TLS** - Mutual cert-based, strongest, requires client certs
- **EAP-TTLS** - Server cert + tunneled inner auth
- **PEAP** - Server cert + tunneled MS-CHAPv2 (most common Windows)
- **EAP-FAST** - Cisco, uses PAC instead of cert
- **LEAP** - Cisco legacy, broken, do not use

## Routing

### Administrative Distance (Cisco defaults)

| Source | AD |
|--------|----|
| Connected interface | 0 |
| Static route | 1 |
| EBGP | 20 |
| EIGRP (internal) | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |
| EIGRP (external) | 170 |
| IBGP | 200 |
| Unknown / unreachable | 255 |

### Routing Protocol Comparison

| Protocol | Type | Algorithm | Metric | Open/Proprietary |
|----------|------|-----------|--------|------------------|
| RIP / RIPv2 | Distance vector | Bellman-Ford | Hop count (max 15) | Open |
| OSPF | Link state | Dijkstra SPF | Cost (bandwidth-based) | Open |
| EIGRP | Advanced distance vector / hybrid | DUAL | Composite (BW, delay) | Open (was Cisco-only) |
| IS-IS | Link state | Dijkstra SPF | Cost | Open (ISP backbone) |
| BGP | Path vector | Best path selection | AS-path + attributes | Open (internet routing) |

## Switching

### Spanning Tree Protocol (STP)

| Standard | Name | Convergence |
|----------|------|-------------|
| 802.1D | STP | 30-50 sec |
| 802.1w | RSTP (Rapid STP) | <10 sec |
| 802.1s | MSTP (Multiple STP) | Per VLAN group |
| Cisco PVST+ | Per-VLAN STP | One instance per VLAN |

**Port states (RSTP):** Discarding, Learning, Forwarding (legacy STP also had Listening, Blocking).
**Port roles:** Root, Designated, Alternate, Backup.

**Protections:** BPDU Guard (disables port if BPDU received on access port), Root Guard (prevents downstream switch from becoming root), Loop Guard, PortFast (skip listening/learning on access ports).

### VLAN and Trunking

- **802.1Q** - Industry standard VLAN tagging, inserts 4-byte tag (TPID 0x8100 + 12-bit VLAN ID)
- **Native VLAN** - Untagged traffic on a trunk; default VLAN 1 (security best practice: change to unused VLAN)
- **VLAN range** - 1-4094 (12 bits); 1, 1002-1005 reserved on Cisco
- **Voice VLAN** - Separate VLAN for IP phones, often via CDP/LLDP-MED auto-config
- **VTP** - Cisco VLAN Trunking Protocol; modes server/client/transparent

### Link Aggregation

- **LACP (802.3ad)** - Industry standard, active or passive negotiation
- **PAgP** - Cisco proprietary, modes auto/desirable
- **Static / "on"** - No negotiation, both sides must match exactly

## Network Services

### DHCP Process (DORA)

1. **Discover** - Client broadcasts DHCPDISCOVER (src 0.0.0.0, dst 255.255.255.255, UDP 67)
2. **Offer** - Server replies with DHCPOFFER (proposed lease)
3. **Request** - Client broadcasts DHCPREQUEST for chosen offer
4. **Acknowledge** - Server confirms with DHCPACK

**DHCP relay / IP helper:** Forwards broadcast DHCP requests across subnets to a central DHCP server.
**Reservation:** Specific IP tied to a MAC address.
**Exclusion:** IP excluded from the pool.
**Lease time:** How long client can use the address before renewing.

### DNS Record Types

| Record | Purpose |
|--------|---------|
| **A** | Hostname -> IPv4 |
| **AAAA** | Hostname -> IPv6 |
| **CNAME** | Alias to another name |
| **MX** | Mail exchanger (priority) |
| **NS** | Authoritative name server for zone |
| **SOA** | Start of authority (zone metadata) |
| **PTR** | Reverse: IP -> hostname |
| **TXT** | Arbitrary text (SPF, DKIM, domain verification) |
| **SRV** | Service location (used by AD, SIP) |
| **CAA** | Authorized certificate issuers |

**DNS hierarchy:** Root (.) -> TLD (.com) -> Domain (example.com) -> Subdomain (www.example.com).
**Recursive resolver** asks on behalf of the client; **authoritative server** holds the actual records.

### Other services

| Service | Purpose | Port |
|---------|---------|------|
| **NTP** | Time sync (stratum 0 = atomic clock; stratum 16 = unsynced) | UDP 123 |
| **SNMP** | Network monitoring; v1/v2c use community strings, v3 adds auth + encryption | UDP 161, traps 162 |
| **Syslog** | Centralized logging; severities 0-7 (Emergency to Debug) | UDP 514 |
| **NetFlow / sFlow / IPFIX** | Flow telemetry for traffic analysis | UDP (varies) |

## Command Reference

### Windows / Linux equivalents

| Task | Windows | Linux/macOS |
|------|---------|-------------|
| Show IP config | `ipconfig /all` | `ip addr` / `ifconfig` |
| Renew DHCP | `ipconfig /renew` | `dhclient -r && dhclient` |
| Flush DNS | `ipconfig /flushdns` | `systemd-resolve --flush-caches` / `dscacheutil -flushcache` (macOS) |
| Test reachability | `ping` | `ping` |
| Trace route | `tracert` | `traceroute` (UDP) / `traceroute -I` (ICMP) |
| Combined ping+trace | `pathping` | `mtr` |
| Show routing table | `route print` / `netstat -r` | `ip route` / `route -n` |
| Show ARP cache | `arp -a` | `ip neigh` / `arp -a` |
| Show connections | `netstat -ano` | `ss -tunap` / `netstat -tunap` |
| DNS lookup | `nslookup` | `dig` / `host` / `nslookup` |
| Capture packets | `pktmon` (Win10+) | `tcpdump` |
| Port scan | `nmap` | `nmap` |
| Bandwidth test | `iperf3` | `iperf3` |

### Quick examples

```
ping -c 4 8.8.8.8                  # Linux: 4 echo requests
ping -n 4 8.8.8.8                  # Windows: 4 echo requests
tracert -d www.example.com         # No reverse DNS, faster
traceroute -I 8.8.8.8              # Use ICMP instead of UDP
dig example.com MX +short          # Just the MX records
nslookup -type=AAAA example.com    # Query IPv6 record
ip -br addr                        # Linux: brief interface summary
ss -tlnp                           # Linux: listening TCP sockets with PIDs
netstat -anob                      # Windows: ports + binary owning them
nmap -sS -p 22,80,443 10.0.0.0/24  # SYN scan three ports across subnet
tcpdump -ni eth0 host 1.2.3.4 and port 53
```

## Hardware Tools

| Tool | Purpose |
|------|---------|
| **Cable tester** | Verify continuity, pinout, identify breaks |
| **Tone generator + probe (fox and hound)** | Trace cable runs through walls/bundles |
| **OTDR** | Optical Time-Domain Reflectometer - measures fiber length, finds breaks/bends |
| **Light meter / OPM** | Measure optical power on fiber |
| **Multimeter** | Voltage, continuity, resistance |
| **Loopback adapter / plug** | Test NIC port functionality |
| **Wi-Fi analyzer** | Survey channels, signal strength, interference, AP placement |
| **Spectrum analyzer** | Identify non-Wi-Fi RF interference (microwaves, baby monitors) |
| **Punch-down tool (110/66)** | Terminate cables on patch panels and 110/66 blocks |
| **Crimper** | Attach RJ-45/RJ-11 connectors |
| **Cable certifier** | Verify Cat 5e/6/6a meets standard for distance, attenuation, NEXT |
| **Protocol analyzer** | Wireshark or hardware tap to capture frames |

## Troubleshooting Methodology (CompTIA 7-step)

1. **Identify the problem** - Gather info, question users, identify symptoms, determine if multiple problems, document approach + scope
2. **Establish a theory of probable cause** - Question the obvious, consider OSI bottom-up
3. **Test the theory** - If confirmed, plan next steps; if not, re-establish theory or escalate
4. **Establish a plan of action** - Document fix, identify potential side effects
5. **Implement the solution** - Or escalate as necessary
6. **Verify full system functionality** - Implement preventive measures
7. **Document findings, actions, outcomes** - Update KB, runbook, change log

## High-Yield Memorizables

### CIA in networking
- **Confidentiality** - Encryption (IPsec, TLS), VLAN segmentation, ACLs
- **Integrity** - Hashing in IPsec/TLS, port security, DAI
- **Availability** - Redundancy (HSRP/VRRP, link agg, dual-homing), DDoS protection

### Acronyms cheat sheet
- **APIPA** - Automatic Private IP Addressing (169.254.0.0/16)
- **CIDR** - Classless Inter-Domain Routing
- **VLSM** - Variable Length Subnet Masking
- **NAT/PAT** - Network/Port Address Translation
- **VLAN** - Virtual LAN
- **VPN** - Virtual Private Network
- **MTU** - Maximum Transmission Unit (default 1500 Ethernet)
- **MSS** - Maximum Segment Size (typically MTU - 40)
- **PoE** - Power over Ethernet (802.3af 15.4W, at 30W, bt 60-100W)
- **HSRP / VRRP / GLBP** - First-hop redundancy (Cisco / open / Cisco load balancing)
- **SDN / SD-WAN** - Software-Defined Networking / Wide Area Network
- **NFV** - Network Function Virtualization
- **CASB** - Cloud Access Security Broker
- **SASE** - Secure Access Service Edge
- **ZTNA** - Zero Trust Network Access

### Documentation
- **[CompTIA Network+ Certification Page](https://www.comptia.org/certifications/network)** - Official cert info
- **[N10-009 Exam Objectives PDF](https://www.comptia.org/certifications/network#examdetails)** - Definitive scope
- **[RFC Editor](https://www.rfc-editor.org/)** - Source for protocol specs (RFC 791 IPv4, 8200 IPv6, 2131 DHCP, 1035 DNS)
- **[Wireshark Sample Captures](https://wiki.wireshark.org/SampleCaptures)** - Practice protocol analysis

---

**Good luck on your exam!** Network+ rewards memorization of ports, masks, and tools combined with the OSI bottom-up reflex on every troubleshooting scenario.
