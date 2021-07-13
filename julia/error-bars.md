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
    description: How to add error-bars to charts in Julia with Plotly.
    display_as: statistical
    language: julia
    layout: base
    name: Error Bars
    order: 1
    page_type: example_index
    permalink: julia/error-bars/
    thumbnail: thumbnail/error-bar.jpg
---

### Error Bars

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

df[!, "e"] = df[!, "sepal_width"]/100

trace = scatter(
    df,
    x=:sepal_width,
    y=:sepal_length,
    group=:species,
    mode="markers",
    error_x=attr(type="data", array=:e, visible=true),
    error_y=attr(type="data", array=:e, visible=true),
)

plot(trace)
```

#### Asymmetric Error Bars with Plotly Express

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

df[!, "e_plus"] = df[!, "sepal_width"]/100
df[!, "e_minus"] = df[!, "sepal_width"]/40
trace = scatter(
    df,
    x=:sepal_width,
    y=:sepal_length,
    group=:species,
    mode="markers",
    error_y=attr(type="data", array=:e_plus, arrayminus=:e_minus, visible=true),
)

plot(trace)
```

#### Error Bars as a Percentage of the y Value

```julia
using PlotlyJS, CSV, DataFrames

trace = scatter(
        x=[0, 1, 2],
        y=[6, 10, 2],
        mode="markers",
        error_y=attr(
            type='percent', # value of error bar given as percentage of y value
            value=50,
            visible=true)
    ))

plot(trace)
```

#### Asymmetric Error Bars with a Constant Offset

```julia
using PlotlyJS, CSV, DataFrames

trace = scatter(
        x=[1, 2, 3, 4],
        y=[2, 1, 3, 4],
        mode="markers",
        error_y=attr(
            type="percent",
            symmetric=false,
            value=15,
            valueminus=25)
    ))
plot(trace)
```

#### Horizontal Error Bars

```julia
using PlotlyJS, CSV, DataFrames

trace = scatter(
        x=[1, 2, 3, 4],
        y=[2, 1, 3, 4],
        mode="markers",
        error_x=attr(
            type="percent",
            value=15
        )
    ))
plot(trace)
```

#### Bar Chart with Error Bars

```julia
using PlotlyJS, CSV, DataFrames

trace1 = bar(
    name="Control",
    x=["Trial 1", "Trial 2", "Trial 3"], y=[3, 6, 4],
    error_y=attr(type="data", array=[1, 0.5, 1.5])
))
trace2 = bar(
    name="Experimental",
    x=["Trial 1", "Trial 2", "Trial 3"], y=[4, 7, 3],
    error_y=attr(type="data", array=[0.5, 1, 2])
))

plot([trace1, trace2])
```

#### Colored and Styled Error Bars

```julia
using PlotlyJS

x_theo = range(-4, stop=4, length=100)
sincx = sinc.(x_theo)
x = [-3.8, -3.03, -1.91, -1.46, -0.89, -0.24, -0.0, 0.41, 0.89, 1.01, 1.91, 2.28, 2.79, 3.56]
y = [-0.02, 0.04, -0.01, -0.27, 0.36, 0.75, 1.03, 0.65, 0.28, 0.02, -0.11, 0.16, 0.04, -0.15]

trace1 = scatter(
    x=x_theo, y=sincx,
    name="sinc(x)"
)

trace2 = scatter(
    x=x, y=y,
    mode="markers",
    name="measured",
    error_y=attr(
        type="constant",
        value=0.1,
        color="purple",
        thickness=1.5,
        width=3,
    ),
    error_x=attr(
        type="constant",
        value=0.2,
        color="purple",
        thickness=1.5,
        width=3,
    ),
    marker=attr(color="purple", size=8)
)

plot([trace1, trace2])
```

#### Reference

See https://plotly.com/julia/reference/scatter/ for more information and chart attribute options!
