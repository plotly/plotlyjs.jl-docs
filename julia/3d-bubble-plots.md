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
    description:
      How to make 3D Bubble Charts in Julia with Plotly. Three examples
      of 3D Bubble Charts.
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Bubble Charts
    order: 6
    page_type: example_index
    permalink: julia/3d-bubble-charts/
    thumbnail: thumbnail/3dbubble.jpg
---

### 3d Bubble chart with Plotly Express

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
trace = scatter3d(
    df,
    x=:year,
    y=:continent,
    z=:pop,
    mode="markers",
    marker=attr(
        size=:gdpPercap,
        color=:lifeExp,
        sizeref=maximum(df.gdpPercap) / 60^2,
        sizemode="area"
    )
)

layout = Layout(scene_zaxis_type="log")
plot(trace, layout)
```

#### Simple Bubble Chart

```julia
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv").body
) |> DataFrame

start = 750
stop = 1500

trace = scatter3d(
    x=df[!, "year"][start:stop],
    y=df[!, "continent"][start:stop],
    z=df[!, "pop"][start:stop],
    text=df[!, "country"][start:stop],
    mode="markers",
    marker=attr(
        sizemode="diameter",
        sizeref=750,
        size=df[!, "gdpPercap"][start:stop],
        color=df[!, "lifeExp"][start:stop],
        colorscale="Viridis",
        colorbar_title="Life<br>Expectancy",
        line_color="rgb(140,140,170)"
    )
)

layout = Layout(height=800, width=800, title="Examining Population and Life Expectancy Over Time")

plot(trace, layout)
```

#### Bubble Chart Sized by a Variable

Plot planets' distance from sun, density, and gravity with bubble size based on planet size

```julia
using PlotlyJS

planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]
planet_colors = ["rgb(135, 135, 125)", "rgb(210, 50, 0)", "rgb(50, 90, 255)",
                 "rgb(178, 0, 0)", "rgb(235, 235, 210)", "rgb(235, 205, 130)",
                 "rgb(55, 255, 217)", "rgb(38, 0, 171)", "rgb(255, 255, 255)"]
distance_from_sun = [57.9, 108.2, 149.6, 227.9, 778.6, 1433.5, 2872.5, 4495.1, 5906.4]
density = [5427, 5243, 5514, 3933, 1326, 687, 1271, 1638, 2095]
gravity = [3.7, 8.9, 9.8, 3.7, 23.1, 9.0, 8.7, 11.0, 0.7]
planet_diameter = [4879, 12104, 12756, 6792, 142984, 120536, 51118, 49528, 2370]

# Create trace, sizing bubbles by planet diameter
trace = scatter3d(
    x = distance_from_sun,
    y = density,
    z = gravity,
    text = planets,
    mode = "markers",
    marker = attr(
        sizemode = "diameter",
        sizeref = 750, # info on sizeref: https://plotly.com/julia/reference/scatter/#scatter-marker-sizeref
        size = planet_diameter,
        color = planet_colors,
        )
)

layout = Layout(
    width=800,
    height=800,
    title = "Planets!",
    scene = attr(
        xaxis=attr(
            title="Distance from Sun",
            titlefont_color="white"
        ),
        yaxis=attr(
            title="Density",
            titlefont_color="white"
        ),
        zaxis=attr(
            title="Gravity",
            titlefont_color="white"
        ),
        bgcolor = "rgb(20, 24, 54)"
    )
)

plot(trace, layout)
```

#### Edit the Colorbar

Plot planets' distance from sun, density, and gravity with bubble size based on planet size

```julia
using PlotlyJS

planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]
temperatures = [167, 464, 15, -20, -65, -110, -140, -195, -200, -225]
distance_from_sun = [57.9, 108.2, 149.6, 227.9, 778.6, 1433.5, 2872.5, 4495.1, 5906.4]
density = [5427, 5243, 5514, 3933, 1326, 687, 1271, 1638, 2095]
gravity = [3.7, 8.9, 9.8, 3.7, 23.1, 9.0, 8.7, 11.0, 0.7]
planet_diameter = [4879, 12104, 12756, 6792, 142984, 120536, 51118, 49528, 2370]

# Create trace, sizing bubbles by planet diameter
trace = scatter3d(
    x = distance_from_sun,
    y = density,
    z = gravity,
    text = planets,
    mode = "markers",
    marker = attr(
        sizemode = "diameter",
        sizeref = 750, # info on sizeref: https://plotly.com/julia/reference/scatter/#scatter-marker-sizeref
        size = planet_diameter,
        color = temperatures,
        colorbar_title = "Mean<br>Temperature",
        colorscale=[[0, "rgb(5, 10, 172)"], [.3, "rgb(255, 255, 255)"], [1, "rgb(178, 10, 28)"]]
    )
)

layout = Layout(
    width=800,
    height=800,
    title = "Planets!",
    scene = attr(
        xaxis=attr(
            title="Distance from Sun",
            titlefont_color="white"
        ),
        yaxis=attr(
            title="Density",
            titlefont_color="white"
        ),
        zaxis=attr(
            title="Gravity",
            titlefont_color="white"
        ),
        bgcolor = "rgb(20, 24, 54)"
    )
)

plot(trace, layout)
```

#### Reference

See https://plotly.com/julia/reference/scatter3d/ and https://plotly.com/julia/reference/scatter/#scatter-marker-sizeref <br>for more information and chart attribute options!
