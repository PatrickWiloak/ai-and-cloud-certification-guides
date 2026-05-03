# LLM Basics

> **8-minute read.**

## The one-line answer

A large language model (LLM) is a neural network trained on a huge pile of text. Given some text as input, it predicts the next token, then the next, then the next. That's the entire trick. Everything else - chat, code, agents, RAG - is built on top of that one capability.

## What's actually happening

When you "ask ChatGPT a question," here's the sequence:

1. Your text gets chopped into **tokens** (roughly: word fragments).
2. The tokens get fed through a deep neural network (a transformer).
3. The model outputs a probability distribution over its entire vocabulary - "what's the most likely next token?"
4. One token is picked (deterministically or with some randomness).
5. That token is appended to the input, and the whole thing runs again.
6. Repeat until the model emits a stop token or hits a length limit.

So when you see streaming text appear word-by-word - that's literally what's happening internally. The model is generating one token at a time.

## Tokens, not words

Tokens are the unit of input and output. They are usually 2-5 characters but vary by language and content.

- "hello world" - 2 tokens
- "anthropomorphize" - 4 tokens
- An emoji - often 1-3 tokens
- Whitespace, punctuation - usually their own tokens

This matters because:
- **Context windows are measured in tokens, not words** (a 200K context window is roughly 150K English words)
- **You're billed per token** for API calls
- **Non-English languages cost more** because they tokenize less efficiently

Rough rule for English: **1 token ≈ 4 characters ≈ 0.75 words.**

## Context window

The context window is the maximum number of tokens the model can read at once - your prompt plus the response. Hit the limit and the oldest content gets dropped or the request fails.

| Model | Approximate context |
|-------|---------------------|
| GPT-3.5-turbo | 16K |
| GPT-4 | 8K-128K (varies) |
| Claude Sonnet 4.5 | 200K (1M in beta) |
| Gemini 1.5 Pro | 2M |

Bigger isn't always better. Larger contexts cost more, run slower, and the model's attention spreads thin - performance can actually degrade past a certain length even when it technically fits.

## Sampling: how the next token gets picked

The model outputs a probability for every token in its vocabulary (~100K tokens). Picking one is called **sampling**. The two main knobs:

### Temperature
A scalar that flattens or sharpens the probability distribution.
- **Temperature 0**: always pick the highest-probability token. Deterministic. Good for code generation, classification, anything where you want repeatable answers.
- **Temperature 1**: sample from the unmodified distribution. Default for most chat use.
- **Temperature >1**: amplify low-probability tokens. Output gets weirder and more creative. Past ~1.5 it usually goes off the rails.

### Top-p (nucleus sampling)
Only sample from the smallest set of tokens whose cumulative probability exceeds p.
- **top_p=0.1**: very conservative, only the top 10% of probability mass.
- **top_p=1.0**: consider all tokens.

You usually tune one or the other, not both. Temperature is more common.

## What LLMs are good at (and not)

### Good at
- **Pattern completion in language**: paraphrasing, summarizing, translating, expanding outlines
- **Code generation** (because code is structured language with lots of training examples)
- **Following instructions** in natural language
- **Surface-level reasoning**: short logic chains, simple math, basic structured output

### Not actually good at (despite seeming to be)
- **Math beyond a few steps**: they hallucinate digits in long arithmetic
- **Citing sources accurately**: they will invent URLs, paper titles, court cases
- **Knowing the cutoff**: the model has a training cutoff date and doesn't know what it doesn't know
- **Being internally consistent over long outputs**: they drift
- **Knowing for sure** when they're wrong: they sound just as confident either way

The fix for the second list: don't ask LLMs to be the source of truth. Pair them with retrieval (RAG), tools (function calling), or external verification (evals).

## Hallucination

The technical term for "the model said something convincing and false." It's not a bug - it's the same mechanism that produces the model's correct outputs. The model is always generating the most plausible next token; sometimes the most plausible thing is a real fact, sometimes it's a confident invention.

You reduce hallucination by:
- Grounding the model in retrieved documents (RAG)
- Letting the model say "I don't know" via prompt design
- Using tools so the model can look things up instead of guessing
- Validating outputs against external truth

You don't eliminate it.

## Open vs closed models

| Type | Examples | Tradeoffs |
|------|----------|-----------|
| **Closed/hosted** | Claude (Anthropic), GPT (OpenAI), Gemini (Google) | Strongest models, easiest API, your data leaves your environment |
| **Open weights** | Llama, Mistral, Qwen, DeepSeek | You can run them yourself, fine-tune freely, weaker on many tasks (gap is closing) |

"Open source" is fuzzy with LLMs - "open weights" is more accurate for most. Real open source means weights + training code + data, which is rare.

## What to look at next

- **[Transformer architecture](./transformer-architecture.md)** - the network that powers LLMs
- **[Prompt engineering](./prompt-engineering.md)** - how to talk to them effectively
- **[RAG explained](./rag-explained.md)** - giving them access to your data
- **[Evals for LLMs](./evals-for-llms.md)** - knowing if your LLM app actually works
- **[AI from Scratch](../ai-from-scratch.md)** - structured 8-phase path
