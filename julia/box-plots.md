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
    description: How to make Box Plots in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: Box Plots
    order: 2
    page_type: example_index
    permalink: julia/box-plots/
    redirect_from:
      - /julia/box/
      - /julia/basic_statistics/
    thumbnail: thumbnail/box.jpg
---

A [box plot](https://en.wikipedia.org/wiki/Box_plot) is a statistical representation of numerical data through their quartiles. The ends of the box represent the lower and upper quartiles, while the median (second quartile) is marked by a line inside the box. For other statistical representations of numerical data, see [other statistical charts](https://plotly.com/julia#statistical-charts).

## Box Plot

In a box plot, the distribution of the column given as `y` argument is represented.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, y=:total_bill, kind="box")
```

If a column name is given as `x` argument, a box plot is drawn for each value of `x`.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:time, y=:total_bill, kind="box")
```

<!-- ### Box Plots in Dash

[Dash](https://plotly.com/dash/) is the best way to build analytical apps in Python using Plotly figures. To run the app below, run `pip install dash`, click "Download" to get the code and run `python app.py`.

Get started with [the official Dash docs](https://dash.plotly.com/installation) and **learn how to effortlessly [style](https://plotly.com/dash/design-kit/) & [deploy](https://plotly.com/dash/app-manager/) apps like this with <a class="plotly-red" href="https://plotly.com/dash/">Dash Enterprise</a>.**

```python hide_code=true
from IPython.display import IFrame
snippet_url = 'https://dash-gallery.plotly.host/python-docs-dash-snippets/'
IFrame(snippet_url + 'box-plots', width='100%', height=630)
``` -->

### Display the underlying data

With the `boxpoints` argument, display underlying data points with either all points (`"all"`), outliers only (`"outliers"`, default), or none of them (`false`).

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:time, y=:total_bill, boxpoints="all" kind="box")
```

### Choosing The Algorithm For Computing Quartiles

By default, quartiles for box plots are computed using the `linear` method (for more about linear interpolation, see #10 listed on [http://www.amstat.org/publications/jse/v14n3/langford.html](http://www.amstat.org/publications/jse/v14n3/langford.html) and [https://en.wikipedia.org/wiki/Quartile](https://en.wikipedia.org/wiki/Quartile) for more details).

However, you can also choose to use an `exclusive` or an `inclusive` algorithm to compute quartiles.

The _exclusive_ algorithm uses the median to divide the ordered dataset into two halves. If the sample is odd, it does not include the median in either half. Q1 is then the median of the lower half and Q3 is the median of the upper half.

The _inclusive_ algorithm also uses the median to divide the ordered dataset into two halves, but if the sample is odd, it includes the median in both halves. Q1 is then the median of the lower half and Q3 the median of the upper half.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")

plot(df, x=:time, y=:total_bill, color=:smoker, quartilemethod="exclusive")
```

#### Difference Between Quartile Algorithms

It can sometimes be difficult to see the difference between the linear, inclusive, and exclusive algorithms for computing quartiles. In the following example, the same dataset is visualized using each of the three different quartile computation algorithms.

```julia
using PlotlyJS

data = [1,2,3,4,5,6,7,8,9]
trace1 = box(y=data, quartilemethod="linear", name="linear")
trace2 = box(y=data, quartilemethod="inclusive", name="inclusive")
trace3 = box(y=data, quartilemethod="exclusive", name="exclusive")

plot([trace1, trace2, trace3])

```

<!-- NOTE: couln't find the `hover_data` arg for julia box plot -->

#### Styled box plot

For the interpretation of the notches, see https://en.wikipedia.org/wiki/Box_plot#Variations.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(
    df,
    x=:time,
    y=:total_bill,
    group=:smoker,
    notched=true,
    kind="box",
    Layout(title="Box plot of total bill")
)

```

### Basic Horizontal Box Plot

```julia
using PlotlyJS

x0 = rand(50)
x1 = rand(50)

# Use x instead of y argument for horizontal plot
trace1 = box(x=x0)
trace2 = box(x=x1)
plot([trace1, trace2])
```

### Box Plot With Precomputed Quartiles

You can specify precomputed quartile attributes rather than using a built-in quartile computation algorithm.

This could be useful if you have already pre-computed those values or if you need to use a different algorithm than the ones provided.

```julia
using PlotlyJS


trace1 = box(y=y,
    name="Precompiled Quartiles", q1=[ 1, 2, 3 ],
    median=[ 4, 5, 6 ],
    q3=[ 7, 8, 9 ],
    lowerfence=[-1, 0, 1],
    upperfence=[5, 6, 7],
    mean=[ 2.2, 2.8, 3.2 ],
    sd=[ 0.2, 0.4, 0.6 ],
    notchspan=[ 0.2, 0.4, 0.6 ]
)
plot(trace1)
```

### Colored Box Plot

```julia
using PlotlyJS
y0 = rand(50)
y1 = rand(50)

trace1 = box(y=y1, marker_color="indianred", name="Sample A")
trace2 = box(y=y2, marker_color="lightseagreen", name="Sample B")
plot([trace, trace2])
```

### Box Plot Styling Mean & Standard Deviation

```julia
using PlotlyJS

trace1 = box(
    y=[2.37, 2.16, 4.82, 1.73, 1.04, 0.23, 1.32, 2.91, 0.11, 4.51, 0.51, 3.75, 1.35, 2.98, 4.50, 0.18, 4.66, 1.30, 2.06, 1.19],
    name="Only Mean",
    marker_color="darkblue",
    boxmean=true # represent mean
)
trace2 = box(
    y=[2.37, 2.16, 4.82, 1.73, 1.04, 0.23, 1.32, 2.91, 0.11, 4.51, 0.51, 3.75, 1.35, 2.98, 4.50, 0.18, 4.66, 1.30, 2.06, 1.19],
    name="Mean & SD",
    marker_color="royalblue",
    boxmean="sd" # represent mean and standard deviation
)
plot([trace1, trace2])
```

### Styling Outliers

The example below shows how to use the `boxpoints` argument. If "outliers", only the sample points lying outside the whiskers are shown. If "suspectedoutliers", the outlier points are shown and points either less than 4Q1-3Q3 or greater than 4Q3-3Q1 are highlighted (using `outliercolor`). If "all", all sample points are shown. If False, only the boxes are shown with no sample points.

```julia
using PlotlyJS

trace1 = box(
    y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
       8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25],
    name="All Points",
    jitter=0.3,
    pointpos=-1.8,
    boxpoints="all", # represent all points
    marker_color="rgb(7,40,89)",
    line_color="rgb(7,40,89)"
)

trace2 = box(
    y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25],
    name="Only Whiskers",
    boxpoints=false, # no data points
    marker_color="rgb(9,56,125)",
    line_color="rgb(9,56,125)"
)

trace3 = box(
    y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25],
    name="Suspected Outliers",
    boxpoints="suspectedoutliers", # only suspected outliers
    marker=attr(
        color="rgb(8,81,156)",
        outliercolor="rgba(219, 64, 82, 0.6)",
        line=attr(
            outliercolor="rgba(219, 64, 82, 0.6)",
            outlierwidth=2)),
    line_color="rgb(8,81,156)"
)

trace4 = box(
    y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25],
    name="Whiskers and Outliers",
    boxpoints="outliers", # only outliers
    marker_color="rgb(107,174,214)",
    line_color="rgb(107,174,214)"
)

plot([trace1, trace2, trace3, trace4], Layout(title="Box Plot Styling Outliers"))
```

### Grouped Box Plots

```julia
using PlotlyJS

x = ["day 1", "day 1", "day 1", "day 1", "day 1", "day 1",
     "day 2", "day 2", "day 2", "day 2", "day 2", "day 2"]


trace1 = box(
    y=[0.2, 0.2, 0.6, 1.0, 0.5, 0.4, 0.2, 0.7, 0.9, 0.1, 0.5, 0.3],
    x=x,
    name="kale",
    marker_color="#3D9970"
)
trace2 = box(
    y=[0.6, 0.7, 0.3, 0.6, 0.0, 0.5, 0.7, 0.9, 0.5, 0.8, 0.7, 0.2],
    x=x,
    name="radishes",
    marker_color="#FF4136"
)
trace3 = box(
    y=[0.1, 0.3, 0.1, 0.9, 0.6, 0.6, 0.9, 1.0, 0.3, 0.6, 0.8, 0.5],
    x=x,
    name="carrots",
    marker_color="#FF851B"
)

plot([trace1, trace2, trace3], Layout(yaxis_title="normalized moisture", boxmode="group"))
```

### Grouped Horizontal Box Plot

```julia
using PlotlyJS

y = ["day 1", "day 1", "day 1", "day 1", "day 1", "day 1",
     "day 2", "day 2", "day 2", "day 2", "day 2", "day 2"]

trace1 = box(
    x=[0.2, 0.2, 0.6, 1.0, 0.5, 0.4, 0.2, 0.7, 0.9, 0.1, 0.5, 0.3],
    y=y,
    name="kale",
    marker_color="#3D9970",
    orientation="h"
)
trace2 = box(
    x=[0.6, 0.7, 0.3, 0.6, 0.0, 0.5, 0.7, 0.9, 0.5, 0.8, 0.7, 0.2],
    y=y,
    name="radishes",
    marker_color="#FF4136",
    orientation="h"
)
trace3 = box(
    x=[0.1, 0.3, 0.1, 0.9, 0.6, 0.6, 0.9, 1.0, 0.3, 0.6, 0.8, 0.5],
    y=y,
    name="carrots",
    marker_color="#FF851B",
    orientation="h"
)

plot([trace1, trace2, trace3], Layout(boxmode="group", xaxis=attr(title="normalized moisture")))

```

### Rainbow Box Plots

```julia
using PlotlyJS

N = 30     # Number of boxes

# generate an array of rainbow colors by fixing the saturation and lightness of the HSL
# representation of colour and marching around the hue.
# Plotly accepts any CSS color format, see e.g. http://www.w3schools.com/cssref/css_colors_legal.asp.
c = [string("hsl(", h, ",50%",",50%)") for h in range(0, stop=360, length=N)]

# Each box is represented by a dict that contains the data, the type, and the colour.
# Use list comprehension to describe N boxes, each with a different colour and with different randomly generated data:
traces = [box(
    y=[j * (3.5 * sin(pi * i/N) + i/N + (1.5 + 0.5 * cos(pi*i/N))) for j in [1:1:10;]],
    marker_color=c[i]
) for i in [1:1:N;]]
layout = Layout(
    paper_bgcolor="rgb(233,233,233)",
    plot_bgcolor="rgb(233,233,233)",
    xaxis=attr(
        showgrid=false,
        zeroline=false,
        showticklabels=false
    ),
    yaxis=attr(
        zeroline=false, gridcolor="white"
    )
)
plot(traces, layout)
```

<!-- NOTE: the Layout method stopped working for me?? I know the syntax is correct,
but I don't know why it isn't working -->

### Fully Styled Box Plots

```julia
using PlotlyJS

x_data = ["Carmelo Anthony", "Dwyane Wade",
          "Deron Williams", "Brook Lopez",
          "Damian Lillard", "David West",]

N = 50

y0 = [(10 * i + 30) for i in rand(N)]
y1 = [(13 * i + 38) for i in rand(N)]
y2 = [(11 * i + 33) for i in rand(N)]
y3 = [(9 * i + 36) for i in rand(N)]
y4 = [(15 * i + 31) for i in rand(N)]
y5 = [(12 * i + 40) for i in rand(N)]

y_data = [y0, y1, y2, y3, y4, y5]

colors = ["rgba(93, 164, 214, 0.5)", "rgba(255, 144, 14, 0.5)", "rgba(44, 160, 101, 0.5)",
          "rgba(255, 65, 54, 0.5)", "rgba(207, 114, 255, 0.5)", "rgba(127, 96, 0, 0.5)"]

fig = go.Figure()

traces = [
    box(
        y=yd,
        name=xd,
        boxpoints="all",
        jitter=0.5,
        whiskerwidth=0.2,
        fillcolor=cls,
        marker_size=2,
        line_width=1
    )
    for (xd, yd, cls) in zip(x_data, y_data, colors)
]

layout = Layout(
    title="Points scored by the Top 9 Scoring NBA Players in 2012",
    yaxis=attr(
        autorange=true,
        showgrid=true,
        zerline=true,
        dtick=5,
        gridcolor="rgb(255,255,255)",
        zerlinecolor="rgb(255,255,255)",
        zerolinewidth=2
    ),
    margin=attr(
        l=40,
        r=30,
        b=80,
        t=100
    ),
    paper_bgcolor="rgb(243,243,243)",
    plot_bgcolor="rgb(243,243,243)",
    showlegend=false
)

plot(traces, layout)
```

<!-- #### Reference

See [function reference for `px.box()`](https://plotly.com/python-api-reference/generated/plotly.express.box) or https://plotly.com/python/reference/box/ for more information and chart attribute options! -->
