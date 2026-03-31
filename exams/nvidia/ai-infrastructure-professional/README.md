# NVIDIA Certified Professional - AI Infrastructure (NCP-AII)

## Exam Overview

The NVIDIA Certified Professional - AI Infrastructure certification validates expertise in designing, deploying, and managing GPU-accelerated infrastructure for AI workloads. This certification covers NVIDIA DGX systems, GPU clusters, Kubernetes GPU management, job scheduling, and performance tuning for enterprise AI environments.

**Exam Code:** NCP-AII
**Exam Duration:** 120 minutes
**Number of Questions:** 60-70 questions
**Exam Format:** Multiple choice
**Cost:** $200 USD
**Validity:** 2 years
**Prerequisites:** Recommended experience with data center infrastructure and GPU computing

## Exam Domains

### Domain 1: DGX Systems and GPU Hardware (20%)
- NVIDIA DGX platform architecture and configurations
- GPU hardware specifications (A100, H100, H200, B200)
- NVLink and NVSwitch interconnects
- DGX OS and Base Command
- Hardware monitoring and diagnostics
- Storage architecture for AI workloads

### Domain 2: GPU Cluster Design and Networking (20%)
- Multi-node GPU cluster architectures
- InfiniBand and high-speed networking for AI
- Network topologies for GPU clusters
- Storage solutions (parallel file systems, NFS, object storage)
- Cluster sizing and capacity planning
- Data center considerations (power, cooling)

### Domain 3: Kubernetes and GPU Orchestration (20%)
- NVIDIA GPU Operator for Kubernetes
- GPU scheduling and resource management
- Multi-Instance GPU (MIG) configuration
- Container runtime for GPUs (NVIDIA Container Toolkit)
- GPU monitoring in Kubernetes environments
- Node feature discovery and labeling

### Domain 4: Job Scheduling and Workload Management (20%)
- Slurm and job scheduling for GPU clusters
- NVIDIA Base Command Manager
- Multi-tenant GPU sharing
- Priority and preemption policies
- Resource quotas and fair-share scheduling
- Job profiling and optimization

### Domain 5: Performance Tuning and Optimization (20%)
- GPU utilization monitoring and profiling
- Memory optimization for training workloads
- Multi-GPU training strategies (data parallel, model parallel)
- Network bandwidth optimization
- Storage I/O tuning for data pipelines
- Benchmarking and baseline establishment

## Key Study Areas

### NVIDIA DGX Platform
- **DGX H100** - 8x H100 GPUs with NVSwitch interconnect
- **DGX SuperPOD** - Large-scale GPU cluster reference architecture
- **DGX Cloud** - Cloud-hosted DGX infrastructure
- **Base Command** - Job management and orchestration platform
- **DGX OS** - Optimized Ubuntu-based operating system

### GPU Technologies
- **NVLink** - High-bandwidth GPU-to-GPU interconnect
- **NVSwitch** - Full-bandwidth GPU switching fabric
- **MIG** - Multi-Instance GPU for workload partitioning
- **CUDA** - GPU programming model and runtime
- **TensorRT** - Inference optimization engine

### Infrastructure Software
- **NVIDIA GPU Operator** - Kubernetes GPU management
- **NVIDIA Container Toolkit** - GPU-accelerated containers
- **DCGM** - Data Center GPU Manager for monitoring
- **Nsight Systems** - Performance profiling tool
- **NCCL** - NVIDIA Collective Communications Library

## Hands-On Skills Required

### Cluster Management
- **Deploying** DGX systems and GPU nodes
- **Configuring** InfiniBand networking for GPU clusters
- **Managing** GPU resources with Kubernetes and Slurm
- **Monitoring** GPU health and utilization with DCGM

### Performance Optimization
- **Profiling** GPU workloads with Nsight Systems
- **Tuning** multi-GPU training configurations
- **Optimizing** network and storage for AI pipelines
- **Benchmarking** cluster performance

### Operations
- **Automating** GPU node provisioning
- **Implementing** multi-tenant resource policies
- **Troubleshooting** GPU hardware and software issues
- **Planning** capacity for growing AI workloads

## Study Tips

1. **Hands-On Practice:** Work with GPU Operator, DCGM, and MIG if possible
2. **DGX Architecture:** Understand the full DGX hardware stack deeply
3. **Networking:** InfiniBand and NVLink are heavily tested
4. **Kubernetes Focus:** GPU Operator and scheduling are key exam areas
5. **Performance Profiling:** Know DCGM metrics and Nsight tools
6. **Scale Thinking:** Always consider multi-node, multi-GPU scenarios
7. **Documentation:** Study NVIDIA docs thoroughly
8. **Stay Current:** Follow NVIDIA data center product updates

## Quick Links
- **[NVIDIA Certification Program](https://www.nvidia.com/en-us/training/certification/)** - Registration and exam details
- **[NVIDIA Deep Learning Institute](https://www.nvidia.com/en-us/training/)** - Official training courses
- **[DGX Documentation](https://docs.nvidia.com/dgx/)** - DGX system guides
- **[GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)** - Kubernetes GPU management
- **[DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - GPU monitoring and management
- **[NCCL Documentation](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)** - Collective communications

## Exam Registration

Register through:
- **NVIDIA Certification Portal:** Online proctored exam via Pearson VUE
- **Pearson VUE:** Testing center locations worldwide

## Career Benefits

### Job Opportunities
- AI Infrastructure Engineer
- GPU Cluster Administrator
- AI Platform Engineer
- Data Center Architect
- HPC Systems Engineer

### Professional Development
- Validates expertise in enterprise AI infrastructure
- Demonstrates proficiency with NVIDIA data center technologies
- Foundation for advanced AI systems management roles
- Industry recognition in GPU-accelerated computing
