# 06. Sustainability and GreenOps

## Why Sustainability Belongs in FinOps

The FinOps Framework elevated Cloud Sustainability as a named Capability in the 2024-2025 refresh. The practical reason: the metrics, personas, data pipelines, and governance loops for cost and carbon overlap substantially. Efficiency wins typically deliver both cost savings and carbon reductions. The FinOps practice is the natural home for carbon accountability in cloud.

The Professional exam expects you to integrate sustainability into scorecards, not treat it as a separate program.

## Scope 1 / 2 / 3

Enterprise GHG accounting uses three scopes:

- **Scope 1**: direct emissions (owned equipment, fleet, on-site generation)
- **Scope 2**: purchased energy (grid electricity)
- **Scope 3**: everything else in the value chain (supply chain, travel, purchased goods, and cloud usage as an upstream service)

Cloud provider emissions are typically **Scope 3 Category 1** (purchased goods and services) for the customer. Cloud providers themselves report their own Scope 1/2/3 in their sustainability reports; what they give you is a customer-specific view of emissions associated with your usage.

## Cloud Provider Carbon Reports

### AWS Customer Carbon Footprint Tool (CCFT)
- Monthly emissions data at the account level
- Scope 2 (location-based and market-based)
- Does not currently include Scope 3 of AWS
- Forecasts assume AWS's 100 percent renewables pledge

### Azure Emissions Impact Dashboard
- Power BI dashboard fed by Azure data
- Scope 1, 2, 3 associated with your Azure usage
- Regional breakdown

### Google Cloud Carbon Footprint
- Per-project, per-region emissions
- BigQuery export available
- Market-based methodology

Limitations common to all:

- Reporting lags 1-3 months
- Methodologies differ; direct comparisons require care
- Newer regions may have less data
- Forecasts depend on provider renewables roadmap assumptions

## Software Carbon Intensity (SCI)

The Green Software Foundation SCI spec defines:

```
SCI = ((E * I) + M) per R
```

- E = energy consumed (kWh)
- I = carbon intensity of the energy (gCO2e/kWh)
- M = embodied emissions (manufacturing and lifecycle of hardware, allocated)
- R = a functional unit (per user, per request, per transaction)

SCI is a rate, like unit economics for carbon. Lower SCI = more carbon-efficient software per unit of business value.

## GreenOps Practices

### Region selection
Some regions have cleaner grids than others. Example: eu-north-1 (Sweden) typically has lower carbon intensity than some US regions. Trade-offs:

- Data residency and compliance
- Latency to users
- Service availability (not all regions have all services)
- Cost (pricing varies by region)

Pick the cleanest region consistent with requirements, not the cheapest.

### Workload scheduling
Some workloads can shift in time or place to match low-carbon periods (carbon-aware scheduling). Tools: Carbon Aware SDK (Green Software Foundation), custom schedulers reading grid-mix APIs.

Applicable workloads: batch jobs, ML training, data ETL, media encoding.

### Efficiency as co-benefit
Rightsizing, consolidation, serverless adoption, storage tiering, shutting down idle resources all reduce cost and emissions simultaneously. These are the easiest GreenOps wins.

### Hardware choice
- ARM / Graviton / Ampere typically better perf/watt than x86 for many workloads
- GPU and accelerator efficiency varies significantly by generation and workload
- Newer chip generations generally more energy efficient

### Data lifecycle
- Deleting stale data reduces storage emissions
- Archive tiers are much more carbon-efficient than hot tiers
- Avoid "cold data in hot storage"

## Integrating Carbon into the Scorecard

Add these KPIs:

- Total tCO2e (monthly, by BU, by cloud)
- SCI or similar intensity metric (per unit of business value)
- Percent of workloads in low-carbon regions
- Cost and carbon co-benefit tracking for optimization projects

Report carbon alongside cost in executive reviews. The message: efficiency is the dominant lever for both.

## Offsets vs Reductions

Offsets (purchased carbon credits) are controversial and increasingly distrusted. The FinOps and GreenOps stance: reduce first, offset only what cannot be reduced, and be transparent about the difference.

Do not confuse "net zero through offsets" with actual emissions reductions. The exam may test this distinction.

## GreenOps Governance

Elements of a mature program:

- Executive sustainability sponsor
- Carbon KPI in quarterly business reviews
- Region selection policy (prefer low-carbon regions)
- Workload classification (carbon-sensitive, carbon-tolerant)
- Procurement integration (vendor sustainability in evaluations)
- Annual sustainability report with cloud emissions section

## Common Exam Traps

- Treating sustainability as separate from cost
- Believing offsets equal reductions
- Assuming all regions are equally clean
- Ignoring embodied emissions (M in SCI)
- Focusing on Scope 1 and 2 only while missing Scope 3 for cloud usage
- Designing a carbon program without named ownership
- Forgetting data lifecycle as a carbon lever, not just a cost lever
