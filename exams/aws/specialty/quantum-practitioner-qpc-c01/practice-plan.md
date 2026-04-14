# AWS Quantum Practitioner - 6 Week Practice Plan

This plan assumes 10 hours per week. Quantum has a steeper conceptual ramp than other AWS specialties; budget more time if linear algebra is rusty.

## Week 1: Math and Quantum Foundations

Goals: rebuild the math, internalize qubits.

- Refresh complex numbers, vector inner product, matrix multiplication
- Read Nielsen & Chuang chapter 2 sections on state vectors and unitary evolution
- Learn Dirac notation: |0>, |1>, |+>, |->, ket/bra
- Understand superposition: |psi> = a|0> + b|1>, |a|^2 + |b|^2 = 1
- Understand measurement: probability = |amplitude|^2
- Visualize on the Bloch sphere
- Learn Pauli matrices, Hadamard, phase gates by hand on paper

Deliverable: by hand, compute the result of H|0>, X|0>, Z|+>.

## Week 2: Circuits and Gates

Goals: read and write quantum circuits.

- Single-qubit gates: I, X, Y, Z, H, S, T, Rx(theta), Ry(theta), Rz(theta)
- Two-qubit gates: CNOT, CZ, SWAP
- Three-qubit gates: Toffoli (CCNOT), Fredkin (CSWAP)
- Bell state preparation: H on qubit 0, then CNOT(0, 1)
- GHZ state preparation
- Quantum teleportation circuit (canonical exercise)
- Install the Braket SDK, run a Hello Bell on the local simulator

Deliverable: write a Bell-state circuit and a 3-qubit GHZ in Braket Python.

## Week 3: Amazon Braket Hands-On

Goals: get fluent with the Braket service.

- Open the Braket console; tour notebooks, devices, tasks, hybrid jobs
- Run a circuit on LocalSimulator
- Run the same circuit on SV1
- Run on a real QPU (IonQ Aria, Rigetti Ankaa, or IQM Garnet)
  - Be deliberate; even small jobs cost a few dollars
- Inspect results stored in S3
- Set IAM permissions for braket actions
- Set up cost budgets and tagging on Braket tasks

Deliverable: a working notebook that runs a Bell circuit on a simulator and a QPU and compares results.

## Week 4: Hybrid Workflows and PennyLane

Goals: build variational algorithms.

- Read Braket Hybrid Jobs documentation
- Run a managed PennyLane container hybrid job
- Implement VQE for H2 molecule (Braket Examples has a notebook)
- Implement QAOA for Max-Cut on a small graph
- Understand priority queueing and reservation
- Compare simulator vs QPU quality for the same VQE

Deliverable: a working VQE that finds the H2 ground state energy on simulator.

## Week 5: Algorithms and Applications

Goals: know the canonical algorithms.

- Grover's algorithm: implement and run; understand quadratic speedup
- Quantum Phase Estimation: implement on simulator
- QFT (Quantum Fourier Transform): implement and verify
- Read about Shor's algorithm (conceptual; do not implement at scale)
- Read about quantum machine learning (kernel methods, variational classifiers)
- Read about analog Hamiltonian simulation on QuEra Aquila

Deliverable: notebook implementing Grover for 4-qubit search.

## Week 6: Operations, Cost, Mocks

Goals: pass under realistic conditions.

- Master Braket pricing model: per-task, per-shot, device fees, simulator per-minute, hybrid job compute
- Practice cost estimation for circuits
- Review error mitigation: zero-noise extrapolation, readout error mitigation
- Review noise model differences: trapped ion vs superconducting vs neutral atom
- Two timed mock exams using exam-style questions
- Review weak areas

## Daily Cadence

- 30 minutes math / theory
- 60 minutes hands-on Braket
- 30 minutes algorithm reading or scenario practice

## Lab Costs

- Local simulator: free
- SV1, DM1, TN1: cheap, often pennies per minute
- IonQ Aria task: typically a few cents per shot, plus per-task fee
- Rigetti, IQM: similar order of magnitude
- Hybrid Jobs: classical compute fee per minute plus quantum task fees

Budget 50-150 USD for hands-on practice across the plan.

## Red Flags You Are Not Ready

- Cannot compute the matrix for H or CNOT from memory
- Cannot prepare a Bell state in Braket
- Do not know the difference between SV1, DM1, TN1
- Cannot explain when to use a QPU vs a simulator
- Cannot estimate the cost of a 1000-shot circuit on IonQ Aria
- Mock exam scores below 65 percent
