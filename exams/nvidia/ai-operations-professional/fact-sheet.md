# NVIDIA AI Operations Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-AIO
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| MLOps and Model Lifecycle | 20% | Pipelines, versioning, CI/CD for ML |
| Model Deployment and Serving | 20% | Triton, NIM, containerization, scaling |
| GPU Monitoring with DCGM | 20% | Health checks, metrics, alerting |
| Fleet Management | 20% | Multi-cluster ops, drivers, compliance |
| Incident Response and Reliability | 20% | Troubleshooting, DR, SLA management |

## Domain 1: MLOps and Model Lifecycle

### ML Pipeline Automation

**Pipeline Components:**
- Data ingestion and validation
- Feature engineering and storage
- Model training and hyperparameter tuning
- Model evaluation and validation
- Model packaging and registration
- Deployment and monitoring
- **[📖 NVIDIA AI Enterprise](https://docs.nvidia.com/ai-enterprise/)** - Enterprise ML platform

**Orchestration Tools:**
- Kubeflow Pipelines for Kubernetes-native ML workflows
- Apache Airflow for general-purpose DAG orchestration
- MLflow for experiment tracking and model registry
- NVIDIA Base Command for GPU-optimized job management

### Model Versioning and Registry

**Model Artifacts:**
- Trained model weights and parameters
- Model configuration and hyperparameters
- Training data version and preprocessing steps
- Evaluation metrics and validation results
- Deployment configuration and serving metadata

**Registry Features:**
- Semantic versioning for models
- Stage transitions (staging, production, archived)
- Lineage tracking (data, code, config)
- Access control and approval workflows
- Metadata search and discovery

### CI/CD for ML

**ML-Specific CI/CD:**
- Automated training pipeline triggers on data or code changes
- Model validation gates (accuracy thresholds, fairness checks)
- Automated deployment to staging environments
- Canary and A/B testing before production promotion
- Rollback procedures for degraded model performance

## Domain 2: Model Deployment and Serving

### NVIDIA Triton Inference Server

**Key Features:**
- Multi-framework support (TensorRT, ONNX, PyTorch, TensorFlow)
- Dynamic batching for throughput optimization
- Model ensemble and pipeline support
- Concurrent model execution
- HTTP/REST and gRPC APIs
- Metrics endpoint for monitoring
- **[📖 Triton Documentation](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)**

**Model Repository:**
```
model_repository/
  model_name/
    config.pbtxt
    1/
      model.plan  # TensorRT
    2/
      model.onnx  # ONNX
```

**Configuration:**
- Instance groups (GPU and CPU execution)
- Dynamic batching parameters
- Model warm-up for consistent latency
- Rate limiting and priority queuing

### NVIDIA NIM

- Pre-optimized inference containers
- OpenAI-compatible API
- TensorRT-LLM optimization built-in
- Simple deployment with Docker or Kubernetes
- Auto-tuning for target GPU hardware
- **[📖 NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)**

### Deployment Patterns

**Blue-Green Deployment:**
- Two identical production environments
- Switch traffic between versions atomically
- Instant rollback capability
- Higher resource cost (2x infrastructure during transition)

**Canary Deployment:**
- Route small percentage of traffic to new version
- Monitor metrics and gradually increase traffic
- Automatic rollback on metric degradation
- Lower risk than blue-green

**A/B Testing:**
- Route traffic based on user segments
- Compare model performance metrics
- Statistical significance testing
- Data-driven model promotion decisions

## Domain 3: GPU Monitoring with DCGM

### DCGM Architecture

**Components:**
- **DCGM Engine (nv-hostengine)** - Core monitoring daemon
- **DCGM Agent** - Per-node data collection
- **DCGM Exporter** - Prometheus metrics export
- **dcgmi** - Command-line management tool
- **[📖 DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**

### Health Monitoring

**Health Watch Categories:**
- **PCIe** - Bus errors and replay counts
- **Memory** - ECC errors (single-bit and double-bit)
- **Inforom** - GPU information ROM integrity
- **Thermal** - Temperature and throttling
- **Power** - Power limit and violations
- **NVLink** - Link errors and degradation

**Diagnostic Levels:**
- Level 1: Quick health check (~15 seconds)
- Level 2: Medium diagnostic (~2 minutes)
- Level 3: Comprehensive stress test (~15 minutes)

### Key Metrics

| Metric | Description | Alert Threshold |
|--------|------------|----------------|
| GPU Utilization | SM activity % | < 10% (underutilized) |
| Memory Used | GPU memory allocation | > 95% (OOM risk) |
| Temperature | GPU die temp | > 83C (throttling) |
| Power Draw | Current wattage | Near TDP (sustained) |
| ECC SBE | Single-bit errors | Increasing trend |
| ECC DBE | Double-bit errors | Any occurrence |
| XID Errors | GPU driver errors | Any critical XID |

### Prometheus/Grafana Integration

- DCGM Exporter runs as DaemonSet in Kubernetes
- Exposes metrics on /metrics endpoint
- Prometheus scrapes metrics at configured interval
- Grafana dashboards for visualization
- AlertManager for automated alerting

## Domain 4: Fleet Management

### Multi-Cluster Operations

- Centralized management of GPU clusters across locations
- Consistent configuration across environments
- Centralized monitoring and alerting
- Uniform software stack deployment

### Driver and Firmware Lifecycle

**Update Strategies:**
- Rolling updates to minimize downtime
- Drain workloads before updating nodes
- Test updates on canary nodes first
- Maintain driver compatibility matrix
- Schedule updates during maintenance windows

### Configuration Management

- Infrastructure as Code (Ansible, Terraform, Puppet)
- GPU driver version pinning per cluster
- CUDA toolkit version management
- Container image version control
- Network configuration consistency

### Security and Compliance

- GPU driver CVE patching
- Container image scanning
- Network security policies for GPU traffic
- Audit logging for GPU resource access
- Compliance reporting for regulated industries

## Domain 5: Incident Response and Reliability

### GPU Failure Modes

**Common Failures:**
- ECC memory errors (correctable and uncorrectable)
- GPU fallen off bus (Xid 79)
- NVLink errors and degradation
- Thermal throttling from cooling failure
- Power supply issues
- Driver crashes (various Xid codes)

**Xid Error Codes (Key Ones):**
- Xid 31: GPU memory page fault
- Xid 48: Double-bit ECC error
- Xid 63: ECC page retirement limit reached
- Xid 79: GPU has fallen off the bus
- Xid 94: Contained ECC error

### Incident Response Procedures

1. **Detect** - Automated alerting via DCGM and monitoring
2. **Triage** - Classify severity and impact
3. **Isolate** - Cordon affected node, redirect workloads
4. **Diagnose** - Run DCGM diagnostics, check logs
5. **Resolve** - Apply fix (driver reset, node replacement)
6. **Verify** - Confirm resolution with health checks
7. **Review** - Post-incident analysis and prevention

### Disaster Recovery

- Checkpoint and resume for long-running training jobs
- Model artifact replication across regions
- Inference service redundancy across clusters
- Automated failover for critical inference endpoints
- Recovery time objectives (RTO) and recovery point objectives (RPO)

## Exam Tips

### Key Concepts to Master
1. MLOps pipeline components and automation
2. Triton Inference Server configuration and deployment
3. DCGM health monitoring, diagnostics, and metrics
4. Fleet management and driver lifecycle
5. GPU failure modes and Xid error codes
6. Incident response procedures
