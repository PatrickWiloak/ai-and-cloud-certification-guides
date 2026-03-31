# Troubleshooting and Maintenance

**[📖 NVIDIA Driver Documentation](https://docs.nvidia.com/datacenter/tesla/index.html)** - Data center driver guides

## Common GPU Issues

### GPU Not Detected

**Symptoms:** nvidia-smi shows "No devices found" or fails

**Diagnosis:**
```bash
# Check if GPU is visible on PCIe bus
lspci | grep -i nvidia

# Check if driver is loaded
lsmod | grep nvidia

# Check kernel messages
dmesg | grep -i nvidia

# Check driver version
cat /proc/driver/nvidia/version
```

**Resolution:**
- If not on PCIe bus: hardware or BIOS issue
- If driver not loaded: install or reinstall driver
- If driver mismatch: install correct driver version
- If Secure Boot conflict: sign driver or disable Secure Boot

### Out of Memory (OOM)

**Symptoms:** CUDA out of memory error, training/inference crashes

**Diagnosis:**
```bash
# Check memory usage
nvidia-smi

# Identify processes using GPU memory
nvidia-smi pmon -s um

# Check for orphaned processes
fuser -v /dev/nvidia*
```

**Resolution:**
- Reduce batch size
- Use mixed precision (FP16/BF16)
- Enable gradient checkpointing
- Kill orphaned GPU processes
- Use a GPU with more memory

### Thermal Throttling

**Symptoms:** Lower-than-expected performance, clock speed drops

**Diagnosis:**
```bash
# Check temperature
nvidia-smi -q -d TEMPERATURE

# Check clock speeds
nvidia-smi -q -d CLOCK

# Check throttle reasons
nvidia-smi -q -d PERFORMANCE
```

**Resolution:**
- Check data center cooling (temperature, airflow)
- Clean dust from heat sinks and fans
- Verify fans are running at correct speed
- Check for hot aisle containment issues
- Reduce GPU power limit as temporary measure

### Container GPU Access Failure

**Symptoms:** Container cannot see GPUs, nvidia-smi fails inside container

**Diagnosis:**
```bash
# Test container GPU access
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi

# Check Docker runtime configuration
docker info | grep -i runtime

# Check Container Toolkit installation
nvidia-ctk --version

# Check Docker daemon config
cat /etc/docker/daemon.json
```

**Resolution:**
- Install/reinstall NVIDIA Container Toolkit
- Run `nvidia-ctk runtime configure --runtime=docker`
- Restart Docker: `systemctl restart docker`
- Verify host nvidia-smi works first
- Check NVIDIA_VISIBLE_DEVICES environment variable

## Log Analysis

### System Logs

```bash
# GPU driver messages
dmesg | grep -i nvidia

# Xid errors (GPU driver errors)
dmesg | grep -i xid

# System journal for GPU
journalctl -u nvidia-persistenced

# Container runtime logs
journalctl -u docker
```

### Key Xid Errors

| Xid | Meaning | Severity | Action |
|-----|---------|----------|--------|
| 31 | Memory page fault | Medium | Check workload for bugs |
| 43 | GPU stopped processing | High | Reset GPU, check hardware |
| 48 | Double-bit ECC error | Critical | Replace GPU if recurring |
| 63 | ECC page retirement limit | Critical | Replace GPU |
| 79 | GPU fallen off bus | Critical | Reboot, likely hardware |
| 94 | Contained ECC error | High | Monitor, may need replacement |

### DCGM Diagnostics

```bash
# Quick health check
dcgmi diag -r 1

# Medium diagnostic
dcgmi diag -r 2

# Comprehensive stress test
dcgmi diag -r 3

# Collect bug report
nvidia-bug-report.sh
```

## Performance Monitoring

### Identifying Bottlenecks

**GPU Underutilization:**
- Low GPU util + high CPU util = CPU bottleneck
- Low GPU util + low CPU util = data loading bottleneck
- Periodic GPU idle gaps = I/O bottleneck
- Low GPU util during all-reduce = network bottleneck

**Memory Issues:**
- GPU memory near capacity = risk of OOM
- Low memory util with low GPU util = small batch size
- Memory growing over time = memory leak

### Monitoring Tools
- **nvidia-smi** - Basic real-time monitoring
- **DCGM** - Enterprise GPU monitoring
- **Prometheus + Grafana** - Metrics dashboard
- **Nsight Systems** - Detailed performance profiling

## Maintenance Procedures

### Driver Updates
1. Check current version: `nvidia-smi --query-gpu=driver_version --format=csv`
2. Download new driver from NVIDIA
3. Stop GPU workloads
4. Unload old driver or stop display manager
5. Install new driver
6. Reboot and verify with nvidia-smi
7. Run DCGM diagnostic to verify health

### GPU Reset

```bash
# Soft reset (if GPU is responsive)
nvidia-smi -r -i <gpu_id>

# If GPU is unresponsive, reboot the node
sudo reboot
```

### Node Maintenance (Kubernetes)

```bash
# Cordon node (prevent new pods)
kubectl cordon <node>

# Drain workloads
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data

# Perform maintenance

# Return to service
kubectl uncordon <node>
```

### Escalation Checklist
When escalating a GPU issue:
- [ ] Collect `nvidia-bug-report.sh` output
- [ ] Record nvidia-smi output
- [ ] Collect DCGM diagnostic results
- [ ] Note Xid errors from dmesg
- [ ] Record GPU serial numbers
- [ ] Document symptoms and timeline
- [ ] List steps already attempted

## Key Exam Concepts

- nvidia-smi troubleshooting commands
- Common GPU issues: not detected, OOM, throttling, container access
- Xid error codes and their meanings
- Log locations and analysis commands
- Bottleneck identification from monitoring data
- Driver update and GPU reset procedures
- Kubernetes node maintenance commands
- Escalation documentation requirements
