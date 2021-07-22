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
    description: How to configure and style the legend in Plotly with Julia.
    display_as: file_settings
    language: julia
    layout: base
    name: Legends
    order: 15
    permalink: julia/legend/
    redirect_from: julia/horizontal-legend/
    thumbnail: thumbnail/legends.gif
---

### Trace Types, Legends and Color Bars

[Traces](/julia/figure-structure) of most types can be optionally associated with a single legend item in the [legend](/julia/legend/). Whether or not a given trace appears in the legend is controlled via the `showlegend` attribute. Traces which are their own subplots (see above) do not support this, with the exception of traces of type `pie` and `funnelarea` for which every distinct color represented in the trace gets a separate legend item. Users may show or hide traces by clicking or double-clicking on their associated legend item. Traces that support legend items also support the `legendgroup` attribute, and all traces with the same legend group are treated the same way during click/double-click interactions.

The fact that legend items are linked to traces means that when using [discrete color](/julia/discrete-color/), a figure must have one trace per color in order to get a meaningful legend. [Plotly Express has robust support for discrete color](/julia/discrete-color/) to make this easy.

Traces which support [continuous color](/julia/colorscales/) can also be associated with color axes in the layout via the `coloraxis` attribute. Multiple traces can be linked to the same color axis. Color axes have a legend-like component called color bars. Alternatively, color axes can be configured within the trace itself.

### Legends

PlotlyJS functions will create one [trace](/julia/figure-structure) per animation frame for each unique combination of data values mapped to discrete color, symbol, line-dash, facet-row and/or facet-column. Traces' `legendgroup` and `showlegend` attributed are set such that only one legend item appears per unique combination of discrete color, symbol and/or line-dash. The legend title is automatically set, and can be overrided within the `Layout`:

<!-- TODO: Can't get marker symbol to bind to data -->

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(
    df,
    x=:total_bill,
    y=:tip,
    group=:sex,
    marker_symbol=:smoker,
    facet_col=:time,
    kind="scatter",
    mode="markers",
    Layout(
        legend_title_text="Gender",

    )
)
```

### Legend Order

By default, Plotly lays out legend items in the order in which values appear in the underlying data. Every function also includes a `category_orders` keyword argument which can be used to control [the order in which categorical axes are drawn](/julia/categorical-axes/), but beyond that can also control the order in which legend items appear, and [the order in which facets are laid out](/julia/facet-plots/).

<!-- TODO: This doesn't make the exact same graph as python...colors are different and can't set category_order -->

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(
    df,
    x=:day,
    y=:total_bill,
    group=:smoker,
    facet_col=:sex,
    marker_symbol=:smoker,
    kind="bar",
    barmode="group",
    Layout(
        category_orders=attr(day= ["Thur", "Fri", "Sat", "Sun"],
                              smoker=["Yes", "No"],
                              sex= ["Male", "Female"])
    )
)
```

When using stacked bars, the bars are stacked from the bottom in the same order as they appear in the legend, so it can make sense to set `layout.legend.traceorder` to `"reversed"` to get the legend and stacks to match:

<!-- TODO: Can't set bar mode stack and use color. `color` doesn't actually change it -->

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(
    df,
    x=:day,
    y=:total_bill,
    facet_col=:sex,
    marker_symbol=:smoker,
    color=:smoker,
    kind="bar",
    barmode="stack",
     Layout(
        category_orders=attr(day= ["Thur", "Fri", "Sat", "Sun"],
                              smoker=["Yes", "No"],
                              sex= ["Male", "Female"])
    )
)
```

When using specific trace methods rather than `plot`, legend items will appear in the order that traces appear in the `data`:

```julia
using PlotlyJS
trace1 = bar(name="first", x=["a", "b"], y=[1,2])
trace2 = bar(name="second", x=["a", "b"], y=[2,1])
trace3 = bar(name="third", x=["a", "b"], y=[1,2])
trace4 = bar(name="fourth", x=["a", "b"], y=[2,1])

plot([trace1, trace2, trace3, trace4])
```

_New in v5.0_

The `legendrank` attribute of a trace can be used to control its placement within the legend, without regard for its placement in the `data` list.

The default `legendrank` for traces is 1000 and ties are broken as described above, meaning that any trace can be pulled up to the top if it is the only one with a legend rank less than 1000 and pushed to the bottom if it is the only one with a rank greater than 1000.

```julia

using PlotlyJS
trace1 = bar(name="fourth", x=["a", "b"], y=[2,1], legendrank=4)
trace2 = bar(name="second", x=["a", "b"], y=[2,1], legendrank=2)
trace3 = bar(name="first", x=["a", "b"], y=[1,2], legendrank=1)
trace4 = bar(name="third", x=["a", "b"], y=[1,2], legendrank=3)

plot([trace1, trace2, trace3, trace4])
```

#### Showing and Hiding the Legend

By default the legend is displayed on Plotly charts with multiple traces, and this can be explicitly set with the `layout.showlegend` attribute:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

plot(
    df,
    x=:sex,
    y=:total_bill,
    group=:time,
    kind="histogram",
    Layout(
        title="Total Bill by Sex, Colored by Time",
        showlegend=false,
        barmode="stack"
    )
)
```

### Legend Positioning

Legends have an anchor point, which can be set to a point within the legend using `layout.legend.xanchor` and `layout.legend.yanchor`. The coordinate of the anchor can be positioned with `layout.legend.x` and `layout.legend.y` in [paper coordinates](/julia/figure-structure/). Note that the plot margins will grow so as to accommodate the legend. The legend may also be placed within the plotting area.

```julia
using PlotlyJS, DataFrames, CSV

df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007,: ]

layout = Layout(
    legend=attr(
        x=0,
        y=1,
    ),
    xaxis_type="log"
)

plot(df_2007,
    x=:gdpPercap,
    y=:lifeExp,
    group=:continent,
    marker=attr(
        size=:pop,
        sizemode="area",
        sizeref=2 * maximum(df_2007.pop) / (45^2),
        sizemin=4
    ),
    kind="scatter",
    mode="markers",
    text=:country,
    layout
)

```

#### Horizontal Legends

The `layout.legend.orientation` attribute can be set to `"h"` for a horizontal legend. Here we also position it above the plotting area.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007,: ]

layout = Layout(
    legend=attr(
        x=1,
        y=1.02,
        yanchor="bottom",
        xanchor="right",
        orientation="h"
    ),
    xaxis_type="log"
)

plot(df_2007,
    x=:gdpPercap,
    y=:lifeExp,
    group=:continent,
    marker=attr(
        size=:pop,
        sizemode="area",
        sizeref=2 * maximum(df_2007.pop) / (45^2),
        sizemin=4
    ),
    kind="scatter",
    mode="markers",
    text=:country,
    layout
)
```

#### Styling Legends

Legends support many styling options.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007,: ]

layout = Layout(
    legend=attr(
        x=0,
        y=1,
        traceorder="reversed",
        title_font_family="Times New Roman",
        font=attr(
            family="Courier",
            size=12,
            color="black"
        ),
        bgcolor="LightSteelBlue",
        bordercolor="Black",
        borderwidth=2
    ),
    xaxis_type="log"
)

plot(df_2007,
    x=:gdpPercap,
    y=:lifeExp,
    group=:continent,
    marker=attr(
        size=:pop,
        sizemode="area",
        sizeref=2 * maximum(df_2007.pop) / (45^2),
        sizemin=4
    ),
    kind="scatter",
    mode="markers",
    text=:country,
    layout
)
```

### Legends with Graph Objects

When creating figures using individual trace methods, legends must be manually configured using some of the options below.

#### Legend Item Names

Legend items appear per trace, and the legend item name is taken from the trace's `name` attribute.

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[1, 2, 3, 4, 5],
    name="Positive"
)

trace2 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[5, 4, 3, 2, 1],
    name="Negative"
)

plot([trace1, trace2])
```

#### Legend titles

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[1, 2, 3, 4, 5],
    name="Increasing"
)

trace2 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[5, 4, 3, 2, 1],
    name="Decreasing"
)

plot([trace1, trace2], Layout(legend_title_text="Trend"))
```

### Hiding Legend Items

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[1, 2, 3, 4, 5],
    showlegend=false
)


trace2 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[5, 4, 3, 2, 1],
)

plot([trace1, trace2], Layout(showlegend=true))
```

#### Hiding the Trace Initially

Traces have a `visible` attribute. If set to `legendonly`, the trace is hidden from the graph implicitly. Click on the name in the legend to display the hidden trace.

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[1, 2, 3, 4, 5],
)


trace2 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[5, 4, 3, 2, 1],
    visible="legendonly"
)

plot([trace1, trace2])
```

#### Size of Legend Items

In this example [itemsizing](https://plotly.com/julia/reference/layout/#layout-legend-itemsizing) attribute determines the legend items symbols remain constant, regardless of how tiny/huge the bubbles would be in the graph.

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[1, 2, 3, 4, 5],
    mode="markers",
    marker_size = 10
)

trace2 = scatter(
    x=[1, 2, 3, 4, 5],
    y=[5, 4, 3, 2, 1],
    mode="markers",
    marker_size=100
)

plot([trace1, trace2], Layout(legend_itemsizing="constant"))
```

#### Grouped Legend Items

Grouping legend items together by setting the `legendgroup` attribute of traces causes their legend entries to be next to each other, and clicking on any legend entry in the group will show or hide the whole group. The `legendgrouptitle` attribute can be used to give titles to groups.

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3],
    y=[2, 1, 3],
    legendgroup="group",  # this can be any string, not just "group"
    legendgrouptitle_text="First Group Title",
    name="first legend group",
    mode="markers",
    marker=attr(color="Crimson", size=10)
)

trace2 = scatter(
    x=[1, 2, 3],
    y=[2, 2, 2],
    legendgroup="group",
    name="first legend group - average",
    mode="lines",
    line=attr(color="Crimson")
)

trace3 = scatter(
    x=[1, 2, 3],
    y=[4, 9, 2],
    legendgroup="group2",
    legendgrouptitle_text="Second Group Title",
    name="second legend group",
    mode="markers",
    marker=attr(color="MediumPurple", size=10)
)

trace4 = scatter(
    x=[1, 2, 3],
    y=[5, 5, 5],
    legendgroup="group2",
    name="second legend group - average",
    mode="lines",
    line=attr(color="MediumPurple")
)

plot([trace1,trace2, trace3, trace4], Layout(title="Try Clicking on the Legend Items!"))
```

You can also hide entries in grouped legends, preserving the grouped show/hide behaviour.

```julia
using PlotlyJS

trace1 = scatter(
    x=[1, 2, 3],
    y=[2, 1, 3],
    legendgroup="group",  # this can be any string, not just "group"
    legendgrouptitle_text="First Group Title",
    name="first legend group",
    mode="markers",
    marker=attr(color="Crimson", size=10)
)

trace2 = scatter(
    x=[1, 2, 3],
    y=[2, 2, 2],
    legendgroup="group",
    name="first legend group - average",
    mode="lines",
    line=attr(color="Crimson"),
    showlegend=false
)

trace3 = scatter(
    x=[1, 2, 3],
    y=[4, 9, 2],
    legendgroup="group2",
    legendgrouptitle_text="Second Group Title",
    name="second legend group",
    mode="markers",
    marker=attr(color="MediumPurple", size=10)
)

trace4 = scatter(
    x=[1, 2, 3],
    y=[5, 5, 5],
    legendgroup="group2",
    name="second legend group - average",
    mode="lines",
    line=attr(color="MediumPurple"),
    showlegend=false
)

plot([trace1,trace2, trace3, trace4], Layout(title="Try Clicking on the Legend Items!"))

```

### Legend items for continuous fields (2D and 3D)

Traces corresponding to 2D fields (e.g. `go.Heatmap`, `go.Histogram2d`) or 3D fields (e.g. `go.Isosurface`, `go.Volume`, `go.Cone`) can also appear in the legend. They come with legend icons corresponding to each trace type, which are colored using the same colorscale as the trace.

The example below explores a vector field using several traces. Note that you can click on legend items to hide or to select (with a double click) a specific trace. This will make the exploration of your data easier!

```julia
using PlotlyJS

# Define vector and scalar fields
r = range(0,stop=1,length=8)
x = [r,r,r]
y = [r,r,r]
z = [r,r,r]

# TODO: Can't get julia to call `sin` on a 2d matrix
# u = @. (sin(pi * x) * cos(pi * z))
# v = @. -2*sin(pi*y) * cos(2*pi*z)
# w = @. cos(pi*x)*sin(pi*z) + cos(pi*y)*sin(2*pi*z)
# magnitude = @. sqrt(u^2 + v^2 + w^2)
# mask1 = @. logical_and(y>=.4, y<=.6)
# mask2 = y>.6
```

#### Reference

See https://plotly.com/julia/reference/layout/#layout-legend for more information!
