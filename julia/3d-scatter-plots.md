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
    description: How to make 3D scatter plots in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Scatter Plots
    order: 2
    page_type: example_index
    permalink: julia/3d-scatter-plots/
    thumbnail: thumbnail/3d-scatter.jpg
---

## 3D scatter plot

Like the [2D scatter plot](https://plotly.com/julia/line-and-scatter/) `scatter`, the 3D version `type="scatter3d"` plots individual data in three-dimensional space.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")
plot(
    df,
    x=:sepal_length, y=:sepal_width, z=:petal_width, group=:species,
    type="scatter3d", mode="markers"
)
```

#### Style 3d scatter plot

It is possible to customize the style of the figure through the parameters of `px.scatter_3d` for some options, or by updating the traces or the layout of the figure through `fig.update`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
plot(
    df, Layout(margin=attr(l=0, r=0, b=0, t=0)),
    x=:sepal_length, y=:sepal_width, z=:petal_width, group=:species,
    type="scatter3d", mode="markers",
    marker_size=:petal_length, marker_sizeref=0.3,
)
```

#### 3D Scatter Plot with Colorscaling and Marker Styling

```julia
using PlotlyJS
# Helix equation
t = range(0, stop=20, length=100)

plot(scatter(
    x=cos.(t),
    y=sin.(t),
    z=t,
    mode="markers",
    marker=attr(
        size=12,
        color=t,                # set color to an array/list of desired values
        colorscale="Viridis",   # choose a colorscale
        opacity=0.8
    ),
    type="scatter3d"
), Layout(margin=attr(l=0, r=0, b=0, t=0)))
```

#### Reference

See https://plotly.com/julia/reference/scatter3d/ for more information and chart attribute options!
