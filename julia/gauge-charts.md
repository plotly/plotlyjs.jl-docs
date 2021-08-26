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
    description: How to make gauge meter charts in Julia with Plotly.
    display_as: financial
    language: julia
    layout: base
    name: Gauge Charts
    order: 7
    page_type: example_index
    permalink: julia/gauge-charts/
    redirect_from:
      - julia/gauge-chart/
      - julia/gauge-meter/
    thumbnail: thumbnail/gauge.jpg
---

#### Basic Gauge

A radial gauge chart has a circular arc, which displays a single value to estimate progress toward a goal.
The bar shows the target value, and the shading represents the progress toward that goal. Gauge charts, known as
speedometer charts as well. This chart type is usually used to illustrate key business indicators.

The example below displays a basic gauge chart with default attributes. For more information about different added attributes check [indicator](https://plotly.com/julia/indicator/) tutorial.

```julia
using PlotlyJS

plot(indicator(
    mode = "gauge+number",
    value = 270,
    domain_x= [0, 1],
    domain_y= [0, 1],
    title_text = "Speed"))

```

#### Add Steps, Threshold, and Delta

The following examples include "steps" attribute shown as shading inside the radial arc, "delta" which is the
difference of the value and goal (reference - value), and "threshold" to determine boundaries that visually alert you if the value cross a defined threshold.

```julia
using PlotlyJS

plot(indicator(
    domain = attr(x= [0, 1], y= [0, 1]),
    value = 450,
    mode = "gauge+number+delta",
    title = attr(text= "Speed"),
    delta = attr(reference= 380),
    gauge = attr(
        axis= attr(range= [nothing, 500]),
        steps = [
            attr(range= [0, 250], color= "lightgray"),
            attr(range= [250, 400], color= "gray")
        ],
        threshold = attr(line= attr(color= "red", width= 4), thickness= 0.75, value= 490))))

```

#### Custom Gauge Chart

The following example shows how to style your gauge charts. For more information about all possible options check our [reference page](https://plotly.com/julia/reference/indicator/).

```julia
using PlotlyJS

plot(
    indicator(
        mode = "gauge+number+delta",
        value = 420,
        domain = attr(x= [0, 1], y= [0, 1]),
        title = attr(text= "Speed", font= attr(size= 24)),
        delta = attr(reference= 400,increasing= attr(color="RebeccaPurple")),
        gauge = attr(
            axis= attr(range= [nothing, 500], tickwidth= 1, tickcolor= "darkblue"),
            bar= attr(color= "darkblue"),
            bgcolor= "white",
            borderwidth= 2,
            bordercolor= "gray",
            steps= [
                attr(range= [0, 250], color= "cyan"),
                attr(range= [250, 400], color= "royalblue")],
            threshold= attr(
                line= attr(color= "red", width= 4),
                thickness= 0.75,
                value= 490
            )
        )
    ),
    Layout(paper_bgcolor = "lavender", font = attr(color= "darkblue", family= "Arial"))
)

```

#### Reference

See https://plotly.com/julia/reference/indicator/ for more information and chart attribute options!
