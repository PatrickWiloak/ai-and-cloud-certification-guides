# NVIDIA OpenUSD Professional - Fact Sheet

## Quick Reference

**Exam Code:** NCP-USD
**Duration:** 120 minutes
**Questions:** 60-70 questions
**Passing Score:** Not officially published
**Cost:** $200 USD
**Validity:** 2 years
**Difficulty:** Advanced

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| USD Fundamentals | 25% | Data model, prims, properties, schemas |
| Scene Composition | 25% | Layers, composition arcs, LIVRPS |
| Omniverse Platform | 20% | Nucleus, connectors, Kit SDK |
| Rendering and Materials | 15% | Materials, lighting, Hydra, RTX |
| Collaboration and Pipeline | 15% | Multi-user, versioning, integration |

## Domain 1: USD Fundamentals

### Core Data Model

**Prims (Primitives):**
- Fundamental scene element in USD
- Hierarchical (tree structure like a file system)
- Types: Xform, Mesh, Camera, Light, Scope, Material
- Each prim has a unique path (e.g., `/World/House/Roof`)

**Properties:**
- **Attributes** - Typed data values (position, color, opacity)
- **Relationships** - Links between prims (material binding)
- Properties can be time-sampled for animation

**Metadata:**
- Key-value data attached to prims, properties, or layers
- `kind`, `purpose`, `hidden`, `active`
- Custom metadata for pipeline information

### File Formats

| Format | Extension | Description |
|--------|-----------|-------------|
| ASCII | .usda | Human-readable text format |
| Binary (Crate) | .usdc | Compact binary, faster loading |
| Package | .usdz | ZIP archive for distribution |
| Generic | .usd | Can be either .usda or .usdc |

### Schema Types

**Typed Schemas (IsA):**
- Define prim types with built-in properties
- UsdGeomMesh, UsdGeomXform, UsdLuxDistantLight
- Prim can only have one typed schema

**API Schemas (HasA):**
- Add capabilities to prims
- Can stack multiple API schemas on one prim
- UsdShadeMaterialBindingAPI, UsdGeomModelAPI
- Applied vs Non-Applied API schemas

**[📖 OpenUSD Schema Documentation](https://openusd.org/release/api/index.html)** - Schema reference

## Domain 2: Scene Composition

### Composition Arcs

**LIVRPS (Composition Order - strongest to weakest):**
1. **L**ocal opinions - Direct edits on the layer
2. **I**nherits - Inherit from another prim (class-like)
3. **V**ariantSets - Switchable variations
4. **R**eferences - Include external USD files or prims
5. **P**ayloads - Deferred references (lazy loading)
6. **S**pecializes - Like inherits but weakest (base class)

### References
```python
# USD Python API
prim.GetReferences().AddReference('./asset.usd', '/Root')
```
- Include external USD files into the scene
- Strongest external composition arc
- Always loaded with the scene
- Can target specific prim paths

### Payloads
```python
prim.GetPayloads().AddPayload('./heavy_asset.usd')
```
- Deferred loading (can be unloaded)
- Same as references but weaker and lazy-loadable
- Used for heavy assets to manage memory
- Load/unload at runtime for performance

### VariantSets
```python
vset = prim.GetVariantSets().AddVariantSet('color')
vset.AddVariant('red')
vset.AddVariant('blue')
vset.SetVariantSelection('red')
```
- Switchable variations on a prim
- Named sets with named variants
- Non-destructive option switching
- Common for LODs, material variations, configurations

### Inherits
- Prim inherits properties from another prim (class)
- Changes to class propagate to all inheriting prims
- Stronger than references (overrides reference opinions)
- Used for shared defaults across many assets

### Layer Stack
- Multiple layers compose to form the final scene
- Stronger layers override weaker layers
- Root layer is strongest
- Sub-layers add opinions in order
- Non-destructive editing through layer separation

**[📖 USD Composition](https://openusd.org/release/glossary.html)** - Composition reference

## Domain 3: Omniverse Platform

### Architecture

**Nucleus:**
- Central collaboration server
- Stores USD files and assets
- Real-time synchronization
- Version control for scene files
- Access control and permissions
- **[📖 Nucleus Documentation](https://docs.omniverse.nvidia.com/nucleus/)**

**Connectors:**
- Plugins for DCC tools (Maya, Blender, 3ds Max, etc.)
- Live sync between DCC and Omniverse
- USD import/export
- Material translation

**Kit SDK:**
- Framework for building Omniverse applications
- Extension-based architecture
- Python and C++ APIs
- UI framework (omni.ui)
- Viewport and rendering integration
- **[📖 Kit Documentation](https://docs.omniverse.nvidia.com/kit/)**

### Key Applications
- **USD Composer** - Scene layout and composition
- **USD Presenter** - Interactive visualization
- **Audio2Face** - AI-driven facial animation
- **Machinima** - Real-time storytelling
- **Code** - Development environment

## Domain 4: Rendering and Materials

### USD Preview Surface
- Standard material definition in USD
- Cross-platform compatibility
- Properties: diffuseColor, metallic, roughness, opacity
- Basic PBR (Physically Based Rendering) material

### MDL Materials
- NVIDIA Material Definition Language
- Advanced physically-based materials
- Procedural textures and functions
- GPU-optimized rendering
- **[📖 MDL Documentation](https://developer.nvidia.com/mdl-sdk)** - Material language

### Hydra Render Delegates
- USD's rendering architecture
- Pluggable render backends
- Storm (OpenGL/Vulkan rasterizer)
- RTX (NVIDIA ray tracing)
- Third-party delegates (RenderMan, Arnold)

### Lighting
- UsdLux light types: DistantLight, SphereLight, RectLight, DomeLight
- Light linking and shadow controls
- IBL (Image-Based Lighting) with DomeLight
- Physical light units

## Domain 5: Collaboration

### Multi-User Workflows
- Nucleus server enables real-time collaboration
- Live layers for per-user edits
- Layer locking for conflict prevention
- Merge workflows for combining changes
- Checkpoints for version snapshots

### Asset Management
- Consistent naming conventions
- Asset resolution (ArResolver) for path mapping
- Reference counting for dependency tracking
- Payload management for scene optimization

## Exam Tips

### Key Concepts to Master
1. LIVRPS composition order (memorize this)
2. References vs Payloads (loading behavior)
3. USD file formats and when to use each
4. Prim types and schema system
5. Omniverse Nucleus and collaboration model
6. Hydra rendering architecture
