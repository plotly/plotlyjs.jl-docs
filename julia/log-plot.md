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
using PlotlyJS, CSV, DataFrames, Query

df = @from i in dataset(DataFrame, "gapminder") begin
     @where i.year == 2007
     @select i
     @collect DataFrame
    end

layout = Layout(xaxis_type="log")

plot(df,
    x=:gdpPercap,
    y=:lifeExp,
    hover_name=:county,
    kind="scatter",
    mode="markers",
    layout
)
```

<!-- NOTE: This doesn't seem correct...It produces a chart where the xaxis range is 10^100000 -->

Setting the range of a logarithmic axis works the same was as with linear axes: using the `xaxis_range` and `yaxis_range` keywords on the `Layout`. Note that you cannot set the range to include 0 or less.

```julia
using PlotlyJS, CSV, DataFrames, Query

df = @from i in dataset(DataFrame, "gapminder") begin
     @where i.year == 2007
     @select i
     @collect DataFrame
    end

layout = Layout(
    xaxis_type="log",
    xaxis_range=[1,100000],
    yaxis_range=[0,100]
)

plot(df,
    x=:gdpPercap,
    y=:lifeExp,
    hover_name=:county,
    kind="scatter",
    mode="markers",
    layout
)
```
