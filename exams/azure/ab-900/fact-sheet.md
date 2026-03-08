# Azure AB-900: Copilot and Agent Administration Fundamentals - Comprehensive Fact Sheet

## Table of Contents
1. [Exam Overview](#exam-overview)
2. [Microsoft 365 Copilot](#microsoft-365-copilot)
3. [Microsoft Copilot Studio](#microsoft-copilot-studio)
4. [AI Agents](#ai-agents)
5. [Governance and Security for Copilot](#governance-and-security-for-copilot)
6. [Study Resources](#study-resources)

---

## Exam Overview

### About the AB-900 Certification

The **[📖 Microsoft Certified: Copilot and Agent Administration Fundamentals](https://learn.microsoft.com/en-us/credentials/certifications/copilot-agent-administration-fundamentals/)** - Official certification page with exam details and registration information.

**[📖 Exam AB-900 Skills Outline](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ab-900)** - Complete study guide with all measured skills and exam objectives.

**[📖 Microsoft Learn AB-900 Learning Path](https://learn.microsoft.com/en-us/training/courses/ab-900t00)** - Official training course covering all exam domains.

### Exam Format
- **Exam Code:** AB-900
- **Full Name:** Microsoft Certified: Copilot and Agent Administration Fundamentals
- **Duration:** 45 minutes
- **Questions:** ~35 questions
- **Passing Score:** 700 out of 1000
- **Question Types:** Multiple choice, multiple response, drag-and-drop
- **Cost:** $99 USD (free retake within 30 days)
- **Prerequisites:** None
- **Validity:** Does not expire (fundamentals level)
- **Delivery:** Pearson VUE or Certiport
- **Languages:** Available in multiple languages including English

**[📖 Microsoft Certification Exam Policies](https://learn.microsoft.com/en-us/credentials/certifications/certification-exam-policies)** - Important policies regarding exam registration, retakes, and accommodations.

### Exam Domains

| Domain | Weight |
|--------|--------|
| 1. Describe Microsoft 365 Copilot | 25-30% |
| 2. Describe Microsoft Copilot Studio | 25-30% |
| 3. Describe AI Agents | 20-25% |
| 4. Describe Governance and Security for Copilot | 20-25% |

### Key Technologies
- Microsoft 365 Copilot
- Microsoft Copilot Studio
- Microsoft Graph
- Power Platform Connectors
- Dataverse
- Azure AI Services
- Microsoft Purview
- Microsoft Entra ID

---

## Microsoft 365 Copilot

### What is Microsoft 365 Copilot?

Microsoft 365 Copilot is an AI-powered productivity assistant integrated across Microsoft 365 applications. It combines the power of large language models (LLMs) with organizational data in Microsoft Graph and the Microsoft 365 apps to turn natural language into a powerful productivity tool.

**[📖 Microsoft 365 Copilot Overview](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-overview)** - Introduction to Microsoft 365 Copilot capabilities and architecture.

**[📖 How Microsoft 365 Copilot Works](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-architecture)** - Technical architecture and data flow of Copilot.

### Copilot Architecture

#### Core Components
- **Large Language Models (LLMs):** Foundation AI models that process and generate natural language
- **Microsoft Graph:** Access to organizational data (emails, files, chats, calendar, contacts)
- **Microsoft 365 Apps:** Integration points across Word, Excel, PowerPoint, Outlook, Teams
- **Semantic Index:** Enhanced search and retrieval of organizational content

**[📖 Microsoft Graph Overview](https://learn.microsoft.com/en-us/graph/overview)** - Understanding the data layer that powers Copilot.

**[📖 Semantic Index for Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/semantic-index-for-copilot)** - How semantic indexing enhances Copilot responses.

### Copilot in Microsoft 365 Apps

#### Copilot in Word
- Draft new documents from prompts or reference files
- Rewrite, summarize, and transform existing content
- Generate tables, outlines, and structured content
- Adjust tone and length of text

**[📖 Copilot in Word](https://support.microsoft.com/en-us/copilot-word)** - Using Copilot features in Word.

#### Copilot in Excel
- Analyze and explore data using natural language
- Generate formulas, charts, and PivotTables
- Identify trends, patterns, and outliers
- Create data visualizations from descriptions

**[📖 Copilot in Excel](https://support.microsoft.com/en-us/copilot-excel)** - Using Copilot features in Excel.

#### Copilot in PowerPoint
- Create presentations from prompts or documents
- Add slides, restructure content, and apply designs
- Summarize presentations and generate speaker notes
- Transform Word documents into presentations

**[📖 Copilot in PowerPoint](https://support.microsoft.com/en-us/copilot-powerpoint)** - Using Copilot features in PowerPoint.

#### Copilot in Outlook
- Draft, reply to, and summarize emails
- Schedule meetings and suggest follow-ups
- Summarize long email threads
- Adjust email tone for different audiences

**[📖 Copilot in Outlook](https://support.microsoft.com/en-us/copilot-outlook)** - Using Copilot features in Outlook.

#### Copilot in Teams
- Summarize meetings and generate action items
- Catch up on missed conversations
- Draft messages and announcements
- Answer questions about meeting content

**[📖 Copilot in Teams](https://support.microsoft.com/en-us/copilot-teams)** - Using Copilot features in Teams.

#### Microsoft Copilot (Chat Experience)
- Cross-app AI assistant accessible via Microsoft 365
- Combines web grounding with organizational data
- Supports natural language queries across Microsoft 365 data
- Generates content and provides insights from multiple sources

**[📖 Microsoft Copilot Chat](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-chat)** - Using the Copilot chat experience.

### Licensing and Deployment

#### Licensing Requirements
- Requires a Microsoft 365 E3, E5, Business Standard, or Business Premium base license
- Microsoft 365 Copilot is an add-on license
- Per-user licensing model
- Includes Copilot across all supported M365 apps

**[📖 Microsoft 365 Copilot Licensing](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-licensing)** - Licensing prerequisites and requirements.

#### Deployment Steps
1. Verify prerequisites and licensing
2. Configure Microsoft 365 tenant settings
3. Assign Copilot licenses to users
4. Enable Copilot features in the Microsoft 365 admin center
5. Configure data access and permissions
6. Plan user onboarding and adoption

**[📖 Prepare for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-setup)** - Deployment guide and readiness checklist.

**[📖 Enable Copilot in Admin Center](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-enable-users)** - Steps to enable and assign Copilot licenses.

### Use Cases and Scenarios
- **Information Workers:** Drafting documents, summarizing emails, creating presentations
- **Managers:** Meeting recaps, team status updates, project summaries
- **Sales Teams:** Customer communication drafts, proposal generation, CRM insights
- **HR Teams:** Policy document creation, onboarding materials, employee communications
- **IT Administrators:** Troubleshooting guidance, documentation, report generation

---

## Microsoft Copilot Studio

### What is Microsoft Copilot Studio?

Microsoft Copilot Studio is a low-code platform for building, customizing, and managing AI-powered copilots (conversational agents). It allows organizations to create custom copilots that can answer questions, automate tasks, and integrate with business systems.

**[📖 Microsoft Copilot Studio Overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)** - Introduction to Copilot Studio and its capabilities.

**[📖 Get Started with Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-get-started)** - Quickstart guide for building your first copilot.

### Core Concepts

#### Topics
- **Definition:** Conversation paths that define how the copilot responds to user input
- **Trigger Phrases:** Words or sentences that activate a specific topic
- **Conversation Nodes:** Building blocks that define the flow (messages, questions, conditions, actions)
- **System Topics:** Pre-built topics for common scenarios (greeting, escalation, fallback)

**[📖 Create and Edit Topics](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-create-edit-topics)** - Building conversation flows with topics.

**[📖 Topic Triggers](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-triggers)** - Configuring trigger phrases and conditions.

#### Actions
- **Definition:** Tasks the copilot can perform, such as calling APIs, running Power Automate flows, or querying data
- **Power Automate Integration:** Connect copilots to automated workflows
- **Connector Actions:** Use pre-built connectors to interact with external services
- **Custom Actions:** Build custom integrations using APIs and code

**[📖 Add Actions to Copilots](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-fundamentals-actions)** - Extending copilot capabilities with actions.

**[📖 Power Automate Integration](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-flow-create)** - Connecting copilots with Power Automate flows.

#### Connectors
- **Power Platform Connectors:** Pre-built connections to hundreds of services
- **Custom Connectors:** Build connections to proprietary or custom APIs
- **Dataverse Integration:** Direct access to organizational data stored in Dataverse
- **SharePoint and OneDrive:** Access to document libraries and file storage

**[📖 Use Connectors in Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-connectors)** - Connecting to external data sources and services.

**[📖 Dataverse Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/data-platform-intro)** - Understanding the data platform behind Copilot Studio.

### Generative AI in Copilot Studio

#### Generative Answers
- Use AI to generate responses from knowledge sources
- Configure knowledge sources (websites, SharePoint, Dataverse, uploaded files)
- No need to manually author every topic
- AI-generated responses with source citations

**[📖 Generative Answers](https://learn.microsoft.com/en-us/microsoft-copilot-studio/nlu-boost-conversations)** - Enabling AI-generated responses in copilots.

#### Generative Actions
- AI can determine which actions to call based on user intent
- Dynamic orchestration of multiple actions
- Reduces need for rigid conversation flows

**[📖 Generative Orchestration](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-generative-actions)** - AI-driven action selection and orchestration.

### Publishing and Channels

#### Publishing Options
- **Microsoft Teams:** Deploy copilots directly in Teams channels and chats
- **Websites:** Embed copilots on web pages via iframe or custom canvas
- **Power Apps:** Integrate copilots into Power Apps applications
- **Facebook, Slack, and more:** Multi-channel deployment capabilities
- **Custom Channels:** Use Direct Line API for custom integrations

**[📖 Publish Copilots](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-fundamentals-publish-channels)** - Deploying copilots to various channels.

**[📖 Deploy to Teams](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-add-bot-to-microsoft-teams)** - Publishing copilots to Microsoft Teams.

### Analytics and Performance

#### Built-in Analytics
- Session tracking and conversation metrics
- Customer satisfaction scores (CSAT)
- Topic performance and usage statistics
- Resolution rates and escalation tracking

**[📖 Copilot Studio Analytics](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-overview)** - Monitoring and analyzing copilot performance.

---

## AI Agents

### What are AI Agents?

AI agents are autonomous or semi-autonomous software entities that can perceive their environment, make decisions, and take actions to achieve specific goals. In the Microsoft ecosystem, agents combine AI models with business logic, data access, and automation capabilities.

**[📖 Introduction to AI Agents](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agents)** - Understanding AI agent concepts in the Microsoft ecosystem.

**[📖 AI Agents in Microsoft 365](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-agents-overview)** - Overview of agent capabilities in Microsoft 365.

### Agent Concepts

#### Key Characteristics
- **Autonomy:** Ability to operate independently without constant human intervention
- **Perception:** Capacity to observe and interpret environmental inputs and data
- **Reasoning:** Using AI models to analyze information and make decisions
- **Action:** Executing tasks and interacting with systems to achieve goals
- **Memory:** Maintaining context and learning from past interactions

#### Agent vs Copilot
- **Copilot:** AI assistant that augments human work; human-in-the-loop model
- **Agent:** More autonomous; can independently execute multi-step tasks
- **Spectrum:** Agents operate on a continuum from highly guided to fully autonomous

### Types of Agents

#### Conversational Agents
- Interact with users through natural language
- Answer questions, provide guidance, and complete requests
- Built with Copilot Studio or Bot Framework
- Examples: Customer service bots, IT helpdesk assistants

#### Task-Based Agents
- Execute specific workflows and business processes
- Triggered by events, schedules, or user requests
- Integrate with business systems via connectors and APIs
- Examples: Invoice processing, order fulfillment, data entry automation

#### Autonomous Agents
- Operate with minimal human oversight
- Monitor conditions and take proactive action
- Chain multiple steps and decisions together
- Examples: Incident response, supply chain optimization, anomaly remediation

**[📖 Build Agents with Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-building)** - Creating agents using Copilot Studio.

### Agent Orchestration

#### What is Orchestration?
- Coordinating multiple agents or agent capabilities to complete complex tasks
- Managing the flow of information between agents
- Ensuring proper sequencing and error handling
- Balancing autonomy with human oversight

#### Orchestration Patterns
- **Sequential:** Agents execute tasks in a defined order
- **Parallel:** Multiple agents work simultaneously on different aspects
- **Hierarchical:** A primary agent delegates to sub-agents
- **Event-Driven:** Agents respond to triggers and events independently

**[📖 Agent Orchestration Concepts](https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-orchestration)** - Understanding how agents are coordinated and managed.

### Agents in Microsoft 365

#### Declarative Agents
- Custom agents defined through configuration (not code)
- Extend Microsoft 365 Copilot with specific instructions, knowledge, and actions
- Scoped to particular business domains or tasks
- Created using Copilot Studio or Teams Toolkit

**[📖 Declarative Agents for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/copilot-declarative-agents)** - Building declarative agents to extend Copilot.

#### Agents in Teams
- Deploy agents directly within Microsoft Teams
- Access team conversations, files, and data
- Automate team workflows and notifications
- Provide contextual assistance within team channels

**[📖 Agents in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/platform/bots/what-are-bots)** - Building and deploying agents in Teams.

---

## Governance and Security for Copilot

### Data Protection

#### How Copilot Handles Data
- Copilot respects existing Microsoft 365 permissions and access controls
- Does not access data the user cannot already access
- Data is not used to train the underlying foundation models
- Prompts and responses are processed within the Microsoft 365 trust boundary

**[📖 Data, Privacy, and Security for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-privacy)** - Comprehensive overview of data handling and privacy.

**[📖 Microsoft 365 Copilot Data Residency](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-data-residency)** - Where Copilot data is processed and stored.

#### Data Access and Permissions
- Inherits user-level permissions from Microsoft 365
- Oversharing risks: Copilot can surface content users have access to but may not be aware of
- Importance of proper information architecture and permission management
- Sensitivity labels are respected in Copilot responses

**[📖 Manage Oversharing with Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-data-protection)** - Mitigating data oversharing risks.

### Microsoft Purview Integration

#### Sensitivity Labels
- Apply labels to protect Copilot interactions and generated content
- Labels flow from source documents to Copilot-generated output
- Encryption and access restrictions persist through Copilot workflows

**[📖 Sensitivity Labels and Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/sensitivity-labels-copilot)** - Using sensitivity labels with Copilot.

#### Data Loss Prevention (DLP)
- DLP policies apply to Copilot-generated content
- Prevent sharing of sensitive information through Copilot responses
- Monitor and audit Copilot interactions for compliance

**[📖 Microsoft Purview Data Loss Prevention](https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp)** - Protecting sensitive data with DLP policies.

#### Compliance and Audit
- Copilot interactions are captured in audit logs
- eDiscovery support for Copilot content
- Retention policies apply to Copilot-generated content
- Communication compliance for monitoring Copilot usage

**[📖 Audit Logs for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/audit-copilot)** - Monitoring Copilot activity with audit logs.

**[📖 eDiscovery for Copilot](https://learn.microsoft.com/en-us/purview/ediscovery-copilot)** - Using eDiscovery with Copilot-generated content.

### Microsoft Entra ID and Access Control

#### Identity and Access Management
- Microsoft Entra ID manages user identities and authentication
- Conditional Access policies control Copilot access based on conditions
- Multi-factor authentication (MFA) for secure Copilot access
- Role-based access control (RBAC) for Copilot administration

**[📖 Microsoft Entra ID Overview](https://learn.microsoft.com/en-us/entra/fundamentals/whatis)** - Identity and access management platform.

**[📖 Conditional Access for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)** - Policy-based access control for Copilot.

### Responsible AI

#### Microsoft's Responsible AI Principles for Copilot
- **Fairness:** Copilot treats all users equitably
- **Reliability and Safety:** Consistent and safe responses
- **Privacy and Security:** Data protection and secure processing
- **Inclusiveness:** Accessible to diverse users
- **Transparency:** Clear about AI-generated content
- **Accountability:** Human oversight and governance

**[📖 Responsible AI for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/responsible-ai-microsoft-365-copilot)** - Responsible AI practices in Copilot.

**[📖 Microsoft Responsible AI Principles](https://www.microsoft.com/en-us/ai/responsible-ai)** - Microsoft's AI ethics framework.

#### Content Safety
- Built-in content filters for harmful content
- Grounding in organizational data reduces hallucination
- Citation and source attribution in responses
- User feedback mechanisms for improving quality

### Admin Controls

#### Microsoft 365 Admin Center
- Enable or disable Copilot features at tenant level
- Manage Copilot license assignments
- Configure Copilot settings and policies
- Monitor Copilot usage and adoption metrics

**[📖 Manage Microsoft 365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-page)** - Admin center management for Copilot.

#### Copilot Studio Governance
- Environment management and access controls
- Data loss prevention policies for copilots
- Connector governance and approvals
- Analytics and monitoring for custom copilots

**[📖 Copilot Studio Admin and Governance](https://learn.microsoft.com/en-us/microsoft-copilot-studio/admin-overview)** - Administration and governance for Copilot Studio.

**[📖 Power Platform Admin Center](https://learn.microsoft.com/en-us/power-platform/admin/admin-documentation)** - Managing the Power Platform environment.

#### Plugin and Extension Management
- Control which plugins and connectors are available
- Approve or restrict third-party extensions
- Manage declarative agent permissions
- Monitor plugin usage and behavior

**[📖 Manage Copilot Plugins](https://learn.microsoft.com/en-us/copilot/microsoft-365/manage-plugins-copilot)** - Controlling plugins and extensions in Copilot.

---

## Study Resources

### Official Microsoft Resources

**[📖 AB-900 Learning Path on Microsoft Learn](https://learn.microsoft.com/en-us/training/courses/ab-900t00)** - Complete learning path with hands-on modules.

**[📖 AB-900 Practice Assessment](https://learn.microsoft.com/en-us/credentials/certifications/copilot-agent-administration-fundamentals/practice/assessment?assessment-type=practice&assessmentId=88)** - Official practice test to assess readiness.

**[📖 Microsoft Exam Sandbox](https://aka.ms/examdemo)** - Interactive demo of exam interface and question types.

### Documentation and Guides

**[📖 Microsoft 365 Copilot Documentation](https://learn.microsoft.com/en-us/copilot/microsoft-365/)** - Central hub for all Microsoft 365 Copilot documentation.

**[📖 Copilot Studio Documentation](https://learn.microsoft.com/en-us/microsoft-copilot-studio/)** - Complete Copilot Studio documentation.

**[📖 Microsoft 365 Admin Documentation](https://learn.microsoft.com/en-us/microsoft-365/admin/)** - Administration guides for Microsoft 365.

### Hands-On Practice

**[📖 Copilot Studio Trial](https://learn.microsoft.com/en-us/microsoft-copilot-studio/sign-up-individual)** - Sign up for a free Copilot Studio trial.

**[📖 Microsoft 365 Developer Program](https://developer.microsoft.com/en-us/microsoft-365/dev-program)** - Free developer sandbox for Microsoft 365.

**[📖 Microsoft Learn Sandbox Exercises](https://learn.microsoft.com/en-us/training/browse/?products=ms-copilot)** - Free interactive labs in browser environment.

### Additional Learning

**[📖 Microsoft 365 Copilot Blog](https://techcommunity.microsoft.com/t5/microsoft-365-copilot/bg-p/Microsoft365Copilot)** - Latest updates and insights on Microsoft 365 Copilot.

**[📖 Copilot Studio Blog](https://powervirtualagents.microsoft.com/en-us/blog/)** - News and updates for Copilot Studio.

**[📖 Microsoft AI Blog](https://blogs.microsoft.com/ai/)** - Broader Microsoft AI news and announcements.

---

## Key Concepts Summary

### Microsoft 365 Copilot
- **Architecture:** LLMs + Microsoft Graph + M365 Apps + Semantic Index
- **Integration:** Word, Excel, PowerPoint, Outlook, Teams, and Copilot Chat
- **Licensing:** Add-on to M365 E3/E5/Business Standard/Business Premium
- **Data Model:** Respects existing permissions; does not train on customer data

### Copilot Studio
- **Purpose:** Low-code platform for building custom copilots
- **Topics:** Conversation paths with trigger phrases and nodes
- **Actions:** Power Automate flows, connectors, and custom API integrations
- **Generative AI:** AI-powered answers from knowledge sources
- **Publishing:** Teams, websites, Power Apps, and multi-channel deployment

### AI Agents
- **Types:** Conversational, task-based, and autonomous agents
- **Orchestration:** Sequential, parallel, hierarchical, and event-driven patterns
- **Declarative Agents:** Configuration-based agents extending M365 Copilot
- **Continuum:** From human-in-the-loop copilots to autonomous agents

### Governance and Security
- **Data Protection:** Respects M365 permissions, sensitivity labels, DLP
- **Compliance:** Audit logs, eDiscovery, retention policies
- **Identity:** Microsoft Entra ID, Conditional Access, MFA
- **Admin Controls:** Tenant settings, license management, plugin governance
- **Responsible AI:** Fairness, reliability, privacy, inclusiveness, transparency, accountability

---

## Exam Tips

### Preparation Strategy
1. Complete the Microsoft Learn AB-900 learning path
2. Explore Microsoft 365 Copilot features hands-on (trial or production)
3. Build a simple copilot in Copilot Studio (free trial available)
4. Review governance and compliance documentation
5. Understand the difference between copilots and agents
6. Focus on capabilities and use cases rather than deep technical implementation

### During the Exam
- Read questions carefully and identify key requirements
- Eliminate obviously wrong answers first
- Look for keywords that indicate specific services or capabilities
- Remember this is a fundamentals exam: breadth over depth
- Manage your time across ~35 questions in 45 minutes

### Common Pitfall Areas
- Confusing Copilot features across different M365 apps
- Not understanding the licensing prerequisites for M365 Copilot
- Mixing up Copilot Studio concepts (topics vs actions vs connectors)
- Forgetting that Copilot respects existing M365 permissions
- Not understanding the difference between copilots and autonomous agents
- Overlooking responsible AI principles and their application

---

## Glossary of Key Terms

- **Agent:** Autonomous or semi-autonomous AI entity that perceives, reasons, and acts
- **Copilot:** AI assistant that augments human work with a human-in-the-loop model
- **Copilot Studio:** Low-code platform for building custom copilots and agents
- **Connector:** Pre-built integration with external services via Power Platform
- **Dataverse:** Cloud-based data platform for Power Platform and Copilot Studio
- **Declarative Agent:** Configuration-defined agent that extends M365 Copilot
- **Generative Answers:** AI-generated responses from knowledge sources in Copilot Studio
- **Microsoft Entra ID:** Cloud identity and access management service
- **Microsoft Graph:** API layer providing access to Microsoft 365 data and intelligence
- **Microsoft Purview:** Unified data governance and compliance platform
- **Orchestration:** Coordinating multiple agents or capabilities to complete complex tasks
- **Semantic Index:** Enhanced search and content retrieval system for Copilot
- **Sensitivity Label:** Classification applied to content for protection and governance
- **Topic:** Conversation path in Copilot Studio defining how the copilot responds
- **Trigger Phrase:** Words or sentences that activate a specific topic in Copilot Studio

---

*This fact sheet covers all essential topics for the AB-900 Copilot and Agent Administration Fundamentals certification exam. Focus on understanding core concepts, service capabilities, and appropriate use cases rather than memorizing syntax or implementation details. Good luck with your certification journey!*

**Last Updated**: 2026-03-08
