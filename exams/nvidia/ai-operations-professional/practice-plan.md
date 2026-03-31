# NCP-AIO AI Operations Professional Study Plan

## 8-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: MLOps Fundamentals
**Focus:** ML lifecycle and pipeline automation

#### Day 1-2: ML Pipeline Architecture
- [ ] Study end-to-end ML pipeline stages
- [ ] Learn pipeline orchestration tools (Kubeflow, Airflow)
- [ ] Understand experiment tracking and reproducibility
- [ ] **Reference:** [NVIDIA AI Enterprise](https://docs.nvidia.com/ai-enterprise/)

#### Day 3-4: Model Versioning and Registry
- [ ] Study model artifact management
- [ ] Learn model registry concepts and stage transitions
- [ ] Understand lineage tracking for reproducibility
- [ ] Practice with MLflow model registry

#### Day 5-7: CI/CD for ML
- [ ] Study ML-specific CI/CD practices
- [ ] Learn validation gates and promotion criteria
- [ ] Understand continuous training triggers
- [ ] **Lab:** Set up a basic ML pipeline with versioning

### Week 2: Model Deployment
**Focus:** Triton and NIM deployment

#### Day 1-3: Triton Inference Server
- [ ] Study Triton architecture and model repository
- [ ] Learn config.pbtxt configuration
- [ ] Understand dynamic batching and model ensembles
- [ ] Practice deploying models on Triton
- [ ] **Reference:** [Triton Documentation](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)

#### Day 4-5: NVIDIA NIM
- [ ] Deploy NIM containers for LLM inference
- [ ] Compare NIM vs Triton capabilities
- [ ] Study auto-scaling configuration
- [ ] **Reference:** [NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)

#### Day 6-7: Deployment Patterns
- [ ] Study blue-green, canary, and A/B testing patterns
- [ ] Learn rollback procedures
- [ ] Understand auto-scaling metrics and configuration
- [ ] **Lab:** Deploy a model with canary traffic splitting

### Phase 2: Advanced Topics (Weeks 3-5)

#### Week 3: GPU Monitoring with DCGM

#### Day 1-2: DCGM Architecture
- [ ] Study DCGM components (engine, CLI, exporter)
- [ ] Learn health watch categories
- [ ] Understand diagnostic levels (1, 2, 3)
- [ ] **Reference:** [DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)

#### Day 3-4: Key Metrics
- [ ] Memorize important DCGM metrics and field IDs
- [ ] Learn ECC error types and their significance
- [ ] Study thermal and power monitoring
- [ ] Practice dcgmi commands

#### Day 5-7: Monitoring Stack
- [ ] Set up DCGM Exporter with Prometheus
- [ ] Create Grafana dashboards for GPU monitoring
- [ ] Configure alerting rules
- [ ] **Lab:** Build a complete GPU monitoring stack

### Week 4: Fleet Management

#### Day 1-2: Multi-Cluster Operations
- [ ] Study fleet architecture patterns
- [ ] Learn centralized management approaches
- [ ] Understand inventory and capacity management

#### Day 3-4: Driver and Firmware Lifecycle
- [ ] Study driver update strategies
- [ ] Learn compatibility matrix management
- [ ] Understand firmware update procedures
- [ ] **Reference:** [NVIDIA Driver Docs](https://docs.nvidia.com/datacenter/tesla/index.html)

#### Day 5-7: Configuration and Security
- [ ] Study Infrastructure as Code for GPU environments
- [ ] Learn security patching procedures
- [ ] Understand compliance requirements
- [ ] **Lab:** Automate GPU node configuration with Ansible

### Week 5: Incident Response and Reliability

#### Day 1-2: GPU Failure Modes
- [ ] Study hardware failure types (ECC, NVLink, thermal)
- [ ] Memorize key Xid error codes
- [ ] Learn software failure patterns
- [ ] Practice diagnostic procedures

#### Day 3-4: Incident Response
- [ ] Study the 7-step incident response framework
- [ ] Practice troubleshooting scenarios
- [ ] Learn isolation and recovery procedures
- [ ] **Lab:** Simulate and respond to GPU incidents

#### Day 5-7: Disaster Recovery
- [ ] Study checkpointing strategies for training
- [ ] Learn HA patterns for inference services
- [ ] Understand RTO and RPO concepts
- [ ] Review SLA management practices

### Phase 3: Review and Exam Prep (Weeks 6-8)

#### Week 6: Integration Practice
- [ ] End-to-end deployment scenario exercises
- [ ] Monitoring and incident response walkthroughs
- [ ] Fleet management simulations
- [ ] Practice multi-domain questions

#### Week 7: Review and Gap Analysis
- [ ] Review all five domains systematically
- [ ] Create flashcards for key metrics and commands
- [ ] Re-read documentation for weak areas
- [ ] Timed practice question sessions

#### Week 8: Final Preparation
- [ ] Review fact sheet and quick reference
- [ ] Full-length timed practice session
- [ ] Final review of weak areas
- [ ] Exam logistics preparation

## Self-Assessment Questions
- Can I configure Triton model repository and dynamic batching?
- Do I know key DCGM metrics and diagnostic commands?
- Can I design a driver update strategy for a GPU fleet?
- Do I know Xid error codes and appropriate responses?
- Can I design disaster recovery for training and inference?
