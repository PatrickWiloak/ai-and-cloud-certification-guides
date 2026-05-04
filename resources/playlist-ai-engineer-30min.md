---
last-updated: 2026-05-03
---

# Playlist - AI engineer, 30 minutes

Six concept pages in order, total ~30 minutes. By the end you have working mental models for: how LLMs predict the next token, how you give them access to your data, how you give them tools, and how you wire that into a working agent.

## The reads, in order

1. **[LLM basics](../learn/concepts/llm-basics.md)** (~5 min)
   What an LLM is, tokenization, the next-token-prediction loop. Foundation for everything else.

2. **[Embeddings and vector search](../learn/concepts/embeddings-and-vector-search.md)** (~5 min)
   How meaning becomes a vector and how nearest-neighbor search lets you "find similar things." Required before RAG makes sense.

3. **[RAG explained](../learn/concepts/rag-explained.md)** (~5 min)
   The workhorse pattern: retrieve relevant chunks → put them in the prompt → answer. Why RAG beats fine-tuning for "give the model access to my data."

4. **[Tool use and function calling](../learn/concepts/tool-use-and-function-calling.md)** (~5 min)
   How the model returns structured JSON that your code dispatches as a tool call. The mechanism under every agent.

5. **[MCP explained](../learn/concepts/mcp-explained.md)** (~3 min)
   The standard tool interface that decouples agents from server implementations. Why this matters in 2026.

6. **[Agentic loops](../learn/concepts/agentic-loops.md)** (~7 min)
   The runtime that turns tools + a model into an agent: take output, execute tools, feed back, repeat. Where most production engineering lives.

## What you can do after this playlist

- Articulate the difference between RAG, fine-tuning, and prompting, and pick the right tool for a problem.
- Sketch the architecture of a Claude / GPT agent that reads files, queries a database, and answers natural-language questions.
- Discuss why MCP exists and what problem it solves.
- Recognize when to reach for an agent vs a single LLM call.

## Next steps after this 30-minute foundation

**If you want to build:**
- [Build a RAG pipeline](./hands-on-projects/build-rag-pipeline.md) - end-to-end with pgvector + Claude (~30 min)
- [Build a Claude agent with MCP](./hands-on-projects/build-claude-agent-with-mcp.md) - tool-using agent with custom MCP server (~30 min)

**If you want to go deeper:**
- [Evals for LLMs](../learn/concepts/evals-for-llms.md) - the regression test for LLM apps
- [Context windows and management](../learn/concepts/context-windows-and-management.md) - the operational reality of agent context
- [Prompt caching](../learn/concepts/prompt-caching.md) - cost optimization for stable-prefix prompts
- [Inference servers](../learn/concepts/inference-servers.md) - if you're going to self-host

**If you want a cert:**
- [AI/ML systems topic index](../topics/ai-ml-systems.md) - all relevant certs grouped by tier
- [LLMs and GenAI topic index](../topics/llms-and-genai.md)

## Related playlists

- [Cloud security in 1 hour](./playlist-cloud-security-1hour.md)
- [Data engineer in 1 hour](./playlist-data-engineer-1hour.md)
- [SRE in 1 hour](./playlist-sre-1hour.md)
