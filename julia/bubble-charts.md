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
    description: How to make bubble charts in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Bubble Charts
    order: 5
    page_type: example_index
    permalink: julia/bubble-charts/
    redirect_from: julia/bubble-charts-tutorial/
    thumbnail: thumbnail/bubble.jpg
---

## Bubble chart with DataFrames

A [bubble chart](https://en.wikipedia.org/wiki/Bubble_chart) is a scatter plot in which a third dimension of the data is shown through the size of markers. For other types of scatter plot, see the [line and scatter page](https://plotly.com/julia/line-and-scatter/).

We first show a bubble chart example using a `DataFrames.DataFrame` instance. The size of markers is set from the dataframe column `pop` given as the `marker_size` parameter.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df07 = df[df.year .== 2007, :]

plot(
    df07,
    x=:gdpPercap, y=:lifeExp, color=:continent , mode="markers",
    marker=attr(size=:pop, sizeref=maximum(df07.pop) / (60^2), sizemode="area"),
    Layout(xaxis_type="log")
)
```

### Simple Bubble Chart

```julia
using PlotlyJS

plot(scatter(x=1:4, y=10:13, mode="markers", marker_size=40:20:100))
```

### Setting Marker Size and Color

```julia
using PlotlyJS

plot(scatter(
    x=1:4, y=10:13, mode="markers",
    marker=attr(
        size=40:20:100,
        color=["rgb(93, 164, 214)", "rgb(255, 144, 14)",
               "rgb(44, 160, 101)", "rgb(255, 65, 54)"],
        opacity=1:-0.2:0.4,
    )
))
```

### Scaling the Size of Bubble Charts

To scale the bubble size, use the attribute `sizeref`. We recommend using the following formula to calculate a `sizeref` value:<br>
`sizeref = 2. * max(array of size values) / (desired maximum marker size ** 2)`<br>
Note that setting "sizeref" to a value greater than 1, decreases the rendered marker sizes, while setting "sizeref" to less than 1, increases the rendered marker sizes. See https://plotly.com/julia/reference/scatter/#scatter-marker-sizeref for more information.
Additionally, we recommend setting the sizemode attribute: https://plotly.com/julia/reference/scatter/#scatter-marker-sizemode to area.

```julia
using PlotlyJS

size = [20, 40, 60, 80, 100, 80, 60, 40, 20, 40]
plot(scatter(
    x=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    y=[11, 12, 10, 11, 12, 11, 12, 13, 12, 11],
    mode="markers",
    marker=attr(
        size=size,
        sizemode="area",
        sizeref=2*maximum(size)/(40^2),
        sizemin=4
    )
))
```

### Hover Text with Bubble Charts

```julia
using PlotlyJS

plot(scatter(
    x=1:4, y=10:13, mode="markers",
    text=["A<br>size: 40", "B<br>size: 60", "C<br>size: 80", "D<br>size: 100"],
    marker=attr(
        color=["rgb(93, 164, 214)", "rgb(255, 144, 14)",  "rgb(44, 160, 101)", "rgb(255, 65, 54)"],
        size=40:20:100,
    )
))
```

### Bubble Charts with Colorscale

```julia
using PlotlyJS

plot(scatter(
    x=[1, 3.2, 5.4, 7.6, 9.8, 12.5],
    y=[1, 3.2, 5.4, 7.6, 9.8, 12.5],
    mode="markers",
    marker=attr(
        color=[120, 125, 130, 135, 140, 145],
        size=[15, 30, 55, 70, 90, 110],
        showscale=true
        )
))
```

### Categorical Bubble Charts

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df07 = df[df.year .== 2007, :]

function make_hover_text(row)
    join([
        "Country: $(row.country)<br>",
        "Life Expectancy: $(row.lifeExp)<br>",
        "GDP per capita: $(row.lifeExp)<br>",
        "Population: $(row.pop)<br>",
        "Year: $(row.year)"
    ], " ")
end

plot(
    df07,
    x=:gdpPercap, y=:lifeExp, group=:continent, mode="markers",
    text=sub_df -> make_hover_text.(eachrow(sub_df)),
    marker=attr(size=:pop, sizeref=maximum(df07.pop) / (60^2), sizemode="area"),
    Layout(
        title="Life Expectancy v. Per Capita GDP, 2007",
        xaxis=attr(
            type="log",
            title_text="GDP per capita (2000 dollars)",
            gridcolor="white"
        ),
        yaxis=attr(title_text="Life Expectancy (years)", gridcolor="white"),
        paper_bgcolor="rgb(243, 243, 243)",
        plot_bgcolor="rgb(243, 243, 243)",
    )
)
```

### Reference

See https://plotly.com/julia/reference/scatter/ for more information and chart attribute options!
