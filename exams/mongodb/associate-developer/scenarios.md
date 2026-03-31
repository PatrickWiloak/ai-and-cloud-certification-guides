# High-Yield Scenarios and Patterns

## CRUD Operation Scenarios

### Upsert Pattern
**Scenario**: Application needs to update a user's last login time, or create the user record if it does not exist.

**Solution Pattern**:
```javascript
db.users.updateOne(
  { email: "user@example.com" },
  {
    $set: { lastLogin: new Date(), name: "John" },
    $inc: { loginCount: 1 }
  },
  { upsert: true }
);
```

**Key Points**:
- `upsert: true` inserts if no match found
- `$set` creates or updates fields
- `$inc` creates field with value if not exists, increments if exists
- Returns `upsertedId` if a new document was created

**Common Distractors**:
- Using findOneAndUpdate without upsert (wrong - will not create)
- Using insertOne with try/catch (wrong - race condition, not atomic)
- Using replaceOne with upsert (wrong - replaces entire document)

### Atomic Array Update
**Scenario**: Add a product to a user's cart if not already present, and update quantity if present.

**Solution Pattern**:
```javascript
// Add if not present
db.carts.updateOne(
  { userId: "U123", "items.productId": { $ne: "P456" } },
  { $push: { items: { productId: "P456", quantity: 1, price: 29.99 } } }
);

// Update quantity if present
db.carts.updateOne(
  { userId: "U123", "items.productId": "P456" },
  { $inc: { "items.$.quantity": 1 } }
);
```

**Common Distractors**:
- Using $addToSet (wrong - compares entire object, not just productId)
- Not using positional $ operator (wrong - updates wrong array element)
- Using two separate operations without checking (wrong - race condition)

### Bulk Write for Data Migration
**Scenario**: Need to update 10,000 documents - add a new field and remove an old one.

**Solution Pattern**:
```javascript
const ops = documents.map(doc => ({
  updateOne: {
    filter: { _id: doc._id },
    update: {
      $set: { newField: transformValue(doc.oldField) },
      $unset: { oldField: "" }
    }
  }
}));

db.collection.bulkWrite(ops, { ordered: false });
```

**Key Points**:
- `ordered: false` allows parallel execution and continues on error
- `ordered: true` (default) stops on first error
- Returns bulkWriteResult with counts for inserts, updates, deletes

**Common Distractors**:
- Individual updateOne calls (wrong - much slower, more network round trips)
- Using updateMany without filter (wrong - cannot transform per-document)
- Using `ordered: true` for independent operations (wrong - slower, unnecessary)

## Index Scenarios

### Optimizing a Slow Query
**Scenario**: Query `db.orders.find({status: "active", customerId: "C123"}).sort({orderDate: -1})` is slow.

**Solution Pattern**:
```javascript
// Apply ESR rule: Equality, Sort, Range
db.orders.createIndex({ status: 1, customerId: 1, orderDate: -1 });
// Or more optimized:
db.orders.createIndex({ customerId: 1, status: 1, orderDate: -1 });
```

**Verify with explain():**
```javascript
db.orders.find({status: "active", customerId: "C123"})
  .sort({orderDate: -1})
  .explain("executionStats");
// Look for: IXSCAN (not COLLSCAN), nReturned close to totalKeysExamined
```

**Common Distractors**:
- Index on `{orderDate: -1}` only (wrong - does not help filter)
- Index on `{orderDate: -1, status: 1}` (wrong - sort field after range/equality)
- Separate indexes on each field (wrong - compound index is more efficient)

### TTL Index for Session Cleanup
**Scenario**: User sessions should automatically expire after 30 minutes of inactivity.

**Solution Pattern**:
```javascript
db.sessions.createIndex(
  { lastActivity: 1 },
  { expireAfterSeconds: 1800 }  // 30 minutes
);
```

**Key Points**:
- TTL index must be on a field with Date type
- Background thread checks every 60 seconds
- Only works on single-field indexes (not compound)
- Documents deleted when `lastActivity + 1800 seconds < now`

**Common Distractors**:
- TTL on a string field (wrong - must be Date type)
- TTL on compound index (wrong - not supported)
- Expecting instant deletion (wrong - background thread runs every 60s)

## Data Modeling Scenarios

### One-to-Many: Blog Posts and Comments
**Scenario**: Blog with posts that can have 0-1000 comments. Most reads fetch the post with recent comments.

**Solution Pattern** (Subset Pattern):
```javascript
// Posts collection - embed recent comments
{
  _id: ObjectId("..."),
  title: "My Post",
  content: "...",
  recentComments: [  // Last 10 comments embedded
    { author: "Alice", text: "Great!", date: ISODate("...") }
  ],
  commentCount: 156
}

// Comments collection - all comments with reference
{
  _id: ObjectId("..."),
  postId: ObjectId("..."),
  author: "Alice",
  text: "Great!",
  date: ISODate("...")
}
```

**Common Distractors**:
- Embedding all comments (wrong - can exceed 16 MB for popular posts)
- Only referencing (wrong - extra query for every post read)
- Separate collection without subset (wrong - misses optimization)

### Many-to-Many: Students and Courses
**Scenario**: Students enroll in courses. Need to query both directions efficiently.

**Solution Pattern**:
```javascript
// Students collection
{
  _id: "S001",
  name: "Alice",
  enrolledCourses: ["C101", "C201", "C301"]  // Array of course IDs
}

// Courses collection
{
  _id: "C101",
  title: "Math 101",
  enrolledStudents: ["S001", "S002", "S003"]  // Array of student IDs
}
```

**Key Points**:
- Two-way referencing for bidirectional queries
- Keep arrays bounded (reasonable enrollment limits)
- Use multikey indexes on both arrays for efficient queries
- For unbounded relationships, use a junction collection

### Polymorphic Pattern
**Scenario**: E-commerce products with different attributes (books have ISBN, electronics have voltage).

**Solution Pattern**:
```javascript
// All products in one collection with shared and specific fields
{
  _id: ObjectId("..."),
  name: "Laptop",
  price: 999.99,
  type: "electronics",
  voltage: "110V",
  warranty_months: 24
}
{
  _id: ObjectId("..."),
  name: "Clean Code",
  price: 39.99,
  type: "book",
  isbn: "978-0132350884",
  author: "Robert Martin"
}
```

**Key Points**:
- Single collection enables simple queries across all products
- `type` field identifies the document shape
- Partial indexes can optimize type-specific queries
- Schema validation can use `oneOf` for type-specific rules

## Aggregation Scenarios

### Sales Report with Grouping
**Scenario**: Calculate total revenue and order count per product category for the last 30 days.

**Solution Pattern**:
```javascript
db.orders.aggregate([
  { $match: {
    orderDate: { $gte: new Date(Date.now() - 30*24*60*60*1000) }
  }},
  { $unwind: "$items" },
  { $group: {
    _id: "$items.category",
    totalRevenue: { $sum: { $multiply: ["$items.price", "$items.quantity"] } },
    orderCount: { $sum: 1 },
    avgOrderValue: { $avg: { $multiply: ["$items.price", "$items.quantity"] } }
  }},
  { $sort: { totalRevenue: -1 } },
  { $project: {
    category: "$_id",
    totalRevenue: { $round: ["$totalRevenue", 2] },
    orderCount: 1,
    avgOrderValue: { $round: ["$avgOrderValue", 2] },
    _id: 0
  }}
]);
```

**Key Points**:
- $match early for index usage and filtering
- $unwind before $group for array element aggregation
- $project reshapes output for readability

### Cross-Collection Join
**Scenario**: Get all orders with customer details for customers in "premium" tier.

**Solution Pattern**:
```javascript
db.orders.aggregate([
  { $lookup: {
    from: "customers",
    localField: "customerId",
    foreignField: "_id",
    as: "customer"
  }},
  { $unwind: "$customer" },
  { $match: { "customer.tier": "premium" } },
  { $project: {
    orderId: 1,
    total: 1,
    customerName: "$customer.name",
    customerEmail: "$customer.email"
  }}
]);
```

**Optimization** - Use pipeline form of $lookup:
```javascript
{ $lookup: {
  from: "customers",
  let: { custId: "$customerId" },
  pipeline: [
    { $match: {
      $expr: { $eq: ["$_id", "$$custId"] },
      tier: "premium"  // Filter inside lookup
    }}
  ],
  as: "customer"
}}
```

### Multi-Faceted Search Results
**Scenario**: Return search results with counts by category, price range, and total count.

**Solution Pattern**:
```javascript
db.products.aggregate([
  { $match: { $text: { $search: "laptop" } } },
  { $facet: {
    results: [
      { $sort: { score: { $meta: "textScore" } } },
      { $limit: 10 },
      { $project: { name: 1, price: 1, category: 1 } }
    ],
    categoryCount: [
      { $group: { _id: "$category", count: { $sum: 1 } } },
      { $sort: { count: -1 } }
    ],
    priceRanges: [
      { $bucket: {
        groupBy: "$price",
        boundaries: [0, 100, 500, 1000, 5000],
        default: "5000+",
        output: { count: { $sum: 1 } }
      }}
    ],
    totalCount: [
      { $count: "count" }
    ]
  }}
]);
```

## Atlas Tools Scenarios

### Atlas Search Implementation
**Scenario**: Implement autocomplete search for product names.

**Search Index Definition:**
```json
{
  "mappings": {
    "dynamic": false,
    "fields": {
      "name": {
        "type": "autocomplete",
        "tokenization": "edgeGram",
        "minGrams": 3,
        "maxGrams": 15
      }
    }
  }
}
```

**Query:**
```javascript
db.products.aggregate([
  { $search: {
    autocomplete: {
      query: "lap",
      path: "name"
    }
  }},
  { $limit: 10 },
  { $project: { name: 1, price: 1 } }
]);
```
