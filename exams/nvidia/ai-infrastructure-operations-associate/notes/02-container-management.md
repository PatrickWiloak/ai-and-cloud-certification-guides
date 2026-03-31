# Container and Runtime Management

**[📖 Container Toolkit Documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)** - GPU container support

## NVIDIA Container Toolkit

### Purpose
Enable GPU-accelerated containers by providing:
- GPU driver access inside containers
- CUDA library mounting
- Device management for container runtimes
- Works with Docker, containerd, CRI-O

### Components
- **nvidia-container-runtime** - OCI-compliant runtime wrapper
- **nvidia-container-cli** - CLI for configuring GPU containers
- **libnvidia-container** - Library for GPU device management
- **nvidia-ctk** - Configuration and setup utility

### Installation

```bash
# Add NVIDIA repository
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Install toolkit
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker runtime
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verify
docker run --rm --gpus all nvidia/cuda:12.0-base-ubuntu22.04 nvidia-smi
```

### CDI (Container Device Interface)
- Standard for exposing devices to containers
- Replaces older nvidia-docker2 approach
- Better integration with container runtimes
- Kubernetes support through device plugins

## Docker with GPU

### Running GPU Containers

```bash
# All GPUs
docker run --gpus all nvidia/cuda:12.0-base-ubuntu22.04 nvidia-smi

# Specific number of GPUs
docker run --gpus 2 <image>

# Specific GPU devices
docker run --gpus '"device=0,1"' <image>

# Specific GPU by UUID
docker run --gpus '"device=GPU-uuid-here"' <image>

# Specific capabilities
docker run --gpus '"capabilities=compute,utility"' <image>
```

### Environment Variables
- `NVIDIA_VISIBLE_DEVICES` - Which GPUs to expose (all, none, or device IDs)
- `NVIDIA_DRIVER_CAPABILITIES` - What driver features to enable
- `CUDA_VISIBLE_DEVICES` - Filter GPUs visible to CUDA applications

### Docker Compose with GPU

```yaml
services:
  training:
    image: nvcr.io/nvidia/pytorch:24.01-py3
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 2
              capabilities: [gpu]
```

## NGC Container Registry

### Overview
- NVIDIA's official container and model registry
- Pre-optimized containers for AI frameworks
- Regular updates with latest drivers and optimizations
- Tested and validated by NVIDIA
- **[📖 NGC Catalog](https://catalog.ngc.nvidia.com/)** - Browse available images

### Common NGC Containers

| Container | Purpose |
|-----------|---------|
| nvidia/pytorch | PyTorch training framework |
| nvidia/tensorflow | TensorFlow training framework |
| nvidia/cuda | Base CUDA development |
| nvidia/tritonserver | Inference serving |
| nvidia/nemo | NeMo framework |

### Usage

```bash
# Login to NGC
docker login nvcr.io
# Username: $oauthtoken
# Password: <NGC API Key>

# Pull framework container
docker pull nvcr.io/nvidia/pytorch:24.01-py3

# Run with GPU
docker run --gpus all -it nvcr.io/nvidia/pytorch:24.01-py3

# Pull Triton
docker pull nvcr.io/nvidia/tritonserver:24.01-py3
```

### NGC API Key
- Generate at https://ngc.nvidia.com/setup
- Required for pulling private containers
- Used as password with username `$oauthtoken`
- Store securely (environment variable or secrets manager)

## Container Best Practices

### Image Management
- Use specific version tags (not :latest)
- Pin CUDA version to match host driver
- Regular updates for security patches
- Scan images for vulnerabilities
- Use multi-stage builds for smaller images

### GPU Resource Management
- Allocate only needed GPUs per container
- Use MIG for sharing GPUs between containers
- Monitor GPU memory usage inside containers
- Clean up GPU processes on container stop
- Set memory limits to prevent OOM

### Networking and Storage
- Use host networking for InfiniBand/RDMA access
- Mount data volumes for training datasets
- Use shared memory (--shm-size) for PyTorch DataLoader
- Configure NFS or parallel FS mounts as volumes

```bash
# Typical training container launch
docker run --gpus all \
  --shm-size=16g \
  --network=host \
  -v /data:/data \
  -v /results:/results \
  nvcr.io/nvidia/pytorch:24.01-py3 \
  python train.py
```

## Key Exam Concepts

- Container Toolkit installation and configuration
- Docker --gpus flag options (all, count, device IDs)
- NGC container registry and common container images
- NVIDIA_VISIBLE_DEVICES environment variable
- Docker Compose GPU configuration
- Container best practices for GPU workloads
