# NCP-AAI High-Yield Scenarios and Practice Problems

## Scenario 1: Choosing the Right Agent Pattern

**Scenario**: A customer support team wants an AI agent that can look up order status, process returns, and answer product questions. The tasks vary per conversation and the agent needs to decide what to do based on user messages. Which agent pattern is most appropriate?

**Solution Pattern**:
- **Best Choice**: ReAct pattern with tool access
- **Reasoning**: Tasks are open-ended and vary per conversation. The agent needs to reason about which tool to use based on user input, execute the tool, observe results, and decide next steps dynamically.

**Common Distractors**:
- Plan-and-Execute - over-engineered for reactive customer support where tasks are typically 1-3 steps
- Reflexion - unnecessary self-improvement loop for straightforward tool-calling tasks
- Hard-coded workflow - too rigid for variable customer requests

**Key Takeaway**: ReAct is the default choice for general-purpose agents that need dynamic tool selection. Plan-and-Execute is better for complex, multi-step tasks with known structure.

---

## Scenario 2: Multi-Agent System Design

**Scenario**: A company wants to build an automated code review system. The system should analyze code for bugs, check style compliance, evaluate security vulnerabilities, and generate a summary report. How should the multi-agent system be designed?

**Solution Pattern**:
- **Architecture**: Hierarchical orchestration with specialized agents
- **Orchestrator Agent**: Receives code, delegates to specialists, aggregates results
- **Bug Detector Agent**: Analyzes code logic and identifies potential bugs
- **Style Checker Agent**: Validates code against style guidelines
- **Security Analyzer Agent**: Scans for vulnerability patterns
- **Reporter Agent**: Synthesizes findings into a structured report
- **Execution**: Bug, style, and security agents run in parallel; reporter runs after all complete

**Common Distractors**:
- Single agent with all capabilities - too complex, hard to maintain, context window limitations
- Sequential execution of all checks - unnecessary latency when checks are independent
- Only using static analysis tools without LLM agents - misses semantic understanding of code intent

**Key Takeaway**: Use parallel orchestration for independent agent tasks and hierarchical structure for clear responsibility delegation.

---

## Scenario 3: Tool Call Error Handling

**Scenario**: An agent uses an external weather API that occasionally returns 503 errors during peak traffic. The agent should provide weather information reliably. How should error handling be implemented?

**Solution Pattern**:
- **Primary strategy**: Exponential backoff retry (3 attempts max)
- **Secondary**: Circuit breaker to stop calling after 5 consecutive failures
- **Fallback**: Use cached weather data if available, or inform user of temporary unavailability
- **Recovery**: Agent communicates the limitation honestly rather than hallucinating weather data

**Common Distractors**:
- Retry indefinitely - wastes resources and blocks the agent
- Immediately fail and tell user to try later - poor experience when retries would succeed
- Use the LLM to guess the weather - hallucination is worse than admitting unavailability
- Switch to a different weather API without validation - may produce inconsistent data

**Key Takeaway**: Implement layered error handling: retry, circuit breaker, fallback, graceful degradation. Never let the agent hallucinate data when a tool fails.

---

## Scenario 4: Guardrails Configuration

**Scenario**: A financial services company deploys an agent that helps customers manage their investment portfolios. The agent must not provide specific investment advice (regulated activity), must not reveal other customers' data, and must stay on topic. How should NeMo Guardrails be configured?

**Solution Pattern**:
- **Input Rails**: Detect and block requests for specific investment recommendations
- **Output Rails**: Filter responses that could be construed as personalized financial advice; redact any PII
- **Topical Rails**: Restrict conversation to portfolio viewing, general education, and account management
- **Dialog Rails**: Require disclaimer when discussing market information
- **Human escalation**: Route complex financial questions to licensed advisors

**Common Distractors**:
- Relying on the model's training to avoid financial advice - insufficient for regulatory compliance
- Blocking all financial discussion - too restrictive, prevents legitimate use cases
- Only output filtering without input filtering - prompt injection could bypass output-only controls
- No logging or audit trail - regulatory environments require conversation records

**Key Takeaway**: Regulated industries need defense-in-depth with multiple guardrail types and comprehensive audit logging.

---

## Scenario 5: NIM Model Selection for Agents

**Scenario**: A startup is building a coding assistant agent that needs to write code, run tests, and iterate on solutions. They have a single NVIDIA A100 80GB GPU. The agent must support function calling for tool use. Which NIM model configuration is best?

**Solution Pattern**:
- **Best Choice**: LLaMA 3.1 70B with INT8 quantization via NIM
- **Reasoning**: 70B model provides strong coding and reasoning capabilities; INT8 quantization fits within 80GB A100 memory; NIM handles optimization automatically; model supports function calling
- **Configuration**: Enable streaming for responsive interaction; set lower temperature (0.1-0.3) for code generation accuracy

**Common Distractors**:
- 405B model - does not fit on a single A100 even with quantization
- 8B model - insufficient reasoning and coding quality for iterative code development
- FP32 deployment of 70B - requires ~280GB, far exceeds A100 capacity
- Non-function-calling model - agent pattern requires tool use capability

**Key Takeaway**: Match model size to available GPU memory with appropriate quantization. Verify function calling support before deploying for agent workloads.

---

## Scenario 6: Memory System Design

**Scenario**: An AI research assistant agent helps scientists with literature review. It needs to remember papers discussed in previous sessions, track the scientist's research interests over time, and recall successful search strategies. Which memory architecture should be used?

**Solution Pattern**:
- **Short-term memory**: Current conversation context - papers being discussed now
- **Long-term memory**: Vector database storing previously discussed papers, key findings, and research interests
- **Episodic memory**: Records of past research sessions - which search strategies worked, which databases yielded best results
- **Retrieval**: Semantic search over long-term memory triggered by current research topics

**Common Distractors**:
- Only short-term memory - loses all context between sessions, forces users to repeat themselves
- Storing everything in the context window - exceeds context limits quickly with academic papers
- Keyword-only search for memory retrieval - misses semantic connections between research topics
- No episodic memory - agent cannot learn from past successful research patterns

**Key Takeaway**: Complex, long-running agent tasks require all three memory types working together. Use vector databases for semantic retrieval of long-term knowledge.

---

## Scenario 7: Agent Safety Testing

**Scenario**: Before deploying a customer-facing agent, the team needs to validate its safety. The agent has access to a customer database, a payment system, and a messaging system. What testing strategy should be used?

**Solution Pattern**:
- **Red teaming**: Security experts attempt prompt injection, privilege escalation, and data exfiltration
- **Tool safety audit**: Verify parameter validation for database queries (SQL injection prevention), payment limits, and message recipient validation
- **Guardrail testing**: Run automated attack patterns against NeMo Guardrails configuration
- **Sandbox testing**: Verify tools cannot access resources beyond their intended scope
- **Load testing**: Ensure safety controls remain effective under high concurrency

**Common Distractors**:
- Only testing happy paths - misses adversarial scenarios
- Skipping tool-level security testing - guardrails alone cannot prevent tool misuse
- Testing once before deployment only - safety requires continuous validation
- Manual testing only - insufficient coverage for automated agent systems

**Key Takeaway**: Agent safety testing requires both adversarial (red team) and systematic (automated) approaches across all layers - input, tools, output, and infrastructure.

---

## Scenario 8: Production Scaling

**Scenario**: An enterprise deploys an agent system handling 10,000 concurrent users. Each agent session involves an average of 5 LLM calls and 3 tool calls. The system runs on NVIDIA H100 GPUs with NIM. How should the infrastructure be architected?

**Solution Pattern**:
- **NIM deployment**: Multiple NIM instances behind a load balancer with auto-scaling
- **Tool execution**: Separate service for tool execution with its own scaling policy
- **Queue system**: Message queue between agent orchestrator and tool execution for async processing
- **State management**: Redis or similar for session state with TTL-based cleanup
- **Monitoring**: Track per-session latency, tool queue depth, GPU utilization, and error rates
- **Scaling triggers**: Auto-scale NIM instances on GPU utilization > 80% or P95 latency > target

**Common Distractors**:
- Single NIM instance - cannot handle 10,000 concurrent users
- Synchronous tool execution blocking LLM inference - wastes GPU resources during tool wait time
- No session state management - losing context between agent turns
- Scaling only on CPU utilization - GPU utilization is the correct metric for NIM scaling

**Key Takeaway**: Separate LLM inference from tool execution, use async processing with queues, and scale based on GPU utilization and latency metrics.
