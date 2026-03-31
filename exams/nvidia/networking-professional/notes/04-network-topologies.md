# Network Topologies for AI

**[📖 DGX SuperPOD Network Guide](https://docs.nvidia.com/dgx-superpod/)** - Reference architecture networking

## Fat-Tree Topology

### Architecture

**Structure:**
- Leaf switches (ToR) connect to compute nodes
- Spine switches connect to all leaf switches
- Optional super-spine for larger fabrics
- Clos network providing full bisection bandwidth

**Characteristics:**
- Non-blocking when properly provisioned
- Any-to-any communication at full bandwidth
- Predictable latency (fixed hop count per tier)
- Standard and well-understood design

### Design Parameters

**Leaf Layer:**
- Connect to compute nodes (downlinks)
- Connect to spine switches (uplinks)
- Oversubscription ratio: uplink BW / downlink BW
- 1:1 ratio = non-blocking (full bisection bandwidth)

**Spine Layer:**
- Connect to all leaf switches
- Number of spines determines bisection bandwidth
- More spines = more bandwidth and redundancy

**Example: 32-Node GPU Cluster**
- 4 leaf switches (8 nodes per leaf)
- 4 spine switches
- Each leaf: 8 downlinks to nodes, 4 uplinks to spines
- 1:2 oversubscription if leaf has 8 down / 4 up (same speed)

### Scaling

| Cluster Size | Leaf Switches | Spine Switches | Bisection BW |
|-------------|--------------|----------------|--------------|
| 16 nodes | 2 | 2 | Full |
| 64 nodes | 8 | 4-8 | Configurable |
| 256 nodes | 16 | 8-16 | Configurable |
| 1024+ nodes | 3-tier (super-spine) | Variable | Configurable |

## Rail-Optimized Topology

### Concept

In a DGX system with 8 GPUs and 8 NICs, each NIC connects to a separate "rail" switch. Corresponding NIC positions across all nodes connect to the same rail switch.

**Structure:**
- 8 rail switches (one per NIC position)
- Each DGX node connects one NIC to each rail switch
- All rank-0 GPUs across nodes share rail-0 switch
- All rank-1 GPUs across nodes share rail-1 switch

### Benefits
- Optimized for NCCL all-reduce communication pattern
- Each rail handles traffic for one GPU rank across nodes
- Fewer switches than full fat-tree for the same node count
- Matches the natural communication pattern of distributed training
- Simpler cabling and management

### Limitations
- Optimized for specific communication patterns (all-reduce)
- Less flexible for arbitrary traffic patterns
- Not ideal for workloads with unpredictable communication
- Scaling requires adding more rails or tiers

### DGX SuperPOD Network

**Reference Architecture:**
- Rail-optimized InfiniBand fabric
- 8 rail switches per DGX pod
- Spine switches connecting rails for larger clusters
- Designed for NCCL collective operation efficiency
- Validated and tested by NVIDIA

**[📖 SuperPOD Networking](https://docs.nvidia.com/dgx-superpod/)** - Network design details

## Dragonfly Topology

### Architecture

**Structure:**
- Nodes grouped into "groups" with full mesh within
- Groups connected by global links
- Low diameter (few hops between any two nodes)
- Efficient use of long-distance links

**Characteristics:**
- Two-level hierarchy (intra-group + inter-group)
- Intra-group: full mesh or fat-tree
- Inter-group: each group connects to every other group
- Maximum 3 hops between any two nodes

### Benefits
- Lower switch count than fat-tree at very large scale
- Efficient use of expensive long-distance links
- Good scalability to thousands of nodes
- Lower cost per port at extreme scale

### Challenges
- More complex routing algorithms required
- Adaptive routing essential for load balancing
- Less predictable performance than fat-tree
- More difficult to troubleshoot

### When to Use
- Very large clusters (1000+ nodes)
- Cost-sensitive deployments at scale
- When fat-tree switch count becomes prohibitive
- Workloads that can tolerate variable latency

## Adaptive Routing

### Purpose
- Dynamically select paths based on current network conditions
- Avoid congested links and hot spots
- Improve effective bisection bandwidth
- Reduce tail latency from congestion

### Mechanisms

**Switch-Level Adaptive Routing:**
- Switch monitors output port queue depths
- Chooses least-congested path for each packet
- Decision made per-packet or per-flow
- Supported on Quantum (IB) and Spectrum (Ethernet) switches

**Per-Packet vs Per-Flow:**
- Per-packet: maximum load balancing, risk of out-of-order delivery
- Per-flow: maintains packet ordering, less aggressive balancing
- Per-flow preferred for most AI workloads (NCCL expects ordered delivery)

### Configuration
- Enable adaptive routing on switches
- Configure aggressiveness parameters
- Set threshold for switching paths
- Monitor effectiveness via telemetry

## Network Sizing for AI

### Bandwidth Requirements

**Training Workloads:**
- Gradient size = model parameters (in bytes)
- All-reduce bandwidth = 2 x gradient_size x (N-1)/N per iteration
- Example: 7B model, FP16 = 14GB gradient, 8 nodes = ~24.5GB per all-reduce
- Need InfiniBand NDR (50 GB/s per port) or multiple ports

**Inference Workloads:**
- Lower bandwidth requirements per model
- Aggregate bandwidth depends on number of models and request rate
- Typically 100GbE or 200GbE sufficient

### Latency Considerations
- Minimize hop count between communicating nodes
- Co-locate related training jobs on nearby nodes
- Use topology-aware job scheduling
- Monitor and optimize network latency

### Oversubscription Planning
- 1:1 (non-blocking) for large model training
- 2:1 acceptable for mixed workloads
- 3:1 or more for inference-only clusters
- Match oversubscription to workload communication intensity

## Key Exam Concepts

- Fat-tree leaf-spine architecture and scaling
- Rail-optimized topology for DGX SuperPOD
- Dragonfly topology for very large clusters
- Adaptive routing mechanisms and configuration
- Network sizing based on training workload requirements
- Oversubscription ratios for different workload types
