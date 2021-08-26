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
    description: How to add images to charts as background images or logos.
    display_as: file_settings
    language: julia
    layout: base
    name: Images
    order: 24
    permalink: julia/images/
    thumbnail: thumbnail/images.png
    v4upgrade: true
---

#### Add a Background Image

In this page we explain how to add static, non-interactive images as background, logo or annotation images to a figure. For exploring image data in interactive charts, see the [tutorial on displaying image data](/julia/imshow).

A background image can be added to the layout of a figure with the `images` parameter of `gLayout`. The
`source` attribute of a `layout.Image` should be the URL of the image.

```julia
using PlotlyJS

# Add trace
trace= scatter(x=[0, 0.5, 1, 2, 2.2], y=[1.23, 2.5, 0.42, 3, 1])

# Add images
layout = Layout(
    template=templates.plotly_white,
    images=[
        attr(
            source="https://upload.wikimedia.org/wikipedia/commons/1/1f/Julia_Programming_Language_Logo.svg",
            xref="x",
            yref="y",
            x=0,
            y=3,
            sizex=2,
            sizey=2,
            sizing="stretch",
            opacity=0.5,
            layer="below"
        )
    ]
)

plot(trace, layout)
```

#### Add a Logo

```julia
using PlotlyJS

trace = bar(
    x=["-35.3", "-15.9", "-15.8", "-15.6", "-11.1",
        "-9.6", "-9.2", "-3.5", "-1.9", "-0.9",
        "1.0", "1.4", "1.7", "2.0", "2.8", "6.2",
        "8.1", "8.5", "8.5", "8.6", "11.4", "12.5",
        "13.3", "13.7", "14.4", "17.5", "17.7",
        "18.9", "25.1", "28.9", "41.4"],
    y=["Designers, musicians, artists, etc.",
        "Secretaries and administrative assistants",
        "Waiters and servers", "Archivists, curators, and librarians",
        "Sales and related", "Childcare workers, home car workers, etc.",
        "Food preparation occupations", "Janitors, maids, etc.",
        "Healthcare technicians, assistants. and aides",
        "Counselors, social and religious workers",
        "Physical, life and social scientists", "Construction",
        "Factory assembly workers", "Machinists, repairmen, etc.",
        "Media and communications workers", "Teachers",
        "Mechanics, repairmen, etc.", "Financial analysts and advisers",
        "Farming, fishing and forestry workers",
        "Truck drivers, heavy equipment operator, etc.", "Accountants and auditors",
        "Human resources, management analysts, etc.", "Managers",
        "Lawyers and judges", "Engineers, architects and surveyors",
        "Nurses", "Legal support workers",
        "Computer programmers and system admin.", "Police officers and firefighters",
        "Chief executives", "Doctors, dentists and surgeons"],
    orientation="h",
    marker=attr(color="rgb(253, 240, 54)", line_color="rgb(0,0,0)", line_width=2)
)



# update layout properties
layout = Layout(
    images=[ attr(
        source="https://raw.githubusercontent.com/cldougl/plot_images/add_r_img/vox.png",
        xref="paper", yref="paper",
        x=1, y=1.05,
        sizex=0.2, sizey=0.2,
        xanchor="right", yanchor="bottom"
    )],
    autosize=false,
    height=800,
    width=700,
    bargap=0.15,
    bargroupgap=0.1,
    barmode="stack",
    hovermode="x",
    margin=attr(r=20, l=300, b=75, t=125),
    title="Moving Up, Moving Down<br> <i>Percentile change in income between childhood and adulthood</i>",
)

plot(trace, layout)
```

#### Zoom on Static Images

```julia
using PlotlyJS

# Constants
img_width = 1600
img_height = 900
scale_factor = 0.5

# Add invisible scatter trace.
# This trace is added to help the autoresize logic work.
trace1 = scatter(
        x=[0, img_width * scale_factor],
        y=[0, img_height * scale_factor],
        mode="markers",
        marker_opacity=0
    )

layout = Layout(
    xaxis = attr(
        visible=false,
        range=[0, img_width * scale_factor]
    ),
    yaxis=attr(
        visible=false,
        range=[0, img_height * scale_factor],
        # the scaleanchor attribute ensures that the aspect ratio stays constant
        scaleanchor="x"
    ),
    images=[
        attr(
            x=0,
            sizex=img_width * scale_factor,
            y=img_height * scale_factor,
            sizey=img_height * scale_factor,
            xref="x",
            yref="y",
            opacity=1.0,
            layer="below",
            sizing="stretch",
            source="https://raw.githubusercontent.com/michaelbabyn/plot_data/master/bridge.jpg"
        )
    ],
    width=img_width * scale_factor,
    height=img_height * scale_factor,
    margin=attr(l= 0, r= 0, t= 0, b= 0),
)

plot(trace, layout)
```

### Annotating layout image with shapes

It can be useful to add shapes to a layout image, for highlighting an object, drawing bounding boxes as part of a machine learning training set, or identifying seeds for a segmentation algorithm.

In order to enable shape drawing, you need to

- define a dragmode corresponding to a drawing tool (`'drawline'`,`'drawopenpath'`, `'drawclosedpath'`, `'drawcircle'`, or `'drawrect'`)
- add [modebar buttons](/julia/configuration-options#add-optional-shapedrawing-buttons-to-modebar) corresponding to the drawing tools you wish to use.

The style of new shapes is specified by the `newshape` layout attribute. Shapes can be selected and modified after they have been drawn. More details and examples are given in the [tutorial on shapes](/julia/shapes#drawing-shapes-on-cartesian-plots).

Drawing or modifying a shape triggers a `relayout` event, which [can be captured by a callback inside a Dash application](https://dash-julia.plotly.com/interactive-graphing).


```julia
using PlotlyJS

# Add image
img_width = 1600
img_height = 900
scale_factor = 0.5

layout = Layout(
    xaxis = attr(showgrid=false, range=(0,img_width)),
    yaxis = attr(showgrid=false, scaleanchor="x", range=(img_height, 0)),
    images=[
        attr(
            x=0,
            sizex=img_width,
            y=0,
            sizey=img_height,
            xref="x",
            yref="y",
            opacity=1.0,
            layer="below",
            source="https://raw.githubusercontent.com/michaelbabyn/plot_data/master/bridge.jpg"
        )
    ],
    dragmode="drawrect",
    newshape=attr(line_color="cyan"),
    title_text="Drag to add annotations - use modebar to change drawing tool",
    modebar_add=[
        "drawline",
        "drawopenpath",
        "drawclosedpath",
        "drawcircle",
        "drawrect",
        "eraseshape"
    ],
)

plot(layout)
```

### Images Placed Relative to Axes

Using `xref='x domain'` or `yref='y domain'`, images can be placed relative to
axes. As an example, the following shows how to put an image in the top corner
of a subplot (try panning and zooming the resulting figure):

<!-- TODO: Images are only going on first facet col -->

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
sources = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Iris_setosa_var._setosa_%282595031014%29.jpg/360px-Iris_setosa_var._setosa_%282595031014%29.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Iris_versicolor_quebec_1.jpg/320px-Iris_versicolor_quebec_1.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Iris_virginica_2.jpg/480px-Iris_virginica_2.jpg",
]

function make_iris_image(src)
    attr(
        source=src,
        xref="x domain",
        yref="y domain",
        x=1,
        y=1,
        xanchor="right",
        yanchor="top",
        sizex=0.2,
        sizey=0.2,
    )
end

p = plot(
    df,
    kind="scatter",
    mode="markers",
    x=:sepal_length,
    y=:sepal_width,
    facet_col=:species,
)

for (col, src) in enumerate(sources)
    add_layout_image!(p, make_iris_image(src), row=1, col=col)
end
p
```

#### Reference

See https://plotly.com/julia/reference/layout/images/ for more information and chart attribute options!
