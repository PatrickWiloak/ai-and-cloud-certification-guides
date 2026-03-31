# NCP-AII AI Infrastructure Professional Study Plan

## 8-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: GPU Hardware and DGX Systems
**Focus:** Core hardware knowledge

#### Day 1-2: GPU Architecture
- [ ] Study H100, A100, H200 GPU specifications and differences
- [ ] Understand HBM memory types and bandwidth
- [ ] Learn Tensor Core generations and data type support
- [ ] Study MIG architecture and partition profiles
- [ ] **Reference:** [NVIDIA GPU Specifications](https://developer.nvidia.com/cuda-gpus)

#### Day 3-4: DGX Platform
- [ ] Study DGX H100 hardware architecture and internal topology
- [ ] Understand NVLink and NVSwitch connectivity
- [ ] Learn DGX SuperPOD reference architecture
- [ ] Study DGX OS and software stack
- [ ] **Reference:** [DGX Documentation](https://docs.nvidia.com/dgx/)

#### Day 5-7: Interconnects
- [ ] Deep dive into NVLink bandwidth and generations
- [ ] Understand NVSwitch full-mesh topology
- [ ] Study PCIe Gen4 vs Gen5 specifications
- [ ] Learn GPU topology within DGX nodes
- [ ] **Lab:** Use nvidia-smi to explore GPU topology

### Week 2: Networking and Storage
**Focus:** Cluster interconnects and data management

#### Day 1-2: InfiniBand Networking
- [ ] Study InfiniBand generations (HDR, NDR, XDR)
- [ ] Learn ConnectX-7 adapter capabilities
- [ ] Understand RDMA concepts and benefits
- [ ] Study GPUDirect RDMA, Storage, and Peer-to-Peer
- [ ] **Reference:** [NVIDIA Networking Docs](https://docs.nvidia.com/networking/)

#### Day 3-4: Network Topologies
- [ ] Study fat-tree topology for GPU clusters
- [ ] Learn rail-optimized topology (DGX SuperPOD)
- [ ] Understand dragonfly topology for large-scale clusters
- [ ] Compare topologies for different cluster sizes

#### Day 5-7: Storage Architecture
- [ ] Study parallel file systems (Lustre, GPFS, BeeGFS, WekaFS)
- [ ] Learn storage tiering strategies
- [ ] Understand data loading optimization patterns
- [ ] Practice storage sizing calculations
- [ ] **Lab:** Benchmark storage I/O with FIO

### Phase 2: Advanced Topics (Weeks 3-5)

#### Week 3: Kubernetes GPU Management

#### Day 1-2: GPU Operator
- [ ] Study GPU Operator components and architecture
- [ ] Learn installation and configuration
- [ ] Understand device plugin and container toolkit
- [ ] Study DCGM Exporter and GPU Feature Discovery
- [ ] **Reference:** [GPU Operator Docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)

#### Day 3-4: GPU Scheduling
- [ ] Practice GPU request syntax in pod specs
- [ ] Learn time-slicing configuration
- [ ] Study MIG-backed scheduling
- [ ] Understand topology-aware scheduling
- [ ] **Lab:** Deploy GPU workloads on Kubernetes

#### Day 5-7: Monitoring and Operations
- [ ] Set up DCGM Exporter with Prometheus
- [ ] Create Grafana dashboards for GPU metrics
- [ ] Configure alerting rules
- [ ] Practice node maintenance procedures

### Week 4: Job Scheduling and Multi-Tenancy

#### Day 1-2: Slurm Fundamentals
- [ ] Study Slurm architecture and components
- [ ] Learn GRES configuration for GPUs
- [ ] Practice job submission with GPU requests
- [ ] Understand interactive vs batch jobs
- [ ] **Lab:** Submit multi-GPU training jobs

#### Day 3-4: Multi-Tenant Management
- [ ] Study partition design patterns
- [ ] Learn fair-share scheduling configuration
- [ ] Understand QOS policies and priorities
- [ ] Implement preemption policies

#### Day 5-7: Base Command Manager
- [ ] Study Base Command Manager features
- [ ] Learn job lifecycle and monitoring
- [ ] Understand dataset management
- [ ] Practice job profiling and optimization
- [ ] **Reference:** [Base Command Docs](https://docs.nvidia.com/base-command-manager/)

### Week 5: Performance Tuning

#### Day 1-2: GPU Profiling
- [ ] Study DCGM metrics in depth
- [ ] Learn Nsight Systems profiling
- [ ] Practice identifying bottlenecks from profiles
- [ ] Understand GPU utilization patterns

#### Day 3-4: Multi-GPU Training
- [ ] Study data parallelism and DDP
- [ ] Learn tensor parallelism and pipeline parallelism
- [ ] Understand 3D parallelism strategies
- [ ] Study NCCL collective operations and tuning
- [ ] **Reference:** [NCCL User Guide](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)

#### Day 5-7: Memory and I/O Optimization
- [ ] Study mixed precision training
- [ ] Learn gradient checkpointing and ZeRO
- [ ] Practice data pipeline optimization
- [ ] Benchmark with standard tools (nccl-tests, MLPerf)
- [ ] **Lab:** Profile and optimize a training workload

### Phase 3: Review and Exam Prep (Weeks 6-8)

#### Week 6: Integration and Practice

#### Day 1-3: End-to-End Scenarios
- [ ] Design a GPU cluster for a given workload
- [ ] Configure Kubernetes GPU scheduling
- [ ] Set up monitoring and alerting
- [ ] Optimize a multi-node training job

#### Day 4-7: Practice Questions
- [ ] Work through scenario-based questions
- [ ] Review architecture design problems
- [ ] Practice troubleshooting scenarios
- [ ] Identify and address knowledge gaps

### Week 7: Review and Gap Filling

#### Day 1-3: Domain Review
- [ ] Review all five domains systematically
- [ ] Create flashcards for specifications and metrics
- [ ] Re-read documentation for weak areas
- [ ] Complete any unfinished labs

#### Day 4-7: Practice and Refinement
- [ ] Timed practice question sessions
- [ ] Focus on multi-domain integration questions
- [ ] Review GPU specifications tables
- [ ] Refresh NCCL and DCGM details

### Week 8: Final Preparation

#### Day 1-3: Intensive Review
- [ ] Review fact sheet and key specifications
- [ ] Practice rapid identification of bottlenecks
- [ ] Focus on configuration syntax and commands

#### Day 4-5: Final Practice
- [ ] Full-length timed practice session
- [ ] Review all incorrect answers
- [ ] Final review of weak areas

#### Day 6: Rest and Light Review
- [ ] Light review of fact sheet only
- [ ] Prepare exam logistics

#### Day 7: Exam Day
- [ ] Brief concept review (30 minutes max)
- [ ] Take the exam with confidence

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** GPU hardware, DGX systems, networking, storage
- **Week 3:** Kubernetes GPU management
- **Week 4:** Job scheduling and multi-tenancy
- **Week 5:** Performance tuning and optimization
- **Week 6:** Integration scenarios and practice
- **Week 7:** Review and gap analysis
- **Week 8:** Final review and exam

### Self-Assessment Questions
- Can I list DGX H100 specifications from memory?
- Do I know the bandwidth differences between NVLink generations?
- Can I configure GPU scheduling in Kubernetes?
- Do I understand Slurm GRES configuration and job submission?
- Can I identify and resolve GPU performance bottlenecks?
- Do I know 3D parallelism strategies and when to use each?
