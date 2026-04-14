# 03 - Tool Use and Function Calling

Tool use is how Claude acts. This note covers the lifecycle, choice modes, parallel tool use, structured output via forced choice, and idiomatic loop construction.

---

## Tool Definition

A tool is declared with three fields:

```json
{
  "name": "get_weather",
  "description": "Look up current weather for a city. Returns null if unknown.",
  "input_schema": {
    "type": "object",
    "properties": {
      "city": {"type": "string", "description": "City name"},
      "units": {"type": "string", "enum": ["c", "f"], "default": "c"}
    },
    "required": ["city"]
  }
}
```

The `description` is a prompt. Spend time on it. Include when to use, what is returned, side effects, and an example invocation when parameters are non-obvious.

---

## Tool Choice Modes

- `tool_choice: {"type": "auto"}` (default) - Claude decides whether to call a tool
- `tool_choice: {"type": "any"}` - Claude must call one of the available tools
- `tool_choice: {"type": "tool", "name": "get_weather"}` - Claude must call this specific tool
- `tool_choice: {"type": "none"}` - Claude may not call tools

Use `auto` for normal agents. Use `any` when you require some action. Use the specific form for guaranteed structured output.

---

## Tool Use Lifecycle

1. Send request with `tools` defined and a user message
2. Claude responds. If it wants a tool, `stop_reason: tool_use` and the assistant message includes one or more `tool_use` content blocks:

```json
{
  "type": "tool_use",
  "id": "toolu_01ABC...",
  "name": "get_weather",
  "input": {"city": "Austin"}
}
```

3. You execute `get_weather("Austin")` in your code
4. You send a new message:

```json
{
  "role": "user",
  "content": [
    {
      "type": "tool_result",
      "tool_use_id": "toolu_01ABC...",
      "content": "Sunny, 28C"
    }
  ]
}
```

5. Continue. Claude may use more tools or produce an `end_turn` text response.

Critical: `tool_result` always goes in a `user` message. The `tool_use_id` must match.

---

## Parallel Tool Use

Modern Claude models can emit multiple `tool_use` blocks in a single response. Your loop must handle this:

```python
if response.stop_reason == "tool_use":
    tool_results = []
    for block in response.content:
        if block.type == "tool_use":
            result = execute(block.name, block.input)
            tool_results.append({
                "type": "tool_result",
                "tool_use_id": block.id,
                "content": result,
            })
    history.append({"role": "user", "content": tool_results})
```

Send all tool_result blocks together in one user message. Do not split them across multiple turns.

---

## Errors in Tools

Return errors structurally:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_01ABC",
  "content": "Order 12345 not found. Use search_orders if you only have the customer name.",
  "is_error": true
}
```

Informative errors let Claude recover. "Failed" or "Error 500" is useless.

---

## Structured Output via Forced Tool Choice

The cleanest way to extract structured data:

```python
extract_tool = {
    "name": "save_invoice",
    "description": "Save the extracted invoice fields.",
    "input_schema": {
        "type": "object",
        "properties": {
            "invoice_number": {"type": "string"},
            "total": {"type": "number"},
            "line_items": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "description": {"type": "string"},
                        "amount": {"type": "number"},
                    },
                    "required": ["description", "amount"],
                },
            },
        },
        "required": ["invoice_number", "total", "line_items"],
    },
}

resp = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=2048,
    tools=[extract_tool],
    tool_choice={"type": "tool", "name": "save_invoice"},
    messages=[{"role": "user", "content": invoice_text}],
)

structured = next(b for b in resp.content if b.type == "tool_use").input
```

You do not need to "execute" the tool - just consume the `input` field as your structured output.

---

## Tool Use With Streaming

`tool_use` blocks stream too: `content_block_start` opens a `tool_use` block, then `input_json_delta` events stream the JSON fragments of the input. Reassemble at the client; the SDK helpers do this for you.

---

## The Agent Loop

A simple loop, written by hand for clarity:

```python
def run_agent(user_prompt, tools, executors, max_iterations=20):
    history = [{"role": "user", "content": user_prompt}]
    for _ in range(max_iterations):
        resp = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=2048,
            tools=tools,
            messages=history,
        )
        history.append({"role": "assistant", "content": resp.content})
        if resp.stop_reason != "tool_use":
            return resp
        tool_results = []
        for block in resp.content:
            if block.type == "tool_use":
                try:
                    result = executors[block.name](**block.input)
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": str(result),
                    })
                except Exception as e:
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": f"Error: {e}",
                        "is_error": True,
                    })
        history.append({"role": "user", "content": tool_results})
    raise RuntimeError("max iterations exceeded")
```

In production you would add streaming, observability, retries, and budget enforcement, but the spine looks like this.

---

## Tool Design Best Practices

- Verb-noun names (`get_customer`, `search_orders`, `create_ticket`)
- Descriptions are prompts; treat them like one
- Minimal required parameters; flexible optional parameters
- Idempotent where feasible
- Structured errors with `is_error: true`
- Document side effects explicitly
- Avoid overlapping tools - merge or dispatcher them

---

## Anti-Patterns

- Tool results in an assistant message
- Forgetting `tool_use_id`
- Using prompt instructions to "respond in JSON" instead of forced tool choice
- Ignoring `is_error: true` and treating all results as success
- Calling tools in serial when they could be parallel

---

## Exam Focus

- Tool result placement (user role)
- `tool_use_id` requirement
- `tool_choice` modes and when to use each
- Parallel tool use semantics
- Structured output via forced tool choice
- Error response shape
