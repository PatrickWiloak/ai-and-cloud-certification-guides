# USD Fundamentals

**[📖 OpenUSD Documentation](https://openusd.org/release/index.html)** - Official USD specification

## USD Data Model

### Prims (Primitives)

Prims are the fundamental building blocks of a USD scene. They form a hierarchical tree structure.

**Prim Types:**
- **Xform** - Transform node (translate, rotate, scale)
- **Mesh** - Polygon mesh geometry
- **Camera** - Virtual camera
- **Light** - Light sources (distant, sphere, rect, dome)
- **Material** - Surface material definition
- **Scope** - Organizational grouping (no transform)
- **Shader** - Shader node within a material

**Prim Paths:**
- Absolute: `/World/Character/Body`
- Root prim: `/`
- Hierarchical namespace with `/` separator
- Must be unique within a stage

**Prim Specifiers:**
- **def** - Defines a concrete prim (most common)
- **over** - Override opinions on an existing prim
- **class** - Abstract class prim (not rendered, used for inheritance)

### Attributes

**Properties:**
- Named, typed data values on prims
- Can be time-varying (animated)
- Have a type (float, double, int, string, vector, matrix, etc.)
- Common: `xformOp:translate`, `points`, `normals`, `faceVertexCounts`

**Time Samples:**
```python
# Set default value
attr.Set(value)

# Set time-sampled value
attr.Set(value, time=1.0)
attr.Set(value, time=2.0)
```

**Interpolation:**
- Default value used when no time samples exist
- Linear interpolation between time samples
- Held interpolation for discrete values

### Relationships

- Named connections between prims
- Target one or more prim paths
- Common uses:
  - `material:binding` - bind material to geometry
  - Collection membership
  - Light linking

### Metadata

**Stage Metadata:**
- `defaultPrim` - entry point for references
- `upAxis` - Y or Z up orientation
- `metersPerUnit` - scene scale
- `framesPerSecond` - animation frame rate

**Prim Metadata:**
- `kind` - assembly, group, component, subcomponent
- `purpose` - default, render, proxy, guide
- `active` - whether prim is included in stage
- `hidden` - visibility hint for UI
- `documentation` - human-readable description

## File Formats

### .usda (ASCII)
```
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Y"
)

def Xform "World"
{
    def Mesh "Cube"
    {
        float3[] points = [(-1,-1,-1), (1,-1,-1), (1,1,-1), ...]
        int[] faceVertexCounts = [4, 4, 4, 4, 4, 4]
        int[] faceVertexIndices = [0, 1, 2, 3, ...]
    }
}
```
- Human-readable text format
- Good for debugging and version control
- Larger file size than binary
- Slower to load than .usdc

### .usdc (Crate Binary)
- Binary format optimized for fast loading
- Smaller file size than .usda
- Memory-mapped file access
- Random access to data within file
- Preferred for production assets

### .usdz (Package)
- Zip archive containing .usdc and textures
- Self-contained for distribution
- Used by Apple AR Quick Look
- Single file for asset delivery
- Read-only (cannot be edited in place)

## USD API Basics

### Python API

```python
from pxr import Usd, UsdGeom, Sdf, Gf

# Create a new stage
stage = Usd.Stage.CreateNew('scene.usda')

# Set stage metadata
stage.SetDefaultPrim(stage.DefinePrim('/World'))
UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.y)

# Create a prim
xform = UsdGeom.Xform.Define(stage, '/World/Object')

# Set transform
xform.AddTranslateOp().Set(Gf.Vec3d(1.0, 2.0, 3.0))

# Create a mesh
mesh = UsdGeom.Mesh.Define(stage, '/World/Object/Mesh')
mesh.GetPointsAttr().Set([(0,0,0), (1,0,0), (1,1,0)])

# Save
stage.GetRootLayer().Save()
```

### Common API Patterns

```python
# Open existing stage
stage = Usd.Stage.Open('scene.usda')

# Traverse all prims
for prim in stage.Traverse():
    print(prim.GetPath())

# Get specific prim
prim = stage.GetPrimAtPath('/World/Object')

# Check prim type
if prim.IsA(UsdGeom.Mesh):
    mesh = UsdGeom.Mesh(prim)

# Get attribute value
points = mesh.GetPointsAttr().Get()

# Set attribute with time sample
mesh.GetPointsAttr().Set(new_points, Usd.TimeCode(1.0))
```

**[📖 USD API Reference](https://openusd.org/release/api/index.html)** - Complete API documentation

## Schemas

### IsA Schemas
- Define prim types through inheritance
- Provide typed API for prims
- Examples: UsdGeomMesh, UsdLuxDistantLight, UsdShadeMaterial
- A prim can only have one IsA schema type

### API Schemas
- Add functionality to any prim type
- Can be applied to existing prims
- Examples: UsdGeom.CollectionAPI, UsdPhysicsRigidBodyAPI
- A prim can have multiple API schemas

### Applied vs Non-Applied
- **Applied** - Explicitly applied to prims (stored in layer)
- **Non-Applied** - Available on all prims of compatible type
- Applied schemas listed in prim's `apiSchemas` metadata

## Key Exam Concepts

- Prim types: Xform, Mesh, Camera, Light, Material, Scope
- Prim specifiers: def, over, class
- File formats: .usda (text), .usdc (binary), .usdz (package)
- Attribute time sampling and interpolation
- Stage metadata: defaultPrim, upAxis, metersPerUnit
- Prim metadata: kind, purpose, active
- IsA schemas vs API schemas
