# Databricks GenAI Engineer Associate - Practice Plan

A 5-week study plan assuming 1-2 hours of theory + 1-2 hours of hands-on lab per day. Adjust if you have less time available.

The exam tests applied judgment on RAG design, evaluation, governance, and production GenAI patterns on Databricks. Hands-on with Mosaic AI / Vector Search / MLflow Evaluation is essential.

---

## Lab setup (do this in week 1, day 1)

- [ ] Create a Databricks free trial account ([databricks.com/try](https://www.databricks.com/try-databricks))
- [ ] Confirm access to Mosaic AI Vector Search, Model Serving, and Foundation Models APIs
- [ ] Clone the [official Databricks GenAI cookbook](https://github.com/databricks/genai-cookbook) examples
- [ ] Have a sample document corpus ready (PDFs, Markdown, or any 50-1000 documents) for RAG labs

---

## Week 1 - RAG Foundations + Architecture

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-rag-design.md](./notes/01-rag-design.md) deep read
- [ ] Databricks RAG documentation
- [ ] Pinecone, Weaviate, or other vendor's RAG tutorial for cross-reference

### Hands-on
- [ ] Build a baseline RAG: ingest 50 documents → embeddings → Vector Search → query
- [ ] Try at least 3 chunking strategies (fixed-size, recursive, semantic)
- [ ] Compare retrieval quality with cosine vs hybrid (BM25 + dense)
- [ ] Implement a basic re-ranker

### Self-check
- [ ] Can I describe when to use a vector DB vs full-text search?
- [ ] Do I know the tradeoffs between dense, sparse, and hybrid retrieval?
- [ ] Can I explain how chunking strategy affects retrieval quality?
- [ ] Do I know the major Databricks Vector Search features (DBSQL integration, automated sync)?

---

## Week 2 - RAG Implementation on Databricks

### Reading
- [ ] [notes/02-rag-implementation.md](./notes/02-rag-implementation.md) deep read
- [ ] Mosaic AI Vector Search docs
- [ ] Foundation Model API docs (DBRX, Llama, Mixtral hosting)
- [ ] Model Serving on Databricks docs

### Hands-on
- [ ] Build an end-to-end RAG with Mosaic AI Vector Search and Foundation Model APIs
- [ ] Use Delta Live Tables for the ingestion pipeline
- [ ] Implement Unity Catalog governance over the document corpus
- [ ] Add prompt-injection guardrails (input validation + output filtering)
- [ ] Deploy as a Model Serving endpoint
- [ ] Make sure the endpoint logs all inputs/outputs to a Delta table for evaluation

### Self-check
- [ ] Can I deploy a working RAG endpoint on Databricks from data ingestion through inference?
- [ ] Do I know Model Serving routes (provisioned vs auto-scaling pay-per-token)?
- [ ] Can I describe the pros and cons of Foundation Model APIs vs hosting your own?
- [ ] Can I explain how Unity Catalog governs the RAG datasets?

---

## Week 3 - Evaluation and Iteration

### Reading
- [ ] [notes/03-governance-evaluation.md](./notes/03-governance-evaluation.md) deep read
- [ ] MLflow Evaluation docs (especially `mlflow.evaluate()` for LLMs)
- [ ] Mosaic AI Agent Framework Evaluation docs
- [ ] LLM-as-judge research (a quick paper read on calibration)

### Hands-on
- [ ] Build an evaluation set for your RAG (100+ question-answer pairs with expected answers)
- [ ] Use MLflow Evaluation with LLM judges to score responses
- [ ] Track multiple eval runs in MLflow Experiments
- [ ] Try at least 2 prompt variations and measure quality delta
- [ ] Implement a simple regression gate: if eval score drops below baseline, fail the deployment

### Self-check
- [ ] Can I write a useful evaluation set for a RAG? What dimensions do I score?
- [ ] Do I know LLM-as-judge calibration techniques (few-shot examples, score rubrics)?
- [ ] Can I run a head-to-head comparison of two prompts using MLflow?
- [ ] Do I understand how to detect retrieval failures vs generation failures?

---

## Week 4 - Production, Monitoring, and Governance

### Reading
- [ ] [notes/03-governance-evaluation.md](./notes/03-governance-evaluation.md) re-read governance sections
- [ ] AI Gateway docs (input/output rate limiting, PII filtering)
- [ ] AI/BI Genie + AI Functions in Databricks SQL
- [ ] Lakehouse Monitoring for ML / GenAI
- [ ] Responsible AI guidelines (Microsoft / Anthropic / Google all publish good ones)

### Hands-on
- [ ] Configure AI Gateway with rate limits and PII redaction
- [ ] Set up Lakehouse Monitoring on the inference logs
- [ ] Build a dashboard tracking: latency p50/p95/p99, token usage, eval scores over time, refusal rate
- [ ] Configure alerting (CloudWatch / equivalent) for quality drift
- [ ] Implement an A/B test between two prompt versions using Model Serving traffic split

### Self-check
- [ ] Can I list 5 things I monitor on a production GenAI endpoint?
- [ ] Do I know how to detect drift (input distribution change, output quality drop)?
- [ ] Can I implement traffic-split A/B testing in Model Serving?
- [ ] Do I know the governance controls Databricks provides for GenAI (audit logs, lineage, access)?

---

## Week 5 - Practice Exams and Weak Areas

### Reading
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) end to end
- [ ] Re-read all 3 notes files
- [ ] Browse the Databricks GenAI Engineer Associate exam guide (official)

### Practice exams
- [ ] Databricks Academy practice questions (free if available)
- [ ] Whizlabs or other third-party practice exam (~1 vendor)
- [ ] [Databricks DE Associate practice questions](../../../resources/practice-questions/databricks-data-engineer-associate.md) (related; covers similar Databricks platform basics)
- [ ] Score 80%+ on the same practice exam twice in a row before scheduling

### Drill weak areas
- [ ] Identify 3-5 weakest topics
- [ ] Re-do hands-on labs for those areas
- [ ] Read official docs cover-to-cover for those topics

### Schedule the exam
- [ ] Book through Webassessor or wherever Databricks proctors
- [ ] Confirm exam logistics, ID, quiet space if online

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30 min | Read notes / docs section |
| 60-90 min | Hands-on lab on the day's topic |
| 30 min | Practice questions on the day's topic |
| 15 min | Note open questions; review tomorrow's plan |

---

## Stop signals (when you're ready)

You're ready to schedule the exam when **all** are true:

- [ ] You can build an end-to-end RAG on Databricks (ingest → vector → retrieve → generate → eval) without notes
- [ ] You can describe MLflow Evaluation patterns for LLMs
- [ ] You know when to use Vector Search vs SQL full-text vs hybrid
- [ ] You can list 5 production governance/monitoring concerns for GenAI apps
- [ ] You score 80%+ on practice exams twice in a row
