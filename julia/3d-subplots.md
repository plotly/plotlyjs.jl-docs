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
    description: 3D Subplots in Plotly
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Subplots
    order: 4
    page_type: example_index
    permalink: julia/3d-subplots/
    thumbnail: thumbnail/3d-subplots.jpg
---

#### 3D Surface Subplots

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

# Initialize figure with 4 3D subplots
fig = make_subplots(
    rows=2, cols=2,
    specs=fill(Spec(kind="scene"), 2, 2)
)

# Generate data
x = range(-5, stop=80, length=10)
y = range(-5, stop=60, length=10)
xGrid, yGrid = mgrid(y, x)
z = xGrid .^ 3 .+ yGrid .^ 3

# adding surfaces to subplots.
add_trace!(
    fig,
    surface(x=x, y=y, z=z, colorscale="Viridis", showscale=false),
    row=1, col=1)

add_trace!(
    fig,
    surface(x=x, y=y, z=z, colorscale="RdBu", showscale=false),
    row=1, col=2)

add_trace!(
    fig,
    surface(x=x, y=y, z=z, colorscale="YlOrRd", showscale=false),
    row=2, col=1)

add_trace!(
    fig,
    surface(x=x, y=y, z=z, colorscale="YlGnBu", showscale=false),
    row=2, col=2)

relayout!(
    fig,
    title_text="3D subplots with different colorscales",
    height=800,
    width=800
)

fig
```

#### Reference

See https://plotly.com/julia/subplots/ for more information regarding subplots!
