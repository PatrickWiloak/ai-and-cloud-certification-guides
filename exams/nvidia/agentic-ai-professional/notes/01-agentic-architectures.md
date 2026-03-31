# Agentic AI Architectures

**[📖 NVIDIA Agentic AI Guide](https://developer.nvidia.com/blog/introduction-to-ai-agents/)** - Introduction to AI agent concepts and patterns

## Agent Design Patterns

### ReAct (Reasoning + Acting)

**Core Loop:**
1. **Thought** - Reason about the current state and determine next action
2. **Action** - Execute a tool or API call
3. **Observation** - Process the result
4. Repeat until task is complete or max iterations reached

**Characteristics:**
- Most popular general-purpose agent pattern
- Interleaves reasoning and action steps
- Grounded in external tool feedback
- Works well for open-ended tasks with tool access
- Can get stuck in loops without proper termination conditions

**When to Use:**
- General-purpose question answering with tools
- Information retrieval and synthesis tasks
- Tasks where the steps are not known in advance
- Interactive debugging and exploration

### Plan-and-Execute

**Two Phases:**
1. **Planning phase** - Generate a complete step-by-step plan
2. **Execution phase** - Execute each step sequentially, collecting results

**Re-planning:**
- Monitor execution progress against the plan
- Detect when results deviate from expectations
- Generate a revised plan incorporating new information
- Balance plan stability vs adaptation

**When to Use:**
- Complex multi-step workflows with known structure
- Tasks where order of operations matters
- Situations requiring predictable execution paths
- Long-running tasks that benefit from upfront planning

### Reflexion

**Loop:**
1. **Execute** - Attempt the task
2. **Evaluate** - Check results against success criteria
3. **Reflect** - Identify what went wrong and how to improve
4. **Retry** - Use reflections to guide the next attempt
5. **Store** - Save reflections in memory for future reference

**When to Use:**
- Tasks with clear success/failure criteria
- Code generation and debugging
- Mathematical problem solving
- Tasks that benefit from iterative improvement

**[📖 NVIDIA Agent Blueprints](https://developer.nvidia.com/blog/tag/agents/)** - Reference implementations for agent patterns

### Additional Patterns

**Tool-Augmented Generation:**
- LLM decides when to invoke tools during generation
- Supports parallel calls for independent operations
- Sequential calls when results feed into subsequent decisions

**Multi-Agent Debate:**
- Multiple agents independently generate responses
- Agents critique and refine each other's outputs
- Iterate until convergence or round limit
- Improves accuracy on complex reasoning tasks

## Memory Systems

### Short-Term Memory (Working Memory)

- Current conversation history and recent messages
- Tool call results and observations
- Limited by the model's context window
- Managed through message history truncation or summarization

### Long-Term Memory

- Persistent facts and learned information
- Implemented with vector databases for semantic retrieval
- Structured knowledge graphs for relationship tracking
- Survives across conversation sessions
- Requires explicit write and retrieval operations

### Episodic Memory

- Records of past task executions and their outcomes
- Successful strategies indexed by task type
- Failed approaches to avoid repeating mistakes
- Enables learning from experience over time

### Memory Management

- **Summarization** - Compress older messages to save context space
- **RAG retrieval** - Fetch relevant long-term memories on demand
- **Priority retention** - Keep high-importance information longer
- **Consolidation** - Periodically merge and deduplicate memories
- **Eviction policies** - Remove stale or low-value entries

**[📖 LangChain Memory](https://python.langchain.com/docs/concepts/memory/)** - Memory management patterns for agents

## State Management

### Conversation State
- Track user intent and dialog progression across turns
- Maintain task context (what has been done, what remains)
- Handle interruptions and topic changes gracefully

### Agent Internal State
- Current goals, sub-goals, and plans
- Intermediate results and partial computations
- Confidence levels and uncertainty tracking
- Tool availability and usage quotas

### Multi-Agent Shared State
- Shared blackboard for inter-agent communication
- Task assignment and completion tracking
- Conflict resolution when agents disagree
- Synchronized access to shared resources

### State Persistence
- Serialize state for long-running tasks
- Resume from checkpoints after failures
- Versioned state for rollback capabilities
- Session management for concurrent users

## Architecture Selection Guide

| Pattern | Best For | Complexity | Predictability |
|---------|----------|-----------|----------------|
| ReAct | General tasks with tools | Medium | Low |
| Plan-and-Execute | Structured multi-step tasks | Medium | High |
| Reflexion | Tasks with clear success criteria | High | Medium |
| Tool-Augmented | Simple tool-calling scenarios | Low | Medium |
| Multi-Agent Debate | Complex reasoning tasks | High | Medium |

## Key Exam Concepts

- Know the differences between ReAct, Plan-and-Execute, and Reflexion
- Understand when each pattern is most appropriate
- Memory types - short-term, long-term, episodic and their implementations
- State management challenges in multi-turn and multi-agent settings
- Architecture trade-offs - predictability vs flexibility vs complexity
