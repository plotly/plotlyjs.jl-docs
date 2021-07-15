---
jupyter:
  jupytext:
    notebook_metadata_filter: all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: "1.2"
      jupytext_version: 1.6.0
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
  plotly:
    description: How to make 3D-surface plots in Julia
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Surface Plots
    order: 3
    page_type: example_index
    permalink: julia/3d-surface-plots/
    redirect_from: julia/3d-surface-coloring/
    thumbnail: thumbnail/3d-surface.jpg
---

#### Topographical 3D Surface Plot

```julia
using PlotlyJS, CSV, HTTP, DataFrames
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame
z_data = Matrix{Float64}(df)
layout = Layout(
    title="Mt Bruno Elevation",
    autosize=false,
    width=500,
    height=500,
    margin=attr(l=65, r=50, b=65, t=90)
)
plot(surface(z=z_data), layout)
```

### Passing x and y data to 3D Surface Plot

If you do not specify `x` and `y` coordinates, integer indices are used for the `x` and `y` axis. You can also pass `x` and `y` values to `surface`.

```julia
using PlotlyJS, CSV, HTTP, DataFrames
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

z_data = Matrix{Float64}(df)'
(sh_0, sh_1) = size(z_data)

x = range(0, stop=1, length=sh_0)
y = range(0, stop=1, length=sh_1)
layout = Layout(
    title="Mt Bruno Elevation", autosize=false,
    width=500, height=500,
    margin=attr(l=65, r=50, b=65, t=90)
)

plot(surface(z=z_data, x=x, y=y), layout)

```

#### Surface Plot With Contours

Display and customize contour data for each axis using the `contours` attribute ([reference](plotly.com/julia/reference/surface/#surface-contours)).

```julia
using PlotlyJS, CSV, HTTP, DataFrames
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame
z_data = Matrix{Float64}(df)'

layout = Layout(
    title="Mt Bruno Elevation",
    autosize=false,
    scene_camera_eye=attr(x=1.87, y=0.88, z=-0.64),
    width=500, height=500,
    margin=attr(l=65, r=50, b=65, t=90)
)
plot(surface(
    z=z_data,
    contours_z=attr(
        show=true,
        usecolormap=true,
        highlightcolor="limegreen",
        project_z=true
    )
), layout)
```

#### Configure Surface Contour Levels

This example shows how to slice the surface graph on the desired position for each of x, y and z axis. [contours.x.start](https://plotly.com/julia/reference/surface/#surface-contours-x-start) sets the starting contour level value, `end` sets the end of it, and `size` sets the step between each contour level.

```julia
using PlotlyJS

plot(
    surface(
        contours = attr(
            x=attr(show=true, start= 1.5, size=0.04, color="white"),
            x_end=2,
            z=attr(show=true, start= 0.5, size= 0.05),
            z_end=0.8
        ),
        x=1:5, y=1:5,
        z = [
            [0, 1, 0, 1, 0],
            [1, 0, 1, 0, 1],
            [0, 1, 0, 1, 0],
            [1, 0, 1, 0, 1],
            [0, 1, 0, 1, 0]
        ]
    ),
    Layout(
        scene=attr(
            xaxis_nticks=20,
            zaxis_nticks=4,
            camera_eye=attr(x=0, y=-1, z=0.5),
            aspectratio=attr(x=1, y=1, z=0.2)
        )
    )
)
```

#### Multiple 3D Surface Plots

```julia
using PlotlyJS

z1 = [
    [8.83,8.89,8.81,8.87,8.9,8.87],
    [8.89,8.94,8.85,8.94,8.96,8.92],
    [8.84,8.9,8.82,8.92,8.93,8.91],
    [8.79,8.85,8.79,8.9,8.94,8.92],
    [8.79,8.88,8.81,8.9,8.95,8.92],
    [8.8,8.82,8.78,8.91,8.94,8.92],
    [8.75,8.78,8.77,8.91,8.95,8.92],
    [8.8,8.8,8.77,8.91,8.95,8.94],
    [8.74,8.81,8.76,8.93,8.98,8.99],
    [8.89,8.99,8.92,9.1,9.13,9.11],
    [8.97,8.97,8.91,9.09,9.11,9.11],
    [9.04,9.08,9.05,9.25,9.28,9.27],
    [9,9.01,9,9.2,9.23,9.2],
    [8.99,8.99,8.98,9.18,9.2,9.19],
    [8.93,8.97,8.97,9.18,9.2,9.18]
]

trace1 = surface(z=z1)
trace2 = surface(z=map(z -> z .- 1, z1), showscale=false, opacity=0.9)
trace3 = surface(z=map(z -> z .+ 1, z1), showscale=false, opacity=0.9)

plot([trace1, trace2, trace3])
```


### Setting the Surface Color

You can use the `surfacecolor` attribute to define the color of the surface of your figure. In this example, the surface color represents the distance from the origin, rather than the default, which is the `z` value.

```julia
using PlotlyJS

a, b, d = 1.32, 1., 0.8
c = a^2 - b^2
dom = range(0, stop=2π, length=100)
u = dom' .* ones(100)
v = ones(100)' .* dom

x = @. (d * (c - a * cos(u) * cos(v)) + b^2 * cos(u)) / (a - c * cos(u) * cos(v))
y = @. b * sin(u) * (a - d*cos(v)) / (a - c * cos(u) * cos(v))
z = @. b * sin(v) * (c*cos(u) - d) / (a - c * cos(u) * cos(v))

p = make_subplots(
    rows=1, cols=2,
    specs=[Spec(kind="scene") Spec(kind="scene")],
    subplot_titles=["Color corresponds to z"  "Color corresponds to distance to origin"]
)
add_trace!(p, surface(x=x, y=y, z=z, colorbar_x=-0.07), row=1, col=1)
add_trace!(p, surface(x=x, y=y, z=z, surfacecolor=@. x^2 + y^2 + z^2), row=1, col=2)
relayout!(p, title_text="Ring cyclide")
p
```

#### Reference

See https://plotly.com/julia/reference/surface/ for more information!
