# GitHub Copilot Study Strategy

## Study Approach

### Phase 1: Product Foundations (Week 1)

**Goal:** Build a clear mental model of what Copilot is, what plans exist, and where it runs.

1. **Know the Product Family**
   - Free, Pro, Pro+, Business, Enterprise
   - Which are per-user vs per-org
   - Billing cycle basics and seat assignment

2. **Know the Surfaces**
   - IDE inline and chat (VS Code, JetBrains, Visual Studio, Neovim, Xcode, Eclipse)
   - GitHub.com chat and repo-aware chat
   - GitHub Mobile
   - CLI via `gh copilot`
   - Pull requests (summaries, review, commit messages)

3. **Phase 1 Resources**
   - **[Copilot Overview](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)**
   - **[Plans for Copilot](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot)**
   - **[Copilot Quickstart](https://docs.github.com/en/copilot/quickstart)**

### Phase 2: Daily Use (Weeks 2-3)

**Goal:** Become fluent in Copilot as a daily tool so the exam reflects muscle memory.

1. **Inline Completions Mastery**
   - Tab to accept, Alt+] / Alt+[ to cycle
   - Partial acceptance (next word) with Ctrl+Right
   - Open the suggestions panel with Ctrl+Enter
   - Use multiple open tabs to enrich context

2. **Chat Mastery**
   - Memorize every slash command and what it does
   - Memorize agents (`@workspace`, `@vscode`, `@terminal`, `@github`)
   - Memorize context variables (`#file`, `#selection`, `#codebase`)
   - Practice iterative refinement with follow-up messages

3. **Prompt Engineering**
   - The 4 S's (Single, Specific, Short, Surround)
   - Zero-shot, one-shot, few-shot
   - Use comments, types, and signatures to seed prompts

4. **Phase 2 Resources**
   - **[Chat Cheat Sheet](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat-in-ides/github-copilot-chat-cheat-sheet)**
   - **[Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)**
   - **[Prompt Engineering](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)**

### Phase 3: Responsible Use and Administration (Week 4)

**Goal:** Understand the policy, security, and privacy surface area.

1. **Responsible AI**
   - Model limitations (hallucinations, outdated APIs, bias, insecure code)
   - Verification workflow: review, test, scan

2. **Data Handling**
   - Business/Enterprise: prompts and suggestions are not retained or used for training
   - Individual: user opts in or out of training
   - Data in transit encrypted; proxy strips prompts after response

3. **Content Exclusions**
   - Path-based rules at repo, org, enterprise scope
   - Suppresses suggestions inside excluded files and prevents files from being used as context
   - Does not retroactively remove public or already-sent data

4. **Duplicate Detection and IP Indemnity**
   - Duplicate detection filter blocks suggestions that match ~150 chars of public code
   - IP indemnity requires Business/Enterprise plus duplicate detection enabled

5. **Phase 3 Resources**
   - **[Trust Center](https://resources.github.com/copilot-trust-center/)**
   - **[Content Exclusions](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization/excluding-content-from-github-copilot)**
   - **[Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot)**

### Phase 4: Review and Exam (Week 5)

**Goal:** Consolidate, take mock exams, identify gaps, ship the exam.

1. Run full scenarios under timing
2. Drill the feature matrix in both directions (feature to plan, plan to features)
3. Re-read any low-confidence sections

## Study Resources

### Official GitHub Resources
- **[Copilot Documentation](https://docs.github.com/en/copilot)** - Complete docs
- **[Copilot Trust Center](https://resources.github.com/copilot-trust-center/)** - Security and privacy
- **[Copilot Learning Pathway](https://resources.github.com/learn/pathways/copilot/)** - Curated path
- **[GitHub Blog - Copilot tag](https://github.blog/tag/github-copilot/)** - New features
- **[GitHub Skills](https://skills.github.com/)** - Hands-on courses

### Free Learning Resources
- **[Copilot Quickstart](https://docs.github.com/en/copilot/quickstart)** - 10-minute intro
- **[YouTube - GitHub](https://www.youtube.com/github)** - Demos and walkthroughs
- **[GitHub Universe talks](https://githubuniverse.com/)** - Deep-dive content

### Practice Platforms
- Your own repositories across multiple languages
- A sandbox org on GitHub Free where you can try Business settings (trial)
- Public open source issues for realistic chat practice

## Exam Tactics

### Question Strategy
1. **Read the full stem** - Many Copilot questions include constraints like plan type or IDE
2. **Identify the plan context** - Enterprise-only features are common distractors
3. **Eliminate wrong model/plan combinations** - e.g., knowledge bases are not in Business
4. **Prefer official terminology** - Use exact names like "duplicate detection filter" and "content exclusions"
5. **Watch for responsible-use flags** - Questions often test whether you verify, test, or scan AI output

### Time Management
- **~65 questions in 90 minutes** = ~1.4 minutes per question
- **First pass (60 minutes):** answer confident items, flag uncertain
- **Second pass (20 minutes):** revisit flagged
- **Final (10 minutes):** sanity-check, make sure nothing is blank
- Do not exceed 3 minutes on any single question on the first pass

### Question Types to Expect
- **Feature to plan mapping** - Which plan includes X?
- **Command recognition** - What does `/fix` do? What does `@workspace` do?
- **Policy scenarios** - Where do you configure Y?
- **Responsible use** - Given situation X, what should the developer do?
- **Prompt patterns** - Which prompt will most likely produce correct code?

### Key Differentiators to Study

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| Duplicate detection filter | Content exclusions | Detection blocks matches to public code; exclusions block files from context |
| Business | Enterprise | Enterprise adds knowledge bases, PR summaries, custom models |
| `@workspace` | `@github` | Workspace is IDE repo context; github queries github.com data |
| Inline suggestion | Chat | Inline is ghost text; chat is conversational |
| Copilot Pro | Copilot Pro+ | Pro+ has higher premium request limits and all models |
| Content exclusions | Private repo | Exclusions affect Copilot context specifically; private repo affects visibility |
| IP indemnity | Responsible use | Indemnity is a contractual commitment; responsible use is a practice |

## Common Pitfalls

### Product Confusion
- **Mixing Business and Enterprise features** - Knowledge bases, PR summaries, Copilot Enterprise code review are Enterprise-only
- **Assuming all chat features exist everywhere** - Some are IDE-only, some are github.com-only
- **Forgetting Copilot Free exists** - It has limited completions and chat per month

### Responsible Use
- **Thinking content exclusions protect already-sent data** - They only affect future requests
- **Assuming IP indemnity is automatic** - It requires duplicate detection to be enabled
- **Believing Copilot never sees private code** - It sees your current editor context by design

### Usage
- **Confusing slash commands with agents** - `/explain` vs `@workspace` are different surfaces
- **Not using context variables** - `#file` and `#selection` dramatically improve quality
- **Using vague prompts** - Ignoring the 4 S's is a common bad habit

### Administration
- **Not knowing scope hierarchy** - Enterprise > Organization > Repository for exclusions and policies
- **Ignoring audit logs** - Copilot emits events for seat management and policy changes
- **Confusing Copilot with GHAS** - They are separate products; do not mix features
