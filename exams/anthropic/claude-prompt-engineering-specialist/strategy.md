# CPES - Exam Strategy

The Specialist exam tests judgment more than recall. Many questions show two prompt variants and ask which is better, or show a failing prompt and ask which intervention would help most. Your job is to recognize the technique each option represents and judge its fit.

---

## 3-Phase Preparation

### Phase 1 - Read (Week 1)

Read Anthropic's prompt engineering guide twice. Make a one-page cheat sheet of techniques with examples. The exam vocabulary tracks the docs precisely.

### Phase 2 - Practice (Weeks 2-3)

Iterate on a real task with measured evals. You should ship at least 5 prompt versions and know which technique drove which improvement.

### Phase 3 - Drill (Week 4)

Run timed scenarios. Re-read the fact sheet. Sleep before the exam.

---

## Time Management

Assume 55 questions in 90 minutes. ~1m 35s per question with a small buffer.

| Time Elapsed | Question # |
|---|---|
| 25 min | 16 |
| 50 min | 32 |
| 75 min | 48 |
| 85 min | 55 (done, review) |

First pass: answer fast, flag the slow ones. Second pass: spend buffer on flags.

---

## Reading Prompt Snippets Fast

Train yourself to spot:

- XML tag usage and consistency
- Where the question is placed (top, middle, bottom)
- Whether examples are in the prompt
- Whether the system field is used at all
- Whether `cache_control` appears
- Whether `tool_choice` is forced for structured output
- Whether prefill is used

Most "what is the best prompt" questions test one of these axes. Identify the axis first.

---

## Common Question Patterns

### "Which prompt is more effective?"

Look for:

- Better use of XML structure
- Explicit format and constraint specification
- Examples present and well-chosen
- Question position (top + bottom for long context)
- System prompt used appropriately

### "What is the most effective change?"

Identify the failure mode the prompt currently exhibits, then match the intervention:

- Wrong format -> examples or forced tool choice
- Wrong tone -> system prompt with persona
- Bad reasoning -> chain of thought or extended thinking
- Verbose -> length constraint
- Lost in long context -> question at top and bottom; XML tags
- Inconsistent across calls -> few-shot anchoring
- Refuses inappropriately -> rephrase task; system prompt clarification

### "Why is this prompt failing?"

Look for ambiguity, missing format spec, missing examples, dynamic content in cached regions, role prompts used as safety controls.

---

## Answer Selection Heuristics

- Prefer documented Anthropic patterns over clever alternatives
- Prefer the simpler intervention that addresses the named failure
- Prefer techniques that compose (XML + examples + CoT) when the question allows
- Prefer extended thinking over prompt-level CoT when the model supports it AND you do not need visible reasoning
- Prefer forced tool choice for strict structured outputs
- Prefer examples over instructions for format requirements

---

## Domain-Specific Tactics

### Prompt Fundamentals

Look for clarity, specificity, and ordering. The best prompt is usually the most explicit one within reason.

### System Prompts

System prompts persist; user prompts vary. Constraints and persona belong in system. The actual task belongs in user.

### Chain of Thought

Three flavors: implicit ("think step by step"), structured (numbered steps), tagged (`<thinking>`/`<answer>`). All work; tagged is most parseable.

### XML Tags

Use them. Be consistent. Tag names should be meaningful for the domain.

### Few-Shot

Quality of examples beats quantity. Diversity beats redundancy. Include edge cases.

### Evaluation

Eval datasets must have gold or rubric. LLM judges must be calibrated. A/B test deliberately.

### Prompt Caching

`cache_control` on content blocks. Static content first. Dynamic content last. Verify with usage fields.

---

## Counter-Intuitive Facts to Internalize

- Adding "be helpful and concise" alone often does little. Specify tokens or sentences.
- Long instructions can outperform short ones on hard tasks.
- Few-shot helps even when the task is well-described.
- Extended thinking can underperform a well-crafted prompt with no thinking on simple tasks (cost without benefit).
- Prefill is one of the most underused techniques.
- Roles do not bypass refusals.

---

## The 24 Hours Before

- Re-read fact sheet
- Re-read this strategy
- Sleep
- Have ID and stable internet ready

---

## During the Exam

- Read every prompt snippet fully; do not skim
- Identify the technique axis the question targets
- Eliminate two answers fast
- Choose the answer most aligned with Anthropic's documented patterns

---

## If You Fail

Score reports show your weakest domain. Spend two weeks rebuilding it with hands-on exercises. Re-sit. Specialist exams reward depth in the craft, which compounds with practice.
