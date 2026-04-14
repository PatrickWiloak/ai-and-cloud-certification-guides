# CAD - Exam Scenarios

Ten scenario-based questions at the difficulty expected for the Application Developer exam. Time yourself at 2 minutes per question.

---

## Scenario 1 - System Prompt Placement

A developer writes:

```python
client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello"},
    ],
)
```

What is wrong?

A. Nothing - this is correct.
B. The `messages` array does not support a `system` role; pass it via the top-level `system` parameter.
C. `max_tokens` should be omitted.
D. The model ID is wrong.

**Answer: B.** The Messages API takes the system prompt via the top-level `system` field, not as a message. The Python SDK will raise an error here.

---

## Scenario 2 - Tool Result Placement

After receiving a response with `stop_reason: tool_use`, you want to send the tool's output back. Which is correct?

A. Append an assistant message with a `tool_result` content block.
B. Append a user message with a `tool_result` content block referencing the `tool_use_id`.
C. Append a system message with the tool output as text.
D. Call `client.tools.submit_result()`.

**Answer: B.** Tool results are sent in a user-role message containing one or more `tool_result` content blocks, each referencing its `tool_use_id`. There is no dedicated SDK method.

---

## Scenario 3 - Cache Breakpoint

You want to cache a 30K-token system prompt. Where do you put `cache_control`?

A. On the top-level request body.
B. On the last content block of the system prompt array.
C. On every user message.
D. On the model parameter.

**Answer: B.** `cache_control` is set on individual content blocks. Place it on the final block of the cache-eligible region (typically the last system content block) so the entire prefix becomes the cache key.

---

## Scenario 4 - Forced Structured Output

You need Claude to return JSON matching a strict schema. Which is most reliable?

A. Tell Claude in the system prompt to respond in JSON.
B. Define a tool whose `input_schema` is the desired JSON shape and set `tool_choice` to that tool.
C. Use a regex parser on free-text output.
D. Set temperature to 0.

**Answer: B.** Forcing tool choice with a schema tool is the reliable way to extract structured JSON. Claude must call the tool, and the `input` is your structured object.

---

## Scenario 5 - Batch API Fit

You need to enrich 50,000 records with summaries within 24 hours. Cost is tight, latency is not. What do you choose?

A. Real-time Messages API with high concurrency.
B. Batch API with prompt caching on the static system prompt.
C. Streaming requests fired in parallel.
D. The Files API.

**Answer: B.** Batch API is half price with a 24-hour SLA. Caching the static prompt compounds savings.

---

## Scenario 6 - Retry on 400

Your retry library treats every non-2xx response as retryable. You see slow responses and increased costs. Which response codes should you NOT retry?

A. 400, 401, 403, 404
B. 429, 500, 529
C. Only 500
D. None - always retry

**Answer: A.** 4xx client errors (other than 429) indicate problems with your request that retries will not fix. 429, 500, 529 are retryable with backoff.

---

## Scenario 7 - Streaming Event Order

In a streaming response with one text block, what is the correct event order?

A. message_start, message_delta, message_stop
B. message_start, content_block_start, content_block_delta..., content_block_stop, message_delta, message_stop
C. content_block_start, content_block_delta..., content_block_stop, message_stop
D. message_start, text_delta..., message_stop

**Answer: B.** Streaming wraps each content block with start/delta/stop and the overall message with `message_start`, a final `message_delta` for usage updates, and `message_stop`.

---

## Scenario 8 - Cache TTL

Your workload sees 5-10 requests within the same minute that share a 20K-token prefix, then nothing for hours. Which caching choice is best?

A. No caching - the prefix changes too often.
B. 5-minute ephemeral cache.
C. 1-hour extended cache.
D. Permanent cache.

**Answer: B.** The traffic clusters within minutes, so the 5-minute TTL captures the hits. The 1-hour tier costs more on writes and offers no extra hits given the traffic pattern. There is no permanent cache option.

---

## Scenario 9 - Bedrock Client

Your team must run on AWS with IAM auth. Which client do you use?

A. `Anthropic()` with the API key set via env var.
B. `AnthropicBedrock()` configured with AWS credentials.
C. `boto3.client("bedrock")` directly.
D. `AnthropicVertex()`.

**Answer: B.** The Anthropic SDK ships an `AnthropicBedrock` client that handles IAM auth and Bedrock-specific request shaping while keeping the same Messages interface.

---

## Scenario 10 - Citations

You build a RAG application that must show users which document each claim came from. Which approach?

A. Prompt Claude to add `[source]` markers at the end.
B. Use the citations feature: pass documents as `document` content blocks with `citations: {enabled: true}`, then render the citation spans returned in the response.
C. Have Claude return JSON with a `sources` array.
D. Post-process with a separate Claude call that infers sources.

**Answer: B.** The native citations feature returns structured citation spans tied to specific source segments. It is more reliable than asking Claude to fabricate source markers.
