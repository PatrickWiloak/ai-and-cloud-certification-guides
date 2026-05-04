---
last-updated: 2026-05-03
---

# AWS DevOps Engineer Pro (DOP-C02) - Exam Strategy

> Cert-specific tactics. General study advice lives in [study-strategies.md](../../../../resources/study-strategies.md).

## Format reminder

- 75 scored questions, 180 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response
- Heavy on practical scenarios; lighter on architecture trade-offs than SAP-C02

## Time management math

180 / 75 = 2.4 min/question. DOP-C02 questions tend to be shorter than SAP-C02 - many can be answered in 60-90 seconds if you recognize the pattern. Bank time on the easy ones for the longer pipeline scenarios.

Pace: Q25 by 60 min, Q50 by 120 min, finish by 165 min, leave 15 min for flagged review.

## Top traps for THIS exam

1. **CodeDeploy deployment styles**: blue/green vs in-place; Lambda canary/linear/all-at-once presets (Canary10Percent10Minutes, Linear10Percent5Minutes, etc.). Memorize the named presets - they appear verbatim in answers.

2. **Pipeline cross-account**: the right answer almost always involves `sts:AssumeRole` with cross-account roles, never long-lived credentials. CodePipeline action's `RoleArn` field is the mechanism.

3. **SSM agent + private subnet**: three VPC endpoints (`ssm`, `ec2messages`, `ssmmessages`) allow SSM agent to operate without internet egress. This appears in both Patch Manager and Run Command questions.

4. **EventBridge vs CloudWatch Events** - the same service, different brand. Don't second-guess; pick whichever the question phrases.

5. **Auto-rollback alarms**: CodeDeploy supports up to 10 rollback alarms per deployment group. The alarm pattern (CloudWatch alarm → CodeDeploy rollback) is heavily tested.

6. **CloudFormation StackSets**: the AWS-managed permission model (service-managed permissions via Organizations) is the modern answer; self-managed permissions are legacy and require setting up trust roles per account manually.

7. **Systems Manager Incident Manager** is the AWS-recommended IR product (introduced 2021); shows up as the right answer to many "automated incident response" questions.

8. **Container deploy patterns**:
   - ECS rolling update = simple deploys, no canary
   - CodeDeploy blue/green for ECS = canary + auto-rollback, requires two target groups
   - ECS service revision shift via task set = also blue/green, more advanced
   - Know which pattern goes with which constraint

9. **CodeBuild local testing** with `aws codebuild start-build` and the use of `buildspec.yml` versions (0.2 has `phases`, `artifacts`, `cache`, `env`).

10. **AWS Backup vs Lifecycle Manager (DLM)**: Backup is multi-service (RDS, EBS, EFS, DynamoDB, etc.) with central audit; DLM is EBS snapshots only. Pick Backup for cross-service.

## Common high-yield topics easy to miss

- AWS Proton (managed self-service for platform engineering)
- AWS App2Container (containerizing Java + .NET workloads)
- AWS Copilot (CLI for ECS/App Runner deployments)
- Lambda destinations (vs DLQs - destinations are async-only, both success and failure)
- Step Functions express workflows vs standard (express = high volume, low duration, no exec history)
- AWS Config conformance packs (multi-rule deployment via CFN)
- Aurora Backtrack (point-in-time within minutes without restore)
- S3 Replication Time Control (RTC) for SLA-backed cross-region replication
- AWS Resilience Hub (assess and improve resilience score)

## When you're stuck on a question

1. **Eliminate manual / non-managed answers** - "an engineer SSHs in and runs..." is rarely correct.
2. **Eliminate "build with Lambda" if a managed service does it** - Lambda glue is fine when nothing native exists, but most DOP-C02 problems have a managed service answer.
3. **Map to the deciding constraint** - is it speed of rollback? minimize downtime? cost? operational overhead?
4. **Pattern-match the named features** - blue/green, canary, in-place, rolling - these are tested as named patterns.
5. **Flag and move on** - 5 minutes max per question.

## Day-of logistics

- 180 min, 75 questions: similar pacing to SAP-C02
- Bring two government IDs to the testing center
- Online proctored: clear room, single monitor, no books, no second screens
- The provided whiteboard / scratch is minimal - don't rely on it for math, do mental math

## After the exam

**Pass:** Professional cert is valid 3 years; recert by passing again or any other AWS Pro/Specialty.

**Fail:** Score breakdown by domain. If you failed close to the cut, regroup in 4-6 weeks; you can retake after 14 days. Most failures involve missing the SDLC Automation domain (CodePipeline / CodeDeploy / CodeBuild trivia) or the Incident Response domain (Incident Manager + EventBridge patterns).

## Patterns to internalize

- "Zero-downtime deploy" + "auto rollback" = CodeDeploy blue/green with alarm
- "Cross-account pipeline" = AssumeRole pattern  
- "Patch at scale" = SSM Patch Manager
- "Centralized observability across accounts" = CloudWatch cross-account observability
- "Automated remediation" = EventBridge → Step Functions or Incident Manager runbook
- "Drift detection" = CloudFormation native drift APIs
- "Self-service infrastructure" = Service Catalog or Proton
- "Canary Lambda deploy" = SAM DeploymentPreference: Canary10Percent10Minutes
