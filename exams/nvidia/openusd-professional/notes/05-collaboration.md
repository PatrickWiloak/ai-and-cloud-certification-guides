# Collaboration and Pipeline Integration

**[📖 Nucleus Collaboration](https://docs.omniverse.nvidia.com/nucleus/)** - Collaboration workflows

## Multi-User Collaboration

### Live Collaboration Model

**Layer-Based Collaboration:**
- Each user works in their own "live layer"
- Changes are isolated per user until merged
- Real-time visibility of other users' changes
- No destructive conflicts between users
- Nucleus handles synchronization

**Workflow:**
1. User opens scene from Nucleus
2. User's edits go to their live layer (strongest)
3. Other users see edits in real-time
4. Changes can be committed to shared layers
5. Layer locks prevent conflicting edits

### Conflict Resolution
- Layer strength order determines which opinion wins
- Higher layers override lower layers
- Users can negotiate through communication
- Layer locks for exclusive access to specific assets
- Merge tools for combining parallel edits

### Session Management
- Track active users in a session
- User presence indicators in viewport
- Chat and annotation tools
- Session history and activity log

## Version Control

### Nucleus Checkpoints
- Point-in-time snapshots of files
- Created manually or automatically
- Can restore any previous checkpoint
- Named checkpoints for milestones
- Lightweight (delta-based storage)

### Branching
- Create branches for experimental changes
- Work in isolation without affecting main
- Merge branches when changes are validated
- Similar to git branching concept

### Asset Versioning Patterns
- Semantic versioning for published assets
- Checkpoint-based history for work in progress
- Reference pinning to specific versions
- Dependency tracking for asset chains

## Pipeline Integration

### USD Pipeline Architecture

**Asset Pipeline:**
1. **Modeling** - Create geometry in DCC (exported as USD)
2. **Surfacing** - Apply materials and textures
3. **Rigging** - Add skeleton and controls
4. **Animation** - Animate characters and objects
5. **Layout** - Arrange assets in scene
6. **Lighting** - Add lights and environment
7. **Rendering** - Final image generation

**Layer Organization:**
```
scene.usd (root)
  sublayers:
    - lighting.usd    (strongest)
    - animation.usd
    - layout.usd
    - surfacing.usd
    - model.usd       (weakest)
```

### DCC Tool Integration

**Maya Workflow:**
- Maya Connector installed as plugin
- Export scene as USD via connector
- Live sync for real-time updates
- Material translation (Maya to USD/MDL)

**Blender Workflow:**
- Built-in USD support in Blender
- Omniverse connector for live sync
- Import/export with material translation

**Houdini Workflow:**
- Native USD support (Solaris)
- LOPs (Layout Operators) for USD scene graph
- Karma renderer as Hydra delegate
- Strong procedural USD generation

### Asset Resolution

**ArResolver:**
- USD's asset path resolution system
- Maps logical paths to physical locations
- Custom resolvers for studio pipelines
- Nucleus resolver for Omniverse paths

**Path Patterns:**
- Relative paths: `./assets/chair.usd`
- Omniverse paths: `omniverse://server/project/scene.usd`
- Custom resolver paths: `asset:chair:v2`

## Performance Optimization

### Scene Optimization Techniques

**Payload Management:**
- Use payloads for heavy assets
- Load only visible/needed payloads
- Unload distant or off-screen assets
- Set load rules per camera view

**Level of Detail (LOD):**
- VariantSets for LOD switching
- Purpose-based geometry (render, proxy, guide)
- Distance-based LOD selection
- Proxy geometry for viewport performance

**Instancing:**
- Point instancer for large numbers of copies (forests, crowds)
- Native USD instancing for repeated assets
- Significant memory savings for duplicated objects
- Scenegraph instancing vs point instancing

**Asset Structure:**
- Keep assets lightweight and modular
- Use references for reusable components
- Minimize prim count where possible
- Efficient texture resolution and format

### Performance Metrics
- Scene load time
- Viewport frame rate
- Memory usage (GPU and system)
- File size on disk
- Network transfer time for collaboration

## Industry Workflows

### Architecture, Engineering, Construction (AEC)
- BIM to USD conversion via Revit connector
- Large-scale architectural visualization
- Construction planning and simulation
- Digital twin of buildings and infrastructure

### Manufacturing
- CAD to USD conversion (SolidWorks, Creo)
- Factory layout and simulation
- Product configuration visualization
- Digital twin of production lines

### Film and Visual Effects
- Scene assembly from multiple departments
- Multi-shot composition
- Look development and lighting
- Final rendering with Hydra delegates

### Robotics and Simulation
- Isaac Sim for robot simulation
- Synthetic data generation
- Physics-accurate environments
- Sensor simulation (camera, lidar)

## Key Exam Concepts

- Live layer collaboration model
- Nucleus checkpoints and branching
- Pipeline layer organization and department workflow
- ArResolver for asset path resolution
- Performance optimization: payloads, LOD, instancing
- Industry-specific USD workflows
