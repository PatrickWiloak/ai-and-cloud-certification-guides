# CPES - Fact Sheet

## Quick Reference (Preliminary)

| Detail | Info |
|---|---|
| Exam Code | CPES |
| Full Name | Claude Prompt Engineering Specialist |
| Provider | Anthropic |
| Duration | 90 minutes (estimate) |
| Questions | 50-60 (estimate) |
| Passing Score | ~720 / 1000 (estimate) |
| Cost | TBD |
| Delivery | Online proctored |
| Validity | 2 years |

---

## Domain Weights (Preliminary)

| Domain | Weight | Focus |
|---|---|---|
| 1. Prompt Fundamentals | 18% | Anatomy, clarity |
| 2. System Prompts and Role | 16% | Persona, constraints |
| 3. Chain-of-Thought / Extended Thinking | 16% | Reasoning elicitation |
| 4. XML Tags / Structured Outputs | 14% | Structure |
| 5. Few-Shot / Many-Shot | 14% | Examples |
| 6. Evaluation and Iteration | 12% | Evals, A/B, regression |
| 7. Prompt Caching Patterns | 10% | Cache-aware design |

---

## Anthropic's 10 Prompting Techniques (As Documented)

In rough order from highest impact:

1. Be clear and direct
2. Use examples (multishot)
3. Let Claude think (chain of thought)
4. Use XML tags
5. Give Claude a role (system prompts)
6. Prefill Claude's response
7. Chain complex prompts
8. Long context tips
9. Extended thinking tips
10. Iterate and evaluate

These map closely to the exam domains. Memorize the list.

---

## Prompt Anatomy

A typical Claude prompt has these layers, in order:

1. System prompt (persona, constraints, capabilities)
2. Tool definitions (if using tools)
3. Cached static context (reference docs, few-shot examples)
4. Per-request context (retrieved snippets)
5. User message with explicit task

Keep static layers stable; vary only the latest layers.

---

## Clarity Principles

- Write as if to a thoughtful but new colleague
- State the goal explicitly, not implicitly
- Specify the audience for the output
- Specify the format of the output
- Specify length and tone constraints
- State what NOT to do when relevant
- Avoid ambiguity ("be brief" vs "respond in 2-3 sentences")

---

## System Prompts

The `system` field sets:

- Role / persona
- Background context that applies to every turn
- Capabilities and limitations
- Default behaviors (length, tone, format)
- Constraints (do not reveal X, do not produce Y)

System prompts persist across the entire conversation. User prompts vary.

---

## Role Prompting

"You are a senior security engineer reviewing code for vulnerabilities."

Effects:

- Activates relevant vocabulary and behaviors
- Constrains scope
- Helps Claude default to appropriate technical depth

Limits:

- Roles do not override safety; Claude will refuse harmful content regardless of role
- Overly cute personas can degrade quality on technical tasks
- Generic roles ("helpful AI") add little

---

## Chain of Thought (CoT)

Three flavors:

1. Implicit - "Think step by step." Brief, often sufficient.
2. Structured - "First, X. Second, Y. Then, Z."
3. Tagged - Use `<thinking>` and `<answer>` XML tags so reasoning and answer can be parsed separately.

Use CoT when:

- The task requires multi-step reasoning
- Quality matters more than latency
- You can verify or extract just the final answer

Skip CoT when:

- The task is single-shot retrieval or classification
- Latency is critical
- Extended thinking is enabled (which serves the same purpose more effectively)

---

## Extended Thinking vs CoT

| Aspect | CoT in Prompt | Extended Thinking |
|---|---|---|
| Where | In your prompt | Native API feature |
| Visibility | Visible in response | Returned as opaque thinking blocks |
| Cost | Counts as output | Counts as output (separately reported) |
| Models | All | Models that support thinking |
| Best For | When you want visible reasoning | When you want quality without prompt clutter |

You can combine both, but it is rarely necessary.

---

## XML Tags

Claude responds especially well to XML-tagged structure. Common tags:

- `<instructions>` - what to do
- `<context>` - background info
- `<examples>` - few-shot demonstrations
- `<input>` / `<document>` - source material
- `<output_format>` - how to respond
- `<thinking>` - reasoning scratchpad
- `<answer>` - final response

Pick names that mean something for your domain. Be consistent across prompts.

---

## Structured Outputs

Three production patterns:

1. Forced tool choice with a schema tool (most reliable)
2. JSON output via prefill: start the assistant with `{` to force JSON
3. XML wrapping: ask Claude to put the answer in `<json>...</json>` and parse out

For strict schemas, prefer #1.

---

## Prefill

You can pre-fill the start of Claude's response by appending an assistant message:

```
[..., {"role": "assistant", "content": "{"}]
```

Effects:

- Forces Claude to continue from your prefill
- Useful for JSON outputs (prefill `{`)
- Useful for skipping pleasantries
- Removes most refusal preambles

Limits:

- Only short prefixes work well
- Prefill content is not generated; you supplied it

---

## Few-Shot Prompting

Provide N examples of input/output pairs to demonstrate format and behavior.

Guidelines:

- 2-5 examples is typical; more for harder tasks (many-shot)
- Examples should span the input distribution
- Include edge cases as examples
- Format examples consistently with intended output
- Wrap examples in XML tags for clarity

Many-shot (dozens of examples) can outperform few-shot for nuanced tasks. Cost more in tokens.

---

## Example Selection

Bad: 5 nearly identical examples. Wastes tokens, narrows behavior.

Good: 5 examples spanning easy / typical / hard / edge / counter-example.

For dynamic systems: retrieve relevant examples per request from an examples library.

---

## Counter-Examples

Showing what NOT to do can be powerful:

```
<example>
<input>...</input>
<bad_output>This output is wrong because it omits X.</bad_output>
<good_output>This is the correct response.</good_output>
</example>
```

Use sparingly; overuse can confuse.

---

## Long Context Tips

When your prompt includes a long document:

- Place the document before the question
- Use XML tags to delimit the document clearly
- Ask Claude to quote relevant passages before answering
- Place the question at both the top and bottom of the prompt for very long inputs (Claude pays more attention to recent tokens)
- Use prompt caching on stable long contexts

---

## Iteration Loop

1. Define the task and success criteria
2. Build a starter eval dataset (20-50 items)
3. Write v1 prompt
4. Score v1 against the eval set
5. Identify failure modes; categorize them
6. Targeted prompt change addressing one failure mode
7. Re-score; compare to v1
8. If better, ship v2; if not, revert and try another change
9. Repeat

Discipline: change one thing at a time. Otherwise you cannot attribute improvements.

---

## Eval Patterns

- Unit checks: schema valid, contains expected term, length within range
- LLM-as-judge: Claude grades against a rubric
- Pairwise: judge picks between two outputs
- Human spot checks for calibration

---

## Prompt Caching Design

To make prompts cache-friendly:

- Place all static content first
- Put `cache_control` at the end of stable regions
- Avoid templating in dynamic values inside cached regions
- Order: system prompt -> tools -> reference docs -> examples -> dynamic context -> user message
- Verify with `cache_creation_input_tokens` and `cache_read_input_tokens`

---

## High-Yield Tips

1. XML tags help Claude parse structure
2. Be explicit, not clever
3. Examples beat instructions for format
4. Prefill solves many output-format problems
5. Extended thinking beats CoT for hard reasoning
6. Cache the static prefix
7. Iterate with evals, not vibes
8. Counter-examples are powerful but easy to overdo
9. Forced tool choice is the most reliable structured output
10. Long contexts: question at top AND bottom

---

## Common Traps

1. Putting dynamic values inside the cached prefix
2. Asking Claude to "be brief" instead of specifying tokens or sentences
3. Stacking 20 examples when 4 would do
4. Using prompts to enforce safety policies (defense in depth: prompt + classifier)
5. Forgetting that role prompting is not a security control
6. Long prompts with the question buried in the middle
7. Iterating without a baseline measurement
8. Calibrating LLM judges against zero human labels
9. Confusing extended thinking (native) with CoT (prompt technique)
10. Thinking prompt caching is automatic - it requires explicit `cache_control`
