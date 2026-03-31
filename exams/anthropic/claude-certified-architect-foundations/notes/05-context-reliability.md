# Domain 5 - Context & Reliability (15%)

## Overview

This domain covers managing Claude's context window effectively, implementing reliability patterns for production systems, and understanding the operational aspects of the Claude API. While it is the lowest-weighted domain, the concepts here apply across all other domains.

---

## Context Window Management

### Context Window Size

Claude models support a 200K token context window. This is the total capacity for:
- System prompt tokens
- Message history tokens (all turns)
- Tool definitions
- Tool results
- The response itself (output tokens)

**[Models Overview](https://docs.anthropic.com/en/docs/about-claude/models)** - Model specifications and context limits

### Token Counting

**[Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)** - Pre-request token calculation

Use the token counting API to estimate token usage before sending a request:
- Prevents context overflow errors
- Helps with cost estimation
- Enables smart context management decisions

Key facts:
- 1 token is approximately 3-4 characters in English
- Images and PDFs consume tokens based on their size/resolution
- Tool definitions consume tokens (factor this into context budgets)
- System prompts consume input tokens

### Context Management Strategies

**Sliding Window**
- Keep the most recent N messages, drop older ones
- Simple to implement but loses historical context
- Best for conversations where recent context matters most

**Summarization**
- Periodically summarize older messages into a condensed form
- Maintains key information while reducing token count
- Can be done by Claude itself (use a separate API call to summarize)
- Best for long conversations where historical context matters

**Retrieval-Augmented Generation (RAG)**
- Store documents in a vector database
- Retrieve only relevant chunks based on the current query
- Include retrieved chunks in the prompt as context
- Best for knowledge-base applications

**Chunking**
- Split large documents into smaller pieces
- Process each chunk separately
- Aggregate results
- Best for document processing tasks that exceed context limits

**Priority Placement**
- Place the most important information at the beginning and end of context
- Claude pays more attention to content at these positions (primacy and recency effects)
- Put reference documents in the middle, instructions at the start, questions at the end

---

## Prompt Caching

**[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Caching for cost and performance

### How Caching Works

1. Mark static content with `cache_control: {"type": "ephemeral"}`
2. First request processes normally and caches the marked content
3. Subsequent requests (within TTL) reuse cached content
4. Cache hits charge 10% of normal input token price (90% savings)
5. Cache writes charge 25% more than normal input token price

### Cache Requirements

- Minimum cacheable content: 1024 tokens (2048 for Claude 3.5 Haiku)
- Cache TTL: 5 minutes (refreshed on each cache hit)
- Cache key based on exact content match
- Any change to cached content invalidates the cache

### Cost Math

For a system prompt of 1000 tokens used in 100 requests:
- Without caching: 100 x 1000 = 100,000 input tokens charged at full rate
- With caching: 1 cache write (1000 tokens at 1.25x) + 99 cache hits (1000 tokens at 0.1x) = 1,250 + 9,900 = 11,150 effective tokens
- Savings: approximately 89%

### Best Practices

- Cache system prompts in multi-turn conversations
- Cache few-shot examples that do not change between requests
- Cache tool definitions for high-volume applications
- Place cached content before variable content in the prompt
- Monitor cache hit rates to ensure caching is effective

---

## Extended Thinking

**[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Claude's reasoning mode

### What is Extended Thinking?

Extended thinking allows Claude to use internal reasoning (a "thinking" block) before generating its response. This is distinct from chain-of-thought prompting because:
- It uses a dedicated thinking budget (separate from response tokens)
- The thinking content is in a separate block (not mixed with the response)
- It is controlled via API parameters, not prompt instructions
- It typically produces deeper, more thorough reasoning

### When to Use

- Complex analytical tasks (legal analysis, code review, mathematical proofs)
- Tasks requiring consideration of multiple factors
- Situations where accuracy is more important than speed
- Planning phases of agentic workflows

### When Not to Use

- Simple tasks (classification, translation, basic Q&A)
- Latency-sensitive applications where speed matters more than depth
- High-volume, low-complexity tasks (cost adds up)
- Tasks that do not benefit from extended reasoning

### Configuration

Set the thinking budget via the `thinking` parameter:
```json
{
  "thinking": {
    "type": "enabled",
    "budget_tokens": 10000
  }
}
```

### Tradeoffs

- **Cost** - Thinking tokens add to the total cost of each request
- **Latency** - Extended thinking takes additional time before the response
- **Quality** - Generally improves quality for complex tasks
- **Streaming** - Thinking content is delivered as a single event, then response streams normally

---

## Reliability Patterns

### Exponential Backoff with Jitter

The standard retry strategy for API errors:

```
delay = min(base_delay * 2^attempt + random_jitter, max_delay)
```

- **Base delay** - Start with 1-2 seconds
- **Exponential increase** - Double the delay on each retry
- **Jitter** - Add random variation to prevent thundering herd
- **Max delay** - Cap at 30-60 seconds
- **Max retries** - Typically 3-5 attempts

Always check the `Retry-After` header on 429 responses - it provides authoritative guidance.

### Fallback Models

When the primary model is unavailable or rate-limited:

1. Try Claude 3.5 Sonnet (primary)
2. Fall back to Claude 3.5 Haiku (faster, cheaper, still capable)
3. Fall back to a cached/default response if all models fail

Considerations:
- Fallback models may have different capabilities
- Test your prompts with all fallback models
- Log which model actually served each request

### Validation Loops

Check Claude's output against expected criteria and retry if needed:

1. Send request to Claude
2. Validate response (schema check, content check, format check)
3. If invalid, retry with additional guidance about what went wrong
4. After N retries, return an error or partial result

Use cases:
- JSON schema validation for structured output
- Content safety checks
- Completeness checks (did Claude address all parts of the question?)

### Circuit Breaker Pattern

Stop making API calls after repeated failures:

1. **Closed** - Normal operation, requests go through
2. **Open** - After N consecutive failures, stop making requests
3. **Half-open** - After a cooldown period, try one request to check if the issue is resolved

This prevents wasting API calls (and money) when there is a systemic issue.

### Timeout Management

Set appropriate timeouts for different scenarios:
- Simple requests: 30 seconds
- Complex reasoning: 60-120 seconds
- Extended thinking: 120-300 seconds (depending on thinking budget)
- Agentic loops: per-iteration timeout + total task timeout

---

## Streaming

**[Streaming Guide](https://docs.anthropic.com/en/docs/build-with-claude/streaming)** - Real-time responses

### How Streaming Works

Claude's streaming uses Server-Sent Events (SSE):
- Response tokens are sent incrementally as they are generated
- Client receives events for each chunk of content
- Reduces perceived latency (user sees output before it is complete)

### Event Types

- `message_start` - Beginning of the response
- `content_block_start` - Start of a content block (text, tool use, thinking)
- `content_block_delta` - Incremental content updates
- `content_block_stop` - End of a content block
- `message_delta` - Message-level updates (stop reason, usage)
- `message_stop` - End of the response

### Streaming with Extended Thinking

When extended thinking is enabled:
- The thinking block is delivered as a single event (not streamed token by token)
- After thinking completes, the response text streams normally
- This means there may be a pause before any visible output while Claude thinks

### Streaming with Tool Use

When Claude decides to use a tool during streaming:
- The tool call is streamed as it is generated
- Your application must buffer the complete tool call before executing it
- After tool execution, send the result and resume streaming

---

## Rate Limiting

**[Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)** - API limit management

### Limit Types

- **Requests per minute (RPM)** - Maximum number of API requests per minute
- **Tokens per minute (TPM)** - Maximum input + output tokens per minute
- **Tokens per day (TPD)** - Maximum tokens per day (some tiers)

### Rate Limit Headers

Every API response includes rate limit headers:
- `anthropic-ratelimit-requests-limit` - Your RPM limit
- `anthropic-ratelimit-requests-remaining` - Remaining requests
- `anthropic-ratelimit-requests-reset` - When the limit resets
- `anthropic-ratelimit-tokens-limit` - Your TPM limit
- `anthropic-ratelimit-tokens-remaining` - Remaining tokens
- `anthropic-ratelimit-tokens-reset` - When the limit resets

### Handling 429 Errors

1. Check the `Retry-After` header for how long to wait
2. Implement exponential backoff with jitter
3. Consider queuing requests to stay under limits
4. Monitor rate limit headers proactively to avoid hitting limits

---

## API Error Codes

**[API Errors](https://docs.anthropic.com/en/api/errors)** - Error reference

| Code | Name | Retryable | Action |
|---|---|---|---|
| 400 | Bad Request | No | Fix the request (invalid parameters, format) |
| 401 | Unauthorized | No | Check API key |
| 403 | Forbidden | No | Check permissions/access |
| 404 | Not Found | No | Check endpoint URL |
| 408 | Timeout | Yes | Retry with backoff |
| 429 | Rate Limited | Yes | Retry after Retry-After delay |
| 500 | Server Error | Yes | Retry with backoff |
| 529 | Overloaded | Yes | Retry with backoff (may need longer delays) |

---

## Key Exam Concepts

1. Know context window sizes and how different content types consume tokens
2. Understand prompt caching requirements, TTL, and cost savings
3. Know when to use extended thinking and its tradeoffs
4. Understand all reliability patterns (backoff, fallback, validation, circuit breaker)
5. Know how streaming works including with extended thinking and tool use
6. Understand rate limit headers and how to handle 429 errors
7. Know the difference between retryable and non-retryable errors
8. Understand context management strategies (sliding window, summarization, RAG)

---

## Related Documentation

- **[Models Overview](https://docs.anthropic.com/en/docs/about-claude/models)** - Context window sizes
- **[Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)** - Token calculation
- **[Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)** - Caching system
- **[Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)** - Reasoning mode
- **[Streaming](https://docs.anthropic.com/en/docs/build-with-claude/streaming)** - Real-time responses
- **[Rate Limits](https://docs.anthropic.com/en/docs/build-with-claude/rate-limits)** - API limits
- **[API Errors](https://docs.anthropic.com/en/api/errors)** - Error codes
