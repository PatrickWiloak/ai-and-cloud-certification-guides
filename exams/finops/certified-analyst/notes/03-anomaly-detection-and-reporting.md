# 03. Anomaly Detection and Reporting

## Definitions Matter

- **Anomaly**: a statistically unusual deviation from expected cost or usage
- **Variance**: a difference between plan (budget, forecast) and actual, not necessarily unusual
- **Drift**: a slow, cumulative change that would not trigger a daily anomaly but shifts the baseline
- **Incident**: an anomaly that warranted action (not every anomaly is an incident)

Exam items will test whether you can pick the right concept for a scenario. A team overspending its quarterly budget by a known amount is variance, not anomaly.

## Detection Techniques

### Threshold
Fixed dollar or percent deviation. Simple, noisy, good as a coarse cutoff ("alert only if over 1000 dollars swing").

### Statistical
- **Z-score**: standard deviations from mean; assumes normality
- **MAD (median absolute deviation)**: robust to outliers and skew, preferred for spiky spend
- **Seasonal decomposition**: separates trend, seasonality, residual; alert on residual

### Machine learning
- Prophet, ARIMA, STL, or vendor black boxes (AWS Cost Anomaly Detection, Azure Anomaly Detector, GCP Recommender)
- Advantage: handles complex seasonality
- Risk: opacity and tuning overhead

### Hybrid
A common production pattern: absolute dollar floor, percent relative floor, and a statistical z-score or MAD test, all three must fire.

## Signal-to-Noise Tuning

The failure mode of anomaly detection is alert fatigue. Practical rules:

- Set a minimum dollar floor so small-service noise does not page
- Suppress known periodic events (month-end billing, quarterly true-ups)
- Route to owners, not a firehose channel
- Measure false positive rate and adjust
- Target less than five high-quality anomalies per day across a large org

## Anomaly Workflow

1. Detect (automated)
2. Classify (billing event, usage event, rate change, architecture change, misconfiguration, security)
3. Route to owner with context
4. Owner acknowledges, investigates, resolves
5. Post-mortem if dollar impact is material
6. Feedback tuning (adjust thresholds or suppressions)

## The FOCUS Lens on Anomalies

FOCUS gives you ChargeCategory and ChargeClass, which are your first classification cut:

- ChargeCategory values: Usage, Purchase, Tax, Credit, Adjustment
- ChargeClass: Correction, Refund, or null for standard

A spike that is 90 percent ChargeCategory = Tax is not a usage anomaly; it is a billing event. Always decompose spikes by these dimensions first.

## Variance Analysis

Variance analysis is about plan vs actual.

- **Period variance**: this month vs last month, this week vs same week last year
- **Plan variance**: actual vs budget or forecast
- **Run-rate variance**: annualized current burn vs target

Key metric: **forecast accuracy** = 1 - (abs(actual - forecast) / actual). Report monthly by business unit.

## Reporting

### Audience-specific content

| Audience | Cadence | Key content |
|----------|---------|-------------|
| Engineering teams | Daily/weekly | Per-service, per-namespace trend, anomalies, recommendations |
| Engineering leaders | Weekly/monthly | Team-level totals, efficiency KPIs, commit coverage, top movers |
| Finance | Monthly | Plan vs actual, forecast, amortized view, accounting treatment |
| Executives | Monthly/quarterly | Unit economics, cost per revenue, run-rate, strategic bets |
| Product | Monthly | Cost per tenant, cost per feature, cost of serve |

### Report design principles

- Start with a headline number and trend
- Always pair cost with a driver (users, transactions, requests)
- Annotate known events (price changes, commit purchases, migrations)
- Provide drill-down paths, do not hide detail
- Include data freshness (how old is the newest row)

## Dashboards vs Reports

Dashboards are for monitoring and ad-hoc investigation. Reports are for narrative and decisions. Do not try to make a dashboard do the work of a report.

## KPI Portfolio

Core anomaly and reporting KPIs to know:

- Anomaly count (by severity, per week)
- Mean time to detect (MTTD) and resolve (MTTR) for cost anomalies
- Forecast accuracy (by business unit)
- Report freshness (hours since latest data)
- Report adoption (unique viewers per week)
- Unallocated spend trend

## Practical Patterns

- Use both a daily and a weekly check; daily catches spikes, weekly catches drift
- Maintain a known-event calendar (promotions, migrations, audits)
- Provide a "why" with every alert (which dimension, which resource, likely cause)
- Keep a running anomaly log; patterns emerge over quarters

## Common Exam Traps

- Mixing up anomaly and variance vocabulary
- Assuming ML is always better (explainability matters)
- Over-alerting by using percent-only thresholds on small services
- Ignoring ChargeCategory decomposition as a first step
- Reporting only BilledCost when the audience needs EffectiveCost
