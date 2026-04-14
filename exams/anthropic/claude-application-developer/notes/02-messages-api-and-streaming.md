# 02 - Messages API and Streaming

The Messages API is the core of Claude. Streaming is how you make Claude apps feel fast. This note covers both deeply.

---

## Messages Endpoint

`POST /v1/messages`

Synchronous when `stream: false`. Streaming when `stream: true`.

The Python SDK exposes both:

```python
client.messages.create(...)         # sync, returns full Message
client.messages.stream(...)         # streaming context manager
```

TypeScript:

```ts
client.messages.create({...});       // returns Message or stream
client.messages.stream({...});       // streaming helper
```

---

## Conversation State

Conversations are stateless on the server. Every request includes the full message history you want Claude to see. To maintain a conversation:

1. Append user message
2. Send request with full history
3. Append the returned assistant message
4. Repeat

This means context cost grows with conversation length. Use compaction or summarization for long conversations.

---

## System Prompts

The `system` field accepts either a string or an array of content blocks:

```python
client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system="You are a helpful assistant.",
    messages=[{"role": "user", "content": "Hi"}],
)
```

Array form enables `cache_control` per block:

```python
system=[
    {"type": "text", "text": "You are a code review assistant.", "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": project_specific_context},
]
```

---

## Multi-Turn Patterns

```python
history = []
while True:
    user = input("> ")
    history.append({"role": "user", "content": user})
    resp = client.messages.create(model="claude-sonnet-4-6", max_tokens=1024, messages=history)
    history.append({"role": "assistant", "content": resp.content})
    print(resp.content[0].text)
```

Always append Claude's full content array, not just the text. Tool use, thinking, and other blocks must persist for continuation.

---

## Streaming

Streaming uses Server-Sent Events. Each event is a JSON object on a `data:` line.

### Event Sequence

For a simple text response:

1. `message_start` - delivers the initial Message object with empty content
2. `content_block_start` - opens content block index 0 (type text)
3. `content_block_delta` (multiple) - each carries a `text_delta` with new text
4. `content_block_stop` - closes block 0
5. `message_delta` - reports cumulative `usage` and final `stop_reason`
6. `message_stop` - end of stream

For a tool_use response:

1. `message_start`
2. `content_block_start` - type `tool_use`, includes `id` and `name`
3. `content_block_delta` (multiple) - `input_json_delta` building up tool arguments
4. `content_block_stop`
5. `message_delta` (with `stop_reason: tool_use`)
6. `message_stop`

For a thinking response (extended thinking enabled):

- `content_block_start` of type `thinking`
- `content_block_delta` with `thinking_delta` for content
- `content_block_delta` with `signature_delta` for the verification signature
- `content_block_stop`

Then the regular text/tool_use blocks follow.

### Ping

The server may send `ping` events to keep the connection alive. Ignore in your handler.

### Errors During Streaming

If the server hits an error mid-stream, an `error` event is emitted. Handle it explicitly; do not assume `message_stop` always arrives.

---

## Streaming Helpers

The Python SDK:

```python
with client.messages.stream(model="claude-sonnet-4-6", max_tokens=1024, messages=[...]) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
    final = stream.get_final_message()
```

This abstracts SSE parsing. You receive only text deltas and can fetch the final assembled Message at the end.

For tool use, iterate over events directly:

```python
with client.messages.stream(...) as stream:
    for event in stream:
        if event.type == "content_block_start" and event.content_block.type == "tool_use":
            ...
```

TypeScript helper:

```ts
const stream = client.messages.stream({...});
stream.on("text", (delta, snapshot) => process.stdout.write(delta));
const finalMessage = await stream.finalMessage();
```

---

## Backpressure

Streaming consumers must read events promptly. If you stall, server-side buffers may eventually drop the connection. For UI rendering, decouple the network read loop from the render loop with a queue.

---

## Resuming and pause_turn

Long responses may emit `stop_reason: pause_turn`. To continue, send the message with the partial assistant response appended and request continuation. Most apps will not see this; design defensively if your prompts can produce very long outputs.

---

## Stop Sequences

Set `stop_sequences: ["</answer>"]` to halt generation when Claude emits the string. The response's `stop_reason` becomes `stop_sequence` and `stop_sequence` field reports which one matched.

---

## Max Tokens

Required. Sets the upper bound on output (text + thinking). Choose based on the task:

- Short replies: 256-512
- Mid-length answers: 1024-2048
- Long-form generation: 4096+
- Extended thinking enabled: budget_tokens + headroom for the visible response

If Claude hits `max_tokens`, the response may be truncated. Increase the cap or instruct Claude to be terse.

---

## Worked Example

```python
from anthropic import Anthropic

client = Anthropic()

with client.messages.stream(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system=[
        {
            "type": "text",
            "text": "You are a concise assistant.",
            "cache_control": {"type": "ephemeral"},
        }
    ],
    messages=[{"role": "user", "content": "Explain SSE in two sentences."}],
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
    final = stream.get_final_message()
    print()
    print(f"Tokens: in={final.usage.input_tokens} out={final.usage.output_tokens} cache_read={final.usage.cache_read_input_tokens}")
```

---

## Common Pitfalls

- Forgetting to consume the stream to completion (resource leak)
- Treating `stop_reason: tool_use` as an error
- Assuming a single text block in the response
- Putting the system prompt in `messages`
- Not preserving thinking blocks across continuations
- Hardcoding model IDs

---

## Exam Focus

- Event order and types
- Where the system prompt goes
- When to stream vs sync
- How `usage` is reported and updated through streaming
- The lifecycle of a tool_use response
