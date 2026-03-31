# NVIDIA Agentic AI Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-AAI
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Agentic AI Architectures | 20% | Agent patterns, memory, state management |
| Tool Use and Function Calling | 20% | Function calling, APIs, tool orchestration |
| Planning and Reasoning | 20% | CoT, task decomposition, self-reflection |
| NVIDIA NIM and Infrastructure | 20% | NIM deployment, model selection, scaling |
| Safety, Guardrails, and Production | 20% | NeMo Guardrails, monitoring, testing |

## Domain 1: Agentic AI Architectures

### Core Agent Patterns

**ReAct (Reasoning + Acting)**
- Interleaves thinking and action steps
- Thought: Reason about current state and next step
- Action: Execute a tool or API call
- Observation: Process result and reason about next step
- Continues until task is complete or max iterations reached
- Most popular pattern for general-purpose agents
- **[📖 NVIDIA Agentic AI Guide](https://developer.nvidia.com/blog/introduction-to-ai-agents/)** - Introduction to agentic AI concepts

**Plan-and-Execute**
- First phase: Generate a complete plan for the task
- Second phase: Execute each step sequentially
- Re-planning: Update plan based on execution results
- Better for complex multi-step tasks
- More predictable than ReAct for structured workflows

**Reflexion**
- Execute task attempt
- Self-evaluate the result against success criteria
- Reflect on what went wrong and how to improve
- Retry with improved approach
- Stores reflections in memory for future attempts
- Good for tasks with clear success/failure criteria

**Tool-Augmented Generation**
- LLM decides when and which tool to call during generation
- Tools extend model capabilities (search, calculation, code execution)
- Parallel tool calls for independent operations
- Sequential tool calls when results depend on previous calls

**Multi-Agent Debate**
- Multiple agents generate independent responses
- Agents critique each other's responses
- Iterate until consensus or maximum rounds
- Improves accuracy for reasoning tasks
- **[📖 NVIDIA Multi-Agent Systems](https://developer.nvidia.com/blog/tag/agents/)** - NVIDIA blog posts on agent architectures

### Memory Systems

**Short-Term Memory (Working Memory)**
- Current conversation context and recent messages
- Tool call results and observations
- Limited by context window size
- Managed through conversation history

**Long-Term Memory**
- Persistent storage of facts and experiences
- Vector database for semantic retrieval
- Structured knowledge graphs for relationships
- Survives across conversation sessions

**Episodic Memory**
- Records of past task executions and outcomes
- Successful strategies for similar tasks
- Failed approaches to avoid
- Enables learning from experience

**Memory Management Strategies**
- Summarize older messages to save context space
- Use RAG for long-term fact retrieval
- Priority-based retention of important information
- Periodic memory consolidation and cleanup

### State Management
- Conversation state tracking across turns
- Task progress and intermediate results
- Agent internal state (goals, plans, beliefs)
- Shared state in multi-agent systems
- State persistence for long-running tasks
- **[📖 LangChain Agent State](https://python.langchain.com/docs/concepts/agents/)** - Agent state management patterns

## Domain 2: Tool Use and Function Calling

### Function Calling Fundamentals

**Schema Definition**
- JSON Schema format for function parameters
- Name, description, parameter types and constraints
- Required vs optional parameters
- Nested object and array parameter support
- Clear descriptions help LLM select correct tools
- **[📖 NVIDIA NIM Function Calling](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Function calling with NIM

**Parameter Extraction**
- LLM extracts parameters from natural language
- Type coercion (strings to numbers, dates, etc.)
- Handling ambiguous or missing parameters
- Validation of extracted parameters before execution

**Tool Selection**
- LLM chooses which tool to call based on user intent
- Multiple tools may be relevant - model selects best match
- No tool needed for conversational responses
- Dynamic tool availability based on context

### Tool Orchestration

**Sequential Execution**
- One tool at a time, results feed into next decision
- Simple to implement and debug
- Can be slow for independent operations
- Appropriate when tools have dependencies

**Parallel Execution**
- Multiple independent tool calls simultaneously
- Reduces total latency for independent operations
- Requires identifying independent vs dependent tools
- More complex error handling

**Pipeline Patterns**
- Chain of tools for data transformation
- Map-reduce for processing multiple items
- Fan-out/fan-in for parallel sub-tasks
- Conditional branching based on tool results

### Error Handling

**Retry Strategies**
- Exponential backoff for transient failures
- Maximum retry count to prevent infinite loops
- Different strategies for different error types
- Fallback to alternative tools or approaches

**Error Recovery**
- Parse error messages and adjust parameters
- Self-correct based on error feedback
- Ask user for clarification when needed
- Graceful degradation to simpler approaches
- **[📖 NeMo Guardrails Actions](https://docs.nvidia.com/nemo/guardrails/latest/user-guides/configuration-guide/index.html)** - Configuring action handling

### Custom Tool Development
- Define clear input/output schemas
- Include detailed descriptions for LLM understanding
- Handle errors gracefully and return informative messages
- Document expected behavior and edge cases
- Test tools independently before agent integration
- Version tools and maintain backward compatibility

## Domain 3: Planning and Reasoning

### Reasoning Techniques

**Chain-of-Thought (CoT)**
- Step-by-step reasoning before final answer
- "Let me think through this step by step..."
- Improves accuracy on complex reasoning tasks
- Can be triggered with few-shot examples or instructions

**Tree of Thought**
- Explore multiple reasoning paths
- Evaluate and prune unpromising branches
- Backtrack and try alternatives
- Best for problems with multiple valid approaches

**Self-Consistency**
- Generate multiple reasoning paths
- Vote on the most common answer
- More robust than single-path reasoning
- Useful for math and logic problems

**Inner Monologue**
- Agent reasons internally before responding
- Separates thinking from user-facing output
- Allows more thorough reasoning without cluttering output
- Can be logged for debugging
- **[📖 NVIDIA Reasoning Models](https://build.nvidia.com/)** - Test reasoning capabilities on build.nvidia.com

### Task Decomposition

**Hierarchical Planning**
- Break complex task into high-level sub-tasks
- Each sub-task may be further decomposed
- Execute leaf tasks with specific tools
- Aggregate results up the hierarchy

**Sequential Decomposition**
- Order sub-tasks by dependency
- Execute in sequence with results passing forward
- Re-plan if any sub-task fails
- Clear execution path

**Dynamic Re-Planning**
- Monitor execution progress
- Detect when plan needs adjustment
- Generate revised plan based on new information
- Balance between plan stability and adaptation

### Self-Reflection and Improvement
- Evaluate quality of generated responses
- Identify errors or gaps in reasoning
- Generate improved responses based on reflection
- Learn from mistakes across sessions (with memory)
- Know when to stop iterating (convergence criteria)

## Domain 4: NVIDIA NIM and Infrastructure

### NVIDIA NIM for Agents

**Model Selection for Agents**
- Function-calling capable models (LLaMA 3.1, Mixtral)
- Models with strong reasoning abilities
- Consider latency requirements for interactive agents
- Balance quality and speed for agent backends
- **[📖 NIM LLM Models](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Available NIM models
- **[📖 NIM Model Cards](https://build.nvidia.com/)** - Model capabilities and performance

**Deployment Options**
- Docker containers for single-node deployment
- Kubernetes for scalable multi-node deployment
- Cloud deployment on AWS, Azure, GCP with NVIDIA GPUs
- NVIDIA AI Enterprise for managed deployment

**Configuration for Agent Workloads**
- Enable function calling in model configuration
- Optimize for low latency (agent interactions should feel fast)
- Configure appropriate context length for agent memory
- Set up streaming for responsive user experience

**Scaling Agent Infrastructure**
- Horizontal scaling with load balancer
- Queue-based processing for async tool calls
- Separate inference and tool execution services
- Auto-scaling based on agent session count
- **[📖 NIM Deployment Guide](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Deployment configuration

### Integration Patterns

**Agent Framework Integration**
- LangChain with NIM as LLM backend
- LlamaIndex with NIM for agent and RAG
- Custom agent frameworks with NIM OpenAI-compatible API
- NVIDIA AI Workbench for development

**API Architecture**
- OpenAI-compatible chat completions API
- Function calling through tool_choice parameter
- Streaming responses for real-time interaction
- Structured output with JSON mode
- **[📖 NIM API Reference](https://docs.nvidia.com/nim/large-language-models/latest/reference.html)** - Complete API documentation

## Domain 5: Safety, Guardrails, and Production

### NeMo Guardrails

**Colang Language**
- Domain-specific language for defining guardrails
- Define conversation flows and boundaries
- Specify allowed and blocked patterns
- Natural language-like syntax for rail definitions
- **[📖 NeMo Guardrails Documentation](https://docs.nvidia.com/nemo/guardrails/latest/index.html)** - Complete guardrails documentation
- **[📖 Colang Language Reference](https://docs.nvidia.com/nemo/guardrails/latest/user-guides/colang-2/overview.html)** - Colang 2 syntax and features

**Guardrail Types**
- **Input Rails:** Filter and validate user inputs before processing
- **Output Rails:** Check and filter model outputs before returning
- **Topical Rails:** Keep conversation within defined topics
- **Dialog Rails:** Enforce conversation flow patterns
- **Retrieval Rails:** Filter retrieved documents in RAG

**Implementation Patterns**
- Define topics the agent should discuss
- Block sensitive or off-topic requests
- Enforce response formatting requirements
- Prevent information disclosure (PII, secrets)
- Rate limiting for tool calls
- **[📖 NeMo Guardrails GitHub](https://github.com/NVIDIA/NeMo-Guardrails)** - Source code and examples

### Agent Safety

**Tool Call Safety**
- Validate tool parameters before execution
- Sandbox tool execution environments
- Rate limit expensive or dangerous operations
- Approve high-risk actions with human-in-the-loop
- Audit log all tool invocations

**Jailbreak Prevention**
- Detect prompt injection attempts
- Multi-layer defense (input filter + output filter)
- Regular testing against known attack patterns
- Update defenses as new attacks emerge

**Cascading Failure Prevention**
- Set maximum iterations per agent loop
- Timeout for individual tool calls
- Circuit breakers for failing external services
- Graceful degradation when tools are unavailable
- **[📖 NVIDIA AI Safety](https://developer.nvidia.com/blog/tag/safety/)** - NVIDIA blog posts on AI safety

### Production Deployment

**Monitoring and Observability**
- Track agent success/failure rates
- Monitor tool call patterns and frequencies
- Log reasoning chains for debugging
- Alert on unusual behavior patterns
- Track token usage and costs per session

**Testing Strategies**
- Unit tests for individual tools
- Integration tests for agent workflows
- Adversarial testing for safety
- Load testing for scalability
- Regression testing for model updates

**Operational Patterns**
- Blue-green deployments for model updates
- Feature flags for new agent capabilities
- Rollback procedures for degraded performance
- Incident response for agent misbehavior
- Capacity planning for agent workloads

## Exam Tips

### Key Concepts to Master
1. Know all major agent patterns (ReAct, Plan-and-Execute, Reflexion)
2. Understand function calling schema design and parameter extraction
3. Master NeMo Guardrails Colang syntax and rail types
4. Know NIM deployment and configuration for agent workloads
5. Understand multi-agent orchestration patterns

### Common Exam Patterns
- "Which agent pattern best suits..." - Match pattern to task characteristics
- "How to prevent..." - Think guardrails and safety measures
- "Which NIM configuration..." - Consider latency, function calling, context
- "Design a multi-agent system..." - Consider roles, communication, orchestration
- "How to handle tool failure..." - Think retry, fallback, graceful degradation
