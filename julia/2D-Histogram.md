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
    description: How to make 2D Histograms in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: 2D Histograms
    order: 5
    page_type: example_index
    permalink: julia/2D-Histogram/
    redirect_from:
    - julia/2d-histogram/
    - julia/2d-histograms/
    thumbnail: thumbnail/histogram2d.jpg
---

## 2D Histograms or Density Heatmaps

A 2D histogram, also known as a density heatmap, is the 2-dimensional generalization of a [histogram](/julia/histograms/) which resembles a [heatmap](/julia/heatmaps/) but is computed by grouping a set of points specified by their `x` and `y` coordinates into bins, and applying an aggregation function such as `count` or `sum` (if `z` is provided) to compute the color of the tile representing the bin. This kind of visualization (and the related [2D histogram contour, or density contour](https://plotly.com/julia/2d-histogram-contour/)) is often used to manage over-plotting, or situations where showing large data sets as [scatter plots](/julia/line-and-scatter/) would result in points overlapping each other and hiding patterns.

## Density Heatmaps

You can make a density heatmap using the `histogram2d` trace type and setting `xbingroup="x"` and `ybingroup="y"`

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:total_bill, y=:tip, xbingroyp="x", ybingroup="y", kind="histogram2d")
```

The number of bins can be controlled with `nbinsx` and `nbinsy` and the color scale with `colorscale`.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(
    df, x=:total_bill, y=:tip, xbingroyp="x", ybingroup="y", kind="histogram2d",
    nbinsx=20, nbinsy=20, colorscale="Viridis"
)
```

Density heatmaps can also be [faceted](/julia/facet-plots/):

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")

plot(
    df, x=:total_bill, y=:tip, xbingroyp="x", ybingroup="y", kind="histogram2d",
    facet_row=:sex, facet_col=:smoker
)
```

### 2D Histogram of a Bivariate Normal Distribution ###

```julia
using PlotlyJS, Random
Random.seed!(41)
plot(histogram2d(x=randn(500), y=randn(500) .+ 1))
```

### 2D Histogram Overlaid with a Scatter Chart ###

```julia
using PlotlyJS, Random

x0 = randn(100) ./ 5. .+ 0.5  # 5. enforces float division
y0 = randn(100) ./ 5. .+ 0.5
x1 = rand(50)
y1 = rand(50) .+ 1.0

x = [x0; x1]
y = [y0; y1]

plot(
    [
        scatter(
            x=x0, y=y0, mode="markers",
            marker=attr(symbol="x", opacity=0.7, color="white", size=8, line_width=1)
        ),
        scatter(
            x=x1, y=y1, mode="markers",
            marker=attr(symbol="circle", opacity=0.7, color="white", size=8, line_width=1)
        ),
        histogram2d(x=x, y=y, colorscale="YlGnBu", zmax=10, nbinsx=14, nbinsy=14, zauto=false)
    ],
    Layout(
        xaxis=attr(ticks="", showgrid=false, zeroline=false, nticks=20),
        yaxis=attr(ticks="", showgrid=false, zeroline=false, nticks=20),
        autosize=false,
        height=550,
        width=550,
        hovermode="closest",
        showlegend=false,
    )
)
```

#### Reference

See https://plotly.com/julia/reference/histogram2d/ for more information and chart attribute options!
