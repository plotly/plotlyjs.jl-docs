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
    description: How to make scatter plots in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Scatter Plots
    order: 1
    page_type: example_index
    permalink: julia/line-and-scatter/
    redirect_from: julia/line-and-scatter-plots-tutorial/
    thumbnail: thumbnail/line-and-scatter.jpg
---

## Scatter Trace Type

The scatter trace type can be used to represent scatter charts (one point or marker per observation), line charts (a line drawn between each point), or bubble charts (points with size proportional to a dimension of the observation).

To draw a scatter chart, use the `scatter` trace type and set the `mode` parameter to `markers`.

```julia
using PlotlyJS
# x and y given as arrays
plot(scatter(x=1:10, y=rand(10), mode="markers"))
```

```julia
# x and y given as DataFrame columns
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")
plot(scatter(df, x=:sepal_width, y=:sepal_length, mode="markers"))
```

#### Set size and color with column names

Note that you can set `marker_size` via column name and generate multiple traces using `group`.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")
plot(
    df, x=:sepal_width, y=:sepal_length, color=:species,
    marker=attr(size=:petal_length, sizeref=maximum(df.petal_length) / (20^2), sizemode="area"),
    mode="markers"
)
```

## Line plots

By setting `mode` to `lines`, you can draw a line chart.

```julia
using PlotlyJS
t = 0:0.01:2π
plot(
    scatter(x=t, y=cos.(t), mode="lines"),
    Layout(yaxis_title="cos(t)", xaxis_title="t")
)
```

You can also plot functions directly:

```julia
using PlotlyJS
plot(cos, 0, 2π, mode="lines", Layout(title="cos(t)"))
```

As well as DataFrames:

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df_ocean = df[df.continent .== "Oceania", :]
plot(
    df_ocean, x=:year, y=:lifeExp, color=:country, mode="lines"
)
```

#### Line and Scatter Plots

Use `mode` argument to choose between markers, lines, or a combination of both.

```julia
using PlotlyJS, Random

Random.seed!(42)

N = 100
random_x = range(0, stop=1, length=N)
random_y0 = randn(N) .+ 5
random_y1 = randn(N)
random_y2 = randn(N) .- 5

plot([
    scatter(x=random_x, y=random_y0, mode="markers", name="markers"),
    scatter(x=random_x, y=random_y1, mode="lines", name="lines"),
    scatter(x=random_x, y=random_y2, mode="markers+lines", name="markers+lines")
])
```

#### Bubble Scatter Plots

In [bubble charts](https://en.wikipedia.org/wiki/Bubble_chart), a third dimension of the data is shown through the size of markers. For more examples, see the [bubble chart docs](https://plotly.com/julia/bubble-charts/)

```julia
using PlotlyJS

plot(scatter(
    x=1:4, y=10:13, mode="markers", marker=attr(size=40:20:100, color=0:3)
))
```

#### Style Scatter Plots

There are many properties of the scatter trace type that control differetn aspects of the appearance of the trace. Here are a few examples

```julia
using PlotlyJS

p = plot(
    [sin, cos], 0, 10, mode="markers", marker=attr(size=10, line_width=2),
    Layout(title="Styled Scatter", yaxis_zeroline=false, xaxis_zeroline=false)
)
restyle!(p, 1, marker_color="rgba(152, 0, 0, 0.8)")
restyle!(p, 2, marker_color="rgba(255, 182, 193, 0.9)")
p
```

#### Data Labels on Hover

```julia
using PlotlyJS, HTTP, CSV, DataFrames

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_usa_states.csv")

plot(
    df, x=:Postal, y=:Population, mode="markers", text=:State, marker_color=:Population,
    Layout(title="Populations of USA States")
)
```

#### Scatter with a Color Dimension

```julia
using PlotlyJS

plot(scatter(
    y=randn(500), mode="markers",
    marker=attr(size=16, color=rand(500), colorscale="Viridis", showscale=true)
))
```

#### Large Data Sets

Now in Plotly you can implement WebGL with `scattergl()` in place of `scatter()` <br>
for increased speed, improved interactivity, and the ability to plot even more data!

```julia
using PlotlyJS

N = 100000
plot(scattergl(
    x=randn(N), y=randn(N), mode="markers",
    marker=attr(color=randn(N), colorscale="Viridis", line_width=1)
))
```

### Reference

See https://plotly.com/julia/reference/scatter/ or https://plotly.com/julia/reference/scattergl/ for more information and chart attribute options!
