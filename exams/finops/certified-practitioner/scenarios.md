# FinOps Certified Practitioner - Practice Scenarios

## Scenario 1: Establishing Cost Visibility

**Situation:** A mid-size company has migrated 60% of its workloads to AWS and Azure. The CFO is frustrated because they cannot determine which departments are responsible for the $500K monthly cloud bill. The engineering teams have no visibility into their spending, and there is no consistent tagging across either cloud provider.

**Question:** What is the best first step to address this problem?

A) Implement Reserved Instances across all workloads to reduce costs immediately
B) Establish a tagging strategy with mandatory tags and implement showback reporting
C) Move all workloads to a single cloud provider to simplify billing
D) Hire a FinOps consultant to implement chargeback immediately

**Correct Answer:** B

**Explanation:** The Inform phase is the foundation of FinOps. Before you can optimize or operate, you need visibility. Establishing a consistent tagging strategy with mandatory tags (cost center, owner, environment, project) and implementing showback reporting gives all stakeholders visibility into spending. This is the Crawl stage of FinOps maturity.

**Why other answers are wrong:**
- A) You should not optimize (rate optimization with RIs) before you have visibility into spending patterns
- C) Multi-cloud is a valid strategy - consolidating for billing simplicity misses the point
- D) Chargeback requires mature cost allocation - showback is the appropriate starting point

---

## Scenario 2: Rate Optimization Decision

**Situation:** A company has been running stable production workloads on AWS for 18 months. Analysis shows consistent usage of 50 m5.xlarge instances 24/7 with minimal variation. Development environments use 20 m5.large instances during business hours (8am-6pm weekdays). The FinOps team wants to optimize rates.

**Question:** What is the most appropriate rate optimization strategy?

A) Purchase 3-year All Upfront Reserved Instances for all 70 instances
B) Purchase 1-year Compute Savings Plans for production, use spot instances for development
C) Convert all workloads to spot instances to maximize savings
D) Purchase 1-year Reserved Instances for production and schedule development instances to stop after hours

**Correct Answer:** D

**Explanation:** Production workloads with consistent, predictable usage are ideal candidates for Reserved Instances. Development environments that only run during business hours should be scheduled to stop after hours - this is usage optimization. Combining rate optimization (RIs for production) with usage optimization (scheduling for dev) maximizes savings while managing risk appropriately.

**Why other answers are wrong:**
- A) 3-year All Upfront for everything is too aggressive - dev does not need RIs if properly scheduled
- B) Spot instances are not appropriate for development environments where interruption would disrupt developers
- C) Spot instances for production workloads is too risky - interruption would cause outages

---

## Scenario 3: Organizational FinOps Adoption

**Situation:** A large enterprise has a FinOps team of two analysts. They have implemented basic cost reporting, but engineering teams ignore the reports. The VP of Engineering says cost management is "not my team's problem" and the CFO wants to implement strict chargeback immediately to force accountability.

**Question:** What is the most effective approach to improve FinOps adoption?

A) Implement chargeback immediately as the CFO requests
B) Escalate to the CEO to mandate FinOps participation
C) Work with engineering leadership to demonstrate the value of cost optimization, start with showback, and celebrate quick wins
D) Remove cloud access from teams that do not comply with cost policies

**Correct Answer:** C

**Explanation:** FinOps principle 1 is "Teams need to collaborate." Forcing chargeback or mandating compliance creates resistance. The most effective approach is to build relationships with engineering leadership, demonstrate the value of cost optimization through quick wins, and start with showback to build cost awareness gradually. This aligns with the FinOps cultural approach - it is a practice built on collaboration, not enforcement.

**Why other answers are wrong:**
- A) Chargeback without mature cost allocation and buy-in will create friction and resistance
- B) Top-down mandates without building relationships rarely drive lasting cultural change
- D) Removing access is punitive and damages the collaborative relationship FinOps requires

---

## Scenario 4: Handling Shared Costs

**Situation:** A company runs a shared Kubernetes cluster that hosts applications from five different product teams. The monthly infrastructure cost is $100K. The platform team manages the cluster. Product teams want to understand their individual costs, but all resources run on shared nodes. The FinOps team needs to allocate these costs.

**Question:** What is the best approach to allocate shared Kubernetes costs?

A) Divide the $100K equally among five teams ($20K each)
B) Allocate costs based on namespace resource requests and usage metrics, with platform overhead distributed proportionally
C) Charge the entire $100K to the platform team since they manage the cluster
D) Ignore shared costs and only report on individually tagged resources

**Correct Answer:** B

**Explanation:** Shared costs should be allocated based on actual consumption where possible. In Kubernetes, namespace-level resource requests and usage metrics provide a fair allocation basis. Platform overhead (control plane, monitoring, etc.) should be distributed proportionally across teams based on their consumption. This gives teams accurate signals about their cost impact and incentivizes efficient resource usage.

**Why other answers are wrong:**
- A) Equal division does not reflect actual usage - a team using 50% of resources pays the same as one using 5%
- C) Charging platform team removes accountability from product teams that drive resource consumption
- D) Ignoring shared costs means a significant portion of spending is invisible to teams

---

## Scenario 5: Waste Identification and Reduction

**Situation:** A FinOps analyst discovers the following in their AWS environment: 200 unattached EBS volumes (total: $8K/month), 15 idle RDS instances in development accounts ($12K/month), 50 EC2 instances averaging 5% CPU utilization ($25K/month), and $5K/month in data transfer costs from cross-region replication that was set up for a project that ended 6 months ago.

**Question:** How should the FinOps team prioritize addressing this waste?

A) Start with the cheapest items first to build momentum with quick wins
B) Address everything simultaneously by shutting down all identified resources
C) Prioritize by impact - address the 50 underutilized EC2 instances first, then idle RDS instances, then clean up storage and data transfer
D) Focus only on right-sizing the EC2 instances since they are the largest cost

**Correct Answer:** C

**Explanation:** Prioritize waste reduction by impact. The 50 underutilized EC2 instances at $25K/month represent the largest savings opportunity through right-sizing. The 15 idle RDS instances at $12K/month are the next highest impact and can likely be terminated or stopped. Then clean up EBS volumes ($8K) and unnecessary data transfer ($5K). This is methodical, prioritized by financial impact, and allows for validation before action.

**Why other answers are wrong:**
- A) Starting with cheapest items delays the biggest savings - prioritize by impact
- B) Shutting everything down simultaneously is risky - some resources may be needed
- D) Focusing only on EC2 ignores $25K/month in other waste

---

## Scenario 6: FinOps Maturity Assessment

**Situation:** A company has the following FinOps capabilities: manual monthly cost reports sent via email, no consistent tagging strategy, basic AWS Budgets alerts set up, a single person handling cost optimization part-time, no integration between finance and engineering teams, and ad-hoc optimization when costs spike.

**Question:** What maturity level is this organization at, and what should they focus on to advance?

A) Walk stage - they should implement automation and advanced analytics
B) Crawl stage - they should focus on establishing consistent tagging, real-time reporting, and a dedicated FinOps function
C) Run stage - they should focus on optimization and cultural embedding
D) Pre-Crawl - they should start by getting executive buy-in before doing anything else

**Correct Answer:** B

**Explanation:** This organization is in the Crawl stage. They have basic cost awareness (monthly reports, budget alerts) but lack foundational elements like consistent tagging, real-time visibility, and cross-functional collaboration. To advance to Walk, they should establish a consistent tagging strategy, implement real-time cost reporting dashboards, create a dedicated FinOps function (even if small), and build bridges between finance and engineering teams.

**Why other answers are wrong:**
- A) Walk stage would have automated reporting, consistent tagging, and cross-functional processes - this organization lacks these
- C) Run stage implies fully automated processes and cultural embedding - this organization is far from that
- D) They already have some FinOps elements (reports, budgets), so they are not pre-Crawl

---

## Scenario 7: Multi-Cloud FinOps Strategy

**Situation:** A company runs workloads across AWS (60%), Azure (30%), and GCP (10%). Each cloud has different teams managing costs with different tools. The CFO wants a unified view of cloud spending. The AWS team uses Cost Explorer, Azure team uses Cost Management, and the GCP team uses BigQuery billing exports.

**Question:** What is the best approach to create a unified FinOps practice?

A) Consolidate all workloads to a single cloud provider
B) Implement a cloud-agnostic FinOps platform that normalizes data across providers, establish unified tagging standards, and create a centralized FinOps team
C) Let each cloud team continue managing costs independently but add the totals together in a spreadsheet
D) Choose the largest cloud provider's tools (AWS) as the standard for all reporting

**Correct Answer:** B

**Explanation:** FinOps principle 3 states "A centralized team drives FinOps." For multi-cloud environments, a cloud-agnostic platform (such as Apptio Cloudability or CloudHealth) can normalize billing data across providers. Unified tagging standards ensure consistent cost allocation regardless of provider. A centralized FinOps team coordinates optimization efforts across all clouds while each cloud team retains technical expertise.

**Why other answers are wrong:**
- A) Consolidation is a major strategic decision - FinOps works across multiple clouds
- C) Manual spreadsheet consolidation is error-prone, delayed, and does not scale
- D) AWS-native tools cannot effectively manage Azure and GCP costs

---

## Scenario 8: Commitment Coverage Strategy

**Situation:** A company has $200K/month in compute spending. Currently 20% is covered by Reserved Instances. The FinOps team wants to increase commitment coverage. Analysis shows: $80K is stable production (running 24/7 for 18+ months), $60K is variable production (scales 2-5x based on traffic), $40K is development and testing, and $20K is experimental workloads.

**Question:** What is the optimal commitment strategy?

A) Purchase RIs to cover 100% of the $200K monthly compute
B) Purchase RIs or Savings Plans for the $80K stable production, use Compute Savings Plans for the baseline of variable production (~$30K), and leave dev/test and experimental on-demand
C) Use spot instances for everything except stable production
D) Do not purchase any commitments until spending patterns stabilize further

**Correct Answer:** B

**Explanation:** Commitment-based discounts should match risk tolerance. Stable production at $80K/month with 18+ months of history is ideal for RIs or Savings Plans. Variable production has a predictable baseline (~$30K) that can be covered by flexible Compute Savings Plans, with the variable portion remaining on-demand. Dev/test and experimental workloads are too variable or short-lived for commitments - they should stay on-demand or use scheduling/spot where appropriate.

**Why other answers are wrong:**
- A) 100% coverage means committing to variable and experimental workloads - high risk of waste
- C) Spot instances for variable production risks interruption during traffic spikes
- D) 18 months of stable usage is sufficient data - delaying commitments wastes money on on-demand rates
