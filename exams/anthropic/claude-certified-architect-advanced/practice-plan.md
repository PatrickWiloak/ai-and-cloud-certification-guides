# CCA-A - 6-Week Practice Plan

This plan assumes you have already passed or are solid on CCA-F content. If not, spend 2 weeks on CCA-F material first.

Daily commitment: 1.5-2 hours on weekdays, 3-4 hours on one weekend day. Total: roughly 70 hours.

---

## Week 1 - Advanced Architectures

Goal: internalize orchestrator-worker, planner-executor, and single-agent tradeoffs.

- [ ] Read `notes/01-advanced-claude-architectures.md`
- [ ] Read Anthropic's multi-agent research blog post end to end
- [ ] Reproduce a minimal orchestrator-worker agent: one Opus planner, three Haiku workers, combine into a research summary
- [ ] Instrument the agent to log tokens-per-worker and total cost per trace
- [ ] Convert the same task to a single-agent Sonnet tool loop. Compare cost, latency, quality.
- [ ] Write a one-page decision memo: when would you pick each pattern?
- [ ] Read `notes/02-claude-agent-sdk-deep-dive.md`
- [ ] Build one minimal example with the Claude Agent SDK (Python or TypeScript)

Deliverable: a repo with both architectures, a cost table, and a decision memo.

---

## Week 2 - Context Engineering and Extended Thinking

Goal: master thinking budgets, the memory tool, and context shaping.

- [ ] Read `notes/03-extended-thinking-and-context-management.md`
- [ ] Read the extended thinking docs cover to cover
- [ ] Take a task where Sonnet scores 70% without thinking. Turn on thinking with budgets of 1K, 4K, 16K. Measure quality and cost.
- [ ] Implement interleaved thinking in a 5-tool agent. Confirm thinking blocks appear between tool calls.
- [ ] Build a simple client-side memory tool integration. Persist user preferences across sessions.
- [ ] Take a 180K-token RAG prompt and cut it to 60K tokens without quality loss via summarization, caching, and retrieval.
- [ ] Compute: what is the break-even cache read count for a 30K-token cached prefix?

Deliverable: a markdown write-up of thinking budget ROI curves and a before/after context diet.

---

## Week 3 - Tool Use and MCP at Scale

Goal: design production-grade tools and MCP servers.

- [ ] Read `notes/04-tool-use-and-mcp-integration.md`
- [ ] Audit a 25-tool agent. Prune, merge, or dispatcher-ify until under 20.
- [ ] Add explicit examples to three tool descriptions and A/B against the old descriptions. Measure tool-selection accuracy.
- [ ] Build an MCP server over streamable HTTP. Add OAuth 2.1 auth. Deploy behind a reverse proxy.
- [ ] Add the code execution tool to an agent. Run a data analysis task end to end.
- [ ] Experiment with parallel tool use. Confirm Claude emits multiple tool_use blocks in one response.
- [ ] Read the MCP specification sections on transports and authentication

Deliverable: a deployable MCP server with auth, versioning, and a README.

---

## Week 4 - Evaluation, Observability, and Safety

Goal: ship evals and tracing that catch regressions before users do.

- [ ] Read `notes/05-evaluation-and-observability.md`
- [ ] Build a 50-item eval dataset for one real task
- [ ] Implement an LLM-as-judge grader with a structured rubric. Calibrate against 10 human-labeled items.
- [ ] Wire a tracing system (OpenTelemetry, Langfuse, or custom) that logs tokens, tool calls, cache reads, thinking tokens per trace
- [ ] Add a regression gate in CI: block merges that drop quality by more than 3% on the eval set
- [ ] Run a small red-team suite (jailbreaks, prompt injections, PII leaks). Document failures and mitigations.
- [ ] Add an input classifier (Haiku) in front of an Opus agent. Measure the block rate and latency overhead.

Deliverable: an eval harness, a regression gate, and a red-team report.

---

## Week 5 - Cost, Latency, and Enterprise Deployment

Goal: squeeze cost and deploy on Bedrock and Vertex.

- [ ] Read `notes/06-cost-latency-optimization-at-scale.md`
- [ ] Read `notes/07-enterprise-deployment-bedrock-vertex.md`
- [ ] Add prompt caching breakpoints to your agent. Measure cache hit rate over 100 requests.
- [ ] Move one workload to the Batch API. Verify the 50% discount and 24h SLA fit.
- [ ] Implement model routing: Haiku triage, Sonnet execute, Opus fallback on low confidence.
- [ ] Deploy the same agent via Amazon Bedrock. Handle IAM auth, regional model IDs.
- [ ] Deploy the same agent via Google Vertex AI. Handle service account auth, publisher model IDs.
- [ ] Enable PrivateLink (Bedrock) or VPC Service Controls (Vertex) and confirm no public egress.
- [ ] Document a zero-data-retention (ZDR) request flow if your workload requires it.

Deliverable: a cost-optimized agent deployed on three backends with a deployment matrix.

---

## Week 6 - Review, Scenarios, and Exam Readiness

Goal: close gaps and build exam stamina.

- [ ] Re-read all notes in order, annotating anything unclear
- [ ] Work through every scenario in `scenarios.md` timed (2 minutes per question)
- [ ] Re-read `fact-sheet.md` and flag any fact you cannot explain in your own words
- [ ] Re-read `strategy.md` the night before
- [ ] Take one full simulated exam (use community practice questions if available)
- [ ] Do a cost and latency walkthrough of your own portfolio agent
- [ ] Read Anthropic's latest blog posts for the past 3 months; note any new features
- [ ] Confirm current model IDs, pricing, and exam logistics

Deliverable: ready to sit the exam.

---

## Hands-On Exercises (Pick Any Two)

1. Build a research agent: orchestrator-worker, 20 parallel Haiku workers, consolidated summary via Opus. Target: under $0.10 per research run.
2. Build a customer support agent with memory tool, extended thinking on escalations, and an eval harness tracking CSAT predictions.
3. Build a code review agent using the Agent SDK with hooks that block commits failing quality checks.
4. Build a compliance redaction pipeline via Batch API that processes 10K documents nightly at under $50.
5. Build a multi-cloud Claude gateway that routes between first-party, Bedrock, and Vertex based on request attributes.

---

## Red Flags - Do Not Sit the Exam Yet If

- You cannot explain when orchestrator-worker beats a single agent in cost
- You cannot wire extended thinking with preserved signatures across tool calls
- You have never deployed Claude via Bedrock or Vertex
- You do not have an eval harness for at least one production-like task
- Your cache hit rate on your own projects is under 50% for repeatable workloads
- You cannot draw the MCP client-server-transport diagram from memory
