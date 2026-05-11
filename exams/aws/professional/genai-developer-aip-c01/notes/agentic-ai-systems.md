# Agentic AI Systems Deep-Dive

> **Cross-cutting deep-dive.** Agentic AI is the largest single concept in Domain 2 (26%) and is also tested in Domain 5 evaluation (skill 5.1.7). Bedrock Agents, AgentCore, Strands, Agent Squad, and MCP all have testable distinctions.

## Table of contents

- [What an agent is](#what-an-agent-is)
- [The AWS agent stack](#the-aws-agent-stack)
- [Amazon Bedrock Agents](#amazon-bedrock-agents)
- [Amazon Bedrock AgentCore](#amazon-bedrock-agentcore)
- [Strands Agents](#strands-agents)
- [AWS Agent Squad](#aws-agent-squad)
- [Model Context Protocol (MCP)](#model-context-protocol-mcp)
- [Custom agents with Step Functions](#custom-agents-with-step-functions)
- [Reasoning patterns](#reasoning-patterns)
- [Memory and state](#memory-and-state)
- [Safety and safeguards](#safety-and-safeguards)
- [Agent evaluation](#agent-evaluation)
- [Decision matrix: pick the right agent layer](#decision-matrix-pick-the-right-agent-layer)
- [Quick-recall summary](#quick-recall-summary)

## What an agent is

An **AI agent** is an FM-driven loop that:

1. **Plans** - given a goal, decides what to do next
2. **Acts** - calls tools (APIs, code, vector search, other agents)
3. **Observes** - takes the tool result back into context
4. **Iterates** - repeats until the goal is achieved

The FM is the brain; tools are the hands; memory is the notepad; orchestration is the loop.

**Why "agentic" is testable now**: a single FM call can't do something like "look up Pat's last 3 orders, calculate refund eligibility, file a support ticket if eligible." That requires multiple tool calls + state. Agents make that tractable.

## The AWS agent stack

| Layer | Service | What it provides |
|-------|---------|------------------|
| **Managed agent (turnkey)** | Amazon Bedrock Agents | Orchestration + Knowledge Base integration + action groups (your Lambda/API tools) + Guardrails |
| **Production runtime** | Amazon Bedrock AgentCore | Secure, scalable runtime for production agents - identity, memory, observability, browser tool, code interpreter, gateway, multi-agent collaboration |
| **Code-first SDK** | Strands Agents (open-source) | Python SDK for tool-calling agents with streaming, retries, state |
| **Multi-agent orchestrator** | AWS Agent Squad (open-source) | Coordinates multiple specialized agents (supervisor + workers) |
| **Tool protocol** | Model Context Protocol (MCP) | Open standard tool interface; AWS hosts via Lambda or ECS |
| **Custom orchestration** | AWS Step Functions | DIY agent loops with full control |

## Amazon Bedrock Agents

The exam-relevant features:

- **Action groups** - bundle related actions backed by Lambda functions or OpenAPI-defined APIs. The agent's "tools."
- **Knowledge Base association** - attach a Bedrock Knowledge Base for RAG within the agent.
- **Guardrails association** - apply input/output safety checks on every model invocation in the agent loop.
- **Prompt overrides** - customize the system prompt for each agent stage (pre-processing, orchestration, post-processing).
- **Agent versions and aliases** - similar to Lambda. Versions are immutable; aliases (`PROD`, `STAGING`) point at versions.
- **Trace** - structured trace of agent reasoning, tool calls, observations - critical for debugging and exam scenarios.
- **Session attributes / session state** - per-session memory passed across turns.
- **Return of control** - instead of Bedrock invoking your action Lambda directly, hand control back to the caller to execute the action (useful for client-side actions or async ops).

Architecture:
```
User -> App -> Bedrock Agent (alias)
                |
                |- Action Group A (Lambda) -> Calls API or DB
                |- Action Group B (Lambda) -> ...
                |- Knowledge Base -> retrieval
                |- Guardrails -> safety
                |- Prompt overrides
                v
              Bedrock FM (Anthropic / Nova / etc.)
```

Use Bedrock Agents when:
- You want fastest path to a working agent
- Tools are AWS-side (Lambda, your APIs)
- You need built-in RAG and Guardrails

## Amazon Bedrock AgentCore

A newer service in the AIP-C01 in-scope list. AgentCore is the **production runtime** for AI agents - intended for agents that need to run reliably at scale beyond what Bedrock Agents alone provide.

Components (exam-relevant by name):
- **AgentCore Runtime** - secure, isolated execution of agents
- **AgentCore Memory** - managed agent memory (semantic + episodic)
- **AgentCore Identity** - per-agent identity for fine-grained access control
- **AgentCore Gateway** - bridges agents to enterprise tools (MCP, OpenAPI, etc.)
- **AgentCore Browser** - sandboxed browser tool for agents to use the web
- **AgentCore Code Interpreter** - sandboxed code execution tool
- **AgentCore Observability** - traces, metrics, prompts/responses logged

When to choose AgentCore over Bedrock Agents:
- Production-grade SLA / observability requirements
- Multi-agent at scale
- Need browser / code interpreter as built-in tools without rolling your own
- Tight identity + tool access governance

## Strands Agents

AWS's open-source code-first agent SDK.

Key features:
- Tool calling with simple function decoration (`@tool`)
- Streaming output
- State management
- Multi-step reasoning with retry
- Direct integration with Bedrock and other model providers

When to choose Strands:
- You want code-first control rather than declarative configuration
- Custom logic between tool calls
- Tight integration with your codebase / SDK patterns

The exam may test "open-source AWS agent framework for code-first development" → **Strands Agents**.

## AWS Agent Squad

AWS's open-source multi-agent orchestration framework.

Patterns it supports:
- **Supervisor + workers**: a router agent dispatches to specialist agents
- **Sequential pipelines**: agents in series
- **Voting / ensemble**
- **Persistent state across agents**

When to choose Agent Squad:
- Multiple specialized agents (research / coding / writing / etc.)
- Need explicit orchestration topology
- Coordination logic too complex for a single agent

## Model Context Protocol (MCP)

MCP is an **open standard** (originated by Anthropic, broadly adopted) for exposing tools to LLMs.

Two roles:
- **MCP server** - exposes a set of tools (and resources, prompts)
- **MCP client** - lives in the agent runtime, connects to one or more MCP servers, presents tools to the FM

AWS hosting recommendations (exam-relevant):
- **Lightweight stateless tools** → host MCP server on **AWS Lambda**
- **Heavier or stateful tools** → host MCP server on **Amazon ECS** (or EKS)
- **MCP Gateway** in Bedrock AgentCore for managed enterprise MCP exposure

Why MCP shows up on the exam:
- It's the **shareable / reusable** tool layer pattern. Once you have an MCP server for, say, "calendar tools," any compatible agent can use it.
- It separates **tool implementation** from **agent runtime**.

## Custom agents with Step Functions

When you want full transparency and don't need a managed runtime:

```
Step Functions state machine:

  state Init -> Pass user input + system prompt
       |
       v
  state CallFM (Lambda) -> Bedrock with tool schema
       |
       v
  state Choice (on FM response)
       |
       +-- if final answer -> state Done
       +-- if tool call -> state ExecuteTool (Lambda)
                              |
                              v
                            state RecordObservation -> append to context
                              |
                              v
                            (loop back to CallFM)
       +-- if max iterations exceeded -> state ErrorOut
```

Advantages:
- Total control over state, retries, errors
- Visualizable in Step Functions console
- Native AWS service integrations (DynamoDB, SNS, S3, Lambda) without writing tool code

Disadvantages:
- More boilerplate vs Bedrock Agents
- You have to wire memory, tracing, guardrails yourself

## Reasoning patterns

| Pattern | Description | When useful |
|---------|-------------|-------------|
| **Chain-of-thought (CoT)** | "Think step by step" before final answer | Math, multi-step logic |
| **ReAct (Reason + Act)** | Thought → Action → Observation → Thought, ... | Tool-using agents |
| **Plan-and-Execute** | Generate full plan first, execute steps | Long-horizon tasks |
| **Reflection / self-critique** | Generate, critique own output, revise | Quality-sensitive outputs |
| **Tree of Thoughts** | Branching exploration with backtracking | Combinatorial / search problems |
| **Self-consistency** | Generate N answers, take majority | Sensitive math / reasoning |

The exam tests **ReAct + tool use** most heavily because that's how Bedrock Agents internally operate.

## Memory and state

| Memory type | Implementation |
|-------------|----------------|
| **In-context (short-term)** | Conversation history in prompt; bounded by context window |
| **Persistent (long-term)** | DynamoDB conversation table indexed by `session_id` |
| **Episodic (semantic)** | Past messages embedded into a vector store (mini RAG over your own conversations) |
| **Procedural** | Agent's learned procedures - typically prompts, templates |
| **Managed** | **Bedrock AgentCore Memory** - handles all of the above |

State at the orchestration layer:
- **Bedrock Agent session attributes** - per-session key-value state
- **Step Functions execution input** - state passed through state machine

## Safety and safeguards

The Domain 2 task 2.1.3 calls out specific safeguards. The exam wants the layered answer:

| Safeguard | AWS implementation |
|-----------|--------------------|
| **Stopping conditions** | Step Functions max attempts / max iterations / max execution time; Bedrock Agents max iteration limit |
| **Timeouts** | Lambda function timeout; HTTP client timeout in tool calls |
| **Resource boundaries (least privilege)** | IAM execution role on the agent Lambda; tool Lambdas can only call permitted resources |
| **Cost circuit breakers** | DynamoDB counter incremented per invocation; abort if threshold exceeded; CloudWatch alarm + EventBridge to disable agent |
| **Failure circuit breakers** | Track consecutive tool failures; short-circuit when N failures within window |
| **Output validation** | JSON schema validation on every FM response; Lambda layer; reject + retry malformed |
| **Content safety** | **Bedrock Guardrails** on every model invocation in the loop |
| **Prompt injection defense** | Input sanitization; Guardrails denied topics; tool-call argument validation |

## Agent evaluation

Tested in Domain 5 (skill 5.1.7).

Metrics to evaluate agents:

- **Task completion rate** - what % of agent runs reach a successful final answer
- **Tool call accuracy** - is the agent picking the right tool for the task
- **Tool argument correctness** - are the arguments well-formed
- **Reasoning quality** - manual or LLM-as-judge review of trace
- **Latency per turn** - observed at API Gateway / Lambda
- **Token usage per task** - cost proxy
- **Error rate / fallback rate**

AWS-native:
- **Bedrock Agent evaluation** - automated evaluation of agent traces
- **CloudWatch metrics + Bedrock Model Invocation Logs** for token usage and per-step analytics
- **X-Ray** for distributed traces of agent + tools

LLM-as-judge for trace quality: feed the trace (thoughts + actions + observations) to a strong model and ask it to score reasoning quality, completeness, efficiency.

## Decision matrix: pick the right agent layer

Common exam scenarios:

| Scenario | Best fit |
|----------|----------|
| "Build a customer support agent that uses our knowledge base and a refund API" | **Bedrock Agents** with action group + Knowledge Base + Guardrails |
| "Production agent platform with browser tool + code interpreter + identity scoping per user" | **Bedrock AgentCore** |
| "Code-first agent SDK from AWS, open source" | **Strands Agents** |
| "Coordinate research, coding, summarizer agents" | **AWS Agent Squad** |
| "Reusable tools shared across many agents and teams" | **MCP servers** (Lambda stateless / ECS stateful) |
| "Full custom orchestration with branching, retries, human approval" | **Step Functions** |
| "Quick chatbot over my private knowledge with no code" | **Q Business** (not technically agentic, but addresses the same business problem) |

## Quick-recall summary

- An agent = FM brain + tools + memory + loop.
- Stack: **Bedrock Agents** (managed) → **AgentCore** (production runtime) → **Strands Agents** (code-first SDK) → **AWS Agent Squad** (multi-agent orchestrator) → **Step Functions** (custom).
- **Bedrock Agents** features: action groups (Lambda/API), Knowledge Base assoc, Guardrails assoc, prompt overrides, versions/aliases, traces, session state, return of control.
- **Bedrock AgentCore** components: Runtime, Memory, Identity, Gateway, Browser, Code Interpreter, Observability.
- **Strands Agents** = AWS open-source code-first agent SDK.
- **AWS Agent Squad** = AWS open-source multi-agent orchestrator.
- **MCP** = open standard for tools; Lambda for stateless / ECS for stateful; reusable across agents.
- Reasoning: CoT, **ReAct**, plan-and-execute, reflection, ToT, self-consistency.
- Memory types: in-context, persistent (DynamoDB), episodic (vector store), managed (**AgentCore Memory**).
- Safeguards (layered): stopping conditions, timeouts, IAM least privilege, cost / failure circuit breakers, output validation, **Guardrails** on every invocation, prompt injection defense.
- Agent evaluation: task completion, tool call accuracy, reasoning quality (LLM-as-judge), Bedrock Agent evaluation, X-Ray, CloudWatch.
- Default decision: managed → Bedrock Agents; production-grade scale → AgentCore; multi-agent → Agent Squad; custom → Step Functions.
