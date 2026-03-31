# Git Basics and GitHub Introduction

## What is Git?

Git is a free, open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Created by Linus Torvalds in 2005 for Linux kernel development.

**[About Git](https://docs.github.com/en/get-started/using-git/about-git)** - GitHub's Git overview
**[Git Documentation](https://git-scm.com/doc)** - Official Git reference

### Key Characteristics
- **Distributed** - Every developer has a full copy of the repository
- **Fast** - Most operations are local and nearly instantaneous
- **Data integrity** - Every file and commit is checksummed (SHA-1)
- **Branching model** - Lightweight, fast branching and merging
- **Staging area** - Intermediate area for preparing commits

### Git vs Other VCS
| Feature | Git (Distributed) | SVN (Centralized) |
|---------|-------------------|-------------------|
| Repository | Full copy on each machine | Single central server |
| Offline work | Full capability | Limited |
| Branching | Lightweight, fast | Heavy, slow |
| Speed | Very fast (local) | Depends on network |
| History | Complete on each clone | Only on server |

## Git Architecture

### The Three Trees
1. **Working Directory** - Files you see and edit on disk
2. **Staging Area (Index)** - Changes marked for the next commit
3. **Repository (.git)** - Committed snapshots stored in Git's database

```
Working Directory --> Staging Area --> Repository
    (git add)         (git commit)
```

### File States
- **Untracked** - New files Git does not know about
- **Modified** - Changed files not yet staged
- **Staged** - Modified files marked for the next commit
- **Committed** - Safely stored in the local repository

**[Recording Changes](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository)** - File lifecycle

## Essential Git Commands

### Repository Setup
```bash
# Initialize a new repository
git init

# Clone an existing repository
git clone https://github.com/user/repo.git

# Clone to a specific directory
git clone https://github.com/user/repo.git my-folder
```

**[Creating a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)** - Repository creation guide

### Basic Workflow
```bash
# Check status of working directory
git status

# Stage specific files
git add file.txt

# Stage all changes
git add .

# Commit staged changes
git commit -m "Add login feature"

# View commit history
git log
git log --oneline --graph
```

### Branching
```bash
# List branches
git branch

# Create a new branch
git branch feature-branch

# Switch to a branch
git checkout feature-branch
git switch feature-branch    # newer syntax

# Create and switch in one command
git checkout -b feature-branch
git switch -c feature-branch  # newer syntax

# Delete a branch
git branch -d feature-branch
```

**[About Branches](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches)** - Branch concepts

### Merging
```bash
# Merge a branch into current branch
git merge feature-branch

# Merge with a merge commit (no fast-forward)
git merge --no-ff feature-branch

# Abort a merge with conflicts
git merge --abort
```

### Rebasing
```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase (squash, edit, reorder commits)
git rebase -i HEAD~3

# Abort a rebase
git rebase --abort
```

**Key difference:** Merge preserves history with a merge commit; rebase replays commits for linear history.

### Remote Operations
```bash
# View remote repositories
git remote -v

# Add a remote
git remote add origin https://github.com/user/repo.git

# Fetch changes (download only, no merge)
git fetch origin

# Pull changes (fetch + merge)
git pull origin main

# Push changes to remote
git push origin main

# Push a new branch
git push -u origin feature-branch
```

**[Getting Changes from a Remote](https://docs.github.com/en/get-started/using-git/getting-changes-from-a-remote-repository)** - Remote operations

### Critical Difference: Fetch vs Pull
| Aspect | `git fetch` | `git pull` |
|--------|-------------|------------|
| Downloads changes | Yes | Yes |
| Merges automatically | No | Yes |
| Safe to run anytime | Yes | Can cause conflicts |
| Updates working directory | No | Yes |
| Use case | Review before merging | Quick update |

### Undoing Changes
```bash
# Unstage a file (keep changes)
git reset HEAD file.txt

# Discard changes in working directory
git checkout -- file.txt
git restore file.txt          # newer syntax

# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (keep changes unstaged)
git reset --mixed HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Create a new commit that undoes a previous commit
git revert <commit-hash>
```

### Other Useful Commands
```bash
# Show changes
git diff                    # working directory vs staging
git diff --staged           # staging vs last commit

# Temporarily save changes
git stash
git stash pop               # restore and remove from stash
git stash list              # view stashed changes

# View file history
git blame file.txt          # who changed each line

# Search commits
git log --grep="bug fix"    # search commit messages
```

## Merge Conflicts

### When Do They Occur?
- Two branches modify the same line(s) in the same file
- One branch deletes a file that the other branch modified
- Both branches add a file with the same name but different content

### Conflict Markers
```
<<<<<<< HEAD
Your changes (current branch)
=======
Their changes (incoming branch)
>>>>>>> feature-branch
```

### Resolving Conflicts
1. Open the conflicted file
2. Choose which changes to keep (or combine both)
3. Remove the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Stage the resolved file with `git add`
5. Complete the merge with `git commit`

**[Resolving Merge Conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-using-the-command-line)** - Conflict resolution guide

## What is GitHub?

GitHub is a cloud-based platform built on top of Git that provides:
- **Repository hosting** - Store and share code remotely
- **Collaboration** - Issues, pull requests, code review
- **Automation** - GitHub Actions for CI/CD
- **Security** - Dependabot, secret scanning, code scanning
- **Project management** - Projects, milestones, labels
- **Community** - Open source hosting, Sponsors, Discussions

**[About GitHub and Git](https://docs.github.com/en/get-started/start-your-journey/about-github-and-git)** - Platform overview

### GitHub Account Types
- **Personal account** - Individual user, owns repositories
- **Organization account** - Shared account for teams, owns repositories, manages teams
- **Enterprise account** - Manages multiple organizations with centralized policies

**[Types of GitHub Accounts](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts)** - Account types

### GitHub Plans
| Plan | Target | Key Features |
|------|--------|-------------|
| Free | Individuals/small teams | Unlimited public/private repos, 2000 Actions min/mo |
| Pro | Individual developers | 3000 Actions min/mo, advanced tools |
| Team | Organizations | Team management, 3000 Actions min/mo |
| Enterprise | Large organizations | SAML SSO, 50000 Actions min/mo, advanced audit |

**[GitHub Plans](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)** - Plan comparison

### GitHub Tools
- **GitHub.com** - Web interface for all GitHub features
- **GitHub Desktop** - GUI for Git operations (Windows, macOS)
- **GitHub Mobile** - iOS/Android app for on-the-go management
- **GitHub CLI (`gh`)** - Command-line tool for GitHub operations
- **GitHub Codespaces** - Cloud-hosted development environments

**[GitHub CLI](https://docs.github.com/en/github-cli)** - CLI documentation
**[GitHub Desktop](https://docs.github.com/en/desktop)** - Desktop app guide
**[GitHub Mobile](https://docs.github.com/en/get-started/using-github/github-mobile)** - Mobile app features

## GitHub Markdown

GitHub uses GitHub Flavored Markdown (GFM) for formatting text in issues, PRs, READMEs, and more.

### Essential Syntax
```markdown
# Heading 1
## Heading 2

**bold** and *italic* and ~~strikethrough~~

- Unordered list
1. Ordered list
- [ ] Task list item

[Link text](url)
![Image alt text](image-url)

`inline code`

> Blockquote

| Column 1 | Column 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

### GitHub-Specific Features
- @mentions for users and teams
- #references for issues and PRs
- Emoji shortcodes (:smile:)
- Mermaid diagrams in code blocks
- Mathematical expressions with LaTeX
- Alerts: `> [!NOTE]`, `> [!WARNING]`, `> [!IMPORTANT]`

**[Basic Formatting Syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)** - Markdown reference
**[GitHub Flavored Markdown Spec](https://github.github.com/gfm/)** - GFM specification

## Key Exam Points

- Git is distributed - every clone is a full repository
- The staging area is what makes Git unique among VCS
- `git fetch` never changes your working directory; `git pull` does
- Merge creates a merge commit; rebase creates linear history
- `git reset` modifies history; `git revert` creates new commits
- GitHub is a platform built on Git, not a replacement for Git
- Know the difference between Personal, Organization, and Enterprise accounts
- GitHub Free includes unlimited public AND private repositories
