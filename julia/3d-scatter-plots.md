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

## 3D scatter plot with Plotly Express

Like the [2D scatter plot](https://plotly.com/julia/line-and-scatter/) `scatter`, the 3D version `type="scatter3d"` plots individual data in three-dimensional space.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")
plot(df, x=:sepal_length, y=:sepal_width, z=:petal_width, group=:species, type="scatter3d", mode="markers")
```

A 4th dimension of the data can be represented thanks to the color of the markers. Also, values from the `species` column are used below to assign symbols to markers.

<!-- NOTE: Couln't get symbol to work -->

<!-- ```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
plot(df,
    x=:sepal_length,
    y=:sepal_width,
    z=:petal_width,
    marker_color=:petal_length,
    marker_symbol="star",
    type="scatter3d",
    mode="markers"
)
```
-->

<!-- NOTE: Doesn't seem to be the same graph... -->

#### Style 3d scatter plot

It is possible to customize the style of the figure through the parameters of `px.scatter_3d` for some options, or by updating the traces or the layout of the figure through `fig.update`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
layout = Layout(margin=attr(l=0, r=0, b=0, t=0))
plot(
    df,
    x=:sepal_length,
    y=:sepal_width,
    z=:petal_width,
    type="scatter3d",
    mode="markers",
    marker_size=:petal_length,
    marker_sizeref=0.3,
    group=:species ,
    layout
)
```

#### 3D Scatter Plot with Colorscaling and Marker Styling

```julia
using PlotlyJS
# Helix equation
t = range(0, stop=20, length=100)
x = cos.(t)
y = sin.(t)
z = t
layout = Layout(margin=attr(l=0, r=0, b=0, t=0))
plot(scatter(
    x=x,
    y=y,
    z=z,
    mode="markers",
    marker=attr(
        size=12,
        color=z,                # set color to an array/list of desired values
        colorscale="Viridis",   # choose a colorscale
        opacity=0.8
    ),
    type="scatter3d"
), layout)

```
