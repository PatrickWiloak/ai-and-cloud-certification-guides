# 01 - Prompt Fundamentals and Anatomy

A Claude prompt is not a single string. It is a structured artifact with layers, roles, and ordering choices that all affect output quality. This note covers the anatomy of an effective prompt and the underlying principles that make some prompts dramatically outperform others on the same task.

---

## What Is a Prompt

In the Messages API, a "prompt" is the combination of:

- The system field (persona, constraints, capabilities)
- Tool definitions (if any)
- The messages array (user / assistant turns)
- Sampling parameters (temperature, top_p)
- Optional features (extended thinking, prompt caching)

The model sees all of this as one composed input. Good prompts treat each layer deliberately.

---

## The Anatomy of a Strong Prompt

A typical production-grade prompt has these layers, in order:

1. System prompt
   - Role / persona
   - Background context that applies to every turn
   - Capabilities and constraints
   - Default behaviors (tone, length, format)

2. Tool definitions
   - For agents and structured-output use cases

3. Cached static content
   - Reference documentation
   - Few-shot examples
   - Domain glossary

4. Per-request context
   - Retrieved snippets (RAG)
   - Conversation history

5. User message
   - The actual task, clearly stated
   - Output format reminder if needed

Static layers stay stable; dynamic layers vary. This ordering also enables prompt caching.

---

## Be Clear and Direct

Anthropic's first prompting principle. Treat Claude like a thoughtful but new colleague.

Bad: "Make this better."
Better: "Rewrite this paragraph in a friendlier tone, keeping it under 80 words and preserving the technical accuracy."

The better version specifies:

- The action (rewrite)
- The dimension (tone)
- The constraint (under 80 words)
- The constraint to preserve (technical accuracy)

Specificity always beats brevity when quality matters.

---

## Specify the Output

Always state:

- Format (JSON, markdown, plain text, list, table)
- Length (sentences, words, tokens)
- Audience (executive, engineer, layperson)
- Tone (formal, friendly, terse)
- What NOT to include if relevant (no preamble, no explanations, no markdown)

Vague output specs cause inconsistent outputs across calls.

---

## Order Matters

Within a prompt, ordering signals priority. Claude pays slightly more attention to:

- The beginning of the prompt (system, opening of context)
- The end of the prompt (immediately before generation)

Practical implications:

- For long prompts, repeat the question or instruction at the end
- Place the most critical constraint at the top of the system prompt
- Avoid burying important content in the middle of long prompts

---

## Specify the Audience

"Explain Kubernetes to a CTO" produces a different response than "Explain Kubernetes to a junior developer." The model adjusts vocabulary, depth, and analogies. Use this lever.

---

## Constraints Without Negation

Where possible, prefer positive constraints over negative ones.

Less effective: "Do not be verbose. Do not include preambles. Do not use markdown."
More effective: "Respond in plain text in 2-3 sentences. Begin with the answer."

Positive constraints are easier for the model to follow and easier to verify.

---

## Format Consistency

If you ask for JSON, give an example of the exact JSON shape. If you ask for markdown, show the heading levels you want. Demonstration via example is more reliable than description.

---

## Length Control

Vague: "Be brief."
Specific: "Respond in 1-2 sentences." Or "Respond in 50-100 tokens."

For strict caps, set `max_tokens` appropriately and instruct Claude that the response will be truncated if too long.

---

## Worked Example - Before and After

Before:

```
"Summarize this document for me."
```

After:

```
System:
"You are a research analyst writing executive briefings."

User:
<document>
{long_document}
</document>

Write a summary of the document above.

Requirements:
- Audience: C-suite executive with no technical background
- Length: 3-4 short paragraphs
- Tone: factual, neutral
- Format: plain text, no headings, no bullet points
- Begin with the single most important finding in one sentence

Now write the summary.
```

The "after" version specifies role, audience, length, tone, format, and an opening structure. Quality improves predictably.

---

## Iterate, Do Not Guess

The right prompt for your task is rarely the first draft. Iteration with measurement (note 06) is the only reliable path to a great prompt.

---

## Anti-Patterns

- Single-sentence prompts for non-trivial tasks
- Stacking 5 vague constraints with no examples
- Asking Claude to "be creative" without dimensions
- Mixing persona, task, and format in one user message when the persona should be in system
- Treating prompts as static; never re-evaluating after model upgrades
- Cargo-culting techniques without measuring impact

---

## Exam Focus

- The structural layers of a prompt
- When to use system vs user messages
- Specificity over brevity on output specs
- Ordering effects in long prompts
- Positive vs negative constraint phrasing
