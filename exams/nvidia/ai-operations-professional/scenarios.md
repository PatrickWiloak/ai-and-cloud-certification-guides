# NCP-AIO High-Yield Scenarios and Practice Problems

## Scenario 1: Model Deployment Strategy

**Scenario**: A company is upgrading their production recommendation model from v2 to v3. The model serves 50,000 requests/minute and has strict SLA requirements (P95 latency < 50ms, 99.9% availability). The new model has different input preprocessing. How should the deployment be handled?

**Solution Pattern**:
- **Approach**: Canary deployment with automated rollback
- Deploy v3 alongside v2 with 1% traffic initially
- Monitor P95 latency, error rate, and recommendation quality metrics
- Gradually increase to 5%, 25%, 50%, 100% over 48 hours
- Automated rollback if P95 latency exceeds 50ms or error rate exceeds 0.1%
- Keep v2 running for 24 hours after full v3 promotion

**Common Distractors**:
- Blue-green with instant cutover - too risky for 50K req/min without gradual validation
- A/B testing - appropriate for quality evaluation, not for safe rollout
- In-place upgrade - causes downtime, violates 99.9% SLA
- Shadow deployment only - never validates under actual user-facing conditions

**Key Takeaway**: High-traffic production services need canary deployment with automated rollback based on SLA metrics.

---

## Scenario 2: GPU Health Diagnosis

**Scenario**: A training job fails intermittently on node dgx-05. DCGM shows increasing single-bit ECC errors on GPU 3 over the past week. The aggregate SBE count is 150 and rising. What action should be taken?

**Solution Pattern**:
1. **Immediate**: Run `dcgmi diag -r 3 -i 3` for comprehensive diagnostic on GPU 3
2. **Short-term**: Cordon the node and drain workloads from GPU 3
3. **Analysis**: Check retired page count - if approaching limit (Xid 63), GPU replacement needed
4. **Decision**: Rising SBE trend strongly suggests degrading memory - schedule GPU replacement
5. **Documentation**: File RMA with error logs and DCGM diagnostic results

**Common Distractors**:
- Ignore SBEs because they are correctable - wrong, rising trend indicates degrading hardware
- Reboot the node - does not fix hardware memory issues
- Reduce workload on that GPU - only delays the inevitable failure
- Update GPU driver - SBEs are hardware issues, not driver bugs

**Key Takeaway**: Rising single-bit ECC errors are an early warning of hardware degradation. Proactively replace the GPU before it progresses to double-bit errors or page retirement limits.

---

## Scenario 3: Triton Configuration Optimization

**Scenario**: A Triton Inference Server deployment serving a text classification model shows low GPU utilization (15%) despite high request volume. The model processes one request at a time. How should Triton be configured to improve throughput?

**Solution Pattern**:
- **Enable dynamic batching** in config.pbtxt
- Set `preferred_batch_size` to [16, 32, 64]
- Set `max_queue_delay_microseconds` to 5000 (5ms) for latency-sensitive workloads
- Increase `instance_count` in instance_group if single instance is saturated
- Verify model supports batched input

**Common Distractors**:
- Add more GPUs - the current GPU is underutilized
- Use a larger model - does not address the batching problem
- Increase max_batch_size without dynamic batching - does not help if requests arrive individually
- Reduce model precision - helps latency per request but does not improve utilization

**Key Takeaway**: Low GPU utilization with high request volume almost always means dynamic batching is not configured. Triton's dynamic batching aggregates individual requests for efficient GPU execution.

---

## Scenario 4: Monitoring Alert Design

**Scenario**: Design an alerting strategy for a GPU cluster running production inference workloads. The cluster has 100 GPUs across 13 nodes. What alerts should be configured?

**Solution Pattern**:
- **Critical alerts (immediate page):**
  - Double-bit ECC error on any GPU (DCGM_FI_DEV_ECC_DBE_VOL_TOTAL > 0)
  - GPU fallen off bus (Xid 79 in system logs)
  - Inference endpoint error rate > 1%
  - All replicas of a model unhealthy
- **Warning alerts (business hours):**
  - GPU temperature > 83C for > 5 minutes
  - Rising SBE trend (> 10 errors in 24 hours)
  - GPU utilization < 10% for > 30 minutes (waste detection)
  - Inference latency P95 > SLA threshold
- **Info alerts (daily review):**
  - Driver version mismatch across nodes
  - GPU utilization consistently > 90% (capacity planning trigger)
  - Checkpoint storage approaching capacity

**Common Distractors**:
- Alert on every single-bit ECC error - too noisy, SBEs are normal at low rates
- Only alert on complete failures - misses early warning indicators
- Same severity for all GPU metrics - creates alert fatigue
- No utilization alerts - misses both waste and capacity issues

**Key Takeaway**: Tiered alerting (critical/warning/info) prevents alert fatigue while ensuring critical issues get immediate attention.

---

## Scenario 5: Driver Update Strategy

**Scenario**: A GPU fleet of 50 DGX nodes needs a driver update to patch a security vulnerability. The fleet runs both training and inference workloads. How should the update be executed?

**Solution Pattern**:
1. **Test**: Update driver on 2 non-production nodes, validate with benchmark suite
2. **Canary**: Update 3 production nodes (mix of training and inference)
3. **Monitor**: Run for 48 hours, check DCGM metrics, job success rates
4. **Rolling update**: Update remaining nodes in batches of 5
5. **Per node**: Cordon, drain workloads, update driver, run diagnostics, uncordon
6. **Rollback plan**: Keep previous driver packages available, document rollback steps

**Common Distractors**:
- Update all nodes simultaneously - causes complete cluster outage
- Skip testing, apply directly - security patch does not guarantee stability
- Wait for scheduled maintenance window only - security vulnerability needs prompt action
- Only update inference nodes - vulnerability affects all nodes equally

**Key Takeaway**: Security patches require prompt but controlled rollout - test, canary, rolling update with per-node drain and validation.

---

## Scenario 6: Disaster Recovery for Training

**Scenario**: A 4-node distributed training job for a 70B model has been running for 3 days when one node experiences a hardware failure. The job checkpoints every 2 hours. How should recovery be handled?

**Solution Pattern**:
1. **Assess**: Identify the last valid checkpoint (at most 2 hours of work lost)
2. **Resources**: Allocate a replacement node from the cluster pool
3. **Validate**: Run DCGM diagnostic on replacement node
4. **Resume**: Restart training from last checkpoint on new 4-node configuration
5. **Verify**: Confirm loss curve is consistent with pre-failure trajectory
6. **Improve**: Consider reducing checkpoint interval to 1 hour for large jobs

**Common Distractors**:
- Restart from the beginning - wastes 3 days of training
- Continue on 3 nodes without the 4th - changes parallelism, may not work or be very slow
- Wait for hardware repair - could take days, checkpoint allows immediate resume
- Reduce model size to fit on 3 nodes - changes the model, not a recovery

**Key Takeaway**: Regular checkpointing is essential for large training jobs. Recovery involves resuming from the last checkpoint on equivalent resources.

---

## Scenario 7: Inference Auto-Scaling

**Scenario**: An inference service experiences a 10x traffic spike every weekday at 9 AM as users start their workday. Current setup has 4 GPU replicas. During the spike, latency exceeds the 100ms P95 SLA. How should auto-scaling be configured?

**Solution Pattern**:
- **Reactive scaling**: HPA on inference queue depth or P95 latency
- **Predictive scaling**: Pre-scale to 20 replicas at 8:45 AM based on known pattern
- **Min/max**: Set minimum 4, maximum 40 replicas
- **Scale-down**: Gradual scale-down over 30 minutes after traffic normalizes
- **Warm-up**: Pre-load models on new replicas before accepting traffic

**Common Distractors**:
- Keep 40 replicas always running - wasteful during off-peak hours
- Scale on CPU utilization - GPU utilization is the correct metric for inference
- Instant scale-down after traffic drops - causes oscillation
- No minimum replicas - cold start during next spike would violate SLA

**Key Takeaway**: Combine predictive pre-scaling (for known patterns) with reactive scaling (for unexpected spikes). Account for GPU provisioning and model loading time.

---

## Scenario 8: Model Performance Degradation

**Scenario**: An inference model's accuracy has been declining over 2 weeks. The model serves product recommendations based on user behavior data. The model itself has not changed. What is the likely cause and solution?

**Solution Pattern**:
- **Likely cause**: Data drift - user behavior patterns have changed since model training
- **Diagnosis**: Compare current input data distribution to training data distribution
- **Short-term**: Monitor drift metrics and alert on significant shifts
- **Medium-term**: Retrain model with recent data
- **Long-term**: Implement continuous training pipeline that triggers on data drift detection
- **Monitoring**: Track prediction distribution, feature drift, and business metrics

**Common Distractors**:
- GPU hardware issue - would cause errors, not gradual accuracy decline
- Model version changed - stated the model has not changed
- Increase inference resources - more GPUs do not fix accuracy
- Roll back to previous model version - previous version would have same drift problem

**Key Takeaway**: Gradual accuracy decline without model changes indicates data drift. Implement drift monitoring and automated retraining pipelines.
