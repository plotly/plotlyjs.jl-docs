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
    description: How to make a graph with multiple axes (dual y-axis plots, plots
      with secondary axes) in julia.
    display_as: file_settings
    language: julia
    layout: base
    name: Multiple Axes
    order: 16
    permalink: julia/multiple-axes/
    thumbnail: thumbnail/multiple-axes.jpg
---

#### Two Y Axes

```julia
using PlotlyJS

plot(
    [
        scatter(x=1:3, y=40:10:60, name="yaxis data"),
        scatter(x=2:4, y=4:6, name="yaxis2 data", yaxis="y2")
    ],
    Layout(
        title_text="Double Y Axis Example",
        xaxis_title_text="xaxis title",
        yaxis_title_text="yaxis title",
        yaxis2=attr(
            title="yaxis2 title",
            overlaying="y",
            side="right"
        )
    )
)
```

#### Multiple Axes

Low-level API for creating a figure with multiple axes

```julia
using PlotlyJS

traces = GenericTrace[]
for i in 1:4
    trace = scatter(x=(i+1):(i+3), y=4:6 .* (10^i), yaxis="y$i", name="yaxis$i data")
    push!(traces, trace)
end

plot(
    traces,
    Layout(
        xaxis_domain=[0.3, 0.7],
        yaxis=attr(title="yaxis title", titlefont_color="red"),
        yaxis2=attr(
            title="yaxis2 title", titlefont_color="blue",
            overlaying="y", side="left", position=0.15, anchor="free"
        ),
        yaxis3=attr(
            title="yaxis3 title", titlefont_color="green",
            overlaying="y", side="right", anchor="x",
        ),
        yaxis4=attr(
            title="yaxis4 title", titlefont_color="orange",
            overlaying="y", side="right", position=0.85, anchor="free",
        ),
        title_text="multiple y-axes example",
    )
)
```

#### Reference

All of the y-axis properties are found here: https://plotly.com/julia/reference/YAxis/.  For more information on creating subplots see the [Subplots in Julia](/julia/subplots/) section.
