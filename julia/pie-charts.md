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
    description: How to make Pie Charts.
    display_as: basic
    language: julia
    layout: base
    name: Pie Charts
    order: 4
    page_type: example_index
    permalink: julia/pie-charts/
    thumbnail: thumbnail/pie-chart.jpg
---

A pie chart is a circular statistical chart, which is divided into sectors to illustrate numerical proportion.

If you're looking instead for a multilevel hierarchical pie-like chart, go to the
[Sunburst tutorial](/julia/sunburst-charts/).

### Pie chart with plotly express

In .`pie`, data visualized by the sectors of the pie is set in `values`. The sector labels are set in `labels`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007, :]
europe = df_2007[df_2007.continent .== "Europe", :]

europe[europe.pop .< 2e6,:country] .= "Other contries"

plot(pie( values=europe.pop, labels=europe.country), Layout(title="Population of European continent"))

```

### Pie chart with repeated labels

Lines of the dataframe with the same value for `labels` are grouped together in the same sector.

```python
import plotly.express as px
# This dataframe has 244 lines, but 4 distinct values for `day`
df = px.data.tips()
fig = px.pie(df, values='tip', names='day')
fig.show()
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

plot(
  pie(
    values=df.tip,
    labels=df.day
  )
)
```

### Setting the color of pie sectors with pie

<!-- TODO: colors not working -->

```python
import plotly.express as px
df = px.data.tips()
fig = px.pie(df, values='tip', names='day', color_discrete_sequence=px.colors.sequential.RdBu)
fig.show()
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(
  pie(
    values=df.tip,
    labels=df.day,
    color_discrete_sequence=colors.RdBu_8
  )
)
```

### Using an explicit mapping for discrete colors

For more information about discrete colors, see the [dedicated page](/python/discrete-color).

<!-- TODO: colors not working -->

```python
import plotly.express as px
df = px.data.tips()
fig = px.pie(df, values='tip', names='day', color='day',
             color_discrete_map={'Thur':'lightcyan',
                                 'Fri':'cyan',
                                 'Sat':'royalblue',
                                 'Sun':'darkblue'})
fig.show()
```

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")
plot(
  pie(
    values=df.tip,
    labels=df.day,
    color_discrete_map=attr(
      Thur="lightcyan",
      Fri="cyan",
      Sat="royalblue",
      Sun="darkblue"
    )
  )
)
```

### Customizing a pie chart created with pie

In the example below, we first create a pie chart with `pie`, using some of its options such as `hover_data` (which columns should appear in the hover) or `labels` (renaming column names). For further tuning, we call `restyle!` to set other parameters of the chart (you can also use `relayout!` for changing the layout).

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007, :]
americas = df_2007[df_2007.continent .== "Americas", :]

fig = plot(
  pie(
    values=americas.pop, labels=americas.country,
    hover_data=americas.lifeExp
  ),
  Layout(
    title="Population of American Continent"
  )
)
restyle!(fig, textposition="inside", textinfo="percent+label")
fig
```

### Styled Pie Chart

Colors can be given as RGB triplets or hexadecimal strings, or with [CSS color names](https://www.w3schools.com/cssref/css_colors.asp) as below.

```julia
using PlotlyJS

cols = ["gold", "mediumturquoise", "darkorange", "lightgreen"]

fig = plot(
  pie(
    labels=["Oxygen","Hydrogen","Carbon_Dioxide","Nitrogen"],
    values=[4500,2500,1053,500]
  )
)
restyle!(fig, hoverinfo="label+percent", textinfo="value", textfont_size=20,
                  marker=attr(colors=cols, line=attr(color="#000000", width=2)))
fig
```

### Controlling text fontsize with uniformtext

If you want all the text labels to have the same size, you can use the `uniformtext` layout parameter. The `minsize` attribute sets the font size, and the `mode` attribute sets what happens for labels which cannot fit with the desired fontsize: either `hide` them or `show` them with overflow. In the example below we also force the text to be inside with `textposition`, otherwise text labels which do not fit are displayed outside of pie sectors.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
asia = df[df.continent .== "Asia", :]

fig = plot(pie(values=asia.pop, labels=asia.country))
restyle!(fig, textposition="inside")
relayout!(fig, uniformtext_minsize=12, uniformtext_mode="hide")
fig
```

#### Controlling text orientation inside pie sectors

The `insidetextorientation` attribute controls the orientation of text inside sectors. With
"auto" the texts may automatically be rotated to fit with the maximum size inside the slice. Using "horizontal" (resp. "radial", "tangential") forces text to be horizontal (resp. radial or tangential)

For a figure `fig` created with plotly express, use `restyle!(insidetextorientation='...')` to change the text orientation.

```julia
using PlotlyJS

labels = ["Oxygen","Hydrogen","Carbon_Dioxide","Nitrogen"]
values = [4500, 2500, 1053, 500]

plot(pie(labels=labels, values=values, textinfo="label+percent",
                             insidetextorientation="radial"
                            ))
```

### Donut Chart

```julia
import plotly.graph_objects as go

labels = ["Oxygen","Hydrogen","Carbon_Dioxide","Nitrogen"]
values = [4500, 2500, 1053, 500]

# Use `hole` to create a donut-like pie chart
fig = plot(pie(labels=labels, values=values, hole=.3))
```

### Pulling sectors out from the center

For a "pulled-out" or "exploded" layout of the pie chart, use the `pull` argument. It can be a scalar for pulling all sectors or an array to pull only some of the sectors.

```julia
import plotly.graph_objects as go

labels = ["Oxygen","Hydrogen","Carbon_Dioxide","Nitrogen"]
values = [4500, 2500, 1053, 500]

# pull is given as a fraction of the pie radius
fig = plot(pie(labels=labels, values=values, pull=[0, 0, 0.2, 0]))
```

### Pie Charts in subplots

```julia

labels = ["US", "China", "European Union", "Russian Federation", "Brazil", "India",
          "Rest of World"]

# Create subplots: use 'domain' type for Pie subplot
fig = make_subplots(rows=1, cols=2, specs=fill(Spec(kind="domain"), 1,2))
add_trace!(fig, pie(labels=labels, values=[16, 15, 12, 6, 5, 4, 42], name="GHG Emissions"),
              row=1, col=1)
add_trace!(fig, pie(labels=labels, values=[27, 11, 25, 8, 1, 3, 25], name="CO2 Emissions"),
              row=1, col=2)

# Use `hole` to create a donut-like pie chart
restyle!(fig, hole=.4, hoverinfo="label+percent+name")

relayout!(fig,
    title_text="Global Emissions 1990-2011",
    # Add annotations in the center of the donut pies.
    annotations=[attr(text="GHG", x=0.18, y=0.5, font_size=20, showarrow=false),
                 attr(text="CO2", x=0.82, y=0.5, font_size=20, showarrow=false)])

fig
```

```julia
using PlotlyJS

labels = ["1st", "2nd", "3rd", "4th", "5th"]

# Define color sets of paintings
night_colors = ["rgb(56, 75, 126)", "rgb(18, 36, 37)", "rgb(34, 53, 101)",
                "rgb(36, 55, 57)", "rgb(6, 4, 4)"]
sunflowers_colors = ["rgb(177, 127, 38)", "rgb(205, 152, 36)", "rgb(99, 79, 37)",
                     "rgb(129, 180, 179)", "rgb(124, 103, 37)"]
irises_colors = ["rgb(33, 75, 99)", "rgb(79, 129, 102)", "rgb(151, 179, 100)",
                 "rgb(175, 49, 35)", "rgb(36, 73, 147)"]
cafe_colors =  ["rgb(146, 123, 21)", "rgb(177, 180, 34)", "rgb(206, 206, 40)",
                "rgb(175, 51, 21)", "rgb(35, 36, 21)"]

# Create subplots, using "domain" type for pie charts
fig = make_subplots(rows=2, cols=2, specs=fill(Spec(kind="domain"), 2,2))

# Define pie charts
add_trace!(fig, pie(labels=labels, values=[38, 27, 18, 10, 7], name="Starry Night",
                     marker_colors=night_colors), row=1, col=1)
add_trace!(fig, pie(labels=labels, values=[28, 26, 21, 15, 10], name="Sunflowers",
                     marker_colors=sunflowers_colors), row=1, col=2)
add_trace!(fig, pie(labels=labels, values=[38, 19, 16, 14, 13], name="Irises",
                     marker_colors=irises_colors), row=2, col=1)
add_trace!(fig, pie(labels=labels, values=[31, 24, 19, 18, 8], name="The Night Café",
                     marker_colors=cafe_colors), row=2, col=2)

# Tune layout and hover info
restyle!(fig, hoverinfo="label+percent+name", textinfo="none")
relayout!(fig, title_text="Van Gogh: 5 Most Prominent Colors Shown Proportionally",
           showlegend=false)

fig
```

#### Plot chart with area proportional to total count

Plots in the same `scalegroup` are represented with an area proportional to their total size.

```julia
using PlotlyJS
labels = ["Asia", "Europe", "Africa", "Americas", "Oceania"]

fig = make_subplots(rows=1, cols=2, specs=fill(Spec(kind="domain"), 1,2),
                    subplot_titles=["1980" "2007"])
add_trace!(fig, pie(labels=labels, values=[4, 7, 1, 7, 0.5], scalegroup="one",
                     name="World GDP 1980"), row=1, col=1)
add_trace!(fig, pie(labels=labels, values=[21, 15, 3, 19, 1], scalegroup="one",
                     name="World GDP 2007"), row=1, col=2)

relayout!(fig, title_text="World GDP")
fig
```

### See Also: Sunburst charts

For multilevel pie charts representing hierarchical data, you can use the `Sunburst` chart. A simple example is given below, for more information see the [tutorial on Sunburst charts](/julia/sunburst-charts/).

```julia
using PlotlyJS

fig =plot(sunburst(
    labels=["Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"],
    parents=["", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve" ],
    values=[10, 14, 12, 10, 2, 6, 6, 4, 4],
))
relayout!(fig, margin = attr(t=0, l=0, r=0, b=0))

fig
```

#### Reference

See [function reference for `pie()`](https://plotly.com/julia-api-reference/generated/plotly.express.pie) or https://plotly.com/julia/reference/pie/ for more information and chart attribute options!
