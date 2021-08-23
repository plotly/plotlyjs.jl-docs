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
    display_name: Python 3
    language: python
    name: python3
  language_info:
    codemirror_mode:
      name: ipython
      version: 3
    file_extension: .py
    mimetype: text/x-python
    name: python
    nbconvert_exporter: python
    pygments_lexer: ipython3
    version: 3.7.6
  plotly:
    description:
      How to make Network Graphs in Python with Plotly. One examples of
      a network graph with NetworkX
    display_as: scientific
    language: python
    layout: base
    name: Network Graphs
    order: 12
    page_type: u-guide
    permalink: python/network-graphs/
    redirect_from:
      - ipython-notebooks/networks/
      - ipython-notebooks/network-graphs/
    thumbnail: thumbnail/net.jpg
---

In this example we show how to visualize a network graph created using `networkx`.

Install the Python library `networkx` with `pip install networkx`.

### Create random graph

```julia
using LightGraphs

G = euclidean_graph(200, 2, cutoff=0.125)[1]
```

#### Create Edges

Add edges as disconnected lines in a single trace and nodes as a scatter trace

```julia
using PlotlyJS, LightGraphs

edge_x = []
edge_y = []

# Generate a random layout
G =  LightGraphs.euclidean_graph(200, 2, cutoff=0.125)[1]
# Position nodes
pos_x, pos_y = spring_layout(G)
# Create plot points
for edge in edges(G)
  append!(edge_x, pos_x[src(edge)])
  append!(edge_x, pos_x[dst(edge)])
  append!(edge_y, pos_y[src(edge)])
  append!(edge_y, pos_y[dst(edge)])

end

#  Color node points by the number of connections.
color_map = [
  size(neighbors(G, node))[1]
  for node in 1:200
]

# Create edges
edges_trace = scatter(
  mode="lines",
  x=edge_x,
  y=edge_y,
  line=attr(
    width=0.5,
    color="#888"
  ),
)

# Create nodes
nodes_trace = scatter(
  x=pos_x,
  y=pos_y,
  mode="markers",
  text = [string("# of connections: ", connection) for connection in color_map],
  marker=attr(
    showscale=true,
    colorscale=colors.imola,
    color=color_map,
    size=10,
    colorbar=attr(
      thickness=15,
      title="Node Connections",
      xanchor="left",
      titleside="right"
    )
  )
)

# Create Plot
plot([edges_trace, nodes_trace],
  Layout(
    hovermode="closest",
    title="Network Graph made with Julia",
    titlefont_size=16,
    showlegend=false,
    showarrow=false,
    xaxis=attr(showgrid=false, zeroline=false, showticklabels=false),
    yaxis=attr(showgrid=false, zeroline=false, showticklabels=false)
  )
)


```

#### Reference

See https://plotly.com/julia/reference/scatter/ for more information and chart attribute options!
