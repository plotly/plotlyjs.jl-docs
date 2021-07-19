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
    description: How to add text labels and annotations to plots in python.
    display_as: file_settings
    language: python
    layout: base
    name: Text and Annotations
    order: 22
    permalink: python/text-and-annotations/
    thumbnail: thumbnail/text-and-annotations.png
---

### Adding Text to Figures

As a general rule, there are two ways to add text labels to figures:

1. Certain trace types, notably in the `scatter` family (e.g. `scatter`, `scatter3d`, `scattergeo` etc), support a `text` attribute, and can be displayed with or without markers.
2. Standalone text annotations can be added to figures using `fig.add_annotation()`, with or without arrows, and they can be positioned absolutely within the figure, or they can be positioned relative to the axes of 2d or 3d cartesian subplots i.e. in data coordinates.

The differences between these two approaches are that:

- Traces can optionally support hover labels and can appear in legends.
- Text annotations can be positioned absolutely or relative to data coordinates in 2d/3d cartesian subplots only.
- Traces cannot be positioned absolutely but can be positioned relative to data coordinates in any subplot type.
- Traces also be used to [draw shapes](/julia/shapes/), although there is a [shape equivalent to text annotations](/julia/shapes/).

### Text on scatter plots

Here is an example that creates a scatter plot with text labels.

<!-- ```python
import plotly.express as px

df = px.data.gapminder().query("year==2007 and continent=='Americas'")

fig = px.scatter(df, x="gdpPercap", y="lifeExp", text="country", log_x=True, size_max=60)

fig.update_traces(textposition='top center')

fig.update_layout(
    height=800,
    title_text='GDP and Life Expectancy (Americas, 2007)'
)

fig.show()
``` -->

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df = df[(df.year .== 2007) .& (df.continent .== "Americas"), :]

layout = Layout(
    height=800,
    title_text="GDP and Life Expectancy (Americas, 2007)",
    xaxis_type="log",
)
trace = scatter(
    df,
    x=:gdpPercap,
    y=:lifeExp,
    text=:country,
    textposition="top center",
    mode="markers+text",
    size_max=60
)

plot(trace, layout)
```

### Text positioning on scatter and line plots

```julia
using PlotlyJS

trace1 = scatter(
    x=[0, 1, 2],
    y=[1, 1, 1],
    mode="lines+markers+text",
    name="Lines, Markers and Text",
    text=["Text A", "Text B", "Text C"],
    textposition="top center"
)

trace2 = scatter(
    x=[0, 1, 2],
    y=[2, 2, 2],
    mode="markers+text",
    name="Markers and Text",
    text=["Text D", "Text E", "Text F"],
    textposition="bottom center"
)

trace3 = scatter(
    x=[0, 1, 2],
    y=[3, 3, 3],
    mode="lines+text",
    name="Lines and Text",
    text=["Text G", "Text H", "Text I"],
    textposition="bottom center"
)

plot([trace1, trace2, trace3])
```

### Controlling text fontsize with uniformtext

For the [pie](/julia/pie-charts), [bar](/julia/bar-charts), [sunburst](/julia/sunburst-charts) and [treemap](/julia/treemap-charts) traces, it is possible to force all the text labels to have the same size thanks to the `uniformtext` layout parameter. The `minsize` attribute sets the font size, and the `mode` attribute sets what happens for labels which cannot fit with the desired fontsize: either `hide` them or `show` them with overflow.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df = df[(df.year .== 2007) .& (df.continent .== "Europe") .& (df.pop .> 2e6), :]

layout = Layout(uniformtext_minsize=8, uniformtext_mode="hide")

trace = bar(
    df,
    y=:pop,
    x=:country,
    text=:pop,
    texttemplate="%{text:.2s}",
    textposition="outside"
)

plot(trace, layout)
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df = df[(df.year .== 2007) .& (df.continent .== "Asia"), :]

layout = Layout(uniformtext_minsize=12, uniformtext_mode="hide")

trace = pie(
    df,
    values=:pop,
    labels=:country,
    textposition="inside"
)

plot(trace, layout)
```

### Controlling text fontsize with textfont

The `textfont_size` parameter of the the [pie](/julia/pie-charts), [bar](/julia/bar-charts), [sunburst](/julia/sunburst-charts) and [treemap](/julia/treemap-charts) traces can be used to set the **maximum font size** used in the chart. Note that the `textfont` parameter sets the `insidetextfont` and `outsidetextfont` parameter, which can also be set independently.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df = df[(df.year .== 2007) .& (df.continent .== "Asia"), :]

trace = pie(df, values=:pop, names=:country, textposition="inside", textfont_size=14)

plot(trace)
```

### Text Annotations

Annotations can be added to a figure using `fig.add_annotation()`.

```julia
using PlotlyJS

trace1 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 1, 3, 2, 4, 3, 4, 6, 5]
)


trace2 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 4, 5, 1, 2, 2, 3, 4, 2]
)

# TODO: There is no `add_annotation` method in julia, putting it in layout for now
layout = Layout(
    showlegend=false,
    annotations=[
        attr(x=2, y=5,
            text="Text annotation with arrow",
            showarrow=true,
            arrowhead=1
        ),
        attr(x=4, y=4,
            text="Text annotation without arrow",
            showarrow=false,
            yshift=10
        )
    ]
)

plot([trace1, trace2], layout)
```

### 3D Annotations

```julia
using PlotlyJS

trace = scatter3d(
    x=["2017-01-01", "2017-02-10", "2017-03-20"],
    y=["A", "B", "C"],
    z=[1, 1000, 100000],
    name="z",
)

layout = Layout(
    scene=attr(
        xaxis=attr(type="date"),
        yaxis=attr(type="category"),
        zaxis=attr(type="log"),
        annotations=[
        attr(
            showarrow=false,
            x="2017-01-01",
            y="A",
            z=0,
            text="Point 1",
            xanchor="left",
            xshift=10,
            opacity=0.7),
        attr(
            x="2017-02-10",
            y="B",
            z=4,
            text="Point 2",
            textangle=0,
            ax=0,
            ay=-75,
            font=attr(
                color="black",
                size=12
            ),
            arrowcolor="black",
            arrowsize=3,
            arrowwidth=1,
            arrowhead=1),
        attr(
            x="2017-03-20",
            y="C",
            z=5,
            ax=50,
            ay=0,
            text="Point 3",
            arrowhead=1,
            xanchor="left",
            yanchor="bottom"
        )]
    ),
)

plot(trace, layout)
```

### Custom Text Color and Styling

```julia
using PlotlyJS

trace1 = scatter(
    x=[0, 1, 2],
    y=[1, 1, 1],
    mode="lines+markers+text",
    name="Lines, Markers and Text",
    text=["Text A", "Text B", "Text C"],
    textposition="top right",
    textfont=attr(
        family="sans serif",
        size=18,
        color="crimson"
    )
)

trace2 = scatter(
    x=[0, 1, 2],
    y=[2, 2, 2],
    mode="lines+markers+text",
    name="Lines and Text",
    text=["Text G", "Text H", "Text I"],
    textposition="bottom center",
    textfont=attr(
        family="sans serif",
        size=18,
        color="LightSeaGreen"
    )
)

plot([trace1, trace2], Layout(showlegend=false))
```

### Styling and Coloring Annotations

```julia
using PlotlyJS

trace1 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 1, 3, 2, 4, 3, 4, 6, 5]
)

trace2 = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 4, 5, 1, 2, 2, 3, 4, 2]
)

# TODO: No `add_annotation` method putting in layout for now
layout = Layout(
    showlegend=false,
    annotations=[
        attr(
            x=2,
            y=5,
            xref="x",
            yref="y",
            text="max=5",
            showarrow=true,
            font=attr(
                family="Courier New, monospace",
                size=16,
                color="#ffffff"
            ),
            align="center",
            arrowhead=2,
            arrowsize=1,
            arrowwidth=2,
            arrowcolor="#636363",
            ax=20,
            ay=-30,
            bordercolor="#c7c7c7",
            borderwidth=2,
            borderpad=4,
            bgcolor="#ff7f0e",
            opacity=0.8
        )
    ]
)

plot([trace1, trace2], layout)
```

### Text Font as an Array - Styling Each Text Element

```julia
using PlotlyJS

trace = scattergeo(
    lat=[45.5, 43.4, 49.13, 51.1, 53.34, 45.24, 44.64, 48.25, 49.89, 50.45],
    lon=[-73.57, -79.24, -123.06, -114.1, -113.28, -75.43, -63.57, -123.21, -97.13,
         -104.6],
    marker=attr(
        color= ["MidnightBlue", "IndianRed", "MediumPurple", "Orange", "Crimson",
                  "LightSeaGreen", "RoyalBlue", "LightSalmon", "DarkOrange", "MediumSlateBlue"],
        line_width= 1,
        size= 10
    ),
    mode="markers+text",
    name="",
    text=["Montreal", "Toronto", "Vancouver", "Calgary", "Edmonton", "Ottawa",
          "Halifax",
          "Victoria", "Winnepeg", "Regina"],
    textfont=attr(
        color= ["MidnightBlue", "IndianRed", "MediumPurple", "Gold", "Crimson",
                  "LightSeaGreen",
                  "RoyalBlue", "LightSalmon", "DarkOrange", "MediumSlateBlue"],
        family= ["Arial, sans-serif", "Balto, sans-serif", "Courier New, monospace",
                   "Droid Sans, sans-serif", "Droid Serif, serif",
                   "Droid Sans Mono, sans-serif",
                   "Gravitas One, cursive", "Old Standard TT, serif",
                   "Open Sans, sans-serif",
                   "PT Sans Narrow, sans-serif", "Raleway, sans-serif",
                   "Times New Roman, Times, serif"],
        size= [22, 21, 20, 19, 18, 17, 16, 15, 14, 13]
    ),
    textposition=["top center", "middle left", "top center", "bottom center",
                  "top right",
                  "middle left", "bottom right", "bottom left", "top right",
                  "top right"]
)

layout = Layout(
    title_text="Canadian cities",
    geo=attr(
        lataxis_range=[40, 70],
        lonaxis_range=[-130, -55],
        scope="north america"
    )
)

plot(trace, layout)
```

### Positioning Text Annotations Absolutely

By default, text annotations have `xref` and `yref` set to `"x"` and `"y"`, respectively, meaning that their x/y coordinates are with respect to the axes of the plot. This means that panning the plot will cause the annotations to move. Setting `xref` and/or `yref` to `"paper"` will cause the `x` and `y` attributes to be interpreted in [paper coordinates](/julia/figure-structure/#positioning-with-paper-container-coordinates-or-axis-domain-coordinates).

<!-- TODO: not sure if this link will work -->

Try panning or zooming in the following figure:

```julia
using PlotlyJS

trace =scatter(x=[1, 2, 3], y=[1, 2, 3])
layout = Layout(
    title="Try panning or zooming!",
    annotations=[
        attr(text="Absolutely-positioned annotation",
                  xref="paper", yref="paper",
                  x=0.3, y=0.3, showarrow=false)
    ]
)

plot(trace, layout)
```

### Adding Annotations Referenced to an Axis

To place annotations relative to the length or height of an axis, the string
`' domain'` can be added after the axis reference in the `xref` or `yref` fields.
For example:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "wind")
trace = scatter(df, y=:frequency, mode="markers")

# Set a custom domain to see how the ' domain' string changes the behaviour
layout = Layout(
    xaxis=attr(domain=[0, 0.5]), yaxis=attr(domain=[0.25, 0.75]),
    annotations=[
        attr(
            xref="x domain",
            yref="y domain",
            # The arrow head will be 25% along the x axis, starting from the left
            x=0.25,
            # The arrow head will be 40% along the y axis, starting from the bottom
            y=0.4,
            text="An annotation referencing the axes",
            arrowhead=2
        )
    ]
)

plot(trace, layout)
```

### Specifying the Text's Position Absolutely

The text coordinates / dimensions of the arrow can be specified absolutely, as
long as they use exactly the same coordinate system as the arrowhead. For
example:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "wind:")
trace = scatter(df, y=:frequency, mode="markers")

layout = Layout(
    xaxis=attr(domain=[0, 0.5]),
    yaxis=attr(domain=[0.25, 0.75]),
    annotations=[
        attr(
            xref="x domain",
            yref="y",
            x=0.75,
            y=1,
            text="An annotation whose text and arrowhead reference the axes and the data",
            # If axref is exactly the same as xref, then the text's position is
            # absolute and specified in the same coordinates as xref.
            axref="x domain",
            # The same is the case for yref and ayref, but here the coordinates are data
            # coordinates
            ayref="y",
            ax=0.5,
            ay=2,
            arrowhead=2
        )
    ]
)

plot(trace, layout)
```

### Customize Displayed Text with a Text Template

To show an arbitrary text in your chart you can use [texttemplate](https://plotly.com/julia/reference/pie/#pie-texttemplate), which is a template string used for rendering the information, and will override [textinfo](https://plotly.com/julia/reference/treemap/#treemap-textinfo).
This template string can include `variables` in %{variable} format, `numbers` in [d3-format's syntax](https://github.com/d3/d3-3.x-api-reference/blob/master/Formatting.md#d3_forma), and `date` in [d3-time-format's syntax](https://github.com/d3/d3-time-format).
`texttemplate` customizes the text that appears on your plot vs. [hovertemplate](https://plotly.com/julia/reference/pie/#pie-hovertemplate) that customizes the tooltip text.

```julia
using PlotlyJS

trace = pie(
    values = [40000000, 20000000, 30000000, 10000000],
    labels = ["Wages", "Operating expenses", "Cost of sales", "Insurance"],
    texttemplate = "%{label}: %{value:\$,s} <br>(%{percent})",
    textposition = "inside")

plot(trace)
```

### Customize Text Template

The following example uses [textfont](https://plotly.com/python/reference/scatterternary/#scatterternary-textfont) to customize the added text.

```julia
using PlotlyJS

trace = scatterternary(
    a = [3, 2, 5],
    b = [2, 5, 2],
    c = [5, 2, 2],
    mode = "markers+text",
    text = ["A", "B", "C"],
    texttemplate = "%{text}<br>(%{a:.2f}, %{b:.2f}, %{c:.2f})",
    textposition = "bottom center",
    textfont = attr(family="Times", size= [18, 21, 20], color= ["IndianRed", "MediumPurple", "DarkOrange"])
)

plot(trace)
```

### Set Date in Text Template

The following example shows how to show date by setting [axis.type](https://plotly.com/python/reference/layout/yaxis/#layout-yaxis-type) in [funnel charts](https://plotly.com/python/funnel-charts/).
As you can see [textinfo](https://plotly.com/python/reference/funnel/#funnel-textinfo) and [texttemplate](https://plotly.com/python/reference/funnel/#funnel-texttemplate) have the same functionality when you want to determine 'just' the trace information on the graph.

```julia
using PlotlyJS

trace1 = funnel(
    name = "Montreal",
    orientation = "h",
    y = ["2018-01-01", "2018-07-01", "2019-01-01", "2020-01-01"],
    x = [100, 60, 40, 20],
    textposition = "inside",
    texttemplate = "%{y| %a. %_d %b %Y}")

trace2 = funnel(
    name = "Vancouver",
    orientation = "h",
    y = ["2018-01-01", "2018-07-01", "2019-01-01", "2020-01-01"],
    x = [90, 70, 50, 10],
    textposition = "inside",
    textinfo = "label")

layout = Layout(yaxis_type="date")

plot([trace1, trace2], layout)
```

#### Reference

See https://plotly.com/julia/reference/layout/annotations/ for more information and chart attribute options!
