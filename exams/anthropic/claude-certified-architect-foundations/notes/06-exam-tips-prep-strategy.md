# Exam Tips & Preparation Strategy

## Overview

This file consolidates exam preparation tips, the complete list of Anthropic Academy courses, recommended practice projects, and strategies for approaching scenario-based questions on the CCA-F exam.

---

## Anthropic Academy Courses (Skilljar)

All courses are free and available at **[anthropic.skilljar.com](https://anthropic.skilljar.com)**

Complete all 13 courses before taking the exam. They are the closest thing to official exam prep material.

### Course List

| # | Course Name | Relevant Domain(s) |
|---|---|---|
| 1 | Claude 101 | All domains (foundational) |
| 2 | AI Fluency Framework and Foundations | All domains (foundational) |
| 3 | Building Applications with Claude API | Domain 3, Domain 5 |
| 4 | Prompt Engineering with Claude | Domain 3 |
| 5 | Introduction to Model Context Protocol | Domain 4 |
| 6 | Tool Use with Claude | Domain 4, Domain 3 |
| 7 | Claude Code Fundamentals | Domain 2 |
| 8 | Advanced Claude Code | Domain 2, Domain 1 |
| 9 | Building Agentic Applications | Domain 1 |
| 10 | Multi-Agent Systems | Domain 1 |
| 11 | Production AI Systems | Domain 1, Domain 5 |
| 12 | Responsible AI with Claude | All domains |
| 13 | Claude for Enterprise Teams | Domain 2, Domain 5 |

### Recommended Course Order

1. Start with Claude 101 and AI Fluency Framework (general foundation)
2. Move to Building Applications with Claude API and Prompt Engineering (Domain 3)
3. Then Tool Use with Claude and Introduction to MCP (Domain 4)
4. Then Claude Code Fundamentals and Advanced Claude Code (Domain 2)
5. Then Building Agentic Applications, Multi-Agent Systems, Production AI Systems (Domain 1)
6. Finish with Responsible AI and Enterprise Teams (cross-cutting)

---

## Recommended Hands-On Practice Projects

### Project 1 - Structured Data Extraction Pipeline

Build a system that processes unstructured text (emails, documents) and extracts structured JSON.

Skills practiced:
- Tool use for structured output
- Prompt engineering (system prompts, XML tags, few-shot examples)
- Prompt caching for repeated schema definitions
- Error handling for invalid extractions

### Project 2 - MCP Server for a Database

Build an MCP server that exposes a database (SQLite or PostgreSQL) as tools and resources.

Skills practiced:
- MCP server development (tools and resources)
- Tool design best practices
- Transport selection (stdio)
- Connecting MCP server to Claude Code

### Project 3 - Agentic Research Assistant

Build an agent that can search the web, read documents, and write a summary report with citations.

Skills practiced:
- Agentic design patterns (tool use loop, plan-execute-reflect)
- Multi-step reasoning
- Error handling and recovery
- Context management for long tasks
- Cost optimization

### Project 4 - Claude Code Team Configuration

Set up Claude Code for a team project with shared configuration.

Skills practiced:
- CLAUDE.md file hierarchy
- Hooks for code quality
- Custom slash commands
- MCP server configuration
- Permissions model

### Project 5 - Production-Ready Chat Application

Build a multi-turn chat application with reliability patterns.

Skills practiced:
- Context window management (summarization, sliding window)
- Prompt caching for system prompts
- Streaming responses
- Rate limit handling
- Fallback models
- Error handling

---

## Key Concepts That Appear Frequently

Based on the exam domains and their weights, these concepts are most likely to appear:

### Must-Know (Appears in multiple questions)

1. **Agentic vs simple prompt decision** - Know exactly when an agent is appropriate
2. **CLAUDE.md hierarchy** - User, project, and directory levels
3. **Tool choice modes** - auto, any, and specific tool forcing
4. **MCP architecture** - Client/server roles, transport types
5. **Prompt caching** - Requirements, TTL, cost savings
6. **Structured output via tool use** - The preferred extraction method
7. **Extended thinking** - When to use it, cost/latency tradeoffs
8. **Error handling** - Both API errors and tool errors
9. **Supervisor pattern** - Multi-agent orchestration
10. **XML tags in prompts** - Organizing complex prompts

### Should-Know (Appears in some questions)

1. Rate limit headers and 429 handling
2. Streaming event types
3. Parallel tool use
4. MCP resources vs tools
5. Few-shot vs many-shot prompting
6. Context window management strategies
7. Hooks system (PreToolUse, PostToolUse)
8. Custom slash commands
9. Token counting
10. Circuit breaker pattern

### Nice-to-Know (Edge cases)

1. MCP sampling (server-initiated LLM calls)
2. MCP prompts (reusable templates)
3. Computer use capabilities
4. Batch API for non-real-time workloads
5. Vision and PDF processing details

---

## Common Misconceptions

### Misconception 1: "Agents are always better than simple prompts"
**Reality:** Agents add complexity, cost, and latency. Use them only when the task requires dynamic multi-step reasoning with tools. Simple prompts are preferred for straightforward tasks.

### Misconception 2: "MCP servers are Claude"
**Reality:** Claude is an MCP client. Your application provides MCP servers. Claude connects to servers to use their tools and resources.

### Misconception 3: "Temperature 0 gives deterministic output"
**Reality:** Claude at temperature 0 is nearly deterministic but may still have slight variations. Do not assume perfectly identical outputs.

### Misconception 4: "Extended thinking is free"
**Reality:** Extended thinking tokens are billed. They add to both cost and latency. Use extended thinking when the quality improvement justifies the cost.

### Misconception 5: "Prompt caching works for all content"
**Reality:** Cached content must be at least 1024 tokens (2048 for Haiku). The cache expires after 5 minutes without a hit. Only static content should be cached.

### Misconception 6: "CLAUDE.md replaces documentation"
**Reality:** CLAUDE.md is for concise, actionable instructions that Claude needs to follow. It is not for documentation. Everything in CLAUDE.md consumes context tokens.

### Misconception 7: "All API errors should be retried"
**Reality:** Only some errors are retryable (429, 500, 529). Others (400, 401, 403) indicate client-side problems that retrying will not fix.

### Misconception 8: "MCP tools and API tools are the same thing"
**Reality:** API tool use defines tools in the API request (your app executes them). MCP tools are defined on MCP servers (the server executes them). Both allow Claude to call functions, but the architecture is different.

---

## How to Approach Scenario-Based Questions

### Step 1 - Read the Full Scenario

Do not skim. Important constraints and requirements are often in the last sentence or buried in the middle. Look for:
- Specific requirements (real-time, cost-sensitive, high-volume)
- Constraints (read-only, no human oversight, team of N developers)
- Scale indicators (10,000 requests/day, 50+ message conversations)

### Step 2 - Identify the Domain

Knowing which domain a question targets helps frame your thinking:
- Mentions agents, multi-step, orchestration - Domain 1
- Mentions CLAUDE.md, hooks, settings, IDE - Domain 2
- Mentions prompts, JSON output, XML tags, caching - Domain 3
- Mentions MCP, tools, function calling, schemas - Domain 4
- Mentions context window, retries, streaming, rate limits - Domain 5

### Step 3 - Eliminate Wrong Answers

Most questions have 1-2 obviously wrong answers:
- Over-engineered solutions (agent for a simple task)
- Security anti-patterns (raw SQL, no auth)
- Missing key requirements (ignoring stated constraints)
- Wrong MCP/tool concepts (reversed client/server roles)

### Step 4 - Choose the Best Answer

Between remaining options, prefer:
- The solution that meets ALL stated requirements
- The simplest solution that works (no over-engineering)
- The most production-appropriate option
- The approach aligned with official documentation and best practices
- The cost-effective option when cost is mentioned

### Step 5 - Time Management

- 120 minutes for 60 questions = 2 minutes per question
- Do not spend more than 3 minutes on any single question
- Flag uncertain questions and return to them
- Trust your first instinct when genuinely unsure

---

## Final Pre-Exam Checklist

- [ ] All 13 Anthropic Academy courses completed
- [ ] Built at least 2 hands-on projects
- [ ] Can explain all 5 domain topics without notes
- [ ] Completed all practice scenarios
- [ ] Reviewed the fact sheet
- [ ] ProctorFree environment tested
- [ ] Quiet room prepared for exam day
- [ ] Government ID ready
- [ ] Good night's sleep before exam day

---

## Related Resources

- **[Anthropic Academy](https://anthropic.skilljar.com)** - Free official courses
- **[Anthropic Documentation](https://docs.anthropic.com)** - Primary reference
- **[MCP Documentation](https://modelcontextprotocol.io)** - MCP protocol
- **[Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook)** - Code examples
- **[Anthropic Blog](https://www.anthropic.com/news)** - Latest updates
