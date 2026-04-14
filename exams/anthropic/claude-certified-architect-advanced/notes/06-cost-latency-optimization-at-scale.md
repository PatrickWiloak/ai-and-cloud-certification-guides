# 06 - Cost, Latency, and Throughput Optimization at Scale

Optimizing a Claude workload is a craft. The Advanced tier expects you to wield prompt caching, the Batch API, model routing, streaming, parallel tool use, and extended thinking budgets as a cohesive toolkit - not as isolated tricks.

---

## The Cost Model

A Claude request costs:

- Input tokens (standard rate)
- Cache write tokens (higher rate, typically ~1.25x input)
- Cache read tokens (much lower rate, typically ~0.1x input)
- Output tokens (higher rate than input)
- Thinking tokens (billed as output)
- Tool execution time (your infrastructure, not Anthropic)

Every optimization moves tokens between these buckets or eliminates them.

---

## Prompt Caching

### Mechanics

Mark parts of the prompt as cacheable with `cache_control: {"type": "ephemeral"}`. On a cache hit, those tokens are served from Anthropic's cache at the cache-read rate. On a miss, they are written at the cache-write rate.

- TTL: 5 minutes (default, ephemeral) or 1 hour (extended)
- Cache is keyed by exact prefix match - one token different, one miss
- Up to 4 cache breakpoints per request
- Minimum cacheable content: 1024 tokens (2048 for Haiku)

### Where to Place Breakpoints

In order of cache-eligibility:

1. System prompt
2. Tool definitions
3. Stable reference documents / corpus
4. Few-shot examples
5. Conversation prefix (for multi-turn)

Place breakpoints at the end of each cache-eligible block so every reuse benefits.

### Break-Even Math

If cache write is 1.25x input rate and cache read is 0.1x input rate:

- Cost to write once: 1.25 * N input tokens
- Cost to read: 0.1 * N input tokens
- Without caching, N reads cost: 1.0 * N input tokens per read

Break-even occurs around 2 reads: (1.25 + 0.1 + 0.1) * N = 1.45N vs 3N uncached.

Rule of thumb: cache only what will be read 2+ times within TTL. For 1-hour cache, this threshold is usually easy to meet. For 5-minute, verify.

### Common Mistakes

- Caching volatile content (changes per request, never hits)
- Forgetting that any change invalidates downstream cache blocks
- Placing breakpoints too granularly (each breakpoint adds overhead)
- Caching tiny blocks below the 1024-token minimum

---

## Batch API

The Batch API runs jobs asynchronously at a 50% discount with a 24-hour SLA.

Limits:

- Up to 100K requests per batch
- Up to 256MB per batch
- Each request is a full Messages API request
- Results available via polling or webhook

### Ideal Use Cases

- Nightly data enrichment
- Backfills after a prompt or model change
- Bulk classification or tagging
- Eval runs over historical data
- Offline document redaction

### Poor Fits

- User-facing interactive paths (latency too high)
- Sub-hour SLA workloads
- Workloads where failure of a single item blocks others (batches are best-effort per item)

### Batch + Caching

Batch API requests can still use prompt caching if the prefix is stable across batch items. Huge compounding savings for bulk workloads.

---

## Model Routing

Different Claude tiers for different tasks:

| Model | Strength | Typical Role |
|---|---|---|
| claude-opus-4-6 | Deepest reasoning | Planner, final synthesizer, fallback on low-confidence |
| claude-sonnet-4-6 | Balanced workhorse | Main agent, coding, most tool use |
| claude-haiku-4-5 | Fast, cheap | Classification, triage, sub-agents, judges |

### Common Routing Patterns

- Triage: Haiku classifies request type, routes to the right pipeline
- Execute-then-escalate: Sonnet handles normal cases, escalates to Opus on flagged inputs (long, complex, ambiguous)
- Worker sub-agents: Haiku for each parallel worker, Sonnet for the orchestrator
- Judge-then-retry: Haiku judges Sonnet output; retry on Opus if judge fails

### Migrating Between Model Versions

When moving from Sonnet 4.5 to Sonnet 4.6:

1. Run your eval set on both. Compare quality, cost, latency.
2. Test on shadow traffic for a week if possible.
3. Watch for prompt-sensitivity changes - newer models may need prompt updates.
4. Roll out gradually; monitor quality metrics.
5. Hold the old model in reserve for rollback.

---

## Latency Optimization

### Streaming

Streaming does not reduce total latency, but reduces perceived latency. Use for every user-facing path.

Server-sent events deliver token-by-token. Combine with partial UI rendering.

### Extended Thinking Tradeoffs

Thinking improves quality but increases latency. Measure each budget level:

- 0 tokens: fastest, baseline quality
- 1K: small quality lift, minor latency
- 8K: larger quality lift, noticeable latency
- 32K: deep reasoning, significant latency

Pick the smallest budget that passes your quality bar.

### Parallel Tool Use

Dispatching 5 tools in parallel vs serial can cut tool latency 5x. Ensure your tool executors can run concurrently without resource contention.

### Regional Proximity

On Bedrock or Vertex, pick a region close to your users. Round-trip latency matters.

### Request Size

Large prompts take longer to process. Slim down:

- Drop stale history via compaction
- Retrieve tight context rather than loading corpora
- Remove tool definitions that this agent does not use

---

## Throughput Optimization

### Rate Limits

Per-tier limits on requests per minute and tokens per minute. Design for them:

- Per-tenant rate limits in your gateway (do not let one tenant starve others)
- Exponential backoff on 429
- Respect the `Retry-After` header
- Request rate limit tier increases well before you hit ceilings

### Connection Pooling and Keepalive

Reuse HTTP connections. The Anthropic SDKs do this by default; verify if you are making raw HTTP calls.

### Concurrency

The SDKs are thread-safe and async-friendly. Use async concurrency for fan-out patterns (orchestrator-worker, parallel tool calls).

---

## A Worked Optimization

Workload: user-facing coding assistant. Baseline:

- 40K system prompt (not cached)
- Sonnet 4.6 for all turns
- No streaming
- No thinking

Cost per conversation: $0.80. P95 latency: 9s.

Optimizations applied:

1. Cache system prompt + tool definitions (5-minute ephemeral)
2. Enable streaming
3. Enable thinking with 2K budget on the first turn only
4. Triage requests with Haiku; simple edits go to Haiku directly, complex refactors go to Sonnet
5. Prune tools from 22 to 14

Results:

- Cost per conversation: $0.22
- P95 latency: 4s (perceived, first-token)
- Quality delta: +2 points on eval set (thanks to small thinking budget)

Lesson: several small optimizations compound.

---

## Cost Audit Checklist

When asked to optimize a workload:

- [ ] Is prompt caching applied at the stable prefix? Hit rate > 80%?
- [ ] Is any cached content below the 1024-token minimum?
- [ ] Is the Batch API applicable for non-interactive portions?
- [ ] Are tool counts bounded? Any redundant tools?
- [ ] Is model tier appropriate for each step? Is Opus used where Sonnet suffices?
- [ ] Is extended thinking on where it should not be? Tuned where it should?
- [ ] Is the context window bloated with stale history?
- [ ] Are retries exponentially backed off?
- [ ] Are parallel tool calls used where independent?

---

## Advanced Exam Focus

- Prompt caching economics (break-even, TTLs, breakpoints)
- Batch API fit (50%, 24h, limits)
- Model routing decisions
- Streaming vs total latency
- Thinking budget ROI
- Parallel tool use impact
- Rate limit handling
