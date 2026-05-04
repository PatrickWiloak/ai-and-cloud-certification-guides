---
last-updated: 2026-05-03
difficulty: intermediate
reading-time: 20 min
---

# Build a RAG pipeline

End-to-end retrieval-augmented generation: load documents, chunk, embed, store in pgvector, retrieve top-K per query, generate with Claude, evaluate. Inline code; should run in ~30 minutes.

For the underlying mechanics see **[RAG explained](../../learn/concepts/rag-explained.md)** and **[Embeddings and vector search](../../learn/concepts/embeddings-and-vector-search.md)**.

## Architecture

```mermaid
flowchart LR
  Docs[Source docs<br/>markdown, PDFs] --> Chunk[Chunk]
  Chunk --> Embed[Embed]
  Embed --> PG[(Postgres<br/>+pgvector)]

  Q[User query] --> EmbQ[Embed query]
  EmbQ --> PG
  PG --> Top[Top-K chunks]
  Top --> Build[Build prompt]
  Q --> Build
  Build --> Claude[Claude Sonnet]
  Claude --> Ans[Answer + citations]
```

## Prerequisites

- Python 3.11+
- Docker (for Postgres + pgvector)
- An Anthropic API key (or OpenAI - swap the client) - get one at [console.anthropic.com](https://console.anthropic.com/)
- ~30 minutes

## Step 1: Postgres with pgvector

Run a local Postgres with the pgvector extension:

```bash
docker run -d --name rag-pg \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  pgvector/pgvector:pg16

# Wait a few seconds for startup, then create the schema:
docker exec -i rag-pg psql -U postgres <<'SQL'
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS chunks (
  id          SERIAL PRIMARY KEY,
  doc_id      TEXT NOT NULL,
  chunk_index INT NOT NULL,
  content     TEXT NOT NULL,
  metadata    JSONB,
  embedding   vector(1024)
);

CREATE INDEX IF NOT EXISTS chunks_embedding_idx
  ON chunks USING hnsw (embedding vector_cosine_ops);
SQL
```

The `vector(1024)` dimension matches the embedding model you'll use below. Change if you swap models.

## Step 2: Install Python dependencies

```bash
pip install anthropic psycopg[binary] sentence-transformers
```

`sentence-transformers` runs locally - no embedding API calls needed. We use the `voyage-3-lite` quality (1024 dim) via a free local model.

## Step 3: Ingest documents

Save as `ingest.py`:

```python
import os
import re
import psycopg
from sentence_transformers import SentenceTransformer

DB = "postgresql://postgres:password@localhost:5432/postgres"
embed_model = SentenceTransformer("BAAI/bge-large-en-v1.5")  # 1024 dim


def chunk_markdown(text, target_size=600, overlap=100):
    """Chunk on paragraph boundaries with overlap."""
    paragraphs = re.split(r"\n\s*\n", text)
    chunks, current = [], ""
    for p in paragraphs:
        if len(current) + len(p) <= target_size:
            current += "\n\n" + p
        else:
            if current.strip():
                chunks.append(current.strip())
            # carry overlap into next chunk
            tail = current[-overlap:] if current else ""
            current = tail + "\n\n" + p
    if current.strip():
        chunks.append(current.strip())
    return chunks


def ingest_file(conn, path):
    text = open(path, encoding="utf-8").read()
    chunks = chunk_markdown(text)
    embeddings = embed_model.encode(chunks, normalize_embeddings=True).tolist()
    doc_id = os.path.basename(path)
    with conn.cursor() as cur:
        for i, (chunk, emb) in enumerate(zip(chunks, embeddings)):
            cur.execute(
                "INSERT INTO chunks (doc_id, chunk_index, content, embedding) "
                "VALUES (%s, %s, %s, %s)",
                (doc_id, i, chunk, str(emb)),
            )
    conn.commit()
    print(f"Ingested {len(chunks)} chunks from {path}")


if __name__ == "__main__":
    import sys
    paths = sys.argv[1:] or ["docs/sample.md"]
    with psycopg.connect(DB) as conn:
        for p in paths:
            ingest_file(conn, p)
```

Run against any markdown corpus you have. To test, use this repo's concept pages:

```bash
python ingest.py ../../learn/concepts/*.md
```

## Step 4: Query

Save as `query.py`:

```python
import os
import psycopg
from anthropic import Anthropic
from sentence_transformers import SentenceTransformer

DB = "postgresql://postgres:password@localhost:5432/postgres"
embed_model = SentenceTransformer("BAAI/bge-large-en-v1.5")
client = Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

PROMPT = """You are a helpful assistant. Answer the user's question using ONLY
the context below. If the answer isn't in the context, say
"I don't have that information."

After the answer, cite the chunks you used like: [source: doc_id chunk N].

<context>
{context}
</context>

Question: {question}"""


def retrieve(question, k=5):
    q_emb = embed_model.encode([question], normalize_embeddings=True)[0].tolist()
    with psycopg.connect(DB) as conn, conn.cursor() as cur:
        cur.execute(
            "SELECT doc_id, chunk_index, content, "
            "1 - (embedding <=> %s::vector) AS score "
            "FROM chunks ORDER BY embedding <=> %s::vector LIMIT %s",
            (str(q_emb), str(q_emb), k),
        )
        return cur.fetchall()


def answer(question):
    rows = retrieve(question)
    context = "\n\n---\n\n".join(
        f"[doc: {doc_id} chunk {idx} score {score:.2f}]\n{content}"
        for doc_id, idx, content, score in rows
    )
    msg = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=600,
        messages=[{"role": "user", "content": PROMPT.format(context=context, question=question)}],
    )
    return msg.content[0].text


if __name__ == "__main__":
    import sys
    q = " ".join(sys.argv[1:]) or "What is RAG?"
    print(answer(q))
```

Run:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
python query.py "What is the difference between RAG and fine-tuning?"
```

You should see an answer with citations pointing back to the relevant concept pages.

## Step 5: Evaluate

A pipeline without an eval is a pipeline you can't improve. Save as `eval.py`:

```python
import json
from query import answer

# Golden set: (question, must-mention substrings)
golden = [
    ("What is RAG?", ["retriev", "context"]),
    ("Why use RAG instead of fine-tuning?",
     ["updateable", "cited", "cheap", "knowledge"]),
    ("What is a vector database?",
     ["embedding", "similarity", "nearest"]),
    ("What does prompt caching do?",
     ["cache", "prefix", "cost"]),
]

def passes(answer_text, must_mention):
    return all(s.lower() in answer_text.lower() for s in must_mention)

results = []
for q, must in golden:
    a = answer(q)
    ok = passes(a, must)
    results.append({"q": q, "must": must, "answer": a[:200], "pass": ok})
    print(f"{'PASS' if ok else 'FAIL'}: {q}")

passed = sum(1 for r in results if r["pass"])
print(f"\n{passed}/{len(results)} passed")
with open("eval-results.json", "w") as f:
    json.dump(results, f, indent=2)
```

Run before and after every change. Track the pass rate over time.

For real evals, swap substring matching for an LLM-as-judge evaluator. See **[Set up an eval harness](./set-up-eval-harness.md)**.

## Step 6: Iterate

The pipeline above is the 70% solution. Real wins come from iterating:

- **Better chunking**: split on logical boundaries (headings) instead of paragraph length
- **Hybrid search**: add `pg_trgm` keyword search alongside vectors, fuse results
- **Reranking**: retrieve top-20, rerank with Cohere or a cross-encoder, keep top-5
- **Query rewriting**: have Claude paraphrase the user's query into 2-3 search variants
- **Citations**: track chunk IDs through generation, surface to user with deeplinks
- **Prompt caching**: cache the system prompt + retrieved-context prefix for repeated questions on the same docs ([Prompt caching](../../learn/concepts/prompt-caching.md))

## Verification

You know it worked when:

- `SELECT count(*) FROM chunks;` returns >0
- `python query.py "..."` returns a coherent answer
- `python eval.py` shows >50% pass rate (then improve from there)

## Cleanup

```bash
docker stop rag-pg && docker rm rag-pg
```

## Extensions

- Replace pgvector with **[Pinecone, Weaviate, or Qdrant](../service-comparison-vector-databases.md)** as scale grows
- Add **[LLM observability](../service-comparison-llm-observability.md)** to trace queries in production
- Wrap as an MCP server so a Claude agent can use this RAG ([Build a Claude agent with MCP](./build-claude-agent-with-mcp.md))
- Move embedding from local model to a hosted embedding API (Voyage, OpenAI, Cohere) when latency matters

## Cross-references

- **Concepts**: [RAG explained](../../learn/concepts/rag-explained.md), [Embeddings](../../learn/concepts/embeddings-and-vector-search.md), [Context windows](../../learn/concepts/context-windows-and-management.md)
- **Topic**: [LLMs and GenAI](../../topics/llms-and-genai.md)
- **Comparisons**: [Vector databases](../service-comparison-vector-databases.md), [GenAI platforms](../service-comparison-genai-platforms.md)
- **Architecture pattern**: [AI/ML pipeline](../architecture-patterns/ai-ml-pipeline.md)
