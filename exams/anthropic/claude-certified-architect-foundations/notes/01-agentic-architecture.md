# Domain 1 - Agentic Architecture (27%)

## Overview

This is the highest-weighted domain on the CCA-F exam. It covers designing, building, and operating agentic systems with Claude. You must understand when to use agentic patterns, how to architect multi-agent systems, and how to handle production concerns like cost, latency, and reliability.

---

## What is an Agentic System?

An agentic system is one where Claude operates in a loop - calling tools, observing results, reasoning about next steps, and taking further actions until a task is complete. Unlike a simple prompt-response interaction, an agentic system involves:

- **Autonomy** - Claude decides which tools to call and in what order
- **Iteration** - Multiple rounds of tool calls and reasoning
- **Goal-directed behavior** - Claude works toward completing a defined objective
- **Dynamic decision making** - The path is not predetermined; it depends on intermediate results

**[Agentic Patterns Guide](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - Official documentation on building agentic systems with Claude

---

## Agentic Design Patterns

### Tool Use Loop

The fundamental agentic pattern. Claude receives a task, calls tools to gather information or take actions, receives tool results, and decides what to do next.

```
User Request -> Claude Reasoning -> Tool Call -> Tool Result -> Claude Reasoning -> ... -> Final Response
```

Key implementation details:
- Each iteration is a separate API call (messages with tool results)
- Claude sees the full conversation history including all previous tool calls
- The loop continues until Claude responds without a tool call (task complete)
- Always implement a maximum iteration limit to prevent runaway loops

### Plan-Execute-Reflect

A structured pattern where the agent:

1. **Plan** - Breaks the task into discrete steps before acting
2. **Execute** - Carries out each step using available tools
3. **Reflect** - Evaluates results after each step and adjusts the plan if needed

This pattern is useful for complex, multi-step tasks where upfront planning improves efficiency. Extended thinking can enhance the planning phase.

### Orchestration Pattern

A central controller manages the flow of work:

1. Receives the initial request
2. Determines which capabilities are needed
3. Routes work to appropriate handlers (which may be Claude with different tools/prompts)
4. Aggregates results
5. Returns the final response

This is useful when different parts of a task require different tools, models, or configurations.

---

## Agent Architectures

### Single Agent

One Claude instance with access to multiple tools. Suitable for:
- Tasks with a manageable number of tools (typically under 10-15)
- Workflows where a single context is sufficient
- Simpler applications where coordination overhead is not justified

Advantages:
- Simple to implement and debug
- Single context window maintains all information
- Lower latency (no inter-agent communication)

Disadvantages:
- Context window fills up with many tools and long conversations
- All tools must share the same model and configuration
- Single point of failure

### Multi-Agent (Peer Pattern)

Multiple Claude instances that collaborate as equals. Each agent has specialized tools and expertise. They communicate by passing messages or shared state.

Suitable for:
- Tasks that naturally decompose into independent subtasks
- Workflows requiring different tool sets that would overwhelm a single context
- Parallel processing of independent work streams

### Supervisor Pattern

A coordinator agent (supervisor) manages multiple worker agents:

1. **Supervisor** - Receives the task, decomposes it, delegates to workers, aggregates results
2. **Workers** - Specialized agents that handle specific subtasks

The supervisor typically has:
- No direct tools (or minimal tools)
- Knowledge of what each worker can do
- Logic for decomposing tasks and routing them
- Ability to synthesize worker outputs into a final result

This is the most common pattern for complex agentic systems. It provides:
- Clear separation of concerns
- Ability to use different models for different tasks (Haiku for simple work, Sonnet/Opus for complex)
- Independent scaling of worker capabilities
- Easier debugging (each worker has a focused scope)

### Hierarchical Multi-Agent

An extension of the supervisor pattern with multiple levels:

```
Top-Level Supervisor
├── Domain Supervisor A
│   ├── Worker A1
│   └── Worker A2
└── Domain Supervisor B
    ├── Worker B1
    └── Worker B2
```

Suitable for very complex systems. Each level adds latency and cost, so use only when simpler patterns are insufficient.

---

## When to Use Agents vs Simple Prompts

### Use Simple Prompts When:
- The task has a clear input-to-output mapping (translation, classification, summarization)
- No external tools or data are needed
- The task can be completed in a single reasoning step
- The output format is predictable and consistent
- Latency requirements are strict (sub-second responses)

### Use Agents When:
- The task requires multiple steps with intermediate decisions
- External tools or data sources are needed
- The path to completion is not known in advance
- Results from one step influence the next step
- The task involves search, research, or exploration
- Complex reasoning over multiple documents or data sources is needed

### Decision Framework

Ask these questions:
1. Does the task require calling external tools? If no - simple prompt.
2. Is the sequence of operations fixed? If yes - prompt chain (not full agent).
3. Do intermediate results change the approach? If yes - agent.
4. Is the task decomposable into independent subtasks? If yes - consider multi-agent.
5. Are there high-stakes actions that need human approval? If yes - agent with human-in-the-loop.

---

## Error Handling and Recovery

### Types of Errors in Agentic Systems

1. **API errors** - Rate limits (429), server errors (500), timeouts
2. **Tool errors** - Tool returns an error or unexpected result
3. **Reasoning errors** - Claude makes a wrong decision or gets stuck in a loop
4. **State errors** - Inconsistent state between agent iterations

### Error Handling Strategies

**Retry with context** - When a tool fails, pass the error message back to Claude so it can adjust its approach:
```
Tool result: {"is_error": true, "content": "Database connection timeout"}
```
Claude can then decide to retry, try an alternative approach, or ask for help.

**Maximum iteration limits** - Always set a maximum number of loop iterations:
- Prevents infinite loops from reasoning errors
- Controls cost (each iteration is an API call)
- Typical limits: 10-25 iterations depending on task complexity

**Circuit breakers** - Stop execution after N consecutive failures:
- Prevents wasting API calls on a systemic issue
- Allow cooldown before resuming
- Alert operators for investigation

**Graceful degradation** - When full task completion is not possible:
- Return partial results with an explanation of what could not be completed
- Offer to escalate to a human
- Log the failure for later analysis

**Fallback strategies:**
- Try alternative tools if the primary tool fails
- Simplify the task and attempt a reduced version
- Use a different model (e.g., fall back from Sonnet to Haiku for simpler subtasks)

---

## Production Considerations

### Cost Management

- Each agentic loop iteration is a separate API call with its own token costs
- Extended thinking adds to per-request costs but may reduce total iterations
- Use cheaper models (Haiku) for simple sub-tasks
- Implement token budgets per task to cap spending
- Monitor cost per task type and optimize high-cost patterns
- Prompt caching reduces cost for repeated static content

### Latency Optimization

- Agentic systems are inherently slower than single-turn prompts (multiple API calls)
- Parallel tool calls reduce total latency when tools are independent
- Streaming helps with perceived latency for user-facing applications
- Consider caching tool results that do not change frequently
- Use the right model size - do not use Opus when Haiku suffices

### Reliability

- Implement comprehensive logging of all agent decisions and tool calls
- Add observability (metrics, traces) for production monitoring
- Test with edge cases: empty tool results, very large tool results, unexpected formats
- Implement timeouts at every level (API call, tool execution, total task)
- Design for idempotency - agent restarts should not cause duplicate side effects

### Human-in-the-Loop

- Required for high-stakes actions (financial transactions, data deletion, external communications)
- Implement approval gates at critical decision points
- Provide the human with Claude's reasoning and proposed action
- Allow the human to modify the action before proceeding
- Log all human interventions for audit purposes

---

## Extended Thinking in Agentic Systems

**[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Claude's internal reasoning mode

Extended thinking can enhance agentic systems by:
- Improving planning quality at the start of a task
- Better reasoning about complex tool results
- More accurate decisions about which tool to call next
- Reducing the number of iterations needed (better decisions = fewer wrong turns)

Tradeoffs:
- Increases per-request cost and latency
- Thinking tokens count against usage but are not visible to the user by default
- Most beneficial for complex reasoning tasks, less useful for simple tool calls
- Consider enabling it selectively - for planning steps but not routine tool calls

---

## Key Exam Concepts

1. Know the difference between tool use loops, plan-execute-reflect, and orchestration patterns
2. Understand when to use single agent vs multi-agent vs supervisor pattern
3. Be able to identify when a simple prompt is better than an agent
4. Know how to implement error handling and recovery in agentic loops
5. Understand production cost and latency implications
6. Know when human-in-the-loop is required
7. Understand how extended thinking enhances agentic reasoning

---

## Related Documentation

- **[Agentic Patterns](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - Primary reference for agentic design
- **[Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Foundation for agentic tool loops
- **[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Enhancing agent reasoning
- **[Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook)** - Agentic code examples
- **[Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)** - Managing agent costs
- **[Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)** - Production rate management
