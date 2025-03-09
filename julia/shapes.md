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
      How to make SVG shapes in Julia. Examples of lines, circle, rectangle,
      and path.
    display_as: file_settings
    language: julia
    layout: base
    name: Shapes
    order: 25
    permalink: julia/shapes/
    thumbnail: thumbnail/shape.jpg
---

### Adding Lines and Polygons to Figures

As a general rule, there are two ways to add shapes (lines or polygons) to figures:

1. Trace types in the `scatter` family (e.g. `scatter`, `scatter3d`, `scattergeo` etc.) can be drawn with `mode="lines"` and optionally support a `fill="self"` attribute, and so can be used to draw open or closed shapes on figures.
2. Standalone lines, ellipses and rectangles can be added to figures using `fig.add_shape()`, and they can be positioned absolutely within the figure, or they can be positioned relative to the axes of 2d Cartesian subplots, i.e. in data coordinates.

_Note:_ there are special functions `add_hline!`, `add_vline!`, `add_hrect!` and `add_vrect!` for the common cases of wanting to draw horizontal or vertical lines or rectangles that are fixed to data coordinates in one axis and absolutely positioned in another.

The differences between these two approaches are that:

- Traces can optionally support hover labels and can appear in legends.
- Shapes can be positioned absolutely or relative to data coordinates in 2d Cartesian subplots only.
- Traces cannot be positioned absolutely but can be positioned relative to date coordinates in any subplot type.
- Traces also support [optional text](/julia/text-and-annotations/), although there is a [textual equivalent to shapes in text annotations](/julia/text-and-annotations/).

### Shape-drawing with Scatter traces

There are two ways to draw filled shapes: scatter traces and [layout.shapes](https://plotly.com/julia/reference/layout/shapes/#layout-shapes-items-shape-type) which is mostly useful for the 2d subplots, and defines the shape type to be drawn, and can be rectangle, circle, line, or path (a custom SVG path).
You also can use [scatterpolar](https://plotly.com/julia/polar-chart/#categorical-polar-chart), scattergeo, scattermapbox to draw filled shapes on any kind of subplots.
To set an area to be filled with a solid color, you need to define [scatter.fill="toself"](https://plotly.com/julia/reference/scatter/#scatter-fill) that connects the endpoints of the trace into a closed shape.
If `mode=line` (default value), then you need to repeat the initial point of a shape at the end of the sequence to have a closed shape.

```julia
using PlotlyJS

plot(scatter(x=[0, 1, 2, 0], y=[0, 2, 0, 0], fill="toself"))
```

You can have more shapes either by adding more traces or interrupting the series with `nothing`.

```julia
using PlotlyJS

plot(scatter(
    x=[0, 1, 2, 0, nothing, 3, 3, 5, 5, 3],
    y=[0, 2, 0, 0, nothing, 0.5, 1.5, 1.5, 0.5, 0.5], fill="toself",
))
```

#### Vertical and Horizontal Lines Positioned Relative to the Axis Data

```julia
using PlotlyJS

# Create scatter trace of text labels
p = plot(scatter(
    x=[2, 3.5, 6],
    y=[1, 1.5, 1],
    text=["Vertical Line",
          "Horizontal Dashed Line",
          "Diagonal dotted Line"],
    mode="text",
), Layout(xaxis_range=[0, 7], yaxis_range=[0, 2.5]))

add_shape!(p, line(
    x0=1, y0=0,
    x1=1, y1=2,
    line=attr(color="RoyalBlue", width=3),
))

add_shape!(p, line(
    x0=2, y0=2, x1=5, y1=2,
    line=attr(
        color="LightSeaGreen",
        width=4,
        dash="dashdot",
    ),
))

add_shape!(p, line(
    x0=4, y0=0, x1=6, y1=2,
    line=attr(
        color="MediumPurple",
        width=4,
        dash="dot",
    ),
))

p
```

#### Lines Positioned Relative to the Plot and to the Axis Data

```julia
using PlotlyJS

# Create scatter trace of text labels
trace = scatter(
    x=[2, 6], y=[1, 1],
    text=["Line positioned relative to the plot",
          "Line positioned relative to the axes"],
    mode="text",
)

layout = Layout(
    # Set axes ranges
    xaxis_range=[0, 8],
    yaxis_range=[0, 2],
    shapes=[
        line(
            xref="x", yref="y",
            x0=4, y0=0, x1=8, y1=1,
            line=attr(
                color="LightSeaGreen",
                width=3,
            ),
        ),
        line(
            xref="paper", yref="paper",
            x0=0, y0=0, x1=0.5,
            y1=0.5,
            line=attr(
                color="DarkOrange",
                width=3,
            ),
        ),
    ],
)

plot(trace, layout)
```

#### Rectangles Positioned Relative to the Axis Data

```julia
using PlotlyJS

trace = scatter(
    x=[1.5, 4.5],
    y=[0.75, 0.75],
    text=["Unfilled Rectangle", "Filled Rectangle"],
    mode="text",
)
layout = Layout(
    # Set axes properties
    xaxis=attr(range=[0, 7], showgrid=false),
    yaxis_range=[0, 3.5],
    # Add shapes
    shapes=[
        rect(
            x0=1, y0=1, x1=2, y1=3,
            line_color="RoyalBlue",
            xref='x', yref='y'
        ),
        rect(
            x0=3, y0=1, x1=6, y1=2,
            line=attr(
                color="RoyalBlue",
                width=2,
            ),
            fillcolor="LightSkyBlue",
            xref='x', yref='y',
        ),
    ],
)

plot(trace, layout)
```

#### Rectangle Positioned Relative to the Plot and to the Axis Data

```julia
using PlotlyJS

# Create scatter trace of text labels
trace = scatter(
    x=[1.5, 3],
    y=[2.5, 2.5],
    text=["Rectangle reference to the plot",
          "Rectangle reference to the axes"],
    mode="text",
)
layout = Layout(
    # Set axes properties
    xaxis_range=[0, 4],
    yaxis_range=[0, 4],
    shapes=[
        rect(
            xref="x", yref="y",
            x0=2.5, y0=0,
            x1=3.5, y1=2,
            line=attr(
                color="RoyalBlue",
                width=3,
            ),
            fillcolor="LightSkyBlue",
        ),
        rect(
            xref="paper", yref="paper",
            x0=0.25, y0=0,
            x1=0.5, y1=0.5,
            line=attr(
                color="LightSeaGreen",
                width=3,
            ),
            fillcolor="PaleTurquoise",
        ),
    ],
)
plot(trace, layout)
```

#### A Rectangle Placed Relative to the Axis Position and Length

A shape can be placed relative to an axis's position on the plot by adding the
string `"domain"` to the axis reference in the `xref` or `yref` attributes for
shapes.
The following code places a rectangle that starts at 60% and ends at 70% along
the x-axis, starting from the left, and starts at 80% and ends at 90% along the
y-axis, starting from the bottom.

```julia
using PlotlyJS, DataFrames, CSV

df = dataset(DataFrame, "wind")

p = plot(
    df, y=:frequency, mode="markers",
    Layout(
        xaxis_domain=[0, 0.5],
        yaxis_domain=[0.25, 0.75],
        # Add a shape whose x and y coordinates refer to the domains of the x and y axes
        shapes=[
            rect(
                xref="x domain", yref="y domain",
                x0=0.6, x1=0.7, y0=0.8, y1=0.9,
            ),
        ],
    ),
)
```

#### Highlighting Time Series Regions with Rectangle Shapes

_Note:_ there are [special methods `add_hline`, `add_vline`, `add_hrect` and `add_vrect` for the common cases of wanting to draw horizontal or vertical lines or rectangles] that are fixed to data coordinates in one axis and absolutely positioned in another.

```julia
using PlotlyJS

# Add scatter trace for line
fig = plot(scatter(
    x=["2015-02-01", "2015-02-02", "2015-02-03", "2015-02-04", "2015-02-05",
       "2015-02-06", "2015-02-07", "2015-02-08", "2015-02-09", "2015-02-10",
       "2015-02-11", "2015-02-12", "2015-02-13", "2015-02-14", "2015-02-15",
       "2015-02-16", "2015-02-17", "2015-02-18", "2015-02-19", "2015-02-20",
       "2015-02-21", "2015-02-22", "2015-02-23", "2015-02-24", "2015-02-25",
       "2015-02-26", "2015-02-27", "2015-02-28"],
    y=[-14, -17, -8, -4, -7, -10, -12, -14, -12, -7, -11, -7, -18, -14, -14,
       -16, -13, -7, -8, -14, -8, -3, -9, -9, -4, -13, -9, -6],
    mode="lines",
    name="temperature",
))

# Add shape regions
add_vrect!(fig,
    "2015-02-04", "2015-02-06",
    fillcolor="LightSalmon", opacity=0.5,
    layer="below", line_width=0,
)

add_vrect!(fig,
    "2015-02-20", "2015-02-22",
    fillcolor="LightSalmon", opacity=0.5,
    layer="below", line_width=0,
)

fig
```

#### Circles Positioned Relative to the Axis Data

```julia
using PlotlyJS

# Create scatter trace of text labels
trace = scatter(
    x=[1.5, 3.5],
    y=[0.75, 2.5],
    text=["Unfilled Circle",
          "Filled Circle"],
    mode="text",
)

layout = Layout(
    xaxis_range=[0, 4.5],
    xaxis_zeroline=false,
    yaxis_range=[0, 4.5],
    width=800,
    height=800,
    # Add circles
    shapes=[
        circle(xref="x", yref="y",
            x0=1, y0=1, x1=3, y1=3,
            line_color="LightSeaGreen"
        ),
        circle(
            xref="x", yref="y",
            fillcolor="PaleTurquoise",
            x0=3, y0=3, x1=4, y1=4,
            line_color="LightSeaGreen",
        ),
    ],
)
plot(trace, layout)
```

#### Highlighting Clusters of Scatter Points with Circle Shapes

```julia
using PlotlyJS, Distributions
# Generate data
x0 = rand(Normal(2, 0.45), 300)
y0 = rand(Normal(2, 0.45), 300)
x1 = rand(Normal(6, 0.4), 200)
y1 = rand(Normal(6, 0.4), 200)


# Create figure
# Add scatter traces
trace1 = scatter(x=x0, y=y0, mode="markers")
trace2 = scatter(x=x1, y=y1, mode="markers")

layout = Layout(
    # Hide legend
    showlegend=false,
    # Add shapes
    shapes=[
        circle(
            xref="x", yref="y",
            x0=minimum(x0), y0=minimum(y0),
            x1=maximum(x0), y1=maximum(y0),
            opacity=0.2,
            fillcolor="blue",
            line_color="blue",
        ),
        circle(
            xref="x", yref="y",
            x0=minimum(x1), y0=minimum(y1),
            x1=maximum(x1), y1=maximum(y1),
            opacity=0.2,
            fillcolor="orange",
            line_color="orange",
        ),
    ],
)

plot([trace1, trace2], layout)
```

#### Venn Diagram with Circle Shapes

```julia
using PlotlyJS

# Create scatter trace of text labels
p = plot(scatter(
    x=[1, 1.75, 2.5],
    y=[1, 1, 1],
    text=["A", "A+B", "B"],
    mode="text",
    textfont=attr(
        color="black",
        size=18,
        family="Arial",
    ),
))

# Update axes properties
update_xaxes!(p,
    showticklabels=false,
    showgrid=false,
    zeroline=false,
)

update_yaxes!(p,
    showticklabels=false,
    showgrid=false,
    zeroline=false,
)

relayout!(
    p,
    margin=attr(l=20, r=20, b=100),
    height=600, width=800,
    plot_bgcolor="white",
    # Add circles
    shapes=[
        circle(
            line_color="blue", fillcolor="blue",
            x0=0, y0=0, x1=2, y1=2,
            opacity=0.3, xref="x", yref="y",
        ),
        circle(
            line_color="gray", fillcolor="gray",
            x0=1.5, y0=0, x1=3.5, y1=2,
            opacity=0.3, xref="x", yref="y",
        ),
    ],
)

p
```

#### Adding Shapes to Subplots

Here we use the different axes (`x1`, `x2`) created by `make_subplots` as reference in order to draw shapes in figure subplots.

```julia
using PlotlyJS

# Create Subplots
fig = make_subplots(rows=2, cols=2, specs=fill(Spec(kind="scatter"), 2, 2))

add_trace!(fig, scatter(x=[2, 6], y=[1, 1]), row=1, col=1)
add_trace!(fig, bar(x=[1, 2, 3], y=[4, 5, 6]), row=1, col=2)
add_trace!(fig, scatter(x=[10, 20], y=[40, 50]), row=2, col=1)
add_trace!(fig, bar(x=[11, 13, 15], y=[8, 11, 20]), row=2, col=2)

# Add shapes
relayout!(fig,
    shapes=[
        line(
            xref="x", yref="y",
            x0=3, y0=0.5, x1=5, y1=0.8,
            line_width=3,
        ),
        rect(
            xref="x2", yref="y4",
            x0=4, y0=2, x1=5, y1=6,
        ),
        rect(
            xref="x3", yref="y3",
            x0=10, y0=20, x1=15, y1=30,
        ),
        circle(
            xref="x4", yref="y4",
            x0=5, y0=12, x1=10, y1=18,
        ),
    ],
)

fig
```

#### Adding the Same Shapes to Multiple Subplots

The same shape can be added to multiple facets by using the `"all"` keyword in the `row` and `col` arguments.
For example

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips");
p = plot(df, x=:total_bill, y=:tip, facet_row=:smoker, facet_col=:sex, mode="markers")

add_shape!(p, rect(x0=25, x1=35, y0=4, y1=6, line_color="purple"), row="all", col="all")
add_shape!(p, line(x0=20, x1=25, y0=5, y1=6, line_color="yellow"), row="all", col=2)
add_shape!(p, circle(x0=10, y0=2, x1=20, y1=7, line_color="green"), row=2, col="all")
p
```

#### SVG Paths

```julia
using PlotlyJS

# Create scatter trace of text labels
fig = plot(scatter(
    x=[2, 1, 8, 8],
    y=[0.25, 9, 2, 6],
    text=["Filled Triangle",
          "Filled Polygon",
          "Quadratic Bézier Curves",
          "Cubic Bézier Curves"],
    mode="text",
))

# Update axes properties
update_xaxes!(fig,
    range=[0, 9],
    zeroline=false,
)

update_yaxes!(fig,
    range=[0, 11],
    zeroline=false,
)

# Add shapes
relayout!(fig,
    shapes=[
        # Quadratic Bézier Curves
        attr(
            type="path",
            path="M 4, 4 Q 6, 0 8, 4",
            line_color="RoyalBlue",
        ),
        # Cubic Bézier Curves
        attr(
            type="path",
            path="M 1, 4 C 2, 8 6, 4 8, 8",
            line_color="MediumPurple",
        ),
        # filled Triangle
        attr(
            type="path",
            path="M 1 1 L 1 3 L 4 1 Z",
            fillcolor="LightPink",
            line_color="Crimson",
        ),
        # filled Polygon
        attr(
            type="path",
            path="M 3, 7 L2, 8 L2, 9 L3, 10, L4, 10 L5, 9 L5, 8 L4, 7 Z",
            fillcolor="PaleTurquoise",
            line_color="LightSeaGreen",
        ),
    ],
)

fig
```

### Drawing shapes with a Mouse on Cartesian plots

You can create layout shapes programmatically, but you can also draw shapes manually by setting the `dragmode` to one of the shape-drawing modes: `"drawline"`, `"drawopenpath"`, `"drawclosedpath"`, `"drawcircle"`, or `"drawrect"`.
If you need to switch between different shape-drawing or other dragmodes (panning, selecting, etc.), [modebar buttons can be added](/julia/configuration-options#add-optional-shapedrawing-buttons-to-modebar) in the `config` to select the dragmode.
If you switch to a different dragmode such as pan or zoom, you will need to select the drawing tool in the modebar to go back to shape drawing.

This shape-drawing feature is particularly interesting for annotating graphs, in particular [image traces] or [layout images](/julia/images).

Once you have drawn shapes, you can select and modify an existing shape by clicking on its boundary (note the arrow pointer).
Its fillcolor turns to pink to highlight the activated shape and then you can

- drag and resize it for lines, rectangles and circles/ellipses
- drag and move individual vertices for closed paths
- move individual vertices for open paths.

An activated shape is deleted by clicking on the `eraseshape` button.

```julia
using PlotlyJS

# define dragmode and add modebar buttons
config = PlotConfig(
    modeBarButtonsToAdd=[
        "drawline",
        "drawopenpath",
        "drawclosedpath",
        "drawcircle",
        "drawrect",
        "eraseshape",
    ]
)

text="Click and drag here <br> to draw a rectangle <br><br> or select another shape <br>in the modebar"
fig = plot(Layout(
    annotations=[
        attr(
            x=0.5,
            y=0.5,
            text=text,
            xref="paper",
            yref="paper",
            showarrow=false,
            font_size=20),
    ],
    # shape defined programmatically
    shapes=[
        attr(editable=true,
             x0=-1, x1=0, y0=2, y1=3,
             xref='x', yref='y',
        ),
    ],
    dragmode="drawrect",
), config=config)
```

### Style of user-drawn shapes

The layout `newshape` attribute controls the visual appearance of new shapes drawn by the user.
`newshape` attributes have the same names as layout shapes.

_Note on shape opacity_: having a new shape's opacity > 0.5 makes it possible to activate a shape by clicking inside the shape (for opacity <= 0.5 you have to click on the border of the shape), but you cannot start a new shape within an existing shape (which is possible for an opacity <= 0.5).

```julia
using PlotlyJS

text="Click and drag<br> to draw a rectangle <br><br> or select another shape <br>in the modebar"

fig = plot(
    Layout(
        annotations=[
            attr(
                x=0.5,
                y=0.5,
                text=text,
                xref="paper",
                yref="paper",
                showarrow=false,
                font_size=20,
            ),
        ],
        shapes=[
            attr(
                line_color="yellow",
                fillcolor="turquoise",
                opacity=0.4,
                editable=true,
                x0=0, x1=1, y0=2, y1=3,
                xref="x", yref="y",
            ),
        ],

        dragmode="drawrect",
        # style of new shapes
        newshape=attr(
            line_color="yellow",
            fillcolor="turquoise",
            opacity=0.5,
        ),
    ),
    config=PlotConfig(
        modeBarButtonsToAdd=[
            "drawline",
            "drawopenpath",
            "drawclosedpath",
            "drawcircle",
            "drawrect",
            "eraseshape",
        ],
    ),
)
```

### Reference

See <https://plotly.com/julia/reference/layout/shapes/> for more information and chart attribute options!
