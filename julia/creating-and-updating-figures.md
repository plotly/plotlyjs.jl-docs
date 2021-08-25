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
    description: Creating and Updating Figures with Plotly's Julia graphing library
    display_as: file_settings
    language: julia
    layout: base
    name: Creating and Updating Figures
    order: 2
    page_type: example_index
    permalink: julia/creating-and-updating-figures/
    redirect_from:
      - julia/user-guide/
      - julia/user-g/
    thumbnail: thumbnail/creating-and-updating-figures.png
    v4upgrade: true
---

The `plotly` Julia package exists to create, manipulate and [render](/julia/renderers/) graphical figures (i.e. charts, plots, maps and diagrams) represented by [data structures also referred to as figures](/julia/figure-structure/). The rendering process uses the [Plotly.js JavaScript library](https://plotly.com/javascript/) under the hood although Python developers using this module very rarely need to interact with the Javascript library directly, if ever. Figures are represented in Julia by individual trace type objects, and are serialized as text in [JavaScript Object Notation (JSON)](https://json.org/) before being passed to Plotly.js.

### Figures via Trace Methods

The Julia PlotlyJS library provides methods for each trace type.

These trace methods have several benefits:

<!-- TODO: Spencer look at this section -->

1. They provide precise data validation. If you provide an invalid property name or an invalid property value as the key to a graph object, an exception will be raised with a helpful error message describing the problem.
2. Graph objects contain descriptions of each valid property as Julia docstrings, with a [full API reference available](https://plotly.com/julia/reference/). You can use these docstrings in the development environment of your choice to learn about the available properties as an alternative to consulting the online [Full Reference](/julia/reference/index/).
3. Properties of graph objects can be accessed using both dictionary-style key lookup (e.g. `fig["layout"]`) or class-style property access (e.g. `fig.layout`).
4. Graph objects support higher-level convenience functions for making updates to already constructed figures (`.update_layout()`, `.add_trace()` etc) as described below.
5. Graph object constructors and update methods accept "magic underscores" (e.g. `go.Figure(layout_title_text="The Title")` rather than `dict(layout=dict(title=dict(text="The Title")))`) for more compact code, as described below.
6. Graph objects support attached rendering (`.show()`) and exporting functions (`.write_image()`) that automatically invoke the appropriate functions from [the `plotly.io` module](https://plotly.com/python-api-reference/plotly.io.html).

Below you can find an example of one way that the figure in the example above could be specified using a graph object instead of a dictionary.

```julia
using PlotlyJS, JSON

fig = plot(bar(x=[1,2,3], y=[1,3,2]), Layout(title_text="A Figure"))
```

<!-- You can also create a graph object figure from a dictionary representation by passing the dictionary to the `go.Figure` constructor.

```python
import plotly.graph_objects as go

dict_of_fig = dict({
    "data": [{"type": "bar",
              "x": [1, 2, 3],
              "y": [1, 3, 2]}],
    "layout": {"title": {"text": "A Figure Specified By A Graph Object With A Dictionary"}}
})

fig = go.Figure(dict_of_fig)

fig
``` -->

##### Converting Plots to JSON

Traces can be converted to the JSON string representation using the `JSON.json` method.

```julia
import plotly.graph_objects as go

fig = plot(
    bar(x=[1, 2, 3], y=[1, 3, 2]),
    Layout(height=600, width=800, template=attr())
)

json(fig)
```

### Creating Figures

This section summarizes several ways to create new graph object figures with the `PlotlyJS` graphing library.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
trace = scatter(x=df.sepal_width, y=df.sepal_length, group=df.species)

# If you print the figure, you'll see that it's just a regular figure with data and layout
JSON.print(trace, 4)
```

<!-- TODO: Figure factories don't exist -->
<!--
#### Figure Factories

[Figure factories](/python/figure-factories) (included in `plotly.py` in the `plotly.figure_factory` module) are functions that produce graph object figures, often to satisfy the needs of specialized domains. Here's an example of using the `create_quiver()` figure factory to construct a graph object figure that displays a 2D quiver plot.

```python
import numpy as np
import plotly.figure_factory as ff

x1,y1 = np.meshgrid(np.arange(0, 2, .2), np.arange(0, 2, .2))
u1 = np.cos(x1)*y1
v1 = np.sin(x1)*y1

fig = ff.create_quiver(x1, y1, u1, v1)

fig
``` -->

#### Make Subplots

The `make_subplots()` function produces a graph object figure that is preconfigured with a grid of subplots that traces can be added to. The `add_trace!()` function will be discussed more below.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2, specs=[Spec(kind="scatter") Spec(kind="bar")])

add_trace!(fig, scatter(y=[4, 2, 1], mode="lines")), row=1, col=1
add_trace!(fig, bar(y=[2, 1, 3]), row=1, col=2)

fig
```

### Updating Figures

Regardless of how a graph object figure was constructed, it can be updated by adding additional traces to it and modifying its properties.

#### Adding Traces

New traces can be added to a graph object figure using the `add_trace!()` method. This method accepts a graph object trace (an instance of `scatter`, `bar`, etc.) and adds it to the figure. This allows you to start with an empty figure, and add traces to it sequentially.

```julia
using PlotlyJS

fig = plot()

add_trace!(fig, bar(x=[1, 2, 3], y=[1, 3, 2]))

fig
```

#### Adding Traces To Subplots

If a figure was created using `make_subplots()`, then supplying the `row` and `col` arguments to `add_trace!()` can be used to add a trace to a particular subplot.

```julia
using PlotlyJS

fig = make_subplots(rows=1, cols=2)

add_trace!(fig, scatter(y=[4, 2, 1], mode="lines")), row=1, col=1
add_trace!(fig, bar(y=[2, 1, 3]), row=1, col=2)

fig
```

This also works for figures created by Plotly Express using the `facet_row` and or `facet_col` arguments.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(df, kind="scatter", mode="markers", x=:sepal_width, y=:sepal_length, color=:species, facet_col=:species,
                 Layout(title="Adding Traces To Subplots Witin A Plotly Express Figure"))

reference_line = scatter(x=[2, 4],
                            y=[4, 8],
                            mode="lines",
                            line_color="gray",
                            showlegend=false)

add_trace!(fig, reference_line), row=1, col=1
add_trace!(fig, reference_line, row=1, col=2)
add_trace!(fig, reference_line, row=1, col=3)

fig
```

#### Magic Underscore Notation

To make it easier to work with nested properties, graph object constructors and many graph object methods support magic underscore notation.

This allows you to reference nested properties by joining together multiple nested property names with underscores.

For example, specifying the figure title in the figure constructor _without_ magic underscore notation requires setting the `layout` argument to `attr(title=dict(text="A Chart"))`.

Similarly, setting the line color of a scatter trace requires setting the `marker` property to `attr(color="crimson")`.

```julia
using PlotlyJS

plot(
    scatter(
        y=[1, 3, 2],
        line=attr(color="crimson")
    ),
    Layout(
        title=attr(text="A Graph Objects Figure Without Magic Underscore Notation")
    )
)


```

With magic underscore notation, you can accomplish the same thing by passing the figure constructor a keyword argument named `title_text`, and by passing the `scatter` constructor a keyword argument named `line_color`.

```julia
using PlotlyJS

plot(
    scatter(
        y=[1, 3, 2],
        line_color="crimson"
    ),
    Layout(
        title_text="A Graph Objects Figure Without Magic Underscore Notation"
    )
)

```

Magic underscore notation is supported throughout the package, and it can often significantly simplify operations involving deeply nested properties.

> Note: When you see keyword arguments with underscores passed to a graph object constructor or method, it is almost always safe to assume that it is an application of magic underscore notation. We have to say "almost always" rather than "always" because there are a few property names in the plotly schema that contain underscores: error_x, error_y, error_z, copy_xstyle, copy_ystyle, copy_zstyle, paper_bgcolor, and plot_bgcolor. These were added back in the early days of the library (2012-2013) before we standardized on banning underscores from property names.

#### Updating Figure Layouts

Graph object figures support an `relayout!()` method that may be used to update multiple nested properties of a figure's layout.

Here is an example of updating the text and font size of a figure's title using `relayout!()`.

```julia
import plotly.graph_objects as go

fig = plot(bar(x=[1, 2, 3], y=[1, 3, 2]))

relayout!(fig, title_text="Using relayout!() With Graph Object Figures",
                  title_font_size=30)

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
```

#### Updating Traces

Traces can be updated by iterating through `fig.plot.data`'s traces.

To show some examples, we will start with a figure that contains `bar` and `scatter` traces across two subplots.

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

for trace in fig.plot.data
    trace.marker[:color] = "RoyalBlue"
end

fig
```

<!-- TODO: these dont' get overwritten -->
<!-- ### Overwrite Existing Properties When Using Update Methods

`relayout!()` and `update_traces()` have an `overwrite` keyword argument, defaulting to False, in which case updates are applied recursively to the _existing_ nested property structure. When set to True, the prior value of existing properties is overwritten with the provided value.

In the example below, the red color of markers is overwritten when updating `marker` in `update_traces()` with `overwrite=True`. Note that setting instead `marker_opacity` with the magic underscore would not overwrite `marker_color` because properties would be overwritten starting only at the level of `marker.opacity`.

```julia
using PlotlyJS

fig = plot(bar(x=[1, 2, 3], y=[6, 4, 9],
                       marker_color="red")) # will be overwritten below

restyle!(fig, marker=attr(opacity=0.4), ovewrwrite=tr

fig
```
-->

<!-- TODO: No `for_each_trace` method -->

#### Conditionally Updating Traces

Suppose the updates that you want to make to a collection of traces depend on the current values of certain trace properties.

You can accomplish this by conditionalty changing the attributes:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(kine="scatter", mode="markers", df, x=:sepal_width, y=:sepal_length, group=:species,
                 title="Conditionally Updating Traces In A Plotly Express Figure With for_each_trace()")

# TODO: Not updating symbol
for trace in fig.plot.data
    if trace.name == "setosa"
        trace.marker[:symbol] = "square"
    end
end

fig
```

#### Updating Figure Axes

Graph object figures support `update_xaxes!()` and `update_yaxes!()` methods that may be used to update multiple nested properties of one or more of a figure's axes. Here is an example of using `update_xaxes!()` to disable the vertical grid lines across all subplots in a figure produced by Plotly Express.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

fig = plot(df, kind="scatter", mode="markers", x=:sepal_width, y=:sepal_length, color=:species,
                 facet_col=:species, Layout(title="Using update_xaxes!()"))

update_xaxes!(fig, showgrid=false)

fig
```

<!-- TODO: no for_each_axis method -->

There are also `for_each_xaxis()` and `for_each_yaxis()` methods that are analogous to the `for_each_trace()` method described above. For non-cartesian subplot types (e.g. polar), there are additional `update_{type}` and `for_each_{type}` methods (e.g. `update_polar()`, `for_each_polar()`).

### Other Update Methods

Figures created with the PlolyJS.jl graphing library also support:

<!-- TODO: no `update_layout_images` method -->

- the `update_layout_images()` method in order to [update background layout images](/julia/images/),
- `update_annotations()` in order to [update annotations](/julia/text-and-annotations/#multiple-annotations),
- and `update_shapes()` in order to [update shapes](/julia/shapes/).
