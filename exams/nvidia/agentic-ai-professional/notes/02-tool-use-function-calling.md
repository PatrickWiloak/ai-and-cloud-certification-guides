# Tool Use and Function Calling

**[📖 NIM Function Calling](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Function calling with NVIDIA NIM

## Function Calling Fundamentals

### Schema Definition

Tools are defined using JSON Schema format:

```json
{
  "type": "function",
  "function": {
    "name": "get_weather",
    "description": "Get current weather for a city",
    "parameters": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "description": "City name"
        },
        "units": {
          "type": "string",
          "enum": ["celsius", "fahrenheit"],
          "description": "Temperature units"
        }
      },
      "required": ["city"]
    }
  }
}
```

**Best Practices for Schema Design:**
- Use clear, descriptive function names
- Write detailed descriptions - the LLM uses these for tool selection
- Specify parameter types, constraints, and enums
- Mark required vs optional parameters explicitly
- Include examples in descriptions for complex parameters

### Parameter Extraction

- LLM extracts parameter values from natural language input
- Handles type coercion (strings to numbers, dates, booleans)
- Deals with ambiguous or missing parameters through clarification
- Validates extracted values against schema constraints before execution

### Tool Selection

- Model chooses which tool(s) to call based on user intent
- `tool_choice: "auto"` - model decides whether to call a tool
- `tool_choice: "required"` - model must call at least one tool
- `tool_choice: {"type": "function", "function": {"name": "..."}}` - force specific tool
- No tool call needed for conversational or reasoning-only responses

**[📖 NIM API Reference](https://docs.nvidia.com/nim/large-language-models/latest/reference.html)** - API parameters for function calling

## Tool Orchestration

### Sequential Execution
- One tool at a time, results inform the next decision
- Simple to implement, easy to debug
- Slower for tasks with independent sub-operations
- Appropriate when tools have dependencies

### Parallel Execution
- Multiple independent tool calls issued simultaneously
- Reduces total latency for independent operations
- Requires identifying which tools are independent
- More complex error handling and result aggregation

### Pipeline Patterns
- **Chain** - Output of one tool feeds into the next
- **Map-Reduce** - Apply tool to multiple items, aggregate results
- **Fan-out/Fan-in** - Parallel sub-tasks that merge at a sync point
- **Conditional** - Branch execution based on tool results

### Routing
- Dynamic tool selection based on input classification
- Route to specialized tools for different domains
- Fallback chains when primary tool is unavailable
- Load balancing across equivalent tool instances

## Error Handling

### Retry Strategies
- **Exponential backoff** for transient network failures
- **Maximum retry count** to prevent infinite loops
- **Different strategies per error type** (retriable vs fatal)
- **Timeout enforcement** for each tool call

### Error Recovery Patterns
- Parse error messages and adjust parameters accordingly
- Self-correct by trying alternative parameter values
- Ask the user for clarification when input is ambiguous
- Fall back to simpler tools or approaches
- Graceful degradation when tools are completely unavailable

### Circuit Breaker Pattern
- Track failure rate for each tool
- Open circuit after threshold of consecutive failures
- Periodically test with a single request (half-open state)
- Prevents cascading failures from broken external services

**[📖 NeMo Guardrails Actions](https://docs.nvidia.com/nemo/guardrails/latest/user-guides/configuration-guide/index.html)** - Configuring action handling and error recovery

## Custom Tool Development

### Design Principles
- Define clear, typed input/output schemas
- Write descriptions that help the LLM understand when and how to use the tool
- Handle errors gracefully - return informative error messages, not stack traces
- Document expected behavior, edge cases, and limitations
- Test tools independently before integrating with agents

### Implementation Checklist
- Input validation before processing
- Timeout handling for external calls
- Structured output format (JSON preferred)
- Logging for debugging and audit
- Rate limiting awareness
- Version management for backward compatibility

### Testing Tools
- Unit tests for input validation and output formatting
- Integration tests with mock external services
- Load tests for concurrent usage
- Edge case tests (empty input, large input, malformed input)
- Verify LLM can correctly select and parameterize the tool

## Key Exam Concepts

- JSON Schema format for function definitions
- Parameter extraction and type coercion
- Sequential vs parallel tool execution trade-offs
- Error handling strategies - retry, fallback, circuit breaker
- Tool selection using tool_choice parameter
- Custom tool design best practices
