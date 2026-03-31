# Data Modeling

**[📖 Data Modeling Introduction](https://www.mongodb.com/docs/manual/core/data-modeling-introduction/)** - Data modeling concepts
**[📖 Schema Design Patterns](https://www.mongodb.com/blog/post/building-with-patterns-a-summary)** - Pattern summary

## Embedding vs Referencing

### When to Embed

**Embed data when:**
- Data is accessed together frequently (read optimization)
- Relationship is one-to-few or one-to-many (bounded)
- Data has a natural parent-child relationship
- Data does not need to be accessed independently
- Atomicity is required (single document updates are atomic)
- Embedded data is relatively small

**Advantages of Embedding:**
- Single read operation retrieves all related data
- Atomic updates within a single document
- No need for $lookup (joins)
- Better data locality
- Simpler application code

**Example - User with Addresses (one-to-few):**
```javascript
{
  _id: ObjectId("..."),
  name: "Alice Smith",
  email: "alice@example.com",
  addresses: [
    { type: "home", street: "123 Main St", city: "Seattle", state: "WA" },
    { type: "work", street: "456 Corp Ave", city: "Portland", state: "OR" }
  ]
}
```

### When to Reference

**Reference data when:**
- Data is accessed independently
- Relationship is one-to-many (unbounded) or many-to-many
- Data is shared across multiple documents
- Document size would exceed 16 MB limit
- Data changes frequently and independently
- Unbounded growth of arrays

**Advantages of Referencing:**
- Avoids data duplication
- Documents stay smaller
- Independent access to related data
- No 16 MB document size concern
- Updates to referenced data happen in one place

**Example - Orders referencing Products (many-to-many):**
```javascript
// Orders collection
{
  _id: ObjectId("..."),
  customerId: ObjectId("..."),
  orderDate: ISODate("..."),
  items: [
    { productId: ObjectId("..."), quantity: 2, price: 29.99 },
    { productId: ObjectId("..."), quantity: 1, price: 49.99 }
  ]
}

// Products collection
{
  _id: ObjectId("..."),
  name: "Widget",
  price: 29.99,
  category: "Electronics",
  description: "..."
}
```

### Decision Matrix

| Factor | Embed | Reference |
|--------|-------|-----------|
| Read pattern | Read together | Read independently |
| Write pattern | Update together | Update independently |
| Data size | Small, bounded | Large or unbounded |
| Duplication | Acceptable | Avoid |
| Atomicity needed | Yes | No (use transactions) |
| Relationship size | Few-to-many | Many-to-millions |
| Data volatility | Low change frequency | High change frequency |

## Relationship Patterns

### One-to-One

**Embed in parent document:**
```javascript
{
  _id: ObjectId("..."),
  name: "Alice",
  passport: {
    number: "AB123456",
    issueDate: ISODate("2020-01-15"),
    expiryDate: ISODate("2030-01-15"),
    country: "US"
  }
}
```

**When to separate:**
- If subdocument is large and rarely accessed
- If subdocument has different access patterns
- If subdocument is updated frequently

### One-to-Many (Bounded)

**Embed array in parent:**
```javascript
// Blog post with comments (bounded - moderate number)
{
  _id: ObjectId("..."),
  title: "My Post",
  content: "...",
  comments: [
    { author: "Bob", text: "Great!", date: ISODate("...") },
    { author: "Charlie", text: "Thanks!", date: ISODate("...") }
  ]
}
```

### One-to-Many (Unbounded)

**Reference with parent ID in child:**
```javascript
// Parent: Author
{ _id: "author1", name: "Alice Smith", bio: "..." }

// Children: Books (reference author)
{ _id: "book1", title: "Book One", authorId: "author1", published: ISODate("...") }
{ _id: "book2", title: "Book Two", authorId: "author1", published: ISODate("...") }
// ... potentially thousands of books
```

### Many-to-Many

**Array of references (both directions if needed):**
```javascript
// Students
{
  _id: "S001",
  name: "Alice",
  enrolledCourses: ["C101", "C201"]  // Course IDs
}

// Courses
{
  _id: "C101",
  title: "Math 101",
  enrolledStudents: ["S001", "S002"]  // Student IDs
}
```

**For very large many-to-many, use a junction collection:**
```javascript
// Enrollments (junction collection)
{ studentId: "S001", courseId: "C101", enrolledDate: ISODate("..."), grade: null }
{ studentId: "S001", courseId: "C201", enrolledDate: ISODate("..."), grade: "A" }
```

## Schema Design Patterns

### Polymorphic Pattern

**[📖 Polymorphic Pattern](https://www.mongodb.com/blog/post/building-with-patterns-the-polymorphic-pattern)** - Different shapes in one collection

**Use Case:** Documents with similar but not identical structures in the same collection.

```javascript
// Products collection - different types with shared fields
{
  _id: ObjectId("..."),
  name: "MacBook Pro",
  type: "laptop",
  price: 2499.99,
  brand: "Apple",
  // Laptop-specific fields
  screenSize: 16,
  processor: "M3 Max",
  ram: "36GB"
}
{
  _id: ObjectId("..."),
  name: "Clean Code",
  type: "book",
  price: 39.99,
  brand: "Prentice Hall",
  // Book-specific fields
  isbn: "978-0132350884",
  author: "Robert Martin",
  pages: 464
}
```

**Benefits:** Single collection for cross-type queries, simple application logic
**Index Strategy:** Use partial indexes for type-specific queries

### Bucket Pattern

**[📖 Bucket Pattern](https://www.mongodb.com/blog/post/building-with-patterns-the-bucket-pattern)** - Group related data into buckets

**Use Case:** Time-series data, IoT sensor readings, event logs.

```javascript
// Instead of one document per reading:
{
  sensorId: "S001",
  date: ISODate("2024-01-15"),
  readings: [
    { time: ISODate("2024-01-15T00:00:00Z"), temp: 22.5, humidity: 45 },
    { time: ISODate("2024-01-15T00:05:00Z"), temp: 22.6, humidity: 44 },
    // ... up to 288 readings per day (every 5 min)
  ],
  readingCount: 288,
  avgTemp: 22.8,
  minTemp: 20.1,
  maxTemp: 25.3
}
```

**Benefits:** Fewer documents, pre-computed aggregates, better index efficiency

### Outlier Pattern

**[📖 Outlier Pattern](https://www.mongodb.com/blog/post/building-with-patterns-the-outlier-pattern)** - Handle documents with unusual sizes

**Use Case:** Most documents have small arrays, but a few have very large arrays.

```javascript
// Normal document
{
  _id: ObjectId("..."),
  title: "Regular Post",
  likes: ["user1", "user2", "user3"],
  likeCount: 3,
  hasOverflow: false
}

// Outlier document (viral post)
{
  _id: ObjectId("..."),
  title: "Viral Post",
  likes: ["user1", "user2", ...],  // First 1000
  likeCount: 50000,
  hasOverflow: true
}

// Overflow collection
{
  postId: ObjectId("..."),
  page: 2,
  likes: ["user1001", "user1002", ...]
}
```

**Benefits:** Optimizes for common case, handles edge cases gracefully

### Attribute Pattern

**[📖 Attribute Pattern](https://www.mongodb.com/blog/post/building-with-patterns-the-attribute-pattern)** - Convert many fields to key-value pairs

**Use Case:** Many similar fields that need to be searched/indexed.

```javascript
// Before (many fields, each needs its own index)
{
  name: "Widget",
  color: "blue",
  size: "large",
  weight: 100,
  material: "steel",
  voltage: "110V"
}

// After (attribute pattern)
{
  name: "Widget",
  attributes: [
    { key: "color", value: "blue" },
    { key: "size", value: "large" },
    { key: "weight", value: 100 },
    { key: "material", value: "steel" },
    { key: "voltage", value: "110V" }
  ]
}
// One compound index: { "attributes.key": 1, "attributes.value": 1 }
```

**Benefits:** Single index covers all attributes, flexible schema

### Subset Pattern

**Use Case:** Large documents where most reads only need a portion of the data.

```javascript
// Main collection (frequently accessed subset)
{
  _id: ObjectId("..."),
  title: "Product Name",
  price: 99.99,
  thumbnail: "thumb.jpg",
  recentReviews: [  // Last 5 reviews
    { author: "Alice", rating: 5, text: "Great!" }
  ],
  avgRating: 4.5,
  reviewCount: 2500
}

// Detail collection (full data)
{
  productId: ObjectId("..."),
  fullDescription: "...",
  allImages: [...],
  specifications: {...}
}
```

**Benefits:** Reduces working set size, faster reads for common access patterns

### Extended Reference Pattern

**Use Case:** Avoid $lookup by copying frequently accessed fields from referenced document.

```javascript
// Order with extended customer reference
{
  _id: ObjectId("..."),
  orderDate: ISODate("..."),
  customerId: ObjectId("..."),
  // Extended reference - copied from customer
  customerName: "Alice Smith",
  customerEmail: "alice@example.com",
  items: [...]
}
```

**Benefits:** No $lookup needed for common queries
**Trade-off:** Must update copies when source changes (eventual consistency acceptable)

### Computed Pattern

**Use Case:** Pre-compute expensive calculations and store the results.

```javascript
{
  _id: ObjectId("..."),
  name: "Product A",
  reviews: [...],
  // Computed fields - updated on write
  totalReviews: 156,
  averageRating: 4.3,
  ratingDistribution: { "5": 80, "4": 40, "3": 20, "2": 10, "1": 6 }
}
```

**Benefits:** Avoid expensive aggregation on reads, faster queries

## Schema Validation

**[📖 Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)** - Validation rules documentation

```javascript
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "email", "age"],
      properties: {
        name: {
          bsonType: "string",
          description: "must be a string and is required"
        },
        email: {
          bsonType: "string",
          pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
          description: "must be a valid email"
        },
        age: {
          bsonType: "int",
          minimum: 0,
          maximum: 150,
          description: "must be an integer between 0 and 150"
        },
        status: {
          enum: ["active", "inactive", "pending"],
          description: "must be one of the defined statuses"
        }
      }
    }
  },
  validationLevel: "moderate",  // strict (default) or moderate
  validationAction: "error"      // error (default) or warn
});
```

**Validation Levels:**
- `strict` - Validates on all inserts and updates
- `moderate` - Only validates documents that match the existing schema

**Validation Actions:**
- `error` - Reject invalid documents
- `warn` - Allow but log a warning

## Key Limits

| Limit | Value |
|-------|-------|
| Maximum document size | 16 MB |
| Maximum BSON nesting depth | 100 levels |
| Maximum namespace length | 120 bytes |
| Maximum indexes per collection | 64 |
| Maximum index key length | 1024 bytes |
| Maximum number of fields in compound index | 32 |
