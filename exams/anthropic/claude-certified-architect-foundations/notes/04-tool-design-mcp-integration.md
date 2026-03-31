# Domain 4 - Tool Design & MCP Integration (18%)

## Overview

This domain covers two closely related topics: designing tools for Claude's function calling API and building integrations using the Model Context Protocol (MCP). You need to understand both mechanisms, when to use each, and how to design tools that work well with Claude.

---

## Claude API Tool Use (Function Calling)

**[Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Complete function calling reference

### How Tool Use Works

1. You define tools in your API request (name, description, JSON schema for parameters)
2. Claude analyzes the user's request and decides if a tool should be called
3. If yes, Claude returns a `tool_use` content block with the tool name and arguments
4. Your application executes the tool and returns the result
5. Claude uses the result to formulate its response (or call another tool)

### Defining Tools

Tools are defined in the `tools` parameter of the Messages API request:

```json
{
  "name": "get_weather",
  "description": "Get the current weather for a specific city. Returns temperature, conditions, and humidity.",
  "input_schema": {
    "type": "object",
    "properties": {
      "city": {
        "type": "string",
        "description": "The city name (e.g., 'San Francisco, CA')"
      },
      "units": {
        "type": "string",
        "enum": ["celsius", "fahrenheit"],
        "description": "Temperature units. Defaults to fahrenheit."
      }
    },
    "required": ["city"]
  }
}
```

### Tool Choice Modes

**[Tool Use - Tool Choice](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Controlling tool selection

| Mode | Behavior | Use Case |
|---|---|---|
| `auto` | Claude decides whether to use a tool (default) | General purpose - let Claude choose |
| `any` | Claude must use one of the provided tools | Force tool use but let Claude pick which |
| `tool` (specific) | Claude must use the named tool | Force a specific tool (e.g., structured extraction) |

```json
// Auto (default)
"tool_choice": {"type": "auto"}

// Must use a tool
"tool_choice": {"type": "any"}

// Must use specific tool
"tool_choice": {"type": "tool", "name": "extract_data"}
```

### Parallel Tool Use

Claude can request multiple tool calls in a single response when the tools are independent. The response will contain multiple `tool_use` content blocks.

- Enabled by default
- Can be disabled with `"disable_parallel_tool_use": true` in the tool choice
- Your application should execute parallel tool calls concurrently for best performance
- Return all results in the next message

### Error Handling in Tool Calls

When a tool execution fails, return the error to Claude:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_123",
  "is_error": true,
  "content": "Connection timeout: database server is unreachable"
}
```

Claude will see the error and can:
- Retry the same tool with different parameters
- Try an alternative approach
- Inform the user about the failure

**Best practice:** Always include descriptive error messages so Claude can reason about what went wrong.

---

## Tool Design Best Practices

**[Tool Use Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/best-practices)** - Official design guidance

### Naming

- Use clear verb-noun format: `get_customer`, `search_orders`, `create_ticket`
- Be specific: `search_products_by_category` is better than `search`
- Avoid abbreviations: `get_temperature` not `get_temp`
- Use snake_case for tool names

### Descriptions

- Explain what the tool does in 1-2 sentences
- Include when the tool should be used
- Mention what the tool returns
- Note any limitations or constraints

Good description:
```
"Get detailed information about a customer by their ID. Returns name, email, account status, and recent orders. Use this when the user asks about a specific customer."
```

Bad description:
```
"Gets customer."
```

### JSON Schemas

- Add `description` to every property in the schema
- Use `enum` for fields with a fixed set of values
- Use `required` to mark mandatory parameters
- Keep schemas as simple as possible - fewer parameters means fewer errors
- Use sensible defaults for optional parameters

### General Principles

1. **Single responsibility** - Each tool does one thing well
2. **Minimal parameters** - Only require what is necessary
3. **Descriptive responses** - Return enough context for Claude to use the data
4. **Idempotent when possible** - Safe to retry without side effects
5. **Error transparency** - Return clear error messages, not generic failures
6. **Appropriate granularity** - Not too broad (does everything) or too narrow (needs 10 tools for one task)

---

## Model Context Protocol (MCP)

**[MCP Introduction](https://modelcontextprotocol.io/introduction)** - Protocol overview

### What is MCP?

The Model Context Protocol is an open standard that defines how AI applications connect to external tools and data sources. It provides a standardized way for:
- AI applications (clients) to discover and use tools
- Tool providers (servers) to expose capabilities
- Both parties to communicate over defined transports

### Why MCP?

Before MCP, every AI application had to build custom integrations for each tool. MCP provides:
- **Standardization** - One protocol for all tool integrations
- **Reusability** - Build a server once, use it with any MCP client
- **Discovery** - Clients can discover available tools, resources, and prompts
- **Security** - Defined authorization and capability negotiation

---

## MCP Architecture

**[MCP Architecture](https://modelcontextprotocol.io/docs/concepts/architecture)** - Design principles

### Components

```
AI Application (Host)
    |
    └── MCP Client
            |
            └── MCP Server
                    |
                    ├── Tools
                    ├── Resources
                    └── Prompts
```

- **Host** - The AI application (e.g., Claude Desktop, Claude Code, your custom app)
- **Client** - The MCP client within the host that manages server connections
- **Server** - A service that exposes tools, resources, and prompts via MCP

**Important for the exam:** Claude (the AI model) is always the client-side. Your application or service is the MCP server. Do not confuse these roles.

### Transports

**[MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)** - Communication methods

| Transport | Use Case | Description |
|---|---|---|
| **stdio** | Local servers | Communication via stdin/stdout. Client spawns the server process. |
| **SSE** | Remote servers (legacy) | Server-Sent Events over HTTP. Older method for remote connections. |
| **Streamable HTTP** | Remote servers (recommended) | Modern HTTP-based transport. Recommended for new remote servers. |

Choosing the right transport:
- **Local tool on developer's machine** - Use stdio
- **Shared team server** - Use streamable HTTP
- **Cloud-hosted service** - Use streamable HTTP

---

## MCP Server Components

### Tools

**[MCP Tools](https://modelcontextprotocol.io/docs/concepts/tools)** - Executable functions

Tools are functions that the AI model can call. They:
- Accept parameters (defined by JSON schema)
- Execute logic (query database, call API, compute)
- Return results to the model

Tools are the most common MCP primitive. Use them when the model needs to take an action or retrieve dynamic data.

### Resources

**[MCP Resources](https://modelcontextprotocol.io/docs/concepts/resources)** - Read-only data

Resources are data sources the model can read. They:
- Have a URI (e.g., `file:///path/to/doc`, `db://customers/123`)
- Return content (text, JSON, binary)
- Are read-only (no side effects)

Use resources for:
- File contents
- Database records
- Configuration data
- Documentation

Resources vs Tools:
- **Resources** - Read-only data access. The model requests data by URI.
- **Tools** - Executable functions with parameters. The model calls a function.

### Prompts

**[MCP Prompts](https://modelcontextprotocol.io/docs/concepts/prompts)** - Reusable templates

Prompts are reusable prompt templates with parameters. They:
- Have a name and description
- Accept parameters to fill in template variables
- Return formatted prompt content

Use prompts for:
- Standardized workflows (code review template, data analysis template)
- Consistent formatting across team members
- Complex prompt patterns that should be reusable

### Sampling

**[MCP Sampling](https://modelcontextprotocol.io/docs/concepts/sampling)** - Server-initiated LLM calls

Sampling allows MCP servers to request LLM completions from the client. This enables:
- Agentic workflows within MCP servers
- Server-side reasoning about data
- Multi-step server-side processing

---

## Building MCP Servers

### Server SDKs

MCP servers can be built in multiple languages:
- **TypeScript** - `@modelcontextprotocol/sdk`
- **Python** - `mcp` package

### Server Structure (TypeScript example)

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

const server = new McpServer({
  name: "my-server",
  version: "1.0.0"
});

// Define a tool
server.tool("search_products", {
  description: "Search products by name or category",
  inputSchema: {
    type: "object",
    properties: {
      query: { type: "string", description: "Search query" },
      category: { type: "string", description: "Product category" }
    },
    required: ["query"]
  }
}, async (params) => {
  // Implementation
  const results = await searchProducts(params.query, params.category);
  return { content: [{ type: "text", text: JSON.stringify(results) }] };
});
```

### MCP Servers Repository

**[MCP Servers](https://github.com/modelcontextprotocol/servers)** - Reference implementations

The official repository contains example MCP servers for common use cases:
- File system access
- Database queries
- Web browsing
- Git operations
- And more

---

## API Tool Use vs MCP - When to Use Which

| Consideration | API Tool Use | MCP |
|---|---|---|
| **Integration scope** | Single application | Reusable across applications |
| **Execution** | Your application executes | MCP server executes |
| **Discovery** | Defined per request | Discovered via protocol |
| **Deployment** | Part of your app | Separate server process |
| **Best for** | App-specific tools | Shared/reusable tools |
| **Configuration** | In API request | In MCP client config |

Use API tool use when:
- Tools are specific to your application
- You want full control over execution
- You are building a custom integration

Use MCP when:
- Tools should be reusable across multiple applications
- You want standardized discovery and invocation
- You are building tools for Claude Code or Claude Desktop
- You want to share tools across a team

---

## Key Exam Concepts

1. Know the three tool choice modes and when to use each
2. Understand MCP architecture - clients, servers, transports
3. Know the difference between MCP tools, resources, and prompts
4. Understand tool design best practices (naming, descriptions, schemas)
5. Know when to use API tool use vs MCP
6. Understand transport selection (stdio for local, streamable HTTP for remote)
7. Know how to handle tool errors (is_error flag, descriptive messages)
8. Understand parallel tool use behavior

---

## Related Documentation

- **[Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - API function calling
- **[Tool Use Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/best-practices)** - Design guidance
- **[MCP Introduction](https://modelcontextprotocol.io/introduction)** - Protocol overview
- **[MCP Architecture](https://modelcontextprotocol.io/docs/concepts/architecture)** - Design principles
- **[MCP Tools](https://modelcontextprotocol.io/docs/concepts/tools)** - Tool primitives
- **[MCP Resources](https://modelcontextprotocol.io/docs/concepts/resources)** - Data access
- **[MCP Prompts](https://modelcontextprotocol.io/docs/concepts/prompts)** - Prompt templates
- **[MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)** - Communication methods
- **[MCP Specification](https://spec.modelcontextprotocol.io)** - Full protocol spec
- **[MCP Servers Repository](https://github.com/modelcontextprotocol/servers)** - Reference implementations
