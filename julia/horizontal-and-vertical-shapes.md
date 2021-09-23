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
    description: How to add annotated horizontal and vertical lines in Julia.
    display_as: file_settings
    language: julia
    layout: base
    name: Horizontal and Vertical Lines and Rectangles
    order: 37
    permalink: julia/horizontal-vertical-shapes/
    thumbnail: thumbnail/shape.jpg
---

### Horizontal and Vertical Lines and Rectangles

*introduced in plotly 4.12*

Horizontal and vertical lines and rectangles that span an entire
plot can be added via the `add_hline`, `add_vline`, `add_hrect`, and `add_vrect`
methods of `plotly.graph_objects.Figure`. Shapes added with these methods are
added as [layout shapes](/julia/shapes).. These shapes are fixed to the endpoints of one axis,
regardless of the range of the plot, and fixed to data coordinates on the other axis. The
following shows some possibilities, try panning and zooming the resulting figure
to see how the shapes stick to some axes:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
fig = plot(df, mode="markers", x=:petal_length, y=:petal_width)
add_hline!(fig, 0.9)
add_vrect!(fig, 0.9, 2)
fig
```

These shapes can be styled by passing the same arguments as are accepted by `add_shape`:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
fig = plot(df, mode="markers", x=:petal_length, y=:petal_width)
add_vline!(fig, 2.5, line_width=3, line_dash="dash", line_color="green")
add_hrect!(fig, 0.9, 2.6, line_width=0, fillcolor="red", opacity=0.2)
fig
```

#### Adding Text Annotations

[Text annotations](/julia/text-and-annotations) can optionally be added to an autoshape
using the `annotation_text` keyword argument, and positioned using the `annotation_position` argument:

<!-- TODO: Annotations not showing up -->
```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
df = stack(df)

fig = plot(df, x=:date, y=:value, color=:variable)

add_hline!(fig, 1, line_dash="dot",
              annotation_text="Jan 1, 2018 baseline", 
              annotation_position="bottom right")
add_vrect!(fig, "2018-09-24", "2018-12-18", 
              annotation_text="decline", annotation_position="top left",
              fillcolor="green", opacity=0.25, line_width=0)
fig
```

Extra formatting of the annotation can be done using magic-underscores prefixed by `annotation_` or by
passing a `dict` to the `annotation` argument:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
df = stack(df)

fig = plot(df, x=:date, y=:value, color=:variable)

add_hline!(fig, 1, line_dash="dot",
              annotation_text="Jan 1, 2018 baseline", 
              annotation_position="bottom right",
              annotation_font_size=20,
              annotation_font_color="blue"
             )
add_vrect!(fig, "2018-09-24", "2018-12-18", 
              annotation_text="decline", annotation_position="top left",
              annotation=attr(font_size=20, font_family="Times New Roman"),
              fillcolor="green", opacity=0.25, line_width=0)
fig
```

#### Adding to Multiple Facets / Subplots

The same line or box can be added to multiple [subplots](/julia/subplots/) or [facets](/julia/facet-plots/)
by setting the `row` and/or `col` to `"all"`. The default `row` and `col` values are `"all"`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")
df = stack(df)

fig = plot(df, facet_col=:variable, x=:date, y=:value, facet_col_wrap=2)

add_hline!(fig, 1, line_dash="dot", row=3, col="all",
              annotation_text="Jan 1, 2018 baseline", 
              annotation_position="bottom right")
add_vrect!(fig, "2018-09-24", "2018-12-18", row="all", col=1,
              annotation_text="decline", annotation_position="top left",
              fillcolor="green", opacity=0.25, line_width=0)
fig
```

### Reference

More details are available about [layout shapes](/julia/shapes/) and [annotations](/julia/text-and-annotations). 