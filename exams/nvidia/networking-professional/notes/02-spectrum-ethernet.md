# Spectrum Ethernet

**[📖 NVIDIA Spectrum Documentation](https://docs.nvidia.com/networking/)** - Switch platform documentation

## NVIDIA Spectrum Switch Family

### Spectrum-2 (SN3000 Series)
- Up to 64x 100GbE ports
- 12.8 Tb/s switching capacity
- Suitable for standard data center networking
- RoCE support for AI workloads

### Spectrum-3 (SN4000/SN5000 Series)
- Up to 64x 400GbE ports
- 51.2 Tb/s switching capacity
- Purpose-built for AI and HPC clusters
- Advanced adaptive routing
- In-network computing (SHARP-like for Ethernet)

### Spectrum-4 (SN5000 Series)
- Up to 64x 800GbE ports
- 102.4 Tb/s switching capacity
- Next-generation AI fabric switch
- Enhanced telemetry and congestion management
- Lowest latency in class

### Switch Selection Guide

| Workload | Recommended | Reason |
|----------|------------|--------|
| General data center | Spectrum-2 | Cost-effective, feature-rich |
| AI training clusters | Spectrum-3/4 | High bandwidth, adaptive routing |
| Large-scale AI | Spectrum-4 | Maximum bandwidth, lowest latency |
| Storage networks | Spectrum-2/3 | RoCE support, lossless capability |

## Cumulus Linux

### Overview
- Full Linux distribution for Spectrum switches
- Standard Linux networking stack and tools
- FRRouting (FRR) for routing protocols
- NVUE configuration management CLI
- Automation-friendly (Ansible, Puppet, APIs)

**[📖 Cumulus Linux Documentation](https://docs.nvidia.com/networking-ethernet-software/)** - Network OS guides

### Configuration Management

**NVUE (NVIDIA User Experience):**
```bash
# Configure interface
nv set interface swp1 ip address 10.0.0.1/30
nv set interface swp1 link speed 400G
nv set interface swp1 link mtu 9216

# Configure BGP
nv set vrf default router bgp autonomous-system 65001
nv set vrf default router bgp neighbor swp1 remote-as 65002

# Apply configuration
nv config apply

# Show running config
nv config show
```

**Traditional Linux Tools:**
```bash
# Interface configuration
ip addr add 10.0.0.1/30 dev swp1
ip link set swp1 mtu 9216

# Routing
ip route show
```

### Routing Protocols

**BGP (Border Gateway Protocol):**
- Primary routing protocol for data center fabrics
- eBGP for leaf-spine connections
- Unnumbered BGP for simplified configuration
- BGP EVPN for overlay networking

**OSPF:**
- Interior routing protocol
- Less common than BGP in modern data centers
- Used in some legacy or smaller deployments

**EVPN-VXLAN:**
- Network virtualization overlay
- Layer 2 extension across Layer 3 fabric
- Multi-tenancy support
- Distributed anycast gateway

### Automation

**Ansible Integration:**
- Modules for Cumulus/NVUE configuration
- Playbooks for fabric-wide changes
- Configuration backup and compliance
- Role-based deployment templates

**REST API:**
- Programmatic access to switch configuration
- Integration with orchestration platforms
- Real-time monitoring data access
- Webhook support for event notifications

## NVIDIA DOCA (DPU SDK)

### BlueField DPU

**Purpose:** Data Processing Unit for infrastructure offload

**Capabilities:**
- Network function acceleration (firewall, NAT, load balancing)
- Storage acceleration (NVMe-oF, compression)
- Security offload (encryption, isolation)
- Programmable data path

**BlueField-3:**
- 400 Gb/s networking
- ARM cores for management
- Hardware accelerators for crypto, regex, compression
- GPUDirect support

**[📖 DOCA Documentation](https://docs.nvidia.com/doca/)** - DPU SDK reference

### DOCA SDK
- C and Python APIs for DPU programming
- Flow processing pipeline
- Packet inspection and modification
- Storage emulation
- Service mesh acceleration

## Ethernet Features for AI

### Large MTU (Jumbo Frames)
- Standard Ethernet MTU: 1500 bytes
- Jumbo frames: 9000-9216 bytes
- Reduces per-packet overhead for large transfers
- Essential for RDMA/RoCE efficiency
- Must be configured consistently end-to-end

### ECMP (Equal Cost Multi-Path)
- Load balance traffic across multiple equal-cost paths
- Hash-based packet distribution
- Increases effective bandwidth
- Requires proper hash configuration for GPU traffic
- 5-tuple or flow-label based hashing

### Link Aggregation (MLAG/LACP)
- Bond multiple physical links
- Increased bandwidth and redundancy
- LACP for standard link aggregation
- MLAG for multi-chassis link aggregation

### Quality of Service
- DSCP marking for traffic classification
- Priority queuing for latency-sensitive traffic
- Strict priority and weighted fair queuing
- Trust DSCP or 802.1p at switch ports

## Key Exam Concepts

- Spectrum switch generations and port speeds
- Cumulus Linux configuration with NVUE
- BGP and EVPN-VXLAN for data center fabrics
- BlueField DPU capabilities and DOCA SDK
- Jumbo frames and ECMP for AI workloads
- Automation tools for network management
