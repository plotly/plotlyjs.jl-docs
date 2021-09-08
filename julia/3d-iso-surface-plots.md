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
    description: How to make 3D Isosurface Plots in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Isosurface Plots
    order: 10
    page_type: example_index
    permalink: julia/3d-isosurface-plots/
    redirect_from: julia/isosurfaces-with-marching-cubes/
    thumbnail: thumbnail/isosurface.jpg
---

# NOTE: this permalink does not work

With `go.Isosurface`, you can plot [isosurface contours](https://en.wikipedia.org/wiki/Isosurface) of a scalar field `value`, which is defined on `x`, `y` and `z` coordinates.

#### Basic Isosurface

In this first example, we plot the isocontours of values `isomin=2` and `isomax=6`. In addition, portions of the sides of the coordinate domains for which the value is between `isomin` and `isomax` (named the `caps`) are colored. Please rotate the figure to visualize both the internal surfaces and the caps surfaces on the sides.

```julia
using PlotlyJS

trace = isosurface(
    x=[0,0,0,0,1,1,1,1],
    y=[1,0,1,0,1,0,1,0],
    z=[1,1,0,0,1,1,0,0],
    value=[1,2,3,4,5,6,7,8],
    isomin=2,
    isomax=6,
)
plot(trace)
```

### Removing caps when visualizing isosurfaces

For a clearer visualization of internal surfaces, it is possible to remove the caps (color-coded surfaces on the sides of the visualization domain). Caps are visible by default.

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)

values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=10,
    isomax=40,
    caps=attr(x_show=false, y_show=false)
))

```

### Modifying the number of isosurfaces

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=10,
    isomax=50,
    surface_count=5, # number of isosurfaces, 2 by default: only min and max
    colorbar_nticks=5, # colorbar ticks correspond to isosurface values
    caps=attr(x_show=false, y_show=false)
    ))
```

### Changing the opacity of isosurfaces

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    opacity=0.6,
    isomin=10,
    isomax=50,
    surface_count=3,
    caps=attr(x_show=false, y_show=false)
    ))
```

#### Isosurface with Additional Slices

Here we visualize slices parallel to the axes on top of isosurfaces. For a clearer visualization, the `fill` ratio of isosurfaces is decreased below 1 (completely filled).

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2
plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=5,
    isomax=50,
    surface_fill=0.4,
    caps=attr(x_show=false, y_show=false),
    slices_z=attr(show=true, locations=[-1, -3,]),
    slices_y=attr(show=true, locations=[0]),
    ))
```

#### Multiple Isosurfaces with Caps

```julia

data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=30,
    isomax=50,
    surface=attr(count=3, fill=0.7, pattern="odd"),
    caps=attr(x_show=true, y_show=true),
    ))
```

### Changing the default colorscale of isosurfaces

<!-- TODO: `colorscale` not changing -->

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

plot(isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    colorscale=colors.RdBu_3,
    isomin=10,
    isomax=50,
    surface_count=3,
    caps=attr(x_show=false, y_show=false)
    ))
```

### Customizing the layout and appearance of isosurface plots

```julia
using PlotlyJS


data = range(-5, stop=5, length=40)
X, Y, Z = mgrid(data, data, data)
# ellipsoid
values = X .* X .* 0.5 .+ Y .* Y .+ Z .* Z .* 2

trace = isosurface(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=30,
    isomax=50,
    surface=attr(count=3, fill=0.7, pattern="odd"),
    showscale=false, # remove colorbar
    caps=attr(x_show=true, y_show=true),
    )

layout = Layout(
    margin=attr(t=0, l=0, b=0), # tight layout
    scene_camera_eye=attr(x=1.86, y=0.61, z=0.98))

plot(trace, layout)
```

#### Reference

See https://plotly.com/julia/reference/isosurface/ for more information and chart attribute options!
