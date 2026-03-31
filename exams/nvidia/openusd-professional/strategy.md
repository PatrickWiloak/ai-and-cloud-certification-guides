# NCP-USD OpenUSD Professional Study Strategy

## Study Approach

### Phase 1: Foundation (1-2 weeks)
1. **USD Data Model** - Prims, properties, schemas, file formats
2. **Composition** - LIVRPS, references, payloads, variants, sublayers
- **[📖 OpenUSD Documentation](https://openusd.org/release/index.html)**

### Phase 2: Platform (2-3 weeks)
1. **Omniverse** - Nucleus, connectors, Kit SDK
2. **Rendering** - Materials, lighting, Hydra, RTX
3. **Collaboration** - Multi-user workflows, pipelines
- **[📖 Omniverse Documentation](https://docs.omniverse.nvidia.com/)**

### Phase 3: Exam Prep (1-2 weeks)
1. Practice composition and API questions
2. Review LIVRPS thoroughly
3. Focus on weak areas

## Recommended Resources
- **[OpenUSD Documentation](https://openusd.org/release/index.html)** - Core reference
- **[Omniverse Documentation](https://docs.omniverse.nvidia.com/)** - Platform
- **[USD Python API](https://openusd.org/release/api/index.html)** - Programming
- **[NVIDIA DLI - USD Courses](https://www.nvidia.com/en-us/training/)** - Training
- **[NVIDIA Developer USD](https://developer.nvidia.com/usd)** - Resources

## Exam Tactics

### Keywords
- "Composition" or "override" - LIVRPS ordering
- "Heavy asset" or "loading" - Payloads
- "Reuse" or "include" - References
- "Switch" or "option" - Variant sets
- "Collaboration" - Nucleus and live layers
- "Material" - UsdPreviewSurface or MDL
- "Render" - Hydra delegates

### Common Pitfalls
- LIVRPS: Local is strongest, Sublayers is weakest
- References are always loaded; payloads can be deferred
- Inherits are stronger than variants and references
- .usdz is read-only (ZIP archive)
- UsdPreviewSurface is for interchange; MDL is for NVIDIA rendering
- Nucleus provides collaboration; connectors provide DCC tool integration
