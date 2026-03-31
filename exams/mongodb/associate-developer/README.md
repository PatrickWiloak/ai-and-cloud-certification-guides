# MongoDB Associate Developer

## Exam Overview

The MongoDB Associate Developer exam validates the ability to build applications using MongoDB. This certification demonstrates proficiency in CRUD operations, data modeling, indexing, aggregation pipelines, and Atlas tools for application development.

**Exam Details:**
- **Exam Code:** MongoDB Associate Developer
- **Duration:** 75 minutes
- **Number of Questions:** 62 multiple-choice questions
- **Passing Score:** 65%
- **Cost:** $150 USD
- **Delivery:** Online proctored
- **Validity:** 3 years
- **Prerequisites:** None (hands-on MongoDB development experience recommended)

## Exam Domains

### Domain 1: CRUD Operations (30%)
- Insert, find, update, and delete operations
- Update operators ($set, $inc, $push, $pull, $unset)
- Bulk write operations
- Query operators and projections
- Cursor methods and modifiers

**Key Operations:**
- insertOne(), insertMany()
- find(), findOne()
- updateOne(), updateMany(), replaceOne()
- deleteOne(), deleteMany()
- bulkWrite()

### Domain 2: Indexes (15%)
- Single field, compound, and multikey indexes
- Text and geospatial indexes
- TTL and unique indexes
- Index performance analysis with explain()
- Index creation strategies

**Key Concepts:**
- Index selectivity and cardinality
- Covered queries
- ESR rule (Equality, Sort, Range)
- Index intersection

### Domain 3: Data Modeling (20%)
- Embedding vs referencing patterns
- Schema design patterns (polymorphic, bucket, outlier, attribute)
- One-to-one, one-to-many, many-to-many relationships
- Schema validation
- Document size limits

**Key Patterns:**
- Embedded documents for frequently accessed related data
- References for large or independently accessed data
- Subset pattern for reducing working set size
- Extended reference pattern for reducing joins

### Domain 4: Aggregation (25%)
- Pipeline stages ($match, $group, $project, $lookup, $unwind)
- Aggregation expressions and operators
- $facet for multi-faceted aggregations
- $graphLookup for graph queries
- Aggregation optimization

**Key Stages:**
- $match, $group, $project, $sort, $limit, $skip
- $lookup (left outer join), $unwind
- $addFields, $set, $replaceRoot
- $bucket, $bucketAuto, $facet

### Domain 5: Atlas Tools (10%)
- Atlas Search (full-text search)
- Atlas Charts (data visualization)
- Atlas Data API (REST API for CRUD)
- Atlas Triggers (event-driven functions)

**Key Concepts:**
- Search index creation and configuration
- Lucene-based search operators
- Chart types and data source configuration
- Trigger types (database, scheduled, authentication)

## Study Materials

### Official Resources
- **[📖 MongoDB Documentation](https://www.mongodb.com/docs/)** - Complete MongoDB documentation
- **[📖 MongoDB University](https://learn.mongodb.com/)** - Free courses and learning paths
- **[📖 MongoDB CRUD Operations](https://www.mongodb.com/docs/manual/crud/)** - CRUD reference guide
- **[📖 MongoDB Aggregation](https://www.mongodb.com/docs/manual/aggregation/)** - Aggregation framework guide

### Study Guide Files
| Resource | Description |
|----------|-------------|
| [Fact Sheet](fact-sheet.md) | Quick reference with exam details and key facts |
| [Study Strategy](strategy.md) | Recommended study approach and timeline |
| [Practice Plan](practice-plan.md) | Week-by-week study schedule with hands-on labs |
| [Scenarios](scenarios.md) | High-yield exam scenarios and solution patterns |
| [Notes](notes/) | Detailed topic notes organized by domain |

### Notes Index
| File | Topics Covered |
|------|---------------|
| [01 - CRUD Operations](notes/01-crud-operations.md) | insertOne/Many, find, update operators, delete, bulk write |
| [02 - Indexes](notes/02-indexes.md) | Single field, compound, multikey, text, geospatial, TTL |
| [03 - Data Modeling](notes/03-data-modeling.md) | Embedding vs referencing, schema patterns |
| [04 - Aggregation](notes/04-aggregation.md) | Pipeline stages, expressions, operators |
| [05 - Atlas Tools](notes/05-atlas-tools.md) | Atlas Search, Charts, Data API, Triggers |
