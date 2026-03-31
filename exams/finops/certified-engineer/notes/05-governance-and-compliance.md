# Governance and Compliance

**[📖 FinOps Capabilities - Cloud Policy and Governance](https://www.finops.org/framework/capabilities/cloud-policy-and-governance/)** - Governance capability

## Overview

This document covers FinOps governance, compliance, organizational alignment, and cultural practices. Governance ensures that cost optimization efforts are sustainable and aligned with organizational policies and regulatory requirements.

## Cloud Governance Framework

### Governance Layers
| Layer | Scope | Enforced By | Examples |
|-------|-------|-------------|---------|
| Organizational policies | Company-wide rules | Management | Budget approval thresholds |
| Cloud account structure | Account/subscription design | Platform team | Account per environment |
| Resource policies | Resource-level controls | Automation | Required tags, instance limits |
| Financial controls | Budget and spending limits | Finance + FinOps | Budget alerts, approval gates |

### Account/Subscription Structure
```
Organization (root)
  ├── Management Account (billing consolidated)
  ├── Production OU
  │     ├── prod-platform
  │     ├── prod-data
  │     └── prod-ml
  ├── Non-Production OU
  │     ├── dev-platform
  │     ├── staging-platform
  │     └── sandbox
  └── Shared Services OU
        ├── networking
        ├── security
        └── logging
```

### Benefits of Account Separation
- Clear cost attribution per business unit
- Blast radius isolation for security
- Independent resource quotas per account
- Simplified budget tracking and alerts
- Service control policies per organizational unit

## Policy Enforcement

### Preventive Controls
| Control | Provider | Purpose |
|---------|----------|---------|
| Service Control Policies | AWS Organizations | Restrict allowed services/regions |
| Azure Policy | Azure | Enforce compliance rules |
| Organization Policy | GCP | Constrain resource configuration |
| IAM Policies | All providers | Restrict who can create resources |

### AWS Service Control Policies
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLargeInstances",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "ForAnyValue:StringLike": {
          "ec2:InstanceType": ["*.12xlarge", "*.16xlarge", "*.24xlarge", "*.metal"]
        }
      }
    },
    {
      "Sid": "DenyUntaggedResources",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "rds:CreateDBInstance"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/team": "true"
        }
      }
    }
  ]
}
```

### Azure Policy Examples
```json
{
  "policyRule": {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Compute/virtualMachines"
        },
        {
          "not": {
            "field": "tags['team']",
            "exists": "true"
          }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
}
```

### Detective Controls
- Cost anomaly monitoring
- Untagged resource reports
- Unused resource detection
- Budget variance alerts
- Commitment utilization tracking

### Corrective Controls
- Auto-stop idle dev instances
- Auto-tag resources from metadata
- Auto-remediate policy violations
- Auto-scale based on utilization
- Auto-archive old storage

## Budgeting and Forecasting

### Budget Types
| Type | Description | Use Case |
|------|-------------|----------|
| Fixed budget | Set amount per period | Stable, predictable workloads |
| Variable budget | Based on business metric | Growing or seasonal workloads |
| Rolling budget | Adjusted quarterly based on actuals | Dynamic environments |

### Budget Process
```
1. Historical analysis (what did we spend last quarter?)
2. Growth projection (what business growth is expected?)
3. New initiatives (what new projects are planned?)
4. Optimization targets (what savings are expected?)
5. Buffer (10-15% contingency)
6. Approval (finance + engineering + business)
7. Monitor (weekly tracking against budget)
8. Adjust (quarterly reforecast)
```

### Forecasting Inputs
- Historical spend patterns (12+ months preferred)
- Known upcoming changes (new services, migrations)
- Business growth projections
- Planned optimization savings
- Commitment expiration/renewal dates
- Seasonal patterns (holiday traffic, year-end processing)

## FinOps Operating Model

### Team Structure Options
| Model | Description | Best For |
|-------|-------------|----------|
| Centralized | Single FinOps team drives all optimization | Small-medium organizations |
| Federated | FinOps team + embedded engineers per team | Large organizations |
| Hybrid | Central team for strategy, federated for execution | Most organizations |

### FinOps Cadence
| Frequency | Activity | Participants |
|-----------|----------|-------------|
| Daily | Anomaly review, quick wins | FinOps team |
| Weekly | Team cost reviews, optimization progress | Engineering leads |
| Monthly | Executive cost review, budget tracking | Leadership + FinOps |
| Quarterly | Commitment review, strategic planning | All stakeholders |
| Annually | Architecture review, vendor negotiations | All stakeholders |

### Communication Framework
```
Executive Report (Monthly):
- Total spend vs budget
- Month-over-month trend
- Top 3 cost drivers
- Key optimization achievements
- Risks and action items

Team Report (Weekly):
- Team spend vs budget
- Right-sizing recommendations
- Waste identified
- Action items from last week
- Optimization wins

Engineering Digest (Daily/Weekly):
- Anomaly alerts
- New optimization recommendations
- Resource utilization summaries
- Quick win opportunities
```

## Compliance Considerations

### Regulatory Requirements
| Regulation | Relevance to FinOps | Requirement |
|-----------|-------------------|-------------|
| SOX | Financial reporting accuracy | Accurate cost allocation and reporting |
| GDPR | Data residency | Region-specific deployments affect cost |
| HIPAA | Data protection | Security controls add cost |
| PCI DSS | Payment data security | Dedicated environments increase cost |

### Compliance Impact on Cost
- Data residency requirements may prevent cost-optimal region selection
- Security controls (encryption, monitoring) add infrastructure cost
- Compliance auditing requires dedicated logging and storage
- Separation of environments (PCI vs non-PCI) increases overhead
- Retention requirements impact storage costs

### FinOps and Sustainability
- Cloud sustainability is an emerging FinOps concern
- Right-sizing reduces energy consumption
- Region selection affects carbon footprint
- Providers offer carbon footprint tools:
  - AWS: Customer Carbon Footprint Tool
  - Azure: Emissions Impact Dashboard
  - GCP: Carbon Footprint

## Stakeholder Management

### Building FinOps Culture
1. **Start with visibility** - Share cost data openly
2. **Celebrate wins** - Recognize teams that optimize
3. **Gamify** - Leaderboards for cost efficiency
4. **Educate** - Training on cloud pricing and optimization
5. **Incentivize** - Include cost metrics in engineering goals
6. **Embed** - Cost as part of architecture review process

### Handling Resistance
| Objection | Response |
|-----------|----------|
| "It's not my job" | Cost is everyone's responsibility, like security |
| "Performance is more important" | Right-sizing improves both cost AND performance |
| "We don't have time" | Start small, automate over time |
| "Cloud is already cheap" | Show the delta between optimal and current spend |
| "We need maximum capacity" | Show utilization data, propose auto-scaling |

### Success Metrics
| Metric | Description | Target |
|--------|-------------|--------|
| Optimization savings | Dollar savings from actions taken | Increasing quarter over quarter |
| Tag compliance | Percentage of resources properly tagged | > 90% |
| Budget accuracy | Forecast vs actual variance | < 10% variance |
| Commitment utilization | Usage of purchased commitments | > 95% |
| Cost per unit trend | Unit economics improvement | Decreasing over time |
| Time to detect anomaly | Hours from spike to alert | < 24 hours |
| Recommendation adoption | Percentage of recommendations implemented | > 60% |
