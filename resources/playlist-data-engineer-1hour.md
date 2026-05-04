---
last-updated: 2026-05-03
---

# Playlist - Data engineer, 1 hour

Seven reads in order, ~60 minutes. By the end you have working mental models for the data engineer's daily concerns: consistency tradeoffs, batch vs streaming, lake vs lakehouse, the modern analytics stack, and the AI / vector layer that's increasingly part of the role.

## The reads, in order

1. **[Eventual consistency](../learn/concepts/eventual-consistency.md)** (~7 min)
   The single most-impactful concept for data engineers. Why your read replicas lag, why CDN caches drift, why "use strong consistency for everything" is the wrong default.

2. **[Queues vs streams](../learn/concepts/queues-vs-streams.md)** (~6 min)
   Kafka / Kinesis / Pub/Sub vs SQS / Service Bus / Cloud Tasks. The fundamental dispatch architectures and when each fits.

3. **[Architecture pattern: data pipeline / ETL](./architecture-patterns/data-pipeline-etl.md)** (~12 min)
   The canonical batch ETL: sources → extract → transform → load → warehouse → BI. With AWS / Azure / GCP implementations.

4. **[Architecture pattern: lakehouse](./architecture-patterns/lakehouse-architecture.md)** (~10 min)
   The modern unified architecture: bronze / silver / gold tiers, open table formats (Delta, Iceberg, Hudi), one storage that serves SQL and Spark and ML.

5. **[Service comparison: databases](./service-comparison-databases.md)** (~10 min)
   When to pick relational, NoSQL, document, wide-column, graph. AWS / Azure / GCP equivalents at each tier.

6. **[Decision matrix: vector database](./decision-matrix-vector-database.md)** (~8 min)
   The AI side of the data stack. Vector search is increasingly part of the data engineer's surface area.

7. **[Databases topic index](../topics/databases.md)** (~7 min)
   Cross-pillar wrap-up: concepts, comparisons, deep-dives, hands-on, and the certs that test data-engineering skills.

## What you can do after this playlist

- Articulate the consistency / availability tradeoffs for any data system.
- Read a streaming architecture diagram and predict where backpressure will show up.
- Pick a database tier (transactional / analytical / wide-column / vector) for a given workload.
- Recognize the modern lakehouse pattern and what it replaces.
- Discuss why Delta / Iceberg / Hudi exist (and why you don't pick all three).

## Next steps

**If you want to build:**
- [Build a data pipeline](./hands-on-projects/build-data-pipeline.md) - hands-on ETL
- [Build a RAG pipeline](./hands-on-projects/build-rag-pipeline.md) - the AI / vector data layer

**If you want to go deeper:**
- [Service comparison: messaging and queues](./service-comparison-messaging-queues.md) - the layer above queues / streams
- [Service comparison: GenAI platforms](./service-comparison-genai-platforms.md) - the LLM-serving side
- [Architecture pattern: CQRS / event sourcing](./architecture-patterns/cqrs-event-sourcing.md) - advanced data architecture

**If you want a cert:**
- [AWS Data Engineer Associate (DEA-C01)](../exams/aws/associate/data-engineer-dea-c01/)
- [Azure Data Engineer Associate (DP-203)](../exams/azure/dp-203/)
- [GCP Professional Data Engineer](../exams/gcp/data-engineer/) - the deepest data-cert option
- [Databricks Data Engineer](../exams/databricks/data-engineer-associate/) (Associate or Professional)
- [Snowflake SnowPro Core](../exams/snowflake/snowpro-core/) and Advanced specializations
- [Data Engineer roadmap](./certification-roadmap-data-engineer.md)

## Related playlists

- [AI engineer in 30 min](./playlist-ai-engineer-30min.md)
- [Cloud security in 1 hour](./playlist-cloud-security-1hour.md)
- [SRE in 1 hour](./playlist-sre-1hour.md)
