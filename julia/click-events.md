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
    description: Click Events With FigureWidget
    display_as: chart_events
    language: julia
    layout: base
    name: Click Events
    order: 4
    page_type: example_index
    permalink: julia/click-events/
    thumbnail: thumbnail/figurewidget-click-events.gif
---

#### Update Points Using a Click Callback

In this example, whenever we click on a point we change its marker symbol to a star and marker color to gold:

```julia
using PlotlyJS, WebIO
color_vec = (fill("red", 10), fill("blue", 10))
symbols = (fill("circle", 10), fill("circle", 10))
ys = (rand(10), rand(10))
p = plot(
    [scatter(y=y, marker=attr(color=c, symbol=s, size=15), line_color=c[1])
    for (y, c, s) in zip(ys, color_vec, symbols)]
)
# display(p)  # usually optional

on(p["click"]) do data
    color_vec = (fill("red", 10), fill("blue", 10))
    symbols = (fill("circle", 10), fill("circle", 10))
    for point in data["points"]
        color_vec[point["curveNumber"] + 1][point["pointIndex"] + 1] = "gold"
        symbols[point["curveNumber"] + 1][point["pointIndex"] + 1] = "star"
    end
    restyle!(p, marker_color=color_vec, marker_symbol=symbols)
end
p
```

Note this example only works when running Julia locally as the logic for updating the point runs in Julia, not in the web browser.

This means that you can execute arbitrary Julia logic in response to clicks on your charts!

<img src='https://raw.githubusercontent.com/michaelbabyn/plot_data/master/figurewidget-click-event.gif'>
