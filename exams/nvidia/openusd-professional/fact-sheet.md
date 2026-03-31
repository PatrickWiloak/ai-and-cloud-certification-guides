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
| USD Fundamentals | 25% | Data model, prims, layers, schemas |
| Scene Composition | 25% | LIVRPS, references, variants, payloads |
| NVIDIA Omniverse | 20% | Platform, Nucleus, Connectors, Kit |
| Rendering and Materials | 15% | MDL, Hydra, RTX, lighting |
| Collaboration and Pipelines | 15% | Multi-user, asset management, digital twins |

## Domain 1: USD Fundamentals

### File Formats
- **.usda** - ASCII (human-readable)
- **.usdc** - Binary (Crate format, fast loading)
- **.usdz** - Zip archive (usdc + textures, for distribution)

### Data Model

**Prims (Primitives):**
- Fundamental building blocks of USD scenes
- Hierarchical namespace (tree structure)
- Types: Xform, Mesh, Camera, Light, Material, Scope
- Each prim has a path (e.g., /World/Character/Body)

**Attributes:**
- Named, typed data on prims
- Time-sampled for animation
- Can have default values and time samples
- Examples: xformOp:translate, points, normals

**Relationships:**
- Named connections between prims
- Used for material bindings, collections, targets
- Example: material:binding relationship

**Metadata:**
- Data about the stage, layers, or prims
- kind, purpose, hidden, active
- Documentation and custom metadata

### Layers and Stages
- **Layer** - A single USD file containing opinions
- **Stage** - The composed result of all layers
- **Root layer** - Entry point for stage composition
- **Session layer** - Non-persistent overrides

**[📖 OpenUSD Documentation](https://openusd.org/release/index.html)** - Core concepts

### USD Schemas
- **IsA schemas** - Define prim types (Mesh, Camera, Light)
- **API schemas** - Add capabilities to prims (CollectionAPI, PhysicsAPI)
- **Applied schemas** - Explicitly applied to prims
- **Non-applied schemas** - Implicitly available

## Domain 2: Scene Composition

### LIVRPS Composition Order

Opinions are resolved in this order (strongest to weakest):

1. **L - Local opinions** (directly authored on the stage)
2. **I - Inherits** (class-based inheritance)
3. **V - Variants** (switchable configurations)
4. **R - References** (scene referencing)
5. **P - Payloads** (deferred loading references)
6. **S - Sublayers** (layer stacking)

### Composition Arcs

**Sublayers:**
- Stack multiple layers on a stage
- Later sublayers have stronger opinions
- Used for department-based workflows (modeling, animation, lighting)

**References:**
- Include a prim tree from another layer
- Can target a specific prim path in the referenced layer
- Loaded immediately when stage is opened

**Payloads:**
- Like references but can be deferred (unloaded)
- Used for heavy assets (geometry, textures)
- Reduces initial load time for large scenes
- User controls which payloads to load

**Variants:**
- Switchable configurations on a prim
- Variant sets contain named variants
- Example: material variants (wood, metal, glass)
- Example: LOD variants (high, medium, low)

**Inherits:**
- Class-based inheritance
- Changes to class propagate to all inheriting prims
- Used for shared properties across many instances

**Specializes:**
- Like inherits but weaker than local opinions
- Base class provides defaults that can be overridden
- Less commonly used than inherits

**[📖 USD Composition](https://openusd.org/release/glossary.html)** - Composition reference

## Domain 3: NVIDIA Omniverse

### Platform Architecture
- **Nucleus** - Central collaboration and data server
- **Kit** - Application development framework
- **Connectors** - DCC tool integration (Maya, 3ds Max, Blender, etc.)
- **Extensions** - Modular functionality for Kit apps
- **RTX Renderer** - Real-time ray tracing
- **[📖 Omniverse Documentation](https://docs.omniverse.nvidia.com/)**

### Nucleus Server
- Central storage for USD assets
- Real-time collaboration (live sync)
- Version control for 3D assets
- Access control and permissions
- Checkpoint system for snapshots

### Connectors
- Bi-directional sync between DCC tools and Omniverse
- Maya Connector, 3ds Max Connector, Blender Connector
- CAD connectors (Revit, SolidWorks)
- Live sync for real-time collaboration

### Kit-Based Applications
- Omniverse USD Composer (scene composition)
- Omniverse Code (development)
- Custom applications via Kit SDK
- Extension-based architecture

## Domain 4: Rendering and Materials

### MDL (Material Definition Language)
- NVIDIA's physically-based material definition
- Procedural and texture-based materials
- Rich library of pre-built materials
- Cross-renderer compatibility
- **[📖 MDL SDK](https://developer.nvidia.com/mdl-sdk)** - Material language

### USD Preview Surface
- Standard USD material for interchange
- Basic PBR (physically-based rendering)
- Diffuse color, metallic, roughness, normal, opacity
- Supported by all USD-compatible renderers

### Hydra Rendering Architecture
- USD's render delegation framework
- Separates scene description from rendering
- Multiple render delegates (Storm, RTX, HdPrman)
- **Storm** - OpenGL/Vulkan real-time viewport
- **RTX** - NVIDIA ray tracing renderer
- **HdPrman** - Pixar's RenderMan delegate

### RTX Rendering in Omniverse
- Real-time ray tracing and path tracing
- Global illumination and ambient occlusion
- Reflections, refractions, and caustics
- AI denoising for interactive performance
- MDL material support

## Domain 5: Collaboration and Pipelines

### Multi-User Collaboration
- Live sync via Nucleus server
- Multiple users editing the same stage simultaneously
- Layer-based conflict resolution
- Real-time updates across connected clients

### Asset Management
- Nucleus as central asset repository
- Version control with checkpoints
- Asset metadata and search
- Reference resolution across projects

### Pipeline Integration
- USD as interchange format between pipeline stages
- Automated asset publishing and validation
- CI/CD for 3D content pipelines
- Custom schemas for studio-specific data

### Digital Twin Workflows
- Industrial facility modeling
- Real-time simulation and visualization
- Sensor data integration
- Physics simulation integration
- IoT data overlay on 3D scenes

## Exam Tips

### Key Concepts to Master
1. LIVRPS composition ordering (memorize this)
2. USD file formats and their use cases
3. Difference between references and payloads
4. Omniverse architecture components
5. MDL vs USD Preview Surface
6. Hydra rendering architecture
