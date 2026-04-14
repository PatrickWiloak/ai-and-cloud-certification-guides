# GitHub Advanced Security Study Strategy

## Study Approach

### Phase 1: Platform and Licensing (Week 1)

**Goal:** Understand what GHAS is, what it includes, and how it is licensed.

1. **Feature Inventory**
   - Code scanning (CodeQL + SARIF)
   - Secret scanning, push protection, custom patterns, validity checks
   - Dependency graph, Dependabot alerts, security updates, version updates
   - Security advisories, Global Advisory Database
   - Security overview dashboards

2. **Free vs Licensed**
   - Public repos: most features are free
   - Private repos: code scanning and secret scanning require GHAS
   - Dependabot and dependency graph are free on private repos

3. **Licensing Model**
   - GHAS is licensed per active committer
   - Active committer: pushed a commit in the last 90 days to a GHAS-enabled repo
   - Committer counts once per enterprise regardless of repo count

4. **Phase 1 Resources**
   - **[About GHAS](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)**
   - **[GHAS Billing](https://docs.github.com/en/billing/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security)**
   - **[Security Configurations](https://docs.github.com/en/code-security/securing-your-organization/introduction-to-securing-your-organization-at-scale/about-enabling-security-features-at-scale)**

### Phase 2: Code Scanning Depth (Week 2-3)

**Goal:** Master code scanning configuration, CodeQL query suites, SARIF, and the alert lifecycle.

1. **Setup Options**
   - Default setup: no YAML, GitHub-managed
   - Advanced setup: custom workflow with full control
   - Switching between the two

2. **CodeQL**
   - Supported languages and build modes
   - Query suites: `code-scanning`, `security-extended`, `security-and-quality`
   - Custom queries and CodeQL packs
   - Local analysis with the CodeQL CLI

3. **SARIF**
   - Upload from any third-party SAST tool
   - Required fields: ruleId, level, message, locations, partialFingerprints

4. **Alert Lifecycle**
   - Open, fixed, dismissed (false positive, won't fix, used in tests)
   - Branch protection integration via required status checks
   - Copilot Autofix for eligible plans

5. **Phase 2 Resources**
   - **[Code Scanning Docs](https://docs.github.com/en/code-security/code-scanning)**
   - **[CodeQL Documentation](https://codeql.github.com/)**
   - **[SARIF Support](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning)**

### Phase 3: Secrets and Supply Chain (Week 4)

**Goal:** Understand secret scanning, push protection, Dependabot, and dependency review deeply.

1. **Secret Scanning**
   - Partner, GitHub, and custom patterns
   - Validity checks where supported
   - Non-provider pattern detection (when enabled)

2. **Push Protection**
   - Blocks pushes containing detected secrets
   - Bypass reasons and audit events
   - Delegated bypass for controlled environments

3. **Dependabot**
   - Alerts for known vulnerabilities in dependency graph
   - Security updates vs version updates
   - `dependabot.yml` syntax and grouped updates

4. **Dependency Review**
   - PR UI showing dep changes
   - `dependency-review-action` with severity and license gating

5. **Phase 3 Resources**
   - **[Secret Scanning Docs](https://docs.github.com/en/code-security/secret-scanning)**
   - **[Dependabot Docs](https://docs.github.com/en/code-security/dependabot)**
   - **[Dependency Review](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review)**

### Phase 4: Advisories, Admin, and Review (Week 5-6)

**Goal:** Finish remaining domains and run mock exams.

1. **Security Advisories**
   - Repository advisories for coordinated disclosure
   - CVE requests, private forks, publication
   - Global Advisory Database and how Dependabot consumes it

2. **Private Vulnerability Reporting**
   - Enable at repo or org
   - Draft advisory creation for maintainers

3. **Administration**
   - Security configurations for scale
   - Security overview dashboards
   - REST API endpoints and webhooks

4. **Phase 4 Resources**
   - **[Security Advisories](https://docs.github.com/en/code-security/security-advisories)**
   - **[Security Overview](https://docs.github.com/en/code-security/security-overview/about-the-security-overview)**
   - **[REST API for Security](https://docs.github.com/en/rest/code-scanning)**

## Study Resources

### Official GitHub Resources
- **[Code Security Docs](https://docs.github.com/en/code-security)** - Complete reference
- **[GHAS Product Page](https://github.com/features/security)** - Product overview
- **[CodeQL Site](https://codeql.github.com/)** - CodeQL learning
- **[GitHub Security Lab](https://securitylab.github.com/)** - Research and CodeQL examples
- **[GitHub Blog - Security](https://github.blog/category/security/)** - Updates
- **[GitHub Skills](https://skills.github.com/)** - Interactive courses

### Free Learning Resources
- **[CodeQL Learning Lab](https://codeql.github.com/docs/writing-codeql-queries/)** - CodeQL query writing
- **[OWASP Top 10](https://owasp.org/www-project-top-ten/)** - Vulnerability classes context
- **[MITRE CWE](https://cwe.mitre.org/)** - Weakness enumeration

### Practice Platforms
- A sandbox GitHub Enterprise Cloud trial org
- Deliberately vulnerable demo repos (e.g., github/codeql-action examples)
- Personal repos with intentionally inserted issues for practice

## Exam Tactics

### Question Strategy
1. **Identify the feature in scope** - Is the question about code scanning, secret scanning, Dependabot, or advisory?
2. **Distinguish alert types** - code scanning vs Dependabot vs secret scanning alerts behave differently
3. **Read YAML carefully** - Many questions include small `dependabot.yml` or workflow snippets where a single field matters
4. **Watch for licensing traps** - Some features are free on public, GHAS on private
5. **Use terminology precisely** - "partner pattern" vs "custom pattern" vs "GitHub pattern" are distinct

### Time Management
- **~75 questions in 120 minutes** = ~1.6 minutes per question
- **First pass (80 minutes):** answer confident items, flag the rest
- **Second pass (30 minutes):** revisit flagged
- **Final (10 minutes):** verify nothing is blank
- Cap any single question at 3 minutes on the first pass

### Question Types to Expect
- **YAML completion** - Fill in a missing field in `dependabot.yml` or a CodeQL workflow
- **Alert triage** - Given a scenario, what action is correct?
- **Feature mapping** - Which feature addresses this risk?
- **Licensing** - Does this scenario consume a seat?
- **Configuration scope** - Where is this configured: repo, org, enterprise?

### Key Differentiators to Study

| Concept A | Concept B | Key Difference |
|-----------|-----------|----------------|
| Default setup | Advanced setup | Default is auto-managed; advanced is YAML workflow |
| `security-extended` | `security-and-quality` | Extended adds lower-precision security; S&Q adds quality on top |
| Dependabot security updates | Dependabot version updates | Security are CVE-driven; version are schedule-driven |
| Partner pattern | Custom pattern | Partner is vendor-supplied; custom is customer-defined |
| Push protection bypass | Push protection denial | Bypass allows push with reason; denial is the default when detected |
| Repository advisory | Global Advisory Database | Repo advisory is coordination space; DB is public feed |
| Dependency graph | Dependabot alerts | Graph is the inventory; alerts are vulnerabilities against it |
| Code scanning | Secret scanning | Code scanning finds code issues; secret scanning finds credentials |

## Common Pitfalls

### Configuration Confusion
- Mixing default and advanced setup behaviors
- Forgetting that secret scanning push protection requires GHAS on private repos
- Using the wrong query suite name
- Missing required fields in `dependabot.yml`

### Licensing
- Thinking every GitHub user consumes a seat (only active committers do)
- Assuming public repos need GHAS for code scanning (they do not)
- Forgetting that Dependabot is free even on private repos

### Alert Triage
- Dismissing alerts with the wrong reason (affects metrics and automation)
- Not understanding auto-dismiss rules for fixed alerts
- Confusing a closed secret scanning alert with a revoked credential

### Administration
- Enabling features repo by repo instead of using security configurations
- Overlooking the security overview dashboard
- Forgetting that audit logs and webhooks exist for automation

### Advisories
- Publishing a draft advisory prematurely
- Not requesting a CVE when appropriate
- Missing the private fork step in coordinated disclosure
