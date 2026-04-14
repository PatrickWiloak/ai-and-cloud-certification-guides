# CPES - 4-Week Practice Plan

Daily commitment: 1-1.5 hours weekdays, 2-3 hours one weekend day. Total: ~35 hours.

This plan is hands-on. Every week ends with measured prompt improvements.

---

## Week 1 - Fundamentals and System Prompts

- [ ] Read Anthropic's prompt engineering overview cover to cover
- [ ] Read `notes/01-prompt-fundamentals-and-anatomy.md` and `notes/02-system-prompts-and-role-prompting.md`
- [ ] Pick one real task you care about (summarization, classification, extraction, code review, support reply)
- [ ] Write a v1 prompt without fancy techniques. Save it.
- [ ] Build a small eval dataset (20 items) with gold answers or rubric
- [ ] Score v1 against the eval set (manual is fine for week 1)
- [ ] Add a system prompt with explicit role and constraints. Re-score.
- [ ] Document what changed and by how much in a prompt journal

Deliverable: a baseline + v2 prompt with measured improvement.

---

## Week 2 - Chain of Thought, XML Tags, Structured Output

- [ ] Read `notes/03-chain-of-thought-and-extended-thinking.md` and `notes/04-xml-tags-and-structured-outputs.md`
- [ ] Add a "think step by step" instruction or `<thinking>` tag. Re-score.
- [ ] Refactor your prompt to use XML tags for instructions, context, and examples. Re-score.
- [ ] If your task has structured output, switch to forced tool choice. Re-score.
- [ ] Try prefill (start the assistant with `{` for JSON). Compare with forced tool choice.
- [ ] Try enabling extended thinking (if your task is reasoning-heavy). Compare with prompt-level CoT.

Deliverable: v3-v5 of the prompt with documented technique-by-technique impact.

---

## Week 3 - Few-Shot, Many-Shot, and Iteration

- [ ] Read `notes/05-few-shot-and-example-driven-prompting.md` and `notes/06-prompt-evaluation-and-iteration.md`
- [ ] Add 3 carefully chosen examples spanning easy / typical / edge case. Re-score.
- [ ] Try 8 examples (many-shot). Compare to 3.
- [ ] Add one counter-example. Re-score.
- [ ] Build an automated LLM-as-judge to replace manual scoring
- [ ] Calibrate the judge against your manual labels (compute agreement)
- [ ] Run an A/B between two prompt variants on the eval set
- [ ] Document which technique gave the biggest lift on your task

Deliverable: an automated eval harness + a winning prompt variant.

---

## Week 4 - Caching, Long Context, Review, Exam Prep

- [ ] Read `notes/07-prompt-caching-design-patterns.md`
- [ ] Reorder your prompt to maximize cache-friendly structure
- [ ] Add `cache_control` at the end of the static prefix
- [ ] Verify cache hit rate and token cost in the response usage
- [ ] If your task uses long documents, apply long-context tips: tags, question top-and-bottom, quote-then-answer
- [ ] Re-read all notes and the fact sheet
- [ ] Walk through every scenario in `scenarios.md` under timed conditions (1.5 minutes per question)
- [ ] Re-read `strategy.md` the night before
- [ ] Verify exam logistics on Anthropic's site

Deliverable: a production-ready, cache-optimized prompt with full eval harness.

---

## Hands-On Project Ideas (Pick One)

1. Customer support reply generator: tone-appropriate replies grounded in product docs with citations.
2. Invoice extractor: structured JSON via forced tool choice; eval against ground-truth invoices.
3. Code review assistant: identify issues in a diff with severity tagging.
4. Research summarizer: long-context summarization with page-level citations.
5. Multi-step lesson planner: chain-of-thought with structured plan output.

---

## Prompt Journal Format

Maintain a journal of every change:

```
v3 -> v4
Date: 2026-04-12
Hypothesis: Adding two counter-examples will reduce false positives.
Change: Added two counter-examples in <bad_output> tags.
Eval delta: +4.2% accuracy, +800 input tokens.
Decision: Ship.
```

This discipline pays off at exam time when you need to recognize which technique a question is testing.

---

## Red Flags - Do Not Sit the Exam Yet If

- You cannot list Anthropic's prompting techniques from memory
- You have not measured the impact of any technique on a real task
- You confuse extended thinking with CoT prompting
- You have never structured a prompt with XML tags
- You think prompt caching is automatic
- You have never used forced tool choice for structured output
