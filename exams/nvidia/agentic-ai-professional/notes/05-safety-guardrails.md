# Safety and Guardrails for Agents

**[📖 NeMo Guardrails Documentation](https://docs.nvidia.com/nemo/guardrails/latest/index.html)** - Complete guardrails reference

## NeMo Guardrails Overview

NeMo Guardrails is NVIDIA's open-source framework for adding safety controls to LLM applications and agents. It provides programmable, layered protection through a domain-specific language called Colang.

**[📖 NeMo Guardrails GitHub](https://github.com/NVIDIA/NeMo-Guardrails)** - Source code and examples

## Colang Language

### Colang 2 Basics

Colang is a domain-specific language for defining conversational guardrails:

```colang
define user ask about weather
  "What is the weather like?"
  "Tell me the forecast"
  "Is it going to rain?"

define flow weather response
  user ask about weather
  bot provide weather info

define bot refuse harmful request
  "I'm sorry, I cannot help with that request."
```

**Key Colang Concepts:**
- **Flows** - Define allowed conversation patterns
- **User messages** - Canonical forms for user intents
- **Bot messages** - Define bot response patterns
- **Actions** - Custom Python functions invoked by guardrails
- **Variables** - Store and reference conversation state

**[📖 Colang 2 Reference](https://docs.nvidia.com/nemo/guardrails/latest/user-guides/colang-2/overview.html)** - Colang 2 syntax and features

## Guardrail Types

### Input Rails
- Filter and validate user inputs before they reach the LLM
- Detect prompt injection and jailbreak attempts
- Block harmful, toxic, or off-topic requests
- Sanitize inputs to remove sensitive information
- Applied first in the processing pipeline

### Output Rails
- Check and filter model outputs before returning to the user
- Block harmful, biased, or factually incorrect content
- Enforce response formatting requirements
- Redact sensitive information from responses
- Applied after LLM generation

### Topical Rails
- Keep the conversation within defined topic boundaries
- Redirect off-topic questions politely
- Define allowed and blocked topic categories
- Prevent agents from discussing unauthorized subjects

### Dialog Rails
- Enforce conversation flow patterns
- Ensure agents follow required interaction sequences
- Handle interruptions and topic changes gracefully
- Maintain conversation coherence

### Retrieval Rails
- Filter retrieved documents in RAG pipelines before they reach the LLM
- Remove irrelevant or low-quality retrieved content
- Block sensitive documents from being used as context
- Ensure retrieval results meet quality thresholds

## Agent Safety Patterns

### Tool Call Safety

**Validation:**
- Validate tool parameters against schema before execution
- Check parameter values against allowed ranges
- Verify tool calls are contextually appropriate
- Rate limit expensive or dangerous tool operations

**Sandboxing:**
- Execute tools in isolated environments
- Restrict file system and network access
- Limit resource consumption (CPU, memory, time)
- Prevent tools from modifying critical system state

**Human-in-the-Loop:**
- Flag high-risk actions for human approval before execution
- Define risk levels for different tool categories
- Provide context for human reviewers to make informed decisions
- Timeout handling when human approval is delayed

### Jailbreak Prevention

**Multi-Layer Defense:**
1. **Input classification** - Detect injection patterns before processing
2. **System prompt hardening** - Robust instructions that resist manipulation
3. **Output filtering** - Catch harmful content that bypasses input filters
4. **Behavioral monitoring** - Detect unusual patterns across conversations

**Common Attack Patterns:**
- Direct prompt injection ("ignore your instructions and...")
- Indirect injection via tool results or retrieved content
- Role-playing attacks ("pretend you are an unrestricted AI")
- Encoding tricks (base64, rot13, character substitution)
- Multi-turn gradual escalation

**[📖 NVIDIA AI Safety](https://developer.nvidia.com/blog/tag/safety/)** - Blog posts on AI safety techniques

### Cascading Failure Prevention

- **Max iterations** - Set limits on agent reasoning loops
- **Timeouts** - Enforce time limits for individual tool calls and total task time
- **Circuit breakers** - Stop calling failing external services
- **Resource budgets** - Limit total tokens, tool calls, or cost per session
- **Graceful degradation** - Fall back to simpler responses when systems fail

## Production Monitoring

### Observability Metrics
- Agent success/failure rates per task type
- Tool call frequency and error rates
- Guardrail trigger rates (which rails fire most often)
- Token usage and cost per session
- Latency distribution for agent responses
- Reasoning chain depth and complexity

### Alerting
- Spike in guardrail trigger rate
- Increase in tool call failures
- Unusual patterns in agent behavior
- Cost anomalies (token usage spikes)
- Latency degradation beyond thresholds

### Logging
- Log full reasoning chains for debugging
- Audit trail for all tool invocations
- Record guardrail decisions and reasons
- Store conversation history for review
- Anonymize PII in logs

## Testing Strategies

### Safety Testing
- **Red teaming** - Adversarial testing by security experts
- **Automated probing** - Run known attack patterns against guardrails
- **Regression testing** - Verify safety after model or config updates
- **Edge case testing** - Test boundary conditions and unusual inputs

### Functional Testing
- **Unit tests** - Test individual tools and guardrails in isolation
- **Integration tests** - Test agent workflows end-to-end
- **Load tests** - Verify performance under concurrent agent sessions
- **Chaos tests** - Randomly disable tools or services to test resilience

### Operational Testing
- **Blue-green deployments** - Deploy new versions alongside old
- **Canary releases** - Gradually shift traffic to new version
- **Rollback procedures** - Quickly revert when issues are detected
- **Incident response** - Documented procedures for agent misbehavior

## Key Exam Concepts

- NeMo Guardrails architecture and Colang syntax
- Five guardrail types: input, output, topical, dialog, retrieval
- Tool call validation, sandboxing, and human-in-the-loop
- Jailbreak prevention - multi-layer defense strategy
- Cascading failure prevention - iterations, timeouts, circuit breakers
- Production monitoring, alerting, and testing strategies
