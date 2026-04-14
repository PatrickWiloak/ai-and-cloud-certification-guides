# 01 - Advanced Claude Architectures

Advanced Claude applications rarely collapse into "one call to the API." They are systems: orchestrators that decompose tasks, workers that execute in parallel, retrievers that shape context, guards that enforce policy, evaluators that gate releases. This note covers the architectural vocabulary and the decision criteria the exam expects you to wield.

---

## The Architectural Spectrum

Anthropic's engineering guidance places Claude systems on a spectrum:

1. Single prompt, no tools - deterministic text task, minimal infrastructure
2. Single prompt with tool use - agent inside one API call
3. Agent loop (tool use in a while-loop) - stateful multi-turn agent
4. Orchestrator-worker - coordinator dispatches to specialized sub-agents
5. Planner-executor - one agent plans, another executes each plan step
6. Peer / swarm - multiple agents collaborate without fixed hierarchy

Move up the spectrum only when the task demands it. Each step up compounds cost, latency, and failure modes.

---

## Single-Agent Tool Loop

The default. One Claude instance, a curated tool set, a loop that:

```
while not done:
    response = messages.create(..., tools=my_tools)
    if response.stop_reason == "end_turn":
        break
    if response.stop_reason == "tool_use":
        for tool_call in extract_tool_uses(response):
            result = execute(tool_call)
            messages.append(tool_result(result))
```

Strengths:

- Minimal moving parts
- Claude sees all context, avoiding information fragmentation
- Prompt caching trivially applies to the static prefix
- Observable: one trace per conversation

Weaknesses:

- Does not parallelize across independent sub-tasks
- Context window constrains very long tasks
- One model tier for the whole task

Use as your default. Only move to multi-agent when profiling shows a specific reason.

---

## Orchestrator-Worker

An orchestrator agent receives the task, decomposes it, dispatches workers, and aggregates. Anthropic's internal research agents used this pattern for web research workloads.

Strengths:

- True parallelism - N workers run concurrently
- Each worker has a narrow, fresh context (no accumulation of prior turns)
- Workers can use cheaper models (Haiku) while the orchestrator uses Opus
- Failures in one worker do not poison siblings

Weaknesses:

- Orchestration overhead - N+2 calls minimum instead of 1-3
- Synthesis risk - aggregating worker outputs requires care to avoid contradictions
- Debuggability - more traces to correlate

Design rules:

1. Workers should have narrow, independent sub-tasks. If workers need to communicate mid-task, the pattern is wrong.
2. Always cap worker count (e.g., top N-most-relevant sources).
3. Include the original user task verbatim in each worker prompt; do not re-paraphrase it.
4. Give the orchestrator a structured output schema so its dispatch is machine-parseable.
5. Give the aggregator explicit instructions about conflict resolution.

---

## Planner-Executor

The planner produces an explicit plan (often structured as a list of steps with inputs/outputs). The executor, possibly on a cheaper model, runs each step.

Use when:

- Planning is hard and benefits from Opus + extended thinking
- Execution is straightforward, deterministic, and benefits from throughput

Common variant: plan once with Opus 4.6, execute with Sonnet 4.6 loop, re-plan only on deviation.

---

## RAG at Scale

Retrieval-augmented generation against large corpora. Advanced patterns:

- Hybrid retrieval (vector + BM25) with fused rerank
- Chunk-and-cite with Claude's citations feature
- Query rewriting with Haiku before retrieval
- Contextual retrieval (Anthropic cookbook) - prepend each chunk with a short summary of its containing document at ingest time, which boosts retrieval accuracy significantly
- Prompt caching on retrieved context only if the same context is reused within the cache TTL; otherwise cache the system prompt instead

Contextual retrieval key insight: most chunking strategies lose document-level context. By generating a short contextual preamble per chunk at ingest time (e.g., "This chunk is from Acme Corp's 2025 Q3 10-Q filing discussing cloud revenue"), retrieval precision improves measurably.

---

## Long-Horizon Agents

Agents that run for hundreds of steps (coding agents, research agents, operations agents). Key concerns:

1. Context exhaustion - compress old turns, offload state to the memory tool or external storage.
2. Goal drift - restate the goal periodically; use a goal-checking sub-step.
3. Loop detection - hash recent tool calls; abort on repeats.
4. Budget enforcement - hard stop on tokens or wall-clock.
5. Recoverability - checkpoint state so a crashed agent can resume.

The Claude Agent SDK provides primitives for many of these: compaction hooks, memory, subagents.

---

## Multi-Tenant Considerations

When one codebase serves many customers:

- Per-tenant system prompts must include tenant ID and scope; do not leak cross-tenant data.
- Prompt caching breakpoints should be placed to maximize cross-request hits within a tenant, not across tenants.
- Tool executions must be authorized per tenant (MCP server enforces this).
- Audit logs must record tenant ID, prompt hash, model, and cost.

---

## Reliability Patterns

- Idempotent tools so retries are safe
- Schema validation on every tool input and output
- Structured error responses (`is_error: true`) so Claude can adapt
- Circuit breakers at the agent loop level, not just HTTP
- Fallback model ladders (Opus -> Sonnet -> Haiku) when the primary is overloaded
- Dead-letter queues for failed batches

---

## Decision Tree

Start here, move down only when forced:

```
Is the task single-shot text generation?       -> Single prompt, no tools
Does it need external data or actions?         -> Single prompt + tools
Does it need multiple tool-use turns?          -> Agent loop
Can sub-tasks run in parallel independently?   -> Orchestrator-worker
Is planning expensive but execution cheap?     -> Planner-executor
Do agents truly need peer coordination?        -> Swarm (rare, justify hard)
```

---

## Anti-Patterns

- Multi-agent as a default instead of as an optimization
- Sub-agents that need to chat with each other mid-task (use orchestrator-worker with structured outputs instead)
- Retries without exponential backoff
- Unbounded agent loops without iteration caps
- Routing every request through Opus when Sonnet or Haiku would suffice
- Caching content that is used once
- Treating prompt caching as a substitute for the memory tool or vice versa

---

## Example: Research Agent Refactor

Before: Opus orchestrator, 10 Opus workers each reading one PDF, Opus aggregator. Cost: $1.20/query. Latency P95: 45s.

After:

1. Haiku 4.5 triages and picks top 5 PDFs.
2. Sonnet 4.6 single-agent with a `read_pdf` tool and parallel tool use, reads all 5 in one turn.
3. Prompt caching on the stable system instructions.
4. Extended thinking enabled only for the final synthesis step with a 4K budget.

Cost: $0.18/query. Latency P95: 14s. Quality within 2 points on the eval set.

The lesson: most "multi-agent" workloads are single-agent workloads in disguise. Profile before architecting.

---

## What the Advanced Exam Asks

Expect scenarios that describe a pipeline and ask "what is wrong" or "what would you change." Answers usually involve:

- Collapsing unnecessary multi-agent structures
- Moving model tiers down where safe
- Introducing caching or batching
- Replacing roll-your-own with a first-party feature
- Right-sizing extended thinking budgets

The exam rewards simplicity within constraints. When in doubt, simpler wins.
