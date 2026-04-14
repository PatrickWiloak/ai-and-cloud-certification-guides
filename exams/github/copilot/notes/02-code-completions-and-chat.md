# Code Completions and Chat

## Inline Code Completions

Inline completions are Copilot's most recognizable feature. The IDE sends context to Copilot and displays the model's best guess as ghost text ahead of the cursor.

### Acceptance Controls

| Action | VS Code | JetBrains | Visual Studio |
|--------|---------|-----------|---------------|
| Accept all | Tab | Tab | Tab |
| Accept next word | Ctrl+Right | Tab-partial | Ctrl+Right |
| Next suggestion | Alt+] | Alt+] | Alt+. |
| Previous suggestion | Alt+[ | Alt+[ | Alt+, |
| Dismiss | Esc | Esc | Esc |
| Open suggestions panel | Ctrl+Enter | Ctrl+Enter | (no panel) |

The suggestions panel opens multiple options in a side-by-side view, useful when the first suggestion is not what you want.

### How Completions Build Context

The IDE gathers context including:
- The current file and cursor location
- Nearby symbols and types
- Recently opened tabs (neighboring context)
- Comments, docstrings, and function signatures above the cursor

### Improving Completion Quality

- Open related files in adjacent tabs so their content informs suggestions
- Write a descriptive function name and a docstring before the body
- Add imports and type annotations to anchor the output language/framework
- Break large changes into smaller steps so each suggestion is easier to predict

**[Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)** - Official guidance

## Copilot Chat Overview

Copilot Chat is the conversational interface to Copilot. It can explain, generate, refactor, test, and document. It runs inside IDEs, on github.com, in GitHub Mobile, and in the CLI.

### Chat Surfaces in VS Code

- **Chat View (panel)** - Persistent side panel with history
- **Inline Chat** - At the cursor; press Ctrl+I
- **Quick Chat** - Floating input for quick questions
- **Terminal Chat** - Ctrl+I inside the integrated terminal

### Chat Surfaces on GitHub.com

- **Copilot Chat button** - Opens a chat panel
- **Repo-aware chat** - When on a repo page, chat can reason about that repo
- **Issue and PR context** - Chat can answer questions about the current issue or PR

**[Chat in IDEs](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat-in-ides/asking-github-copilot-questions-in-your-ide)** - Chat docs

## Slash Commands

Slash commands steer chat to a specific task.

| Command | Purpose |
|---------|---------|
| `/explain` | Explain selected code or a concept |
| `/fix` | Diagnose and propose a fix |
| `/tests` | Generate unit tests for a selection |
| `/doc` | Generate documentation comments |
| `/new` | Scaffold a new file or project |
| `/newNotebook` | Scaffold a new Jupyter notebook |
| `/help` | Show available commands |
| `/clear` | Clear conversation context |

Slash commands vary by IDE; check the command palette for the full list.

## Agents and Participants

Agents route the request to a specialized assistant.

| Agent | Purpose |
|-------|---------|
| `@workspace` | Use the whole repo/workspace as context (VS Code) |
| `@vscode` | Answer questions about VS Code itself |
| `@terminal` | Help with shell and terminal commands |
| `@github` | Query GitHub.com data (issues, PRs, repos) |

Extensions installed from the Copilot Extensions marketplace can add custom agents.

## Context Variables

Context variables explicitly attach files or state to the prompt.

| Variable | Purpose |
|----------|---------|
| `#file` | Attach a specific file |
| `#selection` | Include current editor selection |
| `#codebase` | Broad codebase search for relevant snippets |
| `#terminalLastCommand` | Include last terminal command/output |
| `#terminalSelection` | Include selected terminal text |
| `#editor` | Full active editor content |
| `#web` | Include web content (where enabled) |

## Prompt Patterns in Chat

### Zero-shot

```
Generate a Python function that returns the Fibonacci sequence up to n.
```

### One-shot

```
Given this input/output example, write the function:
Input: "hello world"
Output: "HelloWorld"
```

### Few-shot

```
Here are three examples of slugified titles. Write the slugify function.
- "My First Post" -> "my-first-post"
- "Hello, World!" -> "hello-world"
- "  spaced  " -> "spaced"
```

### Iterative Refinement

Start with a rough prompt, then follow up with corrections:
1. "Write a function that parses CSV."
2. "Handle quoted fields with embedded commas."
3. "Return an iterator, not a list, to support large files."

## Chat on GitHub.com

### Repo Chat

On any repository page, open Copilot Chat to ask:
- "What does this repo do?"
- "Where is authentication implemented?"
- "Summarize the changes in the last 10 commits."

### Issue and PR Context

Open an issue or PR and chat becomes context-aware:
- "Summarize this PR for a reviewer."
- "What files are affected?"
- "Explain the failure in this check."

## Copilot Code Review (Enterprise)

Copilot can be requested as a reviewer on a pull request. It produces comments and suggestions inline, similar to a human reviewer. This is an Enterprise feature.

**[Copilot Code Review](https://docs.github.com/en/copilot/using-github-copilot/code-review/using-copilot-code-review)** - Review feature

## PR Summaries (Enterprise)

Copilot can draft a pull request description using the diff as context. Admins enable this at the org level.

## Commit Message Generation

In the IDE source control panel, click the sparkle icon to let Copilot draft a commit message for staged changes.

## Key Exam Facts

- Tab accepts the current suggestion; Alt+] / Alt+[ cycle alternatives
- `/explain`, `/fix`, `/tests`, `/doc`, `/new` are the core slash commands
- `@workspace` is IDE repo scope; `@github` queries GitHub.com data
- Context variables start with `#` and attach files/selection/codebase
- Chat model selection is available on Pro and above
- PR summaries and Copilot code review are Enterprise features

## Study Checklist

- [ ] I can list the top five slash commands and what each does
- [ ] I can list four agents and when to use each
- [ ] I know the keyboard shortcuts for accepting and cycling suggestions
- [ ] I can describe three ways to attach context with `#` variables
- [ ] I can explain zero-shot, one-shot, and few-shot prompts in chat
