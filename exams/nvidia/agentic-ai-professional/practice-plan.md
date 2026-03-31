# NCP-AAI Agentic AI Professional Study Plan

## 8-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Agentic AI Fundamentals
**Focus:** Core agent concepts and patterns

#### Day 1-2: Agent Architecture Overview
- [ ] Study the concept of AI agents - autonomy, tool use, reasoning
- [ ] Learn ReAct pattern - reasoning and acting interleaved
- [ ] Understand Plan-and-Execute pattern for complex tasks
- [ ] Study Reflexion pattern for self-improving agents
- [ ] **Reference:** [NVIDIA Agentic AI Blog](https://developer.nvidia.com/blog/introduction-to-ai-agents/)

#### Day 3-4: Memory and State
- [ ] Study short-term memory (conversation context)
- [ ] Learn long-term memory with vector databases
- [ ] Understand episodic memory for learning from experience
- [ ] Practice implementing agent state management
- [ ] **Lab:** Build a simple ReAct agent with memory

#### Day 5-7: Function Calling Basics
- [ ] Study function calling schema definition (JSON Schema)
- [ ] Learn parameter extraction from natural language
- [ ] Understand tool selection and routing
- [ ] Practice defining tools with clear schemas
- [ ] **Reference:** [NIM Function Calling](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)

### Week 2: NVIDIA Stack for Agents
**Focus:** NIM and NeMo Guardrails setup

#### Day 1-2: NVIDIA NIM for Agents
- [ ] Deploy NIM with a function-calling capable model
- [ ] Explore NIM OpenAI-compatible API
- [ ] Test function calling through NIM API
- [ ] Understand NIM model selection for agentic workloads
- [ ] **Reference:** [NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)

#### Day 3-4: NeMo Guardrails Introduction
- [ ] Install NeMo Guardrails framework
- [ ] Study Colang language basics
- [ ] Implement simple input and output rails
- [ ] Understand topical guardrails
- [ ] **Reference:** [NeMo Guardrails Docs](https://docs.nvidia.com/nemo/guardrails/latest/index.html)

#### Day 5-7: Agent Framework Integration
- [ ] Integrate NIM with LangChain agent framework
- [ ] Build a basic tool-calling agent with NIM backend
- [ ] Add NeMo Guardrails to the agent
- [ ] Test agent behavior with various inputs
- [ ] **Lab:** Build an end-to-end agent with NIM + Guardrails

### Phase 2: Advanced Topics (Weeks 3-5)

#### Week 3: Advanced Tool Use and Function Calling

#### Day 1-2: Tool Orchestration
- [ ] Study sequential vs parallel tool execution
- [ ] Learn pipeline patterns for tool chains
- [ ] Implement error handling and retry strategies
- [ ] Practice conditional tool selection
- [ ] **Lab:** Build agent with multiple tools and parallel execution

#### Day 3-4: Custom Tool Development
- [ ] Design tool schemas with clear descriptions
- [ ] Build custom tools for database queries, API calls
- [ ] Implement tool validation and error handling
- [ ] Test tools independently before agent integration

#### Day 5-7: Complex Tool Scenarios
- [ ] Multi-step tool chains with data transformation
- [ ] Tool fallback strategies when primary tool fails
- [ ] Dynamic tool registration and discovery
- [ ] Rate limiting and cost control for tool calls
- [ ] **Practice:** Build agent that orchestrates 5+ tools for a complex task

### Week 4: Planning, Reasoning, and Multi-Agent Systems

#### Day 1-2: Advanced Reasoning
- [ ] Study chain-of-thought prompting for agents
- [ ] Learn tree of thought for multi-path reasoning
- [ ] Implement self-consistency for reliable decisions
- [ ] Practice inner monologue patterns
- [ ] **Reference:** [NVIDIA Build](https://build.nvidia.com/) - Test reasoning models

#### Day 3-4: Task Decomposition and Planning
- [ ] Study hierarchical task decomposition
- [ ] Implement dynamic re-planning based on results
- [ ] Learn convergence criteria (when to stop iterating)
- [ ] Practice planning for multi-step workflows

#### Day 5-7: Multi-Agent Systems
- [ ] Design multi-agent architectures (roles, communication)
- [ ] Implement agent-to-agent message passing
- [ ] Study orchestration patterns (sequential, parallel, hierarchical)
- [ ] Build a multi-agent debate system
- [ ] **Lab:** Build a 3-agent system with specialized roles

### Week 5: Safety and Guardrails Deep Dive

#### Day 1-2: NeMo Guardrails Advanced
- [ ] Master Colang 2 syntax and features
- [ ] Implement complex dialog rails
- [ ] Build retrieval rails for RAG-based agents
- [ ] Create custom action handlers
- [ ] **Reference:** [Colang 2 Overview](https://docs.nvidia.com/nemo/guardrails/latest/user-guides/colang-2/overview.html)

#### Day 3-4: Agent Safety Patterns
- [ ] Implement tool call validation and sandboxing
- [ ] Build human-in-the-loop approval workflows
- [ ] Study jailbreak detection and prevention
- [ ] Practice cascading failure prevention (timeouts, circuit breakers)

#### Day 5-7: Safety Testing
- [ ] Red-team your agents with adversarial prompts
- [ ] Test guardrails against known attack patterns
- [ ] Validate safety across diverse input scenarios
- [ ] Document and address discovered vulnerabilities
- [ ] **Lab:** Comprehensive safety audit of an agent system

### Phase 3: Production and Exam Prep (Weeks 6-8)

#### Week 6: Production Deployment

#### Day 1-2: Scaling Agent Systems
- [ ] Deploy agent backend on Kubernetes with auto-scaling
- [ ] Configure load balancing for multiple NIM instances
- [ ] Implement queue-based processing for tool calls
- [ ] Study capacity planning for agent workloads

#### Day 3-4: Monitoring and Observability
- [ ] Set up monitoring for agent success/failure rates
- [ ] Track tool call patterns and token usage
- [ ] Implement distributed tracing for agent workflows
- [ ] Build alerting for unusual agent behavior

#### Day 5-7: Testing and Operations
- [ ] Write unit tests for tools and integration tests for workflows
- [ ] Implement load testing for agent infrastructure
- [ ] Practice blue-green deployments for model updates
- [ ] Build incident response procedures
- [ ] **Lab:** Deploy and monitor a production-ready agent system

### Week 7: Review and Practice

#### Day 1-3: Domain Review
- [ ] Review all five domains systematically
- [ ] Create flashcards for key patterns and concepts
- [ ] Re-read NIM and Guardrails documentation for weak areas
- [ ] Complete any unfinished labs

#### Day 4-5: Practice Questions
- [ ] Work through scenario-based practice questions
- [ ] Focus on multi-domain questions
- [ ] Review answers and identify remaining gaps

#### Day 6-7: Gap Analysis
- [ ] Deep-dive into weakest areas
- [ ] Re-read documentation for problem areas
- [ ] Practice explaining agent patterns out loud

### Week 8: Final Preparation

#### Day 1-3: Intensive Review
- [ ] Review fact sheet and architecture patterns
- [ ] Practice rapid concept identification
- [ ] Focus on safety and guardrails patterns

#### Day 4-5: Final Practice
- [ ] Full-length timed practice session (120 minutes)
- [ ] Review all incorrect answers
- [ ] Final review of weak areas

#### Day 6: Rest and Light Review
- [ ] Light review of fact sheet only
- [ ] Prepare exam logistics

#### Day 7: Exam Day
- [ ] Brief concept review (30 minutes max)
- [ ] Take the exam with confidence

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** Understand agent patterns, set up NIM + Guardrails
- **Week 3:** Master tool use and function calling
- **Week 4:** Advanced reasoning and multi-agent systems
- **Week 5:** Safety and guardrails deep dive
- **Week 6:** Production deployment and operations
- **Week 7:** Practice questions and gap analysis
- **Week 8:** Final review and exam

### Self-Assessment Questions
- Can I explain ReAct, Plan-and-Execute, and Reflexion patterns?
- Can I design a function calling schema for a complex tool?
- Do I know how to implement NeMo Guardrails with Colang?
- Can I architect a multi-agent system with proper orchestration?
- Do I understand production scaling and monitoring for agents?
