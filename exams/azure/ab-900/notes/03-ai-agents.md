# AI Agents - AB-900

## What are AI Agents?

AI agents are autonomous or semi-autonomous software entities that can perceive their environment, reason about information, and take actions to achieve specific goals. Unlike traditional chatbots that follow scripted paths, agents can adapt their behavior, chain multiple steps together, and operate with varying degrees of independence.

**[📖 Introduction to AI Agents](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agents)** - Understanding AI agent concepts in the Microsoft ecosystem.

**[📖 AI Agents in Microsoft 365](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-agents-overview)** - Overview of agent capabilities in Microsoft 365.

## Agent Fundamentals

### Key Characteristics of AI Agents

#### Autonomy
- **Definition:** The ability to operate independently without constant human direction
- **Spectrum:** Ranges from fully guided (human approves every action) to fully autonomous (acts independently)
- **In Practice:** Most enterprise agents operate with bounded autonomy, where guardrails limit what they can do

#### Perception
- **Definition:** The ability to observe and interpret inputs from the environment
- **Sources:** User messages, system events, data changes, sensor readings, API responses
- **Processing:** Agents use AI models to understand and contextualize what they perceive

#### Reasoning
- **Definition:** Using AI models to analyze information and make decisions
- **Capabilities:** Intent understanding, context evaluation, plan generation, risk assessment
- **Models:** Leverages large language models and other AI systems for decision-making

#### Action
- **Definition:** The ability to execute tasks and interact with systems
- **Types:** Sending messages, calling APIs, creating records, triggering workflows, generating content
- **Scope:** Actions are bounded by the agent's permissions and configured capabilities

#### Memory
- **Definition:** Maintaining context and learning from past interactions
- **Short-term:** Conversation context within a single session
- **Long-term:** Stored preferences, past interactions, and accumulated knowledge
- **Organizational:** Access to shared knowledge bases and organizational data

### Agent vs Copilot

Understanding the distinction is important for the AB-900 exam:

| Aspect | Copilot | Agent |
|--------|---------|-------|
| **Primary Mode** | Assists humans; augments productivity | Can operate independently on tasks |
| **Human Involvement** | Human-in-the-loop; user drives the interaction | Can be human-on-the-loop or fully autonomous |
| **Interaction** | Responds to explicit user prompts | Can be proactive; responds to events and triggers |
| **Decision Making** | Suggests; human decides | Can decide and act within defined boundaries |
| **Scope** | Typically single-task focused per prompt | Can handle multi-step, complex workflows |
| **Example** | Copilot drafts an email for you to review | Agent monitors inbox and auto-responds to routine inquiries |

**Important:** Copilots and agents exist on a continuum. A copilot can be enhanced with agent-like capabilities, and agents often include copilot-like conversational features.

## Types of Agents

### Conversational Agents

#### Description
- Interact with users through natural language conversation
- Answer questions, provide guidance, and fulfill requests
- Rely on AI language understanding and generation

#### Characteristics
- **User-Initiated:** Typically activated by a user asking a question or making a request
- **Interactive:** Engage in back-and-forth dialogue to clarify and assist
- **Knowledge-Driven:** Draw from knowledge bases, documents, and data to respond

#### Examples
- Customer service agents answering product questions
- IT helpdesk agents guiding users through troubleshooting
- HR agents answering policy and benefits questions
- Internal knowledge agents for employee onboarding

#### Building Conversational Agents
- **Copilot Studio:** Low-code platform with topics, actions, and generative answers
- **Bot Framework:** Code-first approach for complex conversational experiences
- **Power Virtual Agents:** Now part of Copilot Studio

**[📖 Build Conversational Agents](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)** - Creating agents with Copilot Studio.

### Task-Based Agents

#### Description
- Execute specific workflows and business processes
- Focus on completing defined tasks efficiently
- Often triggered by events rather than user conversations

#### Characteristics
- **Event-Driven:** Triggered by data changes, schedules, or system events
- **Process-Oriented:** Follow defined workflows with branching logic
- **System-Integrated:** Connect to multiple business systems via APIs and connectors
- **Measurable:** Track task completion rates and efficiency metrics

#### Examples
- Invoice processing: Receive invoice, extract data, validate, route for approval
- Order fulfillment: Monitor orders, check inventory, initiate shipping
- Employee onboarding: Create accounts, assign licenses, send welcome materials
- Data entry: Extract information from documents and populate business systems

### Autonomous Agents

#### Description
- Operate with minimal human oversight once configured
- Monitor conditions and take proactive action
- Chain multiple decisions and steps together independently

#### Characteristics
- **Proactive:** Initiate actions based on conditions without waiting for user input
- **Self-Directing:** Determine the best course of action based on context
- **Multi-Step:** Execute complex sequences of actions to achieve goals
- **Adaptive:** Adjust behavior based on outcomes and changing conditions

#### Examples
- Incident response: Detect anomalies, diagnose issues, apply remediation, notify stakeholders
- Supply chain optimization: Monitor inventory, predict demand, reorder supplies
- Security monitoring: Detect threats, assess severity, initiate containment, alert security team
- Content moderation: Monitor submissions, classify content, apply policies, escalate when needed

#### Guardrails for Autonomous Agents
- **Scope Limitations:** Define what the agent can and cannot do
- **Approval Gates:** Require human approval for high-impact actions
- **Monitoring:** Track agent actions and outcomes in audit logs
- **Kill Switch:** Ability to disable or pause agents immediately
- **Ethical Boundaries:** Responsible AI principles embedded in agent behavior

## Agent Orchestration

### What is Orchestration?

Orchestration is the process of coordinating multiple agents or agent capabilities to complete complex tasks. It involves managing the flow of information, sequencing of actions, error handling, and ensuring that the overall goal is achieved.

**[📖 Agent Orchestration Concepts](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-orchestration)** - Understanding agent coordination and management.

### Orchestration Patterns

#### Sequential Orchestration
```
Agent A → Agent B → Agent C → Result
```
- **How It Works:** Agents execute tasks in a defined order, each passing output to the next
- **When to Use:** When tasks have clear dependencies and must happen in sequence
- **Example:** Customer refund process: Validate request → Check eligibility → Process refund → Send confirmation

#### Parallel Orchestration
```
         ┌→ Agent A ─┐
Input ───┼→ Agent B ──┼→ Aggregate → Result
         └→ Agent C ─┘
```
- **How It Works:** Multiple agents work simultaneously on different aspects of a task
- **When to Use:** When tasks are independent and can be performed concurrently
- **Example:** New hire setup: Create email account + Provision laptop + Schedule orientation (all in parallel)

#### Hierarchical Orchestration
```
         Primary Agent
        /      |      \
   Agent A  Agent B  Agent C
```
- **How It Works:** A primary (orchestrator) agent delegates tasks to specialized sub-agents
- **When to Use:** When a complex task requires different specialized capabilities
- **Example:** Customer inquiry: Orchestrator routes to billing agent, technical support agent, or sales agent based on intent

#### Event-Driven Orchestration
```
Event → Trigger → Agent responds → May trigger other agents
```
- **How It Works:** Agents respond to triggers and events independently, and their actions may trigger other agents
- **When to Use:** When workflows are driven by real-time events and conditions
- **Example:** System alert triggers monitoring agent → escalates to remediation agent → notifies operations agent

### Orchestration Considerations
- **Error Handling:** Define what happens when an agent fails or produces unexpected results
- **Timeout Management:** Set time limits for agent responses and actions
- **Conflict Resolution:** Handle situations where agents produce conflicting recommendations
- **Logging and Auditing:** Track the full orchestration chain for troubleshooting and compliance
- **Human Escalation:** Define when and how to involve humans in the orchestration flow

## Agents in Microsoft 365

### Declarative Agents

#### What are Declarative Agents?
Declarative agents are custom agents defined through configuration rather than code. They extend Microsoft 365 Copilot with specific instructions, knowledge sources, and actions tailored to particular business domains or tasks.

**[📖 Declarative Agents for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/copilot-declarative-agents)** - Building declarative agents to extend Copilot.

#### Key Components
- **Instructions:** Custom system prompts that define the agent's personality, scope, and behavior
- **Knowledge:** Specific data sources the agent can access (SharePoint sites, files, Graph connectors)
- **Actions:** Capabilities the agent can perform (API calls, plugins, connectors)
- **Scoping:** Limits on what data and actions the agent can access

#### How to Build Declarative Agents
- **Copilot Studio:** Visual, low-code approach for building declarative agents
- **Teams Toolkit:** Developer-focused approach using JSON manifests and code
- **Microsoft 365 Admin Center:** Configure and manage agents at the organizational level

#### Use Cases
- **Department-Specific Agent:** An HR agent that knows company policies and can answer HR questions
- **Project Agent:** A project management agent with access to specific project documents and data
- **IT Support Agent:** An agent that can troubleshoot common IT issues using knowledge base articles
- **Sales Assistant:** An agent that accesses CRM data and helps with customer preparation

### Agents in Microsoft Teams

#### Capabilities
- Deploy agents directly within Teams for easy access
- Access team conversations, files, and contextual data
- Respond to @mentions in channels and group chats
- Support adaptive cards for rich interactive responses
- Integrate with Teams workflows and approvals

**[📖 Agents in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/platform/bots/what-are-bots)** - Building and deploying agents in Teams.

#### Teams Agent Scenarios
- Team-level FAQ agent for new member onboarding
- Project status agent that pulls data from Planner and DevOps
- Meeting assistant agent that tracks action items and follow-ups
- Channel moderation agent that enforces community guidelines

## Building Agents with Microsoft Tools

### Tool Selection Guide

| Need | Recommended Tool | Audience |
|------|-----------------|----------|
| Simple FAQ or conversation agent | Copilot Studio (topics + generative answers) | Citizen developers |
| Custom M365 Copilot extension | Declarative agents (Copilot Studio or Teams Toolkit) | All skill levels |
| Complex workflow automation | Copilot Studio + Power Automate actions | Citizen/pro developers |
| Advanced custom agent | Bot Framework SDK + Azure AI Services | Professional developers |
| Multi-channel enterprise agent | Copilot Studio (multi-channel publishing) | All skill levels |

### Microsoft Copilot Studio for Agents

Copilot Studio is the primary platform for building agents in the Microsoft ecosystem:
- Low-code visual authoring for conversation and task flows
- Generative AI for dynamic answers and action orchestration
- Power Platform integration for enterprise connectivity
- Built-in analytics and lifecycle management
- Enterprise governance and compliance controls

**[📖 Build Agents with Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-building)** - Creating agents using Copilot Studio.

### Azure AI Services for Agents

For advanced agent scenarios, Azure AI Services provide additional capabilities:
- **Azure OpenAI Service:** Advanced language models for reasoning and generation
- **Azure AI Search:** Knowledge retrieval and semantic search
- **Azure AI Document Intelligence:** Extract structured data from documents
- **Azure AI Language:** Entity recognition, sentiment analysis, and language understanding

**[📖 Azure AI Services](https://learn.microsoft.com/en-us/azure/ai-services/what-are-ai-services)** - Suite of AI services for building intelligent agents.

## Responsible AI for Agents

### Principles Applied to Agents
- **Transparency:** Users should know when they are interacting with an agent, not a human
- **Accountability:** Organizations are responsible for their agents' actions and outcomes
- **Fairness:** Agents should treat all users equitably and avoid biased behavior
- **Safety:** Agents must have guardrails to prevent harmful actions
- **Privacy:** Agents should only access data they are authorized to use
- **Human Oversight:** Critical decisions should include human review and approval

### Agent Safety Best Practices
- Define clear boundaries for what agents can and cannot do
- Implement approval workflows for high-impact actions
- Monitor agent behavior through audit logs and analytics
- Provide users with the ability to escalate to human support
- Regularly review and update agent behavior and knowledge
- Test agents thoroughly before production deployment

**[📖 Responsible AI Principles](https://www.microsoft.com/en-us/ai/responsible-ai)** - Microsoft's AI ethics framework.

## Key Takeaways for AB-900

1. **Agent Definition:** Autonomous or semi-autonomous software entities that perceive, reason, and act
2. **Agent vs Copilot:** Copilots assist with human-in-the-loop; agents can operate more independently
3. **Three Agent Types:** Conversational (Q&A), task-based (workflow), autonomous (proactive)
4. **Orchestration Patterns:** Sequential, parallel, hierarchical, and event-driven
5. **Declarative Agents:** Configuration-based agents that extend Microsoft 365 Copilot
6. **Building Tools:** Copilot Studio (primary), Bot Framework (advanced), Teams Toolkit (developers)
7. **Guardrails:** Scope limitations, approval gates, monitoring, and human escalation
8. **Responsible AI:** Transparency, accountability, fairness, safety, privacy, and human oversight
