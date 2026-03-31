# NCP-AIO AI Operations Professional Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **MLOps Fundamentals**
   - ML pipeline stages and orchestration
   - Model versioning and registry management
   - CI/CD practices for ML
   - **[📖 NVIDIA AI Enterprise](https://docs.nvidia.com/ai-enterprise/)**

2. **Model Serving**
   - Triton Inference Server architecture and configuration
   - NIM deployment and management
   - Deployment patterns (blue-green, canary, A/B)
   - **[📖 Triton Docs](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)**

### Phase 2: Operations (2-3 weeks)
1. **GPU Monitoring**
   - DCGM architecture, metrics, and diagnostics
   - Prometheus/Grafana integration
   - Alerting strategy design
   - **[📖 DCGM Docs](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)**

2. **Fleet Management**
   - Driver and firmware lifecycle
   - Configuration management at scale
   - Security and compliance
   - **[📖 GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)**

3. **Incident Response**
   - GPU failure modes and Xid errors
   - Troubleshooting procedures
   - Disaster recovery patterns

### Phase 3: Exam Prep (1-2 weeks)
1. Practice scenario-based questions
2. Review key metrics and commands
3. Focus on weak areas

## Recommended Resources

### Official NVIDIA Resources
- **[NVIDIA DLI Courses](https://www.nvidia.com/en-us/training/)** - Official training
- **[DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/latest/index.html)** - GPU monitoring
- **[Triton Documentation](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)** - Model serving
- **[NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Inference microservices
- **[NVIDIA Developer Blog](https://developer.nvidia.com/blog/)** - Technical articles

## Exam Tactics

### Keywords to Watch For
- "Monitoring" or "health" - think DCGM
- "Deploy" or "serve" - think Triton or NIM
- "Pipeline" or "lifecycle" - think MLOps
- "Failure" or "error" - think Xid codes and incident response
- "Update" or "patch" - think fleet management
- "Scale" - think auto-scaling and capacity planning

### Common Pitfalls
- DCGM is for monitoring/diagnostics, Nsight is for profiling
- Triton is for general model serving, NIM is for optimized LLM inference
- Single-bit ECC errors are normal at low rates but concerning when rising
- Double-bit ECC errors are always critical events
- Data drift causes gradual accuracy decline, not GPU issues

### Time Management
- 120 minutes for 60-70 questions
- ~1.7-2 minutes per question
- Flag specification-heavy questions for review
- Reserve 15 minutes for flagged questions

## Self-Assessment Questions
- Can I configure Triton model repository and dynamic batching?
- Do I know DCGM diagnostic levels and key metric field IDs?
- Can I design an alerting strategy for a GPU cluster?
- Do I know key Xid error codes and appropriate responses?
- Can I plan a rolling driver update for a production fleet?
- Do I understand checkpointing and DR for training workloads?
