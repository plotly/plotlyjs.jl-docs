---
jupyter:
  jupytext:
    formats: ipynb,md
    notebook_metadata_filter: plotly
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.1
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
  plotly:
    description: How to make Bar Charts in Julia with PlotlyJS.jl.
    display_as: basic
    language: julia
    layout: base
    name: Bar Charts
    order: 3
    page_type: example_index
    permalink: julia/bar-charts/
    thumbnail: thumbnail/bar.jpg
---

```julia
using PlotlyJS
```

```julia
function bar1()
    data = bar(;x=["giraffes", "orangutans", "monkeys"],
                y=[20, 14, 23])
    plot(data)
end
bar1()
```
