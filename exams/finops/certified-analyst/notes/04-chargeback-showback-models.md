# 04. Chargeback and Showback Models

## Definitions

- **Showback**: visibility of costs to business units without an actual financial transfer. Teams see what they spend; budgets and P&L do not move on that basis.
- **Chargeback**: actual internal financial transfer. Business unit budget is debited, IT / platform budget is credited.
- **Hybrid**: showback for most cost, chargeback for a subset (for example, only production prod cost is charged back, dev is showback).

The exam will use these words precisely. If the scenario says "reported to teams but budget does not change," that is showback, period.

## When to Choose Which

| Factor | Favors showback | Favors chargeback |
|--------|-----------------|-------------------|
| Allocation maturity | < 90 percent allocated | > 95 percent allocated |
| Finance readiness | No internal billing process | Established transfer pricing |
| Accountability pressure | Moderate | High |
| Dispute tolerance | Low | Must have a defined process |
| Organizational culture | Collaborative, early-stage FinOps | Accountable, mature |

Chargeback without the maturity to back it up creates disputes and political damage. Most orgs land on hybrid.

## Mechanics of Chargeback

### Transfer pricing
The rate at which internal cost is charged. Options:

- **Pass-through**: exact cost, dollar for dollar
- **Pass-through plus overhead**: cost plus a markup for platform and FinOps labor
- **Fixed-rate**: pre-negotiated unit rates (for example, dollars per CPU-hour for a shared platform)
- **Blended**: an averaged rate across a portfolio

### Timing
- Monthly reconciliation is standard
- True-up and true-down processes handle late-arriving adjustments and credits
- Close calendar must align with finance close

### Journal entries and accounting
Chargeback involves real GL entries. FinOps does not do the accounting, but must produce the data Finance needs: allocation key, cost center, period, dollar value, and an audit trail.

## Mechanics of Showback

Showback is lighter weight but still requires:

- Defined owners (per team)
- Agreed allocation methods
- Regular cadence (monthly at minimum)
- Narrative (why cost changed)

Showback can evolve into "soft chargeback" where team performance includes cost efficiency goals without moving budget.

## Shared Services Under Chargeback

Every chargeback model must handle shared services. Options:

- Allocate proportionally to direct spend (most common)
- Allocate by a driver (requests, GB, cores)
- Absorb in a central platform budget (simplest, but reduces accountability)
- Fixed percent of BU budget (predictable, but arbitrary)

## Commitments Under Chargeback

Commitments (RIs, SPs, CUDs) create allocation puzzles.

- Who gets the discount? Options: the BU that owns the workload consuming the commit, a central pool, or a weighted distribution.
- How do you handle unused commitment? Options: central absorption, spread proportionally, or charge the BU that ordered it.

The cleanest pattern: a central commit pool buys, operates, and owns unused risk. BUs are charged at EffectiveCost (post-discount). This encourages engineering to commit-worthy architectures without creating budget fights.

## Showback and Chargeback Pitfalls

### Pitfall 1: Stale allocation
Allocating based on last month's tags for this month's cost. Always allocate on the period's data.

### Pitfall 2: Hidden overhead
Shared services without a clear line item erode trust.

### Pitfall 3: Month-end surprises
Delivering a chargeback report on the 28th for a period closing on the 30th creates fear, not accountability. Provide daily in-progress views.

### Pitfall 4: Disputes without process
Every chargeback system needs a dispute workflow with SLAs and an arbiter.

### Pitfall 5: Wrong unit of accountability
If a BU has no ability to change a cost (shared platform mandated by policy), charging them back is politics without value.

## Implementation Checklist

1. Confirm allocation coverage above threshold (90-95 percent for chargeback)
2. Document transfer pricing method
3. Define shared services treatment
4. Define commitment allocation policy
5. Build monthly reconciliation process with true-up
6. Build dispute workflow
7. Agree on cadence, format, distribution
8. Partner with Finance on GL mapping
9. Agree on cutover date, parallel run for one period
10. Educate BUs and socialize the model before go-live

## KPIs for the Chargeback Practice

- Allocation coverage
- Dispute rate and dispute aging
- Reconciliation cycle time
- Forecast accuracy per BU (proxy for their ownership)
- Behavioral KPI: cost per unit of value by BU (is accountability changing behavior?)

## Common Exam Traps

- Calling pure visibility "chargeback" because teams are "held accountable"
- Forgetting that chargeback requires Finance partnership, not just FinOps
- Assuming every org should chargeback (many mature orgs stay at showback by choice)
- Confusing blended rates (a pricing concept) with chargeback rates (a transfer pricing concept)
- Ignoring commitment allocation as a chargeback design decision
