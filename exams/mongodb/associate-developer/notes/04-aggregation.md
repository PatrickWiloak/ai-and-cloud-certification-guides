# Aggregation Pipeline

**[📖 Aggregation Pipeline](https://www.mongodb.com/docs/manual/core/aggregation-pipeline/)** - Pipeline documentation
**[📖 Aggregation Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)** - Stage reference

## Pipeline Concepts

### How Pipelines Work
- Documents pass through a series of stages
- Each stage transforms the documents
- Output of one stage becomes input to the next
- Stages can filter, group, sort, reshape, join, and compute
- Pipelines can use indexes (especially $match and $sort at the start)

```javascript
db.collection.aggregate([
  { $match: { ... } },     // Stage 1: Filter
  { $group: { ... } },     // Stage 2: Group
  { $sort: { ... } },      // Stage 3: Sort
  { $project: { ... } }    // Stage 4: Reshape
]);
```

### Pipeline Optimization
- **$match early** - Reduces documents for subsequent stages, can use indexes
- **$project early** - Reduces document size, less memory usage
- **$sort + $limit** - MongoDB optimizes this combination
- **Pipeline memory limit** - 100 MB per stage (use `allowDiskUse: true` to bypass)
- MongoDB may reorder stages for optimization (e.g., moving $match before $project)

## Core Pipeline Stages

### $match

**[📖 $match](https://www.mongodb.com/docs/manual/reference/operator/aggregation/match/)** - Filter documents

```javascript
// Simple filter
{ $match: { status: "active" } }

// Complex filter
{ $match: {
  status: "active",
  age: { $gte: 18, $lte: 65 },
  tags: { $in: ["premium", "vip"] }
}}

// Using $expr for field comparisons
{ $match: {
  $expr: { $gt: ["$quantity", "$reorderLevel"] }
}}
```

**Key Points:**
- Place as early as possible in the pipeline
- Can use indexes when first or after other $match stages
- Uses same query operators as find()
- Cannot use $where in $match

### $group

**[📖 $group](https://www.mongodb.com/docs/manual/reference/operator/aggregation/group/)** - Group and aggregate

```javascript
// Group by field with accumulators
{ $group: {
  _id: "$category",
  totalRevenue: { $sum: "$amount" },
  avgAmount: { $avg: "$amount" },
  maxAmount: { $max: "$amount" },
  minAmount: { $min: "$amount" },
  count: { $sum: 1 },
  items: { $push: "$name" },
  firstDate: { $first: "$date" },
  lastDate: { $last: "$date" }
}}

// Group by multiple fields
{ $group: {
  _id: { category: "$category", year: { $year: "$date" } },
  totalSales: { $sum: "$amount" }
}}

// Group all documents (null _id)
{ $group: {
  _id: null,
  totalAmount: { $sum: "$amount" },
  avgAmount: { $avg: "$amount" },
  count: { $sum: 1 }
}}
```

**Accumulator Operators:**

| Operator | Description |
|----------|-------------|
| `$sum` | Sum of values (or count with `$sum: 1`) |
| `$avg` | Average of values |
| `$min` / `$max` | Minimum / Maximum value |
| `$first` / `$last` | First / Last value (depends on sort order) |
| `$push` | Collect all values into array |
| `$addToSet` | Collect unique values into array |
| `$stdDevPop` / `$stdDevSamp` | Standard deviation |
| `$mergeObjects` | Merge objects into one |
| `$accumulator` | Custom accumulator (JavaScript) |

### $project

**[📖 $project](https://www.mongodb.com/docs/manual/reference/operator/aggregation/project/)** - Reshape documents

```javascript
// Include/exclude fields
{ $project: {
  name: 1,
  email: 1,
  _id: 0
}}

// Computed fields
{ $project: {
  fullName: { $concat: ["$firstName", " ", "$lastName"] },
  totalPrice: { $multiply: ["$price", "$quantity"] },
  discountedPrice: { $subtract: ["$price", { $multiply: ["$price", 0.1] }] },
  year: { $year: "$orderDate" },
  isExpensive: { $gt: ["$price", 100] }
}}

// Conditional fields
{ $project: {
  name: 1,
  priceCategory: {
    $switch: {
      branches: [
        { case: { $lt: ["$price", 10] }, then: "budget" },
        { case: { $lt: ["$price", 50] }, then: "mid-range" }
      ],
      default: "premium"
    }
  }
}}
```

### $sort

```javascript
// Sort ascending (1) or descending (-1)
{ $sort: { price: -1, name: 1 } }

// Sort by computed field
{ $sort: { score: { $meta: "textScore" } } }
```

**Key Points:**
- $sort at beginning of pipeline can use indexes
- $sort + $limit optimization: MongoDB only keeps top N documents
- Memory limit applies: 100 MB (use `allowDiskUse: true` for larger sorts)

### $limit and $skip

```javascript
// Pagination pattern
{ $skip: 20 },  // Skip first 20
{ $limit: 10 }  // Take next 10
```

### $count

```javascript
{ $count: "totalDocuments" }
// Output: { totalDocuments: 42 }
```

## Join and Array Stages

### $lookup

**[📖 $lookup](https://www.mongodb.com/docs/manual/reference/operator/aggregation/lookup/)** - Left outer join

**Simple Equality Join:**
```javascript
{ $lookup: {
  from: "customers",        // Foreign collection
  localField: "customerId", // Field in input documents
  foreignField: "_id",      // Field in foreign documents
  as: "customer"            // Output array field
}}
// Result: each document gets a "customer" array (may be empty if no match)
```

**Pipeline Join (correlated subquery):**
```javascript
{ $lookup: {
  from: "orders",
  let: { custId: "$_id" },
  pipeline: [
    { $match: {
      $expr: { $eq: ["$customerId", "$$custId"] }
    }},
    { $match: { status: "completed" } },
    { $sort: { orderDate: -1 } },
    { $limit: 5 }
  ],
  as: "recentOrders"
}}
```

**Key Points:**
- Always produces an array (empty if no match - left outer join behavior)
- Pipeline form allows filtering, sorting, and projecting within the join
- Foreign collection must be in the same database
- `let` variables are prefixed with `$$` inside the pipeline
- Cannot use $out or $merge inside $lookup pipeline

### $unwind

**[📖 $unwind](https://www.mongodb.com/docs/manual/reference/operator/aggregation/unwind/)** - Deconstruct arrays

```javascript
// Basic unwind
{ $unwind: "$tags" }
// Input:  { name: "A", tags: ["x", "y", "z"] }
// Output: { name: "A", tags: "x" }
//         { name: "A", tags: "y" }
//         { name: "A", tags: "z" }

// With options
{ $unwind: {
  path: "$tags",
  includeArrayIndex: "tagIndex",       // Add array index field
  preserveNullAndEmptyArrays: true     // Keep docs without the field
}}
```

**Key Points:**
- Creates one document per array element
- Multiplies document count
- By default, removes documents with empty or missing arrays
- `preserveNullAndEmptyArrays: true` keeps them
- Common pattern: `$unwind` then `$group` for array aggregation

### $addFields / $set

```javascript
// Add computed fields (keeps all existing fields)
{ $addFields: {
  totalPrice: { $multiply: ["$price", "$quantity"] },
  discountApplied: { $gt: ["$discount", 0] }
}}

// $set is an alias for $addFields
{ $set: {
  lastUpdated: "$$NOW"
}}
```

### $replaceRoot / $replaceWith

```javascript
// Replace document with subdocument
{ $replaceRoot: { newRoot: "$customer" } }

// Conditional replacement
{ $replaceRoot: {
  newRoot: {
    $mergeObjects: [
      { _id: "$_id", type: "$type" },
      "$details"
    ]
  }
}}
```

## Advanced Stages

### $facet

**[📖 $facet](https://www.mongodb.com/docs/manual/reference/operator/aggregation/facet/)** - Multiple pipelines in parallel

```javascript
db.products.aggregate([
  { $match: { category: "electronics" } },
  { $facet: {
    // Results with pagination
    results: [
      { $sort: { price: -1 } },
      { $skip: 0 },
      { $limit: 10 }
    ],
    // Count by brand
    brandCounts: [
      { $group: { _id: "$brand", count: { $sum: 1 } } },
      { $sort: { count: -1 } }
    ],
    // Price statistics
    priceStats: [
      { $group: {
        _id: null,
        avgPrice: { $avg: "$price" },
        minPrice: { $min: "$price" },
        maxPrice: { $max: "$price" }
      }}
    ],
    // Total count
    totalCount: [
      { $count: "count" }
    ]
  }}
]);
```

**Key Points:**
- All sub-pipelines receive the same input documents
- Each sub-pipeline runs independently
- Output is a single document with one field per facet
- Cannot include $out or $merge in facet sub-pipelines

### $bucket and $bucketAuto

```javascript
// Fixed boundaries
{ $bucket: {
  groupBy: "$price",
  boundaries: [0, 25, 50, 100, 250, 500],
  default: "500+",
  output: {
    count: { $sum: 1 },
    avgPrice: { $avg: "$price" },
    products: { $push: "$name" }
  }
}}

// Automatic boundaries
{ $bucketAuto: {
  groupBy: "$price",
  buckets: 5,
  output: {
    count: { $sum: 1 },
    avgPrice: { $avg: "$price" }
  }
}}
```

### $graphLookup

**[📖 $graphLookup](https://www.mongodb.com/docs/manual/reference/operator/aggregation/graphLookup/)** - Recursive graph traversal

```javascript
// Employee hierarchy
{ $graphLookup: {
  from: "employees",
  startWith: "$reportsTo",
  connectFromField: "reportsTo",
  connectToField: "_id",
  as: "managementChain",
  maxDepth: 5,
  depthField: "level"
}}
```

### $merge and $out

```javascript
// $out - Replace entire collection with results
{ $out: "report_results" }

// $merge - Upsert results into collection
{ $merge: {
  into: "monthly_totals",
  on: ["year", "month"],
  whenMatched: "merge",
  whenNotMatched: "insert"
}}
```

**$merge whenMatched options:** `merge`, `replace`, `keepExisting`, `fail`, pipeline
**$merge whenNotMatched options:** `insert`, `discard`, `fail`

## Aggregation Expressions

### String Expressions
```javascript
$concat: ["$first", " ", "$last"]       // Concatenate
$substr: ["$name", 0, 5]                // Substring
$toUpper: "$name"                        // Uppercase
$toLower: "$name"                        // Lowercase
$trim: { input: "$name" }               // Trim whitespace
$split: ["$tags", ","]                   // Split string to array
$regexMatch: { input: "$email", regex: /@gmail/ }  // Regex test
```

### Date Expressions
```javascript
$year: "$date"                           // Extract year
$month: "$date"                          // Extract month (1-12)
$dayOfMonth: "$date"                     // Extract day
$hour: "$date"                           // Extract hour
$dateToString: { format: "%Y-%m-%d", date: "$date" }
$dateFromString: { dateString: "$dateStr" }
$dateDiff: { startDate: "$start", endDate: "$end", unit: "day" }
```

### Conditional Expressions
```javascript
// If-then-else
$cond: { if: { $gt: ["$qty", 100] }, then: "high", else: "low" }

// Switch
$switch: {
  branches: [
    { case: { $eq: ["$status", "A"] }, then: "Active" },
    { case: { $eq: ["$status", "I"] }, then: "Inactive" }
  ],
  default: "Unknown"
}

// If null
$ifNull: ["$description", "No description available"]
```

### Array Expressions
```javascript
$size: "$tags"                           // Array length
$arrayElemAt: ["$items", 0]             // Element at index
$filter: {                               // Filter array elements
  input: "$scores",
  as: "score",
  cond: { $gte: ["$$score", 80] }
}
$map: {                                  // Transform array elements
  input: "$items",
  as: "item",
  in: { $multiply: ["$$item.price", "$$item.qty"] }
}
$reduce: {                               // Reduce array to single value
  input: "$items",
  initialValue: 0,
  in: { $add: ["$$value", "$$this.amount"] }
}
$concatArrays: ["$array1", "$array2"]   // Concatenate arrays
$isArray: "$field"                       // Check if array
```
