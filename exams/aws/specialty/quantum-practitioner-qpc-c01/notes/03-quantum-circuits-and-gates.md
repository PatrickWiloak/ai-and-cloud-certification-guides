# 03. Quantum Circuits and Gates

## Circuits as Sequences of Gates

A quantum circuit is a sequence of gates applied to qubits, followed by measurement. Read circuits left to right (time order) with each horizontal line representing one qubit.

Equivalent representations:

- Diagram (qubit lines with gate boxes)
- Matrix product (right to left in matrix notation; left to right in time)
- Code (Braket Circuit object, Qiskit QuantumCircuit, etc.)

## Single-Qubit Gates

### Identity (I)
```
[[1, 0],
 [0, 1]]
```
Does nothing; useful as a placeholder.

### Pauli-X (NOT, bit-flip)
```
[[0, 1],
 [1, 0]]
```
- X|0> = |1>, X|1> = |0>
- Rotation by pi around X axis on Bloch sphere

### Pauli-Y
```
[[0, -i],
 [i,  0]]
```
- Rotation by pi around Y axis

### Pauli-Z (phase-flip)
```
[[1,  0],
 [0, -1]]
```
- Z|0> = |0>, Z|1> = -|1>
- Rotation by pi around Z axis

### Hadamard (H)
```
(1/sqrt(2)) * [[1,  1],
               [1, -1]]
```
- H|0> = |+>, H|1> = |->
- Creates superposition; the most-used quantum gate

### Phase (S = sqrt(Z))
```
[[1, 0],
 [0, i]]
```

### T (sqrt(S) = Z^(1/4))
```
[[1, 0],
 [0, e^(i*pi/4)]]
```

### Rotations
- Rx(theta): rotation by theta around X axis
- Ry(theta): rotation by theta around Y axis
- Rz(theta): rotation by theta around Z axis

Continuous-parameter gates; building blocks for variational circuits.

## Two-Qubit Gates

### CNOT (Controlled-NOT, CX)
```
[[1, 0, 0, 0],
 [0, 1, 0, 0],
 [0, 0, 0, 1],
 [0, 0, 1, 0]]
```
- Flips target if control is |1>
- Foundational gate for entanglement

### CZ (Controlled-Z)
```
[[1, 0, 0,  0],
 [0, 1, 0,  0],
 [0, 0, 1,  0],
 [0, 0, 0, -1]]
```

### SWAP
```
[[1, 0, 0, 0],
 [0, 0, 1, 0],
 [0, 1, 0, 0],
 [0, 0, 0, 1]]
```
- Swaps two qubits' states

## Three-Qubit Gates

### Toffoli (CCNOT)
- Three qubits: two controls, one target
- Flips target only if both controls are |1>
- Reversible classical AND

### Fredkin (CSWAP)
- Three qubits: one control, two targets
- Swaps the two targets only if control is |1>

## Universal Gate Sets

A universal set is one from which any unitary can be approximated. Common sets:

- {H, T, CNOT}: most common universal set
- {Rx, Ry, Rz, CNOT}: convenient for variational circuits
- Native gate sets vary per QPU; the SDK transpiles your circuit to the device's native set

## Native Gates per Provider

- IonQ: GPI, GPI2, MS (Mølmer-Sørensen) for entangling
- Rigetti: RX, RZ, CZ
- IQM: PRX, CZ

The SDK handles transpilation; you write in standard gates, the platform compiles to native.

## Building Common States

### Bell state (entanglement of 2 qubits)
```python
Circuit().h(0).cnot(0, 1)
```
Result: (|00> + |11>) / sqrt(2)

### GHZ state (n-qubit entanglement)
```python
Circuit().h(0).cnot(0, 1).cnot(0, 2)  # 3-qubit GHZ
```
Result: (|000> + |111>) / sqrt(2)

### Plus state on all qubits
```python
Circuit().h(0).h(1).h(2)
```
Result: (1/sqrt(8)) * sum over all 3-qubit basis states

## Circuit Depth and Width

- **Width**: number of qubits
- **Depth**: number of gate "layers" (gates that can be parallelized count once)
- Higher depth = more decoherence error
- Optimization goal on real hardware: minimize depth

## Transpilation

Your circuit is rewritten by the platform to:
1. Decompose to the device's native gate set
2. Map logical qubits to physical qubits (respecting connectivity)
3. Insert SWAPs where connectivity is limited
4. Minimize depth and gate count

The output may look very different from your input. Use platform tools to inspect the transpiled circuit.

## Measurement

- Measure in the computational (Z) basis by default
- Measurement collapses the qubit and produces a classical bit
- Multiple shots (re-running the circuit and re-measuring) build a probability distribution

## Reading Circuit Diagrams

Common conventions:

- Qubit lines horizontal, time flows left to right
- Single-qubit gates as boxes on a single line
- CNOT: filled circle on control, open circle (XOR symbol) on target, vertical line connecting
- Measurement: meter symbol or "M" box

## Common Exam Traps

- Forgetting that gate composition is matrix multiplication right-to-left in matrix form, but left-to-right in time order
- Confusing CNOT control vs target
- Believing all qubits can be entangled with any other (depends on hardware connectivity)
- Underestimating circuit depth's impact on real-device fidelity
- Missing that transpilation can balloon gate count significantly
- Miscounting measurement basis (default is Z; H before measurement reads X basis)
