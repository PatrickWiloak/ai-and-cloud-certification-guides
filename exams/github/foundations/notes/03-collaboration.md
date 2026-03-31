# Collaboration Features

## Issues

Issues are the primary way to track work on GitHub - bugs, feature requests, tasks, and discussions.

**[About Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues)** - Issues overview
**[Creating an Issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue)** - Issue creation

### Issue Components
- **Title** - Brief description of the issue
- **Description** - Detailed information with Markdown formatting
- **Labels** - Categorize issues (bug, enhancement, help wanted, etc.)
- **Assignees** - Who is responsible for the issue
- **Milestones** - Group issues for tracking toward a goal
- **Projects** - Add to project boards for visual tracking
- **Linked pull requests** - PRs that address this issue

### Issue Templates
- Define templates in `.github/ISSUE_TEMPLATE/` directory
- Can create multiple templates (bug report, feature request, etc.)
- Templates can include pre-filled sections and labels
- Config file (`.github/ISSUE_TEMPLATE/config.yml`) controls template chooser

**[Configuring Issue Templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)** - Template setup

### Linking Issues to Pull Requests
Use keywords in PR descriptions or commit messages to auto-close issues:
- `fixes #123`
- `closes #123`
- `resolves #123`

The issue is automatically closed when the PR is merged to the default branch.

**[Linking a PR to an Issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)** - Linking guide

### Task Lists
```markdown
- [x] Completed task
- [ ] Incomplete task
- [ ] Another task
```
Task lists in issues show progress tracking in the issue list view.

### Labels
- Color-coded tags for categorizing issues and PRs
- Default labels: bug, documentation, duplicate, enhancement, good first issue, help wanted, invalid, question, wontfix
- Custom labels can be created at the repository or organization level
- Can be used for filtering and searching

**[Managing Labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)** - Label management

## Pull Requests

Pull requests are the primary mechanism for proposing and reviewing changes on GitHub.

**[About Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)** - PR overview

### Pull Request Lifecycle
1. **Create a branch** from the base branch (usually `main`)
2. **Make commits** with your changes
3. **Open a pull request** comparing your branch to the base
4. **Request reviewers** and address their feedback
5. **Pass status checks** (CI tests, required reviews)
6. **Merge the pull request** using chosen merge strategy
7. **Delete the branch** (optional, but recommended)

### Creating a Pull Request
- Compare two branches (head branch to base branch)
- Write a title and description explaining the changes
- Reference issues using keywords (fixes, closes, resolves)
- Add reviewers, assignees, labels, projects, and milestones
- Can create from GitHub.com, CLI, or GitHub Desktop

**[Creating a Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)** - PR creation guide

### Draft Pull Requests
- Signal that work is in progress (not ready for review)
- Cannot be merged while in draft status
- Useful for early feedback and discussion
- Convert to "ready for review" when complete
- Status checks still run on draft PRs

**[About Draft Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests)** - Draft PR documentation

### PR Templates
- Define in `.github/PULL_REQUEST_TEMPLATE.md`
- Auto-populates description when creating new PRs
- Can include checklists, sections, and guidelines
- Multiple templates supported in `.github/PULL_REQUEST_TEMPLATE/` directory

## Code Review

Code review is the process of examining proposed changes before they are merged.

**[Reviewing Changes in Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests)** - Review guide

### Review Types
| Review Type | Meaning | Effect |
|------------|---------|--------|
| Approve | Changes look good | Counts toward required approvals |
| Request changes | Issues need fixing | Blocks merge (if required) |
| Comment | General feedback | Neither approves nor blocks |

### Review Features
- **Inline comments** - Comment on specific lines of code
- **Suggested changes** - Propose exact code changes that can be committed directly
- **Batch comments** - Start a review, add multiple comments, submit at once
- **Re-request review** - Ask a reviewer to look again after changes
- **Dismiss review** - Organization owners can dismiss stale reviews

### Code Review Best Practices
- Review the overall approach before diving into details
- Be constructive and specific in feedback
- Use suggestions for small changes
- Approve when satisfied, even if minor issues remain
- Request changes only for blocking issues

**[About Pull Request Reviews](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews)** - Review process

## Merge Strategies

**[About Merge Methods](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)** - Merge method comparison

### Merge Commit (Create a merge commit)
- Creates a new merge commit that combines both branches
- Preserves all individual commits from the feature branch
- Git history shows the full development path
- Default merge method on GitHub

```
main:    A---B-------M
              \     /
feature:       C---D
```

### Squash and Merge
- Combines all feature branch commits into a single commit
- Creates a clean, linear history on the base branch
- Individual commit messages are combined into one
- Good for feature branches with many small/messy commits

```
main:    A---B---S (squashed commit containing C+D)
              \
feature:       C---D
```

### Rebase and Merge
- Replays feature branch commits on top of the base branch
- Creates a linear history without merge commits
- Each original commit is preserved individually
- Commit hashes change during rebase

```
main:    A---B---C'---D' (rebased commits)
```

### When to Use Each
| Strategy | Best For | History |
|----------|----------|---------|
| Merge commit | Default, preserving full context | Complete with merge commits |
| Squash | Many small commits, cleanup | Clean, single commit per PR |
| Rebase | Clean history, few commits | Linear, no merge commits |

## Branch Protection Rules

Branch protection rules enforce workflows and prevent accidental changes to important branches.

**[About Protected Branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)** - Protection overview

### Available Rules
- **Require pull request reviews** - Set minimum number of approving reviews
- **Require status checks** - CI/CD must pass before merge
- **Require conversation resolution** - All discussions must be resolved
- **Require signed commits** - Verify commit authorship
- **Require linear history** - No merge commits allowed
- **Include administrators** - Rules apply to admins too
- **Restrict who can push** - Limit push access to specific people/teams
- **Require code owner reviews** - CODEOWNERS must approve their areas
- **Lock branch** - Make branch read-only

### Branch Protection Patterns
- Exact match: `main`
- Wildcard: `release/*` (matches release/v1.0, release/v2.0)
- Can protect multiple branch patterns

**[Managing Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)** - Rule configuration

## Notifications and Subscriptions

### Notification Triggers
- Assigned to an issue or PR
- Requested as a reviewer
- @mentioned in a comment
- Subscribed to a thread or repository
- Watching a repository
- Team mention

### Notification Channels
- **GitHub inbox** - Web-based notification center
- **Email** - Configurable per-repository
- **GitHub Mobile** - Push notifications on mobile

### Subscription Levels
- **Watch** - All activity in the repository
- **Not watching** - Only participating or @mentioned
- **Ignore** - No notifications at all
- **Custom** - Choose specific events

**[About Notifications](https://docs.github.com/en/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/about-notifications)** - Notification settings
**[Configuring Notifications](https://docs.github.com/en/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/configuring-notifications)** - Notification configuration

## GitHub Discussions

- Forum-style conversations separate from issues
- Categories: Announcements, General, Ideas, Polls, Q&A, Show and tell
- Q&A discussions can have accepted answers
- Converts between issues and discussions
- Supports threaded replies
- Available at repository or organization level

**[About GitHub Discussions](https://docs.github.com/en/discussions)** - Discussions documentation

## Key Exam Points

- Pull requests are the primary collaboration mechanism on GitHub
- Draft PRs cannot be merged and signal work in progress
- Three review types: approve, request changes, comment
- Keywords (fixes, closes, resolves) auto-close issues when PR is merged
- Squash merge creates one commit; merge commit preserves all; rebase creates linear history
- Branch protection rules are enforced - all conditions must be met to merge
- CODEOWNERS assigns reviewers automatically based on file patterns
- Notifications can be configured per repository and per thread
- Discussions are for conversations; issues are for tracking work
- Labels can be used across issues and pull requests for filtering
