# Claude Architect Advanced - Self-Directed Study Track

> ℹ️ **Study track, not an official certification.** Anthropic does not currently run an official certification program. This is a self-directed proficiency track for senior engineers who design, build, and operate large-scale production systems on top of Claude.

## Track Overview

This advanced track is for architects and senior engineers who already ship Claude-powered products. Where the [Foundations track](../claude-certified-architect-foundations/) covers baseline fluency, this track validates your ability to make the deep tradeoff decisions that differentiate a hobby project from a resilient, compliant, multi-tenant production platform.

Material is grounded in Anthropic's published guidance: the Messages API reference, prompt engineering guide, tool use guide, extended thinking guide, prompt caching guide, Batch API guide, Files API guide, Claude Agent SDK documentation, and the Model Context Protocol (MCP) specification. It also reflects public guidance for running Claude on Amazon Bedrock and Google Cloud Vertex AI.

This track targets AI engineers, solutions architects, staff-level software engineers, and platform leads. It is not a beginner track.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Track Name** | Claude Architect Advanced |
| **Provider** | Self-directed (Anthropic-focused) |
| **Skill Level** | Senior / Advanced |
| **Recommended study time** | 6 weeks (2-3 hr/day) |
| **Format** | Scenario and case-study self-assessment items provided in this guide |
| **Prerequisites** | Foundations track recommended; 12+ months production Claude experience |
| **Primary sources** | [docs.anthropic.com](https://docs.anthropic.com), Claude Agent SDK docs, MCP spec, Anthropic Cookbook |

---

## Target Audience

This track is intended for people who already ship Claude-powered products. You should be comfortable with:

- Designing multi-agent and single-agent architectures under cost and latency SLOs
- Integrating Claude with retrieval systems at scale (vector, hybrid, reranked RAG)
- Building and operating MCP servers, tool pipelines, and streaming clients
- Running Claude behind Amazon Bedrock, Google Cloud Vertex AI, or the first-party Anthropic API
- Writing evaluations, tracking regressions, and managing model upgrades (e.g., Sonnet 4.5 to Sonnet 4.6)
- Reasoning about extended thinking budgets, prompt caching layers, batch API economics, and context engineering

If you are still learning the Messages API or the basics of MCP, start with the [Foundations track](../claude-certified-architect-foundations/) first.

---

## Skill Areas

| # | Skill Area | Suggested Weight | Focus |
|---|---|---|---|
| 1 | Advanced Architectures and Multi-Agent Systems | 22% | Orchestrator-worker, planner-executor, swarms |
| 2 | Context Engineering and Extended Thinking | 18% | Long context, memory tool, thinking budgets |
| 3 | Tool Use and MCP at Scale | 17% | Tool design, MCP servers, code execution, computer use |
| 4 | Evaluation, Observability, and Safety | 15% | Eval harnesses, tracing, guardrails, red-teaming |
| 5 | Cost, Latency, and Throughput Optimization | 15% | Caching, batch API, routing, model tiering |
| 6 | Enterprise Deployment (Bedrock, Vertex, VPC) | 13% | Private networking, compliance, residency |

---

## Skill Area Summaries

### 1 - Advanced Architectures and Multi-Agent Systems

Designing systems where multiple Claude agents cooperate or where a single agent runs long-horizon tool-use loops. Know when orchestrator-worker patterns beat a single super-agent, how to bound recursion and iteration, and how to budget tokens across sub-agents. Understand the Claude Agent SDK primitives (agents, subagents, skills, hooks) and when to compose them manually vs. use the SDK.

### 2 - Context Engineering and Extended Thinking

Modern Claude models support large context windows, extended thinking, and the memory tool. Advanced architects must know how to shape context deliberately: which content gets cached, which is retrieved per turn, which is summarized, and which is offloaded to memory. Understand extended thinking token accounting, interleaved thinking during tool use, and when interleaved thinking is worth its cost.

### 3 - Tool Use and MCP at Scale

Tool design, MCP server design, and emerging first-party tools (code execution, computer use, web search, web fetch, bash, text editor, files). Understand parallel tool use, forced tool choice, and how to structure tool definitions so a 30-tool agent still picks correctly. Know MCP transports (stdio, streamable HTTP), authentication patterns (OAuth 2.1), and multi-tenant MCP deployment.

### 4 - Evaluation, Observability, and Safety

Building LLM evals that track quality across model upgrades. Know how to design task-specific evals, LLM-as-judge pipelines, regression gates, and red-team suites. Observability: tracing agents, correlating tool calls with token costs, alerting on quality drift. Safety: Claude's constitutional AI principles, refusals, jailbreak resilience, and PII handling.

### 5 - Cost, Latency, and Throughput Optimization

Prompt caching (ephemeral and 1-hour), the Batch API (50% discount, 24-hour window), model routing between Opus 4.6, Sonnet 4.6, and Haiku 4.5, streaming for perceived latency, parallel tool use, and speculative decoding patterns. Know how to profile an agent and find the 80% cost reduction.

### 6 - Enterprise Deployment (Bedrock, Vertex, VPC)

Deploying Claude through Amazon Bedrock (including Bedrock Agents and Guardrails), Google Cloud Vertex AI, and direct API with private networking. Data residency, HIPAA eligibility, SOC 2, ISO 27001, EU AI Act considerations, customer-managed keys, and audit logging.

---

## Official Resources

| Resource | URL |
|---|---|
| Anthropic Docs | https://docs.anthropic.com |
| Claude Agent SDK | https://docs.anthropic.com/en/api/agent-sdk/overview |
| Extended Thinking | https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking |
| Prompt Caching | https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching |
| Batch API | https://docs.anthropic.com/en/docs/build-with-claude/batch-processing |
| Files API | https://docs.anthropic.com/en/docs/build-with-claude/files |
| Tool Use | https://docs.anthropic.com/en/docs/build-with-claude/tool-use |
| Computer Use | https://docs.anthropic.com/en/docs/build-with-claude/computer-use |
| Code Execution | https://docs.anthropic.com/en/docs/build-with-claude/tool-use/code-execution-tool |
| Memory Tool | https://docs.anthropic.com/en/docs/build-with-claude/tool-use/memory-tool |
| MCP Spec | https://modelcontextprotocol.io |
| Claude on Bedrock | https://docs.anthropic.com/en/api/claude-on-amazon-bedrock |
| Claude on Vertex | https://docs.anthropic.com/en/api/claude-on-vertex-ai |
| Anthropic Cookbook | https://github.com/anthropics/anthropic-cookbook |
| Anthropic Academy | https://anthropic.skilljar.com |

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Deep reference with links and high-yield facts |
| [notes/01-advanced-claude-architectures.md](notes/01-advanced-claude-architectures.md) | Multi-agent, RAG-at-scale, orchestrator patterns |
| [notes/02-claude-agent-sdk-deep-dive.md](notes/02-claude-agent-sdk-deep-dive.md) | Agent SDK primitives, skills, hooks |
| [notes/03-extended-thinking-and-context-management.md](notes/03-extended-thinking-and-context-management.md) | Thinking budgets, memory tool, context shaping |
| [notes/04-tool-use-and-mcp-integration.md](notes/04-tool-use-and-mcp-integration.md) | Advanced tool design, MCP at scale |
| [notes/05-evaluation-and-observability.md](notes/05-evaluation-and-observability.md) | Evals, tracing, LLM-as-judge, regressions |
| [notes/06-cost-latency-optimization-at-scale.md](notes/06-cost-latency-optimization-at-scale.md) | Caching, batch, routing, streaming |
| [notes/07-enterprise-deployment-bedrock-vertex.md](notes/07-enterprise-deployment-bedrock-vertex.md) | Bedrock, Vertex, VPC, compliance |
| [practice-plan.md](practice-plan.md) | 6-week advanced study plan |
| [scenarios.md](scenarios.md) | 10 exam-style scenario questions with explanations |
| [strategy.md](strategy.md) | Exam-day tactics and time management |

---

## Study Approach

1. Anchor to primary sources. Treat docs.anthropic.com, the Anthropic Cookbook, and the MCP specification as ground truth. Community blog posts age quickly.
2. Build, do not just read. Reproduce the patterns Anthropic emphasizes in its official engineering blog posts and cookbook recipes.
3. Track model versions. Advanced material differentiates Opus, Sonnet, and Haiku tradeoffs. Know current IDs: claude-opus-4-7, claude-sonnet-4-6, claude-haiku-4-5.
4. Understand both the first-party API and the cloud deployments. Bedrock and Vertex quirks (model IDs, regional availability, IAM) matter at this tier.

---

## Suggested Learning Progression

```
Foundations track   →   Advanced track   (you are here)
```

Companion tracks in this repo:

- [Claude Application Developer](../claude-application-developer/) - production API/SDK depth
- [Prompt Engineering Specialist](../claude-prompt-engineering-specialist/) - prompt design and evaluation

The advanced material rewards engineers who have felt the pain of a 3am agent loop burning tokens - and fixed it.
