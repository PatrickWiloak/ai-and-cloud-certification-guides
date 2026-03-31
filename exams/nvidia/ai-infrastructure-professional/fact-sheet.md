# NVIDIA AI Infrastructure Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-AII
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| DGX Systems and GPU Hardware | 20% | DGX architecture, GPU specs, NVLink/NVSwitch |
| GPU Cluster Design and Networking | 20% | Cluster topologies, InfiniBand, storage |
| Kubernetes and GPU Orchestration | 20% | GPU Operator, MIG, container runtime |
| Job Scheduling and Workload Management | 20% | Slurm, Base Command, multi-tenancy |
| Performance Tuning and Optimization | 20% | Profiling, multi-GPU training, benchmarking |

## Domain 1: DGX Systems and GPU Hardware

### DGX Platform Family

**DGX H100:**
- 8x NVIDIA H100 80GB SXM GPUs
- 640GB total GPU memory
- NVSwitch for all-to-all GPU communication (900 GB/s per GPU)
- Dual CPU (Intel Xeon or AMD EPYC)
- 2TB system memory
- 8x ConnectX-7 400Gb/s InfiniBand NICs
- 30TB NVMe SSD storage
- ~10.2 kW power consumption
- **[📖 DGX H100 Documentation](https://docs.nvidia.com/dgx/)** - System specifications

**DGX SuperPOD:**
- Reference architecture for large-scale GPU clusters
- Built from multiple DGX units connected via InfiniBand fabric
- Shared high-performance storage (typically Lustre or GPFS)
- Supports hundreds to thousands of GPUs
- Designed for large-scale training workloads
- **[📖 DGX SuperPOD Guide](https://docs.nvidia.com/dgx-superpod/)** - Reference architecture

**DGX Cloud:**
- Cloud-hosted DGX infrastructure
- Available on AWS, Azure, GCP, Oracle Cloud
- NVIDIA Base Command Manager for job management
- Multi-node training with high-speed interconnect
- Pay-per-use consumption model

### GPU Specifications

| GPU | Architecture | Memory | Memory BW | FP16 TFLOPS | FP8 TFLOPS |
|-----|-------------|--------|-----------|-------------|------------|
| A100 40GB | Ampere | 40GB HBM2e | 1.6 TB/s | 312 | N/A |
| A100 80GB | Ampere | 80GB HBM2e | 2.0 TB/s | 312 | N/A |
| H100 SXM | Hopper | 80GB HBM3 | 3.35 TB/s | 989 | 1,979 |
| H200 | Hopper | 141GB HBM3e | 4.8 TB/s | 989 | 1,979 |

### NVLink and NVSwitch

**NVLink (4th Gen - Hopper):**
- 900 GB/s bidirectional bandwidth per GPU
- Direct GPU-to-GPU communication
- Bypasses PCIe bottleneck
- Supports peer-to-peer memory access

**NVSwitch:**
- Full-mesh GPU interconnect within a node
- All 8 GPUs can communicate at full NVLink bandwidth
- Enables efficient all-reduce operations
- Critical for multi-GPU training within a DGX system

**[📖 NVLink Documentation](https://developer.nvidia.com/nvlink)** - Interconnect specifications

### Multi-Instance GPU (MIG)

- Partition a single GPU into up to 7 isolated instances
- Each instance has dedicated compute, memory, and cache
- Hardware-level isolation - no interference between instances
- Supported on A100, H100, and newer GPUs
- Useful for inference workloads and multi-tenant environments
- **[📖 MIG User Guide](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html)** - Configuration guide

## Domain 2: GPU Cluster Design and Networking

### InfiniBand Networking

**ConnectX-7 (400Gb/s NDR):**
- 400 Gb/s per port
- RDMA support for low-latency GPU-to-GPU communication
- GPUDirect RDMA - direct NIC-to-GPU data path
- Essential for multi-node training at scale

**Network Topologies:**
- **Fat-tree** - Standard topology for large clusters, full bisection bandwidth
- **Rail-optimized** - Connects corresponding GPUs across nodes directly
- **Dragonfly** - Scalable topology for very large clusters

**GPUDirect Technologies:**
- **GPUDirect RDMA** - Remote GPU memory access over InfiniBand
- **GPUDirect Storage** - Direct path between storage and GPU memory
- **GPUDirect Peer-to-Peer** - Direct GPU-to-GPU memory access within node

### Storage Architecture

**Parallel File Systems:**
- **Lustre** - High-throughput distributed file system
- **GPFS (Spectrum Scale)** - IBM parallel file system
- **BeeGFS** - Easy-to-deploy parallel file system
- **WekaFS** - High-performance flash-based file system

**Storage Tiers:**
- **Hot tier** - NVMe SSDs on compute nodes for active datasets
- **Warm tier** - Shared parallel file system for training data
- **Cold tier** - Object storage (S3-compatible) for archives and checkpoints

**[📖 NVIDIA Storage Solutions](https://docs.nvidia.com/dgx/)** - Storage architecture guides

## Domain 3: Kubernetes and GPU Orchestration

### NVIDIA GPU Operator

**Components:**
- **GPU Device Plugin** - Exposes GPUs as schedulable resources
- **Container Toolkit** - GPU runtime support in containers
- **DCGM Exporter** - GPU metrics for Prometheus/Grafana
- **GPU Feature Discovery** - Labels nodes with GPU capabilities
- **MIG Manager** - Manages MIG configuration on nodes
- **[📖 GPU Operator Docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)**

**GPU Scheduling:**
- Request GPUs in pod spec: `nvidia.com/gpu: 1`
- Time-slicing for sharing GPUs across pods
- MIG-backed scheduling for isolated GPU partitions
- Topology-aware scheduling for NVLink locality
- Extended resources for specific GPU models

### NVIDIA Container Toolkit

- Enables GPU-accelerated containers
- NVIDIA Container Runtime (nvidia-cri)
- Automatic GPU driver and library mounting
- CDI (Container Device Interface) support
- Works with Docker, containerd, CRI-O

**[📖 Container Toolkit Docs](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)**

## Domain 4: Job Scheduling and Workload Management

### Slurm for GPU Clusters

**GPU Resource Management:**
- `--gres=gpu:N` to request N GPUs per node
- `--gpus-per-task` for per-task GPU allocation
- GPU type selection: `--gres=gpu:h100:4`
- Generic resource (GRES) configuration for GPU types

**Multi-Tenant Features:**
- Partitions for different user groups or priorities
- Fair-share scheduling across teams
- Resource quotas (QOS - Quality of Service)
- Priority and preemption policies
- Accounting and usage tracking

### NVIDIA Base Command Manager

- Enterprise job management for DGX clusters
- Web-based UI for job submission and monitoring
- Multi-cluster management
- Integration with container registries
- Dataset management and job profiling
- **[📖 Base Command Documentation](https://docs.nvidia.com/base-command-manager/)** - Management platform

## Domain 5: Performance Tuning and Optimization

### GPU Monitoring with DCGM

**Key Metrics:**
- GPU utilization (SM activity percentage)
- GPU memory utilization and allocation
- Power consumption and thermal state
- NVLink throughput and errors
- PCIe bandwidth utilization
- ECC error counts (correctable and uncorrectable)
- **[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**

### Multi-GPU Training Strategies

**Data Parallelism:**
- Replicate model on each GPU
- Split training batch across GPUs
- Synchronize gradients after each step (all-reduce)
- Scales well for models that fit on a single GPU

**Model Parallelism:**
- Split model layers across GPUs
- Pipeline parallelism - different stages on different GPUs
- Tensor parallelism - split individual layers across GPUs
- Required when model exceeds single GPU memory

**Hybrid Parallelism:**
- Combine data and model parallelism
- Tensor parallel within a node (NVLink)
- Data parallel across nodes (InfiniBand)
- Pipeline parallel for very large models

### Performance Optimization

- **NCCL tuning** - Collective communication optimization
- **Mixed precision** - FP16/BF16 training with FP32 master weights
- **Gradient accumulation** - Simulate larger batch sizes
- **Data loading** - Prefetch, multiple workers, GPU-direct storage
- **Checkpointing** - Efficient model save/restore during training

## Exam Tips

### Key Concepts to Master
1. DGX hardware architecture and GPU specifications
2. NVLink/NVSwitch bandwidth and connectivity
3. MIG configuration and use cases
4. GPU Operator components and Kubernetes GPU scheduling
5. InfiniBand networking and GPUDirect technologies
6. Slurm GPU resource management
7. DCGM metrics and monitoring
8. Multi-GPU training parallelism strategies
