# 04 - Prompt Caching and Batch API

Two of Anthropic's biggest cost levers. Both reward developers who understand the mechanics deeply.

---

## Prompt Caching

Prompt caching lets Anthropic store a prefix of your request server-side and replay it cheaply on subsequent requests with the same prefix.

### Mechanics

Mark a content block with `cache_control: {"type": "ephemeral"}` to declare it (and everything before it in the prompt) as a cache breakpoint:

```python
system=[
    {
        "type": "text",
        "text": large_static_instructions,
        "cache_control": {"type": "ephemeral"},
    }
]
```

On the first call: cache write. Anthropic stores the prefix and bills cache write tokens.

On subsequent calls with byte-identical prefix: cache read. Tokens are served from cache at the cache read rate.

### Pricing

Approximate multipliers vs base input rate:

- Cache write: ~1.25x
- Cache read: ~0.1x

Exact numbers vary by model; check current pricing.

### TTL

- Default ephemeral: 5 minutes
- Extended: 1 hour (`cache_control: {"type": "ephemeral", "ttl": "1h"}` where supported)

A successful read refreshes the TTL.

### Minimum Cacheable Size

- Most models: 1024 tokens
- Haiku: 2048 tokens

Below the threshold, caching has no effect.

### Breakpoints

Up to 4 cache breakpoints per request. Each breakpoint marks the end of a cacheable region; everything from the start of the prompt to that point becomes the cache key.

Layered example:

```python
system=[
    {"type": "text", "text": stable_system_prompt, "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": product_specific_docs, "cache_control": {"type": "ephemeral"}},
]
```

Two breakpoints. The first protects against a different `product_specific_docs` invalidating the system-prompt cache.

### Cache Eligibility

In order, from highest cache value to lowest:

1. System prompt
2. Tool definitions (cache via the tools array)
3. Stable reference docs in messages
4. Few-shot examples
5. Conversation prefix in long sessions

Volatile content (current user message, dynamic retrieval results) should not be cached.

### Reading Usage

The response `usage` reports:

- `input_tokens` - non-cached input tokens
- `cache_creation_input_tokens` - tokens written to cache this request
- `cache_read_input_tokens` - tokens served from cache this request
- `output_tokens` - response tokens (including thinking)

Sum these for true total billable input.

### Break-Even Math

If write is 1.25x and read is 0.1x:

- Without caching: N reads cost N base
- With caching: 1 write + N reads cost 1.25 + 0.1N

Break-even at ~1.4 reads. Practically, cache anything you will reuse 2+ times within the TTL.

### Common Mistakes

- Caching unstable content (cache miss every request, wasted writes)
- Caching content under the size threshold (no effect)
- Forgetting that any change to a cached block invalidates everything after it
- Not measuring cache hit rate
- Assuming cache survives across model versions (it does not)

---

## Batch API

The Batch API runs jobs asynchronously at half the price.

### Specs

- 50% discount vs real-time
- Within 24 hours SLA (often much faster)
- Up to 100,000 requests per batch
- Up to 256 MB per batch
- Each request is a full Messages API request

### Workflow

1. Create batch:

```python
batch = client.messages.batches.create(
    requests=[
        {
            "custom_id": "request-1",
            "params": {
                "model": "claude-sonnet-4-6",
                "max_tokens": 1024,
                "messages": [{"role": "user", "content": "Summarize: ..."}],
            },
        },
        ...
    ]
)
```

2. Poll status:

```python
batch = client.messages.batches.retrieve(batch.id)
print(batch.processing_status)  # in_progress | canceling | ended
```

3. Retrieve results when ended:

```python
for result in client.messages.batches.results(batch.id):
    if result.result.type == "succeeded":
        print(result.custom_id, result.result.message.content)
    elif result.result.type == "errored":
        print(result.custom_id, result.result.error)
```

### Per-Item Status

Each batch item ends with one of:

- `succeeded` - response available
- `errored` - per-item error (validation, rate, etc.)
- `expired` - the batch hit its expiration
- `canceled` - batch canceled before processing

Failures are independent. One bad item does not poison the batch.

### Custom IDs

`custom_id` is your correlation key. Use to map results back to your records.

### Combining With Caching

Cached blocks within batch requests still get cache reads when the prefix matches across batch items. For a 100K-record batch with a stable system prompt, you write the cache once and read it 100K times for huge savings.

### Webhook vs Polling

Some accounts have webhook delivery for batch completion. Polling works universally. Choose based on your infrastructure.

### Ideal Use Cases

- Backfill enrichment after a prompt change
- Nightly classification or tagging jobs
- Eval runs over historical data
- Bulk redaction or transformation

### Poor Fits

- User-facing interactive flows
- Workloads needing sub-hour SLA
- Workloads where partial completion is unacceptable

---

## Cost Audit Pattern

For any Claude workload:

1. Measure cache hit rate over 1000 requests
2. Compute average cached read tokens, write tokens, regular input tokens, output tokens per request
3. Multiply by current pricing to get average request cost
4. Compare with theoretical cost if caching were perfect, and if Batch API were used

Often a 5-line config change moves you 50%+.

---

## Exam Focus

- Where `cache_control` goes (on content blocks)
- The TTLs (5 min default, 1 hour extended)
- Min cacheable size (1024, 2048 for Haiku)
- Break-even read count
- Batch API discount (50%) and SLA (24h)
- Batch result correlation via `custom_id`
- Per-item batch result statuses
