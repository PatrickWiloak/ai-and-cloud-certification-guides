# AWS Quantum Practitioner (QPC-C01) - Anticipated Study Track

> ℹ️ **Anticipated study track, not a currently-available certification.** AWS has not formally announced an exam under this code. The structure below is built from the public direction of Amazon Braket, AWS quantum announcements, and adjacent specialty exam patterns. Use this as a self-directed proficiency track for quantum on AWS; verify all specifics against AWS Training and Certification when an official exam is released.

## Overview

The "AWS Quantum Practitioner" framing here targets practitioners who design, build, and operate quantum computing workloads on AWS. The material is structured around what AWS has publicly emphasized in Braket announcements and quantum-focused re:Invent sessions; treat exam-style specifics as anticipated, not authoritative.

The credential is positioned for the rapidly growing community of researchers, ML engineers, and cloud architects who use Amazon Braket to access quantum hardware and simulators, build hybrid quantum-classical workflows, and run quantum algorithms (VQE, QAOA, Grover, Shor) at small but increasing scale. Quantum is not yet a production workload for most enterprises, but it is increasingly a strategic R&D investment, and AWS has invested heavily in Braket and the Center for Quantum Computing at Caltech.

## Target Audience

- ML engineers and data scientists exploring quantum approaches
- Cloud architects supporting quantum R&D workloads
- Researchers using Braket as their primary quantum runtime
- Solutions architects advising clients on quantum readiness
- Engineers preparing for hybrid quantum-classical infrastructure

## Prerequisites

- Working AWS knowledge (Solutions Architect Associate level recommended)
- Comfort with Python (Boto3, Braket SDK, NumPy)
- Linear algebra fundamentals (vectors, matrices, complex numbers, tensor products)
- Probability and statistics basics
- No prior quantum experience strictly required, but helpful

## Domain Focus

The notes cover six anticipated domains:

1. Quantum Computing Fundamentals
2. Amazon Braket Service
3. Quantum Circuits and Gates
4. Hybrid Quantum-Classical Workflows
5. Quantum Algorithms (VQE, QAOA, Grover, basic Shor)
6. Cost and Operational Considerations

## Official Resources

- Amazon Braket: https://aws.amazon.com/braket/
- Amazon Braket documentation: https://docs.aws.amazon.com/braket/
- Braket SDK (Python): https://github.com/amazon-braket/amazon-braket-sdk-python
- AWS Quantum Computing blog: https://aws.amazon.com/blogs/quantum-computing/
- AWS Center for Quantum Computing: https://aws.amazon.com/research/quantum-computing/
- Hardware partner pages: IonQ, Rigetti, IQM, QuEra
- AWS Training portal (search for quantum learning paths)

## How This Guide Is Organized

- README.md: orientation
- fact-sheet.md: anticipated blueprint, format estimates, references
- practice-plan.md: 6 week study plan with hands-on Braket labs
- strategy.md: anticipated exam tactics and quantum-specific advice
- scenarios.md: 10 realistic Braket / quantum scenarios
- notes/: six topic notes covering quantum fundamentals, Braket, and operations

## What Makes This Exam Different

Quantum is the most mathematics-heavy of all AWS specialties. Expect:

- Linear algebra reasoning (state vectors, unitary matrices, tensor products)
- Probability and measurement concepts
- Algorithm-level reasoning rather than rote memorization
- Service operations (Braket APIs, IAM, cost) layered on top of quantum reasoning

Unlike some specialties, hands-on practice on real QPUs is expensive, but simulators are accessible and cover most exam-relevant practice.

## Important Caveats

- Exam is anticipated; verify code, format, pricing on AWS Training when available
- Quantum hardware roster on Braket changes (providers added/removed); always check current device list
- Pricing is per-shot or per-task plus device fees; small experiments are inexpensive but production-style workloads can surprise

## Study Time Estimate

- Existing AWS architect with quantum exposure: 40-60 hours
- AWS architect with no quantum: 80-120 hours
- Quantum researcher new to AWS: 60-90 hours
