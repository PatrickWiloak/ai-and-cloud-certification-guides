# FinOps Certified Analyst - Exam Strategy

## Time Management

- 90 minutes for 60 questions means 90 seconds per question average
- Target 75 seconds per question on first pass, leaving 15 minutes for review
- Flag anything that needs a calculation for pass two, do the quick-knowledge items first
- Do not spend more than 2 minutes on any single item before flagging and moving on

## Question Style and What to Expect

FOCA questions are more applied than FOCP. Expect these formats:

1. Scenario with a billing snippet: "Given this row with BilledCost 100, EffectiveCost 72, what is the amortized savings?"
2. Multi-response: pick the two correct allocation methods for this situation
3. Compute-then-choose: compute a KPI, then choose the answer closest to your value
4. Diagnostic: given a symptom, identify the most likely cause (anomaly, tag drift, commit expiry)
5. Role-mapping: which persona owns which capability

## Common Traps

### Trap 1: Confusing BilledCost with EffectiveCost
BilledCost is what the invoice shows. EffectiveCost includes amortization of commitments and is what you should use for unit economics. ListCost is the public rate before any discount.

### Trap 2: Chargeback vs showback vocabulary
Showback is visibility only, no money moves. Chargeback triggers an actual internal financial transfer. A question that says "teams see their cost but finance does not reallocate budget" is showback, not chargeback.

### Trap 3: Commitment coverage vs utilization
Coverage is "what percent of eligible usage is covered by commitments." Utilization is "what percent of commitments are actually used." They answer different questions and exam items will try to swap them.

### Trap 4: Mean vs median in anomalies
For skewed spend distributions, median and MAD (median absolute deviation) are more robust than mean and standard deviation. If the question describes spiky data, lean toward MAD-based answers.

### Trap 5: Amortization direction
RI upfront fee amortizes forward over term. Refunds and credits typically appear as negative line items on the invoice date, not amortized back. Do not amortize what is not amortizable.

### Trap 6: FinOps principles wording
The principles have specific canonical wording. "Teams need to collaborate" is one. "A centralized team drives FinOps" is another. Paraphrases that change meaning ("a centralized team does FinOps for the company") are wrong.

## Anti-Patterns to Avoid

- Over-indexing on one cloud provider; the exam is cloud-agnostic and often uses generic language or FOCUS terms
- Assuming more automation is always better; the framework values business-appropriate automation
- Picking the tool-specific answer; questions about practice usually want process answers, not product answers

## If You Are Running Out of Time

- Skim remaining questions, answer anything gut-obvious
- For pure-knowledge items you cannot recall, eliminate two distractors and guess
- Never leave blanks, there is no penalty for wrong answers

## Pre-Exam Checklist

- Review your FOCUS columns cheat sheet
- Review KPI formulas (ESR, coverage, utilization, forecast accuracy)
- Review the six principles and the capabilities list
- Test your webcam, mic, ID, and clear desk for proctoring
- Close all background apps; some proctoring software is strict

## Day Of

- Eat a normal breakfast, hydrate but not too much
- Log in 20 minutes early; proctor check-in can take 10-15 minutes
- Have a government ID ready
- If the proctor flags a violation, comply immediately and continue
- Breathe; you have prepared, trust the prep
