# GitHub Copilot Certification Exam Guide

## Exam Overview

The GitHub Copilot certification validates your ability to use GitHub Copilot effectively in professional development workflows. It covers Copilot's capabilities, plans, integrations, responsible AI usage, prompt engineering, and enterprise administration. The exam targets developers, team leads, and administrators who deploy or consume AI-assisted development tools.

### Exam Details
- **Exam Name:** GitHub Copilot
- **Duration:** 90 minutes
- **Format:** Multiple choice and multiple response
- **Number of Questions:** ~65 questions
- **Passing Score:** 70%
- **Cost:** $99 USD
- **Delivery:** Online proctored via PSI
- **Prerequisites:** None required; familiarity with Git, GitHub, and at least one modern IDE recommended
- **Validity:** 2 years
- **Retake Policy:** 24-hour wait for first retake, 14 days for subsequent attempts

### Official Resources
- **[GitHub Certifications](https://resources.github.com/learn/certifications/)** - Program overview and registration
- **[GitHub Copilot Documentation](https://docs.github.com/en/copilot)** - Complete product docs
- **[GitHub Copilot Trust Center](https://resources.github.com/copilot-trust-center/)** - Security, privacy, IP
- **[GitHub Skills](https://skills.github.com/)** - Interactive learning
- **[Copilot Learning Pathway](https://resources.github.com/learn/pathways/copilot/)** - Structured path

## Exam Domains

The GitHub Copilot exam is organized around six major functional areas. The weight percentages below reflect the most commonly published distribution for the exam.

### Domain 1: Introduction to GitHub Copilot (20%)

Covers what GitHub Copilot is, how it works, and what products are available.

**Key Topics:**
- What GitHub Copilot is and the AI models that power it (OpenAI Codex, GPT-4o, Claude, Gemini)
- Copilot product family: Copilot Individual, Copilot Business, Copilot Enterprise, Copilot Free
- Feature availability by plan (chat, PR summaries, knowledge bases, custom models)
- How Copilot differs from traditional code completion (LSP) and snippet tools
- High-level architecture: client extension, proxy, model providers, telemetry
- Supported languages (best for popular languages like Python, JavaScript, TypeScript, Go, Ruby, Java, C#)

**What to Study:**
- Differences in features between Individual, Business, and Enterprise
- Which features are GA vs in public preview
- How context is collected from open files, tabs, and the repo

### Domain 2: Responsible Use of GitHub Copilot (15%)

Covers responsible AI, limitations, bias, accuracy, and mitigation strategies.

**Key Topics:**
- Common AI limitations: hallucinations, outdated suggestions, bias, security vulnerabilities
- Verification workflows (review, test, scan before commit)
- Duplicate detection filter and public code matching
- Content exclusions (path-based exclusion of files from context and suggestions)
- IP indemnification for Business/Enterprise with duplicate detection enabled
- Accessibility features and settings

**What to Study:**
- How and where to configure content exclusions (repo, org, enterprise levels)
- What the duplicate detection filter blocks and when
- The shared responsibility model for AI-generated code

### Domain 3: GitHub Copilot Plans and Features (15%)

Covers the feature matrix, billing, and seat management.

**Key Topics:**
- Copilot Free, Individual, Business, Enterprise feature differences
- Chat in IDE, chat in GitHub.com, PR summaries, code review, knowledge bases
- Copilot in the CLI (`gh copilot suggest`, `gh copilot explain`)
- Copilot Extensions (Marketplace, custom extensions via GitHub Apps)
- Copilot Workspace (task-centric development)
- Seat assignment, unassignment, and billing cycles

**What to Study:**
- Which chat features require Business or Enterprise
- How seats are assigned by admins and how users activate them
- What knowledge bases do and which SKU includes them (Enterprise)

### Domain 4: Using GitHub Copilot (25%)

Largest domain. Covers day-to-day usage across IDE, chat, CLI, and PR workflows.

**Key Topics:**
- Inline code completions and ghost text acceptance (Tab, Alt+] / Alt+[)
- Copilot Chat: inline, panel, quick chat, slash commands (`/explain`, `/fix`, `/tests`, `/doc`)
- Agents and participants: `@workspace`, `@terminal`, `@vscode`, `@github`
- Context providers: `#file`, `#selection`, `#codebase`, `#terminalLastCommand`
- Copilot in VS Code, Visual Studio, JetBrains IDEs, Neovim, Xcode, Eclipse
- Copilot in GitHub Mobile and GitHub.com
- Copilot pull request summaries and code review
- Copilot in the CLI

**What to Study:**
- All common chat slash commands and what they do
- Keyboard shortcuts for accepting, rejecting, and cycling suggestions
- How to attach context explicitly and when context is implicit

### Domain 5: Prompt Engineering for GitHub Copilot (10%)

Covers writing effective prompts, comments, and chat messages.

**Key Topics:**
- The 4 S's: Single, Specific, Short, Surround
- Providing examples, expected inputs and outputs
- Breaking large tasks into smaller steps
- Using neighbor tabs and open files as implicit context
- Zero-shot, one-shot, few-shot prompting with Copilot Chat
- Iterative refinement and conversational follow-ups

**What to Study:**
- How naming, comments, and docstrings influence suggestions
- How to seed a prompt with types, schemas, and imports
- When to use chat vs inline completions

### Domain 6: Developer Use Cases for AI (15%)

Covers practical and enterprise scenarios where Copilot adds value.

**Key Topics:**
- Writing new code, refactoring, writing tests, writing documentation
- Learning new languages and frameworks
- Debugging and explaining unfamiliar code
- Generating boilerplate (API clients, DTOs, migrations)
- Legacy code modernization
- DevOps scenarios (workflow YAML, Dockerfiles, Terraform, shell scripts)
- Limitations in regulated industries and what controls exist

**What to Study:**
- How Copilot helps with test generation and code review
- Where Copilot is weakest (proprietary DSLs, very recent frameworks)
- Enterprise scenarios requiring content exclusions or air-gapped workflows

## Key Concepts to Master

### Product Knowledge
1. Plan tiers and the feature matrix across Free, Individual, Business, Enterprise
2. Which features require organization-level policies to be enabled
3. How models are selected and switched in Copilot Chat

### Usage Skills
1. Effective prompt patterns and iterative refinement
2. Context building with files, selections, and participants
3. Slash commands, agents, and Copilot Extensions

### Responsible AI
1. Duplicate detection and IP indemnity requirements
2. Content exclusions and how context gathering is affected
3. Data retention, prompt logging, and telemetry controls

### Administration
1. Enabling Copilot at the org or enterprise level
2. Setting content exclusions at repo, org, and enterprise scope
3. Policy controls: suggestions matching public code, chat, network, MCP servers
4. Audit log events and seat assignment reporting

## Study Approach

### Recommended Path
1. **Week 1:** Fundamentals and plans (Domains 1, 3)
2. **Week 2:** Using Copilot in the IDE and chat (Domain 4)
3. **Week 3:** Prompt engineering and developer use cases (Domains 5, 6)
4. **Week 4:** Responsible use, administration, and review (Domains 2, plus admin cross-cutting)

### Hands-On Practice
- Install the Copilot extension in at least two IDEs (VS Code plus one more)
- Enable a Copilot Free or Individual trial and use it daily
- Try chat, inline, CLI, and GitHub.com chat surfaces
- Configure content exclusions on a test repository
- Create a workflow YAML and a test file with Copilot assistance

### Study Materials
- **[Copilot Docs](https://docs.github.com/en/copilot)** - Primary reference
- **[Copilot Quickstart](https://docs.github.com/en/copilot/quickstart)** - Fast introduction
- **[Copilot Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)** - Official guidance
- **[Copilot Trust Center](https://resources.github.com/copilot-trust-center/)** - Privacy and IP
- **[GitHub Blog - Copilot](https://github.blog/tag/github-copilot/)** - Latest features

### Tips for Success
- Focus heavily on Domain 4 (Using Copilot) and Domain 1 (Fundamentals)
- Memorize the feature matrix by plan, especially Business vs Enterprise
- Learn the exact names of slash commands, agents, and context providers
- Understand content exclusions vs duplicate detection; these are easy to confuse
- Practice chat and inline daily for at least two weeks before the exam
