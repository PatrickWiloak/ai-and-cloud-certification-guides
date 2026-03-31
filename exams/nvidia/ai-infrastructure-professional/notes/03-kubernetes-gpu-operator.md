# Kubernetes GPU Orchestration

**[📖 GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)** - NVIDIA GPU Operator for Kubernetes

## NVIDIA GPU Operator

### Overview

The NVIDIA GPU Operator automates the deployment and management of all NVIDIA software components needed to run GPU workloads in Kubernetes:

- Automates driver installation and updates
- Manages container runtime configuration
- Deploys monitoring and device plugin components
- Handles MIG configuration
- Provides node feature discovery

### Components

**GPU Device Plugin:**
- Exposes GPUs as Kubernetes extended resources (`nvidia.com/gpu`)
- Enables GPU scheduling in pod specifications
- Manages GPU allocation and deallocation
- Supports time-slicing and MIG-backed devices

**NVIDIA Container Toolkit:**
- Provides GPU runtime support for containers
- Mounts GPU drivers and libraries into containers
- Supports Docker, containerd, and CRI-O
- CDI (Container Device Interface) for standardized device access

**DCGM Exporter:**
- Exports GPU metrics to Prometheus
- Provides GPU utilization, memory, temperature, power metrics
- Integrates with Grafana for visualization
- Custom metric collection rules

**GPU Feature Discovery:**
- Labels Kubernetes nodes with GPU properties
- GPU model, driver version, CUDA version
- MIG capability and configuration
- Enables topology-aware scheduling

**MIG Manager:**
- Manages MIG configuration on nodes
- Creates and destroys MIG instances
- Coordinates with device plugin for scheduling
- Configuration via ConfigMaps

**[📖 Container Toolkit Docs](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)** - Container runtime

### Installation

```bash
# Add NVIDIA Helm repository
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update

# Install GPU Operator
helm install gpu-operator nvidia/gpu-operator \
  --namespace gpu-operator \
  --create-namespace
```

## GPU Scheduling in Kubernetes

### Basic GPU Request

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gpu-workload
    image: nvcr.io/nvidia/pytorch:latest
    resources:
      limits:
        nvidia.com/gpu: 2  # Request 2 GPUs
```

### GPU Time-Slicing

- Share a single GPU across multiple pods
- Configured via GPU Operator ConfigMap
- Oversubscription - more virtual GPUs than physical
- No memory isolation between pods (cooperative sharing)
- Suitable for development and lightweight inference

```yaml
# time-slicing config
version: v1
sharing:
  timeSlicing:
    resources:
    - name: nvidia.com/gpu
      replicas: 4  # 4 virtual GPUs per physical GPU
```

### MIG-Backed Scheduling

- Schedule pods on specific MIG profiles
- Hardware-level isolation between pods
- Resource names like `nvidia.com/mig-1g.10gb`
- Configured through MIG Manager

```yaml
resources:
  limits:
    nvidia.com/mig-3g.40gb: 1  # Request a 3g.40gb MIG slice
```

### Topology-Aware Scheduling

- Consider GPU interconnect topology for multi-GPU jobs
- Prefer GPUs connected via NVLink over PCIe
- Node affinity rules for GPU model selection
- Topology manager in Kubernetes for co-located resources

### Multi-Node Training

- Use Kubernetes Job or custom operators (e.g., Kubeflow MPI Operator)
- Network policies for inter-pod GPU communication
- Host networking for InfiniBand access
- Shared storage via PersistentVolumeClaims

## GPU Monitoring in Kubernetes

### DCGM Exporter Metrics

**Key Metrics Exported:**
- `DCGM_FI_DEV_GPU_UTIL` - GPU utilization percentage
- `DCGM_FI_DEV_FB_USED` - GPU memory used (bytes)
- `DCGM_FI_DEV_FB_FREE` - GPU memory free (bytes)
- `DCGM_FI_DEV_POWER_USAGE` - Power consumption (watts)
- `DCGM_FI_DEV_GPU_TEMP` - GPU temperature (Celsius)
- `DCGM_FI_DEV_NVLINK_BANDWIDTH_TOTAL` - NVLink throughput
- `DCGM_FI_DEV_PCIE_REPLAY_COUNTER` - PCIe replay errors
- `DCGM_FI_DEV_ECC_DBE_VOL_TOTAL` - Double-bit ECC errors

**[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - Metrics reference

### Grafana Dashboards
- GPU utilization heatmaps across cluster
- Memory usage per pod and per GPU
- Power consumption trends
- Temperature monitoring and throttling alerts
- NVLink and PCIe bandwidth utilization

### Alerting Rules
- GPU utilization < 10% for extended period (underutilization)
- GPU memory > 95% (OOM risk)
- Temperature > thermal threshold (throttling)
- ECC errors detected (hardware issues)
- GPU fallen off bus (driver/hardware failure)

## Node Management

### Node Labeling
- Automatic labels via GPU Feature Discovery
- `nvidia.com/gpu.product` - GPU model name
- `nvidia.com/gpu.memory` - GPU memory size
- `nvidia.com/mig.capable` - MIG support
- `nvidia.com/gpu.count` - Number of GPUs

### Driver Management
- GPU Operator can install drivers automatically
- Driver version pinning for stability
- Rolling driver updates across cluster
- Pre-installed driver mode for custom environments

### Node Maintenance
- Cordon node to prevent new GPU workloads
- Drain existing workloads gracefully
- Perform driver or firmware updates
- Uncordon to return node to service
- GPU health checks before returning to pool

## Key Exam Concepts

- GPU Operator components and their roles
- GPU scheduling syntax in pod specs
- Time-slicing vs MIG for GPU sharing
- DCGM Exporter metrics for monitoring
- Topology-aware scheduling for multi-GPU jobs
- Node labeling and feature discovery
