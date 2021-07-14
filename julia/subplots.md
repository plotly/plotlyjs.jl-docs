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
    description: How to make subplots in with Plotly's Julia graphing library. Examples
      of stacked, custom-sized, gridded, and annotated subplots.
    display_as: file_settings
    language: julia
    layout: base
    name: Subplots
    order: 17
    page_type: u-guide
    permalink: julia/subplots/
    thumbnail: thumbnail/subplots.jpg
---


#### Simple Subplot

Figures with subplots are created using Julia's array creation syntax. To create a Figure with one row and two columns of subplots, use the syntax `[plot(...) plot(...)]`

```julia
using PlotlyJS
p1 = plot(scatter(x=1:3, y=4:6))
p2 = plot(scatter(x=20:40, y=50:70))
p = [p1 p2]
relayout!(p, title_text="Side by side layout (1 x 2)")
p
```

#### Stacked Subplots

Here is an example of creating a figure with subplots that are stacked on top of each other since there are 3 rows and 1 column in the subplot layout.

```julia
using PlotlyJS

make_plot() = plot(scatter(x=1:4, y=rand(4)))
p = [make_plot(); make_plot(); make_plot()]
relayout!(p, height=600, width=600, title_text="Stacked Subplots")
p
```

#### Multiple Subplots

Here is an example of creating a 2 x 2 subplot grid and populating each subplot with a single `scatter` trace.

```julia
using PlotlyJS

make_plot() = plot(scatter(x=1:4, y=rand(4)))
[
    make_plot() make_plot()
    make_plot() make_plot()
]
```

Or, equivalently

```julia
using PlotlyJS

make_plot() = plot(scatter(x=1:4, y=rand(4)))
[make_plot() make_plot(); make_plot() make_plot()]
```

#### Multiple Subplots with Titles

To add titles to your subplots, add a title to the Layout of each original plot

Here is an example of adding subplot titles to a 2 x 2 subplot grid of scatter traces.

```julia
using PlotlyJS

make_scatter() = scatter(x=1:4, y=rand(4))
p1 = plot(make_scatter(), Layout(title="subplot 1"))
p2 = plot(make_scatter(), Layout(title="subplot 2"))
p3 = plot(make_scatter(), Layout(title="subplot 3"))
p4 = plot(make_scatter(), Layout(title="subplot 4"))

p = [p1 p2; p3 p4]
relayout!(p, height=500, width=700, title_text="Multiple Subplots with Titles")
p
```

### The `Subplots` type

The array construction pun is helpful for quickly creating grids of regularly spaced subplots.

To do more advanced subplot custimization, we have the `Subplots` type.

Using the `Subplots` you can control things like the relative size of subplots, created nested grids of subplots, share x or y axes, etc.

There are two usage patterns for using the `Subplots` type:

**Pattern 1**

The first pattern is to directly create an instance of `Subplots`, then create a `Layout`, then create an empty plot and add traces

```
using PlotlyJS

sp = Subplots(kwargs...)
layout = Layout(sp)
p = plot(layout)
add_trace!(p, ...)
```

**Pattern 2**

The second pattern is to use the `make_subplots` helper function that does that for you.

```
using PlotlyJS

p = make_subplots(kwargs....)
add_trace!(p, ...)
```

Note that `make_subplots` takes all the same arguments as `Subplots`.

Below are some examples of how this works.

#### Subplots with Shared X-Axes

The `shared_xaxes` argument to `make_subplots` can be used to link the x axes of subplots in the resulting figure. The `vertical_spacing` argument is used to control the vertical spacing between rows in the subplot grid.

Here is an example that creates a figure with 3 vertically stacked subplots with linked x axes. A small vertical spacing value is used to reduce the spacing between subplot rows.

```julia
using PlotlyJS

p = make_subplots(rows=3, cols=1, shared_xaxes=true, vertical_spacing=0.02)
add_trace!(p, scatter(x=0:2, y=10:12), row=3, col=1)
add_trace!(p, scatter(x=2:4, y=100:10:120), row=2, col=1)
add_trace!(p, scatter(x=3:5, y=1000:100:1200), row=1, col=1)
relayout!(p, title_text="Stacked Subplots with Shared X-Axes")
p
```

#### Subplots with Shared Y-Axes

The `shared_yaxes` argument to `make_subplots` can be used to link the y axes of subplots in the resulting figure.

Here is an example that creates a figure with a 2 x 2 subplot grid, where the y axes of each row are linked.

```julia
using PlotlyJS

p = make_subplots(rows=3, cols=2, shared_yaxes=true)
add_trace!(p, scatter(x=0:2, y=10:12), row=1, col=1)
add_trace!(p, scatter(x=20:10:40, y=1:3), row=1, col=2)
add_trace!(p, scatter(x=3:5, y=600:100:800), row=2, col=1)
add_trace!(p, scatter(x=3:5, y=1000:100:1200), row=2, col=2)
relayout!(p, title_text="Multiple Subplots with Shared Y-Axes")
p
```

#### Custom Sized Subplot with Subplot Titles

The `specs` argument to `make_subplots` is used to configure per-subplot options.  `specs` must be a `Matrix` with dimensions that match those provided as the `rows` and `cols` arguments. The elements of `specs` may either be `missing`, indicating no subplot should be initialized starting with this grid cell, or an instance of `Spec` containing subplot options.  The `colspan` subplot option specifies the number of grid columns that the subplot starting in the given cell should occupy.  If unspecified, `colspan` defaults to 1.

Here is an example that creates a 2 by 2 subplot grid containing 3 subplots.  The subplot `specs` element for position (2, 1) has a `colspan` value of 2, causing it to span the full figure width. The subplot `specs` element for position (2, 2) is `None` because no subplot begins at this location in the grid.

```julia
using PlotlyJS

p = make_subplots(
    rows=2, cols=2,
    specs=[Spec() Spec(); Spec(colspan=2) missing],
    subplot_titles=["First Subplot" "Second Subplot"; "Third Subplot" missing]
)

add_trace!(p, scatter(x=[1, 2], y=[1, 2]), row=1, col=1)
add_trace!(p, scatter(x=[1, 2], y=[1, 2]), row=1, col=2)
add_trace!(p, scatter(x=[1, 2, 3], y=[2, 1, 2]), row=2, col=1)

relayout!(p, showlegend=false, title_text="Specs with Subplot Title")
p
```

#### Multiple Custom Sized Subplots


Here is an example that uses the `rowspan` and `colspan` subplot options to create a custom subplot layout with subplots of mixed sizes. The `print_grid` argument is set to `True` so that the subplot grid is printed to the screen.

```julia
using PlotlyJS

p = make_subplots(
    rows=5, cols=2,
    specs=[Spec() Spec(rowspan=2)
           Spec() missing
           Spec(rowspan=2, colspan=2) missing
           missing missing
           Spec() Spec()]
)

add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(1,1)"), row=1, col=1)
add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(1,2)"), row=1, col=2)
add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(2,1)"), row=2, col=1)
add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(3,1)"), row=3, col=1)
add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(5,1)"), row=5, col=1)
add_trace!(p, scatter(x=[1, 2], y=[1, 2], name="(5,2)"), row=5, col=2)

relayout!(p, height=600, width=600, title_text="specs examples")
p
```

#### Subplots Types

By default, the `make_subplots` function assumes that the traces that will be added to all subplots are 2-dimensional cartesian traces (e.g. `scatter`, `bar`, `histogram`, `violin`, etc.).  Traces with other subplot types (e.g. `scatterpolar`, `scattergeo`, `parcoords`, etc.) are supported by specifying the `kind` subplot option in the `specs` argument to `make_subplots`.

Here are the possible values for the `kind` option:

 - `"xy"`: 2D Cartesian subplot type for scatter, bar, etc. This is the default if no `type` is specified.
 - `"scene"`: 3D Cartesian subplot for scatter3d, cone, etc.
 - `"polar"`: Polar subplot for scatterpolar, barpolar, etc.
 - `"ternary"`: Ternary subplot for scatterternary.
 - `"mapbox"`: Mapbox subplot for scattermapbox.
 - `"domain"`: Subplot type for traces that are individually positioned. pie, parcoords, parcats, etc.
 - trace type: A trace type name (e.g. `"bar"`, `"scattergeo"`, `"carpet"`, `"mesh"`, etc.) which will be used to determine the appropriate subplot type for that trace.

Here is an example that creates and populates a 2 x 2 subplot grid containing 4 different subplot types.

```julia
using PlotlyJS

p = make_subplots(
    rows=2, cols=2,
    specs=[
        Spec(kind="xy") Spec(kind="polar")
        Spec(kind="domain") Spec(kind="scene")
    ]
)

add_trace!(p, bar(y=[2, 3, 1]), row=1, col=1)
add_trace!(p, barpolar(theta=[0, 45, 90], r=[2, 3, 1]), row=1, col=2)
add_trace!(p, pie(values=[2, 3, 1]), row=2, col=1)
add_trace!(p,
    scatter3d(x=[2, 3, 1], y=[0, 0, 0], z=[0.5, 1, 2], mode="lines"),
    row=2, col=2
)

relayout!(p, height=700, showlegend=false)
```

### Low Level API

The third and last approach for creating subplots is to use the low level plotly.js api.

When using this API you explicitly place each of the axes on the figure and link them to one another.

You also are responsible for assigned traces to a particular pair of axes.

This is the most verbose of the methods for creating charts with multiple subplots, but it is also the most powerful.

The other methods (array creation syntax and `make_subplots`) use this API under the hood.

#### Side by Side Subplot (low-level API)

```julia
using PlotlyJS

plot(
    [
        scatter(x=1:3, y=4:6),
        scatter(x=20:10:30, y=50:10:70, xaxis="x2", yaxis="y2")
    ],
    Layout(xaxis_domain=[0, 0.7], xaxis2_domain=[0.8, 1], yaxis2_anchor="x2")
)
```

#### Subplots with shared axes (low-level API)

```julia
using PlotlyJS

plot(
    [
        scatter(x=1:3, y=4:6),
        scatter(x=20:10:30, y=[5, 5, 5], xaxis="x2", yaxis="y"),
        scatter(x=2:4, y=600:100:800, xaxis="x", yaxis="y3"),
        scatter(x=4000:1000:6000, y=7000:1000:9000, xaxis="x4", yaxis="y4"),
    ],
    Layout(
        xaxis_domain=[0, 0.45],
        yaxis_domain=[0, 0.45],
        xaxis2_domain=[0.55, 1],
        xaxis4=attr(domain=[0.55, 1], anchor="y4"),
        yaxis3_domain=[0.55, 1],
        yaxis4=attr(domain=[0.55, 1], anchor="x4")
    )
)
```

#### Stacked Subplots with a Shared X-Axis (low-level API)

```julia
using PlotlyJS

plot(
    [
        scatter(x=0:2, y=10:12),
        scatter(x=2:4, y=100:10:120, yaxis="y2"),
        scatter(x=3:5, y=1000:100:1200, yaxis="y3"),
    ],
    Layout(
        yaxis_domain=[0, 0.33],
        legend_traceorder="reversed",
        yaxis2_domain=[0.33, 0.66],
        yaxis3_domain=[0.66, 1]
    )
)
```


#### Reference
All of the x-axis properties are found here: https://plotly.com/julia/reference/XAxis/
All of the y-axis properties are found here: https://plotly.com/julia/reference/YAxis/

To get more help, see the docstring for `make_subplots`

```
using PlotlyJS

@doc make_subplots
```
