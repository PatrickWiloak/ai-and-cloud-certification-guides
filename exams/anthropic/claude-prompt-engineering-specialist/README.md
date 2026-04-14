# CPES - Claude Prompt Engineering Specialist

## Exam Overview

The Claude Prompt Engineering Specialist (CPES) certification validates the ability to design, evaluate, and iterate prompts that produce reliable, high-quality outputs from Claude models. Where the Architect track focuses on system design and the Application Developer track on API mechanics, the Specialist track focuses on the craft of the prompt itself: clarity, structure, examples, reasoning elicitation, evaluation, and prompt-engineering patterns at production scale.

This guide is published in advance of the official exam blueprint. Where the exam is still evolving, content is framed as preparation for an emerging certification grounded in Anthropic's published prompt engineering guide and related cookbook recipes.

This certification targets prompt engineers, AI engineers, applied scientists, technical writers crossing into AI, and product engineers responsible for the quality of LLM outputs.

---

## Quick Reference

| Detail | Info |
|---|---|
| Exam Code | CPES (preliminary) |
| Full Name | Claude Prompt Engineering Specialist |
| Provider | Anthropic |
| Duration | 90 minutes (estimate) |
| Questions | 50-60 prompt-analysis and design items (estimate) |
| Passing Score | ~720 / 1000 (estimate) |
| Cost | TBD; expected within Claude Partner Network |
| Delivery | Online proctored |
| Validity | 2 years |
| Prereq | Hands-on prompting experience with Claude |
| Status | Emerging certification - details preliminary |

---

## Target Audience

You should pursue CPES if you:

- Write prompts for production Claude applications
- Iterate on prompts based on quality metrics, not gut feel
- Build prompt evaluation harnesses
- Lead prompt-engineering practice on a team
- Maintain a prompt library across products

---

## Expected Exam Domains

Preliminary weights, subject to confirmation against Anthropic's official blueprint.

| # | Domain | Estimated Weight | Focus |
|---|---|---|---|
| 1 | Prompt Fundamentals and Anatomy | 18% | Roles, structure, clarity |
| 2 | System Prompts and Role Prompting | 16% | Persona, constraints, defaults |
| 3 | Chain-of-Thought and Extended Thinking | 16% | Reasoning elicitation |
| 4 | XML Tags and Structured Outputs | 14% | Structure for parsing and clarity |
| 5 | Few-Shot and Example-Driven Prompting | 14% | Demonstrating format and behavior |
| 6 | Prompt Evaluation and Iteration | 12% | Evals, A/B, regression |
| 7 | Prompt Caching Design Patterns | 10% | Cache-aware prompt structure |

---

## Domain Summaries

### Domain 1 - Prompt Fundamentals and Anatomy

The structure of an effective Claude prompt: system, user, optional examples, optional context, optional reasoning instructions. The role of clarity, specificity, and ordering. Why Claude responds well to certain stylistic choices.

### Domain 2 - System Prompts and Role Prompting

Setting the model's persona, constraints, capabilities, and default behaviors via the `system` field. When role prompting helps and when it backfires. Composing system prompts for multi-feature assistants.

### Domain 3 - Chain-of-Thought and Extended Thinking

Eliciting step-by-step reasoning. The difference between explicit chain-of-thought instructions in the prompt and Claude's native extended thinking. When to use each.

### Domain 4 - XML Tags and Structured Outputs

Why Claude responds especially well to XML-tagged sections. Common tag patterns (instructions, context, examples, output_format). Combining XML tags with forced tool choice for structured extraction.

### Domain 5 - Few-Shot and Example-Driven Prompting

How many examples to include. How to choose representative examples. Many-shot prompting. Counter-examples. Example ordering effects.

### Domain 6 - Prompt Evaluation and Iteration

Writing eval datasets. LLM-as-judge for prompt quality. A/B testing prompt variants. Regression gates for prompt changes. Calibrating judges.

### Domain 7 - Prompt Caching Design Patterns

Designing prompts so the static prefix is large enough to cache. Avoiding accidental cache invalidation. Layering cache breakpoints.

---

## Official Resources

| Resource | URL |
|---|---|
| Prompt Engineering Overview | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering |
| Be Clear and Direct | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct |
| Use Examples (Multishot) | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting |
| Chain of Thought | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought |
| Use XML Tags | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags |
| System Prompts | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts |
| Prefill Claude's Response | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prefill-claudes-response |
| Chain Prompts | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-prompts |
| Long Context Tips | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips |
| Extended Thinking | https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking |
| Prompt Caching | https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching |
| Anthropic Cookbook | https://github.com/anthropics/anthropic-cookbook |
| Prompt Library | https://docs.anthropic.com/en/prompt-library |

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Reference of patterns and high-yield facts |
| [notes/01-prompt-fundamentals-and-anatomy.md](notes/01-prompt-fundamentals-and-anatomy.md) | Anatomy of a Claude prompt |
| [notes/02-system-prompts-and-role-prompting.md](notes/02-system-prompts-and-role-prompting.md) | System prompt design |
| [notes/03-chain-of-thought-and-extended-thinking.md](notes/03-chain-of-thought-and-extended-thinking.md) | CoT and extended thinking |
| [notes/04-xml-tags-and-structured-outputs.md](notes/04-xml-tags-and-structured-outputs.md) | XML structure and JSON extraction |
| [notes/05-few-shot-and-example-driven-prompting.md](notes/05-few-shot-and-example-driven-prompting.md) | Examples and many-shot |
| [notes/06-prompt-evaluation-and-iteration.md](notes/06-prompt-evaluation-and-iteration.md) | Evals, A/B, regression |
| [notes/07-prompt-caching-design-patterns.md](notes/07-prompt-caching-design-patterns.md) | Cache-aware prompt design |
| [practice-plan.md](practice-plan.md) | 4-week prompt-engineering plan |
| [scenarios.md](scenarios.md) | 10 prompt analysis and design scenarios |
| [strategy.md](strategy.md) | Exam-day tactics |

---

## Preparing for an Emerging Certification

1. Read Anthropic's prompt engineering guide cover to cover, twice.
2. Build a prompt eval harness for one real task and use it.
3. Maintain a prompt journal: every change, the hypothesis, the result.
4. Use real model IDs: `claude-opus-4-6`, `claude-sonnet-4-6`, `claude-haiku-4-5`.
5. Re-verify exam logistics on Anthropic's site before booking.

The fastest way to pass is to ship one prompt-driven feature with measured quality improvements.
