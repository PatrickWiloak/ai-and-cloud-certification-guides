# 05 - Few-Shot and Example-Driven Prompting

Examples are often the highest-leverage thing you can add to a prompt. They demonstrate format, behavior, and judgment in a way instructions cannot. This note covers few-shot and many-shot prompting, example selection, ordering, and counter-examples.

---

## Why Examples Work

Claude is a strong pattern matcher. Instructions describe what you want; examples demonstrate it. When Claude sees 3-5 examples of input/output pairs, it generalizes the pattern reliably to new inputs.

For tasks like:

- Format matching (specific JSON shape, specific tone)
- Subjective judgment (when to escalate, what counts as "good")
- Edge case handling (sarcasm, ambiguity)
- Domain conventions (legal phrasing, medical terminology)

examples beat instructions almost always.

---

## How Many Examples

- 0 (zero-shot): default; Claude often does well without examples
- 2-5 (few-shot): standard for production
- 8-20+ (many-shot): for nuanced tasks where 5 is not enough

Add examples until quality plateaus. Beyond that, you spend tokens for no gain.

---

## Example Quality

Bad: 5 nearly identical examples.
Good: 5 examples covering the input distribution:

- Easy / typical case
- Harder / less obvious case
- Edge case (ambiguous, unusual input)
- Counter-example (what NOT to do)
- Domain-specific quirk

Diverse examples teach Claude to generalize. Redundant examples narrow behavior.

---

## Example Format

Wrap examples in XML tags for clarity:

```
<examples>
<example>
<input>I love this product, it changed my life!</input>
<sentiment>positive</sentiment>
</example>
<example>
<input>Eh, it works I guess.</input>
<sentiment>neutral</sentiment>
</example>
<example>
<input>Total waste of money.</input>
<sentiment>negative</sentiment>
</example>
</examples>
```

Format examples consistently with the format you want Claude to use. Inconsistency between example and ask format produces inconsistent outputs.

---

## Example Selection

For static prompts: hand-pick examples that span the input space.

For dynamic systems: retrieve examples per request from an examples library, possibly using a vector store keyed on input similarity. This dynamic few-shot pattern can outperform static examples on diverse inputs.

---

## Example Ordering

Order matters slightly:

- Place easier examples first, harder later (gradient of difficulty)
- Or place examples in the order most similar to the current input last
- For balanced classification, alternate classes to avoid frequency bias

Test ordering with your eval set; the right order is task-dependent.

---

## Counter-Examples

Showing what NOT to do can be powerful:

```
<example>
<input>The contract expires on Jan 1.</input>
<bad_output>I cannot answer questions about contracts.</bad_output>
<reason_bad>The user asked a factual question, not for legal advice.</reason_bad>
<good_output>The contract expires on January 1.</good_output>
</example>
```

Use sparingly. Counter-examples carry weight; too many can shift Claude toward the "bad" pattern as a baseline. Keep good-to-bad ratio at least 2:1.

---

## Many-Shot Prompting

For nuanced tasks (subtle classification, complex extraction), many-shot (10-50+ examples) can outperform few-shot meaningfully. Costs more tokens; combine with prompt caching to amortize.

Pattern:

- Cache the example block as a static prefix
- Vary only the user input per request
- Cache TTL fits your traffic profile

Many-shot + caching is one of the highest-leverage combinations for repeatable workloads.

---

## Examples Beat Instructions for Format

If you want a specific output format:

Less effective:

```
"Respond with a JSON object containing 'name' and 'score'."
```

More effective:

```
"Respond with a JSON object containing 'name' and 'score'.

Example:
{"name": "Acme Corp", "score": 87}"
```

The example anchors the format reliably. The instruction alone allows for "Here is the JSON: { ... }" preambles.

---

## Examples for Behavior, Not Just Format

Examples can teach behavior:

- When to escalate vs respond
- How to handle missing information
- When to ask a clarifying question
- How verbose to be in different contexts

Example pattern:

```
<example>
<situation>User reports a billing issue with insufficient detail.</situation>
<correct_response>Ask for the invoice number and the date of the discrepancy before answering.</correct_response>
</example>
```

---

## Examples in System vs User Prompt

Either works. Tradeoffs:

- System: stable, cacheable, applies to every turn
- User: per-request, customizable

For most apps, place static example libraries in the system prompt (cached). Dynamic per-request examples can go in the user message.

---

## Worked Example - Sentiment Classifier

```
System:
You classify product reviews as positive, negative, or neutral.

<examples>
<example>
<review>This is the best thing I've ever bought!</review>
<sentiment>positive</sentiment>
</example>
<example>
<review>Total disaster, broke immediately.</review>
<sentiment>negative</sentiment>
</example>
<example>
<review>It's fine, does the job.</review>
<sentiment>neutral</sentiment>
</example>
<example>
<review>Wow, I'm so impressed by how quickly this stopped working. /sarcasm</review>
<sentiment>negative</sentiment>
</example>
</examples>

Classify the next review.

User:
<review>Five stars! ...just kidding, it's terrible.</review>
```

The sarcasm-handling example teaches Claude to detect sarcasm.

---

## Anti-Patterns

- Five identical examples
- Examples that mismatch the requested format
- Counter-examples that outnumber good examples
- Examples buried at the end of long prompts
- Static examples for highly variable input distributions
- No examples on tasks that are clearly format-sensitive

---

## Exam Focus

- Few-shot vs many-shot tradeoffs
- Example diversity vs quantity
- XML structure for examples
- Counter-example pitfalls
- Examples + caching pattern
- Examples beat instructions for format
