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
    description:
      Plotly allows you to save interactive HTML versions of your figures
      to your local disk.
    display_as: file_settings
    language: julia
    layout: base
    name: Interactive HTML Export
    order: 31
    page_type: example_index
    permalink: julia/interactive-html-export/
    thumbnail: thumbnail/static-image-export.png
---

### Interactive vs Static Export

Plotly figures are interactive when viewed in a web browser: you can hover over data points, pan and zoom axes, and show and hide traces by clicking or double-clicking on the legend. You can export figures either to [static image file formats like PNG, JPEG, SVG or PDF] or you can export them to HTML files which can be opened in a browser. This page explains how to do the latter.

### Saving to an HTML file

Any figure can be saved as an HTML file using the `PlotlyBase.to_html` method. These HTML files can be opened in any web browser to access the fully interactive figure.

```julia
using PlotlyJS
p = plot(scatter(x=1:10, y=1:10))

open("./example.html", "w") do io
    PlotlyBase.to_html(io, p.plot)
end
```

### Controlling the size of the HTML file

By default, the resulting HTML file is a fully self-contained HTML file which can be uploaded to a web server or shared via email or other file-sharing mechanisms. The downside to this approach is that the file is very large (5Mb+) because it contains an inlined copy of the Plotly.js library required to make the figure interactive. This can be controlled via the `include_plotlyjs` argument (see below).

### Full Parameter Documentation

```julia
using PlotlyJS

@doc PlotlyBase.to_html
```
