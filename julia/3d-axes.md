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
    description: How to format axes of 3d plots in Julia with Plotly.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Axes
    order: 1
    page_type: example_index
    permalink: julia/3d-axes/
    thumbnail: thumbnail/3d-axes.png
---

### Range of axes

3D figures have an attribute in `layout` called `scene`, which contains
attributes such as `xaxis`, `yaxis` and `zaxis` parameters, in order to
set the range, title, ticks, color etc. of the axes.

For creating 3D charts, see [this page](https://plotly.com/julia/3d-charts/).

```julia
    using PlotlyJS

    N = 70
    layout = Layout(
        scene=attr(
            xaxis=attr(
                nticks=4,
                range=[-100,100]
            ),
            yaxis=attr(
                nticks=4,
                range=[-50,100]
            ),
            zaxis=attr(
                nticks=4,
                range=[-100,100]
            ),
        ),
        width=700,
        margin=attr(
            r=20,
            l=10,
            b=10,
            t=10
        ),
    )

    plot(mesh3d(
            x=(70 .* randn(N)),
            y=(55 .* randn(N)),
            z=(40 .* randn(N)),
            color="rgba(244,22,100,0.6)"
        ),
        layout,
    )
```

### Fixed Ratio Axes

```julia
using PlotlyJS

N = 50

fig = make_subplots(rows=2, cols=2,
                    specs=fill(Spec(kind="scene"), 2, 2),
                    print_grid=false)
for i in [1,2]
    for j in [1,2]
        append_trace!(
            mesh3d(
                x=(60 .* randn(N)),
                y=(25 .* randn(N)),
                z=(40 .* randn(N)),
                opacity=0.5,
              ),
            row=i, col=j)
    end
end

relayout!(
    fig,
    width=700, margin=dict(r=10, l=10, b=10, t=10),
    # fix the ratio in the top left subplot to be a cube
    scene_aspectmode="cube",
    # manually force the z-axis to appear twice as big as the other two
    scene2_aspectmode="manual",
    scene2_aspectratio=dict(x=1, y=1, z=2),
    # draw axes in proportion to the proportion of their ranges
    scene3_aspectmode="data"
    # automatically produce something that is well proportioned using "data" as the default
    scene4_aspectmode="auto"
)

fig
```

```julia
using PlotlyJS

N = 50

fig = make_subplots(
    rows=2,
    cols=2,
    specs=fill(Spec(kind="scene"), 2,2),
)

for i in [1,2]
    for j in [1,2]
        add_trace!(p,
            mesh3d(
                x=(60 .* randn(N)),
                y=(25 .* randn(N)),
                z=(40 .* randn(N)),
                opacity=0.5,
            ),
            row=i, col=j
        )

    end
end

fig
```

### Set Axes Title

```julia
using PlotlyJS
# Define random surface
N = 50
trace1 = mesh3d(x=(60 .* randn(N)),
                   y=(25 .* randn(N)),
                   z=(40 .* randn(N)),
                   opacity=0.5,
                   color="yellow"
                  )
trace2 = mesh3d(x=(70 .* randn(N)),
                   y=(55 .* randn(N)),
                   z=(30 .* randn(N)),
                   opacity=0.5,
                   color="pink"
                  )

layout = Layout(scene = attr(
                    xaxis_title="X AXIS TITLE",
                    yaxis_title="Y AXIS TITLE",
                    zaxis_title="Z AXIS TITLE"),
                    width=700,
                    margin=attr(r=20, b=10, l=10, t=10))

plot([trace1, trace2], layout)
```

### Ticks Formatting

```julia
using PlotlyJS
# Define random surface
N = 50
trace = mesh3d(x=(60 .* randn(N)),
                   y=(25 .* randn(N)),
                   z=(40 .* randn(N)),
                   opacity=0.5,
                   color="rgba(100,22,200,0.5)"
                  )

# Different types of customized ticks
layout = Layout(scene = attr(
                    xaxis = attr(
                        ticktext= ["TICKS","MESH","PLOTLY","JULIA"],
                        tickvals= [0,50,75,-50]),
                    yaxis = attr(
                        nticks=5, tickfont=attr(
                            color="green",
                            size=12,
                            family="Old Standard TT, serif",),
                        ticksuffix="#"),
                    zaxis = attr(
                        nticks=4, ticks="outside",
                        tick0=0, tickwidth=4),),
                    width=700,
                    margin=attr(r=10, l=10, b=10, t=10)
                  )

plot(trace, layout)
```

### Background and Grid Color

```julia
using PlotlyJS

N = 50
trace = mesh3d(x=(30 .* randn(N)),
                   y=(25 .* randn(N)),
                   z=(30 .* randn(N)),
                   opacity=0.5)


# xaxis.backgroundcolor is used to set background color
layout = Layout(scene = attr(
                    xaxis = attr(
                         backgroundcolor="rgb(200, 200, 230)",
                         gridcolor="white",
                         showbackground=true,
                         zerolinecolor="white",),
                    yaxis = attr(
                        backgroundcolor="rgb(230, 200,230)",
                        gridcolor="white",
                        showbackground=true,
                        zerolinecolor="white"),
                    zaxis = attr(
                        backgroundcolor="rgb(230, 230,200)",
                        gridcolor="white",
                        showbackground=true,
                        zerolinecolor="white",),),
                    width=700,
                    margin=attr(
                    r=10, l=10,
                    b=10, t=10)
                  )
plot(trace, layout)
```

### Disabling tooltip spikes

By default, guidelines originating from the tooltip point are drawn. It is possible to disable this behaviour with the `showspikes` parameter. In this example we only keep the `z` spikes (projection of the tooltip on the `x-y` plane). Hover on the data to show this behaviour.

```julia
using PlotlyJS

N = 50
trace = mesh3d(x=(30 .* randn(N)),
                   y=(25 .* randn(N)),
                   z=(30 .* randn(N)),
                   opacity=0.5)
layout = Layout(scene=attr(xaxis_showspikes=false,
                             yaxis_showspikes=false))

plot(trace, layout)
```
