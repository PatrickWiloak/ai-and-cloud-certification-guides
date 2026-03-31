# CCA-F Study Strategy

## Overview

This document outlines a 3-phase study approach for the Claude Certified Architect - Foundations (CCA-F) exam. The strategy is designed for someone with 6+ months of production Claude experience who wants to systematically prepare over 4 weeks.

---

## Phase 1 - Foundation Building (Week 1-2)

### Goal
Build a solid understanding of all five exam domains through official documentation and Anthropic Academy courses.

### Activities

**Week 1 - API Fundamentals and Prompt Engineering**

1. Complete Anthropic Academy courses:
   - Claude 101
   - AI Fluency Framework and Foundations
   - Building Applications with Claude API
   - Prompt Engineering with Claude

2. Read core documentation:
   - **[Getting Started](https://docs.anthropic.com/en/docs/initial-setup)** - API setup and first request
   - **[Messages API](https://docs.anthropic.com/en/api/messages)** - Core API reference
   - **[Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)** - Official best practices
   - **[Structured Output](https://docs.anthropic.com/en/docs/build-with-claude/tool-use#json-mode)** - JSON extraction patterns

3. Hands-on practice:
   - Make 20+ API calls with different prompt structures
   - Experiment with system prompts, XML tags, and chain-of-thought
   - Practice extracting structured JSON from unstructured text
   - Build a simple prompt that uses few-shot examples

**Week 2 - Tools, MCP, and Claude Code**

1. Complete Anthropic Academy courses:
   - Introduction to Model Context Protocol
   - Tool Use with Claude
   - Claude Code Fundamentals

2. Read core documentation:
   - **[Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Function calling with Claude
   - **[MCP Documentation](https://modelcontextprotocol.io/introduction)** - Protocol fundamentals
   - **[Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)** - CLI and IDE integration
   - **[CLAUDE.md Files](https://docs.anthropic.com/en/docs/claude-code/memory)** - Project configuration

3. Hands-on practice:
   - Define and use 3-5 custom tools via the API
   - Build a simple MCP server with at least 2 tools
   - Set up Claude Code with a CLAUDE.md file
   - Configure custom slash commands and hooks

### Key Deliverables for Phase 1
- All foundational Anthropic Academy courses completed
- Comfortable making API calls with tools
- Working MCP server
- Claude Code configured for a real project

---

## Phase 2 - Deep Dive and Practice (Week 3)

### Goal
Go deep on the highest-weighted domains (Agentic Architecture at 27%) and build practical experience with production patterns.

### Activities

**Agentic Architecture Deep Dive**

1. Complete Anthropic Academy courses:
   - Building Agentic Applications
   - Multi-Agent Systems
   - Production AI Systems

2. Read and study:
   - **[Agentic Patterns Guide](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - Official agentic documentation
   - **[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Reasoning mode
   - **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Cost optimization
   - **[Anthropic Cookbook - Agents](https://github.com/anthropics/anthropic-cookbook)** - Code examples

3. Build an agentic project:
   - Implement a plan-execute-reflect loop
   - Add error handling and recovery
   - Implement a supervisor pattern with multiple sub-agents
   - Measure and optimize cost and latency

**Context and Reliability Patterns**

1. Study:
   - **[Long Context Tips](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching#long-context-tips)** - Managing large contexts
   - **[Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)** - API limits and handling
   - **[Streaming](https://docs.anthropic.com/en/docs/build-with-claude/streaming)** - Real-time responses
   - **[Error Handling](https://docs.anthropic.com/en/api/errors)** - API error codes and recovery

2. Practice reliability patterns:
   - Implement exponential backoff with jitter
   - Build a validation loop that checks Claude's output
   - Create a fallback chain (Claude 3.5 Sonnet -> Claude 3.5 Haiku)
   - Implement context summarization for long conversations

### Key Deliverables for Phase 2
- Working agentic application with error handling
- Understanding of all production reliability patterns
- Ability to explain cost/latency tradeoffs for different architectures

---

## Phase 3 - Review and Exam Prep (Week 4)

### Goal
Consolidate knowledge, practice exam-style questions, and fill any remaining gaps.

### Activities

**Practice Exams and Scenarios**

1. Work through all scenarios in [scenarios.md](scenarios.md)
2. For each scenario:
   - Read the scenario without looking at the answer
   - Write your solution approach
   - Compare with the provided solution
   - Note any gaps in your understanding
3. Time yourself - aim for under 2 minutes per question

**Gap Analysis**

1. Review the [fact-sheet.md](fact-sheet.md) end to end
2. For each concept you are unsure about:
   - Go back to the relevant documentation
   - Build a quick hands-on example
   - Write a brief explanation in your own words
3. Focus extra time on Domain 1 (Agentic Architecture) - it is 27% of the exam

**Final Review Checklist**

- [ ] Can explain when to use agents vs simple prompts
- [ ] Can design a multi-agent system with supervisor pattern
- [ ] Can configure CLAUDE.md files for a team project
- [ ] Can set up hooks and custom slash commands in Claude Code
- [ ] Can write effective system prompts with XML tags
- [ ] Can extract structured data using tool use
- [ ] Can design MCP servers with appropriate tools and resources
- [ ] Can explain MCP transport types and when to use each
- [ ] Can implement prompt caching for cost optimization
- [ ] Can describe reliability patterns for production Claude apps
- [ ] Can manage context windows for long-running conversations
- [ ] Can handle rate limits and API errors gracefully

### Key Deliverables for Phase 3
- All practice scenarios completed and reviewed
- No major knowledge gaps remaining
- Confidence in answering scenario-based questions under time pressure

---

## Resources by Priority

### Must-Have (Primary Study Material)

| Resource | Why |
|---|---|
| **[Anthropic Academy](https://anthropic.skilljar.com)** | Official training - closely aligned with exam |
| **[Anthropic Docs](https://docs.anthropic.com)** | Primary source of truth for all topics |
| **[MCP Specification](https://modelcontextprotocol.io)** | Required for Domain 4 |
| **[Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)** | Required for Domain 2 |

### Should-Have (Supplementary)

| Resource | Why |
|---|---|
| **[Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook)** | Practical code examples |
| **[Anthropic Blog](https://www.anthropic.com/news)** | Feature announcements and use cases |
| **[MCP Servers Repository](https://github.com/modelcontextprotocol/servers)** | Reference MCP server implementations |

### Nice-to-Have (Extra Practice)

| Resource | Why |
|---|---|
| **[Claude API SDK (Python)](https://github.com/anthropics/anthropic-sdk-python)** | SDK source and examples |
| **[Claude API SDK (TypeScript)](https://github.com/anthropics/anthropic-sdk-node)** | SDK source and examples |
| **[Claude Code Source](https://github.com/anthropics/claude-code)** | Understanding Claude Code internals |

---

## Exam Day Tactics

### Before the Exam

1. **Environment check** - Test your ProctorFree setup 24 hours before
2. **Quiet space** - Online proctoring requires a clean, quiet room
3. **ID ready** - Have government-issued ID available
4. **Rest** - Get a full night's sleep. Cramming the night before does not help with scenario-based exams.

### During the Exam

1. **First pass (70 minutes)** - Answer all questions you are confident about. Flag uncertain ones.
2. **Second pass (40 minutes)** - Return to flagged questions. Eliminate wrong answers first.
3. **Final review (10 minutes)** - Check for any unanswered questions or obvious mistakes.

### Question Strategy

- **Read the full scenario** - Important constraints are often in the last sentence
- **Identify the domain** - Knowing which domain a question targets helps frame your answer
- **Look for "best" vs "correct"** - Multiple answers may work; choose the most appropriate one
- **Production mindset** - Anthropic favors reliable, cost-effective, maintainable solutions
- **Beware of over-engineering** - If a simple prompt works, don't choose the agentic solution
- **Watch for MCP vs API tool use confusion** - These are different mechanisms for similar goals

### Common Pitfalls

1. **Choosing agents when simple prompts suffice** - Agents add complexity. Only use them when multi-step reasoning with tool use is required.
2. **Confusing MCP servers and clients** - Claude is an MCP client. Your application provides MCP servers.
3. **Ignoring cost implications** - Extended thinking and large context windows cost more. The exam tests cost awareness.
4. **Forgetting prompt caching** - For repeated prompts with static prefixes, caching reduces cost by up to 90%.
5. **Over-relying on temperature settings** - Claude's default temperature (1.0) is usually fine. The exam tests when and why to adjust it.
6. **Mixing up tool choice modes** - Know the difference between auto, any, and specific tool forcing.
7. **Neglecting error handling** - Production systems need retry logic, fallbacks, and graceful degradation.
8. **Misunderstanding CLAUDE.md precedence** - User-level, project-level, and directory-level CLAUDE.md files have specific precedence rules.

---

## Progress Tracking

Use the [practice-plan.md](practice-plan.md) file for detailed week-by-week tracking with checkboxes.

### Milestone Checklist

- [ ] Phase 1 complete - Foundation courses and docs reviewed
- [ ] Phase 2 complete - Agentic project built, reliability patterns understood
- [ ] Phase 3 complete - All scenarios practiced, gaps filled
- [ ] Exam scheduled
- [ ] Exam passed
