# NCP-AAI Agentic AI Professional Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **Agent Fundamentals**
   - Study ReAct, Plan-and-Execute, and Reflexion patterns
   - Understand when to use each pattern and their trade-offs
   - Learn agent memory types: short-term, long-term, episodic
   - Study state management for single and multi-agent systems

2. **Function Calling and Tool Use**
   - Learn JSON Schema format for function definitions
   - Practice parameter extraction and type handling
   - Understand tool_choice options (auto, required, specific)
   - Study sequential vs parallel tool execution
   - **[📖 NIM Function Calling](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)**

3. **Hands-On Practice**
   - Build a ReAct agent with tool access
   - Implement function calling with NIM
   - Experiment with different agent patterns
   - **[📖 NVIDIA Build](https://build.nvidia.com/)** - Test models interactively

### Phase 2: Advanced Topics (2-3 weeks)
1. **Multi-Agent Systems**
   - Study orchestration patterns: sequential, parallel, hierarchical
   - Learn communication methods: message passing, blackboard, events
   - Understand conflict resolution strategies
   - Build a multi-agent system with specialized roles

2. **NVIDIA NIM Deep Dive**
   - Deploy NIM containers for agent backends
   - Configure function calling and streaming
   - Study scaling strategies for production agent systems
   - Understand model selection for agent workloads
   - **[📖 NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)**

3. **Safety and Guardrails**
   - Install and configure NeMo Guardrails
   - Learn Colang 2 syntax for rail definitions
   - Implement input, output, and topical rails
   - Study jailbreak prevention and cascading failure protection
   - **[📖 NeMo Guardrails](https://docs.nvidia.com/nemo/guardrails/latest/index.html)**

### Phase 3: Exam Preparation (1-2 weeks)
1. **Production Patterns**
   - Study deployment, scaling, and monitoring for agent systems
   - Review testing strategies: unit, integration, adversarial, load
   - Understand blue-green deployments and incident response

2. **Review and Practice**
   - Work through scenario-based questions
   - Review weak areas identified during study
   - Create flashcards for key patterns and terminology
   - Practice explaining agent architectures out loud

3. **Final Review**
   - Review fact sheet and domain weights
   - Refresh NIM and Guardrails configuration details
   - Practice rapid pattern identification

## Recommended Resources

### Official NVIDIA Resources
- **[NVIDIA DLI - Agentic AI Courses](https://www.nvidia.com/en-us/training/)** - Official training
- **[NVIDIA NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Inference microservices
- **[NeMo Guardrails Documentation](https://docs.nvidia.com/nemo/guardrails/latest/index.html)** - Safety framework
- **[NeMo Guardrails GitHub](https://github.com/NVIDIA/NeMo-Guardrails)** - Source code and examples
- **[NVIDIA Developer Blog](https://developer.nvidia.com/blog/)** - Technical articles on agents

### Agent Framework Resources
- **[LangChain Agents Documentation](https://python.langchain.com/docs/concepts/agents/)** - Agent patterns and implementation
- **[LlamaIndex Agents](https://docs.llamaindex.ai/en/stable/)** - Agent modules and tools
- **[NVIDIA AI Workbench](https://developer.nvidia.com/ai-workbench)** - Development environment

### Supplementary Learning
- **[NVIDIA GTC Sessions](https://www.nvidia.com/gtc/)** - Conference talks on agentic AI
- **[NVIDIA Build](https://build.nvidia.com/)** - Interactive model testing
- **[Hugging Face Agents](https://huggingface.co/docs/transformers/en/agents)** - Agent concepts

## Exam Tactics

### Question Strategy
1. **Read the full question** - identify the agent pattern or concept being tested
2. **Look for NVIDIA-specific solutions** - prefer NIM, NeMo Guardrails, NVIDIA tools
3. **Keywords to watch for:**
   - "Dynamic tool selection" - think ReAct pattern
   - "Complex multi-step" - think Plan-and-Execute
   - "Iterative improvement" - think Reflexion
   - "Safety" or "prevent" - think NeMo Guardrails
   - "Production" or "scale" - think NIM deployment and monitoring
   - "Multiple specialized" - think multi-agent orchestration
4. **Eliminate wrong answers** - narrow to 2 choices, then reason carefully
5. **When in doubt** - choose the NVIDIA-native solution

### Time Management
- 120 minutes for 60-70 questions
- Approximately 1.7-2 minutes per question
- Flag uncertain questions and move on
- Reserve 15 minutes for reviewing flagged questions
- Do not change answers unless you have a clear reason

### Common Pitfalls

**Pattern Confusion:**
- ReAct is for dynamic, open-ended tasks - not for rigid workflows
- Plan-and-Execute is for complex tasks with known structure - not for simple queries
- Reflexion is for iterative self-improvement - not for single-pass tasks
- Multi-agent is for specialized roles - not for simple single-domain tasks

**NIM Misconceptions:**
- NIM is for inference/serving - not for training
- NIM provides OpenAI-compatible API - not a proprietary-only interface
- NIM handles TensorRT-LLM optimization automatically - you do not configure TRT manually
- Not all NIM models support function calling - verify model capabilities

**Guardrails Mistakes:**
- Guardrails are programmable safety layers - not just model fine-tuning
- Input rails run before the LLM, output rails run after - order matters
- Colang defines conversation patterns - it is not a general-purpose programming language
- Guardrails complement but do not replace secure tool design

**Multi-Agent Errors:**
- More agents is not always better - coordination overhead increases
- Parallel execution only works for independent tasks
- Shared state needs access control - not free-for-all access
- Agent failure handling is critical - one broken agent should not crash the system

## Progress Tracking

### Weekly Milestones
- **Week 1**: Agent patterns, memory systems, function calling basics
- **Week 2**: NIM deployment, Guardrails setup, basic agent building
- **Week 3**: Advanced tool use, multi-agent systems
- **Week 4**: Safety deep dive, production patterns
- **Week 5**: Practice scenarios, gap analysis
- **Week 6**: Final review, timed practice, exam

### Self-Assessment Questions
- Can I explain ReAct, Plan-and-Execute, and Reflexion and when to use each?
- Can I design a function calling schema and implement tool orchestration?
- Do I know how to deploy NIM and configure it for agent workloads?
- Can I write Colang rules for input, output, and topical guardrails?
- Can I design a multi-agent system with proper orchestration and communication?
- Do I understand production monitoring, scaling, and incident response for agents?
