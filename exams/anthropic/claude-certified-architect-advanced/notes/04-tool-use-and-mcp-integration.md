# 04 - Tool Use and MCP Integration

Tool use is how Claude acts in the world. The Advanced tier expects fluency across three layers: tool design (names, schemas, descriptions), first-party tools (code execution, computer use, web search, memory, text editor, bash), and MCP for ecosystem integration.

---

## Tool Definition Anatomy

A tool definition has three parts:

- name - machine identifier, verb-noun convention (`search_orders`, `get_customer_profile`)
- description - the prompt Claude reads to decide when and how to use the tool
- input_schema - JSON Schema specifying parameters

Descriptions are prompts. Treat them with the same care as the system prompt. A good description:

- States what the tool does in one sentence
- Clarifies when to use it vs alternatives
- Documents parameter semantics, not just types
- Includes an example invocation when parameters are non-obvious
- Warns about side effects and failure modes

Bad description:

```
"Gets order info."
```

Good description:

```
"Look up the full order record for a given order ID. Use this when the user asks
about specific order status, line items, or shipping. Returns null if the order
does not exist. Does not modify data. Prefer search_orders when the user gives
a customer name but not an ID."
```

---

## Tool Choice Modes

- `auto` (default) - Claude decides whether to use a tool
- `any` - Claude must use one of the provided tools
- `tool` with a specific name - Claude must use that exact tool
- `none` - Claude cannot use any tools

Forced tool choice (`any` or `tool`) is the cleanest way to guarantee structured output: define a single tool whose schema matches your desired JSON shape, then force the call.

---

## Parallel Tool Use

Supported by default on modern Claude models. Claude may emit multiple `tool_use` blocks in a single response. Your agent loop must dispatch all of them and return all `tool_result` blocks before the next turn.

Parallel tool use dramatically reduces latency when sub-tasks are independent. Common uses:

- Fetching multiple documents simultaneously
- Calling multiple APIs whose results will be synthesized
- Verifying a claim against multiple sources at once

Guard against unintended parallelism on non-idempotent actions (e.g., creating multiple records). Mark such tools with explicit warnings in descriptions.

---

## Tool Sprawl

As agents grow, tool counts balloon. Tool-selection accuracy degrades with sprawl. Heuristics:

- Aim for under 20 tools per agent
- Merge overlapping tools (one `search` tool with a `source` parameter beats three source-specific tools)
- Introduce a dispatcher tool for long tails (`call_internal_api(endpoint, body)` with allowlist)
- Split into subagents if a logical cluster of tools only applies to a sub-task

Evidence that you have sprawl: Claude frequently calls the wrong tool, or fails to call any tool when it should.

---

## Error Handling in Tools

Return structured errors. The canonical shape in the Messages API is `tool_result` with `is_error: true`:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_...",
  "content": "Order 12345 not found. Available IDs start with 10000.",
  "is_error": true
}
```

Include enough context for Claude to recover. Vague errors ("failed") cause Claude to retry blindly. Informative errors let Claude reason.

---

## First-Party Tools

Anthropic provides several tools directly via the API. These typically outperform roll-your-own equivalents.

### code_execution

Sandboxed Python runtime. Claude writes and runs code to compute answers, parse data, or call APIs allowed by the sandbox. Ideal for:

- Data analysis on user-provided CSVs or tables
- Arithmetic that LLMs historically botch
- Transforming text with library support

### computer_use

Mouse, keyboard, and screenshot primitives so Claude can drive a GUI. Useful for legacy apps without APIs. Has higher safety considerations - treat outputs as untrusted and guard against prompt injection via on-screen content.

### bash

Execute shell commands. Foundational for Claude Code and coding agents. Always pair with an allowlist and a permissions model.

### text_editor

File editing primitive with `view`, `create`, `str_replace`, and `insert` operations. Preferred over asking Claude to output full files - it edits deterministically.

### web_search

Anthropic-hosted search, returns web results and snippets. Simpler than wiring your own search provider. Rate-limited; check current tiers.

### web_fetch

Fetch a URL and return content. Handles redirects, basic rendering. Combine with web_search for research agents.

### memory

Durable client-side memory. See note 03.

### files

The Files API lets you upload files once and reference them by ID in multiple requests, avoiding re-uploading. Pairs well with PDFs, large contexts, and multimodal workloads.

---

## MCP - Model Context Protocol

MCP is an open protocol for connecting AI applications (clients) to external capabilities (servers). Claude Desktop, Claude Code, and the Agent SDK are all MCP clients.

### Client-Server Model

- Client: the AI application (Claude Code, your app)
- Server: a process exposing tools, resources, prompts
- Transport: how client and server communicate

Servers expose three kinds of capabilities:

- Tools - executable functions (action-oriented)
- Resources - read-only data (like files, database records)
- Prompts - reusable prompt templates

### Transports

- stdio - process-to-process via stdin/stdout; local servers
- Streamable HTTP - modern HTTP-based transport; recommended for remote servers
- SSE - legacy HTTP transport; not recommended for new deployments

### Authentication

Remote MCP servers use OAuth 2.1. The MCP spec defines how clients negotiate, refresh, and scope tokens. Multi-tenant deployments must enforce per-user auth; never let one user's tokens be shared across sessions.

### Multi-Tenant MCP at Scale

- Terminate OAuth at an ingress layer, not at each server instance
- Use per-user rate limits on tool execution
- Version your server; expose the version in server metadata so clients can gracefully adapt
- Log every tool execution with user, tool, arguments, result size, latency
- Enforce timeouts per tool; return error to client rather than hanging

### MCP vs Direct API Tools

| Concern | Direct API Tools | MCP |
|---|---|---|
| Defined in | Request body | Server process |
| Portable across apps? | No | Yes |
| Authentication | Your app handles | OAuth 2.1 or transport-specific |
| Discovery | You know the tools | Client lists tools from server |
| Sharing across teams | Per-team copies | Central server, many clients |

Prefer MCP when the tools will be reused across multiple AI applications. Prefer direct API tools when the tools are tightly coupled to one application.

---

## Designing Idempotent Tools

Agentic loops retry on transient errors. Non-idempotent tools generate duplicates under retry. Design:

- Prefer `create_if_not_exists` semantics with a client-supplied idempotency key
- Return the same response for identical keys
- When possible, make actions reversible (with an `undo_token`)
- Document idempotency in the tool description so Claude trusts retries

---

## Security Considerations

- Validate every tool input against the declared schema at the server; do not trust the client
- Escape or structurally separate untrusted content from instructions (prompt injection via tool results is a real risk)
- Use least-privilege credentials per tool; do not give a `read_orders` tool write access
- Audit every tool call in a way that survives even if the agent process dies
- Rate-limit per user and per tool; an exploited agent can otherwise burn your downstream

---

## Advanced Exam Focus

Expect questions on:

- Which transport to use (Streamable HTTP > stdio > SSE for remote)
- How to design for tool sprawl (prune, merge, dispatcher, subagent)
- When to use forced tool choice for structured output
- When a first-party tool is the correct answer vs custom
- Parallel tool use semantics
- Idempotency and error handling in tools
