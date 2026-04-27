# DP-700 - 6-Week Practice Plan

This plan assumes 1-2 hours of theory + 1-2 hours of hands-on lab per day.

---

## Lab setup

- [ ] Activate the [Microsoft Fabric Free Trial](https://learn.microsoft.com/fabric/get-started/fabric-trial) (60-day F64 trial capacity)
- [ ] Create a workspace; set up a sample dataset (NYC Taxi, World Bank, etc.)
- [ ] Connect the Capacity Metrics App
- [ ] Have access to a free Cosmos DB / Snowflake / SQL DB account if you want to try Mirroring

---

## Week 1 - Fabric Architecture and Workspaces

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-fabric-architecture-and-workspaces.md](./notes/01-fabric-architecture-and-workspaces.md)
- [ ] Microsoft Learn: "Get started with Microsoft Fabric"

### Hands-on
- [ ] Create a workspace; assign trial capacity
- [ ] Explore the workspace: create a Lakehouse, Warehouse, Notebook
- [ ] Navigate the Monitoring Hub

### Self-check
- [ ] Can I describe how OneLake relates to Lakehouses and Warehouses?
- [ ] Can I explain capacity vs workspace vs items?

---

## Week 2 - Ingestion Patterns

### Reading
- [ ] [notes/02-ingestion-pipelines-eventstream.md](./notes/02-ingestion-pipelines-eventstream.md)

### Hands-on
- [ ] Build a Pipeline: Copy Data from public CSV → Lakehouse Files → Notebook → Lakehouse Table
- [ ] Build a Dataflow Gen2 to clean and reshape some data into a Warehouse
- [ ] Configure an Eventstream from sample data → Lakehouse + KQL DB
- [ ] (If you have a free Cosmos DB) Set up Mirroring; observe the replication

### Self-check
- [ ] Can I pick the right ingestion pattern for a given prompt?
- [ ] Do I know Dataflow Gen2 vs Notebook tradeoffs?

---

## Week 3 - Lakehouse and Warehouse

### Reading
- [ ] [notes/03-lakehouse-warehouse-notebooks.md](./notes/03-lakehouse-warehouse-notebooks.md)

### Hands-on
- [ ] Notebook: read CSV, transform, MERGE upsert into Delta table
- [ ] OPTIMIZE + VORDER + ZORDER on the table
- [ ] Time-travel a table back 1 day
- [ ] In a Warehouse: cross-Lakehouse query with 3-part naming
- [ ] Build a Power BI report on top using Direct Lake mode
- [ ] Compare query latency: Import vs DirectQuery vs Direct Lake

### Self-check
- [ ] Can I write a basic PySpark transform end-to-end?
- [ ] Do I know when to use Lakehouse vs Warehouse?

---

## Week 4 - Security, Governance, Deployment

### Reading
- [ ] [notes/04-security-governance-deployment.md](./notes/04-security-governance-deployment.md)

### Hands-on
- [ ] Create a Dev / Test / Prod workspace pair; set up a Deployment Pipeline
- [ ] Add a deployment rule to swap a data source between environments
- [ ] Connect the Dev workspace to a Git repo (Azure DevOps free or GitHub free)
- [ ] Commit changes from the workspace UI; PR to main
- [ ] Apply sensitivity labels to a Lakehouse and a semantic model

### Self-check
- [ ] Can I promote items Dev → Prod with parameter swaps?
- [ ] Do I know the difference between workspace roles and item permissions?

---

## Week 5 - Monitoring, Optimization, Real-time

### Reading
- [ ] [notes/05-monitoring-optimization.md](./notes/05-monitoring-optimization.md)
- [ ] Microsoft Learn: Real-Time Intelligence in Fabric

### Hands-on
- [ ] Connect Capacity Metrics App; review yesterday's CU consumption
- [ ] Run a slow Spark job; use Spark UI to diagnose
- [ ] Build a Reflex item that triggers on a stream condition
- [ ] Configure pipeline failure alerts via email

### Self-check
- [ ] Can I find which item is consuming the most CUs?
- [ ] Can I diagnose a slow Direct Lake query? (V-Order, OPTIMIZE, partition)

---

## Week 6 - Practice and Review

### Reading
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) cover to cover
- [ ] Work through [scenarios.md](./scenarios.md)

### Practice exams
- [ ] Microsoft Learn DP-700 Practice Assessment (free, official)
- [ ] [resources/practice-questions/](../../../resources/practice-questions/) - DP-700 questions if added
- [ ] One paid exam vendor (Whizlabs / MeasureUp - if you can wait, MeasureUp is the official partner)
- [ ] Score 80%+ before scheduling

### Schedule the exam
- [ ] Book through Pearson VUE or Microsoft Learn

---

## Stop signals (you're ready)

- [ ] You can build an end-to-end Fabric pipeline (ingest → transform → BI) without notes
- [ ] You can pick the right ingestion pattern for any prompt
- [ ] You can troubleshoot a slow Spark job using Spark UI
- [ ] You can promote items Dev → Prod with parameter swaps
- [ ] You score 80%+ on practice exams twice in a row
