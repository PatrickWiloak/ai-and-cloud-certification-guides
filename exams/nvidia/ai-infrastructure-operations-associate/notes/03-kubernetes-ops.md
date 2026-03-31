# Kubernetes GPU Operations

**[📖 GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)** - Kubernetes GPU management

## NVIDIA GPU Operator

### What it Does
The GPU Operator automates the deployment of all NVIDIA software components needed to run GPU workloads in Kubernetes:

1. **GPU drivers** - Installs and manages NVIDIA drivers on nodes
2. **Container Toolkit** - Configures container runtime for GPU access
3. **Device Plugin** - Makes GPUs schedulable as Kubernetes resources
4. **DCGM Exporter** - Exports GPU metrics to Prometheus
5. **GPU Feature Discovery** - Labels nodes with GPU properties
6. **MIG Manager** - Manages Multi-Instance GPU configuration

### Installation

```bash
# Add Helm repository
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update

# Install GPU Operator
helm install gpu-operator nvidia/gpu-operator \
  --namespace gpu-operator \
  --create-namespace
```

### Verification

```bash
# Check operator pods
kubectl get pods -n gpu-operator

# Check GPU nodes
kubectl get nodes -l nvidia.com/gpu.present=true

# Verify GPU resources
kubectl describe node <node-name> | grep nvidia.com/gpu
```

## GPU Scheduling

### Requesting GPUs in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
spec:
  containers:
  - name: cuda
    image: nvcr.io/nvidia/cuda:12.0-base-ubuntu22.04
    command: ["nvidia-smi"]
    resources:
      limits:
        nvidia.com/gpu: 1  # Request 1 GPU
```

### Key Points
- GPUs are requested via `nvidia.com/gpu` resource
- Only limits are required (not requests) for GPUs
- GPUs are allocated as whole devices (no fractional GPUs without MIG)
- Multiple containers in a pod can share GPU allocation
- Pod will be pending if no GPU is available

### GPU Feature Discovery Labels

The GPU Operator automatically adds labels to nodes:

```
nvidia.com/gpu.present=true
nvidia.com/gpu.product=NVIDIA-A100-SXM4-80GB
nvidia.com/gpu.count=8
nvidia.com/gpu.memory=81920
nvidia.com/mig.capable=true
nvidia.com/cuda.driver.major=535
```

### Node Selection

```yaml
spec:
  nodeSelector:
    nvidia.com/gpu.product: NVIDIA-H100-SXM
  containers:
  - name: training
    resources:
      limits:
        nvidia.com/gpu: 4
```

## MIG Operations

### Basic MIG Concepts
- Partition one physical GPU into isolated instances
- Hardware-level isolation (compute, memory, cache)
- Supported on A100, H100, and newer
- Each MIG instance appears as a separate GPU resource

### MIG in Kubernetes

**Request MIG slice:**
```yaml
resources:
  limits:
    nvidia.com/mig-1g.10gb: 1  # Request 1g.10gb MIG instance
```

**Available MIG resource types:**
- `nvidia.com/mig-1g.10gb`
- `nvidia.com/mig-2g.20gb`
- `nvidia.com/mig-3g.40gb`
- `nvidia.com/mig-7g.80gb`
- (Profiles depend on GPU model)

### MIG Management
- GPU Operator's MIG Manager handles configuration
- MIG profiles defined via ConfigMap
- Automatic MIG instance creation
- Node drain required for MIG mode changes

### GPU Time-Slicing

Alternative to MIG for GPU sharing:

```yaml
# GPU Operator time-slicing config
apiVersion: v1
kind: ConfigMap
data:
  config: |
    version: v1
    sharing:
      timeSlicing:
        resources:
        - name: nvidia.com/gpu
          replicas: 4
```

- Shares GPU time between pods
- No memory isolation (cooperative sharing)
- Simpler than MIG, less isolation
- Good for development and light inference

## Monitoring in Kubernetes

### DCGM Exporter
- Runs as DaemonSet on GPU nodes
- Exports metrics in Prometheus format
- Scrape endpoint: `<node>:9400/metrics`

### Key Metrics
- `DCGM_FI_DEV_GPU_UTIL` - GPU utilization
- `DCGM_FI_DEV_FB_USED` - Memory used
- `DCGM_FI_DEV_GPU_TEMP` - Temperature
- `DCGM_FI_DEV_POWER_USAGE` - Power draw

### Grafana Dashboards
- Pre-built GPU monitoring dashboards available
- Cluster-wide GPU utilization overview
- Per-node and per-GPU detail views
- Alert configuration for anomalies

## Key Exam Concepts

- GPU Operator components and what each does
- GPU scheduling syntax in Kubernetes pod specs
- GPU Feature Discovery node labels
- MIG resource types and scheduling
- Time-slicing vs MIG for GPU sharing
- DCGM Exporter metrics in Kubernetes
