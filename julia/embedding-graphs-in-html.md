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
    description: How to embed plotly graphs in an iframe in HTML.
    display_as: file_settings
    language: julia
    layout: base
    name: Embedding Plotly Graphs in HTML
    order: 22
    permalink: julia/embedding-plotly-graphs-in-html/
    thumbnail: thumbnail/text-and-annotations.png
---

#### Saving An HTML in Julia

Plotly graphs can be embedd in any HTLM page. This includes [iPython notebooks](https://plotly.com/ipython-notebooks/),
[Wordpress sites](https://wordpress.org/plugins/wp-plotly), dashboard, blogs and more.

To export a plot as html, use the `PlotlyBase.to_html` method passing in an IO buffer and the `plot` attribute of
a generated plot:

```julia
using PlotlyJS

p = plot(scatter(x=[0,1,2], y=[3,6,2]))

open("path/to/file.html", "w") do io
    PlotlyBase.to_html(io, p.plot)
end
```

#### Controlling the Size of the HTML file

To set the default height and width of the generated html, use `default_height` and `default_width` of the `to_html` method:

```julia
using PlotlyJS

p = plot(scatter(x=[0,1,2], y=[3,6,2]))

open("path/to/file.html", "w") do io
    PlotlyBase.to_html(io, p.plot, default_height="400px", default_width="400px")
end
```
