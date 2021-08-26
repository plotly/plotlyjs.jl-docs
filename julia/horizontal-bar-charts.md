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
    description: How to make horizontal bar charts in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Horizontal Bar Charts
    order: 8
    page_type: example_index
    permalink: julia/horizontal-bar-charts/
    thumbnail: thumbnail/horizontal-bar.jpg
---

See more examples of bar charts (including vertical bar charts) and styling options [here](https://plotly.com/julia/bar-charts/).

### Horizontal Bar Chart

For a horizontal bar char, use the `bar` function with `orientation="h"`.

#### Basic Horizontal Bar Chart with Plotly Express

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(bar(df, x=:total_bill, y=:day, orientation="h"))
```

#### Configure horizontal bar chart

In this example a column is used to color the bars, and we add the information from other columns to the hover data.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(bar(df, x=:total_bill, y=:sex, group=:day, orientation="h",
             hover_data=["tip", "size"],
), Layout(
    height=400,
    title="Restaurant bills"
))
```

### Reference

See more examples of bar charts and styling options [here](https://plotly.com/julia/bar-charts/).<br> See https://plotly.com/julia/reference/bar/ for more information and chart attribute options!
