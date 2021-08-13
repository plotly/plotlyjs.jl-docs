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
    description: How to make 2D Histogram Contour plots in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: 2D Histogram Contour
    order: 11
    page_type: u-guide
    permalink: julia/2d-histogram-contour/
    redirect_from: julia/2d-density-plots/
    thumbnail: thumbnail/hist2dcontour.png
---

## 2D Histogram Contours or Density Contours

A 2D histogram contour plot, also known as a density contour plot, is a 2-dimensional generalization of a [histogram](/julia/histograms/) which resembles a [contour plot](/julia/contour-plots/) but is computed by grouping a set of points specified by their `x` and `y` coordinates into bins, and applying an aggregation function such as `count` or `sum` (if `z` is provided) to compute the value to be used to compute contours. This kind of visualization (and the related [2D histogram, or density heatmap](/julia/2d-histogram/)) is often used to manage over-plotting, or situations where showing large data sets as [scatter plots](/julia/line-and-scatter/) would result in points overlapping each other and hiding patterns.

### 2D Histograms with Graph Objects

#### Basic 2D Histogram Contour

```julia
using PlotlyJS, Distributions

x = rand(Uniform(-1,1), 500)
y = rand(Uniform(-1,1), 500)

plot(histogram2dcontour(x=x,y=y))
```

#### 2D Histogram Contour Colorscale

```julia
using PlotlyJS, Distributions

x = rand(Uniform(-1,1), 500)
y = rand(Uniform(-1,1), 500)

plot(histogram2dcontour(x=x,y=y, colorscale="Blues"))
```

#### 2D Histogram Contour Styled

```julia
using PlotlyJS, Distributions

x = rand(Uniform(-1,1), 500)
y = rand(Uniform(-1,1), 500)

plot(histogram2dcontour(
        x = x,
        y = y,
        colorscale = "Jet",
        contours = attr(
            showlabels = true,
            labelfont = attr(
                family = "Raleway",
                color = "white"
            )
        ),
        hoverlabel = attr(
            bgcolor = "white",
            bordercolor = "black",
            font = attr(
                family = "Raleway",
                color = "black"
            )
        )

))
```

#### 2D Histogram Contour Subplot

```julia
using PlotlyJS

t = range(-1, stop=1.2, length=2000)
x = (t .^ 3) .+ (0.3 .* randn(2000))
y = (t .^ 6) .+ (0.3 .* randn(2000))

trace1 = histogram2dcontour(
        x = x,
        y = y,
        colorscale = "Blues",
        reversescale = true,
        xaxis = "x",
        yaxis = "y"
    )
trace2 = scatter(
        x = x,
        y = y,
        xaxis = "x",
        yaxis = "y",
        mode = "markers",
        marker = attr(
            color = "rgba(0,0,0,0.3)",
            size = 3
        )
    )
trace3 = histogram(
        y = y,
        xaxis = "x2",
        marker = attr(
            color = "rgba(0,0,0,1)"
        )
    )
trace4 = histogram(
        x = x,
        yaxis = "y2",
        marker = attr(
            color = "rgba(0,0,0,1)"
        )
    )

layout = Layout(
    autosize = false,
    xaxis = attr(
        zeroline = false,
        domain = [0,0.85],
        showgrid = false
    ),
    yaxis = attr(
        zeroline = false,
        domain = [0,0.85],
        showgrid = false
    ),
    xaxis2 = attr(
        zeroline = false,
        domain = [0.85,1],
        showgrid = false
    ),
    yaxis2 = attr(
        zeroline = false,
        domain = [0.85,1],
        showgrid = false
    ),
    height = 600,
    width = 600,
    bargap = 0,
    hovermode = "closest",
    showlegend = false
)

plot([trace1, trace2, trace3, trace4], layout)
```

#### Reference

See https://plotly.com/julia/reference/histogram2dcontour/ for more information and chart attribute options!
