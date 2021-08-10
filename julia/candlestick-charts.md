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
    description:
      How to make interactive candlestick charts in Julia with Plotly.
      Six examples of candlestick charts with Pandas, time series, and yahoo finance
      data.
    display_as: financial
    language: julia
    layout: base
    name: Candlestick Charts
    order: 2
    page_type: example_index
    permalink: julia/candlestick-charts/
    thumbnail: thumbnail/candlestick.jpg
---

The [candlestick chart](https://en.wikipedia.org/wiki/Candlestick_chart) is a style of financial chart describing open, high, low and close for a given `x` coordinate (most likely
time). The boxes represent the spread between the `open` and `close` values and the lines represent the spread between the `low` and `high` values. Sample points where the close value is higher (lower) then the open value are called increasing (decreasing). By default, increasing candles are drawn in green whereas decreasing are drawn in red.

#### Simple Candlestick with Pandas

```julia
using PlotlyJS, CSV, DataFrames

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

plot(candlestick(
        x=df[:, "Date"],
        open=df[:, "AAPL.Open"],
        high=df[:, "AAPL.High"],
        low=df[:, "AAPL.Low"],
        close=df[:, "AAPL.Close"]
    )
)

```

#### Candlestick without Rangeslider

```julia
using PlotlyJS, CSV, DataFrames

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

plot(candlestick(
        x=df[:, "Date"],
        open=df[:, "AAPL.Open"],
        high=df[:, "AAPL.High"],
        low=df[:, "AAPL.Low"],
        close=df[:, "AAPL.Close"]
    ),
    Layout(xaxis_rangeslider_visible=false)
)
```

#### Adding Customized Text and Annotations

```julia
using PlotlyJS, CSV, DataFrames

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

plot(candlestick(
        x=df[:, "Date"],
        open=df[:, "AAPL.Open"],
        high=df[:, "AAPL.High"],
        low=df[:, "AAPL.Low"],
        close=df[:, "AAPL.Close"]
    ),
    Layout(
        title="The Great Recession",
        yaxis_title="AAPL Stock",
        shapes = [attr(
            x0="2016-12-09", x1="2016-12-09", y0=0, y1=1, xref="x", yref="paper",
            line_width=2)],
        annotations=[attr(
            x="2016-12-09", y=0.05, xref="x", yref="paper",
            showarrow=false, xanchor="left", text="Increase Period Begins")]
    )
)
```

#### Custom Candlestick Colors

```python
using PlotlyJS, CSV, DataFrames

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

plot(candlestick(
        x=df[:, "Date"],
        open=df[:, "AAPL.Open"],
        high=df[:, "AAPL.High"],
        low=df[:, "AAPL.Low"],
        close=df[:, "AAPL.Close"],
        increasing_line_color="cyan",
        decreasing_line_color="gray"
    )
)
```

#### Simple Example with `Date` Objects

```julia
using PlotlyJS, Dates

open_data = [33.0, 33.3, 33.5, 33.0, 34.1]
high_data = [33.1, 33.3, 33.6, 33.2, 34.8]
low_data = [32.7, 32.7, 32.8, 32.6, 32.8]
close_data = [33.0, 32.9, 33.3, 33.1, 33.1]

dates = [Date(2013, 10, 10),
         Date(2013, 11, 10),
         Date(2013, 12, 10),
         Date(2014, 1, 10),
         Date(2014, 2, 10)]

plot(candlestick(
    x=dates,
    open=open_data, high=high_data,
    low=low_data, close=close_data
))

```

#### Reference

For more information on candlestick attributes, see: https://plotly.com/julia/reference/candlestick/
