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
      How to adjust axes properties in Julia - axes titles, styling and
      coloring axes and grid lines, ticks, tick labels and more.
    display_as: file_settings
    language: julia
    layout: base
    name: Axes
    order: 14
    permalink: julia/axes/
    thumbnail: thumbnail/axes.png
---

<!-- TODO: Not sure if links work -->

This tutorial explain how to set the properties of [2-dimensional Cartesian axes](/julia/figure-structure/#2d-cartesian-trace-types-and-subplots), namely [`layout.xaxis`](/julia/reference/layout/xaxis/) and [`layout.yaxis`](julia/reference/layout/xaxis/).

Other kinds of subplots and axes are described in other tutorials:

- [3D axes](/julia/3d-axes) The axis object is [`layout.Scene`](/julia/reference/layout/scene/)
- [Polar axes](/julia/polar-chart/). The axis object is [`layout.Polar`](/julia/reference/layout/polar/)
- [Ternary axes](/julia/ternary-plots). The axis object is [`layout.Ternary`](/julia/reference/layout/ternary/)
- [Geo axes](/julia/map-configuration/). The axis object is [`layout.Geo`](/julia/reference/layout/geo/)
- [Mapbox axes](/julia/mapbox-layers/). The axis object is [`layout.Mapbox`](/julia/reference/layout/mapbox/)
- [Color axes](/julia/colorscales/). The axis object is [`layout.Coloraxis`](/julia/reference/layout/coloraxis/).

**See also** the tutorials on [facet plots](/julia/facet-plots/), [subplots](/julia/subplots) and [multiple axes](/julia/multiple-axes/).

### 2-D Cartesian Axis Types and Auto-Detection

The different types of Cartesian axes are configured via the `xaxis.type` or `yaxis.type` attribute, which can take on the following values:

- `'linear'` as described in this page
- `'log'` (see the [log plot tutorial](/julia/log-plots/))
- `'date'` (see the [tutorial on timeseries](/julia/time-series/))
- `'category'` (see the [categorical axes tutorial](/julia/categorical-axes/))
- `'multicategory'` (see the [categorical axes tutorial](/julia/categorical-axes/))

The axis type is auto-detected by looking at data from the first [trace](/julia/figure-structure/) linked to this axis:

- First check for `multicategory`, then `date`, then `category`, else default to `linear` (`log` is never automatically selected)
- `multicategory` is just a shape test: is the array nested?
- `date` and `category`: require **more than twice as many distinct date or category strings as distinct numbers** in order to choose that axis type.
  - Both of these test an evenly-spaced sample of at most 1000 values

### Forcing an axis to be categorical

It is possible to force the axis type by setting explicitly `xaxis_type`. In the example below the automatic X axis type would be `linear` (because there are not more than twice as many unique strings as unique numbers) but we force it to be `category`.

```julia
using PlotlyJS

trace = bar(x=["a", "a", "b", 3], y = [1,2,3,4])
layout = Layout(xaxis_type="category")

plot(trace, layout)
```

#### General Axis properties

The different groups of Cartesian axes properties are

- title of the axis
- tick values (locations of tick marks) and tick labels. Tick labels and grid lines are placed at tick values.
- lines: grid lines (passing through tick values), axis lines, zero lines
- range of the axis
- domain of the axis

The examples on this page apply to axes of any type, but extra attributes are available for [axes of type `category`](/juliae/categorical-axes/) and [axes of type `date`](/julia/time-series/).

#### Set and Style Axes Title Labels

##### Set axis title text

Axis titles are automatically set to the column names when using `plot` and [using a data frame as input](/julia/px-arguments/).

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, y=:tip, marker_color=:sex, mode="markers", type="scatter")
```

Axis titles can also be overridden using the `[axis]_title` argument of Layout:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
layout = Layout(
    xaxis_title="Total Bill(\$)",
    yaxis_title="Tip (\$)",
    legend_title_text="Legend"
)
trace = scatter(
    df,
    x=:total_bill,
    y=:tip,
    group=:sex,
    mode="markers",
)

plot(trace, layout)
```

#### Moving Tick Labels Inside the Plot

The `ticklabelposition` attribute moves tick labels inside the plotting area, and modifies the auto-range behaviour to accommodate the labels.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
layout = Layout(ticklabelposition="inside top", title=missing)
trace = bar(df, x=:date, y=(df.GOOG .- 1))

plot(trace, layout)
```

##### Set axis title text with Graph Objects

Axis titles are set using the nested `title` property of the x or y axis. Here is an example of creating a new figure and using `Layout`, with magic underscore notation, to set the axis titles.

```julia
import plotly.express as px

trace = scatter(y=[1, 0], x=[0,1])

layout = Layout(xaxis_title="Time", yaxis_title="Value A")

plot(trace, layout)
```

### Set axis title position

This example sets `standoff` attribute to cartesian axes to determine the distance between the tick labels and the axis title. Note that the axis title position is always constrained within the margins, so the actual standoff distance is always less than the set or default value. By default [automargin](https://plotly.com/julia/setting-graph-size/#automatically-adjust-margins) is `True` in Plotly template for the cartesian axis, so the margins will be pushed to fit the axis title at given standoff distance.

```julia
using PlotlyJS

trace = scatter(
    mode = "lines+markers",
    y = [4, 1, 3],
    x = ["December", "January", "February"])

layout = Layout(
    xaxis=attr(
        tickangle=90,
        title_text = "Month",
        title_font_size=20,
        title_standoff=25
    ),
    yaxis=attr(
        title_text = "Temperature",
        title_standoff=25
    )
)

plot(trace, layout)
```

##### Set axis title font

Here is an example that configures the font family, size, and color for the axis titles in a figure created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

layout = Layout(
    xaxis = attr(
        title_text="sepal_width",
        title_font=attr(size=18, family="Courier", color="crimson")
    ),
    yaxis = attr(
        title_text="sepal_length",
        title_font=attr(size=18, family="Courier", color="crimson")
    )
)
# TODO: The xaxis title is not repeated for each of the facets like it is in Python
plot(df, x=:sepal_width, y=:sepal_length, facet_col=:species, mode="markers", kind="scatter", layout)
```

#### Tick Placement, Color, and Style

##### Toggling axis tick marks

Axis tick marks are disabled by default for the default `plotly` theme, but they can easily be turned on by setting the `ticks` axis property to `"inside"` (to place ticks inside plotting area) or `"outside"` (to place ticks outside the plotting area).

Here is an example of turning on inside x-axis and y-axis ticks in a faceted figure created using Plotly Express. Note how the `yaxis_col` argument to `Layout` is used to only turn on the y-axis ticks for the left-most subplot.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

layout = Layout(
    xaxis_ticks="inside",
    yaxis_ticks="index",
    yaxis_col=1
)
plot(df, x=:sepal_width, y=:sepal_length, facet_col=:species, kind="scatter", mode="markers",layout)

fig.show()
```

##### Set number of tick marks (and grid lines)

The approximate number of ticks displayed for an axis can be specified using the `nticks` axis property.

Here is an example of updating the y-axes of a figure created using Plotly Express to display approximately 20 ticks.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        yaxis = attr(
            tickmode="auto",
            nticks=20
        )
    ),
    kind="scatter",
     mode="markers"
)

```

##### Set start position and distance between ticks

The `tick0` and `dtick` axis properties can be used to control to placement of axis ticks as follows: If specified, a tick will fall exactly on the location of `tick0` and additional ticks will be added in both directions at intervals of `dtick`.

Here is an example of updating the y axis of a figure created using Plotly Express to position the ticks at intervals of 0.5, starting at 0.25.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    kind="scatter",
    mode="markers",
    Layout(
        yaxis = attr(
            dtick=0.5,
            tick0=0.25
        )
    ),
)
```

##### Set exact location of axis ticks

It is possible to configure an axis to display ticks at a set of predefined locations by setting the `tickvals` property to an array of positions.

Here is an example of setting the exact location of ticks on the y axes of a figure created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    kind="scatter",
    mode="markers",
    Layout(
        yaxis = attr(tickvals=[5.1, 5.9, 6.3, 7.5])
    ),
)

```

##### Style tick marks

As discussed above, tick marks are disabled by default in the default `plotly` theme, but they can be enabled by setting the `ticks` axis property to `"inside"` (to place ticks inside plotting area) or `"outside"` (to place ticks outside the plotting area).

The appearance of these tick marks can be customized by setting their length (`ticklen`), width (`tickwidth`), and color (`tickcolor`).

Here is an example of enabling and styling the tick marks of a faceted figure created using Plotly Express. Note how the `col` argument to `yaxis attr` is used to only turn on and style the y-axis ticks for the left-most subplot.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    kind="scatter",
    mode="markers",
    Layout(
        yaxis = attr(ticks="outside", tickwidth=2, tickcolor="crimson", ticklen=10, col=1),
        xaxis=attr(ticks="outside", tickwidth=2, tickcolor="crimson", ticklen=10)
    ),
)
```

##### Toggling axis labels

The axis tick mark labels can be disabled by setting the `showticklabels` axis property to `False`.

Here is an example of disabling tick labels in all subplots for a faceted figure created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    kind="scatter",
    mode="markers",
    Layout(
        yaxis = attr(showticklabels=false),
        xaxis=attr(showticklabels=false)
    ),
)
```

##### Set axis label rotation and font

The orientation of the axis tick mark labels is configured using the `tickangle` axis property. The value of `tickangle` is the angle of rotation, in the clockwise direction, of the labels from vertical in units of degrees. The font family, size, and color for the tick labels are stored under the `tickfont` axis property.

Here is an example of rotating the x-axis tick labels by 45 degrees, and customizing their font properties, in a faceted histogram figure created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
layout = Layout(
    xaxis=attr(tickangle=45, tickfont=attr(family="Rockwell", color="crimson", size=14))
)
plot(df, x=:sex, y=:tip, histfunc="sum", facet_col="smoker", type="histogram", layout)

```

#### Enumerated Ticks with Tickvals and Ticktext

The `tickvals` and `ticktext` axis properties can be used together to display custom tick label text at custom locations along an axis. They should be set to lists of the same length where the `tickvals` list contains positions along the axis, and `ticktext` contains the strings that should be displayed at the corresponding positions.

Here is an example.

```julia
using PlotlyJS, CSV, HTTP, Dates

# Load and filter Apple stock data for 2016
apple_df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

apple_df_2016 = apple_df[year.(apple_df.Date) .== 2016, :]

layout = Layout(
    # Set custom x-axis labels
    xaxis=attr(
        tickmode="array",
        ticktext=["End of Q1", "End of Q2", "End of Q3", "End of Q4"],
        tickvals=[Date("2016-04-01"), Date("2016-07-01"), Date("2016-10-01"), maximum(apple_df_2016.Date)],
    ),
    # Prefix y-axis tick labels with dollar sign
    yaxis_tickprefix="\$",
    # Set figure title
    title_text = "Apple Stock Price"
)
# Create figure and add line
plot(
    apple_df_2016,
    x=:Date,
    y=apple_df_2016[!, "AAPL.High"],
    kind="scatter",
    mode="lines",
    layout
)

```

### Axis lines: grid and zerolines

##### Toggling Axis grid lines

Axis grid lines can be disabled by setting the `showgrid` property to `False` for the x and/or y axis.

Here is an example of setting `showgrid` to `False` in the graph object figure constructor.

```julia
using PlotlyJS

plot(scatter(
    mode="lines",
    y=[1, 0],
    x=[0,1]
    ),
    Layout(
        xaxis_showgrid=false,
        yaxis_showgrid=false
    )
)
```

##### Toggling Axis zero lines

The lines passing through zero can be disabled as well by setting the `zeroline` axis property to `False`

```julia
using PlotlyJS

plot(scatter(
    mode="lines",
    y=[1, 0],
    x=[0,1]
    ),
    Layout(
        xaxis_showgrid=false,
        xaxis_zeroline=false,
        yaxis_showgrid=false,
        yaxis_zeroline=false
    )
)
```

#### Styling and Coloring Axes and the Zero-Line

##### Styling axis lines

The `showline` axis property controls the visibility of the axis line, and the `linecolor` and `linewidth` axis properties control the color and width of the axis line.

Here is an example of enabling the x and y axis lines, and customizing their width and color, for a faceted histogram created with Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

layout = Layout(
    yaxis =attr(showline=true, linewidth=2, linecolor="black"),
    xaxis =attr(showline=true, linewidth=2, linecolor="black")

)
plot(df, x=:sex, y=:tip, histfunc="sum", facet_col=:smoker, kind="histogram", layout)
```

##### Mirroring axis lines

Axis lines can be mirrored to the opposite side of the plotting area by setting the `mirror` axis property to `True`.

Here is an example of mirroring the x and y axis lines in a faceted histogram created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

layout = Layout(
    yaxis =attr(showline=true, linewidth=2, linecolor="black", mirror=true),
    xaxis =attr(showline=true, linewidth=2, linecolor="black", mirror=true)

)
plot(df, x=:sex, y=:tip, histfunc="sum", facet_col=:smoker, kind="histogram", layout)
```

##### Styling grid lines

The width and color of axis grid lines are controlled by the `gridwidth` and `gridcolor` axis properties.

Here is an example of customizing the grid line width and color for a faceted scatter plot created with Plotly Express

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

# TODO: xaxis_nticks only sets on first facet
plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        yaxis = attr(showgrid=true, gridwidth=1, gridcolor="LightPink"),
        xaxis = attr(showgrid=true, gridwidth=1, gridcolor="LightPink")
    ),
    kind="scatter",
    mode="markers"
)
```

##### Styling zero lines

The width and color of axis zero lines are controlled by the `zerolinewidth` and `zerolinecolor` axis properties.

Here is an example of configuring the zero line width and color for a simple figure using the `update_xaxes` and `update_yaxes` graph object figure methods.

```julia
using PlotlyJS

plot(scatter(y=[1, 0], x=[0,1]), Layout(
    xaxis=attr(zeroline=true, zerolinewidth=2, zerolinecolor="LightPink"),
    yaxis=attr(zeroline=true, zerolinewidth=2, zerolinecolor="LightPink")
))

```

#### Setting the Range of Axes Manually

The visible x and y axis range can be configured manually by setting the `range` axis property to a list of two values, the lower and upper boundary.

Here's an example of manually specifying the x and y axis range for a faceted scatter plot created with Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        xaxis_range=[1.5, 4.5],
        yaxis_range=[3, 9]
    ),
    kind="scatter",
    mode="markers"
)
```

#### Disabling Pan/Zoom on Axes (Fixed Range)

Pan/Zoom can be disabled for a given axis by setting `fixedrange` to `True`.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

# TODO: fixed_range doesn't work
plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        xaxis=attr(fixedrange=true),
    ),
    kind="scatter",
    mode="markers"
)
```

### Fixed Ratio Axes

The `scaleanchor` and `scaleratio` axis properties can be used to force a fixed ratio of pixels per unit between two axes.

Here is an example of anchoring the scale of the x and y axis with a scale ratio of 1. Notice how the zoom box is constrained to prevent the distortion of the shape of the line plot.

```julia
using PlotlyJS

layout = Layout(
    width = 800,
    height = 500,
    title = "fixed-ratio axes",
    yaxis = attr(
        scaleanchor = "x",
        scaleratio = 1,
    )
)
trace = scatter(
    x = [0,1,1,0,0,1,1,2,2,3,3,2,2,3],
    y = [0,0,1,1,3,3,2,2,3,3,1,1,0,0]
)

plot(trace, layout)
```

### Fixed Ratio Axes with Compressed domain

If an axis needs to be compressed (either due to its own `scaleanchor` and `scaleratio` or those of the other axis), `constrain` determines how that happens: by increasing the "range" (default), or by decreasing the "domain".

```julia
using PlotlyJS

layout = Layout(
    width = 800,
    height = 500,
    title =  "fixed-ratio axes with compressed axes",
    yaxis = attr(
        scaleanchor = "x",
        scaleratio = 1,
    ),
    xaxis = attr(
        range=[-1,4],
        constrain="domain"
    )
)

trace = scatter(
    x = [0,1,1,0,0,1,1,2,2,3,3,2,2,3],
    y = [0,0,1,1,3,3,2,2,3,3,1,1,0,0]
)

plot(trace, layout)
```

##### Decreasing the domain spanned by an axis

In the example below, the x and y axis are anchored together, and the range of the `xaxis` is set manually. By default, plotly extends the range of the axis (overriding the `range` parameter) to fit in the figure `domain`. You can restrict the `domain` to force the axis to span only the set range, by setting `constrain='domain'` as below.

```julia
using PlotlyJS

layout = Layout(
    width = 800,
    height = 500,
    title =  "fixed-ratio axes",
    yaxis = attr(
        range=(-0.5, 3.5),
        constrain="domain"
    ),
    xaxis = attr(
        scaleanchor = "x",
        scaleratio = 1,
    )
)

trace = scatter(
    x = [0,1,1,0,0,1,1,2,2,3,3,2,2,3],
    y = [0,0,1,1,3,3,2,2,3,3,1,1,0,0]
)

plot(trace, layout)
```

### Fixed Ratio Axes with Compressed domain

If an axis needs to be compressed (either due to its own `scaleanchor` and `scaleratio` or those of the other axis), `constrain` determines how that happens: by increasing the "range" (default), or by decreasing the "domain".

```julia
using PlotlyJS

layout = Layout(
    width = 800,
    height = 500,
    title =  "fixed-ratio axes",
    yaxis = attr(
        scaleanchor = "x",
        scaleratio = 1,
    ),
    xaxis = attr(
        range=[-1,4],  # sets the range of xaxis
        constrain="domain",  # meanwhile compresses the xaxis by decreasing its "domain"
    )
)

trace = scatter(
    x = [0,1,1,0,0,1,1,2,2,3,3,2,2,3],
    y = [0,0,1,1,3,3,2,2,3,3,1,1,0,0]
)

plot(trace, layout)
```

#### Reversed Axes

You can tell plotly's automatic axis range calculation logic to reverse the direction of an axis by setting the `autorange` axis property to `"reversed"`.

Here is an example of reversing the direction of the y axes for a faceted scatter plot created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        yaxis_autorange="reversed"
    ),
    kind="scatter",
    mode="markers"
)
```

#### Reversed Axes with Range ( Min/Max ) Specified

The direction of an axis can be reversed when manually setting the range extents by specifying a list containing the upper bound followed by the lower bound (rather that the lower followed by the upper) as the `range` axis property.

Here is an example of manually setting the reversed range of the y axes in a faceted scatter plot figure created using Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        yaxis_range=[9,3]
    ),
    kind="scatter",
    mode="markers"
)
```

### Axis range for log axis type

If you are using a `log` type of axis and you want to set the range of the axis, you have to give the `log10` value of the bounds.

```julia
using PlotlyJS

x = range(1, stop=200, length=30)
plot(scatter(
        x=x,
        y=x.^3,
        range_x=[0.8, 250],
        mode="markers"
    ),
    Layout(
        yaxis_type="log",
        xaxis_type="log",
        xaxis_range=[log10(0.8), log10(250)]
    )
)
```

#### <code>nonnegative</code>, <code>tozero</code>, and <code>normal</code> Rangemode

The axis auto-range calculation logic can be configured using the `rangemode` axis parameter.

If `rangemode` is `"normal"` (the default), the range is computed based on the min and max values of the input data. If `"tozero"`, the range will always include zero. If `"nonnegative"`, the range will not extend below zero, regardless of the input data.

Here is an example of configuring a faceted scatter plot created using Plotly Express to always include zero for both the x and y axes.

```julia
using PlotlyJS

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_width,
    y=:sepal_length,
    facet_col=:species,
    Layout(
        yaxis_range=[9,3]
    ),
    kind="scatter",
    mode="markers"
)
```

#### Setting the domain of the axis

```julia
using PlotlyJS


plot(scatter(
    x = [0,1,1,0,0,1,1,2,2,3,3,2,2,3],
    y = [0,0,1,1,3,3,2,2,3,3,1,1,0,0]
), Layout(
    yaxis_domain=(0.25, 0.75),
    xaxis_domain=(0.25,0.75)
))

```

#### Synchronizing axes in subplots with `matches`

Using `facet_col` from `plotly.express` let [zoom](https://help.plotly.com/zoom-pan-hover-controls/#step-3-zoom-in-and-zoom-out-autoscale-the-plot) and [pan](https://help.plotly.com/zoom-pan-hover-controls/#step-6-pan-along-axes) each facet to the same range implicitly. However, if the subplots are created with `make_subplots`, the axis needs to be updated with `matches` parameter to update all the subplots accordingly.

Zoom in one trace below, to see the other subplots zoomed to the same x-axis range. To pan all the subplots, click and drag from the center of x-axis to the side:

```julia
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import numpy as np

using PlotlyJS

N = 20
x = range(0, stop=1, length=N)

fig = make_subplots(rows=1, cols=3)
for i in 1:1:3
    add_trace!(fig, scatter(x=x, y=rand(N)), row=1, col=i)
end

fig

# TODO: Not sure how to update layout on a subplots fig
# fig.update_xaxes(matches='x')
```

#### Reference

See https://plotly.com/julia/reference/layout/xaxis/ and https://plotly.com/julia/reference/layout/yaxis/ for more information and chart attribute options!
