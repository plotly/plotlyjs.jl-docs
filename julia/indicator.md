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
    description: How to make gauge charts in Julia with Plotly.
    display_as: financial
    language: julia
    layout: base
    name: Indicators
    order: 6
    page_type: example_index
    permalink: julia/indicator/
    thumbnail: thumbnail/indicator.jpg
---

#### Overview

In this tutorial we introduce a new trace named "Indicator". The purpose of "indicator" is to visualize a single value specified by the "value" attribute.
Three distinct visual elements are available to represent that value: number, delta and gauge. Any combination of them can be specified via the "mode" attribute.
Top-level attributes are:

1. value: the value to visualize
1. mode: which visual elements to draw
1. align: how to align number and delta (left, center, right)
1. domain: the extent of the figure


Then we can configure the 3 different visual elements via their respective container:

1. number is simply a representation of the number in text. It has attributes:
1. valueformat: to format the number
1. prefix: a string before the number
1. suffix: a string after the number
1. font.(family|size): to control the font

"delta" simply displays the difference between the value with respect to a reference. It has attributes:

1. reference: the number to compare the value with
1. relative: whether that difference is absolute or relative
1. valueformat: to format the delta
1. (increasing|decreasing).color: color to be used for positive or decreasing delta
1. (increasing|decreasing).symbol: symbol displayed on the left of the delta
1. font.(family|size): to control the font
1. position: position relative to `number` (either top, left, bottom, right)

Finally, we can have a simple title for the indicator via `title` with 'text' attribute which is a string, and 'align' which can be set to left, center, and right.
There are two gauge types: [angular](https://plotly.com/julia/gauge-charts/) and [bullet](https://plotly.com/julia/bullet-charts/). Here is a combination of both shapes (angular, bullet), and different modes (gauge, delta, and value):

```julia
using PlotlyJS


trace1 = indicator(
    value=200,
    delta_reference=160,
    gauge_axis_visible=false,
    domain=attr(row=0, column=0)
)

trace2 = indicator(
    value=120,
    gauge=attr(shape="bullet", axis=_visible=false),
    domain=attr(x=[0.05, 0.5], y=[0.15, 0.35])
)

trace3 = indicator(
    mode="number+delta",
    value=300,
    domain=attr(row=0, column=1)
)

trace4 = indicator(
    mode="delta",
    value=40,
    domain=attr(row=1, column=1)
)

layout = Layout(
    grid=attr(rows=2, columns=2, pattern="independent"),
    template=Template(data=attr(
        indicator=[attr(
            title_text="Speed",
            mode="number+delta+gauge",
            delta_reference=90
        )]
    ))
)
plot([trace1, trace2, trace3, trace4], layout)
```

#### A Single Angular Gauge Chart

```julia
using PlotlyJS

plot(indicator(
    mode="gauge+number",
    value=450,
    title=attr(text="Speed"),
    domain=attr(x=[0, 1], y=[0, 1])
))
```

##### Bullet Gauge

The equivalent of above "angular gauge":

```julia
using PlotlyJS

plot(indicator(
    mode="number+gauge+delta",
    gauge=attr(shape="bullet"),
    delta=attr(reference=300),
    value=220,
    domain=attr(x=[0.1, 1], y=[0.2, 0.9]),
    title=attr(text="Avg order size")
))

```

#### Showing Information above Your Chart

Another interesting feature is that indicator trace sits above the other traces (even the 3d ones). This way, it can be easily used as an overlay as demonstrated below

```julia
using PlotlyJS

trace = indicator(
    mode="number+delta",
    value=492,
    delta=attr(reference=512, valueformat=".0f"),
    title_text="Users online",
    domain=attr(y=[0, 1], x=[0.25, 0.75])
)

trace2 = scatter(
    y=[325, 324, 405, 400, 424, 404, 417, 432, 419, 394, 410, 426, 413, 419, 404, 408, 401, 377, 368, 361, 356, 359, 375, 397, 394, 418, 437, 450, 430, 442, 424, 443, 420, 418, 423, 423, 426, 440, 437, 436, 447, 460, 478, 472, 450, 456, 436, 418, 429, 412, 429, 442, 464, 447, 434, 457, 474, 480, 499, 497, 480, 502, 512, 492])

layout = Layout(xaxis_range=[0, 62])
plot([trace, trace2], layout)
```

#### Data Cards / Big Numbers

Data card helps to display more contextual information about the data. Sometimes one number is all you want to see in a report, such as total sales, annual revenue, etc. This example shows how to visualize these big numbers:

```julia
using PlotlyJS

trace1 = indicator(
    mode="number+delta",
    value=400,
    number=_prefix="\$",
    delta=attr(position="top", reference=320),
    domain=attr(x=[0, 1], y=[0, 1])
)

layout = Layout(paper_bgcolor="lightgray")

plot(trace1, layout)
```

#### It's possible to display several numbers

```julia
using PlotlyJS

trace1 = indicator(
    mode="number+delta",
    value=200,
    domain=attr(x=[0, 0.5], y=[0, 0.5]),
    delta=attr(reference=400, relative=true, position="top")
)

trace2 = indicator(
    mode="number+delta",
    value=350,
    delta=attr(reference=400, relative=true),
    domain=attr(x=[0, 0.5], y=[0.5, 1])
)

trace3 = indicator(
    mode="number+delta",
    value=450,
    title_text="Accounts<br><span style='font-size:0.8em;color:gray'>Subtitle</span><br><span style='font-size:0.8em;color:gray'>Subsubtitle</span>",
    delta=attr(reference=400, relative=true),
    domain=attr(x=[0.6, 1], y=[0, 1])
)

plot([trace1, trace2, trace3])
```

#### Reference

See https://plotly.com/julia/reference/indicator/ for more information and chart attribute options!
