# GitHub Copilot Certification Fact Sheet

## Exam Overview

**Exam Name:** GitHub Copilot
**Duration:** 90 minutes
**Questions:** ~65 multiple choice and multiple response
**Passing Score:** 70%
**Cost:** $99 USD
**Delivery:** Online proctored (PSI)
**Prerequisites:** None (Git and IDE familiarity recommended)
**Validity:** 2 years

**[Official Exam Page](https://resources.github.com/learn/certifications/)** - Registration and details
**[GitHub Copilot Documentation](https://docs.github.com/en/copilot)** - Product docs
**[Copilot Trust Center](https://resources.github.com/copilot-trust-center/)** - Privacy and security

## Target Audience

- Software developers using AI-assisted coding tools
- Team leads evaluating Copilot for adoption
- DevOps and platform engineers integrating Copilot into workflows
- Administrators responsible for Copilot Business or Enterprise rollout
- Technical consultants advising clients on AI tooling

## Domain 1: Introduction to GitHub Copilot (20%)

### What Copilot Is

GitHub Copilot is an AI pair programmer that provides code completions, chat-based assistance, pull request support, and CLI help. It is built on large language models hosted by GitHub on Azure, routed through a GitHub-owned proxy service.

**Models in use (subject to change):**
- OpenAI GPT-4o, o1 family, Codex derivatives for completions
- Anthropic Claude 3.5 Sonnet (selectable in chat for eligible customers)
- Google Gemini (selectable where available)

**[About Copilot](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)** - Product introduction
**[Copilot Features](https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features)** - Feature map

### Copilot Product Family

| Product | Audience | Key Features |
|---------|----------|--------------|
| Copilot Free | Individual users, trial | Limited completions and chat per month |
| Copilot Pro (Individual) | Individual paid users | Unlimited completions, chat, model choice |
| Copilot Pro+ | Power users | Higher premium request limits, all models |
| Copilot Business | Organizations | Policy controls, content exclusions, audit logs, IP indemnity |
| Copilot Enterprise | Large orgs on Enterprise Cloud | Everything in Business plus knowledge bases, PR summaries, custom models |

**[Copilot Plans](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot)** - Plan comparison

### Supported Languages and IDEs

- Best quality on languages with large public training corpora: Python, JavaScript, TypeScript, Go, Ruby, Java, C#, C, C++, Rust, PHP
- First-class IDE support: VS Code, Visual Studio, JetBrains family, Neovim, Xcode, Eclipse, Azure Data Studio
- Surfaces: IDE inline, IDE chat, GitHub.com chat, GitHub Mobile, CLI (gh copilot), PR review

## Domain 2: Responsible Use of GitHub Copilot (15%)

### Limitations to Communicate

- Suggestions can be incorrect, outdated, insecure, or biased
- Training data has a cutoff; very new APIs may be missing or wrong
- Copilot does not know private code unless it is part of the current context (or an Enterprise knowledge base)
- Suggestions can match public code; the duplicate detection filter mitigates this

**[Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot)** - Official guidance

### Duplicate Detection Filter

- Blocks suggestions that match ~150 characters of public code on GitHub
- Configurable at org/enterprise (Business and Enterprise plans)
- Required to be enabled for IP indemnification to apply
- Available to Individual users as a personal setting

### Content Exclusions

- Path-based rules that prevent files from being used as context and suppress suggestions inside excluded files
- Scoped at repository, organization, or enterprise level
- Applied to both completions and chat
- Do not apply to public code or code already submitted to Copilot

**[Content Exclusions](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization/excluding-content-from-github-copilot)** - Exclusion setup

### Data Handling

- Prompts, suggestions, and telemetry behavior depends on plan and settings
- Business and Enterprise: prompts and suggestions are not retained or used to train models
- Individual: user can opt in or out of training on prompts
- Data is encrypted in transit; the proxy strips prompts after response in Business/Enterprise

## Domain 3: Copilot Plans and Features (15%)

### Feature Matrix

| Feature | Free | Pro | Business | Enterprise |
|---------|------|-----|----------|------------|
| Code completions | Limited | Unlimited | Unlimited | Unlimited |
| Chat in IDE | Limited | Yes | Yes | Yes |
| Chat on GitHub.com | Limited | Yes | Yes | Yes |
| Model selection | No | Yes | Yes | Yes |
| Duplicate detection policy | User | User | Admin | Admin |
| Content exclusions | No | No | Yes | Yes |
| IP indemnification | No | No | Yes | Yes |
| Audit logs | No | No | Yes | Yes |
| PR summaries | No | No | No | Yes |
| Knowledge bases | No | No | No | Yes |
| Custom models (preview) | No | No | No | Yes |

**[Plans for Copilot](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot)** - Detailed comparison

### Billing and Seats

- Seats are assigned per user by org or enterprise admins
- Unassigning mid-cycle may or may not refund depending on billing cycle
- Seat utilization can be tracked via API and org insights
- Enterprise accounts can enable Copilot for specific orgs or all orgs

## Domain 4: Using GitHub Copilot (25%)

### Inline Completions (Ghost Text)

| Action | Shortcut (VS Code) |
|--------|--------------------|
| Accept full suggestion | Tab |
| Accept next word | Ctrl+Right (Cmd+Right) |
| Next suggestion | Alt+] |
| Previous suggestion | Alt+[ |
| Dismiss | Esc |
| Open suggestions panel | Ctrl+Enter |

### Copilot Chat Surfaces

- **Inline chat** - Invoked at the cursor (Ctrl+I)
- **Chat view/panel** - Persistent side panel
- **Quick chat** - Floating input for quick questions
- **Chat on GitHub.com** - Repo-aware chat on github.com
- **Chat in Mobile** - Conversational on iOS and Android

### Slash Commands (Chat)

| Command | Purpose |
|---------|---------|
| `/explain` | Explain selected code or concept |
| `/fix` | Propose a fix for a problem |
| `/tests` | Generate tests for selection |
| `/doc` | Generate documentation comments |
| `/new` | Scaffold a new project or workspace |
| `/clear` | Clear chat context |
| `/help` | List chat commands |

**[Chat Cheat Sheet](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat-in-ides/github-copilot-chat-cheat-sheet)** - Chat reference

### Agents and Context Variables

| Agent / Variable | Purpose |
|------------------|---------|
| `@workspace` | Whole repo context (VS Code) |
| `@vscode` | Questions about VS Code itself |
| `@terminal` | Shell/terminal help |
| `@github` | GitHub-hosted data (issues, PRs, repo) |
| `#file` | Attach a file as context |
| `#selection` | Use current selection |
| `#codebase` | Broad codebase search |
| `#terminalLastCommand` | Reference last terminal command |

### Copilot in the CLI

- Install: `gh extension install github/gh-copilot`
- `gh copilot suggest "how to tar a directory"` - Suggests shell, git, or gh commands
- `gh copilot explain "grep -rni error ."` - Explains a command

### Pull Requests

- **PR summaries (Enterprise)** - Auto-generated PR descriptions
- **Code review** - Copilot can be requested as a reviewer on PRs in eligible plans
- **Commit message generation** - From IDE source control

## Domain 5: Prompt Engineering for Copilot (10%)

### The 4 S's

1. **Single** - One intent per prompt
2. **Specific** - Clear names, types, signatures, inputs, outputs
3. **Short** - Concise prompts; refine iteratively
4. **Surround** - Use neighboring code, open tabs, and comments as context

### Prompt Patterns

- **Zero-shot** - Ask once with clear intent
- **One-shot** - Include one example of the desired output
- **Few-shot** - Provide several examples
- **Chain prompting** - Build up context with follow-ups in chat

### Practical Techniques

- Write a descriptive function signature and docstring before asking for the body
- Keep related files open in tabs so Copilot can draw context
- Use types, schemas, and imports to anchor the prompt
- For refactors, explain the current behavior and the desired behavior

**[Prompt Engineering for Copilot](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)** - Official guide

## Domain 6: Developer Use Cases (15%)

### Core Use Cases

- New code generation from comments and signatures
- Test generation (unit, integration, property)
- Refactoring and rename suggestions
- Documentation (README, inline, API)
- Learning unfamiliar frameworks (ask Copilot to explain)
- Code review assistance and PR summaries
- DevOps: Dockerfile, GitHub Actions YAML, Terraform, Bash

### Regulated and Sensitive Scenarios

- Use content exclusions for secrets, license-sensitive code, regulated data
- Enable duplicate detection to reduce public code matches
- Turn off Copilot in repos where prohibited by policy via org settings

## Exam Tips

### High-Priority Topics (by weight)
1. Using Copilot (25%) - slash commands, agents, context, keyboard shortcuts
2. Introduction to Copilot (20%) - plans, models, features, surfaces
3. Responsible Use (15%) - duplicate detection, content exclusions, IP indemnity
4. Plans and Features (15%) - feature matrix per plan
5. Developer Use Cases (15%) - real-world patterns
6. Prompt Engineering (10%) - 4 S's, zero/one/few-shot

### Key Differentiators to Remember
- Duplicate detection blocks matches to public code; content exclusions block files from context
- IP indemnity requires Business/Enterprise plus duplicate detection enabled
- Knowledge bases and PR summaries are Enterprise-only
- `@workspace` is VS Code; `@github` talks to GitHub.com data
- Individual plan users can opt their prompts into training; Business/Enterprise prompts are not used for training
