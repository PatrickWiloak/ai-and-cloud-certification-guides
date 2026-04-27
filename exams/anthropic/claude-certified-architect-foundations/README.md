# Claude Architect Foundations - Self-Directed Study Track

> ℹ️ **Study track, not an official certification.** Anthropic does not currently run an official certification program. This guide is structured around the skill areas a foundational Claude architect should master. Use it as a self-directed proficiency track to validate your knowledge of building production Claude systems.

## Track Overview

This track covers the foundational knowledge of building production applications with Claude: agentic architecture design, Claude Code configuration, prompt engineering, tool design, Model Context Protocol (MCP) integration, and reliability patterns.

It targets developers, architects, and AI engineers who have hands-on experience building with the Claude API, Claude Code, and MCP. Completing the material should leave you able to design, build, and maintain Claude-powered systems in production environments.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Track Name** | Claude Architect Foundations |
| **Provider** | Self-directed (Anthropic-focused) |
| **Skill Level** | Foundational / Associate-equivalent |
| **Recommended study time** | 4-8 weeks (2-3 hr/day) |
| **Format** | 60 scenario-based self-assessment questions provided in this guide |
| **Prerequisites** | 6+ months of hands-on experience with the Claude API, Claude Code, and MCP recommended |
| **Primary sources** | Anthropic Academy (Skilljar), [docs.anthropic.com](https://docs.anthropic.com), MCP spec, Anthropic Cookbook |

---

## Skill Areas

| # | Skill Area | Suggested weight |
|---|---|---|
| 1 | Agentic Architecture | 27% |
| 2 | Claude Code Configuration | 20% |
| 3 | Prompt Engineering & Structured Output | 20% |
| 4 | Tool Design & MCP Integration | 18% |
| 5 | Context & Reliability | 15% |

---

## Skill Area Breakdown

### 1 - Agentic Architecture (27%)

The highest-weighted area. You should understand how to design agentic systems with Claude, including when to use agents vs simple prompts, multi-agent orchestration, and production reliability patterns.

**Key Concepts:**
- Agentic design patterns (tool use loops, multi-step reasoning, orchestration)
- Agent architectures (single agent, multi-agent, supervisor/worker patterns)
- Agentic workflows (plan-execute-reflect loops)
- Error handling and recovery in agentic systems
- Decision criteria for agents vs simple prompt chains
- Production considerations (cost management, latency, reliability)
- Claude's extended thinking in agentic contexts

### 2 - Claude Code Configuration (20%)

Claude Code is Anthropic's official CLI and IDE integration for Claude. This area covers configuring, customizing, and managing Claude Code for individual and team development workflows.

**Key Concepts:**
- Claude Code CLI setup, installation, and configuration
- CLAUDE.md file hierarchy (project-level, user-level, enterprise-level)
- Settings and permissions model
- Hooks system (pre-tool and post-tool execution hooks)
- Custom slash commands
- IDE integrations (VS Code extension, JetBrains plugin)
- MCP server configuration within Claude Code
- Team workflow configuration

### 3 - Prompt Engineering & Structured Output (20%)

The art and science of crafting effective prompts for Claude, plus extracting structured data from responses.

**Key Concepts:**
- Prompt engineering best practices specific to Claude
- System prompts vs user prompts and their roles
- Chain-of-thought and reasoning techniques
- Structured output extraction (JSON mode, tool use for structured data)
- XML tags for prompt organization and clarity
- Few-shot and many-shot prompting techniques
- Prompt caching for cost optimization
- Multimodal prompting (vision, PDF processing)

### 4 - Tool Design & MCP Integration (18%)

The Model Context Protocol (MCP) is a core part of Claude's extensibility story. This area covers designing tools, building MCP servers, and integrating external capabilities into Claude workflows.

**Key Concepts:**
- Model Context Protocol (MCP) architecture and fundamentals
- MCP components (clients, servers, transports - stdio, SSE, streamable HTTP)
- Building MCP servers (tools, resources, prompts)
- Tool design best practices (naming conventions, descriptions, JSON schemas)
- Claude API tool use (function calling)
- Tool choice modes (auto, any, specific tool forcing)
- Parallel tool use
- Error handling in tool calls

### 5 - Context & Reliability (15%)

Managing Claude's context window effectively, implementing reliability patterns, and building production-grade applications.

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

3. **Build hands-on projects** - This is applied material. You need practical experience building with the Claude API, Claude Code, and MCP to internalize it.

4. **Practice with scenarios** - Work through the scenario-based questions in this guide. The goal is applied judgment, not memorization.

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

## Self-Assessment Tips

1. **Read every word** - Scenario questions have important details buried in the context. Skim at your peril.
2. **Eliminate first** - Most questions have 1-2 obviously wrong answers. Eliminate those, then reason through the remaining options.
3. **Think production** - Favor production-ready, reliable, cost-effective solutions over clever hacks.
4. **Watch for "most appropriate"** - Many questions ask for the BEST answer, not just a correct one. Multiple options may work, but one is better.
5. **Time management** - Pace yourself at ~2 minutes per scenario when working through the practice set.
6. **Agentic Architecture is king** - At 27% weighting in this guide, prioritize it.

---

## Suggested Learning Progression

This is the foundational track in a recommended Claude proficiency progression:

```
Foundations (this track)
    |
    v
Application Developer track  -  production API/SDK depth
    |
    v
Advanced / Architect track   -  multi-agent systems, RAG at scale, enterprise deployment
```

The other Anthropic-focused study tracks in this repo:

- [Claude Application Developer](../claude-application-developer/) - production Claude API/SDK development
- [Prompt Engineering Specialist](../claude-prompt-engineering-specialist/) - prompt design, evaluation, caching patterns
- [Architect Advanced](../claude-certified-architect-advanced/) - multi-agent systems, RAG at scale, enterprise deployment

---

## About This Guide

This study guide is designed to help engineers build production-ready proficiency with Claude. It is organized around the major skill areas a foundational Claude architect should master. The notes, scenarios, and practice plan are designed to maximize learning efficiency and applied judgment.
