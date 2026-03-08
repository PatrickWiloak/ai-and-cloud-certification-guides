# AB-900 Copilot and Agent Administration Fundamentals - 2-Week Study Plan

## Overview

This plan covers 14 days of focused study for the AB-900 fundamentals exam. As a fundamentals certification, the emphasis is on breadth of knowledge rather than deep technical implementation. Each day includes 1-2 hours of study.

**Exam Details:** 45 minutes | ~35 questions | 700/1000 passing score | $99 USD

---

## Week 1: Core Concepts and Copilot Features

### Day 1 - Orientation and Microsoft 365 Copilot Introduction
- [ ] Read the AB-900 exam skills outline: https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ab-900
- [ ] Review the exam format, domains, and question types
- [ ] Read Microsoft 365 Copilot overview documentation: https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-overview
- [ ] Take notes on Copilot architecture: LLMs, Microsoft Graph, Semantic Index, M365 Apps

### Day 2 - Copilot Architecture Deep Dive
- [ ] Study how Microsoft 365 Copilot processes prompts and generates responses
- [ ] Read the Copilot architecture documentation: https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-architecture
- [ ] Understand the role of the Semantic Index for Copilot
- [ ] Review Microsoft Graph and its role as the data layer: https://learn.microsoft.com/en-us/graph/overview
- [ ] Create a diagram showing the Copilot data flow (prompt > LLM > Graph > response)

### Day 3 - Copilot Across M365 Applications
- [ ] Study Copilot in Word: drafting, rewriting, summarization, tone adjustment
- [ ] Study Copilot in Excel: data analysis, formula generation, chart creation
- [ ] Study Copilot in PowerPoint: presentation creation, speaker notes, slide restructuring
- [ ] Study Copilot in Outlook: email drafting, summarization, scheduling
- [ ] Study Copilot in Teams: meeting summaries, action items, chat catch-up
- [ ] Review Copilot Chat (cross-app experience) capabilities
- [ ] Create flashcards for each app's unique Copilot capabilities

### Day 4 - Copilot Licensing, Deployment, and Use Cases
- [ ] Study licensing requirements: base licenses (E3, E5, Business Standard/Premium) + Copilot add-on
- [ ] Review deployment steps: prerequisites, tenant config, license assignment, enablement
- [ ] Read deployment guide: https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-setup
- [ ] Study use cases across different roles: information workers, managers, sales, HR, IT
- [ ] Understand when Copilot is appropriate vs other tools

### Day 5 - Copilot Studio Fundamentals
- [ ] Read Copilot Studio overview: https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio
- [ ] Understand Copilot Studio as a low-code platform (not developer-only)
- [ ] Study core concepts: topics, trigger phrases, conversation nodes, system topics
- [ ] Review the authoring experience and conversation designer
- [ ] Sign up for Copilot Studio free trial: https://learn.microsoft.com/en-us/microsoft-copilot-studio/sign-up-individual
- [ ] Build a simple "Hello World" copilot (hands-on practice)

### Day 6 - Copilot Studio: Actions, Connectors, and Generative AI
- [ ] Study actions: Power Automate flows, connector actions, custom actions
- [ ] Review Power Platform connectors and custom connector concepts
- [ ] Understand Dataverse integration with Copilot Studio
- [ ] Study generative answers: knowledge sources, AI-generated responses, citations
- [ ] Study generative actions: AI-driven action selection and orchestration
- [ ] Practice creating a topic with a Power Automate flow action (hands-on)

### Day 7 - Copilot Studio: Publishing, Analytics, and Review
- [ ] Study publishing channels: Teams, websites, Power Apps, Facebook, Slack, Direct Line API
- [ ] Review analytics capabilities: session tracking, CSAT, topic performance, resolution rates
- [ ] Publish your practice copilot to a test channel (hands-on)
- [ ] Review Week 1 notes and fill any knowledge gaps
- [ ] Take the official AB-900 practice assessment (first attempt): https://learn.microsoft.com/en-us/credentials/certifications/copilot-agent-administration-fundamentals/practice/assessment?assessment-type=practice&assessmentId=88
- [ ] Note weak areas for focused study in Week 2

---

## Week 2: AI Agents, Governance, and Exam Prep

### Day 8 - AI Agent Concepts and Types
- [ ] Study AI agent definitions: autonomy, perception, reasoning, action, memory
- [ ] Understand the difference between copilots (human-in-the-loop) and agents (more autonomous)
- [ ] Review agent types: conversational, task-based, autonomous
- [ ] Study declarative agents for Microsoft 365 Copilot
- [ ] Read agent concepts documentation: https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agents
- [ ] Create a comparison chart: copilots vs agents (key differences)

### Day 9 - Agent Orchestration and Microsoft 365 Agents
- [ ] Study orchestration patterns: sequential, parallel, hierarchical, event-driven
- [ ] Understand multi-agent coordination and human oversight requirements
- [ ] Review agents in Microsoft Teams: deployment, data access, workflow automation
- [ ] Study declarative agents: configuration-based, extending M365 Copilot
- [ ] Read about building agents with Copilot Studio: https://learn.microsoft.com/en-us/microsoft-copilot-studio/concept-agent-building

### Day 10 - Governance: Data Protection and Permissions
- [ ] Study how Copilot handles organizational data (respects existing M365 permissions)
- [ ] Understand oversharing risks and mitigation strategies
- [ ] Review data residency and processing boundaries
- [ ] Read privacy documentation: https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-privacy
- [ ] Key fact: Copilot data is NOT used to train foundation models
- [ ] Key fact: Sensitivity labels flow from source documents to Copilot-generated content

### Day 11 - Governance: Compliance, Identity, and Admin Controls
- [ ] Study Microsoft Purview integration: sensitivity labels, DLP, audit logs
- [ ] Review eDiscovery and retention policies for Copilot content
- [ ] Study Microsoft Entra ID: Conditional Access, MFA, RBAC for Copilot
- [ ] Review admin controls: tenant-level settings, license management, plugin governance
- [ ] Study Copilot Studio governance: environment management, DLP policies, connector governance
- [ ] Read admin documentation: https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-page

### Day 12 - Responsible AI and Security
- [ ] Study Microsoft's six Responsible AI principles: fairness, reliability/safety, privacy/security, inclusiveness, transparency, accountability
- [ ] Understand content safety and filtering in Copilot
- [ ] Review how grounding in organizational data reduces hallucination
- [ ] Study citation and source attribution in Copilot responses
- [ ] Read Responsible AI documentation: https://learn.microsoft.com/en-us/copilot/microsoft-365/responsible-ai-microsoft-365-copilot
- [ ] Review plugin and extension management for security

### Day 13 - Full Review and Practice
- [ ] Review all study notes from Days 1-12
- [ ] Retake the official AB-900 practice assessment (second attempt)
- [ ] Review and understand every question you got wrong
- [ ] Focus on weak areas identified from both practice attempts
- [ ] Review common gotchas:
  - [ ] Copilot respects existing M365 permissions (does not bypass access controls)
  - [ ] Copilot is an add-on license, not included in base M365 subscriptions
  - [ ] Copilot Studio is a low-code platform, not developer-only
  - [ ] Sensitivity labels carry through to Copilot-generated content
  - [ ] Copilot data is not used to train foundation models

### Day 14 - Final Prep and Exam Day Readiness
- [ ] Quick review of all four exam domains (30 minutes per domain)
- [ ] Review the glossary of key terms: Agent, Copilot, Copilot Studio, Connector, Dataverse, Declarative Agent, Microsoft Graph, Microsoft Purview, Semantic Index
- [ ] Review the exam format: 45 minutes, ~35 questions, 700/1000 to pass
- [ ] Practice time management: ~1.3 minutes per question
- [ ] Confirm exam appointment details and logistics
- [ ] Get a good night's rest before exam day
- [ ] Take the exam with confidence!

---

## Study Tips

- **Breadth over depth:** This is a fundamentals exam. Know what each service does and when to use it, not how to implement it step-by-step.
- **Focus on "what" and "when":** Understand capabilities, use cases, and appropriate scenarios.
- **Hands-on helps:** Even brief hands-on experience with Copilot Studio makes the concepts much more concrete.
- **Know the differences:** Copilot vs Copilot Studio vs Agents -- understand where each fits.
- **Governance is testable:** Do not skip the data protection, compliance, and Responsible AI sections.

## Key Resources

- **[Official Exam Page](https://learn.microsoft.com/en-us/credentials/certifications/copilot-agent-administration-fundamentals/)** - Registration and details
- **[AB-900 Learning Path](https://learn.microsoft.com/en-us/training/courses/ab-900t00)** - Free official training
- **[Practice Assessment](https://learn.microsoft.com/en-us/credentials/certifications/copilot-agent-administration-fundamentals/practice/assessment?assessment-type=practice&assessmentId=88)** - Official practice test
- **[Copilot Studio Trial](https://learn.microsoft.com/en-us/microsoft-copilot-studio/sign-up-individual)** - Free hands-on environment
- **[Exam Sandbox](https://aka.ms/examdemo)** - Familiarize yourself with the exam interface
