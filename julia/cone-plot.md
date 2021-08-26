---
jupyter:
  jupytext:
    notebook_metadata_filter: all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: "1.2"
      jupytext_version: 1.4.2
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
  plotly:
    description: How to make 3D Cone plots in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Cone Plots
    order: 12
    page_type: example_index
    permalink: julia/cone-plot/
    redirect_from: julia/3d-cone/
    thumbnail: thumbnail/3dcone.png
---

A cone plot is the 3D equivalent of a 2D [quiver plot](/julia/quiver-plots/), i.e., it represents a 3D vector field using cones to represent the direction and norm of the vectors. 3-D coordinates are given by `x`, `y` and `z`, and the coordinates of the vector field by `u`, `v` and `w`.

### Basic 3D Cone

```julia
using PlotlyJS

plot(
    cone(x=[1], y=[1], z=[1], u=[1], v=[1], w=[0]),
    Layout(scene_camera_eye=attr(x=-0.76, y=1.8, z=0.92)
))

```

### Multiple 3D Cones

```julia
using PlotlyJS

plot(
    cone(
        x=[1, 2, 3],
        y=[1, 2, 3],
        z=[1, 2, 3],
        u=[1, 0, 0],
        v=[0, 3, 0],
        w=[0, 0, 2],
        sizemode="absolute",
        sizeref=2,
        anchor="tip"
    ),
    Layout(
        scene=attr(
        domain_x=[0, 1],
        camera_eye=attr(x=-1.57, y=1.36, z=0.58))
    )
)

```

### 3D Cone Lighting

```julia
using PlotlyJS

trace1 = cone(
    x=repeat([1,], 3), name="base", y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace2 = cone(
    x=repeat([2,], 3), opacity=0.3, name="opacity:0.3", y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace3 = cone(
    x=repeat([3,], 3), lighting_ambient=0.3, name="lighting.ambient:0.3", y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace4 = cone(
    x=repeat([4,], 3), lighting_diffuse=0.3, name="lighting.diffuse:0.3", y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace5 = cone(
    x=repeat([5,], 3), lighting_specular=2, name="lighting.specular:2",y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace6 = cone(
    x=repeat([6,], 3), lighting_roughness=1, name="lighting.roughness:1",y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace7 = cone(
    x=repeat([7,], 3), lighting_fresnel=2, name="lighting.fresnel:2",y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name",
    showscale=false
)
trace8 = cone(
    x=repeat([8,], 3), lightposition=attr(x=0, y=0, z=1e5),
    name="lighting.position x:0,y:0,z:1e5",y=[1, 2, 3], z=[1, 1, 1],
    u=[1, 2, 3], v=[1, 1, 2], w=[4, 4, 1],
    hoverinfo="u+v+w+name", showscale=false
)

layout = Layout(
    scene=attr(
        aspectmode="data",
        camera_eye=attr(x=0.05, y=-2.6, z=2)
    ),
    margin=attr(t=0, b=0, l=0, r=0)
)


plot([trace1, trace2, trace3, trace4, trace5, trace6, trace7, trace8], layout)
```

### 3D Cone Vortex

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/vortex.csv").body
) |> DataFrame

plot(cone(
        df,
        x=:x,
        y=:y,
        z=:z,
        u=:u,
        v=:v,
        w=:w,
        colorscale=colors.Blues_8,
        sizemode="absolute",
        sizeref=40
    ),
    Layout(
        scene=attr(
            aspectratio=attr(x=1, y=1, z=0.8),
            camera_eye=attr(x=1.2, y=1.2, z=0.6)
        )
    )
)
```

#### Reference

See https://plotly.com/julia/reference/ for more information and chart attribute options!
