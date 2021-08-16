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
    description: Add continuous error bands to charts in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: Continuous Error Bands
    order: 15
    page_type: u-guide
    permalink: julia/continuous-error-bars/
    thumbnail: thumbnail/error-cont.jpg
---

Continuous error bands are a graphical representation of error or uncertainty as a shaded region around a main trace, rather than as discrete whisker-like error bars. They can be implemented in a manner similar to [filled area plots](/julia/filled-area-plots/) using `scatter` traces with the `fill` attribute.

#### Filling within a single trace

In this example we show how to construct a trace that goes from low to high X values along the upper Y edge of a region, and then from high to low X values along the lower Y edge of the region. This trace is then 'self-filled' using `fill='toself'`.

```julia
using PlotlyJS

x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y = [1, 2, 7, 4, 5, 6, 7, 8, 9, 10]
y_upper = [2, 3, 8, 5, 6, 7, 8, 9, 10, 11]
y_lower = [0, 1, 5, 3, 4, 5, 6, 7, 8, 9]


traces=[
    scatter(
        x=x,
        y=y,
        line=attr(color="rgb(0,100,80)"),
        mode="lines"
    ),
    scatter(
        x=vcat(x, reverse(x)), # x, then x reversed
        y=vcat(y_upper, reverse(y_lower)), # upper, then lower reversed
        fill="toself",
        fillcolor="rgba(0,100,80,0.2)",
        line=attr(color="rgba(255,255,255,0)"),
        hoverinfo="skip",
        showlegend=false
    )
]
plot(traces)
```

#### Filling between two traces

In this example we show how to construct the bounds of the band using two traces, with the lower trace using `fill='tonexty'` to fill an area up to the upper trace.

```julia
using PlotlyJS, DataFrames, CSV, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/wind_speed_laurel_nebraska.csv").body
) |> DataFrame

traces = [
    scatter(
        name="Measurement",
        x=df[!, "Time"],
        y=df[!, "10 Min Sampled Avg"],
        mode="lines",
        line=attr(color="rgb(31, 119, 180)"),
    ),
    scatter(
        name="Upper Bound",
        x=df[!, "Time"],
        y=df[!, "10 Min Sampled Avg"] .+ df[!, "10 Min Std Dev"],
        mode="lines",
        marker=attr(color="#444"),
        line=attr(width=0),
        showlegend=false
    ),
    scatter(
        name="Lower Bound",
        x=df[!, "Time"],
        y=df[!, "10 Min Sampled Avg"] .- df[!, "10 Min Std Dev"],
        marker=attr(color="#444"),
        line=attr(width=0),
        mode="lines",
        fillcolor="rgba(68, 68, 68, 0.3)",
        fill="tonexty",
        showlegend=false
    )
]
layout = Layout(
    yaxis_title="Wind speed (m/s)",
    title="Continuous, variable value error bars",
    hovermode="x"
)
plot(traces, layout)
```
