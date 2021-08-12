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
      How to make line charts in Julia with Plotly. Examples on creating
      and styling line charts in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Line Charts
    order: 2
    page_type: example_index
    permalink: julia/line-charts/
    thumbnail: thumbnail/line-plot.jpg
---

### Line Plots with plotly.express

For more examples of line plots, see the [line and scatter notebook](https://plotly.com/julia/line-and-scatter/).

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
dfCan = df[df.country .== "Canada", :]
plot(dfCan, kind="scatter", mode="lines", x=:year, y=:lifeExp, Layout(title="Life expectancy in Canada"))
```

### Line Plots with column encoding color

```julia
import plotly.express as px

df = dataset(DataFrame, "gapminder")
dfCan = df[df.continent .== "Oceania", :]
plot(dfCan, kind="scatter", mode="lines", x=:year, y=:lifeExp, group=:country)

```

<!-- TODO: can't set index, use facet_row as column names -->

### Sparklines with Plotly Express

Sparklines are scatter plots inside subplots, with gridlines, axis lines, and ticks removed.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "stocks")

df = px.data.stocks(indexed=True)
fig = px.line(df, facet_row="company", facet_row_spacing=0.01, height=200, width=200)

# hide and lock down axes
fig.update_xaxes(visible=false, fixedrange=True)
fig.update_yaxes(visible=false, fixedrange=True)

# remove facet/subplot labels
fig.update_layout(annotations=[], overwrite=True)

# strip down the rest of the plot
fig.update_layout(
    showlegend=false,
    plot_bgcolor="white",
    margin=dict(t=10,l=10,b=10,r=10)
)

# disable the modebar for such a small plot
fig.show(config=dict(displayModeBar=false))
```

#### Line Plot Modes

```julia
using PlotlyJS

N = 100
random_x = range(0, stop=1, length=N)
random_y0 = randn(N) .+ 5
random_y1 = randn(N)
random_y2 = randn(N) .- 5

# Create traces
trace1 = scatter(x=random_x, y=random_y0,
                    mode="lines",
                    name="lines")
trace2 = scatter(x=random_x, y=random_y1,
                    mode="lines+markers",
                    name="lines+markers")
trace3 = scatter(x=random_x, y=random_y2,
                    mode="markers", name="markers")

plot([trace1, trace2, trace3])
```

#### Style Line Plots

This example styles the color and dash of the traces, adds trace names,
modifies line width, and adds plot and axes titles.

```julia
using PlotlyJS

# Add data
month = ["January", "February", "March", "April", "May", "June", "July",
         "August", "September", "October", "November", "December"]
high_2000 = [32.5, 37.6, 49.9, 53.0, 69.1, 75.4, 76.5, 76.6, 70.7, 60.6, 45.1, 29.3]
low_2000 = [13.8, 22.3, 32.5, 37.2, 49.9, 56.1, 57.7, 58.3, 51.2, 42.8, 31.6, 15.9]
high_2007 = [36.5, 26.6, 43.6, 52.3, 71.5, 81.4, 80.5, 82.2, 76.0, 67.3, 46.1, 35.0]
low_2007 = [23.6, 14.0, 27.0, 36.8, 47.6, 57.7, 58.9, 61.2, 53.3, 48.5, 31.0, 23.6]
high_2014 = [28.8, 28.5, 37.0, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9]
low_2014 = [12.7, 14.3, 18.6, 35.5, 49.9, 58.0, 60.0, 58.6, 51.7, 45.2, 32.2, 29.1]

# Create and style traces
trace1 = scatter(x=month, y=high_2014, name="High 2014",
                         line=attr(color="firebrick", width=4))
trace2 = scatter(x=month, y=low_2014, name = "Low 2014",
                         line=attr(color="royalblue", width=4))
trace3 = scatter(x=month, y=high_2007, name="High 2007",
                         line=attr(color="firebrick", width=4,
                              dash="dash") # dash options include "dash", "dot", and "dashdot"
)
trace4 = scatter(x=month, y=low_2007, name="Low 2007",
                         line = attr(color="royalblue", width=4, dash="dash"))
trace5 = scatter(x=month, y=high_2000, name="High 2000",
                         line = attr(color="firebrick", width=4, dash="dot"))
trace6 = scatter(x=month, y=low_2000, name="Low 2000",
                         line=attr(color="royalblue", width=4, dash="dot"))


# Edit the layout
layout = Layout(title="Average High and Low Temperatures in New York",
                   xaxis_title="Month",
                   yaxis_title="Temperature (degrees F)")

plot([trace1 ,trace2, trace3, trace4, trace5, trace6], layout)
```

#### Connect Data Gaps

[connectgaps](https://plotly.com/julia/reference/scatter/#scatter-connectgaps) determines if missing values in the provided data are shown as a gap in the graph or not. In [this tutorial](https://plotly.com/julia/filled-area-on-mapbox/#multiple-filled-areas-with-a-scattermapbox-trace), we showed how to take benefit of this feature and illustrate multiple areas in mapbox.

```julia
using PlotlyJS

x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

trace1 = scatter(
    x=x,
    y=[10, 20, nothing, 15, 10, 5, 15, nothing, 20, 10, 10, 15, 25, 20, 10],
    name = "<b>No</b> Gaps", # Style name/legend entry with html tags
    connectgaps=true # override default to connect the gaps
)
trace2 = scatter(
    x=x,
    y=[5, 15, nothing, 10, 5, 0, 10, nothing, 15, 5, 5, 10, 20, 15, 5],
    name="Gaps",
)

plot([trace1, trace2])

```

#### Interpolation with Line Plots

```julia
using PlotlyJS

x = [1, 2, 3, 4, 5]
y = [1, 3, 2, 3, 1]

trace1 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y, name="linear",
                    line_shape="linear")
trace2 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y .+ 5, name="spline",
                    text=["tweak line smoothness<br>with 'smoothing' in line object"],
                    line_shape="spline")
trace3 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y .+ 10, name="vhv",
                    line_shape="vhv")
trace4 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y .+ 15, name="hvh",
                    line_shape="hvh")
trace5 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y .+ 20, name="vh",
                    line_shape="vh")
trace6 = scatter(hoverinfo="text+name", mode="lines+markers", x=x, y=y .+ 25, name="hv",
                    line_shape="hv")

layout = Layout(legend=attr(y=0.5, traceorder="reversed", font_size=16))

plot([trace1, trace2, trace3, trace4, trace5, trace6], layout)
```

#### Label Lines with Annotations

 <!-- TODO: I can't seem to append `attr`s to an array... -->

```julia
using PlotlyJS

title = "Main Source for News"
labels = ["Television", "Newspaper", "Internet", "Radio"]
colors = ["rgb(67,67,67)", "rgb(115,115,115)", "rgb(49,130,189)", "rgb(189,189,189)"]

mode_size = [8, 8, 12, 8]
line_size = [2, 2, 4, 2]

x_data = [
    [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011,2012, 2013],
    [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011,2012, 2013],
    [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011,2012, 2013],
    [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011,2012, 2013]
]

y_data = [
    [74, 82, 80, 74, 73, 72, 74, 70, 70, 66, 66, 69],
    [45, 42, 50, 46, 36, 36, 34, 35, 32, 31, 31, 28],
    [13, 14, 20, 24, 20, 24, 24, 40, 35, 41, 43, 50],
    [18, 21, 18, 21, 16, 14, 13, 18, 17, 16, 19, 23],
]

traces = []
for i in 1:5
traces = [
    scatter(x=x_data[i], y=y_data[i], mode="lines",
        name=labels[i],
        line=attr(color=colors[i], width=line_size[i]),
        connectgaps=true
    ),
    scatter(
        x=[x_data[i][1], last(x_data[i])],
        y=[y_data[i][1], last(y_data[i])],
        mode="markers",
        marker=attr(color=colors[i], size=mode_size[i]))
    )
for i in 1:5]



annotations = []

# Adding labels
for (y_trace, label, color) in zip(y_data, labels, colors)
    # labeling the left_side of the plot
    append!(annotations, attr(xref=paper, x=0.05, y=y_trace[0],
                                  xanchor="right", yanchor="middle",
                                  text=label + " {}%".format(y_trace[0]),
                                  font=attr(family="Arial",
                                            size=16),
                                  showarrow=false))
    # labeling the right_side of the plot
    append!(annotations, attr(xref=paper, x=0.95, y=y_trace[11],
                                  xanchor="left", yanchor="middle",
                                  text="{}%".format(y_trace[11]),
                                  font=attr(family="Arial",
                                            size=16),
                                  showarrow=false))
end
# Title
append!(annotations, attr(xref=paper, yref="paper", x=0.0, y=1.05,
                              xanchor="left", yanchor="bottom",
                              text="Main Source for News",
                              font=attr(family="Arial",
                                        size=30,
                                        color="rgb(37,37,37)"),
                              showarrow=false))
# Source
append!(annotations, attr(xref=paper, yref="paper", x=0.5, y=-0.1,
                              xanchor="center", yanchor="top",
                              text="Source: PewResearch Center & " +
                                   "Storytelling with data",
                              font=attr(family="Arial",
                                        size=12,
                                        color="rgb(150,150,150)"),
                              showarrow=false))


layout =Layout(
    annotations=annotations
    xaxis=attr(
        showline=true,
        showgrid=false,
        showticklabels=true,
        linecolor="rgb(204, 204, 204)",
        linewidth=2,
        ticks="outside",
        tickfont=attr(
            family="Arial",
            size=12,
            color="rgb(82, 82, 82)",
        ),
    ),
    yaxis=attr(
        showgrid=false,
        zeroline=false,
        showline=false,
        showticklabels=false,
    ),
    autosize=false,
    margin=attr(
        autoexpand=false,
        l=100,
        r=20,
        t=110,
    ),
    showlegend=false,
    plot_bgcolor="white"
)
```

<!-- TODO: Filling lines not working -->

#### Filled Lines

```julia
using PlotlyJS

x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
x_rev = reverse(x)

# Line 1
y1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y1_upper = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
y1_lower = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
y1_lower = reverse(y1_lower)

# Line 2
y2 = [5, 2.5, 5, 7.5, 5, 2.5, 7.5, 4.5, 5.5, 5]
y2_upper = [5.5, 3, 5.5, 8, 6, 3, 8, 5, 6, 5.5]
y2_lower = [4.5, 2, 4.4, 7, 4, 2, 7, 4, 5, 4.75]
y2_lower = reverse(y2_lower)

# Line 3
y3 = [10, 8, 6, 4, 2, 0, 2, 4, 2, 0]
y3_upper = [11, 9, 7, 5, 3, 1, 3, 5, 3, 1]
y3_lower = [9, 7, 5, 3, 1, -.5, 1, 3, 1, -1]
y3_lower = reverse(y3_lower)


trace1 = scatter(
    mode="lines",
    x=x .+ x_rev,
    y=y1_upper .+ y1_lower,
    fill="toself",
    fillcolor="rgba(0,100,80,0.2)",
    line_color="rgba(255,255,255,0)",
    showlegend=false,
    name="Fair",
)
trace2 = scatter(
    mode="lines",
    x=x .+ x_rev,
    y=y2_upper .+ y2_lower,
    fill="toself",
    fillcolor="rgba(0,176,246,0.2)",
    line_color="rgba(255,255,255,0)",
    name="Premium",
    showlegend=false,
)
trace3 = scatter(
    mode="lines",
    x=x .+ x_rev,
    y=y3_upper .+ y3_lower,
    fill="toself",
    fillcolor="rgba(231,107,243,0.2)",
    line_color="rgba(255,255,255,0)",
    showlegend=false,
    name="Ideal",
)
trace4 = scatter(
    mode="lines",
    x=x, y=y1,
    line_color="rgb(0,100,80)",
    name="Fair",
)
trace5 = scatter(
    mode="lines",
    x=x, y=y2,
    line_color="rgb(0,176,246)",
    name="Premium",
)
trace6 = scatter(
    mode="lines",
    x=x, y=y3,
    line_color="rgb(231,107,243)",
    name="Ideal",
)

fig.update_traces()
fig.show()
```

#### Reference

See [function reference for `px.line()`](https://plotly.com/python-api-reference/generated/plotly.express.line) or https://plotly.com/python/reference/scatter/ for more information and chart attribute options!
