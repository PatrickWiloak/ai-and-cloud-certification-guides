# 02 - Claude Agent SDK Deep Dive

The Claude Agent SDK is Anthropic's official toolkit for building autonomous agents. It wraps the Messages API with agent-specific primitives: session management, subagents, skills, hooks, tool-use loops, streaming, and context compaction. Understanding the SDK is essential at the Advanced tier because it encodes Anthropic's recommended agent architecture.

The SDK ships for Python (`claude-agent-sdk` on PyPI) and TypeScript (`@anthropic-ai/claude-agent-sdk` on npm). Both expose the same conceptual model.

---

## Why Use the SDK

You could build an agent with raw Messages API calls. Many production agents do. The SDK earns its place when you need:

- A standardized loop with sensible defaults (iteration caps, error handling, streaming)
- Session persistence so agents can resume
- Subagents as a first-class primitive
- Skills: reusable, versioned capability bundles
- Hooks: pre- and post-tool interception for policy and observability
- Context compaction that Just Works
- Integration with Claude Code's own agent runtime

For simple tool-use loops, the raw API is fine. For production agents, the SDK cuts weeks of boilerplate.

---

## Core Primitives

### Agent

The top-level loop. Configure with:

- Model (claude-opus-4-6, claude-sonnet-4-6, claude-haiku-4-5)
- System prompt
- Tools
- Max iterations
- Thinking configuration
- Hooks

The agent runs until completion, max iterations, or an explicit stop. It handles tool execution and message accumulation automatically.

### Subagent

An agent spawned by a parent agent. Subagents have their own system prompt, tools, and model. They appear to the parent as callable tools. Perfect for orchestrator-worker without writing the plumbing yourself.

Key semantics:

- Subagent has its own context window; parent does not see subagent's internal turns, only the final result
- Subagent tokens count toward the trace cost but not the parent context
- Subagents can have subagents (keep hierarchy shallow - 2 levels is usually enough)

### Skills

A skill is a packaged capability: a description, optional tools, optional system prompt contributions, optional hooks. Skills are the SDK's answer to "how do I reuse agent capabilities across projects?"

Example skill ideas:

- `pdf-processing` - loads PDFs, exposes extract/summarize/cite tools
- `sql-analytics` - exposes a safe SQL tool with row-limit guardrails
- `code-review` - exposes diff/comment/approve tools

Skills compose. An agent can activate multiple skills; the SDK assembles the merged tool set, system prompt, and hooks.

### Hooks

Hooks are functions that run at defined lifecycle points:

- pre-tool - before a tool executes; can block or rewrite
- post-tool - after a tool executes; can transform the result
- pre-model - before each Messages API call; can inject or truncate
- post-model - after each response; can log, audit, or redirect

Hooks are how you enforce policy (PII redaction), add observability (tracing), and implement safety (jailbreak detection) without touching agent business logic.

### Sessions

A session is a persistent conversation with state (message history, memory, skill activations). Sessions can be paused and resumed. Useful for long-running agents (multi-hour coding tasks) and for human-in-the-loop where the agent pauses for approval.

---

## Anatomy of an SDK Agent

```python
from claude_agent_sdk import Agent, tool, hook

@tool
def get_weather(city: str) -> dict:
    """Return current weather for a city."""
    ...

@hook("pre-tool")
def audit(tool_name, args):
    log.info("tool_call", tool=tool_name, args=args)
    return args  # returning None or a modified dict is allowed

agent = Agent(
    model="claude-sonnet-4-6",
    system="You are a helpful meteorology assistant.",
    tools=[get_weather],
    hooks=[audit],
    max_iterations=20,
)

result = agent.run("What is the weather in Austin vs Denver?")
print(result.final_message)
```

The SDK handles the loop, tool dispatch, error propagation, and compaction.

---

## Orchestrator-Worker With Subagents

```python
researcher = Agent(
    model="claude-haiku-4-5",
    system="You are a research worker. Summarize the given source.",
    tools=[read_url, read_pdf],
)

orchestrator = Agent(
    model="claude-sonnet-4-6",
    system="You coordinate a team of research workers.",
    subagents={"researcher": researcher},
    tools=[search_web],
)

result = orchestrator.run("Summarize recent AI regulation in the EU and US.")
```

The orchestrator dispatches to `researcher` via a generated tool interface. Each researcher runs in a fresh context with its own model tier.

---

## Context Compaction

For long-running sessions, raw message history will exhaust the context window. The SDK supports automatic compaction: when history nears a configured threshold (e.g., 80% of context), the SDK summarizes older turns into a compressed context block and retains recent turns verbatim.

Configuration options:

- Compaction threshold (default ~80%)
- Compaction model (often Haiku for speed)
- Preserve-N-recent setting
- Custom compactor function if you need domain-specific summarization

Compaction interacts with prompt caching. A compaction event invalidates the cached prefix past that point. Design hooks to re-establish caching after compaction if the post-compaction prefix is reused.

---

## Integration With Claude Code

The Agent SDK powers Claude Code's internal agent runtime. You can:

- Write custom slash commands in Claude Code using SDK primitives
- Install Claude Code skills via the SDK
- Share hooks between Claude Code and your production agents

This alignment means skills developed for your backend can be reused in Claude Code developer workflows.

---

## Observability

SDK emits structured events for every lifecycle point. Wire these to your observability stack:

- Per-call: model, tokens (input/output/thinking/cache read/cache write), latency, stop reason
- Per-iteration: tool calls, tool latencies, tool errors
- Per-session: total cost, total iterations, final status

Recommended: emit OpenTelemetry spans, one per iteration, with token and cost attributes.

---

## Testing Agents

SDK exposes test harness utilities:

- Fake tool implementations for deterministic tests
- Deterministic sampling (temperature=0 combined with seed where available)
- Transcript replay for regression tests
- Eval runners that execute agent over a dataset and produce pass/fail

Run eval suites in CI. Block merges on regressions.

---

## SDK vs Raw API Decision

Use raw Messages API when:

- Task is a single-shot or simple few-turn interaction
- You have custom agent orchestration that does not fit SDK primitives
- You need fine-grained control over every byte of context

Use the SDK when:

- You are building something that looks like an agent
- You need subagents, skills, or hooks
- You want compaction without writing it yourself
- You want alignment with Claude Code's runtime

---

## Advanced Exam Focus

Expect questions like:

- "Which SDK primitive handles X?" (skills, hooks, subagents, sessions)
- "What happens when an SDK agent hits the compaction threshold?"
- "How do you enforce PII redaction on every tool output?" (post-tool hook)
- "How do you add a specialized sub-task handler?" (subagent)

Know the names. Know the lifecycle. Build one real SDK agent before sitting the exam.
