# GitHub Foundations Study Strategy

## Study Approach

### Phase 1: Foundation Building (Weeks 1-2)

**Goal:** Master Git fundamentals and understand the GitHub platform.

1. **Git Version Control**
   - Install Git and configure your environment
   - Practice all essential commands (init, clone, add, commit, push, pull, fetch)
   - Understand the three-tree architecture (working directory, staging, repository)
   - Master branching, merging, and rebasing
   - Learn to resolve merge conflicts

2. **GitHub Platform Basics**
   - Create a GitHub account and explore the interface
   - Understand account types and plan differences
   - Create repositories with READMEs, licenses, and .gitignore files
   - Practice cloning and forking workflows
   - Explore GitHub Desktop, Mobile, and CLI

3. **Resources for Phase 1**
   - **[Git Handbook](https://docs.github.com/en/get-started/using-git/about-git)** - Git fundamentals
   - **[GitHub Skills: Introduction to GitHub](https://github.com/skills/introduction-to-github)** - Interactive course
   - **[Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)** - Quick command reference
   - **[GitHub Quickstart](https://docs.github.com/en/get-started/quickstart)** - Getting started guide

### Phase 2: Collaboration and Development (Weeks 3-4)

**Goal:** Master collaboration workflows and modern development features.

1. **Collaboration Deep Dive**
   - Create and manage issues with labels, assignees, and milestones
   - Practice the complete pull request lifecycle
   - Conduct code reviews with inline comments and suggestions
   - Configure branch protection rules
   - Set up CODEOWNERS for automatic review assignment
   - Understand all three merge strategies

2. **GitHub Actions and Modern Tools**
   - Write basic workflow YAML files
   - Understand triggers, jobs, steps, and actions
   - Explore the Actions Marketplace
   - Learn Codespaces concepts and configuration
   - Understand Copilot features at a high level

3. **Resources for Phase 2**
   - **[About Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)** - PR documentation
   - **[Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)** - Actions fundamentals
   - **[GitHub Skills: Review Pull Requests](https://github.com/skills/review-pull-requests)** - Interactive PR review course
   - **[GitHub Skills: Hello GitHub Actions](https://github.com/skills/hello-github-actions)** - Actions course

### Phase 3: Exam Preparation (Weeks 5-6)

**Goal:** Cover remaining domains, review all material, and practice for the exam.

1. **Remaining Domains**
   - GitHub Projects - views, custom fields, automation
   - Security - 2FA, SSH keys, Dependabot, secret scanning
   - Community - open source licensing, InnerSource, contributing
   - Organization management - roles, teams, permissions

2. **Review and Practice**
   - Review all notes and the fact sheet
   - Work through scenario-based questions
   - Take practice exams and identify weak areas
   - Re-read documentation for topics you struggle with
   - Create a one-page summary of key differentiators

3. **Resources for Phase 3**
   - **[About Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)** - Projects documentation
   - **[Security Features](https://docs.github.com/en/code-security)** - Security overview
   - **[Open Source Guide](https://opensource.guide/)** - Open source best practices
   - **[GitHub Foundations Study Guide PDF](https://assets.ctfassets.net/wfutmusr1t3h/1kmMx7AwI4qH8yIZgOmQlP/4e60030cc6c76688698652e830ea2a48/github-foundations-exam-study-guide.pdf)** - Official study guide

## Study Resources

### Official GitHub Resources
- **[GitHub Skills](https://skills.github.com/)** - Free interactive courses (the best starting point)
- **[GitHub Docs](https://docs.github.com)** - Complete documentation
- **[GitHub Learning Pathways](https://resources.github.com/learn/pathways/)** - Structured learning paths
- **[GitHub Certifications](https://resources.github.com/learn/certifications/)** - Certification program details
- **[GitHub YouTube Channel](https://www.youtube.com/github)** - Video tutorials and demos
- **[GitHub Blog](https://github.blog/)** - Latest features and updates

### Free Learning Resources
- **[GitHub Skills Courses](https://skills.github.com/)** - Interactive, repository-based learning
- **[Git Documentation](https://git-scm.com/doc)** - Official Git reference
- **[Pro Git Book](https://git-scm.com/book/en/v2)** - Free comprehensive Git book
- **[GitHub Training Manual](https://githubtraining.github.io/training-manual/)** - Training materials

### Community Resources
- **[GitHub Community Forum](https://github.com/orgs/community/discussions)** - Community discussions
- **[r/github](https://www.reddit.com/r/github/)** - Reddit community
- **[GitHub Education](https://education.github.com/)** - Student resources and benefits

### Practice Platforms
- GitHub Skills courses (free, interactive)
- Create personal projects to practice workflows
- Contribute to open source projects for real-world experience
- Practice with a study partner for code review scenarios

## Exam Tactics

### Question Strategy
1. **Read the full question** - Identify what is being asked (best practice, correct command, right feature)
2. **Eliminate wrong answers** - Remove obviously incorrect options first
3. **Look for keywords** - "best," "most appropriate," "correct" signal specific answers
4. **Consider the GitHub way** - GitHub exams favor platform-native solutions
5. **Think about the workflow** - Many questions test proper workflow order

### Time Management
- **75 questions in 120 minutes** = ~1.6 minutes per question
- **First pass (80 minutes):** Answer questions you are confident about, flag uncertain ones
- **Second pass (30 minutes):** Return to flagged questions with fresh perspective
- **Final review (10 minutes):** Check for unanswered questions, verify flagged answers
- Do not spend more than 3 minutes on any single question

### Question Types to Expect
- **Factual recall** - What does command X do? What is feature Y?
- **Scenario-based** - Given this situation, what is the best approach?
- **Comparison** - What is the difference between X and Y?
- **Best practice** - What is the recommended way to do X?
- **Feature identification** - Which GitHub feature solves this problem?

### Key Differentiators to Study
These pairs/groups are commonly tested because they are easy to confuse:

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| `git fetch` | `git pull` | fetch downloads only; pull downloads and merges |
| Fork | Clone | Fork is server-side copy; clone is local copy |
| Merge commit | Squash merge | Merge preserves history; squash creates one commit |
| Branch | Tag | Branch is movable; tag is fixed at a commit |
| Issues | Discussions | Issues track work; discussions are conversations |
| PAT (classic) | Fine-grained PAT | Classic has broad scopes; fine-grained has per-repo permissions |
| Public repo | Internal repo | Public is visible to everyone; internal is org-only |
| `git reset` | `git revert` | Reset removes commits; revert creates new undoing commit |
| GitHub-hosted runner | Self-hosted runner | GitHub-hosted is managed; self-hosted is your infrastructure |
| Classic Projects | New Projects | Classic is per-repo kanban; new is cross-repo with custom fields |

## Common Pitfalls

### Git Concepts
- **Confusing `git fetch` and `git pull`** - fetch does NOT merge; pull does both
- **Not understanding merge vs rebase** - rebase rewrites history, merge preserves it
- **Forgetting `git stash`** - useful for temporarily saving work without committing
- **Mixing up `git reset` modes** - soft, mixed, hard have different effects
- **Ignoring `.gitignore`** - files already tracked are not affected by adding to .gitignore

### GitHub Platform
- **Thinking fork is the same as clone** - fork creates a copy on GitHub; clone creates local copy
- **Not knowing branch protection details** - understand all available protection options
- **Confusing organization roles** - Owner, Member, and Outside Collaborator have different permissions
- **Overlooking GitHub Plans differences** - know what each plan includes
- **Forgetting about draft PRs** - they signal work in progress and prevent accidental merging

### Exam Strategy
- **Rushing through questions** - take time to read the full question and all options
- **Over-studying low-weight domains** - focus effort proportional to domain weight
- **Only reading without practicing** - hands-on experience is critical for this exam
- **Ignoring the official study guide** - it tells you exactly what to study
- **Not reviewing incorrect practice answers** - understanding why you were wrong is more valuable than getting answers right

### Security Topics
- **Thinking 2FA is optional** - GitHub requires 2FA for all accounts
- **Confusing PAT types** - classic vs fine-grained have different scoping models
- **Not understanding SSH key workflow** - know how to generate and add SSH keys
- **Overlooking Dependabot** - it is a key security feature for dependency management
- **Mixing up secret scanning and code scanning** - secrets detect credentials; code scanning finds code vulnerabilities
