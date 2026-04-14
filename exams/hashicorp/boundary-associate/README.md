# HashiCorp Boundary Associate Certification

## Exam Overview

The HashiCorp Boundary Associate certification validates working knowledge of HashiCorp Boundary, an identity-aware secure remote access platform. Boundary provides a modern alternative to traditional bastion hosts and VPNs by authenticating users against trusted identity providers, dynamically authorizing access based on role, and brokering credentials to targets without exposing them to the user.

This exam targets operators, platform engineers, and security engineers who deploy Boundary as part of a zero-trust access strategy. You will need to understand Boundary's architecture, set up controllers and workers, define scopes and roles, configure targets, integrate with Vault for dynamic credentials, and manage session lifecycles.

**Exam Code:** Boundary Associate
**Exam Duration:** 60 minutes
**Number of Questions:** 57 questions
**Exam Format:** Multiple choice and multi-select
**Passing Score:** Approximately 70% (HashiCorp reports pass or fail)
**Cost:** $70.50 USD
**Proctoring:** PSI online proctoring
**Validity:** 2 years
**Prerequisites:** None. Recommended: 3 to 6 months Boundary experience, familiarity with SSH, Vault, and common identity providers (Okta, Azure AD, etc.)

## Who Should Take This Exam

- Platform engineers replacing bastion hosts with identity-aware proxies
- Security engineers implementing zero-trust access policies
- DevOps operators managing infrastructure access for distributed teams
- Engineers integrating Boundary with Vault for dynamic credential brokering
- Consultants deploying Boundary for customers' secure access needs

## Exam Domains (high-level)

1. Boundary architecture and core concepts (approximately 20%)
2. Targets, sessions, and host management (approximately 20%)
3. Credential brokering and Vault integration (approximately 15%)
4. Authentication methods and role-based access control (approximately 20%)
5. Deployment modes, clusters, and workers (approximately 15%)
6. Session recording, audit, and operational tasks (approximately 10%)

See `fact-sheet.md` for detailed topics and commands.

## Prerequisites and Recommended Experience

- Strong Linux CLI and SSH fundamentals
- Familiarity with OIDC / SAML concepts
- Basic Vault knowledge (secrets engines, policies)
- Understanding of network concepts (NAT, private IPs, firewalls)
- Docker / Podman for local testing
- Optional: Terraform basics for infrastructure-as-code Boundary configs

## Study Path

1. Read `fact-sheet.md` for exam structure.
2. Work through all six notes in `notes/` sequentially.
3. Follow the week-by-week plan in `practice-plan.md`.
4. Use `scenarios.md` to test decision-making.
5. Review `strategy.md` the day before the exam.

## Hands-on Lab Requirements

Boundary labs are doable on a laptop:

- Boundary 0.15 or newer (Enterprise features require an Enterprise binary)
- Docker Desktop or Podman for running multiple Boundary components
- A local Vault instance (dev mode is fine)
- One or more target hosts: Docker containers running sshd, a local VM, or a cloud VM
- An OIDC provider for auth method testing (Auth0 free tier works well)

HashiCorp provides `boundary dev` which spins up the full stack in one command for learning.

## Official Resources

- Boundary documentation: https://developer.hashicorp.com/boundary/docs
- Boundary tutorials: https://developer.hashicorp.com/boundary/tutorials
- Exam objectives: https://developer.hashicorp.com/certifications/security-automation
- Boundary Desktop app: https://developer.hashicorp.com/boundary/downloads
- HCP Boundary: https://developer.hashicorp.com/hcp/docs/boundary

## Recommended Supplementary Resources

- "Zero Trust Networks" by Evan Gilman and Doug Barth for conceptual grounding
- HashiCorp Learn's Boundary getting-started track
- Boundary GitHub repo for release notes
- Community forums for real-world deployment questions

## Recertification

Certification is valid for 2 years. Retake the current exam version to recertify. The blueprint evolves as new features (session recording, multi-hop workers, etc.) ship.

## Common Pitfalls to Avoid

- Confusing Boundary with Vault. Boundary governs access to targets; Vault governs secrets. They often integrate.
- Thinking Boundary is a VPN. It proxies specific sessions, not general network traffic.
- Skipping worker concepts. Multi-hop and egress workers are real exam content.
- Overlooking credential brokering patterns. This is a signature Boundary feature.
- Underestimating scope and role semantics. They are central to every permission decision.

## Time Investment Estimate

- 40 to 60 hours total for most candidates
- 3 to 4 weeks of focused part-time study
- At least 15 hours of hands-on labs (heavily recommended)

## Architecture Teaser

At a high level, Boundary has three main components:

- **Controllers:** the control plane. Store config, process API requests, authenticate users.
- **Workers:** the data plane. Proxy TCP traffic between users and targets.
- **Clients:** CLI, Desktop app, or API consumers that initiate sessions.

Users authenticate to a controller, request a session to a target, and the controller authorizes and assigns a worker to proxy the connection. The worker brokers any required credentials during the session. When the session ends, the credentials are revoked.

More detail in `notes/01-boundary-architecture.md`.
