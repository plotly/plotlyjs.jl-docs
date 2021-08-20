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
    description: How to style markers in Julia with Plotly.
    display_as: file_settings
    language: julia
    layout: base
    name: Styling Markers
    order: 20
    permalink: julia/marker-style/
    thumbnail: thumbnail/marker-style.gif
---

### Add Marker Border

In order to make markers look more distinct, you can add a border to the markers. This can be achieved by adding the line property to the marker object.

Here is an example of adding a marker border to a faceted scatter plot created using Plotly Express.

```python
import plotly.express as px

df = px.data.iris()
fig = px.scatter(df, x="sepal_width", y="sepal_length", color="species")

fig.update_traces(marker=dict(size=12,
                              line=dict(width=2,
                                        color='DarkSlateGrey')),
                  selector=dict(mode='markers'))
fig.show()
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
plot(
    kind="scatter",
    mode="markers",
    df,
    x=:sepal_width,
    y=:sepal_length,
    group=:species,
    marker=attr(
        size=12,
        line=attr(width=2, color="DarkSlateGrey"),
        selector_mode="markers"
    )
)

```

Here is an example that creates an empty graph object figure, and then adds two scatter traces with a marker border.

```julia
using PlotlyJS, Distributions
# Generate example data

x = rand(Uniform(3,6), 500)
y = rand(Uniform(3,6), 500)

# Build figure
fig = plot()

# Add scatter trace with medium sized markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=x,
        y=y,
        marker=attr(
            color="LightSkyBlue",
            size=20,
            line=attr(
                color="MediumPurple",
                width=2
            )
        ),
        showlegend=false
    )
)

# Add trace with large marker
add_trace!(fig,
    scatter(
        mode="markers",
        x=[2],
        y=[4.5],
        marker=attr(
            color="LightSkyBlue",
            size=120,
            line=attr(
                color="MediumPurple",
                width=12
            )
        ),
        showlegend=false
    )
)
fig

```

Fully opaque, the default setting, is useful for non-overlapping markers. When many points overlap it can be hard to observe density.

### Opacity

Setting opacity outside the marker will set the opacity of the trace. Thus, it will allow greater visibility of additional traces but like fully opaque it is hard to distinguish density.

```julia
using PlotlyJS, Distributions

# Generate example data
x = rand(Uniform(3, 6), 500)
y = rand(Uniform(3, 4.5), 500)
x2 = rand(Uniform(3, 6), 500)
y2 = rand(Uniform(4.5, 6), 500)

# Build figure
fig = plot()

# Add first scatter trace with medium sized markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=x,
        y=y,
        opacity=0.5,
        marker=attr(
            color="LightSkyBlue",
            size=20,
            line=attr(
                color="MediumPurple",
                width=2
            )
        ),
        name="Opacity 0.5"
    )
)

# Add second scatter trace with medium sized markers
# and opacity 1.0
add_trace!(fig,
    scatter(
        mode="markers",
        x=x2,
        y=y2,
        marker=attr(
            color="LightSkyBlue",
            size=20,
            line=attr(
                color="MediumPurple",
                width=2
            )
        ),
        name="Opacity 1.0"
    )
)

# Add trace with large markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=[2, 2],
        y=[4.25, 4.75],
        opacity=0.5,
        marker=attr(
            color="LightSkyBlue",
            size=80,
            line=attr(
                color="MediumPurple",
                width=8
            )
        ),
        showlegend=false
    )
)

fig

```

### Marker Opacity

To maximise visibility of density, it is recommended to set the opacity inside the marker `marker:{opacity:0.5}`. If multiple traces exist with high density, consider using marker opacity in conjunction with trace opacity.

```julia
using PlotlyJS, Distributions

# Generate example data
x = rand(Uniform(3, 6),500)
y = rand(Uniform(3, 6),500)

# Build figure
fig = plot()

# Add scatter trace with medium sized markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=x,
        y=y,
        marker=attr(
            color="LightSkyBlue",
            size=20,
            opacity=0.5,
            line=attr(
                color="MediumPurple",
                width=2
            )
        ),
        showlegend=false
    )
)


# Add trace with large markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=[2, 2],
        y=[4.25, 4.75],
        marker=attr(
            color="LightSkyBlue",
            size=80,
            opacity=0.5,
            line=attr(
                color="MediumPurple",
                width=8
            )
        ),
        showlegend=false
    )
)

fig

```

### Color Opacity

To maximise visibility of each point, set the color as an `rgba` string that includes an alpha value of 0.5.

This example sets the marker color to `'rgba(135, 206, 250, 0.5)'`. The rgb values of 135, 206, and 250 are from the definition of the `LightSkyBlue` named CSS color that is is used in the previous examples (See https://www.color-hex.com/color/87cefa). The marker line will remain opaque.

```julia
using PlotlyJS, Distributions
# Generate example data
x = rand(Uniform(3, 6),500)
y = rand(Uniform(3, 6),500)


# Build figure
fig = plot()
# Add scatter trace with medium sized markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=x,
        y=y,
        marker=attr(
            color="rgba(135, 206, 250, 0.5)",
            size=20,
            line=attr(
                color="MediumPurple",
                width=2
            )
        ),
        showlegend=false
    )
)


# Add trace with large markers
add_trace!(fig,
    scatter(
        mode="markers",
        x=[2, 2],
        y=[4.25, 4.75],
        marker=attr(
            color="rgba(135, 206, 250, 0.5)",
            size=80,
            line=attr(
                color="MediumPurple",
                width=8
            )
        ),
        showlegend=false
    )
)

fig

```

<!-- TODO: SymbolValidator doesn't exist. would need to hard code everything -->
<!--
### Custom Marker Symbols

The `marker_symbol` attribute allows you to choose from a wide array of symbols to represent markers in your figures.

The basic symbols are: `circle`, `square`, `diamond`, `cross`, `x`, `triangle`, `pentagon`, `hexagram`, `star`, `diamond`, `hourglass`, `bowtie`, `asterisk`, `hash`, `y`, and `line`.

Each basic symbol is also represented by a number. Adding 100 to that number is equivalent to appending the suffix "-open" to a symbol name. Adding 200 is equivalent to appending "-dot" to a symbol name. Adding 300 is equivalent to appending "-open-dot" or "dot-open" to a symbol name.

In the following figure, hover over a symbol to see its name or number. Set the `marker_symbol` attribute equal to that name or number to change the marker symbol in your figure.

```julia
import plotly.graph_objects as go
from plotly.validators.scatter.marker import SymbolValidator

raw_symbols = SymbolValidator().values
namestems = []
namevariants = []
symbols = []
for i in range(0,len(raw_symbols),3):
    name = raw_symbols[i+2]
    symbols.append(raw_symbols[i])
    namestems.append(name.replace("-open", "").replace("-dot", ""))
    namevariants.append(name[len(namestems[-1]):])

fig = go.Figure(go.Scatter(mode="markers", x=namevariants, y=namestems, marker_symbol=symbols,
                           marker_line_color="midnightblue", marker_color="lightskyblue",
                           marker_line_width=2, marker_size=15,
                           hovertemplate="name: %{y}%{x}<br>number: %{marker.symbol}<extra></extra>"))
fig.update_layout(title="Mouse over symbols for name & number!",
                  xaxis_range=[-1,4], yaxis_range=[len(set(namestems)),-1],
                  margin=dict(b=0,r=0), xaxis_side="top", height=1400, width=400)
fig.show()
``` -->

### Reference

See https://plotly.com/python/reference/ for more information and chart attribute options!
