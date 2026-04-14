# IDE Integration and Workflows

## Supported Editors

Copilot ships official extensions or plugins for the following environments.

| Editor | Extension/Plugin | Notes |
|--------|------------------|-------|
| Visual Studio Code | GitHub Copilot and GitHub Copilot Chat | First-class; gets features earliest |
| Visual Studio 2022+ | GitHub Copilot | Installed via VS Installer |
| JetBrains IDEs | GitHub Copilot plugin | IntelliJ, PyCharm, GoLand, WebStorm, Rider, etc. |
| Neovim | copilot.vim and CopilotChat.nvim | Completions and chat |
| Xcode | GitHub Copilot for Xcode | Completions and chat |
| Eclipse | GitHub Copilot | Completions and chat |
| Azure Data Studio | GitHub Copilot | Completions for SQL |

**[Setup in your IDE](https://docs.github.com/en/copilot/configuring-github-copilot/installing-the-github-copilot-extension-in-your-environment)** - Installation guide

## Installation Flow

General steps (VS Code shown):

1. Install the **GitHub Copilot** extension
2. Install the **GitHub Copilot Chat** extension
3. Sign in to GitHub in the editor
4. Authorize the extension to access your GitHub account
5. Verify a seat is assigned (Free, Pro, Business, or Enterprise)

## VS Code Feature Map

- **Ghost text** for completions in any supported language
- **Chat view** in the primary side bar
- **Inline chat** at the cursor (Ctrl+I)
- **Terminal chat** in the integrated terminal (Ctrl+I)
- **Quick chat** - Ctrl+Shift+I
- **Agents** - `@workspace`, `@vscode`, `@terminal`, `@github`
- **Context variables** - `#file`, `#selection`, `#codebase`, `#web`
- **Commands** via Command Palette: "Copilot: ..."
- **Source Control** - generate commit message icon

## JetBrains Feature Map

- Completions while typing
- Chat tool window
- Inline chat via editor context menu
- Slash commands and agents similar to VS Code (subset may vary)

## Copilot in Visual Studio 2022+

- Completions and chat
- Chat pane integrated with the solution
- Context includes open documents and solution files

## Copilot in GitHub Mobile

- Conversational chat with access to GitHub.com data
- Ask about notifications, issues, PRs, and repo summaries
- Useful for reviewing on the go

## Copilot CLI

### Installation

```bash
gh extension install github/gh-copilot
```

Confirm:

```bash
gh copilot --version
```

### Commands

```bash
# Natural language to command
gh copilot suggest "how do I list all files modified in the last 24 hours?"

# Explain an existing command
gh copilot explain "grep -Rni --include='*.py' 'TODO' ."
```

Use flags to force shell, git, or gh CLI target:

```bash
gh copilot suggest -t shell "unzip all .gz files in a folder"
gh copilot suggest -t git "squash the last 3 commits into one"
gh copilot suggest -t gh "list my open PRs"
```

**[Copilot in the CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli/about-github-copilot-in-the-cli)** - CLI docs

## Copilot on GitHub.com

### Global Chat

Click the Copilot button in the header to open chat. Ask general questions, or reference a specific repo.

### Repo Chat

On a repository page, chat is scoped to that repo and can reason about its structure, docs, and code.

### Issues and PRs

- Summarize a long issue thread
- Draft a PR description based on the diff (Enterprise)
- Comment on PRs where Copilot is a reviewer (Enterprise)

## Copilot Extensions

Copilot Extensions extend chat with third-party or internal services. They are installed from the Copilot Extensions Marketplace.

Examples:
- `@sentry` - Query Sentry errors from chat
- `@mongodb` - Query MongoDB docs and sample data
- `@stripe` - Generate Stripe API code and answer billing questions

Custom extensions are built as GitHub Apps exposing an Agent endpoint.

**[Copilot Extensions](https://github.com/marketplace?type=apps&copilot_app=true)** - Marketplace

## Copilot Workspace

A task-centric environment (currently preview/limited) that takes an issue and drafts a plan, implementation, and PR. Designed for end-to-end issue-to-PR workflows.

## Typical Workflows

### Feature Development

1. Create an issue
2. Open the repo in your IDE; open key files in tabs for context
3. Write a function signature; let Copilot ghost text fill the body
4. Ask chat `/tests` to generate tests for the selection
5. Run tests; if red, run `/fix`
6. Use Copilot to draft a PR summary (Enterprise)
7. Request Copilot as a reviewer (Enterprise)

### Debugging

1. Select the failing function
2. `/explain` to understand it
3. `/fix` to propose a correction
4. Run tests; iterate

### Documentation

1. Select an API module
2. `/doc` to generate docstrings
3. Ask chat to generate a README section with examples

### DevOps

1. Ask chat to generate a GitHub Actions workflow for CI
2. Ask for a multi-stage Dockerfile
3. Ask for Terraform for a specific cloud resource
4. Explain complex shell pipelines with `gh copilot explain`

## MCP (Model Context Protocol) Support

Copilot Chat supports the Model Context Protocol, letting local MCP servers provide tools to chat. Admins can enable or disable MCP via policy in Business and Enterprise.

## Key Exam Facts

- Install order: Copilot extension, then Copilot Chat extension, then sign in
- `gh copilot` requires `gh extension install github/gh-copilot`
- Copilot on GitHub.com has global, repo, issue, and PR contexts
- Copilot Extensions are installed via the Marketplace as GitHub Apps
- MCP is policy-controlled in Business and Enterprise

## Study Checklist

- [ ] I can install Copilot in VS Code end to end
- [ ] I can install and use `gh copilot suggest` and `gh copilot explain`
- [ ] I can describe the chat surfaces on github.com
- [ ] I know what Copilot Extensions are and where to find them
- [ ] I can run a full feature workflow (issue to PR) using Copilot
