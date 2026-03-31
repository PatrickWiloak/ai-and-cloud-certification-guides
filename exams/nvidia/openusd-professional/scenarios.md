# NCP-USD High-Yield Scenarios and Practice Problems

## Scenario 1: Composition Strength

**Scenario**: A prim `/World/Chair` has a reference to `chair.usd` which sets `color = blue`. The current layer has a local opinion setting `color = red`. A variant set "finish" with selection "matte" sets `color = green`. What color is the chair?

**Solution**: **Red** (local opinion wins)

**Reasoning**: LIVRPS order is Local > Inherits > Variants > References > Payloads > Sublayers. Local opinions are the strongest, so the local `color = red` overrides both the variant (green) and the reference (blue).

**Key Takeaway**: Always remember LIVRPS. Local opinions always win regardless of what references or variants specify.

---

## Scenario 2: References vs Payloads

**Scenario**: A film production has a city scene with 500 buildings. Each building has detailed interior geometry (2GB per building). The scene takes 30 minutes to load. How should the scene be restructured for better performance?

**Solution Pattern**:
- **Convert building references to payloads**
- Open stage with `Usd.Stage.LoadNone` for fast initial load
- Load payloads selectively based on camera position
- Only detailed buildings near camera are loaded
- Distant buildings use proxy geometry (purpose = "proxy")

**Common Distractors**:
- Reduce polygon count for all buildings - loses detail
- Use smaller texture resolutions - does not address geometry memory
- Put all buildings in one file - does not enable selective loading
- Remove interior geometry entirely - loses asset completeness

**Key Takeaway**: Payloads are essential for large scenes. They enable selective loading to manage memory and load times.

---

## Scenario 3: VariantSet Design

**Scenario**: A furniture manufacturer has a chair model that comes in 3 materials (wood, metal, fabric), 2 sizes (regular, large), and 4 colors. How should variant sets be organized?

**Solution Pattern**:
- Create three independent variant sets on the chair prim:
  - `material` variant set: wood, metal, fabric
  - `size` variant set: regular, large
  - `color` variant set: red, blue, green, black
- Each variant set is independent - any combination is valid
- Total combinations: 3 x 2 x 4 = 24 configurations
- Selection of one variant set does not affect others

**Common Distractors**:
- Create 24 separate variant combinations - combinatorial explosion, unmaintainable
- Use references instead of variants - cannot switch interactively
- Nest variant sets hierarchically - unnecessarily complex for independent options
- Create 24 separate USD files - loses the non-destructive switching benefit

**Key Takeaway**: Use multiple independent variant sets for orthogonal options. USD handles all combinations automatically.

---

## Scenario 4: Department Workflow

**Scenario**: A VFX studio has modeling, rigging, animation, and lighting departments all working on the same shot. How should the USD scene be structured for parallel work?

**Solution Pattern**:
- **Root layer** (shot.usd) references the asset and sublayers department layers:
  ```
  shot.usd (root)
    sublayers:
      - lighting.usd    (strongest department layer)
      - fx.usd
      - animation.usd
      - layout.usd
      - model.usd       (weakest department layer)
  ```
- Each department works in their own layer file
- Stronger layers (lighting) can override weaker layers (model)
- Non-destructive: removing a layer removes only that department's contributions
- Parallel work without file conflicts

**Common Distractors**:
- Everyone edits the same file - causes conflicts and overwrites
- Separate scenes merged at the end - loses real-time visibility
- Only one department works at a time - sequential, slow
- Copy the scene for each department - version control nightmare

**Key Takeaway**: USD sublayer stacking enables parallel department workflows. Each department owns their layer.

---

## Scenario 5: Omniverse Collaboration

**Scenario**: An architecture firm has designers in New York and Tokyo working on the same building model simultaneously. They use Maya in NY and Revit in Tokyo. How should collaboration be set up?

**Solution Pattern**:
- Deploy **Nucleus Enterprise** server accessible to both offices
- NY team uses **Maya Connector** with live sync to Nucleus
- Tokyo team uses **Revit Connector** with live sync to Nucleus
- Both teams work on the same USD scene via Nucleus
- Each user's edits go to their own live layer
- Changes are visible in real-time to all connected users
- Connectors handle Maya/Revit to USD material and geometry translation

**Common Distractors**:
- Email files back and forth - slow, no real-time collaboration
- Use only Maya everywhere - Revit is needed for architectural data
- Local file sharing (SMB) - no real-time sync, conflict risk
- Separate Nucleus servers per office - no unified collaboration

**Key Takeaway**: Nucleus enables real-time multi-tool, multi-site collaboration through connectors and live layers.

---

## Scenario 6: Performance Optimization

**Scenario**: A USD scene with a forest of 100,000 trees runs at 2 FPS in the viewport. Each tree is a separate referenced asset with 50,000 polygons. How should performance be improved?

**Solution Pattern**:
- **Use UsdGeomPointInstancer** for the forest
- Define a few tree prototype prims (5-10 variations)
- PointInstancer places instances with per-point transforms
- 100,000 instances share geometry from a few prototypes
- Massive memory savings vs 100,000 separate references
- Additional: LOD variants for distant trees (fewer polygons)
- Use purpose = "proxy" for simplified viewport geometry

**Common Distractors**:
- Reduce tree polygon count only - helps but instancing is the primary fix
- Load fewer trees - loses the forest
- Use payloads for each tree - 100,000 payloads still slow to manage
- Switch to wireframe rendering - hides the problem

**Key Takeaway**: PointInstancer is essential for large numbers of repeated objects (vegetation, crowds, particles).

---

## Scenario 7: Material Assignment

**Scenario**: A scene has 50 objects that should all share the same red material. If the material color changes to blue, all 50 objects should update automatically. How should this be implemented?

**Solution Pattern**:
- Define the material once: `/Materials/SharedRed`
- Bind all 50 objects to the same material path using MaterialBindingAPI
- To change color: edit the material's diffuseColor attribute once
- All bound objects automatically reflect the change
- Can also use inherits if objects need default material from a class

**Common Distractors**:
- Copy the material to each object - changing color requires 50 edits
- Use a variant for color - variants are per-prim, not per-material
- Set color as an attribute on each object - duplicates data
- Create a script to update all objects - unnecessary when binding is used

**Key Takeaway**: Material binding allows many objects to share one material definition. Changes to the material automatically propagate.
