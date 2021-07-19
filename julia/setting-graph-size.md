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
    description: How to manipulate the graph size, margins and background color.
    display_as: file_settings
    language: python
    layout: base
    name: Setting Graph Size
    order: 11
    permalink: python/setting-graph-size/
    thumbnail: thumbnail/sizing.png
---

### Adjusting Height, Width, & Margins

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

plot(
    df,
    x=:total_bill,
    y=:tip,
    facet_col=:sex,
    kind="scatter",
    mode="markers",
    Layout(
        width=800,
        height=800,
        margin=attr(
            l=20,r=20,t=20,b=20
        ),
        paper_bgcolor="LightSteelBlue"
    )
)
```

### Adjusting Height, Width, & Margins With Trace Methods

Individual trace methods are the low-level building blocks of figures which you can use instead of `plot` for greater control.

```julia
using PlotlyJS

trace = scatter(
    x=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    y=[0, 1, 2, 3, 4, 5, 6, 7, 8]
)

layout = Layout(
    autosize=false,
    width=500,
    height=500,
    margin=attr(
        l=50,
        r=50,
        b=100,
        t=100,
        pad=4
    ),
    paper_bgcolor="LightSteelBlue",
)

plot(trace, layout)
```

### Automatically Adjust Margins

Set [automargin](https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-automargin) to `true` for the axis and Plotly will automatically increase the margin size to prevent ticklabels from being cut off or overlapping with axis titles.

```julia
using PlotlyJS

trace = bar(
    x=["Apples", "Oranges", "Watermelon", "Pears"],
    y=[3, 2, 1, 4]
)

layout = Layout(
    autosize=false,
    width=500,
    height=500,
    yaxis=attr(
        title_text="Y-axis Title Hello World",
        ticktext=["Very long label", "long label", "3", "label"],
        tickvals=[1, 2, 3, 4],
        tickmode="array",
        titlefont_size=30,
        automargin=true
    )
)

plot(trace, layout)
```

#### Reference

See https://plotly.com/julia/reference/layout/ for more information and chart attribute options!
