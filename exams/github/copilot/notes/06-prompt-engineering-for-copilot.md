# Prompt Engineering for Copilot

## Why Prompts Matter

Copilot's output quality depends heavily on what context it sees. Prompt engineering is the discipline of shaping that context, both through explicit chat messages and through the implicit signals in your editor (file names, comments, types, open tabs).

**[Prompt Engineering for Copilot](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)** - Official guide

## The 4 S's

GitHub's canonical framework for Copilot prompts.

### Single

Ask for one thing at a time. Prompts that combine multiple unrelated asks produce confused output.

Bad:
```
Write a REST API, deploy it to AWS, and add monitoring.
```

Good:
```
Write a Flask route that accepts a POST with a JSON body and returns a 201 with an id.
```

### Specific

Include concrete names, types, constraints, inputs, and expected outputs.

Bad:
```
Parse the data.
```

Good:
```
Parse this CSV string into a list of Dict[str, str]. Handle quoted fields with commas. Skip blank lines.
```

### Short

Do not over-prompt. Break the task into smaller prompts when possible. Iteratively refine.

### Surround

Use the context around the cursor. Open related files. Place types, imports, or comments near where Copilot will produce output.

## Comments and Signatures as Prompts

Inline completions respond well to:
- A descriptive function name
- A one-line comment above the cursor
- A docstring explaining intent, inputs, and outputs
- A type signature

Example (Python):

```python
def slugify(title: str) -> str:
    """Convert a title to a URL-safe slug.
    - Lowercase
    - Replace non-alphanumeric characters with hyphens
    - Collapse consecutive hyphens
    - Strip leading/trailing hyphens
    """
    # Copilot ghost text will implement this
```

## Neighboring Tabs as Context

Copilot peeks at open tabs. Open the module with your type definitions or interfaces before editing a new file. This is especially effective for:

- Implementing a route that calls a service whose types are defined in another file
- Writing tests for a function whose source is in another file
- Replicating a pattern from an existing module

## Prompting Patterns

### Zero-shot

Ask once without examples. Works when the task is well-known.

```
Write a TypeScript function that debounces another function by N milliseconds.
```

### One-shot

Provide a single example of the desired output.

```
Here is one entry:
{ "id": "u_123", "email": "a@b.com" }
Write a Zod schema that validates this shape.
```

### Few-shot

Provide several examples to illustrate a pattern.

```
Convert date strings to ISO:
"Jan 3, 2024" -> "2024-01-03"
"December 31, 1999" -> "1999-12-31"
"2/14/2021"   -> "2021-02-14"

Write a function that does this.
```

### Chain-of-thought

For complex tasks, ask Copilot to reason step by step.

```
I need to migrate this SQL query to a NoSQL document model. Walk through the steps, then write the final code.
```

## Iterative Refinement in Chat

Start rough, refine.

```
User: Write a function to retry a network call.
Copilot: (provides a basic retry with fixed delay)
User: Add exponential backoff with jitter.
Copilot: (updates)
User: Cap the total wait time at 30 seconds and surface the last error.
Copilot: (produces final version)
```

## Using Context Variables Well

- `#file` - Attach a file you want Copilot to consider
- `#selection` - Use the current selection explicitly
- `#codebase` - Let Copilot search the repo for relevant snippets
- `#terminalLastCommand` - Reference the last shell command and its output

Combine with slash commands:

```
/tests #selection using pytest and parameterization
```

## Slash Command Prompt Patterns

### `/explain`

Good for: new codebases, tricky regex, complex types.

```
/explain #selection
```

### `/fix`

Good for: failing tests, compile errors, lint warnings.

```
/fix TypeError at line 42 of #file:service.ts
```

### `/tests`

Good for: generating tests for a selection. Be explicit about framework.

```
/tests #selection using Jest, mock the HTTP client
```

### `/doc`

Good for: docstrings, inline comments, README sections.

```
/doc #selection in Google style
```

### `/new`

Good for: scaffolding new projects or files.

```
/new a FastAPI project with SQLAlchemy, Alembic, pytest, and Dockerfile
```

## Language-Specific Tips

### Python

- Use type hints; Copilot leans on them heavily
- Write a docstring with Args, Returns, Raises
- Import the specific library you want (requests vs httpx vs urllib)

### JavaScript/TypeScript

- Write interfaces/types first, then ask for implementation
- Specify framework (Next.js, Express, Fastify) in comments
- Use JSDoc blocks for parameter hints

### Go

- Write the function signature including error return
- Use package-level constants and types to anchor suggestions

### Shell

- Use `gh copilot suggest` rather than fighting completions in a text editor
- Describe the OS (GNU vs BSD) if tooling differs

## Anti-Patterns

- Overly vague prompts ("make this better")
- Multi-goal prompts ("refactor, optimize, document, test")
- Missing context (no types, no imports, no docstring)
- Copying and pasting logs without structure
- Ignoring failures; instead, feed the error back into `/fix`

## Red Flags in AI Output

- Hallucinated function names; verify imports exist
- Outdated APIs; check the library version
- Insecure defaults; review crypto, auth, input handling
- Silently swallowed errors; ensure tests cover failure paths
- Untested edge cases; request tests with `/tests`

## Key Exam Facts

- The 4 S's: Single, Specific, Short, Surround
- Neighboring tabs and the current selection are strong implicit context
- Slash commands steer chat; agents scope chat; context variables attach data
- Iterative refinement in chat is a supported pattern; don't re-prompt from scratch
- Human review is required; prompt engineering helps but does not remove responsibility

## Study Checklist

- [ ] I can recite and explain the 4 S's
- [ ] I can turn a vague prompt into a specific, single-goal prompt
- [ ] I know which slash commands fit which tasks
- [ ] I can combine `#selection` and `/tests` effectively
- [ ] I can describe three red flags to check in AI output
