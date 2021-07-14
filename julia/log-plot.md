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
    description: How to make Log plots in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Log Plots
    order: 5
    permalink: julia/log-plot/
    thumbnail: thumbnail/log.jpg
---

### Logarithmic Axes

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df07 = df[df.year .== 2007, :]

plot(
    df07,
    x=:gdpPercap, y=:lifeExp, hover_name=:county, mode="markers",
    Layout(xaxis_type="log")
)
```

Setting the range of a logarithmic axis works the same was as with linear axes: using the `xaxis_range` and `yaxis_range` keywords on the `Layout`. Note that you cannot set the range to include 0 or less.

In the example below, the range of the x-axis is [0, 5] in log units, which is the same as [0, 10000] in linear units.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df07 = df[df.year .== 2007, :]

plot(
    df07,
    x=:gdpPercap, y=:lifeExp, hover_name=:county, mode="markers",
    Layout(xaxis=attr(type="log", range=[0, 5]), yaxis_range=[0, 100])
)
```
