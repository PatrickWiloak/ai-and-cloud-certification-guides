# CAD - Exam Strategy

The Application Developer exam tests whether you can write correct Claude code, debug it, and make sound implementation choices. Many questions take the form of a code snippet plus "what is wrong?" or "what completes this?". Time pressure is real but manageable if you can read fluently in Python or TypeScript.

---

## 3-Phase Preparation

### Phase 1 - Build Fluency (Weeks 1-2)

Write code with the API daily. Use both Python and TypeScript SDKs at least once. Trace every byte of streaming events. Run a tool loop by hand without the SDK helpers so you understand what they do for you.

### Phase 2 - Production Patterns (Weeks 3-4)

Layer in caching, batches, files, retries, and error handling. Build something you would not be embarrassed to deploy. Feel each rate limit, each cache hit, each refused request.

### Phase 3 - Drill (Week 5)

Run timed scenarios. Re-read the fact sheet. Sleep before the exam.

---

## Time Management

Assume 65 questions in 120 minutes. About 1m 50s per question with a small buffer.

| Time Elapsed | Question # |
|---|---|
| 30 min | 17 |
| 60 min | 33 |
| 90 min | 49 |
| 110 min | 65 (done, review) |

First pass: answer fast, flag the slow ones. Second pass: spend the buffer on flags. Third pass: review only with concrete reasons to change.

---

## Reading Code Snippets Fast

Train yourself to scan for these markers:

- `messages.create` vs `messages.stream` vs `messages.batches.create` - tells you the API surface
- `tool_choice` value - tells you if the question is about forced output
- `cache_control` placement - tells you the question is about caching
- `tool_result` in user message - tells you the question is about the tool loop
- `system` field vs `messages` array - tells you if the snippet has a system prompt mistake

Most questions hinge on a single line. Find it, then read the rest only if needed.

---

## Common Code Bugs to Spot

1. System prompt placed as a user message
2. `tool_result` placed in the assistant message instead of user
3. Missing `max_tokens`
4. `cache_control` on the request instead of a content block
5. Stream not consumed to completion
6. Hardcoded API key in source
7. 400 errors retried in a backoff loop
8. Tool result that omits the `tool_use_id`
9. Forced tool choice combined with `tools: []`
10. Image content with the wrong `media_type`

---

## Answer Selection Heuristics

- Prefer SDK helpers (e.g., `messages.stream`) over manual SSE parsing when both work.
- Prefer Anthropic's documented patterns over clever workarounds.
- Prefer correct error categorization (retryable vs not) over universal retry.
- For structured output, prefer `tool_choice: {type: "tool", name: ...}` over prompting Claude to "respond in JSON."
- For RAG with attribution, prefer the citations feature over post-hoc parsing.
- For bulk async work, prefer the Batch API over your own queue.
- For PDF input, prefer the Files API or `document` content block over OCR.

---

## Domain-Specific Tactics

### Messages API and Streaming

Trace event order by heart: `message_start` -> per content block (`content_block_start` -> deltas -> `content_block_stop`) -> `message_delta` -> `message_stop`.

### Tool Use

`tool_use` in assistant message; `tool_result` in user message. Always include `tool_use_id`. `is_error: true` for failures.

### Caching

Cache writes more expensive, reads much cheaper. Break-even ~2 reads. Min 1024 tokens (2048 Haiku). 4 breakpoints max. TTL 5 minutes default, 1 hour extended.

### Batch API

50% discount, 24h SLA, 100K requests / 256MB max. Per-item success or failure. Async.

### Files and Citations

Upload once, reference by file_id. Citations require `citations: {enabled: true}` on document blocks.

### Errors and Retries

Honor `retry-after`. Backoff with jitter. Retry 429, 500, 529, network. Do not retry 400, 401, 403, 404.

### SDKs

`Anthropic` for first-party, `AnthropicBedrock` for AWS, `AnthropicVertex` for GCP. Async clients are `Async*`. Streaming helpers exist - prefer them.

---

## The 24 Hours Before

- Re-read fact sheet
- Re-read this strategy
- Run one of your own Claude apps end to end as muscle memory
- Sleep
- Have ID and stable internet ready

---

## During the Exam

- Read the entire question; the constraint is often in the last sentence
- Skim the code; find the diff vs idiomatic
- Eliminate two answers fast
- Choose the most documented pattern between the remaining

---

## If You Fail

Score reports tell you the weakest domain. Spend two weeks rebuilding that domain only. Re-sit. Failing once is normal at the edge of competence.
