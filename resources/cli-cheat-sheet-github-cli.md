# GitHub CLI (gh) Cheat Sheet

Quick reference for the GitHub CLI used to manage repositories, pull requests, issues, and automation from the terminal.

**Official Documentation:** https://cli.github.com/manual/

---

## Table of Contents

- [Authentication](#authentication)
- [Repository Operations](#repository-operations)
- [Pull Requests](#pull-requests)
- [Issues](#issues)
- [GitHub Actions](#github-actions)
- [Codespaces](#codespaces)
- [Releases and Tags](#releases-and-tags)
- [API Command](#api-command)
- [Gists](#gists)
- [Aliases and Extensions](#aliases-and-extensions)
- [Configuration](#configuration)

---

## Authentication

```bash
# Login interactively (browser-based)
gh auth login

# Login with a specific host (GitHub Enterprise)
gh auth login --hostname github.example.com

# Login with a token
gh auth login --with-token < token.txt

# Login with a specific protocol
gh auth login --git-protocol ssh

# Check authentication status
gh auth status

# View the current auth token
gh auth token

# Refresh authentication scopes
gh auth refresh --scopes repo,read:org

# Switch between accounts
gh auth switch

# Logout
gh auth logout

# Set up Git credential helper
gh auth setup-git
```

---

## Repository Operations

```bash
# Create a new repository
gh repo create my-repo

# Create a public repository
gh repo create my-repo --public

# Create a private repository with description
gh repo create my-repo --private --description "My project"

# Create from a template
gh repo create my-repo --template owner/template-repo

# Create and clone locally
gh repo create my-repo --public --clone

# Initialize with README and license
gh repo create my-repo --public --add-readme --license mit

# Clone a repository
gh repo clone owner/repo

# Clone to a specific directory
gh repo clone owner/repo my-directory

# Fork a repository
gh repo fork owner/repo

# Fork and clone
gh repo fork owner/repo --clone

# View repository info
gh repo view

# View in browser
gh repo view --web

# View a specific repository
gh repo view owner/repo

# List your repositories
gh repo list

# List repositories for an org
gh repo list my-org

# List with filters
gh repo list --language go --limit 20

# List public repos only
gh repo list --visibility public

# Archive a repository
gh repo archive owner/repo

# Delete a repository
gh repo delete owner/repo --yes

# Rename a repository
gh repo rename new-name

# Edit repository settings
gh repo edit --default-branch main
gh repo edit --visibility private
gh repo edit --enable-issues=false

# Sync a fork with upstream
gh repo sync owner/fork

# Set default repository for commands
gh repo set-default owner/repo

# View repository README
gh repo view owner/repo --json readme --jq '.readme'
```

---

## Pull Requests

```bash
# Create a pull request interactively
gh pr create

# Create with title and body
gh pr create --title "Add feature" --body "Description here"

# Create with specific base branch
gh pr create --base main --head feature-branch

# Create as draft
gh pr create --draft

# Create with reviewers
gh pr create --reviewer user1,user2

# Create with assignees
gh pr create --assignee @me

# Create with labels
gh pr create --label "bug,priority:high"

# Create and fill from commit messages
gh pr create --fill

# Create from a specific template
gh pr create --template "bug_report.md"

# List pull requests
gh pr list

# List with filters
gh pr list --state open
gh pr list --state closed
gh pr list --state merged
gh pr list --author @me
gh pr list --label bug
gh pr list --base main
gh pr list --assignee @me
gh pr list --draft

# List with search query
gh pr list --search "is:open review:required"

# View a pull request
gh pr view 123

# View in browser
gh pr view 123 --web

# View current branch PR
gh pr view

# View PR as JSON
gh pr view 123 --json title,body,state,reviews

# Checkout a pull request locally
gh pr checkout 123

# Checkout and create a local branch
gh pr checkout 123 --branch my-local-branch

# Show PR diff
gh pr diff 123

# Review a pull request
gh pr review 123

# Approve a pull request
gh pr review 123 --approve

# Request changes
gh pr review 123 --request-changes --body "Please fix the tests"

# Comment on a PR
gh pr review 123 --comment --body "Looks good overall"

# Add a comment (not a review)
gh pr comment 123 --body "Thanks for the update"

# Merge a pull request
gh pr merge 123

# Merge with a specific method
gh pr merge 123 --merge
gh pr merge 123 --squash
gh pr merge 123 --rebase

# Merge and delete branch
gh pr merge 123 --squash --delete-branch

# Auto-merge when checks pass
gh pr merge 123 --auto --squash

# Disable auto-merge
gh pr merge 123 --disable-auto

# Close a pull request
gh pr close 123

# Reopen a pull request
gh pr reopen 123

# Mark as ready for review (from draft)
gh pr ready 123

# Convert to draft
gh pr ready 123 --undo

# Edit a pull request
gh pr edit 123 --title "New title"
gh pr edit 123 --add-label "reviewed"
gh pr edit 123 --remove-label "wip"
gh pr edit 123 --add-reviewer user1
gh pr edit 123 --add-assignee @me

# View PR checks
gh pr checks 123

# Watch PR checks
gh pr checks 123 --watch

# Lock a PR conversation
gh pr lock 123

# Unlock a PR conversation
gh pr unlock 123
```

---

## Issues

```bash
# Create an issue interactively
gh issue create

# Create with title and body
gh issue create --title "Bug report" --body "Description"

# Create with labels and assignee
gh issue create --title "Fix login" --label bug --assignee @me

# Create from a template
gh issue create --template "bug_report.md"

# Create in a specific project
gh issue create --project "Sprint Board"

# List issues
gh issue list

# List with filters
gh issue list --state open
gh issue list --state closed
gh issue list --author @me
gh issue list --assignee @me
gh issue list --label "bug"
gh issue list --milestone "v1.0"

# List with search
gh issue list --search "is:open label:bug sort:created-desc"

# View an issue
gh issue view 456

# View in browser
gh issue view 456 --web

# View as JSON
gh issue view 456 --json title,body,labels,assignees

# Close an issue
gh issue close 456

# Close with a reason
gh issue close 456 --reason "not planned"

# Reopen an issue
gh issue reopen 456

# Comment on an issue
gh issue comment 456 --body "Working on this now"

# Edit an issue
gh issue edit 456 --title "Updated title"
gh issue edit 456 --add-label "priority:high"
gh issue edit 456 --remove-label "triage"
gh issue edit 456 --add-assignee user1
gh issue edit 456 --milestone "v2.0"

# Pin an issue
gh issue pin 456

# Unpin an issue
gh issue unpin 456

# Transfer an issue to another repo
gh issue transfer 456 owner/other-repo

# Delete an issue
gh issue delete 456

# Lock an issue
gh issue lock 456

# Unlock an issue
gh issue unlock 456

# Develop on an issue (create branch)
gh issue develop 456

# List issue labels
gh label list

# Create a label
gh label create "priority:high" --color FF0000 --description "High priority"
```

---

## GitHub Actions

```bash
# List workflow runs
gh run list

# List runs for a specific workflow
gh run list --workflow build.yml

# List runs with filters
gh run list --status failure
gh run list --branch main
gh run list --user @me

# View a specific run
gh run view 12345

# View run in browser
gh run view 12345 --web

# View run logs
gh run view 12345 --log

# View failed step logs
gh run view 12345 --log-failed

# Watch a run in progress
gh run watch 12345

# Download run artifacts
gh run download 12345

# Download specific artifact
gh run download 12345 --name my-artifact

# Rerun a workflow
gh run rerun 12345

# Rerun only failed jobs
gh run rerun 12345 --failed

# Cancel a workflow run
gh run cancel 12345

# Delete a workflow run
gh run delete 12345

# List workflows
gh workflow list

# View workflow details
gh workflow view build.yml

# Run a workflow manually (workflow_dispatch)
gh workflow run build.yml

# Run with inputs
gh workflow run build.yml --field environment=production

# Run on a specific branch
gh workflow run build.yml --ref feature-branch

# Enable/disable a workflow
gh workflow enable build.yml
gh workflow disable build.yml

# View workflow YAML
gh workflow view build.yml --yaml

# List caches
gh cache list

# Delete a cache
gh cache delete cache-key
```

---

## Codespaces

```bash
# Create a codespace
gh codespace create

# Create for a specific repo and branch
gh codespace create --repo owner/repo --branch main

# Create with a specific machine type
gh codespace create --machine standardLinux32gb

# List codespaces
gh codespace list

# Open a codespace in browser
gh codespace code --web

# Open in VS Code desktop
gh codespace code

# SSH into a codespace
gh codespace ssh

# Stop a codespace
gh codespace stop

# Delete a codespace
gh codespace delete

# View codespace logs
gh codespace logs

# Port forwarding
gh codespace ports forward 8080:8080

# List forwarded ports
gh codespace ports

# Copy files to/from codespace
gh codespace cp local-file.txt remote:/path/
gh codespace cp remote:/path/file.txt ./local/
```

---

## Releases and Tags

```bash
# Create a release
gh release create v1.0.0

# Create with title and notes
gh release create v1.0.0 --title "Version 1.0" --notes "First stable release"

# Create from a specific branch/commit
gh release create v1.0.0 --target main

# Create a draft release
gh release create v1.0.0 --draft

# Create a prerelease
gh release create v1.0.0 --prerelease

# Create with auto-generated notes
gh release create v1.0.0 --generate-notes

# Upload assets with a release
gh release create v1.0.0 ./dist/app-linux ./dist/app-macos

# List releases
gh release list

# View a release
gh release view v1.0.0

# View latest release
gh release view --latest

# Download release assets
gh release download v1.0.0

# Download specific asset
gh release download v1.0.0 --pattern "*.tar.gz"

# Edit a release
gh release edit v1.0.0 --title "Updated Title"

# Delete a release
gh release delete v1.0.0

# Upload assets to existing release
gh release upload v1.0.0 ./new-asset.zip
```

---

## API Command

```bash
# GET request
gh api repos/owner/repo

# POST request
gh api repos/owner/repo/issues -f title="Bug" -f body="Description"

# PATCH request
gh api repos/owner/repo/issues/123 -X PATCH -f state=closed

# DELETE request
gh api repos/owner/repo/issues/123/labels/bug -X DELETE

# Use GraphQL
gh api graphql -f query='
  query {
    viewer {
      login
      repositories(first: 10) {
        nodes { name }
      }
    }
  }
'

# Paginate results
gh api repos/owner/repo/issues --paginate

# Use JQ for filtering
gh api repos/owner/repo/pulls --jq '.[].title'

# Set custom headers
gh api repos/owner/repo -H "Accept: application/vnd.github.v3+json"

# Use with GitHub Enterprise
gh api --hostname github.example.com repos/owner/repo

# View rate limit
gh api rate_limit

# View specific fields
gh api repos/owner/repo --jq '{name: .name, stars: .stargazers_count}'

# List PR comments
gh api repos/owner/repo/pulls/123/comments --jq '.[].body'

# Get organization members
gh api orgs/my-org/members --jq '.[].login'
```

---

## Gists

```bash
# Create a gist from a file
gh gist create file.txt

# Create a public gist
gh gist create --public file.txt

# Create with a description
gh gist create --desc "My code snippet" file.py

# Create from multiple files
gh gist create file1.py file2.py

# Create from stdin
echo "Hello" | gh gist create

# List your gists
gh gist list

# View a gist
gh gist view GIST_ID

# Edit a gist
gh gist edit GIST_ID

# Delete a gist
gh gist delete GIST_ID

# Clone a gist
gh gist clone GIST_ID

# Rename a file in a gist
gh gist rename GIST_ID old-name.txt new-name.txt
```

---

## Aliases and Extensions

### Aliases

```bash
# List aliases
gh alias list

# Create an alias
gh alias set pv 'pr view'
gh alias set co 'pr checkout'
gh alias set myissues 'issue list --assignee @me'

# Create a complex alias with shell
gh alias set --shell prdiff 'gh pr diff $1 | delta'

# Delete an alias
gh alias delete pv

# Import aliases from a file
gh alias import aliases.yml
```

### Extensions

```bash
# List installed extensions
gh extension list

# Browse available extensions
gh extension browse

# Install an extension
gh extension install owner/gh-extension-name

# Popular extensions:
gh extension install dlvhdr/gh-dash          # Dashboard TUI
gh extension install vilmibm/gh-screensaver  # Fun screensaver
gh extension install mislav/gh-branch-clean  # Clean merged branches
gh extension install seachicken/gh-poi       # Delete merged branches

# Upgrade extensions
gh extension upgrade --all
gh extension upgrade owner/gh-extension-name

# Remove an extension
gh extension remove owner/gh-extension-name

# Create a new extension
gh extension create my-extension
```

---

## Configuration

```bash
# View current configuration
gh config list

# Set default editor
gh config set editor vim

# Set default browser
gh config set browser firefox

# Set default git protocol
gh config set git_protocol ssh

# Set pager
gh config set pager less

# Get a config value
gh config get editor

# Set prompt preference
gh config set prompt disabled

# Environment variables
GH_TOKEN          # Authentication token
GH_ENTERPRISE_TOKEN  # Enterprise token
GH_HOST           # Default host
GH_REPO           # Default repository
GH_EDITOR         # Editor
GH_BROWSER        # Browser
GH_PAGER          # Pager
GH_DEBUG          # Enable debug logging
NO_COLOR          # Disable color output

# Shell completion (bash)
eval "$(gh completion -s bash)"
echo 'eval "$(gh completion -s bash)"' >> ~/.bashrc

# Shell completion (zsh)
eval "$(gh completion -s zsh)"
echo 'eval "$(gh completion -s zsh)"' >> ~/.zshrc

# JSON output for scripting
gh pr list --json number,title,author
gh issue list --json number,title,labels --jq '.[] | select(.labels[].name == "bug")'
```

---

## Resources

- GitHub CLI Manual: https://cli.github.com/manual/
- GitHub CLI Repository: https://github.com/cli/cli
- GitHub REST API: https://docs.github.com/en/rest
- GitHub GraphQL API: https://docs.github.com/en/graphql
- GitHub CLI Extensions: https://github.com/topics/gh-extension
