# 06. Cost and Operational Considerations

## The Braket Cost Model

Braket pricing has multiple components. Always check current AWS pricing for accurate numbers; the principles below remain stable.

### Per-task fee
A small fixed fee for submitting any task to a QPU. Typically a few cents to under a dollar per task. Does not apply to simulators.

### Per-shot fee
Charged for each shot executed on a QPU. Varies by device:

- IonQ Aria: higher per-shot, fewer shots typical
- Rigetti Ankaa: lower per-shot, fast execution
- IQM Garnet: comparable to Rigetti
- QuEra Aquila: per-shot pricing for AHS workloads

For a 1000-shot run, per-shot cost dominates per-task cost.

### Simulator pricing
Per-minute of execution time for managed simulators (SV1, DM1, TN1). LocalSimulator runs in your own process at no Braket cost (you still pay for the host compute).

### Hybrid Jobs pricing
- Classical compute: per-instance-hour for the orchestrator container
- Quantum tasks: per-task and per-shot as normal
- Optional priority queue access (helps reduce wait between iterations)

### Reservation (Braket Direct)
A flat hourly rate for guaranteed access to a QPU during a booked window. Use when:
- You need predictable wall-clock execution
- A shared queue would create unacceptable latency
- A workshop, demo, or critical experiment is time-sensitive

## Cost Estimation Patterns

### Single circuit on QPU
```
Cost = task_fee + (shots * shot_fee)
```

### VQE iteration
```
Iteration cost = sum over Pauli strings of (task_fee + shots * shot_fee)
Total cost = iterations * iteration_cost
```

### Hybrid job
```
Total = job_compute_cost + sum of all quantum task costs
```

## Cost Optimization Strategies

### 1. Develop on simulators
LocalSimulator for small-scale, iterating; SV1 for validation. Move to QPU only for final runs or to characterize hardware-specific behavior.

### 2. Right-size shots
Statistical confidence improves as 1 / sqrt(shots). Going from 100 to 10000 shots shrinks error 10x but costs 100x. For many use cases 200-1000 shots is enough.

### 3. Choose device by use case
- Fast iteration with reasonable fidelity: Rigetti / IQM superconducting
- High-fidelity, all-to-all needed: IonQ trapped ion
- Analog Hamiltonian simulation: QuEra
- Best price/performance for a given workload may shift; benchmark.

### 4. Use Hybrid Jobs for variational work
Reduces inter-iteration latency and may reduce total wall clock significantly.

### 5. Tag everything
Apply AWS tags to tasks, jobs, S3 results. Use Cost Explorer with tag dimensions.

### 6. Set budgets and alerts
AWS Budgets with thresholds at 50, 80, 100 percent. Quantum experiments can spiral.

### 7. Cancel runaway tasks
`braket cancel-quantum-task` and `cancel-job` can stop unintended cost accumulation.

## Service Quotas

Default Braket quotas include:

- Concurrent tasks per device
- Concurrent hybrid jobs
- Shots per task
- Tasks per minute (rate limit)

For large experiments, request quota increases in advance.

## IAM Patterns

Principle of least privilege:

- Researchers: braket:Create*, Get*, Search*, Cancel* on their tasks; S3 read/write on their output prefix
- Reviewers: braket:Get*, Search*; S3 read on output prefix
- Admins: full braket: plus iam: for role management

Use IAM roles with Braket-managed policies as a starting point; tighten by tag conditions.

## Result Storage Operations

Each task writes JSON to S3. Lifecycle considerations:

- Apply S3 lifecycle rules to age out old results
- Use S3 Intelligent-Tiering for results you may need again
- Compress and aggregate results from many small tasks if you keep them long-term

## Observability

- **CloudWatch metrics**: per-device queue depth, task counts, errors
- **CloudTrail**: API audit (who created which task)
- **Hybrid Job logs**: container stdout/stderr in CloudWatch Logs
- **Custom metrics**: emit your own (cost per iteration, energy estimate, gradient norm)

## Region Considerations

Braket is available in specific AWS regions; not every QPU is in every region. Some QPUs are accessible only via certain regions due to hardware location. Plan data residency accordingly.

## Error Mitigation

QPUs are noisy. Common mitigation strategies:

- **Readout error mitigation**: characterize and invert measurement error
- **Zero-noise extrapolation (ZNE)**: run circuit at amplified noise levels and extrapolate to zero noise
- **Probabilistic error cancellation**: more advanced, requires noise model
- **Dynamical decoupling**: insert pulse sequences to suppress decoherence

Each adds shot count or circuit depth, increasing cost; trade against fidelity needs.

## When Quantum Is Not the Right Choice

Operational reality:

- For most production workloads today, classical solutions are cheaper, faster, and more reliable
- Quantum is for R&D, benchmarking, and capability building
- Avoid making business commitments based on near-term quantum advantage

## Lifecycle of a Quantum Workload

1. **Concept**: classical baseline established; identify quantum hypothesis
2. **Prototype**: LocalSimulator / SV1
3. **Pilot**: small QPU runs to characterize hardware behavior
4. **Hybrid optimization**: variational algorithm tuned on simulator, validated on QPU
5. **Benchmark**: compare quantum and classical results, including cost
6. **Decision**: continue research, productize, or shelve

## Common Exam Traps

- Underestimating shot cost in variational loops
- Choosing a QPU when a simulator suffices
- Skipping reservation when wall-clock predictability matters
- Missing the role of IAM and S3 permissions in task submission
- Ignoring CloudWatch metrics for cost / health monitoring
- Believing error mitigation is free (it adds shots and depth)
- Recommending quantum for production workloads where classical is clearly superior
