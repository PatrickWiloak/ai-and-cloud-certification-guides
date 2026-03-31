# Job Scheduling and Workload Management

**[📖 Base Command Documentation](https://docs.nvidia.com/base-command-manager/)** - NVIDIA enterprise job management

## Slurm for GPU Clusters

### Overview

Slurm (Simple Linux Utility for Resource Management) is the most widely used job scheduler for GPU clusters in AI and HPC environments.

### Key Components
- **slurmctld** - Central controller daemon
- **slurmd** - Compute node daemon
- **slurmdbd** - Database daemon for accounting
- **squeue** - View job queue
- **sbatch** - Submit batch jobs
- **srun** - Run interactive/parallel jobs
- **scancel** - Cancel jobs
- **sacct** - View job accounting

### GPU Resource Configuration

**GRES (Generic Resources) Setup:**
```
# /etc/slurm/gres.conf
NodeName=dgx01 Name=gpu Type=h100 File=/dev/nvidia[0-7]
NodeName=dgx02 Name=gpu Type=h100 File=/dev/nvidia[0-7]
```

**Requesting GPUs:**
```bash
# Request 4 H100 GPUs
sbatch --gres=gpu:h100:4 train.sh

# Request 2 GPUs per task, 4 tasks
sbatch --gres=gpu:2 --ntasks=4 distributed_train.sh

# Request entire DGX node (8 GPUs)
sbatch --gres=gpu:8 --exclusive train.sh
```

### Job Types

**Batch Jobs:**
```bash
#!/bin/bash
#SBATCH --job-name=train-llm
#SBATCH --gres=gpu:8
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=8
#SBATCH --time=48:00:00
#SBATCH --partition=training

srun python train.py --distributed
```

**Interactive Jobs:**
```bash
srun --gres=gpu:1 --pty bash
```

**Array Jobs:**
```bash
#SBATCH --array=0-9
# Runs 10 instances with different SLURM_ARRAY_TASK_ID
```

### Multi-Node Training with Slurm

- Use `srun` to launch processes across nodes
- Each node gets requested GPUs
- Slurm sets environment variables for MPI/NCCL rank discovery
- `SLURM_PROCID`, `SLURM_LOCALID`, `SLURM_NODELIST`
- InfiniBand networking used for inter-node communication

## Multi-Tenant GPU Management

### Partitions

**Purpose:** Logical groups of nodes for different user groups or job types

```
# slurm.conf partition configuration
PartitionName=training Nodes=dgx[01-16] MaxTime=72:00:00 Default=YES
PartitionName=inference Nodes=dgx[17-20] MaxTime=24:00:00
PartitionName=dev Nodes=dgx[21-22] MaxTime=4:00:00 Priority=10
```

**Design Patterns:**
- Separate partitions for training, inference, and development
- Priority partitions for urgent jobs
- Preemptible partitions for low-priority batch work
- Dedicated partitions for specific teams

### Fair-Share Scheduling

- Allocate GPU resources proportionally across teams
- Track historical usage per team/user
- Users who have used less than their share get priority
- Prevents any single team from monopolizing the cluster
- Configured via association hierarchies and shares

### Quality of Service (QOS)

```
# Define QOS levels
sacctmgr add qos high priority=1000 maxwall=72:00:00 maxtres=gpu=64
sacctmgr add qos normal priority=500 maxwall=48:00:00 maxtres=gpu=32
sacctmgr add qos low priority=100 maxwall=24:00:00 maxtres=gpu=8
```

**QOS Controls:**
- Maximum resource limits per job
- Maximum wall time
- Priority weighting
- Preemption policies
- Maximum jobs per user/group

### Preemption

- Higher-priority jobs can preempt lower-priority ones
- Preempted jobs are either requeued or cancelled
- Checkpointing recommended for preemptible workloads
- Grace period before preemption for clean shutdown
- Useful for maximizing cluster utilization

## NVIDIA Base Command Manager

### Features
- Web-based job management interface
- Multi-cluster management from single pane
- Container-native job submission
- Dataset management and versioning
- Job profiling with GPU metrics
- Role-based access control (RBAC)
- Integration with NGC container registry

### Job Lifecycle
1. **Submit** - User submits job with resource requirements
2. **Queue** - Job waits for resources
3. **Schedule** - Scheduler allocates resources
4. **Run** - Job executes on allocated GPUs
5. **Monitor** - Track progress and resource utilization
6. **Complete** - Job finishes, resources released
7. **Report** - Usage accounting and profiling data

### Dataset Management
- Register datasets with metadata
- Mount datasets into job containers
- Version tracking for reproducibility
- Access control per team/user
- Caching on local NVMe for performance

## Job Profiling and Optimization

### GPU Utilization Analysis
- DCGM metrics during job execution
- GPU SM utilization vs memory utilization
- Identify CPU-bottlenecked jobs (low GPU util, high CPU)
- Identify data-loading bottlenecks (periodic GPU idle)
- Network bottleneck detection (low GPU util during all-reduce)

### Common Optimization Patterns
- **Low GPU utilization** - Increase batch size, check data loading
- **GPU memory underutilized** - Increase batch size or model size
- **CPU bottleneck** - More data workers, preprocess data offline
- **Network bottleneck** - Optimize collective operations, check NCCL config
- **I/O bottleneck** - Stage data to local NVMe, use parallel FS

### Resource Accounting
- Track GPU-hours consumed per user/team/project
- Compare requested vs actual utilization
- Identify wasteful jobs (allocated but unused GPUs)
- Generate reports for capacity planning
- Chargeback models for multi-tenant environments

## Key Exam Concepts

- Slurm GRES configuration for GPU resources
- Job submission with GPU requests (--gres, --gpus-per-task)
- Partition design for multi-tenant environments
- Fair-share scheduling and QOS configuration
- Preemption policies and their trade-offs
- Base Command Manager features and job lifecycle
- Job profiling and optimization patterns
