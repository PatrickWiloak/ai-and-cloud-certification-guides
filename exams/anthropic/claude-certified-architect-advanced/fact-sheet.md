# CCA-A - Fact Sheet

## Quick Reference (Preliminary)

| Detail | Info |
|---|---|
| Exam Code | CCA-A |
| Full Name | Claude Certified Architect - Advanced |
| Provider | Anthropic |
| Duration | 150 minutes (estimate) |
| Questions | 65-75 scenario-based MCQs and case studies (estimate) |
| Passing Score | ~750 / 1000 (estimate) |
| Cost | TBD |
| Delivery | Online proctored |
| Validity | 2 years |
| Prereq | CCA-F recommended |

All numbers above are preliminary pending Anthropic's official blueprint.

---

## Expected Domain Weights

| Domain | Weight | Key Focus |
|---|---|---|
| 1. Advanced Architectures and Multi-Agent | 22% | Orchestrator-worker, planner-executor, swarms |
| 2. Context Engineering and Extended Thinking | 18% | Memory tool, thinking budgets, interleaved thinking |
| 3. Tool Use and MCP at Scale | 17% | Parallel tools, MCP servers, code execution |
| 4. Evaluation, Observability, Safety | 15% | Evals, tracing, guardrails, red-teaming |
| 5. Cost, Latency, Throughput | 15% | Caching, batch, routing, streaming |
| 6. Enterprise Deployment | 13% | Bedrock, Vertex, VPC, compliance |

---

## Core Model IDs (2026)

| Model | Model ID | Best For |
|---|---|---|
| Opus | claude-opus-4-6 | Deep reasoning, long-horizon agents, planning |
| Sonnet | claude-sonnet-4-6 | General purpose, coding, workhorse |
| Haiku | claude-haiku-4-5 | High throughput, classification, sub-agents |

Bedrock and Vertex have their own region-scoped IDs. Always check current documentation.

---

## Official Documentation

### Core API

- [Messages API](https://docs.anthropic.com/en/api/messages)
- [Streaming](https://docs.anthropic.com/en/api/messages-streaming)
- [Message Batches](https://docs.anthropic.com/en/api/creating-message-batches)
- [Token Counting](https://docs.anthropic.com/en/api/messages-count-tokens)
- [Errors](https://docs.anthropic.com/en/api/errors)
- [Rate Limits](https://docs.anthropic.com/en/api/rate-limits)

### Advanced Features

- [Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)
- [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [Batch Processing](https://docs.anthropic.com/en/docs/build-with-claude/batch-processing)
- [Files API](https://docs.anthropic.com/en/docs/build-with-claude/files)
- [Citations](https://docs.anthropic.com/en/docs/build-with-claude/citations)
- [Vision](https://docs.anthropic.com/en/docs/build-with-claude/vision)
- [PDF Support](https://docs.anthropic.com/en/docs/build-with-claude/pdf-support)
- [Memory Tool](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/memory-tool)

### Tool Use

- [Tool Use Overview](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)
- [Code Execution Tool](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/code-execution-tool)
- [Computer Use](https://docs.anthropic.com/en/docs/build-with-claude/computer-use)
- [Bash Tool](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/bash-tool)
- [Text Editor Tool](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/text-editor-tool)
- [Web Search Tool](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/web-search-tool)

### Agent SDK and MCP

- [Claude Agent SDK Overview](https://docs.anthropic.com/en/api/agent-sdk/overview)
- [Agent SDK Python](https://github.com/anthropics/claude-agent-sdk-python)
- [Agent SDK TypeScript](https://github.com/anthropics/claude-agent-sdk-typescript)
- [MCP Introduction](https://modelcontextprotocol.io/introduction)
- [MCP Specification](https://spec.modelcontextprotocol.io)

### Enterprise Deployment

- [Claude on Amazon Bedrock](https://docs.anthropic.com/en/api/claude-on-amazon-bedrock)
- [Claude on Vertex AI](https://docs.anthropic.com/en/api/claude-on-vertex-ai)
- [Anthropic Trust Center](https://trust.anthropic.com)

---

## Domain 1 - Advanced Architectures

### Orchestrator-Worker Pattern

A parent agent receives a task, decomposes it into parallelizable sub-tasks, dispatches each to a worker (often Haiku for cost), and aggregates results. Use when:

- The task can be split into independent units (research across many sources, code review across files)
- Workers do not need shared state mid-task
- Parallelism pays for the orchestration overhead

Anti-pattern: using orchestrator-worker when a single tool-use loop on Sonnet finishes in the same wall clock time at half the token cost.

### Planner-Executor Pattern

Opus plans, Sonnet or Haiku executes. Planner produces an explicit plan (often as structured output), executor runs each step. Good when planning is expensive but execution is cheap and verifiable.

### Swarm / Peer Pattern

Multiple peer agents with complementary specialties communicate. Rare in production - coordination overhead usually costs more than it saves. Prefer orchestrator-worker.

### Single-Agent Tool Loop

One Claude instance with a rich tool set, looped until a stop condition. Still the default choice for most agentic workloads. Multi-agent is an optimization, not a starting point.

### Bounding Agentic Loops

- Max iterations (typically 10-50 for user-facing, 100-500 for batch)
- Max tokens per run
- Max wall-clock time
- Circuit breakers on repeated tool errors
- Budget enforcement per trace

---

## Domain 2 - Context Engineering and Extended Thinking

### Context Window Economics

Claude 4.x models support 200K tokens with 1M available in some configurations. Every token in context is paid for on every turn. Strategies:

- Cache the static prefix (system prompt, tool definitions, reference docs)
- Retrieve just-in-time rather than pre-loading
- Summarize old turns once they exceed a threshold
- Offload durable state to the memory tool
- Order: cache-eligible content first, then volatile content

### Extended Thinking

Claude 4.x models expose a `thinking` block with configurable budget.

- Enable via `thinking: {type: "enabled", budget_tokens: N}`
- Budget is a soft cap; Claude may stop thinking early
- Thinking tokens are billed at output rates
- Thinking blocks are returned in the response and must be preserved when continuing a turn (opaque `signature`)
- Interleaved thinking lets Claude think between tool calls

### When to Use Extended Thinking

- Complex multi-step reasoning (math, planning, difficult code)
- Tasks where a wrong answer is expensive
- Research and synthesis tasks
- NOT for: classification, simple rewrites, chit-chat

### Memory Tool

Client-side persistent memory Claude can read and write across sessions. Key patterns:

- User-scoped memory for personalization
- Project-scoped memory for long-running agents
- Treat memory as append-mostly; prune aggressively
- Memory content still counts toward context when loaded

---

## Domain 3 - Tool Use and MCP at Scale

### Tool Design at Scale

- Target under 20 tools per agent when possible; prune aggressively
- Group related tools behind a single dispatcher tool if the count explodes
- Descriptions are prompts - treat them with prompt-engineering rigor
- Use examples in descriptions when parameter semantics are non-obvious
- Return errors as structured content with `is_error: true`

### First-Party Tools

- code_execution - sandboxed Python runtime
- computer_use - mouse/keyboard/screenshot
- bash - shell execution (Claude Code and Agent SDK)
- text_editor - file editing primitive
- web_search - Anthropic-hosted search
- web_fetch - URL content retrieval
- memory - durable client-side memory

### MCP Transports

| Transport | Use Case |
|---|---|
| stdio | Local processes, CLIs, desktop apps |
| Streamable HTTP | Remote servers, cloud deployments (recommended) |
| SSE | Legacy remote transport (deprecated in favor of streamable HTTP) |

### MCP at Scale

- Multi-tenant MCP servers must enforce per-user auth (OAuth 2.1 for remote servers)
- Cache tool schemas in the client; do not refetch per request
- Apply timeouts per tool; surface timeouts as tool errors to Claude
- Version MCP servers; expose version in server metadata

---

## Domain 4 - Evaluation and Observability

### Eval Types

- Unit evals - deterministic, string/regex/schema checks
- LLM-as-judge - Claude grades Claude's output against a rubric
- Human-in-the-loop - SMEs grade a sample
- A/B diff evals - run old and new prompts side by side on held-out set

### Observability Signals

- Per-request: input tokens, output tokens, thinking tokens, cache read/write tokens, latency, stop reason
- Per-trace: total cost, total tool calls, total iterations, final status
- Per-cohort: quality score trends, error rate, latency P50/P95/P99
- Alert on: quality drift, cost spike, cache hit rate drop

### Safety Patterns

- Input classifier (Haiku) for jailbreak detection upstream of Opus
- Output classifier for PII or policy violations
- Structured refusal handling (do not retry refusals as if they were errors)
- Prompt injection defense: separate system instructions from untrusted content with XML tags and explicit warnings

---

## Domain 5 - Cost, Latency, Throughput

### Prompt Caching Layers

- 5-minute ephemeral cache (default)
- 1-hour cache for long-lived prefixes
- Cache breakpoints: up to 4 per request
- Cache hit reads are ~90% cheaper than input tokens
- Cache writes cost ~25% more than input tokens - only cache if you will read 2+ times

### Batch API

- 50% discount vs real-time
- 24-hour SLA
- Up to 100K requests or 256MB per batch
- Use for: backfills, nightly evals, offline enrichment
- Do NOT use for: user-facing requests, sub-hour SLAs

### Model Routing

Route cheap-to-classify tasks to Haiku 4.5, general work to Sonnet 4.6, deep reasoning to Opus 4.6. A common pattern: Haiku triages, Sonnet executes, Opus only when Sonnet flags low confidence.

### Streaming

Reduces perceived latency but does not reduce total latency. Always stream for interactive UX. Stream tool calls when possible; Claude emits `input_json_delta` events as tool arguments are built.

---

## Domain 6 - Enterprise Deployment

### Amazon Bedrock

- Regional model IDs (e.g., `anthropic.claude-sonnet-4-6-20260101-v1:0`)
- IAM-based auth, no Anthropic API key
- PrivateLink for VPC-only traffic
- Bedrock Guardrails layered on top
- CloudTrail for audit logging
- Cross-region inference profiles for capacity

### Google Cloud Vertex AI

- Publisher model IDs (e.g., `claude-sonnet-4-6@20260101`)
- IAM and service account auth
- VPC Service Controls for data exfiltration protection
- Cloud Logging and Cloud Monitoring native integration
- Regional endpoints; check per-model availability

### Compliance Posture

- SOC 2 Type II, ISO 27001, ISO 42001
- HIPAA eligible on BAA (first-party API and Bedrock)
- Zero data retention (ZDR) available for qualified customers
- EU AI Act GPAI obligations apply; document your downstream use

---

## Exam Tips

### Likely High-Yield Topics

1. Orchestrator-worker vs single-agent tradeoffs
2. Extended thinking token accounting and preservation
3. Prompt caching breakpoints and TTLs
4. Tool description design for large toolsets
5. MCP streamable HTTP vs stdio vs SSE
6. LLM-as-judge eval design
7. Bedrock vs Vertex vs first-party selection criteria
8. Batch API economics vs real-time
9. Memory tool lifecycle
10. Prompt injection defense patterns

### Common Traps

1. Defaulting to multi-agent when a single loop is cheaper
2. Caching content that is never re-read
3. Forgetting to preserve thinking signatures on turn continuation
4. Assuming Bedrock model IDs match Anthropic API IDs
5. Conflating memory tool with prompt caching
6. Using Batch API for user-facing paths
7. Over-tooling agents past ~20 tools
8. Treating refusals as retryable errors
9. Ignoring cache write cost when designing breakpoints
10. Using SSE transport for new MCP deployments

---

## High-Yield Study Sequence

1. Re-read the Anthropic engineering blog posts on multi-agent research and Claude Code
2. Complete the Anthropic Academy advanced tracks
3. Build one orchestrator-worker agent end to end with evals
4. Deploy the same workload to Bedrock and Vertex; feel the diffs
5. Run a cost audit: cache hit rate, thinking ratio, tool-call count
6. Walk through scenarios.md under timed conditions
