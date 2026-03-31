# GitHub Foundations - Exam-Style Scenarios

## Scenario 1: Repository Setup and Collaboration

### Scenario
A small development team of 5 people is starting a new open source project. They want to allow external contributors while maintaining code quality. The team needs to set up their repository with appropriate settings and protection rules.

**Question:** Which combination of configurations should the team implement?

**Options:**
A. Create a private repository, add all contributors as collaborators, and require signed commits
B. Create a public repository, add branch protection rules requiring PR reviews, create CONTRIBUTING.md and CODE_OF_CONDUCT.md, and add a LICENSE file
C. Create an internal repository with a CODEOWNERS file and enable GitHub Discussions
D. Create a public repository with no branch protection and allow direct pushes to main

**Correct Answer:** B

**Explanation:**
- Public repository is needed for open source projects - external contributors can view and fork
- Branch protection with required PR reviews ensures code quality through peer review
- CONTRIBUTING.md provides guidelines for external contributors
- CODE_OF_CONDUCT.md establishes community behavior standards
- LICENSE file is essential for open source projects to define usage terms

**Why other options are wrong:**
- **A:** Private repository prevents external contributors from seeing or forking the code
- **C:** Internal repositories are only available within organizations, not for open source
- **D:** No branch protection means anyone with write access could push directly to main, risking code quality

---

## Scenario 2: Git Workflow and Commands

### Scenario
A developer has been working on a feature branch called `feature/login` and has made several commits. They want to incorporate the latest changes from the `main` branch into their feature branch before opening a pull request. They want to maintain a clean, linear commit history.

**Question:** Which Git command should the developer use?

**Options:**
A. `git merge main` (while on feature/login branch)
B. `git rebase main` (while on feature/login branch)
C. `git pull origin main` (while on feature/login branch)
D. `git cherry-pick main`

**Correct Answer:** B

**Explanation:**
- `git rebase main` replays the feature branch commits on top of the latest main branch commits
- This creates a clean, linear history without merge commits
- The developer should be on the feature/login branch when running this command
- After rebasing, the feature branch will appear as if it was started from the latest main

**Why other options are wrong:**
- **A:** `git merge main` would create a merge commit, not maintaining linear history
- **C:** `git pull origin main` would fetch and merge, also creating a merge commit
- **D:** `git cherry-pick` is for selecting specific commits, not integrating an entire branch

---

## Scenario 3: Pull Request and Code Review

### Scenario
A developer opens a pull request that fixes a critical bug. The repository has the following branch protection rules on `main`:
- Require at least 2 approving reviews
- Require status checks to pass (CI tests)
- Require conversation resolution

The CI tests pass, one reviewer approves, and there is one unresolved conversation. The developer wants to merge immediately because the bug is critical.

**Question:** What must happen before this PR can be merged?

**Options:**
A. The developer can force-merge since the bug is critical
B. The developer needs one more approving review and must resolve the unresolved conversation
C. Only the one unresolved conversation needs to be resolved since tests pass
D. An organization admin can bypass all branch protection rules to merge immediately

**Correct Answer:** B

**Explanation:**
- Branch protection rules are enforced - ALL conditions must be met
- The PR currently has: 1 approval (needs 2), passing CI (met), 1 unresolved conversation (needs 0)
- Two remaining requirements: get a second approving review AND resolve the conversation
- Even critical bugs must follow the established process for code quality

**Why other options are wrong:**
- **A:** There is no force-merge option that bypasses branch protection for regular users
- **C:** The PR also needs a second approving review (only has 1 of required 2)
- **D:** While admins can include an option to allow bypassing, this is a separate setting and not the default behavior

---

## Scenario 4: GitHub Actions Basics

### Scenario
A team wants to automatically run their test suite every time someone pushes code to any branch and whenever a pull request is opened against the `main` branch. They also want tests to run on a schedule every night at midnight.

**Question:** Which workflow trigger configuration correctly implements these requirements?

**Options:**
A.
```yaml
on:
  push:
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * *'
```

B.
```yaml
on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: '0 0 * * *'
```

C.
```yaml
on:
  push:
  pull_request:
  schedule:
    - cron: 'midnight'
```

D.
```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * *'
```

**Correct Answer:** A

**Explanation:**
- `push:` with no branch filter triggers on pushes to ANY branch (requirement 1)
- `pull_request: branches: [main]` triggers when PRs target the main branch (requirement 2)
- `schedule: cron: '0 0 * * *'` runs at midnight UTC daily (requirement 3)
- All three requirements are met with this configuration

**Why other options are wrong:**
- **B:** `push: branches: [main]` only triggers on pushes to main, not all branches
- **C:** `cron: 'midnight'` is not valid cron syntax - must use standard 5-field format
- **D:** `push: branches: [main]` limits push triggers to only the main branch

---

## Scenario 5: Fork and Clone Workflow

### Scenario
A developer wants to contribute to an open source project on GitHub. They do not have write access to the original repository. They need to make changes and submit them for review by the project maintainers.

**Question:** What is the correct workflow for this developer?

**Options:**
A. Clone the repository, create a branch, make changes, and push directly to the original repository
B. Fork the repository, clone the fork locally, create a branch, make changes, push to the fork, and open a pull request to the original repository
C. Download the repository as a ZIP, make changes, and email the maintainers
D. Clone the repository, make changes on main, and open a pull request from the local clone

**Correct Answer:** B

**Explanation:**
- Forking creates a server-side copy under the developer's account
- Cloning the fork creates a local working copy
- Working on a branch keeps changes organized and the fork's main clean
- Pushing to the fork updates the developer's server-side copy
- Opening a PR from fork to original repository submits changes for review
- This is the standard open source contribution workflow

**Why other options are wrong:**
- **A:** Without write access, the developer cannot push directly to the original repository
- **C:** This bypasses GitHub's collaboration features entirely and is not standard practice
- **D:** Without write access, the developer cannot push to the original repository at all

---

## Scenario 6: Security and Access Management

### Scenario
An organization admin notices that a team member accidentally committed an API key to a public repository. The commit has already been pushed to GitHub.

**Question:** What should the admin do to handle this situation? (Select the BEST answer)

**Options:**
A. Delete the commit from the repository history and the API key will be safe
B. Immediately rotate/revoke the exposed API key, remove the secret from the repository (using git filter-branch or BFG), enable secret scanning to prevent future incidents, and review the audit log
C. Make the repository private to hide the exposed key
D. Simply delete the file containing the key and push a new commit

**Correct Answer:** B

**Explanation:**
- The API key must be rotated/revoked immediately since it was exposed publicly
- Simply removing the file does not remove it from Git history
- Git filter-branch or BFG Repo-Cleaner can remove secrets from history
- Enabling secret scanning prevents similar incidents in the future
- Audit log review helps understand the scope of potential exposure

**Why other options are wrong:**
- **A:** Even if the commit is removed from history, it may have been cached, forked, or scraped
- **C:** Making the repository private does not revoke the already-exposed key
- **D:** The key remains in Git history even if the file is deleted in a new commit

---

## Scenario 7: GitHub Projects and Issue Management

### Scenario
A product manager is planning a quarterly release with 30 features across 3 teams. They need to track progress, visualize work status, and filter by team. Each team works across multiple repositories.

**Question:** Which GitHub feature best fits this use case?

**Options:**
A. Create a classic project board in one repository with columns for each status
B. Use GitHub Projects (new) with custom fields for team, status views, and cross-repository issue tracking
C. Create separate milestone in each repository and track progress independently
D. Use GitHub Discussions to coordinate work across teams

**Correct Answer:** B

**Explanation:**
- GitHub Projects (new) supports cross-repository issue tracking - essential for 3 teams
- Custom fields allow adding "Team" as a single-select field for filtering
- Multiple views (table, board, roadmap) provide different perspectives
- Built-in workflows can automate status changes
- Insights provide progress visualization

**Why other options are wrong:**
- **A:** Classic project boards are limited in scope and lack custom fields for team filtering
- **C:** Separate milestones per repository create silos and no unified tracking view
- **D:** Discussions are for conversations, not project tracking and visualization

---

## Scenario 8: Open Source Licensing

### Scenario
A company wants to create an open source library that other companies can use in their commercial products without restriction. However, they want any modifications to the library itself to remain open source.

**Question:** Which license best fits this requirement?

**Options:**
A. MIT License - allows any use with minimal restrictions
B. GNU GPL v3 - requires all derivative works to be open source
C. GNU LGPL v3 - allows linking in proprietary software but modifications to the library must stay open source
D. Apache License 2.0 - allows any use but includes patent protection

**Correct Answer:** C

**Explanation:**
- LGPL allows the library to be used (linked) in commercial/proprietary products
- Any modifications to the LGPL-licensed library itself must remain open source
- This balances commercial friendliness with protecting the library's open source nature
- This is commonly used for libraries and frameworks

**Why other options are wrong:**
- **A:** MIT allows modifications to remain closed source - does not meet the requirement
- **B:** GPL requires ALL derivative works (including products using the library) to be open source - too restrictive for commercial use
- **D:** Apache 2.0 allows modifications to remain closed source - does not meet the requirement
