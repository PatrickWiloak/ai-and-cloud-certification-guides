# FinOps Certified Professional - Exam Strategy

## Time Management

- 120 minutes for 65 questions = 110 seconds per question average
- Scenario questions can take 3-4 minutes; pure knowledge items 45 seconds
- Target: 90 seconds average on first pass, 20 minutes reserved for flagged review
- Use the flag aggressively on long scenarios; answer the easy ones first

## Question Style

FOCP-Pro leans heavily on scenarios. Expect:

1. **Multi-constraint design**: "Given a 400M multi-cloud spend, 3 BUs, weak tagging, strong finance partnership, pick the right operating model."
2. **Commitment portfolio judgment**: coverage, mix, and term trade-offs
3. **Root cause and remediation**: "cost spiked 40 percent in 3 days, what do you do first?"
4. **Operating model trade-offs**: centralize vs federate
5. **Policy and governance**: preventive vs detective, what to enforce, what to nudge
6. **Emerging topics**: sustainability integration, AI/ML cost governance

## Key Judgment Axes

The exam repeatedly tests whether you understand these trade-offs:

- Coverage vs flexibility (commitments)
- Standardization vs autonomy (operating models)
- Preventive vs detective governance
- Chargeback vs showback readiness
- Cost vs carbon vs performance
- Centralized commit pool vs BU-owned commits
- Build vs buy for FinOps tooling

## Common Traps

### Trap 1: Over-centralization answers
The "most FinOps" answer is not always "centralize everything." Mature orgs often federate execution with central standards.

### Trap 2: Over-committing
Higher coverage is not always better. Run rate reductions, migrations, and architectural changes reduce the safe commit floor. 65-75 percent coverage often outperforms 90 percent coverage in ESR once risk is priced.

### Trap 3: Tool-first answers
The exam rewards process and data architecture answers. Tool-specific answers usually lose.

### Trap 4: Ignoring sustainability in a cost question
If carbon is mentioned in the scenario, the correct answer weighs it. Pure cost-minimization answers miss when the scenario signals sustainability.

### Trap 5: Confusing AI/ML cost patterns
Training cost is bursty and GPU-dominated. Inference cost scales with users and is latency-sensitive. Levers differ. Caching and model choice dominate for inference; scheduling and spot dominate for training.

### Trap 6: FOCUS column confusion
BilledCost for invoices. EffectiveCost for unit economics. ListCost for what-if / ESR. ContractedCost for negotiated rate analysis. Mixing these breaks the math.

### Trap 7: Convertible vs standard RI
Convertible allows instance family changes, at a lower discount. Standard offers higher discount but less flexibility. Questions that emphasize architectural change ahead favor convertible or Compute SPs.

## Anti-Patterns

- "Always chargeback" answers
- "Let the tool decide" without a data architecture
- Policy without enablement
- Sustainability as an afterthought
- Treating AI/ML as a normal workload

## If Running Out of Time

- Flag all long scenarios, finish all short ones first
- On scenarios, answer the sub-question type first (if multi-part), then refine
- Eliminate obviously wrong options even when uncertain
- Never leave blanks

## Pre-Exam Checklist

- FOCUS columns cheat sheet
- KPI formulas (ESR, coverage, utilization, forecast accuracy, SCI)
- Operating model decision tree
- Commitment decision tree per cloud
- AI/ML cost lever checklist
- Clean desk and environment for proctoring

## Day Of

- Normal sleep, normal breakfast
- Log in 20 minutes early
- Keep water nearby (proctors allow a clear bottle usually)
- Trust preparation; you are not expected to know every detail, you are expected to reason
