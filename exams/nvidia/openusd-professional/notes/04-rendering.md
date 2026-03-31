# Rendering and Materials

**[📖 USD Rendering](https://openusd.org/release/api/usdShade_page_front.html)** - USD shading documentation

## Materials in USD

### USD Preview Surface

The standard material in USD for cross-platform compatibility:

**Properties:**
- `diffuseColor` - Base color (RGB)
- `metallic` - Metallic factor (0-1)
- `roughness` - Surface roughness (0-1)
- `opacity` - Transparency (0-1)
- `emissiveColor` - Self-illumination color
- `ior` - Index of refraction
- `normal` - Normal map input
- `occlusion` - Ambient occlusion

```usda
def Material "SimpleMaterial"
{
    token outputs:surface.connect = </SimpleMaterial/Shader.outputs:surface>

    def Shader "Shader"
    {
        uniform token info:id = "UsdPreviewSurface"
        color3f inputs:diffuseColor = (0.8, 0.2, 0.2)
        float inputs:metallic = 0.0
        float inputs:roughness = 0.5
        token outputs:surface
    }
}
```

### MDL Materials

**NVIDIA Material Definition Language:**
- Advanced physically-based material system
- Procedural textures and noise functions
- Layered materials and complex shading
- GPU-optimized for RTX rendering
- Extensive material library
- **[📖 MDL SDK](https://developer.nvidia.com/mdl-sdk)** - Material language reference

**Key MDL Features:**
- Mathematical functions for procedural generation
- Layer blending (clear coat, subsurface)
- Measured material data support
- Texture coordinate manipulation
- Custom BSDF definitions

### Material Binding

```python
from pxr import UsdShade

# Create material
material = UsdShade.Material.Define(stage, '/Materials/Red')

# Create shader
shader = UsdShade.Shader.Define(stage, '/Materials/Red/Shader')
shader.CreateIdAttr('UsdPreviewSurface')
shader.CreateInput('diffuseColor', Sdf.ValueTypeNames.Color3f).Set((1, 0, 0))
shader.CreateInput('roughness', Sdf.ValueTypeNames.Float).Set(0.4)

# Connect shader to material output
material.CreateSurfaceOutput().ConnectToSource(shader.ConnectableAPI(), 'surface')

# Bind material to geometry
UsdShade.MaterialBindingAPI(mesh_prim).Bind(material)
```

### Texture Mapping

```usda
def Shader "DiffuseTexture"
{
    uniform token info:id = "UsdUVTexture"
    asset inputs:file = @./textures/diffuse.png@
    float2 inputs:st.connect = </Material/UVReader.outputs:result>
    color3f outputs:rgb
}

def Shader "UVReader"
{
    uniform token info:id = "UsdPrimvarReader_float2"
    string inputs:varname = "st"
    float2 outputs:result
}
```

## Lighting

### USD Light Types

**UsdLuxDistantLight:**
- Infinitely far away (sun-like)
- Parallel rays
- Properties: angle, color, intensity

**UsdLuxSphereLight:**
- Point or sphere-shaped light source
- Properties: radius, color, intensity
- Soft shadows based on radius

**UsdLuxRectLight:**
- Rectangular area light
- Properties: width, height, color, intensity
- Good for window and panel lighting

**UsdLuxDomeLight:**
- Environment/sky light
- Image-based lighting (IBL) with HDR textures
- Properties: texture file, intensity
- Provides ambient illumination

**UsdLuxCylinderLight:**
- Tube-shaped light source
- Good for fluorescent lighting simulation

### Light Properties
- **intensity** - Light brightness
- **color** - Light color (RGB)
- **exposure** - Photographic exposure adjustment
- **normalize** - Normalize intensity by area
- **enableColorTemperature** - Use Kelvin color temperature

### Light Linking
- Control which geometry a light affects
- Include/exclude lists for selective lighting
- Per-light shadow enable/disable
- Light group management

## Cameras

### USD Camera Properties
- **focalLength** - Lens focal length (mm)
- **horizontalAperture** - Sensor width (mm)
- **verticalAperture** - Sensor height (mm)
- **clippingRange** - Near/far clip planes
- **fStop** - Aperture for depth of field
- **focusDistance** - Focus distance for DoF

## Hydra Rendering Architecture

### Overview
- USD's pluggable rendering system
- Decouples scene description from rendering
- Multiple render delegates can render the same scene
- Scene index translates USD to render-ready data

### Render Delegates

**Storm (Default):**
- OpenGL/Vulkan rasterizer
- Fast interactive viewport rendering
- Good for scene navigation and layout
- Lower quality than ray tracing

**RTX (NVIDIA):**
- Real-time ray tracing
- Path tracing for photorealistic output
- GPU-accelerated (requires NVIDIA RTX GPU)
- Global illumination, reflections, caustics
- Progressive refinement for final quality

**Third-Party Delegates:**
- RenderMan (Pixar)
- Arnold (Autodesk)
- Karma (SideFX)
- Blender Cycles

### Render Settings
- Resolution and aspect ratio
- Samples per pixel (quality vs speed)
- Ray depth for reflections/refractions
- Denoising options
- AOV (Arbitrary Output Variable) channels
- Motion blur settings

## Key Exam Concepts

- USD Preview Surface properties and PBR workflow
- MDL vs USD Preview Surface (capabilities and use cases)
- Material binding API for connecting materials to geometry
- USD light types and their properties
- Hydra architecture and render delegate concept
- Storm (rasterizer) vs RTX (ray tracer) render delegates
