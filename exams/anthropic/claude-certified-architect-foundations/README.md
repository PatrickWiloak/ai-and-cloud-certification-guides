# CCA-F - Claude Certified Architect - Foundations

## Exam Overview

The Claude Certified Architect - Foundations (CCA-F) is Anthropic's first official certification, launched on March 12, 2026. It validates foundational knowledge of building production applications with Claude, including agentic architecture design, Claude Code configuration, prompt engineering, tool design, MCP integration, and reliability patterns.

This certification targets developers, architects, and AI engineers who have hands-on experience building with the Claude API, Claude Code, and the Model Context Protocol (MCP). It is designed to prove you can design, build, and maintain Claude-powered systems in production environments.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | CCA-F |
| **Full Name** | Claude Certified Architect - Foundations |
| **Provider** | Anthropic |
| **Duration** | 120 minutes |
| **Questions** | 60 scenario-based multiple choice |
| **Passing Score** | 720 / 1000 |
| **Cost** | Included with Claude Partner Network (standalone pricing available) |
| **Delivery** | ProctorFree (online proctored) |
| **Validity** | 2 years |
| **Prerequisites** | 6+ months production experience with Claude API, Claude Code, and MCP recommended |
| **Launched** | March 12, 2026 |

---

## Exam Domains

| # | Domain | Weight | Questions (approx.) |
|---|---|---|---|
| 1 | Agentic Architecture | 27% | ~16 |
| 2 | Claude Code Configuration | 20% | ~12 |
| 3 | Prompt Engineering & Structured Output | 20% | ~12 |
| 4 | Tool Design & MCP Integration | 18% | ~11 |
| 5 | Context & Reliability | 15% | ~9 |

---

## Domain Breakdown

### Domain 1 - Agentic Architecture (27%)

This is the highest-weighted domain and the most critical to pass. You must understand how to design agentic systems with Claude, including when to use agents vs simple prompts, multi-agent orchestration, and production reliability patterns.

**Key Concepts:**
- Agentic design patterns (tool use loops, multi-step reasoning, orchestration)
- Agent architectures (single agent, multi-agent, supervisor/worker patterns)
- Agentic workflows (plan-execute-reflect loops)
- Error handling and recovery in agentic systems
- Decision criteria for agents vs simple prompt chains
- Production considerations (cost management, latency, reliability)
- Claude's extended thinking in agentic contexts

### Domain 2 - Claude Code Configuration (20%)

Claude Code is Anthropic's official CLI and IDE integration for Claude. This domain tests your knowledge of configuring, customizing, and managing Claude Code for individual and team development workflows.

**Key Concepts:**
- Claude Code CLI setup, installation, and configuration
- CLAUDE.md file hierarchy (project-level, user-level, enterprise-level)
- Settings and permissions model
- Hooks system (pre-tool and post-tool execution hooks)
- Custom slash commands
- IDE integrations (VS Code extension, JetBrains plugin)
- MCP server configuration within Claude Code
- Team workflow configuration

### Domain 3 - Prompt Engineering & Structured Output (20%)

This domain covers the art and science of crafting effective prompts for Claude, as well as extracting structured data from Claude's responses.

**Key Concepts:**
- Prompt engineering best practices specific to Claude
- System prompts vs user prompts and their roles
- Chain-of-thought and reasoning techniques
- Structured output extraction (JSON mode, tool use for structured data)
- XML tags for prompt organization and clarity
- Few-shot and many-shot prompting techniques
- Prompt caching for cost optimization
- Multimodal prompting (vision, PDF processing)

### Domain 4 - Tool Design & MCP Integration (18%)

The Model Context Protocol (MCP) is a core part of Claude's extensibility story. This domain tests your ability to design tools, build MCP servers, and integrate external capabilities into Claude workflows.

**Key Concepts:**
- Model Context Protocol (MCP) architecture and fundamentals
- MCP components (clients, servers, transports - stdio, SSE, streamable HTTP)
- Building MCP servers (tools, resources, prompts)
- Tool design best practices (naming conventions, descriptions, JSON schemas)
- Claude API tool use (function calling)
- Tool choice modes (auto, any, specific tool forcing)
- Parallel tool use
- Error handling in tool calls

### Domain 5 - Context & Reliability (15%)

This domain covers managing Claude's context window effectively, implementing reliability patterns, and building production-grade applications.

**Key Concepts:**
- Context window management (200K token window)
- Long context best practices and strategies
- Prompt caching for performance and cost
- Extended thinking (Claude's reasoning mode)
- Reliability patterns (retries, fallbacks, validation loops)
- Token counting and budget management
- Streaming and real-time response handling
- Rate limiting, error handling, and API best practices

---

## Study Approach

### Recommended Path

1. **Start with Anthropic Academy** - Complete the free courses on Skilljar (anthropic.skilljar.com). These are the official training materials and align closely with exam content.

2. **Read the documentation** - The official docs at docs.anthropic.com are the primary source of truth. Focus on the API reference, guides, and cookbooks.

3. **Build hands-on projects** - The exam is scenario-based. You need practical experience building with the Claude API, Claude Code, and MCP to answer questions confidently.

4. **Practice with scenarios** - Work through the scenario-based practice questions in this guide. The exam tests applied knowledge, not memorization.

5. **Review and fill gaps** - Use the fact sheet and notes in this guide to identify and fill knowledge gaps.

### Time Investment

- **4 weeks** is the recommended study period for someone with existing Claude experience
- **6-8 weeks** for those newer to Claude but with general AI/ML background
- **2-3 hours per day** of focused study is ideal

### Key Study Resources

| Resource | URL | Notes |
|---|---|---|
| Anthropic Academy | https://anthropic.skilljar.com | Free official courses - complete all 13 |
| Anthropic Docs | https://docs.anthropic.com | Primary documentation |
| MCP Specification | https://modelcontextprotocol.io | MCP protocol details |
| Claude Code Docs | https://docs.anthropic.com/en/docs/claude-code | CLI and IDE docs |
| Anthropic Cookbook | https://github.com/anthropics/anthropic-cookbook | Code examples |
| Anthropic Blog | https://www.anthropic.com/news | Latest features and updates |

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Deep reference with documentation links, domain breakdowns, and exam tips |
| [notes/01-agentic-architecture.md](notes/01-agentic-architecture.md) | Domain 1 - Agentic Architecture (27%) |
| [notes/02-claude-code-configuration.md](notes/02-claude-code-configuration.md) | Domain 2 - Claude Code Configuration (20%) |
| [notes/03-prompt-engineering-structured-output.md](notes/03-prompt-engineering-structured-output.md) | Domain 3 - Prompt Engineering & Structured Output (20%) |
| [notes/04-tool-design-mcp-integration.md](notes/04-tool-design-mcp-integration.md) | Domain 4 - Tool Design & MCP Integration (18%) |
| [notes/05-context-reliability.md](notes/05-context-reliability.md) | Domain 5 - Context & Reliability (15%) |
| [notes/06-exam-tips-prep-strategy.md](notes/06-exam-tips-prep-strategy.md) | Exam tips, Skilljar courses, and preparation strategy |
| [practice-plan.md](practice-plan.md) | 4-week study plan with checkboxes |
| [scenarios.md](scenarios.md) | 8-10 exam-style scenarios with solutions |
| [strategy.md](strategy.md) | 3-phase study approach, resources, and exam tactics |

---

## Exam Day Tips

1. **Read every word** - Scenario questions have important details buried in the context. Skim at your peril.
2. **Eliminate first** - Most questions have 1-2 obviously wrong answers. Eliminate those, then reason through the remaining options.
3. **Think production** - The exam favors production-ready, reliable, cost-effective solutions over clever hacks.
4. **Watch for "most appropriate"** - Many questions ask for the BEST answer, not just a correct one. Multiple options may work, but one is better.
5. **Time management** - 120 minutes for 60 questions gives you 2 minutes per question. Flag hard ones and come back.
6. **Agentic Architecture is king** - At 27%, this domain can make or break your score. Prioritize it.

---

## Certification Path

The CCA-F is the foundational certification in Anthropic's certification program. As Anthropic's first certification offering, it establishes a baseline of knowledge for working with Claude in production. Future certifications are expected to build on this foundation with more advanced topics.

```
CCA-F (Foundations)     <-- You are here
    |
    v
CCA-P (Professional)   <-- Expected future certification
    |
    v
CCA-E (Expert)          <-- Expected future certification
```

---

## About This Guide

This study guide was created to help engineers prepare for the CCA-F certification exam. It is organized to follow the exam domains and weighted accordingly. The notes, scenarios, and practice plan are all designed to maximize your preparation efficiency.

Good luck on your exam!
