# MongoDB Associate Developer - Fact Sheet

## 📋 Exam Overview

**Exam Name:** MongoDB Associate Developer
**Duration:** 75 minutes
**Questions:** 62 multiple-choice questions
**Passing Score:** 65%
**Cost:** $150 USD
**Valid For:** 3 years
**Delivery:** Online proctored

**[📖 Official Certification Page](https://learn.mongodb.com/pages/certification)** - Registration and details
**[📖 MongoDB Documentation](https://www.mongodb.com/docs/)** - Complete reference
**[📖 MongoDB University](https://learn.mongodb.com/)** - Free learning resources

## 🎯 Target Audience

This certification is designed for:
- Application developers building with MongoDB
- Backend engineers using MongoDB for data storage
- Full-stack developers working with document databases
- Data engineers designing MongoDB schemas
- Professionals with 6+ months MongoDB development experience

## 📚 Exam Domains

### Domain 1: CRUD Operations (30%)

**Insert Operations:**
- `db.collection.insertOne({doc})` - Insert single document
- `db.collection.insertMany([{doc1}, {doc2}])` - Insert multiple documents
- `_id` is auto-generated as ObjectId if not specified
- `ordered: false` option continues on error for insertMany

**Query Operations:**
- `db.collection.find({filter}, {projection})` - Find matching documents
- `db.collection.findOne({filter})` - Find first matching document
- Cursor methods: `.sort()`, `.limit()`, `.skip()`, `.count()`

**Query Operators:**
| Operator | Description | Example |
|----------|-------------|---------|
| `$eq` | Equal | `{age: {$eq: 25}}` |
| `$ne` | Not equal | `{status: {$ne: "inactive"}}` |
| `$gt` / `$gte` | Greater than (or equal) | `{age: {$gt: 18}}` |
| `$lt` / `$lte` | Less than (or equal) | `{price: {$lt: 100}}` |
| `$in` | In array | `{status: {$in: ["A", "B"]}}` |
| `$nin` | Not in array | `{status: {$nin: ["D"]}}` |
| `$and` | Logical AND | `{$and: [{a: 1}, {b: 2}]}` |
| `$or` | Logical OR | `{$or: [{a: 1}, {b: 2}]}` |
| `$not` | Logical NOT | `{age: {$not: {$gt: 25}}}` |
| `$exists` | Field exists | `{email: {$exists: true}}` |
| `$type` | Field type | `{age: {$type: "number"}}` |
| `$regex` | Regular expression | `{name: {$regex: /^J/}}` |
| `$elemMatch` | Array element match | `{scores: {$elemMatch: {$gt: 80}}}` |
| `$all` | All elements match | `{tags: {$all: ["a", "b"]}}` |
| `$size` | Array size | `{tags: {$size: 3}}` |

**Update Operators:**
| Operator | Description | Example |
|----------|-------------|---------|
| `$set` | Set field value | `{$set: {name: "new"}}` |
| `$unset` | Remove field | `{$unset: {temp: ""}}` |
| `$inc` | Increment value | `{$inc: {count: 1}}` |
| `$mul` | Multiply value | `{$mul: {price: 1.1}}` |
| `$rename` | Rename field | `{$rename: {old: "new"}}` |
| `$min` / `$max` | Update if less/greater | `{$min: {low: 5}}` |
| `$push` | Add to array | `{$push: {tags: "new"}}` |
| `$pull` | Remove from array | `{$pull: {tags: "old"}}` |
| `$addToSet` | Add unique to array | `{$addToSet: {tags: "x"}}` |
| `$pop` | Remove first/last array element | `{$pop: {tags: 1}}` |
| `$each` | Modifier for $push/$addToSet | `{$push: {tags: {$each: ["a","b"]}}}` |

**[📖 CRUD Reference](https://www.mongodb.com/docs/manual/crud/)** - Complete CRUD documentation

### Domain 2: Indexes (15%)

**Index Types:**
- **Single Field** - Index on one field: `db.col.createIndex({field: 1})`
- **Compound** - Multiple fields: `db.col.createIndex({a: 1, b: -1})`
- **Multikey** - Automatically created for array fields
- **Text** - Full-text search: `db.col.createIndex({content: "text"})`
- **Geospatial** - 2d and 2dsphere indexes for location queries
- **Hashed** - Hash-based: `db.col.createIndex({field: "hashed"})`
- **TTL** - Auto-delete documents: `db.col.createIndex({created: 1}, {expireAfterSeconds: 3600})`
- **Unique** - Enforce uniqueness: `db.col.createIndex({email: 1}, {unique: true})`
- **Sparse** - Only index documents with the field: `{sparse: true}`
- **Partial** - Index subset: `{partialFilterExpression: {status: "active"}}`

**ESR Rule for Compound Indexes:**
- **E**quality fields first (exact match)
- **S**ort fields next (ordering)
- **R**ange fields last (inequality, $gt, $lt)

**[📖 Indexes](https://www.mongodb.com/docs/manual/indexes/)** - Index documentation

### Domain 3: Data Modeling (20%)

**Embedding vs Referencing:**
| Factor | Embed | Reference |
|--------|-------|-----------|
| Read frequency together | High | Low |
| Data size | Small | Large |
| Update frequency | Low | High |
| Relationship | One-to-few | One-to-many (large) |
| Atomicity needed | Yes | No |

**Document Size Limit:** 16 MB maximum per document

**Schema Patterns:**
- **Polymorphic** - Different document shapes in same collection
- **Bucket** - Group time-series data into buckets
- **Outlier** - Handle documents with unusual array sizes
- **Attribute** - Convert many similar fields to key-value pairs
- **Subset** - Store frequently accessed subset in main document
- **Extended Reference** - Copy frequently accessed fields from referenced document
- **Computed** - Pre-compute and store derived values

**[📖 Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)** - Schema design guide

### Domain 4: Aggregation (25%)

**Key Pipeline Stages:**
| Stage | Description |
|-------|-------------|
| `$match` | Filter documents (like find) |
| `$group` | Group by field, compute aggregates |
| `$project` | Reshape documents, include/exclude fields |
| `$sort` | Sort documents |
| `$limit` / `$skip` | Pagination |
| `$lookup` | Left outer join with another collection |
| `$unwind` | Deconstruct array into separate documents |
| `$addFields` / `$set` | Add computed fields |
| `$count` | Count documents |
| `$facet` | Multiple aggregation pipelines in parallel |
| `$bucket` | Categorize into buckets |
| `$replaceRoot` | Replace document with subdocument |
| `$merge` / `$out` | Write results to collection |
| `$graphLookup` | Recursive graph traversal |

**[📖 Aggregation Pipeline](https://www.mongodb.com/docs/manual/core/aggregation-pipeline/)** - Pipeline reference

### Domain 5: Atlas Tools (10%)

**Atlas Search:**
- Full-text search powered by Apache Lucene
- Search indexes defined on collections
- Operators: text, phrase, autocomplete, compound, range
- Accessed via `$search` aggregation stage

**Atlas Charts:**
- Built-in data visualization tool
- Connects directly to Atlas collections
- Chart types: bar, line, scatter, heatmap, geo, etc.

**Atlas Data API:**
- REST API for CRUD operations
- HTTP endpoints for find, insert, update, delete
- Authentication via API keys

**Atlas Triggers:**
- Database triggers (on insert/update/delete)
- Scheduled triggers (cron-based)
- Authentication triggers (on user events)

**[📖 Atlas Search](https://www.mongodb.com/docs/atlas/atlas-search/)** - Atlas Search documentation
**[📖 Atlas Triggers](https://www.mongodb.com/docs/atlas/app-services/triggers/)** - Triggers documentation

## 🔑 Key Limits to Remember

| Limit | Value |
|-------|-------|
| Max document size | 16 MB |
| Max BSON nesting depth | 100 levels |
| Max namespace length | 120 bytes |
| Max indexes per collection | 64 |
| Max compound index fields | 32 |
| Max index key size | 1024 bytes |
| Max pipeline memory usage | 100 MB (per stage) |
| Max `$lookup` result size | 100 MB (16 MB per document) |
