# CRUD Operations

**[📖 MongoDB CRUD Operations](https://www.mongodb.com/docs/manual/crud/)** - Complete CRUD documentation
**[📖 Query and Projection Operators](https://www.mongodb.com/docs/manual/reference/operator/query/)** - Operator reference

## Insert Operations

### insertOne()

**[📖 insertOne()](https://www.mongodb.com/docs/manual/reference/method/db.collection.insertOne/)** - Insert one document

```javascript
// Basic insert
db.users.insertOne({
  name: "Alice",
  email: "alice@example.com",
  age: 30,
  tags: ["admin", "user"],
  address: {
    city: "Seattle",
    state: "WA"
  },
  createdAt: new Date()
});

// Returns: { acknowledged: true, insertedId: ObjectId("...") }
```

**Key Points:**
- `_id` is auto-generated as ObjectId if not provided
- Custom `_id` is allowed (any type, must be unique)
- Document must not exceed 16 MB
- Throws error if `_id` already exists (duplicate key error)

### insertMany()

**[📖 insertMany()](https://www.mongodb.com/docs/manual/reference/method/db.collection.insertMany/)** - Insert multiple documents

```javascript
db.users.insertMany([
  { name: "Bob", email: "bob@example.com", age: 25 },
  { name: "Charlie", email: "charlie@example.com", age: 35 }
], { ordered: false });

// Returns: { acknowledged: true, insertedIds: { '0': ObjectId("..."), '1': ObjectId("...") } }
```

**Ordered vs Unordered:**
- `ordered: true` (default) - Stops on first error, guarantees order
- `ordered: false` - Continues on errors, may execute in any order, faster for large batches
- Unordered inserts are preferred for bulk data loading

## Find Operations

### find() and findOne()

**[📖 find()](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/)** - Query documents

```javascript
// Find all
db.users.find();

// Find with filter
db.users.find({ age: { $gt: 25 } });

// Find with projection
db.users.find(
  { status: "active" },
  { name: 1, email: 1, _id: 0 }  // Include name, email; exclude _id
);

// findOne returns first match
db.users.findOne({ email: "alice@example.com" });
```

### Comparison Operators

```javascript
// Equal (implicit)
db.users.find({ age: 25 });
// Explicit: { age: { $eq: 25 } }

// Not equal
db.users.find({ status: { $ne: "inactive" } });

// Greater than / Greater than or equal
db.users.find({ age: { $gt: 18 } });
db.users.find({ age: { $gte: 21 } });

// Less than / Less than or equal
db.users.find({ price: { $lt: 100 } });
db.users.find({ price: { $lte: 50 } });

// In / Not in
db.users.find({ status: { $in: ["active", "pending"] } });
db.users.find({ role: { $nin: ["admin"] } });

// Range (combining operators)
db.users.find({ age: { $gte: 18, $lte: 65 } });
```

### Logical Operators

```javascript
// AND (implicit - multiple conditions)
db.users.find({ status: "active", age: { $gt: 18 } });

// AND (explicit)
db.users.find({ $and: [{ status: "active" }, { age: { $gt: 18 } }] });

// OR
db.users.find({ $or: [{ status: "active" }, { role: "admin" }] });

// NOT
db.users.find({ age: { $not: { $gt: 65 } } });

// NOR (none of the conditions)
db.users.find({ $nor: [{ status: "inactive" }, { age: { $lt: 18 } }] });
```

**When to use explicit $and:**
- When you need multiple conditions on the same field
- `{ $and: [{ price: { $gt: 10 } }, { price: { $lt: 50 } }] }`
- Same as: `{ price: { $gt: 10, $lt: 50 } }`

### Element Operators

```javascript
// Field exists
db.users.find({ email: { $exists: true } });
db.users.find({ middleName: { $exists: false } });

// Field type
db.users.find({ age: { $type: "number" } });
db.users.find({ age: { $type: "string" } });  // Find mistyped ages
```

### Array Operators

```javascript
// Match array containing value
db.users.find({ tags: "admin" });

// Match array containing all values
db.users.find({ tags: { $all: ["admin", "user"] } });

// Match array with exact size
db.users.find({ tags: { $size: 3 } });

// Element match - conditions on SAME element
db.scores.find({
  results: { $elemMatch: { $gte: 80, $lt: 90 } }
});
// vs dot notation - conditions can match DIFFERENT elements
db.scores.find({ "results": { $gte: 80, $lt: 90 } });
```

### Evaluation Operators

```javascript
// Regular expression
db.users.find({ name: { $regex: /^Ali/i } });
db.users.find({ name: { $regex: "^Ali", $options: "i" } });

// Text search (requires text index)
db.articles.find({ $text: { $search: "coffee shop" } });

// Expression (use aggregation expressions in find)
db.inventory.find({ $expr: { $gt: ["$qty", "$reorder"] } });
```

### Projections

```javascript
// Include specific fields (inclusion projection)
db.users.find({}, { name: 1, email: 1 });
// Returns: { _id: ObjectId("..."), name: "Alice", email: "alice@..." }

// Exclude specific fields (exclusion projection)
db.users.find({}, { password: 0, ssn: 0 });

// Cannot mix inclusion and exclusion (except _id)
db.users.find({}, { name: 1, _id: 0 });  // Valid - _id exclusion is special

// Array projection operators
db.posts.find({}, { comments: { $slice: 5 } });         // First 5
db.posts.find({}, { comments: { $slice: -3 } });        // Last 3
db.posts.find({}, { comments: { $slice: [10, 5] } });   // Skip 10, take 5
db.posts.find({}, { "comments.$": 1 });                  // First matching element
db.posts.find({}, { comments: { $elemMatch: { author: "Alice" } } }); // Matching element
```

### Cursor Methods

```javascript
// Sort (1 = ascending, -1 = descending)
db.users.find().sort({ age: -1, name: 1 });

// Limit results
db.users.find().limit(10);

// Skip results (pagination)
db.users.find().skip(20).limit(10);  // Page 3 with 10 per page

// Count
db.users.find({ status: "active" }).count();
db.users.countDocuments({ status: "active" });  // Preferred

// Execution order: sort -> skip -> limit (regardless of method call order)
```

## Update Operations

### updateOne() and updateMany()

**[📖 Update Operations](https://www.mongodb.com/docs/manual/reference/method/db.collection.updateOne/)** - Update documentation

```javascript
// Update one document
db.users.updateOne(
  { email: "alice@example.com" },
  { $set: { lastLogin: new Date() }, $inc: { loginCount: 1 } }
);

// Update many documents
db.users.updateMany(
  { status: "inactive" },
  { $set: { archived: true, archivedAt: new Date() } }
);

// Returns: { acknowledged: true, matchedCount: 1, modifiedCount: 1 }
```

### Update Operators

**[📖 Update Operators](https://www.mongodb.com/docs/manual/reference/operator/update/)** - Complete operator reference

**Field Update Operators:**
```javascript
// $set - Set field value (create if not exists)
{ $set: { name: "New Name", "address.city": "Portland" } }

// $unset - Remove field
{ $unset: { temporaryField: "" } }

// $inc - Increment (positive or negative)
{ $inc: { quantity: -1, totalSold: 1 } }

// $mul - Multiply
{ $mul: { price: 1.1 } }  // 10% price increase

// $rename - Rename field
{ $rename: { "old_name": "new_name" } }

// $min - Update only if new value is less than current
{ $min: { lowScore: 50 } }

// $max - Update only if new value is greater than current
{ $max: { highScore: 99 } }

// $currentDate - Set to current date
{ $currentDate: { lastModified: true } }
{ $currentDate: { lastModified: { $type: "timestamp" } } }
```

**Array Update Operators:**
```javascript
// $push - Add element to array
{ $push: { tags: "newTag" } }

// $push with modifiers
{ $push: { scores: { $each: [90, 85, 95], $sort: -1, $slice: 10 } } }
// Adds all scores, sorts descending, keeps top 10

// $addToSet - Add only if not already present
{ $addToSet: { tags: "unique" } }
{ $addToSet: { tags: { $each: ["a", "b", "c"] } } }

// $pull - Remove matching elements
{ $pull: { tags: "oldTag" } }
{ $pull: { scores: { $lt: 60 } } }  // Remove all scores below 60

// $pop - Remove first (-1) or last (1) element
{ $pop: { queue: -1 } }  // Remove first
{ $pop: { queue: 1 } }   // Remove last

// $ positional operator - Update matched array element
db.collection.updateOne(
  { "items.productId": "P123" },
  { $set: { "items.$.quantity": 5 } }
);

// $[] all positional - Update all array elements
{ $inc: { "scores.$[]": 10 } }  // Add 10 to all scores

// $[<identifier>] filtered positional
db.collection.updateOne(
  { _id: 1 },
  { $set: { "grades.$[elem].score": 100 } },
  { arrayFilters: [{ "elem.score": { $lt: 60 } }] }
);
```

### replaceOne()

```javascript
db.users.replaceOne(
  { email: "alice@example.com" },
  { name: "Alice Smith", email: "alice@example.com", age: 31, status: "active" }
);
```
- Replaces the entire document (except `_id`)
- Cannot use update operators ($set, $inc, etc.)
- Useful for full document replacement

### findOneAndUpdate() / findOneAndReplace() / findOneAndDelete()

```javascript
// Returns the document before or after modification
const result = db.users.findOneAndUpdate(
  { email: "alice@example.com" },
  { $inc: { loginCount: 1 } },
  { returnDocument: "after", upsert: true }
);

// findOneAndDelete - atomically find and remove
const deleted = db.sessions.findOneAndDelete(
  { sessionId: "abc123" }
);
```

**Options:**
- `returnDocument: "before"` (default) or `"after"` - Return pre or post modification
- `upsert: true` - Insert if no match
- `sort: { field: 1 }` - Which document to modify if multiple match
- `projection: { field: 1 }` - Fields to return

## Delete Operations

```javascript
// Delete one
db.users.deleteOne({ email: "alice@example.com" });

// Delete many
db.users.deleteMany({ status: "inactive", lastLogin: { $lt: new Date("2023-01-01") } });

// Delete all documents (empty filter)
db.logs.deleteMany({});

// Returns: { acknowledged: true, deletedCount: 5 }
```

## Bulk Write Operations

**[📖 bulkWrite()](https://www.mongodb.com/docs/manual/reference/method/db.collection.bulkWrite/)** - Bulk operations documentation

```javascript
db.collection.bulkWrite([
  {
    insertOne: {
      document: { name: "New Item", quantity: 10 }
    }
  },
  {
    updateOne: {
      filter: { name: "Existing Item" },
      update: { $inc: { quantity: 5 } }
    }
  },
  {
    updateMany: {
      filter: { status: "pending" },
      update: { $set: { status: "processed" } }
    }
  },
  {
    replaceOne: {
      filter: { name: "Old Item" },
      replacement: { name: "Old Item", quantity: 0, archived: true }
    }
  },
  {
    deleteOne: {
      filter: { name: "Deleted Item" }
    }
  },
  {
    deleteMany: {
      filter: { quantity: 0, archived: true }
    }
  }
], { ordered: false });
```

**Return Value:**
```javascript
{
  acknowledged: true,
  insertedCount: 1,
  matchedCount: 5,
  modifiedCount: 4,
  deletedCount: 2,
  upsertedCount: 0,
  insertedIds: { '0': ObjectId("...") },
  upsertedIds: {}
}
```

## Write Concerns and Read Concerns

### Write Concern
```javascript
db.users.insertOne(
  { name: "Alice" },
  { writeConcern: { w: "majority", j: true, wtimeout: 5000 } }
);
```

| Setting | Description |
|---------|-------------|
| `w: 1` | Acknowledge from primary only (default) |
| `w: "majority"` | Acknowledge from majority of replica set |
| `w: 0` | No acknowledgment (fire and forget) |
| `j: true` | Wait for journal write |
| `wtimeout` | Timeout in milliseconds |

### Read Concern
| Level | Description |
|-------|-------------|
| `local` | Most recent data from primary (default) |
| `available` | Most recent data (may return orphaned docs on sharded clusters) |
| `majority` | Data acknowledged by majority |
| `linearizable` | Reflects all successful majority-acknowledged writes |
| `snapshot` | Data from a specific point in time (transactions) |
