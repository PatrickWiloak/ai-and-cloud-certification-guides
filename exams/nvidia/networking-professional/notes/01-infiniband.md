# InfiniBand Technology

**[📖 NVIDIA InfiniBand Documentation](https://docs.nvidia.com/networking/)** - Complete InfiniBand guides

## InfiniBand Architecture

### Protocol Stack

**Physical Layer:**
- Defines signaling rates and encoding
- Link training and speed negotiation
- Lane bonding (1x, 4x, 12x ports)
- Cable types: copper (DAC), active optical, fiber

**Link Layer:**
- Credit-based flow control (prevents buffer overflow)
- Error detection via CRC (ICRC and VCRC)
- Virtual Lanes (VLs) for traffic isolation
- Packet types: data, management, link

**Network Layer:**
- LID-based routing within subnets
- GRH (Global Route Header) for inter-subnet routing
- Deterministic routing via linear forwarding tables
- Adaptive routing for congestion avoidance

**Transport Layer:**
- Reliable and unreliable delivery modes
- Queue Pair (QP) based connections
- Completion Queue (CQ) for operation status
- End-to-end flow control and congestion management

**Verbs API (Upper Layer):**
- Standard programming interface for RDMA
- libibverbs library
- Send, receive, RDMA write, RDMA read, atomic operations
- Work request and completion model

### InfiniBand Speed Generations

| Generation | Signal Rate | Encoding | Effective Rate/Lane | 4x BW | 2x BW |
|-----------|-------------|----------|-------------------|--------|--------|
| SDR | 2.5 Gb/s | 8b/10b | 2.0 Gb/s | 8 Gb/s | 4 Gb/s |
| DDR | 5.0 Gb/s | 8b/10b | 4.0 Gb/s | 16 Gb/s | 8 Gb/s |
| QDR | 10 Gb/s | 8b/10b | 8.0 Gb/s | 32 Gb/s | 16 Gb/s |
| FDR | 14.0625 Gb/s | 64b/66b | 13.64 Gb/s | 56 Gb/s | 28 Gb/s |
| EDR | 25 Gb/s | 64b/66b | 25 Gb/s | 100 Gb/s | 50 Gb/s |
| HDR | 50 Gb/s | 64b/66b | 50 Gb/s | 200 Gb/s | 100 Gb/s |
| NDR | 100 Gb/s | 64b/66b | 100 Gb/s | 400 Gb/s | 200 Gb/s |
| XDR | 200 Gb/s | 64b/66b | 200 Gb/s | 800 Gb/s | 400 Gb/s |

### NVIDIA ConnectX Adapters

**ConnectX-7:**
- NDR 400 Gb/s InfiniBand
- Standard adapter in DGX H100
- GPUDirect RDMA and GPUDirect Storage
- SHARP (Scalable Hierarchical Aggregation and Reduction Protocol)
- Hardware offload for collective operations

**ConnectX-8:**
- XDR 800 Gb/s InfiniBand
- Next-generation adapter
- Enhanced GPUDirect capabilities
- Higher bandwidth for future GPU platforms

## Subnet Management

### Subnet Manager (SM)

**Responsibilities:**
- Discover all nodes and switches in the fabric
- Assign LIDs (Local Identifiers) to ports
- Compute routing tables and push to switches
- Monitor fabric health and topology changes
- Handle fabric events and errors

**SM Modes:**
- **Master** - Active SM controlling the fabric
- **Standby** - Backup SM ready for failover
- Priority-based election when multiple SMs exist
- Automatic failover on master failure

### OpenSM vs UFM SM

**OpenSM:**
- Open-source subnet manager
- Command-line configuration
- Good for small to medium fabrics
- Limited management features

**UFM-Based SM:**
- NVIDIA enterprise subnet manager
- GUI-based management
- Advanced routing algorithms
- Telemetry and analytics integration
- Recommended for production AI clusters

### Routing Algorithms

**Linear Forwarding:**
- Static routing tables computed by SM
- Deterministic path for each source-destination pair
- Simple and predictable

**Fat-Tree Routing:**
- Optimized for fat-tree topologies
- Balances traffic across uplinks
- Minimizes hop count

**Adaptive Routing:**
- Dynamic path selection based on congestion
- Switch-level decision making
- Avoids hot spots
- Supported on Quantum switches

**[📖 UFM Subnet Manager](https://docs.nvidia.com/networking/display/ufm/)** - SM configuration

## Partitioning and QoS

### Partition Keys (P_Keys)
- 16-bit identifiers for network isolation
- Similar to VLANs in Ethernet
- Full member vs limited member
- Default partition (0x7FFF) includes all ports
- Custom partitions for tenant isolation

### Quality of Service

**Service Levels (SL):**
- 16 service levels (SL0-SL15)
- Map to Virtual Lanes for traffic prioritization
- SL-to-VL mapping configured on switches

**Virtual Lanes (VL):**
- Hardware queues within a link
- Up to 16 VLs per link (VL0-VL14, VL15 for management)
- Independent flow control per VL
- Prevents head-of-line blocking between traffic classes

**Traffic Classes:**
- Map applications to SLs
- GPU training traffic on high-priority SL
- Management traffic on separate SL
- Storage traffic isolated from compute traffic

## Diagnostics and Troubleshooting

### Common Tools

```bash
# Check local port status
ibstat

# List all switches in fabric
ibswitches

# List all HCAs in fabric
ibhosts

# Query port counters
perfquery <lid> <port>

# Run comprehensive diagnostics
ibdiagnet

# Check subnet manager status
sminfo

# Query node information
smpquery nodeinfo <lid>

# Trace route between two nodes
ibtracert <src_lid> <dst_lid>
```

### Common Issues

**Link Errors:**
- Symbol errors - physical layer problem (cable, connector)
- CRC errors - data integrity issue
- Link down events - connection loss
- Resolution: Check cables, clean connectors, replace if persistent

**Routing Issues:**
- Unreachable destinations - SM routing problem
- Suboptimal paths - routing algorithm configuration
- Resolution: Restart SM, check topology, verify routing config

**Performance Issues:**
- Low throughput - check link speed negotiation
- High latency - check hop count and congestion
- Resolution: Verify speeds, check for oversubscription

## Key Exam Concepts

- InfiniBand protocol stack layers and their functions
- Speed generations and bandwidth calculations
- Subnet Manager roles and failover
- Partitioning with P_Keys for isolation
- QoS with Service Levels and Virtual Lanes
- Diagnostic commands and common troubleshooting
