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
      How to set the global font, title, legend-entries, and axis-titles
      in Julia.
    display_as: file_settings
    language: julia
    layout: base
    name: Setting the Font, Title, Legend Entries, and Axis Titles
    order: 13
    permalink: julia/figure-labels/
    redirect_from: julia/font/
    thumbnail: thumbnail/figure-labels.png
---

### Automatic Labelling

When using the `plot` method, your axes and legend are automatically labelled, and it's easy to override the automation for a customized figure using the `labels` keyword argument. The title of your figure is up to you though!

Here's a figure with automatic labels and then the same figure with overridden labels.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_length,
    y=:sepal_width,
    group=:species,
    kind="scatter",
    mode="markers",
    Layout(
        title="Automatic Labels Based on Data Frame Column Names"
    )
)
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_length,
    y=:sepal_width,
    group=:species,
    kind="scatter",
    mode="markers",
    Layout(
        title="Automatic Labels Based on Data Frame Column Names",
        xaxis_title="Sepal Length (cm)",
        yaxis_title="Sepal Width (cm)",
        legend_title_text="Species of Iris"
    )
)

```

### Global and Local Font Specification

You can set the figure-wide font with the `layout.font` attribute, which will apply to all titles and tick labels, but this can be overridden for specific plot items like individual axes and legend titles etc. In the following figure, we set the figure-wide font to Courier New in blue, and then override this for certain parts of the figure.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

plot(
    df,
    x=:sepal_length,
    y=:sepal_width,
    group=:species,
    kind="scatter",
    mode="markers",
    Layout(
        font_family="Courier New",
        font_color="blue",
        title=attr(
            text="Playing with Fonts",
            font_family="Times New Roman",
            font_color="red",
        ),
        legend_title_font_color="green"
    )
)
```

### Manual Labelling

```julia
using PlotlyJS

trace1 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    name="Name of Trace 1"       # this sets its legend entry
)


trace2 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[1, 0, 3, 2, 5, 4, 7, 6, 8],
    name="Name of Trace 2"
)

layout = Layout(
    title="Plot Title",
    xaxis_title="X Axis Title",
    yaxis_title="Y Axis Title",
    legend_title="Legend Title",
    font=attr(
        family="Courier New, monospace",
        size=18,
        color="RebeccaPurple"
    )
)

plot([trace1, trace2], layout)
```

The configuration of the legend is discussed in detail in the [Legends](/julia/legend/) page.

### Align Plot Title

The following example shows how to align the plot title in [layout.title](https://plotly.com/julia/reference/layout/#layout-title). `x` sets the x position with respect to `xref` from "0" (left) to "1" (right), and `y` sets the y position with respect to `yref` from "0" (bottom) to "1" (top). Moreover, you can define `xanchor` to `left`,`right`, or `center` for setting the title's horizontal alignment with respect to its x position, and/or `yanchor` to `top`, `bottom`, or `middle` for setting the title's vertical alignment with respect to its y position.

```julia
using PlotlyJS

trace= scatter(
    y=[3, 1, 4],
    x=["Mon", "Tue", "Wed"]
)

layout = Layout(
    title=attr(
        text= "Plot Title",
        y=0.9,
        x=0.5,
        xanchor= "center",
        yanchor= "top"
    )
)

plot(trace, layout)
```

#### Reference

See https://plotly.com/julia/reference/layout/ for more information!
