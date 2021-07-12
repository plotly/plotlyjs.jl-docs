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
    description: How to make an inset graph in julia.
    display_as: multiple_axes
    language: julia
    layout: base
    name: Inset Plots
    order: 3
    page_type: example_index
    permalink: julia/insets/
    thumbnail: thumbnail/insets.jpg
---

## Simple Inset Plot

You can make an inset plot using the `inset` argument to `make_subplots`

This argument expects an array of `Inset` objects. The `Inset` object has the following fields:

```julia
using PlotlyJS

@doc Inset
```

To use `make_subplots` with inset charts, you first create an empty plot using `make_subplots` and then add traces to the subplots (including the inset):

```julia
using PlotlyJS
p = make_subplots(insets=[Inset(cell=(1,1), l=0.7, b=0.6)]);

# second trace is added to axes (x2, y2), which is the insets
addtraces!(p, scatter(y=rand(10)), scatter(y=1:5, yaxis="y2", xaxis="x2", name="inset"))
p
```

You can also have inset charts in subplots that are not the first subplot.

Note that inset plots are assigned their "index" after all non inset subplots.

In the example below the top subplot has index (1,1), the bottom subplot has index (2,2) and the inset subplot has index (3,3).

```julia
using PlotlyJS
p = make_subplots(insets=[Inset(cell=(2,1), l=0.7, b=0, h=0.5)], rows=2, cols=1);
addtraces!(
    p,
    scatter(y=rand(10), name="top"),
    scatter(y=1:5, yaxis="y2", xaxis="x2", name="bottom"),
    scatter(y=5:-1:1, yaxis="y3", xaxis="x3", name="inset"),
)
p
```
