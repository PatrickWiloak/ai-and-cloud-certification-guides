# GPU Monitoring with DCGM

**[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - Data Center GPU Manager

## DCGM Architecture

### Components

**DCGM Engine (nv-hostengine):**
- Core daemon running on each GPU node
- Collects GPU telemetry and health data
- Manages GPU groups and policies
- Provides API for management tools

**dcgmi CLI:**
- Command-line interface for DCGM operations
- GPU discovery, health checks, diagnostics
- Metric monitoring and policy management
- Group management for multi-GPU operations

**DCGM Exporter:**
- Exports GPU metrics in Prometheus format
- Runs as a DaemonSet in Kubernetes
- Configurable metric collection
- Integrates with Prometheus/Grafana stack

**DCGM Libraries:**
- C, Python, and Go bindings
- Programmatic access to GPU telemetry
- Custom monitoring tool integration
- Embedded health checks in applications

## Health Monitoring

### Health Watch Categories

**Memory:**
- ECC single-bit error (SBE) tracking
- ECC double-bit error (DBE) detection
- Page retirement monitoring
- Memory bandwidth degradation
- Row remapping status

**PCIe:**
- PCIe replay count monitoring
- Link speed and width verification
- Bandwidth utilization tracking
- Error detection and reporting

**NVLink:**
- Link error counts
- Bandwidth utilization
- Link degradation detection
- Recovery from transient errors

**Thermal:**
- GPU die temperature monitoring
- Memory temperature tracking
- Thermal throttling detection
- Fan speed and cooling status

**Power:**
- Power consumption tracking
- Power limit violations
- Voltage anomaly detection
- Power brake events

### Diagnostic Levels

**Level 1 - Quick (Software):**
- ~15 seconds runtime
- Basic GPU responsiveness check
- Driver communication verification
- Quick memory test

**Level 2 - Medium (Hardware Short):**
- ~2 minutes runtime
- PCIe bandwidth test
- Memory stress test (targeted)
- NVLink bandwidth verification
- Basic compute test

**Level 3 - Comprehensive (Hardware Long):**
- ~15 minutes runtime
- Full memory stress test
- Extended compute stress test
- Sustained PCIe bandwidth test
- NVLink error injection test
- Thermal stress under load

```bash
# Run comprehensive diagnostic
dcgmi diag -r 3

# Run diagnostic on specific GPU
dcgmi diag -r 2 -i 0

# Run diagnostic on GPU group
dcgmi diag -r 3 -g mygroup
```

**[📖 DCGM Diagnostics](https://docs.nvidia.com/datacenter/dcgm/latest/user-guide/dcgm-diagnostics.html)** - Diagnostic details

## Key Metrics

### GPU Utilization Metrics

| Field ID | Metric | Description |
|----------|--------|-------------|
| 155 | DCGM_FI_DEV_SM_ACTIVE | SM activity percentage |
| 203 | DCGM_FI_DEV_GPU_UTIL | Overall GPU utilization |
| 204 | DCGM_FI_DEV_MEM_COPY_UTIL | Memory controller utilization |
| 1001 | DCGM_FI_DEV_GPU_UTIL_SAMPLES | GPU utilization samples |

### Memory Metrics

| Field ID | Metric | Description |
|----------|--------|-------------|
| 251 | DCGM_FI_DEV_FB_FREE | Free framebuffer memory |
| 252 | DCGM_FI_DEV_FB_USED | Used framebuffer memory |
| 253 | DCGM_FI_DEV_FB_TOTAL | Total framebuffer memory |

### Error Metrics

| Field ID | Metric | Description |
|----------|--------|-------------|
| 310 | DCGM_FI_DEV_ECC_SBE_VOL_TOTAL | Volatile single-bit errors |
| 311 | DCGM_FI_DEV_ECC_DBE_VOL_TOTAL | Volatile double-bit errors |
| 312 | DCGM_FI_DEV_ECC_SBE_AGG_TOTAL | Aggregate single-bit errors |
| 313 | DCGM_FI_DEV_ECC_DBE_AGG_TOTAL | Aggregate double-bit errors |
| 392 | DCGM_FI_DEV_RETIRED_SBE | Retired pages (single-bit) |
| 393 | DCGM_FI_DEV_RETIRED_DBE | Retired pages (double-bit) |

### Thermal and Power Metrics

| Field ID | Metric | Description |
|----------|--------|-------------|
| 150 | DCGM_FI_DEV_POWER_USAGE | Power draw (watts) |
| 155 | DCGM_FI_DEV_GPU_TEMP | GPU temperature (C) |
| 156 | DCGM_FI_DEV_MEM_TEMP | Memory temperature (C) |

### Monitoring Commands

```bash
# Monitor GPU metrics in real-time
dcgmi dmon -e 203,204,150,155 -d 1000

# Monitor specific GPU
dcgmi dmon -i 0 -e 203,252,150

# Check health status
dcgmi health -s mpit  # memory, pcie, inforom, thermal

# Set health watch
dcgmi health -s a  # all watches
```

## Prometheus/Grafana Integration

### DCGM Exporter Deployment

```yaml
# Kubernetes DaemonSet
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: dcgm-exporter
spec:
  template:
    spec:
      containers:
      - name: dcgm-exporter
        image: nvcr.io/nvidia/k8s/dcgm-exporter:latest
        ports:
        - containerPort: 9400
          name: metrics
```

### Key Grafana Dashboards

**Cluster Overview:**
- Total GPU count and health status
- Aggregate utilization across cluster
- Error rate trends
- Power consumption totals

**Per-Node View:**
- Individual GPU utilization heatmap
- Memory usage per GPU
- Temperature and power per GPU
- Error counts per GPU

**Per-Job View:**
- GPU utilization during job execution
- Memory allocation and peak usage
- Training throughput correlation
- Idle time identification

### Alerting Rules

```yaml
# Prometheus alerting rules
groups:
- name: gpu-alerts
  rules:
  - alert: GPUHighTemperature
    expr: DCGM_FI_DEV_GPU_TEMP > 83
    for: 5m
    labels:
      severity: warning

  - alert: GPUDoublebitError
    expr: DCGM_FI_DEV_ECC_DBE_VOL_TOTAL > 0
    labels:
      severity: critical

  - alert: GPULowUtilization
    expr: DCGM_FI_DEV_GPU_UTIL < 10
    for: 30m
    labels:
      severity: info
```

## Proactive Failure Detection

### Early Warning Indicators
- Increasing single-bit ECC error rate
- Rising PCIe replay counts
- NVLink error accumulation
- Gradual temperature increase trend
- Clock throttling frequency increasing

### Automated Response
- Auto-cordon Kubernetes nodes with GPU errors
- Migrate workloads from degraded GPUs
- Trigger replacement workflow for failing hardware
- Notify operations team via PagerDuty/Slack
- Create incident ticket automatically

## Key Exam Concepts

- DCGM architecture: engine, CLI, exporter, libraries
- Health watch categories and diagnostic levels
- Key metric field IDs and their meanings
- ECC error types: single-bit vs double-bit, volatile vs aggregate
- Prometheus/Grafana integration and alerting
- Proactive failure detection patterns
