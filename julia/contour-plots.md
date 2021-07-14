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
    description: How to make Contour plots in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Contour Plots
    order: 1
    page_type: example_index
    permalink: julia/contour-plots/
    thumbnail: thumbnail/contour.jpg
---

### Basic Contour Plot

A 2D contour plot shows the [contour lines](https://en.wikipedia.org/wiki/Contour_line) of a 2D numerical array `z`, i.e. interpolated lines of isovalues of `z`.

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]'
))
```

### Setting X and Y Coordinates in a Contour Plot

```julia
using PlotlyJS

plot(contour(
    x=[-9, -6, -5 , -3, -1], # horizontal axis
    y=[0, 1, 4, 5, 7], # vertical axis
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]'
))
```

### Colorscale for Contour Plot

```julia
using PlotlyJS

plot(contour(
    colorscale="Electric",
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]'
))
```

### Customizing Size and Range of a Contour Plot's Contours

```julia
using PlotlyJS

plot(contour(
    z=z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    colorscale="Hot",
    contours_start=0,
    contours_end=8,
    contours_size=2
))

```

### Customizing Spacing Between X and Y Axis Ticks

```julia
using PlotlyJS
plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    dx=10, x0=5, dy=10, y0=10,
))
```

### Connect the Gaps Between None Values in the Z Matrix

```julia
using PlotlyJS

p = make_subplots(
    rows=2, cols=2,
    column_titles=["connectgaps = False"; "connectgaps = True"],
    row_titles=["Contour map"; "Heatmap"]
)
z = [
    [missing, missing, missing, 12, 13, 14, 15, 16],
    [missing, 1, missing, 11, missing, missing, missing, 17],
    [missing, 2, 6, 7, missing, missing, missing, 18],
    [missing, 3, missing, 8, missing, missing, missing, 19],
    [5, 4, 10, 9, missing, missing, missing, 20],
    [missing, missing, missing, 27, missing, missing, missing, 21],
    [missing, missing, missing, 26, 25, 24, 23, 22]
]

add_trace!(p, contour(z=z, showscale=false), row=1, col=1)
add_trace!(p, contour(z=z, showscale=false, connectgaps=true), row=1, col=2)
add_trace!(p, heatmap(z=z, showscale=false, zsmooth="best"), row=2, col=1)
add_trace!(p, heatmap(z=z, showscale=false, connectgaps=true, zsmooth="best"), row=2, col=2)

p
```

### Smoothing the Contour lines

```julia
using PlotlyJS

z = [
    2  4   7   12  13  14  15  16
    3  1   6   11  12  13  16  17
    4  2   7   7   11  14  17  18
    5  3   8   8   13  15  18  19
    7  4   10  9   16  18  20  19
    9  10  5   27  23  21  21  21
    11 14  17  26  25  24  23  22
]'

p = make_subplots(
    rows=1, cols=2, column_titles=["Without Smoothing"; "With Smoothing"]
)

add_trace!(p, contour(z=z, line_smoothing=0), row=1, col=1)
add_trace!(p, contour(z=z, line_smoothing=0.85), row=1, col=2)

p
```

### Smooth Contour Coloring

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    # heatmap gradient coloring is applied between each contour level
    contours_coloring="heatmap" # can also be "lines", or "none"
))
```

### Contour Line Labels

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    # heatmap gradient coloring is applied between each contour level
    contours=attr(
        coloring ="heatmap",
        showlabels = true, # show labels on contours
        labelfont = attr( # label font properties
            size = 12,
            color = "white",
        )
    )
))
```

### Contour Lines

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    contours_coloring="lines",
    line_width=2,
))
```

### Custom Contour Plot Colorscale

```julia
using PlotlyJS

# Valid color strings are CSS colors, rgb or hex strings
colorscale = [[0, "gold"], [0.5, "mediumturquoise"], [1, "lightsalmon"]]

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
   colorscale=colorscale,
))

```

### Color Bar Title

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    colorbar=attr(
        title="Color bar title", # title here
        titleside="right",
        titlefont=attr(
            size=14,
            family="Arial, sans-serif"
        )
    )
))
```

### Color Bar Size for Contour Plots

In the example below, both the thickness (given here in pixels) and the length (given here as a fraction of the plot height) are set.

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    colorbar=attr(
        thickness=25,
        thicknessmode="pixels",
        len=0.6,
        lenmode="fraction",
        outlinewidth=0
    )
))
```

### Styling Color Bar Ticks for Contour Plots

```julia
using PlotlyJS

plot(contour(
    z=[
        10      10.625      12.5       15.625     20
        5.625    6.25       8.125      11.25      15.625
        2.5      3.125      5.         8.125      12.5
        0.625    1.25       3.125      6.25       10.625
        0        0.625      2.5        5.625      10
    ]',
    colorbar=attr(
        nticks=10, ticks="outside",
        ticklen=5, tickwidth=1,
        showticklabels=true,
        tickangle=0, tickfont_size=12
    )
))
```

#### Reference

See https://plotly.com/julia/reference/contour/ for more information and chart attribute options!
