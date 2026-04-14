# Copilot Fundamentals

## What GitHub Copilot Is

GitHub Copilot is an AI-powered developer assistant that helps write, review, test, and explain code. It combines inline code completions, conversational chat, CLI assistance, and repository-aware tooling across IDEs, github.com, GitHub Mobile, and the shell.

Copilot runs on large language models hosted on Microsoft Azure by GitHub. Requests are sent from the user's IDE or browser to a GitHub-owned proxy, which handles authentication, telemetry, policy enforcement, and calls the appropriate model provider.

**[What is Copilot](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)** - Official introduction
**[Copilot features map](https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features)** - Feature reference

## The Model Stack

The underlying models evolve over time. At the time of writing, Copilot uses multiple providers:

- **OpenAI** - GPT-4o, o-series, Codex-family for completions
- **Anthropic** - Claude 3.5 Sonnet (selectable in chat where eligible)
- **Google** - Gemini (selectable where available)

Not all models are available on all plans. Some models are labeled premium requests and consume monthly allotment on Pro/Pro+/Business/Enterprise.

### Model Selection

On supported surfaces the chat UI has a model picker. Users can pick the model that best fits the task. Defaults are set by GitHub and may be overridden by organization policy in Business and Enterprise.

## Copilot Product Family

| Product | Audience | Notes |
|---------|----------|-------|
| Copilot Free | Individual trial and casual users | Monthly caps on completions and chat; limited premium requests |
| Copilot Pro | Paid individual | Unlimited completions; chat; model choice |
| Copilot Pro+ | Power user | Higher premium request limits; access to more models |
| Copilot Business | Organizations | Admin controls, content exclusions, audit logs, IP indemnity |
| Copilot Enterprise | Enterprise Cloud customers | All Business features plus knowledge bases, PR summaries, Copilot code review, custom models |

**[Plans for Copilot](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot)** - Plan comparison

### Feature Matrix at a Glance

| Feature | Free | Pro | Business | Enterprise |
|---------|------|-----|----------|------------|
| Inline completions | Limited | Yes | Yes | Yes |
| Chat in IDE and github.com | Limited | Yes | Yes | Yes |
| Model selection | Some | Yes | Yes | Yes |
| Duplicate detection filter | User | User | Admin | Admin |
| Content exclusions | No | No | Yes | Yes |
| Audit log events | No | No | Yes | Yes |
| IP indemnity | No | No | Yes | Yes |
| PR summaries | No | No | No | Yes |
| Knowledge bases | No | No | No | Yes |
| Custom models (preview) | No | No | No | Yes |

## Where Copilot Runs

### IDEs
- **Visual Studio Code** - First-class; most features land here first
- **Visual Studio 2022+** - Full chat and completions
- **JetBrains IDEs** - IntelliJ, PyCharm, GoLand, WebStorm, Rider, RubyMine, and more
- **Neovim** - Completions and chat plugin
- **Xcode** - Completions and chat
- **Eclipse** - Completions and chat
- **Azure Data Studio** - Completions

### Browser and Mobile
- **github.com** - Chat (general and repo-aware), PR summaries, code review suggestions
- **GitHub Mobile** - iOS and Android chat

### CLI
- `gh extension install github/gh-copilot`
- `gh copilot suggest` - Natural language to command
- `gh copilot explain` - Explain a command

## The Three Core Interactions

### 1. Inline Completions (Ghost Text)

Copilot predicts the next code as you type. The suggestion appears as gray ghost text. Keyboard interactions include:

| Action | VS Code Shortcut |
|--------|------------------|
| Accept full suggestion | Tab |
| Accept next word | Ctrl+Right (Cmd+Right) |
| Next suggestion | Alt+] |
| Previous suggestion | Alt+[ |
| Dismiss | Esc |
| Open suggestions panel | Ctrl+Enter |

### 2. Copilot Chat

Conversational assistant that can reason across files, explain code, refactor, generate tests, and scaffold projects. Available in IDEs, github.com, and Mobile.

### 3. CLI Assistant

`gh copilot` provides terminal-grade help for shell, Git, and the gh CLI.

## Supported Languages

Copilot supports many programming languages. Quality is highest for languages with large public training corpora:

- Python, JavaScript, TypeScript
- Go, Ruby, Java, Kotlin
- C, C++, C#
- Rust, Swift, PHP
- Shell (Bash/Zsh), YAML, HCL/Terraform
- SQL, HTML, CSS

Quality is lower for niche or proprietary languages and for very new framework versions that post-date training cutoff.

## Context Collection

Copilot's suggestions depend heavily on context:

- **Current file** - Buffer around the cursor
- **Other open tabs** - Recently viewed files in the editor
- **Imports and types** - Help anchor suggestions to the right APIs
- **Cursor position** - The completion target
- **Chat attachments** - Explicit `#file`, `#selection`, `#codebase` references

Context excluded by content exclusion rules is removed from these inputs.

## Copilot Trust Center Highlights

- Prompts and suggestions are encrypted in transit
- Business and Enterprise: no retention of prompts and suggestions, no use for training
- Individual: opt-in or opt-out to training data usage
- The proxy performs policy enforcement, including content exclusion and duplicate detection

**[Copilot Trust Center](https://resources.github.com/copilot-trust-center/)** - Security and privacy

## Seat Management and Billing

- Seats are assigned to specific users by org or enterprise admins
- Users activate assigned seats by accepting the invitation
- Seat assignment events appear in the audit log
- Unassignment behavior depends on the billing cycle and plan
- Utilization and last-activity reports help manage seat efficiency

## Key Exam Facts

- Copilot Business is the minimum plan for content exclusions, audit logs, and IP indemnity
- Copilot Enterprise adds knowledge bases, PR summaries, Copilot code review, and custom models
- Duplicate detection filter blocks suggestions matching ~150 characters of public code
- IP indemnity requires Business/Enterprise AND duplicate detection enabled
- `gh copilot` requires installing the gh-copilot extension

## Study Checklist

- [ ] I can list all Copilot SKUs and one differentiator for each
- [ ] I can name the IDEs Copilot supports
- [ ] I can describe the three core interactions
- [ ] I know where duplicate detection and content exclusions live
- [ ] I understand the difference between Business and Enterprise features
