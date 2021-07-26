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
    description: How to make Histograms in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: Histograms
    order: 3
    page_type: example_index
    permalink: julia/histograms/
    redirect_from:
      - /julia/histogram-tutorial/
      - /julia/histogram/
    thumbnail: thumbnail/histogram.jpg
---

In statistics, a [histogram](https://en.wikipedia.org/wiki/Histogram) is representation of the distribution of numerical data, where the data are binned and the count for each bin is represented. More generally, in plotly a histogram is an aggregated bar chart, with several possible aggregation functions (e.g. sum, average, count...).

If you"re looking instead for bar charts, i.e. representing _raw, unaggregated_ data with rectangular
bar, go to the [Bar Chart tutorial](/julia/bar-charts/).

## Histograms with DataFrames

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, kind="histogram")
```

#### Choosing the number of bins

By default, the number of bins is chosen so that this number is comparable to the typical number of samples in a bin. This number can be customized, as well as the range of values.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, kind="histogram", nbinsx=20)
```

### Histograms on Date Data

Plotly histograms will automatically bin date data in addition to numerical data:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
plot(df, x=:date, kind="histogram", Layout(bargap=0.2))
```

### Histograms on Categorical Data

Plotly histograms will automatically bin numerical or date data but can also be used on raw categorical data, as in the following example, where the X-axis value is the categorical "day" variable:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(df,
    x=:day, kind="histogram",
    Layout(xaxis=attr(categoryorder="array", categoryarray=["Thur", "Fri", "Sat", "Sun"]))
)
```

#### Type of normalization

The default mode is to represent the count of samples in each bin. With the `histnorm` argument, it is also possible to represent the percentage or fraction of samples in each bin (`histnorm="percent"` or `probability`), or a density histogram (the sum of all bar areas equals the total number of sample points, `density`), or a probability density histogram (the sum of all bar areas equals 1, `probability density`).

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, kind="histogram", histnorm="probability density")
```

#### Aspect of the histogram plot

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(
    df, x=:total_bill, marker=attr(opacity=0.8, color="indianred"), kind="histogram",
    Layout(title_text="Histogram of bills", xaxis_title_text="total bill", yaxis_type="log")
)
```

#### Several histograms for the different values of one column

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, kind="histogram", color=:sex, Layout(barmode="stack"))
```

#### Using histfunc

For each bin of `x`, one can compute a function of data using `histfunc`. The argument of `histfunc` is the dataframe column given as the `y` argument. Below the plot shows that the average tip increases with the total bill.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, y=:tip, kind="histogram", histfunc="avg")
```

### Horizontal Histogram

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
# Use `y` argument instead of `x` for horizontal histogram
plot(df, y=:total_bill, kind="histogram")
```

### Overlaid Histogram

```julia
using PlotlyJS

plot(
    [histogram(x=randn(500), opacity=0.6), histogram(x=randn(500), opacity=0.6)],
    Layout(barmode="overlay")
)
```

### Stacked Histograms

```julia
using PlotlyJS

plot(
    [histogram(x=randn(500), opacity=0.6), histogram(x=randn(500), opacity=0.6)],
    Layout(barmode="stack")
)
```

### Styled Histogram

```julia
using PlotlyJS
plot(
    [
        histogram(
            x=randn(500),
            histnorm="percent",
            name="control",
            xbins_start=0.2,
            xbins_end=0.8,
            xbins_size=0.1,
            marker_color="#eb98b5",
            opacity=0.75
        ),
        histogram(
            x=randn(500) .+ 1,
            histnorm="percent",
            name="experimental",
            xbins_start=0.4,
            xbins_end=0.8,
            xbins_size=0.1,
            marker_color="#330C73",
            opacity=0.75
        )
    ],
    Layout(title="Sampled Results", xaxis_title="Value", yaxis_title="Count")
)
```

### Cumulative Histogram

```julia
using PlotlyJS

plot(histogram(x=randn(400), cumulative_enabled=true, nbinsx=50))
```

### Specify Aggregation Function

```julia
using PlotlyJS
x = ["Apples", "Apples", "Apples", "Oranges", "Bananas"]
y = [5, 10, 3, 10, 5]

trace1 = histogram(histfunc="count", y=y, x=x, name="count")
trace2 = histogram(histfunc="sum", y=y, x=x, name="sum")

plot([trace1, trace2])
```


### Custom Binning

For custom binning along x-axis, use the attribute [`nbinsx`](https://plotly.com/julia/reference/histogram/#histogram-nbinsx). Please note that the autobin algorithm will choose a "nice" round bin size that may result in somewhat fewer than `nbinsx` total bins. Alternatively, you can set the exact values for [`xbins`](https://plotly.com/julia/reference/histogram/#histogram-xbins) along with `autobinx = false`.

```julia
using PlotlyJS

x = ["1970-01-01", "1970-01-01", "1970-02-01", "1970-04-01", "1970-01-02",
     "1972-01-31", "1970-02-13", "1971-04-19"]

p = make_subplots(rows=3, cols=2)


add_trace!(p, histogram(x=x, nbinsx=4), row=1, col=1)
add_trace!(p, histogram(x=x, nbinsx=8), row=1, col=2)
add_trace!(p, histogram(x=x, nbinsx=10), row=2, col=1)
add_trace!(p, histogram(
    x=x, xbins_end="1972-03-31", autobinx=false,
    xbins=attr(start="1969-11-15", size="M18"), # M18 stands for 18 months
), row=2, col=2)
add_trace!(p, histogram(
    x=x, autobinx=false, xbins_end="1972-03-31",
    xbins=attr(start="1969-11-15", size="M4"), # 4 months bin size
), row=3, col=1)
add_trace!(p, histogram(
    x=x, autobinx=false, xbins_end="1972-03-31",
    xbins=attr(start="1969-11-15", size= "M2"), # 2 months
), row=3, col=2)
p
```
### See also: Bar Charts

If you want to display information about the individual items within each histogram bar, then create a stacked bar chart with hover information as shown below. Note that this is not technically the histogram chart type, but it will have a similar effect as shown below by comparing the output of ploting `histogram` and `bar`. For more information, see the [tutorial on bar charts](/julia/bar-charts/).

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")

p1 = plot(df, x=:day, y=:tip, height=300, kind="bar", Layout(title="Stacked Bar Chart - Hover on individual items"))
p2 = plot(df, x=:day, y=:tip, height=300, kind="histogram", histfunc="sum", Layout(title="Histogram Chart"))

[p1; p2]
```

#### Reference

See  https://plotly.com/julia/reference/histogram/ for more information and chart attribute options!
