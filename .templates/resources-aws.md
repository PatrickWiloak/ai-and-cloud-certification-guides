# AWS Study Resources Guide

Consolidated AWS study resources referenced across the AWS certifications in this repo. Use this as the central hub when preparing for any AWS certification.

---

## Official AWS Resources

### Documentation and learning paths
- **[📖 AWS Documentation](https://docs.aws.amazon.com/)** - Authoritative service documentation
- **[📖 AWS Skill Builder](https://skillbuilder.aws/)** - Free official courses, learning plans, and (paid) Official Practice Exams
- **[📖 AWS Training](https://aws.amazon.com/training/)** - Course catalog
- **[📖 AWS Certification Hub](https://aws.amazon.com/certification/)** - Cert paths, exam guides, sample questions
- **[📖 AWS Whitepapers](https://aws.amazon.com/whitepapers/)** - Reference architectures and best practices
- **[📖 AWS Architecture Center](https://aws.amazon.com/architecture/)** - Reference architectures and Well-Architected Lenses
- **[📖 AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)** - Operational excellence, security, reliability, performance, cost, sustainability

### Blogs
- **[AWS News Blog](https://aws.amazon.com/blogs/aws/)** - Launches and feature updates
- **[AWS Big Data Blog](https://aws.amazon.com/blogs/big-data/)**
- **[AWS Database Blog](https://aws.amazon.com/blogs/database/)**
- **[AWS Machine Learning Blog](https://aws.amazon.com/blogs/machine-learning/)**
- **[AWS Security Blog](https://aws.amazon.com/blogs/security/)**
- **[AWS DevOps Blog](https://aws.amazon.com/blogs/devops/)**
- **[AWS Architecture Blog](https://aws.amazon.com/blogs/architecture/)**

### Video and event content
- **[AWS Events on YouTube](https://www.youtube.com/user/AmazonWebServices)** - re:Invent and AWS Summit talks
- **[AWS This Week](https://www.youtube.com/playlist?list=PLhr1KZpdzukcEY_Tu7P02kdWxccWcuhRJ)** - Weekly product news
- **[AWS Online Tech Talks](https://aws.amazon.com/events/online-tech-talks/)**

---

## Hands-on Practice

### Free / low-cost lab environments
- **[AWS Free Tier](https://aws.amazon.com/free/)** - 12 months free + always-free tier
- **[AWS Workshops](https://workshops.aws/)** - Curated guided labs across services
- **[AWS Cloud Quest](https://aws.amazon.com/training/digital/aws-cloud-quest/)** - Gamified labs
- **[AWS Skill Builder Subscription](https://skillbuilder.aws/subscriptions)** (paid) - includes AWS Builder Labs and Cloud Quest premium roles

### Commercial lab platforms
- **A Cloud Guru / Pluralsight** - lab platform with sandbox accounts
- **Cloud Academy** - hands-on labs and learning paths
- **Whizlabs** - practice exams + labs
- **KodeKloud** - DevOps-focused labs

### Building your own
- Use [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/) or [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to spin up + tear down lab environments
- Set up cost alerts ([Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)) before you start

---

## Practice Exams

| Provider | Strength | Cost |
|---|---|---|
| **AWS Skill Builder Official Practice Exam** | Closest to real exam style; one per cert | ~$20 each |
| **Tutorials Dojo (Jon Bonso)** | Considered hardest, high-quality explanations | $15-30 per cert |
| **Whizlabs** | Volume of questions; cheaper | $10-20 per cert |
| **Stephane Maarek (Udemy)** | Often bundled with video courses | varies |
| **MeasureUp** | Microsoft-style; relevant for AWS too | $$ |

Aim for **80%+ on the same practice exam twice in a row** before scheduling the real exam.

---

## Video Courses

- **Stephane Maarek** (Udemy) - the most-recommended AWS courses for SAA, DVA, SOA, SAP, DOP, MLA, DEA
- **Adrian Cantrill** ([learn.cantrill.io](https://learn.cantrill.io/)) - deep dives, very thorough
- **A Cloud Guru / Pluralsight** - broad catalog, good for quick refreshers
- **AWS Skill Builder** - free official courses; uneven quality but improving

Pick **one primary video course** + **one primary practice-exam vendor**. Don't shop multiple.

---

## Communities

- **[r/AWSCertifications](https://reddit.com/r/AWSCertifications)** - active study community, lots of pass reports
- **[r/AWS](https://reddit.com/r/aws)** - general AWS discussion
- **[Stephane Maarek's Discord](https://discord.gg/aws-certified)** - course-linked but open
- **[AWS re:Post](https://repost.aws/)** - official Q&A, replaces forums
- **[Cloud Academy AWS Community](https://community.cloudacademy.com/)**

---

## Cost-Optimization for Lab Use

- Use the free tier aggressively in months 1-12.
- Tag every resource with a `cert:<exam-code>` tag for easy cleanup.
- Set a $20/month budget alert as a safety net.
- Tear down resources at end of each lab session - don't leave EC2 / RDS / EKS running overnight.
- Prefer Spot instances for any EC2-based labs.
- See [AWS Cost Optimization Guide](../resources/cost-optimization/aws-cost-optimization.md) and [Free Tier Guide](../resources/free-tier-guide.md).

---

## Repo Cross-References

- **[AWS CLI Cheat Sheet](../resources/cli-cheat-sheet-aws.md)**
- **[AWS Well-Architected Notes](../resources/well-architected/aws-well-architected.md)**
- **[AWS Cost Optimization](../resources/cost-optimization/aws-cost-optimization.md)**
- **[AWS Troubleshooting](../resources/troubleshooting/aws-troubleshooting.md)**
- **[On-Prem to AWS Migration](../resources/migration-guides/on-prem-to-aws.md)**
- **[Service Comparisons (cross-cloud)](../resources/)**
- **[Practice Resources (cross-vendor)](../resources/practice-resources.md)**

---

> Last reviewed: 2026-04. AWS reorganizes documentation URLs occasionally; if a link is broken, search for the title text instead.
