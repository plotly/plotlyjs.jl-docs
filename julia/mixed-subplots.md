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
    description: How to make mixed subplots in Julia with Plotly.
    display_as: multiple_axes
    language: julia
    layout: base
    name: Mixed Subplots
    order: 1
    page_type: example_index
    permalink: julia/mixed-subplots/
    thumbnail: thumbnail/mixed_subplot.JPG
---

#### Mixed Subplots

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get( "https://raw.githubusercontent.com/plotly/datasets/master/volcano_db.csv").body
) |> DataFrame


# frequency of Country
freq = combine(groupby(df, :Country), nrow)

# read in 3d volcano surface data
df_v = CSV.File(
    HTTP.get( "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv").body
) |> DataFrame

# Initialize figure with subplots
fig = make_subplots(
    rows=2, cols=2,
    column_widths=[0.6, 0.4],
    row_heights=[0.4, 0.6],
    specs=[
        Spec(kind="geo", rowspan=2) Spec(kind="xy")
        missing Spec(kind= "scene")
    ]
)


# TODO: Plot not staying in it's sub plot spot
# Add scattergeo globe map of volcano locations
add_trace!(
    fig,
    scattergeo(
        lat=df[!, "Latitude"],
        lon=df[!, "Longitude"],
        mode="markers",
        hoverinfo="text",
        showlegend=false,
        marker=attr(color="crimson", size=4, opacity=0.8),
        projection_type="orthographic",
        landcolor="white",
        oceancolor="MidnightBlue",
        showocean=true,
        lakecolor="LightBlue"
    ),
    row=1, col=1
)

# Add locations bar chart
add_trace!(
    fig,
    bar(x=freq[!,"Country"][1:11],y=freq[!, "nrow"][1:11], marker_color="crimson", showlegend=false),
    row=1, col=2
)

# Add 3d surface of volcano
add_trace!(
    fig,
    surface(z=Matrix{Int64}(df_v), showscale=false),
    row=2, col=2
)

# Set theme, margin, and annotation in layout
relayout!(
    fig,
    geo=attr(projection_type="orthographic",
    landcolor="white",
    oceancolor="MidnightBlue",
    showocean=true,
    lakecolor="LightBlue"),
    xaxis2_tickangle=45,
    template=templates.plotly_dark,
    margin=attr(r=10, t=25, b=40, l=60),
    annotations=[
        attr(
            text="Source: NOAA",
            showarrow=false,
            xref="paper",
            yref="paper",
            x=0,
            y=0)
    ]
)

fig
```

#### Reference

See https://plotly.com/julia/reference/ for more information and chart attribute options!
