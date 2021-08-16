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
    description: How to make 3D Mesh Plots
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Mesh Plots
    order: 9
    page_type: u-guide
    permalink: julia/3d-mesh/
    thumbnail: thumbnail/3d-mesh.jpg
---

### Simple 3D Mesh example

`go.Mesh3d` draws a 3D set of triangles with vertices given by `x`, `y` and `z`. If only coordinates are given, an algorithm such as [Delaunay triangulation](https://en.wikipedia.org/wiki/Delaunay_triangulation) is used to draw the triangles. Otherwise the triangles can be given using the `i`, `j` and `k` parameters (see examples below).

```julia
import plotly.graph_objects as go
import numpy as np
using PlotlyJS, CSV, DataFrames, HTTP

# Download data set from plotly repo
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/mesh_dataset.txt").body;
    delim=" ",
    header=false
) |> DataFrame

plot(df, kind="mesh3d", x=:Column1, y=:Column2, z=:Column3, opacity=0.50)
```

### 3D Mesh example with Alphahull

The `alphahull` parameter sets the shape of the mesh. If the value is -1 (default value) then [Delaunay triangulation](https://en.wikipedia.org/wiki/Delaunay_triangulation) is used. If >0 then the [alpha-shape algorithm](https://en.wikipedia.org/wiki/Alpha_shape) is used. If 0, the [convex hull](https://en.wikipedia.org/wiki/Convex_hull) is represented (resulting in a convex body).

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/mesh_dataset.txt").body;
    delim=" ",
    header=false
) |> DataFrame

plot(df, x=:Column1, y=:Column2, z=:Column3,
    kind="mesh3d",
    alphahull=5,
    opacity=0.4)
```

### Mesh Tetrahedron

In this example we use the `i`, `j` and `k` parameters to specify manually the geometry of the triangles of the mesh.

```julia
using PlotlyJS

plot(mesh3d(
    x=[0, 1, 2, 0],
    y=[0, 0, 1, 2],
    z=[0, 2, 0, 1],
    colorbar_title="z",
    colorscale=[[0, "gold"],
                [0.5, "mediumturquoise"],
                [1, "magenta"]],
    # Intensity of each vertex, which will be interpolated and color-coded
    intensity=[0, 0.33, 0.66, 1],
    # i, j and k give the vertices of triangles
    # here we represent the 4 triangles of the tetrahedron surface
    i=[0, 0, 0, 1],
    j=[1, 2, 3, 2],
    k=[2, 3, 1, 3],
    name="y",
    showscale=true
))

```

### Mesh Cube

```julia
using PlotlyJS

plot(mesh3d(
    # 8 vertices of a cube
    x=[0, 0, 1, 1, 0, 0, 1, 1],
    y=[0, 1, 1, 0, 0, 1, 1, 0],
    z=[0, 0, 0, 0, 1, 1, 1, 1],
    colorbar_title="z",
    colorscale=[[0, "gold"],
                [0.5, "mediumturquoise"],
                [1, "magenta"]],
    # Intensity of each vertex, which will be interpolated and color-coded
    intensity = 0:8,
    # i, j and k give the vertices of triangles
    i = [7, 0, 0, 0, 4, 4, 6, 6, 4, 0, 3, 2],
    j = [3, 4, 1, 2, 5, 6, 5, 2, 0, 1, 6, 3],
    k = [0, 7, 2, 3, 6, 7, 1, 1, 5, 5, 7, 6],
    name="y",
    showscale=true
))

```

### Intensity values defined on vertices or cells

The `intensitymode` attribute of `mesh3d` can be set to `vertex` (default mode, in which case intensity values are interpolated between values defined on vertices), or to `cell` (value of the whole cell, no interpolation). Note that the `intensity` parameter should have the same length as the number of vertices or cells, depending on the `intensitymode`.

Whereas the previous example used the default `intensitymode='vertex'`, we plot here the same mesh with `intensitymode='cell'`.

```julia
using PlotlyJS

plot(mesh3d(
    # 8 vertices of a cube
    x=[0, 0, 1, 1, 0, 0, 1, 1],
    y=[0, 1, 1, 0, 0, 1, 1, 0],
    z=[0, 0, 0, 0, 1, 1, 1, 1],
    colorbar_title="z",
    colorscale=[[0, "gold"],
                [0.5, "mediumturquoise"],
                [1, "magenta"]],
    # Intensity of each vertex, which will be interpolated and color-coded
    intensity = 0:12,
    intensitymode="cell",
    # i, j and k give the vertices of triangles
    i = [7, 0, 0, 0, 4, 4, 6, 6, 4, 0, 3, 2],
    j = [3, 4, 1, 2, 5, 6, 5, 2, 0, 1, 6, 3],
    k = [0, 7, 2, 3, 6, 7, 1, 1, 5, 5, 7, 6],
    name="y",
    showscale=true
))

```

## Reference

See https://plotly.com/julia/reference/mesh3d/ for more information and chart attribute options!
