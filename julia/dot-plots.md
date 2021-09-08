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
    description: How to make dot plots in Julia with Plotly.
    display_as: basic
    language: julia
    layout: base
    name: Dot Plots
    order: 6
    page_type: example_index
    permalink: julia/dot-plots/
    thumbnail: thumbnail/dot-plot.jpg
---

#### Basic Dot Plot

Dot plots (also known as [Cleveland dot plots](https://en.wikipedia.org/wiki/Dot_plot_(statistics))) are [scatter plots](https://plotly.com/julia/line-and-scatter/) with one categorical axis and one continuous axis. They can be used to show changes between two (or more) points in time or between two (or more) conditions. Compared to a [bar chart](/julia/bar-charts/), dot plots can be less cluttered and allow for an easier comparison between conditions.

For the same data, we show below how to create a dot plot using `scatter`.

```julia
using PlotlyJS, DataFrames

schools = ["Brown", "NYU", "Notre Dame", "Cornell", "Tufts", "Yale",
           "Dartmouth", "Chicago", "Columbia", "Duke", "Georgetown",
           "Princeton", "U.Penn", "Stanford", "MIT", "Harvard"]
n_schools = size(schools)[1]

women_salary = [72, 67, 73, 80, 76, 79, 84, 78, 86, 93, 94, 90, 92, 96, 94, 112]
men_salary = [92, 94, 100, 107, 112, 114, 114, 118, 119, 124, 131, 137, 141, 151, 152, 165]

df = DataFrame(
    school=vcat(repeat(schools, 2)),
    salary=vcat(men_salary, women_salary),
    gender=vcat(repeat(["Men"], n_schools), repeat(["Women"], n_schools))
)

# Use column names of df for the different parameters x, y, color, ...
plot(
    df,
    kind="scatter",
    mode="markers",
    x=:salary,
    y=:school,
    group=:gender,
    Layout(
        title="Gender Earnings Disparity",
        xaxis_title="Annual Salary (in thousands)" # customize axis label
    )
)
```

```julia
using PlotlyJS

schools = ["Brown", "NYU", "Notre Dame", "Cornell", "Tufts", "Yale",
           "Dartmouth", "Chicago", "Columbia", "Duke", "Georgetown",
           "Princeton", "U.Penn", "Stanford", "MIT", "Harvard"]

trace1 = scatter(
    x=[72, 67, 73, 80, 76, 79, 84, 78, 86, 93, 94, 90, 92, 96, 94, 112],
    y=schools,
    marker=attr(color="crimson", size=12),
    mode="markers",
    name="Women",
)

trace2 = scatter(
    x=[92, 94, 100, 107, 112, 114, 114, 118, 119, 124, 131, 137, 141, 151, 152, 165],
    y=schools,
    marker=attr(color="gold", size=12),
    mode="markers",
    name="Men"
)

layout = Layout(title="Gender Earnings Disparity",
                  xaxis_title="Annual Salary (in thousands)",
                  yaxis_title="School")

plot([trace1, trace2], layout)
```

#### Styled Categorical Dot Plot

```julia
using PlotlyJS

country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)",
           "United States (2012)", "Slovenia (2014)", "Canada (2011)",
           "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)", "Portugal (2011)"]
voting_pop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6]
reg_voters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9]


trace1 = scatter(
    x=voting_pop,
    y=country,
    mode="markers",
    name="Percent of estimated voting age population",
    marker=attr(
        line_width=1, symbol="circle", size=16,
        color="rgba(156, 165, 196, 0.95)",
        line_color="rgba(156, 165, 196, 1.0)",
    )
)
trace2 = scatter(
    x=reg_voters, y=country,
    mode="markers",
    name="Percent of estimated registered voters",
    marker=attr(
        line_width=1, symbol="circle", size=16,
        color="rgba(204, 204, 204, 0.95)",
        line_color="rgba(217, 217, 217, 1.0)"
    )
)


layout = Layout(
    title="Votes cast for ten lowest voting age population in OECD countries",
    xaxis=attr(
        showgrid=false,
        showline=true,
        linecolor="rgb(102, 102, 102)",
        tickfont_color="rgb(102, 102, 102)",
        showticklabels=true,
        dtick=10,
        ticks="outside",
        tickcolor="rgb(102, 102, 102)",
    ),
    margin=attr(l=140, r=40, b=50, t=80),
    legend=attr(
        font_size=10,
        yanchor="middle",
        xanchor="right",
    ),
    width=800,
    height=600,
    paper_bgcolor="white",
    plot_bgcolor="white",
    hovermode="closest",
)

plot([trace1, trace2], layout)
```

### Reference

See https://plotly.com/julia/reference/scatter/ for more information and chart attribute options!
