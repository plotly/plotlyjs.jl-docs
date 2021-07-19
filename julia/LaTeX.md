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
    description: How to add LaTeX to julia graphs.
    display_as: advanced_opt
    language: julia
    layout: base
    name: LaTeX
    order: 5
    page_type: example_index
    permalink: julia/LaTeX/
    thumbnail: thumbnail/latex.jpg
---

#### LaTeX Typesetting

Figure titles, axis labels and annotations all accept LaTeX directives for rendering mathematical formulas and notation, when the entire label is surrounded by dollar signs `$...$`. This rendering is handled by the [MathJax library](https://www.mathjax.org/) (version 2.7.5), which must be loaded in the environment where figures are being rendered. MathJax is included by default in Jupyter-like environments, but when embedding Plotly figures in other contexts it may be required to ensure that MathJax is separately loaded, for example via a `<script>` tag pointing to a content-delivery network (CDN).

<!-- TODO:can't get LaTeX strings to render -->

```julia
using PlotlyJS, LaTeXStrings

trace1 = scatter(
    x=[1, 2, 3, 4],
    y=[1, 4, 9, 16],
    mode="lines",
)

plot(trace1, Layout(
    xaxis_title=L"$\sqrt{(n_\text{c}(t|{T_\text{early}}))}$",
    yaxis_title=L"$d, r \text{ (solar radius)}$",
    title= L"\\alpha_{1c} = 352 \pm 11 \\text{ km s}^{-1}"
))

```

```julia
using PlotlyJS, LaTeXStrings

trace1 = scatter(
    x=[1, 2, 3, 4],
    y=[1, 4, 9, 16],
    mode="markers",
    name=L"$\alpha_{1c} = 352 \pm 11 \text{ km s}^{-1}$"
))

trace2 = scatter(
    x=[1, 2, 3, 4],
    y=[0.5, 2, 4.5, 8],
    name=L"$\beta_{1c} = 25 \pm 11 \text{ km s}^{-1}$"
))
layout = Layout(
    xaxis_title=L"$\sqrt{(n_\text{c}(t|{T_\text{early}}))}$",
    yaxis_title=L"$d, r \text{ (solar radius)}$"
)

plot([trace1, trace2], layout)
```
