# 01. Quantum Computing Fundamentals

## Why Quantum Is Different

Classical computers process bits with values 0 or 1. Quantum computers process qubits with values that can be in superposition: a probabilistic combination of 0 and 1. This expands the computational state space exponentially with qubit count, enabling certain algorithms (factoring, search, simulation of quantum systems) that scale better than the best known classical equivalents. The catch: qubits are fragile, error rates are high, and quantum advantage has been demonstrated only on narrow problems.

## The Qubit

A qubit's state is a unit vector in a 2-dimensional complex Hilbert space:

```
|psi> = a|0> + b|1>     where |a|^2 + |b|^2 = 1
```

- a and b are complex numbers (amplitudes)
- |a|^2 is the probability of measuring 0
- |b|^2 is the probability of measuring 1
- Once measured, the state collapses; probabilistic information is lost

## Dirac Notation

- |0> = column vector [1, 0]
- |1> = column vector [0, 1]
- |+> = (|0> + |1>) / sqrt(2)
- |-> = (|0> - |1>) / sqrt(2)
- <psi| = conjugate transpose of |psi> (a "bra")
- <psi|phi> = inner product (scalar)
- |psi><phi| = outer product (operator)

## The Bloch Sphere

A geometric representation of a single qubit. Any pure single-qubit state maps to a point on a unit sphere:

- |0> at the north pole
- |1> at the south pole
- |+>, |->, |i>, |-i> on the equator

Rotations on the Bloch sphere correspond to single-qubit gates.

## Multi-Qubit States

n qubits live in a 2^n-dimensional Hilbert space. The state vector for n qubits has 2^n complex amplitudes. Tensor product:

```
|0>|0> = |00> = [1, 0, 0, 0]
|0>|1> = |01> = [0, 1, 0, 0]
|1>|0> = |10> = [0, 0, 1, 0]
|1>|1> = |11> = [0, 0, 0, 1]
```

## Entanglement

A multi-qubit state is **entangled** if it cannot be written as a tensor product of single-qubit states. Bell state:

```
(|00> + |11>) / sqrt(2)
```

This is entangled: measuring one qubit determines the other instantly. Entanglement is the resource that powers quantum advantage.

## Superposition

A qubit in superposition holds both 0 and 1 simultaneously, weighted by amplitudes. Many qubits in superposition collectively represent all 2^n basis states with associated amplitudes. Quantum algorithms manipulate the amplitudes (constructive and destructive interference) so that desired outcomes have high probability when measured.

## Measurement

Measurement collapses a superposition into a basis state with probability given by the squared amplitude.

```
|psi> = a|0> + b|1>
P(0) = |a|^2
P(1) = |b|^2
```

After measurement, the state IS the measured basis state. You cannot un-measure.

## Unitary Evolution

Quantum gates are unitary matrices: square matrices U with U†U = I. Unitary operations:

- Are reversible (U† reverses U)
- Preserve normalization (probabilities sum to 1)
- Compose by matrix multiplication

## Decoherence and Noise

Real qubits interact with their environment, losing quantum information over time. Key concepts:

- **T1 (relaxation time)**: how long a qubit stays in |1> before decaying to |0>
- **T2 (dephasing time)**: how long a qubit maintains phase coherence
- **Gate error**: probability per gate of an incorrect operation
- **Readout error**: probability of misclassifying a measurement

Current QPUs have T1 in the tens to hundreds of microseconds (superconducting) or seconds (trapped ion). Practical algorithms need depth-limited circuits.

## No-Cloning Theorem

You cannot create an identical copy of an unknown quantum state. Many classical patterns (broadcast, replicate, eager copy) do not work in quantum. The proof is short: if a cloning unitary existed, applying it to a superposition would violate linearity.

Consequence: quantum error correction works by encoding information across many qubits, not by copying.

## Reversibility

Quantum gates are reversible (unitary). Classical AND, OR are not reversible. To embed classical logic in quantum circuits, use reversible gates: Toffoli (CCNOT), Fredkin (CSWAP).

## Common Single-Qubit States

- |0> = [1, 0]
- |1> = [0, 1]
- |+> = (|0> + |1>) / sqrt(2)
- |-> = (|0> - |1>) / sqrt(2)
- |i> = (|0> + i|1>) / sqrt(2)
- |-i> = (|0> - i|1>) / sqrt(2)

## Important Identities

- H|0> = |+>
- H|1> = |->
- X|0> = |1>, X|1> = |0>
- Z|+> = |->, Z|-> = |+>
- HXH = Z
- HZH = X
- CNOT|+0> = (|00> + |11>) / sqrt(2)  (Bell state)

## Measurement Bases

You can measure in any basis, not just the computational (Z) basis. Common alternatives:

- X basis (|+>, |->) by applying H before Z-basis measurement
- Y basis (|i>, |-i>) by applying S† H before Z-basis measurement

## Common Misconceptions

- Quantum computers are not "infinitely parallel" classical computers; you do not get all 2^n answers
- A qubit is not "0 and 1 at the same time" in a classical sense; it is in a complex superposition
- Quantum does not solve all hard problems; it has narrow algorithmic wins
- More qubits is not strictly better; deeper circuits accumulate more error

## Common Exam Traps

- Confusing measurement probability (|amplitude|^2) with amplitude
- Believing measurement is reversible (it is not)
- Missing the no-cloning constraint in protocol design
- Confusing entanglement with correlation (entanglement is stronger)
- Treating decoherence as negligible
