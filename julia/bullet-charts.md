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
    description: How to make bullet charts in Julia with Plotly.
    display_as: financial
    language: julia
    layout: base
    name: Bullet Charts
    order: 8
    page_type: example_index
    permalink: julia/bullet-charts/
    thumbnail: thumbnail/bullet.png
---

#### Basic Bullet Charts

Stephen Few's Bullet Chart was invented to replace dashboard [gauges](https://plotly.com/julia/gauge-charts/) and meters, combining both types of charts into simple bar charts with qualitative bars (steps), quantitative bar (bar) and performance line (threshold); all into one simple layout.
Steps typically are broken into several values, which are defined with an array. The bar represent the actual value that a particular variable reached, and the threshold usually indicate a goal point relative to the value achieved by the bar. See [indicator page](https://plotly.com/julia/gauge-charts/) for more detail.

```julia
using PlotlyJS
plot(indicator(
    mode="number+gauge+delta",
    gauge_shape="bullet",
    value=220,
    delta_reference=300,
    domain_x=[0,1],
    domain_y=[0,1],
    title_text="Profit"
), Layout(height=250))
```

#### Add Steps, and Threshold

Below is the same example using "steps" attribute, which is shown as shading, and "threshold" to determine boundaries that visually alert you if the value cross a defined threshold.

```julia
using PlotlyJS

plot(indicator(
    mode="number+gauge+delta",
    value=220,
    domain_x=[0.1, 1],
    domain_y=[0, 1],
    title_text="<b>Profit</b>",
    delta_reference=200,
    gauge=attr(
        shape="bullet",
        axis_range=[nothing, 300],
        threshold=attr(
            line=attr(color="red", width=2),
            thickness=0.75,
            value=280
        ),
        steps=[
            attr(range=[0, 150], color="lightgray"),
            attr(range=[150, 250], color="gray")
        ]
    )
), Layout(height=250))
```

#### Custom Bullet

The following example shows how to customize your charts. For more information about all possible options check our [reference page](https://plotly.com/julia/reference/indicator/).

```julia
using PlotlyJS

plot(indicator(
    mode="number+gauge+delta",
    value=220,
    domain=attr(x=[0, 1], y=[0, 1]),
    delta=attr(reference=280, position="top"),
    title=attr(text="<b>Profit</b><br><span style=\'color: gray; font-size:0.8em\'>U.S. \$</span>", font_size=14),
    gauge=attr(
        shape="bullet",
        axis=attr(range=[nothing, 300]),
        threshold=attr(
            line=attr(color="red", width=2),
            thickness=0.75,
            value=270,
        ),
        bgcolor="white",
        steps=[
            attr(range=[0, 150], color="cyan"),
            attr(range=[150, 250], color="royalblue")
        ],
        bar_color="darkblue"
    )
), Layout(height=250))
```

#### Multi Bullet

Bullet charts can be stacked for comparing several values at once as illustrated below:

```julia
trace1 = indicator(
    mode="number+gauge+delta", value=180,
    delta=attr(reference=200),
    domain=attr(x=[0.25, 1], y=[0.08, 0.25]),
    title=attr(text="Revenue"),
    gauge=attr(
        shape="bullet",
        axis=attr(range=[nothing, 300]),
        threshold=attr(
            line=attr(color="black", width=2),
            thickness=0.75,
            value=170
        ),
        steps=[
            attr(range=[0, 150], color="gray"),
            attr(range=[150, 250], color="lightgray")
        ],
        bar=attr(color="black")
    )
)

trace2 = indicator(
    mode="number+gauge+delta", value=35,
    delta=attr(reference=200),
    domain=attr(x=[0.25, 1], y=[0.4, 0.6]),
    title=attr(text="Profit"),
    gauge=attr(
        shape="bullet",
        axis=attr(range=[nothing, 100]),
        threshold=attr(
            line=attr(color="black", width=2),
            thickness=0.75,
            value=50
        ),
        steps=[
            attr(range=[0, 25], color="gray"),
            attr(range=[25, 75], color="lightgray")
        ],
        bar=attr(color="black")
    )
)

trace3 = indicator(
    mode="number+gauge+delta", value=220,
    delta=attr(reference=200),
    domain=attr(x=[0.25, 1], y=[0.7, 0.9]),
    title=attr(text="Satisfaction"),
    gauge=attr(
        shape="bullet",
        axis=attr(range=[nothing, 300]),
        threshold=attr(
            line=attr(color="black", width=2),
            thickness=0.75,
            value=210
        ),
        steps=[
            attr(range=[0, 150], color="gray"),
            attr(range=[150, 250], color="lightgray")
        ],
        bar=attr(color="black")
    )
)

layout = Layout(height=400, margin=attr(t=0, b=0, l=0))

plot([trace1, trace2, trace3], layout)

```

#### Reference

See https://plotly.com/julia/reference/indicator/ for more information and chart attribute options!
