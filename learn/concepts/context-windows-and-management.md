---
last-updated: 2026-05-03
difficulty: beginner
reading-time: 7 min
---

# Context windows and management

> **7-minute read. Assumes you've read [LLM basics](./llm-basics.md).**

## The one-line answer

The context window is the total number of tokens (chunks of text, roughly 0.75 of a word) the model can "see" in a single call - your system prompt, the conversation history, retrieved documents, tool definitions, and the response it generates. Every call has a hard limit. Modern frontier models range from 128K to 1M+ tokens. Knowing how to manage this budget is most of the work in building real LLM apps.

## What counts as context

Everything sent to the model in a single API call:

```
context = system_prompt
        + tool_definitions
        + chat_history (every turn so far)
        + retrieved_documents (RAG)
        + the user's current message
        + the response (counted toward the same window)
```

Tokens vary by language. A token in English is ~4 characters or 0.75 words. In code or other languages it can be much less efficient.

## The limit isn't free

A 1M-token context is *technically* available. Practically:

- **Cost scales linearly** with input tokens. 500K tokens at $3/M = $1.50 per call. Multiply by however many users you have.
- **Latency scales** with input length. The model has to attend to all of it. Time-to-first-token for very long contexts can be 10s+.
- **Quality often degrades** past a few hundred K tokens, even when the limit is much higher. The "lost in the middle" effect (see below) is real.
- **Caching helps** but only if you structure the request right.

## Lost in the middle

Documented in [Liu et al. 2023](https://arxiv.org/abs/2307.03172) and replicated since: LLMs attend more strongly to the start and end of a long context than to the middle. If you bury the relevant chunk at position 50 of 100, the model often misses it - even though the limit was nowhere close.

Implications:

- For RAG, **rank by relevance and put the best chunk first or last**, not in the middle.
- For long agent histories, **summarize old turns** and put the summary near the start, with recent turns at the end.
- For tool results from many parallel calls, the order matters. Put the most-load-bearing result last.

## Strategies for staying inside the budget

### Truncation
Drop the oldest turns when you exceed the budget. Simple. Works fine for short-conversation bots. Useless for anything that requires long-term memory.

### Sliding window
Keep the most recent N turns and a separate, persistent system prompt. A specialized form of truncation.

### Summarization
When the history grows past a threshold, ask the model to summarize the earlier turns into a paragraph. Replace those turns with the summary. This loses fidelity but keeps the budget bounded.

### Retrieval as context extension
Don't put the whole doc in the prompt. Embed it, retrieve only the relevant chunks per query. This is [RAG](./rag-explained.md), and it's the workhorse strategy for "I have a million tokens of source material."

### Prompt caching
If part of your prompt is stable across many calls (the system prompt, tool definitions, a long doc), use [prompt caching](./prompt-caching.md). The model still "sees" all those tokens but you pay 10x less for cached portions.

### Hierarchical summaries
For agentic loops with very long histories, maintain a tree of summaries: per-turn detail, per-N-turn rollup, per-session rollup. The agent navigates the tree.

## Tokenization gotchas

The model doesn't see characters; it sees tokens. Watch out for:

- **Code is dense in tokens**. 1000 lines of TypeScript can easily be 15K tokens.
- **Whitespace counts**. Trailing whitespace, lots of indentation - all tokens.
- **Non-English languages** can use 2-3x more tokens per character.
- **JSON has structural overhead**. `{"name": "Alice"}` is more tokens than `name: Alice`.
- **Token counts vary per model**. GPT-4 and Claude use different tokenizers; the same text can be a different number of tokens.

When budgeting, count tokens with the **specific tokenizer** for your target model. Anthropic's [count-tokens API](https://docs.anthropic.com/en/api/messages-count-tokens) and OpenAI's `tiktoken` library both work for their respective models.

## A worked example

Suppose you're building a doc-Q&A bot. Per query:

```
system_prompt:        500 tokens (cached)
tool_definitions:     200 tokens (cached)
chat_history:       3,000 tokens (last 6 turns)
retrieved_chunks:   4,000 tokens (top 8 chunks of 500 tokens each)
user_message:          50 tokens
response:             400 tokens (output)
                  ----------
total:              8,150 tokens per call
```

At Claude 3.5 Sonnet pricing (~$3/M input, ~$15/M output):

- Input: 7,750 tokens × $3/M = $0.023
- Cached portion (700 tokens): $0.0007 instead of $0.0021. Small savings here, big across many users.
- Output: 400 tokens × $15/M = $0.006
- Per-call: ~$0.03

Now imagine you skipped retrieval and stuffed the full doc (200K tokens) into context. Same query becomes ~$0.60. 20x more expensive. And the answer often gets worse.

## Common mistakes

### Letting chat history grow forever
Without a strategy, every turn the context gets longer until you hit the limit and crash. Every chat-style app needs an answer for "what happens at turn 50?"

### Stuffing too much into RAG context
"More chunks = better answers" is wrong past a certain K. Pick the smallest K that still answers the question. 5-10 is usually right; 50 is rarely better than 10.

### Ignoring token budget for tool results
A tool returns the entire 500-row table. The model has to attend to all of it. Truncate or paginate at the tool layer.

### Counting characters instead of tokens
You'll be off by 25-50% and get surprising rejections.

### Forgetting that the response counts
A 50-token prompt that asks for a 50,000-token output still counts the 50K against the window.

## What to look at next

- **[LLM basics](./llm-basics.md)** - tokenization, attention, the foundation
- **[Prompt caching](./prompt-caching.md)** - dramatically reduces cost for stable-prefix prompts
- **[RAG explained](./rag-explained.md)** - the standard way to extend "what the model knows" without burning context
- **[Agentic loops](./agentic-loops.md)** - where context management gets really hard
