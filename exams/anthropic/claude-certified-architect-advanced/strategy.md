# CCA-A - Exam Strategy

The Advanced exam rewards depth. Where Foundations asks "what is prompt caching," Advanced asks "given a 40K-token system prompt, a 2-minute user latency budget, and 500 QPS, design the caching topology." Your job on exam day is to translate scenario details into design decisions under time pressure.

---

## 3-Phase Preparation

### Phase 1 - Ground Truth (Weeks 1-2)

Read primary sources only. Docs.anthropic.com, the MCP specification, the Bedrock and Vertex integration guides, and the most recent two Anthropic engineering blog posts. Community blog posts are useful but age faster than the docs.

Output: a private glossary of every term the docs use. If you cannot define it in one sentence, it is a gap.

### Phase 2 - Build (Weeks 3-4)

Ship two agents. One orchestrator-worker, one single-agent tool loop. Instrument both. Deploy at least one to Bedrock or Vertex. The exam is scenario-based; you need scar tissue from real systems to answer scenario questions quickly.

Output: a repo of Claude-powered systems you can explain line by line.

### Phase 3 - Drill (Weeks 5-6)

Timed scenario practice. Walk through the scenarios.md in this guide under 2-minute-per-question pressure. Re-read the fact sheet the night before. Sleep.

Output: reflexive recall on high-yield facts, calm pacing on exam day.

---

## Time Management During the Exam

Assume 150 minutes and 70 questions. That is roughly 2 minutes per question with 10 minutes of buffer for review.

- First pass: answer every question you are confident on within 90 seconds. Flag anything that takes longer.
- Second pass: return to flagged questions. Use the buffer for the hardest 5-10.
- Do not leave any question blank. There is no penalty for wrong answers on Anthropic's current exam format.

Pacing checkpoints:

| Time Elapsed | Question # |
|---|---|
| 30 min | 14 |
| 60 min | 28 |
| 90 min | 42 |
| 120 min | 56 |
| 140 min | 70 (done, review) |

If you are behind at any checkpoint, skip harder questions aggressively.

---

## Question Decoding

Advanced exam questions often contain:

- Non-functional requirements (latency budget, throughput, compliance)
- A scale number (tokens, QPS, users)
- A constraint (region, model tier, ZDR)
- A tradeoff ask (cheapest, fastest, most reliable, most secure)

Read the last sentence first. The last sentence usually tells you which axis matters (cost vs latency vs reliability vs compliance). Then re-read from the top with that lens.

---

## Answer Selection Heuristics

When two answers both look right:

1. Pick the one that most directly satisfies the constraint named in the last sentence.
2. Prefer answers that follow Anthropic's documented best practices over clever alternatives.
3. Prefer managed features (prompt caching, Batch API, Files API) over roll-your-own.
4. Prefer Claude-native patterns (XML tags, tool use for structured output) over generic LLM patterns (regex parsing).
5. Prefer simpler architectures unless scale or constraints force complexity.

When all answers look wrong: the question is testing whether you can identify the least-bad tradeoff. Pick the answer that preserves the most important non-functional requirement.

---

## Domain-Specific Tactics

### Architectures (22%)

- "Multi-step, parallelizable, independent sub-tasks" screams orchestrator-worker.
- "Long-horizon planning with cheap execution" screams planner-executor.
- "General conversational with tools" screams single-agent tool loop.
- Any time the question mentions "swarm" with no further justification, suspect it is a distractor.

### Context Engineering (18%)

- Questions mentioning "long document, reused across requests" want caching.
- "Persistent state across sessions" wants the memory tool.
- "Complex reasoning, wrong answer expensive" wants extended thinking.
- Watch for trap answers that conflate memory tool with prompt caching.

### Tool Use and MCP (17%)

- Streamable HTTP is the recommended remote MCP transport. SSE is legacy.
- Parallel tool use is enabled by default for supported models.
- Forced tool choice (`tool_choice: {type: "tool", name: ...}`) is for when you need structured extraction.
- First-party tools (code execution, computer use, web search) are preferred over custom reimplementations.

### Evaluation (15%)

- LLM-as-judge is good for subjective quality; unit evals for schema/format.
- Regression gates in CI are a common correct answer.
- Calibrate judges against human labels before trusting.

### Cost and Latency (15%)

- Batch API = 50% discount, 24h SLA.
- Prompt caching = ~90% read discount, 25% write premium.
- Streaming improves perceived latency, not total latency.
- Model routing (Haiku triage -> Sonnet execute) is a high-yield optimization.

### Enterprise Deployment (13%)

- Bedrock uses IAM and regional model IDs.
- Vertex uses service accounts and publisher model IDs.
- PrivateLink (AWS) / VPC Service Controls (GCP) for no-public-egress.
- ZDR is a separate contractual arrangement, not a default.

---

## The 24 Hours Before

- Re-read the fact sheet.
- Re-read this strategy file.
- Do not cram new material - reinforce what you know.
- Sleep 7-8 hours.
- Eat before the exam. Caffeine to your normal level, not above.
- Test your webcam, microphone, and room setup if proctored online.
- Have your ID ready.

---

## During the Exam

- Breathe before starting. Read the instructions fully.
- Do not argue with questions. If it feels wrong, flag and move on.
- Use the whole time. Do not submit early.
- On the last pass, change answers only when you have a concrete reason. Gut-doubts are usually wrong.

---

## If You Fail

Retake windows apply. Use the score report to identify the weakest domain. Spend 2-3 weeks rebuilding in that domain only, then re-sit. Do not re-study the whole exam - diminishing returns.

Failing the first time does not mean the material is beyond you. Advanced exams frequently require a second attempt.
