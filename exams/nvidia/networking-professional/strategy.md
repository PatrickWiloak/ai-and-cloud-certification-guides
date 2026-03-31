# NCP-NET Networking Professional Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **InfiniBand Core**
   - Protocol stack and speed generations
   - Subnet management and routing
   - Partitioning and QoS
   - **[📖 NVIDIA Networking Docs](https://docs.nvidia.com/networking/)**

2. **RDMA and RoCE**
   - RDMA operations and programming model
   - RoCE v1 vs v2
   - Lossless Ethernet (PFC, ECN, DCQCN)
   - GPUDirect RDMA
   - **[📖 GPUDirect Docs](https://developer.nvidia.com/gpudirect)**

### Phase 2: Advanced (2-3 weeks)
1. **Spectrum Ethernet** - Switch family, Cumulus Linux, DOCA
2. **Topologies** - Fat-tree, rail-optimized, dragonfly, adaptive routing
3. **UFM** - Monitoring, telemetry, diagnostics, fabric management

### Phase 3: Exam Prep (1-2 weeks)
1. Practice scenarios and troubleshooting
2. Review specifications and commands
3. Focus on weak areas

## Recommended Resources
- **[NVIDIA Networking Documentation](https://docs.nvidia.com/networking/)** - Complete reference
- **[UFM Documentation](https://docs.nvidia.com/networking/display/ufm/)** - Fabric management
- **[DGX SuperPOD Guide](https://docs.nvidia.com/dgx-superpod/)** - Reference architecture
- **[NVIDIA DLI Courses](https://www.nvidia.com/en-us/training/)** - Official training
- **[NVIDIA Developer Blog](https://developer.nvidia.com/blog/)** - Technical articles

## Exam Tactics

### Keywords
- "Lossless" - PFC + ECN for RoCE
- "Isolation" - InfiniBand partitions (P_Keys)
- "Congestion" - Adaptive routing, ECN, DCQCN
- "Monitor" or "manage" - UFM
- "GPU communication" - GPUDirect RDMA, NVLink, NCCL
- "Large scale" - Dragonfly topology
- "DGX cluster" - Rail-optimized topology

### Common Pitfalls
- RoCE v2 is routable (UDP/IP), RoCE v1 is L2 only
- PFC is per-priority, not per-port
- Adaptive routing should be per-flow for NCCL, not per-packet
- GPUDirect RDMA requires nvidia-peermem module
- InfiniBand uses P_Keys for isolation, not VLANs
