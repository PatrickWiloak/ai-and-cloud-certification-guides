# 03 - Extended Thinking and Context Management

Extended thinking and deliberate context engineering are the two levers that most distinguish Advanced architects from Foundations-level practitioners. Both are about spending the right tokens in the right places.

---

## Extended Thinking

Extended thinking is Claude's internal reasoning mode. Before producing the user-visible response, Claude generates a `thinking` block: private, structured reasoning that improves answers on hard tasks.

### Enabling

```python
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=16000,
    thinking={"type": "enabled", "budget_tokens": 8000},
    messages=[{"role": "user", "content": "..."}],
)
```

`budget_tokens` is a soft cap for the thinking block. Claude may stop thinking earlier if it reaches confidence. `max_tokens` is the overall response cap and must exceed `budget_tokens`.

### Billing and Accounting

Thinking tokens are billed at output rates. Budget for them as output costs. A task with 2K response + 8K thinking costs as if you generated 10K output tokens.

### Response Shape

The response content array includes `thinking` blocks alongside `text` blocks:

```json
[
  {"type": "thinking", "thinking": "...", "signature": "..."},
  {"type": "text", "text": "..."}
]
```

The `signature` is an opaque verification token. You must preserve thinking blocks verbatim (including signatures) when continuing a turn with tool results.

### Interleaved Thinking

On supported models, Claude can emit thinking blocks between tool calls, not only at turn start. This lets the agent reflect on a tool result before deciding the next action. Enable via model support plus request configuration.

Interleaved thinking is a major quality win for long-horizon agents but increases token cost. Measure before rolling out broadly.

### When to Use Extended Thinking

Use for:

- Math, logic, complex planning
- Code generation on non-trivial problems
- Multi-constraint optimization
- Research synthesis across conflicting sources
- Decisions with high downside cost

Skip for:

- Classification
- Simple rewriting or summarization
- Retrieval and surface-level Q&A
- Streaming chit-chat UX where latency matters more than quality

### Budget Tuning

Start at 4K. Measure quality on your eval set. Increase to 8K, 16K if quality still climbs. Decrease aggressively if it flatlines. The ROI curve is usually concave - big gains early, diminishing returns past some inflection.

### Streaming With Thinking

Streaming works with extended thinking. The thinking content streams but arrives as a single coherent block from the user's perspective. Show a "Thinking..." indicator during this period.

---

## Context Window Economics

Claude 4.x models have 200K-token context windows (1M in some configurations). But context is expensive - every token is paid for on every turn. Context discipline compounds over a product's lifetime.

### Core Principle

Only put things in context that (a) must be there and (b) are not reusable. Everything reusable should be cached. Everything stale should be summarized or offloaded.

### Context Layers

Think of context as an ordered stack:

1. System prompt (cache-eligible, rarely changes)
2. Tool definitions (cache-eligible)
3. Stable reference documents (cache-eligible)
4. Retrieved just-in-time context (varies per request)
5. Message history (accumulates)
6. Current user message (always fresh)

Caching candidates are the top layers. Ordering matters: caching works best when cached content sits at the prefix.

### Summarization

When message history exceeds a threshold:

- Summarize with a cheap model (Haiku)
- Preserve the last N turns verbatim for recency
- Replace older turns with the summary
- Re-cache the new prefix once it stabilizes

Tradeoff: summarization loses nuance. Eval before and after to ensure quality holds.

### Retrieval

For documents and structured data, retrieve what is needed per request rather than pre-loading. Hybrid retrieval (vector + lexical + rerank) is the advanced default. Use Claude's citations feature to link answers back to source chunks.

### Contextual Retrieval

At ingest time, prepend each chunk with a generated summary of its containing document, e.g.:

```
[This chunk is from the 2026 Claude Developer Handbook, section on Tool Use.]
<original chunk text>
```

This lift in retrieval accuracy is free at query time (the work is at ingest) and typically improves top-k recall meaningfully.

---

## The Memory Tool

The memory tool is a first-party primitive for durable cross-session state. Claude reads and writes to a client-provided memory store. Common patterns:

### User-Scoped Memory

Personalization: preferences, voice, past decisions. Memory entries keyed by user ID. Load into context at session start.

### Project-Scoped Memory

Long-running agents (research agents, coding agents) persist notes, plans, partial results. Memory survives across restarts.

### Append-Mostly Discipline

Memory grows forever if you let it. Rules of thumb:

- Prefer append over update; updates lose history
- Prune by age and relevance, not by "we have too much"
- Tag entries with category and timestamp
- Compact old memory into summaries periodically

### Memory vs Prompt Caching

They solve different problems:

| Feature | Memory Tool | Prompt Caching |
|---|---|---|
| Lifespan | Durable across sessions | Minutes (5min or 1hr) |
| Purpose | Stateful knowledge | Token cost reduction |
| Updated by | The agent | You (by repeating prefix) |
| Counts toward context | Yes, when loaded | Yes, same tokens |

A production personalization system often uses both: memory for what to include, caching for the static envelope around it.

---

## Context Pitfalls

1. Caching unstable prefixes - cache churn destroys the economics. If the prefix changes per request, do not cache it.
2. Loading full conversation history forever - compact or summarize.
3. Putting retrieved content inside the system prompt - breaks caching on the retrieval variability.
4. Forgetting that memory tool content is context. Pulling 50K tokens from memory costs 50K input tokens.
5. Thinking budgets on cheap tasks - Haiku with thinking can cost more than Opus without.
6. Using extended thinking as a substitute for good prompting. Better prompts often beat bigger thinking budgets.

---

## Worked Example - Context Budget

Target: 30K tokens per request, budget is $0.25.

Without discipline:

- 10K system prompt (not cached) - $30 per 1K requests
- 50K reference doc pre-loaded - 1.7x over budget
- 40K conversation history - history alone blows the budget

With discipline:

- 10K system prompt cached (1.25x write, 0.1x read) - $3 per 1K requests after warmup
- Retrieved 3K chunks per request instead of pre-loading 50K
- Conversation compacted to a 2K summary + last 6 turns
- Result: 15K total context at steady state, well under budget

---

## Advanced Exam Focus

Know:

- Thinking is billed at output rates
- Thinking blocks must be preserved verbatim with signatures when continuing with tool results
- Interleaved thinking enables between-tool reflection
- Memory tool is for durable state; prompt caching is for token cost
- Contextual retrieval is an ingest-time technique
- Compaction invalidates caching past the compaction point
- Cache writes cost more; cache reads cost much less; break-even around 2 reads
