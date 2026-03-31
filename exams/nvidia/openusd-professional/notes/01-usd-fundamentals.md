# USD Fundamentals

**[📖 OpenUSD Documentation](https://openusd.org/release/index.html)** - Official USD reference

## Core Data Model

### Prims (Primitives)

Prims are the fundamental building blocks of a USD scene:

- Organized in a hierarchical tree (like a filesystem)
- Each prim has a unique path: `/World/Characters/Hero`
- Prims have a type (Mesh, Xform, Camera, Light, etc.)
- Can contain child prims, properties, and metadata
- Root prim is implicitly at `/`

**Common Prim Types:**
- **Xform** - Transform node (translation, rotation, scale)
- **Mesh** - Polygon geometry
- **Camera** - Virtual camera
- **Scope** - Grouping node (no transform)
- **Material** - Shading material definition
- **Light types** - DistantLight, SphereLight, RectLight, DomeLight

### Properties

**Attributes:**
- Typed data values attached to prims
- Can be time-sampled for animation
- Examples: `points`, `normals`, `faceVertexCounts`, `visibility`
- Custom attributes with namespace prefixes

**Relationships:**
- Named connections between prims
- Used for material bindings, target references
- Example: `material:binding` links mesh to material
- Can be time-varying

### Metadata

Key-value data on prims, properties, or layers:

- **kind** - Classification (component, assembly, group, subcomponent)
- **purpose** - Rendering purpose (default, render, proxy, guide)
- **active** - Whether prim is active (true/false)
- **hidden** - UI visibility hint
- **documentation** - Human-readable description

### USD Python API

```python
from pxr import Usd, UsdGeom, Gf

# Create a new stage
stage = Usd.Stage.CreateNew('scene.usda')

# Define a prim
xform = UsdGeom.Xform.Define(stage, '/World')

# Create a mesh
mesh = UsdGeom.Mesh.Define(stage, '/World/Cube')
mesh.CreatePointsAttr([
    Gf.Vec3f(-1, -1, -1), Gf.Vec3f(1, -1, -1),
    # ... more vertices
])

# Set transform
xform.AddTranslateOp().Set(Gf.Vec3d(0, 0, 0))
xform.AddRotateXYZOp().Set(Gf.Vec3f(0, 45, 0))
xform.AddScaleOp().Set(Gf.Vec3f(1, 1, 1))

# Save
stage.GetRootLayer().Save()
```

**[📖 USD Python API](https://openusd.org/release/api/index.html)** - Programming reference

## File Formats

### .usda (ASCII)
- Human-readable text format
- Editable with any text editor
- Larger file size
- Useful for debugging and learning
- Version control friendly (text diffs)

```usda
#usda 1.0

def Xform "World"
{
    def Mesh "Cube"
    {
        float3[] points = [(-1, -1, -1), (1, -1, -1), ...]
        int[] faceVertexCounts = [4, 4, 4, 4, 4, 4]
        int[] faceVertexIndices = [0, 1, 3, 2, ...]
    }
}
```

### .usdc (Crate Binary)
- Compact binary format
- Fast loading (memory-mapped)
- Smaller file size than .usda
- Preferred for production assets
- Not human-readable

### .usdz (Package)
- ZIP archive containing USD files and assets
- Self-contained (includes textures, materials)
- Used for distribution and sharing
- Apple AR Quick Look support
- Read-only format

### .usd (Generic)
- Can be either .usda or .usdc
- USD detects format automatically
- Convention for files that may change format
- Recommended for references (format-agnostic)

## Schema System

### Typed Schemas (IsA)

Define what a prim "is":
- Each prim can have exactly one typed schema
- Provides built-in properties and behavior
- Inheritance hierarchy (UsdGeomMesh inherits from UsdGeomGprim)
- Applied via `Define()` or type name in USD file

**Geometry schemas:** UsdGeomMesh, UsdGeomCurves, UsdGeomPoints, UsdGeomXform
**Lighting schemas:** UsdLuxDistantLight, UsdLuxSphereLight, UsdLuxRectLight
**Shading schemas:** UsdShadeMaterial, UsdShadeShader

### API Schemas (HasA)

Add capabilities to prims:
- Multiple API schemas can be applied to one prim
- Do not define the prim type
- Two categories:
  - **Applied** - Explicitly applied, stored in scene (MaterialBindingAPI)
  - **Non-Applied** - Utility interfaces, not stored (UsdGeomModelAPI)

**Common API schemas:**
- UsdShadeMaterialBindingAPI - Bind materials to geometry
- UsdGeomModelAPI - Model hierarchy metadata
- UsdCollectionAPI - Define collections of prims
- UsdPhysicsRigidBodyAPI - Physics simulation properties

## Scene Hierarchy Patterns

### Kind Hierarchy
- **model** - Base kind for all models
- **assembly** - Group of components (a car)
- **component** - Leaf model (a wheel)
- **group** - Organizational grouping
- **subcomponent** - Part of a component

### Purpose
- **default** - Always visible
- **render** - High-quality geometry for final rendering
- **proxy** - Simplified geometry for viewport display
- **guide** - Helper geometry (not rendered)

## Key Exam Concepts

- Prim hierarchy and path syntax
- Attribute vs relationship properties
- File formats: .usda (text), .usdc (binary), .usdz (package)
- Typed schemas (IsA) vs API schemas (HasA)
- Kind hierarchy for asset classification
- Purpose values for rendering optimization
- USD Python API basics
