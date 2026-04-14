# 02. Amazon Braket Service

## What Braket Is

Amazon Braket is AWS's managed quantum computing service. It provides:

- A unified API and SDK to run circuits on multiple QPU hardware providers and on managed simulators
- Notebook environments preloaded with quantum SDKs
- Hybrid Jobs for variational algorithms requiring orchestrated classical and quantum execution
- Result storage in S3, audit via CloudTrail, metrics via CloudWatch
- IAM integration for permissions
- Reservation model (Braket Direct) for guaranteed QPU time

## Service Components

### Devices
Both QPUs (real hardware) and simulators are exposed as Devices. Each device has an ARN, a status (available, retired, offline), supported gate set, qubit count, and pricing.

### Tasks
A "task" is a single circuit execution: one circuit, N shots, one device. Created via `device.run(circuit, shots=N)`. Each task gets a task ARN; results are stored in S3.

### Hybrid Jobs
Container-based execution that orchestrates quantum tasks plus classical compute. Best for variational algorithms (VQE, QAOA) that iterate quantum tasks under classical optimizer control. Hybrid jobs get priority queueing to reduce per-iteration latency.

### Notebooks
SageMaker-hosted notebook instances preloaded with the Braket SDK and example notebooks.

## Hardware Providers (verify current availability)

| Provider | Modality | Strengths | Trade-offs |
|----------|----------|-----------|------------|
| IonQ (Aria, Forte) | Trapped ion | High fidelity, all-to-all connectivity | Slower gates |
| Rigetti (Ankaa) | Superconducting | Fast gates | Limited connectivity, more noise |
| IQM (Garnet) | Superconducting | European hardware option | Modest qubit count |
| QuEra (Aquila) | Neutral atom | Analog Hamiltonian Simulation, large arrays | Different programming model |

Hardware roster changes; check current Braket console for live availability.

## Simulators

| Simulator | Type | Capacity | Use case |
|-----------|------|---------|----------|
| LocalSimulator | In-process | Small (~25 qubits) | Free, fast iteration during development |
| SV1 | State vector | Up to ~34 qubits | Exact simulation, general purpose |
| DM1 | Density matrix | Up to ~17 qubits | Simulate noise channels |
| TN1 | Tensor network | Larger circuits | Limited entanglement, structured circuits |

## SDK Basics

```python
from braket.circuits import Circuit
from braket.aws import AwsDevice
from braket.devices import LocalSimulator

# Build a Bell state
circuit = Circuit().h(0).cnot(0, 1)

# Run locally
device = LocalSimulator()
result = device.run(circuit, shots=1000).result()
print(result.measurement_counts)

# Run on SV1
sv1 = AwsDevice("arn:aws:braket:::device/quantum-simulator/amazon/sv1")
task = sv1.run(circuit, shots=1000, s3_destination_folder=("my-bucket", "results"))
print(task.result().measurement_counts)

# Run on a QPU
ionq = AwsDevice("arn:aws:braket:us-east-1::device/qpu/ionq/Aria-1")
task = ionq.run(circuit, shots=100, s3_destination_folder=("my-bucket", "results"))
```

## Hybrid Jobs

```python
from braket.jobs import hybrid_job

@hybrid_job(device="arn:aws:braket:::device/quantum-simulator/amazon/sv1")
def my_vqe(initial_params):
    # Iterative classical optimizer with quantum task calls
    ...
    return optimized_params

job = my_vqe(initial_params=[0.1, 0.2, 0.3])
```

Hybrid jobs run in containers; you can use the managed PennyLane container or bring your own container with custom dependencies.

## IAM

Common Braket actions:

- braket:CreateQuantumTask
- braket:GetQuantumTask
- braket:CancelQuantumTask
- braket:SearchQuantumTasks
- braket:CreateJob
- braket:GetJob
- braket:CancelJob
- braket:SearchJobs
- braket:GetDevice
- braket:SearchDevices

You also need s3:PutObject / s3:GetObject for the results bucket.

## Pricing Model

- **Per-task fee**: a small fee per task submission, varies by device
- **Per-shot fee**: charged per shot, varies by device (often the dominant cost)
- **Simulator pricing**: per-minute of execution time
- **Hybrid Jobs**: classical compute pricing (instance-hours) plus quantum task fees
- **Reservation (Braket Direct)**: flat hourly rate for guaranteed QPU time

Always check the device's pricing in the console; rates change.

## Cost Optimization

- Develop on LocalSimulator first (free)
- Validate on SV1 before paying for QPU time
- Choose shots deliberately; statistical confidence improves as sqrt(shots)
- Use Hybrid Jobs (not ad-hoc notebooks) for variational work to reduce iteration latency
- Reserve only for time-sensitive workloads where queueing risk is real
- Set Cost Explorer budgets and tag tasks for visibility

## Result Storage

Each quantum task writes JSON results to a configured S3 bucket. Hybrid Jobs write logs and artifacts to S3 plus model output. Standard S3 lifecycle policies apply.

## Observability

- **CloudWatch metrics**: per-device queue depth, task counts, error counts
- **CloudTrail**: API call audit
- **Hybrid Job logs**: container stdout/stderr to CloudWatch Logs
- **Braket console**: visual monitoring of devices, queue depths, task history

## Pulse-Level Control (Braket Pulse)

For research workflows that need below-gate control, Braket Pulse lets you specify the actual control waveforms (shapes, amplitudes, durations). Provider-specific; not all devices support this. Out of scope for most practitioners; useful for algorithm research and noise characterization.

## Common Mistakes

- Running large circuits directly on QPU without simulator validation
- Forgetting S3 destination configuration on tasks
- Misjudging shot count and overspending
- Not setting cost budgets
- Mixing region: QPU device ARN region must match the SDK call region
- Submitting too many tasks rapidly and hitting service quotas

## Common Exam Traps

- Confusing tasks (single circuit) with hybrid jobs (orchestrated workflow)
- Choosing the wrong simulator (DM1 for noise, SV1 for general, TN1 for structured large)
- Believing reservation is always required (it is not; on-demand is the default)
- Missing the role of S3 in result storage
- Picking IonQ when fast gate time is the priority (superconducting wins on speed)
