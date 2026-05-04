---
last-updated: 2026-05-03
---

# Practice Questions Template

This template defines the format for practice question banks in this repository. Use it as a seed when authoring a new bank, and lift the boilerplate sections directly.

---

## Question Format

Each question should follow this structure:

```markdown
### Question X
**Scenario:** [Brief description of the situation - 1-3 sentences]

A. Option A
B. Option B
C. Option C
D. Option D

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** [Explanation of why the correct answer is right and why other options are wrong - 2-5 sentences]

**Key Concept:** [Link to relevant documentation or notes file]
</details>
```

---

## Example Question

### Question 1
**Scenario:** A company needs to store infrequently accessed data that must be retrieved within milliseconds when needed. The data is accessed about once per quarter but retrieval time is critical for business operations.

A. S3 Standard
B. S3 Standard-IA
C. S3 Glacier Instant Retrieval
D. S3 Glacier Deep Archive

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** S3 Glacier Instant Retrieval is designed for data accessed once per quarter with millisecond retrieval times. S3 Standard-IA requires more frequent access (at least once per month) to be cost-effective. S3 Glacier Deep Archive has retrieval times of 12+ hours. S3 Standard is too expensive for infrequently accessed data.

**Key Concept:** [S3 Storage Classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)
</details>

---

## Question types: aim for a healthy mix

A 25-question bank should span the categories below in roughly the proportions listed. Not every question will fit cleanly into one category - that's fine - but if your bank ends up entirely scenario-style and skips troubleshooting, it's not preparing the reader for the real exam.

| Type | Target % | What it tests |
|---|---|---|
| **Scenario / architecture choice** | 35-50% | "Pick the right service / pattern for this requirement" |
| **Configuration / decision** | 15-25% | "Which setting or flag does X" |
| **Troubleshooting** | 10-20% | "Symptoms shown - root cause + fix" |
| **Cost / sizing** | 10-15% | "Lever that most affects spend / capacity" |
| **Security / compliance** | 10-15% | "What controls satisfy this requirement" |

Cover all major exam domains in proportion to the official blueprint weight. A 30%-weight domain should get ~30% of your questions.

## Writing better distractors

The wrong answers (distractors) are where good practice banks separate themselves from poor ones. A distractor should be:

- **Plausible** - someone who half-knows the material would consider it. "AWS hires interns" is not a plausible distractor; "Use Lambda layers" might be.
- **Wrong for a *specific reason*** - not just "another service name." The explanation should articulate why it fails: hits a quota, wrong consistency model, doesn't meet the SLA, etc.
- **A common confusion** - test the boundary between two services (RDS vs Aurora, Lambda vs Fargate, Pub/Sub vs Kafka).
- **Same shape as the correct answer** - if the correct answer is one sentence, distractors should be one sentence too. Lopsided length is a tell.

**Bad distractor**: "Manual review" (too obviously wrong for any non-trivial scenario).

**Good distractor**: "Use S3 Cross-Region Replication" (plausible for a DR scenario; fails because CRR doesn't replicate KMS-encrypted objects without explicit configuration).

## Explanations: the "why" matters more than the "what"

The Answer block has three parts:

- **Correct: X** - the letter (and only the letter, not the full text - the reader scanned the options already).
- **Why:** the reasoning. Lead with why the correct answer fits, then briefly note why the most-tempting wrong answer fails. 2-4 sentences. Don't re-state the question.
- **Key Concept:** (optional but encouraged) - a link to the canonical vendor doc, this repo's concept page, or the relevant notes/ file.

Avoid hand-waving like "this is the standard solution." Tell the reader the specific property of the right answer that makes it right (latency, cost model, consistency, SLA, scaling profile).

---

## Guidelines

### Scenario-Based Questions
- Focus on real-world situations
- Include specific requirements (cost, performance, compliance, scale, regulatory constraint)
- Avoid trick questions - test knowledge, not reading comprehension
- Cite numbers when they matter ("100 TB", "50 ms p99", "5000 concurrent users")

### Answer Choices
- Make all options plausible
- Avoid "all of the above" or "none of the above"
- Keep options similar in length and detail
- Only one clearly correct answer

### Explanations
- Explain why the correct answer is right
- Briefly explain why the strongest wrong answer is wrong
- Link to official documentation or this repo's notes/ file

### Domain Coverage
- Distribute questions across all exam domains
- Weight questions according to the published exam blueprint percentages
- Cover both common and edge-case scenarios

---

## Length target

| Bank tier | Question count | Reasoning |
|---|---|---|
| Foundational (Practitioner / Fundamentals) | 15-20 | Exam itself is short; bank should fit a 30 min review |
| Associate | 20-25 | Cover the breadth of domains |
| Professional / Specialty / Pro | 25-40 | Match the exam's depth and trickiness |

---

## Scoring guide template

Append a scoring guide at the end. It maps "what % did I get" to "what should I do next." Example for a 25-question bank:

```markdown
## Scoring guide

- **22-25 (88%+):** Strong. Schedule the exam.
- **17-21 (68-87%):** Solid. Targeted re-study on weak-domain wrong answers, then schedule.
- **<17 (<68%):** Re-read the relevant notes/ files and try again in a week.

[Cert]: ~50 questions, 100 minutes, 700/1000 (or whichever) to pass. [Add a sentence on the exam's emphasis.]
```

---

## File Naming Convention

`[provider]-[certification-name].md`

Examples:
- `aws-cloud-practitioner.md`
- `aws-solutions-architect-associate.md`
- `azure-az-104.md`
- `gcp-cloud-engineer.md`

---

## Don't do

- **Verbatim exam questions.** Legal and ethical violation. If a question feels too close to one you saw on a real exam, rewrite the scenario from scratch with different numbers and constraints.
- **Trivial questions.** "What does S3 stand for?" tests nothing. Aim at the level of judgment the exam actually tests.
- **Outdated material.** Check the current exam blueprint before authoring. Retired exam concepts (e.g., MLS-C01 algorithms after MLA-C01 launched) are worse than no questions.
- **Domain skew.** A 25-question bank where 20 are on a single domain trains the reader for the wrong test.
