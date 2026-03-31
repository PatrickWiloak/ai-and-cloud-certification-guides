# Indexes

**[📖 MongoDB Indexes](https://www.mongodb.com/docs/manual/indexes/)** - Complete index documentation
**[📖 Index Strategies](https://www.mongodb.com/docs/manual/applications/indexes/)** - Indexing best practices

## Index Fundamentals

### How Indexes Work
- MongoDB uses B-tree data structures for indexes
- Indexes store a small portion of the collection's data in an ordered format
- Without an index, MongoDB scans every document (collection scan / COLLSCAN)
- With an index, MongoDB can efficiently find documents (index scan / IXSCAN)
- Indexes improve read performance but add overhead to writes

### The _id Index
- Every collection has a unique index on the `_id` field
- Created automatically and cannot be dropped
- `_id` index supports equality queries and range queries on `_id`
- Default `_id` is an ObjectId (12-byte value with timestamp, machine, process, counter)

### Creating and Managing Indexes

```javascript
// Create index
db.collection.createIndex({ field: 1 });  // Ascending
db.collection.createIndex({ field: -1 }); // Descending

// Create with options
db.collection.createIndex(
  { email: 1 },
  { unique: true, name: "email_unique_idx", background: true }
);

// List indexes
db.collection.getIndexes();

// Drop index
db.collection.dropIndex("email_unique_idx");
db.collection.dropIndex({ email: 1 });

// Drop all indexes (except _id)
db.collection.dropIndexes();
```

## Index Types

### Single Field Index

**[📖 Single Field Indexes](https://www.mongodb.com/docs/manual/core/index-single/)** - Single field index guide

```javascript
db.users.createIndex({ email: 1 });
db.users.createIndex({ age: -1 });
```

- Supports queries on that field
- Direction (1 or -1) does not matter for single-field indexes (can traverse both ways)
- Supports sort on that field
- Also supports queries on embedded document fields: `{ "address.city": 1 }`

### Compound Index

**[📖 Compound Indexes](https://www.mongodb.com/docs/manual/core/index-compound/)** - Compound index guide

```javascript
db.orders.createIndex({ customerId: 1, orderDate: -1 });
db.products.createIndex({ category: 1, price: 1, rating: -1 });
```

**Key Rules:**
- Field order matters significantly
- Supports queries on any prefix of the index fields
- Index `{a: 1, b: 1, c: 1}` supports queries on: `{a}`, `{a, b}`, `{a, b, c}`
- Does NOT efficiently support queries on `{b}`, `{c}`, or `{b, c}` alone
- Sort must match index direction or exact reverse

**ESR Rule (Equality, Sort, Range):**
1. **Equality** fields first - Fields with exact match conditions ($eq, $in)
2. **Sort** fields next - Fields used in sort()
3. **Range** fields last - Fields with inequality conditions ($gt, $lt, $gte, $lte)

**Example:**
```javascript
// Query: find active users in age range, sorted by name
db.users.find({ status: "active", age: { $gte: 18, $lte: 65 } }).sort({ name: 1 });

// Best index (ESR): Equality(status) -> Sort(name) -> Range(age)
db.users.createIndex({ status: 1, name: 1, age: 1 });
```

### Multikey Index

**[📖 Multikey Indexes](https://www.mongodb.com/docs/manual/core/index-multikey/)** - Array field index guide

```javascript
db.products.createIndex({ tags: 1 });

// Supports queries like:
db.products.find({ tags: "electronics" });
db.products.find({ tags: { $in: ["electronics", "sale"] } });
```

- Automatically created when indexing a field that contains an array
- Creates index entries for each element in the array
- A compound index can have at most one multikey field
- Cannot create compound multikey index with two array fields

### Text Index

**[📖 Text Indexes](https://www.mongodb.com/docs/manual/core/index-text/)** - Full-text search index guide

```javascript
// Single field text index
db.articles.createIndex({ content: "text" });

// Multiple field text index with weights
db.articles.createIndex(
  { title: "text", content: "text", tags: "text" },
  { weights: { title: 10, content: 5, tags: 1 } }
);

// Query with text index
db.articles.find({ $text: { $search: "coffee shop" } });

// With text score
db.articles.find(
  { $text: { $search: "coffee" } },
  { score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" } });
```

**Key Points:**
- Only one text index per collection
- Supports multiple languages
- Case-insensitive by default
- Searches for any of the terms (OR logic)
- Use quotes for phrase matching: `{ $search: "\"coffee shop\"" }`
- Prefix with - to exclude: `{ $search: "coffee -decaf" }`

### Geospatial Indexes

**[📖 Geospatial Indexes](https://www.mongodb.com/docs/manual/core/geospatial-indexes/)** - Location-based index guide

**2dsphere Index (for GeoJSON data):**
```javascript
db.places.createIndex({ location: "2dsphere" });

// Near query
db.places.find({
  location: {
    $near: {
      $geometry: { type: "Point", coordinates: [-122.4194, 37.7749] },
      $maxDistance: 5000  // meters
    }
  }
});

// Within polygon
db.places.find({
  location: {
    $geoWithin: {
      $geometry: {
        type: "Polygon",
        coordinates: [[ [lng1,lat1], [lng2,lat2], [lng3,lat3], [lng1,lat1] ]]
      }
    }
  }
});
```

**2d Index (for legacy coordinate pairs):**
```javascript
db.places.createIndex({ coordinates: "2d" });
```

### TTL Index

**[📖 TTL Indexes](https://www.mongodb.com/docs/manual/core/index-ttl/)** - Auto-expiring document index

```javascript
// Expire documents 3600 seconds after the createdAt date
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 3600 });

// Expire at a specific time (set expireAfterSeconds to 0)
db.events.createIndex({ expireAt: 1 }, { expireAfterSeconds: 0 });
// Document: { event: "...", expireAt: ISODate("2024-12-31T23:59:59Z") }
```

**Key Constraints:**
- Field must be a Date type (or array of dates - uses earliest)
- Only works on single-field indexes
- Background thread runs every 60 seconds
- Cannot be a compound index
- Cannot be used on `_id` field or capped collections

### Hashed Index

```javascript
db.collection.createIndex({ field: "hashed" });
```
- Used for hash-based sharding
- Supports equality queries only (not range)
- Cannot be compound or multikey
- Even data distribution for sharding

## Index Properties

### Unique Index
```javascript
db.users.createIndex({ email: 1 }, { unique: true });
```
- Rejects duplicate values
- Null is treated as a value (only one null allowed unless sparse)
- Unique compound index enforces uniqueness on the combination

### Sparse Index
```javascript
db.users.createIndex({ email: 1 }, { sparse: true });
```
- Only indexes documents that have the indexed field
- Reduces index size
- Cannot return results for documents without the field when using the index
- Useful with unique to allow multiple documents without the field

### Partial Index
```javascript
db.orders.createIndex(
  { orderDate: 1 },
  { partialFilterExpression: { status: "active" } }
);
```
- Indexes only documents matching the filter expression
- Smaller and more efficient than full indexes
- Query must include the partial filter expression to use the index
- Supports: $eq, $exists, $gt, $gte, $lt, $lte, $type, $and

### Hidden Index
```javascript
// Hide index (stops query planner from using it)
db.collection.hideIndex("index_name");

// Unhide index
db.collection.unhideIndex("index_name");
```
- Useful for testing impact of dropping an index without actually dropping it

## Query Performance Analysis

### explain()

**[📖 explain()](https://www.mongodb.com/docs/manual/reference/method/cursor.explain/)** - Query plan analysis

```javascript
// Query execution stats
db.users.find({ age: { $gt: 25 } }).explain("executionStats");
```

**Verbosity Levels:**
- `"queryPlanner"` (default) - Shows winning plan
- `"executionStats"` - Shows execution statistics
- `"allPlansExecution"` - Shows all candidate plans

**Key Fields to Examine:**
| Field | Description | Good Value |
|-------|-------------|------------|
| `stage` | Query stage type | IXSCAN (not COLLSCAN) |
| `nReturned` | Documents returned | Close to examined |
| `totalKeysExamined` | Index keys examined | Close to nReturned |
| `totalDocsExamined` | Documents examined | Close to nReturned |
| `executionTimeMillis` | Execution time | Low |

**Covered Queries:**
- All fields in query and projection are in the index
- `totalDocsExamined` = 0 (no document fetch needed)
- Stage shows IXSCAN with no FETCH stage
```javascript
// With index { status: 1, name: 1 }
db.users.find(
  { status: "active" },
  { name: 1, _id: 0 }  // Must exclude _id for covered query
).explain("executionStats");
```

### Index Intersection
- MongoDB can use multiple indexes to fulfill a query
- Less efficient than a single compound index
- Visible in explain() as AND_SORTED or AND_HASH stages
- Generally prefer compound indexes over relying on intersection

## Index Best Practices

1. **Create indexes that support your queries** - Analyze query patterns first
2. **Use compound indexes following ESR rule** - Equality, Sort, Range
3. **Avoid over-indexing** - Each index uses memory and slows writes
4. **Use partial indexes** when queries always include a filter
5. **Monitor index usage** with `$indexStats` aggregation stage
6. **Remove unused indexes** - They waste resources
7. **Limit indexes to 64 per collection** (hard limit)
8. **Consider working set size** - Indexes should fit in RAM
9. **Use explain() to verify** index usage for critical queries
10. **Background index creation** for production builds
