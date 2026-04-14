# 07 - SDKs: Python, TypeScript, and CLI

Anthropic ships first-party SDKs for Python and TypeScript and a CLI for quick experimentation. The exam expects fluency in idiomatic SDK usage, including streaming helpers, async clients, and the Bedrock / Vertex sub-clients.

---

## Python SDK

Install:

```
pip install anthropic
```

### Sync Client

```python
from anthropic import Anthropic

client = Anthropic()  # reads ANTHROPIC_API_KEY from env
msg = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hi"}],
)
print(msg.content[0].text)
```

### Async Client

```python
from anthropic import AsyncAnthropic
import asyncio

aclient = AsyncAnthropic()

async def main():
    msg = await aclient.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=1024,
        messages=[{"role": "user", "content": "Hi"}],
    )
    print(msg.content[0].text)

asyncio.run(main())
```

Use async for fan-out (parallel requests, agent workers).

### Streaming Helpers

```python
with client.messages.stream(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Tell me a story"}],
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
    final = stream.get_final_message()
```

Async streaming:

```python
async with aclient.messages.stream(...) as stream:
    async for text in stream.text_stream:
        print(text, end="", flush=True)
```

For tool_use streaming, iterate over events directly via `for event in stream:`.

### Configuration Options

```python
client = Anthropic(
    api_key="...",          # or env
    base_url="...",         # for proxies
    timeout=30.0,
    max_retries=2,          # SDK-level retries
    default_headers={...},
)
```

### Per-Request Options

```python
client.with_options(timeout=60.0, max_retries=0).messages.create(...)
```

### Error Types

```python
from anthropic import (
    APIError, APIConnectionError, APITimeoutError,
    BadRequestError, AuthenticationError, PermissionDeniedError,
    NotFoundError, RateLimitError, InternalServerError,
)
```

### Bedrock Client

```python
from anthropic import AnthropicBedrock

client = AnthropicBedrock(
    aws_region="us-east-1",
    # AWS credentials via env, profile, or IAM role
)
msg = client.messages.create(
    model="anthropic.claude-sonnet-4-6-YYYYMMDD-v1:0",
    max_tokens=1024,
    messages=[...],
)
```

### Vertex Client

```python
from anthropic import AnthropicVertex

client = AnthropicVertex(region="us-east5", project_id="my-gcp-project")
msg = client.messages.create(
    model="claude-sonnet-4-6@YYYYMMDD",
    max_tokens=1024,
    messages=[...],
)
```

The Messages interface is identical across all three clients.

---

## TypeScript SDK

Install:

```
npm install @anthropic-ai/sdk
```

### Basic Usage

```ts
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic();  // reads ANTHROPIC_API_KEY

const msg = await client.messages.create({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Hi" }],
});

console.log(msg.content[0]);
```

### Streaming

```ts
const stream = client.messages.stream({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Tell me a story" }],
});

stream.on("text", (delta) => process.stdout.write(delta));

const final = await stream.finalMessage();
```

Or async iteration:

```ts
for await (const event of stream) {
  if (event.type === "content_block_delta") { ... }
}
```

### Configuration

```ts
const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: "...",
  timeout: 30_000,
  maxRetries: 2,
});
```

### Error Handling

```ts
import { APIError, RateLimitError } from "@anthropic-ai/sdk";

try {
  await client.messages.create({...});
} catch (err) {
  if (err instanceof RateLimitError) { ... }
  else if (err instanceof APIError) { ... }
  else throw err;
}
```

### Bedrock and Vertex (TS)

```ts
import { AnthropicBedrock } from "@anthropic-ai/bedrock-sdk";
import { AnthropicVertex } from "@anthropic-ai/vertex-sdk";

const bedrock = new AnthropicBedrock({ awsRegion: "us-east-1" });
const vertex = new AnthropicVertex({ region: "us-east5", projectId: "..." });
```

(Package names may vary; check current docs.)

---

## CLI Tools

The Python SDK does not ship a one-line `anthropic` CLI by default, but `claude-agent-sdk` and Claude Code provide CLI surfaces. For ad-hoc API testing, use `curl`:

```
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model": "claude-sonnet-4-6", "max_tokens": 256, "messages": [{"role": "user", "content": "Hi"}]}'
```

For developer workflows, Claude Code is the official CLI agent.

---

## Idiomatic Patterns

### Reuse the Client

Construct one client per process and reuse it. Connection pooling, retries, and headers are stable across calls.

### Type Safety

Both SDKs ship full typings. In Python, the response objects are dataclass-like; access fields by attribute. In TypeScript, types flow from the imports.

### Pagination

Some endpoints (Files list, Batches list) return paginated results. The SDKs expose iterators:

```python
for f in client.files.list():
    print(f.id)
```

### Webhook Verification

If you receive Anthropic webhooks (e.g., for batch completion), verify signatures per docs. The SDKs may expose helpers.

### Test Doubles

For tests, mock the client at the boundary. Avoid mocking inside the SDK. Use replay fixtures for streaming behavior.

---

## Cross-SDK Choice

| Concern | Choose Python | Choose TypeScript |
|---|---|---|
| Backend services | Often Python | Often Node/TS |
| Frontend integration | Rare | Yes (server-side or BFF) |
| Data science workflows | Python | Rare |
| Edge runtimes | Limited | Yes (Cloudflare Workers, Vercel) |
| Async ergonomics | asyncio | Native Promise / await |

Both SDKs cover the same Messages surface. Pick by ecosystem.

---

## SDK Versioning

The SDKs add features as Anthropic ships them. Stay reasonably current; old SDK versions may not expose new features (memory tool, citations, code execution). Pin a known-good minor version in your manifest, upgrade deliberately.

---

## Common Pitfalls

- Constructing a new client per request (defeats connection pooling)
- Catching all exceptions broadly
- Mocking too deep into the SDK
- Hardcoding model IDs in source
- Mixing Bedrock model IDs with first-party model IDs
- Leaving streams unconsumed

---

## Exam Focus

- Which client class to use for first-party / Bedrock / Vertex
- Streaming helpers and how to assemble final messages
- Async vs sync client choice
- Error class hierarchy
- Per-request option overrides
- Idiomatic agent loop construction with the SDK
