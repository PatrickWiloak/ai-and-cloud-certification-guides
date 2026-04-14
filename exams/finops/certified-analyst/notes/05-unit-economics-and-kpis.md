# 05. Unit Economics and KPIs

## Why Unit Economics

Total cloud cost alone is uninterpretable. A 20 percent increase in cost can be good (revenue grew 40 percent) or catastrophic (revenue flat). Unit economics translate cloud cost into cost-per-unit-of-business-value, making cloud cost comparable, reportable, and defensible.

## Picking the Right Unit

The unit should be:

- Meaningful to the business (Product and Finance agree)
- Measurable reliably (instrumented, stable definition)
- Sensitive to cloud decisions (if it does not move when you change cloud architecture, it is the wrong unit)
- Stable over time (you can compare quarters)

Common units:

- Cost per tenant or customer
- Cost per active user (MAU, DAU)
- Cost per transaction, API call, or order
- Cost per GB ingested or stored
- Cost per inference (ML workloads)
- Cost per requested CPU-hour (platform services)

Some orgs track several; a SaaS company might track cost per active user, cost per customer, and cost per 1000 API calls.

## Building the Metric

The numerator is **allocated EffectiveCost** for the unit's scope. The denominator is the business unit. Both must be for the same time period and the same scope.

Common errors:

- Numerator includes shared cost that should not belong (over-allocation)
- Denominator uses a different period (month for cost, week for users)
- Denominator scope does not match (all customers in numerator, only active in denominator)

## Core FinOps KPIs

### Allocation quality
- **Allocation coverage**: allocated cost / total cost
- **Tag coverage**: tagged resources / total resources
- **Unallocated dollars trend**: absolute unallocated per month

### Commitment health
- **Commitment coverage**: eligible usage covered by commits / total eligible usage
- **Commitment utilization**: commitment hours used / commitment hours purchased
- **Effective Savings Rate (ESR)**: (ListCost - EffectiveCost) / ListCost

ESR is the most underused KPI. It integrates rate optimization into one number. A healthy ESR varies by industry but 15-35 percent is common.

### Efficiency
- **Cost per unit of value** (your chosen units)
- **Idle resource percent**: idle cost / total cost
- **Storage efficiency**: GB used / GB billed, or hot vs cold tier mix

### Forecast and plan
- **Forecast accuracy**: 1 - abs(actual - forecast) / actual
- **Plan variance**: (actual - plan) / plan
- **Budget burn rate**: cumulative spend / days elapsed, annualized

### Practice operations
- **MTTD for anomalies**
- **MTTR for anomalies**
- **Allocation dispute rate**
- **FinOps education reach**: percent of engineers trained

## Formula Review

Memorize these; exam questions often embed a calculation.

```
ESR = (ListCost - EffectiveCost) / ListCost
Commitment Coverage = Covered Eligible Usage / Total Eligible Usage
Commitment Utilization = Used Commit Hours / Purchased Commit Hours
Forecast Accuracy = 1 - abs(Actual - Forecast) / Actual
Amortized Monthly RI Cost = Upfront / Term Months + Hourly Rate * Hours
Blended Rate = Total Cost / Total Usage (weighted average across pricing tiers)
Cost per Unit = Allocated EffectiveCost / Units
```

## Connecting to Business Value

Unit economics are not just KPIs, they are the bridge to business decisions:

- Is our gross margin stable as we scale? (cost per customer trend vs revenue per customer)
- Does a new feature earn its cost? (feature cost vs revenue lift)
- Are we efficient enough to compete on price? (cost per transaction vs competitor benchmarks)
- Is cloud cost growing faster than revenue? (cloud cost growth rate vs revenue growth rate)

The sixth principle ("decisions driven by business value of cloud") is operationalized by unit economics. The exam will test this linkage.

## Scorecards and Reporting

A FinOps scorecard typically has 5-10 KPIs, reviewed monthly with leadership. Example layout:

| KPI | Target | This month | Trend |
|-----|--------|-----------|-------|
| Allocation coverage | 95% | 93.4% | up |
| ESR | 25% | 22.1% | flat |
| Commitment coverage | 70% | 68% | up |
| Commitment utilization | 98% | 99.2% | flat |
| Cost per active user | < $0.42 | $0.39 | down (good) |
| Forecast accuracy | > 95% | 93.8% | down |
| Idle cost | < 5% | 4.2% | flat |

## Common Anti-patterns

- Tracking 40 KPIs (no one reads them; pick 5-10)
- Changing definitions silently (destroys trend)
- Reporting only total cost (no business context)
- Using BilledCost for unit economics (EffectiveCost is correct)
- Presenting KPIs without targets (no one knows if they are good)

## Common Exam Traps

- Using BilledCost instead of EffectiveCost for unit cost
- Confusing coverage with utilization
- Confusing ESR with commitment savings alone (ESR includes all discount sources)
- Ignoring the scope alignment of numerator and denominator
- Quoting percent changes without absolute context
