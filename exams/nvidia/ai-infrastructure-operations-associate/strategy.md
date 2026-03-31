# NCA-AIIO AI Infrastructure Operations Associate Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **GPU Monitoring** - nvidia-smi, DCGM, health indicators
2. **Containers** - Container Toolkit, Docker GPU flags, NGC
- **[📖 DCGM Docs](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**
- **[📖 Container Toolkit Docs](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)**

### Phase 2: Operations (2-3 weeks)
1. **Kubernetes** - GPU Operator, scheduling, MIG
2. **Infrastructure** - Drivers, CUDA compatibility, maintenance
3. **Troubleshooting** - Common issues, Xid errors, log analysis
- **[📖 GPU Operator Docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)**

### Phase 3: Exam Prep (1 week)
1. Practice scenario-based questions
2. Review commands and error codes
3. Focus on hands-on procedures

## Recommended Resources
- **[DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - GPU monitoring
- **[Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)** - GPU containers
- **[GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)** - Kubernetes GPU
- **[NGC Catalog](https://catalog.ngc.nvidia.com/)** - Container registry
- **[NVIDIA DLI Courses](https://www.nvidia.com/en-us/training/)** - Official training

## Exam Tactics

### Keywords
- "Monitor" or "health" - nvidia-smi or DCGM
- "Container" or "Docker" - Container Toolkit, --gpus flag
- "Kubernetes" or "pod" - GPU Operator, scheduling
- "Error" or "failure" - Xid codes, troubleshooting steps
- "Isolation" - MIG
- "Share GPU" - MIG or time-slicing
- "Driver" - Version compatibility, update procedure

### Common Pitfalls
- nvidia-smi shows driver info; nvcc shows CUDA toolkit version
- Container Toolkit enables GPU containers; GPU Operator manages Kubernetes GPU stack
- SBE is correctable and normal at low rates; DBE is always critical
- MIG provides hardware isolation; time-slicing provides no memory isolation
- GPU memory is separate from system RAM
- CUDA runtime version in containers must be compatible with host driver

### Time Management
- 60 minutes for 50-60 questions
- ~1 minute per question
- Flag uncertain questions and return at end
- Do not overthink straightforward command questions
