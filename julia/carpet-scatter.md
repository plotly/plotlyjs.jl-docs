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
    description: How to make carpet scatter plots in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Carpet Scatter Plot
    order: 15
    page_type: example_index
    permalink: julia/carpet-scatter/
    thumbnail: thumbnail/scattercarpet.jpg
---

### Basic Carpet Plot

```julia
using PlotlyJS

plot(carpet(
    a=[4, 4, 4, 4.5, 4.5, 4.5, 5, 5, 5, 6, 6, 6],
    b=[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
    y=[2, 3.5, 4, 3, 4.5, 5, 5.5, 6.5, 7.5, 8, 8.5, 10],
    aaxis=attr(
        tickprefix="a = ",
        ticksuffix="m",
        smoothing=1,
        minorgridcount=9
    ),
    baxis=attr(
        tickprefix="b = ",
        ticksuffix="Pa",
        smoothing=1,
        minorgridcount=9
    )
))
```

### Add Carpet Scatter Trace

```julia
using PlotlyJS

trace1 = carpet(
    a=[4, 4, 4, 4.5, 4.5, 4.5, 5, 5, 5, 6, 6, 6],
    b=[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
    y=[2, 3.5, 4, 3, 4.5, 5, 5.5, 6.5, 7.5, 8, 8.5, 10],
    aaxis=attr(
        tickprefix="a = ",
        ticksuffix="m",
        smoothing=1,
        minorgridcount=9
    ),
    baxis=attr(
        tickprefix="b = ",
        ticksuffix="Pa",
        smoothing=1,
        minorgridcount=9
    )
)

trace2 = scattercarpet(
    a=[4, 4.5, 5, 6],
    b=[2.5, 2.5, 2.5, 2.5],
    line=attr(
        shape="spline",
        smoothing=1,
        color="blue"
    )
)

plot([trace1, trace2])
```

### Add Multiple Scatter Traces

```julia
using PlotlyJS

trace1 = carpet(
    a=[0.1,0.2,0.3],
    b=[1,2,3],
    y=[[1,2.2,3],[1.5,2.7,3.5],[1.7,2.9,3.7]],
    cheaterslope=1,
    aaxis=attr(
        title="a",
        tickmode="linear",
        dtick=0.05
    ),
    baxis=attr(
        title="b",
        tickmode="linear",
        dtick=0.05
    )
)

trace2 = scattercarpet(
    name="b = 1.5",
    a=[0.05, 0.15, 0.25, 0.35],
    b=[1.5, 1.5, 1.5, 1.5]
)

trace3 = scattercarpet(
    name="b = 2",
    a=[0.05, 0.15, 0.25, 0.35],
    b=[2, 2, 2, 2]
)

trace4 = scattercarpet(
    name="b = 2.5",
    a=[0.05, 0.15, 0.25, 0.35],
    b=[2.5, 2.5, 2.5, 2.5]
)

trace5 = scattercarpet(
    name="a = 0.15",
    a=[0.15, 0.15, 0.15, 0.15],
    b=[0.5, 1.5, 2.5, 3.5],
    line=attr(
        smoothing=1,
        shape="spline"
    )
)

trace6 = scattercarpet(
    name="a = 0.2",
    a=[0.2, 0.2, 0.2, 0.2],
    b=[0.5, 1.5, 2.5, 3.5],
    line=attr(
        smoothing=1,
        shape="spline"
    ),
      marker=attr(
        size=[10, 20, 30, 40],
        color=["#000", "#f00", "#ff0", "#fff"]
      )
)

trace7 = scattercarpet(
    name="a = 0.25",
    a=[0.25, 0.25, 0.25, 0.25],
    b=[0.5, 1.5, 2.5, 3.5],
    line=attr(
        smoothing=1,
        shape="spline"
    )
)

layout = Layout(
    title="scattercarpet extrapolation, clipping, and smoothing",
    hovermode="closest"
)
plot([trace1, trace2, trace3, trace4, trace5, trace6, trace7], layout)
```

### Reference

See https://plotly.com/julia/reference/scattercarpet/ for more information and chart attribute options!
