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
    description: How to format axes ticks in Julia with Plotly.
    display_as: file_settings
    language: julia
    layout: base
    name: Formatting Ticks
    order: 12
    permalink: julia/tick-formatting/
    thumbnail: thumbnail/tick-formatting.gif
---

#### Tickmode - Linear

If `"linear"`, the placement of the ticks is determined by a starting position `tick0` and a tick step `dtick`

```julia
using PlotlyJS

fig = plot(scatter(
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    y = [28.8, 28.5, 37, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9]
))

relayout!(fig,
    xaxis = attr(
        tickmode = "linear",
        tick0 = 0.5,
        dtick = 0.75
    )
)

fig
```

#### Tickmode - Array

If `"array"`, the placement of the ticks is set via `tickvals` and the tick text is `ticktext`.

```julia
using PlotlyJS

fig = plot(scatter(
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    y = [28.8, 28.5, 37, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9]
))

relayout!(fig,
    xaxis = attr(
        tickmode = "array",
        tickvals = [1, 3, 5, 7, 9, 11],
        ticktext = ["One", "Three", "Five", "Seven", "Nine", "Eleven"]
    )
)

fig
```

#### Using Tickformat Attribute

For more formatting types, see: https://github.com/d3/d3-format/blob/master/README.md#locale_format

```julia
using PlotlyJS

fig = plot(scatter(
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    y = [28.8, 28.5, 37, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9]
))

relayout!(fig, yaxis_tickformat = "%")

fig
```

#### Using Tickformat Attribute - Date/Time

For more date/time formatting types, see: https://github.com/d3/d3-time-format/blob/master/README.md

```julia
using PlotlyJS, DataFrames, CSV, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

fig = plot(df, kind="scatter", x=:Date, y=df[!, "AAPL.High"])

relayout!(fig, title = "Time Series with Custom Date-Time Format",
    xaxis_tickformat = "%d %B (%a)<br>%Y")

fig
```

#### Using Exponentformat Attribute

```julia
using PlotlyJS

fig = plot(scatter(
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    y = [68000, 52000, 60000, 20000, 95000, 40000, 60000, 79000, 74000, 42000, 20000, 90000]
))

relayout!(fig,
    yaxis =attr(
        showexponent = "all",
        exponentformat = "e"
    )
)

fig
```

#### Tickformatstops to customize for different zoom levels

```julia
using PlotlyJS, DataFrames, CSV, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

fig = plot(df,
    kind="scatter",
    x=:Date,
    y=:mavg
)

relayout!(fig,
    xaxis_tickformatstops = [
        attr(dtickrange=[missing, 1000], value="%H:%M:%S.%L ms"),
        attr(dtickrange=[1000, 60000], value="%H:%M:%S s"),
        attr(dtickrange=[60000, 3600000], value="%H:%M m"),
        attr(dtickrange=[3600000, 86400000], value="%H:%M h"),
        attr(dtickrange=[86400000, 604800000], value="%e. %b d"),
        attr(dtickrange=[604800000, "M1"], value="%e. %b w"),
        attr(dtickrange=["M1", "M12"], value="%b '%y M"),
        attr(dtickrange=["M12", missing], value="%Y Y")
    ]
)

fig
```

#### Placing ticks and gridlines between categories

```julia
using PlotlyJS

fig = plot(bar(
    x = ["apples", "oranges", "pears"],
    y = [1, 2, 3]
))

update_xaxes!(
    fig,
    showgrid=true,
    ticks="outside",
    tickson="boundaries",
    ticklen=20
)

fig
```

#### Reference

See https://plotly.com/julia/reference/layout/xaxis/ for more information and chart attribute options!
