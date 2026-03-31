# Performance Tuning and Optimization

**[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - GPU monitoring and diagnostics

## GPU Monitoring and Profiling

### NVIDIA DCGM (Data Center GPU Manager)

**Key Monitoring Metrics:**
- **GPU Utilization** - Percentage of time SMs are active
- **Memory Utilization** - Percentage of GPU memory in use
- **Power Draw** - Current power consumption in watts
- **Temperature** - GPU die temperature in Celsius
- **Clock Speeds** - Current SM and memory clock frequencies
- **ECC Errors** - Single-bit (correctable) and double-bit (uncorrectable) errors
- **NVLink Throughput** - Bandwidth utilization per NVLink connection
- **PCIe Throughput** - Bandwidth utilization on PCIe bus

**DCGM Commands:**
```bash
# Check GPU health
dcgmi diag -r 3  # Level 3 diagnostic (comprehensive)

# Monitor GPU metrics
dcgmi dmon -e 155,156,203,204  # Utilization, memory, power, temp

# Group GPUs for monitoring
dcgmi group -c my-gpus
dcgmi group -a my-gpus 0,1,2,3

# Run health check
dcgmi health -s mpi  # Check memory, PCIe, InfiniBand
```

**Health Monitoring:**
- Automated health checks on schedule
- ECC error tracking and alerting
- GPU thermal monitoring
- NVLink error detection
- PCIe replay counter monitoring
- Automated GPU reset on recoverable errors

### NVIDIA Nsight Systems

**Purpose:** System-wide performance profiling

**Capabilities:**
- CPU and GPU timeline visualization
- CUDA kernel launch and execution profiling
- Memory allocation and transfer tracking
- NCCL collective operation profiling
- Data loading pipeline analysis
- Identifies bottlenecks across CPU, GPU, network, and storage

**Common Analysis Patterns:**
- Gap analysis: identify idle time between GPU kernels
- Data transfer overlaps: check CPU-to-GPU and GPU-to-GPU transfers
- Kernel launch overhead: detect excessive small kernel launches
- NCCL profiling: measure collective operation efficiency

**[📖 Nsight Systems](https://developer.nvidia.com/nsight-systems)** - Profiling tool

### nvidia-smi

```bash
# Basic GPU status
nvidia-smi

# Detailed GPU info
nvidia-smi -q

# Monitor continuously
nvidia-smi dmon -s pucvmet

# Check MIG status
nvidia-smi mig -lgi

# Monitor processes
nvidia-smi pmon -s um
```

## Memory Optimization

### GPU Memory Breakdown

**During Training:**
- Model parameters (weights)
- Optimizer states (momentum, variance for Adam)
- Gradients
- Activations (forward pass intermediate values)
- Temporary buffers and workspace

**Memory Estimation (FP32 Adam):**
- Model params: 4 bytes/param
- Optimizer states: 8 bytes/param (momentum + variance)
- Gradients: 4 bytes/param
- Total optimizer memory: ~16 bytes/param (4x model size)
- 7B model: ~112GB for full precision training

### Memory Reduction Techniques

**Mixed Precision Training:**
- Train with FP16/BF16 while maintaining FP32 master weights
- Reduces activation memory by ~50%
- Requires loss scaling for FP16 stability
- BF16 preferred on Ampere and newer (no loss scaling needed)
- TF32 for compute kernels on Ampere+

**Gradient Checkpointing:**
- Trade compute for memory
- Recompute activations during backward pass instead of storing
- Reduces activation memory from O(n) to O(sqrt(n))
- Increases training time by ~30%

**ZeRO (Zero Redundancy Optimizer):**
- Stage 1: Partition optimizer states across GPUs
- Stage 2: Partition gradients across GPUs
- Stage 3: Partition parameters across GPUs
- Each stage progressively reduces per-GPU memory
- Implemented in DeepSpeed and FSDP

**Activation Offloading:**
- Move activations to CPU memory during forward pass
- Transfer back during backward pass
- Trades CPU memory and PCIe bandwidth for GPU memory
- Useful for very large models

## Multi-GPU Training Strategies

### Data Parallelism

**Concept:**
- Replicate complete model on each GPU
- Split training batch across GPUs
- Each GPU processes its portion of the batch
- Synchronize gradients via all-reduce after each step

**Implementation:**
- PyTorch DDP (Distributed Data Parallel)
- Horovod
- NVIDIA NCCL for collective operations

**Scaling:**
- Near-linear scaling with number of GPUs (for large batch sizes)
- Communication overhead increases with model size
- Gradient all-reduce is the primary bottleneck
- NVLink within node, InfiniBand across nodes

### Model Parallelism

**Tensor Parallelism:**
- Split individual layers across GPUs
- Each GPU holds a portion of each layer's weights
- Requires frequent inter-GPU communication per layer
- Best within a node (NVLink bandwidth)
- Used by Megatron-LM for large models

**Pipeline Parallelism:**
- Split model into stages assigned to different GPUs
- Micro-batching to keep all stages busy
- GPipe and PipeDream approaches
- Lower communication requirements than tensor parallel
- Can work across nodes (InfiniBand)

**Expert Parallelism (for MoE models):**
- Different experts on different GPUs
- Token routing to appropriate experts
- Communication for expert dispatch and combination
- Used by Mixtral and similar MoE architectures

### Hybrid Parallelism (3D Parallelism)

**Typical Configuration:**
- Tensor parallel within a DGX node (NVLink)
- Pipeline parallel across small groups of nodes
- Data parallel across node groups (InfiniBand)
- Example: 128 GPUs = 8-way tensor x 4-way pipeline x 4-way data

**[📖 NCCL Documentation](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)** - Collective communications

## Network Bandwidth Optimization

### NCCL Tuning

**Key Environment Variables:**
- `NCCL_IB_HCA` - Select InfiniBand adapters
- `NCCL_IB_GID_INDEX` - InfiniBand GID index
- `NCCL_SOCKET_IFNAME` - Network interface for TCP
- `NCCL_ALGO` - Algorithm selection (Ring, Tree, CollNet)
- `NCCL_PROTO` - Protocol selection (Simple, LL, LL128)
- `NCCL_CROSS_NIC` - Allow cross-NIC communication

**Optimization Tips:**
- Use tree all-reduce for large message sizes
- Use ring all-reduce for smaller messages
- Ensure all InfiniBand NICs are active
- Match GPU-NIC topology for optimal routing
- Enable SHARP for in-network reduction when available

### Network Diagnostics
- `nccl-tests` - Benchmark all-reduce, broadcast, etc.
- `ib_read_bw` / `ib_write_bw` - InfiniBand bandwidth tests
- DCGM NVLink metrics for intra-node communication
- PCIe bandwidth tests for GPU-NIC path

## Storage I/O Tuning

### Data Pipeline Optimization
- **Prefetching** - Overlap data loading with GPU computation
- **Multi-worker loading** - Parallel data reader processes
- **Data format** - Use efficient formats (WebDataset, LMDB, TFRecord)
- **Local caching** - Stage hot data on NVMe SSDs
- **GPUDirect Storage** - Bypass CPU for storage-to-GPU path

### I/O Bottleneck Detection
- Low GPU utilization with periodic drops - likely I/O bound
- High CPU utilization on data loading threads
- Low storage throughput vs theoretical maximum
- High wait time in data loader

## Benchmarking

### Standard Benchmarks
- **MLPerf Training** - Industry standard for training performance
- **MLPerf Inference** - Industry standard for inference throughput
- **nccl-tests** - Network collective operation benchmarks
- **FIO** - Storage I/O benchmarks
- **IOR** - Parallel file system benchmarks

### Establishing Baselines
- Benchmark each component independently first
- GPU compute: run standard model training benchmarks
- Network: nccl-tests all-reduce bandwidth
- Storage: sequential and random I/O throughput
- End-to-end: representative training job with time-to-train metric

## Key Exam Concepts

- DCGM metrics and health monitoring commands
- Memory optimization: mixed precision, gradient checkpointing, ZeRO
- Data parallel vs tensor parallel vs pipeline parallel
- 3D parallelism configuration strategies
- NCCL tuning environment variables
- Storage I/O optimization for training pipelines
- Benchmarking methodology and standard tools
