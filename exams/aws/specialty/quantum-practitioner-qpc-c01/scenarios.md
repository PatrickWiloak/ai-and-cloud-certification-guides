# AWS Quantum Practitioner - Practice Scenarios

Ten realistic scenarios. Work each one, write your reasoning before reading the answer.

## Scenario 1: Choosing a Simulator

A team wants to debug a 28-qubit circuit with deep entanglement. They do not need noise modeling.

Question: Which Braket simulator?

Answer: SV1. State vector handles up to ~34 qubits and provides exact results. TN1 would not fit deep entanglement. DM1 is for noise simulation and would not scale. LocalSimulator is too small for 28 qubits.

## Scenario 2: Algorithm for Drug Discovery

A pharma research team wants to estimate ground-state energies of small molecules.

Question: Which algorithm and why?

Answer: VQE (Variational Quantum Eigensolver). VQE is the canonical algorithm for ground-state energy estimation in quantum chemistry. It is variational, so it requires hybrid quantum-classical execution; use Braket Hybrid Jobs.

## Scenario 3: Optimization on a Graph

A logistics team wants to solve Max-Cut on a 12-node graph.

Question: Which algorithm?

Answer: QAOA (Quantum Approximate Optimization Algorithm). Designed for combinatorial optimization including Max-Cut. Run as a hybrid job; tune p (number of QAOA layers).

## Scenario 4: Trapped Ion vs Superconducting

A team needs high-fidelity 2-qubit gates and full all-to-all connectivity for a 25-qubit experiment.

Question: Which modality, and which Braket provider fits?

Answer: Trapped ion. Provides high gate fidelity and native all-to-all connectivity. IonQ Aria or Forte are the relevant Braket devices. Trade-off: slower gate times than superconducting.

## Scenario 5: Cost Estimation

A circuit runs at 1000 shots on IonQ Aria. The per-task fee is around $0.30 and per-shot $0.03.

Question: Estimate cost per run, and savings if shots reduce to 200 with acceptable statistical confidence.

Answer:
- 1000 shots: $0.30 + (1000 * $0.03) = $30.30
- 200 shots: $0.30 + (200 * $0.03) = $6.30
- Savings: ~$24 per run

For variational algorithms with thousands of iterations, shot count is the dominant cost lever.

## Scenario 6: Variational Pipeline Design

A team wants VQE on H2 with iterative parameter updates.

Question: Should they orchestrate from a notebook or use Hybrid Jobs?

Answer: Hybrid Jobs. The classical optimizer container runs co-located with the quantum task submissions; priority queueing reduces per-iteration latency vs ad-hoc notebook submission. For long-running variational work, Hybrid Jobs is the production pattern.

## Scenario 7: Search Problem Sizing

A team wants to use Grover's algorithm to search a 1024-element unstructured database.

Question: How many qubits, and is the speedup worth it at this scale?

Answer: Need 10 qubits to encode 1024 = 2^10 states. Grover gives quadratic speedup: ~sqrt(1024) = 32 iterations vs classical 1024. At small scale on noisy hardware, Grover is mostly pedagogical; near-term advantage is unproven for most use cases. Exam-relevant, production rarely.

## Scenario 8: Noise Modeling

A team wants to predict how their circuit will perform on a real device before running.

Question: Which simulator, and what data do they need?

Answer: DM1 (density matrix simulator) supports noise modeling. They need a noise model for the target device (gate error rates, T1, T2, readout error). They can also run zero-noise extrapolation as an error mitigation technique.

## Scenario 9: Reservation vs On-Demand

A team needs guaranteed access to IonQ Aria for a 4-hour hackathon next week.

Question: Pricing model?

Answer: Braket Direct reservations. Reserves the QPU for a flat hourly rate during the booked window. Eliminates queue wait. On-demand alone risks waiting behind other users.

## Scenario 10: Analog Hamiltonian on QuEra

A team wants to simulate quantum spin-glass dynamics on a 2D lattice.

Question: Which Braket device, and what programming model?

Answer: QuEra Aquila (neutral atom). Aquila supports analog Hamiltonian simulation, a different programming model from gate-based circuits. Use Braket's AHS (Analog Hamiltonian Simulation) APIs. Excellent fit for spin-system simulation on the Rydberg-blockade Hamiltonian.
