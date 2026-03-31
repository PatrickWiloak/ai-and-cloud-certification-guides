# NCA-AIIO High-Yield Scenarios and Practice Problems

## Scenario 1: GPU Not Accessible in Container

**Scenario**: A developer runs `docker run --gpus all nvidia/cuda:12.0-base nvidia-smi` and gets "docker: Error response from daemon: could not select device driver". What is the issue?

**Solution Pattern**:
- **Cause**: NVIDIA Container Toolkit is not installed or not configured
- **Fix**:
  1. Install NVIDIA Container Toolkit
  2. Run `nvidia-ctk runtime configure --runtime=docker`
  3. Restart Docker: `systemctl restart docker`
  4. Verify host nvidia-smi works first
  5. Retry the docker command

**Common Distractors**:
- GPU driver not installed - would fail on host nvidia-smi too
- Wrong CUDA version - container would start but CUDA would fail inside
- GPU hardware failure - nvidia-smi would fail on host
- Docker not installed - different error message

**Key Takeaway**: "Could not select device driver" means the Container Toolkit is missing or misconfigured. Install and configure it, then restart Docker.

---

## Scenario 2: GPU Memory Issue

**Scenario**: A training job crashes with "CUDA error: out of memory". nvidia-smi shows GPU 0 at 78GB/80GB memory usage. What should be done?

**Solution Pattern**:
1. Check for orphaned processes: `nvidia-smi pmon` or `fuser /dev/nvidia0`
2. Kill any orphaned GPU processes
3. If no orphans, reduce batch size in training configuration
4. Consider enabling mixed precision (FP16) to reduce memory
5. Consider gradient checkpointing for large models

**Common Distractors**:
- Add more system RAM - does not help GPU memory
- Upgrade GPU driver - does not increase GPU memory
- Increase swap space - GPU memory cannot use swap
- Restart the GPU - does not increase available memory (unless orphaned processes)

**Key Takeaway**: GPU OOM means the workload exceeds GPU memory. Check for orphaned processes first, then reduce memory usage through batch size or precision changes.

---

## Scenario 3: Kubernetes GPU Scheduling

**Scenario**: A pod requesting 1 GPU is stuck in Pending state. The cluster has 4 nodes with 8 GPUs each. kubectl describe pod shows "Insufficient nvidia.com/gpu". What should be checked?

**Solution Pattern**:
1. Check node GPU allocation: `kubectl describe nodes | grep nvidia.com/gpu`
2. Verify GPU Operator is running: `kubectl get pods -n gpu-operator`
3. Check if all GPUs are already allocated to other pods
4. Check node labels and any nodeSelector/affinity constraints on the pod
5. Check if GPU nodes are cordoned or tainted

**Common Distractors**:
- Install CUDA in the container - CUDA is already in NGC containers
- Increase CPU resources - GPU scheduling is the bottleneck
- Add more pod replicas - more pods would need more GPUs
- Change container image - scheduling issue, not image issue

**Key Takeaway**: "Insufficient nvidia.com/gpu" means all GPUs are allocated or the GPU Operator is not running. Check allocation status and operator health.

---

## Scenario 4: GPU Health Monitoring

**Scenario**: A node shows intermittent job failures. nvidia-smi shows all GPUs are functioning. DCGM shows increasing single-bit ECC errors on GPU 2 (50 in the last 24 hours vs 2 per day previously). What action should be taken?

**Solution Pattern**:
1. Run `dcgmi diag -r 3 -i 2` for comprehensive diagnostic on GPU 2
2. Check page retirement count: `nvidia-smi -q -d ECC -i 2`
3. The rising SBE trend indicates degrading memory hardware
4. Cordon the node and schedule GPU replacement
5. Migrate workloads away from GPU 2

**Common Distractors**:
- Ignore because SBEs are correctable - rising trend is the concern
- Reboot the node - does not fix hardware degradation
- Update the driver - SBEs are hardware issues
- Reset the ECC counters - hides the problem

**Key Takeaway**: Rising SBE rates are an early warning of memory degradation. Run DCGM diagnostics and plan for GPU replacement before it progresses to DBEs.

---

## Scenario 5: Driver Version Mismatch

**Scenario**: After updating the GPU driver on a node, Docker containers that were working before now fail with "CUDA driver version is insufficient for CUDA runtime version". What happened?

**Solution Pattern**:
- **Cause**: The container's CUDA runtime requires a newer driver than what is installed
- **Check**: Compare driver version (`nvidia-smi`) with container CUDA version
- **Fix options**:
  1. Install a newer GPU driver that supports the container's CUDA version
  2. Use an older container image that matches the installed driver
  3. Check NVIDIA's CUDA-driver compatibility matrix

**Common Distractors**:
- Reinstall Container Toolkit - toolkit is fine, driver version is the issue
- Install CUDA toolkit on host - containers bring their own CUDA runtime
- Change Docker version - Docker version is not related to CUDA version
- Disable Secure Boot - not related to CUDA version mismatch

**Key Takeaway**: CUDA runtime in containers requires a minimum driver version on the host. Always check the CUDA-driver compatibility matrix before updating.

---

## Scenario 6: MIG Configuration

**Scenario**: An inference server needs to run 3 small models on a single H100 GPU. Each model needs about 10GB GPU memory. The team wants hardware-level isolation between models. Which approach should be used?

**Solution Pattern**:
- **Use MIG** to partition the H100 into 3 instances
- Create 3x 2g.20gb MIG instances (or 3x 1g.10gb if 10GB is sufficient)
- Each model runs in its own MIG instance
- Hardware isolation prevents one model from affecting others
- In Kubernetes: request `nvidia.com/mig-2g.20gb: 1` per pod

**Common Distractors**:
- Time-slicing - no memory isolation, one model's OOM affects others
- Three separate GPUs - wasteful when MIG can partition one GPU
- Run all models in one container - no isolation between models
- Software-based GPU virtualization - MIG provides hardware-level isolation

**Key Takeaway**: MIG provides hardware-level isolation ideal for running multiple inference models on one GPU. Time-slicing is simpler but has no memory isolation.
