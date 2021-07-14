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
    description: How to make Heatmaps in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Heatmaps
    order: 2
    page_type: example_index
    permalink: julia/heatmaps/
    redirect_from: julia/heatmap/
    thumbnail: thumbnail/heatmap.jpg
---

### Heatmap

```julia
using PlotlyJS

data = [
    [1, 20, 30],
    [20, 1, 60],
    [30, 60, 1]
]
plot(heatmap(z=data))
```

NOTE: I can"t find a matching way to customize the `labels` in Julia

### Customizing the axes and labels on a heatmap

You can use the `x`, `y` and `labels` arguments to customize the display of a heatmap, and use `Layout(xaxis_side="top")` to move the x axis tick labels to the top:

```julia
using PlotlyJS

data=[[1, 25, 30, 50, 1], [20, 1, 60, 80, 30], [30, 60, 1, 5, 20]]
trace = heatmap(
    z=data,
    labels=attr(x="Day of Week", y="Time of Day", color="Productivity"),
    x=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
    y=["Morning", "Afternoon", "Evening"]
)
layout = Layout(xaxis_side="top")

plot(trace, layout)
```

### Heatmap with Categorical Axis Labels

In this example we also show how to ignore hovertext when we have missing values in the data by setting the `hoverongaps` to false.

```julia
using PlotlyJS
trace = heatmap(
    z=[[1, missing, 30, 50, 1], [20, 1, 60, 80, 30], [30, 60, 1, -10, 20]],
    x=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
    y=["Morning", "Afternoon", "Evening"],
    hoverongaps=false
)
plot(trace)
```

### Heatmap with Unequal Block Sizes

```julia
using PlotlyJS
# Build the rectangles as a heatmap
# specify the edges of the heatmap squares
phi = (1 + sqrt(5) )/2. # golden ratio
xe = [0, 1, 1+(1/(phi^4)), 1+(1/(phi^3)), phi]
ye = [0, 1/(phi^3), 1/phi^3+1/phi^4, 1/(phi^2), 1]

z = [ [13,3,3,5],
      [13,2,1,5],
      [13,10,11,12],
      [13,8,8,8]
    ]

trace = heatmap(
    x = sort(xe),
    y = sort(ye),
    z = z,
    type = "heatmap",
    colorscale = "Viridis"
)

# Add spiral line plot
function spiral(th)
    a = 1.120529
    b = 0.306349
    r = a .* MathConstants.e.^(-b .* th)
    return (r .* cos.(th), r .* sin.(th))
end

theta = range(-pi/13, stop=4*pi, length=1000)
(x,y) = spiral(theta)

trace1 = scatter(
    x=x[1] .- x,
    y=-y[1] .+ y,
    line=attr(color="white", width=3)
)

axis_template = attr(range = [0,1.6], autorange = false,
             showgrid = false, zeroline = false,
             linecolor = "black", showticklabels = false,
             ticks = "" )

layout = Layout(
    margin=attr(t=200, r=200,b=200,l=200),
    xaxis=axis_template,
    yaxis=axis_template,
    showlegend=false,
    width=700,
    height=700,
    autosize=false
)

plot([trace, trace1], layout)

```

### Heatmap with Datetime Axis

```julia
using PlotlyJS, Dates, Distributions

programmers = ["Alex","Nicole","Sara","Etienne","Chelsea","Jody","Marianne"]

base = Dates.now()
# Get last 180 days
dates = Dates.now() .- Dates.Day.(0:179)

z = rand(Poisson(), size(dates)[1], size(programmers)[1])
# z = np.random.poisson(size=(len(programmers), len(dates)))

trace = heatmap(z=z, x=dates, y=programmers, colorscale="Viridis")
layout = Layout(title="Github commits per day", xaxis_nticks=36)

plot(trace, layout)
```
