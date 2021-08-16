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
    description: How to Control the Camera in your 3D Charts in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Camera Controls
    order: 5
    permalink: julia/3d-camera-controls/
    thumbnail: thumbnail/3d-camera-controls.jpg
---

### How camera controls work

The camera position and direction is determined by three vectors: _up_, _center_, _eye_. Their coordinates refer to the 3-d domain, i.e., `(0, 0, 0)` is always the center of the domain, no matter data values.
The `eye` vector determines the position of the camera. The default is $(x=1.25, y=1.25, z=1.25)$.

The `up` vector determines the `up` direction on the page. The default is $(x=0, y=0, z=1)$, that is, the z-axis points up.

The projection of the `center` point lies at the center of the view. By default it is $(x=0, y=0, z=0)$.

### Default parameters

```julia
using PlotlyJS, DataFrames, CSV, HTTP
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "default"
# Default parameters which are used when `layout.scene.camera` is not provided
camera = attr(
    up=attr(x=0, y=0, z=1),
    center=attr(x=0, y=0, z=0),
    eye=attr(x=1.25, y=1.25, z=1.25)
)

relayout!(p, scene_camera=camera, title=name)
p
```

### Changing the camera position by setting the eye parameter

#### Lower the View Point

by setting `eye.z` to a smaller value.

```julia
using PlotlyJS, DataFrames, CSV, HTTP
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:2, y:2, z:0.1)"
camera = attr(
    eye=attr(x=2, y=2, z=0.1)
)

relayout!(p, scene_camera=camera, title=name)

p
```

#### X-Z plane

set `eye.x` and `eye.z` to zero

```julia
using PlotlyJS, DataFrames, CSV, HTTP
# Read data from a csv
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:0., y:2.5, z:0.)"
camera = attr(
    eye=attr(x=0., y=2.5, z=0.)
)


relayout!(p, scene_camera=camera, title=name)

p
```

#### Y-Z plane

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:2.5, y:0., z:0.)"
camera = attr(
    eye=attr(x=2.5, y=0., z=0.)
)

relayout!(p, scene_camera=camera, title=name)
p
```

#### View from Above (X-Y plane)

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:0., y:0., z:2.5)"
camera = attr(
    eye=attr(x=0., y=0., z=2.5)
)

relayout!(p, scene_camera=camera, title=name)
p
```

#### Zooming In

... by placing the camera closer to the origin (`eye` with a smaller norm)

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:0.1, y:0.1, z:1.5)"
camera = attr(
    eye=attr(x=0.1, y=0.1, z=1.5)
)

relayout!(p, scene_camera=camera, title=name)

p
```

### Tilting the camera vertical by setting the up parameter

Tilt camera by changing the `up` vector: here the vertical of the view points in the `x` direction.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)

name = "eye = (x:0., y:2.5, z:0.), point along x"
camera = attr(
    up=attr(x=1, y=0., z=0),
    eye=attr(x=0., y=2.5, z=0.)
)

relayout!(p, scene_camera=camera, title=name)
p
```

Note when `up` does not correspond to the direction of an axis, you also need to set `layout.scene.dragmode="orbit"`.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)


angle = pi / 4 # 45 degrees

name = "vertical is along y+z"
camera = attr(
    up=attr(x=0, y=cos(angle), z=sin(angle)),
    eye=attr(x=2, y=0, z=0)
)

relayout!(p, scene_camera=camera, scene_dragmode="orbit", title=name)
p
```

### Changing the focal point by setting center

You can change the focal point (a point which projection lies at the center of the view) by setting the `center` parameter of `camera`. Note how a part of the data is cropped below because the camera is looking up.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv").body
) |> DataFrame

p = plot(surface(z=Matrix{Float64}(df), showscale=false))
relayout!(p,
    title="Mt Bruno Elevation",
    width=400, height=400,
    margin=attr(t=40, r=0, l=20, b=20)
)
name = "looking up"
camera = attr(
    center=attr(x=0, y=0, z=0.7))


relayout!(p, scene_camera=camera, title=name)
p
```

#### Reference

See https://plotly.com/julia/reference/layout/scene/#layout-scene-camera for more information and chart attribute options!
