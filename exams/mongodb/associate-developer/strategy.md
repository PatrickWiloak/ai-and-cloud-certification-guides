# MongoDB Associate Developer - Study Strategy

## 🎯 Study Approach

### Phase 1: CRUD Foundations (1-2 weeks)
1. **Core Operations**
   - Master insert, find, update, and delete operations
   - Learn all query operators ($eq, $gt, $in, $and, $or, $regex, etc.)
   - Practice update operators ($set, $inc, $push, $pull, $addToSet)
   - Understand cursor methods (sort, limit, skip, count)

2. **Hands-on Practice**
   - Set up MongoDB Atlas free tier or local MongoDB
   - Import sample datasets and practice queries
   - Use MongoDB Compass for visual query building
   - Practice with MongoDB Shell (mongosh)

### Phase 2: Indexes and Data Modeling (2-3 weeks)
1. **Indexing**
   - Create and analyze different index types
   - Practice using explain() to analyze query performance
   - Learn the ESR rule for compound index design
   - Understand covered queries and index selectivity

2. **Data Modeling**
   - Study embedding vs referencing trade-offs
   - Learn schema design patterns (polymorphic, bucket, outlier, attribute)
   - Practice modeling different relationship types
   - Understand document size limits and working set size

### Phase 3: Aggregation and Atlas (2-3 weeks)
1. **Aggregation Pipeline**
   - Build pipelines with $match, $group, $project, $sort
   - Practice $lookup for cross-collection joins
   - Learn $unwind for array deconstruction
   - Implement $facet for multi-faceted results
   - Understand pipeline optimization rules

2. **Atlas Tools**
   - Create Atlas Search indexes and run search queries
   - Build charts with Atlas Charts
   - Use Atlas Data API for REST-based access
   - Configure database triggers

### Phase 4: Exam Preparation (1 week)
1. **Practice Questions**
   - Take practice exams
   - Review incorrect answers with documentation
   - Focus on CRUD (30%) and Aggregation (25%) - these are 55% of the exam

2. **Final Review**
   - Review operator reference tables
   - Review aggregation stage syntax
   - Review index types and their use cases

## 📚 Study Resources

### Official MongoDB Resources
- **[📖 MongoDB University](https://learn.mongodb.com/)** - Free courses and certifications
- **[📖 MongoDB Documentation](https://www.mongodb.com/docs/)** - Complete reference
- **[📖 MongoDB Developer Center](https://www.mongodb.com/developer/)** - Tutorials and articles
- **[📖 MongoDB Playground](https://mongoplayground.net/)** - Online query playground

### Recommended Courses
- **[📖 MongoDB CRUD Operations (MongoDB University)](https://learn.mongodb.com/)** - Free CRUD course
- **[📖 MongoDB Aggregation (MongoDB University)](https://learn.mongodb.com/)** - Free aggregation course
- **[📖 MongoDB Data Modeling (MongoDB University)](https://learn.mongodb.com/)** - Free modeling course
- **[📖 MongoDB Indexes (MongoDB University)](https://learn.mongodb.com/)** - Free indexing course

### Practice and Hands-on
- **[📖 MongoDB Atlas](https://www.mongodb.com/atlas)** - Free tier for practice
- **[📖 Sample Datasets](https://www.mongodb.com/docs/atlas/sample-data/)** - Atlas sample data
- **[📖 MongoDB Compass](https://www.mongodb.com/products/compass)** - GUI for MongoDB

## 🧠 Exam Tactics

### Question Strategy
1. **CRUD Questions (30%)** - Know exact syntax for operations and operators
2. **Aggregation Questions (25%)** - Know pipeline stage order and output shape
3. **Data Modeling Questions (20%)** - Understand trade-offs for embedding vs referencing
4. **Index Questions (15%)** - Know index types and when to use each
5. **Atlas Questions (10%)** - Know Atlas tools capabilities

### Time Management
- **~1.2 minutes per question** average
- **Flag and move** - Do not spend more than 2 minutes on any question
- **Reserve 10 minutes** for reviewing flagged questions
- **CRUD and Aggregation first** - These are the majority of the exam

### Key Areas to Master
- Query and update operator syntax
- Aggregation pipeline stage ordering and output
- Compound index design using the ESR rule
- Embedding vs referencing decision criteria
- $lookup syntax and behavior
- Atlas Search $search stage

## ⚠️ Common Pitfalls

1. **$push vs $addToSet** - $addToSet only adds if value not already present
2. **updateOne vs replaceOne** - updateOne uses operators, replaceOne replaces entire document
3. **Aggregation $match placement** - Place early in pipeline for index usage
4. **Compound index field order matters** - ESR: Equality, Sort, Range
5. **$lookup requires $unwind for one-to-many** - Without $unwind, results are arrays
6. **16 MB document limit** - Affects embedding strategy for large arrays
7. **TTL indexes only work on date fields** - Must be a Date type or array of Dates
8. **$elemMatch vs dot notation** - $elemMatch ensures conditions match same element
