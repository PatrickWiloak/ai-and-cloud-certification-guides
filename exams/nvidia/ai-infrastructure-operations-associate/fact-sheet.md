# NVIDIA AI Infrastructure Operations Associate - Fact Sheet

## Quick Reference

**Exam Code:** NCA-AIIO
**Duration:** 60 minutes
**Questions:** 50-60 questions
**Passing Score:** Not officially published
**Cost:** $135 USD
**Validity:** 2 years
**Difficulty:** Associate (foundational)

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| GPU Fundamentals and Monitoring | 25% | nvidia-smi, DCGM, GPU metrics |
| Container and Runtime Management | 25% | Container Toolkit, Docker, NGC |
| Kubernetes GPU Operations | 20% | GPU Operator, scheduling, MIG |
| Infrastructure Management | 15% | Drivers, CUDA, storage, networking |
| Troubleshooting and Maintenance | 15% | Error diagnosis, logs, escalation |

## Domain 1: GPU Fundamentals and Monitoring

### nvidia-smi Commands

```bash
# Basic GPU status
nvidia-smi

# Detailed query
nvidia-smi -q

# Continuous monitoring
nvidia-smi dmon -s pucvmet

# Process monitoring
nvidia-smi pmon -s um

# MIG status
nvidia-smi mig -lgi

# GPU reset
nvidia-smi -r -i <gpu_id>
```

### Key GPU Metrics

| Metric | Description | Normal Range |
|--------|-------------|-------------|
| GPU Utilization | SM activity % | Workload-dependent |
| Memory Used | GPU memory allocation | < 95% of total |
| Temperature | GPU die temperature | < 83C |
| Power Draw | Current wattage | < TDP |
| Fan Speed | Cooling fan percentage | Automatic |
| Clock Speed | SM and memory clock | Varies by load |

### DCGM Basics

```bash
# Check GPU health
dcgmi diag -r 1  # Quick check

# Monitor metrics
dcgmi dmon -e 203,204,150,155

# Health watches
dcgmi health -s a  # All watches

# Group management
dcgmi group -c mygroup
dcgmi group -a mygroup 0,1
```

**[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**

### ECC Errors
- **Single-Bit Errors (SBE)** - Correctable, normal at low rates
- **Double-Bit Errors (DBE)** - Uncorrectable, critical
- Volatile counts: since last reset
- Aggregate counts: lifetime total
- Page retirement: bad memory pages taken offline

## Domain 2: Container and Runtime Management

### NVIDIA Container Toolkit

**Purpose:** Enable GPU access inside containers

**Components:**
- nvidia-container-runtime
- nvidia-container-cli
- libnvidia-container
- nvidia-ctk (configuration tool)

**Installation:**
```bash
# Configure repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Install
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

**[📖 Container Toolkit Docs](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)**

### Docker with GPU

```bash
# Run container with all GPUs
docker run --gpus all nvidia/cuda:12.0-base-ubuntu22.04 nvidia-smi

# Specific GPUs
docker run --gpus '"device=0,1"' nvidia/cuda:12.0-base-ubuntu22.04 nvidia-smi

# GPU count
docker run --gpus 2 nvidia/cuda:12.0-base-ubuntu22.04 nvidia-smi
```

### NGC Container Registry

- NVIDIA's container and model registry
- Pre-built containers for AI frameworks (PyTorch, TensorFlow)
- Optimized and tested by NVIDIA
- Regular updates with latest drivers and libraries
- **[📖 NGC Catalog](https://catalog.ngc.nvidia.com/)** - Browse containers

```bash
# Login to NGC
docker login nvcr.io

# Pull container
docker pull nvcr.io/nvidia/pytorch:24.01-py3
```

## Domain 3: Kubernetes GPU Operations

### GPU Operator

**What it Does:**
- Automates GPU driver installation
- Deploys Container Toolkit on nodes
- Installs DCGM Exporter for monitoring
- Manages GPU Device Plugin
- Handles GPU Feature Discovery
- Manages MIG configuration

**Installation:**
```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm install gpu-operator nvidia/gpu-operator \
  --namespace gpu-operator --create-namespace
```

**[📖 GPU Operator Docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)**

### GPU Scheduling

```yaml
# Pod requesting 1 GPU
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gpu-app
    image: nvcr.io/nvidia/pytorch:24.01-py3
    resources:
      limits:
        nvidia.com/gpu: 1
```

### MIG Basics
- Partition one GPU into smaller instances
- Hardware-level isolation
- Supported on A100 and H100
- Managed by GPU Operator's MIG Manager
- Request MIG slices: `nvidia.com/mig-1g.10gb: 1`

## Domain 4: Infrastructure Management

### GPU Driver Management

**Driver Types:**
- **Data center driver** - For server GPUs (Tesla, A100, H100)
- **Production branch** - Stable, long-term support
- **New feature branch** - Latest features

**Commands:**
```bash
# Check driver version
nvidia-smi --query-gpu=driver_version --format=csv

# Check CUDA version
nvcc --version
```

### CUDA Toolkit
- Programming tools for GPU development
- Runtime libraries for GPU applications
- Version compatibility with drivers
- Forward-compatible runtime

### System Requirements
- Linux OS (Ubuntu, RHEL, CentOS)
- Compatible NVIDIA GPU
- Sufficient PCIe bandwidth
- Adequate power and cooling
- GPU driver matching CUDA requirements

## Domain 5: Troubleshooting

### Common Issues

**GPU Not Detected:**
1. Check `lspci | grep NVIDIA`
2. Verify driver is loaded: `lsmod | grep nvidia`
3. Check driver logs: `dmesg | grep nvidia`
4. Reinstall driver if needed

**Out of Memory (OOM):**
1. Check memory usage: `nvidia-smi`
2. Identify processes: `nvidia-smi pmon`
3. Reduce batch size or model size
4. Kill orphaned GPU processes

**Performance Issues:**
1. Check GPU utilization: `nvidia-smi dmon`
2. Check thermal throttling: `nvidia-smi -q -d CLOCK`
3. Verify expected clock speeds
4. Check for data loading bottlenecks

**Container GPU Issues:**
1. Verify Container Toolkit is installed
2. Check Docker runtime configuration
3. Test with: `docker run --gpus all nvidia/cuda:12.0-base nvidia-smi`
4. Check container logs for driver mismatch

### Key Xid Errors
- Xid 31: GPU memory page fault
- Xid 48: Double-bit ECC error
- Xid 79: GPU fallen off bus
- Check with: `dmesg | grep -i xid`

### Escalation
- Document the issue (symptoms, commands run, results)
- Collect nvidia-bug-report.sh output
- Collect DCGM diagnostic results
- Escalate with hardware serial numbers and error codes

## Exam Tips

### Key Concepts to Master
1. nvidia-smi commands and output interpretation
2. DCGM basic commands and health checks
3. Docker GPU flags (--gpus)
4. Container Toolkit installation and configuration
5. GPU Operator components and Kubernetes GPU scheduling
6. Common GPU troubleshooting steps
