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
    description: How to plot date and time in Julia.
    display_as: financial
    language: julia
    layout: base
    name: Time Series and Date Axes
    order: 1
    page_type: example_index
    permalink: julia/time-series/
    thumbnail: thumbnail/time-series.jpg
---

### Time Series using Axes of type `date`

Time series charts can be constructed from Julia either from Arrays or DataFrame columns with time like types (`DateTime` or `Date`).

For financial applications, Plotly can also be used to create [Candlestick charts](/julia/candlestick-charts/) and [OHLC charts](/julia/ohlc-charts/), which default to date axes.

```julia
using PlotlyJS, DataFrames, VegaDatasets, Dates

df = DataFrame(VegaDatasets.dataset("stocks"))
df[!, :date] = Date.(df.date, dateformat"uuu d yyyy")
plot(df, x=:date, y=:price, group=:symbol)
```

<!-- ### Time Series in Dash -->

### Different Chart Types on Date Axes

Any kind of cartesian chart can be placed on `date` axes, for example this bar chart of relative stock ticker values.

```julia
using PlotlyJS, DataFrames, VegaDatasets, Dates

df = DataFrame(VegaDatasets.dataset("stocks"))
df[!, :date] = Date.(df.date, dateformat"uuu d yyyy")

plot(
    df[df.symbol .== "AAPL", :],
    x=:date,
    y=:price,
    kind="bar",
    Layout(title="AAPL stock price"),
)
```

### Configuring Tick Labels

By default, the tick labels (and optional ticks) are associated with a specific grid-line, and represent an *instant* in time, for example, "00:00 on February 1, 2018". Tick labels can be formatted using the `tickformat` attribute (which accepts the [d3 time-format formatting strings](https://github.com/d3/d3-time-format)) to display only the month and year, but they still represent an instant by default, so in the figure below, the text of the label "Feb 2018" spans part of the month of January and part of the month of February. The `dtick` attribute controls the spacing between gridlines, and the `"M1"` setting means "1 month". This attribute also accepts a number of milliseconds, which can be scaled up to days by multiplying by `24*60*60*1000`.

Date axis tick labels have the special property that any portion after the first instance of `"\n"` in `tickformat` will appear on a second line only once per unique value, as with the year numbers in the example below. To have the year number appear on every tick label, `"<br>"` should be used instead of `"\n"`.

Note that by default, the formatting of values of X and Y values in the hover label matches that of the tick labels of the corresponding axes, so when customizing the tick labels to something broad like "month", it"s usually necessary to customize the hover label to something narrower like the actual date, as below.

```julia
using PlotlyJS, DataFrames, VegaDatasets, Dates

df = DataFrame(VegaDatasets.dataset("stocks"))
df[!, :date] = Date.(df.date, dateformat"uuu d yyyy")
plot(
    df, x=:date, y=:price, group=:symbol,
    Layout(
        title="custom tick labels",
        xaxis=attr(dtick="M1", tickformat="%b\n%Y", range=["2007-06-01", "2008-07-31"])
    )
)
```

### Moving Tick Labels to the Middle of the Period


By setting the `ticklabelmode` attribute to `"period"` (the default is `"instant"`) we can move the tick labels to the middle of the period they represent. The gridlines remain at the beginning of each month (thanks to `dtick="M1"`) but the labels now span the month they refer to.

```julia
using PlotlyJS, DataFrames, VegaDatasets, Dates

df = DataFrame(VegaDatasets.dataset("stocks"))
df[!, :date] = Date.(df.date, dateformat"uuu d yyyy")
plot(
    df, x=:date, y=:price, group=:symbol,
    Layout(
        title="custom tick labels with ticklabelmode='period'",
        xaxis=attr(dtick="M1", tickformat="%b\n%Y", ticklabelmode="period", range=["2007-06-01", "2008-07-31"])
    )
)
```

### Summarizing Time-series Data with Histograms

Plotly [histograms](/julia/histograms/) are powerful data-aggregation tools which even work on date axes. In the figure below, we pass in daily data and display it as monthly averages by setting `histfunc="avg` and `xbins_size="M1"`.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    [
        histogram(df, x=:Date, y=Symbol("AAPL.Close"), histfunc="avg", xbins_size="M1", name="hist"),
        scatter(df, mode="markers", x=:Date, y=Symbol("AAPL.Close"), name="daily"),
    ],
    Layout(
        title="Histogram on Date Axes",
        bargap=0.1,
        xaxis=attr(showgrid=true, ticklabelmode="period", dtick="M1", tickformat="%b\n%Y")
    )
)
```

### Displaying Period Data

If your data coded "January 1" or "January 31" in fact refers to data collected throughout the month of January, for example, you can configure your traces to display their marks at the start end, or middle of the month with the `xperiod` and `xperiodalignment` attributes. In the example below, the raw data is all coded with an X value of the 10th of the month, but is binned into monthly periods with `xperiod="M1"` and then displayed at the start, middle and end of the period.

```julia
using PlotlyJS, DataFrames, Dates

df = DataFrame(
    date=Date.(["2020-01-10", "2020-02-10", "2020-03-10", "2020-04-10", "2020-05-10", "2020-06-10"]),
    value=[1, 2, 3, 1, 2, 3]
)

# shared trace attributes
common = attr(mode="markers+lines", x=:date, y=:value)

plot(
    [
        scatter(df; name="Raw Data", marker_symbol="star", common...),
        scatter(df; name="Start-aligned", xperiod="M1", xperiodalignment="start", common...),
        scatter(df; name="Middle-aligned", xperiod="M1", xperiodalignment="middle", common...),
        scatter(df; name="End-aligned", xperiod="M1", xperiodalignment="end", common...),
        bar(df; name="Middle-aligned", xperiod="M1", xperiodalignment="middle", common...),
    ],
    Layout(xaxis=attr(showgrid=true, ticklabelmode="period"))
)
```

### Time Series Plot with Custom Date Range

The data range can be set manually using either `Date` objects, or date strings.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(df, x=:Date, y=Symbol("AAPL.High"), Layout(xaxis_range=["2016-07-01", "2016-12-31"]))
```

### Time Series With Range Slider

A range slider is a small subplot-like area below a plot which allows users to pan and zoom the X-axis while maintaining an overview of the chart. Check out the reference for more options: https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-rangeslider

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    df, x=:Date, y=Symbol("AAPL.High"),
    Layout(
        title="Time Series with Range Slider",
        xaxis_rangeslider_visible=true,
    )
)
```

### Time Series with Range Selector Buttons

Range selector buttons are special controls that work well with time series and range sliders, and allow users to easily set the range of the x-axis. Check out the reference for more options: https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-rangeselector

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    df, x=:Date, y=Symbol("AAPL.High"),
    Layout(
        title="Time Series with Range Slider and Selectors",
        xaxis=attr(
            rangeslider_visible=true,
            rangeselector=attr(
                buttons=[
                    attr(count=1, label="1m", step="month", stepmode="backward"),
                    attr(count=6, label="6m", step="month", stepmode="backward"),
                    attr(count=1, label="YTD", step="year", stepmode="todate"),
                    attr(count=1, label="1y", step="year", stepmode="backward"),
                    attr(step="all")
                ]
            )
        )
    )
)
```

### Customizing Tick Label Formatting by Zoom Level

The `tickformatstops` attribute can be used to customize the formatting of tick labels depending on the zoom level. Try zooming in to the chart below and see how the tick label formatting changes. Check out the reference for more options: https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-tickformatstops

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    df, x=:Date, y=:mavg,
    Layout(
        xaxis=attr(
            rangeslider_visible=true,
            tickformatstops = [
                attr(dtickrange=[nothing, 1000], value="%H:%M:%S.%L ms"),
                attr(dtickrange=[1000, 60000], value="%H:%M:%S s"),
                attr(dtickrange=[60000, 3600000], value="%H:%M m"),
                attr(dtickrange=[3600000, 86400000], value="%H:%M h"),
                attr(dtickrange=[86400000, 604800000], value="%e. %b d"),
                attr(dtickrange=[604800000, "M1"], value="%e. %b w"),
                attr(dtickrange=["M1", "M12"], value="%b %y M"),
                attr(dtickrange=["M12", nothing], value="%Y Y")
            ]
        )
    )
)
```

### Hiding Weekends and Holidays

The `rangebreaks` attribute available on x- and y-axes of type `date` can be used to hide certain time-periods. In the example below, we show two plots: one in default mode to show gaps in the data, and one where we hide weekends and holidays to show an uninterrupted trading history. Note the smaller gaps between the grid lines for December 21 and January 4, where holidays were removed. Check out the reference for more options: https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-rangebreaks

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    df, x=:Date, y=Symbol("AAPL.High"), kind=:scatter, mode=:markers,
    Layout(
        title="Default Display with Gaps",
        xaxis_range=Date.(["2015-12-01", "2016-01-15"])
    )
)
```

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

plot(
    df, x=:Date, y=Symbol("AAPL.High"), kind=:scatter, mode=:markers,
    Layout(
        title="Hide Weekend and Holiday Gaps with rangebreaks",
        xaxis=attr(
            range=Date.(["2015-12-01", "2016-01-15"]),
            rangebreaks=[
                Dict(:bounds=>["sat", "mon"]), #hide weekends
                Dict(:values=>["2015-12-25", "2016-01-01"])  # hide Christmas and New Year"s
            ]
        )
    )
)
```
