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
    description: How to use hover text and formatting in Julia with Plotly.
    display_as: file_settings
    language: julia
    layout: base
    name: Hover Text and Formatting
    order: 23
    permalink: julia/hover-text-and-formatting/
    thumbnail: thumbnail/hover-text.png
---

### Hover Labels

One of the most deceptively-powerful features of interactive visualization using Plotly is the ability for the user to reveal more information about a data point by moving their mouse cursor over the point and having a hover label appear.

There are three hover modes available in Plotly. The default setting is `layout.hovermode='closest'`, wherein a single hover label appears for the point directly underneath the cursor.

#### Hovermode `closest` (default mode)

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
oceania = df[df.continent .== "Oceania", :]

plot(
    oceania,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    Layout(
        title="layout.hovermode='closest' (the default)"
    )
)

```

#### Hovermode `x` or `y`

If `layout.hovermode='x'` (or `'y'`), a single hover label appears per trace, for points at the same `x` (or `y`) value as the cursor. If multiple points in a given trace exist at the same coordinate, only one will get a hover label. In the line plot below we have forced markers to appear, to make it clearer what can be hovered over, and we have disabled the built-in Plotly Express `hovertemplate` by setting it to `None`, resulting in a more compact hover label per point:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
oceania = df[df.continent .== "Oceania", :]

plot(
    oceania,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    hovertemplate=nothing,
    Layout(
        title="layout.hovermode='x'",
        hovermode="x",
    )
)

```

#### Unified hovermode

If `layout.hovermode='x unified'` (or `'y unified'`), a single hover label appear, describing one point per trace, for points at the same `x` (or `y`) value as the cursor.  If multiple points in a given trace exist at the same coordinate, only one will get an entry in the hover label. In the line plot below we have forced markers to appear, to make it clearer what can be hovered over, and we have disabled the built-in Plotly Express `hovertemplate` by setting it to `None`, resulting in a more compact entry per point in the hover label:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
oceania = df[df.continent .== "Oceania", :]

plot(
    oceania,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    hovertemplate=nothing,
    Layout(
        title="layout.hovermode='x unified'",
        hovermode="x unified",
    )
)
```

#### Selecting a hovermode in a figure created with `plotly.graph_objects`

The hovermode is a property of the figure layout, so you can select a hovermode no matter how you created the figure, either with `plotly.express` or with `plotly.graph_objects`. Below is an example with a figure created with `plotly.graph_objects`. If you're not familiar with the structure of plotly figures, you can read [the tutorial on creating and updating plotly figures](/julia/creating-and-updating-figures/).

```julia
using PlotlyJS

t = range(0, 2*pi, length=100)
trace1 = scatter(x=t, y=sin.(t), name="sin(t)")
trace2 = scatter(x=t, y=cos.(t), name="cost(t)")
plot([trace1, trace2], Layout(hovermode="x unified"))
```

### Customizing Hover Label Appearance

Hover label text and colors default to trace colors in hover modes other than `unified`, and can be globally set via the `layout.hoverlabel` attributes. Hover label appearance can also be controlled per trace in `<trace>.hoverlabel`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
oceania = df[df.continent .== "Oceania", :]

plot(
    oceania,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    hovertemplate="country=New Zealand<br>year=%{x}<br>lifeExp=%{y}<extra></extra>",
    Layout(
        title="Custom layout.hoverlabel formatting",
        hoverlabel=attr(
            bgcolor="white",
            font_size=16,
            font_family="Rockwell"
        ),
    )
)
```

### Customizing hover text with a hovertemplate

To customize the tooltip on your graph you can use the [hovertemplate](https://plotly.com/julia/reference/pie/#pie-hovertemplate) attribute traces, which is a template string used for rendering the information that appear on hoverbox.
This template string can include `variables` in %{variable} format, `numbers` in [d3-format's syntax](https://github.com/d3/d3-3.x-api-reference/blob/master/Formatting.md#d3_format), and `date` in [d3-time-format's syntax](https://github.com/d3/d3-time-format). In the example below, the empty `<extra></extra>` tag removes the part of the hover where the trace name is usually displayed in a contrasting color. The `<extra>` tag can be used to display other parts of the hovertemplate, it is not reserved for the trace name.

Note that a hovertemplate customizes the tooltip text, while a [texttemplate](https://plotly.com/julia/reference/pie/#pie-texttemplate) customizes the text that appears on your chart. <br>

Set the horizontal alignment of the text within tooltip with [hoverlabel.align](https://plotly.com/julia/reference/layout/#layout-hoverlabel-align).

```julia
using PlotlyJS

trace1 = scatter(
    x=[1,2,3,4,5],
    y=[2.02825,1.63728,6.83839,4.8485,4.73463],
    hovertemplate=string(
        "<i>Price</i>: \$%{y:.2f}",
        "<br><b>X</b>: %{x}<br>",
        "<b>%{text}</b>"
    ),
    text=[string("Custom text ", x) for x in 1:5],
)

trace2 = scatter(
    x=[1,2,3,4,5],
    y=[3.02825,2.63728,4.83839,3.8485,1.73463],
    hovertemplate="Price: \$%{y:\$.2f}<extra></extra>"
)

plot([trace1, trace2], Layout(
    hoverlabel_align="right",
    title="Set hover text with hovertemplate"
))
```


```julia
using PlotlyJS

plot(pie(
    name = "",
    values = [2, 5, 3, 2.5],
    labels = ["R", "julia", "Java Script", "Matlab"],
    text = ["textA", "TextB", "TextC", "TextD"],
    hovertemplate = "%{label}: <br>Popularity: %{percent} </br> %{text}"
))

```


### Hover Templates with Mixtures of Period data

*New in v5.0*

When [displaying periodic data](https://plotly.com/julia/time-series/#displaying-period-data) with mixed-sized periods (i.e. quarterly and monthly) in conjunction with `x` or `x unified` hovermodes and using `hovertemplate`, the `xhoverformat` attribute can be used to control how each period's X value is displayed, and the special `%{xother}` hover-template directive can be used to control how the X value is displayed for points that do not share the exact X coordinate with the point that is being hovered on. `%{xother}` will return an empty string when the X value is the one being hovered on, otherwise it will return `(%{x})`. The special `%{_xother}`, `%{xother_}` and `%{_xother_}` variations will display with spaces before, after or around the parentheses, respectively.

```julia
using PLotlyJS 


trace1 = bar(
    x=["2020-01-01", "2020-04-01", "2020-07-01"],
    y=[1000, 1500, 1700],
    xperiod="M3",
    xperiodalignment="middle",
    xhoverformat="Q%q",
    hovertemplate="%{y}%{_xother}"
)

trace2 = scatter(
    x=["2020-01-01", "2020-02-01", "2020-03-01",
      "2020-04-01", "2020-05-01", "2020-06-01",
      "2020-07-01", "2020-08-01", "2020-09-01"],
    y=[1100,1050,1200,1300,1400,1700,1500,1400,1600],
    xperiod="M1",
    xperiodalignment="middle",
    hovertemplate="%{y}%{_xother}"
)

plot([trace1, trace2], Layout(hovermode="x unified"))
```

### Advanced Hover Template

The following example shows how to format a hover template.

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "gapminder")
df_2007 = df[df.year .== 2007, :]

df_2007 = sort(df_2007, [:continent, :country])

bubble_size = sqrt.(df_2007.pop)

df_2007.size = bubble_size
continent_names = ["Africa", "Americas", "Asia", "Europe", "Oceania"]

traces = [
    trace = scatter(
        mode="markers",
        x=continent.gdpPercap,
        y=continent.lifeExp,
        name=continent.continent[1],
        text=continent.country,
        hovertemplate=string(
            "<b>%{text}</b><br><br>",
            "GDP per Capita: %{x:\$,.0f}<br>",
            "Life Expectation: %{y:.0%}<br>",
            "Population: %{marker.size:,}",
            "<extra></extra>",
        ),
        marker_size=continent.size,
        marker_sizeref=10,
        marker_sizemode="area"
    )
    for continent in groupby(df_2007, :continent)
]

plot(traces, Layout(
    xaxis=attr(
        title="GDP Per capita",
        type="log"
    ),
    yaxis_title="Life Expectancy(years)"
))
```

### Adding other data to the hover with customdata and a hovertemplate

Ttraces have a `customdata` argument in which you can add an array, which outer dimensions should have the same dimensions as the plotted data. You can then use `customdata` inside a `hovertemplate` to display the value of customdata.

```julia
using PlotlyJS

z1 = rand(7,7)
z2 = rand(7,7)
z3 = rand(7,7)

fig = make_subplots(rows=1, cols=2)

add_trace!(fig,
    heatmap(
        z=z1,
        customdata = collect(zip(z2,z3)),
        hovertemplate="<b>z1:%{z:.3f}</b><br>z2:%{customdata[0]:.3f} <br>z3: %{customdata[1]:.3f}",
        coloraxis="coloraxis1",
        name=""
    ), 
    row=1, col=1
)

add_trace!(fig,
    heatmap(
        z=z2,
        customdata=collect(zip(z1,z3)),
        hovertemplate="z1:%{customdata[0]:.3f} <br><b>z2:%{z:.3f}</b><br>z3: %{customdata[1]:.3f}",
        coloraxis="coloraxis1",
        name=""
    ),
    row=1, col=2
)

relayout!(fig, title_text="Hover to see the value of z1, z2 and z3 together")
fig

```

### Setting the Hover Template in Mapbox Maps

```julia
using PlotlyJS

f = open(".mapbox_token") # you will need your own
token = String(read(f))
close(f)

trace = scattermapbox(
    name = "",
    mode = "markers+text+lines",
    lon = [-75, -80, -50],
    lat = [45, 20, -20],
    marker = attr(
        size=20, 
        symbol = ["bus", "harbor", "airport"],
    ),
    hovertemplate = string(
        "<b>%{marker.symbol} </b><br><br>",
        "longitude: %{lon}<br>",
        "latitude: %{lat}<br>"
    )
)

plot(trace, Layout(
    mapbox=attr(
        accesstoken=token,
        style="outdoors",
        zoom=1
    ),
    showlegend=false
))



```

### Controlling Hover Text with `hoverinfo`

Prior to the addition of `hovertemplate`, hover text was controlled via the now-deprecated `hoverinfo` attribute.

```julia
using PlotlyJS


plot(scatter(
    x=[1, 2, 3, 4, 5],
    y=[2, 1, 6, 4, 4],
    hovertext=["Text A", "Text B", "Text C", "Text D", "Text E"],
    hoverinfo="text",
    marker_color="green",
    showlegend=false
))

```

### Spike lines

Plotly supports "spike lines" which link a point to the axis on hover, and can be configured per axis.

```julia
using PlotlyJS

df = dataset(DataFrame, "gapminder")
df = df[df.continent .== "Oceania", :]

plot(
    df,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    Layout(
        xaxis_showspikes=true,
        yaxis_showspikes=true,
        title="Spike lines active"
    )
)

```

Spike lines can be styled per axis as well, and the cursor distance setting can be controlled via `layout.spikedistance`.

```julia
using PlotlyJS

df = dataset(DataFrame, "gapminder")
df = df[df.continent .== "Oceania", :]

plot(
    df,
    x=:year,
    y=:lifeExp,
    color=:country,
    mode="markers+lines",
    Layout(
        xaxis=attr(
            showspikes=true,
            spikecolor="green",
            spikesnap="cursor",
            spikemode="across"
        ),
        yaxis=attr(
            showspikes=true,
            spikecolor="orange",
            spikethickness=2
        ),
        title="Spike lines active",
        spikedistance=1000,
        hoverdistance=100
    )
)

```

#### Reference

See https://plotly.com/julia/reference/ for more information and chart attribute options!