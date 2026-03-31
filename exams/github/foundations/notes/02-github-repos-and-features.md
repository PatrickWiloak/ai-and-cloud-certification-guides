# GitHub Repositories and Features

## Repository Basics

A repository is the most basic element of GitHub - it contains all project files, revision history, and collaboration features.

**[About Repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories)** - Repository overview
**[Creating a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)** - Creation guide

### Repository Visibility

| Visibility | Who Can See | Who Can Contribute | Use Case |
|------------|-------------|-------------------|----------|
| Public | Everyone | Anyone (via fork/PR) | Open source projects |
| Private | You + collaborators | Invited collaborators | Proprietary code |
| Internal | Organization members | Organization members | InnerSource projects |

**[Setting Repository Visibility](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility)** - Visibility settings

### Creating a Repository

**Via GitHub.com:**
1. Click "+" in the top-right corner, select "New repository"
2. Choose owner (personal or organization)
3. Enter repository name
4. Set visibility (public/private)
5. Optionally initialize with README, .gitignore, license
6. Click "Create repository"

**Via GitHub CLI:**
```bash
gh repo create my-project --public --clone
gh repo create my-project --private --add-readme
```

**Via Git:**
```bash
mkdir my-project && cd my-project
git init
git remote add origin https://github.com/user/my-project.git
```

### Repository Templates

- Create a template repository to generate new repos with the same structure
- Templates include files, branches, and directory structure
- Users can create repos from templates without forking
- Useful for standardizing project setup across an organization

**[Creating a Template Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)** - Template setup

## Essential Repository Files

### README.md
- First file visitors see when viewing a repository
- Should include project description, installation, usage, and contribution guidelines
- Rendered as HTML on the repository page
- Can include badges, images, and formatted content
- Profile READMEs (in a repo matching your username) appear on your profile

**[About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)** - README best practices

### .gitignore
- Specifies files and directories Git should ignore
- Patterns match file paths (e.g., `*.log`, `node_modules/`, `.env`)
- GitHub provides templates for common languages and frameworks
- Files already tracked by Git are NOT affected by adding to .gitignore
- Use `git rm --cached <file>` to stop tracking a file

**[Ignoring Files](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files)** - .gitignore guide

### LICENSE
- Defines how others can use, modify, and distribute your code
- Required for open source projects
- GitHub can add a license during repository creation
- Without a license, default copyright laws apply (all rights reserved)

**[Licensing a Repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)** - License guide
**[Choose a License](https://choosealicense.com/)** - License comparison tool

### CODEOWNERS
- Located in root, `docs/`, or `.github/` directory
- Automatically requests reviews from specified owners
- Uses pattern matching (similar to .gitignore)
- Works with branch protection rules requiring code owner review

```
# Example CODEOWNERS file
*.js @frontend-team
*.py @backend-team
/docs/ @docs-team
* @default-reviewer
```

**[About Code Owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)** - CODEOWNERS reference

### Community Health Files
| File | Purpose |
|------|---------|
| `CONTRIBUTING.md` | Contribution guidelines and process |
| `CODE_OF_CONDUCT.md` | Community behavior expectations |
| `SECURITY.md` | Vulnerability reporting instructions |
| `SUPPORT.md` | How to get help with the project |
| `FUNDING.yml` | Sponsorship links (in `.github/` directory) |
| `ISSUE_TEMPLATE/` | Templates for new issues |
| `PULL_REQUEST_TEMPLATE.md` | Template for new pull requests |

**[Creating Community Health Files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)** - Community files guide

## Clone vs Fork

### Cloning
- Creates a local copy of a repository on your machine
- Maintains a direct link to the remote (origin)
- Used when you have write access or want a local copy
- Changes are pushed back to the same remote repository

```bash
# Clone via HTTPS
git clone https://github.com/user/repo.git

# Clone via SSH
git clone git@github.com:user/repo.git

# Clone via GitHub CLI
gh repo clone user/repo
```

**[Cloning a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)** - Clone guide

### Forking
- Creates a server-side copy under your GitHub account
- Independent from the original (upstream) repository
- Used for contributing to projects you do not have write access to
- Pull requests are submitted from fork back to original

**Fork workflow:**
1. Fork the repository on GitHub
2. Clone your fork locally
3. Add upstream remote: `git remote add upstream <original-repo-url>`
4. Create a feature branch
5. Make changes and push to your fork
6. Open a pull request from your fork to the original repository

**[Fork a Repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)** - Fork guide
**[Syncing a Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)** - Keep fork updated

### Clone vs Fork Comparison

| Aspect | Clone | Fork |
|--------|-------|------|
| Location | Local machine | GitHub (server-side) |
| Ownership | Same remote repo | Your account |
| Write access needed | Yes (to push) | No (push to your fork) |
| Purpose | Work on your own repos | Contribute to others' repos |
| Sync method | `git pull` | `git fetch upstream` + merge |
| Creates PR to | Same repo | Original (upstream) repo |

## GitHub Pages

GitHub Pages is a free static site hosting service directly from a GitHub repository.

**Features:**
- Host static HTML, CSS, and JavaScript
- Supports Jekyll for static site generation
- Custom domain support with HTTPS
- Source from root, `/docs`, or `gh-pages` branch
- Available for all public repositories (free plan)

**Setup options:**
1. Repository settings - Pages - choose source branch and folder
2. Use a Jekyll theme from the theme chooser
3. Use GitHub Actions for custom build and deploy

**URL format:**
- User/org site: `username.github.io` (from repo named `username.github.io`)
- Project site: `username.github.io/repository-name`

**[GitHub Pages](https://docs.github.com/en/pages)** - Pages documentation
**[Creating a GitHub Pages Site](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)** - Setup guide

## Repository Settings

### Features that can be enabled/disabled
- Issues
- Projects
- Wiki
- Discussions
- Sponsorship
- Preserve this repository (archiving)

### Branch Settings
- Default branch name
- Branch protection rules
- Automatic branch deletion after PR merge

### Collaboration Settings
- Manage access and invite collaborators
- Configure merge button options (merge, squash, rebase)
- Automatically delete head branches
- Allow auto-merge

**[Managing Repository Settings](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings)** - Settings reference

## Repository Navigation

### Key tabs in a repository
| Tab | Purpose |
|-----|---------|
| Code | Browse files, view README |
| Issues | Track bugs, features, tasks |
| Pull Requests | View and manage PRs |
| Actions | CI/CD workflows and runs |
| Projects | Project boards and tracking |
| Wiki | Documentation pages |
| Security | Security advisories, alerts |
| Insights | Activity, contributors, traffic |
| Settings | Repository configuration |

### Useful Features
- **Keyboard shortcuts** - Press `?` on any GitHub page
- **File finder** - Press `t` to search files in a repository
- **Command palette** - Press `Ctrl+K` / `Cmd+K` for quick navigation
- **Blame view** - See who last modified each line
- **History view** - See all commits for a specific file
- **Code navigation** - Click symbols to jump to definitions

**[Keyboard Shortcuts](https://docs.github.com/en/get-started/accessibility/keyboard-shortcuts)** - Shortcut reference

## Key Exam Points

- Know the three repository visibility options and when to use each
- Internal repos are only available in organizations
- `.gitignore` does not affect already-tracked files
- CODEOWNERS automatically assigns reviewers on pull requests
- Templates create new repos; forks create linked copies
- GitHub Pages hosts static content for free from public repos
- Community health files can be in root, `docs/`, or `.github/`
- A repository without a LICENSE defaults to all rights reserved
- README.md is automatically rendered on the repository page
- Forks maintain an upstream relationship; clones maintain an origin relationship
