# 06 - Prompt Evaluation and Iteration

The difference between a good prompt and a great one is iteration. The difference between iteration and guesswork is measurement. This note covers building prompt eval datasets, scoring strategies, A/B testing, and regression discipline.

---

## The Iteration Loop

1. Define the task and what "good" looks like
2. Build a starter eval dataset (20-50 items)
3. Write v1 prompt
4. Score v1 against the eval set
5. Identify failure modes; categorize them
6. Make a targeted prompt change addressing one failure mode
7. Re-score; compare to v1
8. If better, ship v2; if not, revert and try another change
9. Repeat

The discipline: change one thing per iteration. Otherwise you cannot attribute improvements.

---

## Eval Dataset Design

A useful eval dataset has:

- 20-200 items (start small, grow)
- Coverage of the input distribution (easy, typical, hard, edge)
- Known-bug cases (regressions you have already fixed)
- Adversarial cases (jailbreaks, prompt injections, malformed input)
- Gold labels or rubric criteria
- Tags for slicing results (input type, complexity, expected behavior)

Anti-patterns:

- An eval set that always passes (too easy)
- An eval set that always fails (too hard or rubric is broken)
- An eval set built once and never refreshed
- An eval set without gold labels that drifts into "looks ok"

---

## Scoring Methods

### Unit Checks

Deterministic verification:

- Schema validity (JSON parseable, fields present)
- Length within range
- Contains required substring or pattern
- Matches regex
- Numeric equality or tolerance

Cheap, fast, reliable. Use whenever the criterion is mechanical.

### LLM-as-Judge

Claude (often Sonnet or Opus) grades the target output against a rubric:

```
You are evaluating a customer support response.

<response>
{candidate}
</response>

<rubric>
- Accuracy: did it answer the user's question correctly?
- Tone: was it friendly and professional?
- Length: was it appropriately concise (under 4 sentences)?
- Safety: did it avoid making promises it cannot keep?
</rubric>

For each criterion, score 1-5 with brief justification.
Then give an overall pass/fail.
```

Get structured output (forced tool choice with a schema) so you can aggregate.

### Pairwise Judging

Show two candidate outputs; ask the judge which is better. Useful when "best" is hard to define absolutely.

```
<candidate_a>...</candidate_a>
<candidate_b>...</candidate_b>

Which response is better? Consider accuracy, tone, conciseness.
Output: A, B, or TIE, with one-sentence justification.
```

Pairwise judges often agree more reliably than absolute-score judges.

### Human Spot Checks

Always have humans spot-check a sample. This calibrates the LLM judge and catches systematic blind spots.

---

## Judge Calibration

A judge is only useful if its labels correlate with human judgment.

Procedure:

1. Collect 20-50 items with human labels
2. Run the judge on the same items
3. Compute agreement (accuracy or correlation)
4. Iterate on the judge prompt until agreement is acceptable (>0.7 typical)
5. Re-calibrate periodically (monthly or after model upgrades)

Red flags:

- Judge biased toward verbose responses
- Judge favors its own model's style
- Judge inconsistent run-to-run (set temperature low for judges)

---

## A/B Testing Prompts

Run two variants on the eval set; compare scores.

```python
results_a = score_all(eval_set, prompt_a)
results_b = score_all(eval_set, prompt_b)
delta = results_b.mean() - results_a.mean()
```

Significance:

- For small eval sets, eyeball improvements > 5 points or so
- For larger sets, use statistical tests (paired t-test or bootstrap)
- Guard against overfitting to the eval set; hold out a test set

---

## Regression Discipline

Production prompt changes are software changes. Treat them with CI.

- Every prompt change runs the eval set in CI
- Block merges that drop quality by more than N% (e.g., 3%)
- Require justification to override
- Maintain a baseline file in version control

This single practice prevents most prompt regressions.

---

## What to Iterate On

Common levers, in rough order of impact:

1. Adding examples
2. Adding clear format specification
3. Specifying audience and tone
4. Adding chain of thought
5. Switching system vs user content
6. Adjusting role / persona
7. Adding counter-examples
8. Adjusting temperature
9. Trying a different model

Try one lever at a time. Document the hypothesis and result.

---

## Failure Mode Categorization

When prompts fail, categorize:

- Format failures (wrong shape)
- Hallucinations (made up facts)
- Truncation (response cut off)
- Refusals (Claude declined)
- Length (too long or too short)
- Tone (wrong register)
- Reasoning (correct format, wrong logic)
- Edge case (specific input class fails)

Each category has different remedies. A category of failures is more actionable than a list of individual failures.

---

## Prompt Journal

Maintain a prompt journal for every project:

```
v3 -> v4
Date: 2026-04-12
Hypothesis: Adding two diverse counter-examples will reduce false positives.
Change: Added two counter-examples in <bad_output> tags.
Eval delta: +4.2% accuracy on the held-out set, +800 input tokens.
Cost delta: +$0.0003 per request.
Decision: Ship.
Notes: Counter-examples were specifically the sarcasm and double-negation cases.
```

This discipline pays off when:

- Onboarding new team members
- Debugging regressions ("when did we last change this?")
- Learning what works for your domain
- Studying for the exam

---

## Anti-Patterns

- Iterating without a baseline measurement
- Changing 5 things at once
- Over-fitting to the eval set
- LLM judges with no human calibration
- Treating the eval set as immutable and never adding cases
- Ignoring failed cases instead of categorizing
- Rolling back without recording why

---

## Exam Focus

- The iterate-measure-attribute discipline
- Eval dataset properties
- Unit vs LLM-as-judge vs pairwise
- Judge calibration
- Regression gates as a CI practice
- Failure mode categorization
