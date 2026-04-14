# CAD - Fact Sheet

## Quick Reference (Preliminary)

| Detail | Info |
|---|---|
| Exam Code | CAD |
| Full Name | Claude Application Developer |
| Provider | Anthropic |
| Duration | 120 minutes (estimate) |
| Questions | 60-70 (estimate) |
| Passing Score | ~720 / 1000 (estimate) |
| Cost | TBD |
| Delivery | Online proctored |
| Validity | 2 years |

---

## Domain Weights (Preliminary)

| Domain | Weight | Focus |
|---|---|---|
| 1. Messages API and Streaming | 22% | Request/response, SSE events |
| 2. Tool Use | 20% | Tool calls, parallel, choice modes |
| 3. Prompt Caching and Batch API | 16% | Cache, batches |
| 4. Files, Citations, Multimodal | 14% | PDFs, images, citations |
| 5. Error Handling, Rate Limits | 14% | 429, retries, idempotency |
| 6. SDKs | 14% | Python, TypeScript, CLI |

---

## Models (2026)

| Model | ID | Use |
|---|---|---|
| Opus | claude-opus-4-6 | Deep reasoning |
| Sonnet | claude-sonnet-4-6 | Workhorse |
| Haiku | claude-haiku-4-5 | Throughput, classification |

---

## Authentication

- Header: `x-api-key: <key>`
- Header: `anthropic-version: 2023-06-01`
- Beta features: `anthropic-beta: <feature>`

Bedrock and Vertex use IAM and service accounts respectively, not the API key.

---

## Messages API Essentials

### Request Shape (Minimal)

```json
{
  "model": "claude-sonnet-4-6",
  "max_tokens": 1024,
  "messages": [
    {"role": "user", "content": "Hello"}
  ]
}
```

### Required Fields

- `model`
- `max_tokens`
- `messages`

### Optional Fields

- `system` - system prompt (string or array of content blocks)
- `temperature` - 0 to 1
- `top_p`, `top_k`
- `stop_sequences`
- `stream` - boolean
- `tools`, `tool_choice`
- `thinking` - extended thinking config
- `metadata` - user_id for abuse tracking

### Response Shape

```json
{
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "model": "claude-sonnet-4-6",
  "content": [{"type": "text", "text": "..."}],
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 12,
    "output_tokens": 30,
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 0
  }
}
```

### Stop Reasons

- `end_turn` - natural completion
- `max_tokens` - hit max_tokens cap
- `stop_sequence` - hit a stop_sequence
- `tool_use` - Claude wants to call a tool
- `pause_turn` - long-running response paused (rare)
- `refusal` - model declined to respond

---

## Content Block Types

- text
- image (base64 or URL)
- document (PDF, base64 or file_id)
- tool_use (Claude's request to call a tool)
- tool_result (your response to a tool_use)
- thinking (Claude's internal reasoning)

---

## Streaming Events

In order:

1. `message_start` - message metadata
2. For each content block:
   - `content_block_start`
   - `content_block_delta` (one or more)
   - `content_block_stop`
3. `message_delta` - usage and stop_reason updates
4. `message_stop` - end of stream

Delta types:

- `text_delta` - text increments
- `input_json_delta` - tool_use input building
- `thinking_delta` - thinking content
- `signature_delta` - thinking signature

Also: `ping` events for keepalive.

---

## Tool Use Lifecycle

1. Define tools in the request: `tools: [{name, description, input_schema}]`
2. Set `tool_choice`: `auto` (default), `any`, `{type: "tool", name: "..."}`, or `none`
3. Claude responds with `stop_reason: tool_use` and one or more `tool_use` blocks
4. Execute the tool(s) in your code
5. Send a new message with role `user` and a `tool_result` content block per tool_use
6. Continue the loop until `stop_reason: end_turn`

### Forced Structured Output

To guarantee JSON matching a schema:

```python
tools = [{
    "name": "extract_invoice",
    "description": "Extract structured invoice fields.",
    "input_schema": {...JSON schema...}
}]
tool_choice = {"type": "tool", "name": "extract_invoice"}
```

The tool's `input` will be the structured output.

---

## Prompt Caching

- Mark blocks with `cache_control: {"type": "ephemeral"}`
- Default TTL: 5 minutes
- 1-hour TTL: `cache_control: {"type": "ephemeral", "ttl": "1h"}` (where supported)
- Up to 4 cache breakpoints per request
- Minimum cacheable: 1024 tokens (2048 for Haiku)
- Cache writes ~1.25x input rate
- Cache reads ~0.1x input rate
- `usage.cache_creation_input_tokens` and `usage.cache_read_input_tokens` report per request

### What to Cache (in order)

1. System prompt
2. Tool definitions
3. Stable reference docs
4. Few-shot examples
5. Conversation prefix

---

## Batch API

| Aspect | Value |
|---|---|
| Discount | 50% off real-time |
| SLA | Within 24 hours |
| Max requests per batch | 100,000 |
| Max batch size | 256 MB |

### Workflow

1. Submit batch: `POST /v1/messages/batches` with array of requests
2. Poll: `GET /v1/messages/batches/{id}` for status
3. Retrieve: `GET /v1/messages/batches/{id}/results` (JSONL stream)
4. Each item succeeds or fails independently

### Batch Statuses

- in_progress
- canceling
- ended

Per-item results: `succeeded`, `errored`, `expired`, `canceled`.

---

## Files API

- Upload: `POST /v1/files` (multipart)
- Reference by `file_id` in subsequent messages
- Supported types: PDF, images, plain text, JSON, more
- File size limits and storage TTL per docs
- Use to avoid re-uploading the same artifact across requests

---

## Citations

Enables Claude to cite specific spans of input documents in its response. Wrap source documents in `document` content blocks with `citations: {enabled: true}`. Claude returns `citations` arrays alongside text spans.

Use cases:

- Grounded RAG with source attribution
- Compliance use cases requiring traceability
- UI rendering of "sources" beneath generated answers

---

## Vision and PDF

### Images

```json
{"type": "image", "source": {"type": "base64", "media_type": "image/png", "data": "..."}}
```

Or by URL or `file_id`.

### PDFs

```json
{"type": "document", "source": {"type": "base64", "media_type": "application/pdf", "data": "..."}}
```

Or by URL or `file_id`. Claude reads text and visual layout.

---

## Error Codes

| Code | Meaning | Action |
|---|---|---|
| 400 | invalid_request_error | Fix request |
| 401 | authentication_error | Check API key |
| 403 | permission_error | Check permissions |
| 404 | not_found_error | Check ID/endpoint |
| 413 | request_too_large | Trim payload |
| 429 | rate_limit_error | Retry with backoff per Retry-After |
| 500 | api_error | Retry with backoff |
| 529 | overloaded_error | Retry with backoff |

### Rate Limit Headers

- `anthropic-ratelimit-requests-limit`
- `anthropic-ratelimit-requests-remaining`
- `anthropic-ratelimit-requests-reset`
- `anthropic-ratelimit-tokens-limit`
- `anthropic-ratelimit-tokens-remaining`
- `anthropic-ratelimit-tokens-reset`
- `retry-after` on 429 / 529

---

## Retry Patterns

- Exponential backoff with jitter
- Cap retries (3-5)
- Honor `retry-after` when present
- Distinguish retryable (429, 500, 529, network) from non-retryable (400, 401, 403, 404)

---

## SDK Highlights

### Python

```python
from anthropic import Anthropic
client = Anthropic()  # reads ANTHROPIC_API_KEY
msg = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hi"}],
)
```

Async: `from anthropic import AsyncAnthropic`.

Streaming helper:

```python
with client.messages.stream(...) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
final = stream.get_final_message()
```

Bedrock: `from anthropic import AnthropicBedrock`.
Vertex: `from anthropic import AnthropicVertex`.

### TypeScript

```ts
import Anthropic from "@anthropic-ai/sdk";
const client = new Anthropic();
const msg = await client.messages.create({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Hi" }],
});
```

Streaming:

```ts
const stream = client.messages.stream({...});
for await (const event of stream) { ... }
const final = await stream.finalMessage();
```

---

## High-Yield Exam Tips

1. `max_tokens` is required.
2. System prompts go in the `system` field, not as a message.
3. `stop_reason: tool_use` requires you to send `tool_result` next, not a regular user message.
4. Tool results go in a `user` role message with `tool_result` content blocks.
5. `cache_control` belongs on individual content blocks, not on the request.
6. Cache writes cost more; cache reads cost much less; break-even ~2 reads.
7. Batch API is async; poll or use webhooks.
8. The Retry-After header overrides your default backoff.
9. The SDK is thread-safe; reuse the client.
10. Bedrock and Vertex have separate SDK clients but the same Messages interface.

---

## Common Traps

1. Putting the system prompt as a user message (use `system` field).
2. Forgetting to send tool_result and instead sending a fresh user message.
3. Caching content that changes per request.
4. Missing `cache_creation_input_tokens` accounting in cost reports.
5. Treating Batch results as in-order; they are not.
6. Retrying 400 errors blindly.
7. Hardcoding model IDs without env config.
8. Ignoring `pause_turn` stop reason on long responses.
9. Confusing `tool_choice: any` with `tool_choice: {type: "tool", name: ...}`.
10. Streaming without consuming events to completion (resource leak).
