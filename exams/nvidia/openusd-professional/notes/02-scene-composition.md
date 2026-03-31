# Scene Composition

**[📖 USD Composition](https://openusd.org/release/glossary.html)** - Composition arc reference

## LIVRPS Composition Ordering

USD resolves conflicting opinions using a strict ordering called LIVRPS (strongest to weakest):

1. **L - Local** - Opinions directly authored in the current layer
2. **I - Inherits** - Opinions from inherited class prims
3. **V - Variants** - Opinions from selected variants
4. **R - References** - Opinions from referenced layers/prims
5. **P - Payloads** - Opinions from payload layers (deferred references)
6. **S - Sublayers** - Opinions from sublayer stack

**Key Rule:** Stronger opinions always win. Local opinions override everything else.

**[📖 LIVRPS Reference](https://openusd.org/release/glossary.html#livrps-strength-ordering)** - Composition strength

## Composition Arcs

### Sublayers

**Purpose:** Stack multiple layers to compose a single stage

```python
# usda syntax
(
    subLayers = [
        @./lighting.usda@,
        @./animation.usda@,
        @./modeling.usda@
    ]
)
```

**Characteristics:**
- Opinions in stronger (earlier) sublayers override weaker ones
- All sublayers share the same namespace
- Used for department-based workflows
- Common pattern: base layer + department overrides

**Department Workflow Example:**
- modeling.usda - geometry and topology
- rigging.usda - skeleton and skin bindings
- animation.usda - keyframe data
- lighting.usda - lights and render settings
- layout.usda - scene assembly (root layer, references others)

### References

**Purpose:** Include prim hierarchies from other files

```python
# Python API
prim.GetReferences().AddReference('./character.usda', '/Character')

# usda syntax
def Xform "Hero" (
    references = @./character.usda@</Character>
)
{
}
```

**Characteristics:**
- Loaded immediately when stage opens
- Can target a specific prim in the referenced file
- Multiple references can be stacked on one prim
- Opinions in the referencing layer override the referenced content
- Used for asset assembly

### Payloads

**Purpose:** Deferred-loading references for heavy content

```python
# Python API
prim.GetPayloads().AddPayload('./heavy_geometry.usda')

# usda syntax
def Xform "Building" (
    payload = @./building_geometry.usda@
)
{
}
```

**Characteristics:**
- Can be loaded or unloaded at runtime
- Reduces initial scene load time
- Used for heavy geometry, large environments
- Stage can control which payloads are active
- Weaker than references in composition strength

**Loading Control:**
```python
# Load specific payloads
stage = Usd.Stage.Open('scene.usda', Usd.Stage.LoadNone)
stage.Load('/World/Building')  # Load this payload

# Load all
stage = Usd.Stage.Open('scene.usda', Usd.Stage.LoadAll)
```

### Variants

**Purpose:** Switchable configurations for prims

```python
# usda syntax
def Xform "Chair" (
    variants = {
        string material = "wood"
    }
    prepend variantSets = "material"
)
{
    variantSet "material" = {
        "wood" {
            # wood material binding
        }
        "metal" {
            # metal material binding
        }
        "plastic" {
            # plastic material binding
        }
    }
}
```

**Python API:**
```python
# Create variant set
vset = prim.GetVariantSets().AddVariantSet('material')
vset.AddVariant('wood')
vset.AddVariant('metal')

# Set active variant
vset.SetVariantSelection('wood')

# Author within variant
with vset.GetVariantEditContext():
    # Opinions here go into the 'wood' variant
    prim.GetAttribute('color').Set(...)
```

**Use Cases:**
- Material variants (different surface finishes)
- LOD variants (high, medium, low detail)
- Configuration variants (open/closed door)
- Season variants (summer/winter foliage)

### Inherits

**Purpose:** Class-based inheritance for shared properties

```python
# usda syntax
class "_CharacterBase"
{
    float height = 1.8
    string team = "default"
}

def Xform "Soldier" (
    inherits = </_CharacterBase>
)
{
    # Inherits height and team from _CharacterBase
    # Can override locally
    string team = "alpha"
}
```

**Characteristics:**
- Changes to the class propagate to all inheriting prims
- Local opinions on the inheriting prim override class opinions
- Class prims (class specifier) are not rendered
- Stronger than variants, references, payloads, sublayers
- Used for shared defaults across many instances

### Specializes

**Purpose:** Like inherits but with weaker strength

- Base provides defaults
- Local opinions override specialized opinions
- Specialized opinions override base
- Less commonly used than inherits
- Useful when the base should be the "fallback" not the "override"

## Namespace Editing

### Operations
- **Rename** - Change a prim's name
- **Reparent** - Move a prim to a different parent
- **Remove** - Delete a prim
- **Reorder** - Change sibling order

### Layer Flattening
- Collapse all composition into a single layer
- Resolves all LIVRPS opinions into final values
- Useful for export and debugging
- Loses composition structure (non-reversible)

```python
# Flatten stage to a new layer
flat_layer = stage.Flatten()
flat_layer.Export('flattened.usda')
```

## Composition Patterns

### Asset Structure
```
/AssetRoot (default prim)
  /Geometry
    /Mesh
  /Materials
    /BaseMaterial
  /Skeleton (if rigged)
```

### Scene Assembly
- Root layer references assets
- Layout layer positions assets in world
- Department layers add animation, lighting, effects
- Variant selections choose configurations

### Performance Considerations
- Use payloads for heavy geometry
- Reference lightweight proxy geometry for layout
- Load only needed payloads during editing
- Flatten only when composition overhead is a bottleneck

## Key Exam Concepts

- LIVRPS ordering (memorize: Local, Inherits, Variants, References, Payloads, Sublayers)
- References vs Payloads (immediate vs deferred loading)
- Variant sets and variant selection
- Inherits vs Specializes (strength difference)
- Sublayer stacking for department workflows
- Payload loading control (LoadAll, LoadNone, selective)
