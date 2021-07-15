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
    description: How to make Bar Charts in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Bar Charts
    order: 3
    page_type: example_index
    permalink: julia/bar-charts/
    thumbnail: thumbnail/bar.jpg
---

### Bar chart with DataFrames

When creating bar charts using DataFrames, each row of the DataFrame is represented as a rectangular mark.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_canada = df[df.country .== "Canada", :]

plot(df_canada, x=:year, y=:pop, kind="bar")
```

#### Bar chart with Long Format Data

Long-form data has one row per observation, and one column per variable. This is suitable for storing and displaying multivariate data i.e. with dimension greater than 2. This format is sometimes called "tidy".

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "medals")
long_df = stack(df, Not([:nation]), variable_name="medal", value_name="count")

plot(long_df, kind="bar", x=:nation, y=:count, group=:medal, Layout(title="Long-Form Input", barmode="stack"))
```

```julia
long_df
```

#### Bar chart with Wide Format Data

Wide-form data has one row per value of one of the first variable, and one column per value of the second variable. This is suitable for storing and displaying 2-dimensional data.

This form of data is less-well supported in Plotly"s Julia library. In order to use wide-form data, we reccomend constructing individual traces, one for each column:

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "medals")

plot(
    [bar(df, x=:nation, y=y, name=String(y)) for y in [:gold, :silver, :bronze]],
    Layout(title="Wide-Form Input")
)
```

```julia
df
```

<!-- ### Bar chart in Dash -->

### Customize bar chart

The bar plot can be customized using keyword arguments.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_canada = df[df.country .== "Canada", :]

plot(
    df_canada, x=:year, y=:pop, kind="bar",
    marker=attr(showscale=true, coloraxis="coloraxis", color=:lifeExp),
    Layout(
        yaxis_title="population of Canada",
        height=400,
        coloraxis_colorbar_title="life expectancy"
    )
)
```

When several rows share the same value of `x` (here Female or Male), the rectangles are grouped together by default

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:sex, y=:total_bill, group=:time, kind="bar")
```

Using the `Layout.barmode` property you can switch to stacked mode:

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:sex, y=:total_bill, group=:time, kind="bar", Layout(barmode="stack"))
```

Or you can choose to represent each observation as a small rectangle, stacked to form a larger bar using `Layout.barmode = "relative"`

```julia
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")
plot(df, x=:sex, y=:total_bill, group=:time, kind="bar", Layout(barmode="relative"))
```

#### Basic Bar Chart with Julia arrays

If your data is not in a DataFrame, you can also use native Julia arrays to construct your bar charts

```julia
using PlotlyJS
animals = ["giraffes", "orangutans", "monkeys"]
plot(bar(x=animals, y=[20, 14, 23]))
```

#### Grouped Bar Chart

You can use `relayout!` to update the grouping behavior

```julia
using PlotlyJS
animals = ["giraffes", "orangutans", "monkeys"]

p = plot([
    bar(name="SF Zoo", x=animals, y=[20, 14, 23]),
    bar(name="LA Zoo", x=animals, y=[12, 18, 29])
])
relayout!(p, barmode="group")
p
```

### Stacked Bar Chart

You can also set `Layout.barmode` when constructing the figure. Below is an example of stacked bars:

```julia
using PlotlyJS
animals = ["giraffes", "orangutans", "monkeys"]

p = plot([
    bar(name="SF Zoo", x=animals, y=[20, 14, 23]),
    bar(name="LA Zoo", x=animals, y=[12, 18, 29])
], Layout(barmode="stack"))
```

### Bar Chart with Hover Text

```julia
using PlotlyJS

x = ["Product A", "Product B", "Product C"]
y = [20, 14, 23]
text = ["$x% market share" for x in [27, 25, 19]]
plot(bar(
    x=x, y=y, hovertext=text,
    marker=attr(color="rgb(158,202,225)", line_color="rgb(8,48,107)", line_width=1.5, opacity=0.6)
), Layout(title_text="January 2013 Sales Report"))
```

### Bar Chart with Direct Labels

```julia
using PlotlyJS

x = ["Product A", "Product B", "Product C"]
y = [20, 14, 23]

# Use textposition="auto" for direct text
plot(bar(x=x, y=y, text=y, textposition="auto"))
```

### Controlling text fontsize with uniformtext

If you want all the text labels to have the same size, you can use the `uniformtext` layout parameter. The `minsize` attribute sets the font size, and the `mode` attribute sets what happens for labels which cannot fit with the desired fontsize: either `hide` them or `show` them with overflow. In the example below we also force the text to be outside of bars with `textposition`.

```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_smaller = df[(df.continent .== "Europe") .& (df.year .== 2007) .& (df.pop .> 2e6), :]
plot(
    df_smaller,
    y=:pop, x=:country, text=:pop, kind="bar",
    texttemplate="%{text:.2s}", textposition="outside",
    Layout(uniformtext_minsize=8, uniformtext_mode="hide")
)
```

### Rotated Bar Chart Labels

```julia
using PlotlyJS, Random

months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

plot([
     bar(x=months, y=rand(10:20, 12), name="Primary Product", marker_color="indianred"),
     bar(x=months, y=rand(0:30, 12), name="Secondary Product", marker_color="lightsalmon")
], Layout(barmode="group", xaxis_tickangle=-45))
```

### Customizing Individual Bar Colors

```julia
using PlotlyJS

colors = fill("lightslategray", 5)
colors[2] = "crimson"

plot(
    bar(x='A':'E', y=[20, 14, 23, 25, 22], marker_color=colors),
    Layout(title_text="Least Used Feature")
)
```

### Customizing Individual Bar Widths

```julia
using PlotlyJS

plot(bar(
    x=[1, 2, 3, 5.5, 10],
    y=[10, 8, 6, 4, 2],
    width=[0.8, 0.8, 0.8, 3.5, 4] # customize width here
))
```

Bar charts with custom widths can be used to make mekko charts (also known as marimekko charts, mosaic plots, or variwide charts).

```julia
using PlotlyJS

labels = ["apples","oranges","pears","bananas"]
widths = [10, 20, 20, 50]

data = Dict(
    "South" => [50,80,60,70],
    "North" => [50,20,40,30]
)

function make_trace(key)
    bar(
        name=key, y=data[key], x=cumsum(widths)-widths, width=widths,
        offset=0,
        customdata=permutedims([labels widths .* data[key]]),
        texttemplate="%{y} x %{width} =<br>%{customdata[1]}",
        textposition="inside",
        textangle=0,
        textfont_color="white",
        marker_line=attr(color="white", width=0.5),
        hovertemplate=join([
            "label: %{customdata[0]}",
            "width: %{width}",
            "height: %{y}",
            "area: %{customdata[1]}",
        ], "<br>")
    )
end
plot(
    make_trace.(keys(data)),
    Layout(
        title_text="Marimekko Chart",
        barmode="stack",
        uniformtext=attr(mode="hide", minsize=10),
        xaxis=attr(
            range=[0, 100], showgrid=true,
            tickvals=cumsum(widths) - widths / 2,
            ticktext=["$l<br>$w" for (l, w) in zip(labels, widths)],
        ),
        yaxis=attr(range=[0, 100], showgrid=true)
    )
)
```

### Customizing Individual Bar Base

```julia
using PlotlyJS

years = 2016:2018
plot([
    bar(x=years, y=500:100:700, base=[-500, -600, -700], marker_color="crimson", name="expenses")
    bar(x=years, y=[300, 400, 700], base=0, marker_color="lightslategrey", name="revenue")
])
```

### Bar Chart with Relative Barmode

With "relative" barmode, the bars are stacked on top of one another, with negative values
below the axis, positive values above.

```julia
using PlotlyJS
x = [1, 2, 3, 4]

plot([
    bar(x=x, y=[1, 4, 9, 16])
    bar(x=x, y=[6, -8, -4.5, 8])
    bar(x=x, y=[-15, -3, 4.5, -8])
    bar(x=x, y=[-1, 3, -3, -4])
], Layout(barmode="relative", title_text="Relative Barmode"))
```

### Bar Chart with Sorted or Ordered Categories

Set `categoryorder` to `"category ascending"` or `"category descending"` for the alphanumerical order of the category names or `"total ascending"` or `"total descending"` for numerical order of values. [categoryorder](https://plotly.com/julia/reference/layout/xaxis/#layout-xaxis-categoryorder) for more information. Note that sorting the bars by a particular trace isn"t possible right now - it"s only possible to sort by the total values. Of course, you can always sort your data _before_ plotting it if you need more customization.

This example orders the bar chart alphabetically with `categoryorder: "category ascending"`

```julia
using PlotlyJS

x = ["b", "a", "c", "d"]
plot([
    bar(x=x, y=[2,5,1,9], name="Montreal"),
    bar(x=x, y=[1, 4, 9, 16], name="Ottawa"),
    bar(x=x, y=[6, 8, 4.5, 8], name="Toronto"),
], Layout(barmode="stack", xaxis_categoryorder="category ascending"))
```

This example shows how to customise sort ordering by defining `categoryorder` to "array" to derive the ordering from the attribute `categoryarray`.

```julia
x = ["b", "a", "c", "d"]
plot([
    bar(x=x, y=[2,5,1,9], name="Montreal"),
    bar(x=x, y=[1, 4, 9, 16], name="Ottawa"),
    bar(x=x, y=[6, 8, 4.5, 8], name="Toronto"),
], Layout(barmode="stack", xaxis=attr(categoryorder="array", categoryarray=["d", "a", "c", "b"])))
```

This example orders the bar chart by descending value with `categoryorder: "total descending"`

```julia
using PlotlyJS

x = ["b", "a", "c", "d"]
plot([
    bar(x=x, y=[2,5,1,9], name="Montreal"),
    bar(x=x, y=[1, 4, 9, 16], name="Ottawa"),
    bar(x=x, y=[6, 8, 4.5, 8], name="Toronto"),
], Layout(barmode="stack", xaxis_categoryorder="total descending"))
```

### Horizontal Bar Charts

See examples of horizontal bar charts [here](https://plotly.com/julia/horizontal-bar-charts/).

### Bar Charts With Multicategory Axis Type

If your traces have arrays for `x` or `y`, then the axis type is automatically inferred to be `multicategory`.

```julia
using PlotlyJS
x = [
    ["BB+", "BB+", "BB+", "BB", "BB", "BB"],
    [16, 17, 18, 16, 17, 18,]
]
plot([
    bar(x=x, y=[1, 2, 3, 4, 5, 6]),
    bar(x=x, y=[6, 5, 4, 3, 2, 1]),
], Layout(barmode="relative"))
```
