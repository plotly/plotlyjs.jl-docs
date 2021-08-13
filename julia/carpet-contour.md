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
    description: How to make carpet contour plots in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Carpet Contour Plot
    order: 14
    page_type: u-guide
    permalink: julia/carpet-contour/
    thumbnail: thumbnail/contourcarpet.jpg
---

### Basic Carpet Plot

Set the `x` and `y` coordinates, using `x` and `y` attributes. If `x` coordinate values are omitted a cheater plot will be created. To save parameter values use `a` and `b` attributes. To make changes to the axes, use `aaxis` or `baxis` attributes. For a more detailed list of axes attributes refer to [julia reference](https://plotly.com/julia/reference/carpet/#carpet-aaxis).

```julia
using PLotlyJS

plot(carpet(
    a=[0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3],
    b=[4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6],
    x=[2, 3, 4, 5, 2.2, 3.1, 4.1, 5.1, 1.5, 2.5, 3.5, 4.5],
    y=[1, 1.4, 1.6, 1.75, 2, 2.5, 2.7, 2.75, 3, 3.5, 3.7, 3.75],
    aaxis=attr(
        tickprefix="a=",
        smoothing=0,
        minorgridcount=9,
        type="linear"
    ),
    baxis=attr(
        tickprefix="b=",
        smoothing=0,
        minorgridcount=9,
        type="linear"
    )
))

```

// TODO: Can"t use `end` as argument?

### Add Contours

```julia
using PlotlyJS


trace1=contourcarpet(
    a=[0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3],
    b=[4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6],
    z=[1, 1.96, 2.56, 3.0625, 4, 5.0625, 1, 7.5625, 9, 12.25, 15.21, 14.0625],
    autocontour=false,
    contours=attr(
        start=1,
        size=1
    ),
    contours_end=14,
    line=attr(
        width=2,
        smoothing=0
    ),
    colorbar=attr(
       len=0.4,
        y=0.25
    )
)

trace2=carpet(
    a=[0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3],
    b=[4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6],
    x=[2, 3, 4, 5, 2.2, 3.1, 4.1, 5.1, 1.5, 2.5, 3.5, 4.5],
    y=[1, 1.4, 1.6, 1.75, 2, 2.5, 2.7, 2.75, 3, 3.5, 3.7, 3.75],
    aaxis=attr(
        tickprefix="a=",
        smoothing=0,
        minorgridcount=9,
        type="linear"
    ),
    baxis=attr(
        tickprefix="b=",
        smoothing=0,
        minorgridcount=9,
        type="linear"
    )
)


plot([trace1, trace2])
```

### Add Multiple Traces

```julia
using PlotlyJS, HTTP, JSON

response=HTTP.get("https://raw.githubusercontent.com/bcdunbar/datasets/master/airfoil_data.json")
data=JSON.parse(String(response.body))

trace1=carpet(
    a=data[1]["a"],
    b=data[1]["b"],
    x=data[1]["x"],
    y=data[1]["y"],
    baxis=attr(
      startline=false,
      endline=false,
      showticklabels="none",
      smoothing=0,
      showgrid=false
    ),
    aaxis=attr(
      startlinewidth=2,
      startline=true,
      showticklabels="none",
      endline=true,
      showgrid=false,
      endlinewidth=2,
      smoothing=0
    )
)

trace2=contourcarpet(
    z=data[2]["z"],
    autocolorscale=false,
    zmax=1,
    name="Pressure",
    colorscale="Viridis",
    zmin=-8,
    colorbar=attr(
      y=0,
      yanchor="bottom",
      titleside="right",
      len=0.75,
      title="Pressure coefficient, c<sub>p</sub>"
    ),
    contours=attr(
      start=-1,
      size=0.025,
      showlines=false
    ),
    contours_end=1.000,
    line=attr(
      smoothing=0
    ),
    autocontour=false,
    zauto=false
)

trace3=contourcarpet(
    z=data[3]["z"],
    opacity=0.300,
    showlegend=true,
    name="Streamlines",
    autocontour=true,
    ncontours=50,
    contours=attr(
      coloring="none"
    ),
    line=attr(
      color="white",
      width=1
    )
)

trace4=contourcarpet(
    z=data[4]["z"],
    showlegend=true,
    name="Pressure<br>contours",
    autocontour=false,
    line=attr(
        color="rgba(0, 0, 0, 0.5)",
        smoothing=1
    ),
    contours=attr(
        size=0.250,
        start=-4,
        coloring="none",
        showlines=true
    ),
    contours_end=1.000,
)

trace5=scatter(
    x=data[5]["x"],
    y=data[5]["y"],
    legendgroup="g1",
    name="Surface<br>pressure",
    mode="lines",
    hoverinfo="skip",
    line=attr(
      color="rgba(255, 0, 0, 0.5)",
      width=1,
      shape="spline",
      smoothing=1
    ),
    fill="toself",
    fillcolor="rgba(255, 0, 0, 0.2)"
)

trace6=scatter(
    x=data[6]["x"],
    y=data[6]["y"],
    showlegend=false,
    legendgroup="g1",
    mode="lines",
    hoverinfo="skip",
    line=attr(
      color="rgba(255, 0, 0, 0.3)",
      width=1
    )
)

trace7=scatter(
    x=data[7]["x"],
    y=data[7]["y"],
    showlegend=false,
    legendgroup="g1",
    name="cp",
    text=data[7]["text"],
    hoverinfo="text",
    mode="lines",
    line=attr(
      color="rgba(255, 0, 0, 0.2)",
      width=0
    )
)

layout=Layout(
    yaxis=attr(
      zeroline=false,
      range=[-1.800,1.800],
      showgrid=false
    ),
    dragmode="pan",
    height=700,
    xaxis=attr(
      zeroline=false,
      scaleratio=1,
      scaleanchor="y",
      range=[-3.800,3.800],
      showgrid=false
    ),
    title="Flow over a Karman-Trefftz airfoil",
    hovermode="closest",
    margin=attr(
      r=60,
      b=40,
      l=40,
      t=80
    ),
    width=900
)

plot([trace1, trace2, trace3, trace4, trace5, trace6, trace7], layout)
```

### Reference

See https://plotly.com/julia/reference/contourcarpet/ for more information and chart attribute options!
