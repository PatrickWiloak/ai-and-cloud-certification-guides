# Omniverse Platform

**[📖 Omniverse Documentation](https://docs.omniverse.nvidia.com/)** - Platform reference

## Omniverse Architecture

### Core Components

**Nucleus:**
- Central server for asset storage and collaboration
- Real-time file synchronization
- Version control with checkpoints
- Access control and permissions
- Pub/sub for live updates between clients
- **[📖 Nucleus Docs](https://docs.omniverse.nvidia.com/nucleus/)**

**Kit SDK:**
- Application development framework
- Extension-based modular architecture
- Python and C++ APIs
- Built-in viewport, UI, and rendering
- Foundation for all Omniverse applications
- **[📖 Kit SDK Docs](https://docs.omniverse.nvidia.com/kit/)**

**Connectors:**
- Bridge plugins for third-party DCC tools
- Maya Connector, Blender Connector, 3ds Max Connector
- Revit, SketchUp, Rhino connectors (AEC)
- SolidWorks, Creo connectors (manufacturing)
- Live sync for real-time collaboration

**RTX Renderer:**
- Real-time ray tracing engine
- Path tracing for photorealistic rendering
- GPU-accelerated with NVIDIA RTX GPUs
- Global illumination, reflections, shadows
- Physically-based rendering pipeline

## Nucleus Server

### Architecture
- **Database** - Stores file metadata and versions
- **Storage** - Stores file content (local or cloud)
- **Auth** - Authentication and authorization
- **Discovery** - Service discovery for clients
- **Pub/Sub** - Real-time change notifications

### File Operations
- Create, read, update, delete files and folders
- Atomic write operations for consistency
- File locking for exclusive access
- Checkpoint creation for version snapshots
- Branching for experimental changes

### Collaboration Model
- Multiple users can work on the same scene simultaneously
- Each user edits in their own layer (live layer)
- Changes propagate in real-time via pub/sub
- Conflict resolution through layer strength ordering
- Layer locking prevents simultaneous edits to same layer

### Access Control
- User and group management
- Per-folder permissions (read, write, admin)
- ACL-based access control
- Integration with enterprise identity providers (LDAP, SAML)
- Audit logging for compliance

### Deployment Options
- **Nucleus Cloud** - SaaS offering, managed by NVIDIA
- **Enterprise Nucleus** - Self-hosted on-premises or in cloud
- **Local Nucleus** - Single-user development server
- Docker-based deployment for enterprise

## Connectors

### How Connectors Work
1. User opens DCC tool with connector installed
2. Connector authenticates with Nucleus
3. User opens USD file from Nucleus
4. Edits in DCC tool are synced to Nucleus
5. Other users see changes in real-time
6. Materials and textures translated between formats

### Key Connector Features
- **Live Sync** - Real-time bidirectional updates
- **Material Translation** - Convert DCC materials to USD/MDL
- **Geometry Export** - Convert native geometry to USD meshes
- **Animation Export** - Time-sampled transform and blend shapes
- **Camera/Light Export** - Convert to USD light and camera types

### Supported Tools
- **Film/VFX:** Maya, Houdini, Blender, 3ds Max
- **AEC:** Revit, SketchUp, Rhino
- **Manufacturing:** SolidWorks, Creo, Siemens NX
- **Visualization:** Unreal Engine

## Kit SDK

### Extension Architecture
- Extensions are the fundamental building blocks
- Each extension provides specific functionality
- Extensions can depend on other extensions
- Hot-reload for rapid development
- Marketplace for sharing extensions

### Key Extensions
- **omni.kit.viewport** - 3D viewport rendering
- **omni.ui** - UI framework for windows and widgets
- **omni.usd** - USD stage management
- **omni.physx** - Physics simulation
- **omni.rtx** - RTX rendering pipeline

### Extension Development

```python
import omni.ext

class MyExtension(omni.ext.IExt):
    def on_startup(self, ext_id):
        print("Extension started")
        # Initialize extension

    def on_shutdown(self):
        print("Extension shutdown")
        # Cleanup
```

### Application Development
- Build custom Omniverse applications with Kit
- Combine extensions for desired functionality
- Deploy as standalone applications
- Customize UI and workflow
- **[📖 Extension Development](https://docs.omniverse.nvidia.com/kit/docs/kit-extension-template/)** - Tutorial

## Omniverse Applications

**USD Composer:**
- Scene layout and composition
- Large scene assembly
- Material assignment
- Rendering and visualization

**USD Presenter:**
- Interactive presentations of USD scenes
- Navigation and annotation
- Sharing and collaboration
- Real-time rendering

**Omniverse Code:**
- Development environment for extensions
- Built-in Python editor
- Live extension reloading
- Debugging tools

## Key Exam Concepts

- Nucleus architecture and collaboration model
- Real-time collaboration through live layers
- Connector workflow for DCC tool integration
- Kit SDK extension architecture
- Access control and version management
- Deployment options (cloud, enterprise, local)
