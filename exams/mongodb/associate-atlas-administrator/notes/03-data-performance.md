# Data Management and Performance

**[📖 Atlas Search](https://www.mongodb.com/docs/atlas/atlas-search/)** - Search documentation
**[📖 Performance Advisor](https://www.mongodb.com/docs/atlas/performance-advisor/)** - Performance optimization

## Atlas Search

### Overview
- Full-text search engine built on Apache Lucene
- Integrated directly into MongoDB Atlas
- Accessed via `$search` aggregation stage
- Separate search indexes from database indexes
- Available on M10+ clusters

### Creating Search Indexes

**Via Atlas UI:**
1. Navigate to cluster > Search tab
2. Click "Create Search Index"
3. Choose Visual Editor or JSON Editor
4. Select database and collection
5. Configure field mappings

**Index Configuration:**
```json
{
  "mappings": {
    "dynamic": false,
    "fields": {
      "title": {
        "type": "string",
        "analyzer": "lucene.standard"
      },
      "description": {
        "type": "string",
        "analyzer": "lucene.english"
      },
      "productName": {
        "type": "autocomplete",
        "tokenization": "edgeGram",
        "minGrams": 3,
        "maxGrams": 15
      },
      "category": {
        "type": "stringFacet"
      },
      "price": {
        "type": "number"
      },
      "location": {
        "type": "geo"
      }
    }
  }
}
```

**Mapping Types:**
| Type | Description | Use Case |
|------|-------------|----------|
| `dynamic: true` | Auto-index all fields | Prototyping |
| `dynamic: false` | Only mapped fields | Production (recommended) |

**Field Types:**
| Type | Description |
|------|-------------|
| `string` | Text with analyzer |
| `number` | Numeric values |
| `date` | Date fields |
| `boolean` | True/false values |
| `objectId` | ObjectId fields |
| `geo` | GeoJSON geometry |
| `autocomplete` | Autocomplete suggestions |
| `stringFacet` | Faceted string values |
| `numberFacet` | Faceted numeric values |

### Analyzers

| Analyzer | Description |
|----------|-------------|
| `lucene.standard` | Default, tokenizes on whitespace and punctuation |
| `lucene.simple` | Tokenizes on non-letter characters |
| `lucene.whitespace` | Tokenizes on whitespace only |
| `lucene.keyword` | Treats entire string as single token |
| `lucene.english` | English language stemming and stop words |

### Querying with $search

```javascript
// Basic text search
db.products.aggregate([
  { $search: { text: { query: "laptop", path: "title" } } },
  { $limit: 10 },
  { $project: { title: 1, price: 1, score: { $meta: "searchScore" } } }
]);

// Compound search
db.products.aggregate([
  { $search: {
    compound: {
      must: [{ text: { query: "laptop", path: "title" } }],
      filter: [{ range: { path: "price", gte: 500, lte: 2000 } }],
      should: [{ text: { query: "gaming", path: "description" } }],
      mustNot: [{ text: { query: "refurbished", path: "condition" } }]
    }
  }}
]);

// Autocomplete
db.products.aggregate([
  { $search: { autocomplete: { query: "lap", path: "productName" } } },
  { $limit: 10 }
]);
```

**Key Rules:**
- `$search` must be the first stage in the pipeline
- Cannot use `$match` before `$search`
- Use `$searchMeta` for facet results without documents

## Performance Advisor

**[📖 Performance Advisor](https://www.mongodb.com/docs/atlas/performance-advisor/)** - Index recommendations

### Capabilities
- Analyzes queries from the last 24 hours (M10+)
- Suggests indexes to create based on slow queries
- Identifies redundant and unused indexes
- Shows query patterns and execution statistics

### Index Recommendations
- Based on query patterns with high execution time
- Considers query frequency and impact
- Suggests compound indexes following best practices
- Provides estimated performance improvement

### Using Performance Advisor
1. Navigate to cluster > Performance Advisor
2. Review suggested indexes
3. See the queries that would benefit from each index
4. Create indexes directly from the advisor
5. Monitor impact after index creation

### Index Management in Atlas
- Create indexes via Atlas UI (rolling builds on M10+)
- Drop indexes from collection view
- View index statistics (size, usage)
- Rolling index builds prevent downtime

## Real-Time Performance Panel

**[📖 Real-Time Performance](https://www.mongodb.com/docs/atlas/real-time-performance-panel/)** - Live monitoring

### Active Operations
- Shows currently executing operations
- Duration of each operation
- Operation type (read, write, command)
- Target collection and query pattern

### Query Targeting
- Ratio of documents scanned to documents returned
- High ratio indicates missing or inefficient indexes
- Target ratio close to 1:1 for optimal performance
- Alerts can be configured for high targeting ratios

### Hottest Collections
- Collections with the most active operations
- Read vs write distribution
- Helps identify bottleneck collections

## Database Profiler

**[📖 Query Profiler](https://www.mongodb.com/docs/atlas/tutorial/profile-database/)** - Profiler in Atlas

- Available on M10+ clusters
- Configure via Atlas UI or API
- Shows slow queries with execution details
- Filter by operation type, namespace, duration

**Profiler Output:**
- Operation type (find, update, aggregate, etc.)
- Execution time in milliseconds
- Documents scanned vs returned
- Index used or collection scan
- Query shape and plan summary

## Data Federation

**[📖 Data Federation](https://www.mongodb.com/docs/atlas/data-federation/)** - Federated queries

### Overview
- Query data across multiple sources with a single connection
- Supports Atlas clusters, S3 buckets, Azure Blob Storage
- Virtual database - no data movement
- SQL and MQL query support

### Data Sources
| Source | Description |
|--------|-------------|
| Atlas Cluster | Live cluster data |
| Atlas Online Archive | Archived data |
| AWS S3 | Data in S3 buckets (JSON, CSV, Parquet, Avro) |
| Azure Blob Storage | Data in Azure storage containers |

### Use Cases
- Query archived and live data together
- Analyze data in cloud storage without ETL
- Create reporting views across multiple sources
- Reduce cluster storage by archiving to cheaper storage

## Online Archive

**[📖 Online Archive](https://www.mongodb.com/docs/atlas/online-archive/manage-online-archive/)** - Data archiving

### Configuration
1. Select collection to archive
2. Define archiving rule (date field and age threshold)
3. Set partition fields for query optimization
4. Archive moves data from cluster to cloud storage

### Rules
- Date-based archiving: documents older than X days
- Custom criteria with $match expression
- Partition fields improve query performance on archived data
- Archiving runs continuously in the background

### Key Points
- Archived data is read-only
- Query via Data Federation connection string
- Reduces cluster storage costs
- Data remains queryable alongside live data
- Cannot modify archived documents (must restore first)

## Data Explorer

### Features
- Browse collections and documents in Atlas UI
- Run find queries with filter, project, sort
- Run aggregation pipelines interactively
- Insert, edit, and delete individual documents
- View collection statistics and indexes
- Export query results (JSON, CSV)

### Query Interface
- Filter: MongoDB query syntax
- Project: Field inclusion/exclusion
- Sort: Ascending/descending on any field
- Limit: Number of documents to display
- Aggregation: Visual pipeline builder

## Performance Best Practices

1. **Use Performance Advisor** - Implement recommended indexes
2. **Monitor query targeting** - Keep scanned:returned ratio low
3. **Avoid collection scans** - Ensure queries use indexes
4. **Right-size your cluster** - Match tier to workload requirements
5. **Use analytics nodes** - Isolate analytical from operational traffic
6. **Archive old data** - Use Online Archive to reduce working set
7. **Use Atlas Search** for text queries instead of $regex
8. **Profile slow queries** - Use the database profiler on M10+
9. **Index rollouts** - Use rolling index builds to avoid downtime
10. **Monitor cache utilization** - Ensure working set fits in memory
