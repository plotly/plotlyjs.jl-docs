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
    description: How to make 3D Volume Plots in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Volume Plots
    order: 11
    page_type: u-guide
    permalink: julia/3d-volume-plots/
    thumbnail: thumbnail/3d-volume-plots.jpg
---

A volume plot with `volume` shows several partially transparent isosurfaces for volume rendering. The API of `volume` is close to the one of `isosurface`. However, whereas [isosurface plots](/julia/3d-isosurface-plots/) show all surfaces with the same opacity, tweaking the `opacityscale` parameter of `volume` results in a depth effect and better volume rendering.

## Simple volume plot

In the three examples below, note that the default colormap is different whether isomin and isomax have the same sign or not.

```julia
using PLotlyJS


function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

data = range(-8, stop=8, length=40)
X, Y, Z = mgrid(data, data, data)

values = sin.(X .* Y .* Z) ./ (X .* Y .* Z)

plot(volume(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=0.1,
    isomax=0.8,
    opacity=0.1, # needs to be small to see through all surfaces
    surface_count=17, # needs to be a large number for good volume rendering
))
```

```julia
using PlotlyJS

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end
data = range(-1, stop=1, length=30)

X, Y, Z = mgrid(data, data, data)
values = sin.(pi .* X) .* cos.(pi .* Z) .* sin.(pi .* Y)

plot(volume(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=-0.1,
    isomax=0.8,
    opacity=0.1, # needs to be small to see through all surfaces
    surface_count=21, # needs to be a large number for good volume rendering
))
```

```julia
using PlotlyJS, ImageFiltering

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

# Generate nicely looking random 3D-field
l = 30
data = 1:l

X, Y, Z = mgrid(data, data, data)
vol = zeros((l, l, l))
vol[rand(1:length(vol), 15)] .= 1

vol = imfilter(vol, Kernel.gaussian((4 ,4, 4)), "symmetric")
vol ./= maximum(vol)

trace = volume(
    x=X[:], y=Y[:], z=Z[:],
    value=vol[:],
    isomin=0.2,
    isomax=0.7,
    opacity=0.1,
    surface_count=25,
)
layout = Layout(scene_xaxis_showticklabels=false,
                  scene_yaxis_showticklabels=false,
                  scene_zaxis_showticklabels=false)

plot(trace, layout)
```

### Defining the opacity scale of volume plots

In order to see through the volume, the different isosurfaces need to be partially transparent. This transparency is controlled by a global parameter, `opacity`, as well as an opacity scale mapping scalar values to opacity levels. The figure below shows that changing the opacity scale changes a lot the visualization, so that `opacityscale` should be chosen carefully (`uniform` corresponds to a uniform opacity, `min`/`max` maps the minimum/maximum value to a maximal opacity, and `extremes` maps both the minimum and maximum values to maximal opacity, with a dip in between).

```julia
using PlotlyJS

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

fig = make_subplots(
    rows=2, cols=2,
    specs=fill(Spec(kind="scene"), 2,2)
)


data = range(-8, stop=8, length=30)
X, Y, Z = mgrid(data, data, data)

values = sin.(X .* Y .* Z) ./ (X .* Y .* Z)


add_trace!(fig, volume(
    opacityscale="uniform",
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=0.15,
    isomax=0.9,
    opacity=0.1,
    surface_count=15,
    ), row=1, col=1)
add_trace!(fig, volume(
    opacityscale="extremes",
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=0.15,
    isomax=0.9,
    opacity=0.1,
    surface_count=15,
    ), row=1, col=2)
add_trace!(fig, volume(
    opacityscale="min",
     x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=0.15,
    isomax=0.9,
    opacity=0.1,
    surface_count=15,
    ), row=2, col=1)
add_trace!(fig, volume(
    opacityscale="max",
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=0.15,
    isomax=0.9,
    opacity=0.1,
    surface_count=15,
    ), row=2, col=2)


fig
```

### Defining a custom opacity scale

It is also possible to define a custom opacity scale, mapping scalar values to relative opacity values (between 0 and 1, the maximum opacity is given by the opacity keyword). This is useful to make a range of values completely transparent, as in the example below between -0.2 and 0.2.

```julia
using PlotlyJS
function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

data = range(-1, stop=1, length=30)
X, Y, Z = mgrid(data, data, data)

values =    sin.(pi .* X) .* cos.(pi .* Z) .* sin.(pi .* Y)

plot(volume(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=-0.5,
    isomax=0.5,
    opacity=0.1, # max opacity
    opacityscale=[[-0.5, 1], [-0.2, 0], [0.2, 0], [0.5, 1]],
    surface_count=21,
    colorscale="RdBu"
    ))
```

### Adding caps to a volume plot

For a clearer visualization of internal surfaces, it is possible to remove the caps (color-coded surfaces on the sides of the visualization domain). Caps are visible by default. Compare below with and without caps.

```julia
using PlotlyJS
function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

data = range(0, stop=1, length=20)
X, Y, Z = mgrid(data, data, data)

vol = (X .- 1) .^ 2 .+ (Y .- 1) .^ 2 .+ Z .^ 2


trace = volume(
    x=X[:], y=Y[:], z=Z[:],
    value=vol[:],
    isomin=0.2,
    isomax=0.7,
    opacity=0.2,
    surface_count=21,
    caps= attr(x_show=true, y_show=true, z_show=true, x_fill=1), # with caps (default mode)
)

# Change camera view for a better view of the sides, XZ plane
# (see https://plotly.com/python/v3/3d-camera-controls/)
layout = Layout(scene_camera = attr(
    up=attr(x=0, y=0, z=1),
    center=attr(x=0, y=0, z=0),
    eye=attr(x=0.1, y=2.5, z=0.1)
))

plot(trace, layout)
```

```julia
using PlotlyJS
function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

data = range(0, stop=1, length=20)
X, Y, Z = mgrid(data, data, data)

vol = (X .- 1) .^ 2 .+ (Y .- 1) .^ 2 .+ Z .^ 2



trace = volume(
    x=X[:], y=Y[:], z=Z[:],
    value=vol[:],
    isomin=0.2,
    isomax=0.7,
    opacity=0.2,
    surface_count=21,
    caps= attr(x_show=false, y_show=false, z_show=false, x_fill=1), # no caps
)

layout = Layout(scene_camera = attr(
    up=attr(x=0, y=0, z=1),
    center=attr(x=0, y=0, z=0),
    eye=attr(x=0.1, y=2.5, z=0.1)
))

plot(trace, layout)
```

### Adding slices to a volume plot

Slices through the volume can be added to the volume plot. In this example the isosurfaces are only partially filled so that the slice is more visible, and the caps were removed for the same purpose.

```julia
using PlotlyJS
function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

data = range(0, stop=1, length=20)
X, Y, Z = mgrid(data, data, data)

vol = (X .- 1) .^ 2 .+ (Y .- 1) .^ 2 .+ Z .^ 2


plot(volume(
    x=X[:], y=Y[:], z=Z[:],
    value=vol[:],
    isomin=0.2,
    isomax=0.7,
    opacity=0.2,
    surface_count=21,
    slices_z=attr(show=true, locations=[0.4]),
    surface=attr(fill=0.5, pattern="odd"),
    caps= attr(x_show=false, y_show=false, z_show=false), # no caps
))

```

#### Reference

See https://plotly.com/julia/reference/volume/ for more information and chart attribute options!

#### See also

[3D isosurface documentation](/julia/3d-isosurface-plots/)
