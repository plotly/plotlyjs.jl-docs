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
    description: How to make Sankey Diagrams in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Sankey Diagram
    order: 12
    page_type: example_index
    permalink: julia/sankey-diagram/
    thumbnail: thumbnail/sankey.jpg
---

A [Sankey diagram](https://en.wikipedia.org/wiki/Sankey_diagram) is a flow diagram, in which the width of arrows is proportional to the flow quantity.

### Basic Sankey Diagram

Sankey diagrams visualize the contributions to a flow by defining [source](https://plotly.com/julia/reference/sankey/#sankey-link-source) to represent the source node, [target](https://plotly.com/julia/reference/sankey/#sankey-link-target) for the target node, [value](https://plotly.com/julia/reference/sankey/#sankey-link-value) to set the flow volume, and [label](https://plotly.com/julia/reference/sankey/#sankey-node-label) that shows the node name.

```julia
using PlotlyJS

plot(sankey(
    node = attr(
      pad = 15,
      thickness = 20,
      line = attr(color = "black", width = 0.5),
      label = ["A1", "A2", "B1", "B2", "C1", "C2"],
      color = "blue"
    ),
    link = attr(
      source = [0, 1, 0, 2, 3, 3], # indices correspond to labels, eg A1, A2, A1, B1, ...
      target = [2, 3, 3, 4, 4, 5],
      value = [8, 4, 2, 8, 4, 2]
  )),
  Layout(title_text="Basic Sankey Diagram", font_size=10)
)

```

### More complex Sankey diagram with colored links

```julia
using PlotlyJS, JSON, HTTP

response=HTTP.get("https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json")
data=JSON.parse(String(response.body))

# override gray link colors with "source" colors
opacity=0.4
# change "magenta" to its "rgba" value to add opacity
data["data"][1]["node"]["color"] = [
    color == "magenta" ? "rgba(255,0,255, 0.8)" : color
    for color in data["data"][1]["node"]["color"]
]

plot(sankey(
    valueformat = ".0f",
    valuesuffix = "TWh",
    # Define nodes
    node = attr(
      pad = 15,
      thickness = 15,
      line = attr(color = "black", width = 0.5),
      label =  data["data"][1]["node"]["label"],
      color =  data["data"][1]["node"]["color"]
    ),
    # Add links
    link = attr(
      source =  data["data"][1]["link"]["source"],
      target =  data["data"][1]["link"]["target"],
      value =  data["data"][1]["link"]["value"],
      label =  data["data"][1]["link"]["label"],
      color =  data["data"][1]["link"]["color"]
)))
```

### Style Sankey Diagram

This example also uses [hovermode](https://plotly.com/julia/reference/layout/#layout-hovermode) to enable multiple tooltips.

```julia
using PlotlyJS, JSON, HTTP


response=HTTP.get("https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json")
data=JSON.parse(String(response.body))

plot(
    sankey(
        valueformat = ".0f",
        valuesuffix = "TWh",
        node = attr(
            pad = 15,
            thickness = 15,
            line = attr(color = "black", width = 0.5),
            label =  data["data"][1]["node"]["label"],
            color =  data["data"][1]["node"]["color"]
        ),
        link = attr(
            source =  data["data"][1]["link"]["source"],
            target =  data["data"][1]["link"]["target"],
            value =  data["data"][1]["link"]["value"],
            label =  data["data"][1]["link"]["label"]
        )
    ),
    Layout(
        hovermode = "x",
        title="Energy forecast for 2050<br>Source: Department of Energy & Climate Change, Tom Counsell via <a href='https://bost.ocks.org/mike/sankey/'>Mike Bostock</a>",
        font=attr(size = 10, color = "white"),
        plot_bgcolor="black",
        paper_bgcolor="black"
    )
)

```

### Hovertemplate and customdata of Sankey diagrams

Links and nodes have their own hovertemplate, in which link- or node-specific attributes can be displayed. To add more data to links and nodes, it is possible to use the `customdata` attribute of `link` and `nodes`, as in the following example. For more information about hovertemplate and customdata, please see the [tutorial on hover text].

```julia
using PlotlyJS

plot(sankey(
    node = attr(
      pad = 15,
      thickness = 20,
      line = attr(color = "black", width = 0.5),
      label = ["A1", "A2", "B1", "B2", "C1", "C2"],
      customdata = ["Long name A1", "Long name A2", "Long name B1", "Long name B2",
                    "Long name C1", "Long name C2"],
      hovertemplate="Node %{customdata} has total value %{value}<extra></extra>",
      color = "blue"
    ),
    link = attr(
      source = [0, 1, 0, 2, 3, 3], # indices correspond to labels, eg A1, A2, A2, B1, ...
      target = [2, 3, 3, 4, 4, 5],
      value = [8, 4, 2, 8, 4, 2],
      customdata = ["q","r","s","t","u","v"],
      hovertemplate=string("Link from node %{source.customdata}<br />",
        "to node%{target.customdata}<br />has value %{value}",
        "<br />and data %{customdata}<extra></extra>"),
  )), Layout(title_text="Basic Sankey Diagram", font_size=10))
```

### Define Node Position

The following example sets [node.x](https://plotly.com/julia/reference/sankey/#sankey-node-x) and `node.y` to place nodes in the specified locations, except in the `snap arrangement` (default behaviour when `node.x` and `node.y` are not defined) to avoid overlapping of the nodes, therefore, an automatic snapping of elements will be set to define the padding between nodes via [nodepad](https://plotly.com/julia/reference/sankey/#sankey-node-pad). The other possible arrangements are:<font color='blue'> 1)</font> perpendicular <font color='blue'>2)</font> freeform <font color='blue'>3)</font> fixed

```julia
using PlotlyJS

plot(sankey(
    arrangement = "snap",
    node = attr(
        label= ["A", "B", "C", "D", "E", "F"],
        x= [0.2, 0.1, 0.5, 0.7, 0.3, 0.5],
        y= [0.7, 0.5, 0.2, 0.4, 0.2, 0.3],
        pad=10,  # 10 Pixels
    ),
    link = attr(
        source= [0, 0, 1, 2, 5, 4, 3, 5],
        target= [5, 3, 4, 3, 0, 2, 2, 3],
        value= [1, 2, 1, 1, 1, 1, 1, 2]
    )
))

```

### Reference

See [https://plotly.com/julia/reference/sankey](https://plotly.com/julia/reference/sankey/) for more information and options!
