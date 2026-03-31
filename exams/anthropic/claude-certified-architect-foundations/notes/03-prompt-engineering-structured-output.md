# Domain 3 - Prompt Engineering & Structured Output (20%)

## Overview

This domain covers writing effective prompts for Claude and extracting structured data from responses. Claude has specific behaviors and capabilities that make it respond differently to various prompting techniques. Understanding these is critical for both the exam and production use.

---

## Prompt Engineering Fundamentals

**[Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)** - Primary reference

### System Prompts vs User Prompts

**System prompts** set Claude's role, behavior, and constraints. They are sent as the `system` parameter in the API request.

Use system prompts for:
- Defining Claude's role and persona
- Setting behavioral constraints and guidelines
- Providing reference information that applies to all messages
- Establishing output format expectations

**User prompts** are the actual requests from the user, sent in the `messages` array.

**[System Prompts Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts)** - Best practices for system prompt design

Key principles:
- System prompts are processed first and set the frame for all subsequent interactions
- Keep system prompts focused and concise
- System prompts support prompt caching (ideal for multi-turn conversations)
- Do not repeat information between system and user prompts

---

## XML Tags for Prompt Organization

Claude responds exceptionally well to XML-tagged sections in prompts. XML tags provide clear structure that helps Claude parse and follow complex instructions.

**[Use XML Tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)** - XML tag techniques

### Common XML Tag Patterns

```xml
<instructions>
Your task-specific instructions here.
</instructions>

<context>
Background information Claude needs to complete the task.
</context>

<examples>
<example>
<input>Example input</input>
<output>Expected output</output>
</example>
</examples>

<document>
The document to analyze or process.
</document>
```

### Benefits of XML Tags

- **Clarity** - Claude clearly distinguishes between instructions, context, and data
- **Parsing** - You can ask Claude to wrap its output in XML tags for easy extraction
- **Organization** - Complex prompts become readable and maintainable
- **Referencing** - You can refer to tagged sections by name (e.g., "use the data in <context>")

### Best Practices

- Use descriptive tag names that indicate content purpose
- Be consistent with tag naming across your application
- Use XML tags to separate variable content from fixed instructions
- Nest tags when logical (e.g., examples within an examples block)

---

## Chain-of-Thought Reasoning

**[Chain of Thought](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought)** - Eliciting step-by-step reasoning

### When to Use Chain-of-Thought

- Complex reasoning tasks (math, logic, analysis)
- Tasks requiring multiple steps of evaluation
- Decision-making with multiple factors
- Debugging or troubleshooting scenarios

### Techniques

1. **Explicit instruction** - "Think step by step before answering"
2. **Structured thinking** - "First analyze X, then consider Y, then determine Z"
3. **Thinking tags** - Ask Claude to put reasoning in `<thinking>` tags before the answer
4. **Extended thinking** - Use the API's built-in extended thinking feature for complex tasks

### Chain-of-Thought vs Extended Thinking

| Feature | Chain-of-Thought Prompting | Extended Thinking |
|---|---|---|
| How activated | Prompt instructions | API parameter |
| Visibility | In the response text | Separate thinking block |
| Token cost | Response tokens (output pricing) | Thinking tokens (separate pricing) |
| Quality | Good for moderate complexity | Better for high complexity |
| Control | Prompt-based | Budget-based (max thinking tokens) |

---

## Few-Shot and Many-Shot Prompting

**[Few-Shot Prompting](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/few-shot-prompting)** - Example-based prompting

### Few-Shot Prompting

Provide 2-5 input/output examples to guide Claude's behavior:

```xml
<examples>
<example>
<input>The product arrived damaged and I want a refund.</input>
<output>{"category": "refund", "urgency": "high", "sentiment": "negative"}</output>
</example>
<example>
<input>When does the store open on weekends?</input>
<output>{"category": "general_inquiry", "urgency": "low", "sentiment": "neutral"}</output>
</example>
</examples>
```

Benefits:
- Demonstrates exact output format without ambiguity
- Establishes classification categories implicitly
- Reduces need for verbose instructions
- Particularly effective for format-sensitive tasks

### Many-Shot Prompting

Provide dozens to hundreds of examples for highly specific patterns. Useful when:
- The task requires nuanced pattern matching
- Edge cases are common
- Consistency across many categories is important

Consider using prompt caching for many-shot prompts since the examples are static.

### When to Choose Which

- **Zero-shot** - Task is straightforward and Claude handles it well without examples
- **Few-shot (2-5)** - Format or behavior needs demonstration; common choice
- **Many-shot (10+)** - Highly specific or nuanced task requiring precise pattern matching

---

## Structured Output Techniques

### Method 1 - Tool Use for Structured Extraction

The most reliable method for getting structured JSON output. Define a tool with the desired schema:

```json
{
  "name": "extract_data",
  "description": "Extract structured data from the input",
  "input_schema": {
    "type": "object",
    "properties": {
      "name": {"type": "string", "description": "Customer name"},
      "category": {"type": "string", "enum": ["billing", "technical", "general"]},
      "urgency": {"type": "string", "enum": ["low", "medium", "high"]}
    },
    "required": ["name", "category", "urgency"]
  }
}
```

Use `tool_choice: {"type": "tool", "name": "extract_data"}` to force Claude to call this tool.

**Advantages:**
- Schema-enforced output structure
- Enum constraints for categorical fields
- Required field enforcement
- No need to parse free text

### Method 2 - JSON Mode via System Prompt

Include explicit JSON format instructions in the system prompt:

```
You are a data extraction assistant. Always respond with valid JSON matching this schema:
{"name": string, "category": "billing"|"technical"|"general", "urgency": "low"|"medium"|"high"}
```

**Advantages:**
- Simpler implementation than tool use
- Works without tool definitions

**Disadvantages:**
- Less reliable than tool use (Claude may add explanation text)
- No schema enforcement at the API level

### Method 3 - Prefilling

Start the assistant message with `{` to force JSON output:

```json
{
  "role": "assistant",
  "content": "{"
}
```

Claude will continue from this prefix and produce JSON. Note: this technique is not available with extended thinking.

### Method 4 - XML Output Tags

Ask Claude to wrap output in specific tags for easy parsing:

```
Wrap your response in <result> tags with the following fields...
```

Useful when you want structured output but not necessarily JSON.

### Recommended Approach for Exam

The exam favors **tool use for structured extraction** as the primary method. It is the most reliable, provides schema enforcement, and is the officially recommended approach for production systems.

---

## Prompt Caching

**[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Cost optimization through caching

### How It Works

1. Mark static parts of your prompt with `cache_control: {"type": "ephemeral"}`
2. On the first request, Anthropic caches the marked content
3. Subsequent requests within the TTL (5 minutes) reuse the cached content
4. Cached tokens are charged at 10% of the normal input price (90% savings)

### Requirements

- Cached content must be at least 1024 tokens (2048 tokens for Claude 3.5 Haiku)
- The cache key is based on exact content match - any change invalidates the cache
- Cache TTL is 5 minutes, refreshed on each cache hit

### Ideal Use Cases

- System prompts in multi-turn conversations
- Few-shot/many-shot example sets
- Reference documents in RAG applications
- Tool definitions that do not change between requests
- Long instructions that apply to every request

### What to Cache

```
[System prompt - 500 tokens] -- CACHE THIS
[Few-shot examples - 2000 tokens] -- CACHE THIS
[Retrieved documents - 10000 tokens] -- Variable, do not cache
[User question - 50 tokens] -- Variable, do not cache
```

---

## Multimodal Prompting

### Vision

**[Vision Guide](https://docs.anthropic.com/en/docs/build-with-claude/vision)** - Image understanding

Claude can process images sent as base64-encoded data or URLs:
- Describe image content
- Extract text from images (OCR)
- Analyze charts and diagrams
- Answer questions about visual content

### PDF Processing

**[PDF Support](https://docs.anthropic.com/en/docs/build-with-claude/pdf-support)** - Document processing

Claude can read and analyze PDF documents:
- Extract text and data from PDFs
- Answer questions about document content
- Summarize multi-page documents
- Process forms and structured documents

---

## Temperature and Sampling

- **Temperature** - Controls randomness in output (0 to 1)
  - 0 = Most deterministic (note: not perfectly deterministic)
  - 1 = Default, good balance of creativity and consistency
  - Higher values increase variation
- **Top-p** - Alternative to temperature, controls diversity
- **Top-k** - Limits the number of tokens considered at each step

For structured output and data extraction, lower temperatures (0-0.3) are generally preferred.
For creative writing and brainstorming, higher temperatures (0.7-1.0) work well.

---

## Key Exam Concepts

1. Know when to use system prompts vs user prompts
2. Understand XML tag patterns and their benefits
3. Know the differences between chain-of-thought prompting and extended thinking
4. Understand all four structured output methods and when to use each
5. Know prompt caching requirements (minimum tokens, TTL, cost savings)
6. Understand few-shot vs many-shot vs zero-shot tradeoffs
7. Know how temperature and sampling parameters affect output
8. Understand multimodal capabilities (vision, PDF)

---

## Related Documentation

- **[Prompt Engineering](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)** - Main guide
- **[System Prompts](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts)** - System prompt design
- **[Chain of Thought](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought)** - Reasoning techniques
- **[Use XML Tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)** - XML organization
- **[Few-Shot Prompting](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/few-shot-prompting)** - Example-based prompting
- **[Tool Use](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Structured extraction via tools
- **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Cost optimization
- **[Vision](https://docs.anthropic.com/en/docs/build-with-claude/vision)** - Image processing
- **[PDF Support](https://docs.anthropic.com/en/docs/build-with-claude/pdf-support)** - Document processing
- **[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Built-in reasoning
