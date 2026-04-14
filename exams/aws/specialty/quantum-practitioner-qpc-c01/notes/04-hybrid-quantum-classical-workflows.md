# 04. Hybrid Quantum-Classical Workflows

## Why Hybrid

Near-term quantum hardware is noisy and shallow-circuit-limited. Most practical algorithms today are **variational**: a parameterized quantum circuit produces a value, a classical optimizer adjusts the parameters, and the loop iterates until convergence. The classical and quantum components are tightly coupled.

Hybrid algorithms include:

- VQE (Variational Quantum Eigensolver) for ground-state energy
- QAOA (Quantum Approximate Optimization Algorithm) for combinatorial optimization
- Quantum kernel methods and variational quantum classifiers for ML
- Quantum Generative Adversarial Networks (QGANs)

## Anatomy of a Variational Algorithm

1. **Ansatz**: a parameterized quantum circuit (parameters = theta)
2. **Cost function**: typically expectation value of a Hamiltonian, computed by sampling the circuit
3. **Classical optimizer**: SciPy minimize, gradient descent, COBYLA, SPSA, Adam
4. **Iteration**: optimizer proposes new theta; quantum circuit returns new cost; repeat until converged

Per iteration: hundreds to thousands of shots on the QPU/simulator.

## Why Hybrid Jobs in Braket

Submitting tasks one at a time from a notebook to a QPU has high latency: each task queues, dispatches, and returns. For a thousand-iteration optimization, latency dominates.

**Braket Hybrid Jobs** addresses this by:

- Running the classical orchestrator in a managed container
- Giving the job priority queue access to the QPU (reduced wait between iterations)
- Co-locating compute and quantum task submission
- Tracking progress, logs, and metrics centrally

## Hybrid Jobs Flow

```python
from braket.jobs import hybrid_job, save_job_result
from braket.circuits import Circuit
from braket.aws import AwsDevice

@hybrid_job(device="arn:aws:braket:::device/quantum-simulator/amazon/sv1")
def vqe_h2():
    device = AwsDevice("arn:aws:braket:::device/quantum-simulator/amazon/sv1")
    # iterate: build circuit with theta, run, compute cost, optimizer step
    ...
    save_job_result({"final_energy": energy, "params": params})

job = vqe_h2()
print(job.arn)
```

## Container Options

### Managed PennyLane container
Preloaded with PennyLane, Braket plugin, and standard scientific Python. Best for getting started.

### Bring Your Own Container (BYOC)
Provide a Docker image with your dependencies. Useful when you need:
- Specific versions of NumPy/SciPy/PyTorch
- Custom optimizer implementations
- Domain-specific libraries (chemistry, finance)

## PennyLane Integration

PennyLane is a popular open-source library for variational quantum computing. The PennyLane-Braket plugin lets you write circuits in PennyLane's API and execute on any Braket device.

```python
import pennylane as qml
from pennylane import numpy as np

dev = qml.device("braket.aws.qubit",
                 device_arn="arn:aws:braket:::device/quantum-simulator/amazon/sv1",
                 wires=4, shots=1000)

@qml.qnode(dev)
def circuit(params):
    qml.RX(params[0], wires=0)
    qml.RY(params[1], wires=1)
    qml.CNOT(wires=[0, 1])
    return qml.expval(qml.PauliZ(0) @ qml.PauliZ(1))
```

## Cost Function Sampling

A cost function is typically `<psi|H|psi>` for some Hamiltonian H. Estimating this requires:

1. Decomposing H into Pauli strings
2. For each Pauli string, building a circuit that measures in that basis
3. Running each circuit for N shots
4. Averaging measurement results to estimate the expectation
5. Combining the expectations weighted by the Hamiltonian coefficients

For a molecule like H2, H decomposes into a few dozen Pauli strings. Each iteration thus runs many circuits.

## Optimizer Choice

- **Gradient-free** (COBYLA, Nelder-Mead, SPSA): no derivative needed; tolerant of noise; SPSA particularly noise-robust
- **Gradient-based** (Adam, gradient descent): need parameter-shift rule to compute gradients on quantum hardware; more iterations possible if gradients are reliable

For NISQ-era hardware, gradient-free or noise-aware optimizers (SPSA) often win.

## Parameter Shift Rule

Standard finite-difference does not work well on noisy quantum estimators. Parameter shift gives an exact gradient for many gate types:

```
df/dθ = 0.5 * (f(θ + π/2) - f(θ − π/2))
```

Two extra circuit evaluations per parameter, but exact in expectation.

## Convergence and Stopping

- Cost function tolerance
- Maximum iterations
- Wall clock budget
- Cost budget (shots * per-shot fee)

For long-running variational work, set a wall-clock and cost cap.

## Hybrid for ML

Quantum machine learning patterns:

- **Variational quantum classifier (VQC)**: quantum circuit produces a label probability; trained variationally
- **Quantum kernel methods**: quantum circuit computes a kernel matrix used in a classical SVM
- **Hybrid neural networks**: a small quantum layer inside a classical neural network

For most current ML problems, classical methods still outperform; quantum ML is research-stage.

## Result Aggregation

Each iteration produces:

- A cost estimate (with shot noise)
- An optimizer state
- Possibly intermediate parameters

Hybrid Jobs writes these to S3 and emits CloudWatch metrics. Final results saved via `save_job_result()`.

## Common Exam Traps

- Choosing on-demand notebook submission for a thousand-iteration variational algorithm (use Hybrid Jobs)
- Forgetting that each iteration runs many shots, multiplying cost
- Believing gradient-based optimizers always win on noisy hardware (SPSA often wins)
- Confusing Hybrid Jobs with single tasks (different APIs, different billing)
- Missing the priority queue advantage of Hybrid Jobs
- Choosing the wrong device for the variational algorithm (start on simulator)
