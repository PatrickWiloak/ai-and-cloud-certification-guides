# DP-700 - Exam-Style Scenarios

12 scenarios covering the major exam domains. Read the prompt, pick the best answer, then check the explanation.

---

### Scenario 1
**You need to continuously replicate Azure Cosmos DB data into Fabric for analytics with the lowest engineering effort. What do you configure?**

**Best answer:** Mirroring - configure mirroring on the Cosmos DB account from the Fabric workspace. Initial backfill + ongoing CDC, no pipeline required. Lands as Delta in OneLake.

---

### Scenario 2
**A real-time IoT stream from Azure IoT Hub must land in a Lakehouse and also feed a real-time dashboard with sub-second latency.**

**Best answer:** Eventstream with two destinations: a Lakehouse (for batch/long-term analytics) and a KQL Database / Eventhouse (for the sub-second dashboard via real-time queries).

---

### Scenario 3
**Power BI users need to query a 100GB Lakehouse table with import-like speed without the import refresh cycle.**

**Best answer:** Use Direct Lake storage mode in Power BI. Optimize with V-Order on the Delta table.

---

### Scenario 4
**A data engineer needs full T-SQL DDL/DML on a table (CREATE / UPDATE / DELETE), but the table needs to live in OneLake.**

**Best answer:** Use a Warehouse. Lakehouse SQL endpoint is read-only. Both store data as Delta in OneLake.

---

### Scenario 5
**You need to promote a Pipeline from Dev to Test to Prod, swapping the source data source for each environment.**

**Best answer:** Deployment Pipelines with deployment rules that swap source parameters per environment.

---

### Scenario 6
**A Spark notebook job is taking 6 hours and one task is much slower than others. Diagnostic approach?**

**Best answer:** Open the Spark UI from the notebook execution. Look at stage and task durations. Slow single task = data skew. Mitigate by salting the join key, repartitioning, or broadcasting the smaller side.

---

### Scenario 7
**A Cosmos DB query analyst needs read access to a specific Lakehouse, but should not see other items in the same workspace.**

**Best answer:** Don't grant workspace role. Instead, grant Read at the item level on the specific Lakehouse only.

---

### Scenario 8
**Daily revenue must trigger an email alert when it drops more than 20% from yesterday.**

**Best answer:** Reflex item watching a KQL query (or a Power BI semantic model measure) with a condition rule. Trigger email or Power Automate flow on alert.

---

### Scenario 9
**You want a low-code transform that filters, joins, and reshapes data from 3 SaaS sources into a Warehouse table.**

**Best answer:** Dataflow Gen2 with output to the Warehouse. Power Query handles the filter/join/reshape; the Warehouse output destination loads the result.

---

### Scenario 10
**The team wants to back the workspace's content with version control and review changes via PRs.**

**Best answer:** Connect the workspace to an Azure DevOps or GitHub repo using Fabric Git integration. Items sync as JSON/source. Commits and PRs work as expected.

---

### Scenario 11
**A Lakehouse table grows to 5 TB and Direct Lake queries slow down. What do you do?**

**Best answer:** Run `OPTIMIZE table VORDER` on the Delta table. Optionally `OPTIMIZE table ZORDER BY (col)` on commonly-filtered columns. Partition the table by date if appropriate. Vacuum old versions.

---

### Scenario 12
**Which item type is appropriate for sub-second analytics on streaming data with Kusto query language?**

**Best answer:** KQL Database / Eventhouse. Backed by Kusto engine. Optimized for real-time analytics on append-only event data.

---

## Scoring guide

- **10-12:** Schedule the exam.
- **7-9:** Re-read fact-sheet and weak-area notes.
- **<7:** More hands-on practice with Fabric Free Trial.

DP-700 has multiple-choice + multi-response + case studies + sometimes labs. These scenarios test pattern recognition; build hands-on fluency with the Fabric UI for the labs.
