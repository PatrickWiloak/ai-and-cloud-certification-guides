# Domain 2 - Claude Code Configuration (20%)

## Overview

Claude Code is Anthropic's official agentic coding tool, available as a CLI application and as IDE extensions for VS Code and JetBrains. This domain covers how to install, configure, and customize Claude Code for individual and team development workflows.

---

## What is Claude Code?

Claude Code is an agentic coding assistant that lives in your terminal and IDE. It can:
- Read, write, and edit files in your codebase
- Run terminal commands
- Search through code and documentation
- Interact with external services via MCP servers
- Follow project-specific instructions via CLAUDE.md files

Unlike simple code completion tools, Claude Code operates as an agent - it plans, executes, and iterates to complete complex development tasks.

**[Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)** - Introduction and capabilities

---

## Installation and Setup

### CLI Installation

Claude Code is installed via npm:
```bash
npm install -g @anthropic-ai/claude-code
```

Requirements:
- Node.js 18+
- Anthropic API key (or Claude Pro/Team/Enterprise subscription)
- Supported OS: macOS, Linux, Windows (via WSL)

### Authentication

Claude Code can authenticate via:
- Anthropic API key (set via `ANTHROPIC_API_KEY` environment variable)
- Claude Pro/Team/Enterprise subscription (OAuth flow)
- API key configured in settings

### First Run

Launch Claude Code in a project directory:
```bash
cd your-project
claude
```

On first run in a project, Claude Code will:
- Read any CLAUDE.md files in the project
- Detect the project structure and language
- Present the interactive CLI interface

**[Getting Started with Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)** - Setup instructions

---

## CLAUDE.md Files (Memory)

CLAUDE.md files are the primary way to give Claude Code persistent instructions about your project. They function as project memory that persists across sessions.

**[Claude Code Memory](https://docs.anthropic.com/en/docs/claude-code/memory)** - Complete CLAUDE.md documentation

### File Hierarchy

CLAUDE.md files follow a hierarchy with increasing specificity:

1. **Enterprise-level** - Managed by organization admins (enterprise deployments)
2. **User-level** (`~/.claude/CLAUDE.md`) - Personal preferences that apply to all projects
3. **Project-level** (repo root `CLAUDE.md`) - Project-specific instructions, checked into version control
4. **Directory-level** (subdirectory `CLAUDE.md`) - Instructions specific to a subdirectory

All applicable CLAUDE.md files are combined and included in Claude's context. Lower-level files can add specificity but should not contradict higher-level instructions.

### What to Include in CLAUDE.md

**Project-level CLAUDE.md (most common):**
- Project overview and architecture
- Coding standards and conventions
- Build and test commands
- Common patterns and anti-patterns
- Technology stack details
- File organization conventions
- Important project-specific rules

**User-level CLAUDE.md:**
- Preferred response language
- Personal coding style preferences
- Global rules that apply across all projects

### Best Practices

- Keep CLAUDE.md concise - everything in it uses context window tokens
- Focus on actionable instructions, not documentation
- Update CLAUDE.md as project conventions evolve
- Use CLAUDE.md for things Claude consistently gets wrong without guidance
- Project-level CLAUDE.md should be checked into version control for team sharing
- Do not put secrets or sensitive data in CLAUDE.md

### Example Project CLAUDE.md

```markdown
# Project Instructions

## Build Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Coding Standards
- Use TypeScript strict mode
- Prefer functional components with hooks
- Use Tailwind CSS for styling
- Write tests for all new features

## Architecture
- Frontend: Next.js 14 with App Router
- Backend: Express.js API in /api directory
- Database: PostgreSQL with Prisma ORM
```

---

## Settings and Permissions

**[Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)** - Configuration reference

### Settings Files

Settings are configured in JSON files:
- **User settings**: `~/.claude/settings.json` - Personal settings
- **Project settings**: `.claude/settings.json` - Project-specific settings (checked into repo)
- **Enterprise settings**: Managed centrally by administrators

### Permissions Model

Claude Code has a permissions system that controls what actions require user approval:

- **Allowed tools** - Tools that can run without asking for permission
- **Denied tools** - Tools that are blocked entirely
- **Default behavior** - Unspecified tools prompt for approval

Common permission configurations:
- Allow read operations without approval (file reads, searches)
- Require approval for write operations (file edits, command execution)
- Block dangerous commands (rm -rf, git push --force)

### Key Settings

- `permissions` - Tool-level permission rules
- `mcpServers` - MCP server configurations
- `env` - Environment variables to set
- `apiKey` - API key configuration (prefer environment variables)

---

## Hooks System

Hooks allow you to run custom scripts before or after Claude Code executes specific tools. They are configured in settings files.

**[Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)** - Hooks documentation

### Hook Types

- **PreToolUse** - Runs before a tool is executed. Can block the tool execution.
- **PostToolUse** - Runs after a tool completes. Can process or validate results.
- **Notification** - Runs when Claude Code sends a notification

### Hook Configuration

Hooks are defined in settings.json:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "write_file",
        "command": "npm run lint --fix ${file}"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "write_file",
        "command": "npm run format ${file}"
      }
    ]
  }
}
```

### Use Cases

- **Pre-tool: Linting** - Run linter before file writes to ensure code quality
- **Pre-tool: Validation** - Check that proposed changes meet project standards
- **Pre-tool: Security scanning** - Scan for secrets or vulnerabilities before committing
- **Post-tool: Formatting** - Auto-format files after Claude writes them
- **Post-tool: Testing** - Run relevant tests after code changes
- **Post-tool: Notifications** - Alert the team when significant changes are made

### Hook Behavior

- Pre-tool hooks that exit with a non-zero status block the tool execution
- Hook output is captured and can be shown to the user
- Hooks run synchronously (Claude Code waits for them to complete)
- Hooks have access to tool-specific variables (file paths, command text, etc.)

---

## Custom Slash Commands

Slash commands are shortcuts for common workflows. Claude Code includes built-in commands and supports custom user-defined commands.

**[Claude Code Slash Commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)** - Commands reference

### Built-in Commands

- `/help` - Show available commands
- `/clear` - Clear conversation history
- `/compact` - Summarize and compress the conversation
- `/init` - Initialize CLAUDE.md for the project
- Other built-in commands per documentation

### Custom Commands

Custom commands are markdown files stored in the `.claude/commands/` directory:

```
.claude/
  commands/
    deploy.md        # Project command: /deploy
    review.md        # Project command: /review
```

User-level commands are stored in `~/.claude/commands/`:

```
~/.claude/
  commands/
    my-template.md   # User command: /my-template
```

### Command File Format

Command files are markdown files whose content becomes the prompt when invoked:

```markdown
Review the staged git changes and provide:
1. A summary of what changed
2. Potential issues or bugs
3. Suggestions for improvement

Focus on code quality, security, and performance.
```

### Best Practices

- Keep command prompts focused on a single workflow
- Project commands (`.claude/commands/`) should be checked into version control
- Use descriptive filenames that indicate what the command does
- Commands can reference project conventions from CLAUDE.md

---

## IDE Integrations

**[Claude Code IDE Integration](https://docs.anthropic.com/en/docs/claude-code/ide-integrations)** - IDE setup guide

### VS Code Extension

- Install from the VS Code marketplace
- Provides Claude Code panel within VS Code
- Integrates with editor context (selected code, open files)
- Uses the same CLAUDE.md files and settings as the CLI

### JetBrains Plugin

- Install from the JetBrains marketplace
- Available for IntelliJ IDEA, WebStorm, PyCharm, and other JetBrains IDEs
- Similar functionality to the VS Code extension
- Shares configuration with the CLI

### CLI vs IDE

| Feature | CLI | IDE Extension |
|---|---|---|
| Terminal access | Full | Limited |
| File context | Manual | Automatic (open files, selection) |
| Visual diff | Text-based | IDE diff viewer |
| MCP servers | Configured in settings | Same settings |
| CLAUDE.md | Same files | Same files |

---

## MCP Server Configuration in Claude Code

Claude Code can connect to MCP servers for additional capabilities.

**[Claude Code MCP Servers](https://docs.anthropic.com/en/docs/claude-code/mcp-servers)** - MCP configuration in Claude Code

### Configuration Methods

MCP servers are configured via:

1. **Project `.mcp.json`** - Checked into version control for team sharing
2. **User settings** - In `~/.claude/settings.json` for personal MCP servers
3. **CLI flag** - Pass MCP server configuration at launch

### .mcp.json Format

```json
{
  "mcpServers": {
    "database": {
      "command": "node",
      "args": ["./mcp-servers/database-server.js"],
      "env": {
        "DB_CONNECTION": "postgresql://localhost:5432/mydb"
      }
    },
    "remote-api": {
      "url": "https://internal-api.company.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

### Transport Types in Claude Code

- **stdio** - For local MCP servers. Claude Code spawns the process and communicates via stdin/stdout.
- **Streamable HTTP / SSE** - For remote MCP servers. Claude Code connects via HTTP.

---

## Best Practices for Team Configuration

**[Claude Code Best Practices](https://docs.anthropic.com/en/docs/claude-code/best-practices)** - Official recommendations

1. **Version control CLAUDE.md** - Check project-level CLAUDE.md into the repo so all team members share the same instructions
2. **Version control .claude/commands/** - Share custom slash commands across the team
3. **Version control .mcp.json** - Share MCP server configurations
4. **Use .claude/settings.json for project permissions** - Standardize which operations require approval
5. **Keep personal preferences in user-level files** - Individual developers customize via `~/.claude/CLAUDE.md` and `~/.claude/settings.json`
6. **Document hooks** - If hooks are configured, document their purpose and behavior for the team
7. **Review CLAUDE.md regularly** - Keep instructions current as the project evolves

---

## Key Exam Concepts

1. Know the CLAUDE.md file hierarchy and precedence order
2. Understand the difference between settings.json and CLAUDE.md
3. Know how to configure hooks (PreToolUse, PostToolUse)
4. Understand the permissions model and how to configure it
5. Know how to create and use custom slash commands
6. Understand MCP server configuration in Claude Code
7. Know the difference between project-level and user-level configuration
8. Understand IDE integration capabilities and limitations

---

## Related Documentation

- **[Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)** - Introduction
- **[Claude Code Memory](https://docs.anthropic.com/en/docs/claude-code/memory)** - CLAUDE.md files
- **[Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)** - Configuration
- **[Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)** - Hook system
- **[Claude Code Slash Commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)** - Custom commands
- **[Claude Code MCP Servers](https://docs.anthropic.com/en/docs/claude-code/mcp-servers)** - MCP integration
- **[Claude Code Best Practices](https://docs.anthropic.com/en/docs/claude-code/best-practices)** - Recommendations
- **[Claude Code IDE Integration](https://docs.anthropic.com/en/docs/claude-code/ide-integrations)** - VS Code and JetBrains
