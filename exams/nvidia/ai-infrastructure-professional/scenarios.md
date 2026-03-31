# NCP-AII High-Yield Scenarios and Practice Problems

## Scenario 1: Cluster Design for LLM Training

**Scenario**: A company wants to train a 70B parameter language model. They need to determine the GPU cluster configuration. The model requires approximately 140GB in FP16 for parameters alone, plus optimizer states and activations. What infrastructure is needed?

**Solution Pattern**:
- **Minimum GPUs**: 70B model in FP16 = ~140GB. A single H100 has 80GB, so minimum 2 GPUs for model weights alone. With optimizer states (Adam ~3x params), need ~560GB total - requires at least 8 H100s (1 DGX H100 node)
- **Recommended**: 4-8 DGX H100 nodes (32-64 GPUs) for practical training speed
- **Parallelism**: 8-way tensor parallel within each node (NVLink), 4-way data parallel across nodes (InfiniBand)
- **Network**: InfiniBand NDR 400Gb/s for inter-node gradient synchronization
- **Storage**: Parallel file system (Lustre) with sufficient throughput for data loading

**Common Distractors**:
- Single DGX node with 8 GPUs - possible with ZeRO-3 but impractically slow
- PCIe-connected GPUs - insufficient bandwidth for tensor parallelism
- Ethernet networking - too slow for multi-node training synchronization
- A100 40GB GPUs - memory too small, would require excessive model parallelism

**Key Takeaway**: Match parallelism strategy to hardware topology - tensor parallel on NVLink within nodes, data parallel on InfiniBand across nodes.

---

## Scenario 2: MIG Configuration for Inference

**Scenario**: An inference platform needs to serve 5 different small models (each using ~10GB GPU memory) simultaneously on a single H100 GPU. All models need isolation for SLA guarantees. How should MIG be configured?

**Solution Pattern**:
- **Configuration**: Create 5x 1g.10gb MIG instances on the H100
- **Reasoning**: Each 1g.10gb instance provides ~10GB memory and dedicated compute, sufficient for small inference models
- **Isolation**: Hardware-level isolation ensures one model cannot impact another
- **Kubernetes**: Schedule 5 pods, each requesting `nvidia.com/mig-1g.10gb: 1`

**Common Distractors**:
- Time-slicing with 5 virtual GPUs - no memory isolation, one model's OOM affects all others
- 5 separate physical GPUs - wasteful when MIG can partition one GPU
- 7g.80gb single instance running all models - no isolation between models
- Using 2g.20gb profiles - wastes memory, can only fit 3 on one GPU (not 5)

**Key Takeaway**: MIG provides hardware-level isolation ideal for multi-tenant inference. Match MIG profiles to model memory requirements.

---

## Scenario 3: Network Bottleneck Diagnosis

**Scenario**: A distributed training job across 4 DGX H100 nodes shows GPU utilization averaging 45% during training. Profiling shows GPUs are idle during gradient synchronization. What is the likely cause and fix?

**Solution Pattern**:
- **Diagnosis**: Low GPU utilization with idle time during all-reduce indicates network bottleneck
- **Checks**:
  1. Verify all InfiniBand NICs are active (`ibstat`)
  2. Check NCCL is using InfiniBand, not TCP (`NCCL_DEBUG=INFO`)
  3. Run `nccl-tests` to measure actual all-reduce bandwidth
  4. Verify GPUDirect RDMA is enabled
- **Fixes**:
  - Ensure all 8 InfiniBand NICs per node are operational
  - Set `NCCL_IB_HCA` to use all available adapters
  - Enable SHARP for in-network aggregation if available
  - Increase batch size to amortize communication overhead
  - Consider gradient compression

**Common Distractors**:
- Increasing GPU clock speed - GPUs are idle, not slow
- Adding more GPUs - would increase communication overhead
- Reducing model size - does not address the network bottleneck
- Using time-slicing - irrelevant to distributed training

**Key Takeaway**: Low GPU utilization during multi-node training usually means network bottleneck. Verify all NICs are active, GPUDirect RDMA is enabled, and NCCL is properly configured.

---

## Scenario 4: Kubernetes GPU Scheduling

**Scenario**: A Kubernetes cluster has nodes with different GPU types (A100 and H100). A training job requires 4 H100 GPUs on the same node for NVLink connectivity. How should the pod be configured?

**Solution Pattern**:
```yaml
resources:
  limits:
    nvidia.com/gpu: 4
nodeSelector:
  nvidia.com/gpu.product: NVIDIA-H100-SXM
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: nvidia.com/gpu.count
          operator: Gte
          values: ["4"]
```
- Use GPU Feature Discovery labels to target H100 nodes
- Request 4 GPUs to ensure same-node scheduling
- Node selector for specific GPU model

**Common Distractors**:
- No node selector - might schedule on A100 nodes
- Requesting GPUs across multiple pods - no NVLink between pods on different nodes
- Using `nvidia.com/gpu: 8` when only 4 needed - wastes resources
- Pod anti-affinity - would spread pods across nodes, opposite of desired behavior

**Key Takeaway**: Use GPU Feature Discovery labels for GPU-type-specific scheduling. Request all GPUs in a single pod for NVLink locality.

---

## Scenario 5: Storage Bottleneck Resolution

**Scenario**: A computer vision training job loads 256x256 images from a Lustre file system. The job achieves only 30% GPU utilization. Profiling shows GPUs wait for data between batches. How should the data pipeline be optimized?

**Solution Pattern**:
- **Immediate fixes**:
  - Increase DataLoader `num_workers` from 2 to 8-16
  - Enable `prefetch_factor` to queue multiple batches ahead
  - Enable `pin_memory` for faster CPU-to-GPU transfer
- **Medium-term fixes**:
  - Convert dataset to WebDataset or LMDB format (sequential reads)
  - Cache dataset on local NVMe SSDs
  - Pre-resize images to reduce on-the-fly processing
- **Long-term fixes**:
  - Enable GPUDirect Storage for direct storage-to-GPU path
  - Increase Lustre stripe count for higher throughput
  - Add more OSTs to the Lustre file system

**Common Distractors**:
- Adding more GPUs - would make the I/O bottleneck worse
- Using a larger model - does not address data loading
- Reducing batch size - reduces GPU efficiency further
- Switching to InfiniBand for storage - Lustre already uses high-speed networking

**Key Takeaway**: Data loading bottlenecks show as low GPU utilization with periodic idle gaps. Fix with more workers, better data formats, local caching, and storage tuning.

---

## Scenario 6: Slurm Multi-Tenant Configuration

**Scenario**: A shared GPU cluster has three teams: Research (40% allocation), Engineering (40%), and DevOps (20%). Research jobs are long-running (days), Engineering jobs are medium (hours), and DevOps jobs are short (minutes). Design the Slurm configuration.

**Solution Pattern**:
- **Partitions**: Create separate partitions per team with appropriate time limits
- **Fair-share**: Configure shares proportional to allocation (4:4:2)
- **QOS**:
  - Research: high MaxWall (7 days), max 40% of GPUs
  - Engineering: medium MaxWall (48 hours), max 40% of GPUs
  - DevOps: low MaxWall (4 hours), max 20% of GPUs, high priority for fast turnaround
- **Preemption**: Allow DevOps to preempt idle Research/Engineering GPUs for short jobs
- **Backfill**: Enable backfill scheduling to fill gaps with smaller jobs

**Common Distractors**:
- No fair-share - one team could monopolize the cluster
- Single partition for all teams - no isolation or policy differentiation
- No preemption - DevOps short jobs stuck behind long Research jobs
- Equal time limits for all - Research needs days, DevOps needs minutes

**Key Takeaway**: Multi-tenant Slurm requires partitions, fair-share, QOS, and preemption policies tailored to each team's workload patterns.

---

## Scenario 7: GPU Health Issue

**Scenario**: A DGX node reports intermittent training failures with CUDA errors. Some jobs fail, others complete successfully. GPU utilization appears normal when jobs are running. How should this be diagnosed?

**Solution Pattern**:
- **Step 1**: Check DCGM for ECC errors: `dcgmi diag -r 3`
- **Step 2**: Review `nvidia-smi -q` for error counts per GPU
- **Step 3**: Check system logs for Xid errors (GPU driver error codes)
- **Step 4**: Monitor temperature - thermal throttling can cause intermittent failures
- **Step 5**: Run GPU stress test to identify the failing GPU
- **Resolution**: If ECC uncorrectable errors found, replace the GPU. If correctable errors accumulating, schedule maintenance.

**Common Distractors**:
- Reinstalling drivers - does not fix hardware ECC errors
- Rebooting the node - may temporarily mask but does not resolve hardware issues
- Reducing workload - hides the problem rather than diagnosing it
- Blaming the training code - intermittent hardware failures are not software bugs

**Key Takeaway**: Intermittent CUDA errors on specific nodes point to hardware issues. Use DCGM diagnostics, ECC error counts, and Xid error codes to identify failing GPUs.

---

## Scenario 8: Multi-GPU Parallelism Selection

**Scenario**: A team needs to train a 13B parameter model on a single DGX H100 node (8x H100 80GB GPUs). The model fits on a single GPU with FP16. What parallelism strategy should they use?

**Solution Pattern**:
- **Best Choice**: Data parallelism (DDP) across all 8 GPUs
- **Reasoning**: Model fits on a single GPU, so no model parallelism needed. Data parallelism provides near-linear scaling with 8 GPUs. NVSwitch enables efficient all-reduce within the node.
- **Configuration**: Batch size 8x single-GPU batch, gradient synchronization via NCCL over NVLink

**Common Distractors**:
- Tensor parallelism - unnecessary overhead when model fits on one GPU
- Pipeline parallelism - adds complexity and pipeline bubbles without benefit
- Using only 1 GPU - wastes 7 available GPUs
- ZeRO-3 - needed for models that do not fit in memory, adds communication overhead

**Key Takeaway**: If the model fits on a single GPU, always use data parallelism. Only use model parallelism when the model exceeds single-GPU memory.
