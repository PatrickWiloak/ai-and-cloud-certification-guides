# CAD - 5-Week Practice Plan

Daily commitment: 1.5-2 hours weekdays, 3-4 hours one weekend day. Total: ~55 hours.

This plan is hands-on. Every week ends with code you can run.

---

## Week 1 - Messages API and Streaming

- [ ] Read `notes/01-claude-api-fundamentals.md` and `notes/02-messages-api-and-streaming.md`
- [ ] Set up `ANTHROPIC_API_KEY` in your environment
- [ ] Install Python SDK and TypeScript SDK
- [ ] Send a basic Messages request from both SDKs
- [ ] Inspect the response: content blocks, usage, stop_reason
- [ ] Implement streaming. Print tokens as they arrive.
- [ ] Catch and reassemble all SSE event types: message_start, content_block_start/delta/stop, message_delta, message_stop
- [ ] Handle a `pause_turn` scenario by logging it
- [ ] Write a 30-line CLI that takes a prompt and streams the response

Deliverable: a CLI that streams from Sonnet 4.6.

---

## Week 2 - Tool Use

- [ ] Read `notes/03-tool-use-function-calling.md`
- [ ] Define a single tool (e.g., `get_weather`) and call it via `auto` choice
- [ ] Walk through the tool_use / tool_result lifecycle by hand
- [ ] Implement parallel tool use: define two independent tools and confirm Claude calls both in one turn
- [ ] Use forced tool choice for structured JSON extraction
- [ ] Implement an agent loop that runs until `end_turn` with iteration cap
- [ ] Add a structured error response (`is_error: true`) and observe Claude recovering
- [ ] Try `tool_choice: any` and `tool_choice: {type: "tool", name: "X"}`

Deliverable: a tool-use agent with at least 3 tools, including one error path.

---

## Week 3 - Prompt Caching, Batch API, Files

- [ ] Read `notes/04-prompt-caching-and-batch-api.md` and `notes/05-files-api-citations-and-pdfs.md`
- [ ] Add `cache_control` to a 30K-token system prompt; verify `cache_creation_input_tokens` and `cache_read_input_tokens` in usage
- [ ] Compute cache ROI on a synthetic 100-request workload
- [ ] Try the 1-hour cache TTL where supported
- [ ] Submit a batch of 100 requests via the Batch API; poll until complete; retrieve results
- [ ] Handle per-item batch errors gracefully
- [ ] Upload a PDF via the Files API and reference it by file_id in two requests
- [ ] Enable citations on a multi-document RAG-style request and inspect the citation spans
- [ ] Add image input (base64) for a vision task

Deliverable: a small "doc Q&A" app with cached system prompt, PDF input, and citations.

---

## Week 4 - Error Handling, Rate Limits, Production Hardening

- [ ] Read `notes/06-error-handling-rate-limits-retries.md`
- [ ] Implement exponential backoff with jitter for 429, 500, 529
- [ ] Honor the `retry-after` header
- [ ] Inspect rate limit headers and add proactive throttling
- [ ] Add a circuit breaker after N consecutive failures
- [ ] Distinguish retryable from non-retryable errors
- [ ] Add structured logging: model, tokens, latency, stop_reason
- [ ] Add a metric for cache hit rate
- [ ] Simulate a rate limit by hammering with concurrent requests; observe behavior
- [ ] Stress-test your tool loop: max iterations, max tokens, max wall clock

Deliverable: a hardened API client with retries, circuit breaker, and observability.

---

## Week 5 - SDK Mastery, Review, Exam Prep

- [ ] Read `notes/07-sdks-python-typescript-and-cli.md`
- [ ] Compare Python sync, Python async, and TypeScript SDK ergonomics for the same feature
- [ ] Use the streaming helper APIs in both SDKs
- [ ] Try `AnthropicBedrock` and `AnthropicVertex` clients (use trial accounts if needed)
- [ ] Re-read all notes and the fact sheet
- [ ] Walk through every scenario in `scenarios.md` under timed conditions
- [ ] Re-read `strategy.md` the night before
- [ ] Verify current model IDs and exam logistics

Deliverable: ready to sit the exam.

---

## Hands-On Project Ideas (Pick One)

1. PDF Q&A bot: upload via Files API, cache system prompt, citations enabled, streaming UI.
2. Structured extractor: read invoices/contracts and force JSON output via tool choice.
3. Backfill enrichment job: 10K records via Batch API with cache, idempotent retries.
4. Customer support agent: 5-tool agent with parallel tool use, hardened retries, streaming.
5. Multimodal triage tool: classify uploaded images and surface a structured triage decision.

---

## Red Flags - Do Not Sit the Exam Yet If

- You cannot describe every SSE event type and its payload
- You have never used `cache_control` and verified the `usage` accounting
- You have never run a tool loop end to end
- You have never used the Batch API
- Your retry logic does not honor `retry-after`
- You confuse `tool_choice: any` with `tool_choice: {type: "tool", name: "X"}`
