# DGX Systems and GPU Hardware

**[📖 DGX Documentation](https://docs.nvidia.com/dgx/)** - Complete DGX system documentation

## NVIDIA DGX Platform

### DGX H100

**Hardware Specifications:**
- 8x NVIDIA H100 80GB SXM5 GPUs
- 640GB total GPU memory (HBM3)
- 4th-generation NVLink (900 GB/s per GPU)
- NVSwitch for full-mesh GPU interconnect
- Dual AMD EPYC processors
- 2TB DDR5 system memory
- 8x NVIDIA ConnectX-7 400Gb/s InfiniBand NICs
- 30TB NVMe SSD local storage
- ~10.2 kW typical power draw

**Internal Connectivity:**
- All 8 GPUs connected via NVSwitch at full NVLink bandwidth
- Any GPU can communicate with any other GPU at 900 GB/s
- Enables efficient all-reduce for distributed training
- No GPU topology bottlenecks within the node

### DGX A100

**Hardware Specifications:**
- 8x NVIDIA A100 80GB SXM4 GPUs
- 640GB total GPU memory (HBM2e)
- 3rd-generation NVLink (600 GB/s per GPU)
- NVSwitch interconnect
- Dual AMD EPYC 7742 processors
- 2TB DDR4 system memory
- 8x ConnectX-6 200Gb/s InfiniBand HDR NICs
- 30TB NVMe SSD local storage

### DGX SuperPOD

**Architecture:**
- Reference design for large-scale GPU clusters
- Built from DGX units as building blocks
- InfiniBand fabric connects all DGX nodes
- Shared high-performance storage layer
- Supports 20+ DGX nodes (160+ GPUs) in base configuration
- Scales to thousands of GPUs

**Components:**
- DGX compute nodes
- InfiniBand switches (leaf and spine)
- Storage system (parallel file system)
- Management network
- Base Command Manager for orchestration

**[📖 DGX SuperPOD Reference](https://docs.nvidia.com/dgx-superpod/)** - Architecture guide

### DGX Cloud

- Cloud-hosted DGX infrastructure as a service
- Available on major cloud providers (AWS, Azure, GCP, Oracle)
- NVIDIA-managed software stack
- Multi-node training with dedicated interconnect
- Base Command Manager for job management
- Pay-per-use consumption model
- Same software stack as on-premises DGX

## GPU Architecture Details

### NVIDIA H100 (Hopper)

**Key Features:**
- 80GB HBM3 memory at 3.35 TB/s bandwidth
- 4th-gen NVLink at 900 GB/s
- FP8 Transformer Engine for AI training and inference
- 132 streaming multiprocessors (SMs)
- Hardware-level MIG support (up to 7 instances)
- Second-gen Secure Multi-Instance GPU
- PCIe Gen5 support

**Performance (SXM Variant):**
- FP64: 34 TFLOPS
- FP32: 67 TFLOPS
- TF32: 989 TFLOPS (with sparsity)
- FP16/BF16: 1,979 TFLOPS (with sparsity)
- FP8: 3,958 TFLOPS (with sparsity)

### NVIDIA A100 (Ampere)

**Key Features:**
- 40GB or 80GB HBM2e memory
- 3rd-gen NVLink at 600 GB/s
- TF32 Tensor Cores for AI training
- 108 streaming multiprocessors
- First-gen MIG support (up to 7 instances)
- PCIe Gen4 support

### Generation Comparison

| Feature | A100 (Ampere) | H100 (Hopper) | H200 (Hopper) |
|---------|--------------|---------------|----------------|
| GPU Memory | 80GB HBM2e | 80GB HBM3 | 141GB HBM3e |
| Memory BW | 2.0 TB/s | 3.35 TB/s | 4.8 TB/s |
| NVLink BW | 600 GB/s | 900 GB/s | 900 GB/s |
| FP8 Support | No | Yes | Yes |
| MIG Instances | Up to 7 | Up to 7 | Up to 7 |

**[📖 NVIDIA GPU Specs](https://developer.nvidia.com/cuda-gpus)** - GPU comparison

## NVLink and NVSwitch

### NVLink

**Purpose:** High-bandwidth, low-latency GPU-to-GPU interconnect

**4th Generation (Hopper):**
- 900 GB/s bidirectional per GPU
- 18 NVLink connections per GPU
- Direct memory access between GPUs
- Bypasses PCIe bottleneck entirely
- Supports cache coherence across GPUs

**Use Cases:**
- All-reduce operations during distributed training
- Model parallelism with frequent inter-GPU communication
- Peer-to-peer memory access for data sharing
- Unified memory across multiple GPUs

### NVSwitch

**Purpose:** Non-blocking switch fabric for NVLink connections

**Key Characteristics:**
- Connects all 8 GPUs in a DGX system at full bandwidth
- Any-to-any GPU communication without bandwidth reduction
- Critical for collective operations (all-reduce, all-gather)
- Hardware-level multicast support
- Enables SHARP (Scalable Hierarchical Aggregation and Reduction Protocol) in-network computing

## Multi-Instance GPU (MIG)

### Overview
- Partition a single GPU into isolated instances
- Each instance gets dedicated compute, memory, and cache
- Hardware-level isolation prevents interference
- Supported on A100, H100, and newer GPUs

### MIG Profiles (H100)

| Profile | GPU Slices | Memory | SMs |
|---------|-----------|--------|-----|
| 1g.10gb | 1/7 | 10GB | ~19 |
| 2g.20gb | 2/7 | 20GB | ~38 |
| 3g.40gb | 3/7 | 40GB | ~56 |
| 4g.40gb | 4/7 | 40GB | ~76 |
| 7g.80gb | 7/7 | 80GB | 132 |

### MIG Use Cases
- **Inference serving** - Multiple small models on one GPU
- **Multi-tenancy** - Isolated GPU resources per tenant
- **Development** - Share expensive GPUs among developers
- **CI/CD** - GPU testing pipelines with resource isolation

### MIG Management
- Enable MIG mode: `nvidia-smi -i 0 -mig 1`
- Create instances: `nvidia-smi mig -cgi <profile>`
- Create compute instances: `nvidia-smi mig -cci`
- Kubernetes integration via GPU Operator MIG Manager

**[📖 MIG User Guide](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html)** - Configuration details

## DGX Software Stack

### DGX OS
- Optimized Ubuntu-based operating system
- Pre-configured GPU drivers and CUDA
- Container runtime (Docker with NVIDIA Container Toolkit)
- NCCL and NVSHMEM libraries
- System monitoring tools

### Base Command Manager
- Job scheduling and management
- Multi-cluster orchestration
- Dataset management
- Job profiling and monitoring
- User and team management
- Container registry integration

**[📖 Base Command Documentation](https://docs.nvidia.com/base-command-manager/)** - Management platform

## Key Exam Concepts

- DGX H100 hardware specifications and internal architecture
- NVLink bandwidth and NVSwitch topology
- MIG configuration profiles and use cases
- GPU generation differences (A100 vs H100 vs H200)
- DGX SuperPOD architecture and components
- DGX OS and Base Command Manager capabilities
