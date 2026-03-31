# GPU Cluster Design and Networking

**[📖 NVIDIA Networking Documentation](https://docs.nvidia.com/networking/)** - NVIDIA networking solutions

## GPU Cluster Architectures

### Cluster Building Blocks

**Compute Nodes:**
- DGX systems or custom GPU servers
- 4-8 GPUs per node is typical
- High-bandwidth intra-node interconnect (NVLink/NVSwitch)
- Local NVMe storage for scratch and staging

**Network Fabric:**
- InfiniBand for GPU-to-GPU communication across nodes
- Ethernet management network
- Optional dedicated storage network
- Out-of-band management (BMC/IPMI)

**Storage Layer:**
- Shared parallel file system for training data
- Local NVMe for checkpoint caching
- Object storage for dataset archives
- High-bandwidth path from storage to compute

**Management:**
- Cluster management software (Base Command, Bright, xCAT)
- Job scheduler (Slurm, PBS, LSF)
- Monitoring and alerting (DCGM, Prometheus, Grafana)

### Cluster Sizing

**Factors:**
- Number of concurrent training jobs
- Largest model size (determines minimum GPUs per job)
- GPU memory requirements per model
- Storage throughput requirements for data loading
- Network bandwidth for gradient synchronization
- Power and cooling capacity

**Rule of Thumb:**
- Large language model training: 64-1024+ GPUs
- Computer vision training: 8-64 GPUs
- Inference serving: 1-8 GPUs per model instance
- Development and experimentation: 1-8 GPUs per user

## InfiniBand Networking

### InfiniBand Generations

| Generation | Speed | Bandwidth (per port) |
|-----------|-------|---------------------|
| HDR | 200 Gb/s | 25 GB/s |
| NDR | 400 Gb/s | 50 GB/s |
| XDR | 800 Gb/s | 100 GB/s |

### ConnectX Network Adapters

**ConnectX-7 (NDR 400Gb/s):**
- Standard NIC for DGX H100
- RDMA over InfiniBand
- GPUDirect RDMA support
- Hardware offload for collective operations
- 8 NICs per DGX H100 node

**[📖 ConnectX Documentation](https://docs.nvidia.com/networking/)** - Network adapter specifications

### Network Topologies

**Fat-Tree:**
- Hierarchical leaf-spine architecture
- Full bisection bandwidth
- Standard choice for most GPU clusters
- Predictable latency and throughput
- Scales well to hundreds of nodes

**Rail-Optimized:**
- Each NIC on a node connects to a different switch
- Corresponding GPU ranks across nodes share a rail
- Reduces switch requirements for specific traffic patterns
- Optimized for all-reduce communication
- Used in DGX SuperPOD reference architecture

**Dragonfly:**
- Groups of switches connected in a low-diameter network
- Efficient for very large clusters (1000+ nodes)
- Lower switch count than fat-tree at extreme scale
- More complex routing

### GPUDirect Technologies

**GPUDirect RDMA:**
- Direct data path between GPU memory and network adapter
- Bypasses CPU and system memory entirely
- Reduces latency and CPU overhead
- Essential for efficient multi-node GPU communication
- Requires compatible NIC and GPU on same PCIe root complex

**GPUDirect Storage:**
- Direct data path between storage (NVMe) and GPU memory
- Bypasses CPU bounce buffer
- Accelerates data loading for training
- Supported with compatible storage controllers

**GPUDirect Peer-to-Peer:**
- Direct GPU-to-GPU memory copy within a node
- Uses NVLink when available (preferred)
- Falls back to PCIe when NVLink not available
- Used by NCCL for intra-node communication

**[📖 GPUDirect Documentation](https://developer.nvidia.com/gpudirect)** - Direct GPU communication

## Storage Architecture

### Parallel File Systems

**Lustre:**
- Most widely deployed parallel file system for HPC/AI
- Supports thousands of clients
- Scalable throughput and capacity
- Metadata server (MDS) + Object storage servers (OSS)
- Striping across multiple OSTs for throughput

**GPFS (IBM Spectrum Scale):**
- Enterprise parallel file system
- Strong POSIX compliance
- Built-in tiering and policy engine
- Good for mixed workloads (AI + analytics)

**BeeGFS:**
- Easy to deploy and manage
- Good performance for mid-scale clusters
- Open-source with commercial support
- Buddy mirroring for high availability

**WekaFS:**
- Flash-optimized distributed file system
- Very high IOPS and low latency
- Good for small-file random access patterns
- GPU-aware data placement

### Storage Tiering

**Tier 1 - Local NVMe:**
- Fastest access for active data
- Limited capacity per node
- Used for checkpoints, scratch space, data staging
- GPUDirect Storage support

**Tier 2 - Shared Parallel FS:**
- Training datasets and shared data
- High aggregate throughput
- Network-attached via InfiniBand or high-speed Ethernet
- Primary working storage for training jobs

**Tier 3 - Object Storage:**
- Large-scale dataset archives
- Model artifact storage
- Lowest cost per TB
- S3-compatible API access

### Data Loading Optimization

- **Prefetching** - Load next batch while GPU processes current
- **Multiple data workers** - Parallel data loading processes
- **Data format** - Use efficient formats (TFRecord, WebDataset)
- **Caching** - Cache preprocessed data on local NVMe
- **Compression** - Reduce storage I/O with compressed datasets

## Data Center Considerations

### Power
- DGX H100: ~10.2 kW per unit
- Large clusters can require megawatts of power
- Plan for power distribution and redundancy
- UPS and generator backup for critical workloads

### Cooling
- GPU clusters generate significant heat
- Liquid cooling increasingly common for high-density deployments
- Rear-door heat exchangers for air-cooled racks
- Hot aisle/cold aisle containment
- Monitor thermal conditions to prevent throttling

### Physical Layout
- Proximity of compute and storage for low-latency access
- Cable management for dense InfiniBand cabling
- Rack weight considerations (DGX systems are heavy)
- Maintenance access and hot-swap capability

## Key Exam Concepts

- InfiniBand generations and bandwidth specifications
- Fat-tree vs rail-optimized vs dragonfly topologies
- GPUDirect RDMA, Storage, and Peer-to-Peer
- Parallel file system options and their trade-offs
- Storage tiering strategies for AI workloads
- Cluster sizing considerations
