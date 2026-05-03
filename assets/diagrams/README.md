# Diagrams

PNG diagrams used throughout the repo, generated from [draw.io](https://app.diagrams.net/) (or the draw.io MCP server when available).

## Layout

Diagrams are organized by topic. Subdirectories are created lazily as content grows:

```
assets/diagrams/
├── architecture/    # Architecture patterns (3-tier, microservices, event-driven, etc.)
├── ai/              # AI/ML topics (RAG pipelines, attention, agent loops)
├── cloud/           # Cloud primitives (regions, VPC topologies, storage)
├── networking/      # Networking deep dives (DNS flow, BGP, load balancing)
└── security/        # Security and identity flows (OAuth, IAM, zero trust)
```

## Authoring

- Create diagrams in draw.io (preferred) or any tool that exports PNG.
- Export at 2x resolution for retina displays.
- Keep file size under ~200 KB for inline use.
- Save the source `.drawio` file alongside the PNG when feasible (so others can edit).

## Embedding

```markdown
![Descriptive alt text](../../assets/diagrams/<topic>/<slug>.png)
```

Always include alt text. See [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md#visual-content-standards) for the full convention, including when to use Mermaid as an inline fallback.
