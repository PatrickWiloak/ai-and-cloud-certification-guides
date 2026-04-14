# AWS Quantum Practitioner - Fact Sheet (Anticipated)

## Important Notice

This certification is anticipated based on AWS direction with Amazon Braket. As of this writing, AWS has not formally announced an exam with the QPC-C01 code, format, or pricing. The fields below represent realistic estimates derived from adjacent AWS specialty exams (AIF, MLA, MLS, DAS, ANS) and public Braket capabilities. Verify all details against AWS Training and Certification when the exam is officially released.

## Anticipated Exam Identity

| Attribute | Anticipated value |
|-----------|-------------------|
| Certification body | AWS Training and Certification |
| Anticipated exam code | QPC-C01 |
| Level | Specialty |
| Delivery | Pearson VUE testing center or online proctored via Pearson OnVUE |
| Anticipated duration | 170 minutes |
| Anticipated questions | 65 multiple choice and multi-response |
| Anticipated passing score | 750 / 1000 (scaled) |
| Anticipated cost | 300 USD |
| Validity | 3 years (standard AWS) |
| Languages | English at launch; localized later |

## Anticipated Domain Blueprint

| Domain | Anticipated weight |
|--------|-------------------:|
| 1. Quantum Computing Fundamentals | 20% |
| 2. Amazon Braket Service | 25% |
| 3. Quantum Circuits and Gates | 15% |
| 4. Hybrid Quantum-Classical Workflows | 15% |
| 5. Quantum Algorithms | 15% |
| 6. Cost and Operational Considerations | 10% |

## Key Concepts by Domain

### Domain 1: Fundamentals
- Qubit, superposition, entanglement, measurement, decoherence
- Bloch sphere visualization
- State vector representation; Dirac notation (|0>, |1>, |+>, |->)
- Pauli matrices (X, Y, Z), Hadamard (H), phase (S, T)
- Unitary evolution and reversibility
- No-cloning theorem
- Bell states and their preparation

### Domain 2: Amazon Braket
- Braket service architecture: notebooks, hybrid jobs, tasks, devices
- SDK (Python amazon-braket-sdk)
- Supported hardware: IonQ (Aria, Forte), Rigetti (Ankaa), IQM (Garnet), QuEra (Aquila, neutral atom)
- Simulators: SV1 (state vector), DM1 (density matrix), TN1 (tensor network), local simulators
- IAM permissions: braket:CreateQuantumTask, GetQuantumTask, etc.
- S3 result storage
- CloudWatch metrics, CloudTrail audit
- Braket Pulse for low-level pulse control
- Braket Direct for reserved capacity

### Domain 3: Circuits and Gates
- Single-qubit gates: I, X, Y, Z, H, S, T, Rx, Ry, Rz
- Multi-qubit gates: CNOT, CZ, SWAP, CCNOT (Toffoli), CSWAP (Fredkin)
- Universal gate sets
- Circuit depth and width
- Native gate sets per QPU (varies by hardware)
- Circuit transpilation and optimization
- Compilation strategies

### Domain 4: Hybrid Workflows
- Braket Hybrid Jobs: container-based hybrid execution
- Variational algorithms requiring classical optimizer + quantum circuit
- Priority queueing for hybrid jobs
- BYO container or managed PennyLane container
- Integration with Amazon SageMaker for ML
- Result aggregation and post-processing

### Domain 5: Algorithms
- Grover's algorithm (search; quadratic speedup)
- Shor's algorithm (factoring; conceptual at exam scale)
- Quantum Phase Estimation (QPE)
- Variational Quantum Eigensolver (VQE)
- Quantum Approximate Optimization Algorithm (QAOA)
- Quantum Machine Learning basics
- Annealing (relevant for some hardware)
- Quantum Fourier Transform (QFT)

### Domain 6: Cost and Operations
- Per-task pricing + per-shot pricing model
- Device-specific pricing (varies significantly)
- Reservation model (Braket Direct)
- Hybrid Job pricing (compute + quantum)
- Simulator pricing per minute
- Cost monitoring with AWS Cost Explorer and tagging
- Error mitigation strategies and cost trade-off
- Choosing simulator vs QPU for development phase

## Hardware on Amazon Braket (verify current list)

| Provider | Modality | Devices (representative) |
|----------|----------|--------------------------|
| IonQ | Trapped ion | Aria, Forte |
| Rigetti | Superconducting | Ankaa |
| IQM | Superconducting | Garnet |
| QuEra | Neutral atom (analog Hamiltonian) | Aquila |

Hardware comes and goes from Braket; always check `device.is_available` and the AWS console for current devices and queue depths.

## Simulators on Amazon Braket

| Simulator | Type | Use |
|-----------|------|-----|
| SV1 | State vector | General purpose, up to ~34 qubits |
| DM1 | Density matrix | Simulating noise, smaller qubit count |
| TN1 | Tensor network | Larger circuits with limited entanglement |
| LocalSimulator | In-process | Free for development; limited size |

## Official Resources

- Amazon Braket: https://aws.amazon.com/braket/
- Braket docs: https://docs.aws.amazon.com/braket/
- Braket SDK: https://github.com/amazon-braket/amazon-braket-sdk-python
- Braket Tutorials: https://github.com/amazon-braket/amazon-braket-examples
- AWS Quantum blog: https://aws.amazon.com/blogs/quantum-computing/
- PennyLane integration: https://docs.pennylane.ai/projects/braket/
- IonQ docs: https://ionq.com/docs
- Rigetti docs: https://docs.rigetti.com/
- AWS Center for Quantum Computing

## Recommended Materials

- Book: Quantum Computing: An Applied Approach (Hidary)
- Book: Programming Quantum Computers (Johnston, Harrigan, Gimeno-Segovia)
- Book: Quantum Computation and Quantum Information (Nielsen and Chuang) for depth
- AWS Skill Builder Braket courses
- Braket Examples GitHub repo (work through every notebook)
- Qiskit Textbook (provider-agnostic learning resource)
