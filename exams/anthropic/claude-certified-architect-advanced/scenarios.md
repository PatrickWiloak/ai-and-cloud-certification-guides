# CCA-A - Exam Scenarios

Ten scenario-based questions at the difficulty expected for Advanced. Each includes the setup, answer choices, the correct answer, and reasoning. Work through them under a 2-minute timer per question.

---

## Scenario 1 - Multi-Agent Research Overkill

A team is building a legal research assistant. A user asks a single question, the system searches an internal case database, reads the top 5 case summaries, and produces an answer. The team built it as an orchestrator-worker system: one Opus 4.6 orchestrator, five Haiku 4.5 workers each reading one case, one Opus aggregator. Average cost per query: $0.42. P95 latency: 28 seconds.

The team asks you to reduce cost and latency without sacrificing quality.

A. Swap the orchestrator to Sonnet 4.6.
B. Replace the architecture with a single Sonnet 4.6 agent that uses a search tool and retrieves all 5 cases in one tool call with prompt caching on the case corpus.
C. Add extended thinking with a 16K budget on the Opus aggregator.
D. Migrate to the Batch API.

**Answer: B.** The workload does not require multi-agent orchestration. Five independent reads can happen in one tool call with parallel tool use or as a single retrieval, and prompt caching on the corpus will drive the input cost down sharply. Single-agent tool loops on Sonnet are the default choice; multi-agent was premature. D breaks the interactive UX. C adds cost without clear benefit. A is incremental, not architectural.

---

## Scenario 2 - Extended Thinking Continuation

An agent runs a tool-use loop with extended thinking enabled (`thinking: {type: "enabled", budget_tokens: 8000}`). On turn 3, the agent returns a `thinking` block, a `tool_use` block, and stops with `stop_reason: tool_use`. You execute the tool and want to send the result back for turn 4. What must you include in the next request?

A. Only the tool_result block.
B. The tool_result block and a regenerated thinking block.
C. The full previous assistant message including the thinking block with its signature, plus the tool_result block.
D. The full previous assistant message with the thinking block stripped out, plus the tool_result block.

**Answer: C.** Extended thinking blocks must be preserved verbatim on continuation, including their opaque `signature` field. The API rejects continuations that strip or modify thinking blocks when tool use is in flight. This is a frequent Advanced-exam trap.

---

## Scenario 3 - Prompt Caching Economics

You have a 40K-token system prompt (stable) and a 2K-token per-request user prompt. Each request produces 500 output tokens. Cache writes cost 1.25x input tokens; cache reads cost 0.1x input tokens. On average, each conversation thread sends 6 requests within 5 minutes, then the thread ends.

Is caching worth it, and how should it be structured?

A. No, the prefix is too large to cache.
B. Yes, place one cache breakpoint at the end of the 40K-token system prompt. Break-even after 2 reads; 6 reads makes caching a clear win.
C. Yes, but use the 1-hour cache tier since threads last less than 5 minutes.
D. Yes, but place the cache breakpoint at the end of the user prompt to cache the full request.

**Answer: B.** With 6 reads and a break-even around 2, caching the 40K prefix is clearly worth it. The 5-minute ephemeral tier fits the thread lifetime. Option C is wrong direction on TTL. Option D caches volatile content, which is useless.

---

## Scenario 4 - MCP Transport Selection

You are building a remote MCP server that will serve 50 internal teams, each with their own OAuth-authenticated context, over the public internet. Which transport do you choose?

A. stdio
B. SSE (server-sent events)
C. Streamable HTTP
D. WebSockets

**Answer: C.** Streamable HTTP is the modern, recommended transport for remote MCP servers and is what the spec directs new deployments toward. SSE is legacy. stdio is for local processes. WebSockets are not an MCP transport.

---

## Scenario 5 - Eval Regression Gate

Your team ships prompt changes weekly. You want to prevent quality regressions from reaching production. Which design most directly achieves this?

A. Have engineers manually test 10 prompts before each release.
B. Run a daily cron job that scores production traffic with LLM-as-judge and posts to Slack.
C. Block CI merges that drop quality score by more than 3% on a held-out eval set graded by a calibrated LLM-as-judge.
D. Roll out new prompts to 5% of traffic and monitor CSAT.

**Answer: C.** A regression gate in CI is the most direct preventive control. B and D detect regressions after they reach users. A is not scalable and lacks consistency.

---

## Scenario 6 - Bedrock vs First-Party

A regulated US healthcare customer needs HIPAA BAA coverage, no public internet traffic between their VPC and Claude, CloudTrail audit logs, and IAM-based auth. They run entirely on AWS. Which deployment do you recommend?

A. Anthropic first-party API with IP allowlisting.
B. Anthropic first-party API with a self-managed proxy in their VPC.
C. Claude on Amazon Bedrock with PrivateLink.
D. Claude on Google Vertex AI.

**Answer: C.** Bedrock provides IAM auth, CloudTrail logs, PrivateLink for no-public-egress, and HIPAA eligibility natively for AWS customers. A and B leak or add complexity. D is off-cloud.

---

## Scenario 7 - Tool Sprawl

An agent has grown to 38 tools. Users report that Claude sometimes calls the wrong tool or fails to call any tool. Which intervention is most likely to help?

A. Switch from Sonnet 4.6 to Opus 4.6.
B. Add examples to each tool description.
C. Prune redundant tools, merge overlapping tools, and introduce a dispatcher for the remaining long tail. Target under 20 tools.
D. Set `tool_choice: any` to force tool use.

**Answer: C.** Large tool surfaces degrade selection accuracy. Pruning and dispatching is the architectural fix. B helps at the margin. A is expensive and may not fix the underlying ambiguity. D forces any tool call, including wrong ones.

---

## Scenario 8 - Batch vs Real-Time

A compliance team wants to redact PII from 2 million support tickets. They need the redactions within 24 hours. Cost is tight. Which path?

A. Real-time Messages API with high concurrency.
B. Batch API with prompt caching on the redaction instructions.
C. Real-time Messages API with the Files API.
D. Claude Code running locally on an analyst's laptop.

**Answer: B.** Batch API offers a 50% discount and a 24-hour SLA, which fits the requirement. Caching the static redaction instructions drives costs further down. A is 2x more expensive. D cannot scale to 2M items.

---

## Scenario 9 - Memory Tool vs Prompt Caching

A product manager asks you to "remember user preferences across sessions so the assistant feels personalized." Which is the correct primitive?

A. Prompt caching.
B. The memory tool with per-user scoping.
C. Pinning preferences into the system prompt.
D. Extended thinking.

**Answer: B.** The memory tool is Anthropic's designed primitive for durable cross-session state. Prompt caching is for static prefixes and has a short TTL. Pinning into the system prompt does not scale per-user without dynamic assembly. Extended thinking is unrelated.

---

## Scenario 10 - Interleaved Thinking

A 5-step agent uses tool use. You want Claude to reason between tool calls so it can reflect on prior results before choosing the next action. What do you enable?

A. Regular extended thinking only at the start of the turn.
B. Interleaved thinking, allowing thinking blocks between tool calls.
C. Streaming with `stream: true`.
D. Chain-of-thought prompting in the system prompt.

**Answer: B.** Interleaved thinking is the specific feature that lets Claude think between tool calls within a single turn. A confines thinking to turn start. C is a delivery concern. D is a prompt-level hack that does not produce real thinking blocks.

---

## Review Checklist

After going through these:

- [ ] Did you finish each in under 2 minutes?
- [ ] Can you state the underlying principle behind each correct answer?
- [ ] Can you identify the category of distractor used in each wrong answer?
- [ ] Which domain did you feel weakest on? Go re-read that note next.
