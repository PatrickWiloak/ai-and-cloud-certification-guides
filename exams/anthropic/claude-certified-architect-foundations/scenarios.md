# CCA-F - Exam-Style Scenarios

## How to Use This Guide

Each scenario presents a realistic situation followed by 4 answer choices. Try to answer each question before reading the solution. The exam uses scenario-based multiple choice questions - practicing with these helps you recognize patterns and avoid common traps.

**Format for each scenario:**
- Scenario description (read carefully - details matter)
- 4 answer choices (A, B, C, D)
- Correct answer with explanation
- Common distractor analysis
- Related documentation links

---

## Scenario 1 - Designing an Agentic Workflow for Customer Service

**Domain:** Agentic Architecture (27%)

### Scenario

Your company is building an AI-powered customer service system using Claude. The system needs to:
- Look up customer information in a CRM database
- Check order status from an order management system
- Process simple refund requests (under $50) automatically
- Escalate complex issues to human agents
- Maintain conversation context across multiple turns

A junior developer proposes using a simple prompt chain where each step is hardcoded in sequence: first look up customer, then check orders, then decide on action. A senior developer suggests building a fully autonomous agent with no human oversight.

Which approach is most appropriate?

**A.** Use the simple prompt chain as proposed - hardcoded sequences are more reliable than agents.

**B.** Build a single agentic loop where Claude has access to CRM, order, and refund tools, with a maximum iteration limit, human-in-the-loop for refunds over $50, and conversation history management.

**C.** Build the fully autonomous agent with no human oversight - Claude can handle all decisions independently since the tasks are straightforward.

**D.** Use separate Claude instances for each step (lookup, order check, refund) with no coordination between them.

### Solution

**Correct Answer: B**

An agentic loop is appropriate here because the workflow requires dynamic decision-making - Claude needs to decide which tools to call based on the conversation context, not follow a fixed sequence. However, full autonomy without guardrails (option C) is inappropriate for financial operations. The agent needs:

- **Tool use loop** - Claude decides which tool to call next based on conversation flow
- **Maximum iteration limit** - Prevents runaway costs and infinite loops
- **Human-in-the-loop** - Required for high-stakes actions (refunds over $50)
- **Context management** - Conversation history maintained for multi-turn interactions

**Why other answers are wrong:**
- **A** - A hardcoded sequence cannot handle the dynamic nature of customer conversations. Customers may ask about orders before providing their info, or change topics mid-conversation.
- **C** - No human oversight for financial transactions is a production anti-pattern. Always have guardrails for high-stakes actions.
- **D** - Separate, uncoordinated instances cannot maintain conversation context or make decisions based on combined information.

**Related docs:**
- **[Agentic Patterns](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - Design patterns for agentic systems

---

## Scenario 2 - Configuring Claude Code for Team Development

**Domain:** Claude Code Configuration (20%)

### Scenario

You are the lead developer on a team of 8 engineers. Your team uses Claude Code for daily development across three microservices repositories. You need to:
- Ensure all team members use consistent coding standards when working with Claude Code
- Enforce that Claude Code runs linting before every file write
- Allow individual developers to set personal preferences (like preferred language for explanations)
- Share common slash commands for deployment workflows

How should you configure Claude Code to meet these requirements?

**A.** Create a single user-level CLAUDE.md at `~/.claude/CLAUDE.md` on each developer's machine with all settings, coding standards, and slash commands.

**B.** Create project-level CLAUDE.md files in each repository root with coding standards, configure pre-tool hooks for linting in `.claude/settings.json`, tell developers to use user-level `~/.claude/CLAUDE.md` for personal preferences, and add shared slash commands to `.claude/commands/` in each repository.

**C.** Configure everything in `.claude/settings.json` at the project level. Put coding standards, slash commands, and personal preferences all in the settings file.

**D.** Use environment variables to pass coding standards and configuration to Claude Code at runtime.

### Solution

**Correct Answer: B**

This answer correctly uses the Claude Code configuration hierarchy:

- **Project-level CLAUDE.md** (checked into repo) - Team-shared coding standards and project-specific instructions
- **Pre-tool hooks** in settings - Run linting before file writes (hooks are configured in settings, not CLAUDE.md)
- **User-level CLAUDE.md** (`~/.claude/CLAUDE.md`) - Individual developer preferences
- **Project `.claude/commands/`** - Shared slash commands checked into version control

**Why other answers are wrong:**
- **A** - User-level CLAUDE.md only applies to individual developers and is not version controlled. Team standards belong in project-level files.
- **C** - Settings.json is for configuration options and permissions, not coding standards or detailed instructions. CLAUDE.md is the correct place for project instructions.
- **D** - Environment variables are not the mechanism for Claude Code configuration. CLAUDE.md files and settings.json are the proper configuration system.

**Related docs:**
- **[Claude Code Memory](https://docs.anthropic.com/en/docs/claude-code/memory)** - CLAUDE.md file hierarchy
- **[Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)** - Pre and post tool hooks
- **[Claude Code Slash Commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)** - Custom commands

---

## Scenario 3 - Implementing Structured Data Extraction

**Domain:** Prompt Engineering & Structured Output (20%)

### Scenario

You are building a system that processes customer support emails and extracts structured data: customer name, issue category (billing, technical, general), urgency (low, medium, high), and a summary. The system processes 10,000 emails per day. Each email is processed independently - there is no conversation context to maintain.

The extracted data must be valid JSON that conforms to a specific schema. Invalid JSON would cause downstream pipeline failures. Cost efficiency is important at this volume.

Which approach best meets these requirements?

**A.** Use a system prompt that says "Respond only in JSON format" and parse the response directly.

**B.** Define a tool called `extract_email_data` with a JSON schema matching your desired output structure, use `tool_choice: {"type": "tool", "name": "extract_email_data"}` to force the tool call, and enable prompt caching for the system prompt and tool definition.

**C.** Use extended thinking to reason about each email, then extract the JSON from the thinking output.

**D.** Send each email twice - once for classification and once for extraction - to improve accuracy.

### Solution

**Correct Answer: B**

This is the optimal approach because:

- **Tool use for structured output** - Defining a tool with a JSON schema guarantees the output conforms to your schema. Claude will "call" the tool with properly structured data.
- **Forced tool choice** - `tool_choice: {"type": "tool", "name": "extract_email_data"}` ensures Claude always uses the tool (no free-text responses that could break parsing)
- **Prompt caching** - At 10,000 emails/day, caching the system prompt and tool definition saves up to 90% on those tokens. The tool definition and system prompt are the same across all requests.
- **Schema validation** - Tool use provides built-in schema compliance

**Why other answers are wrong:**
- **A** - System prompt instructions alone do not guarantee valid JSON. Claude may include markdown formatting, explanation text, or slightly malformed JSON. At 10,000 emails/day, even a 1% failure rate means 100 pipeline failures.
- **C** - Extended thinking adds significant cost and is unnecessary for straightforward extraction tasks. It is designed for complex reasoning, not simple data extraction.
- **D** - Sending each email twice doubles costs with minimal accuracy improvement. Tool use with a good schema achieves high accuracy in a single call.

**Related docs:**
- **[Tool Use Guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Structured output via tool definitions
- **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Caching for high-volume workloads

---

## Scenario 4 - Building an MCP Server for Database Access

**Domain:** Tool Design & MCP Integration (18%)

### Scenario

Your team is building an MCP server that gives Claude access to a PostgreSQL database containing product inventory data. The MCP server will be used by multiple team members through Claude Code. The requirements are:

- Claude should be able to search products by name, category, or price range
- Claude should be able to read product details
- Claude should NOT be able to modify any data (read-only access)
- The server will run locally on each developer's machine

Which MCP server design is most appropriate?

**A.** Create MCP tools for `search_products` and `get_product_details`, plus an `update_product` tool with a confirmation step. Use stdio transport.

**B.** Create MCP resources for product data (e.g., `product://{id}`) and an MCP tool for `search_products`. Use stdio transport since the server runs locally.

**C.** Create a single MCP tool called `query_database` that accepts raw SQL queries. Use streamable HTTP transport.

**D.** Create MCP tools for all CRUD operations but rely on the database user permissions to prevent writes.

### Solution

**Correct Answer: B**

This design correctly uses MCP primitives:

- **MCP Resources** for read-only data access - Resources are designed for exposing data that the model can read. `product://{id}` is a resource URI that returns product details.
- **MCP Tool** for search - Search requires parameters (name, category, price range) and dynamic execution, making it appropriate as a tool.
- **stdio transport** - Correct for local processes running on each developer's machine.
- **No write capabilities** - The design does not include any mutation operations, enforcing the read-only requirement at the application level.

**Why other answers are wrong:**
- **A** - Includes an `update_product` tool which violates the read-only requirement. Even with a confirmation step, the capability should not exist.
- **C** - Accepting raw SQL queries is a security anti-pattern (SQL injection risk). Also, streamable HTTP is for remote servers - stdio is correct for local processes.
- **D** - Relying solely on database permissions is defense-in-depth, but the MCP server should not expose write operations at all. Principle of least privilege means not providing CRUD tools when only read access is needed.

**Related docs:**
- **[MCP Tools](https://modelcontextprotocol.io/docs/concepts/tools)** - When to use tools
- **[MCP Resources](https://modelcontextprotocol.io/docs/concepts/resources)** - When to use resources
- **[MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)** - Choosing the right transport

---

## Scenario 5 - Managing Context for a Long-Running Conversation

**Domain:** Context & Reliability (15%)

### Scenario

You are building a technical support chatbot using Claude. Users often have conversations that span 50+ messages as they troubleshoot complex issues. You have observed that:
- After about 30 messages, Claude starts to lose track of earlier details
- The context window fills up, causing API errors
- Costs are high because each request sends the full conversation history

You need a solution that maintains conversation quality while managing costs and staying within context limits.

**A.** Increase the max_tokens parameter to allow longer responses, which will free up context space.

**B.** Implement a sliding window that keeps only the last 10 messages, discarding all older messages.

**C.** Implement a hybrid approach: use prompt caching for the system prompt, maintain a running summary of the conversation that is updated every 10 messages, keep the last 15 messages in full, and use the summary to preserve important context from earlier in the conversation.

**D.** Switch to a model with a larger context window to avoid the problem entirely.

### Solution

**Correct Answer: C**

The hybrid approach addresses all three issues:

- **Prompt caching** for the system prompt - Since the system prompt is the same for every request, caching it reduces costs significantly
- **Running summary** - Preserves important context from earlier messages without using full token count. Updated periodically to capture key decisions and findings.
- **Recent message window** - Keeps the last 15 messages in full for immediate conversational context
- **Cost management** - The summary is much shorter than full message history, reducing per-request token counts

**Why other answers are wrong:**
- **A** - max_tokens controls response length, not context capacity. This does not address the core problem and may actually make it worse by generating longer responses.
- **B** - Discarding all older messages loses critical troubleshooting context. A user may reference something from message 5 in message 35. The sliding window alone is too aggressive.
- **D** - Claude's context window is already 200K tokens. The issue is not the window size but efficient use of it. Larger windows also mean higher costs per request.

**Related docs:**
- **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Caching static content
- **[Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)** - Managing token usage

---

## Scenario 6 - Implementing Reliability for a Production Claude Application

**Domain:** Context & Reliability (15%) / Agentic Architecture (27%)

### Scenario

You are deploying a Claude-powered document analysis service in production. The service processes legal contracts and extracts key terms, obligations, and deadlines. It serves 500 requests per hour during business hours. You have experienced the following issues:

- Occasional 429 (rate limit) errors during peak hours
- Rare 500 (server error) responses from the Anthropic API
- Sometimes Claude returns incomplete extractions that miss important contract clauses
- No visibility into why extractions fail or what Claude "thought" during processing

Which combination of reliability patterns should you implement?

**A.** Implement retry logic with a fixed 1-second delay for all errors, and add logging for failed requests.

**B.** Implement exponential backoff with jitter for 429/500 errors (respecting the Retry-After header), add a validation step that checks extracted data against expected schema and retries on validation failure, enable extended thinking for complex contracts to improve extraction quality, and implement structured logging of all API calls including token usage and thinking content.

**C.** Queue all requests and process them sequentially to avoid rate limits. Add a 5-second delay between requests.

**D.** Switch to the batch API for all requests to avoid rate limits entirely.

### Solution

**Correct Answer: B**

This answer implements a comprehensive reliability stack:

- **Exponential backoff with jitter** - The correct retry strategy for rate limits and server errors. Jitter prevents thundering herd. Retry-After header provides authoritative guidance on when to retry.
- **Validation loop** - Checks the extracted data against expected format/completeness. If Claude misses fields, it retries with additional guidance. This catches incomplete extractions.
- **Extended thinking** - For complex legal contracts, extended thinking helps Claude reason through dense text more carefully, improving extraction quality.
- **Structured logging** - Essential for debugging production issues. Logging token usage helps monitor costs. Thinking content shows Claude's reasoning for audit purposes.

**Why other answers are wrong:**
- **A** - Fixed 1-second delays do not respect rate limits (which may require longer waits) and can cause thundering herd problems. Also does not address incomplete extractions or lack of visibility.
- **C** - Sequential processing with 5-second delays would make the system too slow for 500 requests/hour (each request would need at least 5 seconds, limiting throughput to 720/hour before processing time). It also does not address quality issues.
- **D** - The batch API is designed for non-real-time workloads (results available within 24 hours). Legal contract analysis may need timely results.

**Related docs:**
- **[API Errors](https://docs.anthropic.com/en/api/errors)** - Error codes and handling
- **[Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)** - Rate limit management
- **[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Reasoning mode

---

## Scenario 7 - Prompt Optimization for a RAG Application

**Domain:** Prompt Engineering & Structured Output (20%)

### Scenario

You have built a RAG (Retrieval-Augmented Generation) application that answers questions about your company's internal documentation. The system retrieves relevant document chunks from a vector database and includes them in the prompt to Claude. You are experiencing these issues:

- High costs because each request includes the system prompt (500 tokens), few-shot examples (2000 tokens), and retrieved documents (variable, 5000-15000 tokens)
- Claude sometimes ignores relevant information from retrieved documents
- Claude sometimes makes up information not present in the retrieved documents (hallucination)

How should you optimize this system?

**A.** Remove the few-shot examples to reduce token count. Rely on the system prompt alone for output formatting.

**B.** Enable prompt caching for the system prompt and few-shot examples (which are static), place retrieved documents after the cached content with clear XML tags (e.g., `<retrieved_documents>`), add explicit instructions to "only answer based on the provided documents" and "cite the source document for each claim", and place the user's question after the documents.

**C.** Use extended thinking for every query to help Claude reason better about the documents.

**D.** Reduce the number of retrieved documents to 1-2 to keep costs low and avoid confusing Claude.

### Solution

**Correct Answer: B**

This answer addresses all three issues systematically:

- **Prompt caching** - The system prompt (500 tokens) and few-shot examples (2000 tokens) are static across all requests. Caching them saves 90% on those 2500 tokens per request.
- **XML tags for document organization** - Using `<retrieved_documents>` and individual `<document>` tags helps Claude clearly identify and reference specific sources.
- **Anti-hallucination instructions** - "Only answer based on provided documents" with citation requirements forces Claude to ground responses in the retrieved content.
- **Document placement** - Placing documents between the static content and the question follows the recommended pattern for RAG prompts.

**Why other answers are wrong:**
- **A** - Removing few-shot examples may degrade output quality significantly. The cost savings (2000 tokens) are better achieved through prompt caching which preserves the examples while reducing cost by 90%.
- **C** - Extended thinking adds cost to every request without necessarily addressing the hallucination or document-ignoring problems. It is better suited for complex reasoning tasks, not RAG retrieval.
- **D** - Reducing to 1-2 documents may cause Claude to miss relevant information. The better approach is to include sufficient documents with clear organization (XML tags) so Claude can find and use the relevant parts.

**Related docs:**
- **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Caching static content
- **[Use XML Tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)** - Organizing prompt content
- **[Prompt Engineering](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)** - General best practices

---

## Scenario 8 - Multi-Agent Orchestration for Code Review

**Domain:** Agentic Architecture (27%)

### Scenario

You are building an automated code review system using Claude. The system needs to:
1. Analyze code changes for security vulnerabilities
2. Check code style and best practices compliance
3. Evaluate test coverage and suggest missing tests
4. Generate a unified review report with prioritized findings

Each analysis type requires different expertise and context (security rules, style guides, test patterns). The analyses are independent of each other but the final report needs to synthesize all findings.

Which architecture is most appropriate?

**A.** Use a single Claude agent with all security rules, style guides, and test patterns loaded into one massive context. It performs all analyses in sequence.

**B.** Use a supervisor agent that delegates to three specialized sub-agents (security, style, testing), each with their own focused context and tools. The supervisor collects results and generates the unified report.

**C.** Use three separate API calls with no coordination. Send results to a simple template engine to generate the report.

**D.** Use extended thinking with a single prompt that includes all rules and asks Claude to perform all three analyses at once.

### Solution

**Correct Answer: B**

The supervisor pattern is ideal for this use case:

- **Specialized sub-agents** - Each agent has focused context (only security rules, only style guides, or only test patterns). This avoids context dilution and allows each agent to be expert in its domain.
- **Independent execution** - The three analyses can run in parallel since they are independent, reducing total latency.
- **Supervisor coordination** - The supervisor agent has the meta-context to prioritize findings across domains and generate a coherent, unified report.
- **Scalability** - New analysis types (performance, accessibility) can be added as new sub-agents without modifying existing ones.

**Why other answers are wrong:**
- **A** - Loading all rules into one context risks hitting context limits and dilutes attention. Claude performs better with focused context. A single agent doing everything sequentially is also slower.
- **C** - No coordination means the report cannot intelligently prioritize or correlate findings. A template engine cannot reason about how security issues interact with code style issues.
- **D** - Extended thinking helps with complex reasoning but does not solve the context overload problem. All three sets of rules in one prompt still dilutes the context.

**Related docs:**
- **[Agentic Patterns](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - Multi-agent and supervisor patterns

---

## Scenario 9 - Configuring MCP for a Remote Team

**Domain:** Tool Design & MCP Integration (18%) / Claude Code Configuration (20%)

### Scenario

Your company has a team of developers who use Claude Code. They need access to shared internal tools:
- A company knowledge base API (hosted on an internal server)
- A ticket management system API (hosted on an internal server)
- A local code analysis tool (runs on each developer's machine)

You need to configure MCP servers so all team members can access these tools through Claude Code.

**A.** Build all three as stdio MCP servers and have each developer run them locally. Share the server code via the repository.

**B.** Build the knowledge base and ticket system as MCP servers using streamable HTTP transport (since they are remote APIs), build the code analysis tool as a stdio MCP server (since it runs locally), and configure them in the project's `.mcp.json` file so all team members get the same configuration.

**C.** Build all three as REST APIs and have developers call them manually, pasting results into Claude Code.

**D.** Build all three as streamable HTTP MCP servers hosted on the internal server, including the code analysis tool.

### Solution

**Correct Answer: B**

This correctly matches transport types to deployment models:

- **Streamable HTTP** for remote services - The knowledge base and ticket system are on internal servers, making HTTP-based transport appropriate. Streamable HTTP is the modern recommended transport for remote MCP servers.
- **stdio** for local tools - The code analysis tool runs on each developer's machine, making stdio the natural choice.
- **Project `.mcp.json`** - This file is checked into the repository, ensuring all team members share the same MCP configuration.

**Why other answers are wrong:**
- **A** - Running the knowledge base and ticket system MCP servers locally via stdio means each developer needs credentials, local setup, and cannot benefit from centralized deployment. These are remote services and should use remote transports.
- **C** - This defeats the purpose of MCP integration. Manual copy-paste is not an automated workflow.
- **D** - The code analysis tool runs on local code. Hosting it remotely would require transferring code to the server, adding latency and security concerns.

**Related docs:**
- **[MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)** - Transport type selection
- **[Claude Code MCP Servers](https://docs.anthropic.com/en/docs/claude-code/mcp-servers)** - MCP in Claude Code

---

## Scenario 10 - Choosing Between Agent and Simple Prompt

**Domain:** Agentic Architecture (27%)

### Scenario

You are building four different features for your application. For which feature is an agentic approach (tool use loop) most appropriate?

**A.** A feature that translates user interface text from English to Spanish, French, and German.

**B.** A feature that summarizes a single document into 3 bullet points.

**C.** A feature that researches a topic by searching multiple databases, reading relevant documents, cross-referencing findings, and writing a report with citations.

**D.** A feature that classifies incoming emails into categories (spam, support, sales, other).

### Solution

**Correct Answer: C**

The research feature requires an agentic approach because:

- **Multi-step reasoning** - The agent must search, read, cross-reference, and synthesize
- **Dynamic tool use** - Search results determine which documents to read next
- **Iterative refinement** - Initial findings may reveal new search queries
- **Multiple tool calls** - Database search tools, document reading tools, and writing tools are needed in a dynamic sequence
- **Decision making** - The agent decides when it has enough information to write the report

**Why other answers are wrong:**
- **A** - Translation is a single-step task. One API call with appropriate prompting handles this efficiently. No tools or iteration needed.
- **B** - Summarization is a single-step task. The document goes in, the summary comes out. No tools or multi-step reasoning needed.
- **D** - Classification is a single-step task. Each email is classified independently with one API call. Tool use or structured output can help format the result, but an agentic loop is not needed.

**Key principle:** Use agents when the task requires dynamic decision-making about which actions to take next based on intermediate results. Use simple prompts when the input-to-output mapping is straightforward.

**Related docs:**
- **[Agentic Patterns](https://docs.anthropic.com/en/docs/build-with-claude/agentic)** - When to use agentic systems
