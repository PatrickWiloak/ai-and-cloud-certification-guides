# GitHub Advanced Security Study Plan

## 6-Week Study Schedule

### Week 1: GHAS Overview and Licensing

#### Day 1-2: What GHAS Is
- [ ] Read the GHAS overview docs
- [ ] List the features included and excluded from GHAS licensing
- [ ] Identify which features are free on public repos vs paid on private
- [ ] Review Notes: `notes/01-ghas-overview-and-licensing.md`
- [ ] Read: [About GHAS](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)

#### Day 3-4: Licensing and Active Committers
- [ ] Understand the active committer definition (push in 90 days)
- [ ] Walk through a sample seat calculation
- [ ] Understand how committers across multiple repos consume a single seat
- [ ] Read: [GHAS Billing](https://docs.github.com/en/billing/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security)

#### Day 5-6: Enablement and Security Configurations
- [ ] Enable GHAS on a sandbox repository
- [ ] Create a security configuration at org level
- [ ] Apply the configuration to multiple repos
- [ ] Mark a configuration as default for new repos
- [ ] Read: [Security Configurations](https://docs.github.com/en/code-security/securing-your-organization/introduction-to-securing-your-organization-at-scale/about-enabling-security-features-at-scale)

#### Day 7: Week 1 Review
- [ ] Summarize licensing rules on one page
- [ ] Quiz yourself on which features require GHAS
- [ ] Review the security configuration workflow

### Week 2: Code Scanning and CodeQL (Part 1)

#### Day 8-9: Code Scanning Basics
- [ ] Enable default setup on a test repo
- [ ] Review the alerts that appear after the first run
- [ ] Dismiss an alert with each dismissal reason
- [ ] Review Notes: `notes/02-code-scanning-and-codeql.md`
- [ ] Read: [About Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)

#### Day 10-11: Advanced Setup
- [ ] Convert a repo from default to advanced setup
- [ ] Customize the workflow to add `security-extended` queries
- [ ] Configure a schedule and paths-ignore
- [ ] Trigger a scan on PR and review the status check
- [ ] Read: [CodeQL Query Suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/codeql-query-suites)

#### Day 12-13: SARIF and Third-Party Tools
- [ ] Upload a SARIF file from a third-party tool (Semgrep or Snyk)
- [ ] Verify alerts appear with correct rule IDs
- [ ] Understand fingerprints and deduplication
- [ ] Read: [SARIF Support](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning)

#### Day 14: Week 2 Review
- [ ] Summarize default vs advanced setup
- [ ] List CodeQL languages and query suites
- [ ] Review alert lifecycle states

### Week 3: Code Scanning (Part 2) and Autofix

#### Day 15-16: CodeQL Queries and Packs
- [ ] Run a CodeQL database build locally with the CLI
- [ ] Run a built-in query against the database
- [ ] Modify a query and observe new results
- [ ] Understand CodeQL packs and how to distribute custom queries

#### Day 17-18: Copilot Autofix
- [ ] Trigger a code scanning alert in a PR
- [ ] Review the Autofix suggestion
- [ ] Apply, edit, or discard the fix
- [ ] Understand responsible use in AI fix acceptance

#### Day 19-20: Branch Protection and Rulesets
- [ ] Require code scanning status checks for the default branch
- [ ] Configure severity-based gates via rulesets
- [ ] Review how failures block merges
- [ ] Read: [Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

#### Day 21: Week 3 Review
- [ ] Review Notes: `notes/02-code-scanning-and-codeql.md`
- [ ] Practice reading a SARIF file
- [ ] Write a minimal code scanning workflow from memory

### Week 4: Secret Scanning, Push Protection, and Dependabot

#### Day 22-23: Secret Scanning
- [ ] Enable secret scanning on a sandbox repo
- [ ] Commit a fake but well-formed AWS key and observe the alert
- [ ] Review validity check status
- [ ] Create a custom pattern and verify it detects a known sample
- [ ] Review Notes: `notes/03-secret-scanning-and-push-protection.md`
- [ ] Read: [About Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)

#### Day 24-25: Push Protection
- [ ] Enable push protection on the repo
- [ ] Attempt to push a commit with a detected secret; observe the block
- [ ] Bypass with each reason and review the audit log
- [ ] Configure delegated bypass at org level
- [ ] Read: [Push Protection](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/push-protection-for-repositories-and-organizations)

#### Day 26-27: Dependabot and Dependency Review
- [ ] Create a `.github/dependabot.yml` with npm and github-actions ecosystems
- [ ] Enable Dependabot security updates
- [ ] Observe grouped update PRs
- [ ] Add the `dependency-review-action` to a CI workflow
- [ ] Intentionally introduce a vulnerable dep in a PR and watch the block
- [ ] Review Notes: `notes/04-dependency-review-and-dependabot.md`
- [ ] Read: [Dependabot Options](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference)

#### Day 28: Week 4 Review
- [ ] Review the full alert types: code scanning, secret scanning, Dependabot
- [ ] Practice writing `dependabot.yml` fragments
- [ ] Summarize push protection bypass behavior

### Week 5: Advisories, Vulnerability Management, and Administration

#### Day 29-30: Security Advisories
- [ ] Create a draft security advisory on a test repo
- [ ] Use a private fork for coordinated fix development
- [ ] Request a CVE assignment
- [ ] Publish the advisory and observe Global Advisory Database flow
- [ ] Review Notes: `notes/05-security-advisories-and-vulnerability-management.md`
- [ ] Read: [About Repository Advisories](https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/about-repository-security-advisories)

#### Day 31-32: Private Vulnerability Reporting
- [ ] Enable private vulnerability reporting at org and repo level
- [ ] Walk through the reporter flow using a test repo
- [ ] Review triage workflow and severity scoring

#### Day 33-34: Administration and Reporting
- [ ] Explore the organization Security Overview dashboard
- [ ] Review coverage per repo and filter by risk
- [ ] Export alerts via the REST API
- [ ] Review Notes: `notes/06-ghas-administration-and-enterprise-rollout.md`
- [ ] Read: [Security Overview](https://docs.github.com/en/code-security/security-overview/about-the-security-overview)

#### Day 35: Week 5 Review
- [ ] Summarize advisory publication flow
- [ ] Review security overview widgets
- [ ] Practice API calls to list alerts

### Week 6: Final Review and Mock Exams

#### Day 36-37: Comprehensive Review
- [ ] Re-read fact-sheet.md top to bottom
- [ ] Review all six notes files
- [ ] Build flashcards for query suites, alert types, and YAML options

#### Day 38-39: Scenarios and Practice
- [ ] Work through scenarios.md
- [ ] Review every wrong answer with the relevant doc

#### Day 40-41: Mock Exams
- [ ] Take any available practice exam under 120-minute timing
- [ ] Revisit weak domains

#### Day 42: Exam Day
- [ ] Light fact-sheet review
- [ ] Confirm ID, webcam, quiet room
- [ ] Take the exam with confidence

## Study Tips

### Time Allocation by Domain Weight

| Domain | Weight | Suggested Hours |
|--------|--------|----------------|
| Code Scanning and CodeQL | 25% | 15-20 hours |
| Secret Scanning and Push Protection | 20% | 10-14 hours |
| Dependency Review and Dependabot | 20% | 10-14 hours |
| GHAS Overview and Licensing | 15% | 7-10 hours |
| Security Advisories | 10% | 5-7 hours |
| Administration | 10% | 5-7 hours |

### Recommended Daily Schedule
- **30 min** reading GHAS docs or notes
- **45 min** hands-on in a sandbox org
- **15 min** flashcards on query suites, YAML, and alerts
- **Total: ~1.5 hours/day**

### Hands-On Labs
1. Enable default code scanning on a Node.js app; review initial alerts
2. Upload a Semgrep SARIF file and confirm alerts
3. Create a custom secret scanning pattern for an internal token format
4. Write a `dependabot.yml` covering three ecosystems with grouped updates
5. Create, coordinate, and publish a repository security advisory end-to-end
6. Build a security configuration and apply it to five repos at once
