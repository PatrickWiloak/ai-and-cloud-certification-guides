# Incident Response and Reliability

**[📖 DCGM Diagnostics](https://docs.nvidia.com/datacenter/dcgm/latest/user-guide/dcgm-diagnostics.html)** - GPU diagnostic tools

## GPU Failure Modes

### Hardware Failures

**ECC Memory Errors:**
- **Single-Bit Errors (SBE)** - Correctable, data is repaired automatically
  - Normal at low rates, concerning when rate increases
  - Tracked as volatile (since reset) and aggregate (lifetime)
  - Memory pages with SBE may be retired proactively
- **Double-Bit Errors (DBE)** - Uncorrectable, causes computation failure
  - Any DBE is a critical event
  - Affected memory page is retired immediately
  - May require GPU replacement if persistent

**GPU Fallen Off Bus (Xid 79):**
- GPU becomes unresponsive to the driver
- Causes: hardware failure, PCIe issues, power problems
- Requires node reboot to recover
- If persistent, indicates hardware replacement needed

**NVLink Errors:**
- Link degradation reduces inter-GPU bandwidth
- Can cause training slowdown before complete failure
- DCGM tracks NVLink error counts per link
- Failed NVLink may require GPU or baseboard replacement

**Thermal Issues:**
- GPU throttles performance at high temperatures
- Sustained throttling indicates cooling system problem
- Check fans, heat sinks, airflow, and ambient temperature
- Thermal shutdown at extreme temperatures

### Software Failures

**Driver Crashes:**
- Various Xid error codes indicate different failure modes
- May be recoverable with GPU reset
- Persistent crashes may indicate hardware issue
- Check driver version compatibility

**CUDA Errors:**
- Out-of-memory (OOM) - workload exceeds GPU memory
- Illegal memory access - software bug or hardware issue
- Launch failure - kernel configuration error
- Timeout - kernel exceeds time limit

### Key Xid Error Codes

| Xid | Description | Severity | Action |
|-----|-------------|----------|--------|
| 31 | GPU memory page fault | Medium | Check workload, may be OOM |
| 43 | GPU stopped processing | High | Reset GPU, check hardware |
| 48 | Double-bit ECC error | Critical | Retire page, monitor for recurrence |
| 63 | ECC page retirement limit | Critical | Replace GPU |
| 79 | GPU fallen off bus | Critical | Reboot node, likely hardware failure |
| 94 | Contained ECC error | High | Monitor, may need replacement |

## Incident Response Procedures

### NVIDIA GPU Incident Response Framework

**1. Detection:**
- Automated alerts from DCGM monitoring
- User-reported job failures
- Anomaly detection in metrics
- Health check failures

**2. Triage:**
- Classify severity: Critical, High, Medium, Low
- Determine blast radius (single GPU, node, cluster)
- Assess impact on running workloads
- Assign incident to appropriate team

**3. Isolation:**
- Cordon affected Kubernetes node
- Drain running workloads to healthy nodes
- Disable job scheduling to affected resources
- Preserve logs and diagnostic data

**4. Diagnosis:**
```bash
# Check GPU health
dcgmi diag -r 3

# Review Xid errors
dmesg | grep -i xid

# Check ECC errors
nvidia-smi -q -d ECC

# Check NVLink status
nvidia-smi nvlink -s

# Check thermal status
nvidia-smi -q -d TEMPERATURE

# Check power status
nvidia-smi -q -d POWER
```

**5. Resolution:**
- **Transient error**: Reset GPU (`nvidia-smi -r -i <gpu_id>`), monitor
- **Driver issue**: Update or rollback driver version
- **ECC errors**: Retire pages, schedule replacement if persistent
- **Hardware failure**: Replace GPU or node
- **Thermal**: Fix cooling, reduce workload until repaired
- **Software**: Fix workload configuration, update libraries

**6. Verification:**
- Run DCGM Level 3 diagnostic on repaired GPU
- Submit test workload to verify functionality
- Monitor metrics for 24 hours before returning to production
- Uncordon node and resume scheduling

**7. Post-Incident Review:**
- Document root cause and resolution
- Update runbooks with new findings
- Implement preventive measures
- Share learnings with team

## Disaster Recovery

### Training Workload Recovery

**Checkpointing:**
- Regular model checkpoints during training (every N steps)
- Store checkpoints on persistent shared storage
- Include optimizer state, learning rate schedule, data position
- Validate checkpoint integrity before resuming
- Keep multiple checkpoint versions for rollback

**Recovery Process:**
1. Detect training job failure
2. Identify last valid checkpoint
3. Allocate new GPU resources (may be different node)
4. Resume training from checkpoint
5. Verify training metrics are consistent with pre-failure

### Inference Service Recovery

**High Availability:**
- Multiple inference replicas across nodes
- Load balancer with health checks
- Automatic restart on container failure
- Pod disruption budgets in Kubernetes
- Cross-cluster failover for critical services

**Recovery Time Objective (RTO):**
- Inference services: minutes (automatic failover)
- Training jobs: minutes to hours (checkpoint resume)
- Data pipelines: hours (re-run from last stage)

**Recovery Point Objective (RPO):**
- Inference services: zero (stateless, model in registry)
- Training jobs: depends on checkpoint frequency
- Data pipelines: depends on data versioning

### Multi-Region Resilience
- Model artifacts replicated across regions
- Inference endpoints in multiple regions
- DNS-based failover for regional outages
- Data consistency for feature stores

## SLA Management

### Inference SLAs

**Key Metrics:**
- Availability (uptime percentage)
- Latency (P50, P95, P99)
- Throughput (requests/second)
- Error rate (percentage of failed requests)

**Typical Targets:**
- Availability: 99.9% - 99.99%
- Latency P95: < 100ms (varies by model)
- Error rate: < 0.1%

### SLA Monitoring
- Real-time dashboards for SLA metrics
- Automated alerting when approaching SLA thresholds
- Error budget tracking
- Monthly SLA reports

## Key Exam Concepts

- GPU failure modes: ECC errors, Xid codes, thermal, NVLink
- Key Xid error codes and their meanings
- Incident response steps: detect, triage, isolate, diagnose, resolve, verify, review
- DCGM diagnostic commands and levels
- Checkpoint and resume for training recovery
- HA patterns for inference services
- RTO and RPO concepts for AI workloads
