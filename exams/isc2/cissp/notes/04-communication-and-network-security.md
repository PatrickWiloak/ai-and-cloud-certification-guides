# 04 - Communication and Network Security (Domain 4, 13%)

## Domain Overview

Domain 4 covers network protocols, network architecture, secure communication, and the technologies enabling secure data transit. It is heavy on protocols, port numbers, and network device behavior. Understanding the OSI model end-to-end is foundational.

## OSI Reference Model

| Layer | Name | Examples | PDU |
|-------|------|----------|-----|
| 7 | Application | HTTP, HTTPS, FTP, SMTP, DNS, SNMP, SSH | Data |
| 6 | Presentation | TLS, SSL, JPEG, MPEG, ASCII, EBCDIC | Data |
| 5 | Session | NetBIOS, RPC, SQL, NFS, PPTP, SOCKS | Data |
| 4 | Transport | TCP, UDP, SCTP | Segment / Datagram |
| 3 | Network | IP, ICMP, IGMP, IPsec, OSPF, BGP, RIP | Packet |
| 2 | Data Link | Ethernet, ARP, PPP, MAC, switches | Frame |
| 1 | Physical | Cables, hubs, repeaters, NIC, voltages | Bit |

Mnemonics:
- All People Seem To Need Data Processing (top-down)
- Please Do Not Throw Sausage Pizza Away (bottom-up)

### TCP/IP Model
| TCP/IP Layer | OSI Layers |
|--------------|-----------|
| Application | 5, 6, 7 |
| Transport | 4 |
| Internet | 3 |
| Link / Network Access | 1, 2 |

## Common Protocols and Ports

| Port | Protocol | Service |
|------|----------|---------|
| 20/21 | TCP | FTP (data/control) |
| 22 | TCP | SSH, SFTP, SCP |
| 23 | TCP | Telnet (insecure) |
| 25 | TCP | SMTP |
| 53 | UDP/TCP | DNS |
| 67/68 | UDP | DHCP |
| 69 | UDP | TFTP |
| 80 | TCP | HTTP |
| 88 | TCP/UDP | Kerberos |
| 110 | TCP | POP3 |
| 111 | TCP/UDP | RPC portmapper |
| 119 | TCP | NNTP |
| 123 | UDP | NTP |
| 135 | TCP | MS RPC |
| 137-139 | TCP/UDP | NetBIOS |
| 143 | TCP | IMAP |
| 161/162 | UDP | SNMP / SNMP traps |
| 389 | TCP/UDP | LDAP |
| 443 | TCP | HTTPS |
| 445 | TCP | SMB |
| 465 | TCP | SMTPS |
| 500 | UDP | IKE (IPsec) |
| 514 | UDP | Syslog |
| 587 | TCP | SMTP submission (with STARTTLS) |
| 636 | TCP | LDAPS |
| 853 | TCP | DNS over TLS |
| 989/990 | TCP | FTPS |
| 993 | TCP | IMAPS |
| 995 | TCP | POP3S |
| 1433 | TCP | MSSQL |
| 1521 | TCP | Oracle DB |
| 1701 | UDP | L2TP |
| 1723 | TCP | PPTP (deprecated) |
| 1812/1813 | UDP | RADIUS |
| 3128/8080 | TCP | Proxy (common) |
| 3268/3269 | TCP | Global Catalog (LDAP) / GC over SSL |
| 3306 | TCP | MySQL |
| 3389 | TCP | RDP |
| 4500 | UDP | IPsec NAT-T |
| 5060/5061 | UDP/TCP | SIP / SIP-TLS |
| 5432 | TCP | PostgreSQL |

## TCP/IP Fundamentals

### TCP three-way handshake
SYN -> SYN/ACK -> ACK

### TCP four-way termination
FIN -> ACK -> FIN -> ACK (each side closes independently)

### TCP vs UDP
- TCP: connection-oriented, reliable, ordered, slower
- UDP: connectionless, unreliable, faster, low overhead (DNS queries, VoIP, streaming)

### IP addressing
- IPv4: 32-bit, dotted decimal, ~4.3B addresses
- IPv6: 128-bit, hexadecimal with colons, vast space
- Private ranges (RFC 1918): 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
- Loopback: 127.0.0.0/8 (IPv4), ::1 (IPv6)
- Link-local: 169.254.0.0/16 (IPv4), fe80::/10 (IPv6)
- Multicast: 224.0.0.0/4 (IPv4), ff00::/8 (IPv6)

### CIDR
- /24 = 256 addresses (254 usable)
- /16 = 65,536 addresses
- /8 = 16.7M addresses
- VLSM allows variable subnet sizes

### NAT types
- Static NAT - 1:1
- Dynamic NAT - many:many from pool
- PAT (NAPT) - many:1 with port translation

### IPv6 features
- Built-in IPsec support (often disabled in practice)
- No broadcast (replaced by multicast and anycast)
- SLAAC (Stateless Address Autoconfiguration)
- ND replaces ARP

## Network Devices

| Device | OSI Layer | Function |
|--------|-----------|----------|
| Hub | 1 | Repeats signals (legacy) |
| Bridge | 2 | Connects two LAN segments |
| Switch | 2 (3 if L3 switch) | Forwards by MAC |
| Router | 3 | Routes by IP |
| Firewall | 3-7 (NGFW) | Filters traffic |
| IDS | 3-7 | Detects threats (passive) |
| IPS | 3-7 | Detects and blocks (inline) |
| WAF | 7 | Application-layer filtering |
| Proxy | 7 | Forwarding/caching/filtering |
| Reverse proxy | 7 | Server-side proxy |
| Load balancer | 4 or 7 | Distributes traffic |
| Gateway | Variable | Translates between protocols |

### Firewall Types
- **Stateless (packet filter)** - rules on IP, port, protocol
- **Stateful** - tracks connection state
- **Application proxy** - terminates and reassembles
- **Next-Generation Firewall (NGFW)** - app-aware, identity, IPS, threat intel
- **Web Application Firewall (WAF)** - L7 specifically for web apps

### IDS/IPS
- **Signature-based** - known attack patterns
- **Anomaly-based / heuristic** - deviations from baseline
- **Behavior-based** - learned normal behavior
- **NIDS / NIPS** - network-based
- **HIDS / HIPS** - host-based

False positive vs false negative trade-off; tuning critical.

### Honeypots and Honeynets
- Decoy systems to detect, study, deter attackers
- Honeytokens: fake credentials placed to detect lateral movement
- Legal considerations (entrapment in some jurisdictions)

## Secure Network Design

### Defense in Depth Network Layers
- Perimeter (edge firewall, IDS/IPS)
- DMZ (publicly accessible services)
- Internal network (segmented)
- Sensitive zones (PCI, HR, R&D)
- Endpoint (host firewall, EDR)

### Network Segmentation
- VLANs (L2 segmentation)
- Subnets (L3 segmentation)
- VPNs (logical segmentation across networks)
- Microsegmentation (per-workload, often via SDN or service mesh)
- Air-gapping (physical isolation)

### Zero Trust Networking
- No implicit trust based on network location
- Verify every connection
- Identity-aware policies (user, device, app)
- Continuous evaluation
- BeyondCorp (Google), NIST SP 800-207

### SDN (Software-Defined Networking)
- Separation of control plane and data plane
- Centralized controller
- Programmable network (APIs)
- Enables microsegmentation, dynamic policy

### SD-WAN
- WAN built on SDN principles
- Uses multiple transport (MPLS, broadband, LTE/5G)
- Application-aware routing

### SASE (Secure Access Service Edge)
- Convergence of network (SD-WAN) and security (SWG, CASB, ZTNA, FWaaS)
- Cloud-delivered

### Network Access Control (NAC)
- Posture assessment before granting access
- 802.1X for port-based authentication
- Quarantine non-compliant devices

## Wireless Networks

### 802.11 Standards
| Standard | Frequency | Speed | Notes |
|----------|-----------|-------|-------|
| 802.11a | 5 GHz | 54 Mbps | Older |
| 802.11b | 2.4 GHz | 11 Mbps | Legacy |
| 802.11g | 2.4 GHz | 54 Mbps | Legacy |
| 802.11n (Wi-Fi 4) | 2.4/5 GHz | 600 Mbps | MIMO |
| 802.11ac (Wi-Fi 5) | 5 GHz | 1+ Gbps | MU-MIMO |
| 802.11ax (Wi-Fi 6/6E) | 2.4/5/6 GHz | 9.6 Gbps | OFDMA |
| 802.11be (Wi-Fi 7) | 2.4/5/6 GHz | 30+ Gbps | MLO |

### Wi-Fi Security
- **WEP** - broken (RC4 weakness)
- **WPA** - improved on WEP, still weak
- **WPA2** - AES-CCMP, strong with good password
- **WPA2-Enterprise** - 802.1X, EAP, RADIUS
- **WPA3** - SAE (Simultaneous Authentication of Equals) replacing PSK; forward secrecy
- **WPA3-Enterprise** - optional 192-bit mode

### EAP Variants
- **EAP-TLS** - mutual cert auth (strongest)
- **EAP-TTLS** - server cert + tunneled auth
- **PEAP** - Microsoft tunneled, MS-CHAPv2 inside
- **EAP-FAST** - Cisco, replaces LEAP
- **LEAP** - deprecated

### Wi-Fi Threats
- Rogue AP
- Evil twin (rogue with target's SSID)
- Deauthentication attacks
- KRACK (key reinstallation against WPA2)
- Karma attack (probe responses to all SSIDs)
- Wardriving

### Wireless Site Survey
- Coverage planning
- Channel assignment to minimize co-channel interference
- AP placement to avoid signal bleed beyond intended boundary

## Other Wireless
- **Bluetooth**: 2.4 GHz, short range, classic vs BLE; threats include bluejacking, bluesnarfing, bluebugging
- **Zigbee**: low-power IoT mesh
- **NFC**: very short range (cm), payments, badges
- **RFID**: active vs passive; supply chain, asset tracking
- **Cellular (4G/5G)**: 5G adds network slicing, virtualization
- **Satellite**: latency, throughput trade-offs

## Secure Communication Protocols

### TLS (replacing SSL)
- TLS 1.2: widely supported, can be configured securely
- TLS 1.3: simplified handshake, removed weak ciphers, encrypted handshake
- Always disable SSL 2/3, TLS 1.0/1.1
- Cipher suites: KX_AUTH_BULK_MAC (e.g., ECDHE-RSA-AES256-GCM-SHA384)
- PFS (Perfect Forward Secrecy) requires ephemeral key exchange (ECDHE, DHE)

### IPsec
- AH (Authentication Header) - integrity and authenticity, NOT confidentiality
- ESP (Encapsulating Security Payload) - confidentiality + optional integrity/auth
- Modes:
  - **Transport mode** - encrypts payload (host-to-host)
  - **Tunnel mode** - encrypts entire packet (gateway-to-gateway, VPN)
- IKEv2 for key management
- SA (Security Association) per direction

### SSH
- Replaces telnet, rsh, rlogin
- Port 22
- Public key auth or password
- Tunneling (port forwarding)

### S/MIME and PGP
- S/MIME: cert-based email signing/encryption (uses PKI)
- PGP/GPG: web of trust model
- Both provide confidentiality, integrity, authenticity, non-repudiation

### DNS Security
- **DNSSEC** - signs DNS records (integrity, authenticity)
- **DNS over HTTPS (DoH)** - privacy from network observers
- **DNS over TLS (DoT)** - similar
- **DANE** - publishes TLS certs in DNSSEC-signed records

### Email Security
- SPF - which servers may send for a domain
- DKIM - cryptographic signature on emails
- DMARC - policy combining SPF/DKIM, reporting
- BIMI - logo display when DMARC enforced

## VPN Technologies

| Type | Layer | Notes |
|------|-------|-------|
| IPsec VPN | 3 | Site-to-site or remote access |
| SSL/TLS VPN | 4-7 | Browser-friendly, NAT-friendly |
| L2TP/IPsec | 2/3 | Older but common |
| PPTP | 2 | Deprecated, weak |
| WireGuard | 3 | Modern, simple, fast, audited |
| OpenVPN | 7 (TCP/UDP) | Widely deployed, open source |
| ZTNA | App | Identity-aware, replaces VPN for apps |

## Multilayer Protocol Considerations

Encapsulating one protocol in another can hide threats from inspection. Examples:
- DNS tunneling (data in DNS queries)
- ICMP tunneling
- HTTPS-tunneling (covers any L7 protocol)
- IPv6 tunnels (Teredo, 6to4)

Implications: deep packet inspection limited if encrypted; rely on metadata, behavior, endpoint visibility.

## Converged Protocols
- **FCoE** - Fibre Channel over Ethernet (storage on Ethernet)
- **iSCSI** - SCSI over IP (storage on IP networks)
- **VoIP** - voice over IP (SIP, RTP, SRTP for encryption)
- **MPLS** - label-switched networks for performance and traffic engineering

## Content Distribution Networks
- Caching, edge delivery
- DDoS absorption (large network capacity)
- TLS termination at edge
- Bot management
- Examples: Cloudflare, Akamai, Fastly, AWS CloudFront

## Network Attacks

| Attack | Description |
|--------|-------------|
| ARP spoofing | Falsify ARP responses to MITM L2 |
| DNS spoofing/cache poisoning | False DNS responses |
| MAC flooding | Overflow switch MAC table to broadcast |
| VLAN hopping | Double-tagging, switch spoofing |
| DDoS | Volumetric, protocol (SYN flood), application |
| MITM | Intercept and possibly modify |
| Replay | Capture and resend |
| Session hijacking | Take over authenticated session |
| TCP/SYN flood | Exhaust half-open connections |
| Smurf | ICMP amplification (legacy) |
| Fraggle | UDP version of Smurf |
| Teardrop | Fragmented packet reassembly attack |
| Land attack | Source = destination, crashes vulnerable stacks |

## Common Exam Pitfalls

- Confusing OSI layer of devices (firewall at multiple layers)
- Picking PPTP when modern alternatives exist
- Forgetting AH provides no confidentiality
- Mixing TCP and UDP port assignments
- Choosing WEP/WPA when WPA2/WPA3 exists
- Forgetting DNSSEC provides integrity, not confidentiality
- Confusing transport mode and tunnel mode IPsec
- Picking signature-based IDS when zero-day is the threat
