# CCA-F - 4-Week Practice Plan

## Overview

This 4-week study plan is designed for someone with 6+ months of production Claude experience. Adjust the pace based on your background. Each week includes specific tasks, documentation to read, courses to complete, and hands-on exercises.

**Time commitment:** 2-3 hours per day, 5-6 days per week

---

## Week 1 - API Fundamentals & Prompt Engineering

**Focus:** Domains 3 (Prompt Engineering - 20%) and Domain 5 (Context & Reliability - 15%)

### Anthropic Academy Courses

- [ ] Complete "Claude 101" on Skilljar
- [ ] Complete "AI Fluency Framework and Foundations" on Skilljar
- [ ] Complete "Building Applications with Claude API" on Skilljar
- [ ] Complete "Prompt Engineering with Claude" on Skilljar

### Documentation Reading

- [ ] Read [Getting Started Guide](https://docs.anthropic.com/en/docs/initial-setup)
- [ ] Read [Messages API Reference](https://docs.anthropic.com/en/api/messages)
- [ ] Read [Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)
- [ ] Read [System Prompts Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts)
- [ ] Read [Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)
- [ ] Read [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [ ] Read [Streaming Guide](https://docs.anthropic.com/en/docs/build-with-claude/streaming)
- [ ] Read [Vision Guide](https://docs.anthropic.com/en/docs/build-with-claude/vision)
- [ ] Read [PDF Support](https://docs.anthropic.com/en/docs/build-with-claude/pdf-support)

### Hands-On Exercises

- [ ] Set up Anthropic API key and make first API call
- [ ] Write 5 different system prompts for different use cases
- [ ] Practice chain-of-thought prompting with 3 complex tasks
- [ ] Use XML tags to organize a multi-section prompt
- [ ] Implement few-shot prompting with 3+ examples
- [ ] Extract structured JSON from unstructured text (3 examples)
- [ ] Experiment with prompt caching on a repeated prompt
- [ ] Test extended thinking on a complex reasoning task
- [ ] Implement streaming for a real-time response

### Study Notes Review

- [ ] Review [notes/03-prompt-engineering-structured-output.md](notes/03-prompt-engineering-structured-output.md)
- [ ] Review [notes/05-context-reliability.md](notes/05-context-reliability.md)

### Week 1 Self-Assessment

Answer these questions without looking at notes:

- [ ] What is the difference between system prompts and user prompts?
- [ ] When should you use XML tags in prompts?
- [ ] How does prompt caching work and when should you use it?
- [ ] What is extended thinking and when is it beneficial?
- [ ] How do you handle streaming responses?
- [ ] What are the token limits for Claude's context window?

---

## Week 2 - Tool Use & MCP

**Focus:** Domain 4 (Tool Design & MCP Integration - 18%) and Domain 2 (Claude Code - 20%)

### Anthropic Academy Courses

- [ ] Complete "Introduction to Model Context Protocol" on Skilljar
- [ ] Complete "Tool Use with Claude" on Skilljar
- [ ] Complete "Claude Code Fundamentals" on Skilljar
- [ ] Complete "Advanced Claude Code" on Skilljar

### Documentation Reading

- [ ] Read [Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)
- [ ] Read [Tool Use Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/best-practices)
- [ ] Read [MCP Introduction](https://modelcontextprotocol.io/introduction)
- [ ] Read [MCP Core Architecture](https://modelcontextprotocol.io/docs/concepts/architecture)
- [ ] Read [MCP Tools](https://modelcontextprotocol.io/docs/concepts/tools)
- [ ] Read [MCP Resources](https://modelcontextprotocol.io/docs/concepts/resources)
- [ ] Read [MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)
- [ ] Read [Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)
- [ ] Read [Claude Code Memory (CLAUDE.md)](https://docs.anthropic.com/en/docs/claude-code/memory)
- [ ] Read [Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- [ ] Read [Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [ ] Read [Claude Code Slash Commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)

### Hands-On Exercises

- [ ] Define 3 tools and use them via the Messages API
- [ ] Implement parallel tool use in a single request
- [ ] Test all tool choice modes (auto, any, specific)
- [ ] Handle tool use errors gracefully
- [ ] Build a simple MCP server (TypeScript or Python) with 2+ tools
- [ ] Connect your MCP server to Claude Code
- [ ] Create a CLAUDE.md file for a real project
- [ ] Set up a pre-tool hook in Claude Code
- [ ] Create a custom slash command
- [ ] Configure Claude Code IDE integration (VS Code or JetBrains)

### Study Notes Review

- [ ] Review [notes/04-tool-design-mcp-integration.md](notes/04-tool-design-mcp-integration.md)
- [ ] Review [notes/02-claude-code-configuration.md](notes/02-claude-code-configuration.md)

### Week 2 Self-Assessment

- [ ] What are the three tool choice modes and when do you use each?
- [ ] What is the difference between MCP tools, resources, and prompts?
- [ ] What transport types does MCP support?
- [ ] How does the CLAUDE.md file hierarchy work?
- [ ] What are hooks and when would you use them?
- [ ] How do you handle errors from tool calls?

---

## Week 3 - Agentic Architecture & Claude Code Advanced

**Focus:** Domain 1 (Agentic Architecture - 27%) - the highest-weighted domain

### Anthropic Academy Courses

- [ ] Complete "Building Agentic Applications" on Skilljar
- [ ] Complete "Multi-Agent Systems" on Skilljar
- [ ] Complete "Production AI Systems" on Skilljar
- [ ] Complete "Responsible AI with Claude" on Skilljar

### Documentation Reading

- [ ] Read [Agentic Patterns](https://docs.anthropic.com/en/docs/build-with-claude/agentic)
- [ ] Read [Computer Use](https://docs.anthropic.com/en/docs/build-with-claude/computer-use)
- [ ] Read [Claude Code Best Practices](https://docs.anthropic.com/en/docs/claude-code/best-practices)
- [ ] Read [Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)
- [ ] Read [API Errors Reference](https://docs.anthropic.com/en/api/errors)
- [ ] Read [Anthropic Cookbook - Agentic examples](https://github.com/anthropics/anthropic-cookbook)
- [ ] Read [Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)
- [ ] Review [Claude Code MCP Configuration](https://docs.anthropic.com/en/docs/claude-code/mcp-servers)

### Hands-On Exercises

- [ ] Build an agentic workflow with a tool use loop
- [ ] Implement plan-execute-reflect pattern
- [ ] Add error handling and retry logic to your agent
- [ ] Build a multi-agent system with supervisor pattern
- [ ] Implement context summarization for a long-running agent
- [ ] Measure and optimize cost for an agentic workflow
- [ ] Set up Claude Code for a team project with shared CLAUDE.md
- [ ] Implement a production reliability pattern (fallback chain)
- [ ] Build an agent that knows when to stop and ask for clarification

### Study Notes Review

- [ ] Review [notes/01-agentic-architecture.md](notes/01-agentic-architecture.md)
- [ ] Re-review all previous notes for cross-domain connections

### Week 3 Self-Assessment

- [ ] When should you use an agent vs a simple prompt chain?
- [ ] What is the supervisor pattern and when is it appropriate?
- [ ] How do you handle errors in an agentic loop?
- [ ] What are the cost implications of extended thinking in agents?
- [ ] How do you prevent infinite loops in agentic systems?
- [ ] What is the plan-execute-reflect pattern?

---

## Week 4 - Practice Exams & Review

**Focus:** All domains - consolidation and gap filling

### Remaining Anthropic Academy Courses

- [ ] Complete any remaining Skilljar courses not yet finished
- [ ] Review course notes and key takeaways from all courses

### Practice and Review

- [ ] Complete all scenarios in [scenarios.md](scenarios.md)
- [ ] Time yourself on scenarios (aim for under 2 min per question)
- [ ] Review [fact-sheet.md](fact-sheet.md) end to end
- [ ] Re-read [strategy.md](strategy.md) exam day tactics section
- [ ] Review [notes/06-exam-tips-prep-strategy.md](notes/06-exam-tips-prep-strategy.md)

### Gap Analysis

- [ ] List topics where you feel least confident
- [ ] Re-read documentation for weak areas
- [ ] Build one more hands-on example for each weak area
- [ ] Write explanations of key concepts in your own words

### Domain-Specific Review

**Domain 1 - Agentic Architecture (27%)**
- [ ] Can design single and multi-agent architectures
- [ ] Know when to use agents vs simple prompts
- [ ] Understand production cost and latency tradeoffs
- [ ] Can implement error handling and recovery patterns

**Domain 2 - Claude Code Configuration (20%)**
- [ ] Know CLAUDE.md file hierarchy and precedence
- [ ] Can configure hooks, slash commands, and settings
- [ ] Understand permissions model
- [ ] Can set up MCP servers in Claude Code

**Domain 3 - Prompt Engineering & Structured Output (20%)**
- [ ] Can write effective system prompts
- [ ] Know when to use XML tags, chain-of-thought, few-shot
- [ ] Can extract structured JSON from unstructured text
- [ ] Understand prompt caching strategies

**Domain 4 - Tool Design & MCP Integration (18%)**
- [ ] Can design tools with proper schemas and descriptions
- [ ] Understand MCP architecture and transport types
- [ ] Can build MCP servers with tools and resources
- [ ] Know tool choice modes and parallel tool use

**Domain 5 - Context & Reliability (15%)**
- [ ] Understand context window management strategies
- [ ] Can implement reliability patterns (retries, fallbacks)
- [ ] Know extended thinking capabilities and tradeoffs
- [ ] Can handle rate limits and API errors

### Exam Logistics

- [ ] Schedule exam through ProctorFree
- [ ] Test ProctorFree setup and environment
- [ ] Prepare quiet, clean room for proctoring
- [ ] Have government ID ready
- [ ] Get a good night's sleep before exam day

---

## Daily Study Template

Use this template for each study session:

```
Date: ___________
Time spent: ___________
Topics covered:
- [ ] ___________
- [ ] ___________
- [ ] ___________

Key takeaways:
1. ___________
2. ___________
3. ___________

Questions to research:
1. ___________
2. ___________

Confidence level (1-5): ___
```

---

## Progress Summary

| Week | Focus | Status |
|---|---|---|
| Week 1 | API Fundamentals & Prompt Engineering | [ ] Not Started / [ ] In Progress / [ ] Complete |
| Week 2 | Tool Use & MCP | [ ] Not Started / [ ] In Progress / [ ] Complete |
| Week 3 | Agentic Architecture | [ ] Not Started / [ ] In Progress / [ ] Complete |
| Week 4 | Practice & Review | [ ] Not Started / [ ] In Progress / [ ] Complete |

**Exam Date:** ___________
**Result:** ___________
