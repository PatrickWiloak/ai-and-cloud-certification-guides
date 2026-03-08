# AI Agents - Study Notes (AB-900 Domain 3: 20-25%)

## What are AI Agents?

AI agents are autonomous or semi-autonomous software entities that can perceive their environment, reason about information, and take actions to achieve specific goals. Unlike traditional automation that follows rigid, pre-defined rules, AI agents use large language models and other AI capabilities to make decisions dynamically based on context.

In the Microsoft ecosystem, agents combine AI models with business logic, data access, and automation capabilities to perform work on behalf of users and organizations.

**[Introduction to AI Agents](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agents)** - Agent concepts in the Microsoft ecosystem.

**[AI Agents in Microsoft 365](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-agents-overview)** - Overview of agent capabilities in Microsoft 365.

---

## Agent Concepts and Characteristics

### Five Key Characteristics of AI Agents

1. **Autonomy** - Ability to operate independently without constant human intervention. Agents can initiate actions, make decisions, and execute multi-step tasks with varying degrees of independence.

2. **Perception** - Capacity to observe and interpret inputs from their environment. This includes reading data from systems, monitoring events, processing user messages, and interpreting context.

3. **Reasoning** - Using AI models to analyze information, evaluate options, and make decisions. Agents apply logic and AI inference to determine the best course of action.

4. **Action** - Executing tasks and interacting with systems to achieve goals. Agents can call APIs, update records, send messages, trigger workflows, and perform other operations.

5. **Memory** - Maintaining context across interactions and learning from past experiences. Agents retain conversation history, user preferences, and previous outcomes to improve future responses.

### Agents vs Copilots

Understanding the distinction between agents and copilots is critical for the AB-900 exam:

| Aspect | Copilot | Agent |
|--------|---------|-------|
| **Human involvement** | Human-in-the-loop; user reviews and approves | Can operate with minimal human oversight |
| **Autonomy level** | Assistive -- augments human work | Semi-autonomous to fully autonomous |
| **Interaction model** | User initiates requests | Can be event-driven or proactive |
| **Decision making** | Suggests; human decides | Can decide and act independently |
| **Scope** | Typically single-task assistance | Can chain multiple steps and decisions |
| **Example** | Copilot drafts an email for user review | Agent monitors inbox and auto-responds to routine queries |

Key exam point: Agents and copilots exist on a **continuum** -- not a binary distinction. Some solutions blend both patterns depending on the task complexity and risk level.

---

## Types of AI Agents

### Conversational Agents

Conversational agents interact with users through natural language dialogue.

**Characteristics:**
- Respond to user messages in real time
- Maintain conversation context across multiple turns
- Can answer questions, provide guidance, and complete requests
- Typically human-in-the-loop (users guide the interaction)

**Examples:**
- Customer service chatbots handling product inquiries
- IT helpdesk assistants that troubleshoot common issues
- HR FAQ bots answering employee policy questions
- Sales assistants providing product recommendations

**Built with:** Copilot Studio, Bot Framework, or Azure AI Bot Service

### Task-Based Agents

Task-based agents execute specific workflows and business processes.

**Characteristics:**
- Focused on completing defined tasks or workflows
- Triggered by events, schedules, or user requests
- Integrate with business systems via connectors and APIs
- Follow structured processes with decision points

**Examples:**
- Invoice processing agent that extracts data and routes for approval
- Order fulfillment agent that tracks inventory and updates shipping
- Data entry automation that validates and imports records
- Report generation agent that compiles data from multiple sources

### Autonomous Agents

Autonomous agents operate with minimal human oversight, proactively monitoring and acting.

**Characteristics:**
- Operate independently once configured
- Monitor conditions and take proactive action
- Chain multiple steps and decisions together
- Handle exceptions and edge cases using AI reasoning
- May request human input only for high-risk decisions

**Examples:**
- Incident response agent that detects, diagnoses, and remediates IT issues
- Supply chain optimization agent that adjusts orders based on demand signals
- Security monitoring agent that identifies and responds to threats
- Customer retention agent that identifies at-risk accounts and initiates outreach

### The Autonomy Spectrum

Agents operate on a continuum from fully guided to fully autonomous:

```
Guided          Assistive         Semi-Autonomous      Autonomous
|----------------|-----------------|---------------------|
Human controls   Human reviews     Human oversees        Minimal human
every step       AI suggestions    AI executes with      involvement;
                                   checkpoints           AI decides and acts
```

The appropriate autonomy level depends on:
- **Risk level** of the tasks being performed
- **Complexity** of the decisions required
- **Regulatory requirements** for human oversight
- **Organizational trust** in the AI system
- **Impact** of errors or incorrect actions

---

## Agent Orchestration Patterns

### What is Agent Orchestration?

Orchestration is the coordination of multiple agents or agent capabilities to complete complex tasks. It involves managing the flow of information, sequencing of actions, error handling, and balancing autonomy with human oversight.

**[Agent Orchestration Concepts](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-orchestration)** - How agents are coordinated and managed.

### Four Orchestration Patterns

#### 1. Sequential Orchestration
- Agents execute tasks in a **defined order**, one after another
- Output of one agent becomes input for the next
- Simplest pattern, suitable for linear workflows
- Example: Data collection agent > Validation agent > Processing agent > Notification agent

#### 2. Parallel Orchestration
- Multiple agents work **simultaneously** on different aspects of a task
- Results are aggregated when all agents complete
- Improves performance for independent sub-tasks
- Example: Simultaneously querying multiple data sources, then combining results

#### 3. Hierarchical Orchestration
- A **primary (orchestrator) agent** delegates tasks to specialized sub-agents
- The orchestrator manages coordination, aggregation, and decision-making
- Sub-agents report results back to the orchestrator
- Example: A project management agent delegates to scheduling, resource, and budget sub-agents

#### 4. Event-Driven Orchestration
- Agents respond to **triggers and events** independently
- No centralized controller; agents react to conditions in their environment
- Loose coupling between agents
- Example: A file upload event triggers a document analysis agent, which triggers a compliance check agent, which triggers a notification agent

### Multi-Agent Coordination

When multiple agents work together:
- **Shared context:** Agents need access to common data and conversation state
- **Conflict resolution:** Handling contradictory outputs from different agents
- **Error propagation:** Managing failures that affect downstream agents
- **Resource management:** Avoiding duplication of effort or data conflicts

### Human Oversight in Orchestration

Even in automated multi-agent systems, human oversight remains important:
- **Approval gates:** Human review required before high-impact actions
- **Escalation paths:** Agents can hand off to humans when confidence is low
- **Audit trails:** All agent actions are logged for review
- **Kill switches:** Administrators can pause or stop agent execution
- **Boundary setting:** Define what agents can and cannot do

---

## Microsoft Copilot Studio Agents

### Building Agents with Copilot Studio

Copilot Studio is Microsoft's primary platform for building agents in the M365 ecosystem.

**Agent authoring capabilities:**
- Define agent instructions and persona
- Configure knowledge sources (SharePoint, websites, Dataverse, files)
- Create topics for structured conversation flows
- Add actions via Power Automate, connectors, and APIs
- Enable generative AI for dynamic responses and action selection
- Set up triggers for autonomous activation

**[Build Agents with Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-building)** - Creating agents using the platform.

### Declarative Agents for Microsoft 365 Copilot

Declarative agents are a specific type of agent that extends Microsoft 365 Copilot:

- **Configuration-based:** Defined through declarations (instructions, knowledge, actions) rather than code
- **Extend M365 Copilot:** Appear within the Copilot experience as specialized assistants
- **Domain-scoped:** Focused on specific business areas (e.g., "HR Policy Agent," "IT Support Agent")
- **Created using:** Copilot Studio or Teams Toolkit

**Key components of a declarative agent:**
1. **Instructions:** Natural language description of the agent's role and behavior
2. **Knowledge:** Data sources the agent can access (SharePoint, Graph connectors, etc.)
3. **Actions:** Capabilities the agent can perform (API plugins, Power Automate flows)

**[Declarative Agents for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/copilot-declarative-agents)** - Building declarative agents.

### Agents in Microsoft Teams

Agents can be deployed directly within Microsoft Teams:

- Access team conversations, files, and data
- Automate team workflows and send notifications
- Provide contextual assistance within channels
- Respond to @mentions and direct messages
- Participate in meetings and channels as a team member

**[Agents in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/platform/bots/what-are-bots)** - Building and deploying agents in Teams.

---

## Governance and Security for AI Agents

### Why Agent Governance Matters

As agents gain more autonomy, governance becomes critical:
- Agents can take actions that affect business data and processes
- Autonomous agents operate without real-time human review
- Multi-agent systems can have compounding effects from errors
- Regulatory and compliance requirements may mandate oversight

### Agent Governance Controls

- **Scope limitations:** Define what data and systems each agent can access
- **Action boundaries:** Restrict which operations agents can perform
- **Authentication and authorization:** Ensure agents operate with appropriate credentials
- **Monitoring and logging:** Track all agent activities for audit purposes
- **Testing and validation:** Rigorous testing before deploying autonomous agents
- **Versioning:** Maintain version control for agent configurations

### Data Loss Prevention for Agents
- DLP policies from Power Platform apply to Copilot Studio agents
- Control which connectors agents can use
- Prevent agents from accessing or sharing sensitive data
- Classify connectors as Business, Non-Business, or Blocked

### Environment Isolation
- Use separate environments for development, testing, and production
- Apply different governance policies per environment
- Promote agents through environments using solutions
- Maintain clear separation between experimental and production agents

---

## Responsible AI Principles for Agents

Microsoft's six Responsible AI principles apply directly to AI agents:

### 1. Fairness
- Agents should treat all users equitably
- Monitor for bias in agent responses and decisions
- Ensure diverse testing scenarios

### 2. Reliability and Safety
- Agents should perform consistently and predictably
- Implement safeguards for edge cases and failures
- Test thoroughly across varied scenarios

### 3. Privacy and Security
- Agents must protect user and organizational data
- Apply principle of least privilege for data access
- Encrypt data in transit and at rest

### 4. Inclusiveness
- Design agents to be accessible to users with diverse abilities
- Support multiple languages and communication styles
- Consider varying levels of technical literacy

### 5. Transparency
- Users should know when they are interacting with an AI agent
- Agent-generated content should be clearly identified
- Provide explanations for agent decisions when possible
- Include citations and source attribution

### 6. Accountability
- Maintain human oversight of agent behavior
- Establish clear ownership and responsibility for each agent
- Regular review and audit of agent actions
- Defined escalation paths for issues

**[Microsoft Responsible AI Principles](https://www.microsoft.com/en-us/ai/responsible-ai)** - Microsoft's AI ethics framework.

**[Responsible AI for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/responsible-ai-microsoft-365-copilot)** - Applied responsible AI practices.

---

## Key Exam Points to Remember

1. **Agent definition:** Autonomous or semi-autonomous software entities that perceive, reason, and act
2. **Copilot vs Agent:** Copilot = human-in-the-loop; Agent = more autonomous. They exist on a continuum.
3. **Three agent types:** Conversational, task-based, and autonomous
4. **Five characteristics:** Autonomy, perception, reasoning, action, memory
5. **Four orchestration patterns:** Sequential, parallel, hierarchical, event-driven
6. **Declarative agents:** Configuration-based agents that extend M365 Copilot (no code required)
7. **Human oversight:** Even autonomous agents need approval gates, escalation paths, and audit trails
8. **Copilot Studio:** Primary platform for building agents in the Microsoft ecosystem
9. **Governance:** DLP policies, environment isolation, scope limitations, and action boundaries
10. **Responsible AI:** Six principles -- fairness, reliability/safety, privacy/security, inclusiveness, transparency, accountability
