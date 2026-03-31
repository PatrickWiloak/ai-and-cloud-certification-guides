# NVIDIA Omniverse

**[📖 Omniverse Documentation](https://docs.omniverse.nvidia.com/)** - Complete platform reference

## Platform Architecture

### Core Components

**Nucleus:**
- Central collaboration and data server
- Real-time file synchronization
- Version control (checkpoints)
- Access control and permissions
- USD live layer support for multi-user editing
- **[📖 Nucleus Documentation](https://docs.omniverse.nvidia.com/nucleus/)**

**Kit:**
- Application development framework
- Extension-based modular architecture
- Python and C++ APIs
- UI framework for building custom tools
- Base for Omniverse applications (Composer, Code)

**Connectors:**
- Bi-directional bridges between DCC tools and Omniverse
- Live sync for real-time collaboration
- Export/import for batch workflows
- Available for Maya, 3ds Max, Blender, Revit, SolidWorks, etc.

**RTX Renderer:**
- Real-time ray tracing and path tracing
- NVIDIA RTX GPU acceleration
- MDL material support
- AI denoising for interactive quality
- Multi-GPU rendering support

### Omniverse Applications

**USD Composer:**
- Scene composition and layout
- Large-scale environment assembly
- Physics simulation
- Material editing and assignment
- Rendering and visualization

**Code:**
- Developer-focused application
- Extension development and testing
- Script editor and debugger
- API exploration

**Isaac Sim:**
- Robotics simulation on Omniverse
- Physics-based robot simulation
- Synthetic data generation
- Reinforcement learning environments

**Drive Sim:**
- Autonomous vehicle simulation
- Sensor simulation (LiDAR, camera, radar)
- Traffic simulation
- Scenario generation

## Nucleus Server

### Collaboration Model
- Shared USD layers via Nucleus storage
- Multiple users can edit simultaneously
- Live layers for real-time sync
- Conflict resolution through USD composition
- Each user's edits go to their own layer

### Storage and Access
- REST API for file operations
- Omniverse Client Library for programmatic access
- Web-based administration interface
- LDAP/Active Directory integration for authentication
- Role-based access control (read, write, admin)

### Checkpoints
- Point-in-time snapshots of files
- Non-destructive - do not duplicate unchanged data
- Rollback to any checkpoint
- Compare checkpoints for changes
- Automatic checkpoint on save (configurable)

### Deployment Options
- On-premises server
- Cloud deployment (AWS, Azure, GCP)
- NVIDIA Omniverse Cloud
- Enterprise configurations with HA

## Connectors

### Workflow Modes

**Live Sync:**
- Real-time bi-directional connection
- Changes in DCC tool appear in Omniverse instantly
- Changes in Omniverse appear in DCC tool
- Multiple users in different tools editing the same scene

**Publish/Subscribe:**
- Export from DCC tool to Nucleus
- Import from Nucleus to DCC tool
- Batch processing workflows
- Offline asset preparation

### Supported Applications
- Autodesk Maya
- Autodesk 3ds Max
- Autodesk Revit
- Blender
- SolidWorks
- Unreal Engine
- Adobe Substance
- McNeel Rhino

## Kit-Based Development

### Extensions

**Architecture:**
- Omniverse Kit applications are collections of extensions
- Each extension provides specific functionality
- Extensions can depend on other extensions
- Hot-reloadable during development

**Extension Types:**
- UI extensions (panels, windows, menus)
- Action extensions (tools, operations)
- Service extensions (background processes)
- Schema extensions (custom USD schemas)

### Python API

```python
import omni.ext
import omni.ui as ui

class MyExtension(omni.ext.IExt):
    def on_startup(self, ext_id):
        self._window = ui.Window("My Tool", width=300, height=200)
        with self._window.frame:
            with ui.VStack():
                ui.Label("Hello Omniverse!")
                ui.Button("Click Me", clicked_fn=self._on_click)

    def _on_click(self):
        print("Button clicked!")

    def on_shutdown(self):
        self._window.destroy()
```

### omni.ui Framework
- Declarative UI framework
- Layout: VStack, HStack, Frame, ScrollingFrame
- Widgets: Button, Label, Slider, Field, ComboBox
- Styling with CSS-like properties
- Data binding for reactive updates

**[📖 Kit Documentation](https://docs.omniverse.nvidia.com/kit/)** - Development framework

## Key Exam Concepts

- Omniverse architecture: Nucleus, Kit, Connectors, RTX Renderer
- Nucleus collaboration model and checkpoint system
- Connector workflow modes: live sync vs publish/subscribe
- Kit extension architecture and Python API
- Omniverse application portfolio (Composer, Code, Isaac Sim)
- Deployment options for Nucleus server
