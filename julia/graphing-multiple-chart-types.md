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
    description: How to design figures with multiple chart types in julia.
    display_as: file_settings
    language: julia
    layout: base
    name: Multiple Chart Types
    order: 18
    page_type: u-guide
    permalink: julia/graphing-multiple-chart-types/
    thumbnail: thumbnail/multiple-chart-type.jpg
---

### Chart Types versus Trace Types

Plotly figures support defining [subplots](/julia/subplots/) of various types (e.g. cartesian, [polar](/julia/polar-chart/), [3-dimensional](/julia/3d-charts/), [maps](/julia/maps/) etc) with attached traces of various compatible types (e.g. scatter, bar, choropleth, surface etc). This means that **Plotly figures are not constrained to representing a fixed set of "chart types"** such as scatter plots only or bar charts only or line charts only: any subplot can contain multiple traces of different types.


### Multiple Trace Types with Plotly Express

The first argument to the `plot` function accepts and array of traces. Each of these traces can be of a different (but compatible) type. For example, below we have a line and bar chart in the same figure:


```julia
using PlotlyJS

fruits = ["apples", "oranges", "bananas"]
plot([
    scatter(x=fruits, y=[1, 3, 2], name="This year", mode="lines"),
    bar(x=fruits, y=[2, 1, 3], name="Last year", mode="lines")
])
```

#### A Contour and Scatter Plot of the Method of Steepest Descent

The example below shows how to display both a scatter plot and contour plot on the same axes.

This is useful for demonstrating progress in a steepest descent algorithm

```julia
using PlotlyJS, HTTP, JSON

response = HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/steepest.json")
data = JSON.parse(String(response.body))

plot([
    contour(
        z=data["contour_z"][1],
        y=data["contour_y"][1],
        x=data["contour_x"][1],
        ncontours=30,
        showscale=false
    ),
    scatter(
        x=data["trace_x"], y=data["trace_y"], mode="markers+lines",
        name="steepest", line_color="black"
    )
])
```

#### Reference

See https://plotly.com/julia/reference/ for more information and attribute options!
