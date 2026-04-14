# 07 - Prompt Caching Design Patterns

Prompt caching is not just an optimization knob - it is a prompt design constraint. A cache-friendly prompt is structured very differently from one written without caching in mind. The Specialist exam expects fluency in these design patterns.

---

## Quick Mechanics Recap

- Mark content blocks with `cache_control: {"type": "ephemeral"}`
- Cache writes ~1.25x input rate; cache reads ~0.1x input rate
- TTL: 5 minutes default, 1 hour extended
- Up to 4 cache breakpoints per request
- Minimum cacheable: 1024 tokens (2048 for Haiku)
- Cache is keyed on byte-exact prefix match

See the Application Developer guide note 04 for the deep mechanics. This note focuses on prompt design.

---

## The First Design Rule: Static First, Dynamic Last

Caching is keyed on prefix. Anything that varies invalidates the cache from that point onward. Therefore:

```
[ stable system prompt ]      <- cache breakpoint candidate
[ stable tools ]              <- cache breakpoint candidate
[ stable reference docs ]     <- cache breakpoint candidate
[ stable few-shot examples ]  <- cache breakpoint candidate
---- breakpoint here ----
[ retrieved per-request context ]
[ conversation history ]
[ current user message ]
```

If you put a per-request value (user ID, timestamp, retrieved snippet) in the system prompt, you destroy the cache.

---

## Common Anti-Pattern: Templated Variables in Cached Regions

Bad:

```python
system = f"User: {user_name}\n\n{static_instructions}"
```

Every request has a different `user_name`, so the cache hit rate is zero.

Good:

```python
system = [
    {"type": "text", "text": static_instructions, "cache_control": {"type": "ephemeral"}},
]
messages = [{"role": "user", "content": f"My name is {user_name}. Question: ..."}]
```

Move the variable out of the cached region.

---

## Layered Cache Breakpoints

Use multiple breakpoints when content has stability tiers:

```python
system = [
    {"type": "text", "text": global_persona, "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": tenant_specific_context, "cache_control": {"type": "ephemeral"}},
]
```

Two breakpoints. The first protects the global persona cache from being invalidated when `tenant_specific_context` differs across tenants.

Up to 4 breakpoints per request. Place each at a stability boundary.

---

## Cache the Tools Array

Tool definitions can take thousands of tokens for rich agents. The tools array is implicitly part of the cacheable prefix. Stable tool definitions across requests means cache reads on every call.

If your tool set varies per request (e.g., per-tenant tool gating), structure tool sets carefully to maintain stability across cohorts.

---

## Cache Few-Shot Example Libraries

Many-shot prompts (20+ examples) become cost-prohibitive without caching. With caching:

```python
system = [
    {"type": "text", "text": persona, "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": fifty_examples, "cache_control": {"type": "ephemeral"}},
]
```

Pay the write cost once; read cheaply many times. This is one of the highest-leverage uses of caching for prompt-engineering teams.

---

## Cache the Conversation Prefix

For long-running conversations:

- Cache the system prompt
- Cache the conversation history up to the last few turns
- Vary only the recent turns

This requires placing `cache_control` on the last "stable" turn in the message array. Subsequent requests with identical prior turns reuse the cache.

Tradeoff: cache writes happen each time the stable region grows. Place breakpoints at natural conversation milestones.

---

## TTL Selection

| Pattern | TTL |
|---|---|
| Bursty traffic with quiet periods | 5-min ephemeral (the default) |
| Sustained traffic across hours | 1-hour extended |
| Daily batch jobs | 1-hour or design without caching |
| Once-per-week reports | Caching is not worth it |

The 1-hour tier costs more on writes and slightly more on storage but pays off when your traffic spans the full hour.

---

## Combining Caching With Long Documents

For RAG with a stable corpus or for assistants with a stable long reference doc:

- If the doc fits in context and is referenced often, cache it in the system prompt
- If the doc is per-request (different doc per query), do not cache (cache miss every time)
- For massive corpora, retrieve per-request snippets; cache the system prompt + retrieval template

The decision: is the doc the same across requests, or per-request?

---

## Verifying Cache Behavior

Always inspect the response usage:

```python
print(resp.usage.cache_creation_input_tokens)  # tokens written this request
print(resp.usage.cache_read_input_tokens)      # tokens served from cache
print(resp.usage.input_tokens)                 # uncached input tokens
```

Healthy cache behavior:

- First request after deploy: high cache_creation, low cache_read
- Subsequent requests: low cache_creation, high cache_read
- After TTL: another cache_creation event, then back to reads

If cache_read is consistently zero, your prefix is varying; investigate.

---

## Cache and Model Versions

Cache does not survive across model versions. When you upgrade Sonnet 4.5 -> Sonnet 4.6, the first batch of requests will rewrite caches. Plan for this.

---

## Cost / Quality Tradeoffs

Cache lets you afford bigger prompts that would otherwise be cost-prohibitive:

- More few-shot examples
- More detailed system instructions
- Larger reference docs

Use the cache budget to invest in prompt quality, not just to cut costs.

---

## Worked Example - Cache-Friendly Prompt

```python
system = [
    {
        "type": "text",
        "text": persona_and_global_constraints,  # 2000 tokens
        "cache_control": {"type": "ephemeral"},
    },
    {
        "type": "text",
        "text": load_examples_library(),  # 8000 tokens
        "cache_control": {"type": "ephemeral"},
    },
    {
        "type": "text",
        "text": load_product_docs(),  # 15000 tokens
        "cache_control": {"type": "ephemeral"},
    },
]

messages = [
    {
        "role": "user",
        "content": [
            {"type": "text", "text": f"Retrieved context:\n{retrieved_snippets}\n\nQuestion: {user_question}"},
        ],
    }
]
```

Three cache breakpoints. The 25K-token static prefix is cached once; subsequent requests within TTL pay only for the dynamic user message and retrieved snippets.

---

## Anti-Patterns

- Variables in the cached region
- One huge breakpoint when natural boundaries exist
- Caching dynamic per-request content (always misses)
- Forgetting that cache writes cost extra
- Not measuring cache hit rate
- Caching tiny prompts under the size threshold
- Assuming the cache survives across model versions
- Treating caching as automatic; it requires explicit `cache_control`

---

## Exam Focus

- Static-first, dynamic-last ordering
- Where `cache_control` belongs (on content blocks)
- Multiple breakpoints for layered stability
- Caching tools and few-shot example libraries
- TTL selection by traffic pattern
- Verifying via `usage.cache_*` fields
- Cache invalidation by any prefix change
