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
    description: How to add dropdowns to update Plotly chart attributes in Julia.
    display_as: controls
    language: julia
    layout: base
    name: Dropdown Menus
    order: 2
    page_type: example_index
    permalink: julia/dropdowns/
    thumbnail: thumbnail/dropdown.jpg
---

#### Methods

The [updatemenu method](https://plotly.com/julia/reference/layout/updatemenus/#layout-updatemenus-buttons-method) determines which [plotly.js function](https://plotly.com/javascript/plotlyjs-function-reference/) will be used to modify the chart. There are 4 possible methods:

- `"restyle"`: modify data or data attributes
- `"relayout"`: modify layout attributes
- `"update"`: modify data **and** layout attributes
- `"animate"`: start or pause an [animation](https://plotly.com/julia/#animations)

## Restyle Dropdown

The `"restyle"` method should be used when modifying the data and data attributes of the graph.

### Update One Data Attribute

This example demonstrates how to update a single data attribute: chart `type` with the `"restyle"` method.

```julia
using PlotlyJS, CSV, DataFrames, HTTP, Tables

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv").body
) |> DataFrame

trace1 = surface(z=Tables.matrix(df), colorscale="Viridis")

layout = Layout(
    width=800,
    height=900,
    autosize=false,
    margin=attr(t=0, b=0, l=0, r=0),
    template="plotly_white",
    scene=attr(
        aspectratio=attr(x=1, y=1, z=0.7),
        aspectmode="manual"
    ),
    updatemenus=[
        attr(
            buttons=[
                attr(
                    args=["type", "surface"],
                    label="3D Surface",
                    method="restyle"
                ),
                attr(
                    args=["type", "heatmap"],
                    label="Heatmap",
                    method="restyle"
                )
            ],
            direction="down",
            pad_r=10,
            pad_t=10,
            showactive=true,
            x=0.1,
            xanchor="left",
            y=1.1,
            yanchor="top"
        )
    ],
    annotations=[
        attr(
            text="Trace type:",
            showarrow=false,
            x=0,
            y=1.085,
            yref="paper",
            align="left"
        )
    ]
)

plot(trace1, layout)
```

### Update Several Data Attributes

This example demonstrates how to update several data attributes: colorscale, colorscale direction, and line display with the "restyle" method.

```julia
using PlotlyJS, CSV, DataFrames, HTTP, Tables

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv").body
) |> DataFrame

trace = heatmap(z=Tables.matrix(df), colorscale="Viridis")

button_layer_1_height = 1.08
layout = Layout(
    width=800,
    height=800,
    autosize=false,
    margin=attr(t=100,b=0,l=0,r=0),
    scene=attr(
        aspectratio=attr(x=1,y=1,z=0.7),
        aspectmode="manual"
    ),
    updatemenus=[
        attr(
            buttons=[
                attr(
                    args=["colorscale", "Viridis"],
                    label="Viridis",
                    method="restyle"
                ),
                attr(
                    args=["colorscale", "Cividis"],
                    label="Cividis",
                    method="restyle"
                ),
                attr(
                    args=["colorscale", "Blues"],
                    label="Blues",
                    method="restyle"
                ),
                attr(
                    args=["colorscale", "Greens"],
                    label="Greens",
                    method="restyle"
                ),
            ],
            direction="down",
            pad_r=10,
            pad_t=10,
            showactive=true,
            x=0.1,
            xanchor="left",
            y=button_layer_1_height,
            yanchor="top"
        ),
        attr(
            buttons=[
                attr(
                    args=["reversescale", false],
                    label="False",
                    method="restyle"
                ),
                attr(
                    args=["reversescale", true],
                    label="True",
                    method="restyle"
                )
            ],
            direction="down",
            pad_r= 10,
            pad_t=10,
            showactive=true,
            x=0.37,
            xanchor="left",
            y=button_layer_1_height,
            yanchor="top"
        ),
        attr(
            buttons=[
                attr(
                    args=[attr(contours_showlines=false, type="contour")],
                    label="Hide lines",
                    method="restyle"
                ),
                attr(
                    args=[attr(contours_showlines=true, type="contour")],
                    label="Show lines",
                    method="restyle"
                ),
            ],
            direction="down",
            pad=attr(r=10, t=10),
            showactive=true,
            x=0.58,
            xanchor="left",
            y=button_layer_1_height,
            yanchor="top"
        )
    ]
)
```

## Relayout Dropdown

The `"relayout"` method should be used when modifying the layout attributes of the graph.<br>

### Update One Layout Attribute

This example demonstrates how to update a layout attribute: chart `type` with the `"relayout"` method.

```julia
using PlotlyJS, Distributions

x0 = rand(Normal(2, 0.4), 400)
y0 = rand(Normal(2, 0.4), 400)
x1 = rand(Normal(3, 0.6), 600)
y1 = rand(Normal(6, 0.4), 400)
x2 = rand(Normal(4, 0.2), 200)
y2 = rand(Normal(4, 0.4), 200)

trace1 = scatter(x=x0, y=y0, mode="markers", marker_color="DarkOrange")
trace2 = scatter(x=x1, y=y1, mode="markers", marker_color="Crimson")
trace3 = scatter(x=x2, y=y2, mode="markers", marker_color="RebeccaPurple")

# Add buttons that add shapes
cluster0 = [attr(type="circle",
                            xref="x", yref="y",
                            x0=minimum(x0), y0=minimum(y0),
                            x1=maximum(x0), y1=maximum(y0),
                            line=attr(color="DarkOrange"))]
cluster1 = [attr(type="circle",
                            xref="x", yref="y",
                            x0=minimum(x1), y0=minimum(y1),
                            x1=maximum(x1), y1=maximum(y1),
                            line=attr(color="Crimson"))]
cluster2 = [attr(type="circle",
                            xref="x", yref="y",
                            x0=minimum(x2), y0=minimum(y2),
                            x1=maximum(x2), y1=maximum(y2),
                            line=attr(color="RebeccaPurple"))]

layout = Layout(
    updatemenus=[
        attr(
            buttons=[
                attr(label="None",
                    method="relayout",
                    args=["shapes", []]),
                attr(label="Cluster 0",
                    method="relayout",
                    args=["shapes", cluster0]),
                attr(label="Cluster 1",
                    method="relayout",
                    args=["shapes", cluster1]),
                attr(label="Cluster 2",
                    method="relayout",
                    args=["shapes", cluster2]),
                attr(label="All",
                    method="relayout",
                    args=["shapes", vcat(cluster0, cluster1, cluster2)])
            ],
        )
    ],
    title_text="Highlight Clusters",
    showlegend=false
)

plot([trace1, trace2, trace3], layout)
```

### Update Dropdown

The `"update"` method should be used when modifying the data and layout sections of the graph.<br>
This example demonstrates how to update which traces are displayed while simultaneously updating layout attributes such as the chart title and annotations.

```python
import plotly.graph_objects as go

import pandas as pd

# Load dataset
df = pd.read_csv(
    "https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")
df.columns = [col.replace("AAPL.", "") for col in df.columns]

# Initialize figure
fig = go.Figure()

# Add Traces

fig.add_trace(
    go.Scatter(x=list(df.index),
               y=list(df.High),
               name="High",
               line=dict(color="#33CFA5")))

fig.add_trace(
    go.Scatter(x=list(df.index),
               y=[df.High.mean()] * len(df.index),
               name="High Average",
               visible=False,
               line=dict(color="#33CFA5", dash="dash")))

fig.add_trace(
    go.Scatter(x=list(df.index),
               y=list(df.Low),
               name="Low",
               line=dict(color="#F06A6A")))

fig.add_trace(
    go.Scatter(x=list(df.index),
               y=[df.Low.mean()] * len(df.index),
               name="Low Average",
               visible=False,
               line=dict(color="#F06A6A", dash="dash")))

# Add Annotations and Buttons
high_annotations = [dict(x="2016-03-01",
                         y=df.High.mean(),
                         xref="x", yref="y",
                         text="High Average:<br> %.3f" % df.High.mean(),
                         ax=0, ay=-40),
                    dict(x=df.High.idxmax(),
                         y=df.High.max(),
                         xref="x", yref="y",
                         text="High Max:<br> %.3f" % df.High.max(),
                         ax=0, ay=-40)]
low_annotations = [dict(x="2015-05-01",
                        y=df.Low.mean(),
                        xref="x", yref="y",
                        text="Low Average:<br> %.3f" % df.Low.mean(),
                        ax=0, ay=40),
                   dict(x=df.High.idxmin(),
                        y=df.Low.min(),
                        xref="x", yref="y",
                        text="Low Min:<br> %.3f" % df.Low.min(),
                        ax=0, ay=40)]

fig.update_layout(
    updatemenus=[
        dict(
            active=0,
            buttons=list([
                dict(label="None",
                     method="update",
                     args=[{"visible": [True, False, True, False]},
                           {"title": "Yahoo",
                            "annotations": []}]),
                dict(label="High",
                     method="update",
                     args=[{"visible": [True, True, False, False]},
                           {"title": "Yahoo High",
                            "annotations": high_annotations}]),
                dict(label="Low",
                     method="update",
                     args=[{"visible": [False, False, True, True]},
                           {"title": "Yahoo Low",
                            "annotations": low_annotations}]),
                dict(label="Both",
                     method="update",
                     args=[{"visible": [True, True, True, True]},
                           {"title": "Yahoo",
                            "annotations": high_annotations + low_annotations}]),
            ]),
        )
    ])

# Set title
fig.update_layout(title_text="Yahoo")

fig.show()
```

```julia
using PlotlyJS, CSV, DataFrames

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

x = range(1, stop=size(df)[1])
trace1 = scatter(
    df,
    x=x,
    y=df[!, "AAPL.High"] ,
    name="High",
    line_color="#33CFA5"
)

trace2 = scatter(
    df,
    x=x,
    y=repeat([mean(df[!, "AAPL.High"])], size(df)[1]),
    name="High Average",
    visible=false,
    line=attr(color="#33CFA5", dash="dash")
)

trace3 = scatter(
    df,
    x=x,
    y=df[!, "AAPL.Low"],
    name="Low",
    line_color="#F06A6A"
)
trace4 = scatter(
    df,
    x=x,
    y=repeat([mean(df[!, "AAPL.Low"])], size(df)[1]),
    name="Low Average",
    visible=false,
    line=attr(color="#F06A6A", dash="dash")
)

high_annotations = [attr(x="2016-03-01",
                         y=mean(df[:, "AAPL.High"]),
                         xref="x", yref="y",
                         text=string("High Average:<br> ", mean(df[:, "AAPL.High"])),
                         ax=0, ay=-40),
                    attr(x=argmax(df[!, "AAPL.High"]),
                         y=maximum(df[:, "AAPL.High"]),
                         xref="x", yref="y",
                         text=string("High Max:<br> ", maximum(df[:, "AAPL.High"])),
                         ax=0, ay=-40)]
low_annotations = [attr(x="2015-05-01",
                        y=mean(df[:, "AAPL.Low"]),
                        xref="x", yref="y",
                        text=string("Low Average:<br>", mean(df[:, "AAPL.Low"])),
                        ax=0, ay=40),
                   attr(x=argmin(df[!, "AAPL.High"]),
                        y=minimum(df[:, "AAPL.Low"]),
                        xref="x", yref="y",
                        text=string("Low Min:<br>", minimum(df[:, "AAPL.Low"])),
                        ax=0, ay=40)]

layout = Layout(
    updatemenus=[
        attr(
            active=0,
            buttons=[
                attr(
                    label="None",
                    method="update",
                    args=[
                        attr(visible= [true, false, true, false]),
                        attr(title= "Yahoo",
                            annotations=[]
                        )
                    ]
                ),
                attr(label="High",
                     method="update",
                     args=[
                        attr(visible= [true, true, false, false]),
                        attr(
                            title= "Yahoo High",
                            annotations=high_annotations
                        )
                    ]
                ),
                attr(
                    label="Low",
                    method="update",
                    args=[
                        attr(visible= [false, false, true, true]),
                        attr(
                            title= "Yahoo Low",
                            annotations=low_annotations
                        )
                    ]
                ),
                attr(
                    label="Both",
                    method="update",
                    args=[
                        attr(visible=[true, true, true, true]),
                        attr(
                            title="Yahoo",
                            annotations=vcat(high_annotations, low_annotations)
                        )
                    ]
                ),
            ],
        )
    ])

plot([trace1, trace2, trace3, trace4], layout)
```

#### Reference

See https://plotly.com/julia/reference/layout/updatemenus/ for more information about `updatemenu` dropdowns.
