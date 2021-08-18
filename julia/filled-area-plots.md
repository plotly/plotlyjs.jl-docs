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
    description: How to make filled area plots in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Filled Area Plots
    order: 7
    page_type: example_index
    permalink: julia/filled-area-plots/
    thumbnail: thumbnail/area.jpg
---

### Filled area chart with plotly.graph_objects

#### Basic Overlaid Area Chart

```julia
using PlotlyJS

plot([
    scatter(x=1:4, y=[0, 2, 3, 5], fill="tozeroy"), # fill down to xaxis
    scatter(x=1:4, y=[3, 5, 1, 7], fill="tonexty"), # fill to trace0 y
])
```

#### Overlaid Area Chart Without Boundary Lines

Set `mode = "none"` to remove boundary lines.

```julia
using PlotlyJS

plot([
    scatter(x=1:4, y=[0, 2, 3, 5], fill="tozeroy", mode="none"),
    scatter(x=1:4, y=[3, 5, 1, 7], fill="tonexty", mode="none"),
])
```

#### Interior Filling for Area Chart

```julia
using PlotlyJS

plot([
    scatter(x=1:4, y=[3, 4, 8, 3], mode="lines", line_color="indigo"),
    scatter(x=1:4, y=[1, 6, 2, 6], mode="lines", line_color="indigo", fill="tonexty"),
])
```

#### Stacked Area Chart

The `stackgroup` parameter is used to add the `y` values of the different traces in the same group. Traces in the same group fill up to the next trace of the group.

```julia
using PlotlyJS

x = ["Winter", "Spring", "Summer", "Fall"]

plot([
    scatter(
        x=x, y=[40, 60, 40, 10],
        stackgroup="one", mode="lines", hoverinfo="x+y",
        line=attr(width=0.5, color="rgb(131, 90, 241)")
    ),
    scatter(
        x=x, y=[20, 10, 10, 60],
        stackgroup="one", mode="lines", hoverinfo="x+y",
        line=attr(width=0.5, color="rgb(111, 231, 219)")
    ),
    scatter(
        x=x, y=[40, 30, 50, 30],
        stackgroup="one", mode="lines", hoverinfo="x+y",
        line=attr(width=0.5, color="rgb(184, 247, 2121)")
    ),
], Layout(yaxis_range=(0, 100)))
```

### Stacked Area Chart with Normalized Values

```julia
using PlotlyJS

x = ["Winter", "Spring", "Summer", "Fall"]

plot([
    scatter(
        x=x, y=[40, 60, 40, 10],
        line=attr(width=0.5, color="rgb(131, 90, 241)"),
        stackgroup="one", mode="lines", hoverinfo="x+y",
        groupnorm="percent" # sets the normalization for the sum of the stackgroup
    ),
    scatter(
        x=x, y=[20, 10, 10, 60],
        stackgroup="one", mode="lines", hoverinfo="x+y",
        line=attr(width=0.5, color="rgb(111, 231, 219)")
    ),
    scatter(
        x=x, y=[40, 30, 50, 30],
        stackgroup="one", mode="lines", hoverinfo="x+y",
        line=attr(width=0.5, color="rgb(184, 247, 2121)")
    ),
], Layout(yaxis=attr(ticksuffix="%", range=(0, 100))))
```

#### Reference

See https://plotly.com/julia/reference/scatter/#scatter-line
and https://plotly.com/julia/reference/scatter/#scatter-fill
for more information and attribute options!
