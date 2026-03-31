# Atlas Tools

**[📖 MongoDB Atlas](https://www.mongodb.com/docs/atlas/)** - Atlas documentation
**[📖 Atlas Search](https://www.mongodb.com/docs/atlas/atlas-search/)** - Atlas Search documentation

## Atlas Search

### Overview
- Full-text search engine built on Apache Lucene
- Integrated directly into MongoDB Atlas
- Accessed via `$search` aggregation stage
- Supports autocomplete, fuzzy matching, faceted search, and scoring
- Separate from MongoDB text indexes (more powerful)

**[📖 Atlas Search Overview](https://www.mongodb.com/docs/atlas/atlas-search/atlas-search-overview/)** - Search concepts

### Search Index Definition

```json
{
  "mappings": {
    "dynamic": true,
    "fields": {
      "title": {
        "type": "string",
        "analyzer": "lucene.standard"
      },
      "description": {
        "type": "string",
        "analyzer": "lucene.english"
      },
      "price": {
        "type": "number"
      },
      "tags": {
        "type": "string",
        "analyzer": "lucene.keyword"
      },
      "productName": {
        "type": "autocomplete",
        "tokenization": "edgeGram",
        "minGrams": 3,
        "maxGrams": 15
      }
    }
  }
}
```

**Index Types:**
- `dynamic: true` - Automatically index all fields (good for prototyping)
- `dynamic: false` - Only index explicitly defined fields (recommended for production)

**Field Types:**
- `string` - Text fields with analyzer
- `number` - Numeric fields
- `date` - Date fields
- `boolean` - Boolean fields
- `geo` - GeoJSON objects
- `autocomplete` - Autocomplete suggestions
- `token` - Exact match tokens

### Search Operators

**$search Stage:**
```javascript
db.products.aggregate([
  { $search: {
    index: "default",  // Index name (optional if "default")
    text: {
      query: "wireless headphones",
      path: "title",
      fuzzy: { maxEdits: 1 }  // Allow 1 character edit
    }
  }},
  { $limit: 10 },
  { $project: {
    title: 1,
    price: 1,
    score: { $meta: "searchScore" }
  }}
]);
```

**Text Search:**
```javascript
{ $search: {
  text: {
    query: "coffee",
    path: ["title", "description"],  // Search multiple fields
    fuzzy: { maxEdits: 2, prefixLength: 3 }
  }
}}
```

**Phrase Search:**
```javascript
{ $search: {
  phrase: {
    query: "new york",
    path: "city",
    slop: 1  // Allow 1 word between terms
  }
}}
```

**Autocomplete Search:**
```javascript
{ $search: {
  autocomplete: {
    query: "head",
    path: "productName",
    tokenOrder: "sequential"
  }
}}
```

**Compound Search:**
```javascript
{ $search: {
  compound: {
    must: [
      { text: { query: "laptop", path: "title" } }
    ],
    should: [
      { text: { query: "gaming", path: "description" } }
    ],
    mustNot: [
      { text: { query: "refurbished", path: "condition" } }
    ],
    filter: [
      { range: { path: "price", gte: 500, lte: 2000 } }
    ]
  }
}}
```

**Compound Clauses:**
- `must` - Must match (affects score)
- `should` - Should match (boosts score)
- `mustNot` - Must not match (filters, does not affect score)
- `filter` - Must match (filters, does not affect score)

**Range Search:**
```javascript
{ $search: {
  range: {
    path: "price",
    gte: 100,
    lte: 500
  }
}}
```

### Search Facets

```javascript
db.products.aggregate([
  { $searchMeta: {
    facet: {
      operator: {
        text: { query: "laptop", path: "title" }
      },
      facets: {
        brandFacet: {
          type: "string",
          path: "brand",
          numBuckets: 10
        },
        priceFacet: {
          type: "number",
          path: "price",
          boundaries: [0, 500, 1000, 2000, 5000]
        }
      }
    }
  }}
]);
```

### Search Scoring

```javascript
// Boost specific fields
{ $search: {
  compound: {
    should: [
      {
        text: {
          query: "laptop",
          path: "title",
          score: { boost: { value: 3 } }
        }
      },
      {
        text: {
          query: "laptop",
          path: "description",
          score: { boost: { value: 1 } }
        }
      }
    ]
  }
}}
```

## Atlas Charts

**[📖 Atlas Charts](https://www.mongodb.com/docs/charts/)** - Charts documentation

### Overview
- Built-in data visualization tool in MongoDB Atlas
- No data movement or ETL required
- Connects directly to Atlas collections
- Supports real-time and scheduled refresh
- Embeddable charts for applications

### Chart Types
- **Bar/Column** - Categorical comparisons
- **Line** - Time-series trends
- **Area** - Stacked time-series
- **Scatter** - Correlations between variables
- **Donut/Pie** - Proportional distribution
- **Heatmap** - Two-dimensional distribution
- **Geospatial** - Map-based visualization
- **Number** - Single metric display
- **Table** - Tabular data display
- **Gauge** - Progress toward a goal

### Key Features
- **Data Source** - Connect to Atlas collections or views
- **Aggregation** - Charts use aggregation pipeline under the hood
- **Filters** - Interactive filtering on dashboards
- **Embedding** - Embed charts in web applications via SDK
- **Dashboards** - Organize multiple charts into dashboards
- **Sharing** - Share with team members or embed publicly

## Atlas Data API

**[📖 Atlas Data API](https://www.mongodb.com/docs/atlas/app-services/data-api/)** - Data API documentation

### Overview
- HTTP/REST API for CRUD operations on Atlas data
- No MongoDB driver required
- Access from any HTTP client (curl, fetch, etc.)
- Authentication via API keys

### Endpoints

**Base URL:** `https://data.mongodb-api.com/app/<app-id>/endpoint/data/v1`

**Find Documents:**
```bash
curl -X POST "https://data.mongodb-api.com/app/<app-id>/endpoint/data/v1/action/find" \
  -H "Content-Type: application/json" \
  -H "api-key: <API-KEY>" \
  -d '{
    "dataSource": "Cluster0",
    "database": "mydb",
    "collection": "users",
    "filter": { "status": "active" },
    "projection": { "name": 1, "email": 1 },
    "limit": 10
  }'
```

**Insert Document:**
```bash
curl -X POST ".../action/insertOne" \
  -H "Content-Type: application/json" \
  -H "api-key: <API-KEY>" \
  -d '{
    "dataSource": "Cluster0",
    "database": "mydb",
    "collection": "users",
    "document": { "name": "Alice", "email": "alice@example.com" }
  }'
```

**Update Document:**
```bash
curl -X POST ".../action/updateOne" \
  -d '{
    "dataSource": "Cluster0",
    "database": "mydb",
    "collection": "users",
    "filter": { "email": "alice@example.com" },
    "update": { "$set": { "lastLogin": { "$date": "2024-01-15T00:00:00Z" } } }
  }'
```

**Available Actions:**
- `findOne` / `find` - Query documents
- `insertOne` / `insertMany` - Insert documents
- `updateOne` / `updateMany` - Update documents
- `deleteOne` / `deleteMany` - Delete documents
- `aggregate` - Run aggregation pipeline

## Atlas Triggers

**[📖 Atlas Triggers](https://www.mongodb.com/docs/atlas/app-services/triggers/)** - Triggers documentation

### Trigger Types

#### Database Triggers
- Fire on collection changes (insert, update, delete, replace)
- Can be configured for specific operations
- Access to change event document (fullDocument, updateDescription)
- Support for document preimage (before change)

**Configuration:**
```javascript
// Trigger function receives change event
exports = function(changeEvent) {
  const fullDocument = changeEvent.fullDocument;
  const operationType = changeEvent.operationType;
  const updateDescription = changeEvent.updateDescription;
  
  // Process the change
  if (operationType === "insert") {
    // Handle new document
  } else if (operationType === "update") {
    // Handle update
    const updatedFields = updateDescription.updatedFields;
  }
};
```

**Trigger Options:**
- **Operation Types:** Insert, Update, Delete, Replace
- **Full Document:** Include the full document after change
- **Document Preimage:** Include document before change (requires oplog)
- **Project:** Filter which fields trigger the function
- **Match Expression:** Filter which documents trigger the function

#### Scheduled Triggers
- Fire on a cron schedule
- No change event - runs at specified times
- Good for periodic tasks (cleanup, reports, sync)

**Cron Expressions:**
```
# Every hour
0 * * * *

# Every day at midnight
0 0 * * *

# Every Monday at 9 AM
0 9 * * 1
```

#### Authentication Triggers
- Fire on user authentication events
- Create, login, delete user events
- Good for auditing and user onboarding

### Trigger Functions
- Written in JavaScript
- Run in Atlas App Services runtime
- Can access MongoDB collections
- Can call external services (HTTP, email, etc.)
- Have access to context object (user, environment)

```javascript
// Access collections in trigger function
exports = async function(changeEvent) {
  const mongodb = context.services.get("mongodb-atlas");
  const db = mongodb.db("mydb");
  const auditCollection = db.collection("audit_log");
  
  await auditCollection.insertOne({
    timestamp: new Date(),
    operation: changeEvent.operationType,
    collection: changeEvent.ns.coll,
    documentId: changeEvent.documentKey._id,
    userId: context.user.id
  });
};
```

## Atlas Additional Features

### Performance Advisor
- Analyzes slow queries automatically
- Suggests indexes to create
- Shows index usage statistics
- Identifies unused indexes for potential removal
- Available for M10+ clusters

### Data Explorer
- Browse collections and documents in the Atlas UI
- Run queries and aggregation pipelines
- Edit documents directly
- View collection statistics
- Export query results

### Atlas CLI
```bash
# Login
atlas auth login

# List clusters
atlas clusters list

# Create cluster
atlas clusters create myCluster --region US_EAST_1 --tier M10

# Load sample data
atlas clusters sampleData load myCluster

# Manage database users
atlas dbusers create --username myuser --password mypass --role readWriteAnyDatabase
```

**[📖 Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/)** - CLI documentation
