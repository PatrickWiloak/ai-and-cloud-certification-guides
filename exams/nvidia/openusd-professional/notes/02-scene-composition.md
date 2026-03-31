# Scene Composition

**[📖 USD Composition](https://openusd.org/release/glossary.html)** - Composition concepts

## Composition Arcs

USD's composition system is its most powerful feature. It allows non-destructive assembly of complex scenes from reusable components.

### LIVRPS Rule (Composition Strength Order)

From strongest to weakest:

1. **L**ocal - Direct opinions on the current layer
2. **I**nherits - Opinions from inherited class prims
3. **V**ariantSets - Opinions from active variant selections
4. **R**eferences - Opinions from referenced USD files/prims
5. **P**ayloads - Opinions from payload USD files (deferred)
6. **S**pecializes - Opinions from specialized base prims

**The strongest opinion wins.** If a local edit sets color=red and a reference sets color=blue, the prim will be red (local is strongest).

## References

### Purpose
- Include external USD assets into a scene
- Reuse assets across multiple scenes
- Override referenced prim properties locally

### Usage

```python
from pxr import Usd, Sdf

stage = Usd.Stage.CreateNew('scene.usda')
prim = stage.DefinePrim('/World/Chair')

# Add reference to external asset
prim.GetReferences().AddReference('./chair.usd', '/ChairRoot')

# Add reference to another prim in same file
prim.GetReferences().AddInternalReference('/Templates/Chair')
```

```usda
def Xform "World"
{
    def "Chair" (
        references = @./chair.usd@</ChairRoot>
    )
    {
        # Local overrides here (stronger than reference)
        color3f[] primvars:displayColor = [(1, 0, 0)]
    }
}
```

### Key Properties
- Always loaded (cannot be deferred)
- Stronger than payloads
- Can reference specific prim paths within a file
- Can have multiple references on one prim (stacked)
- Can be internal (same file) or external (different file)

## Payloads

### Purpose
- Same as references but with deferred loading
- Used for heavy assets (high-poly models, large datasets)
- Can be loaded/unloaded at runtime to manage memory
- Essential for large scene management

### Usage

```python
prim = stage.DefinePrim('/World/HeavyBuilding')
prim.GetPayloads().AddPayload('./building_detailed.usd')
```

```usda
def "HeavyBuilding" (
    payload = @./building_detailed.usd@
)
{
}
```

### Load Rules
- `Usd.Stage.Load` - Load all payloads
- `Usd.Stage.LoadNone` - Load no payloads (just structure)
- Per-prim load/unload control
- Load rules persist across session

### References vs Payloads

| Feature | References | Payloads |
|---------|-----------|----------|
| Loading | Always loaded | Can be deferred |
| Strength | Stronger | Weaker |
| Use case | Critical assets | Heavy/optional assets |
| Memory | Always in memory | Loadable on demand |

## VariantSets

### Purpose
- Define switchable variations on a prim
- Non-destructive option switching
- Common uses: LODs, color options, configurations

### Usage

```python
prim = stage.DefinePrim('/World/Car')
vset = prim.GetVariantSets().AddVariantSet('color')

vset.AddVariant('red')
vset.SetVariantSelection('red')
with vset.GetVariantEditContext():
    prim.GetAttribute('color').Set((1, 0, 0))

vset.AddVariant('blue')
vset.SetVariantSelection('blue')
with vset.GetVariantEditContext():
    prim.GetAttribute('color').Set((0, 0, 1))

# Set active variant
vset.SetVariantSelection('red')
```

```usda
def "Car" (
    variants = {
        string color = "red"
    }
    prepend variantSets = "color"
)
{
    variantSet "color" = {
        "red" {
            color3f[] primvars:displayColor = [(1, 0, 0)]
        }
        "blue" {
            color3f[] primvars:displayColor = [(0, 0, 1)]
        }
    }
}
```

### Common Variant Patterns
- **LOD variants** - Level of detail switching
- **Material variants** - Different material options
- **Configuration variants** - Product configurations
- **Platform variants** - OS-specific assets

## Inherits

### Purpose
- Share common properties across many prims
- Changes to the "class" prim propagate to all inheritors
- Like object-oriented inheritance

### Usage

```python
# Define class prim
class_prim = stage.CreateClassPrim('/TreeClass')
UsdGeom.Xform.Define(stage, '/TreeClass')
# Set default properties on class

# Create instance that inherits
tree = stage.DefinePrim('/World/Tree1')
tree.GetInherits().AddInherit('/TreeClass')
```

```usda
class "TreeClass"
{
    float height = 10.0
    color3f color = (0, 0.5, 0)
}

def "World"
{
    def "Tree1" (
        inherits = </TreeClass>
    )
    {
        # Overrides or additional properties
    }
}
```

### Key Properties
- Stronger than variants and references
- Class prims are not rendered directly
- Changes to class affect all inheriting prims
- Useful for shared defaults

## Specializes

### Purpose
- Similar to inherits but weakest composition arc
- Used as a "base class" that everything can override
- Rarely used but important to understand for LIVRPS

### Key Difference from Inherits
- Specializes is the weakest arc (S in LIVRPS)
- Inherits is stronger than variants and references
- Specializes opinions lose to all other arcs
- Used when you want a base that is easily overridden

## Layer Stacking

### Sub-Layers
- Multiple layers compose to form the stage
- Root layer is strongest
- Sub-layers are weaker in listed order
- Each layer can contain independent edits

```python
# Add sub-layers
root_layer = stage.GetRootLayer()
root_layer.subLayerPaths.append('./animation.usd')
root_layer.subLayerPaths.append('./layout.usd')
root_layer.subLayerPaths.append('./model.usd')
# animation is stronger than layout, layout stronger than model
```

### Non-Destructive Editing
- Each department/artist works in their own layer
- Animation in one layer, lighting in another
- Layout changes do not affect model layer
- Layers can be added/removed without affecting others
- Enables parallel workflow

## Key Exam Concepts

- LIVRPS composition order (memorize the mnemonic)
- References vs Payloads (loading behavior and strength)
- VariantSets for switchable options
- Inherits vs Specializes (strength difference)
- Layer stacking order and sub-layer strength
- Non-destructive editing through layer separation
- Python API for composition arcs
