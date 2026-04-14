# GitHub Copilot - Exam-Style Scenarios

## Scenario 1: Choosing the Right Plan

### Scenario
A 500-developer company wants to roll out Copilot across all engineering teams. Security requires that prompts and suggestions are not retained and not used to train any model. They also want path-based controls to keep certain proprietary algorithms out of Copilot context, and they want IP indemnification for generated code.

**Question:** Which plan meets the minimum requirements?

**Options:**
A. Copilot Pro for every developer
B. Copilot Business for every developer
C. Copilot Enterprise for every developer
D. Copilot Free for every developer

**Correct Answer:** B

**Explanation:**
Copilot Business is the minimum plan that offers content exclusions, audit logs, prompt/suggestion non-retention, and IP indemnification (with duplicate detection enabled). Copilot Enterprise adds more (knowledge bases, PR summaries, custom models) but is not required by the stated requirements.

**Why other options are wrong:**
- **A:** Pro is an individual plan; it lacks admin content exclusions and IP indemnity.
- **C:** Enterprise works but is more than required; the question asks for the minimum.
- **D:** Free has usage limits and no enterprise controls.

---

## Scenario 2: Preventing Suggestions That Match Public Code

### Scenario
A compliance officer is worried about receiving code suggestions that match public code on GitHub, due to licensing concerns.

**Question:** Which feature addresses this concern?

**Options:**
A. Content exclusions
B. Duplicate detection filter
C. Custom models
D. Knowledge bases

**Correct Answer:** B

**Explanation:**
The duplicate detection filter blocks suggestions that match approximately 150 characters of public code on GitHub. It is required to be enabled to activate IP indemnity on Business and Enterprise.

**Why other options are wrong:**
- **A:** Content exclusions prevent files from being used as context; they do not block matches against public code.
- **C:** Custom models personalize suggestions; they do not filter matches.
- **D:** Knowledge bases provide repo context for Enterprise chat; not a public code filter.

---

## Scenario 3: Using the Right Chat Surface

### Scenario
A developer in VS Code wants Copilot Chat to answer a question about their entire repository, not just the currently open file.

**Question:** Which agent should the developer use?

**Options:**
A. `@terminal`
B. `@vscode`
C. `@workspace`
D. `/explain`

**Correct Answer:** C

**Explanation:**
`@workspace` instructs Copilot Chat to consider the whole workspace (repository) when answering. It enables broader code search and reasoning across files.

**Why other options are wrong:**
- **A:** `@terminal` targets shell/terminal help.
- **B:** `@vscode` answers questions about VS Code itself.
- **D:** `/explain` is a slash command for explaining selected code; it is not an agent for scope.

---

## Scenario 4: Generating Unit Tests

### Scenario
A developer wants Copilot to generate unit tests for a selected function in VS Code.

**Question:** What is the fastest way to do this?

**Options:**
A. Type a comment above the function and press Tab to accept
B. Select the function, open Copilot Chat, and run `/tests`
C. Run `gh copilot explain` on the function
D. Accept the next inline suggestion

**Correct Answer:** B

**Explanation:**
The `/tests` slash command in chat is specifically designed to generate tests for the current selection. It is faster and more reliable than relying on inline completions alone.

**Why other options are wrong:**
- **A:** Can work but is slower and less consistent than `/tests`.
- **C:** `gh copilot explain` describes shell commands, not code tests.
- **D:** Inline suggestions may not target test generation.

---

## Scenario 5: Content Exclusions Scope

### Scenario
An enterprise wants to prevent Copilot from suggesting code inside any file whose path matches `secrets/` or `**/*.pem`, across every repository in the organization.

**Question:** Where should this be configured?

**Options:**
A. Per-repository in the repo settings, for every repo individually
B. As a user setting in each developer's VS Code
C. At the organization level in Copilot content exclusions
D. In a `.copilotignore` file in each repo root

**Correct Answer:** C

**Explanation:**
Copilot content exclusions can be configured at the repository, organization, or enterprise level. For an org-wide rule covering every repository, set it at the organization level. The configuration is path-based and applies to completions and chat.

**Why other options are wrong:**
- **A:** Per-repo would work but is not the efficient way to cover every repository.
- **B:** There is no equivalent user-level setting for content exclusions.
- **D:** There is no `.copilotignore` file mechanism.

---

## Scenario 6: Prompt Engineering

### Scenario
A developer asks Copilot Chat: "make it faster." The response is generic and unhelpful.

**Question:** Which change to the prompt is most likely to produce a useful answer?

**Options:**
A. Ask the same question again
B. Select the slow function, attach it with `#selection`, and say "Optimize this for large inputs (n > 1M) while preserving the current public signature"
C. Ask Copilot to explain what "faster" means
D. Switch to a different IDE

**Correct Answer:** B

**Explanation:**
This follows the 4 S's: Single intent (optimize), Specific (preserve signature, handle n > 1M), Short (concise), and Surround (attach the relevant code as context via `#selection`).

**Why other options are wrong:**
- **A:** Repeating a vague prompt rarely improves results.
- **C:** Asking for definitions wastes time without providing context.
- **D:** The IDE is not the limiting factor.

---

## Scenario 7: IP Indemnity Requirements

### Scenario
A Copilot Business customer wants IP indemnification for generated suggestions.

**Question:** What must be true for indemnification to apply?

**Options:**
A. The customer has Copilot Business and the duplicate detection filter is enabled
B. The customer has Copilot Free with duplicate detection enabled
C. The customer pays an additional per-seat fee for indemnification
D. The customer has enabled knowledge bases

**Correct Answer:** A

**Explanation:**
IP indemnification applies to Copilot Business and Copilot Enterprise customers when the duplicate detection filter is enabled. It is part of the product without additional fees.

**Why other options are wrong:**
- **B:** Free does not include indemnity.
- **C:** No additional fee is required; indemnity is included with Business/Enterprise.
- **D:** Knowledge bases are an Enterprise feature and unrelated to indemnification.

---

## Scenario 8: CLI Use Case

### Scenario
A developer frequently forgets Bash flag combinations for `tar` and `find`.

**Question:** Which Copilot feature is best suited to help in the terminal?

**Options:**
A. GitHub Mobile app
B. `gh copilot suggest`
C. Copilot PR summaries
D. Copilot knowledge bases

**Correct Answer:** B

**Explanation:**
`gh copilot suggest` accepts natural language and proposes shell, Git, or gh CLI commands. It is the right tool for terminal tasks. `gh copilot explain` is its companion for explaining existing commands.

**Why other options are wrong:**
- **A:** Mobile is for on-the-go GitHub tasks, not local shell commands.
- **C:** PR summaries are for pull request descriptions, not the shell.
- **D:** Knowledge bases are for Enterprise chat context, not CLI help.

---

## Scenario 9: Enterprise-Only Feature

### Scenario
A platform team wants to curate a collection of internal engineering documents that Copilot Chat can reference when answering developer questions on github.com.

**Question:** Which feature and plan is required?

**Options:**
A. Content exclusions on Copilot Business
B. Knowledge bases on Copilot Enterprise
C. Custom models on Copilot Business
D. Copilot Extensions on Copilot Free

**Correct Answer:** B

**Explanation:**
Knowledge bases are an Enterprise feature that let admins curate a collection of markdown repos as context for Copilot Chat on github.com.

**Why other options are wrong:**
- **A:** Content exclusions remove context; they do not add curated references.
- **C:** Custom models are preview and Enterprise-only; they are not a curated document store.
- **D:** Extensions are available on multiple plans but are not the same as a knowledge base.

---

## Scenario 10: Responsible Use

### Scenario
A developer accepts a Copilot suggestion that implements an authentication token check. The code compiles and passes one unit test.

**Question:** What is the responsible next step before merging?

**Options:**
A. Merge immediately because CI passed
B. Have a human reviewer check the logic, run additional security-focused tests, and consider running Code Scanning
C. Delete the code because Copilot cannot write secure code
D. Push to production and monitor

**Correct Answer:** B

**Explanation:**
AI-generated code must be reviewed like any other code. For security-sensitive logic, require human review, add targeted tests, and run code scanning/SAST. This is the core responsible-use practice.

**Why other options are wrong:**
- **A:** One test and CI pass is insufficient for authentication logic.
- **C:** Copilot can produce secure code; verification is what matters.
- **D:** Pushing unreviewed security code is reckless.

---

## Scenario 11: Model Selection

### Scenario
A developer on Copilot Pro wants to switch the model Copilot Chat uses for a specific conversation because they want different reasoning characteristics.

**Question:** Is this possible, and where?

**Options:**
A. No, model selection is not a feature of any plan
B. Yes, via the model picker in Copilot Chat on supported surfaces
C. Only by changing GitHub Enterprise Cloud policy
D. Only after rebooting the IDE

**Correct Answer:** B

**Explanation:**
Copilot Chat supports model selection on eligible plans (including Pro, Business, and Enterprise). The picker appears in the chat UI and allows switching among available models.

**Why other options are wrong:**
- **A:** Model selection is a supported feature.
- **C:** It is not gated behind Enterprise Cloud policy for Pro users.
- **D:** No reboot required.

---

## Scenario 12: Audit and Telemetry

### Scenario
A security team wants to see who assigned and unassigned Copilot seats, and when policies changed for the organization.

**Question:** Where should they look?

**Options:**
A. The Copilot Chat history in each developer's IDE
B. The organization audit log, filtering for Copilot events
C. The billing invoice
D. The git commit log of the org's repos

**Correct Answer:** B

**Explanation:**
Organization audit logs include Copilot-related events such as seat assignment, policy changes, and content exclusion updates. Admins filter the log by action namespace to find Copilot entries.

**Why other options are wrong:**
- **A:** IDE chat history is local and not for audit.
- **C:** Billing shows charges, not policy or seat events.
- **D:** Git commits are unrelated to Copilot admin events.
