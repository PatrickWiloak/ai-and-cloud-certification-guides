# Claude Application Developer - Self-Directed Study Track

> ℹ️ **Study track, not an official certification.** Anthropic does not currently run an official certification program. This is a self-directed proficiency track for developers who build production applications on the Claude API.

## Track Overview

This track covers the skills needed to build, ship, and maintain production applications on the Claude API. Where the Architect tracks focus on system design, this track focuses on the developer surface: the Messages API, streaming, tool use, prompt caching, the Batch API, the Files API, citations, error handling, and the Python and TypeScript SDKs.

Material is grounded in Anthropic's published API docs and SDK references.

This track targets backend engineers, full-stack developers, and AI engineers who write code against the Claude API daily. It assumes general programming fluency in Python or TypeScript and basic familiarity with HTTP, JSON, and async programming.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Track Name** | Claude Application Developer |
| **Provider** | Self-directed (Anthropic-focused) |
| **Skill Level** | Mid-level / Associate-equivalent |
| **Recommended study time** | 5 weeks (2-3 hr/day) |
| **Format** | 60-70 scenario and code-reading self-assessment items provided in this guide |
| **Prerequisites** | 6+ months building with the Claude API |
| **Primary sources** | [docs.anthropic.com](https://docs.anthropic.com), Python and TypeScript SDK repos, Anthropic Cookbook |

---

## Target Audience

Build this skill set if you:

- Ship features that call the Messages API
- Write prompt caching, streaming, or tool-use code by hand
- Maintain production retry, rate limit, and error handling logic
- Use the Files API for PDFs, images, or large documents
- Work with the Python or TypeScript SDKs daily

---

## Skill Areas

| # | Skill Area | Suggested Weight | Focus |
|---|---|---|---|
| 1 | Messages API and Streaming | 22% | Request/response, streaming events |
| 2 | Tool Use and Function Calling | 20% | Tools, parallel tools, structured output |
| 3 | Prompt Caching and Batch API | 16% | Cache breakpoints, batching economics |
| 4 | Files API, Citations, and Multimodal | 14% | PDFs, images, citations |
| 5 | Error Handling, Rate Limits, Retries | 14% | 429, 5xx, idempotency, backoff |
| 6 | SDKs (Python, TypeScript, CLI) | 14% | Idioms, async, streaming, helpers |

---

## Skill Area Summaries

### 1 - Messages API and Streaming

The core API. Know the request and response shapes, the role of system vs user vs assistant messages, content blocks (text, image, tool_use, tool_result, thinking), streaming SSE event types (`message_start`, `content_block_start`, `content_block_delta`, `content_block_stop`, `message_delta`, `message_stop`), and how to assemble streamed responses correctly.

### 2 - Tool Use and Function Calling

Tool definitions, tool_choice modes (auto, any, tool, none), the tool_use / tool_result lifecycle, parallel tool use, structured output via forced tool choice, and idiomatic patterns for composing tool loops.

### 3 - Prompt Caching and Batch API

Prompt caching mechanics (`cache_control`, breakpoints, TTLs, write/read economics, minimum sizes), and the Batch API workflow (create batch, poll status, retrieve results, error handling per item, 50% discount, 24h SLA).

### 4 - Files API, Citations, and Multimodal

Uploading and referencing files, image input, PDF support, and the citations feature for grounded responses with source attribution.

### 5 - Error Handling, Rate Limits, Retries

API error codes (400, 401, 403, 404, 429, 500, 529), rate limit headers, exponential backoff with jitter, idempotency keys, retry budgets, and circuit breakers.

### 6 - SDKs

Python SDK (`anthropic`), TypeScript SDK (`@anthropic-ai/sdk`), CLI patterns, async clients, streaming helpers, the Bedrock and Vertex sub-packages, and SDK error types.

---

## Official Resources

| Resource | URL |
|---|---|
| Anthropic Docs | https://docs.anthropic.com |
| Messages API | https://docs.anthropic.com/en/api/messages |
| Streaming | https://docs.anthropic.com/en/api/messages-streaming |
| Tool Use | https://docs.anthropic.com/en/docs/build-with-claude/tool-use |
| Prompt Caching | https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching |
| Batch API | https://docs.anthropic.com/en/docs/build-with-claude/batch-processing |
| Files API | https://docs.anthropic.com/en/docs/build-with-claude/files |
| Citations | https://docs.anthropic.com/en/docs/build-with-claude/citations |
| Vision | https://docs.anthropic.com/en/docs/build-with-claude/vision |
| PDF Support | https://docs.anthropic.com/en/docs/build-with-claude/pdf-support |
| Errors | https://docs.anthropic.com/en/api/errors |
| Rate Limits | https://docs.anthropic.com/en/api/rate-limits |
| Python SDK | https://github.com/anthropics/anthropic-sdk-python |
| TypeScript SDK | https://github.com/anthropics/anthropic-sdk-typescript |
| Anthropic Cookbook | https://github.com/anthropics/anthropic-cookbook |

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Reference with API shapes and high-yield facts |
| [notes/01-claude-api-fundamentals.md](notes/01-claude-api-fundamentals.md) | Auth, models, request shape |
| [notes/02-messages-api-and-streaming.md](notes/02-messages-api-and-streaming.md) | Messages API, streaming events |
| [notes/03-tool-use-function-calling.md](notes/03-tool-use-function-calling.md) | Tool use lifecycle, parallel, forced choice |
| [notes/04-prompt-caching-and-batch-api.md](notes/04-prompt-caching-and-batch-api.md) | Caching mechanics, batch workflow |
| [notes/05-files-api-citations-and-pdfs.md](notes/05-files-api-citations-and-pdfs.md) | Files, PDFs, citations, multimodal |
| [notes/06-error-handling-rate-limits-retries.md](notes/06-error-handling-rate-limits-retries.md) | Errors, retries, backoff, idempotency |
| [notes/07-sdks-python-typescript-and-cli.md](notes/07-sdks-python-typescript-and-cli.md) | SDK idioms across Python and TypeScript |
| [practice-plan.md](practice-plan.md) | 5-week plan with hands-on exercises |
| [scenarios.md](scenarios.md) | 10 exam-style scenarios |
| [strategy.md](strategy.md) | Exam-day tactics |

---

## Study Approach

1. Build first, read second. Every skill area has a hands-on path. Write the code.
2. Use the latest SDK. Old SDK versions hide modern features.
3. Track release notes. Anthropic ships fast; new features (memory tool, files, citations, code execution) become relevant material quickly.
4. Use real model IDs: `claude-opus-4-7`, `claude-sonnet-4-6`, `claude-haiku-4-5`.

The fastest way to internalize this material is to ship something real with the Claude API and feel each feature in production.

---

## Companion Tracks

- [Foundations](../claude-certified-architect-foundations/) - architectural fundamentals
- [Architect Advanced](../claude-certified-architect-advanced/) - multi-agent systems, RAG at scale, enterprise deployment
- [Prompt Engineering Specialist](../claude-prompt-engineering-specialist/) - prompt design and evaluation
