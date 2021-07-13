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

If you're looking instead for bar charts, i.e. representing _raw, unaggregated_ data with rectangular
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
df = dataset(DateFrame, "tips")
plot(df, x=:"total_bill", kind="histogram", nbinsx=20)
```

### Histograms on Date Data

Plotly histograms will automatically bin date data in addition to numerical data:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
plot(df, x=:date, kind="histogram")
```

<!-- fig.update_layout(bargap=0.2) NOTE can't figure out how to use bargap -->

### Histograms on Categorical Data

Plotly histograms will automatically bin numerical or date data but can also be used on raw categorical data, as in the following example, where the X-axis value is the categorical "day" variable:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
layout = Layout(xaxis=attr(categoryorder="array", categoryarray=["Thur", "Fri", "Sat", "Sun"]))
plot(df, x=:day, kind="histogram", layout)
```

<!-- #### Histograms in Dash

[Dash](https://plotly.com/dash/) is the best way to build analytical apps in Python using Plotly figures. To run the app below, run `pip install dash`, click "Download" to get the code and run `python app.py`.

Get started with [the official Dash docs](https://dash.plotly.com/installation) and **learn how to effortlessly [style](https://plotly.com/dash/design-kit/) & [deploy](https://plotly.com/dash/app-manager/) apps like this with <a class="plotly-red" href="https://plotly.com/dash/">Dash Enterprise</a>.**

```python hide_code=true
from IPython.display import IFrame
snippet_url = 'https://dash-gallery.plotly.host/python-docs-dash-snippets/'
IFrame(snippet_url + 'histograms', width='100%', height=630)
``` -->

<!-- NOTE: Not sure because this is numpy -->
<!-- #### Accessing the counts (y-axis) values

JavaScript calculates the y-axis (count) values on the fly in the browser, so it's not accessible in the `fig`. You can manually calculate it using `np.histogram`.

```python
import plotly.express as px
import numpy as np

df = px.data.tips()
# create the bins
counts, bins = np.histogram(df.total_bill, bins=range(0, 60, 5))
bins = 0.5 * (bins[:-1] + bins[1:])

fig = px.bar(x=bins, y=counts, labels={'x':'total_bill', 'y':'count'})
fig.show()
``` -->

#### Type of normalization

The default mode is to represent the count of samples in each bin. With the `histnorm` argument, it is also possible to represent the percentage or fraction of samples in each bin (`histnorm='percent'` or `probability`), or a density histogram (the sum of all bar areas equals the total number of sample points, `density`), or a probability density histogram (the sum of all bar areas equals 1, `probability density`).

```julia
using PlotlyJS, CSV, DataFrame
df = dataset(DateFrame, "tips")
plot(df, x:="total_bill", kind="histogram", histnorm='probability density')
```

<!-- NOTE: couldn't get log_y, color_discrete_sequence, or labels
title is in Layout
opacity is arg on plot -->
<!-- #### Aspect of the histogram plot

```python
import plotly.express as px
df = px.data.tips()
fig = px.histogram(df, x="total_bill",
                   title='Histogram of bills',
                   labels={'total_bill':'total bill'}, # can specify one label per df column
                   opacity=0.8,
                   log_y=True, # represent bars with log scale
                   color_discrete_sequence=['indianred'] # color of histogram bars
                   )
fig.show()
``` -->

#### Several histograms for the different values of one column

```julia
using PlotlyJS, CSV, DataFrame
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, kind="histogram", group=:sex)
```

#### Using histfunc

For each bin of `x`, one can compute a function of data using `histfunc`. The argument of `histfunc` is the dataframe column given as the `y` argument. Below the plot shows that the average tip increases with the total bill.

```julia
using PlotlyJS, CSV, DataFrame
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, y=:tip, kind="histogram", histfunc='avg')
```

<!-- NOTE: There is no default in julia -->
<!-- The default `histfunc` is `sum` if `y` is given, and works with categorical as well as binned numeric data on the `x` axis: -->

<!-- ```python
import plotly.express as px
df = px.data.tips()
fig = px.histogram(df, x="day", y="total_bill", category_orders=dict(day=["Thur", "Fri", "Sat", "Sun"]))
fig.show()
``` -->

<!-- NOTE: This feature doesn't exist for julia yet (/julia/pattern-hatching-texture/ is 404)-->
<!-- _New in v5.0_

Histograms afford the use of [patterns (also known as hatching or texture)](/python/pattern-hatching-texture/) in addition to color:

```python
import plotly.express as px

df = px.data.tips()
fig = px.histogram(df, x="sex", y="total_bill", color="sex", pattern_shape="smoker")
fig.show()
``` -->

<!-- NOTE: feature doesn't exist in julia lib -->
<!--
#### Visualizing the distribution

With the `marginal` keyword, a subplot is drawn alongside the histogram, visualizing the distribution. See [the distplot page](https://plotly.com/python/distplot/)for more examples of combined statistical representations.

```python
import plotly.express as px
df = px.data.tips()
fig = px.histogram(df, x="total_bill", color="sex", marginal="rug", # can be `box`, `violin`
                         hover_data=df.columns)
fig.show()
``` -->

### Horizontal Histogram

```julia
using PlotlyJS, CSV, DataFrame

df = dataset(DataFrame, "tips")
# Use `y` argument instead of `x` for horizontal histogram
plot(df, y=:"total_bill", kind="histogram")
```

### Overlaid Histogram

```julia
using PlotlyJS, CSV, DataFrame


x0 = randn(500)
x1 = randn(500)

trace1 = histogram( x=x0)
trace2 = histogram(x=x1)
layout = Layout(barmode="overlay")

plot([trace1, trace2], layout)
```

```julia
using PlotlyJS, CSV, DataFrame
```

### Stacked Histograms

```julia
using PlotlyJS, CSV, DataFrame


x0 = randn(500)
x1 = randn(500)

trace1 = histogram( x=x0)
trace2 = histogram(x=x1)
layout = Layout(barmode="stack")

plot([trace1, trace2], layout)
```

### Styled Histogram

```julia
using PlotlyJS, CSV

x0 = rand(500)
x1 = rand(500)

layout = Layout(
    title="Sampled Results",
    xaxis_title="Value",
    yaxis_title="Count"
)

trace1 = histogram(
    x=x0,
    histnorm="percent",
    name="control",
    xbins_start=0.2,
    xbins_end=0.8,
    xbins_size=0.1,
    marker_color="#eb98b5",
    opacity=0.75
)

trace1 = histogram(
    x=x0,
    histnorm="percent",
    name="experimental",
    xbins_start=0.4,
    xbins_end=0.8,
    xbins_size=0.1,
    marker_color="#330C73",
    opacity=0.75
)

plot([trace1, trace2], layout)
```

### Cumulative Histogram

```julia
x = rand(5000)
plot(histogram(x=x, kind="histogram", cumulative_enabled=true))
```

### Specify Aggregation Function

```julia
x = ["Apples","Apples","Apples","Oranges", "Bananas"]
y = ["5","10","3","10","5"]

trace1 = histogram(histfunc="count", y=y, x=x, name="count"))
trace2 = histogram(histfunc="sum", y=y, x=x, name="sum"))

plot([trace1, trace2])
```

<!-- NOTE: can't get `nbinsx` arg to work with a histogram() trace -->
<!--
### Custom Binning

For custom binning along x-axis, use the attribute [`nbinsx`](https://plotly.com/python/reference/histogram/#histogram-nbinsx). Please note that the autobin algorithm will choose a 'nice' round bin size that may result in somewhat fewer than `nbinsx` total bins. Alternatively, you can set the exact values for [`xbins`](https://plotly.com/python/reference/histogram/#histogram-xbins) along with `autobinx = False`.

```python
import plotly.graph_objects as go
from plotly.subplots import make_subplots

x = ['1970-01-01', '1970-01-01', '1970-02-01', '1970-04-01', '1970-01-02',
     '1972-01-31', '1970-02-13', '1971-04-19']

fig = make_subplots(rows=3, cols=2)

trace0 = go.Histogram(x=x, nbinsx=4)
trace1 = go.Histogram(x=x, nbinsx = 8)
trace2 = go.Histogram(x=x, nbinsx=10)
trace3 = go.Histogram(x=x,
                      xbins=dict(
                      start='1969-11-15',
                      end='1972-03-31',
                      size='M18'), # M18 stands for 18 months
                      autobinx=False
                     )
trace4 = go.Histogram(x=x,
                      xbins=dict(
                      start='1969-11-15',
                      end='1972-03-31',
                      size='M4'), # 4 months bin size
                      autobinx=False
                      )
trace5 = go.Histogram(x=x,
                      xbins=dict(
                      start='1969-11-15',
                      end='1972-03-31',
                      size= 'M2'), # 2 months
                      autobinx = False
                      )

fig.append_trace(trace0, 1, 1)
fig.append_trace(trace1, 1, 2)
fig.append_trace(trace2, 2, 1)
fig.append_trace(trace3, 2, 2)
fig.append_trace(trace4, 3, 1)
fig.append_trace(trace5, 3, 2)

fig.show()
``` -->

### See also: Bar Charts

If you want to display information about the individual items within each histogram bar, then create a stacked bar chart with hover information as shown below. Note that this is not technically the histogram chart type, but it will have a similar effect as shown below by comparing the output of ploting `histogram` and `bar`. For more information, see the [tutorial on bar charts](/julia/bar-charts/).

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")

plot(df, x=:day, y=:tip, height=300, kind="bar", Layout(title="Stacked Bar Chart - Hover on individual items"))
plot(df, x=:day, y=:tip, height=300, kind="histogram", histfunc="sum", Layout(title="Histogram Chart"))
```

<!-- NOTE: I don't see anydifference with using bingroup. Maybe the wrong arg? Or not implemented? -->

<!-- ### Share bins between histograms

In this example both histograms have a compatible bin settings using [bingroup](https://plotly.com/julia/reference/histogram/#histogram-bingroup) attribute. Note that traces on the same subplot, and with the same `barmode` ("stack", "relative", "group") are forced into the same `bingroup`, however traces with `barmode = "overlay"` and on different axes (of the same axis type) can have compatible bin settings. Histogram and [histogram2d](https://plotly.com/julia/2D-Histogram/) trace can share the same `bingroup`.

```python
import plotly.graph_objects as go
import numpy as np

fig = go.Figure(go.Histogram(
    x=np.random.randint(7, size=100),
    bingroup=1))

fig.add_trace(go.Histogram(
    x=np.random.randint(7, size=20),
    bingroup=1))

fig.update_layout(
    barmode="overlay",
    bargap=0.1)

fig.show()
```

#### Reference

See [function reference for `px.histogram()`](https://plotly.com/python-api-reference/generated/plotly.express.histogram) or https://plotly.com/python/reference/histogram/ for more information and chart attribute options! -->
