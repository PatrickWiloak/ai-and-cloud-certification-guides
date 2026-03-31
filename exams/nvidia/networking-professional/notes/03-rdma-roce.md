# RDMA and RoCE

**[📖 NVIDIA RDMA Documentation](https://docs.nvidia.com/networking/)** - RDMA networking guides

## RDMA Fundamentals

### What is RDMA?

Remote Direct Memory Access enables direct memory-to-memory data transfer between computers without involving the CPU, operating system kernel, or cache.

**Key Benefits:**
- **Zero-copy** - Data moves directly between application buffers
- **Kernel bypass** - No system call overhead
- **Low latency** - Single-digit microsecond RTT
- **High throughput** - Near wire-speed data transfer
- **Low CPU overhead** - CPU is free for computation

### RDMA Operations

**Two-Sided Operations:**
- **Send** - Sender pushes data to receiver's pre-posted buffer
- **Receive** - Receiver posts buffers for incoming sends
- Both sides must participate (post work requests)

**One-Sided Operations:**
- **RDMA Write** - Write data to remote memory without remote CPU involvement
- **RDMA Read** - Read data from remote memory without remote CPU involvement
- Only initiator posts work request; remote side is passive
- Remote memory must be registered and accessible

**Atomic Operations:**
- **Compare-and-Swap** - Atomic read-modify-write on remote memory
- **Fetch-and-Add** - Atomic increment on remote memory
- Useful for distributed synchronization

### RDMA Programming Model

**Key Abstractions:**
- **Protection Domain (PD)** - Security boundary for resources
- **Queue Pair (QP)** - Send and receive queue pair for communication
- **Completion Queue (CQ)** - Reports completion of work requests
- **Memory Region (MR)** - Registered memory for RDMA access
- **Work Request (WR)** - Operation to perform (send, RDMA write, etc.)
- **Work Completion (WC)** - Result of completed operation

**Connection Flow:**
1. Create protection domain
2. Allocate and register memory regions
3. Create queue pairs and completion queues
4. Exchange connection information (address, QP number, memory keys)
5. Establish connection (RC) or connectionless (UD)
6. Post work requests for data transfer
7. Poll completion queue for results

## RDMA Transport Types

### InfiniBand Native
- RDMA built into InfiniBand protocol
- Lossless by design (credit-based flow control)
- Highest performance RDMA implementation
- Requires InfiniBand fabric and adapters

### RoCE v1
- RDMA over Ethernet Layer 2
- Ethertype 0x8915 for RDMA packets
- Limited to single broadcast domain (same VLAN/subnet)
- Not routable across Layer 3 boundaries
- Requires lossless Ethernet (PFC)

### RoCE v2
- RDMA over UDP/IP (port 4791)
- Routable across subnets and Layer 3 boundaries
- Standard choice for modern Ethernet AI clusters
- Requires lossless Ethernet for reliability
- GRH (Global Route Header) encapsulation in UDP/IP

### iWARP
- RDMA over TCP/IP
- Works on any Ethernet network (no lossless requirement)
- Higher latency than RoCE (TCP overhead)
- Less common in AI/HPC deployments

## Lossless Ethernet Configuration

### Priority Flow Control (PFC)

**Purpose:** Prevents packet loss for specific traffic classes

**How it Works:**
1. Receiver buffer reaches threshold
2. Receiver sends PFC PAUSE frame for specific priority
3. Sender pauses transmission for that priority
4. Other priorities continue unaffected
5. Receiver sends PFC RESUME when buffer drains

**Configuration:**
```bash
# Enable PFC on priority 3 (example for Cumulus)
nv set interface swp1 qos pfc-watchdog enabled
nv set interface swp1 qos roce mode lossless
```

**Risks:**
- PFC deadlock - circular dependency of paused links
- PFC storm - cascading pause across fabric
- Head-of-line blocking within a priority
- Mitigation: PFC watchdog, careful topology design

### Explicit Congestion Notification (ECN)

**Purpose:** End-to-end congestion signaling

**How it Works:**
1. Switch queue exceeds marking threshold
2. Switch sets ECN bits in IP header (CE - Congestion Experienced)
3. Receiver echoes congestion to sender via CNP (Congestion Notification Packet)
4. Sender reduces transmission rate
5. Rate gradually recovers as congestion clears

**Configuration:**
```bash
# Set ECN marking threshold
nv set interface swp1 qos ecn threshold min 150000 max 1500000
```

### DCQCN (Data Center QoS for Converged Networks)

- Combines PFC (for zero loss) with ECN (for congestion control)
- Rate-based congestion control algorithm
- Implemented in ConnectX adapter firmware
- Standard approach for RoCE in AI data centers
- Parameters: alpha (aggressiveness), rate increase timer, byte counter

### Traffic Classification

- DSCP marking for RoCE traffic identification
- Trust DSCP at switch ports
- Map DSCP to internal priority queues
- Consistent configuration across all switches in path
- Typical: RoCE on priority 3, other traffic on priority 0

## GPUDirect RDMA

### Overview
- Direct data path between GPU memory and network adapter
- Bypasses CPU and system memory entirely
- Registered GPU memory accessible via RDMA keys
- Critical for efficient multi-node GPU training

### Requirements
- Compatible GPU (NVIDIA Tesla/datacenter GPUs)
- Compatible NIC (ConnectX-5 or newer)
- GPU and NIC on same PCIe root complex (or NVSwitch path)
- nvidia-peermem kernel module loaded
- Supported by NCCL for distributed training

### GPUDirect Storage
- Direct path between storage devices and GPU memory
- Bypasses CPU bounce buffer
- Accelerates data loading for training
- Requires compatible storage controller (NVMe)
- cuFile API for application integration

**[📖 GPUDirect Documentation](https://developer.nvidia.com/gpudirect)** - GPU direct access

## Performance Tuning

### Adapter Tuning
- Set optimal MTU (4096 for IB, 9000 for Ethernet)
- Configure receive queue depth
- Enable hardware offloads (checksum, LSO)
- Set interrupt coalescing parameters
- Pin interrupts to appropriate CPU cores

### Fabric Tuning
- Enable adaptive routing where supported
- Configure proper QoS policies
- Ensure consistent PFC/ECN configuration
- Monitor and resolve hot spots
- Verify full bandwidth utilization

### Benchmarking
- `ib_write_bw` / `ib_read_bw` - RDMA bandwidth tests
- `ib_write_lat` / `ib_read_lat` - RDMA latency tests
- `perftest` suite for comprehensive RDMA benchmarks
- `nccl-tests` for GPU collective communication benchmarks

## Key Exam Concepts

- RDMA operations: send/receive, RDMA write/read, atomics
- RoCE v1 (L2 only) vs RoCE v2 (routable over UDP/IP)
- PFC for lossless Ethernet - how it works and risks
- ECN for congestion notification - marking and response
- DCQCN combining PFC and ECN for RoCE
- GPUDirect RDMA requirements and benefits
- Performance tuning and benchmarking tools
