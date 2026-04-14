# 05. Quantum Algorithms: VQE, QAOA, Grover, and Building Blocks

## Algorithm Categories

Quantum algorithms divide roughly into:

- **Variational** (NISQ-friendly): VQE, QAOA, variational quantum classifiers
- **Quantum simulation**: simulating quantum systems (chemistry, materials)
- **Search and optimization**: Grover, amplitude amplification
- **Number theoretic**: Shor's factoring, discrete logarithm
- **Building blocks**: QFT, QPE, amplitude estimation

The Practitioner exam focuses on intuition and use case fit, not implementation depth for fault-tolerant algorithms.

## Variational Quantum Eigensolver (VQE)

**Goal**: find the ground-state energy of a Hamiltonian.

**Where used**: quantum chemistry (molecular energies), materials science.

**Pattern**:
1. Encode the molecule as a Hamiltonian H (a sum of Pauli strings)
2. Define an ansatz (parameterized quantum circuit) U(theta)
3. Cost = <0|U†(theta) H U(theta)|0> = expected energy
4. Classical optimizer minimizes cost over theta
5. Final cost approximates the ground-state energy

**Typical use case**: H2, H2O, LiH small-molecule energies.

**Cost considerations**: many Pauli strings * many shots * many iterations = expensive on QPU. Most VQE work runs on simulators today.

## Quantum Approximate Optimization Algorithm (QAOA)

**Goal**: approximate solutions to combinatorial optimization (Max-Cut, TSP, scheduling).

**Pattern**:
1. Encode the problem as a cost Hamiltonian Hc
2. Choose a mixer Hamiltonian Hm (often sum of Pauli-X)
3. Ansatz: alternating exp(-i*beta_p*Hm) and exp(-i*gamma_p*Hc) for p layers
4. Variational optimization over (beta, gamma)
5. Sample the final state to read off candidate solutions

**Use case**: combinatorial optimization where exact classical solvers struggle at scale.

**Caveat**: classical heuristics (simulated annealing, modern SAT solvers) often match or beat current QAOA on practical instances.

## Grover's Algorithm

**Goal**: search an unstructured space of N elements in O(sqrt(N)) operations vs O(N) classical.

**Setup**: an "oracle" recognizes the target item.

**Pattern**:
1. Initialize all qubits to uniform superposition (apply H to each)
2. Repeat ~sqrt(N) times:
   a. Apply the oracle (flips phase of target)
   b. Apply diffusion operator (inverts about the mean)
3. Measure; with high probability you get the target index

**Use case**: search problems where you can build an efficient oracle. In practice limited by oracle construction cost.

**Speedup**: quadratic. Real-world advantage requires very large N and fault-tolerant hardware.

## Shor's Algorithm

**Goal**: factor large integers in polynomial time. Implications for cryptography (RSA).

**Components**: modular exponentiation circuit, Quantum Fourier Transform, classical post-processing.

**Status**: famous theoretically; cannot factor RSA-relevant numbers with current hardware. Demonstrated on tiny numbers (15, 21).

**Exam relevance**: know it conceptually and its implication for RSA.

## Quantum Phase Estimation (QPE)

**Goal**: estimate the phase phi where U|psi> = e^(2*pi*i*phi)|psi>.

**Building block** for many algorithms (including Shor's). Requires:
- Controlled applications of U^(2^k)
- Inverse QFT
- Many ancilla qubits for precision

NISQ-era versions exist but the canonical QPE is fault-tolerant in scope.

## Quantum Fourier Transform (QFT)

The quantum analog of the discrete Fourier transform. Uses O(n^2) gates for n qubits vs O(n*2^n) for classical FFT on a 2^n-element vector.

**Used by**: QPE, Shor's, period-finding algorithms.

## Amplitude Amplification and Estimation

Generalization of Grover. Useful for Monte Carlo speedup (quadratic). Active research area for finance applications (option pricing).

## Quantum Simulation

Simulating quantum systems is one of the most physically motivated applications. Approaches:

- **Trotterization**: approximate exp(-iHt) by short steps
- **Variational simulation**: use VQE-like methods to evolve states
- **Analog Hamiltonian Simulation (AHS)**: directly engineer the Hamiltonian on hardware (QuEra Aquila does this)

## Quantum Machine Learning (QML)

A research-stage application. Patterns:

- **Variational quantum classifiers**: quantum circuit produces label probabilities
- **Quantum kernels**: quantum circuit computes inner products in a high-dimensional Hilbert space
- **Hybrid networks**: quantum layer inside a classical neural network
- **Quantum data encoding**: amplitude encoding, angle encoding, basis encoding

Currently QML rarely outperforms classical ML on practical datasets. Watch for advances.

## Annealing (Adjacent)

Quantum annealing (D-Wave) is a different paradigm targeting optimization. Not currently on Braket but conceptually related to QAOA (both attack combinatorial optimization).

## Algorithm Selection Cheat Sheet

| Problem | Algorithm |
|---------|-----------|
| Ground state of a molecule | VQE |
| Combinatorial optimization (Max-Cut, scheduling) | QAOA |
| Unstructured search | Grover (with caveats) |
| Factoring | Shor (theoretical at scale) |
| Quantum system dynamics | Quantum simulation (Trotter, AHS) |
| Period finding | QPE |
| Small classifier with structure | Variational quantum classifier |
| Spin-glass simulation | Analog Hamiltonian Simulation on Aquila |

## Practical Realities

- Quantum advantage demonstrations exist for narrow benchmark problems
- Most practical workloads still favor classical methods
- Variational algorithms are the workhorses of NISQ-era research
- Fault-tolerant algorithms (Shor, full QPE) await hardware progress

## Common Exam Traps

- Picking Grover for a problem with no efficient oracle (Grover does not magically search a database without index structure)
- Picking VQE for combinatorial optimization (use QAOA)
- Picking QAOA for chemistry (use VQE)
- Believing Shor's is practical today
- Confusing AHS (analog) with gate-based algorithms (digital)
- Assuming quantum ML is production-ready
