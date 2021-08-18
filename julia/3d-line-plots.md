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
    description: How to make 3D Line Plots
    display_as: 3d_charts
    language: julia
    layout: base
    name: 3D Line Plots
    order: 7
    page_type: example_index
    permalink: julia/3d-line-plots/
    thumbnail: thumbnail/3d-line.jpg
---


### 3D Line plots

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_brazil = df[df.country .== "Brazil", :]

plot(df_brazil, x=:gdpPercap, y=:pop, z=:year, type="scatter3d", mode="lines")
```

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df_europe = df[df.continent .== "Europe", :]

plot(df_europe, x=:gdpPercap, y=:pop, z=:year, type="scatter3d", mode="lines", color=:country)
```

#### 3D Line Plot of Brownian Motion

Here we represent a trajectory in 3D.

```julia
using PlotlyJS, Distributions, Dates

function brownian_motion(T=1, N=100; sigma=0.01, S0=20, mu=0.1)
    dt = float(T)/(N-1)
    t = 0:dt:T
    W = randn(N)
    W = cumsum(W) .* sqrt(dt) # standard brownian motion
    X = @. (mu-0.5*sigma^2) * t + sigma * W
    S0.*exp.(X) # geometric brownian motion
end

dates = Date(2012,1,1):Day(1):Date(2013,2,22)

T = Dates.value((extrema(dates)[2]-extrema(dates)[1])) / 365
N = size(dates)[1]
start_price = 100
y = brownian_motion(T, N, sigma=0.1, S0=start_price)
z = brownian_motion(T, N, sigma=0.1, S0=start_price)

layout = Layout(
    width=800,
    height=700,
    autosize=false,
    scene=attr(
        camera=attr(
            up=attr(x=0, y=0, z=1),
            eye=attr(x=0, y=1.0707, z=1)
        ),
        aspectratio=attr(x=1, y=1, z=0.7),
        aspectmode="manual",
    )
)
plot(scatter(
    x=dates,
    y=y,
    z=z,
    marker=attr(size=4, color=z, colorscale="Viridis"),
    line=attr(color="darkblue", width=2),
    type="scatter3d",
    mode="lines+markers"
), layout)
```

#### Reference

See https://plotly.com/julia/reference/scatter3d/#scatter3d-marker-line for more information and chart attribute options!
