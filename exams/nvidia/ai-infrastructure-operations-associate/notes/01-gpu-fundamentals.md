# GPU Fundamentals and Monitoring

**[📖 NVIDIA SMI Documentation](https://developer.nvidia.com/nvidia-system-management-interface)** - System management interface

## GPU Architecture Basics

### NVIDIA GPU Components
- **Streaming Multiprocessors (SMs)** - Primary compute units
- **Tensor Cores** - Specialized for matrix math (AI training/inference)
- **HBM Memory** - High-bandwidth GPU memory
- **NVLink** - High-speed GPU-to-GPU interconnect
- **PCIe Interface** - Connection to CPU and system

### GPU Families for Data Centers
- **Ampere** - A100, A30 (generation)
- **Hopper** - H100, H200 (current generation)
- **Ada Lovelace** - L40S (workstation/inference)

### Key Specifications to Know
- GPU memory size (40GB, 80GB, 141GB)
- Memory bandwidth (TB/s)
- Compute performance (TFLOPS)
- Number of Tensor Cores
- Supported data types (FP32, FP16, BF16, FP8, INT8)

## nvidia-smi

### Basic Usage

```bash
# Display GPU status
nvidia-smi
```

**Output includes:**
- GPU model name
- Driver and CUDA version
- Temperature and power usage
- Memory usage (used/total)
- GPU utilization percentage
- Running processes

### Monitoring Commands

```bash
# Continuous monitoring (1 second interval)
nvidia-smi dmon -s pucvmet -d 1

# Process monitoring
nvidia-smi pmon -s um -d 1

# Query specific fields
nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used \
  --format=csv

# Detailed information
nvidia-smi -q

# Specific GPU
nvidia-smi -i 0 -q

# Clock information
nvidia-smi -q -d CLOCK

# ECC information
nvidia-smi -q -d ECC

# Temperature information
nvidia-smi -q -d TEMPERATURE
```

### Important Output Fields
- `GPU Util` - Percentage of time SMs are active
- `Mem Util` - Memory controller utilization
- `Temp` - GPU temperature in Celsius
- `Pwr:Usage/Cap` - Current power / maximum power
- `Memory-Usage` - Used / Total GPU memory
- `Processes` - PIDs using the GPU

## DCGM (Data Center GPU Manager)

### Overview
- Enterprise GPU monitoring and management
- Health checks and diagnostics
- Telemetry collection
- Group management for multi-GPU operations
- **[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**

### Basic Commands

```bash
# Start DCGM
systemctl start nvidia-dcgm

# Check GPU health (quick)
dcgmi diag -r 1

# Check GPU health (comprehensive)
dcgmi diag -r 3

# Monitor metrics in real-time
dcgmi dmon -e 203,204,150,155 -d 1000
# 203=GPU util, 204=Mem util, 150=Power, 155=Temperature

# Set health watches
dcgmi health -s a  # All watches

# Check health status
dcgmi health -c

# Create GPU group
dcgmi group -c training-gpus
dcgmi group -a training-gpus 0,1,2,3
```

### DCGM Health Watches
- **PCIe** (p) - Bus errors and bandwidth
- **Memory** (m) - ECC errors and page retirement
- **Inforom** (i) - GPU information ROM
- **Thermal** (t) - Temperature monitoring
- **Power** (w) - Power limit and violations
- **NVLink** (n) - Link errors

### Diagnostic Levels
- **Level 1 (Quick)**: ~15 seconds, basic checks
- **Level 2 (Medium)**: ~2 minutes, hardware short test
- **Level 3 (Long)**: ~15 minutes, comprehensive stress test

## GPU Health Indicators

### Normal Operation
- Temperature: 30-80C under load
- GPU utilization: varies by workload (0-100%)
- Power: within TDP limits
- No ECC errors (or very few SBE)
- Stable clock speeds

### Warning Signs
- Temperature > 83C (throttling begins)
- Rising single-bit ECC error rate
- PCIe replay count increasing
- Clock speed lower than expected
- NVLink errors accumulating

### Critical Indicators
- Double-bit ECC errors (any)
- GPU fallen off bus (Xid 79)
- Temperature approaching shutdown threshold
- Persistent CUDA errors across workloads

## ECC Error Types

### Single-Bit Errors (SBE)
- Correctable by hardware
- Normal at very low rates
- Concerning when rate increases over time
- May lead to page retirement
- Track via: `nvidia-smi -q -d ECC`

### Double-Bit Errors (DBE)
- Uncorrectable
- Causes CUDA errors in running workloads
- Affected memory page retired immediately
- Any DBE should be investigated
- May indicate need for GPU replacement

### Page Retirement
- Bad memory pages are taken offline
- SBE-retired: pages with repeated single-bit errors
- DBE-retired: pages with double-bit errors
- Limited number of retirable pages
- Xid 63 when limit reached (GPU replacement needed)

## Key Exam Concepts

- nvidia-smi basic and monitoring commands
- Understanding nvidia-smi output fields
- DCGM diagnostic levels and health watches
- ECC error types: SBE (correctable) vs DBE (uncorrectable)
- GPU health indicators and warning signs
- GPU temperature thresholds and throttling
