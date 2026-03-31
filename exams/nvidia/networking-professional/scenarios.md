# NCP-NET High-Yield Scenarios and Practice Problems

## Scenario 1: Topology Selection for AI Cluster

**Scenario**: A company is building a 128-node DGX H100 cluster for large language model training. Each node has 8x ConnectX-7 400Gb/s NICs. The workload is dominated by NCCL all-reduce operations. Which network topology should be used?

**Solution Pattern**:
- **Best Choice**: Rail-optimized topology with InfiniBand NDR
- 8 rail switches (one per NIC position across all nodes)
- Spine switches connecting rails for full fabric connectivity
- Optimized for all-reduce pattern used by NCCL
- Follows DGX SuperPOD reference architecture

**Common Distractors**:
- Full fat-tree - more switches than needed, rail-optimized is purpose-built for this pattern
- Dragonfly - better for 1000+ nodes, over-complicated for 128 nodes
- Simple leaf-spine with 2 switches - insufficient bandwidth for 128 DGX nodes
- Ethernet-only fabric - InfiniBand provides better latency for collective operations

**Key Takeaway**: Rail-optimized topology is the standard choice for DGX clusters because it matches the NCCL all-reduce communication pattern.

---

## Scenario 2: RoCE Configuration for Lossless Ethernet

**Scenario**: An AI cluster uses Spectrum-3 switches and ConnectX-7 adapters with RoCE v2. Users report intermittent RDMA failures and retransmissions. The network has jumbo frames configured but no explicit lossless configuration. What is missing?

**Solution Pattern**:
- **Root Cause**: PFC and ECN are not configured - RoCE v2 requires lossless Ethernet
- **Fix**:
  1. Enable PFC on priority 3 (or designated RoCE priority) on all switches
  2. Configure ECN marking thresholds on all switches
  3. Set DCQCN parameters on ConnectX adapters
  4. Configure DSCP marking for RoCE traffic classification
  5. Verify consistent QoS configuration across all switches in path

**Common Distractors**:
- Increase MTU further - jumbo frames are already configured
- Switch to RoCE v1 - would not fix the lossless issue and loses routability
- Add more switches - does not address packet loss
- Update adapter firmware only - requires fabric-wide PFC/ECN configuration

**Key Takeaway**: RoCE v2 requires lossless Ethernet (PFC + ECN) consistently configured across all switches in the data path.

---

## Scenario 3: InfiniBand Troubleshooting

**Scenario**: A training job spanning 4 DGX nodes shows significantly lower NCCL bandwidth than expected. ibstat shows all ports are Active at NDR speed. What should be investigated?

**Solution Pattern**:
1. Run `perfquery` on all ports to check error counters
2. Check symbol error counts - high values indicate physical layer issues
3. Run `ibdiagnet` for comprehensive fabric diagnostic
4. Verify all 8 NICs per node are active (not just one)
5. Check NCCL environment variables - ensure all NICs are being used
6. Verify routing tables are balanced across all paths
7. Check for link width issues (4x vs 2x vs 1x)

**Common Distractors**:
- Ports are Active so everything is fine - Active status does not mean error-free
- Restart the subnet manager - routing looks fine if ports are Active
- Replace all cables - overly aggressive without diagnostics
- Reduce number of nodes - masks the problem rather than solving it

**Key Takeaway**: Active port status does not guarantee performance. Check error counters, link width, and verify all NICs are participating.

---

## Scenario 4: UFM Monitoring Alert

**Scenario**: UFM reports a rising trend of symbol errors on a spine switch port over the past 48 hours. The port connects to a leaf switch. Training jobs through this path show occasional slowdowns. What action should be taken?

**Solution Pattern**:
1. Check symbol error counters on both ends of the link via UFM telemetry
2. Run cable diagnostics through UFM
3. If errors are on one side only - likely cable or connector issue
4. If errors on both sides - may be port hardware issue
5. Schedule cable replacement during maintenance window
6. Temporarily re-route traffic using adaptive routing if available
7. After cable replacement, clear counters and monitor for 24 hours

**Common Distractors**:
- Ignore because training still completes - rising errors predict failure
- Replace the entire switch - too aggressive, likely just a cable
- Disable the port immediately - causes traffic disruption without alternative path
- Wait for the link to fail completely - proactive replacement prevents outages

**Key Takeaway**: Rising error trends are early warnings. Use UFM telemetry for proactive cable replacement before complete failure.

---

## Scenario 5: Multi-Tenant Network Isolation

**Scenario**: A shared InfiniBand cluster needs to isolate traffic between three teams: ML Training, Inference, and Research. Each team should only see their own nodes. How should isolation be configured?

**Solution Pattern**:
- **Use InfiniBand partitions (P_Keys)**:
  - P_Key 0x0001 for ML Training team
  - P_Key 0x0002 for Inference team
  - P_Key 0x0003 for Research team
  - Default partition (0x7FFF) for management traffic only
- Configure partitions via UFM partition manager
- Assign node ports to appropriate partitions
- Full member for compute traffic, limited member for management

**Common Distractors**:
- Physical network separation - expensive, wastes shared infrastructure
- VLANs on InfiniBand - VLANs are Ethernet concept, not IB
- ACLs on switches - IB uses partitions, not ACLs for isolation
- Separate subnet managers - unnecessary complexity, partitions provide isolation

**Key Takeaway**: InfiniBand partitions (P_Keys) provide network isolation similar to VLANs in Ethernet. Managed via UFM partition manager.

---

## Scenario 6: GPUDirect RDMA Not Working

**Scenario**: A multi-node training job shows all GPU-to-GPU communication going through host memory instead of GPUDirect RDMA. NCCL logs show "NET/IB: Using [pid] memory type host". What is the issue?

**Solution Pattern**:
- **Check nvidia-peermem module**: `lsmod | grep nvidia_peermem`
- If not loaded: `modprobe nvidia-peermem`
- Verify GPU and NIC are on the same PCIe root complex
- Check NCCL environment: `NCCL_NET_GDR_LEVEL` should allow GPUDirect
- Verify GPU driver supports GPUDirect (datacenter driver required)
- Check NIC firmware supports GPUDirect RDMA

**Common Distractors**:
- Increase network bandwidth - bandwidth is not the issue, data path is
- Update NCCL version only - likely a system configuration issue
- Disable GPUDirect and accept the performance hit - fixable problem
- Add more host memory - does not fix the data path issue

**Key Takeaway**: GPUDirect RDMA requires: nvidia-peermem kernel module, compatible GPU and NIC on same PCIe root, and correct NCCL configuration.

---

## Scenario 7: Network Sizing

**Scenario**: A team plans to train a 70B parameter model across 32 DGX H100 nodes. The model uses data parallelism with 256 GPUs. Estimate the network bandwidth needed per node for all-reduce.

**Solution Pattern**:
- Gradient size: 70B params x 2 bytes (FP16) = 140GB
- All-reduce volume per node: 2 x 140GB x (256-1)/256 = ~280GB
- Time budget: ~1 second per all-reduce (typical)
- Bandwidth needed: ~280 GB/s per node
- DGX H100 has 8x 400Gb/s (50 GB/s each) = 400 GB/s total
- 280 GB/s needed / 400 GB/s available = 70% utilization - feasible

**Common Distractors**:
- Only 1 NIC needed per node - insufficient bandwidth
- 100GbE is sufficient - ~12.5 GB/s per port, far too slow
- No inter-node communication needed - data parallel requires gradient sync
- Gradient compression eliminates bandwidth needs - reduces but does not eliminate

**Key Takeaway**: Network sizing starts with gradient size and number of GPUs. DGX H100's 8x NDR InfiniBand provides sufficient bandwidth for most training workloads.

---

## Scenario 8: Adaptive Routing Decision

**Scenario**: A large InfiniBand cluster with fat-tree topology experiences congestion on specific spine links during peak training hours. UFM telemetry shows uneven traffic distribution across spine switches. What should be done?

**Solution Pattern**:
- **Enable adaptive routing** on Quantum switches
- Configure per-flow adaptive routing (maintains packet ordering for NCCL)
- Set congestion threshold for path switching
- Monitor traffic distribution improvement via UFM telemetry
- Verify NCCL performance improvement after enabling

**Common Distractors**:
- Add more spine switches - expensive, adaptive routing may solve it
- Per-packet adaptive routing - risks out-of-order delivery, breaks NCCL
- Static route recalculation - cannot adapt to dynamic traffic patterns
- Reduce cluster utilization - hides the problem, wastes resources

**Key Takeaway**: Adaptive routing resolves congestion hot spots dynamically. Use per-flow mode for AI workloads that require ordered delivery.
