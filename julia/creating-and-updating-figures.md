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
    description: Creating and Updating Plots with Plotly's Julia graphing library
    display_as: file_settings
    language: julia
    layout: base
    name: Creating and Updating Plots
    order: 2
    page_type: example_index
    permalink: julia/creating-and-updating-figures/
    redirect_from:
      - julia/user-guide/
      - julia/user-g/
    thumbnail: thumbnail/creating-and-updating-figures.png
    v4upgrade: true
---

The `PlotlyJS.jl` Julia package exists to create, manipulate and render graphical figures (i.e. charts, plots, maps and diagrams) represented by [data structures also referred to as plots](/julia/figure-structure/). The rendering process uses the [Plotly.js JavaScript library](https://plotly.com/javascript/) under the hood although Python developers using this module very rarely need to interact with the Javascript library directly, if ever. Figures are represented in Julia by individual trace type objects, and are serialized as text in [JavaScript Object Notation (JSON)](https://json.org/) before being passed to Plotly.js.

In general, below we will use the names `fig` and `p` to refer to plots creatd with the `plot` method.

### Plots via Trace Methods

The Julia PlotlyJS library provides methods for each trace type.

These trace methods have several benefits:

1. Properties of plots can be accessed using both Dict-style key lookup (e.g. `fig[:layout]`) or property access style lookup (e.g. `fig.layout`).
2. Plots support higher-level convenience functions for making updates to already constructed Plots (`relayout!()`, `add_trace!()` etc) as described below.
3. The trace methods and update methods accept "magic underscores" (e.g. `plot(Layout(title_text="The Title"))` rather than `Dict(:layout => Dict(:title => Dict(:text => "The Title")))`) for more compact code, as described below.
4. Plots automatically know how to render themselves in your computing environment. When plotting from the REPL, a dedicated plot window will be used. Inside VS Code, the Julia Plot pane will show Plots. In a Juptyer environment, plots will render in output area of cells. Finally, the `savefig` method can be used to render a plot to a static file such as a png, pdf, svg, etc.

Below you can find an example of one way that the plot in the example above could be specified using a the `plot`, `bar`, and `Layout` functions.

```julia
using PlotlyJS, JSON

fig = plot(bar(x=[1,2,3], y=[1,3,2]), Layout(title_text="A Plot"))
```

##### Converting Plots to JSON

Traces can be converted to the JSON string representation using the `JSON.json` method.

```julia
using PlotlyJS, JSON

fig = plot(
    bar(x=[1, 2, 3], y=[1, 3, 2]),
    Layout(height=600, width=800, template=attr())
)

# json will return a string. Let's print it -- the `, 2` makes it pretty
println(json(fig, 2))
```

### Creating Plots

This section summarizes several ways to create new plots, traces, and layouts with the `PlotlyJS` graphing library.

```julia
using PlotlyJS, CSV, DataFrames, JSON

df = dataset(DataFrame, "iris")
trace = scatter(df, x=:sepal_width, y=:sepal_length, group=:species)

# If you print the trace, you'll see that it's just a regular trace
JSON.print(trace, 2)
```

#### Make Subplots

The `make_subplots()` function produces a plot that is preconfigured with a grid of subplots that traces can be added to. The `add_trace!()` function will be discussed more below.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2)

add_trace!(fig, scatter(y=[4, 2, 1], mode="lines"), row=1, col=1)
add_trace!(fig, bar(y=[2, 1, 3]), row=1, col=2)

fig
```

### Updating Plots

Regardless of how a plot was constructed, it can be updated by adding additional traces to it and modifying its properties.

#### Adding Traces

New traces can be added to a plot using the `add_trace!()` function. This function accepts a trace (an instance of `scatter`, `bar`, etc.) and adds it to the Plot. This allows you to start with an empty Plot, and add traces to it sequentially.

```julia
using PlotlyJS

fig = plot()

add_trace!(fig, bar(x=[1, 2, 3], y=[1, 3, 2]))

fig
```

#### Adding Traces To Subplots

If a Plot was created using `make_subplots()`, then supplying the `row` and `col` arguments to `add_trace!()` can be used to add a trace to a particular subplot.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2)

add_trace!(fig, scatter(y=[4, 2, 1], mode="lines"), row=1, col=1)
add_trace!(fig, bar(y=[2, 1, 3]), row=1, col=2)

fig
```

This also works for plots created using the `plot(::DataFrame, args...; kwargs...)` method, using the `facet_row` and or `facet_col` keyword arguments.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(df, kind="scatter", mode="markers", x=:sepal_width, y=:sepal_length, color=:species, facet_col=:species,
                 Layout(title="Adding Traces To Subplots Witin A Plot"))

reference_line = scatter(x=[2, 4],
                            y=[4, 8],
                            mode="lines",
                            line_color="gray",
                            showlegend=false)

add_trace!(fig, reference_line, row=1, col=1)
add_trace!(fig, reference_line, row=1, col=2)
add_trace!(fig, reference_line, row=1, col=3)

fig
```

#### Magic Underscore Notation

To make it easier to work with nested properties, trace constructors and many plot manipulation methods support magic underscore notation.

This allows you to reference nested properties by joining together multiple nested property names with underscores.

For example, specifying the figure title in the Layout constructor _without_ magic underscore notation requires setting the `layout` argument to `attr(title=attr(text="A Chart"))`.

Similarly, setting the line color of a scatter trace requires setting the `marker` property to `attr(color="crimson")`.

```julia
using PlotlyJS

plot(
    scatter(
        y=[1, 3, 2],
        line=attr(color="crimson")
    ),
    Layout(
        title=attr(text="A Plot Without Magic Underscore Notation")
    )
)


```

With magic underscore notation, you can accomplish the same thing by passing the Layout constructor a keyword argument named `title_text`, and by passing the `scatter` constructor a keyword argument named `line_color`.

```julia
using PlotlyJS

plot(
    scatter(
        y=[1, 3, 2],
        line_color="crimson"
    ),
    Layout(
        title_text="A Plot With Magic Underscore Notation"
    )
)

```

Magic underscore notation is supported throughout the package, and it can often significantly simplify operations involving deeply nested properties.

> Note: When you see keyword arguments with underscores passed to a graph object constructor or method, it is almost always safe to assume that it is an application of magic underscore notation. We have to say "almost always" rather than "always" because there are a few property names in the plotly schema that contain underscores: error_x, error_y, error_z, copy_xstyle, copy_ystyle, copy_zstyle, paper_bgcolor, and plot_bgcolor. These were added back in the early days of the library (2012-2013) before we standardized on banning underscores from property names. However, PlotlyJS.jl is aware of these few proeprties and will handle them appropriately.

#### Updating Layouts

Plots support a `relayout!(::Plot; kwargs...)` method that may be used to update multiple nested properties of a Plot's layout.

Here is an example of updating the text and font size of a Plot's title using `relayout!()`.

```julia
using PlotlyJS

fig = plot(bar(x=[1, 2, 3], y=[1, 3, 2]))

relayout!(
    fig, 
    title=attr(text="Using relayout!() With Plots",font_size=30)
)

fig
```

Note that the following `relayout!()` operations are equivalent:

```julia
relayout!(fig, title_text="relayout!() Syntax Example",
                  title_font_size=30)

relayout!(fig, title_text="relayout!() Syntax Example",
                  title_font=attr(size=30))


relayout!(fig, title=attr(text="relayout!() Syntax Example"),
                             font=attr(size=30))
                             
relayout!(fig, title=attr(text="relayout!() Syntax Example", font_size=30))
```

#### Updating Traces

Traces can be updated using the `resytle!` function

To show some examples, we will start with a Plot that contains `bar` and `scatter` traces across two subplots.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2, specs=fill(Spec(kind="scatter"), 1,2))

add_trace!(fig, scatter(y=[4, 2, 3.5], mode="markers",
                marker=attr(size=20, color="LightSeaGreen"),
                name="a"), row=1, col=1)

add_trace!(fig, bar(y=[2, 1, 3],
            marker=attr(color="MediumPurple"),
            name="b"), row=1, col=1)

add_trace!(fig, scatter(y=[2, 3.5, 4], mode="markers",
                marker=attr(size=20, color="MediumPurple"),
                name="c"), row=1, col=2)

add_trace!(fig, bar(y=[1, 3, 2],
            marker=attr(color="LightSeaGreen"),
            name="d"), row=1, col=2)

fig
```

Note that both `scatter` and `bar` traces have a `marker.color` property to control their coloring. Here is an example of looping through `fig.plot.data` to modify the color of all traces.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2)

add_trace!(fig, scatter(y=[4, 2, 3.5], mode="markers",
                marker=attr(size=20, color="LightSeaGreen"),
                name="a"), row=1, col=1)

add_trace!(fig, bar(y=[2, 1, 3],
            marker=attr(color="MediumPurple"),
            name="b"), row=1, col=1)

add_trace!(fig, scatter(y=[2, 3.5, 4], mode="markers",
                marker=attr(size=20, color="MediumPurple"),
                name="c"), row=1, col=2)

add_trace!(fig, bar(y=[1, 3, 2],
            marker=attr(color="LightSeaGreen"),
            name="d"), row=1, col=2)

restyle!(fig, marker_color="RoyalBlue")

fig
```

If we wanted to only change the marker color for specific traces, we can use the `restyle(::Plot, index::Union{Int,Vector{Int}}; kwargs...)` where the `index` argument specifies which trace(s) to update.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2)

add_trace!(fig, scatter(y=[4, 2, 3.5], mode="markers",
                marker=attr(size=20, color="LightSeaGreen"),
                name="a"), row=1, col=1)

add_trace!(fig, bar(y=[2, 1, 3],
            marker=attr(color="MediumPurple"),
            name="b"), row=1, col=1)

add_trace!(fig, scatter(y=[2, 3.5, 4], mode="markers",
                marker=attr(size=20, color="MediumPurple"),
                name="c"), row=1, col=2)

add_trace!(fig, bar(y=[1, 3, 2],
            marker=attr(color="LightSeaGreen"),
            name="d"), row=1, col=2)

# set scatters to blue
restyle!(fig, [1, 3], marker_color="RoyalBlue")

# first bar to purple
restyle!(fig, 2, marker_color="purple")

# second bar to orange
restyle!(fig, 4, marker_color="orange")

fig
```

#### Conditionally Updating Traces

Suppose the updates that you want to make to a collection of traces depend on the current values of certain trace properties.

You can accomplish this by conditionalty changing the attributes:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(kine="scatter", mode="markers", df, x=:sepal_width, y=:sepal_length, group=:species,
                 title="Conditionally Updating Traces in a Plot")

for (i, trace) in enumerate(fig.plot.data)
    if trace.name == "setosa"
        restyle!(fig, i, marker_symbol="square")
    end
end

fig
```

#### Updating Layout properties

Plots support `update_xaxes!()` and `update_yaxes!()` methods that may be used to update multiple nested properties of one or more of a plot's axes. Here is an example of using `update_xaxes!()` to disable the vertical grid lines across all subplots in a Plot produced the `plot(::DataFrame, ...)` method.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(df, kind="scatter", mode="markers", x=:sepal_width, y=:sepal_length, color=:species,
                 facet_col=:species, Layout(title="Using update_xaxes!()"))

update_xaxes!(fig, showgrid=false)

fig
```

In addition to `update_xaxes!` there are also methods  `update_{type}!` where `type` can be any of `yaxes`, `geos`, `mapboxes`, `polars`, `scenes`, `ternaries`, `annotations`, `shapes`, and `images`.

### Methods to add items

Plots created with the PlolyJS.jl graphing library also support a number of methods to add features to a plot:

- `add_hrect!`, `add_vrect!`: add a horizontal or veritcal rectangle to a chart
- `add_hline!`, `add_vline!`: add a horizontal or veritcal line to a chart
- `add_shape!`: add an arbitrary shape (one of `line`, `circle`, or `rect`)
- `add_layout_image!`: 

Note that all these methods are subplot aware. So if you created the plot using `make_subplots` or using `plot(::DataFrame)` you can call `add_SOMETHING!(args...; row=row, col=col)`
