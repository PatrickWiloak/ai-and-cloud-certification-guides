# HashiCorp Packer Associate (003) Certification

## Exam Overview

The HashiCorp Packer Associate (003) certification validates foundational knowledge and practical skills for building machine images with HashiCorp Packer. It is aimed at operators, platform engineers, and build engineers who produce immutable images (AMIs, Azure images, GCP images, Docker containers, vSphere templates, and more) as part of a CI/CD or release pipeline.

Packer is the HashiCorp tool for creating identical machine images for multiple platforms from a single source configuration. The exam confirms you understand Packer's architecture, can author HCL2 configurations, can use builders, provisioners, and post-processors, and can integrate Packer into a build pipeline.

**Exam Code:** Packer Associate (003)
**Exam Duration:** 60 minutes
**Number of Questions:** 57 questions
**Exam Format:** Multiple choice and multiple response
**Passing Score:** 70% (HashiCorp does not publish an exact score; reported as pass or fail)
**Cost:** $70.50 USD
**Proctoring:** PSI online proctoring
**Validity:** 2 years
**Prerequisites:** None. Recommended: 6+ months of hands-on Packer experience and comfort with at least one cloud provider

## Who Should Take This Exam

- Build and release engineers producing AMIs or other cloud images
- Platform engineers standardizing golden images for internal consumers
- DevOps engineers integrating Packer into CI pipelines
- Infrastructure operators migrating from manual image creation to repeatable, codified builds
- Engineers preparing for HashiCorp's broader automation certification track (Packer + Terraform + Vault)

## Exam Domains (high-level)

1. Understand Packer fundamentals (approximately 15%)
2. Understand and use Packer plugins (builders, provisioners, post-processors) (approximately 25%)
3. Author and debug HCL2 configuration (approximately 20%)
4. Integrate Packer with HCP Packer and artifact management (approximately 15%)
5. Use Packer in CI/CD and multi-cloud workflows (approximately 15%)
6. Secure images and manage credentials (approximately 10%)

See `fact-sheet.md` for detailed topics.

## Prerequisites and Recommended Experience

- Comfortable with one of the major clouds (AWS most common on exam). You should know what an AMI is, what regions and AZs are, how security groups and key pairs work.
- Command-line fluency: Bash or PowerShell
- Basic shell scripting for provisioners
- Familiarity with at least one of: Ansible, Chef, Puppet, Shell provisioners
- Working knowledge of HCL (Terraform background helps enormously)
- Understanding of Git and CI/CD pipelines

## Study Path

1. Read `fact-sheet.md` to frame the exam.
2. Work through the six notes files in `notes/` sequentially.
3. Follow the week-by-week schedule in `practice-plan.md`.
4. Review `scenarios.md` for real-world decision points.
5. Use `strategy.md` close to exam day.

## Hands-on Lab Requirements

Theoretical understanding is not enough. You need to build real images.

- Packer 1.10 or newer (1.11+ recommended)
- AWS free-tier account (AMI builds on free-tier EC2 work fine)
- Optionally: Azure or GCP sandbox for multi-cloud practice
- Docker Desktop or Docker Engine for container builder practice
- Text editor with HCL syntax support (VS Code + HashiCorp extension)

## Official Resources

- Packer documentation: https://developer.hashicorp.com/packer/docs
- Packer tutorials: https://developer.hashicorp.com/packer/tutorials
- Exam objectives: https://developer.hashicorp.com/certifications/infrastructure-automation
- HCP Packer documentation: https://developer.hashicorp.com/hcp/docs/packer
- Packer plugin registry: https://developer.hashicorp.com/packer/integrations

## Recommended Supplementary Resources

- HashiCorp Learn tutorials on building AWS AMIs and Docker images
- Example Packer templates in the `hashicorp/packer-examples` repository
- Packer GitHub repo for release notes and issue tracker
- Ansible documentation for the `ansible` provisioner (most common on exam)

## Recertification

The certification is valid for 2 years. To recertify, take the current version of the exam. The exam blueprint has evolved from JSON templates (pre-1.7) to HCL2 (current). Always check the latest blueprint before scheduling.

## Common Pitfalls to Avoid

- Studying the legacy JSON template format. HCL2 is the current exam scope.
- Assuming Packer and Terraform are interchangeable. They solve different problems.
- Skipping the HCP Packer portion. HashiCorp prominently features it on current exams.
- Ignoring post-processors. They are a full exam subdomain.
- Not practicing real builds. Reading docs does not build muscle memory.

## Time Investment Estimate

- 40 to 50 hours total for most candidates
- 2 to 3 weeks of focused part-time study
- At least 10 hours of hands-on labs (can be compressed into a weekend)

## Cost Awareness

Practice builds create real cloud resources. Packer usually destroys the builder instance after the image is captured, but orphaned EBS snapshots, unregistered AMIs, and AWS Image Builder pipelines can accumulate. Budget alerts at $10 to $20 are adequate for associate-level practice.
