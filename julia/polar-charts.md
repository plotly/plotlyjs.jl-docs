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
    description: How to make polar charts in Julia with Plotly.
    display_as: scientific
    language: julia
    layout: base
    name: Polar Charts
    order: 16
    page_type: u-guide
    permalink: julia/polar-chart/
    thumbnail: thumbnail/polar.gif
---

## Polar chart

A polar chart represents data along radial and angular axes. Using the `scatterpolar` trace type, it is possible to represent polar data as scatter markers by setting `mode="markers"` and polar lines by setting `mode="lines"`.

The radial and angular coordinates are given with the `r` and `theta` arguments of `scatterpolar`. In the example below the `theta` data are categorical, but numerical data are possible too and the most common case.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "wind")
plot(scatterpolar(df, r=:frequency, theta=:direction, mode="markers"))
```

The "strength" column corresponds to strength categories of the wind, and there is a frequency value for each direction and strength. Below we use the strength column to encode the color of the markers.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "wind")

plot(scatterpolar(
    df,
    r=:frequency, theta=:direction, color=:strength,
    marker=attr(size=:frequency, sizeref=0.05), mode="markers"
))

```

For a line polar plot, use `mode="lines"`:

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "wind")

plot(scatterpolar(
    df,
    r=:frequency, theta=:direction, color=:strength,
    marker=attr(size=:frequency, sizeref=0.05), mode="lines"
))
```

You can plot less than a whole circle by setting the `polar_sector` argument on the Layout. You can also control the direction using `polar_angularaxis_direction`:

```julia
using PlotlyJS
plot(
    scatterpolar(r=0:10:90, theta=0:10:90, mode="markerss",),
    Layout(polar=attr(angularaxis_direction="counterclockwise", sector=(0, 90)))
)
```

#### Line Polar Chart

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/polar_dataset.csv")

plot([
    scatterpolar(df, r=:x1, theta=:y, mode="lines", name="Figure 8"),
    scatterpolar(df, r=:x2, theta=:y, mode="lines", name="Cardioid"),
    scatterpolar(df, r=:x3, theta=:y, mode="lines", name="Hypercardioid"),
], Layout(title="Mic Patterns"))
```

#### Polar Bar Chart

a.k.a matplotlib logo in a few lines of code

```julia
using PlotlyJS

plot(
    barpolar(
        r=[3.5, 1.5, 2.5, 4.5, 4.5, 4, 3],
        theta=[65, 15, 210, 110, 312.5, 180, 270],
        width=[20,15,10,20,15,30,15,],
        marker_color=["#E4FF87", "#709BFF", "#709BFF", "#FFAA70", "#FFAA70", "#FFDF70", "#B6FFB4"],
        marker_line_color="black",
        marker_line_width=2,
        opacity=0.8
    ),
    Layout(polar = attr(
        radialaxis = attr(range=[0, 5], showticklabels=false, ticks=""),
        angularaxis = attr(showticklabels=false, ticks="")
    ))
)
```

#### Categorical Polar Chart

```julia
using PlotlyJS

p = make_subplots(rows=2, cols=2, specs=fill(Spec(kind="polar"), 2, 2))

add_trace!(p, row=1, col=1, scatterpolar(
      name = "angular categories",
      r = [5, 4, 2, 4, 5],
      theta = ["a", "b", "c", "d", "a"],
))
add_trace!(p, row=1, col=2, scatterpolar(
    name = "radial categories",
    r = ["a", "b", "c", "d", "b", "f", "a"],
    theta = [1, 4, 2, 1.5, 1.5, 6, 5],
    thetaunit = "radians",
))
add_trace!(p, row=2, col=1, scatterpolar(
    name = "angular categories (w/ categoryarray)",
    r = [5, 4, 2, 4, 5],
    theta = ["a", "b", "c", "d", "a"],
))
add_trace!(p, row=2, col=2, scatterpolar(
    name = "radial categories (w/ category descending)",
    r = ["a", "b", "c", "d", "b", "f", "a", "a"],
    theta = [45, 90, 180, 200, 300, 15, 20, 45],
))
relayout!(p,
    polar=attr(
        radialaxis_angle=-45,
        angularaxis=attr(
            direction="clockwise",
            period=6
        )
    ),
    polar2=attr(
        radialaxis=attr(
            angle=180,
            tickangle=-180 # so that tick labels are not upside down
      )
    ),
    polar3=attr(
        sector=[80, 400],
        radialaxis_angle=-45,
        angularaxis_categoryarray=["d", "a", "c", "b"]
    ),
    polar4=attr(
        radialaxis_categoryorder="category descending",
        angularaxis=attr(
            thetaunit="radians",
            dtick=0.3141592653589793
        )
    )
)
```

#### Polar Chart Sector

```julia
using PlotlyJS

p = make_subplots(rows=1, cols=2, specs=fill(Spec(kind="polar"), 1, 2))

make_trace() = scatterpolar(
    r=[1,2,3,4,5],
    theta=[0,90,180,360,0],
    mode="lines+markers",
    line_color="magenta",
    marker=attr(
        color="royalblue",
        symbol="square",
        size=8
    )
)

add_trace!(p, make_trace(), row=1, col=1)
add_trace!(p, make_trace(), row=1, col=2)

# The sector is [0, 360] by default, we update it for the first plot only
# setting parameters for the second plot would be polar2=...
relayout!(p, polar_sector=[150, 210])
p
```

#### Polar Chart Directions

```julia
using PlotlyJS

p = make_subplots(rows=1, cols=2, specs=fill(Spec(kind="polar"), 1, 2))

r = [1,2,3,4,5]
theta = [0,90,180,360,0]

make_trace() = scatterpolar(
    r=[1,2,3,4,5],
    theta=[0,90,180,360,0],
    mode="lines+markers",
    line_color="indianred",
    marker=attr(
        color="lightslategray",
        symbol="square",
        size=8
    )
)

add_trace!(p, make_trace(), row=1, col=1)
add_trace!(p, make_trace(), row=1, col=2)

relayout!(p,
    showlegend=false,
    polar=attr(
      radialaxis_tickfont_size=8,
      angularaxis=attr(
        tickfont_size=8,
        rotation=90, # start position of angular axis
        direction="counterclockwise"
      )
    ),
    polar2=attr(
      radialaxis_tickfont_size=8,
      angularaxis=attr(
        tickfont_size=8,
        rotation=90,
        direction="clockwise"
      ),
    )
)

p
```

#### Webgl Polar Chart

The `scatterpolargl` trace uses the [WebGL](https://en.wikipedia.org/wiki/WebGL) plotting engine for GPU-accelerated rendering.

```julia
using PlotlyJS, CSV, DataFrames, HTTP

read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body))

df = read_remote_csv("https://raw.githubusercontent.com/plotly/datasets/master/hobbs-pearson-trials.csv")

plot(
    [
        scatterpolargl(
            df; marker=attr(size=15, color="mediumseagreen"), mode="markers",
            r=:trial_1_r,theta=:trial_1_theta, name="Trial 1",
        ),
        scatterpolargl(
            df; marker=attr(size=20, color="darkorange"), mode="markers",
            r=:trial_2_r,theta=:trial_2_theta, name="Trial 2",
        ),
        scatterpolargl(
            df; marker=attr(size=12, color="mediumpurple"), mode="markers",
            r=:trial_3_r,theta=:trial_3_theta, name="Trial 3",
        ),
        scatterpolargl(
            df; marker=attr(size=22, color = "magenta"), mode="markers",
            r=:trial_4_r,theta=:trial_4_theta, name="Trial 4",
        ),
        scatterpolargl(
            df; marker=attr(size=19, color="limegreen"), mode="markers",
            r=:trial_5_r,theta=:trial_5_theta, name="Trial 3",
        ),
        scatterpolargl(
            df; marker=attr(size=10, color = "gold"), mode="markers",
            r=:trial_6_r,theta=:trial_6_theta, name="Trial 4",
        ),
    ],
    Layout(
        title="Hobbs-Pearson Trials",
        font_size=15,
        showlegend=false,
        polar=attr(
            bgcolor="rgb(223, 223, 223)",
            angularaxis=attr(linewidth=3, showline=true, linecolor="black"),
            radialaxis=attr(
                side="counterclockwise",
                showline=true,
                linewidth=2,
                gridcolor="white",
                gridwidth=2,
            )
        ),
    paper_bgcolor="rgb(223, 223, 223)"
    )
)
```

#### Reference

See https://plotly.com/julia/reference/scatterpolar/ for more information and chart attribute options!
