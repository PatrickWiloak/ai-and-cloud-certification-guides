# 01 - Claude API Fundamentals

The Claude API is a small surface with a lot of depth. This note covers the foundation: authentication, models, request shape, and the conceptual model behind the Messages API.

---

## Authentication

The first-party Anthropic API uses an API key:

```
x-api-key: sk-ant-...
anthropic-version: 2023-06-01
```

The `anthropic-version` header pins the API contract. Anthropic does not break old contracts; new behaviors land behind new versions or opt-in beta headers.

Beta features are gated by `anthropic-beta` headers, e.g.:

```
anthropic-beta: prompt-caching-2024-07-31
```

(Specific beta header strings change; check current docs.)

Bedrock and Vertex use IAM credentials and Google service accounts respectively, not the API key.

---

## Base URL

First-party API:

```
https://api.anthropic.com
```

The Messages endpoint is `POST /v1/messages`. SDKs default to this base URL.

---

## Models

Current generation IDs (2026):

| Model | Strength | When to Use |
|---|---|---|
| claude-opus-4-6 | Deepest reasoning | Hard planning, complex synthesis |
| claude-sonnet-4-6 | Balanced workhorse | Default for most apps |
| claude-haiku-4-5 | Speed, throughput, cost | Classification, routing, sub-agents |

Always parameterize the model ID in config; never hardcode in source. New versions ship regularly.

---

## Request Shape

Minimal valid request:

```json
{
  "model": "claude-sonnet-4-6",
  "max_tokens": 1024,
  "messages": [
    {"role": "user", "content": "Hello"}
  ]
}
```

Required fields:

- `model`
- `max_tokens` - the cap on response length, including thinking and text
- `messages` - alternating user / assistant turns

Optional fields:

- `system` - top-level system prompt; string or array of content blocks
- `temperature` - 0 to 1
- `top_p`, `top_k` - sampling alternatives to temperature
- `stop_sequences` - array of strings; response stops when emitted
- `stream` - boolean; SSE streaming
- `tools` and `tool_choice` - tool use config
- `thinking` - extended thinking config
- `metadata` - user_id for abuse tracking; do not put PII here

---

## The Roles

- `system` - top-level field, not a role in `messages`. Sets persona, constraints, formats.
- `user` - human input, including tool_result blocks.
- `assistant` - Claude's previous turns, including tool_use blocks.

The first message must be `user`. Roles must alternate. The last message in the array determines what Claude is responding to.

---

## Content Blocks

Each message has `content` that is either a string (shorthand for a single text block) or an array of typed content blocks:

- `text` - plain text
- `image` - base64-encoded or URL or file_id
- `document` - PDF or other document via base64, URL, or file_id
- `tool_use` - Claude's request to invoke a tool (in assistant messages)
- `tool_result` - your response to a tool_use (in user messages)
- `thinking` - Claude's internal reasoning (in assistant messages with extended thinking)

Mixing types in one message is normal: an assistant message often has a `thinking` block and a `tool_use` block.

---

## Response Shape

```json
{
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "model": "claude-sonnet-4-6",
  "content": [{"type": "text", "text": "Hi there"}],
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 12,
    "output_tokens": 5,
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 0
  }
}
```

The `content` array can contain multiple blocks. Always iterate; do not assume a single text block.

---

## Stop Reasons

- `end_turn` - natural completion
- `max_tokens` - hit the cap; response may be incomplete
- `stop_sequence` - hit a configured stop sequence
- `tool_use` - Claude wants you to execute a tool
- `pause_turn` - long response paused (rare; resume by continuing)
- `refusal` - model declined to respond

Treat `tool_use` as a state in your loop, not an error. Treat `refusal` as terminal - do not retry as if it were an error.

---

## Token Counting

Use the token counting endpoint to estimate request size before sending:

```
POST /v1/messages/count_tokens
```

Same body as Messages, returns `input_tokens`. Useful for context budgeting and rate limit planning.

---

## Temperature, Top-P, Top-K

- `temperature` 0 = most deterministic (still not byte-equal across runs); 1 = default; higher = more varied
- `top_p` (nucleus sampling) - alternative to temperature
- `top_k` - limit to top-K tokens per step

Use one. For most production apps, default temperature is fine. Lower for extraction tasks; higher for creative tasks.

---

## Idempotency

The Messages API is not natively idempotent at the API level. If you need at-most-once semantics, manage idempotency client-side: store a hash of the request and the response, and return the stored response on retries.

---

## Versioning Discipline

- Pin `anthropic-version` to a known value
- Pin model IDs in config, not source
- Document every beta header you depend on
- Track Anthropic release notes for changes

---

## Where to Go Next

- Note 02: Messages API and streaming in depth
- Note 03: Tool use lifecycle
- Note 04: Caching and batching
- Note 05: Files, citations, multimodal
- Note 06: Errors, rate limits, retries
- Note 07: SDKs

If you understand this note, you can call Claude. The rest is composition.
