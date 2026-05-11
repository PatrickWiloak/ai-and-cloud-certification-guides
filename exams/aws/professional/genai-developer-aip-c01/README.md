# AWS Certified Generative AI Developer - Professional (AIP-C01)

The AWS Certified Generative AI Developer - Professional (AIP-C01) certification validates the ability to integrate foundation models (FMs) into production applications and business workflows on AWS. It is a Professional-tier credential targeted at developers who already build production-grade applications and have hands-on experience implementing GenAI solutions.

## Quick Links

- [Fact Sheet](fact-sheet.md) - Exam logistics, blueprint, in-scope and out-of-scope services
- [Official Exam Page](https://aws.amazon.com/certification/certified-generative-ai-developer-professional/) - Registration and exam details
- [Official Exam Guide PDF](https://d1.awsstatic.com/onedam/marketing-channels/website/aws/en_US/certification/approved/pdfs/docs-aip/AWS-Certified-Generative-AI-Developer-Pro_Exam-Guide.pdf) - Authoritative blueprint
- [Official Exam Guide (HTML)](https://docs.aws.amazon.com/aws-certification/latest/ai-professional-01/ai-professional-01.html) - Same content, navigable by domain

## Study Notes

### Domain notes (weighted by exam %)
- [Domain 1: Foundation Model Integration, Data Management, and Compliance (31%)](notes/01-foundation-models-data-compliance.md)
- [Domain 2: Implementation and Integration (26%)](notes/02-implementation-integration.md)
- [Domain 3: AI Safety, Security, and Governance (20%)](notes/03-ai-safety-security-governance.md)
- [Domain 4: Operational Efficiency and Optimization for GenAI Applications (12%)](notes/04-operational-efficiency-optimization.md)
- [Domain 5: Testing, Validation, and Troubleshooting (11%)](notes/05-testing-validation-troubleshooting.md)

### Cross-cutting deep-dives (the high-leverage topics)
- [RAG Architecture Deep-Dive](notes/rag-architecture-deep-dive.md) - Tested in Domains 1, 4, 5
- [Agentic AI Systems](notes/agentic-ai-systems.md) - Tested in Domains 2, 5
- [Bedrock Platform Deep-Dive](notes/bedrock-platform-deep-dive.md) - The single most-tested service surface
- [Prompt Engineering and Management](notes/prompt-engineering-and-management.md) - Tested in Domains 1, 3, 5
- [AWS Services Mapping (reverse index)](notes/aws-services-mapping.md) - Last-mile service-by-service review

### Companion materials in this repo (background, not Pro-level)
- [AWS Certified AI Practitioner (AIF-C01)](../../genai/) - Foundational cert; useful background only
- [AWS Certified Machine Learning Engineer Associate (MLA-C01)](../../associate/ml-engineer-mla-c01/) - Some overlap with Bedrock and SageMaker AI
- [LLMs and GenAI topic notes](../../../../topics/llms-and-genai.md) - Cross-cloud GenAI concepts
- [Cross-cloud GenAI platform comparison](../../../../resources/service-comparison-genai-platforms.md)

## What the exam validates

The exam validates a candidate's ability to:

- Design and implement solutions using vector stores, Retrieval Augmented Generation (RAG), knowledge bases, and other GenAI architectures.
- Integrate FMs into applications and business workflows.
- Apply prompt engineering and management techniques.
- Implement agentic AI solutions.
- Optimize GenAI applications for cost, performance, and business value.
- Implement security, governance, and Responsible AI practices.
- Troubleshoot, monitor, and optimize GenAI applications.
- Evaluate FMs for quality and responsibility.

## Exam structure (one-line summary)

| Property | Value |
|----------|-------|
| Code | AIP-C01 |
| Time | 205 minutes |
| Questions | 85 total (65 scored + 10 unscored) |
| Format | Multiple choice and multiple response |
| Passing score | 750 / 1000 (scaled) |
| Cost | $300 USD |
| Validity | 3 years |
| Delivery | Pearson VUE (online proctored or test center) |

Full details in the [fact sheet](fact-sheet.md).

## Domain weightings

| Domain | Weight |
|--------|--------|
| 1. Foundation Model Integration, Data Management, and Compliance | 31% |
| 2. Implementation and Integration | 26% |
| 3. AI Safety, Security, and Governance | 20% |
| 4. Operational Efficiency and Optimization for GenAI Applications | 12% |
| 5. Testing, Validation, and Troubleshooting | 11% |

## 1-week study schedule (today is 2026-05-08, target exam ~2026-05-17)

This schedule is weighted by domain percentage. Day 1 starts heaviest because Domain 1 is the largest (31%) and covers the foundational concepts (RAG, vector stores, prompt engineering, FM customization) that the rest of the exam builds on.

| Day | Date | Focus | Hours (target) |
|-----|------|-------|----------------|
| 1 | 2026-05-08 (Fri) | Read [fact-sheet](fact-sheet.md), [Domain 1](notes/01-foundation-models-data-compliance.md) tasks 1.1-1.3 (architecture, FM selection, data pipelines) | 3-4 |
| 2 | 2026-05-09 (Sat) | [Domain 1](notes/01-foundation-models-data-compliance.md) tasks 1.4-1.6 (vector stores, retrieval, prompt engineering) + [RAG deep-dive](notes/rag-architecture-deep-dive.md) | 4-5 |
| 3 | 2026-05-10 (Sun) | [Domain 2](notes/02-implementation-integration.md) (all tasks) + [Agentic AI deep-dive](notes/agentic-ai-systems.md) | 4-5 |
| 4 | 2026-05-11 (Mon) | [Bedrock platform deep-dive](notes/bedrock-platform-deep-dive.md) end-to-end + [Prompt engineering deep-dive](notes/prompt-engineering-and-management.md) | 3-4 |
| 5 | 2026-05-12 (Tue) | [Domain 3](notes/03-ai-safety-security-governance.md) (all tasks) - guardrails, PII, governance, responsible AI | 3 |
| 6 | 2026-05-13 (Wed) | [Domain 4](notes/04-operational-efficiency-optimization.md) (cost, perf, monitoring) + [Domain 5](notes/05-testing-validation-troubleshooting.md) (eval + troubleshooting) | 3 |
| 7 | 2026-05-14 (Thu) | [AWS services mapping](notes/aws-services-mapping.md) - service-by-service walkthrough; revisit weak domains | 3 |
| 8 | 2026-05-15 (Fri) | Quick-recall summaries at the bottom of every note. Light review only. | 2 |
| 9 | 2026-05-16 (Sat) | Rest day or sleep-in. Skim quick-recall summaries only. | 1 |
| - | 2026-05-17 (Sun) | **Exam day** | - |

Adjust the dates to your actual exam date. Total target study load: ~25-30 focused hours across 8 days.

## How to read these notes

- Each domain note begins with the **verbatim list of exam Tasks and Skills** from the official guide. This is your checklist - if you understand every Skill, you can pass that domain.
- The cross-cutting deep-dives go several layers deeper than the domain notes on the highest-leverage topics. Read them after the corresponding domain note, not before.
- Every note ends with a **Quick-recall summary** - dense bullet list designed for last-week skimming. Treat these as your cram sheet.
- Service names use AWS short names where standard (Amazon SNS, not Amazon Simple Notification Service) - the exam itself does the same, per the official "Mentions of AWS services on the exam" page.

## Prerequisites you should already have

Per the official target candidate description:

- 2+ years of experience building production-grade applications on AWS or with open-source technologies
- General AI/ML or data engineering experience
- 1+ year of hands-on experience implementing GenAI solutions
- Working familiarity with AWS compute, storage, networking, IAM, IaC, observability, and cost optimization

If any of these is shaky, the AIP-C01 will be brutal in 1 week. Prioritize hands-on Bedrock + Knowledge Bases + Agents work over reading.

## Out of scope (don't waste study time)

The exam explicitly excludes these job tasks:

- **Model development and training** (you won't be tested on training a transformer from scratch)
- **Advanced ML techniques** (no math-heavy ML theory)
- **Data engineering and feature engineering** (no detailed Glue/EMR/Spark transformations)

A condensed list of out-of-scope AWS services (don't waste time on these): DeepRacer, DeepComposer, Forecast, Fraud Detector, Lookout family, Monitron, HealthLake, Panorama, Redshift, Timestream, Lightsail, Beanstalk, Snow Family, IoT family, Alexa for Business, GameLift, Braket. Full list in the [fact sheet](fact-sheet.md).
