# 03 - Chain of Thought and Extended Thinking

Two distinct mechanisms for getting Claude to reason before answering. They overlap but are not interchangeable. The Specialist exam expects you to choose between them and combine them when appropriate.

---

## Chain of Thought (CoT)

CoT is a prompt-level technique. You instruct Claude to think step by step before giving the final answer. The reasoning becomes part of the visible response.

### Three Flavors

1. Implicit:

```
"Think step by step before answering."
```

2. Structured:

```
"First, identify the key facts. Second, list possible interpretations.
Third, pick the most likely interpretation. Fourth, give the answer."
```

3. Tagged:

```
"Use <thinking> tags to reason. Place your final answer in <answer> tags."
```

### When CoT Helps

- Multi-step reasoning (math, logic, planning)
- Tasks where Claude makes shortcuts that lead to wrong answers
- Tasks where you can verify the chain or extract just the answer
- Tasks where the user benefits from seeing reasoning

### When CoT Hurts

- Latency-sensitive flows (CoT lengthens responses)
- Simple classification or lookup tasks (no benefit, just cost)
- Cases where the user only wants the answer and the CoT clutters output

### Tagged CoT for Parsing

```
Use the <thinking> tags to work through the problem.
Then provide the final answer in <answer> tags.

<thinking>
[Claude's reasoning]
</thinking>

<answer>
[Final answer]
</answer>
```

The parser extracts only the `<answer>` content for downstream use. This is the most production-friendly CoT pattern.

---

## Extended Thinking

Extended thinking is a native API feature that produces opaque thinking blocks before the visible response. Enable per-request:

```python
thinking={"type": "enabled", "budget_tokens": 8000}
```

### Properties

- Returns `thinking` content blocks alongside `text` blocks
- Thinking content is opaque (not intended for end-user display)
- Includes a `signature` that must be preserved on continuations
- Billed at output rates
- Available on supported models (claude-opus-4-6, claude-sonnet-4-6 with appropriate config)

### Budget Tuning

`budget_tokens` is a soft cap. Claude may stop earlier. Typical budgets:

- 1024-2048: light reasoning lift
- 4096-8192: meaningful improvement on hard tasks
- 16K-32K: deep reasoning for very hard problems

ROI is concave - early gains, diminishing returns. Measure on your eval set.

### When Extended Thinking Helps

- Hard math, code generation, planning
- Multi-constraint optimization
- Research synthesis with conflicting sources
- Decisions with significant downside cost

### When Extended Thinking Hurts

- Simple tasks (no quality lift, all cost)
- Latency-sensitive UI
- Tasks where prompt-level CoT already saturates quality

---

## CoT vs Extended Thinking

| Aspect | Prompt CoT | Extended Thinking |
|---|---|---|
| Where defined | Prompt text | API parameter |
| Visibility | In response text | Opaque blocks |
| Parseability | Need to parse out final answer | Native separation |
| Cost | Output tokens | Output tokens (separate accounting) |
| Models | All | Supported models only |
| Continuation | No special handling | Must preserve thinking blocks with signatures |
| Best for | Short reasoning, when reasoning helps user | Hard problems, hidden reasoning |

For production: use extended thinking when supported and reasoning need not be displayed; use tagged CoT when you need visible or simpler reasoning.

---

## Combining Both

You can enable extended thinking AND ask Claude to use `<thinking>` tags in the visible response. Rare but possible. Usually one or the other suffices.

---

## Interleaved Thinking

In agentic loops, interleaved thinking lets Claude think between tool calls within one turn. Enable via supported model + configuration. Major quality lift on multi-step agents.

Token cost increases proportional to thinking budget per inter-tool step. Measure carefully.

---

## Continuation Rules for Extended Thinking

When you continue a conversation that included thinking + tool_use:

- Preserve the assistant message verbatim, including thinking blocks and their signatures
- Add tool_result blocks in a new user message
- Continue the conversation

The API rejects modified or stripped thinking blocks. This is a frequent exam item.

---

## Worked Example - Prompt CoT

```
System: "You are a careful financial analyst."

User:
"Use <thinking> tags to work through the problem step by step.
Place your final recommendation in <recommendation> tags.

A startup raised $5M at a $20M post-money valuation. They have $200K
monthly burn and $1M ARR growing 15% MoM. Should they raise more in 6 months?"
```

Claude responds with structured reasoning in `<thinking>`, recommendation in `<recommendation>`. The downstream parser only consumes `<recommendation>`.

---

## Worked Example - Extended Thinking

```python
client.messages.create(
    model="claude-opus-4-6",
    max_tokens=4096,
    thinking={"type": "enabled", "budget_tokens": 8000},
    system="You are a careful financial analyst.",
    messages=[{"role": "user", "content": "<the same question>"}],
)
```

Same task, no prompt-level CoT instruction needed. The thinking happens in opaque blocks; the visible text is the recommendation.

---

## Choosing Between Them

| Situation | Choice |
|---|---|
| Production agent on supported model | Extended thinking |
| User wants to see reasoning | Tagged CoT |
| Latency-critical interactive UX | Neither (or minimal CoT) |
| Simple classification | Neither |
| Hard task, hidden reasoning ok | Extended thinking |
| Hard task, visible reasoning needed | Tagged CoT |
| Migrating older code | Often start with CoT, evaluate switch to extended thinking |

---

## Anti-Patterns

- Adding "Think step by step" to every prompt by default
- Enabling extended thinking on a Haiku model where it does not help
- Setting thinking budgets without measuring ROI
- Stripping thinking blocks before continuation
- Using prompt CoT when the user only wants the answer

---

## Exam Focus

- The difference between CoT and extended thinking
- Tagged CoT for parseable reasoning
- Extended thinking budget tuning
- Continuation rules for extended thinking
- When neither technique is appropriate
