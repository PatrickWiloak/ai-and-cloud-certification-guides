# MongoDB Associate Developer - Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: CRUD Operations - Insert and Query

#### Day 1-2: Insert Operations and Document Structure
- [ ] Study BSON data types and document structure
- [ ] Learn insertOne() and insertMany() with options
- [ ] Understand ObjectId generation and _id field behavior
- [ ] Hands-on: Set up Atlas free tier and import sample data
- [ ] Lab: Insert documents with various data types and nested structures
- [ ] Review Notes: `01-crud-operations.md`

#### Day 3-4: Query Operations and Operators
- [ ] Study comparison operators ($eq, $ne, $gt, $gte, $lt, $lte, $in, $nin)
- [ ] Learn logical operators ($and, $or, $not, $nor)
- [ ] Practice element operators ($exists, $type)
- [ ] Study array operators ($elemMatch, $all, $size)
- [ ] Hands-on: Write complex queries against sample datasets
- [ ] Lab: Build queries using multiple operator combinations

#### Day 5-6: Projections and Cursor Methods
- [ ] Study projection syntax (inclusion and exclusion)
- [ ] Learn cursor methods: sort(), limit(), skip(), count()
- [ ] Understand cursor behavior and batching
- [ ] Practice combining query operators with projections
- [ ] Hands-on: Build paginated queries with sort and limit
- [ ] Lab: Use cursor methods for data exploration

#### Day 7: Week 1 Review
- [ ] Complete CRUD query practice questions
- [ ] Practice writing queries from requirements descriptions
- [ ] Review query operator syntax

### Week 2: CRUD Operations - Update and Delete

#### Day 8-9: Update Operations
- [ ] Study updateOne(), updateMany(), and replaceOne()
- [ ] Learn update operators ($set, $unset, $inc, $mul, $rename, $min, $max)
- [ ] Practice array update operators ($push, $pull, $addToSet, $pop, $each)
- [ ] Understand upsert option and findOneAndUpdate()
- [ ] Hands-on: Practice all update operators on sample data
- [ ] Lab: Build update operations for complex document structures
- [ ] Review Notes: `01-crud-operations.md`

#### Day 10-11: Delete and Bulk Operations
- [ ] Study deleteOne() and deleteMany()
- [ ] Learn findOneAndDelete() for atomic operations
- [ ] Understand bulkWrite() with ordered and unordered options
- [ ] Practice bulk operations mixing inserts, updates, and deletes
- [ ] Hands-on: Implement bulk write operations
- [ ] Lab: Build a data migration script using bulk operations

#### Day 12-13: Advanced CRUD Patterns
- [ ] Study findOneAndUpdate() with returnDocument option
- [ ] Learn about write concerns and read concerns
- [ ] Understand atomic operations and transactions basics
- [ ] Practice error handling for CRUD operations
- [ ] Hands-on: Implement optimistic concurrency control
- [ ] Lab: Build a complete CRUD application

#### Day 14: Week 2 Review
- [ ] Complete CRUD update/delete practice questions
- [ ] Build end-to-end CRUD application
- [ ] Review all update operators

### Week 3: Indexes

#### Day 15-16: Single Field and Compound Indexes
- [ ] Study single field index creation and behavior
- [ ] Learn compound index design and the ESR rule
- [ ] Understand index direction (ascending vs descending)
- [ ] Practice using explain() to analyze query plans
- [ ] Hands-on: Create indexes and analyze performance impact
- [ ] Lab: Optimize slow queries using appropriate indexes
- [ ] Review Notes: `02-indexes.md`

#### Day 17-18: Special Index Types
- [ ] Study multikey indexes for array fields
- [ ] Learn text indexes for full-text search
- [ ] Understand geospatial indexes (2d and 2dsphere)
- [ ] Study TTL indexes for automatic document expiration
- [ ] Hands-on: Create and test each index type
- [ ] Lab: Build a location-based query with geospatial index

#### Day 19-20: Index Optimization
- [ ] Study covered queries and index-only plans
- [ ] Learn about index selectivity and cardinality
- [ ] Understand partial and sparse indexes
- [ ] Practice index intersection and multi-index queries
- [ ] Hands-on: Analyze and optimize query performance
- [ ] Lab: Design indexes for complex query patterns

#### Day 21: Week 3 Review
- [ ] Complete index practice questions
- [ ] Review ESR rule with examples
- [ ] Practice explain() interpretation

### Week 4: Data Modeling

#### Day 22-23: Embedding vs Referencing
- [ ] Study embedding patterns and when to embed
- [ ] Learn referencing patterns and when to reference
- [ ] Understand one-to-one, one-to-many, and many-to-many relationships
- [ ] Practice modeling different relationship types
- [ ] Hands-on: Model a blog application with users, posts, comments
- [ ] Lab: Compare embedded vs referenced performance
- [ ] Review Notes: `03-data-modeling.md`

#### Day 24-25: Schema Design Patterns
- [ ] Study polymorphic pattern for heterogeneous collections
- [ ] Learn bucket pattern for time-series data
- [ ] Understand outlier pattern for unbounded arrays
- [ ] Study attribute pattern for varied field sets
- [ ] Hands-on: Implement each pattern with sample data
- [ ] Lab: Design schema for an e-commerce application

#### Day 26-27: Schema Validation and Advanced Modeling
- [ ] Study JSON Schema validation rules
- [ ] Learn computed pattern for pre-aggregated data
- [ ] Understand subset pattern for working set optimization
- [ ] Practice schema versioning strategies
- [ ] Hands-on: Add schema validation to collections
- [ ] Lab: Design schema for a real-world use case

#### Day 28: Week 4 Review
- [ ] Complete data modeling practice questions
- [ ] Review pattern selection criteria
- [ ] Practice modeling from requirements

### Week 5: Aggregation Pipeline

#### Day 29-30: Core Pipeline Stages
- [ ] Study $match, $group, $project, $sort, $limit, $skip
- [ ] Learn $group accumulators ($sum, $avg, $min, $max, $push, $first)
- [ ] Understand pipeline stage ordering for optimization
- [ ] Hands-on: Build aggregation pipelines for analytics queries
- [ ] Lab: Create reports using $match and $group combinations
- [ ] Review Notes: `04-aggregation.md`

#### Day 31-32: Joins and Array Operations
- [ ] Study $lookup for cross-collection joins
- [ ] Learn $unwind for array deconstruction
- [ ] Understand $addFields/$set for computed fields
- [ ] Practice $replaceRoot for document reshaping
- [ ] Hands-on: Build pipelines with $lookup and $unwind
- [ ] Lab: Join orders with customer data using $lookup

#### Day 33-34: Advanced Aggregation
- [ ] Study $facet for multi-faceted results
- [ ] Learn $bucket and $bucketAuto for categorization
- [ ] Understand $graphLookup for recursive queries
- [ ] Study $merge and $out for writing results
- [ ] Hands-on: Build complex multi-stage pipelines
- [ ] Lab: Create a dashboard query using $facet

#### Day 35: Week 5 Review and Atlas Tools
- [ ] Study Atlas Search basics and $search stage
- [ ] Learn Atlas Charts, Data API, and Triggers overview
- [ ] Complete aggregation practice questions
- [ ] Review Notes: `05-atlas-tools.md`

### Week 6: Exam Preparation

#### Day 36-37: Full Practice Exams
- [ ] Take first full-length practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify weak domains and knowledge gaps
- [ ] Create flashcards for missed concepts

#### Day 38-39: Targeted Review
- [ ] Focus study on weakest domains
- [ ] Review all operator reference tables
- [ ] Practice aggregation pipeline construction
- [ ] Review data modeling decision trees

#### Day 40-41: Final Review
- [ ] Take second full-length practice exam
- [ ] Review CRUD operator syntax
- [ ] Review aggregation stage ordering
- [ ] Review index types and ESR rule
- [ ] Light review of all notes

#### Day 42: Exam Day Preparation
- [ ] Quick review of fact sheet
- [ ] Review common pitfalls
- [ ] Ensure exam environment is ready
- [ ] Rest and prepare mentally

## 📊 Domain Study Time Allocation

| Domain | Weight | Recommended Hours |
|--------|--------|-------------------|
| CRUD Operations | 30% | 18-22 hours |
| Aggregation | 25% | 16-20 hours |
| Data Modeling | 20% | 12-15 hours |
| Indexes | 15% | 10-12 hours |
| Atlas Tools | 10% | 6-8 hours |
| **Total** | **100%** | **62-77 hours** |
