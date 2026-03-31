# Rendering and Materials

**[📖 MDL SDK Documentation](https://developer.nvidia.com/mdl-sdk)** - Material Definition Language

## MDL (Material Definition Language)

### Overview
- NVIDIA's physically-based material definition language
- Describes material appearance mathematically
- Procedural and texture-based materials
- Cross-renderer compatibility (RTX, Iray, etc.)
- Rich standard library of pre-built materials

### MDL Structure
```mdl
mdl 1.7;
import ::df::*;
import ::tex::*;

export material simple_material(
    color diffuse_color = color(0.8, 0.2, 0.2),
    float roughness = 0.5
) = material(
    surface: material_surface(
        scattering: df::diffuse_reflection_bsdf(
            tint: diffuse_color,
            roughness: roughness
        )
    )
);
```

### Key Concepts
- **BSDF** - Bidirectional Scattering Distribution Function
- **EDF** - Emission Distribution Function
- **VDF** - Volume Distribution Function
- Layered material composition
- Procedural textures and noise functions
- Cutout opacity and transparency

**[📖 MDL Handbook](https://developer.nvidia.com/mdl-sdk)** - Material authoring guide

## USD Preview Surface

### Standard Material

```python
# usda syntax
def Material "SimpleMaterial"
{
    token outputs:surface.connect = </SimpleMaterial/Shader.outputs:surface>

    def Shader "Shader"
    {
        uniform token info:id = "UsdPreviewSurface"
        color3f inputs:diffuseColor = (0.8, 0.2, 0.2)
        float inputs:metallic = 0.0
        float inputs:roughness = 0.5
        float inputs:opacity = 1.0
        token outputs:surface
    }
}
```

### UsdPreviewSurface Inputs
- **diffuseColor** - Base color (color3f)
- **metallic** - Metallic factor (0-1)
- **roughness** - Surface roughness (0-1)
- **opacity** - Transparency (0-1)
- **normal** - Normal map
- **displacement** - Displacement map
- **occlusion** - Ambient occlusion
- **emissiveColor** - Emission color
- **ior** - Index of refraction
- **specularColor** - Specular tint
- **clearcoat** - Clear coat layer
- **clearcoatRoughness** - Clear coat roughness

### MDL vs UsdPreviewSurface

| Feature | MDL | UsdPreviewSurface |
|---------|-----|-------------------|
| Complexity | Full PBR + procedural | Basic PBR |
| Compatibility | NVIDIA renderers | All USD renderers |
| Procedural | Yes | No |
| Layering | Full layer stack | Limited |
| Use case | Final rendering | Interchange/preview |

## Hydra Rendering Architecture

### Overview
- USD's rendering abstraction layer
- Separates scene description from rendering
- Multiple render delegates can render the same scene
- Scene index provides data to render delegates

### Render Delegates

**Storm:**
- OpenGL/Vulkan-based rasterizer
- Real-time viewport rendering
- Fast interactive performance
- USD's default render delegate
- Good for scene navigation and layout

**RTX (NVIDIA):**
- Hardware-accelerated ray tracing
- Path tracing for photorealistic rendering
- Real-time with AI denoising
- MDL material support
- Multi-GPU rendering

**HdPrman (Pixar):**
- RenderMan render delegate
- Production-quality rendering
- Film and VFX standard
- OSL shader support

### Scene Index
- Provides scene data to render delegates
- Handles change tracking and dirty flagging
- Manages render primitives (rprims)
- Supports instancing and scene graph optimization

**[📖 Hydra Architecture](https://openusd.org/release/api/hd_page_front.html)** - Rendering framework

## RTX Rendering in Omniverse

### Rendering Modes

**Real-Time (RTX Real-Time):**
- Interactive frame rates
- Ray-traced reflections and shadows
- Approximate global illumination
- AI denoising for quality
- Suitable for editing and preview

**Path Tracing (RTX Path Traced):**
- Physically accurate light simulation
- Full global illumination
- Caustics and complex light transport
- Converges over time to ground truth
- Used for final rendering

### Key Features
- **Global Illumination** - Indirect lighting from bounced light
- **Reflections** - Accurate mirror and glossy reflections
- **Shadows** - Soft shadows from area lights
- **Ambient Occlusion** - Contact shadows for realism
- **Subsurface Scattering** - Light penetrating translucent materials
- **AI Denoising** - DLSS and OptiX denoiser for real-time quality

### Multi-GPU Rendering
- Distribute rendering across multiple GPUs
- NVLink for efficient multi-GPU communication
- Linear scaling for path tracing
- SLI-like compositing for real-time mode

## Lighting

### USD Light Types
- **DistantLight** - Sun/directional light
- **SphereLight** - Point/spherical area light
- **RectLight** - Rectangular area light
- **DiskLight** - Disk-shaped area light
- **DomeLight** - Environment/IBL light (HDR map)
- **CylinderLight** - Cylindrical area light

### Lighting Properties
- **intensity** - Light brightness
- **color** - Light color
- **exposure** - Photographic exposure control
- **enableColorTemperature** - Kelvin color temperature
- **radius** (for area lights) - Size affects shadow softness

## Camera Setup

### USD Camera Properties
- **focalLength** - Lens focal length (mm)
- **horizontalAperture** - Sensor width (mm)
- **verticalAperture** - Sensor height (mm)
- **clippingRange** - Near and far clip planes
- **fStop** - Aperture for depth of field
- **focusDistance** - Focus distance for DOF

## Key Exam Concepts

- MDL structure and BSDF concepts
- UsdPreviewSurface inputs and properties
- MDL vs UsdPreviewSurface trade-offs
- Hydra render delegates: Storm, RTX, HdPrman
- RTX rendering modes: real-time vs path traced
- USD light types and their properties
- Camera properties for rendering
