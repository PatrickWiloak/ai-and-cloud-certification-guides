# NCP-AII AI Infrastructure Professional Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **GPU Hardware**
   - Memorize H100 and A100 specifications
   - Understand NVLink generations and bandwidth
   - Learn NVSwitch topology within DGX nodes
   - Study MIG profiles and use cases
   - **[📖 DGX Documentation](https://docs.nvidia.com/dgx/)**

2. **Networking**
   - InfiniBand generations (HDR, NDR, XDR) and speeds
   - Fat-tree and rail-optimized topologies
   - GPUDirect RDMA, Storage, and Peer-to-Peer
   - **[📖 NVIDIA Networking](https://docs.nvidia.com/networking/)**

3. **Storage**
   - Parallel file systems and their trade-offs
   - Storage tiering strategies
   - Data loading optimization patterns

### Phase 2: Software Stack (2-3 weeks)
1. **Kubernetes GPU Management**
   - GPU Operator components and installation
   - GPU scheduling, time-slicing, and MIG in Kubernetes
   - DCGM Exporter and monitoring
   - **[📖 GPU Operator Docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)**

2. **Job Scheduling**
   - Slurm GRES configuration and job submission
   - Multi-tenant policies: partitions, fair-share, QOS
   - Base Command Manager capabilities
   - **[📖 Base Command Docs](https://docs.nvidia.com/base-command-manager/)**

3. **Hands-On Practice**
   - Deploy GPU Operator on a Kubernetes cluster
   - Submit Slurm jobs with GPU requests
   - Monitor GPUs with DCGM and nvidia-smi

### Phase 3: Performance and Exam Prep (1-2 weeks)
1. **Performance Tuning**
   - DCGM metrics and profiling with Nsight Systems
   - Multi-GPU training strategies (data, tensor, pipeline parallel)
   - NCCL tuning and network optimization
   - Memory optimization (mixed precision, ZeRO, checkpointing)
   - **[📖 NCCL User Guide](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)**

2. **Review and Practice**
   - Work through scenario-based questions
   - Focus on bottleneck identification and resolution
   - Create flashcards for key specifications

## Recommended Resources

### Official NVIDIA Resources
- **[NVIDIA DLI - Infrastructure Courses](https://www.nvidia.com/en-us/training/)** - Official training
- **[DGX Documentation](https://docs.nvidia.com/dgx/)** - DGX system guides
- **[GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)** - Kubernetes GPU management
- **[DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - GPU monitoring
- **[NCCL Documentation](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)** - Collective communications

### Supplementary Resources
- **[NVIDIA Developer Blog](https://developer.nvidia.com/blog/)** - Technical articles
- **[NVIDIA GTC Sessions](https://www.nvidia.com/gtc/)** - Conference presentations
- **[Slurm Documentation](https://slurm.schedmd.com/documentation.html)** - Job scheduler reference
- **[Kubernetes Documentation](https://kubernetes.io/docs/)** - Container orchestration

## Exam Tactics

### Question Strategy
1. **Read the full question** - identify the infrastructure component being tested
2. **Look for NVIDIA-specific solutions** - prefer NVIDIA tools and platforms
3. **Keywords to watch for:**
   - "Bandwidth" or "throughput" - think NVLink, InfiniBand, GPUDirect
   - "Isolation" - think MIG
   - "Multi-tenant" - think Slurm partitions, QOS, fair-share
   - "Low GPU utilization" - identify the bottleneck (network, storage, CPU)
   - "Scale" or "multi-node" - think InfiniBand, NCCL, parallelism strategy
   - "Monitor" or "health" - think DCGM
4. **Eliminate wrong answers** - verify numbers match known specifications
5. **When in doubt** - choose the solution that uses NVIDIA-specific technology

### Time Management
- 120 minutes for 60-70 questions
- Approximately 1.7-2 minutes per question
- Flag specification-heavy questions for review
- Reserve 15 minutes for reviewing flagged questions

### Common Pitfalls

**Hardware Confusion:**
- NVLink is GPU-to-GPU, InfiniBand is node-to-node
- MIG requires A100 or newer - not supported on older GPUs
- H100 has 4th-gen NVLink (900 GB/s), A100 has 3rd-gen (600 GB/s)
- DGX H100 has 8 GPUs with NVSwitch, not PCIe connected

**Software Confusion:**
- GPU Operator manages the Kubernetes GPU stack, not training frameworks
- DCGM is for monitoring, Nsight is for profiling
- Slurm GRES is for GPUs, partitions are for node groups
- Base Command Manager is NVIDIA's enterprise tool, not open-source Slurm

**Performance Mistakes:**
- Data parallelism is preferred when model fits on one GPU
- Tensor parallelism needs NVLink bandwidth - do not use across nodes
- Pipeline parallelism has bubble overhead - not always faster
- NCCL tree algorithm is better for large messages, ring for small

## Progress Tracking

### Self-Assessment Questions
- Can I list DGX H100 specifications including NVLink bandwidth?
- Do I know InfiniBand generation speeds and ConnectX adapter capabilities?
- Can I configure GPU Operator and schedule GPU workloads in Kubernetes?
- Do I understand Slurm GRES configuration and multi-tenant policies?
- Can I diagnose GPU performance bottlenecks from DCGM metrics?
- Do I know when to use data vs tensor vs pipeline parallelism?
