# Microsoft Copilot Studio - AB-900

## What is Microsoft Copilot Studio?

Microsoft Copilot Studio is a low-code graphical platform that enables organizations to build, customize, and manage AI-powered copilots (conversational agents). It allows both professional developers and citizen developers to create custom copilots that can answer questions, automate tasks, and integrate with business systems, all without writing extensive code.

**[📖 Microsoft Copilot Studio Overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)** - Introduction to Copilot Studio and its capabilities.

**[📖 Get Started with Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-get-started)** - Quickstart guide for building your first copilot.

## Copilot Studio Interface

### Key Areas of the Authoring Canvas
- **Topics:** Define conversation flows and responses
- **Actions:** Connect to external services and automate tasks
- **Knowledge:** Configure AI-generated answers from data sources
- **Analytics:** Monitor performance and user interactions
- **Channels:** Publish copilots to various platforms
- **Settings:** Configure copilot behavior, authentication, and governance

**[📖 Copilot Studio Authoring Interface](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-first-bot)** - Navigating the Copilot Studio environment.

## Topics

### What are Topics?

Topics are the building blocks of a copilot's conversation flow. Each topic represents a specific subject or task the copilot can handle and defines how it responds to related user input.

**[📖 Create and Edit Topics](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-create-edit-topics)** - Building conversation flows with topics.

### Topic Components

#### Trigger Phrases
- **Definition:** Example phrases or sentences that activate a specific topic
- **Purpose:** Help the copilot's natural language understanding match user input to the correct topic
- **Best Practices:**
  - Include 5-10 varied trigger phrases per topic
  - Use different wordings for the same intent
  - Include both formal and casual phrasing
  - Avoid overlapping trigger phrases across topics

**[📖 Topic Triggers](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-triggers)** - Configuring trigger phrases and conditions.

#### Conversation Nodes
Nodes are the individual steps in a topic's conversation flow:

- **Message Node:** Display a message or prompt to the user
- **Question Node:** Ask the user a question and capture their response
- **Condition Node:** Branch the conversation based on conditions or variable values
- **Variable Assignment:** Set or update variable values during the conversation
- **Topic Redirect:** Transfer the conversation to a different topic
- **End Conversation:** Close the current topic and optionally gather feedback

**[📖 Conversation Nodes](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-create-edit-topics)** - Using nodes to build conversation flows.

#### Variables
- **Purpose:** Store and use information throughout the conversation
- **Scope:**
  - **Topic Variables:** Available only within the current topic
  - **Global Variables:** Available across all topics in the copilot
- **Types:** String, number, boolean, table, record, date/time
- **Usage:** Capture user input, pass data between nodes, personalize responses

**[📖 Variables in Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-variables)** - Working with variables in conversation flows.

### System Topics

Pre-built topics that handle common conversation scenarios:

- **Greeting:** Initial welcome message when a user starts a conversation
- **Goodbye:** Closing message when a conversation ends
- **Escalate:** Transfer to a human agent when the copilot cannot help
- **Fallback:** Response when no topic matches the user's input
- **Start Over:** Reset the conversation
- **Multiple Topics Matched:** Handle ambiguity when multiple topics match
- **Conversational Boosting (Generative Answers):** AI-generated responses from knowledge sources

**[📖 System Topics](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-system-topics)** - Understanding and customizing system topics.

## Actions

### What are Actions?

Actions extend a copilot's capabilities beyond conversation by connecting it to external systems, services, and automated workflows. They allow copilots to retrieve data, perform operations, and trigger business processes.

**[📖 Add Actions to Copilots](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-fundamentals-actions)** - Extending copilot capabilities with actions.

### Types of Actions

#### Power Automate Flows
- **Integration:** Call Power Automate cloud flows directly from copilot topics
- **Capabilities:** Access hundreds of services, perform complex logic, transform data
- **Input/Output:** Pass variables from the copilot to the flow and receive results back
- **Use Cases:** Create records, send notifications, query databases, approve requests

**[📖 Power Automate Integration](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-flow-create)** - Connecting copilots with Power Automate flows.

#### Connector Actions
- **Pre-built Connectors:** Hundreds of ready-to-use connections (SharePoint, Outlook, Dynamics 365, Salesforce, ServiceNow, etc.)
- **Direct Use:** Call connectors directly from topics without building a separate flow
- **Data Operations:** Read, create, update, and delete records in connected systems
- **Authentication:** Connectors handle authentication with the target service

**[📖 Use Connectors in Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-connectors)** - Connecting to external data sources and services.

#### Custom Actions
- **HTTP Requests:** Call custom APIs and web services
- **Bot Framework Skills:** Integrate with advanced Bot Framework capabilities
- **Code Components:** Extend with custom code for complex scenarios

#### Plugin Actions
- **Microsoft 365 Plugins:** Access Microsoft 365 data and services
- **AI Plugins:** Leverage AI Builder and Azure AI capabilities
- **Third-Party Plugins:** Integrate with external plugin ecosystems

### Generative Actions

Generative actions use AI to dynamically determine which actions to call based on the user's intent, without requiring explicit topic authoring:
- **Dynamic Selection:** AI determines which action best addresses the user's request
- **Natural Orchestration:** Multiple actions can be chained together intelligently
- **Reduced Authoring:** Less need for rigid conversation flows and explicit mappings

**[📖 Generative Orchestration](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-generative-actions)** - AI-driven action selection and orchestration.

## Knowledge and Generative Answers

### Generative Answers

Generative answers enable a copilot to use AI to generate responses from configured knowledge sources, without requiring manually authored topics for every possible question.

**[📖 Generative Answers](https://learn.microsoft.com/en-us/microsoft-copilot-studio/nlu-boost-conversations)** - Enabling AI-generated responses in copilots.

### Knowledge Sources

#### Supported Sources
- **Public Websites:** Crawl and index public web pages
- **SharePoint:** Access organizational documents and pages
- **Dataverse:** Query structured business data
- **Uploaded Files:** Use uploaded documents (Word, PDF, etc.) as knowledge
- **Custom Data:** Connect to custom data sources via connectors

#### How It Works
1. User asks a question that does not match a specific topic
2. Copilot searches configured knowledge sources for relevant content
3. AI generates a natural language response based on the retrieved content
4. Response includes citations linking back to source documents
5. User can follow citations to access the original content

**[📖 Knowledge Sources Configuration](https://learn.microsoft.com/en-us/microsoft-copilot-studio/nlu-generative-answers-sharepoint-onedrive)** - Configuring knowledge sources for generative answers.

### Content Moderation
- Built-in content safety filters for generated responses
- Configurable content moderation levels
- Source attribution to ensure traceability
- Fallback to authored topics when confidence is low

## Connectors and Data Integration

### Power Platform Connectors

#### What are Connectors?
- Pre-built integrations that connect Copilot Studio to external services and data
- Part of the broader Power Platform connector ecosystem
- Handle authentication, data formatting, and API communication

#### Common Connectors
- **Microsoft 365:** SharePoint, Outlook, OneDrive, Teams
- **Dynamics 365:** Sales, Customer Service, Marketing
- **Databases:** SQL Server, Azure SQL, Cosmos DB
- **Third-Party:** Salesforce, ServiceNow, SAP, Slack, Jira
- **Development:** HTTP, Azure Functions, Custom APIs

**[📖 Power Platform Connectors](https://learn.microsoft.com/en-us/connectors/connector-reference/)** - Complete connector reference catalog.

### Dataverse

#### What is Dataverse?
- Cloud-based data platform underlying Power Platform
- Provides structured data storage with rich data types
- Supports business logic, validation, and security
- Integrates natively with Copilot Studio

#### Integration with Copilot Studio
- Query Dataverse tables directly from copilot topics
- Create and update records through conversation flows
- Use Dataverse data to personalize copilot responses
- Leverage Dataverse security roles for data access control

**[📖 Dataverse Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/data-platform-intro)** - Understanding the data platform.

## Publishing and Channels

### Publishing Options

#### Microsoft Teams
- Deploy copilots as Teams apps
- Available in 1:1 chats and team channels
- Integrate with Teams messaging experience
- Support for adaptive cards and rich responses

**[📖 Deploy to Teams](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-add-bot-to-microsoft-teams)** - Publishing copilots to Microsoft Teams.

#### Websites
- Embed copilots on web pages via iframe or custom canvas
- Customizable chat widget appearance
- Support for authenticated and anonymous users
- Responsive design for mobile and desktop

**[📖 Deploy to Websites](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-connect-bot-to-web-channels)** - Embedding copilots on websites.

#### Power Apps
- Integrate copilots within Power Apps canvas and model-driven apps
- Contextual assistance within business applications
- Pass data between the app and copilot

#### Additional Channels
- Facebook Messenger
- Slack
- Custom channels via Direct Line API
- Mobile apps

**[📖 Publish Copilots](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-fundamentals-publish-channels)** - Multi-channel publishing overview.

## Analytics and Performance

### Built-in Analytics Dashboard

#### Key Metrics
- **Session Tracking:** Number of sessions, session duration, messages per session
- **Resolution Rate:** Percentage of conversations resolved without escalation
- **Escalation Rate:** Percentage of conversations escalated to human agents
- **Abandonment Rate:** Percentage of conversations abandoned by users
- **Customer Satisfaction (CSAT):** User ratings and feedback scores
- **Topic Performance:** Most and least used topics, success rates per topic

#### Analytics Views
- **Summary:** High-level KPIs and trends
- **Customer Satisfaction:** CSAT scores and feedback details
- **Sessions:** Detailed session logs and conversation transcripts
- **Topics:** Per-topic performance metrics and improvement areas

**[📖 Copilot Studio Analytics](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-overview)** - Monitoring and analyzing copilot performance.

### Improving Copilot Performance
- Review unresolved and escalated sessions
- Identify missing topics from fallback data
- Refine trigger phrases based on actual user queries
- Optimize conversation flows for common paths
- Monitor generative answer quality and add knowledge sources as needed

## Copilot Studio Administration

### Environment Management
- Copilots are created within Power Platform environments
- Environments provide isolation, security boundaries, and data separation
- Production and development environments for lifecycle management

### Security and Governance
- Role-based access for copilot authors and administrators
- Data loss prevention (DLP) policies restrict connector usage
- Authentication options for end users (Azure AD, manual)
- Audit logging of copilot creation and modification

**[📖 Copilot Studio Admin Overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/admin-overview)** - Administration and governance.

**[📖 Power Platform Admin Center](https://learn.microsoft.com/en-us/power-platform/admin/admin-documentation)** - Managing environments and governance.

## Key Takeaways for AB-900

1. **Low-Code Platform:** Copilot Studio enables both citizen developers and professional developers to build copilots
2. **Topics:** Conversation flows defined by trigger phrases and conversation nodes
3. **Actions:** Extend copilots with Power Automate, connectors, and custom integrations
4. **Generative Answers:** AI-generated responses from knowledge sources (websites, SharePoint, Dataverse, files)
5. **Generative Actions:** AI dynamically selects which actions to execute based on user intent
6. **Publishing:** Multi-channel deployment to Teams, websites, Power Apps, and more
7. **Analytics:** Built-in dashboards for monitoring resolution rates, CSAT, and topic performance
8. **Governance:** DLP policies, role-based access, and environment management through Power Platform
